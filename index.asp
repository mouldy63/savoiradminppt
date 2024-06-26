<%Option Explicit%>
<%Response.Buffer = False%>
<%
response.redirect("/php/home")
response.end

dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES,WEBSITEADMIN"
dim orderexists, Con, rs, rs1, rs2, sql, contactno, outstandingTotal, noteslink, overdueclass, todaysdate, closeordernote, dtchangeorderid, dtdate, correschange, corrclose, strresponse
strresponse=""
corrclose=""
correschange=""
dtchangeorderid=""
dtdate=""
dtchangeorderid=request("dtchange")
dtdate=request("dtdate")
todaysdate=day(now()) & "/" & month(now()) & "/" & year(now())
outstandingTotal=0
contactno=""
orderexists=""
orderexists=Request("orderexists")
closeordernote=""
closeordernote=request("close")
correschange=request("correschange")
corrclose=request("corrclose")
strresponse=request("name")

%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="emailfuncs.asp" -->
<!-- #include file="customer_service_followup_email.asp" -->
<%
' send out the customer service warning emails
if not isTestSystem() then
	call sendCustomerServiceFollowupEmails()
	call sendDeliveryBookedBalanceOutstandingNotificationEmails()
end if
Set Con = getMysqlConnection()


if correschange<>"" then
	sql="Select * from communication where communication=" & correschange
	
  Set rs = getMysqlUpdateRecordSet(sql, con)
  rs("next")=dtdate
  rs.update
rs.close
set rs=nothing
end if

if dtchangeorderid<>"" then
	sql="Select * from ordernote where ordernote_id=" & dtchangeorderid
	
  Set rs = getMysqlUpdateRecordSet(sql, con)
  rs("followupdate")=dtdate
  rs.update
rs.close
set rs=nothing
end if

if corrclose<>"" then
	sql="Select * from communication where communication=" & corrclose
	
  Set rs = getMysqlUpdateRecordSet(sql, con)
  rs("commstatus")="Completed"
  rs("staff")=retrieveUserName()
  rs("commCompletedBy")=retrieveUserName()
  rs("completeddate")=now()
  rs("response")=strresponse & "<br />" & retrieveUserName() & "<br />" & now() & "<br /><br />" & rs("response")
  rs.update
rs.close
set rs=nothing
end if
if closeordernote<>"" then
	sql="Select * from ordernote where ordernote_id=" & closeordernote
	
  Set rs = getMysqlUpdateRecordSet(sql, con)
  rs("action")="Completed"
  rs("noteCompletedBy")=retrieveUserName()
  rs("noteCompletedDate")=now()
  rs.update
rs.close
set rs=nothing
end if

%>
<!doctype html>
<html lang="en">

<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="css/jquery-confirm.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script type="text/javascript" src="https://code.jquery.com/jquery-3.1.1.js"></script>
<script src="scripts/keepalive.js"></script>
<script src="SpryAssets/SpryCollapsiblePanel.js" type="text/javascript"></script>
<link href="SpryAssets/SpryCollapsiblePanel2.css" rel="stylesheet" type="text/css">
  <script type="text/javascript" src="js/jquery.powertip.js"></script>
	<link rel="stylesheet" type="text/css" href="css/jquery.powertip.css" />
<style type="text/css">
.overdue {
	background-color:rgba(255,0,0,0.1);}
  .arrow {
    width: 70px;
    height: 16px;
    overflow: hidden;
    position: absolute;
    left: 50%;
    margin-left: -35px;
    bottom: -16px;
  }
  .arrow.top {
    top: -16px;
    bottom: auto;
  }
  .arrow.left {
    left: 20%;
  }
  .arrow:after {
    content: "";
    position: absolute;
    left: 20px;
    top: -20px;
    width: 25px;
    height: 25px;
    box-shadow: 6px 5px 9px -9px black;
    -webkit-transform: rotate(45deg);
    -ms-transform: rotate(45deg);
    transform: rotate(45deg);
  }
  .arrow.top:after {
    bottom: -20px;
    top: auto;
  }
  .jconfirm.jconfirm-white .jconfirm-box, .jconfirm.jconfirm-light .jconfirm-box {
	  font-family:"Trebuchet MS",Arial,Verdana,San serif !important;
	  margin-right:40% !important;
	  }
.jconfirm.jconfirm-white .jconfirm-box .jconfirm-buttons button.btn-default, .jconfirm.jconfirm-light .jconfirm-box .jconfirm-buttons button.btn-default {
	font-size:14px !important;}
