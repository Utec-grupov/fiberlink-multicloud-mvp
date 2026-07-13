// index.js — API Capacity Validation Service
// Puerto: 8080 (requerido por Azure Container Apps)
//
// Los datos de capacidad se consultan desde dbo.capacity_validation
// en SQL Server. Las credenciales de conexión se obtienen de Azure Key Vault
// (ver db.js) usando la Managed Identity del Container App.
//
// IMPORTANTE: useAzureMonitor() debe llamarse ANTES de requerir
// express (o cualquier otro módulo que se quiera auto-instrumentar),
// para que las auto-instrumentaciones de OpenTelemetry (http, express)
// puedan "engancharse" a esos módulos correctamente.

const { useAzureMonitor } = require('@azure/monitor-opentelemetry');
const { trace, metrics, SpanStatusCode } = require('@opentelemetry/api');

const otelEnabled = !!process.env.APPLICATIONINSIGHTS_CONNECTION_STRING;

if (otelEnabled) {
  useAzureMonitor({
    azureMonitorExporterOptions: {
      connectionString: process.env.APPLICATIONINSIGHTS_CONNECTION_STRING
    }
  });
  console.log('Azure Monitor OpenTelemetry inicializado.');
} else {
  console.warn('APPLICATIONINSIGHTS_CONNECTION_STRING no definida. Telemetría deshabilitada.');
}

// Tracer y meter para telemetría personalizada (spans, eventos, métricas)
const tracer = trace.getTracer('capacity-validation-service');
const meter = metrics.getMeter('capacity-validation-service');

// Métricas custom
const capacityValidateDuration = meter.createHistogram('capacity_validate.duration_ms', {
  description: 'Tiempo de respuesta de la validación de capacidad en ms',
  unit: 'ms'
});
const capacityValidateCounter = meter.createCounter('capacity_validate.count', {
  description: 'Cantidad de validaciones de capacidad por resultado'
});
const portReservationDuration = meter.createHistogram('port_reservation.duration_ms', {
  description: 'Tiempo de respuesta de la reserva de puerto en ms',
  unit: 'ms'
});
const portReservationCounter = meter.createCounter('port_reservation.count', {
  description: 'Cantidad de reservas de puerto por resultado'
});

const express = require('express');
const crypto = require('crypto');
const { getPool, sql } = require('./db');

const app = express();
const PORT = 8080;

app.use(express.json());

// ─────────────────────────────────────────────
// ENDPOINT 1: Health Check
// GET /health
// ─────────────────────────────────────────────
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'UP',
    service: 'capacity-validation-service',
    timestamp: new Date().toISOString()
  });
});

// ─────────────────────────────────────────────
// ENDPOINT 2: Validar Capacidad Técnica
// POST /api/v1/capacity/validate
// ─────────────────────────────────────────────
app.post('/api/v1/capacity/validate', (req, res) => {
  // Span custom que envuelve la lógica de negocio del endpoint.
  // Queda anidado bajo el span HTTP auto-generado por la
  // instrumentación de Express, así que hereda el mismo traceId
  // (correlación automática, sin necesitar el correlationId propio
  // para eso — igual lo seguimos usando como atributo de negocio).
  return tracer.startActiveSpan('CapacityValidate', async (span) => {
    const startTime = Date.now();
    const { correlationId, nodeId, ctoId, serviceType, bandwidthRequired, requesterId } = req.body;

    const finishWithError = (status, code, message) => {
      span.setAttribute('capacity.validationError', code);
      if (correlationId) span.setAttribute('correlationId', correlationId);
      span.setStatus({ code: SpanStatusCode.ERROR, message: code });
      capacityValidateCounter.add(1, { result: 'validation_error', reason: code });
      span.end();
      return res.status(status).json({ error: message });
    };

    // Validaciones básicas
    if (!correlationId) {
      return finishWithError(400, 'missing_correlationId', 'El campo "correlationId" es obligatorio.');
    }
    if (!nodeId || !ctoId || !serviceType || bandwidthRequired === undefined) {
      return finishWithError(
          400,
          'missing_required_fields',
          'Los campos nodeId, ctoId, serviceType y bandwidthRequired son obligatorios.'
      );
    }

    span.setAttribute('correlationId', correlationId);
    span.setAttribute('requesterId', requesterId || 'unknown');
    span.setAttribute('capacity.nodeId', nodeId);
    span.setAttribute('capacity.ctoId', ctoId);
    span.setAttribute('capacity.serviceType', serviceType);
    span.setAttribute('capacity.bandwidthRequired', bandwidthRequired);

    try {
      const pool = await getPool();
      const result = await pool.request()
          .input('nodeId', sql.VarChar, nodeId)
          .input('ctoId', sql.VarChar, ctoId)
          .query(`
          SELECT TOP 1
            node_id, cto_id, max_capacity_mbps, current_load_mbps,
            total_ports, available_ports, technology, status
          FROM dbo.capacity_validation
          WHERE node_id = @nodeId AND cto_id = @ctoId AND status = 'ACTIVE'
        `);

      const row = result.recordset[0];

      if (!row) {
        span.setAttribute('capacity.recordFound', false);
        span.addEvent('CapacityValidate.RecordNotFound');
        span.setStatus({ code: SpanStatusCode.ERROR, message: 'record_not_found' });
        capacityValidateCounter.add(1, { result: 'not_found' });
        span.end();
        return res.status(404).json({
          correlationId,
          error: `No se encontró un registro ACTIVE para nodeId="${nodeId}" y ctoId="${ctoId}".`
        });
      }

      const availableCapacity = row.max_capacity_mbps - row.current_load_mbps;
      const currentLoadPct = Math.round((row.current_load_mbps / row.max_capacity_mbps) * 100);

      // Genera hasta 2 puertos recomendados en función de available_ports.
      // No existe una tabla de puertos individual en el esquema actual;
      // si se agrega (p.ej. dbo.ports con splitter_id / signal_quality),
      // este bloque puede reemplazarse por una consulta real.
      const recommendedPorts = [];
      const portsToRecommend = Math.min(row.available_ports, 2);
      for (let i = 0; i < portsToRecommend; i++) {
        recommendedPorts.push({
          portId: `PORT-${String(i + 1).padStart(3, '0')}`,
          splitterId: 'SPLITTER-01',
          signalQuality: i === 0 ? 'EXCELLENT' : 'GOOD'
        });
      }

      const isAvailable = bandwidthRequired <= availableCapacity && row.available_ports > 0;

      const response = {
        correlationId,
        capacity: {
          available: isAvailable,
          node: {
            id: row.node_id,
            currentLoad: currentLoadPct,
            maxCapacity: row.max_capacity_mbps,
            availableCapacity
          },
          cto: {
            id: row.cto_id,
            availablePorts: row.available_ports,
            totalPorts: row.total_ports,
            technology: row.technology
          },
          recommendedPorts
        },
        responseTime: `${Date.now() - startTime} ms`
      };

      const elapsedMs = Date.now() - startTime;
      span.setAttribute('capacity.recordFound', true);
      span.setAttribute('capacity.available', isAvailable);
      span.setAttribute('capacity.currentLoadPct', currentLoadPct);
      span.setAttribute('capacity.technology', row.technology);
      span.addEvent('CapacityValidate.Success', { elapsedMs });

      capacityValidateDuration.record(elapsedMs, {
        technology: row.technology,
        available: String(isAvailable)
      });
      capacityValidateCounter.add(1, { result: 'success' });
      span.setStatus({ code: SpanStatusCode.OK });
      span.end();

      return res.status(200).json(response);
    } catch (err) {
      span.recordException(err);
      span.setStatus({ code: SpanStatusCode.ERROR, message: err.message });
      capacityValidateCounter.add(1, { result: 'error' });
      span.end();

      console.error('Error en /api/v1/capacity/validate:', err);
      return res.status(503).json({
        correlationId,
        error: 'No fue posible consultar la base de datos de capacidad.'
      });
    }
  });
});

