/*
courseManager.js
@author Daniel Tongu
*/

// Custom helper function for document.querySelectorAll
const $ = (selector) => document.querySelectorAll(selector);

document.addEventListener('DOMContentLoaded', function() {
    // Select all buttons that need to mark courses as completed
    const buttons = $('#academicYearPlan section header button');

    buttons.forEach(button => {
      button.addEventListener('click', function() {
          const section = this.closest('section');
          const season = section.id;
          completeCourses(season);
      });
    });

    // Add drag-and-drop functionality to each course
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
});

/**
 * Handle the drag start event by storing the draggable element's id and temporarily hiding it from view.
 * @param {DragEvent} event - The dragstart event object
 */
function dragStart(event) {
  event.dataTransfer.setData('text', event.target.id);
  setTimeout(() => event.target.classList.add('hide'), 0);
}

/**
 * Handle the drag end event by removing the temporary hidden state.
 * @param {DragEvent} event - The dragend event object
 */
function dragEnd(event) {
  event.target.classList.remove('hide');
}

/**
 * Handle the drag over event by preventing the default behavior to allow dropping and adding a hover effect to valid drop targets.
 * @param {DragEvent} event - The dragover event object
 */
function dragOver(event) {
  event.preventDefault();
  if (event.target.tagName === 'UL') {
    event.target.classList.add('hovered');
  }
}

/**
 * Handle the drag leave event by removing the hover effect from the list when a draggable leaves the drop zone.
 * @param {DragEvent} event - The dragleave event object
 */
function dragLeave(event) {
  if (event.target.tagName === 'UL') {
    event.target.classList.remove('hovered');
  }
}

/**
 * Handle the drop event by retrieving the dragged element and appending it to the new list.
 * @param {DragEvent} event - The drop event object
 */
function drop(event) {
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
  }
}

/**
 * Move all draggable courses from a given section to the completed section and mark them as non-draggable.
 * @param {string} season - The id of the section representing the current academic season
 */
function completeCourses(season) {
    let completedSection = document.querySelector(`#completedCourses .${season}`);

    if (!completedSection) {
        const newSection = document.createElement('section');
        newSection.className = season;

        const newHeader = document.createElement('h3');
        newHeader.textContent = season.charAt(0).toUpperCase() + season.slice(1);

        const newList = document.createElement('ul');
        newSection.appendChild(newHeader);
        newSection.appendChild(newList);

        document.querySelector('#completedCourses').appendChild(newSection);
        completedSection = newList;
    } else {
        completedSection = completedSection.querySelector('ul');
    }

    const section = document.getElementById(season);
    const courseList = section.querySelector('ul');
    const courses = courseList.querySelectorAll('li[draggable="true"]');
    courses.forEach(course => {
        course.setAttribute('draggable', 'false');
        completedSection.appendChild(course);
    });
}
