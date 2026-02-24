-- Object: PROCEDURE dbo.FoValanGenerate
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Proc FoValanGenerate (@Sauda_Date Varchar(11)) As        
Declare         
@@Start_Date Datetime,        
@@ExpiryDate Datetime,        
@@Sett_No Varchar(12),        
@@Sett_Type Varchar(2),        
        
@@BillNo int,        
@@FromParty Varchar(10),        
@@ToParty Varchar(10),        
        
@@ACName Varchar(50),        
@@ACCode Varchar(10),        
@@OppCode Varchar(10),        
@@RevCode Varchar(10),        
@@DummyOppCode Varchar(10),        
@@DummyRevCode Varchar(10),        
        
@@ClrHsgParty Varchar(10) ,        
@@BrkRelParty Varchar(10) ,        
@@SerTaxParty Varchar(10) ,        
@@CESSTaxParty Varchar(10) ,        
@@OptExeParty Varchar(10) ,        
@@RndOffParty Varchar(10) ,        
@@CarForParty Varchar(10) ,        
@@SerTaxPayParty Varchar(10) ,        
@@CESSTaxPayParty Varchar(10),        
@@InsSerTaxParty Varchar(10) ,        
@@InsSebiTaxParty Varchar(10) ,        
@@InsTurnTaxParty Varchar(10) ,        
@@InsBrkNoteParty Varchar(10) ,        
@@RemAccParty Varchar(10) ,        
@@SebiTaxParty Varchar(10) ,        
@@TurnTaxParty Varchar(10) ,        
@@BrkNoteParty Varchar(10) ,        
@@RevClrHsgParty Varchar(10) ,         
@@ConClrHsgParty Varchar(10) ,        
@@ClrPreParty Varchar(10) ,        
@@ClrChrgParty Varchar(10) ,        
@@RevClrChrgParty Varchar(10) ,        
@@inschrgParty varchar(10),        
        
        
@@MaturityDate Varchar(17),        
@@ExpDate Varchar(11),        
        
@@DummyBranch_Cd Varchar(10),        
@@Branch_cd Varchar(10),        
@@Sell_buy int,        
@@MTOM numeric(18,6),        
@@Premium numeric(18,6),        
@@ExeAssign numeric(18,6),        
@@Brokerage numeric(18,6),        
@@Service_Tax numeric(18,6),        
@@CESS_Tax numeric(18,6),        
@@TService_Tax numeric(18,6),          
@@TCESS_Tax numeric(18,6),          
@@TBrokerage numeric(18,6),      
@@ExService_Tax numeric(18,6),        
@@Turn_Tax numeric(18,6),        
@@Sebi_Tax numeric(18,6),        
@@Broker_Chrg numeric(18,6),        
@@Cl_Chrg numeric(18,6),        
@@ExCl_Chrg numeric(18,6),        
@@DiffAmt numeric(18,6),        
@@TrdAmt  numeric(18,6),        
@@DelAmt  numeric(18,6),        
@@OppAmt  numeric(18,6),        
@@RevAmt  numeric(18,6),        
@@AccAmt  numeric(18,6),        
@@CalSerAmt  numeric(18,6),        
@@inschrg numeric(18,6),        
@@TExService_Tax numeric(18,6),        
@@TExCESS_Tax numeric(18,6),        
        
@@NetMTOM numeric(18,6),        
@@NetPremium numeric(18,6),        
@@NetExeAssign numeric(18,6),        
@@NetBrokerage numeric(18,6),        
@@NetService_Tax numeric(18,6),        
@@NetCESS_Tax numeric(18,6),          
@@NetExCESS_Tax numeric(18,6),          
@@NetExService_Tax numeric(18,6),        
@@NetTurn_Tax numeric(18,6),        
@@NetSebi_Tax numeric(18,6),        
@@NetBroker_Chrg numeric(18,6),        
@@NetCl_Chrg numeric(18,6),        
@@NetExCl_Chrg numeric(18,6),        
@@NetDiffAmt numeric(18,6),        
@@GrossDiffAmt numeric(18,6),        
@@NetTrdAmt  numeric(18,6),        
@@NetDelAmt  numeric(18,6),        
@@Netinschrg numeric(18,6),        
        
