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
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, rs2, rs3, rs4, recordfound, id, sql, sql2,  sql3, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, showroomname, mattresswidth, orderNo, bedname, accsummary, orderedprod, customertype, notes, bookeddeliverydate, contactno, wholeorderstatus, mattorderstatus, mattdeliverydate, basedeliverydate, baseorderstatus, topperdeliverydate, topperorderstatus, hbdeliverydate, hborderstatus, legdeliverydate, legorderstatus, valancedeliverydate, valanceorderstatus, accdeliverydate, accorderstatus
msg=""



if (retrieveuserid()=2) then	
Set Con = getMysqlConnection()
'sql for all contacts from a date (uses date added and firstcontactdate)
'sql="select * from contact C, Address A where C.code=A.code and is_developer='n' AND C.contact_no<>319256 AND C.contact_no<>24188 and (C.dateadded > '2021-02-21' or A.FIRST_CONTACT_DATE > '2021-02-21')"
sql="SELECT P.purchase_no, P.deliverydate, P.bookeddeliverydate, P.ORDER_DATE, P.ORDER_NUMBER, L.adminheading, P.ordercurrency, P.vatrate, P.istrade,P.savoirmodel, P.mattressprice, P.baseprice, P.basedrawersprice, P.basefabricprice, P.basetrimprice, P.upholsteryprice, P.topperprice, P.headboardprice, P.headboardtrimprice, P.hbfabricprice, P.legprice, P.addlegprice, P.valanceprice, P.valfabricprice, P.deliveryprice, P.accessoriestotalcost, P.discount, P.discounttype, P.ordersource, P.quote  FROM purchase P, Location L WHERE P.idlocation=L.idlocation and year(ORDER_DATE)>2019 and (quote is Null or quote='n') and (cancelled is Null or cancelled='n') and ordersource<>'Marketing' and ordersource<>'Test' order by ORDER_DATE ASC "
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
contactno=""

Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Order Date,Order No,Showroom,Currency,VAT rate,VAT incl,All Order Status,Delivery Date,Mattress model,Mattress Price,Mattress Order Status,Mattress delivery date,Base Price,Base Drawer Price, Base Fabric Price,Base Trim Price,Upholstery Price,Base Order Status,Base delivery date,Topper Price,Topper Order Status,Topper delivery date,Headboard Price,Headboard Trim Price,Headboard Fabric Price,Headboard Order Status,Headboard delivery date,Leg Price,Additional Leg Price,Leg Order Status,Leg delivery date,Valance Price, Valance Fabric Price,Valance Order Status,Valance delivery date,Delivery Price,Accessory Price,Accessory Order Status,Accessory delivery date,Discount,Discount Type,Order Source, Quote")
Do until rs.eof
wholeorderstatus=""
mattorderstatus=""
mattdeliverydate=""
baseorderstatus=""
basedeliverydate=""
topperorderstatus=""
topperdeliverydate=""
hborderstatus=""
hbdeliverydate=""
legorderstatus=""
legdeliverydate=""
valanceorderstatus=""
valancedeliverydate=""
accorderstatus=""
accdeliverydate=""
sql2="SELECT * FROM qc_history_latest Q, qc_status S WHERE Q.QC_StatusID=S.QC_StatusID and Q.Purchase_no='" & rs("purchase_no") & "'"
Set rs1 = getMysqlQueryRecordSet(sql2, con)
if not rs1.eof then
do until rs1.eof
	if rs1("ComponentID")=0 then
	wholeorderstatus=rs1("qc_status")
	end if
	if rs1("ComponentID")=1 then
	mattorderstatus=rs1("qc_status")
	mattdeliverydate=rs1("DeliveryDate")
	end if
	if rs1("ComponentID")=3 then
	baseorderstatus=rs1("qc_status")
	basedeliverydate=rs1("DeliveryDate")
	end if
	if rs1("ComponentID")=5 then
	topperorderstatus=rs1("qc_status")
	topperdeliverydate=rs1("DeliveryDate")
	end if
	if rs1("ComponentID")=8 then
	hborderstatus=rs1("qc_status")
	hbdeliverydate=rs1("DeliveryDate")
	end if
	if rs1("ComponentID")=7 then
	legorderstatus=rs1("qc_status")
	legdeliverydate=rs1("DeliveryDate")
	end if
	if rs1("ComponentID")=6 then
	valanceorderstatus=rs1("qc_status")
	valancedeliverydate=rs1("DeliveryDate")
	end if
	if rs1("ComponentID")=9 then
	accorderstatus=rs1("qc_status")
	accdeliverydate=rs1("DeliveryDate")
	end if

rs1.movenext
loop
end if
rs1.close
set rs1=nothing


excelLine = """" & rs("ORDER_DATE") & """,""" & rs("ORDER_NUMBER") & """,""" & rs("adminheading") & """,""" & rs("ordercurrency") & """,""" & rs("vatrate") & """,""" & rs("istrade") & """,""" & wholeorderstatus & """,""" & rs("bookeddeliverydate") & """,""" & rs("savoirmodel") & """,""" & rs("mattressprice") & """,""" & mattorderstatus & """,""" & mattdeliverydate & """,""" & rs("baseprice") & """,""" & rs("basedrawersprice") & """,""" & rs("basefabricprice") & """,""" & rs("basetrimprice") & """,""" & rs("upholsteryprice") & """,""" & baseorderstatus & """,""" & basedeliverydate & """,""" & rs("topperprice") & """,""" & topperorderstatus & """,""" & topperdeliverydate & """,""" & rs("headboardprice") & """,""" & rs("headboardtrimprice") & """,""" & rs("hbfabricprice") & """,""" & hborderstatus & """,""" & hbdeliverydate & """,""" & rs("legprice") & """,""" & rs("addlegprice") & """,""" & legorderstatus & """,""" & legdeliverydate & """,""" & rs("valanceprice") & """,""" & rs("valfabricprice") & """,""" & valanceorderstatus & """,""" & valancedeliverydate & """,""" & rs("deliveryprice") & """,""" & rs("accessoriestotalcost") & """,""" & accorderstatus & """,""" & accdeliverydate & """,""" & rs("discount") & """,""" & rs("discounttype") & """,""" & rs("ordersource") & """,""" & rs("quote") & """"
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
