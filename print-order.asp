<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="orderfuncs.asp" -->
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, baseprice, upholsteredbase, upholsteryprice, valancerequired, accessoriesrequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, contact,  orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, rs3, selcted, custcode, msg, signature, custname, quote
dim purchase_no, i, paymentSum, payments, n, displayterms, orderCurrency, remakeguarantee
remakeguarantee="n"
displayterms=""
quote=Request("quote")
custname=""
msg=""
localeref=retrieveuserregion()
Set Con = getMysqlConnection()
sql="Select * from region WHERE id_region=" & localeref
'REsponse.Write("sql=" & sql)	
Set rs = getMysqlUpdateRecordSet(sql, con)

Session.LCID = rs("locale")
rs.close
set rs=nothing

purchase_no=Request("val")

selcted=""
count=0
order=""
submit=""

payments = getPaymentsForOrder(purchase_no, con)
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta content="text/html; charset=utf-8" http-equiv="content-type" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />

	<script type="text/javascript" src="ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="ckeditor/lang/_languages.js"></script>
	<script src="ckeditor/_samples/sample.js" type="text/javascript"></script>
	
	<link rel="stylesheet" href="Styles/jquery.signaturepad.css">
	<!--[if lt IE 9]><script src="scripts/flashcanvas.js"></script><![endif]-->
	<script src="common/jquery.js" type="text/javascript"></script>
	

<link href="ckeditor/_samples/sample.css" rel="stylesheet" type="text/css" />

<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/printorder.css" rel="Stylesheet" type="text/css" media="print" />

</head>
<body onLoad="window.print();">

<div class="container"><img src="/images/logo.gif" width="255" height="66" />
<div class="content brochure">
  <div class="one-col head-col">
  <%


Set rs = getMysqlQueryRecordSet("Select * from purchase WHERE purchase_no=" & purchase_no & "", con)

