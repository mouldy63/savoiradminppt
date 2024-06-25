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
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="generalfuncs.asp" -->
<!-- #include file="searchresults-funcs.asp" -->
<%
Response.Buffer = False
Server.ScriptTimeout = 600
Dim surname, Con, rs, recordfound, id, sql, postcode, channel, contacttype, company, sb, sh, location, orderno, recordno, qresults, pno, cref, currentorders(), comporders(), noorders(), filtertype, filterkeyword
dim currentContactIds(), completedContactIds(), nCurrentContactIds, nCompletedContactIds
cref=request("cref")
qresults=request("qresults")
location=Request("location")
sb=Request("sb")
sh=Request("sh")
orderno=Trim(Request("orderno"))
company=Trim(Request("company"))
contacttype=Trim(Request("type"))
surname=Trim(Request("surname"))
postcode=Trim(Request("postcode"))
If postcode<>"" then
	postcode=replace(postcode, " ", "")
end if
channel=Trim(Request("channel"))
filtertype=Trim(Request("filtertype"))
filterkeyword=Trim(Request("filterkeyword"))
if request("submit") = "Reset Filter" then
	filtertype = ""
	filterkeyword = ""
end if

If company<>"" and len(company)<2 then response.Redirect("search.asp?msg=c")

If surname<>"" and len(surname)<2 then response.Redirect("search.asp?msg=s")
If postcode<>"" and len(postcode)<2 then response.Redirect("search.asp?msg=p")
If company="" AND contacttype="n" and surname="" AND postcode="" AND orderno="" AND channel="n" and cref="" Then response.Redirect("search.asp?msg=n")
If company="" AND contacttype="" and surname="" AND postcode="" AND orderno="" AND channel="" and cref="" Then response.Redirect("search.asp?msg=n")

Set Con = getMysqlConnection()
if orderno <> "" then 
	Set rs = getMysqlQueryRecordSet("Select * from purchase where order_number=" & orderno, con)
	if not rs.eof then
	pno=rs("purchase_no")
	rs.close
	set rs=nothing
	response.Redirect("edit-purchase.asp?order=" & pno)
