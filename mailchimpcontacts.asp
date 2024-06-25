<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
Response.Buffer = False
Server.ScriptTimeout =1900%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, rs2, rs3, rs4, recordfound, id, sql, sql2,  sql3, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, showroomname, mattresswidth, orderNo, bedname, accsummary, orderedprod, customertype, notes
msg=""



if (retrieveuserid()=2) then	
Set Con = getMysqlConnection()
'sql for all contacts from a date (uses date added and firstcontactdate)
'sql="select * from contact C, Address A where C.code=A.code and is_developer='n' AND C.contact_no<>319256 AND C.contact_no<>24188 and (C.dateadded > '2018-12-16' or A.FIRST_CONTACT_DATE > '2018-12-16')"
sql="select * from contact2 C, Address2 A where C.code=A.code and is_developer='n' AND C.contact_no<>319256 AND C.contact_no<>24188"
'and C.contact_no>349893"
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)


Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Customer Status,Customer Type,Title,First Name,Surname,Company,street1,street2,street3,town,county,postcode,country,tel,fax,Channel,Pricelist,Email,Acceptemail,Acceptpost,Source Site")
Do until rs.eof
customertype=""
	if rs("customerType")<>"" and NOT isNull(rs("customerType")) then
		sql3="select * from customerType C where customerTypeID=" & rs("customerType")
		Set rs3 = getMysqlQueryRecordSet(sql3, con)
		if not rs3.eof then
		customertype=rs3("customerType")
		end if
		rs3.close
		set rs3=nothing
	end if
	
	excelLine = """" & rs("status") & """,""" & customertype & """,""" & rs("title") & """,""" & rs("first") & """,""" & rs("surname") & """,""" & rs("company") & """,""" & rs("street1") & """,""" & rs("street2") & """,""" & rs("street3") & """,""" & rs("town") & """,""" & rs("county") & """,""" & rs("postcode") & """,""" & rs("country") & """,""" & rs("tel") & """,""" & rs("fax") & """,""" & rs("channel") & """,""" & rs("price_list") & """,""" & rs("email_address") & """,""" & rs("acceptemail") & """,""" & rs("acceptpost") & """"
	
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
Response.AddHeader "Content-Disposition", "attachment; filename=""datadump.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing
Con.Close
Set Con = Nothing
end if
%>
  
<!-- #include file="common/logger-out.inc" -->
