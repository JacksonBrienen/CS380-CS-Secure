DROP DATABASE IF EXISTS CS_Secure;
CREATE DATABASE CS_Secure;
USE CS_Secure;

CREATE TABLE majors (
    majorName       VARCHAR(20)		NOT NULL,
    CONSTRAINT      majorsPK
        PRIMARY KEY (majorName)
) ENGINE INNODB
;

CREATE  TABLE  students (
    studentID       CHAR(10)     	NOT NULL,
    username        VARCHAR(30)     NOT NULL,
    email           VARCHAR(60),
    pswd        	VARCHAR(60)     NOT NULL,
    major           VARCHAR(20),
    minor         	VARCHAR(20),
    fname           VARCHAR(50),
    lname         	VARCHAR(50),
    gender        	CHAR(1),
    CONSTRAINT      studentsPK
        PRIMARY KEY (studentID),
    CONSTRAINT      students_fk_majors
        FOREIGN KEY (major)
        REFERENCES  majors (majorName)
) ENGINE INNODB
;

CREATE TABLE classes (
    classID         VARCHAR(10),
    className		VARCHAR(100),
    descr       	VARCHAR(400),
    credits			INTEGER,
    link			VARCHAR(100),
    genEd			BOOLEAN,
    multiCourse		BOOLEAN,
    CONSTRAINT      classesPK
        PRIMARY KEY (classID)
) ENGINE INNODB
;

CREATE TABLE majorReqs (
    major           VARCHAR(20) NOT NULL,
    classID         VARCHAR(10) NOT NULL,
    requirementType VARCHAR(10),
    CONSTRAINT      majorReqsPK
        PRIMARY KEY (major, classID),
    CONSTRAINT      majorReqs_fk_majors
        FOREIGN KEY (major) 
        REFERENCES  majors (majorName),
	CONSTRAINT      majorReqs_fk_classes
        FOREIGN KEY (classID) 
        REFERENCES  classes (classID)
) ENGINE INNODB
;

CREATE TABLE preReqs(
    classID         VARCHAR(10)     NOT NULL,
    prereqClass     VARCHAR(10)     NOT NULL,
    CONSTRAINT      preReqsPK
        PRIMARY KEY (classID, preReqClass),
    CONSTRAINT      preReqs_fk_classes_mainClass
        FOREIGN KEY (classID)
        REFERENCES  classes (classID),
	CONSTRAINT      preReqs_fk_classes_preReqClass
        FOREIGN KEY (classID)
        REFERENCES  classes (classID)
) ENGINE INNODB
;

CREATE TABLE studentTaken (
    studentID       CHAR(10)		NOT NULL,
    classID         VARCHAR(10)		NOT NULL,
    CONSTRAINT      studentTakenPK
        PRIMARY KEY (studentID, classID),
    CONSTRAINT      studentTaken_fk_students
        FOREIGN KEY (studentID)
        REFERENCES  students (studentID),
    CONSTRAINT      studentTaken_fk_classes
        FOREIGN KEY (classID)
        REFERENCES  classes (classID) 
) ENGINE INNODB
;

CREATE TABLE studentPlan (
	studentID		CHAR(10)		NOT NULL,
    season			VARCHAR(10)		NOT NULL,
    classOne		VARCHAR(10),
    classTwo		VARCHAR(10),
	classThree		VARCHAR(10),
    classFour		VARCHAR(10),
    classFive		VARCHAR(10),
    classSix		VARCHAR(10),
	CONSTRAINT 		studentPlanPK
		PRIMARY KEY (studentID, season),
	CONSTRAINT		studentPlan_fk_students
		FOREIGN KEY (studentID)
		REFERENCES  students (studentID),
	CONSTRAINT		studentPlanC1_fk_classes
		FOREIGN KEY	(classOne)
		REFERENCES 	classes (classID),
	CONSTRAINT		studentPlanC2_fk_classes
		FOREIGN KEY	(classTwo)
		REFERENCES 	classes (classID),
	CONSTRAINT		studentPlanC3_fk_classes
		FOREIGN KEY	(classThree)
		REFERENCES 	classes (classID),
	CONSTRAINT		studentPlanC4_fk_classes
		FOREIGN KEY	(classFour)
		REFERENCES 	classes (classID),
	CONSTRAINT		studentPlanC5_fk_classes
		FOREIGN KEY	(classFive)
		REFERENCES 	classes (classID),
	CONSTRAINT		studentPlanC6_fk_classes
		FOREIGN KEY	(classSix)
		REFERENCES 	classes (classID)
) ENGINE INNODB
;

-- Above are the statements to create the basic tables without data, but with connections

SET FOREIGN_KEY_CHECKS=0;

INSERT INTO majors VALUES 
    ('Computer Science')
;

