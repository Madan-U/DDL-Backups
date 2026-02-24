-- Object: PROCEDURE dbo.TradeRecCheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC TradeRecCheck
as

UPDATE FTTRADE SET PARTIPANTCODE = MEMBERCODE 
FROM OWNER
WHERE ISNULL(PARTIPANTCODE, '') = ''

GO
