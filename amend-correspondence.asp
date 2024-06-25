<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim postcode, postcodefull, Con, rs, rs1, recordfound, id, rspostcode, submit, count, sql, location
count=0
submit=Request("submit") 
Set Con = getMysqlConnection()%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta content="text/html; charset=utf-8" http-equiv="content-type" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />

<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>
<script src="scripts/keepalive.js"></script>

</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">
	

<div id="alerts">
		<noscript>
			<p>&nbsp;</p>
		</noscript>
	</div>
		<form action="amend-letter.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
          <p>
            <label>
<%sql="Select * from correspondence"
If not isSuperuser then
sql=sql & " WHERE superuseramendonly='n' AND owning_region=" & retrieveUserRegion() & " AND"
If retrieveUserRegion<>1 then sql=sql & " owning_location=" & retrieveuserlocation() & " AND" 
sql=sql & " source_site='" & retrieveUserSite & "'"
End If
'response.Write("sql=" & sql)
'response.End()%>
              <select name="correspondence" id="correspondence">
              <option value="n">Choose</option>
                         <%

Set rs = getMysqlQueryRecordSet(sql, con)
If rs.eof Then 
response.Write("No correspondence available - go back to admin menu and select Add New Correspondence")
else
Do until rs.eof
if rs("owning_location")<>"" then
Set rs1 = getMysqlQueryRecordSet("Select * from location where idlocation=" & rs("owning_location"), con)
location=rs1("location")
else 
location="UK"
end if
%>
   <option value="<%=rs("correspondenceid")%>"><%=rs("correspondencename")%> - <%=location%></option>
   <%rs.movenext
   loop
  End If
   rs.close
   set rs=nothing
   con.close
   set con=nothing%>
              </select>
            </label>
          </p>
          <p>
            <input type="submit" name="submit1" value="Edit"  id="submit1" class="button" />
          </p>
    </form>
    
  </div>
  </div>
<div>
</div>
       
</body>
</html>
 <script Language="JavaScript" type="text/javascript">
<!--
   
function FrontPage_Form1_Validator(theForm)
{
    if (theForm.correspondence.value == "n")
  {
    alert("Please choose correspondence to amend");
    theForm.correspondence.focus();
    return (false);
  }
    return true;
} 

//-->
</script>
   
<!-- #include file="common/logger-out.inc" -->
