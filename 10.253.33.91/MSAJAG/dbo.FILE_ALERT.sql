-- Object: PROCEDURE dbo.FILE ALERT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc [dbo].[FILE ALERT]
as

EXEC MSDB.DBO.SP_SEND_DBMAIL                                  
@PROFILE_NAME ='BO SUPPORT',                                  
@RECIPIENTS ='csosurveillance@angelbroking.com;tushar.jorigal@angelbroking.com', 
@COPY_RECIPIENTS='updationteam@angelbroking.com',                                  
@BODY = 'Dear Team,<br><br>Kindly Keep the Trade file for <B>Auto squared off setting </B> on below mentioned Path and format:<br> <br> \\ABVSINSURANCEBO.INTERNAL.ANGELONE.IN\Share\BoSupport\CNT_Omnesys <br>FILE NAME FORMAT:Trades-date.txt (Eg: Trades-07022020.txt) <br><br><br> Regards,<br>Punit Verma',
@BODY_FORMAT ='HTML',                                 
@SUBJECT = 'FILE ALERT'

GO
