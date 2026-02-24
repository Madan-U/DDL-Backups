-- Object: PROCEDURE dbo.JOBTEST007
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

CREATE PROC JOBTEST007
AS
INSERT INTO SQLJOBTEST VALUES (GETDATE())

GO
