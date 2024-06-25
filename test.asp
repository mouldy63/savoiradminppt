<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="componentfuncs.asp" -->
<%
dim con, componentPriceExVatAfterDiscount
Set Con = getMysqlConnection()

componentPriceExVatAfterDiscount = getComponentPriceExVatAfterDiscount(con, 75981, 1)
response.write("<br>componentPriceExVatAfterDiscount = " & componentPriceExVatAfterDiscount)
%>