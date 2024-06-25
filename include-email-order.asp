<%
if deldate <> "" then
deldate1=day(deldate) & "/" & month(deldate) & "/" & year(deldate)
else
	deldate1 = ""
end if
msg="<html><body><font face=""Arial, Helvetica, sans-serif"">"
If isamendment then msg=msg & "<b>AMENDED ORDER</b><br /><br />"
msg=msg & "<b>CUSTOMER DETAILS</b><br /><table width=""98%"" border=""1""  cellpadding=""3"" cellspacing=""0"">"
msg=msg & "<tr><td width=""10%"">Contact:</td><td width=""23%"">" & contact & "</td>"
msg=msg & "<td colspan=""2"">Invoice Address:</td><td colspan=""2"">Delivery Address:</td></tr>"
msg=msg & "<tr><td>Order No:</td><td>" & orderno & "</td>"
msg=msg & "<td width=""8%"">Line 1: </td><td width=""28%"">" & add1 & "</td>"
msg=msg & "<td width=""8%"">Line 1: </td><td width=""23%"">" & add1d & "</td></tr>"
msg=msg & "<tr><td>Date of order: </td><td>" & orderdate & "</td>"
msg=msg & "<td>Line 2: </td><td>" & add2 & "</td>"
msg=msg & "<td>Line 2: </td><td>" & add2d & "</td></tr>"
msg=msg & "<tr><td>Customer Reference:</td><td>" & reference & "</td>"
msg=msg & "<td>Line 3:</td><td>" & add3 & "</td>"
msg=msg & "<td>Line 3:</td><td>" & add3d & "</td></tr>"
msg=msg & "<tr><td>Clients Title:</td><td>" & clientstitle & "</td>"
msg=msg & "<td>Town: </td><td>" & town & "</td>"
msg=msg & "<td>Town: </td><td>" & townd & "</td></tr>"
msg=msg & "<tr><td>First Name:</td><td>" & clientsfirst & "</td>"
msg=msg & "<td>County: </td><td>" & county & "</td>"
msg=msg & "<td>County: </td><td>" & countyd & "</td></tr>"
msg=msg & "<tr><td>Surname:</td><td>" & clientssurname & "</td>"
msg=msg & "<td>Postcode: </td><td>" & postcode & "</td>"
msg=msg & "<td>Postcode: </td><td>" & postcoded & "</td></tr>"
msg=msg & "<tr><td>Tel Home:</td><td>" & tel & "</td>"
msg=msg & "<td>Country: </td><td>" & country & "</td>"
msg=msg & "<td>Country: </td><td>" & countryd & "</td></tr>"


msg=msg & "<tr><td>Tel Work: </td><td>" & telwork & "</td><td>Company Name: </td><td>" & companyname & "</td><td>Contact number 1:</td><td>" & makeContactNumberString(delphonetype1, delphone1) & "</td></tr>"
msg=msg & "<tr><td>Mobile: </td><td>" & mobile & "</td><td></td><td></td><td>Contact number 2:</td><td>" & makeContactNumberString(delphonetype2, delphone2) & "</td></tr>"
msg=msg & "<tr><td></td><td></td><td></td><td></td><td>Contact number 3:</td><td>" & makeContactNumberString(delphonetype3, delphone3) & "</td></tr>"
msg=msg & "<tr><td>Email: </td><td>" & email_address & "</td><td></td><td></td><td></td><td></td></tr>"
msg=msg & "<tr><td>Order Type: </td><td>" & ordertypename & "</td><td>Approx. Delivery Date:</td><td>" & deldate1 & "</td><td>Booked Delivery Date: </td><td>" & bookeddeliverydate & "</td></tr>"

msg=msg & "</table>"

