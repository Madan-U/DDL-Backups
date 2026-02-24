-- Object: PROCEDURE dbo.InsDelTransPrintPool
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc InsDelTransPrintPool (@OptFlag Int, @BDpType Varchar(4), @BDpId Varchar(8), @BCltDpID Varchar(16)) 
As
Declare 
@Sett_no Varchar(7),
@Sett_Type Varchar(2),
@SNo Numeric,
@Qty int,
@diffQty int,
@SlipNo Int,
@BatchNo int,
@TransDate Varchar(11),
@HolderName Varchar(30),
@FolioNo Varchar(20),
@Party_Code Varchar(10),
@CertNo Varchar(12),
@TrType Int,
@DpId Varchar(8),
@CltDpId Varchar(16),
@DelBDpId Varchar(8),
@DelBCltDpId Varchar(16),
@AllQty Int,
@DelCur Cursor,
@BenCur Cursor

If @OptFlag = 1 
Begin
Update DelTrans Set Delivered = 'G', SlipNo = D.SlipNo, 
BatchNo = D.BatchNo, FolioNo = D.FolioNo,
TransDate = D.TransDate, HolderName = d.HolderName
From DelTransPrintPool D
Where DelTrans.Sett_No = D.Sett_No
And DelTrans.Sett_Type = D.Sett_Type
And DelTrans.Party_Code >= D.FromParty
And DelTrans.Party_Code <= D.ToParty
And DelTrans.Scrip_Cd Like '%'
And DelTrans.Series Like '%'
And DelTrans.CertNo = D.CertNo
And DelTrans.TrType = D.TrType
And Filler2 = 1
And DrCr = 'D'
And DelTrans.BDpType = D.BDpType
And DelTrans.BDpId = D.BDpId
And DelTrans.BCltDpId = D.BCltDpId
And Delivered = '0'
And DelTrans.ISett_No = D.ISett_No
And DelTrans.ISett_Type = D.ISett_Type
And OptionFlag = 1  And DelTrans.Party_Code <> 'BROKER'
End

If @OptFlag = 3
Begin
Update DelTrans Set Delivered = 'G', SlipNo = D.SlipNo, 
BatchNo = D.BatchNo, FolioNo = D.FolioNo,
TransDate = D.TransDate, HolderName = d.HolderName
From DelTransPrintPool D
Where DelTrans.Sett_No = D.Sett_No
And DelTrans.Sett_Type = D.Sett_Type
And DelTrans.Party_Code >= D.FromParty
And DelTrans.Party_Code <= D.ToParty
And DelTrans.Party_Code = D.Party_Code
And DelTrans.Scrip_Cd Like '%'
And DelTrans.Series Like '%'
And DelTrans.CertNo = D.CertNo
And DelTrans.TrType = D.TrType
And Filler2 = 1
And DrCr = 'D'
And DelTrans.BDpType = D.BDpType
And DelTrans.BDpId = D.BDpId
And DelTrans.BCltDpId = D.BCltDpId
And Delivered = '0'
And DelTrans.DpId = D.DpId
And DelTrans.CltDpId = D.CltDpId
And OptionFlag = 3
And D.Qty = NewQty 
And DelTrans.Party_Code <> 'BROKER'

Insert Into DelTransTemp
Select DelTrans.Sno,DelTrans.Sett_No,DelTrans.Sett_type,DelTrans.RefNo,DelTrans.TCode,DelTrans.TrType,
DelTrans.Party_Code,DelTrans.scrip_cd,DelTrans.series,DelTrans.Qty,DelTrans.FromNo,DelTrans.ToNo,
DelTrans.CertNo,DelTrans.FolioNo,DelTrans.HolderName,DelTrans.Reason,DelTrans.DrCr,'D',DelTrans.OrgQty,
DelTrans.DpType,DelTrans.DpId,DelTrans.CltDpId,DelTrans.BranchCd,DelTrans.PartipantCode,DelTrans.SlipNo,
DelTrans.BatchNo,DelTrans.ISett_No,DelTrans.ISett_Type,DelTrans.ShareType,DelTrans.TransDate,DelTrans.Filler1,
DelTrans.Filler2,DelTrans.Filler3,DelTrans.BDpType,DelTrans.BDpId,DelTrans.BCltDpId,DelTrans.Filler4,DelTrans.Filler5
From DelTrans, DelTransPrintPool D
Where DelTrans.Sett_No = D.Sett_No
And DelTrans.Sett_Type = D.Sett_Type
And DelTrans.Party_Code >= D.FromParty
And DelTrans.Party_Code <= D.ToParty
And DelTrans.Party_Code = D.Party_Code
And DelTrans.Scrip_Cd Like '%'
And DelTrans.Series Like '%'
And DelTrans.CertNo = D.CertNo
And DelTrans.TrType = D.TrType
And Filler2 = 1
And DrCr = 'D'
And DelTrans.BDpType = D.BDpType
And DelTrans.BDpId = D.BDpId
And DelTrans.BCltDpId = D.BCltDpId
And Delivered = 'G'
And DelTrans.DpId = D.DpId
And DelTrans.CltDpId = D.CltDpId
And DelTrans.FolioNo = D.FolioNo
And DelTrans.SlipNo = D.SlipNo
And DelTrans.BatchNo = D.BatchNo
And OptionFlag = 3
And D.Qty = NewQty 
And DelTrans.Party_Code <> 'BROKER'

