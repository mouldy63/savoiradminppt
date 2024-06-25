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
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, recordfound, id, sql, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1
msg=""
msg=Request("msg")
ddmonth=Request("month")
ddyear=Request("year")
monthfrom1=Request("monthfrom")
If monthfrom1<>"" Then
	monthfrom=year(monthfrom1) & "/" & month(monthfrom1) & "/" & day(monthfrom1)
	monthto1=Request("monthto")
	monthto=year(monthto1) & "/" & month(monthto1) & "/" & day(monthto1)
End If
found = false
For Each item In Request.Form
  ItemValue = Request.Form(Item)
  if Instr(ItemValue, "http://") then
	found = true
  End If
Next
For Each item In Request.Form
  ItemValue = Request.Form(Item)
  if Instr(ItemValue, "<") then
	found = true
  End If
Next
If found= true then response.Redirect("error.asp")

submit=Request("submit") 
'


	
Set Con = getMysqlConnection()
sql="SELECT source, COUNT(*) as cnt FROM address where status like 'Prospect'"
If monthfrom1 <> "" AND monthto1 <> "" Then 
	sql=sql &  " and first_contact_date > '" & monthfrom & "' and first_contact_date < '" & monthto & "'"
End if
If ddmonth<>"n" then
	sql=sql & " AND month(first_contact_date) = " & ddmonth & " AND year(first_contact_date) = " & ddyear & ""
end if
if not isSuperuser() then
	sql = sql & " AND owning_region=" & retrieveuserregion() & ""
	sql = sql & " AND source_site='" & retrieveUserSite() & "'"
end if
sql=sql & " GROUP BY source"
Set rs = getMysqlUpdateRecordSet(sql, con)
If submit<>"" Then 
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>
<body>
<div class="container">
<!-- #include file="header.asp" -->
	
					  <div class="content brochure">
			    <div class="one-col head-col">
			<p>Brochure Request Reports 
            <%If ddmonth <>"n" then response.Write(" for  " & monthname(ddmonth) & " "  & ddyear)
			If monthfrom1 <>"" then response.Write(" from " & monthfrom1 & " to " & monthto1)%>
            </p><p>&nbsp;</p>
                </div>


		<div class="two-col">
		  <table width="416" border="0" cellspacing="2" cellpadding="2">
		    <tr>
		      <td width="251" class="redtext">Marketing Source</td>
		      <td width="151" class="redtext">No. of Sales</td>
	        </tr>
<%response.Write("sql=" & sql)
Do until rs.eof%>		    <tr>
		      <td><%If rs("source")<>"" then response.Write(rs("source")) else response.write("Not provided")%></td>
		      <td><%=rs("cnt")%></td>
		      </tr>
           <%rs.movenext
		   loop
		%>
	      </table>
		</div>
  </div>
<div>
</div>
        </form>
</body>
</html>
<%End if
If Request("excellist")<>"" then
Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
brochuremsg="Brochure Request Reports "
            If ddmonth <>"n" then brochuremsg=brochuremsg & " for  " & monthname(ddmonth) & " "  & ddyear
			If monthfrom1 <>"" then brochuremsg=brochuremsg & " from " & monthfrom1 & " to " & monthto1
tempfile.WriteLine(brochuremsg)
tempfile.WriteLine("Source,No of Brochure Requests per Source")
Do until rs.eof
If rs("source")<>"" then strsource=rs("source") else strsource="Not provided"
excelLine = """" & strsource & """,""" & rs("cnt") &  """"
tempfile.WriteLine(excelLine)
rs.movenext
loop
rs.close
set rs=nothing

tempfile.close

Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = 1
objStream.LoadFromFile(filename)

Response.ContentType = "application/csv"
Response.AddHeader "Content-Disposition", "attachment; filename=""brochure-request-numbers.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing
end if
Con.Close
Set Con = Nothing
%>
  
<!-- #include file="common/logger-out.inc" -->
