<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR, SAVOIRSTAFF"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim  Con, rs, rs1, addproduct, component,productname,weight,tariff,depth,msg,sql


Set Con = getMysqlConnection()




msg=Request("msg")



%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/extra.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

<script src="SpryAssets/SpryTabbedPanels.js" type="text/javascript"></script>
<link href="SpryAssets/SpryTabbedPanels.css" rel="stylesheet" type="text/css">
</head>
<body>
<div class="container">
<!-- #include file="header.asp" -->

<div class="content brochure">
<div class="one-col head-col">
<%if msg<>"" then response.Write("<p><font color=red>" & msg & "</font></p>")%>
<div id="TabbedPanels1" class="TabbedPanels">
<ul class="TabbedPanelsTabGroup">
<li class="TabbedPanelsTab" tabindex="0">Product Information</li>
<li class="TabbedPanelsTab" tabindex="0">Box / Crate Information</li>

</ul>
<div class="TabbedPanelsContentGroup">
<div class="TabbedPanelsContent"><p>Click on Product Name to Edit - <a href="add-component-data.asp">or click here to Add New Product</a></p>
<table cellspacing="1" cellpadding="5" class="tableborder">
<tr>
<td>Product Type</td>
<td>Product Item</td>
<td>Weight per Square Cm (linear for headboards)</td>
<td>Harmonised Tariff Code</td>
<td>Depth of Products (cms)</td>
</tr>
<%sql="Select D.componentname, C.component, D.weight, D.tariffcode, D.depth, D.componentdata_id from componentdata D, component C where D.componentid=C.componentid order by C.componentid asc, D.componentname asc"
Set rs = getMysqlQueryRecordSet(sql , con)
Do until rs.eof					%>
<tr>
<td><%=rs("component")%>&nbsp;</td>
<td><a href="/php/editcompdata?lid=<%=rs("componentdata_id")%>"><%=rs("componentname")%></a></td>
<td><%=rs("weight")%>&nbsp;</td>
<td><%=rs("tariffcode")%>&nbsp;</td>
<td><%=rs("depth")%>&nbsp;</td>
</tr>
<%rs.movenext
loop
rs.close
set rs=nothing%>
</table>


<p><a href="add-component-data.asp">Add new product</a></p></div>
<form name="form1" method="post" action="updateshippingbox.asp">
<div class="TabbedPanelsContent">

