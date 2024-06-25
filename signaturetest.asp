<!DOCTYPE html><head lang="en-ca"><meta charset="utf-8">
<title>Require a Drawn Signature &middot; Signature Pad &middot; Lab &middot; Thomas J Bradley</title>
<link rel="stylesheet" href="http://static.thomasjbradley.ca/css/lab.css">
<link rel="stylesheet" href="http://static.thomasjbradley.ca/lab/signature-pad/jquery.signaturepad.css">
<!--[if lt IE 9]><script src="http://static.thomasjbradley.ca/lab/signature-pad/flashcanvas.js"></script><![endif]-->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"></script></head><body><div id="content">
<h1>Require a Drawn Signature</h1>
<p>This demo showcases an HTML form where the user is required to draw their signature before submission.
<p><a href="http://thomasjbradley.ca/lab/signature-pad#require-drawn">Find the full documentation in the lab</a><hr>
<form method="post" action="#" class="sigPad">
<label for="name">Print your name</label>
<input type="text" name="name" id="name" class="name">

<p class="drawItDesc">Draw your signature</p><ul class="sigNav">
<li class="drawIt"><a href="#draw-it" >Draw It</a></li>
<li class="clearButton"><a href="#clear">Clear</a></li></ul>
<div class="sig sigWrapper"><div class="typed"></div>
<canvas class="pad" width="198" height="55"></canvas>
<input type="hidden" name="output" class="output"></div>
<button type="submit">I accept the terms of this agreement.</button></form></div>
<script src="http://static.thomasjbradley.ca/lab/signature-pad/jquery.signaturepad.min.js"></script>
<script>

var sig = <%=request("output")%>

$(document).ready( function(){
  $('.sigPad').signaturePad({displayOnly:true}).regenerate(sig);
})
	</script>
<script src="http://static.thomasjbradley.ca/lab/signature-pad/json2.min.js"></script>

</body>