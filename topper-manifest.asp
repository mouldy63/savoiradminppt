<%Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=5 and componentname = '" & rs("toppertype") & "'", con)
If not rs2.eof then
		weight=rs2("weight")
		tarrifcode=rs2("TARIFFCODE")
		depth=rs2("depth")
end if
rs2.close
set rs2=nothing 
if wrap=1 or wrap=2 then
						
							components=components & "Topper "
							itemcount=itemcount+1
							redim preserve componentarray(itemcount)
							redim preserve dimensionsarray(itemcount)
							redim preserve weightarray(itemcount)
							redim preserve grossweightarray(itemcount)
							redim preserve wholesaleprice(itemcount)
							call getComponentSizes(con,5,pnarray(n), m1width, m1length)

							if left(rs("topperwidth"),4)="Spec" then
											call getComponentWidthSpecialSizes(con,5,pnarray(n), m1width)
											m1width=m1width
									end if
									if left(rs("topperlength"),4)="Spec" then
											call getComponentLengthSpecialSizes(con,5,pnarray(n), m1length)
											m1length=m1length
									end if
							dimensionsarray(itemcount)=m1width & "x" & m1length & "x" & depth & "cm"
							weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
							weightarray(itemcount)=round(weightcalc)
							grossweightarray(itemcount)=round(weightcalc)
							wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 5),2)
							totalNW=totalNW+CDbl(weightarray(itemcount))
							totalGW=totalGW+CDbl(grossweightarray(itemcount))
							if packpegwith=5 then
								componentarray(itemcount)=rs("toppertype") & " & pegboard 2 pc"
							else
								componentarray(itemcount)=rs("toppertype") & "  1 pc"
							end if
end if
if wrap=3 then
Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where purchase_no=" & pnarray(n) & " and componentid = 5", con)
	if not rs4.eof then
	call getPackedWithCompDetails(con, pnarray(n), 5, wholesaleprices, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
	if rs4("packedwith")<>"" and rs4("packedwith")<>0 then itempackedwith=true
		if itempackedwith=false then
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
			if packpegwith=5 then
				componentarray(itemcount)=rs("toppertype") & " & pegboard 2 pc"
			else
				componentarray(itemcount)=rs("toppertype") & "  1 pc"
			end if
			if packedwithCompName<>"" then componentarray(itemcount)=componentarray(itemcount) &  packedwithCompName
			Set rs2 = getMysqlQueryRecordSet("Select * from shippingbox where sname='" & rs4("Boxsize") & "'", con)
			if not rs2.eof then 
				boxweight=rs2("Weight")
			end if
			rs2.close
			set rs2=nothing
			grossweightarray(itemcount)=rs4("PackKg")
			wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 5),2)
			weightarray(itemcount)=CDbl(rs4("PackKg"))-CDbl(boxweight)
			totalNW=totalNW+CDbl(weightarray(itemcount))
			totalGW=totalGW+CDbl(grossweightarray(itemcount))
		end if
	end if
end if

if wrap=4 then
response.write("acctest=" & pnarray(n))

call getPackedWithCompDetails(con, pnarray(n), 5, wholesaleprices, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)

	Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where comppartno=1 and purchase_no=" & pnarray(n) & " and componentid = 5", con)
	if not rs4.eof then
		if rs4("packedwith")<>"" and rs4("packedwith")<>0 then itempackedwith=true
		if itempackedwith=false then
			itemcount=itemcount+1
			redim preserve componentarray(itemcount)
			redim preserve dimensionsarray(itemcount)
			redim preserve weightarray(itemcount)
			redim preserve grossweightarray(itemcount)
			redim preserve wholesaleprice(itemcount)
			dimensionsarray(itemcount)=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
			if packpegwith=5 then
				componentarray(itemcount)=rs("toppertype") & " & pegboard 2 pc"
			else
				componentarray(itemcount)=rs("toppertype") & "  1 pc"
			end if
			if packedwithCompName<>"" then componentarray(itemcount)=componentarray(itemcount) &  packedwithCompName
			Set rs2 = getMysqlQueryRecordSet("Select * from shippingbox where sname='" & rs4("Boxsize") & "'", con)
			if not rs2.eof then 
				boxweight=rs2("Weight")
			end if
			rs2.close
			set rs2=nothing
			grossweightarray(itemcount)=rs4("PackKg")
			wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 5),2)
			if packedwithCompName<>"" then wholesaleprice(itemcount)=wholesaleprice(itemcount) & "<br>" & packedwithCompPrice
			weightarray(itemcount)=CDbl(rs4("PackKg"))-CDbl(boxweight)
			totalNW=totalNW+CDbl(weightarray(itemcount))
			totalGW=totalGW+CDbl(grossweightarray(itemcount))

			if rs4("boxqty")=2 then
				grossweightarray(itemcount)=CDbl(rs4("PackKg"))-CDbl(boxweight)
				wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 5),2)
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
				wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 5),2)
				weightarray(itemcount)=CDbl(rs4("PackKg"))-(CDbl(boxweight)*2)
				totalNW=totalNW+CDbl(weightarray(itemcount))
				totalGW=totalGW+CDbl(grossweightarray(itemcount))
				componentarray(itemcount)=rs("toppertype") & "  2nd pc"
			end if
		end if
		
		rs4.close
		set rs4=nothing
		end if
		Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where comppartno=2 and purchase_no=" & pnarray(n) & " and componentid = 5", con)
	if not rs4.eof then
		itemcount=itemcount+1
				redim preserve componentarray(itemcount)
				redim preserve dimensionsarray(itemcount)
				redim preserve weightarray(itemcount)
				redim preserve grossweightarray(itemcount)
				redim preserve wholesaleprice(itemcount)
				dimensionsarray(itemcount)=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
				grossweightarray(itemcount)=CDbl(rs4("PackKg"))-CDbl(boxweight)
				wholesaleprice(itemcount)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, pnarray(n), 5),2)
				weightarray(itemcount)=CDbl(rs4("PackKg"))-(CDbl(boxweight)*2)
				totalNW=totalNW+CDbl(weightarray(itemcount))
				totalGW=totalGW+CDbl(grossweightarray(itemcount))
				componentarray(itemcount)=rs("toppertype") & "  2nd pc"
	rs4.close
	set rs4=nothing
	end if
end if		%>