<%
dim isHpsAddOrder, hpsDiscountObj, hpsDummyDiscountObj, hpsPrice

set hpsDummyDiscountObj = new CompPriceDiscount
hpsDummyDiscountObj.discounttype="percent"
hpsDummyDiscountObj.standardPrice = 0.0
hpsDummyDiscountObj.discount = 0.0
hpsDummyDiscountObj.price = 0.0

isHpsAddOrder = (scriptname="/add-order.asp")
%>
<div id="hbsum" style="float:left; width:94%;">
<p><strong>Headboard Price Summary</strong></p>
<!-- headboard prices summary table start -->
<table width="100%" border="0" cellpadding="3" cellspacing="3" class="xview">

<!-- fabric price -->
<%
if isHpsAddOrder then
	hpsPrice = request("hbfabricprice")
else
	hpsPrice = rs("hbfabricprice")
end if
%>
<tr class="headboardsummary15">
	<td colspan="4" >&nbsp;</td>

	<td width="40%" align="right">
		Fabric Price Total
		<span class="cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
		<label><input name="hbfabricprice" value="<%=fmtCurr2(hpsPrice, false, orderCurrency)%>" type="text" class="xview" id="hbfabricprice" size="10"></label>
	</td>
</tr>

<!-- trim (compId=10) -->
<%
if isHpsAddOrder then
	bpsPrice = request("headboardtrimprice")
	set hpsDiscountObj = hpsDummyDiscountObj
else
	bpsPrice = rs("headboardtrimprice")
	set hpsDiscountObj = headboardTrimDiscountObj
end if
%>
<tr class="headboardsummary10" style="display: none;">
	<td width="17%" ><span class="headboardtrimdiscountcls">
		List Price: <%= getCurrencySymbolForCurrency(orderCurrency) %>
		<span id="standardheadboardtrimpricespan"><%=fmtCurr2(hpsDiscountObj.standardPrice, false, orderCurrency)%></span>
		<input type="hidden" name="standardheadboardtrimprice" id="standardheadboardtrimprice" value="<%=hpsDiscountObj.standardPrice%>" onchange="setHeadboardTrimPrice();" />
	</span></td>

	<td><span class="headboardtrimdiscountcls">
		DC: %
		<input type="radio" name="headboardtrimdiscounttype" id="headboardtrimdiscounttype1" value="percent" <%=ischecked2(hpsDiscountObj.discountType="percent")%> onchange="setHeadboardTrimPrice(); setEditPageHeadboardTrimDiscountSummary();" />
		&nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %>
		<input type="radio" name="headboardtrimdiscounttype" id="headboardtrimdiscounttype2" value="currency" <%=ischecked2(hpsDiscountObj.discountType="currency")%> onchange="setHeadboardTrimPrice(); setEditPageHeadboardTrimDiscountSummary();" />
		&nbsp;
		<input name="headboardtrimdiscount" value="<%=fmtCurr2(hpsDiscountObj.discount, false, orderCurrency)%>" type="text" id="headboardtrimdiscount" size="10" onchange="setHeadboardTrimPrice(); setEditPageHeadboardTrimDiscountSummary();" />
	</span></td>

	<td colspan="2" >&nbsp;</td>

	<td width="40%" align="right">
		Trim
		<span class="cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
		<label><input name="headboardtrimprice" value="<%=fmtCurr2(bpsPrice, false, orderCurrency)%>" type="text" id="headboardtrimprice" size="10" onchange="setHeadboardTrimDiscount();"></label>
	</td>
</tr>

<!-- the headboard itself (compId=3) -->
<%
if isHpsAddOrder then
	hpsPrice = request("headboardprice")
	set hpsDiscountObj = hpsDummyDiscountObj
else
	hpsPrice = rs("headboardprice")
	set hpsDiscountObj = headboardDiscountObj
end if
%>
<tr>
	<td width="17%" ><span class="headboarddiscountcls">
		List Price: <%= getCurrencySymbolForCurrency(orderCurrency) %><span id="standardheadboardpricespan"><%=fmtCurr2(hpsDiscountObj.standardPrice, false, orderCurrency)%></span>
		<input type="hidden" name="standardheadboardprice" id="standardheadboardprice" value="<%=hpsDiscountObj.standardPrice%>" onchange="setHeadboardPrice();" />
	</span></td>
	<td><span class="headboarddiscountcls">
		DC: %
		<input type="radio" name="headboarddiscounttype" id="headboarddiscounttype1" value="percent" <%=ischecked2(hpsDiscountObj.discountType="percent")%> onchange="setHeadboardPrice(); setEditPageHeadboardDiscountSummary();" />
		&nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %>
		<input type="radio" name="headboarddiscounttype" id="headboarddiscounttype2" value="currency" <%=ischecked2(hpsDiscountObj.discountType="currency")%> onchange="setHeadboardPrice(); setEditPageHeadboardDiscountSummary();" />
		&nbsp;
		<input name="headboarddiscount" value="<%=fmtCurr2(hpsDiscountObj.discount, false, orderCurrency)%>" type="text" id="headboarddiscount" size="10" onchange="setHeadboardPrice(); setEditPageHeadboardDiscountSummary();" />
	</span></td>

	<td colspan="2" >&nbsp;</td>

	<td width="40%" align="right">
		Headboard
		<span class="cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
		<label>
		<input name="headboardprice" value="<%=fmtCurr2(hpsPrice, false, orderCurrency)%>" type="text" id="headboardprice" size="10" onchange="setHeadboardDiscount();" />
		</label>
	</td>
