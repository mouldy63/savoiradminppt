$(document).ready(function() {
	
	// topper special widths
	topperSpecialWidthHandler(false);
	
	$("#topper_width").change(function() {
		//console.log("topper_width changed");
		topperSpecialWidthHandler(true);
	});
	
	// topper special lengths
	topperSpecialLengthHandler(false);
	
	$("#topper_length").change(function() {
		//console.log("topper_length changed");
		topperSpecialLengthHandler(true);
	});
	
	registerTextareaUsageCounter('topper_instructions', 'topper_instructions_counter', 250);
	
});

// was topperspecialwidthSelected in edit-purchase.asp
function topperSpecialWidthHandler(clearvalues) {
	//console.log("topperSpecialWidthHandler: clearvalues=" + clearvalues);
    $('#id_topper_specialwidth1').hide(); // was topperspecialwidth1

    if (clearvalues) {
        $("#topper_specialwidth1").val(""); // was topper1width
    }

    var topperWidth = $("#topper_width").val();
	//console.log("topperSpecialWidthHandler: topperWidth=" + topperWidth);

    if (topperWidth == "Special Width") {
        $('#id_topper_specialwidth1').show();
    }

}

// was topperspeciallengthSelected in edit-purchase.asp
function topperSpecialLengthHandler(clearvalues) {
	//console.log("topperSpecialLengthHandler: clearvalues=" + clearvalues);
    $('#id_topper_speciallength1').hide(); // was topperspeciallength1

    if (clearvalues) {
        $("#topper_speciallength1").val(""); // was topper1length
    }

    var topperLength = $("#topper_length").val();
	//console.log("topperSpecialLengthHandler: topperLength=" + topperLength);

    if (topperLength == "Special Length") {
        $('#id_topper_speciallength1').show();
    }
}

