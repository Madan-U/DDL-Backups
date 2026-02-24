-- Object: PROCEDURE dbo.Duprecsettcheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

 CREATE Proc Duprecsettcheck As        
    
Declare @Sauda_Date Varchar(11)        
      
Select Top 1 @Sauda_Date = Left(Convert(Varchar,sauda_date,109),11) From Trade    
      
Select   Trade_no,       
        Order_no,       
        Scrip_cd,       
        Series,       
        Sell_buy,       
        Sauda_date         
Into     #sett       
From    Settlement         
Where  Sauda_Date Between @Sauda_Date And @Sauda_Date + ' 23:59:59'  
      
--select @@rowcount        
If (select @@rowcount) > 0         
Begin         
     Delete Trade From Trade, #sett S Where           
     Trade.sauda_date = S.sauda_date         
     And Replace(replace(replace(replace(replace(replace(replace(replace(replace(trade.trade_no,'r',''),'e',''),'a',''),'x',''),'b',''),'t',''),'s',''),'i',''),'u','')           
     = Replace(replace(replace(replace(replace(replace(replace(replace(replace(s.trade_no,'r',''),'e',''),'a',''),'x',''),'b',''),'t',''),'s',''),'i',''),'u','')          
     And Trade.order_no = S.order_no           
     And Trade.scrip_cd = S.scrip_cd          
     And Trade.series = S.series          
     And Trade.sell_buy = S.sell_buy          
     --and Trade.markettype = S.markettype          
     --and Trade.marketrate = S.dummy1           
End        
        
Select Trade_no, Order_no, Scrip_cd, Series, Sell_buy, Sauda_date         
Into #isett From Isettlement         
Where Sauda_Date Like @Sauda_Date + '%'         
--select @@rowcount        
If (select @@rowcount) > 0         
Begin        
     Delete Trade From Trade, #isett S Where           
     Trade.sauda_date = S.sauda_date        
     And Replace(replace(replace(replace(replace(replace(replace(replace(replace(trade.trade_no,'r',''),'e',''),'a',''),'x',''),'b',''),'t',''),'s',''),'i',''),'u','')           
     = Replace(replace(replace(replace(replace(replace(replace(replace(replace(s.trade_no,'r',''),'e',''),'a',''),'x',''),'b',''),'t',''),'s',''),'i',''),'u','')          
     And Trade.order_no = S.order_no           
     And Trade.scrip_cd = S.scrip_cd          
     And Trade.series = S.series          
     And Trade.sell_buy = S.sell_buy          
     --and Trade.markettype = S.markettype          
     --and Trade.marketrate = S.dummy1          
End

GO
