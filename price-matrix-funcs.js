function getAllStandardPrices() {
	if (isComponentRequired(1)) {
		getStandardMattressPrice();
	}

	if (isComponentRequired(3)) {
		getStandardBasePrice();
	}

	if (isComponentRequired(5)) {
		getStandardTopperPrice();
	}

	if (isComponentRequired(8)) {
		getStandardHeadboardPrice();
	}
	
	if (isComponentRequired(7)) {
		getStandardLegsPrice();
	}

	if (isComponentRequired(16)) {
		getStandardAddLegsPrice();
	}

	if (isComponentRequired(6)) {
		getStandardValancePrice();
	}

	if (isComponentRequired(12)) {
		// upholstered base
		getStandardBaseUpholsteryPrice();
	}

	if (isComponentRequired(11)) {
		// base trim
		getStandardBaseTrimPrice();
	}

	if (isComponentRequired(13)) {
		// base drawers
		getStandardBaseDrawersPrice();
	}

	if (isComponentRequired(18)) {
		// headboard trim
		getStandardHeadboardTrimPrice();
	}
}

function isComponentRequired(compId) {
	var radioName;
	if (compId == 1) {
		radioName = "mattressrequired";
	} else if (compId == 3) {
		radioName = "baserequired";
	} else if (compId == 5) {
		radioName = "topperrequired";
	} else if (compId == 7) {
		radioName = "legsrequired";
	} else if (compId == 8) {
		radioName = "headboardrequired";
	} else if (compId == 6) {
		radioName = "valancerequired";
	} else if (compId == 12) {
		radioName = "baserequired";
	} else if (compId == 17) {
		radioName = "baserequired";
	} else if (compId == 11) {
		radioName = "baserequired";
	} else if (compId == 13) {
		radioName = "baserequired";
	} else if (compId == 16) {
		radioName = "legsrequired";
	} else if (compId == 10) {
		radioName = "headboardrequired";
	}
	
	var val = $("input[name=" + radioName + "]:checked").val();
	var required = (val == 'y');
	
	if ((compId == 12 || compId == 17) && required) {
		// for upholstered base & base fabric also need to check BaseUpholstery dropdown
		var baseUpholstery = $("#upholsteredbase option:selected").val();
		console.log("baseUpholstery=" + baseUpholstery);
		required = (baseUpholstery == 'Yes' || baseUpholstery == 'Yes, Com');
	}
	
	if (compId == 11 && required) {
		// for base trim also need to check BaseTrim dropdown
		var baseTrim = $("#basetrim option:selected").val();
		required = (baseTrim != 'n');
	}

	if (compId == 13 && required) {
		// for base drawers also need to check drawer config dropdown
		var drawerConfig = $("#drawerconfig option:selected").val();
		required = (drawerConfig != 'n');
	}
	
	if (compId == 10 && required) {
		// for headbaord trim also check the manhattantrim dropdown
		var headboardTrim = $("#manhattantrim option:selected").val();
		required = (headboardTrim != 'n' && headboardTrim != '--');
	}
	
	return required;
}

function getStandardMattressPrice() {
	var model = $("#savoirmodel option:selected").val();
	var width = $("#mattresswidth option:selected").val();
	var length = $("#mattresslength option:selected").val();
	var stdPrice = getStandardPriceSync(1, model, width, length, '', '', '', 1.0);
	trace("getStandardMattressPrice = " + stdPrice);
	
	if (stdPrice == -1 && $('.mattressdiscountcls').is(':visible')) {
		$("#mattressprice").val(''); // clear out any previous price, so long as it's a price matrix price
	}
	
	updateStandardPriceFields(stdPrice, 'standardmattresspricespan', 'standardmattressprice', setEditPageMattressDiscountSummary, 'mattressdiscountcls');
}

