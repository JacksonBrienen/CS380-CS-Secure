'use strict';

window.addEventListener('load', ()=> {
    // true  -> sign up
    // false -> sign in
    let state = false;

    const passwd = document.getElementById("passwd");
    const conf_passwd = document.getElementById("conf-passwd");
    const top = document.getElementById("top-button");
    const btm = document.getElementById("btm-button");

    function passwordMatching() {
        if(passwd.value !== conf_passwd.value) {
            this.setCustomValidity('Passwords must match');
        } else {
            this.setCustomValidity('');
        }
    }

    function toggleState() {
        state = !state;
        if (state) {
            conf_passwd.style.setProperty("display", "inherit");
            top.setAttribute("value", "Sign Up");
            btm.innerText = "Sign In Instead";
            conf_passwd.setAttribute("required", "");
            conf_passwd.oninput = passwordMatching;
        } else {
            conf_passwd.style.setProperty("display", "none");
            top.setAttribute("value", "Sign In");
            btm.innerText = "Sign Up Instead";
            conf_passwd.removeAttribute("required");
            conf_passwd.oninput = undefined;
        }
    }

    btm.addEventListener("click", (e) => {
        e.preventDefault();
        toggleState();
    });

    toggleState(); // flips to sign up state by default
});