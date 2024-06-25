$(document).ready(function() {
	registerTextareaUsageCounter('headboard_fabric_desc', 'headboard_fabric_desc_counter', 250);
	registerTextareaUsageCounter('headboard_instructions', 'headboard_instructions_counter', 250);

	// headboard_trimreq is a hidden field, and is set to y when headboard_manhattantrim is set.
	setHeadboardTrimReqHiddenField();
	$("#headboard_manhattantrim").change(function() {
		setHeadboardTrimReqHiddenField();
	});

	showHideManhattanTrimSelect();
	showHideFootboardOptions();
	$("#headboard_style").change(function() {
		showHideManhattanTrimSelect();
		showHideFootboardOptions();
	});
});

function setHeadboardTrimReqHiddenField() {
	var headboardTrimReq = 'y';
	if ($("#headboard_manhattantrim").val() == 'n') {
		headboardTrimReq = 'n';
	}
	$("#headboard_trimreq").val(headboardTrimReq);
}

function showHideManhattanTrimSelect() {
    var hbStyle = $("#headboard_style").val();

    if (hbStyle && (hbStyle.substring(0, 9) == 'Manhattan' || hbStyle == 'Holly' || hbStyle == 'Hatti' || hbStyle == 'Harlech (CF2)' || hbStyle == 'Lotti (CF4)' || hbStyle == 'Leo (CF5)' || hbStyle == 'Winston (Stitched)' || hbStyle == 'C2' || hbStyle == 'C4' || hbStyle == 'C5' || hbStyle == 'CF2' || hbStyle == 'CF4' || hbStyle == 'CF5')) {
		$('.headboardTrimClass').show();
    } else {
        $("#headboard_manhattantrim").val('n');
		$('.headboardTrimClass').hide();
    }
    setHeadboardTrimReqHiddenField();
}

function showHideFootboardOptions() {
    var hbStyle = $("#headboard_style").val();

    if (hbStyle && (hbStyle.substring(0, 30) == 'Gorrivan Headboard & Footboard')) {
        $('.footboardClass').show();
    } else {
        $('.footboardClass').hide();
    }
}