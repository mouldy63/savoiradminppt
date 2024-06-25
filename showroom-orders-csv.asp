<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%'restrict user access to administrator and one user!
if userHasRole("ADMINISTRATOR") or  retrieveUserID()=90 Then%>
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, dateasc, orderasc, customerasc, coasc, datefrom, datefromstr, datetostr, dateto, dateto1, user, rs2, rs3, receiptasc, amttotal, currencysym, ordervaltotal, totalpayments, totalos, location, payasc, matt1TOTAL, matt2TOTAL, matt3TOTAL, matt4TOTAL, mattFrenchTOTAL, mattStateTOTAL, base1TOTAL, base2TOTAL, base3TOTAL, base4TOTAL, basePegTOTAL, basePlatTOTAL, baseSlimTOTAL, baseStateTOTAL, cwtopperTOTAL, hcatopperTOTAL, hwtopperTOTAL, cwtopperonlyTOTAL, hcatopperonlyTOTAL, hwtopperonlyTOTAL, legsTOTAL, hbTOTAL, hide, locationname, recno, sql1, sql2, excelLine
Session.LCID = 2057
Dim ncountries
locationname=""
hide=""
location=request("location")

Set Con = getMysqlConnection()
if location<>"all" and location<>"allplus" and location<>"" then
	Set rs = getMysqlQueryRecordSet("Select adminheading from location where idlocation=" & location , con)
	if not rs.eof then
	locationname=rs("adminheading")
	end if
	rs.close
	set rs=nothing
end if

matt1TOTAL=0 
matt2TOTAL=0
matt3TOTAL=0
matt4TOTAL=0
mattFrenchTOTAL=0
mattStateTOTAL=0
base1TOTAL=0
base2TOTAL=0
base3TOTAL=0
base4TOTAL=0
basePegTOTAL=0
basePlatTOTAL=0
baseSlimTOTAL=0
baseStateTOTAL=0
cwtopperTOTAL=0
hcatopperTOTAL=0
hwtopperTOTAL=0
cwtopperonlyTOTAL=0
hcatopperonlyTOTAL=0
hwtopperonlyTOTAL=0
legsTOTAL=0
hbTOTAL=0
Dim i
Dim allcountries
submit=Request("submitcsv") 
if submit<>"" then
allcountries="P.idlocation IN ("
if location="all" and location<>"" then
	sql="Select adminheading, idlocation from location where retire='n' order by adminheading"
end if
if location="allplus" and location<>"" then
	sql="Select adminheading, idlocation from location where adminheading is not null order by adminheading"
end if
if location<>"allplus" and location<>"all" and location<>"" then
	sql="Select adminheading, idlocation from location where idlocation =" & location
end if

	Set rs = getMysqlQueryRecordSet(sql, con)
	ncountries=rs.recordcount

	
	ReDim countryarray(ncountries), matt1(ncountries), matt2(ncountries), matt3(ncountries), matt4(ncountries), mattFrench(ncountries), mattState(ncountries), base1(ncountries), base2(ncountries), base3(ncountries), base4(ncountries), basePeg(ncountries), basePlat(ncountries), baseSlim(ncountries), baseState(ncountries), cwtopper(ncountries), hcatopper(ncountries), hwtopper(ncountries), cwtopperonly(ncountries), hcatopperonly(ncountries), hwtopperonly(ncountries), legs(ncountries), hb(ncountries)
	ReDim countrynamearray(ncountries)
	count=1
	Do until rs.eof
	countryarray(count) = rs("idlocation")
	countrynamearray(count)=rs("adminheading")
	count=count+1
	allcountries=allcountries & rs("idlocation") & ","
	rs.movenext
	loop
	rs.close
	set rs=nothing
	
	allcountries=left(allcountries, len(allcountries)-1) & ")"




for i=1 to ncountries
matt1(i)=0
matt2(i)=0
matt3(i)=0
matt4(i)=0
mattFrench(i)=0
mattState(i)=0
base1(i)=0
base2(i)=0
base3(i)=0
base4(i)=0
basePeg(i)=0
basePlat(i)=0
baseSlim(i)=0
baseState(i)=0
cwtopper(i)=0
hcatopper(i)=0
hwtopper(i)=0
cwtopperonly(i)=0
hcatopperonly(i)=0
hwtopperonly(i)=0
legs(i)=0
hb(i)=0

next




datefromstr=Request("datefrom")

If datefromstr <>"" then
datefrom=year(datefromstr) & "-" & month(datefromstr) & "-" & day(datefromstr)
end if
datetostr=Request("dateto")
If datetostr <>"" then
datetostr=DateAdd("d",1,datetostr)
dateto=year(datetostr) & "-" & month(datetostr) & "-" & day(datetostr)

end if

count=0


