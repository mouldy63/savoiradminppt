jQuery.ajaxSetup({
	async : false
});

function wrapTypeChangeHandler() {
	checkWrapShow();
	checkWrapType();
	checkCrateShow();
	var wraptype = $("#wraptype").val();

	// MATTRESS
	if (wraptype == 4) {
		// crate
		defaultCrateSize('1','matt1_packwidth','matt1_packheight','matt1_packdepth','mattressCrateType','matt_crateqty', false);
		defaultCrateSize('1','matt2_packwidth','matt2_packheight','matt2_packdepth','mattressCrateType2','matt_crateqty', false);
		defaultCrateWeight('1','mattressCrateType','matt1cratewgt','matt_crateqty', false);
		defaultCrateWeight('1','mattressCrateType','matt2cratewgt','matt_crateqty', false);
		defaultCompWeight('1', 'js_savoirmodel', 'js_matt1width', 'js_matt1length', 'crateprodwgt1_1', false);
		defaultCompWeight('1', 'js_savoirmodel', 'js_matt2width', 'js_matt2length', 'crateprodwgt1_2', false);
		setTotalWeight('matt1cratewgt', 'crateprodwgt1_1', 'matt1_packkg');
		setTotalWeight('matt2cratewgt', 'crateprodwgt1_2', 'matt2_packkg');
		disablefield('mattressCrateType','matt1_packwidth','matt1_packheight','matt1_packdepth');
	}
	if (wraptype == 3) {
		// box mattress
		defaultBoxSize('1','matt1boxsize','matt2boxsize',false);
		defaultBoxWeight('1', 'matt1boxsize', 'matt1boxwgt', false);
		defaultBoxWeight('1', 'matt2boxsize', 'matt2boxwgt', false);
		defaultCompWeight('1', 'js_savoirmodel', 'js_matt1width', 'js_matt1length', 'boxprodwgt1_1', false);
		defaultCompWeight('1', 'js_savoirmodel', 'js_matt2width', 'js_matt2length', 'boxprodwgt1_2', false);
		setTotalWeight('matt1boxwgt', 'boxprodwgt1_1', 'matt1kg');
		setTotalWeight('matt2boxwgt', 'boxprodwgt1_2', 'matt2kg');
	}
	// END MATTRESS
	// Begin base
	if (wraptype == 4) {
		// crate
		defaultCrateSize('3','base1_packwidth','base1_packheight','base1_packdepth','baseCrateType','base_crateqty', false);
		defaultCrateSize('3','base2_packwidth','base2_packheight','base2_packdepth','baseCrateType2','base_crateqty', false);
		defaultCrateWeight('3','baseCrateType','base1cratewgt','base_crateqty', false);
		defaultCrateWeight('3','baseCrateType','base2cratewgt','base_crateqty', false);
		defaultCompWeight('3', 'js_basesavoirmodel', 'js_base1width', 'js_base1length', 'crateprodwgt3_1', false);
		defaultCompWeight('3', 'js_basesavoirmodel', 'js_base2width', 'js_base2length', 'crateprodwgt3_2', false);
		setTotalWeight('base1cratewgt', 'crateprodwgt3_1', 'base1_packkg');
		setTotalWeight('base2cratewgt', 'crateprodwgt3_2', 'base2_packkg');
		disablefield('baseCrateType','base1_packwidth','base1_packheight','base1_packdepth');
	}
	if (wraptype == 3) {
	
	defaultBoxSize('3','base1boxsize','base2boxsize',false);
	defaultBoxWeight('3', 'base1boxsize', 'base1boxwgt', false);
	defaultBoxWeight('3', 'base2boxsize', 'base2boxwgt', false);
	defaultCompWeight('3', 'js_basesavoirmodel', 'js_base1width', 'js_base1length', 'boxprodwgt3_1', false);
	defaultCompWeight('3', 'js_basesavoirmodel', 'js_base2width', 'js_base2length', 'boxprodwgt3_2', false);
	setTotalWeight('base1boxwgt', 'boxprodwgt3_1', 'base1kg');
	setTotalWeight('base2boxwgt', 'boxprodwgt3_2', 'base2kg');
	// END base
	}
	// Begin topper
	if (wraptype == 4) {
		// crate
		defaultCrateSize('5','topper1_packwidth','topper1_packheight','topper1_packdepth','topperCrateType','topper_crateqty', false);
		defaultCrateWeight('5','topperCrateType','topper1cratewgt','topper_crateqty', false);
		defaultCompWeight('5', 'js_toppertype', 'js_topper1width', 'js_topper1length', 'crateprodwgt5_1', false);
		setTotalWeight('topper1cratewgt', 'crateprodwgt5_1', 'topper1_packkg');
		disablefield('topperCrateType','topper1_packwidth','topper1_packheight','topper1_packdepth');
	}
	if (wraptype == 3) {
	
	defaultBoxSize('5','topper1boxsize','',false);
	defaultBoxWeight('5', 'topper1boxsize', 'topper1boxwgt', false);
	defaultCompWeight('5', 'js_toppertype', 'js_topper1width', 'js_topper1length', 'boxprodwgt5_1', false);
	setTotalWeight('topper1boxwgt', 'boxprodwgt5_1', 'topper1kg');
	// END topper
	}
	// Begin LEGS
	if (wraptype == 4) {
		// crate
		defaultCrateSize('7','legs1_packwidth','legs1_packheight','legs1_packdepth','legsCrateType','legs_crateqty', false);
		defaultCrateWeight('7','legsCrateType','legs1cratewgt','legs_crateqty', false);
		defaultCompWeight('7', 'js_legstyle', 'js_legs1width', 'js_legs1length', 'crateprodwgt7_1', false);
		setTotalWeight('legs1cratewgt', 'crateprodwgt7_1', 'legs1_packkg');
		disablefield('legsCrateType','legs1_packwidth','legs1_packheight','legs1_packdepth');
	}
	if (wraptype == 3) {
		
		defaultBoxSize('7','legs1boxsize','',false);
		defaultBoxWeight('7', 'legs1boxsize', 'legs1boxwgt', false);
		defaultCompWeight('7', 'js_legstyle', 'js_legqty', '', 'boxprodwgt7_1', false);
		setTotalWeight('legs1boxwgt', 'boxprodwgt7_1', 'legs1kg');
		// END LEGS
	}
	// Begin valance
	if (wraptype == 3) {
	
		defaultBoxSize('6','valance1boxsize','',false);
		defaultBoxWeight('6', 'valance1boxsize', 'valance1boxwgt', false);
		defaultCompWeight('6', 'js_valance', 'js_valance1width', 'js_valance1length', 'boxprodwgt6_1', false);
		setTotalWeight('valance1boxwgt', 'boxprodwgt6_1', 'valance1kg');
	
	}
	if (wraptype == 4) {
	
		defaultCrateSize('6','valance1_packwidth','valance1_packheight','valance2_packdepth','valanceCrateType','valance_crateqty', false);
		defaultCrateWeight('6','valanceCrateType','valance1cratewgt','valance_crateqty', false);
		defaultCompWeight('6', 'js_valance', 'js_valance1width', 'js_valance1length', 'crateprodwgt6_1', false);
		setTotalWeight('valance1cratewgt', 'crateprodwgt6_1', 'valance1_packkg');
		disablefield('valanceCrateType','valance1_packwidth','valance1_packheight','valance1_packdepth');
	}
	// END valance	defaultCrateSize('6','valance1_packwidth','valance1_packheight','valance1_packdepth','valanceCrateType','valance_crateqty',false);
	//defaultCrateSize('6','valance2_packwidth','valance2_packheight','valance2_packdepth','valanceCrateType2','valance_crateqty',false);
//	disablefield('valanceCrateType','valance1_packwidth','valance1_packheight','valance1_packdepth');
	
	//defaultCrateSize('7','legs1_packwidth','legs1_packheight','legs1_packdepth','legsCrateType','legs_crateqty',false);
	//defaultCrateSize('7','legs2_packwidth','legs2_packheight','legs2_packdepth','legsCrateType2','legs_crateqty',false);
	//disablefield('legsCrateType','legs1_packwidth','legs1_packheight','legs1_packdepth');
	
	if (wraptype == 4) {
		defaultCrateSize('8','hb1_packwidth','hb1_packheight','hb1_packdepth','hbCrateType','hb_crateqty', true);
		defaultCrateSize('8','hb2_packwidth','hb2_packheight','hb2_packdepth','hbCrateType','hb_crateqty', true);
		defaultCrateWeight('8','hbCrateType','hb1cratewgt','hb_crateqty', true);
		defaultCrateWeight('8','hbCrateType','hb2cratewgt','hb_crateqty', true);
		defaultCompWeight('8', 'js_headboardstyle', 'js_hb1width', '', 'crateprodwgt8_1', true);
		defaultCompWeight('8', 'js_headboardstyle', 'js_hb1width', '', 'crateprodwgt8_2', true);
		setTotalWeight('hb1cratewgt', 'crateprodwgt8_1', 'hb1_packkg');
		setTotalWeight('hb2cratewgt', 'crateprodwgt8_2', 'hb2_packkg');
		disablefield('hbCrateType','hb1_packwidth','hb1_packheight','hb1_packdepth');
	}
	if (wraptype == 3) {
		defaultBoxSize('8','hb1boxsize','hb2boxsize',false);
		defaultBoxWeight('8', 'hb1boxsize', 'hb1boxwgt', false);
		defaultBoxWeight('8', 'hb2boxsize', 'hb2boxwgt', false);
		defaultCompWeight('8', 'js_headboardstyle', 'js_hb1width', '', 'boxprodwgt8_1', false);
		defaultCompWeight('8', 'js_headboardstyle', 'js_hb1width', '', 'boxprodwgt8_2', false);
		setTotalWeight('hb1boxwgt', 'boxprodwgt8_1', 'hb1kg');
		setTotalWeight('hb2boxwgt', 'boxprodwgt8_2', 'hb2kg');
	}
	if (wraptype == 1 || wraptype == 2) {
		defaultCompWeight('8', 'js_headboardstyle', 'js_hb1width', '', 'boxprodwgt8_1', false);
		setTotalWeight('hb1boxwgt', 'boxprodwgt8_1', 'hb_packkg');
	}
	
	if (wraptype == 4) {
		defaultCrateSize('9','acc1_packwidth','acc1_packheight','acc1_packdepth','accCrateType','acc_crateqty', true);
		defaultCrateSize('9','acc2_packwidth','acc2_packheight','acc2_packdepth','accCrateType','acc_crateqty', true);
		defaultCrateWeight('9','accCrateType','acc1cratewgt','acc_crateqty', true);
		defaultCrateWeight('9','accCrateType','acc2cratewgt','acc_crateqty', true);
		setTotalWeight('acc1cratewgt', 'crateprodwgt9_1', 'acc1_packkg');
		setTotalWeight('acc2cratewgt', 'crateprodwgt9_2', 'acc2_packkg');
		disablefield('accCrateType','acc1_packwidth','acc1_packheight','acc1_packdepth');
	}
	
	if (wraptype == 3) {
		defaultBoxSize('9','acc1boxsize','acc2boxsize',false);
		defaultBoxWeight('9', 'acc1boxsize', 'acc1boxwgt', false);
		defaultBoxWeight('9', 'acc2boxsize', 'acc2boxwgt', false);
		setTotalWeight('acc1boxwgt', 'boxprodwgt9_1', 'acc1kg');
		setTotalWeight('acc2boxwgt', 'boxprodwgt9_2', 'acc2kg');
	}
	
	//defaultCrateSize('9','acc1_packwidth','acc1_packheight','acc1_packdepth','accCrateType','acc_crateqty',false);
	//defaultCrateSize('9','acc2_packwidth','acc2_packheight','acc2_packdepth','accCrateType2','acc_crateqty',false);
	//disablefield('accCrateType','acc1_packwidth','acc1_packheight','acc1_packdepth');
	
	
	//defaultBoxSize('3','base1boxsize','base2boxsize',false);
	//defaultBoxSize('5','topper1boxsize','',false);
	defaultBoxSize('6','valance1boxsize','', false);
	//defaultBoxSize('7','legs1boxsize','', false);
	defaultBoxSize('9','acc1boxsize','', false);
	defaultWrapSize('8','hb_packwidth','hb_packheight','hb_packdepth','hb_packkg');
	
	// null the accessory boxes
	$("#acc_packdesc").val("");
	$("#acc_packkg").val("");
	$("#acc_packtariffcode").val("");
	$("#acc_packwidth").val("");
	$("#acc_packheight").val("");
	$("#acc_packdepth").val("");
	
	getAccBoxSizes(); // default the accessory box size
	
	// default the packed with dropdowns, if not already set
	if ($("#wraptype").val() == 4) {
		if (defaultCratePackedWith('6', 'valancePackedWith')) {
			getCratePackedWith('6','valancePackedWith','valancepackedwithcompnofield');
		}
		if (defaultCratePackedWith('7', 'legsPackedWith')) {
			getCratePackedWith('7','legsPackedWith','legspackedwithcompnofield');
		}
		if (defaultCratePackedWith('9', 'accPackedWith')) {
			getCratePackedWith('9','accPackedWith','accpackedwithcompnofield');
		}
	}
	
	if ($("#wraptype").val() == 3) {
		if (defaultBoxPackedWith('6', 'valanceBoxPackedWith')) {
			getBoxPackedWith('6','valanceBoxPackedWith');
		}
		if (defaultBoxPackedWith('9', 'accBoxPackedWith')) {
			getBoxPackedWith('9','accBoxPackedWith');
		}
	}
	
	// populate the accessories packed with dropdowns
	populateAccPackedWithDropdown($("#wraptype").val());
}