if rs("savoirmodel")="No. 1" or rs("savoirmodel")="No. 2" then
remakeguarantee="y"
end if
orderCurrency = rs("ordercurrency")
contact = rs("salesusername")
Set rs1 = getMysqlQueryRecordSet("Select * from contact WHERE code=" & rs("code") & "", con)
Set rs2 = getMysqlQueryRecordSet("Select * from address WHERE code=" & rs1("code") & "", con)
signature = rs("signature")
If rs1("title") <> "" Then custname=custname & capitalise(lcase(rs1("title"))) & " "
If rs1("first") <> "" Then custname=custname & capitalise(lcase(rs1("first"))) & " "
If rs1("surname") <> "" Then custname=custname & capitalise(lcase(rs1("surname")))
%><p id="donotprint"><a href="editcust.asp?val=<%=rs1("contact_no")%>"><< Return to Customer Record</a></p>
<%If quote="y" then%>
<p><b>Pricing is subject to change.  This quote is valid for 60 days</b></p>
<p><b>Quote for:
<%Else%>
<p><b>Order for:
<%End If%>   
&nbsp;<%=custname%></b></p>
     
    <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
          <tr>
            <td width="10%">Contact:</td>
            <td width="23%">
             <%=contact%></td>
            <td colspan="2">Invoice Address:</td>
            <td colspan="2">Delivery Address:</td>
        </tr>
          <tr>
            <%If quote="y" then%>
             <td>Quote No:</td>
          <%Else%>
              <td>Order No:</td>
          <%End If%>
        
            <td><%=rs("order_number")%></td>
            <td width="8%">Line 1: </td>
            <td width="28%"><%=rs2("street1")%></td>
            <td width="8%">Line 1: </td>
            <td width="23%"><%=rs("deliveryadd1")%></td>
        </tr>
          <tr>
            <td>Date of order: </td>
            <td><%=rs("order_date")%></td>
            <td>Line 2: </td>
            <td><%=rs2("street2")%></td>
            <td>Line 2: </td>
            <td><%=rs("deliveryadd2")%></td>
        </tr>
          <tr>
            <td>Customer Reference:</td>
            <td><%=rs("customerreference")%></td>
            <td>Line 3:</td>
            <td><%=rs2("street3")%></td>
            <td>Line 3:</td>
            <td><%=rs("deliveryadd3")%></td>
        </tr>
          <tr>
            <td>Clients Title:</td>
            <td><%=rs1("title")%></td>
            <td>Town: </td>
            <td><%=rs2("town")%></td>
            <td>Town: </td>
            <td><%=rs("deliverytown")%></td>
        </tr>
          <tr>
            <td>First Name:</td>
            <td><%=rs1("first")%></td>
            <td>County: </td>
            <td><%=rs2("county")%></td>
            <td>County: </td>
            <td><%=rs("deliverycounty")%></td>
        </tr>
          <tr>
            <td>Surname:</td>
            <td><%=rs1("surname")%></td>
            <td>Postcode: </td>
            <td><%=rs2("postcode")%></td>
            <td>Postcode: </td>
            <td><%=rs("deliverypostcode")%></td>
        </tr>
          <tr>
            <td>Tel Home:</td>
            <td><%=rs2("tel")%>&nbsp;</td>
            <td>Country: </td>
            <td><%=rs2("country")%></td>
            <td>Country: </td>
            <td><%=rs("deliverycountry")%></td>
        </tr>
        <tr>
            <td>Tel Work:: </td>
            <td><%=rs1("telwork")%>&nbsp;</td>
            <td></td><td></td><td></td><td></td>
        </tr>
         <tr>
            <td>Mobile:</td>
            <td><%=rs1("mobile")%>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td></td><td></td>
        </tr>
         <tr>
           <td>Email Address:</td>
           <td><%=rs2("email_address")%>&nbsp;</td>
	       <% if rs1("company_vat_no") <> "" then %>
	           <td>Company VAT No.:</td><td><%=rs1("company_vat_no")%></td>
	       <% else %>
	           <td>&nbsp;</td><td>&nbsp;</td>
	       <% end if %>
           <td>&nbsp;</td>
           <td>&nbsp;</td>
         </tr>
         <tr>
           <td>Company Name: </td>
           <td><%=rs("companyname")%></td>
           <td>Approx. Delivery Date:</td>
           <td><%=getRoundedApproxDateDescription(rs("deliverydate"))%></td>
           <td>Booked Delivery Date: </td>
           <td><%=rs("bookeddeliverydate")%></td>
         </tr>
      </table>
      <br>
   
      <div class="clear"></div>
      <p class="purplebox"><span class="radiobxmargin">Mattress Required</span>&nbsp;
        <%If rs("mattressrequired")="y" Then%>
        Yes
        <%else%>
        No
        
        <%End If%>
      </p>
     <%If rs("mattressrequired")="y" Then%>
      <div id="mattress_div">
        <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
          <tr>
            <td width="11%">Savoir Model:</td>
            <td width="22%"><%=rs("savoirmodel")%>
               
            </td>
            <td width="10%">Mattress Type: </td>
            <td>
              
                <%If rs("mattresstype")<>"" Then%>
               <%=rs("mattresstype")%>
                <%End If%>
            </td>
            <td width="8%">Ticking Options</td>
            <td width="24%">
              <%If rs("tickingoptions")<>"" Then%>
             <%=rs("tickingoptions")%>
              <%End If%>
            </td>
          </tr>
          <tr>
            <td>Mattress Width:</td>
            <td>
              <%If rs("mattresswidth")<>"" Then%>
              <%=rs("mattresswidth")%>
              <%End If%>
            </td>
            <td width="10%">Mattress Length: </td>
            <td width="25%">
              <%If rs("mattresslength")<>"" Then%>
             <%=rs("mattresslength")%>
              <%End If%>
            </td>
            <td colspan="2">&nbsp;</td>
          </tr>
        </table>
        <p>Support (as viewed from the foot looking toward the head end):</p>
        <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
          <tr>
            <td width="11%">Left Support:</td>
            <td width="14%">
              <%If rs("leftsupport")<>"" Then%>
             <%=rs("leftsupport")%>
              <%End If%>
            </td>
            <td width="11%">Right Support: </td>
            <td width="13%">
              <%If rs("rightsupport")<>"" Then%>
             <%=rs("rightsupport")%>
              <%End If%>
            </td>
            <td width="11%">Vent Position:</td>
            <td width="16%">
              <%If rs("ventposition")<>"" Then%>
              <%=rs("ventposition")%>
              <%End If%>
           </td>
            <td width="10%">Vent Finish:</td>
            <td width="14%">
              <%If rs("ventfinish")<>"" Then%>
             <%=rs("ventfinish")%>
              <%End If%>
            </td>
          </tr>
        </table>
        <p class="greybox">Special Instructions:</p>
        <%If rs("tickingoptions")="White Trellis" Then%>
        <img src="img/white-trellis.jpg" alt="White Trellis" width="149" height="96" hspace="30" align="right">
        <%End If%>
         <%If rs("tickingoptions")="Grey Trellis" Then%>
        <img src="img/grey-trellis.jpg" alt="Grey Trellis" width="149" height="96" hspace="30" align="right">
         <%End If%>
         <%If rs("tickingoptions")="Silver Trellis" Then%>
        <img src="img/silver-trellis.jpg" alt="Silver Trellis" width="149" height="96" hspace="30" align="right">
         <%End If%>
         <%If rs("tickingoptions")="Oatmeal Trellis" Then%>
       <img src="img/oatmeal-trellis.jpg" alt="oatmeal Trellis" width="149" height="96" hspace="30" align="right">
        <%End If%>
