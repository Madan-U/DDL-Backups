-- Object: PROCEDURE dbo.NseCMValanGenerate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.NseCMValanGenerate    Script Date: 10/01/2002 7:40:13 PM ******/

/****** Object:  Stored Procedure dbo.NseCMValanGenerate    Script Date: 09/12/2002 3:44:18 PM ******/

/****** Object:  Stored Procedure dbo.NseCMValanGenerate    Script Date: 09/11/2002 2:47:28 PM ******/
/*
Drop Proc NseCMValanGenerate
*/
CREATE Proc NseCMValanGenerate (@Sett_No Varchar(7),@Sett_Type Varchar(2),@StatusName Varchar(15),@FlagForInclusiveBrokerage int) As
Declare 
@@Start_Date Datetime,
@@End_Date Datetime,
@@Sec_Payin Datetime,
@@Sec_Payout Datetime,
@@BillNo int,

@@ACName Varchar(50),
@@ACCode Varchar(10),
@@OppCode Varchar(10),
@@RevCode Varchar(10),
@@DummyOppCode Varchar(10),
@@DummyRevCode Varchar(10),
@@ClrHsgParty Varchar(10),
@@BrkRelParty Varchar(10),
@@SerTaxParty Varchar(10),
@@DelChrgParty Varchar(10),
@@RndOffParty Varchar(10),
@@MrgParty Varchar(10),
@@SerTaxPayParty Varchar(10),
@@SebiTaxParty Varchar(10),
@@TurnTaxParty Varchar(10),
@@InsChrgParty Varchar(10),
@@BrkNoteParty Varchar(10),
@@OthChrgParty Varchar(10),

@@DummyBranch_Cd Varchar(10),
@@Branch_cd Varchar(10),
@@Sell_buy int,
@@Exchange numeric(18,6),
@@Brokerage numeric(18,6),
@@DelBrokerage numeric(18,6),
@@Service_Tax numeric(18,6),
@@ExService_Tax numeric(18,6),
@@Turn_Tax numeric(18,6),
@@Sebi_Tax numeric(18,6),
@@Ins_Chrg numeric(18,6),
@@Broker_Chrg numeric(18,6),
@@Other_Chrg numeric(18,6),
@@DiffAmt numeric(18,6),
@@TrdAmt  numeric(18,6),
@@DelAmt  numeric(18,6),
@@OppAmt  numeric(18,6),
@@RevAmt  numeric(18,6),
@@AccAmt  numeric(18,6),
@@CalSerAmt  numeric(18,6),

@@NetExchange numeric(18,6),
@@NetBrokerage numeric(18,6),
@@NetDelBrokerage numeric(18,6),
@@NetService_Tax numeric(18,6),
@@NetExService_Tax numeric(18,6),
@@NetTurn_Tax numeric(18,6),
@@NetSebi_Tax numeric(18,6),
@@NetIns_Chrg numeric(18,6),
@@NetBroker_Chrg numeric(18,6),
@@NetOther_Chrg numeric(18,6),
@@NetDiffAmt numeric(18,6),
@@GrossDiffAmt numeric(18,6),
@@NetTrdAmt  numeric(18,6),
@@NetDelAmt  numeric(18,6),

@@TrdStDuty numeric(18,6),
@@DelStDuty numeric(18,6),
@@StDuty numeric(18,6),
@@TrdTTDuty numeric(18,6),
@@DelTTDuty numeric(18,6),
@@TTDuty numeric(18,6),
@@Trans_Cat Varchar(3),
@@Service_Chrg numeric(18,6),

@@SetMstCur Cursor,
@@ValanAccCur Cursor,
@@ValanAmtCur CurSor

Select @@NetExchange = 0 
Select @@NetBrokerage = 0 
Select @@NetDelBrokerage = 0 
Select @@NetService_Tax = 0 
Select @@NetExService_Tax = 0 
Select @@NetTurn_Tax = 0 
Select @@NetSebi_Tax = 0 
Select @@NetIns_Chrg = 0 
Select @@NetBroker_Chrg = 0 
Select @@NetOther_Chrg = 0 
select @@GrossDiffAmt = 0

