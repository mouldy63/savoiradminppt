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
<%Dim postcode, postcodefull, val, Con, rs, rs1, rs2, recordfound, id, rspostcode, submit, count, findus, sql, accessoryid, formfield, accessorytext, pressid, presstext, presspriority, imageid, region, localeref
region=retrieveUserRegion()
count=0
val=""
val=Request("val")
submit=Request("submit") 
Set Con = getMysqlConnection()
 sql="Select * from region WHERE id_region=" & region & ""
        'response.Write("sql=" & sql)
        'response.End()
        Set rs = getMysqlUpdateRecordSet(sql, con)
		localeref=rs("locale")
		rs.close
		set rs=nothing
		Session.LCID=localeref
%>

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
        
		<%If Request("findus")<>"" Then 
        sql="Select * from location WHERE idlocation=" & Request("findus") & ""
        'response.Write("sql=" & sql)
        'response.End()
        Set rs = getMysqlUpdateRecordSet(sql, con)
        If Request("add1")<>"" Then rs("add1")=Request("add1") else rs("add1")=Null
        If Request("add2")<>"" Then rs("add2")=Request("add2") else rs("add2")=Null
        If Request("add3")<>"" Then rs("add3")=Request("add3") else rs("add3")=Null
        If Request("town")<>"" Then rs("town")=Request("town") else rs("town")=Null
        If Request("county")<>"" Then rs("countystate")=Request("county") else rs("countystate")=Null
        If Request("postcode")<>"" Then rs("postcode")=Request("postcode") else rs("postcode")=Null
        If Request("tel")<>"" Then rs("tel")=Request("tel") else rs("tel")=Null
        If Request("fax")<>"" Then rs("fax")=Request("fax") else rs("fax")=Null
        If Request("email")<>"" Then rs("email")=Request("email") else rs("email")=Null
        If Request("narrative")<>"" Then rs("narrative")=Request("narrative") else rs("narrative")=Null
        If Request("openinghours")<>"" Then rs("openinghours")=Request("openinghours") else rs("openinghours")=Null
        rs.Update
        rs.close
        set rs=nothing
        End If

Set rs = getMysqlUpdateRecordSet("Select * from locationpages WHERE locationpageid=" & val & "", con)
	If rs("priority")=4 Then 
	Set rs1 = getMysqlUpdateRecordSet("Select * from accessorylink WHERE locationid=" & rs("locationid") & "", con)
	Do until rs1.eof
		rs1.delete
		rs1.update
		rs1.movenext
	loop
	rs1.close
	set rs1=nothing
	For Each formfield in Request.Form
		if left(formfield, 2) = "XX" then
			accessoryid=right(formfield,len(formfield)-2)
			accessorytext=trim(request.form("TT" & accessoryid))
			sql="INSERT INTO accessorylink (locationid,accessoryid,accessorytext) VALUES (" & rs("locationid") & "," & accessoryid & ",'" & accessorytext & "')"
			'response.Write("sql=" & sql)
			'response.End()
			con.execute(sql)
		end if
	Next 
	End IF
	
Set rs = getMysqlUpdateRecordSet("Select * from locationpages WHERE locationpageid=" & val & "", con)
	If rs("priority")=6 Then 
	Set rs1 = getMysqlUpdateRecordSet("Select * from pressads WHERE locationid=" & rs("locationid") & "", con)
	Do until rs1.eof
		rs1.delete
		rs1.update
		rs1.movenext
	loop
	rs1.close
	set rs1=nothing
	For Each formfield in Request.Form
		if left(formfield, 2) = "YY" then
			pressid=right(formfield,len(formfield)-2)
			imageid=trim(request.form("MM" & pressid))
			presspriority=trim(request.form("YY" & pressid))
			presstext=trim(request.form("PP" & pressid))
			sql="INSERT INTO pressads (locationid,imageid,priority,presstext) VALUES (" & rs("locationid") & ",'" & imageid & "','" & presspriority & "','" & presstext & "')"
			response.Write("sql=" & sql & "<br />")
			'response.End()
			con.execute(sql)
		end if
	Next 
	End IF

Set rs = getMysqlUpdateRecordSet("Select * from locationpages WHERE locationpageid=" & val & "", con)
	If rs("priority")=1 Then 
		If request("editor1")<>"" Then rs("desc")=Request("editor1")
		rs("title")=Request("editor2")
	End If
If rs("priority")=1 or rs("priority")=2 then
	rs("active")="y"
	else
	If Request("active") <>"" Then rs("active")="y" else rs("active")="n"
End If
rs.Update
rs.close
set rs=nothing

Else

