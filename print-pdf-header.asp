<%PDF.SetFont "F15", 12, "#999"
PDF.AddHTML "<p align=""right""><img src=""images/logo.gif"" width=""255"" height=""66""></p>"
if quote="y" then
	PDF.AddTextPos 20, 20, "Quote No. " & rs("order_number")
		if aw="y" then
		PDF.AddTextPos 220, 20, "QUOTE CONFIRMATION"
		end if
	else
	PDF.AddTextPos 20, 20, "Order No. " & rs("order_number")
		if aw="y" then
		PDF.AddTextPos 220, 20, "ORDER CONFIRMATION"
		end if
end if
PDF.SetFont "F15", 10, "#999"
if quote="y" then
	PDF.AddTextPos 20, 40, "Quote Date. " & FormatDateTime(rs("order_date"),vbShortDate)
	else
	PDF.AddTextPos 20, 40, "Order Date. " & FormatDateTime(rs("order_date"),vbShortDate)
end if
PDF.AddTextPos 20, 60, "Savoir Contact: " & contact
PDF.SetFont "F15", 9, "#999"
PDF.AddTextPos 20, 80, "Showroom: " & showroomaddress

PDF.AddLine 20, 85, 580, 85
PDF.AddHTMLPos 25, 76, s


PDF.AddHTMLPos 25, 87, "<img src=""images/whitebg.png"" width=""95"" height=""16"">"
PDF.AddHTMLPos 215, 87, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
PDF.AddHTMLPos 405, 87, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"




PDF.AddTextPos 33, 97, "Client Details"



PDF.AddTextPos 223, 97, "Invoice Address"
PDF.AddTextPos 413, 97, "Delivery Address"
PDF.SetFont "F15", 8, "#999"%>