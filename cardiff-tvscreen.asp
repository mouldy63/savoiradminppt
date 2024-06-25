<tr>
      <td width="4%" valign="top"><a href="orderdetails.asp?pn=<%=rs("purchase_no")%>" target="_blank"><font size="+2"><%=rs("order_number")%></font></a></td>
      <td width="7%" valign="top" id="bespoke2"><%=left(custname,25)%><br>
      <%=left(rs("companyname"),25)%></td>
      <td width="6%" valign="top"id="bespoke2"><%=rs("customerreference")%></td>
      <td width="8%" valign="top"id="bespoke2"><%=rs("adminheading")%></td>
      <%
	  if rs("savoirmodel")<>"" and NOT ISNULL(rs("savoirmodel")) and compmadeat1=madeat then
	 
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