@@TrdStDuty numeric(18,6),        
@@DelStDuty numeric(18,6),        
@@StDuty numeric(18,6),        
@@TrdTTDuty numeric(18,6),        
@@DelTTDuty numeric(18,6),        
@@TTDuty numeric(18,6),        
@@Trans_Cat Varchar(3),        
@@Service_Chrg numeric(18,6),        
@@CESS_Chrg numeric(18,6),        
        
@@Sub_Broker varchar(10),        
@@Com_Per numeric(18,6),        
@@BrokShare numeric(18,6),        
@@NetBrokShare numeric(18,6),        
@@GrossBrokShare numeric(18,6),        
        
@@SetMstCur Cursor,        
@@ValanAccCur Cursor,        
@@ValanAmtCur CurSor        
        
Select @@NetMTOM = 0         
Select @@NetPremium = 0         
Select @@NetExeAssign = 0         
Select @@NetBrokerage = 0         
Select @@NetService_Tax = 0         
Select @@NetCESS_Tax = 0           
Select @@TBrokerage = 0       
Select @@TService_Tax = 0          
Select @@TCESS_Tax = 0          
Select @@TExService_Tax = 0          
Select @@TExCESS_Tax = 0        
Select @@NetExService_Tax = 0         
Select @@NetExCESS_Tax = 0           
Select @@NetTurn_Tax = 0         
Select @@NetSebi_Tax = 0         
Select @@NetBroker_Chrg = 0         
Select @@NetCl_Chrg = 0         
Select @@NetExCl_Chrg = 0         
Select @@NetDiffAmt = 0         
Select @@GrossDiffAmt = 0         
Select @@NetTrdAmt  = 0         
Select @@NetDelAmt  = 0        
Select @@Netinschrg  = 0        
        
Set @@SetMstCur = Cursor for          
Select service_tax, CESS_Tax from FoGlobals  Where @Sauda_Date >= year_start_dt and @Sauda_Date <=  year_end_dt         
Open @@SetMstCur           
Fetch Next From @@SetMstCur into @@Service_Chrg, @@CESS_Chrg          
Close @@SetMstCur          
DeAllocate @@SetMstCur          
       
        
select top 1 @@MaturityDate = left(convert(varchar,Maturitydate,109),11) + ' 23:59',@@ExpDate = left(convert(varchar,Expirydate,109),11)         
from foscrip2 where  left(convert(varchar,maturitydate,109),11) like @Sauda_Date + '%'        
        
If @@MaturityDate Is Not Null         
	Begin        
	 Exec FoRearrangeBillflag @@MaturityDate        
	 Exec CalculateStampDuty @@MaturityDate        
	End 

Exec sp_Insert_DelPos @Sauda_Date        
        
Select @@FromParty = Min(Party_Code),@@ToParty=Max(Party_Code) From Client2         
        
Exec FoValanPop @Sauda_Date,@@FromParty,@@ToParty        
        
Delete from FOAccBill where BillDate Like @Sauda_Date + '%'        
        
Set @@ValanAccCur = Cursor For        
Select 
	Top 1 Sett_no=Convert(Varchar,ExpiryDate,112),
	Sett_Type='N',
	Start_Date=Left(Convert(Varchar,ExpiryDate,109),11),
	ExpiryDate=Left(Convert(Varchar,ExpiryDate,109),11)        
From FoScrip2 where maturitydate >= @Sauda_Date        

Open @@ValanAccCur        
Fetch Next From @@ValanAccCur into @@Sett_No,@@Sett_Type,@@Start_Date,@@ExpiryDate        
Close @@ValanAccCur        
DeAllocate @@ValanAccCur        
        
/* Start of Party Bill Amount */        
        
insert into FOAccBill          
        
