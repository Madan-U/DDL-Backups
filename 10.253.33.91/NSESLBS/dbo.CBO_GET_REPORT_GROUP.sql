-- Object: PROCEDURE dbo.CBO_GET_REPORT_GROUP
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE     PROCEDURE [dbo].[CBO_GET_REPORT_GROUP]
(
	@BANKID VARCHAR(15) = '',
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
                Fldreportgrp,
		Fldmenugrp
	FROM
       Tblreportgrp

GO
