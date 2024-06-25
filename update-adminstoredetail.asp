<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,WEBSITEADMIN"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim val, Con, rs, rs1, recordfound, id, submit, count, findus, sql, add1, add2, add3, town, countystate, postcode, tel, fax, email, openingdays, openingtimes, openingmoreinfo, moreinfo, sageref, bankacname, bankacno, bankroutingno, banksortcode, bankname, bankaddress, iban, swift, paymentterms, invoicenote1, invoicenote2, invoicenote3, invoicenote4, invoicenote5, invoicenote6, invoiceconame, invoiceadd1, invoiceadd2, invoiceadd3, invoicetown, invoicecountry, invoicepostcode, termsvalid, savoirowned
count=0
val=""
val=Request("val")
savoirowned=request("savoirowned")
add1=request("add1")
add2=request("add2")
add3=request("add3")
town=request("town")
termsvalid=request("termsvalid")
countystate=request("county")
postcode=request("postcode")
tel=request("tel")
fax=request("fax")
email=request("email")
openingdays=request("odays")
openingtimes=request("otime")
openingmoreinfo=request("omoreinfo")
sageref=request("sageref")
bankacname=request("bankacname")
bankacno=request("bankacno")
bankroutingno=request("bankroutingno")
banksortcode=request("banksortcode")
bankname=request("bankname")
bankaddress=request("bankaddress")
iban=request("iban")
swift=request("swift")
paymentterms=request("paymentterms")
invoicenote1=request("invoicenote1")
invoicenote2=request("invoicenote2")
invoicenote3=request("invoicenote3")
invoicenote4=request("invoicenote4")
invoicenote5=request("invoicenote5")
invoicenote6=request("invoicenote6")
invoiceconame=request("invoiceconame")
invoiceadd1=request("invoiceadd1")
invoiceadd2=request("invoiceadd2")
invoiceadd3=request("invoiceadd3")
invoicetown=request("invoicetown")
invoicecountry=request("invoicecountry")
invoicepostcode=request("invoicepostcode")

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

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">



<p>
	
<%sql="Select * from location WHERE idlocation=" & val & ""
'response.Write("sql=" & sql)
'response.End()
Set rs = getMysqlUpdateRecordSet(sql, con)
rs("savoirowned")=savoirowned
moreinfo = Replace(openingmoreinfo, chr(10),"<br />")
if add1<>"" then rs("add1")=add1 else rs("add1")=null
if add2<>"" then rs("add2")=add2 else rs("add2")=null
if add3<>"" then rs("add3")=add3 else rs("add3")=null
if town<>"" then rs("town")=town else rs("town")=null
if countystate<>"" then rs("countystate")=countystate else rs("countystate")=null
if postcode<>"" then rs("postcode")=postcode else rs("postcode")=null
if tel<>"" then rs("tel")=tel else rs("tel")=null
if email<>"" then rs("email")=email else rs("email")=null
if fax<>"" then rs("fax")=fax else rs("fax")=null
if openingdays<>"" then rs("openingdays")=openingdays else rs("openingdays")=null
if openingtimes<>"" then rs("openingtimes")=openingtimes else rs("openingtimes")=null
if moreinfo<>"" then rs("openingmoreinfo")=moreinfo else rs("openingmoreinfo")=null
rs.update
rs.close
set rs=nothing

sql="Select * from showroomdata WHERE showroomlocationid=" & val & ""
'response.Write("sql=" & sql)
'response.End()
Set rs = getMysqlUpdateRecordSet(sql, con)

if sageref<>"" then rs("sageref")=sageref else rs("sageref")=null
if bankacname<>"" then rs("bankacname")=bankacname else rs("bankacname")=null
if bankacno<>"" then rs("bankacno")=bankacno else rs("bankacno")=null
if bankroutingno<>"" then rs("bankroutingno")=bankroutingno else rs("bankroutingno")=null
if banksortcode<>"" then rs("banksortcode")=banksortcode else rs("banksortcode")=null
if bankname<>"" then rs("bankname")=bankname else rs("bankname")=null
if bankaddress<>"" then rs("bankaddress")=bankaddress else rs("bankaddress")=null
if iban<>"" then rs("iban")=iban else rs("iban")=null
if swift<>"" then rs("swift")=swift else rs("swift")=null
if paymentterms<>"" then rs("paymentterms")=paymentterms else rs("paymentterms")=null
if invoicenote1<>"" then rs("invoicenote1")=invoicenote1 else rs("invoicenote1")=null
if invoicenote2<>"" then rs("invoicenote2")=invoicenote2 else rs("invoicenote2")=null
if invoicenote3<>"" then rs("invoicenote3")=invoicenote3 else rs("invoicenote3")=null
if invoicenote4<>"" then rs("invoicenote4")=invoicenote4 else rs("invoicenote4")=null
if invoicenote5<>"" then rs("invoicenote5")=invoicenote5 else rs("invoicenote5")=null
if invoicenote6<>"" then rs("invoicenote6")=invoicenote6 else rs("invoicenote6")=null
if invoiceconame<>"" then rs("invoiceconame")=invoiceconame else rs("invoiceconame")=null
if invoiceadd1<>"" then rs("invoiceadd1")=invoiceadd1 else rs("invoiceadd1")=null
if invoiceadd2<>"" then rs("invoiceadd2")=invoiceadd2 else rs("invoiceadd2")=null
if invoiceadd3<>"" then rs("invoiceadd3")=invoiceadd3 else rs("invoiceadd3")=null
if invoicetown<>"" then rs("invoicetown")=invoicetown else rs("invoicetown")=null
if invoicecountry<>"" then rs("invoicecountry")=invoicecountry else rs("invoicecountry")=null
if invoicepostcode<>"" then rs("invoicepostcode")=invoicepostcode else rs("invoicepostcode")=null
if termsvalid="y" then rs("termsenabled")="y" else rs("termsenabled")="n"

rs.update
rs.close
set rs=nothing
Con.Close
Set Con = Nothing%>  
The Showroom details have been updated - <a href="javascript: history.go(-2)">back to showroom selection page</a>
</p>     
  </div>
  </div>
<div>
</div>
       
</body>
</html>

   
<!-- #include file="common/logger-out.inc" -->
