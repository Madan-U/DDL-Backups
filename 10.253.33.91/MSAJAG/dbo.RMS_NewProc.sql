-- Object: PROCEDURE dbo.RMS_NewProc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc [dbo].[RMS_NewProc] (@RMSDate Varchar(11), @FromParty Varchar(10), @ToParty Varchar(10), @HairCut Numeric(18,4))
AS

Set NoCount On 

/*Select @FromParty=Min(Party_Code), @ToParty=Max(Party_Code) From ClientMaster*/

Exec rpt_GrossExposureNew @FromParty,@ToParty,@RMSDate,@RMSDate,'N','%','%'

Exec rpt_GrossExposureNew @FromParty,@ToParty,@RMSDate,@RMSDate,'W','%','%'

Exec AngelBSECM.BSEDB_ab.DBO.rpt_GrossExposureNew @FromParty,@ToParty,@RMSDate,@RMSDate,'D','%','%'
Exec AngelBSECM.BSEDB_ab.DBO.rpt_GrossExposureNew @FromParty,@ToParty,@RMSDate,@RMSDate,'C','%','%'

Exec RMS_NewDebitStock @RMSDate,@FromParty,@ToParty

Delete From RMSALLSEGMENT Where Sauda_Date Like @RMSDate + '%'
And Party_Code >= @FromParty And Party_Code <= @ToParty

Insert into RMSALLSEGMENT 
Select @RMSDate,BRANCH_CD,'','',Family,'',PARTY_CODE,Long_NAME,'NSE',
0,0,0,0,0,0,0,IsNull(Credit_Limit,0),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,@HairCut,0,0,0
From ClientMaster 
Where Party_Code >= @FromParty And Party_Code <= @ToParty

