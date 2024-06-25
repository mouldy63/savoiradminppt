<%
dim isBpsAddOrder, bpsDiscountObj, bpsDummyDiscountObj, bpsPrice

set bpsDummyDiscountObj = new CompPriceDiscount
bpsDummyDiscountObj.discounttype="percent"
bpsDummyDiscountObj.standardPrice = 0.0
bpsDummyDiscountObj.discount = 0.0
bpsDummyDiscountObj.price = 0.0


isBpsAddOrder = (scriptname="/add-order.asp")
%>
<div class="clear"></div>
<div id="basesum" style="float:left; width:94%;">
<p><strong>Base Price Summary</strong></p>

<!-- base prices summary table start -->
<table width="100%" border="0"  cellpadding="3" cellspacing="3" class="xview">

<!-- fabric (compId=17) -->
<%
if isBpsAddOrder then
	bpsPrice = request("basefabricprice")
	set bpsDiscountObj = bpsDummyDiscountObj
else
	bpsPrice = rs("basefabricprice")
	set bpsDiscountObj = baseFabricDiscountObj
end if
%>
<tr class="basesummary17" style="display: none;">
	<td width="17%" ><span class="basefabricdiscountcls">
		Calculated Price: <%= getCurrencySymbolForCurrency(orderCurrency) %>
		<span id="standardbasefabricpricespan"><%=fmtCurr2(bpsDiscountObj.standardPrice, false, orderCurrency)%></span>
		<input type="hidden" name="standardbasefabricprice" id="standardbasefabricprice" value="<%=bpsDiscountObj.standardPrice%>" onchange="setBaseFabricPrice();" />
	</span></td>

	<td><span class="basefabricdiscountcls">
		DC: %
		<input type="radio" name="basefabricdiscounttype" id="basefabricdiscounttype1" value="percent" <%=ischecked2(bpsDiscountObj.discountType="percent")%> onchange="setBaseFabricPrice(); setEditPageBaseFabricDiscountSummary();" />
		&nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %>
		<input type="radio" name="basefabricdiscounttype" id="basefabricdiscounttype2" value="currency" <%=ischecked2(bpsDiscountObj.discountType="currency")%> onchange="setBaseFabricPrice(); setEditPageBaseFabricDiscountSummary()" />
		&nbsp;
		<input name="basefabricdiscount" value="<%=fmtCurr2(bpsDiscountObj.discount, false, orderCurrency)%>" type="text" id="basefabricdiscount" size="10" onchange="setBaseFabricPrice(); setEditPageBaseFabricDiscountSummary()" />
	</span></td>

	<td colspan="2" >&nbsp;</td>

	<td width="40%" align="right">
		Fabric Price Total
		<span class="cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
		<label><input name="basefabricprice" value="<%=fmtCurr2(bpsPrice, false, orderCurrency)%>" type="text" id="basefabricprice" size="10" onchange="setBaseFabricDiscount();" ></label>
	</td>
</tr>

<!-- upholstery (compId=12) -->
<%
if isBpsAddOrder then
	bpsPrice = request("upholsteryprice")
	set bpsDiscountObj = bpsDummyDiscountObj
else
	bpsPrice = rs("upholsteryprice")
	set bpsDiscountObj = baseUpholsteryDiscountObj
end if
%>
<tr class="basesummary12" style="display: none;">
	<td width="17%" ><span class="upholsterydiscountcls">
		List Price: <%= getCurrencySymbolForCurrency(orderCurrency) %>
		<span id="standardupholsterypricespan"><%=fmtCurr2(bpsDiscountObj.standardPrice, false, orderCurrency)%></span>
		<input type="hidden" name="standardupholsteryprice" id="standardupholsteryprice" value="<%=bpsDiscountObj.standardPrice%>" onchange="setBaseUpholsteryPrice();" />
	</span></td>

	<td><span class="upholsterydiscountcls">
		DC: %
		<input type="radio" name="upholsterydiscounttype" id="upholsterydiscounttype1" value="percent" <%=ischecked2(bpsDiscountObj.discountType="percent")%> onchange="setBaseUpholsteryPrice(); setEditPageBaseUpholsteryDiscountSummary();" />
		&nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %>
		<input type="radio" name="upholsterydiscounttype" id="upholsterydiscounttype2" value="currency" <%=ischecked2(bpsDiscountObj.discountType="currency")%> onchange="setBaseUpholsteryPrice(); setEditPageBaseUpholsteryDiscountSummary()" />
		&nbsp;
		<input name="upholsterydiscount" value="<%=fmtCurr2(bpsDiscountObj.discount, false, orderCurrency)%>" type="text" id="upholsterydiscount" size="10" onchange="setBaseUpholsteryPrice(); setEditPageBaseUpholsteryDiscountSummary()" />
	</span></td>

	<td colspan="2" >&nbsp;</td>

	<td width="40%" align="right">
		Upholstery
		<span class="cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
		<label><input name="upholsteryprice" value="<%=fmtCurr2(bpsPrice, false, orderCurrency)%>" type="text" id="upholsteryprice" size="10" onchange="setBaseUpholsteryDiscount();" ></label>
	</td>
