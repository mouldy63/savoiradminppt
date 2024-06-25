<%
dim THUMBNAILIMGDIR, STDIMGDIR, CATIMGDIR
THUMBNAILIMGDIR = ""
STDIMGDIR = ""
CATIMGDIR = ""

' the data structures
class product

	public idProd
	public key
	public name
	public desc
	public extdesc
	public code
	public idCat
	public retired
	public rrp
	public price
	public seq

end class

class cat

	public idCat
	public key
	public name
	public desc
	public retired
	public seq
	public idCatParent

end class

class attr

	public idAttr
	public key
	public name
	public desc

end class

class prodattr

	public idProd
	public idAttr
	public desc

end class

class opt

	public idOpt
	public idAttr
	public key
	public name
	public desc
	public img
	public retired

end class

class prodopt

	public idProd
	public idOpt
	public desc
	public img
	public addprice
	public seq
	public available

end class

class offprodoptcombo

	public idProd
	public idOpt1
	public idOpt2
	public idOpt3

end class

class prodoptcomboprice

	public idProd
	public idOpt1
	public idOpt2
	public idOpt3
	public price

end class

class prodrel

	public idProdRel
	public idProdParent
	public idProdChild
	public seq

end class

class promocode

	public code
	public description
	public discount
	public retired

end class

class pclink

	public id
	public code
	public reftype
	public refid

end class

' product helpers
function getAllProducts()

	dim ars, theProducts(), aProduct, i
	
	set ars = getQueryRecordSet("SELECT * FROM PROD ORDER BY SEQ,NAME")
	i = 0

	while not ars.eof
		i = i + 1
		set aProduct = new product
		aProduct.idProd = ars("IDPROD")
		aProduct.key = ars("KEY")
		aProduct.idCat = ars("IDCAT")
		aProduct.key = ars("KEY")
		aProduct.name = trim(ars("NAME"))
		aProduct.desc = trim(ars("DESC"))
		aProduct.extdesc = trim(ars("EXTDESC"))
		aProduct.code = trim(ars("CODE"))
		aProduct.retired = ars("RETIRED")
		aProduct.rrp = ars("RRP")
		aProduct.price = ars("PRICE")
		aProduct.seq = ars("SEQ")
	
		redim preserve theProducts(i)
		set theProducts(i) = aProduct

		ars.movenext
	wend

	closers(ars)
	
	getAllProducts = theProducts

end function

function getProductsForCat(byval aIdCat)

	dim ars, theProducts(), aProduct, i
	
	set ars = getQueryRecordSet("SELECT * FROM PROD WHERE IDCAT=" & aIdCat & " ORDER BY SEQ,NAME")
	i = 0

	while not ars.eof
		i = i + 1
		set aProduct = new product
		aProduct.idProd = ars("IDPROD")
		aProduct.key = ars("KEY")
		aProduct.idCat = ars("IDCAT")
		aProduct.key = ars("KEY")
		aProduct.name = trim(ars("NAME"))
		aProduct.desc = trim(ars("DESC"))
		aProduct.extdesc = trim(ars("EXTDESC"))
		aProduct.code = trim(ars("CODE"))
		aProduct.retired = ars("RETIRED")
		aProduct.rrp = ars("RRP")
		aProduct.price = ars("PRICE")
		aProduct.seq = ars("SEQ")
	
		redim preserve theProducts(i)
		set theProducts(i) = aProduct

		ars.movenext
	wend
	
	if i = 0 then redim theProducts(0)

	closers(ars)
	
	getProductsForCat = theProducts

end function

function getLiveProductsForCat(byval aIdCat)

	dim ars, theProducts(), aProduct, i
	
	set ars = getQueryRecordSet("SELECT * FROM PROD WHERE IDCAT=" & aIdCat & " AND RETIRED=FALSE ORDER BY SEQ,NAME")
	i = 0

	while not ars.eof
		i = i + 1
		set aProduct = new product
		aProduct.idProd = ars("IDPROD")
		aProduct.key = ars("KEY")
		aProduct.idCat = ars("IDCAT")
		aProduct.key = ars("KEY")
		aProduct.name = trim(ars("NAME"))
		aProduct.desc = trim(ars("DESC"))
		aProduct.extdesc = trim(ars("EXTDESC"))
		aProduct.code = trim(ars("CODE"))
		aProduct.retired = ars("RETIRED")
		aProduct.rrp = ars("RRP")
		aProduct.price = ars("PRICE")
		aProduct.seq = ars("SEQ")
	
		redim preserve theProducts(i)
		set theProducts(i) = aProduct

		ars.movenext
	wend
	
	if i = 0 then redim theProducts(0)

	closers(ars)
	
	getLiveProductsForCat = theProducts

end function

function getOptsForProd(byval aIdProd, byval aIdAttr, byval aAvailableOnly)

	dim ars, theOptions(), aOption, asql, ii
	
	asql = "SELECT O.IDOPT,O.IDATTR,O.KEY,O.NAME,O.DESC,O.IMG,O.RETIRED FROM OPT O, PRODOPT PO WHERE O.IDATTR=" & aIdAttr & " AND PO.IDPROD=" & aIdProd & " AND O.IDOPT=PO.IDOPT"
	if aAvailableOnly then
		asql = asql & " AND AVAILABLE=TRUE"
	end if
	asql = asql & " ORDER BY PO.SEQ"
	'response.write("<br>" & asql)
	'response.end
	set ars = getQueryRecordSet(asql)
	ii = 0
	
	if ars.eof then
		redim theOptions(0)
	else
		while not ars.eof
			ii = ii + 1
			set aOption = new opt
			aOption.idOpt = ars("IDOPT")
			aOption.idAttr = ars("IDATTR")
			aOption.key = ars("KEY")
			aOption.name = trim(ars("NAME"))
			aOption.desc = trim(ars("DESC"))
			aOption.img = trim(ars("IMG"))
			aOption.retired = ars("RETIRED")
		
			redim preserve theOptions(ii)
			set theOptions(ii) = aOption
	
			ars.movenext
		wend
	end if


	closers(ars)
	
	getOptsForProd = theOptions

end function

function getAvailableOptsForProd(byval aIdProd, byval aIdAttr)

	getAvailableOptsForProd = getOptsForProd(aIdProd, aIdAttr, true)

end function

function getOptsForAttr(aIdAttr)

	dim ars, theOptions(), aOption, asql
	
	asql = "SELECT * FROM OPT O WHERE O.IDATTR=" & aIdAttr & " ORDER BY NAME"
	
	set ars = getQueryRecordSet(asql)
	i = 0
	
	if ars.eof then
		redim theOptions(0)
	end if

	while not ars.eof
		i = i + 1
		set aOption = new opt
		aOption.idOpt = ars("IDOPT")
		aOption.idAttr = ars("IDATTR")
		aOption.key = ars("KEY")
		aOption.name = trim(ars("NAME"))
		aOption.desc = trim(ars("DESC"))
		aOption.img = trim(ars("IMG"))
		aOption.retired = ars("RETIRED")
	
		redim preserve theOptions(i)
		set theOptions(i) = aOption

		ars.movenext
	wend

	closers(ars)
	
	getOptsForAttr = theOptions