.jconfirm.jconfirm-white .jconfirm-box .jconfirm-buttons, .jconfirm.jconfirm-light .jconfirm-box .jconfirm-buttons {
	float:none !important;
	text-align:center !important;
	font-size:12px !important;
	font-style:normal !important;}
.jconfirm .jconfirm-box .jconfirm-buttons button {
	font-size:12px !important;}
.jconfirm .jconfirm-box div.jconfirm-title-c {font-size:14px !important;}
.colFR {width:40%; float:right;}
.colFL {width:59%; float:left;}
.CollapsiblePanelOpen .CollapsiblePanelTab {
    background-color: #eee;
    background-image: url("/images/minusL.gif");
    background-position: 2px 10px;
    background-repeat: no-repeat;
    height: 20px;
    margin-left: 0;
    padding: 10px;
	text-indent:10px;
}
.CollapsiblePanelClosed .CollapsiblePanelTab {
    background-image: url("/images/plusL.gif");
    background-position: 2px 10px;
    background-repeat: no-repeat;
    height: 20px;
    margin-left: 0;
    padding: 10px;
	text-indent:10px;
}
.bedworks {width:70%;
margin: 0 auto;
}
#powerTip {
    max-width: 300px;
    padding: 10px;
    position: absolute;
	white-space:normal;
    z-index: 2147483647;
  </style>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">

<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.0.3/jquery-confirm.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.0.3/jquery-confirm.min.js"></script>
</head>

<body>
<div class="container">

<!-- #include file="header.asp" -->

<%if retrieveUserRegion()=1 and (retrieveUserLocation()=3 or retrieveUserLocation()=4 or retrieveUserLocation()=36 or retrieveUserLocation()=39) then%>
<div class="colFR">  
<div id="CollapsiblePanel1" class="CollapsiblePanel">

  <%
  sql="Select SUM(P.balanceoutstanding) as n from purchase P, contact C WHERE P.contact_no=C.contact_no and (C.contact_no<>319256 and C.contact_no<>24188 and C.retire<>'y') and P.idlocation=" & retrieveUserLocation() & " and (P.cancelled is null or P.cancelled <>'y')  and P.orderonhold<>'y' and P.completedorders='n' AND P.bookeddeliverydate is not NULL and P.balanceoutstanding > 0 order by P.bookeddeliverydate asc"
  Set rs = getMysqlQueryRecordSet(sql, con)
  if not rs.eof then
  outstandingTotal=rs("n")
  end if
  rs.close
  set rs=nothing%>
  
