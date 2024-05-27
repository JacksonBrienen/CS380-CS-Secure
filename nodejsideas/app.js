//Include express, create an app, set a port to use
const express = require('express')
const app = express()
const port = 3000

//include the ability to use fs func
const fs = require('fs')

//include the ability to use path
const ext = require('path')

//include the ability to parse body in requests/responses
const parser = require('body-parser')

//include functionality to database from database.js
const db = require('./database')
//call function with db.createAClass()

//create a static directory to access files
const dir = './httpd'

//Listen to requests on port
app.listen(port, () => console.log(`Server is listening on port ${port}`))

//use json files
app.use(express.json())

//use urlencoded unextended parsing
app.use(parser.urlencoded({extended: false}))

/* Begin Section Created By Jackson Brienen */

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

/* End Section Created By Jackson Brienen */

app.get('/', (req, res) => {
	//req.url or req.method are useful
	//res.write and res.end are useful
	//could also use res.send, which sets res.setHeader Content-Type implicitly
	res.status(200).json({info:'preset'})
})

app.get('/welcome', (req, res) => {
	res.sendFile(path.join(__dirname, dir, 'welcome.html'))
	console.log('Going to Welcome Page')
})

//accept from signin page
app.get('/welcome/:dynamic', (req, res) => {
	const { dynamic } = req.params
	const { email } = req.query
	const { password } = req.query
})

//accept from signup page
app.get('/welcome/:dynamic', (req, res) => {
	const { dynamic } = req.params
	const { email } = req.query
	const { studentid } = req.query
	const { password } = req.query

})

app.get('/courseManager', (req, res) => {
	res.sendFile(path.join(__dirname, dir, 'courseManager.html'))
})

app.get('/courseManager/:dynamic', (req, res) => {
	const { dynamic } = req.params

})

app.post('/', (req, res) => {
	const { parcel } = req.body
	if(!parcel) {
		return res.status(400).send({status : 'failed'})
	}
	res.status(200).send({status : 'received'})
})

app.post('/welcome', (req,res) => {
	console.log(req.body)
	let email; let sid; let password;

	for(const [key, value] of Object.entries(req.body)) {
		switch(key) {
		case 'email':
			email= value;
			break;
		case 'sid':
			sid=value;
			break;
		case 'password':
			password=value;
		}
	}

	if((email === undefined || password === undefined || sid === undefined) || ((email === '') || (password === '') || (sid === '')))
	{
		res.status(400).send({status : 'failure'})
	}
	try {
		rows = verifySignUpNoConflict(email, sid)
	} catch {
		affected = createNewStudent(email, sid, password)
		if(affected === 1)
		{
			res.write('Accepted')
		}
	}
})

//

//Catch General Errors that will occur. Track dev info, but show message
app.use((err, req, res, next) => {
	console.error(err.stack)
	res.status(500).send('Something Broke. Please Try Again')
})

// fall through get request, responds with 404
/* Fallback Created By Jackson Brienen */
app.get('*', function(req, res){
    res.status(404);
    if(req.accepts("html")) {
        res.send('<html lang="en">Error 404 page not found</html>');
    } else if(req.accepts("json")) {
        res.send('{"error": "Resource Not Found"}');
    } else {
        res.send();
    }
})