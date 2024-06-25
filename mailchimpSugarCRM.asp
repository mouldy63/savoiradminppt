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
sql="SELECT C.contact_no, C.title, C.surname, A.EMAIL_ADDRESS, A.street1, A.street2, A.street3, A.town, A.county, A.postcode, A.country, A.tel, C.telwork, C.mobile, A.company, C.position, C.COMPANY_VAT_NO, C.acceptemail, C.acceptpost, A.wrongaddress, A.STATUS, A.CHANNEL, CT.customerType, A.source, A.source_other, A.INITIAL_CONTACT, A.FIRST_CONTACT_DATE, A.PRICE_LIST, A.VISIT_DATE, A.VISIT_LOCATION, A.last_contact_date, P.ORDER_NUMBER, P.ORDER_DATE, P.totalexvat, P.ordercurrency, P.deliveryadd1,P.deliveryadd2, P.deliveryadd3, P.deliverytown, P.deliverycounty, P.deliverypostcode, P.deliverycountry, (SELECT SUM(totalexvat) as cumspend FROM Purchase P1 WHERE P1.contact_no=C.contact_no GROUP BY P1.contact_no) as cumspend, (select group_concat(ip.product) from interestproducts ip join interestproductslink ipl on ip.id=ipl.product_id where ipl.contact_no=C.contact_no) as intprods"
sql=sql & " FROM contact C" 
sql=sql & " join address a on C.code=A.code" 
sql=sql & " join location L on C.idlocation = L.idlocation "
sql=sql & " left join purchase P on P.contact_no=C.contact_no AND P.ordersource<>'Test' and (P.quote<>'y' or P.quote is null) and (P.cancelled='n' or P.cancelled is null)"
sql=sql & " left join customertype CT on CT.customerTypeID=C.customerType"
sql=sql & " where C.is_developer='n' AND C.contact_no<>319256 AND C.contact_no<>24188 and C.contact_no < 23101"

'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
contactno=""

Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Contact No,Title,Surname,Email Address,Invoice Address 1,Invoice Address 2,Invoice Address3,Invoice Town,Invoice County, Invoice Postcode,Invoice Country,Tel Home, Tel Work, Mobile,Company,Position,Company VAT No,Accepts Email Marketing,Accepts Postal Marketing,Wrong Address,Interested In,Customer Status,Channel,Customer Type,Source,Alternative Source,Initial Contact Made By,Initial Contact Date,Price List,Visit Date,Visit Location,Last Contact Date,Order No,Order Date,Order Total Ex VAT, Order Currency,Cumulative Spend ex VAT,Delivery Address1,Delivery Address2,Delivery Address3,Delivery Town,Delivery County,Delivery Postcode,Delivery Country")
Do until rs.eof

	
excelLine = """" & rs("contact_no") & """,""" & rs("title") & """,""" & rs("surname") & """,""" & rs("email_address") & """,""" & rs("street1") & """,""" & rs("street2") & """,""" & rs("street3") & """,""" & rs("town") & """,""" & rs("county") & """,""" & rs("postcode") & """,""" & rs("country") & """,""" & rs("tel") & """,""" & rs("telwork") & """,""" & rs("mobile") & """,""" & rs("company") & """,""" & rs("position") & """,""" & rs("COMPANY_VAT_NO") & """,""" & rs("acceptemail") & """,""" & rs("acceptpost") & """,""" & rs("wrongaddress") & """,""" & rs("intprods") & """,""" & rs("STATUS") & """,""" & rs("CHANNEL") & """,""" & rs("customerType") & """,""" & rs("source") & """,""" & rs("source_other") & """,""" & rs("INITIAL_CONTACT") & """,""" & rs("FIRST_CONTACT_DATE") & """,""" & rs("PRICE_LIST") & """,""" & rs("VISIT_DATE") & """,""" & rs("VISIT_LOCATION") & """,""" & rs("last_contact_date") & """,""" & rs("ORDER_NUMBER") & """,""" & rs("ORDER_DATE") & """,""" & rs("totalexvat") & """,""" & rs("ordercurrency") & """,""" & rs("cumspend") & """,""" & rs("deliveryadd1") & """,""" & rs("deliveryadd2") & """,""" & rs("deliveryadd3") & """,""" & rs("deliverytown") & """,""" & rs("deliverycounty") & """,""" & rs("deliverypostcode") & """,""" & rs("deliverycountry") & """"
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
