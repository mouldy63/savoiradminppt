<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,REGIONAL_ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="generalfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, customerasc, orderasc, showr,  companyasc, bookeddate, productiondate, previousOrderNumber, acknowDateWarning, lorrycount, splitshipment, rs5, deliverypostcode
dim diff, balanceOutstanding, showroom, slected, buddyLocationAndRegionList, pairs, pair, locAndReg, nLoc, custref, orderdateasc

showroom=request("showroom")
companyasc=""
customerasc=""
orderasc=""
orderdateasc=""
showr=""
custref=""
showr=request("showr")
productiondate=request("productiondate")
deliverypostcode=request("deliverypostcode")
bookeddate=request("bookeddate")
companyasc=request("companyasc")
customerasc=request("customerasc")
orderasc=request("orderasc")
orderdateasc=request("orderdateasc")
custref=request("custref")
msg=""
msg=Request("msg")
count=0
submit=Request("submit") 
Set Con = getMysqlConnection()
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>
<script src="scripts/keepalive.js"></script>

</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">
<% 
postcodefull=Request("postcode")
postcode=Replace(postcodefull, " ", "")
If msg<>"" Then response.Write("<p><font color=""red"">The Brochure Requests were " & msg & "</font></p>")%>
<p>Current Orders.</p>
<%'If retrieveUserRegion()=1 then%>
	<p><form name="form1" method="post" action="current-orders.asp">
		   <%If not isSuperuser() and not userHasRole("ADMINISTRATOR") then
		   sql="Select distinct(L.idlocation),L.adminheading from location L, Purchase P where P.idlocation=L.idlocation AND P.idlocation in (" & makeBuddyLocationList(retrieveUserLocation(), con) & ") and L.retire<>'y' order by adminheading"
        else
        sql="Select * from location where retire<>'y' order by adminheading"
		end if
        Set rs = getMysqlQueryRecordSet(sql , con)%>
      <select name="showroom" size="1" class="formtext" id="showroom">
              <option value="all">All Showrooms</option>
            <%do until rs.EOF
			slected=""
			if showroom<>"all" then
				if CDbl(showroom)=CDbl(rs("idlocation")) then slected="selected"
			end if
			%>
              <option value="<%=rs("idlocation")%>" <%=slected%>><%=rs("adminheading")%></option>
            <% rs.movenext 
			loop
			rs.Close
			Set rs = Nothing%>
            </select>

      <input type="submit" name="submit" id="submit" value="Filter">&nbsp;&nbsp;&nbsp;<a href="currentorders-csv.asp?showroom=<%=showroom%>">CSV</a>
	</form></p>
  
<%'end if%>


<!--<form name="form1" method="post" action="">-->	
  <p>
<%

sql = "select * from ("
sql = sql & "select order_number,order_date,customerreference,acknowdate,purchase_no,surname,p.owning_region,c.title,first,company,total,ordercurrency,paymentstotal,balanceoutstanding,vat,deliverypostcode,productiondate,bookeddeliverydate,overseasOrder,istrade,"
if userHasRole("ADMINISTRATOR") or userHasRole("SHOWROOM_VIEWER") or retrieveUserRegion=1 then 
sql = sql & "adminheading,"
end if
sql = sql & " (select min(ec.collectionstatus) as mincollectionstatus from exportlinks el, exportcollections ec where ec.exportcollectionsid=el.linkscollectionid and el.purchase_no=p.purchase_no) as mincollectionstatus"
sql = sql & " from address A, contact C, Purchase P" 
if userHasRole("ADMINISTRATOR") or userHasRole("SHOWROOM_VIEWER") or retrieveUserRegion=1  then 
sql = sql & ", Location L"
end if
sql = sql & " Where (P.cancelled is null or P.cancelled <> 'y') AND C.retire='n' AND P.orderonhold<>'y' AND C.contact_no<>319256 AND C.contact_no<>24188 and (P.ORDER_NUMBER IS NOT NULL AND P.ORDER_NUMBER != '') AND A.code=C.code AND C.contact_no=P.contact_no AND P.completedorders='n' AND P.quote='n' "
if userHasRole("ADMINISTRATOR") or userHasRole("SHOWROOM_VIEWER") or retrieveUserRegion()=1  then 
	sql = sql & " AND P.idlocation=L.idlocation "