<table border="0"  cellpadding="2px" cellspacing="2px">
<tr>
<td width="111">Shipping Boxes</td>
<td width="75">&nbsp;</td>
<td width="9">&nbsp;</td>
<td width="58">&nbsp;</td>
<td width="6">&nbsp;</td>
<td width="62">&nbsp;</td>
<td width="53">&nbsp;</td>
<td width="58">&nbsp;</td>
<td colspan="2">Packaging Allowance cm</td>
</tr>
<tr>
<td>&nbsp;</td>
<td>Width cm</td>
<td>&nbsp;</td>
<td>Length cm</td>
<td>&nbsp;</td>
<td>Weight (kg)</td>
<td>Depth cm</td>
<td>&nbsp;</td>
<td width="61">Width cm</td>
<td width="125">Length cm</td>
</tr>
<%sql="Select * from shippingbox where sName='Small'"
Set rs = getMysqlQueryRecordSet(sql , con)
%>
<tr>
<td align="right">Small</td>
<td>
<label for="widthS"></label>
<input name="widthS" type="text" id="widthS" size="5" value="<%=formatNumber(rs("width"),2)%>">
</td>
<td>x</td>
<td><input name="lengthS" type="text" id="lengthS" value="<%=formatNumber(rs("length"),2)%>" size="5"></td>
<td>&nbsp;</td>
<td><input name="weightS" type="text" id="weightS" value="<%=formatNumber(rs("weight"),2)%>" size="5"></td>
<td><input name="depthS" type="text" id="depthS" value="<%=formatNumber(rs("depth"),2)%>" size="5"></td>
<td>&nbsp;</td>
<td><input name="packwidthS" type="text" id="weightS" value="<%=formatNumber(rs("packallowancewidth"),2)%>" size="5"></td>
<td><input name="packlengthS" type="text" id="packlengthS" value="<%=formatNumber(rs("packallowancelength"),2)%>" size="5"></td>
</tr>
<%rs.close
set rs=nothing
sql="Select * from shippingbox where sName='Medium'"
Set rs = getMysqlQueryRecordSet(sql , con)
%>
<tr>
<td align="right">Medium</td>
<td><input name="widthM" type="text" id="widthM" size="5" value="<%=formatNumber(rs("width"),2)%>"></td>
<td>x</td>
<td><input name="lengthM" type="text" id="lengthM" value="<%=formatNumber(rs("length"),2)%>" size="5"></td>
<td>&nbsp;</td>
<td><input name="weightM" type="text" id="weightM" value="<%=formatNumber(rs("weight"),2)%>" size="5"></td>
<td><input name="depthM" type="text" id="depthM" value="<%=formatNumber(rs("depth"),2)%>" size="5"></td>
<td>&nbsp;</td>
<td><input name="packwidthM" type="text" id="packwidthM" value="<%=formatNumber(rs("packallowancewidth"),2)%>" size="5"></td>
<td><input name="packlengthM" type="text" id="packlengthM" value="<%=formatNumber(rs("packallowancelength"),2)%>" size="5"></td>
</tr>
<%rs.close
set rs=nothing
sql="Select * from shippingbox where sName='Large'"
Set rs = getMysqlQueryRecordSet(sql , con)
%>
<tr>
<td align="right">Large</td>
<td><input name="widthL" type="text" id="widthL" size="5" value="<%=formatNumber(rs("width"),2)%>"></td>
<td>x</td>
<td><input name="lengthL" type="text" id="lengthL" value="<%=formatNumber(rs("length"),2)%>" size="5"></td>
<td>&nbsp;</td>
<td><input name="weightL" type="text" id="weightL" value="<%=formatNumber(rs("weight"),2)%>" size="5"></td>
<td><input name="depthL" type="text" id="depthL" value="<%=formatNumber(rs("depth"),2)%>" size="5"></td>
<td>&nbsp;</td>
<td><input name="packwidthL" type="text" id="packwidthL" value="<%=formatNumber(rs("packallowancewidth"),2)%>" size="5"></td>
<td><input name="packlengthL" type="text" id="packlengthL" value="<%=formatNumber(rs("packallowancelength"),2)%>" size="5"></td>
</tr>
<tr>
<td align="right">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<tr>
<td align="right">&nbsp;</td>
<td>Height cm</td>
<td>&nbsp;</td>
<td>Width cm</td>
<td>&nbsp;</td>
<td>Depth cm</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<%rs.close
set rs=nothing
sql="Select * from shippingbox where sName='LegBox'"
Set rs = getMysqlQueryRecordSet(sql , con)
%>
<tr>
<td align="right">Leg Box</td>
<td><input name="heightLB" type="text" id="heightLB" size="5" value="<%=formatNumber(rs("height"),2)%>"></td>
<td>x</td>
<td><input name="widthLB" type="text" id="widthLB" size="5" value="<%=formatNumber(rs("width"),2)%>"></td>
<td>x</td>
<td><input name="depthLB" type="text" id="depthLB" size="5" value="<%=formatNumber(rs("depth"),2)%>"></td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<tr>
<td align="right">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<%rs.close
set rs=nothing
sql="Select * from shippingbox where sName='WoodenCrates'"
Set rs = getMysqlQueryRecordSet(sql , con)
%>
<tr>
<td align="right">&nbsp;</td>
<td colspan="4">Weight per sq. mtr. (kg)</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<tr>
<td align="right">Wooden Crates</td>
<td colspan="4"><input name="woodencrates" type="text" id="woodencrates" value="<%=formatNumber(rs("weight"),2)%>" size="5"></td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>  <%rs.close
set rs=nothing
sql="Select * from shippingbox where sName='InternalCrate'"
Set rs = getMysqlQueryRecordSet(sql , con)
%>
<tr>
<td colspan="3" align="right">Internal Crate / Product Allowance</td>
<td align="left"><input name="internalcrate" type="text" id="internalcrate" value="<%=formatNumber(rs("allowance"),2)%>" size="5">
cm</td>
<td align="right">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>  <%rs.close
set rs=nothing
sql="Select * from shippingbox where sName='AdditionalCrate'"
Set rs = getMysqlQueryRecordSet(sql , con)
%>
<tr>
<td colspan="3" align="right">Additional Crate Packaging Allowance</td>
<td><input name="additionalcrate" type="text" id="additionalcrate" value="<%=formatNumber(rs("allowance"),2)%>" size="5">
cm</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr> <%rs.close
set rs=nothing
sql="Select * from shippingbox where sName='RoundCrate'"
Set rs = getMysqlQueryRecordSet(sql , con)
%>
<tr>
<td colspan="3" align="right">Round Crate to nearest</td>
<td><input name="roundcrate" type="text" id="roundcrate" value="<%=formatNumber(rs("roundtonearest"),2)%>" size="5">
cm</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<tr>
<td colspan="3" align="right">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr><%rs.close
set rs=nothing
sql="Select * from shippingbox where sName='HCaTopper'"
Set rs = getMysqlQueryRecordSet(sql , con)
%>
<tr>
<td colspan="3" align="left">Folded Topper Allowance cm</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<tr>
<td align="right">HCa Topper</td>
<td align="left"><input name="hca" type="text" id="hca" value="<%=formatNumber(rs("allowance"),2)%>" size="5"></td>
<td align="left">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr><%rs.close
set rs=nothing
sql="Select * from shippingbox where sName='StateHCaTopper'"
Set rs = getMysqlQueryRecordSet(sql , con)
%>
<tr>
<td colspan="3" align="left">Folded Topper Allowance cm</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<tr>
<td align="right">State HCa Topper</td>
<td align="left"><input name="statehca" type="text" id="statehca" value="<%=formatNumber(rs("allowance"),2)%>" size="5"></td>
<td align="left">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr><%rs.close
set rs=nothing
sql="Select * from shippingbox where sName='HWTopper'"
Set rs = getMysqlQueryRecordSet(sql , con)
%>
<tr>
<td align="right">HW Topper</td>
<td align="left"><input name="hw" type="text" id="hw" value="<%=formatNumber(rs("allowance"),2)%>" size="5"></td>
<td align="left">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr><%rs.close
set rs=nothing
sql="Select * from shippingbox where sName='CWTopper'"
Set rs = getMysqlQueryRecordSet(sql , con)
%>
<tr>
<td align="right">CW Topper</td>
<td align="left"><input name="cw" type="text" id="cw" value="<%=formatNumber(rs("allowance"),2)%>" size="5"></td>
<td align="left">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>