Exec NseCMValan @Sett_No,@Sett_Type,'','','','',@StatusName
Delete from AccBill where sett_no = @Sett_No and sett_type = @Sett_Type
Delete from IAccBill where sett_no = @Sett_No and sett_type = @Sett_Type
/* Get the Start_Date and End_Date of the Settlement */

Set @@SetMstCur = Cursor for
	Select Broker_note,Turnover_tax,Trans_Cat from Taxes
Open @@SetMstCur 
Fetch Next From @@SetMstCur into @@StDuty,@@TTDuty,@@Trans_Cat
while @@Fetch_Status = 0 
Begin
	if @@Trans_Cat = 'TRD' 
	begin
		Select @@TrdStDuty = @@StDuty
		Select @@TrdTTDuty = @@TTDuty
	End	
	Else if @@Trans_Cat = 'DEL' 
	Begin
		Select @@DelStDuty = @@StDuty
		Select @@DelTTDuty = @@TTDuty
	End
	Fetch Next From @@SetMstCur into @@StDuty,@@TTDuty,@@Trans_Cat
End
Close @@SetMstCur
DeAllocate @@SetMstCur

Select @@Service_Tax = 0 
Set @@SetMstCur = Cursor for
	Select service_tax from Globals
Open @@SetMstCur 
Fetch Next From @@SetMstCur into @@Service_Chrg
Close @@SetMstCur
DeAllocate @@SetMstCur

Set @@SetMstCur = Cursor For
	Select Start_Date,end_date,sec_payin,sec_Payout from sett_mst 
	where sett_no = @Sett_No and sett_type = @Sett_Type
Open @@SetMstCur 
Fetch Next from @@SetMstCur into @@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout
Close @@SetMstCur
DeAllocate @@SetMstCur

/* Finish the Settlement Date Selection */

/* Start of Party Bill Amount */

 insert into AccBill   
Select Party_Code,BillNo,
Sell_buy = (Case When Sum(Pamt) >= Sum(SAmt) 
		 Then 1
	         Else 2
	    End),
sett_no,sett_type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
Amount = Round(Abs(Sum(Pamt) - Sum(SAmt)),2),
Branch_cd,'Bill Posted'
from CMBillValan where sett_no = @Sett_No and sett_type = @Sett_Type
And TradeType = 'S'
Group By sett_no,sett_type,Branch_cd,Party_code,BillNo

/* End of Party Bill Amount */


Set @@ValanAccCur = Cursor For
	Select ACName,ACCode from valanaccount V where Effdate = (Select Max(EffDate) from ValanAccount A
	Where A.EffDate <= @@End_Date and V.AcName = A.AcName) Order By AcName
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
	if @@ACName = 'DELIVERY CHARGES'  
		Select @@DelChrgParty = @@ACCode
	if @@ACName = 'ROUNDING OFF'  
		Select @@RndOffParty = @@ACCode
	if @@ACName = 'MARGIN'  
		Select @@MrgParty = @@ACCode
	if @@ACName = 'SERVICE TAX PAYABLE'  
		Select @@SerTaxPayParty = @@ACCode
	if @@ACName = 'SEBI TURNOVER TAX'  
		Select @@SebiTaxParty = @@ACCode
	if @@ACName = 'TURNOVER TAX'  
		Select @@TurnTaxParty = @@ACCode
	if @@ACName = 'INSURANCE CHARGES'  
		Select @@InsChrgParty = @@ACCode
	if @@ACName = 'BROKER NOTE STAMP CHARGES'  
		Select @@BrkNoteParty = @@ACCode
	if @@ACName = 'OTHER CHARGES'  
		Select @@OthChrgParty = @@ACCode

	Fetch Next From @@ValanAccCur into @@ACName,@@ACCode
End
Close @@ValanAccCur
DeAllocate @@ValanAccCur