function populateAccPackedWithDropdown(wraptype) {
	// clear the exists options
	for (var i = 1; i <= 20; i++) {
		var slctId = "#acc_packedwith" + i;
		if ( $(slctId).length ) {
			if (wraptype == 2) {
				// remove the non-accessories as they are not valid for export
				$(slctId + " option[value='1']").remove();
				$(slctId + " option[value='3']").remove();
				$(slctId + " option[value='5']").remove();
				$(slctId + " option[value='7']").remove();
				$(slctId + " option[value='8']").remove();
			} else if (wraptype == 3) {
				// add the non-accessories
				if (orderHasComponent(5)) {
					$(slctId).append('<option value="5">Topper</option>');
				}
				if (orderHasComponent(1)) {
					$(slctId).append('<option value="1">Mattress</option>');
				}
				if (orderHasComponent(3)) {
					$(slctId).append('<option value="3">Base</option>');
				}
				if (orderHasComponent(7)) {
					$(slctId).append('<option value="7">Legs</option>');
				}
				if (orderHasComponent(8)) {
					$(slctId).append('<option value="8">Headboard</option>');
				}
			}
		}
	}
}

function crateQtyChanged(CompNo, boxCtrlId1, boxCtrlId2, boxCtrlId3, boxCtrlId4, crateTypeDropdownName, crateQtyDropdownName) {
	var crateType = $("#" + crateTypeDropdownName).val();
	if (crateType=="Special Size Crate") {
		// don't want to default the sizes and weights if it's a special and it's just the qty that's been changed
		
		var crateqty = 1;
		if (crateQtyDropdownName != '') {
			crateqty = parseInt($("#" + crateQtyDropdownName).val());
		}
		if (crateqty == 2 && boxCtrlId1.indexOf("2") != -1) {
			// also, if the qty has been increased to 2, then clear out any sizes and weights for the 2nd crate
			// boxCtrlId1.indexOf("2") checks that these are the 2nd crate fields, as it's only them we want to blank out
			$("#" + boxCtrlId1).val(""); // length
			$("#" + boxCtrlId2).val(""); // height
			$("#" + boxCtrlId3).val(""); // width
			$("#" + boxCtrlId4).val(""); // weight
		}
		return;
	}
	
	getChangedCrateSize(CompNo, boxCtrlId1, boxCtrlId2, boxCtrlId3, boxCtrlId4, crateTypeDropdownName, crateQtyDropdownName);
}

function getChangedCrateSize(CompNo, boxCtrlId1, boxCtrlId2, boxCtrlId3, boxCtrlId4, crateTypeDropdownName, crateQtyDropdownName) {
	var crateType = $("#" + crateTypeDropdownName).val();
	var crateqty = 1;
	if (crateQtyDropdownName != '') {
		crateqty = parseInt($("#" + crateQtyDropdownName).val());
	}
	if (crateType=="CratePackAlt") {
		// not sure what CratePackAlt is, but leaving it for now 
	} else {
		var url = "ajaxGetDefaultCrateSizes.asp?expak=" + encodeURIComponent(crateType) + "&ts=" + (new Date()).getTime();
		$.get(url, function(data) {
			var vals = data.split(",");
			$("#" + boxCtrlId1).val(vals[0]); // length
			$("#" + boxCtrlId2).val(vals[1]); // height
			$("#" + boxCtrlId3).val(vals[2]); // width
			
			// the total weight to display is the sum of the crate, the component and the items packed with it, if any (e.g. legs) 
			var weight = parseInt(vals[3]) * crateqty; // this is just the crate weight
			//console.log("getChangedCrateSize: crate weight=" + weight);
			var url = "ajaxGetDefaultCrateWrapN.asp?pn=" + jsPn + "&compid=" + CompNo + "&ts=" + (new Date()).getTime();
			console.log("url=" + url);
			$.get(url, function(data2) {
				var vals2 = data2.split(",");
				//console.log("getChangedCrateSize: component weight=" + vals2[6]);
				weight = weight + parseInt(vals2[6]); // add in the component weight
				
				var legsPrevPackedWithCompId = $("#legspackedwithcompnofield").val();
				if (legsPrevPackedWithCompId == CompNo) {
					// the legs were packed with this comp, so add the weight of the legs on
					weight = weight + getComponentWeight(7);
				}
				
				var accPrevPackedWithCompId = $("#accpackedwithcompnofield").val();
				if (accPrevPackedWithCompId == CompNo) {
					// the accessories were packed with this comp, so add the weight of the accessories on
					weight = weight + getComponentWeight(9);
				}
	
				var valPrevPackedWithCompId = $("#valancepackedwithcompnofield").val();
				if (valPrevPackedWithCompId == CompNo) {
					// the valance was packed with this comp, so add the weight of the valance on
					weight = weight + getComponentWeight(6);
				}
	
				$("#" + boxCtrlId4).val(weight); // weight
			});
		});
	}
}

function checkSpecialCrateQty(compID, crateTypeDropdownName, crateQty, crate2show) {
	var crateType = $("#" + crateTypeDropdownName).val();
	var crateNo = $("#" + crateQty).val();
	if (crateType == 'Special Size Crate' && crateNo == 2) {
		$('.' + crate2show).show();
	} else {
		$('.' + crate2show).hide();
	}
	//console.log("checkSpecialCrateQty: crate2show=" + crate2show);
}

/**
 * Returns the weight of the component, using ajax. Only works for items that can be packed with others at the mo (i.e. compid=6, 7 or 9)
 */
function getComponentWeight(compId) {
    var weight = 0;
    var url = "ajaxGetDefaultCompWeight.asp?pn=" + jsPn + "&compno=" + compId + "&ts=" + (new Date()).getTime();
    $.ajax({
        url:url,
        method: "GET",
        async: false,
        success:function(response) {
        	weight = response;
        	if (weight == '') weight = 0;
        }
    });
    return parseInt(weight);
}

// equiv of getChangedCrateSize for boxes
function getBoxWeight(CompNo, CompName, dropdown, am1width, am1length, aWeightField) {
	var boxName = $("#" + dropdown).val();
	var url = "ajaxGetBoxWeight.asp?pn=" + jsPn + "&compid=" + CompNo + "&compname=" + CompName + "&boxname=" + boxName + "&width=" + am1width + "&length=" + am1length + "&ts=" + (new Date()).getTime();
	$.get(url, function(boxAndCompWeight) {

		var totalWeight = parseInt(boxAndCompWeight);
		var valPrevPackedWithCompId = $("#valanceboxpackedwithcompnofield").val();
		var packedWithCompId = 0;
		if (valPrevPackedWithCompId == CompNo) {
			// the valance was packed with this comp, so add the weight of the valance on
			packedWithCompId = 6;
		}
		if (packedWithCompId != 0) {
			totalWeight = totalWeight + getComponentWeight(packedWithCompId);
		}
	
		$("#" + aWeightField).val(totalWeight);
	});
}

function getAccBoxSizes() {
	var compId = 9;
	if (!orderHasComponent(compId)) {
		return;
	}
	
	var wrapType = $("#wraptype").val();
	if (wrapType != 3) {
		$("#acc_packwidth").val('');
		$("#acc_packheight").val('');
		$("#acc_packdepth").val('');
		$("#acc_packkg").val('');
		return;
	}

	var packedWithCompId = $("#accBoxPackedWith").val();
	if (typeof packedWithCompId === "undefined") {
		packedWithCompId = "";
	}
	if (packedWithCompId != "" && packedWithCompId != "0") {
		// as it's packed with something, ensure the size fields are empty
		$("#acc_packwidth").val('');
		$("#acc_packheight").val('');
		$("#acc_packdepth").val('');
		$("#acc_packkg").val('');
		return;
	}
	

	var boxName = $("#acc1boxsize").val();
	if (typeof boxName === "undefined") boxName = "Small"; // so that when we call ajaxGetAccBoxWeight.asp we get the values for a Small box
	if (boxName == "Special") {
		// can't get sizes for special
		return;
	}
	var url = "ajaxGetAccBoxWeight.asp?pn=" + jsPn + "&compid=" + compId + "&compname=&boxname=" + boxName + "&width=&length=&ts=" + (new Date()).getTime();
	$.get(url, function(data) {
		 var vals = data.split(",");
		$("#acc_packkg").val(vals[0]);
		$("#acc_packwidth").val(vals[1]);
		$("#acc_packheight").val(vals[2]);
		$("#acc_packdepth").val(vals[3]);
		// remove 'Special' from options, if present
		$("#acc1boxsize option[value='Special']").remove();
	});
}