Update RMSALLSEGMENT Set NB_LEDGER_VOC_BAL = NB_LEDGER_VOC_BAL + Amt From (
select L.CltCode,Amt=Sum(Case When L.DrCr = 'D' Then -VAmt Else Vamt end) from Account.Dbo.Ledger L, Account.Dbo.Parameter, Account.Dbo.Acmast A
Where EDt <= @RMSDate + ' 23:59:59'
And Edt >= SdtCur And CurYear = 1 
And A.CltCode = L.CltCode And A.ACCAT <> 3

Group by L.CltCode ) A Where A.CltCode = RMSALLSEGMENT.PARTY_CODE
And Sauda_Date Like @RMSDate + '%' 
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set NB_LEDGER_EFF_BAL = IsNull(Amt,0) From (
select L.CltCode,Amt=Sum(Case When L.DrCr = 'D' Then -VAmt Else Vamt end) from Account.Dbo.Ledger L, Account.Dbo.Parameter, Account.Dbo.Acmast A
Where VDt <= @RMSDate + ' 23:59:59'
And Vdt >= SdtCur And CurYear = 1 
And A.CltCode = L.CltCode And A.ACCAT <> 3
And VTyp <> '2' 
Group by L.CltCode ) A Where A.CltCode = RMSALLSEGMENT.PARTY_CODE
And Sauda_Date Like @RMSDate + '%' 
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set NB_LEDGER_EFF_BAL = NB_LEDGER_EFF_BAL + IsNull(Amt,0) From (
select L.CltCode,Amt=Sum(Case When L.DrCr = 'D' Then -VAmt Else Vamt end) from Account.Dbo.Ledger L, Account.Dbo.Parameter, Account.Dbo.Acmast A
Where EDt <= @RMSDate + ' 23:59:59'
And Edt >= SdtCur And CurYear = 1 
And A.CltCode = L.CltCode And A.ACCAT <> 3
And VTyp = '2' 
Group by L.CltCode ) A Where A.CltCode = RMSALLSEGMENT.PARTY_CODE
And Sauda_Date Like @RMSDate + '%' 
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set NB_LEDGER_VOC_BAL = NB_LEDGER_VOC_BAL + Amt From (
select L.CltCode,Amt=Sum(Case When L.DrCr = 'D' Then -VAmt Else Vamt end) from AngelBSECM.Account_ab.Dbo.Ledger L, AngelBSECM.Account_ab.Dbo.Parameter, AngelBSECM.Account_ab.Dbo.Acmast A
Where EDt <= @RMSDate + ' 23:59:59'
And Edt >= SdtCur And CurYear = 1 
And A.CltCode = L.CltCode And A.ACCAT <> 3

Group by L.CltCode ) A Where A.CltCode = RMSALLSEGMENT.PARTY_CODE
And Sauda_Date Like @RMSDate + '%' 
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set NB_LEDGER_EFF_BAL = NB_LEDGER_EFF_BAL + IsNull(Amt,0) From (
select L.CltCode,Amt=Sum(Case When L.DrCr = 'D' Then -VAmt Else Vamt end) from AngelBSECM.Account_ab.Dbo.Ledger L, AngelBSECM.Account_ab.Dbo.Parameter, AngelBSECM.Account_ab.Dbo.Acmast A
Where VDt <= @RMSDate + ' 23:59:59'
And Vdt >= SdtCur And CurYear = 1 
And A.CltCode = L.CltCode And A.ACCAT <> 3
And VTyp <> '2' 
Group by L.CltCode ) A Where A.CltCode = RMSALLSEGMENT.PARTY_CODE
And Sauda_Date Like @RMSDate + '%' 
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set NB_LEDGER_EFF_BAL = NB_LEDGER_EFF_BAL + IsNull(Amt,0) From (
select L.CltCode,Amt=Sum(Case When L.DrCr = 'D' Then -VAmt Else Vamt end) from AngelBSECM.Account_AB.Dbo.Ledger L, Account.Dbo.Parameter, AngelBSECM.Account_Ab.Dbo.Acmast A
Where EDt <= @RMSDate + ' 23:59:59'
And Edt >= SdtCur And CurYear = 1 
And A.CltCode = L.CltCode And A.ACCAT <> 3
And VTyp = '2' 
Group by L.CltCode ) A Where A.CltCode = RMSALLSEGMENT.PARTY_CODE
And Sauda_Date Like @RMSDate + '%' 
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set TOT_COLLATERAL_NB = EffectiveColl,CASH_DEPOSIT=ActualCash,NON_CASH=ActualNonCash From Collateral 
Where Trans_Date Like @RMSDate + '%' And Collateral.Party_Code = RMSALLSEGMENT.Party_Code
And Collateral.Segment = 'CAPITAL'
And Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set N_Prev_GE = IsNull(( Select Sum(PRate+SRate) from CmBillValan C
where C.Sauda_date like (select Left(Convert(Varchar,max(sauda_date),109),11)+'%' from CmBillValan
   		       where sauda_date < @RMSDate
		       and party_code = C.Party_Code)
                       and C.Party_code = RMSALLSEGMENT.Party_Code ),0)
Where sauda_date Like @RMSDate + '%' 
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set N_TURNOVER = TotTurn, N_TRDTURNOVER = TrdTurn, N_DELTURNOVER = DelTurn
From ( Select C.Party_Code,TotTurn=IsNull(Sum(TRDAMT),0), TrdTurn=IsNull(Sum(TRDAMT-DELAMT),0), 
       DelTurn=IsNull(Sum(DELAMT),0) 
       From CMBillValan C Where C.sauda_date Like @RMSDate + '%' 
       Group By Party_Code ) A
Where sauda_date Like @RMSDate + '%' And A.Party_Code = RMSALLSEGMENT.Party_Code
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set B_TURNOVER = TotTurn, B_TRDTURNOVER = TrdTurn, B_DELTURNOVER = DelTurn
From ( Select C.Party_Code,TotTurn=IsNull(Sum(TRDAMT),0), TrdTurn=IsNull(Sum(TRDAMT-DELAMT),0), 
       DelTurn=IsNull(Sum(DELAMT),0) 
       From AngelBSECM.BSEDB_ab.DBO.CMBillValan C Where C.sauda_date Like @RMSDate + '%' 
       Group By Party_Code ) A
