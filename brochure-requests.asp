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
<!-- #include file="generalfuncs.asp" -->
<%Dim postcode, postcodefull, Con, rs, rs1, sql, recordfound, id, rspostcode, submit, count, msg, fontclass, brochureRequestType
msg=""
msg=Request("msg")
count=0
submit=Request("submit") 
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
<style>
.fontcol, .fontcol a:link,  .fontcol a:active, .fontcol a:visited {color:#FF0000;}
</style>
</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">
<% 
postcodefull=Request("postcode")
postcode=Replace(postcodefull, " ", "")
If msg<>"" Then response.Write("<p><font color=""red"">The Brochure Requests were " & msg & "</font></p>")%>
<p>The following brochure requests need processing.</p>
<p class="b"> <a href="javascript:selectAll()">Select All</a>&nbsp;|
    <a href="javascript:deselectAll()">Deselect All</a>&nbsp;</p>
<p>

<form name="form1" method="post" action="print.asp"  onSubmit="return OnSubmitForm();">	
  <p>
    <%Set Con = getMysqlConnection()
sql = "Select C.title, C.first, C.surname, A.company, A.street1, A.street2, A.street3, A.Town, A.County, A.country, A.postcode, A.first_contact_date, C.owning_region, C.idlocation, C.source_site, C.owning_region, C.code, C.contact_no, L.location from address A, contact C, Location L Where C.idlocation=L.idlocation and C.retire='n' AND A.code=C.code AND C.brochurerequestsent='n'"
if not isSuperuser() and retrieveUserLocation()<>1 then
	if retrieveuserregion()=18 then
		'sql = sql & " AND (C.owning_region=6 or C.owning_region=18)"
	else
		sql = sql & " AND C.owning_region=" & retrieveuserregion()
	end if
	If retrieveuserlocation()<>3 and retrieveuserregion()<>9 then
		sql = sql & " AND C.idlocation=" & retrieveUserLocation()
	end if
	If retrieveuserlocation()=3 then
	sql = sql & " AND C.idlocation<>36"
	end if
	sql = sql & " AND C.source_site='" & retrieveUserSite() & "'"
end if
'response.write("<br>" & sql)
Set rs = getMysqlQueryRecordSet(sql, con)
response.Write("Total = " & rs.recordcount & "<br /><br />")
Do until rs.EOF
if rs("owning_region")="18" then
	response.Write("<p class=""fontcol"">")
else
	response.Write("<p>")
end if
response.Write("<input type=""checkbox"" name=""XX_" & rs("code") & """ id=""XX_" & rs("code") & """><a href=""editcust.asp?val=" & rs("contact_no") & """>")
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
if retrieveuserlocation()=1 then
response.write(" <font color=""red"">Showroom: " & rs("location") & "</font>")
end if
sql="Select * from communication where code=" & rs("code") & " and type like '%brochure%' order by date desc"

Set rs1 = getMysqlQueryRecordSet(sql, con)
brochureRequestType = "Postal"
if NOT rs1.eof then
response.Write(", " & rs1("date"))
	if not isnull(rs1("type")) and rs1("type") = "Digital Brochure sent by email" then brochureRequestType = "Digital"
else
response.Write(", " & rs("first_contact_date"))
end if
rs1.close
set rs1=nothing
response.write(" <font color=""blue"">Type: " & brochureRequestType & "</font>")
response.Write("</a><br></p>")
count=count+1
rs.movenext
loop
rs.close
set rs=nothing
Con.Close
Set Con = Nothing%>
    
    <label>
      &nbsp;&nbsp; <input name="corresid" type="hidden" value="1">
      <input type="submit" name="submit1" id="submit1" value="Print Letters">
    </label>
    <input type="submit" name="submit2" id="submit2" value="Print Labels">
   
   <%if retrieveUserLocation()=8 then%>
   <input type="submit" name="submit5" id="submit5" value="Print 2 x 3 Labels">
   <%else%>
   <input type="submit" name="submit5" id="submit5" value="Print 3 x 7 Labels">
   <%end if%>
    <input type="submit" name="submit3" id="submit3" value="Remove Brochure Requests" onClick="return confirm('Have you printed the labels and the letters? Clicking OK below will now remove these brochure requests from the queue?'); ">
    
    <input type="submit" name="submit6" id="submit6" onClick="document.pressed=this.value" value="Download CSV file">
  </p>
  <p><strong>Please use back button on your browser once you have finished printing. REMEMBER - once you are happy you have printed the labels and letters return and remove brochure request(s) from the list above. <font color="#FF0000">NB: A follow update has been added for brochure request letters which you have queued for printing - if printing has failed you will need to remove / adjust the follow-up date</font></strong></p>
<P>  <input type="submit" name="submit4" id="submit4" value="Delete Entries (SPAM ONLY)" onClick="return confirm('Are you sure you want to DELETE these brochure requests?'); "></p>
</form>
<%If count>25 then%>
<p><a href="#top" class="addorderbox">&gt;&gt; Back to Top</a></p>
<%end if%>
</div>
  </div>
<div>
</div>

</body>
</html>
 <script language="JavaScript">
<!--
function OnSubmitForm()
{
  if(document.pressed == 'Download CSV file')
  {//alert("edit");
   document.form1.action ="admin-csv.asp";
  }
  return true;
}
function selectAll() {

	if (document.form1.elements) {
	    for (var j = 0; j < document.form1.elements.length; j++) {
	        var e = document.form1.elements[j];
	        if (e.type == "checkbox" && e.name.length > 2 && e.name.substr(0,3) == "XX_" ) {
	            e.checked = true;
	        }
	    }
	}

}

function deselectAll() {

	if (document.form1.elements) {
	    for (var j = 0; j < document.form1.elements.length; j++) {
	        var e = document.form1.elements[j];
	        if (e.type == "checkbox" && e.name.length > 2 && e.name.substr(0,3) == "XX_" ) {
	            e.checked = false;
	        }
	    }
	}

}

//-->
</script>
   
<!-- #include file="common/logger-out.inc" -->