if ordernote_notetext <> "" then
	msg=msg & vbnewline & vbnewline
	msg=msg & "<br/>"
	msg=msg & "<b>ORDER NOTES</b>"
	msg=msg & "<table width=""98%"" border=""1"" align=""center"" cellpadding=""3"" cellspacing=""0"">"
	msg=msg & "<tr><td>Note Text</td><td>Follow-up date</td><td>Action</td></tr>"
	msg=msg & "<tr>"
	msg=msg & "<td>" & ordernote_notetext & "</td>"
	msg=msg & "<td>" & ordernote_followupdate & "&nbsp;</td>"
	msg=msg & "<td>" & ordernote_action & "</td>"
	msg=msg & "</tr>"
    msg=msg & "</table>"
end if

msg=msg & vbnewline & vbnewline
'msg=msg & "<p class=""purplebox""><b>Delivery Instructions</b></p>"
'msg=msg & "<p>" & deliveryinstructions & "</p>"

msg=msg & vbnewline & vbnewline
msg=msg & "<br />"
msg=msg & "<b>MATTRESS</b>"
If mattressrequired="y" then
msg=msg & vbnewline & vbnewline
msg=msg & "<table width=""98%"" border=""1"" cellpadding=""3"" cellspacing=""0"">"
msg=msg & "<tr><td width=""11%"">Savoir Model:</td><td width=""22%"">" & savoirmodel & "</td>"
msg=msg & "<td width=""10%"">Mattress Type: </td><td>" & mattresstype & "</td>"
msg=msg & "<td width=""8%"">Ticking Options</td><td width=""24%"">" & tickingoptions & "</td></tr>"
msg=msg & "<tr><td>Mattress Width:</td><td>" & mattresswidth & ""
If matt1width<>"" then
msg=msg & " Mattress 1 Width: " & matt1width & ""
end if
If matt2width<>"" then
msg=msg & " Mattress 2 Width: " & matt2width & ""
end if
msg=msg & "</td>"
msg=msg & "<td width=""10%"">Mattress Length: </td><td width=""25%"">" & mattresslength & ""
If matt1length<>"" then
msg=msg & " Mattress 1 Length: " & matt1length & ""
end if
If matt2length<>"" then
msg=msg & " Mattress 2 Length: " & matt2length & ""
end if
msg=msg & "</td><td colspan=""2"">"
If tickingoptions="White Trellis" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/white-trellis.jpg"" align=""right"">"
If tickingoptions="Grey Trellis" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/grey-trellis.jpg"" align=""right"">"
If tickingoptions="Silver Trellis" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/silver-trellis.jpg"" align=""right"">"
If tickingoptions="Oatmeal Trellis" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/oatmeal-trellis.jpg"" align=""right"">"
msg=msg & "&nbsp;</td></tr></table>"
msg=msg & vbnewline & vbnewline
msg=msg & "<p><b>Support (as viewed from the foot looking toward the head end):</b></p>"
msg=msg & "<table width=""98%"" border=""1"" cellpadding=""3"" cellspacing=""0"">"
msg=msg & "<tr><td width=""11%"">Left Support:</td><td width=""14%"">" & leftsupport & "</td>"
msg=msg & "<td width=""11%"">Right Support: </td><td width=""13%"">" & rightsupport & "</td>"
msg=msg & "<td width=""11%"">Vent Position:</td><td width=""16%"">" & ventposition & "</td>"
msg=msg & "<td width=""10%"">Vent Finish:</td><td width=""14%"">" & ventfinish & "</td></tr></table>"
msg=msg & vbnewline & vbnewline
msg=msg & "<p class=""greybox""><b>Special Instructions:</b></p>"
msg=msg & "<p>"
msg=msg & mattressinstructions
msg=msg & "</p><p>"
If mattressprice<>"" Then
msg=msg & "<b>Mattress Price </b>" & Ccur(mattressprice)
End If
msg=msg & "</p>"
else
msg=msg & "<p>No mattress required</p>"
end if
msg=msg & "<br />"

