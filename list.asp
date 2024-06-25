<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="generalfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%
Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, customerasc, orderasc, showr,  companyasc, bookeddate, productiondate, previousOrderNumber, acknowDateWarning, rs2, compstatus
dim matt_madeat, base_madeat, topper_madeat, headboard_madeat, legs_madeat, factory, bold
dim diff, factories

showr=request("showr")
productiondate=request("productiondate")
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


<html>
<head><title>Administration.</title>

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>

<script type="text/javascript">
        function UpdateTableHeaders() {
            $("div.divTableWithFloatingHeader").each(function() {
                var originalHeaderRow = $(".tableFloatingHeaderOriginal", this);
                var floatingHeaderRow = $(".tableFloatingHeader", this);
                var offset = $(this).offset();
                var scrollTop = $(window).scrollTop();
                if ((scrollTop > offset.top) && (scrollTop < offset.top + $(this).height())) {
                    floatingHeaderRow.css("visibility", "visible");
                    floatingHeaderRow.css("top", Math.min(scrollTop - offset.top, $(this).height() - floatingHeaderRow.height()) + "px");

                    // Copy cell widths from original header
                    $("th", floatingHeaderRow).each(function(index) {
                        var cellWidth = $("th", originalHeaderRow).eq(index).css('width');
                        $(this).css('width', cellWidth);
                    });

                    // Copy row width from whole table
                    floatingHeaderRow.css("width", $(this).css("width"));
                }
                else {
                    floatingHeaderRow.css("visibility", "hidden");
                    floatingHeaderRow.css("top", "0px");
                }
            });
        }

        $(document).ready(function() {
            $("table.tableWithFloatingHeader").each(function() {
                $(this).wrap("<div class=\"divTableWithFloatingHeader\" style=\"position:relative\"></div>");

                var originalHeaderRow = $("tr:first", this)
                originalHeaderRow.before(originalHeaderRow.clone());
                var clonedHeaderRow = $("tr:first", this)

                clonedHeaderRow.addClass("tableFloatingHeader");
                clonedHeaderRow.css("position", "absolute");
                clonedHeaderRow.css("top", "0px");
                clonedHeaderRow.css("left", $(this).css("margin-left"));
                clonedHeaderRow.css("visibility", "hidden");

                originalHeaderRow.addClass("tableFloatingHeaderOriginal");
            });
            UpdateTableHeaders();
            $(window).scroll(UpdateTableHeaders);
            $(window).resize(UpdateTableHeaders);
        });
    </script>
<style>
<!--
th {
    background-color: lightgrey;
    border: 1px solid black;
}
td {
    border: 1px solid black;
}
-->
</style>

</head>
<body>



<p>
  <% 
%>
  <a href="index.asp">Back to Main menu</a>
</p>
<p><a href="production-index.asp">Back to Production menu</a>
</p>
<p>Production Orders</p>

<p>Filter by:
<% bold = (factory=2)%>
&nbsp;<a href="production-list.asp?factory=2"><%if bold then%><b><%end if%>London Orders<%if bold then%></b><%end if%></a>
<% bold = (factory=1)%>
&nbsp;<a href="production-list.asp?factory=1"><%if bold then%><b><%end if%>Cardiff Orders<%if bold then%></b><%end if%></a>
<% bold = (factory=0)%>
&nbsp;<a href="production-list.asp?factory=0"><%if bold then%><b><%end if%>Unassigned Orders<%if bold then%></b><%end if%></a>
<% bold = (factory=-1)%>
&nbsp;<a href="production-list.asp"><%if bold then%><b><%end if%>None<%if bold then%></b><%end if%></a>
</p>
<!--<form name="form1" method="post" action="">-->	
<p>
<%
Set Con = getMysqlConnection()
sql = ""
if factory <> -1 then
	sql = "select * from ("
end if	
sql = sql & "select purchase_no,order_number,c.first,c.surname,c.title"
sql = sql & ",company,adminheading,order_date,productiondate,bookeddeliverydate"
sql = sql & ",mattressrequired,legsrequired,baserequired,headboardrequired,topperrequired"
sql = sql & ",basesavoirmodel,savoirmodel,headboardstyle,legstyle,toppertype"

