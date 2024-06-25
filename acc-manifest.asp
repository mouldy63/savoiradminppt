<%if wrap=1 then
	itemcount=itemcount+1
	redim preserve componentarray(itemcount)
	redim preserve dimensionsarray(itemcount)
	redim preserve weightarray(itemcount)
	redim preserve grossweightarray(itemcount)
	redim preserve wholesaleprice(itemcount)
	dimensionsarray(itemcount)="-"
	weightcalc="-"
	weightarray(itemcount)=weightcalc
	grossweightarray(itemcount)=weightcalc
	wholesaleprice(itemcount)=1
	componentarray(itemcount)="Accessories"							
end if
if wrap=2 then
	itempackedwith=false 
	Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where purchase_no=" & pnarray(n) & " and componentid = 9 order by PackedWith asc", con)
	if not rs4.eof then					
		do until rs4.eof
		if rs4("packedwith")<>"" and rs4("packedwith")<>"0" then
			itempackedwith=true
		else
			itempackedwith=false
		end if
		if itempackedwith=false then
			Set rs3 = getMysqlQueryRecordSet("Select * from orderaccessory where orderaccessory_id=" & rs4("CompPartNo"), con)
			if not rs3.eof then 
				itemcount=itemcount+1
				redim preserve componentarray(itemcount)
				redim preserve dimensionsarray(itemcount)
				redim preserve weightarray(itemcount)
				redim preserve grossweightarray(itemcount)
				redim preserve wholesaleprice(itemcount)
				componentarray(itemcount)=rs3("description")
				dimensionsarray(itemcount)=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
				weightcalc=rs4("packkg")
				weightarray(itemcount)=weightcalc
				grossweightarray(itemcount)=weightcalc
				wholesaleprice(itemcount)=1
				if rs4("PackKg")<>"" then
						totalNW=totalNW+CDbl(weightarray(itemcount))
						totalGW=totalGW+CDbl(grossweightarray(itemcount))
				end if
			rs3.close
			set rs3=nothing
			end if
		end if
		if itempackedwith=true then
		call getPackedWithCompDetails(con, pnarray(n), 9, wholesaleprices, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
		Set rs3 = getMysqlQueryRecordSet("Select * from orderaccessory where orderaccessory_id=" & rs4("CompPartNo"), con)
			if not rs3.eof then
				componentarray(itemcount)=componentarray(itemcount) & "<br>" & rs3("description")
			end if
		rs3.close
		set rs3=nothing
		end if
	rs4.movenext
	loop
	rs4.close
	set rs4=nothing
	end if
end if
if wrap=3 then
	itempackedwith=false 
	Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where purchase_no=" & pnarray(n) & " and componentid = 9 order by PackedWith asc", con)
	if not rs4.eof then
	call getPackedWithCompDetails(con, pnarray(n), 9, wholesaleprices, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
		do until rs4.eof
		if rs4("packedwith")<>"" and rs4("packedwith")<>"0" then
			itempackedwith=true
		else
			itempackedwith=false
		end if
		if itempackedwith=false then
		Set rs3 = getMysqlQueryRecordSet("Select * from orderaccessory where orderaccessory_id=" & rs4("CompPartNo"), con)
			if not rs3.eof then 
				itemcount=itemcount+1
				redim preserve componentarray(itemcount)
				redim preserve dimensionsarray(itemcount)
				redim preserve weightarray(itemcount)
				redim preserve grossweightarray(itemcount)
				redim preserve wholesaleprice(itemcount)
				componentarray(itemcount)=rs3("description")
				dimensionsarray(itemcount)=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
				weightcalc=rs4("packkg")
			rs3.close
			set rs3=nothing
			end if
			Set rs2 = getMysqlQueryRecordSet("Select * from shippingbox where sname='" & rs4("Boxsize") & "'", con)
			if not rs2.eof then 
				boxweight=rs2("Weight")
			end if
			rs2.close
			set rs2=nothing
			grossweightarray(itemcount)=rs4("PackKg")
			wholesaleprice(itemcount)=1
			weightarray(itemcount)=rs4("PackKg")
			if rs4("PackKg")<>"" then
			totalNW=totalNW+CDbl(weightarray(itemcount))
			totalGW=totalGW+CDbl(grossweightarray(itemcount))
			end if
		end if
		if itempackedwith=true then
			call getPackedWithCompDetails(con, pnarray(n), 9, wholesaleprices, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
			Set rs3 = getMysqlQueryRecordSet("Select * from orderaccessory where orderaccessory_id=" & rs4("CompPartNo"), con)
				if not rs3.eof then
					'componentarray(itemcount)=componentarray(itemcount) & "<br>" & rs3("description")
				end if
			rs3.close
			set rs3=nothing
		end if
	rs4.movenext
	loop
	rs4.close
	set rs4=nothing
	end if
end if	

if wrap=4 then

	itempackedwith=false 
	call getPackedWithCompDetails(con, pnarray(n), 9, wholesaleprices, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
		Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where comppartno=1 and purchase_no=" & pnarray(n) & " and componentid = 9", con)
		if not rs4.eof then
		if rs4("packedwith")<>"" and rs4("packedwith")<>"0" then
			itempackedwith=true
		else
			itempackedwith=false
		end if
		if itempackedwith=false then
	
			itemcount=itemcount+1
			redim preserve componentarray(itemcount)
			redim preserve dimensionsarray(itemcount)
			redim preserve weightarray(itemcount)
			redim preserve grossweightarray(itemcount)
			redim preserve wholesaleprice(itemcount)
			weightcalc=rs4("packkg")
			dimensionsarray(itemcount)=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
			Set rs3 = getMysqlQueryRecordSet("Select * from orderaccessory where purchase_no=" & pnarray(n), con)
			if not rs3.eof then 
			do until rs3.eof	
				componentarray(itemcount)=rs3("description") & "<br>" & componentarray(itemcount)
				accdesccounter=accdesccounter+1
				wholesaleprice(itemcount)=rs3("wholesaleprice") & "<br>" & wholesaleprice(itemcount)
			rs3.movenext
			loop	
			rs3.close
			set rs3=nothing
			end if
			componentarray(itemcount)=componentarray(itemcount) & packedwithCompName
			Set rs2 = getMysqlQueryRecordSet("Select * from shippingbox where sname='" & rs4("Boxsize") & "'", con)
			if not rs2.eof then 
				boxweight=rs2("Weight")
			end if
			rs2.close
			set rs2=nothing
			grossweightarray(itemcount)=rs4("PackKg")
			if packedwithCompName<>"" then wholesaleprice(itemcount)=wholesaleprice(itemcount) & "<br>" & packedwithCompPrice
			weightarray(itemcount)=rs4("PackKg")
			if rs4("PackKg")<>"" then
			totalNW=totalNW+CDbl(weightarray(itemcount))
			totalGW=totalGW+CDbl(grossweightarray(itemcount))
			end if
		end if
		if itempackedwith=true then
			call getPackedWithCompDetails(con, pnarray(n), 9, wholesaleprices, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
			Set rs3 = getMysqlQueryRecordSet("Select * from orderaccessory where orderaccessory_id=" & rs4("CompPartNo"), con)
				if not rs3.eof then
					'componentarray(itemcount)=componentarray(itemcount) & "<br>" & rs3("description")
				end if
			rs3.close
			set rs3=nothing
		end if
	rs4.close
	set rs4=nothing
	end if
	
	'compartno2 section
	Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where comppartno=2 and purchase_no=" & pnarray(n) & " and componentid = 9", con)
		if not rs4.eof then
			itemcount=itemcount+1
			redim preserve componentarray(itemcount)
			redim preserve dimensionsarray(itemcount)
			redim preserve weightarray(itemcount)
			redim preserve grossweightarray(itemcount)
			redim preserve wholesaleprice(itemcount)
			weightcalc=rs4("packkg")
			dimensionsarray(itemcount)=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"	
			componentarray(itemcount)="Accessory Box 2"
			Set rs2 = getMysqlQueryRecordSet("Select * from shippingbox where sname='" & rs4("Boxsize") & "'", con)
			if not rs2.eof then 
				boxweight=rs2("Weight")
			end if
			rs2.close
			set rs2=nothing
			grossweightarray(itemcount)=rs4("PackKg")
			wholesaleprice(itemcount)=1
			weightarray(itemcount)=rs4("PackKg")
			if rs4("PackKg")<>"" then
			totalNW=totalNW+CDbl(weightarray(itemcount))
			totalGW=totalGW+CDbl(grossweightarray(itemcount))
			end if
	rs4.close
	set rs4=nothing
	end if
end if	
%>