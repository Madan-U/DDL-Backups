-- Object: PROCEDURE dbo.V2_InstTradeData_Main
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc V2_InstTradeData_Main                  
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
      Exec  V2_InstTradeData_main                   
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
            PQty = Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End),       
            SQty = Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End),       
            PVal = Sum(Case When Sell_Buy = 1 Then TradeQty * Dummy1 Else 0 End),       
            SVal = Sum(Case When Sell_Buy = 2 Then TradeQty * Dummy1 Else 0 End),       
            ConsolFlag = min(Dummy2),       
            Long_Name = Isnull(C1.Long_Name,'MISSING CLIENT'),  
     Cl_type = C1.Cl_type    
      FROM Trade T WITH(NoLock)                   
      LEFT OUTER JOIN                   
            Client1 C1 WITH(NoLock)                   
            ON                   
            (                  
                  T.Party_Code = C1.Cl_Code                   
            )                   
      WHERE T.Party_Code BETWEEN @fromparty AND @toparty                   
            AND T.Scrip_cd BETWEEN @fromscrip AND @toscrip                   
            AND T.Dummy2 like @type + '%'      
	    AND IsNull(C1.Cl_type,'') like @clienttype + '%'            
      GROUP BY T.Party_Code,       
            C1.Short_Name,       
            C1.Long_Name,       
            left(Sauda_Date,11),  
     Cl_type    
      ORDER BY Party_Code

GO
