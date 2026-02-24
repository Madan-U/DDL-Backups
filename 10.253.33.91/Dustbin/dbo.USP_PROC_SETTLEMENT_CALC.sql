-- Object: PROCEDURE dbo.USP_PROC_SETTLEMENT_CALC
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

CREATE PROCEDURE [dbo].[USP_PROC_SETTLEMENT_CALC] (@RUNDATE VARCHAR(11),@REPORT VARCHAR(10))                  
                  
AS  --- EXEC PROC_ALL_REPORT_STATUS 'SEP 12 2022'                  
 Declare @sett_no varchar(7),@date varchar(20)  
Select @sett_no=Sett_No from MSAJAG..sett_mst where start_date =Convert(Varchar(11),getdate(),120) and sett_type='M'  
select @date=Convert(Varchar(11),getdate(),120)  
  
Insert into MSAJAG.DBO.V2_Process_Status_Log values ('NSE', 'CAPITAL', @date, @sett_no, 'M', 'BILLING', '', '0', '1900-01-01 00:00:00.000', '', '')  
Insert into MSAJAG.DBO.V2_Process_Status_Log values ('NSE', 'CAPITAL', @date, @sett_no, 'M', 'CONTRACTPOP', '', '0', '1900-01-01 00:00:00.000', '', '')  
Insert into MSAJAG.DBO.V2_Process_Status_Log values ('NSE', 'CAPITAL', @date, @sett_no, 'M', 'POSTING', '', '0', '1900-01-01 00:00:00.000', '', '')  
Insert into MSAJAG.DBO.V2_Process_Status_Log values ('NSE', 'CAPITAL', @date, @sett_no, 'M', 'STT', '', '0', '1900-01-01 00:00:00.000', '', '')  
Insert into MSAJAG.DBO.V2_Process_Status_Log values ('NSE', 'CAPITAL', @date, @sett_no, 'M', 'VALAN', '', '0', '1900-01-01 00:00:00.000', '', '')  
Insert into MSAJAG.DBO.V2_Process_Status_Log values ('NSE', 'CAPITAL', @date, @sett_no, 'M', 'VBB', '', '0', '1900-01-01 00:00:00.000', '', '')  
  
Insert into MSAJAG.DBO.V2_Process_Status_Log values ('NSE', 'CAPITAL', @date, @sett_no, 'Z', 'BILLING', '', '0', '1900-01-01 00:00:00.000', '', '')  
Insert into MSAJAG.DBO.V2_Process_Status_Log values ('NSE', 'CAPITAL', @date, @sett_no, 'Z', 'CONTRACTPOP', '', '0', '1900-01-01 00:00:00.000', '', '')  
Insert into MSAJAG.DBO.V2_Process_Status_Log values ('NSE', 'CAPITAL', @date, @sett_no, 'Z', 'POSTING', '', '0', '1900-01-01 00:00:00.000', '', '')  
Insert into MSAJAG.DBO.V2_Process_Status_Log values ('NSE', 'CAPITAL', @date, @sett_no, 'Z', 'STT', '', '0', '1900-01-01 00:00:00.000', '', '')  
Insert into MSAJAG.DBO.V2_Process_Status_Log values ('NSE', 'CAPITAL', @date, @sett_no, 'Z', 'VALAN', '', '0', '1900-01-01 00:00:00.000', '', '')  
Insert into MSAJAG.DBO.V2_Process_Status_Log values ('NSE', 'CAPITAL', @date, @sett_no, 'Z', 'VBB', '', '0', '1900-01-01 00:00:00.000', '', '')   
  
select Status='Settlement Calender is successfully updated'

GO
