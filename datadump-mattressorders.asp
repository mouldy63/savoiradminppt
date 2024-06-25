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
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, rs2, rs3, recordfound, id, sql, sql2,  sql3, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, showroomname, mattresswidth, orderNo, bedname, accsummary, orderedprod, customertype
msg=""



if (retrieveuserid()=2) then	
Set Con = getMysqlConnection()
sql="SELECT P.order_number, C.surname, A.email_address, A.street1, A.street2, A.street3, A.town, A.county, A.postcode, A.country, P.totalexvat, P.savoirmodel, P.basesavoirmodel FROM purchase P, Contact C, Address A where P.code=C.Code and C.code=A.code  and (P.savoirmodel='No. 1' or P.basesavoirmodel='No. 1') and (P.ordersource<>'Stock' and P.ordersource<>'Floorstock' and P.ordersource<>'Marketing' and P.ordersource<>'Test') and (P.quote='n' or P.quote is null) and (P.cancelled<>'n' or P.cancelled is null) and P.owning_region=1 and C.acceptemail='y'"
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)


Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Order No, Surname, Email address, Address 1, Address 2, Address 3, Town, County, Postcode, Country, Total Ex Vat, Mattress, Base")
Do until rs.eof
	excelLine = """" & rs("order_number") & """,""" & rs("surname") & """,""" & rs("email_address") & """,""" & rs("street1") & """,""" & rs("street2") & """,""" & rs("street3") & """,""" & rs("town") & """,""" & rs("County") & """,""" & rs("postcode") & """,""" & rs("Country") & """,""" & rs("totalexvat") & """,""" & rs("savoirmodel") & """,""" & rs("basesavoirmodel") & """"
	
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
