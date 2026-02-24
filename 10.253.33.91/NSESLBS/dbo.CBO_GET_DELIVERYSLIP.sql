-- Object: PROCEDURE dbo.CBO_GET_DELIVERYSLIP
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------








CREATE PROCEDURE [dbo].[CBO_GET_DELIVERYSLIP]
(
	
        @STRGET VARCHAR(100)='',
	@FLAG VARCHAR(25),
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS

declare 
	@dptype varchar(20),
	@dpid varchar(25),
	@cldpno varchar(25),
	@slptype varchar(25),
	@FromSlip int,
	@ToSlip int,
	@series varchar(25)
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END

--SET @FTABLE = LTRIM(RTRIM(.dbo.PIECE(@FIXEDITEMS, ',', 1)))
	IF  @FLAG='dpid'
	BEGIN 
	Select  distinct Dpid ,'' Dptype ,'' Dpcltno ,'' Description ,'' AccountType,'' Licenceno,''  EXCHANGE,'' SEGMENT  From DeliveryDp   Where DpType = @STRGET	
	END
	

	IF  @FLAG='ClientId'
	begin
	SET @dptype = LTRIM(RTRIM(.dbo.PIECE(@STRGET, '|', 1)))
	SET @dpid = LTRIM(RTRIM(.dbo.PIECE(@STRGET, '|', 2)))
	Select distinct '' Dpid ,'' Dptype , Dpcltno ,'' Description ,'' AccountType,'' Licenceno,''  EXCHANGE,'' SEGMENT From DeliveryDp Where DpType = @dptype And DpId = @dpid
	end
	
	IF  @FLAG='OK'
	begin
		SET @dptype = LTRIM(RTRIM(.dbo.PIECE(@STRGET, '|', 1)))
		SET @dpid = LTRIM(RTRIM(.dbo.PIECE(@STRGET, '|', 2)))
		SET @cldpno = LTRIM(RTRIM(.dbo.PIECE(@STRGET, '|', 3)))
		SET @slptype = LTRIM(RTRIM(.dbo.PIECE(@STRGET, '|', 4)))
		SET @FromSlip = convert(int,LTRIM(RTRIM(.dbo.PIECE(@STRGET, '|', 5))))
		SET @ToSlip = convert(int,LTRIM(RTRIM(.dbo.PIECE(@STRGET, '|', 6))))
		SET @series = LTRIM(RTRIM(.dbo.PIECE(@STRGET, '|', 7)))
	
	
	
	Select * From DelSlipMst Where SlipNo between @FromSlip And @ToSlip And SlipType Like @slptype And DpType = @dptype And DpId = @dpid And CltDpId = @cldpno Order By SlipNo
	end

GO
