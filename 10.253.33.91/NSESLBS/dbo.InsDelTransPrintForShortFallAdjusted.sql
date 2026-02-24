-- Object: PROCEDURE dbo.InsDelTransPrintForShortFallAdjusted
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc InsDelTransPrintForShortFallAdjusted   
 (  
  @OptFlag Int,   
  @BDpType Varchar(4),   
  @BDpId Varchar(8),   
  @BCltDpID Varchar(16)  
 )                 
AS                
 
 DECLARE                 
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
 @ToParty Varchar(10)      
  
  
 IF @OptFlag = 1   --- POA   
 BEGIN  
  UPDATE FoPOAMarginShortFallAdjusted  Set  Status = 'Generated'  
  FROM FoPOAMarginShortFallAdjusted AS POA, DelTransPrintReliable AS D  
  WHERE POA.Party_Code = D.Party_Code  
  AND POA.Scrip_Cd = D.Scrip_Cd  
  AND POA.Series = D.Series  
  AND POA.ISIN = D.CertNo  
  --POA. = D.BDpType  
  AND POA.DpID = D.DpID  
  AND POA.CltDpID = D.CltDpId  
  AND POA.Status = 'ShortFall Adjusted'   
  AND D.TrType = '1002'  
 END  

 If @OptFlag = 6              
 Begin                
  Update DelTrans Set Delivered = 'G', SlipNo = D.SlipNo,                 
  BatchNo = D.BatchNo, FolioNo = D.FolioNo,                
  TransDate = D.TransDate, HolderName = d.HolderName          
  From DelTransPrintReliable D                
  Where DelTrans.Party_Code >= D.FromParty                
  And DelTrans.Party_Code <= D.ToParty                
  And DelTrans.Party_Code <> 'BROKER'    
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
      
  Insert Into DelTransTemp                
  Select DelTrans.Sno,DelTrans.Sett_No,DelTrans.Sett_type,DelTrans.RefNo,DelTrans.TCode,TrType=904,                
  DelTrans.Party_Code,DelTrans.scrip_cd,DelTrans.series,DelTrans.Qty,DelTrans.FromNo,DelTrans.ToNo,                
  DelTrans.CertNo,DelTrans.FolioNo,DelTrans.HolderName,DelTrans.Reason,DelTrans.DrCr,'0',DelTrans.OrgQty,                
  DelTrans.DpType,DelTrans.DpId,DelTrans.CltDpId,DelTrans.BranchCd,DelTrans.PartipantCode,DelTrans.SlipNo,                
  DelTrans.BatchNo,DelTrans.ISett_No,DelTrans.ISett_Type,DelTrans.ShareType,DelTrans.TransDate,DelTrans.Filler1,                
  DelTrans.Filler2,DelTrans.Filler3,@BDpType,@BDpId,@BCltDpId,DelTrans.Filler4,DelTrans.Filler5          
  From DelTrans, DelTransPrintReliable D                
  Where DelTrans.Party_Code >= D.FromParty                
  And DelTrans.Party_Code <= D.ToParty                
  And DelTrans.Party_Code <> 'BROKER'                
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
 END     ---   If @OptFlag = 6

GO
