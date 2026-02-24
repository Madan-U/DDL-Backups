-- Object: PROCEDURE dbo.CLS_USP_VIRTUAL_MIS_LEDGER_REPORT
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC [dbo].[CLS_USP_VIRTUAL_MIS_LEDGER_REPORT]
(
  @FROM_DATE VARCHAR(11),                    
  @TO_DATE VARCHAR(11),                    
  @FROM_PARTY VARCHAR(10),                    
  @TO_PARTY VARCHAR(10),
  @STATUSID VARCHAR(10) = '',        
  @STATUSNAME VARCHAR(10) = ''
)
AS
BEGIN
EXEC USP_VIRTUAL_MIS_LEDGER_REPORT @FROM_DATE,@TO_DATE,@FROM_PARTY,@TO_PARTY,'',''
END

GO
