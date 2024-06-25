<%
sub sendEMail(aName, aRecipient, aBody, aSubject, aSender)

	dim USECDONTS, o
	USECDONTS = application("USECDONTS")
	'response.write("<br> application('USECDONTS') = " & application("USECDONTS"))
	if USECDONTS = "" then
		USECDONTS = "true"
		on error resume next
			set o = Server.CreateObject("CDONTS.NewMail")
		if err.number <> 0 then
			USECDONTS = "false"
		end if
		'response.write("<br> USECDONTS = " & USECDONTS)
		on error goto 0
		set o = nothing
		application("USECDONTS") = USECDONTS
	end if
	
	
	if USECDONTS = "true" then
		call sendCDontsMail(aName, aRecipient, aBody, aSubject, aSender)
	else
		call sendJMail(aName, aRecipient, aBody, aSubject, aSender)
	end if
end sub

sub sendJMail(aName, aRecipient, aBody, aSubject, aSender)

	dim aMsg
	Set aMsg = Server.CreateObject("JMail.Message")

	aMsg.From = aSender
	aMsg.AddRecipient aRecipient, aName
	aMsg.Priority = 3
	aMsg.Subject = aSubject
	aMsg.Body = aBody
	aMsg.MailServerUserName = "mad@natalex"
	aMsg.MailServerPassword = "madmad39"

	'Out going SMTP mail server address
	'aMsg.Send("localhost")
	aMsg.Send("pop.natalex.co.uk")

	Set aMsg = Nothing

end sub

sub sendCDontsMail(aName, aRecipient, aBody, aSubject, aSender)

	dim objMail, aRecipients
	Set objMail = Server.CreateObject("CDONTS.NewMail")
	objMail.BodyFormat = 0
	objMail.MailFormat = 0

	objMail.From = aSender
	objMail.To = aRecipient
	objMail.Subject = aSubject

	objMail.Body = aBody
	objMail.Send
	
	set objMail = nothing

end sub
%>