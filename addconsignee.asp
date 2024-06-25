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
<%Dim Con, rs, userid, sql, consigneename, msg, add1, add2, add3, town, county, country, postcode, contact, tel, amend, consigneeid, mainconsignee, wid, idlocation

consigneename=request("consigneename")
amend=request("amend")
consigneeid=request("consigneeid")
add1=request("add1")
add2=request("add2")
add3=request("add3")
town=request("town")
county=request("county")
country=request("country")
postcode=request("postcode")
contact=request("contact")
tel=request("tel")
if consigneename<>""  and add1<>"" then
Set Con = getMysqlConnection()
if amend="y" then
		sql="SELECT * from consignee_address where consignee_ADDRESS_ID=" & consigneeid
		Set rs = getMysqlUpdateRecordSet(sql, con)
	else
		sql="SELECT * from consignee_address"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		rs.AddNew
end if
if consigneename<>"" then rs("consigneeName")=consigneename else rs("consigneeName")=""
if add1 <>"" then rs("add1")=add1 else rs("add1")=""
if add2 <>"" then rs("add2")=add2 else rs("add2")=""
if add3 <>"" then rs("add3")=add3 else rs("add3")=""
if town <>"" then rs("town")=town else rs("town")=""
if county <>"" then rs("countystate")=county else rs("countystate")=""
if postcode <>"" then rs("postcode")=postcode else rs("postcode")=""
if country <>"" then rs("country")=country else rs("country")=""
if contact <>"" then rs("contact")=contact else rs("contact")=""
if tel <>"" then rs("phone")=tel else rs("phone")=""
rs.Update
wid=rs("consignee_ADDRESS_ID")
rs.close
set rs=nothing


msg=consigneename & "has been edited"
Con.Close
Set Con = Nothing
response.Redirect("add-consignee.asp?msg=" & msg & "")
end if
%>
  
<!-- #include file="common/logger-out.inc" -->
