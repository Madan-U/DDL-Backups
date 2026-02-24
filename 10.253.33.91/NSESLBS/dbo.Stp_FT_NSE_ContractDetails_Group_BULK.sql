-- Object: PROCEDURE dbo.Stp_FT_NSE_ContractDetails_Group_BULK
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------






--Exec Stp_FT_NSE_ContractDetails_Group_BULK 'Mar 22 2004','Mar 22 2004', '0000181','0017852', 'UT056', 'UT056', '','0000005', '10208','IN231111131', 'NSE','','brokerage inclusive of STT In FT'

CREATE     PROC

Stp_FT_NSE_ContractDetails_Group_BULK

@FromDate Varchar(11),
@ToDate Varchar(11),
@FromContract Varchar(7),
@ToContract Varchar(7),
@FromParty Varchar(10),
@ToParty Varchar(10),
@LineNo Varchar(5),
@BatchNo Varchar(7),
@MemberCode Varchar(15),
@BrokerSebiRegNo Varchar(12),
@ExchangeCode Varchar(4),
@SettlementDate Varchar(11),
@GroupCode Varchar(10),
@FromCustodian Varchar(20),      
@ToCustodian Varchar(20),      
@FromCP Varchar(8),      
@ToCP Varchar(8)
As

Declare
@@FromParty Varchar(10),
@@ToParty Varchar(10),
@@FromContract Varchar(7),
@@ToContract Varchar(7)

If Ltrim(Rtrim(@FromCustodian)) = '' And Ltrim(Rtrim(@ToCustodian)) = ''      
Begin      
 Select @FromCustodian = Min(custodiancode), @ToCustodian = Max(custodiancode)  From Custodian      
End      
      
If Ltrim(Rtrim(@FromCP)) = '' And Ltrim(Rtrim(@ToCP)) = ''      
Begin      
 Select @FromCP = Min(DPId), @ToCp = Max(DPId)  From Custodian      
End 

Select @@FromParty =  @FromParty
Select @@ToParty = @ToParty
If Ltrim(Rtrim(@@FromParty)) = '' And Ltrim(Rtrim(@@ToParty)) = ''
Begin
	Select @@FromParty = Min(Party_Code), @@ToParty = Max(Party_Code)  From Client2
End

Select @@FromContract =  @FromContract
Select @@ToContract = @ToContract

If Ltrim(Rtrim(@@FromContract)) = '' And Ltrim(Rtrim(@@ToContract)) = ''
Begin
	Select @@FromContract = '0000000',  @@ToContract = '9999999'
End

Select

BrokerSebiRegNo = @BrokerSebiRegNo,
CustodianCode = isnull(C.SebiRegNo,0),
ContractType = 'A',
ExchangeCode = (Case When @ExchangeCode='NSE' Then '23' When @ExchangeCode='BSE' Then '01' Else '' End),
ContractNo = LTrim(RTrim(i.contractno)), 
MsgPrepDate = Left(Replace(Replace(Replace(Convert(Varchar,getdate(),120),'-',''),':',''),' ',''),8), 
settdate =
Left(Replace(Replace(Replace(Convert(Varchar,convert(datetime, 
	Case when ltrim(rtrim(@SettlementDate)) = '' then 
	S.Sec_Payout else 
	@SettlementDate end),120),'-',''),':',''),' ',''),8),
