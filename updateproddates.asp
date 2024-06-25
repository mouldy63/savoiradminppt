<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="generalfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="clientAccessFuncs.asp" -->
<%
Dim Con
Set Con = getMysqlConnection()
if not isClientAllowedAccess(Con, "deliveries booked", false) then
	Response.Status = "403 Forbidden"
	response.end
end if
Dim postcode, postcodefull, rs, rs1, recordfound, id, rspostcode, submit, count, sql, sql2, msg, customerasc, orderasc, showr,  companyasc, bookeddate, productiondate, previousOrderNumber, acknowDateWarning, rs2, compstatus
dim matt_madeat, base_madeat, topper_madeat, headboard_madeat, legs_madeat, factory, bold
dim diff, factories, datenow, twoweeksdate, custname, madeat, hasLondonItems, compmadeat1, compmadeat3, compmadeat5, compmadeat8, compmadeat7, hasCardiffItems, dofweek,startweek,newweek, pnewweek, weekno, pweekno, weeknoadd, pweeknoadd, weekstarted, pweekstarted, data, pweekno2, weekno2, finishedComp1, finishedComp3, finishedComp5, finishedComp8, finishedComp7, ItemNotFinished, strdate, enddate, ItemsFinished, WoodworkNoItems, realproductiondate, weekNoToDisplay, realProdStartDate, realProdEndDate


sql="select * from Purchase Where completedorders='n' AND quote='n' AND completedorders='n' and orderonhold<>'y' and (cancelled is Null or cancelled='n') AND code<>15919 and code<>218766 and productiondate<>'' and (DeliveryDateConfirmed<>'y' or DeliveryDateConfirmed is Null) AND source_site='SB'  order by productiondate asc"
count=0
Set rs = getMysqlUpdateRecordSet(sql, con)
Do until rs.eof
	sql2="select * from QC_history_latest WHERE MadeAt=2 and purchase_no=" & rs("purchase_no") & " order by BCWexpected desc"
	Set rs1 = getMysqlQueryRecordSet(sql2, con)
	if not rs1.eof then
		if rs1("bcwexpected")<>"" then rs("LondonProductionDate")=rs1("bcwexpected")
		count=count+1
	end if
	rs1.close
	set rs1=nothing
	
	sql2="select * from QC_history_latest WHERE MadeAt=1 and purchase_no=" & rs("purchase_no") & " order by BCWexpected desc"
	Set rs1 = getMysqlQueryRecordSet(sql2, con)
	if not rs1.eof then
		if rs1("bcwexpected")<>"" then rs("CardiffProductionDate")=rs1("bcwexpected")
		count=count+1
	end if
	rs1.close
	set rs1=nothing
	rs.update
rs.movenext
loop

rs.close
set rs=nothing
Con.close
set Con=nothing
response.Write("no of items update=" & count)
%>


 
   