function getAccCrateSizes() {
	var compId = 9;
	if (!orderHasComponent(compId)) {
		return;
	}
	
	var wrapType = $("#wraptype").val();
	if (wrapType != 4) {
		$("#acc1_packwidth").val('');
		$("#acc1_packheight").val('');
		$("#acc1_packdepth").val('');
		$("#acc1_packkg").val('');
		return;
	}

	var packedWithCompId = $("#accPackedWith").val();
	if (typeof packedWithCompId === "undefined") {
		packedWithCompId = "";
	}
	if (packedWithCompId != "" && packedWithCompId != "0") {
		// as it's packed with something, ensure the size fields are empty
		$("#acc1_packwidth").val('');
		$("#acc1_packheight").val('');
		$("#acc1_packdepth").val('');
		$("#acc1_packkg").val('');
		return;
	}

	var url = "ajaxGetDefaultCrateWrapN.asp?pn=" + jsPn + "&compid=" + compId + "&ts=" + (new Date()).getTime();
	$.get(url, function(data) {
		 var vals = data.split(",");
		$("#acc1_packwidth").val(vals[0]);
		$("#acc1_packheight").val(vals[1]);
		$("#acc1_packdepth").val(vals[2]);
		$("#acc1_packkg").val(vals[3]);
	});
}

function handleAccBoxSizeChange() {
	//console.log("changed");
	var newOption = $('<option value="Special">Special</option>');
	$('#acc1boxsize').append(newOption);
	$("#acc1boxsize option[value='Special']").prop('selected', true);
}

function defaultCrateSize(CompNo, boxCtrlId1, boxCtrlId2, boxCtrlId3, boxCtrlId5, boxCtrlId6, isPageLoad) {
	if (CompNo == '8') {
		var x = 1;
	}
	if (!orderHasComponent(CompNo)) {
		return;
	}
	
	var slct = $("#wraptype").val();
	if (slct == 4) {
		if (isPageLoad && (fieldHasValue(boxCtrlId1) || fieldHasValue(boxCtrlId2) || fieldHasValue(boxCtrlId3))) {
			// do nothing
		} else {
			var url = "ajaxGetDefaultCrateWrapN.asp?pn=" + jsPn + "&compid=" + CompNo + "&ts=" + (new Date()).getTime();
			$.get(url, function(data) {
				var vals = data.split(",");
				$("#" + boxCtrlId1).val(vals[0]);
				$("#" + boxCtrlId2).val(vals[1]);
				$("#" + boxCtrlId3).val(vals[2]);
				if (boxCtrlId5 != '') {
					$("#" + boxCtrlId5 + " option[value='" + vals[4] + "']").prop('selected', true);
				}
				if (boxCtrlId6 != '') {
					$("#" + boxCtrlId6 + " option[value='" + vals[5] + "']").prop('selected', true);
				}
			});
		}
	}
}

function defaultBoxWeight(CompNo, dropdown, boxWeightCtrlId, isPageLoad) {
	
	if (!orderHasComponent(CompNo)) {
		return;
	}
	var slct = $("#wraptype").val();
	if (slct == 3) {
		if (isPageLoad && fieldHasValue(boxWeightCtrlId)) {
		} else {
			var boxname = $("#" + dropdown).val();
			if (boxname=="Leg Box") {
				boxname="LegBox";
			} 
			if (boxname=="Double Leg Box") {
				boxname="DoubleLegBox";
			}
			var url = "ajaxGetBoxWeightOnly.asp?boxname=" + boxname + "&ts=" + (new Date()).getTime();
			$.get(url, function(boxWeight) {
				console.log('boxWeight='+boxWeight);
				$("#" + boxWeightCtrlId).val(boxWeight);
			});
		}
	}
}

function defaultCompWeight(CompNo, compNameCtrlId, widthCtrlId, lengthCtrlId, compWeightCtrlId, isPageLoad) {
	
	if (!orderHasComponent(CompNo)) {
		return;
	}
	var slct = $("#wraptype").val();
	if (slct == 3 || slct == 4) {
		if (isPageLoad && fieldHasValue(compWeightCtrlId)) {
		} else {
			var boxname = 'Small'; // dummy value, as the box weight cancels itself out in the calc below
			var url = "ajaxGetBoxWeightOnly.asp?boxname=" + boxname + "&ts=" + (new Date()).getTime();
			$.get(url, function(boxWeight) {
				console.log('defaultCompWeight: boxWeight='+boxWeight);
				var CompName = $("#" + compNameCtrlId).val();
				var width = $("#" + widthCtrlId).val();
				width = width ? parseFloat(width) : 1;
				if (slct == 4 && widthCtrlId == 'js_matt1width') {
					// fudge to double up weight for 2 mattresses
					var matt2width = parseFloat($("#js_matt2width").val());
					if (!isNaN(matt2width)) {
						width += matt2width;
					}
				}
				if (slct == 4 && widthCtrlId == 'js_base1width') {
					// fudge to double up weight for 2 mattresses
					var base2width = parseFloat($("#js_base2width").val());
					if (!isNaN(base2width)) {
						width += base2width;
					}
				}
				var length = $("#" + lengthCtrlId).val();
				length = length ? parseFloat(length) : 1;
				var url = "ajaxGetBoxWeight.asp?pn=" + jsPn + "&compid=" + CompNo + "&compname=" + CompName + "&boxname=" + boxname + "&width=" + width + "&length=" + length + "&ts=" + (new Date()).getTime();
				console.log("defaultCompWeight: url=" + url);
				$.get(url, function(boxAndCompWeight) {
					console.log('defaultCompWeight: boxAndCompWeight='+boxAndCompWeight);
					var totalWeight = parseFloat(boxAndCompWeight);
					console.log('defaultCompWeight: totalWeight='+totalWeight);
					var compWeight = totalWeight - boxWeight;
					console.log('defaultCompWeight: compWeight='+compWeight);
					console.log('Legs: ='+width);
					if (CompNo==7) {
						compWeight= width * 350/1000;
					}
					$("#" + compWeightCtrlId).val(compWeight.toFixed(0));
				});
			});
		}
	}
}

function defaultCrateWeight(CompNo, dropdown, crateWeightCtrlId, crateQtyCtrlId, isPageLoad) {
	
	if (!orderHasComponent(CompNo)) {
		return;
	}
	var slct = $("#wraptype").val();
	if (slct == 4) {
		if (isPageLoad && fieldHasValue(crateWeightCtrlId)) {
			console.log("ispageload=" + isPageLoad + "crateWeightCtrlId=" + crateWeightCtrlId);  
		} else {
			var cratename = $("#" + dropdown).val();
			// crate weights come from shippingbox table, same as boxs weights
			var url = "ajaxGetBoxWeightOnly.asp?boxname=" + cratename + "&ts=" + (new Date()).getTime();
			crateqty = 1;
			if (crateQtyCtrlId) crateqty = $("#"+crateQtyCtrlId).val();
			$.get(url, function(crateWeight) {
				if (!crateqty) crateqty = 1;
				crateWeight = crateWeight*crateqty;
				$("#" + crateWeightCtrlId).val(crateWeight.toFixed(0));
			});
		}
	}
}

function isValidFloat(value) {
	return value !== null && !isNaN(parseFloat(value)) && isFinite(value);
}

function setTotalWeight(packagingWgtCtrl, compWgtCtrl, totalWgtCtrl) {
	var totalWgt = "";
	var packagingWgt = $("#" + packagingWgtCtrl).val();
	var compWgt = $("#" + compWgtCtrl).val();
	if (isValidFloat(packagingWgt) && isValidFloat(compWgt)) {
		totalWgt = (parseFloat(packagingWgt) + parseFloat(compWgt)).toFixed(0);
	}
	$("#" + totalWgtCtrl).val(totalWgt);
}

function defaultBoxSize(CompNo, boxSizeCtrlId1, boxSizeCtrlId2, isPageLoad) {
	if (!orderHasComponent(CompNo)) {
		return;
	}
	if (CompNo == '8') {
		//console.log("here");
	}
	var slct = $("#wraptype").val();
	if (slct == 3) {
			var url = "ajaxGetDefaultBoxSize.asp?pn=" + jsPn + "&compid=" + CompNo + "&ts=" + (new Date()).getTime();
			console.log("url=" + url);
			$.get(url, function(data) {
				var mattressCount = $("#js_mattresscount").val();
				console.log("mattressCount="+mattressCount);
				var vals = data.split(",");
				if (!isPageLoad || !fieldHasValue(boxSizeCtrlId1)) $("#" + boxSizeCtrlId1 + " option[value='" + vals[0] + "']").attr('selected', 'selected');
				
				if (boxSizeCtrlId2 != '' && vals[2] != '') {
					if (!isPageLoad || !fieldHasValue(boxSizeCtrlId2)) $("#" + boxSizeCtrlId2 + " option[value='" + vals[2] + "']").attr('selected', 'selected');
				}
			});
	}
}

function defaultWrapSize(CompNo, boxCtrlId1, boxCtrlId2, boxCtrlId3, boxCtrlId4) {
	var slct = $("#wraptype").val();
	if (slct == 1 || slct == 2) {
		var url = "ajaxGetDefaultBoxWrap.asp?pn=" + jsPn + "&compid=" + CompNo
				+ "&ts=" + (new Date()).getTime();
		$.get(url, function(data) {
			var vals = data.split(",");
			$("#" + boxCtrlId1).val(vals[0]);
			$("#" + boxCtrlId2).val(vals[1]);
			$("#" + boxCtrlId3).val(vals[2]);
			$("#" + boxCtrlId4).val(vals[3]);
		});
	}
}

function checkWrapType() {
	var slct = $("#wraptype").val();
	
	if (slct == 3) {
		$('#mattboxshow').show();
		$('#baseboxshow').show();
		$('#topperboxshow').show();
		$('#hbboxshow').show();
		if (orderHasComponent(6)) {
			$('.valanceboxshow').show();
			$('#valanceboxshow').show();
			} else {
			$('.valanceboxshow').hide();
			$('#valanceboxshow').hide();
		}
		if (!orderHasComponent(1) && !orderHasComponent(3) && !orderHasComponent(5) && !orderHasComponent(6) && !orderHasComponent(7) && !orderHasComponent(8)) {
			$('.accpackedwithshow').hide();
		}
		$('.accboxshow').hide();
		$('#accboxshow').hide();
		$('#valancetxtshow3').show();
		$('#legsboxshow').show();
		$('#mattresstxtinc3show').show();
		$('#basetxtinc3show').show();
		$('#toppertxtinc3show').show();
		$('#hbtxtinc3show').show();
		
		//$('.legspackedwithshow').show();
		//$('.accpackedwithshow').show();
		
	} else {
		//$('.mattspecialcrate2').hide();
		//$('.basespecialcrate2').hide();
		$('#mattboxshow').hide();
		$('#baseboxshow').hide();
		$('#topperboxshow').hide();
		$('#hbboxshow').hide();
		$('.valanceboxshow').hide();
		$('#valanceboxshow').hide();
		$('.accboxshow').hide();
		$('#accboxshow').hide();
		$('#valancetxtshow3').hide();
		$('#legsboxshow').hide();
		$('#mattresstxtinc3show').hide();
		$('#basetxtinc3show').hide();
		$('#toppertxtinc3show').hide();
		$('#hbtxtinc3show').hide();
		//$('.legspackedwithshow').hide();
		//$('.accpackedwithshow').hide();
	}
	
	// show/hide the accessories wrap div and it's contents
	showHideAccWrap();
}