function getStandardBasePrice() {
	var model = $("#basesavoirmodel option:selected").val();
	var width = $("#basewidth option:selected").val();
	var length = $("#baselength option:selected").val();
	var stdPrice = getStandardPriceSync(3, model, width, length, '', '', '', 1.0);
	trace("getStandardBasePrice = " + stdPrice);

	if (stdPrice == -1 && $('.basediscountcls').is(':visible')) {
		$("#baseprice").val(''); // clear out any previous price,  so long as it's a price matrix price
		calcTotalBasePrice();
	}

	updateStandardPriceFields(stdPrice, 'standardbasepricespan', 'standardbaseprice', setEditPageBaseDiscountSummary, 'basediscountcls');
}

function getStandardBaseUpholsteryPrice() {
	var stdPrice = 0.0;
	if (isComponentRequired(12)) {
		var model = $("#basesavoirmodel option:selected").val();
		if (model != "No. 1") {
			// Horrible fudge for free base trim with No. 1 bases. Not able to use compIdSet1 to base basesavoirmodel to getStandardPriceSync, as that would make the trim
			// free for all base models. Need to extend getStandardPriceSync to include the value selected for the base model - a lot of work!
			stdPrice = getStandardPriceSync(12, 'Base Upholstery', '', '', '', '', '', 1.0);
		}
	}
	
	if (stdPrice == -1 && $('.upholsterydiscountcls').is(':visible')) {
		$("#upholsteryprice").val(''); // clear out any previous price,  so long as it's a price matrix price
		calcTotalBasePrice();
	}

	updateStandardPriceFields(stdPrice, 'standardupholsterypricespan', 'standardupholsteryprice', setEditPageBaseUpholsteryDiscountSummary, 'upholsterydiscountcls');
}

function getStandardBaseTrimPrice() {
	var option = $("#basetrim option:selected").val();
	var stdPrice = 0.0;
	if (isComponentRequired(11)) {
		var model = $("#basesavoirmodel option:selected").val();
		if (model != "No. 1") {
			// Horrible fudge for free base trim with No. 1 bases. Not able to use compIdSet1 to base basesavoirmodel to getStandardPriceSync, as that would make the trim
			// free for all base models. Need to extend getStandardPriceSync to include the value selected for the base model - a lot of work!
			stdPrice = getStandardPriceSync(11, 'Base Trim', option, '', '', '', '', 1.0);
		}
	}

	if (stdPrice == -1 && $('.basetrimdiscountcls').is(':visible')) {
		$("#basetrimprice").val(''); // clear out any previous price, so long as it's a price matrix price
		calcTotalBasePrice();
	}
	
	updateStandardPriceFields(stdPrice, 'standardbasetrimpricespan', 'standardbasetrimprice', setEditPageBaseTrimDiscountSummary, 'basetrimdiscountcls');
}

function getStandardBaseDrawersPrice() {
	var option = $("#drawerconfig option:selected").val();
	var stdPrice = 0.0;
	if (isComponentRequired(13)) {
		stdPrice = getStandardPriceSync(13, 'Base Drawers', option, '', '', '', '', 1.0);
	}

	if (stdPrice == -1 && $('.basedrawersdiscountcls').is(':visible')) {
		$("#basedrawersprice").val(''); // clear out any previous price, so long as it's a price matrix price
		calcTotalBasePrice();
	}
	
	updateStandardPriceFields(stdPrice, 'standardbasedrawerspricespan', 'standardbasedrawersprice', setEditPageBaseDrawersDiscountSummary, 'basedrawersdiscountcls');
}

function getStandardTopperPrice() {
	var type = $("#toppertype option:selected").val();
	var width = $("#topperwidth option:selected").val();
	var length = $("#topperlength option:selected").val();
	var compIdSet1 = "";
	var compIdSet2 = "";
	if (isComponentRequired(1)) {
		compIdSet1 = "1";
	}
	var stdPrice = getStandardPriceSync(5, type, width, length, '', compIdSet1, compIdSet2, 1.0);

	if (stdPrice == -1 && $('.topperdiscountcls').is(':visible')) {
		$("#topperprice").val(''); // clear out any previous price, so long as it's a price matrix price
	}
	
	updateStandardPriceFields(stdPrice, 'standardtopperpricespan', 'standardtopperprice', setEditPageTopperDiscountSummary, 'topperdiscountcls');
}

