<%
Dim  ffJpeg

Set ffJpeg = Server.CreateObject("Persits.Jpeg")

sub processFile(byval aFilename, byref aFile, byref aMove, byref aWidth, byref aHeight)
	dim aRealFilename
	aRealFilename = Server.MapPath(aFilename)
	if Upload.fileExists(aRealFilename) then
		Upload.deleteFile(aRealFilename)
	end if
	if aMove then
		aFile.MoveVirtual(aFilename)
	else
		aFile.CopyVirtual(aFilename)
	end if
	If aWidth > 0 then
	call resizeImage(aRealFilename, aWidth, aHeight)
	End If
end sub

sub processFileAbsolute(byval aFilename, byref aFile, byref aMove, byref aWidth, byref aHeight)
	if Upload.fileExists(aFilename) then
		Upload.deleteFile(aFilename)
	end if
	if aMove then
		aFile.Move(aFilename)
	else
		aFile.Copy(aFilename)
	end if
	If aWidth > 0 then
		call resizeImage(aFilename, aWidth, aHeight)
	End If
end sub

sub deleteFile(byval aFilename)
	dim aRealFilename
	aRealFilename = Server.MapPath(aFilename)
	if Upload.fileExists(aRealFilename) then
		Upload.deleteFile(aRealFilename)
	end if
end sub

sub renameFile(byval aOldname, byval aNewname)
	dim aRealOldname, aRealNewname
	aRealOldname = Server.MapPath(aOldname)
	aRealNewname = Server.MapPath(aNewname)
	if Upload.fileExists(aRealOldname) then
		call Upload.MoveFile(aRealOldname, aRealNewname)
	end if
end sub

sub resizeImage(byref aFilename, byref aWidth, byref aHeight)

	ffJpeg.Open aFilename
	'ffJpeg.Canvas.Brush.Solid = False ' or a solid bar would be drawn
	'ffJpeg.Canvas.Bar 1, 1, ffJpeg.Width, ffJpeg.Height
	ffJpeg.Sharpen 1, 110
	ffJpeg.Width = aWidth
	ffJpeg.Height = aHeight

	'ffJpeg.Height = ffJpeg.Width * ffJpeg.OriginalHeight / ffJpeg.OriginalWidth
	ffJpeg.Canvas.Pen.Color = &000000' black
	ffJpeg.Canvas.Pen.Width = 2
	ffJpeg.Save aFilename
end sub

sub closeFileObjects()
	set Upload = nothing
'	set ffJpeg = nothing
end sub

function getFileNameExtension(afilename)
	dim aidx
	aidx = instrrev(afilename, ".")
	getFileNameExtension = ""
	if aidx > 0 then
		getFileNameExtension = right(afilename, len(afilename)-aidx+1)
	end if
end function
%>