INSERT INTO classes VALUES
	(
    "CS110",
        "Programming Fundamentals I",
        "Fundamental concepts of programming from an object-oriented perspective. Classes, objects and methods, algorithm development, problem-solving techniques, basic control structures, primitive types and arrays.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256150",
        false,
        false
    ), (
    "CS111",
        "Programming Fundamentals II",
        "Continuation of object-oriented programming concepts introduced in CS 110. Inheritance, exceptions, graphical user interfaces, recursion, and data structures.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256151",
        false,
        false
    ), (
    "CS112",
        "Introduction to Data Science in Python",
        "This course is an introduction to the Python programming language with the following Data Science topics; data pre-processing, working with categorical and textual data, data parsing, data and natural language processing and data visualization.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256152",
        false,
        false
    ), (
    "CS301",
        "Data Structures",
        "Introduction to elementary data structures (arrays, lists, stacks, queues, deques, binary trees) and their Java implementation as abstract data types.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256156",
        false,
        false
    ), (
    "CS302",
        "Advanced Data Structures and File Processing",
        "Introduction to non-linear data structures (balanced search trees, priority queues, graphs, maps, sets, hashing data structures), their Java implementations as abstract data types, and basic algorithms (sorting, greedy, graph algorithms).",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256157",
        false,
        false
    ), (
    "CS311",
        "Computer Architecture I",
        "Introduction to computer architecture, data representations, assembly language, addressing techniques. Course will be offered every year. Course will not have an established scheduling pattern.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256158",
        false,
        false
    ), (
    "CS312",
        "Computer Architecture II",
        "Introduction to the structure of computers. Digital circuits, central processing units, memory, input/output processing, parallel architectures. Course will be offered every year.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256159",
        false,
        false
    ), (
    "CS325",
        "Technical Writing in Computer Science",
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256160",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256160",
        false,
        false
    ), (
    "CS361",
        "Principles of Language Design I",
        "Topics will include evolution of programming languages, syntax and semantics, bindings, scoping, data types, assignment, control, and subprograms.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256163",
        false,
        false
    ), (
    "CS362",
        "Principles of Language Design II",
        "Topics will include abstract data types, parallel processing, object-oriented programming, exception handling functional programming, and logic programming. Course will be offered every year. Course will not have an established scheduling pattern.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256164",
        false,
        false
    ), (
    "CS380",
        "Introduction to Software Engineering",
        "An introduction to the principles and practices of software engineering, including object-oriented analysis and design, design patterns, and testing. Course will not have an established scheduling pattern.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256179",
        false,
        false
    ), (
    "CS392",
        "Practical Experience in Debugging Computer Code",
        "Mentored experience in applying techniques and providing feedback for debugging computer code.",
        1,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256167",
        false,
        false
    ), (
    "CS420",
        "Database Management Systems",
        "Logical aspects of database processing; concepts of organizing data into integrated databases; hierarchical, network, and relational approaches.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256168",
        false,
        false
    ), (
    "CS427",
        "Algorithm Analysis",
        "Topics will include basic algorithmic analysis, algorithmic strategies, fundamental computing algorithms, basic computability, the complexity classes P and NP, and advanced algorithmic analysis.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256169",
        false,
        false
    ), (
    "CS450",
        "Computer Network and Data Communications",
        "The course deals with networking and data communication utilizing the concepts of device and network protocols, network configurations, encryption, data compression and security.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256175",
        false,
        false
    ), (
    "CS470",
        "Operating Systems",
        "Topics will include principles of operating systems, concurrency, scheduling and dispatch, memory management, processes and threads, device management, security and protection, and file systems.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256180",
        false,
        false
    ), (
    "CS480",
        "Advanced Software Engineering",
        "Advanced principles and practices of software engineering, including project management, requirements gathering and specification, design, coding, testing, maintenance and documentation. Students work in teams to develop a large software project.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256182",
        false,
        false
    ), (
    "CS481",
        "Capstone Project",
        "The computer science capstone project and culminating experience. Students will work in teams to develop and deploy a project reflecting an objective in the computer science field dealing with either industrial or research aspects.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256183",
        false,
        false
    ), (
    "CS489",
        "Senior Colloquium",
        "Investigation of ethical and historical topics provides a culminating experience in computer science. Students make connections between computer science and their General Education experiences. Concepts, principles and knowledge in the field are assessed.",
        1,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256184",
        false,
        false
    ), (
    "CS492",
        "Laboratory Experience in Teaching Computer Science",
        "Supervised progressive experience in developing procedures and techniques in teaching computer science.",
        2,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256187",
        false,
        false
    ), (


    "MATH153",
        "Pre-Calculus Mathematics I",
        "A foundation course which stresses those algebraic and elementary function concepts together with the manipulative skills essential to the study of calculus.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257139",
        false,
        false
    ), (
    "MATH154",
        "Pre-Calculus Mathematics II",
        "A continuation of MATH 153 with emphasis on trigonometric functions, vectors, systems of equations, the complex numbers, and an introduction to analytic geometry.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257140",
        false,
        false
    ), (
    "MATH172",
        "Calculus I",
        "Theory, techniques, and applications of differentiation and integration of the elementary functions.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257143",
        false,
        false
    ), (
    "MATH173",
        "Calculus II",
        "Theory, techniques, and applications of differentiation and integration of the elementary functions.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257144",
        false,
        false
    ), (
    "MATH260",
        "Sets and Logic",
        "Essentials of mathematical proofs, including use of quantifiers and principles of valid inference. Set theory as a mathematical system.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257147",
        false,
        false
    ), (
    "MATH330",
        "Discrete Mathematics",
        "Topics from logic, combinatorics, counting techniques, graph theory, and theory of finite-state machines.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257159",
        false,
        false
    ), (
    "DHC102",
        "Articulating Honors: Research Writing in the Twenty-First Century",
        "Introduces students to the academic expectations for DHC students; including writing essays, giving presentations, joining class discussions, and conducting research. Examines the philosophy, history, and debates surrounding honors education today, ultimately entering the discussion themselves. May be repeated for credit.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259810",
        false,
        false
    ), (
    "ENG101",
        "Academic Writing I: Critical Reading and Responding",
        "Develops flexible writing knowledge to adapt to writing situations across disciplines and contexts.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256437",
        false,
        false
    ), (
    "ENG101A",
        "Stretch Academic Writing A: Critical Reading and Responding",
        "Develops flexible writing knowledge to adapt to writing situations across disciplines and contexts.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259863",
        false,
        false
    ), (
    "ENG101B",
        "Stretch Academic Writing B: Critical Reading and Responding",
        "Develops flexible writing knowledge to adapt to writing situations across disciplines and contexts.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259864",
        false,
        false
    ), (
    "ADMG285",
        "Sustainable Decision-Making",
        "Examines the impact of decision-making using short/long term outlooks and multiple perspectives. Develops skills to critically evaluate economic, environmental and social impacts of decisions as well as appropriate methods to professionally communicate those decisions.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259738",
        false,
        false
    ), (
    "DHC270",
        "Integrated Learning",
        "An interdisciplinary approach to examining social, economic, technological, ethical, cultural, or aesthetic implications of knowledge. Instruction is augmented with practical application opportunities provided through international studies and community service learning.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256204",
        false,
        false
    ), (
    "ENG102",
        "Academic Writing II: Reasoning and Research on Social Justice",
        "Develops skills in research-based academic argument through assignments involving evaluation, analysis, and synthesis of multiple sources.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256438",
        false,
        false
    ), (
    "ENG103",
        "Academic Writing II: Reasoning and Research on Health and Current Issues",
        "Develops skills in research-based academic argument through assignments involving evaluation, analysis, and synthesis of multiple sources.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259641",
        false,
        false
    ), (
    "ENG111",
        "Writing in the Sciences",
        "Prepares students to write effectively in a variety of scientific disciplines through assignments involving evaluation, analysis, data interpretation, and synthesis of multiple sources.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259813",
        false,
        false
    ), (
    "HIST302",
        "Historical Methods",
        "Exercises in historical research, critical analysis, and interpretation.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256879",
        false,
        false
    ), (
    "MGT200",
        "Tactical Skills for Professionals",
        "This course develops the skills and insights necessary to effectively acquire, synthesize and disseminate knowledge as a business decision maker - skills essential for success in business school and standard abilities in high performance professionals.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258316",
        false,
        false
    ), (
    "PHIL152",
        "Arguments about Healthcare",
        "This course will cultivate critical thinking skills through the examination of arguments about healthcare, including whether there is a right to healthcare, the social determinants of health, and public policies designed to provide healthcare.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259627",
        false,
        false
    ), (
    "ABS210",
        "Introduction to Black Experience in the U.S.",
        "Examination of African Americans as (1) members of the nation they helped to build; and (2) members of a distinct culture that shapes and is shaped by local, national and global socio-economic and political forces.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258441",
        false,
        false
    ), (
    "BUS241",
        "Legal Environment of Business",
        "An introduction to legal reasoning, ethics in business, the law of contracts, torts, agency, sales, bailments, and personal property.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255953",
        false,
        false
    ), (
    "ECON101",
        "Economic Issues",
        "For the student who desires a general knowledge of economics. Applications of economic principles to current social and political problems.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256218",
        false,
        false
    ), (
    "EFC250",
        "Introduction to Education",
        "Introduction to teaching as career, foundations and overview of American public education, effective teachers, responsibilities of schools in democratic society, essential professional competences, preparation, and certification. Culturally anchored, and offers a framework of equity pedagogy.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259595",
        false,
        false
    ), (
    "GEOG250",
        "Resource Exploitation and Conservation",
        "Explores the historical, cultural, political, socio-economic perspectives of natural resource use, extraction, and sustainability at local to global scales. Students will examine resources and decision-making as citizens of campus, the Pacific Northwest, and the World. ",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256687",
        false,
        false
    ), (
    "HIST143",
        "United States History to 1865",
        "Survey of U.S. history from before contact to Civil War. Themes include pre-Columbian societies; colonization; epidemics and environmental change; slavery; the American Revolution and Constitution; the market revolution; Manifest Destiny; and the Civil War. SB-Perspectives on Cultures and Experiences of U.S. (W).",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256875",
        false,
        false
    ), (
    "HIST144",
        "United States History Since 1865",
        "U.S. history from Reconstruction to the present. Themes include Imperialism, Progressivism, World War I, Great Depression, World War II, the Civil Rights and Women’s Movements, the Vietnam War, recent U.S. foreign policy and political movements. ",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256876",
        false,
        false
    ), (
    "LAJ102",
        "Introduction to Law and Justice",
        "This course will focus on the role of law in society and will examine both the criminal and civil law system, as well as, the function of law in social change and social control. SB-Perspectives on Cultures and Experiences of U.S.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258153",
        false,
        false
    ), (
    "LIS245",
        "Research Methods in the Digital Age",
        "This course examines methods of information gathering and sharing in academic and social environments. Students explore applications of the research process, learn strategies for identifying and synthesizing information, and discuss research influences on scholarly conversations. Formerly LIS 345, students may not receive credit for both.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257128",
        false,
        false
    ), (
    "LLAS102",
        "An Introduction to Latino and Latin American Studies",
        "Introduction to the history, peoples, and cultures of Latin America and of the Latino/a population in the United States.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257130",
        false,
        false
    ), (
    "LLAS405",
        "Race, Latinidad and the Economy in the United States and Latin America",
        "The course is designed to provide understanding of how race is defined and perceived in the U.S and Latin America. Race and inequality are interconnected and integral in understanding the systemic inequalities present in society.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=261373",
        false,
        false
    ), (
    "MKT360",
        "Principles of Marketing",
        "Principles of marketing class for non-business majors. Explores the function and processes of marketing, introducing students to the fundamental marketing concepts.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257257",
        false,
        false
    ), (
    "POSC210",
        "American Politics",
        "Origin and development of the United States government; structure, political behavior, organizations, and processes; rights and duties of citizens.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257684",
        false,
        false
    ), (
    "PSY310",
        "Multicultural Psychology and Social Justice",
        "An examination of human behavior in cultural context emphasizing the role of culture on thought, behavior, relationships and society. Addresses the influences of identity differences on individuals and society. Examines cross-cultural theory, and methodology. ",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257751",
        false,
        false
    ), (
    "PUBH351",
        "Community Building Strategies for Public Health",
        "Introduces students to practical strategies designed to engage others in creating change that matters to them. Explores ideas, evidence, examples, and possibilities from the activist to the establishment.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256861",
        false,
        false
    ), (
    "SOC109",
        "Social Construction of Race",
        "Exploration of the social construction of race from antiquity to modern day. How did the idea of race come about? How did it evolve? What have been the social consequences of the idea of race?",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256531",
        false,
        false
    ), (
    "SUST301",
        "Introduction to Sustainability",
        "Students will learn about a variety of concepts related to sustainable development and sustainable environments. Emphasis will be placed on literature focusing on implementation of sustainability projects at local scales.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259659",
        false,
        false
    ), (
    "WGSS201",
        "Introduction to Women’s, Gender, and Sexuality Studies",
        "An interdisciplinary exploration how gender and sexuality impact people’s lives both historically and in contemporary society. Gender related issues are examined through social, political, economic, and cultural issues and processes influencing societies, communities, and individuals. SB-Perspectives on Cultures and Experiences of U.S. (W). Meets the General Education writing requirement.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258143",
        false,
        false
    ), (
    "DHC150",
        "Aesthetic Experience",
        "Variable topic. Courses in this area explore questions about the nature of art; to understand, interrogate, and engage in the creative process; and to explore the connections between art, culture, and history.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256196",
        false,
        false
    ), (
    "DNCE161",
        "Cultural History of Dance",
        "A comprehensive look at the global dynamics of dance, examining the diverse cultural traditions and the innovations that have advanced dance into the 21st century. AH-Aesthetic Experience",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257520",
        false,
        false
    ), (
    "ENG264",
        "Introduction to Creative Writing and the Environment",
        "An introduction to the creative writing genres: poetry, fiction, screenwriting, and creative nonfiction as they are applied to place and the environment. Examines the rhetorical forms and expectations of each in a workshop format.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259643",
        false,
        false
    ), (
    "FILM150",
        "Film Appreciation",
        "Introduction to the art of film, through screenings, lectures, discussions, quizzes, and online discussion posts. Emphasis will be placed on traditional “Hollywood-style” films as well as independent, foreign, avant-garde, documentary, and short films. ",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259606",
        false,
        false
    ), (
    "MUS101",
        "History of Jazz",
        "History of artistic, cultural, and technological developments in jazz, focusing on important players and performances. Introduction to fundamental musical concepts and methods; emphasis on active listening, social justice, current issues. ",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257291",
        false,
        false
    ), (
    "MUS103",
        "History of Rock and Roll",
        "History of Rock and Roll, America’s second indigenous musical art form, after jazz. Emphasis placed on artists, music genres, and cultural/societal forces shaping rock’s evolution, 1950s to present. Extensive listening, reading; required online discussion.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257293",
        false,
        false
    ), (
    "TH101",
        "Appreciation of Theatre and Film",
        "Viewing, discussing, and comparing film and live theatre performance. AH-Aesthetic Experience.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258032",
        false,
        false
    ), (
    "TH107",
        "Introduction to Theatre",
        "Overview of the basic elements of the theatre arts and dramatic structure, and the environment for production of plays. Attendance at assigned outside events is required.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258033",
        false,
        false
    ), (
    "ANTH130",
        "Cultural Worlds",
        "The cross-cultural and holistic study of humans worldwide, including the analysis of race, gender, power, kinship, globalization, and the role of symbols in social life. Students will also examine their own world through anthropological lenses. SB-Perspectives on World Cultures.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255644",
        false,
        false
    ), (
    "AST102",
        "Introduction to Asian Studies",
        "An interdisciplinary introduction to the study of Asia; emphasizing geography, history, culture, and economics.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255806",
        false,
        false
    ), (
    "COM302",
        "Intercultural Communication",
        "The objective of this course is to give the participants the skills and understanding necessary to improve communication with peoples of other nations and cultures.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256070",
        false,
        false
    ), (
    "ECON202",
        "Principles of Economics Macro",
        "Organization of the U.S. economy, structure, and role of the monetary system, problems of employment and inflation, overall impact of government spending and taxation on the economy. Economic growth, world economic problems, and a comparison of capitalism with other economic systems.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256221",
        false,
        false
    ), (
    "EDLT217",
        "Exploring Global Dynamics through Children’s and Adolescent Literature",
        "Interdisciplinary connections with critical analysis of global and international children’s/adolescent literature are explored. Comparisons across contemporary, historical, social, political, and economic issues through global and international children’s/adolescent literature read and discussed. ",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259593",
        false,
        false
    ), (
    "ENG347",
        "Global Perspectives in Literature",
        "An introduction to contemporary non-western and postcolonial literature.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256461",
        false,
        false
    ), (
    "ENST310",
        "Energy and Society",
        "Through classroom and field experience, students will examine society’s use of and dependence upon energy. Students will become more discerning citizens, able to take part in local, national, and global energy discussions. ",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256519",
        false,
        false
    ), (
    "GEOG101",
        "World Regional Geography",
        "An introduction to the dynamic landscapes of the world’s major regions, examining socioeconomic, political, demographic, cultural and environmental patterns, processes, and issues. ",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256683",
        false,
        false
    ), (
    "GERM200",
        "Introduction to German Culture",
        "The course examines major events, social movements, and cultural debates that situate contemporary German culture in historical global perspectives.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=260042",
        false,
        false
    ), (
    "HIST101",
        "World History to 1500",
        "Origins and development of the major world civilizations to the 15th century. A comparative study of their political, social, and economic institutions, and their religious and intellectual backgrounds.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256872",
        false,
        false
    ), (
    "HIST103",
        "World History Since 1815",
        "A comparative survey of political, social, economic, and cultural developments in world history since 1815",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256874",
        false,
        false
    ), (
    "KRN311",
        "Korean Cinema and Visual Culture",
        "This course examines the cultural history of Korean cinema and visual culture, with a specific emphasis on contemporary youth and popular culture, including K-Pop, international Korean blockbusters, and manhwa (comics) among others.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259901",
        false,
        false
    ), (
    "MUS105",
        "Introduction to World Music",
        "An interdisciplinary exploration of the many roles played by music in traditional societies, with emphasis on music’s social functions, life contexts, and influence on self-identity. ",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258634",
        false,
        false
    ), (
    "PHIL106",
        "Asian Philosophy",
        "Examination of selected classical and/or contemporary issues and questions in Chinese, Japanese and Indian philosophy.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257609",
        false,
        false
    ), (
    "POSC270",
        "International Relations",
        "This course explores political issues and theories in international relations. This class will focus on issues of war and peace, international law and organization, foreign policy, diplomatic history, and international political economy",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257687",
        false,
        false
    ), (
    "RELS103",
        "World Mythologies",
        "An overview of world mythology and the contemporary study of myths: their nature, functions, symbolism, and uses; their cultural contexts, artistic expressions, and influence on contemporary life. ",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258936",
        false,
        false
    ), (
    "WLC311",
        "Popular Cultures of the World",
        "This online course examines popular culture as a reflection of ideologies and value systems in different societies and cultural contexts. Course will not have an established scheduling pattern.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258504",
        false,
        false
    ), (
    "DHC140",
        "Humanistic Understanding",
        "Courses in the humanities focuses on the analysis and interpretation of human stories of the past, present, and future in order to understand the processes of continuity and change in individuals and cultures through both documented and imaginative accounts.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256194",
        false,
        false
    ), (
    "HIST102",
        "World History: 1500-1815",
        "A comparative survey of political, social, economic, and cultural developments in world history from 1500-1815.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256873",
        false,
        false
    ), (
    "HIST301",
        "Pacific Northwest History",
        "Exploration and settlement; subsequent political, economic, and social history with particular emphasis on Washington.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256878",
        false,
        false
    ), (
    "HUM101",
        "Exploring Cultures in the Ancient World",
        "An interdisciplinary exploration from literature, history, philosophy, and the arts of selected major ancient civilizations in Asia, Africa, Europe, and/or the Americas from their beginnings through the 15th century.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256943",
        false,
        false
    ), (
    "HUM103",
        "Exploring Cultures in Modern and Contemporary Societies",
        "An interdisciplinary exploration of literature, history, philosophy, and the arts of selected world civilizations from the 20th century to the present.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256945",
        false,
        false
    ), (
    "LAJ215",
        "Law in American History",
        "This course explores the role of law in American society from 1789 to 1939, including connections between law and violence, economics, politics, culture, gender and ethnicity.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259558",
        false,
        false
    ), (
    "MGT395",
        "Leadership in Business Organizations",
        "Examination of theories and practices of leadership in business organizations.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257249",
        false,
        false
    ), (
    "PHIL101",
        "Philosophical Inquiry",
        "Introduces students to the basic concepts, questions, and methods of philosophical inquiry. Topics may include free will and responsibility, knowledge and skepticism, the nature of the divine, moral reasoning, and human rights and social justice.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257606",
        false,
        false
    ), (
    "PHIL104",
        "Moral Controversies",
        "An introduction to moral reasoning through the study of current ethical problems. Topics may include abortion, capital punishment, consumerism, immigration, sexual ethics, killing in war, and/or torture.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257610",
        false,
        false
    ), (
    "RELS101",
        "World Religions",
        "Survey of the major world religions (Judaism, Christianity, Islam, Hinduism, Buddhism, Confucianism, Daoism), including their tenets, practices, and evaluation of the human condition.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257800",
        false,
        false
    ), (
    "TH382",
        "Diverse Experiences in American Drama",
        "A study of contemporary plays by and/or about People of the Global Majority and their experiences in the United States of America. Titles and focus will change responsively to encompass contemporary ideas and artistic work.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258092",
        false,
        false
    ), (
    "AIS101",
        "American Indian Culture before European Contact",
        "An interdisciplinary approach explores the lifeways and environments of American Indians prior to European contact and settlement. Sources of pre-contact information consist of the archaeological, oral history, and paleoenvironmental records.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255631",
        false,
        false
    ), (
    "ANTH107",
        "Being Human: Past and Present",
        "Exploration of being human throughout the world from the earliest human ancestors to today using archaeological, biological, cultural and linguistic anthropology methods and perspectives.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255641",
        false,
        false
    ), (
    "ANTH180",
        "Language and Culture",
        "This course is an introduction to the scientific and anthropological study of language, concerning its structure and function as an omnipresent system in communication, cognition, and socialization, and its relationship with culture, society, and power. ",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255645",
        false,
        false
    ), (
    "ASP305",
        "Accessibility and User Experience",
        "Issues of accessibility in everyday quality of life experiences. Models of disability. disability etiquette. Changes in laws and attitudes toward inclusion. Current careers requiring competence in troubleshooting accessibility.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258901",
        false,
        false
    ), (
    "ATM281",
        "Socio-cultural Aspects of Apparel",
        "Clothing in relation to individual and group behavior patterns; personal and social meanings attributed to dress; and cultural patterns of technology, aesthetics, ritual, morality, and symbolism.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259707",
        false,
        false
    ), (
    "CDFS101",
        "Skills for Marriage and Intimate Relationships",
        "Provides an overview of romantic relationship dynamics and common issues in relationships from inception to dissolution. Students learn strategies for their own relationships and skills to work in relationship education.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256650",
        false,
        false
    ), (
    "CDFS234",
        "Contemporary Families",
        "Origins and historical development of families; cultural variations, contemporary trends. Draws upon information and insight from numerous root disciplines to explore family structure and function.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256652",
        false,
        false
    ), (
    "DHC250",
        "Social and Behavioral Dynamics",
        "Variable Topic. Courses focus on how individuals, cultures, and societies operate and evolve and introduce disciplined ways of thinking about individuals and groups. May be repeated for credit under a different topic",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256200",
        false,
        false
    ), (
    "ECON201",
        "Principles of Economics Micro",
        "Introduction to standard economic models used to examine how individuals and firms make decisions under different market structures; role of government in the economy in addressing market failure and efficiency equity tradeoff. ",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256220",
        false,
        false
    ), (
    "GEOG208",
        "Our Human World",
        "Explores the historical diffusion and contemporary spatial distribution of cultures, religions, and languages. Evaluates how these features interact with economic and political systems to create distinctive places at scales ranging from local to global.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256685",
        false,
        false
    ), (
    "HED101",
        "Essentials for Healthy Living",
        "Essentials for healthy living is a survey course designed to give the student the practical and theoretical knowledge necessary to apply principles of overall wellness in the pursuit of a healthier lifestyle. ",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256834",
        false,
        false
    ), (
    "HRM381",
        "Management of Human Resources",
        "Selection of personnel, methods of training and retraining workers, wage policy, utilization of human resources, job training, administration of labor contracts, and public relations.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256937",
        false,
        false
    ), (
    "IDS357",
        "Race, Drugs and Prohibition in the U.S.: What Makes Drug Use Criminal?",
        "Marijuana, cocaine, coffee and sugar. Why are some drugs “good” and some “bad?” Explore the “Drug War,” motivations for regulation, current dilemmas and social justice implications in the United States, from an interdisciplinary approach.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259612",
        false,
        false
    ), (
    "LAJ216",
        "Race, Gender and Justice",
        "This course examines the role of race/ethnicity and gender in law and public policy with an emphasis on criminal justice.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259657",
        false,
        false
    ), (
    "MGT380",
        "Organizational Management",
        "Principles of management class for non-business majors. Introduces students to the history and development of management ideas and contemporary practice. Overview of all the major elements of the managerial function",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257242",
        false,
        false
    ), (
    "MGT386",
        "Principles of Organizational Behavior",
        "Applied and conceptual analysis of behavior within organizations. Involves leadership, motivation, communications, group processes, decision-making, climate, and culture.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257246",
        false,
        false
    ), (
    "POSC101",
        "Introduction to Politics",
        "This course explores the meanings of power, political actors, resources of power and how they are being used for what purposes, under what ideological, institutional and policy processes affecting our quality of life.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257683",
        false,
        false
    ), (
    "POSC260",
        "Comparative Politics",
        "Comparative political analysis, utilizing a variety of methods and theoretical approaches; application to selected western and non-western systems. Recommended to precede other courses in comparative politics.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257686",
        false,
        false
    ), (
    "PSY101",
        "General Psychology",
        "The study of the basic principles, problems and methods that underlie the science of psychology, including diversity, human development, biological bases of behavior, learning, sensation and perception, cognition, personality, and psychopathology.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257739",
        false,
        false
    ), (
    "PSY242",
        "Psychology of Video Games",
        "This course outlines many foundational theories of psychology within the lens of video games. Students will examine psychological concepts present in video games and how knowledge of psychology can improve the gaming experience.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259633",
        false,
        false
    ), (
    "SOC101",
        "Social Problems",
        "An introduction to the study of contemporary issues such as poverty, military policies, families, crime, aging, racial, ethnic conflict, and the environment.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257940",
        false,
        false
    ), (
    "SOC107",
        "Principles of Sociology",
        "An introduction to the basic concepts and theories of sociology with an emphasis on the group aspects of human behavior.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257941",
        false,
        false
    ), (
    "SOC307",
        "Individual and Society",
        "An analysis of the relationship between social structure and the individual.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257947",
        false,
        false
    ), (
    "STP300",
        "Inquiry Approaches to Teaching and Lesson Design",
        "In this field-based introductory course, students observe, experience, and describe essential components of effective STEM teaching in grades K-12. Students also design and teach lessons that implement essential components of content, equity, and professional practice. Course Requires liability insurance and current WSP/FBI fingerprints that do not expire before end of quarter.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259000",
        false,
        false
    ), (
    "WGSS250",
        "Introduction to Queer Studies",
        "An interdisciplinary introduction to queer studies, investigating the historical and contemporary reality of those who identify as gay, lesbian, bisexual, transgender, and/or queer.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258320",
        false,
        false
    ), (
    "BIOL101",
        "Fundamentals of Biology",
        "Introduction to scientific inquiry and basic principles of biology at molecular, cellular, organismal, community, and ecosystem levels as applied to humans, society, and the environment. Four hours lecture and one two-hour laboratory per week.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255875",
        false,
        false
    ), (
    "CHEM111",
        "Introduction to Chemistry",
        "Chemical principles of the compositions, structure, properties, and changes of matter. Designed for students in certain health science programs.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255965",
        false,
        false
    ), (
    "CHEM111LAB",
        "Introductory Chemistry Laboratory",
        "Introduction to basic chemistry techniques. Two hours laboratory weekly. Combined with CHEM 111 lecture satisfies Physical and Natural World, Ways of Knowing.",
        1,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255966",
        false,
        false
    ), (
    "CHEM181",
        "General Chemistry I",
        "This course introduces chemistry concepts such as atoms and molecules, stoichiometry, solution chemistry, thermochemistry, electronic structure of the atom and periodicity, and chemical bonding.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255971",
        false,
        false
    ), (
    "CHEM181LAB",
        "General Chemistry Laboratory I",
        "This laboratory supports hands-on, inquiry-based approaches to exploring topics presented in CHEM 181. Three hours of laboratory weekly.",
        1,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255972",
        false,
        false
    ), (
    "ENST201",
        "Earth as an Ecosystem",
        "Introduction to the concept of our planet as a finite environment with certain properties essential for life and will explore dynamic nature of the earth’s physical, chemical, geological, and biological processes and their interrelated “systems”.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256513",
        false,
        false
    ), (
    "EXSC154",
        "Science of Healthy Living",
        "Science of Healthy Living (5 credits) is a lecture (4 hours) and in-person laboratory (2 hours) course, that analyzes and evaluates current theories and practices related to healthy living, focusing on translating theory to practice. ",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259605",
        false,
        false
    ), (
    "GEOG107",
        "Our Dynamic Earth",
        "The complex weather, climate, water, landforms, soils, and vegetation comprising Earth’s physical environments over space and time. Incorporates map interpretation and scientific analysis in understanding various landscapes and human impacts upon those landscapes. ",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256684",
        false,
        false
    ), (
    "GEOL101",
        "Introduction to Geology",
        "An introduction to geology emphasizing the origin and nature of the common rocks, plate tectonic theory, earthquake and volcanoes, and geologic time. Includes weekly labs.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256750",
        false,
        false
    ), (
    "GEOL107",
        "Earth’s Changing Surface",
        "The role of natural geologic processes in shaping the earth’s surface; includes hydrologic cycle, rivers and flooding, landslides, coastal processes, and climate cycles. Four hour lecture per week plus required field trips.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256754",
        false,
        false
    ), (
    "PHYS101",
        "Introductory Astronomy I",
        "An inquiry-based introduction to celestial motions, celestial objects, observational astronomy and the physics associated with each. Emphasis on stars and planets.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257642",
        false,
        false
    ), (
    "PHYS106",
        "Physics Inquiry",
        "An introduction to fundamental physics topics highlighting applications to the world around us. There will be an emphasis on learning by inquiry and on designing and critiquing solutions to real world issues.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257645",
        false,
        false
    ), (
    "SCED101",
        "Integrated Life Science",
        "Inquiry-based investigations into life science to help students develop understanding of fundamental concepts and the process of scientific investigation. This course is designed for prospective elementary teachers but is open to all students.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258327",
        false,
        false
    ), (
    "ACCT301",
        "Accounting Skills for Non-Accounting Majors",
        "An overview of accounting, tax, and finance from the viewpoint of the financial statement user. Students will learn basic financial language and analysis skills for assessing enterprise performance. Customized topics for students in various majors. ",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255563",
        false,
        false
    ), (
    "ANTH120",
        "Archaeology: Science of the Past",
        "Introduction to the concepts, methods, and development of archaeology, as well as key discoveries from the ancient world.  Illustrations of how fields of science are combined to uncover past human achievements and diverse cultures.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255643",
        false,
        false
    ), (
    "BIOL201",
        "Human Physiology",
        "An introduction to the function of human cells, organs, and organ systems as it relates to health and well-being current developments, and society.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255880",
        false,
        false
    ), (
    "BIOL300",
        "Introduction to Evolution",
        "An introduction to the Darwinian theory of evolution. Exploration of the mechanisms of evolutionary change, speciation, and macroevolutionary patterns of the evolution of life on Earth including humans.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255885",
        false,
        false
    ), (
    "ETSC101",
        "Modern Technology and Energy",
        "A study of how basic scientific principles are applied daily in industrial societies through a survey of transportation, energy and power, construction, and consumer product technologies.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256953",
        false,
        false
    ), (
    "GEOL108",
        "Earth and Energy Resources",
        "Exploration of the earth’s mineral and energy resources, how they are formed, harnessed, and the environmental impacts of their extraction and use. NS-Applications Natural Science.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256755",
        false,
        false
    ), (
    "GEOL302",
        "Oceans and Atmosphere",
        "Introduction to Earth’s climate and the hydrologic cycle through study of the ocean-atmosphere system. Chemical and physical changes will be studied over time scales ranging from millions of years to days. Will include a field trip. NS-Patterns and Connections Natural World.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256758",
        false,
        false
    ), (
    "IEM302",
        "Energy, Environment, and Climate Change",
        "The course examines the physical principles behind climate change science and how they relate to energy and resource use on our planet. Emphasis placed on examining how energy decisions impact past, present, and future climates. ",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258575",
        false,
        false
    ), (
    "IT202",
        "Change Ready: Technology Skills for Civic and Community Leaders",
        "Learn to maximize software applications and collaborative tools to support community and civic projects. Emphasis on using technology to facilitate project design, organization, communication, presentation, and building stakeholder support.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259753",
        false,
        false
    ), (
    "NUTR101",
        "Introduction to Human Nutrition",
        "Fundamental nutritional concepts as related to health. Four hours lecture and one hour discussion per week.",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257428",
        false,
        false
    ), (
    "PUBH320",
        "Environmental Health",
        "Examines environments, agents, and outcomes related to human and ecosystem health. Explores basic toxicology and environmental epidemiology principles; behavioral, social, economic, and political factors; scientific and technological advances; and sustainability issues and strategies.",
        4,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256844",
        false,
        false
    ), (
    "SHM102",
        "Occupational Health",
        "Explore the fundamental concepts of occupational health, including identification of health hazards in the work place, prevention of work place injuries and illnesses, human factors, and environmental health as it relates to the workplace",
        5,
        "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259571",
        false,
        false
    )
