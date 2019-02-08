<%'******************************************************
Response.Charset = "ISO-8859-1"
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1


	'***************************************************
	
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open "PROVIDER=MICROSOFT.JET.OLEDB.4.0; DATA SOURCE=" & server.mappath("/db/db.mdb")
	
	'***************************************************
	
	Set rsproduktkategori = Server.CreateObject("ADODB.Recordset")    
	strSQL = "SELECT * FROM tblProduktkategori" 	
	
	rsproduktkategori.CursorType = 2
	rsproduktkategori.LockType = 3
	rsproduktkategori.Open strSQL, conn
    Do While NOT rsproduktkategori.EOF
        strproduktkategori = strproduktkategori & "{""ProduktkategoriId"": """ & rsproduktkategori("ProduktkategoriId") & ""","
        strproduktkategori = strproduktkategori & """Produktkategori"": """ & rsproduktkategori("Produktkategori") & """},"
    rsproduktkategori.MoveNext
	Loop
    Set rsproduktkategori = Nothing

    Set rsproduktgruppe = Server.CreateObject("ADODB.Recordset")    
	strSQL = "SELECT * FROM tblProduktgruppe" 	
	'***************************************************
	rsproduktgruppe.CursorType = 2
	rsproduktgruppe.LockType = 3
	rsproduktgruppe.Open strSQL, conn
    Do While NOT rsproduktgruppe.EOF
        strproduktgruppe = strproduktgruppe & "{""ProduktgruppeId"": """ & rsproduktgruppe("produktgruppeId") & ""","
        strproduktgruppe = strproduktgruppe & """Produktgruppe"": """ & rsproduktgruppe("Produktgruppe") & """},"
    rsproduktgruppe.MoveNext
	Loop
    Set rsproduktgruppe = Nothing

    conn.Close
    Set conn = Nothing

    If Right(strproduktgruppe, 1) = "," Then
		strproduktgruppe = Left(strproduktgruppe, Len(strproduktgruppe) -1)
	End If
    If Right(strproduktkategori, 1) = "," Then
	strproduktkategori = Left(strproduktkategori, Len(strproduktkategori) -1)
    End If

	
	data = "{"
	
	data = data & """produktkategori"":"	
	data = data & "["
	data = data & strproduktkategori
	data = data & "],"

    data = data & """produktgruppe"":"	
	data = data & "["
	data = data & strproduktgruppe
	data = data & "]"

	
	data = data & "}"
	
	response.write Data


%>
	
