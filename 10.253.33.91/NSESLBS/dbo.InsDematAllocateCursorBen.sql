-- Object: PROCEDURE dbo.InsDematAllocateCursorBen
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE  Proc InsDematAllocateCursorBen (@RefNo int) As       
      
Delete From DematTransBen Where CltAccNo = ''
      
Update DematTransBen Set DpId = Left(CltAccNo,8) where Len(CltAccNo) = 16      
And DpId <> Left(CltAccNo,8)      
      
Update DematTransBen Set DpName = '' where DpName Is Null      
      
Update DematTransBen set scrip_cd = s2.scrip_cd,Series = s2.Series       
from multiisin s2 Where s2.isin = DematTransBen.isin And Valid = 1       

Update DematTransBen Set Sett_no = '2000000', 
Sett_Type = (Case When RefNo = 110 
		  then 'N' 	
		  Else 'D' 
	     End)
      
Delete From DematTransBen      
Where CltAccNo In ( Select DpCltNo From MSAJAG.DBO.DeliveryDp M      
Where M.DpId = DematTransBen.DpId And DpCltNo = CltAccNo )  
  
Delete From DematTransBen      
Where CltAccNo In ( Select DpCltNo From BSEDB.DBO.DeliveryDp M      
Where M.DpId = DematTransBen.DpId And DpCltNo = CltAccNo )  
    
Delete From DematTransBen      
Where BCltAccNo In ( Select DpCltNo From MSAJAG.DBO.DeliveryDp M      
Where M.DpId = DematTransBen.BDpId And DpCltNo = BCltAccNo And Description like '%POOL%' )      
      
Delete From DematTransBen      
Where BCltAccNo In ( Select DpCltNo From BSEDB.DBO.DeliveryDp M      
Where M.DpId = DematTransBen.BDpId And DpCltNo = BCltAccNo And Description like '%POOL%' )      
      
Delete From DematTransBen      
Where BCltAccNo not In ( Select DpCltNo From MSAJAG.DBO.DeliveryDp M      
Where M.DpId = DematTransBen.BDpId And DpCltNo = BCltAccNo)      

Delete From DematTransBen      
Where BCltAccNo In ( Select DpCltNo From MSAJAG.DBO.DeliveryDp M      
Where M.DpId = DematTransBen.BDpId And DpCltNo = BCltAccNo And Exchange = (Case when RefNo = 110 Then 'BSE' Else 'NSE' End))

Delete From DematTransBen      
Where BCltAccNo not In ( Select DpCltNo From BSEDB.DBO.DeliveryDp M      
Where M.DpId = DematTransBen.BDpId And DpCltNo = BCltAccNo)      
      
Update DematTransBen Set Party_Code = M.Party_Code      
From MultiCltID M Where M.DpId = DematTransBen.DpID      
And M.CltDpNo = CltAccNo       
      
Insert Into DelTrans      
Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,TransNo,TransNo,IsIn,      
TransNo,'OFF MARKET','OFF MARKET','C','0',Qty,DpType,DpId,CltAccNo,Branch_Cd,PartipantCode,      
'0','0','','','DEMAT',TrDate,Filler1,1,'',      
BDpType,BDpId,BCltAccNo,Filler4,Filler5 From DematTransBen D      
WHERE PARTY_CODE <> 'Party' and drcr = 'C'      
AND ISIN IN (SELECT ISIN FROM MULTIISIN M       
      WHERE M.ISIN = D.ISIN AND M.VALID = 1       
      AND M.SCRIP_CD = D.SCRIP_CD AND M.SERIES = D.SERIES )      
      
Insert Into DelTrans      
Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,TransNo,TransNo,IsIn,      
TransNo,'OFF MARKET','OFF MARKET','D','0',Qty,DpType,DpId,CltAccNo,Branch_Cd,PartipantCode,      
'0','0','','','DEMAT',TrDate,Filler1,1,'',      
BDpType,BDpId,BCltAccNo,Filler4,Filler5 From DematTransBen D      
WHERE PARTY_CODE <> 'Party' and drcr = 'C'      
AND ISIN IN (SELECT ISIN FROM MULTIISIN M       
      WHERE M.ISIN = D.ISIN AND M.VALID = 1       
      AND M.SCRIP_CD = D.SCRIP_CD AND M.SERIES = D.SERIES )      
      
Delete From DematTransBen      
WHERE PARTY_CODE <> 'Party'      
AND ISIN IN (SELECT ISIN FROM MULTIISIN M       
      WHERE M.ISIN = DematTransBen.ISIN AND M.VALID = 1       
      AND M.SCRIP_CD = DematTransBen.SCRIP_CD AND M.SERIES = DematTransBen.SERIES )

GO
