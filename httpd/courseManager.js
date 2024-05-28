/*
courseManager.js
@author Daniel Tongu
*/


"use strict";

function getCookie(name) {
    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);
    if (parts.length === 2) return parts.pop().split(';').shift();
}

let token;

window.addEventListener("load", ()=> {
    token = getCookie('token');
    if(token === undefined) {
        window.location.replace("/welcome");
    }

    const neededList = document.getElementById("needed-list");
    const quarterLists = [
        document.getElementById("fall-list"),
        document.getElementById("winter-list"),
        document.getElementById("spring-list"),
        document.getElementById("summer-list")
    ];
    const completedList = document.getElementById("completed-list");

    neededList.addEventListener('drop', drop);
    neededList.addEventListener('dragover', dragOver);
    for(const list of quarterLists) {
        list.addEventListener('drop', drop);
        list.addEventListener('dragover', dragOver);
    }
    completedList.addEventListener('drop', drop);
    completedList.addEventListener('dragover', dragOver);

    function readData(list, url) {
        fetch(url, {
            method: 'GET',
            headers: {
                'Auth-Token': token
            }
        }).then((res) => {
            if(res.ok) {
                res.json().then(json => {
                    for(const key in json) {
                        const li = document.createElement('li');
                        if(json[key].multiCourse) {
                            const select = document.createElement('select');
                            const opt = document.createElement('option');
                            opt.innerText = key;
                            select.appendChild(opt);
                            for(const c of json[key].courses) {
                                const opt = document.createElement('option');
                                opt.innerText = c[0];
                                select.appendChild(opt);
                            }
                            li.appendChild(select);
                        } else {
                            li.innerText = key;
                        }
                        li.id = key;
                        li.setAttribute('draggable', 'true');
                        li.addEventListener('dragstart', (e) => {
                            e.dataTransfer.setData('text', e.target.id);
                        });
                        list.appendChild(li);
                    }
                });
            } else {
                window.location.replace("/welcome");
            }
        });
    }

    readData(neededList, '/manager/needed');
    readData(quarterLists[0], '/manager/fall');
    readData(quarterLists[1], '/manager/winter');
    readData(quarterLists[2], '/manager/spring');
    readData(quarterLists[3], '/manager/summer');
    readData(completedList, '/manager/completed');

    // console.log(document.cookie);
    // const courseList = document.querySelectorAll("#courseCatalog ul").item(0);
    // getCourses().then(/** @type {Course[]}*/ courses => {
    //     for(const [key, c] of Object.entries(courses)) {
    //         if(c.majorRequirement) {
    //             /** @type {HTMLLIElement} */
    //             const e = document.createElement("li");
    //             e.textContent = key;
    //             e.setAttribute("id", key);
    //             e.setAttribute("draggable", "true");
    //             courseList.appendChild(e);
    //         } else if(c.genEd && c.multiCourse) {
    //             /** @type {MultiCourse} */
    //             const multiCourse = c;
    //             const listItem = document.createElement("li");
    //             listItem.setAttribute("id", key);
    //             listItem.setAttribute("draggable", "false");
    //             listItem.addEventListener('dragstart', dragStart);
    //             listItem.addEventListener('dragend', dragEnd);
    //             const selectElem = document.createElement("select");
    //             listItem.addEventListener('dragend', (event)=> {
    //                 if(listItem.parentElement.id === "needed-list") {
    //                     for(let i = 0; i < selectElem.length; i++) {
    //                         selectElem.item(i).removeAttribute("disabled");
    //                     }
    //                 } else if (listItem.parentElement.id === "completed-list") {
    //                     for(let i = 0; i < selectElem.length; i++) {
    //                         selectElem.item(i).setAttribute("disabled", "");
    //                     }
    //                 } else {
    //                     selectElem.item(0).setAttribute("disabled", "");
    //                     for(let i = 1; i < selectElem.length; i++) {
    //                         selectElem.item(i).removeAttribute("disabled");
    //                     }
    //                 }
    //             });
    //             const baseOpt = document.createElement("option");
    //             baseOpt.style.backgroundColor = 'grey';
    //             baseOpt.innerText = key;
    //             selectElem.appendChild(baseOpt);
    //             selectElem.addEventListener("change", function() {
    //                 if(selectElem.value === key) {
    //                     listItem.style.backgroundColor = 'grey';
    //                     selectElem.style.backgroundColor = 'grey';
    //                     listItem.setAttribute("draggable", "false");
    //                 } else {
    //                     listItem.style.backgroundColor = 'white';
    //                     selectElem.style.backgroundColor = 'inherit';
    //                     listItem.setAttribute("draggable", "true");
    //                 }
    //             });
    //             listItem.style.backgroundColor = 'grey';
    //             selectElem.style.backgroundColor = 'grey';
    //             for(const courseArray of multiCourse.courses) {
    //                 if(courseArray.length > 0) {
    //                     if(courseArray.length > 1) {
    //                         selectElem.addEventListener("change", function() {
    //                             if(selectElem.value === courseArray[0])
    //                             {
    //                                 for(let i = 1; i < courseArray.length; i++) {
    //                                     const e = document.createElement("li");
    //                                     e.textContent = courseArray[i];
    //                                     e.setAttribute("id", courseArray[i]);
    //                                     e.setAttribute("draggable", "true");
    //                                     e.addEventListener('dragstart', dragStart);
    //                                     e.addEventListener('dragend', dragEnd);
    //                                     courseList.appendChild(e);
    //                                 }
    //                             } else if(selectElem.value !== courseArray[0]) {
    //                                 for(let i = 1; i < courseArray.length; i++) {
    //                                     const lists = document.getElementsByTagName("ul");
    //                                     const e = document.getElementById(courseArray[i]);
    //                                     for(let k = 0; k < lists.length; k++) {
    //                                         if(lists.item(k).contains(e)) {
    //                                             lists.item(k).removeChild(e);
    //                                         }
    //                                     }
    //                                 }
    //                             }
    //                         });
    //                     }
    //                     const opt = document.createElement("option");
    //                     opt.innerText = courseArray[0];
    //                     selectElem.appendChild(opt);
    //                     // for(const course of courseArray) {
    //                     //
    //                     // }
    //                 }
    //
    //
    //             }
    //             listItem.appendChild(selectElem);
    //             courseList.appendChild(listItem);
    //         }
    //
    //     }
    // }).then(()=> {
    //     setupEventListeners();
    //     addDragAndDropHandlers();
    // });
});

