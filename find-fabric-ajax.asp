<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #INCLUDE file="utilfuncs2.asp" -->
<%
Dim Con, rs, orderid, fabric, selectname, tabindexno, valancefabricchoice, basefabricchoice, headboardfabricchoice, fabricoption, fabricchoice
Set Con = getMysqlConnection()

fabric = cleanForDb(request("fabric"))
if fabric = "" then
	response.end
end if

orderid = cleanForDb(request("order"))

headboardfabricchoice = ""
basefabricchoice = ""
valancefabricchoice = ""
if orderid <> "" then
	Set rs = getMysqlQueryRecordSet("Select * from purchase WHERE Purchase_No=" & orderid, con)
	headboardfabricchoice = trim(rs("headboardfabricchoice"))
	basefabricchoice = trim(rs("basefabricchoice"))
	valancefabricchoice = trim(rs("valancefabricchoice"))
	rs.close
	set rs = nothing
end if

fabricchoice = ""
if request("name")="basefabric" then 
	selectname="basefabricchoice"
	tabindexno=72
	fabricchoice = basefabricchoice
end if
if request("name")="headboardfabric" then 
	selectname="headboardfabricchoice"
	tabindexno=74
	fabricchoice = headboardfabricchoice
end if
if request("name")="valancefabric" then 
	selectname="valancefabricchoice"
	tabindexno=93
	fabricchoice = valancefabricchoice
end if

if request("fabricchoice") <> "" then
	' we've been supplied by the fabric choice to pre-select, so use in preference to that from the order
	fabricchoice = request("fabricchoice")
end if


fabricoption = 0
if fabric = "Novasuede" then
	fabricoption = 1
elseif fabric = "Romo" then
	fabricoption = 2
elseif fabric = "AndrewMartin" then
	fabricoption = 3
elseif fabric = "Muirhead" then
	fabricoption = 4
end if
%>
<select name="<%=selectname%>" id="<%=selectname%>" onChange="javascript:submitFabricDropdown(this)" tabindex="<%=tabindexno%>">
<% if fabricoption > 0 then 
			%><option/><%
			Set rs = getMysqlQueryRecordSet("Select * from fabric Where fabricoption=" & fabricoption, con)
			Do until rs.EOF
			%>
				<option value='<%=trim(rs("fabric"))%>' <%=isselected(trim(rs("fabric")), fabricchoice)%> ><%=trim(rs("fabric"))%></option>
			<%rs.movenext
			loop
			rs.close
			set rs=nothing
elseif fabric = "TBC" then %>
			<option value='TBC' <%=isselected("TBC", fabricchoice)%> >TBC</option>
<%elseif fabric = "ClientsFabric" then %>
			<option value='Clients Own Fabric' <%=isselected("Clients Own Fabric", fabricchoice)%> >Client's Own Fabric</option>
<% end if %>
</select>
<%Con.close
set Con=nothing%>