;

INSERT INTO majorReqs VALUES
	('Computer Science', 'CS110', 'major'),
    ('Computer Science', 'CS111', 'major'),
    ('Computer Science', 'CS112', 'major'),
    ('Computer Science', 'CS301', 'major'),
    ('Computer Science', 'CS302', 'major'),
    ('Computer Science', 'CS311', 'major'),
    ('Computer Science', 'CS312', 'major'),
    ('Computer Science', 'CS325', 'major'),
    ('Computer Science', 'CS361', 'major'),
    ('Computer Science', 'CS362', 'major'),
    ('Computer Science', 'CS380', 'major'),
    ('Computer Science', 'CS392', 'major'),
    ('Computer Science', 'CS420', 'major'),
    ('Computer Science', 'CS427', 'major'),
    ('Computer Science', 'CS450', 'major'),
    ('Computer Science', 'CS470', 'major'),
    ('Computer Science', 'CS480', 'major'),
    ('Computer Science', 'CS481', 'major'),
    ('Computer Science', 'CS489', 'major'),
    ('Computer Science', 'CS492', 'major'),
    ('Computer Science', 'MATH172', 'major'),
    ('Computer Science', 'MATH173', 'major'),
    ('Computer Science', 'MATH260', 'major'),
    ('Computer Science', 'MATH330', 'major')