function getStandardHeadboardPrice() {
	var type = $("#headboardstyle option:selected").val();
	var width = "";
	var length = "";
	var compIdSet1 = "";
	var compIdSet2 = "";
	var stdPrice = getStandardPriceSync(8, type, width, length, '', compIdSet1, compIdSet2, 1.0);
	//trace("getStandardHeadboardPrice = " + stdPrice);
	
	if (stdPrice == -1 && $('.headboarddiscountcls').is(':visible')) {
		$("#headboardprice").val(''); // clear out any previous price, so long as it's a price matrix price
		calcTotalHeadboardPrice();
	}
	
	updateStandardPriceFields(stdPrice, 'standardheadboardpricespan', 'standardheadboardprice', setEditPageHeadboardDiscountSummary, 'headboarddiscountcls');
}

function getStandardHeadboardTrimPrice() {
	var option = $("#headboardstyle option:selected").val();
	var stdPrice = 0.0;
	if (isComponentRequired(10)) {
		stdPrice = getStandardPriceSync(10, 'Manhattan Trim', option, '', '', '', '', 1.0);
	}

	if (stdPrice == -1 && $('.headboardtrimdiscountcls').is(':visible')) {
		$("#headboardtrimprice").val(''); // clear out any previous price, so long as it's a price matrix price
		calcTotalHeadboardPrice();
	}
	
	updateStandardPriceFields(stdPrice, 'standardheadboardtrimpricespan', 'standardheadboardtrimprice', setEditPageHeadboardTrimDiscountSummary, 'headboardtrimdiscountcls');
}

function getStandardLegsPrice() {
	var legCount = $("#legqty").val();
	var legFinish = $("#legfinish").val();
	var type = $("#legstyle").val();
	console.log("legfinish=" + legFinish);
	console.log("type=" + type);
	var compIdSet1 = "";
	var compIdSet2 = "";
	
	var freeLegs = false;
	if (legCount == 0) {
		console.log("getStandardLegsPrice: legCount=0, so set price to 0.0");
		freeLegs = true;
	} else if (isComponentRequired(3)) {
		if (type=='Castors' || type=='Metal') {
			console.log("getStandardLegsPrice: free legs with base when type = " + type);
			freeLegs = true;
		} else if (type=='Wooden Tapered') {
			var finish = $("#legfinish").val();
			if (finish != 'Natural Maple') {
				console.log("getStandardLegsPrice: free legs with base when type = " + type + " & finish " + finish);
				freeLegs = true;
			}
		}
	}
	
	var stdPrice;
	if (freeLegs) {
		stdPrice = 0.0;
		if (legCount == 0) {
			stdPrice = -1; // so that the discount fields disappear on the form
		}
	} else {
		stdPrice = getStandardPriceSync(7, type, legFinish, '', '', compIdSet1, compIdSet2, legCount);
	}

	if (stdPrice == -1 && $('.legsdiscountcls').is(':visible')) {
		$("#legprice").val(''); // clear out any previous price, so long as it's a price matrix price
	}
	
	updateStandardPriceFields(stdPrice, 'standardlegspricespan', 'standardlegsprice', setEditPageLegsDiscountSummary, 'legsdiscountcls');
}

function getStandardAddLegsPrice() {
	var type = $("#addlegstyle option:selected").val();
	var addLegCount = $("#addlegqty option:selected").val();
	trace("addlegstyle=" + type);
	trace("addLegCount=" + addLegCount);
	var compIdSet1 = "";
	var compIdSet2 = "";
	var stdPrice = getStandardPriceSync(16, type, '', '', '', compIdSet1, compIdSet2, addLegCount);

	if (stdPrice == -1 && $('.addlegsdiscountcls').is(':visible')) {
		$("#addlegprice").val(''); // clear out any previous price, so long as it's a price matrix price
	}
	
	updateStandardPriceFields(stdPrice, 'standardaddlegspricespan', 'standardaddlegsprice', setEditPageAddLegsDiscountSummary, 'addlegsdiscountcls');
}

