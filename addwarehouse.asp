<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim Con, rs, userid, sql, warehousename, msg, idlocation, add1, add2, town, county, country, postcode, contact, tel, amend, warehouseid, mainwarehouse, wid
mainwarehouse=request("mainwarehouse")
warehouseid=request("warehouseid")
amend=request("amend")
idlocation=request("idlocation")
warehousename=request("warehousename")
add1=request("add1")
add2=request("add2")
town=request("town")
county=request("county")
country=request("country")
postcode=request("postcode")
contact=request("contact")
tel=request("tel")
if warehousename<>""  and add1<>"" then
Set Con = getMysqlConnection()
if amend="y" then
		sql="SELECT * from location_address where LOCATION_ADDRESS_ID=" & warehouseid
		Set rs = getMysqlUpdateRecordSet(sql, con)
	else
		sql="SELECT * from location_address"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		rs.AddNew
end if
if warehousename <>"" then rs("warehousename")=warehousename else rs("warehousename")=""
rs("idlocation")=idlocation
if add1 <>"" then rs("add1")=add1 else rs("add1")=""
if add2 <>"" then rs("add2")=add2 else rs("add2")=""
if town <>"" then rs("town")=town else rs("town")=""
if county <>"" then rs("countystate")=county else rs("countystate")=""
if country <>"" then rs("country")=country else rs("country")=""
if contact <>"" then rs("contact")=contact else rs("contact")=""
if tel <>"" then rs("phone")=tel else rs("phone")=""
if mainwarehouse="y" then rs("ISDEFAULT")="y" else rs("ISDEFAULT")="n"
rs.Update
wid=rs("LOCATION_ADDRESS_ID")
rs.close
set rs=nothing
if mainwarehouse="y" then 
sql="SELECT * from location_address where LOCATION_ADDRESS_ID<>" & wid & " and idlocation=" & idlocation
		Set rs = getMysqlUpdateRecordSet(sql, con)
		do until rs.eof
		rs("isdefault")="n"
		rs.movenext
		loop
end if

msg=warehousename & "has been edited"
Con.Close
Set Con = Nothing
response.Redirect("add-warehouse.asp?msg=" & msg & "")
end if
%>
  
<!-- #include file="common/logger-out.inc" -->
