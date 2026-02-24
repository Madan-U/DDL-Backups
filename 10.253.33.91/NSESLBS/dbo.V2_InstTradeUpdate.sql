-- Object: PROCEDURE dbo.V2_InstTradeUpdate
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc V2_InstTradeUpdate         
(        
      @party_code varchar(10),        
      @scrip_cd varchar(10),         
      @series varchar(3),         
      @MktRate money,        
      @consolidate varchar(1),      
      @SellBuy varchar(1)        
)        
        
As         
        
        
      if @consolidate = 'Y'         
      Begin        
            Begin tran        
                  UPDATE         
                        Trade         
                        SET MarketRate = @MktRate,         
                        Dummy2 = 1         
  FROM CLIENT1 C1, CLIENT2 C2  
                  WHERE C2.Party_Code = @party_code         
  AND C1.CL_CODE = C2.CL_CODE  
  AND TRADE.PARTY_CODE = C2.PARTY_CODE  
  AND C1.CL_TYPE = 'INS'
                        AND scrip_cd = @scrip_cd         
                        AND series = @series         
      AND Sell_Buy like @SellBuy + '%'      
            Commit Tran        
      End        
              
      if @consolidate = 'N'         
      Begin        
            Begin tran        
                  UPDATE         
                        Trade         
                        SET MarketRate = Dummy1,         
                        Dummy2 = 0         
                  WHERE Party_Code = @party_code         
                        AND scrip_cd = @scrip_cd         
                        AND series = @series         
      AND Sell_Buy like @SellBuy + '%'      
            Commit Tran        
      End

GO
