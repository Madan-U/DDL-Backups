-- Object: PROCEDURE dbo.UpdateCollateral
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc UpdateCollateral As           

Delete From C_SecuritiesMstDemat       
Where Dp_Acc_Code In ( Select DpCltNo from DeliveryDp Where DpId = BankDpId And DpCltNo = Dp_Acc_Code       
And Description Like '%F & O%' )
      
Delete From C_SecuritiesMstDemat Where B_Dp_Acc_Code not In ( Select DpCltNo from DeliveryDp )          
      
update C_SecuritiesMstDemat set scrip_cd = '', Series = ''        

update C_SecuritiesMstDemat set scrip_cd = s2.scrip_cd,series = s2.series           
from BSEDB.DBO.multiisin s2 Where s2.isin = C_SecuritiesMstDemat.isin And Valid = 1 
and Exchange = 'BCM' and Segment = 'FUTURES'       

update C_SecuritiesMstDemat set scrip_cd = s2.scrip_cd,series = s2.series           
from BSEFOPCM.DBO.multiisin s2 Where s2.isin = C_SecuritiesMstDemat.isin And Valid = 1 
and Exchange = 'BCM' and Segment = 'FUTURES' and C_SecuritiesMstDemat.scrip_cd = '' 

update C_SecuritiesMstDemat set scrip_cd = s2.scrip_cd,series = s2.series       
from multiisin s2 Where s2.isin = C_SecuritiesMstDemat.isin And Valid = 1
and Exchange = 'NCM' and Segment = 'FUTURES'   

update C_SecuritiesMstDemat set scrip_cd = s2.scrip_cd,series = s2.series           
from NSEFOPCM.DBO.multiisin s2 Where s2.isin = C_SecuritiesMstDemat.isin And Valid = 1         
and Exchange = 'NCM' and Segment = 'FUTURES' and C_SecuritiesMstDemat.scrip_cd = ''  

Update C_SecuritiesMstDemat Set Party_Code = M.Party_Code           
From NSEFOPCM.DBO.MultiCltId M Where C_SecuritiesMstDemat.BankDpId = M.DpId           
And C_SecuritiesMstDemat.Dp_Acc_Code = M.CltDpNo           
And Exchange = 'NCM' And Segment = 'FUTURES'          
And M.CltDpNo Not In ( Select M1.CltDpNo From NSEFOPCM.DBO.MultiCltId M1          
Where C_SecuritiesMstDemat.BankDpId = M1.DpId           
And C_SecuritiesMstDemat.Dp_Acc_Code = M1.CltDpNo           
Group By M1.DpId, M1.CltDpNo          
Having Count(1) > 1 )
      
Update C_SecuritiesMstDemat Set Party_Code = M.Party_Code           
From BSEFOPCM.DBO.MultiCltId M Where C_SecuritiesMstDemat.BankDpId = M.DpId           
And C_SecuritiesMstDemat.Dp_Acc_Code = M.CltDpNo           
And Exchange = 'BCM' And Segment = 'FUTURES'          
And M.CltDpNo Not In ( Select M1.CltDpNo From BSEFOPCM.DBO.MultiCltId M1          
Where C_SecuritiesMstDemat.BankDpId = M1.DpId           
And C_SecuritiesMstDemat.Dp_Acc_Code = M1.CltDpNo           
Group By M1.DpId, M1.CltDpNo          
Having Count(1) > 1 )      
          
Insert into C_SecuritiesMst( Exchange,Segment,Company,Party_Code,BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,Scrip_Cd,Series,Qty,DrCr,Trans_Code,EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,TrType,End_Date,Tcode,Remarks,Active,Status,LoginName,LoginTime,TransToExch,Filler11,Filler12,Filler13,Filler14,Filler15 )          
Select Exchange,Segment,Company,Party_Code,BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,Scrip_Cd,Series,Qty,DrCr,Trans_Code,EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,TrType,End_Date,Tcode,Remarks,Active,Status,LoginName,LoginTime,TransToExch,Filler11,Filler12,Filler13,Filler14,Filler15 From C_SecuritiesMstDemat           
Where DrCr = 'C' And Scrip_cd <> ''         
And Party_Code <> 'PARTY'        
        
Insert into C_SecuritiesMst( Exchange,Segment,Company,Party_Code,BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,Scrip_Cd,Series,Qty,DrCr,Trans_Code,EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,TrType,End_Date,Tcode,Remarks,Active,Status,LoginName,LoginTime,TransToExch,Filler11,Filler12,Filler13,Filler14,Filler15 )          
Select Exchange,Segment,Company,Party_Code,BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,Scrip_Cd,Series,Qty,DrCr,Trans_Code,EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,0,End_Date,Tcode,Remarks,Active,'Release',LoginName,LoginTime,TransToExch,Filler11,Filler12,Filler13,Filler14,Filler15 From C_SecuritiesMstDemat           
Where DrCr = 'D' And Scrip_cd <> ''         
And Party_Code <> 'PARTY'          
        
Delete From C_SecuritiesMstDemat           
Where Scrip_cd <> ''         
And Party_Code <> 'PARTY'

GO
