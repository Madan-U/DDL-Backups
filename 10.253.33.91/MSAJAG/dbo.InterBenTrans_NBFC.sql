-- Object: PROCEDURE dbo.InterBenTrans_NBFC
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc InterBenTrans_NBFC ( @Sett_no Varchar(7),@Sett_Type Varchar(2),@RefNo Int) As    
Declare @NBFCPos Cursor,  
@Party_Code Varchar(10),  
@Scrip_Cd Varchar(12),   
@Series Varchar(3),  
@BseCode Varchar(10),   
@IsIn Varchar(12),   
@ToRecQty Int,  
@Diff Int,  
@Hold Int,   
@Exchg Varchar(3),  
@BDpType Varchar(4),  
@BDpId varchar(8),   
@BCltDpId Varchar(16),  
@HoldCur Cursor,  
@NSEParticiPantCode Varchar(15),  
@BSEParticiPantCode Varchar(15)  
  
Select @NSEParticiPantCode = MemberCode From MSAJAG.DBO.Owner  
Select @BSEParticiPantCode = MemberCode From BSEDB.DBO.Owner  
  
/* Postion Qty */  
Select D.PARTY_CODE,Scrip_CD=D.SCRIP_CD,Series=D.SERIES,  
BSECODE=IsNull(BM.Scrip_Cd,'NA'),M.IsIn,  
PQTY=QTY, NSEHold = 0, BseHold = 0, Rec = 0, BseInst = 0, NseInst = 0  
Into #DelInterBen from Client1 C1, Client2 C2, msajag.Dbo.DeliveryClt D, msajag.DBO.MultiIsin M   
Left Outer Join bsedb.Dbo.MultiIsin BM    
On (BM.IsIn = M.IsIn And BM.Valid = 1 )    
Where D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type  
And D.Scrip_Cd = M.Scrip_Cd and d.series = m.series And InOut = 'I'    
and M.valid = 1 And C1.Cl_Code = C2.Cl_Code  
And C2.Party_Code = D.Party_Code And C1.Cl_Type = 'NBF'  
  
/* Already Rec */  
Insert Into #DelInterBen    
Select DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,IsIn,  
PQty = 0, NSEHold = 0, BseHold = 0, Rec = IsNull(Sum(Qty),0), BseInst = 0, NseInst = 0  
From DelTrans D, #DelInterBen DT where D.SETT_NO = @Sett_No  
And D.sett_type = @Sett_Type and D.party_code = DT.Party_Code    
and D.CertNo = DT.IsIn and DrCr = 'C' and sharetype <> 'auction'    
and Filler2 = 1 And PQty > 0   
Group By DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,IsIn  
  
/* Bse Inter Sett */  
Insert Into #DelInterBen    
Select DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,IsIn,  
PQty = 0, NSEHold = 0, BseHold = 0, Rec = 0, BseInst = IsNull(Sum(Qty),0), NseInst = 0  
From BSEDB.DBO.DelTrans D, #DelInterBen DT where D.ISETT_NO = @Sett_No  
And D.ISett_type = @Sett_Type and D.party_code = DT.Party_Code    
and D.CertNo = DT.IsIn and DrCr = 'D' and sharetype <> 'auction'    
and Filler2 = 1 And PQty > 0 And Delivered <> 'D'  
Group By DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,IsIn  
   
/* Nse Inter Sett */  
Insert Into #DelInterBen    
Select DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,IsIn,  
PQty = 0, NSEHold = 0, BseHold = 0, Rec = 0, BseInst = 0, NseInst = IsNull(Sum(Qty),0)  
From MSAJAG.DBO.DelTrans D, #DelInterBen DT where D.ISETT_NO = @Sett_No  
And D.ISett_type = @Sett_Type and D.party_code = DT.Party_Code    
and D.CertNo = DT.IsIn and DrCr = 'D' and sharetype <> 'auction'    
and Filler2 = 1 And PQty > 0 And Delivered <> 'D'  
Group By DT.PARTY_CODE,DT.SCRIP_CD,DT.Series,DT.BSECODE,IsIn  
  
/* Bse NBFC Inter Sett */  
Insert Into #DelInterBen    
select Party_Code, Scrip_CD=IsNull(M.SCRIP_CD,'NA'), D.SERIES,BSECODE=D.Scrip_cd, CertNo,   
PQty = 0, NSEHold = 0, BseHold = 0, Rec = 0, BseInst = IsNull(Sum(Qty),0), NseInst = 0  
From BSEDB.DBO.deltrans_nbfc d, BSEDB.DBO.DeliveryDp DP, BSEDB.DBO.MultiIsIn Bm   
Left Outer Join Msajag.DBO.MultiIsin M    
On ( BM.IsIn = M.IsIn And M.Valid = 1 )     
Where ISett_No = @Sett_No   
And ISett_Type = @Sett_Type  
And DrCr = 'D' And TrType = 1000  
And Dp.DpType = D.BDpType  
And Dp.DpId = D.BDpId  
And DP.DPCltNo = D.BCltDpId  
And DP.Description Not Like '%POOL%'  
And D.CertNo = BM.IsIn and BM.Valid =1    
GROUP BY Party_Code, IsNull(M.SCRIP_CD,'NA'), D.SERIES, D.Scrip_cd, CertNo  
  
