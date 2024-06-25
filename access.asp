<% 
dim failed
failed = Request.QueryString ("failed")
%>
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="commonstanbridgeearls.css" rel="stylesheet" type="text/css">
</head>

<body bgcolor="#FFFFFF" bordercolor="#663366"  border="15" onLoad="MM_preloadImages('/lib/navigation/corres_links_but_roll2.gif')" >
<p><% if failed = "true" THEN %>
</p>
<div align="center"><b class="maintext">Login 
  failed - please try again</b> 
  <% End If %>
<font face="verdana" size="2"> </font> <font face="verdana" size="2"> </font></div>
<font face="verdana" size="2">
<form method="post" action="login.asp">
  <div align="center">
    <center>
      <p><!--#include file="header.asp"-->&nbsp;</p>
      <table border="0" width="347">
        <tr> 
          <td width="142" class="bodytext"><b class="maintext">User Name</b></td>
          <td width="127" class="bodytext"><b class="maintext">Password</b></td>
          <td width="64"></td>
        </tr>
        <tr> 
          <td> 
            <input type="text" name="username" size="10">
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
</font>
<center>
  <p>&nbsp;</p>
  <p>&nbsp;</p>
</center>
<p align="center"><b></b></p>
</body>
</html>
