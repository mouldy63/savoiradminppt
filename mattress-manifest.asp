	<%
Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=1 and componentname = '" & rs("savoirmodel") & "'", con)
If not rs2.eof then
		weight=rs2("weight")
		depth=rs2("depth")
end if
rs2.close
set rs2=nothing

if wrap=1 or wrap=2 then					
	itemcount=itemcount+1
	redim preserve componentarray(itemcount)
	redim preserve dimensionsarray(itemcount)
	redim preserve weightarray(itemcount)
	redim preserve grossweightarray(itemcount)
	redim preserve wholesaleprice(itemcount)
	if packpegwith=1 then
		componentarray(itemcount)=rs("savoirmodel") & " mattress & pegboard 2 pc"
	else
		componentarray(itemcount)=rs("savoirmodel") & " mattress 1 pc"
	end if
	'if 1 mattress
	if left(rs("mattresstype"),3)<>"Zip" then
		'totalcost=totalcost+CDbl(componentpricearray(itemcount))
		call getComponentSizes(con,1,pnarray(n), m1width, m1length)
		if left(rs("mattresswidth"),4)="Spec" then
			call getComponentWidthSpecialSizes(con,1,pnarray(n), m1width)
		end if
		if left(rs("mattresslength"),4)="Spec" then
			call getComponentLengthSpecialSizes(con,1,pnarray(n), m1length)
		end if
		dimensionsarray(itemcount)=m1width & "x" & m1length & "x" & depth & "cm"
		weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
		weightarray(itemcount)=round(weightcalc)
		grossweightarray(itemcount)=round(weightcalc)
		wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 1),2)
		totalNW=totalNW+CDbl(weightarray(itemcount))
		totalGW=totalGW+CDbl(grossweightarray(itemcount))	
	else
	'2 mattresses (FIRST MATT)
		call getComponentSizes(con,1,pnarray(n), m1width, m1length)
		if left(rs("mattresswidth"),4)<>"Spec" then
			m1width=m1width/2
		end if 
		if left(rs("mattresswidth"),4)="Spec" then
			call getComponent1WidthSpecialSizes(con,1,pnarray(n), m1width, m2width)
		end if
		if left(rs("mattresslength"),4)="Spec" then
			call getComponent1LengthSpecialSizes(con,1,pnarray(n), m1length, m2length)
		end if
		dimensionsarray(itemcount)=m1width & "x" & m1length & "x" & depth & "cm"
		weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
		weightarray(itemcount)=round(weightcalc)
		grossweightarray(itemcount)=round(weightcalc)
		wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 1)/2,2)
		totalNW=totalNW+CDbl(weightarray(itemcount))
		totalGW=totalGW+CDbl(grossweightarray(itemcount))	

		'2ND MATT
		itemcount=itemcount+1
		redim preserve componentarray(itemcount)
		redim preserve dimensionsarray(itemcount)
		redim preserve weightarray(itemcount)
		redim preserve grossweightarray(itemcount)
		redim preserve wholesaleprice(itemcount)
		call getComponentSizes(con,1,pnarray(n), m2width, m2length)
		if left(rs("mattresswidth"),4)<>"Spec" then
		m2width=m2width/2
		end if
		if left(rs("mattresswidth"),4)="Spec" then
			call getComponent1WidthSpecialSizes(con,1,pnarray(n), m1width, m2width)
		end if
		if left(rs("mattresslength"),4)="Spec" then
			call getComponent1LengthSpecialSizes(con,1,pnarray(n), m1length, m2length)
		end if
		dimensionsarray(itemcount)=m2width & "x" & m2length & "x" & depth & "cm"
		weightcalc=((CDbl(m2width) * CDbl(m2length)) * CDbl(weight))+0.5
		weightarray(itemcount)=round(weightcalc)
		grossweightarray(itemcount)=round(weightcalc)
		wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 1)/2,2)
		totalNW=totalNW+CDbl(weightarray(itemcount))
		totalGW=totalGW+CDbl(grossweightarray(itemcount))	
		if packpegwith=1 then
			componentarray(itemcount)=rs("savoirmodel") & " mattress & pegboard 2 pc"
		else
			componentarray(itemcount)=rs("savoirmodel") & " mattress 1 pc"
		end if
	end if
						
end if

