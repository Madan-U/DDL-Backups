-- Object: PROCEDURE dbo.HoldingReco
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc HoldingReco as 
Declare 
@TCode numeric,
@Party_code Varchar(10),
@Qty numeric,
@MSno numeric,
@Sno numeric,
@PQty numeric,
@RemQty numeric,
@CertNo Varchar(12),
@Sett_No Varchar(7),
@Sett_Type Varchar(2),
@DelCur Cursor,
@QtyCur Cursor
Set @DelCur = Cursor for
Select Sno,TCode,Party_Code,Qty,Sett_No,Sett_Type,CertNo From AniDel Where DrCr = 'D'
And Filler2 = 1 And BCltDpId = '1202020000000937' 
And Party_Code <> 'BROKER' And TrType <> 906 And CertNo >= 'INE326A01029'
Order By CertNo
Open @Delcur
Fetch next from @Delcur into @MSno,@TCode,@Party_Code,@Qty,@Sett_No,@Sett_Type,@CertNo
While @@Fetch_Status = 0 
Begin
	Select @MSno,@TCode,@Party_Code,@Qty,@Sett_No,@Sett_Type,@CertNo
	Set @QtyCur = Cursor For
	Select Sno,Qty From AniDel Where CertNo = @CertNo And DrCr = 'D'
	And Filler2 = 0 And BCltDpId <> '1202020000000937'
	And Party_Code = @Party_Code And TrType <> 906 And Delivered = 'G'	
	And Sett_No = @Sett_No And Sett_Type = @Sett_Type And TCode = @TCode
	And HolderName Not Like 'BEN 1202020000000937'
	Open @Qtycur	
	Fetch Next From @Qtycur into @Sno,@PQty
	Select @Sno,@PQty
	if @@Fetch_Status = 0
	Begin
		While @Qty > 0 And @@Fetch_Status = 0
		Begin
			if @Qty >= @PQty
			Begin
				Update AniDel Set HolderName = 'BEN 1202020000000937'
				Where Sno = @Sno
				Select @Qty = @Qty - @PQty		
			End
			Else if @Qty < @PQty
			Begin
				Insert into AniDel
				Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,@Qty,FromNo,ToNo,
				CertNo,FolioNo,'BEN 1202020000000937',Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,
				PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,
				Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
				From AniDel Where Sno = @Sno
	
				Update AniDel Set Qty = @PQty - @Qty Where Sno = @Sno
				Select @Qty = 0
			End
			Fetch Next From @Qtycur into @Sno,@PQty		
		End
	End
	Else
	Begin
		Insert into AniDel
		Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,@Qty,FromNo,ToNo,
		CertNo,FolioNo,'BEN 1202020000000937',Reason,DrCr,'G',OrgQty,DpType,DpId,CltDpId,BranchCd,
		PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,0,
		Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
		From AniDel Where CertNo = @CertNo And DrCr = 'D'
		And Filler2 = 1 And BCltDpId = '1202020000000937'
		And Party_Code = @Party_Code And TrType <> 906 
		And Sett_No = @Sett_No And Sett_Type = @Sett_Type And TCode = @TCode		
		And Sno = @MSno
	End
	Close @Qtycur
	Fetch next from @Delcur into @MSno,@TCode,@Party_Code,@Qty,@Sett_No,@Sett_Type,@CertNo	
End
Close @Delcur
Deallocate @Delcur

GO
