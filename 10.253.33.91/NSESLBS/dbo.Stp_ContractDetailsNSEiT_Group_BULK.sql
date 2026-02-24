-- Object: PROCEDURE dbo.Stp_ContractDetailsNSEiT_Group_BULK
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE              Proc Stp_ContractDetailsNSEiT_Group_BULK
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
@Remark Varchar(210),
@GroupCode Varchar(10)
As

Declare
@@FromParty Varchar(10),
@@ToParty Varchar(10),
@@FromContract Varchar(7),
@@ToContract Varchar(7)

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

Select Header = @BatchNo,  '15', LineNo1= '*****', InstructionType = '515',  InstrumentType='1',
CustodianCode = '1'+ Isnull(Replace(c1.Fd_Code,'/',''),'')/*(case when @BrokerSebiRegNo <> '' then '1'+ Isnull(C.DpId,'') else '2' + Isnull(C.DpId,'') end)*/,
ContractNo = (Case When @ExchangeCode='NSE' Then 'A23'+ Ltrim(Rtrim(I.ContractNo)) When @ExchangeCode='BSE' Then 'A01'+ Ltrim(Rtrim(I.ContractNo)) Else '' End),
CNDate = Left(Replace(Replace(Replace(Convert(Varchar,Min(I.Sauda_date),120),'-',''),':',''),' ',''),8) ,
MessageType='1',  PrevRefNo = '',
--SettDate = Left(Replace(Replace(Replace(Convert(Varchar,S.Sec_Payout,120),'-',''),':',''),' ',''),8),
--SettDate = 
--(Case when ltrim(rtrim(@SettlementDate)) = '' then  
--	Left(Replace(Replace(Replace(Convert(Varchar,S.Sec_Payout,120),'-',''),':',''),' ',''),8) else  
--	Left(Replace(Replace(Replace(Convert(Varchar,Convert(datetime,@SettlementDate),120),'-',''),':',''),' ',''),8) end ), 
settdate =
Left(Replace(Replace(Replace(Convert(Varchar,convert(datetime, 
	Case when ltrim(rtrim(@SettlementDate)) = '' then 
	S.Sec_Payout else 
	@SettlementDate end),120),'-',''),':',''),' ',''),8),

order_conf_time = Right('00000000000000' + Replace(Replace(Replace(convert(varchar, Min(sauda_date), 120), '-', ''), ' ', ''), ':', ''), 14),
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

BrokerSebiRegNo = @BrokerSebiRegNo, ExchangeCode = (Case When @ExchangeCode='NSE' Then '23' When @ExchangeCode='BSE' Then '1' Else '' End),  
TradeFlag=(Case When I.Sell_Buy=1 Then 'B' Else 'S' End), 
PaymentIndicator = '1',
ClientDetails =left(Replace(c1.Fd_Code,'/',''),12)/*left(case when  c1.Fd_Code <> '' then ( C1.Long_Name + ',' + Replace(I.Party_code,'ZUT','UT') + ',' + c1.Fd_Code + ','+ ltrim(rtrim(C1.L_Address1)) + ','+ ltrim(rtrim(C1.L_Address2)) + ','+ ltrim(rtrim(C
1.L_Address3))) else ( C1.Long_Name + ',' + Replace(I.Party_code,'ZUT','UT') + ','
  + pan_gir_no + ','+ ltrim(rtrim(C1.L_Address1)) + ','+ ltrim(rtrim(C1.L_Address2)) + ','+ ltrim(rtrim(C1.L_Address3)))  end,140)*/,
CpCode= left((Case when RTrim(LTrim(U.Mapidid))<>'' then left(RTrim(LTrim(U.Mapidid)),10)else RTrim(LTrim(U.Ucc_code)) end),10),
Qty=Sum(I.Tradeqty), IsinDetails = left(M.Isin + '~' + LTrim(RTrim(s1.short_name)),118), ScripDetails = '',
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
MemberCode = (case when @BrokerSebiRegNo <> '' then '1'+ @BrokerSebiRegNo else '2' + @MemberCode end), 
TMAddress = left(rtrim(ltrim(Addr1)) + rtrim(ltrim(Addr2)),140), CounterParty='1'+CounterParty, 
TradeAmount = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))*Sum(I.Tradeqty),4))), 
Brokerage = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Service_chrg = 1 
                      Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))
      		 Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))
                     End),4))), 
ServiceTax = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Service_chrg = 0 
                   Then Sum(I.Service_tax) 
	                   Else 0
                   End),4))), 
Ins_Chrg = CONVERT(VARCHAR,CONVERT(NUMERIC(18,0),round((Case When Insurance_chrg = 1 
                   Then Round(Sum(I.Ins_Chrg),0)
	                   Else 0
                   End),4))), 
