<%
Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=7", con)
	If not rs2.eof then
			weight=rs2("weight")
			depth=rs2("depth")
	end if
rs2.close
set rs2=nothing

if rs("legQty")<>"" then
	legno=rs("legQty")
end if
if rs("AddLegQty")<>"" then
	legno=legno + rs("AddLegQty")
end if
if rs("headboardlegqty")<>"" then
	legno=legno + rs("headboardlegqty")
end  if
if wrap=2 or wrap=1 then
							
	components=components & "Legs "
	itemcount=itemcount+1
	redim preserve componentarray(itemcount)
	redim preserve dimensionsarray(itemcount)
	redim preserve weightarray(itemcount)
	redim preserve grossweightarray(itemcount)
	redim preserve wholesaleprice(itemcount)
	Set rs2 = getMysqlQueryRecordSet("Select * from shippingbox where sname='LegBox'", con)
	if not rs2.eof then 
		dimensionsarray(itemcount)=rs2("width") & "x" & rs2("height") & "x" & rs2("depth") & "cm"
	end if
	rs2.close
	set rs2=nothing
	weightcalc=((CDbl(legno) * 27 * CDbl(weight))/1000)+0.5
	weightarray(itemcount)=round(weightcalc)
	grossweightarray(itemcount)=round(weightcalc)
	wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 7),2)
	totalNW=totalNW+CDbl(weightarray(itemcount))
	totalGW=totalGW+CDbl(grossweightarray(itemcount))
	componentarray(itemcount)=" Legs (" & legno & ") and Fittings 1 box"
end if

if wrap=3 then
	boxname=""
	Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where purchase_no=" & pnarray(n) & " and componentid = 7", con)
	
	if not rs4.eof then
		call getPackedWithCompDetails(con, pnarray(n), 7, wholesaleprices, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
		if rs4("packedwith")<>"" and rs4("packedwith")<>0 then itempackedwith=true
		if itempackedwith=false then
			components=components & "Legs "
			itemcount=itemcount+1
			redim preserve componentarray(itemcount)
			redim preserve dimensionsarray(itemcount)
			redim preserve weightarray(itemcount)
			redim preserve grossweightarray(itemcount)
			redim preserve wholesaleprice(itemcount)
			boxname=Replace(rs4("Boxsize")," ","")
			Set rs2 = getMysqlQueryRecordSet("Select * from shippingbox where sname like '" & boxname & "'", con)
			if not rs2.eof then 
				dimensionsarray(itemcount)=rs2("width") & "x" & rs2("height") & "x" & rs2("depth") & "cm"
			end if
			rs2.close
			set rs2=nothing
			weightcalc=((CDbl(legno) * 27 * CDbl(weight))/1000)+0.5
			weightarray(itemcount)=round(weightcalc)
			grossweightarray(itemcount)=round(weightcalc)
			wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 7),2)
			totalNW=totalNW+CDbl(weightarray(itemcount))
			totalGW=totalGW+CDbl(grossweightarray(itemcount))
			componentarray(itemcount)=" Legs (" & legno & ") and Fittings 1 box"
		end if
		rs4.close
		set rs4=nothing
	end if
end if
response.write("testlegs=" & pnarray(n))
%>