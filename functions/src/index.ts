const functions = require("firebase-functions");

const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();

exports.checkcode = functions.https.onCall((code: any, log: boolean = false,
) => {
    var valid: Boolean = false;
    const docRef = db.collection('codes').doc('joinCodes');
    const result = docRef.get().then((doc: any) => {
        function exists() {
            if (!doc.exists) {
                console.log('No such document!');
                return null;
            }
            var data: any = doc.data()["studentCodes"];
            var codeData: any = data[code["code"]];
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

        const instance: any = exists();
        if (instance != null && instance["valid"] && (instance["maxUses"] > instance["used"])) {
            valid = true;
        } else {
            valid = false;
        }
        try {

            if (log) {
                docRef.update({ studentCodes: { code: { used: instance["used"] } } });
            }

        } catch (error) {
            valid = false;
        }
        return;
    })
    return (result.then(() => { console.log("Returned " + valid); return (valid); }));
});
