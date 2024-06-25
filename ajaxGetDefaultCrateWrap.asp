<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="componentfuncs.asp" -->
<%
dim con, sql, rs, rs2, pn, compId
dim width, length, defaultBoxSize1, defaultBoxSize2, defaultWeight1, defaultWeight2, m1width, m2width, m1length, m2length, t1width, t1length
dim defaultPackWidth, defaultPackHeight, defaultPackDepth, defaultPackKG, mattressonly, mattresstopper, compdepth, internalCrateAllow, PackAllowance, RoundToNearest, AddCrateAllow, mattresszipped, topperdepth, legsmattress, legsDepth, cratemultiplier, crateweight, shippingcrateweight, componentweight, basenumber, legsbase, legstopper, legshb, legsWidth, legsHeight, legno, legweight, valanceweight, valancebase, valancemattress, valancetopper, valancehb, totalwidth, topperonly, overallwidth, overalllength
topperonly="n"
basenumber=1

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
pn = request("pn")
compId = request("compid")

Set con = getMysqlConnection()

sql = "select * from shippingbox where sName='InternalCrate'"
'response.write("sql=" & sql)
set rs = getMysqlQueryRecordSet(sql, con)
internalCrateAllow=rs("Allowance")
rs.close
set rs=nothing

sql = "select * from shippingbox where sName='AdditionalCrate'"
'response.write("sql=" & sql)
set rs = getMysqlQueryRecordSet(sql, con)
AddCrateAllow=rs("Allowance")
rs.close
set rs=nothing

sql = "select * from shippingbox where sName='RoundCrate'"
'response.write("sql=" & sql)
set rs = getMysqlQueryRecordSet(sql, con)
RoundToNearest=rs("RoundToNearest")
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

sql = "select * from shippingbox where sName='WoodenCrates'"
'response.write("sql=" & sql)
set rs = getMysqlQueryRecordSet(sql, con)
shippingcrateweight=rs("weight")
rs.close
set rs=nothing

sql = "select * from purchase where purchase_no=" & pn
'response.write("sql=" & sql)
set rs = getMysqlQueryRecordSet(sql, con)
if rs("legqty")<>"" then legno=rs("legqty")
if rs("addlegqty")<>"" then legno=CDbl(legno) + CDbl(rs("addlegqty"))
if rs("headboardlegqty")<>"" then legno=CDbl(legno) + CDbl(rs("headboardlegqty"))

legweight=getLegWeight(con)


if rs("baserequired")="y" and rs("valancerequired")="y" then valancebase="y"
if rs("baserequired")="n" and rs("valancerequired")="y" and rs("mattressrequired")="y" then valancemattress="y"
if rs("baserequired")="n" and rs("valancerequired")="y" and rs("mattressrequired")="n" and rs("topperrequired")="y" then valancetopper="y"
if rs("baserequired")="n" and rs("valancerequired")="y" and rs("mattressrequired")="n" and rs("topperrequired")="n" and rs("headboardrequired")="y" then valancehb="y"
if rs("mattressrequired")="n" and rs("baserequired")="y" and rs("legsrequired")="y" then legsbase="y"
if rs("mattressrequired")="n" and rs("baserequired")="n" and rs("headboardrequired")="n" and rs("legsrequired")="y" and rs("topperrequired")="y" then legstopper="y"
if rs("mattressrequired")="n" and rs("baserequired")="n" and rs("headboardrequired")="y" and rs("legsrequired")="y" and rs("topperrequired")="n" then legshb="y"
if rs("baserequired")="y" and (left(rs("basetype"),3)="Eas" or left(rs("basetype"),3)="Nor") then basenumber=2
if rs("mattressrequired")="y" and rs("legsrequired")="y" and rs("topperrequired")="n" and rs("valancerequired")="n" and rs("headboardrequired")="n" and rs("baserequired")="n" then legsmattress="y"
if rs("mattressrequired")="y" and rs("baserequired")="y" and rs("legsrequired")="y" then
legsbase="y"
legsmattress=""
end if
if  rs("topperrequired")="y" then topperdepth=getComponentDepth(con, rs("toppertype"), 5)
if rs("mattressrequired")="y" and rs("topperrequired")="n" then
mattressonly="y" 'mattressonly true
end if
if rs("topperrequired")="y" and rs("mattressrequired")="n" then topperonly="y"
if rs("mattressrequired")="y" and rs("topperrequired")="y" then mattressonly="n" 'mattress + topper (single matt only)
if left(rs("mattresstype"),3)="Zip" and mattressonly="n" then
mattressonly="n"
topperdepth=getShippingComponentDepth(con, left(rs("toppertype"),2)) 'mattress + topper (folded as 2 matt)
end if
if left(rs("mattresstype"),3)="Zip" then
mattresszipped="y"
cratemultiplier=2
end if
if left(rs("basetype"),3)="Eas" or left(rs("basetype"),3)="Nor" then
cratemultiplier=2
end if
defaultBoxSize1 = ""
defaultBoxSize2 = ""

