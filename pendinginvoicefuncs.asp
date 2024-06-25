<%
sub addPendingInvoice(byref acon, apn, aInvoicedate, aInvoiceno)
	dim ars
	Set ars = getMysqlUpdateRecordSet("Select * from pending_invoicenos", acon)
	ars.AddNew
	ars("salesusername") = retrieveUserName()
	ars("purchase_no") = apn
	ars("invoice_date") = aInvoicedate
	ars("invoice_no") = aInvoiceno
	ars("placed") = toDbDateTime(now)
	ars.update
	ars.close
	set ars = nothing
end sub

function getFinalInvoiceNo(byref acon, apn)
	dim aResult(2)
	aResult(1) = ""
	aResult(2) = ""
	dim ars
	Set ars = getMysqlQueryRecordSet("select invoice_no,invoice_date from final_invoicenos where purchase_no=" & apn, acon)
	if not ars.eof then
		aResult(1) = ars("invoice_no")
		aResult(2) = ars("invoice_date")
	end if
	ars.close
	set ars = nothing
	getFinalInvoiceNo = aResult
end function
%>
