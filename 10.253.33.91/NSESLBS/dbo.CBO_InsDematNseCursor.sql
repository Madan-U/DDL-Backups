-- Object: PROCEDURE dbo.CBO_InsDematNseCursor
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc CBO_InsDematNseCursor ( @RefNo int) As  
  
Insert Into DelTrans  
Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,D.scrip_cd,D.series,Qty,TransNo,TransNo,D.IsIn,TransNo,'',  
'Pay-Out','C','0',Qty,DpType,DpId,CltAccNo,Branch_Cd,PartipantCode,0,'','','','DEMAT',  
TrDate,Filler1,1,Filler3,BDpType,BDpId,BCltAccNo,filler4,filler5  
From DematTrans D Where TrType = 906 And DrCr = 'C'   
AND D.SCRIP_CD IN ( SELECT DISTINCT SCRIP_CD FROM DELIVERYCLT DE   
                       WHERE DE.Sett_No = D.Sett_No And DE.Sett_Type = D.Sett_Type  
        And DE.SCRIP_CD = D.SCRIP_CD AND DE.SERIES = D.SERIES )     
AND IsIn IN ( Select IsIn From MultiIsIn Where Scrip_cd = D.Scrip_cd And Series = D.Series    
And IsIn = D.IsIn And Valid = 1 )   
  
Insert Into DelTrans  
Select Sett_No,Sett_type,RefNo,TCode,904,'BROKER',D.scrip_cd,D.series,Qty,TransNo,TransNo,D.IsIn,TransNo,'',  
'Pay-Out','D','0',Qty,DpType,DpId,CltAccNo,Branch_Cd,PartipantCode,0,'','','','DEMAT',  
TrDate,Filler1,1,Filler3,BDpType,BDpId,BCltAccNo,filler4,filler5  
From DematTrans D Where TrType = 906 And DrCr = 'C'   
AND D.SCRIP_CD IN ( SELECT DISTINCT SCRIP_CD FROM DELIVERYCLT DE   
                       WHERE DE.Sett_No = D.Sett_No And DE.Sett_Type = D.Sett_Type  
        And DE.SCRIP_CD = D.SCRIP_CD AND DE.SERIES = D.SERIES )     
AND IsIn IN ( Select IsIn From MultiIsIn Where Scrip_cd = D.Scrip_cd And Series = D.Series    
And IsIn = D.IsIn And Valid = 1 )   
  
  
Delete from DematTrans Where TrType = 906 And DrCr = 'C'   
AND SCRIP_CD IN ( SELECT DISTINCT SCRIP_CD FROM DELIVERYCLT DE   
                       WHERE DE.Sett_No = Demattrans.Sett_No And DE.Sett_Type = Demattrans.Sett_Type  
        And DE.SCRIP_CD = DematTrans.SCRIP_CD AND DE.SERIES = DematTrans.SERIES )     
AND IsIn IN ( Select IsIn From MultiIsIn Where Scrip_cd = DematTrans.Scrip_cd And Series = DematTrans.Series    
And IsIn = DematTrans.IsIn And Valid = 1 )   
  
Exec InsNseDematOutCursor

GO
