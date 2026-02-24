-- Object: PROCEDURE dbo.AUTO_AWS_AUC_RPT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[AUTO_AWS_AUC_RPT]   
(   
@D  VARCHAR(11)  
)  
AS  
  
 BEGIN   
    
  EXEC msdb.DBO.SP_START_JOB 'AUTO_AWS_AUC'   
  WAITFOR DELAY '00:1:30';   
     
  SELECT 'CONTRACT NOTE PROCESS COMPLETED SUCESSFULLY...!!!   
  
  Kindly Find the File ON Below Path:   
  \\AngelNseCM\j\Contract_Note  ....!!!' AS [STATUS]  
    
 END

GO
