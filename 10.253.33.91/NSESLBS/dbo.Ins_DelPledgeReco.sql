-- Object: PROCEDURE dbo.Ins_DelPledgeReco
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC Ins_DelPledgeReco As
Declare 
@DpId Varchar(8),
@CltDpId Varchar(16), 
@IsIn Varchar(12), 
@PledgeBal int, 
@PldCur Cursor,
@DelPldCur Cursor,
@SNo Numeric(18,0),
@Sett_No Varchar(7),
@Sett_Type Varchar(2),
@Party_Code Varchar(10),
@HoldQty Int
Select DpId, CltDpId, IsIn, FreeBal, PledgeBal,
HoldFreeBal = 0, HoldPledgeBal = 0
Into #DelCdslBalance From DelCdslBalance
Where pledgebal > 0
And CltDpId In (Select DpCltNo From DeliveryDp Where Description Not Like '%POOL%')

Update #DelCdslBalance Set 
HoldPledgeBal = Qty
From (Select BDpId, BCltDpId, CertNo, Qty=Sum(Qty) From DelTrans
Where DrCr = 'D' And Filler2 = 1 And TrType = 909 And Delivered = '0'
Group By BDpId, BCltDpId, CertNo) D
Where #DelCdslBalance.DpId = D.BDpId
And #DelCdslBalance.CltDpId = D.BCltDpId
And #DelCdslBalance.IsIn = D.CertNo

Set @PldCur = CurSor For
Select DpId, CltDpId, IsIn, PledgeBal-HoldPledgeBal From #DelCdslBalance
Where PledgeBal <> HoldPledgeBal
Order By DpId, CltDpId, IsIn
Open @PldCur 
Fetch Next From @PldCur Into @DpId, @CltDpId, @IsIn, @PledgeBal
While @@FETCH_STATUS = 0 
Begin
	if @PledgeBal > 0
	Begin
	-- To Increase Pledge Balance in DelTrans
		Set @DelPldCur = Cursor For
		Select Sno, Sett_No, Sett_Type, Party_Code, Qty From DelTrans
		Where BDpId = @DpId And BCltDpId = @CltDpId
		And DrCr = 'D' And Filler2 = 1 
		And TrType = 904 And Delivered = '0'
		And CertNo = @IsIn
		Order By Sett_No, Sett_Type, Party_Code, Qty Desc
		Open @DelPldCur
		Fetch Next From @DelPldCur Into @Sno, @Sett_No, @Sett_Type, @Party_Code, @HoldQty
		While @@Fetch_Status = 0 And @PledgeBal > 0
		Begin
			if @PledgeBal >= @HoldQty
			Begin
				Update DelTrans	Set TrType = 909, Reason = 'PLEDGE TRANSFER'
				Where Sno = @Sno
				Set @PledgeBal = @PledgeBal - @HoldQty
			End
			Else
			Begin
				Insert Into DelTrans
				Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,
				Qty = @HoldQty - @PledgeBal,FromNo,ToNo,CertNo,FolioNo,HolderName,Reason,DrCr,Delivered,
				OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,
				ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
				From DelTrans Where Sno = @Sno

				Update DelTrans	Set TrType = 909, Reason = 'PLEDGE TRANSFER', Qty = @PledgeBal
				Where Sno = @Sno

				Set @PledgeBal = 0
			End
			Fetch Next From @DelPldCur Into @Sno, @Sett_No, @Sett_Type, @Party_Code, @HoldQty				
		End
		Close @DelPldCur
		DeAllocate @DelPldCur
	End
	Else
	Begin
	-- To Decrease Pledge Balance in DelTrans
		Set @PledgeBal = ABS(@PledgeBal)
		Set @DelPldCur = Cursor For
		Select Sno, Sett_No, Sett_Type, Party_Code, Qty From DelTrans
		Where BDpId = @DpId And BCltDpId = @CltDpId
		And DrCr = 'D' And Filler2 = 1 
		And TrType = 909 And Delivered = '0'
		And CertNo = @IsIn
		Order By Sett_No, Sett_Type, Party_Code, Qty Desc
		Open @DelPldCur
		Fetch Next From @DelPldCur Into @Sno, @Sett_No, @Sett_Type, @Party_Code, @HoldQty
		While @@Fetch_Status = 0 And @PledgeBal > 0
		Begin
			if @PledgeBal >= @HoldQty
			Begin
				Update DelTrans	Set TrType = 904, Reason = 'DEMAT'
				Where Sno = @Sno
				Set @PledgeBal = @PledgeBal - @HoldQty
			End
			Else
			Begin
				Insert Into DelTrans
				Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,
				Qty = @HoldQty - @PledgeBal,FromNo,ToNo,CertNo,FolioNo,HolderName,Reason,DrCr,Delivered,
				OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,
				ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
				From DelTrans Where Sno = @Sno

				Update DelTrans	Set TrType = 904, Reason = 'DEMAT', Qty = @PledgeBal
				Where Sno = @Sno

				Set @PledgeBal = 0
			End
			Fetch Next From @DelPldCur Into @Sno, @Sett_No, @Sett_Type, @Party_Code, @HoldQty				
		End
		Close @DelPldCur
		DeAllocate @DelPldCur
	End
	Fetch Next From @PldCur Into @DpId, @CltDpId, @IsIn, @PledgeBal
End
Close @PldCur
DeAllocate @PldCur

GO