//
// Despite the name, this function adds the weight of the component to the weight field of the component it's
// being packed with, and if it used to be packed with some other component, it deducts the weight from that
// component's weight field.
//
function getCratePackedWith(itemCompNo, packedWithDropdownName,	packedwithcompnofield) {
	// itemCompNo is the comp id we're packing (7 for legs etc)
	// packedWithDropdownName is the name of the dropdown that selects what we're packing itemCompNo with
	// packedwithcompnofield is the field storing the compno of the component the item weight is currently packed with

	var packedWithCompId = $("#" + packedWithDropdownName).val();
	var packedWithWeightFieldName, prevPackedWithWeightFieldName;
	if (packedWithCompId == 1) {
		packedWithWeightFieldName = "matt1_packkg";
	} else if (packedWithCompId == 3) {
		packedWithWeightFieldName = "base1_packkg";
	} else if (packedWithCompId == 5) {
		packedWithWeightFieldName = "topper1_packkg";
	} else if (packedWithCompId == 8) {
		packedWithWeightFieldName = "hb1_packkg";
	} else if (packedWithCompId == 7) {
		packedWithWeightFieldName = "legs1_packkg";
		$('.nolegcrate').hide();
	} else if (packedWithCompId == 6) {
		packedWithWeightFieldName = "valance1_packkg";
		$('.novalancecrate').hide();
	} else if (packedWithCompId == 9) {
		packedWithWeightFieldName = "acc1_packkg";
		$('.noacccrate').hide();
	}
	
	if (itemCompNo == 7 && packedWithCompId == 6) {
		$("#accPackedWith option[value='7']").prop('disabled',true);
		$("#accPackedWith option[value='7']").prop('disabled',true);
	}
	if (itemCompNo == 7 && packedWithCompId == 9) {
		$("#valancePackedWith option[value='7']").prop('disabled',true);
		$("#accPackedWith option[value='7']").prop('disabled',true);
	}
	//mad added 25/6/18
	if (itemCompNo == 7 && packedWithCompId == 5) {
		$("#valancePackedWith option[value='7']").prop('disabled',true);
		$("#accPackedWith option[value='7']").prop('disabled',true);
	}
	if (itemCompNo == 6 && packedWithCompId == 1) {
		$("#accPackedWith option[value='6']").prop('disabled',true);}
	else if (itemCompNo == 6 && packedWithCompId == 3) {
		$("#accPackedWith option[value='6']").prop('disabled',true);}
	else if (itemCompNo == 6 && packedWithCompId == 5) {
		$("#accPackedWith option[value='6']").prop('disabled',true);}		
	else if (itemCompNo == 6 && packedWithCompId == 7) {
		$("#accPackedWith option[value='6']").prop('disabled',true);}
	else if (itemCompNo == 6 && packedWithCompId == 8) {
		$("#accPackedWith option[value='6']").prop('disabled',true);}
	else if (itemCompNo == 6 && packedWithCompId == 9) {
		$("#accPackedWith").val('0');
		$("#accPackedWith option[value='1']").prop('disabled',true);
		$("#accPackedWith option[value='3']").prop('disabled',true);
		$("#accPackedWith option[value='5']").prop('disabled',true);
		$("#accPackedWith option[value='6']").prop('disabled',true);
		$("#accPackedWith option[value='7']").prop('disabled',true);
		$("#accPackedWith option[value='8']").prop('disabled',true);}
	
	
	//finished adding 25/6/18
	
	else if (itemCompNo == 6 && packedWithCompId == 7) {
		$("#accPackedWith option[value='6']").prop('disabled',true);
	}
	else if (itemCompNo == 6 && packedWithCompId == 8) {
		$("#accPackedWith option[value='6']").prop('disabled',true);
	}
	else if (itemCompNo == 6 && packedWithCompId == 9) {
		$("#legsPackedWith option[value='6']").prop('disabled',true);
	}
	
	if (itemCompNo == 9 && packedWithCompId == 7) {
		$("#valancePackedWith option[value='9']").prop('disabled',true);
		
	}
	if (itemCompNo == 9 && packedWithCompId == 8) {
		$("#valancePackedWith option[value='9']").prop('disabled',true);
		
	}
	if (itemCompNo == 9 && packedWithCompId == 6) {
		$("#legsPackedWith option[value='9']").prop('disabled',true);
	}
	
	

	var prevPackedWithCompId = $("#" + packedwithcompnofield).val();
	prevPackedWithWeightFieldName = "";
	if (prevPackedWithCompId == 1) {
		prevPackedWithWeightFieldName = "matt1_packkg";
	} else if (prevPackedWithCompId == 3) {
		prevPackedWithWeightFieldName = "base1_packkg";
	} else if (prevPackedWithCompId == 5) {
		prevPackedWithWeightFieldName = "topper1_packkg";
	} else if (prevPackedWithCompId == 7) {
		prevPackedWithWeightFieldName = "legs1_packkg";
	} else if (prevPackedWithCompId == 6) {
		prevPackedWithWeightFieldName = "valance1_packkg";
	} else if (prevPackedWithCompId == 8) {
		prevPackedWithWeightFieldName = "hb1_packkg";
	} else if (prevPackedWithCompId == 9) {
		prevPackedWithWeightFieldName = "acc1_packkg";
	}
	
	var itemWeight = getComponentWeight(itemCompNo);
	// add the item weight to the weight of the component it's packed with
	var currentWeight = $("#" + packedWithWeightFieldName).val();
	if (currentWeight == '') currentWeight = 0;
	var newWeight = parseInt(currentWeight) + itemWeight;
	// console.log("getCratePackedWith: currentWeight = " + currentWeight);
	// console.log("getCratePackedWith: newWeight = " + newWeight);
	$("#" + packedWithWeightFieldName).val(newWeight);

	// deduct the item weight from the weight of the component used to be packed with (if any)
	if (prevPackedWithWeightFieldName != "") {
		currentWeight = $("#" + prevPackedWithWeightFieldName).val();
		newWeight = parseInt(currentWeight) - itemWeight;
		$("#" + prevPackedWithWeightFieldName).val(newWeight);
	} else {
		// console.log("no prev packed with component to deduct weight from");
	}
	
	$("#" + packedwithcompnofield).val(packedWithCompId);

}

function getCratePackedWithInit(itemCompNo, packedWithDropdownName,	packedwithcompnofield) {
	// itemCompNo is the comp id we're packing (7 for legs etc)
	// packedWithDropdownName is the name of the dropdown that selects what we're packing itemCompNo with
	var packedWithCompId = $("#" + packedWithDropdownName).val();
	if (itemCompNo == 7 && packedWithCompId == 6) {
		$("#accPackedWith option[value='7']").prop('disabled',true);
		$("#accPackedWith option[value='7']").prop('disabled',true);
	}
	if (itemCompNo == 7 && packedWithCompId == 9) {
		$("#valancePackedWith option[value='7']").prop('disabled',true);
		$("#accPackedWith option[value='7']").prop('disabled',true);
	}
	//mad added 25/6/18
	if (itemCompNo == 7 && packedWithCompId == 5) {
		$("#valancePackedWith option[value='7']").prop('disabled',true);
		$("#accPackedWith option[value='7']").prop('disabled',true);
	}
	if (itemCompNo == 6 && packedWithCompId == 1) {
		$("#accPackedWith option[value='6']").prop('disabled',true);}
	else if (itemCompNo == 6 && packedWithCompId == 3) {
		$("#accPackedWith option[value='6']").prop('disabled',true);}
	else if (itemCompNo == 6 && packedWithCompId == 5) {
		$("#accPackedWith option[value='6']").prop('disabled',true);}		
	else if (itemCompNo == 6 && packedWithCompId == 7) {
		$("#accPackedWith option[value='6']").prop('disabled',true);}
	else if (itemCompNo == 6 && packedWithCompId == 9) {
		$("#accPackedWith").val('0');
		$("#accPackedWith option[value='1']").prop('disabled',true);
		$("#accPackedWith option[value='3']").prop('disabled',true);
		$("#accPackedWith option[value='5']").prop('disabled',true);
		$("#accPackedWith option[value='6']").prop('disabled',true);
		$("#accPackedWith option[value='7']").prop('disabled',true);}
	//finished adding 25/6/18
	else if (itemCompNo == 6 && packedWithCompId == 7) {
		$("#accPackedWith option[value='6']").prop('disabled',true);
	}
	else if (itemCompNo == 6 && packedWithCompId == 9) {
		$("#legsPackedWith option[value='6']").prop('disabled',true);
	}
	if (itemCompNo == 9 && packedWithCompId == 7) {
		$("#valancePackedWith option[value='9']").prop('disabled',true);
		
	}
	if (itemCompNo == 9 && packedWithCompId == 6) {
		$("#legsPackedWith option[value='9']").prop('disabled',true);
	}
}



function getBoxPackedWith(itemCompNo, packedWithDropdownName, accID) {
	if (itemCompNo==9 && empty(accID)) {
		// nothing to do
		return;
	}
	// itemCompNo is the comp id we're packing (7 for legs etc)
	// packedWithDropdownName is the name of the dropdown that selects what we're packing itemCompNo with
	var packedWithCompId = $("#" + packedWithDropdownName).val();
	console.log("getBoxPackedWith: packedWithCompId=" + packedWithCompId);
	console.log("getBoxPackedWith: starts with = " + packedWithCompId.startsWith("9-"));
	var packedWithAccId = 0;
	if (packedWithCompId.startsWith("9-")) {
		packedWithAccId = packedWithCompId.substr(2);
		packedWithCompId = 9;
		console.log("getBoxPackedWith: packedWithAccId=" + packedWithAccId);
	}

	
	var packedWithWeightFieldName, prevPackedWithWeightFieldName;
	if (packedWithCompId == 1) {
		packedWithWeightFieldName = "matt1kg";
	} else if (packedWithCompId == 3) {
		packedWithWeightFieldName = "base1kg";
	} else if (packedWithCompId == 5) {
		packedWithWeightFieldName = "topper1kg";
	} else if (packedWithCompId == 7) {
		packedWithWeightFieldName = "legs1kg";
	} else if (packedWithCompId == 8) {
		packedWithWeightFieldName = "hb1kg";
	} else if (packedWithCompId == 9) {
		packedWithWeightFieldName = "acc_weight" + packedWithAccId;
	}

	var prevPackedWithCompId = $("#" + packedWithDropdownName).attr("data-oldval");
	var prevAccId = 0;
	if (prevPackedWithCompId.startsWith("9-")) {
		prevAccId = prevPackedWithCompId.substr(2);
		prevPackedWithCompId = 9;
		console.log("getBoxPackedWith: prevAccId=" + prevAccId);
	}

	prevPackedWithWeightFieldName = "";
	if (prevPackedWithCompId == 1) {
		prevPackedWithWeightFieldName = "matt1kg";
	} else if (prevPackedWithCompId == 3) {
		prevPackedWithWeightFieldName = "base1kg";
	} else if (prevPackedWithCompId == 5) {
		prevPackedWithWeightFieldName = "topper1kg";
	} else if (prevPackedWithCompId == 7) {
		prevPackedWithWeightFieldName = "legs1kg";
	} else if (prevPackedWithCompId == 8) {
		prevPackedWithWeightFieldName = "hb1kg";
	} else if (prevPackedWithCompId == 9) {
		prevPackedWithWeightFieldName = "acc_weight" + prevAccId;
	}
	var itemWeight = 0.0;
	if (itemCompNo==9) {
		itemWeight = parseInt($("#acc_weight" + accID).val());
	} else {
		itemWeight = getComponentWeight(itemCompNo);
	}

	// add the item weight to the weight of the component it's packed with
	var currentWeight = $("#" + packedWithWeightFieldName).val();
	if (currentWeight == '' || typeof currentWeight === "undefined") currentWeight = 0;
	var newWeight = parseInt(currentWeight) + itemWeight;
	$("#" + packedWithWeightFieldName).val(newWeight);

	// deduct the item weight from the weight of the component used to be packed with (if any)
	if (prevPackedWithWeightFieldName != "") {
		currentWeight = $("#" + prevPackedWithWeightFieldName).val();
		newWeight = parseInt(currentWeight)	- itemWeight;
		$("#" + prevPackedWithWeightFieldName).val(newWeight);
	} else {
		// console.log("no prev packed with component to deduct weight from");
	}
	
	var oldPackedWith = packedWithCompId;
	if (packedWithCompId == 9) {
		oldPackedWith = oldPackedWith + "-" + packedWithAccId;
	}
	$("#" + packedWithDropdownName).attr("data-oldval", oldPackedWith);
}


