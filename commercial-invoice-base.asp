<%
if rs("componentid")="3" then
	
	Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=3 and componentname = '" & rs("basesavoirmodel") & "'", con)
	
	If not rs2.eof then
		weight=rs2("weight")
		tarrifcode=rs2("TARIFFCODE")
		depth=rs2("depth")
	end if
	rs2.close
	set rs2=nothing
	components=components & "Base "
	redim preserve componentqtyarray(count)
	componentqtyarray(count)=1
	


	call getComponentSizes(con,3,purchase_no, m1width, m1length)
'add base extras
	
	baseqty1=Round((getComponentPriceExVatAfterDiscount(con, purchase_no, 3))/2,2)
	if wholesale="y" then baseqty1=formatnumber(getComponentWholesalePrice2(con, purchase_no, 3)/2,2)
	if wrap=3 or wrap=4 then
		
		Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where purchase_no=" & purchase_no & " and componentid = 3", con) 
		if not rs4.eof then
			call getPackedWithCompDetails(con, purchase_no, 3, wholesale, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
			
			
			do until rs4.eof
				if rs4("comppartno")="1" then
					packweight=rs4("packkg")
					packdimensions=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
					if wrap=4 then
						packcubicmeters1=CDbl(rs4("packwidth")) * CDbl(rs4("packheight")) * CDbl(rs4("packdepth"))
						
					end if
					packagingdata=true
					packqty=rs4("boxqty")
					if (isNull(rs4("boxqty")) or rs4("boxqty")="") then packqty=1
					if wrap=3 then 
						if rs4("boxsize")<>"" then
							call getBoxSizes(con, rs4("boxsize"), boxwidth, boxlength, boxdepth)
							packdimensions=boxwidth & "x" & boxlength & "x" & boxdepth & "cm"
							packcubicmeters1=CDbl(boxwidth) * CDbl(boxlength) * CDbl(boxdepth)
						end if
					end if
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
						componentarray(count)=rs("basesavoirmodel") & " base 1 pc"
						
						cubicmetersarray(count)=packcubicmeters1
						dimensionsarray(count)=packdimensions
						tarrifarray(count)=tarrifcode
						weightarray(count)=packweight
						if (rs("baseprice")="" or IsNull(rs("baseprice"))) then
							componentpricearray(count)=0 + baseextras
							componentunitpricearray(count)=0.00 + baseextras
						else
							componentpricearray(count)=Round((getComponentPriceExVatAfterDiscount(con, purchase_no, 3)/2),2)
							componentunitpricearray(count)=Round((getComponentPriceExVatAfterDiscount(con, purchase_no, 3)/2),2)
							
						end if
						if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 3)/2,2)
						if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 3)/2,2)
					end if
					componentqtyarray(count)=1
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
		tarrifarray(count)=tarrifcode
	end if
	
	if wrap=1 then
		componentqtyarray(count)=1
	end if
		
	
	if packqty=2 then
		dimensionsarray(count)=packdimensions
		componentpricearray(count)=(getComponentPriceExVatAfterDiscount(con, purchase_no, 3))-baseqty1
		componentunitpricearray(count)=formatnumber((getComponentPriceExVatAfterDiscount(con, purchase_no, 3))-baseqty1,2)
		weightarray(count)="1" & packweight
		tarrifarray(count)=tarrifcode & compTariffcode
		componentextrasqtyarray(count)=compQty
		componentqtyarray(count)=1
		componentpriceextrasarray(count)=packedwithCompPrice
		componentunitpriceextrasarray(count)=unitprice
		cubicmetersarray(count)=packcubicmeters1
	end if
	if packagingdata=true and packqty=2 then
		componentarray(count)=rs("basesavoirmodel") & " base 1 pc" & packedwithCompName
	else
		componentarray(count)=rs("basesavoirmodel") & " base 1 pc"
	end if
	if packagingdata=true and packqty<>2 then
		componentqtyarray(count)=1
		componentextrasqtyarray(count)=compQty
		componentarray(count)=componentarray(count) & packedwithCompName
		componentpriceextrasarray(count)=componentpriceextrasarray(count) & packedwithCompPrice
		componentunitpriceextrasarray(count)=componentunitpriceextrasarray(count) & unitprice
	end if
	
	if packqty<>2 then
		if (left(rs("basetype"),3)<>"Eas" and left(rs("basetype"),3)<>"Nor") then
			componentpricearray(count)=getComponentPriceExVatAfterDiscount(con, purchase_no, 3)
			componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 3),2)
			if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 3),2)
			if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 3),2)
			if packagingdata=true and wholesale="n" then
				componentpriceextrasarray(count)=packedwithCompPrice
				componentunitpriceextrasarray(count)=unitprice
			end if
			if right(packedwithcompname,7)="Valance" and wholesale="y" then 
				componentpriceextrasarray(count)=componentpriceextrasarray(count) & getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
				componentunitpriceextrasarray(count)=componentunitpriceextrasarray(count) &  getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
			end if
			
