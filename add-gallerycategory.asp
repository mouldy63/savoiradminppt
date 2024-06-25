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
<%Dim postcode, postcodefull, val, Con, rs, rs1, recordfound, id, rspostcode, submit, count, webadmin, msg, website, categoryname
categoryname=request("categoryname")
website=request("website")
webadmin=request("webadmin")
msg=""
count=0
submit=Request("submit")
Set Con = getMysqlConnection()
If submit<>"" and request("categoryname")<>"" then

Set rs = getMysqlUpdateRecordSet("Select * from gallerycategory", con)
rs.AddNew
If categoryname<>"" then rs("gallerycategory")=categoryname
if website<>"" then rs("website")="y"
if webadmin<>"" then rs("Sadmin")="y"
rs.update
rs.close
set rs=nothing
msg="Category " & categoryname & " has been added."

end if

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta content="text/html; charset=utf-8" http-equiv="content-type" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
	
<SCRIPT LANGUAGE="VBScript">
Function MyForm_onSubmit
  If Msgbox("Are you sure you want to delete this record?", vbYesNo + vbExclamation) = vbNo Then
    MyForm_onSubmit = False
  End If
End Function
</SCRIPT>

<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
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
<p>Add Gallery Category:</p>
<div id="c1">
<form name="form1" method="post" action="add-gallerycategory.asp">
  <p>Enter new category name:
    <input type="text" name="categoryname" id="categoryname">
    <br>
  </p>
  <p>Select where it is to appear:</p>
  <p>
    <input type="checkbox" name="website" id="website">
    <label for="website"></label>
    Website</p>
  <p>
    <input type="checkbox" name="admin" id="admin">
    Admin<br>
    <label for="webadmin"></label>
  </p>
  <p>
    <input type="submit" name="submit" id="submit" value="Submit">
  </p>
</form>
</div>
<div id="c2"> 
<p><b>Current Categories</b><br /><br />
<%


Set rs = getMysqlQueryRecordSet("Select * from gallerycategory order by gallerycategory", con)
Do until rs.eof

	response.Write(rs("gallerycategory") & "<br />")
rs.movenext
loop

rs.close
set rs=nothing	%>
</p>  </div>  

<p>&nbsp;</p>     
  </div>
  </div>
<div>
</div>
       
</body>
</html>
<%con.close
set con=nothing%>
   
<!-- #include file="common/logger-out.inc" -->
