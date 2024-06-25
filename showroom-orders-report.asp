<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR, SALES"

%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->

<%'restrict user access to administrator and one user!
if userHasRole("ADMINISTRATOR") or  retrieveUserID()=90 Then%>

<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, dateasc, orderasc, customerasc, coasc, datefrom, datefromstr, datetostr, dateto, dateto1, user, rs2, rs3, receiptasc, amttotal, currencysym, ordervaltotal, totalpayments, totalos, location, payasc, matt1TOTAL, matt2TOTAL, matt3TOTAL, matt4TOTAL, mattFrenchTOTAL, mattStateTOTAL, base1TOTAL, base2TOTAL, base3TOTAL, base4TOTAL, basePegTOTAL, basePlatTOTAL, baseSlimTOTAL, baseStateTOTAL, cwtopperTOTAL, hcatopperTOTAL, hwtopperTOTAL, cwtopperonlyTOTAL, hcatopperonlyTOTAL, hwtopperonlyTOTAL, legsTOTAL, hbTOTAL, hide, locationname, recno, sql1, sql2
Dim matt1IdTOTAL, matt2IdTOTAL, matt3IdTOTAL, matt4IdTOTAL, mattFrenchIdTOTAL, mattStateIdTOTAL, base1IdTOTAL, base2IdTOTAL, base3IdTOTAL, base4IdTOTAL, basePegIdTOTAL, basePlatIdTOTAL, baseSlimIdTOTAL, baseStateIdTOTAL, cwtopperIdTOTAL, hcatopperIdTOTAL, hwtopperIdTOTAL, cwtopperonlyIdTOTAL, hcatopperonlyIdTOTAL, hwtopperonlyIdTOTAL, legsIdTOTAL, hbIdTOTAL
Dim showroomOrderTOTAL, showroomOrderTOTALIds, mattOtherTOTAL, mattOtherTOTALIds, baseOtherTOTAL, baseOtherTOTALIds, topperOtherTOTAL,topperOtherTOTALIds

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

matt1IdTOTAL="" 
matt2IdTOTAL=""
matt3IdTOTAL=""
matt4IdTOTAL=""
mattFrenchIdTOTAL=""
mattStateIdTOTAL=""
base1IdTOTAL=""
base2IdTOTAL=""
base3IdTOTAL=""
base4IdTOTAL=""
basePegIdTOTAL=""
basePlatIdTOTAL=""
baseSlimIdTOTAL=""
baseStateIdTOTAL=""
cwtopperIdTOTAL=""
hcatopperIdTOTAL=""
hwtopperIdTOTAL=""
cwtopperonlyIdTOTAL=""
hcatopperonlyIdTOTAL=""
hwtopperonlyIdTOTAL=""
legsIdTOTAL=""
hbIdTOTAL=""

