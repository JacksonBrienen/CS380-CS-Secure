/*
 Author: Jackson Brienen
 File: header.js
 Description: Dynamically loads the header for all pages, this is the only place the header should be modified
 */

const headerHTML =
    `
     <header>
        <img src="icon.png">
        <h1>CS Secure</h1>
        <h4>We're Securing your Future</h4>
     </header>
    `;

window.addEventListener('load', ()=> {
    document.body.innerHTML = headerHTML + document.body.innerHTML;
});