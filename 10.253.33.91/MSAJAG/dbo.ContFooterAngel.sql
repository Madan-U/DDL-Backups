-- Object: PROCEDURE dbo.ContFooterAngel
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE proc ContFooterAngel (@Sdate varchar(12), @Sett_Type varchar(2), @ContNo varchar(7), @sell_buy varchar(1),@Sett_no Varchar(10),@Party_code Varchar(15)) as
 Select
 Qty =isnull( sum(tradeqty),0), Amount =isnull( sum(amount),0), 
 Brokerage =isnull( sum(tradeqty*NBrokApp),0), Ser = isnull(sum(Nsertax),0), 
 sell_buy , Left(Convert(Varchar,Sauda_date,109),11) 
 SETT_TYPE, contractno,
TotalTrading = isnull(sum(tradeqty*brokapplied),0),
TotalDelivery = isnull(sum(tradeqty*(NBrokApp-Brokapplied)),0)   from settlement where 
 sett_type = @Sett_type and sauda_date like  @sdate + '%' 
 and sell_buy = @Sell_buy
 and convert(int,contractno) = @Contno
 And sett_no = @sett_no
 And Party_code = @Party_code
 group by SETT_TYPE,contractno,sell_buy,Sett_no,Left(Convert(Varchar,Sauda_date,109),11) ,Party_code

GO