Select
	Party_Code,BillNo=0,        
	Sell_Buy = 
		(Case When Sum(Case When Sell_buy = 1 Then Amount Else -Amount End) > 0 Then 1 Else 2 End), 
	Sett_no, Sett_Type, Sauda_Date, Start_Date, End_Date, Sec_Payin, Sec_Payout, 
	amount =  abs(sum(Case When Sell_buy = 1 Then Amount Else -Amount End)), 
	D1, D2, D3, D4, Branch_Code, Narr
	From (
		Select Party_Code,        
			Sell_buy = (Case When Sum(Case When ParticipantCode = MemberCode         
					Then SBillAmt - PBillAmt - (service_tax - ExSer_Tax + turn_tax + 
						 Ins_chrg + Other_Chrg + sebi_tax + broker_note + cl_chrg-excl_chrg)         
					Else -1 End ) > 0         
					Then 2        
					Else 1        
					End),        
	sett_no=@@Sett_No,sett_type=@@Sett_Type,Sauda_Date,Start_Date=Sauda_Date,
	End_Date=Sauda_Date,Sec_Payin=Sauda_Date,Sec_Payout=Sauda_Date,        
	Amount = Round(Abs(Sum(Case When ParticipantCode = MemberCode         
				Then SBillAmt - PBillAmt - (service_tax - ExSer_Tax + turn_tax + 
					Ins_chrg + sebi_tax + Other_Chrg + broker_note + cl_chrg-excl_chrg)        
				Else SBillAmt + PBillAmt + (service_tax - ExSer_Tax + Ins_chrg + Other_Chrg +
					 turn_tax + sebi_tax + broker_note + cl_chrg-excl_chrg)         
				End)),2) ,        
	D1=0,D2=0,D3=0,D4=0, Branch_code, Narr='Bill Posted'        
from
	FoBillValan_Temp , FOOwner where Sauda_Date Like @Sauda_Date + '%'        
Group By
	Branch_code,Party_code,Sauda_Date, Participantcode  ) A
Group by
	Party_Code, Sett_no, Sett_Type, Sauda_Date, Start_Date, End_Date,
	Sec_Payin, Sec_Payout, D1, D2, D3, D4, Branch_Code, Narr
        
/* End of Party Bill Amount */        
        
Set @@ValanAccCur = Cursor For        
 Select ACName,ACCode from valanaccount V where Effdate = (Select Max(EffDate) from ValanAccount A        
 Where A.EffDate <= @Sauda_Date and V.AcName = A.AcName) Order By AcName        
Open @@ValanAccCur        
Fetch Next From @@ValanAccCur into @@ACName,@@ACCode        
while @@Fetch_Status = 0         
Begin        
 if @@ACName = 'CLEARING HOUSE'          
  Select @@ClrHsgParty = @@ACCode        
 if @@ACName = 'BROKERAGE REALISED'          
  Select @@BrkRelParty = @@ACCode    
 if @@ACName = 'SERVICE TAX'          
  Select @@SerTaxParty = @@ACCode        
 if @@ACName = 'CESS TAX'            
   Select @@CESSTaxParty = @@ACCode          
 if @@ACName = 'OPTION EXERCISE'          
  Select @@OptExeParty = @@ACCode        
 if @@ACName = 'ROUNDING OFF'          
  Select @@RndOffParty = @@ACCode        
 if @@ACName = 'CARRY FORWARD CHARGE'          
  Select @@CarForParty = @@ACCode        
 if @@ACName = 'SERVICE TAX PAYABLE'          
  Select @@SerTaxPayParty = @@ACCode        
 if @@ACName = 'INCLUSIVE SERVICE TAX'          
  Select @@InsSerTaxParty = @@ACCode        
 if @@ACName = 'INCLUSIVE SEBI TAX'          
  Select @@InsSebiTaxParty = @@ACCode        
 if @@ACName = 'INCLUSIVE TURN TAX'          
  Select @@InsTurnTaxParty = @@ACCode        
 if @@ACName = 'INCLUSIVE STAMP TAX'          
  Select @@InsBrkNoteParty = @@ACCode        
 if @@ACName = 'REMISSOR ACCOUNT'          
  Select @@RemAccParty = @@ACCode        
 if @@ACName = 'SEBI TAX'          
  Select @@SebiTaxParty = @@ACCode        
 if @@ACName = 'CESS TAX PAYABLE'            
   Select @@CESSTaxPayParty = @@ACCode          
 if @@ACName = 'TURN OVER TAX'          
  Select @@TurnTaxParty = @@ACCode        
 if @@ACName = 'STAMP DUTY'          
  Select @@BrkNoteParty = @@ACCode        
 if @@ACName = 'REVERSE CLRG HOUSE'          
  Select @@RevClrHsgParty = @@ACCode         
 if @@ACName = 'CONS. CLRG HOUSE'          
  Select @@ConClrHsgParty = @@ACCode        
 if @@ACName = 'CLEARING CHARGES'          
  Select @@ClrChrgParty = @@ACCode        
 if @@ACName = 'REVERSE CLEARING CHARGES'          
  Select @@RevClrChrgParty = @@ACCode        
 if @@ACName = 'CLEARING PREMIUM ACCOUNT'          
  Select @@ClrPreParty = @@ACCode        
 if @@ACName = 'SECURITY TRANSACTION TAX'          
  Select @@InschrgParty = @@ACCode        
        
  --print @@ACName        
        
 Fetch Next From @@ValanAccCur into @@ACName,@@ACCode        
