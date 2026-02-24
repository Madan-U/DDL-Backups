-- Object: PROCEDURE dbo.Aucratevalidation
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure Aucratevalidation    
@sett_no int,    
@sett_type char(1),  
@setterr int output    
as     
    
---declare @@setterr varchar(2)    
begin    
    
    
 Select distinct Scrip_Cd,Party_Code,AuctionPart,                 
 Sum(Case when sell_buy=1 then TradeQTY else 0 end) As BuyQty,                
 Case when sell_buy=1 then Marketrate else 0 end As BuyMktRate,                
 Sum(Case when sell_buy=2 then TradeQTY else 0 end) as SellQty,                
 Case when sell_buy=2 then Marketrate else 0 end as SellMktRate,                
 Round(Sum(Case Sell_Buy When 2 Then (TradeQty*MarketRate) Else -(TradeQty*MarketRate) End),2) As Answer                
  
-- count(*),Scrip_cd,    
--case when sell_buy=1 then (tradeqty*marketrate) else -(tradeqty*marketrate) end as PradAmt,    
--case when sell_buy=1 then (tradeqty*dummy1) else -(tradeqty*Dummy1) end as ExchAmt     
from settlement     
where     
sett_no=@sett_no    
and auctionpart in ('FC','FS','N')    
and sett_type=@sett_type    
group by scrip_cd,tradeqty,dummy1,marketrate,sell_buy ,party_code,auctionpart  
having sum((case when sell_buy=1 then (tradeqty*marketrate) else -(tradeqty*marketrate)end) -(case when sell_buy=1 then (tradeqty*dummy1) else -(tradeqty*Dummy1)end))<>0    
    
if @@rowcount=0     
    
select @setterr=0    
    
else    
    
select @setterr=1    
    
end

GO