</tr>

<!-- trim (compId=11) -->
<%
if isBpsAddOrder then
	bpsPrice = request("basetrimprice")
	set bpsDiscountObj = bpsDummyDiscountObj
else
	bpsPrice = rs("basetrimprice")
	set bpsDiscountObj = baseTrimDiscountObj
end if
%>
<tr class="basesummary11" style="display: none;">
	<td width="17%" ><span class="basetrimdiscountcls">
		List Price: <%= getCurrencySymbolForCurrency(orderCurrency) %>
		<span id="standardbasetrimpricespan"><%=fmtCurr2(bpsDiscountObj.standardPrice, false, orderCurrency)%></span>
		<input type="hidden" name="standardbasetrimprice" id="standardbasetrimprice" value="<%=bpsDiscountObj.standardPrice%>" onchange="setBaseTrimPrice();" />
	</span></td>

	<td><span class="basetrimdiscountcls">
		DC: %
		<input type="radio" name="basetrimdiscounttype" id="basetrimdiscounttype1" value="percent" <%=ischecked2(bpsDiscountObj.discountType="percent")%> onchange="setBaseTrimPrice(); setEditPageBaseTrimDiscountSummary();" />
		&nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %>
		<input type="radio" name="basetrimdiscounttype" id="basetrimdiscounttype2" value="currency" <%=ischecked2(bpsDiscountObj.discountType="currency")%> onchange="setBaseTrimPrice(); setEditPageBaseTrimDiscountSummary();" />
		&nbsp;
		<input name="basetrimdiscount" value="<%=fmtCurr2(bpsDiscountObj.discount, false, orderCurrency)%>" type="text" id="basetrimdiscount" size="10" onchange="setBaseTrimPrice(); setEditPageBaseTrimDiscountSummary();" />
	</span></td>

	<td colspan="2" >&nbsp;</td>

	<td width="40%" align="right">
		Trim
		<span class="cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
		<label><input name="basetrimprice" value="<%=fmtCurr2(bpsPrice, false, orderCurrency)%>" type="text" id="basetrimprice" size="10" onchange="setBaseTrimDiscount();"></label>
	</td>
</tr>

<!-- drawers (compId=13) -->
<%
if isBpsAddOrder then
	bpsPrice = request("basedrawersprice")
	set bpsDiscountObj = bpsDummyDiscountObj
else
	bpsPrice = rs("basedrawersprice")
	set bpsDiscountObj = baseDrawersDiscountObj
end if
%>
<tr class="basesummary13" style="display: none;">
	<td width="17%"><span class="basedrawersdiscountcls">
		List Price: <%= getCurrencySymbolForCurrency(orderCurrency) %><span id="standardbasedrawerspricespan"><%=fmtCurr2(bpsDiscountObj.standardPrice, false, orderCurrency)%></span>
		<input type="hidden" name="standardbasedrawersprice" id="standardbasedrawersprice" size="10" value="<%=bpsDiscountObj.standardPrice%>" onchange="setBaseDrawersPrice();" />
	</span></td>

	<td><span class="basedrawersdiscountcls">
		DC: %
		<input type="radio" name="basedrawersdiscounttype" id="basedrawersdiscounttype1" value="percent" <%=ischecked2(bpsDiscountObj.discountType="percent")%> onchange="setBaseDrawersPrice(); setEditPageBaseDrawersDiscountSummary();">
		&nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %>
		<input type="radio" name="basedrawersdiscounttype" id="basedrawersdiscounttype2" value="currency" <%=ischecked2(bpsDiscountObj.discountType="currency")%> onchange="setBaseDrawersPrice(); setEditPageBaseDrawersDiscountSummary();">
		&nbsp;
		<input name="basedrawersdiscount" value="<%=fmtCurr2(bpsDiscountObj.discount, false, orderCurrency)%>" type="text" id="basedrawersdiscount" size="10" onchange="setBaseDrawersPrice(); setEditPageBaseDrawersDiscountSummary();">
	</span></td>

	<td colspan="2" >&nbsp;</td>

	<td width="40%" align="right">
		Drawers
		<span class="cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>

		<label>
		<input name="basedrawersprice" value="<%=fmtCurr2(bpsPrice, false, orderCurrency)%>" type="text" id="basedrawersprice" size="10" onchange="setBaseDrawersDiscount();"></label>
	</td>
