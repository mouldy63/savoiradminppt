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
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, recordfound, id, sql, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, addperson, newname, locationname, location
Set Con = getMysqlConnection()



msg=Request("msg")



%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/extra.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>
<body>
<div class="container">
<!-- #include file="header.asp" -->

<div class="content brochure">
<div class="one-col head-col">
<%if msg<>"" then%>
<p><font color="#FF0000"><%=msg%></font></p>
<%end if%>
<div id="c1">
<form name="form1" method="post" action="addconsignee.asp">
<h1>ADD NEW CONSIGNEE</h1>
<p>CONSIGNEE Name:<br>
<input name="consigneename" type="text" id="consigneename" size="40">
</p>
<p>Address Line 1:<br>
<input name="add1" type="text" id="add1" size="40">
</p>
<p>Address Line 2:<br>
<input name="add2" type="text" id="add2" size="40">
<br>
</p>
<p>Address Line 3:<br>
<input name="add2" type="text" id="add2" size="40">
<br>
</p>
<p>Town:<br>
<input name="town" type="text" id="town" size="40">
</p>
<p>County / State :<br>
<input name="county" type="text" id="county" size="40">
</p>
<p>Postcode :<br>
<input name="postcode" type="text" id="postcode" size="40">
</p>
<p>Country :<br>
<input name="country" type="text" id="country" size="40">
<br>
</p>
<p>Contact Name :<br>
<input name="contact" type="text" id="contact" size="40">
</p>
<p>Tel :<br>
<input name="tel" type="text" id="tel" size="40">
</p>
<p>
<input type="submit" name="addperson" id="addperson" value="Add Consignee">
</p>
</form>
</div>
<div id="c2">
<h1>Current Consignees (click on Consignee to edit)</h1>
<p>
<%sql="SELECT * from consignee_address  order by consigneeName asc"

Set rs = getMysqlUpdateRecordSet(sql, con)
do until rs.eof
response.Write("<a href=""edit-consignee.asp?lid=" & rs("CONSIGNEE_ADDRESS_ID") & """><font color=""red"">" & rs("consigneeName")  & "</font></a><br />")
rs.movenext
loop
rs.close
set rs=nothing%></p>

</div>
</div>
</div>
<div>
</div>
</form>
</body>
</html>
<%

Con.Close
Set Con = Nothing
%>

<!-- #include file="common/logger-out.inc" -->
