-- Object: PROCEDURE dbo.InsDelTransPrintBen_kar
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.InsDelTransPrintBen    Script Date: 01/31/2005 1:26:28 PM ******/    
CREATE Proc InsDelTransPrintBen_kar (@OptFlag Int, @BDpType Varchar(4), @BDpId Varchar(8), @BCltDpID Varchar(16))       
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
      
If @OptFlag = 4      
Begin      
Update DelTrans Set Delivered = 'G', SlipNo = D.SlipNo,       
BatchNo = D.BatchNo, FolioNo = D.FolioNo,      
TransDate = D.TransDate, HolderName = d.HolderName      
From DelTransPrintBen D With(Index(DelPrint))  
Where Filler2 = 1      
And DelTrans.Party_Code >= D.FromParty      
And DelTrans.Party_Code <= D.ToParty      
And DelTrans.Party_Code = D.Party_Code      
And DelTrans.Scrip_Cd Like '%'      
And DelTrans.Series Like '%'      
And DelTrans.CertNo = D.CertNo      
And DelTrans.TrType = D.TrType      
And DrCr = 'D'      
And DelTrans.BDpType = D.BDpType      
And DelTrans.BDpId = D.BDpId      
And DelTrans.BCltDpId = D.BCltDpId      
And Delivered = '0'      
And DelTrans.DpId = D.DpId      
And DelTrans.CltDpId = D.CltDpId      
And OptionFlag = 4      
And D.Qty = NewQty      
      
Insert Into DelTransTemp      
Select DelTrans.Sno,DelTrans.Sett_No,DelTrans.Sett_type,DelTrans.RefNo,DelTrans.TCode,DelTrans.TrType,      
DelTrans.Party_Code,DelTrans.scrip_cd,DelTrans.series,DelTrans.Qty,DelTrans.FromNo,DelTrans.ToNo,      
DelTrans.CertNo,DelTrans.FolioNo,DelTrans.HolderName,DelTrans.Reason,DelTrans.DrCr,'D',DelTrans.OrgQty,      
DelTrans.DpType,DelTrans.DpId,DelTrans.CltDpId,DelTrans.BranchCd,DelTrans.PartipantCode,DelTrans.SlipNo,      
DelTrans.BatchNo,DelTrans.ISett_No,DelTrans.ISett_Type,DelTrans.ShareType,DelTrans.TransDate,DelTrans.Filler1,      
DelTrans.Filler2,DelTrans.Filler3,DelTrans.BDpType,DelTrans.BDpId,DelTrans.BCltDpId,DelTrans.Filler4,DelTrans.Filler5      
From DelTrans , DelTransPrintBen D With(Index(DelPrint))     
Where Filler2 = 1      
And DelTrans.Party_Code >= D.FromParty      
And DelTrans.Party_Code <= D.ToParty      
And DelTrans.Party_Code = D.Party_Code      
And DelTrans.Scrip_Cd Like '%'      
And DelTrans.Series Like '%'      
And DelTrans.CertNo = D.CertNo      
And DelTrans.TrType = D.TrType      
And DrCr = 'D'      
And DelTrans.BDpType = D.BDpType      
And DelTrans.BDpId = D.BDpId      
And DelTrans.BCltDpId = D.BCltDpId      
And Delivered = 'G'      
And DelTrans.DpId = D.DpId      
And DelTrans.CltDpId = D.CltDpId      
And DelTrans.FolioNo = D.FolioNo      
And OptionFlag = 4      
And D.Qty = NewQty      
      
