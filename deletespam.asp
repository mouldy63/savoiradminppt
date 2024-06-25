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
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg
msg=""
msg=Request("msg")
count=0
if isSuperUser() then 
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
If msg<>"" Then response.Write("<p><font color=""red"">The entries were " & msg & "</font></p>")%>
<p>The following entries have been retired and now need deleting or may have been deleted in error and need reactivating.</p>
<p class="b"> <a href="javascript:selectAll()">Select All</a>&nbsp;|
    <a href="javascript:deselectAll()">Deselect All</a>&nbsp;</p>
<p>

<form name="form1" method="post" action="deleteentries.asp">	
  <p>
    <%Set Con = getMysqlConnection()
sql = "Select * from address A, contact C Where C.retire='y' AND A.code=C.code"

'response.write("<br>" & sql)
Set rs = getMysqlQueryRecordSet(sql, con)
Do until rs.EOF
response.Write("<p><input type=""checkbox"" name=""XX_" & rs("code") & """ id=""XX_" & rs("code") & """><a href=""editcust.asp?val=" & rs("contact_no") & """>")
If rs("title")<>"" then response.write(rs("title") & " ")
If rs("first")<>"" then response.write(rs("first") & " ")
If rs("surname")<>"" then response.write(rs("surname") & " ")
If rs("company")<>"" then response.write(rs("company"))
If rs("street1")<>"" then response.write(", " & rs("street1"))
If rs("street2")<>"" then response.write(", " & rs("street2"))
If rs("street3")<>"" then response.write(", " & rs("street3"))
If rs("town")<>"" then response.write(", " & rs("town"))
If rs("county")<>"" then response.write(", " & rs("county"))
If rs("postcode")<>"" then response.write(", " & rs("postcode"))
If rs("country")<>"" then response.write(", " & rs("country"))
response.Write("</a><br></p>")
count=count+1
rs.movenext
loop
rs.close
set rs=nothing
Con.Close
Set Con = Nothing%>
    
    <label>
    </label>
    <input type="submit" name="submit2" id="submit2" value="Re-activate" onClick="return confirm('Are you sure you want to reactivate these brochure requests?'); ">
    <input type="submit" name="submit1" id="submit1" value="Delete Entries (spam)" onClick="return confirm('Are you sure you want to DELETE these entries - all details for these customers will be removed?'); ">
  </p>
  <p>&nbsp;</p>
</form>
</div>
  </div>
<div>
</div>
       
</body>
</html>
<%End If%>
 <script language="JavaScript">
<!--

function selectAll() {

	if (document.form1.elements) {
	    for (var j = 0; j < document.form1.elements.length; j++) {
	        var e = document.form1.elements[j];
	        if (e.type == "checkbox" && e.name.length > 2 && e.name.substr(0,3) == "XX_" ) {
	            e.checked = true;
	        }
	    }
	}

}

function deselectAll() {

	if (document.form1.elements) {
	    for (var j = 0; j < document.form1.elements.length; j++) {
	        var e = document.form1.elements[j];
	        if (e.type == "checkbox" && e.name.length > 2 && e.name.substr(0,3) == "XX_" ) {
	            e.checked = false;
	        }
	    }
	}

}

//-->
</script>
   
<!-- #include file="common/logger-out.inc" -->
