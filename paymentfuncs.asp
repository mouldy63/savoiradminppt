<%
sub addPayment(byref acon, apn, aPmtamt, aPaymentmethod, aInvoicedate, aInvoiceno, aCreditdetails, aOutstanding, aReceiptNo)
	dim aPaymentExists, ars
	Set ars = getMysqlUpdateRecordSet("Select * from payment where purchase_no=" & apn, acon)
	aPaymentExists = not ars.eof
	ars.AddNew
	ars("amount") = aPmtamt
	ars("salesusername") = retrieveUserName()
	ars("paymentmethodid") = aPaymentmethod
	if aOutstanding > 0.0 then
		ars("paymenttype") = "Additional Payment"
	elseif aPaymentExists then
		ars("paymenttype") = "Final Payment"
	else
		ars("paymenttype") = "Full Payment"
	end if
	ars("purchase_no") = apn
	ars("invoicedate") = aInvoicedate
	ars("invoice_number") = aInvoiceno
	ars("placed") = toDbDateTime(now)
	ars("receiptno") = aReceiptNo
	if aCreditdetails <> "" then ars("creditdetails") = aCreditdetails
	ars.update
	ars.close
	set ars = nothing
end sub

sub sendPaymentEmail(byref acon, aClientssurname, aCompany, aOrderNo, aOrderCurrency, aPmtamt, aPaymentmethodname, aOrdertypename, aInvoicedate, aInvoiceno, aCreditdetails, aOutstanding, aTotal, aPricelist, aReceiptno, aPaymentEmailCC)
	dim ars, aTo, aCc, aBcc, aLocationname, aAccountsubject, aAccountsmsg
	Set ars = getMysqlQueryRecordSet("Select * from location where idlocation=" & retrieveuserlocation(), acon)
	aLocationname=ars("location")
	call closeRs(ars)

	aAccountsubject=aClientssurname 
	If aCompany <>"" then aAccountsubject=aAccountsubject  & " - " &  aCompany 
	aAccountsubject=aAccountsubject & " - " & aOrderNo & " - " & aOrderCurrency & fmtCurrNonHtml(aPmtamt, false, "") & " - " & aPaymentmethodname
	aAccountsmsg="<html><body><font face=""Arial, Helvetica, sans-serif""><b>CUSTOMER PAYMENT</b><br /><table width=""98%"" border=""1""  cellpadding=""3"" cellspacing=""0"">"
	aAccountsmsg=aAccountsmsg & "<tr><td>Order Type</td><td>" & aOrdertypename & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Payment Amount</td><td>" & fmtCurr2(aPmtamt, true, aOrderCurrency) & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Invoice Date</td><td>" & aInvoicedate & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Invoice No:</td><td>" & aInvoiceno & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Payment Type</td><td>" & aPaymentmethodname & "</td></tr>"
	if aCreditdetails <> "" then
		aAccountsmsg=aAccountsmsg & "<tr><td>Credit Details</td><td>" & aCreditdetails & "</td></tr>"
	end if
	aAccountsmsg=aAccountsmsg & "<tr><td>Customer Surname</td><td>" &  aClientssurname & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Company</td><td>" & aCompany & "&nbsp;</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Order No</td><td>" & aOrderNo & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Amount Outstanding on this order</td><td>" & fmtCurr2(aOutstanding, true, aOrderCurrency) & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Order Total Amount</td><td>" & fmtCurr2(aTotal, true, aOrderCurrency) & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Payment Source</td><td>" & aLocationname & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Price List</td><td>" & aPricelist & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Receipt No.</td><td>" & aReceiptno & "</td></tr>"
		
	aAccountsmsg=aAccountsmsg & "</font></body></html>"
	
	If retrieveUserName()="maddy" then
		aTo = "info@natalex.co.uk"
	elseif retrieveUserRegion()=17 or retrieveUserRegion()=19 then
		aTo ="Pv@savoirbeds.co.uk,da@savoirbeds.co.uk"
	elseif retrieveUserName()="dave" then
		aTo = "david@natalex.co.uk"
	else
		aTo = "SavoirAdminAccounts@savoirbeds.co.uk"
	end if
	if aPaymentEmailCC <> "" then
		aCc = aPaymentEmailCC
	end if
	aBcc = "david@natalex.co.uk"

	call sendBatchEmail(aAccountsubject, aAccountsmsg, "noreply@savoirbeds.co.uk", aTo, "", aCc, true, con)
