<%Response.Expires = 0
Response.ExpiresAbsolute = Now - 10
Response.AddHeader "pragma", "no-cache"
Response.AddHeader "cache-control", "private"
Response.CacheControl = "no-cache"

Response.Write Session("sessionvalue1") & ";" & _
	Session("sessionvalue2") & ";" & _
	Session("sessionvalue3") & ";" & _
	Session("sessionvalue4")
%>