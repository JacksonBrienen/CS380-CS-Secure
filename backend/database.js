const sql = require("mysql2");
const bcrypt = require("bcrypt");
const errno = require("./errno");

const compsciId = 1;

const connection = sql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'password',
    multipleStatements: true
});

connection.connect((err) => {
    if(err) throw err;
    console.log('Connected to MySql');
});

// restarts the connection if it closes
connection.on('close', ()=> {
    connection.connect((err) => {
        if(err) throw err;
        console.log('Connected to MySql');
    });
});

/**
 * Callback to ensure an email does not already exist in the database
 * @callback emailCB
 * @param {boolean} unused - true if the email is not already in the database; false if otherwise
 */
/**
 * @param {string} email
 * @param {emailCB} cb
 */
function unusedEmail(email, cb) {
    connection.query('SELECT email FROM db.student WHERE email=?', [email], (err, res) => {
        cb(res.length === 0);
    });
}

/**
 * Callback to verify if a new user could be added to the Database
 * @callback addStudentCB
 * @param {boolean} success - true if the user could be added; otherwise false and errno and err will be set
 * @param {number} errno - an error number defined in errno.js
 * @param {undefined | string | Error | SQLException} err - error that occurred
 */
/**
 *
 * @param {string} email
 * @param {string} passwd
 * @param {addStudentCB} cb
 */
exports.addStudent = function addStudent(email, passwd, cb) {
    unusedEmail(email, (unused) => {
        if(unused) {
            bcrypt.genSalt(10, (err, salt) => {
                if(err) {
                    cb(false, errno.BCRYPT_ERROR, err);
                } else {
                    bcrypt.hash(passwd, salt, (err, hash)=>{
                        if(err) {
                            cb(false, errno.BCRYPT_ERROR, err);
                        } else {
                            connection.query('INSERT INTO db.student (email, password, planId) VALUES (?, ?, ?)',
                                [email, hash, compsciId],
                                (err, res) => {
                                    if(err) {
                                        cb(false, errno.SQL_ERROR, err);
                                    } else {
                                        cb(true, errno.NO_ERROR, undefined);
                                    }
                                });
                        }
                    });
                }
            });
        } else {
            cb(false, errno.DUPLICATE_EMAIL_ERROR, 'Duplicate Email in Database');
        }
    });
}

exports.validateStudent = function validateStudent(email, passwd, cb) {
    connection.query('SELECT password FROM db.student WHERE email = ?', [email], (err, res) => {
        if(err) {
            cb(false, errno.SQL_ERROR, err);
        } else if(res.length !== 1) {
            cb(false, errno.INVALID_EMAIL_OR_PASSWORD, 'No matching email or password');
        } else {
            console.log(res[0]);
            bcrypt.compare(passwd, res[0].password, (err, res)=> {
                if(err) {
                    cb(false, errno.BCRYPT_ERROR, err);
                } else if(res) {
                    cb(true, errno.NO_ERROR, undefined);
                } else {
                    cb(false, errno.INVALID_EMAIL_OR_PASSWORD, 'No matching email or password');
                }
            });
        }
    });
}

exports.studentId = function studentId(email, passwd, cb) {
    connection.query('SELECT * FROM db.student WHERE email = ?', [email], (err, qres)=> {
        if(err) {
            cb(false, undefined);
        } else if(qres.length === 0) {
            cb(false, undefined);
        } else {
            bcrypt.compare(passwd, qres[0].password, (err, res)=> {
                if(err) {
                    cb(false, errno.BCRYPT_ERROR, err);
                } else if(!res) {
                    cb(false, undefined);
                } else {
                    console.log('returning sid', qres[0].sid);
                    cb(true, qres[0].sid);
                }
            });
        }
    });
}

function courseJson(rows) {
    const courses = {};
    for(const row of rows) {
        courses[row.id] = {
            name: row.name,
            description: row.description,
            link: row.link,
            credits: row.credits
        }
    }
    return courses;
}

function multiCourseJson(rows) {
    const courses = {};
    for(const row of rows) {
        if(courses[row.id] === undefined) {
            courses[row.id] = {
                name: row.name,
                description: row.description,
                link: row.link,
                courses: [],
                multiCourse: true
            }
        }
        if(row.courseList === courses[row.id].courses.length) {
            courses[row.id].courses.push([]);
        }
        courses[row.id].courses[row.courseList].push(row.courseId);
    }
    return courses;
}

exports.needed = function needed(sid, cb) {
    connection.query(
        'SELECT * FROM db.course WHERE ' +
        'id NOT IN (SELECT id       FROM db.multicourse)             AND ' +
        'id NOT IN (SELECT courseId FROM db.multicourse)             AND ' +
        'id NOT IN (SELECT course   FROM db.fall      WHERE sid = ?) AND ' +
        'id NOT IN (SELECT course   FROM db.winter    WHERE sid = ?) AND ' +
        'id NOT IN (SELECT course   FROM db.spring    WHERE sid = ?) AND ' +
        'id NOT IN (SELECT course   FROM db.summer    WHERE sid = ?) AND ' +
        'id NOT IN (SELECT course   FROM db.completed WHERE sid = ?)',
        [sid, sid, sid, sid, sid],
        (err, res) => {
            if(err) {
                cb(false, undefined);
            } else {
                cb(true, courseJson(res));
            }
        }
    );
}

