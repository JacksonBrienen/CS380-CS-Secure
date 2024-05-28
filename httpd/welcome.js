'use strict';

function urlencode(obj) {
    let body = [];
    for(let [key, value] of Object.entries(obj)) {
        body.push(`${encodeURIComponent(key)}=${encodeURIComponent(value)}`);
    }
    return body.join('&');
}

function post(obj) {
    fetch('/welcome', {
        method: 'POST',
        headers: {
            'Accept': 'application/json;text/html',
            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
        },
        body: urlencode(obj)
    }).then(res => {
        if(res.headers.get("content-type").includes('json')) {
            res.json().then((json) => {
                document.cookie = `token=${encodeURIComponent(json.token)}; path=/; Secure;`;
                document.location.href = '/manager';
            });
        } else if(res.headers.get("content-type").includes('html')) {
            res.text().then(text => {
                const _info = getInfo();
                if(_info !== null) {
                    getForm().removeChild(_info);
                }
                const info = document.createElement('div');

                info.id = 'info';
                if(res.status >= 400) {
                    info.style.setProperty('color', 'red');
                }
                info.innerHTML = `${text}`;
                getForm().prepend(info);
            });
        }
    }).then(() => {
        getTopButton().removeAttribute("disabled");
        getBtmButton().removeAttribute("disabled");
    });

}

function getForm() {
    return document.getElementsByTagName("form").item(0);
}

function getEmail() {
    return document.getElementById("email");
}

function getPassword() {
    return document.getElementById("passwd");
}

function getConfirmPassword() {
    return document.getElementById("conf-passwd");
}

function getTopButton() {
    return document.getElementById("top-button");
}

function getBtmButton() {
    return document.getElementById("btm-button");
}

function getInfo() {
    return document.getElementById('info');
}

function passwordMatching() {
    if(getPassword().value !== getConfirmPassword().value) {
        this.setCustomValidity('Passwords must match');
    } else {
        this.setCustomValidity('');
    }
}

// true  -> sign up
// false -> sign in
let state = false;

function toggleState() {
    state = !state;
    if (state) {
        getConfirmPassword().style.setProperty("display", "inherit");
        getTopButton().setAttribute("value", "Sign Up");
        getBtmButton().innerText = "Sign In Instead";
        getConfirmPassword().setAttribute("required", "");
        getConfirmPassword().oninput = passwordMatching;
    } else {
        getConfirmPassword().style.setProperty("display", "none");
        getTopButton().setAttribute("value", "Sign In");
        getBtmButton().innerText = "Sign Up Instead";
        getConfirmPassword().removeAttribute("required");
        getConfirmPassword().oninput = undefined;
    }
}

function changeToSignin() {
    const info = getInfo();
    if(state) {
        toggleState();
        if(info !== null) {
            getForm().removeChild(info);
        }
    } else {
        if(info !== null) {
            getForm().removeChild(info);
        }
    }
}


function submitEvent(e) {
    e.preventDefault();
    if(getForm().checkValidity()) {
        getTopButton().setAttribute("disabled", "");
        getBtmButton().setAttribute("disabled", "");
        post({signUp: state, email: getEmail().value, password: getPassword().value});
    } else {
        getForm().reportValidity();
    }
}

function toggleEvent(e) {
    e.preventDefault();
    toggleState();
}

function initListeners() {
    getTopButton().addEventListener('click', submitEvent);
    getBtmButton().addEventListener('click', toggleEvent);
}

window.addEventListener('load', ()=> {
    initListeners();
    toggleState(); // flips to sign up state by default
});