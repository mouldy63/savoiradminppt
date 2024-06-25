<%
sub recordClientInfo(byref aCon, aScreenName, aClientIp, aAllowed)
	dim aGranted, aSql
	'response.write("recordClientInfo: REMOTE_ADDR=" & request.ServerVariables("REMOTE_ADDR"))
	aGranted = "n"
	if aAllowed then aGranted = "y"
	aSql = "insert into clientaccesslog (client_ip,access_timestamp,screen_name,granted) values ('" & aClientIp & "',now(),'" & aScreenName & "','" & aGranted & "')"
	aCon.execute(aSql)
end sub

function isClientAllowedAccess(byref aCon, aScreenName, aRecord)
	dim aClientIp, aSql, ars
	aClientIp = request.ServerVariables("REMOTE_ADDR")
	'response.write("isClientAllowedAccess: clientIp=" & aClientIp & ", screenName=" & aScreenName)
	aSql = "select * from clientaccess where client_ip='" & aClientIp & "' and enabled='y'"
	Set ars = getMysqlQueryRecordSet(aSql, aCon)
	isClientAllowedAccess = false
	if not ars.eof then
		isClientAllowedAccess = true
	end if
	if aRecord then
		call recordClientInfo(aCon, aScreenName, aClientIp, isClientAllowedAccess)
	end if
	'response.write("isClientAllowedAccess: allowed=" & isClientAllowedAccess)
end function
%>