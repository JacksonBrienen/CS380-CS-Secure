/*
 Author     : Jackson Brienen
 File       : index.js
 Description: Main node server file
 */

// Requires express, body-parser, and mysql packages to run

// import and run express to create server
const app = require("express")();

const parser = require("body-parser");
app.use(parser.urlencoded({extended: false}));

const fs = require("node:fs");
const ext = require("path");

const db = require("./database");
const ERRNO = require("./errno");
const jwt = require('./jwt');

// directory where files are stored
const dir = "../httpd";

// routes for main page, signin/signup, and course manager
const routes = [
    {
        path: "/",
        filePath: `${dir}/index.html`
    },
    {
        path: "/welcome",
        filePath: `${dir}/welcome.html`
    },
    {
        path: "/manager",
        filePath: `${dir}/courseManager.html`
    }
];

// recursively add files to server from root directory
function buildFs(dir) {
    let fullDir = "";
    for(const subDir of dir) {
        fullDir += subDir + "/";
    }
    let currentDir = "/";
    for(let i = 1; i < dir.length; i++) {
        currentDir += dir[i] + "/";
    }
    const paths = fs.readdirSync(fullDir);
    for(const f of paths) {
        if(fs.statSync(`${fullDir}${f}`).isDirectory()) {
            const newDir = [...dir];
            newDir.push(f);
            buildFs(newDir);
        } else {
            const fullPath = `${fullDir}${f}`;
            const path = `${currentDir}${f}`;
            const extension = ext.extname(path);
            if(extension !== '.html') {
                app.get(path, (req, res, next) => {
                    res.type(extension);
                    fs.createReadStream(fullPath).pipe(res);
                });
            }
        }
    }
}

// add get requests for routes
function buildRoutes(routes) {
    for(const route of routes) {
        app.get(route.path, (req, res, next) => {
            res.type("html");
            fs.createReadStream(route.filePath).pipe(res);
        });
    }
}

buildFs([dir]);
buildRoutes(routes);

function evalBoolean(str) {
    if(str.toLowerCase() === 'true') {
        return true;
    }
    if(str.toLowerCase() === 'false') {
        return false;
    }
    throw `Invalid boolean value ${str}`;
}

function validEmail(email) {
    const r = RegExp('(?:[a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\\])');
    return r.test(email);
}

app.post("/welcome", (req, res, next) => {
    let signUp;
    let email;
    let password;
    // check for proper keys and gets their values
    // any errors caught here will be either error of the developer
    // or a malicious actor attempting to break the system by changing what is given to the request body
    try {
        console.log(req.body);
        for(const [key, value] of Object.entries(req.body)) {
            switch(key) {
                case 'signUp':
                    signUp = evalBoolean(value);
                    break;
                case 'email':
                    if(typeof(value) === 'string') {
                        email = value;
                    } else {
                        throw `Value ${value} for email is not a string`;
                    }
                    break;
                case 'password':
                    if(typeof(value) === 'string') {
                        password = value;
                    } else {
                        throw `Value ${value} for password is not a string`;
                    }
                    break;
            }
        }
        if(signUp === undefined)   throw 'signUp entry not defined';
        if(email === undefined)    throw 'email entry not defined';
        if(password === undefined) throw 'password entry not defined';
    } catch (e) {
        console.log(`Rejecting Welcome request with object ${req.body} because ${e}`);
        res.status(400);
        return;
    }

    if(!validEmail(email)) {
        console.log(`Rejecting Welcome request since '${email}' is not a valid email`);
        res.status(418);
        res.type('text/html');
        res.send('<p>Error: Invalid Email, please check your email, then try again.</p>');
        return;
    }

    if(password.length === 0) {
        console.log(`Rejecting Welcome request since password is blank`);
        res.status(418);
        res.type('text/html');
        res.send('<p>Error: Empty password, please enter a password, then try again.</p>');
        return;
    }

    // by this point all inputs are valid, and now need to be checked
    // to see if they are ok on the database end

    if(signUp) {
        db.addStudent(email, password, (success, errno, err)=> {
            if(success) {
                res.status(200);
                res.type('text/html');
                res.send('<p>Account successfully created.<br>Try <a role="button" onclick="changeToSignin()">logging in</a>.</p>');
            } else {
                switch(errno) {
                    case ERRNO.SQL_ERROR:
                    case ERRNO.BCRYPT_ERROR:
                        console.log(`Rejecting Welcome request due to error ${err}`);
                        res.status(418);
                        res.type('text/html');
                        res.send('<p>Error: Cannot handle process at this time<br>Please try again later.</p>');
                        break;
                    case ERRNO.DUPLICATE_EMAIL_ERROR:
                        console.log(`Rejecting Welcome request due to email already existing`);
                        res.status(418);
                        res.type('text/html');
                        res.send('<p>An account using this email already exists.<br>Try <a role="button" onclick="changeToSignin()">logging in</a> instead.</p>');
                        break;
                }
            }
        });
    } else {
        db.validateStudent(email, password, (success, errno, err)=> {
            if(success) {
                jwt.generateJWT({email: email, password: password}, (err, token) => {
                    if(err) {
                        console.log(`Rejecting Welcome request due to error ${err}`);
                        res.status(418);
                        res.type('text/html');
                        res.send('<p>Error: Cannot handle process at this time<br>Please try again later.</p>');
                    } else {
                        res.status(200);
                        res.type('json');
                        res.send({token: token});
                    }
                });
            } else {
                switch(errno) {
                    case ERRNO.SQL_ERROR:
                    case ERRNO.BCRYPT_ERROR:
                        console.log(`Rejecting Welcome request due to error ${err}`);
                        res.status(418);
                        res.type('text/html');
                        res.send('<p>Error: Cannot handle process at this time<br>Please try again later.</p>');
                        break;
                    case ERRNO.INVALID_EMAIL_OR_PASSWORD:
                        console.log(`Rejecting Welcome request due to invalid credentials`);
                        res.status(418);
                        res.type('text/html');
                        res.send('<p>Email or Password incorrect</p>');
                        break;
                }
            }
        });
    }
});