</tr>

<!-- the base itself (compId=3) -->
<%
if isBpsAddOrder then
	bpsPrice = request("baseprice")
	set bpsDiscountObj = bpsDummyDiscountObj
else
	bpsPrice = rs("baseprice")
	set bpsDiscountObj = baseDiscountObj
end if
%>
<tr>
	<td width="17%" ><span class="basediscountcls">
		List Price: <%= getCurrencySymbolForCurrency(orderCurrency) %><span id="standardbasepricespan"><%=fmtCurr2(bpsDiscountObj.standardPrice, false, orderCurrency)%></span>
		<input type="hidden" name="standardbaseprice" id="standardbaseprice" value="<%=bpsDiscountObj.standardPrice%>" onchange="setBasePrice();" />
	</span></td>
	<td><span class="basediscountcls">
		DC: %
		<input type="radio" name="basediscounttype" id="basediscounttype1" value="percent" <%=ischecked2(bpsDiscountObj.discountType="percent")%> onchange="setBasePrice(); setEditPageBaseDiscountSummary();" />
		&nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %>
		<input type="radio" name="basediscounttype" id="basediscounttype2" value="currency" <%=ischecked2(bpsDiscountObj.discountType="currency")%> onchange="setBasePrice(); setEditPageBaseDiscountSummary();" />
		&nbsp;
		<input name="basediscount" value="<%=fmtCurr2(bpsDiscountObj.discount, false, orderCurrency)%>" type="text" id="basediscount" size="10" onchange="setBasePrice(); setEditPageBaseDiscountSummary();" />
	</span></td>

	<td colspan="2" >&nbsp;</td>

	<td width="40%" align="right">
		Base
		<span class="cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
		<label>
		<input name="baseprice" value="<%=fmtCurr2(bpsPrice, false, orderCurrency)%>" type="text" id="baseprice" size="10" onchange="setBaseDiscount();" />
		</label>
	</td>
</tr>

<!-- total base price -->
<tr>
	<td colspan="4" >&nbsp;</td>

	<td width="40%" align="right">
		<strong>Total Base Price</strong>
		<span class="cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
		<label><input name="totalbaseprice" type="text" class="xview" id="totalbaseprice" size="10" readonly="true" ></label>
	</td>
</tr>

</table>
</div>
<!-- base prices summary table end -->
<%if Request.ServerVariables("path_info")="/edit-purchase.asp" then%>
<div class="showWholesale">
<table width="30%" border="0" align="right" cellpadding="3" cellspacing="3" class="xview bordergris" style="float:right">
<tr><td colspan="2" align="center"><b>Wholesale Pricing</b></td></tr>
<tr><td align="right">Fabric Price Per Metre</td>
<td align="left">
<span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
<%sql = "Select * from wholesale_prices WHERE Purchase_No=" & order & " and componentID=17"

Set rs4 = getMysqlQueryRecordSet(sql, con)
if not rs4.eof then

WBaseFabricprice=CDbl(rs4("price"))
end if
rs4.close
set rs4=nothing%>

<input name = "WBaseFabricprice" type = "text"
id = "WBaseFabricprice" value = "<%=WBaseFabricprice%>" size = "10"
/></td></tr>
<tr><td align="right">Upholstery</td>
<td align="left">
<span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
<%sql = "Select * from wholesale_prices WHERE Purchase_No=" & order & " and componentID=12"
Set rs4 = getMysqlQueryRecordSet(sql, con)
if not rs4.eof then

WBaseUphprice=CDbl(rs4("price"))
end if
rs4.close
set rs4=nothing%>

<input name = "WBaseUphprice" type = "text"
id = "WBaseUphprice"

