<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #INCLUDE file="utilfuncs2.asp" -->
<%Dim Con, rs, rs6
Set Con = getMysqlConnection()
Set rs6 = getMysqlUpdateRecordSet("Select * from purchase WHERE Purchase_No=" & Session("order"), con)

	dim fabric, selectname, tabindexno, fabricchoice

	fabric = cleanForDb(request("cty"))
	if fabric = "" then
		response.end
	end if
    if request("name")="fabric" then 
		fabricchoice=rs("basefabricchoice")
		selectname="fabric2"
		tabindexno=72
	end if
	if request("name")="fabric3" then 
		fabricchoice=rs("headboardfabricchoice")
		selectname="fabric4"
		tabindexno=74
	end if
	if request("name")="fabric6" then 
		fabricchoice=rs("valancefabricchoice")
		selectname="fabric7"
		tabindexno=93
	end if	
rs6.close
set rs6=nothing
%>
<select name="<%=selectname%>" id="<%=selectname%>" onChange="javascript:submitFabricDropdown(this)" tabindex="<%=tabindexno%>">
	<option/>
   
<% if fabric = "Novasuede" then 
			Set rs = getMysqlUpdateRecordSet("Select * from fabric Where fabricoption=1", con)
			If fabricchoice<>"" Then%>
           	<option value='<%=fabricchoice%>' selected><%=fabricchoice%></option>
            <%End If
			Do until rs.EOF
			%>
				<option value='<%=rs("fabric")%>'><%=rs("fabric")%></option>
			<%rs.movenext
			loop
			rs.close
			set rs=nothing%>
		
	<% elseif fabric = "Romo" then 
			Set rs = getMysqlUpdateRecordSet("Select * from fabric Where fabricoption=2", con)
			If fabricchoice<>"" Then%>
           	<option value='<%=fabricchoice%>' selected><%=fabricchoice%></option>
            <%End If
			Do until rs.EOF
			%>
				<option value='<%=rs("fabric")%>'><%=rs("fabric")%></option>
			<%rs.movenext
			loop
			rs.close
			set rs=nothing%>
	<% elseif fabric = "AndrewMartin" then 
		Set rs = getMysqlUpdateRecordSet("Select * from fabric Where fabricoption=3", con)
			If fabricchoice<>"" Then%>
           	<option value='<%=fabricchoice%>' selected><%=fabricchoice%></option>
            <%End If
			Do until rs.EOF
			%>
				<option value='<%=rs("fabric")%>'><%=rs("fabric")%></option>
			<%rs.movenext
			loop
			rs.close
			set rs=nothing%>
	<% elseif fabric = "Muirhead" then 
		Set rs = getMysqlUpdateRecordSet("Select * from fabric Where fabricoption=4", con)
			If fabricchoice<>"" Then%>
           	<option value='<%=fabricchoice%>' selected><%=fabricchoice%></option>
            <%End If
			Do until rs.EOF
			%>
				<option value='<%=rs("fabric")%>'><%=rs("fabric")%></option>
			<%rs.movenext
			loop
			rs.close
			set rs=nothing
		elseif fabric = "None" then %>
			<option value='None' selected>None</option>
	<%elseif fabric = "TBC" then %>
			<option value='TBC' selected>TBC</option>
     <%elseif fabric = "ClientsFabric" then %>
			<option value='Clients Own Fabric' selected>Client's Own Fabric</option>
	<% end if %>
</select>
<%Con.close
set Con=nothing%>