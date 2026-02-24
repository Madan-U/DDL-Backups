-- Object: PROCEDURE dbo.PROC_ENABLE_MCDX_FUTURES_JOB
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

CREATE PROCEDURE [dbo].[PROC_ENABLE_MCDX_FUTURES_JOB] (@RUNDATE VARCHAR(11),@REPORT VARCHAR(10))              
              
AS  --- EXEC PROC_ALL_REPORT_STATUS 'SEP 12 2022'              
    EXEC ANGELCOMMODITY.msdb.dbo.sp_update_job    
@job_name='MCX FUTURES AUTO PROCESS SETTLEMENT',@enabled = 1    
select JOB_STATUS='MULTI COMMODITY AUTOMATION JOB IS SUCCESSFULLY ENABLED'

GO
