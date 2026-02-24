-- Object: PROCEDURE dbo.PER_LOT_100_BROK_ANG_EMAIL
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

  
CREATE PROC [dbo].[PER_LOT_100_BROK_ANG_EMAIL] AS    
   
DECLARE @bodycontent VARCHAR(max),@SUB varchar(500)    
    
SET @SUB = 'PER LOT 100 brokage slab Client Details - '+ CONVERT(VARCHAR(11),GETDATE(),105)              
              
DECLARE @ADNAME VARCHAR(100) = 'J:\BACKOFFICE\EXPORT\' + 'PER_LOT_100_BROK_ANG_'+ REPLACE(CONVERT(VARCHAR(10), GETDATE(), 104), '.', '') + '.CSV'              
DECLARE @ADSTMT NVARCHAR(4000) = 'EXEC [INHOUSE].[DBO].[PER_LOT_100_BROK_ANG]'              
DECLARE @ADBCP VARCHAR(4000) = 'BCP "' + @ADSTMT + '" QUERYOUT "' + @ADNAME + '" -c -t"," -r"\n" -T'              
              
EXEC MASTER..XP_CMDSHELL @ADBCP , NO_OUTPUT              
              
SELECT @bodycontent = '<p>Dear Nilesh,</p>              
<p>Data has been generated for the clients having more than PER LOT 100 brokage slab on below path.</p>   
<p>J:\BACKOFFICE\EXPORT</p>  
<p>&nbsp;</p><p>&nbsp;</p>'              
                          
EXEC MSDB.DBO.SP_SEND_DBMAIL               
@PROFILE_NAME='BO SUPPORT',               
@RECIPIENTS='nilesh@angelbroking.com',              
@copy_recipients='brokerage.modification@angelbroking.com;rahulc.shah@angelbroking.com',              
--@blind_copy_recipients='ananthanarayanan.b@angelbroking.com',              
@SUBJECT=@SUB,              
@BODY=@BODYCONTENT,              
--@FILE_ATTACHMENTS = @ADNAME,              
@IMPORTANCE = 'HIGH',              
@BODY_FORMAT ='HTML'

GO