function getStandardValancePrice() {
	var type = "Valance";
	var width = "";
	var length = "";
	var compIdSet1 = "";
	var compIdSet2 = "";
	var stdPrice = getStandardPriceSync(6, type, width, length, '', compIdSet1, compIdSet2, 1.0);

	if (stdPrice == -1 && $('.valancediscountcls').is(':visible')) {
		$("#valanceprice").val(''); // clear out any previous price, so long as it's a price matrix price
	}
	
	updateStandardPriceFields(stdPrice, 'standardvalancepricespan', 'standardvalanceprice', setEditPageValanceDiscountSummary, 'valancediscountcls');
}

function getStandardPriceSync(compId, type, dim1, dim2, dim3, compIdSet1, compIdSet2, multiplier) {
	if (!isPriceMatrixEnabled()) {
		trace("Price matrix disabled. getStandardPriceSync doing nothing");
		return;
	}
	
	var curr = $("#currency").val();
	var url = "ajaxGetMatrixPrice.asp?compid=" + compId + "&type=" + encodeURI(type).replace('&', '%26') + "&dim1=" + encodeURI(dim1) + "&dim2=" + encodeURI(dim2) + "&dim3=" + encodeURI(dim3) + "&curr=" + curr + "&multiplier=" + encodeURI(multiplier);
	
	if (compIdSet1 != '') {
		url += "&compidset1=" + compIdSet1;
	}

	if (compIdSet2 != '') {
		url += "&compidset2=" + compIdSet2;
	}

	if (isTradeJs == "y") {
		url += "&trade=y&vatrate=" + vatRateJs;
	}
	
	url += "&ts=" + (new Date()).getTime();
	trace(url);

	return $.ajax({
        type: "GET",
        url: url,
        async: false
    }).responseText;
}

function updateStandardPriceFields(stdPrice, divId, fieldId, callback, hideShowCls) {

	if (!isPriceMatrixEnabled()) {
		trace("Price matrix disabled. updateStandardPriceFields doing nothing");
		return;
	}

	//trace("divId = " + divId);
	//trace("fieldId = " + fieldId);
	var effectiveStdPrice = stdPrice;
	if (effectiveStdPrice < 0.0) effectiveStdPrice = 0.0;
	if (divId != "") {
		$('#'+divId).html(effectiveStdPrice);
	}

	if (fieldId != "") {
		$('#'+fieldId).val(effectiveStdPrice);
		if (stdPrice > -1.0) $('#'+fieldId).change(); // only trigger the discount recalc if there is a list price
	}
	callback();
	//trace("hideShowCls=" + hideShowCls);
	if (hideShowCls != "") {
		trace("stdPrice = " + stdPrice);
		if (stdPrice > -1.0) {
			//trace("show " + hideShowCls + " hide " + hideShowCls + '_dummy');
			$('.'+hideShowCls).show();
			$('.'+hideShowCls+'_dummy').hide();
		} else {
			//trace("hide " + hideShowCls + " show " + hideShowCls + '_dummy');
			$('.'+hideShowCls).hide();
			$('.'+hideShowCls+'_dummy').show();
		}
	}
}

function setMattressPrice() {
	setComponentPrice('mattressdiscounttype1', 'mattressdiscount', 'standardmattressprice', 'mattressprice');
}

function setTopperPrice() {
	setComponentPrice('topperdiscounttype1', 'topperdiscount', 'standardtopperprice', 'topperprice');
}

function setBasePrice() {
	setComponentPrice('basediscounttype1', 'basediscount', 'standardbaseprice', 'baseprice');
	if (typeof calcTotalBasePrice !== 'undefined' && $.isFunction(calcTotalBasePrice)) {
		// if the function exists (is available in add-order & edit-purchase), call calcTotalBasePrice to set the info only total base price field
		calcTotalBasePrice();
	}
}

