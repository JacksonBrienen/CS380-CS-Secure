const fs = require('node:fs');
const jwt = require('jsonwebtoken');


// read key
const JWT_SECRET_KEY = fs.readFileSync('../jwt.key');

exports.generateJWT = function generateJWT(cred, cb) {
    jwt.sign(cred, JWT_SECRET_KEY, {}, cb);
}

exports.decodeJWT = function decodeJWT(token, cb) {
    jwt.verify(token, JWT_SECRET_KEY, {}, (err, decoded)=> {
        if(decoded === undefined || err) {
            cb(false, undefined);
        } else {
            cb(true, decoded);
        }
    });
}