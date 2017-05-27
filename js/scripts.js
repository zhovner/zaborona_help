const warning = 0;


document.addEventListener("DOMContentLoaded", function(){
	let message = document.getElementById('warning_ddos');
	if ( message && warning ){
		message.style.display = "block";
	}
})