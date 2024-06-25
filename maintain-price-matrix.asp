<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%
dim con, sql, rs, compRs, priceTypeRs, jsmsg, row
jsmsg = request("jsmsg")

set con = getMysqlConnection()

set compRs = getMysqlQueryRecordSet("select componentid as val, component as opt from component order by componentid", con)
set priceTypeRs = getMysqlQueryRecordSet("select price_type_id as val, name as opt from price_matrix_type order by seq", con)
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration - Price Matrix</title>
<meta content="text/html; charset=utf-8" http-equiv="content-type" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/extra.css" rel="Stylesheet" type="text/css" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>
<script src="common/jquery.eComboBox.custom.js" type="text/javascript"></script>
<% if jsmsg <> "" then %>
	<script Language="JavaScript" type="text/javascript">
		alert("<%=jsmsg%>");
	</script>
<% end if %>
</head>

<body>
<div class="container">
	<!-- #include file="header.asp" -->
	<div class="content brochure">
		<p>
			<input type="button" name="formToggle" id="formToggle" value="Edit" onclick="toggleForm();" />
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			Retail to Wholesale Adjustment:&nbsp;
			<input type="text" name="adjustmentfactor" id="adjustmentfactor" value="2.5" size="10" class="otherfieldscls"/>
			&nbsp;
			<input type="button" name="applyadjustment" id="applyadjustment" value="Update Wholesale from Retail Prices" onclick="applyAdjustment();" class="otherfieldscls"/>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" name="exworkscopy" id="exworkscopy" value="Copy data from UK wholesale to Ex Works column" onclick="doExWorksCopy();" class="otherfieldscls"/>
			&nbsp;
			<a href="/php/PriceMatrixImportExport/export/">Download</a>
		</p>
		<form action="maintain-price-matrix-process.asp" method="post" name="form1" id="form1" onSubmit="return validate(this);">
			<table>
				<tr>
					<td colspan="11">&nbsp;</td>
					<td colspan="3" align="center"><b>Retail Prices</b></td>
					<td colspan="3" align="center"><b>Wholesale Prices</b></td>
					<td colspan="1">Ex works</td>
					<td colspan="1">&nbsp;</td>
				</tr>
				<tr>
					<td>Row</td>
					<td>Price Type</td>
					<td>Component</td>
					<td>Dimension 1 Name</td>
					<td>Dimension 1</td>
					<td>Dimension 2 Name</td>
					<td>Dimension 2</td>
					<td>Dimension 3 Name</td>
					<td>Dimension 3</td>
					<td>Set Component 1</td>
					<td>Set Component 2</td>
					<td>GBP</td>
					<td>USD</td>
					<td>EUR</td>
					<td>GBP</td>
					<td>USD</td>
					<td>EUR</td>
					<td>Revenue 2014</td>
					<td>Delete</td>
				</tr>
				<%
				sql = "select t.price_type_id, p.price_matrix_id as id, t.name, t.dim1_name, p.dim1, t.dim2_name, p.dim2, t.dim3_name, p.dim3,"
				sql = sql & " p.componentid, p.gbp, p.usd, p.eur, p.gbp_wholesale, p.usd_wholesale, p.eur_wholesale, p.ex_works_revenue,"
				sql = sql & " p.compid_set1, p.compid_set2 from price_matrix_type t, price_matrix p where t.price_type_id=p.price_type_id"
				sql = sql & " order by p.componentid, p.price_matrix_id"
				set rs = getMysqlQueryRecordSet(sql, con)
				row = 0
				while not rs.eof
					row = row + 1
					if (row mod 50) = 0 then response.flush ' to fix the Response Buffer Limit Exceeded problem
					%>
					<tr>
						<td><%=row%></td>
						<td>
							<select name="price_type_id-<%=rs("id")%>" id="price_type_id-<%=rs("id")%>" onchange="makeDimensions(<%=rs("id")%>);">
								<% response.write(makeSelectOptions(priceTypeRs, rs("price_type_id"), false)) %>
							</select>
						</td>
						<td>
							<select name="componentid-<%=rs("id")%>" id="componentid-<%=rs("id")%>">
								<% response.write(makeSelectOptions(compRs, rs("componentid"), false)) %>
							</select>
						</td>

						<td><span id="dim1_name-<%=rs("id")%>"><%=rs("dim1_name")%></span></td>
						<td><input type="text" name="dim1-<%=rs("id")%>" id="dim1-<%=rs("id")%>" value="<%=rs("dim1")%>" size="10" /></td>

						<td><span id="dim2_name-<%=rs("id")%>"><%=rs("dim2_name")%></span></td>
						<td><input type="text" name="dim2-<%=rs("id")%>" id="dim2-<%=rs("id")%>" value="<%=rs("dim2")%>" size="10" /></td>

						<td><span id="dim3_name-<%=rs("id")%>"><%=rs("dim3_name")%></span></td>
						<td><input type="text" name="dim3-<%=rs("id")%>" id="dim3-<%=rs("id")%>" value="<%=rs("dim3")%>" size="10" /></td>

						<td>
							<select name="compid_set1-<%=rs("id")%>" id="compid_set1-<%=rs("id")%>">
								<% response.write(makeSelectOptions(compRs, rs("compid_set1"), true)) %>
							</select>
						</td>

						<td>
							<select name="compid_set2-<%=rs("id")%>" id="compid_set2-<%=rs("id")%>">
								<% response.write(makeSelectOptions(compRs, rs("compid_set2"), true)) %>
							</select>
						</td>

						<td><input type="text" name="gbp-<%=rs("id")%>" id="gbp-<%=rs("id")%>" value="<%=myFmtNbr(rs("gbp"))%>" size="7" /></td>
						<td><input type="text" name="usd-<%=rs("id")%>" id="usd-<%=rs("id")%>" value="<%=myFmtNbr(rs("usd"))%>" size="7" /></td>
						<td><input type="text" name="eur-<%=rs("id")%>" id="eur-<%=rs("id")%>" value="<%=myFmtNbr(rs("eur"))%>" size="7" /></td>
						<td><input type="text" name="gbp_wholesale-<%=rs("id")%>" id="gbp_wholesale-<%=rs("id")%>" value="<%=myFmtNbr(rs("gbp_wholesale"))%>" size="7" /></td>
						<td><input type="text" name="usd_wholesale-<%=rs("id")%>" id="usd_wholesale-<%=rs("id")%>" value="<%=myFmtNbr(rs("usd_wholesale"))%>" size="7" /></td>
						<td><input type="text" name="eur_wholesale-<%=rs("id")%>" id="eur_wholesale-<%=rs("id")%>" value="<%=myFmtNbr(rs("eur_wholesale"))%>" size="7" /></td>
						<td><input type="text" name="ex_works_revenue-<%=rs("id")%>" id="ex_works_revenue-<%=rs("id")%>" value="<%=myFmtNbr(rs("ex_works_revenue"))%>" size="7" /></td>
						<td><input type="checkbox" name="del-<%=rs("id")%>" id="del-<%=rs("id")%>" value="y" /></td>
					</tr>
					<script Language="JavaScript" type="text/javascript">
						<% if isnull(rs("dim1")) or rs("dim1") = "" then %>$("#dim1-<%=rs("id")%>").hide();<% end if %>
						<% if isnull(rs("dim2")) or rs("dim2") = "" then %>$("#dim2-<%=rs("id")%>").hide();<% end if %>
						<% if isnull(rs("dim3")) or rs("dim3") = "" then %>$("#dim3-<%=rs("id")%>").hide();<% end if %>
					</script>
					<%
					rs.movenext
				wend
				%>	
				<tr>
					<td colspan="10">New Entry:</td>
				</tr>		
				<tr>
					<td>&nbsp;</td>
					<td>
						<select name="price_type_id-0" id="price_type_id-0" onchange="makeDimensions(0);">
							<% response.write(makeSelectOptions(priceTypeRs, 0, true)) %>
						</select>
					</td>
					<td>
						<select name="componentid-0" id="componentid-0">
							<% response.write(makeSelectOptions(compRs, 0, true)) %>
						</select>
					</td>
					
					<td><span id="dim1_name-0"></span></td>
					<td><input type="text" name="dim1-0" id="dim1-0" size="5" /></td>
					<td><span id="dim2_name-0"></span></td>
					<td><input type="text" name="dim2-0" id="dim2-0" size="5" /></td>
					<td><span id="dim3_name-0"></span></td>
					<td><input type="text" name="dim3-0" id="dim3-0" size="5" /></td>

					<td>
						<select name="compid_set1-0" id="compid_set1-0">
							<% response.write(makeSelectOptions(compRs, 0, true)) %>
						</select>
					</td>

					<td>
						<select name="compid_set2-0" id="compid_set2-0">
							<% response.write(makeSelectOptions(compRs, 0, true)) %>
						</select>
					</td>

					<td><input type="text" name="gbp-0" id="gbp-0" size="7" /></td>
					<td><input type="text" name="usd-0" id="usd-0" size="7" /></td>
					<td><input type="text" name="eur-0" id="eur-0" size="7" /></td>
					<td><input type="text" name="gbp_wholesale-0" id="gbp_wholesale-0" size="7" /></td>
					<td><input type="text" name="usd_wholesale-0" id="usd_wholesale-0" size="7" /></td>
					<td><input type="text" name="eur_wholesale-0" id="eur_wholesale-0" size="7" /></td>
					<td><input type="text" name="ex_works_revenue-0" id="ex_works_revenue-0" size="7" /></td>
				</tr>
			</table>
			<input type="submit" name="save" value="Save" />
		</form>
	</div>
