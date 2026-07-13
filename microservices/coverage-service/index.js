// index.js — API Coverage Service
// Puerto: 8080 (requerido por Azure Container Apps)
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
const tracer = trace.getTracer('coverage-service');
const meter = metrics.getMeter('coverage-service');

// Métricas custom
const coverageQueryDuration = meter.createHistogram('coverage_query.duration_ms', {
  description: 'Tiempo de respuesta de la consulta de cobertura en ms',
  unit: 'ms'
});
const coverageQueryCounter = meter.createCounter('coverage_query.count', {
  description: 'Cantidad de consultas de cobertura por resultado'
});

const express = require('express');
const app = express();
const PORT = 8080;

// Middleware
app.use(express.json());

// ─────────────────────────────────────────────
// ENDPOINT 1: Health Check
// GET /health
// ─────────────────────────────────────────────
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'UP',
    service: 'coverage-service',
    timestamp: new Date().toISOString()
  });
});

// ─────────────────────────────────────────────
// ENDPOINT 2: Consultar Cobertura por Dirección
// POST /api/v1/coverage/query
// ─────────────────────────────────────────────
app.post('/api/v1/coverage/query', (req, res) => {

  // Span custom que envuelve la lógica de negocio del endpoint.
  // Queda anidado bajo el span HTTP auto-generado por la
  // instrumentación de Express, así que hereda el mismo traceId
  // (correlación automática, sin necesitar el correlationId propio
  // para eso — igual lo seguimos usando como atributo de negocio).
  return tracer.startActiveSpan('CoverageQuery', (span) => {

    const {
      correlationId,
      address,
      requesterId
    } = req.body;

    const finishWithError = (status, code, message) => {
      span.setAttribute('coverage.validationError', code);
      if (correlationId) span.setAttribute('correlationId', correlationId);
      span.setStatus({ code: SpanStatusCode.ERROR, message: code });
      coverageQueryCounter.add(1, { result: 'validation_error', reason: code });
      span.end();
      return res.status(status).json({ error: message });
    };

    // Validaciones básicas
    if (!correlationId) {
      return finishWithError(400, 'missing_correlationId', 'El campo "correlationId" es obligatorio.');
    }

    if (!address) {
      return finishWithError(400, 'missing_address', 'El objeto "address" es obligatorio.');
    }

    const {
      street,
      number,
      neighborhood,
      city,
      coordinates
    } = address;

    if (!street || !number || !neighborhood || !city) {
      return finishWithError(400, 'incomplete_address', 'Los campos street, number, neighborhood y city son obligatorios.');
    }

    if (
        !coordinates ||
        coordinates.latitude === undefined ||
        coordinates.longitude === undefined
    ) {
      return finishWithError(400, 'missing_coordinates', 'Las coordenadas (latitude y longitude) son obligatorias.');
    }

    span.setAttribute('correlationId', correlationId);
    span.setAttribute('requesterId', requesterId || 'unknown');
    span.setAttribute('address.city', city);
    span.setAttribute('address.neighborhood', neighborhood);

    const startTime = Date.now();

    try {
      // ------------------------------------------------------------------
      // Simulación de consulta al sistema GIS / Inventario de Red
      // Posteriormente aquí se consumirá el servicio real.
      //
      // Cuando se conecte el servicio real (ej. vía HTTP/DB a un GIS),
      // la instrumentación automática de OpenTelemetry lo capturará
      // como un span hijo (dependency) dentro de este mismo span.
      // ------------------------------------------------------------------

      const response = {
        correlationId,
        coverage: {
          available: true,
          technology: "XGS-PON",
          maxSpeed: 1000,
          nodeId: "NODE-001",
          ctoId: "CTO-101",
          estimatedDistance: 87
        },
        responseTime: `${Date.now() - startTime} ms`
      };

      const elapsedMs = Date.now() - startTime;

      span.setAttribute('coverage.available', response.coverage.available);
      span.setAttribute('coverage.technology', response.coverage.technology);
      span.setAttribute('coverage.estimatedDistance', response.coverage.estimatedDistance);
      span.addEvent('CoverageQuery.Success', { elapsedMs });

      coverageQueryDuration.record(elapsedMs, { city, technology: response.coverage.technology });
      coverageQueryCounter.add(1, { result: 'success' });

      span.setStatus({ code: SpanStatusCode.OK });
      span.end();

      return res.status(200).json(response);

    } catch (err) {
      span.recordException(err);
      span.setStatus({ code: SpanStatusCode.ERROR, message: err.message });
      coverageQueryCounter.add(1, { result: 'error' });
      span.end();

      return res.status(500).json({
        correlationId,
        error: 'Error interno al consultar la cobertura.'
      });
    }
  });

});

// ─────────────────────────────────────────────
// Endpoint raíz
// ─────────────────────────────────────────────
app.get('/', (req, res) => {
  res.json({
    service: "Coverage Service",
    version: "1.0.0",
    endpoints: [
      "GET /health",
      "POST /api/v1/coverage/query"
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
  console.log(`POST http://localhost:${PORT}/api/v1/coverage/query`);
});