const express = require('express');

const app = express();

app.use(express.json());

app.post('/notify', async (req, res) => {
  try {

    const event = req.body;

    console.log('========== NOTIFICATION SERVICE ==========');
    console.log(`Correlation ID : ${event.correlationId}`);
    console.log(`Event ID       : ${event.networkEvent.eventId}`);
    console.log(`Event Type     : ${event.networkEvent.eventType}`);
    console.log(`Severity       : ${event.networkEvent.severity}`);

    console.log('[NOTIFICATION] 📲 Enviando notificaciones...');

    console.log(
        `[NOTIFICATION] Zona: ${event.networkEvent.estimatedScope.geographicArea}`
    );

    console.log(
        `[NOTIFICATION] Clientes afectados: ${event.networkEvent.estimatedScope.estimatedCustomersAffected}`
    );

    console.log(
        `[NOTIFICATION] Notificaciones enviadas correctamente para el incidente ${event.networkEvent.eventId}`
    );

    res.status(200).json({
      success: true,
      message: 'Notificaciones enviadas correctamente.'
    });

  } catch (error) {

    console.error(error);

    res.status(500).json({
      success: false,
      error: error.message
    });

  }
});

const PORT = process.env.PORT || 8080;

app.listen(PORT, () => {
  console.log(`Notification Service iniciado en puerto ${PORT}`);
});