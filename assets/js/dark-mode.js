const btn = document.querySelector("#dark-mode-btn");

btn.addEventListener("click", function () {
  document.body.classList.toggle("light");
  if (document.body.classList.contains("light")) {
    localStorage.setItem("lightMode", true);
  } else {
    localStorage.setItem("lightMode", false);
  }
  const tmp = this.getAttribute("off-label");
  this.setAttribute("off-label", this.innerHTML);
  this.innerHTML = tmp;
});

document.addEventListener("DOMContentLoaded", function () {
  const mode = localStorage.getItem("lightMode");
  if (JSON.parse(mode)) {
    btn.dispatchEvent(new CustomEvent("click"));
  }
});
