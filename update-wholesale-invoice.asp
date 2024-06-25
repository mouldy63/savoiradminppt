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
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="paymentfuncs.asp" -->
<!-- #include file="emailfuncs.asp" -->
<%
dim con, rs, rs1, sql, pn
dim winvoiceno, winvoicedate, 
dim scriptname2

call openLogger()
scriptname2 = "update-wholesale-invoice.asp"
call log(scriptname2, "Enter with purchase_no=" & Request("pn"))

winvoiceno = Request("winvoiceno")
winvoicedate = request("winvoicedate")
pn = Request("pn")
  
  Set Con = getMysqlConnection()
  con.begintrans ' wrap db update in a transaction
  
  sql="Select * from wholesale_invoices where purchase_no=" & pn
  Set rs = getMysqlUpdateRecordSetWithErrorLogging(sql, con)
  if rs.eof then
  	rs.AddNew
	rs("purchase_no")=pn
  else
    rs("wholesale_inv_no")=winvoiceno
	rs("wholesale_inv_date")=winvoicedate
   end if
   rs.update
end if
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
</head>

<body><iframe src="wholesale-invoice?pn=<%=pn%>&winvoiceno=<%=winvoiceno%>&&winvoicedate=<%=winvoicedate%>" width="100%" height="900"></iframe>
</body>
</html>


rs.close
set rs = nothing


' database updates done
con.committrans
con.close


response.Redirect("edit-purchase.asp?order=" & pn)
%>
<!-- #include file="common/logger-out.inc" -->
