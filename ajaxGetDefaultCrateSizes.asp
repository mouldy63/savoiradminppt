<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="componentfuncs.asp" -->
<%
dim con, sql, rs, rs2, pn, compId
dim width, length, defaultBoxSize1, defaultBoxSize2, defaultWeight1, defaultWeight2, m1width, m2width, m1length, m2length, t1width, t1length
dim defaultPackWidth, defaultPackHeight, defaultPackDepth, defaultPackKG, defaultCrateQty, mattressonly, mattresstopper, compdepth, internalCrateAllow, PackAllowance, RoundToNearest, AddCrateAllow, mattresszipped, topperdepth, legsmattress, legsDepth, cratemultiplier, shippingcrateweight, componentweight, basenumber, legsbase, legstopper, legshb, legsWidth, legsHeight, legno, legweight, valanceweight, valancebase, valancemattress, valancetopper, valancehb, totalwidth, topperonly, overallwidth, overalllength, crateName, crateLength, crateWidth, crateHeight, crateWeight, crateName2, crateLength2, crateWidth2, crateHeight2, crateWeight2, crateName3, crateLength3, crateWidth3, crateHeight3, crateWeight3, crateName4, crateLength4, crateWidth4, crateHeight4, crateWeight4, defaultPackLength, crateExpak, crateQty, expak
topperonly="n"
basenumber=1
expak=request("expak")
Set con = getMysqlConnection()

sql = "select * from shippingbox where sName like '" & expak & "'"
set rs = getMysqlQueryRecordSet(sql, con)

crateLength=rs("length")
crateWidth=rs("width")
crateHeight=rs("height")
crateName=rs("sName")
crateWeight=rs("weight")
rs.close
set rs=nothing


response.write(crateLength & "," & crateHeight & "," & crateWidth & "," & crateWeight & "," & crateName)

con.close
set con=nothing
%>
