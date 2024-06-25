<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="componentfuncs.asp" -->
<%
dim con, sql, rs, rs2, pn, compId
dim width, length, defaultBoxSize1, defaultBoxSize2, defaultWeight1, defaultWeight2, m1width, m2width, m1length, m2length, t1width, t1length
dim defaultPackWidth, defaultPackHeight, defaultPackDepth, defaultPackKG, defaultCrateQty, mattressonly, mattresstopper, compdepth, internalCrateAllow, PackAllowance, RoundToNearest, AddCrateAllow, mattresszipped, topperdepth, legsmattress, legsDepth, cratemultiplier, crateweight, shippingcrateweight, componentweight, basenumber, legsbase, legstopper, legshb, legsWidth, legsHeight, legno, legweight, valanceweight, valancebase, valancemattress, valancetopper, valancehb, totalwidth, topperonly, overallwidth, overalllength, crateName1, crateLength1, crateWidth1, crateHeight1, crateWeight1, crateName2, crateLength2, crateWidth2, crateHeight2, crateWeight2, crateName3, crateLength3, crateWidth3, crateHeight3, crateWeight3, crateName4, crateLength4, crateWidth4, crateHeight4, crateWeight4, crateName5, crateLength5, crateWidth5, crateHeight5, crateWeight5, defaultPackLength, crateExpak, crateQty, internalCrateLength4, internalCrateWidth4, internalCrateHeight4, legspackedwith, valancepackedwith, accpackedwith, accessoryqty
accessoryqty=0
RoundToNearest=1
topperonly="n"
basenumber=1

crateQty=0
cratemultiplier=1 ' unless 2 matt or bases
crateweight=0
overallwidth=0
overalllength=0
legsDepth=""
legsmattress=""
legsbase=""
legstopper=""
legshb=""
topperdepth=""
compdepth=""
mattressonly=""
mattresstopper=""
mattresszipped=""
valancebase=""
valancemattress=""
valancetopper=""
valancehb=""
valanceweight=0
componentweight=0
crateName1=0
crateLength1=0
crateWidth1=0
crateHeight1=0
crateName2=0
crateLength2=0
crateWidth2=0
crateHeight2=0
crateName3=0
crateLength3=0
crateWidth3=0
crateHeight3=0
crateName4=0
crateLength4=0
crateWidth4=0
crateHeight4=0
crateWeight1=0
crateWeight2=0
crateWeight3=0
crateWeight4=0
pn = request("pn")
compId = request("compid")

Set con = getMysqlConnection()

sql = "select * from shippingbox where shippingBoxId=16" 'Expak MB
'response.write("sql=" & sql)
set rs = getMysqlQueryRecordSet(sql, con)
crateLength1=rs("length")
crateWidth1=rs("width")
crateHeight1=rs("height")
crateName1=rs("sName")
crateWeight1=rs("weight")
rs.close
set rs=nothing

sql = "select * from shippingbox where shippingBoxId=17" 'Expak T
'response.write("sql=" & sql)
set rs = getMysqlQueryRecordSet(sql, con)
crateLength2=rs("length")
crateWidth2=rs("width")
crateHeight2=rs("height")
crateName2=rs("sName")
crateWeight2=rs("weight")
rs.close
set rs=nothing

sql = "select * from shippingbox where shippingBoxId=18" 'Expak 1M
'response.write("sql=" & sql)
set rs = getMysqlQueryRecordSet(sql, con)
crateLength3=rs("length")
crateWidth3=rs("width")
crateHeight3=rs("height")
crateName3=rs("sName")
crateWeight3=rs("weight")
rs.close
set rs=nothing

sql = "select * from shippingbox where shippingBoxId=19" 'Expak H
'response.write("sql=" & sql)
set rs = getMysqlQueryRecordSet(sql, con)
crateLength4=rs("length")
crateWidth4=rs("width")
crateHeight4=rs("height")
crateName4=rs("sName")
crateWeight4=rs("weight")