end function

function getOpt(aIdOpt)

	dim ars, asql
	
	asql = "SELECT * FROM OPT WHERE IDOPT=" & aIdOpt
	
	set ars = getQueryRecordSet(asql)
	
	while not ars.eof
		set getOpt = new opt
		getOpt.idOpt = ars("IDOPT")
		getOpt.idAttr = ars("IDATTR")
		getOpt.key = ars("KEY")
		getOpt.name = trim(ars("NAME"))
		getOpt.desc = trim(ars("DESC"))
		getOpt.img = trim(ars("IMG"))
		getOpt.retired = ars("RETIRED")
	
		ars.movenext
	wend

	closers(ars)
	
end function

function getSafeOptName(aIdOpt)

	if aIdOpt <> 0 then
		getSafeOptName = getOpt(aIdOpt).name
	else
		getSafeOptName = "N/A"
	end if

end function

sub updateProduct(byref aproduct)

	dim asql
	asql = "UPDATE PROD SET NAME='" & aproduct.name & "',KEY='" & aproduct.key & "',[DESC]='" & aproduct.desc & "',EXTDESC='" & aproduct.extdesc & "',CODE='" & aproduct.code & "',RETIRED=" & aproduct.retired & ",IDCAT=" & aproduct.idCat & ",RRP=" & aproduct.rrp & ",PRICE=" & aproduct.price & ",SEQ=" & aproduct.seq & " WHERE IDPROD=" & aproduct.idprod
	'response.write("<br>" & asql)
	'response.end
	call conExecute(asql)

end sub

sub insertProduct(byref aproduct)

	dim asql
	asql = "INSERT INTO PROD (KEY,NAME,[DESC],EXTDESC,CODE,IDCAT,RETIRED,RRP,PRICE,SEQ) VALUES ('" & aproduct.key & "','" & aproduct.name & "','" & aproduct.desc & "','" & aproduct.extdesc & "','" & aproduct.code & "'," & aproduct.idcat & "," & aproduct.retired & "," & aproduct.rrp & "," & aproduct.price & "," & aproduct.seq & ")"
	'response.write("<br>" & asql)
	call conExecute(asql)

end sub

sub deleteProduct(byref aIdProd)

	dim asql

	asql = "DELETE FROM PRODATTR WHERE IDPROD=" & aIdProd
	call conExecute(asql)

	asql = "DELETE FROM PRODOPT WHERE IDPROD=" & aIdProd
	call conExecute(asql)

	asql = "DELETE FROM PROD WHERE IDPROD=" & aIdProd
	call conExecute(asql)
	
end sub

' category helpers
function getAllCategories()

	dim ars, theCats(), aCat, i
	
	set ars = getQueryRecordSet("SELECT * FROM CAT ORDER BY SEQ,NAME")
	i = 0

	while not ars.eof
		i = i + 1
		set aCat = new cat
		aCat.idCat = cint(ars("IDCAT"))
		aCat.key = ars("KEY")
		aCat.name = trim(ars("NAME"))
		aCat.desc = trim(ars("DESC"))
		aCat.retired = cbool(ars("RETIRED"))
		aCat.seq = cint(ars("SEQ"))
		aCat.idCatParent = cint(ars("IDCATPARENT"))
	
		redim preserve theCats(i)
		set theCats(i) = aCat

		ars.movenext
	wend

	if i = 0 then redim theCats(0)

	closers(ars)
	
	getAllCategories = theCats

end function

function getAllActiveCategories()

	dim ars, theCats(), aCat, i
	
	set ars = getQueryRecordSet("SELECT * FROM CAT WHERE NOT RETIRED ORDER BY SEQ,NAME")
	i = 0

	while not ars.eof
		i = i + 1
		set aCat = new cat
		aCat.idCat = cint(ars("IDCAT"))
		aCat.key = ars("KEY")
		aCat.name = trim(ars("NAME"))
		aCat.desc = trim(ars("DESC"))
		aCat.retired = cbool(ars("RETIRED"))
		aCat.seq = cint(ars("SEQ"))
		aCat.idCatParent = cint(ars("IDCATPARENT"))
	
		redim preserve theCats(i)
		set theCats(i) = aCat

		ars.movenext
	wend

	closers(ars)
	
	getAllActiveCategories = theCats

end function

function getAllMainActiveCategories()

	dim ars, theCats(), aCat, i
	
	set ars = getQueryRecordSet("SELECT * FROM CAT WHERE IDCATPARENT=0 AND NOT RETIRED ORDER BY SEQ,NAME")
	i = 0

	while not ars.eof
		i = i + 1
		set aCat = new cat
		aCat.idCat = cint(ars("IDCAT"))
		aCat.key = ars("KEY")
		aCat.name = trim(ars("NAME"))
		aCat.desc = trim(ars("DESC"))
		aCat.retired = cbool(ars("RETIRED"))
		aCat.seq = cint(ars("SEQ"))
		aCat.idCatParent = cint(ars("IDCATPARENT"))
	
		redim preserve theCats(i)
		set theCats(i) = aCat

		ars.movenext
	wend

	closers(ars)
	
	getAllMainActiveCategories = theCats

end function

function getActiveSubCats(byval aIdCat)

	dim ars, theCats(), aCat, i
	
	set ars = getQueryRecordSet("SELECT * FROM CAT WHERE IDCATPARENT=" & aIdCat & " AND NOT RETIRED ORDER BY SEQ,NAME")
	i = 0

	while not ars.eof
		i = i + 1
		set aCat = new cat
		aCat.idCat = cint(ars("IDCAT"))
		aCat.key = ars("KEY")
		aCat.name = trim(ars("NAME"))
		aCat.desc = trim(ars("DESC"))
		aCat.retired = cbool(ars("RETIRED"))
		aCat.seq = cint(ars("SEQ"))
		aCat.idCatParent = cint(ars("IDCATPARENT"))
	
		redim preserve theCats(i)
		set theCats(i) = aCat

		ars.movenext
	wend
	
	if i = 0 then redim theCats(0)

	closers(ars)
	
	getActiveSubCats = theCats

end function

sub updateCategory(byref acat)

	dim asql
	asql = "UPDATE CAT SET KEY='" & acat.key & "',NAME='" & acat.name & "',[DESC]='" & acat.desc & "',RETIRED=" & acat.retired & ",SEQ=" & acat.seq & ",IDCATPARENT=" & acat.idcatparent & " WHERE IDCAT=" & acat.idCat
	'response.write("<br>" & asql)
	call conExecute(asql)

end sub

