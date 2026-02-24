-- Object: PROCEDURE dbo.SSRS_LEDGER_RPT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[SSRS_LEDGER_RPT]  
 (  
 @FROMDATE varchar(20),  
 @TODATE varchar(20)  
 )  
 AS BEGIN  
   EXEC ABVSINSURANCEBO.msdb.DBO.SP_START_JOB 'LED_SEC_HOLD_CLIENT'     
 WAITFOR DELAY '00:0:45';    
  
 
select party_code,ledger from [csokyc-6].general.dbo.RMS_DtClFi_summ     
where rms_date>=CONVERT(VARCHAR,@FROMDATE,103)    
and rms_date<=CONVERT(VARCHAR,@TODATE,103) + ' 23:59'      
and party_code in(select party_code from SSIS_SEC_DATA)    
  
END

GO