SettAmount = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Sell_Buy = 1 
		 Then (Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)) * Sum(I.Tradeqty)
		      + (Case When Service_chrg = 1 
                              Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))
			      Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))
                     	 End)
		      + (Case When Service_chrg = 0 
                                Then Sum(I.Service_tax) 
	                   Else 0
                         End) + (Case When Insurance_chrg = 1 
                                Then Round(Sum(I.Ins_Chrg),0)
	                   Else 0
                         End) 
		 Else (Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)) * Sum(I.Tradeqty) 
		      - (Case When Service_chrg = 1 
                              Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))
			      Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))
                     	 End)
		      - (Case When Service_chrg = 0 
                                Then Sum(I.Service_tax) 
	                   Else 0
                         End) - (Case When Insurance_chrg = 1 
                                Then Round(Sum(I.Ins_Chrg),0)
	                   Else 0
                         End) 
		End ),4))),

remarks = @Remark, 
I.Sett_No,Detail=(Case When Dummy7 = 0 Then 'Y' Else 'N' End),I.party_code,I.scrip_cd
From Isettlement I, Multiisin M, Sett_Mst S, Owner O, Client1 C1, Client2 C2, Custodian C,  instclient_tbl T, scrip1 s1, scrip2 s2, Ucc_Client U
Where ContractNo Between @@FromContract and @@ToContract and Sauda_Date Like @FromDate + '%'  
and I.Party_Code Between @@FromParty and @@ToParty and I.Scrip_Cd = M.Scrip_Cd 
and M.Series = (Case When I.Series = 'BL' Then 'EQ' 
                     When I.Series = 'IL' Then 'EQ' 
                     Else I.Series
                End)
and M.Valid=1 and 
I.Sett_no = S.Sett_No and I.Sett_type = S.Sett_Type and Tradeqty <> 0 and I.Party_Code = T.PartyCode
and I.Party_Code =  C2.Party_Code and C1.Cl_Code = C2.Cl_Code And C2.Dummy6 = 'NSEIT' and C1.Cl_Type = 'INS'
And C2.CltDpNo = C.custodiancode
And S1.Co_Code = S2.Co_Code
And S2.Series = S1.Series And S2.SCRIP_CD = I.Scrip_CD And S2.Series = I.Series
And I.Party_code = U.Party_code
and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)
Group By I.Party_code,I.ContractNo,I.scrip_cd, Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8), 
--Left(Replace(Replace(Replace(Convert(Varchar,S.Sec_Payout,120),'-',''),':',''),' ',''),8),

Left(Replace(Replace(Replace(Convert(Varchar,convert(datetime, 
	Case when ltrim(rtrim(@SettlementDate)) = '' then 
	S.Sec_Payout else 
	@SettlementDate end),120),'-',''),':',''),' ',''),8),

I.Sett_No, I.Sell_Buy, I.Sett_Type, M.Isin, S.Start_date, O.MemberCode, Addr1, Addr2, C1.Long_Name,s1.short_name,
C1.L_Address1,C1.L_Address2,C1.L_Address3,C1.FD_CODE,T.brokerage,Service_chrg,Dummy7,
pan_gir_no, C.DpId,U.mapidid, U.Ucc_code,CounterParty,  Insurance_Chrg,I.SERIES

union all

Select Header = @BatchNo,  '15', LineNo1= '*****', InstructionType = '515',  InstrumentType='1',
CustodianCode = '1'+ Isnull(Replace(c1.Fd_Code,'/',''),'')/* (case when @BrokerSebiRegNo <> '' then '1'+ Isnull(C.DpId,'') else '2' + Isnull(C.DpId,'') end)*/,
ContractNo = (Case When @ExchangeCode='NSE' Then 'A23'+ Ltrim(Rtrim(I.ContractNo)) When @ExchangeCode='BSE' Then 'A01'+ Ltrim(Rtrim(I.ContractNo)) Else '' End),
CNDate = Left(Replace(Replace(Replace(Convert(Varchar,Min(I.Sauda_date),120),'-',''),':',''),' ',''),8),
MessageType='1',  PrevRefNo = '',
settdate =
Left(Replace(Replace(Replace(Convert(Varchar,convert(datetime, 
	Case when ltrim(rtrim(@SettlementDate)) = '' then 
	S.Sec_Payout else 
	@SettlementDate end),120),'-',''),':',''),' ',''),8),

order_conf_time = Right('00000000000000' + Replace(Replace(Replace(convert(varchar, Min(sauda_date), 120), '-', ''), ' ', ''), ':', ''), 14),
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
BrokerSebiRegNo = @BrokerSebiRegNo, ExchangeCode = (Case When @ExchangeCode='NSE' Then '23' When @ExchangeCode='BSE' Then '1' Else '' End),  
TradeFlag=(Case When I.Sell_Buy=1 Then 'B' Else 'S' End), 
PaymentIndicator = '2',
ClientDetails =left(Replace(c1.Fd_Code,'/',''),12)/*left(case when  c1.Fd_Code <> '' then ( C1.Long_Name + ',' + Replace(I.Party_code,'ZUT','UT') + ',' + c1.Fd_Code + ','+ ltrim(rtrim(C1.L_Address1)) + ','+ ltrim(rtrim(C1.L_Address2)) + ','+ ltrim(rtrim(C
1.L_Address3))) else ( C1.Long_Name + ',' + Replace(I.Party_code,'ZUT','UT') + ','
  + pan_gir_no + ','+ ltrim(rtrim(C1.L_Address1)) + ','+ ltrim(rtrim(C1.L_Address2)) + ','+ ltrim(rtrim(C1.L_Address3)))  end,140)*/,