msg=msg & "<b>TOPPER</b><br />"
If topperrequired="y" Then
msg=msg & "<table width=""98%"" border=""1"" cellpadding=""3"" cellspacing=""0"">"
msg=msg & "<tr><td width=""11%"">Topper Type:</td><td width=""22%"">" & toppertype & "</td>"
msg=msg & "<td>Topper Width: </td><td>" & topperwidth & ""
If topper1width<>"" then
msg=msg & " Topper Width: " & topper1width & ""
end if
msg=msg & "</td>"
msg=msg & "<td width=""8%"">Topper Length:</td><td width=""24%"">" & topperlength & ""
If topper1length<>"" then
msg=msg & " Topper Length: " & topper1length & ""
end if
msg=msg & "</td></tr>"
msg=msg & "<tr><td>Ticking Options:</td><td>" & toppertickingoptions & "</td>"
msg=msg & "<td width=""10%"">&nbsp;</td><td width=""25%"">&nbsp;</td><td>&nbsp;</td><td>"
If toppertickingoptions="White Trellis" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/white-trellis.jpg"" align=""right"">"
If toppertickingoptions="Grey Trellis" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/grey-trellis.jpg"" align=""right"">"
If toppertickingoptions="Silver Trellis" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/silver-trellis.jpg"" align=""right"">"
If toppertickingoptions="Oatmeal Trellis" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/oatmeal-trellis.jpg"" align=""right"">"
msg=msg & "&nbsp;</td></tr></table>"
msg=msg & vbnewline & vbnewline
msg=msg & "<p class=""greybox""><b>Special Instructions:</b></p>"
msg=msg & "<p>"
msg=msg & specialinstructionstopper
msg=msg & "</p><p>"
msg=msg & "<b>Topper Price </b>" & topperprice
msg=msg & "</p>"
else
msg=msg & "<p>No topper required</p>"
end if
msg=msg & "<br />"

msg=msg & "<b>BASE</b><br />"
If baserequired="y" Then
msg=msg & "<table width=""98%"" border=""1"" cellpadding=""3"" cellspacing=""0"">"
msg=msg & "<tr><td>Savoir Model:</td><td>" & basesavoirmodel & "</td>"
msg=msg & "<td>Base Type:</td><td>" & basetype & "</td>"
msg=msg & "<td>Base Width: </td><td>" & basewidth & ""
If base1width<>"" then
msg=msg & "  Base 1 Width: " & base1width & ""
end if
If base2width<>"" then
msg=msg & "  Base 2 Width: " & base2width & ""
end if
msg=msg & "</td></tr>"
msg=msg & "<tr><td>Base Length:</td><td>" & baselength & ""
If base1length<>"" then
msg=msg & " Base 1 Length: " & base1length & ""
end if
If base2length<>"" then
msg=msg & " Base 2 Length: " & base2length & ""
end if
msg=msg & "</td>"

msg=msg & "<td>Link Position:</td><td>" & linkposition & "</td>"
msg=msg & "<td>Link Finish</td><td>" & linkfinish & "</td></tr>"
if drawers="Yes" then
msg=msg & "<tr><td>Drawers: </td><td>" & drawers & "</td><td>Drawer Config: </td><td>" & drawerconfig & "</td><td>Drawer Height:  </td><td>" & drawerheight & "</td></tr>"
end if
msg=msg & "<tr><td>Extended Base:</td><td>" & extbase & "</td>"
msg=msg & "<td>&nbsp;</td><td>&nbsp;</td> <td>&nbsp;</td> <td>&nbsp;</td> </tr></table>"
msg=msg & vbnewline & vbnewline
msg=msg & "<p class=""greybox""><b>Special Instructions:</b></p>"
msg=msg & "<p>"
msg=msg & baseinstructions
msg=msg & "</p><p>"
msg=msg & "<b>Base Price </b>" & baseprice
msg=msg & "</p>"


