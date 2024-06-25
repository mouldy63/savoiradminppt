<%
Dim fso, jpeg
Set fso = CreateObject("Scripting.FileSystemObject")
'Set jpeg = Server.CreateObject("Persits.Jpeg")

sub processFile(byval filename, byref File)
	dim realFilename
	realFilename = Server.MapPath(filename)
	if fso.fileExists(realFilename) then
		fso.deleteFile(realFilename)
	end if
	File.MoveVirtual(filename)
'	call resizeImage(realFilename)
end sub

sub deleteFile(byval filename)
	dim realFilename
	realFilename = Server.MapPath(filename)
	if fso.fileExists(realFilename) then
		fso.deleteFile(realFilename)
	end if
end sub

sub renameFile(byval oldname, byval newname)
	dim realOldname, realNewname
	realOldname = Server.MapPath(oldname)
	realNewname = Server.MapPath(newname)
	if fso.fileExists(realOldname) then
		call fso.MoveFile(realOldname, realNewname)
	end if
end sub

'sub resizeImage(byref filename)
'	jpeg.Open filename
'	jpeg.Width = jpeg.OriginalWidth / 7
'	jpeg.Height = jpeg.OriginalHeight / 7
'	jpeg.Canvas.Pen.Color = &000000' green
'	jpeg.Canvas.Pen.Width = 2
'	jpeg.Canvas.Brush.Solid = False ' or a solid bar would be drawn
'	jpeg.Canvas.Bar 1, 1, jpeg.Width, jpeg.Height
'	'jpeg.Sharpen 1, 110
'	jpeg.Save filename
'end sub

sub closeFileObjects()
	set fso = nothing
'	set jpeg = nothing
end sub
%>
