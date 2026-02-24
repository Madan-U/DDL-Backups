-- Object: PROCEDURE dbo.CheckLedgerDrCr
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE proc CheckLedgerDrCr
AS
SELECT SUM(vamt) AS totalamount, drcr
FROM ledger
GROUP BY drcr

GO
