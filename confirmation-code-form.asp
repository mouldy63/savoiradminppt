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
<!-- #include file="generalfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%
dim con, rs, sql, pn, orderNumber, isValid, validated, msg
set con = getMysqlConnection()

pn = request("pn")

set rs = getMysqlQueryRecordSet("select order_number from purchase where purchase_no="&pn, con)
orderNumber = rs("order_number")
closemysqlrs(rs)

validated = false
if request("button") <> "" then
	if not isempty(request("code")) and request("code") <> "" then
		isValid = validateOrderConfirmationCode(con, pn, request("code"))
		if isValid then
			call confirmOrder(con, pn, retrieveUserID())
			validated = true
			set rs = getMysqlUpdateRecordSet("select * from exportlinks where purchase_no="&pn, con)
			if rs.eof then
			else
				do until rs.eof
				 rs("orderConfirmed")="y"
				rs.movenext
				loop
		end if
		closemysqlrs(rs)
			msg = "Order " & orderNumber & " validated"
		else
			msg = "Sorry - the code you entered is not valid for order " & orderNumber
		end if
	else
		msg = "Please enter the confirmation code"
	end if
end if

closemysqlcon(con)

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Order Confirmation Code Form</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>
<script type="text/javascript">
	<% if msg <> "" then %>
		alert('<%=msg%>');
	<% end if %>
	<% if validated then 				
	%>
		window.location = "/php/AwaitingOrders";
	<% else %>
		window.location = "edit-purchase.asp?qw=y&order=<%=pn%>";
	<% end if %>
</script>
</head>
<body>
</body>
</html>
<!-- #include file="common/logger-out.inc" -->
