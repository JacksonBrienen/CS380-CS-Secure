/*
 Author: Jackson Brienen
 File: header.js
 Description: Dynamically loads the header for all pages, this is the only place the header should be modified
 */

function headerHTML() {
    const header = document.createElement('header');
    header.innerHTML = headerInnerHTML;
    return header;
}

const headerInnerHTML =
    `
    <img src="icon.png">
    <h1>CS Secure</h1>
    <h4>We're Securing your Future</h4>
    <nav>
        <a href="/"><img class="home nav-button"></a>
        <a href="/welcome"><img class="login nav-button"></a>
        <a href="/manager"><img class="account nav-button"></a>
    </nav>
    `;

window.addEventListener('load', ()=> {
    const header = headerHTML();
    document.body.appendChild(header);
});