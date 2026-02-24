-- Object: PROCEDURE dbo.InsDelTransPrintBen_ilfs
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

 CREATE Proc InsDelTransPrintBen_ilfs (@OptFlag Int, @BDpType Varchar(4), @BDpId Varchar(8), @BCltDpID Varchar(16))               
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
@Scrip_Cd Varchar(12),              
@Series Varchar(3),              
@CertNo Varchar(12),              
@TrType Int,              
@DpId Varchar(8),              
@CltDpId Varchar(16),              
@DelBDpId Varchar(8),              
@DelBCltDpId Varchar(16),              
@AllQty Int,              
@DelCur Cursor,              
@BenCur Cursor,    
@RefNo Int,    
@FromParty Varchar(10),             
@ToParty Varchar(10),  
@DPTYPE VARCHAR(4),  
@FLAG int   
    
    
If @OptFlag = 3              
Begin              
    
Update DelTransPrintBen Set OptionFlag = 3 Where OptionFlag = 4    
    
Update DelTrans Set Delivered = 'G', SlipNo = D.SlipNo,               
BatchNo = D.BatchNo, FolioNo = D.FolioNo,              
TransDate = D.TransDate, HolderName = d.HolderName              
From DelTransPrintBen D              
Where DelTrans.Party_Code >= D.FromParty              
And DelTrans.Party_Code <= D.ToParty              
And DelTrans.Party_Code = D.Party_Code              
And DelTrans.Scrip_Cd = D.Scrip_Cd          
And DelTrans.Series = D.Series          
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
And Filler1 = 'Third Party'            
            
Insert Into DelTransTemp              
Select DelTrans.Sno,DelTrans.Sett_No,DelTrans.Sett_type,DelTrans.RefNo,DelTrans.TCode,DelTrans.TrType,              
DelTrans.Party_Code,DelTrans.scrip_cd,DelTrans.series,DelTrans.Qty,DelTrans.FromNo,DelTrans.ToNo,              
DelTrans.CertNo,DelTrans.FolioNo,DelTrans.HolderName,DelTrans.Reason,DelTrans.DrCr,'D',DelTrans.OrgQty,              
DelTrans.DpType,DelTrans.DpId,DelTrans.CltDpId,DelTrans.BranchCd,DelTrans.PartipantCode,DelTrans.SlipNo,              
DelTrans.BatchNo,DelTrans.ISett_No,DelTrans.ISett_Type,DelTrans.ShareType,DelTrans.TransDate,DelTrans.Filler1,              
DelTrans.Filler2,DelTrans.Filler3,DelTrans.BDpType,DelTrans.BDpId,DelTrans.BCltDpId,DelTrans.Filler4,DelTrans.Filler5              
From DelTrans, DelTransPrintBen D              
Where DelTrans.Party_Code >= D.FromParty              
And DelTrans.Party_Code <= D.ToParty              
And DelTrans.Party_Code = D.Party_Code              
And DelTrans.Scrip_Cd = D.Scrip_Cd          
And DelTrans.Series = D.Series          
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
And OptionFlag = 3              
And DelTrans.SlipNo = D.SlipNo            
And DelTrans.BatchNo = D.BatchNo            
And Filler1 = 'Third Party'            
              
Set @BenCur = Cursor For              
Select Party_Code, Scrip_Cd, Series, CertNo, TrType, DpId, CltDpId, SlipNo, BatchNo, FolioNo,               
HolderName, NewQty , TransDate = Left(Convert(Varchar,TransDate,109),11), BDpId, BCltDpId              
From DelTransPrintBen Where OptionFlag = 3 And Qty <> NewQty               
Order BY Party_Code, CertNo              
Open @BenCur              
Fetch Next From @BenCur into @Party_Code, @Scrip_Cd, @Series, @CertNo, @TrType, @DpId,      
@CltDpId, @SlipNo, @BatchNo, @FolioNo, @HolderName, @AllQty , @TransDate, @DelBDpId, @DelBCltDpId              
While @@Fetch_Status = 0               
Begin              
 Select @DiffQty = @AllQty              
 Set @DelCur = Cursor For              
 Select Sett_no, Sett_Type, Sno, Qty From DelTrans              
 Where Party_Code = @Party_Code              
 And Scrip_Cd = @Scrip_Cd              
 And Series = @Series          
 And CertNo = @CertNo              
 And TrType = @TrType              
 And DrCr = 'D'              
 And Delivered = '0'              
 And Filler2 = 1               
 And DpId = @DpId              
 And CltDpId = @CltDpId              
 And BDpId = @DelBDpId              
 And BCltDpId = @DelBCltDpId              
 And Filler1 = 'Third Party'            
 Order By Sett_No, Sett_Type, Qty Desc              
 Open @DelCur              
 Fetch Next From @DelCur into @Sett_No, @Sett_Type, @Sno, @Qty               
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
  Fetch Next From @DelCur into @Sett_No, @Sett_Type, @Sno, @Qty              
 End              
 Fetch Next From @BenCur into @Party_Code, @Scrip_Cd, @Series, @CertNo, @TrType, @DpId,           
 @CltDpId, @SlipNo, @BatchNo, @FolioNo, @HolderName, @AllQty , @TransDate, @DelBDpId, @DelBCltDpId              
