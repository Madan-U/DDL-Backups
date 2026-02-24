-- Object: PROCEDURE dbo.CBO_ADDEDIT_DELIVERYSLIP
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------










CREATE   PROCEDURE [dbo].[CBO_ADDEDIT_DELIVERYSLIP]
(
	
        @Dptype varchar(10),
	@Sliptype varchar(2),
	@Slipno int,
	@Slflag int,
	@Checksum varchar(5),
	@Dpid  varchar(8), 
	@Cltdpid varchar(16),
	@SLIPSERIES varchar(6),
	@EDITFLAG varchar(10),	
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS
	if @EDITFLAG='Update'
	begin
	update DelSlipMst set SlFlag =@Slflag , CheckSum =@Checksum , SlipSeries = @SLIPSERIES
	where dptype= @Dptype and sliptype =@Sliptype and SlipNo =@Slipno  And DpId =@Dpid  And CltDpId = @Cltdpid
        end

	if @EDITFLAG='Insert'
	begin
	insert into DelSlipMst values (@Dptype,@Sliptype,@Slipno,@Slflag ,@Checksum,@Dpid,@Cltdpid,@SLIPSERIES)
        
	end

GO
