<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="componentfuncs.asp" -->
<%
dim con, sql, rs, rs2, pn, compId
dim width, length, defaultBoxSize1, defaultBoxSize2, defaultWeight1, defaultWeight2, m1width, m2width, m1length, m2length, BoxWeight, legno, legweight, valancetxt, accessoryqty, RoundToNearest
RoundToNearest=1

pn = request("pn")
compId = request("compid")
valancetxt=request("valancetxt")


Set con = getMysqlConnection()


sql = "select * from purchase where purchase_no=" & pn

'response.write("sql=" & sql)
set rs = getMysqlQueryRecordSet(sql, con)
Dim valancebase, valancemattress, valancetopper, valancehb
if rs("baserequired")="y" and rs("valancerequired")="y" then valancebase="y"
if rs("baserequired")="n" and rs("valancerequired")="y" and rs("mattressrequired")="y" then valancemattress="y"
if rs("baserequired")="n" and rs("valancerequired")="y" and  rs("mattressrequired")="n" and rs("topperrequired")="y" then valancetopper="y"
if rs("baserequired")="n" and rs("mattressrequired")="n" and rs("topperrequired")="n" and rs("headboardrequired")="y" and rs("valancerequired")="y" then valancehb="y"
defaultBoxSize1 = ""
defaultBoxSize2 = ""

if compId = 1 then
' mattress
	if left(rs("mattresstype"),3)<>"Zip" then
		call getComponentSizes(con,1,rs("purchase_no"), m1width, m1length)
		if left(rs("mattresswidth"),4)="Spec" then
		call getComponentWidthSpecialSizes(con,1,rs("purchase_no"), m1width)
		end if
		if left(rs("mattresslength"),4)="Spec" then
		call getComponentLengthSpecialSizes(con,1,rs("purchase_no"), m1length)
		end if
		if m1width < 108 then defaultBoxSize1 = "Small"
		if m1width > 107 and m1width < 154 then defaultBoxSize1 = "Medium"
		if m1width > 153 then defaultBoxSize1 = "Large"
		defaultWeight1 = checkMattKg(con,1,rs("savoirmodel"),defaultBoxSize1,m1width,m1length)
		if valancetxt="Valance packed with mattress" then defaultWeight1=defaultWeight1+6
	else
		call getComponentSizes(con,1,rs("purchase_no"), m1width, m1length)
		call getComponentSizes(con,1,rs("purchase_no"), m2width, m2length)
		'response.write("m1width = " & m1width)
		'response.write("m1length = " & m1length)
		'response.end
		if left(rs("mattresswidth"),4)<>"Spec" then
		m1width=m1width
		m2width=m1width
		end if
		if left(rs("mattresswidth"),4)="Spec" then
			call getComponent1WidthSpecialSizes(con,1,rs("purchase_no"), m1width, m2width)
		end if
		if left(rs("mattresslength"),4)="Spec" then
			call getComponent1LengthSpecialSizes(con,1,rs("purchase_no"), m1length, m2length)
		end if
		
		if m1width <> "" and m1length <> "" then
			if CDbl(m1width) < 108 then defaultBoxSize1 = "Small"
			if CDbl(m1width) > 107 then defaultBoxSize1 = "Medium"
			defaultWeight1 = checkMattKg(con,1,rs("savoirmodel"),defaultBoxSize1,m1width,m1length)
		end if
		
		'response.Write(m2width)
		'response.End()
		if m2width <> "" and m2length <> "" then
		if CDbl(m2width) < 108 then defaultBoxSize2 = "Small"
		if CDbl(m2width) > 107 then defaultBoxSize2 = "Medium"
		defaultWeight2 = checkMattKg(con,1,rs("savoirmodel"),defaultBoxSize2,m2width,m2length)
		end if
	end if
	
	'response.Write(m1width)
	'response.End()

end if