internalCrateLength4=rs("internallength")
internalCrateWidth4=rs("internalwidth")
internalCrateHeight4=rs("internalheight")
rs.close
set rs=nothing

sql = "select * from shippingbox where shippingBoxId=20" 'special
'response.write("sql=" & sql)
set rs = getMysqlQueryRecordSet(sql, con)
crateLength5=rs("length")
crateWidth5=rs("width")
crateHeight5=rs("height")
crateName5=rs("sName")
crateWeight5=rs("weight")
rs.close
set rs=nothing

sql = "select * from shippingbox where sName='LegBox'"
'response.write("sql=" & sql)
set rs = getMysqlQueryRecordSet(sql, con)
legsDepth=rs("depth")
legsWidth=rs("width")
legsHeight=rs("height")
rs.close
set rs=nothing


sql = "select * from purchase where purchase_no=" & pn
'response.write("sql=" & sql)
set rs = getMysqlQueryRecordSet(sql, con)
'if rs("legqty")<>"" then legno=rs("legqty")
'if rs("addlegqty")<>"" then legno=CDbl(legno) + CDbl(rs("addlegqty"))
'if rs("headboardlegqty")<>"" then legno=CDbl(legno) + CDbl(rs("headboardlegqty"))

legweight=getLegWeight(con)
legspackedwith=0
valancepackedwith=0
accpackedwith=0
If rs("legsrequired")="y" and rs("mattressrequired")="y" then legspackedwith=1
If rs("legsrequired")="y" and rs("baserequired")="y" then legspackedwith=3
If rs("legsrequired")="y" and rs("topperrequired")="y" then legspackedwith=5

If rs("valancerequired")="y" and rs("mattressrequired")="y" then valancepackedwith=1
If rs("valancerequired")="y" and rs("baserequired")="y" then valancepackedwith=3
If rs("valancerequired")="y" and rs("topperrequired")="y" then valancepackedwith=5

If rs("accessoriesrequired")="y" and rs("mattressrequired")="y" then accpackedwith=1
If rs("accessoriesrequired")="y" and rs("baserequired")="y" then accpackedwith=3
If rs("accessoriesrequired")="y" and rs("topperrequired")="y" then accpackedwith=5