function setBaseTrimPrice() {
	setComponentPrice('basetrimdiscounttype1', 'basetrimdiscount', 'standardbasetrimprice', 'basetrimprice');
	if (typeof calcTotalBasePrice !== 'undefined' && $.isFunction(calcTotalBasePrice)) {
		// if the function exists (is available in add-order & edit-purchase), call calcTotalBasePrice to set the info only total base price field
		calcTotalBasePrice();
	}
}

function setBaseDrawersPrice() {
	setComponentPrice('basedrawersdiscounttype1', 'basedrawersdiscount', 'standardbasedrawersprice', 'basedrawersprice');
	if (typeof calcTotalBasePrice !== 'undefined' && $.isFunction(calcTotalBasePrice)) {
		// if the function exists (is available in add-order & edit-purchase), call calcTotalBasePrice to set the info only total base price field
		calcTotalBasePrice();
	}
}

function setBaseFabricPrice() {
	setComponentPrice('basefabricdiscounttype1', 'basefabricdiscount', 'standardbasefabricprice', 'basefabricprice');
	if (typeof calcTotalBasePrice !== 'undefined' && $.isFunction(calcTotalBasePrice)) {
		// if the function exists (is available in add-order & edit-purchase), call calcTotalBasePrice to set the info only total base price field
		calcTotalBasePrice();
	}
}

function setBaseUpholsteryPrice() {
	setComponentPrice('upholsterydiscounttype1', 'upholsterydiscount', 'standardupholsteryprice', 'upholsteryprice');
	if (typeof calcTotalBasePrice !== 'undefined' && $.isFunction(calcTotalBasePrice)) {
		// if the function exists (is available in add-order & edit-purchase), call calcTotalBasePrice to set the info only total base price field
		calcTotalBasePrice();
	}
}

function setHeadboardPrice() {
	setComponentPrice('headboarddiscounttype1', 'headboarddiscount', 'standardheadboardprice', 'headboardprice');
	if (typeof calcTotalHeadboardPrice !== 'undefined' && $.isFunction(calcTotalHeadboardPrice)) {
		// if the function exists (is available in add-order & edit-purchase), call calcTotalHeadboardPrice to set the info only total base price field
		calcTotalHeadboardPrice();
	}
}

function setHeadboardTrimPrice() {
	setComponentPrice('headboardtrimdiscounttype1', 'headboardtrimdiscount', 'standardheadboardtrimprice', 'headboardtrimprice');
	if (typeof calcTotalHeadboardPrice !== 'undefined' && $.isFunction(calcTotalHeadboardPrice)) {
		// if the function exists (is available in add-order & edit-purchase), call calcTotalHeadboardPrice to set the info only total headboard price field
		calcTotalHeadboardPrice();
	}
}

function setLegsPrice() {
	setComponentPrice('legsdiscounttype1', 'legsdiscount', 'standardlegsprice', 'legprice');
}

function setAddLegsPrice() {
	setComponentPrice('addlegsdiscounttype1', 'addlegsdiscount', 'standardaddlegsprice', 'addlegprice');
}

function setValancePrice() {
	setComponentPrice('valancediscounttype1', 'valancediscount', 'standardvalanceprice', 'valanceprice');
}

function setComponentPrice(pcFieldId, dcFieldId, stdPriceFieldId, priceFieldId) {
	
	if (!isPriceMatrixEnabled()) {
		trace("Price matrix disabled. setComponentPrice doing nothing");
		return;
	}

	var isPercent = $('#' + pcFieldId).is(':checked');
	var discount = $('#' + dcFieldId).val() / 1.0;
	var stdPrice = $('#' + stdPriceFieldId).val() / 1.0;
	//trace("pcFieldId=" + pcFieldId);
	//trace("isPercent=" + isPercent);
	//trace("discount=" + discount);
	//trace("stdPrice=" + stdPrice);
	var price = 0.0;
	if (stdPrice > -1.0) {
		if (isPercent) {
			price = stdPrice * (1.0 - discount / 100.0);
			//trace("% price=" + price);
		} else {
			price = stdPrice - discount;
			//trace("£ price=" + price);
		}
	}
	
	//trace("price=" + price);
	//trace("priceFieldId=" + priceFieldId);
	if (price > -1.0) {
		$('#' + priceFieldId).val(price.toFixed(2));
	}
}

