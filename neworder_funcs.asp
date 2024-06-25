<%
function createNewOrderPdf(byref acon, aPn, aConfirmation)

	dim aCustname, ars, ars1, ars2, ars3, asql, aAdemail, aClienthdg, aClientdetails, aCustaddress, aSs, aXacc, aContact, aShowroomaddress, aMattModel
	dim aAccesscost, aYPos, aPDF
	
	Set ars = getMysqlQueryRecordSet("Select * from savoir_user where user_id=" & retrieveuserid(), acon)
	aAdemail=ars("adminemail")
	ars.close
	set ars=nothing
	
	Set ars = getMysqlQueryRecordSet("Select * from purchase WHERE purchase_no=" & aPn & "", acon)
	if ars("mattressrequired")="y" then aMattModel=ars("savoirmodel") else aMattModel="None"
	
	Set ars2 = getMysqlQueryRecordSet("Select * from location WHERE idlocation=" & ars("idlocation") & "", acon)
	If ars2("add1")<>"" then aShowroomaddress=Utf8ToUnicode(ars2("add1")) & ", "
	If ars2("add2")<>"" then aShowroomaddress=aShowroomaddress & Utf8ToUnicode(ars2("add2")) & ", "
	If ars2("add3")<>"" then aShowroomaddress=aShowroomaddress & Utf8ToUnicode(ars2("add3")) & ", "
	If ars2("town")<>"" then aShowroomaddress=aShowroomaddress & Utf8ToUnicode(ars2("town")) & ", "
	If ars2("countystate")<>"" then aShowroomaddress=aShowroomaddress & Utf8ToUnicode(ars2("countystate")) & ", "
	If ars2("postcode")<>"" then aShowroomaddress=aShowroomaddress & Utf8ToUnicode(ars2("postcode")) & ", "
	if aShowroomaddress<>"" then aShowroomaddress=left(aShowroomaddress, len(aShowroomaddress)-2)
	If ars2("tel")<>"" then aShowroomaddress=aShowroomaddress & "&nbsp;&nbsp;Tel: " & ars2("tel")
	If aAdemail<>"" then aShowroomaddress=aShowroomaddress & "&nbsp;&nbsp;Email: " &aAdemail
	ars2.close
	set ars2=nothing
	Set ars2 = getMysqlQueryRecordSet("Select * from savoir_user WHERE username like '" & ars("salesusername") & "'", acon)
	aContact = ars2("name")
	ars2.close
	set ars2=nothing
	Set ars1 = getMysqlQueryRecordSet("Select * from contact WHERE code=" & ars("code") & "", acon)
	Set ars2 = getMysqlQueryRecordSet("Select * from address WHERE code=" & ars1("code") & "", acon)
	
	aCustname=""
	If ars1("title") <> "" Then aCustname=aCustname & Utf8ToUnicode(capitalise(lcase(ars1("title")))) & " "
	If ars1("first") <> "" Then aCustname=aCustname & Utf8ToUnicode(capitalise(lcase(ars1("first")))) & " "
	If ars1("surname") <> "" Then aCustname=aCustname & Utf8ToUnicode(capitalise(lcase(ars1("surname"))))
	aClienthdg="<font family=""Tahoma""><font size=""8"">"
	aClienthdg=aClienthdg & "Client: <br />"
	aClienthdg=aClienthdg & "Company: <br />"
	if ars1("company_vat_no")<>"" then aClienthdg=aClienthdg & "VAT No: <br />"
	aClienthdg=aClienthdg & "Home Tel: <br />"
	aClienthdg=aClienthdg & "Work Tel: <br />"
	aClienthdg=aClienthdg & "Mobile: <br />"
	aClienthdg=aClienthdg & "Email: <br />"
	aClienthdg=aClienthdg & "Client Ref: <br />"
	aClienthdg=aClienthdg & "</font></font>"
	
	aClientdetails="<font family=""Tahoma""><font size=""9""><b>"
	aClientdetails=aClientdetails & aCustname & "&nbsp;</b><br /></font><font family=""Tahoma""><font size=""8""><b>"
	aClientdetails=aClientdetails & ars2("company") & "&nbsp;<br />"
	if ars1("company_vat_no")<>"" then aClientdetails=aClientdetails & ars1("company_vat_no") & "<br />"
	aClientdetails=aClientdetails & ars2("tel") & "&nbsp;<br />"
	aClientdetails=aClientdetails & ars1("telwork") & "&nbsp;<br />"
	aClientdetails=aClientdetails & ars1("mobile") & "&nbsp;<br />"
	aClientdetails=aClientdetails & ars2("email_address") & "&nbsp;<br />"
	aClientdetails=aClientdetails & ars("customerreference") & "&nbsp;<br />"
	aClientdetails=aClientdetails & "</font></font>"
	
	aCustaddress="<font family=""Tahoma""><font size=""8"">"
	If ars2("street1")<>"" then aCustaddress=aCustaddress & ars2("street1") & "<br />"
	If ars2("street2")<>"" then aCustaddress=aCustaddress & ars2("street2") & "<br />"
	If ars2("street3")<>"" then aCustaddress=aCustaddress & ars2("street3") & "<br />"
	If ars2("town")<>"" then aCustaddress=aCustaddress & ars2("town") & "<br />"
	If ars2("county")<>"" then aCustaddress=aCustaddress & ars2("county") & "<br />"
	If ars2("postcode")<>"" then aCustaddress=aCustaddress & ars2("postcode") & "<br />"
	If ars2("country")<>"" then aCustaddress=aCustaddress & ars2("country")
	aCustaddress=aCustaddress & "</b></font></font>"
	
	aSs = "<br><br><table cellpadding=""1""> "
	aSs = aSs & " <tr height=""0""><td colspan=""7"" height=""0""></td></tr>"
	aSs = aSs & " <tr><td width=""11"" height=""55""></td> "
	aSs = aSs & " <td width=""54"" valign=""top"">" & aClienthdg & "</td><td width=""112"" valign=""top"">" & aClientdetails & "</td><td width=""24""></td><td width=""166""><b></b></td><td width=""24""></td><td width=""166""><b></b></td> "
	aSs = aSs & " </tr> "
	aSs = aSs & " </table> "
	
	Set ars3 = getMysqlQueryRecordSet("select * from orderaccessory where purchase_no=" & aPn & " order by orderaccessory_id", acon)
	aXacc="<table><tr><td width=""10"" height=""20""></td><td>Item&nbsp;Description</td><td>Design</td><td>Colour</td><td>Size</td><td align=""right"">Qty</td><td align=""right"">Unit&nbsp;Price</td><td align=""right"">Total</td></tr>"
	if not ars3.eof then
	 do until ars3.eof
	aXacc=aXacc & "<tr ><td width=""10"" height=""20""></td>"
	aXacc=aXacc & "<td width=""150""><b>" & ars3("description") & "</b></td>"
	aXacc=aXacc & "<td width=""100""><b>" & ars3("design") & "</b></td>"
	aXacc=aXacc & "<td width=""80""><b>" & ars3("colour") & "</b></td>"
	aXacc=aXacc & "<td width=""80""><b>" & ars3("size") & "</b></td>"
	aXacc=aXacc & "<td width=""40"" align=""right""><b>" & ars3("qty") & "</b></td>"
	aXacc=aXacc & "<td width=""50"" align=""right""><b>" & fmtCurr2(ars3("unitprice"), true, ars("ordercurrency")) & "</b></td>"
	if (ars3("unitprice")<>"" and CDbl(ars3("unitprice"))>0.0) then aAccesscost=ars3("qty")*CDbl(ars3("unitprice")) else aAccesscost=0
	aXacc=aXacc & "<td width=""40"" align=""right""><b>" & fmtCurr2(aAccesscost, true, ars("ordercurrency")) & "</b></td>"
	aXacc=aXacc & "</tr>"
	aXacc=aXacc & "<tr><td></td><td colspan=""7""><hr style=""color:#eeeeee;""></td></tr>"
	aAccesscost=0   
		ars3.movenext
		loop
	end if
	ars3.close
	set ars3 = nothing
		
	aXacc=aXacc & "</table>"
	
	const csPropGraphLineColor=405
	const csPropGraphZoom= 1
	const csPropGraphWZoom= 50 
	const csPropGraphHZoom= 50
	const csPropTextFont  = 100
	const csHTML_FontName = 100
	const csHTML_FontSize  = 101
	const csPropTextSize  = 101
	const csPropTextAlign = 102
	const csPropTextColor = 103
	const csPropTextUnderline = 104
	const csPropTextRender  = 105
	const csPropAddTextWidth = 113
	const csPropParSpace    = 200
	const csPropParLeft 	= 201
	const csPropParTop 		= 202
	const csPropPosX	    = 205
	const csPropPosY	    = 206
	const csPropInfoTitle 	= 300
	const algLeft = "0"
	const algRight = "1"
	const algCenter = "2"
	const algJustified = "3"
	const pTrue = "1"
	const pFalse = "0"
	
	set aPDF = server.createobject("aspPDF.EasyPDF")
	aPDF.License("$810217456;'David Mildenhall';PDF;1;0-31.170.121.214")
	aPDF.page "A4", 0  'landscape
	
	'aPDF.DEBUG = True
	aPDF.SetMargins 10,15,10,5
	
	aPDF.SetProperty csPropTextAlign, algCenter
	aYPos = int(aPDF.GetProperty(csPropPosY))
	aPDF.SetPos 0, aYPos - 5
	'aPDF.AddLine 60, 55, 520, 55
	aPDF.SetTrueTypeFont "F15", "Tahoma", 0, 0
	aPDF.SetProperty csPropParLeft, "20"
	aPDF.SetProperty csPropPosX, "20"
	aPDF.SetProperty csHTML_FontName, "F1"
	aPDF.SetProperty csHTML_FontSize, "8"
	aPDF.SetProperty csPropTextColor,"#999"
	aPDF.SetProperty csPropTextAlign, "0"
	aPDF.SetProperty csPropAddTextWidth, 1
	aPDF.SetFont "F15", 12, "#999"
	
	'aPDF.AddFormObj 0, 0, 2, 2, "form.button1", "", "", 0 
	'aPDF.AddEventObj 6, "form.button1", "app.alert(""please print off this form"");", "JavaScript" 
	
	call DrawBox(aPDF, 20, 93, 180, 95)
	
	aPDF.AddHTML "<p align=""left""><img src=""images/logo.gif"" width=""255"" height=""66""></p>"
	aPDF.AddTextPos 400, 20, "Order No. " & ars("order_number")
	if aConfirmation="y" then
	aPDF.AddTextPos 220, 20, "ORDER CONFIRMATION"
	end if
	aPDF.SetFont "F15", 10, "#999"
	aPDF.AddTextPos 400, 40, "Order Date. " & FormatDateTime(ars("order_date"),vbShortDate)
	aPDF.AddTextPos 400, 60, "Savoir Contact: " & aContact
	aPDF.SetFont "F15", 9, "#999"
	aPDF.AddTextPos 20, 80, "Showroom: " & aShowroomaddress
	aPDF.AddHTML "<hr>"
	aPDF.AddHTMLPos 25, 69, aSs
	
	aPDF.AddHTMLPos 25, 85, "<img src=""images/whitebg.png"" width=""95"" height=""16"">"
	aPDF.AddHTMLPos 215, 85, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
	aPDF.AddHTMLPos 405, 85, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
	
	aPDF.AddHTMLPos 25, 600, "<img src=""images/whitebg.png"" width=""230"" height=""16"">"
	aPDF.AddHTMLPos 25, 753, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
	aPDF.AddHTMLPos 315, 753, "<img src=""images/whitebg.png"" width=""170"" height=""16"">"
	
	aPDF.AddTextPos 33, 97, "Client Details"
	aPDF.SetFont "F15", 8, "#999"
	aPDF.AddHTMLPos 250, 99, "Mattress Spec: " & aMattModel
	
	createNewOrderPdf = aPDF.saveString
	set aPDF = nothing
	ars1.close
	ars.close
	ars2.close
	set ars1=nothing
	set ars=nothing
	set ars2=nothing

end function 

Sub DrawBox(byref aPDF, aX, aY, aWidth, aHeight)
	aPDF.AddBox aX, aY, aX+aWidth, aY+aHeight
End Sub

function capitalise(astr)
	dim awords, aword
	if isNull(astr) or trim(astr)="" then
		capitalise=""
	else
		awords = split(trim(astr), " ")
		for each aword in awords
			aword = lcase(aword)
			aword = ucase(left(aword,1)) & (right(aword,len(aword)-1))
			capitalise = capitalise & aword & " "
		next
		capitalise = left(capitalise, len(capitalise)-1)
	end if
end function
%>