if compId = 1 then
	componentweight=0
	'if legspackedwith=1 then
		'	componentweight=componentweight + ((CDbl(legno) * 27 * CDbl(legweight))/1000)
	'end if
	
	if left(rs("mattresstype"),3)<>"Zip" then
		call getComponentSizes(con,1,rs("purchase_no"), m1width, m1length)
		if left(rs("mattresswidth"),4)="Spec" then
			call getComponentWidthSpecialSizes(con,1,rs("purchase_no"), m1width)
			
		end if
		if left(rs("mattresslength"),4)="Spec" then
			call getComponentLengthSpecialSizes(con,1,rs("purchase_no"), m1length)
		end if
		totalwidth=m1width
		componentweight=checkCompWeight(con,1,rs("savoirmodel"),totalwidth,m1length)
		'response.Write("totalwidth=" & totalwidth)
		'response.End()
		if CDbl(totalwidth)>110 then 
			crateExpak=crateName3 'Expak 1m
			defaultPackLength=crateLength3
			defaultPackHeight=crateHeight3
			defaultPackWidth=crateWidth3
			defaultPackKG=componentweight+CDbl(crateWeight3)
			defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
			defaultCrateQty=1
		else 
			crateExpak=crateName1 'Expak MB
			defaultPackLength=crateLength1
			defaultPackHeight=crateHeight1
			defaultPackWidth=crateWidth1
			defaultPackKG=componentweight+CDbl(crateWeight1)
			defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
			defaultCrateQty=1
		end if
	else
		call getComponentSizes(con,1,rs("purchase_no"), m1width, m1length)
		call getComponentSizes(con,1,rs("purchase_no"), m2width, m2length)
		if left(rs("mattresswidth"),4)<>"Spec" then
			totalwidth=CDbl(m1width)
			m1width=m1width/2
			m2width=m1width
			componentweight=checkCompWeight(con,1,rs("savoirmodel"),totalwidth,m1length)
			if m1width<221 and rs("savoirmodel")<>"No. 1" then 
				crateExpak=crateName1 'Expak MB
				defaultPackLength=crateLength1
				defaultPackHeight=crateHeight1
				defaultPackWidth=crateWidth1
				defaultPackKG=componentweight+CDbl(crateWeight1)
				defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
				defaultCrateQty=1
			end if
			if m1width<221 and rs("savoirmodel")="No. 1" then 
				crateExpak=crateName1 'Expak MB
				defaultPackLength=crateLength1
				defaultPackHeight=crateHeight1
				defaultPackWidth=crateWidth1
				defaultPackKG=componentweight+(2*CDbl(crateWeight1))
				defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
				defaultCrateQty=2
			end if
			if m1width>220 then 
				crateExpak=crateName5 'special
				defaultPackLength=crateLength5
				defaultPackHeight=crateHeight5
				defaultPackWidth=crateWidth5
				defaultPackKG=componentweight+CDbl(crateWeight5)
				defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
				defaultCrateQty=1
			end if
		end if
		if left(rs("mattresswidth"),4)="Spec" then
			call getComponent1WidthSpecialSizes(con,1,rs("purchase_no"), m1width, m2width)
			
			totalwidth=CDbl(m1width)+CDbl(m2width)

			if CDbl(totalwidth)<221 and rs("savoirmodel")<>"No. 1" then 
			crateExpak=crateName1 'Expak MB
			defaultPackLength=crateLength1
			defaultPackHeight=crateHeight1
			defaultPackWidth=crateWidth1
			defaultPackKG=componentweight+CDbl(crateWeight1)
			defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
			defaultCrateQty=1
			end if
			if CDbl(totalwidth)<221 and rs("savoirmodel")="No. 1" then 
				crateExpak=crateName1 'Expak MB
				defaultPackLength=crateLength1
				defaultPackHeight=crateHeight1
				defaultPackWidth=crateWidth1
				defaultPackKG=componentweight+(2*CDbl(crateWeight1))
				defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
				defaultCrateQty=2
			end if
			if CDbl(totalwidth)>220 then 
				crateExpak=crateName5 'special
				defaultPackLength=crateLength5
				defaultPackHeight=crateHeight5
				defaultPackWidth=crateWidth5
				defaultPackKG=componentweight+CDbl(crateWeight5)
				defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
				defaultCrateQty=1
			end if
			'end if
			if left(rs("mattresslength"),4)="Spec" then
				call getComponent1LengthSpecialSizes(con,1,rs("purchase_no"), m1length, m2length)
			end if
		end if
	end if
end if 

