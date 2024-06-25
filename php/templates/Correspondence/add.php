<?php use Cake\Routing\Router; ?>

<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/ckeditor/lang/_languages.js"></script>
<script src="/ckeditor/_samples/sample.js" type="text/javascript"></script>
<link href="/ckeditor/_samples/sample.css" rel="stylesheet" type="text/css" />

<div id="brochureform" class="brochure">
<div id="alerts">
		<noscript>
			<p>
				<strong>CKEditor requires JavaScript to run</strong>. In a browser with no JavaScript
				support, like yours, you should still see the contents (HTML data) and you should
				be able to edit it normally, without a rich editor interface.
			</p>
		</noscript>
	</div>
<h1>Add New Correspondence (NOT brochure requests)</h1>
<form action="/php/correspondence/add" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
<p>The following letter can be printed and sent to all customers by using the Search Customers menu on the <a href="index.asp">Main Admin Menu.</a></p>
<p>Amend letter here:</p>

<p>Add a name for the correspondence (i.e. brochure letter or January Sales promotion etc)</p>
<p>  
  <label>
    <br>
    <input name="correspondencename" type="text" id="correspondencename" size="40" maxlength="55">
  </label></p>

<hr>
<p><strong>If you would like to add Dear Mr xxxxx then </strong> enter greeting i.e. Dear<br>
  <br>
<label>
  <input name="greeting" type="text" id="greeting" value="" size="20">
  </label> 
  this will then automatically add your greeting.
  <br>
</p>
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
			<textarea cols="80" id="editor1" name="editor1" rows="10"></textarea>
<input name="correspondence" type="hidden" value="<%=correspondence%>">
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
	      <input type="submit" name="submit" value="Add Letter"  id="submit" class="button" />
        </p>
        
	</form>

</div>

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