Where sauda_date Like @RMSDate + '%' And A.Party_Code = RMSALLSEGMENT.Party_Code
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set B_Prev_GE = IsNull(( Select Sum(PRate+SRate) from AngelBSECM.BSEDB_ab.DBO.CmBillValan C
where C.Sauda_date like (select Left(Convert(Varchar,max(sauda_date),109),11)+'%' from AngelBSECM.BSEDB_ab.DBO.CmBillValan
   		         where sauda_date < @RMSDate
		         and party_code = C.Party_Code )
                         and C.Party_code = RMSALLSEGMENT.Party_Code ),0)
Where sauda_date Like @RMSDate + '%' 
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Truncate Table RMSMTOM
Insert Into RMSMTOM
Select S.Party_Code,S.Scrip_Cd,S.Series,NSE_MTM=(Sum(PQtyTrd+PQtyDel)*Isnull(Max(Cl_Rate),0)-Sum(PRate))+ (Sum(SRate)-Sum(SQtyTrd+SQtyDel)*Isnull(Max(Cl_Rate),0)),
NSENET=SUM(PRate+SRate),  
CurrGE=(Case When Sum(Case When S.Sauda_Date Like @RMSDate + '%' Then PQtyTrd+PQtyDel Else 0 End) >
                  Sum(Case When S.Sauda_Date Like @RMSDate + '%' Then SQtyTrd+SQtyDel Else 0 End) 
             Then Sum(Case When S.Sauda_Date Like @RMSDate + '%' Then PRate Else 0 End) - 
                  Sum(Case When S.Sauda_Date Like @RMSDate + '%' Then SRate Else 0 End) Else 0 End)
      +(Case When Sum(Case When S.Sauda_Date Like @RMSDate + '%' Then SQtyTrd+SQtyDel Else 0 End) >
                  Sum(Case When S.Sauda_Date Like @RMSDate + '%' Then PQtyTrd+PQtyDel Else 0 End) 
             Then Sum(Case When S.Sauda_Date Like @RMSDate + '%' Then SRate Else 0 End) - 
                  Sum(Case When S.Sauda_Date Like @RMSDate + '%' Then PRate Else 0 End) Else 0 End),
NsePur=(Case When Sum(PQtyTrd+PQtyDel) > Sum(SQtyTrd+SQtyDel) Then Sum(PRate)-Sum(SRate) Else 0 End),
NseSale=(Case When Sum(SQtyTrd+SQtyDel) > Sum(PQtyTrd+PQtyDel) Then Sum(SRate)-Sum(PRate) Else 0 End),
TotalGe=Sum(PRate)-Sum(SRate) 
From Sett_Mst SM, RMSALLSEGMENT R,CMBillValan S Left Outer Join Closing C
On ( C.Scrip_Cd = S.Scrip_Cd And C.Series = S.Series And 
C.SysDate = ( Select Max(SysDate) From Closing Where Scrip_Cd = S.Scrip_Cd And Series = S.Series And 
SysDate <= @RMSDate + ' 23:59:00'))
Where S.Sett_No = SM.Sett_No And S.Sett_Type = SM.Sett_Type 
And S.Sauda_Date <= @RMSDate + ' 23:59:59' And funds_payin > @RMSDate
And S.Party_Code = R.Party_Code And R.Sauda_Date Like @RMSDate + '%'
And R.PARTY_CODE >= @FromParty And R.PARTY_CODE <= @ToParty
Group By S.Party_Code,S.Scrip_Cd,S.Series 

