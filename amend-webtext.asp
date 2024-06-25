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
<%Dim Con, rs, val
val=Request("val")
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
	<link href="ckeditor/_samples/sample.css" rel="stylesheet" type="text/css" />

<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">
	
<%
Set rs = getMysqlQueryRecordSet("Select * from texts WHERE text_id=" & val, con)
response.Write("<b>The page will edit the " & rs("textkey") & " text</b>")
%>
<div id="alerts">
		<noscript>
			<p>
				<strong>CKEditor requires JavaScript to run</strong>. In a browser with no JavaScript
				support, like yours, you should still see the contents (HTML data) and you should
				be able to edit it normally, without a rich editor interface.
			</p>
		</noscript>
	</div>
		<form action="update-text.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
        <p>Amend web text below</a> 
<%if val=3605 OR val=3606 then response.write(" OR <b><a href=""savoiridimages.asp""><font color=red>AMEND SAVOIRID.COM IMAGES</font></a></b>")
if val=3607 OR val=3608 then response.write(" OR <b><a href=""savoiridimagesA1.asp""><font color=red>AMEND SAVOIRID.COM IMAGES</font></a></b>")
if val=3609 OR val=3610 then response.write(" OR <b><a href=""savoiridimagesA2.asp""><font color=red>AMEND SAVOIRID.COM IMAGES</font></a></b>")
if val=3611 OR val=3612 then response.write(" OR <b><a href=""savoiridimagesA3.asp""><font color=red>AMEND SAVOIRID.COM IMAGES</font></a></b>")%></p>


<hr>
<p>Available languages (<span id="count"> </span> languages!):<br />
			<script type="text/javascript">
			//<![CDATA[
				document.write( '<select disabled="disabled" id="languages" onchange="createEditor( this.value );">' );
				// Get the language list from the _languages.js file.
				for ( var i = 0 ; i < window.CKEDITOR_LANGS.length ; i++ )
				{
					document.write(
						'<option value="' + window.CKEDITOR_LANGS[i].code + '">' +
							window.CKEDITOR_LANGS[i].name +
						'</option>' );
				}
				document.write( '</select>' );
			//]]>
			</script>
			<br />
			<span style="color: #888888">(You may see strange characters if your system doesn't
				support the selected language)</span>
		</p>
		<p>
			<textarea cols="80" id="editor1" name="editor1" rows="10"><%=rs("text")%></textarea>
			<script type="text/javascript">
			//<![CDATA[

				// Set the number of languages.
				document.getElementById( 'count' ).innerHTML = window.CKEDITOR_LANGS.length;

				var editor;

				function createEditor( languageCode )
				{
					if ( editor )
						editor.destroy();

					// Replace the <textarea id="editor"> with an CKEditor
					// instance, using default configurations.
					editor = CKEDITOR.replace( 'editor1',
						{
							language : languageCode,

							on :
							{
								instanceReady : function()
								{
									// Wait for the editor to be ready to set
									// the language combo.
									var languages = document.getElementById( 'languages' );
									languages.value = this.langCode;
									languages.disabled = false;
								}
							}
						} );
				}

				// At page startup, load the default language:
				createEditor( '' );

			//]]>
			</script>	      </p>
		<%if isNull(rs("alertlive")) then
		else%>
        <p>Tick to make alert live:&nbsp; 
        <%if rs("alertlive")="y" then%>
        <input name="alertlive" type="checkbox" value="y" checked>
        <%else%>
        <input name="alertlive" type="checkbox" value="y">
        <%end if%>
		  </p>
          <%end if%>
		<input name="val" type="hidden" value="<%=val%>">
        <input type="submit" name="submit1" value="Amend Website Text"  id="submit1" class="button" />
	</form>
<%rs.close
set rs=nothing

Con.Close
Set Con = Nothing%>       
  </div>
  </div>
<div>
</div>
       
</body>
</html>

   
<!-- #include file="common/logger-out.inc" -->