sub insertCategory(byref acat)

	dim asql
	asql = "INSERT INTO CAT (KEY,NAME,[DESC],RETIRED,SEQ,IDCATPARENT) VALUES ('" & acat.key & "','" & acat.name & "','" & acat.desc & "'," & acat.retired & "," & acat.seq & "," & acat.idcatparent & ")"
	'response.write("<br>" & asql)
	call conExecute(asql)

end sub

sub deleteCategory(byref aIdCat)

	dim asql, ars
	
	asql = "SELECT IDPROD FROM PROD WHERE IDCAT=" & aIdCat
	set ars = getQueryRecordSet(asql)
	while not ars.eof
		call deleteProduct(ars("IDPROD"))
		ars.movenext
	wend
	closers(ars)

	asql = "DELETE FROM CAT WHERE IDCAT=" & aIdCat
	call conExecute(asql)
	
end sub

' attribute helpers
function getAllAttributes()

	dim ars, theAttrs(), aAttr, i
	
	set ars = getQueryRecordSet("SELECT * FROM ATTR ORDER BY NAME")
	i = 0

	while not ars.eof
		i = i + 1
		set aAttr = new attr
		aAttr.idAttr = ars("IDATTR")
		aAttr.key = ars("KEY")
		aAttr.name = trim(ars("NAME"))
		aAttr.desc = trim(ars("DESC"))
	
		redim preserve theAttrs(i)
		set theAttrs(i) = aAttr

		ars.movenext
	wend

	if i = 0 then redim theAttrs(0)

	closers(ars)
	
	getAllAttributes = theAttrs

end function

sub updateAttribute(byref aAttr)

	dim asql
	asql = "UPDATE ATTR SET KEY='" & aAttr.key & "',NAME='" & aAttr.name & "',[DESC]='" & aAttr.desc & "' WHERE IDATTR=" & aAttr.idAttr
	'response.write("<br>" & asql)
	call conExecute(asql)

end sub

sub insertAttribute(byref aAttr)

	dim asql
	asql = "INSERT INTO ATTR (KEY,NAME,[DESC]) VALUES ('" & aAttr.key & "','" & aAttr.name & "','" & aAttr.desc & "')"
	'response.write("<br>" & asql)
	call conExecute(asql)

end sub

sub deleteAttribute(byref aIdAttr)

	dim asql

	asql = "DELETE FROM PRODATTR WHERE IDATTR=" & aIdAttr
	call conExecute(asql)

	asql = "DELETE FROM ATTR WHERE IDATTR=" & aIdAttr
	call conExecute(asql)
	
end sub

' product attribute helpers
function getProductAttributes()

	dim ars, theProdAttrs(), aProdAttr, i
	
	set ars = getQueryRecordSet("SELECT * FROM PRODATTR ORDER BY IDPROD,IDATTR")
	i = 0

	while not ars.eof
		i = i + 1
		set aProdAttr = new prodattr
		aProdAttr.idProd = ars("IDPROD")
		aProdAttr.idAttr = ars("IDATTR")
		aProdAttr.desc = trim(ars("DESC"))
	
		redim preserve theProdAttrs(i)
		set theProdAttrs(i) = aProdAttr

		ars.movenext
	wend
	
	if i = 0 then redim theProdAttrs(0)

	closers(ars)
	
	getProductAttributes = theProdAttrs

end function

function getProductAttributesForAttr(byval aIdAttr)

	dim ars, theProdAttrs(), aProdAttr, i
	
	set ars = getQueryRecordSet("SELECT * FROM PRODATTR WHERE IDATTR=" & aIdAttr & " ORDER BY IDPROD,IDATTR")
	i = 0

	while not ars.eof
		i = i + 1
		set aProdAttr = new prodattr
		aProdAttr.idProd = ars("IDPROD")
		aProdAttr.idAttr = ars("IDATTR")
		aProdAttr.desc = trim(ars("DESC"))
	
		redim preserve theProdAttrs(i)
		set theProdAttrs(i) = aProdAttr

		ars.movenext
	wend
	
	if i = 0 then redim theProdAttrs(0)

	closers(ars)
	
	getProductAttributesForAttr = theProdAttrs

end function

function getAttributesForProduct(byval aIdProd)

	dim ars, theAttrs(), aAttr, i
	
	set ars = getQueryRecordSet("SELECT A.IDATTR,A.KEY,A.NAME,A.DESC FROM PRODATTR PA, ATTR A WHERE PA.IDPROD=" & aIdProd & " AND PA.IDATTR=A.IDATTR ORDER BY A.IDATTR")
	i = 0

	while not ars.eof
		i = i + 1
		set aAttr = new attr
		aAttr.idAttr = ars("IDATTR")
		aAttr.key = trim(ars("KEY"))
		aAttr.name = trim(ars("NAME"))
		aAttr.desc = trim(ars("DESC"))
	
		redim preserve theAttrs(i)
		set theAttrs(i) = aAttr

		ars.movenext
	wend
	
	if i = 0 then redim theAttrs(0)

	closers(ars)
	
	getAttributesForProduct = theAttrs

end function

sub insertProductAttribute(byref aProdAttr)

	dim asql
	asql = "INSERT INTO PRODATTR (IDPROD,IDATTR,[DESC]) VALUES (" & aProdAttr.idProd & "," & aProdAttr.idAttr & ",'" & aProdAttr.desc & "')"
	'response.write("<br>" & asql)
	call conExecute(asql)

end sub

sub updateProductAttribute(byref oldIdProd, byref oldIdAttr, byref aProdAttr)

	dim asql
	asql = "UPDATE PRODATTR SET IDPROD=" & aProdAttr.idProd & ",IDATTR=" & aProdAttr.idAttr & ",[DESC]='" & aProdAttr.desc & "'" &_
		   " WHERE IDPROD=" & oldIdProd & " AND IDATTR=" & oldIdAttr & ""
	'response.write("<br>" & asql)
	call conExecute(asql)

end sub

sub deleteProductAttribute(byref aProdAttr)

	dim asql
	asql = "DELETE FROM PRODATTR WHERE IDPROD=" & aProdAttr.idProd & " AND IDATTR=" & aProdAttr.idAttr
	'response.write("<br>" & asql)
	call conExecute(asql)

end sub

sub deleteAllProductAttributesForAttr(byval aIdAttr)

	dim asql
	asql = "DELETE FROM PRODATTR WHERE IDATTR=" & aIdAttr
	call conExecute(asql)

end sub

sub deleteAllProductAttributes()

	dim asql
	asql = "DELETE FROM PRODATTR"
	call conExecute(asql)

end sub