<p><strong>
          <%=rs("mattressinstructions")%>
        </strong>     <span class="floatprice"> Mattress  £
           <%=rs("mattressprice")%>
       </p>
        <div class="clear"></div>
      </div>
      <%End If%>
      <p class="purplebox"><span class="radiobxmargin">Topper Required</span>&nbsp;
        <% If rs("topperrequired")="y" then%>
        Yes
        <%Else%>
        No
        <%End If%>
      </p>
      <% If rs("topperrequired")="y" then%>
      <div id="topper_div">
        <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
          <tr>
            <td width="11%">Topper Type:</td>
            <td width="22%">
              <%If rs("toppertype")<>"" Then%>
             <%=rs("toppertype")%>
              <%End If%>
            </td>
            <td>Topper Width: </td>
            <td>
              <%If rs("topperwidth")<>"" Then%>
            <%=rs("topperwidth")%>
              <%End If%>
            </td>
            <td width="8%">Topper Length:</td>
            <td width="24%">
              <%If rs("topperlength")<>"" Then%>
             <%=rs("topperlength")%>
              <%End If%>
            </td>
          </tr>
          <tr>
            <td>Ticking Options:</td>
            <td>
              <%If rs("toppertickingoptions")<>"" Then%>
              <%=rs("toppertickingoptions")%>
              <%End If%>
            </td>
            <td width="10%">&nbsp;</td>
            <td width="25%">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
        <%If rs("toppertickingoptions")="White Trellis" Then%>
        <img src="img/white-trellis.jpg" alt="White Trellis" width="149" height="96" hspace="30" align="right">
        <%End If%>
         <%If rs("toppertickingoptions")="Grey Trellis" Then%>
       <img src="img/grey-trellis.jpg" alt="Grey Trellis" width="149" height="96" hspace="30" align="right">
         <%End If%>
         <%If rs("toppertickingoptions")="Silver Trellis" Then%>
         <img src="img/silver-trellis.jpg" alt="Silver Trellis" width="149" height="96" hspace="30" align="right">
         <%End If%>
         <%If rs("toppertickingoptions")="Oatmeal Trellis" Then%>
        <img src="img/oatmeal-trellis.jpg" alt="oatmeal Trellis" width="149" height="96" hspace="30" align="right">
        <%End If%>
        <div class="clear"></div>
        <p class="greybox">Special Instructions:</p>
        <p><%=rs("specialinstructionstopper")%>
        <span class="floatprice"> Topper £
          <%=rs("topperprice")%>
        </span></p>
        <div class="clear"></div>
      </div>
      <%End If%>
      <p class="purplebox"><span class="radiobxmargin">Base Required</span>&nbsp;
        <%If rs("baserequired")="y" Then%>
        Yes
        <%Else%>
        No
        <%End If%>
      </p>
      <%If rs("baserequired")="y" Then%>
      <div id="base_div">
        <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
          <tr>
            <td>Savoir Model:</td>
            <td>
              <%If rs("basesavoirmodel")<>"" Then%>
             <%=rs("basesavoirmodel")%>
              <%End If%>
            </td>
            <td>Base Type:</td>
            <td>
              <%If rs("basetype")<>"" Then%>
              <%=rs("basetype")%>
              <%End If%>
            </td>
            <td>Base Width: </td>
            <td>
              <%If rs("basewidth")<>"" Then%>
              <%=rs("basewidth")%>
              <%End If%>
            </td>
          </tr>
          <tr>
            <td>Base Length:</td>
            <td>
              <%If rs("baselength")<>"" Then%>
         <%=rs("baselength")%>
              <%End If%>
            </td>
            <td>Link Position:</td>
            <td><%If rs("linkposition")<>"" Then%>
              <%=rs("linkposition")%>
              <%End If%></td>
            <td>Link Finish</td>
            <td><%If rs("linkfinish")<>"" Then%>
              <%=rs("linkfinish")%>
              <%End If%></td>
          </tr>
          <tr>
            <td>Extended Base:</td>
            <td><%=rs("extbase")%>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
        <p class="greybox">Special Instructions:</p>
        <p><%=rs("baseinstructions")%>
        <span class="floatprice"> Base  £
         <%=rs("baseprice")%>
      
        </span></p>
        <div class="clear"></div>
        &nbsp;
        <p class="greybox">Upholstery Fabric Options</p>
        <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
          <tr>
            <td width="11%">Upholstered Base:</td>
            <td width="12%">
              <%If rs("upholsteredbase")<>"" Then%>
              <%=rs("upholsteredbase")%>
              <%End If%>
            </td>
            <td width="11%">Fabric Options: </td>
            <td width="21%">
              <%If rs("basefabric")<>"" Then%>
              <%=rs("basefabric")%>
              <%End If%>
            </td>
            <td width="12%">Fabric Selection:</td>
            <td width="33%"><%If rs("basefabricchoice")<>"" Then%>
              <%=rs("basefabricchoice")%>
              <%End If%></td>
          </tr>
          <tr>
            <td>Base Fabric Direction:</td>
            <td><%If rs("basefabricdirection")<>"" then response.Write(rs("basefabricdirection"))%>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
         <p class="greybox">Base Fabric Description:</p>
        <p><%=rs("basefabricdesc")%>
        <span class="floatpricenotop"> Upholstery £
         <%=rs("upholsteryprice")%>
        
        </span> <br>
    </div>
      <%End If%>
      <div class="clear"></div>
      
      <p class="purplebox"><span class="radiobxmargin">Legs Required</span>&nbsp;
        <%If rs("legsrequired")="y" Then%>
        Yes
        <%Else%>
        No
        <%End If%>
      </p>
	  <% If rs("legsrequired")="y" then%>
      <div id="legs_div">
        <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
          <tr>
            <td width="11%">Leg Style:</td>
            <td width="22%">
              <%If rs("legstyle")<>"" Then%>
             <%=rs("legstyle")%>
             <%if rs("legstyle")="Castors" then response.Write(" : Floor type - " & rs("floortype"))%>
              <%End If%>
            </td>
            <td>Leg Finish: </td>
            <td>
              <%If rs("legfinish")<>"" Then%>
            <%=rs("legfinish")%>
              <%End If%>
            </td>
            <td width="8%">Leg Height:</td>
            <td width="24%">
              <%If rs("legheight")<>"" Then%>
             <%=rs("legheight")%>
              <%End If%>
            </td>
          </tr>
          <tr>
            <td>Standard Legs:</td>
            <td>
              <%If rs("legqty")<>"" Then%>
              <%=rs("legqty")%>
              <%End If%>
            </td>
            <td width="10%">Additional Legs:</td>
            <td width="25%"><%If rs("addlegqty")<>"" Then%>
              <%=rs("addlegqty")%>
              <%End If%></td>
            <td>Legs Total:</td>
            <%Dim TotLegs
			TotLegs=0
			if rs("legqty")<>"" then TotLegs=CInt(rs("legqty"))
			if rs("addlegqty")<>"" then TotLegs=TotLegs + CInt(rs("addlegqty"))%>
            
            <td><%If TotLegs<>0 Then%>
              <%=TotLegs%>
              <%End If%></td>
          </tr>
        </table>
       
        <div class="clear"></div>
         <%if rs("specialinstructionslegs")<>"" then%>
         <p class="greybox">Special Instructions:</p>
        <p><%=rs("specialinstructionslegs")%>
        <span class="floatprice"> Legs £
          <%=rs("legprice")%>
        </span></p>
        <%else%>
        <span class="floatpriceup"> Legs £
          <%=rs("legprice")%>
        </span>
        <%end if%>
        <div class="clear"></div>
        
      </div>
      <%End If%>
      
      
      
      <p class="purplebox"><span class="radiobxmargin">Headboard Required</span>&nbsp;<%If rs("headboardrequired")="y" Then%>
        Yes
        <%Else%>
        No
        
        <%End If%>
      </p>
      <%If rs("headboardrequired")="y" Then%>
      <div id="headboard_div">
        <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
          <tr>
            <td>Headboard Styles:</td>
            <td>
              <%If rs("headboardstyle")<>"" Then%>
             <%=rs("headboardstyle")%>
              <%End If%>
            </td>
            <td width="11%">Fabric Options:</td>
            <td width="21%">
              <%If rs("headboardfabric")<>"" Then%>
              <%=rs("headboardfabric")%>
              <%End If%>
            </td>
            <td width="12%">Fabric Selection:</td>
            <td width="33%"><%If rs("headboardfabricchoice")<>"" Then%>
              <%=rs("headboardfabricchoice")%>
              <%End If%></td>
          </tr>
          <tr>
            <td>Headboard Height:</td>
            <td>
              <%If rs("headboardheight")<>"" Then%>
             <%=rs("headboardheight")%>
              <%End If%>
            </td>
            <td>Headboard Finish:</td>
            <td><%=rs("headboardfinish")%>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>Headboard Fabric Direction:</td>
            <td><%If rs("headboardfabricdirection")<>"" then response.Write(rs("headboardfabricdirection"))%>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
         <p class="greybox">Headboard Fabric Description:</p>
        <p><%=rs("headboardfabricdesc")%></p>
        <p class="greybox">Special Instructions:</p>
        <br><%If rs("headboardstyle")="C1" then%>
        <img src="img/c1.gif" alt="C5" width="77" height="119" hspace="30" align="right">
        <%End If%>
            <%If rs("headboardstyle")="C2" then%>
            <img src="img/c2.gif" alt="C4" width="160" height="131" hspace="30" align="right">
             <%End If%>
            <%If rs("headboardstyle")="C4" then%>
            <img src="img/c4.gif" alt="C2" width="77" height="119" hspace="30" align="right">
            <%End If%>
              <%If rs("headboardstyle")="C5" then%>
              <img src="img/c5.gif" alt="C1" width="77" height="119" hspace="30" align="right">
              <%End If%>
             <%If rs("headboardstyle")="C6" then%>
             <img src="img/c6.gif" alt="C6" width="77" height="119" hspace="30" align="right">
              <%End If%>
            <%If rs("headboardstyle")="M31" then%>
            <img src="img/m31.gif" alt="M31" width="77" height="119" hspace="30" align="right">
              <%End If%>
            <%If rs("headboardstyle")="M32" then%>
           <img src="img/m32.gif" alt="M32" width="160" height="131" hspace="30" align="right">
              <%End If%>
             <%If rs("headboardstyle")="H1" then%>
             <img src="img/holly.gif" alt="Holly" width="77" height="119" hspace="30" align="right">
              <%End If%>
             <%If rs("headboardstyle")="F100" then%>
            <img src="img/f100.gif" alt="F100" width="77" height="119" hspace="30" align="right">
              <%End If%>
