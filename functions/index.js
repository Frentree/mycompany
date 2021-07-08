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

//출근 데이터 자동 생성
exports.autoCreateAttendanceDb = functions.pubsub.schedule('42 18 * * 1-5').timeZone('Asia/Seoul').onRun(async (context) => {
    var db = admin.firestore();
    var today = new Date();
    var utc = today.getTime() + (today.getTimezoneOffset() * 60 * 1000);
    var KR_TIME_DIFF = 9 * 60 * 60 * 1000;
    var kr_today = new Date(utc + (KR_TIME_DIFF));
    var year = kr_today.getFullYear(); // 년도
    var month = kr_today.getMonth();  // 월
    var date = kr_today.getDate() - 1;  // 날짜
    var createDate = new Date(year, month, date, 00);

    await db.collection("company").get().then(companySnapshot => {
        companySnapshot.forEach(async companyDoc => {
            await companyDoc.ref.collection("user").get().then(userSnapshot =>{
                userSnapshot.forEach(async userDoc => {
                    var result = await companyDoc.ref.collection("attendance").where("mail", "==", userDoc.data().mail).where("createDate", "==", createDate).get();
                    if(result == null){
                        console.log('result =====> ', result);
                        await companyDoc.ref.collection("attendance").add(
                            {
                                mail: userDoc.data().mail,
                                name: userDoc.data().name,
                                createDate: createDate,
                                overTime: 0,
                                autoOffWork: 0,
                                status: 0,
                            }
                        );
                    }

                });
            });
        });
    });
});


//자동 퇴근 처리
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