-- Object: PROCEDURE dbo.stp_FT_NSE_TradeDetails_BULK
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE        Proc stp_FT_NSE_TradeDetails_BULK    
    
@SaudaDate Varchar(11),    
@ContractNo Varchar(7),    
@Sett_No Varchar(7),    
@Sett_Type Varchar(3),    
@LineNo Varchar(5),    
@BatchNo Varchar(7),    
@FromParty Varchar(10),    
@ToParty Varchar(10),    
@ExchangeCode Varchar(2),    
@Dummy7 varchar(2),    
@Scripcd varchar(20),    
@GroupCode Varchar(10)    
    
AS    
    
Declare    
@@FromParty Varchar(10),    
@@ToParty Varchar(10)    
    
Select @@FromParty =  @FromParty    
Select @@ToParty = @ToParty    
    
If Ltrim(Rtrim(@FromParty)) = '' And Ltrim(Rtrim(@ToParty)) = ''    
Begin    
 Select @@FromParty = Min(Party_Code), @@ToParty = Max(Party_Code)  From Client2    
End    
    
 Select ContractNo, Order_no,     
 Trade_No=Replace(Replace(Replace(Replace(Replace(Replace(Ltrim(Rtrim(Trade_no)),'R',''),'C',''),'A',''),'S',''),'B',''),'T',''),    
 Sauda_Date, TradeQty, dummy1, Party_Code, Sett_No, Sett_Type, Scrip_Cd    
 Into #Settlement From Settlement I     
 Where ContractNo = @ContractNo and      
 Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8) = @SaudaDate     
 and I.Party_Code Between @@FromParty and @@ToParty  and Tradeqty <> 0     
 and Sett_No = @Sett_No      
 and Sett_Type = (Case When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='23'  Then 'N'     
       When @Sett_Type= 'TT' and @ExchangeCode='23'  Then 'W'     
       When @Sett_Type= 'DR' and @ExchangeCode='01'  Then 'D'    
       When @Sett_Type= 'TT' and @ExchangeCode='01'  Then 'C'    
       When @Sett_Type= 'AR' and @ExchangeCode='23'  Then 'A'     
       When @Sett_Type= 'AD' and @ExchangeCode='01'  Then 'AD' Else '' End)    
 And Scrip_Cd like @ScripCd + '%'     
    
 Select ContractNo, Order_No, Trade_No, Sauda_Date, TradeQty = Sum(TradeQty), MarketRate=Convert(Numeric(18,5),Sum(dummy1*TradeQty)/Sum(TradeQty)), Party_Code, Sett_No, Sett_Type, Scrip_Cd    
 Into #Settlement_New From #Settlement    
 Group By ContractNo, Order_No, Trade_No, Sauda_Date,Party_Code, Sett_No, Sett_Type, Scrip_Cd    
    
 Select ContractNo, Order_no,     
 Trade_No=Replace(Replace(Replace(Replace(Replace(Replace(Ltrim(Rtrim(Trade_no)),'R',''),'C',''),'A',''),'S',''),'B',''),'T',''),    
 Sauda_Date, TradeQty, dummy1, Party_Code, Sett_No, Sett_Type, Scrip_Cd    
 Into #ISettlement From ISettlement I     
 Where ContractNo = @ContractNo and      
 Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8) = @SaudaDate     
 and I.Party_Code Between @@FromParty and @@ToParty  and Tradeqty <> 0     
 and Sett_No = @Sett_No      
 and Sett_Type = (Case When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='23'  Then 'N'     
       When @Sett_Type= 'TT' and @ExchangeCode='23'  Then 'W'     
       When @Sett_Type= 'DR' and @ExchangeCode='01'  Then 'D'    
       When @Sett_Type= 'TT' and @ExchangeCode='01'  Then 'C'    
       When @Sett_Type= 'AR' and @ExchangeCode='23'  Then 'A'     
       When @Sett_Type= 'AD' and @ExchangeCode='01'  Then 'AD' Else '' End)    
 And Scrip_Cd like @ScripCd + '%'     
     
 Select ContractNo, Order_No, Trade_No, Sauda_Date, TradeQty = Sum(TradeQty), MarketRate=Convert(Numeric(18,5),Sum(dummy1*TradeQty)/Sum(TradeQty)), Party_Code, Sett_No, Sett_Type, Scrip_Cd    
 Into #ISettlement_New From #ISettlement    
 Group By ContractNo, Order_No, Trade_No, Sauda_Date,Party_Code, Sett_No, Sett_Type, Scrip_Cd    
    
    
 Select    
 trade_no = Replace(Replace(Replace(lTrim(rTrim(Trade_no)),'R',''),'C',''),'A',''),    
 TradeQty = TradeQty,    
 MarketRate=CONVERT(VARCHAR,Convert(Numeric(10,4),I.MarketRate)),    
 TradeTime = Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),    
    order_no = lTrim(rTrim(Order_no))    
    
 From #Isettlement_New I, instClient_Tbl T, Client2 C2, Client1 C1    
    
 Where ContractNo = @ContractNo and      
 Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8) = @SaudaDate     
 and I.Party_Code Between @@FromParty and @@ToParty  and Tradeqty <> 0  and I.Party_Code = T.PartyCode    
 and Sett_No = @Sett_No  and Sett_Type = (Case    
      When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='23'  Then 'N'     
   When @Sett_Type= 'TT' and @ExchangeCode='23'  Then 'W'     
      When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='01'  Then 'D'    
   When @Sett_Type= 'TT' and @ExchangeCode='01'  Then 'C'    
         When @Sett_Type= 'AR' and @ExchangeCode='23'  Then 'A'     
         When @Sett_Type= 'AD' and @ExchangeCode='01'  Then 'AD' Else '' End)    
 And C2.Party_code = I.Party_Code And C2.Dummy6 = 'FT' and C2.Dummy7 = '0'    
 And Scrip_Cd like @ScripCd + '%'     
 And C1.Cl_code = c2.Cl_code    
 and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)     
 UNION ALL    
    
 Select    
 trade_no = Replace(Replace(Replace(lTrim(rTrim(Trade_no)),'R',''),'C',''),'A',''),    
 TradeQty = TradeQty,    
 MarketRate=CONVERT(VARCHAR,Convert(Numeric(10,4),I.MarketRate)),    
 TradeTime = Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),    
 order_no = lTrim(rTrim(Order_no))    
    
 From #settlement_New I, instClient_Tbl T, Client2 C2, Client1 C1    
    
 Where ContractNo = @ContractNo and      
 Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8) = @SaudaDate     
 and I.Party_Code Between @@FromParty and @@ToParty  and Tradeqty <> 0  and I.Party_Code = T.PartyCode    
 and Sett_No = @Sett_No  and Sett_Type = (Case    
          When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='23'  Then 'N'     
   When @Sett_Type= 'TT' and @ExchangeCode='23'  Then 'W'     
          When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='01'  Then 'D'    
   When @Sett_Type= 'TT' and @ExchangeCode='01'  Then 'C'    
          When @Sett_Type= 'AR' and @ExchangeCode='23'  Then 'A'     
          When @Sett_Type= 'AD' and @ExchangeCode='01'  Then 'AD' Else '' End)    
 And C2.Party_code = I.Party_Code And C2.Dummy6 = 'FT' and C2.Dummy7 = '0'    
 And ltrim(Rtrim(Scrip_Cd)) = ltrim(Rtrim(@ScripCd))      
 And C1.Cl_code = c2.Cl_code    
 and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)     
    
/*****************************************************************************************/

GO