// ─────────────────────────────────────────────
// ENDPOINT 3: Reservar Puerto Temporal
// POST /api/v1/port-reservations
// ─────────────────────────────────────────────
app.post('/api/v1/port-reservations', (req, res) => {
  return tracer.startActiveSpan('PortReservation', (span) => {
    const startTime = Date.now();
    const { correlationId, portId, orderId, customerId, reservationDuration, requesterId } = req.body;

    const finishWithError = (status, code, message) => {
      span.setAttribute('reservation.validationError', code);
      if (correlationId) span.setAttribute('correlationId', correlationId);
      span.setStatus({ code: SpanStatusCode.ERROR, message: code });
      portReservationCounter.add(1, { result: 'validation_error', reason: code });
      span.end();
      return res.status(status).json({ error: message });
    };

    if (!correlationId) {
      return finishWithError(400, 'missing_correlationId', 'El campo "correlationId" es obligatorio.');
    }
    if (!portId || !orderId || !customerId || reservationDuration === undefined) {
      return finishWithError(
          400,
          'missing_required_fields',
          'Los campos portId, orderId, customerId y reservationDuration son obligatorios.'
      );
    }

    span.setAttribute('correlationId', correlationId);
    span.setAttribute('requesterId', requesterId || 'unknown');
    span.setAttribute('reservation.portId', portId);
    span.setAttribute('reservation.orderId', orderId);
    span.setAttribute('reservation.customerId', customerId);
    span.setAttribute('reservation.durationHours', reservationDuration);

    // -------------------------------------------------------
    // Simulación de reserva de puerto
    // -------------------------------------------------------
    const expiresAt = new Date(Date.now() + reservationDuration * 60 * 60 * 1000);
    const reservationId = crypto.randomUUID();

    const response = {
      correlationId,
      reservation: {
        reservationId,
        portId,
        status: 'RESERVED',
        expiresAt: expiresAt.toISOString(),
        orderId
      }
    };

    const elapsedMs = Date.now() - startTime;
    span.setAttribute('reservation.id', reservationId);
    span.setAttribute('reservation.status', 'RESERVED');
    span.addEvent('PortReservation.Success', { elapsedMs });

    portReservationDuration.record(elapsedMs, { status: 'RESERVED' });
    portReservationCounter.add(1, { result: 'success' });
    span.setStatus({ code: SpanStatusCode.OK });
    span.end();

    return res.status(200).json(response);
  });
});

// ─────────────────────────────────────────────
// Endpoint raíz
// ─────────────────────────────────────────────
app.get('/', (req, res) => {
  res.json({
    service: 'Capacity Validation Service',
    version: '1.2.0',
    endpoints: [
      'GET /health',
      'POST /api/v1/capacity/validate',
      'POST /api/v1/port-reservations'
    ]
  });
});

// ─────────────────────────────────────────────
// Manejador global de errores no capturados
// ─────────────────────────────────────────────
app.use((err, req, res, next) => {
  const span = trace.getActiveSpan();
  if (span) {
    span.recordException(err);
    span.setStatus({ code: SpanStatusCode.ERROR, message: err.message });
  }
  res.status(500).json({ error: 'Error interno del servidor.' });
});

// ─────────────────────────────────────────────
// Iniciar servidor
// ─────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`Servidor iniciado en puerto ${PORT}`);
  console.log(`GET  http://localhost:${PORT}/health`);
  console.log(`POST http://localhost:${PORT}/api/v1/capacity/validate`);
  console.log(`POST http://localhost:${PORT}/api/v1/port-reservations`);
});