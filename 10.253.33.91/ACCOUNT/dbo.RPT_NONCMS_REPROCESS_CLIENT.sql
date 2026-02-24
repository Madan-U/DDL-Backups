-- Object: PROCEDURE dbo.RPT_NONCMS_REPROCESS_CLIENT
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------




CREATE procedure [dbo].[RPT_NONCMS_REPROCESS_CLIENT]     
as    
    
    
Begin    
    
declare @recordCount int     
   
 CREATE TABLE #RECORDCOUNT(RECORDCOUNT INT)   
 INSERT INTO #RECORDCOUNT

        
select   isnull(count(*), 0)    
FROM ANAND1.ACCOUNT.DBO.Recon_NONCMS_Data WHERE ModifiedDate BETWEEN DATEADD(hour,-2,GETDATE()) AND DATEADD(hour,1,GETDATE())    
AND UploadStatus='REPROCESS' AND MatchedFlag='1'
UNION ALL
select   isnull(count(*), 0)    
FROM AngelBSECM.ACCOUNT_AB.DBO.Recon_NONCMS_Data WHERE ModifiedDate BETWEEN DATEADD(hour,-2,GETDATE()) AND DATEADD(hour,1,GETDATE())    
AND UploadStatus='REPROCESS' AND MatchedFlag='1'
UNION ALL
select   isnull(count(*), 0)    
FROM ANGELFO.ACCOUNTFO.DBO.Recon_NONCMS_Data WHERE ModifiedDate BETWEEN DATEADD(hour,-2,GETDATE()) AND DATEADD(hour,1,GETDATE())    
AND UploadStatus='REPROCESS' AND MatchedFlag='1'
UNION ALL
select   isnull(count(*), 0)    
FROM ANGELFO.ACCOUNTCURFO.DBO.Recon_NONCMS_Data WHERE ModifiedDate BETWEEN DATEADD(hour,-2,GETDATE()) AND DATEADD(hour,1,GETDATE())    
AND UploadStatus='REPROCESS' AND MatchedFlag='1'
UNION ALL
select   isnull(count(*), 0)    
FROM ANGELCOMMODITY.ACCOUNTMCDX.DBO.Recon_NONCMS_Data WHERE ModifiedDate BETWEEN DATEADD(hour,-2,GETDATE()) AND DATEADD(hour,1,GETDATE())    
AND UploadStatus='REPROCESS' AND MatchedFlag='1'
UNION ALL
select   isnull(count(*), 0)    
FROM ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.Recon_NONCMS_Data WHERE ModifiedDate BETWEEN DATEADD(hour,-2,GETDATE()) AND DATEADD(hour,1,GETDATE())    
AND UploadStatus='REPROCESS' AND MatchedFlag='1'
UNION ALL
select   isnull(count(*), 0)    
FROM ANGELCOMMODITY.ACCOUNTNCDX.DBO.Recon_NONCMS_Data WHERE ModifiedDate BETWEEN DATEADD(hour,-2,GETDATE()) AND DATEADD(hour,1,GETDATE())    
AND UploadStatus='REPROCESS' AND MatchedFlag='1'

 

    
    
