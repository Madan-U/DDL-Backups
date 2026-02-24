-- Object: PROCEDURE dbo.NBFC_InsDelTransPrintBen
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc NBFC_InsDelTransPrintBen (@OptFlag Int, @BDpType Varchar(4), @BDpId Varchar(8), @BCltDpID Varchar(16), @isett_no varchar(7), @isett_type varchar(2))
As                  
   
       
If @OptFlag = 4                  
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
And DelTrans.DpId = D.DpId                  
And DelTrans.CltDpId = D.CltDpId 
And deltrans.TrType = 1000
And deltrans.ISett_no = @ISett_No
And deltrans.ISett_Type = @ISett_Type                 
And OptionFlag = 4                  
And D.Qty = NewQty                  
                  
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
And deltrans.TrType = 1000
And deltrans.ISett_no = @ISett_No
And deltrans.ISett_Type = @ISett_Type         
And DelTrans.SlipNo = D.SlipNo                
And DelTrans.BatchNo = D.BatchNo        
end

GO