/* Exchange and levis Branch wise Obligation Amount */
Set @@ValanAmtCur = Cursor for	
	Select Branch_cd,
	Sell_buy = (Case When Sum(PRate) >= Sum(SRate) 
			 Then 2
			 Else 1
		    End),
	Exchange = Abs(Sum(PRate) - Sum(SRate)),
	Brokerage=Sum(PBrokTrd+SBrokTrd),DelBrokerage=Sum(PBrokDel+SBrokDel),
	Service_Tax=Sum(Service_Tax),ExService_Tax=Sum(ExService_Tax),Turn_Tax=Sum(Turn_Tax),Sebi_Tax=Sum(Sebi_Tax),
	Ins_Chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg),TrdAmt=Sum(TrdAmt),DelAmt=Sum(DelAmt)
	from CMBillValan where sett_no = @Sett_No and sett_type = @Sett_Type And TradeType = 'S'
	Group By sett_no,sett_type,Branch_cd
	Order By sett_no,sett_type,Branch_cd
Open @@ValanAmtCur 
Fetch Next From @@ValanAmtCur into @@Branch_cd,@@Sell_buy,@@Exchange,@@Brokerage,@@DelBrokerage,@@Service_Tax,
                @@ExService_Tax,@@Turn_Tax,@@Sebi_Tax,@@Ins_Chrg,@@Broker_Chrg,@@Other_Chrg,@@TrdAmt,@@DelAmt
While @@Fetch_Status = 0 
Begin		
	if @@Sell_buy = 1  
		Select @@NetExchange = @@NetExchange + @@Exchange
	else
		Select @@NetExchange = @@NetExchange - @@Exchange			
	
	Select @@NetTrdAmt = @@NetTrdAmt + @@TrdAmt 
	Select @@NetDelAmt = @@NetDelAmt + @@DelAmt
	if @FlagForInclusiveBrokerage = 1 
	Begin 	
		Select @@Turn_Tax = (@@TrdAmt * @@TrdTTDuty) / 100 + (@@DelAmt * @@DelTTDuty) / 100 
		Select @@NetTurn_Tax = @@NetTurn_Tax + @@Turn_Tax 
		Select @@NetSebi_Tax = 0
		Select @@Sebi_Tax = 0
		Select @@NetIns_Chrg = 0 
		Select @@Ins_Chrg = 0 
		Select @@Broker_Chrg = (@@TrdAmt * @@TrdSTDuty) / 100 + (@@DelAmt * @@DelSTDuty) / 100 
		Select @@NetBroker_Chrg = @@NetBroker_Chrg + @@Broker_Chrg 
		Select @@NetOther_Chrg = 0
		Select @@Other_Chrg = 0 

		if @@Brokerage > 0  
			Select @@Brokerage = @@Brokerage - (( (@@TrdAmt * @@TrdTTDuty) / 100))    -     ( ( (@@TrdAmt * @@TrdSTDuty) / 100) )
	
		if @@DelBrokerage < Abs(((@@DelAmt * @@DelTTDuty) / 100) + ((@@DelAmt * @@DelSTDuty) / 100))
			Select @@Brokerage = @@Brokerage - ((@@DelAmt * @@DelTTDuty) / 100) - ((@@DelAmt * @@DelSTDuty) / 100)
		else 
			Select @@DelBrokerage = @@DelBrokerage - ((@@DelAmt * @@DelTTDuty) / 100) - ((@@DelAmt * @@DelSTDuty) / 100)		

		Select @@Service_Tax = @@Brokerage * @@Service_Chrg / 105 
		Select @@Brokerage = @@Brokerage - @@Service_Tax

		Select @@NetBrokerage = @@NetBrokerage + @@Brokerage 		
		Select @@DelBrokerage = @@DelBrokerage /*- ( @@DelBrokerage * @@Service_Chrg / 100 )*/		
		
		Select @@NetService_Tax = @@NetService_Tax + @@Service_Tax		
		Select @@NetDelBrokerage = @@NetDelBrokerage + @@DelBrokerage
		if @@ExService_Tax > 0 
			Select @@ExService_Tax = 0 /*@@NetService_Tax*/
		
		Select @@NetExService_Tax = @@NetExService_Tax + @@ExService_Tax 
	End
	Else
	Begin
		Select @@NetTurn_Tax = @@NetTurn_Tax + @@Turn_Tax
		Select @@NetSebi_Tax = @@NetSebi_Tax + @@Sebi_Tax
		Select @@NetIns_Chrg = @@NetIns_Chrg + @@Ins_Chrg
		Select @@NetBroker_Chrg = @@NetBroker_Chrg + @@Broker_Chrg 
		Select @@NetOther_Chrg = @@NetOther_Chrg + @@Other_Chrg
		Select @@NetBrokerage = @@NetBrokerage + @@Brokerage
		Select @@NetDelBrokerage = @@NetDelBrokerage + @@DelBrokerage
		Select @@NetService_Tax = @@NetService_Tax + @@Service_Tax
		Select @@NetExService_Tax = @@NetExService_Tax + @@ExService_Tax 
	End
		insert into AccBill Values ( @@ClrHsgParty,0,@@Sell_buy,@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
		       Round(@@Exchange,2),@@Branch_cd,'Bill Posted')	
				
	insert into AccBill Values ( @@BrkRelParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
		       Round(@@Brokerage,2),@@Branch_cd,'Bill Posted')	

	insert into AccBill Values ( @@DelChrgParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
		       Round(@@DelBrokerage,2),@@Branch_cd,'Bill Posted')
		
	insert into AccBill Values ( @@SerTaxParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
		       Round(@@Service_Tax,2),@@Branch_cd,'Bill Posted')

	insert into AccBill Values ( @@SerTaxPayParty,0,'1',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
		       Round(@@ExService_Tax,2),@@Branch_cd,'Bill Posted')
		
	insert into AccBill Values ( @@TurnTaxParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
		       Round(@@Turn_Tax,2),@@Branch_cd,'Bill Posted')

	insert into AccBill Values ( @@SebiTaxParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
		       Round(@@Sebi_Tax,2),@@Branch_cd,'Bill Posted')

	insert into AccBill Values ( @@InsChrgParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
		       Round(@@Ins_Chrg,2),@@Branch_cd,'Bill Posted')

	insert into AccBill Values ( @@BrkNoteParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
		       Round(@@Broker_Chrg,2),@@Branch_cd,'Bill Posted')

	insert into AccBill Values ( @@OthChrgParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
		       Round(@@Other_Chrg,2),@@Branch_cd,'Bill Posted')

	Fetch Next From @@ValanAmtCur into @@Branch_cd,@@Sell_buy,@@Exchange,@@Brokerage,@@DelBrokerage,@@Service_Tax,
					   @@ExService_Tax,@@Turn_Tax,@@Sebi_Tax,@@Ins_Chrg,@@Broker_Chrg,@@Other_Chrg,@@TrdAmt,@@DelAmt

