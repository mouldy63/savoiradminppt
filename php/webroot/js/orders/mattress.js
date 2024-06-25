$(document).ready(function() {
	
	// mattress special widths
	mattressSpecialWidthHandler(false);
	
	$("#mattress_type").change(function() {
		//console.log("mattress_type changed");
		mattressSpecialWidthHandler(true);
	});
	$("#mattress_width").change(function() {
		//console.log("mattress_width changed");
		mattressSpecialWidthHandler(true);
	});
	
	// mattress special lengths
	mattressSpecialLengthHandler(false);
	
	$("#mattress_type").change(function() {
		//console.log("mattress_type changed");
		mattressSpecialLengthHandler(true);
	});
	$("#mattress_length").change(function() {
		//console.log("mattress_length changed");
		mattressSpecialLengthHandler(true);
	});
	
	registerTextareaUsageCounter('mattress_instructions', 'mattress_instructions_counter', 250);
	
});

// was mattspecialwidthSelected in edit-purchase.asp
function mattressSpecialWidthHandler(clearvalues) {
	//console.log("mattressSpecialWidthHandler: clearvalues=" + clearvalues);
    $('#id_mattress_specialwidth1').hide(); // was mattspecialwidth1
    $('#id_mattress_specialwidth2').hide(); // was mattspecialwidth2

    if (clearvalues) {
        $("#mattress_specialwidth1").val(""); // was matt1width
        $("#mattress_specialwidth2").val(""); // was matt2width
    }

    var mattWidth = $("#mattress_width").val();
    var mattType = $("#mattress_type").val();
	//console.log("mattressSpecialWidthHandler: mattWidth=" + mattWidth);
	//console.log("mattressSpecialWidthHandler: mattType=" + mattType);

    if ((mattWidth == "Special Width")
        && ((mattType == "Zipped Pair") || (mattType == "Zipped Pair (Centre Only)"))) {
        $('#id_mattress_specialwidth1').show();
        $('#id_mattress_specialwidth2').show();
    }

    if ((mattWidth == "Special Width")
        && ((mattType != "Zipped Pair") && (mattType != "Zipped Pair (Centre Only)"))) {
        $('#id_mattress_specialwidth1').show();
    }
}

// was mattspeciallengthSelected in edit-purchase.asp
function mattressSpecialLengthHandler(clearvalues) {
	//console.log("mattressSpecialLengthHandler: clearvalues=" + clearvalues);
    $('#id_mattress_speciallength1').hide(); // was mattspeciallength1
    $('#id_mattress_speciallength2').hide(); // was mattspeciallength2

    if (clearvalues) {
        $("#mattress_speciallength1").val(""); // was matt1length
        $("#mattress_speciallength2").val(""); // was matt2length
    }

    var mattLength = $("#mattress_length").val();
    var mattType = $("#mattress_type").val();
	//console.log("mattressSpecialLengthHandler: mattLength=" + mattLength);
	//console.log("mattressSpecialLengthHandler: mattType=" + mattType);

    if ((mattLength == "Special Length")
        && ((mattType == "Zipped Pair") || (mattType == "Zipped Pair (Centre Only)"))) {
        $('#id_mattress_speciallength1').show();
        $('#id_mattress_speciallength2').show();
    }

    if ((mattLength == "Special Length")
        && ((mattType != "Zipped Pair") && (mattType != "Zipped Pair (Centre Only)"))) {
        $('#id_mattress_speciallength1').show();
    }
}

