const admin = require("firebase-admin");

// Load the service account key
const serviceAccount = require("./serviceAccountKey.json");

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
admin.messaging().send({
  token: "emCVsBM3RCGihK8vLrLyAr:APA91bEsry6MO_p4oYktq0FyPYPrBGMRGMkZ56KmnX5AnBMt5pWQopV5uRliPX7Wl81GAJEQSov2b3tpEAevVQPvcf6Rn2F72j6lV6iWd6hIKRTcbp21DDg",
  data: {
    hello: "world",
  },
  // Set Android priority to "high"
  android: {
    priority: "high",
  },
  // Add APNS (Apple) config
  apns: {
    payload: {
      aps: {
        contentAvailable: true,
      },
    },
    headers: {
      "apns-push-type": "background",
      "apns-priority": "5", // Must be `5` when `contentAvailable` is set to true.
      "apns-topic": "io.flutter.plugins.firebase.messaging", // bundle identifier
    },
  },
});