End
Close @@ValanAmtCur
DeAllocate @@ValanAmtCur

Set @@ValanAmtCur = Cursor for
	Select Amount = Isnull(Sum(Amount),0),BranchCd,Sell_Buy From AccBill Where 
	sett_no = @Sett_No and Sett_Type = @Sett_Type and Branchcd <> 'ZZZ'
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
			insert into AccBill Values ( @@RndOffParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
	 	        	Round(@@NetDiffAmt,2),@@DummyBranch_Cd,'Bill Posted')
	Else if @@NetDiffAmt < 0 
			insert into AccBill Values ( @@RndOffParty,0,'1',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
	 	        	Round(Abs(@@NetDiffAmt),2),@@DummyBranch_Cd,'Bill Posted')		

End
Close @@ValanAmtCur
DeAllocate @@ValanAmtCur
	
if @@NetExchange >= 0 
	Select @@Sell_Buy = 1
Else
	Select @@Sell_Buy = 2

insert into AccBill Values ( @@ClrHsgParty,0,@@Sell_buy,@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
       Round(Abs(@@NetExchange),2),'ZZZ','Bill Posted')
			
insert into AccBill Values ( @@BrkRelParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
       Round(@@NetBrokerage,2),'ZZZ','Bill Posted')

insert into AccBill Values ( @@DelChrgParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
       Round(@@NetDelBrokerage,2),'ZZZ','Bill Posted')
	
insert into AccBill Values ( @@SerTaxParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
       Round(@@NetService_Tax,2),'ZZZ','Bill Posted')

insert into AccBill Values ( @@SerTaxPayParty,0,'1',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
       Round(@@NetExService_Tax,2),'ZZZ','Bill Posted')
	
