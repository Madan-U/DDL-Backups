-- Object: PROCEDURE dbo.UpdateCollateral_HDFC
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Proc UpdateCollateral_HDFC As   

update C_SecuritiesMstDemat set scrip_cd = s2.scrip_cd, series = s2.series   
from NSEFO.DBO.MULTIISIN s2 Where s2.isin = C_SecuritiesMstDemat.isin   

Update C_SecuritiesMstDemat Set BankDpId = M.DpId   
From MultiCltId M Where C_SecuritiesMstDemat.BankDpId = ''
And C_SecuritiesMstDemat.Dp_Acc_Code = M.CltDpNo   
And Exchange = 'NSE' And Segment = 'CAPITAL'  
And M.CltDpNo Not In ( Select M1.CltDpNo From MultiCltId M1  
Where C_SecuritiesMstDemat.Dp_Acc_Code = M1.CltDpNo   
Group By M1.CltDpNo  
Having Count(1) > 1 )  
And C_SecuritiesMstDemat.Party_Code = 'PARTY'

Update C_SecuritiesMstDemat Set BankDpId = M.DpId   
From NSEFO.DBO.MultiCltId M Where C_SecuritiesMstDemat.BankDpId = ''
And C_SecuritiesMstDemat.Dp_Acc_Code = M.CltDpNo   
And Exchange = 'NSE' And Segment = 'FUTURES'  
And M.CltDpNo Not In ( Select M1.CltDpNo From NSEFO.DBO.MultiCltId M1  
Where C_SecuritiesMstDemat.Dp_Acc_Code = M1.CltDpNo   
Group By M1.CltDpNo  
Having Count(1) > 1 )  
And C_SecuritiesMstDemat.Party_Code = 'PARTY'

Update C_SecuritiesMstDemat Set Party_Code = M.Party_Code   
From MultiCltId M Where C_SecuritiesMstDemat.BankDpId = M.DpId   
And C_SecuritiesMstDemat.Dp_Acc_Code = M.CltDpNo   
And Exchange = 'NSE' And Segment = 'CAPITAL'  
And M.CltDpNo Not In ( Select M1.CltDpNo From MultiCltId M1  
Where C_SecuritiesMstDemat.BankDpId = M1.DpId   
And C_SecuritiesMstDemat.Dp_Acc_Code = M1.CltDpNo   
Group By M1.DpId, M1.CltDpNo  
Having Count(1) > 1 )  
And C_SecuritiesMstDemat.Party_Code = 'PARTY'
  
Update C_SecuritiesMstDemat Set Party_Code = M.Party_Code   
From NSEFO.DBO.MultiCltId M Where C_SecuritiesMstDemat.BankDpId = M.DpId   
And C_SecuritiesMstDemat.Dp_Acc_Code = M.CltDpNo   
And Exchange = 'NSE' And Segment = 'FUTURES'  
And M.CltDpNo Not In ( Select M1.CltDpNo From NSEFO.DBO.MultiCltId M1  
Where C_SecuritiesMstDemat.BankDpId = M1.DpId   
And C_SecuritiesMstDemat.Dp_Acc_Code = M1.CltDpNo   
Group By M1.DpId, M1.CltDpNo  
Having Count(1) > 1 )  
And C_SecuritiesMstDemat.Party_Code = 'PARTY'
  
Insert into C_SecuritiesMst( Exchange,Segment,Company,Party_Code,BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,Scrip_Cd,Series,
Qty,DrCr,Trans_Code,EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,TrType,End_Date,Tcode,Remarks,Active,Status,
LoginName,LoginTime,TransToExch,Filler11,Filler12,Filler13,Filler14,Filler15 )  
Select Exchange,Segment,Company,Party_Code,BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,Scrip_Cd,Series,Qty,DrCr,Trans_Code,
EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,TrType,End_Date,Tcode,Remarks,Active,Status,LoginName,LoginTime,TransToExch,
Filler11,Filler12,Filler13,Filler14,Filler15 From C_SecuritiesMstDemat   
Where DrCr = 'C' And IsIn In (Select IsIn From NSEFO.DBO.MULTIISIN where NSEFO.DBO.MULTIISIN.IsIn = C_SecuritiesMstDemat.IsIn And Valid = 1 )  
And Party_Code <> 'PARTY'  
  
Insert into C_SecuritiesMst( Exchange,Segment,Company,Party_Code,BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,Scrip_Cd,Series,
Qty,DrCr,Trans_Code,EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,TrType,End_Date,Tcode,Remarks,Active,Status,
LoginName,LoginTime,TransToExch,Filler11,Filler12,Filler13,Filler14,Filler15 )  
Select Exchange,Segment,Company,'Broker',BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,Scrip_Cd,Series,Qty,'D',Trans_Code,
EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,TrType,End_Date,Tcode,Remarks,Active,Status,LoginName,LoginTime,TransToExch,
'Broker',Filler12,Filler13,Filler14,Filler15 From C_SecuritiesMstDemat   
Where DrCr = 'C' And IsIn In (Select IsIn From NSEFO.DBO.MULTIISIN where NSEFO.DBO.MULTIISIN.IsIn = C_SecuritiesMstDemat.IsIn And Valid = 1 )  
And Party_Code <> 'PARTY'  
  
Insert into C_SecuritiesMst( Exchange,Segment,Company,Party_Code,BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,Scrip_Cd,Series,
Qty,DrCr,Trans_Code,EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,TrType,End_Date,Tcode,Remarks,Active,Status,
LoginName,LoginTime,TransToExch,Filler11,Filler12,Filler13,Filler14,Filler15 )  
Select Exchange,Segment,Company,Party_Code,BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,Scrip_Cd,Series,Qty,DrCr,Trans_Code,
EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,0,End_Date,Tcode,Remarks,Active,'Release',LoginName,LoginTime,TransToExch,
Filler11,Filler12,Filler13,Filler14,Filler15 From C_SecuritiesMstDemat   
Where DrCr = 'D' And IsIn In (Select IsIn From NSEFO.DBO.MULTIISIN where NSEFO.DBO.MULTIISIN.IsIn = C_SecuritiesMstDemat.IsIn And Valid = 1 )  
And Party_Code <> 'PARTY'  
  
Insert into C_SecuritiesMst( Exchange,Segment,Company,Party_Code,BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,Scrip_Cd,Series,
Qty,DrCr,Trans_Code,EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,TrType,End_Date,Tcode,Remarks,Active,Status,
LoginName,LoginTime,TransToExch,Filler11,Filler12,Filler13,Filler14,Filler15 )  
Select Exchange,Segment,Company,'Broker',BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,Scrip_Cd,Series,Qty,'C',Trans_Code,
EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,0,End_Date,Tcode,Remarks,Active,'Release',LoginName,LoginTime,TransToExch,
'Broker',Filler12,Filler13,Filler14,Filler15 From C_SecuritiesMstDemat   
Where DrCr = 'D' And IsIn In (Select IsIn From NSEFO.DBO.MULTIISIN where NSEFO.DBO.MULTIISIN.IsIn = C_SecuritiesMstDemat.IsIn And Valid = 1 )  
And Party_Code <> 'PARTY'  
  
Delete From C_SecuritiesMstDemat   
Where IsIn In (Select IsIn From NSEFO.DBO.MULTIISIN where NSEFO.DBO.MULTIISIN.IsIn = C_SecuritiesMstDemat.IsIn And Valid = 1 )  
And Party_Code <> 'PARTY'

GO
