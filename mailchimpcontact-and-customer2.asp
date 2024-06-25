<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
Response.Buffer = False
Server.ScriptTimeout =82900%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, rs2, rs3, rs4, recordfound, id, sql, sql2,  sql3, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, showroomname, mattresswidth, orderNo, bedname, accsummary, orderedprod, customertype, notes, bookeddeliverydate, contactno, orderdate

msg=""



if (retrieveuserid()=2) then	
Set Con = getMysqlConnection()
'sql for all contacts from a date (uses date added and firstcontactdate)
'sql="select * from contact C, Address A where C.code=A.code and is_developer='n' AND C.contact_no<>319256 AND C.contact_no<>24188 and (C.dateadded > '2021-09-13' or A.FIRST_CONTACT_DATE > '2021-09-13')"
sql="SELECT * FROM contact C, Address A, Location L WHERE C.code=A.code and C.idlocation = L.idlocation and C.is_developer='n' AND C.contact_no<>319256 AND C.contact_no<>24188 and C.contact_no <332398 and (C.owning_region=4 OR C.OWNING_REGION=12 or C.OWNING_REGION=13 or C.OWNING_REGION=14 or C.idlocation=49)                                                                                                                                                   "
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
contactno=""

Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("First,Last Name,Company,Email Address,Order Date (if ordered),Showroom (if ordered),Owning Showroom,Customer Type,Price List")
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
	bookeddeliverydate=""
	contactno=rs("contact_no")
	orderdate=""
	showroomname=""

sql2="select * from purchase P, location L where P.contact_no=" & rs("contact_no") & " and P.idlocation=L.idlocation and orderSource<>'Test' and orderSource<>'Marketing' and (cancelled is Null or cancelled='n') and quote='n' and P.order_date > '2016-12-31' and P.order_date < '2021-01-02'"
Set rs1 = getMysqlQueryRecordSet(sql2, con)
if not rs1.eof then

	do until rs1.eof
	orderdate=orderdate & rs1("ORDER_DATE") & " "
	showroomname=showroomname & rs1("adminheading") & ": "
	rs1.movenext
	loop
	rs1.close
	set rs1=nothing
	
excelLine = """" & rs("first") & """,""" & rs("surname") & """,""" & rs("company") & """,""" & rs("email_address") & """,""" & orderdate & """,""" & showroomname & """,""" & rs("adminheading") & """,""" & customertype & """,""" & rs("price_list") & """"
tempfile.WriteLine(excelLine)

end if





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
