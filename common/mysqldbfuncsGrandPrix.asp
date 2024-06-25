<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%

function getMysqlConnection()
	dim theServer, theSchema, theDbUser, theDbPassword, theConString

	
		theServer = "localhost"
		theSchema = "admin_DGPdb89X"
		theDbUser = "DGPdb9X50A"
		theDbPassword = "7*OsNiw[fAn!S(1"

	theConString = "DRIVER={MySQL ODBC 3.51 Driver}; SERVER=" & theServer & "; DATABASE=" & theSchema & "; UID=" & theDbUser & ";PWD=" & theDbPassword & "; OPTION=3"
	
	'response.write("<br>" & theConString)
	'response.end
	Set getMysqlConnection = Server.CreateObject("ADODB.connection")
	getMysqlConnection.open theConString
	getMysqlConnection.execute("set names 'utf8'")
end function

function getMysqlQueryRecordSet(aSql, aCon)
	'response.write("<br>getQueryRecordSet sql = " & aSql)
	'response.end
	Set getMysqlQueryRecordSet = Server.CreateObject("ADODB.recordset")
	getMysqlQueryRecordSet.ActiveConnection = aCon
	getMysqlQueryRecordSet.CursorLocation = adUseClient
	getMysqlQueryRecordSet.CursorType = adOpenStatic
	getMysqlQueryRecordSet.LockType = adLockReadOnly
	on error resume next
		getMysqlQueryRecordSet.Open aSql
	if err.number <> 0 then
		response.write("<br>Error=" & err.description)
		response.end
	end if
	on error goto 0
end function

function getMysqlUpdateRecordSet(aSql, aCon)
	Set getMysqlUpdateRecordSet = Server.CreateObject("ADODB.recordset")
	getMysqlUpdateRecordSet.ActiveConnection = aCon
	getMysqlUpdateRecordSet.CursorLocation = adUseClient
	getMysqlUpdateRecordSet.CursorType = adOpenKeyset	'was adOpenDynamic
	getMysqlUpdateRecordSet.LockType = adLockOptimistic
	on error resume next
		getMysqlUpdateRecordSet.Open aSql
	if err.number <> 0 then
		response.write("<br>Error=" & err.description)
		response.end
	end if
	on error goto 0
end function

sub closemysqlrs(byref ars)
	ars.close
	set ars = nothing
end sub

sub closemysqlcon(byref acon)
	acon.close
	set acon = nothing
end sub

function toMysqlDate(byref aStrDate)
	dim aDate
	aDate = cdate(aStrDate)
	toMysqlDate = year(aDate) & "-" & month(aDate) & "-" & day(aDate)
end function

function escapeQuotes(byref val)
	if isnull(val) or val = "" then
		escapeQuotes = ""
	else
		escapeQuotes = replace(trim(val), "'", "''")
	end if
end function

function convertBoolean(byref astr)
	dim abool
	if isnull(astr) or astr = "" then
		convertBoolean = 0
	else
		abool = cbool(astr)
		if abool then
			convertBoolean = 1
		else
			convertBoolean = 0
		end if
	end if
end function

function defaultString(byref astr, byref adefault)
	if isnull(astr) or astr = "" then
		defaultString = adefault
	else
		defaultString = astr
	end if
end function

function defaultInt(byref astr, byref adefault)
	if isnull(astr) or astr = "" then
		defaultInt = adefault
	else
		defaultInt = cint(astr)
	end if
end function

function safeBool(byref astr)
	if isnull(astr) or astr = "" then
		safeBool = false
	elseif lcase(astr) = "y" or lcase(astr) = "yes" or lcase(astr) = "true" or lcase(astr) = "1" then
		safeBool = true
	else
		safeBool = false
	end if
end function

function isColNull(byref ars, aColName)
	isColNull = isnull(ars(aColName)) or isempty(ars(aColName))
end function
%>