-- Object: PROCEDURE dbo.V2_DelBranchMark_Payout
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Proc V2_DelBranchMark_Payout   
(    
 @BenType Varchar(4)    
) as  
Declare   
@SrNo Numeric(18,0),  
@Exchg Varchar(3),  
@Party_Code Varchar(10),  
@Scrip_CD Varchar(12),  
@Series Varchar(12),  
@CertNo Varchar(12),  
@DpId Varchar(8),    
@CltDpId Varchar(16),
@BDpType Varchar(4),
@AprQty Int,  
@DelCur Cursor,  
@DelPayCur Cursor,  
@Sno Numeric(18,0),  
@Qty Int,  
@PayQty Int  
  
Create Table #Del  
( Exchg      Varchar(3),  
  Party_Code Varchar(10),  
  Scrip_cd   Varchar(12),  
  Series     Varchar(3),  
  CertNo     Varchar(12),  
  Qty        int,  
  DpId       Varchar(8),    
  CltDpId    Varchar(16),
  BDpType    Varchar(4))  
  
Select SrNo,Exchg,Party_Code,Scrip_CD,Series,CertNo,  
AprQty = AprQty-PayQty,HoldQty=Convert(Numeric(18,4),0), DpId, CltDpId, BDpType  
Into #DelBranchMark_New From DelBranchMark_New  
Where ProcessStatus = 'APR' And ReqStatus = 'APR'  
And AprQty > 0 And HoldType = @BenType  
And AprQty > PayQty  
If @@rowcount > 0   
Begin   
 if @BenType = 'BEN'  
 Begin  
  Insert Into #Del   
  Select Exchg=(Case When RefNo = 110 Then 'NSE' Else 'BSE' End),      
  D.Party_Code, D.Scrip_CD, D.Series, D.CertNo, Qty=Sum(D.Qty), D.DpId, D.CltDpId,BDpType=''
  From DelTrans D With(Index(DelHold), NoLock), DeliveryDp DP, #DelBranchMark_New M  
  Where 
  D.Party_Code = M.Party_Code   
  And D.Scrip_Cd = M.Scrip_Cd  
  And D.Series = M.Series  
  And D.CertNo = M.CertNo
  And D.DpId = M.DpID 
  And D.CltDpId = M.CltDpId
  And Filler2 = 1 And DrCr = 'D'    
  And Delivered = '0'     
  And ShareType = 'DEMAT'    
  And D.BDpType = DP.DpType    
  And BDpID = Dp.DpId    
  And BCltDpId = DpCltNo    
  And Description Not Like '%POOL%'  
  And Description Not Like '%PLEDGE%'
  AND ACCOUNTTYPE <> 'MAR'  
  And TrType = 904   
  And D.DpId <> ''    
  And D.Party_Code <> 'BROKER'    
  Group By D.Party_Code, D.Scrip_CD, D.Series, D.CertNo, RefNo, D.DpId, D.CltDpId  
    
  Insert Into #Del  
  Select Exchg=(Case When RefNo = 110 Then 'NSE' Else 'BSE' End),      
  D.Party_Code, D.Scrip_CD, D.Series, D.CertNo, Qty=Sum(D.Qty), D.DpId, D.CltDpId,BDpType=''
  From BSEDB.DBO.DelTrans D  With(Index(DelHold), NoLock), BSEDB.DBO.DeliveryDp DP, #DelBranchMark_New M  
  Where D.Party_Code <> 'BROKER'    
  And D.Party_Code = M.Party_Code   
  And D.Scrip_Cd = M.Scrip_Cd  
  And D.CertNo = M.CertNo
  And D.DpId = M.DpID 
  And D.CltDpId = M.CltDpId
  And Filler2 = 1 And DrCr = 'D'    
  And Delivered = '0'     
  And ShareType = 'DEMAT'    
  And D.BDpType = DP.DpType    
  And BDpID = Dp.DpId    
  And BCltDpId = DpCltNo    
  And Description Not Like '%POOL%'    
  And Description Not Like '%PLEDGE%'  
  AND ACCOUNTTYPE <> 'MAR'
  And TrType = 904   
  And D.DpId <> ''
  Group By D.Party_Code, D.Scrip_CD, D.Series, D.CertNo, RefNo, D.DpId, D.CltDpId  
 End  

 if @BenType = 'MAR'  
 Begin  
  Insert Into #Del   
  Select Exchg=(Case When RefNo = 110 Then 'NSE' Else 'BSE' End),      
  D.Party_Code, D.Scrip_CD, D.Series, D.CertNo, Qty=Sum(D.Qty), D.DpId, D.CltDpId,BDpType=''
  From DelTrans D With(Index(DelHold), NoLock), DeliveryDp DP, #DelBranchMark_New M  
  Where 
  D.Party_Code = M.Party_Code   
  And D.Scrip_Cd = M.Scrip_Cd  
  And D.Series = M.Series  
  And D.CertNo = M.CertNo
  And D.DpId = M.DpID 
  And D.CltDpId = M.CltDpId
  And Filler2 = 1 And DrCr = 'D'    
  And Delivered = '0'     
  And ShareType = 'DEMAT'    
  And D.BDpType = DP.DpType    
  And BDpID = Dp.DpId    
  And BCltDpId = DpCltNo    
  And Description Not Like '%POOL%'  
  And Description Not Like '%PLEDGE%'
  AND ACCOUNTTYPE = 'MAR'  
  And TrType = 904   
  And D.DpId <> ''    
  And D.Party_Code <> 'BROKER'    
  Group By D.Party_Code, D.Scrip_CD, D.Series, D.CertNo, RefNo, D.DpId, D.CltDpId  
    
  Insert Into #Del  
  Select Exchg=(Case When RefNo = 110 Then 'NSE' Else 'BSE' End),      
  D.Party_Code, D.Scrip_CD, D.Series, D.CertNo, Qty=Sum(D.Qty), D.DpId, D.CltDpId,BDpType=''
  From BSEDB.DBO.DelTrans D  With(Index(DelHold), NoLock), BSEDB.DBO.DeliveryDp DP, #DelBranchMark_New M  
  Where D.Party_Code <> 'BROKER'    
  And D.Party_Code = M.Party_Code   
  And D.Scrip_Cd = M.Scrip_Cd  
  And D.CertNo = M.CertNo
  And D.DpId = M.DpID 
  And D.CltDpId = M.CltDpId
  And Filler2 = 1 And DrCr = 'D'    
  And Delivered = '0'     
  And ShareType = 'DEMAT'    
  And D.BDpType = DP.DpType    
  And BDpID = Dp.DpId    
  And BCltDpId = DpCltNo    
  And Description Not Like '%POOL%'    
  And Description Not Like '%PLEDGE%'  
  AND ACCOUNTTYPE = 'MAR'
  And TrType = 904   
  And D.DpId <> ''
  Group By D.Party_Code, D.Scrip_CD, D.Series, D.CertNo, RefNo, D.DpId, D.CltDpId  
 End

 if @BenType = 'POOL'  
 Begin  
  Insert Into #Del   
  Select Exchg=(Case When RefNo = 110 Then 'NSE' Else 'BSE' End),      
  D.Party_Code, D.Scrip_CD, D.Series, D.CertNo, Qty=Sum(D.Qty), D.DpId, D.CltDpId,D.BDpType
  From DelTrans D With(Index(DelHold), NoLock),  DeliveryDp DP, #DelBranchMark_New M   
  Where 
  D.Party_Code = M.Party_Code   
  And D.Scrip_Cd = M.Scrip_Cd  
  And D.Series = M.Series  
  And D.CertNo = M.CertNo
  And D.DpId = M.DpID 
  And D.CltDpId = M.CltDpId 
  And Filler2 = 1 And DrCr = 'D'    
  And Delivered = '0'     
  And ShareType = 'DEMAT'    
  And D.BDpType = DP.DpType    
  And BDpID = Dp.DpId    
  And BCltDpId = DpCltNo    
  And Description Like '%POOL%'  
  And TrType = 904   
  And D.DpId <> ''    
  And D.Party_Code <> 'BROKER'
  And D.BDpType = M.BDpType	
  Group By D.Party_Code, D.Scrip_CD, D.Series, D.CertNo, D.RefNo, D.DpId, D.CltDpId,D.BDpType
    
  Insert Into #Del  
  Select Exchg=(Case When RefNo = 110 Then 'NSE' Else 'BSE' End),      
  D.Party_Code, D.Scrip_CD, D.Series, D.CertNo, Qty=Sum(D.Qty), D.DpId, D.CltDpId,D.BDpType
  From BSEDB.DBO.DelTrans D With(Index(DelHold), NoLock), BSEDB.DBO.DeliveryDp DP, #DelBranchMark_New M   
  Where 
  D.Party_Code = M.Party_Code   
  And D.Scrip_Cd = M.Scrip_Cd  
  And D.CertNo = M.CertNo
  And D.DpId = M.DpID 
  And D.CltDpId = M.CltDpId 
  And Filler2 = 1 And DrCr = 'D'    
  And Delivered = '0'     
  And ShareType = 'DEMAT'    
  And D.BDpType = DP.DpType    
  And BDpID = Dp.DpId    
  And BCltDpId = DpCltNo    
  And Description Like '%POOL%'    
  And TrType = 904   
  And D.DpId <> ''    
  And D.Party_Code <> 'BROKER'      
  And D.BDpType = M.BDpType
  Group By D.Party_Code, D.Scrip_CD, D.Series, D.CertNo, RefNo, D.DpId, D.CltDpId,D.BDpType
 End   
 Update #DelBranchMark_New Set HoldQty = Qty  
 From #Del D  
 Where #DelBranchMark_New.Exchg = D.Exchg    
 And #DelBranchMark_New.Party_Code = D.Party_Code    
 And #DelBranchMark_New.Scrip_Cd = D.Scrip_cd    
 And D.Series = (Case When #DelBranchMark_New.Exchg = 'NSE' Then #DelBranchMark_New.Series Else 'BSE' End)  
 And #DelBranchMark_New.CertNo = D.CertNo  
 And #DelBranchMark_New.Exchg = D.Exchg  
 And #DelBranchMark_New.DpId = D.DpId  
 And #DelBranchMark_New.CltDpId = D.CltDpId  
 And #DelBranchMark_New.BDpType = D.BDpType 

 Update DelBranchMark_New Set PayQty = PayQty + D.HoldQty  
 From #DelBranchMark_New D  
 Where DelBranchMark_New.Exchg = D.Exchg    
 And DelBranchMark_New.Party_Code = D.Party_Code    
 And DelBranchMark_New.Scrip_Cd = D.Scrip_cd    
 And DelBranchMark_New.CertNo = D.CertNo  
 And DelBranchMark_New.Exchg = D.Exchg  
 And ProcessStatus = 'APR' And ReqStatus = 'APR'  
 And DelBranchMark_New.AprQty > 0 And HoldType = @BenType  
 And D.AprQty = D.HoldQty  
 And DelBranchMark_New.DpId = D.DpId  
 And DelBranchMark_New.CltDpId = D.CltDpId  
 And DelBranchMark_New.BDpType = D.BDpType 
   
 if @BenType = 'BEN'  
 Begin  
  Update DelTrans Set TrType = 905  
  From #DelBranchMark_New D, DeliveryDp DP  
  Where Filler2 = 1 And DrCr = 'D'    
  And Delivered = '0'     
  And ShareType = 'DEMAT'    
  And DelTrans.BDpType = DP.DpType    
  And BDpID = Dp.DpId    
  And BCltDpId = DpCltNo    
  And Description Not Like '%POOL%'    
  And Description Not Like '%PLEDGE%'  
  AND ACCOUNTTYPE <> 'MAR'
  And TrType = 904   
  And DelTrans.DpId <> ''    
  And DelTrans.Party_Code = D.Party_Code  
  And DelTrans.Scrip_Cd = D.Scrip_cd    
  And DelTrans.Series = D.Series    
  And DelTrans.CertNo = D.CertNo  
  And AprQty = HoldQty  
  And DelTrans.DpId = D.DpId  
  And DelTrans.CltDpId = D.CltDpId  
    
  Update BSEDB.DBO.DelTrans Set TrType = 905  
  From #DelBranchMark_New D, BSEDB.DBO.DeliveryDp DP  
  Where Filler2 = 1 And DrCr = 'D'    
  And Delivered = '0'     
  And ShareType = 'DEMAT'    
  And BSEDB.DBO.DelTrans.BDpType = DP.DpType    
  And BDpID = Dp.DpId    
  And BCltDpId = DpCltNo    
  And Description Not Like '%POOL%'    
  And Description Not Like '%PLEDGE%'  
  AND ACCOUNTTYPE <> 'MAR'
  And TrType = 904   
  And BSEDB.DBO.DelTrans.DpId <> ''    
  And BSEDB.DBO.DelTrans.Party_Code = D.Party_Code  
  And BSEDB.DBO.DelTrans.Scrip_Cd = D.Scrip_cd    
  And BSEDB.DBO.DelTrans.CertNo = D.CertNo  
  And AprQty = HoldQty  
  And BSEDB.DBO.DelTrans.DpId = D.DpId  
  And BSEDB.DBO.DelTrans.CltDpId = D.CltDpId  
 End  

 if @BenType = 'MAR'  
 Begin  
  Update DelTrans Set TrType = 905  
  From #DelBranchMark_New D, DeliveryDp DP  
  Where Filler2 = 1 And DrCr = 'D'    
  And Delivered = '0'     
  And ShareType = 'DEMAT'    
  And DelTrans.BDpType = DP.DpType    
  And BDpID = Dp.DpId    
  And BCltDpId = DpCltNo    
  And Description Not Like '%POOL%'    
  And Description Not Like '%PLEDGE%'  
  AND ACCOUNTTYPE = 'MAR'
  And TrType = 904   
  And DelTrans.DpId <> ''    
  And DelTrans.Party_Code = D.Party_Code  
  And DelTrans.Scrip_Cd = D.Scrip_cd    
  And DelTrans.Series = D.Series    
  And DelTrans.CertNo = D.CertNo  
  And AprQty = HoldQty  
  And DelTrans.DpId = D.DpId  
  And DelTrans.CltDpId = D.CltDpId  
    
  Update BSEDB.DBO.DelTrans Set TrType = 905  
  From #DelBranchMark_New D, BSEDB.DBO.DeliveryDp DP  
  Where Filler2 = 1 And DrCr = 'D'    
  And Delivered = '0'     
  And ShareType = 'DEMAT'    
  And BSEDB.DBO.DelTrans.BDpType = DP.DpType    
  And BDpID = Dp.DpId    
  And BCltDpId = DpCltNo    
  And Description Not Like '%POOL%'    
  And Description Not Like '%PLEDGE%'  
  AND ACCOUNTTYPE = 'MAR'
  And TrType = 904   
  And BSEDB.DBO.DelTrans.DpId <> ''    
  And BSEDB.DBO.DelTrans.Party_Code = D.Party_Code  
  And BSEDB.DBO.DelTrans.Scrip_Cd = D.Scrip_cd    
  And BSEDB.DBO.DelTrans.CertNo = D.CertNo  
  And AprQty = HoldQty  
  And BSEDB.DBO.DelTrans.DpId = D.DpId  
  And BSEDB.DBO.DelTrans.CltDpId = D.CltDpId  
 End  

 if @BenType = 'POOL'    
 Begin  
  Update DelTrans Set TrType = 905  
  From #DelBranchMark_New D, DeliveryDp DP  
  Where Filler2 = 1 And DrCr = 'D'    
  And Delivered = '0'     
  And ShareType = 'DEMAT'    
  And DelTrans.BDpType = DP.DpType    
  And BDpID = Dp.DpId    
  And BCltDpId = DpCltNo    
  And Description Like '%POOL%'    
  And TrType = 904   
  And DelTrans.DpId <> ''    
  And DelTrans.Party_Code = D.Party_Code  
  And DelTrans.Scrip_Cd = D.Scrip_cd    
  And DelTrans.Series = D.Series    
  And DelTrans.CertNo = D.CertNo  
  And AprQty = HoldQty  
  And DelTrans.DpId = D.DpId  
  And DelTrans.CltDpId = D.CltDpId  
  And DelTrans.BDpType = D.BDpType 
    
  Update BSEDB.DBO.DelTrans Set TrType = 905  
  From #DelBranchMark_New D, BSEDB.DBO.DeliveryDp DP  
  Where Filler2 = 1 And DrCr = 'D'    
  And Delivered = '0'     
  And ShareType = 'DEMAT'    
  And BSEDB.DBO.DelTrans.BDpType = DP.DpType    
  And BDpID = Dp.DpId    
  And BCltDpId = DpCltNo    
  And Description Like '%POOL%'    
  And TrType = 904   
  And BSEDB.DBO.DelTrans.DpId <> ''    
  And BSEDB.DBO.DelTrans.Party_Code = D.Party_Code  
  And BSEDB.DBO.DelTrans.Scrip_Cd = D.Scrip_cd    
  And BSEDB.DBO.DelTrans.CertNo = D.CertNo  
  And AprQty = HoldQty  
  And BSEDB.DBO.DelTrans.DpId = D.DpId  
  And BSEDB.DBO.DelTrans.CltDpId = D.CltDpId  
  And BSEDB.DBO.DelTrans.BDpType = D.BDpType 
 End   

 Set @DelCur = Cursor For  
 Select SrNo,Exchg,Party_Code,Scrip_CD,Series,CertNo,AprQty, DpId, CltDpId, BDpType From #DelBranchMark_New  
 Where AprQty <> HoldQty  
 Open @DelCur  
 Fetch Next From @DelCur into @SrNo, @Exchg, @Party_Code, @Scrip_CD, @Series, @CertNo, @AprQty, @DpId, @CltDpId, @BDpType  
 While @@Fetch_Status = 0   
 Begin  
  Set @PayQty = 0  
  if @Exchg = 'NSE'   
   if @BenType = 'BEN'  
   Begin   
    Set @DelPayCur = Cursor For   
    Select D.Sno, Qty From DelTrans D, DeliveryDp DP, Sett_Mst S  
    Where S.Sett_No = D.Sett_No And S.Sett_Type = D.Sett_Type  
    And BDpType = DP.DpType And BDpID = Dp.DpId And BCltDpId = DpCltNo  
    And Description Not Like '%POOL%' And Description Not Like '%PLEDGE%' 
  AND ACCOUNTTYPE <> 'MAR' 
    And DrCr = 'D' And Filler2 = 1 And TrType = 904  
    And D.DpId <> '' And Party_Code = @Party_Code  
    And Scrip_Cd = @Scrip_Cd And D.Series = @Series  
    And CertNo = @CertNo   
    And D.DpId = @DpId  
    And D.CltDpId = @CltDpId  
    Order By Sec_Payin, Qty  
   End  
   if @BenType = 'MAR'  
   Begin   
    Set @DelPayCur = Cursor For   
    Select D.Sno, Qty From DelTrans D, DeliveryDp DP, Sett_Mst S  
    Where S.Sett_No = D.Sett_No And S.Sett_Type = D.Sett_Type  
    And BDpType = DP.DpType And BDpID = Dp.DpId And BCltDpId = DpCltNo  
    And Description Not Like '%POOL%' And Description Not Like '%PLEDGE%' 
  AND ACCOUNTTYPE = 'MAR' 
    And DrCr = 'D' And Filler2 = 1 And TrType = 904  
    And D.DpId <> '' And Party_Code = @Party_Code  
    And Scrip_Cd = @Scrip_Cd And D.Series = @Series  
    And CertNo = @CertNo   
    And D.DpId = @DpId  
    And D.CltDpId = @CltDpId  
    Order By Sec_Payin, Qty  
   End  
   if @BenType = 'POOL'    
   Begin  
    Set @DelPayCur = Cursor For   
    Select D.Sno, Qty From DelTrans D, DeliveryDp DP, Sett_Mst S  
    Where S.Sett_No = D.Sett_No And S.Sett_Type = D.Sett_Type  
    And BDpType = DP.DpType And BDpID = Dp.DpId And BCltDpId = DpCltNo  
    And Description Like '%POOL%'  
    And DrCr = 'D' And Filler2 = 1 And TrType = 904  
    And D.DpId <> '' And Party_Code = @Party_Code  
    And Scrip_Cd = @Scrip_Cd And D.Series = @Series  
    And CertNo = @CertNo   
    And D.DpId = @DpId  
    And D.CltDpId = @CltDpId
    And D.BDpType = @BDpType   
    Order By Sec_Payin, Qty  
   End  
  Else  
   if @BenType = 'BEN'  
   Begin   
    Set @DelPayCur = Cursor For   
    Select D.Sno, Qty From BSEDB.DBO.DelTrans D, BSEDB.DBO.DeliveryDp DP, BSEDB.DBO.Sett_Mst S  
    Where S.Sett_No = D.Sett_No And S.Sett_Type = D.Sett_Type  
    And BDpType = DP.DpType And BDpID = Dp.DpId And BCltDpId = DpCltNo  
    And Description Not Like '%POOL%' And Description Not Like '%PLEDGE%'  
  AND ACCOUNTTYPE <> 'MAR'
    And DrCr = 'D' And Filler2 = 1 And TrType = 904  
    And D.DpId <> '' And Party_Code = @Party_Code  
    And Scrip_Cd = @Scrip_Cd   
    And CertNo = @CertNo   
    And D.DpId = @DpId  
    And D.CltDpId = @CltDpId  
    Order By Sec_Payin, Qty  
   End  
   if @BenType = 'MAR'  
   Begin   
    Set @DelPayCur = Cursor For   
    Select D.Sno, Qty From BSEDB.DBO.DelTrans D, BSEDB.DBO.DeliveryDp DP, BSEDB.DBO.Sett_Mst S  
    Where S.Sett_No = D.Sett_No And S.Sett_Type = D.Sett_Type  
    And BDpType = DP.DpType And BDpID = Dp.DpId And BCltDpId = DpCltNo  
    And Description Not Like '%POOL%' And Description Not Like '%PLEDGE%'  
  AND ACCOUNTTYPE = 'MAR'
    And DrCr = 'D' And Filler2 = 1 And TrType = 904  
    And D.DpId <> '' And Party_Code = @Party_Code  
    And Scrip_Cd = @Scrip_Cd   
    And CertNo = @CertNo   
    And D.DpId = @DpId  
    And D.CltDpId = @CltDpId  
    Order By Sec_Payin, Qty  
   End  
   if @BenType = 'POOL'     
   Begin   
    Set @DelPayCur = Cursor For   
    Select D.Sno, Qty From BSEDB.DBO.DelTrans D, BSEDB.DBO.DeliveryDp DP, BSEDB.DBO.Sett_Mst S  
    Where S.Sett_No = D.Sett_No And S.Sett_Type = D.Sett_Type  
    And BDpType = DP.DpType And BDpID = Dp.DpId And BCltDpId = DpCltNo  
    And Description Like '%POOL%'  
    And DrCr = 'D' And Filler2 = 1 And TrType = 904  
    And D.DpId <> '' And Party_Code = @Party_Code  
    And Scrip_Cd = @Scrip_Cd   
    And CertNo = @CertNo   
    And D.DpId = @DpId  
    And D.CltDpId = @CltDpId
    And D.BDpType = @BDpType     
    Order By Sec_Payin, Qty  
   End  
   Open @DelPayCur  
  Fetch Next From @DelPayCur Into @SNo, @Qty  
  While @@Fetch_Status = 0 And @AprQty > 0  
  Begin  
   if @AprQty >= @Qty   
   Begin  
    if @Exchg = 'NSE'   
     Update DelTrans Set TrType = 905   
     Where Sno = @Sno  
    Else  
     Update BSEDB.DBO.DelTrans Set TrType = 905   
     Where Sno = @Sno  
   
    Set @PayQty = @PayQty + @Qty  
    Set @AprQty = @AprQty - @Qty  
   End  
   Else  
   Begin  
    if @Exchg = 'NSE'   
    Begin  
     Insert Into DelTrans  
     Select Sett_No,Sett_Type,Refno,Tcode,Trtype,Party_Code,Scrip_Cd,Series,Qty-@AprQty,Fromno,Tono,Certno,  
     Foliono,Holdername,Reason,Drcr,Delivered,Orgqty,Dptype,Dpid,Cltdpid,Branchcd,Partipantcode,Slipno,Batchno,  
     Isett_No,Isett_Type,Sharetype,Transdate,Filler1,Filler2,Filler3,Bdptype,Bdpid,Bcltdpid,Filler4,Filler5   
     From DelTrans Where Sno = @Sno  
    
     Update DelTrans Set TrType = 905, Qty = @AprQty  
     Where Sno = @Sno  
    End  
    Else  
    Begin  
     Insert Into BSEDB.DBO.DelTrans  
     Select Sett_No,Sett_Type,Refno,Tcode,Trtype,Party_Code,Scrip_Cd,Series,Qty-@AprQty,Fromno,Tono,Certno,  
     Foliono,Holdername,Reason,Drcr,Delivered,Orgqty,Dptype,Dpid,Cltdpid,Branchcd,Partipantcode,Slipno,Batchno,  
     Isett_No,Isett_Type,Sharetype,Transdate,Filler1,Filler2,Filler3,Bdptype,Bdpid,Bcltdpid,Filler4,Filler5   
     From BSEDB.DBO.DelTrans Where Sno = @Sno  
    
     Update BSEDB.DBO.DelTrans Set TrType = 905, Qty = @AprQty  
     Where Sno = @Sno     
    End   
    Set @PayQty = @PayQty + @AprQty  
    Set @AprQty = 0  
   End  
   Fetch Next From @DelPayCur Into @SNo, @Qty  
  End  
  Close @DelPayCur  
  DeAllocate @DelPayCur  
    
  Update DelBranchMark_New Set PayQty = PayQty + @PayQty Where SrNo = @SrNo  
  
 Fetch Next From @DelCur into @SrNo, @Exchg, @Party_Code, @Scrip_CD, @Series, @CertNo, @AprQty, @DpId, @CltDpId, @BDpType  
 End  
 Close @DelCur  
 DeAllocate @DelCur  
End

GO