Set @BenCur = Cursor For
Select Sett_No, Sett_Type, Party_Code, CertNo, TrType, DpId, CltDpId, SlipNo, BatchNo, FolioNo, 
HolderName, Qty , TransDate = Left(Convert(Varchar,TransDate,109),11), BDpId, BCltDpId
From DelTransPrintPool Where OptionFlag = 3 And Qty <> NewQty 
Order BY Party_Code, CertNo
Open @BenCur
Fetch Next From @BenCur into @Sett_No, @Sett_Type, @Party_Code, @CertNo, @TrType, @DpId, @CltDpId, @SlipNo, @BatchNo, @FolioNo, 
@HolderName, @AllQty , @TransDate, @DelBDpId, @DelBCltDpId
Select @Party_Code, @CertNo, @TrType, @DpId, @CltDpId, @SlipNo, @BatchNo, @FolioNo, 
@HolderName, @AllQty , @TransDate, @DelBDpId, @DelBCltDpId
While @@Fetch_Status = 0 
Begin
	Select @DiffQty = @AllQty
	Set @DelCur = Cursor For
	Select Sno, Qty From DelTrans
	Where Party_Code = @Party_Code
	And CertNo = @CertNo
	And TrType = @TrType
	And DrCr = 'D'
	And Delivered = '0'
	And Filler2 = 1 
	And DpId = @DpId
	And CltDpId = @CltDpId
	And BDpId = @DelBDpId
	And BCltDpId = @DelBCltDpId
	Order By Sett_No, Sett_Type, Qty Desc
	Open @DelCur
	Fetch Next From @DelCur into @Sno, @Qty	
	While @@Fetch_Status = 0 And @DiffQty > 0 
	Begin
		If @DiffQty >= @Qty
		Begin
			Update DelTrans Set SlipNo = @Slipno, BatchNo = @BatchNo, FolioNo = @Foliono,
			HolderName = @HolderName, TransDate = @TransDate, Delivered = 'G'
			Where Sett_no = @Sett_No
			And Sett_Type = @Sett_Type
			And Sno = @Sno
			Select @DiffQty = @DiffQty - @Qty
		End
		Else
		Begin
			Insert Into DelTrans
			Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,@Qty-@DiffQty,FromNo,ToNo,
			CertNo,FolioNo,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,
			PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,
			Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5 From DelTrans
			Where Sett_no = @Sett_No
			And Sett_Type = @Sett_Type
			And Sno = @Sno

			Update DelTrans Set SlipNo = @Slipno, BatchNo = @BatchNo, FolioNo = @Foliono,
			HolderName = @HolderName, TransDate = @TransDate, Delivered = 'G', Qty = @DiffQty
			Where Sett_no = @Sett_No
			And Sett_Type = @Sett_Type
			And Sno = @Sno

			Select @DiffQty = 0 
		End
		Fetch Next From @DelCur into @Sno, @Qty	
	End
	Fetch Next From @BenCur into @Sett_No, @Sett_Type,@Party_Code, @CertNo, @TrType, @DpId, @CltDpId, @SlipNo, @BatchNo, @FolioNo, 
	@HolderName, @AllQty , @TransDate, @DelBDpId, @DelBCltDpId
End