if compId = 3 then
	if left(rs("basetype"),3)<>"Eas" and left(rs("basetype"),3)<>"Nor" then
		call getComponentSizes(con,3,rs("purchase_no"), m1width, m1length)

		if left(rs("basewidth"),4)="Spec" then
			call getComponentWidthSpecialSizes(con,3,rs("purchase_no"), m1width)
		end if
		if left(rs("baselength"),4)="Spec" then
			call getComponentLengthSpecialSizes(con,3,rs("purchase_no"), m1length)
		end if
		
		overallwidth=m1width
		overalllength=m1length
		componentweight=checkCompWeight(con,3,rs("basesavoirmodel"),overallwidth,overalllength)
		
		if overallwidth<111 then 
			crateExpak=crateName1 'Expak MB
			defaultPackLength=crateLength1
			defaultPackHeight=crateHeight1
			defaultPackWidth=crateWidth1
			defaultPackKG=componentweight+CDbl(crateWeight1)
			defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
			defaultCrateQty=1
		end if
		if overallwidth>110 then 
			crateExpak=crateName3 'Expak 1m
			defaultPackLength=crateLength3
			defaultPackHeight=crateHeight3
			defaultPackWidth=crateWidth3
			defaultPackKG=componentweight+CDbl(crateWeight3)
			defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
			defaultCrateQty=1
		end if
		if overallwidth>110 and overallwidth<166 and rs("basesavoirmodel")="No. 4" then 
			crateExpak=crateName4 'Expak H
			defaultPackLength=crateLength4
			defaultPackHeight=crateHeight4
			defaultPackWidth=crateWidth4
			defaultPackKG=componentweight+CDbl(crateWeight4)
			defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
			defaultCrateQty=1
		end if
		if overallwidth>165 and rs("basesavoirmodel")="No. 4" then 
			crateExpak=crateName3 'special
			defaultPackLength=crateLength3
			defaultPackHeight=crateHeight3
			defaultPackWidth=crateWidth3
			defaultPackKG=componentweight+CDbl(crateWeight3)
			defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
			defaultCrateQty=1
		end if
		
	else
		call getComponentSizes(con,3,rs("purchase_no"), m1width, m1length)
		call getComponentSizes(con,3,rs("purchase_no"), m2width, m2length)
		overallwidth=m1width
		overalllength=m1length
		
		
		if left(rs("basewidth"),4)<>"Spec" then
			if left(rs("basetype"),3)="Eas" then
				m2length=m2length-130
				m1length=130
				if m1length>m2length then
					'do nothing
				else
					m1length=m2length
				end if
			else
				m1width=m1width/2
				m2width=m1width
			end if
		end if
		
		if left(rs("basewidth"),4)="Spec" then
			call getComponent1WidthSpecialSizes(con,3,rs("purchase_no"), m1width, m2width)
			overallwidth=CDbl(m1width)+CDbl(m2width)
		end if
		if left(rs("baselength"),4)="Spec" then
			call getComponent1LengthSpecialSizes(con,3,rs("purchase_no"), m1length, m2length)
			overalllength=CDbl(m1length)+CDbl(m2length)
		end if

		componentweight=checkCompWeight(con,3,rs("basesavoirmodel"),overallwidth,overalllength)
		if overallwidth<111 then 
			crateExpak=crateName1 'Expak MB
			defaultPackLength=crateLength1
			defaultPackHeight=crateHeight1
			defaultPackWidth=crateWidth1
			defaultPackKG=componentweight+CDbl(crateWeight1)
			defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
			defaultCrateQty=1
		end if
		
		if overallwidth>110 and rs("basesavoirmodel")<>"No. 4" then 
			crateExpak=crateName3 'Expak 1m
			defaultPackLength=crateLength3
			defaultPackHeight=crateHeight3
			defaultPackWidth=crateWidth3
			defaultPackKG=componentweight+CDbl(crateWeight3)
			defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
			defaultCrateQty=1
		end if
		
		
		if overallwidth>110 and overallwidth<166 and rs("basesavoirmodel")="No. 4" then 
			crateExpak=crateName4 'Expak H
			defaultPackLength=crateLength4
			defaultPackHeight=crateHeight4
			defaultPackWidth=crateWidth4
			defaultPackKG=componentweight+CDbl(crateWeight4)
			defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
			defaultCrateQty=1
		end if


		if left(rs("basewidth"),4)<>"Spec" then
			if left(rs("basetype"),3)="Nor" then
				overallwidth=m1width + m2width
				componentweight=checkCompWeight(con,3,rs("basesavoirmodel"),overallwidth,overalllength)
				if m1width<111 then 
					crateExpak=crateName1 'Expak MB
					defaultPackLength=crateLength1
					defaultPackHeight=crateHeight1
					defaultPackWidth=crateWidth1
					defaultPackKG=componentweight+CDbl(crateWeight1)
					defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
					defaultCrateQty=1
				end if
				if m1width>110 then 
					crateExpak=crateName3 'Expak 1m
					defaultPackLength=crateLength3
					defaultPackHeight=crateHeight3
					defaultPackWidth=crateWidth3
					defaultPackKG=componentweight+CDbl(crateWeight3)
					defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
					defaultCrateQty=1
				end if
				if m1width<166 and rs("basesavoirmodel")="No. 4" then 
					crateExpak=crateName4 'Expak h
					defaultPackLength=crateLength4
					defaultPackHeight=crateHeight4
					defaultPackWidth=crateWidth4
					defaultPackKG=componentweight+(2*CDbl(crateWeight4))
					defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
					defaultCrateQty=2
				end if
			end if
		end if

		if left(rs("basewidth"),4)="Spec" then
		
			call getComponent1WidthSpecialSizes(con,3,rs("purchase_no"), m1width, m2width)
			'overallwidth=CDbl(m1width)+CDbl(m2width)
			
			componentweight=checkCompWeight(con,3,rs("basesavoirmodel"),m1width,m2width)
			if CDbl(m1width)<111 then 
					crateExpak=crateName1 'Expak MB
					defaultPackLength=crateLength1
					defaultPackHeight=crateHeight1
					defaultPackWidth=crateWidth1
					defaultPackKG=componentweight+CDbl(crateWeight1)
					defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
					defaultCrateQty=1
				end if
				if CDbl(m1width)>110 then 
					crateExpak=crateName3 'Expak 1m
					defaultPackLength=crateLength3
					defaultPackHeight=crateHeight3
					defaultPackWidth=crateWidth3
					defaultPackKG=componentweight+CDbl(crateWeight3)
					defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
					defaultCrateQty=1
				end if
				if CDbl(m1width)<166 and rs("basesavoirmodel")="No. 4" then 
					crateExpak=crateName4 'Expak h
					defaultPackLength=crateLength4
					defaultPackHeight=crateHeight4
					defaultPackWidth=crateWidth4
					defaultPackKG=componentweight+(2*CDbl(crateWeight4))
					defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
					defaultCrateQty=2
				end if
		end if
		
		if left(rs("baselength"),4)="Spec" then
			call getComponent1LengthSpecialSizes(con,3,rs("purchase_no"), m1length, m2length)
			overalllength=CDbl(m1length)+CDbl(m2length)
			componentweight=checkCompWeight(con,3,rs("basesavoirmodel"),overallwidth,overalllength)
			if CDbl(m1width)<111 then 
					crateExpak=crateName1 'Expak MB
					defaultPackLength=crateLength1
					defaultPackHeight=crateHeight1
					defaultPackWidth=crateWidth1
					defaultPackKG=componentweight+CDbl(crateWeight1)
					defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
					defaultCrateQty=1
				end if
				if CDbl(m1width)>110 then 
					crateExpak=crateName3 'Expak 1m
					defaultPackLength=crateLength3
					defaultPackHeight=crateHeight3
					defaultPackWidth=crateWidth3
					defaultPackKG=componentweight+CDbl(crateWeight3)
					defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
					defaultCrateQty=1
				end if
				if CDbl(m1width)<166 and rs("basesavoirmodel")="No. 4" then 
					crateExpak=crateName4 'Expak h
					defaultPackLength=crateLength4
					defaultPackHeight=crateHeight4
					defaultPackWidth=crateWidth4
					defaultPackKG=componentweight+(2*CDbl(crateWeight4))
					defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
					defaultCrateQty=2
				end if
		end if
		
		if CDbl(m1width)>165 or CDbl(m2width)>165  then 
			crateExpak=crateName5 'special
			defaultPackLength=crateLength5
			defaultPackHeight=crateHeight5
			defaultPackWidth=crateWidth5
			defaultPackKG=componentweight+CDbl(crateWeight5)
			defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
			defaultCrateQty=1
		end if
		
		if rs("basesavoirmodel")="Pegboard" then
			m1length=m1length/2
		end if
	end if
