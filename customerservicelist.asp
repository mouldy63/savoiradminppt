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
<%Dim postcode, postcodefull, Con, rs, rs1, recordfound, id, rspostcode, submit, count, sql, msg, csnumberdesc, orderasc, showr,  csnumberasc, bookeddate, previousOrderNumber, acknowDateWarning, sortorder, lastuser
lastuser=""
dim diff

sortorder=request("sortorder")
If sortorder="" then sortorder="csnumber asc"
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

If msg<>"" Then response.Write("<p><font color=""red"">" & msg & "</font></p>")%>
<p>Customer Service List</p>


<!--<form name="form1" method="post" action="">-->	
  <p>
<%
Set Con = getMysqlConnection()
sql = "Select * from customerservice where csclosed='n'"
if  isSuperuser() or retrieveuserlocation()=1 then
else
	sql = sql & " AND idregion=" & retrieveuserregion() & ""
	sql = sql & " AND idlocation=" & retrieveuserlocation() & ""
end if
sql=sql &  " order by " & sortorder 
Set rs = getMysqlQueryRecordSet(sql, con)
response.Write("Total number of reports open = " & rs.recordcount)
'response.Write("sql = " & sql)
%>
<table width="935" border="0" cellpadding="6" cellspacing="2">
 <tr>
    <td width="71" valign="bottom"><b>Customer Service No.<a href="customerservicelist.asp?sortorder=csnumber desc"><br>
      <br>
      <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="customerservicelist.asp?sortorder=csnumber asc"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></b></td>
    <td width="69" valign="bottom"><strong>Location<br>
      <br>
    </strong><b><a href="customerservicelist.asp?sortorder=showroom desc"><img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="customerservicelist.asp?sortorder=showroom asc"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></b></td>
       <td width="72" valign="bottom"><strong>Order No<br>
         <br>
       </strong><b><a href="customerservicelist.asp?sortorder=orderno desc"><img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="customerservicelist.asp?sortorder=orderno asc"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></b></td>
       <td width="75" valign="bottom"><strong>Customer Name</strong><br>
        <br>
        <b><a href="customerservicelist.asp?sortorder=dataentrydate desc"><img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="customerservicelist.asp?sortorder=custname asc"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></b></td> 
       <td width="72" valign="bottom"><b>Customer Service Date<a href="customerservicelist.asp?sortorder=custname desc"><br>
         <br>
        <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="customerservicelist.asp?sortorder=dataentrydate asc"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></b></td>
       <td width="106" valign="bottom"><strong>Item Description</strong></td>
       <td width="100" valign="bottom"><strong>Latest Note</strong></td>
       <td width="49" valign="bottom"><strong>Last note by</strong></td>
       <td width="71" valign="bottom">Savoir Staff resolving this issue<br>
        <br>
        <strong><a href="customerservicelist.asp?sortorder=savoirstaffresolvingissue desc"><img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="customerservicelist.asp?sortorder=savoirstaffresolvingissue asc"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></strong></td>

    <td width="108" valign="bottom"><b>Follow-up Date<br>
      <br>
    </b><strong><a href="customerservicelist.asp?sortorder=followupdate desc"><img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="customerservicelist.asp?sortorder=followupdate asc"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></strong></td>
   
    </tr>
<%Do until rs.EOF%>
<%' if rs("order_number") <> previousOrderNumber then
'rs("order_date") 
'If the acknowledgement date is Null, and the Order Date is more than 7 days beyond than current date then a Red flag appears
'acknowDateWarning = false
'if (isnull(rs("acknowdate")) or rs("acknowdate") = "") and rs("order_date") <> "" then
'	diff = dateDiff("d", cdate(rs("order_date")), now())
'	acknowDateWarning = (diff > 7)
'end if
%>
	  <tr>
	    <td valign="top"><%
	response.Write("<a href=""customerservicereport.asp?csid=" & rs("csid") & """>")
	response.Write(rs("csnumber"))
	response.Write("</a>")
	%></td>
	    <td valign="top"><%
	If rs("showroom")<>"" then response.write(rs("showroom"))
	%></td>
	        <td valign="top"><%If rs("orderno")<>"" then 
	sql="Select * from purchase where order_number = " & rs("orderno")
	Set rs1 = getMysqlQueryRecordSet(sql, con)
	if not rs1.eof then
		response.write("<a href=""edit-purchase.asp?order=" & rs1("purchase_no") & """>" & rs("orderno") & "</a>")
		else
		response.Write(rs("orderno"))
	end if
	rs1.close
	set rs1=nothing
end if
%></td>
	        <td valign="top"><%
			
			 response.write(rs("custname"))
			
		%></td>
	        <td valign="top"><%If rs("dataentrydate")<>"" then response.write(rs("dataentrydate") & " ")%>&nbsp;</td>
	        <td valign="top"><%
			If rs("itemdesc")<>"" then
			 response.write(rs("itemdesc"))
			end if
		%></td>
	        <td valign="top"> <% Set rs1 = getMysqlQueryRecordSet("Select * from customerservicenotes where csid = " & rs("csid") & " order by csnotesid desc, dateadded desc", con)
   if not rs1.eof then
			If rs1("note")<>"" then
			 response.write(rs1("note"))
			 lastuser=rs1("noteaddedby")
			end if
	end if
	rs1.close
	set rs1=nothing
		%></td>
	        <td valign="top"><%
			If lastuser<>"" then
			Set rs1 = getMysqlQueryRecordSet("Select * from savoir_user where user_id = " & cint(lastuser), con)
	response.Write(rs1("username"))
	rs1.close
	set rs1=nothing
	lastuser=""
			
			end if%>&nbsp;</td>
	        <td valign="top"><% 

					 response.write(rs("savoirstaffresolvingissue"))
	
		%></td>
	
	    <td valign="top">
        <%If rs("followupdate")<>"" then
			If rs("followupdate")<date() then
			response.write("<font color=red>" & rs("followupdate") & "</font> ")
			else
			 response.write(rs("followupdate") & " ")
			end if
		end if%>&nbsp;</td>
	 
	    </tr>
	<%
	count=count+1
	
rs.movenext
loop%>
</table>
<%if rs.recordcount>20 then%>
  <p><a href="#top" class="addorderbox">&gt;&gt; Back to Top</a></p>
  <%end if%>
<%rs.close
set rs=nothing
Con.Close
Set Con = Nothing%>
    

    
  </p>

<!--</form>-->
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
