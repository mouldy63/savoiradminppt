<!-- #include file="funcs.asp" -->
<%
dim userRoles, ret, user
userRoles = retrieveUserRoles()
user = retrieveUserName()
'response.write("<br>userRoles = " & userRoles)
'response.end

if userRoles <> "" then
	ret = request("ret")
	if ret <> "" then
		response.redirect(ret)
	else
		response.redirect("/php/home")
	end if
end if

dim failed
failed = Request("failed")
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<HTML lang="EN"> 


<head>
<title>Admin</title>
<style type="text/css">
<!--
//-->
</style>
<script language="JavaScript">
<!--

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>
<meta name="robots" content="noindex">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="/Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
</head>

<body bgcolor="#FFFFFF" bordercolor="#663366"  border="15" onLoad="MM_preloadImages('/lib/navigation/corres_links_but_roll2.gif')" >
<div class="container">
<img src="../images/logo-s.gif" width="255" height="40">
<p><% if failed = "true" THEN %>
</p>
<div align="center"><b class="maintext">Login 
  failed - please try again</b> </div>
  <% End If %>
<form method="post" action="login.asp">
  <input type="hidden" name="ret" value="<%=Server.HtmlEncode(request("ret"))%>" />
  <div align="center">
    <center>
      <table border="0" width="347">
        <tr> 
          <td width="142" class="bodytext"><b class="maintext">User Name</b></td>
          <td width="127" class="bodytext"><b class="maintext">Password</b></td>
          <td width="64"></td>
        </tr>
        <tr> 
          <td> 
            <input type="text" name="username" size="30">
          </td>
          <td> 
            <input type="password" name="password" size="15">
          </td>
          <td> 
            <input type="submit" value="Log In...">
          </td>
        </tr>
      </table>
    </center>
  </div>
</form>
</div>
</body>
</html>
