let login;
let reg;

// Add event listener for messages from the server
window.addEventListener('message', (event) => {
    const data = event.data;
    const nui = document.querySelector('.box');

    if (data.action === 'show') {
        $('.box').fadeIn();
        nui.style.visibility = 'visible';
    }

    if (data.action === 'hide') {
        $('.box').fadeOut();
        nui.style.visibility = 'hidden';
        document.getElementById("pass").value = '';
    }

    const element = document.querySelector(".input-user");
    element.value = event.data.name;
});

// Add click event listener for login button
login = document.querySelector(".b-login");
login.addEventListener('click', () => {
    const nameData = document.getElementById("name").value; // NAME
    const passData = document.getElementById("pass").value; // PASSWORD

    if (!document.querySelector(".checkmark").checked || nameData.length < 1 || passData.length < 1) {
        return;
    }

    $('.box').fadeOut();

    $.post(`http://${GetParentResourceName()}/login`, JSON.stringify({
        username: nameData,
        passw: passData,
    }));
});

// Add click event listener for register button
reg = document.querySelector(".b-reg");
reg.addEventListener('click', () => {
    const nameData = document.getElementById("name").value;
    const passData = document.getElementById("pass").value;

    if (!document.querySelector(".checkmark").checked || nameData.length < 1 || passData.length < 1) {
        return;
    }

    $('.box').fadeOut();
    document.getElementById("pass").value = '';

    $.post(`http://${GetParentResourceName()}/reg`, JSON.stringify({
        username: nameData,
        passw: passData,
    }));
});

// Add draggable functionality to the login box
$(".box").draggable({
    handle: '.header'
});
