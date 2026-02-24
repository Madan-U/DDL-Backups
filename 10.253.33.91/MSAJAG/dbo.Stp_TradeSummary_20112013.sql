-- Object: PROCEDURE dbo.Stp_TradeSummary_20112013
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

    
CREATE   Proc [dbo].[Stp_TradeSummary_20112013]      
@SaudaDate Varchar(8),      
@ContractNo Varchar(7),      
@Sett_No Varchar(7),      
@Sett_Type Varchar(3),      
@BatchNo Varchar(7),      
@FromParty Varchar(10),      
@ToParty Varchar(10),      
@BrokerSebiRegNo Varchar(12),      
@ExchangeCode Varchar(4),      
@IOrS Varchar(1),      
@GroupCode Varchar(10)      
      
As      
Declare       
@Order_No Varchar(16),      
@Trade_No Varchar(16),      
@TradeTime Varchar(6)      
      
If @IOrS = 'S'       
Begin      
      
Select @Order_no =  Right('0000000000000000' + Ltrim(Rtrim(Min(Order_no))),16) ,       
@Trade_No = Right('0000000000000000' +Replace(Replace(Replace(Ltrim(Rtrim(Min(Trade_no))),'R',''),'C',''),'A',''),16),      
@TradeTime = Right(Replace(Replace(Replace(Convert(Varchar,Min(Sauda_date),120),'-',''),':',''),' ',''),6)      
From settlement I, instClient_Tbl T, Client2 C2, client1 c1      
Where ContractNo = @ContractNo and  Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8) = @SaudaDate       
and I.Party_Code Between @FromParty and @ToParty  and Tradeqty <> 0  and I.Party_Code = T.PartyCode      
and Sett_No = @Sett_No  and Sett_Type = @Sett_Type      
And C1.Cl_code = c2.Cl_code      
and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)      
And C2.Party_code = I.Party_Code And C2.Dummy6 = 'NSDL' and C2.Dummy7 = '1'      
      
Select Header , Line, Filler, Sebi,  ContractNo, Order_no, Trade_No, TradeTime,TradeQty ,      
MarketRate = Right('0000000000' + Substring(Convert(varChar(15),MarketRate),1,CHARINDEX('.',Convert(varChar(15),MarketRate),1)-1),10)+      
Left(Substring(Convert(varChar(15),MarketRate),CHARINDEX('.',Convert(varChar(15),MarketRate),1)+1,Len(Convert(varChar(15),MarketRate))-1)+'00000',5),Party_code  = Right(Space(10) + LTrim(RTrim(Party_Code)), 10)      
From       
(      
Select Header = @BatchNo + '13', Line = '00000', Filler=Space(2), Sebi=Left(@BrokerSebiRegNo+'            ',12), ContractNo =  'A23'+Left(Ltrim(Rtrim(@ContractNo)) + '             ',13) ,      
Order_no =  @Order_No, /*Right('0000000000000000' + Ltrim(Rtrim(Order_no)),16) , */      
Trade_No = @Trade_No, /*Right('0000000000000000' +Replace(Replace(Replace(Ltrim(Rtrim(Trade_no)),'R',''),'C',''),'A',''),16),*/      
TradeTime = @TradeTime, /*Right(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),6),*/      
/*TradeQty = Right('000000000000' + Convert(varChar(12),TradeQty),12)+ '000',*/      
TradeQty = Right('000000000000' + Convert(varChar(12),Sum(TradeQty)),12)+ '000',      
/*MarketRate =Convert(Numeric(10,5), Round(I.MarketRate, Convert(integer,T.marketrate)))*/      
MarketRate =Convert(Numeric(10,5),(Sum(Round(I.Dummy1,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))),I.Party_code      
From settlement I, instClient_Tbl T, Client2 C2, client1 c1      
Where ContractNo = @ContractNo and  Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8) = @SaudaDate       
and I.Party_Code Between @FromParty and @ToParty  and Tradeqty <> 0  and I.Party_Code = T.PartyCode      
and Sett_No = @Sett_No  and Sett_Type = @Sett_Type      
And C1.Cl_code = c2.Cl_code      
and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)      
And C2.Party_code = I.Party_Code And C2.Dummy6 = 'NSDL'  and C2.Dummy7 = '1'      
group by I.Party_code      
) A      
End      
Else      
Begin      
Select @Order_no =  Right('0000000000000000' + Ltrim(Rtrim(Min(Order_no))),16) ,       
@Trade_No = Right('0000000000000000' +Replace(Replace(Replace(Ltrim(Rtrim(Min(Trade_no))),'R',''),'C',''),'A',''),16),      
@TradeTime = Right(Replace(Replace(Replace(Convert(Varchar,Min(Sauda_date),120),'-',''),':',''),' ',''),6)      
From Isettlement I, instClient_Tbl T, Client2 C2, client1 c1      
Where ContractNo = @ContractNo and  Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8) = @SaudaDate       
and I.Party_Code Between @FromParty and @ToParty  and Tradeqty <> 0  and I.Party_Code = T.PartyCode      
and Sett_No = @Sett_No  and Sett_Type = @Sett_Type      
And C1.Cl_code = c2.Cl_code      
and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)      
And C2.Party_code = I.Party_Code And C2.Dummy6 = 'NSDL'  and C2.Dummy7 = '1'      
      
Select Header , Line, Filler, Sebi,  ContractNo, Order_no, Trade_No, TradeTime,TradeQty ,      
MarketRate = Right('0000000000' + Substring(Convert(varChar(15),MarketRate),1,CHARINDEX('.',Convert(varChar(15),MarketRate),1)-1),10)+      
Left(Substring(Convert(varChar(15),MarketRate),CHARINDEX('.',Convert(varChar(15),MarketRate),1)+1,Len(Convert(varChar(15),MarketRate))-1)+'00000',5),Party_code = Right(Space(10) + LTrim(RTrim(Party_Code)), 10)      
From       
(      
Select Header = @BatchNo + '13', Line = '00000', Filler=Space(2), Sebi=Left(@BrokerSebiRegNo+'            ',12), ContractNo =  'A23'+Left(Ltrim(Rtrim(@ContractNo)) + '             ',13) ,      
Order_no =  @Order_No, /*Right('0000000000000000' + Ltrim(Rtrim(Order_no)),16) , */      
Trade_No = @Trade_No, /*Right('0000000000000000' +Replace(Replace(Replace(Ltrim(Rtrim(Trade_no)),'R',''),'C',''),'A',''),16),*/      
TradeTime = @TradeTime, /*Right(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),6),*/      
/*TradeQty = Right('000000000000' + Convert(varChar(12),TradeQty),12)+ '000',*/      
TradeQty = Right('000000000000' + Convert(varChar(12),Sum(TradeQty)),12)+ '000',      
/*MarketRate =Convert(Numeric(10,5), Round(I.MarketRate, Convert(integer,T.marketrate)))*/      
MarketRate =Convert(Numeric(10,5),(Sum(Round(I.Dummy1,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))),I.Party_code      
From Isettlement I, instClient_Tbl T, Client2 C2, client1 c1      
Where ContractNo = @ContractNo and  Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8) = @SaudaDate       
and I.Party_Code Between @FromParty and @ToParty  and Tradeqty <> 0  and I.Party_Code = T.PartyCode      
and Sett_No = @Sett_No  and Sett_Type = @Sett_Type      
And C1.Cl_code = c2.Cl_code      
and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)      
And C2.Party_code = I.Party_Code And C2.Dummy6 = 'NSDL'  and C2.Dummy7 = '1'      
group by I.Party_code      
) A      
End

GO
