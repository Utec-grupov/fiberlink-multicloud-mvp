const functions = require('@google-cloud/functions-framework');
const axios = require('axios');

functions.cloudEvent('processNetworkEvent', async (cloudEvent) => {
  try {
    // Decodificar el mensaje recibido desde Pub/Sub
    const data = Buffer.from(
        cloudEvent.data.message.data,
        'base64'
    ).toString('utf8');

    const event = JSON.parse(data);

    console.log('===== NETWORK EVENT RECEIVED =====');
    console.log(`Correlation ID : ${event.correlationId}`);
    console.log(`Event ID       : ${event.networkEvent.eventId}`);
    console.log(`Event Type     : ${event.networkEvent.eventType}`);
    console.log(`Severity       : ${event.networkEvent.severity}`);
    console.log(`Reported By    : ${event.networkEvent.reportedBy}`);
    console.log(`Timestamp      : ${event.networkEvent.eventTimestamp}`);
    console.log(`Source System  : ${event.sourceSystem}`);

    console.log('Affected Infrastructure:');
    console.log(`Nodes          : ${event.networkEvent.affectedInfrastructure.nodeIds.join(', ')}`);
    console.log(`CTOs           : ${event.networkEvent.affectedInfrastructure.ctoIds.join(', ')}`);
    console.log(`Fiber Segments : ${event.networkEvent.affectedInfrastructure.fiberSegmentIds.join(', ')}`);
    console.log(`OLTs           : ${event.networkEvent.affectedInfrastructure.oltIds.join(', ')}`);

    console.log('Estimated Scope:');
    console.log(`Area           : ${event.networkEvent.estimatedScope.geographicArea}`);
    console.log(`Customers      : ${event.networkEvent.estimatedScope.estimatedCustomersAffected}`);

    //logica
    // Llamar al Notification Service
    const response = await axios.post(
        'https://notification-dispatch-949052388233.us-central1.run.app/notify',
        event,
        {
          headers: {
            'Content-Type': 'application/json'
          }
        }
    );

    console.log(`Notification Service respondió con HTTP ${response.status}`);
    console.log('Evento enviado correctamente al Notification Service.');

  } catch (error) {
    console.error('Error procesando el evento de red:', error);

    if (error.response) {
      console.error('Respuesta del Notification Service:', error.response.data);
    }

    throw error;
  }
});