Set @BenCur = Cursor For      
Select Party_Code, CertNo, TrType, DpId, CltDpId, SlipNo, BatchNo, FolioNo,       
HolderName, Qty , TransDate = Left(Convert(Varchar,TransDate,109),11), BDpId, BCltDpId      
From DelTransPrintBen Where OptionFlag = 4 And Qty <> NewQty       
Order BY Party_Code, CertNo      
Open @BenCur      
Fetch Next From @BenCur into @Party_Code, @CertNo, @TrType, @DpId, @CltDpId, @SlipNo, @BatchNo, @FolioNo,       
@HolderName, @AllQty , @TransDate, @DelBDpId, @DelBCltDpId      
While @@Fetch_Status = 0       
Begin      
 Select @DiffQty = @AllQty      
 Set @DelCur = Cursor For      
 Select Sett_no, Sett_Type, Sno, Qty From DelTrans      
 Where Filler2 = 1       
 And Party_Code = @Party_Code      
 And CertNo = @CertNo      
 And TrType = @TrType      
 And DrCr = 'D'      
 And Delivered = '0'      
 And DpId = @DpId      
 And CltDpId = @CltDpId      
 And BDpId = @DelBDpId      
 And BCltDpId = @DelBCltDpId      
 Order By Sett_No, Sett_Type, Qty Desc      
 Open @DelCur      
 Fetch Next From @DelCur into @Sett_No, @Sett_Type, @Sno, @Qty       
 Select @Sett_No, @Sett_Type, @Sno, @Qty      
 While @@Fetch_Status = 0 And @DiffQty > 0       
 Begin      
  If @DiffQty >= @Qty      
  Begin      
   Update DelTrans Set SlipNo = @Slipno, BatchNo = @BatchNo, FolioNo = @Foliono,      
   HolderName = @HolderName, TransDate = @TransDate, Delivered = 'G'      
   Where Sno = @Sno      
   Select @DiffQty = @DiffQty - @Qty      
  End      
  Else      
  Begin      
   Insert Into DelTrans      
   Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,@Qty-@DiffQty,FromNo,ToNo,      
   CertNo,FolioNo,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,      
   PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,      
   Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5 From DelTrans      
   Where Sno = @Sno      
      
   Update DelTrans Set SlipNo = @Slipno, BatchNo = @BatchNo, FolioNo = @Foliono,      
   HolderName = @HolderName, TransDate = @TransDate, Delivered = 'G', Qty = @DiffQty      
   Where Sno = @Sno      
      
   Select @DiffQty = 0       
  End      
  Fetch Next From @DelCur into @Sett_No, @Sett_Type, @Sno, @Qty      
 End      
 Fetch Next From @BenCur into @Party_Code, @CertNo, @TrType, @DpId, @CltDpId, @SlipNo, @BatchNo, @FolioNo,       
 @HolderName, @AllQty , @TransDate, @DelBDpId, @DelBCltDpId      
End      
      
Insert Into DelTransTemp      
Select DelTrans.Sno,DelTrans.Sett_No,DelTrans.Sett_type,DelTrans.RefNo,DelTrans.TCode,DelTrans.TrType,      
DelTrans.Party_Code,DelTrans.scrip_cd,DelTrans.series,DelTrans.Qty,DelTrans.FromNo,DelTrans.ToNo,      
DelTrans.CertNo,DelTrans.FolioNo,DelTrans.HolderName,DelTrans.Reason,DelTrans.DrCr,'D',DelTrans.OrgQty,      
DelTrans.DpType,DelTrans.DpId,DelTrans.CltDpId,DelTrans.BranchCd,DelTrans.PartipantCode,DelTrans.SlipNo,      
DelTrans.BatchNo,DelTrans.ISett_No,DelTrans.ISett_Type,DelTrans.ShareType,DelTrans.TransDate,DelTrans.Filler1,      
DelTrans.Filler2,DelTrans.Filler3,DelTrans.BDpType,DelTrans.BDpId,DelTrans.BCltDpId,DelTrans.Filler4,DelTrans.Filler5      
From DelTrans, DelTransPrintBen D With(Index(DelPrint))        
Where Filler2 = 1      
And DelTrans.Party_Code >= D.FromParty      
And DelTrans.Party_Code <= D.ToParty      
And DelTrans.Party_Code = D.Party_Code      
And DelTrans.Scrip_Cd Like '%'      
And DelTrans.Series Like '%'      
And DelTrans.CertNo = D.CertNo      
And DelTrans.TrType = D.TrType      
And DrCr = 'D'      
And DelTrans.BDpType = D.BDpType      
And DelTrans.BDpId = D.BDpId      
And DelTrans.BCltDpId = D.BCltDpId      
And Delivered = 'G'      
And DelTrans.DpId = D.DpId      
And DelTrans.CltDpId = D.CltDpId      
And DelTrans.FolioNo = D.FolioNo      
And OptionFlag = 4      
And D.Qty <> NewQty      
      
