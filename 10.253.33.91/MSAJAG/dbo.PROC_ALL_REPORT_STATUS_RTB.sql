-- Object: PROCEDURE dbo.PROC_ALL_REPORT_STATUS_RTB
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[PROC_ALL_REPORT_STATUS_RTB] (@RUNDATE VARCHAR(11),@REPORT VARCHAR(10))      
      
AS  --- EXEC PROC_ALL_REPORT_STATUS 'SEP 12 2022'      
  
SELECT SRNO,Business_DATE,Process_Name,    
CASE WHEN process_flag =1 THEN 'Completed'    
ELSE 'Pending'    
END AS Status    
FROM TBL_CASH_PROCESS_LOG  WHERE Business_Date=@RUNDATE order by process_Date

GO