' option helpers
function getAllOptions()

	dim ars, theOptions(), aOption, i
	
	set ars = getQueryRecordSet("SELECT * FROM OPT ORDER BY IDATTR, NAME")
	i = 0

	while not ars.eof
		i = i + 1
		set aOption = new opt
		aOption.idOpt = ars("IDOPT")
		aOption.idAttr = ars("IDATTR")
		aOption.key = ars("KEY")
		aOption.name = trim(ars("NAME"))
		aOption.desc = trim(ars("DESC"))
		aOption.img = trim(ars("IMG"))
		aOption.retired = ars("RETIRED")
	
		redim preserve theOptions(i)
		set theOptions(i) = aOption

		ars.movenext
	wend

	closers(ars)
	
	getAllOptions = theOptions

end function

sub updateOption(byref aopt)

	dim asql
	asql = "UPDATE OPT SET KEY='" & aopt.key & "',NAME='" & aopt.name & "',[DESC]='" & aopt.desc & "',IMG='" & aopt.img & "',RETIRED=" & aopt.retired & ",IDATTR=" & aopt.idAttr & " WHERE IDOPT=" & aopt.idOpt
	'response.write("<br>" & asql)
	call conExecute(asql)

end sub

sub insertOption(byref aopt)

	dim asql
	asql = "INSERT INTO OPT (KEY,NAME,[DESC],IMG,IDATTR,RETIRED) VALUES ('" & aopt.key & "','" & aopt.name & "','" & aopt.desc & "','" & aopt.img & "'," & aopt.idAttr & "," & aopt.retired & ")"
	'response.write("<br>" & asql)
	call conExecute(asql)

end sub

sub deleteOption(byref aIdOpt)

	dim asql

	asql = "DELETE FROM PRODOPT WHERE IDOPT=" & aIdOpt
	call conExecute(asql)

	asql = "DELETE FROM OPT WHERE IDOPT=" & aIdOpt
	call conExecute(asql)
	
end sub

' product option info helpers
function getProductOpts()

	dim ars, theProdOpts(), aProdOpt, i
	
	set ars = getQueryRecordSet("SELECT * FROM PRODOPT ORDER BY IDPROD,IDOPT")
	i = 0

	while not ars.eof
		i = i + 1
		set aProdOpt = new prodOpt
		aProdOpt.idProd = ars("IDPROD")
		aProdOpt.idOpt = ars("IDOPT")
		aProdOpt.desc = trim(ars("DESC"))
		aProdOpt.img = trim(ars("IMG"))
		aProdOpt.addprice = ars("ADDPRICE")
		aProdOpt.seq = ars("SEQ")
		aProdOpt.available = ars("AVAILABLE")
	
		redim preserve theProdOpts(i)
		set theProdOpts(i) = aProdOpt

		ars.movenext
	wend
	
	if i = 0 then redim theProdOpts(0)

	closers(ars)
	
	getProductOpts = theProdOpts

end function

function getProductOptsForProd(byval aIdprod)

	dim ars, theProdOpts(), aProdOpt, i, asql
	
	asql = "SELECT DISTINCT(PO.IDOPT),O.IDATTR,PO.IDPROD,PO.DESC,PO.IMG,PO.ADDPRICE,PO.SEQ,PO.AVAILABLE FROM PRODATTR PA, OPT O, PRODOPT PO" &_
		   " WHERE PO.IDPROD=" & aIdprod & " AND PA.IDATTR=O.IDATTR AND PO.IDPROD=PA.IDPROD AND O.IDOPT=PO.IDOPT" &_
		   " ORDER BY O.IDATTR,PO.SEQ"
	
	set ars = getQueryRecordSet(asql)
	i = 0
	
	if ars.eof then
		redim theProdOpts(0)
	end if

	while not ars.eof
		i = i + 1
		set aProdOpt = new prodOpt
		aProdOpt.idProd = ars("IDPROD")
		aProdOpt.idOpt = ars("IDOPT")
		aProdOpt.desc = trim(ars("DESC"))
		aProdOpt.img = trim(ars("IMG"))
		aProdOpt.addprice = ars("ADDPRICE")
		aProdOpt.seq = ars("SEQ")
		aProdOpt.available = ars("AVAILABLE")
	
		redim preserve theProdOpts(i)
		set theProdOpts(i) = aProdOpt

		ars.movenext
	wend
	
	closers(ars)
	
	getProductOptsForProd = theProdOpts

end function

function getProduct(byval idprod)

	dim ars
	set ars = getQueryRecordSet("SELECT * FROM PROD WHERE IDPROD=" & idprod)
	set getProduct = new product

	while not ars.eof
		getProduct.idProd = ars("IDPROD")
		getProduct.key = ars("KEY")
		getProduct.idCat = ars("IDCAT")
		getProduct.key = ars("KEY")
		getProduct.name = trim(ars("NAME"))
		getProduct.desc = trim(ars("DESC"))
		getProduct.extdesc = trim(ars("EXTDESC"))
		getProduct.code = trim(ars("CODE"))
		getProduct.retired = ars("RETIRED")
		getProduct.rrp = ars("RRP")
		getProduct.price = ars("PRICE")
		getProduct.seq = ars("SEQ")
	
		ars.movenext
	wend
	
	closers(ars)

end function

function getProductOptForProdAndOpt(byval idprod, byval idopt)

	dim ars
	set ars = getQueryRecordSet("SELECT * FROM PRODOPT WHERE IDPROD=" & idprod & " AND IDOPT=" & idopt)
	set getProductOptForProdAndOpt = new prodOpt

	while not ars.eof
		getProductOptForProdAndOpt.idProd = ars("IDPROD")
		getProductOptForProdAndOpt.idOpt = ars("IDOPT")
		getProductOptForProdAndOpt.desc = trim(ars("DESC"))
		getProductOptForProdAndOpt.img = trim(ars("IMG"))
		getProductOptForProdAndOpt.addprice = ars("ADDPRICE")
		getProductOptForProdAndOpt.seq = ars("SEQ")
		getProductOptForProdAndOpt.available = ars("AVAILABLE")
	
		ars.movenext
	wend
	
	closers(ars)

end function

function getPriceForProductOption(byval idprod, byval idopt1, byval idopt2, byval idopt3)

	dim aProd, aProdOpt
	'response.write("<br>idprod = " & idprod)
	'response.write("<br>idopt1 = " & idopt1)
	'response.write("<br>idopt2 = " & idopt2)
	'response.write("<br>idopt3 = " & idopt3)

	getPriceForProductOption = getProdOptComboPrice(idprod, idopt1, idopt2, idopt3)
	'response.write("<br>getProdOptComboPrice = " & getPriceForProductOption)
	'response.end

	if getPriceForProductOption < 0.0 then
		set aProd = getProduct(idprod)
		getPriceForProductOption = aProd.price
		if idopt1 <> 0 then
			set aProdOpt = getProductOptForProdAndOpt(idprod, idopt1)
			'response.write("<br>idopt1 price = " & aProdOpt.addprice)
			getPriceForProductOption = getPriceForProductOption + aProdOpt.addprice
		end if
		if idopt2 <> 0 then
			set aProdOpt = getProductOptForProdAndOpt(idprod, idopt2)
			'response.write("<br>idopt2 price = " & aProdOpt.addprice)
			getPriceForProductOption = getPriceForProductOption + aProdOpt.addprice
		end if
		if idopt3 <> 0 then
			set aProdOpt = getProductOptForProdAndOpt(idprod, idopt3)
			'response.write("<br>idopt3 price = " & aProdOpt.addprice)
			getPriceForProductOption = getPriceForProductOption + aProdOpt.addprice
		end if
	end if