End      
      
If @OptFlag = 5      
Begin      
Update DelTrans Set Delivered = 'G', SlipNo = D.SlipNo,       
BatchNo = D.BatchNo, FolioNo = D.FolioNo,      
TransDate = D.TransDate, HolderName = d.HolderName,                
DpType = @BDpType, DpId = @BDpId, CltDpId = @BCltDpId      
From DelTransPrintBen D With(Index(DelPrint))  
Where Filler2 = 1      
And DelTrans.Party_Code >= D.FromParty      
And DelTrans.Party_Code <= D.ToParty      
And DelTrans.Party_Code = D.Party_Code      
And DelTrans.Scrip_Cd Like '%'      
And DelTrans.Series Like '%'      
And DelTrans.CertNo = D.CertNo      
And DelTrans.TrType = D.TrType      
And DrCr = 'D'      
And DelTrans.BDpType = D.BDpType      
And DelTrans.BDpId = D.BDpId      
And DelTrans.BCltDpId = D.BCltDpId      
And Delivered = '0'         
And OptionFlag = 5      
And D.Qty = NewQty      
      
Insert Into DelTransTemp      
Select DelTrans.Sno,DelTrans.Sett_No,DelTrans.Sett_type,DelTrans.RefNo,DelTrans.TCode,DelTrans.TrType,      
DelTrans.Party_Code,DelTrans.scrip_cd,DelTrans.series,DelTrans.Qty,DelTrans.FromNo,DelTrans.ToNo,      
DelTrans.CertNo,DelTrans.FolioNo,DelTrans.HolderName,DelTrans.Reason,DelTrans.DrCr,'0',DelTrans.OrgQty,      
DelTrans.DpType,DelTrans.DpId,DelTrans.CltDpId,DelTrans.BranchCd,DelTrans.PartipantCode,DelTrans.SlipNo,      
DelTrans.BatchNo,DelTrans.ISett_No,DelTrans.ISett_Type,DelTrans.ShareType,DelTrans.TransDate,DelTrans.Filler1,      
DelTrans.Filler2,DelTrans.Filler3,@BDpType,@BDpId,@BCltDpId,DelTrans.Filler4,DelTrans.Filler5      
From DelTrans , DelTransPrintBen D With(Index(DelPrint))     
Where Filler2 = 1      
And DelTrans.Party_Code >= D.FromParty      
And DelTrans.Party_Code <= D.ToParty      
And DelTrans.Party_Code = D.Party_Code      
And DelTrans.Scrip_Cd Like '%'      
And DelTrans.Series Like '%'      
And DelTrans.CertNo = D.CertNo      
And DelTrans.TrType = D.TrType      
And DrCr = 'D'      
And DelTrans.BDpType = D.BDpType      
And DelTrans.BDpId = D.BDpId      
And DelTrans.BCltDpId = D.BCltDpId      
And Delivered = 'G'          
And DelTrans.FolioNo = D.FolioNo      
And OptionFlag = 5      
And D.Qty = NewQty      
      