end sub

function getRefundMethodName(byref acon, aRefundmethod)
	dim asql, ars
	asql="Select * from paymentmethod WHERE paymentmethodid=" & aRefundmethod
	Set ars = getMysqlQueryRecordSet(asql, acon)
	getRefundMethodName=ars("paymentmethod")
	ars.close
	set ars=nothing
end function

sub addRefund(byref acon, apn, aRefundAmt, aRefundmethod, aReceiptNo)
	dim ars
	Set ars = getMysqlUpdateRecordSet("Select * from payment where purchase_no=" & apn, acon)
	ars.AddNew
	ars("amount") = aRefundAmt * -1.0
	ars("salesusername") = retrieveUserName()
	ars("paymentmethodid") = aRefundmethod
	ars("paymenttype") = "Refund"
	ars("purchase_no") = apn
	ars("placed") = toDbDateTime(now)
	ars("receiptno")=aReceiptNo
	ars.update
	ars.close
	set ars = nothing
end sub

sub sendRefundEmail(byref acon, aClientssurname, aCompany, aOrderno, aRefundAmt, aOrderCurrency, aRefundmethodname, aOrdertypename, aOutstanding, aTotal, aPricelist, aRefundreceiptno, aPaymentEmailCC)
	dim ars, aTo, aCc, aBcc, aLocationname, aAccountsubject, aAccountsmsg
	Set ars = getMysqlQueryRecordSet("Select * from location where idlocation=" & retrieveuserlocation(), acon)
	aLocationname=ars("location")
	call closeRs(ars)

	aAccountsubject=aClientssurname 
	If aCompany <>"" then aAccountsubject=aAccountsubject  & " - " &  aCompany 
	aAccountsubject=aAccountsubject & " - " & aOrderno & " - " & aOrderCurrency & fmtCurrNonHtml(aRefundAmt, false, "") & " - " & aRefundmethodname
	aAccountsmsg="<html><body><font face=""Arial, Helvetica, sans-serif""><b>CUSTOMER REFUND</b><br /><table width=""98%"" border=""1""  cellpadding=""3"" cellspacing=""0"">"
	aAccountsmsg=aAccountsmsg & "<tr><td>Order Type</td><td>" & aOrdertypename & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Refund Amount</td><td>" & fmtCurr2(aRefundAmt, true, aOrderCurrency) & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Refund Type</td><td>" & aRefundmethodname & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Customer Surname</td><td>" &  aClientssurname & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Company</td><td>" & aCompany & "&nbsp;</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Order No</td><td>" & aOrderno & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Amount Outstanding on this order</td><td>" & fmtCurr2(aOutstanding, true, aOrderCurrency) & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Order Total Amount</td><td>" & fmtCurr2(aTotal, true, aOrderCurrency) & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Refund Source</td><td>" & aLocationname & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Price List</td><td>" & aPricelist & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "<tr><td>Refund Receipt No.</td><td>" & aRefundreceiptno & "</td></tr>"
	aAccountsmsg=aAccountsmsg & "</font></body></html>"

	If retrieveUserName()="maddy" then
		aTo = "info@natalex.co.uk"
	elseif retrieveUserRegion()=17 or retrieveUserRegion()=19 then
		aTo ="Pv@savoirbeds.co.uk,da@savoirbeds.co.uk"
	elseif retrieveUserName()="dave" then
		aTo = "david@natalex.co.uk"
	else
		aTo = "SavoirAdminAccounts@savoirbeds.co.uk"
	end if
	if aPaymentEmailCC <> "" then
		aCc = aPaymentEmailCC
	end if

	call sendBatchEmail(aAccountsubject, aAccountsmsg, "noreply@savoirbeds.co.uk", aTo, "", aCc, true, con)
end sub
%>