End              
              
Insert Into DelTransTemp              
Select DelTrans.Sno,DelTrans.Sett_No,DelTrans.Sett_type,DelTrans.RefNo,DelTrans.TCode,DelTrans.TrType,              
DelTrans.Party_Code,DelTrans.scrip_cd,DelTrans.series,DelTrans.Qty,DelTrans.FromNo,DelTrans.ToNo,              
DelTrans.CertNo,DelTrans.FolioNo,DelTrans.HolderName,DelTrans.Reason,DelTrans.DrCr,'D',DelTrans.OrgQty,              
DelTrans.DpType,DelTrans.DpId,DelTrans.CltDpId,DelTrans.BranchCd,DelTrans.PartipantCode,DelTrans.SlipNo,              
DelTrans.BatchNo,DelTrans.ISett_No,DelTrans.ISett_Type,DelTrans.ShareType,DelTrans.TransDate,DelTrans.Filler1,              
DelTrans.Filler2,DelTrans.Filler3,DelTrans.BDpType,DelTrans.BDpId,DelTrans.BCltDpId,DelTrans.Filler4,DelTrans.Filler5              
From DelTrans, DelTransPrintBen D              
Where DelTrans.Party_Code >= D.FromParty              
And DelTrans.Party_Code <= D.ToParty              
And DelTrans.Party_Code = D.Party_Code              
And DelTrans.Scrip_Cd = D.Scrip_Cd          
And DelTrans.Series = D.Series          
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
And OptionFlag = 3            
And DelTrans.SlipNo = D.SlipNo            
And DelTrans.BatchNo = D.BatchNo            
And Filler1 = 'Third Party'              
End              
              
If @OptFlag = 4              
Begin              
  
SELECT TOP 1 @DPTYPE = (CASE WHEN DPID LIKE 'IN%' THEN 'NSDL' ELSE 'CDSL' END)  
FROM DelTransPrintBen  
  
Select @RefNo = RefNo From DelSegment     
Select @FromParty = IsNull(Min(FromParty),'0'), @ToParty = IsNull(Max(ToParty),'ZZZZZZZ') From DelTransPrintBen    
    
Update DelTrans Set Delivered = 'G', SlipNo = D.SlipNo,               
BatchNo = D.BatchNo, FolioNo = D.FolioNo,              
TransDate = D.TransDate, HolderName = d.HolderName              
From DelTransPrintBen D              
Where DelTrans.Party_Code >= D.FromParty              
And DelTrans.Party_Code <= D.ToParty              
And DelTrans.Party_Code = D.Party_Code              
And DelTrans.Scrip_Cd = D.Scrip_Cd          
And DelTrans.Series = D.Series          
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
And Filler1 <> 'Third Party'  
And OptionFlag = 4              
And D.Qty = NewQty              
              
