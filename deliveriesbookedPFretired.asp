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
Dim postcode, postcodefull, rs, recordfound, id, rspostcode, submit, count, sql, msg, customerasc, orderasc, showr,  companyasc, bookeddate, productiondate, previousOrderNumber, acknowDateWarning, rs2, compstatus
dim matt_madeat, base_madeat, topper_madeat, headboard_madeat, legs_madeat, factory, bold
dim diff, factories, datenow, twoweeksdate, custname, madeat, hasLondonItems, compmadeat1, compmadeat3, compmadeat5, compmadeat8, compmadeat7, hasCardiffItems, dofweek,startweek,newweek, pnewweek, weekno, pweekno, weeknoadd, pweeknoadd, weekstarted, pweekstarted, data, pweekno2, weekno2, finishedComp1, finishedComp3, finishedComp5, finishedComp8, finishedComp7, ItemNotFinished, strdate, enddate, ItemsFinished, ProductionFloorNoItems, realproductiondate


weekstarted=1
pweekstarted=1
pweekno=DatePart("ww", Now(), 2, 2)


madeat=CInt(request("madeat"))
'madeat=2

sql="Select ProductionFloorNoItems from manufacturedat where ManufacturedAtId=" & madeat
Set rs = getMysqlQueryRecordSet(sql, con)
ProductionFloorNoItems=rs("ProductionFloorNoItems")
rs.close
set rs=nothing

datenow=DateAdd ("d", 0, Date())
'dofweek=Weekday(datenow,0)
'startweek=7-dofweek
'newweek=DateAdd ("d", startweek, datenow)

twoweeksdate= DateAdd ("d", +14, Date())
datenow=toDbDate(datenow)
twoweeksdate=toDbDate(twoweeksdate)
showr=request("showr")
'productiondate=request("productiondate")
bookeddate=request("bookeddate")
companyasc=request("companyasc")
customerasc=request("customerasc")
orderasc=request("orderasc")
matt_madeat=request("matt_madeat")
base_madeat=request("base_madeat")
topper_madeat=request("topper_madeat")
headboard_madeat=request("headboard_madeat")
legs_madeat=request("legs_madeat")
factory=request("factory")
if factory = "" then factory=-1
factory = cint(factory)
msg=""
msg=Request("msg")
count=0
submit=Request("submit") 

postcodefull=Request("postcode")
postcode=Replace(postcodefull, " ", "")
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">

<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/extra.css" rel="Stylesheet" type="text/css" />
<link href="Styles/screenP.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script   
   src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js">
    </script>
<style>
.moveleft10 {
	position:relative;
	left: -10px;}
.lheight {
	clear:both;
	margin-top:20px;}
#bespoke {font-size:11px;}
#bespoke2 {font-size:10px;}
</style>



</head>
<body>

<div class="containerwide">

  <div class="one-col head-col">

<!--<form name="form1" method="post" action="">-->	
<br><h1 class="moveleft10">&nbsp;</h1><br><br>
<table width="100%" border="0" cellpadding="0" cellspacing="0" id="bespoke">
<%

Set Con = getMysqlConnection()


%>

<tr><td height="35" colspan="10" bgcolor="#999999">&nbsp;<br>  <strong>Production Date</strong><br>&nbsp;</td></tr>
<tr><td colspan="10"><hr></td></tr>
<%sql = "select * from address A, contact C, Purchase P, Location L Where P.code=A.code AND C.contact_no=P.contact_no AND P.completedorders='n' AND P.quote='n' AND P.completedorders='n' and P.orderonhold<>'y' and (P.cancelled is Null or P.cancelled='n') AND P.productiondate<>'' and (P.DeliveryDateConfirmed<>'y' or P.DeliveryDateConfirmed is Null) AND P.source_site='SB' and P.idlocation=L.idlocation order by P.productiondate asc " 