TradeDate = Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8), 
TradeRate = CONVERT(VARCHAR,CONVERT(NUMERIC(18,4),round((Sum(I.MarketRate * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)),4))), 
brokpershare=
Convert
(
	NUMERIC(18,4),
	Case When Sum(I.Tradeqty) > 0 Then
	(
		CONVERT(NUMERIC(18,4),round((Case When Service_chrg = 1 
		Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))
		Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))
		End),4))/Sum(I.Tradeqty)
	)
	Else
	0
	End
),
ExchangeID = (Case When @ExchangeCode='NSE' Then '100013573' When @ExchangeCode='BSE' Then '100002519' Else '' End),
ExchangeClearingHouse = (Case When @ExchangeCode='NSE' Then '100013581' When @ExchangeCode='BSE' Then '100002303' Else '' End),
TradeFlag=(Case When I.Sell_Buy=1 Then 'BUYI' Else 'SELL' End),
TradePayment = 'FREE',
ClientName = Left(LTrim(RTrim(c1.long_name)), 100),
ClientSEBINumber = replace(c1.Fd_Code,'/',''),
CpCode = left((Case when RTrim(LTrim(U.Mapidid))<>'' then RTrim(LTrim(U.Mapidid))else RTrim(LTrim(U.Ucc_code)) end),12),
Qty=Sum(I.Tradeqty),
IsinDetails = M.Isin,
ScripDetails = '',
Sett_Type = (Case
	         When  I.Sett_Type in( 'N', 'D') Then (CASE WHEN I.SERIES = 'IL' THEN 'DI' ELSE 'DR' END)
		 When  I.Sett_Type in( 'W', 'C') Then 'TT' 
	         When  I.Sett_Type in ('A', 'AD') Then 'AR' Else 'OT' End), 
Sett_No = (Case When @ExchangeCode = 'NSE' 
		Then  I.Sett_No 
		Else (Case When Convert(int,Month(Start_Date)) < 4 
		                 Then '0' + Convert(Varchar,Right(Convert(int,Year(Start_Date)),2) - 1) + Right(Convert(int,Year(Start_Date)),2) 
	      		    Else Right(Convert(int,Year(Start_Date)),2) + '0' + Convert(Varchar,Right(Convert(int,Year(Start_Date)),2) + 1) 
 	     	         End) 
		        + Right(I.Sett_no,3)  
	     End ),
BuySellBroker=(Case When I.Sell_Buy=1 Then 'SELL' Else 'BUYR' End),
AgentType=(Case When I.Sell_Buy=1 Then 'DEAG' Else 'REAG' End),

TradeAmount = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))*Sum(I.Tradeqty),4))), 
Brokerage = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Service_chrg = 1
                      Then Round(Sum(I.Brokapplied*I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))
      		 Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))
                     End),4))), 
ServiceTax = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Service_chrg = 0 
                   Then Sum(I.Service_tax) 
	                   Else 0
                   End),4))), 
NetSettAmount = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Sell_Buy = 1 
		 Then (Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)) * Sum(I.Tradeqty)
		      + (Case When Service_chrg = 1 
                              Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))
			      Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))
                     	 End)
		      + (Case When Service_chrg = 0 
                                Then Sum(I.Service_tax) 
	                   Else 0
                         End) 
		      + (case when insurance_chrg = 1 then sum(ins_chrg) else 0 end)		/*FOR STT*/

		 Else (Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)) * Sum(I.Tradeqty) 
		      - (Case When Service_chrg = 1 
                              Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))
			      Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))
                     	 End)
		      - (Case When Service_chrg = 0 
                                Then Sum(I.Service_tax) 
	                   Else 0
                         End)
					- (case when insurance_chrg = 1 then sum(ins_chrg) else 0 end)		/*FOR STT*/
		End ),4))),

Detail=(Case When Dummy7 = 0 Then 'Y' Else 'N' End),
I.party_code,
I.scrip_cd,
ins_chrg = round(round(sum((case when insurance_chrg = 1 then ins_chrg else 0 end)), 0 , 1), 4)

From Isettlement I, Multiisin M, Sett_Mst S, Owner O, Client1 C1, Client2 C2, Custodian C,  instclient_tbl T, scrip1 s1, scrip2 s2, Ucc_Client U
Where 
ContractNo Between @@FromContract and @@ToContract
and Sauda_Date Like @FromDate + '%'
and I.Party_Code Between @@FromParty and @@ToParty
and I.Scrip_Cd = M.Scrip_Cd
and M.Series = (Case When I.Series = 'BL' Then 'EQ' 
                     When I.Series = 'IL' Then 'EQ' 
                     Else I.Series
                End)
