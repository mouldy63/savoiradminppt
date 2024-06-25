<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%
Dim con, rs, contactNo, current, sql, dimensions, orderdate
dimensions="n"
contactNo = request("contactno")
current = request("current")
set con = getMysqlConnection()

sql = "select p.purchase_no,p.order_number,p.order_date,p.customerreference,p.bed"
sql = sql & ", group_concat(n.notetext order by n.createddate desc SEPARATOR '<br/>') as notes"
sql = sql & " from purchase p left join ordernote n on p.purchase_no=n.purchase_no"
sql = sql & " where p.contact_no=" & contactNo
if current = "TRUE" then
	' customers with current orders
	sql = sql & " and p.completedorders='n'"
elseif current = "FALSE" then
	' customers with completed orders
	sql = sql & " and p.completedorders='y'"
end if
sql = sql & " group by p.purchase_no"
response.write("sql = " & sql)

set rs = getMysqlQueryRecordSet(sql, con)

response.write("<table border='0' cellpadding='3' width='95%'>")
response.write("<tr><td><b>Order No</b></td><td><b>Order Date</b></td><td><b>Customer Ref.</b></td><td><b>Archive Information</b></td><td><b>Notes</b></td><td><b>Order Description</b></td></tr>")

while not rs.eof
	orderdate = ""
	if rs("order_date") <> "" then orderdate = FormatDateTime(rs("order_date"), vbShortDate)

	response.write("<tr>")
	response.write("<td valign='top'><a href='edit-purchase.asp?order=" & rs("purchase_no") & "'>" & rs("order_number") & "</a></td>")
	response.write("<td valign='top'>" & orderdate & "</td>")
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