-- Object: PROCEDURE dbo.Rpt_NSEDelBranchMark
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc Rpt_NSEDelBranchMark
@SettNo Varchar(7),
@SettType Varchar(2),
@Party_Code Varchar(10),
@IsIn Varchar(12)
As
Declare 

@DelMarkQty Int,
@DelQty Int,
@SNo Numeric,
@DelCur Cursor,
@DelQtyCur Cursor

Set @DelCur = Cursor For
Select Sett_No,Sett_Type,Party_Code,CertNo,DelMarkQty=DelMarkQty-PayOutGiven
From DelBranchMark Where Aproved = 1 And DelMarkQty-PayOutGiven > 0 
Order By Sett_No,Sett_Type,Party_Code,Scrip_Cd,Series,CertNo
Open @DelCur
Fetch Next From @DelCur Into @SettNo,@SettType,@Party_Code,@IsIn,@DelMarkQty
While @@Fetch_Status = 0 
Begin
	Set @DelQtyCur = Cursor For
	Select IsNull(Sum(Qty),0) From DelTrans Where Party_Code = @Party_Code
	And CertNo = @IsIn And Sett_No = @SettNo And Sett_Type = @SettType	
	And Filler2 = 1 And DrCr = 'D' And TrType = 904 And CertNo <> 'AUCTION'
	Open @DelQtyCur
	Fetch Next From @DelQtyCur into @DelQty
	If @DelQty <= @DelMarkQty And @DelQty > 0 
	Begin
		Update DelTrans Set TrType = 905 Where Party_Code = @Party_Code
		And CertNo = @IsIn And Sett_No = @SettNo And Sett_Type = @SettType	
		And Filler2 = 1 And DrCr = 'D' And TrType = 904 And CertNo <> 'AUCTION'
		
		Update DelBranchMark Set PayOutGiven = PayOutGiven + @DelQty
		Where Aproved = 1 And DelMarkQty-PayOutGiven > 0
		And Party_Code = @Party_Code And CertNo = @IsIn 
		And Sett_No = @SettNo And Sett_Type = @SettType	
	End
	Else
	Begin
		Close @DelQtyCur
		DeAllocate @DelQtyCur
		Set @DelQtyCur = Cursor For	
		Select SNo,Qty From DelTrans Where Party_Code = @Party_Code
		And CertNo = @IsIn And Sett_No = @SettNo And Sett_Type = @SettType	
		And Filler2 = 1 And DrCr = 'D' And TrType = 904 And CertNo <> 'AUCTION'
		Open @DelQtyCur
		Fetch Next From @DelQtyCur into @SNo,@DelQty
		While @@Fetch_Status = 0 
		Begin
			If @DelQty <= @DelMarkQty And @DelMarkQty > 0 
			Begin
				Update DelTrans Set TrType = 905 Where Party_Code = @Party_Code
				And CertNo = @IsIn And Sett_No = @SettNo And Sett_Type = @SettType	
				And Filler2 = 1 And DrCr = 'D' And TrType = 904 And SNo = @SNo And CertNo <> 'AUCTION'
		
				Update DelBranchMark Set PayOutGiven = PayOutGiven + @DelQty
				Where Aproved = 1 And DelMarkQty-PayOutGiven > 0
				And Party_Code = @Party_Code And CertNo = @IsIn 
				And Sett_No = @SettNo And Sett_Type = @SettType

				Set @DelMarkQty = @DelMarkQty - @DelQty
			End
			Else if @DelMarkQty > 0 
			Begin
				Insert into DelTrans
				Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty=@DelQty-@DelMarkQty,
				FromNo,ToNo,CertNo,FolioNo,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,
				BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,
				Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5
				From DelTrans Where Party_Code = @Party_Code
				And CertNo = @IsIn And Sett_No = @SettNo And Sett_Type = @SettType	
				And Filler2 = 1 And DrCr = 'D' And TrType = 904 And SNo = @SNo
				And CertNo <> 'AUCTION'
				Update DelTrans Set TrType = 905, Qty = @DelMarkQty Where Party_Code = @Party_Code
				And CertNo = @IsIn And Sett_No = @SettNo And Sett_Type = @SettType	
				And Filler2 = 1 And DrCr = 'D' And TrType = 904 And SNo = @SNo	
				And CertNo <> 'AUCTION'
				Update DelBranchMark Set PayOutGiven = PayOutGiven + @DelMarkQty
				Where Aproved = 1 And DelMarkQty-PayOutGiven > 0
				And Party_Code = @Party_Code And CertNo = @IsIn 
				And Sett_No = @SettNo And Sett_Type = @SettType

				Set @DelMarkQty = 0 			
			End
			Fetch Next From @DelQtyCur into @SNo,@DelQty
		End
	End
	Close @DelQtyCur
	DeAllocate @DelQtyCur
	Fetch Next From @DelCur Into @SettNo,@SettType,@Party_Code,@IsIn,@DelMarkQty
End
Close @DelCur
DeAllocate @DelCur

GO