Set @BenCur = Cursor For              
Select Party_Code, Scrip_Cd, Series, CertNo, TrType, DpId, CltDpId, SlipNo, BatchNo, FolioNo,               
HolderName, NewQty , TransDate = Left(Convert(Varchar,TransDate,109),11), BDpId, BCltDpId              
From DelTransPrintBen Where OptionFlag = 4 And Qty <> NewQty               
Order BY Party_Code, CertNo              
Open @BenCur              
Fetch Next From @BenCur into @Party_Code, @Scrip_Cd, @Series, @CertNo, @TrType, @DpId, @CltDpId,           
@SlipNo, @BatchNo, @FolioNo, @HolderName, @AllQty , @TransDate, @DelBDpId, @DelBCltDpId              
While @@Fetch_Status = 0               
Begin              
 Select @DiffQty = @AllQty              
 Set @DelCur = Cursor For              
 Select Sett_no, Sett_Type, Sno, Qty, FLAG = 1 From DelTrans              
 Where Party_Code = @Party_Code              
 And Scrip_Cd = @Scrip_Cd          
 And Series = @Series          
 And CertNo = @CertNo              
 And TrType = @TrType              
 And DrCr = 'D'              
 And Delivered = '0'              
 And Filler2 = 1               
 And DpId = @DpId              
 And CltDpId = @CltDpId              
 And BDpId = @DelBDpId              
 And BCltDpId = @DelBCltDpId  
 And Filler1 <> 'Third Party'  
 AND SETT_NO IN (SELECT SETT_NO FROM MSAJAG.DBO.DELPAYOUT DELPAYOUT  
          WHERE DelTrans.SETT_NO = DELPAYOUT.SETT_NO  
          AND DelTrans.SETT_TYPE = DELPAYOUT.SETT_TYPE  
   AND DelTrans.PARTY_CODE = DELPAYOUT.SCRIP_CD  
   AND DelTrans.SERIES = DELPAYOUT.SERIES  
   AND DelTrans.CertNo = DELPAYOUT.CertNo  
   AND DELPAYOUT.CERTNO = @CertNo)  
 UNION    
 Select Sett_no, Sett_Type, Sno, Qty, FLAG = 2 From DelTrans              
 Where Party_Code = @Party_Code              
 And Scrip_Cd = @Scrip_Cd          
 And Series = @Series          
 And CertNo = @CertNo              
 And TrType = @TrType              
 And DrCr = 'D'              
 And Delivered = '0'              
 And Filler2 = 1               
 And DpId = @DpId              
 And CltDpId = @CltDpId              
 And BDpId = @DelBDpId              
 And BCltDpId = @DelBCltDpId  
 And Filler1 <> 'Third Party'  
 AND SETT_NO NOT IN (SELECT SETT_NO FROM MSAJAG.DBO.DELPAYOUT DELPAYOUT  
          WHERE DelTrans.SETT_NO = DELPAYOUT.SETT_NO  
          AND DelTrans.SETT_TYPE = DELPAYOUT.SETT_TYPE  
   AND DelTrans.PARTY_CODE = DELPAYOUT.SCRIP_CD  
   AND DelTrans.SERIES = DELPAYOUT.SERIES  
   AND DelTrans.CertNo = DELPAYOUT.CertNo  
   AND DELPAYOUT.CERTNO = @CertNo)  
 Order By FLAG, Sett_No, Sett_Type, Qty Desc              
 Open @DelCur              
 Fetch Next From @DelCur into @Sett_No, @Sett_Type, @Sno, @Qty, @FLAG               
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
  Fetch Next From @DelCur into @Sett_No, @Sett_Type, @Sno, @Qty, @FLAG              
 End              
 Fetch Next From @BenCur into @Party_Code, @Scrip_Cd, @Series, @CertNo, @TrType, @DpId, @CltDpId,           
 @SlipNo, @BatchNo, @FolioNo, @HolderName, @AllQty , @TransDate, @DelBDpId, @DelBCltDpId              
End              
              
Insert Into DelTransTemp              
Select DelTrans.Sno,DelTrans.Sett_No,DelTrans.Sett_type,DelTrans.RefNo,DelTrans.TCode,DelTrans.TrType,              
DelTrans.Party_Code,DelTrans.scrip_cd,DelTrans.series,DelTrans.Qty,DelTrans.FromNo,DelTrans.ToNo,              
DelTrans.CertNo,DelTrans.FolioNo,DelTrans.HolderName,DelTrans.Reason,DelTrans.DrCr,'D',DelTrans.OrgQty,              
DelTrans.DpType,DelTrans.DpId,DelTrans.CltDpId,DelTrans.BranchCd,DelTrans.PartipantCode,DelTrans.SlipNo,              
DelTrans.BatchNo,DelTrans.ISett_No,DelTrans.ISett_Type,DelTrans.ShareType,DelTrans.TransDate,DelTrans.Filler1,              
DelTrans.Filler2,DelTrans.Filler3,DelTrans.BDpType,DelTrans.BDpId,DelTrans.BCltDpId,DelTrans.Filler4,DelTrans.Filler5              
From DelTrans, DelTransPrintBen D              
Where DelTrans.Party_Code >= D.FromParty              
And DelTrans.Party_Code <= D.ToParty              
And DelTrans.Party_Code = D.Party_Code              
And DelTrans.Scrip_Cd = D.Scrip_Cd          
And DelTrans.Series = D.Series          
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
And OptionFlag = 4              
And DelTrans.SlipNo = D.SlipNo            
And DelTrans.BatchNo = D.BatchNo    
    