and M.Valid=1
and I.Sett_no = S.Sett_No
and I.Sett_type = S.Sett_Type
and Tradeqty <> 0
and I.Party_Code = T.PartyCode
and I.Party_Code =  C2.Party_Code
and C1.Cl_Code = C2.Cl_CodeAnd C2.Dummy6 = 'FT' And C1.Cl_type ='INS'
And C2.CltDpNo = C.custodiancode
And S1.Co_Code = S2.Co_Code
And S2.Series = S1.Series
And S2.SCRIP_CD = I.Scrip_CD
And S2.Series = I.Series
And I.Party_code = U.Party_code
and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)
And C.DpId Between @FromCp And @ToCp      
And CustodianCode Between @FromCustodian And @ToCustodian      
Group By I.Party_code,I.ContractNo,I.scrip_cd, Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8), 
Left(Replace(Replace(Replace(Convert(Varchar,convert(datetime, 
	Case when ltrim(rtrim(@SettlementDate)) = '' then 
	S.Sec_Payout else 
	@SettlementDate end),120),'-',''),':',''),' ',''),8),
I.Sett_No, I.Sell_Buy, I.Sett_Type, M.Isin, S.Start_date, O.MemberCode, Addr1, Addr2, C1.Long_Name,s1.short_name,
C1.L_Address1,C1.L_Address2,C1.L_Address3,C1.FD_CODE,T.brokerage,Service_chrg,Dummy7,
pan_gir_no, C.DpId,U.mapidid, U.Ucc_code,CounterParty,C.SebiRegNo, insurance_chrg, I.SERIES

UNION ALL

Select
BrokerSebiRegNo = @BrokerSebiRegNo,
CustodianCode = isnull(C.SebiRegNo,0),
ContractType = 'A',
ExchangeCode = (Case When @ExchangeCode='NSE' Then '23' When @ExchangeCode='BSE' Then '01' Else '' End),  
ContractNo = LTrim(RTrim(i.contractno)), 
MsgPrepDate = Left(Replace(Replace(Replace(Convert(Varchar,getdate(),120),'-',''),':',''),' ',''),8), 
settdate =
Left(Replace(Replace(Replace(Convert(Varchar,convert(datetime, 
	Case when ltrim(rtrim(@SettlementDate)) = '' then 
	S.Sec_Payout else 
	@SettlementDate end),120),'-',''),':',''),' ',''),8),
TradeDate = Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8), 
TradeRate = CONVERT(VARCHAR,CONVERT(NUMERIC(18,4),round((Sum(I.MarketRate * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)),4))), 
brokpershare=
Convert
(
	NUMERIC(18,4),
	Case When Sum(I.Tradeqty) > 0 Then
	(
		CONVERT(NUMERIC(18,4),round((Case When Service_chrg = 1 
		Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))
		Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))
		End),4))/Sum(I.Tradeqty)
	)
	Else
	0
	End
),
ExchangeID = (Case When @ExchangeCode='NSE' Then '100013573' When @ExchangeCode='BSE' Then '100002519' Else '' End),
ExchangeClearingHouse = @BrokerSebiRegNo, 
TradeFlag=(Case When I.Sell_Buy=1 Then 'BUYI' Else 'SELL' End),
TradePayment = 'APMT', 
ClientName = Left(LTrim(RTrim(c1.long_name)), 100),
ClientSEBINumber = replace(c1.fd_code,'/',''),
CpCode= left((Case when RTrim(LTrim(U.Mapidid))<>'' then RTrim(LTrim(U.Mapidid))else RTrim(LTrim(U.Ucc_code)) end),12),
Qty=Sum(I.Tradeqty),
IsinDetails = M.Isin,
ScripDetails = '',
Sett_Type = (Case
	         When  I.Sett_Type in( 'N', 'D') Then (CASE WHEN I.SERIES = 'IL' THEN 'DI' ELSE 'DR' END) 
		 When  I.Sett_Type in( 'W', 'C') Then 'TT' 
	         When  I.Sett_Type in ('A', 'AD') Then 'AR' Else 'OT' End), 