if compId = 3 then
' base
	if left(rs("basetype"),3)<>"Eas" and left(rs("basetype"),3)<>"Nor" then
	call getComponentSizes(con,3,rs("purchase_no"), m1width, m1length)
		if left(rs("basewidth"),4)="Spec" then
		call getComponentWidthSpecialSizes(con,3,rs("purchase_no"), m1width)
		end if
		if left(rs("baselength"),4)="Spec" then
		call getComponentLengthSpecialSizes(con,3,rs("purchase_no"), m1length)
		end if
		if m1width < 108 then defaultBoxSize1 = "Small"
		if m1width > 107 and m1width < 154 then defaultBoxSize1 = "Medium"
		if m1width > 153 then defaultBoxSize1 = "Large"
	else
		call getComponentSizes(con,3,rs("purchase_no"), m1width, m1length)
		call getComponentSizes(con,3,rs("purchase_no"), m2width, m2length)
		'if left(rs("basewidth"),4)<>"Spec" then
		m1width=m1width/2
		m2width=m2width/2
		if left(rs("basetype"),3)="Eas" then
			defaultBoxSize1 = "Medium"
			defaultBoxSize2 = "Small"
		end if
		'end if
		if left(rs("basewidth"),4)="Spec" then
		call getComponent1WidthSpecialSizes(con,3,rs("purchase_no"), m1width, m2width)
		end if
		if left(rs("baselength"),4)="Spec" then
		call getComponent1LengthSpecialSizes(con,3,rs("purchase_no"), m1length, m2length)
		end if
		if left(rs("basetype"),3)="Nor" then
			if CDbl(m1width) < 108 then defaultBoxSize1 = "Small"
			if CDbl(m1width) < 108 then defaultBoxSize2 = "Small"
			if CDbl(m2width) > 107 then defaultBoxSize1 = "Medium"
			if CDbl(m2width) > 107 then defaultBoxSize2 = "Medium"
		end if
	end if
	if m1width <> "" and m1length <> "" then
	'defaultBoxSize1 = checkMatt1Box(con, m1width, m1length)
	defaultWeight1 = checkMattKg(con,3,rs("basesavoirmodel"),defaultBoxSize1,m1width,m1length)
	if valancetxt="Valance packed with base" then defaultWeight1=defaultWeight1+6
	end if
	if m2width <> "" and m2length <> "" then
	'defaultBoxSize2 = checkMatt1Box(con, m2width, m2length)
	defaultWeight2 = checkMattKg(con,3,rs("basesavoirmodel"),defaultBoxSize2,m2width,m2length)
	end if
	'response.Write("m1width=" & m1width & " m2width=" & m2width)
	'response.End()
end if

if compId = 5 then
' topper
defaultBoxSize1="Small"
call getComponentSizes(con,5,rs("purchase_no"), m1width, m1length)
if left(rs("topperwidth"),4)="Spec" then
call getComponentWidthSpecialSizes(con,5,rs("purchase_no"), m1width)
end if
if left(rs("topperlength"),4)="Spec" then
call getComponentLengthSpecialSizes(con,5,rs("purchase_no"), m1length)
end if
if m1width <> "" and m1length <> "" then
defaultWeight1 = checkMattKg(con,5,rs("toppertype"),defaultBoxSize1,m1width,m1length)
if valancetxt="Valance packed with topper" then defaultWeight1=defaultWeight1+6
end if
end if

if compId = 8 then
' hb
defaultBoxSize1="Medium"
m1width=getHbWidth(con,rs("purchase_no"))
m1length=getHbHeight(con,rs("purchase_no"))
if m1width <> "" and m1length <> "" then
defaultWeight1 = checkMattKg(con,8,rs("headboardstyle"),defaultBoxSize1,m1width,null)
end if
end if

if compId = 6 then
' valance
sql = "Select * from shippingbox where sname = 'Small'"
'response.Write("sql=" & asql)
set rs2 = getMysqlQueryRecordSet(sql, con)
if not rs2.eof then
BoxWeight=CDbl(rs2("WEIGHT"))
end if
rs2.close
set rs2=nothing
defaultBoxSize1="Small"
defaultWeight1=6+CDbl(BoxWeight)
end if

if compId = 7 then
' legs
Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=7", con)
If not rs2.eof then
legweight=rs2("weight")
end if
rs2.close
set rs2=nothing
if rs("legqty")<>"" then legno=rs("legqty")
if rs("addlegqty")<>"" then legno=CDbl(legno) + CDbl(rs("addlegqty"))
if rs("headboardlegqty")<>"" then legno=CDbl(legno) + CDbl(rs("headboardlegqty"))
defaultBoxSize1="Leg Box"
defaultWeight1=((CDbl(legno) * 27 * CDbl(legweight))/1000)
end if

if compId = 9 then
' accessories
	sql = "Select * from shippingbox where sname = 'Small'"
	set rs2 = getMysqlQueryRecordSet(sql, con)
	if not rs2.eof then
		BoxWeight=CDbl(rs2("WEIGHT"))
	end if
	rs2.close
	set rs2=nothing
	sql="select SUM(qty) AS AccQty from orderaccessory where purchase_no = " & pn
	set rs2 = getMysqlQueryRecordSet(sql, con)
	if not rs2.eof then
		accessoryqty=CDbl(rs2("AccQty"))
	end if
	rs2.close
	set rs2=nothing
	defaultBoxSize1="Small"
	defaultWeight1=BoxWeight + (0.5 * accessoryqty)
	defaultWeight1=round(defaultWeight1/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
end if



defaultWeight1=round(defaultWeight1/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
defaultWeight2=round(defaultWeight2/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)

response.write(defaultBoxSize1 & "," & FormatNumber(defaultWeight1, 1) & "," & defaultBoxSize2 & "," & FormatNumber(defaultWeight2, 1))

rs.close
set rs = nothing
con.close
set con=nothing
%>
