<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
Response.Buffer = True %>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim postcode, postcodefull, Con, rs, csvsql
csvsql=request("csvsql")

Dim  cnt,  excellist, excelLine,  failedwrite, errormsg, showr, productiondate, deldate, companyasc, scode, rs1, msg, sql, replacementsum
Set Con = getMysqlConnection()
replacementsum=0

Set rs = getMysqlQueryRecordSet(csvsql, con)

Dim filesys, tempfile, tempfolder, tempname, filename, objStream
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
msg=msg & " - Total records = " & rs.recordcount
tempfile.WriteLine(msg)
tempfile.WriteLine("Customer Service No,Location,Order No,Customer Service Date,Date Closed,Closing Notes,Replacement Price,Service Code,Closed By")

Do until rs.EOF

if isNull(rs("servicecode")) then
			else
				sql="Select * from service_code where servicecodeID=" & rs("servicecode")
				Set rs1 = getMysqlQueryRecordSet(sql, con)
				scode=rs1("servicecode")
				rs1.close
				set rs1=nothing
			end if
			
			if isNull(rs("replacementprice")) then
			else
			replacementsum=replacementsum+CDbl(rs("replacementprice"))
			end if
excelLine = """" & rs("csnumber") & """,""" & rs("showroom") & """,""" & rs("orderno") & ""","""
excelLine = excelLine & rs("dataentrydate") & """,""" & rs("datecaseclosed") & """,""" 
excelLine = excelLine & rs("closedcasenotes") & """,""" & rs("replacementprice") & """,""" & scode & ""","""
excelLine = excelLine & rs("closedby") & """"
tempfile.WriteLine(excelLine)
scode=""

rs.movenext
loop
rs.close
set rs=nothing
excelLine = """Total:"","""","""","""","""","""",""" &  replacementsum & ""","""","""""
tempfile.WriteLine(excelLine)
tempfile.close

Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = 1
objStream.LoadFromFile(filename)

Response.ContentType = "application/csv"
Response.AddHeader "Content-Disposition", "attachment; filename=""customer-service-history.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing

Con.Close
Set Con = Nothing%>
    

 
<!-- #include file="common/logger-out.inc" -->
