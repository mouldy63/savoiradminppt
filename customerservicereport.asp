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
<!-- #include file="orderfuncs.asp" -->

<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, customerasc, orderasc, showr,  companyasc, bookeddate, previousOrderNumber, acknowDateWarning, csnumber, completedby, deliverdon, problemdesc, showroom, userid, username, csid, rs1, lastuserlogin, noteby, rs2, closedby, toddate
toddate=day(date()) & "/" & month(date()) & "/" & year(date())
csid=request("csid")

count=0
Set Con = getMysqlConnection()



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
var year = new Date().getFullYear();
$( "#followup" ).datepicker({
changeMonth: true,
yearRange: "year:+2",
changeYear: true

});
$( "#followup" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});
</script>
</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<%Set rs = getMysqlQueryRecordSet("Select * from customerservice where csid=" & csid, con)
Set rs1 = getMysqlQueryRecordSet("Select * from savoir_user where user_id = " & rs("completedby"), con)
username=rs1("username")
rs1.close
set rs1=nothing%>
<div class="content brochure">
<div class="one-col head-col">
<h1>Customer Service report: Issue raised on <%=FormatDateTime(rs("dataentrydate"),1)%><br>
</h1>
<%If rs("csclosed")="n" then%>
<form METHOD="POST" name="form1" ENCTYPE="multipart/form-data" ACTION="addnote.asp"  onSubmit="return FrontPage_Form1_Validator(this)">
<%end if%>
<table width="90%" border="0" cellpadding="4" align="center">
<tr>
<td width="22%" valign="top">Customer Service Number</td>
<td width="31%" valign="top"><%=rs("csnumber")%></td>
<td width="25%" valign="top">Showroom</td>
<td width="22%" valign="top">
<%=rs("showroom")%></td>
</tr>
<tr>
<td valign="top">Original Form Completed by:</td>
<td valign="top">
<%=username%>

</td>
<td valign="top">Order Number</td>
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
</tr>
<tr>
<td valign="top">Date item delivered to Customer</td>
<td valign="top"><%=rs("datedelivered")%>
</td>
<td valign="top">Customer Name</td>
<td valign="top"><%=rs("custname")%></td>
</tr>
<tr>
<td valign="top">Item Description</td>
<td valign="top"><%=rs("itemdesc")%></td>
<td valign="top">Date customer first made you aware of the problem</td>
<td valign="top"><%=rs("firstawaredate")%></td>
</tr>
<tr>
<td valign="top">Please describe the problem with the product</td>
<td valign="top"><%=rs("problemdesc")%></td>
<td valign="top">Please let us know what you feel the solution to the problem is:</td>
<td valign="top"><%=rs("possiblesolution")%></td>
</tr>
<tr>
<td valign="top">Photos / Videos of problem</td>
<td rowspan="4" valign="top"><%Set rs1 = getMysqlQueryRecordSet("Select * from customerserviceuploads where csid like " & csid, con)
if not rs1.eof then
count=1
do until rs1.eof%>
<a href="<%=rs1("prodfilename")%>" target="_blank">Download <%=count%></a><br />
<%count=count+1
rs1.movenext
loop
end if
rs1.close
set rs1=nothing%></td>
<td valign="top">What action have you already taken about this problem:</td>
<td valign="top"><%=rs("actiontaken")%></td>
</tr>
<tr>
<td valign="top">&nbsp;</td>
<td valign="top">What date was this visit / action:</td>
<td valign="top"><%=rs("visitactiondate")%></td>
</tr>
<tr>
<td valign="top">&nbsp;</td>
<td valign="top">Any other comments</td>
<td valign="top"><%=rs("anycomments")%></td>
</tr>
<tr>
<td valign="top">&nbsp;</td>
<td valign="top">Savoir Staff resolving this issue</td>
<td valign="top"><label for="savoirstaff"></label>
<input type="text" name="savoirstaff" id="savoirstaff" value="<%=rs("savoirstaffresolvingissue")%>"></td>
</tr>
<tr>
<td colspan="4" valign="top"><hr></td>
</tr>
<tr>
<td valign="top"><strong>NOTES:</strong></td>
<td valign="top">&nbsp;</td>
<td><strong><%If rs("csclosed")="n" then%>
LATEST FOLLOW-UP ACTION DATE
<%else%>
DATE CLOSED
<%end if%></strong></td>
<td><%If rs("csclosed")="n" then
response.Write(rs("followupdate"))
else
response.Write(rs("datecaseclosed"))
end if%></td>
</tr>
<% Set rs1 = getMysqlQueryRecordSet("Select * from customerservicenotes where csid = " & csid & " order by csnotesid desc, dateadded desc", con)
if not rs1.eof then%>
<tr>
<td valign="top"><strong>Date of Note</strong></td>
<td valign="top"><strong>Note</strong></td>
<td valign="top"><strong>Action Date</strong></td>
<td><strong>Note Added By</strong></td>
</tr>
<%Do until rs1.eof%>
<tr>
<td valign="top"><%=rs1("dateadded")%></td>
<td valign="top"><%=rs1("note")%></td>
<td valign="top"><%=rs1("actiondate")%></td>
<%if rs1("noteaddedby")<>"" then
Set rs2 = getMysqlQueryRecordSet("Select * from savoir_user where user_id = " & rs1("noteaddedby"), con)
If not rs2.eof then
noteby=rs2("username")
end if
rs2.close
set rs2=nothing
else
noteby=""
end if%>
<td valign="top"><%=noteby%></td>
</tr>
<%noteby=""
rs1.movenext
loop
end if
rs1.close
set rs1=nothing%>
<%If rs("csclosed")="y" then%>
<tr>
<td colspan="4" valign="top"><%
if rs("closedby")<>"" then response.Write("<b>Closed by:</b> " & rs("closedby") & "<br /><br />")
if rs("closedcasenotes")<>"" then response.Write("<b>Closing case note:</b>  " & rs("closedcasenotes"))%></td>
</tr>
<%end if%>
<tr>
  <td valign="top">Add Photos/Videos:</td>
  <td valign="top"><label for="photos"></label>
