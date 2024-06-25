<%Option Explicit%>
<!-- #include file="common/utilfuncs.asp" -->
<%
response.write(getCurrencySymbolForCurrency(request("currency")))
%>