-- Object: PROCEDURE dbo.stp_FT_NSE_TradeSummary_BULK
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE   Proc stp_FT_NSE_TradeSummary_BULK  
  
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
@@ToParty Varchar(10),  
@Order_No Varchar(16),  
@Trade_No Varchar(16),  
@TradeTime Varchar(15)  
  
Select @@FromParty =  @FromParty  
Select @@ToParty = @ToParty  
  
If Ltrim(Rtrim(@FromParty)) = '' And Ltrim(Rtrim(@ToParty)) = ''  
Begin  
 Select @@FromParty = Min(Party_Code), @@ToParty = Max(Party_Code)  From Client2  
End  
  
    Select @Order_no =  Right('0000000000000000' + Ltrim(Rtrim(Min(Order_no))),16) ,   
 @Trade_No = Right('0000000000000000' +Replace(Replace(Replace(Replace(Replace(Replace(Ltrim(Rtrim(min(Trade_no))),'R',''),'C',''),'A',''),'S',''),'B',''),'T',''),16),  
    @TradeTime = Replace(Replace(Convert(Varchar,Min(Sauda_date),120),'-',''),':','')  
 From settlement I  
 Where ContractNo = @ContractNo and  Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8) = @SaudaDate   
 and I.Party_Code Between @FromParty and @ToParty  and Tradeqty <> 0    
 and Sett_No = @Sett_No  and Sett_Type = (Case When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='23'  Then 'N'   
                                 When @Sett_Type= 'TT' and @ExchangeCode='23'  Then 'W'   
                                            When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='01'  Then 'D'  
                                 When @Sett_Type= 'TT' and @ExchangeCode='01'  Then 'C'  
                                            When @Sett_Type= 'AR' and @ExchangeCode='23'  Then 'A'   
                                            When @Sett_Type= 'AD' and @ExchangeCode='01'  Then 'AD' Else '' End)  
 And ltrim(Rtrim(Scrip_Cd)) = ltrim(Rtrim(@ScripCd))    
      
 Select ContractNo, Order_no =@Order_no,   
 Trade_No= @Trade_No,  
 Sauda_Date=@TradeTime,  
 TradeQty = Convert(varChar(12),Sum(TradeQty)),  
 MarketRate = Convert(Numeric(10,5),(Sum(Round(dummy1,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))),  
  I.Party_Code, Sett_No, Sett_Type, Scrip_Cd  
 Into #Settlement_New From settlement I, instClient_Tbl T   
 Where ContractNo = @ContractNo and    
 Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8) = @SaudaDate   
 and I.Party_Code Between @@FromParty and @@ToParty  and Tradeqty <> 0   and I.Party_Code = T.PartyCode  
 and Sett_No = @Sett_No    
 and Sett_Type = (Case When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='23'  Then 'N'   
                            When @Sett_Type= 'TT' and @ExchangeCode='23'  Then 'W'   
                                       When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='01'  Then 'D'  
                            When @Sett_Type= 'TT' and @ExchangeCode='01'  Then 'C'  
                                        When @Sett_Type= 'AR' and @ExchangeCode='23'  Then 'A'   
                                        When @Sett_Type= 'AD' and @ExchangeCode='01'  Then 'AD' Else '' End)  
 And ltrim(Rtrim(Scrip_Cd)) = ltrim(Rtrim(@ScripCd))    
 Group By ContractNo, I.Party_Code, Sett_No, Sett_Type, Scrip_Cd  
  
 Select @Order_no =  Right('0000000000000000' + Ltrim(Rtrim(Min(Order_no))),16) ,   
 @Trade_No = Right('0000000000000000' +Replace(Replace(Replace(Replace(Replace(Replace(Ltrim(Rtrim(min(Trade_no))),'R',''),'C',''),'A',''),'S',''),'B',''),'T',''),16),  
    @TradeTime = Replace(Replace(Convert(Varchar,Min(Sauda_date),120),'-',''),':','')  
 From Isettlement I  
 Where ContractNo = @ContractNo and  Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8) = @SaudaDate   
 and I.Party_Code Between @FromParty and @ToParty  and Tradeqty <> 0    
 and Sett_No = @Sett_No  and Sett_Type = (Case When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='23'  Then 'N'   
         When @Sett_Type= 'TT' and @ExchangeCode='23'  Then 'W'   
                                            When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='01'  Then 'D'  
                                 When @Sett_Type= 'TT' and @ExchangeCode='01'  Then 'C'  
                                            When @Sett_Type= 'AR' and @ExchangeCode='23'  Then 'A'   
                                            When @Sett_Type= 'AD' and @ExchangeCode='01'  Then 'AD' Else '' End)  
 And ltrim(Rtrim(Scrip_Cd)) = ltrim(Rtrim(@ScripCd))    
  
 Select ContractNo, Order_no =@Order_no,   
 Trade_No= @Trade_No,  
 Sauda_Date=@TradeTime,  
 TradeQty = Convert(varChar(12),Sum(TradeQty)),  
 MarketRate = Convert(Numeric(10,5),(Sum(Round(dummy1,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))),  
  I.Party_Code, Sett_No, Sett_Type, Scrip_Cd  
 Into #ISettlement_New From Isettlement I, instClient_Tbl T   
 Where ContractNo = @ContractNo and    
 Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8) = @SaudaDate   
 and I.Party_Code Between @@FromParty and @@ToParty  and Tradeqty <> 0   and I.Party_Code = T.PartyCode  
 and Sett_No = @Sett_No    
 and Sett_Type = (Case When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='23'  Then 'N'   
                            When @Sett_Type= 'TT' and @ExchangeCode='23'  Then 'W'   
                                       When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='01'  Then 'D'  
                            When @Sett_Type= 'TT' and @ExchangeCode='01'  Then 'C'  
                                        When @Sett_Type= 'AR' and @ExchangeCode='23'  Then 'A'   
                                        When @Sett_Type= 'AD' and @ExchangeCode='01'  Then 'AD' Else '' End)  
 And ltrim(Rtrim(Scrip_Cd)) = ltrim(Rtrim(@ScripCd))    
 Group By ContractNo,I.Party_Code, Sett_No, Sett_Type, Scrip_Cd  
  