End        
Close @@ValanAccCur        
DeAllocate @@ValanAccCur        
        
/* Exchange and levis Branch wise Obligation Amount */        
Set @@ValanAmtCur = Cursor for         
 Select Branch_Code,        
 MTOM      = IsNull(Sum(Case When Inst_Type Like 'FUT%' AND ParticipantCode = MemberCode         
        Then SBILLAMT + SBROKAMT - PBILLAMT + PBROKAMT         
        Else 0         
          End),0),        
 Premium   = IsNull(Sum(Case When Inst_Type Like 'OPT%' And AuctionPart <> 'EA' And TradeType = 'BT' AND ParticipantCode = MemberCode         
        Then SBILLAMT + SBROKAMT - PBILLAMT + PBROKAMT         
        Else 0         
          End),0),        
 ExeAssign = IsNull(Sum(Case When Inst_Type Like 'OPT%' And AuctionPart = 'EA' And TradeType = 'BT' AND ParticipantCode = MemberCode         
        Then SBILLAMT + SBROKAMT - PBILLAMT + PBROKAMT         
        Else 0         
          End),0),        
 Brokerage=Sum(SBrokAmt + PBrokAmt),        
 Service_Tax=Sum(Service_Tax),ExService_Tax=Sum(ExSer_Tax),        
 Turn_Tax=Sum(Turn_Tax),Sebi_Tax=Sum(Sebi_Tax), Ins_chrg=sum( Ins_chrg),        
 Broker_Chrg=Sum(Broker_Note),Cl_Chrg = Sum(Cl_Chrg),ExCl_Chrg = Sum(ExCl_Chrg)         
 From FoBillValan_Temp, fOoWNER Where Sauda_Date Like @Sauda_Date + '%'        
 Group By Branch_Code        
 Order By Branch_Code        
Open @@ValanAmtCur         
Fetch Next From @@ValanAmtCur into @@Branch_cd,@@MTOM,@@Premium,@@ExeAssign,@@Brokerage,@@Service_Tax,        
                @@ExService_Tax,@@Turn_Tax,@@Sebi_Tax,@@Inschrg,@@Broker_Chrg,@@Cl_Chrg,@@ExCl_Chrg        
While @@Fetch_Status = 0         
Begin         
 Select @@NetMTOM = @@NetMTOM + @@MTOM        
 Select @@NetPremium = @@NetPremium + @@Premium        
 Select @@NetExeAssign = @@NetExeAssign + @@ExeAssign         
 Select @@NetTurn_Tax = @@NetTurn_Tax + @@Turn_Tax        
 Select @@NetSebi_Tax = @@NetSebi_Tax + @@Sebi_Tax        
