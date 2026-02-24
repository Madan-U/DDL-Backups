-- Object: PROCEDURE dbo.C_CollDpChange
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc C_CollDpChange
(
 @Exchange Varchar(3),
 @Segment Varchar(7),
 @FromDpId Varchar(8),
 @FromCltDpId Varchar(16),
 @EffDate Varchar(11), 
 @ToDpId Varchar(8),
 @ToCltDpId Varchar(16),
 @Remark Varchar(30) )
As
Insert into C_SecuritiesMst
Select Exchange,Segment,Company,Party_Code,'','','',Inst_Type,Isin,
Scrip_Cd,Series,Sum(Case When DrCr = 'C' Then Qty Else -Qty End),'C', 1,@EffDate,
@ToDpId,@ToCltDpId,B_Dp_Type=(Case When Len(@ToCltDpId) = 8 Then 'NSDL' Else 'CDSL' End),1,
GetDate(),1,@Remark,1,'','',GetDate(),'N','Party','',
'','','' from C_SecuritiesMst
Where Exchange = @Exchange
And Segment = @Segment
And B_BankDpId = @FromDpId 
And B_Dp_Acc_Code = @FromCltDpId
And Filler12 = ''
And Party_Code <> 'BROKER'
And EffDate <= @EffDate + ' 23:59:59'
Group by Exchange,Segment,Company,Party_Code, Inst_Type,Isin,Scrip_Cd, Series,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type
Having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) > 0

Insert into C_SecuritiesMst
Select Exchange,Segment,Company,Party_Code,'','','',Inst_Type,Isin,
Scrip_Cd,Series,Sum(Case When DrCr = 'C' Then Qty Else -Qty End),'D', 1,@EffDate,
@FromDpId,@FromCltDpId,B_Dp_Type=(Case When Len(@FromCltDpId) = 8 Then 'NSDL' Else 'CDSL' End),1,
GetDate(),1,@Remark,1,'','',GetDate(),'N','Party','',
'','','' from C_SecuritiesMst
Where Exchange = @Exchange
And Segment = @Segment
And B_BankDpId = @FromDpId 
And B_Dp_Acc_Code = @FromCltDpId
And Filler12 = ''
And Party_Code <> 'BROKER'
And EffDate <= @EffDate + ' 23:59:59'
Group by Exchange,Segment,Company,Party_Code, Inst_Type,Isin,Scrip_Cd, Series,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type
Having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) > 0

Insert into C_SecuritiesMst
Select Exchange,Segment,Company,Party_Code,BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,
Scrip_Cd,Series,Sum(Case When DrCr = 'C' Then Qty Else -Qty End),'C', 1,@EffDate,
@ToDpId,@ToCltDpId,B_Dp_Type=(Case When Len(@ToCltDpId) = 8 Then 'NSDL' Else 'CDSL' End),1,
GetDate(),1,@Remark,1,'','',GetDate(),'N','Party',1,
'','','' from C_SecuritiesMst
Where Exchange = @Exchange
And Segment = @Segment
And B_BankDpId = @FromDpId 
And B_Dp_Acc_Code = @FromCltDpId
And Filler12 <> ''
And Party_Code <> 'BROKER'
And EffDate <= @EffDate + ' 23:59:59'
Group by Exchange,Segment,Company,Party_Code, Inst_Type,Isin,Scrip_Cd, Series,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type, BankDpId,Dp_Acc_Code,Dp_Type 
Having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) > 0

Insert into C_SecuritiesMst
Select Exchange,Segment,Company,Party_Code,BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,
Scrip_Cd,Series,Sum(Case When DrCr = 'C' Then Qty Else -Qty End),'D', 1,@EffDate,
@FromDpId,@FromCltDpId,B_Dp_Type=(Case When Len(@FromCltDpId) = 8 Then 'NSDL' Else 'CDSL' End),1,
GetDate(),1,@Remark,1,'','',GetDate(),'N','Party',1,
'','','' from C_SecuritiesMst
Where Exchange = @Exchange
And Segment = @Segment
And B_BankDpId = @FromDpId 
And B_Dp_Acc_Code = @FromCltDpId
And Filler12 <> ''
And Party_Code <> 'BROKER'
And EffDate <= @EffDate + ' 23:59:59'
Group by Exchange,Segment,Company,Party_Code, Inst_Type,Isin,Scrip_Cd, Series,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type, BankDpId,Dp_Acc_Code,Dp_Type 
Having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) > 0

Update C_SecuritiesMst Set BankDpId = BankId, Dp_Acc_Code=CltDpId, Dp_Type=Depository From Client4 
Where C_SecuritiesMst.Party_Code = Client4.Party_Code And DefDp = 1 And Depository In ('NSDL', 'CDSL') And BankDpId = ''
And B_Dp_Acc_Code in (@FromCltDpId, @ToCltDpId)

GO
