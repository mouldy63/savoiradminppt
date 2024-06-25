<%'headboard options
if rs("headboardrequired")="y" then
	if rs("headboardstyle")="Gorrivan Headboard & Footboard" then
		y=90
		gorrivanexists="y"
	else
		y=75
	end if
 
	If rs("specialinstructionsheadboard")<>"" then
		If rs("headboardfabricdesc")<>"" then y=y+12
		DrawBox 20,x-5, 560, y
		PDF.SetProperty csPropGraphLineColor, "silver"
		if gorrivanexists="y" then 
			DrawBox 25,x+27, 500, 18
			If rs("headboardfabricdesc")<>"" then DrawBox 25,x+70, 500, 18
			PDF.SetProperty csPropGraphLineColor, "black"
		else
			DrawBox 25,x+27, 500, 18
			If rs("headboardfabricdesc")<>"" then DrawBox 25,x+60, 500, 18
			PDF.SetProperty csPropGraphLineColor, "black"
		end if
	else
		y=51
		If rs("headboardfabricdesc")<>"" then y=y+15
		if gorrivanexists="y" then
			DrawBox 20,x-5, 560, y+10
			PDF.SetProperty csPropGraphLineColor, "silver"
			If rs("headboardfabricdesc")<>"" then DrawBox 25,x+47, 500, 18
			PDF.SetProperty csPropGraphLineColor, "black"
		else
			DrawBox 20,x-5, 560, y
			PDF.SetProperty csPropGraphLineColor, "silver"
			If rs("headboardfabricdesc")<>"" then DrawBox 25,x+37, 500, 18
			PDF.SetProperty csPropGraphLineColor, "black"
		end if
	end if
		
PDF.AddHTMLPos 25, x-10, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
PDF.AddHTMLPos 33, x-12, "<font family=""Tahoma""><font size=""8""><b>Headboard</b></font></font>"

	PDF.AddHTMLPos 33, x, "<font family=""Tahoma""><font size=""8"">Style:</font></font>"
	PDF.AddHTMLPos 57, x, "<font family=""Tahoma""><font size=""9""><b>" & rs("headboardstyle") & "</b></font></font>"
	if gorrivanexists="y" then
	PDF.AddHTMLPos 240, x, "<font family=""Tahoma""><font size=""8"">Headboard Finish:</font></font>"
	PDF.AddHTMLPos 310, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("headboardfinish") & "</b></font></font>"
	PDF.AddHTMLPos 370, x, "<font family=""Tahoma""><font size=""8"">Footboard Finish:</font></font>"
	PDF.AddHTMLPos 436, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("footboardfinish") & "</b></font></font>"
	PDF.AddHTMLPos 33, x+11, "<font family=""Tahoma""><font size=""8"">Headboard Height:</font></font>"
	PDF.AddHTMLPos 103, x+11, "<font family=""Tahoma""><font size=""8""><b>" & rs("headboardheight") & "</b></font></font>"

	PDF.AddHTMLPos 443, x+11, "<font family=""Tahoma""><font size=""8"">Legs:</font></font>"
	PDF.AddHTMLPos 473, x+11, "<font family=""Tahoma""><font size=""8""><b>" & rs("headboardlegqty") & "</b></font></font>"
	PDF.AddHTMLPos 240, x+11, "<font family=""Tahoma""><font size=""8"">Footboard Height:</font></font>"
	PDF.AddHTMLPos 310, x+11, "<font family=""Tahoma""><font size=""8""><b>" & rs("footboardheight") & "</b></font></font>"
    else
	PDF.AddHTMLPos 220, x, "<font family=""Tahoma""><font size=""8"">Finish:</font></font>"
	PDF.AddHTMLPos 250, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("headboardfinish") & "</b></font></font>"
	PDF.AddHTMLPos 355, x, "<font family=""Tahoma""><font size=""8"">Height:</font></font>"
	PDF.AddHTMLPos 387, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("headboardheight") & "</b></font></font>"
	PDF.AddHTMLPos 33, x+11, "<font family=""Tahoma""><font size=""8"">Legs:</font></font>"
	PDF.AddHTMLPos 63, x+11, "<font family=""Tahoma""><font size=""8""><b>" & rs("headboardlegqty") & "</b></font></font>"
	PDF.AddHTMLPos 220, x+11, "<font family=""Tahoma""><font size=""8"">Fabric Options:</font></font>"
	PDF.AddHTMLPos 280, x+11, "<font family=""Tahoma""><font size=""8""><b>" & rs("hbfabricoptions") & "</b></font></font>"
	end if
	'if NOT userHasRoleInList("NOPRICESUSER") then
	if (retrieveuserid()<>181 and retrieveuserid()<>182) then
		PDF.AddHTMLPos 534, x, "<font family=""Tahoma""><font size=""8"">PRICE:</font></font>"
	end if
	'PDF.AddHTMLPos 33, x+11, "<font family=""Tahoma""><font size=""8"">Manhattan Trim:</font></font>"
	'PDF.AddHTMLPos 97, x+11, "<font family=""Tahoma""><font size=""9""><b>" & rs("manhattantrim") & "</b></font></font>"
	
	
	'if NOT userHasRoleInList("NOPRICESUSER") then
	if (retrieveuserid()<>181 and retrieveuserid()<>182) then
		If rs("headboardprice")<>"" and   NOT ISNULL(rs("headboardprice"))  then
		PDF.AddHTMLPos 534, x+10, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("headboardprice"),2) & "</b></font></font>"
		else
		PDF.AddHTMLPos 534, x+10, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & "0.00</b></font></font>"
		end if
	end if
		If rs("specialinstructionsheadboard")<>"" then
			specialinstructionsheadboard=replace(rs("specialinstructionsheadboard"),CHR(13)," ")
			str5=specialinstructionsheadboard
			PDF.SetFont "F15", 6, "#999"
			PDF.SetProperty csPropAddTextWidth , 2
			if gorrivanexists="y" then
			PDF.AddTextWidth 33,x+35,490, str5
			else
			PDF.AddTextWidth 33,x+35,490, str5
			end if
			x=x-7
		else
			x=x-30
		end if	
	if gorrivanexists="y" then
		PDF.AddHTMLPos 33, x+52, "<font family=""Tahoma""><font size=""8"">Fabric Options:</font></font>"
	PDF.AddHTMLPos 93, x+52, "<font family=""Tahoma""><font size=""8""><b>" & rs("hbfabricoptions") & "</b></font></font>"
	PDF.AddHTMLPos 240, x+52, "<font family=""Tahoma""><font size=""8"">Fabric Selection:</font></font>"
	PDF.AddHTMLPos 310, x+52, "<font family=""Tahoma""><font size=""8""><b>" & rs("headboardfabric") & "</b></font></font>"
	PDF.AddHTMLPos 422, x+52, "<font family=""Tahoma""><font size=""8"">Direction:</font></font>"
	PDF.AddHTMLPos 460, x+52, "<font family=""Tahoma""><font size=""8""><b>" & rs("headboardfabricdirection") & "</b></font></font>"
