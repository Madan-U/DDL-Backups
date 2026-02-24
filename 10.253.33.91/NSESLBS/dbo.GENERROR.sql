-- Object: PROCEDURE dbo.GENERROR
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC GENERROR
	@ERRMSG VARCHAR(500) = 'Error Generated'
AS
	RAISERROR (@ERRMSG, 16, 1)

GO
