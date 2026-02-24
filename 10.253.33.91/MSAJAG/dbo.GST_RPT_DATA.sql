-- Object: PROCEDURE dbo.GST_RPT_DATA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

---EXEC GST_RPT_DATA 'MAY  1 2021','MAY 31 2021','N0','ZZZ99999'  
  
CREATE PROCEDURE [dbo].[GST_RPT_DATA]  
(  
@FROMDATE VARCHAR(30),  
@TODATE VARCHAR(30),  
@FROMPARTY VARCHAR(20),  
@TOPARTY VARCHAR(20)  
)  
AS BEGIN   
TRUNCATE TABLE RPT_GST_NO_SSRS  
  
INSERT INTO RPT_GST_NO_SSRS  
SELECT DISTINCT PARTY_CODE,INV_NO  
---into RPT_GST_NO_SSRS  
 FROM TBL_GST_INVOICE WITH(NOLOCK)  
WHERE INVOICE_DATE>=@FROMDATE AND INVOICE_DATE<=@TODATE   
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY ORDER BY PARTY_CODE  
  
DECLARE @FILE1 VARCHAR(MAX),@PATH1 VARCHAR(MAX) = 'J:\BackOffice\Automation\GST_DATA\'                         
SET @FILE1 = @PATH1 + 'GST_CLIENT' +'_'+ @FROMPARTY + '.csv' --Folder Name       
DECLARE @S1 VARCHAR(MAX)                                
SET @S1 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''PARTY_CODE'''',''''INV_NO'''''    --Column Name      
SET @S1 = @S1 + ' UNION ALL SELECT    cast([PARTY_CODE] as varchar),cast([INV_NO] as varchar)  FROM [MSAJAG].[dbo].[RPT_GST_NO_SSRS]    " QUERYOUT ' --Convert data type if required      
      
 +@file1+ ' -c -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''       
--       PRINT  (@S)       
EXEC(@S1)        
    
END

GO