Dim i
Dim allcountries
submit=Request("submit") 
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

	
	ReDim countryarray(ncountries), matt1(ncountries), matt1Ids(ncountries), matt2(ncountries), matt2Ids(ncountries), matt3(ncountries), matt3Ids(ncountries), matt4(ncountries), matt4Ids(ncountries), mattFrench(ncountries), mattFrenchIds(ncountries), mattState(ncountries), mattStateIds(ncountries), base1(ncountries), base1Ids(ncountries), base2(ncountries), base2Ids(ncountries), base3(ncountries), base3Ids(ncountries), base4(ncountries), base4Ids(ncountries), basePeg(ncountries), basePegIds(ncountries), basePlat(ncountries), basePlatIds(ncountries), baseSlim(ncountries), baseSlimIds(ncountries), baseState(ncountries), baseStateIds(ncountries), cwtopper(ncountries), cwtopperIds(ncountries), hcatopper(ncountries), hcatopperIds(ncountries), hwtopper(ncountries), hwtopperIds(ncountries), cwtopperonly(ncountries), cwtopperonlyIds(ncountries), hcatopperonly(ncountries), hcatopperonlyIds(ncountries), hwtopperonly(ncountries), hwtopperonlyIds(ncountries), legs(ncountries), legsIds(ncountries), hb(ncountries), hbIds(ncountries)
	ReDim  mattOther(ncountries), mattOtherIds(ncountries), baseOther(ncountries), baseOtherIds(ncountries), topperOther(ncountries),topperOtherIds(ncountries), topperOnlyOther(ncountries),topperOnlyOtherIds(ncountries),legsOther(ncountries),legsOtherIds(ncountries), hbOther(ncountries), hbOtherIds(ncountries)
	ReDim countrynamearray(ncountries),allLocalOrders(ncountries),allLocalOrderIds(ncountries)
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
matt1Ids(i)=""
matt2Ids(i)=""
matt3Ids(i)=""
matt4Ids(i)=""
mattFrenchIds(i)=""
mattStateIds(i)=""
base1Ids(i)=""
base2Ids(i)=""
base3Ids(i)=""
base4Ids(i)=""
basePegIds(i)=""
basePlatIds(i)=""
baseSlimIds(i)=""
baseStateIds(i)=""
cwtopperIds(i)=""
hcatopperIds(i)=""
hwtopperIds(i)=""
cwtopperonlyIds(i)=""
hcatopperonlyIds(i)=""
hwtopperonlyIds(i)=""
legsIds(i)=""
hbIds(i)=""
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
	sql="Select count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.idlocation"
	else
	sql="Select count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.idlocation"
	end if

                        Set rs = getMysqlQueryRecordSet("SET SESSION group_concat_max_len=32000000;" , con)
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						allLocalOrders(i)=rs("n") 
						allLocalOrderIds(i)=rs("ids")
						rs.movenext
						loop
						rs.close
						set rs=nothing
	if location="all" or location="allplus" then
	sql="Select P.savoirmodel, count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.mattressrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.savoirmodel"
	else
	sql="Select P.savoirmodel, count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.mattressrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.savoirmodel"
	end if

                        Set rs = getMysqlQueryRecordSet("SET SESSION group_concat_max_len=32000000;" , con)
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("savoirmodel")="No. 1" then 
							matt1(i)=rs("n") 
							matt1Ids(i)=rs("ids")
						ElseIf rs("savoirmodel")="No. 2" then 
							matt2(i)=rs("n")
							matt2Ids(i)=rs("ids")
						ElseIf rs("savoirmodel")="No. 3" then 
							matt3(i)=rs("n")
							matt3Ids(i)=rs("ids")
						ElseIf rs("savoirmodel")="No. 4" then 
							matt4(i)=rs("n")
							matt4Ids(i)=rs("ids")
						ElseIf rs("savoirmodel")="French Mattress" then 
							mattFrench(i)=rs("n")
							mattFrenchIds(i)=rs("ids")
						ElseIf rs("savoirmodel")="State" then 
							mattState(i)=rs("n")
							mattStateIds(i)=rs("ids")
						Else
							mattOther(i)=rs("n")
							mattOtherIds(i)=rs("ids")
						End If
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
	if location="all" or location="allplus" then
	sql="Select P.basesavoirmodel, count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.baserequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.basesavoirmodel"
	else
	sql="Select P.basesavoirmodel, count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.baserequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.basesavoirmodel"
	end if

                        Set rs = getMysqlQueryRecordSet("SET SESSION group_concat_max_len=32000000;" , con)
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof						
						if rs("basesavoirmodel")="No. 1" then 
							base1(i)=rs("n")
							base1Ids(i)=rs("ids")
						ElseIf rs("basesavoirmodel")="No. 2" then 
							base2(i)=rs("n")
							base2Ids(i)=rs("ids")
						ElseIf rs("basesavoirmodel")="No. 3" then 
							base3(i)=rs("n")
							base3Ids(i)=rs("ids")
						ElseIf rs("basesavoirmodel")="No. 4" then 
							base4(i)=rs("n")
							base4Ids(i)=rs("ids")
						ElseIf rs("basesavoirmodel")="Pegboard" then 
							basePeg(i)=rs("n")
							basePegIds(i)=rs("ids")
						ElseIf rs("basesavoirmodel")="Platform Base" then 
							basePlat(i)=rs("n")
							basePlatIds(i)=rs("ids")
						ElseIf rs("basesavoirmodel")="Savoir Slim" then 
							baseSlim(i)=rs("n")
							baseSlimIds(i)=rs("ids")
						ElseIf rs("basesavoirmodel")="State" then 
							baseState(i)=rs("n")
							baseStateIds(i)=rs("ids")
						Else
							baseOther(i)=rs("n")
							baseOtherIds(i)=rs("ids")
						End If
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
						
	if location="all" or location="allplus" then
	sql="Select P.toppertype, count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (P.mattressrequired='y' or baserequired='y') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	else
	sql="Select P.toppertype, count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (P.mattressrequired='y' or baserequired='y') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	end if

                        Set rs = getMysqlQueryRecordSet("SET SESSION group_concat_max_len=32000000;" , con)
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof						
						if rs("toppertype")="CW Topper" then 
							cwtopper(i)=rs("n")
							cwtopperIds(i)=rs("ids")
						ElseIf rs("toppertype")="HCa Topper" then 
							hcatopper(i)=rs("n")
							hcatopperIds(i)=rs("ids")
						ElseIf rs("toppertype")="HW Topper" then 
							hwtopper(i)=rs("n")
							hwtopperIds(i)=rs("ids")
						Else
							topperOther(i)=rs("n")
							topperOtherIds(i)=rs("ids")
						End If
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
	if location="all" or location="allplus" then
	sql="Select P.toppertype, count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (mattressrequired='n' and baserequired='n') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	else
	sql="Select P.toppertype, count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (mattressrequired='n' and baserequired='n') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	end if

                        Set rs = getMysqlQueryRecordSet("SET SESSION group_concat_max_len=32000000;" , con)
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof						
						if rs("toppertype")="CW Topper" then 
							cwtopperonly(i)=rs("n")
							cwtopperonlyIds(i)=rs("ids")
						End If
						if rs("toppertype")="HCa Topper" then 
							hcatopperonly(i)=rs("n")
							hcatopperonlyIds(i)=rs("ids")
						End If
						if rs("toppertype")="HW Topper" then 
							hwtopperonly(i)=rs("n")
							hwtopperonlyIds(i)=rs("ids")
						End If
						rs.movenext
						loop
						rs.close
						set rs=nothing

	if location="all" or location="allplus" then
	sql="Select count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.legsrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	else
	sql="Select count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.legsrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	end if

                        Set rs = getMysqlQueryRecordSet("SET SESSION group_concat_max_len=32000000;" , con)
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof	
						legs(i)=rs("n")
						legsIds(i)=rs("ids")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
	if location="all" or location="allplus" then
	sql="Select count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.headboardrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	else
	sql="Select count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.headboardrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	end if

                        Set rs = getMysqlQueryRecordSet("SET SESSION group_concat_max_len=32000000;" , con)
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof						
						hb(i)=rs("n")
						hbIds(i)=rs("ids")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
	next
	
	if location="all" or location="allplus" then	
	'totals sql
	
	sql="Select count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where (P.cancelled is Null or P.cancelled='n') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"


                        Set rs = getMysqlQueryRecordSet("SET SESSION group_concat_max_len=32000000;" , con)
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						showroomOrderTOTAL=rs("n") 
						showroomOrderTOTALIds=rs("ids")
						rs.movenext
						loop
						rs.close
						set rs=nothing
	sql="SELECT P.savoirmodel, count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.mattressrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.savoirmodel"

	
							Set rs = getMysqlQueryRecordSet("SET SESSION group_concat_max_len=32000000;" , con)
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof
							if rs("savoirmodel")="No. 1" then 
								matt1TOTAL=rs("n")
								matt1IdTOTAL=rs("ids")
							ElseIf rs("savoirmodel")="No. 2" then 
								matt2TOTAL=rs("n")
								matt2IdTOTAL=rs("ids")
							ElseIf rs("savoirmodel")="No. 3" then 
								matt3TOTAL=rs("n")
								matt3IdTOTAL=rs("ids")
							ElseIf rs("savoirmodel")="No. 4" then 
								matt4TOTAL=rs("n")
								matt4IdTOTAL=rs("ids")
							ElseIf rs("savoirmodel")="French Mattress" then 
								mattFrenchTOTAL=rs("n")
								mattFrenchIdTOTAL=rs("ids")
							ElseIf rs("savoirmodel")="State" then 
								mattStateTOTAL=rs("n")
								mattStateIdTOTAL=rs("ids")
							Else
								mattOtherTOTAL=rs("n")
								mattOtherTOTALIds=rs("ids")
							End If
							rs.movenext
							loop
							rs.close
							set rs=nothing
							
	sql="Select P.basesavoirmodel, count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.baserequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.basesavoirmodel"
	
							Set rs = getMysqlQueryRecordSet("SET SESSION group_concat_max_len=32000000;" , con)
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof						
							if rs("basesavoirmodel")="No. 1" then 
								base1TOTAL=rs("n")
								base1IdTOTAL=rs("ids")
							ElseIf rs("basesavoirmodel")="No. 2" then 
								base2TOTAL=rs("n")
								base2IdTOTAL=rs("ids")
							ElseIf rs("basesavoirmodel")="No. 3" then 
								base3TOTAL=rs("n")
								base3IdTOTAL=rs("ids")
							ElseIf rs("basesavoirmodel")="No. 4" then 
								base4TOTAL=rs("n")
								base4IdTOTAL=rs("ids")
							ElseIf rs("basesavoirmodel")="Pegboard" then 
								basePegTOTAL=rs("n")
								basePegIdTOTAL=rs("ids")
							ElseIf rs("basesavoirmodel")="Platform Base" then 
								basePlatTOTAL=rs("n")
								basePlatIdTOTAL=rs("ids")
							ElseIf rs("basesavoirmodel")="Savoir Slim" then 
								baseSlimTOTAL=rs("n")
								baseSlimIdTOTAL=rs("ids")
							ElseIf rs("basesavoirmodel")="State" then 
								baseStateTOTAL=rs("n")
								baseStateIdTOTAL=rs("ids")
							Else
								baseOtherTOTAL=rs("n")
								baseOtherTOTALIds=rs("ids")
							End If
							rs.movenext
							loop
							rs.close
							set rs=nothing
							
	sql="Select P.toppertype, count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (P.mattressrequired='y' or baserequired='y') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	
							Set rs = getMysqlQueryRecordSet("SET SESSION group_concat_max_len=32000000;" , con)
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof						
							if rs("toppertype")="CW Topper" then 
								cwtopperTOTAL=rs("n")
								cwtopperIdTOTAL=rs("ids")
							ElseIf rs("toppertype")="HCa Topper" then 
								hcatopperTOTAL=rs("n")
								hcatopperIdTOTAL=rs("ids")
							ElseIf rs("toppertype")="HW Topper" then 
								hwtopperTOTAL=rs("n")
								hwtopperIdTOTAL=rs("ids")
							Else
								topperOtherTOTAL=rs("n")
								topperOtherTOTALIds=rs("ids")
							End If
							rs.movenext
							loop
							rs.close
							set rs=nothing
							
	sql="Select P.toppertype, count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (mattressrequired='n' and baserequired='n') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	
							Set rs = getMysqlQueryRecordSet("SET SESSION group_concat_max_len=32000000;" , con)
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof						
							if rs("toppertype")="CW Topper" then 
								cwtopperonlyTOTAL=rs("n")
								cwtopperonlyIdTOTAL=rs("ids")
							End If
							if rs("toppertype")="HCa Topper" then 
								hcatopperonlyTOTAL=rs("n")
								hcatopperonlyIdTOTAL=rs("ids")
							End If
							if rs("toppertype")="HW Topper" then 
								hwtopperonlyTOTAL=rs("n")
								hwtopperonlyIdTOTAL=rs("ids")
							End If
							rs.movenext
							loop
							rs.close
							set rs=nothing
	
	sql="Select count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.legsrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	
							Set rs = getMysqlQueryRecordSet("SET SESSION group_concat_max_len=32000000;" , con)
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof						
							legsTOTAL=rs("n")
							legsIdTOTAL=rs("ids")
							rs.movenext
							loop
							rs.close
							set rs=nothing
							
	sql="Select count(*) as n, GROUP_CONCAT(CONVERT(PURCHASE_No, CHAR(10)) SEPARATOR ',') AS ids from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.headboardrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	
							Set rs = getMysqlQueryRecordSet("SET SESSION group_concat_max_len=32000000;" , con)
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof						
							hbTOTAL=rs("n")
							hbIdTOTAL=rs("ids")
							rs.movenext
							loop
							rs.close
							set rs=nothing
										
	end if