end if
end if

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
<style>
.AccordionPanel {float: left;}
.AccordionPanelTab {margin-left:5px; float:left;}
.Accordclear {clear:both;}
.stickleft {float:left;left:0px;}
.AccordionPanel table {margin-left:30px; background-color:#d4d4d4;}

</style>
</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<p>Enter a surname and / or customer reference or an order number below to search the database:
<form action="search-results.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">
				<p>
				  <label for="surname" id="surname"><strong>Surname</strong>
				    <input onChange="resetFilter()" name="surname" type="text" id="surname" value="<%=surname%>" class="text" />
			      </label> 
				 &nbsp;&nbsp;&nbsp;
				  <label for="cref" id="cref"><strong>Customer Ref.</strong>
				    <input onChange="resetFilter()" name="cref" type="text" id="cref" value="<%=cref%>" class="text" />
			      </label>
		   &nbsp;<strong>Company</strong>&nbsp;
		   <input onChange="resetFilter()" name="company" type="text" id="company" value="<%=company%>" class="text" />
		   &nbsp;
				  <label for="orderno" id="orderno"><strong>Order No.</strong>
				    <input name="orderno" type="text" class="text" id="orderno" onChange="resetFilter()" size="10" />
			      </label>
				  <input name="channel" type="hidden" value="n">
				  <input name="type" type="hidden" value="n">
				  <input name="qresults" type="hidden" value="y">
				  <input type="submit" name="submit" value="Search"  id="submit" class="button" />
		    </p>
            <hr /><br />
            <p>Filter by:</p>
            <p><select name="filtertype" id="filtertype">
              <option value="A" <%=selected(filtertype, "A")%> >Any Field</option>
              <option value="first" <%=selected(filtertype, "first")%> >First Name</option>
              <option value="company" <%=selected(filtertype, "company")%> >Company Name</option>
              <option value="add1" <%=selected(filtertype, "add1")%> >Address 1</option>
              <option value="add2" <%=selected(filtertype, "add2")%> >Address 2</option>
              <option value="add3" <%=selected(filtertype, "add3")%> >Address 3</option>
              <option value="email" <%=selected(filtertype, "email_address")%> >Email</option>
              <option value="postcode" <%=selected(filtertype, "postcode")%> >Post Code</option>
              <option value="city" <%=selected(filtertype, "city")%> >City</option>
              <option value="custref" <%=selected(filtertype, "custref")%> >Customer Reference No</option>
              <option value="channel" <%=selected(filtertype, "channel")%> >Channel</option>
              <option value="type" <%=selected(filtertype, "type")%> >Type of Contact</option>
              <option value="visited" <%=selected(filtertype, "visited")%> >Where Customer Visited</option>
              
            </select>
            &nbsp;&nbsp;&nbsp;<input name="filterkeyword" value="<%=filterkeyword%>" type="text" id="filterkeyword">
            &nbsp;&nbsp;&nbsp;<input type="submit" name="submit" value="Filter"  id="submit" class="button" />
            &nbsp;&nbsp;&nbsp;<input type="submit" name="submit" value="Reset Filter"  id="submit" class="button" />
      </p>
      </form></div>	
<form method="post" action="print.asp" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">						  <div class="content brochure">
			    <div class="one-col head-col">
			<p>You searched for <%If request("surname")<>"" Then response.Write("Surname: " & Request("surname"))%>
			<%If request("postcode")<>"" Then response.Write(" Postcode: " & Request("postcode"))%>
			<%If request("channel")<>"n" Then response.Write(" Channel: " & Request("channel"))%>
			<%If request("type")<>"n" Then response.Write(" Initial Contact type: " & Request("type"))%>
			<%If request("type")<>"n" Then response.Write(" Initial Contact type: " & Request("type"))%>
			<%If request("cref")<>"" Then response.Write(" Order Ref: " & Request("cref"))%>
            <%If request("company")<>"" Then response.Write(" Company: " & Request("company"))%>
			<%If request("location")<>"" Then response.Write(" Visited Location: " & Request("location"))%></p>
			<p class="b"> <a href="javascript:selectAll()">Select All</a>&nbsp;|
    <a href="javascript:deselectAll()">Deselect All</a>&nbsp;</p>

<%

'
' current orders customers
'
sql = getCustomersSql(con, surname, cref, postcode, company, channel, contacttype, "TRUE", filtertype, filterkeyword)
'response.Write("<br>sql=" & sql & "<br>")
'response.end
Set rs = getMysqlQueryRecordSet(sql, con)
response.Write("<div class=""greybg""><hr /><b>Customers with Current Orders = " & rs.recordcount & "</b><br / ><br / ></div>")
recordno=rs.recordcount
%>
<div id="Accordion1" class="Accordion" tabindex="0">
<%
nCurrentContactIds = 0
Do until rs.EOF
%>

  <div class="AccordionPanel">
  	<a href="javascript:void(0)" class="stickleft" onclick="getPanelContent('<%=rs("contact_no")%>', 'TRUE', '1', '<%=cref%>', '<%=filtertype%>', '<%=filterkeyword%>');" id="plus1-<%=rs("contact_no")%>"><img src="images/plus.gif" ></a>
  	<a href="javascript:void(0)" class="stickleft" onclick="closePanel('<%=rs("contact_no")%>', '1');" id="minus1-<%=rs("contact_no")%>"><img src="images/minus.gif" ></a>
    <div class="AccordionPanelTab"><%
		If rs("acceptpost")="n" Then
		response.Write("<input type=""checkbox"" disabled=""disabled"" name=""XX_" & rs("code") & """ id=""XX_" & rs("code") & """>")
		else
		response.Write("<input type=""checkbox"" name=""XX_" & rs("code") & """ id=""XX_" & rs("code") & """>")
		End If
		Response.Write("<a href=""editcust.asp?val=" & rs("contact_no") & """>")
		If rs("surname")<>"" Then Response.write(rs("surname") & ", ")
		If rs("title")<>"" Then Response.write(rs("title") & " ")
		If rs("first")<>"" Then Response.write(rs("first") & ", ")
		
		If rs("company")<>"" Then response.write(rs("company") & ", ")
		If rs("street1")<>"" Then response.write(rs("street1") & ", ")
		If rs("street2")<>"" Then response.write(rs("street2") & ", ")
		If rs("street3")<>"" Then response.write(rs("street3") & ", ")
		If rs("county")<>"" Then response.write(rs("county") & ", ")
		If rs("postcode")<>"" Then response.write(rs("postcode") & ", ")
		If rs("country")<>"" Then response.write(rs("country") & ", ")
		Response.write("</a>")
		If rs("acceptpost")="n" Then response.write(" <font color=""red"">NO MARKETING BY POST</font>")
		If rs("acceptemail")="n" Then response.write(" <font color=""red"">NO MARKETING BY EMAIL</font>")
		If rs("source_site")="SH" Then response.write(" <font color=""red"">Simon Horn Contact</font>")
		Response.write("<br />")%>
        </div><div class="Accordclear"></div>
    <div id="panel1-<%=rs("contact_no")%>" class="AccordionPanelContent"></div>
  
</div><div class="Accordclear"></div>
<%
nCurrentContactIds = nCurrentContactIds + 1
redim preserve currentContactIds(nCurrentContactIds)
currentContactIds(nCurrentContactIds) = rs("contact_no")
rs.movenext
loop
rs.close
set rs=nothing
%></div><%
'
' completed orders customers
'
sql = getCustomersSql(con, surname, cref, postcode, company, channel, contacttype, "FALSE", filtertype, filterkeyword)
'response.Write("<br>sql=" & sql & "<br>")
Set rs = getMysqlQueryRecordSet(sql, con)
response.Write("<div class=""greybg""><hr /><b>Customers with Completed Orders = " & rs.recordcount & "</b><br / ><br / ></div>")
recordno=rs.recordcount%>
<div id="Accordion2" class="Accordion" tabindex="0">
<%
nCompletedContactIds = 0
Do until rs.EOF
%>
  <div class="AccordionPanel">
  	<a href="javascript:void(0)" class="stickleft" onclick="getPanelContent('<%=rs("contact_no")%>', 'FALSE', '2', '<%=cref%>', '<%=filtertype%>', '<%=filterkeyword%>');" id="plus2-<%=rs("contact_no")%>"><img src="images/plus.gif" ></a>
  	<a href="javascript:void(0)" class="stickleft" onclick="closePanel('<%=rs("contact_no")%>', '2');" id="minus2-<%=rs("contact_no")%>"><img src="images/minus.gif" ></a>
    <div class="AccordionPanelTab">
		
		<%
		If rs("acceptpost")="n" Then
		response.Write("<input type=""checkbox"" disabled=""disabled"" name=""XX_" & rs("code") & """ id=""XX_" & rs("code") & """>")
		else
		response.Write("<input type=""checkbox"" name=""XX_" & rs("code") & """ id=""XX_" & rs("code") & """>")
		End If
		Response.Write("<a href=""editcust.asp?val=" & rs("contact_no") & """>")
		If rs("surname")<>"" Then Response.write(rs("surname") & ", ")
		If rs("title")<>"" Then Response.write(rs("title") & " ")
		If rs("first")<>"" Then Response.write(rs("first") & ", ")
		
		If rs("company")<>"" Then response.write(rs("company") & ", ")
		If rs("street1")<>"" Then response.write(rs("street1") & ", ")
		If rs("street2")<>"" Then response.write(rs("street2") & ", ")
		If rs("street3")<>"" Then response.write(rs("street3") & ", ")
		If rs("county")<>"" Then response.write(rs("county") & ", ")
		If rs("postcode")<>"" Then response.write(rs("postcode") & ", ")
		If rs("country")<>"" Then response.write(rs("country") & ", ")
		Response.write("</a>")
		If rs("acceptpost")="n" Then response.write(" <font color=""red"">NO MARKETING BY POST</font>")
		If rs("acceptemail")="n" Then response.write(" <font color=""red"">NO MARKETING BY EMAIL</font>")
		If rs("source_site")="SH" Then response.write(" <font color=""red"">Simon Horn Contact</font>")
		Response.write("<br />")%>
        </div><div class="Accordclear"></div>
    <div id="panel2-<%=rs("contact_no")%>" class="AccordionPanelContent"></div>
  </div><div class="Accordclear"></div><div class="Accordclear"></div>
<%
nCompletedContactIds = nCompletedContactIds + 1
redim preserve completedContactIds(nCompletedContactIds)
completedContactIds(nCompletedContactIds) = rs("contact_no")
rs.movenext
loop
rs.close
set rs=nothing%>
</div>
<%
'
' no orders customers (only display so long as no customer ref or filter have been provided)
'
if cref = "" and filterkeyword = "" then
	sql = getCustomersSql(con, surname, cref, postcode, company, channel, contacttype, "", filtertype, filterkeyword)
	'response.Write("<br>sql=" & sql & "<br>")
	Set rs = getMysqlQueryRecordSet(sql, con)
	response.Write("<div class=""greybg""><hr /><b>Customers with No Orders = " & rs.recordcount & "</b><br / ><br / ></div>")
	recordno=rs.recordcount%>
	<div id="Accordion3" class="Accordion" tabindex="0">
	<%Do until rs.EOF%>
	  <div class="AccordionPanel">
	    <div class="AccordionPanelTab"><%
	
			If rs("acceptpost")="n" Then
			response.Write("<input type=""checkbox"" disabled=""disabled"" name=""XX_" & rs("code") & """ id=""XX_" & rs("code") & """>")
			else
			response.Write("<input type=""checkbox"" name=""XX_" & rs("code") & """ id=""XX_" & rs("code") & """>")
			End If
			Response.Write("<a href=""editcust.asp?val=" & rs("contact_no") & """>")
			If rs("surname")<>"" Then Response.write(rs("surname") & ", ")
			If rs("title")<>"" Then Response.write(rs("title") & " ")
			If rs("first")<>"" Then Response.write(rs("first") & ", ")
			
			If rs("company")<>"" Then response.write(rs("company") & ", ")
			If rs("street1")<>"" Then response.write(rs("street1") & ", ")
			If rs("street2")<>"" Then response.write(rs("street2") & ", ")
			If rs("street3")<>"" Then response.write(rs("street3") & ", ")
			If rs("county")<>"" Then response.write(rs("county") & ", ")
			If rs("postcode")<>"" Then response.write(rs("postcode") & ", ")
			If rs("country")<>"" Then response.write(rs("country") & ", ")
			Response.write("</a>")
			If rs("acceptpost")="n" Then response.write(" <font color=""red"">NO MARKETING BY POST</font>")
			If rs("acceptemail")="n" Then response.write(" <font color=""red"">NO MARKETING BY EMAIL</font>")
			If rs("source_site")="SH" Then response.write(" <font color=""red"">Simon Horn Contact</font>")
			Response.write("<br />")%>
	        </div>
	  </div><div class="Accordclear"></div>
	  
	<%
	
	rs.movenext
	loop
	rs.close
	set rs=nothing
end if
%></div>
<input name="nobrochurealert" type="hidden" id="nobrochurealert" value="n">
<br />

          <label>Choose letter to print
            <select name="corresid" id="corresid">
               <option value="n">None</option>
                         <%
Set rs = getMysqlQueryRecordSet("Select * from correspondence WHERE owning_region=" & retrieveUserRegion() & "", con)


Do until rs.eof%>
   <option value="<%=rs("correspondenceid")%>"><%=rs("correspondencename")%></option>
   <%rs.movenext
   loop
   rs.close
   set rs=nothing
   %>
            </select>
            </label>
          <br>
          <br>
<input type="submit" name="submit2" id="submit2" value="Print Labels" onClick="setSubmitIndicator('Print Labels')">


<input type="submit" name="submit5" id="submit5" value="Print 3 x 7 Labels">
<input type="submit" name="submit1" id="submit1" value="Print Letters" onClick="setSubmitIndicator('Print Letters')">
</p>

<p>&nbsp;</p>
<p>
<%
If recordno > 15 then%>
                 <p><a href="#top" class="addorderbox">&gt;&gt; Back to Top</a></p>
<%end if%>&nbsp;</p>
                </div>


		<div class="two-col"></div>
    </div>
  </div>
<div>
</div>
        </form>
</body>
</html>
<%Con.Close
Set Con = Nothing
%>
 <script language="JavaScript">
<!--

function resetFilter() {
		$('#filtertype').val("Any Field");
		$('#filterkeyword').val("");
	}
   
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
function FrontPage_Form1_Validator(theForm)
{
 
	if (submitIndicator == "Print Letters" && theForm.corresid.value == "n")
  {
    alert("You need to choose a correspondence letter before submitting");
    theForm.corresid.focus();
    return (false);
  }

    return true;
}

var submitIndicator;
function setSubmitIndicator(ind) {
	submitIndicator = ind;
}

function getPanelContent(contactno, current, panelId, cref, filterType, filterVal) {
	var divId = "panel" + panelId + "-" + contactno;
    var url = "searchresults-orderdetails.asp?contactno=" + contactno + "&current=" + current + "&cref=" + encodeURIComponent(cref) + "&filtertype=" + encodeURIComponent(filterType) + "&filterval=" + encodeURIComponent(filterVal) + "&ts=" + (new Date()).getTime();
    //console.log(url);
    $('#' + divId).load(url);
	$('#' + divId).show("slow");
	swapOpenCloseButtons(contactno, panelId, false);
}
function closePanel(contactno, panelId) {
	var divId = "panel" + panelId + "-" + contactno;
	$('#' + divId).hide("slow");
	swapOpenCloseButtons(contactno, panelId, true);
}
function swapOpenCloseButtons(contactno, panelId, close) {
	var openBtnId = "plus" + panelId + "-" + contactno;
	var closeBtnId = "minus" + panelId + "-" + contactno;
	if (close) {
		$('#' + openBtnId).show();
		$('#' + closeBtnId).hide();
	} else {
		$('#' + openBtnId).hide();
		$('#' + closeBtnId).show();
	}
}

<%
for n = 1 to nCurrentContactIds
%>
swapOpenCloseButtons('<%=currentContactIds(n)%>', '1', true);
<%
next
%>
<%
for n = 1 to nCompletedContactIds
%>
swapOpenCloseButtons('<%=completedContactIds(n)%>', '2', true);
<%
next
%>
//-->
</script>    
<!-- #include file="common/logger-out.inc" -->

