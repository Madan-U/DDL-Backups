-- Object: PROCEDURE dbo.RPT_ALERT_DELAYINACTIVE_NP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


            
CREATE PROCEDURE [dbo].[RPT_ALERT_DELAYINACTIVE_NP]      
            
AS             

DECLARE @RUNDATE VARCHAR(11)

SET @RUNDATE = GETDATE()

DECLARE @bodycontent VARCHAR(max),@SUB varchar(500)  
  
SET @SUB = 'Client Details Not Present in Master - '+ CONVERT(VARCHAR(11),GETDATE(),105)            
            
DECLARE @ADNAME VARCHAR(100) = 'J:\BACKOFFICE\EXPORT\' + 'DELAY_IN_ACTIVATION_DATA_NP_'+ REPLACE(CONVERT(VARCHAR(10), GETDATE(), 104), '.', '') + '.CSV'            
DECLARE @ADSTMT NVARCHAR(4000) = 'EXEC [MSAJAG].[DBO].[RPT_ACTIVE_CLIENT_VDT_NP]  ''' + @RUNDATE + ''''            
DECLARE @ADBCP VARCHAR(4000) = 'BCP "' + @ADSTMT + '" QUERYOUT "' + @ADNAME + '" -c -t"," -r"\n" -T'            
            
EXEC MASTER..XP_CMDSHELL @ADBCP , NO_OUTPUT            
            
SELECT @bodycontent = '<p>Dear Nirmal,</p>            
<p>Please see the attached file for client not done Client activation and Client receipt data present.</p>            
<p>&nbsp;</p><p>&nbsp;</p>'            

EXEC MSDB.DBO.SP_SEND_DBMAIL             
@PROFILE_NAME='BO SUPPORT',             
@RECIPIENTS='nirmal.purohit@angelbroking.com;sandip.tote@angelbroking.com;mohitsohanlal.jain@angelbroking.com;nitin.kumar@angelbroking.com;sm.sunnysiddula@angelbroking.com;ravindra.1raje@angelbroking.com',            
@copy_recipients='suresh.raut@angelbroking.com;nikunj.shah@angelbroking.com;narayan.patankar@angelbroking.com',            
@blind_copy_recipients='ananthanarayanan.b@angelbroking.com',            
@SUBJECT=@SUB,            
@BODY=@BODYCONTENT,            
@FILE_ATTACHMENTS = @ADNAME,            
@IMPORTANCE = 'HIGH',            
@BODY_FORMAT ='HTML'

GO
