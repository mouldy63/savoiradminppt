<%packagingdata=false
Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=7", con)
	If not rs2.eof then
			weight=rs2("weight")
			depth=rs2("depth")
			tarrifcode=rs2("TARIFFCODE")
	end if
rs2.close
set rs2=nothing
if rs("componentid")="7" then
	itempackedwith=false 
	if (wrap=3 or wrap=4) then
	
		Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where purchase_no=" & purchase_no & " and componentid = 7", con)
		if not rs4.eof then
			call getPackedWithCompDetails(con, purchase_no, 7, wholesale, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
			if rs4("packedwith")<>"" and rs4("packedwith")<>0 then itempackedwith=true
			if itempackedwith=false then
				do until rs4.eof
					
					if rs4("comppartno")="1" then
						packweight=rs4("packkg")
						packdimensions=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
						if wrap=4 then
							packcubicmeters1=CDbl(rs4("packwidth")) * CDbl(rs4("packheight")) * CDbl(rs4("packdepth"))
						end if
						packagingdata=true
						packqty=rs4("boxqty")
						
						if (wrap=3) then
							if rs4("boxsize")<>"" then 
								call getBoxSizes(con, "LegBox", boxwidth, boxlength, boxdepth)
								packdimensions=boxwidth & "x" & boxlength & "x" & boxdepth & "cm"
								packcubicmeters1=CDbl(boxwidth) * CDbl(boxlength) * CDbl(boxdepth)
								if rs4("boxsize")="Double Leg Box" then 
									packdimensions=boxwidth & "x" & boxlength & "x" & CDbl(boxdepth)*2 & "cm"
									packcubicmeters1=CDbl(boxwidth) * CDbl(boxlength) * (CDbl(boxdepth)*2)
								end if
								
							end if
						end if
						if isNull(packqty) or packqty="" then packqty=1
					end if
					if rs4("comppartno")="2" then
						packweight2=rs4("packkg")
						
						packdimensions2=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
						if wrap=4 then
							packcubicmeters2=CDbl(rs4("packwidth")) * CDbl(rs4("packheight")) * CDbl(rs4("packdepth"))					
						end if
						if (wrap=3) then
							if rs4("boxsize")<>"" then 
								call getBoxSizes(con, "LegBox", boxwidth, boxlength, boxdepth)
								packdimensions2=boxwidth & "x" & boxlength & "x" & boxdepth & "cm"
								packcubicmeters2=CDbl(boxwidth) * CDbl(boxlength) * CDbl(boxdepth)
								if rs4("boxsize")="Double Leg Box" then 
									packdimensions2=boxwidth & "x" & boxlength & "x" & (CDbl(boxdepth)*2) & "cm"
									packcubicmeters2=CDbl(boxwidth) * CDbl(boxlength) * (CDbl(boxdepth)*2)
								end if
							end if
						end if
						packagingdata2=true
						packqty2=rs4("boxqty")
						if packqty2="" then packqty2=1
					end if
					rs4.movenext
				loop
			end if
			rs4.close
			set rs4=nothing
		end if
	end if
	if itempackedwith=false then
	
		if rs("legQty")<>"" then
			legno=rs("legQty")
		end if
		if rs("AddLegQty")<>"" then
			legno=legno + rs("AddLegQty")
		end if
		if rs("headboardlegqty")<>"" then
			legno=legno + rs("headboardlegqty")
		end  if
			
			call getComponentSizes(con,7,purchase_no, legheight, legfinish)
			components=components & "Legs "
			count=count+1
			redim preserve componentarray(count)
			redim preserve componentpricearray(count)
			redim preserve componentunitpricearray(count)
			redim preserve componentpriceextrasarray(count)
			redim preserve componentunitpriceextrasarray(count)
			redim preserve componentqtyarray(count)
			redim preserve componentextrasqtyarray(count)
			redim preserve tarrifarray(count)
			redim preserve dimensionsarray(count)
			redim preserve weightarray(count)
			redim preserve cubicmetersarray(count)
			componentqtyarray(count)=1
			tarrifarray(count)=tarrifcode & compTariffcode
			if left(rs("legheight"),4)="Spec" then
				call getComponentWidthSpecialSizes(con,7,purchase_no, m1height)
				legheight=m1height
			end if
			if packagingdata=true then
				dimensionsarray(count)=packdimensions
				componentextrasqtyarray(count)=compQty
				componentpriceextrasarray(count)=componentpriceextrasarray(count) & packedwithCompPrice
				componentunitpriceextrasarray(count)=componentunitpriceextrasarray(count) & unitprice
				'if right(packedwithcompname,7)="Valance" and wholesale="y" then 
				'	componentpriceextrasarray(count)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
				'	componentunitpriceextrasarray(count)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
					
				'end if
				
				componentarray(count)=" Legs (" & legno & ") and Fittings 1 box" & packedwithCompName
				
			else
				componentarray(count)=" Legs (" & legno & ") and Fittings 1 box"		
				dimensionsarray(count)="22 x 42 x 27cm"
			end if
			weightcalc=((CDbl(legno) * 27 * CDbl(weight))/1000)+0.5
			if packagingdata=true then
				weightarray(count)=packweight
				cubicmetersarray(count)=packcubicmeters1
			else
				weightarray(count)=round(weightcalc)
				cubicmetersarray(count)=24948
			end if
			if rs("legprice")<>"" then
				componentpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 7),2)
				componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 7),2)
			else
				componentpricearray(count)=10
				componentunitpricearray(count)=formatNumber(10.00,2)
			end if
			if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 7),2)
			if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 7),2)
			
			
			
		end if
			
		if wholesale="n" then
					totalcost=totalcost+getComponentPriceExVatAfterDiscount(con, purchase_no, 7)
		end if
		if wholesale="y" then totalcost=totalcost+getComponentWholesalePrice2(con, purchase_no, 7)
	end if
%>