/*****************************************************************************************/  
  
 Select  
 trade_no = Replace(Replace(Replace(lTrim(rTrim(Trade_no)),'R',''),'C',''),'A',''),  
 TradeQty = TradeQty,  
 MarketRate=CONVERT(VARCHAR,Convert(Numeric(10,4),I.MarketRate)),  
    TradeTime = sauda_date,  
    order_no = lTrim(rTrim(Order_no))  
 From #Isettlement_New I, instClient_Tbl T, Client2 C2, Client1 C1  
  
 Where ContractNo = @ContractNo   
 and I.Party_Code Between @@FromParty and @@ToParty  and Tradeqty <> 0  and I.Party_Code = T.PartyCode  
 and Sett_No = @Sett_No  and Sett_Type = (Case  
          When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='23'  Then 'N'   
   When @Sett_Type= 'TT' and @ExchangeCode='23'  Then 'W'   
          When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='01'  Then 'D'  
   When @Sett_Type= 'TT' and @ExchangeCode='01'  Then 'C'  
          When @Sett_Type= 'AR' and @ExchangeCode='23'  Then 'A'   
          When @Sett_Type= 'AD' and @ExchangeCode='01'  Then 'AD' Else '' End)  
 And C2.Party_code = I.Party_Code And C2.Dummy6 = 'FT' and C2.Dummy7 = '1'  
 And ltrim(Rtrim(Scrip_Cd)) = ltrim(Rtrim(@ScripCd))    
 And C1.Cl_code = c2.Cl_code  
 and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)   
  
 UNION ALL  
  
 Select  
 trade_no = Replace(Replace(Replace(lTrim(rTrim(Trade_no)),'R',''),'C',''),'A',''),  
 TradeQty = TradeQty,  
 MarketRate=CONVERT(VARCHAR,Convert(Numeric(10,4),I.MarketRate)),  
    TradeTime = sauda_date,  
 order_no = lTrim(rTrim(Order_no))  
 From #settlement_New I, instClient_Tbl T, Client2 C2, Client1 C1  
  
 Where ContractNo = @ContractNo   
 and I.Party_Code Between @@FromParty and @@ToParty  and Tradeqty <> 0  and I.Party_Code = T.PartyCode  
 and Sett_No = @Sett_No  and Sett_Type = (Case  
    When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='23'  Then 'N'   
   When @Sett_Type= 'TT' and @ExchangeCode='23'  Then 'W'   
          When (@Sett_Type= 'DR' OR @SETT_TYPE = 'DI') and @ExchangeCode='01'  Then 'D'  
   When @Sett_Type= 'TT' and @ExchangeCode='01'  Then 'C'  
          When @Sett_Type= 'AR' and @ExchangeCode='23'  Then 'A'   
          When @Sett_Type= 'AD' and @ExchangeCode='01'  Then 'AD' Else '' End)  
 And C2.Party_code = I.Party_Code And C2.Dummy6 = 'FT' and C2.Dummy7 = '1'  
 And ltrim(Rtrim(Scrip_Cd)) = ltrim(Rtrim(@ScripCd))  
 And C1.Cl_code = c2.Cl_code  
 and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)     
  
/*****************************************************************************************/

GO