if location<>"all" and location<>"allplus" then ncountries=1
for i=1 to ncountries
	if location="all" or location="allplus" then
	sql="Select P.savoirmodel, count(*) as n from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.mattressrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.savoirmodel"
	else
	sql="Select P.savoirmodel, count(*) as n from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.mattressrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.savoirmodel"
	end if

                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("savoirmodel")="No. 1" then matt1(i)=rs("n")
						if rs("savoirmodel")="No. 2" then matt2(i)=rs("n")
						if rs("savoirmodel")="No. 3" then matt3(i)=rs("n")
						if rs("savoirmodel")="No. 4" then matt4(i)=rs("n")
						if rs("savoirmodel")="French Mattress" then mattFrench(i)=rs("n")
						if rs("savoirmodel")="State" then mattState(i)=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
	if location="all" or location="allplus" then
	sql="Select P.basesavoirmodel, count(*) as n from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.baserequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.basesavoirmodel"
	else
	sql="Select P.basesavoirmodel, count(*) as n from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.baserequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.basesavoirmodel"
	end if

                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof						
						if rs("basesavoirmodel")="No. 1" then base1(i)=rs("n")
						if rs("basesavoirmodel")="No. 2" then base2(i)=rs("n")
						if rs("basesavoirmodel")="No. 3" then base3(i)=rs("n")
						if rs("basesavoirmodel")="No. 4" then base4(i)=rs("n")
						if rs("basesavoirmodel")="Pegboard" then basePeg(i)=rs("n")
						if rs("basesavoirmodel")="Platform Base" then basePlat(i)=rs("n")
						if rs("basesavoirmodel")="Savoir Slim" then baseSlim(i)=rs("n")
						if rs("basesavoirmodel")="State" then baseState(i)=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
						
	if location="all" or location="allplus" then
	sql="Select P.toppertype, count(*) as n from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (P.mattressrequired='y' or baserequired='y') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	else
	sql="Select P.toppertype, count(*) as n from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (P.mattressrequired='y' or baserequired='y') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	end if

                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof						
						if rs("toppertype")="CW Topper" then cwtopper(i)=rs("n")
						if rs("toppertype")="HCa Topper" then hcatopper(i)=rs("n")
						if rs("toppertype")="HW Topper" then hwtopper(i)=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
	if location="all" or location="allplus" then
	sql="Select P.toppertype, count(*) as n from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (mattressrequired='n' and baserequired='n') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	else
	sql="Select P.toppertype, count(*) as n from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (mattressrequired='n' and baserequired='n') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	end if

                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof						
						if rs("toppertype")="CW Topper" then cwtopperonly(i)=rs("n")
						if rs("toppertype")="HCa Topper" then hcatopperonly(i)=rs("n")
						if rs("toppertype")="HW Topper" then hwtopperonly(i)=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing

	if location="all" or location="allplus" then
	sql="Select count(*) as n from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.legsrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	else
	sql="Select count(*) as n from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.legsrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	end if

                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof	
						legs(i)=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
	if location="all" or location="allplus" then
	sql="Select count(*) as n from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.headboardrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	else
	sql="Select count(*) as n from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.headboardrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	end if

                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof						
						hb(i)=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
	next
	
	if location="all" or location="allplus" then	
	'totals sql
	sql="Select P.savoirmodel, count(*) as n from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.mattressrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.savoirmodel"

	
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof
							if rs("savoirmodel")="No. 1" then matt1TOTAL=rs("n")
							if rs("savoirmodel")="No. 2" then matt2TOTAL=rs("n")
							if rs("savoirmodel")="No. 3" then matt3TOTAL=rs("n")
							if rs("savoirmodel")="No. 4" then matt4TOTAL=rs("n")
							if rs("savoirmodel")="French Mattress" then mattFrenchTOTAL=rs("n")
							if rs("savoirmodel")="State" then mattStateTOTAL=rs("n")
							rs.movenext
							loop
							rs.close
							set rs=nothing
							
	sql="Select P.basesavoirmodel, count(*) as n from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.baserequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.basesavoirmodel"
	
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof						
							if rs("basesavoirmodel")="No. 1" then base1TOTAL=rs("n")
							if rs("basesavoirmodel")="No. 2" then base2TOTAL=rs("n")
							if rs("basesavoirmodel")="No. 3" then base3TOTAL=rs("n")
							if rs("basesavoirmodel")="No. 4" then base4TOTAL=rs("n")
							if rs("basesavoirmodel")="Pegboard" then basePegTOTAL=rs("n")
							if rs("basesavoirmodel")="Platform Base" then basePlatTOTAL=rs("n")
							if rs("basesavoirmodel")="Savoir Slim" then baseSlimTOTAL=rs("n")
							if rs("basesavoirmodel")="State" then baseStateTOTAL=rs("n")
							rs.movenext
							loop
							rs.close
							set rs=nothing
							
	sql="Select P.toppertype, count(*) as n from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (P.mattressrequired='y' or baserequired='y') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof						
							if rs("toppertype")="CW Topper" then cwtopperTOTAL=rs("n")
							if rs("toppertype")="HCa Topper" then hcatopperTOTAL=rs("n")
							if rs("toppertype")="HW Topper" then hwtopperTOTAL=rs("n")
							rs.movenext
							loop
							rs.close
							set rs=nothing
							
	sql="Select P.toppertype, count(*) as n from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (mattressrequired='n' and baserequired='n') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof						
							if rs("toppertype")="CW Topper" then cwtopperonlyTOTAL=rs("n")
							if rs("toppertype")="HCa Topper" then hcatopperonlyTOTAL=rs("n")
							if rs("toppertype")="HW Topper" then hwtopperonlyTOTAL=rs("n")
							rs.movenext
							loop
							rs.close
							set rs=nothing
	
	sql="Select count(*) as n from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.legsrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof						
							legsTOTAL=rs("n")
							rs.movenext
							loop
							rs.close
							set rs=nothing
							
	sql="Select count(*) as n from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.headboardrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof						
							hbTOTAL=rs("n")
							rs.movenext
							loop
							rs.close
							set rs=nothing
										
	end if