Select @@NetBroker_Chrg = @@NetBroker_Chrg + @@Broker_Chrg         
 Select @@NetCl_Chrg = @@NetCl_Chrg + @@Cl_Chrg        
 Select @@NetExCl_Chrg = @@NetExCl_Chrg + @@ExCl_Chrg        
 Select @@NetInschrg  = @@NetInschrg + @@Inschrg        
 Select @@TService_Tax =  @@Service_Tax          
 Select @@TExService_Tax =  @@ExService_Tax           
        
 Select @@TCESS_Tax = @@Service_Tax - Round(( @@Service_Tax * 100 ) / ( 100 + @@CESS_Chrg ),2)      
 Select @@TService_Tax = @@Service_Tax - @@TCESS_Tax      
          
 Select @@TExCESS_Tax = @@TExService_Tax - Round(( @@TExService_Tax * 100 ) / ( 100 + @@CESS_Chrg ),2)        
 Select @@TExService_Tax = @@TExService_Tax - @@TExCESS_Tax        
        
 Select @@NetCESS_Tax = @@NetCESS_Tax + @@TCESS_Tax          
 Select @@NetExCESS_Tax = @@NetExCESS_Tax + @@TExCESS_Tax           
        
 Select @@NetExService_Tax = @@NetExService_Tax + @@TExService_Tax          
 Select @@NetService_Tax = @@NetService_Tax + @@TService_Tax        
 Select @@TBrokerage = @@Brokerage      
 Select @@NetBrokerage = @@NetBrokerage + @@TBrokerage        
        
        
 If @@MTOM > 0         
  Select @@Sell_Buy = 1          
 Else        
  Select @@Sell_Buy = 2       
          
 insert into FOAccBill Values ( @@ClrHsgParty,0,@@Sell_buy,@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(Abs(@@MTOM),2),0,0,0,0,@@Branch_cd,'Bill Posted')         
            
 If @@Premium > 0         
  Select @@Sell_Buy = 1          
 Else        
  Select @@Sell_Buy = 2        
          
 insert into FOAccBill Values ( @@ClrPreParty,0,@@Sell_buy,@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(Abs(@@Premium),2),0,0,0,0,@@Branch_cd,'Bill Posted')        
        
 If @@ExeAssign > 0         
  Select @@Sell_Buy = 1          
 Else        
  Select @@Sell_Buy = 2        
          
 insert into FOAccBill Values ( @@OptExeParty,0,@@Sell_buy,@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(Abs(@@ExeAssign),2),0,0,0,0,@@Branch_cd,'Bill Posted')        
        
 insert into FOAccBill Values ( @@BrkRelParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@TBrokerage,2),0,0,0,0,@@Branch_cd,'Bill Posted')         
      
        
        
 insert into FOAccBill Values ( @@SerTaxParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@TService_Tax,2),0,0,0,0,@@Branch_cd,'Bill Posted')        
        
          
 insert into FOAccBill Values (@@InsSerTaxParty,0,'1',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@ExService_Tax,2),0,0,0,0,@@Branch_cd,'Bill Posted')        
        
        
 if Round(@@TCESS_Tax,2) <> 0         
 begin        
   insert into FOAccBill Values (@@CESSTaxParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@TCESS_Tax,2),0,0,0,0,@@Branch_cd,'Bill Posted')        
 end        
        
        
  if Round(@@TExCESS_Tax,2) <> 0        
   begin        
    insert into FOAccBill Values (@@CESSTaxPayParty,0,'1',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@TExCESS_Tax,2),0,0,0,0,@@Branch_cd,'Bill Posted')        
  end        
        
        
 insert into FOAccBill Values ( @@TurnTaxParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@Turn_Tax,2),0,0,0,0,@@Branch_cd,'Bill Posted')        
         
 insert into FOAccBill Values ( @@SebiTaxParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@Sebi_Tax,2),0,0,0,0,@@Branch_cd,'Bill Posted')        
        
 insert into FOAccBill Values ( @@BrkNoteParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@Broker_Chrg,2),0,0,0,0,@@Branch_cd,'Bill Posted')        
        
 insert into FOAccBill Values ( @@ClrChrgParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@Cl_Chrg,2),0,0,0,0,@@Branch_cd,'Bill Posted')        
          
 insert into FOAccBill Values ( @@RevClrChrgParty,0,'1',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@ExCl_Chrg,2),0,0,0,0,@@Branch_cd,'Bill Posted')        
        
 insert into FOAccBill Values ( @@InschrgParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@Inschrg,2),0,0,0,0,@@Branch_cd,'Bill Posted')        
        
      
        
 Fetch Next From @@ValanAmtCur into @@Branch_cd,@@MTOM,@@Premium,@@ExeAssign,@@Brokerage,@@Service_Tax,        
                      @@ExService_Tax,@@Turn_Tax,@@Sebi_Tax,@@Inschrg,@@Broker_Chrg,@@Cl_Chrg,@@ExCl_Chrg        
        
