<%'******************************************************
    
    Response.Charset = "ISO-8859-1"
    Response.CacheControl = "no-cache"
    Response.AddHeader "Pragma", "no-cache"
    Response.Expires = -1

    html = "Hei "  & VbCrLf
	html = html & VbCrLf			
	html = html & " Test" & VbCrLf
	html = html & VbCrLf			
	html = html & VbCrLf
	html = html & VbCrLf			
	html = html & "Mvh" & VbCrLf
	html = html & "Team Abrahamsen Audio" & VbCrLf			
	html = html & VbCrLf
	html = html & VbCrLf
	html = html & VbCrLf
	html = html & "Dette er en automatisk generert e-post, vennligst ikke svar på denne." & VbCrLf

    Set myMail = Server.CreateObject("CDO.Message")
	myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
	myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = serverIP
	myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
	myMail.Configuration.Fields.Update
			
	myMail.From = "team@abrahamsenaudio.com"
	myMail.To = "kai.abrahamsen@welonda.com"		
	myMail.Subject = "Abrahamsen Audio - Web Form" 
	myMail.TextBody = html
	myMail.BodyPart.Charset = "UTF-8"		
	myMail.Send
	Set myMail = Nothing
%>