<%
Dim DB_FILE_NAME
DB_FILE_NAME = "../../data/stanbridge.mdb"

function getDBConnection()
	Set getDBConnection = Server.CreateObject("ADODB.connection")
	getDBConnection.Open "DRIVER=Microsoft Access Driver (*.mdb);DBQ=" & Server.MapPath(DB_FILE_NAME)
end function

function getQueryRecordSet(aSql, aCon)
	Set getQueryRecordSet = Server.CreateObject("ADODB.recordset")
	getQueryRecordSet.ActiveConnection = aCon
	'getQueryRecordSet.CursorLocation = adUseClient
	getQueryRecordSet.CursorType = adOpenStatic
	getQueryRecordSet.LockType = adLockReadOnly
	getQueryRecordSet.Open aSql
end function

function getUpdateRecordSet(aSql, aCon)
	Set getUpdateRecordSet = Server.CreateObject("ADODB.recordset")
	getUpdateRecordSet.ActiveConnection = aCon
	'getUpdateRecordSet.CursorLocation = adUseClient
	getUpdateRecordSet.CursorType = adOpenKeyset	'was adOpenDynamic
	getUpdateRecordSet.LockType = adLockOptimistic
	getUpdateRecordSet.Open aSql
end function


%>