-- Object: FUNCTION citrus_usr.TRIMZERO
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION [citrus_usr].[TRIMZERO](@LeadingZeros VARCHAR(100))
RETURNS VARCHAR(100)
AS
BEGIN 
RETURN CAST(CAST(@LeadingZeros AS NUMERIC(18,0)) AS VARCHAR(100))
END

GO
