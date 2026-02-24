-- Object: PROCEDURE citrus_usr.usp_DPHoldingAndTransactionStatements
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE proc usp_DPHoldingAndTransactionStatements
@FromDate varchar(11),
@ToDate varchar(11)
AS
BEGIN
		exec citrus_usr.PR_GET_TXT_FILEGEN_FORANGELID 'HOLDING','12033200','','',@FromDate,@ToDate
				
        exec citrus_usr.PR_GET_TXT_FILEGEN_FORANGELID 'TRX','12033200','','',@FromDate,@ToDate				

END

--	exec DMAT.DMAT.citrus_usr.usp_DPHoldingAndTransactionStatements 'Feb 01 2016','Feb 29 2016'

GO
