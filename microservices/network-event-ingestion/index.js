const express = require('express');
const { PubSub } = require('@google-cloud/pubsub');
const crypto = require('crypto');

const app = express();
const pubsub = new PubSub();

// Reemplazar por el nombre real del tópico
const TOPIC_NAME = 'flk-dev-integration-topic';

/**
 * Genera un evento de red mock
 */
function buildMockNetworkEvent() {
  return {
    correlationId: crypto.randomUUID(),
    networkEvent: {
      eventId: crypto.randomUUID(),
      eventType: "FIBER_CUT",
      severity: "CRITICAL",
      affectedInfrastructure: {
        nodeIds: [
          "NODE-001",
          "NODE-002"
        ],
        ctoIds: [
          "CTO-1001",
          "CTO-1002"
        ],
        fiberSegmentIds: [
          "FIBER-SEG-001"
        ],
        oltIds: [
          "OLT-LIMA-01"
        ]
      },
      eventTimestamp: new Date().toISOString(),
      reportedBy: "NMS",
      estimatedScope: {
        geographicArea: "Lima - San Isidro",
        estimatedCustomersAffected: 1250
      }
    },
    sourceSystem: "NETWORK_EVENT_INGESTION"
  };
}

/**
 * Publica un evento mock en Pub/Sub
 */
app.post('/publish', async (req, res) => {
  try {
    const event = buildMockNetworkEvent();

    const data = Buffer.from(JSON.stringify(event));

    const messageId = await pubsub
        .topic(TOPIC_NAME)
        .publishMessage({ data });

    res.status(200).json({
      success: true,
      messageId,
      event
    });

  } catch (error) {
    console.error(error);

    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

app.listen(8080, () => {
  console.log("🚀 Network Event Publisher ejecutándose en puerto 8080");
});