</table>
<hr />
<%
rs.close
set rs=nothing
%>
<table width="100%" border="0" cellspacing="0" cellpadding="3">
  <tr>
    <td>Savoir Stock Ref.</td>
    <td>Crate Name</td>
    <td>Internal Length</td>
    <td>Internal Width</td>
    <td>Internal Height</td>
    <td>External Length</td>
    <td>External Width</td>
    <td>External Height</td>
    <td>Crate Weight</td>
  </tr>
  <%sql="Select * from shippingbox where sName='Expak MB'"
Set rs = getMysqlQueryRecordSet(sql , con)%>
  <tr>
    <td><%=rs("SavoirStockRef")%></td>
    <td><%=rs("sName")%></td>
    <td><input name="internalLengthExpakMB" type="text" id="internalLengthExpakMB" size="5" value="<%=formatNumber(rs("InternalLength"),2)%>"></td>
    <td><input name="internalWidthExpakMB" type="text" id="internalHeightExpakMB" size="5" value="<%=formatNumber(rs("InternalWidth"),2)%>"></td>
    <td><input name="internalHeightExpakMB" type="text" id="internalHeightExpakMB" size="5" value="<%=formatNumber(rs("InternalHeight"),2)%>"></td>
    <td><input name="lengthExpakMB" type="text" id="lengthExpakMB" size="5" value="<%=formatNumber(rs("length"),2)%>"></td>
    <td><input name="widthExpakMB" type="text" id="widthExpakMB" size="5" value="<%=formatNumber(rs("width"),2)%>"></td>
    <td><input name="heightExpakMB" type="text" id="heightExpakMB" size="5" value="<%=formatNumber(rs("height"),2)%>"></td>
    <td><input name="weightExpakMB" type="text" id="weightExpakMB" size="5" value="<%=formatNumber(rs("weight"),2)%>"></td>
  </tr>
<%
rs.close
set rs=nothing
sql="Select * from shippingbox where sName='Expak T'"
Set rs = getMysqlQueryRecordSet(sql , con)%>
  <tr>
    <td><%=rs("SavoirStockRef")%></td>
    <td><%=rs("sName")%></td>
    <td><input name="internalLengthExpakT" type="text" id="internalLengthExpakT" size="5" value="<%=formatNumber(rs("InternalLength"),2)%>"></td>
    <td><input name="internalWidthExpakT" type="text" id="internalHeightExpakT" size="5" value="<%=formatNumber(rs("InternalWidth"),2)%>"></td>
    <td><input name="internalHeightExpakT" type="text" id="internalHeightExpakT" size="5" value="<%=formatNumber(rs("InternalHeight"),2)%>"></td>
    <td><input name="lengthExpakT" type="text" id="lengthExpakT" size="5" value="<%=formatNumber(rs("length"),2)%>"></td>
    <td><input name="widthExpakT" type="text" id="widthExpakT" size="5" value="<%=formatNumber(rs("width"),2)%>"></td>
    <td><input name="heightExpakT" type="text" id="heightExpakT" size="5" value="<%=formatNumber(rs("height"),2)%>"></td>
    <td><input name="weightExpakT" type="text" id="weightExpakT" size="5" value="<%=formatNumber(rs("weight"),2)%>"></td>
  </tr>