PDF.AddHTMLPos 33, x+63, "<font family=""Tahoma""><font size=""8"">Description:</font></font>"
	PDF.AddHTMLPos 93, x+63, "<font family=""Tahoma""><font size=""8""><b>" & rs("headboardfabricchoice") & "</b></font></font>"
	else
		PDF.AddHTMLPos 33, x+53, "<font family=""Tahoma""><font size=""8"">Fabric Selection:</font></font>"
		PDF.AddHTMLPos 99, x+53, "<font family=""Tahoma""><font size=""8""><b>" & rs("headboardfabric") & "</b></font></font>"
	PDF.AddHTMLPos 220, x+53, "<font family=""Tahoma""><font size=""8"">Description:</font></font>"
	PDF.AddHTMLPos 268, x+53, "<font family=""Tahoma""><font size=""8""><b>" & rs("headboardfabricchoice") & "</b></font></font>"
	PDF.AddHTMLPos 422, x+53, "<font family=""Tahoma""><font size=""8"">Direction:</font></font>"
	PDF.AddHTMLPos 460, x+53, "<font family=""Tahoma""><font size=""8""><b>" & rs("headboardfabricdirection") & "</b></font></font>"
	end if
	'if NOT userHasRoleInList("NOPRICESUSER") then
	if (retrieveuserid()<>181 and retrieveuserid()<>182) then
		PDF.AddHTMLPos 534, x+53, "<font family=""Tahoma""><font size=""8"">PRICE:</font></font>"
		If rs("hbfabricprice")<>"" and   NOT ISNULL(rs("hbfabricprice"))  then
		PDF.AddHTMLPos 534, x+63, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("hbfabricprice"),2) & "</b></font></font>"
		else
		PDF.AddHTMLPos 534, x+63, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & "0.00</b></font></font>"
		end if
		If rs("hbfabricprice")<>"" and NOT ISNULL(rs("hbfabricprice")) then
			If CDbl(rs("hbfabricprice"))>0.0 then upholsterysum=Cdbl(upholsterysum)+Cdbl(rs("hbfabricprice"))
		end if
	end if
	
	If rs("headboardfabricdesc")<>"" then
	headboardfabricdesc=replace(rs("headboardfabricdesc"),CHR(13)," ")
	str6=headboardfabricdesc
	PDF.SetFont "F15", 6, "#999"
	PDF.SetProperty csPropAddTextWidth , 2
	if gorrivanexists="y" then
		PDF.AddTextWidth 33,x+85,490, str6
	else
		PDF.AddTextWidth 33,x+75,490, str6
	end if
	end if
end if
'end headboard%>