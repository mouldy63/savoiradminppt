<%
dim globalConnection
set globalConnection = nothing

sub initialiseDBConnection()
    set globalConnection = Server.CreateObject("ADODB.connection")
    globalConnection.open "DRIVER=Microsoft Access Driver (*.mdb);DBQ=" & Server.MapPath(DB_FILE_NAME)
    globalConnection.begintrans
end sub

sub conExecute(aSql)
	'response.write(asql)
	'response.end
    globalConnection.execute(aSql)
end sub

function getQueryRecordSet(aSql)
	'response.write("getQueryRecordSet: aSql = " & aSql)
	'response.end
    Set getQueryRecordSet = Server.CreateObject("ADODB.recordset")
    getQueryRecordSet.ActiveConnection = globalConnection
    'getQueryRecordSet.CursorLocation = adUseClient
    getQueryRecordSet.CursorType = adOpenStatic
    getQueryRecordSet.LockType = adLockReadOnly
    getQueryRecordSet.Open aSql
end function

function getConQueryRecordSet(aSql, byref aCon)
    Set getConQueryRecordSet = Server.CreateObject("ADODB.recordset")
    getConQueryRecordSet.ActiveConnection = aCon
    'getConQueryRecordSet.CursorLocation = adUseClient
    getConQueryRecordSet.CursorType = adOpenStatic
    getConQueryRecordSet.LockType = adLockReadOnly
    getConQueryRecordSet.Open aSql
end function

function getUpdateRecordSet(aSql)
    Set getUpdateRecordSet = Server.CreateObject("ADODB.recordset")
    getUpdateRecordSet.ActiveConnection = globalConnection
    'getUpdateRecordSet.CursorLocation = adUseClient
    getUpdateRecordSet.CursorType = adOpenKeyset    'was adOpenDynamic
    getUpdateRecordSet.LockType = adLockOptimistic
    getUpdateRecordSet.Open aSql
end function

sub closeDBConnection()
    globalConnection.committrans
    globalConnection.close
    set globalConnection = nothing
end sub

sub closers(byref ars)
    ars.close
    set ars = nothing
end sub

%>