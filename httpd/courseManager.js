/*
courseManager.js
@author Daniel Tongu
*/


"use strict";

class CourseManager {
    constructor() {
        this.init();
    }

    /**
     * Initialize the event listeners and setup.
     */
    init() {
        document.addEventListener('DOMContentLoaded', () => {
            this.setupEventListeners();
            this.addDragAndDropHandlers();
        });
    }

    /**
     * Custom helper function for querySelectorAll specific to courseManager.
     * @param {string} selector - The CSS selector to query.
     * @returns {NodeList} The list of matched elements.
     */
    $(selector) {
        return document.querySelectorAll(selector);
    }

    /**
     * Custom helper function for querySelector specific to courseManager.
     * @param {string} selector - The CSS selector to query.
     * @returns {Element} The matched element.
     */
    $$(selector) {
        return document.querySelector(selector);
    }

    /**
     * Setup event listeners for marking courses as completed.
     */
    setupEventListeners() {
        const buttons = this.$('#academicYearPlan section header button');
        buttons.forEach(button => {
            button.addEventListener('click', () => {
                const section = button.closest('section');
                const season = section.id;
                this.completeCourses(season);
            });
        });
    }

    /**
     * Add drag-and-drop functionality to each course.
     */
    addDragAndDropHandlers() {
        const courses = this.$('li[draggable="true"]');
        courses.forEach(course => {
            course.addEventListener('dragstart', this.dragStart);
            course.addEventListener('dragend', this.dragEnd);
        });

        // Add the functionality for containers to accept dropping courses
        const lists = this.$('ul');
        lists.forEach(list => {
            list.addEventListener('dragover', this.dragOver);
            list.addEventListener('dragleave', this.dragLeave);
            list.addEventListener('drop', this.drop);
        });
    }

    /**
     * Handle the drag start event by storing the draggable element's id and temporarily hiding it from view.
     * @param {DragEvent} event - The dragstart event object.
     */
    dragStart(event) {
        event.dataTransfer.setData('text', event.target.id);
        setTimeout(() => event.target.classList.add('hide'), 0);
    }

    /**
     * Handle the drag end event by removing the temporary hidden state.
     * @param {DragEvent} event - The dragend event object.
     */
    dragEnd(event) {
        event.target.classList.remove('hide');
    }

    /**
     * Handle the drag over event by preventing the default behavior to allow dropping and adding a hover effect to valid drop targets.
     * @param {DragEvent} event - The dragover event object.
     */
    dragOver(event) {
        event.preventDefault();
        if (event.target.tagName === 'UL') {
            event.target.classList.add('hovered');
        }
    }

    /**
     * Handle the drag leave event by removing the hover effect from the list when a draggable leaves the drop zone.
     * @param {DragEvent} event - The dragleave event object.
     */
    dragLeave(event) {
        if (event.target.tagName === 'UL') {
            event.target.classList.remove('hovered');
        }
    }

    /**
     * Handle the drop event by retrieving the dragged element and appending it to the new list.
     * @param {DragEvent} event - The drop event object.
     */
    drop(event) {
        event.preventDefault();
        const id = event.dataTransfer.getData('text');
        const draggable = document.getElementById(id);

        if (draggable && event.target.tagName === 'UL') {
            event.target.classList.remove('hovered');
            try {
                event.target.appendChild(draggable);
            } catch (error) {
                console.error("Failed to append child:", error);
            }
            // Make sure the course is draggable in all sections
            draggable.setAttribute('draggable', 'true');
            draggable.addEventListener('dragstart', this.dragStart);
            draggable.addEventListener('dragend', this.dragEnd);
        }
    }

    /**
     * Move all draggable courses from a given section to the completed section and mark them as draggable.
     * @param {string} season - The id of the section representing the current academic season.
     */
    completeCourses(season) {
        const completedSection = this.$$('#completedCourses ul');
        const section = document.getElementById(season);
        const courseList = section.querySelector('ul');
        const courses = courseList.querySelectorAll('li[draggable="true"]');

        courses.forEach(course => {
            course.setAttribute('draggable', 'true');
            completedSection.appendChild(course);
        });
    }
}

// Instantiate the CourseManager
new CourseManager();
