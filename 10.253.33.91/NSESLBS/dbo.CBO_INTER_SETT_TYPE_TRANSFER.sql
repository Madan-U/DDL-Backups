-- Object: PROCEDURE dbo.CBO_INTER_SETT_TYPE_TRANSFER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



--exec CBO_INTER_SETT_TYPE_TRANSFER 'a','BROKER','BROKER'
CREATE     PROCEDURE CBO_INTER_SETT_TYPE_TRANSFER
	     --@FLAG   VARCHAR(1),
        --@Sett_no VARCHAR(7),
        @Sett_Type VARCHAR(2),
        @STATUSID VARCHAR(25),
	     @STATUSNAME VARCHAR(25) 
AS
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
  select distinct sett_No from DeliveryClt where Sett_Type = @sett_type
  order by sett_No

GO
