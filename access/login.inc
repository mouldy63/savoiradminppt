<%
dim aUserRoles, aUser, aAllowed, arrRoles, arrAllowedRoles, aRole, aAllowedRole, aRet, aParams

dim domain
domain = Request.ServerVariables("SERVER_NAME")
if domain <> "savoiradmin.co.uk" _
	and domain <> "www.savoiradmin.co.uk" _
	and domain <> "savoiradmintest.co.uk.217-199-174-247.natalex.biz" _
	and domain <> "savoiradmintest.co.uk.94-136-44-145.natalex.co.uk" _
	and domain <> "savoiradminppt.co.uk" _
	and domain <> "www.savoiradminppt.co.uk" _
	and domain <> "draft-website.co.uk" _
	then 
	Response.Status = "403 Forbidden"
	response.end
end if

aUserRoles = retrieveUserRoles()

aAllowed = false

if aUserRoles <> "" and ALLOWED_ROLES <> "" then
	arrRoles = split(aUserRoles, ",")
	arrAllowedRoles = split(ALLOWED_ROLES, ",")
	for each aRole in arrRoles
		for each aAllowedRole in arrAllowedRoles
			if aRole = aAllowedRole then
				aAllowed = true
			end if
		next
	next
end if

If not aAllowed then
	aRet = Request.ServerVariables("SCRIPT_NAME")
	if aRet="/index.asp" or aRet="/Index.asp" or aRet="" then 
		aRet="/php/home"
	else
		aParams = Request.ServerVariables("QUERY_STRING")
		if aParams <> "" then
			aRet = aRet & "?" & aParams
		end if
	end if
	
	Response.Redirect "access/access.asp?ret=" & Server.urlEncode(aRet)
End If
%> 