sql = sql & " , case when exists (Select 1 from qc_history_latest h where h.componentid=1 AND h.purchase_no=P.purchase_no) then (Select madeat from qc_history_latest h where h.componentid=1 AND h.purchase_no=P.purchase_no and h.madeat is not null and h.madeat<> 0) else -1 end as matt_madeat" 
sql = sql & " , case when exists (Select 1 from qc_history_latest h where h.componentid=3 AND h.purchase_no=P.purchase_no) then (Select madeat from qc_history_latest h where h.componentid=3 AND h.purchase_no=P.purchase_no and h.madeat is not null and h.madeat<> 0) else -1 end as base_madeat" 
sql = sql & " , case when exists (Select 1 from qc_history_latest h where h.componentid=5 AND h.purchase_no=P.purchase_no) then (Select madeat from qc_history_latest h where h.componentid=5 AND h.purchase_no=P.purchase_no and h.madeat is not null and h.madeat<> 0) else -1 end as topper_madeat" 
sql = sql & " , case when exists (Select 1 from qc_history_latest h where h.componentid=8 AND h.purchase_no=P.purchase_no) then (Select madeat from qc_history_latest h where h.componentid=8 AND h.purchase_no=P.purchase_no and h.madeat is not null and h.madeat<> 0) else -1 end as headboard_madeat" 
sql = sql & " , case when exists (Select 1 from qc_history_latest h where h.componentid=7 AND h.purchase_no=P.purchase_no) then (Select madeat from qc_history_latest h where h.componentid=7 AND h.purchase_no=P.purchase_no and h.madeat is not null and h.madeat<> 0) else -1 end as legs_madeat" 

sql = sql & " from address A, contact C, Purchase P" 
sql = sql & ", Location L"
sql = sql & " Where P.purchase_no IN (SELECT Distinct purchase_no FROM qc_history_latest) and (P.cancelled is null or P.cancelled <> 'y') AND C.retire='n' AND A.code=C.code AND C.contact_no=P.contact_no AND P.completedorders='n' AND P.quote='n' "
sql = sql & " AND P.idlocation=L.idlocation "
sql = sql & " AND P.source_site='SB' " 

if showr="a" then
sql = sql & " order by L.adminheading asc"
end if
if showr="d" then
sql = sql & " order by L.adminheading desc"
end if
if customerasc="a" then
sql = sql & " order by C.surname asc"
end if
if customerasc="d" then
sql = sql & " order by C.surname desc"
end if
if orderasc="a" then
sql = sql & " order by P.order_number asc"
end if
if orderasc="d" then
sql = sql & " order by P.order_number desc"
end if
if companyasc="a" then
sql = sql & " order by A.company asc"
end if
if companyasc="d" then
sql = sql & " order by A.company desc"
end if

if bookeddate="a" then
sql = sql & " order by P.bookeddeliverydate asc"
end if
if bookeddate="d" then
sql = sql & " order by P.bookeddeliverydate desc"
end if

if productiondate="a" then
	sql = sql & " order by P.productiondate asc"
end if
if productiondate="d" then
	sql = sql & " order by P.productiondate desc"
end if
if matt_madeat = "a" then
	sql = sql & " order by matt_madeat asc"
end if
if matt_madeat = "d" then
	sql = sql & " order by matt_madeat desc"
end if
if base_madeat = "a" then
	sql = sql & " order by base_madeat asc"
end if
if base_madeat = "d" then
	sql = sql & " order by base_madeat desc"
end if
if topper_madeat = "a" then
	sql = sql & " order by topper_madeat asc"
end if
if topper_madeat = "d" then
	sql = sql & " order by topper_madeat desc"
end if
if headboard_madeat = "a" then
	sql = sql & " order by headboard_madeat asc"
end if
if headboard_madeat = "d" then
	sql = sql & " order by headboard_madeat desc"
end if
if legs_madeat = "a" then
	sql = sql & " order by legs_madeat asc"
end if
if legs_madeat = "d" then
	sql = sql & " order by legs_madeat desc"
end if

if customerasc=""  and  orderasc="" and companyasc=""  and bookeddate=""  and showr="" and productiondate="" and matt_madeat="" and base_madeat="" and topper_madeat="" and headboard_madeat="" and legs_madeat="" then
	sql = sql & " order by P.order_number asc"
end if

if factory <> -1 then
	if factory = 0 then
		' unassigned
		sql = sql & ") as x where (x.matt_madeat is null OR x.matt_madeat=0 OR x.base_madeat is null OR x.base_madeat=0 OR x.topper_madeat is null OR x.topper_madeat=0 OR x.headboard_madeat is null OR x.headboard_madeat=0 OR x.legs_madeat is null OR x.legs_madeat=0)"
	else
		sql = sql & ") as x where (x.matt_madeat=" & factory & " OR x.base_madeat=" & factory & " OR x.topper_madeat=" & factory & " OR x.headboard_madeat=" & factory & " OR x.legs_madeat=" & factory & ")"
	end if
end if


'response.write("<br>" & sql & "<br>")
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
response.Write("Total = " & rs.recordcount & "<br /><br />")
factories = getFactories(con)

%>
 