Update RMSALLSEGMENT Set N_MTM = IsNull((Select Sum(NSE_MTM) From RMSMTOM Where RMSMTOM.Party_Code = RMSALLSEGMENT.Party_Code ),0)
where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set N_MTM_LOSS = IsNull((Select Sum(NSE_MTM) From RMSMTOM Where RMSMTOM.Party_Code = RMSALLSEGMENT.Party_Code And NSE_MTM < 0),0)
where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set N_Purch = IsNull((Select Sum(NSEPur) From RMSMTOM Where RMSMTOM.Party_Code = RMSALLSEGMENT.Party_Code ),0)
where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set N_Sales = IsNull((Select Sum(NSESale) From RMSMTOM Where RMSMTOM.Party_Code = RMSALLSEGMENT.Party_Code ),0)
where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set N_Net = IsNull((Select Sum(NSENet) From RMSMTOM Where RMSMTOM.Party_Code = RMSALLSEGMENT.Party_Code ),0)
where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set N_CURRENT_GE = IsNull((Select Sum(CurrGe) From RMSMTOM Where RMSMTOM.Party_Code = RMSALLSEGMENT.Party_Code ),0)
where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set N_Id_Exposure = IsNull((Select Sum(TotalGe)-N_Prev_Ge From RMSMTOM Where RMSMTOM.Party_Code = RMSALLSEGMENT.Party_Code ),0)
where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Truncate Table RMSMTOM
Insert Into RMSMTOM
Select S.Party_Code,S.Scrip_Cd,S.Series,
NSE_MTM=(Sum(PQtyTrd+PQtyDel)*Isnull(Max(Cl_Rate),0)-Sum(PRate)) + (Sum(SRate)-Sum(SQtyTrd+SQtyDel)*Isnull(Max(Cl_Rate),0)),
NSENET=SUM(PRate+SRate),  
CurrGE=(Case When Sum(Case When S.Sauda_Date Like @RMSDate + '%' Then PQtyTrd+PQtyDel Else 0 End) >
                  Sum(Case When S.Sauda_Date Like @RMSDate + '%' Then SQtyTrd+SQtyDel Else 0 End) 
             Then Sum(Case When S.Sauda_Date Like @RMSDate + '%' Then PRate Else 0 End) - 
                  Sum(Case When S.Sauda_Date Like @RMSDate + '%' Then SRate Else 0 End) Else 0 End)
      +(Case When Sum(Case When S.Sauda_Date Like @RMSDate + '%' Then SQtyTrd+SQtyDel Else 0 End) >
                  Sum(Case When S.Sauda_Date Like @RMSDate + '%' Then PQtyTrd+PQtyDel Else 0 End) 
             Then Sum(Case When S.Sauda_Date Like @RMSDate + '%' Then SRate Else 0 End) - 
                  Sum(Case When S.Sauda_Date Like @RMSDate + '%' Then PRate Else 0 End) Else 0 End),
NsePur=(Case When Sum(PQtyTrd+PQtyDel) > Sum(SQtyTrd+SQtyDel) Then Sum(PRate)-Sum(SRate) Else 0 End),
NseSale=(Case When Sum(SQtyTrd+SQtyDel) > Sum(PQtyTrd+PQtyDel) Then Sum(SRate)-Sum(PRate) Else 0 End),
TotalGe=Sum(PRate)-Sum(SRate)
From AngelBSECM.BSEDB_ab.DBO.Sett_Mst SM, RMSALLSEGMENT R, AngelBSECM.BSEDB_ab.DBO.CMBillValan S Left Outer Join AngelBSECM.BSEDB_ab.DBO.Closing C
On ( C.Scrip_Cd = S.Scrip_Cd And C.Series = S.Series And 
C.SysDate = ( Select Max(SysDate) From AngelBSECM.BSEDB_ab.DBO.Closing Where Scrip_Cd = S.Scrip_Cd And Series = S.Series And 
SysDate <= @RMSDate + ' 23:59:00'))
Where S.Sett_No = SM.Sett_No And S.Sett_Type = SM.Sett_Type 
And S.Sauda_Date <= @RMSDate + ' 23:59:59' And funds_payin > @RMSDate
And S.Party_Code = R.Party_Code And R.Sauda_Date Like @RMSDate + '%'
And TradeType Not Like 'SBF'
And R.PARTY_CODE >= @FromParty And R.PARTY_CODE <= @ToParty
Group By S.Party_Code,S.Scrip_Cd,S.Series,Cl_Rate 