Insert Into MSAJAG.DBO.DelPayOut_Reco    
Select Exchange, Sett_No, Sett_Type, Party_Code, Scrip_Cd, Series, CertNo, AcType,     
HoldQty=DebitQty, RMSPayQty=ActPayOut, PayQty, RunDate = GetDate()    
From MSAJAG.DBO.DelPayOut    
Where Party_Code BetWeen @FromParty And @ToParty    
And Exchange = (Case When @RefNo = 110 Then 'NSE' Else 'BSE' End)  
AND PARTY_CODE IN (SELECT PARTY_CODE FROM CLIENT4  
WHERE DEFDP = 1 AND DEPOSITORY = @DPTYPE)  
    
Insert Into MSAJAG.DBO.DelPayOut_Reco    
Select Exchange=(Case When RefNo = 110 Then 'NSE' Else 'BSE' End),    
DelTransTemp.Sett_No, DelTransTemp.Sett_Type, DelTransTemp.Party_Code,     
DelTransTemp.Scrip_Cd, DelTransTemp.Series, DelTransTemp.CertNo, AcType = 'BEN',    
HoldQty = 0, RMSPayQty = 0, PayQty = Sum(DelTransTemp.Qty), RunDate = GetDate()    
From DelTransTemp, DelTransPrintBen D              
Where DelTransTemp.Party_Code >= D.FromParty              
And DelTransTemp.Party_Code <= D.ToParty              
And DelTransTemp.Party_Code = D.Party_Code              
And DelTransTemp.Scrip_Cd = D.Scrip_Cd          
And DelTransTemp.Series = D.Series          
And DelTransTemp.CertNo = D.CertNo              
And DelTransTemp.TrType = D.TrType              
And Filler2 = 1    
And DrCr = 'D'    
And DelTransTemp.BDpType = D.BDpType              
And DelTransTemp.BDpId = D.BDpId              
And DelTransTemp.BCltDpId = D.BCltDpId              
And Delivered = 'D'              
And DelTransTemp.DpId = D.DpId              
And DelTransTemp.CltDpId = D.CltDpId              
And DelTransTemp.FolioNo = D.FolioNo              
And OptionFlag = 4              
And DelTransTemp.SlipNo = D.SlipNo            
And DelTransTemp.BatchNo = D.BatchNo    
Group By DelTransTemp.Sett_No, DelTransTemp.Sett_Type, DelTransTemp.Party_Code,     
DelTransTemp.Scrip_Cd, DelTransTemp.Series, DelTransTemp.CertNo, DelTransTemp.RefNo    
    
Delete From MSAJAG.DBO.DelPayOut    
Where Party_Code BetWeen @FromParty And @ToParty    
And Exchange = (Case When @RefNo = 110 Then 'NSE' Else 'BSE' End)    
AND PARTY_CODE IN (SELECT PARTY_CODE FROM CLIENT4  
WHERE DEFDP = 1 AND DEPOSITORY = @DPTYPE)  
End              
              
If @OptFlag = 5              
Begin              
Update DelTrans Set Delivered = 'G', SlipNo = D.SlipNo,               
BatchNo = D.BatchNo, FolioNo = D.FolioNo,              
TransDate = D.TransDate, HolderName = d.HolderName              
From DelTransPrintBen D              
Where DelTrans.Party_Code >= D.FromParty              
And DelTrans.Party_Code <= D.ToParty              
And DelTrans.Party_Code = D.Party_Code        
And DelTrans.Scrip_Cd = D.Scrip_Cd          
And DelTrans.Series = D.Series          
And DelTrans.CertNo = D.CertNo              
And DelTrans.TrType = D.TrType              
And Filler2 = 1              
And DrCr = 'D'              
And DelTrans.BDpType = D.BDpType              
And DelTrans.BDpId = D.BDpId              
And DelTrans.BCltDpId = D.BCltDpId              
And Delivered = '0'              
And OptionFlag = 5              
And D.Qty = NewQty              
        
