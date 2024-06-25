<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="fieldoptionfuncs.asp" -->
<%
Dim con
Set con = getMysqlConnection()

response.write(makeOptionString2(request("fieldname"), "", true, request("defaultsrcfield"), request("defaultsrcopt"), true, false, con))
'response.write("<option>TEST</option>")

con.close
set con=nothing
%>