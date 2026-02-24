-- Object: PROCEDURE dbo.MISSING_DISBROK
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

    
CREATE PROC [dbo].[MISSING_DISBROK]     
    
AS    
    
DECLARE @SAUDA_DATE_L VARCHAR(11)    
    
SET @SAUDA_DATE_L = GETDATE() - 1    
    
IF ( CONVERT(VARCHAR(11),ACCOUNT.DBO.FN_NEXTWEEKDAY(GETDATE(), 'MON'),109) = CONVERT(VARCHAR(11),GETDATE()))        
BEGIN         
RETURN        
END        
        
IF ( CONVERT(VARCHAR(11),ACCOUNT.DBO.FN_NEXTWEEKDAY(GETDATE(), 'SUN'),109) = CONVERT(VARCHAR(11),GETDATE()))        
BEGIN         
RETURN        
END        
        
IF ( SELECT COUNT(1) FROM MSAJAG.DBO.SETT_MST WHERE CONVERT(VARCHAR(11),START_DATE) = CONVERT(VARCHAR(11),GETDATE()-1) AND SETT_TYPE = 'N') = ''        
BEGIN         
RETURN        
END        
        
 --EXEC MISSING_DISBROK 'JUL 19 2022'    
  
--TRUNCATE TABLE MISSING_DISBROK_ANG  
   
--INSERT INTO MISSING_DISBROK_ANG 

EXEC [ANGELFO].[NSECURFO].[DBO].MISSING_DISBROK @SAUDA_DATE_L ,1 
    
    
DECLARE @bodycontent VARCHAR(max),@SUB varchar(500)          
           
SET @SUB = 'Missing Discount Brok - '+ CONVERT(VARCHAR(11),@SAUDA_DATE_L,105)          
          
DECLARE @ADNAME VARCHAR(100) = 'J:\BACKOFFICE\EXPORT\' + 'Missing_Discount_Brok_'+ REPLACE(CONVERT(VARCHAR(11), @SAUDA_DATE_L, 104), ' ', '-') + '.CSV'          
--DECLARE @ADSTMT NVARCHAR(4000) = 'EXEC [ANGELFO].[NSECURFO].[DBO].MISSING_DISBROK  ''' + @SAUDA_DATE_L + ''''      
DECLARE @ADSTMT NVARCHAR(4000) = 'SELECT * FROM [AngelNSECM].[MSAJAG].DBO.MISSING_DISBROK_ANG'      
DECLARE @ADBCP VARCHAR(4000) = 'BCP "' + @ADSTMT + '" QUERYOUT "' + @ADNAME + '" -c -t"," -r"\n" -T'          
          
EXEC MASTER..XP_CMDSHELL @ADBCP , NO_OUTPUT          
          
SELECT @bodycontent = '<p>Dear Team,</p>            
<p>Please see the attached file for a Missing Discount Brok of Client data.</p>            
<p>&nbsp;</p>'   + @ADNAME    
    
EXEC MSDB.DBO.SP_SEND_DBMAIL           
@PROFILE_NAME='BO SUPPORT',           
--@RECIPIENTS='shashi.soni@angelbroking.com',          
--@copy_recipients='saurabh.saran@angelbroking.com;dileswar.jena@angelbroking.com',          
@blind_copy_recipients='ananthanarayanan.b@angelbroking.com',          
@SUBJECT=@SUB,          
@BODY=@BODYCONTENT,          
--@FILE_ATTACHMENTS = @ADNAME,          
@IMPORTANCE = 'HIGH',          
@BODY_FORMAT ='HTML'

GO
