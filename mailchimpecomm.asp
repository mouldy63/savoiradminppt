<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
Response.Buffer = False
Server.ScriptTimeout =832900%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, rs2, rs3, rs4, recordfound, id, sql, sql2,  sql3, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, showroomname, mattresswidth, orderNo, bedname, accsummary, orderedprod, customertype, notes, bookeddeliverydate, contactno, matt1width, matt2width, matt1length, matt2length, base1width, base2width, base1length, base2length, basedrawerconfigid, mattinstructions, topperinstructions, speclegheight, ordertype, accdesc, accdesign, acccolour, accsize, accprice, accqty, accdeliverydate,vattext,accpodate,accsupplier,accponumber,accsi,accqtytofollow,acctarrif,firstorderdate

msg=""



if retrieveuserid()<>2 and retrieveuserid()<>1 then
	response.end
end if

Set Con = getMysqlConnection()
sql="select contact_no,firstweborder,firstorder from ("
sql = sql & " select p.contact_no,"
sql = sql & " (select min(p1.order_date) from purchase p1 where (p1.order_number like '500%' or p1.customerreference like '%web order%') and p1.contact_no=p.contact_no) as firstweborder,"
sql = sql & " (select min(p2.order_date) from purchase p2 where p2.contact_no=p.contact_no) as firstorder"
sql = sql & " from purchase p where p.contact_no <> '24188' and p.contact_no <> '331595'"
sql = sql & " and p.orderonhold<>'y' and (p.cancelled is Null or p.cancelled='n')"
sql = sql & " ) x where x.firstweborder is not null && x.firstweborder <= x.firstorder"

Set rs = getMysqlQueryRecordSet(sql, con)

Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Contact No.,Surname,Company,Email Address,Order Number,Order Date,Customer Ref,Order Source")

Do until rs.eof
	sql="SELECT P.contact_no, surname, company, email_address, order_number, order_date, customerreference, ordersource from purchase P, contact C, Address A WHERE P.contact_no=C.contact_no and C.CODE=A.CODE and P.contact_no =" & rs("contact_no") & " and p.orderonhold<>'y' and (p.cancelled is Null or p.cancelled='n')"
	Set rs2 = getMysqlQueryRecordSet(sql, con)
	Do until rs2.eof
		excelLine = """" & rs2("contact_no") & """,""" & rs2("surname") & """,""" & rs2("company") & """,""" & rs2("email_address") & """,""" & rs2("order_number") & """,""" & rs2("order_date") & """,""" & rs2("customerreference") & """,""" & rs2("OrderSource") & """"
		tempfile.WriteLine(excelLine)
		rs2.movenext
	loop
	rs2.close
	set rs2=nothing

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

%>
  
<!-- #include file="common/logger-out.inc" -->