'end if
			if left(rs("basewidth"),4)="Spec" then
				call getComponentWidthSpecialSizes(con,3,purchase_no, m1width)
				hbwidth=m1width
			end if
			if left(rs("baselength"),4)="Spec" then
				call getComponentLengthSpecialSizes(con,3,purchase_no, m1length)
			end if
			weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
			if packagingdata=true then
				dimensionsarray(count)=packdimensions
				cubicmetersarray(count)=packcubicmeters1
				weightarray(count)=packweight
			else
				dimensionsarray(count)=m1width & "x" & m1length & "x" & depth & "cm"
				cubicmetersarray(count)=CDbl(m1width) * CDbl(m1length) * CDbl(depth)
				weightarray(count)=round(weightcalc)
			end if
			
		else
'2 BASES (1ST BASE)
			
			call getComponentSizes(con,3,purchase_no, m1width, m1length)
			if left(rs("basetype"),3)="Nor" then
				hbwidth=m1width
				m1width=CDbl(m1width)/2
			end if
			if left(rs("basetype"),3)="Eas" then
				hbwidth=m1width
				m1length=130
			end if
			if left(rs("basewidth"),4)="Spec" then
				call getComponent1WidthSpecialSizes(con,3,purchase_no, m1width, m2width)
				hbwidth=m1width
				m1width=m1width
			end if
			if left(rs("baselength"),4)="Spec" then
				call getComponent1LengthSpecialSizes(con,3,purchase_no, m1length, m2length)
				m1length=m1length
			end if
			weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
			if packagingdata=true then
				
				dimensionsarray(count)=packdimensions
				cubicmetersarray(count)=packcubicmeters1
				componentextrasqtyarray(count)=compQty
				weightarray(count)=packweight
				if packagingdata2=true then
					
					componentpricearray(count)=(getComponentPriceExVatAfterDiscount(con, purchase_no, 3))-baseqty1
					
					componentunitpricearray(count)=formatnumber((getComponentPriceExVatAfterDiscount(con, purchase_no, 3))-baseqty1,2)
					if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 3)-baseqty1,2)
					if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 3)-baseqty1,2)
					componentarray(count)=rs("basesavoirmodel") & " base 1 pc" & packedwithCompName
				else
					componentpricearray(count)=getComponentPriceExVatAfterDiscount(con, purchase_no, 3)
					componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 3),2)
					if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 3),2)
					if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 3),2)
					componentqtyarray(count)=1
					componentpriceextrasarray(count)=packedwithCompPrice
					componentunitpriceextrasarray(count)=unitprice
					if packqty=2 then
						componentarray(count)=rs("basesavoirmodel") & " base 1 pc"
						componentpricearray(count)=getComponentPriceExVatAfterDiscount(con, purchase_no, 3)/2
						componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 3)/2,2)
						if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 3)/2,2)
						if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 3)/2,2)
					else
						componentarray(count)=rs("basesavoirmodel") & " base 2 pc" & packedwithCompName
						tarrifarray(count)=tarrifcode & compTariffcode
					end if
					
				end if
			else
				componentqtyarray(count)=1
				dimensionsarray(count)=m1width & "x" & m1length & "x" & depth & "cm"
				cubicmetersarray(count)=CDbl(m1width) * CDbl(m1length) * CDbl(depth)
				weightarray(count)=round(weightcalc)
				componentpricearray(count)=(getComponentPriceExVatAfterDiscount(con, purchase_no, 3))/2
				componentunitpricearray(count)=formatnumber((getComponentPriceExVatAfterDiscount(con, purchase_no, 3))/2,2)
				if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 3)/2,2)
				if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 3)/2,2)
				componentarray(count)=rs("basesavoirmodel") & " base 1 pc"
			end if
			
