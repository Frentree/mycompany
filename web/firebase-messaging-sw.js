importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyCpYEm0Fw-vS9Snw15H2wURfk4yXnVhh0o",
  authDomain: "app-dev-c912f.firebaseapp.com",
  databaseURL: "https://app-dev-c912f.firebaseio.com",
  projectId: "app-dev-c912f",
  storageBucket: "app-dev-c912f.appspot.com",
  messagingSenderId: "35952526312",
  appId: "1:35952526312:web:fa2ce7262eab34fc601a5d",
  measurementId: "G-TK6XD2YV12",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});