-- Object: PROCEDURE dbo.CBO_GET_REPORTGROUP
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE   PROCEDURE [dbo].[CBO_GET_REPORTGROUP]
(
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS

	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	SELECT
		Fldgrpname,
                Flddesc,
                Fldreportgrp

	FROM
		TBLREPORTGRP

GO