Insert Into DelTransTemp
Select DelTrans.Sno,DelTrans.Sett_No,DelTrans.Sett_type,DelTrans.RefNo,DelTrans.TCode,DelTrans.TrType,
DelTrans.Party_Code,DelTrans.scrip_cd,DelTrans.series,DelTrans.Qty,DelTrans.FromNo,DelTrans.ToNo,
DelTrans.CertNo,DelTrans.FolioNo,DelTrans.HolderName,DelTrans.Reason,DelTrans.DrCr,'D',DelTrans.OrgQty,
DelTrans.DpType,DelTrans.DpId,DelTrans.CltDpId,DelTrans.BranchCd,DelTrans.PartipantCode,DelTrans.SlipNo,
DelTrans.BatchNo,DelTrans.ISett_No,DelTrans.ISett_Type,DelTrans.ShareType,DelTrans.TransDate,DelTrans.Filler1,
DelTrans.Filler2,DelTrans.Filler3,DelTrans.BDpType,DelTrans.BDpId,DelTrans.BCltDpId,DelTrans.Filler4,DelTrans.Filler5
From DelTrans, DelTransPrintPool D
Where DelTrans.Sett_No = D.Sett_No
And DelTrans.Sett_Type = D.Sett_Type
And DelTrans.Party_Code >= D.FromParty
And DelTrans.Party_Code <= D.ToParty
And DelTrans.Party_Code = D.Party_Code
And DelTrans.Scrip_Cd Like '%'
And DelTrans.Series Like '%'
And DelTrans.CertNo = D.CertNo
And DelTrans.TrType = D.TrType
And Filler2 = 1
And DrCr = 'D'
And DelTrans.BDpType = D.BDpType
And DelTrans.BDpId = D.BDpId
And DelTrans.BCltDpId = D.BCltDpId
And Delivered = 'G'
And DelTrans.DpId = D.DpId
And DelTrans.CltDpId = D.CltDpId
And DelTrans.FolioNo = D.FolioNo
And DelTrans.SlipNo = D.SlipNo
And DelTrans.BatchNo = D.BatchNo
And OptionFlag = 3
And D.Qty <> NewQty

End

If @OptFlag = 2
Begin
Update DelTrans Set Delivered = 'G', SlipNo = D.SlipNo, 
BatchNo = D.BatchNo, FolioNo = D.FolioNo,
TransDate = D.TransDate, HolderName = d.HolderName
From DelTransPrintPool D
Where DelTrans.Sett_No = D.Sett_No
And DelTrans.Sett_Type = D.Sett_Type
And DelTrans.Party_Code >= D.FromParty
And DelTrans.Party_Code <= D.ToParty
And DelTrans.Scrip_Cd Like '%'
And DelTrans.Series Like '%'
And DelTrans.CertNo = D.CertNo
And DelTrans.TrType = D.TrType
And Filler2 = 1
And DrCr = 'D'
And DelTrans.BDpType = D.BDpType
And DelTrans.BDpId = D.BDpId
And DelTrans.BCltDpId = D.BCltDpId
And Delivered = '0'
And OptionFlag = 2
And DelTrans.Party_Code <> 'BROKER'

Insert Into DelTransTemp
Select DelTrans.Sno,DelTrans.Sett_No,DelTrans.Sett_type,DelTrans.RefNo,DelTrans.TCode,DelTrans.TrType,
DelTrans.Party_Code,DelTrans.scrip_cd,DelTrans.series,DelTrans.Qty,DelTrans.FromNo,DelTrans.ToNo,
DelTrans.CertNo,DelTrans.FolioNo,DelTrans.HolderName,DelTrans.Reason,DelTrans.DrCr,'0',DelTrans.OrgQty,
DelTrans.DpType,DelTrans.DpId,DelTrans.CltDpId,DelTrans.BranchCd,DelTrans.PartipantCode,DelTrans.SlipNo,
DelTrans.BatchNo,DelTrans.ISett_No,DelTrans.ISett_Type,DelTrans.ShareType,DelTrans.TransDate,DelTrans.Filler1,
DelTrans.Filler2,DelTrans.Filler3,@BDpType,@BDpId,@BCltDpId,DelTrans.Filler4,DelTrans.Filler5
From DelTrans, DelTransPrintPool D
Where DelTrans.Sett_No = D.Sett_No
And DelTrans.Sett_Type = D.Sett_Type
And DelTrans.Party_Code >= D.FromParty
And DelTrans.Party_Code <= D.ToParty
And DelTrans.Scrip_Cd Like '%'
And DelTrans.Series Like '%'
And DelTrans.CertNo = D.CertNo
And DelTrans.TrType = D.TrType
And Filler2 = 1
And DrCr = 'D'
And DelTrans.BDpType = D.BDpType
And DelTrans.BDpId = D.BDpId
And DelTrans.BCltDpId = D.BCltDpId
And Delivered = 'G'
And OptionFlag = 2
And DelTrans.FolioNo = D.FolioNo
And DelTrans.SlipNo = D.SlipNo
And DelTrans.BatchNo = D.BatchNo
And DelTrans.Party_Code <> 'BROKER'

End

GO
