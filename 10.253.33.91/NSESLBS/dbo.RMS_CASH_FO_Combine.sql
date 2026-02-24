-- Object: PROCEDURE dbo.RMS_CASH_FO_Combine
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc RMS_CASH_FO_Combine         
(        
@StatusId Varchar(20), @Statusname Varchar(25),        
@RMSDate Varchar(11), @FromCode Varchar(10),         
@ToCode Varchar(10), @RptType Varchar(1))        
As        
        
-- RMS_CASH_FO_Combine 'BROKER', 'BROKER', 'Mar  2 2006', '0', 'ZZZZ', 'F'        
-- RMS_CASH_FO_Combine 'BROKER', 'BROKER', 'OCT 13 2006', '15500045', '15500045', 'F'      
Declare         
@FromFamily Varchar(10),         
@ToFamily Varchar(10),        
@FromParty Varchar(10),         
@ToParty Varchar(10)        
        
Set @FromFamily = (Case When @RptType = 'P' Then '0' Else @FromCode End)        
Set @ToFamily = (Case When @RptType = 'P' Then 'ZZZZZZZZZZ' Else @ToCode End)        
Set @FromParty = (Case When @RptType = 'F' Then '0' Else @FromCode End)        
Set @ToParty = (Case When @RptType = 'F' Then 'ZZZZZZZZZZ' Else @ToCode End)        
        
Set Transaction Isolation level Read uncommitted        
Select Party_Code, Party_Name, FAMILY, FAMILYName, Branch_Cd, Sub_Broker, SubName=Convert(Varchar(100),''), Trader, Area, Region,         
CashSegMarg=round(((STOCKN*70/100) + (nb_ledger_voc_bal) + (tot_collateral_nb) - (payinafterhaircut*130/100))/100000,4),        
Fout=nb_ledger_voc_bal/100000, Fut_NetAmt = Convert(Numeric(18,4),0), Exposure = Convert(Numeric(18,4),0),        
FoNetCash = Convert(Numeric(18,4),0), Collateral = Convert(Numeric(18,4),0),         
IntialMargin = Convert(Numeric(18,4),0), MTMMargin = Convert(Numeric(18,4),0),
NETMARG , STOCKN = STOCKY, STOCKY = STOCKN, PAYINAFTERHAIRCUT
Into #RMSCombine        
From rmsallsegment With(Index(DateParty), NoLock)      
Where Sauda_Date like @RMSDate + '%'        
And Party_Code Between @FromParty And @ToParty        
And Family Between @FromFamily And @ToFamily        
And         
     @StatusName =         
          (case         
                when @StatusId = 'BRANCH' then branch_cd        
                when @StatusId = 'SUBBROKER' then sub_broker        
                when @StatusId = 'Trader' then Trader        
                when @StatusId = 'Family' then Family        
                when @StatusId = 'Area' then Area        
                when @StatusId = 'Region' then Region        
                when @StatusId = 'Client' then party_code        
          else         
                'BROKER'        
          End)        
        