<p><%=rs("specialinstructionsheadboard")%>
        <span class="floatprice"> Headboard £
         <%=rs("headboardprice")%>
        </span></p>
        <div class="clear"></div>
    </div>
      <%End If%>
      <p class="purplebox"><span class="radiobxmargin">Valance Required</span>&nbsp;<%If rs("valancerequired")="y" Then%>
        Yes
       <%Else%>
        No
        
        <%End If%>
      </p>
      <%If rs("valancerequired")="y" Then%>
      <div id="valance_div">
        <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
          <tr>
            <td width="11%">No. of Pleats:</td>
            <td width="12%"><%If rs("pleats")<>"" Then %>
             <%=rs("pleats")%></option>
              <%End If%>
            </td>
            <td width="11%">Fabric Options: </td>
            <td width="21%">
              <%If rs("valancefabric")<>"" Then%>
              <%=rs("valancefabric")%>
              <%End If%>
            </td>
            <td width="12%">Fabric Selection:</td>
            <td width="33%">  <%If rs("valancefabricchoice")<>"" Then%>
              <%=rs("valancefabricchoice")%>
              <%End If%></td>
          </tr>
          <tr>
            <td>Valance Fabric Direction:</td>
            <td><%If rs("valancefabricdirection")<>"" then response.Write(rs("valancefabricdirection"))%>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
         <p class="greybox">Valance Fabric Description:</p>
        <p><%=rs("valancefabricdesc")%></p>
        <p class="greybox">Special Instructions:</p>
        <p><%=rs("specialinstructionsvalance")%>
        <span class="floatprice"> Valance £
         <%=rs("valanceprice")%>
       
        </span></p>
        <div class="clear"></div>
    </div>
      <%End If%>
      
