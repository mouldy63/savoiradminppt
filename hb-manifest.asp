<%packdimensions=""
Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=8 and componentname = '" & rs("headboardstyle") & "'", con)
If not rs2.eof then
		weight=rs2("weight")
		depth=rs2("depth")
end if
rs2.close
set rs2=nothing 

if wrap=1 or wrap=2 then
	Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where purchase_no=" & pnarray(n) & " and componentid = 8", con)
	if not rs4.eof then
	packdimensions=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
	hbwidth=CDbl(rs4("packwidth"))
	end if
	
		components=components & "Headboard "
		itemcount=itemcount+1
		redim preserve componentarray(itemcount)
		redim preserve dimensionsarray(itemcount)
		redim preserve weightarray(itemcount)
		redim preserve grossweightarray(itemcount)
		redim preserve wholesaleprice(itemcount)
		if rs("headboardWidth")<>"" and hbwidth="" then 
			hbwidth=rs("headboardWidth")
			else
			if hbwidth="" then hbwidth=getHbWidth(con,pnarray(n))
			if hbwidth="" then hbwidth=0
		end if
		if packdimensions="" then
		dimensionsarray(itemcount)=hbwidth & "x" & rs("headboardheight") & " "
		else
		dimensionsarray(itemcount)=packdimensions
		end if
		weightcalc=((cleantonumber(hbwidth)) * CDbl(weight))+0.5
		'response.Write("hbwidth=" & hbwidth & " pn=" & pnarray(n))
		'if trim(hbwidth)="" then hbwidth=0
		'hbwidth=1
		'response.Write("<br>hbwidth=" & hbwidth)
		'response.End()
		
		weightarray(itemcount)=round(weightcalc)
		grossweightarray(itemcount)=round(weightcalc)
		wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 8),2)
		if weightcalc<>"" then
		totalNW=totalNW+CDbl(weightarray(itemcount))
		totalGW=totalGW+CDbl(grossweightarray(itemcount))
		end if
		if packpegwith=8 then
			componentarray(itemcount)=rs("headboardstyle") & " Headboard & pegboard 2 pc"
		else
			componentarray(itemcount)=rs("headboardstyle") & " Headboard 1 pc"
		end if
end if
if wrap=3 then
Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where purchase_no=" & pnarray(n) & " and componentid = 8", con)
	if not rs4.eof then
	call getPackedWithCompDetails(con, pnarray(n), 8, wholesaleprices, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
	
	itemcount=itemcount+1
	redim preserve componentarray(itemcount)
	redim preserve dimensionsarray(itemcount)
	redim preserve weightarray(itemcount)
	redim preserve grossweightarray(itemcount)
	redim preserve wholesaleprice(itemcount)
	if rs4("boxsize")<>"" then 
		call getBoxSizes(con, rs4("boxsize"), boxwidth, boxlength, boxdepth)
		dimensionsarray(itemcount)=boxwidth & "x" & boxlength & "x" & boxdepth & "cm"
	end if
	if packpegwith=8 then
		componentarray(itemcount)=rs("headboardstyle") & " Headboard & pegboard 2 pc"
	else
		componentarray(itemcount)=rs("headboardstyle") & " Headboard 1 pc"
	end if
	if packedwithCompName<>"" then componentarray(itemcount)=componentarray(itemcount) & packedwithCompName
	Set rs2 = getMysqlQueryRecordSet("Select * from shippingbox where sname='" & rs4("Boxsize") & "'", con)
	if not rs2.eof then 
		boxweight=rs2("Weight")
	end if
	rs2.close
	set rs2=nothing
	grossweightarray(itemcount)=rs4("PackKg")
	wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 8),2)
	weightarray(itemcount)=CDbl(rs4("PackKg"))-CDbl(boxweight)
	totalNW=totalNW+CDbl(weightarray(itemcount))
			totalGW=totalGW+CDbl(grossweightarray(itemcount))
rs4.close
set rs4=nothing
end if

end if

if wrap=4 then
response.write("hb=" & pnarray(n))
	call getPackedWithCompDetails(con, pnarray(n), 8, wholesaleprices, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
	Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where comppartno=1 and purchase_no=" & pnarray(n) & " and componentid = 8", con)
	if not rs4.eof then
		itemcount=itemcount+1
		redim preserve componentarray(itemcount)
		redim preserve dimensionsarray(itemcount)
		redim preserve weightarray(itemcount)
		redim preserve grossweightarray(itemcount)
		redim preserve wholesaleprice(itemcount)
		dimensionsarray(itemcount)=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
		if packpegwith=8 then
			componentarray(itemcount)=rs("headboardstyle") & " Headboard & pegboard 2 pc"
		else
			componentarray(itemcount)=rs("headboardstyle") & " Headboard 1 pc"
		end if
		if packedwithCompName<>"" then componentarray(itemcount)=componentarray(itemcount) & packedwithCompName
		Set rs2 = getMysqlQueryRecordSet("Select * from shippingbox where sname='" & rs4("Boxsize") & "'", con)
		if not rs2.eof then 
			boxweight=rs2("Weight")
		end if
		rs2.close
		set rs2=nothing
		grossweightarray(itemcount)=rs4("PackKg")
		wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 8),2)
		weightarray(itemcount)=CDbl(rs4("PackKg"))-CDbl(boxweight)
		totalNW=totalNW+CDbl(weightarray(itemcount))
		totalGW=totalGW+CDbl(grossweightarray(itemcount))
		if rs4("boxqty")=2 then
			grossweightarray(itemcount)=CDbl(rs4("PackKg"))-CDbl(boxweight)
			wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 8),2)
			weightarray(itemcount)=CDbl(rs4("PackKg"))-(CDbl(boxweight)*2)
			totalNW=totalNW+CDbl(weightarray(itemcount))
			totalGW=totalGW+CDbl(grossweightarray(itemcount))
			itemcount=itemcount+1
			redim preserve componentarray(itemcount)
			redim preserve dimensionsarray(itemcount)
			redim preserve weightarray(itemcount)
			redim preserve grossweightarray(itemcount)
			redim preserve wholesaleprice(itemcount)
			dimensionsarray(itemcount)=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
			grossweightarray(itemcount)=CDbl(rs4("PackKg"))-CDbl(boxweight)
			wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 8),2)
			weightarray(itemcount)=CDbl(rs4("PackKg"))-(CDbl(boxweight)*2)
			totalNW=totalNW+CDbl(weightarray(itemcount))
			totalGW=totalGW+CDbl(grossweightarray(itemcount))
			componentarray(itemcount)=rs("headboardstyle") & " Headboard 2nd pc"
		end if
		rs4.close
		set rs4=nothing
		end if
		Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where comppartno=2 and purchase_no=" & pnarray(n) & " and componentid = 8", con)
	if not rs4.eof then
		itemcount=itemcount+1
				redim preserve componentarray(itemcount)
				redim preserve dimensionsarray(itemcount)
				redim preserve weightarray(itemcount)
				redim preserve grossweightarray(itemcount)
				redim preserve wholesaleprice(itemcount)
				dimensionsarray(itemcount)=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
				grossweightarray(itemcount)=CDbl(rs4("PackKg"))-CDbl(boxweight)
				wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 8)/2,2)
				weightarray(itemcount)=CDbl(rs4("PackKg"))-(CDbl(boxweight)*2)
				totalNW=totalNW+CDbl(weightarray(itemcount))
				totalGW=totalGW+CDbl(grossweightarray(itemcount))
				componentarray(itemcount)=rs("headboardstyle") & " Headboard 2nd pc"
	rs4.close
	set rs4=nothing
	end if
end if	%>