if compId = 1 then
' hb
if left(rs("mattresstype"),3)<>"Zip" then
call getComponentSizes(con,1,rs("purchase_no"), m1width, m1length)
if left(rs("mattresswidth"),4)="Spec" then
call getComponentWidthSpecialSizes(con,1,rs("purchase_no"), m1width)
end if
if left(rs("mattresslength"),4)="Spec" then
call getComponentLengthSpecialSizes(con,1,rs("purchase_no"), m1length)
end if
totalwidth=m1width
else
call getComponentSizes(con,1,rs("purchase_no"), m1width, m1length)
call getComponentSizes(con,1,rs("purchase_no"), m2width, m2length)
if left(rs("mattresswidth"),4)<>"Spec" then
totalwidth=CDbl(m1width)
m1width=m1width/2
m2width=m1width
end if
if left(rs("mattresswidth"),4)="Spec" then
call getComponent1WidthSpecialSizes(con,1,rs("purchase_no"), m1width, m2width)
totalwidth=CDbl(m1width)+CDbl(m2width)
if CDbl(m1width)>CDbl(m2width) then
'do nothing
else
'possible m2width bigger than m1 or equal so ok to make m2
m1width=m2width
end if
end if
if left(rs("mattresslength"),4)="Spec" then
call getComponent1LengthSpecialSizes(con,1,rs("purchase_no"), m1length, m2length)
end if
end if



defaultPackWidth=CDbl(m1length)+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)
defaultPackWidth=round(defaultPackWidth/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
defaultPackWidth=round(defaultPackWidth/CDbl(RoundToNearest))*CDbl(RoundToNearest)

defaultPackHeight=CDbl(m1width)+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)
defaultPackHeight=round(defaultPackHeight/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)


defaultPackDepth=getComponentDepth(con, rs("savoirmodel"), 1)
if mattresszipped="y" then defaultPackDepth=CDbl(defaultPackDepth)*2
if topperdepth<>"" then

defaultPackDepth=CDbl(defaultPackDepth)+CDbl(topperdepth)

call getComponentSizes(con,5,rs("purchase_no"), t1width, t1length)
if left(rs("topperwidth"),4)="Spec" then
call getComponentWidthSpecialSizes(con,5,rs("purchase_no"), t1width)
end if
if left(rs("topperlength"),4)="Spec" then
call getComponentLengthSpecialSizes(con,5,rs("purchase_no"), t1length)
end if
componentweight=checkCompWeight(con,5,rs("toppertype"),t1width,t1length)
end if
if legsmattress="y" then
defaultPackDepth=defaultPackDepth+CDbl(legsDepth)
componentweight=componentweight + ((CDbl(legno) * 27 * CDbl(legweight))/1000)
end if
'response.Write("defaultPackDepth=" & defaultPackDepth)
defaultPackDepth=Cdbl(defaultPackDepth)+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)
defaultPackDepth=round(defaultPackDepth/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)

crateweight=cratemultiplier * defaultPackHeight * defaultPackWidth
crateweight=crateweight + (cratemultiplier * defaultPackHeight * defaultPackDepth)
crateweight=crateweight + (cratemultiplier * defaultPackWidth * defaultPackDepth)
crateweight=crateweight/10000

