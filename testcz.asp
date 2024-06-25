<%Option Explicit%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim postcode, postcodefull, val, Con, rs, rs1, rs2, recordfound, id, rspostcode, submit, count, findus, sql, accessoryid, formfield, accessorytext, pressid, presstext, presspriority, imageid, region, localeref, charsetref

count=0
val=""
val=Request("val")
submit=Request("submit") 
Session.LCID=1029
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
<script type="text/javascript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
</head>
<body onLoad="MM_preloadImages('images/admin-buttonr.gif')">

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">
<%If submit<>"" Then 
%>

    <p>Your page has been amended on the website.</p>
        
	<%
Set rs = getMysqlUpdateRecordSet("Select * from czech", con)
	
		If request("editor1")<>"" Then rs("testtext")=Request("editor1")
	

rs.Update
rs.close
set rs=nothing
else
Set rs = getMysqlUpdateRecordSet("Select * from czech", con)
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
			<form action="<%=Request.ServerVariables("SCRIPT_NAME")%>" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
			
			<p>Amend text:</p>
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
			<input name="val" type="hidden" id="val" value="<%=val%>">
	
			
	
			  <textarea cols="80" id="editor1" name="editor1" rows="10"><%=rs("testtext")%></textarea>
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
						if ( editor )
							editor.destroy();
	
						// Replace the <textarea id="editor"> with an CKEditor
						// instance, using default configurations.
						editor = CKEDITOR.replace( 'editor2',
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
	
        <input type="submit" name="submit" value="Amend web page"  id="submit" class="button" />
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
       
</body>
</html>

   