end if

if compId = 5 then
	' topper
	call getComponentSizes(con,5,rs("purchase_no"), m1width, m1length)
	if left(rs("topperwidth"),4)="Spec" then
		call getComponentWidthSpecialSizes(con,5,rs("purchase_no"), m1width)
	end if
	if left(rs("topperlength"),4)="Spec" then
		call getComponentLengthSpecialSizes(con,5,rs("purchase_no"), m1length)
	end if
	componentweight=checkCompWeight(con,5,rs("toppertype"),m1width,m1length)
	crateExpak=crateName2 'Expak t
	defaultPackLength=crateLength2
	defaultPackHeight=crateHeight2
	defaultPackWidth=crateWidth2
	defaultPackKG=componentweight+CDbl(crateWeight2)
	defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
	defaultCrateQty=1

end if

if compId = 8 then
	' hb
	m1width=getHbWidth(con,rs("purchase_no"))
	componentweight=componentweight + checkCompWeight(con,8,rs("headboardstyle"),m1width,m1length)
	'm1length=getHbHeight(con,rs("purchase_no"))
	'defaultPackDepth=getComponentDepth(con, rs("headboardstyle"), 8)
	'response.Write("m1width=" & m1width & " m1length=" & m1length & " depth=" & defaultPackDepth)
	'if CDbl(m1width) < CDbl(internalcrateWidth4)+1 and CDbl(m1length) < CDbl(internalcrateLength4)+1 and CDbl(defaultPackDepth) < CDbl(internalcrateWidth4)+1 then
	crateExpak=crateName4 'Expak h
	defaultPackLength=crateLength4
	defaultPackHeight=crateHeight4
	defaultPackWidth=crateWidth4
	defaultPackKG=CDbl(crateWeight4) + componentweight
	defaultCrateQty=1
	