<%
rs.close
set rs=nothing
sql="Select * from shippingbox where sName='Expak 1M'"
Set rs = getMysqlQueryRecordSet(sql , con)%>
  <tr>
    <td><%=rs("SavoirStockRef")%></td>
    <td><%=rs("sName")%></td>
    <td><input name="internalLengthExpak1M" type="text" id="internalLengthExpak1M" size="5" value="<%=formatNumber(rs("InternalLength"),2)%>"></td>
    <td><input name="internalWidthExpak1M" type="text" id="internalHeightExpak1M" size="5" value="<%=formatNumber(rs("InternalWidth"),2)%>"></td>
    <td><input name="internalHeightExpak1M" type="text" id="internalHeightExpak1M" size="5" value="<%=formatNumber(rs("InternalHeight"),2)%>"></td>
    <td><input name="lengthExpak1M" type="text" id="lengthExpak1M" size="5" value="<%=formatNumber(rs("length"),2)%>"></td>
    <td><input name="widthExpak1M" type="text" id="widthExpak1M" size="5" value="<%=formatNumber(rs("width"),2)%>"></td>
    <td><input name="heightExpak1M" type="text" id="heightExpak1M" size="5" value="<%=formatNumber(rs("height"),2)%>"></td>
    <td><input name="weightExpak1M" type="text" id="weightExpak1M" size="5" value="<%=formatNumber(rs("weight"),2)%>"></td>
  </tr>
<%
rs.close
set rs=nothing
sql="Select * from shippingbox where sName='Expak H'"
Set rs = getMysqlQueryRecordSet(sql , con)%>
  <tr>
    <td><%=rs("SavoirStockRef")%></td>
    <td><%=rs("sName")%></td>
    <td><input name="internalLengthExpakH" type="text" id="internalLengthExpakH" size="5" value="<%=formatNumber(rs("InternalLength"),2)%>"></td>
    <td><input name="internalWidthExpakH" type="text" id="internalHeightExpakH" size="5" value="<%=formatNumber(rs("InternalWidth"),2)%>"></td>
    <td><input name="internalHeightExpakH" type="text" id="internalHeightExpakH" size="5" value="<%=formatNumber(rs("InternalHeight"),2)%>"></td>
    <td><input name="lengthExpakH" type="text" id="lengthExpakH" size="5" value="<%=formatNumber(rs("length"),2)%>"></td>
    <td><input name="widthExpakH" type="text" id="widthExpakH" size="5" value="<%=formatNumber(rs("width"),2)%>"></td>
    <td><input name="heightExpakH" type="text" id="heightExpakH" size="5" value="<%=formatNumber(rs("height"),2)%>"></td>
    <td><input name="weightExpakH" type="text" id="weightExpakH" size="5" value="<%=formatNumber(rs("weight"),2)%>"></td>
  </tr>
  <%
rs.close
set rs=nothing
%>
</table>
<input type="submit" name="Submit" id="Submit" value="Submit">
<br /><br />
</form></div>

</div>
</div>

</div>
</div>

<div>
</div>

<script type="text/javascript">
var TabbedPanels1 = new Spry.Widget.TabbedPanels("TabbedPanels1");
</script>
</body>
</html>
<%

Con.Close
Set Con = Nothing
%>
<script Language="JavaScript" type="text/javascript">
<!--
function FrontPage_Form1_Validator(theForm)
{


if (theForm.collectiondate.value == "")
{
alert("Please select a collection date");
theForm.collectiondate.focus();
return (false);
}
if (theForm.etadate.value == "")
{
alert("Please select an ETA date");
theForm.etadate.focus();
return (false);
}
if (theForm.shipperaddress.value == "all")
{
alert("Please select a shipper");
theForm.shipperaddress.focus();
return (false);
}

return true;
}

//-->
</script>
<!-- #include file="common/logger-out.inc" -->