msg=msg & "<br />"
msg=msg & "<p class=""greybox""><b>Upholstery Fabric Options</b></p>"
msg=msg & "<table width=""98%"" border=""1"" cellpadding=""3"" cellspacing=""0"">"
msg=msg & "<tr><td width=""11%"">Upholstered Base:</td>"
msg=msg & "<td width=""12%"">" & upholsteredbase & "</td>"
msg=msg & "<td width=""11%"">Fabric Options: </td><td width=""21%"">" & basefabric & "</td>"
msg=msg & "<td width=""12%"">Fabric Selection:</td><td width=""33%"">" & basefabricchoice & "</td></tr>"

msg=msg & "<tr><td width=""11%"">Base Fabric Direction:</td>"
msg=msg & "<td width=""12%"">" & basefabricdirection & "</td>"
msg=msg & "<td width=""11%"">&nbsp;</td><td width=""21%"">&nbsp;</td>"
msg=msg & "<td width=""12%"">&nbsp;</td><td width=""33%"">&nbsp;</td></tr></table>"


msg=msg & vbnewline & vbnewline
msg=msg & "<p class=""greybox""><b>Base Fabric Description:</b></p>"
msg=msg & "<p>"
msg=msg & basefabricdesc
msg=msg & "</p><p>"
msg=msg & "<b>Upholstery Price </b>" & upholsteryprice
msg=msg & "</p><br />"

else
msg=msg & "<p>No base required</p>"
end if
msg=msg & vbnewline & vbnewline
msg=msg & "<b>LEGS</b>"
IF legsrequired="y" Then
msg=msg & "<table width=""98%"" border=""1"" cellpadding=""3"" cellspacing=""0""><tr>"
msg=msg & "<td>Leg Style:</td><td>" & legstyle & "</td>"
msg=msg & "<td>Leg Finish: </td><td>" & legfinish & "</td>"
msg=msg & "<td>Leg Qty:</td><td>" & legqty & "</td></tr>"
msg=msg & "<tr><td>Additional Legs:</td><td>" & addlegqty & "</td>"
msg=msg & "<td>Leg Height:</td><td>" & legheight & "</td>"
msg=msg & "<td>Floor Type:</td><td>" & floortype & "</td></tr>"
msg=msg & "</table>"
msg=msg & vbnewline & vbnewline
msg=msg & "<p class=""greybox""><b>Special Leg Instructions:</b></p>"
msg=msg & "<p>"
msg=msg & specialinstructionslegs
msg=msg & "</p>"
else
msg=msg & "<p>No legs required</p>"
end if
msg=msg & vbnewline & vbnewline
msg=msg & "<b>HEADBOARD</b>"
IF headboardrequired="y" Then
msg=msg & "<table width=""98%"" border=""1"" cellpadding=""3"" cellspacing=""0"">"
msg=msg & "<tr><td>Headboard Styles:</td><td>" & headboardstyle & "</td>"
msg=msg & "<td width=""11%"">Fabric Options:</td><td width=""21%"">" & headboardfabric & " (" & hbfabricoptions & ")</td>"
msg=msg & "<td width=""12%"">Fabric Selection:</td><td width=""33%"">" & headboardfabricchoice & "</td></tr>"
msg=msg & "<tr><td>Headboard Height:</td><td>" & headboardheight & "</td><td>Headboard Finish:</td><td>" & headboardfinish & "&nbsp;</td><td>&nbsp;</td><td>"
If headboardstyle="C5" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/c5.gif"" align=""right"">"
If headboardstyle="C4" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/c4.gif"" align=""right"">"
If headboardstyle="C2" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/c2.gif"" align=""right"">"
If headboardstyle="C1" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/c1.gif"" align=""right"">"
If headboardstyle="C6" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/c6.gif"" align=""right"">"
If headboardstyle="M31" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/m31.gif"" align=""right"">"
If headboardstyle="M32" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/m32.gif"" align=""right"">"
If headboardstyle="Holly" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/holly.gif"" align=""right"">"
If headboardstyle="F100" then msg=msg & "<img src=""http://www.savoiradmin.co.uk/img/f100.gif"" align=""right"">"
msg=msg & "&nbsp;</td></tr>"
msg=msg & "<tr><td>Headboard Fabric Direction</td><td>" & headboardfabricdirection & "</td><td>Supporting Leg Qty:</td><td>" & hblegs & "</td><td>&nbsp;</td><td>&nbsp;</td></tr></table>"
msg=msg & vbnewline & vbnewline
msg=msg & "<p class=""greybox""><b>Headboard Fabric Description:</b></p>"
msg=msg & "<p>"
msg=msg & headboardfabricdesc
msg=msg & "</p>"
msg=msg & "<p class=""greybox""><b>Special Instructions:</b></p>"
msg=msg & "<p>"
msg=msg & specialinstructionsheadboard
msg=msg & "</p><p>"
msg=msg & "<b>Headboard Price </b>" & headboardprice
msg=msg & "</p>"
    
