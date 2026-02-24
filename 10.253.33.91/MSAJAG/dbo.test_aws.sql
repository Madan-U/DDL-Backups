-- Object: PROCEDURE dbo.test_aws
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc  test_aws  
(@D varchar(11)  
)  
  
as   
   
     
 BEGIN   
 TRUNCATE TABLE TBL_CN_MAR_BILL_DATE  
 INSERT INTO TBL_CN_MAR_BILL_DATE  
 SELECT @D,'M'  
    
  EXEC msdb.DBO.SP_START_JOB 'AUTO_AWS_CN_MAR_BILL'   
   WAITFOR DELAY '00:02:02';   
     
DECLARE @C varchar(11)      
SELECT @C=COUNT(DISTINCT PARTY_CODE)  FROM MARGIN_PROCESS WHERE SNO=1  
  SELECT 'MARGIN STATEMENT PROCESS FOR '+ '' + 'WITH COUNT OF '+@C+' COMPLETED SUCESSFULLY...!!!   
  
  Kindly Find the File ON Below Path:   
  \\AngelNseCM\j\Comb_Margin  ....!!!' AS STATUS  
    
 END  
  
  
   
  
--147868

GO
