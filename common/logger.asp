<%
const CLEANCHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
Dim aLogger, aTextFile

sub openLogger()
	dim aCleanUserName, aFileName
	aCleanUserName = cleanName(retrieveUserName())
	if aCleanUserName = "" then aCleanUserName = "default"
	aFileName = "\logs\savoirasp-" & aCleanUserName & ".log"
	on error resume next
		
		Set aLogger = CreateObject("Scripting.FileSystemObject")
		Set aTextFile = aLogger.OpenTextFile(Server.MapPath(aFileName), 8, true)
	on error goto 0
end sub

sub log(aScriptName, aMessage)
	dim aLine
	on error resume next
		aLine = now() & "    " & aScriptName & "    " & retrieveUserName() & "    " & aMessage
		aTextFile.WriteLine(aLine)
	on error goto 0
end sub

sub closeLogger()
	on error resume next
		aTextFile.close()
		set aTextFile = nothing
		set aLogger = nothing
	on error goto 0
end sub

function cleanName(aName)
	dim ai
	for ai = 1 to len(aName)
		if instr(1, CLEANCHARS, mid(aName, ai, 1), 1) <> 0 then
			cleanName = cleanName & mid(aName, ai, 1)
		end if
	next

end function
%>