// document.addEventListener('DOMContentLoaded', () => {
//     // const courseList = document.querySelectorAll("#courseCatalog ul").item(0);
//     // getCourses().then(/** @type {Course[]}*/ courses => {
//     //     for(const [key, c] of Object.entries(courses)) {
//     //         //if(c.majorRequirement) {
//     //             /** @type {HTMLLIElement} */
//     //             const e = document.createElement("li");
//     //             e.textContent = key;
//     //             e.setAttribute("draggable", "true");
//     //             courseList.appendChild(e);
//     //
//     //         //}
//     //     }
//     //     setupEventListeners();
//     //     addDragAndDropHandlers();
//     // });
//     setupEventListeners();
//     addDragAndDropHandlers();
// });

/**
 * Custom helper function for querySelectorAll specific to courseManager.
 * @param {string} selector - The CSS selector to query.
 * @returns {NodeList} The list of matched elements.
 */
function $(selector) {
    return document.querySelectorAll(selector);
}

/**
 * Custom helper function for querySelector specific to courseManager.
 * @param {string} selector - The CSS selector to query.
 * @returns {Element} The matched element.
 */
function $$(selector) {
    return document.querySelector(selector);
}

/**
 * Setup event listeners for marking courses as completed.
 */
function setupEventListeners() {
    const buttons = $('#academicYearPlan section header button');
    buttons.forEach(button => {
        button.addEventListener('click', () => {
            const section = button.closest('section');
            const season = section.id;
            completeCourses(season);
        });
    });
}

/**
 * Add drag-and-drop functionality to each course.
 */
function addDragAndDropHandlers() {
    const courses = $('li[draggable="true"]');
    courses.forEach(course => {
        course.addEventListener('dragstart', dragStart);
        course.addEventListener('dragend', dragEnd);
    });

    // Add the functionality for containers to accept dropping courses
    const lists = $('ul');
    lists.forEach(list => {
        list.addEventListener('dragover', dragOver);
        list.addEventListener('dragleave', dragLeave);
        list.addEventListener('drop', drop);
    });
}

/**
 * Handle the drag start event by storing the draggable element's id and temporarily hiding it from view.
 * @param {DragEvent} event - The dragstart event object.
 */
function dragStart(event) {
    event.dataTransfer.setData('text', event.target.id);
    // setTimeout(() => event.target.classList.add('hide'), 0);
}

/**
 * Handle the drag end event by removing the temporary hidden state.
 * @param {DragEvent} event - The dragend event object.
 */
function dragEnd(event) {
    // event.target.classList.remove('hide');
}

/**
 * Handle the drag over event by preventing the default behavior to allow dropping and adding a hover effect to valid drop targets.
 * @param {DragEvent} event - The dragover event object.
 */
function dragOver(event) {
    event.preventDefault();
    if (event.target.tagName === 'UL') {
        // event.target.classList.add('hovered');
    }
}

/**
 * Handle the drag leave event by removing the hover effect from the list when a draggable leaves the drop zone.
 * @param {DragEvent} event - The dragleave event object.
 */
function dragLeave(event) {
    if (event.target.tagName === 'UL') {
        // event.target.classList.remove('hovered');
    }
}

/**
 * Handle the drop event by retrieving the dragged element and appending it to the new list.
 * @param {DragEvent} event - The drop event object.
 */
function drop(event) {
    event.preventDefault();
    const listTable = {
        "needed-list": "needed",
        "fall-list": "fall",
        "winter-list": "winter",
        "spring-list": "spring",
        "summer-list": "summer",
        "completed-list": "completed",
    }
    const tableId = listTable[event.target.id];
    const id = event.dataTransfer.getData('text');
    ///manager/:season/:course
    fetch(`/manager/${tableId}/${id}`, {
        method: 'POST',
        headers: {
            'Auth-Token': token
        }
    }).then(res => {
        if(res.ok) {
            console.log('good move');
        } else {
            console.log('bad move');
        }
    });

    const draggable = document.getElementById(id);
    if (draggable && event.target.tagName === 'UL') {
        event.target.classList.remove('hovered');
        try {
            event.target.appendChild(draggable);
        } catch (error) {
            console.error("Failed to append child:", error);
        }
    }
}

/**
 * Move all draggable courses from a given section to the completed section and mark them as draggable.
 * @param {string} season - The id of the section representing the current academic season.
 */
function completeCourses(season) {
    const completedSection = $$('#completedCourses ul');
    const section = document.getElementById(season);
    const courseList = section.querySelector('ul');
    const courses = courseList.querySelectorAll('li[draggable="true"]');

    courses.forEach(course => {
        course.setAttribute('draggable', 'true');
        completedSection.appendChild(course);
    });
}