Update RMSALLSEGMENT Set B_MTM = IsNull((Select Sum(NSE_MTM) From RMSMTOM Where RMSMTOM.Party_Code = RMSALLSEGMENT.Party_Code ),0)
where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set B_MTM_LOSS = IsNull((Select Sum(NSE_MTM) From RMSMTOM Where RMSMTOM.Party_Code = RMSALLSEGMENT.Party_Code And NSE_MTM < 0),0)
where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set B_Purch = IsNull((Select Sum(NSEPur) From RMSMTOM Where RMSMTOM.Party_Code = RMSALLSEGMENT.Party_Code ),0)
where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set B_Sales = IsNull((Select Sum(NSESale) From RMSMTOM Where RMSMTOM.Party_Code = RMSALLSEGMENT.Party_Code ),0)
where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set B_Net = IsNull((Select Sum(NSENet) From RMSMTOM Where RMSMTOM.Party_Code = RMSALLSEGMENT.Party_Code ),0)
where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set B_CURRENT_GE = IsNull((Select Sum(CurrGe) From RMSMTOM Where RMSMTOM.Party_Code = RMSALLSEGMENT.Party_Code ),0)
where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set B_Id_Exposure = IsNull((Select Sum(TotalGe)-B_Prev_Ge From RMSMTOM Where RMSMTOM.Party_Code = RMSALLSEGMENT.Party_Code ),0)
where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set N_AVM = Margin From (
Select Party_code,Margin=Sum(Margin) From (
Select Party_Code,Scrip_CD,Margin=Abs((Sum(BuyValue-SellValue)*Rate)/100) From TblGrossExpNewDetail
Where RunDate Like @RMSDate + '%'
Group By Party_Code,Scrip_Cd,Rate) A
Group By Party_Code ) B Where B.Party_Code = RMSALLSEGMENT.Party_Code
And Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set B_AVM = Margin From (
Select Party_code,Margin=Sum(Margin) From (
Select Party_Code,Scrip_CD,Margin=Abs((Sum(BuyValue-SellValue)*Rate)/100) From AngelBSECM.BSEDB_ab.DBO.TblGrossExpNewDetail
Where RunDate Like @RMSDate + '%'
Group By Party_Code,Scrip_Cd,Rate) A
Group By Party_Code ) B Where B.Party_Code = RMSALLSEGMENT.Party_Code
And Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set 
NSEDebitValue = DNSEDebitValue,
BSEDebitValue = DBSEDebitValue,
POAValue      = DPOAValue,
NSEPayIn      = DNSEPayIn,
BSEPayIn      = DBSEPayIn
From (
Select Party_Code,
DNSEDebitValue 	  = IsNull(Sum(Case When Branch_Cd = 'NSE' Then (DebitQty*Cl_Rate) Else 0 End),0),
DBSEDebitValue 	  = IsNull(Sum(Case When Branch_Cd = 'BSE' Then (DebitQty*Cl_Rate) Else 0 End),0),
DPOAValue         = IsNull(Sum(Case When Branch_Cd = 'POA' Then (DebitQty*Cl_Rate) Else 0 End),0),
DNSEPayIn         = IsNull(Sum(Case When Branch_Cd = 'NSE' Then (ShrtQty*Cl_Rate) Else 0 End),0),
DBSEPayIn         = IsNull(Sum(Case When Branch_Cd = 'BSE' Then (ShrtQty*Cl_Rate) Else 0 End),0)
From DelDebitSummary Group By Party_Code ) A 
Where A.Party_Code = RMSALLSEGMENT.Party_Code
And RMSALLSEGMENT.Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set 
DebitValueAfterHairCut = (DNSEDebitValue + DBSEDebitValue) - ( (DNSEDebitValue + DBSEDebitValue) * @HairCut / 100 ) ,
POAAfterHairCut        = DPOAValue - ( DPOAValue *  @HairCut / 100 ) ,
PayinAfterHairCut      = ( DNSEPayIn + DBSEPayIn ) + (( DNSEPayIn + DBSEPayIn )* @HairCut / 100 ) 
From (
Select Party_Code,
DNSEDebitValue    = IsNull(Sum(Case When Branch_Cd = 'NSE' Then (DebitQty*Cl_Rate) Else 0 End),0),
DBSEDebitValue 	  = IsNull(Sum(Case When Branch_Cd = 'BSE' Then (DebitQty*Cl_Rate) Else 0 End),0),
DPOAValue         = IsNull(Sum(Case When Branch_Cd = 'POA' Then (DebitQty*Cl_Rate) Else 0 End),0),
DNSEPayIn         = IsNull(Sum(Case When Branch_Cd = 'NSE' Then (ShrtQty*Cl_Rate) Else 0 End),0),
DBSEPayIn         = IsNull(Sum(Case When Branch_Cd = 'BSE' Then (ShrtQty*Cl_Rate) Else 0 End),0)
From DelDebitSummary Group By Party_Code ) A 
Where A.Party_Code = RMSALLSEGMENT.Party_Code
And RMSALLSEGMENT.Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set NB_TOTAL_MTM = N_MTM + B_MTM, MTM_LOSSES = N_MTM_LOSS + B_MTM_LOSS, 
AVM = N_AVM + B_AVM, NB_DAY_PURCH = N_Purch + B_Purch, NB_DAY_SALES = N_Sales + B_Sales, 
NB_UPTO_DAY_EXP = (N_Purch + B_Purch + N_Sales + B_Sales),
/*NB_ALLOWED = (TOT_COLLATERAL_NB + NB_LEDGER_EFF_BAL + N_MTM_LOSS + B_MTM_LOSS ) * 7,*/
NB_ALLOWED = TOT_COLLATERAL_NB + NB_LEDGER_EFF_BAL + DebitValueAfterHairCut + POAAfterHairCut - PayinAfterHairCut - N_AVM - B_AVM , 
/*NB_EXCESS_SHORT = (Case When ((TOT_COLLATERAL_NB + NB_LEDGER_EFF_BAL + N_MTM_LOSS + B_MTM_LOSS ) * 7 - (N_Purch + B_Purch + N_Sales + B_Sales)) / 7 > 0 
			Then ((TOT_COLLATERAL_NB + NB_LEDGER_EFF_BAL + N_MTM_LOSS + B_MTM_LOSS ) * 7 - (N_Purch + B_Purch + N_Sales + B_Sales)) / 7
		   	Else (0 - (N_Purch + B_Purch + N_Sales + B_Sales )) / 7  End ),
*/
NB_EXCESS_SHORT = TOT_COLLATERAL_NB + NB_LEDGER_EFF_BAL + DebitValueAfterHairCut + POAAfterHairCut - PayinAfterHairCut - N_AVM - B_AVM ,
NB_TOTAL_CURRENTGE = N_Current_GE + B_Current_GE,
NB_TURNOVER = N_TURNOVER + B_TURNOVER
where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set TotalAvgTurnOver = IsNull((Select Sum(NB_TurnOver)/IsNull(Count(NB_TurnOver),1) From RMSALLSEGMENT  R Where 
R.Party_Code = RMSALLSEGMENT.Party_Code And R.Sauda_Date <= @RMSDate + ' 23:59:59' ),0)
Where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Truncate Table RMSPercent 
Insert into RMSPercent 
Select C.Party_Code,C.sauda_date,C.scrip_cd,C.series,
CurrentOpenPurchase = (Case When Sum(PQtyDel) > 0 Then Sum(PRate) Else 0 End ),
CurrentOpenSell = (Case When Sum(SQtyDel) > 0 Then Sum(SRate) Else 0 End ),
ScripwiseCurrentGrossexp = Sum(PRate) + Sum(SRate),
MaxCurrentGrossExposure = 0,
Percentage = 0,''
From CmBillValan C, Sett_Mst S, RMSALLSEGMENT R Where C.Sett_no = S.Sett_no And C.Sett_Type = S.Sett_Type
And C.Sauda_Date <= @RMSDate + ' 23:59:59' And funds_payin > @RMSDate
And R.Sauda_Date Like @RMSDate + '%' And R.Party_Code = C.Party_Code
And R.PARTY_CODE >= @FromParty And R.PARTY_CODE <= @ToParty
Group By C.Party_Code,C.sauda_date,scrip_cd,C.series
Having ( Sum(PQtyDel) > 0 Or Sum(SqtyDel) > 0 )

