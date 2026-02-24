-- Object: PROCEDURE dbo.acc_checkLedger
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE proc acc_checkLedger
AS
SELECT SUM(case when upper(drcr) = 'D' then vamt else -vamt end) 
FROM ledger

GO