if wrap=3 then
	
	call getPackedWithCompDetails(con, pnarray(n), 1, wholesaleprices, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
	itemcount=itemcount+1
	redim preserve componentarray(itemcount)
	redim preserve dimensionsarray(itemcount)
	redim preserve weightarray(itemcount)
	redim preserve grossweightarray(itemcount)
	redim preserve wholesaleprice(itemcount)
	Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where comppartno=1 and purchase_no=" & pnarray(n) & " and componentid = 1", con)
	if not rs4.eof then
	if packpegwith=1 then
		componentarray(itemcount)=rs("savoirmodel") & " mattress & pegboard 2 pc"
	else
		componentarray(itemcount)=rs("savoirmodel") & " mattress 1 pc"
	end if
	'if 1 mattress
	if left(rs("mattresstype"),3)<>"Zip" then
		if rs4("boxsize")<>"" then 
			call getBoxSizes(con, rs4("boxsize"), boxwidth, boxlength, boxdepth)
			dimensionsarray(itemcount)=boxwidth & "x" & boxlength & "x" & boxdepth & "cm"
		end if
		Set rs2 = getMysqlQueryRecordSet("Select * from shippingbox where sname='" & rs4("Boxsize") & "'", con)
		if not rs2.eof then 
			boxweight=rs2("Weight")
		end if
		rs2.close
		set rs2=nothing
		weightarray(itemcount)=CDbl(rs4("PackKg"))-CDbl(boxweight)
		grossweightarray(itemcount)=rs4("PackKg")
		wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 1),2)
		totalNW=totalNW+CDbl(weightarray(itemcount))
		totalGW=totalGW+CDbl(grossweightarray(itemcount))	
		if packedwithCompName<>"" then componentarray(itemcount)=componentarray(itemcount) & packedwithCompName
	else
	'2 mattresses (FIRST MATT)
	
		if rs4("boxsize")<>"" then 
			call getBoxSizes(con, rs4("boxsize"), boxwidth, boxlength, boxdepth)
			dimensionsarray(itemcount)=boxwidth & "x" & boxlength & "x" & boxdepth & "cm"
		end if
		Set rs2 = getMysqlQueryRecordSet("Select * from shippingbox where sname='" & rs4("Boxsize") & "'", con)
		if not rs2.eof then 
			boxweight=rs2("Weight")
		end if
		rs2.close
		set rs2=nothing
		weightarray(itemcount)=CDbl(rs4("PackKg"))-CDbl(boxweight)
		grossweightarray(itemcount)=rs4("PackKg")
		wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 1)/2,2)
		totalNW=totalNW+CDbl(weightarray(itemcount))
		totalGW=totalGW+CDbl(grossweightarray(itemcount))		
		if packedwithCompName<>"" then componentarray(itemcount)=componentarray(itemcount) & packedwithCompName
		rs4.close
		set rs4=nothing
		end if
		
		'2ND MATT
		Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where comppartno=2 and purchase_no=" & pnarray(n) & " and componentid = 1", con)
		if not rs4.eof then
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
			Set rs2 = getMysqlQueryRecordSet("Select * from shippingbox where sname='" & rs4("Boxsize") & "'", con)
			if not rs2.eof then 
				boxweight=rs2("Weight")
			end if
			rs2.close
			set rs2=nothing
			weightarray(itemcount)=CDbl(rs4("PackKg"))-CDbl(boxweight)
			grossweightarray(itemcount)=rs4("PackKg")
			wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 1)/2,2)
			totalNW=totalNW+CDbl(weightarray(itemcount))
			totalGW=totalGW+CDbl(grossweightarray(itemcount))	
			componentarray(itemcount)=rs("savoirmodel") & " mattress 1 pc"
		end if
	end if



end if	