</tr>

<!-- total headboard price -->
<tr>
	<td colspan="4" >&nbsp;</td>

	<td width="40%" align="right">
		<strong>Total Headboard Price</strong>
		<span class="cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
		<label><input name="totalheadboardprice" type="text" class="xview" id="totalheadboardprice" size="10" readonly="true" ></label>
	</td>
</tr>

</table>
<!-- headboard prices summary table end -->
</div>
<%if Request.ServerVariables("path_info")="/edit-purchase.asp" then%>
<div class="showWholesale">
<table width="30%" border="0" align="right" cellpadding="3" cellspacing="3" class="xview bordergris" style="float:right">
<tr><td colspan="2"><b>Wholesale Pricing</b></td></tr>
<tr><td width="51%" align="right">Fabric Price Per Metre</td>
<td width="49%" align="left">
<span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
<%sql = "Select * from wholesale_prices WHERE Purchase_No=" & order & " and componentID=15"
Set rs4 = getMysqlQueryRecordSet(sql, con)
if not rs4.eof then

WHBFabricprice=rs4("price")
end if
rs4.close
set rs4=nothing%>

<input name = "WHBFabricprice" type = "text"
id = "WHBFabricprice"

value = "<%=WHBFabricprice%>" size = "10"
/></td></tr>
<tr class="showTrimWholesale"><td align="right">Trim</td>
<td align="left">
<span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
<%sql = "Select * from wholesale_prices WHERE Purchase_No=" & order & " and componentID=10"
Set rs4 = getMysqlQueryRecordSet(sql, con)
if not rs4.eof then

WHBTrimprice=rs4("price")
end if
rs4.close
set rs4=nothing
%>

<input name = "WHBTrimprice" type = "text"
id = "WHBTrimprice"

value = "<%=WHBTrimprice%>" size = "10"
/></td></tr>
<tr><td align="right">Headboard</td>
<td align="left">
<span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
<%sql = "Select * from wholesale_prices WHERE Purchase_No=" & order & " and componentID=8"
Set rs4 = getMysqlQueryRecordSet(sql, con)
if not rs4.eof then

WHBprice=rs4("price")
end if
rs4.close
set rs4=nothing%>

<input name = "WHBprice" type = "text"
id = "WHBprice"

value = "<%=WHBprice%>" size = "10"
/></td></tr>
</table>
</div>
<%end if%>
<script>
	$("#hbfabricprice").change(function(){
    	trace("hbfabricprice changed");
    	calcTotalHeadboardPrice();
	});

	$("#headboardprice").change(function(){
    	calcTotalHeadboardPrice();
	});

	$("#headboardtrimprice").change(function(){
    	calcTotalHeadboardPrice();
	});
	
	$("#WHBFabricprice").change(function(){
    	trace("WHBFabricprice changed");
    	calcTotalWholesaleHeadboardPrice();
	});

	$("#WHBprice").change(function(){
    	calcTotalWholesaleHeadboardPrice();
	});

	$("#WHBTrimprice").change(function(){
    	calcTotalWholesaleHeadboardPrice();
	});


	function calcTotalHeadboardPrice() {
		var price = 0.0;
		price = price + $('#hbfabricprice').val() / 1.0;
		price = price + $('#headboardprice').val() / 1.0;
		price = price + $('#headboardtrimprice').val() / 1.0;
		$('#totalheadboardprice').val(price.toFixed(2));
	}
	
	function calcTotalWholesaleHeadboardPrice() {
		var price = 0.0;
		price = price + $('#WHBFabricprice').val() / 1.0;
		price = price + $('#WHBprice').val() / 1.0;
		price = price + $('#WHBTrimprice').val() / 1.0;
		$('#Wtotalheadboardprice').val(price.toFixed(2));
	}
	
	function showHideHeadboardPriceSummaryRow(compId) {
		trace("showHideHeadboardPriceSummaryRow: compId=" + compId);
		if (isComponentRequired(compId)) {
			$('.headboardsummary'+compId).show();
		} else {
			$('.headboardsummary'+compId).hide();
		}
	}
</script>