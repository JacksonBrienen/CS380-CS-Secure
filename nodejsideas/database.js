//Include mysql2 (mysql is just less useful for most cases)
const mysql = require('mysql2')

//connect to cs_secure database using localhost
//create a pool of connections to reuse
const pool = mysql.createPool({
	host: '127.0.0.1',
	user: 'root',
	password: '',
	database: 'cs_secure'
}).promise()

//Pair function query and call to get information for signing in
async function signInQuery(email) {
	const [rows] = await pool.query(`
		SELECT password
		FROM students
		WHERE email = ?
		`, [email])
	return rows[0]
}
async function getSignInInfo(email) {
	const getInfo = await signInQuery(email)
	return getInfo
}

//Grouped function queries and call to get information for signing up
async function signUpQueryCheckEmail(email) {
	const [rows] = await pool.query(`
		SELECT studentID
		FROM students
		WHERE email = ?
		`, [email])
	return rows[0]
}
async function signUpQueryCheckStudentID(id) {
	const [rows] = await pool.query(`
		SELECT email
		FROM students
		WHERE studentID = ?
		`, [id])
	return rows[0]
}
async function verifySignUpNoConflict(email, id) {
	const verifyEmail = await signUpQueryCheckEmail(email)
	const verifyId = await signUpQueryCheckStudentID(id)
	return { vemail:verifyEmail, vid:verifyId }
}

//Paired function query and call to create a new student when signing up
async function insertNewStudentQuery(email, id, password) {
	const [result] = await pool.query(`
		INSERT INTO students (email, studentID, password)
		VALUES (?, ?, ?)
		`, [email, id, password])
	return result.affectedRows
}
async function createNewStudent(email, id, password) {
	const result = await insertNewStudentQuery(email, id, password)
	return result
}

//Paired function query and call to see a students plan based on id
async function seeStudentPlanQuery(id) {
	const [rows] = await pool.query(`
		SELECT *
		FROM studentplan
		WHERE studentID = ?
		`, [id])
	return rows
}
async function getStudentPlanned(id) {
	const rows = await seeStudentPlanQuery(id)
	return rows
}

//Paired function query and call to see a students taken classes based on id
async function seeStudentTakenQuery(id) {
	const [rows] = await pool.query(`
		SELECT *
		FROM studenttaken
		WHERE studentID = ?
		`, [id])
	return rows
}
async function getStudentTaken(id) {
	const rows = await seeStudentTakenQuery(id)
	return rows
}

//Paired function query and call to update a students plan based on id and season
async function updateStudentPlanQuery(id, season, class1, class2, class3, class4, class5, class6) {
	const [result] = await pool.query(`
		UPDATE studentplan
		VALUES (?, ?, ?, ?, ?, ?)
		WHERE studentID = ? AND season = ?
		`, [class1, class2, class3, class4, class5, class6], [id], [season])
	return result.changedRows
}
async function changeStudentPlan(id, season, class1, class2, class3, class4, class5, class6) {
	const result = await updateStudentPlanQuery(id, season, class1, class2, class3, class4, class5, class6)
	return result
}

//Paired function query and call to determine if a specific student has taken a specific class
async function seeStudentTakenSpecificClassQuery(studentID, classID) {
	const [rows] = await pool.query(`
		SELECT classID
		FROM studenttaken
		WHERE studentID = ? and classID = ?
		`, [studentID], [classID])
	return rows
}
async function getIfClassTakenByStudent(studentID, classID) {
	const rows = await seeStudentTakenSpecificClassQuery(studentID, classID)
	return rows
}

//Paired function query and call to insert a new class into a students taken classes
async function insertNewClassTakenQuery(studentID, classID) {
	const [result] = await pool.query(`
		INSERT INTO studenttaken
		VALUES (?, ?)
		`, [studentID, classID])
	return result.affectedRows
}
async function takenNewClass(studentID, classID) {
	const result = await insertNewClassTakenQuery(studentID, classID)
	return result
}

//Paired function query and call to delete a class from a students taken classes
async function deleteClassFromTakenQuery(studentID, classID) {
	const [result] = await pool.query(`
		DELETE FROM studenttaken
		WHERE studentID = ? AND classID = ?
		`, [studentID], [classID])
	return result.affectedRows
}
async function removeTakenClass(studentID, classID) {
	const result = await deleteClassFromTakenQuery(studentID, classID)
	return result
}

//Export the functions that should be "public"
module.exports = {
	getSignInInfo,
	verifySignUpNoConflict,
	createNewStudent,
	getStudentPlanned,
	getStudentTaken,
	changeStudentPlan,
	getIfClassTakenByStudent,
	takenNewClass,
	removeTakenClass
}