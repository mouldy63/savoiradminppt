function recordMattressChanged(elmnt) {
	//console.log("recordMattressChanged: " + elmnt.attr('name'));
	if (isComponentElement('mattress-field', elmnt)) {
		$('#mattress-changed').val('y');
	}
}

function recordBaseChanged(elmnt) {
	if (isComponentElement('base-field', elmnt)) {
		$('#base-changed').val('y');
		//console.log("base-changed");
	}
}

function recordTopperChanged(elmnt) {
	if (isComponentElement('topper-field', elmnt)) {
		$('#topper-changed').val('y');
	}
}

function recordValanceChanged(elmnt) {
	if (isComponentElement('valance-field', elmnt)) {
		$('#valance-changed').val('y');
	}
}

function recordLegsChanged(elmnt) {
	if (isComponentElement('legs-field', elmnt)) {
		$('#legs-changed').val('y');
	}
}

function recordHeadboardChanged(elmnt) {
	if (isComponentElement('headboard-field', elmnt)) {
		$('#headboard-changed').val('y');
	}
}

function recordAccessoriesChanged(elmnt) {
	if (isComponentElement('accessories-field', elmnt)) {
		$('#accessories-changed').val('y');
	}
}

function isComponentElement(className, elmnt) {
	var name = elmnt.attr('name');
	return $('#'+name).hasClass(className) || $("input[name='"+name+"']").hasClass(className);
}
