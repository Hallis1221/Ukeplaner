"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendLekse = void 0;
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();
// const fcm = admin.messaging();
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
        if (argumentData["useLog"] == true && valid) {
            var key = argumentData["code"];
            var codesList = {};
            var list = { "used": parseInt(instance["used"]) + 1, "maxUses": instance["maxUses"], "valid": instance["valid"] };
            if (type == "student") {
                codesList["studentCodes"] = {};
                codesList["studentCodes"][key] = list;
            }
            else {
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
exports.sendLekse = functions.firestore.document("classes/{classId}/classes/{classTime}").
    onWrite(async (snapshot, context) => {
    var parent = snapshot.data.ref.parent;
    console.log("parent is now " + parent);
});
//# sourceMappingURL=index.js.map