<table  style="border: 3px" class="tableWithFloatingHeader" >
<thead>

 <tr>
    <th align="left" valign="bottom"><b>Customer Name<a href="production-list.asp?customerasc=d&factory=<%=factory%>"><br>
      <img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?customerasc=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b></th>
       <th align="left" valign="bottom"><strong>Company<br>
       </strong><b><a href="production-list.asp?companyasc=d&factory=<%=factory%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?companyasc=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b></th>
       <th align="left" valign="bottom"><strong>Order Source<a href="production-list.asp?showr=d&factory=<%=factory%>"><br>
           <img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?showr=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="0"></a></strong></th> 
       <th align="left" valign="bottom"><b>Order No<a href="production-list.asp?orderasc=d&factory=<%=factory%>"><br>
        <img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?orderasc=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="0"></a></b></th>
       <th align="left" valign="bottom"><b>Order<br>
         Date</b></th>

    <th align="left" valign="bottom"><b>MATTRESS Required</b></th>

    <th align="left" valign="bottom"><b> Made At<br>
    </b>
    	<b><a href="production-list.asp?matt_madeat=d&factory=<%=factory%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?matt_madeat=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b>
    </th>
    <th align="left" valign="bottom"><strong> Order Status</strong></th>
    <th align="left" valign="bottom"><strong> BASE Required</strong></th>
    <th align="left" valign="bottom"><strong>Made At<br>
    </strong>
       	<b><a href="production-list.asp?base_madeat=d&factory=<%=factory%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?base_madeat=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b>
    </th>
      <th align="left" valign="bottom">  <strong> Order Status</strong></th>
    <th align="left" valign="bottom"><strong> TOPPER Required</strong></th>
    <th align="left" valign="bottom"><strong>Made At</strong><br>
       	<b><a href="production-list.asp?topper_madeat=d&factory=<%=factory%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?topper_madeat=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b>
    </th>
    <th align="left" valign="bottom"><strong> Order Status</strong></th>
    <th align="left" valign="bottom"><strong>HEADBOARD Required</strong></th>
    <th align="left" valign="bottom"><strong> Made At</strong>
       	<br>
       	<b><a href="production-list.asp?headboard_madeat=d&factory=<%=factory%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?headboard_madeat=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b>
    </th>
    <th align="left" valign="bottom"><strong> Order Status</strong></th>
  <th align="left" valign="bottom"><strong> LEGS Required</strong></th>
    <th align="left" valign="bottom"><strong>Made At</strong><br>
       	<b><a href="production-list.asp?legs_madeat=d&factory=<%=factory%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?legs_madeat=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b>
    </th>
    <th align="left" valign="bottom"><strong>Order Status</strong></th>
    <th align="left" valign="bottom"><strong>Production Date<a href="production-list.asp?productiondate=d&factory=<%=factory%>"><br>
        <img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?productiondate=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="0"></a></strong>&nbsp;</th>
    <th align="left" valign="bottom"><strong>Booked Delivery Date
      <a href="production-list.asp?bookeddate=d&factory=<%=factory%>"><br>
        <img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?bookeddate=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="0"></a></strong>&nbsp;</th>
    </tr>
 </thead>
 <tbody>
	<%Do until rs.EOF%>

	  <tr>
	    <td align="left" valign="top"><%
	response.Write("<a href=""orderdetails.asp?pn=" & rs("purchase_no") & """>")
	If rs("surname")<>"" then response.write(rs("surname") & ", ")
	If rs("title")<>"" then response.write(rs("title") & " ")
	If rs("first")<>"" then response.write(rs("first") & " ")
	response.Write("</a>")
	%>&nbsp;</td>
          <td align="left" valign="top"><%
	If rs("company")<>"" then response.write(rs("company"))
	%>&nbsp;</td>
          <td align="left" valign="top"><%=rs("adminheading")%>&nbsp;</td>
          <td align="left" valign="top"><a href="orderdetails.asp?pn=<%=rs("purchase_no")%>"><%If rs("order_number")<>"" then response.write(rs("order_number") & " ")%></a>&nbsp;</td>
	        <td align="left" valign="top"><%If rs("order_date")<>"" then response.write(left(rs("order_date"),10) & " ")%>
	          &nbsp;</td>
	
		<!-- mattress -->
	    <td align="left" valign="top" class="borderleft"><%if rs("mattressrequired")="y" then response.Write(rs("savoirmodel"))%>&nbsp;</td>
	    <% if parseMadeat(rs("matt_madeat")) = -1 and rs("mattressrequired")="y" then%>
        	<td align="left" valign="top" class="redborder">
        <%else%>
        	<td align="left" valign="top" >
        <%end if%>
		<% if parseMadeat(rs("matt_madeat")) > -1 and rs("mattressrequired")="y" then response.write(factories(parseMadeat(rs("matt_madeat")))) %>&nbsp;</td>
        <%if rs("mattressrequired")="y" then%>
	    	<td align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 1)%>"><%=getComponentStatusTxt(rs("purchase_no"), 1, con)%>&nbsp;</td>
        <%else%>
        	<td align="left" valign="top">&nbsp;</td>
        <%end if%>
	    
		<!-- base -->
	    <td align="left" valign="top" class="borderleft"><%if rs("baserequired")="y" then response.Write(rs("basesavoirmodel"))%>&nbsp;</td>
	    <% if parseMadeat(rs("base_madeat")) = -1 and rs("baserequired")="y" then%>
        	<td align="left" valign="top" class="redborder">
        <%else%>
        	<td align="left" valign="top">
        <%end if%>
		<% if parseMadeat(rs("base_madeat")) > -1 and rs("baserequired")="y" then response.write(factories(parseMadeat(rs("base_madeat")))) %>&nbsp;</td>
        <%if rs("baserequired")="y" then%>
        	<td align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 3)%>"><%=getComponentStatusTxt(rs("purchase_no"), 3, con)%>&nbsp;</td>
        <%else%>
        	<td align="left" valign="top">&nbsp;</td>
        <%end if%>
        
		<!-- topper -->
	    <td align="left" valign="top" class="borderleft"><%if rs("topperrequired")="y" then response.Write(rs("toppertype"))%>
	      &nbsp;</td>
	    <% if parseMadeat(rs("topper_madeat")) = -1 and rs("topperrequired")="y" then%>
        	<td align="left" valign="top" class="redborder" >
        <%else%>
        	<td align="left" valign="top">
        <%end if%>
		<% if parseMadeat(rs("topper_madeat")) > -1 and rs("topperrequired")="y" then response.write(factories(parseMadeat(rs("topper_madeat")))) %>&nbsp;</td>
        <%if rs("topperrequired")="y" then%>
	    	<td align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 5)%>"><%=getComponentStatusTxt(rs("purchase_no"), 5, con)%>&nbsp;</td>
        <%else%>
        	<td align="left" valign="top">&nbsp;</td>
        <%end if%>
	    
		<!-- headboard -->
	    <td align="left" valign="top" class="borderleft"><%if rs("headboardrequired")="y" then response.Write(rs("headboardstyle"))%>
  			&nbsp;</td>
	    <% if parseMadeat(rs("headboard_madeat")) = -1 and rs("headboardrequired")="y" then%>
        	<td align="left" valign="top" class="redborder" >
        <%else%>
        	<td align="left" valign="top">
        <%end if%>
		<% if parseMadeat(rs("headboard_madeat")) > -1 and rs("headboardrequired")="y" then response.write(factories(parseMadeat(rs("headboard_madeat")))) %>&nbsp;</td>
        <%if rs("headboardrequired")="y" then%>
	    	<td align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 8)%>"><%=getComponentStatusTxt(rs("purchase_no"), 8, con)%>&nbsp;</td>
        <%else%>
        	<td align="left" valign="top" >&nbsp;</td>
        <%end if%>
  
		<!-- legs -->
  		<td align="left" valign="top" class="borderleft"><%if rs("legstyle")<>"" then response.Write(rs("legstyle"))%>
  			&nbsp;</td>
   		<% if parseMadeat(rs("legs_madeat")) = -1 and rs("legsrequired") = "y" then%>
        	<td align="left" valign="top" class="redborder" >
        <%else%>
        	<td align="left" valign="top">
        <%end if%>
        <%'=rs("legs_madeat")%>
		<% if parseMadeat(rs("legs_madeat")) > -1 then response.write(factories(parseMadeat(rs("legs_madeat")))) %>&nbsp;</td>
       	<% if rs("legsrequired") ="y" then%>
	    	<td align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 7)%>"><%=getComponentStatusTxt(rs("purchase_no"), 7, con)%>&nbsp;</td>
        <%else%>
        	<td align="left" valign="top">&nbsp;</td>
        <%end if%>
	    
	    <td align="left" valign="top" class="borderleft"><%=rs("productiondate")%>&nbsp;</td><td align="left" valign="top"><%=rs("bookeddeliverydate")%>&nbsp;</td>
	    </tr>
	<%

rs.movenext
loop%>
</tbody></table>

<%if rs.recordcount>20 then%>
  <p><a href="#top" class="addorderbox">&gt;&gt; Back to Top</a></p>
  <%end if%>
<%rs.close
set rs=nothing
Con.Close
Set Con = Nothing%>
    

    
  </p>

<!--</form>-->
<div id="topright">
<form action="prodlist-csv.asp"  method="post" name="form1">

<input name="prodsql" type="hidden" value="<%=sql%>">
<input name="submit" type="submit" value="Produce CSV File">
</form>
</div>


       
</body>
</html>

<%
function getComponentCellStatusClass(byref acon, aPurchaseNo, aCompId)
	dim aStatus
	aStatus = getComponentStatus(acon, aPurchaseNo, aCompId)
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
%>


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
   
<!-- #include file="common/logger-out.inc" -->
