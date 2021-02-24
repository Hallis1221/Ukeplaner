const functions = require("firebase-functions");

exports.listFruit = functions.https.onCall((_code: number
) => {
    return _code;
});