Update RMSPercent Set MaxCurrentGrossExposure = ( Select Max(ScripwiseCurrentGrossexp) From RMSPercent R Where R.Party_Code = RMSPercent.Party_Code)
Update RMSPercent Set Percentage = ( Select (CASE WHEN Sum(ScripwiseCurrentGrossexp) > 0 THEN Max(ScripwiseCurrentGrossexp)/Sum(ScripwiseCurrentGrossexp) ELSE 0 END ) From RMSPercent R Where R.Sauda_Date = RMSPercent.Sauda_Date And R.Party_Code = RMSPercent.Party_Code )*100

Update RMSALLSEGMENT SET NPercentScrip = IsNull((Select Min(Scrip_Cd) From RMSPercent 
Where ScripwiseCurrentGrossexp = MaxCurrentGrossExposure
And RMSPercent.Party_Code = RMSALLSEGMENT.Party_Code ),'')
Where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT SET BPercentSeries = IsNull((Select Min(Series) From RMSPercent 
Where ScripwiseCurrentGrossexp = MaxCurrentGrossExposure
And RMSPercent.Party_Code = RMSALLSEGMENT.Party_Code ),'')
Where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT SET BPercent = IsNull((Select Min(Percentage) From RMSPercent 
Where ScripwiseCurrentGrossexp = MaxCurrentGrossExposure
And RMSPercent.Party_Code = RMSALLSEGMENT.Party_Code ),0)
Where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Truncate Table RMSPercent 
Insert into RMSPercent 
Select C.Party_Code,C.sauda_date,C.scrip_cd,C.series,
CurrentOpenPurchase = (Case When Sum(PQtyDel) > 0 Then Sum(PRate) Else 0 End ),
CurrentOpenSell = (Case When Sum(SQtyDel) > 0 Then Sum(SRate) Else 0 End ),
ScripwiseCurrentGrossexp = Sum(PRate) + Sum(SRate),
MaxCurrentGrossExposure = 0,
Percentage = 0,''
From AngelBSECM.BSEDB_ab.DBO.CmBillValan C, AngelBSECM.BSEDB_ab.DBO.Sett_Mst S, RMSALLSEGMENT R Where C.Sett_no = S.Sett_no And C.Sett_Type = S.Sett_Type
And C.Sauda_Date <= @RMSDate + ' 23:59:59' And funds_payin > @RMSDate
And R.Sauda_Date Like @RMSDate + '%' And R.Party_Code = C.Party_Code
And R.PARTY_CODE >= @FromParty And R.PARTY_CODE <= @ToParty
Group By C.Party_Code,C.sauda_date,scrip_cd,C.series
Having ( Sum(PQtyDel) > 0 Or Sum(SqtyDel) > 0 )