'2ND BASE
			if packagingdata=true and packagingdata2=false then
				
			else
				count=count+1
				call getComponentSizes(con,3,purchase_no, m1width, m1length)
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
				if left(rs("basetype"),3)="Nor" then
						m2width=CDbl(m1width)/2
					m2length=m1length
				end if
				if left(rs("basetype"),3)="Eas" then
					m2width=m1width
					m2length=CDbl(m1length)-130
				end if
				if left(rs("basewidth"),4)="Spec" then
					call getComponent1WidthSpecialSizes(con,3,purchase_no, m1width, m2width)
					if (trim(hbwidth)<>"" and trim(m2width)<>"") then
						hbwidth=CDbl(hbwidth)+CDbl(m2width)
					end if
					m2width=m2width
				end if
				if left(rs("baselength"),4)="Spec" then
					call getComponent1LengthSpecialSizes(con,3,purchase_no, m1length, m2length)
					m2length=m2length
				end if
				if packagingdata2=true then
					dimensionsarray(count)=packdimensions2
					cubicmetersarray(count)=packcubicmeters2
				else
					dimensionsarray(count)=m2width & "x" & m2length & "x" & depth & "cm"
					cubicmetersarray(count)=cleantonumber(m2width) * cleantonumber(m2length) * cleantonumber(depth)
				end if
				
				if m2width<>"" and m2length<>"" then
					weightcalc=((CDbl(m2width) * CDbl(m2length)) * CDbl(weight))+0.5
				end if
				if packagingdata2=true then
					weightarray(count)=CDbl(packweight2)
					componentarray(count)=rs("basesavoirmodel") & " base 1 pc"
				else
					weightarray(count)=round(weightcalc)
					componentarray(count)=rs("basesavoirmodel") & " base 1 pc"
				end if
				tarrifarray(count)=tarrifcode
				componentqtyarray(count)=1
				
				componentpricearray(count)=(getComponentPriceExVatAfterDiscount(con, purchase_no, 3))-baseqty1
				componentunitpricearray(count)=formatnumber(((getComponentPriceExVatAfterDiscount(con, purchase_no, 3))-baseqty1),2)
				if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 3)-baseqty1,2)
				if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 3)-baseqty1,2)
				if packagingdata2=true then
					componentpricearray(count)=(getComponentPriceExVatAfterDiscount(con, purchase_no, 3))/2
					componentunitpricearray(count)=formatnumber((getComponentPriceExVatAfterDiscount(con, purchase_no, 3))/2,2)
					if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 3)/2,2)
					if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 3)/2,2)
				end if
			end if
		end if
		
	end if
	if (rs("baseprice")="" or IsNull(rs("baseprice")) or rs("baseprice")="0" or rs("baseprice")="0.00") then
				componentpricearray(count)=10.00
				componentunitpricearray(count)=formatNumber(10.00,2)
				totalcost=totalcost+10
	end if
	
	if wholesale="n" then
			totalcost=totalcost+getComponentPriceExVatAfterDiscount(con, purchase_no, 3)
	end if
	if wholesale="y" then totalcost=totalcost+getComponentWholesalePrice2(con, purchase_no, 3)

	
end if

%>

