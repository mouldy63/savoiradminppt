function getAllListPrices() {
	if (isComponentRequired(1)) {
		getMattressListPrice();
	}

	if (isComponentRequired(3)) {
		getBaseListPrice();
	}

	if (isComponentRequired(5)) {
		getTopperListPrice();
	}

	if (isComponentRequired(8)) {
		getHeadboardListPrice();
	}
	
	if (isComponentRequired(7)) {
		getLegsListPrice();
	}

	if (isComponentRequired(16)) {
		getAddLegsListPrice();
	}

	if (isComponentRequired(6)) {
		getValanceListPrice();
	}

	if (isComponentRequired(12)) {
		// upholstered base
		getBaseUpholsteryListPrice();
	}

	if (isComponentRequired(11)) {
		// base trim
		getBaseTrimListPrice();
	}

	if (isComponentRequired(13)) {
		// base drawers
		getBaseDrawersListPrice();
	}

	if (isComponentRequired(10)) {
		// headboard trim
		getHeadboardTrimListPrice();
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

function getMattressListPrice() {
	var model = $("#savoirmodel option:selected").val();
	var width = $("#mattresswidth option:selected").val();
	var length = $("#mattresslength option:selected").val();
	var stdPrice = getListPriceForComponent(1, model, width, length, '', '', '', 1.0);
	console.log("getMattressListPrice = " + stdPrice);
	
	if (stdPrice == -1 && $('.mattressdiscountcls').is(':visible')) {
		$("#mattressprice").val(''); // clear out any previous price, so long as it's a price matrix price
	}
	
	updateListPriceFields(stdPrice, 'mattresslistpricespan', 'mattresslistprice', setEditPageMattressDiscountSummary, 'mattressdiscountcls');
}

function getBaseListPrice() {
	var model = $("#basesavoirmodel option:selected").val();
	var width = $("#basewidth option:selected").val();
	var length = $("#baselength option:selected").val();
	var stdPrice = getListPriceForComponent(3, model, width, length, '', '', '', 1.0);
	console.log("getBaseListPrice = " + stdPrice);

	if (stdPrice == -1 && $('.basediscountcls').is(':visible')) {
		$("#baseprice").val(''); // clear out any previous price,  so long as it's a price matrix price
		calcTotalBasePrice();
	}

	updateListPriceFields(stdPrice, 'baselistpricespan', 'baselistprice', setEditPageBaseDiscountSummary, 'basediscountcls');
}

function getBaseUpholsteryListPrice() {
	var stdPrice = 0.0;
	if (isComponentRequired(12)) {
		var model = $("#basesavoirmodel option:selected").val();
		if (model != "No. 1") {
			// Horrible fudge for free base trim with No. 1 bases. Not able to use compIdSet1 to base basesavoirmodel to getListPriceForComponent, as that would make the trim
			// free for all base models. Need to extend getListPriceForComponent to include the value selected for the base model - a lot of work!
			stdPrice = getListPriceForComponent(12, 'Base Upholstery', '', '', '', '', '', 1.0);
		}
	}
	
	if (stdPrice == -1 && $('.upholsterydiscountcls').is(':visible')) {
		$("#upholsteryprice").val(''); // clear out any previous price,  so long as it's a price matrix price
		calcTotalBasePrice();
	}

	updateListPriceFields(stdPrice, 'upholsterylistpricespan', 'upholsterylistprice', setEditPageBaseUpholsteryDiscountSummary, 'upholsterydiscountcls');
}

function getBaseTrimListPrice() {
	var option = $("#basetrim option:selected").val();
	var stdPrice = 0.0;
	if (isComponentRequired(11)) {
		var model = $("#basesavoirmodel option:selected").val();
		if (model != "No. 1") {
			// Horrible fudge for free base trim with No. 1 bases. Not able to use compIdSet1 to base basesavoirmodel to getListPriceForComponent, as that would make the trim
			// free for all base models. Need to extend getListPriceForComponent to include the value selected for the base model - a lot of work!
			stdPrice = getListPriceForComponent(11, 'Base Trim', option, '', '', '', '', 1.0);
		}
	}

	if (stdPrice == -1 && $('.basetrimdiscountcls').is(':visible')) {
		$("#basetrimprice").val(''); // clear out any previous price, so long as it's a price matrix price
		calcTotalBasePrice();
	}
	
	updateListPriceFields(stdPrice, 'basetrimlistpricespan', 'basetrimlistprice', setEditPageBaseTrimDiscountSummary, 'basetrimdiscountcls');
}

function getBaseDrawersListPrice() {
	var option = $("#drawerconfig option:selected").val();
	var stdPrice = 0.0;
	if (isComponentRequired(13)) {
		stdPrice = getListPriceForComponent(13, 'Base Drawers', option, '', '', '', '', 1.0);
	}

	if (stdPrice == -1 && $('.basedrawersdiscountcls').is(':visible')) {
		$("#basedrawersprice").val(''); // clear out any previous price, so long as it's a price matrix price
		calcTotalBasePrice();
	}
	
	updateListPriceFields(stdPrice, 'basedrawerslistpricespan', 'basedrawerslistprice', setEditPageBaseDrawersDiscountSummary, 'basedrawersdiscountcls');
}

function getTopperListPrice() {
	var type = $("#toppertype option:selected").val();
	var width = $("#topperwidth option:selected").val();
	var length = $("#topperlength option:selected").val();
	var compIdSet1 = "";
	var compIdSet2 = "";
	if (isComponentRequired(1)) {
		compIdSet1 = "1";
	}
	var stdPrice = getListPriceForComponent(5, type, width, length, '', compIdSet1, compIdSet2, 1.0);

	if (stdPrice == -1 && $('.topperdiscountcls').is(':visible')) {
		$("#topperprice").val(''); // clear out any previous price, so long as it's a price matrix price
	}
	
	updateListPriceFields(stdPrice, 'topperlistpricespan', 'topperlistprice', setEditPageTopperDiscountSummary, 'topperdiscountcls');
}

function getHeadboardListPrice() {
	var type = $("#headboardstyle option:selected").val();
	var width = "";
	var length = "";
	var compIdSet1 = "";
	var compIdSet2 = "";
	var stdPrice = getListPriceForComponent(8, type, width, length, '', compIdSet1, compIdSet2, 1.0);
	//console.log("getHeadboardListPrice = " + stdPrice);
	
	if (stdPrice == -1 && $('.headboarddiscountcls').is(':visible')) {
		$("#headboardprice").val(''); // clear out any previous price, so long as it's a price matrix price
		calcTotalHeadboardPrice();
	}
	
	updateListPriceFields(stdPrice, 'headboardlistpricespan', 'headboardlistprice', setEditPageHeadboardDiscountSummary, 'headboarddiscountcls');
}

function getHeadboardTrimListPrice() {
	var option = $("#headboardstyle").val();
	console.log("getHeadboardTrimListPrice: hbstyle=" + option);
	var stdPrice = 0.0;
	if (isComponentRequired(10)) {
		stdPrice = getListPriceForComponent(10, 'Manhattan Trim', option, '', '', '', '', 1.0);
	}

	if (stdPrice == -1 && $('.headboardtrimdiscountcls').is(':visible')) {
		$("#headboardtrimprice").val(''); // clear out any previous price, so long as it's a price matrix price
		calcTotalHeadboardPrice();
	}
	
	updateListPriceFields(stdPrice, 'headboardtrimlistpricespan', 'headboardtrimlistprice', setEditPageHeadboardTrimDiscountSummary, 'headboardtrimdiscountcls');
}

function getLegsListPrice() {
	var legCount = $("#legqty").val();
	var legFinish = $("#legfinish").val();
	var type = $("#legstyle").val();
	console.log("legfinish=" + legFinish);
	console.log("type=" + type);
	var compIdSet1 = "";
	var compIdSet2 = "";
	
	var freeLegs = false;
	if (legCount == 0) {
		console.log("getLegsListPrice: legCount=0, so set price to 0.0");
		freeLegs = true;
	} else if (isComponentRequired(3)) {
		if (type=='Castors' || type=='Metal') {
			console.log("getLegsListPrice: free legs with base when type = " + type);
			freeLegs = true;
		} else if (type=='Wooden Tapered') {
			var finish = $("#legfinish").val();
			if (finish != 'Natural Maple') {
				console.log("getLegsListPrice: free legs with base when type = " + type + " & finish " + finish);
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
		stdPrice = getListPriceForComponent(7, type, legFinish, '', '', compIdSet1, compIdSet2, legCount);
	}

	if (stdPrice == -1 && $('.legsdiscountcls').is(':visible')) {
		$("#legprice").val(''); // clear out any previous price, so long as it's a price matrix price
	}
	
	updateListPriceFields(stdPrice, 'legslistpricespan', 'legslistprice', setEditPageLegsDiscountSummary, 'legsdiscountcls');
}

function getAddLegsListPrice() {
	var type = $("#addlegstyle option:selected").val();
	var addLegCount = $("#addlegqty option:selected").val();
	console.log("addlegstyle=" + type);
	console.log("addLegCount=" + addLegCount);
	var compIdSet1 = "";
	var compIdSet2 = "";
	var stdPrice = getListPriceForComponent(16, type, '', '', '', compIdSet1, compIdSet2, addLegCount);

	if (stdPrice == -1 && $('.addlegsdiscountcls').is(':visible')) {
		$("#addlegsprice").val(''); // clear out any previous price, so long as it's a price matrix price
	}
	
	updateListPriceFields(stdPrice, 'addlegslistpricespan', 'addlegslistprice', setEditPageAddLegsDiscountSummary, 'addlegsdiscountcls');
}

function getValanceListPrice() {
	var type = "Valance";
	var width = "";
	var length = "";
	var compIdSet1 = "";
	var compIdSet2 = "";
	var stdPrice = getListPriceForComponent(6, type, width, length, '', compIdSet1, compIdSet2, 1.0);

	if (stdPrice == -1 && $('.valancediscountcls').is(':visible')) {
		$("#valanceprice").val(''); // clear out any previous price, so long as it's a price matrix price
	}
	
	updateListPriceFields(stdPrice, 'valancelistpricespan', 'valancelistprice', setEditPageValanceDiscountSummary, 'valancediscountcls');
}

function getListPriceForComponent(compId, type, dim1, dim2, dim3, compIdSet1, compIdSet2, multiplier) {
	if (!isPriceMatrixEnabled()) {
		console.log("Price matrix disabled. getListPriceForComponent doing nothing");
		return;
	}
	
	var curr = $("#currency").val();
	var url = "PriceMatrixData/getMatrixPrice?compid=" + compId + "&type=" + encodeURI(type).replace('&', '%26') + "&dim1=" + encodeURI(dim1) + "&dim2=" + encodeURI(dim2) + "&dim3=" + encodeURI(dim3) + "&curr=" + curr + "&multiplier=" + encodeURI(multiplier);
	
	if (compIdSet1 != '') {
		url += "&compidset1=" + compIdSet1;
	}

	if (compIdSet2 != '') {
		url += "&compidset2=" + compIdSet2;
	}

	if (isTrade()) {
		url += "&trade=y&vatrate=" + getVatRate();
	}
	
	url += "&ts=" + (new Date()).getTime();
	console.log(url);

	return $.ajax({
        type: "GET",
        url: url,
        async: false
    }).responseText;
}

function updateListPriceFields(stdPrice, divId, fieldId, callback, hideShowCls) {

	if (!isPriceMatrixEnabled()) {
		console.log("Price matrix disabled. updateListPriceFields doing nothing");
		return;
	}

	//console.log("divId = " + divId);
	//console.log("fieldId = " + fieldId);
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
	//console.log("hideShowCls=" + hideShowCls);
	if (hideShowCls != "") {
		console.log("stdPrice = " + stdPrice);
		if (stdPrice > -1.0) {
			//console.log("show " + hideShowCls + " hide " + hideShowCls + '_dummy');
			$('.'+hideShowCls).show();
			$('.'+hideShowCls+'_dummy').hide();
		} else {
			//console.log("hide " + hideShowCls + " show " + hideShowCls + '_dummy');
			$('.'+hideShowCls).hide();
			$('.'+hideShowCls+'_dummy').show();
		}
	}
}

function setMattressPrice() {
	setComponentPrice('mattressdiscounttype1', 'mattressdiscount', 'mattresslistprice', 'mattressprice');
}

function setTopperPrice() {
	setComponentPrice('topperdiscounttype1', 'topperdiscount', 'topperlistprice', 'topperprice');
}

function setBasePrice() {
	setComponentPrice('basediscounttype1', 'basediscount', 'baselistprice', 'baseprice');
	if (typeof calcTotalBasePrice !== 'undefined' && $.isFunction(calcTotalBasePrice)) {
		// if the function exists (is available in add-order & edit-purchase), call calcTotalBasePrice to set the info only total base price field
		calcTotalBasePrice();
	}
}

function setBaseTrimPrice() {
	setComponentPrice('basetrimdiscounttype1', 'basetrimdiscount', 'basetrimlistprice', 'basetrimprice');
	if (typeof calcTotalBasePrice !== 'undefined' && $.isFunction(calcTotalBasePrice)) {
		// if the function exists (is available in add-order & edit-purchase), call calcTotalBasePrice to set the info only total base price field
		calcTotalBasePrice();
	}
}

function setBaseDrawersPrice() {
	setComponentPrice('basedrawersdiscounttype1', 'basedrawersdiscount', 'basedrawerslistprice', 'basedrawersprice');
	if (typeof calcTotalBasePrice !== 'undefined' && $.isFunction(calcTotalBasePrice)) {
		// if the function exists (is available in add-order & edit-purchase), call calcTotalBasePrice to set the info only total base price field
		calcTotalBasePrice();
	}
}

function setBaseFabricPrice() {
	setComponentPrice('basefabricdiscounttype1', 'basefabricdiscount', 'basefabriclistprice', 'basefabricprice');
	if (typeof calcTotalBasePrice !== 'undefined' && $.isFunction(calcTotalBasePrice)) {
		// if the function exists (is available in add-order & edit-purchase), call calcTotalBasePrice to set the info only total base price field
		calcTotalBasePrice();
	}
}

function setBaseUpholsteryPrice() {
	setComponentPrice('upholsterydiscounttype1', 'upholsterydiscount', 'upholsterylistprice', 'upholsteryprice');
	if (typeof calcTotalBasePrice !== 'undefined' && $.isFunction(calcTotalBasePrice)) {
		// if the function exists (is available in add-order & edit-purchase), call calcTotalBasePrice to set the info only total base price field
		calcTotalBasePrice();
	}
}

function setHeadboardPrice() {
	setComponentPrice('headboarddiscounttype1', 'headboarddiscount', 'headboardlistprice', 'headboardprice');
	if (typeof calcTotalHeadboardPrice !== 'undefined' && $.isFunction(calcTotalHeadboardPrice)) {
		// if the function exists (is available in add-order & edit-purchase), call calcTotalHeadboardPrice to set the info only total base price field
		calcTotalHeadboardPrice();
	}
}

function setHeadboardTrimPrice() {
	setComponentPrice('headboardtrimdiscounttype1', 'headboardtrimdiscount', 'headboardtrimlistprice', 'headboardtrimprice');
	if (typeof calcTotalHeadboardPrice !== 'undefined' && $.isFunction(calcTotalHeadboardPrice)) {
		// if the function exists (is available in add-order & edit-purchase), call calcTotalHeadboardPrice to set the info only total headboard price field
		calcTotalHeadboardPrice();
	}
}

function setLegsPrice() {
	setComponentPrice('legsdiscounttype1', 'legsdiscount', 'legslistprice', 'legprice');
}

function setAddLegsPrice() {
	setComponentPrice('addlegsdiscounttype1', 'addlegsdiscount', 'addlegslistprice', 'addlegsprice');
}

function setValancePrice() {
	setComponentPrice('valancediscounttype1', 'valancediscount', 'valancelistprice', 'valanceprice');
}

function setComponentPrice(pcFieldId, dcFieldId, stdPriceFieldId, priceFieldId) {
	//'mattressdiscounttype1', 'mattressdiscount', 'mattresslistprice', 'mattressprice'
	
	if (!isPriceMatrixEnabled()) {
		console.log("Price matrix disabled. setComponentPrice doing nothing");
		return;
	}

	var isPercent = $('#' + pcFieldId).is(':checked');
	var discount = $('#' + dcFieldId).val() / 1.0;
	var stdPrice = $('#' + stdPriceFieldId).val() / 1.0;
	var price = 0.0;
	if (stdPrice > -1.0) {
		if (isPercent) {
			price = stdPrice * (1.0 - discount / 100.0);
		} else {
			price = stdPrice - discount;
		}
	}
	
	if (price > -1.0) {
		$('#' + priceFieldId).val(price.toFixed(2));
	}
}

function setMattressDiscount() {
	setComponentDiscount('mattressdiscounttype1', 'mattressdiscount', 'mattresslistprice', 'mattressprice');
}

function setTopperDiscount() {
	setComponentDiscount('topperdiscounttype1', 'topperdiscount', 'topperlistprice', 'topperprice');
}

function setBaseDiscount() {
	setComponentDiscount('basediscounttype1', 'basediscount', 'baselistprice', 'baseprice');
}

function setBaseTrimDiscount() {
	setComponentDiscount('basetrimdiscounttype1', 'basetrimdiscount', 'basetrimlistprice', 'basetrimprice');
}

function setBaseDrawersDiscount() {
	setComponentDiscount('basedrawersdiscounttype1', 'basedrawersdiscount', 'basedrawerslistprice', 'basedrawersprice');
}

function setBaseFabricDiscount() {
	setComponentDiscount('basefabricdiscounttype1', 'basefabricdiscount', 'basefabriclistprice', 'basefabricprice');
}

function setBaseUpholsteryDiscount() {
	setComponentDiscount('upholsterydiscounttype1', 'upholsterydiscount', 'upholsterylistprice', 'upholsteryprice');
}

function setHeadboardDiscount() {
	setComponentDiscount('headboarddiscounttype1', 'headboarddiscount', 'headboardlistprice', 'headboardprice');
}

function setHeadboardTrimDiscount() {
	setComponentDiscount('headboardtrimdiscounttype1', 'headboardtrimdiscount', 'headboardtrimlistprice', 'headboardtrimprice');
}

function setLegsDiscount() {
	setComponentDiscount('legsdiscounttype1', 'legsdiscount', 'legslistprice', 'legprice');
}

function setAddLegsDiscount() {
	setComponentDiscount('addlegsdiscounttype1', 'addlegsdiscount', 'addlegslistprice', 'addlegsprice');
}

function setValanceDiscount() {
	setComponentDiscount('valancediscounttype1', 'valancediscount', 'valancelistprice', 'valanceprice');
}

function setComponentDiscount(pcFieldId, dcFieldId, stdPriceFieldId, priceFieldId) {

	if (!isPriceMatrixEnabled()) {
		console.log("Price matrix disabled. setComponentDiscount doing nothing");
		return;
	}

	var isPercent = $('#' + pcFieldId).is(':checked');
	var price = $('#' + priceFieldId).val() / 1.0;
	var stdPrice = $('#' + stdPriceFieldId).val() / 1.0;
	//console.log("setComponentDiscount: priceFieldId=" + priceFieldId);
	//console.log("setComponentDiscount: isPercent=" + isPercent);
	//console.log("setComponentDiscount: price=" + price);
	//console.log("setComponentDiscount: stdPrice=" + stdPrice);
	var discount = 0.0;
	if (stdPrice > 0.0) {
		if (isPercent) {
			discount = 100.0 * (1.0 - price / stdPrice);
			//console.log("setComponentDiscount: % discount=" + discount);
		} else {
			discount = stdPrice - price;
			//console.log("setComponentDiscount: � discount=" + discount);
		}
	}
	
	if (discount > 0.0) {
		$('#' + dcFieldId).val(discount.toFixed(2));
	}
}

function setMattressDiscountAmt() {
	setComponentDiscountAmt('mattressdiscountamt', 'mattresslistprice', 'mattressprice');
}

function setTopperDiscountAmt() {
	setComponentDiscountAmt('topperdiscountamt', 'topperlistprice', 'topperprice');
}

function setBaseDiscountAmt() {
	setComponentDiscountAmt('basediscountamt', 'baselistprice', 'baseprice');
}

function setBaseTrimDiscountAmt() {
	setComponentDiscountAmt('basetrimdiscountamt', 'basetrimlistprice', 'basetrimprice');
}

function setBaseDrawersDiscountAmt() {
	setComponentDiscountAmt('basedrawersdiscountamt', 'basedrawerslistprice', 'basedrawersprice');
}

function setBaseFabricDiscountAmt() {
	setComponentDiscountAmt('basefabricdiscountamt', 'basefabriclistprice', 'basefabricprice');
}

function setBaseUpholsteryDiscountAmt() {
	setComponentDiscountAmt('upholsterydiscountamt', 'upholsterylistprice', 'upholsteryprice');
}

function setHeadboardDiscountAmt() {
	setComponentDiscountAmt('headboarddiscountamt', 'headboardlistprice', 'headboardprice');
}

function setHeadboardTrimDiscountAmt() {
	setComponentDiscountAmt('headboardtrimdiscountamt', 'headboardtrimlistprice', 'headboardtrimprice');
}

function setLegsDiscountAmt() {
	setComponentDiscountAmt('legsdiscountamt', 'legslistprice', 'legprice');
}

function setAddLegsDiscountAmt() {
	setComponentDiscountAmt('addlegsdiscountamt', 'addlegslistprice', 'addlegsprice');
}

function setValanceDiscountAmt() {
	setComponentDiscountAmt('valancediscountamt', 'valancelistprice', 'valanceprice');
}

function setComponentDiscountAmt(amtFieldId, stdPriceFieldId, priceFieldId) {

	if (!isPriceMatrixEnabled()) {
		console.log("Price matrix disabled. setComponentDiscountAmt doing nothing");
		return;
	}
	
	var price = $('#' + priceFieldId).val() / 1.0;
	var stdPrice = $('#' + stdPriceFieldId).val() / 1.0;
	var discountAmt = stdPrice - price;
	if (discountAmt < 0.0) discountAmt = 0.0;
	//console.log("setComponentDiscountAmt: price=" + price);
	//console.log("setComponentDiscountAmt: stdPrice=" + stdPrice);
	//console.log("setComponentDiscountAmt: discountAmt=" + discountAmt);
	
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
	setEditPageComponentDiscountSummary('mattressprice', 'mattresslistprice', 'mattresslistpricespan2', 'mattressdiscountamtspan');
}

function setEditPageBaseDiscountSummary() {
	setEditPageComponentDiscountSummary('baseprice', 'baselistprice', 'baselistpricespan2', 'basediscountamtspan');
}

function setEditPageBaseFabricDiscountSummary() {
	setEditPageComponentDiscountSummary('basefabricprice', 'basefabriclistprice', 'basefabriclistpricespan2', 'basefabricdiscountamtspan');
}

function setEditPageBaseUpholsteryDiscountSummary() {
	setEditPageComponentDiscountSummary('upholsteryprice', 'upholsterylistprice', 'upholsterylistpricespan2', 'upholsterydiscountamtspan');
}

function setEditPageBaseTrimDiscountSummary() {
	setEditPageComponentDiscountSummary('basetrimprice', 'basetrimlistprice', 'basetrimlistpricespan2', 'basetrimdiscountamtspan');
}

function setEditPageBaseDrawersDiscountSummary() {
	setEditPageComponentDiscountSummary('basedrawersprice', 'basedrawerslistprice', 'basedrawerslistpricespan2', 'basedrawersdiscountamtspan');
}

function setEditPageTopperDiscountSummary() {
	setEditPageComponentDiscountSummary('topperprice', 'topperlistprice', 'topperlistpricespan2', 'topperdiscountamtspan');
}

function setEditPageHeadboardDiscountSummary() {
	setEditPageComponentDiscountSummary('headboardprice', 'headboardlistprice', 'headboardlistpricespan', 'headboarddiscountamtspan');
}

function setEditPageHeadboardTrimDiscountSummary() {
	setEditPageComponentDiscountSummary('headboardtrimprice', 'headboardtrimlistprice', 'headboardtrimlistpricespan2', 'headboardtrimdiscountamtspan');
}

function setEditPageLegsDiscountSummary() {
	setEditPageComponentDiscountSummary('legprice', 'legslistprice', 'legslistpricespan2', 'legsdiscountamtspan');
}

function setEditPageAddLegsDiscountSummary() {
	setEditPageComponentDiscountSummary('addlegsprice', 'addlegslistprice', 'addlegslistpricespan2', 'addlegsdiscountamtspan');
}

function setEditPageValanceDiscountSummary() {
	setEditPageComponentDiscountSummary('valanceprice', 'valancelistprice', 'valancelistpricespan2', 'valancediscountamtspan');
}

function setEditPageComponentDiscountSummary(srcPriceFieldId, srcStdPriceFieldId, trgStdPriceSpanId, trgDiscountAmtSpanId) {
	
	if (!isPriceMatrixEnabled()) {
		console.log("Price matrix disabled. setEditPageComponentDiscountSummary doing nothing");
		return;
	}
	console.log(trgStdPriceSpanId + " exists = " + $('#' + trgStdPriceSpanId).length);

	if ($('#' + trgStdPriceSpanId).length) { // just in case this is called on the new order pages
		var price = $('#' + srcPriceFieldId).val() / 1.0;
		var stdPrice = $('#' + srcStdPriceFieldId).val() / 1.0;
		var discountAmt = stdPrice - price;
		if (discountAmt < 0.0) discountAmt = 0.0;
		console.log("srcPriceFieldId=" + srcPriceFieldId);
		console.log("price=" + price);
		console.log("stdPrice=" + stdPrice);
		console.log("discountAmt=" + discountAmt);
		$('#' + trgStdPriceSpanId).html(stdPrice.toFixed(2));
		$('#' + trgDiscountAmtSpanId).html(discountAmt.toFixed(2));
		//redisplaySummary(true);
	} 
}

function resetPriceField(priceFieldId, compId) {
	if (!isComponentRequired(compId)) {
		$('#' + priceFieldId).val("0.0");
	}
}

function isPriceMatrixEnabled() {
	var priceMatrixEnabledValue = $('#pricematrixenabled').val();
	return priceMatrixEnabledValue == 'y';
}

function isTrade() {
	var isTrade = $('#isTrade').val();
	return isTrade == 'y';
}

function getVatRate() {
	var vatRate = $('#vatrates').val();
	return vatRate;
}