function setMattressDiscount() {
	setComponentDiscount('mattressdiscounttype1', 'mattressdiscount', 'standardmattressprice', 'mattressprice');
}

function setTopperDiscount() {
	setComponentDiscount('topperdiscounttype1', 'topperdiscount', 'standardtopperprice', 'topperprice');
}

function setBaseDiscount() {
	setComponentDiscount('basediscounttype1', 'basediscount', 'standardbaseprice', 'baseprice');
}

function setBaseTrimDiscount() {
	setComponentDiscount('basetrimdiscounttype1', 'basetrimdiscount', 'standardbasetrimprice', 'basetrimprice');
}

function setBaseDrawersDiscount() {
	setComponentDiscount('basedrawersdiscounttype1', 'basedrawersdiscount', 'standardbasedrawersprice', 'basedrawersprice');
}

function setBaseFabricDiscount() {
	setComponentDiscount('basefabricdiscounttype1', 'basefabricdiscount', 'standardbasefabricprice', 'basefabricprice');
}

function setBaseUpholsteryDiscount() {
	setComponentDiscount('upholsterydiscounttype1', 'upholsterydiscount', 'standardupholsteryprice', 'upholsteryprice');
}

function setHeadboardDiscount() {
	setComponentDiscount('headboarddiscounttype1', 'headboarddiscount', 'standardheadboardprice', 'headboardprice');
}

function setHeadboardTrimDiscount() {
	setComponentDiscount('headboardtrimdiscounttype1', 'headboardtrimdiscount', 'standardheadboardtrimprice', 'headboardtrimprice');
}

function setLegsDiscount() {
	setComponentDiscount('legsdiscounttype1', 'legsdiscount', 'standardlegsprice', 'legprice');
}

function setAddLegsDiscount() {
	setComponentDiscount('addlegsdiscounttype1', 'addlegsdiscount', 'standardaddlegsprice', 'addlegprice');
}

function setValanceDiscount() {
	setComponentDiscount('valancediscounttype1', 'valancediscount', 'standardvalanceprice', 'valanceprice');
}

function setComponentDiscount(pcFieldId, dcFieldId, stdPriceFieldId, priceFieldId) {

	if (!isPriceMatrixEnabled()) {
		trace("Price matrix disabled. setComponentDiscount doing nothing");
		return;
	}

	var isPercent = $('#' + pcFieldId).is(':checked');
	var price = $('#' + priceFieldId).val() / 1.0;
	var stdPrice = $('#' + stdPriceFieldId).val() / 1.0;
	//trace("setComponentDiscount: priceFieldId=" + priceFieldId);
	//trace("setComponentDiscount: isPercent=" + isPercent);
	//trace("setComponentDiscount: price=" + price);
	//trace("setComponentDiscount: stdPrice=" + stdPrice);
	var discount = 0.0;
	if (stdPrice > 0.0) {
		if (isPercent) {
			discount = 100.0 * (1.0 - price / stdPrice);
			//trace("setComponentDiscount: % discount=" + discount);
		} else {
			discount = stdPrice - price;
			//trace("setComponentDiscount: £ discount=" + discount);
		}
	}
	
	if (discount > 0.0) {
		$('#' + dcFieldId).val(discount.toFixed(2));
	}
}

function setMattressDiscountAmt() {
	setComponentDiscountAmt('mattressdiscountamt', 'standardmattressprice', 'mattressprice');
}

function setTopperDiscountAmt() {
	setComponentDiscountAmt('topperdiscountamt', 'standardtopperprice', 'topperprice');
}

function setBaseDiscountAmt() {
	setComponentDiscountAmt('basediscountamt', 'standardbaseprice', 'baseprice');
}

