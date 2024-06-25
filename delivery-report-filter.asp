<%
Option Explicit
%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES,REGIONAL_ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="reportfuncs.asp" -->
<%

Dim Con, rs, sql, submit, url, previousOrderNumber, acknowDateWarning, diff, count
dim reporttype, datefrom, dateto, location, giftpack, delcall
dim showr, customerasc, orderasc, companyasc, deldate, proddate
Set Con = getMysqlConnection()

submit = request("submit")
reporttype = request("reporttype")
datefrom = request("datefrom")
dateto = request("dateto")
location = request("location")
giftpack = request("giftpack")
delcall = request("delcall")
showr = request("showr")
customerasc = request("customerasc")
orderasc = request("orderasc")
companyasc = request("companyasc")
deldate = request("deldate")
proddate = request("proddate")
%>

<!doctype html public "-//w3c//dtd html 4.01//en"
    "http://www.w3.org/tr/html4/strict.dtd">
<html lang = "en">
    <head>
        <title>Administration.</title>

        <meta http-equiv = "Content-Type" content = "text/html; charset=utf-8" />

        <meta http-equiv = "ROBOTS" content = "NOINDEX,NOFOLLOW" />

        <link href = "Styles/screen.css" rel = "Stylesheet" type = "text/css" />

        <link href = "Styles/print.css" rel = "Stylesheet" type = "text/css" media = "print" />

        <script src = "common/jquery.js" type = "text/javascript">
        </script>

        <script src = "scripts/keepalive.js">
        </script>
        <link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
