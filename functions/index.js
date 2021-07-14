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
exports.autoCreateAttendanceDb = functions.region('asia-northeast3').pubsub.schedule('0 4 * * 1-5').timeZone('Asia/Seoul').onRun(async (context) => {
    var db = admin.firestore();
    var today = new Date()
    today.setHours(today.getHours() + 9);
    var year = today.getFullYear(); // 년도
    var month = today.getMonth();  // 월
    var date = today.getDate();  // 날짜
    var createDate = new Date(year, month, date);
    createDate.setHours(createDate.getHours() - 9);

    await db.collection("company").get().then(companySnapshot => {
        companySnapshot.forEach(async companyDoc => {
            await companyDoc.ref.collection("user").get().then(userSnapshot =>{
                userSnapshot.forEach(async userDoc => {
                    var result = await companyDoc.ref.collection("attendance").where("mail", "==", userDoc.data().mail).where("createDate", "==", createDate).get();
                    if(result.empty){
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


//자동 퇴근 처리(18:30)
exports.autoOffWorkCheck1 = functions.region('asia-northeast3').pubsub.schedule('30 18 * * *').timeZone('Asia/Seoul').onRun(async (context) => {
   var db = admin.firestore();
   var today = new Date()
   var year = today.getFullYear(); // 년도
   var month = today.getMonth();  // 월
   var date = today.getDate();  // 날짜
   var createDate = new Date(year, month, date);
   var offWorkTime = new Date(year, month, date, 9, 30);
   var setOffWorkTime = new Date(year, month, date, 9);

   createDate.setHours(createDate.getHours() - 9);

   await db.collection("company").get().then(companySnapshot => {
       companySnapshot.forEach(async companyDoc => {
           await companyDoc.ref.collection("user").get().then(userSnapshot =>{
               userSnapshot.forEach(async userDoc => {
                   var result = await companyDoc.ref.collection("attendance").where("mail", "==", userDoc.data().mail).where("createDate", "==", createDate).get();
                   if(!result.empty){
                       result.forEach(async attendanceDoc => {
                           if(attendanceDoc.data().attendTime != null){
                                if(attendanceDoc.data().overTime == 0 || attendanceDoc.data().overTime == null){
                                    if(attendanceDoc.data().endTime == null || attendanceDoc.data().endTime.toDate().getTime() > offWorkTime.getTime()) {
                                        await attendanceDoc.ref.update({
                                            endTime: setOffWorkTime,
                                        })
                                    }
                               }
                           }
                       });
                   }
               });
           });
       });
   });
});

//자동 퇴근 처리(12:30)
exports.autoOffWorkCheck2 = functions.region('asia-northeast3').pubsub.schedule('30 00 * * *').timeZone('Asia/Seoul').onRun(async (context) => {
   var db = admin.firestore();
   var today = new Date()
   var year = today.getFullYear(); // 년도
   var month = today.getMonth();  // 월
   var date = today.getDate();  // 날짜
   var createDate = new Date(year, month, date);
   var offWorkTime = new Date(year, month, date, 9, 30);
   var setOffWorkTime = new Date(year, month, date, 9);

   createDate.setHours(createDate.getHours() - 9);

   await db.collection("company").get().then(companySnapshot => {
       companySnapshot.forEach(async companyDoc => {
           await companyDoc.ref.collection("user").get().then(userSnapshot =>{
               userSnapshot.forEach(async userDoc => {
                   var result = await companyDoc.ref.collection("attendance").where("mail", "==", userDoc.data().mail).where("createDate", "==", createDate).get();
                   if(!result.empty){
                       result.forEach(async attendanceDoc => {
                           if(attendanceDoc.data().attendTime != null){
                                if(attendanceDoc.data().overTime == 0 || attendanceDoc.data().overTime == null){
                                    if(attendanceDoc.data().endTime == null || attendanceDoc.data().endTime.toDate().getTime() > offWorkTime.getTime()) {
                                        await attendanceDoc.ref.update({
                                            endTime: setOffWorkTime,
                                            autoOffWork: 2,
                                        })
                                    }
                               }
                               else{
                                    let tempTime = new Date(year, month, date, 9, 30);
                                    tempTime.setHours(tempTime.getHours() + attendanceDoc.data().overTime);
                                    if(attendanceDoc.data().autoOffWork == 2){
                                        tempTime.setMinutes(tempTime.getMinutes() - 30);
                                        if(attendanceDoc.data().endTime.toDate().getTime() < tempTime.getTime()){
                                            await attendanceDoc.ref.update({
                                                endTime: tempTime,
                                                autoOffWork: 2,
                                            })
                                        }
                                    }
                                    if(attendanceDoc.data().endTime == null || attendanceDoc.data().endTime.toDate().getTime() > tempTime.getTime()) {
                                        tempTime.setMinutes(tempTime.getMinutes() - 30);
                                        await attendanceDoc.ref.update({
                                            endTime: tempTime,
                                            autoOffWork: 2,
                                        })
                                    }
                               }
                           }
                       });
                   }
               });
           });
       });
   });
});
