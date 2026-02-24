-- Object: PROCEDURE dbo.InsDematTransInsert
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE proc InsDematTransInsert (              
 @TCode Int,               
 @RefNo Int )               
As               
       
Update DelCode set TCode = @TCode Where RefNo = @RefNo              
          
Delete from DematTransSpeed where sno in (select Sno From Speed_Temp)          
/* Till HERE */          
              
Delete DematTransSpeed From DematTrans DT           
Where DematTransSpeed.Sett_No = DT.Sett_No          
And DematTransSpeed.IsIn = DT.IsIn                 
--and DematTransSpeed.TrDate Like DT.TrDate             
and DematTransSpeed.DrCr = Dt.DrCr             
And DT.BDpType = 'NSDL'             
And DT.BCltAccNo = DematTransSpeed.BCltAccNo                 
And DematTransSpeed.TransNo = Dt.TransNo                 
              
Delete DematTransSpeed From DematTransOut DT           
Where DematTransSpeed.Sett_No = DT.Sett_No          
And DematTransSpeed.IsIn = DT.IsIn                 
--and DematTransSpeed.TrDate Like DT.TrDate             
and DematTransSpeed.DrCr = Dt.DrCr             
And DT.BDpType = 'NSDL'             
And DT.BCltAccNo = DematTransSpeed.BCltAccNo                 
And DematTransSpeed.TransNo = Dt.TransNo                 
              
insert into DematTrans( Sett_No, Sett_Type,RefNo,TCode,TrType,Party_Code,Scrip_Cd,Series,Qty,              
TrDate,CltAccNo,DpId,DpName,IsIn,Branch_Cd,PartiPantCode,DpType,TransNo,               
DrCr , BDpType, BDpId, BCltAccNo, Filler1, Filler2, Filler3, Filler4, Filler5 )              
Select Sett_No, Sett_Type,RefNo,TCode,TrType,Party_Code,Scrip_Cd,Series,Qty,               
TrDate,CltAccNo,DpId,DpName,IsIn,Branch_Cd,PartiPantCode,DpType,TransNo,               
DrCr , BDpType, BDpId, BCltAccNo, Filler1, Filler2, Filler3, Filler4, Filler5 From DematTransSpeed               
              
update DematTrans set Series = ( Case when @RefNo = 110 then 'EQ' else 'BSE' End )               
              
update DematTrans set scrip_cd = s2.scrip_cd,Series = D.Series               
from multiisin s2 ,DematTrans  d Where s2.isin = d.isin               
              
If @RefNo = 120               
Begin              
      Update DematTrans Set Sett_Type = D.Sett_Type From DeliveryClt D               
        Where D.Sett_No = DematTrans.Sett_No And D.Scrip_Cd = DematTrans.Scrip_Cd And D.Sett_Type = 'C'               
        And D.Sett_No >= '2004164' And DematTrans.Sett_Type = 'D'               
            
      Update DematTrans Set Sett_Type = D.Sett_Type From DeliveryClt D               
        Where D.Sett_No = DematTrans.Sett_No And D.Scrip_Cd = DematTrans.Scrip_Cd And D.Sett_Type = 'D'            
        And D.Sett_No >= '2004164' And DematTrans.Sett_Type = 'C'            
End              
              
Update DematTrans Set CltAccNo = RTrim(IsNull((Select Left(Sett_No + '                ',16) From DematTrans D Where               
D.TransNo = DematTrans.TransNo And              
D.TrType = 907 And D.DrCr = 'D'),CltAccNo))              
Where TrType = 907 And DrCr = 'C'              
                 
Update DematTrans Set DpId = RTrim(IsNull((Select Left(Sett_Type + '                ',8) From DematTrans D               
Where D.TransNo = DematTrans.TransNo And              
D.TrType = 907 And D.DrCr = 'D'),DpId))              
Where TrType = 907 And DrCr = 'C'          
              
update DematTrans set               
party_code = (Case When @RefNo = 120               
                              Then 'BSE'               
                              Else 'NSE'               
                     End)               
Where TrType = 906               
                
Insert Into DematTransOut Select Sett_No,Sett_Type,RefNo,TCode,TrType,Party_Code,Scrip_Cd,Series,Qty,TrDate,CltAccNo,DpId,DpName,IsIn,Branch_Cd,              
PartiPantCode,DpType,TransNo,DrCr,BDpType,BDpId,BCltAccNo,Filler1,Filler2,Filler3,Filler4,Filler5              
from DematTrans Where DrCr = 'D' And TrType = 906               
                  
Delete from DematTrans Where DrCr = 'D'              
              
truncate table Speed_Temp

GO
