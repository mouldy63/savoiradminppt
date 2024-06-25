<%
if rs("componentid")="6" then
Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=6 and componentname = 'Valance'", con)
	
	If not rs2.eof then
		'weight=rs2("weight")
		tarrifcode=rs2("TARIFFCODE")
		'depth=rs2("depth")
	end if
	rs2.close
	set rs2=nothing
	itempackedwith=false
	if wrap=3 or wrap=4 then
		Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where purchase_no=" & purchase_no & " and componentid = 6", con)
		
		if not rs4.eof then
		
			call getPackedWithCompDetails(con, purchase_no, 6, wholesale, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
			do until rs4.eof
				if rs4("packedwith")<>"" and rs4("packedwith")<>"0" then itempackedwith=true
				
				if itempackedwith=false then
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
								packdimensions=CDbl(boxwidth) * CDbl(boxlength) * CDbl(boxdepth)
							end if
						end if
						if isNull(packqty) or packqty="" then packqty=1
					end if
					if rs4("comppartno")="2" then
						packweight2=rs4("packkg")
						packdimensions2=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
						packcubicmeters2=CDbl(rs4("packwidth")) * CDbl(rs4("packheight")) * CDbl(rs4("packdepth"))
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
				end if
				
				rs4.movenext
			loop
			rs4.close
			set rs4=nothing
			
		end if
	end if
	if itempackedwith=false then 
		components=components & "Valance "
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
		call getComponentSizes(con,6,purchase_no, m1width, m1length)
		tarrifarray(count)=tarrifcode & compTariffcode
		if packagingdata=true then
			dimensionsarray(count)=packdimensions
			cubicmetersarray(count)=packcubicmeters1
			weightarray(count)=packweight
			componentextrasqtyarray(count)=compQty
			componentpriceextrasarray(count)=componentpriceextrasarray(count) & packedwithCompPrice
			componentunitpriceextrasarray(count)=componentunitpriceextrasarray(count) & unitprice
			componentarray(count)=rs("toppertype") & "  1 pc" & packedwithCompName
		else
			dimensionsarray(count)=m1width & "x" & m1length & "cm"
			cubicmetersarray(count)="-"
			weightarray(count)="6"
		end if
		
		componentarray(count)="Valance 1 pc"
		componentpricearray(count)=getComponentPriceExVatAfterDiscount(con, purchase_no, 6)
		componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 6),2)
		
		
		if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
		if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 6),2)
		if itempackedwith=false and componentpricearray(count)=0 then 
			componentpricearray(count)=10.00
			componentunitpricearray(count)=formatNumber(10.00,2)
		end if
	end if

if wholesale="n" then
			if rs("valanceprice")="" or isNull(rs("valanceprice")) or rs("valanceprice")="0" or rs("valanceprice")="0.00" then
			totalcost=totalcost+10
			else
			totalcost=totalcost+getComponentPriceExVatAfterDiscount(con, purchase_no, 6)
			end if
	end if
	if wholesale="y" then totalcost=totalcost+getComponentWholesalePrice2(con, purchase_no, 6)

end if

%>



