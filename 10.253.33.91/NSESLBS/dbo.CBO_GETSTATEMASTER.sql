-- Object: PROCEDURE dbo.CBO_GETSTATEMASTER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE   PROCEDURE [dbo].[CBO_GETSTATEMASTER]
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
		SrNo,
State,
TrdStampDuty,
DelStampDuty,
ProStampDuty,
Min_Multiplier,
For_Turnover,
Maximum_Limit,
INCL_IN_NONMAH
	FROM
		State_Master

GO