end function

sub insertProductOpt(byref aProdOpt)

	dim asql
	asql = "INSERT INTO PRODOPT (IDPROD,IDOPT,[DESC],IMG,ADDPRICE,SEQ,AVAILABLE) VALUES (" & aProdOpt.idProd & "," & aProdOpt.idOpt & ",'" & aProdOpt.desc & "','" & aProdOpt.img & "'," & aProdOpt.addprice & "," & aProdOpt.seq & "," & aProdOpt.available & ")"
	'response.write("<br>" & asql)
	'response.end
	call conExecute(asql)

end sub

sub updateProductOpt(byref oldIdProd, byref oldIdOpt, byref aProdOpt)

	dim asql
	asql = "UPDATE PRODOPT SET IDPROD=" & aProdOpt.idProd & ",IDOPT=" & aProdOpt.idOpt & ",[DESC]='" & aProdOpt.desc & "',IMG='" & aProdOpt.img & "',ADDPRICE=" & aProdOpt.addprice & ",SEQ=" & aProdOpt.seq & ",AVAILABLE=" & aProdOpt.available &_
		   " WHERE IDPROD=" & oldIdProd & " AND IDOPT=" & oldIdOpt & ""
	'response.write("<br>" & asql)
	call conExecute(asql)

end sub

sub deleteProductOpt(byref aProdOpt)

	dim asql
	asql = "DELETE FROM PRODOPT WHERE IDPROD=" & aProdOpt.idProd & " AND IDOPT=" & aProdOpt.idOpt
	'response.write("<br>" & asql)
	call conExecute(asql)

end sub

sub deleteAllProductOpts()

	dim asql
	asql = "DELETE FROM PRODOPT"
	call conExecute(asql)

end sub

sub deleteAllProductOptsForProd(byval idprod)

	dim asql
	asql = "DELETE FROM PRODOPT WHERE IDPROD=" & idprod
	call conExecute(asql)

end sub

function getCatByKey(byref akey)

	dim asql, ars
	asql = "SELECT * FROM CAT WHERE KEY='" & akey & "'"
	set ars = getQueryRecordSet(asql)

	while not ars.eof
		set getCatByKey = new cat
		getCatByKey.idCat = cint(ars("IDCAT"))
		getCatByKey.key = ars("KEY")
		getCatByKey.name = trim(ars("NAME"))
		getCatByKey.desc = trim(ars("DESC"))
		getCatByKey.retired = cbool(ars("RETIRED"))
		getCatByKey.seq = cint(ars("SEQ"))
		getCatByKey.idCatParent = cint(ars("IDCATPARENT"))
	
		ars.movenext
	wend

	closers(ars)
	
end function

function getCatById(byref aIdCat)

	dim asql, ars
	asql = "SELECT * FROM CAT WHERE IDCAT=" & aIdCat
	set ars = getQueryRecordSet(asql)

	while not ars.eof
		set getCatById = new cat
		getCatById.idCat = cint(ars("IDCAT"))
		getCatById.key = ars("KEY")
		getCatById.name = trim(ars("NAME"))
		getCatById.desc = trim(ars("DESC"))
		getCatById.retired = cbool(ars("RETIRED"))
		getCatById.seq = cint(ars("SEQ"))
		getCatById.idCatParent = cint(ars("IDCATPARENT"))
	
		ars.movenext
	wend

	closers(ars)
	
end function

function getProdById(byref aIdProd)

	dim asql, ars
	asql = "SELECT * FROM PROD WHERE IDPROD=" & aIdProd
	set ars = getQueryRecordSet(asql)

	while not ars.eof
		set getProdById = new product
		getProdById.idProd = ars("IDPROD")
		getProdById.idCat = ars("IDCAT")
		getProdById.key = trim(ars("KEY"))
		getProdById.name = trim(ars("NAME"))
		getProdById.desc = trim(ars("DESC"))
		getProdById.extdesc = trim(ars("EXTDESC"))
		getProdById.code = trim(ars("CODE"))
		getProdById.retired = ars("RETIRED")
		getProdById.rrp = ars("RRP")
		getProdById.price = ars("PRICE")
		getProdById.seq = ars("SEQ")
	
		ars.movenext
	wend

	closers(ars)
	
end function

function getProdByCatAndKey(byval aIdCat, byval aKey)

	dim asql, ars
	asql = "SELECT * FROM PROD WHERE IDCAT=" & aIdCat & " AND KEY='" & aKey & "'"
	set ars = getQueryRecordSet(asql)

	while not ars.eof
		set getProdByCatAndKey = new product
		getProdByCatAndKey.idProd = ars("IDPROD")
		getProdByCatAndKey.idCat = ars("IDCAT")
		getProdByCatAndKey.key = trim(ars("KEY"))
		getProdByCatAndKey.name = trim(ars("NAME"))
		getProdByCatAndKey.desc = trim(ars("DESC"))
		getProdByCatAndKey.extdesc = trim(ars("EXTDESC"))
		getProdByCatAndKey.code = trim(ars("CODE"))
		getProdByCatAndKey.retired = ars("RETIRED")
		getProdByCatAndKey.rrp = ars("RRP")
		getProdByCatAndKey.price = ars("PRICE")
		getProdByCatAndKey.seq = ars("SEQ")
	
		ars.movenext
	wend

	closers(ars)
	
end function

function getAttrByKey(byref aKey)

	dim asql, ars
	asql = "SELECT * FROM ATTR WHERE KEY='" & aKey & "'"
	set ars = getQueryRecordSet(asql)

	while not ars.eof
		set getAttrByKey = new attr
		getAttrByKey.idAttr = ars("IDATTR")
		getAttrByKey.key = ars("KEY")
		getAttrByKey.name = trim(ars("NAME"))
		getAttrByKey.desc = trim(ars("DESC"))
	
		ars.movenext
	wend

	closers(ars)
	
end function

function getAttr(byval aIdAttr)

	dim asql, ars
	asql = "SELECT * FROM ATTR WHERE IDATTR=" & aIdAttr
	set ars = getQueryRecordSet(asql)

	while not ars.eof
		set getAttr = new attr
		getAttr.idAttr = ars("IDATTR")
		getAttr.key = ars("KEY")
		getAttr.name = trim(ars("NAME"))
		getAttr.desc = trim(ars("DESC"))
	
		ars.movenext
	wend

	closers(ars)
	
