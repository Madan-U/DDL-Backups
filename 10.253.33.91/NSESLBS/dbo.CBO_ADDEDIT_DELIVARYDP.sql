-- Object: PROCEDURE dbo.CBO_ADDEDIT_DELIVARYDP
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





CREATE PROCEDURE [dbo].[CBO_ADDEDIT_DELIVARYDP]
(
	@SNo INT,
	@Dptype varchar(4),
 	@Dpid  varchar(16),
	@Dpcltno varchar(16),
	@Description varchar(50),
        @AccountType  varchar(4),
	@Licenceno varchar(10),
	@EXCHANGE varchar(3),
	@SEGMENT varchar(7),
	@FLAG	varchar(1),
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS

	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
 
	IF @FLAG = 'A'	
	BEGIN
		Insert Into DeliveryDp 
		Values (@Dptype,
			@Dpid,
			@Dpcltno,
			@Description,
			@AccountType,
			@Licenceno,
			@EXCHANGE,
			@SEGMENT)	
	END
	
	IF @FLAG = 'E'	
	BEGIN
	Update DeliveryDp Set 
		 DpType =@Dptype,
		 DpId = @Dpid  ,
		DpCltNo =@Dpcltno ,
		Description = @Description,
		AccountType = @AccountType,
		LicenceNo = @Licenceno,
		Exchange = @EXCHANGE,
		Segment = @SEGMENT

		Where SNo = @SNo
		
	END

GO
