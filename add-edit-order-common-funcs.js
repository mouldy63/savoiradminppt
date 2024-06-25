function clearLegsFields() {
	$('#legstyle').val("");
	$('#legqty').val("");
	$('#legfinish').val("");
	$('#legheight').val("");
	$('#speciallegheight').val("");
	$('#addlegstyle').val("");
	$('#addlegqty').val("");
	$('#addlegfinish').val("");
	$('#specialinstructionslegs').val("");
    $("#floortype option[value='TBC']").attr('selected', 'selected'); // reset floortype selection
}

function defaultAddLegQty() {
    if (!areLegsRequired()) {
    	return;
    }
    
    var basewidth = $("#basewidth").val();
    basewidth = parseInt(basewidth.replace(/[^0-9]/g, '')); // strip out the chars & convert to int
    var basetype = $("#basetype").val();
    
    var addLeqQty = 0;
    if (basetype == "One Piece") {
	    if (basewidth > 139) {
	    	addLeqQty = 7;
	    } else {
	    	addLeqQty = 0;
	    }
    } else if (basetype == "North-South Split") {
	    addLeqQty = 4;
    } else if (basetype == "East-West Split") {
	    if (basewidth > 139) {
	    	addLeqQty = 7;
	    } else {
	    	addLeqQty = 4;
	    }
    }
    $('#addlegqty').val(addLeqQty);
}

function defaultAddLegFinish() {
    if (!areLegsRequired()) {
    	return;
    }
    
    var addlegstyle = $("#addlegstyle").val();
    var finishOptions = [];
    var defaultFinishSelection = "";
    
    if (addlegstyle == "TBC") {
        finishOptions.push("TBC");
    } else if (addlegstyle == "Perspex") {
        finishOptions.push("Perspex clear");
    } else if (addlegstyle == "Cylindrical") {
        finishOptions.push("TBC");
        finishOptions.push("Ebony");
        finishOptions.push("Beech");
        defaultFinishSelection = "Ebony";
    } else if (addlegstyle == "Wooden Tapered") {
        finishOptions.push("TBC");
        finishOptions.push("Natural Maple");
        finishOptions.push("Oak");
        finishOptions.push("Walnut");
        finishOptions.push("Ebony");
        finishOptions.push("Rosewood");
        finishOptions.push("Special (as instructions)");
    } else if (addlegstyle == "Maple") {
        finishOptions.push("TBC");
    }

    $('#addlegfinish').find('option').remove();
    
    $.each(finishOptions, function(val, text) {
        $('#addlegfinish').append($('<option></option>').val(text).html(text));
    });
    
    if (defaultFinishSelection != "") {
        $("#addlegfinish option[value='" + defaultFinishSelection + "']").attr('selected', 'selected');
    }
    
}

function xsetLegQty() {
    if (!areLegsRequired()) {
        return;
    }
    
    var legtype = $("#legstyle option:selected").val();
    var legQty = 4;
    if (legtype == "Penelope" || legtype == "Ball & Claw") {
        legQty = 2;
    }
    $('#legqty').val(legQty);

    //trace("legQty = " + legQty);
}

function areLegsRequired() {
    var legsRequired = $("input[name=legsrequired]:checked").val();
    if (legsRequired == 'n') {
        return false;
    } else {
    	return true;
    }
}

function setLegQty() {
    var basewidth = $("#basewidth option:selected").val();
    var basetype = $("#basetype option:selected").val();
    var legtype = $("#legstyle option:selected").val();
    var legQty = 0;
    var addLegQty = 0;
    var isException = false;
    if (legtype == "Penelope" || legtype == "Ball & Claw") {
    	isException = true;
    }
    console.log("@@@basewidth= " + basewidth);
    console.log("@@@basetype= " + basetype);
    console.log("@@@legtype= " + legtype);

    var rBaseWidth = new String(basewidth); 
    rBaseWidth = rBaseWidth.replace(/[^0-9.]/g, ''); // strip out the chars
    console.log("@@@rBaseWidth= " + rBaseWidth);

    if (basetype == "North-South Split") {
        legQty = 4;
        addLegQty = 4;
        if (isException) {
            legQty = 2;
            addLegQty = 6;
        }
    } else if (basetype == "East-West Split") {
        legQty = 4;
        addLegQty = 4;
        if (rBaseWidth > 139) addLegQty = 7;
        if (isException) {
            legQty = 2;
            addLegQty = 6;
            if (rBaseWidth > 139) addLegQty = 9;
        }
    } else if (basewidth != "n") {
        legQty = 4;
        addLegQty = 0;
        if (rBaseWidth > 139) addLegQty = 7;
        if (isException) {
            legQty = 2;
            addLegQty = 2;
            if (rBaseWidth > 139) addLegQty = 9;
        }
    }
    $('#legqty').val(legQty);
    $('#addlegqty').val(addLegQty);
    //console.log("@@@legqty= " + legQty);
    //console.log("@@@addlegqty= " + addLegQty);
}