end function

function getProductPage(byval aCatId, byval aPageSize, byval aPageNo, byRef aPageCount)

	dim asql, ars, i, aProduct, theProducts()
	asql = "SELECT * FROM PROD WHERE IDCAT=" & aCatId & " AND RETIRED=FALSE ORDER BY SEQ,NAME"
	set ars = getQueryRecordSet(asql)
	
	if not ars.eof then
	
		if aPageSize > 0 then
			ars.PageSize = aPageSize
			ars.CacheSize = aPageSize
		end if
		if aPageNo > 0 then
			ars.absolutepage = aPageNo
		end if
		aPageCount = ars.pagecount
		
		i = 0
		while not ars.eof and i < aPageSize
			i = i + 1
			set aProduct = new product
			aProduct.idProd = ars("IDPROD")
			aProduct.key = ars("KEY")
			aProduct.idCat = ars("IDCAT")
			aProduct.key = ars("KEY")
			aProduct.name = trim(ars("NAME"))
			aProduct.desc = trim(ars("DESC"))
			aProduct.extdesc = trim(ars("EXTDESC"))
			aProduct.code = trim(ars("CODE"))
			aProduct.retired = ars("RETIRED")
			aProduct.rrp = ars("RRP")
			aProduct.price = ars("PRICE")
			aProduct.seq = ars("SEQ")
		
			redim preserve theProducts(i)
			set theProducts(i) = aProduct
			ars.movenext
		wend

	else
	
		redim theProducts(0)
	
	end if
	
	closers(ars)
	
	getProductPage = theProducts

end function

function getProductSearchPage(byval aSearchString, byval aPageSize, byval aPageNo, byRef aPageCount)

	dim asql, aWords, aWord, bFirst, ars, i, aProduct, theProducts()
	
	if trim(aSearchString) = "" then
		asql = "SELECT * FROM PROD WHERE RETIRED=FALSE ORDER BY SEQ,NAME"
	else

		aSearchString = replace(aSearchString, " ", ",")
		aWords = split(aSearchString, ",")
		bFirst = true

		asql = "SELECT * FROM PROD WHERE RETIRED=FALSE AND ( ("
		for each aWord in aWords
			if not bFirst then
				asql = asql & " AND "
			end if
			asql = asql & " [DESC] LIKE '" & aWord & "'"
			asql = asql & " OR [DESC] LIKE '%" & aWord & "'"
			asql = asql & " OR [DESC] LIKE '" & aWord & "%'"
			asql = asql & " OR [DESC] LIKE '%" & aWord & "%'"
			bFirst = false
		next
		asql = asql & ")"

		bFirst = true
		asql = asql & " OR ("
		for each aWord in aWords
			if not bFirst then
				asql = asql & " AND "
			end if
			asql = asql & " NAME LIKE '" & aWord & "'"
			asql = asql & " OR NAME LIKE '%" & aWord & "'"
			asql = asql & " OR NAME LIKE '" & aWord & "%'"
			asql = asql & " OR NAME LIKE '%" & aWord & "%'"
			bFirst = false
		next
		asql = asql & ") )"

		asql = asql & " ORDER BY SEQ,NAME"

	end if

	'response.write("<br>" & asql)
	'response.end

	set ars = getQueryRecordSet(asql)
	
	if not ars.eof then
	
		if aPageSize > 0 then
			ars.PageSize = aPageSize
			ars.CacheSize = aPageSize
		end if
		if aPageNo > 0 then
			ars.absolutepage = aPageNo
		end if
		aPageCount = ars.pagecount
		
		i = 0
		while not ars.eof and i < aPageSize
			i = i + 1
			set aProduct = new product
			aProduct.idProd = ars("IDPROD")
			aProduct.key = ars("KEY")
			aProduct.idCat = ars("IDCAT")
			aProduct.key = ars("KEY")
			aProduct.name = trim(ars("NAME"))
			aProduct.desc = trim(ars("DESC"))
			aProduct.desc = trim(ars("DESC"))
			aProduct.code = trim(ars("CODE"))
			aProduct.retired = ars("RETIRED")
			aProduct.rrp = ars("RRP")
			aProduct.price = ars("PRICE")
			aProduct.seq = ars("SEQ")
		
			redim preserve theProducts(i)
			set theProducts(i) = aProduct
			ars.movenext
		wend
		
	else
	
		redim theProducts(0)
	
	end if
	
	closers(ars)
	
	getProductSearchPage = theProducts

end function

function getDomainData(byval akey)

	dim ars
	set ars = getQueryRecordSet("SELECT VAL FROM DOMAINDATA WHERE KEY='" & akey & "'")
	getDomainData = ""
	while not ars.eof
		getDomainData = trim(ars("VAL"))
		ars.movenext
	wend
	closers(ars)

end function

sub updateDomainData(byval akey, byval aval)

	dim asql
	asql = "UPDATE DOMAINDATA SET VAL='" & aval & "' WHERE KEY='" & akey & "'"
	call conExecute(asql)

end sub

function getThumbnailImgDir()

	if THUMBNAILIMGDIR = "" then
		THUMBNAILIMGDIR = getDomainData("THUMBNAILIMGDIR")
	end if
	
	getThumbnailImgDir = THUMBNAILIMGDIR

end function

function getStandardImgDir()

	if STDIMGDIR = "" then
		STDIMGDIR = getDomainData("STDIMGDIR")
	end if
	
	getStandardImgDir = STDIMGDIR

end function

function getThumbnailImg(byval code)

	getThumbnailImg = getThumbnailImgDir() + "/" + code + ".jpg"

end function

function getStandardImg(byval code)

	getStandardImg = getStandardImgDir() + "/" + code + ".jpg"

end function

function getCatImg(byval key)

	if CATIMGDIR = "" then
		CATIMGDIR = getDomainData("CATIMGDIR")
	end if
	
	getCatImg = CATIMGDIR + "/" + key + ".jpg"

end function

function getProdOptThumbnailImg(byval aidprod, byval aidopt)

	dim aProdOpt
	set aProdOpt = getProductOptForProdAndOpt(aidprod, aidopt)
	getProdOptThumbnailImg = getThumbnailImgDir() + "/" + aProdOpt.img

end function

function getProdOptStandardImg(byval aidprod, byval aidopt)

	dim aProdOpt
	set aProdOpt = getProductOptForProdAndOpt(aidprod, aidopt)
	getProdOptStandardImg = getStandardImgDir() + "/" + aProdOpt.img

end function