Set Transaction Isolation level Read uncommitted        
Insert Into #RMSCombine         
Select Party_Code, Party_Name, FAMILY, FAMILYName, Branch_Code, Sub_Broker, SubName=Convert(Varchar(100),''), Trader, Area, Region,        
CashSegMarg = Convert(Numeric(18,4),0),Fout=Convert(Numeric(18,4),0),        
Fut_NetAmt=Sum(Fut_LongAmt+Fut_ShortAmt), Exposure=Sum(Fut_LongAmt+Fut_ShortAmt+CA_ShortAmt+PA_ShortAmt),        
FoNetCash = Convert(Numeric(18,4),0), Collateral = Convert(Numeric(18,4),0),         
IntialMargin = Convert(Numeric(18,4),0), MTMMargin = Convert(Numeric(18,4),0),
NETMARG = 0, STOCKN = 0, STOCKY = 0, PAYINAFTERHAIRCUT = 0
From (        
Select Party_Code, Party_Name, FAMILY, FAMILYName, Branch_Code, Sub_Broker, Trader, Area, Region,        
Inst_Type,symbol,ExpiryDate=convert(varchar(11),expirydate,109) ,Strike_Price,Option_Type,cmclosing,        
Fut_LongAmt=(Case When sum(case when inst_type like 'FUT%' Then PQty - SQty else 0 End) > 0         
     Then sum(case when inst_type like 'FUT%' Then (((PQty - SQty)*CMClosing)/100000) else 0 End) Else 0 End) ,        
Fut_ShortAmt=(Case When sum(case when inst_type like 'FUT%' then PQty - SQty else 0 End) < 0         
     Then sum(case when inst_type like 'FUT%' then (((SQty - PQty)*CMClosing)/100000) else 0 End) Else 0 End),        
CA_ShortAmt=(Case When sum(case when (inst_type like 'OPT%' and option_type like 'C%') then PQty - SQty else 0 End) < 0         
          Then sum(case when (inst_type like 'OPT%' and option_type like 'C%') then (((SQty - PQty)*CMClosing)/100000) else 0 End)         
   Else 0 End),        
PA_ShortAmt=(Case When sum(case when (inst_type like 'OPT%' and option_type like 'P%') then PQty - SQty else 0 End) < 0         
          Then sum(case when (inst_type like 'OPT%' and option_type like 'P%') then (((SQty - PQty)*CMClosing)/100000) else 0 End)         
   Else 0 End)      From NSEFO.DBO.FoBillValan With(Index(FoBill), NoLock)        
Where Sauda_date like @RMSDate + '%'        
And Party_Code Between @FromParty And @ToParty        
And Family Between @FromFamily And @ToFamily        
And         
     @StatusName =         
          (case         
                when @StatusId = 'BRANCH' then branch_code        
                when @StatusId = 'SUBBROKER' then sub_broker        
                when @StatusId = 'Trader' then Trader        
                when @StatusId = 'Family' then Family        
                when @StatusId = 'Area' then Area        
                when @StatusId = 'Region' then Region        
                when @StatusId = 'Client' then party_code        
          else         
                'BROKER'        
          End)        
and CMClosing > 0        
group by Party_Code, Party_Name, FAMILY, FAMILYName, Branch_Code, Sub_Broker, Trader, Area, Region,        
Inst_Type,symbol,convert(varchar(11),expirydate,109) ,Strike_Price,Option_Type,cmclosing ) A        
Group By Party_Code, Party_Name, FAMILY, FAMILYName, Branch_Code, Sub_Broker, Trader, Area, Region        
        
Set Transaction Isolation level Read uncommitted        
Insert Into #RMSCombine        
Select T.Party_Code, Party_Name=T.Long_Name, T.FAMILY, FAMILYName='', T.Branch_Cd, T.Sub_Broker, SubName=Convert(Varchar(100),''), T.Trader, Area=C1.Area, Region=C1.Region,        
CashSegMarg = Convert(Numeric(18,4),0),Fout=Convert(Numeric(18,4),0),        
Fut_NetAmt = Convert(Numeric(18,4),0), Exposure = Convert(Numeric(18,4),0),        
FoNetCash=(BillAmount+LedgerAmount)/100000, Collateral = (Cash_Coll+NonCash_Coll)/100000,         
IntialMargin=Initialmargin/100000, MTMMargin=MTMMargin/100000,
NETMARG = 0, STOCKN = 0, STOCKY = 0, PAYINAFTERHAIRCUT = 0         
From NSEFO.DBO.TBL_ClientMargin T With(Index(PartyDate), NoLock), NSEFO.DBO.Client1 C1, NSEFO.DBO.Client2 C2        
Where C1.Cl_Code = C2.Cl_Code        
And C2.Party_Code = T.Party_Code        
And MarginDate Like @RMSDate + '%'        
And T.Party_Code Between @FromParty And @ToParty        
And T.Family Between @FromFamily And @ToFamily        
And         
     @StatusName =         
          (case         
                when @StatusId = 'BRANCH' then T.Branch_Cd        
                when @StatusId = 'SUBBROKER' then T.sub_broker        
                when @StatusId = 'Trader' then T.Trader        
                when @StatusId = 'Family' then T.Family        
                when @StatusId = 'Area' then c1.Area        
                when @StatusId = 'Region' then c1.Region        
                when @StatusId = 'Client' then T.party_code        
          else         
                'BROKER'        
          End)        
  
Update #RMSCombine Set Party_Name = C1.Long_Name, Branch_Cd = C1.Branch_Cd, Sub_Broker = C1.Sub_Broker, Family = C1.Family        
From NSEFO.DBO.Client1 C1, NSEFO.DBO.Client2 C2        
Where C1.Cl_Code = C2.Cl_Code        
And C2.Party_Code = #RMSCombine.Party_Code        
        
