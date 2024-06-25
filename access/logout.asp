<% option explicit %>
<!-- #include file="../common/adovbs2.inc" -->
<!-- #include file="../common/mysqldbfuncs.asp" -->
<!-- #include file="funcs.asp" -->
<%
Dim ret, con
set con = getMysqlConnection()
call clearUserSession(con)
ret = request("ret")
if ret <> "" then
	response.redirect ret
else
	response.redirect "/php/services/closeSession"
end if
%>

