-- Object: PROCEDURE dbo.C_CollScripChange
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc C_CollScripChange  
(@DpId Varchar(8),  
 @CltDpId Varchar(16),  
 @Exchange Varchar(3),  
 @Segment Varchar(7),  
 @EffDate Varchar(11),   
 @OldScrip Varchar(12),  
 @NewScrip Varchar(12),  
 @Remark Varchar(30) )  
As  
Insert into C_SecuritiesMst  
Select Exchange,Segment,Company,Party_Code,'','','',Inst_Type,Isin,  
@NewScrip,Series,abs(Sum(Case When DrCr = 'C' Then Qty Else -Qty End)),
drcr = (case when Sum(Case When DrCr = 'C' Then Qty Else -Qty End) > 0 then 'C' else 'D' end), 
1,@EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,1,  
GetDate(),1,@Remark,1,'','',GetDate(),'N','Party','',  
'','','' from C_SecuritiesMst  
Where Exchange = @Exchange  
And Segment = @Segment  
And B_BankDpId = @DpId   
And B_Dp_Acc_Code = @CltDpId  
And Scrip_CD = @OldScrip  
And Filler12 = ''  
And Party_Code <> 'BROKER'  
And EffDate <= @EffDate + ' 23:59:59'  
Group by Exchange,Segment,Company,Party_Code, Inst_Type,Isin,Scrip_Cd, Series,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type  
Having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) <> 0  
  
Insert into C_SecuritiesMst  
Select Exchange,Segment,Company,Party_Code,'','','',Inst_Type,Isin,  
@OldScrip,Series,abs(Sum(Case When DrCr = 'C' Then Qty Else -Qty End)),
drcr = (case when Sum(Case When DrCr = 'C' Then Qty Else -Qty End) > 0 then 'D' else 'C' end), 
1,@EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,1,  
GetDate(),1,@Remark,1,'','',GetDate(),'N','Party','',  
'','','' from C_SecuritiesMst  
Where Exchange = @Exchange  
And Segment = @Segment  
And B_BankDpId = @DpId   
And B_Dp_Acc_Code = @CltDpId  
And Scrip_CD = @OldScrip  
And Filler12 = ''  
And Party_Code <> 'BROKER'  
And EffDate <= @EffDate + ' 23:59:59'  
Group by Exchange,Segment,Company,Party_Code, Inst_Type,Isin,Scrip_Cd, Series,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type  
Having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) <> 0  
  
Insert into C_SecuritiesMst  
Select Exchange,Segment,Company,Party_Code,BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,  
@NewScrip,Series,abs(Sum(Case When DrCr = 'C' Then Qty Else -Qty End)),
drcr = (case when Sum(Case When DrCr = 'C' Then Qty Else -Qty End) > 0 then 'C' else 'D' end), 
1,@EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,1,  
GetDate(),1,@Remark,1,'','',GetDate(),'N','Party',1,  
'','','' from C_SecuritiesMst  
Where Exchange = @Exchange  
And Segment = @Segment  
And B_BankDpId = @DpId   
And B_Dp_Acc_Code = @CltDpId  
And Scrip_CD = @OldScrip  
And Filler12 <> ''  
And Party_Code <> 'BROKER'  
And EffDate <= @EffDate + ' 23:59:59'  
Group by Exchange,Segment,Company,Party_Code, Inst_Type,Isin,Scrip_Cd, Series,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,  BankDpId,Dp_Acc_Code,Dp_Type 
Having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) <> 0  
  
Insert into C_SecuritiesMst  
Select Exchange,Segment,Company,Party_Code,BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,  
@OldScrip,Series,abs(Sum(Case When DrCr = 'C' Then Qty Else -Qty End)),
drcr = (case when Sum(Case When DrCr = 'C' Then Qty Else -Qty End) > 0 then 'D' else 'C' end), 
1,@EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,1,  
GetDate(),1,@Remark,1,'','',GetDate(),'N','Party',1,  
'','','' from C_SecuritiesMst  
Where Exchange = @Exchange  
And Segment = @Segment  
And B_BankDpId = @DpId   
And B_Dp_Acc_Code = @CltDpId  
And Scrip_CD = @OldScrip  
And Filler12 <> ''  
And Party_Code <> 'BROKER'  
And EffDate <= @EffDate + ' 23:59:59'  
Group by Exchange,Segment,Company,Party_Code, Inst_Type,Isin,Scrip_Cd, Series,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type, BankDpId,Dp_Acc_Code,Dp_Type 
Having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) <> 0  
  
  
Update C_SecuritiesMst Set BankDpId = BankId, Dp_Acc_Code=CltDpId, Dp_Type=Depository From Client4   
Where C_SecuritiesMst.Party_Code = Client4.Party_Code And DefDp = 1 And Depository In ('NSDL', 'CDSL') And BankDpId = ''  
And Scrip_Cd in (@OldScrip, @NewScrip)

GO