defaultPackKG=crateweight * CDbl(shippingcrateweight)

if valancemattress="y" then componentweight=componentweight + 6
componentweight=componentweight + checkCompWeight(con,1,rs("savoirmodel"),totalwidth,m1length)

defaultPackKG=defaultPackKG+componentweight
defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)




end if

if compId = 3 then
' hb
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
end if
if rs("basesavoirmodel")="Pegboard" then
m1length=m1length/2
end if

defaultPackWidth=CDbl(m1length)+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)


defaultPackHeight=CDbl(m1width)+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)
defaultPackHeight=round(defaultPackHeight/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)

defaultPackDepth=getComponentDepth(con, rs("basesavoirmodel"), 3)
defaultPackDepth=CDbl(defaultPackDepth)*basenumber


if legsbase="y" then
defaultPackWidth=defaultPackWidth+CDbl(legsDepth)
componentweight=componentweight + ((CDbl(legno) * 27 * CDbl(legweight))/1000)
end if
defaultPackDepth=defaultPackDepth+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)
defaultPackDepth=round(defaultPackDepth/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)

defaultPackWidth=round(defaultPackWidth/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
defaultPackWidth=round(defaultPackWidth/CDbl(RoundToNearest))*CDbl(RoundToNearest)
'response.Write(cratemultiplier & "x" & defaultPackHeight & "x" & defaultPackWidth & "<br>")
crateweight=cratemultiplier * defaultPackHeight * defaultPackWidth
crateweight=crateweight + (cratemultiplier * defaultPackHeight * defaultPackDepth)
crateweight=crateweight + (cratemultiplier * defaultPackWidth * defaultPackDepth)
crateweight=crateweight/10000
defaultPackKG=crateweight * CDbl(shippingcrateweight)
if valancebase="y" then componentweight=componentweight + 6
componentweight=componentweight + checkCompWeight(con,3,rs("basesavoirmodel"),overallwidth,overalllength)
'response.Write(componentweight & "<br>")
defaultPackKG=defaultPackKG+componentweight
defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
if rs("basesavoirmodel")="Pegboard" then
defaultPackKG=5
end if

end if

if compId = 5 and rs("mattressrequired")="n" then
' topper
call getComponentSizes(con,5,rs("purchase_no"), m1width, m1length)
if left(rs("topperwidth"),4)="Spec" then
call getComponentWidthSpecialSizes(con,5,rs("purchase_no"), m1width)
end if
if left(rs("topperlength"),4)="Spec" then
call getComponentLengthSpecialSizes(con,5,rs("purchase_no"), m1length)
end if

if m1length<>"" then

m1length=m1length/3
end if
topperdepth=getShippingComponentDepth(con, left(rs("toppertype"),2))

defaultPackWidth=CDbl(m1width)+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)
defaultPackWidth=round(defaultPackWidth/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
defaultPackHeight=round(m1length/CDbl(RoundToNearest))*CDbl(RoundToNearest)


'defaultPackHeight=CDbl(m1width)+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)
'defaultPackHeight=round(defaultPackHeight/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)

defaultPackDepth=getShippingComponentDepth(con, left(rs("toppertype"),2))
defaultPackDepth=CDbl(defaultPackDepth)


if legstopper="y" then
defaultPackDepth=defaultPackDepth+CDbl(legsDepth)
componentweight=componentweight + ((CDbl(legno) * 27 * CDbl(legweight))/1000)
end if
defaultPackDepth=CDbl(defaultPackDepth)+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)
defaultPackDepth=round(defaultPackDepth/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)

crateweight=cratemultiplier * defaultPackHeight * defaultPackWidth
crateweight=crateweight + (cratemultiplier * defaultPackHeight * defaultPackDepth)
crateweight=crateweight + (cratemultiplier * defaultPackWidth * defaultPackDepth)
crateweight=crateweight/10000
defaultPackKG=crateweight * CDbl(shippingcrateweight)
if valancetopper="y" then componentweight=componentweight + 6
componentweight=componentweight + checkCompWeight(con,3,rs("basesavoirmodel"),m1width,m1length)
defaultPackKG=defaultPackKG+componentweight
defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)



