-- Object: PROCEDURE dbo.proc_Auction_Turnovertax_process
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

Create ProC proc_Auction_Turnovertax_process (@sett_no varchar(11),@sett_type varchar(2))
As
Begin
Update S Set turn_tax=Round((Tradeqty*MarketRate*0.00297/100),4),NSerTax=(Round((Tradeqty*MarketRate*0.00297/100),4)*18/100),
Service_tax=(Round((Tradeqty*MarketRate*0.00297/100),4)*18/100)
from settlement S where sett_no = @sett_no and sett_type=@sett_type   And AuctionPart like 'F%' and MarketRate <>0
END

GO