function disablefield(fieldname, boxCtrlId1, boxCtrlId2, boxCtrlId3) {
	var slct = $("#" + fieldname).val();

	//console.log("fieldname=" + fieldname);
	//console.log("slct=" + slct);
	if (slct == "Special Size Crate") {
		$("#" + boxCtrlId1 + "").prop('readonly', false);
		$("#" + boxCtrlId2 + "").prop('readonly', false);
		$("#" + boxCtrlId3 + "").prop('readonly', false);
	} else {
		$("#" + boxCtrlId1 + "").prop('readonly', true);
		$("#" + boxCtrlId2 + "").prop('readonly', true);
		$("#" + boxCtrlId3 + "").prop('readonly', true);
	}
}

function toggle_visibility(id) {
	var e = document.getElementById(id);
	if (e.style.display == 'block')
		e.style.display = 'none';
	else
		e.style.display = 'block';
}

function tickingSelected() {
	hideAllTickingSwatches();
	var selection = $("#tickingoptions").val();
	if (selection == "White Trellis") {
		$('#tick1').show();
		$('#tick1t').show();
	} else if (selection == "Grey Trellis") {
		$('#tick2').show();
		$('#tick2t').show();
	} else if (selection == "Silver Trellis") {
		$('#tick3').show();
		$('#tick3t').show();
	} else if (selection == "Oatmeal Trellis") {
		$('#tick4').show();
		$('#tick4t').show();
	}
}

function headboardstyle() {
	hideAllHeadboardSwatches();
	var selection = $("#headboardstyle").val();
	if (selection == "C1") {
		$('#tick5').show();
	} else if (selection == "C2") {
		$('#tick6').show();
	} else if (selection == "C4") {
		$('#tick7').show();
	} else if (selection == "C5") {
		$('#tick8').show();
	} else if (selection == "C6") {
		$('#tick9').show();
	} else if (selection == "M31") {
		$('#tick10').show();
	} else if (selection == "M32") {
		$('#tick11').show();
	} else if (selection == "H1 Holly") {
		$('#tick12').show();
	} else if (selection == "F100") {
		$('#tick13').show();
	} else if (selection == "MF31") {
		$('#tick14').show();
	} else if (selection == "MF32") {
		$('#tick15').show();
	} else if (selection == "Animal") {
		$('#tick16').show();
	}
}

function setGiftLetter() {
	if ($('#giftpack').is(':checked')) {
		$('#delletter').show();
	} else {
		$('#delletter').hide();
	}
}

function checkWrapShow() {
	var slct = $("#wraptype").val();
	if (slct == 1 || slct == 2) {
		$('#wrapshow').show();
	} else {
		$('#wrapshow').hide();
	}
	if (slct == 2 || slct == 3) {
		$('.accexpboxonly').show();
		$('#accboxshow').hide();
	} else {
		$('.accexpboxonly').hide();
	}
}

function CrateOrPack(checkboxVal, compVal, hidecrate, hidecrate2, width, height, depth, kg, compID, PackedWith, PackedWithCompNoField, cratetype, crateqty, specialcrate2) {
	//Packed with info
	if($("#" + checkboxVal).prop('checked') == true){
		$('.' + compVal).show();
		//$('.' + hidecrate).hide();
		$('.' + hidecrate2).hide();
		//$('.' + checkboxVal).hide();
		$('#' + width).val(0);
		$('#' + height).val(0);
		$('#' + depth).val(0);
		$('#' + kg).val(0);
		$('#' + specialcrate2).val("");
		getCratePackedWith(compID,PackedWith,PackedWithCompNoField);
		disablefield(cratetype,width,height,depth);
	} else {
		$('.' + compVal).hide();
		$('.' + hidecrate).show();
		$("#" + PackedWith + " option[value='']").prop('selected', 'selected');
		defaultCrateSize(compID,width,height,depth,cratetype,crateqty,false);
		getCratePackedWith(compID,PackedWith,PackedWithCompNoField);
		disablefield(cratetype,width,height,depth);
	}
}

function checkCrateShow() {
	var slct = $("#wraptype").val();
	if (slct == 4) {
		checkSpecialCrateQty('1','mattressCrateType','matt_crateqty','mattspecialcrate2');
		checkSpecialCrateQty('3','baseCrateType','base_crateqty','basespecialcrate2');
		checkSpecialCrateQty('5','topperCrateType','topper_crateqty','topperspecialcrate2');
		checkSpecialCrateQty('6','valanceCrateType','valance_crateqty','valancespecialcrate2');
		checkSpecialCrateQty('7','legsCrateType','legs_crateqty','legsspecialcrate2');
		checkSpecialCrateQty('8','hbCrateType','hb_crateqty','hbspecialcrate2');
		checkSpecialCrateQty('9','accCrateType','acc_crateqty','accspecialcrate2');
		$('#crateshow').show();
		$('#basecrateshow').show();
		if ($("#base1_packwidth").val() == '') {
			defaultCrateSize('3', 'base1_packwidth', 'base1_packheight',
					'base1_packdepth', 'baseCrateType',
					'base_crateqty', false);
		}
		$("#headboardstyle").val();
		$('#toppercrateshow').show();
		$('#toppertxtshow').show();
		$('#hbcrateshow').show();
		$('.legscrateshow').show();
		$('#legstxtshow').show();
		$('.valancecrateshow').show();
		$('#accCrateShow').show();
		$('#valancetxtshow4').show();
		$('#mattresstxtincshow').show();
		$('#basetxtincshow').show();
		$('#toppertxtincshow').show();
		$('#hbtxtincshow').show();
		$('.legspackedwithshow').show();
		$('.valancepackedwithshow').show();
		$('.accpackedwithshow').show();
		if (!orderHasComponent(1) && !orderHasComponent(3) && !orderHasComponent(5) && !orderHasComponent(6) && !orderHasComponent(7) && !orderHasComponent(8)) {
			$('.accpackedwithshow').hide();
			$('.noacccrate').hide();
		}
		if (!orderHasComponent(1) && !orderHasComponent(3) && !orderHasComponent(5) && !orderHasComponent(6) && !orderHasComponent(7) && !orderHasComponent(8) && orderHasComponent(9)) {
			$('.hideacccrate').show();
		}
	} else {
		$('#crateshow').hide();
		$('#basecrateshow').hide();
		$('#toppercrateshow').hide();
		$('#toppertxtshow').hide();
		$('#hbcrateshow').hide();
		$('.legscrateshow').hide();
		$('#legstxtshow').hide();
		$('.valancecrateshow').hide();
		$('#accCrateShow').hide();
		$('#valancetxtshow4').hide();
		$('#mattresstxtincshow').hide();
		$('#basetxtincshow').hide();
		$('#toppertxtincshow').hide();
		$('#hbtxtincshow').hide();
		$('.legspackedwithshow').hide();
		$('.valancepackedwithshow').hide();
		$('.accpackedwithshow').hide();
	}
}



function fieldHasValue(fieldId) {
	if (fieldId == "") return false;
	if (!$("#" + fieldId).length) return false;
	return $("#" + fieldId).val() != "";
}

function setDeliveredOn() {
	var deldate = $("#deliveredon").val();
	if ($('#confirmeddelivery').is(':checked') && deldate == "") {
		alert("Please enter confirmed date");
		$('#confirmeddelivery').removeAttr('checked');
	}
}

function manhattanTrimOptions() {
	var slct = $("#headboardstyle").val();
	if (slct && slct.substring(0, 9) == 'Manhattan') {
		$('#manhattantrimdiv1').show();
		$('#manhattantrimdiv2').show();
	} else {
		$("#manhattantrim option[value='--']").attr('selected', 'selected');
		$('#manhattantrimdiv1').hide();
		$('#manhattantrimdiv2').hide();
	}
}

function checkAllMattDatesCompleted() {
	var finishDate = $("#mattfinished").val();
	if (finishDate != "") {
		if ($("#mattcut").val() == "") {
			$('#mattcut').val(finishDate);
		}

		if ($("#mattmachined").val() == "") {
			$('#mattmachined').val(finishDate);
		}

		if ($("#springunitdate").val() == "") {
			$('#springunitdate').val(finishDate);
		}
	}
}

function checkAllBaseDatesCompleted() {
	var finishDate = $("#basefinished").val();
	if (finishDate != "") {
		if ($("#boxcut").val() == "") {
			$('#boxcut').val(finishDate);
		}

		if ($("#boxmachined").val() == "") {
			$('#boxmachined').val(finishDate);
		}

		if ($("#boxframe").val() == "") {
			$('#boxframe').val(finishDate);
		}
		if ($("#baseprepped").val() == "") {
			$('#baseprepped').val(finishDate);
		}
	}
}

function checkAllTopperDatesCompleted() {
	var finishDate = $("#topperfinished").val();
	if (finishDate != "") {
		if ($("#toppercut").val() == "") {
			$('#toppercut').val(finishDate);
		}

		if ($("#toppermachined").val() == "") {
			$('#toppermachined').val(finishDate);
		}

	}
}

function checkAllHeadboardDatesCompleted() {
	var finishDate = $("#headboardfinished").val();
	if (finishDate != "") {
		if ($("#headboardframe").val() == "") {
			$('#headboardframe').val(finishDate);
		}

		if ($("#headboardprepped").val() == "") {
			$('#headboardprepped').val(finishDate);
		}

	}
}

function checkAllLegsDatesCompleted() {
	var finishDate = $("#legsfinished").val();
	if (finishDate != "") {
		if ($("#legsprepped").val() == "") {
			$('#legsprepped').val(finishDate);
		}

	}
}

function checkFinishedDateCompleted(origmattstatus) {
	var finDate = $("#mattfinished").val();
	var mattstatus = $("#mattressqc").val();
	if ((mattstatus == "50" || mattstatus == "60" || mattstatus == "70")
			&& finDate == "") {
		alert("Please enter Mattress Finished Date and then Order Status can be changed");
		$("#mattressqc option[value='" + origmattstatus + "']").attr(
				'selected', 'selected');
		$('#mattfinished').focus();
	}

}

function checkBaseFinishedDateCompleted(origbasestatus) {
	var finDate = $("#basefinished").val();
	var basestatus = $("#baseqc").val();
	if ((basestatus == "50" || basestatus == "60" || basestatus == "70")
			&& finDate == "") {
		alert("Please enter Base Finished Date and then Order Status can be changed");
		$("#baseqc option[value='" + origbasestatus + "']").attr('selected',
				'selected');
		$('#basefinished').focus();
	}

}