end if


if compId = 8 then
' hb
m1width=getHbWidth(con,rs("purchase_no"))
m1length=getHbHeight(con,rs("purchase_no"))
'response.Write("width=" & m1width & "<br>" & "len=" & m1length)

defaultPackWidth=CDbl(m1width)+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)
defaultPackWidth=round(defaultPackWidth/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
defaultPackWidth=round(defaultPackWidth/CDbl(RoundToNearest))*CDbl(RoundToNearest)

defaultPackHeight=CDbl(m1length)+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)
defaultPackHeight=round(defaultPackHeight/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)

defaultPackDepth=getComponentDepth(con, rs("headboardstyle"), 8)
'response.Write(defaultPackDepth & "<br>")
if legshb="y" then
defaultPackDepth=defaultPackDepth+CDbl(legsDepth)
componentweight=componentweight + ((CDbl(legno) * 27 * CDbl(legweight))/1000)
end if
'response.Write("defaultPackDepth=" & defaultPackDepth & "<br>" & "internalCrateAllow=" & internalCrateAllow)
defaultPackDepth=CDbl(defaultPackDepth)+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)
defaultPackDepth=round(defaultPackDepth/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)

crateweight=cratemultiplier * defaultPackHeight * defaultPackWidth
crateweight=crateweight + (cratemultiplier * defaultPackHeight * defaultPackDepth)
crateweight=crateweight + (cratemultiplier * defaultPackWidth * defaultPackDepth)
crateweight=crateweight/10000
defaultPackKG=crateweight * CDbl(shippingcrateweight)

if valancehb="y" then componentweight=componentweight + 6
componentweight=componentweight + checkCompWeight(con,8,rs("headboardstyle"),m1width,m1length)

defaultPackKG=defaultPackKG+componentweight
defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)

end if

if compId = 7 then
' legs

defaultPackWidth=CDbl(legsWidth)+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)
defaultPackWidth=round(defaultPackWidth/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
defaultPackWidth=round(defaultPackWidth/CDbl(RoundToNearest))*CDbl(RoundToNearest)

defaultPackHeight=CDbl(legsHeight)+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)
defaultPackHeight=round(defaultPackHeight/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)

defaultPackDepth=CDbl(defaultPackDepth)+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)
defaultPackDepth=round(defaultPackDepth/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)

crateweight=cratemultiplier * defaultPackHeight * defaultPackWidth
crateweight=crateweight + (cratemultiplier * defaultPackHeight * defaultPackDepth)
crateweight=crateweight + (cratemultiplier * defaultPackWidth * defaultPackDepth)
crateweight=crateweight/10000


defaultPackKG=crateweight * CDbl(shippingcrateweight)
componentweight=componentweight + ((CDbl(legno) * 27 * CDbl(legweight))/1000)
defaultPackKG=defaultPackKG+componentweight
defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)


end if

if compId = 6 then
' valance

defaultPackWidth=CDbl(legsWidth)+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)
defaultPackWidth=round(defaultPackWidth/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
defaultPackWidth=round(defaultPackWidth/CDbl(RoundToNearest))*CDbl(RoundToNearest)

defaultPackHeight=CDbl(legsHeight)+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)
defaultPackHeight=round(defaultPackHeight/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)

defaultPackDepth=CDbl(defaultPackDepth)+CDbl(internalCrateAllow)+CDbl(AddCrateAllow)
defaultPackDepth=round(defaultPackDepth/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)

crateweight=cratemultiplier * defaultPackHeight * defaultPackWidth
crateweight=crateweight + (cratemultiplier * defaultPackHeight * defaultPackDepth)
crateweight=crateweight + (cratemultiplier * defaultPackWidth * defaultPackDepth)
crateweight=crateweight/10000


defaultPackKG=crateweight * CDbl(shippingcrateweight)
componentweight=6
defaultPackKG=defaultPackKG+componentweight
defaultPackKG=round(defaultPackKG/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)


end if





response.write(defaultPackWidth & "," & defaultPackHeight & "," & defaultPackDepth & "," & defaultPackKG)

rs.close
set rs = nothing
con.close
set con=nothing
%>
