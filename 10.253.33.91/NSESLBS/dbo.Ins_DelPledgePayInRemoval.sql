-- Object: PROCEDURE dbo.Ins_DelPledgePayInRemoval
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC Ins_DelPledgePayInRemoval As  
Declare   
@Party_Code Varchar(10),  
@IsIn Varchar(12),   
@ShortQty Int,  
@NSEPldQty Int,  
@BSEPldQty Int,  
@PldCur Cursor,  
@DelPldCur Cursor,  
@SNo Numeric(18,0),  
@Sett_No Varchar(7),  
@Sett_Type Varchar(2),  
@HoldQty Int,  
@RefNo Int  
  
Select @RefNo = RefNo From DelSegment  
  
Set @PldCur = CurSor For  
Select Party_Code,IsIn,ShortQty,NSEPldQty,BSEPldQty From DelPledgePayIn  
Where ShortQty > 0 And (NSEPldQty > 0 Or BSEPldQty > 0)  
Order By Party_Code, IsIn  
Open @PldCur   
Fetch Next From @PldCur Into @Party_Code,@IsIn,@ShortQty,@NSEPldQty,@BSEPldQty  
While @@FETCH_STATUS = 0   
Begin  
 if @RefNo = 110   
 Begin  
  Set @NSEPldQty = (Case When @NSEPldQty >= @ShortQty   
           Then @ShortQty  
           Else @NSEPldQty  
         End)  
  Set @ShortQty = @ShortQty - @NSEPldQty  
  Set @BSEPldQty = (Case When @ShortQty > 0   
           Then (Case When @BSEPldQty >= @ShortQty   
                      Then @ShortQty  
               Else @BSEPldQty  
          End)  
           Else 0   
         End)  
  Set @ShortQty = @ShortQty - @BSEPldQty  
 End  
  
 if @RefNo = 120   
 Begin  
  Set @BSEPldQty = (Case When @BSEPldQty >= @ShortQty   
           Then @ShortQty  
           Else @BSEPldQty  
         End)  
  Set @ShortQty = @ShortQty - @BSEPldQty  
  
  Set @NSEPldQty = (Case When @ShortQty > 0   
           Then (Case When @NSEPldQty >= @ShortQty   
                      Then @ShortQty  
               Else @NSEPldQty  
          End)  
           Else 0   
         End)  
  Set @ShortQty = @ShortQty - @NSEPldQty  
 End  
  
 If @NSEPldQty > 0   
 Begin  
  Set @DelPldCur = Cursor For  
  Select D.Sno, Sett_No, Sett_Type, Qty From MSAJAG.DBO.DelTrans D, MSAJAG.DBO.DeliveryDp DP  
  Where BDpId = DP.DpId And BCltDpId = DP.DpCltNo  
  And Party_Code = @Party_Code  
  And DrCr = 'D' And Filler2 = 1   
  And TrType = 909 And Delivered = '0'  
  And CertNo = @IsIn And Description Not Like '%POOL%'  
  Order By Sett_No, Sett_Type, Qty Desc  
  Open @DelPldCur  
  Fetch Next From @DelPldCur Into @Sno, @Sett_No, @Sett_Type, @HoldQty  
  While @@Fetch_Status = 0 And @NSEPldQty > 0   
  Begin  
   if @NSEPldQty >= @HoldQty  
   Begin  
    Update MSAJAG.DBO.DelTrans Set TrType = 904, Reason = 'DEMAT'  
    Where Sno = @Sno  
    Set @NSEPldQty = @NSEPldQty - @HoldQty  
   End  
   Else  
   Begin  
    Insert Into MSAJAG.DBO.DelTrans  
    Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,  
    Qty = @HoldQty - @NSEPldQty,FromNo,ToNo,CertNo,FolioNo,HolderName,Reason,DrCr,Delivered,  
    OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,  
    ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5  
    From MSAJAG.DBO.DelTrans Where Sno = @Sno  
   
    Update MSAJAG.DBO.DelTrans Set TrType = 904, Reason = 'DEMAT', Qty = @NSEPldQty  
    Where Sno = @Sno  
   
    Set @NSEPldQty = 0  
   End  
   Fetch Next From @DelPldCur Into @Sno, @Sett_No, @Sett_Type, @HoldQty      
  End  
  Close @DelPldCur  
  DeAllocate @DelPldCur  
 End  
 If @BSEPldQty > 0   
 Begin  
  Set @DelPldCur = Cursor For  
  Select D.Sno, Sett_No, Sett_Type, Qty From BSEDB.DBO.DelTrans D, BSEDB.DBO.DeliveryDp DP  
  Where BDpId = DP.DpId And BCltDpId = DP.DpCltNo  
  And Party_Code = @Party_Code  
  And DrCr = 'D' And Filler2 = 1   
  And TrType = 909 And Delivered = '0'  
  And CertNo = @IsIn And Description Not Like '%POOL%'  
  Order By Sett_No, Sett_Type, Qty Desc  
  Open @DelPldCur  
  Fetch Next From @DelPldCur Into @Sno, @Sett_No, @Sett_Type, @HoldQty  
  While @@Fetch_Status = 0 And @BSEPldQty > 0   
  Begin  
   if @BSEPldQty >= @HoldQty  
   Begin  
    Update BSEDB.DBO.DelTrans Set TrType = 904, Reason = 'DEMAT'  
    Where Sno = @Sno  
    Set @BSEPldQty = @BSEPldQty - @HoldQty  
   End  
   Else  
   Begin  
    Insert Into BSEDB.DBO.DelTrans  
    Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,  
    Qty = @HoldQty - @BSEPldQty,FromNo,ToNo,CertNo,FolioNo,HolderName,Reason,DrCr,Delivered,  
    OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,  
    ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5  
    From BSEDB.DBO.DelTrans Where Sno = @Sno  
   
    Update BSEDB.DBO.DelTrans Set TrType = 904, Reason = 'DEMAT', Qty = @BSEPldQty  
    Where Sno = @Sno  
   
    Set @BSEPldQty = 0  
   End  
   Fetch Next From @DelPldCur Into @Sno, @Sett_No, @Sett_Type, @HoldQty      
  End  
  Close @DelPldCur  
  DeAllocate @DelPldCur  
 End  
 Fetch Next From @PldCur Into @Party_Code,@IsIn,@ShortQty,@NSEPldQty,@BSEPldQty  
End  
Close @PldCur  
DeAllocate @PldCur  

TRUNCATE TABLE DelPledgePayIn

GO
