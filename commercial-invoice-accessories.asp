<%
if rs("componentid")="9" then

	itempackedwith=false 
	if wrap=3 or wrap=4 or wrap=2 then
	
		Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where purchase_no=" & purchase_no & " and componentid = 9", con)
		
		if not rs4.eof then
			
			do until rs4.eof
				if rs4("packedwith")<>"" and rs4("packedwith")<>"0" then
					itempackedwith=true
					
				else
					itempackedwith=false
					
				end if
				
					
				if itempackedwith=false then
				
					call getStandaloneAccessoryCompDetails(con, purchase_no, rs4("CompPartNo"), wrap, wholesale, packaccunitprice, acctotalforitem, packaccqty, packaccdesc, packtarrifcode)
					response.write("<br>packaccdesc=" & packaccdesc)
					call getPackedWithCompDetails(con, purchase_no, "9-" & rs4("CompPartNo"), wholesale, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
					if right(packedwithCompName,7)="Valance" then
						accCompPartNo=right(getCompPartNo(con, purchase_no, 6),len(getCompPartNo(con, purchase_no, 6))-2)
					end if
					count=count+1
					redim preserve componentarray(count)
					redim preserve componentpricearray(count)
					redim preserve componentunitpricearray(count)
					redim preserve componentpriceextrasarray(count)
					redim preserve componentunitpriceextrasarray(count)
					redim preserve componentqtyarray(count)
					redim preserve componentextrasqtyarray(count)
					redim preserve dimensionsarray(count)
					redim preserve weightarray(count)
					redim preserve tarrifarray(count)
					redim preserve cubicmetersarray(count)
					if CInt(accCompPartNo)=CInt(rs4("CompPartNo")) then
						componentpriceextrasarray(count)=packedwithCompPrice
						componentextrasqtyarray(count)=compQty
						componentunitpriceextrasarray(count)=compQty
						if wholesale="y" and right(packedwithCompName,7)="Valance" then componentpriceextrasarray(count)=getCurrencySymbolForCurrency(orderCurrency) & formatnumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
						if wholesale="y" and right(packedwithCompName,7)="Valance" then componentunitpriceextrasarray(count)=getCurrencySymbolForCurrency(orderCurrency) & formatnumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
					end if
					
					packweight=rs4("packkg")
					
					componentpricearray(count) = acctotalforitem
					
					if wrap<>2 then
						'if wholesale="y" then componentpricearray(count)=formatnumber(getAccWholesale(con, purchase_no, rs4("CompPartNo")),2)
					end if
					
					if wrap=3 and packedwithCompName="" then
						
						if rs4("packwidth")<>"" and rs4("packheight")<>"" and rs4("packdepth")<>"" then
							packcubicmeters1=CDbl(rs4("packwidth")) * CDbl(rs4("packheight")) * CDbl(rs4("packdepth"))
							cubicmetersarray(count)=packcubicmeters1
						end if
					end if
					if wrap=4 and packedwithCompName="" then
						if rs4("packwidth")<>"" and rs4("packheight")<>"" and rs4("packdepth")<>"" then
							packcubicmeters1=CDbl(rs4("packwidth")) * CDbl(rs4("packheight")) * CDbl(rs4("packdepth"))
							cubicmetersarray(count)=packcubicmeters1
						end if
					end if
					if wrap=3 or wrap=2 then
						tarrifarray(count)=rs4("packtariffcode") & compTariffcode
						componentqtyarray(count) = packaccqty
					end if
					if wrap=2 and packedwithCompName="" then
						if rs4("packwidth")<>"" and rs4("packheight")<>"" and rs4("packdepth")<>"" then
							packcubicmeters1=CDbl(rs4("packwidth")) * CDbl(rs4("packheight")) * CDbl(rs4("packdepth"))
							cubicmetersarray(count)=packcubicmeters1
						end if
						componentqtyarray(count) = getAccWholesaleQty(con, purchase_no, rs4("CompPartNo"))
					end if
					weightarray(count) = rs4("packkg") & getPackedWithAccessoryWeights(con, purchase_no, rs4("CompPartNo"))
					
					response.write("<br>wrap=" & wrap)
					response.write("<br>packaccdesc=" & packaccdesc)
					if wrap = 3 or wrap = 4 or wrap=2 then
						componentarray(count) = packaccdesc
					else
						componentarray(count)="Accessories"
					end if
					
					if CInt(accCompPartNo)=CInt(rs4("CompPartNo")) then
						if packedwithCompName <> "" then componentarray(count) = componentarray(count) & packedwithCompName
					end if
					packdimensions=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
					if wrap=3 or wrap=2 then
						componentunitpricearray(count) = packaccunitprice
						
						if wholesale="y" then 
							call getAccWholesaleUnit(con, purchase_no, rs4("CompPartNo"), orderCurrency, accWholesale, accWholesaleUnit, accWholesaleTotal)
							componentunitpricearray(count) = accWholesaleUnit
							componentpricearray(count) = accWholesale
							wholesaletotal=wholesaletotal + accWholesaleTotal
						end if
						'if wholesale="y" then weightarray(count)=getAccWholesaleWeight(con, purchase_no, rs4("CompPartNo"))
						
						dimensionsarray(count)=packdimensions
					end if
					if wrap=4 then
						componentarray(count) = packaccdesc
						dimensionsarray(count) = packdimensions
						componentqtyarray(count) = packaccqty
						
						componentunitpricearray(count) = packaccunitprice
						
						tarrifarray(count) = packtarrifcode
						if rs4("packwidth")<>"" then packcubicmeters1=packcubicmeters1 * CDbl(rs4("packwidth"))
						if rs4("packheight")<>"" then packcubicmeters1=packcubicmeters1 * CDbl(rs4("packheight"))
						if rs4("packdepth")<>"" then packcubicmeters1=packcubicmeters1 * CDbl(rs4("packdepth"))
						if wholesale="y" then 
							'wholesaletotal=wholesaletotal+getAccWholesale(con, purchase_no, rs4("CompPartNo"))
						end if
					end if

				

					packagingdata=true
					packqty=rs4("boxqty")
					if wrap=3 then 
						if rs4("boxsize")<>"" then
							call getBoxSizes(con, rs4("boxsize"), boxwidth, boxlength, boxdepth)
							packdimensions=boxwidth & "x" & boxlength & "x" & boxdepth & "cm"
						end if
					end if
					if isNull(packqty) or packqty="" then packqty=1
					
				end if
				rs4.movenext
			loop
			
			rs4.close
			set rs4=nothing

		end if
		
		
	end if 
	
	
	if wrap=1 then
		if itempackedwith=false then
			components=components & "Accessories "
			count=count+1
			redim preserve componentarray(count)
			redim preserve componentpricearray(count)
			redim preserve componentunitpricearray(count)
			redim preserve componentpriceextrasarray(count)
			redim preserve componentunitpriceextrasarray(count)
			redim preserve componentqtyarray(count)
			redim preserve componentextrasqtyarray(count)
			redim preserve dimensionsarray(count)
			redim preserve weightarray(count)
			redim preserve tarrifarray(count)
			redim preserve cubicmetersarray(count)
			call getStandaloneAccessoryCompDetails(con, purchase_no, NULL, wrap, wholesale, packaccunitprice, acctotalforitem, packaccqty, packaccdesc, packtarrifcode)
			componentarray(count)=packaccdesc
			componentqtyarray(count)=packaccqty
			componentunitpricearray(count)=packaccunitprice
			componentpricearray(count) = acctotalforitem			
			cubicmetersarray(count)="-"
			weightcalc="-"
			weightarray(count)=weightcalc
			'componentunitpricearray(count)=formatNumber(rs("accessoriestotalcost"),2)
			'componentpricearray(count)=formatNumber(rs("accessoriestotalcost"),2)
			
			
			'if wholesale="y" then
			
			'componentpricearray(count)=getAccWholesaleTotal(con, purchase_no)
			'componentunitpricearray(count)=formatNumber(getAccWholesaleTotal(con, purchase_no),2)
			'totalcost=totalcost+getAccWholesaleTotal(con, purchase_no)
			'end if

				
		end if
	end if
	
    'if wholesale="n" and itempackedwith=false then
	'totalcost=totalcost+getSumOfValues(componentpricearray(count))
	'response.Write("totcost=" & totalcost)
	'response.End()
	'end if
	if wholesale="n" then
	call getStandaloneAccessoryCompDetails(con, purchase_no, NULL, wrap, wholesale, packaccunitprice, acctotalforitem, packaccqty, packaccdesc, packtarrifcode)
	acctotalforitem=replace(acctotalforitem,"&#8364;","")
	totalcost=totalcost+getSumOfValues(acctotalforitem)
	'response.Write("totcost=" & totalcost)
	'response.End()
	end if
	
	if wholesale="y" and wrap<>4 and wrap<>1 then
	totalcost=totalcost+wholesaletotal
	end if
	if wrap=4 and wholesale="y" and itempackedwith=false then
		totalcost=totalcost+getSumOfValues(componentpricearray(count))
	end if
	if (wrap=4 or wrap=3) and wholesale="y" and itempackedwith=true then
		totalcost=totalcost+getAccWholesaleTotal(con, purchase_no)
	end if
	
end if
%>