<%sql="Select * from purchase P, contact C WHERE P.contact_no=C.contact_no and (C.contact_no<>319256 and C.contact_no<>24188 and C.retire<>'y') and P.idlocation=" & retrieveUserLocation() & " and (P.cancelled is null or P.cancelled <>'y')  and P.orderonhold<>'y' and P.completedorders='n' AND P.bookeddeliverydate is not NULL and P.balanceoutstanding > 0 order by P.bookeddeliverydate asc"
  Set rs = getMysqlQueryRecordSet(sql, con)
  if not rs.eof then
  'if retrieveUserRegion()=1 and retrieveUserLocation()<>1 then%>

    <div class="CollapsiblePanelTab" tabindex="0">Payments to be Collected</div>
    <div class="CollapsiblePanelContent">
   <table width="100%" border="0" cellspacing="0" cellpadding="3">
  <tr>
    <td>Delivery Date</td>
    <td>Order No.</td>
    <td>Customer Name</td>
    <td>Balance Outstanding</td>
  </tr>
  <%Do until rs.eof
	Set rs1 = getMysqlQueryRecordSet("Select * from contact WHERE code=" & rs("code") & "", con)
	%>
  <tr>
    <td><%=rs("bookeddeliverydate")%></td>
    <td><%response.Write("<a href=""edit-purchase.asp?order=" & rs("purchase_no") & """>" & rs("order_number") & "</a>")%></td>
    <td><%response.Write("<a href=""editcust.asp?val=" & rs1("contact_no") & """>" & rs1("title") & " " & rs1("surname") & "</a>")%></td>
    <td><%response.Write(fmtCurr2(rs("balanceoutstanding"), true, rs("ordercurrency")))%></td>
  </tr>
  <%rs1.close
	set rs1=nothing
	rs.movenext
	loop
	%>
    <tr><td></td><td></td><td><b>TOTAL</b></td><td><%response.Write("<b>£" & outstandingTotal & "</b>")%></td></tr>
</table>
  </div>
  <%end if
  rs.close
	set rs=nothing
  %>
    
 
</div>
</div>
<%end if%>

<%Set rs = getMysqlQueryRecordSet("Select * from location WHERE idlocation=" & retrieveUserLocation(), con)
if not rs.eof and rs("SavoirOwned")="y" then
if retrieveUserRegion()=1 and (retrieveUserLocation()=3 or retrieveUserLocation()=4 or retrieveUserLocation()=36 or retrieveUserLocation()=39) then%>
<div class="colFL">
<%else%>
<div class="bedworks">
<%end if%>

<div id="CollapsiblePanel2" class="CollapsiblePanel">
	<div class="CollapsiblePanelTab" tabindex="0">Outstanding Tasks</div>
    <div class="CollapsiblePanelContent">
   <table border="0" align="center" cellpadding="11" cellspacing="0">
   <tr><td colspan="6">	ORDER NOTES</td></tr>
  <tr>
    <td>Task&nbsp;Due&nbsp;Date</td>
    <td>Order No.</td>
    <td>Customer Name</td>
    <td>Created By</td>
    <td>Description</td>
    <td>Status</td>
  </tr>

  <%sql="Select O.ordernote_id, O.followupdate, A.company, P.order_number, P.quote, O.purchase_no, A.code, A.tel, C.surname, C.title, C.first, C.Contact_no, A.email_address, C.telwork, C.mobile, O.username,O.notetext from ordernote O, purchase P, Contact C, Address A, savoir_user U WHERE O.purchase_no=P.purchase_no and P.contact_no=C.contact_no and U.username=O.username and  action='To Do'"
if retrieveUserLocation=1 or retrieveUserLocation=27 then 
sql=sql & " and O.username='" & retrieveUserName() & "'"
else
sql=sql & " and P.idlocation='" & retrieveUserLocation() & "' and (U.id_location<>27 and U.id_location<>1)"
end if
sql=sql & " and C.code=A.code order by followupdate asc"
'response.Write(sql)
  Set rs1 = getMysqlQueryRecordSet(sql, con)
  
  if retrieveUserLocation=1 then
  noteslink="orderdetails.asp?pn="
  else
  noteslink="edit-purchase.asp?order="
  end if
  Do until rs1.eof
  	if rs1("followupdate")<>"" then
		if CDate(rs1("followupdate"))<CDate(todaysdate) then overdueclass="overdue" else overdueclass=""
	end if
	%>
  <tr class="<%=overdueclass%>">
    <td valign="top">
    <script>
$(function() {
$( "#datechange<%=rs1("ordernote_id")%>" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy',
onSelect: function () {
                var date = $("#datechange<%=rs1("ordernote_id")%>").val();
				window.location.assign('index.asp?dtdate=' + date + '&dtchange=<%=rs1("ordernote_id")%>');
            }
});
$( "#datechange<%=rs1("ordernote_id")%>" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});
</script><input name = "datechange<%=rs1("ordernote_id")%>" type = "text" placeholder="Date change" class = "text" id = "datechange<%=rs1("ordernote_id")%>" value = "<%=rs1("followupdate")%>" size = "10" style="background-color:transparent; border:none;" />
    </td>
	
    <td valign="top">
	<%if rs1("quote")="y" then%>
	<a href="<%response.Write("edit-purchase.asp?quote=y&order=" & rs1("purchase_no"))%>"><%=rs1("order_number")%></a>
	<%else%>
	<a href="<%response.Write(noteslink & rs1("purchase_no"))%>"><%=rs1("order_number")%></a>
	<%end if%>
	</td>
    <td valign="top"><div id="tip2<%=rs1("code")%>"><div title="Mouse follow">
	<%if rs1("quote")="y" then%>
	<a href="<%response.Write("editcust.asp?val=" & rs1("contact_no"))%>"><%response.write(rs1("surname") & "," & rs1("title") & " " & rs1("first"))%></a><%if rs1("company")<>"" then response.Write("<br /><font size=""1px"">(" & rs1("company") & ")</font>")%>
	<%else%>
	<a href="<%response.Write(noteslink & rs1("purchase_no"))%>"><%response.write(rs1("surname") & "," & rs1("title") & " " & rs1("first"))%></a><%if rs1("company")<>"" then response.Write("<br /><font size=""1px"">(" & rs1("company") & ")</font>")%>
	<%end if%>
	</div></div></td>
    <td valign="top">
	<%if rs1("quote")="y" then%>
	<a href="<%response.Write("edit-purchase.asp?quote=y&order=" & rs1("purchase_no"))%>"><%=rs1("username")%></a>
	<%else%>
	<a href="<%response.Write(noteslink & rs1("purchase_no"))%>"><%=rs1("username")%></a>
	<%end if%>
	</td>
    <td valign="top"><div id="tip<%=rs1("ordernote_id")%>"><div title="Mouse follow"><a href="<%response.Write(noteslink & rs1("purchase_no"))%>">
	<%if len(rs1("notetext"))>20 then
	response.Write(left(rs1("notetext"),17) & "...")
	else
	response.Write(rs1("notetext"))
	end if%></a></div></div>
	</td>
	
    <td valign="top"><button class="close<%=rs1("ordernote_id")%> btn btn-primary"><img src="images/green-button.png" width="20" height="20"></button>
    <script type="text/javascript">
                                $('.close<%=rs1("ordernote_id")%>').on('click', function () {
                                    $.confirm({
                                        title: 'Would you like to complete this task',
                                        content: '',
                                        buttons: {
                                            yes: function () {
                                                window.location.assign('index.asp?close=<%=rs1("ordernote_id")%>');
                                            },
                                            no: function () {
                                            }
                                        }
                                    });
                                });
                            </script></td>
  </tr>
 
  <script type="text/javascript">
		$(function() {
			// mouse-on example
			var mouseOnDiv = $('#tip<%=rs1("ordernote_id")%> div');
			var tipContent = $(
				'<p><%=rs1("notetext")%></p>'
			);
			mouseOnDiv.data('powertipjq', tipContent);
			mouseOnDiv.powerTip({
				placement: 'e',
				mouseOnToPopup: true
			});
		});
		$(function() {
			// mouse-on example
			var mouseOnDiv = $('#tip2<%=rs1("code")%> div');
			var tipContent = $(
				'<p><%response.write(rs1("First") & " " & rs1("surname") & "<br />Tel: " & rs1("tel") & "<br />Tel Work: " & rs1("telwork") & "<br />Mobile : " & rs1("mobile") & "<br /><a href=""mailto:" & rs1("email_address") & """><font color=white>Email: " & rs1("email_address") & "</</font></a>")%></p>'
			);
			mouseOnDiv.data('powertipjq', tipContent);
			mouseOnDiv.powerTip({
				placement: 'e',
				mouseOnToPopup: true
			});
		});
	</script>
  <%rs1.movenext
	loop
	rs1.close
	set rs1=nothing  

sql="Select O.Communication, O.next, A.company, O.code, O.response, A.code, A.tel, C.surname, C.title, C.first, A.email_address, C.telwork, C.mobile, O.staff, O.notes, C.Contact_no from communication O, Contact C, Address A, savoir_user U WHERE O.code=C.code and O.staff=U.username and commstatus='To Do'"
if retrieveUserLocation()=1 or retrieveUserLocation=27 then
sql=sql & " and O.staff='" & retrieveUserName() & "'"
else
sql=sql & " and C.idlocation='" & retrieveUserLocation() & "' and (U.id_location<>27 and U.id_location<>1)"
end if
sql=sql &  " and C.code=A.code order by O.next asc"

  Set rs2 = getMysqlQueryRecordSet(sql, con)
   
  if rs2.eof then
  else%>
  <tr><td colspan="6">	CUSTOMER NOTES</td></tr>
  <%Do until rs2.eof
  if rs2("next")<>"" then
	if CDate(rs2("next"))<CDate(todaysdate) then overdueclass="overdue" else overdueclass=""
  end if
	%>
  <tr class="<%=overdueclass%>">
    <td valign="top"><script>
$(function() {
$( "#datechange2<%=rs2("communication")%>" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy',
onSelect: function () {
                var date = $("#datechange2<%=rs2("communication")%>").val();
				window.location.assign('index.asp?dtdate=' + date + '&correschange=<%=rs2("communication")%>');
            }
});
$( "#datechange2<%=rs2("communication")%>" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});
</script>
<input name = "datechange2<%=rs2("communication")%>" type = "text" placeholder="Date change" class = "text" id = "datechange2<%=rs2("communication")%>" value = "<%=rs2("next")%>" size = "10" style="background-color:transparent; border:none;"  />
    </td>
    <td valign="top">-</td>
    <td valign="top"><div id="tip4<%=rs2("communication")%>"><div title="Mouse follow"><a href="<%response.Write("editcust.asp?tab=4&val=" & rs2("contact_no"))%>"><%response.write(rs2("surname") & "," & rs2("title") & " " & rs2("first"))%></a><%if rs2("company")<>"" then response.Write("<br /><font size=""1px"">(" & rs2("company") & ")</font>")%></div></div></td>
    <td valign="top"><a href="<%response.Write("editcust.asp?tab=4&val=" & rs2("contact_no"))%>"><%=rs2("staff")%></a></td>
    <td valign="top"><div id="tip3<%=rs2("communication")%>"><div title="Mouse follow"><a href="<%response.Write("editcust.asp?tab=4&val=" & rs2("contact_no"))%>">
	<%if len(rs2("response"))>20 then
	response.Write(left(rs2("response"),17) & "...")
	elseif rs2("response")="" and len(rs2("notes"))>20 then
	response.Write(left(rs2("notes"),17) & "...")
	else
	response.Write(rs2("response") & " " & rs2("notes"))
	end if%></a></div></div>
	</td>
    <td valign="top"><button class="close<%=rs2("communication")%> btn btn-primary"><img src="images/green-button.png" width="20" height="20"></button>
    <script type="text/javascript">
                                $('.close<%=rs2("communication")%>').on('click', function () {
									$.confirm({
                                        title: 'Would you like to complete this task',
                                        content: '',
                                        buttons: {
                                            yes: function () {
												$.confirm({
												title: 'Would you like to complete this task',
												content: '' +
												'<form action="" class="formName">' +
												'<div class="form-group">' +
												'<label>You need to enter a response before completing this task:</label>' +
												'<textarea placeholder="Response" class="name form-control" required />' +
												'</div>' +
												'</form>',
												buttons: {
													formSubmit: {
														text: 'Submit',
														btnClass: 'btn-blue',
														action: function () {
															var name = this.$content.find('.name').val();
															
															if(!name){
																$.alert('provide a valid response');
																return false;
															}
															$.alert('Your response is ' + name);
															window.location.assign('index.asp?corrclose=<%=rs2("communication")%>&name=' + name);
														}
													},
													cancel: function () {
														//close
													},
												},
												onContentReady: function () {
													// bind to events
													var jc = this;
													this.$content.find('form').on('submit', function (e) {
														// if the user submits the form by pressing enter in the field.
														e.preventDefault();
														jc.$$formSubmit.trigger('click'); // reference the button and click it
													});
												}
											});
                                
                                            },
                                            no: function () {
                                            }
                                        }
                                    });
                                });
                            </script></td>
  </tr>
  
 
  
  <script type="text/javascript">
		$(function() {
			// mouse-on example
			var mouseOnDiv = $('#tip3<%=rs2("communication")%> div');
			var tipContent = $(
				'<p><%=rs2("response")%><%=rs2("notes")%></p>'
			);
			mouseOnDiv.data('powertipjq', tipContent);
			mouseOnDiv.powerTip({
				placement: 'e',
				mouseOnToPopup: true
			});
		});
		$(function() {
			// mouse-on example
			var mouseOnDiv = $('#tip4<%=rs2("code")%> div');
			var tipContent = $(
				'<p><%response.write(rs2("First") & " " & rs2("surname") & "<br />Tel: " & rs2("tel") & "<br />Tel Work: " & rs2("telwork") & "<br />Mobile : " & rs2("mobile") & "<br /><a href=""mailto:" & rs2("email_address") & """><font color=white>Email: " & rs2("email_address") & "</</font></a>")%></p>'
			);
			mouseOnDiv.data('powertipjq', tipContent);
			mouseOnDiv.powerTip({
				placement: 'e',
				mouseOnToPopup: true
			});
		});
	</script>
  <%
	rs2.movenext
	loop
	end if
	rs2.close
	set rs2=nothing
	
	%>
    
</table>
  </div></div>
</div>
</div>
<%rs.close
set rs=nothing
end if%>
<script type="text/javascript">
var CollapsiblePanel1 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel1");
</script>
<script type="text/javascript">
var CollapsiblePanel2 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel2");
</script>
</body>
</html>
<%Con.close
set Con=nothing%>
 <script Language="JavaScript" type="text/javascript">
<!--
function FrontPage_Form1_Validator(theForm)
{
 
   if ((theForm.surname.value == "") && (theForm.orderno.value == "") && (theForm.company.value == "") && (theForm.cref.value == ""))
  {
    alert("Please complete one of the fields to obtain results");
    theForm.surname.focus();
    return (false);
  }

if ((theForm.surname.value != "") && (theForm.surname.value.length <2))
  {
    alert("Surname needs to be at least 2 characters long");
    theForm.surname.focus();
    return (false);
  }

    return true;
} 

//-->
</script>
 
<!-- #include file="common/logger-out.inc" -->