end if
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

<script src="scripts/keepalive.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
<script>
$(function() {
var year = new Date().getFullYear();

var dateFormat = $( "#datefrom" ).datepicker( "option", "dateFormat" );	
$( "#datefrom" ).datepicker({
dateFormat: "dd/mm/yy",
changeMonth: true,
yearRange: "-21:+0",
changeYear: true
});
$( "#datefrom" ).datepicker( "option", "dateFormat", "dd/mm/yy" );

$( "#datefrom" ).datepicker( "option", "dateFormat", "dd/mm/yy" );

$( "#datefrom" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#dateto" ).datepicker({
dateFormat: "dd/mm/yy",
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
$( "#dateto" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});

</script>
<%if location<>"all" and location<>"allplus" then
hide="hide"%>
<style>
.hide {display:none;}

</style>
<%end if%>
</head>
<body>

<div class="containerfull">
<!-- #include file="header.asp" -->
	
<form action="showroom-orders-report.asp" method="post" name="form1">					  
    <div class="contentfull brochure">
			    <div class="one-col head-col">
			<p>Showroom Orders Report</p>
			<table border="0" align="center" cellpadding="5" cellspacing="2">
					    <tr>
					      <td><label for="datefrom" id="surname"><strong>Date of Order Start :</strong><br>
		  <input name="datefrom" type="text" class="text" id="datefrom" value="<%=request("datefrom")%>" size="10" /></label></td>
					      <td><strong>Date of Order End: </strong><br>
                          <input name="dateto" type="text" class="text" id="dateto" size="10" value="<%=request("dateto")%>" /></td>
					      <td> <%Dim optionselected
                                    sql = "Select * from location where retire<>'y' order by adminheading"
                                    Set rs = getMysqlQueryRecordSet(sql, con)
                                    %>

                                    <select name = "location" size = "1" class = "formtext" id = "location">
                                    <%optionselected=""
									if location="all" then optionselected="selected"%>
                                   	  <option value = "all" <%=optionselected%>>Current Showrooms</option>
                                      <%optionselected=""
									  if location="allplus" then optionselected="selected"%>
                                      <option value = "allplus" <%=optionselected%>>Current & Retired</option>
                                        
                                        <%
                                        do until rs.EOF
										optionselected=""
                                        if locationname=rs("adminheading") then optionselected="selected"%>

                                      <option value = "<%=rs("idlocation")%>" <%=optionselected%>><%=rs("adminheading")%></option>
                                        <%
                                        rs.movenext
                                        loop
                                        rs.Close
                                        Set rs = Nothing
                                        %>
                                    </select>&nbsp;</td>
              </tr>
                      
					    <tr>
					      <td colspan="3" align="left">				          
					        <input type = "submit" name = "submitcsv" value = "Download CSV" id = "submitcsv"
                                        class = "button" onClick="return setFormAction('csv')" />
					        <input type = "submit" name = "submit" value = "Search" id = "submit"
                                        class = "button" onClick="return setFormAction('')" />
					      </td>
	      </tr>
			      </table>
<%if submit<>"" then%>				
          <p>&nbsp;</p>
          <p align="center">Dates: From <%=request("datefrom")%> to <%=request("dateto")%><br>
          </p>
<table border="0" cellspacing="3" cellpadding="1" align="center">
<%if location="all" or location="allplus" then%>
  <tr>
    <td>&nbsp;</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><strong>
<%=countrynamearray(i)%>
</strong></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><strong>TOTAL</strong></td>
    </tr>
<%else%>
<td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><strong><%=locationname%></strong></td>
    <td>&nbsp;</td>
<%end if%>
  <tr>
    <td><strong>Showroom Total Orders</strong></td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if allLocalOrders(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=allLocalOrderIds(i)%>"><%=allLocalOrders(i)%></a><%else%><%=allLocalOrders(i)%><%end if%></td>
    <%next%>
	<td bgcolor="#FFFFFF" class="<%=hide%>"><%if showroomOrderTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=showroomOrderTOTALIds%>"><%=showroomOrderTOTAL%></a><%else%><%=showroomOrderTOTAL%><%end if%></td>    
  </tr>
  <tr>
    <td>&nbsp;</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>">&nbsp;</td>
    </tr>
  <tr>
  <tr>
    <td><strong>Mattresses</strong></td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"></td>
    </tr>
  <tr>
    <td>No. 1</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if matt1(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=matt1Ids(i)%>"><%=matt1(i)%></a><%else%><%=matt1(i)%><%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if matt1TOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=matt1IdTOTAL%>"><%=matt1TOTAL%></a><%else%><%=matt1TOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>No. 2</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if matt2(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=matt2Ids(i)%>"><%=matt2(i)%></a><%else%><%=matt2(i)%><%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if matt2TOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=matt2IdTOTAL%>"><%=matt2TOTAL%></a><%else%><%=matt2TOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>No. 3</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if matt3(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=matt3Ids(i)%>"><%=matt3(i)%></a><%else%><%=matt3(i)%><%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if matt3TOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=matt3IdTOTAL%>"><%=matt3TOTAL%></a><%else%><%=matt3TOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>No. 4</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if matt4(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=matt4Ids(i)%>"><%=matt4(i)%></a><%else%><%=matt4(i)%><%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if matt4TOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=matt4IdTOTAL%>"><%=matt4TOTAL%></a><%else%><%=matt4TOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>French Mattress</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if mattFrench(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=mattFrenchIds(i)%>"><%=mattFrench(i)%></a><%else%><%=mattFrench(i)%><%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if mattFrenchTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=mattFrenchIdTOTAL%>"><%=mattFrenchTOTAL%></a><%else%><%=mattFrenchTOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>State</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if mattState(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=mattStateIds(i)%>"><%=mattState(i)%></a><%else%><%=mattState(i)%><%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if mattStateTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=mattStateIdTOTAL%>"><%=mattStateTOTAL%></a><%else%><%=mattStateTOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>Other</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if mattOther(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=mattOtherIds(i)%>"><%=mattOther(i)%></a><%else%><%=mattOther(i)%><%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if mattOtherTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=mattOtherTOTALIds%>"><%=mattOtherTOTAL%></a><%else%><%=mattOtherTOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>">&nbsp;</td>
    </tr>
  <tr>
    <td><strong>Box Springs</strong></td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"></td>
    </tr>
  <tr>
    <td>No. 1</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if base1(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=base1Ids(i)%>"><%=base1(i)%>&nbsp;</a><%else%><%=base1(i)%>&nbsp;<%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if base1TOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=base1IdTOTAL%>"><%=base1TOTAL%></a><%else%><%=base1TOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>No. 2</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if base2(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=base2Ids(i)%>"><%=base2(i)%>&nbsp;</a><%else%><%=base2(i)%>&nbsp;<%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if base2TOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=base2IdTOTAL%>"><%=base2TOTAL%></a><%else%><%=base2TOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>No. 3</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if base3(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=base2Ids(i)%>"><%=base3(i)%>&nbsp;</a><%else%><%=base3(i)%>&nbsp;<%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if base3TOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=base3IdTOTAL%>"><%=base3TOTAL%></a><%else%><%=base3TOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>No. 4</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if base4(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=base4Ids(i)%>"><%=base4(i)%>&nbsp;</a><%else%><%=base4(i)%>&nbsp;<%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if base4TOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=base4IdTOTAL%>"><%=base4TOTAL%></a><%else%><%=base4TOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>Pegboard</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if basePeg(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=basePegIds(i)%>"><%=basePeg(i)%>&nbsp;</a><%else%><%=basePeg(i)%>&nbsp;<%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if basePegTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=basePegIdTOTAL%>"><%=basePegTOTAL%></a><%else%><%=basePegTOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>Platform</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if basePlat(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=basePlatIds(i)%>"><%=basePlat(i)%>&nbsp;</a><%else%><%=basePlat(i)%>&nbsp;<%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if basePlatTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=basePlatIdTOTAL%>"><%=basePlatTOTAL%></a><%else%><%=basePlatTOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>Savoir Slim</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if baseSlim(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=baseSlimIds(i)%>"><%=baseSlim(i)%>&nbsp;</a><%else%><%=baseSlim(i)%>&nbsp;<%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if baseSlimTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=baseSlimIdTOTAL%>"><%=baseSlimTOTAL%></a><%else%><%=baseSlimTOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>State</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if baseState(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=baseStateIds(i)%>"><%=baseState(i)%>&nbsp;</a><%else%><%=baseState(i)%>&nbsp;<%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if baseStateTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=baseStateIdTOTAL%>"><%=baseStateTOTAL%></a><%else%><%=baseStateTOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>Other</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if baseOther(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=baseOtherIds(i)%>"><%=baseOther(i)%></a><%else%><%=baseOther(i)%><%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if baseOtherTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=baseOtherTOTALIds%>"><%=baseOtherTOTAL%></a><%else%><%=baseOtherTOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"></td>
    </tr>
  <tr>
    <td><strong>Toppers Linked with mattress or base</strong></td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"></td>
    </tr>
  <tr>
    <td>HCA</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if hcatopper(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=hcatopperIds(i)%>"><%=hcatopper(i)%>&nbsp;</a><%else%><%=hcatopper(i)%>&nbsp;<%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if hcatopperTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=hcatopperIdTOTAL%>"><%=hcatopperTOTAL%></a><%else%><%=hcatopperTOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>HW</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if hwtopper(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=hwtopperIds(i)%>"><%=hwtopper(i)%>&nbsp;</a><%else%><%=hwtopper(i)%>&nbsp;<%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if hwtopperTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=hwtopperIdTOTAL%>"><%=hwtopperTOTAL%></a><%else%><%=hwtopperTOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>CW</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if cwtopper(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=cwtopperIds(i)%>"><%=cwtopper(i)%>&nbsp;</a><%else%><%=cwtopper(i)%>&nbsp;<%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if cwtopperTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=cwtopperIdTOTAL%>"><%=cwtopperTOTAL%></a><%else%><%=cwtopperTOTAL%><%end if%></td>
    </tr>
    <tr>
    <td>Other</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if topperOther(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=topperOtherIds(i)%>"><%=topperOther(i)%></a><%else%><%=topperOther(i)%><%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if topperOtherTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=topperOtherTOTALIds%>"><%=topperOtherTOTAL%></a><%else%><%=topperOtherTOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"></td>
    </tr>
  <tr>
    <td><strong>Toppers only (no base or mattress)</strong></td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"></td>
    </tr>
  <tr>
    <td>HCA</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if hcatopperonly(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=hcatopperonlyIds(i)%>"><%=hcatopperonly(i)%>&nbsp;</a><%else%><%=hcatopperonly(i)%>&nbsp;<%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if hcatopperonlyTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=hcatopperonlyIdTOTAL%>"><%=hcatopperonlyTOTAL%></a><%else%><%=hcatopperonlyTOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>HW</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if hwtopperonly(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=hwtopperonlyIds(i)%>"><%=hwtopperonly(i)%>&nbsp;</a><%else%><%=hwtopperonly(i)%>&nbsp;<%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if hwtopperonlyTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=hwtopperonlyIdTOTAL%>"><%=hwtopperonlyTOTAL%></a><%else%><%=hwtopperonlyTOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>CW</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if cwtopperonly(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=cwtopperonlyIds(i)%>"><%=cwtopperonly(i)%>&nbsp;</a><%else%><%=cwtopperonly(i)%>&nbsp;<%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if cwtopperonlyTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=cwtopperonlyIdTOTAL%>"><%=cwtopperonlyTOTAL%></a><%else%><%=cwtopperonlyTOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"></td>
    </tr>
  <tr>
    <td><strong>Legs</strong></td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if legs(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=legsIds(i)%>"><%=legs(i)%>&nbsp;</a><%else%><%=legs(i)%>&nbsp;<%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if legsTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=legsIdTOTAL%>"><%=legsTOTAL%></a><%else%><%=legsTOTAL%><%end if%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"></td>
    </tr>
  <tr>
    <td><strong>Headboards</strong></td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%if hb(i)<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=hbIds(i)%>"><%=hb(i)%>&nbsp;</a><%else%><%=hb(i)%>&nbsp;<%end if%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%if hbTOTAL<>"0" then%><a href="#" onclick="orderDetails(this);return false;" data-ids="<%=hbIdTOTAL%>"><%=hbTOTAL%></a><%else%><%=hbTOTAL%><%end if%></td>
    </tr>
          </table>
          <p>&nbsp;</p>
          <p>
            <%end if%>
          </p>
        </div>
  </div>
<div>
</div>
        </form>
</body>
</html>

 <%Con.Close
Set Con = Nothing%> 
<%end if%>
<!-- #include file="common/logger-out.inc" -->
<script Language="JavaScript" type="text/javascript">

	function setFormAction(actionName) {
		if (actionName == "csv") {
			document.form1.action = "showroom-orders-csv.asp"
		} else {
			document.form1.action = "showroom-orders-report.asp"
		}
		return true;
	}
	function orderDetails(element){
		var ids = element.getAttribute("data-ids");
		var tempForm = document.createElement('form');
		tempForm.id = "tempForm";
		tempForm.target = "_blank";
		tempForm.method = "POST";
		tempForm.action = "/php/orderReport";
		var tempInput = document.createElement("input");
		tempInput.type = "text";
		tempInput.name = "ids";
		tempInput.value = ids;
		tempForm.appendChild(tempInput);
		document.body.appendChild(tempForm);
		tempForm.submit();
		var e = document.getElementById("tempForm");
		e.parentNode.removeChild(e);
	}

</script>
