<%

function getDBConnection()
	dim theServer, theSchema, theDbUser, theDbPassword, theConString

	if Request.ServerVariables("HTTP_HOST") <> "localhost" then
		'response.write("<br />ONLINE")
		theServer = "localhost"
		'theSchema = "savoirbedding"
		'theDbUser = "savoirbedding"
		'theDbPassword = "natty01"
		theSchema = "admin_savoirppt"
		theDbUser = "user_savoirppt"
		theDbPassword = "Gqpk79$8"
	else
		'response.write("<br />NOT ONLINE")
		theServer = "localhost"
		theSchema = "savoirbedding"
		theDbUser = "root"
		theDbPassword = "natasha94"
	end if
	theConString = "DRIVER={MySQL ODBC 3.51 Driver}; SERVER=" & theServer & "; DATABASE=" & theSchema & "; UID=" & theDbUser & ";PWD=" & theDbPassword & "; OPTION=3"
	
	'response.write("<br />" & theConString)
	'response.end
	Set getDBConnection = Server.CreateObject("ADODB.connection")
	getDBConnection.open theConString
	getDBConnection.execute("set names 'utf8'")
end function

function getQueryRecordSet(aSql, aCon)
	'response.write("<br />getQueryRecordSet sql = " & aSql)
	'response.end
	Set getQueryRecordSet = Server.CreateObject("ADODB.recordset")
	getQueryRecordSet.ActiveConnection = aCon
	getQueryRecordSet.CursorLocation = adUseClient
	getQueryRecordSet.CursorType = adOpenStatic
	getQueryRecordSet.LockType = adLockReadOnly
	getQueryRecordSet.Open aSql
end function

function getUpdateRecordSet(aSql, aCon)
	Set getUpdateRecordSet = Server.CreateObject("ADODB.recordset")
	getUpdateRecordSet.ActiveConnection = aCon
	getUpdateRecordSet.CursorLocation = adUseClient
	getUpdateRecordSet.CursorType = adOpenKeyset	'was adOpenDynamic
	getUpdateRecordSet.LockType = adLockOptimistic
	getUpdateRecordSet.Open aSql
end function


%>