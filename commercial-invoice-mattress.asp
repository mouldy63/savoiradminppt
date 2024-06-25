<%
if rs("componentid")="1" then
	Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=1 and componentname = '" & rs("savoirmodel") & "'", con)
	If not rs2.eof then
		weight=rs2("weight")
		tarrifcode=rs2("TARIFFCODE")
		depth=rs2("depth")
	end if
	rs2.close
	set rs2=nothing
	if wrap=3 or wrap=4 then
		Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where purchase_no=" & purchase_no & " and componentid = 1", con)
		if not rs4.eof then
			call getPackedWithCompDetails(con, purchase_no, 1, wholesale, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
			
			do until rs4.eof
				if rs4("comppartno")="1" then
					packweight=rs4("packkg")
					packdimensions=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
					if wrap=4 then 
						packcubicmeters1=CDbl(rs4("packwidth")) * CDbl(rs4("packheight")) * CDbl(rs4("packdepth"))
					end if
					packagingdata=true
					packqty=rs4("boxqty")
					if wrap=3 then 
						if rs4("boxsize")<>"" then
							call getBoxSizes(con, rs4("boxsize"), boxwidth, boxlength, boxdepth)
							packdimensions=boxwidth & "x" & boxlength & "x" & boxdepth & "cm"
							packcubicmeters1=CDbl(boxwidth) * CDbl(boxlength) * CDbl(boxdepth)
						end if
					end if
					if isNull(packqty) or packqty="" then packqty=1
					
					if packqty=2 then
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
						packweight=CDbl(rs4("packkg"))/2
						componentarray(count)=rs("savoirmodel") & " mattress 1 pc"
						componentqtyarray(count)=1
						cubicmetersarray(count)=packcubicmeters1
						dimensionsarray(count)=packdimensions
						tarrifarray(count)=tarrifcode

						weightarray(count)=packweight
						if (rs("mattressprice")="" or IsNull(rs("mattressprice"))) then
							componentpricearray(count)=10.00
							componentunitpricearray(count)=10.00
						else
							
							componentpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 1)/2,2)
							componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 1)/2,2)
						end if
						if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1)/2,2)
						if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1)/2,2)
					end if
				end if
				if rs4("comppartno")="2" then
					packweight2=rs4("packkg")
					packdimensions2=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
					if wrap=4 then
						packcubicmeters2=CDbl(rs4("packwidth")) * CDbl(rs4("packheight")) * CDbl(rs4("packdepth"))
					end if
					if wrap=3 then 
						if rs4("boxsize")<>"" then
							call getBoxSizes(con, rs4("boxsize"), boxwidth, boxlength, boxdepth)
							packdimensions2=boxwidth & "x" & boxlength & "x" & boxdepth & "cm"
							packcubicmeters2=CDbl(boxwidth) * CDbl(boxlength) * CDbl(boxdepth)
							
						end if
					end if
					packagingdata2=true
					packqty2=rs4("boxqty")
					if packqty2="" then packqty2=1
				end if
				rs4.movenext
			loop
			rs4.close
			set rs4=nothing
		end if
	end if
	
	
	components=components & "Mattress "
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
	if packqty=1 then
		tarrifarray(count)=tarrifcode & compTariffcode
		
	else
		tarrifarray(count)=tarrifcode & compTariffcode
	end if
	if packqty=2 then
		tarrifarray(count)=tarrifcode & compTariffcode
		dimensionsarray(count)=packdimensions
		componentarray(count)=rs("savoirmodel") & " mattress 1 pc"
		componentpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 1)/2,2)
		componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 1)/2,2)
		if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1)/2,2)
		if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1)/2,2)
		
		weightarray(count)=packweight
		cubicmetersarray(count)=packcubicmeters1
		componentpriceextrasarray(count)=packedwithCompPrice
		componentunitpriceextrasarray(count)=unitprice
		'if right(packedwithcompname,7)="Valance" and wholesale="y" then 
		'	componentpriceextrasarray(count)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
		'	componentunitpriceextrasarray(count)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
		'end if
		
		componentextrasqtyarray(count)=compQty
	end if
	
	
	if packagingdata=true then
		componentarray(count)=rs("savoirmodel") & " mattress 1 pc" & packedwithCompName
		componentextrasqtyarray(count)=compQty
		'componentpriceextrasarray(count)=packedwithCompPrice
		componentunitpriceextrasarray(count)=unitprice
		if wrap=3 then 
			weightarray(count)=packweight
			cubicmetersarray(count)=packcubicmeters1
			dimensionsarray(count)=packdimensions
			componentpriceextrasarray(count)=packedwithCompPrice
			'componentunitpriceextrasarray(count)=unitprice
			'if right(packedwithcompname,7)="Valance" and wholesale="y" then 
			'	componentpriceextrasarray(count)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
			'	componentunitpriceextrasarray(count)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
			'end if
			componentextrasqtyarray(count)=compQty
			if (rs("mattressprice")="" or IsNull(rs("mattressprice"))) then
				componentpricearray(count)=10.00
				componentunitpricearray(count)=10.00
			else
				componentpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 1)/2,2)
				componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 1)/2,2)
				if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1)/2,2)
				if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1)/2,2)
			end if
			
		end if
	else
		componentarray(count)=rs("savoirmodel") & " mattress 1 pc"
	end if
	componentqtyarray(count)=1