function getOffProdOptCombosForProduct(byval aIdProd)

	dim ars, theCombos(), aCombo, i, asql
	
	asql = "SELECT IDPROD,IDOPT1,IDOPT2,IDOPT3 FROM OFFPRODOPTCOMBO WHERE IDPROD=" & aIdprod
	
	set ars = getQueryRecordSet(asql)
	i = 0
	
	if ars.eof then
		redim theCombos(0)
	end if

	while not ars.eof
		i = i + 1
		set aCombo = new offprodoptcombo
		aCombo.idProd = ars("IDPROD")
		aCombo.idOpt1 = ars("IDOPT1")
		aCombo.idOpt2 = ars("IDOPT2")
		aCombo.idOpt3 = ars("IDOPT3")
	
		redim preserve theCombos(i)
		set theCombos(i) = aCombo

		ars.movenext
	wend
	
	closers(ars)
	
	getOffProdOptCombosForProduct = theCombos

end function

function isProdOptComboAvailable(byval aIdProd, byval aIdOpt1, byval aIdOpt2, byval aIdOpt3)

	'isProdOptComboAvailable = false
	'exit function
	
	dim ars, asql
	
	asql = "SELECT IDPROD FROM OFFPRODOPTCOMBO WHERE IDPROD=" & aIdprod & " AND IDOPT1=" & aIdOpt1 & " AND IDOPT2=" & aIdOpt2 & " AND IDOPT3=" & aIdOpt3
	'response.write("<br>asql = " & asql)
	'response.end
	set ars = getQueryRecordSet(asql)
	if ars.eof then
		isProdOptComboAvailable = true
	else
		isProdOptComboAvailable = false
	end if

end function

sub insertProdOptCombo(byref aOffprodoptcombo)

	dim asql
	asql = "INSERT INTO OFFPRODOPTCOMBO (IDPROD,IDOPT1,IDOPT2,IDOPT3) VALUES (" & aOffprodoptcombo.idProd & "," & aOffprodoptcombo.idOpt1 & "," & aOffprodoptcombo.idOpt2 & "," & aOffprodoptcombo.idOpt3 & ")"
	'response.write("<br>" & asql)
	'response.end
	call conExecute(asql)

end sub

sub deleteAllProdOptCombosForProd(byval idprod)

	dim asql
	asql = "DELETE FROM OFFPRODOPTCOMBO WHERE IDPROD=" & idprod
	call conExecute(asql)

end sub

sub deleteProdOptCombo(byref aOffprodoptcombo)

	dim asql
	asql = "DELETE FROM OFFPRODOPTCOMBO WHERE IDPROD=" & aOffprodoptcombo.idProd & " AND IDOPT1=" & aOffprodoptcombo.idOpt1 & " AND IDOPT2=" & aOffprodoptcombo.idOpt2 & " AND IDOPT3=" & aOffprodoptcombo.idOpt3
	call conExecute(asql)

end sub

sub insertProdOptComboPrice(byref aProdoptcomboprice)

	dim asql
	asql = "INSERT INTO PRODOPTCOMBOPRICE (IDPROD,IDOPT1,IDOPT2,IDOPT3,PRICE) VALUES (" & aProdoptcomboprice.idProd & "," & aProdoptcomboprice.idOpt1 & "," & aProdoptcomboprice.idOpt2 & "," & aProdoptcomboprice.idOpt3 & "," & aProdoptcomboprice.price & ")"
	'response.write("<br>" & asql)
	'response.end
	call conExecute(asql)

end sub

sub deleteAllProdOptComboPricesForProd(byval idprod)

	dim asql
	asql = "DELETE FROM PRODOPTCOMBOPRICE WHERE IDPROD=" & idprod
	call conExecute(asql)

end sub

sub deleteProdOptComboPrice(byref aProdoptcomboprice)

	dim asql
	asql = "DELETE FROM PRODOPTCOMBOPRICE WHERE IDPROD=" & aProdoptcomboprice.idProd & " AND IDOPT1=" & aProdoptcomboprice.idOpt1 & " AND IDOPT2=" & aProdoptcomboprice.idOpt2 & " AND IDOPT3=" & aProdoptcomboprice.idOpt3
	call conExecute(asql)

end sub

function getProdOptComboPricesForProduct(byval aIdProd)

	dim ars, theCombos(), aCombo, i, asql
	
	asql = "SELECT IDPROD,IDOPT1,IDOPT2,IDOPT3,PRICE FROM PRODOPTCOMBOPRICE WHERE IDPROD=" & aIdprod & " ORDER BY IDOPT1,IDOPT2,IDOPT3"
	'response.write("<br>asql = " & asql)
	
	set ars = getQueryRecordSet(asql)
	i = 0
	
	if ars.eof then
		redim theCombos(0)
	end if

	while not ars.eof
		i = i + 1
		set aCombo = new prodoptcomboprice
		aCombo.idProd = ars("IDPROD")
		aCombo.idOpt1 = ars("IDOPT1")
		aCombo.idOpt2 = ars("IDOPT2")
		aCombo.idOpt3 = ars("IDOPT3")
		aCombo.price = ars("PRICE")
	
		redim preserve theCombos(i)
		set theCombos(i) = aCombo

		ars.movenext
	wend
	
	closers(ars)
	
	getProdOptComboPricesForProduct = theCombos

end function

function getProdOptComboPrice(byval aIdProd, byval aIdOpt1, byval aIdOpt2, byval aIdOpt3)

	dim asql, ars
	
	asql = "SELECT PRICE FROM PRODOPTCOMBOPRICE WHERE IDPROD=" & aIdProd
	asql = asql & " AND IDOPT1=" & aIdOpt1
	asql = asql & " AND IDOPT2=" & aIdOpt2
	asql = asql & " AND IDOPT3=" & aIdOpt3
	'response.write("<br>asql = " & asql)
	'response.end
	
	set ars = getQueryRecordSet(asql)
	getProdOptComboPrice = -1.0
	
	if not ars.eof then
		getProdOptComboPrice = ars("PRICE")
	end if
	
	closers(ars)
	
end function

function getProdRelsForProd(byval aIdProd)

	dim ars, theRels(), aRel, i, asql
	
	asql = "SELECT IDPRODREL,IDPRODCHILD,SEQ FROM PRODREL WHERE IDPRODPARENT=" & aIdprod & " ORDER BY SEQ"
	
	set ars = getQueryRecordSet(asql)
	i = 0
	
	if ars.eof then
		redim theRels(0)
	end if

	while not ars.eof
		i = i + 1
		set aRel = new prodrel
		aRel.idProdRel = cint(ars("IDPRODREL"))
		aRel.idProdParent = aIdProd
		aRel.idProdChild = cint(ars("IDPRODCHILD"))
		aRel.seq = cint(ars("SEQ"))
	
		redim preserve theRels(i)
		set theRels(i) = aRel

		ars.movenext
	wend
	
	closers(ars)
	
	getProdRelsForProd = theRels

end function

sub insertProdRel(byref aProdRel)

	dim asql
	asql = "INSERT INTO PRODREL (IDPRODPARENT,IDPRODCHILD,SEQ) VALUES (" & aProdRel.idProdParent & "," & aProdRel.idProdChild & "," & aProdRel.seq & ")"
	'response.write("<br>" & asql)
	'response.end
	call conExecute(asql)