End        
Close @@ValanAmtCur        
DeAllocate @@ValanAmtCur        
        
Select @@NetBrokShare = 0        
Select @@GrossBrokShare = 0        
        
Set @@ValanAmtCur = Cursor for        
select sb.sub_broker,com_perc, BRANCH_CD, Brokerage = Sum(PBrokAmt+SBrokAmt)*com_perc/100        
from FoBillValan_Temp s, client2 c2,client1 c1,subbrokers sb        
Where s.party_code = c2.party_code and c1.cl_code = c2.cl_code         
and c1.Sub_Broker = sb.sub_broker         
and sb.com_perc > 0         
and s.sauda_date Like @Sauda_Date + '%'        
Group By sb.sub_broker,com_perc,BRANCH_CD        
Order By sb.sub_broker,BRANCH_CD        
Open @@ValanAmtCur         
Fetch Next From @@ValanAmtCur into @@Sub_Broker,@@Com_Per,@@Branch_Cd,@@BrokShare        
While @@Fetch_Status = 0          
Begin        
 Select @@DummyBranch_Cd = @@Branch_Cd        
 While @@DummyBranch_Cd = @@Branch_Cd and @@Fetch_Status = 0          
 Begin        
  Select @@NetBrokShare = @@NetBrokShare + @@BrokShare        
  Select @@GrossBrokShare = @@GrossBrokShare + @@BrokShare        
        
  insert into FOAccBill Values ( @@Sub_Broker,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
               Round(@@BrokShare,2),0,0,0,0,@@Branch_cd,'Bill Posted')        
           
  Fetch Next From @@ValanAmtCur into @@Sub_Broker,@@Com_Per,@@Branch_Cd ,@@BrokShare       
 End        
/*    
 insert into FOAccBill Values ( @@RemAccParty,0,'1',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
       Round(@@NetBrokShare,2),0,0,0,0,@@Branch_cd,'Bill Posted')        
*/    
 Select @@NetBrokShare = 0        
End        
        
Set @@ValanAmtCur = Cursor for        
 Select Amount = Isnull(Sum(Amount),0),BranchCd,Sell_Buy From FOAccBill Where         
 BillDate Like @Sauda_Date + '%' and Branchcd <> 'ZZZ'        
 Group by BranchCD,Sell_Buy         
 Order by BranchCD,Sell_Buy        
Open @@ValanAmtCur         
Fetch Next from @@ValanAmtCur into @@DiffAmt,@@Branch_Cd,@@Sell_Buy        
While @@Fetch_Status = 0          
Begin        
 Select @@DummyBranch_Cd = @@Branch_Cd        
 Select @@NetDiffAmt = 0        
 While @@DummyBranch_Cd = @@Branch_Cd and @@Fetch_Status = 0         
 Begin        
  If @@Sell_Buy = 1         
  Begin        
   Select @@NetDiffAmt = @@NetDiffAmt + @@DiffAmt        
   Select @@GrossDiffAmt = @@GrossDiffAmt + @@DiffAmt        
  End         
  Else        
  Begin                                
   Select @@NetDiffAmt = @@NetDiffAmt - @@DiffAmt         
   Select @@GrossDiffAmt = @@GrossDiffAmt - @@DiffAmt       
End        
  Fetch Next from @@ValanAmtCur into @@DiffAmt,@@Branch_Cd,@@Sell_Buy          
 End        
 if @@NetDiffAmt > 0         
  insert into FOAccBill Values ( @@RndOffParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(Abs(@@NetDiffAmt),2),0,0,0,0,@@DummyBranch_Cd,'Bill Posted')        
 Else if @@NetDiffAmt < 0         
  insert into FOAccBill Values ( @@RndOffParty,0,'1',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(Abs(@@NetDiffAmt),2),0,0,0,0,@@DummyBranch_Cd,'Bill Posted')        
         