function checkTopperFinishedDateCompleted(origtopperstatus) {
	var finDate = $("#topperfinished").val();
	var topperstatus = $("#topperstatus").val();
	if ((topperstatus == "50" || topperstatus == "60" || topperstatus == "70")
			&& finDate == "") {
		alert("Please enter Topper Finished Date and then Order Status can be changed");
		$("#topperstatus option[value='" + origtopperstatus + "']").attr(
				'selected', 'selected');
		$('#topperfinished').focus();
	}

}

function checkHBFinishedDateCompleted(orighbstatus) {
	var finDate = $("#headboardfinished").val();
	var headboardstatus = $("#headboardstatus").val();
	if ((headboardstatus == "50" || headboardstatus == "60" || headboardstatus == "70")
			&& finDate == "") {
		alert("Please enter Headboard Finished Date and then Order Status can be changed");
		$("#headboardstatus option[value='" + orighbstatus + "']").attr(
				'selected', 'selected');
		$('#headboardfinished').focus();
	}

}

function checkLegsFinishedDateCompleted(origlegsstatus) {
	var finDate = $("#legsfinished").val();
	var legsstatus = $("#legsstatus").val();
	if ((legsstatus == "50" || legsstatus == "60" || legsstatus == "70")
			&& finDate == "") {
		alert("Please enter Legs Finished Date and then Order Status can be changed");
		$("#legsstatus option[value='" + origlegsstatus + "']").attr(
				'selected', 'selected');
		$('#legsfinished').focus();
	}

}

function checkValanceFinishedDateCompleted(origvalancestatus) {
	var finDate = $("#valancefinished").val();
	var valancestatus = $("#valancestatus").val();
	if ((valancestatus == "50" || valancestatus == "60" || valancestatus == "70")
			&& finDate == "") {
		alert("Please enter Valance Finished Date and then Order Status can be changed");
		$("#valancestatus option[value='" + origvalancestatus + "']").attr(
				'selected', 'selected');
		$('#valancefinished').focus();
	}

}

function checkProdDateCompleted() {
	var prodDate = $("#mattbcwexpected").val();
	var mattstatus = $("#mattressqc").val();
	if (mattstatus == "20" && prodDate == "") {
		alert("please enter Mattress Production Date");
		$('#mattbcwexpected').focus();
	}

}

function checkBaseProdDateCompleted() {
	var prodDate = $("#basebcwexpected").val();
	var basestatus = $("#baseqc").val();
	if (basestatus == "20" && prodDate == "") {
		alert("please enter Base Production Date");
		$('#basebcwexpected').focus();
	}

}

function checkHeadboardProdDateCompleted() {
	var prodDate = $("#headboardbcwexpected").val();
	var hbstatus = $("#headboardstatus").val();
	if (hbstatus == "20" && prodDate == "") {
		alert("please enter Headboard Production Date");
		$('#headboardbcwexpected').focus();
	}

}

function checkTopperProdDateCompleted() {
	var prodDate = $("#topperbcwexpected").val();
	var topperstatus = $("#topperstatus").val();
	if (topperstatus == "20" && prodDate == "") {
		alert("please enter Topper Production Date");
		$('#topperbcwexpected').focus();
	}

}

function checkValanceProdDateCompleted() {
	var prodDate = $("#valancebcwexpected").val();
	var valancestatus = $("#valancestatus").val();
	if (valancestatus == "20" && prodDate == "") {
		alert("please enter Valance Production Date");
		$('#valancebcwexpected').focus();
	}

}

function checkLegsProdDateCompleted() {
	var prodDate = $("#legsbcwexpected").val();
	var legsstatus = $("#legsstatus").val();
	if (legsstatus == "20" && prodDate == "") {
		alert("please enter Legs Production Date");
		$('#legsbcwexpected').focus();
	}

}

function setHeadboardHeightOptions() {
	var hbStyle = $("#headboardstyle").val();
	var url = "get-field-options-ajax.asp?fieldname=headboardheight&defaultsrcfield=headboardstyle&defaultsrcopt="
			+ escape(hbStyle) + "&ts=" + (new Date()).getTime();
	$('#headboardheight').load(url);
}

function setLegStyleOptions() {
	var hbStyle = $("#headboardstyle").val();
	var url = "get-field-options-ajax.asp?fieldname=legstyle&defaultsrcfield=headboardstyle&defaultsrcopt="
			+ escape(hbStyle) + "&ts=" + (new Date()).getTime();
	$('#legstyle').load(url, function() {
		setLegFinishes();
	});
}

function updateMattStatus() {
	var madeAt = $("#mattressmadeat").val();
	var aBay = $("#matbay").val();
	if (madeAt == '1' && aBay != '') {
		$("#mattressqc option[value='50']").attr('selected', 'selected');
	}
}
function updateBaseStatus() {
	var madeAt = $("#basemadeat").val();
	var aBay = $("#basebay").val();
	if (madeAt == '1' && aBay != '') {
		$("#baseqc option[value='50']").attr('selected', 'selected');
	}
}
function updateTopperStatus() {
	var madeAt = $("#toppermadeat").val();
	var aBay = $("#topperbay").val();
	if (madeAt == '1' && aBay != '') {
		$("#topperstatus option[value='50']").attr('selected', 'selected');
	}
}
function updateHeadboardStatus() {
	var madeAt = $("#headboardmadeat").val();
	var aBay = $("headboardbay").val();
	if (madeAt == '1' && aBay != '') {
		$("#headboardstatus option[value='50']").attr('selected', 'selected');
	}
}
function updateLegsStatus() {
	var madeAt = $("#legsmadeat").val();
	var aBay = $("#legsbay").val();
	if (madeAt == '1' && aBay != '') {
		$("#legsstatus option[value='50']").attr('selected', 'selected');
	}
}
function updateValanceStatus() {
	var madeAt = $("#valancemadeat").val();
	var aBay = $("#valancebay").val();
	if (madeAt == '1' && aBay != '') {
		$("#valancestatus option[value='50']").attr('selected', 'selected');
	}
}

function checkMattMadeAt() {
	var madeAt = $("#mattressmadeat").val();
	if (madeAt == '1') {
		$("#matbay option[value='41']").attr('selected', 'selected');
		$("#mattressqc option[value='40']").attr('selected', 'selected');
	}
}

function checkBaseMadeAt() {
	var madeAt = $("#basemadeat").val();
	if (madeAt == '1') {
		$("#basebay option[value='41']").attr('selected', 'selected');
		$("#baseqc option[value='40']").attr('selected', 'selected');
	}
}

function checkTopperMadeAt() {
	var madeAt = $("#toppermadeat").val();
	if (madeAt == '1') {
		$("#topperbay option[value='41']").attr('selected', 'selected');
		$("#topperstatus option[value='40']").attr('selected', 'selected');
	}
}

function checkHeadboardMadeAt() {
	var madeAt = $("#headboardmadeat").val();
	if (madeAt == '1') {
		$("#headboardbay option[value='41']").attr('selected', 'selected');
		$("#headboardstatus option[value='40']").attr('selected', 'selected');
	}
}

function checkValanceMadeAt() {
	var madeAt = $("#valancemadeat").val();
	if (madeAt == '1') {
		$("#valancebay option[value='41']").attr('selected', 'selected');
		$("#valancestatus option[value='40']").attr('selected', 'selected');
	}
}

function checkLegsMadeAt() {
	var madeAt = $("#legsmadeat").val();
	if (madeAt == '1') {
		$("#legsbay option[value='41']").attr('selected', 'selected');
		$("#legsstatus option[value='40']").attr('selected', 'selected');
	}
}

function checkMattFinishedStatus() {
	var madeAt = $("#mattressmadeat").val();
	// $("#matbay option[value='40']").attr('selected', 'selected');
	$("#mattressqc option[value='30']").attr('selected', 'selected');
}

function checkBaseFinishedStatus() {
	var madeAt = $("#basemadeat").val();
	// $("#basebay option[value='40']").attr('selected', 'selected');
	$("#baseqc option[value='30']").attr('selected', 'selected');
}

function checkTopperFinishedStatus() {
	var madeAt = $("#toppermadeat").val();
	// $("#topperbay option[value='40']").attr('selected', 'selected');
	$("#topperstatus option[value='30']").attr('selected', 'selected');
}

function checkHeadboardFinishedStatus() {
	var madeAt = $("#headboardmadeat").val();
	// $("#headboardbay option[value='40']").attr('selected', 'selected');
	$("#headboardstatus option[value='30']").attr('selected', 'selected');
}

function checkValanceFinishedStatus() {
	var madeAt = $("#valancemadeat").val();
	// $("#valancebay option[value='40']").attr('selected', 'selected');
	$("#valancestatus option[value='30']").attr('selected', 'selected');
}

function checkLegsFinishedStatus() {
	var madeAt = $("#legsmadeat").val();
	// $("#legsbay option[value='39']").attr('selected', 'selected');
	$("#legsstatus option[value='30']").attr('selected', 'selected');
}

function hideAllTickingSwatches() {
	$('#tick1').hide();
	$('#tick2').hide();
	$('#tick3').hide();
	$('#tick4').hide();
	$('#tick1t').hide();
	$('#tick2t').hide();
	$('#tick3t').hide();
	$('#tick4t').hide();
}
function hideAllHeadboardSwatches() {
	$('#tick5').hide();
	$('#tick6').hide();
	$('#tick7').hide();
	$('#tick8').hide();
	$('#tick9').hide();
	$('#tick10').hide();
	$('#tick11').hide();
	$('#tick12').hide();
	$('#tick13').hide();
	$('#tick14').hide();
	$('#tick15').hide();
	$('#tick16').hide();
}

function mattressChanged() {
	var value = $("input[name=mattressrequired]:checked").val();
	if (value == 'y') {
		$('#mattress_div').show("slow");
	} else {
		$('#mattress_div').hide("slow");
	}
}

function topperChanged() {
	var value = $("input[name=topperrequired]:checked").val();
	if (value == 'y') {
		$('#topper_div').show("slow");
	} else {
		$('#topper_div').hide("slow");
	}
}

function baseChanged() {
	var value = $("input[name=baserequired]:checked").val();
	if (value == 'y') {
		$('#base_div').show("slow");
	} else {
		$('#base_div').hide("slow");
	}
}

function headboardChanged() {
	var value = $("input[name=headboardrequired]:checked").val();
	if (value == 'y') {
		$('#headboard_div').show("slow");
	} else {
		$('#headboard_div').hide("slow");
	}
}

function legsChanged() {
	var value = $("input[name=legsrequired]:checked").val();
	if (value == 'y') {
		$('#legs_div').show("slow");
	} else {
		$('#legs_div').hide("slow");
	}
}

function valanceChanged() {
	var value = $("input[name=valancerequired]:checked").val();
	if (value == 'y') {
		$('#valance_div').show("slow");
	} else {
		$('#valance_div').hide("slow");
	}
}

function accessoriesChanged() {
	var value = $("input[name=accessoriesrequired]:checked").val();
	if (value == 'y') {
		$('#accessories_div').show("slow");
	} else {
		$('#accessories_div').hide("slow");
	}
}

function deliveryChanged() {
	var value = $("input[name=deliverycharge]:checked").val();
	if (value == 'y') {
		$('#delivery_div').show("slow");
	} else {
		$('#delivery_div').hide("slow");
		$('#deliveryprice').val("0.00"); // remove delivery price if delivery
		// deselected
	}
}

