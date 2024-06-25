<%
sub sendEmail(aSubject, aMsg, aSender, aTo, aAttachment, aCc, aBcc)
	dim aMailObj
	Set aMailObj = CreateObject("CDO.Message")
	aMailObj.BodyPart.charset = "utf-8"
	aMailObj.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing")=2
	aMailObj.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")="127.0.0.1"
	aMailObj.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport")=25 
	aMailObj.Configuration.Fields.Update
	aMailObj.Subject = aSubject
	aMailObj.From = aSender
	If retrieveUserName()="maddy" then
		aMailObj.To = "info@natalex.co.uk"
	elseif retrieveUserName()="dave" then
		aMailObj.To = "david@natalex.co.uk"
	else
		aMailObj.To = aTo
		if aCc <> "" then
			aMailObj.CC = aCc
		end if
		if aBcc <> "" then
			aMailObj.BCC = aBcc
		end if
	end if
	aMailObj.HtmlBody = aMsg
	if aAttachment <> "" then
		aMailObj.AddAttachment aAttachment	
	end if
	aMailObj.Send
	set aMailObj=nothing	
end sub

sub sendEmailWithStringAttachment(aSubject, aMsg, aSender, aTo, aAttachmentFileName, aAttachmentString)
	dim afs, afolder, afile, aAttachment
	Set afs = Server.CreateObject("Scripting.FileSystemObject") 
	Set afolder = afs.GetSpecialFolder(2)
	Set afile = afolder.CreateTextFile(aAttachmentFileName)
	afile.WriteLine(aAttachmentString)
	afile.Close
	aAttachment = afolder & "\" & aAttachmentFileName
	set afile = nothing
	set afolder = nothing
	set afs = nothing
	call sendEmail(aSubject, aMsg, aSender, aTo, aAttachment, "", "")
end sub
%>