else
msg=msg & "<p>No headboard required</p>"
end if
msg=msg & "<br /> "

msg=msg & "<b>VALANCE</b><br />"
If valancerequired="y" Then
msg=msg & "<table width=""98%"" border=""1"" cellpadding=""3"" cellspacing=""0"">"
msg=msg & "<tr><td width=""11%"">No. of Pleats:</td><td width=""12%"">" & pleats & "</td>"
msg=msg & "<td width=""11%"">Fabric Options: </td><td width=""21%"">" & valancefabric & "</td>"
msg=msg & "<td width=""12%"">Fabric Selection:</td><td width=""33%"">" & valancefabricchoice & "</td></tr>"

msg=msg & "<tr><td width=""11%"">Valance Fabric Direction:</td><td width=""12%"">" & valancefabricdirection & "</td>"
msg=msg & "<td width=""11%"">Valance Drop: </td><td width=""21%"">" & valancedrop & "</td>"
msg=msg & "<td width=""12%"">Valance Width: </td><td width=""33%"">" & valancewidth & "</td></tr>"
msg=msg & "<tr><td width=""12%"">Valance Length: </td><td width=""33%"">" & valancelength & "</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr></table>"
msg=msg & vbnewline & vbnewline
msg=msg & "<p class=""greybox""><b>Special Instructions:</b></p>"
msg=msg & "<p>"
msg=msg & specialinstructionsvalance
If valanceprice<>"" then
msg=msg & "</p><p><b>Valance Price: </b>  " & CCur(valanceprice)
End If
msg=msg & "</p>"
else
msg=msg & "<p>No valance required</p>"
end if
msg=msg & "<br /> "

sql="Select * from orderaccessory where purchase_no=" & order
Set rs4 = getMysqlQueryRecordSet(sql, con)
if not rs4.eof then
msg=msg & "<b>ACCESSORIES</b><br /><table width=""98%"" border=""1"" cellpadding=""3"" cellspacing=""0""><tr><td><b>Description</b></td><td><b>Design</b></td><td><b>Colour</b></td><td><b>Size</b></td><td><b>Unit Price</b></td><td><b>Qty</b></td></tr>"
do until rs4.eof
msg=msg & "<tr><td>" & rs4("description") & "</td><td>" & rs4("design") & "</td><td>" & rs4("colour") & "</td><td>" & rs4("size") & "</td><td>" & rs4("unitprice") & "</td><td>" & rs4("qty") & "</td></tr>"
rs4.movenext
loop
msg=msg & "</table>"
end if
rs4.close
set rs4=nothing


msg=msg & "<p><b>DELIVERY CHARGE</b></p>"
msg=msg & "<p>Access Check Required: " & accesscheck & "</p>"
If deliverycharge="y" Then
If specialinstructionsdelivery <> "" Then msg=msg & "<p><b>Special Instructions: </b></p><p>" & specialinstructionsdelivery & "</p> "
If deliveryprice <> "" Then msg=msg & "<p><b>Delivery Charge: </b>  " & CCur(deliveryprice) & "</p> "

