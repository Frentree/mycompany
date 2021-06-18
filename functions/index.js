/* eslint no-undef: "off" */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

exports.sendFcm = functions.https.onCall(async (data, context) => {
    const _tokens = data["tokens"];
    const _title = data["title"];
    const _message = data["message"];
    const _alarmId = data["alarmId"];
    const _route = data["route"];

    await admin.messaging().sendToDevice(
      _tokens,
      {
        notification: {
          title: _title,
          body: _message,
          alarmId: _alarmId,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
        data: {
          route: _route,
        }
      },
      {
        // Required for background/quit data-only messages on iOS
        contentAvailable: true,
        // Required for background/quit data-only messages on Android
        priority: "high",
      }
    );
});
