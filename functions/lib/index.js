"use strict";
const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();
exports.checkcode = functions.https.onCall((code) => {
    var valid = false;
    const docRef = db.collection('codes').doc('joinCodes');
    const result = docRef.get().then((doc) => {
        function exists() {
            if (!doc.exists) {
                console.log('No such document!');
                return null;
            }
            var data = doc.data()["studentCodes"];
            var codeData = data[code["code"]];
            if (codeData != undefined) {
                return codeData;
            }
            data = doc.data()["teacherCodes"];
            codeData = data[code["code"]];
            if (codeData != undefined) {
                return codeData;
            }
            return null;
        }
        const instance = exists();
        if (instance != null && instance["valid"] && (instance["maxUses"] > instance["used"])) {
            valid = true;
        }
        else {
            valid = false;
        }
        return;
    });
    return (result.then(() => { console.log("Returned " + valid); return (valid); }));
});
//# sourceMappingURL=index.js.map