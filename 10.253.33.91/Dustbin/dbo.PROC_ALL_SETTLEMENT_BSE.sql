-- Object: PROCEDURE dbo.PROC_ALL_SETTLEMENT_BSE
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

CREATE PROCEDURE [dbo].[PROC_ALL_SETTLEMENT_BSE] (@RUNDATE VARCHAR(11),@REPORT VARCHAR(10))        
        
AS  --- EXEC PROC_ALL_REPORT_STATUS 'SEP 12 2022'        
    select count(1) AS BSE_CAPITAL_SETTLEMENT_COUNT from ANGELBSECM.BSEDB_AB.DBO.settlement with (nolock) where Sauda_Date >=CAST(GETDATE() AS date)

GO