<!-- accessories section -->
  <p class="purplebox"><span class="radiobxmargin">Accessories Required</span>&nbsp;<%If rs("accessoriesrequired")="y" Then%>
    Yes
   <%Else%>
    No
    
    <%End If%>
  </p>
<%
If rs("accessoriesrequired")="y" Then
	Set rs3 = getMysqlUpdateRecordSet("select * from orderaccessory where purchase_no=" & purchase_no & " order by orderaccessory_id", con)
	%>
	<div id="accessories_div">
		<table>
		<tr><th>Item&nbsp;No.</th><th>Item&nbsp;Description</th><th>Unit&nbsp;Price</th><th>Quantity</th><th>Delete</th><th>&nbsp;</th></tr>
		<%
		i = 0
		while not rs3.eof
			i = i + 1
		%>
			<tr id="acc_row<%=i%>">
				<td><%=i%></td>
				<td><%=rs3("description")%></td>
				<td><%=fmtCurr2(rs3("unitprice"), true, orderCurrency)%></td>
				<td><%=rs3("qty")%></td>
			</tr>
		<%
			rs3.movenext
		wend
		rs3.close
		set rs3 = nothing
		%>
		</table>
		<p>Accessories total:&nbsp;<%=fmtCurr2(rs("accessoriestotalcost"), true, orderCurrency)%></span></p>
	</div> 
   <div class="clear"></div>
