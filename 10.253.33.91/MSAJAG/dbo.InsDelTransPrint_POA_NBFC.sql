-- Object: PROCEDURE dbo.InsDelTransPrint_POA_NBFC
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc InsDelTransPrint_POA_NBFC (@BDpType Varchar(4), @BDpId Varchar(8), @BCltDpID Varchar(16))     
As    

Insert into DelTrans_NBFC
Select N.Sett_No, N.Sett_type, N.RefNo, N.TCode, N.TrType, N.Party_Code, N.scrip_cd, N.series, N.Qty, N.FromNo, N.ToNo, N.CertNo, D.FolioNo, 
D.HolderName, N.Reason, DrCr = 'D', Delivered='G', N.OrgQty, N.DpType, N.DpId, N.CltDpId, N.BranchCd, N.PartipantCode, D.SlipNo, D.BatchNo, 
N.ISett_No, N.ISett_Type, N.ShareType, D.TransDate, N.Filler1, N.Filler2, N.Filler3, N.BDpType, N.BDpId, N.BCltDpId, N.Filler4, N.Filler5 
From DelTrans_NBFC N, DelTransPrint_NBFC D    
Where N.Sett_No = D.Sett_No    
And N.Sett_Type = D.Sett_Type    
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

Insert Into DelTransTemp_NBFC
Select N.SNo, N.Sett_No, N.Sett_type, N.RefNo, N.TCode, N.TrType, N.Party_Code, N.scrip_cd, N.series, N.Qty, N.FromNo, N.ToNo, N.CertNo, D.FolioNo, 
D.HolderName, N.Reason, DrCr = 'D', Delivered='D', N.OrgQty, @BDpType, @BDpId, @BCltDpId, N.BranchCd, N.PartipantCode, D.SlipNo, D.BatchNo, 
N.ISett_No, N.ISett_Type, N.ShareType, D.TransDate, N.Filler1, N.Filler2, N.Filler3, N.BDpType, N.BDpId, N.BCltDpId, N.Filler4, N.Filler5 
From DelTrans_NBFC N, DelTransPrint_NBFC D    
Where N.Sett_No = D.Sett_No    
And N.Sett_Type = D.Sett_Type    
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
D.HolderName, N.Reason, DrCr = 'C', Delivered='0', N.OrgQty, N.BDpType, N.BDpId, N.BCltDpId, N.BranchCd, N.PartipantCode, D.SlipNo, D.BatchNo, 
N.ISett_No, N.ISett_Type, N.ShareType, D.TransDate, N.Filler1, N.Filler2, N.Filler3, @BDpType, @BDpId, @BCltDpId, N.Filler4, N.Filler5 
From DelTrans_NBFC N, DelTransPrint_NBFC D    
Where N.Sett_No = D.Sett_No    
And N.Sett_Type = D.Sett_Type    
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

GO
