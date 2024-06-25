<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
Response.Buffer = False
Server.ScriptTimeout =122900%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, rs2, rs3, rs4, recordfound, id, sql, sql2,  sql3, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, showroomname, mattresswidth, orderNo, bedname, accsummary, orderedprod, customertype, notes, bookeddeliverydate, contactno

msg=""



if (retrieveuserid()=2) then	
Set Con = getMysqlConnection()
'sql for all contacts from a date (uses date added and firstcontactdate)
'sql="select * from contact C, Address A where C.code=A.code and is_developer='n' AND C.contact_no<>319256 AND C.contact_no<>24188 and (C.dateadded > '2021-02-21' or A.FIRST_CONTACT_DATE > '2021-02-21')"
sql="select * from contact C, Address A where C.code=A.code and is_developer='n' AND C.contact_no<>319256 AND C.contact_no > 353999 "
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
contactno=""

Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Customer No,Customer Status,Customer Type,Title,First Name,Surname,Add1,Add2,Add3,Town,Postcode,Country,Company,Email,Tel,Tel Work,Mobile,Showroom,Bed Purchase,Products Purchased,Order No.,Booked Delivery Date,Accessories,Purchase Date,Order Value ex VAT,Currency,Acceptemail")
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
sql2="select * from purchase P, location L where P.contact_no=" & rs("contact_no") & " and P.idlocation=L.idlocation and orderSource<>'Test' and (cancelled is Null or cancelled='n') and quote='n'"
Set rs1 = getMysqlQueryRecordSet(sql2, con)
if not rs1.eof then
	do until rs1.eof
	orderedprod=""
	orderNo=""
	showroomname=""
	bedname=""
	accsummary=""
	bookeddeliverydate=""
	If rs1("bookeddeliverydate") <> "" then 
		bookeddeliverydate=rs1("bookeddeliverydate")
	end if
	If rs1("baserequired")="y" then 
		bedname=rs1("basesavoirmodel")
		orderedprod=orderedprod & rs1("basesavoirmodel") & " base, "
	end if
	If rs1("mattressrequired")="y" then 
		bedname=rs1("savoirmodel")
		orderedprod=orderedprod & rs1("savoirmodel") & " mattress, "
	end if
	If rs1("topperrequired")="y" then 
		orderedprod=orderedprod & rs1("toppertype") & " topper, "
	end if
	If rs1("legsrequired")="y" then 
		orderedprod=orderedprod & " legs, "
	end if
	If rs1("headboardrequired")="y" then 
		orderedprod=orderedprod & rs1("headboardstyle") & " headboard, "
	end if
	If rs1("valancerequired")="y" then 
		orderedprod=orderedprod &  " valance, "
	end if
	if len(orderedprod)>2 then 
	orderedprod=left(orderedprod,len(orderedprod)-2)
	end if
	if rs1("accessoriesrequired")="y" then
		sql3="select * from orderaccessory where purchase_no=" & rs1("purchase_no") & ""
		Set rs2 = getMysqlQueryRecordSet(sql3, con)
		if not rs2.eof then
			do until rs2.eof
			accsummary=accsummary & rs2("description") & ", "
			rs2.movenext
			loop
		end if
		rs2.close
		set rs2=nothing
		if len(accsummary)>2 then
		accsummary=left(accsummary,len(accsummary)-2)
		end if
	end if
	
	showroomname=rs1("adminheading")
	orderNo=rs1("ORDER_NUMBER")
	excelLine = """" & contactno & """,""" & rs("status") & """,""" & customertype & """,""" & rs("title") & """,""" & rs("first") & """,""" & rs("surname") & """,""" & rs("street1") & """,""" & rs("street2") & """,""" & rs("street3") & """,""" & rs("town") & """,""" & rs("postcode") & """,""" & rs("country") & """,""" & rs("company") & """,""" & rs("email_address") & """,""" & rs("tel") & """,""" & rs("telwork") & """,""" & rs("mobile") & """,""" & showroomname & """,""" & bedname & """,""" & orderedprod & """,""" & orderNo & """,""" & bookeddeliverydate & """,""" & accsummary & """,""" & left(rs1("order_date"),10) & """,""" & rs1("totalexvat") & """,""" & rs1("ordercurrency") & """,""" & rs("acceptemail") & """"
	
	tempfile.WriteLine(excelLine)
	notes=""
	rs1.movenext
	loop

	rs1.close
	set rs1=nothing
else
orderNo=""
showroomname=""
bedname=""
excelLine = """" & contactno & """,""" & rs("status") & """,""" & customertype & """,""" & rs("title") & """,""" & rs("first") & """,""" & rs("surname") & """,""" & rs("street1") & """,""" & rs("street2") & """,""" & rs("street3") & """,""" & rs("town") & """,""" & rs("postcode") & """,""" & rs("country") & """,""" & rs("company") & """,""" & rs("email_address") & """,""" & rs("tel") & """,""" & rs("telwork") & """,""" & rs("mobile") & """,""" & showroomname & """,""" & bedname & """,""" & bedname & """,""" & orderNo & """,""" & bookeddeliverydate & """,""" & showroomname & """,""" & showroomname & """,""" & showroomname & """,""" & showroomname & """,""" & rs("acceptemail") & """"
tempfile.WriteLine(excelLine)

end if
notes=""
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
Response.AddHeader "Content-Disposition", "attachment; filename=""datadumpnew.csv"""

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