<% end if %>
      
    <p class="purplebox"><span class="radiobxmargin">Delivery Charge</span>&nbsp;<%If rs("deliverycharge")="y" Then%>
        Yes
        <%Else%>
        No
        <%End If%>
    </p>
      <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
        <tr>
        <td width="17%">Access Check Required?</td>
        <td width="38%"><%=rs("accesscheck")%></td>
        <td width="15%">Disposal of old bed</td>
        <td width="30%"><%=rs("oldbed")%>&nbsp; </td>
        </tr>
    </table>
      <%If rs("deliverycharge")="y" Then%>
      <div id="delivery_div">
        <p class="greybox">Special Instructions:</p>
       <p><%=rs("specialinstructionsdelivery")%>
        <span class="floatprice"> Delivery £
        <%=rs("deliveryprice")%>

        </span></p> </div>
      <div class="clear"></div>
      <%End If%>
      <hr>
      <p>
      </p>
    <p>&nbsp;</p>
      <table border="0" align="center" cellpadding="2" cellspacing="2">
        <tr>
          <td colspan="2">
          <%If quote="y" then%>
           <h1 align="center">Quote Summary  - Quote No. <%=rs("order_number")%></h1>
          <%Else%>
           <h1 align="center">Order Summary  - Order No. <%=rs("order_number")%></h1>
          <%End If%>
         </td>
        </tr>
        <%If rs("mattressrequired")="y" Then%>
        <tr>
          <td>Mattress</td>
          <td align="right"><%If rs("mattressprice")<>"" Then%>
            <%=getCurrencySymbolForCurrency(orderCurrency)%>
            <%=fmtCurr2(rs("mattressprice"), false, orderCurrency)%>
            <% end if %></td>
        </tr>
        <%End If
			  If rs("topperrequired")="y" Then%>
        <tr>
          <td>Topper</td>
          <td align="right"><%If rs("topperprice")<>"" Then%>
            <%=getCurrencySymbolForCurrency(orderCurrency)%>
            <%=fmtCurr2(rs("topperprice"), false, orderCurrency)%>
            <% end if %></td>
        </tr> <%End If
			  If rs("legprice")<>"" Then%>
         <tr>
          <td>Leg Price</td>
          <td align="right"><%If rs("legprice")<>"" Then%>
            <%=getCurrencySymbolForCurrency(orderCurrency)%>
            <%=fmtCurr2(rs("legprice"), false, orderCurrency)%>
            <% end if %></td>
        </tr>
        <%End If
			  If rs("baserequired")="y" Then%>
        <tr>
          <td>Base</td>
          <td align="right"><%If rs("baseprice")<>"" Then%>
            <%=getCurrencySymbolForCurrency(orderCurrency)%>
           <%=fmtCurr2(rs("baseprice"), false, orderCurrency)%>
            <% end if %></td>
        </tr>
        <tr>
          <%End If
			  If rs("upholsteredbase")="Yes" Then%>
          <td>Upholstered Base</td>
          <td align="right"><%If rs("upholsteryprice")<>"" Then%>
            <%=getCurrencySymbolForCurrency(orderCurrency)%>
            <%=fmtCurr2(rs("upholsteryprice"), false, orderCurrency)%>
            <% end if %></td>
        </tr>
        <%End If 
			   
			   If rs("headboardrequired")="y" Then%>
        <tr>
          <td>Headboard</td>
          <td align="right"><%If rs("headboardprice")<>"" Then%>
            <%=getCurrencySymbolForCurrency(orderCurrency)%>
            <%=fmtCurr2(rs("headboardprice"), false, orderCurrency)%>
            <% end if %></td>
        </tr>
          <%End If 
			   
			   If rs("hbfabricprice")="y" Then%>
        <tr>
          <td>Headboard Fabric Cost</td>
          <td align="right"><%If rs("hbfabricprice")<>"" Then%>
            <%=getCurrencySymbolForCurrency(orderCurrency)%>
            <%=fmtCurr2(rs("hbfabricprice"), false, orderCurrency)%>
            <% end if %></td>
        </tr>
        <%End If
			  If rs("valancerequired")="y" Then%>
        <tr>
          <td>Valance</td>
          <td align="right"><%If rs("valanceprice")<>"" Then%>
            <%=getCurrencySymbolForCurrency(orderCurrency)%>
            <%=fmtCurr2(rs("valanceprice"), false, orderCurrency)%>
            <% end if %></td>
        </tr>
        <%End If
			  If rs("valfabricprice")<>"" Then%>
        <tr>
          <td>Valance Fabric Price</td>
          <td align="right"><%If rs("valfabricprice")<>"" Then%>
            <%=getCurrencySymbolForCurrency(orderCurrency)%>
            <%=fmtCurr2(rs("valfabricprice"), false, orderCurrency)%>
            <% end if %></td>
        </tr>
        <%End If
			  If rs("accessoriesrequired")="y" Then%>
        <tr>
          <td>Accessories</td>
          <td align="right"><%=fmtCurr2(rs("accessoriestotalcost"), true, orderCurrency)%></td>
        </tr>
        <%End If
			  If rs("bedsettotal")<>"" Then%>
        <tr>
          <td><strong>Bed Set Total</strong></td>
          <td align="right"><%=getCurrencySymbolForCurrency(orderCurrency)%>
            <%=fmtCurr2(rs("bedsettotal"), false, orderCurrency)%></td>
        </tr>
        <%If rs("discount") <>"" Then %>
        <tr>
          <td>DC 
          <%If rs("discounttype")="percent" then%>
            Percent
            <%End If%>
             <%If rs("discounttype")="currency" then%>
            Amount <%=getCurrencySymbolForCurrency(orderCurrency)%>
            <%End If%>
          </td>
          <td align="right"><%If rs("discount")<>"" then response.Write(rs("discount"))%></td>
        </tr>
        <%End if%>
        <tr>
          <td><strong>Sub Total</strong></td>
          <td align="right"><%=getCurrencySymbolForCurrency(orderCurrency)%><%=fmtCurr2(rs("subtotal"), false, orderCurrency)%></td>
        </tr>
        <tr>
          <td>Delivery Charge</td>
          <td align="right"><%If rs("deliveryprice")<>"" Then%>
          <%=getCurrencySymbolForCurrency(orderCurrency)%> <%=fmtCurr2(rs("deliveryprice"), false, orderCurrency)%>
          <%End If%></td>
        </tr>
        <% if rs("tradediscount") <> "" then %>
		  <tr>
		    <td>Trade Discount</td>
            <td align="right"><%=getCurrencySymbolForCurrency(orderCurrency)%><%=fmtCurr2(rs("tradediscount"), false, orderCurrency)%></td>
	      </tr>
        <% end if %>
        <% if rs("totalexvat") <> "" then %>
		  <tr>
		    <td>Total excluding VAT</td>
            <td align="right"><%=getCurrencySymbolForCurrency(orderCurrency)%><%=fmtCurr2(rs("totalexvat"), false, orderCurrency)%></td>
	      </tr>
		  <tr>
		    <td>VAT</td>
            <td align="right"><%=getCurrencySymbolForCurrency(orderCurrency)%><%=fmtCurr2(rs("vat"), false, orderCurrency)%></td>
	      </tr>
        <% end if %>
        <tr>
          <td><strong>TOTAL</strong></td>
          <td align="right">
          <%'If rs("subtotal") <>"" Then
		  if rs("total")<>"" or Not IsNull(rs("total")) then%>
         <%=getCurrencySymbolForCurrency(orderCurrency)%> <%=fmtCurr2(Cint(rs("total")), false, orderCurrency)%>
         <%End If%>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td align="right">&nbsp;</td>
        </tr>
        <%If quote <> "y" then%>
        	<% if ubound(payments) > 0 then %>
			     <tr><td colspan="2"><table>
			     <tr><td><b>Payments Made</b></td></tr>
			     <tr>
			     	<td>Type</td><td>Payment Method</td><td>Date</td><td>Receipt No.</td><td>Amount</td><td>Credit Details</td>
			     </tr>
			     <%
			     paymentSum = 0.0
			     for n = 1 to ubound(payments)
				     paymentSum = paymentSum + payments(n).amount
				     %>
				     <tr>
				       <td><%=payments(n).paymentType%></td>
				       <td><%=payments(n).paymentMethod%></td>
                       <td><%=payments(n).placed%></td>
				       <td><%=payments(n).receiptNo%></td>
				       <td><%=fmtCurr2(abs(payments(n).amount), true, orderCurrency)%></td>
				       <% if payments(n).creditDetails <> "" then %>
				       	   <td><%=payments(n).creditDetails%></td>
				       <% end if %>
				     </tr>
			     <%next%>
			     </table></td></tr>
        	<% end if %>
        <tr>
          <td>Payments Total</td>
          <td align="right"><%If rs("paymentstotal")<>"" Then%>
		  <%=getCurrencySymbolForCurrency(orderCurrency)%><%=fmtCurr2(rs("paymentstotal"), false, orderCurrency)%>
          <%End If%></td>
        </tr>
        <tr>
          <td><strong>Balance Outstanding</strong></td>
          <td align="right"><%If rs("balanceoutstanding")<>"" Then%>
       <%=getCurrencySymbolForCurrency(orderCurrency)%>  <%=fmtCurr2(rs("balanceoutstanding"), false, orderCurrency)%>
       <%End If%></td>
        </tr><%End If%>
        <tr>
          <td>&nbsp;</td>
          <td align="right">&nbsp;</td>
        </tr>
        <%End If%>
      </table>
  </div>
