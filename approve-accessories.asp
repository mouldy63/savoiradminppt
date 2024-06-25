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

if isSuperUser() then %>

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


<p>The following images are waiting approval.</p>
<p class="b"> <a href="javascript:selectAll()">Select Al for Approvall</a>&nbsp;|
    <a href="javascript:deselectAll()">Deselect All for Approval</a>&nbsp;</p>


<form name="form1" method="post" action="accessoriesapproved.asp">	

    <%Set Con = getMysqlConnection()
sql = "Select * from accessories A, location L Where A.approved='n' AND A.idlocation=L.idlocation"
'response.write("<br>" & sql)
Set rs = getMysqlQueryRecordSet(sql, con)
Do until rs.EOF
response.Write("<p><b>" & rs("Accessory") & "</b></p><p>Approve: <input type=""checkbox"" name=""XX_" & rs("accessoryid") & """ id=""XX_" & rs("accessoryid") & """><img src=""accessories/accessory" & rs("accessoryid") & ".jpg"" width=""180"" height=""177""> <b>Location: " & rs("location") & "</b>")
response.Write(" | <font color=red>Delete Image:</font> <input type=""checkbox"" name=""YY_" & rs("accessoryid") & """ id=""YY_" & rs("accessoryid") & """></p><hr>")
count=count+1
rs.movenext
loop
rs.close
set rs=nothing
Con.Close
Set Con = Nothing%>

  </p>
  <p>&nbsp;</p>
  <label>
    <input type="submit" name="submit" id="submit" value="Submit">
  </label>
</form>
</div>
  </div>
<div>
</div>
 <%End If%>      
</body>
</html>
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
