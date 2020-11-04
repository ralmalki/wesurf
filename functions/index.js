const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.sendNotification = functions.database  
            .ref('/notification/{topicId}/messages/{messageId}')
            .onCreate((snapshot, context) => {


    const topicId  = context.params.topicId;
    const messageId = context.params.messageId;
    const summaryLabel = topicId +"-" + messageId; 
    const receivedOn = Date.now();

    const payload = {

        data: {
            topicId: topicId,
            messageId: messageId,
            time: receivedOn
        },

        notification: {
            title: "Notification Title",
            body: summaryLabel,
            icon: '/img/blue_map_icon.png',
            click_action: `https://${process.env.GCLOUD_PROJECT}.firebaseapp.com`,
            sound: "default"
        }
    };

    const options = {
        priority: "high",
        timeToLive: 60 * 60 * 2
    }; 

    return admin.messaging().sendToTopic(topicId, payload, options);


});