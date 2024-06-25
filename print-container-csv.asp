<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, recordfound, id, sql, i
dim orderexists, rs1, rs3, totalpn, n, items, location, exportlinksid, collectionid, loc, shipperid, custname
dim pnarray(), count,  currencyno, shipmentcount
dim productdetails, accessoriesexist, deliverypriceexists, expcost, shippeddate, datefrom, dateto, datecomp
Dim totalexportcost
shippeddate=""
shipmentcount=1
currencyno=1
expcost=0
count = 0
id=request("id")
location=request("location")
Set Con = getMysqlConnection()

sql="SELECT * from exportcollections E, location L, shipper_address S, collectionStatus C, exportCollShowrooms T where  T.idlocation=L.idlocation and E.shipper=S.shipper_address_id AND C.collectionStatusID=E.collectionStatus AND  T.exportCollectionID=" & id & " and E.exportcollectionsid=T.exportCollectionid order by CollectionDate"
Set rs3 = getMysqlQueryRecordSet(sql, con)
collectionid=rs3("exportcollectionsid")


Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname

tempfile.WriteLine("SALES")

Do until rs3.eof
	  loc=rs3("idlocation")
	  datefrom=rs3("collectiondate")
	  dateto=date()
	  datecomp=DateDiff("d",datefrom,dateto)
	  if datecomp>0 then shippeddate=rs3("collectiondate") else shippeddate=""

excelLine = """" & rs3("location") & """"
tempfile.WriteLine(excelLine)
tempfile.WriteLine("Order No,Customer Name,Customer Reference,Order Description,Total Amount,Invoice No.,Shipped,Payment Received,Payment Due")

	if retrieveUserLocation()=1 or retrieveUserLocation()=27 then
			  sql="SELECT distinct purchase_no, linksCollectionid from exportlinks E, exportCollShowrooms S where  E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & rs3("exportCollectionsID") & " AND S.idlocation=" & rs3("idlocation") & " and orderConfirmed='y'"		  
			  else
			  sql="SELECT distinct E.purchase_no, linksCollectionid from exportlinks E, exportCollShowrooms S, Purchase P where  E.LinksCollectionID=S.exportCollshowroomsID and P.idlocation=" & retrieveUserLocation & " and E.purchase_no=P.purchase_no AND S.exportCollectionID=" & rs3("exportCollectionsID") & " AND S.idlocation=" & location & "  AND orderConfirmed='y'"
	end if

Set rs1 = getMysqlQueryRecordSet(sql, con)
		  
	if rs1.eof then
		  totalpn=0
	else
		    exportlinksid=rs1("LinksCollectionID")
		  totalpn=rs1.recordcount
				while not rs1.eof
				count = count + 1
				redim preserve pnarray(count)
				pnarray(count)=rs1("purchase_no")
				rs1.movenext
				wend		 
	end if
	rs1.close
	set rs1=nothing
	if count>0 then

