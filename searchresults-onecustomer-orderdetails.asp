<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%
Dim con, rs, contactNo, current, sql, dimensions, orderdate, pno, pg
pg=request("pg")
pno=request("pno")
dimensions="n"
contactNo = request("contactno")
current = request("current")
set con = getMysqlConnection()

sql = "select p.purchase_no,p.order_number,p.order_date,p.customerreference,p.bed,p.notes,p.salesusername,p.idlocation,l.location,p.orderonhold,p.quote,p.cancelled"
sql = sql & " from purchase p, location l"
sql = sql & " where p.idlocation=l.idlocation and (p.quote='n' or p.quote is null) and (p.cancelled='n' or p.cancelled is null) and p.purchase_no <> " & pno & " and p.contact_no=" & contactNo

sql = sql & " and p.completedorders='n'"

sql = sql & " group by p.purchase_no"
'response.write("sql = " & sql)

set rs = getMysqlQueryRecordSet(sql, con)

response.write("<table border='0' cellpadding='3' width='95%'>")
response.write("<tr><td><b>Order No</b></td><td><b>Order Date</b></td><td><b>Contact</b></td><td><b>Source</b></td><td><b>Customer Ref.</b></td><td><b>Archive Information</b></td><td><b>Notes</b></td><td><b>Order Description</b></td></tr>")

while not rs.eof
	orderdate = ""
	if rs("order_date") <> "" then orderdate = FormatDateTime(rs("order_date"), vbShortDate)

	response.write("<tr>")
	if pg="o" then
	response.write("<td valign='top'><a href='orderdetails.asp?pn=" & rs("purchase_no") & "'>" & rs("order_number") & "</a></td>")
	else
	response.write("<td valign='top'><a href='edit-purchase.asp?order=" & rs("purchase_no") & "'>" & rs("order_number") & "</a></td>")
	end if
	response.write("<td valign='top'>" & orderdate & "</td>")
	response.write("<td valign='top'>" & rs("salesusername") & "</td>")
	response.write("<td valign='top'>" & rs("location") & "</td>")
	response.write("<td valign='top'>" & rs("customerreference") & "</td>")
	response.write("<td valign='top'>" & rs("bed") & "</td>")
	response.write("<td valign='top'>" & rs("notes") & "</td>")
	response.write("<td valign='top'>" & getOrderDescription(con, rs("purchase_no")) & "</td>")
	response.write("</tr>")
	rs.movenext
wend

rs.close
set rs = nothing

response.write("</table>")

con.close
set con=nothing

function getOrderDescription(byref acon, aPn)
	dim asql, ars
	getOrderDescription = ""
	asql = "select * from purchase where purchase_no=" & aPn
	set ars = getMysqlQueryRecordSet(asql, acon)
	
	if ars("mattressrequired") = "y" then
		getOrderDescription = getOrderDescription & "<br/>Mattress: " & ars("savoirmodel") & " ("
		if ars("mattress1width") <> "" then
			dimensions="y"
			getOrderDescription = getOrderDescription & ars("mattress1width") & "," & ars("mattress2width") 
		else
			dimensions="y"
			getOrderDescription = getOrderDescription & ars("mattresswidth") 
		end if
		getOrderDescription = getOrderDescription & " x "
		if ars("mattress1length") <> "" then
			getOrderDescription = getOrderDescription & ars("mattress1length") & "," & ars("mattress2length") 
		else
			getOrderDescription = getOrderDescription & ars("mattresslength") 
		end if
		getOrderDescription = getOrderDescription & ")" 
	end if
	
	if ars("topperrequired") = "y" then
		getOrderDescription = getOrderDescription & "<br/>" & ars("toppertype")
		if dimensions="n" then
		getOrderDescription = getOrderDescription & " (" & ars("topperwidth") & " x " & ars("topperlength") & ")"
		dimensions="y" 
		end if
	end if
	
	if ars("baserequired") = "y" then
		getOrderDescription = getOrderDescription & "<br/>Base: " & ars("basesavoirmodel")
		if dimensions="n" then
			getOrderDescription = getOrderDescription & " (" & ars("basewidth") 
			if ars("base2width") <> "" then
				getOrderDescription = getOrderDescription & "," & ars("base2width") 
			end if
			getOrderDescription = getOrderDescription & " x "
			getOrderDescription = getOrderDescription & ars("baselength")
			if ars("base2length") <> "" then
				getOrderDescription = getOrderDescription & "," & ars("base2length") 
			end if
			getOrderDescription = getOrderDescription & ")" 
		end if
	end if

	if ars("legsrequired") = "y" then
		getOrderDescription = getOrderDescription & "<br/>Legs: " & ars("legstyle")
	end if

	if ars("headboardrequired") = "y" then
		getOrderDescription = getOrderDescription & "<br/>" & ars("headboardstyle")
	end if

	if ars("valancerequired") = "y" then
		getOrderDescription = getOrderDescription & "<br/>Valance"
	end if

	if ars("accessoriesrequired") = "y" then
		getOrderDescription = getOrderDescription & "<br/>Accessories"
	end if

	if getOrderDescription <> "" then
		getOrderDescription = right(getOrderDescription, len(getOrderDescription)-5)
	end if

	ars.close
	set ars = nothing
end function
%>