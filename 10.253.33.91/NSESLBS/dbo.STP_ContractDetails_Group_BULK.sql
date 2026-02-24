-- Object: PROCEDURE dbo.STP_ContractDetails_Group_BULK
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE      Proc STP_ContractDetails_Group_BULK  
@FromDate Varchar(11),      
@ToDate Varchar(11),      
@FromContract Varchar(7),      
@ToContract Varchar(7),      
@FromParty Varchar(10),      
@ToParty Varchar(10),      
@BatchNo Varchar(7),      
@BrokerSebiRegNo Varchar(12),      
@ExchangeCode Varchar(4),      
@FromCustodian Varchar(20),      
@ToCustodian Varchar(20),      
@FromCP Varchar(8),      
@ToCP Varchar(8),      
@SettlementDate Varchar(11),      
@Remark Varchar(210),      
@GroupCode Varchar(10)      
      
As      
      
If Ltrim(Rtrim(@FromCustodian)) = '' And Ltrim(Rtrim(@ToCustodian)) = ''      
Begin      
 Select @FromCustodian = Min(custodiancode), @ToCustodian = Max(custodiancode)  From Custodian      
End      
      
If Ltrim(Rtrim(@FromCP)) = '' And Ltrim(Rtrim(@ToCP)) = ''      
Begin      
 Select @FromCP = Min(DPId), @ToCp = Max(DPId)  From Custodian      
End      
      
Select ContractNo,      
Trade_no=Replace(Replace(Replace(Replace(Replace(Replace(Ltrim(Rtrim(Trade_no)),'R',''),'C',''),'A',''),'S',''),'B',''),'T',''),      
Party_Code,Scrip_Cd,Tradeqty,MarketType,Series,Order_no,      
MarketRate,Sauda_date,Sell_buy,Brokapplied,NetRate,Service_tax,      
NBrokApp,NSerTax,N_NetRate,Sett_No,sett_type,PartiPantCode,      
ins_chrg      
Into #Settlement From Settlement I      
Where ContractNo Between @FromContract and @ToContract and Sauda_Date Like @FromDate + '%'       
and I.Party_Code Between @FromParty and @ToParty And Tradeqty > 0      
      
Select ContractNo,Trade_no,      
Party_Code,Scrip_Cd,Tradeqty=Sum(TradeQty),MarketType,Series,Order_no,      
MarketRate=Sum(TradeQty*MarketRate)/Sum(TradeQty),Sauda_date,Sell_buy,      
Brokapplied=Sum(NBrokapp*TradeQty)/Sum(TradeQty),NetRate=Sum(TradeQty*N_NetRate)/Sum(TradeQty),      
Service_tax=Sum(NSerTax),Sett_No,sett_type,PartiPantCode,      
ins_chrg=isnull(sum(ins_chrg), 0)      
Into #Settlement_New From #Settlement      
Group By ContractNo,Trade_no,      
Party_Code,Scrip_Cd,MarketType,Series,Order_no,Sauda_date,Sell_buy,Sett_No,sett_type,PartiPantCode      
      
      
Select ContractNo,      
Trade_no=Replace(Replace(Replace(Replace(Replace(Replace(Ltrim(Rtrim(Trade_no)),'R',''),'C',''),'A',''),'S',''),'B',''),'T',''),      
Party_Code,Scrip_Cd,Tradeqty,MarketType,Series,Order_no,      
MarketRate,Sauda_date,Sell_buy,Brokapplied,NetRate,Service_tax,      
NBrokApp,NSerTax,N_NetRate,Sett_No,sett_type,PartiPantCode,      
ins_chrg      
Into #ISettlement From ISettlement I      
Where ContractNo Between @FromContract and @ToContract and Sauda_Date Like @FromDate + '%'       
and I.Party_Code Between @FromParty and @ToParty And Tradeqty > 0      
      
