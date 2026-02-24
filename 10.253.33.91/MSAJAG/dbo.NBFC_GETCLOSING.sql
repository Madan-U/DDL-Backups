-- Object: PROCEDURE dbo.NBFC_GETCLOSING
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC NBFC_GETCLOSING (@SAUDA_DATE VARCHAR(11))
AS

SELECT *   
FROM   CLOSING   
WHERE  SYSDATE LIKE @SAUDA_DATE + '%'

GO
