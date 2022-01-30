let login 
let reg

window.addEventListener('message', (event) => {
    let data = event.data
    const Nui = document.querySelector('.box')
    if (data.action == 'show') {
      $('.box').fadeIn();
      Nui.style.visibility = 'visible'
    }

    if (data.action == 'hide') {
      $('.box').fadeOut();
      Nui.style.visibility = 'hidden'
      document.getElementById("pass").value='';
    }
    const element = document.querySelector(".input-user")
    element.value = event.data.name
});

login = document.querySelector(".b-login")
login.addEventListener('click', () => {
    let nameData = document.getElementById("name").value // NAME
    let passData = document.getElementById("pass").value // PASSWORD
    if (!document.querySelector(".checkmark").checked) return
    $('.box').fadeOut();
    $.post(`http://dv_loginsystem/login`, JSON.stringify({
      username: nameData,
      passw: passData,
    })
  );
})

reg = document.querySelector(".b-reg")
reg.addEventListener('click', () => {
    let nameData = document.getElementById("name").value
    let passData = document.getElementById("pass").value
    if (!document.querySelector(".checkmark").checked) return
    $('.box').fadeOut();
    document.getElementById("pass").value='';
    $.post(`http://dv_loginsystem/reg`, JSON.stringify({
      username: nameData,
      passw: passData,
    })
  );
})

// DRAGGABLE
$(".box").draggable({ handle:'.header'});