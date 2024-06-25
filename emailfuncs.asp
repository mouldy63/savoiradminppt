<%
sub sendBatchEmail(aSubject, aMsg, aSender, aTo, aAttachment, aCc, aIsHtml, byref acon)
	dim ars
	on error resume next
		If retrieveUserName()="maddy" then
			aTo = "info@natalex.co.uk"
			aCc = ""
		elseif retrieveUserName()="dave" then
			aTo = "david@natalex.co.uk"
			aCc = ""
		end if
		
		Set ars = getMysqlUpdateRecordSet("select * from batchemail", acon)
		ars.AddNew
		
		ars("to") = aTo
		if not isnull(aCc) and aCc <> "" then
			ars("cc") = aCc
		end if
		ars("from") = aSender
		ars("subject") = aSubject
		if not isnull(aMsg) and aMsg <> "" then
			ars("body") = aMsg
		end if
		if aIsHtml then
			ars("format") = "html"
		end if
		if aAttachment <> "" then
			ars("attachment") = aAttachment
		end if
	
		ars.Update
		ars.close
		set ars=nothing
	if err.number <> 0 then
		call log(scriptname, "emailfuncs.asp.sendBatchEmail: error=" & err.description)
	end if
	on error goto 0
end sub

sub sendBatchEmailWithStringAttachment(aSubject, aMsg, aSender, aTo, aAttachmentFileName, aAttachmentString, aCc, aIsHtml, byref acon)
	dim afs, afolder, afile, aAttachment
	on error resume next
		Set afs = Server.CreateObject("Scripting.FileSystemObject") 
		Set afolder = afs.GetSpecialFolder(2)
		Set afile = afolder.CreateTextFile(aAttachmentFileName)
		afile.WriteLine(aAttachmentString)
		afile.Close
		aAttachment = afolder & "\" & aAttachmentFileName
		set afile = nothing
		set afolder = nothing
		set afs = nothing
	if err.number <> 0 then
		call log(scriptname, "emailfuncs.asp.sendBatchEmailWithStringAttachment: error=" & err.description)
	end if
	on error goto 0
	call sendBatchEmail(aSubject, aMsg, aSender, aTo, aAttachment, aCc, aIsHtml, acon)
end sub
%>