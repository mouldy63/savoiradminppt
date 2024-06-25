<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="generalfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%Dim  Con, rs, rs1, rs2, recordfound, id, count, i, fieldName, fieldValue, fieldNameArray, type1, prodsql, sql,  title, specialwidth1, specialwidth2, speciallength1, speciallength2, comptype, instructions


sql=Request.form("prodsql")
title=request.form("title")
'response.write(sql)
'response.end()
Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine

Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
excelLine = """" & title & """"
tempfile.WriteLine(excelLine)
if InStr(title,"Headboard") then
tempfile.WriteLine("Order No,Component,Special Instructions,Width,Height,Showroom,Fabric Company,Fabric Description,Fabric Special Instructions")
elseif InStr(title,"Leg") then
tempfile.WriteLine("Order No,Component,Special Instructions,Height,Special,Leg Finish")
elseif InStr(title,"Topper") then
tempfile.WriteLine("Order No,Component,Special Instructions,Width,Length,Special Width,Special Length")
else
tempfile.WriteLine("Order No,Component,Special Instructions,Width,Length,Special Width 1, Special Length 1,Special Width 2, Special Length 2,Showroom")
end if
Set Con = getMysqlConnection()

Set rs = getMysqlQueryRecordSet(sql, con)

Do until rs.eof
if InStr(title,"Headboard") then
else
if (left(lcase(rs("w")),7)="special" or left(lcase(rs("l")),7)="special") then
	Set rs1 = getMysqlQueryRecordSet("SELECT * FROM `productionsizes` WHERE Purchase_No=" & rs("purchase_no"), con)
	if not rs1.eof then
		if InStr(title,"Mattress") then
			if left(lcase(rs("w")),7)="special" then
				specialwidth1=rs1("matt1width")
				specialwidth2=rs1("matt2width")
			end if
			if left(lcase(rs("l")),7)="special" then
				speciallength1=rs1("matt1length")
				speciallength2=rs1("matt2length")
			end if
		end if
		if InStr(title,"Base") then
			if left(lcase(rs("w")),7)="special" then
				specialwidth1=rs1("base1width")
				specialwidth2=rs1("base2width")
			end if
			if left(lcase(rs("l")),7)="special" then
				speciallength1=rs1("base1length")
				speciallength2=rs1("base2length")
			end if
		end if
		if InStr(title,"Topper") then
			if left(lcase(rs("w")),7)="special" then
				specialwidth1=rs1("topper1width")
			end if
			if left(lcase(rs("l")),7)="special" then
				speciallength1=rs1("topper1length")
			end if
		end if
		if InStr(title,"Leg") then
			if left(lcase(rs("w")),7)="special" then
				specialwidth1=rs1("legheight")
			end if
		end if
		rs1.close
		set rs1=nothing
	end if
end if
end if
instructions=rs("x")
if instructions<>"" then
instructions=Replace(instructions, """", """""")
end if

if InStr(title,"Headboard") then
excelLine = """" & rs("order_number") & """,""" & rs("n") & """,""" & instructions & """,""" & rs("w") & """,""" & rs("l") & """,""" & rs("adminheading") & """,""" & rs("headboardfabric") & """,""" & rs("headboardfabricchoice") & """,""" & rs("headboardfabricdesc") & """"

elseif InStr(title,"Leg") then
excelLine = """" & rs("order_number") & """,""" & rs("n") & """,""" & instructions & """,""" & rs("l") & """,""" & specialwidth1 & """,""" & rs("lf") & """"
elseif InStr(title,"Topper") then
excelLine = """" & rs("order_number") & """,""" & rs("n") & """,""" & instructions & """,""" & rs("w") & """,""" & rs("l") & """,""" & specialwidth1 & """,""" & speciallength1 & """"
else
excelLine = """" & rs("order_number") & """,""" & rs("n") & """,""" & instructions & """,""" & rs("w") & """,""" & rs("l") & """,""" & specialwidth1 & """,""" & speciallength1 & """,""" & specialwidth2 & """,""" & speciallength2 & """"
end if

tempfile.WriteLine(excelLine)

specialwidth1=""
specialwidth2=""
speciallength1=""
speciallength2=""
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
Response.AddHeader "Content-Disposition", "attachment; filename=""itemsproduced.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing


%>
<!-- #include file="common/logger-out.inc" -->