Update #RMSCombine Set FamilyName = C1.Long_Name, Sub_Broker = C1.Sub_Broker, Branch_Cd = C1.Branch_Cd       
From NSEFO.DBO.Client1 C1, NSEFO.DBO.Client2 C2        
Where C1.Cl_Code = C2.Cl_Code        
And C2.Party_Code = #RMSCombine.Family  
  
Update #RMSCombine Set Party_Name = C1.Long_Name, Branch_Cd = C1.Branch_Cd, Sub_Broker = C1.Sub_Broker, Family = C1.Family        
From Client1 C1, Client2 C2        
Where C1.Cl_Code = C2.Cl_Code        
And C2.Party_Code = #RMSCombine.Party_Code        
        
Update #RMSCombine Set FamilyName = C1.Long_Name, Sub_Broker = C1.Sub_Broker, Branch_Cd = C1.Branch_Cd       
From Client1 C1, Client2 C2        
Where C1.Cl_Code = C2.Cl_Code        
And C2.Party_Code = #RMSCombine.Family        
        
Update #RMSCombine Set SubName = Name        
From SubBrokers        
Where SubBrokers.Sub_Broker = #RMSCombine.Sub_Broker        
        
If @RptType = 'P'         
Begin        
 Select Party_Code, Party_Name, Branch_Cd, Sub_Broker, SubName,      
 CashSegMarg=Sum(CashSegMarg), FoNetCash=Sum(FoNetCash), Collateral=Sum(Collateral),         
 TotalMargin = Sum(CashSegMarg + FoNetCash + Collateral),         
 IntialMargin = Sum(IntialMargin), MTMMargin = Sum(MTMMargin), MarginReq = Sum(IntialMargin + MTMMargin),        
 NetCollectable = Sum(CashSegMarg + FoNetCash + Collateral) - Sum(IntialMargin + MTMMargin),        
 Fut_NetAmt = Sum(Fut_NetAmt), Exposure = Sum(Exposure), Fout = Sum(Fout),         
 TotalLedBal = Sum(FoNetCash + Fout),
 NETMARG = Sum(NETMARG)/100000, STOCKN = Sum(STOCKN)/100000, 
 STOCKY = Sum(STOCKY)/100000, PAYINAFTERHAIRCUT = Sum(PAYINAFTERHAIRCUT)/100000
 From #RMSCombine      
 Group By Party_Code, Party_Name, Branch_Cd, Sub_Broker, SubName        
 HAVING NOT (Sum(Collateral) <= 0.005 AND Sum(IntialMargin + MTMMargin) <= 0.005
 AND Sum(FoNetCash + Fout) >= -0.005 AND Sum(FoNetCash + Fout) <= 0.005 AND SUM(NETMARG) <= 500
 AND Sum(STOCKN) <= 500 AND Sum(STOCKY) <= 500 AND Sum(PAYINAFTERHAIRCUT) <= 500)
 Order By Party_Code
      
End        
Else        
Begin        
 Select Family, FamilyName, Branch_Cd, Sub_Broker, SubName,      
 CashSegMarg=Sum(CashSegMarg), FoNetCash=Sum(FoNetCash), Collateral=Sum(Collateral),         
 TotalMargin = Sum(CashSegMarg + FoNetCash + Collateral),         
 IntialMargin = Sum(IntialMargin), MTMMargin = Sum(MTMMargin), MarginReq = Sum(IntialMargin + MTMMargin),        
 NetCollectable = Sum(CashSegMarg + FoNetCash + Collateral) - Sum(IntialMargin + MTMMargin),        
 Fut_NetAmt = Sum(Fut_NetAmt), Exposure = Sum(Exposure), Fout = Sum(Fout),         
 TotalLedBal = Sum(FoNetCash + Fout),
 NETMARG = Sum(NETMARG)/100000, STOCKN = Sum(STOCKN)/100000, 
 STOCKY = Sum(STOCKY)/100000, PAYINAFTERHAIRCUT = Sum(PAYINAFTERHAIRCUT)/100000
 From #RMSCombine      
 Group By Family, FamilyName, Branch_Cd, Sub_Broker, SubName        
 HAVING NOT (Sum(Collateral) <= 0.005 AND Sum(IntialMargin + MTMMargin) <= 0.005
 AND Sum(FoNetCash + Fout) >= -0.005 AND Sum(FoNetCash + Fout) <= 0.005 AND SUM(NETMARG) <= 500
 AND Sum(STOCKN) <= 500 AND Sum(STOCKY) <= 500 AND Sum(PAYINAFTERHAIRCUT) <= 500)
 Order By Family
End

GO