'if 1 mattress
	if left(rs("mattresstype"),3)<>"Zip" then
		if (rs("mattressprice")="" or IsNull(rs("mattressprice"))) then
			componentpricearray(count)=10.00
			componentunitpricearray(count)=10.00
		else
			componentpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 1),2)
			componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 1),2)
		end if
		if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1),2)
		if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1),2)
		call getComponentSizes(con,1,purchase_no, m1width, m1length)
		if left(rs("mattresswidth"),4)="Spec" then
			call getComponentWidthSpecialSizes(con,1,purchase_no, m1width)
		end if
		if left(rs("mattresslength"),4)="Spec" then
			call getComponentLengthSpecialSizes(con,1,purchase_no, m1length)
		end if
		'response.Write("packagingdata=" & packagingdata & "<br>packqty=" & packqty)
		'response.End() 
		if packagingdata=true and packqty<>2  then
			dimensionsarray(count)=packdimensions
			componentpriceextrasarray(count)=packedwithCompPrice
			componentunitpriceextrasarray(count)=unitprice
			'if right(packedwithcompname,7)="Valance" and wholesale="y" then 
			'	componentpriceextrasarray(count)=componentpriceextrasarray(count) & getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
			'	componentunitpriceextrasarray(count)=componentunitpriceextrasarray(count) &  getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
			'end if
		else
			dimensionsarray(count)=m1width & "x" & m1length & "x" & depth & "cm"
		end if
		cubicmetersarray(count)=CDbl(m1width) * CDbl(m1length) * CDbl(depth)
		weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
		if packagingdata=true then
			weightarray(count)=packweight
			cubicmetersarray(count)=packcubicmeters1
		else
			weightarray(count)=round(weightcalc)
		end if
		hbwidth=m1width
	else
		if packqty<>2 then
			
