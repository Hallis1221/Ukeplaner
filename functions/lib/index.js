"use strict";
const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();
exports.checkcode = functions.https.onCall((argumentData) => {
    var valid = false;
    var type;
    const docRef = db.collection('codes').doc('joinCodes');
    const result = docRef.get().then((doc) => {
        function exists() {
            if (!doc.exists) {
                console.log('No such document!');
                return null;
            }
            var data = doc.data()["studentCodes"];
            var codeData = data[argumentData["code"]];
            if (codeData != undefined) {
                type = "student";
                return codeData;
            }
            data = doc.data()["teacherCodes"];
            codeData = data[argumentData["code"]];
            if (codeData != undefined) {
                type = "teacher";
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
        console.log(argumentData["useLog"] == true);
        if (argumentData["useLog"] == true && valid) {
            var key = argumentData["code"];
            var codesList = {};
            var list = { "used": instance["used"] + 1, "maxUses": 3, "valid": true };
            if (type == "student") {
                console.log(type);
                codesList["studentCodes"] = {};
                codesList["studentCodes"][key] = list;
            }
            else {
                console.log(type);
                codesList["teacherCodes"] = {};
                codesList["teacherCodes"][key] = list;
            }
            docRef.update(codesList);
        }
        return;
    });
    return (result.then(() => {
        console.log("Returned " + valid);
        return valid;
    }));
});
//# sourceMappingURL=index.js.map