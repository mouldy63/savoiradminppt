<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,WEBSITEADMIN"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%  Response.Buffer = True
  Response.ExpiresAbsolute = Now() - 1
  Response.Expires = 0
  Response.CacheControl = "no-cache"

Dim Connect, rs, Query, Con, toddate, valueid, valueret, formfield, strcatid, gallerycat, sql
gallerycat=request("gallerycat")
valueid=Request("valueid")
valueret=Request("valueret")
toddate=Now() %>
<%
' Open Database Connection
Set Con = getMysqlConnection()
sql="Select * from gallery G, gallerylinks C where G.id=C.galleryid and C.gallerycat=" & gallerycat & " and G.website='y' order by G.priority"
Set rs = getMysqlQueryRecordSet(sql, con)
Do until rs.EOF

For Each formfield in Request.Form

	if left(formfield,2)="RC" Then
	'response.Write(right(formfield,len(formfield)-2))
	'response.End()
	If CLng(right(formfield,len(formfield)-2)) = CLng(rs("id")) then
	sql="update gallery set priority=" & CLng(request.form(formfield)) & " where id=" & rs("id")
	Con.execute(sql)
		'rs("priority")=CLng(request.form(formfield))
	'Response.Write(formfield & "<br>")
	end if
    End If
Next 
rs.movenext
loop

rs.Close
Set rs = Nothing
Con.Close
Set Con = Nothing
Response.Redirect("gallerylist.asp?gallerycat=" & gallerycat & "&val=y")
%>
<!-- #include file="common/logger-out.inc" -->
