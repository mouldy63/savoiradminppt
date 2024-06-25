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
<%Dim postcode, postcodefull, Con, rs, sql, recordfound, id, rspostcode, submit, count, correspondence, location
location=retrieveuserlocation()
'response.Write(location)
count=0
submit=Request("submit") 
Set Con = getMysqlConnection()%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
	<script type="text/javascript" src="ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="ckeditor/lang/_languages.js"></script>
	<script src="ckeditor/_samples/sample.js" type="text/javascript"></script>
	<link href="ckeditor/_samples/sample.css" rel="stylesheet" type="text/css" />

<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>
<script src="scripts/keepalive.js"></script>

</head>
<body>

<div class= "container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">
<%If submit<>"" Then 
%>

<p>Your terms has now been added/edited.</p>
	
<%
Set rs = getMysqlUpdateRecordSet("Select * from location where idlocation=" & location, con)
rs("datetermsamended")=date()
rs("termsamendedby")=retrieveUserName()
rs("terms")=Request("editor1")
rs.Update
rs.close
set rs=nothing

Else
%>
<div id="alerts">
		<noscript>
			<p>
				<strong>CKEditor requires JavaScript to run</strong>. In a browser with no JavaScript
				support, like yours, you should still see the contents (HTML data) and you should
				be able to edit it normally, without a rich editor interface.
			</p>
		</noscript>
	</div><%Set rs = getMysqlUpdateRecordSet("Select * from location where idlocation=" & location, con)%>

		<form action="store-terms.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
        <p>&nbsp;</p>

      </p>
<p>


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
			<textarea cols="80" id="editor1" name="editor1" rows="10"><%=rs("terms")%></textarea>
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
			</script>
	      <br>
	      <br>
        </p>
        <input type="submit" name="submit" value="Add/Edit Terms"  id="submit" class="button" />
	</form>
<%rs.close
set rs=nothing
End If
Con.Close
Set Con = Nothing%>       
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
 
   if (theForm.correspondencename.value == "")
  {
    alert("You need to give this correspondence a name so you can refer to it later");
    theForm.correspondencename.focus();
    return (false);
  }

 

    return true;
} 

//-->
</script>
<!-- #include file="common/logger-out.inc" -->
