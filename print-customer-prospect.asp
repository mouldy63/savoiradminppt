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
dim orderexists, totalpn, n, items, location, exportlinksid, collectionid, loc, shipperid, custname
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

sql="SELECT acceptemail, acceptpost, title, first, surname, company, street1, street2, street3, town, county, country, postcode, email_address, status FROM address A, contact C WHERE A.code=C.code and C.owning_region=9"
Set rs = getMysqlQueryRecordSet(sql, con)
Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname

tempfile.WriteLine("title,first,surname,Company,add1,add2,add3,town,county,country,postcode,email,status,accept email,accept post")
Do until rs.eof
excelLine= """" & rs("title") & """,""" & rs("first") & """,""" & rs("surname") & """,""" & rs("company") & """,""" & rs("street1") & """,""" & rs("street2") & """,""" & rs("street3") & """,""" & rs("town") & """,""" & rs("county") & """,""" & rs("country") & """,""" & rs("postcode") & """,""" & rs("email_address") & """,""" & rs("status") & """,""" & rs("acceptemail") & """,""" & rs("acceptpost") & """"
tempfile.WriteLine(excelLine)
rs.movenext
loop
rs.close
set rs=nothing
con.close
set con=nothing
tempfile.close
Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = 1
objStream.LoadFromFile(filename)
Response.ContentType = "application/csv"
Response.AddHeader "Content-Disposition", "attachment; filename=""france.csv"""
Response.Status = "200"
Response.BinaryWrite objStream.Read
objStream.Close
Set objStream = Nothing
filesys.deleteFile filename, true
set filesys = Nothing
%>
  