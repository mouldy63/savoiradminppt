$(document).ready(function() {

	// legs_addreq is a hidden field, and should be set to y if the legs_addqty > 0.
	setAddLegsReqHiddenField();
	$("#legs_addqty").change(function() {
		setAddLegsReqHiddenField();
	});

	showFloorType();
	$("#legs_style").change(function() {
		showFloorType();
	});
	
	legsSpecialHeightSelected();
	$("#legs_height").change(function() {
		legsSpecialHeightSelected();
	});
	
	registerTextareaUsageCounter('legs_specialinstructions', 'legs_specialinstructions_counter', 130);
	
});

function setAddLegsReqHiddenField() {
	var addLegsReq = 'y';
	if ($("#legs_addqty").val() == '0') {
		addLegsReq = 'n';
	}
	$("#legs_addreq").val(addLegsReq);
}

function showFloorType() {
	var slct = $("#legs_style option:selected").val();
	if (slct == "Castors") {
		$('.legs_floortype_class').show();
	} else {
		$('.legs_floortype_class').hide();
		$("#legs_floortype").val('');
	}
}

function legsSpecialHeightSelected() {
	var slct = $("#legs_height").val();
	if (slct == "Special Height") {
		$('.legs_specialheight_class').show();
	} else {
		$('.legs_specialheight_class').hide();
		$("#legs_specialheight").val('');
	}
}