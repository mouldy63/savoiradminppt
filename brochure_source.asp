<%Option Explicit%>
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #INCLUDE file="utilfuncs2.asp" -->
<%
	dim sourceGroup, con, rs, sql, displayText

	sourceGroup = cleanForDb(request("sg"))
	if sourceGroup = "" then
		response.end
	end if
	
	Set Con = getMysqlConnection()
	displayText = request("txt")
	
	sql = "Select * from source"
	if sourceGroup <> "other" then
		sql = sql & " where `source group`='" & sourceGroup & "'"
	else
		sql = sql & " where `source group` not in ('Advertising','Editorial','Hotel','Internet','recommendation')"
	end if
	sql = sql & " and source is not null and source <> ''"
	sql = sql & " and websitetext is not null and websitetext <> ''"
	sql = sql & " and retired <> 'y' and retired <> 'Y'"
	sql = sql & " order by websitetext"
	Set rs = getMysqlQueryRecordSet(sql, con)
%>
<label for="source" class="outdent">Please select from the choices below:<%'=server.htmlencode(displayText)%></label><br/>
<select name="source" id="source">
	<option/>
	<% while not rs.eof %>
		<option value='<%=rs("source")%>'><%=server.htmlencode(rs("websitetext"))%></option>
		<% rs.movenext %>
	<% wend %>
</select>

<%
con.close
set con = nothing
%>