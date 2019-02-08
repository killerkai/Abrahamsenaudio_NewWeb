<%'************************************************
Response.Charset = "ISO-8859-1"
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1

'************************************************
Function jsonEncode(str)
 If str <> "" Then
  Dim charmap(127), haystack()
  charmap(8)  = "\b"
  charmap(9)  = "\t"
  charmap(10) = "\n"
  charmap(12) = "\f"
  charmap(13) = "\r"
  charmap(34) = "\"""
  charmap(47) = "\/"
  charmap(92) = "\\"
  Dim strlen : strlen = Len(str) - 1
  ReDim haystack(strlen)
  Dim i, charcode
  For i = 0 To strlen
   haystack(i) = Mid(str, i + 1, 1)
   charcode = AscW(haystack(i)) And 65535
   If charcode < 127 Then
    If Not IsEmpty(charmap(charcode)) Then
     haystack(i) = charmap(charcode)
    ElseIf charcode < 32 Then
     haystack(i) = "\u" & Right("000" & LCase(Hex(charcode)), 4)
    End If
   Else
    haystack(i) = "\u" & Right("000" & LCase(Hex(charcode)), 4)
   End If
  Next
  jsonEncode = Join(haystack, "")
 Else
  jsonEncode = str 
 End If
End Function

Function ReplaceBadChar(strTemp)
	strTemp = Replace(Replace(Replace(Replace(strTemp, Chr(10), "\n"), Chr(13), "\r"), Chr(34), "\"""), "<br>", "")
	ReplaceBadChar = strTemp
End Function

Function IngressTekst(InString,What,Lengde)

	LoopLengde = LEN(InString)
	If LoopLengde < Lengde Then
		IngressTekst = InString	
	Else

		If Asc(Mid(InString, LoopLengde, 1)) <> Asc(What) Then
			InString = InString & chr(What)
			LoopLengde = LEN(InString)
		End If

		For i = 1 To LoopLengde
		 	If Asc(Mid(InString, i, 1)) = What Then	 	
				If i >= Lengde Then
			 		w_InString = Mid(InString, 1, i)
		 			Exit For 	
		 		End If
		 	End If	
		Next		
		IngressTekst = w_InString

	End If

End Function




'**************************************************

	'***************************************************
	
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open "PROVIDER=MICROSOFT.JET.OLEDB.4.0; DATA SOURCE=" & server.mappath("/db/db.mdb")
	
	'***************************************************
	
	Set rsprodukter = Server.CreateObject("ADODB.Recordset")    
	strSQL = "SELECT * FROM tblProdukt" 	
	
	rsprodukter.CursorType = 2
	rsprodukter.LockType = 3
	rsprodukter.Open strSQL, conn
	
	Do While NOT rsprodukter.EOF	
		
		ProduktkategoriId = rsprodukter("ProduktkategoriId")        
		
		Set Produktkategori = Server.CreateObject("ADODB.Recordset")
		strSQL = "SELECT * FROM tblProduktkategori WHERE ProduktkategoriId = " & ProduktkategoriId
			
		Produktkategori.CursorType = 2
		Produktkategori.LockType = 3
		Produktkategori.Open strSQL, conn
    
        ProduktgruppeiId = rsprodukter("ProduktgruppeId")        
		
		Set Produktgruppe = Server.CreateObject("ADODB.Recordset")
		strSQL = "SELECT * FROM tblProduktgruppe WHERE ProduktgruppeId = " & ProduktgruppeiId
			
		Produktgruppe.CursorType = 2
		Produktgruppe.LockType = 3
		Produktgruppe.Open strSQL, conn	
        	
		
		
		strData = strData & "{""produkt"": """ & rsprodukter("Produkt") & ""","
        strData = strData & """produktid"": """ & rsprodukter("Produktid") & ""","
        strData = strData & """regdato"": """ & rsprodukter("RegDato") & ""","
        strData = strData & """produktkategori"": """ & Produktkategori("Produktkategori") & ""","
        strData = strData & """produktgruppe"": """ & Produktgruppe("Produktgruppe") & ""","
        strData = strData & """produktbredde"": """ & rsprodukter("Bredde") & ""","	
        strData = strData & """produkthoyde"": """ & rsprodukter("Hoyde") & ""","
        strData = strData & """produktdybde"": """ & rsprodukter("Dybde") & ""","
        strData = strData & """produktvekt"": """ & rsprodukter("Vekt") & ""","	
		strData = strData & """produktbeskrivelse"": """ & jsonEncode(rsprodukter("ProduktBeskrivelse")) & ""","
        strData = strData & """butikkstatus"": """ & rsprodukter("ButikkStatus") & ""","
        strData = strData & """webstatus"": """ & rsprodukter("WebStatus") & ""","
        strData = strData & """slidestatus"": """ & rsprodukter("slide") & ""","
        strData = strData & """pris"": """ & rsprodukter("Pris") & ""","
        strData = strData & """bilde"": """ & rsprodukter("bilde1") & ""","
		strData = strData & """status"": """ & rsprodukter("Status") & """},"
		
		Set Produktkategori = Nothing
        Set Produktgruppe = Nothing
        
	rsprodukter.MoveNext
	Loop
	strSQL = "SELECT TilleggId, KnyttetId, TilleggGruppe, TilleggTekst"
    strSQL = strSQL & " FROM tblTillegg"
    strSQL = strSQL & " WHERE TilleggType = 'produkt'"
    strSQL = strSQL & " ORDER BY KnyttetId, TilleggGruppe"
    Set rsProduktTillegg = Conn.Execute(strSQL)

    Do While NOT rsProduktTillegg.EOF
				
	    produkttilleggdata = produkttilleggdata & "{""TilleggId"": """ & rsProduktTillegg("TilleggId") & """,""produktid"": """ & rsProduktTillegg("KnyttetId") & """,""tillegggruppe"": """ & rsProduktTillegg("TilleggGruppe") & ""","
	    produkttilleggdata = produkttilleggdata & """tilleggtekst"": """ & ReplaceBadChar(rsProduktTillegg("TilleggTekst")) & """},"
			
    rsProduktTillegg.MoveNext
    Loop

	Set rsProduktTillegg = Nothing
	'***************************************************

	conn.Close
	Set conn = Nothing
	Set rsprodukter = Nothing
		
	'***************************************************
	
	If Right(strData, 1) = "," Then
		strData = Left(strData, Len(strData) -1)
	End If
    If Right(produkttilleggdata, 1) = "," Then
	produkttilleggdata = Left(produkttilleggdata, Len(produkttilleggdata) -1)
    End If

	
	data = "{"
	
	data = data & """produkt"":"	
	data = data & "["
	data = data & strData
	data = data & "],"

    data = data & """produkttillegg"":"	
	data = data & "["
	data = data & produkttilleggdata
	data = data & "]"

	
	data = data & "}"
	
	response.write Data
	


'**********************************************%>