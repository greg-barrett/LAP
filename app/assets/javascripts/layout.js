

document.addEventListener('turbolinks:load', function(){
  //animate the hamburger
  var hamburger = document.querySelector(".hamburger");
  var nav = document.querySelector(".menu");
    // On click
    hamburger.addEventListener("click", function() {
      // Toggle class "is-active"
      hamburger.classList.toggle("isactive");
      nav.classList.toggle("expand");
      // Do something else, like open/close menu
    });
});
