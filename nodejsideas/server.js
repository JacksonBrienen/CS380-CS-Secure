const express = require('express')
const path = require('path')
const fs = require('fs');
const mysql = require('mysql2');

const port = 3000
const app = express()

app.set('view engine', 'ejs')
//app.use(logger)
app.use(express.static("public")) 
app.use(express.urlencoded({extended: true}))

//app.use(express.static(path.join(__dirname, 'public')))

app.get('/', (req, res) => {
	console.log('Here')
	//res.download('server.js') //downloads the given file
	//res.status(200).json({message: "Error"}) //sends back the formatted json but with optional error/success internal
	res.render('index', {text2:"World"})
})

const viewRouter = require('./routes/views')

app.use('/views', viewRouter)

const screenRouter = require('./routes/screens')
app.use('/screens', screenRouter)

/*
function logger(req, res, next) {
	console.log(req.originalUrl)
	next()
}*/

app.listen(port)

/*
app.get('/users', (req, res) => { //This would allow localhost/users to be the view specific to this
	res.send('User List')
})

app.get('/users/new', (req, res) => {
	res.send('User New Fomr')
})
*/


// Serve static files from the public directory
app.use(express.static(path.join(__dirname, 'public')))
/*
const courses = JSON.parse(fs.readFileSync('courses.json', 'utf8'));
const sqlSchema = fs.readFileSync('createCSSecureDatabase.sql', 'utf8');

// MySQL configuration
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  multipleStatements: true
});

connection.query(sqlSchema, (err) => {
	if(err) throw err;
	console.log('Database and table was either created or existed');
	
	courses.forEach(course => {
		connection.query('INSERT INTO classes (data) VALUES (?)', [JSON.stringify(course)], (err) => {
			if(err) throw err;
		});
	});
	
	console.log('Courses Inserted');
	connection.end();
}); */

/*

// Connect to MySQL
connection.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  
  console.log('Connected to MySQL');
  
  repairDatabase();
});

function repairDatabase() {
	fs.readFile('/../Database/repairCSSecureDB.sql', 'utf8', (err, repairSql) => {
	  if(err) {
		  console.error('Error reading repair sql : ', err);
		  return;
	  }
	  connection.query(repairSql, (error) => {
		  if(error) {
			  console.error('Error executing repair sql : ', error);
			  return;
		  }
		  console.log('Repair executed successfully');
	  });
	});
}

// Endpoint to fetch data
app.get('/data', (req, res) => {
  // Query database
  connection.query('SELECT * FROM students', (error, results) => {
    if (error) {
      console.error('Error querying database:', error);
      res.status(500).send('Internal Server Error');
      return;
    }
    // Send response
    res.json(results);
  });
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
*/