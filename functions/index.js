const functions = require('firebase-functions');
const admin = require('firebase-admin');
const logger = require("firebase-functions/logger");
admin.initializeApp();

exports.transferUserData = functions.https.onRequest((req, res) => {
    // Check for POST request and dbkey parameter
    if (req.method !== 'POST') {
        return res.status(403).send('Forbidden! Only POST method is allowed.');
    }

    const dbKey = req.body.data.dbKey;
    if (!dbKey) {
        return res.status(400).send('The dbKey parameter is required.');
    }

    const db = admin.database();
    const pendingRef = db.ref(`pending/${dbKey}`);
    const usersRef = db.ref(`users/${dbKey}`);

    // First, get the data from the pending node
    pendingRef.once('value', snapshot => {
        if (snapshot.exists()) {
            const userData = snapshot.val();

            // First Transaction: Update the users node
            usersRef.set(userData).then(() => {
                // Second Transaction: Delete the pending node
                return pendingRef.remove()
                    .then(() => res.send('Transfer successful from pending to users.'))
                    .catch(error => {
                        logger.error('Error deleting data from pending:', error);
                        res.status(500).send(`Error deleting data from pending: ${error.message}`);
                    });
            }).catch(error => {
                logger.error('Error updating data to users:', error);
                res.status(500).send(`Error updating data to users: ${error.message}`);
            });
        } else {
            res.status(404).send('No data found for provided dbKey in pending.');
        }
    }, error => {
        logger.error('Error accessing data from pending:', error);
        res.status(500).send(`Error accessing data: ${error.message}`);
    });
});

exports.deleteFirebaseUser = functions.https.onCall((data, context) => {
  // Check if the request is made by an authenticated user
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated.');
  }

  const uid = data.uid;

  return admin.auth().deleteUser(uid)
    .then(() => {
      console.log('Successfully deleted user', uid);
      return { status: 'success', message: 'User deleted' };
    })
    .catch((error) => {
      console.log('Error deleting user:', error);
      throw new functions.https.HttpsError('unknown', error.message, error);
    });
});

