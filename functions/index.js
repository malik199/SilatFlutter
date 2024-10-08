/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
/*
const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require('firebase-admin');

admin.initializeApp();

exports.helloWorld = onRequest((request, response) => {
   logger.info("Hello logs!", {structuredData: true});
   response.send("Hello from Firebase!");
});

exports.updateUserData = functions.database.ref('/pending/{userId}')
    .onWrite(async (change, context) => {
        // Check for data deletion.
        if (!change.after.exists()) {
            logger.log("No data to process.");
            return null;
        }

        const beforeData = change.before.val();
        const afterData = change.after.val();

        // Check if data is unchanged.
        if (JSON.stringify(beforeData) === JSON.stringify(afterData)) {
            logger.log("Data is unchanged.");
            return null;
        }

        const userId = context.params.userId;
        const userRef = admin.database().ref(`/users/${userId}`);

        try {
            // Perform the update.
            await userRef.update(afterData);
            logger.log(`Updated user data for userId: ${userId}`);

            // Remove the pending node.
            await change.after.ref.remove();
            logger.log(`Removed pending data for userId: ${userId}`);
        } catch (error) {
            // Log any errors that occur.
            logger.error(`Error updating data for userId: ${userId}`, error);
            throw error;
        }

        return null;
    });*/

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const logger = require("firebase-functions/logger");
admin.initializeApp();

exports.receiveKeyAndTrigger = functions.https.onRequest((request, response) => {
    if (request.method !== "POST") {
        return response.status(405).send('Method Not Allowed');
    }

    const dbKey = request.body.dbKey;
    if (!dbKey) {
        return response.status(400).send('No dbKey provided');
    }

    // Assuming dbKey is the userId to update in /pending
    const pendingRef = admin.database().ref(`/pending/${dbKey}`);
logger.info("Hello logs!", {structuredData: true});
    // Here we simulate a data change that should trigger `updateUserData`
    pendingRef.update({ triggeredByHttp: true })
        .then(() => response.send(`Triggered updateUserData with dbKey: ${dbKey}`))
        .catch(error => response.status(500).send(`Error triggering updateUserData: ${error.message}`));
});