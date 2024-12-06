<%
' Clear out the existing HTTP header information
Response.Expires = 0
Response.Buffer = TRUE
Response.Clear
Response.Buffer = TRUE
Response.ContentType = "application/pdf"

Response.Expires = 0
Response.Expiresabsolute = Now() - 1
Response.AddHeader "pragma","no-cache"
Response.AddHeader "cache-control","private"
Response.CacheControl = "no-cache" 

dim PDF, str, streamPDF
str=""
const csPropGraphZoom= 1
const csPropGraphWZoom= 50 
const csPropGraphHZoom= 50
const csPropTextFont  = 100
const csPropTextSize  = 101
const csPropTextAlign = 102
const csPropTextColor = 103
const csPropTextUnderline = 104
const csPropTextRender  = 105
const csPropAddTextWidth = 113
const csPropParSpace    = 200
const csPropParLeft 	= 201
const csPropParTop 		= 202
const csPropPosX	    = 205
const csPropPosY	    = 206
const csPropInfoTitle 	= 300

'
const algLeft = "0"
const algRight = "1"
const algCenter = "2"
const algJustified = "3"
'
const pTrue = "1"
const pFalse = "0"


set PDF = server.createobject("aspPDF.EasyPDF")
'PDF.License("C:\Program Files (x86)\MITData\01022012-44318-S1538.lic")
PDF.License("$162185902;'David Mildenhall';PDF;1;0-217.199.174.247;0-109.104.75.208")
PDF.page "A4", 1  'landscape

'PDF.DEBUG = True
PDF.SetMargins 20,50,50,50

PDF.SetProperty csPropTextAlign, algCenter
YPos = int(PDF.GetProperty(csPropPosY))
PDF.SetPos 0, YPos - 10
'PDF.AddLine 60, 55, 520, 55



PDF.SetProperty csPropParLeft, "50"
PDF.SetProperty csPropPosX, "50"

PDF.SetProperty csPropTextColor,"#3e7034"
PDF.SetProperty csPropTextAlign, "0"
PDF.SetProperty csPropAddTextWidth, 1
PDF.SetFont "F1", 18, "#3e7034"
PDF.SetFont "F1", 16, "#3366CC"
PDF.AddTextWidth 340,140,390, "www.savoirbedding.co.uk<br>"
PDF.SetProperty csPropTextSize, 12	
PDF.SetFont "F1", 12, "#3e7034"
PDF.SetProperty csPropTextAlign, "1"
PDF.SetProperty csPropAddTextWidth, 1
PDF.AddTextWidth 120,160,200, "After 5 years"
PDF.AddTextWidth 120,180,200, str
PDF.AddTextWidth 120,200,200, str
PDF.SetProperty csPropTextAlign, "2"
str="Treat Yourself -"
PDF.AddTextWidth 143,350,200, str
str="Treat Your Garden"
PDF.AddTextWidth 143,367,200, str
PDF.SetFont "F1", 14, "#3366CC"
PDF.SetProperty csPropAddTextWidth, 2
PDF.AddTextWidth 172,393,505, str 
PDF.SetProperty csPropTextAlign, "3"
PDF.SetFont "F1", 10, "#000000"
PDF.AddTextWidth 172,410,505, str 
PDF.SetFont "F1", 10, "#3e7034"
PDF.AddTextWidth 172,462,505, str
	

' Write it directly to window

PDF.BinaryWrite
set pdf = nothing
%>