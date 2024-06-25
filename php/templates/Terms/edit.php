<?php use Cake\Routing\Router; ?>
<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/ckeditor/lang/_languages.js"></script>
<script src="/ckeditor/_samples/sample.js" type="text/javascript"></script>
<link href="/ckeditor/_samples/sample.css" rel="stylesheet" type="text/css" />

<div id="brochureform" class="brochure">
<h1>Edit Showroom Data</h1>


<div id="alerts">
		<noscript>
			<p>
				<strong>CKEditor requires JavaScript to run</strong>. In a browser with no JavaScript
				support, like yours, you should still see the contents (HTML data) and you should
				be able to edit it normally, without a rich editor interface.
			</p>
		</noscript>
	</div>

		<form action="edit" method="post" name="form1">	
		<input name="idlocation" type="hidden" value="<?php echo $row['idlocation']; ?>">
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
			<textarea cols="80" id="editor1" name="editor1" rows="10"><?php echo $row['terms']; ?></textarea>
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
        <input type="submit" name="submit" value="Edit Terms"  id="submit" class="button" />
	</form>

</div>