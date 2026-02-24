-- Object: PROCEDURE dbo.DupRecCheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc DupRecCheck As    
Declare    
@@Membercode as varchar(10),    
@@Mycode As cursor   

 
delete from fttrade where Party_code = 'NSE'
    
Update FTTrade Set branch_id = Party_code    
--Print 'Did Update Branch_id'    
    
Set @@Mycode = cursor for     
    Select MemberCode  from Owner    
    Open @@Mycode    
    Fetch next  from @@Mycode into   @@MemberCode    
Close @@Mycode    
Deallocate @@Mycode    
    
/* Set @@Mycode    
*/    
/*    
insert into trade select * from fttrade where trade_no not in     
      ( select tm.trade_no from Trade tm    
   where convert(varchar,fttrade.sauda_date,106) = convert(varchar,tm.sauda_date,106)    
  and fttrade.trade_no = tm.trade_no    
         and fttrade.order_no = tm.order_no    
 and fttrade.scrip_cd = tm.scrip_cd    
 and fttrade.marketrate = tm.marketrate    
 and fttrade.user_id = tm.user_id     
 and fttrade.sell_buy = tm.sell_buy */    
    
    
--Update fttrade set order_no =Convert(Varchar, convert(Decimal,Order_no),15) where Order_no not like '%MT'    
       
--Print ' Did Update Orderno '     
    
Update Fttrade set party_code = 'INSTITUTE'  where  party_code not in(select party_code from client2)   and partipantcode <> @@MemberCode     
--Print 'Did update Party_code'    
     
insert into trade select * from fttrade where trade_no not in     
      ( select tm.trade_no from Trade tm    
   where convert(varchar,fttrade.sauda_date,106) = convert(varchar,tm.sauda_date,106)    
  and fttrade.trade_no = tm.trade_no    
         and fttrade.order_no = tm.order_no    
 and fttrade.scrip_cd = tm.scrip_cd    
 and fttrade.marketrate = tm.marketrate    
/*  and fttrade.user_id = tm.user_id */    
 and fttrade.sell_buy = tm.sell_buy    
     )    
    
--Print 'Did update Trade'    
    
truncate table fttrade    
    
--Print 'Did truncate table '

GO