CpCode= left((Case when RTrim(LTrim(U.Mapidid))<>'' then left(RTrim(LTrim(U.Mapidid)),10)else RTrim(LTrim(U.Ucc_code)) end),10),
Qty=Sum(I.Tradeqty), IsinDetails = left(M.Isin + '~' + LTrim(RTrim(s1.short_name)),118),  ScripDetails = '',
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
	     End ), MemberCode = (case when @BrokerSebiRegNo <> '' then '1'+ @BrokerSebiRegNo else '2' + @MemberCode end), 
TMAddress = left(rtrim(ltrim(Addr1)) + rtrim(ltrim(Addr2)),140), CounterParty='1'+@BrokerSebiRegNo, 
TradeAmount=CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))*Sum(I.Tradeqty),4))), 
Brokerage = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Service_chrg = 1 
                      Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))
      		 Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))
                     End),4))), 
ServiceTax = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Service_chrg = 0 
                   Then Sum(I.Service_tax) 
	                   Else 0
                   End),4))), 
Ins_Chrg = CONVERT(VARCHAR,CONVERT(NUMERIC(18,0),round((Case When Insurance_chrg = 1
                   Then Round(Sum(I.Ins_Chrg),0)
	                   Else 0
                   End),4))), 
SettAmount = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Sell_Buy = 1 
		 Then (Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)) * Sum(I.Tradeqty)
		      + (Case When Service_chrg = 1 
                              Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))
			      Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))
                     	 End)
		      + (Case When Service_chrg = 0 
                                Then Sum(I.Service_tax) 
	                   Else 0
                         End) + (Case When Insurance_chrg = 1 
                                Then Round(Sum(I.Ins_Chrg),0)
	                   Else 0
                         End) 
		 Else (Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)) * Sum(I.Tradeqty) 
		      - (Case When Service_chrg = 1 
                              Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))
			      Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))
                     	 End)
		      - (Case When Service_chrg = 0 
                                Then Sum(I.Service_tax) 
	                   Else 0
                         End) - (Case When Insurance_chrg = 1 
                                Then Round(Sum(I.Ins_Chrg),0)
	                   Else 0
                         End) 
		End ),4))),
remarks =@Remark, 
I.Sett_No,
Detail=(Case When Dummy7 = 0 Then 'Y' Else 'N' End),I.Party_code,I.scrip_cd
From settlement I, Multiisin M, Sett_Mst S, Owner O, Client1 C1, Client2 C2, Custodian C,  instclient_tbl T, scrip1 s1, scrip2 s2, Ucc_Client U
Where ContractNo Between @@FromContract and @@ToContract and Sauda_Date Like @FromDate + '%'  
and I.Party_Code Between @@FromParty and @@ToParty and I.Scrip_Cd = M.Scrip_Cd 
and M.Series = (Case When I.Series = 'BL' Then 'EQ' 
                     When I.Series = 'IL' Then 'EQ' 
                     Else I.Series
                End)
and M.Valid=1 and 
I.Sett_no = S.Sett_No and I.Sett_type = S.Sett_Type and Tradeqty <> 0 and I.Party_Code = T.PartyCode
and I.Party_Code =  C2.Party_Code and C1.Cl_Code = C2.Cl_Code And C2.Dummy6 = 'NSEIT' and C1.Cl_Type = 'INS'
And C2.CltDpNo = C.custodiancode
And S1.Co_Code = S2.Co_Code
And S2.Series = S1.Series And S2.SCRIP_CD = I.Scrip_CD And S2.Series = I.Series
And I.Party_code = U.Party_code
and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)
Group By I.Party_code,I.ContractNo,I.scrip_cd, Left(Replace(Replace(Replace(Convert(Varchar,Sauda_date,120),'-',''),':',''),' ',''),8), 
--Left(Replace(Replace(Replace(Convert(Varchar,S.Sec_Payout,120),'-',''),':',''),' ',''),8),
Left(Replace(Replace(Replace(Convert(Varchar,convert(datetime, 
	Case when ltrim(rtrim(@SettlementDate)) = '' then 
	S.Sec_Payout else 
	@SettlementDate end),120),'-',''),':',''),' ',''),8),
I.Sett_No, I.Sell_Buy, I.Sett_Type, M.Isin, S.Start_date, O.MemberCode, Addr1, Addr2, C1.Long_Name,s1.short_name,
C1.L_Address1,C1.L_Address2,C1.L_Address3,C1.FD_CODE,T.brokerage,Service_chrg,Dummy7,
pan_gir_no, C.DpId,U.mapidid, U.Ucc_code,CounterParty, Insurance_Chrg,I.SERIES
Order By I.Party_code,ContractNo,I.scrip_cd

GO