</div>
</body>
</html>
<%
function makeSelectOptions(byref aRs, aDefId, aIncludeBlank)
	dim astr
	if aIncludeBlank then
		astr = "<option value=''></option>"
	end if
	aRs.movefirst
	while not aRs.eof
		astr = astr & "<option value='" & aRs("val") & "' " & selected(aDefId, aRs("val")) & ">" & aRs("opt") & "</option>"
		aRs.movenext
	wend
	makeSelectOptions = astr
end function

function myFmtNbr(aAmt)
	if isnull(aAmt) or isempty(aAmt) or aAmt = "" then
		myFmtNbr = ""
	else
		myFmtNbr = formatNumber(aAmt, 2, -1, 0, 0)
	end if
end function
%>
<script Language="JavaScript" type="text/javascript">
	$("#dim1-0").hide();
	$("#dim2-0").hide();
	$("#dim3-0").hide();
	
	disableForm();
	
	function toggleForm() {
		var val = $("#formToggle").val();
		if (val == "Edit") {
			$("#formToggle").val('Lock');
			enableForm();
		} else {
			$("#formToggle").val('Edit');
			disableForm();
		}
	}
	
	function disableForm() {
		$('#form1 input').attr('disabled', 'disabled');
		$('#form1 textarea').attr('disabled', 'disabled');
		$('#form1 select').attr('disabled', 'disabled');
		$('.otherfieldscls').attr('disabled', 'disabled');
	}

	function enableForm() {
		$('#form1 input').removeAttr('disabled');
		$('#form1 textarea').removeAttr('disabled');
		$('#form1 select').removeAttr('disabled');
		$('.otherfieldscls').removeAttr('disabled');
	}

	function makeDimensions(typeId) {
		var ptid = $("#price_type_id-" + typeId).val();
		var url = "maintain-price-matrix-ajax.asp?func=getPriceTypeDims&ptid=" + ptid + "&ts=" + (new Date()).getTime();
		//alert(url);
		$.getJSON(url, function(data) {
			$.each(data, function(key, val) {
				var i = key.substr(3,1);
				$("#dim" + i + "_name-" + typeId).html(val);
				if (val != "") {
					$("#dim" + i + "-" + typeId).show();
				} else {
					$("#dim" + i + "-" + typeId).hide();
				}
			});
		});
	}
	
	function applyAdjustment() {
		var factor = $("#adjustmentfactor").val();
		if (!isNumber(factor)) {
			alert("Please enter a valid number");
			$("#adjustmentfactor").focus();
			return;
		}
		var retailPrice, wholesalePrice;
		<%
		rs.movefirst
		while not rs.eof
			%>
			retailPrice = $("#gbp-<%=rs("id")%>").val();
			if (isNumber(retailPrice)) {
				wholesalePrice = retailPrice / factor;
				$("#gbp_wholesale-<%=rs("id")%>").val(wholesalePrice.toFixed(2));
			}

			retailPrice = $("#usd-<%=rs("id")%>").val();
			if (isNumber(retailPrice)) {
				wholesalePrice = retailPrice / factor;
				$("#usd_wholesale-<%=rs("id")%>").val(wholesalePrice.toFixed(2));
			}

			retailPrice = $("#eur-<%=rs("id")%>").val();
			if (isNumber(retailPrice)) {
				wholesalePrice = retailPrice / factor;
				$("#eur_wholesale-<%=rs("id")%>").val(wholesalePrice.toFixed(2));
			}
			<%
			rs.movenext
		wend
		%>
	}
	
	function doExWorksCopy() {
		var gbpWholesalePrice;
		<%
		rs.movefirst
		while not rs.eof
			%>
			gbpWholesalePrice = $("#gbp_wholesale-<%=rs("id")%>").val();
			console.log("gbpWholesalePrice = " + gbpWholesalePrice);
			if (isNumber(gbpWholesalePrice)) {
				$("#ex_works_revenue-<%=rs("id")%>").val(parseFloat(gbpWholesalePrice).toFixed(2));
			}
			<%
			rs.movenext
		wend
		%>
	}
	
	function validate(theForm) {
		// number validation no longer required, as dims don't have to be numbers any more
		return true;
		<%
		rs.movefirst
		while not rs.eof
			%>
			var dim1 = $("#dim1-<%=rs("id")%>").val();
			if (dim1 != "" && !isNumber(dim1)) {
				$("#dim1-<%=rs("id")%>").focus();
				alert("Please enter a valid number");
				return false;
			}

			var dim2 = $("#dim2-<%=rs("id")%>").val();
			if (dim2 != "" && !isNumber(dim2)) {
				$("#dim2-<%=rs("id")%>").focus();
				alert("Please enter a valid number");
				return false;
			}

			var dim3 = $("#dim3-<%=rs("id")%>").val();
			if (dim3 != "" && !isNumber(dim3)) {
				$("#dim3-<%=rs("id")%>").focus();
				alert("Please enter a valid number");
				return false;
			}
			<%
			rs.movenext
		wend
		%>
		
		var type0 = $("#price_type_id-0").val();
		if (type0 != "") {
			var compId0 = $("#componentid-0").val();
			if (compId0 == "") {
				$("#componentid-0").focus();
				alert("Please select a component");
				return false;
			}

			var dim1 = $("#dim1-0").val();
			if (dim1 != "" && !isNumber(dim1)) {
				$("#dim1-0").focus();
				alert("Please enter a valid number");
				return false;
			}

			var dim2 = $("#dim2-0").val();
			if (dim2 != "" && !isNumber(dim2)) {
				$("#dim2-0").focus();
				alert("Please enter a valid number");
				return false;
			}

			var dim3 = $("#dim3-0").val();
			if (dim3 != "" && !isNumber(dim3)) {
				$("#dim3-0").focus();
				alert("Please enter a valid number");
				return false;
			}
		}
		
		return true;
	}
	
	function isNumber(n) {
		return n !== null && n !== undefined && !isNaN(parseFloat(n)) && isFinite(n);
	}
</script>
<%
call closemysqlrs(rs)
call closemysqlrs(compRs)
call closemysqlrs(priceTypeRs)
call closemysqlcon(con)
%>
<!-- #include file="common/logger-out.inc" -->