Sett_No = (Case When @ExchangeCode = 'NSE' 
		Then  I.Sett_No 
		Else (Case When Convert(int,Month(Start_Date)) < 4 
		                 Then '0' + Convert(Varchar,Right(Convert(int,Year(Start_Date)),2) - 1) + Right(Convert(int,Year(Start_Date)),2) 
	      		    Else Right(Convert(int,Year(Start_Date)),2) + '0' + Convert(Varchar,Right(Convert(int,Year(Start_Date)),2) + 1) 
 	     	         End) 
		        + Right(I.Sett_no,3)  
	     End ),
BuySellBroker=(Case When I.Sell_Buy=1 Then 'SELL' Else 'BUYR' End),
AgentType=(Case When I.Sell_Buy=1 Then 'DEAG' Else 'REAG' End),
TradeAmount=CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))*Sum(I.Tradeqty),4))), 
Brokerage = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Service_chrg = 1 
                      Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))
      		 Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))
                     End),4))), 
ServiceTax = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Service_chrg = 0 
                   Then Sum(I.Service_tax) 
	                   Else 0
                   End),4))), 
NetSettAmount = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Sell_Buy = 1 
		 Then (Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)) * Sum(I.Tradeqty)
		      + (Case When Service_chrg = 1 
                              Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))
			      Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))
                     	 End)
		      + (Case When Service_chrg = 0 
                                Then Sum(I.Service_tax) 
	                   Else 0
                         End) 
					+ (case when insurance_chrg = 1 then sum(ins_chrg) else 0 end)		/*FOR STT*/

		 Else (Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)) * Sum(I.Tradeqty) 
		      - (Case When Service_chrg = 1 
                              Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))
			      Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))
       	 End)
		      - (Case When Service_chrg = 0 
                                Then Sum(I.Service_tax) 
	                   Else 0
                         End) 
					- (case when insurance_chrg = 1 then sum(ins_chrg) else 0 end)		/*FOR STT*/
		End ),4))),

Detail=(Case When Dummy7 = 0 Then 'Y' Else 'N' End),
I.Party_code,
I.scrip_cd,
ins_chrg = round(round(sum((case when insurance_chrg = 1 then ins_chrg else 0 end)), 0 , 1), 4)

From settlement I, Multiisin M, Sett_Mst S, Owner O, Client1 C1, Client2 C2, Custodian C,  instclient_tbl T, scrip1 s1, scrip2 s2, Ucc_Client U
Where ContractNo Between @@FromContract and @@ToContract and Sauda_Date Like @FromDate + '%'  
and I.Party_Code Between @@FromParty and @@ToParty and I.Scrip_Cd = M.Scrip_Cd 
and M.Series = (Case When I.Series = 'BL' Then 'EQ' 
                     When I.Series = 'IL' Then 'EQ' 
                     Else I.Series
                End)
and M.Valid=1 and I.Sett_no = S.Sett_No and I.Sett_type = S.Sett_Type and Tradeqty <> 0 and I.Party_Code = T.PartyCode
and I.Party_Code =  C2.Party_Code and C1.Cl_Code = C2.Cl_Code And C2.Dummy6 = 'FT' And C1.Cl_type ='INS'
And C2.CltDpNo = C.custodiancode
And S1.Co_Code = S2.Co_Code
And S2.Series = S1.Series And S2.SCRIP_CD = I.Scrip_CD And S2.Series = I.Series
And I.Party_code = U.Party_code
and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)
And C.DpId Between @FromCp And @ToCp      
And CustodianCode Between @FromCustodian And @ToCustodian
Group By I.Party_code,I.ContractNo,I.scrip_cd, Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8), 
Left(Replace(Replace(Replace(Convert(Varchar,convert(datetime, 
	Case when ltrim(rtrim(@SettlementDate)) = '' then 
	S.Sec_Payout else 
	@SettlementDate end),120),'-',''),':',''),' ',''),8),
I.Sett_No, I.Sell_Buy, I.Sett_Type, M.Isin, S.Start_date, O.MemberCode, Addr1, Addr2, C1.Long_Name,s1.short_name,
C1.L_Address1,C1.L_Address2,C1.L_Address3,C1.FD_CODE,T.brokerage,Service_chrg,Dummy7,
pan_gir_no, C.DpId,U.mapidid, U.Ucc_code,CounterParty,C.SebiRegNo, insurance_chrg,I.SERIES

Order By CpCode

GO