Set rs = getMysqlQueryRecordSet(sql, con)
Do until rs.eof
custname=""
if rs("title")<>"" then custname=custname & rs("title") & " "
if rs("first")<>"" then custname=custname & rs("first") & " "
if rs("surname")<>"" then custname=custname & rs("surname")

ItemsFinished="n"

compmadeat1=getComponentCurrentMadeAt(con, rs("purchase_no"), 1)
finishedcomp1=isCompFinished(con, rs("purchase_no"), 1)
compmadeat3=getComponentCurrentMadeAt(con, rs("purchase_no"), 3)
finishedcomp3=isCompFinished(con, rs("purchase_no"), 3)
compmadeat5=getComponentCurrentMadeAt(con, rs("purchase_no"), 5)
finishedcomp5=isCompFinished(con, rs("purchase_no"), 5)
compmadeat8=getComponentCurrentMadeAt(con, rs("purchase_no"), 8)
finishedcomp8=isCompFinished(con, rs("purchase_no"), 8)
compmadeat7=getComponentCurrentMadeAt(con, rs("purchase_no"), 7)
finishedcomp7=isCompFinished(con, rs("purchase_no"), 7)

hasLondonItems = false
hasCardiffItems = false
if (compmadeat1=1 and finishedcomp1="n") or (compmadeat3=1 and finishedcomp3="n") or (compmadeat5=1 and finishedcomp5="n") or (compmadeat8=1 and finishedcomp8="n") or (compmadeat7=1 and finishedcomp7="n") then
	hasCardiffItems = true
end if
if (compmadeat1=2 and finishedcomp1="n") or (compmadeat3=2 and finishedcomp3="n") or (compmadeat5=2 and finishedcomp5="n") or (compmadeat8=2 and finishedcomp8="n") or (compmadeat7=2 and finishedcomp7="n") then
	hasLondonItems = true
end if
ItemNotFinished=False
if finishedcomp1="n" or finishedcomp3="n" or finishedcomp5="n" or finishedcomp8="n" or finishedcomp7="n" then
	ItemNotFinished = true
end if


if (hasCardiffItems and madeat=1) or (hasLondonItems and madeat=2) then
realproductiondate=rs("productiondate")
productiondate=rs("productiondate")
productiondate=(DateAdd("d",-ProductionFloorNoItems,productiondate))
dofweek=Weekday(realproductiondate,0)

startweek=7-dofweek
pnewweek=DateAdd ("d", startweek, realproductiondate)

pweekno=DatePart("ww", realproductiondate, 2, 2)
strdate=FirstDayOfNextWeekN(pweekno2, realproductiondate)
strdate=Year(strdate) & "/" & month(strdate) & "/" & day(strdate)
enddate=FirstDayOfNextWeekN(pweekno, realproductiondate)
enddate=Year(enddate) & "/" & month(enddate) & "/" & day(enddate)
if pweekno<>pweekno2 then


response.Write("<tr><td height=""17"" colspan=""2"" bgcolor=""#999999"">Week No. " & pweekno & "</td><td colspan=""6"" bgcolor=""#999999"" align=""center"">" & getcomponentNoTobefinished(con, strdate, enddate, madeat) & " items to finish</td><td height=""17"" colspan=""2"" bgcolor=""#999999"">Production&nbsp;Date </td></tr>")

else
		response.Write("<tr><td colspan=10><hr style=""height:1px;border:none;color:#999999;background-color:#999999;""></td></tr>")
end if
'pnewweek=DateAdd ("d", 7, pnewweek)
pweekno2=pweekno	