end sub

sub deleteProdRel(byref aIdProdRel)

	dim asql
	asql = "DELETE FROM PRODREL WHERE IDPRODREL=" & aIdProdRel
	'response.write("<br>" & asql)
	'response.end
	call conExecute(asql)

end sub

sub deleteProdRelForProd(byref aIdProdParent)

	dim asql
	asql = "DELETE FROM PRODREL WHERE IDPRODPARENT=" & aIdProdParent
	'response.write("<br>" & asql)
	'response.end
	call conExecute(asql)

end sub

function isValidPromocode(byval code)

	dim ars
	set ars = getQueryRecordSet("SELECT * FROM PROMOCODE WHERE CODE='" & code & "' AND RETIRED=FALSE")
	isValidPromocode = not ars.eof
	closers(ars)

end function

function getPromocode(byval code)

	dim ars
	set ars = getQueryRecordSet("SELECT * FROM PROMOCODE WHERE CODE='" & code & "'")
	set getPromocode = new promocode

	while not ars.eof
		getPromocode.code = ars("CODE")
		getPromocode.description = ars("DESCRIPTION")
		getPromocode.discount = cdbl(ars("DISCOUNT"))
		getPromocode.retired = cbool(ars("RETIRED"))
	
		ars.movenext
	wend
	
	closers(ars)

end function

sub insertPromocode(byref apromocode)

	dim asql
	asql = "INSERT INTO PROMOCODE (CODE,DESCRIPTION,DISCOUNT,RETIRED) VALUES ('" & apromocode.code & "','" & apromocode.description & "'," & apromocode.discount & "," & apromocode.retired & ")"
	'response.write("<br>" & asql)
	call conExecute(asql)

end sub

sub updatePromocode(byref apromocode)

	dim asql
	asql = "UPDATE PROMOCODE SET DISCOUNT=" & apromocode.discount & ",DESCRIPTION='" & apromocode.description & "',RETIRED=" & apromocode.retired & " WHERE CODE='" & apromocode.code & "'"
	'response.write("<br>" & asql)
	'response.end
	call conExecute(asql)

end sub

sub deletePromocode(byref acode)

	deleteAllPcLinks4Code(acode)
	dim asql
	asql = "DELETE FROM PROMOCODE WHERE CODE='" & acode & "'"
	call conExecute(asql)
	
end sub

function getPromoCodes(byval incRetired)

	dim ars, theCodes(), aCode, i, asql
	
	asql = "SELECT * FROM PROMOCODE"
	if not incRetired then
		asql = asql & " WHERE RETIRED=FALSE"
	end if
	asql = asql & " ORDER BY CODE"
	set ars = getQueryRecordSet(asql)
	i = 0

	while not ars.eof
		i = i + 1
		set aCode = new promocode
		aCode.code = ars("CODE")
		aCode.description = ars("DESCRIPTION")
		aCode.discount = cdbl(ars("DISCOUNT"))
		aCode.retired = cbool(ars("RETIRED"))
	
		redim preserve theCodes(i)
		set theCodes(i) = aCode

		ars.movenext
	wend

	closers(ars)
	
	if i = 0 then
		redim preserve theCodes(0)
	end if
	
	getPromoCodes = theCodes

end function

sub insertPcLink(byref apclink)

	dim asql
	asql = "INSERT INTO PCLINK (CODE,REFTYPE,REFID) VALUES ('" & apclink.code & "','" & apclink.reftype & "'," & apclink.refid & ")"
	'response.write("<br>" & asql)
	call conExecute(asql)

end sub

sub deletePcLink(byref aid)

	dim asql
	asql = "DELETE FROM PCLINK WHERE ID=" & aid
	call conExecute(asql)
	
end sub

sub deleteAllPcLinks4Code(byval acode)

	dim asql
	asql = "DELETE FROM PCLINK WHERE CODE='" & acode & "'"
	call conExecute(asql)
	
end sub

function getPcLinks4Code(byval acode, byval orderByType)

	dim ars, theLinks(), aLink, i, asql
	
	asql = "SELECT * FROM PCLINK WHERE CODE='" & acode & "' ORDER BY"
	if orderByType then
		asql = asql & " REFTYPE,"
	end if
	asql = asql & " ID"
	set ars = getQueryRecordSet(asql)
	i = 0

	while not ars.eof
		i = i + 1
		set aLink = new pclink
		aLink.id = cint(ars("ID"))
		aLink.code = ars("CODE")
		aLink.reftype = ars("REFTYPE")
		aLink.refid = cint(ars("REFID"))
	
		redim preserve theLinks(i)
		set theLinks(i) = aLink

		ars.movenext
	wend

	closers(ars)
	
	if i = 0 then
		redim preserve theLinks(0)
	end if
	
	getPcLinks4Code = theLinks

end function

function getDiscountedNames(byval acode)

	dim alinks, i, aNames(), acat, aprod
	alinks = getPcLinks4Code(acode, true)
	redim aNames(ubound(alinks))
	for i = 1 to ubound(alinks)
		if alinks(i).reftype = "CAT" then
			set acat = getCatById(alinks(i).refid)
			aNames(i) = "all " & acat.name
		elseif alinks(i).reftype = "PROD" then
			set aprod = getProdById(alinks(i).refid)
			set acat = getCatById(aprod.idCat)
			aNames(i) = "all " & aprod.name & " " & acat.name
		else
			aNames(i) = "all products"
		end if
	next
	
	getDiscountedNames = anames

end function

function getDiscountForOrderItem(byval aIdOrderItem, byval acode)

	dim ars, alinks, i, apromocode, aOrderItem, aprod
	
	getDiscountForOrderItem = 0
	
	if isValidPromocode(acode) then
		
		alinks = getPcLinks4Code(acode, true)
		set apromocode = getPromocode(acode)
		set aOrderItem = getOrderItem(aIdOrderItem)
		set aprod = getProdById(aOrderItem.idProd)
		
		for i = 1 to ubound(alinks)
			if alinks(i).reftype = "ALL" then
				getDiscountForOrderItem = apromocode.discount
				'response.write("<br>ALL discount " & getDiscountForOrderItem)
				exit function
			elseif alinks(i).reftype = "CAT" then
				if aprod.idCat = alinks(i).refid then
					getDiscountForOrderItem = apromocode.discount
					'response.write("<br>CAT(" & aprod.idCat & ") discount " & getDiscountForOrderItem)
					exit function
				end if
			else	' PROD
				if aOrderItem.idProd = alinks(i).refid then
					getDiscountForOrderItem = apromocode.discount
					'response.write("<br>PROD(" & aOrderItem.idProd & ") discount " & getDiscountForOrderItem)
					exit function
				end if
			end if
		next
	
	end if

end function
%>