<%
If Session ("BAuthenticated") <> "true" THEN
	Session ("nextasp") = Request.ServerVariables("SCRIPT_NAME")
	Response.Redirect "access.asp"
End If
Session.Timeout=60
%> 

