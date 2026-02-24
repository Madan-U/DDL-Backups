-- Object: PROCEDURE dbo.rpt_NSEFO_SSB_TEMP
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE proc [dbo].[rpt_NSEFO_SSB_TEMP]    

(  
@party_code varchar(10),   
@Sauda_date varchar(11)
)   
  
AS      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
Select  f.order_no,  
f.sell_buy as sbc,   
convert(varchar,f.activitytime,101) as Activitytime,     
convert(varchar,f.activitytime,103) as ActivitytimeDD,    
f.trade_no,   
isnull(f.inst_type,'') inst_type ,      
isnull(f.symbol,'') symbol,   
convert(varchar,f.expirydate,101) as expirydate,     
convert(varchar,f.expirydate,103) as expirydateDD,     
left(convert(varchar,f.expirydate,109),11) as expirydate1,   
f.strike_price,      
(Case When isnull(f.option_type,'') = '' Then '' Else F.Option_Type End ) option_type,      
f.sec_name,f.sell_buy,   
buyqty = (case when f.sell_buy = '1' then f.tradeqty else 0 end),       
sellqty = (case when f.sell_buy = '2' then f.tradeqty else 0 end),   
f.price,   
f.party_code,      
s2.c_Regular_lot,   
f.participantcode,   
c1.long_name       
  
From FoTrade f, client1 c1, client2 c2, foscrip2 s2   
  
Where f.Activitytime like @Sauda_date +'%'   
and f.party_code = @party_code      
and f.inst_type = s2.inst_type   
and f.option_type=s2.option_type   
and f.symbol=s2.symbol   
and f.expirydate = s2.expirydate      
and f.strike_price = s2.strike_price   
and f.party_code = c2.party_code   
and c1.cl_code = c2.cl_code  
  
ORDER BY f.sec_name,f.Sell_Buy,f.order_no,f.trade_no

GO