if wrap=4 then
	
	call getPackedWithCompDetails(con, pnarray(n), 1, wholesaleprices, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
	itemcount=itemcount+1
	redim preserve componentarray(itemcount)
	redim preserve dimensionsarray(itemcount)
	redim preserve weightarray(itemcount)
	redim preserve grossweightarray(itemcount)
	redim preserve wholesaleprice(itemcount)
	Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where comppartno=1 and purchase_no=" & pnarray(n) & " and componentid = 1", con)
	if not rs4.eof then
		if packpegwith=1 then
			componentarray(itemcount)=rs("savoirmodel") & " mattress & pegboard 2 pc"
		else
			componentarray(itemcount)=rs("savoirmodel") & " mattress 1 pc"
		end if
		'if 1 mattress
		if left(rs("mattresstype"),3)<>"Zip" then
			dimensionsarray(itemcount)=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
			Set rs2 = getMysqlQueryRecordSet("Select * from shippingbox where sname='" & rs4("Boxsize") & "'", con)
			if not rs2.eof then 
				boxweight=rs2("Weight")
			end if
			rs2.close
			set rs2=nothing
			weightarray(itemcount)=CDbl(rs4("PackKg"))-CDbl(boxweight)
			grossweightarray(itemcount)=rs4("PackKg")
			wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 1),2)
			if packedwithCompName<>"" then wholesaleprice(itemcount)=wholesaleprice(itemcount) & "<br>" & packedwithCompPrice
			totalNW=totalNW+CDbl(weightarray(itemcount))
			totalGW=totalGW+CDbl(grossweightarray(itemcount))	
			if packedwithCompName<>"" then componentarray(itemcount)=componentarray(itemcount) & packedwithCompName
			if rs4("boxqty")=2 then
				grossweightarray(itemcount)=CDbl(rs4("PackKg"))-CDbl(boxweight)
				wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 1),2)
				if packedwithCompName<>"" then wholesaleprice(itemcount)=wholesaleprice(itemcount) & "<br>" & packedwithCompPrice
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
				wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 1),2)
				weightarray(itemcount)=CDbl(rs4("PackKg"))-(CDbl(boxweight)*2)
				totalNW=totalNW+CDbl(weightarray(itemcount))
				totalGW=totalGW+CDbl(grossweightarray(itemcount))	
				componentarray(itemcount)=rs("savoirmodel") & " mattress 2 pc"
			end if
		else
		'2 mattresses (FIRST MATT)
		dimensionsarray(itemcount)=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
		Set rs2 = getMysqlQueryRecordSet("Select * from shippingbox where sname='" & rs4("Boxsize") & "'", con)
		if not rs2.eof then 
			boxweight=rs2("Weight")
		end if
		rs2.close
		set rs2=nothing
		weightarray(itemcount)=CDbl(rs4("PackKg"))-CDbl(boxweight)
		grossweightarray(itemcount)=rs4("PackKg")
		wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 1)/2,2)
		if packedwithCompName<>"" then wholesaleprice(itemcount)=wholesaleprice(itemcount) & "<br>" & packedwithCompPrice
		totalNW=totalNW+CDbl(weightarray(itemcount))
		totalGW=totalGW+CDbl(grossweightarray(itemcount))			
		if packedwithCompName<>"" then componentarray(itemcount)=componentarray(itemcount) & packedwithCompName
		if rs4("boxqty")=2 then
				grossweightarray(itemcount)=CDbl(rs4("PackKg"))-CDbl(boxweight)
				wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 1),2)
				if packedwithCompName<>"" then wholesaleprice(itemcount)=wholesaleprice(itemcount) & "<br>" & packedwithCompPrice
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
				wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 1),2)
				if packedwithCompName<>"" then wholesaleprice(itemcount)=wholesaleprice(itemcount) & "<br>" & packedwithCompPrice
				weightarray(itemcount)=CDbl(rs4("PackKg"))-(CDbl(boxweight)*2)
				totalNW=totalNW+CDbl(weightarray(itemcount))
				totalGW=totalGW+CDbl(grossweightarray(itemcount))
				componentarray(itemcount)=rs("savoirmodel") & " mattress 2 pc"
			end if
		rs4.close
		set rs4=nothing
	end if
		
		'2ND MATT
		Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where comppartno=2 and purchase_no=" & pnarray(n) & " and componentid = 1", con)
		if not rs4.eof then
			itemcount=itemcount+1
			redim preserve componentarray(itemcount)
			redim preserve dimensionsarray(itemcount)
			redim preserve weightarray(itemcount)
			redim preserve grossweightarray(itemcount)
			redim preserve wholesaleprice(itemcount)
			dimensionsarray(itemcount)=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
			Set rs2 = getMysqlQueryRecordSet("Select * from shippingbox where sname='" & rs4("Boxsize") & "'", con)
			if not rs2.eof then 
				boxweight=rs2("Weight")
			end if
			rs2.close
			set rs2=nothing
			weightarray(itemcount)=CDbl(rs4("PackKg"))-CDbl(boxweight)
			grossweightarray(itemcount)=rs4("PackKg")
			wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 1)/2,2)
			totalNW=totalNW+CDbl(weightarray(itemcount))
			totalGW=totalGW+CDbl(grossweightarray(itemcount))
			componentarray(itemcount)=rs("savoirmodel") & " mattress 1 pc"
		end if
	end if



end if	
%>