function setDefaultDeliveryCharge() {
	var country = $('#countryd').val();
	if (country == "")
		country = $('#country').val();
	country = encodeURIComponent(country);
	var postcode = $('#postcoded').val();
	if (postcode == "")
		postcode = $('#postcode').val();
	postcode = encodeURIComponent(postcode);
	var url = "ajaxGetShippingCost.asp?country=" + country + "&postcode="
			+ postcode + "&ts=" + (new Date()).getTime();
	$.get(url, function(data) {
		$('#deliveryprice').val(data);
		$('#deliveryprice').blur();
	});
}

function setLegFinishes() {

	var slct = $("#legstyle").val();
	var finishOptions = [];
	var heightOptions = [];
	var defaultFinishSelection = "";
	var defaultHeightSelection = "";

	if (slct == "TBC") {
		finishOptions.push("TBC");
		heightOptions.push("TBC");
	} else if (slct == "Wooden Tapered") {
		finishOptions.push("TBC");
		finishOptions.push("Natural Maple");
		finishOptions.push("Oak");
		finishOptions.push("Walnut");
		finishOptions.push("Ebony");
		finishOptions.push("Rosewood");
		finishOptions.push("Special (as instructions)");
		heightOptions.push("TBC");
		heightOptions.push("9.5cm/ Low");
		heightOptions.push("13.5cm/ Standard");
		heightOptions.push("17cm/ Tall");
		heightOptions.push("21cm/ Very Tall");
	} else if (slct == "Holly") {
		finishOptions.push("TBC");
		finishOptions.push("Natural Maple");
		finishOptions.push("Oak");
		finishOptions.push("Ebony");
		finishOptions.push("Rosewood");
		finishOptions.push("Special (as instructions)");
		defaultFinishSelection = "Rosewood";
		heightOptions.push("15cm");
		defaultHeightSelection = "15cm";
	} else if (slct == "Metal") {
		finishOptions.push("Polished");
		heightOptions.push("15cm");
		heightOptions.push("Special (as instructions)");
		defaultHeightSelection = "15cm";
	} else if (slct == "Manhattan") {
		finishOptions.push("TBC");
		finishOptions.push("Natural Maple");
		finishOptions.push("Oak");
		finishOptions.push("Ebony");
		finishOptions.push("Special (as instructions)");
		defaultFinishSelection = "Ebony";
		heightOptions.push("13.5cm");
		heightOptions.push("Special (as instructions)");
		defaultHeightSelection = "13.5cm";
	} else if (slct == "Ball & Claw") {
		finishOptions.push("TBC");
		finishOptions.push("Silver Gilded");
		finishOptions.push("Gold Gilded");
		finishOptions.push("Special (as instructions)");
		heightOptions.push("15cm");
		heightOptions.push("Special (as instructions)");
	} else if (slct == "Castors") {
		finishOptions.push("Brown");
		heightOptions.push("TBC");
		heightOptions.push("9.5cm/ Low");
		heightOptions.push("13.5cm/ Standard");
		heightOptions.push("17cm/ Tall");
		heightOptions.push("21cm/ Very Tall");
	} else if (slct == "Special (as instructions)") {
		finishOptions.push("Special (as instructions)");
		heightOptions.push("Special (as instructions)");
	}

	$('#legfinish').find('option').remove();

	$.each(finishOptions, function(val, text) {
		$('#legfinish').append($('<option></option>').val(text).html(text));
	});

	if (defaultFinishSelection != "") {
		$("#legfinish option[value='" + defaultFinishSelection + "']").attr(
				'selected', 'selected');
	}

	$('#legheight').find('option').remove();

	$.each(heightOptions, function(val, text) {
		$('#legheight').append($('<option></option>').val(text).html(text));
	});

	if (defaultHeightSelection != "") {
		$("#legheight option[value='" + defaultHeightSelection + "']").attr(
				'selected', 'selected');
	}
}

function clearvalancefabricrecdate() {
	$('#valancefabricrecdate').val('');
}
function clearproductiondate() {
	$('#productiondate').val('');
}
function clearlondonproductiondate() {
	$('#londonproductiondate').val('');
}
function clearcardiffproductiondate() {
	$('#cardiffproductiondate').val('');
}
function cleardeliveredon() {
	$('#deliveredon').val('');
}
function clearordernote_followupdate() {
	$('#ordernote_followupdate').val('');
}
function clearmattcut() {
	$('#mattcut').val('');
}
function clearmattmachined() {
	$('#mattmachined').val('');
}
function clearspringunitdate() {
	$('#springunitdate').val('');
}
function clearmattfinished() {
	$('#mattfinished').val('');
}
function clearmattbcwexpected() {
	$('#mattbcwexpected').val('');
	defaultAreaProductionDates();
}
function clearmattbcwwarehouse() {
	$('#mattbcwwarehouse').val('');
}
function clearmattdeldate() {
	$('#mattdeldate').val('');
}
function clearbasepodate() {
	$('#basepodate').val('');
}
function clearbasefabricexpecteddate() {
	$('#basefabricexpecteddate').val('');
}
function clearbasefabricrecdate() {
	$('#basefabricrecdate').val('');
}
function clearbasecuttingsent() {
	$('#basecuttingsent').val('');
}
function clearbaseconfirmeddate() {
	$('#baseconfirmeddate').val('');
}
function clearbasetobcwdate() {
	$('#basetobcwdate').val('');
}
function clearboxcut() {
	$('#boxcut').val('');
}
function clearbasefrTreatingSent() {
	$('#basefrTreatingSent').val('');
}
function clearbasefrTreatingReceived() {
	$('#basefrTreatingReceived').val('');
}
function clearvalancefrTreatingSent() {
	$('#valancefrTreatingSent').val('');
}
function clearvalancefrTreatingReceived() {
	$('#valancefrTreatingReceived').val('');
}
function clearboxmachined() {
	$('#boxmachined').val('');
}
function clearboxframe() {
	$('#boxframe').val('');
}
function clearbaseprepped() {
	$('#baseprepped').val('');
}
function clearbasefinished() {
	$('#basefinished').val('');
}
function clearbasebcwexpected() {
	$('#basebcwexpected').val('');
	defaultAreaProductionDates();
}
function clearbasebcwwarehouse() {
	$('#basebcwwarehouse').val('');
}
function clearbasedeldate() {
	$('#basedeldate').val('');
}
function cleartoppercut() {
	$('#toppercut').val('');
}
function cleartoppermachined() {
	$('#toppermachined').val('');
}
function cleartopperfinished() {
	$('#topperfinished').val('');
}
function cleartopperbcwexpected() {
	$('#topperbcwexpected').val('');
	defaultAreaProductionDates();
}
function cleartopperbcwwarehouse() {
	$('#topperbcwwarehouse').val('');
}
function cleartopperdeldate() {
	$('#topperdeldate').val('');
}
function clearheadboardpodate() {
	$('#headboardpodate').val('');
}
function clearheadboardfabricexpecteddate() {
	$('#headboardfabricexpecteddate').val('');
}
function clearheadboardfabricrecdate() {
	$('#headboardfabricrecdate').val('');
}
function clearheadboardcuttingsent() {
	$('#headboardcuttingsent').val('');
}
function clearfrTreatingSent() {
	$('#frTreatingSent').val('');
}
function clearfrTreatingReceived() {
	$('#frTreatingReceived').val('');
}
function clearheadboardconfirmeddate() {
	$('#headboardconfirmeddate').val('');
}
function clearheadboardtobcwdate() {
	$('#headboardtobcwdate').val('');
}
function clearheadboardframe() {
	$('#headboardframe').val('');
}
function clearheadboardprepped() {
	$('#headboardprepped').val('');
}
function clearheadboardfinished() {
	$('#headboardfinished').val('');
}
function clearheadboardbcwexpected() {
	$('#headboardbcwexpected').val('');
	defaultAreaProductionDates();
}
function clearheadboardbcwwarehouse() {
	$('#headboardbcwwarehouse').val('');
}
function clearheadboarddeldate() {
	$('#headboarddeldate').val('');
}
function clearlegsfinished() {
	$('#legsfinished').val('');
}
function clearvalancefinished() {
	$('#valancefinished').val('');
}
function clearlegsprepped() {
	$('#legsprepped').val('');
}
function clearlegsbcwexpected() {
	$('#legsbcwexpected').val('');
	defaultAreaProductionDates();
}
function clearlegsbcwwarehouse() {
	$('#legsbcwwarehouse').val('');
}
function clearlegsdeldate() {
	$('#legsdeldate').val('');
}
function clearvalancepodate() {
	$('#valancepodate').val('');
}
function clearvalancefabricexpecteddate() {
	$('#valancefabricexpecteddate').val('');
}
function clearvalancecuttingsent() {
	$('#valancecuttingsent').val('');
}
function clearvalanceconfirmeddate() {
	$('#valanceconfirmeddate').val('');
}
function clearsendtosddate() {
	$('#sendtosddate').val('');
}
function clearvalancebcwexpected() {
	$('#valancebcwexpected').val('');
	defaultAreaProductionDates();
}
function clearvalancebcwwarehouse() {
	$('#valancebcwwarehouse').val('');
}
function clearvalancedeldate() {
	$('#valancedeldate').val('');
}
function clearacc_podate(acci) {
	$('#acc_podate' + acci).val('');
}
function clearacc_eta(acci) {
	$('#acc_eta' + acci).val('');
}
function clearacc_received(acci) {
	$('#acc_received' + acci).val('');
}
function clearacc_checked(acci) {
	$('#acc_checked' + acci).val('');
}
function clearacc_delivered(acci) {
	$('#acc_delivered' + acci).val('');
}

function closePanel(contactno, panelId) {
	var divId = "panel1";
	$('#' + divId).hide("slow");
	$('#minus1').hide();
	$('#plus1').show();
}

function showLegStylePriceField() {
	var slct = $("#legstyle").val();
	if (slct == "Holly" || slct == "Ball & Claw" || slct == "Manhattan"
			|| slct == "Special (as instructions)") {
		$('#legpricespan').show();
	} else {
		$('#legpricespan').hide();
		$('#legprice').val(''); // remove leg price if leg price field hidden
	}
}

function clearmattbay() {
	$("#matbay option[value='n']").attr('selected', 'selected');
	$("#mattressqc option[value='40']").attr('selected', 'selected');
	$("#matbay option[value='40']").hide();
}
function clearbasebay() {
	$("#basebay option[value='n']").attr('selected', 'selected');
	$("#baseqc option[value='40']").attr('selected', 'selected');
	$("#basebay option[value='40']").hide();
}
function cleartopperbay() {
	$("#topperbay option[value='n']").attr('selected', 'selected');
	$("#topperstatus option[value='40']").attr('selected', 'selected');
	$("#topperbay option[value='40']").hide();
}
function clearheadboardbay() {
	$("#headboardbay option[value='n']").attr('selected', 'selected');
	$("#headboardstatus option[value='40']").attr('selected', 'selected');
	$("#headboardbay option[value='40']").hide();
}
function clearlegsbay() {
	$("#legsbay option[value='n']").attr('selected', 'selected');
	$("#legsstatus option[value='40']").attr('selected', 'selected');
	$("#legsbay option[value='40']").hide();
}
function clearvalancebay() {
	$("#valancebay option[value='n']").attr('selected', 'selected');
	$("#valancestatus option[value='40']").attr('selected', 'selected');
	$("#valancebay option[value='40']").hide();
}

