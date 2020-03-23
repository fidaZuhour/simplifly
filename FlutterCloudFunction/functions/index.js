const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

var newData;
var privousData;

exports.myTrigger = functions.firestore.document('vedios/{description}').onUpdate(async (snapshot, context) => {

    if (snapshot.empty) {
        console.log('No Devices');
        return;
    }
    newData = snapshot.after.data();
    privousData = snapshot.before.data();

    const description = newData.description;
    const pre = privousData.description;
   //No Update on Description
    if (description === pre )return null;

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
            title: 'There is an update on the description of a video',
            body: "the previous description :"+ pre+" the new description : " + description,
            sound: 'default',
        },
        data: {
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
            message: 'Update message',
        },
    };

    try {
    console.log('Notification sent successfully');
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log('Notification sent successfully');
    } catch (error) {
        console.log(error);
    }
});
