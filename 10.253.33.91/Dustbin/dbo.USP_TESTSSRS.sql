-- Object: PROCEDURE dbo.USP_TESTSSRS
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------


CREATE PROC USP_TESTSSRS @DATE DATE
AS
SELECT * FROM BOTEAM WHERE JOINDATE =@DATE

GO
