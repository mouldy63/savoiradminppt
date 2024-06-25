<%Option Explicit
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="adovbs2.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->

<%
dim con, sql, sql2, rs, rs1, pn, thumbUrl, url, username, theType

pn = request("pn")
theType = request("type")

Set con = getMysqlConnection()

sql = "select * from purchase_attachment where purchase_no=" & pn & " and type='" & theType & "'"
set rs = getMysqlQueryRecordSet(sql, con)

%>

<%
while not rs.eof
thumbUrl = "/order_attachment_thumbs/" & rs("thumbnail")
url = "php/services/dropzoneDownload/" & rs("purchase_attachment_id")
if rs("user_id")<>"" then
sql2 = "select * from savoir_user where user_id=" & rs("user_id")
set rs1 = getMysqlQueryRecordSet(sql2, con)
username=rs1("username")
rs1.close
set rs1=nothing
else 
username=""
end if

%>

<div style="float:left; margin-right:10px; margin-bottom:20px; padding-right:10px">
<%if isSuperUser() or userHasRole("BED_PHOTOS_DEL") then %>
<div><a href='#' onclick='deleteAttachment_<%=theType%>("<%=rs("purchase_attachment_id")%>", "<%=rs("id")%>")' >Delete below</a><br /><br /></div>
<%end if%>
<a href='<%=url%>' href='<%=thumbUrl%>' data-lightbox="example-set" ><img src='<%=thumbUrl%>' alt='<%=rs("filename")%>' title='<%=rs("filename")%>' height='50'/><br /><%=rs("upload_date")%><br /><%=username%><br /><%=left(rs("filename"),20)%></a>
<hr />	
</div>
<%
	rs.movenext
wend
%>

<div class="clear"></div>
<%
call closemysqlrs(rs)
call closemysqlcon(con)
%>