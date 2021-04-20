import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();
// const fcm = admin.messaging();

exports.checkcode = functions.https.onCall((argumentData: any,
) => {// THIS IS A MAP; DO NOT FORGET
    var valid: Boolean = false;
    var type: String;
    const docRef = db.collection('codes').doc('joinCodes');
    const result = docRef.get().then((doc: any) => {
        function exists() {
            if (!doc.exists) {
                console.log('No such document!');
                return null;
            }
            var data: any = doc.data()["studentCodes"];
            var codeData: any = data[argumentData["code"]];
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

        const instance: any = exists();
        if (instance != null && instance["valid"] && (instance["maxUses"] > instance["used"])) {
            valid = true;
        } else {
            valid = false;
        }

        if (argumentData["useLog"] == true && valid) {
            var key: any = argumentData["code"];

            var codesList: any = {};

            var list: any = { "used": parseInt(instance["used"]) + 1, "maxUses": instance["maxUses"], "valid": instance["valid"] };

            if (type == "student") {

                codesList["studentCodes"] = {};
                codesList["studentCodes"][key] = list;
            } else {

                codesList["teacherCodes"] = {};
                codesList["teacherCodes"][key] = list;
            }

            docRef.update(codesList)
        }

        return;
    })
    return (result.then(() => {
        console.log("Returned " + valid); return valid;
    },));
});

export const sendLekse = functions.firestore.document("classes/{classId}/classes/{classTime}").
    onWrite(async (snapshot: any, context: any,) => {
        var parent = snapshot.data.ref.parent;
        console.log("parent is now " + parent);
    
    });