Set rs = getMysqlQueryRecordSet("Select * from locationpages WHERE locationpageid=" & val & "", con)
Dim locationid
locationid=rs("locationid")
findus=""
	If rs("priority")="2" Then
	Set rs1 = getMysqlQueryRecordSet("Select * from location WHERE idlocation=" & rs("locationid") & "", con)
	%>		<form action="editpage.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
	<textarea name="narrative" cols="60" rows="4"><%=rs1("narrative")%></textarea>Opening narrative <br /><br />
	<label>
	  <input name="add1" type="text" id="add1" value="<%=rs1("add1")%>" size="40">Address line 1<br /><br />
	</label>
	<label>
	  <input type="text" name="add2" id="add2" value="<%=rs1("add2")%>" size="40">Address line 2<br /><br />
	</label>
	<label>
	  <input type="text" name="add3" id="add3" value="<%=rs1("add3")%>" size="40">Address line 3<br /><br />
	</label>
	<label>
	  <input type="text" name="town" id="town" value="<%=rs1("town")%>" size="40">Town<br /><br />
	</label>
	<label>
	  <input type="text" name="county" id="county" value="<%=rs1("countystate")%>" size="40">County / State<br /><br />
	</label>
	<label>
	  <input type="text" name="postcode" id="postcode" value="<%=rs1("postcode")%>" size="40">Postcode<br /><br />
	</label>
	<label>
	  <input type="text" name="tel" id="tel" value="<%=rs1("tel")%>" size="40">Tel<br /><br />
	</label>
	<label>
	  <input type="text" name="fax" id="fax" value="<%=rs1("fax")%>">Fax<br /><br />
	</label>
	<label>
	  <input type="text" name="email" id="email" value="<%=rs1("email")%>" size="40">Email<br /><br />
	</label><textarea name="openinghours" rows="" cols="60"><%=rs1("openinghours")%></textarea>Opening hours<br /><br />
	<input name="val" type="hidden" id="val" value="<%=val%>">
	<input name="findus" type="hidden" id="findus" value="<%=rs("locationid")%>"><%
	End If
	If rs("priority")=1 Then%>
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
	
				  <textarea cols="80" id="editor2" name="editor2" rows="10"><%=rs("title")%></textarea>
	
			  <textarea cols="80" id="editor1" name="editor1" rows="10"><%=rs("desc")%></textarea>
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
	<%End If
	If rs("priority")="3" Then%>
		<form action="editpage.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
		  <span class="justifyright"><a href="addevent.asp?val=<%=val%>">ADD EVENT</a> | <a href="addblog.asp?val=<%=val%>">ADD BLOG</a>&nbsp;&nbsp;&nbsp;</span>   <p>Tick if website page is to be made live 
								<%If rs("active")="y" Then%>
								<input name="active" type="checkbox" id="active" value="y" checked>
