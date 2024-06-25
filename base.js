$(document).ready(function() {
	subcomponentLoadWatch('base_trimreq', 'n', 11, 350);
	subcomponentLoadWatch('base_drawersreq', 'n', 13, 360);
	subcomponentLoadWatch('base_upholsteryreq', 'n', 12, 370);
	
	// base special widths
	baseSpecialWidthHandler(false);
	
	$("#base_type").change(function() {
		//console.log("base_type changed");
		baseSpecialWidthHandler(true);
	});
	$("#base_width").change(function() {
		//console.log("base_width changed");
		baseSpecialWidthHandler(true);
	});
	
	// base special lengths
	baseSpecialLengthHandler(false);
	
	$("#base_type").change(function() {
		//console.log("base_type changed");
		baseSpecialLengthHandler(true);
	});
	$("#base_length").change(function() {
		//console.log("base_length changed");
		baseSpecialLengthHandler(true);
	});
	
	registerTextareaUsageCounter('base_instructions', 'base_instructions_counter', 250);
	
	// base_fabricreq is a hidden field, and should mirror base_upholsteryreq.
	// This is because if the user selects upholstery then fabric is automatically required.
	setFabricReqHiddenField();
	$("#base_fabricreq").change(function() {
		console.log("base_fabricreq changed");
		setFabricReqHiddenField();
	});
});

// was mattspecialwidthSelected in edit-purchase.asp
function baseSpecialWidthHandler(clearvalues) {
	//console.log("baseSpecialWidthHandler: clearvalues=" + clearvalues);
    $('#id_base_specialwidth1').hide(); // was mattspecialwidth1
    $('#id_base_specialwidth2').hide(); // was mattspecialwidth2

    if (clearvalues) {
        $("#base_specialwidth1").val(""); // was matt1width
        $("#base_specialwidth2").val(""); // was matt2width
    }

    var mattWidth = $("#base_width").val();
    var mattType = $("#base_type").val();
	//console.log("baseSpecialWidthHandler: mattWidth=" + mattWidth);
	//console.log("baseSpecialWidthHandler: mattType=" + mattType);

    if ((mattWidth == "Special Width")
        && ((mattType == "North-South Split") || (mattType == "East-West Split"))) {
        $('#id_base_specialwidth1').show();
        $('#id_base_specialwidth2').show();
    }

    if ((mattWidth == "Special Width")
        && ((mattType != "North-South Split") && (mattType != "East-West Split"))) {
        $('#id_base_specialwidth1').show();
    }
}

// was mattspeciallengthSelected in edit-purchase.asp
function baseSpecialLengthHandler(clearvalues) {
	//console.log("baseSpecialLengthHandler: clearvalues=" + clearvalues);
    $('#id_base_speciallength1').hide(); // was mattspeciallength1
    $('#id_base_speciallength2').hide(); // was mattspeciallength2

    if (clearvalues) {
        $("#base_speciallength1").val(""); // was matt1length
        $("#base_speciallength2").val(""); // was matt2length
    }

    var mattLength = $("#base_length").val();
    var mattType = $("#base_type").val();
	//console.log("baseSpecialLengthHandler: mattLength=" + mattLength);
	//console.log("baseSpecialLengthHandler: mattType=" + mattType);

    if ((mattLength == "Special Length")
        && ((mattType == "North-South Split") || (mattType == "East-West Split"))) {
        $('#id_base_speciallength1').show();
        $('#id_base_speciallength2').show();
    }

    if ((mattLength == "Special Length")
        && ((mattType != "North-South Split") && (mattType != "East-West Split"))) {
        $('#id_base_speciallength1').show();
    }
}

function setFabricReqHiddenField() {
	
}