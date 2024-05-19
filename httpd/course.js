class Course {

    /**
     * @param {string} name
     * @param {string} description
     * @param {string} link
     * @param {boolean} majorRequirement
     * @param {boolean} genEd
     * @param {boolean} multiCourse
     */
    constructor(name, description, link, majorRequirement, genEd, multiCourse) {
        if(!(this instanceof SimpleCourse || this instanceof MultiCourse)) {
            throw "Course is abstract and should only be created via SimpleCourse or MultiCourse child classes";
        }
        this.name = name;
        this.description = description;
        this.link = link;
        this.majorRequirement = majorRequirement;
        this.genEd = genEd;
        this.multiCourse = multiCourse;
    }

}

class SimpleCourse extends Course {

    /**
     * @param {string} name
     * @param {string} description
     * @param {string} link
     * @param {number} credits
     * @param {[Course[]]} prereqs
     * @param {boolean} majorRequirement
     * @param {boolean} genEd
     */
    constructor(name, description, link, credits, prereqs, majorRequirement, genEd) {
        super(name, description, link, majorRequirement, genEd, false);
        this.credits = credits;
        this.prereqs = prereqs;
    }

}

class MultiCourse extends Course {

    /**
     * @param {string} name
     * @param {string} description
     * @param {string} link
     * @param {[Course[]]} courses
     * @param {boolean} majorRequirement
     * @param {boolean} genEd
     */
    constructor(name, description, link, courses, majorRequirement, genEd) {
        super(name, description, link, majorRequirement, genEd, true);
        this.courses = courses;
    }

}
