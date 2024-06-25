<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,WEBSITEADMIN"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim Con, rs, val, rs1, i, selected
selected=""
val=Request("val")
Set Con = getMysqlConnection()%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta content="text/html; charset=utf-8" http-equiv="content-type" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />


<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">

<%
Set rs = getMysqlQueryRecordSet("Select * from press WHERE pressid=" & val, con)

%>

<form action="update-press.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">
<p><strong>Amend press item below</strong><br>
<br>
</p>

<p>
<label for="maincountry"></label>
<select name="maincountry" id="maincountry">
<%Set rs1 = getMysqlQueryRecordSet("Select * from store_country order by country_id", con)
Do until rs1.eof
if rs("country")=rs1("country_id") then selected="selected" else selected=""%>
<option value="<%=rs1("country_id")%>" <%=selected%>><%=rs1("country")%></option>
<%rs1.movenext
loop
rs1.close
set rs1=nothing%>
</select>
If the main press item is not for the UK select which country it is for (this will ensure that it is prioritised before any UK press items.
</p>
<p>Date:
<%=rs("date")%>
<br /><br /><b>Select which countries the press item should appear on:</b><br /><br />

<%Set rs1 = getMysqlQueryRecordSet("Select * from store_country order by country_id", con)
Do until rs1.eof%>

<%for i=1 to rs1.recordcount
if rs("country" & i & "")="y" AND rs1("country_id")=i then %>
<input name="country<%=i%>" value="y" type="checkbox" checked><%=rs1("country")%>&nbsp;&nbsp;
<%elseif  rs("country" & i & "")="n" AND rs1("country_id")=i then%>
<input name="country<%=i%>" value="y" type="checkbox"><%=rs1("country")%>&nbsp;&nbsp;
<%end if
next
rs1.movenext
loop
rs1.close
set rs1=nothing%>


</p>
<p>If press item needs a link to a URL instead of a pdf please add it here:
<input name="urllink" type="text" value="<%=rs("urllink")%>" size="70"><input name="val" type="hidden" value="<%=val%>">
<p>
<input type="submit" name="submit1" value="Amend Press item"  id="submit1" class="button" />
<p><br /><br />


</form>

<form action="deletepress.asp?val=<%=val%>" method="post"  name="form2" onSubmit="return FrontPage_Form1_Validator(this)">
<input name="val" id="val" type="hidden" value="<%=val%>">
<p align="right"><input type="submit" name="submit1" value="DELETE Press item"  id="submit1" class="button" /></p>

</form>
<%rs.close
set rs=nothing

Con.Close
Set Con = Nothing%>
</div>
</div>
<div>
</div>

</body>
</html>


<!-- #include file="common/logger-out.inc" -->
