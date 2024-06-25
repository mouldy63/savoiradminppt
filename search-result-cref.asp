<%
sql="Select * from Purchase P, contact C where P.code=C.code and P.customerreference like '%"& cref & "%'"
if surname<>"" then sql=sql & " AND C.surname like '%" & surname & "%'"
if not isSuperuser() and not userHasRole("ADMINISTRATOR") then
		if retrieveuserregion()<>1 then 
			sql=sql & " AND P.idlocation=" & retrieveUserLocation() & ""
			else
			sql=sql & " AND P.owning_region=1"
		end if
end if
'response.write("<br>sql = " & sql)
Set rs = getMysqlQueryRecordSet(sql, con)
%>
No or records returned = <%=rs.recordcount%><br/><br/>
<b>Order Number(s)</b> - click to go through to order<br/><br/>
<%
while not rs.EOF
	response.Write("<a href=""edit-purchase.asp?order=" & rs("purchase_no") & """>" & rs("order_number") & "</a><br />")
	rs.movenext
wend
rs.close
set rs=nothing
%>
