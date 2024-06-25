<%
if rs("componentid")="8" then
	
	if (wrap=1 or wrap=2 or wrap=3 or wrap=4) then
		Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where purchase_no=" & purchase_no & " and componentid = 8", con)
		if not rs4.eof then
			call getPackedWithCompDetails(con, purchase_no, 8, wholesale, packedwithCompName, packedwithCompPrice, compQty, compTotal, compTariffcode, unitprice)
			
			do until rs4.eof
				if rs4("comppartno")="1" then
					packweight=rs4("packkg")
					
					packdimensions=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
					
					if (wrap=4 or wrap=2 or wrap=1) then
						packcubicmeters1=CDbl(rs4("packwidth")) * CDbl(rs4("packheight")) * CDbl(rs4("packdepth"))
					end if
					packagingdata=true
					packqty=rs4("boxqty")
					if (wrap=3) then
						if rs4("boxsize")<>"" then 
							call getBoxSizes(con, rs4("boxsize"), boxwidth, boxlength, boxdepth)
							packdimensions=boxwidth & "x" & boxlength & "x" & boxdepth & "cm"
							packcubicmeters1=CDbl(boxwidth) * CDbl(boxlength) * CDbl(boxdepth)
						end if
					end if
					if isNull(packqty) or packqty="" then packqty=1
				end if
				if rs4("comppartno")="2" then
					packweight2=rs4("packkg")
					if wrap=4 then
						packdimensions2=rs4("packwidth") & "x" & rs4("packheight") & "x" & rs4("packdepth") & "cm"
					end if
					packcubicmeters1=CDbl(rs4("packwidth")) * CDbl(rs4("packheight")) * CDbl(rs4("packdepth"))
					
					if (wrap=3 or wrap=2) then
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
		Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=8 and componentname = '" & rs("headboardstyle") & "'", con)
	If not rs2.eof then
		weight=rs2("weight")
		tarrifcode=rs2("TARIFFCODE")
		depth=rs2("depth")
	else
		tarrifcode="-"
	end if
	rs2.close
	set rs2=nothing 
	
	components=components & "Headboard "
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
	componentqtyarray(count)=1
	tarrifarray(count)=tarrifcode & compTariffcode
	if rs("headboardheight")="TBC" then hbheight=215 else hbheight=cleantonumber(rs("headboardheight"))
	if rs("headboardWidth")<>"" then 
		hbwidth=rs("headboardWidth")
	else
		if hbwidth="" then hbwidth=getHbWidth(con,purchase_no)
		if hbwidth="" then hbwidth=0
	end if
	
	if left(rs("headboardheight"),4)<>"Spec" then
		if depth="" then depth=15
		if hbwidth<>"n" then
			cubicmetersarray(count)=CDbl(hbwidth) * hbheight * CDbl(depth)
		end if
	else
		cubicmetersarray(count)="-"
	end if
	
	if packagingdata=true then
		dimensionsarray(count)=packdimensions
		cubicmetersarray(count)=packcubicmeters1
		componentextrasqtyarray(count)=compQty
		componentpriceextrasarray(count)=componentpriceextrasarray(count) & packedwithCompPrice
		componentunitpriceextrasarray(count)=componentunitpriceextrasarray(count) & unitprice
		componentarray(count)=rs("headboardstyle") & " Headboard 1 pc" & packedwithCompName
	else
		componentarray(count)=rs("headboardstyle") & " Headboard 1 pc"
		if hbwidth<>"" then
			dimensionsarray(count)=hbwidth & "x" & hbheight & " "
		else
			dimensionsarray(count)=hbheight & " "
		end if
	end if
	if hbwidth<>"n" then
		weightcalc=((CDbl(hbwidth)) * CDbl(weight))+0.5
	end if
	if packagingdata=true then
		weightarray(count)=packweight
	else
		weightarray(count)=round(weightcalc)
	end if
	componentpricearray(count)=getComponentPriceExVatAfterDiscount(con, purchase_no, 8)
	
	componentunitpricearray(count)=formatnumber(getComponentPriceExVatAfterDiscount(con, purchase_no, 8),2)
	if componentpricearray(count)=0 then
		componentpricearray(count)=10.00
		componentunitpricearray(count)=formatNumber(10.00,2)
		totalcost=totalcost+10
	end if
	if wholesale="y" then componentunitpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 8),2)
	if wholesale="y" then componentpricearray(count)=formatnumber(getComponentWholesalePrice2(con, purchase_no, 8),2)
	if wholesale="n" then 
			totalcost=totalcost+getComponentPriceExVatAfterDiscount(con, purchase_no, 8)
	end if
	if wholesale="y" then totalcost=totalcost+getComponentWholesalePrice2(con, purchase_no, 8)
	
end if
%>

