<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,REGIONAL_ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, recordno
msg=""
msg=Request("msg")
count=0
submit=Request("submit") 
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
<% 
postcodefull=Request("postcode")
postcode=Replace(postcodefull, " ", "")
If msg<>"" Then response.Write("<p><font color=""red"">The Brochure Requests were " & msg & "</font></p>")%>
<p>The following orders are on hold.</p>
<p class="b"> <a href="javascript:selectAll()">Select All</a>&nbsp;|
    <a href="javascript:deselectAll()">Deselect All</a>&nbsp;</p>
<p>

<form name="form1" method="post" action="submitheldorders.asp">	
  <p>
    <%Set Con = getMysqlConnection()
sql = "Select * from address A, contact C, Purchase P Where C.retire='n' AND A.code=C.code AND C.code=P.code AND P.orderonhold='y' and (P.cancelled='n' or P.cancelled is null)"
if not isSuperuser() then
	sql = sql & " AND A.owning_region=" & retrieveuserregion() & ""
	If retrieveUserLocation() <> 1 and retrieveUserLocation()<>27 and not userHasRoleInList("ADMINISTRATOR,REGIONAL_ADMINISTRATOR") then
		sql = sql & " AND P.idlocation=" & retrieveUserLocation() & ""
	end if
	sql = sql & " AND A.source_site='" & retrieveUserSite() & "'"
end if
'response.write("<br>" & sql)
Set rs = getMysqlQueryRecordSet(sql, con)
response.Write("Total = " & rs.recordcount & "<br /><br />")
recordno=rs.recordcount
Do until rs.EOF
response.Write("<p><input type=""checkbox"" name=""XX_" & rs("purchase_no") & """ id=""XX_" & rs("purchase_no") & """><a href=""editcust.asp?val=" & rs("contact_no") & """>")
If rs("title")<>"" then response.write(rs("title") & " ")
If rs("first")<>"" then response.write(rs("first") & " ")
If rs("surname")<>"" then response.write(rs("surname") & " ")
If rs("order_number")<>"" then response.write(" - Order No: " & rs("order_number") & " ")
If rs("order_date")<>"" then response.write(" - Date: " & rs("order_date") & " ")
if NOT userHasRole("NOPRICESUSER") then
'if (retrieveuserid()<>181 and retrieveuserid()<>182) then
	If rs("total")<>"" then response.write(" - Value: " & rs("total") & " ")
end if
response.Write("</a><br></p>")
count=count+1
rs.movenext
loop
rs.close
set rs=nothing
Con.Close
Set Con = Nothing%>
    
    <label>
     
      <input type="submit" name="submit1" id="submit1" value="PLACE ORDERS">
    </label>
  </p>
  <p>&nbsp;</p>
</form><%If recordno > 12 then%>
                 <p><a href="#top" class="addorderbox">&gt;&gt; Back to Top</a></p>
<%end if%>
</div>
  </div>
<div>
</div>
       
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
