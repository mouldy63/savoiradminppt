<html>

<head>
<meta http-equiv="Content-Language" content="pt-br">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
</head>

<body>


<%

dim PDF

' Debug the license rutine on the PDF version
' This is done when you get problems on the license machine

set PDF = server.createobject("aspPDF.EasyPDF")

	PDF.DEBUG = True
	PDF.LIC_DEBUG = True
	PDF.License("$162185902;'David Mildenhall';PDF;1;0-217.199.174.247;0-109.104.75.208")

	response.write "<br>Version Information:<br>" & PDF.Version
set pdf = nothing


%>

</body>

</html>