Set @BenCur = Cursor For              
Select Party_Code, Scrip_Cd, Series, CertNo, TrType, SlipNo, BatchNo, FolioNo,               
HolderName, NewQty , TransDate = Left(Convert(Varchar,TransDate,109),11), BDpId, BCltDpId              
From DelTransPrintBen Where OptionFlag = 5 And Qty <> NewQty               
Order BY Party_Code, CertNo              
Open @BenCur              
Fetch Next From @BenCur into @Party_Code, @Scrip_Cd, @Series, @CertNo, @TrType,         
@SlipNo, @BatchNo, @FolioNo, @HolderName, @AllQty , @TransDate, @DelBDpId, @DelBCltDpId              
While @@Fetch_Status = 0               
Begin              
 Select @DiffQty = @AllQty              
 Set @DelCur = Cursor For              
 Select Sett_no, Sett_Type, Sno, Qty From DelTrans              
 Where Party_Code = @Party_Code              
 And Scrip_Cd = @Scrip_Cd          
 And Series = @Series          
 And CertNo = @CertNo              
 And TrType = @TrType              
 And DrCr = 'D'              
 And Delivered = '0'              
 And Filler2 = 1               
 And BDpId = @DelBDpId              
 And BCltDpId = @DelBCltDpId              
 Order By Sett_No, Sett_Type, Qty Desc              
 Open @DelCur              
 Fetch Next From @DelCur into @Sett_No, @Sett_Type, @Sno, @Qty               
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
  Fetch Next From @DelCur into @Sett_No, @Sett_Type, @Sno, @Qty              
 End              
 Fetch Next From @BenCur into @Party_Code, @Scrip_Cd, @Series, @CertNo, @TrType,         
 @SlipNo, @BatchNo, @FolioNo, @HolderName, @AllQty , @TransDate, @DelBDpId, @DelBCltDpId              
End              
              
Insert Into DelTransTemp              
Select DelTrans.Sno,DelTrans.Sett_No,DelTrans.Sett_type,DelTrans.RefNo,DelTrans.TCode,DelTrans.TrType,              
DelTrans.Party_Code,DelTrans.scrip_cd,DelTrans.series,DelTrans.Qty,DelTrans.FromNo,DelTrans.ToNo,              
DelTrans.CertNo,DelTrans.FolioNo,DelTrans.HolderName,DelTrans.Reason,DelTrans.DrCr,'0',DelTrans.OrgQty,              
DelTrans.DpType,DelTrans.DpId,DelTrans.CltDpId,DelTrans.BranchCd,DelTrans.PartipantCode,DelTrans.SlipNo,              
DelTrans.BatchNo,DelTrans.ISett_No,DelTrans.ISett_Type,DelTrans.ShareType,DelTrans.TransDate,DelTrans.Filler1,              
DelTrans.Filler2,DelTrans.Filler3,@BDpType,@BDpId,@BCltDpId,DelTrans.Filler4,DelTrans.Filler5         
From DelTrans, DelTransPrintBen D              
Where DelTrans.Party_Code >= D.FromParty              
And DelTrans.Party_Code <= D.ToParty              
And DelTrans.Party_Code = D.Party_Code              
And DelTrans.Scrip_Cd = D.Scrip_Cd          
And DelTrans.Series = D.Series          
And DelTrans.CertNo = D.CertNo              
And DelTrans.TrType = D.TrType              
And Filler2 = 1              
And DrCr = 'D'              
And DelTrans.BDpType = D.BDpType              
And DelTrans.BDpId = D.BDpId              
And DelTrans.BCltDpId = D.BCltDpId              
And Delivered = 'G'              
And DelTrans.FolioNo = D.FolioNo              
And OptionFlag = 5        
And DelTrans.SlipNo = D.SlipNo            
And DelTrans.BatchNo = D.BatchNo              
End        
              
If @OptFlag = 6            
Begin              
Update DelTrans Set Delivered = 'G', SlipNo = D.SlipNo,               
BatchNo = D.BatchNo, FolioNo = D.FolioNo,              
TransDate = D.TransDate, HolderName = d.HolderName,            
DpType = @BDpType, DpId = @BDpId, CltDpId = @BCltDpId            
From DelTransPrintBen D              
Where DelTrans.Party_Code >= D.FromParty              
And DelTrans.Party_Code <= D.ToParty              
And DelTrans.Party_Code = D.Party_Code        
And DelTrans.Scrip_Cd = D.Scrip_Cd          
And DelTrans.Series = D.Series          
And DelTrans.CertNo = D.CertNo              
And DelTrans.TrType = D.TrType              
And Filler2 = 1              
And DrCr = 'D'              
And DelTrans.BDpType = D.BDpType              
And DelTrans.BDpId = D.BDpId              
And DelTrans.BCltDpId = D.BCltDpId              
And Delivered = '0'              
And OptionFlag = 6            
And D.Qty = NewQty              
              
