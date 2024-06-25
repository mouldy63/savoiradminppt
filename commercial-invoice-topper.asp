<%
if rs("componentid")="5" then
	Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=5 and componentname = '" & rs("toppertype") & "'", con)
	If not rs2.eof then
		weight=rs2("weight")
		tarrifcode=rs2("TARIFFCODE")
		depth=rs2("depth")
	end if
	rs2.close
	set rs2=nothing 
	if wrap=3 or wrap=4 then
		Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where purchase_no=" & purchase_no & " and componentid = 5", con)
		if not rs4.eof then
			call getPackedWithCompDetails(con, purchase_no, 5, wholesale, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
			components=components & "Topper "
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
					componentarray(count)=rs("toppertype") & " 1 pc"
					componentqtyarray(count)=1
					cubicmetersarray(count)=packcubicmeters1
					dimensionsarray(count)=packdimensions
					tarrifarray(count)=tarrifcode
					weightarray(count)=packweight
					if (rs("topperprice")="" or IsNull(rs("topperprice")) or rs("topperprice")="0" or rs("topperprice")="0.00") then
						componentpricearray(count)=10
						componentunitpricearray(count)=formatNumber(10.00,2)
					else
						componentpricearray(count)=getComponentPriceExVatAfterDiscount(con, purchase_no, 5)/2
						componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 5)/2,2)
					end if
					if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 5)/2,2)
					if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 5)/2,2)				
				end if
			end if
			if rs4("comppartno")="2" then
				packweight2=rs4("packkg")
				packdimensions2=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
				if wrap=3 then 
					if rs4("boxsize")<>"" then
						call getBoxSizes(con, rs4("boxsize"), boxwidth, boxlength, boxdepth)
						packdimensions2=boxwidth & "x" & boxlength & "x" & boxdepth & "cm"
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
		call getComponentSizes(con,5,purchase_no, m1width, m1length)
		tarrifarray(count)=tarrifcode & compTariffcode
		if left(rs("topperwidth"),4)="Spec" then
			call getComponentWidthSpecialSizes(con,5,purchase_no, m1width)
			m1width=m1width
		end if
		if left(rs("topperlength"),4)="Spec" then
			call getComponentLengthSpecialSizes(con,5,purchase_no, m1length)
			m1length=m1length
		end if
		weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
		if packagingdata=true then
			dimensionsarray(count)=packdimensions
			cubicmetersarray(count)=packcubicmeters1
			weightarray(count)=packweight
			componentextrasqtyarray(count)=compQty
			componentpriceextrasarray(count)=componentpriceextrasarray(count) & packedwithCompPrice
			componentunitpriceextrasarray(count)=componentunitpriceextrasarray(count) & unitprice
			'if right(packedwithcompname,7)="Valance" and wholesale="y" then 
			'	componentpriceextrasarray(count)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
			'	componentunitpriceextrasarray(count)=getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
			'end if
			componentarray(count)=rs("toppertype") & "  1 pc" & packedwithCompName
		else
			componentarray(count)=rs("toppertype") & "  1 pc"
			dimensionsarray(count)=m1width & "x" & m1length & "x" & depth & "cm"
			cubicmetersarray(count)=CDbl(m1width) * CDbl(m1length) * CDbl(depth)
			weightarray(count)=round(weightcalc)
			response.Write("weightcalc=" & weightcalc)
		end if
		
	
		if (rs("topperprice")="" or IsNull(rs("topperprice")) or rs("topperprice")="0" or rs("topperprice")="0.00") then
			componentpricearray(count)=10
			componentunitpricearray(count)=formatNumber(10.00,2)
			topperprice=10
		else
			componentpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 5),2)
			componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 5),2)
			topperprice=getComponentPriceExVatAfterDiscount(con, purchase_no, 5)
			if wholesale="y" then topperprice=getComponentWholesalePrice2(con, purchase_no, 5)
			if packqty=2 then
				componentpricearray(count)=getComponentPriceExVatAfterDiscount(con, purchase_no, 5)/2
				componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 5)/2,2)
				if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 5)/2,2)
				if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 5)/2,2)
			end if
			
		end if
		if componentpricearray(count)=0 then
			componentpricearray(count)=10.00
			componentunitpricearray(count)=formatNumber(10.00,2)
			totalcost=totalcost+10
		end if
		if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 5),2)
		if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 5),2)
		'end if
		
		if wholesale="n" then		
				totalcost=totalcost+topperprice
		end if
		if wholesale="y" then totalcost=totalcost+getComponentWholesalePrice2(con, purchase_no, 5)

end if
%>


