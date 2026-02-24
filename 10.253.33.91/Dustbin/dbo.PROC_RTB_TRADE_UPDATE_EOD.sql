-- Object: PROCEDURE dbo.PROC_RTB_TRADE_UPDATE_EOD
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

CREATE PROCEDURE [dbo].[PROC_RTB_TRADE_UPDATE_EOD] (@RUNDATE VARCHAR(11),@REPORT VARCHAR(10))              
              
AS  --- EXEC PROC_ALL_REPORT_STATUS 'SEP 12 2022'    

BEGIN
SET @RUNDATE= CONVERT(varchar, getdate(), 23)

Update MSAJAG..V2_Business_Process set import_Trade='1',  Billing='1', Vbb='1', stt='1' where Business_Date=@RUNDATE and Sett_type in ('M', 'N', 'W', 'Z')

select JOB_STATUS='TRADE,BILLING,VBB,STT PROCESSES FLAG ARE SUCCESSFULLY UPDATED' 

END

GO