end if

if compId = 7 then
	if rs("legqty")<>"" then legno=rs("legqty")
	if rs("addlegqty")<>"" then legno=CDbl(legno) + CDbl(rs("addlegqty"))
	if rs("headboardlegqty")<>"" then legno=CDbl(legno) + CDbl(rs("headboardlegqty"))
	legweight=getLegWeight(con)
	componentweight=(CDbl(legno) * 27 * CDbl(legweight))/1000
	componentweight=round(componentweight/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
	
	crateExpak=crateName5 'special
	defaultPackLength=crateLength5
	defaultPackHeight=crateHeight5
	defaultPackWidth=crateWidth5
	defaultPackKG=CDbl(crateWeight5) + componentweight
	defaultCrateQty=1
end if

if compId = 6 then
	componentweight=6
	crateExpak=crateName5 'special
	defaultPackLength=crateLength5
	defaultPackHeight=crateHeight5
	defaultPackWidth=crateWidth5
	defaultPackKG=CDbl(crateWeight5) + componentweight
	defaultCrateQty=1
	
end if

if compId = 9 then
	sql = "Select SUM(qty) AS AccQty from orderaccessory where purchase_no = " & pn
	set rs2 = getMysqlQueryRecordSet(sql, con)
	if not rs2.eof then
		accessoryqty=CDbl(rs2("AccQty")) 
	end if
	rs2.close
	set rs2=nothing
	componentweight=CInt(accessoryqty)*0.5
	componentweight=round(componentweight/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
	crateExpak=crateName5 'special
	defaultPackLength=crateLength5
	defaultPackHeight=crateHeight5
	defaultPackWidth=crateWidth5
	defaultPackKG=CDbl(crateWeight5) + componentweight
	defaultCrateQty=1
	
end if

componentweight=round(componentweight/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest) ' just to make sure

response.write(defaultPackLength & "," & defaultPackHeight & "," & defaultPackWidth & "," & defaultPackKG & "," & crateExpak & "," & defaultCrateQty & "," & componentweight)

rs.close
set rs = nothing
con.close
set con=nothing
%>
