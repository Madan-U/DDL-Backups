-- Object: PROCEDURE dbo.Ins_DelPledgeMark
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC Ins_DelPledgeMark As  
Declare   
@Sett_No Varchar(7),  
@Sett_Type Varchar(2),  
@Party_Code Varchar(10),  
@Scrip_Cd Varchar(10),   
@Series Varchar(3),   
@IsIn Varchar(12),   
@BDpId Varchar(8),   
@BCltDpId Varchar(16),  
@PldQty Int,  
@PldCur Cursor,  
@DelPldCur Cursor,  
@SNo Numeric(18,0),  
  
@HoldQty Int  
  
Set @PldCur = CurSor For  
Select Party_Code,Scrip_Cd,Series,IsIn,BDpId,BCltDpId,PledgeQty From DelPledgeMark  
Where PledgeQty > 0   
Order By Party_Code,Scrip_Cd,Series
Open @PldCur   
Fetch Next From @PldCur Into @Party_Code,@Scrip_Cd,@Series,@IsIn,@BDpId,@BCltDpId,@PldQty  
While @@FETCH_STATUS = 0   
Begin  
 Set @DelPldCur = Cursor For  
 Select Sno, Qty From DelTrans  
 Where Party_Code = @Party_Code And Scrip_Cd = @Scrip_Cd  
 And Series = @Series And CertNo = @IsIn   
 And DrCr = 'D' And Filler2 = 1   
 And TrType = 904 And Delivered = '0'  
 And BDpId = @BDpId And BCltDpId = @BCltDpId  
 Order By Sett_No, Sett_Type, Qty Desc  
 Open @DelPldCur  
 Fetch Next From @DelPldCur Into @Sno, @HoldQty  
 While @@Fetch_Status = 0 And @PldQty > 0  
 Begin  
  if @PldQty >= @HoldQty  
  Begin  
   Update DelTrans Set TrType = 909, Reason = 'PLEDGE MARKING'  
   Where Sno = @Sno  
   Set @PldQty = @PldQty - @HoldQty  
  End  
  Else  
  Begin  
   Insert Into DelTrans  
   Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,  
   Qty = @HoldQty - @PldQty,FromNo,ToNo,CertNo,FolioNo,HolderName,Reason,DrCr,Delivered,  
   OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,  
   ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5  
   From DelTrans Where Sno = @Sno  
  
   Update DelTrans Set TrType = 909, Reason = 'PLEDGE MARKING', Qty = @PldQty  
   Where Sno = @Sno  
   Set @PldQty = 0  
  End  
  Fetch Next From @DelPldCur Into @Sno, @HoldQty      
 End  
 Close @DelPldCur  
 DeAllocate @DelPldCur  
 Fetch Next From @PldCur Into @Party_Code,@Scrip_Cd,@Series,@IsIn,@BDpId,@BCltDpId,@PldQty  
End  
Close @PldCur  
DeAllocate @PldCur  

TRUNCATE TABLE DelPledgeMark

GO