Set @BenCur = Cursor For      
Select Party_Code, CertNo, TrType, SlipNo, BatchNo, FolioNo,       
HolderName, Qty , TransDate = Left(Convert(Varchar,TransDate,109),11), BDpId, BCltDpId      
From DelTransPrintBen Where OptionFlag = 5 And Qty <> NewQty       
Order BY Party_Code, CertNo      
Open @BenCur      
Fetch Next From @BenCur into @Party_Code, @CertNo, @TrType, @SlipNo, @BatchNo, @FolioNo,       
@HolderName, @AllQty , @TransDate, @DelBDpId, @DelBCltDpId      
While @@Fetch_Status = 0       
Begin      
 Select @DiffQty = @AllQty      
 Set @DelCur = Cursor For      
 Select Sett_no, Sett_Type, Sno, Qty From DelTrans      
 Where Filler2 = 1       
 And Party_Code = @Party_Code      
 And CertNo = @CertNo      
 And TrType = @TrType      
 And DrCr = 'D'      
 And Delivered = '0'          
 And BDpId = @DelBDpId      
 And BCltDpId = @DelBCltDpId      
 Order By Sett_No, Sett_Type, Qty Desc      
 Open @DelCur      
 Fetch Next From @DelCur into @Sett_No, @Sett_Type, @Sno, @Qty       
 Select @Sett_No, @Sett_Type, @Sno, @Qty      
 While @@Fetch_Status = 0 And @DiffQty > 0       
 Begin      
  If @DiffQty >= @Qty      
  Begin      
   Update DelTrans Set SlipNo = @Slipno, BatchNo = @BatchNo, FolioNo = @Foliono,      
   HolderName = @HolderName, TransDate = @TransDate, Delivered = 'G',
   DPTYPE = @BDpType, DPID = @BDpId, CLTDPID = @BCltDpId      
   Where Sno = @Sno      
   Select @DiffQty = @DiffQty - @Qty      
  End      
  Else      
  Begin      
   Insert Into DelTrans      
   Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,@Qty-@DiffQty,FromNo,ToNo,      
   CertNo,FolioNo,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,      
   PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,      
   Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5 From DelTrans      
   Where Sno = @Sno      
      
   Update DelTrans Set SlipNo = @Slipno, BatchNo = @BatchNo, FolioNo = @Foliono,      
   HolderName = @HolderName, TransDate = @TransDate, Delivered = 'G', Qty = @DiffQty,
   DPTYPE = @BDpType, DPID = @BDpId, CLTDPID = @BCltDpId       
   Where Sno = @Sno      
      
   Select @DiffQty = 0       
  End      
  Fetch Next From @DelCur into @Sett_No, @Sett_Type, @Sno, @Qty      
 End      
 Fetch Next From @BenCur into @Party_Code, @CertNo, @TrType, @SlipNo, @BatchNo, @FolioNo,       
 @HolderName, @AllQty , @TransDate, @DelBDpId, @DelBCltDpId      
End      
      
Insert Into DelTransTemp      
Select DelTrans.Sno,DelTrans.Sett_No,DelTrans.Sett_type,DelTrans.RefNo,DelTrans.TCode,DelTrans.TrType,      
DelTrans.Party_Code,DelTrans.scrip_cd,DelTrans.series,DelTrans.Qty,DelTrans.FromNo,DelTrans.ToNo,      
DelTrans.CertNo,DelTrans.FolioNo,DelTrans.HolderName,DelTrans.Reason,DelTrans.DrCr,'0',DelTrans.OrgQty,      
DelTrans.DpType,DelTrans.DpId,DelTrans.CltDpId,DelTrans.BranchCd,DelTrans.PartipantCode,DelTrans.SlipNo,      
DelTrans.BatchNo,DelTrans.ISett_No,DelTrans.ISett_Type,DelTrans.ShareType,DelTrans.TransDate,DelTrans.Filler1,      
DelTrans.Filler2,DelTrans.Filler3,@BDpType,@BDpId,@BCltDpId,DelTrans.Filler4,DelTrans.Filler5      
From DelTrans, DelTransPrintBen D With(Index(DelPrint))        
Where Filler2 = 1      
And DelTrans.Party_Code >= D.FromParty      
And DelTrans.Party_Code <= D.ToParty      
And DelTrans.Party_Code = D.Party_Code      
And DelTrans.Scrip_Cd Like '%'      
And DelTrans.Series Like '%'      
And DelTrans.CertNo = D.CertNo      
And DelTrans.TrType = D.TrType      
And DrCr = 'D'      
And DelTrans.BDpType = D.BDpType      
And DelTrans.BDpId = D.BDpId      
And DelTrans.BCltDpId = D.BCltDpId      
And Delivered = 'G'       
And DelTrans.FolioNo = D.FolioNo      
And OptionFlag = 5      
And D.Qty <> NewQty      
      