IF EXISTS(SELECT  * FROM #RECORDCOUNT WHERE RECORDCOUNT <> 0)    
begin    
    
    
DECLARE
    @tab char(1) = CHAR(9)
    
    
    
EXEC msdb.dbo.sp_send_dbmail    
    @profile_name = 'CLASS AUTO PROCESS TEST Profile',    
    @recipients = 'YOGESH.SAWANT@MKTTECH.IN;AKHILA.SETHI@MKTTECH.IN;pranita@angelbroking.com',    
    @query = 'SELECT EXCHANGE=''NSE'',SEGMENT=''CAPITAL'',UPLOADID,BANKACCOUNT,BANKCODE,DrCr,Amt,ValueDate,ReferenceNo,VNO,VTYP 
FROM ANAND1.ACCOUNT.DBO.Recon_NONCMS_Data
WHERE ModifiedDate BETWEEN DATEADD(hour,-2,GETDATE()) AND DATEADD(hour,1,GETDATE())     
AND UploadStatus=''REPROCESS''
AND MatchedFlag=1
UNION ALL
SELECT EXCHANGE=''BSE'',SEGMENT=''CAPITAL'',UPLOADID,BANKACCOUNT,BANKCODE,DrCr,Amt,ValueDate,ReferenceNo,VNO,VTYP 
FROM AngelBSECM.ACCOUNT_AB.DBO.Recon_NONCMS_Data
WHERE ModifiedDate BETWEEN DATEADD(hour,-2,GETDATE()) AND DATEADD(hour,1,GETDATE())     
AND UploadStatus=''REPROCESS''
AND MatchedFlag=1
UNION ALL
SELECT EXCHANGE=''NSE'',SEGMENT=''FUTURES'',UPLOADID,BANKACCOUNT,BANKCODE,DrCr,Amt,ValueDate,ReferenceNo,VNO,VTYP 
FROM ANGELFO.ACCOUNTFO.DBO.Recon_NONCMS_Data
WHERE ModifiedDate BETWEEN DATEADD(hour,-2,GETDATE()) AND DATEADD(hour,1,GETDATE())     
AND UploadStatus=''REPROCESS''
AND MatchedFlag=1
UNION ALL
SELECT EXCHANGE=''NSX'',SEGMENT=''FUTURES'',UPLOADID,BANKACCOUNT,BANKCODE,DrCr,Amt,ValueDate,ReferenceNo,VNO,VTYP 
FROM ANGELFO.ACCOUNTCURFO.DBO.Recon_NONCMS_Data
WHERE ModifiedDate BETWEEN DATEADD(hour,-2,GETDATE()) AND DATEADD(hour,1,GETDATE())     
AND UploadStatus=''REPROCESS''
AND MatchedFlag=1
UNION ALL
SELECT EXCHANGE=''MCX'',SEGMENT=''FUTURES'',UPLOADID,BANKACCOUNT,BANKCODE,DrCr,Amt,ValueDate,ReferenceNo,VNO,VTYP 
FROM ANGELCOMMODITY.ACCOUNTMCDX.DBO.Recon_NONCMS_Data
WHERE ModifiedDate BETWEEN DATEADD(hour,-2,GETDATE()) AND DATEADD(hour,1,GETDATE())     
AND UploadStatus=''REPROCESS''
AND MatchedFlag=1
UNION ALL
SELECT EXCHANGE=''MCD'',SEGMENT=''FUTURES'',UPLOADID,BANKACCOUNT,BANKCODE,DrCr,Amt,ValueDate,ReferenceNo,VNO,VTYP 
FROM ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.Recon_NONCMS_Data
WHERE ModifiedDate BETWEEN DATEADD(hour,-2,GETDATE()) AND DATEADD(hour,1,GETDATE())     
AND UploadStatus=''REPROCESS''
AND MatchedFlag=1
UNION ALL
SELECT EXCHANGE=''NCX'',SEGMENT=''FUTURES'',UPLOADID,BANKACCOUNT,BANKCODE,DrCr,Amt,ValueDate,ReferenceNo,VNO,VTYP 
FROM ANGELCOMMODITY.ACCOUNTNCDX.DBO.Recon_NONCMS_Data
WHERE ModifiedDate BETWEEN DATEADD(hour,-2,GETDATE()) AND DATEADD(hour,1,GETDATE())     
AND UploadStatus=''REPROCESS''
AND MatchedFlag=1 
' ,
    

      
      
    @subject = 'LIST OF NONCMS_REPROCESS_CLIENT',    
    @Body = 'NONCMS_REPROCESS_CLIENT..... ' ,    
    @attach_query_result_as_file = 1,  
    @query_attachment_filename='NONCMS_REPROCESS_CLIENT.xls',
    @query_result_separator=@tab,
    @query_result_no_padding=1;
  
  
End    
else    
begin    
    
      EXEC msdb.dbo.sp_send_dbmail    
      @profile_name = 'CLASS AUTO PROCESS TEST Profile',    
       @recipients = 'YOGESH.SAWANT@MKTTECH.IN;AKHILA.SETHI@MKTTECH.IN;pranita@angelbroking.com',     
            @BODY = 'No data returned ',     
            @subject = 'LIST OF NONCMS_REPROCESS_CLIENT'    
    
End    
End;

GO
