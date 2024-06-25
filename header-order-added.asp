<form name="back_form" id="back_form" action="aaa-add-order.asp" >
	<a href="javascript:submitBack();">back</a>
	<input type="submit" name="submit" value="Save Quote" id="submit" class="button" tabindex="105" />
</form>


<table width="952" border="0" cellpadding="0" cellspacing="0" summary="page layout">
  <tr >
    <td width="25%" class="logobg" ><p align="left" class="lindalliancelogo"><img src="/images/logo.gif" width="255" height="66" /><br>
      </p>
    </td>
    <td width="50%" valign="middle" class="logobg"><div align="center">
      <h1 class="lindalliancelogo"><br>
        <em class="strapline">  Administration Area </em></h1>
    </div></td>
    <td width="25%" valign="middle" class="logobg"><div align="left">
      <p align="right">&nbsp;</p>
      </div></td>
  </tr>
  <tr bgcolor="#CCCCCC">
    <td height="25">&nbsp;</td>
    <td height="25" colspan="2"><p align="right"><a href="/index.asp"> Admin Menu </a>&nbsp;|&nbsp;<a href="javascript:submitBack();"> Back </a>&nbsp;|&nbsp;<a href="/access/logout.asp"> Logoff</a></p></td>
  </tr>
</table>
<script Language="JavaScript" type="text/javascript">
	function submitBack() {
		alert($("#back_form").name);
	    $("#back_form").submit();
	}
</script>