Select ContractNo,Trade_no,      
Party_Code,Scrip_Cd,Tradeqty=Sum(TradeQty),MarketType,Series,Order_no,      
MarketRate=Sum(TradeQty*MarketRate)/Sum(TradeQty),Sauda_date,Sell_buy,      
Brokapplied=Sum(NBrokapp*TradeQty)/Sum(TradeQty),NetRate=Sum(TradeQty*N_NetRate)/Sum(TradeQty),      
Service_tax=Sum(NSerTax),Sett_No,sett_type,PartiPantCode,      
ins_chrg=isnull(sum(ins_chrg), 0)      
Into #ISettlement_New From #ISettlement      
Group By ContractNo,Trade_no,      
Party_Code,Scrip_Cd,MarketType,Series,Order_no,Sauda_date,Sell_buy,Sett_No,sett_type,PartiPantCode      
      
Select Header, Filler, LineNo1, ContractNo = Left(ContractNo+'                ',16) , CNDate,       
BrokerSebiRegNo =  Left(@BrokerSebiRegNo + '            ',12),      
/*BLANKED OUT BY SHYAM - Jun 16 2004*/      
ExchangeCode = Space(4), /*Left(@ExchangeCode+'    ',4), */      
ClExchangeCode = Left(ClExchangeCode+'                ',16),      
CustodianCode = Left(CustodianCode+'        ',8), Filler1,      
ISIN = Left(Isin + '            ',12),       
TradeDate, MarketType, Sett_No, TradeFlag,       
Sett_Type=Left(Ltrim(Rtrim(Sett_Type))+'  ',2), SettDate,Filler2,      
AvgRate =  Right('0000000000' + Substring(Convert(varChar(15),AvgRate),1,CHARINDEX('.',Convert(varChar(15),AvgRate),1)-1),10)+      
Left(Substring(Convert(varChar(15),AvgRate),CHARINDEX('.',Convert(varChar(15),AvgRate),1)+1,Len(Convert(varChar(15),AvgRate))-1)+'00000',5),      
Qty = Right('000000000000' + Convert(varChar(13),Qty),12)+ '000',      
Brokerage = Right('0000000000' + Substring(Convert(varChar(15),Brokerage),1,CHARINDEX('.',Convert(varChar(15),Brokerage),1)-1),10)+      
Left(Substring(Convert(varChar(15),Brokerage),CHARINDEX('.',Convert(varChar(15),Brokerage),1)+1,Len(Convert(varChar(15),Brokerage))-1)+'00000',5),      
ServiceTax = Right('0000000000' + Substring(Convert(varChar(12),ServiceTax),1,CHARINDEX('.',Convert(varChar(12),ServiceTax),1)-1),10)+      
Left(Substring(Convert(varChar(15),ServiceTax),CHARINDEX('.',Convert(varChar(15),ServiceTax),1)+1,Len(Convert(varChar(15),ServiceTax))-1)+'00000',5),      
NetValue  = Right('0000000000' + Substring(Convert(varChar(15),NetValue),1,CHARINDEX('.',Convert(varChar(15),NetValue),1)-1),10)+      
Left(Substring(Convert(varChar(15),NetValue),CHARINDEX('.',Convert(varChar(15),NetValue),1)+1,Len(Convert(varChar(15),NetValue))-1)+'00000',5),      
NoOfTrades = (Case When Detail = 'N' Then '00001' Else Right('00000' + Convert(varChar(5),NoOfTrades),5) End), 
SebiNo = Left(SebiNo + Space(12),12), 
CSett_No,SettOrISett,Detail,      
scrip_cd = Right(Space(20) + LTrim(RTrim(scrip_cd)), 20),      
ins_chrg = Right('0000000000' + Substring(Convert(varChar(15), ins_chrg),1,      
 CHARINDEX('.',Convert(varChar(15), ins_chrg),1)-1),10) +      
 Left(Substring(Convert(varChar(15), ins_chrg), CHARINDEX('.',Convert(varChar(15), ins_chrg),1)+1,       
 Len(Convert(varChar(15), ins_chrg))-1)+'00000',5)      
      
From (      
      
Select Header = @BatchNo + '15', Filler=Space(6),LineNo1= '00000', ContractNo = 'A23'+ Ltrim(Rtrim(I.ContractNo)),       
CNDate = Replace(Replace(Replace(Convert(Varchar,Min(I.Sauda_date),120),'-',''),':',''),' ',''),       
ClExchangeCode= Left((Case when RTrim(LTrim(U.Mapidid))<>'' then RTrim(LTrim(U.Mapidid)) else RTrim(LTrim(U.Ucc_code)) end) + Space(16), 16),      
CustodianCode = /*Isnull(C.DpId,'')*/ IsNull(U.FMCode,'') , Filler1 = Space(2),      
ISIN = Isnull(M.Isin,''), TradeDate = Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8),       
MarketType=(Case      
                  When  I.Sett_Type in( 'N', 'D') Then (Case When I.Scrip_Cd Like '6%' Or I.Series='IL' Then 'DI' Else 'DR' End)      
        When  I.Sett_Type in( 'W', 'C') Then  'TT'      
                  When  I.Sett_Type in ('A', 'AD') Then 'AR' Else ''       
        End),       