<input name="photos" type="file" id="photos" >
<input type="file" name="photos" id="photos" >
<input type="file" name="photos" id="photos" >
<input type="file" name="photos" id="photos" >
<input type="file" name="photos" id="photos" >
<input type="file" name="photos" id="photos" >&nbsp;</td>
  <td valign="top">&nbsp;</td>
  <td valign="top">&nbsp;</td>
</tr>
<tr>
<td colspan="4" valign="top"><hr></td>
</tr>
<%If rs("csclosed")="n" then%>
<tr>
<td valign="top">Add Note</td>
<td valign="top"><textarea name="note" cols="35" rows="5" id="note" tabindex="3"></textarea></td>
<td valign="top">Follow up action date</td>
<td valign="top"><input name="followup" type="text" id="followup" tabindex="27" size="10" readonly>

<label for="dateA"></label>
<input type="hidden" name="dateA" id="dateA" value("<%=toddate%>")>
</td>
</tr>
<tr>
<td valign="top"><%if retrieveuserlocation()=1 then%>Close Case (if ticked case is closed)<%end if%></td>
<td valign="top"><p>
<%if retrieveuserlocation()=1 then%><input name="closecase" type="checkbox" id="closecase" value="y" onClick="javascript:cbClicked(this, 'closednotes_div')" >
<label for="closecase"></label>
<%end if%>
</p>
<p>

</p></td>
<td colspan="2" valign="top"><p>
<input type="hidden" name="csid" id="csid" value="<%=csid%>">
<input type="hidden" name="csnumber" id="csnumber" value="<%=rs("CSnumber")%>">
<div id="closednotes_div" style="display:none">
<p>Please describe how this case was resolved<br>
<label for="closedcasenotes"></label>
<textarea name="closedcasenotes" id="closedcasenotes" cols="50" rows="6"></textarea>
<br /><br />
Case closed by
<input name="closedby" type="text" id="closedby" tabindex="30" size="25" maxlength="255" >
</p>
<p><label for="replacementprice"></label>
Replacement Item GBP Retail Price (Inc. VAT)&nbsp; <br>
£
<input name="replacementprice" type="text" id="replacementprice" size="10">
</p>
<p>
<label for="servicecode"></label>
Please enter service code:<br>
<%Set rs1 = getMysqlQueryRecordSet("Select * from service_code", con)%>
<select name="servicecode" id="servicecode">
<option value="n">Please choose code</option>
<%do until rs1.eof%>
<option value="<%=rs1("servicecodeID")%>"><%=rs1("servicecode")%></option>
<%rs1.movenext
loop%>
</select>
<%rs1.close
set rs1=nothing%></td>
</tr>
<%end if%>
<%If rs("csclosed")="n" then%>
<tr>
<td colspan="4" align="right"><input name="submitcs" type="submit" id="submitcs" tabindex="40" value="Submit"></td>
</tr>
<%end if%>
</table>
<%If rs("csclosed")="n" then%>
</form>
<%end if%>
<p><%response.Write(toddate)%>&nbsp;</p>
<!--</form>-->
</div>
</div>
<div>
</div>

</body>
</html>
<script Language="JavaScript" type="text/javascript">
function cbClicked(cb, divName) {
if (cb.checked) {
$('#'+divName).show("fast");
} else {
$('#'+divName).hide("fast");
}
}
</script>
<%rs.close
set rs=nothing
con.close
set con=nothing%>
<script Language="JavaScript" type="text/javascript">
<!--
function IsNumeric(sText)
{
var ValidChars = "0123456789.";
var IsNumber=true;
var Char;


for (i = 0; i < sText.length && IsNumber == true; i++)
{
Char = sText.charAt(i);
if (ValidChars.indexOf(Char) == -1)
{
IsNumber = false;
}
}
return IsNumber;

}
function FrontPage_Form1_Validator(theForm)
{
if (theForm.closecase.checked == true && !IsNumeric(theForm.replacementprice.value))
{
alert("Please enter only numbers in the replacement price field");
theForm.replacementprice.focus();
return (false);
}

if (theForm.closecase.checked == true && (theForm.closedcasenotes.value == "" || theForm.closedby.value == "" || theForm.replacementprice.value == ""  || theForm.servicecode.value == "n"))
{
alert("Please enter notes, faults, replacement cost for closing case and the name of the person closing it.");
theForm.closedcasenotes.focus();
return (false);
}
//var datetod = new date(theForm.dateA.value);
//var followupDate = new date(theForm.followup.value);


if (theForm.followup.value != "") {
if (theForm.dateA.value >= theForm.followup.value) {
alert("A follow up date cannot be earlier than today's date");
theForm.followup.focus();
return (false);
}
}
return true;
}


//-->
</script>
<!-- #include file="common/logger-out.inc" -->
