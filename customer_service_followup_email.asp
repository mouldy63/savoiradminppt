<%
sub sendCustomerServiceFollowupEmails()
	dim ars, asql, adate, acon, aLastChecked, adiff, amsg, amail, aTo
	set acon = getMysqlConnection()

	asql = "select value from comreg where name='CUSTOMERSERVICEWARNINGEMAILLASTCHECKED'"
	set ars = getMysqlQueryRecordSet(asql, acon)
	aLastChecked = cdate(ars("value"))
	call closemysqlrs(ars)
	
	adiff = DateDiff("d", aLastChecked, now())
	'response.write("<br>adiff = " & adiff)
	if adiff <1 then
		exit sub
	end if
	
	adate = toMysqlDate(now())
	'asql = "select * from customerservice where csclosed='n' and followupdate < '" & adate & "'"
	' followupdate removed at Daryls request 21/11/13 
	asql = "select * from customerservice where csclosed='n'"
	'response.write("<br>asql = " & asql)
	set ars = getMysqlQueryRecordSet(asql, acon)

	amsg="<html><body><font face=""Arial, Helvetica, sans-serif""><b>Overdue Customer Service Issues</b><br/><br/>"
	
	if not ars.eof then
		amsg=amsg & "<table width=""98%"" border=""1""  cellpadding=""3"" cellspacing=""0"">"
		amsg=amsg & "<tr><td>Customer Service No.</td><td>Showroom</td><td>Customer Service Date</td><td>Customer Name</td><td>Problem Description</td><td>Being Handled By</td></tr>"
		while not ars.eof
			amsg=amsg & "<tr><td>"&ars("csnumber")&"</td><td>"&ars("showroom")&"&nbsp;</td><td>"&ars("dataentrydate")&"</td><td>"&ars("custname")&"&nbsp;</td><td>"&ars("problemdesc")&"&nbsp;</td><td>"&ars("savoirstaffresolvingissue")&"&nbsp;</td></tr>"
			ars.movenext
		wend
		amsg=amsg & "</table>"
	else
		amsg=amsg & "There are no outstanding customer service issues today."
	end if

	amsg=amsg & "</font></body></html>"

	call closemysqlrs(ars)
	
	call sendBatchEmail("Overdue customer service issues", amsg, "noreply@savoirbeds.co.uk", "SavoirAdminCustomerService@savoirbeds.co.uk", "", "david@natalex.co.uk", true, acon)

	asql = "update comreg set value='" & adate & "' where name='CUSTOMERSERVICEWARNINGEMAILLASTCHECKED'"
	acon.execute(asql)

	call closemysqlcon(acon)
end sub


sub sendDeliveryBookedBalanceOutstandingNotificationEmails()
	dim ars, ars2, asql, adate, acon, aLastChecked, adiff, amsg, amail, anrows
	set acon = getMysqlConnection()

	asql = "select value from comreg where name='DELIVERYBOOKEDBALANCEOUTSTANDINGNOTIFICATIONMAILLASTCHECKED'"
	set ars = getMysqlQueryRecordSet(asql, acon)
	aLastChecked = cdate(ars("value"))
	call closemysqlrs(ars)
	
	adiff = DateDiff("d", aLastChecked, now())
	'response.write("<br>adiff = " & adiff)
	if adiff <1 then
		exit sub
	end if
	
	' all uk showrooms except bedworks
	asql = "select * from location where idlocation <> 1 and owning_region=1 and (retire is null or retire='n')"
	Set ars = getMysqlQueryRecordSet(asql, acon)
	while not ars.eof
		asql = "Select * from purchase p join contact c on p.contact_no=c.contact_no"
		asql = asql & " join address a on a.code=c.code"
		asql = asql & " where p.idlocation=" & ars("idlocation") & " and (p.cancelled is null or p.cancelled <>'y')  and p.orderonhold<>'y' and p.completedorders='n' AND p.bookeddeliverydate is not NULL and p.balanceoutstanding > 0 order by p.bookeddeliverydate asc"
		'response.write("<br>asql=" & asql)
		Set ars2 = getMysqlQueryRecordSet(asql, acon)
	
		anrows = 0
		if not ars2.eof then
		
			amsg= "<html><body><font face=""Arial, Helvetica, sans-serif""><p>The following orders have been allocated a delivery date, however there is a balance outstanding. Please collect the payment to clear the balance.</p><p>This is an automatic email sent from Savoir Admin to " & ars("email") & "</p></font>"
			amsg=amsg & "<table cellpadding=4><tr><td>Delivery Date</td><td>Order No.</td><td>Customer Name</td><td>Company</td><td>Balance Outstanding</td></tr>"
			while not ars2.eof
				amsg=amsg & "<tr><td>" & ars2("bookeddeliverydate") & "</td><td>" & ars2("order_number") & "</td><td>" & ars2("title") & " " & ars2("surname") & "</td><td>" & ars2("company") & "</td><td align=""right"">" & fmtCurr2(ars2("balanceoutstanding"), true, ars2("ordercurrency")) & "</td></tr>"
				ars2.movenext
				anrows = anrows + 1
			wend
			call closemysqlrs(ars2)
	
			amsg=amsg & "</table>"
			call sendBatchEmail("Orders with delivery date and outstanding balance", amsg, "noreply@savoirbeds.co.uk", ars("email"), "", "", true, acon)
			
		end if
		'response.write("<br>rows for location " & ars("idlocation") & " = " & anrows)
	
		ars.movenext
	wend
	call closemysqlrs(ars)

	' update comreg	
	adate = toMysqlDate(now())
	asql = "update comreg set value='" & adate & "' where name='DELIVERYBOOKEDBALANCEOUTSTANDINGNOTIFICATIONMAILLASTCHECKED'"
	acon.execute(asql)

	call closemysqlcon(acon)
end sub

%>