exports.neededMulti = function neededMulti(sid, cb) {
    connection.query(
        'SELECT * FROM db.multicourse mc ' +
        'JOIN db.course c ON mc.id = c.id ' +
        'WHERE ' +
        'mc.id NOT IN (SELECT course   FROM db.fall      WHERE sid = ?) AND ' +
        'mc.id NOT IN (SELECT course   FROM db.winter    WHERE sid = ?) AND ' +
        'mc.id NOT IN (SELECT course   FROM db.spring    WHERE sid = ?) AND ' +
        'mc.id NOT IN (SELECT course   FROM db.summer    WHERE sid = ?) AND ' +
        'mc.id NOT IN (SELECT course   FROM db.completed WHERE sid = ?)     ' +
        'ORDER BY courseList, courseIndex',
        [sid, sid, sid, sid, sid],
        (err, res) => {
            if(err) {
                cb(false, undefined);
            } else {
                cb(true, multiCourseJson(res));
            }
        }
    );
}

exports.completed = function completed(table, sid, cb) {
    connection.query(
        'SELECT * FROM db.course WHERE ' +
        'id NOT IN (SELECT id FROM db.multicourse) AND ' +
        'id IN (SELECT course FROM db.' + table + ' WHERE sid = ?)',
        [sid],
        (err, res) => {
            if(err) {
                throw err;
                cb(false, undefined);
            } else {
                cb(true, courseJson(res));
            }
        }
    );
}

exports.completedMulti = function completedMulti(table, sid, cb) {
    connection.query(
        'SELECT * FROM db.multicourse mc ' +
        'JOIN db.course c ON mc.id = c.id ' +
        'WHERE mc.id IN (SELECT course FROM db.' + table + ' WHERE sid = ?) ' +
        'ORDER BY courseList, courseIndex',
        [sid],
        (err, res) => {
            if(err) {
                throw err;
                cb(false, undefined);
            } else {
                cb(true, multiCourseJson(res));
            }
        }
    );
}

exports.removeCompleted = function removeCompleted(id, sid, cb) {
    connection.query(
        'DELETE FROM db.fall      WHERE course = ? AND sid = ?; ' +
        'DELETE FROM db.winter    WHERE course = ? AND sid = ?; ' +
        'DELETE FROM db.spring    WHERE course = ? AND sid = ?; ' +
        'DELETE FROM db.summer    WHERE course = ? AND sid = ?; ' +
        'DELETE FROM db.completed WHERE course = ? AND sid = ?; ',
        [id, sid, id, sid, id, sid, id, sid, id, sid],
        (err, res) => {
            if(err) {
                cb(false);
            } else {
                cb(true);
            }
        });
}


exports.addCompleted = function addCompleted(table, id, sid, cb) {
    exports.removeCompleted(id, sid, (success) => {
        if(success) {
            connection.query(
                'INSERT INTO db.' + table + ' VALUES (?, ?)',
                [sid, id],
                (err, res)=> {
                    if(err) {
                        cb(false);
                    } else {
                        cb(true);
                    }
                }
            );
        } else {
            cb(false);
        }
    });
}

exports.getMulti = function getMulti(sid, cb) {
    connection.query(
        'SELECT mutlicourse, course FROM db.multicourseSelection WHERE sid = ?',
        [sid],
        (err, res) => {
            if(err) {
                cb(false, undefined);
            } else {
                const courses = {}
                for(const row of res) {
                    courses[row.mutlicourse] = row.course;
                }
                cb(true, courses);
            }
        }
    );
}

exports.setMulti = function setMulti(multiId, id, sid, cb) {
    if(id === multiId) {
        connection.query(
            'DELETE FROM db.multicourseSelection WHERE sid = ? AND mutlicourse = ?', // fricken typo in db, too lazy to fix
            [sid, multiId],
            (err, res) => {
                if(err) {
                    cb(false);
                } else {
                    cb(true);
                }
            }
        );
    } else {
        connection.query(
            'INSERT INTO db.multicourseSelection VALUES (?, ?, ?)',
            [sid, multiId, id],
            (err, res) => {
                if(err) {
                    connection.query(
                        'UPDATE db.multicourseSelection SET course = ? WHERE sid = ? AND mutlicourse = ?',
                        [id, sid, multiId],
                        (err, res) => {
                            if(err) {
                                cb(false);
                            } else {
                                cb(true);
                            }
                        }
                    );
                } else {
                    cb(true);
                }
            }
        );
    }
}



// exports.addStudent("email@email.com", "password", (success, errno, err) => {
//    if(success) {
//
//    }
// });

// brienenj@cwu.edu 123
// email@email.com  password
// exports.validateStudent("brienenj@cwu.edu", "123", (success, errno, err)=> {
//     if(success) {
//         console.log("Da Baby");
//     } else {
//         console.log("Da Adult");
//     }
// });