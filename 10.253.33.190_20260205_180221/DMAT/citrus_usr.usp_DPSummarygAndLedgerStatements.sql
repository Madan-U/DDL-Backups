-- Object: PROCEDURE citrus_usr.usp_DPSummarygAndLedgerStatements
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[usp_DPSummarygAndLedgerStatements]
@FromDate varchar(11),
@ToDate varchar(11)
AS
BEGIN
	 exec citrus_usr.PR_GET_TXT_FILEGEN_FORANGELID 'SUMMARY','12033200','','',@FromDate,@ToDate
				
        exec citrus_usr.PR_GET_TXT_FILEGEN_FORANGELID 'ledger','12033200','','',@FromDate,@ToDate				

END

--	exec DMAT.citrus_usr.usp_DPSummarygAndLedgerStatements 'Feb 01 2016','Feb 29 2016'

GO
