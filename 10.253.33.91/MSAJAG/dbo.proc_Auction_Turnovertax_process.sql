-- Object: PROCEDURE dbo.proc_Auction_Turnovertax_process
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE ProC proc_Auction_Turnovertax_process (@sett_no varchar(11),@sett_type varchar(2))  
As  
Begin  
DEclare @trdate datetime,@Stax decimal(18,4)
Select @trdate=Start_date from sett_mst where  sett_no=@sett_no and Sett_type =@sett_type

select @Stax=service_tax from globals  where  @trdate between year_start_dt and year_end_dt

Update S Set turn_tax=Round((Tradeqty*MarketRate*0.00297/100),4),NSerTax=(Round((Tradeqty*MarketRate*0.00297/100),4)*@Stax/100),  
Service_tax=(Round((Tradeqty*MarketRate*0.00297/100),4)*@Stax/100)  
from settlement S where sett_no = @sett_no and sett_type=@sett_type   And AuctionPart in ('FA','FS') and MarketRate <>0  
END

GO
