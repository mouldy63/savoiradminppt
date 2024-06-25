var observersFieldList = [];
var observedFieldList = [];

function CompObj(pn) {
	
	this.pn = pn;
	this.priceAffectingFieldList = [];

	this.addObserverPairToList = function(observedControl, observingControl) {
		if (!observedFieldList.includes(observedControl) || !observersFieldList.includes(observingControl)) {
			console.log("CompObj.addObserverPairToList: " + observedControl + "->" + observingControl);
			observedFieldList.push(observedControl); 
			observersFieldList.push(observingControl); 
		}
    }

	this.observedControlChanged = function(theObserved, theObserver) {
		console.log("CompObj.observedControlChanged called with theObserved=" + theObserved + " & theObserver=" + theObserver);
		var n = 0;
		var that = this;
		observedFieldList.forEach(function(observedControl) {
			if (observedControl == theObserved && observersFieldList[n] == theObserver) {
				console.log("CompObj.observedControlChanged called for " + theObserved);
				that.getNewObserverValue(theObserved, observersFieldList[n], "observedControlChanged");
			}
			n++;
		});
	}
	
	this.registerPriceAffectingField = function(theFieldName) {
		if (!this.priceAffectingFieldList.includes(theFieldName)) {
			this.priceAffectingFieldList.push(theFieldName); 
		}
	}

	this.getNewObserverValue = function(theObserved, theObserver, theCaller) {
		if (!$("#" + theObserver).length) {
			// the observer doesn't exist - this can happen when a sub-component is unloaded
			return;
		}
		//console.log("CompObj.getNewObserverValue called with theObserved=" + theObserved + " theObserver=" + theObserver);
		console.log("CompObj.getNewObserverValue: called by " + theCaller);
		// get the current values of the observed controls
		var form = $("#" + theObserved).closest("form");
		var serializeArray = form.serializeArray();
		var indexedArray = {};
		var that = this;
		$.map(serializeArray, function(n, i){
			//observedFieldList.forEach(function(observedControl) {
	    	//	if (observedControl == n['name']) {
	    	        indexedArray[n['name']] = n['value'];
	    	//	}
	    	//});
	    });
		var formData = encodeURIComponent(JSON.stringify(indexedArray));
		
		// get the new values and the default from the server
		var firedVal = $("#" + theObserved).val();
		var observerValue = $("#" + theObserver).val();
		var url = "component/getDropdownData?pn=" + this.pn + "&formdata=" + formData + "&observed=" + theObserved + "&observedValue=" + encodeURI(firedVal) + "&observer=" + theObserver + "&observerValue=" + encodeURI(observerValue);
		console.log("CompObj.getNewObserverValue: url=" + url);
		$.getJSON(url, function(dropdownValues) {
			// clear the old values from the dropdown, and repopulate
			//console.log("CompObj.getNewObserverValue: dropdownValues=" + dropdownValues);
			$('#' + theObserver).find('option').remove();
			var selectedKey = '';
			$('#' + theObserver).append($('<option></option>').val('').html('(choose one)'));
			$.each(dropdownValues, function(key, text){
				if (key == 'SELECTED') {
					selectedKey = text;
				} else {
					$('#' + theObserver).append($('<option></option>').val(key).html(text));
				}
	        });
			if (selectedKey != '') {
				$("#" + theObserver + " option[value='" + selectedKey + "']").attr('selected', 'selected');
			}
		});
	}
	
	this.refreshPriceTable = function(compId, changedFieldName, changedFieldId, compName) {
		console.log("CompObj.refreshPriceTable called with changedFieldName=" + changedFieldName);
		// get the current values of the price affecting fields
		//var form = $("#" + compName + "_form");
		var form = $("#" + changedFieldId).closest("form");
		var serializeArray = form.serializeArray();
		var indexedArray = {};
		var that = this;
		$.map(serializeArray, function(n, i) {
			//that.priceAffectingFieldList.forEach(function(field) {
	    	//	if (field == n['name']) {
	    	        indexedArray[n['name']] = n['value'];
	    	//	}
	    	//});
	    });
		// add some stuff from the order form
		var orderCurrency = $('#order_currency').val();
		var vatRate = $('#order_vatrate').val();
		var isTrade = $('#order_istrade').val();

		var formData = encodeURIComponent(JSON.stringify(indexedArray));
		//console.log("formData = " + formData);
		
		// load the pricing table
		var url = "component/pricingTable?pn=" + this.pn + "&compId=" + compId + "&changedFieldName=" + changedFieldName + "&formdata=" + formData + "&ordercurrency=" + orderCurrency + "&vatrate=" + encodeURIComponent(vatRate) + "&istrade=" + isTrade;
		console.log("compobj loading " + compId + " pricing table");
		//console.log("url=" + url);
		$('#' + compName + '_pricing').load(url);
	}
}