</div>
<div class="clear">&nbsp;</div>
<%rs1.close
set rs1=nothing
rs.close
set rs=nothing

If retrieveuserregion()=1 then
Set rs = getMysqlQueryRecordSet("Select * from location where idlocation=1", con)
else
Set rs = getMysqlQueryRecordSet("Select * from location where idlocation=" & retrieveuserlocation(), con)
end if
if remakeguarantee="y" then displayterms=rs("remakeguarantee") 
displayterms=displayterms & rs("terms")
rs.close
set rs=nothing%>
<div><%=displayterms%><p> I have read and understood, the terms and conditions above</p>
<% if signature <> "" then %>
	<p>Customer Signature: <%=custname%></p>
	<div class="sigPad">
	<div class="sigPad sig sigWrapper">
	<canvas class="pad" width="198" height="55"></canvas>
	</div>
	</div>
<% end if %>
</div>
       
</body>
</html>

<% if signature <> "" then %>
	<script src="http://static.thomasjbradley.ca/lab/signature-pad/jquery.signaturepad.min.js"></script>
	<script Language="JavaScript" type="text/javascript">
	var sig = '<%=signature%>';
	$(document).ready( function(){
	  $('.sigPad').signaturePad({displayOnly:true}).regenerate(sig);
	})
	</script>
	<script src="scripts/json2.min.js"></script>
