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
sql="select * from purchase p join location L on p.idlocation=L.idlocation join contact c on p.contact_no=c.contact_no join address a on p.code=a.code where p.ordersource not in ('Floorstock','Test','Marketing','Stock') and (p.cancelled='n' or p.cancelled is null) and (p.quote='n' or p.quote is null) and year(p.order_date)=2021 and p.contact_no in (select t1.contact_no from (select contact_no,purchase_no,order_date from purchase where ordersource not in ('Floorstock','Test','Marketing','Stock') and (cancelled='n' or cancelled is null) and (quote='n' or quote is null) group by contact_no) as t1 where year(t1.order_date)<2021)"

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


	orderedprod=""
	orderNo=""
	showroomname=""
	accsummary=""
	If rs("baserequired")="y" then 
		orderedprod=orderedprod & rs("basesavoirmodel") & " base, "
	end if
	If rs("mattressrequired")="y" then 
		orderedprod=orderedprod & rs("savoirmodel") & " mattress, "
	end if
	If rs("topperrequired")="y" then 
		orderedprod=orderedprod & rs("toppertype") & " topper, "
	end if
	If rs("legsrequired")="y" then 
		orderedprod=orderedprod & " legs, "
	end if
	If rs("headboardrequired")="y" then 
		orderedprod=orderedprod & rs("headboardstyle") & " headboard, "
	end if
	If rs("valancerequired")="y" then 
		orderedprod=orderedprod &  " valance, "
	end if
	if len(orderedprod)>2 then 
	orderedprod=left(orderedprod,len(orderedprod)-2)
	end if
	if rs("accessoriesrequired")="y" then
		sql3="select * from orderaccessory where purchase_no=" & rs("purchase_no") & ""
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
	

	excelLine = """" & left(rs("order_date"),10) & """,""" & rs("totalexvat") & """,""" & rs("order_number") & """,""" & rs("adminheading") & """,""" & rs("discounttype") & """,""" & rs("discount") & """,""" & rs("ordercurrency") & """,""" & rs("surname") & """,""" & rs("EMAIL_ADDRESS") & """,""" & rs("company") & """,""" & rs("street1") & """,""" & rs("street2") & """,""" & rs("street3") & """,""" & rs("town") & """,""" & rs("county") & """,""" & rs("postcode") & """,""" & rs("country") & """,""" & rs("deliveryadd1") & """,""" & rs("deliveryadd2") & """,""" & rs("deliveryadd3") & """,""" & rs("deliverytown") & """,""" & rs("deliverycounty") & """,""" & rs("deliverypostcode") & """,""" & rs("deliverycountry") & """,""" & orderedprod & """,""" & accsummary & """,""" & rs("contact_no") & """"
	
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
Response.AddHeader "Content-Disposition", "attachment; filename=""datadumprepeatorder2021.csv"""

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
