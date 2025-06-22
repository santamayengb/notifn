const admin = require("firebase-admin");

// Load the service account key
const serviceAccount = require("./serviceAccountKey.json");

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

async function sendNotification() {
  try {
    const response = await admin.messaging().sendEachForMulticast({
      tokens: [
        "emCVsBM3RCGihK8vLrLyAr:APA91bEsry6MO_p4oYktq0FyPYPrBGMRGMkZ56KmnX5AnBMt5pWQopV5uRliPX7Wl81GAJEQSov2b3tpEAevVQPvcf6Rn2F72j6lV6iWd6hIKRTcbp21DDg",
      ], // 🔁 Replace with real FCM tokens
      data: {
        title: "Weather Warning!",
        imageUrl: "https://my-cdn.com/extreme-weather.png", // Fixed URL
        body: "A new weather warning has been issued for your location.",
      },
      android: {
        priority: "high",
      },
      apns: {
        headers: {
          "apns-push-type": "background",
          "apns-priority": "5", // Must be `5` when `contentAvailable` is set to true.
          "apns-topic": "io.flutter.plugins.firebase.messaging", // bundle identifier
        },
      },
    });

    console.log(`✅ Successfully sent ${response.successCount} messages`);
    if (response.failureCount > 0) {
      response.responses.forEach((r, i) => {
        if (!r.success) {
          console.log(`❌ Failed to send to token ${i}:`, r.error.message);
        }
      });
    }
  } catch (error) {
    console.error("🔥 Error sending notifications:", error);
  }
}

// Call the function
sendNotification();
