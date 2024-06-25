<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim postcode, sql, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, emailcheck, custcode, msg, custurls, emailadd
emailadd=request("emailadd")
emailcheck=""
custurls=""
count=0
submit=Request("submit")
if request("submit2")<> "" then submit=request("submit2")
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>
<script src="scripts/keepalive.js"></script>
</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">
<%if msg<>"" then response.Write("<p><a href=<font color=""red"">" & msg & "</font></p>")%>
<%If submit<>"" then
	if Request("postcode")<>"" Then 
	postcodefull=Request("postcode")
	postcode=Replace(postcodefull, " ", "")
	end if%>

<p>All customers from the database with the postcode entered are listed below.  If the customer exists already please click on the relevant customer.</p>
<p>If the customer does not exist please enter a new record by clicking here </p>
<p><a href="brochure.asp?basic=n&postcode=<%=postcodefull%>&email=<%=emailadd%>">NEW RECORD</a><<</p>
<p>&nbsp;</p>
	
<%Set Con = getMysqlConnection()
if retrieveuserregion()=1 then
	If postcode<>"" Then
		Set rs = getMysqlQueryRecordSet("Select * from address A, contact C Where C.retire='n' AND A.code=C.code and A.postcode<>''", con)
	end if
	If emailadd<>"" Then
		Set rs = getMysqlQueryRecordSet("Select * from address A, contact C Where C.retire='n' AND A.code=C.code and A.email_address<>''", con)
	end if
else
	If postcode<>"" Then
		Set rs = getMysqlQueryRecordSet("Select * from address A, contact C Where A.postcode<>'' and C.idlocation=" & retrieveuserlocation() & " AND C.retire='n' AND A.code=C.code", con)
	end if
	If emailadd<>"" Then
		Set rs = getMysqlQueryRecordSet("Select * from address A, contact C Where A.email_address<>'' and C.idlocation=" & retrieveuserlocation() & " AND C.retire='n' AND A.code=C.code", con)
	end if
end if
Do until rs.EOF
If postcode<>"" Then
	rspostcode=Replace(rs("postcode"), " ", "")
	If trim(lcase(rspostcode))=trim(lcase(postcode)) AND postcode<>"" Then 
		response.Write("<p><a href=""editcust.asp?val=" & rs("contact_no") & """>")
		If rs("title")<>"" then response.write(rs("title") & " ")
		If rs("first")<>"" then response.write(rs("first") & " ")
		If rs("surname")<>"" then response.write(rs("surname") & " ")
		If rs("company")<>"" then response.write(rs("company"))
		If rs("street1")<>"" then response.write(", " & rs("street1"))
		If rs("street2")<>"" then response.write(", " & rs("street2"))
		If rs("street3")<>"" then response.write(", " & rs("street3"))
		If rs("town")<>"" then response.write(", " & rs("town"))
		If rs("county")<>"" then response.write(", " & rs("county"))
		If rs("postcode")<>"" then response.write(", " & rs("postcode"))
		If rs("country")<>"" then response.write(", " & rs("country"))
		response.Write("</a><br></p>")
		count=count+1
	End If
	
End If
if emailadd<>"" then
	If trim(lcase(emailadd))=trim(lcase(rs("email_address"))) Then 
		response.Write("<p><a href=""editcust.asp?val=" & rs("contact_no") & """>")
		If rs("title")<>"" then response.write(rs("title") & " ")
		If rs("first")<>"" then response.write(rs("first") & " ")
		If rs("surname")<>"" then response.write(rs("surname") & " ")
		If rs("company")<>"" then response.write(rs("company"))
		If rs("street1")<>"" then response.write(", " & rs("street1"))
		If rs("street2")<>"" then response.write(", " & rs("street2"))
		If rs("street3")<>"" then response.write(", " & rs("street3"))
		If rs("town")<>"" then response.write(", " & rs("town"))
		If rs("county")<>"" then response.write(", " & rs("county"))
		If rs("postcode")<>"" then response.write(", " & rs("postcode"))
		If rs("country")<>"" then response.write(", " & rs("country"))
		response.Write("</a><br></p>")
		count=count+1
	End If
	
End If
rs.movenext
loop
rs.close
set rs=nothing
Con.Close
Set Con = Nothing

If count=0 then response.redirect("brochure.asp?postcode=" & postcodefull & "&email=" & emailadd & "")
Else%>
		<form action="check-postcode.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	<p>Enter postcode for customer:
		  <input name="postcode" type="text" id="postcode" size="10" onKeyDown="javascript: clearemail();" />
			  <input type="submit" name="submit" value="Submit Postcode"  id="submit" class="button" />
			</p>
    </form>
            <form action="check-postcode.asp" method="post" name="form2" onSubmit="return FrontPage_Form1_Validator(this)">
		  <p>Enter email address for customer:
            <input name="emailadd" type="text" id="emailadd" size="10" onKeyDown="javascript: clearpostcode();" />
            <input type="submit" name="submit2" value="Check Email address"  id="submit2" class="button" />
          </p>
		 
    </form>	
<%End If%>       
  </div>
  </div>
<div>
</div>
       
</body>
</html>
<script Language="JavaScript" type="text/javascript">
<!--
function FrontPage_Form1_Validator(theForm)
{
 
   if (theForm.postcode.value == "")
  {
    alert("Please enter the postcode");
    theForm.postcode.focus();
    return (false);
  }


    return true;
} 

function clearemail() {
	$('#emailadd').val('');
}
function clearpostcode() {
	$('#postcode').val('');
}

//-->
</script>
   
<!-- #include file="common/logger-out.inc" -->