function setBaseTrimDiscountAmt() {
	setComponentDiscountAmt('basetrimdiscountamt', 'standardbasetrimprice', 'basetrimprice');
}

function setBaseDrawersDiscountAmt() {
	setComponentDiscountAmt('basedrawersdiscountamt', 'standardbasedrawersprice', 'basedrawersprice');
}

function setBaseFabricDiscountAmt() {
	setComponentDiscountAmt('basefabricdiscountamt', 'standardbasefabricprice', 'basefabricprice');
}

function setBaseUpholsteryDiscountAmt() {
	setComponentDiscountAmt('upholsterydiscountamt', 'standardupholsteryprice', 'upholsteryprice');
}

function setHeadboardDiscountAmt() {
	setComponentDiscountAmt('headboarddiscountamt', 'standardheadboardprice', 'headboardprice');
}

function setHeadboardTrimDiscountAmt() {
	setComponentDiscountAmt('headboardtrimdiscountamt', 'standardheadboardtrimprice', 'headboardtrimprice');
}

function setLegsDiscountAmt() {
	setComponentDiscountAmt('legsdiscountamt', 'standardlegsprice', 'legprice');
}

function setAddLegsDiscountAmt() {
	setComponentDiscountAmt('addlegsdiscountamt', 'standardaddlegsprice', 'addlegprice');
}

function setValanceDiscountAmt() {
	setComponentDiscountAmt('valancediscountamt', 'standardvalanceprice', 'valanceprice');
}

function setComponentDiscountAmt(amtFieldId, stdPriceFieldId, priceFieldId) {

	if (!isPriceMatrixEnabled()) {
		trace("Price matrix disabled. setComponentDiscountAmt doing nothing");
		return;
	}
	
	var price = $('#' + priceFieldId).val() / 1.0;
	var stdPrice = $('#' + stdPriceFieldId).val() / 1.0;
	var discountAmt = stdPrice - price;
	if (discountAmt < 0.0) discountAmt = 0.0;
	//trace("setComponentDiscountAmt: price=" + price);
	//trace("setComponentDiscountAmt: stdPrice=" + stdPrice);
	//trace("setComponentDiscountAmt: discountAmt=" + discountAmt);
	
	$('#' + amtFieldId).val(discountAmt.toFixed(2));
	$('#' + amtFieldId + 'span').html(discountAmt.toFixed(2));
	
	setSummaryTotals();
}

function setSummaryTotals() {
	var discountAmtTotal = 0.0;
	if ($('#mattressdiscountamt').length ) discountAmtTotal += $('#mattressdiscountamt').val() / 1.0;
	if ($('#basediscountamt').length ) discountAmtTotal += $('#basediscountamt').val() / 1.0;
	if ($('#basetrimdiscountamt').length ) discountAmtTotal += $('#basetrimdiscountamt').val() / 1.0;
	if ($('#basedrawersdiscountamt').length ) discountAmtTotal += $('#basedrawersdiscountamt').val() / 1.0;
	if ($('#upholsterydiscountamt').length ) discountAmtTotal += $('#upholsterydiscountamt').val() / 1.0;
	if ($('#topperdiscountamt').length ) discountAmtTotal += $('#topperdiscountamt').val() / 1.0;
	if ($('#headboarddiscountamt').length ) discountAmtTotal += $('#headboarddiscountamt').val() / 1.0;
	if ($('#headboardtrimdiscountamt').length ) discountAmtTotal += $('#headboardtrimdiscountamt').val() / 1.0;
	if ($('#legsdiscountamt').length ) discountAmtTotal += $('#legsdiscountamt').val() / 1.0;
	if ($('#addlegsdiscountamt').length ) discountAmtTotal += $('#addlegsdiscountamt').val() / 1.0;
	$('#totaldiscountamt').val(discountAmtTotal.toFixed(2));
	$('#totaldiscountamtspan').html(discountAmtTotal.toFixed(2));
}

