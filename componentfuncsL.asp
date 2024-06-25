<%

sub getComponentSizes(byref acon, acompid, apurchaseno, byref aComp1width, byref aComp2width, byref aComp1length, byref aComp2length)
 dim ars, componentwidth, componentlength, asql
 if acompid=1 then 
 	componentwidth="mattresswidth"
	componentlength="mattresslength"
 end if
 if acompid=3 then componentwidth="basewidth"
 if acompid=5 then componentwidth="topperwidth"
 if acompid=6 then componentwidth="valancewidth"
 'if acompid=8 then componentwidth="headboardwidth"
 asql="select " & componentwidth & " as w, " & componentlength  & " as l from purchase where purchase_no=" & apurchaseno & ""
 set ars = getMysqlQueryRecordSet(asql, aCon)
  if acompid=1 and (left(ars("n"),4))<>"Spec" and ars("w")<>"TBC" and ars("n")<>"n" and Not isNull(ars("w")) then aComp1width=left(ars("w"), len(ars("n"))-2)
  if acompid=1 and (left(ars("n"),4))<>"Spec" and ars("w")<>"TBC" and ars("n")<>"n" and Not isNull(ars("n")) then aComp1length=left(ars("w"), len(ars("n"))-2)
  
  if acompid=3 and (left(ars("n"),4))<>"Spec" and ars("w")<>"TBC" and ars("n")<>"n" and Not isNull(ars("w")) then aComp1width=left(ars("w"), len(ars("n"))-2)
  if acompid=5 and (left(ars("n"),4))<>"Spec" and ars("w")<>"TBC" and ars("n")<>"n" and Not isNull(ars("w")) then aComp1width=left(ars("w"), len(ars("n"))-2)
  if acompid=6 and (left(ars("n"),4))<>"Spec" and ars("w")<>"TBC" and ars("n")<>"n" and Not isNull(ars("w")) then aComp1width=ars("w")
 
 ars.close
 set ars = nothing
end sub

%>