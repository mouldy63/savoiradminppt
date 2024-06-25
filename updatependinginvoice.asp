<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="generalfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="paymentfuncs.asp" -->
<!-- #include file="pendinginvoicefuncs.asp" -->
<!-- #include file="emailfuncs.asp" -->
<%
dim con, rs, rs1, sql, pn, depositradio
dim pmtamt, paymentmethod, invoicedate, invoiceno, creditdetails, outstanding, receiptno, refundamt, refundmethod, paymentstotal, total
dim scriptname

call openLogger()
scriptname = "updatependinginvoice.asp"
call log(scriptname, "Enter with purchase_no=" & Request("pn"))

invoicedate = request("invoicedate")
if invoicedate = "" then invoicedate = toDisplayDate(now())
  invoiceno = request("invoiceno")
  pn = Request("pn")
  depositradio=Request("depositradio")
  Set Con = getMysqlConnection()
  con.begintrans ' wrap db update in a transaction
if depositradio<>"" then    
   call addPendingInvoice(con, pn, invoicedate, invoiceno)
end if  

' database updates done
con.committrans
con.close

response.Redirect("edit-purchase.asp?order=" & pn)
%>
