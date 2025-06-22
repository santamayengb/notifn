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
        "dbSr8sKbRFipVaY5Illa4X:APA91bEshf8SVeHPLf_HwT9gmMqyaJaprSzFFwfP0eYl3LA50mDYolFs5yR4Zfib5fuDaT6M9pfgUEvze4ZnBriXjAEHohp1rPjvmsfSrK6eRpBegDmJfHI",
      ], // 🔁 Replace with real FCM tokens
      notification: {
        title: "Weather Warning!",
        body: "A new weather warning has been issued for your location.",
        imageUrl: "https://my-cdn.com/extreme-weather.png",
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