insert into AccBill Values ( @@TurnTaxParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
       Round(@@NetTurn_Tax,2),'ZZZ','Bill Posted')

insert into AccBill Values ( @@SebiTaxParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
       Round(@@NetSebi_Tax,2),'ZZZ','Bill Posted')

insert into AccBill Values ( @@InsChrgParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
       Round(@@NetIns_Chrg,2),'ZZZ','Bill Posted')

insert into AccBill Values ( @@BrkNoteParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
       Round(@@NetBroker_Chrg,2),'ZZZ','Bill Posted' )

insert into AccBill Values ( @@OthChrgParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
       Round(@@NetOther_Chrg,2),'ZZZ','Bill Posted' )

Set @@ValanAmtCur = Cursor for
	Select OppCode,RevCode,AcCode from valanAccount where Reversed = 1 
	and EffDate = (Select Min(EffDate) from valanAccount
	Where EffDate >= @@End_Date ) Order by OppCode,RevCode
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
				Select Amount,Sell_Buy From AccBill where Sett_No = @Sett_No and Sett_Type = @Sett_Type
				and Party_Code = @@AcCode
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
			Close @@ValanAccCur
			DeAllocate @@ValanAccCur
			Fetch Next From @@ValanAmtCur into @@OppCode,@@RevCode,@@AcCode 
		End
		if @@RevAmt > 0 
			insert into AccBill Values ( @@DummyRevCode,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
		       		Round(@@RevAmt,2),'ZZZ','Bill Posted')		
		Else
			insert into AccBill Values ( @@DummyRevCode,0,'1',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
		       		Round(abs(@@RevAmt),2),'ZZZ','Bill Posted')		
	End	
	if @@OppAmt > 0  
		insert into AccBill Values ( @@DummyOppCode,0,'1',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
	       		Round(@@OppAmt,2),'ZZZ','Bill Posted')			
	Else
		insert into AccBill Values ( @@DummyOppCode,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
	       		Round(Abs(@@OppAmt),2),'ZZZ','Bill Posted')			
End
Close @@ValanAmtCur
DeAllocate @@ValanAmtCur



Select @@GrossDiffAmt = 0

Set @@ValanAmtCur = Cursor for

Select Amount = Isnull(Sum(Amount),0),Sell_Buy From AccBill A,Account.Dbo.AcMAst M 
Where sett_no = @Sett_No and Sett_Type = @Sett_Type 
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
	insert into AccBill Values ( @@RndOffParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
	        	Round(@@GrossDiffAmt,2),'ZZZ','Bill Posted')
Else 
	insert into AccBill Values ( @@RndOffParty,0,'1',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
 	        	Round(Abs(@@GrossDiffAmt),2),'ZZZ','Bill Posted')


/* Institutional Process */
Select @@NetBrokerage     = 0
Select @@NetDelBrokerage  = 0
Select @@NetService_Tax   = 0
Select @@NetExService_Tax = 0
Select @@NetDiffAmt       = 0
Select @@GrossDiffAmt     = 0

insert into IAccBill  
Select Party_Code,BillNo,Sell_buy = 1,sett_no,sett_type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
Amount = Round(Sum(Pamt) + Sum(SAmt),2),Branch_cd,'Bill Posted' 
from CMBillValan where sett_no = @Sett_No and sett_type = @Sett_Type And TradeType = 'I'
Group By sett_no,sett_type,Branch_cd,Party_code,BillNo

/* Exchange and levis Branch wise Obligation Amount */
Set @@ValanAmtCur = Cursor for	
	Select Branch_cd,Brokerage=Sum(PBrokTrd+SBrokTrd),DelBrokerage=Sum(PBrokDel+SBrokDel),
	Service_Tax=Sum(Service_Tax),ExService_Tax=Sum(ExService_Tax)
	from CMBillValan where sett_no = @Sett_No and sett_type = @Sett_Type And TradeType = 'I'
	Group By sett_no,sett_type,Branch_cd
	Order By sett_no,sett_type,Branch_cd