End        
Close @@ValanAmtCur        
DeAllocate @@ValanAmtCur        
        
 If @@NetMTOM > 0         
  Select @@Sell_Buy = 1          
 Else        
  Select @@Sell_Buy = 2        
          
 insert into FOAccBill Values ( @@ClrHsgParty,0,@@Sell_buy,@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(Abs(@@NetMTOM),2),0,0,0,0,'ZZZ','Bill Posted')         
            
 If @@NetPremium > 0         
  Select @@Sell_Buy = 1          
 Else        
  Select @@Sell_Buy = 2        
          
 insert into FOAccBill Values ( @@ClrPreParty,0,@@Sell_buy,@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(Abs(@@NetPremium),2),0,0,0,0,'ZZZ','Bill Posted')        
        
 If @@NetExeAssign > 0         
  Select @@Sell_Buy = 1          
 Else        
  Select @@Sell_Buy = 2        
          
 insert into FOAccBill Values ( @@OptExeParty,0,@@Sell_buy,@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(Abs(@@NetExeAssign),2),0,0,0,0,'ZZZ','Bill Posted')        
        
 insert into FOAccBill Values ( @@BrkRelParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@NetBrokerage,2),0,0,0,0,'ZZZ','Bill Posted')        
        
 insert into FOAccBill Values ( @@SerTaxParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@NetService_Tax,2),0,0,0,0,'ZZZ','Bill Posted')        
        
 if Round(@@NetCESS_Tax,2) <> 0         
  begin        
   insert into FOAccBill Values ( @@CESSTaxParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@NetCESS_Tax,2),0,0,0,0,'ZZZ','Bill Posted')        
  end        
 if Round(@@NetExCESS_Tax,2) <> 0         
  begin        
   insert into FOAccBill Values ( @@CESSTaxPayParty,0,'1',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@NetExCESS_Tax,2),0,0,0,0,'ZZZ','Bill Posted')        
  end        
        
        
          
 insert into FOAccBill Values ( @@InsSerTaxParty,0,'1',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@NetExService_Tax,2),0,0,0,0,'ZZZ','Bill Posted')        
        
 insert into FOAccBill Values ( @@TurnTaxParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@NetTurn_Tax,2),0,0,0,0,'ZZZ','Bill Posted')        
         
 insert into FOAccBill Values ( @@SebiTaxParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@NetSebi_Tax,2),0,0,0,0,'ZZZ','Bill Posted')        
        
 insert into FOAccBill Values ( @@BrkNoteParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@NetBroker_Chrg,2),0,0,0,0,'ZZZ','Bill Posted')        
        
 insert into FOAccBill Values ( @@ClrChrgParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,  
         Round(@@NetCl_Chrg,2),0,0,0,0,'ZZZ','Bill Posted')        
          
 insert into FOAccBill Values ( @@RevClrChrgParty,0,'1',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@NetExCl_Chrg,2),0,0,0,0,'ZZZ','Bill Posted')        
/*        
 insert into FOAccBill Values ( @@RemAccParty,0,'1',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@GrossBrokShare,2),0,0,0,0,'ZZZ','Bill Posted')        
*/        
 insert into FOAccBill Values ( @@InschrgParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(@@NetInschrg,2),0,0,0,0,'ZZZ','Bill Posted')        
        
        
Select @@OppAmt = 0        
        
Set @@ValanAmtCur = Cursor for        
 Select OppCode,RevCode,AcCode from valanAccount where Reversed = 1         
 and EffDate = (Select Min(EffDate) from valanAccount        
 Where EffDate <= @Sauda_Date ) Order by OppCode,RevCode        