value = "<%=WBaseUphprice%>" size = "10"
/></td></tr>
<tr id="showBaseTrimWholesale"><td align="right">Trim</td>
<td align="left">
<span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
<%sql = "Select * from wholesale_prices WHERE Purchase_No=" & order & " and componentID=11"
Set rs4 = getMysqlQueryRecordSet(sql, con)
if not rs4.eof then

WBaseTrimprice=CDbl(rs4("price"))
end if
rs4.close
set rs4=nothing%>

<input name = "WBaseTrimprice" type = "text"
id = "WBaseTrimprice"

value = "<%=WBaseTrimprice%>" size = "10"
class = "topper-field"
/></td></tr>
<tr id="showDrawerWholesale"><td align="right">Drawers</td>
<td align="left">
<span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
<%sql = "Select * from wholesale_prices WHERE Purchase_No=" & order & " and componentID=13"
Set rs4 = getMysqlQueryRecordSet(sql, con)
if not rs4.eof then

WBaseDrawerprice=CDbl(rs4("price"))
end if
rs4.close
set rs4=nothing%>

<input name = "WBaseDrawerprice" type = "text"
id = "WBaseDrawerprice"

value = "<%=WBaseDrawerprice%>" size = "10"
/></td></tr>

<tr><td align="right">Base</td>
<td align="left">
<span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
<%sql = "Select * from wholesale_prices WHERE Purchase_No=" & order & " and componentID=3"
Set rs4 = getMysqlQueryRecordSet(sql, con)
if not rs4.eof then

WBaseprice=CDbl(rs4("price"))
end if
rs4.close
set rs4=nothing%>

<input name = "WBaseprice" type = "text"
id = "WBaseprice"

value = "<%=WBaseprice%>" size = "10"
/></td></tr>

</table>
</div>

<%end if%>
<script>
	$("#basefabricprice").change(function(){
    	trace("basefabricprice changed");
    	calcTotalBasePrice();
	});
	
	$("#upholsteryprice").change(function(){
    	trace("upholsteryprice changed");
    	calcTotalBasePrice();
	});

	$("#basetrimprice").change(function(){
    	trace("basetrimprice changed");
    	calcTotalBasePrice();
	});

	$("#basedrawersprice").change(function(){
    	trace("basedrawersprice changed");
    	calcTotalBasePrice();
	});

	$("#baseprice").change(function(){
    	trace("baseprice changed");
    	calcTotalBasePrice();
	});
	
	$("#WBaseFabricprice").change(function(){
    	trace("WBaseFabricprice changed");
    	calcTotalWholesaleBasePrice();
	});
	
	$("#WBaseUphprice").change(function(){
    	trace("WBaseUphprice changed");
    	calcTotalWholesaleBasePrice();
	});

	$("#WBaseTrimprice").change(function(){
    	trace("WBaseTrimprice changed");
    	calcTotalWholesaleBasePrice();
	});

	$("#WBaseDrawerprice").change(function(){
    	trace("WBaseDrawerprice changed");
    	calcTotalWholesaleBasePrice();
	});

	$("#WBaseprice").change(function(){
    	trace("WBaseprice changed");
    	calcTotalWholesaleBasePrice();
	});

	function calcTotalBasePrice() {
		var price = 0.0;
		price = price + $('#basefabricprice').val() / 1.0;
		price = price + $('#upholsteryprice').val() / 1.0;
		price = price + $('#basetrimprice').val() / 1.0;
		price = price + $('#basedrawersprice').val() / 1.0;
		price = price + $('#baseprice').val() / 1.0;
		$('#totalbaseprice').val(price.toFixed(2));
	}
	
	function calcTotalWholesaleBasePrice() {
		var price = 0.0;
		price = price + $('#WBaseFabricprice').val() / 1.0;
		console.log('price=' + price);
		price = price + $('#WBaseUphprice').val() / 1.0;
		console.log('price=' + price);
		price = price + $('#WBaseTrimprice').val() / 1.0;
		console.log('price=' + price);
		price = price + $('#WBaseDrawerprice').val() / 1.0;
		console.log('price=' + price);
		price = price + $('#WBaseprice').val() / 1.0;
		console.log('price=' + price);
		$('#Wtotalbaseprice').val(price.toFixed(2));
		console.log('price=' + price);
	}
	
	function showHideBasePriceSummaryRow(compId) {
		trace("showHideBasePriceSummaryRow: compId=" + compId);
		if (isComponentRequired(compId)) {
			$('.basesummary'+compId).show();
		} else {
			$('.basesummary'+compId).hide();
		}
	}
  </script>