;

INSERT INTO preReqs VALUES
	('CS111', 'CS110'),
    ('CS111', 'MATH153'),
    ('CS301', 'CS111'),
    ('CS301', 'MATH154'),
    ('CS302', 'AW2'),
    ('CS302', 'CS111'),
    ('CS302', 'CS301'),
    ('CS302', 'MATH172'),
    ('CS311', 'CS111'),
    ('CS312', 'CS301'),
    ('CS312', 'CS311'),
    ('CS312', 'CS325'),
    ('CS325', 'AW2'),
    ('CS325', 'CS111'),
    ('CS361', 'CS302'),
    ('CS362', 'CS361'),
    ('CS362', 'MATH260'),
    ('CS380', 'CS325'),
    ('CS392', 'CS361'),
    ('CS420', 'CS302'),
    ('CS420', 'CS325'),
    ('CS420', 'MATH260'),
    ('CS427', 'CS302'),
    ('CS427', 'MATH330'),
    ('CS450', 'AW2'),
    ('CS450', 'CS301'),
    ('CS450', 'CS311'),
    ('CS450', 'CS325'),
    ('CS450', 'MATH172'),
    ('CS470', 'CS302'),
    ('CS470', 'CS312'),
    ('CS470', 'CS361'),
    ('CS480', 'CS380'),
    ('CS480', 'CS420'),
    ('CS481', 'CS480'),
    ('CS489', 'CS480'),
    ('CS492', 'CS392'),
    ('MATH154', 'MATH153'),
    ('MATH172', 'MATH154'),
    ('MATH173', 'MATH172'),
    ('MATH260', 'MATH173'),
    ('MATH330', 'MATH260')  
;

INSERT INTO students VALUES 
    ('0000000000', 'examplestudent', 'examplestudent@gmail.com', 'password123$', 'Computer Science', NULL, 'John', 'Doe', 'M')
;
	
INSERT INTO studentTaken VALUES
	('0000000000', 'CS110'),
    ('0000000000', 'CS111'),
    ('0000000000', 'MATH153')
;

INSERT INTO studentPlan VALUES
	('0000000000', 'Spring', 'CS301', 'MATH154', 'AW1', NULL, NULL, NULL)
;

SET FOREIGN_KEY_CHECKS=1;

