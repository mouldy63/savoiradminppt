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
<%Dim postcode, postcodefull, Con, rs, rs1, recordfound, id, rspostcode, submit, count, sql, msg, cust, customerasc, actiondate
actiondate=""
customerasc=""
cust=""
msg=""
msg=Request("msg")
customerasc=Request("customerasc")
actiondate=Request("actiondate")

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

</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">

<p>To Do List</p>
<p class="b"> <a href="javascript:selectAll()">Select All</a>&nbsp;|
    <a href="javascript:deselectAll()">Deselect All</a>&nbsp;</p>
<p>

  <p>
    <%Set Con = getMysqlConnection()
sql = "Select * from contact C, Communication P Where P.actioned='n' AND C.code=P.code AND P.next is not null"
if not isSuperuser() then
	sql = sql & " AND A.owning_region=" & retrieveuserregion() & ""
	If retrieveUserLocation()<>1 then
	sql = sql & " AND C.idlocation=" & retrieveUserLocation() & ""
	end if
	sql = sql & " AND A.source_site='" & retrieveUserSite() & "'"
end if
if customerasc="a" then
sql = sql & " order by C.surname asc"
end if
if customerasc="d" then
sql = sql & " order by C.surname desc"
end if
if actiondate="a" then
sql = sql & " order by P.next asc"
end if
if actiondate="d" then
sql = sql & " order by P.next desc"
end if
If customerasc="" and actiondate="" then
sql = sql & " order by P.next asc"
end if
'response.write("<br>" & sql)
Set rs = getMysqlQueryRecordSet(sql, con)
response.Write("Total = " & rs.recordcount & "<br /><br />")%>
<table width="100%" border="0" cellspacing="2" cellpadding="2">
  <tr>
    <td width="19%" valign="top">Customer Name:<a href="todolist.asp?customerasc=d"><br>
      <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="todolist.asp?customerasc=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></td>
    <td width="15%" valign="top">Action Date<a href="todolist.asp?actiondate=d"><br>
      <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="todolist.asp?actiondate=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></td>
    <td width="12%" valign="top">Response</td>
    <td width="19%" valign="top">Previous / <br />Current Order No.</td>
    <td width="9%" valign="top">Added By:</td>
    <td width="26%" valign="top">Notes:</td>

  </tr>
<%
Do until rs.EOF
%>

  <tr>
    <td valign="top"><a href="actionitem.asp?val=<%=rs("code")%>"><%If rs("title")<>"" then response.write(rs("title") & " ")
If rs("first")<>"" then response.write(rs("first") & " ")
If rs("surname")<>"" then response.write(rs("surname") & "</a> ")%></a>&nbsp;</td>
    <td valign="top"><%If rs("next")<>"" then response.write(rs("next") & " ")%>&nbsp;</td>
    <td valign="top"><%If rs("response")<>"" then response.write(rs("response") & " ")%></td>
    <td valign="top"><%Set rs1 = getMysqlQueryRecordSet("Select * from purchase  Where code=" & rs("code"), con)
	Do until rs1.eof
	response.Write(rs1("order_number") & "<br />")
	rs1.movenext
	loop
	rs1.close
	set rs1=nothing%></td>
    <td><%=rs("staff")%> &nbsp;</td>
     <td><%=rs("notes")%> &nbsp;</td>
  </tr>

<%
count=count+1
rs.movenext
loop
rs.close
set rs=nothing
Con.Close
Set Con = Nothing%>
  
</table> 
  
</p></p></div></div>
<div>
</div>
       
</body>
</html>
<script Language="JavaScript" type="text/javascript">
<!--
	
function FrontPage_Form1_Validator(theForm)
{
 if (theForm.datequotedeclined.value == "")
  {
    alert("Please enter date quote was declined");
    theForm.datequotedeclined.focus();
    return (false);
  }
   if (theForm.reasonquotedeclined.value == "")
  {
    alert("Please enter reason quote(s) where declined");
    theForm.reasonquotedeclined.focus();
    return (false);
  }
 

    return true;
} 

//-->
</script>
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