else
	if not isSuperuser() and not userHasRole("ADMINISTRATOR") then
		If retrieveuserid()=170 then
			sql = sql & " AND P.owning_region=" & retrieveuserregion()
			sql = sql & " AND P.idlocation in (3, 4, 5)"
		elseif userHasRole("REGIONAL_ADMINISTRATOR") then
			' REGION_ADMINISTRATOR can see all orders in their region
			sql = sql & " AND P.OWNING_REGION=" & retrieveuserregion()
		elseIf retrieveuserlocation()<>1 and retrieveuserlocation()<>27 then 'Bedworks & Cardiff
			buddyLocationAndRegionList = getBuddyLocationAndRegionList(con, retrieveUserLocation())
			'response.write("<br>buddyLocationAndRegionList = " & buddyLocationAndRegionList)
			'response.end
			nLoc = 0
			pairs = split(buddyLocationAndRegionList, ";")
			sql = sql & " AND ("
			for each pair in pairs
				nLoc = nLoc + 1
				if nLoc > 1 then
					sql = sql & " OR "
				end if
				locAndReg = split(pair, ",")
				sql = sql & " (P.idlocation=" & locAndReg(0) & " AND P.owning_region=" & locAndReg(1) & ")"
			next
			sql = sql & ")"
		else
			sql = sql & " AND P.owning_region=" & retrieveuserregion()
		end if
	'	sql = sql & " AND P.source_site='" & retrieveUserSite() & "'"
	end if
end if
If retrieveuserRegion()=1 AND (not isSuperuser() and not userHasRole("ADMINISTRATOR")) then
	sql = sql & " AND P.idlocation in (" & makeBuddyLocationList(retrieveUserLocation(), con) & ") "
end if

if showroom <> "all" and showroom <> "" then
	sql = sql & " and P.idlocation=" & showroom
end if

sql = sql & " AND P.source_site='SB' " 
sql = sql & ") as x where (x.mincollectionstatus is null or x.mincollectionstatus<4)"

if showr="a" then
	sql = sql & " order by adminheading asc"
end if
if showr="d" then
	sql = sql & " order by adminheading desc"
end if
if customerasc="a" then
	sql = sql & " order by surname asc"
end if
if customerasc="d" then
	sql = sql & " order by surname desc"
end if
if orderasc="a" then
	sql = sql & " order by order_number asc"
end if
if orderasc="d" then
	sql = sql & " order by order_number desc"
end if
if orderdateasc="a" then
	sql = sql & " order by order_date asc"
end if
if orderdateasc="d" then
	sql = sql & " order by order_date desc"
end if
if custref="a" then
	sql = sql & " order by customerreference asc"
end if
if custref="d" then
	sql = sql & " order by customerreference desc"
end if
if companyasc="a" then
	sql = sql & " order by company asc"
end if
if companyasc="d" then
	sql = sql & " order by company desc"
end if
if bookeddate="a" then
	sql = sql & " order by bookeddeliverydate asc"
end if
if bookeddate="d" then
	sql = sql & " order by bookeddeliverydate desc"
end if
if productiondate="a" then
	sql = sql & " order by productiondate asc"
end if
if productiondate="d" then
	sql = sql & " order by productiondate desc"
end if
if deliverypostcode="a" then
	sql = sql & " order by deliverypostcode asc"
end if
if deliverypostcode="d" then
	sql = sql & " order by deliverypostcode desc"
end if
if customerasc=""  and  orderasc="" and  orderdateasc="" and companyasc="" and custref=""  and bookeddate=""  and deliverypostcode=""  and showr="" and productiondate="" then
	sql = sql & " order by order_date asc"
end if

'response.write("<br>" & sql)
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
response.Write("Total = " & rs.recordcount & "<br /><br />")
%>
<table border="0" cellpadding="6" cellspacing="2">
 <tr>
    <td width="88"><b>Customer Name<a href="current-orders.asp?customerasc=d"><br>
      <img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a><a href="current-orders.asp?customerasc=a"><img src="img/asc.gif" alt="Ascending" width="24" height="20" align="middle"border></a></b></td>
       <td width="69"><strong>Company<br>
       </strong><b><a href="current-orders.asp?companyasc=d"><img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a><a href="current-orders.asp?companyasc=a"><img src="img/asc.gif" alt="Ascending" width="24" height="20" align="middle"border></a></b></td> 
       <td width="75"><b>Order No<a href="current-orders.asp?orderasc=d"><br>
        <img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a><a href="current-orders.asp?orderasc=a"><img src="img/asc.gif" alt="Ascending" width="24" height="20" align="middle" border="0"></a></b></td>
        <td width="75"><b>Customer Ref.<a href="current-orders.asp?custref=d"><br>
        <img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a><a href="current-orders.asp?custref=a"><img src="img/asc.gif" alt="Ascending" width="24" height="20" align="middle" border="0"></a></b></td>
       <td width="56"><strong>Delivery<br>
         Postcode<a href="current-orders.asp?deliverypostcode=d"><br>
        <img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a><a href="current-orders.asp?deliverypostcode=a"><img src="img/asc.gif" alt="Ascending" width="24" height="20" align="middle" border="0"></a></strong></td>