function setMattressTypes(defaultSelection) {
	var slct = $("#mattresswidth").val();
	if (defaultSelection == null)
		defaultSelection = "";

	var mattressTypeOptions = [];
	if (slct == "90cm" || slct == "100cm" || slct == "105cm" || slct == "120cm"
			|| slct == "140cm") {
		mattressTypeOptions.push("--");
		mattressTypeOptions.push("TBC");
		mattressTypeOptions.push("One Piece");
		localDefault = "One Piece";
		if (defaultSelection != "TBC" && defaultSelection != "One Piece") {
			defaultSelection = "One Piece";
		}
	} else {
		mattressTypeOptions.push("--");
		mattressTypeOptions.push("TBC");
		mattressTypeOptions.push("One Piece");
		mattressTypeOptions.push("Zipped Pair");
		mattressTypeOptions.push("Zipped Pair (Centre Only)");
	}

	$('#mattresstype').find('option').remove();
	$.each(mattressTypeOptions, function(val, text) {
		$('#mattresstype').append($('<option></option>').val(text).html(text));
	});
	if (defaultSelection != "") {
		$("#mattresstype option[value='" + defaultSelection + "']").attr(
				'selected', 'selected');
	}
}

function setLinkPosition(defaultSelection) {
	if (defaultSelection == null)
		defaultSelection = "";
	var slct = $("#upholsteredbase").val();

	var linkPositionOptions = [];
	if (slct == "Yes") {
		linkPositionOptions.push("Link Underneath");
	} else {
		linkPositionOptions.push("Link Underneath");
		linkPositionOptions.push("Link on Ends");
		if (defaultSelection == "") {
			defaultSelection = "Link on Ends";
		}
	}

	$('#linkposition').find('option').remove();
	$.each(linkPositionOptions, function(val, text) {
		$('#linkposition').append($('<option></option>').val(text).html(text));
	});
	if (defaultSelection != "") {
		$("#linkposition option[value='" + defaultSelection + "']").attr(
				'selected', 'selected');
	}
}

function IsNumeric(sText) {
	var ValidChars = "0123456789.";
	var IsNumber = true;
	var Char;

	for (i = 0; i < sText.length && IsNumber == true; i++) {
		Char = sText.charAt(i);
		if (ValidChars.indexOf(Char) == -1) {
			IsNumber = false;
		}
	}
	return IsNumber;
}

function enableComponentSections() {
	// mattress status
	$('#matt1 :input').attr('disabled', false);

	// topper
	$('#topp1 :input').attr('disabled', false);

	// base
	$('#base1 :input').attr('disabled', false);

	// headboard
	$('#head1 :input').attr('disabled', false);

	// valance
	$('#valance1 :input').attr('disabled', false);

	// accessories
	$('#accessory1 :input').attr('disabled', false);

	// legs
	$('#legs1 :input').attr('disabled', false);
}

function disableWholeForm() {
	$('#form1 input').attr('disabled', 'disabled');
	$('#form1 textarea').attr('disabled', 'disabled');
	$('#form1 select').attr('disabled', 'disabled');
}

function defaultSingleComponentProductionDate(mainProdDate, compId) {
	var prodDate = $('#'+compId).val();
	if (!prodDate || prodDate == '') {
		$('#'+compId).val(mainProdDate);
	}
}

function componentProductionDateUpdateHandler(ctrlName) {
	var latestDate = getLatestComponentProdDate();
	// console.log("latestDate="+latestDate);
	if (!latestDate || latestDate == "") {
		return;
	}
	var latestDateUs = swapUkUsDateString(latestDate);
	// console.log("latestDateUs="+latestDateUs);

	var mainProdDate = $('#productiondate').val();
	// console.log("mainProdDate="+mainProdDate);
	if (!mainProdDate || mainProdDate == "") {
		mainProdDate = "01/01/1970";
	}
	var mainProdDateUs = swapUkUsDateString(mainProdDate);
	// console.log("mainProdDateUs="+mainProdDateUs);

	var latestDateObj = Date.parse(latestDateUs);
	var mainProdDateObj = Date.parse(mainProdDateUs);
	// console.log("latestDateObj="+latestDateObj);
	// console.log("mainProdDateObj="+mainProdDateObj);
	
	if (latestDateObj > mainProdDateObj) {
		$('#productiondate').val(latestDate);
	}
}

function getLatestComponentProdDate() {
	var latestInt = 0;
	var latestStr = "";
	
	var dateInt = getComponentProdDateAsInt('mattbcwexpected');
	if (dateInt > latestInt) {
		latestInt = dateInt;
		latestStr = getComponentProdDate('mattbcwexpected');
	}

	dateInt = getComponentProdDateAsInt('basebcwexpected');
	if (dateInt > latestInt) {
		latestInt = dateInt;
		latestStr = getComponentProdDate('basebcwexpected');
	}

	dateInt = getComponentProdDateAsInt('topperbcwexpected');
	if (dateInt > latestInt) {
		latestInt = dateInt;
		latestStr = getComponentProdDate('topperbcwexpected');
	}

	dateInt = getComponentProdDateAsInt('headboardbcwexpected');
	if (dateInt > latestInt) {
		latestInt = dateInt;
		latestStr = getComponentProdDate('headboardbcwexpected');
	}

	dateInt = getComponentProdDateAsInt('legsbcwexpected');
	if (dateInt > latestInt) {
		latestInt = dateInt;
		latestStr = getComponentProdDate('legsbcwexpected');
	}

	dateInt = getComponentProdDateAsInt('valancebcwexpected');
	if (dateInt > latestInt) {
		latestInt = dateInt;
		latestStr = getComponentProdDate('valancebcwexpected');
	}

	dateInt = getComponentProdDateAsInt('accessoriesbcwexpected');
	if (dateInt > latestInt) {
		latestInt = dateInt;
		latestStr = getComponentProdDate('accessoriesbcwexpected');
	}
	
	return latestStr;
}

function getComponentProdDateAsInt(compId) {
	var prodDate = $('#'+compId).val();
	if (!prodDate || prodDate == "") {
		return 0;
	}
	return Date.parse(swapUkUsDateString(prodDate));
}

function getComponentProdDate(compId) {
	var prodDate = $('#'+compId).val();
	if (!prodDate || prodDate == "") {
		return '';
	}
	return prodDate;
}

function swapUkUsDateString(dateStr) {
	if (!dateStr || dateStr == '') return '01/01/1970';
	return dateStr.substring(3,5) + '/' + dateStr.substring(0,2) + '/' + dateStr.substring(6,10);
}

function logChange(elmnt) {
	// not needed here (came from edit-purchase screen)
}

function resetExWorks(qcSelectCtrl, exWorksSelectCtrl) {
	var qcVal = $('#'+qcSelectCtrl).val();
	if (qcVal == "80") {
		// item cancelled, so reset ex works val
		$('#'+exWorksSelectCtrl).val("n");
	}
}

/**
 * Defaults the crate 'packed with' dropdown for stuff like legs
 */
function defaultCratePackedWith(compId, packedWithSlctName) {
	if (!orderHasComponent(compId)) {
		// console.log("order does not have component "+CompNo);
		return false;
	} 
	
	var wrapType = $("#wraptype").val();
	if (wrapType != 4) {
		// only applies if the wraptype is crate
		return false;
	}
	
	// see if the packed with dropdown already has a value
	var packedWith = $("#" + packedWithSlctName).val();
	if (packedWith != '') {
		// already has a value
		return false;
	}
	
	var defaultPackedWith = '';
	if (orderHasComponent('5')) {
		defaultPackedWith = '5'; // topper
	} else if (orderHasComponent('3')) {
		defaultPackedWith = '3'; // base
	} else if (orderHasComponent('1')) {
		defaultPackedWith = '1'; // mattress
	}
	
	var defaultWasSet = false;
	if (defaultPackedWith != '') {
		// set the default
		$("#" + packedWithSlctName + " option[value='" + defaultPackedWith + "']").prop('selected', true);
		
		// remove the 'empty' selection value
		$("#" + packedWithSlctName + " option[value='']").remove();
		
		defaultWasSet = true;
	}
	
	return defaultWasSet;
}

/**
 * Defaults the box 'packed with' dropdown for stuff like legs
 */
function defaultBoxPackedWith(compId, packedWithSlctName) {
	if (!orderHasComponent(compId)) {
		// console.log("order does not have component "+CompNo);
		return false;
	} 
	
	var wrapType = $("#wraptype").val();
	if (wrapType != 3) {
		// only applies if the wraptype is box
		return false;
	}
	
	// see if the packed with dropdown already has a value
	var packedWith = $("#" + packedWithSlctName).val();
	if (packedWith != '') {
		// already has a value
		return false;
	}
	var defaultPackedWith = '';
	if (compId == 9) {
		if (orderHasComponent('5')) {
			defaultPackedWith = '5'; // topper
		} else if (orderHasComponent('1')) {
			defaultPackedWith = '1'; // mattress
		} else if (orderHasComponent('3')) {
			defaultPackedWith = '3'; // base
		} else if (orderHasComponent('7')) {
			defaultPackedWith = '7'; // legs
		}
	} else {
		if (orderHasComponent('3')) {
			defaultPackedWith = '3'; // base
		} else if (orderHasComponent('5')) {
			defaultPackedWith = '5'; // topper
		} else if (orderHasComponent('1')) {
			defaultPackedWith = '1'; // mattress
		} else if (orderHasComponent('7')) {
			defaultPackedWith = '7'; // legs
		} else if (orderHasComponent('9')) {
			defaultPackedWith = '9'; // acc
		}
	}
	
	var defaultWasSet = false;
	if (defaultPackedWith != '') {
		// set the default
		$("#" + packedWithSlctName + " option[value='" + defaultPackedWith + "']").prop('selected', true);
		
		// remove the 'empty' selection value (unless it's accessories, where we leave it available
		if (compId != 9) {
			$("#" + packedWithSlctName + " option[value='']").remove();
		}
		
		defaultWasSet = true;
	}
	
	return defaultWasSet;
}

function showHideAccWrap() {
	
	var wrapType = $("#wraptype").val();
	if (wrapType == 1) {
		// hide whole div
		$('.tariffcode').hide();
	} else if (wrapType == 2) {
		// show everything
		$('.tariffcode').show();
	} else if (wrapType == 3) {
		// if acc packed with something else, just show tariff code, else show everything
		var accPackedWithCompNo = $("#accBoxPackedWith").val();
		if (accPackedWithCompNo == '' || accPackedWithCompNo == '0' || typeof accPackedWithCompNo === "undefined") {
			$('.tariffcode').show();
		} else {
			$('.tariffcode').show();
		}
	} else if (wrapType == 4) {
		// just show tariff code
		var accPackedWithCompNo = $("#accPackedWith").val();
		//alert("accPackedWithCompNo=" + accPackedWithCompNo);
		if (accPackedWithCompNo == '0' || typeof accPackedWithCompNo === "undefined") {
			$('#accCrateShow').show();
			$('.hideacccrate').show();
			$('.tariffcode').show();
			$('.noacccrate').hide();
			
		} else {
			$('.tariffcode').show();
			$('.hideacccrate').hide();
			$('.noacccrate').hide();
		}
	}
}