Open @@ValanAmtCur         
Fetch Next From @@ValanAmtCur into @@OppCode,@@RevCode,@@AcCode         
While @@Fetch_Status =  0        
Begin        
 Select @@DummyOppCode = @@OppCode        
 While @@DummyOppCode = @@OppCode and @@Fetch_Status =  0        
 Begin        
  Select @@RevAmt = 0        
  Select @@DummyRevCode = @@RevCode        
  While @@DummyRevCode = @@RevCode and @@DummyOppCode = @@OppCode and @@Fetch_Status =  0        
  Begin        
   Set @@ValanAccCur = Cursor for        
    Select Amount,Sell_Buy From FOAccBill where BillDate Like @Sauda_Date + '%'        
    and Party_Code = @@AcCode And BranchCd = 'ZZZ'        
   Open @@ValanAccCur         
   Fetch Next from @@ValanAccCur into @@AccAmt,@@Sell_Buy        
        
   if @@Fetch_Status =  0        
   Begin        
    if @@Sell_Buy = 1         
    Begin        
     Select @@RevAmt = @@RevAmt + @@AccAmt        
     Select @@OppAmt = @@OppAmt + @@AccAmt        
    End        
    Else        
    Begin        
     Select @@RevAmt = @@RevAmt - @@AccAmt        
     Select @@OppAmt = @@OppAmt - @@AccAmt        
    End        
   End      
   Else        
   Close @@ValanAccCur        
  DeAllocate @@ValanAccCur        
   Fetch Next From @@ValanAmtCur into @@OppCode,@@RevCode,@@AcCode         
  End        
  if @@RevAmt > 0         
   insert into FOAccBill Values ( @@DummyRevCode,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
          Round(Abs(@@RevAmt),2),0,0,0,0,'ZZZ','Bill Posted')        
  Else        
   insert into FOAccBill Values ( @@DummyRevCode,0,'1',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
          Round(Abs(@@RevAmt),2),0,0,0,0,'ZZZ','Bill Posted')        
 End         
 if @@OppAmt > 0        
  insert into FOAccBill Values ( @@DummyOppCode,0,'1',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(Abs(@@OppAmt),2),0,0,0,0,'ZZZ','Bill Posted')          
 Else        
  insert into FOAccBill Values ( @@DummyOppCode,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
         Round(Abs(@@OppAmt),2),0,0,0,0,'ZZZ','Bill Posted')        
End        
Close @@ValanAmtCur        
DeAllocate @@ValanAmtCur        
        
Select @@GrossDiffAmt = 0        
        
Set @@ValanAmtCur = Cursor for        
        
Select Amount = Isnull(Sum(Amount),0),Sell_Buy From FOAccBill A,AccountMCDX.Dbo.AcMAst M         
Where BillDate Like @Sauda_Date + '%'        
and A.Party_code = M.CltCode And (BranchCd = 'ZZZ' or AcCat = 4 )        
Group by Sell_buy        
        
Open @@ValanAmtCur         
Fetch Next from @@ValanAmtCur into @@DiffAmt,@@Sell_Buy        
While @@Fetch_Status = 0          
Begin  
 Begin  
  If @@Sell_Buy = 1         
  Begin          
   Select @@GrossDiffAmt = @@GrossDiffAmt + @@DiffAmt        
  End         
  Else        
  Begin                            
   Select @@GrossDiffAmt = @@GrossDiffAmt - @@DiffAmt                 
  End        
  Fetch Next from @@ValanAmtCur into @@DiffAmt,@@Sell_Buy        
 End        
End        
Close @@ValanAmtCur        
DeAllocate @@ValanAmtCur        
        
        
if @@GrossDiffAmt > 0         
 insert into FOAccBill Values ( @@RndOffParty,0,'2',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
        Round(Abs(@@GrossDiffAmt),2),0,0,0,0,'ZZZ','Bill Posted')        
Else         
 insert into FOAccBill Values ( @@RndOffParty,0,'1',@@Sett_No,@@Sett_Type,@Sauda_Date,@@Start_Date,@@ExpiryDate,@@ExpiryDate,@@ExpiryDate,        
        Round(Abs(@@GrossDiffAmt),2),0,0,0,0,'ZZZ','Bill Posted')        
        
          
Delete From FoAccBill Where Amount = 0 And BillDate Like @Sauda_Date + '%'        
        
Exec FOGENBILLNO @Sauda_Date       
    
Update FoBillValan_Temp set BillNo = FoAccBill.Bill_No  from  FoAccBill    
where left(FoBillValan_Temp.sauda_date,11) like left(FoAccBill.BillDate,11) + '%'  
and FoBillValan_Temp.party_code = FoAccBill.party_code  
and BillDate Like @Sauda_Date + '%'           
    
    
             
Delete From FoBillValan Where Sauda_Date Like @Sauda_Date + '%'            
                
Insert into FoBillValan                 
Select * from FoBillValan_Temp                
  

Truncate table FoBillValan_Temp

GO