app.get('/manager/needed', (req, res) => {
    const token = req.get('Auth-Token');
    if(token === undefined) {
        res.sendStatus(400);
    } else {
        jwt.decodeJWT(token, (success, obj) => {
            if(success) {
                db.studentId(obj.email, obj.password, (success, sid) => {
                    if(success) {
                        db.needed(sid, (success, obj1) => {
                            if(success) {
                                db.neededMulti(sid, (success, obj2)=>{
                                    if(success) {
                                        res.status(200);
                                        res.type('json');
                                        res.send({...obj1, ...obj2});
                                    } else {
                                        res.sendStatus(400);
                                    }
                                });
                            } else {
                                res.sendStatus(400);
                            }
                        });
                    } else {
                        res.sendStatus(400);
                    }
                });
            } else {
                res.sendStatus(400);
            }
        });
    }
});

app.get('/manager/:season', (req, res, next) => {
    switch(req.params.season) {
        case 'fall':
        case 'winter':
        case 'spring':
        case 'summer':
        case 'completed':
            const token = req.get('Auth-Token');
            if(token === undefined) {
                res.sendStatus(400);
            } else {
                jwt.decodeJWT(token, (success, obj) => {
                    if (success) {
                        db.studentId(obj.email, obj.password, (success, sid) => {
                            if (success) {
                                db.completed(req.params.season, sid, (success, obj1) => {
                                    if(success) {
                                        db.completedMulti(req.params.season, sid, (success, obj2) => {
                                            if(success) {
                                                res.status(200);
                                                res.type('json');
                                                res.send({...obj1, ...obj2});
                                            } else {
                                                res.sendStatus(400);
                                            }
                                        });
                                    } else {
                                        res.sendStatus(400);
                                    }
                                });
                            } else {
                                res.sendStatus(400);
                            }
                        });
                    } else {
                        res.sendStatus(400);
                    }
                });
            }
            break;
        default:
            res.sendStatus(404);
            break;
    }
});

app.post('/manager/needed/:course', (req, res, next) => {
    const token = req.get('Auth-Token');
    if(token === undefined) {
        res.sendStatus(400);
    } else {
        jwt.decodeJWT(token, (success, obj) => {
            if (success) {
                db.studentId(obj.email, obj.password, (success, sid) => {
                    if (success) {
                        db.removeCompleted(req.params.course, sid, (success) => {
                            if(success) {
                                res.sendStatus(200);
                            } else {
                                res.sendStatus(400);
                            }
                        });
                    } else {
                        res.sendStatus(400);
                    }
                });
            } else {
                res.sendStatus(400);
            }
        });
    }
});

app.post('/manager/:season/:course', (req, res, next) => {
    switch(req.params.season) {
        case 'fall':
        case 'winter':
        case 'spring':
        case 'summer':
        case 'completed':
            const token = req.get('Auth-Token');
            if(token === undefined) {
                res.sendStatus(400);
            } else {
                jwt.decodeJWT(token, (success, obj) => {
                    if (success) {
                        db.studentId(obj.email, obj.password, (success, sid) => {
                            if (success) {
                                db.addCompleted(req.params.season, req.params.course, sid, (success) => {
                                    if(success) {
                                        res.sendStatus(200);
                                    } else {
                                        res.sendStatus(400);
                                    }
                                });
                            } else {
                                res.sendStatus(400);
                            }
                        });
                    } else {
                        res.sendStatus(400);
                    }
                });
            }
            break;
        default:
            res.sendStatus(404);
            break;
    }
});

// fall through get request, responds with 404
app.get('*', function(req, res){
    res.status(404);
    if(req.accepts("html")) {
        res.send('<html lang="en">Error 404 page not found</html>');
    } else if(req.accepts("json")) {
        res.send('{"error": "Resource Not Found"}');
    } else {
        res.send();
    }
});

// bind server to port 3000
app.listen(3000);
