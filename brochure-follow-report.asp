<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="orderfuncs.asp" -->
<%Const UTF8_BOM = "﻿"
Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, recordfound, id, sql, sql1, sql2, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, orders, ordersString, showroomlocation, slected, custaddress, brochuredate, excelmsg, mnth
brochuredate=request("brochuredate")
ddmonth=""
ddyear=""
showroomlocation=""
msg=""
msg=Request("msg")
ddmonth=Request("month")
ddyear=Request("year")
monthfrom1=Request("monthfrom")
showroomlocation=request("location")
If monthfrom1<>"" Then
	monthfrom=year(monthfrom1) & "/" & month(monthfrom1) & "/" & day(monthfrom1)
	monthto1=Request("monthto")
	monthto=year(monthto1) & "/" & month(monthto1) & "/" & day(monthto1)
End If
found = false
For Each item In Request.Form
  ItemValue = Request.Form(Item)
  if Instr(ItemValue, "http://") then
	found = true
  End If
Next
For Each item In Request.Form
  ItemValue = Request.Form(Item)
  if Instr(ItemValue, "<") then
	found = true
  End If
Next
If found= true then response.Redirect("error.asp")

submit=Request("submit") 
'


	
Set Con = getMysqlConnection()
If Request("excellist")="" then
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
<script>
$(function() {
    $('#reset').click(function() {
        $(':input','#form1')
            .not(':button, :submit, :reset, :hidden')
            .val('')
            .removeAttr('checked')
            .removeAttr('selected');
    });
});
$(function() {
var year = new Date().getFullYear();
$( "#monthfrom" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
<%if monthfrom<>"" then
%>
$( "#monthfrom" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#monthfrom" ).datepicker('setDate', "<%=monthfrom1%>" );
<%else%>
$( "#monthfrom" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
<%end if%>
$( "#monthto" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
<%if monthto<>"" then
%>
$( "#monthto" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#monthto" ).datepicker('setDate', "<%=monthto1%>" );
<%else%>
$( "#monthto" ).datepicker( "option", "dateFormat", "dd/mm/yy" );

<%end if%>

});

</script>
<%Dim locationname
if showroomlocation<>"n" and showroomlocation<>"" then
sql = "Select * from location where idlocation=" & showroomlocation
 Set rs = getMysqlQueryRecordSet(sql, con)
 locationname=rs("location")
 rs.close
 set rs=nothing
else
 locationname="all showrooms"
end if
%>
<style>
table.tablebd {
	border: 1px solid #999;
	width: 100%;
	border-collapse:collapse;
}
table.tablebd td, table.tablebd th {
  border: 1px solid #999;
  padding: 6px 4px;
}

</style>
</head>
<body>
<div class="container">
<!-- #include file="header.asp" -->


					  <div class="content brochure">
			    <div>
                <form action="brochure-follow-report.asp" method="post" name="form1" id="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
					  
			<p>Brochure Follow Ups</p>


	
    
        <input type="hidden" name="site" value="<%=retrieveUserSite()%>" />
       
		  <p>Generate Brochure Follow Report:</p>
	  <p>from&nbsp;
	    <label>
	      <input name="monthfrom" type="text" id="monthfrom" size="10" value="<%=monthfrom%>">
	      &nbsp;&nbsp;&nbsp;&nbsp;to&nbsp;</label>
          <label>
	      <input name="monthto" type="text" id="monthto" size="10" value="<%=monthto%>">
	       </label>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
			OR by Month 
			  <label>
    <select name="month" id="month" >
      <option value="n">Select Month</option>
      <%For i=12 to 1 step -1
	  slected=""
	  mnth = month(DateAdd("m",-i,date()))
	  if ddmonth<>"n" then
	  	if CInt(mnth)=CInt(ddmonth) then slected="selected"
	  end if
	  %>
      <option value="<%=mnth%>" <%=slected%> ><%=MonthName(mnth)%></option>
      <% next%>
      </select>
        </label>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
			  Year
			  <label>
			    <select name="year" id="year">
                  <option value="n">Select Year</option>
                  <%slected=""
	  				if request("year")<>"n" then
	  				if Year(date())=CInt(Request("year")) then slected="selected"
					end if%>
			      <option value="<%=Year(date())%>" <%=slected%>><%=Year(date())%></option>
			      <%For i=1 to 10
					  slected=""
	  				if request("year")<>"n" then
	  				if CInt(year(date())-i)=CInt(Request("year")) then slected="selected"
					end if%>
			      <option value="<%=year(date())-i%>" <%=slected%>><%=year(date())-i%> </option>
			      <% next%>
	            </select>
	          </label>
		     <label> </label>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <p>
      <%
                                    sql = "Select * from savoir_user where retired='n' and username<>'production' order by username"
                                    Set rs1 = getMysqlQueryRecordSet(sql, con)
                                    %>
        
        <select name = "user" size = "1" class = "formtext" id = "user">
          <option value = "n">User</option>
          <%
                                        do until rs1.EOF
                                        slected=""
	  				if request("user")<>"n" then
	  				if rs1("username")=Request("user") then slected="selected"
					end if%>
          
          <option value = "<%=rs1("username")%>" <%=slected%>><%=rs1("username")%></option>
          <%
                                        rs1.movenext
                                        loop
                                        rs1.Close
                                        Set rs1 = Nothing
                                        %>
          </select> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          
        <%
                                    sql = "Select * from location where retire<>'y' order by adminheading"
                                    Set rs1 = getMysqlQueryRecordSet(sql, con)
                                    %>
        
        <select name = "location" size = "1" class = "formtext" id = "location">
          <option value = "n">All Showrooms</option>
          <%
                                        do until rs1.EOF
                                        slected=""
	  				if request("location")<>"n" then
	  				if CInt(rs1("idlocation"))=CInt(Request("location")) then slected="selected"
					end if%>
          
          <option value = "<%=rs1("idlocation")%>" <%=slected%>><%=rs1("adminheading")%></option>
          <%
                                        rs1.movenext
                                        loop
                                        rs1.Close
                                        Set rs1 = Nothing
                                        %>
          </select>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  
        <select name="commstatus" size="1" class="formtext" id="commstatus">
          <option value="n">Select Status:</option>
          
          <option value="To Do">To Do</option>
          <option value="Completed">Completed</option>
          <option value="Cancelled">Cancelled</option>
          
          </select>
        
        
        <br>
        <br>
  <input type="submit" name="submit" value="Apply Filter"  id="submit" class="button" />
        <label>
          <input name="excellist" type="submit" class="button" id="excellist" value="Download CSV">
          </label>
  <input type="button" id="clear-form" value="Clear Form" />
        
                </form>
			
        
<%sql="Select * from communication X, contact C, Location L WHERE X.code=C.Code and C.idlocation=L.idlocation and (X.type like '%brochure request%' or X.notes like '%brochure request%') and "
If monthfrom1 <> "" AND monthto1 <> "" Then 
	sql=sql &  " date > '" & monthfrom & "' and date < '" & monthto & "'"
End if
If ddmonth<>"n" and ddyear<>"n" then
	sql=sql & " month(date) = " & ddmonth & " AND year(date) = " & ddyear & ""
end if
if showroomlocation<>"n" then
	sql=sql & " AND C.idlocation=" & showroomlocation & ""
end if
if (request("commstatus")<>"n" and request("commstatus")<>"") then
	sql=sql & " AND X.commstatus='" & request("commstatus") & "'"
end if
if (request("user")<>"n" and request("user")<>"") then
	sql=sql & " AND (X.staff='" & request("user") & "' OR X.response like '%" & request("user") & "%')"
end if
if brochuredate="d" then sql=sql & " order by X.date desc"
if brochuredate="a" then sql=sql & " order by X.date asc"
if brochuredate="cd" then sql=sql & " order by X.person desc"
if brochuredate="ca" then sql=sql & " order by X.person asc"
if brochuredate="dd" then sql=sql & " order by X.next desc"
if brochuredate="da" then sql=sql & " order by X.next asc"
if brochuredate="sd" then sql=sql & " order by L.adminheading desc"
if brochuredate="sa" then sql=sql & " order by L.adminheading asc"
'response.Write("sql=" & sql)
If submit<>"" Then 
Set rs = getMysqlUpdateRecordSet(sql, con)%>

			<p>Brochure Request Reports 
            <%If ddmonth <>"n" then response.Write(" for  " & monthname(ddmonth) & " "  & ddyear)
			If monthfrom1 <>"" then response.Write(" from " & monthfrom1 & " to " & monthto1)%> 
			
			<%response.Write(" for " & locationname & " - " & rs.recordcount & " records")%>
            </p>
		  <table cellspacing="2" cellpadding="2" class="tablebd">
		    <tr class="tablebd">
		      <td valign="bottom"><b>Date of Brochure&nbsp;Request</b><br>
              <a href="brochure-follow-report.asp?brochuredate=d&msg=<%=msg%>&month=<%=ddmonth%>&year=<%=ddyear%>&monthfrom=<%=monthfrom1%>&monthto=<%=monthto1%>&location=<%=showroomlocation%>&submit=y"><br>
      <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="brochure-follow-report.asp?brochuredate=a&msg=<%=msg%>&month=<%=ddmonth%>&year=<%=ddyear%>&monthfrom=<%=monthfrom1%>&monthto=<%=monthto1%>&location=<%=showroomlocation%>&submit=y"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></td>
      		      <td valign="bottom"><b>Contact Name<br>
      		        (Customer Address)
      		      </b><br>
              <a href="brochure-follow-report.asp?brochuredate=ca&msg=<%=msg%>&month=<%=ddmonth%>&year=<%=ddyear%>&monthfrom=<%=monthfrom1%>&monthto=<%=monthto1%>&location=<%=showroomlocation%>&submit=y"><br>
      <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="brochure-follow-report.asp?brochuredate=cd&msg=<%=msg%>&month=<%=ddmonth%>&year=<%=ddyear%>&monthfrom=<%=monthfrom1%>&monthto=<%=monthto1%>&location=<%=showroomlocation%>&submit=y"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></td>
              <td valign="bottom"><b>Follow&nbsp;Up&nbsp;Date</b><br>
              <a href="brochure-follow-report.asp?brochuredate=da&msg=<%=msg%>&month=<%=ddmonth%>&year=<%=ddyear%>&monthfrom=<%=monthfrom1%>&monthto=<%=monthto1%>&location=<%=showroomlocation%>&submit=y"><br>
      <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="brochure-follow-report.asp?brochuredate=dd&msg=<%=msg%>&month=<%=ddmonth%>&year=<%=ddyear%>&monthfrom=<%=monthfrom1%>&monthto=<%=monthto1%>&location=<%=showroomlocation%>&submit=y"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></td>
              <td valign="top"><b>Response Notes</b></td>
              <td valign="top"><b>Status</b></td>
              <td valign="top"><b>Showroom&nbsp;&nbsp;&nbsp;</b><br>
              <a href="brochure-follow-report.asp?brochuredate=sa&msg=<%=msg%>&month=<%=ddmonth%>&year=<%=ddyear%>&monthfrom=<%=monthfrom1%>&monthto=<%=monthto1%>&location=<%=showroomlocation%>&submit=y"><br>
      <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="brochure-follow-report.asp?brochuredate=sd&msg=<%=msg%>&month=<%=ddmonth%>&year=<%=ddyear%>&monthfrom=<%=monthfrom1%>&monthto=<%=monthto1%>&location=<%=showroomlocation%>&submit=y"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></td>
              <td valign="top"><b>Order Date/Number & Value</b></td>
	        </tr>
<%'response.Write("sql=" & sql)
Do until rs.eof
custaddress=""
orders = getCustomerOrdersAndValues(con, rs("contact_no"), rs("date"))
custaddress= getCustomerAddress(con, rs("code"))
%>		    <tr>
		      <td valign="top"><a href="editcust.asp?tab=4&val=<%=rs("contact_no")%>"><%=left(rs("date"), 10)%></a></td>
        <td valign="top"><a href="editcust.asp?tab=4&val=<%=rs("contact_no")%>"><%=rs("person")%><br><%=custaddress%></a></td>
        <td valign="top"><a href="editcust.asp?tab=4&val=<%=rs("contact_no")%>"><%if rs("commstatus")="To Do" then response.Write(left(rs("next"), 10))%></a></td>
        <td valign="top"><a href="editcust.asp?tab=4&val=<%=rs("contact_no")%>"><%=rs("response")%></a></td>
        <td valign="top"><a href="editcust.asp?tab=4&val=<%=rs("contact_no")%>"><%=rs("commstatus")%></a></td>
        <td valign="top"><a href="editcust.asp?tab=4&val=<%=rs("contact_no")%>"><%=rs("location")%></a></td>
        <td valign="top"><a href="editcust.asp?tab=4&val=<%=rs("contact_no")%>"><%
for i = 1 to ubound(orders)
	response.Write(orders(i) & "<br>")
next%></a>
</td>
        
		      </tr>
           <%rs.movenext
		   loop
		   rs.close
set rs=nothing
		%>
	      </table>
		</div>
  </div>
<div>
</div>
        </form>
</body>
</html>
<%End if
end if
If Request("excellist")<>"" then
Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, brochuresentdate, ordernos, ordervals
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.Write(UTF8_BOM)
sql="Select * from communication X, contact C, Address A, Location L WHERE X.code=C.Code and A.code=C.code and C.idlocation=L.idlocation and (X.type like '%brochure request%' or X.notes like '%brochure request%') and "
If monthfrom1 <> "" AND monthto1 <> "" Then 
	sql=sql &  " date > '" & monthfrom & "' and date < '" & monthto & "'"
End if
If ddmonth<>"n" and ddyear<>"n" then
	sql=sql & " month(date) = " & ddmonth & " AND year(date) = " & ddyear & ""
end if
if showroomlocation<>"n" then
	sql=sql & " AND C.idlocation=" & showroomlocation & ""
end if
if (request("commstatus")<>"n" and request("user")<>"") then
	sql=sql & " AND X.commstatus='" & request("commstatus") & "'"
end if
if (request("user")<>"n" and request("user")<>"") then
	sql=sql & " AND (X.staff='" & request("user") & "' OR X.response like '%" & request("user") & "%')"
end if
Set rs = getMysqlUpdateRecordSet(sql, con)
brochuremsg="Brochure Follow Up Reports "
            If ddmonth <>"n" then brochuremsg=brochuremsg & " for  " & monthname(ddmonth) & " "  & ddyear
			If monthfrom1 <>"" then brochuremsg=brochuremsg & " from " & monthfrom1 & " to " & monthto1
			brochuremsg=brochuremsg & " for " & locationname & " - " & rs.recordcount & " records"
tempfile.WriteLine(brochuremsg)
tempfile.WriteLine("Date of Brochure Request,Brochure Sent,Contact Name,Customer Address,Follow Up Date,Response Notes,Status,Showroom,Order Number,Order Values")
Do until rs.eof
custaddress=""
custaddress= replace(getCustomerAddress(con, rs("code")),"<br>",vbCrLf)
sql="Select * from communication where code=" & rs("code") & " and type='Letter' and notes='Brochure Request Follow-Up'"
set rs1= getMysqlUpdateRecordSet(sql, con)
if not rs1.eof then
brochuresentdate=left(rs1("date"),10)
else
brochuresentdate=""
end if
rs1.close
set rs1=nothing
orders=""
ordernos=""
ordervals=""
orders = getCustomerOrdersAndValues(con, rs("contact_no"), rs("date"))
ordernos = getCustomerOrderNos(con, rs("contact_no"), rs("date"))
ordervals = cleanHtmlCode(getCustomerOrderVals(con, rs("contact_no"), rs("date")))
excelLine = """" & left(rs("date"), 10) & """,""" & brochuresentdate & """,""" & rs("person") & """,""" & custaddress
if rs("commstatus")="To Do" then
excelLine = excelLine & """,""" & left(rs("next"), 10)
else
excelLine = excelLine & """,""" & ""
end if
excelLine = excelLine & """,""" & cleanHtmlCode(rs("response")) &  """,""" & rs("commstatus") &  """,""" & rs("location")
excelLine = excelLine & """,""" & ordernos & """,""" & ordervals 
excelLine = excelLine & """"
tempfile.WriteLine(excelLine)
brochuresentdate=""
rs.movenext
loop
rs.close
set rs=nothing

tempfile.close

Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Charset = "UTF-8"
objStream.Open
objStream.Type = 1
objStream.LoadFromFile(filename)

Response.ContentType = "text/csv; charset=utf-8"
Response.AddHeader "Content-Disposition", "attachment; filename=""brochure-followup-reports.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing
end if

Con.Close
Set Con = Nothing
If Request("excellist")="" then%>
     <script Language="JavaScript" type="text/javascript">
$(document).ready(function() 
{
    $('#reset-form').on('click', function()
    {
        $("#form1").trigger("reset");
    });

    $('#clear-form').on('click', function()
    { 
        $('#form1').find('input:text, input:password, textarea').val('');
		$('#form1').find('select').val('n');
        $('#form1').find('input:radio, input:checkbox').prop('checked', false);
    });
});
<!--
function FrontPage_Form1_Validator(theForm)
{
 
   if ((theForm.monthfrom.value == "") && (theForm.monthto.value == "") && (theForm.month.value == "n") && (theForm.year.value == "n"))
  {
    alert("Please complete one of the fields to obtain results");
    theForm.monthfrom.focus();
    return (false);
  }
  
  if ((theForm.monthfrom.value == "") && (theForm.monthto.value == "") && (theForm.month.value != "n") && (theForm.year.value == "n"))
  {
    alert("Please select a year");
    theForm.year.focus();
    return (false);
  }
  if ((theForm.monthfrom.value == "") && (theForm.monthto.value == "") && (theForm.month.value == "n") && (theForm.year.value != "n"))
  {
    alert("Please select a month");
    theForm.month.focus();
    return (false);
  }

if ((theForm.monthfrom.value != "") && (theForm.monthto.value != "") && (theForm.month.value != "n"))
  {
    alert("Please reset the form and choose either Dates from and to OR month and year");
    theForm.monthfrom.focus();
    return (false);
  }

    return true;
} 

//-->
</script> 
<!-- #include file="common/logger-out.inc" -->
<%end if%>