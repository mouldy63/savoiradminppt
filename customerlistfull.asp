<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
Response.Buffer = False
Server.ScriptTimeout =900%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, recordfound, id, sql, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, regionname
Dim status
msg=""
msg=Request("msg")
ddmonth=Request("month")
ddyear=Request("year")
monthfrom1=Request("monthfrom")
status = Request("status")
If monthfrom1<>"" Then
	monthfrom=year(monthfrom1) & "/" & month(monthfrom1) & "/" & day(monthfrom1)
	monthto1=Request("monthto")
	monthto=year(monthto1) & "/" & month(monthto1) & "/" & day(monthto1)
	monthto=DateAdd("d",1,monthto)
	monthto=year(monthto) & "/" & month(monthto) & "/" & day(monthto)
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
sql="SELECT * from contact C, address A, location AS e where C.source_site='SB' AND c.code=a.code AND  C.idlocation=e.idlocation "
If status<>"" then
	sql=sql & " AND a.status='" & status & "'"
end if
If monthfrom1 <> "" AND monthto1 <> "" Then 
	sql=sql &  " and first_contact_date >= '" & monthfrom & "' and first_contact_date < '" & monthto & "'"
End if
If ddmonth<>"n" then
	sql=sql & " AND month(first_contact_date) = " & ddmonth & " AND year(first_contact_date) = " & ddyear & ""
end if
if not isSuperuser() then
	sql = sql & " AND C.owning_region=" & retrieveuserregion() & ""
	sql = sql & " AND C.idlocation=" & retrieveuserlocation() & ""
	sql = sql & " AND C.source_site='" & retrieveUserSite() & "'"
end if
sql=sql & " order by c.surname"
'response.Write(sql)
'response.End()
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
			<p>Customers 
            <%If ddmonth <>"n" then response.Write(" for  " & monthname(ddmonth) & " "  & ddyear)
			If monthfrom1 <>"" then response.Write(" from " & monthfrom1 & " to " & monthto1)%>
            </p><p>&nbsp;</p>
                </div>


		
  </div>
<div>
</div>
        </form>
</body>
</html>
<%End if
If Request("excellist")<>"" then
Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
brochuremsg="Customers "
            If ddmonth <>"n" then brochuremsg=brochuremsg & " for  " & monthname(ddmonth) & " "  & ddyear
			If monthfrom1 <>"" then brochuremsg=brochuremsg & " from " & monthfrom1 & " to " & monthto1
tempfile.WriteLine(brochuremsg)
tempfile.WriteLine("Original Alpha Name,Owning Showroom,Title,Firstname,Surname,Company,Address1,Address2,Address3,Town,County,Postcode,Country,Tel,Email,Status,Visit date,Source,Channel,Visit Date,Last Order Date,Accept Email,Accept Post,First Contact date")
Do until rs.eof
sql="Select * from purchase where code=" & rs("code") & " order by order_date desc"
'response.Write("sql=" & sql)
'response.End()
orderdt=""
Set rs1 = getMysqlUpdateRecordSet(sql, con)
If not rs1.eof then

	If isNull(rs1("order_date")) or rs1("order_date")="" then
		orderdt=""
		else
		orderdt=rs1("order_date")
	end if
end if
rs1.close
set rs1=nothing 
'regionname=""
'sql="Select * from region where id_region=" & rs("owning_region") & ""
'Set rs1 = getMysqlUpdateRecordSet(sql, con)
'regionname=rs1("name")
'rs1.close
'set rs1=nothing
excelLine = """" & rs("alpha_name") & """,""" & rs("location") & """,""" & rs("title") & """,""" & rs("first") &  """,""" & rs("surname") &  """,""" & rs("Company") &  """,""" & rs("street1") &  """,""" & rs("street2") &  """,""" & rs("street3") &  """,""" & rs("town") &  """,""" & rs("county") &  """,""" & rs("postcode") &  """,""" & rs("country") &  """,""" & rs("tel") &  """,""" & rs("email_address") &  """,""" & rs("status") &  """,""" & rs("visit_date") &  """,""" & rs("source") &  """,""" & rs("channel") &  """,""" & rs("visit_date") &  """,""" & orderdt &  """,""" & rs("acceptemail") &  """,""" & rs("acceptpost") &  """,""" & rs("first_contact_date") &  """"
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