else
msg=msg & "<p>No delivery charge</p>"
end if
msg=msg & "<p>Dispose of Old Bed? " & oldbed & "</p>"
msg=msg & "<br /> "
msg=msg & "<table width=""563"" border=""1"" cellpadding=""0"" cellspacing=""2"">"
msg=msg & "<tr><td colspan=""2""><strong>Order Summary - Order No. " & orderno & "</strong></td></tr>"
msg=msg & "<tr><td width=""296"">Mattress</td><td width=""253"">" & mattressprice & "</td></tr>"
msg=msg & "<tr><td>Topper</td><td width=""253"">" & topperprice & "</td></tr>"
msg=msg & "<tr><td>Leg Price</td><td width=""253"">" & legprice & "</td></tr>"
msg=msg & "<tr><td>Base</td><td width=""253"">" & baseprice & "</td></tr>"
msg=msg & "<tr><td>Upholstered Base</td><td>" & upholsteryprice & "</td></tr>"
msg=msg & "<tr><td>Base Fabric Price</td><td>" & basefabricprice & "</td></tr>"
msg=msg & "<tr><td>Headboard</td><td width=""253"">" & headboardprice & "</td></tr>"
msg=msg & "<tr><td>Headboard Fabric Price</td><td>" & hbfabricprice & "</td></tr>"
msg=msg & "<tr><td>Valance</td><td width=""253"">" & valanceprice & "</td></tr>"
msg=msg & "<tr><td>Valance Fabric Price</td><td>" & valfabricprice & "</td></tr>"
msg=msg & "<tr><td>Accessories Total Cost</td><td>" & accessoriestotalcost & "</td></tr>"
msg=msg & "<tr><td><strong>Bed Set Total</strong></td><td>" & bedsettotal & "</td></tr>"
If dcresult<>"" then
msg=msg & "<tr><td>DC &nbsp;&nbsp;" & dctype & "</td><td>" & dcresult & "</td></tr>"
end if
msg=msg & "<tr><td><strong>Sub Total</strong></td><td>" & subtotal & "</td></tr>"
msg=msg & "<tr><td>Delivery Charge</td><td>" & deliveryprice & "</td></tr>"



if tradeDiscount <> "" then
	msg=msg & "<tr><td>Trade Discount</td><td>" & tradeDiscount & "</td></tr>"
end if
'if totalExVat <> "" then
	msg=msg & "<tr><td>Total excluding VAT</td><td>" & totalExVat & "</td></tr>"
	msg=msg & "<tr><td>VAT</td><td>" & vat & "</td></tr>"
'end if
msg=msg & "<tr><td><strong>TOTAL</strong></td><td>" & total & "</td></tr>"
msg=msg & "<tr><td>Payments Total</td><td>" & paymentstotal & "</td></tr>"
msg=msg & "<tr><td><strong>Balance Outstanding</strong></td><td>" & outstanding & "</td></tr></table>"

'following code waiting for problem with formfields to be sorted
'If isamendment then
'sql="Select * from orderhistory O, goodfieldnames G where G.purchasefieldname=O.field and O.purchase_no=" & order & " and O.version=" & amendedversionno
'response.Write("sql=" & sql)
'response.End()
'Set rs4 = getMysqlQueryRecordSet(sql, con)
'msg=msg & "<p><b>AMENDMENTS LISTED BELOW</b><br /><br />"
'Do until rs4.eof
'msg=msg & "<p>" & rs4("goodfieldname") & " changed from " & rs4("oldvalue") & " to " & rs4("newvalue") & "</p>"
'rs4.movenext
'loop
'rs4.close
'set rs4=nothing
'end if
msg=msg & "</font></body></html>"

%>

