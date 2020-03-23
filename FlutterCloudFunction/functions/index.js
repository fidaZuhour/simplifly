const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

var newData;

exports.myTrigger = functions.firestore.document('vedios/description').onUpdate(async (snapshot, context) => {
    //

    if (snapshot.empty) {
        console.log('No Devices');
        return;
    }

    newData = snapshot.after.data();

    const deviceIdTokens = await admin
        .firestore()
        .collection('DeviceIDTokens')
        .get();

    var tokens = [];

    for (var token of deviceIdTokens.docs) {
        tokens.push(token.data().device_token);
    }
    var payload = {
        notification: {
            title: 'update',
            body: 'Push Body',
            sound: 'default',
        },
        data: {
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
            message: 'push message',
        },
    };

    try {
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log('Notification sent successfully');
    } catch (error) {
        console.log(error);
    }
});





//const functions = require('firebase-functions');
//const admin = require('firebase-admin');
//
//admin.initializeApp(functions.config().functions);
//
//var newData;
//
//exports.myTrigger = functions.firestore.document('vedios/{description}').onUpdate(async (snapshot, context) => {
//
//
//    if (snapshot.empty) {
//        console.log('No Devices');
//        return;
//    }
//
//    newData = snapshot.data();
//
//    const deviceIdTokens = await admin
//        .firestore()
//        .collection('DeviceIDTokens')
//        .get();
//
//    var tokens = [];
//
//    for (var token of deviceIdTokens.docs) {
//        tokens.push(token.data().device_token);
//    }
//    var payload = {
//        notification: {
//            title: 'Push Title',
//            body: 'Push Body',
//            sound: 'default',
//        },
//        data: {
//            push_key: 'Push Key Value',
//            key1: newData.data,
//        },
//    };
//
//    try {
//        const response = await admin.messaging().sendToDevice(tokens, payload);
//        console.log('Notification sent successfully');
//    } catch (err) {
//        console.log(err);
//    }
//});