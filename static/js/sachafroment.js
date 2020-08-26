document.addEventListener("DOMContentLoaded", function(){
	let mode = localStorage.getItem("mode");
	console.log(mode)
	if(mode == ""){
		localStorage.setItem("mode","light");
	} else if (mode == "dark"){
		document.body.className = "dark";
		document.getElementById("darkbtn").firstChild.data = "Light Mode";
	}
});

function dark_mode() {
  if (document.body.className == "dark") {
	localStorage.setItem("mode","light");
	document.body.className = "light";
	document.getElementById("darkbtn").firstChild.data ="Dark Mode";
  } else if (document.body.className == "light" || document.body) {
	localStorage.setItem("mode","dark");
	document.body.className = "dark";
	document.getElementById("darkbtn").firstChild.data ="Light Mode";
  }
}
