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
'sql="select * from contact C, Address A where C.code=A.code and is_developer='n' AND C.contact_no<>319256 AND C.contact_no<>24188 and (C.dateadded > '2020-04-04' or A.FIRST_CONTACT_DATE > '2020-04-04')"
sql="select * from contact C, Address A where C.code=A.code and is_developer='n' AND C.contact_no<>319256 AND C.contact_no<>24188 and C.contact_no>2776"
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)


Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Title,First Name,Surname,Company,Add1,Add2,Add3,Town,County,Postcodee,Country,Email,Showroom,Bed Purchase,Products Purchased,Order No.,Accessories,Purchase Date,Order Value ex VAT,Currency")
Do until rs.eof
sql2="select * from purchase P, location L where P.contact_no=" & rs("contact_no") & " and P.idlocation=L.idlocation and orderSource<>'Test' and orderSource<>'Marketing' and (cancelled is Null or cancelled='n')"
Set rs1 = getMysqlQueryRecordSet(sql2, con)
if not rs1.eof then
	do until rs1.eof
	orderedprod=""
	orderNo=""
	showroomname=""
	bedname=""
	accsummary=""
	If rs1("baserequired")="y" then 
		bedname=rs1("basesavoirmodel")
		orderedprod=orderedprod & rs1("basesavoirmodel") & " base "
	end if
	If rs1("mattressrequired")="y" then 
		bedname=rs1("savoirmodel")
		orderedprod=orderedprod & rs1("savoirmodel") & " mattress "
	end if
	If rs1("topperrequired")="y" then 
		orderedprod=orderedprod & rs1("toppertype") & " topper "
	end if
	If rs1("legsrequired")="y" then 
		orderedprod=orderedprod & " legs "
	end if
	If rs1("headboardrequired")="y" then 
		orderedprod=orderedprod & rs1("headboardstyle") & " headboard "
	end if
	If rs1("valancerequired")="y" then 
		orderedprod=orderedprod &  " valance "
	end if
	if rs1("accessoriesrequired")="y" then
		sql3="select * from orderaccessory where purchase_no=" & rs1("purchase_no") & ""
		Set rs2 = getMysqlQueryRecordSet(sql3, con)
		if not rs2.eof then
			do until rs2.eof
			accsummary=accsummary & rs2("description") & " "
			rs2.movenext
			loop
		end if
		rs2.close
		set rs2=nothing
	end if
	
	showroomname=rs1("adminheading")
	orderNo=rs1("ORDER_NUMBER")
	excelLine = """" & rs("title") & """,""" & rs("first") & """,""" & rs("surname") & """,""" & rs("company") & """,""" & rs("street1") & """,""" & rs("street2") & """,""" & rs("street3") & """,""" & rs("town") & """,""" & rs("county") & """,""" & rs("postcode") & """,""" & rs("country") & """,""" & rs("email_address") & """,""" & showroomname & """,""" & bedname & """,""" & orderedprod & """,""" & orderNo & """,""" & accsummary & """,""" & left(rs1("order_date"),10) & """,""" & rs1("totalexvat") & """,""" & rs1("ordercurrency") & """"
	
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
excelLine = """" & rs("title") & """,""" & rs("first") & """,""" & rs("surname") & """,""" & rs("company") & """,""" & rs("street1") & """,""" & rs("street2") & """,""" & rs("street3") & """,""" & rs("town") & """,""" & rs("county") & """,""" & rs("postcode") & """,""" & rs("country") & """,""" & rs("email_address") & """,""" & showroomname & """,""" & bedname & """,""" & bedname & """,""" & orderNo & """,""" & showroomname & """,""" & showroomname & """,""" & showroomname & """,""" & showroomname & """"
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
