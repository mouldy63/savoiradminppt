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
<!-- #include file="common/utilfuncs.asp" -->
<%Dim title, strname, surname, matt1width, matt2width, matt1length, matt2length, company, position, xsource,  submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, rs2, rs3, rs4, recordfound, id, sql, sql2,  sql3, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, showroomname, mattresswidth, orderNo, bedname, accsummary, orderedprod, customertype, notes, bookeddeliverydate, contactno

msg=""



if (retrieveuserid()=2 or retrieveuserid()=1) then	
Set Con = getMysqlConnection()
'sql for all contacts from a date (uses date added and firstcontactdate)
sql="select L.adminheading, P.purchase_no, P.order_number, P.order_date, P.ordersource, C.surname, A.company, P.savoirmodel, P.leftsupport, P.rightsupport, P.mattresswidth, P.mattresslength, P.mattresstype, P.mattressinstructions from purchase P, contact C, Address A, Location L where P.mattressrequired='y' and C.code=A.code and P.contact_no=C.contact_no and P.idlocation=L.idlocation and is_developer='n' AND C.contact_no<>319256 AND C.contact_no<>24188 and P.quote<>'y' and (P.cancelled='n' or P.cancelled is null)"
'sql="select * from contact C, Address A where C.code=A.code and is_developer='n' AND C.contact_no<>319256 AND C.contact_no<>24188 and C.contact_no > 351323"
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
contactno=""

Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt, mattressinstructions
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Order No.,Order Date,Showroom,Order Source,Surname,Company,Model No.,Left support,Right support,Width,Length,Special width 1,Special width 2,Special length 1,Special length 2,Type, Instructions")
Do until rs.eof
	if (rs("mattresswidth")="Special Width" or rs("mattresslength")="Special Length") then
		sql2="select * from productionsizes where purchase_no=" & rs("purchase_no")
		Set rs1 = getMysqlQueryRecordSet(sql2, con)
		if not rs1.eof then
			matt1width=""
			matt2width=""
			matt1length=""
			matt2length=""
			If rs1("matt1width") <> "" then 
				matt1width=rs1("matt1width")
			end if
			If rs1("matt2width") <> "" then 
				matt1width=rs1("matt2width")
			end if
			If rs1("matt1length") <> "" then 
				matt1width=rs1("matt1length")
			end if
			If rs1("matt2length") <> "" then 
				matt1width=rs1("matt2length")
			end if
		end if
		rs1.close
		set rs1=nothing
	end if
	
	mattressinstructions = ""
	if (not IsNull(rs("mattressinstructions")) and not IsEmpty(rs("mattressinstructions"))) then
		mattressinstructions = cleanForCSV(rs("mattressinstructions"))
	end if
	
	excelLine = """" & rs("order_number") & """,""" & rs("order_date") & """,""" & rs("adminheading") & """,""" & rs("ordersource") & """,""" & rs("surname") & """,""" & rs("company") & """,""" & rs("savoirmodel") & """,""" & rs("leftsupport") & """,""" & rs("rightsupport") & """,""" & rs("mattresswidth") & """,""" & rs("mattresslength") & """,""" & matt1width & """,""" & matt1length & """,""" & matt2width & """,""" & matt2length & """,""" & rs("mattresstype") & """,""" & mattressinstructions & """"
	
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