end if


Dim filesys, tempfile, tempfolder, tempname, filename, objStream
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Showroom Orders Report")
tempfile.WriteLine("Dates: From " & request("datefrom") & " to " & request("dateto"))
if location="all" or location="allplus" then
	excelLine="""" & " " & ""","""
	for i=1 to ncountries
	excelLine=excelLine & countrynamearray(i) & ""","""
	next
	excelLine=excelLine & "TOTAL" & """"
	tempfile.WriteLine(excelLine)
	else
	excelLine="""" & " " & """,""" & locationname & """"
	tempfile.WriteLine(excelLine)
end if
tempfile.WriteLine("Mattresses")
excelLine="""" & "No. 1" & ""","""
for i=1 to ncountries
excelLine=excelLine & matt1(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & matt1TOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "No. 2" & ""","""
for i=1 to ncountries
excelLine=excelLine & matt2(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & matt2TOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "No. 3" & ""","""
for i=1 to ncountries
excelLine=excelLine & matt3(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & matt3TOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "No. 4" & ""","""
for i=1 to ncountries
excelLine=excelLine & matt4(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & matt4TOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "French Mattress" & ""","""
for i=1 to ncountries
excelLine=excelLine & mattFrench(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & mattFrenchTOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "State" & ""","""
for i=1 to ncountries
excelLine=excelLine & mattState(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & mattStateTOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
tempfile.WriteLine("Box Springs")
excelLine="""" & "No. 1" & ""","""
for i=1 to ncountries
excelLine=excelLine & base1(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & base1TOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "No. 2" & ""","""
for i=1 to ncountries
excelLine=excelLine & base2(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & base2TOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "No. 3" & ""","""
for i=1 to ncountries
excelLine=excelLine & base3(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & base3TOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "No. 4" & ""","""
for i=1 to ncountries
excelLine=excelLine & base4(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & base4TOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "Pegboard" & ""","""
for i=1 to ncountries
excelLine=excelLine & basePeg(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & basePegTOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "Platform" & ""","""
for i=1 to ncountries
excelLine=excelLine & basePlat(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & basePlatTOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "Savoir Slim" & ""","""
for i=1 to ncountries
excelLine=excelLine & baseSlim(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & baseSlimTOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "State" & ""","""
for i=1 to ncountries
excelLine=excelLine & baseState(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & baseStateTOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
tempfile.WriteLine("Toppers Linked with mattress or base")
excelLine="""" & "HCA" & ""","""
for i=1 to ncountries
excelLine=excelLine & hcatopper(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & hcatopperTOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "HW" & ""","""
for i=1 to ncountries
excelLine=excelLine & hwtopper(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & hwtopperTOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "CW" & ""","""
for i=1 to ncountries
excelLine=excelLine & cwtopper(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & cwtopperTOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
tempfile.WriteLine("Toppers only (no base or mattress)")
excelLine="""" & "HCA" & ""","""
for i=1 to ncountries
excelLine=excelLine & hcatopperonly(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & hcatopperonlyTOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "HW" & ""","""
for i=1 to ncountries
excelLine=excelLine & hwtopperonly(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & hwtopperonlyTOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "CW" & ""","""
for i=1 to ncountries
excelLine=excelLine & cwtopperonly(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & cwtopperonlyTOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "Legs" & ""","""
for i=1 to ncountries
excelLine=excelLine & legs(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & legsTOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)
excelLine="""" & "Headboards" & ""","""
for i=1 to ncountries
excelLine=excelLine & hb(i) & ""","""
next
if location="all" or location="allplus" then excelLine=excelLine & hbTOTAL & """" else excelLine=excelLine & """"
tempfile.WriteLine(excelLine)


tempfile.close

Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = 1
objStream.LoadFromFile(filename)

Response.ContentType = "application/csv"
Response.AddHeader "Content-Disposition", "attachment; filename=""report.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing



Con.Close
Set Con = Nothing
END IF%> 
