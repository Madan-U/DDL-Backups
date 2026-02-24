-- Object: PROCEDURE dbo.CBO_GETDELIVERYDP
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure CBO_GETDELIVERYDP
 (
  @dpid     VARCHAR(16),
  @flag	    VARCHAR(1),
 	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
 )
 AS
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
  IF @FLAG <> 'D' AND @FLAG <> 'C' 
	  BEGIN
		 RAISERROR ('Dpid/DpCltNo Flags Not Set Properly', 16, 1)
		RETURN
	END
  IF @flag = 'D'
		BEGIN
			SELECT
				distinct Dpid
		 	FROM
		    DeliveryDp
	  END
  Else IF @flag = 'C'
				BEGIN
         Select
           Distinct DpCltNo 
         From
           DeliveryDp 
         Where 
           Description not Like '%POOL%' And DpId = @dpid
         END

GO
