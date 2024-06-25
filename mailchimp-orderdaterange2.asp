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
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, rs2, rs3, rs4, recordfound, id, sql, sql2,  sql3, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, showroomname, mattresswidth, orderNo, bedname, accsummary, orderedprod, customertype, notes, bookeddeliverydate, contactno, wholeorderstatus, mattorderstatus, mattdeliverydate, basedeliverydate, baseorderstatus, topperdeliverydate, topperorderstatus, hbdeliverydate, hborderstatus, legdeliverydate, legorderstatus, valancedeliverydate, valanceorderstatus, accdeliverydate, accorderstatus, mattspec, mattresslength, matt2width, matt2length, matt1width, matt1length, mattwidthstring
msg=""


if (retrieveuserid()=2) then	
Set Con = getMysqlConnection()
'sql for all contacts from a date (uses date added and firstcontactdate)
'sql="select * from contact C, Address A where C.code=A.code and is_developer='n' AND C.contact_no<>319256 AND C.contact_no<>24188 and (C.dateadded > '2021-02-21' or A.FIRST_CONTACT_DATE > '2021-02-21')"
sql="SELECT  P.purchase_no, P.mattresstype, A.Company, P.accessoriesrequired, P.total, P.mattresswidth, P.mattresslength, P.mattressrequired, P.ORDER_DATE, P.ORDER_NUMBER, A.email_address, P.deliveryadd1, P.deliveryadd2, P.deliveryadd3, P.deliverytown, P.deliverycounty, P.deliverypostcode, P.deliverycountry, P.ordercurrency, P.savoirmodel, C.surname FROM purchase P, Location L, contact C, Address A WHERE P.contact_no=C.contact_no and C.code=A.code and P.idlocation=L.idlocation and year(ORDER_DATE)>2016 and (quote is Null or quote='n') and (cancelled is Null or cancelled='n') and ordersource<>'Marketing' and ordersource<>'Test' and ordersource<>'Floorstock' and ordersource<>'Stock' and is_developer='n'"
sql=sql & " AND C.contact_no<>319256 AND C.contact_no<>24188 order by ORDER_DATE ASC "
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
contactno=""

Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Order Date,Order No,Surname,Company,Email Address,Del Add 1,Del Add 2,Del Add 3,Del Town,Del County,Del Postcode,Del Country,Matt Spec,Matt Length/Width,Order Value,Accessories Item & Size")
Do until rs.eof
accsummary=""
mattspec=""
mattresswidth=""
mattresslength=""
mattwidthstring=""
if rs("accessoriesrequired")="y" then

	sql3="select * from orderaccessory where purchase_no=" & rs("purchase_no") & ""
	Set rs2 = getMysqlQueryRecordSet(sql3, con)
	if not rs2.eof then
		do until rs2.eof
		accsummary=accsummary & rs2("description") & " size= " & (rs2("size") & ", ")
		rs2.movenext
		loop
	end if
	rs2.close
	set rs2=nothing
	if len(accsummary)>2 then
	accsummary=left(accsummary,len(accsummary)-2)
	end if
end if
if rs("mattressrequired")="y" then
	matt1width=""
	matt2width=""
	matt1length=""
	matt2length=""
	
	if left(rs("mattresswidth"),3)="Spe" or left(rs("mattresslength"),3)="Spe" then
		sql3="select matt1width, matt2width, matt1length, matt2length from productionsizes where purchase_no=" & rs("purchase_no") & ""
				Set rs2 = getMysqlQueryRecordSet(sql3, con)
				if not rs2.eof then
					if rs2("matt1width")<>"" then matt1width=rs2("matt1width") else matt1width=""
					if rs2("matt2width")<>"" then matt2width=rs2("matt2width") else matt2width=""
					if rs2("matt1length")<>"" then matt1length=rs2("matt1length") else matt1length=""
					if rs2("matt2length")<>"" then matt2length=rs2("matt2length") else matt2length=""
				end if
				rs2.close
				set rs2=nothing
	end if
	
	if matt1width<>"" then mattwidthstring= matt1width & "cm x "
	if matt1width="" then mattwidthstring= rs("mattresswidth") & " x "
	if matt1length<>"" then mattwidthstring=mattwidthstring & matt1length & "cm. "
	if matt1length="" then mattwidthstring=mattwidthstring & rs("mattresslength") & ". "
	if left(rs("mattresstype"),3)="Zip" and (left(rs("mattresswidth"),3)="Spe" or left(rs("mattresslength"),3)="Spe") then
		if matt2width<>"" then 
			mattwidthstring=mattwidthstring & matt2width & "cm x "
		else 
			mattwidthstring=mattwidthstring & rs("mattresswidth")
		end if
		if matt2length<>"" then 
			mattwidthstring=mattwidthstring & matt2length & "cm."
		else
			mattwidthstring=mattwidthstring & rs("mattresslength")
		end if
	end if
end if



excelLine = """" & rs("ORDER_DATE") & """,""" & rs("ORDER_NUMBER") & """,""" & rs("surname") & """,""" & rs("company") & """,""" & rs("email_address") & """,""" & rs("deliveryadd1") & """,""" & rs("deliveryadd2") & """,""" & rs("deliveryadd3") & """,""" & rs("deliverytown") & """,""" & rs("deliverycounty") & """,""" & rs("deliverypostcode") & """,""" & rs("deliverycountry") & """,""" & rs("savoirmodel") & """,""" & mattwidthstring & """,""" & rs("total") & """,""" & accsummary & """,""" & rs("ordercurrency") & """"
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