<script>
$(function() {
var year = new Date().getFullYear();
var dateFormat = $( "#datefrom" ).datepicker( "option", "dateFormat" );
$( "#datefrom" ).datepicker({ 
dateFormat: "dd/mm/yy",
//$( "#datefrom" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
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
    </head>

    <body>
        
            <div class = "container">
                <!-- #include file="header.asp" -->
<form action = "delivery-report-filter.asp" method = "post" name = "form1">
                <div class = "content brochure">
                    <div class = "one-col head-col">
                        <p>Delivery Reports:</p>

                        <p>&nbsp;</p>

                        <table width = "530" border = "0" align = "center" cellpadding = "5" cellspacing = "2">
                            <tr>
                                <td>
                                    Choose report type:
                                </td>

                                <td colspan = "2">
                                    <label for = "reporttype"></label>

                                    <select name = "reporttype" id = "reporttype">
                                        <option value = "delivery"<%=selected("delivery", reporttype)%>>Delivery
                                        Dates</option>

                                        <option value = "production"<%=selected("production", reporttype)%>>Production
                                        Completion Dates</option>
                                    </select>
                                </td>
                            </tr>

                            <tr>
                                <td width = "174">
                                    <label for = "datefrom" id = "surname"><strong>Date from :</strong>

                                    <br>
                                    <input name = "datefrom" type = "text" class = "text" id = "datefrom"
                                        value = "<%=datefrom%>"
                                        size = "10" /></label>
                                </td>

                                <td width = "164">
                                    <strong>Date to: </strong>

                                    <br>
                                    <input name = "dateto" type = "text" class = "text" id = "dateto"
                                        value = "<%=dateto%>"
                                        size = "10" />
                                </td>

                                <td width = "164">
                                    <%if userHasRole("REGIONAL_ADMINISTRATOR") then
									sql = "Select * from location where OWNING_REGION=" & retrieveuserregion() & " AND retire<>'y' order by adminheading"
									else
                                    sql = "Select * from location where owning_region=1 AND retire<>'y' order by adminheading"
									end if
									
                                    Set rs = getMysqlQueryRecordSet(sql, con)
                                    %>

                                    <select name = "location" size = "1" class = "formtext" id = "location">
                                        <option value = "all"<%=selected("all", location)%>>All Showrooms</option>
                                        <%
                                        do until rs.EOF
                                        %>

                                        <option value = "<%=rs("idlocation")%>"
                                            <%=selected(rs("idlocation"), location)%>><%=rs("adminheading")%></option>
                                        <%
                                        rs.movenext
                                        loop
                                        rs.Close
                                        Set rs = Nothing
                                        %>
                                    </select>

                                    &nbsp;&nbsp;
                                    <%%>
                                </td>
                            </tr>

                            <tr>
                                <td> </td>
                          <td colspan = "2" align = "right"></td>
                            </tr>

                            <tr>
                                <td colspan = "3">
                                    <label for = "giftpack"><br />

                                    Tick to only show deliveries with Received Gift Packs

                                    <input name = "giftpack" type = "checkbox" id = "giftpack" value = "y"
                                        <%=ischeckedY(giftpack)%> /></label>

                                    <label for = "delcall"><br />

                                    Include only records where a Post Delivery Call has been logged

                                    <input name = "delcall" type = "checkbox" id = "delcall" value = "y"
                                        <%=ischeckedY(delcall)%> /></label>
                                </td>
                            </tr>

                            <tr>
                                <td>&nbsp;
                                    
                                </td>

                                <td align = "right">
                                    <span class = "row">
                                    <input type = "submit" name = "submit" value = "Search Database" id = "submit"
                                        class = "button" onClick="return setFormAction('')" /> </span>
                                </td>
                                <td align = "right">
                                    <span class = "row">
                                    <input type = "submit" name = "submitcsv" value = "Download CSV" id = "submitcsv"
                                        class = "button" onClick="return setFormAction('csv')" /> </span>
                                </td>
                            </tr>
                        </table>

                        <p><br> </p>
                    </div>
                </div>
<div></form></div>
        
<%
				if submit <> "" then
                                        count = 0
                                        url = "submit=true&delcall=" & delcall & "&giftpack=" & giftpack & "&reporttype=" & reporttype & "&datefrom=" & Server.URLEncode(datefrom) & "&dateto=" & Server.URLEncode(dateto) & "&location=" & location & "&"
                                        set rs = getDeliveryReportRs(con, location, delcall, giftpack, reporttype, datefrom, dateto, showr, customerasc, orderasc, companyasc, deldate, proddate)
                                        response.Write("Total = " & rs.recordcount & "<br /><br />")
                                    %>

                                            <table border = "0" cellpadding = "6" cellspacing = "2">
                                                <tr>
                                                    <td width = "88">
                                                        <b>Customer
                                                        Name<a href = "delivery-report-filter.asp?<%=url%>customerasc=d">

                                                        <br>
                                                        <img src = "img/desc.gif" alt = "Descending" width = "34"
                                                            height = "30" align = "middle"
                                                            border = "0"></a><a href = "delivery-report-filter.asp?<%=url%>customerasc=a"><img src = "img/asc.gif"
                                                            alt = "Ascending" width = "34" height = "30"
                                                            align = "middle"border></a></b>
                                                    </td>

                                                    <td width = "33">
                                                        <strong>Company

                                                        <br>
                                                        </strong><b><a href = "delivery-report-filter.asp?<%=url%>companyasc=d"><img src = "img/desc.gif"
                                                            alt = "Descending" width = "34" height = "30"
                                                            align = "middle"
                                                            border = "0"></a><a href = "delivery-report-filter.asp?<%=url%>companyasc=a"><img src = "img/asc.gif"
                                                            alt = "Ascending" width = "34" height = "30"
                                                            align = "middle"border></a></b>
                                                    </td>

                                                    <td width = "34">
                                                        Ref.
                                                    </td>

                                                    <td>
                                                        <b>Order No<a href = "delivery-report-filter.asp?<%=url%>orderasc=d">

                                                        <br>
                                                        <img src = "img/desc.gif" alt = "Descending" width = "34"
                                                            height = "30" align = "middle"
                                                            border = "0"></a><a href = "delivery-report-filter.asp?<%=url%>orderasc=a"><img src = "img/asc.gif"
                                                            alt = "Ascending" width = "34" height = "30"
                                                            align = "middle" border = "0"></a></b>
                                                    </td>
                                                    <%
                                                    if userHasRole("ADMINISTRATOR") or userHasRole("SHOWROOM_VIEWER") or userHasRole("REGIONAL_ADMINISTRATOR") then
                                                    %>

                                                        <td width = "59">
                                                            <strong>Order Source

                                                            <br>
                                                            <a href = "delivery-report-filter.asp?<%=url%>showr=d">

                                                            <br>
                                                            <img src = "img/desc.gif" alt = "Descending" width = "34"
                                                                height = "30" align = "middle"
                                                                border = "0"></a><a href = "delivery-report-filter.asp?<%=url%>showr=a"><img src = "img/asc.gif"
                                                                alt = "Ascending" width = "34" height = "30"
                                                                align = "middle" border = "0"></a></strong>
                                                        </td>
                                                        <td>Delivery Postcode</td>
                                                    <%
                                                    end if
                                                    %>

                                            <td width = "68">
                                                <b>Order Value</b>
                                            </td>

                                            <td width = "80">
                                                <strong>Payments Total</strong>
                                            </td>

                                            <td width = "110">
                                                <strong>Balance Outstanding</strong>
                                            </td>
                                            <%
                                        if reporttype = "delivery" then
                                            %>

                                                <td width = "124">
                                                    <strong>Delivery Date

                                                    <br>
                                                    <a href = "delivery-report-filter.asp?<%=url%>deldate=d"><img src = "img/desc.gif"
                                                        alt = "Descending" width = "34" height = "30"
                                                        align = "middle"
                                                        border = "0"></a><a href = "delivery-report-filter.asp?<%=url%>deldate=a"><img src = "img/asc.gif" alt = "Ascending" width = "34" height = "30" align = "middle"border></a>
                                                    </strong>
                                                </td>
                                            <%
                                        end if
                                            %>
                                            <%
                                        if reporttype = "production" then
                                            %>

                                                <td width = "124">
                                                    <strong>Production Date

                                                    <br>
                                                    <a href = "delivery-report-filter.asp?<%=url%>proddate=d"><img src = "img/desc.gif"
                                                        alt = "Descending" width = "34" height = "30"
                                                        align = "middle"
                                                        border = "0"></a><a href = "delivery-report-filter.asp?<%=url%>proddate=a"><img src = "img/asc.gif" alt = "Ascending" width = "34" height = "30" align = "middle"border></a>
                                                    </strong>
                                                </td>
                                            <%
                                        end if
                                            %>
                                                </tr>
                                                <%
                                            Do until rs.EOF
                                                %>
                                                <%
                                            if rs("order_number") <> previousOrderNumber then
'rs("order_date")
'If the acknowledgement date is Null, and the Order Date is more than 7 days beyond than current date then a Red flag appears
                                                acknowDateWarning = false
                                                if(isnull(rs("acknowdate") ) or rs("acknowdate") = "") and rs("order_date") <> "" then
                                                    diff = dateDiff("d", cdate(rs("order_date") ), now() )
                                                    acknowDateWarning = (diff > 7)
                                                end if
                                                %>

                                                    <tr>
                                                        <td valign = "top"><% 'response.Write("<p><input type=""checkbox"" name=""XX_" & rs("purchase_no") & """ id=""XX_" & rs("purchase_no") & """><a href=""edit-purchase.asp?order=" & rs("purchase_no") & """>")
                                                        response.Write("<a href=""edit-purchase.asp?order=" & rs("purchase_no") & """>")
                                                        If rs("surname") <> "" then response.write(rs("surname") & ", ")
                                                        If rs("title") <> "" then response.write(rs("title") & " ")
                                                        If rs("first") <> "" then response.write(rs("first") & " ")
                                                            response.Write("</a>")
                                                            %></td>

                                                        <td valign = "top"><%
                                                            If rs("company") <> "" then response.write(rs("company") )
                                                            %></td>

                                                        <td valign = "top">
                                                            <%=rs("customerreference")%>&nbsp;
                                                        </td>

                                                        <td valign = "top">
                                                            <%
                                                            If rs("order_number") <> "" then response.write(rs("order_number") & " ")
                                                            %>&nbsp;
                                                        </td>
                                                                <%
                                                                if userHasRole("ADMINISTRATOR") or userHasRole("SHOWROOM_VIEWER") or userHasRole("REGIONAL_ADMINISTRATOR")  then
                                                                %>

                                                                    <td><%=rs("adminheading")%></td>
                                                                <%
                                                                end if
                                                                %>
<td><%=rs("deliverypostcode")%></td>
                                                            <td align = "right" valign = "top">
                                                                <%
                                                            If rs("total") <> "" then response.write(rs("total") & " ")
                                                                %>&nbsp;
                                                            </td>

                                                            <td align = "right" valign = "top">
                                                                <%
                                                            response.Write(rs("paymentstotal") )
                                                                %>&nbsp;
                                                            </td>

                                                            <td align = "right" valign = "top"><%
                                                            response.Write(rs("balanceoutstanding") )
                                                                %></td>
                                                            <%
                                                        if reporttype = "delivery" then
                                                            %>

                                                            <td valign = "top">
                                                                <%
                                                                If rs("bookeddeliverydate") <> "" then response.Write(rs("bookeddeliverydate") )
                                                                %>&nbsp;
                                                            </td>
                                                            <%
                                                        end if
                                                            %>
                                                            <%
                                                        if reporttype = "production" then
                                                            %>

                                                                <td valign = "top">
                                                                    <%
                                                                    If rs("production_completion_date") <> "" then response.Write(rs("production_completion_date") )
                                                                    %>&nbsp;
                                                                </td>
                                                            <%
                                                        end if
                                                            %>
                                                    </tr>
                                                <%
                                                count = count + 1
                                                    previousOrderNumber = rs("order_number")
                                            end if
                                                rs.movenext
                                            loop
                                                %>
                                            </table>
                                            <%
                                        if rs.recordcount > 20 then
                                            %>

                                                <p><a href = "#top" class = "addorderbox">&gt;&gt; Back to Top</a></p>
                                            <%
                                        end if

                                            call closemysqlrs(rs)
                                            %>
                                    <%
                                    end if
                                    %>
    </body>
</html>
<script Language="JavaScript" type="text/javascript">

	function setFormAction(actionName) {
		if (actionName == "csv") {
			document.form1.action = "delivery-report-csv.asp"
		} else {
			document.form1.action = "delivery-report-filter.asp"
		}
		return true;
	}

</script>
<%
call closemysqlcon(con)
%>
<!-- #include file="common/logger-out.inc" -->