Sett_No = (Case When @ExchangeCode = 'NSE'       
  Then  I.Sett_No       
  Else (Case When Convert(int,Month(Start_Date)) < 4       
                   Then '0' + Convert(Varchar,Right(Convert(int,Year(Start_Date)),2) - 1) + Right(Convert(int,Year(Start_Date)),2)       
             Else Right(Convert(int,Year(Start_Date)),2) + '0' + Convert(Varchar,Right(Convert(int,Year(Start_Date)),2) + 1)       
                 End)       
          + Right(I.Sett_no,3)        
      End ),       
TradeFlag=(Case When I.Sell_Buy=1 Then 'B' Else 'S' End), I.Sett_Type,        
settdate =      
Left(Replace(Replace(Replace(Convert(Varchar,convert(datetime,       
 Case when ltrim(rtrim(@SettlementDate)) = '' then       
 (Case When Sell_Buy = 1 Then S.Sec_PayOut   Else  S.Sec_PayIn  End)      
  else @SettlementDate end),120),'-',''),':',''),' ',''),8),      
/*SettDate = (Case When Sell_Buy = 1       
                            Then Left(Replace(Replace(Replace(Convert(Varchar,S.Sec_PayOut,120),'-',''),':',''),' ',''),8)      
                Else  Left(Replace(Replace(Replace(Convert(Varchar,S.Sec_PayIn,120),'-',''),':',''),' ',''),8)      
                  End) ,*/      
Filler2=Space(2),      
AvgRate = Convert(Numeric(18,5),(Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))),      
Qty=Sum(I.Tradeqty),       
Brokerage = (Case When Service_chrg = 1       
                              Then Convert(Numeric(18,5),Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage)))      
      Else   Convert(Numeric(18,5),Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage)))      
                     End),       
ServiceTax = (Case When Service_chrg = 0       
                                Then Convert(Numeric(18,5),Sum(I.Service_tax))       
                    Else 0      
                       End),       
      
NetValue = round((Case When Sell_Buy = 1       
   Then Convert(Numeric(18,5),(Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))) * Sum(I.Tradeqty)      
        + (Case When Service_chrg = 1       
                              Then Convert(Numeric(18,5),Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage)))      
         Else Convert(Numeric(18,5),Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage)))      
                       End)      
        + (Case When Service_chrg = 0       
                                Then Convert(Numeric(18,5),Sum(I.Service_tax))       
                    Else 0      
                         End)      
    + (Case When Insurance_chrg = 1 Then Convert(Numeric(18,5), round(sum(i.ins_chrg), 0) ) Else 0 End)      
   Else Convert(Numeric(18,5),(Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))) * Sum(I.Tradeqty)       
        - (Case When Service_chrg = 1       
                              Then Convert(Numeric(18,5),Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage)))      
         Else Convert(Numeric(18,5),Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage)))      
                       End)      
        - (Case When Service_chrg = 0       
                                Then Convert(Numeric(18,5),Sum(I.Service_tax))       
                    Else 0      
                         End)       
     - (Case When Insurance_chrg = 1 Then Convert(Numeric(18,5), round(sum(i.ins_chrg), 0) ) Else 0 End)      
  End ),2),      
NoOfTrades = Count(I.Trade_no),
SebiNo=IsNull(C1.FD_Code,''), CSett_No=I.Sett_No,SettOrISett = 'I',Detail=(Case When Dummy7 = 0 Then 'Y' Else 'N' End),      
i.scrip_cd, ins_chrg = round(sum((case when insurance_chrg = 1 then ins_chrg else 0 end)), 0)      
      
