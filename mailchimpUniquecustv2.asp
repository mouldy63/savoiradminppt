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
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, rs2, rs3, rs4, recordfound, id, sql, sql2,  sql3, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, showroomname, mattresswidth, orderNo, bedname, accsummary, orderedprod, customertype, notes, bookeddeliverydate, contactno, theYear

msg=""
theYear = 2019


if (retrieveuserid()=2) then	
Set Con = getMysqlConnection()
'sql for all contacts from a date (uses date added and firstcontactdate)
'sql="select * from contact C, Address A where C.code=A.code and is_developer='n' AND C.contact_no<>319256 AND C.contact_no<>24188 and (C.dateadded > '2021-02-21' or A.FIRST_CONTACT_DATE > '2021-02-21')"
'sql="select * from purchase p join location L on p.idlocation=L.idlocation join contact c on p.contact_no=c.contact_no join address a on p.code=a.code where p.purchase_no in (select t1.purchase_no from (select contact_no, purchase_no, order_date from purchase where ordersource not in ('Floorstock','Test','Marketing','Stock') and (cancelled='n' or cancelled is null) and (quote='n' or quote is null) group by contact_no) as t1 where year(t1.order_date)=2021)"

sql = "select p.contact_no from purchase p"
sql = sql & " where p.purchase_no in"
sql = sql & " (select t1.purchase_no from"
sql = sql & " (select contact_no, purchase_no, order_date from purchase where ordersource not in ('Floorstock','Test','Marketing','Stock')"
sql = sql & " and (cancelled='n' or cancelled is null) and (quote='n' or quote is null) group by contact_no)"
sql = sql & " as t1 where year(t1.order_date)=" & theYear & ")"

'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
contactno=""

Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Order Date,Order Value ex VAT,Order No,Showroom,Discount Type,Discount,Currency,Customer Last Name,Email Address,Company,Invoice Add 1, Invoice Add 2,Invoice Add 3, Invoice Town, Invoice County, Invoice Postcode, Invoice Country, Delivery Address 1, Delivery Add 2,Delivery Add 3, Delivery Town, Delivery County, Delivery Postcode, Delivery Country, Items Purchased, Accessories Purchased")

Do until rs.eof

	sql2 = "select * from purchase p"
	sql2 = sql2 & " join location L on p.idlocation=L.idlocation"
	sql2 = sql2 & " join contact c on p.contact_no=c.contact_no"
	sql2 = sql2 & " join address a on p.code=a.code"
	sql2 = sql2 & " where c.contact_no=" & rs("contact_no") & " and year(p.order_date)=" & theYear
	'response.write sql2
	'response.end
	Set rs2 = getMysqlQueryRecordSet(sql2, con)
	
	Do until rs2.eof

		orderedprod=""
		orderNo=""
		showroomname=""
		accsummary=""
		If rs2("baserequired")="y" then 
			orderedprod=orderedprod & rs2("basesavoirmodel") & " base, "
		end if
		If rs2("mattressrequired")="y" then 
			orderedprod=orderedprod & rs2("savoirmodel") & " mattress, "
		end if
		If rs2("topperrequired")="y" then 
			orderedprod=orderedprod & rs2("toppertype") & " topper, "
		end if
		If rs2("legsrequired")="y" then 
			orderedprod=orderedprod & " legs, "
		end if
		If rs2("headboardrequired")="y" then 
			orderedprod=orderedprod & rs2("headboardstyle") & " headboard, "
		end if
		If rs2("valancerequired")="y" then 
			orderedprod=orderedprod &  " valance, "
		end if
		if len(orderedprod)>2 then 
		orderedprod=left(orderedprod,len(orderedprod)-2)
		end if
		if rs2("accessoriesrequired")="y" then
			sql3="select * from orderaccessory where purchase_no=" & rs2("purchase_no") & ""
			Set rs3 = getMysqlQueryRecordSet(sql3, con)
			if not rs3.eof then
				do until rs3.eof
				accsummary=accsummary & rs3("description") & ", "
				rs3.movenext
				loop
			end if
			rs3.close
			set rs3=nothing
			if len(accsummary)>2 then
			accsummary=left(accsummary,len(accsummary)-2)
			end if
		end if
		
	
		excelLine = """" & left(rs2("order_date"),10) & """,""" & rs2("totalexvat") & """,""" & rs2("order_number") & """,""" & rs2("adminheading") & """,""" & rs2("discounttype") & """,""" & rs2("discount") & """,""" & rs2("ordercurrency") & """,""" & rs2("surname") & """,""" & rs2("EMAIL_ADDRESS") & """,""" & rs2("company") & """,""" & rs2("street1") & """,""" & rs2("street2") & """,""" & rs2("street3") & """,""" & rs2("town") & """,""" & rs2("county") & """,""" & rs2("postcode") & """,""" & rs2("country") & """,""" & rs2("deliveryadd1") & """,""" & rs2("deliveryadd2") & """,""" & rs2("deliveryadd3") & """,""" & rs2("deliverytown") & """,""" & rs2("deliverycounty") & """,""" & rs2("deliverypostcode") & """,""" & rs2("deliverycountry") & """,""" & orderedprod & """,""" & accsummary & """,""" & rs2("contact_no") & """"
		
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
Response.AddHeader "Content-Disposition", "attachment; filename=""datadumpfirstorder2019.csv"""

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