<%if retrieveUserRegion=1 then%>
    <td width="56"><b>Note Date</b></td>
    <%end if%>
    <td width="56"><b>Order Date<a href="current-orders.asp?orderdateasc=d"><br>
        <img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a><a href="current-orders.asp?orderdateasc=a"><img src="img/asc.gif" alt="Ascending" width="24" height="20" align="middle" border="0"></a></b></td>
    <%if retrieveUserRegion=1 then%>
    <td width="56"><b>Ackgt Date</b></td>
    <%end if%>
<%if userHasRole("ADMINISTRATOR") or userHasRole("SHOWROOM_VIEWER") or retrieveUserRegion()=1 then%>
<td width="59"><strong>Showroom<br>
       <a href="current-orders.asp?showr=d"><br>
        <img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a><a href="current-orders.asp?showr=a"><img src="img/asc.gif" alt="Ascending" width="24" height="20" align="middle" border="0"></a></strong></td>
<%end if%>
<%if NOT userHasRole("NOPRICESUSER") then
'if (retrieveuserid()<>181 and retrieveuserid()<>182) then%>
    <td width="68"><b>Order Value</b></td>
    <td width="86"><strong>Payments Total</strong></td>
    <td width="114" align="right"><strong>Balance Outstanding</strong></td>
<%end if%>
    <%if retrieveUserRegion=1 then%>
    <td width="124"><strong>Production Date<br><a href="current-orders.asp?productiondate=d"><img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a><a href="current-orders.asp?productiondate=a"><img src="img/asc.gif" alt="Ascending" width="24" height="20" align="middle"border></a></strong></td>
  <%end if%>
  <%if retrieveUserRegion=1 or retrieveUserLocation()=34 or retrieveUserLocation()=37 then%> 
    <td width="124"><strong>Booked Delivery Date<br><a href="current-orders.asp?bookeddate=d"><img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a><a href="current-orders.asp?bookeddate=a"><img src="img/asc.gif" alt="Ascending" width="24" height="20" align="middle"border></a>
    </strong></td>
     <%end if%>

     <td width="61"><strong>Ex-works Date&nbsp;</strong></td>
    <td width="21">&nbsp;</td>
    </tr>
<%Do until rs.EOF%>
<% if rs("order_number") <> previousOrderNumber then
'rs("order_date") 
'If the acknowledgement date is Null, and the Order Date is more than 7 days beyond than current date then a Red flag appears
acknowDateWarning = false
if (isnull(rs("acknowdate")) or rs("acknowdate") = "") and rs("order_date") <> "" then
	diff = dateDiff("d", cdate(rs("order_date")), now())
	acknowDateWarning = (diff > 7)
end if

	balanceOutstanding = safeCCur(rs("balanceoutstanding"))