End 

If @OptFlag = 6      
Begin      
Update DelTrans Set Delivered = 'G', SlipNo = D.SlipNo,       
BatchNo = D.BatchNo, FolioNo = D.FolioNo,      
TransDate = D.TransDate, HolderName = d.HolderName,                
DpType = @BDpType, DpId = @BDpId, CltDpId = @BCltDpId      
From DelTransPrintBen D With(Index(DelPrint))  
Where Filler2 = 1      
And DelTrans.Party_Code >= D.FromParty      
And DelTrans.Party_Code <= D.ToParty      
And DelTrans.Party_Code = D.Party_Code      
And DelTrans.Scrip_Cd Like '%'      
And DelTrans.Series Like '%'      
And DelTrans.CertNo = D.CertNo      
And DelTrans.TrType = D.TrType      
And DrCr = 'D'      
And DelTrans.BDpType = D.BDpType      
And DelTrans.BDpId = D.BDpId      
And DelTrans.BCltDpId = D.BCltDpId      
And Delivered = '0'         
And OptionFlag = 6      
And D.Qty = NewQty      
      
Insert Into DelTransTemp      
Select DelTrans.Sno,DelTrans.Sett_No,DelTrans.Sett_type,DelTrans.RefNo,DelTrans.TCode,DelTrans.TrType,      
DelTrans.Party_Code,DelTrans.scrip_cd,DelTrans.series,DelTrans.Qty,DelTrans.FromNo,DelTrans.ToNo,      
DelTrans.CertNo,DelTrans.FolioNo,DelTrans.HolderName,DelTrans.Reason,DelTrans.DrCr,'D',DelTrans.OrgQty,      
DelTrans.DpType,DelTrans.DpId,DelTrans.CltDpId,DelTrans.BranchCd,DelTrans.PartipantCode,DelTrans.SlipNo,      
DelTrans.BatchNo,DelTrans.ISett_No,DelTrans.ISett_Type,DelTrans.ShareType,DelTrans.TransDate,DelTrans.Filler1,      
DelTrans.Filler2,DelTrans.Filler3,DelTrans.BDpType,DelTrans.BDpId,DelTrans.BCltDpId,DelTrans.Filler4,DelTrans.Filler5      
From DelTrans , DelTransPrintBen D With(Index(DelPrint))     
Where Filler2 = 1      
And DelTrans.Party_Code >= D.FromParty      
And DelTrans.Party_Code <= D.ToParty      
And DelTrans.Party_Code = D.Party_Code      
And DelTrans.Scrip_Cd Like '%'      
And DelTrans.Series Like '%'      
And DelTrans.CertNo = D.CertNo      
And DelTrans.TrType = D.TrType      
And DrCr = 'D'      
And DelTrans.BDpType = D.BDpType      
And DelTrans.BDpId = D.BDpId      
And DelTrans.BCltDpId = D.BCltDpId      
And Delivered = 'G'          
And DelTrans.FolioNo = D.FolioNo      
And OptionFlag = 6      
And D.Qty = NewQty      
      
