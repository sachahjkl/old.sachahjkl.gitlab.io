document.body.className = "dark";

function dark_mode() {
  if (document.body.className == "dark") {
    document.body.className = "";
    document.getElementById("darkbtn").firstChild.data ="Dark Mode"
  } else {
    document.body.className = "dark";
    document.getElementById("darkbtn").firstChild.data ="Light Mode"
  }
}