Update RMSPercent Set MaxCurrentGrossExposure = ( Select Max(ScripwiseCurrentGrossexp) From RMSPercent R Where R.Party_Code = RMSPercent.Party_Code)
Update RMSPercent Set Percentage = ( Select (CASE WHEN Sum(ScripwiseCurrentGrossexp) > 0 THEN Max(ScripwiseCurrentGrossexp)/Sum(ScripwiseCurrentGrossexp) ELSE 0 END ) From RMSPercent R Where R.Sauda_Date = RMSPercent.Sauda_Date And R.Party_Code = RMSPercent.Party_Code )*100

Update RMSALLSEGMENT SET NPercentScrip = IsNull((Select Min(Scrip_Cd) From RMSPercent 
Where ScripwiseCurrentGrossexp = MaxCurrentGrossExposure
And RMSPercent.Party_Code = RMSALLSEGMENT.Party_Code And RMSPercent.Sauda_Date Like @RMSDate + '%'),'')
Where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT SET BPercentSeries = IsNull((Select Min(Series) From RMSPercent 
Where ScripwiseCurrentGrossexp = MaxCurrentGrossExposure
And RMSPercent.Party_Code = RMSALLSEGMENT.Party_Code And RMSPercent.Sauda_Date Like @RMSDate + '%'),'')
Where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT SET BPercent = IsNull((Select Min(Percentage) From RMSPercent 
Where ScripwiseCurrentGrossexp = MaxCurrentGrossExposure
And RMSPercent.Party_Code = RMSALLSEGMENT.Party_Code And RMSPercent.Sauda_Date Like @RMSDate + '%'),0)
Where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT SET MaxPercentScrip = (Case When BPercent > NPercent Then BPercentScrip Else NPercentScrip End),
MaxPercentSeries=(Case When BPercent > NPercent Then BPercentSeries Else NPercentSeries End),
MAxPercent=(Case When BPercent > NPercent Then BPercent Else NPercent End),
TotalPercentage=BPercent+NPercent 
Where Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set SALES_PERSON = C1.Trader, Trader=C1.Trader,Sub_Broker=C1.Sub_Broker From Client1 C1, Client2 C2 
Where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = RMSALLSEGMENT.Party_Code
And Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set FamilyName = C1.Long_Name From Client1 C1, Client2 C2 
Where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = RMSALLSEGMENT.Family
And Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Update RMSALLSEGMENT Set CUST_EXECUTIVE = IsNull(Approver,'') From Client2 C2, Client5 C5 
Where C5.Cl_Code = C2.Cl_Code And C2.Party_Code = RMSALLSEGMENT.Party_Code
And Sauda_Date Like @RMSDate + '%'
And RMSALLSEGMENT.PARTY_CODE >= @FromParty And RMSALLSEGMENT.PARTY_CODE <= @ToParty

