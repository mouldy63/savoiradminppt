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
dim pmtamt, paymentmethod, invoicedate, invoiceno, creditdetails, outstanding, receiptno, refundamt, refundmethod, paymentstotal, total
dim scriptname2

call openLogger()
scriptname2 = "updatepayments.asp"
call log(scriptname2, "Enter with purchase_no=" & Request("pn"))

paymentmethod = Request("paymentmethod")
invoicedate = request("invoicedate")
if invoicedate = "" then invoicedate = toDisplayDate(now())
  invoiceno = request("invoiceno")
  creditdetails = replaceQuotes(Request("creditdetails"))
  outstanding = ccur(Request("outstanding"))
  refundmethod = Request("refundmethod")
  pn = Request("pn")
  
  Set Con = getMysqlConnection()
  con.begintrans ' wrap db update in a transaction
  
  total = safeCur(request("total"))
  pmtamt = safeCur(request("additionalpayment"))
  refundamt = safeCur(request("refund"))
  receiptno = getNextReceiptNumber(con)
  call log(scriptname2, "pmtamt=" & pmtamt & " refundamt=" & refundamt & " receiptno=" & receiptno)
  
  If pmtamt > 0.0 then
   call addPayment(con, pn, pmtamt, paymentmethod, invoicedate, invoiceno, creditdetails, outstanding, receiptno)
  end if
  
  If refundamt > 0.0 then
   call addRefund(con, pn, refundamt, refundmethod, receiptno)
  end if
  
  sql="Select * from payment where purchase_no=" & pn
  Set rs = getMysqlUpdateRecordSetWithErrorLogging(sql, con)
  if not rs.eof then
  do until rs.eof
   if isNull(rs("invoice_number")) or rs("invoice_number")="" then
    rs("invoice_number")=request(rs("paymentid") & "invono")
   end if
   rs.update
   rs.movenext
  loop
end if

rs.close
set rs = nothing

Set rs = getMysqlUpdateRecordSetWithErrorLogging("select * from purchase where purchase_no=" & pn, con)
paymentstotal = pmtamt - refundamt
outstanding = outstanding - paymentstotal
rs("balanceoutstanding") = outstanding
if isNull(rs("paymentstotal")) then
rs("paymentstotal")=paymentstotal
else
rs("paymentstotal") = paymentstotal + CDbl(rs("paymentstotal"))
end if
rs.update
rs.close
set rs = nothing
call log(scriptname2, "paymentstotal=" & paymentstotal & " outstanding=" & outstanding)

' stuff just for exports
If request("exportchoice") <> "" then
  sql="Select L.exportLinksID from exportcollections E, exportLinks L, exportCollShowrooms S where L.purchase_no=" & pn & " and E.collectiondate='" & toUSADate(request("exportchoice")) & "' AND L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID"
  'response.Write("sql= " & sql)
  'response.End()
  Set rs = getMysqlQueryRecordSetWithErrorLogging(sql, con)
 Do until rs.eof
  Set rs1 = getMysqlUpdateRecordSetWithErrorLogging("Select * from exportLinks where exportLinksID=" & rs("exportLinksID"), con)
  rs1("invoiceNo") = invoiceno
  rs1("invoiceDate") = invoicedate
  rs1.update
  rs1.close
  set rs1=nothing
  rs.movenext
 loop
 rs.close
 set rs=nothing
end if

' database updates done
con.committrans
con.close

' get a new connection for the emails
Set Con = getMysqlConnection()

' emails
dim paymentEmailCC
paymentEmailCC = getPaymentNotificationEmailAddressForShowroom(retrieveuserlocation(), con)
call log(scriptname2, "paymentEmailCC=" & paymentEmailCC)

If pmtamt > 0.0 then
 call sendPaymentEmail(con, request("clientssurname"), request("company"), request("orderno"), request("orderCurrency"), pmtamt, getRefundMethodName(con, paymentmethod), request("ordertypename"), invoicedate, invoiceno, creditdetails, outstanding, total, request("pricelist"), receiptno, paymentEmailCC)
end if

If refundamt > 0.0 then
 call sendRefundEmail(con, request("clientssurname"), request("company"), request("orderno"), refundamt, request("orderCurrency"), getRefundMethodName(con, refundmethod), request("ordertypename"), outstanding, total, request("pricelist"), receiptno, paymentEmailCC)
end if

con.close
set con = nothing

'response.write("<br>pmtamt = " & pmtamt)
'response.write("<br>refundamt = " & refundamt)
'response.write("<br>outstanding = " & outstanding)
'response.write("<br>paymentstotal = " & paymentstotal)
response.Redirect("edit-purchase.asp?order=" & pn)
%>
<!-- #include file="common/logger-out.inc" -->