Set @BenCur = Cursor For              
Select Party_Code, Scrip_Cd, Series, CertNo, TrType, SlipNo, BatchNo, FolioNo,               
HolderName, NewQty , TransDate = Left(Convert(Varchar,TransDate,109),11), BDpId, BCltDpId              
From DelTransPrintBen Where OptionFlag = 6 And Qty <> NewQty               
Order BY Party_Code, CertNo              
Open @BenCur              
Fetch Next From @BenCur into @Party_Code, @Scrip_Cd, @Series, @CertNo, @TrType,         
@SlipNo, @BatchNo, @FolioNo, @HolderName, @AllQty , @TransDate, @DelBDpId, @DelBCltDpId              
While @@Fetch_Status = 0               
Begin              
 Select @DiffQty = @AllQty              
 Set @DelCur = Cursor For              
 Select Sett_no, Sett_Type, Sno, Qty From DelTrans              
 Where Party_Code = @Party_Code              
 And Scrip_Cd = @Scrip_Cd          
 And Series = @Series          
 And CertNo = @CertNo              
 And TrType = @TrType              
 And DrCr = 'D'              
 And Delivered = '0'              
 And Filler2 = 1               
 And BDpId = @DelBDpId              
 And BCltDpId = @DelBCltDpId              
 Order By Sett_No, Sett_Type, Qty Desc              
 Open @DelCur              
 Fetch Next From @DelCur into @Sett_No, @Sett_Type, @Sno, @Qty               
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
  Fetch Next From @DelCur into @Sett_No, @Sett_Type, @Sno, @Qty              
 End              
 Fetch Next From @BenCur into @Party_Code, @Scrip_Cd, @Series, @CertNo, @TrType,         
 @SlipNo, @BatchNo, @FolioNo, @HolderName, @AllQty , @TransDate, @DelBDpId, @DelBCltDpId              
End              
              
Insert Into DelTransTemp              
Select DelTrans.Sno,DelTrans.Sett_No,DelTrans.Sett_type,DelTrans.RefNo,DelTrans.TCode,DelTrans.TrType,              
DelTrans.Party_Code,DelTrans.scrip_cd,DelTrans.series,DelTrans.Qty,DelTrans.FromNo,DelTrans.ToNo,              
DelTrans.CertNo,DelTrans.FolioNo,DelTrans.HolderName,DelTrans.Reason,DelTrans.DrCr,'D',DelTrans.OrgQty,              
DelTrans.DpType,DelTrans.DpId,DelTrans.CltDpId,DelTrans.BranchCd,DelTrans.PartipantCode,DelTrans.SlipNo,              
DelTrans.BatchNo,DelTrans.ISett_No,DelTrans.ISett_Type,DelTrans.ShareType,DelTrans.TransDate,DelTrans.Filler1,              
DelTrans.Filler2,DelTrans.Filler3,DelTrans.BDpType,DelTrans.BDpId,DelTrans.BCltDpId,DelTrans.Filler4,DelTrans.Filler5        
From DelTrans, DelTransPrintBen D              
Where DelTrans.Party_Code >= D.FromParty              
And DelTrans.Party_Code <= D.ToParty              
And DelTrans.Party_Code = D.Party_Code              
And DelTrans.Scrip_Cd = D.Scrip_Cd          
And DelTrans.Series = D.Series          
And DelTrans.CertNo = D.CertNo              
And DelTrans.TrType = D.TrType              
And Filler2 = 1              
And DrCr = 'D'              
And DelTrans.BDpType = D.BDpType              
And DelTrans.BDpId = D.BDpId              
And DelTrans.BCltDpId = D.BCltDpId              
And Delivered = 'G'              
And DelTrans.FolioNo = D.FolioNo              
And OptionFlag = 6        
And DelTrans.SlipNo = D.SlipNo            
And DelTrans.BatchNo = D.BatchNo              
End

GO
