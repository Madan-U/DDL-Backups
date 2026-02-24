-- Object: PROCEDURE dbo.RPT_ALERT_DELAYINACTIVE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE PROCEDURE [dbo].[RPT_ALERT_DELAYINACTIVE] (@RUNDATE VARCHAR(11))            

            

AS             

            

DECLARE @bodycontent VARCHAR(max),@SUB varchar(500)  

  

DECLARE @NI AS VARCHAR(2) = '0'  

DECLARE @PATHI AS VARCHAR(200) =  'J:\BACKOFFICE\IMPORT'  

DECLARE @DELETESQLI AS VARCHAR(512)  

SET @DELETESQLI = 'FORFILES /P "' + @PATHI + '" /S /M *.* /D -' + @NI + ' /C "CMD /C DEL @PATH"'  

EXEC MASTER.DBO.XP_CMDSHELL @DELETESQLI, NO_OUTPUT   

  

DECLARE @NE AS VARCHAR(2) = '0'  

DECLARE @PATHE AS VARCHAR(200) =  'J:\BACKOFFICE\EXPORT'  

DECLARE @DELETESQLE AS VARCHAR(512)  

SET @DELETESQLE = 'FORFILES /P "' + @PATHE + '" /S /M *.* /D -' + @NE + ' /C "CMD /C DEL @PATH"'  

EXEC MASTER.DBO.XP_CMDSHELL @DELETESQLE, NO_OUTPUT   

             

SET @SUB = 'Delay in Activation Client Details - '+ CONVERT(VARCHAR(11),GETDATE(),105)            

            

DECLARE @ADNAME VARCHAR(100) = 'J:\BACKOFFICE\EXPORT\' + 'DELAY_IN_ACTIVATION_DATA_'+ REPLACE(CONVERT(VARCHAR(10), GETDATE(), 104), '.', '') + '.CSV'            

DECLARE @ADSTMT NVARCHAR(4000) = 'EXEC [MSAJAG].[DBO].[RPT_ACTIVE_CLIENT_VDT]  ''' + @RUNDATE + ''''            

DECLARE @ADBCP VARCHAR(4000) = 'BCP "' + @ADSTMT + '" QUERYOUT "' + @ADNAME + '" -c -t"," -r"\n" -T'            

            

EXEC MASTER..XP_CMDSHELL @ADBCP , NO_OUTPUT            

            

SELECT @bodycontent = '<p>Dear Nirmal,</p>            

<p>Please see the attached file for a reconciliation of Client activation and Client receipt data.</p>            

<p>&nbsp;</p><p>&nbsp;</p>'            

            

EXEC ACCOUNT.DBO.ALT_EXCHANGE_PAYINPAYOUT   ---- EXCHANGE PAYOUT ALERT FOR NARAYAN TEAM            

            

EXEC MSDB.DBO.SP_SEND_DBMAIL             

@PROFILE_NAME='BO SUPPORT',             

@RECIPIENTS='ganesh.jagdale@angelbroking.com;narayan.patankar@angelbroking.com',            

@copy_recipients='rahulc.shah@angelbroking.com',            

@blind_copy_recipients='bo.support@angelbroking.com',            

@SUBJECT=@SUB,            

@BODY=@BODYCONTENT,            

@FILE_ATTACHMENTS = @ADNAME,            

@IMPORTANCE = 'HIGH',            

@BODY_FORMAT ='HTML'            

      

      

IF ( CONVERT(VARCHAR(11),ACCOUNT.DBO.FN_NEXTWEEKDAY(GETDATE(), 'MON'),109) = CONVERT(VARCHAR(11),GETDATE()))        

BEGIN         

EXEC ACCOUNT.DBO.[BANK_PayinPout_New_2]          

END        

            

EXEC ACCOUNT.DBO.BANK_PayinPout_New -- Narayan Bank Payin Payout Report          

            

EXEC ACCOUNT.DBO.TBL_PAYINPAYOUTREPORT   ---- EXCHANGE PAYIN / PAYOUT             

            

EXEC ACCOUNT.DBO.TBL_TRUNOVER_ANG_RPT    ---- EXCHANGE TURNOVER      

      

EXEC ACCOUNT.DBO.CONTROLACCMAILER -- Control A/c Tally      



EXEC ACCOUNT.DBO.PER_LOT_100_BROK_ANG_EMAIL

      

EXEC BROK_ISSUE_CODE_PROC 'F'-- Wrong Brokage Query for Nilesh      

      

--EXEC MISSING_DISBROK -- Missing Discount Brok for Shashi       

  

--EXEC PROC_OFF_MARKET_DATA_ANG -- Akshay / Malhar - Auto  

  

--EXEC BANKNIFTY_FINNIFTY_ISSUE_ANG_EMAIL

GO
