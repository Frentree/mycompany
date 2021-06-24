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

exports.sendFcmNew = functions.https.onCall(async (data, context) => {
    const _tokens = data["tokens"];
    const _title = data["title"];
    const _message = data["message"];
    const _route = data["route"];
    const _alarmId = data["alarmId"];

    await admin.messaging().sendToDevice(
      _tokens,
      {
        notification: {
          title: _title,
          body: _message,
        },
        data: {
          click_action: "FLUTTER_NOTIFICATION_CLICK",
          route: _route,
          alarmId: _alarmId,
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


/* exports.sendFcm = functions.region("asia-northeast1").https.onCall(async (data, context) => {
    const _token = data["token"];
    const _team = data["team"];
    const _name = data["name"];
    const _position = data["position"];
    const _collection = data["collection"];
    const _alarmId = data["alarmId"];

    const payload = {
        data: {
        title: "",
        body: _collection,
        alarmId: _alarmId,
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
        }
    };

    const options = {
        priority: "high",
    };

    await admin.messaging().sendToDevice(_token, payload, options);
});*/