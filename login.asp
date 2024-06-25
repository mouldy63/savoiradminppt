<% option explicit %>
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<%Dim Connect, rs, Query, membership, nextasp, user, password, ObjConn, strvalue, con

Function RemoveChars() 
  dim frm,item,val
  Set frm = Server.CreateObject("Scripting.Dictionary") 
  frm.CompareMode=1    ' mode 1 = text
  For each Item in Request.Form
  	val = Replace(Request.Form(Item),">","&gt;") 
  	val = Replace(val,"<","&lt;") 
    frm.Add Cstr(Item), val
  Next 
  Set RemoveChars = frm 
End Function 

dim myform
Set myform = RemoveChars()  ' replace < with null
' Open Database Connection
Set Con = getMysqlConnection()
Set rs = getMysqlQueryRecordSet("Select * from Pass", con)

user = TRIM(myform("username"))
password = TRIM(myform("password"))
nextasp = ""

Do While (nextasp = "" And Not rs.EOF)
	If user = rs("username") AND password = rs("password")  THEN
		Session ("BAuthenticated") = "true"
		nextasp = "index.asp"
		If TRIM(nextasp) = "" THEN
			nextasp = "index.asp"
		End If
    	Session ("nextasp") = ""
		
	End If
	rs.MoveNext
Loop

if (nextasp = "") Then
	nextasp = "access.asp?failed=true"
else
	nextasp = "index.asp" ' trying to take the user back to a half complete form doesn't work, so this is better
End If

Response.Redirect nextasp
%>