totalexportcost=0
for n = 1 to ubound(pnarray)
totalexportcost=0
productdetails=""
accessoriesexist="n"
deliverypriceexists="n"
		sql="SELECT * from exportLinks E, exportcollshowrooms S where E.LinksCollectionID=S.exportCollshowroomsID and S.Exportcollectionid=" & id & " and purchase_no=" & pnarray(n)
		Set rs = getMysqlQueryRecordSet(sql, con)
		items=rs.recordcount
		do until rs.eof
		if rs("componentid")=1 then
			sql="Select savoirmodel, mattresstype, mattressprice from purchase where purchase_no=" & pnarray(n)
			Set rs1 = getMysqlQueryRecordSet(sql, con)
			productdetails=productdetails & rs1("savoirmodel") & " mattress, "
			if left(rs1("mattresstype"),3)="Zip" then items=items+1
				if rs1("mattressprice")="0" or isNull(rs1("mattressprice")) then
				else
				totalexportcost=totalexportcost+CDbl(rs1("mattressprice"))
				end if
			rs1.close 
			set rs1=nothing
		end if
		if rs("componentid")=3 then
			sql="Select basesavoirmodel, basetype, baseprice, upholsteryprice, basefabricprice from purchase where purchase_no=" & pnarray(n)
			Set rs1 = getMysqlQueryRecordSet(sql, con)
			productdetails=productdetails & rs1("basesavoirmodel") & " base, "
			if (left(rs1("basetype"),3)="Eas" or left(rs1("basetype"),3)="Nor") then items=items+1
			if rs1("baseprice")="0" or isNull(rs1("baseprice")) then
				else
				totalexportcost=totalexportcost+CDbl(rs1("baseprice"))
			end if
			if rs1("upholsteryprice")="0" or isNull(rs1("upholsteryprice")) then
				else
				totalexportcost=totalexportcost+CDbl(rs1("upholsteryprice"))
			end if
			if rs1("basefabricprice")="0" or isNull(rs1("basefabricprice")) then
				else
				totalexportcost=totalexportcost+CDbl(rs1("basefabricprice"))
			end if
				
			rs1.close 
			set rs1=nothing
		end if
		if rs("componentid")=5 then
		sql="Select toppertype, topperprice from purchase where purchase_no=" & pnarray(n)
		Set rs1 = getMysqlQueryRecordSet(sql, con)
		productdetails=productdetails & rs1("toppertype") & ", "
		if rs1("topperprice")="0" or isNull(rs1("topperprice")) then
						else
						totalexportcost=totalexportcost+CDbl(rs1("topperprice"))
		end if
		rs1.close
		set rs1=nothing
		end if
		if rs("componentid")=6 then
		sql="Select valanceprice, valfabricprice from purchase where purchase_no=" & pnarray(n)
		Set rs1 = getMysqlQueryRecordSet(sql, con)
		productdetails=productdetails & "Valance, "
			if rs1("valanceprice")="0" or isNull(rs1("valanceprice")) then
				else
				totalexportcost=totalexportcost+CDbl(rs1("valanceprice"))
			end if
			if rs1("valfabricprice")="0" or isNull(rs1("valfabricprice")) then
				else
				totalexportcost=totalexportcost+CDbl(rs1("valfabricprice"))
			end if
		rs1.close
		set rs1=nothing
		end if
		if rs("componentid")=7 then
		sql="Select legprice, addlegprice from purchase where purchase_no=" & pnarray(n)
		Set rs1 = getMysqlQueryRecordSet(sql, con)
			productdetails=productdetails & "Legs, "
			if rs1("legprice")="0" or isNull(rs1("legprice")) then
			else
			totalexportcost=totalexportcost+CDbl(rs1("legprice"))
			end if
			if rs1("addlegprice")="0" or isNull(rs1("addlegprice")) then
			else
			totalexportcost=totalexportcost+CDbl(rs1("addlegprice"))
			end if
		rs1.close
		set rs1=nothing
		end if

		if rs("componentid")=8 then
		sql="Select headboardprice, hbfabricprice from purchase where purchase_no=" & pnarray(n)
		Set rs1 = getMysqlQueryRecordSet(sql, con)
		productdetails=productdetails & "Headboard, "
			if rs1("headboardprice")="0" or isNull(rs1("headboardprice")) then
						else
						totalexportcost=totalexportcost+CDbl(rs1("headboardprice"))
			end if
			if rs1("hbfabricprice")="0" or isNull(rs1("hbfabricprice")) then
						else
						totalexportcost=totalexportcost+CDbl(rs1("hbfabricprice"))
			end if
						
		rs1.close
		set rs1=nothing
		end if

		if rs("componentid")=9 then
		sql="Select accessoriestotalcost from purchase where purchase_no=" & pnarray(n)
		Set rs1 = getMysqlQueryRecordSet(sql, con)
		accessoriesexist="y"
			if rs1("accessoriestotalcost")="0" or isNull(rs1("accessoriestotalcost")) then
						else
						totalexportcost=totalexportcost+CDbl(rs1("accessoriestotalcost"))
			end if
		rs1.close
		set rs1=nothing
		end if
		rs.movenext
		loop
		rs.close
		set rs=nothing
		
		sql="Select specialinstructionsdelivery from purchase where purchase_no=" & pnarray(n)
		Set rs1 = getMysqlQueryRecordSet(sql, con)
			if rs1("specialinstructionsdelivery")<>"" and NOT ISNULL(rs1("specialinstructionsdelivery")) then 
				deliverypriceexists="y"
			end if
		rs1.close
		set rs1=nothing

				  
sql="SELECT * FROM exportlinks E, exportcollshowrooms  S, purchase P, Address A, Contact C WHERE E.purchase_no=" & pnarray(n) & " and E.LinksCollectionID=S.exportCollshowroomsID and P.purchase_no=E.purchase_no and P.code=C.code and A.code=P.code group by E.purchase_no" 
Set rs = getMysqlQueryRecordSet(sql, con)
		if not rs.eof Then
custname=""
custname=rs("surname") & " " & rs("first") & " " & rs("title")
if accessoriesexist="y" then productdetails=productdetails & "Accessories, "
if deliverypriceexists="y" then productdetails=productdetails & "Delivery, "
productdetails = LEFT(productdetails, (LEN(productdetails)-2)) 

if rs("ordercurrency")="GBP" then expcost="£" & totalexportcost
if rs("ordercurrency")="EUR" then expcost="€" & totalexportcost
if rs("ordercurrency")="USD" then expcost="$" & totalexportcost

excelLine= """" & rs("order_number") & """,""" & custname & """,""" & rs("customerreference") & """,""" & productdetails & """,""" & expcost & """,""" & rs("invoiceNo") & """,""" & shippeddate & """,""" & rs("paymentstotal") & """,""" & rs("balanceoutstanding") & """"
tempfile.WriteLine(excelLine)
		end if
next
rs.close
set rs=nothing

end if
count=0
Erase pnarray
expcost=0
rs3.movenext
loop
rs3.close
set rs3=nothing
		
con.close
set con=nothing

tempfile.close

Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = 1
objStream.LoadFromFile(filename)

Response.ContentType = "application/csv"
Response.AddHeader "Content-Disposition", "attachment; filename=""container-details.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing


%>
  