/* Nse NBFC Inter Sett */  
Insert Into #DelInterBen    
select Party_Code, D.SCRIP_CD, D.SERIES,BSECODE=IsNull(M.SCRIP_CD,'NA'), CertNo,   
PQty = 0, NSEHold = 0, BseHold = 0, Rec = 0, BseInst = 0, NseInst = IsNull(Sum(Qty),0)  
From MSAJAG.DBO.deltrans_nbfc d, MSAJAG.DBO.DeliveryDp DP, MSAJAG.DBO.MultiIsIn Bm   
Left Outer Join BSEDB.DBO.MultiIsin M    
On ( BM.IsIn = M.IsIn And M.Valid = 1 )     
Where ISett_No = @Sett_No   
And ISett_Type = @Sett_Type  
And DrCr = 'D' And TrType = 1000  
And Dp.DpType = D.BDpType  
And Dp.DpId = D.BDpId  
And DP.DPCltNo = D.BCltDpId  
And DP.Description Not Like '%POOL%'  
And D.CertNo = BM.IsIn and BM.Valid =1    
GROUP BY Party_Code, D.SCRIP_CD, D.SERIES,IsNull(M.SCRIP_CD,'NA'), CertNo  
  
/* Bse Holding */  
select Party_Code, Scrip_CD=IsNull(M.SCRIP_CD,'NA'), D.SERIES,BSECODE=D.Scrip_cd, CertNo,   
Hold = Sum(Case When DrCr = 'C' Then Qty Else -Qty End), Exchg = 'BSE', BDpType, BDpId, BCltDpId  
Into #NBFCHold From BSEDB.DBO.deltrans_nbfc d, BSEDB.DBO.DeliveryDp DP, BSEDB.DBO.MultiIsIn Bm   
Left Outer Join Msajag.DBO.MultiIsin M    
On ( BM.IsIn = M.IsIn And M.Valid = 1 )     
Where Dp.DpType = D.BDpType  
And Dp.DpId = D.BDpId  
And DP.DPCltNo = D.BCltDpId  
And DP.Description Not Like '%POOL%'  
And D.CertNo = BM.IsIn and BM.Valid = 1
And TrType <> 909
GROUP BY PARTY_CODE,M.Scrip_CD,D.SCRIP_CD,D.SERIES,CertNo,BDpType, BDpId, BCltDpId  
Having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) > 0  
  
/* Nse Holding */  
Insert Into #NBFCHold  
select Party_Code, D.SCRIP_CD, D.SERIES,BSECODE=IsNull(M.SCRIP_CD,'NA'), CertNo,   
Hold = Sum(Case When DrCr = 'C' Then Qty Else -Qty End), Exchg = 'NSE', BDpType, BDpId, BCltDpId  
From MSAJAG.DBO.deltrans_nbfc d, MSAJAG.DBO.DeliveryDp DP, MSAJAG.DBO.MultiIsIn Bm   
Left Outer Join BSEDB.DBO.MultiIsin M    
On ( BM.IsIn = M.IsIn And M.Valid = 1 )     
Where Dp.DpType = D.BDpType  
And Dp.DpId = D.BDpId  
And DP.DPCltNo = D.BCltDpId  
And DP.Description Not Like '%POOL%'  
And D.CertNo = BM.IsIn and BM.Valid = 1  
And TrType <> 909
GROUP BY PARTY_CODE,M.Scrip_CD,D.SCRIP_CD,D.SERIES,CertNo,BDpType, BDpId, BCltDpId  
Having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) > 0  
  
