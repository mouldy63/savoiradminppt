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
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, rs2, rs3, rs4, recordfound, id, sql, sql2,  sql3, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, showroomname, mattresswidth, orderNo, bedname, accsummary, orderedprod, customertype, notes, bookeddeliverydate, contactno, matt1width, matt2width, matt1length, matt2length, base1width, base2width, base1length, base2length, basedrawerconfigid, mattinstructions, topperinstructions, speclegheight, ordertype, accdesc, accdesign, acccolour, accsize, accprice, accqty, accdeliverydate,vattext,accpodate,accsupplier,accponumber,accsi,accqtytofollow,acctarrif,accproductcode

msg=""



if (retrieveuserid()=2) then	
Set Con = getMysqlConnection()
sql="select * from purchase P, contact C, Address A where accessoriesrequired='y' AND purchase_no > 80907 and P.contact_no=C.contact_no and C.CODE=A.CODE"
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
contactno=""

Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Name,Company,Order Date,Order number,Order Source,Customer Ref,Showroom,Currency,VAT rate,Booked Delivery date,Discount of Order,Discount type,Acc Desc,Acc Design,Acc Colour,Acc Size,Acc Price,VAT included/excluded,Acc Qty,Acc Delivery Date,PO Date,Supplier,PO Number,Special Instructions,Qty To Follow,Tariff Code,Product Code")
Do until rs.eof
showroomname=""
sql="select adminheading from location where idlocation=" & rs("idlocation")
Set rs1 = getMysqlQueryRecordSet(sql, con)
if Not rs1.eof then
showroomname=rs1("adminheading")
end if
rs1.close
set rs1=nothing
vattext=""
if rs("istrade")="y" then vattext="Exc"
if rs("istrade")="n" then vattext="Inc"
accsummary=""
if rs("accessoriesrequired")="y" then
		sql3="select * from orderaccessory where purchase_no=" & rs("purchase_no") & ""
		Set rs1 = getMysqlQueryRecordSet(sql3, con)
		if not rs1.eof then
			do until rs1.eof
			accdesc=rs1("description")
			accdesign=rs1("design")
			acccolour=rs1("colour")
			accsize=rs1("size")
			accprice=rs1("unitprice")
			accqty=rs1("qty")
			accdeliverydate=rs1("delivered")
			accpodate=rs1("podate")
			accsupplier=rs1("supplier")
			accponumber=rs1("ponumber")
			accsi=rs1("specialinstructions")
			accqtytofollow=rs1("qtytofollow")
			acctarrif=rs1("tariffcode")
			accproductcode=rs1("productcode")
			
			excelLine = """" & rs("surname") & """,""" & rs("company") & """,""" & rs("order_date") & """,""" & rs("order_number") & """,""" & rs("OrderSource") & """,""" & rs("customerreference") & """,""" & showroomname & """,""" & rs("ordercurrency") & """,""" & rs("vatrate") & """,""" & rs("bookeddeliverydate") & """,""" & rs("discount") & """,""" & rs("discounttype") & """,""" & accdesc & """,""" & accdesign & """,""" & acccolour & """,""" & accsize & """,""" & accprice & """,""" & vattext & """,""" & accqty & """,""" & accdeliverydate & """,""" & accpodate & """,""" & accsupplier & """,""" & accponumber & """,""" & accsi & """,""" & accqtytofollow & """,""" & acctarrif & """,""" & accproductcode & """"
	
	tempfile.WriteLine(excelLine)
	
			rs1.movenext
			loop
		end if
		rs1.close
		set rs1=nothing
		if len(accsummary)>2 then
		accsummary=left(accsummary,len(accsummary)-2)
		end if
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