<%Else%>
								<input name="active" type="checkbox" id="active" value="y" >
								 <%End If%></p>
	   <input name="val" type="hidden" id="val" value="<%=val%>">
	   <h3>Current Events (for editing)</h3>
	   <%Set rs1 = getMysqlQueryRecordSet("Select * from events WHERE locationpageid=" & rs("locationpageid") & "", con)
			If rs1.eof then
			response.Write("<p>Currently no events to edit</p>")
			else
			Do until rs1.eof
			response.Write("<p><a href=""editevent.asp?val=" & rs1("eventid") & """>" & rs1("startdate") & " - " & rs1("title") & "</a><br />")
			rs1.movenext
			loop
			rs1.close
			set rs1=nothing
			End If%>		
   <h3>Current Blogs (for editing) </h3>      
 <%Set rs1 = getMysqlQueryRecordSet("Select * from blogs WHERE locationpageid=" & rs("locationpageid") & " order by date desc", con)
			If rs1.eof then
			response.Write("<p>Currently no blogs to edit</p>")
			else
			Do until rs1.eof
			response.Write("<p><a href=""editblog.asp?val=" & rs1("blogid") & """>" & rs1("date") & " - " & rs1("title") & "</a><br />")
			rs1.movenext
			loop
			rs1.close
			set rs1=nothing
			End If%>          
	<%
    End If%>
	<%If rs("priority")="4" Then
		Response.Write("<a href=""uploadaccessory.asp?val=" & rs("locationid") & """><img src=""images/admin-button.gif"" width=""164"" height=""42"" id=""Image1"" onMouseOver=""MM_swapImgRestore();MM_swapImage('Image1','','images/admin-buttonr.gif',1)"" onMouseOut=""MM_swapImgRestore()"" align=""right""></a><p>Select which items you would like on your page and enter your own text:</p>")
		sql="Select * from accessories WHERE idlocation='1' OR idlocation=" & rs("locationid") & " AND approved <>'r' order by priority"
		'response.Write("sql=" & sql)
		Set rs1 = getMysqlQueryRecordSet(sql, con)	
		%> 	<form action="editpage.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
		<p>
		Tick if website page is to be made live 
                                <%If rs("active")="y" Then%>
                                <input name="active" type="checkbox" id="active" value="y" checked>
                                <%Else%>
                                <input name="active" type="checkbox" id="active" value="y" >
                                 <%End If%>

        <table width="500px" border="0" align="center" id="centertable" cellpadding="18" cellspacing="18">
      <tr>
    <%Dim accesscount, qty, reccount
    reccount=rs.recordcount
    qty=1
    accesscount=0
    Do until rs1.eof
    %>
        <td><img src="http://savoirbedding.ds5150.dedicated.turbodns.co.uk/accessories/accessory<%=rs1("accessoryid")%>.jpg" width="180" height="177" /><br />
          <br />
    <%sql="Select * from accessorylink WHERE locationid=" & locationid & " and accessoryid=" & rs1("accessoryid")
    Dim checked, atext
    checked=""
    atext=""
    Set rs2 = getMysqlQueryRecordSet(sql, con)	
    If not rs2.eof Then
    checked="checked"
    atext=rs2("accessorytext")
    End If
    rs2.close 
    set rs2=nothing
    %><%If rs1("approved")="n" Then 
		response.write("Awaiting approval")
		Else%>
          <input name="XX<%=rs1("accessoryid")%>" type="checkbox" value="" <%=checked%>>
          <input name="TT<%=rs1("accessoryid")%>" type="text" value="<%=atext%>">
          <%End If%></td>
    <%accesscount=accesscount+1
    qty=qty+1
		If qty=reccount Then
			If accesscount=0 then response.Write("</tr>")
			If accesscount=1 then response.Write("<td>&nbsp;</td></tr>")
			If accesscount=2 then response.Write("<td>&nbsp;</td><td>&nbsp;</td></tr>")
			If accesscount=3 then response.Write("</tr>")
		
		else
			If accesscount=3 then 
			response.Write("</tr>")
			accesscount=0
			End If
		End If

rs1.movenext
loop
%> 
    </table><input name="val" type="hidden" id="val" value="<%=val%>">

    </div>
	<%rs1.close
set rs1=nothing
End If

If rs("priority")="5" then %>
		<form action="editpage.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
      <span class="justifyright"><a href="addtestimonial.asp?val=<%=val%>">ADD TESTIMONIAL</a>&nbsp;&nbsp;&nbsp;</span>   
      <p>Tick if website page is to be made live 
	  						<%If rs("active")="y" Then%>
                            <input name="active" type="checkbox" id="active" value="y" checked>
                            <%Else%>
                            <input name="active" type="checkbox" id="active" value="y" >
	<%End If%></p>
   <input name="val" type="hidden" id="val" value="<%=val%>">
   <h3>Current Testimonials (for editing)</h3>
   <%sql="Select * from testimonials WHERE locationid=" & rs("locationid") & " order by date desc"
   Set rs1 = getMysqlQueryRecordSet(sql, con)
If rs1.eof then
response.Write("<p>Currently no testimonials to edit</p>")
else
Do until rs1.eof
response.Write("<p><a href=""edittestimonial.asp?val=" & rs1("testimonialid") & """>" & rs1("date") & " - " & rs1("name") & "</a><br />")
rs1.movenext
loop
End If
rs1.close
set rs1=nothing%>  
<br /><br /></p>
<%
End If

If rs("priority")="6" then %>
		<form action="editpage.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
     <!-- <span class="justifyright"><a href="addpress.asp?val=<%=val%>">ADD Press</a>&nbsp;&nbsp;&nbsp;</span> -->  
      <p>Tick if website page is to be made live 
	  						<%If rs("active")="y" Then%>
                            <input name="active" type="checkbox" id="active" value="y" checked>
                            <%Else%>
                            <input name="active" type="checkbox" id="active" value="y" >
		  <%End If%></p>
   <input name="val" type="hidden" id="val" value="<%=val%>">
   <h3>Current Press Cuttings (for editing)</h3>
   <%sql="Select * from pressads WHERE locationid=" & rs("locationid") & " order by priority asc"
   Set rs1 = getMysqlQueryRecordSet(sql, con)
If rs1.eof then
response.Write("<p>Currently no press cuttings to edit</p>")
else
Do until rs1.eof%>
<p><input name="YY<%=rs1("pressid")%>" type="text" value="<%=rs1("priority")%>" size="2"> &nbsp;
<input name="PP<%=rs1("pressid")%>" type="text" value="<%=rs1("presstext")%>">
<input name="MM<%=rs1("pressid")%>" type="hidden" value="<%=rs1("imageid")%>">
 <!--<a href="addimage.asp?val=<%=rs1("pressid")%>">Add pdf / image</a></p>-->
<%
rs1.movenext
loop
End If
rs1.close
set rs1=nothing%>  
</p>

<%
End If%>
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

   
<!-- #include file="common/logger-out.inc" -->