<% end if %>
  
<script Language="JavaScript" type="text/javascript">
<!--

$(document).ready(init());
function init() {
	tickingSelected();
	$("#tickingoptions").change(tickingSelected);
	headboardstyle();
	$("#headboardstyle").change(headboardstyle);
	
	mattressChanged();
	topperChanged();
	baseChanged();
	headboardChanged();
	valanceChanged();
	deliveryChanged();
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
	} else if (selection == "H1 - Holly") {
		$('#tick12').show();
	} else if (selection == "F100") {
		$('#tick13').show();
	}
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
}



function FrontPage_Form1_Validator(theForm)
{
 
   if (theForm.correspondencename.value == "")
  {
    alert("You need to give this correspondence a name so you can refer to it later");
    theForm.correspondencename.focus();
    return (false);
  }

 

    return true;
} 

//-->
</script>
<script Language="JavaScript" type="text/javascript">
<!--
	window.onload = init();
	function init() {
		//alert("init called");
		populateFabricDropdown(document.form1.basefabric);
		populateFabricDropdown(document.form1.headboardfabric);
		populateFabricDropdown(document.form1.valancefabric);
	};
	
	function populateFabricDropdown(e) {s
		var url = "find-fabric-ajax.asp?fabric="+e.options[e.selectedIndex].value + "&name=" + e.name + "&ts=" + (new Date()).getTime();
		//alert("url = " + url);
		if (e.name=="basefabric") {
			$('#basefabric_div').load(url);
		} else if (e.name=="headboardfabric") {
			$('#headboardfabric_div').load(url);
			//alert("e.name = " + e.name);
		} else {
			$('#valancefabric_div').load(url);
			//alert("e.name = " + e.name);
		}
	}

	function defaultBaseModel() {
		var slct = $("#savoirmodel option:selected").val();
		$("#basesavoirmodel option[value='" + slct + "']").attr('selected', 'selected');
	}
	
	function defaultBaseType() {
		var slct = $("#mattresstype option:selected").val();
		if (slct && slct.substring(0, 11) == 'Zipped Pair') {
			slct = "Linked Pair";
		}
		$("#basetype option[value='" + slct + "']").attr('selected', 'selected');
	}

	function defaultBaseWidth() {
		var slct = $("#mattresswidth option:selected").val();
		$("#basewidth option[value='" + slct + "']").attr('selected', 'selected');
		$("#topperwidth option[value='" + slct + "']").attr('selected', 'selected');
	}

	function defaultBaseLength() {
		var slct = $("#mattresslength option:selected").val();
		$("#topperlength option[value='" + slct + "']").attr('selected', 'selected');
	}

	function defaultLinkFinish() {
		var slct = $("#ventfinish option:selected").val();
		if (slct == 'Brass Vents' || slct == 'Chrome Vents') {
			slct = slct + " and Link Bar";
		}
		$("#linkfinish option[value='" + slct + "']").attr('selected', 'selected');
	}

	function defaultTopperTickingOptions() {
		var slct = $("#tickingoptions option:selected").val();
		$("#toppertickingoptions option[value='" + slct + "']").attr('selected', 'selected');
	}

//-->
</script> 
<%

function capitalise(str)
dim words, word
if isNull(str) or trim(str)="" then
	capitalise=""
else
	words = split(trim(str), " ")
	for each word in words
		word = lcase(word)
		word = ucase(left(word,1)) & (right(word,len(word)-1))
		capitalise = capitalise & word & " "
	next
	capitalise = left(capitalise, len(capitalise)-1)
end if

end function
con.close
set con=nothing
%>
<!-- #include file="common/logger-out.inc" -->