Set @NBFCPos = cursor for  
Select Party_Code, Scrip_Cd, Series, BSECode, IsIn,   
ToRecQty = Sum(PQty)-Sum(Rec + BseInst + NseInst)   
From #DelInterBen   
Group By Party_Code, Scrip_Cd, Series, BSECode, IsIn  
Order BY Party_Code, IsIn  
Open @NBFCPos  
Fetch Next From @NBFCPos into @Party_Code, @Scrip_Cd, @Series, @BseCode, @IsIn, @ToRecQty   
While @@Fetch_Status = 0   
Begin  
 Select @Diff = @ToRecQty  
 Set @HoldCur = Cursor For   
 Select Hold, Exchg, BDpType, BDpId, BCltDpId From #NBFCHold  
 Where Party_Code = @Party_Code   
        And CertNo = @IsIn  
 Order By Exchg Desc  
 Open @HoldCur  
 Fetch Next From @HoldCur Into @Hold, @Exchg, @BDpType, @BDpId, @BCltDpId  
 While @@Fetch_Status = 0 And @Diff > 0  
 Begin  
  If @Diff >= @Hold  
  Begin  
   If @Exchg = 'NSE'   
    Insert into MSAJAG.DBO.DelTrans_NBFC  
    Select '2000000', 'N', 110, 0, 1000,  
    @Party_Code, @scrip_cd, @Series, @Hold, '0', '0', @IsIn, '0', 'Inter Ben Transfer', 'Inter Ben Transfer',  
    'D', '0' , @Hold, DpType='', DpId='', CltDpId='', BranchCd = 'HO', @NSEParticiPantCode, '0', '0', @Sett_No, @Sett_Type,  
    'DEMAT', Convert(Varchar,GetDate()), '', 1, '', @BDpType, @BDpId, @BCltDpId, Filler4='0', Filler5 = '0'  
   Else  
    Insert into BSEDB.DBO.DelTrans_NBFC  
    Select '2000000', 'D', 120, 0, 1000,  
    @Party_Code, @BseCode, 'BSE', @Hold, '0', '0', @IsIn, '0', 'Inter Exchg Transfer', 'Inter Ben Transfer',  
    'D', '0' , @Hold, DpType='', DpId='', CltDpId='', BranchCd = 'HO', @BSEParticiPantCode, '0', '0', @Sett_No, @Sett_Type,  
    'DEMAT', Convert(Varchar,GetDate()), '', 1, '', @BDpType, @BDpId, @BCltDpId, Filler4='0', Filler5 = '0'  
  
   Select @Diff = @Diff - @Hold  
  End  
  Else  
  Begin  
   If @Exchg = 'NSE'   
    Insert into MSAJAG.DBO.DelTrans_NBFC  
    Select '2000000', 'N', 110, 0, 1000,  
    @Party_Code, @scrip_cd, @Series, @Diff, '0', '0', @IsIn, '0', 'Inter Ben Transfer', 'Inter Ben Transfer',  
                         'D', '0' , @Diff, DpType='', DpId='', CltDpId='', BranchCd = 'HO', @NSEParticiPantCode, '0', '0', @Sett_No, @Sett_Type,  
    'DEMAT', Convert(Varchar,GetDate()), '', 1, '', @BDpType, @BDpId, @BCltDpId, Filler4='0', Filler5 = '0'  
   Else  
    Insert into BSEDB.DBO.DelTrans_NBFC  
    Select '2000000', 'D', 120, 0, 1000,  
    @Party_Code, @BseCode, 'BSE', @Diff, '0', '0', @IsIn, '0', 'Inter Exchg Transfer', 'Inter Ben Transfer',  
  'D', '0' , @Diff, DpType='', DpId='', CltDpId='', BranchCd = 'HO', @BSEParticiPantCode, '0', '0', @Sett_No, @Sett_Type,  
    'DEMAT', Convert(Varchar,GetDate()), '', 1, '', @BDpType, @BDpId, @BCltDpId, Filler4='0', Filler5 = '0'  
  
   Select @Diff = 0  
  End  
    
  Fetch Next From @HoldCur Into @Hold, @Exchg, @BDpType, @BDpId, @BCltDpId  
 End   
 Fetch Next From @NBFCPos into @Party_Code, @Scrip_Cd, @Series, @BseCode, @IsIn, @ToRecQty   
End  
  
Update MSAJAG.DBO.DelTrans_NBFC Set DpType = M.DpType, DpId = M.DpId, CltDpId = M.CltDpNo  
From MultiCltId M, MSAJAG.DBO.DelTrans_NBFC N, MSAJAG.DBO.DeliveryDp D  
Where N.Party_Code = M.Party_Code  
And N.BDpType  = D.DpType  
And N.BDpId    = D.DpId  
And N.BCltDpId = D.DpCltNo  
And M.Def = 1 And TrType = 1000   
And DrCr = 'D' And N.DpId = ''  
  
Update BSEDB.DBO.DelTrans_NBFC Set DpType = M.DpType, DpId = M.DpId, CltDpId = M.CltDpNo  
From MultiCltId M, BSEDB.DBO.DelTrans_NBFC N, BSEDB.DBO.DeliveryDp D  
Where N.Party_Code = M.Party_Code  
And N.BDpType  = D.DpType  
And N.BDpId    = D.DpId  
And N.BCltDpId = D.DpCltNo  
And M.Def = 1 And TrType = 1000   
And DrCr = 'D' And N.DpId = ''

GO
