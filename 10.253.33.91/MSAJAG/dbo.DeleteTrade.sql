-- Object: PROCEDURE dbo.DeleteTrade
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


create proc DeleteTrade
@tradeno varchar(14),
@orderno varchar (16),
@partycode varchar(10),
@scripcd varchar(10),
@series char(2),
@sellbuy int,
@qty int,
@rate money,
@setttype varchar(3),
@settno varchar(7),
@saudadate smalldatetime, 
@flag int
as
if @flag =1 
begin
insert into deltrade select * from settlement where
trade_no =@tradeno and
order_no=@orderno and 
party_code = @partycode and
scrip_cd =@scripcd and 
series=@series and 
sell_buy=@sellbuy and 
tradeqty=@qty and
marketrate=@rate and
sett_type =@setttype and
sett_no =@settno and
convert(varchar,sauda_date,106) =@saudadate

delete from settlement where
trade_no =@tradeno and
order_no=@orderno and 
party_code = @partycode and
scrip_cd =@scripcd and 
series=@series and 
sell_buy=@sellbuy and 
tradeqty=@qty and
marketrate=@rate and
sett_type =@setttype and
sett_no =@settno and
convert(varchar,sauda_date,106) =@saudadate
end 
if @flag =2
begin
insert into deltrade select * from history where
trade_no =@tradeno and
order_no=@orderno and 
party_code = @partycode and
scrip_cd =@scripcd and 
series=@series and 
sell_buy=@sellbuy and 
tradeqty=@qty and
marketrate=@rate and
sett_type =@setttype and
sett_no =@settno and
convert(varchar,sauda_date,106) =@saudadate


delete from history where
trade_no =@tradeno and
order_no=@orderno and 
party_code = @partycode and
scrip_cd =@scripcd and 
series=@series and 
sell_buy=@sellbuy and 
tradeqty=@qty and
marketrate=@rate and
sett_type =@setttype and
sett_no =@settno and
convert(varchar,sauda_date,106) =@saudadate
end

GO
