-- Object: PROCEDURE dbo.InsDelTransPrint_NBFC_POA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE  Proc InsDelTransPrint_NBFC_POA (@OptFlag Int, @BDpType Varchar(4), @BDpId Varchar(8), @BCltDpID Varchar(16))       
As  
If @OptFlag = 4   
Begin  
Insert into DelTrans_NBFC    
Select '2000000', Sett_type = (Case When RefNo = 110 Then 'N' Else 'D' End),  
S.RefNo, TCode = 0, D.TrType, D.Party_Code, D.scrip_cd, D.series, D.Qty, FromNo = D.FolioNo, ToNo = D.FolioNo,   
CertNo, D.FolioNo, HolderName, HolderName, DrCr = 'D', Delivered='G', D.Qty, D.DpType, D.DpId, D.CltDpId,   
BranchCd = 'HO', PartipantCode = MemberCode, D.SlipNo, D.BatchNo,     
ISett_No = '', ISett_Type = '', ShareType = 'DEMAT', D.TransDate, Filler1 = '', Filler2 = 1, Filler3 = '',   
D.BDpType, D.BDpId, D.BCltDpId, Filler4 = '', Filler5 = ''  
From DelTransPrint_NBFC D, DelSegment S, Owner  
    
Insert Into DelTransTemp_NBFC    
Select N.SNo, N.Sett_No, N.Sett_type, N.RefNo, N.TCode, N.TrType, N.Party_Code, N.scrip_cd, N.series, N.Qty, N.FromNo, N.ToNo, N.CertNo, D.FolioNo,     
D.HolderName, N.Reason, DrCr = 'D', Delivered='D', N.OrgQty, N.DpType, N.DpId, N.CltDpId, N.BranchCd, N.PartipantCode, D.SlipNo, D.BatchNo,     
N.ISett_No, N.ISett_Type, N.ShareType, D.TransDate, N.Filler1, N.Filler2, N.Filler3, N.BDpType, N.BDpId, N.BCltDpId, N.Filler4, N.Filler5     
From DelTrans_NBFC N, DelTransPrint_NBFC D        
Where N.Sett_No = '2000000'  
And N.Sett_Type = (Case When RefNo = 110 Then 'N' Else 'D' End)  
And N.Party_Code >= D.FromParty        
And N.Party_Code <= D.ToParty        
And N.Party_Code = D.Party_Code    
And N.Scrip_Cd Like '%'        
And N.Series Like '%'        
And N.CertNo = D.CertNo    
And N.TrType = D.TrType    
And N.BDpType = D.BDpType    
And N.BDpId = D.BDpId    
And N.BCltDpId = D.BCltDpId    
And N.DrCr = 'D'     
And N.Delivered = 'G'    
And N.SlipNo = D.SlipNo    
And N.FolioNo = D.FolioNo    
And N.BatchNo = D.BatchNo   
End  
Else If @OptFlag = 5
Begin  
  
Update DelTrans_NBFC Set Delivered = 'G', FromNo = D.FolioNo, ToNo = D.FolioNo,   
FolioNo = D.FolioNo, HolderName = D.HolderName, SlipNo = D.SlipNo, BatchNo = D.BatchNo, TransDate = D.TransDate  
From DelTransPrint_NBFC D  
Where DelTrans_NBFC.ISett_No = D.Sett_No  
And DelTrans_NBFC.ISett_Type = D.Sett_Type  
And DelTrans_NBFC.Party_Code >= D.FromParty        
And DelTrans_NBFC.Party_Code <= D.ToParty        
And DelTrans_NBFC.Party_Code = D.Party_Code    
And DelTrans_NBFC.Scrip_Cd Like '%'        
And DelTrans_NBFC.Series Like '%'        
And DelTrans_NBFC.CertNo = D.CertNo    
And DelTrans_NBFC.TrType = D.TrType    
And DelTrans_NBFC.BDpType = D.BDpType    
And DelTrans_NBFC.BDpId = D.BDpId    
And DelTrans_NBFC.BCltDpId = D.BCltDpId  
And DelTrans_NBFC.DrCr = 'D'  
And Delivered = '0' 
  
