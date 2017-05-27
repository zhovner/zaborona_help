document.addEventListener("DOMContentLoaded", function(){
	let message = document.getElementById('warning_ddos');
	if ( message && warning_ddos ){
		message.style.display = "block";
	}
})