
<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="aspupload.asp" -->
<!-- #include file="filefuncs.asp" -->
<%
Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, count, sql, msg, customerasc, orderasc, showr,  companyasc, bookeddate, previousOrderNumber, acknowDateWarning, csnumber, completedby, deliverdon, problemdesc, actiontaken, solution, orderno, itemdesc, firstaware, actiondate, showroom, csid, completedbyname
dim file, upload, ext, newFileName, uploadok, custname, anycomments

Server.ScriptTimeout = 18600
Set Upload = Server.CreateObject("Persits.Upload")

Upload.SetMaxSize 3145728, True
'On Error Resume Next
Upload.SaveVirtual("produploads/temp/")
uploadok=true
If Err.Number = 8 Then
	msg="Your file is too large. Please try again."
	uploadok=false
Else
	If Err <> 0 Then
		msg="An error occurred: " & Err.Description
		uploadok=false
	End If
End If
On Error GoTo 0
If uploadok then
	completedbyname=Upload.form("completedbyname")
	showroom=Upload.form("showroom")
	anycomments=Upload.form("anycomments")
	custname=Upload.form("custname")
	actiondate=Upload.form("actiondate")
	firstaware=Upload.form("firstaware")
	itemdesc=Upload.form("itemdesc")
	orderno=Upload.form("orderno")
	solution=Upload.Form("solution")
	actiontaken=Upload.Form("actiontaken")
	problemdesc=Upload.Form("problemdesc")
	deliverdon=Upload.Form("deliverdon")
	completedby=Upload.Form("completedby")
	csnumber=Upload.Form("csnumber")
	Set Con = getMysqlConnection()
	
	count=0
	
	
	
	Set rs = getMysqlUpdateRecordSet("Select * from customerservice", con)
	rs.addnew
	rs("csnumber")=csnumber
	If custname<>"" then rs("custname")=custname
	If anycomments<>"" then rs("anycomments")=anycomments
	If completedby<>"" then rs("completedby")=completedby
	If deliverdon<>"" then rs("datedelivered")=deliverdon
	If problemdesc<>"" then rs("problemdesc")=problemdesc
	If actiontaken<>"" then rs("actiontaken")=actiontaken
	If solution<>"" then rs("possiblesolution")=solution
	If orderno<>"" then rs("orderno")=orderno
	If itemdesc<>"" then rs("itemdesc")=itemdesc
	If firstaware<>"" then rs("firstawaredate")=firstaware
	If actiondate<>"" then rs("visitactiondate")=actiondate
	rs("showroom")=showroom
	rs("idlocation")=retrieveUserlocation()
	rs("idregion")=retrieveUserRegion()
	rs("dataentrydate")=date()
	rs.update
	csid=rs("csid")
	
	rs.close
	set rs=nothing
	
	For Each File in Upload.Files
		'response.write("<br>File.Name=" & File.Name)
		ext = getFileNameExtension(File.path)
		'response.write("<br>ext=" & ext)
		count = count + 1
		newFileName = "produploads/" & csnumber & "-" & count & ext
		'response.write("<br>newFileName=" & newFileName)
		call processFile(newFileName, File, true, 0, 0)
		
		Set rs = getMysqlUpdateRecordSet("Select * from customerserviceuploads", con)
		rs.AddNew
		rs("csid")=csid
		rs("prodfilename")=newfilename
		rs("dateuploaded")=date()
		rs.Update
		rs.close
		set rs=nothing
	Next
	
	set Upload = nothing
	call closeFileObjects()
	
	Dim mailmsg
	mailmsg="<html><body><font face=""Arial, Helvetica, sans-serif""><b>CUSTOMER SERVICE</b><br /><table width=""98%"" border=""1""  cellpadding=""3"" cellspacing=""0"">"
			mailmsg=mailmsg & "<tr><td>Customer Service Number & Date</td><td>" & csnumber & " - " & date() & "</td></tr>"
			mailmsg=mailmsg & "<tr><td>Form Completed by:</td><td>" & completedbyname & "</td></tr>"
			mailmsg=mailmsg & "<tr><td>Date item delivered to Customer</td><td>" & deliverdon & "</td></tr>"
			mailmsg=mailmsg & "<tr><td>Please describe the problem with the product</td><td>" &  problemdesc & "</td></tr>"
			mailmsg=mailmsg & "<tr><td>Showroom</td><td>" & showroom & "</td></tr>"
			mailmsg=mailmsg & "<tr><td>Customer Name</td><td>" & custname & "</td></tr>"
			mailmsg=mailmsg & "<tr><td>Order No</td><td>" & orderno & "</td></tr>"
			mailmsg=mailmsg & "<tr><td>Item Description</td><td>" & itemdesc & "</td></tr>"
			mailmsg=mailmsg & "<tr><td>Date customer first made you aware of the problem</td><td>" & firstaware & "</td></tr>"
			mailmsg=mailmsg & "<tr><td>Please let us know what you feel the solution to the problem is:</td><td>" & solution & "</td></tr>"
			mailmsg=mailmsg & "<tr><td>What action have you already taken about this problem:</td><td>" & actiontaken & "</td></tr>"
			mailmsg=mailmsg & "<tr><td>What date was this visit/ action:</td><td>" & actiondate & "</td></tr>"
			mailmsg=mailmsg & "<tr><td>Any other comments:</td><td>" & anycomments & "</td></tr>"
			mailmsg=mailmsg & "<tr><td>No. of documents uploaded</td><td>" & count & "</td></tr>"
			mailmsg=mailmsg & "</font></body></html>"
			
			
	call sendBatchEmail(orderno & " - Customer Service form completed", mailmsg, "noreply@savoirbeds.co.uk", "SavoirAdminCustomerService@savoirbeds.co.uk", "", "", true, con)
	con.close
	set con=nothing
end if	%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>


</head>
<body>
<div class="container">
<!-- #include file="header.asp" -->
<p align="center"><%If uploadok then%>
Thank you - the customer service report has been added - please note the case number is <%=csnumber%>
<%else%>
<%response.Write(msg & " <a href="">click here to go back to customer service form</a>")%>
<%end if%></p>
</div>
</body>
</html>
<!-- #include file="common/logger-out.inc" -->
