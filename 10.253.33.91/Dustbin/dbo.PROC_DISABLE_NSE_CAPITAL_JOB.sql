-- Object: PROCEDURE dbo.PROC_DISABLE_NSE_CAPITAL_JOB
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

CREATE PROCEDURE [dbo].[PROC_DISABLE_NSE_CAPITAL_JOB] (@RUNDATE VARCHAR(11),@REPORT VARCHAR(10))          
          
AS  --- EXEC PROC_ALL_REPORT_STATUS 'SEP 12 2022'          
    EXEC ANAND1.msdb.dbo.sp_update_job
@job_name='NSE CASH AUTO PROCESS SETTLEMENT',@enabled = 0
select JOB_STATUS='NSE-CAPITAL AUTOMATION JOB IS SUCCESSFULLY DISABLED'

GO
