<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="componentfuncs.asp" -->
<%
dim con, sql, rs, pn, compId
dim width, length, defaultBoxSize1, defaultBoxSize2, defaultWeight1, defaultWeight2, m1width, m2width, m1length, m2length
dim defaultPackWidth, defaultPackHeight, defaultPackDepth, defaultPackKG
pn = request("pn")
compId = request("compid")

Set con = getMysqlConnection()

sql = "select * from purchase where purchase_no=" & pn
'response.write("sql=" & sql)
set rs = getMysqlQueryRecordSet(sql, con)

defaultBoxSize1 = ""
defaultBoxSize2 = ""


if compId = 8 then
' hb
defaultPackWidth=getHBWidth(con, rs("purchase_no"))
if defaultPackWidth="n" then defaultPackWidth=0
defaultPackHeight=getHbHeight(con, rs("purchase_no"))
defaultPackDepth=getHbDepth(con, rs("headboardstyle"))
defaultPackKG = checkMattKg(con,8,rs("headboardstyle"),defaultBoxSize1,defaultPackWidth,null)

end if




response.write(defaultPackWidth & "," & defaultPackHeight & "," & defaultPackDepth & "," & defaultPackKG)

rs.close
set rs = nothing
con.close
set con=nothing
%>