Open @@ValanAmtCur 
Fetch Next From @@ValanAmtCur into @@Branch_cd,@@Brokerage,@@DelBrokerage,@@Service_Tax,@@ExService_Tax
While @@Fetch_Status = 0 
Begin
	if @FlagForInclusiveBrokerage = 1 
	Begin 			
		Select @@Service_Tax = @@Brokerage * @@Service_Chrg / 105 
		Select @@Brokerage = @@Brokerage - @@Service_Tax

		Select @@NetBrokerage = @@NetBrokerage + @@Brokerage 		
	
		Select @@NetService_Tax = @@NetService_Tax + @@Service_Tax		
		Select @@NetDelBrokerage = @@NetDelBrokerage + @@DelBrokerage
		if @@ExService_Tax > 0 
			Select @@ExService_Tax = 0 /*@@NetService_Tax*/
		
		Select @@NetExService_Tax = @@NetExService_Tax + @@ExService_Tax 
	End
	Else
	Begin
		Select @@NetBrokerage = @@NetBrokerage + @@Brokerage
		Select @@NetDelBrokerage = @@NetDelBrokerage + @@DelBrokerage
		Select @@NetService_Tax = @@NetService_Tax + @@Service_Tax
		Select @@NetExService_Tax = @@NetExService_Tax + @@ExService_Tax 
	End

	insert into IAccBill Values ( @@BrkRelParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,	
	       Round(@@Brokerage,2),@@Branch_cd,'Bill Posted')

	insert into IAccBill Values ( @@DelChrgParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
	       Round(@@DelBrokerage,2),@@Branch_cd,'Bill Posted')
	
	insert into IAccBill Values ( @@SerTaxParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
	       Round(@@Service_Tax,2),@@Branch_cd,'Bill Posted')

	insert into IAccBill Values ( @@SerTaxPayParty,0,'1',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
	       Round(@@ExService_Tax,2),@@Branch_cd,'Bill Posted')	

	Fetch Next From @@ValanAmtCur into @@Branch_cd,@@Brokerage,@@DelBrokerage,@@Service_Tax,@@ExService_Tax
End
Close @@ValanAmtCur
DeAllocate @@ValanAmtCur

insert into IAccBill Values ( @@BrkRelParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,	
       Round(@@NetBrokerage,2),'ZZZ','Bill Posted')

insert into IAccBill Values ( @@DelChrgParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
       Round(@@NetDelBrokerage,2),'ZZZ','Bill Posted')

insert into IAccBill Values ( @@SerTaxParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
       Round(@@NetService_Tax,2),'ZZZ','Bill Posted')

insert into IAccBill Values ( @@SerTaxPayParty,0,'1',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
	       Round(@@NetExService_Tax,2),'ZZZ','Bill Posted')

Set @@ValanAmtCur = Cursor for
	Select Amount = Isnull(Sum(Amount),0),BranchCd,Sell_Buy From IAccBill Where 
	sett_no = @Sett_No and Sett_Type = @Sett_Type and Branchcd <> 'ZZZ'
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
			insert into IAccBill Values ( @@RndOffParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
	 	        	Round(@@NetDiffAmt,2),@@DummyBranch_Cd,'Bill Posted')
	Else if @@NetDiffAmt < 0 
			insert into IAccBill Values ( @@RndOffParty,0,'1',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
	 	        	Round(Abs(@@NetDiffAmt),2),@@DummyBranch_Cd,'Bill Posted')		

End
Close @@ValanAmtCur
DeAllocate @@ValanAmtCur



Select @@GrossDiffAmt = 0

Set @@ValanAmtCur = Cursor for

Select Amount = Isnull(Sum(Amount),0),Sell_Buy From IAccBill A,Account.Dbo.AcMAst M 
Where sett_no = @Sett_No and Sett_Type = @Sett_Type 
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
	insert into IAccBill Values ( @@RndOffParty,0,'2',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
	        	Round(@@GrossDiffAmt,2),'ZZZ','Bill Posted')
Else 
	insert into IAccBill Values ( @@RndOffParty,0,'1',@Sett_No,@Sett_Type,@@Start_Date,@@End_Date,@@Sec_Payin,@@Sec_Payout,
 	        	Round(Abs(@@GrossDiffAmt),2),'ZZZ','Bill Posted')

GO