%>


    <tr>
      <td width="4%" valign="top"><font size="+2"><%=rs("order_number")%></font></td>
      <td width="7%" valign="top" id="bespoke2"><%=left(custname,25)%><br>
      <%=left(rs("companyname"),25)%></td>
      <td width="6%" valign="top"id="bespoke2"><%=rs("customerreference")%></td>
      <td width="8%" valign="top"id="bespoke2"><%=rs("adminheading")%></td>
      <%if rs("savoirmodel")<>"" and NOT ISNULL(rs("savoirmodel")) and compmadeat1=madeat then
	 
	%>
      <td width="18%" valign="top"><span style="display:block;margin-bottom:-12px;margin-top:-5px;color:<%=getLockColourForStatus(getComponentStatusLatest(con, rs("purchase_no"), 1))%>"><%=rs("savoirmodel")%>Mattress</span><br>
      <font size="+3">
      
      <span style="white-space: pre;color:<%=getColourForEntry(con, rs("purchase_no"), "Cut", 1)%>">&#9608;</span>
	  <span style="white-space: pre;color:<%=getColourForEntry(con, rs("purchase_no"), "Machined", 1)%>">&#9608;</span>
      <span style="white-space: pre;color:<%=getColourForEntry(con, rs("purchase_no"), "springunitdate", 1)%>">&#9608;</span>
      <span style="white-space: pre;color:<%=getColourForEntry(con, rs("purchase_no"), "finished", 1)%>">&#9608;</span>
      </font></td>
      <%else%>
      <td width="1%" valign="top">&nbsp;</td>
      <%end if%>
      <%if rs("basesavoirmodel")<>"" and NOT ISNULL(rs("basesavoirmodel")) and compmadeat3=madeat   then
	    %>
      <td width="19%" valign="top"><span style="display:block;margin-bottom:-12px;margin-top:-5px;color:<%=getLockColourForStatus(getComponentStatusLatest(con, rs("purchase_no"), 3))%>"><%=rs("basesavoirmodel")%> Base</span><br>
      <font size="+3">
     <span style="white-space: pre;color:<%=getColourForEntry(con, rs("purchase_no"), "Cut", 3)%>">&#9608;</span>
      <span style="white-space: pre;color:<%=getColourForEntry(con, rs("purchase_no"), "Machined", 3)%>">&#9608;</span>
      <span style="white-space: pre;color:<%=getColourForEntry(con, rs("purchase_no"), "Framed", 3)%>">&#9608;</span>
      <span style="white-space: pre;color:<%=getColourForEntry(con, rs("purchase_no"), "prepped", 3)%>">&#9608;</span>
      <span style="white-space: pre;color:<%=getColourForEntry(con, rs("purchase_no"), "finished", 3)%>">&#9608;</span>
      </font></td>
      <%data="y"
	  else%>
      <td width="1%" valign="top">&nbsp;</td>
      <%data="n"
	  end if%>
      <%if rs("toppertype")<>"" and NOT ISNULL(rs("toppertype")) and compmadeat5=madeat   then
	 %>
      <td width="12%" valign="top"><span style="display:block;margin-bottom:-12px;margin-top:-5px;color:<%=getLockColourForStatus(getComponentStatusLatest(con, rs("purchase_no"), 5))%>"><%=rs("toppertype")%></span><br><font size="+3"><span style="color:<%=getColourForEntry(con, rs("purchase_no"), "Cut", 5)%>">&#9608;</span>
      <span style="color:<%=getColourForEntry(con, rs("purchase_no"), "Machined", 5)%>">&#9608;</span>
      <span style="color:<%=getColourForEntry(con, rs("purchase_no"), "finished", 5)%>">&#9608;</span>
      </font></td>
      <%else%>
      <td width="1%" valign="top">&nbsp;</td>
      <%end if%>
      <%if rs("headboardstyle")<>"" and NOT ISNULL(rs("headboardstyle")) and compmadeat8=madeat   then
	  %>
      <td width="12%" valign="top"><span style="display:block;margin-bottom:-12px;margin-top:-5px;color:<%=getLockColourForStatus(getComponentStatusLatest(con, rs("purchase_no"), 8))%>"><%=rs("headboardstyle")%></span><br>
      <font size="+3">
      <span style="white-space: pre;color:<%=getColourForEntry(con, rs("purchase_no"), "Framed", 8)%>">&#9608;</span>
      <span style="white-space: pre;color:<%=getColourForEntry(con, rs("purchase_no"), "prepped", 8)%>">&#9608;</span>
      <span style="white-space: pre;color:<%=getColourForEntry(con, rs("purchase_no"), "finished", 8)%>">&#9608;</span>
      </font></td>
      <%else%>
      <td width="1%" valign="top">&nbsp;</td>
      <%end if%>
      <%if rs("legstyle")<>"" and NOT ISNULL(rs("legstyle")) and compmadeat7=madeat then
	  %>
      <td width="7%" valign="top"><span style="display:block;margin-bottom:-12px;margin-top:-5px;color:<%=getLockColourForStatus(getComponentStatusLatest(con, rs("purchase_no"), 7))%>"><%=rs("legstyle")%></span><br><font size="+3">
      <span style="white-space: pre;color:<%=getColourForEntry(con, rs("purchase_no"), "prepped", 7)%>">&#9608;</span>
      <span style="white-space: pre;color:<%=getColourForEntry(con, rs("purchase_no"), "finished", 7)%>">&#9608;</span>
      </font></td>
      <%else%>
      <td width="1%" valign="top">&nbsp;</td>
      <%end if%>
      <td width="2%" valign="top"><%=productiondate%></td>
    </tr>