Insert Into DelTransTemp_NBFC    
Select N.SNo, N.Sett_No, N.Sett_type, N.RefNo, N.TCode, N.TrType, N.Party_Code, N.scrip_cd, N.series, N.Qty, N.FromNo, N.ToNo, N.CertNo, D.FolioNo,     
D.HolderName, N.Reason, DrCr = 'D', Delivered='D', N.OrgQty, N.DpType, N.DpId, N.CltDpId, N.BranchCd, N.PartipantCode, D.SlipNo, D.BatchNo,     
N.ISett_No, N.ISett_Type, N.ShareType, D.TransDate, N.Filler1, N.Filler2, N.Filler3, N.BDpType, N.BDpId, N.BCltDpId, N.Filler4, N.Filler5     
From DelTrans_NBFC N, DelTransPrint_NBFC D  
Where N.ISett_No = D.Sett_No  
And N.ISett_Type = D.Sett_Type  
And N.Party_Code >= D.FromParty        
And N.Party_Code <= D.ToParty        
And N.Party_Code = D.Party_Code    
And N.Scrip_Cd Like '%'        
And N.Series Like '%'        
And N.CertNo = D.CertNo    
And N.TrType = D.TrType    
And N.BDpType = D.BDpType    
And N.BDpId = D.BDpId    
And N.BCltDpId = D.BCltDpId    
And N.DrCr = 'D'     
And N.Delivered = 'G'    
And N.SlipNo = D.SlipNo    
And N.FolioNo = D.FolioNo    
And N.BatchNo = D.BatchNo   
  
Insert Into DelTransTemp_NBFC    
Select N.SNo, N.Sett_No, N.Sett_type, N.RefNo, N.TCode, TrType = 904, N.Party_Code, N.scrip_cd, N.series, N.Qty, N.FromNo, N.ToNo, N.CertNo, D.FolioNo,     
D.HolderName, N.Reason, DrCr = 'C', Delivered='0', N.OrgQty, N.BDpType, N.BDpId, N.BCltDpId, N.BranchCd, N.PartipantCode, D.SlipNo, D.BatchNo,     
ISett_No = '', ISett_Type = '', N.ShareType, D.TransDate, N.Filler1, N.Filler2, N.Filler3, N.DpType, N.DpId, N.CltDpId, N.Filler4, N.Filler5     
From DelTrans_NBFC N, DelTransPrint_NBFC D        
Where N.ISett_No = D.Sett_No  
And N.ISett_Type = D.Sett_Type  
And N.Party_Code >= D.FromParty        
And N.Party_Code <= D.ToParty        
And N.Party_Code = D.Party_Code    
And N.Scrip_Cd Like '%'        
And N.Series Like '%'        
And N.CertNo = D.CertNo    
And N.TrType = D.TrType    
And N.BDpType = D.BDpType    
And N.BDpId = D.BDpId    
And N.BCltDpId = D.BCltDpId    
And N.DrCr = 'D'     
And N.Delivered = 'G'    
And N.SlipNo = D.SlipNo    
And N.FolioNo = D.FolioNo    
And N.BatchNo = D.BatchNo   
  
