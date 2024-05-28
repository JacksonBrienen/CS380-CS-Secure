const jwt = require('jsonwebtoken');

const JWT_SECRET_KEY = 'nSkmj4Tma+l6CN0bPRtdoN+1pT8aiLtZ71CawvRi2pmN+BG7bPfl/pzXcXTlTMFkd8M/q5rvWX1OjhK/9upNb8J37pAfBnhZTg1k35WUCuS+aRpAY0R1tRZk0/TRtVjXEWZXOLI69zVvTLhIa3SMqmaPjIaYmJ8vnb338XpouvT+1HVCFi+Sy4Nale1SOQ1PVRSowdQVjeA+ND+Q9JydyRAJIMCs8q6GH1sHADkBcqfnB0j2jYJm9aDZRCWhgWIaak9UmamJ+QXScj2iCi+Iqxl5p9TBzIpb++u8gqzd5rD7wlrp0rxTP9eKIxaSub1r/ZxJx+Fqst7VRi6aC9q6hQ==';

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