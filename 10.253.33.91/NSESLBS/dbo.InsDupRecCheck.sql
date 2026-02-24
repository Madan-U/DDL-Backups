-- Object: PROCEDURE dbo.InsDupRecCheck
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc InsDupRecCheck as     
    
Delete from DematTransSpeed Where Transno in (    
Select Transno from DematTrans Where DematTrans.IsIn = DematTransSpeed.Isin   
And Sett_no = DematTransSpeed.Sett_No 
And Left(Convert(Varchar,DematTrans.TrDate,109),11) = Left(Convert(Varchar,DematTransSpeed.TrDate,109),11))
     
Delete from DematTransSpeed Where Transno in (    
Select FromNo from DelTrans Where Filler2 = 1 AND DRCR = 'C'     
And DelTrans.CertNo = DematTransSpeed.Isin   
And Sett_no = DematTransSpeed.Sett_No 
And Left(Convert(Varchar,DelTrans.TransDate,109),11) = Left(Convert(Varchar,DematTransSpeed.TrDate,109),11) )
     
insert into DematTrans (Sett_No,Sett_Type,RefNo,TCode,TrType,Party_Code,Scrip_Cd,Series,Qty,TrDate,CltAccNo,
DpId,DpName,IsIn,Branch_Cd,PartiPantCode,DpType,TransNo,DrCr,BDpType,BDpId,BCltAccNo,Filler1,Filler2,
Filler3,Filler4,Filler5)    
Select Sett_No,Sett_Type,RefNo,TCode,TrType,Party_Code,Scrip_Cd,Series,Qty,TrDate,CltAccNo,DpId,DpName,
IsIn,Branch_Cd,PartiPantCode,DpType,TransNo,DrCr,BDpType,BDpId,BCltAccNo,Filler1,Filler2,Filler3,TrDate,Filler5
from DematTransSpeed

GO