Delete From RMSALLSEGMENT where sauda_date like @RMSDate + '%' 
And TOT_COLLATERAL_NB=0 And CASH_DEPOSIT=0 And DEP_FO=0 And SEC_DEP_VALUE=0 And 
SEC_DEP_PERCENT=0 And SEC_DEP_PERCENT_VALUE=0 And NON_CASH=0 And CREDIT_LIMIT=0 
And N_MTM=0 And N_MTM_LOSS=0 And N_AVM=0 And N_TURNOVER=0 And N_PURCH=0 And N_SALES=0 
And N_NET=0 And N_TOTAL_GE=0 And N_CURRENT_GE=0 And N_PREV_GE=0 And N_ID_EXPOSURE=0 And 
B_MTM=0 And B_MTM_LOSS=0 And B_AVM=0 And B_TURNOVER=0 And B_PURCH=0 And B_SALES=0 And B_NET=0 
And B_TOTAL_GE=0 And B_CURRENT_GE=0 And B_PREV_GE=0 And B_ID_EXPOSURE=0 And AMT_SHORT=0 And 
NB_LEDGER_EFF_BAL=0 And NB_LEDGER_VOC_BAL=0 And FO_LEDGER_BAL=0 And TOTAL_LEDGER_BAL=0 And 
NB_ID_EXPOSURE=0 And FO_ID_EXPOSURE=0 And NB_TOTAL_MTM=0 And MTM_LOSSORZERO=0 And MTM_LOSSES=0 
And AVM=0 And CASH_VAR_MARGIN=0 And FO_MTM=0 And FO_OPTION_VALUE=0 And FO_SPAN_MARGIN=0 
And FO_OPEN_RISK=0 And NB_DAY_PURCH=0 And NB_DAY_SALES=0 And NB_UPTO_DAY_EXP=0 And NB_TOTAL_CURRENTGE=0 
And NB_ALLOWED=0 And FO_EXP=0 And FO_ALLOW=0 And NB_EXCESS_SHORT=0 And FO_EXCESS_SHORT=0 And 
NB_TURNOVER=0 And FO_TURNOVER = 0 And NSEDebitValue = 0 And BSEDebitValue = 0 And POAValue = 0 
And NSEPayIn = 0 And BSEPayIn = 0

GO
