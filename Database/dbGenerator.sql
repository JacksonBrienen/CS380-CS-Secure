/* WARNING THIS FILE WILL DELETE ALL EXISTING DATABASE DATA, DO NOT RUN IF DATA NEEDS TO BE SAVED */

DROP SCHEMA IF EXISTS `db` ;

/* Init Data Base */
CREATE SCHEMA IF NOT EXISTS `db` DEFAULT CHARACTER SET utf8 ;
USE `db` ;

/* Sets up major/minor plan */
CREATE TABLE IF NOT EXISTS `db`.`plans` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `planName` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


/* basic student information */
CREATE TABLE IF NOT EXISTS `db`.`student` (
  `sid` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(256) NOT NULL,
  `password` VARCHAR(512) NOT NULL,
  `planId` INT NOT NULL,
  PRIMARY KEY (`sid`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `student_planId_fk_idx` (`planId` ASC) VISIBLE,
  CONSTRAINT `student_planId_fk`
    FOREIGN KEY (`planId`)
    REFERENCES `db`.`plans` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


/* Inits courses, this will hold all courses regardless of if they are genEd, majorRequirement, or else */
CREATE TABLE IF NOT EXISTS `db`.`course` (
  `id` VARCHAR(16) NOT NULL,
  `name` VARCHAR(128) NOT NULL,
  `description` VARCHAR(1024) NOT NULL,
  `link` VARCHAR(128) NOT NULL,
  `credits` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


/* db for only multicourse courses and the courses they contain */
CREATE TABLE IF NOT EXISTS `db`.`multicourse` (
  `id` VARCHAR(16) NOT NULL,
  `courseList` INT NOT NULL,
  `courseIndex` INT NOT NULL,
  `courseId` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`courseList`, `id`, `courseIndex`),
  INDEX `mutlicourse_course_id_fk_idx` (`courseId` ASC) VISIBLE,
  CONSTRAINT `multicourse_id_fk`
    FOREIGN KEY (`id`)
    REFERENCES `db`.`course` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `mutlicourse_course_id_fk`
    FOREIGN KEY (`courseId`)
    REFERENCES `db`.`course` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


/* db for courses who have prereqs and their prereq lists */
CREATE TABLE IF NOT EXISTS `db`.`prereq` (
  `id` VARCHAR(16) NOT NULL,
  `courseList` INT NOT NULL,
  `courseIndex` INT NOT NULL,
  `courseId` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`id`, `courseList`, `courseIndex`),
  INDEX `prereq_course_fk_idx` (`courseId` ASC) VISIBLE,
  CONSTRAINT `prereq_id_fk`
    FOREIGN KEY (`id`)
    REFERENCES `db`.`course` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `prereq_course_fk`
    FOREIGN KEY (`courseId`)
    REFERENCES `db`.`course` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


/* db for genEd courses, can include multicourses */
CREATE TABLE IF NOT EXISTS `db`.`genEd` (
  `courseId` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`courseId`),
  CONSTRAINT `genEd_courseId_pk`
    FOREIGN KEY (`courseId`)
    REFERENCES `db`.`course` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


/* courses that are for a specific 'plan' or major requirement */
CREATE TABLE IF NOT EXISTS `db`.`planReq` (
  `planId` INT NOT NULL,
  `courseId` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`planId`, `courseId`),
  INDEX `plan_courseId_fk_idx` (`courseId` ASC) VISIBLE,
  CONSTRAINT `plan_planId_fk`
    FOREIGN KEY (`planId`)
    REFERENCES `db`.`plans` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `plan_courseId_fk`
    FOREIGN KEY (`courseId`)
    REFERENCES `db`.`course` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


/* table for a students currently selected fall classes */
CREATE TABLE IF NOT EXISTS `db`.`fall` (
  `sid` INT NOT NULL,
  `course` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`sid`, `course`),
  INDEX `fall_course_fk_idx` (`course` ASC) VISIBLE,
  CONSTRAINT `fall_sid_fk`
    FOREIGN KEY (`sid`)
    REFERENCES `db`.`student` (`sid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fall_course_fk`
    FOREIGN KEY (`course`)
    REFERENCES `db`.`course` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

/* table for a students currently selected winter classes */
CREATE TABLE IF NOT EXISTS `db`.`winter` (
  `sid` INT NOT NULL,
  `course` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`sid`, `course`),
  INDEX `fall_course_fk_idx` (`course` ASC) VISIBLE,
  CONSTRAINT `winter_sid_fk`
    FOREIGN KEY (`sid`)
    REFERENCES `db`.`student` (`sid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `winterl_course_fk`
    FOREIGN KEY (`course`)
    REFERENCES `db`.`course` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

/* table for a students currently selected spring classes */
CREATE TABLE IF NOT EXISTS `db`.`spring` (
  `sid` INT NOT NULL,
  `course` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`sid`, `course`),
  INDEX `fall_course_fk_idx` (`course` ASC) VISIBLE,
  CONSTRAINT `spring_sid_fk`
    FOREIGN KEY (`sid`)
    REFERENCES `db`.`student` (`sid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `spring_course_fk`
    FOREIGN KEY (`course`)
    REFERENCES `db`.`course` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

/* table for a students currently selected summer classes */
CREATE TABLE IF NOT EXISTS `db`.`summer` (
  `sid` INT NOT NULL,
  `course` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`sid`, `course`),
  INDEX `fall_course_fk_idx` (`course` ASC) VISIBLE,
  CONSTRAINT `summer_sid_fk`
    FOREIGN KEY (`sid`)
    REFERENCES `db`.`student` (`sid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `summer_course_fk`
    FOREIGN KEY (`course`)
    REFERENCES `db`.`course` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

/* table for a students currently selected completed classes */
CREATE TABLE IF NOT EXISTS `db`.`completed` (
  `sid` INT NOT NULL,
  `course` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`sid`, `course`),
  INDEX `fall_course_fk_idx` (`course` ASC) VISIBLE,
  CONSTRAINT `completed_sid_fk`
    FOREIGN KEY (`sid`)
    REFERENCES `db`.`student` (`sid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `completed_course_fk`
    FOREIGN KEY (`course`)
    REFERENCES `db`.`course` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

/* table for which course(s) a student has selected for a multicourse */
CREATE TABLE IF NOT EXISTS `db`.`multicourseSelection` (
  `sid` INT NOT NULL,
  `mutlicourse` VARCHAR(16) NOT NULL,
  `course` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`sid`, `mutlicourse`),
  INDEX `mutlicourseSelection_multicourse_fk_idx` (`mutlicourse` ASC) VISIBLE,
  INDEX `multicourseSelection_course_fk_idx` (`course` ASC) VISIBLE,
  CONSTRAINT `mutlicourseSelection_multicourse_fk`
    FOREIGN KEY (`mutlicourse`)
    REFERENCES `db`.`multicourse` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `multicourseSelection_student_fk`
    FOREIGN KEY (`sid`)
    REFERENCES `db`.`student` (`sid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `multicourseSelection_course_fk`
    FOREIGN KEY (`course`)
    REFERENCES `db`.`multicourse` (`courseId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

/* Insert all school data into the db
   Initially ran with FK checks on to ensure database functionality 
 */
SET FOREIGN_KEY_CHECKS=0;
INSERT INTO db.plans (planName) VALUES ("Computer Science B.S.");
INSERT INTO db.course VALUES ("CS110", "Programming Fundamentals I", "Fundamental concepts of programming from an object-oriented perspective. Classes, objects and methods, algorithm development, problem-solving techniques, basic control structures, primitive types and arrays.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256150", 4);
INSERT INTO db.planReq VALUES (1, "CS110");
INSERT INTO db.course VALUES ("CS111", "Programming Fundamentals II", "Continuation of object-oriented programming concepts introduced in CS 110. Inheritance, exceptions, graphical user interfaces, recursion, and data structures.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256151", 4);
INSERT INTO db.planReq VALUES (1, "CS111");
INSERT INTO db.course VALUES ("CS112", "Introduction to Data Science in Python", "This course is an introduction to the Python programming language with the following Data Science topics; data pre-processing, working with categorical and textual data, data parsing, data and natural language processing and data visualization.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256152", 4);
INSERT INTO db.planReq VALUES (1, "CS112");
INSERT INTO db.course VALUES ("CS301", "Data Structures", "Introduction to elementary data structures (arrays, lists, stacks, queues, deques, binary trees) and their Java implementation as abstract data types.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256156", 4);
INSERT INTO db.planReq VALUES (1, "CS301");
INSERT INTO db.course VALUES ("CS302", "Advanced Data Structures and File Processing", "Introduction to non-linear data structures (balanced search trees, priority queues, graphs, maps, sets, hashing data structures), their Java implementations as abstract data types, and basic algorithms (sorting, greedy, graph algorithms).", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256157", 4);
INSERT INTO db.planReq VALUES (1, "CS302");
INSERT INTO db.course VALUES ("CS311", "Computer Architecture I", "Introduction to computer architecture, data representations, assembly language, addressing techniques. Course will be offered every year. Course will not have an established scheduling pattern.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256158", 4);
INSERT INTO db.planReq VALUES (1, "CS311");
INSERT INTO db.course VALUES ("CS312", "Computer Architecture II", "Introduction to the structure of computers. Digital circuits, central processing units, memory, input/output processing, parallel architectures. Course will be offered every year.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256159", 4);
INSERT INTO db.planReq VALUES (1, "CS312");
INSERT INTO db.course VALUES ("CS325", "Technical Writing in Computer Science", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256160", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256160", 4);
INSERT INTO db.planReq VALUES (1, "CS325");
INSERT INTO db.course VALUES ("CS361", "Principles of Language Design I", "Topics will include evolution of programming languages, syntax and semantics, bindings, scoping, data types, assignment, control, and subprograms.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256163", 4);
INSERT INTO db.planReq VALUES (1, "CS361");
INSERT INTO db.course VALUES ("CS362", "Principles of Language Design II", "Topics will include abstract data types, parallel processing, object-oriented programming, exception handling functional programming, and logic programming. Course will be offered every year. Course will not have an established scheduling pattern.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256164", 4);
INSERT INTO db.planReq VALUES (1, "CS362");
INSERT INTO db.course VALUES ("CS380", "Introduction to Software Engineering", "An introduction to the principles and practices of software engineering, including object-oriented analysis and design, design patterns, and testing. Course will not have an established scheduling pattern.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256179", 4);
INSERT INTO db.planReq VALUES (1, "CS380");
INSERT INTO db.course VALUES ("CS392", "Practical Experience in Debugging Computer Code", "Mentored experience in applying techniques and providing feedback for debugging computer code.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256167", 1);
INSERT INTO db.planReq VALUES (1, "CS392");
INSERT INTO db.course VALUES ("CS420", "Database Management Systems", "Logical aspects of database processing; concepts of organizing data into integrated databases; hierarchical, network, and relational approaches.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256168", 4);
INSERT INTO db.planReq VALUES (1, "CS420");
INSERT INTO db.course VALUES ("CS427", "Algorithm Analysis", "Topics will include basic algorithmic analysis, algorithmic strategies, fundamental computing algorithms, basic computability, the complexity classes P and NP, and advanced algorithmic analysis.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256169", 4);
INSERT INTO db.planReq VALUES (1, "CS427");
INSERT INTO db.course VALUES ("CS450", "Computer Network and Data Communications", "The course deals with networking and data communication utilizing the concepts of device and network protocols, network configurations, encryption, data compression and security.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256175", 4);
INSERT INTO db.planReq VALUES (1, "CS450");
INSERT INTO db.course VALUES ("CS470", "Operating Systems", "Topics will include principles of operating systems, concurrency, scheduling and dispatch, memory management, processes and threads, device management, security and protection, and file systems.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256180", 4);
INSERT INTO db.planReq VALUES (1, "CS470");
INSERT INTO db.course VALUES ("CS480", "Advanced Software Engineering", "Advanced principles and practices of software engineering, including project management, requirements gathering and specification, design, coding, testing, maintenance and documentation. Students work in teams to develop a large software project.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256182", 4);
INSERT INTO db.planReq VALUES (1, "CS480");
INSERT INTO db.course VALUES ("CS481", "Capstone Project", "The computer science capstone project and culminating experience. Students will work in teams to develop and deploy a project reflecting an objective in the computer science field dealing with either industrial or research aspects.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256183", 4);
INSERT INTO db.planReq VALUES (1, "CS481");
INSERT INTO db.course VALUES ("CS489", "Senior Colloquium", "Investigation of ethical and historical topics provides a culminating experience in computer science. Students make connections between computer science and their General Education experiences. Concepts, principles and knowledge in the field are assessed.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256184", 1);
INSERT INTO db.planReq VALUES (1, "CS489");
INSERT INTO db.course VALUES ("CS492", "Laboratory Experience in Teaching Computer Science", "Supervised progressive experience in developing procedures and techniques in teaching computer science.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256187", 2);
INSERT INTO db.planReq VALUES (1, "CS492");
INSERT INTO db.course VALUES ("MATH153", "Pre-Calculus Mathematics I", "A foundation course which stresses those algebraic and elementary function concepts together with the manipulative skills essential to the study of calculus.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257139", 5);
INSERT INTO db.course VALUES ("MATH154", "Pre-Calculus Mathematics II", "A continuation of MATH 153 with emphasis on trigonometric functions, vectors, systems of equations, the complex numbers, and an introduction to analytic geometry.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257140", 5);
INSERT INTO db.course VALUES ("MATH172", "Calculus I", "Theory, techniques, and applications of differentiation and integration of the elementary functions.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257143", 5);
INSERT INTO db.planReq VALUES (1, "MATH172");
INSERT INTO db.course VALUES ("MATH173", "Calculus II", "Theory, techniques, and applications of differentiation and integration of the elementary functions.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257144", 5);
INSERT INTO db.planReq VALUES (1, "MATH173");
INSERT INTO db.course VALUES ("MATH260", "Sets and Logic", "Essentials of mathematical proofs, including use of quantifiers and principles of valid inference. Set theory as a mathematical system.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257147", 5);
INSERT INTO db.planReq VALUES (1, "MATH260");
INSERT INTO db.course VALUES ("MATH330", "Discrete Mathematics", "Topics from logic, combinatorics, counting techniques, graph theory, and theory of finite-state machines.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257159", 5);
INSERT INTO db.planReq VALUES (1, "MATH330");
INSERT INTO db.course VALUES ("AW1", "Academic Writing I", "Academic Writing I prepares students with the skills necessary for critical reading and academic writing, including summarizing, reading sources critically and responding to them, synthesizing multiple perspectives, and using academic writing conventions, including grammar and mechanics.", "https://catalog.acalog.cwu.edu/preview_program.php?catoid=74&poid=16709#AcademicWritingICriticalReadingAndRespondingCredits5", NULL);
INSERT INTO db.genEd VALUES ("AW1");
INSERT INTO db.course VALUES ("DHC102", "Articulating Honors: Research Writing in the Twenty-First Century", "Introduces students to the academic expectations for DHC students; including writing essays, giving presentations, joining class discussions, and conducting research. Examines the philosophy, history, and debates surrounding honors education today, ultimately entering the discussion themselves. May be repeated for credit.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259810", 5);
INSERT INTO db.course VALUES ("ENG101", "Academic Writing I: Critical Reading and Responding", "Develops flexible writing knowledge to adapt to writing situations across disciplines and contexts.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256437", 5);
INSERT INTO db.course VALUES ("ENG101A", "Stretch Academic Writing A: Critical Reading and Responding", "Develops flexible writing knowledge to adapt to writing situations across disciplines and contexts.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259863", 5);
INSERT INTO db.course VALUES ("ENG101B", "Stretch Academic Writing B: Critical Reading and Responding", "Develops flexible writing knowledge to adapt to writing situations across disciplines and contexts.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259864", 5);
INSERT INTO db.course VALUES ("AW2", "Academic Writing II", "The Academic Writing II courses prepare students with skills in research-based academic argument through assignments involving evaluation, analysis, and synthesis of multiple sources.", "https://catalog.acalog.cwu.edu/preview_program.php?catoid=74&poid=16709#K1AcademicWritingIICriticalReadingAndResponding", NULL);
INSERT INTO db.genEd VALUES ("AW2");
INSERT INTO db.course VALUES ("ADMG285", "Sustainable Decision-Making", "Examines the impact of decision-making using short/long term outlooks and multiple perspectives. Develops skills to critically evaluate economic, environmental and social impacts of decisions as well as appropriate methods to professionally communicate those decisions.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259738", 5);
INSERT INTO db.course VALUES ("DHC270", "Integrated Learning", "An interdisciplinary approach to examining social, economic, technological, ethical, cultural, or aesthetic implications of knowledge. Instruction is augmented with practical application opportunities provided through international studies and community service learning.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256204", 4);
INSERT INTO db.course VALUES ("ENG102", "Academic Writing II: Reasoning and Research on Social Justice", "Develops skills in research-based academic argument through assignments involving evaluation, analysis, and synthesis of multiple sources.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256438", 5);
INSERT INTO db.course VALUES ("ENG103", "Academic Writing II: Reasoning and Research on Health and Current Issues", "Develops skills in research-based academic argument through assignments involving evaluation, analysis, and synthesis of multiple sources.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259641", 5);
INSERT INTO db.course VALUES ("ENG111", "Writing in the Sciences", "Prepares students to write effectively in a variety of scientific disciplines through assignments involving evaluation, analysis, data interpretation, and synthesis of multiple sources.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259813", 5);
INSERT INTO db.course VALUES ("HIST302", "Historical Methods", "Exercises in historical research, critical analysis, and interpretation.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256879", 5);
INSERT INTO db.course VALUES ("MGT200", "Tactical Skills for Professionals", "This course develops the skills and insights necessary to effectively acquire, synthesize and disseminate knowledge as a business decision maker - skills essential for success in business school and standard abilities in high performance professionals.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258316", 5);
INSERT INTO db.course VALUES ("PHIL152", "Arguments about Healthcare", "This course will cultivate critical thinking skills through the examination of arguments about healthcare, including whether there is a right to healthcare, the social determinants of health, and public policies designed to provide healthcare.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259627", 5);
INSERT INTO db.course VALUES ("K2", "Community, Cultue, & Citizenship", "The community, culture, and citizenship perspective engages students with historic and contemporary political, ethical, cultural, socioeconomic, and other emerging issues affecting society. By grappling with the intersection of social concerns, students will learn how societies are created and how to contribute to them as effective citizens.", "https://catalog.acalog.cwu.edu/preview_program.php?catoid=74&poid=16709#K2CommunityCultureAndCitizenship", NULL);
INSERT INTO db.genEd VALUES ("K2");
INSERT INTO db.course VALUES ("ABS210", "Introduction to Black Experience in the U.S.", "Examination of African Americans as (1) members of the nation they helped to build; and (2) members of a distinct culture that shapes and is shaped by local, national and global socio-economic and political forces.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258441", 5);
INSERT INTO db.course VALUES ("BUS241", "Legal Environment of Business", "An introduction to legal reasoning, ethics in business, the law of contracts, torts, agency, sales, bailments, and personal property.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255953", 5);
INSERT INTO db.course VALUES ("ECON101", "Economic Issues", "For the student who desires a general knowledge of economics. Applications of economic principles to current social and political problems.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256218", 5);
INSERT INTO db.course VALUES ("EFC250", "Introduction to Education", "Introduction to teaching as career, foundations and overview of American public education, effective teachers, responsibilities of schools in democratic society, essential professional competences, preparation, and certification. Culturally anchored, and offers a framework of equity pedagogy.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259595", 4);
INSERT INTO db.course VALUES ("GEOG250", "Resource Exploitation and Conservation", "Explores the historical, cultural, political, socio-economic perspectives of natural resource use, extraction, and sustainability at local to global scales. Students will examine resources and decision-making as citizens of campus, the Pacific Northwest, and the World. ", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256687", 4);
INSERT INTO db.course VALUES ("HIST143", "United States History to 1865", "Survey of U.S. history from before contact to Civil War. Themes include pre-Columbian societies; colonization; epidemics and environmental change; slavery; the American Revolution and Constitution; the market revolution; Manifest Destiny; and the Civil War. SB-Perspectives on Cultures and Experiences of U.S. (W).", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256875", 5);
INSERT INTO db.course VALUES ("HIST144", "United States History Since 1865", "U.S. history from Reconstruction to the present. Themes include Imperialism, Progressivism, World War I, Great Depression, World War II, the Civil Rights and Women’s Movements, the Vietnam War, recent U.S. foreign policy and political movements. ", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256876", 5);
INSERT INTO db.course VALUES ("LAJ102", "Introduction to Law and Justice", "This course will focus on the role of law in society and will examine both the criminal and civil law system, as well as, the function of law in social change and social control. SB-Perspectives on Cultures and Experiences of U.S.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258153", 5);
INSERT INTO db.course VALUES ("LIS245", "Research Methods in the Digital Age", "This course examines methods of information gathering and sharing in academic and social environments. Students explore applications of the research process, learn strategies for identifying and synthesizing information, and discuss research influences on scholarly conversations. Formerly LIS 345, students may not receive credit for both.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257128", 4);
INSERT INTO db.course VALUES ("LLAS102", "An Introduction to Latino and Latin American Studies", "Introduction to the history, peoples, and cultures of Latin America and of the Latino/a population in the United States.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257130", 5);
INSERT INTO db.course VALUES ("LLAS405", "Race, Latinidad and the Economy in the United States and Latin America", "The course is designed to provide understanding of how race is defined and perceived in the U.S and Latin America. Race and inequality are interconnected and integral in understanding the systemic inequalities present in society.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=261373", 5);
INSERT INTO db.course VALUES ("MKT360", "Principles of Marketing", "Principles of marketing class for non-business majors. Explores the function and processes of marketing, introducing students to the fundamental marketing concepts.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257257", 5);
INSERT INTO db.course VALUES ("POSC210", "American Politics", "Origin and development of the United States government; structure, political behavior, organizations, and processes; rights and duties of citizens.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257684", 5);
INSERT INTO db.course VALUES ("PSY310", "Multicultural Psychology and Social Justice", "An examination of human behavior in cultural context emphasizing the role of culture on thought, behavior, relationships and society. Addresses the influences of identity differences on individuals and society. Examines cross-cultural theory, and methodology. ", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257751", 4);
INSERT INTO db.course VALUES ("PUBH351", "Community Building Strategies for Public Health", "Introduces students to practical strategies designed to engage others in creating change that matters to them. Explores ideas, evidence, examples, and possibilities from the activist to the establishment.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256861", 4);
INSERT INTO db.course VALUES ("SOC109", "Social Construction of Race", "Exploration of the social construction of race from antiquity to modern day. How did the idea of race come about? How did it evolve? What have been the social consequences of the idea of race?", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256531", 5);
INSERT INTO db.course VALUES ("SUST301", "Introduction to Sustainability", "Students will learn about a variety of concepts related to sustainable development and sustainable environments. Emphasis will be placed on literature focusing on implementation of sustainability projects at local scales.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259659", 4);
INSERT INTO db.course VALUES ("WGSS201", "Introduction to Women’s, Gender, and Sexuality Studies", "An interdisciplinary exploration how gender and sexuality impact people’s lives both historically and in contemporary society. Gender related issues are examined through social, political, economic, and cultural issues and processes influencing societies, communities, and individuals. SB-Perspectives on Cultures and Experiences of U.S. (W). Meets the General Education writing requirement.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258143", 5);
INSERT INTO db.course VALUES ("K3", "Creative Expression", "The creative expression perspective allows students to explore aesthetic expression and artistic perspectives on common themes in the literary and fine arts.", "https://catalog.acalog.cwu.edu/preview_program.php?catoid=74&poid=16709#K3CreativeExpression", NULL);
INSERT INTO db.genEd VALUES ("K3");
INSERT INTO db.course VALUES ("DHC150", "Aesthetic Experience", "Variable topic. Courses in this area explore questions about the nature of art; to understand, interrogate, and engage in the creative process; and to explore the connections between art, culture, and history.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256196", 5);
INSERT INTO db.course VALUES ("DNCE161", "Cultural History of Dance", "A comprehensive look at the global dynamics of dance, examining the diverse cultural traditions and the innovations that have advanced dance into the 21st century. AH-Aesthetic Experience", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257520", 4);
INSERT INTO db.course VALUES ("ENG264", "Introduction to Creative Writing and the Environment", "An introduction to the creative writing genres: poetry, fiction, screenwriting, and creative nonfiction as they are applied to place and the environment. Examines the rhetorical forms and expectations of each in a workshop format.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259643", 5);
INSERT INTO db.course VALUES ("FILM150", "Film Appreciation", "Introduction to the art of film, through screenings, lectures, discussions, quizzes, and online discussion posts. Emphasis will be placed on traditional “Hollywood-style” films as well as independent, foreign, avant-garde, documentary, and short films. ", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259606", 5);
INSERT INTO db.course VALUES ("MUS101", "History of Jazz", "History of artistic, cultural, and technological developments in jazz, focusing on important players and performances. Introduction to fundamental musical concepts and methods; emphasis on active listening, social justice, current issues. ", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257291", 5);
INSERT INTO db.course VALUES ("MUS103", "History of Rock and Roll", "History of Rock and Roll, America’s second indigenous musical art form, after jazz. Emphasis placed on artists, music genres, and cultural/societal forces shaping rock’s evolution, 1950s to present. Extensive listening, reading; required online discussion.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257293", 5);
INSERT INTO db.course VALUES ("TH101", "Appreciation of Theatre and Film", "Viewing, discussing, and comparing film and live theatre performance. AH-Aesthetic Experience.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258032", 4);
INSERT INTO db.course VALUES ("TH107", "Introduction to Theatre", "Overview of the basic elements of the theatre arts and dramatic structure, and the environment for production of plays. Attendance at assigned outside events is required.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258033", 5);
INSERT INTO db.course VALUES ("K4", "Global Dynamics", "The global dynamics perspective focuses on how individuals, groups, communities, and nations function in a global society. Students will gain a cultural awareness and sensitivity that prepares them for citizenship in a diverse, global society by developing an understanding of how culture shapes human experience, an appreciation for diverse worldviews, and an awareness of the complexity of the interactions among local, regional, national, and global systems.", "https://catalog.acalog.cwu.edu/preview_program.php?catoid=74&poid=16709#K4GlobalDynamics", NULL);
INSERT INTO db.genEd VALUES ("K4");
INSERT INTO db.course VALUES ("ANTH130", "Cultural Worlds", "The cross-cultural and holistic study of humans worldwide, including the analysis of race, gender, power, kinship, globalization, and the role of symbols in social life. Students will also examine their own world through anthropological lenses. SB-Perspectives on World Cultures.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255644", 5);
INSERT INTO db.course VALUES ("AST102", "Introduction to Asian Studies", "An interdisciplinary introduction to the study of Asia; emphasizing geography, history, culture, and economics.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255806", 5);
INSERT INTO db.course VALUES ("COM302", "Intercultural Communication", "The objective of this course is to give the participants the skills and understanding necessary to improve communication with peoples of other nations and cultures.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256070", 4);
INSERT INTO db.course VALUES ("ECON202", "Principles of Economics Macro", "Organization of the U.S. economy, structure, and role of the monetary system, problems of employment and inflation, overall impact of government spending and taxation on the economy. Economic growth, world economic problems, and a comparison of capitalism with other economic systems.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256221", 5);
INSERT INTO db.course VALUES ("EDLT217", "Exploring Global Dynamics through Children’s and Adolescent Literature", "Interdisciplinary connections with critical analysis of global and international children’s/adolescent literature are explored. Comparisons across contemporary, historical, social, political, and economic issues through global and international children’s/adolescent literature read and discussed. ", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259593", 4);
INSERT INTO db.course VALUES ("ENG347", "Global Perspectives in Literature", "An introduction to contemporary non-western and postcolonial literature.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256461", 5);
INSERT INTO db.course VALUES ("ENST310", "Energy and Society", "Through classroom and field experience, students will examine society’s use of and dependence upon energy. Students will become more discerning citizens, able to take part in local, national, and global energy discussions. ", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256519", 5);
INSERT INTO db.course VALUES ("GEOG101", "World Regional Geography", "An introduction to the dynamic landscapes of the world’s major regions, examining socioeconomic, political, demographic, cultural and environmental patterns, processes, and issues. ", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256683", 5);
INSERT INTO db.course VALUES ("GERM200", "Introduction to German Culture", "The course examines major events, social movements, and cultural debates that situate contemporary German culture in historical global perspectives.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=260042", 5);
INSERT INTO db.course VALUES ("HIST101", "World History to 1500", "Origins and development of the major world civilizations to the 15th century. A comparative study of their political, social, and economic institutions, and their religious and intellectual backgrounds.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256872", 5);
INSERT INTO db.course VALUES ("HIST103", "World History Since 1815", "A comparative survey of political, social, economic, and cultural developments in world history since 1815", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256874", 5);
INSERT INTO db.course VALUES ("KRN311", "Korean Cinema and Visual Culture", "This course examines the cultural history of Korean cinema and visual culture, with a specific emphasis on contemporary youth and popular culture, including K-Pop, international Korean blockbusters, and manhwa (comics) among others.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259901", 5);
INSERT INTO db.course VALUES ("MUS105", "Introduction to World Music", "An interdisciplinary exploration of the many roles played by music in traditional societies, with emphasis on music’s social functions, life contexts, and influence on self-identity. ", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258634", 4);
INSERT INTO db.course VALUES ("PHIL106", "Asian Philosophy", "Examination of selected classical and/or contemporary issues and questions in Chinese, Japanese and Indian philosophy.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257609", 5);
INSERT INTO db.course VALUES ("POSC270", "International Relations", "This course explores political issues and theories in international relations. This class will focus on issues of war and peace, international law and organization, foreign policy, diplomatic history, and international political economy", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257687", 5);
INSERT INTO db.course VALUES ("RELS103", "World Mythologies", "An overview of world mythology and the contemporary study of myths: their nature, functions, symbolism, and uses; their cultural contexts, artistic expressions, and influence on contemporary life. ", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258936", 5);
INSERT INTO db.course VALUES ("WLC311", "Popular Cultures of the World", "This online course examines popular culture as a reflection of ideologies and value systems in different societies and cultural contexts. Course will not have an established scheduling pattern.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258504", 5);
INSERT INTO db.course VALUES ("K5", "Humanities", "The humanities perspective focuses on helping students interpret their world, culture, and perspectives through the study of philosophical, literary, and historical forms.", "https://catalog.acalog.cwu.edu/preview_program.php?catoid=74&poid=16709#K5Humanities", NULL);
INSERT INTO db.genEd VALUES ("K5");
INSERT INTO db.course VALUES ("DHC140", "Humanistic Understanding", "
Add to My Favorites (opens a new window)
Share this Page
Print (opens a new window)
Help (opens a new window)
Add to Portfolio (opens a new window)
DHC 140 - Humanistic Understanding
Description:
Variable topic. Courses in the humanities focuses on the analysis and interpretation of human stories of the past, present, and future in order to understand the processes of continuity and change in individuals and cultures through both documented and imaginative accounts.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256194", 5);
INSERT INTO db.course VALUES ("HIST102", "World History: 1500-1815", "A comparative survey of political, social, economic, and cultural developments in world history from 1500-1815.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256873", 5);
INSERT INTO db.course VALUES ("HIST301", "Pacific Northwest History", "Exploration and settlement; subsequent political, economic, and social history with particular emphasis on Washington.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256878", 5);
INSERT INTO db.course VALUES ("HUM101", "Exploring Cultures in the Ancient World", "An interdisciplinary exploration from literature, history, philosophy, and the arts of selected major ancient civilizations in Asia, Africa, Europe, and/or the Americas from their beginnings through the 15th century.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256943", 5);
INSERT INTO db.course VALUES ("HUM103", "Exploring Cultures in Modern and Contemporary Societies", "An interdisciplinary exploration of literature, history, philosophy, and the arts of selected world civilizations from the 20th century to the present.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256945", 5);
INSERT INTO db.course VALUES ("LAJ215", "Law in American History", "This course explores the role of law in American society from 1789 to 1939, including connections between law and violence, economics, politics, culture, gender and ethnicity.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259558", 4);
INSERT INTO db.course VALUES ("MGT395", "Leadership in Business Organizations", "Examination of theories and practices of leadership in business organizations.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257249", 5);
INSERT INTO db.course VALUES ("PHIL101", "Philosophical Inquiry", "Introduces students to the basic concepts, questions, and methods of philosophical inquiry. Topics may include free will and responsibility, knowledge and skepticism, the nature of the divine, moral reasoning, and human rights and social justice.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257606", 5);
INSERT INTO db.course VALUES ("PHIL104", "Moral Controversies", "An introduction to moral reasoning through the study of current ethical problems. Topics may include abortion, capital punishment, consumerism, immigration, sexual ethics, killing in war, and/or torture.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257610", 5);
INSERT INTO db.course VALUES ("RELS101", "World Religions", "Survey of the major world religions (Judaism, Christianity, Islam, Hinduism, Buddhism, Confucianism, Daoism), including their tenets, practices, and evaluation of the human condition.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257800", 5);
INSERT INTO db.course VALUES ("TH382", "Diverse Experiences in American Drama", "A study of contemporary plays by and/or about People of the Global Majority and their experiences in the United States of America. Titles and focus will change responsively to encompass contemporary ideas and artistic work.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258092", 5);
INSERT INTO db.course VALUES ("K6", "Individual & Society", "The individual and society perspective focuses on the relationship between people and their socialization. Students will be exposed to connections between behaviors, perspectives, psychology, and influences affecting everyday life.", "https://catalog.acalog.cwu.edu/preview_program.php?catoid=74&poid=16709#K6IndividualAndSociety", NULL);
INSERT INTO db.genEd VALUES ("K6");
INSERT INTO db.course VALUES ("AIS101", "American Indian Culture before European Contact", "An interdisciplinary approach explores the lifeways and environments of American Indians prior to European contact and settlement. Sources of pre-contact information consist of the archaeological, oral history, and paleoenvironmental records.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255631", 5);
INSERT INTO db.course VALUES ("ANTH107", "Being Human: Past and Present", "Exploration of being human throughout the world from the earliest human ancestors to today using archaeological, biological, cultural and linguistic anthropology methods and perspectives.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255641", 5);
INSERT INTO db.course VALUES ("ANTH180", "Language and Culture", "This course is an introduction to the scientific and anthropological study of language, concerning its structure and function as an omnipresent system in communication, cognition, and socialization, and its relationship with culture, society, and power. ", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255645", 5);
INSERT INTO db.course VALUES ("ASP305", "Accessibility and User Experience", "Issues of accessibility in everyday quality of life experiences. Models of disability. disability etiquette. Changes in laws and attitudes toward inclusion. Current careers requiring competence in troubleshooting accessibility.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258901", 4);
INSERT INTO db.course VALUES ("ATM281", "Socio-cultural Aspects of Apparel", "Clothing in relation to individual and group behavior patterns; personal and social meanings attributed to dress; and cultural patterns of technology, aesthetics, ritual, morality, and symbolism.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259707", 4);
INSERT INTO db.course VALUES ("CDFS101", "Skills for Marriage and Intimate Relationships", "Provides an overview of romantic relationship dynamics and common issues in relationships from inception to dissolution. Students learn strategies for their own relationships and skills to work in relationship education.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256650", 4);
INSERT INTO db.course VALUES ("CDFS234", "Contemporary Families", "Origins and historical development of families; cultural variations, contemporary trends. Draws upon information and insight from numerous root disciplines to explore family structure and function.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256652", 4);
INSERT INTO db.course VALUES ("DHC250", "Social and Behavioral Dynamics", "Variable Topic. Courses focus on how individuals, cultures, and societies operate and evolve and introduce disciplined ways of thinking about individuals and groups. May be repeated for credit under a different topic", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256200", 4);
INSERT INTO db.course VALUES ("ECON201", "Principles of Economics Micro", "Introduction to standard economic models used to examine how individuals and firms make decisions under different market structures; role of government in the economy in addressing market failure and efficiency equity tradeoff. ", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256220", 5);
INSERT INTO db.course VALUES ("GEOG208", "Our Human World", "Explores the historical diffusion and contemporary spatial distribution of cultures, religions, and languages. Evaluates how these features interact with economic and political systems to create distinctive places at scales ranging from local to global.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256685", 5);
INSERT INTO db.course VALUES ("HED101", "Essentials for Healthy Living", "Essentials for healthy living is a survey course designed to give the student the practical and theoretical knowledge necessary to apply principles of overall wellness in the pursuit of a healthier lifestyle. ", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256834", 4);
INSERT INTO db.course VALUES ("HRM381", "Management of Human Resources", "Selection of personnel, methods of training and retraining workers, wage policy, utilization of human resources, job training, administration of labor contracts, and public relations.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256937", 5);
INSERT INTO db.course VALUES ("IDS357", "Race, Drugs and Prohibition in the U.S.: What Makes Drug Use Criminal?", "Marijuana, cocaine, coffee and sugar. Why are some drugs “good” and some “bad?” Explore the “Drug War,” motivations for regulation, current dilemmas and social justice implications in the United States, from an interdisciplinary approach.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259612", 5);
INSERT INTO db.course VALUES ("LAJ216", "Race, Gender and Justice", "This course examines the role of race/ethnicity and gender in law and public policy with an emphasis on criminal justice.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259657", 4);
INSERT INTO db.course VALUES ("MGT380", "Organizational Management", "Principles of management class for non-business majors. Introduces students to the history and development of management ideas and contemporary practice. Overview of all the major elements of the managerial function", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257242", 5);
INSERT INTO db.course VALUES ("MGT386", "Principles of Organizational Behavior", "Applied and conceptual analysis of behavior within organizations. Involves leadership, motivation, communications, group processes, decision-making, climate, and culture.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257246", 5);
INSERT INTO db.course VALUES ("POSC101", "Introduction to Politics", "This course explores the meanings of power, political actors, resources of power and how they are being used for what purposes, under what ideological, institutional and policy processes affecting our quality of life.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257683", 5);
INSERT INTO db.course VALUES ("POSC260", "Comparative Politics", "Comparative political analysis, utilizing a variety of methods and theoretical approaches; application to selected western and non-western systems. Recommended to precede other courses in comparative politics.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257686", 5);
INSERT INTO db.course VALUES ("PSY101", "General Psychology", "The study of the basic principles, problems and methods that underlie the science of psychology, including diversity, human development, biological bases of behavior, learning, sensation and perception, cognition, personality, and psychopathology.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257739", 5);
INSERT INTO db.course VALUES ("PSY242", "Psychology of Video Games", "This course outlines many foundational theories of psychology within the lens of video games. Students will examine psychological concepts present in video games and how knowledge of psychology can improve the gaming experience.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259633", 4);
INSERT INTO db.course VALUES ("SOC101", "Social Problems", "An introduction to the study of contemporary issues such as poverty, military policies, families, crime, aging, racial, ethnic conflict, and the environment.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257940", 5);
INSERT INTO db.course VALUES ("SOC107", "Principles of Sociology", "An introduction to the basic concepts and theories of sociology with an emphasis on the group aspects of human behavior.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257941", 5);
INSERT INTO db.course VALUES ("SOC307", "Individual and Society", "An analysis of the relationship between social structure and the individual.
", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257947", 5);
INSERT INTO db.course VALUES ("STP300", "Inquiry Approaches to Teaching and Lesson Design", "In this field-based introductory course, students observe, experience, and describe essential components of effective STEM teaching in grades K-12. Students also design and teach lessons that implement essential components of content, equity, and professional practice. Course Requires liability insurance and current WSP/FBI fingerprints that do not expire before end of quarter.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259000", 4);
INSERT INTO db.course VALUES ("WGSS250", "Introduction to Queer Studies", "An interdisciplinary introduction to queer studies, investigating the historical and contemporary reality of those who identify as gay, lesbian, bisexual, transgender, and/or queer.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258320", 5);
INSERT INTO db.course VALUES ("K7", "Physical & Natural World", "This Physical and Natural World perspective introduces the core practice of science: generating testable explanations. Students will be introduced to fundamental scientific concepts and will engage in scientific practices.", "https://catalog.acalog.cwu.edu/preview_program.php?catoid=74&poid=16709#K7PhysicalAndNaturalWorld", NULL);
INSERT INTO db.genEd VALUES ("K7");
INSERT INTO db.course VALUES ("BIOL101", "Fundamentals of Biology", "Introduction to scientific inquiry and basic principles of biology at molecular, cellular, organismal, community, and ecosystem levels as applied to humans, society, and the environment. Four hours lecture and one two-hour laboratory per week.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255875", 5);
INSERT INTO db.course VALUES ("CHEM111", "Introduction to Chemistry", "Chemical principles of the compositions, structure, properties, and changes of matter. Designed for students in certain health science programs.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255965", 4);
INSERT INTO db.course VALUES ("CHEM111LAB", "Introductory Chemistry Laboratory", "Introduction to basic chemistry techniques. Two hours laboratory weekly. Combined with CHEM 111 lecture satisfies Physical and Natural World, Ways of Knowing.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255966", 1);
INSERT INTO db.course VALUES ("CHEM181", "General Chemistry I", "This course introduces chemistry concepts such as atoms and molecules, stoichiometry, solution chemistry, thermochemistry, electronic structure of the atom and periodicity, and chemical bonding.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255971", 4);
INSERT INTO db.course VALUES ("CHEM181LAB", "General Chemistry Laboratory I", "This laboratory supports hands-on, inquiry-based approaches to exploring topics presented in CHEM 181. Three hours of laboratory weekly.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255972", 1);
INSERT INTO db.course VALUES ("ENST201", "Earth as an Ecosystem", "Introduction to the concept of our planet as a finite environment with certain properties essential for life and will explore dynamic nature of the earth’s physical, chemical, geological, and biological processes and their interrelated “systems”.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256513", 5);
INSERT INTO db.course VALUES ("EXSC154", "Science of Healthy Living", "Science of Healthy Living (5 credits) is a lecture (4 hours) and in-person laboratory (2 hours) course, that analyzes and evaluates current theories and practices related to healthy living, focusing on translating theory to practice. ", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259605", 5);
INSERT INTO db.course VALUES ("GEOG107", "Our Dynamic Earth", "The complex weather, climate, water, landforms, soils, and vegetation comprising Earth’s physical environments over space and time. Incorporates map interpretation and scientific analysis in understanding various landscapes and human impacts upon those landscapes. ", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256684", 5);
INSERT INTO db.course VALUES ("GEOL101", "Introduction to Geology", "An introduction to geology emphasizing the origin and nature of the common rocks, plate tectonic theory, earthquake and volcanoes, and geologic time. Includes weekly labs.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256750", 5);
INSERT INTO db.course VALUES ("GEOL107", "Earth’s Changing Surface", "The role of natural geologic processes in shaping the earth’s surface; includes hydrologic cycle, rivers and flooding, landslides, coastal processes, and climate cycles. Four hour lecture per week plus required field trips.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256754", 4);
INSERT INTO db.course VALUES ("PHYS101", "Introductory Astronomy I", "An inquiry-based introduction to celestial motions, celestial objects, observational astronomy and the physics associated with each. Emphasis on stars and planets.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257642", 5);
INSERT INTO db.course VALUES ("PHYS106", "Physics Inquiry", "An introduction to fundamental physics topics highlighting applications to the world around us. There will be an emphasis on learning by inquiry and on designing and critiquing solutions to real world issues.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257645", 5);
INSERT INTO db.course VALUES ("SCED101", "Integrated Life Science", "Inquiry-based investigations into life science to help students develop understanding of fundamental concepts and the process of scientific investigation. This course is designed for prospective elementary teachers but is open to all students.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258327", 5);
INSERT INTO db.course VALUES ("K8", "Science & Technology", "The science and technology perspective focuses on scientific inquiry, intersections with technology, mathematical applications, and connections to the world around us.", "https://catalog.acalog.cwu.edu/preview_program.php?catoid=74&poid=16709#K8ScienceAndTechnology", NULL);
INSERT INTO db.genEd VALUES ("K8");
INSERT INTO db.course VALUES ("ACCT301", "Accounting Skills for Non-Accounting Majors", "An overview of accounting, tax, and finance from the viewpoint of the financial statement user. Students will learn basic financial language and analysis skills for assessing enterprise performance. Customized topics for students in various majors. ", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255563", 5);
INSERT INTO db.course VALUES ("ANTH120", "Archaeology: Science of the Past", "Introduction to the concepts, methods, and development of archaeology, as well as key discoveries from the ancient world.  Illustrations of how fields of science are combined to uncover past human achievements and diverse cultures.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255643", 5);
INSERT INTO db.course VALUES ("BIOL201", "Human Physiology", "An introduction to the function of human cells, organs, and organ systems as it relates to health and well-being current developments, and society.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255880", 5);
INSERT INTO db.course VALUES ("BIOL300", "Introduction to Evolution", "An introduction to the Darwinian theory of evolution. Exploration of the mechanisms of evolutionary change, speciation, and macroevolutionary patterns of the evolution of life on Earth including humans.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=255885", 5);
INSERT INTO db.course VALUES ("ETSC101", "Modern Technology and Energy", "A study of how basic scientific principles are applied daily in industrial societies through a survey of transportation, energy and power, construction, and consumer product technologies.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256953", 5);
INSERT INTO db.course VALUES ("GEOL108", "Earth and Energy Resources", "Exploration of the earth’s mineral and energy resources, how they are formed, harnessed, and the environmental impacts of their extraction and use. NS-Applications Natural Science.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256755", 4);
INSERT INTO db.course VALUES ("GEOL302", "Oceans and Atmosphere", "Introduction to Earth’s climate and the hydrologic cycle through study of the ocean-atmosphere system. Chemical and physical changes will be studied over time scales ranging from millions of years to days. Will include a field trip. NS-Patterns and Connections Natural World.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256758", 4);
INSERT INTO db.course VALUES ("IEM302", "Energy, Environment, and Climate Change", "The course examines the physical principles behind climate change science and how they relate to energy and resource use on our planet. Emphasis placed on examining how energy decisions impact past, present, and future climates. ", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=258575", 4);
INSERT INTO db.course VALUES ("IT202", "Change Ready: Technology Skills for Civic and Community Leaders", "Learn to maximize software applications and collaborative tools to support community and civic projects. Emphasis on using technology to facilitate project design, organization, communication, presentation, and building stakeholder support.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259753", 4);
INSERT INTO db.course VALUES ("NUTR101", "Introduction to Human Nutrition", "Fundamental nutritional concepts as related to health. Four hours lecture and one hour discussion per week.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=257428", 5);
INSERT INTO db.course VALUES ("PUBH320", "Environmental Health", "Examines environments, agents, and outcomes related to human and ecosystem health. Explores basic toxicology and environmental epidemiology principles; behavioral, social, economic, and political factors; scientific and technological advances; and sustainability issues and strategies.", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=256844", 4);
INSERT INTO db.course VALUES ("SHM102", "Occupational Health", "Explore the fundamental concepts of occupational health, including identification of health hazards in the work place, prevention of work place injuries and illnesses, human factors, and environmental health as it relates to the workplace", "https://catalog.acalog.cwu.edu/preview_course_nopop.php?catoid=89&coid=259571", 5);
INSERT INTO db.preReq VALUES ("CS111", "0", "0", "CS110");
INSERT INTO db.preReq VALUES ("CS111", "0", "1", "MATH153");
INSERT INTO db.preReq VALUES ("CS301", "0", "0", "CS111");
INSERT INTO db.preReq VALUES ("CS301", "0", "1", "MATH154");
INSERT INTO db.preReq VALUES ("CS302", "0", "0", "AW2");
INSERT INTO db.preReq VALUES ("CS302", "0", "1", "CS111");
INSERT INTO db.preReq VALUES ("CS302", "0", "2", "CS301");
INSERT INTO db.preReq VALUES ("CS302", "0", "3", "MATH172");
INSERT INTO db.preReq VALUES ("CS311", "0", "0", "CS111");
INSERT INTO db.preReq VALUES ("CS312", "0", "0", "CS301");
INSERT INTO db.preReq VALUES ("CS312", "0", "1", "CS311");
INSERT INTO db.preReq VALUES ("CS312", "0", "2", "CS325");
INSERT INTO db.preReq VALUES ("CS325", "0", "0", "AW2");
INSERT INTO db.preReq VALUES ("CS325", "0", "1", "CS111");
INSERT INTO db.preReq VALUES ("CS361", "0", "0", "CS302");
INSERT INTO db.preReq VALUES ("CS362", "0", "0", "CS361");
INSERT INTO db.preReq VALUES ("CS362", "0", "1", "MATH260");
INSERT INTO db.preReq VALUES ("CS380", "0", "0", "CS302");
INSERT INTO db.preReq VALUES ("CS380", "1", "0", "CS325");
INSERT INTO db.preReq VALUES ("CS392", "0", "0", "CS361");
INSERT INTO db.preReq VALUES ("CS420", "0", "0", "CS302");
INSERT INTO db.preReq VALUES ("CS420", "0", "1", "CS325");
INSERT INTO db.preReq VALUES ("CS420", "0", "2", "MATH260");
INSERT INTO db.preReq VALUES ("CS427", "0", "0", "CS302");
INSERT INTO db.preReq VALUES ("CS427", "0", "1", "MATH330");
INSERT INTO db.preReq VALUES ("CS450", "0", "0", "AW2");
INSERT INTO db.preReq VALUES ("CS450", "0", "1", "CS301");
INSERT INTO db.preReq VALUES ("CS450", "0", "2", "CS311");
INSERT INTO db.preReq VALUES ("CS450", "0", "3", "CS325");
INSERT INTO db.preReq VALUES ("CS450", "0", "4", "MATH172");
INSERT INTO db.preReq VALUES ("CS470", "0", "0", "CS302");
INSERT INTO db.preReq VALUES ("CS470", "0", "1", "CS312");
INSERT INTO db.preReq VALUES ("CS470", "0", "2", "CS361");
INSERT INTO db.preReq VALUES ("CS480", "0", "0", "CS380");
INSERT INTO db.preReq VALUES ("CS480", "0", "1", "CS420");
INSERT INTO db.preReq VALUES ("CS481", "0", "0", "CS480");
INSERT INTO db.preReq VALUES ("CS489", "0", "0", "CS480");
INSERT INTO db.preReq VALUES ("CS492", "0", "0", "CS392");
INSERT INTO db.preReq VALUES ("MATH154", "0", "0", "MATH153");
INSERT INTO db.preReq VALUES ("MATH172", "0", "0", "MATH154");
INSERT INTO db.preReq VALUES ("MATH173", "0", "0", "MATH172");
INSERT INTO db.preReq VALUES ("MATH260", "0", "0", "MATH173");
INSERT INTO db.preReq VALUES ("MATH260", "1", "0", "MATH172");
INSERT INTO db.preReq VALUES ("MATH260", "1", "1", "CS301");
INSERT INTO db.preReq VALUES ("MATH330", "0", "0", "MATH260");
INSERT INTO db.multicourse VALUES ("AW1", "0", "0", "DHC102");
INSERT INTO db.multicourse VALUES ("AW1", "1", "0", "ENG101");
INSERT INTO db.multicourse VALUES ("AW1", "2", "0", "ENG101A");
INSERT INTO db.multicourse VALUES ("AW1", "2", "1", "ENG101B");
INSERT INTO db.preReq VALUES ("ENG101B", "0", "0", "ENG101A");
INSERT INTO db.multicourse VALUES ("AW2", "0", "0", "ADMG285");
INSERT INTO db.multicourse VALUES ("AW2", "1", "0", "DHC270");
INSERT INTO db.multicourse VALUES ("AW2", "2", "0", "ENG102");
INSERT INTO db.multicourse VALUES ("AW2", "3", "0", "ENG103");
INSERT INTO db.multicourse VALUES ("AW2", "4", "0", "ENG111");
INSERT INTO db.multicourse VALUES ("AW2", "5", "0", "HIST302");
INSERT INTO db.multicourse VALUES ("AW2", "6", "0", "MGT200");
INSERT INTO db.multicourse VALUES ("AW2", "7", "0", "PHIL152");
INSERT INTO db.preReq VALUES ("ADMG285", "0", "0", "AW1");
INSERT INTO db.preReq VALUES ("ENG102", "0", "0", "AW1");
INSERT INTO db.preReq VALUES ("ENG103", "0", "0", "AW1");
INSERT INTO db.preReq VALUES ("ENG111", "0", "0", "AW1");
INSERT INTO db.preReq VALUES ("HIST302", "0", "0", "AW1");
INSERT INTO db.preReq VALUES ("MGT200", "0", "0", "AW1");
INSERT INTO db.preReq VALUES ("PHIL152", "0", "0", "AW1");
INSERT INTO db.multicourse VALUES ("K2", "0", "0", "ABS210");
INSERT INTO db.multicourse VALUES ("K2", "1", "0", "BUS241");
INSERT INTO db.multicourse VALUES ("K2", "2", "0", "ECON101");
INSERT INTO db.multicourse VALUES ("K2", "3", "0", "EFC250");
INSERT INTO db.multicourse VALUES ("K2", "4", "0", "GEOG250");
INSERT INTO db.multicourse VALUES ("K2", "5", "0", "HIST143");
INSERT INTO db.multicourse VALUES ("K2", "6", "0", "HIST144");
INSERT INTO db.multicourse VALUES ("K2", "7", "0", "LAJ102");
INSERT INTO db.multicourse VALUES ("K2", "8", "0", "LIS245");
INSERT INTO db.multicourse VALUES ("K2", "9", "0", "LLAS102");
INSERT INTO db.multicourse VALUES ("K2", "10", "0", "LLAS405");
INSERT INTO db.multicourse VALUES ("K2", "11", "0", "MKT360");
INSERT INTO db.multicourse VALUES ("K2", "12", "0", "POSC210");
INSERT INTO db.multicourse VALUES ("K2", "13", "0", "PSY310");
INSERT INTO db.multicourse VALUES ("K2", "14", "0", "PUBH351");
INSERT INTO db.multicourse VALUES ("K2", "15", "0", "SOC109");
INSERT INTO db.multicourse VALUES ("K2", "16", "0", "SUST301");
INSERT INTO db.multicourse VALUES ("K2", "17", "0", "WGSS201");
INSERT INTO db.multicourse VALUES ("K3", "0", "0", "DHC150");
INSERT INTO db.multicourse VALUES ("K3", "1", "0", "DNCE161");
INSERT INTO db.multicourse VALUES ("K3", "2", "0", "ENG264");
INSERT INTO db.multicourse VALUES ("K3", "3", "0", "FILM150");
INSERT INTO db.multicourse VALUES ("K3", "4", "0", "MUS101");
INSERT INTO db.multicourse VALUES ("K3", "5", "0", "MUS103");
INSERT INTO db.multicourse VALUES ("K3", "6", "0", "TH101");
INSERT INTO db.multicourse VALUES ("K3", "7", "0", "TH107");
INSERT INTO db.multicourse VALUES ("K4", "0", "0", "ANTH130");
INSERT INTO db.multicourse VALUES ("K4", "1", "0", "AST102");
INSERT INTO db.multicourse VALUES ("K4", "2", "0", "COM302");
INSERT INTO db.multicourse VALUES ("K4", "3", "0", "ECON202");
INSERT INTO db.multicourse VALUES ("K4", "4", "0", "EDLT217");
INSERT INTO db.multicourse VALUES ("K4", "5", "0", "ENG347");
INSERT INTO db.multicourse VALUES ("K4", "6", "0", "ENST310");
INSERT INTO db.multicourse VALUES ("K4", "7", "0", "GEOG101");
INSERT INTO db.multicourse VALUES ("K4", "8", "0", "GERM200");
INSERT INTO db.multicourse VALUES ("K4", "9", "0", "HIST101");
INSERT INTO db.multicourse VALUES ("K4", "10", "0", "HIST103");
INSERT INTO db.multicourse VALUES ("K4", "11", "0", "KRN311");
INSERT INTO db.multicourse VALUES ("K4", "12", "0", "MUS105");
INSERT INTO db.multicourse VALUES ("K4", "13", "0", "PHIL106");
INSERT INTO db.multicourse VALUES ("K4", "14", "0", "POSC270");
INSERT INTO db.multicourse VALUES ("K4", "15", "0", "RELS103");
INSERT INTO db.multicourse VALUES ("K4", "16", "0", "WLC311");
INSERT INTO db.preReq VALUES ("MUS105", "0", "0", "ENG101");
INSERT INTO db.multicourse VALUES ("K5", "0", "0", "DHC140");
INSERT INTO db.multicourse VALUES ("K5", "1", "0", "HIST102");
INSERT INTO db.multicourse VALUES ("K5", "2", "0", "HIST301");
INSERT INTO db.multicourse VALUES ("K5", "3", "0", "HUM101");
INSERT INTO db.multicourse VALUES ("K5", "4", "0", "HUM103");
INSERT INTO db.multicourse VALUES ("K5", "5", "0", "LAJ215");
INSERT INTO db.multicourse VALUES ("K5", "6", "0", "MGT395");
INSERT INTO db.multicourse VALUES ("K5", "7", "0", "PHIL101");
INSERT INTO db.multicourse VALUES ("K5", "8", "0", "PHIL104");
INSERT INTO db.multicourse VALUES ("K5", "9", "0", "RELS101");
INSERT INTO db.multicourse VALUES ("K5", "10", "0", "TH382");
INSERT INTO db.multicourse VALUES ("K6", "0", "0", "AIS101");
INSERT INTO db.multicourse VALUES ("K6", "1", "0", "ANTH107");
INSERT INTO db.multicourse VALUES ("K6", "2", "0", "ANTH180");
INSERT INTO db.multicourse VALUES ("K6", "3", "0", "ASP305");
INSERT INTO db.multicourse VALUES ("K6", "4", "0", "ATM281");
INSERT INTO db.multicourse VALUES ("K6", "5", "0", "CDFS101");
INSERT INTO db.multicourse VALUES ("K6", "6", "0", "CDFS234");
INSERT INTO db.multicourse VALUES ("K6", "7", "0", "DHC250");
INSERT INTO db.multicourse VALUES ("K6", "8", "0", "ECON201");
INSERT INTO db.multicourse VALUES ("K6", "9", "0", "GEOG208");
INSERT INTO db.multicourse VALUES ("K6", "10", "0", "HED101");
INSERT INTO db.multicourse VALUES ("K6", "11", "0", "HRM381");
INSERT INTO db.multicourse VALUES ("K6", "12", "0", "IDS357");
INSERT INTO db.multicourse VALUES ("K6", "13", "0", "LAJ216");
INSERT INTO db.multicourse VALUES ("K6", "14", "0", "MGT380");
INSERT INTO db.multicourse VALUES ("K6", "15", "0", "MGT386");
INSERT INTO db.multicourse VALUES ("K6", "16", "0", "POSC101");
INSERT INTO db.multicourse VALUES ("K6", "17", "0", "POSC260");
INSERT INTO db.multicourse VALUES ("K6", "18", "0", "PSY101");
INSERT INTO db.multicourse VALUES ("K6", "19", "0", "PSY242");
INSERT INTO db.multicourse VALUES ("K6", "20", "0", "SOC101");
INSERT INTO db.multicourse VALUES ("K6", "21", "0", "SOC107");
INSERT INTO db.multicourse VALUES ("K6", "22", "0", "SOC307");
INSERT INTO db.multicourse VALUES ("K6", "23", "0", "STP300");
INSERT INTO db.multicourse VALUES ("K6", "24", "0", "WGSS250");
INSERT INTO db.multicourse VALUES ("K7", "0", "0", "BIOL101");
INSERT INTO db.multicourse VALUES ("K7", "1", "0", "CHEM111");
INSERT INTO db.multicourse VALUES ("K7", "1", "1", "CHEM111LAB");
INSERT INTO db.multicourse VALUES ("K7", "2", "0", "CHEM181");
INSERT INTO db.multicourse VALUES ("K7", "2", "1", "CHEM181LAB");
INSERT INTO db.multicourse VALUES ("K7", "3", "0", "ENST201");
INSERT INTO db.multicourse VALUES ("K7", "4", "0", "EXSC154");
INSERT INTO db.multicourse VALUES ("K7", "5", "0", "GEOG107");
INSERT INTO db.multicourse VALUES ("K7", "6", "0", "GEOL101");
INSERT INTO db.multicourse VALUES ("K7", "7", "0", "GEOL107");
INSERT INTO db.multicourse VALUES ("K7", "8", "0", "PHYS101");
INSERT INTO db.multicourse VALUES ("K7", "9", "0", "PHYS106");
INSERT INTO db.multicourse VALUES ("K7", "10", "0", "SCED101");
INSERT INTO db.multicourse VALUES ("K8", "0", "0", "ACCT301");
INSERT INTO db.multicourse VALUES ("K8", "1", "0", "ANTH120");
INSERT INTO db.multicourse VALUES ("K8", "2", "0", "BIOL201");
INSERT INTO db.multicourse VALUES ("K8", "3", "0", "BIOL300");
INSERT INTO db.multicourse VALUES ("K8", "4", "0", "ETSC101");
INSERT INTO db.multicourse VALUES ("K8", "5", "0", "GEOL108");
INSERT INTO db.multicourse VALUES ("K8", "6", "0", "GEOL302");
INSERT INTO db.multicourse VALUES ("K8", "7", "0", "IEM302");
INSERT INTO db.multicourse VALUES ("K8", "8", "0", "IT202");
INSERT INTO db.multicourse VALUES ("K8", "9", "0", "NUTR101");
INSERT INTO db.multicourse VALUES ("K8", "10", "0", "PUBH320");
INSERT INTO db.multicourse VALUES ("K8", "11", "0", "SHM102");
SET FOREIGN_KEY_CHECKS=1;