Set @BenCur = Cursor For      
Select Party_Code, CertNo, TrType, SlipNo, BatchNo, FolioNo,       
HolderName, Qty , TransDate = Left(Convert(Varchar,TransDate,109),11), BDpId, BCltDpId      
From DelTransPrintBen Where OptionFlag = 6 And Qty <> NewQty       
Order BY Party_Code, CertNo      
Open @BenCur      
Fetch Next From @BenCur into @Party_Code, @CertNo, @TrType, @SlipNo, @BatchNo, @FolioNo,       
@HolderName, @AllQty , @TransDate, @DelBDpId, @DelBCltDpId      
While @@Fetch_Status = 0       
Begin      
 Select @DiffQty = @AllQty      
 Set @DelCur = Cursor For      
 Select Sett_no, Sett_Type, Sno, Qty From DelTrans      
 Where Filler2 = 1       
 And Party_Code = @Party_Code      
 And CertNo = @CertNo      
 And TrType = @TrType      
 And DrCr = 'D'      
 And Delivered = '0'          
 And BDpId = @DelBDpId      
 And BCltDpId = @DelBCltDpId      
 Order By Sett_No, Sett_Type, Qty Desc      
 Open @DelCur      
 Fetch Next From @DelCur into @Sett_No, @Sett_Type, @Sno, @Qty       
 Select @Sett_No, @Sett_Type, @Sno, @Qty      
 While @@Fetch_Status = 0 And @DiffQty > 0       
 Begin      
  If @DiffQty >= @Qty      
  Begin      
   Update DelTrans Set SlipNo = @Slipno, BatchNo = @BatchNo, FolioNo = @Foliono,      
   HolderName = @HolderName, TransDate = @TransDate, Delivered = 'G',
   DPTYPE = @BDpType, DPID = @BDpId, CLTDPID = @BCltDpId      
   Where Sno = @Sno      
   Select @DiffQty = @DiffQty - @Qty      
  End      
  Else      
  Begin      
   Insert Into DelTrans      
   Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,@Qty-@DiffQty,FromNo,ToNo,      
   CertNo,FolioNo,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,      
   PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,      
   Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5 From DelTrans      
   Where Sno = @Sno      
      
   Update DelTrans Set SlipNo = @Slipno, BatchNo = @BatchNo, FolioNo = @Foliono,      
   HolderName = @HolderName, TransDate = @TransDate, Delivered = 'G', Qty = @DiffQty,
   DPTYPE = @BDpType, DPID = @BDpId, CLTDPID = @BCltDpId       
   Where Sno = @Sno      
      
   Select @DiffQty = 0       
  End      
  Fetch Next From @DelCur into @Sett_No, @Sett_Type, @Sno, @Qty      
 End      
 Fetch Next From @BenCur into @Party_Code, @CertNo, @TrType, @SlipNo, @BatchNo, @FolioNo,       
 @HolderName, @AllQty , @TransDate, @DelBDpId, @DelBCltDpId      
End      
      
Insert Into DelTransTemp      
Select DelTrans.Sno,DelTrans.Sett_No,DelTrans.Sett_type,DelTrans.RefNo,DelTrans.TCode,DelTrans.TrType,      
DelTrans.Party_Code,DelTrans.scrip_cd,DelTrans.series,DelTrans.Qty,DelTrans.FromNo,DelTrans.ToNo,      
DelTrans.CertNo,DelTrans.FolioNo,DelTrans.HolderName,DelTrans.Reason,DelTrans.DrCr,'D',DelTrans.OrgQty,      
DelTrans.DpType,DelTrans.DpId,DelTrans.CltDpId,DelTrans.BranchCd,DelTrans.PartipantCode,DelTrans.SlipNo,      
DelTrans.BatchNo,DelTrans.ISett_No,DelTrans.ISett_Type,DelTrans.ShareType,DelTrans.TransDate,DelTrans.Filler1,      
DelTrans.Filler2,DelTrans.Filler3,DelTrans.BDpType,DelTrans.BDpId,DelTrans.BCltDpId,DelTrans.Filler4,DelTrans.Filler5      
From DelTrans, DelTransPrintBen D With(Index(DelPrint))        
Where Filler2 = 1      
And DelTrans.Party_Code >= D.FromParty      
And DelTrans.Party_Code <= D.ToParty      
And DelTrans.Party_Code = D.Party_Code      
And DelTrans.Scrip_Cd Like '%'      
And DelTrans.Series Like '%'      
And DelTrans.CertNo = D.CertNo      
And DelTrans.TrType = D.TrType      
And DrCr = 'D'      
And DelTrans.BDpType = D.BDpType      
And DelTrans.BDpId = D.BDpId      
And DelTrans.BCltDpId = D.BCltDpId      
And Delivered = 'G'       
And DelTrans.FolioNo = D.FolioNo      
And OptionFlag = 6      
And D.Qty <> NewQty      
      
End

GO
