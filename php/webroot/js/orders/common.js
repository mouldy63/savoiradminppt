var jspn;
var loadingComponentCount = 0;

function topComponentLoadWatch(compName, compId) {
	// initial load
	var compSelectId = "order_" + compName + "req";
	loadOrderTopComponent(compSelectId, compId);
	$("#"+compSelectId + "_y").change(function() {
		// watch for changes
		loadOrderTopComponent(compSelectId, compId);
	});	
	$("#"+compSelectId + "_n").change(function() {
		// watch for changes
		loadOrderTopComponent(compSelectId, compId);
	});	
}

function loadOrderTopComponent(compSelectId, compId) {
	var val = $("input[name='" + compSelectId + "']:checked").val();
	if (val == 'n') {
		unloadOrderComponent(compId);
	} else {
		loadOrderComponent(compId);
	}
}

function subcomponentLoadWatch(subcompSelectId, unloadVal, subcompId) {
	// initial load
	loadOrderSubcomponent(subcompSelectId, unloadVal, subcompId);
	$("#"+subcompSelectId).change(function() {
		// watch for changes
		loadOrderSubcomponent(subcompSelectId, unloadVal, subcompId);
	});	
}

function loadOrderSubcomponent(subcompSelectId, unloadVal, subcompId) {
	var val = $("#"+subcompSelectId).val();
	if (val == unloadVal) {
		unloadOrderComponent(subcompId);
	} else {
		loadOrderComponent(subcompId);
	}
}

function loadOrderComponent(compId) {
	loadingComponentCount += compId;
	console.log("loadOrderComponent CALLED for " + compId + " loadingComponentCount=" + loadingComponentCount);
	var url = "component?pn=" + jspn + "&compId=" + compId;
    $('#' + jsComponentNames[compId]).load(url, function() {
    	loadingComponentCount -= compId;
    	console.log("loadOrderComponent COMPLETE for " + compId + " loadingComponentCount=" + loadingComponentCount);
   	});
}

function unloadOrderComponent(compId) {
	console.log("unloadOrderComponent called for " + compId);
    $('#' + jsComponentNames[compId]).html('');
}

function setCallRefreshPriceTableOnChange(changedFieldName, changedFieldId, compObj, compId, compName) {
	console.log("@@@ setCallRefreshPriceTableOnChange: " + changedFieldName + " " + changedFieldId);
	console.log("loadingComponentCount = " + loadingComponentCount);
	if (loadingComponentCount > 0) {
		setTimeout(function() {
			setCallRefreshPriceTableOnChange(changedFieldName, changedFieldId, compObj, compId, compName);
		}, 250)
		return;
	}
	if ($("#" + changedFieldId).length) {
		// Deregister previous pricetable related onchange handlers to prevent multiple submissions. This happens when a subcomponent is reloaded.
		console.log("@@@ setCallRefreshPriceTableOnChange called for " + changedFieldId);
		$("#" + changedFieldId).off("change.pricetable_compid"+compId);
		$("#" + changedFieldId).on("change.pricetable_compid"+compId, function() {
			compObj.refreshPriceTable(compId, changedFieldName, changedFieldId, compName);
		});
	}
}

function registerTextareaUsageCounter(taDivId, counterDivId, sizeLimit) {
	$('#'+taDivId).keyup(function() {
		  var len = $(this).val().length;
		  $("#"+counterDivId).html(sizeLimit-len + "/" + sizeLimit);
	});
	$('#' + taDivId).attr('maxlength', sizeLimit);
	$('#' + taDivId).keyup(); // make sure we start with the current usage displayed
}