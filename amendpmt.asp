<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES,ACCOUNTS"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim postcode, postcodefull, val, Con, rs, rs1, recordfound, id, rspostcode, submit, count, findus, sql, totalpayments, purchaseno, paymentoamend
count=0
totalpayments=""
purchaseno=""
val=""
submit=""
val=Request("val")
submit=Request("submit") 
Set Con = getMysqlConnection()%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta content="text/html; charset=utf-8" http-equiv="content-type" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
	<script type="text/javascript" src="ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="ckeditor/lang/_languages.js"></script>
	<script src="ckeditor/_samples/sample.js" type="text/javascript"></script>
<SCRIPT LANGUAGE="VBScript">
Function MyForm_onSubmit
  If Msgbox("Are you sure you want to delete this record?", vbYesNo + vbExclamation) = vbNo Then
    MyForm_onSubmit = False
  End If
End Function
</SCRIPT>
<link href="ckeditor/_samples/sample.css" rel="stylesheet" type="text/css" />

<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>
<body>
<% if userHasRoleInList("ACCOUNTS") then %>
<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">


<%If submit<>"" Then 
%>

	
<%
sql="Select * from payment where paymentid=" & val
'response.Write("sql=" & sql)
'response.End()

Set rs = getMysqlUpdateRecordSet(sql, con)
purchaseno=rs("purchase_no")
rs("amendedfrom")=rs("amount")
paymentoamend=rs("amount")
rs("amount")=Request("amount")
rs("reasonforamend")=Request("reasonforamend")
rs("dateofamend")=date()
rs("amendedby")=retrieveUserName()
rs.Update
rs.close
set rs=nothing

sql="Select SUM(amount) AS totalpayments from payment where purchase_no=" & purchaseno
Set rs = getMysqlUpdateRecordSet(sql, con)
'response.Write("Total Payments=" & CCur(rs("totalpayments")))
totalpayments=CCur(rs("totalpayments"))
'response.End()
rs.close
set rs=nothing

sql="Select * from purchase where purchase_no=" & purchaseno
'response.Write("sql=" & sql)
Set rs = getMysqlUpdateRecordSet(sql, con)
Dim totalcost
totalcost=rs("total")
rs("paymentstotal")=totalpayments
rs("balanceoutstanding")=CCur(rs("total"))-totalpayments
rs.update
rs.close
set rs=nothing%>
<p>Your payment has been updated from <%=paymentoamend%> to <%=request("amount")%>.</p>
<p><a href="accounts.asp?location=<%=request("location")%>&datefrom=<%=request("datefrom")%>&dateto=<%=request("dateto")%>&user=<%=request("user")%>">Return to Accounts</a></p>
<%Else

sql="Select * from payment P, purchase R where P.purchase_no=R.purchase_no and P.paymentid=" & val
'response.Write("sql=" & sql)
'response.End()
Set rs = getMysqlUpdateRecordSet(sql, con)
%>		<form action="amendpmt.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">
  <p>
  <label>Payment Amount<br>  </label>
    <input name="amount" type="text" id="amount">
    currently <%=rs("amount")%><br>
    <br>
    <label> Reason for amendment<br></label>
    <input name="reasonforamend" type="text" id="reasonforamend">

  </p>
  <p><input name="val" type="hidden" id="val" value="<%=val%>">

    <input type="submit" name="submit" value="Update Payment"  id="submit" class="button" />
  </p>
 <p><a href="accounts.asp?location=<%=request("location")%>&datefrom=<%=request("datefrom")%>&dateto=<%=request("dateto")%>&user=<%=request("user")%>">Return to Accounts</a></p>
</form>
<%
rs.close
set rs=nothing
End If
Con.Close
Set Con = Nothing%>       
  </div>
  </div>
<div>
</div>
<%end if%>       
</body>
</html>

   
<!-- #include file="common/logger-out.inc" -->
