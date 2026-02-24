-- Object: PROCEDURE dbo.CBO_SEARCHEXCHANGE
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE CBO_SEARCHEXCHANGE
AS
SELECT distinct Exchange FROM Pradnya.dbo.multicompany ORDER BY Exchange desc

GO