%>
	  <tr>
	    <td valign="top"><%'response.Write("<p><input type=""checkbox"" name=""XX_" & rs("purchase_no") & """ id=""XX_" & rs("purchase_no") & """><a href=""edit-purchase.asp?order=" & rs("purchase_no") & """>")
	response.Write("<a href=""edit-purchase.asp?order=" & rs("purchase_no") & """>")
	If rs("surname")<>"" then response.write(rs("surname") & ", ")
	If rs("title")<>"" then response.write(rs("title") & " ")
	If rs("first")<>"" then response.write(rs("first") & " ")
	response.Write("</a>")
	%></td>
	        <td valign="top"><%
	If rs("company")<>"" then response.write(rs("company"))
	%></td>
	        <td valign="top"><%If rs("order_number")<>"" then response.write(rs("order_number") & " ")%>&nbsp;</td>
            <td valign="top"><%If rs("customerreference")<>"" then response.write(rs("customerreference") & " ")%>&nbsp;</td>
	        <td valign="top"><%If rs("deliverypostcode")<>"" then response.write(rs("deliverypostcode") & " ")%></td>
	<%if retrieveUserRegion=1 then%>
	    <td valign="top">&nbsp;
	    	<% if orderHasOverdueNote(con, rs("purchase_no")) then %><img src="img/redflag.jpg" alt="Warning" align="middle" border="0"><% end if %>
	    </td>
        <%end if%>
	    <td valign="top"><%If rs("order_date")<>"" then response.write(rs("order_date") & " ")%>&nbsp;</td>
        <%if retrieveUserRegion=1 then%>
	    <td valign="top">
	    	<%If rs("acknowdate")<>"" then response.write(rs("acknowdate") & " ")%>&nbsp;
	    	<% if acknowDateWarning then %><img src="img/redflag.jpg" alt="Warning" align="middle" border="0"><% end if %>
	    </td>
        <%end if%>
	<%if userHasRole("ADMINISTRATOR") or userHasRole("SHOWROOM_VIEWER") or retrieveUserRegion()=1 then%>
<td><%=rs("adminheading")%></td>
<%end if%>
<%if NOT userHasRole("NOPRICESUSER") then
'if (retrieveuserid()<>181 and retrieveuserid()<>182) then%>
	    <td align="right" valign="top"><%=fmtCurr2(rs("total"), true, rs("ordercurrency"))%></td>
	    <td align="right" valign="top"><%=fmtCurr2(rs("paymentstotal"), true, rs("ordercurrency"))%></td>
	    <td align="right" valign="top"><%=fmtCurr2(balanceOutstanding, true, rs("ordercurrency"))%></td>
<%end if%>
    <%if retrieveUserRegion=1 then%>
	    <td valign="top"><%If rs("productiondate")<>"" then response.Write(rs("productiondate"))%>&nbsp;</td>
         <%end if%>
        <%if retrieveUserRegion=1 or retrieveUserLocation()=34 or retrieveUserLocation()=37 then%> 
	    <td valign="top"><%If rs("bookeddeliverydate")<>"" then response.Write(rs("bookeddeliverydate"))%>&nbsp;</td>
        <%end if%>
       <td valign="top">
       <%if rs("overseasOrder")="y" then
					Set rs5 = getMysqlQueryRecordSet("select count(*) as lorrycount from (SELECT exportcollectionid FROM exportlinks E, exportcollshowrooms L where E.linkscollectionid=L.exportCollshowroomsID and purchase_no=" & rs("purchase_no") & "  group by exportcollectionid)  as x", con)
					if not rs5.eof then
						lorrycount=rs5("lorrycount")
					end if
					rs5.close
					set rs5=nothing
					
					if Cint(lorrycount) > 1 then 
						response.Write("Split Shipment Dates")
						splitshipment="y"
					else
						splitshipment="n"
						Set rs5 = getMysqlUpdateRecordSet("Select * from exportcollections E, exportLinks L, exportCollShowrooms S where L.purchase_no=" & rs("purchase_no") & " and L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID", con)
						if not rs5.eof then
							response.Write(rs5("CollectionDate"))
						else
							response.Write("TBA")
						end if
						rs5.close
					set rs5=nothing
					end if
					
	   end if%>
       &nbsp;</td> 
	    <td valign="top"><%'response.Write("<br>Reason for declining quote<label><input type=""text"" name=""decline"" id=""decline""></label>")
	'response.Write("Date Declined<label><input type=""text"" name=""datedeclined"" id=""datedeclined""></label>")%>&nbsp;</td>
	    </tr>
	<%
	count=count+1
	previousOrderNumber = rs("order_number")
end if
rs.movenext
loop%>
</table>
<%if rs.recordcount>20 then%>
  <p><a href="#top" class="addorderbox">&gt;&gt; Back to Top</a></p>
  <%end if%>
<%rs.close
set rs=nothing
Con.Close
Set Con = Nothing
%>
<!-- #include file="common/logger-out.inc" -->

    
  </p>

<!--</form>-->
</div>
  </div>
<div>
</div>
       
</body>
</html>
 <script language="JavaScript">
<!--

function selectAll() {

	if (document.form1.elements) {
	    for (var j = 0; j < document.form1.elements.length; j++) {
	        var e = document.form1.elements[j];
	        if (e.type == "checkbox" && e.name.length > 2 && e.name.substr(0,3) == "XX_" ) {
	            e.checked = true;
	        }
	    }
	}

}

function deselectAll() {

	if (document.form1.elements) {
	    for (var j = 0; j < document.form1.elements.length; j++) {
	        var e = document.form1.elements[j];
	        if (e.type == "checkbox" && e.name.length > 2 && e.name.substr(0,3) == "XX_" ) {
	            e.checked = false;
	        }
	    }
	}

}

//-->
</script>
   
