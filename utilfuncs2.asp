<%
const VALIDCHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 &-'@,."

function isselected(firstval, secondval)
	isselected = ""
	if not isNull(firstval) and not isNull(secondval) then
		if cstr(firstval) = cstr(secondval) then
			isselected = " selected "
		end if
	end if
end function

function cleanForDb(byval astr)
	cleanForDb = cleanForDbImpl(astr, true)
end function

function cleanForDbNotQuotes(byval astr)
	cleanForDbNotQuotes = cleanForDbImpl(astr, false)
end function

function cleanForDbImpl(byval astr, byval aReplaceQuotes)

	dim ai
	cleanForDbImpl = ""
	astr = trim(astr)
	
	for ai = 1 to len(astr)
		if instr(1, VALIDCHARS, mid(astr, ai, 1), 1) <> 0 then
			cleanForDbImpl = cleanForDbImpl & mid(astr, ai, 1)
		end if
	next

	cleanForDbImpl = replace(cleanForDbImpl, "insert ", "insrt ", 1, 99, 1)
	cleanForDbImpl = replace(cleanForDbImpl, "update ", "updte ", 1, 99, 1)
	cleanForDbImpl = replace(cleanForDbImpl, "delete ", "delte ", 1, 99, 1)
	cleanForDbImpl = replace(cleanForDbImpl, "drop ", "drp ", 1, 99, 1)
	cleanForDbImpl = replace(cleanForDbImpl, "select ", "slect ", 1, 99, 1)
	cleanForDbImpl = replace(cleanForDbImpl, "--", "", 1, 99, 1)
	cleanForDbImpl = replace(cleanForDbImpl, "xp_", "", 1, 99, 1)
	if aReplaceQuotes then
		cleanForDbImpl = replace(cleanForDbImpl, "'", "''")
	end if

end function

function replaceQuotes(byval astr)
	replaceQuotes = replace(astr, "'", "''")
end function
%>