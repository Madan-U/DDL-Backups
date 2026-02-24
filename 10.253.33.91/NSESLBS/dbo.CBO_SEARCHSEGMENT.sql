-- Object: PROCEDURE dbo.CBO_SEARCHSEGMENT
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE CBO_SEARCHSEGMENT
AS
SELECT distinct Segment FROM Pradnya.dbo.multicompany ORDER BY Segment

GO