From Multiisin M, Sett_Mst S, instclient_tbl T, Client2 C2, Client1 C1, Custodian C, #Isettlement_New I Left Outer Join UCC_Client U      
On (U.Party_Code = I.Party_Code)       
Where C1.Cl_Code = C2.Cl_Code and C1.Cl_Type = 'INS' And C2.Dummy6 = 'NSDL'        
And ContractNo Between @FromContract and @ToContract and Sauda_Date Like @FromDate + '%'       
and I.Party_Code Between @FromParty and @ToParty and I.Scrip_Cd = M.Scrip_Cd 
and M.Series = (Case When I.Series = 'BL' Then 'EQ' 
                     When I.Series = 'IL' Then 'EQ' 
                     Else I.Series
                End)
and M.Valid=1 and       
I.Sett_no = S.Sett_No and I.Sett_type = S.Sett_Type and Tradeqty <> 0  and I.Party_Code = T.PartyCode      
and I.Party_Code = C2.Party_Code And C2.CltDpNo = C.custodiancode And C.DpId Between @FromCp And @ToCp      
And CustodianCode Between @FromCustodian And @ToCustodian      
and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)      
Group By I.ContractNo, i.scrip_cd, Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8),       
I.PartiPantCode, I.MarketType, I.Sett_No, I.Sell_Buy, I.Sett_Type, M.Isin,       
--S.Sec_PayOut, Sec_PayIn,       
Left(Replace(Replace(Replace(Convert(Varchar,convert(datetime,       
 Case when ltrim(rtrim(@SettlementDate)) = '' then       
 (Case When Sell_Buy = 1 Then S.Sec_PayOut   Else  S.Sec_PayIn  End)      
  else @SettlementDate end),120),'-',''),':',''),' ',''),8),      
U.FMCode, U.Mapidid,U.Ucc_Code,T.brokerage,T.marketrate,Service_chrg,Dummy7,Start_Date,      
insurance_chrg, C1.FD_Code,I.Series      
      
Union All      
      
Select Header = @BatchNo + '15', Filler=Space(6),LineNo1= '00000', ContractNo = 'A23'+ Ltrim(Rtrim(I.ContractNo)),       
CNDate = Replace(Replace(Replace(Convert(Varchar,Min(I.Sauda_date),120),'-',''),':',''),' ',''),       
ClExchangeCode= Left((Case when RTrim(LTrim(U.Mapidid))<>'' then RTrim(LTrim(U.Mapidid)) else RTrim(LTrim(U.Ucc_code)) end) + Space(16), 16),      
CustodianCode =  IsNull(U.FMCode,''), Filler1 = Space(2),      
ISIN = Isnull(M.Isin,''), TradeDate = Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8),       
MarketType=(Case      
          When  I.Sett_Type in( 'N', 'D') Then (Case When I.Scrip_Cd Like '6%' Or I.Series='IL' Then 'DI' Else 'DR' End)      
        When  I.Sett_Type in( 'W', 'C') Then  'TT'      
          When  I.Sett_Type in ('A', 'AD') Then 'AR' Else '' End),       
Sett_No = (Case When @ExchangeCode = 'NSE'       
  Then  I.Sett_No       
  Else (Case When Convert(int,Month(Start_Date)) < 4       
                   Then '0' + Convert(Varchar,Right(Convert(int,Year(Start_Date)),2) - 1) + Right(Convert(int,Year(Start_Date)),2)        
             Else Right(Convert(int,Year(Start_Date)),2) + '0' + Convert(Varchar,Right(Convert(int,Year(Start_Date)),2) + 1)       
                 End)       
          + Right(I.Sett_no,3)        
      End ),        
TradeFlag=(Case When I.Sell_Buy=1 Then 'B' Else 'S' End), I.Sett_Type,        
settdate =      
Left(Replace(Replace(Replace(Convert(Varchar,convert(datetime,       
 Case when ltrim(rtrim(@SettlementDate)) = '' then       
 (Case When Sell_Buy = 1 Then S.Sec_PayOut   Else  S.Sec_PayIn  End)      
  else @SettlementDate end),120),'-',''),':',''),' ',''),8),      
/*SettDate = (Case When Sell_Buy = 1       
                            Then Left(Replace(Replace(Replace(Convert(Varchar,S.Sec_PayOut,120),'-',''),':',''),' ',''),8)      
                Else  Left(Replace(Replace(Replace(Convert(Varchar,S.Sec_PayIn,120),'-',''),':',''),' ',''),8)      
                  End) , */      