<%
end if
rs.movenext
loop
rs.close
set rs=nothing
%>

<%
Con.Close
Set Con = Nothing%>
  </table>
<p>&nbsp; </p>

<!--</form>-->
<div id="topright">
  <img src="images/logo.gif" width="255" height="66" alt="Savoir Beds"></div>
</div>
</div>
<div>

   
</body>
<HEAD>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
</HEAD>   
</html>

<%

function getLockColourForStatus(aStatus)

	if aStatus = 20 then
		getLockColourForStatus = "red" 'In Production
	elseif aStatus = 30 then
		getLockColourForStatus = "orange" ' Order on Stock, Waiting QC
	elseif aStatus = 40 then
		getLockColourForStatus = "green" ' QC Checked
	elseif aStatus = 50 then
		getLockColourForStatus = "green" ' In Bay
	elseif aStatus = 60 then
		getLockColourForStatus = "green" ' Order Picked
	elseif aStatus = 70 then
		getLockColourForStatus = "grey" ' Delivered
	else
		getLockColourForStatus = ""
	end if

end function

function getComponentCellStatusClass(byref acon, aPurchaseNo, aCompId)
	dim aStatus
	aStatus = getComponentStatusLatest(acon, aPurchaseNo, aCompId)
	getComponentCellStatusClass = ""
	if aStatus < 20 then getComponentCellStatusClass = "redcell"
end function

function parseMadeat(byref aval)
	parseMadeat = -1

	on error resume next
		parseMadeat = cint(cstr(aval))
	if err.number <> 0 then
		parseMadeat = -1
	end if
	on error goto 0
	'response.write("<br>aval = " & cstr(aval))
	'response.write("<br>parseMadeat = " & parseMadeat)
	'response.end
	
end function

Function FirstDayOfWeekN( weekN, ProdDate )
	Dim FirstDayOfYear, FirstDayOfFirstWeek
    FirstDayOfYear = DateSerial( Year(ProdDate), 1, 1 )
    FirstDayOfFirstWeek = FirstDayOfYear - Weekday( FirstDayOfYear ) + 1
    FirstDayOfWeekN = DateAdd( "ww", weekN-1, FirstDayOfFirstWeek )
End Function

Function FirstDayOfNextWeekN( weekN, ProdDate )
	Dim FirstDayOfYear, FirstDayOfFirstWeek
    FirstDayOfYear = DateSerial( Year(ProdDate), 1, 1 )
    FirstDayOfFirstWeek = FirstDayOfYear - Weekday( FirstDayOfYear ) + 1
    FirstDayOfNextWeekN = DateAdd( "ww", weekN, FirstDayOfFirstWeek )
End Function
%>


 
   