function setEditPageMattressDiscountSummary() {
	setEditPageComponentDiscountSummary('mattressprice', 'standardmattressprice', 'standardmattresspricespan2', 'mattressdiscountamtspan');
}

function setEditPageBaseDiscountSummary() {
	setEditPageComponentDiscountSummary('baseprice', 'standardbaseprice', 'standardbasepricespan2', 'basediscountamtspan');
}

function setEditPageBaseFabricDiscountSummary() {
	setEditPageComponentDiscountSummary('basefabricprice', 'standardbasefabricprice', 'standardbasefabricpricespan2', 'basefabricdiscountamtspan');
}

function setEditPageBaseUpholsteryDiscountSummary() {
	setEditPageComponentDiscountSummary('upholsteryprice', 'standardupholsteryprice', 'standardupholsterypricespan2', 'upholsterydiscountamtspan');
}

function setEditPageBaseTrimDiscountSummary() {
	setEditPageComponentDiscountSummary('basetrimprice', 'standardbasetrimprice', 'standardbasetrimpricespan2', 'basetrimdiscountamtspan');
}

function setEditPageBaseDrawersDiscountSummary() {
	setEditPageComponentDiscountSummary('basedrawersprice', 'standardbasedrawersprice', 'standardbasedrawerspricespan2', 'basedrawersdiscountamtspan');
}

function setEditPageTopperDiscountSummary() {
	setEditPageComponentDiscountSummary('topperprice', 'standardtopperprice', 'standardtopperpricespan2', 'topperdiscountamtspan');
}

function setEditPageHeadboardDiscountSummary() {
	setEditPageComponentDiscountSummary('headboardprice', 'standardheadboardprice', 'standardheadboardpricespan2', 'headboarddiscountamtspan');
}

function setEditPageHeadboardTrimDiscountSummary() {
	setEditPageComponentDiscountSummary('headboardtrimprice', 'standardheadboardtrimprice', 'standardheadboardtrimpricespan2', 'headboardtrimdiscountamtspan');
}

function setEditPageLegsDiscountSummary() {
	setEditPageComponentDiscountSummary('legprice', 'standardlegsprice', 'standardlegspricespan2', 'legsdiscountamtspan');
}

function setEditPageAddLegsDiscountSummary() {
	setEditPageComponentDiscountSummary('addlegprice', 'standardaddlegsprice', 'standardaddlegspricespan2', 'addlegsdiscountamtspan');
}

function setEditPageValanceDiscountSummary() {
	setEditPageComponentDiscountSummary('valanceprice', 'standardvalanceprice', 'standardvalancepricespan2', 'valancediscountamtspan');
}

function setEditPageComponentDiscountSummary(srcPriceFieldId, srcStdPriceFieldId, trgStdPriceSpanId, trgDiscountAmtSpanId) {
	
	if (!isPriceMatrixEnabled()) {
		trace("Price matrix disabled. setEditPageComponentDiscountSummary doing nothing");
		return;
	}
	trace(trgStdPriceSpanId + " exists = " + $('#' + trgStdPriceSpanId).length);

	if ($('#' + trgStdPriceSpanId).length) { // just in case this is called on the new order pages
		var price = $('#' + srcPriceFieldId).val() / 1.0;
		var stdPrice = $('#' + srcStdPriceFieldId).val() / 1.0;
		var discountAmt = stdPrice - price;
		if (discountAmt < 0.0) discountAmt = 0.0;
		trace("srcPriceFieldId=" + srcPriceFieldId);
		trace("price=" + price);
		trace("stdPrice=" + stdPrice);
		trace("discountAmt=" + discountAmt);
		$('#' + trgStdPriceSpanId).html(stdPrice.toFixed(2));
		$('#' + trgDiscountAmtSpanId).html(discountAmt.toFixed(2));
		redisplaySummary(true);
	} 
}

function resetPriceField(priceFieldId, compId) {
	if (!isComponentRequired(compId)) {
		$('#' + priceFieldId).val("0.0");
	}
}

