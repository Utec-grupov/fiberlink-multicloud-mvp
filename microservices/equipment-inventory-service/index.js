// index.js — API Network Topology Service
// Puerto: 8080 (requerido por Azure Container Apps)

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
    service: 'network-topology-service',
    timestamp: new Date().toISOString()
  });
});

// ─────────────────────────────────────────────
// ENDPOINT 2: Consultar Topología de Red
// POST /api/v1/network-topology/query
// ─────────────────────────────────────────────
app.post('/api/v1/network-topology/query', (req, res) => {

  const {
    correlationId,
    topologyRequest,
    requesterId
  } = req.body;

  // Validaciones básicas
  if (!correlationId) {
    return res.status(400).json({
      error: 'El campo "correlationId" es obligatorio.'
    });
  }

  if (!topologyRequest) {
    return res.status(400).json({
      error: 'El objeto "topologyRequest" es obligatorio.'
    });
  }

  const {
    resourceType,
    resourceId,
    includeParents = true,
    includeChildren = true,
    includeAttributes = true,
    maxDepth = 5
  } = topologyRequest;

  if (!resourceType || !resourceId) {
    return res.status(400).json({
      error: 'Los campos "resourceType" y "resourceId" son obligatorios.'
    });
  }

  // ------------------------------------------------------------------
  // Simulación de consulta a Oracle UIM
  // Aquí posteriormente se llamará al API real del inventario Oracle.
  // ------------------------------------------------------------------

  const response = {
    correlationId,
    networkTopology: {
      resource: {
        id: resourceId,
        type: resourceType,
        name: "Nodo Lima Sur",
        status: "ACTIVE",
        location: "Lima"
      },
      parents: includeParents
          ? [
            {
              id: "OLT-001",
              type: "OLT",
              name: "OLT Chorrillos",
              status: "ACTIVE"
            }
          ]
          : [],
      children: includeChildren
          ? [
            {
              id: "CTO-101",
              type: "CTO",
              status: "ACTIVE"
            },
            {
              id: "CTO-102",
              type: "CTO",
              status: "ACTIVE"
            }
          ]
          : [],
      relationships: [
        {
          source: "OLT-001",
          target: resourceId,
          relationshipType: "CONNECTED_TO"
        },
        {
          source: resourceId,
          target: "CTO-101",
          relationshipType: "SERVES"
        },
        {
          source: resourceId,
          target: "CTO-102",
          relationshipType: "SERVES"
        }
      ],
      metadata: {
        generatedAt: new Date().toISOString(),
        source: "Oracle Inventory (Mock)",
        requesterId,
        includeAttributes,
        maxDepth
      }
    }
  };

  return res.status(200).json(response);

});

// ─────────────────────────────────────────────
// Endpoint opcional para verificar disponibilidad
// ─────────────────────────────────────────────
app.get('/', (req, res) => {
  res.json({
    service: "Network Topology Service",
    version: "1.0.0",
    endpoints: [
      "GET /health",
      "POST /api/v1/network-topology/query"
    ]
  });
});

// ─────────────────────────────────────────────
// Iniciar servidor
// ─────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`Servidor iniciado en puerto ${PORT}`);
  console.log(`GET  http://localhost:${PORT}/health`);
  console.log(`POST http://localhost:${PORT}/api/v1/network-topology/query`);
});