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
<!-- #include file="componentfuncs.asp" -->
<%Dim  Con, rs, rs2, recordfound, id, count, i, fieldName, fieldValue, fieldNameArray, type1, prodsql, sql, sql2,  title, factory, ticking
factory=request("factory")
Set Con = getMysqlConnection()



title=request("title")
'response.Write("sql=" & sql)
'response.End()
Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, model, component, componentW1, componentW2, componentL1, componentL2, componentstyle, width, height, length, Width1, Width2, pno, Length1, Length2, productiondate, etadate, componentsize

Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
excelLine = """" & title & """"
tempfile.WriteLine(excelLine)
tempfile.WriteLine("Order No,Component,Model,Type,Ticking,Size,Width1,Length1,Width2,Length2,Production Date,Approx. Delivery Date")



sql="Select * from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID<>0 and Q.madeat=" & factory & " and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919 order by P.purchase_no asc"
Set rs = getMysqlQueryRecordSet(sql, con)

Do until rs.eof
Width1=""
Width2=""
Length1=""
Length2=""
componentW1=""
componentW2=""
componentL1=""
componentL2=""
ticking=""
pno=rs("purchase_no")
if rs("componentID")=1 then
	component="Mattress"
	model=rs("savoirmodel")
	componentstyle=rs("mattresstype")
	ticking=rs("tickingoptions")
	if left(rs("mattresswidth"),4)="Spec" then call getComponent1WidthSpecialSizes(con, 1, pno, Width1, Width2)
	if left(rs("mattresslength"),4)="Spec" then call getComponent1LengthSpecialSizes(con, 1, pno, Length1, Length2)
	componentsize="(w x l): " & rs("mattresswidth") & " x " & rs("mattresslength")
	if left(rs("mattresswidth"),4)<>"Spec" then componentW1=rs("mattresswidth")
	if left(rs("mattresslength"),4)<>"Spec" then componentL1=rs("mattresslength")
	if Width1<>"" then 
		componentsize=componentsize & vbnewline & "W: " & Width1 & "cm"
		componentW1=Width1 & "cm"
	end if
	if Length1<>"" then 
		componentsize=componentsize & " x L: " & Length1 & "cm"
		componentL1=Length1 & "cm"
	end if
	if Width2<>"" then 
		componentsize=componentsize & " W: " & Width2 & "cm"
		componentW2=Width2 & "cm"
	end if
	if Length2<>"" then 
		componentsize=componentsize & " x L: " & Length2 & "cm"
		componentL2=Length2 & "cm"
	end if
end if
if rs("componentID")=3 then
	component="Base"
	model=rs("basesavoirmodel")
	componentstyle=rs("basetype")
	ticking=rs("basetickingoptions")
	if left(rs("basewidth"),4)="Spec" then call getComponent1WidthSpecialSizes(con, 3, pno, Width1, Width2)
	if left(rs("baselength"),4)="Spec" then call getComponent1LengthSpecialSizes(con, 3, pno, Length1, Length2)
	componentsize="(w x l): " & rs("basewidth") & " x " & rs("baselength")
	if left(rs("basewidth"),4)<>"Spec" then componentW1=rs("basewidth")
	if left(rs("baselength"),4)<>"Spec" then componentL1=rs("baselength")
	if Width1<>"" then 
		componentsize=componentsize & vbnewline & "W: " & Width1 & "cm"
		componentW1=Width1 & "cm"
	end if
	if Length1<>"" then 
		componentsize=componentsize & " x L: " & Length1 & "cm"
		componentL1=Length1 & "cm"
	end if
	if Width2<>"" then 
		componentsize=componentsize & " W: " & Width2 & "cm"
		componentW2=Width2 & "cm"
	end if
	if Length2<>"" then 
		componentsize=componentsize & " x L: " & Length2 & "cm"
		componentL2=Length2 & "cm"
	end if
