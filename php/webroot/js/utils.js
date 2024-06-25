var traceEnabled = true;
var spinner;
var opts = {
		  lines: 11, // The number of lines to draw
		  length: 15, // The length of each line
		  width: 7, // The line thickness
		  radius: 20, // The radius of the inner circle
		  corners: 1, // Corner roundness (0..1)
		  rotate: 0, // The rotation offset
		  direction: 1, // 1: clockwise, -1: counterclockwise
		  color: '#000', // #rgb or #rrggbb or array of colors
		  speed: 1, // Rounds per second
		  trail: 60, // Afterglow percentage
		  shadow: false, // Whether to render a shadow
		  hwaccel: false, // Whether to use hardware acceleration
		  className: 'spinner', // The CSS class to assign to the spinner
		  zIndex: 2e9, // The z-index (defaults to 2000000000)
		  top: '50%', // Top position relative to parent
		  left: '50%' // Left position relative to parent
		};

function trace(s) {
	if (traceEnabled) {
		try { console.log(s) } catch (e) { };
	}
}

function isNumeric(sText) {
   var validChars = "0123456789.";
   var isNumeric=true;
   var char;

   for (i = 0; i < sText.length && isNumeric == true; i++) 
	  { 
	  char = sText.charAt(i); 
	  if (validChars.indexOf(char) == -1) 
		 {
		 isNumeric = false;
		 }
	  }
   return isNumeric;
}

function isInteger(sText) {
   var validChars = "0123456789";
   var isInteger=true;
   var char;

   for (i = 0; i < sText.length && isInteger == true; i++) 
	  { 
	  char = sText.charAt(i); 
	  if (validChars.indexOf(char) == -1) 
		 {
		 isInteger = false;
		 }
	  }
   return isInteger;
}

function pad(num, size) {
	var s = "000000000" + num;
	return s.substr(s.length-size);
}

function startSpinner(divId) {
	trace("startSpinner: spinner=" + spinner);
	if (!spinner) {
		var target = document.getElementById(divId);
		spinner = new Spinner(opts).spin(target);
	}
}

function stopSpinner() {
	trace("stopSpinner: spinner=" + spinner);
	if (spinner) {
		spinner.stop();
		spinner = null;
	}
}
