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
<!-- #include file="aspupload.asp" -->
<!-- #include file="filefuncs1.asp" -->
<%Dim  val, Con, rs, submit, sql, msg, gallerycat, id, jpgname, Upload
id=request("id")
val=request("val")
gallerycat=request("gallerycat")

Set Con = getMysqlConnection()
Set Upload = Server.CreateObject("Persits.Upload")

sql="Select * from gallery where id=" & id
Set rs = getMysqlUpdateRecordSet(sql, con)
jpgname=rs("jpgname")
rs.delete
rs.close
set rs=nothing
sql="Select * from gallerylinks where galleryid=" & id
Set rs = getMysqlUpdateRecordSet(sql, con)
do until rs.eof
rs.delete
rs.movenext
loop
rs.close
set rs=nothing
		
		call deleteFileX("C:\inetpub\vhosts\savoirbeds.co.uk\httpdocs\gallery\collections\thumb\" & jpgname & ".jpg")
		call deleteFileX("C:\inetpub\vhosts\savoirbeds.co.uk\httpdocs\gallery\collections\large\" & jpgname & ".jpg")
		
response.Redirect("gallerylist.asp?gallerycat=" & gallerycat & "")
%>

<!-- #include file="common/logger-out.inc" -->