Filler2=Space(2),       
AvgRate = Convert(Numeric(18,5),(Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))),      
Qty=Sum(I.Tradeqty),       
Brokerage = (Case When Service_chrg = 1       
                              Then Convert(Numeric(18,5),Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage)))      
      Else   Convert(Numeric(18,5),Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage)))      
                     End),       
ServiceTax = (Case When Service_chrg = 0       
                                Then Convert(Numeric(18,5),Sum(I.Service_tax))       
                    Else 0      
                       End),       
      
NetValue =round( (Case When Sell_Buy = 1       
   Then Convert(Numeric(18,5),(Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))) * Sum(I.Tradeqty)      
        + (Case When Service_chrg = 1       
                              Then Convert(Numeric(18,5),Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage)))      
         Else Convert(Numeric(18,5),Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage)))      
                       End)      
        + (Case When Service_chrg = 0       
                                Then Convert(Numeric(18,5),Sum(I.Service_tax))       
                    Else 0      
                         End)      
     + (Case When Insurance_chrg = 1 Then Convert(Numeric(18,5), round(sum(i.ins_chrg), 0) ) Else 0 End)      
   Else Convert(Numeric(18,5),(Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))) * Sum(I.Tradeqty)       
        - (Case When Service_chrg = 1       
                              Then Convert(Numeric(18,5),Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage)))      
         Else Convert(Numeric(18,5),Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage)))      
                       End)      
        - (Case When Service_chrg = 0       
                      Then Convert(Numeric(18,5),Sum(I.Service_tax))       
                    Else 0      
                         End)       
     - (Case When Insurance_chrg = 1 Then Convert(Numeric(18,5), round(sum(i.ins_chrg), 0) ) Else 0 End)      
  End ),2),      
NoOfTrades = Count(I.Trade_no),
SebiNo=IsNull(C1.FD_Code,''),CSett_No=I.Sett_No,SettOrISett = 'S',Detail=(Case When Dummy7 = 0 Then 'Y' Else 'N' End),      
i.scrip_cd, ins_chrg = round(sum((case when insurance_chrg = 1 then ins_chrg else 0 end)), 0)      
      
From Multiisin M, Sett_Mst S, instclient_tbl T, Client2 C2, Client1 C1, Custodian C, #settlement_New I Left Outer Join UCC_Client U      
On (U.Party_Code = I.Party_Code)       
Where C1.Cl_Code = C2.Cl_Code and C1.Cl_Type = 'INS' And C2.Dummy6 = 'NSDL'        
And ContractNo Between @FromContract and @ToContract and Sauda_Date Like @FromDate + '%'       
and I.Party_Code Between @FromParty and @ToParty and I.Scrip_Cd = M.Scrip_Cd 
and M.Series = (Case When I.Series = 'BL' Then 'EQ' 
                     When I.Series = 'IL' Then 'EQ' 
                     Else I.Series
                End)
and M.Valid=1 and       
I.Sett_no = S.Sett_No and I.Sett_type = S.Sett_Type and Tradeqty <> 0  and I.Party_Code = T.PartyCode      
and I.Party_Code = C2.Party_Code And C2.CltDpNo = C.custodiancode And C.DpId Between @FromCp And @ToCp      
And CustodianCode Between @FromCustodian And @ToCustodian      
and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)      
Group By I.ContractNo, i.scrip_cd, Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8),       
I.PartiPantCode, I.MarketType, I.Sett_No, I.Sell_Buy, I.Sett_Type, M.Isin,       
--S.Sec_PayOut, Sec_PayIn,       
Left(Replace(Replace(Replace(Convert(Varchar,convert(datetime,       
 Case when ltrim(rtrim(@SettlementDate)) = '' then       
 (Case When Sell_Buy = 1 Then S.Sec_PayOut   Else  S.Sec_PayIn  End)      
  else @SettlementDate end),120),'-',''),':',''),' ',''),8),      
U.FMCode, U.Mapidid,U.Ucc_Code,T.brokerage,T.marketrate,Service_chrg,Dummy7,Start_Date,      
insurance_chrg, C1.FD_Code,I.Series      
) A      
      
Order By ContractNo

GO
