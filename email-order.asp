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
<!-- #include file="emailfuncs.asp" -->
<%Dim val, rs, rs1, rs2, rs3, rs4, con, localeref, regiontel, regionemail, staffcontact, localtel, contactname, sql, msg, contactno
Set Con = getMysqlConnection()
val=request("val")
localeref=retrieveuserregion()
staffcontact=retrieveUserName()
Set rs = getMysqlUpdateRecordSet("Select * from savoir_user WHERE username='" & staffcontact & "'", con)
	Set rs1 = getMysqlUpdateRecordSet("Select * from location WHERE idlocation=" & rs("id_location"), con)
	localtel=rs1("tel")
	regionemail=rs1("email")
	contactname=rs("name")
	rs1.close
	set rs1=nothing
rs.close
set rs=nothing
sql="Select * from region WHERE id_region=" & localeref
'REsponse.Write("sql=" & sql)	
Set rs = getMysqlUpdateRecordSet(sql, con)
Session.LCID = rs("locale")
rs.close
set rs=nothing
Set rs = getMysqlQueryRecordSet("Select * from purchase WHERE purchase_no=" & val & "", con)
Set rs1 = getMysqlQueryRecordSet("Select * from contact WHERE code=" & rs("code") & "", con)
contactno=rs1("contact_no")
Set rs2 = getMysqlQueryRecordSet("Select * from address WHERE code=" & rs1("code") & "", con)
msg="<html><body><font face=""Arial, Helvetica, sans-serif"">Dear " & rs1("title") & " " & rs1("surname") & ", many thanks for requesting information regarding your future Savoir Bed.  I have attached to this email a quote based on your requirements.  Should you wish to proceed or to discuss your requirements in finer detail then please do contact me on " & localtel & " or please email at <a href=""mailto:" & regionemail & """>" & regionemail & "</a><br /><br /> Yours Sincerely<br />" & contactname & "  <br /><br />Please do not reply to this email, this is sent from an unchecked email address."
msg=msg & "<br /><br /><b>Pricing is subject to change.  This quote is valid for 60 days</b></p>"

msg=msg & "<b>QUOTE</b><br /><table width=""98%"" border=""1""  cellpadding=""3"" cellspacing=""0"">"
msg=msg & "<tr><td width=""10%"">Quote from:</td><td width=""23%"">" & retrieveUserName() & "</td>"
msg=msg & "<td colspan=""2"">Invoice Address:</td><td colspan=""2"">Delivery Address:</td></tr>"
msg=msg & "<tr><td>Order No:</td><td>" & rs("order_number") & "</td>"
msg=msg & "<td width=""8%"">Line 1: </td><td width=""28%"">" & rs2("street1") & "</td>"
msg=msg & "<td width=""8%"">Line 1: </td><td width=""23%"">" & rs("deliveryadd1") & "</td></tr>"
msg=msg & "<tr><td>Date of order: </td><td>" & rs("order_date") & "</td>"
msg=msg & "<td>Line 2: </td><td>" & rs2("street2") & "</td>"
msg=msg & "<td>Line 2: </td><td>" & rs("deliveryadd2") & "</td></tr>"
msg=msg & "<tr><td>Customer Reference:</td><td>" & rs("customerreference") & "</td>"
msg=msg & "<td>Line 3:</td><td>" & rs2("street3") & "</td>"
msg=msg & "<td>Line 3:</td><td>" & rs("deliveryadd3") & "</td></tr>"
msg=msg & "<tr><td>Clients Title:</td><td>" & rs1("title") & "</td>"
msg=msg & "<td>Town: </td><td>" & rs2("town") & "</td>"
msg=msg & "<td>Town: </td><td>" & rs("deliverytown") & "</td></tr>"
msg=msg & "<tr><td>First Name:</td><td>" & rs1("first") & "</td>"
msg=msg & "<td>County: </td><td>" & rs2("county") & "</td>"
msg=msg & "<td>County: </td><td>" & rs("deliverycounty") & "</td></tr>"
msg=msg & "<tr><td>Surname:</td><td>" & rs1("surname") & "</td>"
msg=msg & "<td>Postcode: </td><td>" & rs2("postcode") & "</td>"
msg=msg & "<td>Postcode: </td><td>" & rs("deliverypostcode") & "</td></tr>"
msg=msg & "<tr><td>Approx. Delivery Date:</td><td>" & getRoundedApproxDateDescription(rs("deliverydate")) & "</td>"
msg=msg & "<td>Country: </td><td>" & rs2("country") & "</td>"
msg=msg & "<td>Country: </td><td>" & rs("deliverycountry") & "</td></tr>"
	msg=msg & "<tr><td>Company Name: </td><td>" & rs("companyname") & "</td><td>Contact Details</td><td>Tel Home: " & rs2("tel")& "<br />Tel Work: " & rs1("telwork") & "<br />Mobile: " & rs1("mobile") & "</td><td>Email Address:</td><td>" & rs2("email_address") & "</td></tr>"
msg=msg & "</table>"
msg=msg & vbnewline & vbnewline
'msg=msg & "<p class=""purplebox""><b>Delivery Instructions</b></p>"
'msg=msg & "<p>" & rs("deliveryinstructions") & "</p>"

msg=msg & vbnewline & vbnewline

msg=msg & "<b>MATTRESS</b>"
If rs("mattressrequired")="y" then
msg=msg & vbnewline & vbnewline
msg=msg & "<table width=""98%"" border=""1"" cellpadding=""3"" cellspacing=""0"">"
msg=msg & "<tr><td width=""11%"">Savoir Model:</td><td width=""22%"">" & rs("savoirmodel") & "</td>"
msg=msg & "<td width=""10%"">Mattress Type: </td><td>" & rs("mattresstype") & "</td>"
msg=msg & "<td width=""8%"">Ticking Options</td><td width=""24%"">" & rs("tickingoptions") & "</td></tr>"
msg=msg & "<tr><td>Mattress Width:</td><td>" & rs("mattresswidth") & "</td>"
msg=msg & "<td width=""10%"">Mattress Length: </td><td width=""25%"">" & rs("mattresslength") & "</td><td colspan=""2"">"
If rs("tickingoptions")="White Trellis" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/white-trellis.jpg"" align=""right"">"
If rs("tickingoptions")="Grey Trellis" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/grey-trellis.jpg"" align=""right"">"
If rs("tickingoptions")="Silver Trellis" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/silver-trellis.jpg"" align=""right"">"
If rs("tickingoptions")="Oatmeal Trellis" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/oatmeal-trellis.jpg"" align=""right"">"
msg=msg & "&nbsp;</td></tr></table>"
msg=msg & vbnewline & vbnewline
msg=msg & "<p><b>Support (as viewed from the foot looking toward the head end):</b></p>"
msg=msg & "<table width=""98%"" border=""1"" cellpadding=""3"" cellspacing=""0"">"
msg=msg & "<tr><td width=""11%"">Left Support:</td><td width=""14%"">" & rs("leftsupport") & "</td>"
msg=msg & "<td width=""11%"">Right Support: </td><td width=""13%"">" & rs("rightsupport") & "</td>"
msg=msg & "<td width=""11%"">Vent Position:</td><td width=""16%"">" & rs("ventposition") & "</td>"
msg=msg & "<td width=""10%"">Vent Finish:</td><td width=""14%"">" & rs("ventfinish") & "</td></tr></table>"
msg=msg & vbnewline & vbnewline
msg=msg & "<p class=""greybox""><b>Special Instructions:</b></p>"
msg=msg & "<p>"
msg=msg & rs("mattressinstructions")
msg=msg & "</p><p>"
If rs("mattressprice")<>"" Then
msg=msg & "<b>Mattress Price </b>" & Ccur(rs("mattressprice"))
End If
msg=msg & "</p>"
else
msg=msg & "<p>No mattress required</p>"
end if
msg=msg & "<br />"

msg=msg & "<b>TOPPER</b><br />"
If rs("topperrequired")="y" Then
msg=msg & "<table width=""98%"" border=""1"" cellpadding=""3"" cellspacing=""0"">"
msg=msg & "<tr><td width=""11%"">Topper Type:</td><td width=""22%"">" & rs("toppertype") & "</td>"
msg=msg & "<td>Topper Width: </td><td>" & rs("topperwidth") & "</td>"
msg=msg & "<td width=""8%"">Topper Length:</td><td width=""24%"">" & rs("topperlength") & "</td></tr>"
msg=msg & "<tr><td>Ticking Options:</td><td>" & rs("toppertickingoptions") & "</td>"
msg=msg & "<td width=""10%"">&nbsp;</td><td width=""25%"">&nbsp;</td><td>&nbsp;</td><td>"
If rs("toppertickingoptions")="White Trellis" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/white-trellis.jpg"" align=""right"">"
If rs("toppertickingoptions")="Grey Trellis" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/grey-trellis.jpg"" align=""right"">"
If rs("toppertickingoptions")="Silver Trellis" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/silver-trellis.jpg"" align=""right"">"
If rs("toppertickingoptions")="Oatmeal Trellis" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/oatmeal-trellis.jpg"" align=""right"">"
msg=msg & "&nbsp;</td></tr></table>"
msg=msg & vbnewline & vbnewline
msg=msg & "<p class=""greybox""><b>Special Instructions:</b></p>"
msg=msg & "<p>"
msg=msg & rs("specialinstructionstopper")
msg=msg & "</p><p>"
msg=msg & "<b>Topper Price </b>" & rs("topperprice")
msg=msg & "</p>"
else
msg=msg & "<p>No topper required</p>"
end if
msg=msg & "<br />"

msg=msg & "<b>BASE</b><br />"
If rs("baserequired")="y" Then
msg=msg & "<table width=""98%"" border=""1"" cellpadding=""3"" cellspacing=""0"">"
msg=msg & "<tr><td>Savoir Model:</td><td>" & rs("basesavoirmodel") & "</td>"
msg=msg & "<td>Base Type:</td><td>" & rs("basetype") & "</td>"
msg=msg & "<td>Base Width: </td><td>" & rs("basewidth") & "</td></tr>"
msg=msg & "<tr><td>Base Length:</td><td>" & rs("baselength") & "</td>"
msg=msg & "<td>Leg Style:</td><td>" & rs("legstyle") & "</td>"
msg=msg & "<td>Leg Finish: </td><td>" & rs("legfinish") & "</td></tr>"
msg=msg & "<tr><td>Leg Height:</td><td>" & rs("legheight") & "</td>"
msg=msg & "<td>Link Position:</td><td>" & rs("linkposition") & "</td>"
msg=msg & "<td>Link Finish</td><td>" & rs("linkfinish") & "</td></tr>"
msg=msg & "<tr><td>Extended Base:</td><td>" & rs("extbase") & "</td>"
msg=msg & "<td>&nbsp;</td><td>&nbsp;</td> <td>&nbsp;</td> <td>&nbsp;</td> </tr></table>"
msg=msg & vbnewline & vbnewline
msg=msg & "<p class=""greybox""><b>Special Instructions:</b></p>"
msg=msg & "<p>"
msg=msg & rs("baseinstructions")
msg=msg & "</p><p>"
msg=msg & "<b>Base Price </b>" & rs("baseprice")
msg=msg & "</p>"
else
msg=msg & "<p>No base required</p>"
end if
msg=msg & "<br />"
msg=msg & "<p class=""greybox""><b>Upholstery Fabric Options</b></p>"
msg=msg & "<table width=""98%"" border=""1"" cellpadding=""3"" cellspacing=""0"">"
msg=msg & "<tr><td width=""11%"">Upholstered Base:</td>"
msg=msg & "<td width=""12%"">" & rs("upholsteredbase") & "</td>"
msg=msg & "<td width=""11%"">Fabric Options: </td><td width=""21%"">" & rs("basefabric") & "</td>"
msg=msg & "<td width=""12%"">Fabric Selection:</td><td width=""33%"">" & rs("basefabricchoice") & "</td></tr>"
msg=msg & "<tr><td width=""11%"">Base Fabric Direction:</td>"
msg=msg & "<td>" & rs("basefabricdirection") & "</td>"
msg=msg & "<td>&nbsp;</td><td>&nbsp;</td>"
msg=msg & "<td>&nbsp;</td></tr></table>"

msg=msg & vbnewline & vbnewline
msg=msg & "<p class=""greybox""><b>Base Fabric Description:</b></p>"
msg=msg & "<p>"
msg=msg & rs("basefabricdesc")
msg=msg & "</p><p>"
msg=msg & "<b>Upholstery Price </b>" & rs("upholsteryprice")
msg=msg & "</p><br />"

msg=msg & "<b>HEADBOARD</b>"
IF rs("headboardrequired")="y" Then
msg=msg & "<table width=""98%"" border=""1"" cellpadding=""3"" cellspacing=""0"">"
msg=msg & "<tr><td>Headboard Styles:</td><td>" & rs("headboardstyle") & "</td>"
msg=msg & "<td width=""11%"">Fabric Options:</td><td width=""21%"">" & rs("headboardfabric") & "</td>"
msg=msg & "<td width=""12%"">Fabric Selection:</td><td width=""33%"">" & rs("headboardfabricchoice") & "</td></tr>"
msg=msg & "<tr><td>Headboard Height:</td><td>" & rs("headboardheight") & "</td><td>Headboard Finish:</td><td>" & rs("headboardfinish") & "&nbsp;</td><td>&nbsp;</td><td>"
If rs("headboardstyle")="C5" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/c5.gif"" align=""right"">"
If rs("headboardstyle")="C4" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/c4.gif"" align=""right"">"
If rs("headboardstyle")="C2" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/c2.gif"" align=""right"">"
If rs("headboardstyle")="C1" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/c1.gif"" align=""right"">"
If rs("headboardstyle")="C6" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/c6.gif"" align=""right"">"
If rs("headboardstyle")="M31" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/m31.gif"" align=""right"">"
If rs("headboardstyle")="M32" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/m32.gif"" align=""right"">"
If rs("headboardstyle")="Holly" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/holly.gif"" align=""right"">"
If rs("headboardstyle")="F100" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/f100.gif"" align=""right"">"
msg=msg & "&nbsp;</td></tr>"
msg=msg & "<tr><td>Headboard Fabric Direction</td><td>" & rs("headboardfabricdirection") & "</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr></table>"
msg=msg & vbnewline & vbnewline
msg=msg & "<p class=""greybox""><b>Headboard Fabric Description:</b></p>"
msg=msg & "<p>"
msg=msg & rs("headboardfabricdesc")
msg=msg & "</p>"
msg=msg & "<p class=""greybox""><b>Special Instructions:</b></p>"
msg=msg & "<p>"
msg=msg & rs("specialinstructionsheadboard")
msg=msg & "</p><p>"
msg=msg & "<b>Headboard Price </b>" & rs("headboardprice")
msg=msg & "</p>"
    
else
msg=msg & "<p>No headboard required</p>"
end if
msg=msg & "<br /> "

msg=msg & "<b>VALANCE</b><br />"
If rs("valancerequired")="y" Then
msg=msg & "<table width=""98%"" border=""1"" cellpadding=""3"" cellspacing=""0"">"
msg=msg & "<tr><td width=""11%"">No. of Pleats:</td><td width=""12%"">" & rs("pleats") & "</td>"
msg=msg & "<td width=""11%"">Fabric Options: </td><td width=""21%"">" & rs("valancefabric") & "</td>"
msg=msg & "<td width=""12%"">Fabric Selection:</td><td width=""33%"">" & rs("valancefabricchoice") & "</td></tr>"
msg=msg & "<tr><td width=""11%"">Valance Fabric Direction:</td><td width=""12%"">" & rs("valancefabricdirection") & "</td>"
msg=msg & "<td width=""11%"">&nbsp;</td><td width=""21%"">&nbsp;</td>"
msg=msg & "<td width=""12%"">&nbsp;</td><td width=""33%"">&nbsp;</td></tr></table>"
msg=msg & vbnewline & vbnewline
msg=msg & "<p class=""greybox""><b>Valance Fabric Description:</b></p>"
msg=msg & "<p>"
msg=msg & rs("valancefabricdesc")
msg=msg & "</p>"
msg=msg & "<p class=""greybox""><b>Special Instructions:</b></p>"
msg=msg & "<p>"
msg=msg & rs("specialinstructionsvalance")
If rs("valanceprice")<>"" then
msg=msg & "</p><p><b>Valance Price: </b>  " & CCur(rs("valanceprice"))
End If
msg=msg & "</p>"
else
msg=msg & "<p>No valance required</p>"
end if
msg=msg & "<br /> "
sql="Select * from orderaccessory where purchase_no=" & val
Set rs4 = getMysqlQueryRecordSet(sql, con)
if not rs4.eof then
msg=msg & "<b>ACCESSORIES</b><br /><table width=""98%"" border=""1"" cellpadding=""3"" cellspacing=""0""><tr><td><b>Description</b></td><td><b>Unit Price</b></td><td><b>Qty</b></td></tr>"
do until rs4.eof
msg=msg & "<tr><td>" & rs4("description") & "</td><td>" & CCur(rs4("unitprice")) & "</td><td>" & rs4("qty") & "</td></tr>"
rs4.movenext
loop
msg=msg & "</table>"
end if
rs4.close
set rs4=nothing

msg=msg & "<p><b>DELIVERY CHARGE</b></p>"
msg=msg & "<p>Access Check Required: " & rs("accesscheck") & "</p>"
If rs("deliverycharge")="y" Then
If rs("specialinstructionsdelivery") <> "" Then msg=msg & "<p><b>Special Instructions: </b></p><p>" & rs("specialinstructionsdelivery") & "</p> "
If rs("deliveryprice") <> "" Then msg=msg & "<p><b>Delivery Charge: </b>  " & CCur(rs("deliveryprice")) & "</p> "

else
msg=msg & "<p>No delivery charge</p>"
end if
msg=msg & "<p>Dispose of Old Bed? " & rs("oldbed") & "</p>"
msg=msg & "<br /> "
msg=msg & "<table width=""563"" border=""1"" cellpadding=""0"" cellspacing=""2"">"
msg=msg & "<tr><td colspan=""2""><strong>Order Summary - Order No. " & rs("order_number") & "</strong></td></tr>"
msg=msg & "<tr><td width=""296"">Mattress</td><td width=""253"">" & rs("mattressprice") & "</td></tr>"
msg=msg & "<tr><td>Topper</td><td width=""253"">" & rs("topperprice") & "</td></tr>"
msg=msg & "<tr><td>Leg Price</td><td width=""253"">" & rs("legprice") & "</td></tr>"
msg=msg & "<tr><td>Base</td><td width=""253"">" & rs("baseprice") & "</td></tr>"
msg=msg & "<tr><td>Upholstered Base</td><td>" & rs("upholsteryprice") & "</td></tr>"
msg=msg & "<tr><td>Base Fabric Price</td><td>" & rs("basefabricprice") & "</td></tr>"
msg=msg & "<tr><td>Headboard</td><td width=""253"">" & rs("headboardprice") & "</td></tr>"
msg=msg & "<tr><td>Headboard Fabric Price</td><td>" & rs("hbfabricprice") & "</td></tr>"
msg=msg & "<tr><td>Valance</td><td width=""253"">" & rs("valanceprice") & "</td></tr>"
msg=msg & "<tr><td>Valance Fabric Price</td><td>" & rs("valfabricprice") & "</td></tr>"
msg=msg & "<tr><td>Accessories Total Cost</td><td>" & rs("accessoriestotalcost") & "</td></tr>"
msg=msg & "<tr><td><strong>Bed Set Total</strong></td><td>" & rs("bedsettotal") & "</td></tr>"
If rs("discount")<>"" then msg=msg & "<tr><td>DC &nbsp;&nbsp;" & rs("discounttype") & "</td><td>" & rs("discount") & "</td></tr>"
msg=msg & "<tr><td><strong>Sub Total</strong></td><td>" & rs("subtotal") & "</td></tr>"
msg=msg & "<tr><td>Delivery Charge</td><td>" & rs("deliveryprice") & "</td></tr>"
msg=msg & "<tr><td><strong>TOTAL</strong></td><td>" & rs("total") & "</td></tr>"
msg=msg & "<tr><td>Payments Total</td><td>" & rs("paymentstotal") & "</td></tr>"
msg=msg & "<tr><td><strong>Balance Outstanding</strong></td><td>" & rs("balanceoutstanding") & "</td></tr>"

msg=msg & "</table>"
msg=msg & "</font></body></html>"

If rs2("email_address")="" or ISNULL(rs2("email_address"))  then
response.write("Customer does not have an email address listed <a href=""editcust.asp?val=" & contactno & """>Go back to customer record</a>") 
rs.close
set rs=nothing
rs1.close
set rs1=nothing
rs2.close
set rs2=nothing
con.close
set con=nothing
response.End()
else

	call sendBatchEmail(rs1("title") & " " & rs1("surname") & " Savoir Quote " & rs("order_number"), msg, "noreply@savoirbeds.co.uk", rs2("email_address"), "", "", true, con)

end if
rs.close
set rs=nothing
rs1.close
set rs1=nothing
rs2.close
set rs2=nothing
con.close
set con=nothing
response.redirect("editcust.asp?val=" & contactno & "&msg=esent")%>

<!-- #include file="common/logger-out.inc" -->
