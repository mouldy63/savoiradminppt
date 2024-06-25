<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR, SAVOIRSTAFF"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim orders, Con, rs, rs1, id, sql, collectionid, locationname
orders=""
id=request("id")
collectionid=request("collectionid")
Set Con = getMysqlConnection()
sql="SELECT * from location where idlocation=" & id
Set rs = getMysqlQueryRecordSet(sql, con)
if not rs.eof then locationname=rs("adminheading")
rs.close
set rs=nothing
sql="SELECT * from exportCollShowrooms where exportCollectionID=" & collectionid & " and idlocation=" & id

Set rs = getMysqlUpdateRecordSet(sql, con)
if not rs.eof then
	sql="SELECT P.order_number, P.purchase_no from exportLinks E, purchase P where E.purchase_no=P.purchase_no and Linkscollectionid=" & rs("exportCollshowroomsID") & " group by E.purchase_no"

	Set rs1 = getMysqlQueryRecordSet(sql, con)
	if rs1.eof then
	rs.delete
	else
	do until rs1.eof
	orders= orders & "<a href=""orderdetails.asp?pn=" & rs1("purchase_no") & """>" & rs1("order_number") & "</a> "
	rs1.movenext
	loop
	end if
	rs1.close
	set rs1=nothing
end if
rs.Close
Set rs = Nothing
Con.Close
Set Con = Nothing
response.Redirect("edit-collection.asp?lname=" & locationname & "&orders=" & orders & "&collectionid=" & collectionid)
%>

<!-- #include file="common/logger-out.inc" -->
