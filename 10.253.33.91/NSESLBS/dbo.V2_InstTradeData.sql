-- Object: PROCEDURE dbo.V2_InstTradeData
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc V2_InstTradeData            
(            
      @fromparty varchar(10),             
      @toparty varchar(10),            
      @fromscrip varchar(10),             
      @toscrip varchar(10),        
      @type varchar(2),  
      @clienttype varchar(3)              
)            
            
As            
            
/*===============================================================================            
      Exec V2_InstTradeData             
            @fromparty = '0000000000',             
            @toparty = 'ZZZZZZZZZZ',            
            @fromscrip = '0000000000',             
            @toscrip = 'ZZZZZZZZZZ',    
     	    @type = ''              
===============================================================================*/            
            
      SELECT             
            T.Party_Code,             
            Party_Name = Isnull(C1.Short_Name,'MISSING CLIENT'),             
            Sauda_Date = left(Sauda_Date,11),             
            T.Scrip_Cd,             
            T.Series,             
            Sell_Buy=case sell_buy When '2' then 'S' else 'P' end ,             
            TradeQty = Sum(T.TradeQty),             
            MarketRate = Round(Sum(T.TradeQty * T.MarketRate) / Sum(T.TradeQty),4),             
            AvgRate = Round(Sum(T.TradeQty * T.Dummy1) / Sum(T.TradeQty), isnull(convert(int,I.Marketrate),4)),             
            ConsolFlag = max(T.Dummy2),   
            Long_Name = Isnull(C1.Long_Name,'MISSING CLIENT')
      FROM Trade T WITH(NoLock)             
      LEFT OUTER JOIN             
            Client1 C1 WITH(NoLock)             
            ON             
            (            
                  T.Party_Code = C1.Cl_Code             
            )             
      LEFT OUTER JOIN             
            InstClient_Tbl I With(NoLock)  
            ON             
            (            
                  I.PartyCode = C1.Cl_Code             
            )             
      WHERE T.Party_Code BETWEEN @fromparty AND @toparty             
            AND T.Scrip_cd BETWEEN @fromscrip AND @toscrip             
            AND T.Dummy2 like @type + '%'        
	    AND IsNull(C1.Cl_type,'') like @clienttype + '%'
      GROUP BY Scrip_Cd,             
            series,             
            Sell_Buy,             
            Party_Code,             
            left(Sauda_Date,11),             
            C1.Short_Name,             
            C1.Long_Name,   
            I.MarketRate    
      ORDER BY Party_Code,             
            Scrip_Cd,             
            Series

GO