Insert Into DelTransTemp_NBFC    
Select N.SNo, N.Sett_No, N.Sett_type, N.RefNo, N.TCode, N.TrType, N.Party_Code, N.scrip_cd, N.series, N.Qty, N.FromNo, N.ToNo, N.CertNo, D.FolioNo,     
D.HolderName, N.Reason, DrCr = 'D', Delivered='0', N.OrgQty, N.BDpType, N.BDpId, N.BCltDpId, N.BranchCd, N.PartipantCode, D.SlipNo, D.BatchNo,     
N.ISett_No, N.ISett_Type, N.ShareType, D.TransDate, N.Filler1, N.Filler2, N.Filler3, N.DpType, N.DpId, N.CltDpId, N.Filler4, N.Filler5     
From DelTrans_NBFC N, DelTransPrint_NBFC D  
Where N.ISett_No = D.Sett_No  
And N.ISett_Type = D.Sett_Type  
And N.Party_Code >= D.FromParty        
And N.Party_Code <= D.ToParty        
And N.Party_Code = D.Party_Code    
And N.Scrip_Cd Like '%'        
And N.Series Like '%'        
And N.CertNo = D.CertNo    
And N.TrType = D.TrType    
And N.BDpType = D.BDpType    
And N.BDpId = D.BDpId    
And N.BCltDpId = D.BCltDpId    
And N.DrCr = 'D'     
And N.Delivered = 'G'    
And N.SlipNo = D.SlipNo    
And N.FolioNo = D.FolioNo    
And N.BatchNo = D.BatchNo   
  
End  
Else If @OptFlag = 6
Begin  
  
Update DelTrans_NBFC Set Delivered = 'G', FromNo = D.FolioNo, ToNo = D.FolioNo,   
FolioNo = D.FolioNo, HolderName = D.HolderName, SlipNo = D.SlipNo, BatchNo = D.BatchNo, TransDate = D.TransDate 
From DelTransPrint_NBFC D  
Where DelTrans_NBFC.ISett_No = D.Sett_No  
And DelTrans_NBFC.ISett_Type = D.Sett_Type  
And DelTrans_NBFC.Party_Code >= D.FromParty        
And DelTrans_NBFC.Party_Code <= D.ToParty        
And DelTrans_NBFC.Party_Code = D.Party_Code    
And DelTrans_NBFC.Scrip_Cd Like '%'        
And DelTrans_NBFC.Series Like '%'        
And DelTrans_NBFC.CertNo = D.CertNo    
And DelTrans_NBFC.TrType = D.TrType    
And DelTrans_NBFC.BDpType = D.BDpType    
And DelTrans_NBFC.BDpId = D.BDpId    
And DelTrans_NBFC.BCltDpId = D.BCltDpId  
And DelTrans_NBFC.DrCr = 'D'  
And Delivered = '0'   

Insert Into DelTransTemp_NBFC    
Select N.SNo, N.Sett_No, N.Sett_type, N.RefNo, N.TCode, N.TrType, N.Party_Code, N.scrip_cd, N.series, N.Qty, N.FromNo, N.ToNo, N.CertNo, D.FolioNo,     
D.HolderName, N.Reason, DrCr = 'D', Delivered='D', N.OrgQty, N.DpType, N.DpId, N.CltDpId, N.BranchCd, N.PartipantCode, D.SlipNo, D.BatchNo,     
N.ISett_No, N.ISett_Type, N.ShareType, D.TransDate, N.Filler1, N.Filler2, N.Filler3, N.BDpType, N.BDpId, N.BCltDpId, N.Filler4, N.Filler5     
From DelTrans_NBFC N, DelTransPrint_NBFC D  
Where N.ISett_No = D.Sett_No  
And N.ISett_Type = D.Sett_Type  
And N.Party_Code >= D.FromParty        
And N.Party_Code <= D.ToParty        
And N.Party_Code = D.Party_Code    
And N.Scrip_Cd Like '%'        
And N.Series Like '%'        
And N.CertNo = D.CertNo    
And N.TrType = D.TrType    
And N.BDpType = D.BDpType    
And N.BDpId = D.BDpId    
And N.BCltDpId = D.BCltDpId    
And N.DrCr = 'D'     
And N.Delivered = 'G'    
And N.SlipNo = D.SlipNo    
And N.FolioNo = D.FolioNo    
And N.BatchNo = D.BatchNo    
  
End

GO