end if
if rs("componentID")=5 then
	component="Topper"
	model=rs("toppertype")
	componentstyle=""
	ticking=rs("toppertickingoptions")
	if left(rs("topperwidth"),4)="Spec" then call getComponentWidthSpecialSizes(con, 5, pno, Width1)
	if left(rs("topperlength"),4)="Spec" then call getComponentLengthSpecialSizes(con, 5, pno, Length1)
	componentsize="w x l): " & rs("topperwidth") & " x " & rs("topperlength")
	if left(rs("topperwidth"),4)<>"Spec" then componentW1=rs("topperwidth")
	if left(rs("topperlength"),4)<>"Spec" then componentL1=rs("topperlength")
	if Width1<>"" then 
		componentsize=componentsize & vbnewline & "W: " & Width1 & "cm"
		componentW1=Width1 & "cm"
	end if
	if Length1<>"" then 
		componentsize=componentsize & " x L: " & Length1 & "cm"
		componentL1=Length1 & "cm"
	end if

end if
if rs("componentID")=6 then
	component="Valance"
	model=rs("valancefabricchoice")
	componentstyle=rs("headboardfabric")
	ticking=""
	componentsize="(w x l): " & rs("valancewidth") & " x " & rs("valancelength") & ". Drop: " & rs("valancedrop")
	componentW1=rs("valancewidth")
	componentW2=rs("valancelength")
end if
if rs("componentID")=7 then
	component="Legs"
	model=rs("legstyle")
	componentstyle=rs("legfinish")
	ticking=""
	if left(rs("legheight"),4)="Spec" then call getComponentWidthSpecialSizes(con, 7, pno, Width1)
	if rs("legheight")<>"" then componentsize="Height: " & rs("legheight") else componentsize=""
	if left(rs("legheight"),4)<>"Spec" then componentW1=rs("legheight")
	if Width1<>"" then 
		componentsize=componentsize & vbnewline & "Special Height: " & Width1 & "cm"
		componentW1=Width1 & "cm"
	end if
end if
if rs("componentID")=8 then
	component="Headboard"
	model=rs("headboardstyle")
	componentstyle=rs("headboardfabric")
	ticking=""
	componentsize="(w x h): " & rs("headboardwidth") & " x " & rs("headboardheight")
	componentW1=rs("headboardwidth")
	componentL1=rs("headboardheight")
end if
'if rs("componentID")=9 then
'	component="Accessories"
'	model="Acc"
	'componentstyle=""
'end if
productiondate=rs("productiondate")
etadate=rs("deliverydate")
if rs("overseasorder")="y" then 
	sql2="SELECT * FROM exportlinks E, exportcollshowrooms L, Exportcollections C where E.componentid=" & rs("componentid") & " and E.linkscollectionid=L.exportCollshowroomsID and E.purchase_no=" & pno & " and L.exportCollectionID = C.exportCollectionsID"
	'response.Write("sql=" & sql2)
	Set rs2 = getMysqlQueryRecordSet(sql2, con)
	if not rs2.eof then
	etadate=rs2("collectiondate")
	end if
	rs2.close
	set rs2=nothing
end if
excelLine = """" & rs("order_number") & """,""" & component & """,""" & model & """,""" & componentstyle & """,""" & ticking & """,""" & componentsize & """,""" & componentW1 & """,""" & componentL1 & """,""" & componentW2 & """,""" & componentL2 & """,""" & productiondate & """,""" & etadate & """"


tempfile.WriteLine(excelLine)

rs.movenext
loop
rs.close
set rs=nothing

'sql="Select * from orderaccessory O, purchase P where P.purchase_no=O.purchase_no and (P.cancelled is Null or P.cancelled='n') and P.code<>15919 and O.delivered is null"
'Set rs = getMysqlQueryRecordSet(sql, con)

'Do until rs.eof
'	component="Accessories"
'	model=rs("description")
	'componentstyle=rs("design")
	'componentsize=rs("size")
'	ticking=""
'	productiondate=""
'	etadate=rs("eta")
'excelLine = """" & rs("order_number") & """,""" & component & """,""" & model & """,""" & componentstyle & """,""" & ticking & """,""" & componentsize & """,""" & componentW1 & """,""" & componentL1 & """,""" & componentW2 & """,""" & componentL2 & """,""" & productiondate & """,""" & etadate & """"


'tempfile.WriteLine(excelLine)

'rs.movenext
'loop
'rs.close
'set rs=nothing

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
