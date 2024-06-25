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
<%Dim Con, rs, userid, sql, shippername, msg, add1, add2, add3, town, county, country, postcode, contact, tel, amend, shipperid, mainshipper, wid, idlocation

shippername=request("shippername")
amend=request("amend")
shipperid=request("shipperid")
add1=request("add1")
add2=request("add2")
add3=request("add3")
town=request("town")
county=request("county")
country=request("country")
postcode=request("postcode")
contact=request("contact")
tel=request("tel")
if shippername<>""  and add1<>"" then
Set Con = getMysqlConnection()
if amend="y" then
		sql="SELECT * from shipper_address where SHIPPER_ADDRESS_ID=" & shipperid
		Set rs = getMysqlUpdateRecordSet(sql, con)
	else
		sql="SELECT * from shipper_address"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		rs.AddNew
end if
if shippername<>"" then rs("shipperName")=shippername else rs("shipperName")=""
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
wid=rs("SHIPPER_ADDRESS_ID")
rs.close
set rs=nothing


msg=shippername & "has been edited"
Con.Close
Set Con = Nothing
response.Redirect("add-shipper.asp?msg=" & msg & "")
end if
%>
  
<!-- #include file="common/logger-out.inc" -->