'2 mattresses (FIRST MATT)
			call getComponentSizes(con,1,purchase_no, m1width, m1length)
			tarrifarray(count)=tarrifcode
			if left(rs("mattresswidth"),4)<>"Spec" then
				hbwidth=m1width
				m1width=m1width/2
			end if 
			if left(rs("mattresswidth"),4)="Spec" then
				call getComponent1WidthSpecialSizes(con,1,purchase_no, m1width, m2width)
				hbwidth=m1width
			end if
			if left(rs("mattresslength"),4)="Spec" then
				call getComponent1LengthSpecialSizes(con,1,purchase_no, m1length, m2length)
			end if
			if packagingdata=true then
				dimensionsarray(count)=packdimensions
			else
				dimensionsarray(count)=m1width & "x" & m1length & "x" & depth & "cm"
			end if
			cubicmetersarray(count)=CDbl(m1width) * CDbl(m1length) * CDbl(depth)
			weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
			if packagingdata=true then
				weightarray(count)=packweight
				cubicmetersarray(count)=packcubicmeters1
				componentextrasqtyarray(count)=compQty
				if packagingdata2=true then
					componentpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 1)/2,2)
					componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 1)/2,2)
					if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1)/2,2)
					if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1)/2,2)
					componentarray(count)=rs("savoirmodel") & " mattress 1 pc" & packedwithCompName
					componentpriceextrasarray(count)=componentpriceextrasarray(count) & packedwithCompPrice
					componentunitpriceextrasarray(count)=componentunitpriceextrasarray(count) & unitprice
					'if right(packedwithcompname,7)="Valance" and wholesale="y" then 
					'	componentpriceextrasarray(count)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
					'	componentunitpriceextrasarray(count)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
					'end if
					
				else
					componentpricearray(count)=CLng(getComponentPriceExVatAfterDiscount(con, purchase_no, 1))
					componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 1),2)
					if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1),2)
					if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1),2)
					if packqty=2 then
						componentarray(count)=rs("savoirmodel") & " mattress 1 pc"
						componentpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 1)/2,2)
						componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 1)/2,2)
						if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1)/2,2)
						if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1)/2,2)
					else
						componentarray(count)=rs("savoirmodel") & " mattress 2 pc" & packedwithCompName
						tarrifarray(count)=tarrifcode & compTariffcode
					end if
				end if
			else
				weightarray(count)=round(weightcalc)
				componentpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 1),2)/2
				componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 1)/2,2)
				if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1)/2,2)
				if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1)/2,2)
				componentarray(count)=rs("savoirmodel") & " mattress 1 pc"
				
			end if
		end if
		
		
		
		if packagingdata=true and packagingdata2=false then
			
		else
'2ND MATT
			
			count=count+1
			redim preserve componentarray(count)
			redim preserve componentpricearray(count)
			redim preserve componentunitpricearray(count)
			redim preserve componentpriceextrasarray(count)
			redim preserve componentunitpriceextrasarray(count)
			redim preserve componentqtyarray(count)
			redim preserve componentextrasqtyarray(count)
			redim preserve dimensionsarray(count)
			redim preserve tarrifarray(count)
			redim preserve weightarray(count)
			redim preserve cubicmetersarray(count)
			tarrifarray(count)=tarrifcode
			
			call getComponentSizes(con,1,purchase_no, m2width, m2length)
			if left(rs("mattresswidth"),4)<>"Spec" then
				m2width=m2width/2
			end if
			if left(rs("mattresswidth"),4)="Spec" then
				call getComponent1WidthSpecialSizes(con,1,purchase_no, m1width, m2width)
				hbwidth=CDbl(hbwidth)+CDbl(m2width)
			end if
			if left(rs("mattresslength"),4)="Spec" then
				call getComponent1LengthSpecialSizes(con,1,purchase_no, m1length, m2length)
			end if
			weightcalc=((CDbl(m2width) * CDbl(m2length)) * CDbl(weight))+0.5
			if packagingdata2=true then
				dimensionsarray(count)=packdimensions2
				cubicmetersarray(count)=packcubicmeters2
				weightarray(count)=CDbl(packweight2)

			else
componentqtyarray(count)=1
				dimensionsarray(count)=m2width & "x" & m2length & "x" & depth & "cm"
				cubicmetersarray(count)=CDbl(m2width) * CDbl(m2length) * CDbl(depth)
				weightarray(count)=round(weightcalc)
			end if
			
			
			componentarray(count)=rs("savoirmodel") & " mattress 1 pc"
			componentpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 1),2)/2
			componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 1)/2,2)
			if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1)/2,2)
			if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 1)/2,2)
		end if
	end if
	if (rs("mattressprice")="" or IsNull(rs("mattressprice")) or rs("mattressprice")="0" or rs("mattressprice")="0.00") then
				componentpricearray(count)=10.00
				componentunitpricearray(count)=formatNumber(10.00,2)
				totalcost=totalcost+10
	end if
	if wholesale="n" then
			totalcost=totalcost+getComponentPriceExVatAfterDiscount(con, purchase_no, 1)
	end if
	if wholesale="y" then totalcost=totalcost+getComponentWholesalePrice2(con, purchase_no, 1)

end if


%>

