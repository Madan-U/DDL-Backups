-- Object: PROCEDURE dbo.C_CollPartyChange
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Proc C_CollPartyChange  
(@DpId Varchar(8),  
 @CltDpId Varchar(16),  
 @Exchange Varchar(3),  
 @Segment Varchar(7),  
 @EffDate Varchar(11),   
 @OldParty Varchar(12),  
 @NewParty Varchar(12),
 @Scrip_Cd Varchar(12),
 @Remark Varchar(30) )  
As  

Set @Scrip_Cd = (Case When Len(@Scrip_Cd) = 0 
	     Then '%' 
	     Else @Scrip_Cd
	End)

Insert into C_SecuritiesMst  
Select Exchange,Segment,Company,@NewParty,'','','',Inst_Type,Isin,  
Scrip_Cd,Series,Sum(Case When DrCr = 'C' Then Qty Else -Qty End),'C', 1,@EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,1,  
GetDate(),1,@Remark,1,'','',GetDate(),'N','Party','',  
'','','' from C_SecuritiesMst  
Where Exchange = @Exchange  
And Segment = @Segment  
And B_BankDpId = @DpId   
And B_Dp_Acc_Code = @CltDpId  
And Party_Code = @OldParty  
And Scrip_Cd Like @Scrip_Cd
And Filler12 = ''  
And Party_Code <> 'BROKER'  
And EffDate <= @EffDate + ' 23:59:59'  
Group by Exchange,Segment,Company,Party_Code, Inst_Type,Isin,Scrip_Cd, Series,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type  
Having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) > 0  
  
Insert into C_SecuritiesMst  
Select Exchange,Segment,Company,@OldParty,'','','',Inst_Type,Isin,  
Scrip_Cd,Series,Sum(Case When DrCr = 'C' Then Qty Else -Qty End),'D', 1,@EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,1,  
GetDate(),1,@Remark,1,'','',GetDate(),'N','Party','',  
'','','' from C_SecuritiesMst  
Where Exchange = @Exchange  
And Segment = @Segment  
And B_BankDpId = @DpId   
And B_Dp_Acc_Code = @CltDpId  
And Party_Code = @OldParty  
And Scrip_Cd Like @Scrip_Cd
And Filler12 = ''  
And Party_Code <> 'BROKER'  
And EffDate <= @EffDate + ' 23:59:59'  
Group by Exchange,Segment,Company,Party_Code, Inst_Type,Isin,Scrip_Cd, Series,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type  
Having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) > 0  
  
Insert into C_SecuritiesMst  
Select Exchange,Segment,Company,@NewParty,BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,  
Scrip_Cd,Series,Sum(Case When DrCr = 'C' Then Qty Else -Qty End),'C', 1,@EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,1,  
GetDate(),1,@Remark,1,'','',GetDate(),'N','Party',1,  
'','','' from C_SecuritiesMst  
Where Exchange = @Exchange  
And Segment = @Segment  
And B_BankDpId = @DpId   
And B_Dp_Acc_Code = @CltDpId  
And Party_Code = @OldParty  
And Scrip_Cd Like @Scrip_Cd
And Filler12 <> ''  
And Party_Code <> 'BROKER'  
And EffDate <= @EffDate + ' 23:59:59'  
Group by Exchange,Segment,Company,Party_Code, Inst_Type,Isin,Scrip_Cd, Series,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,  BankDpId,Dp_Acc_Code,Dp_Type Having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) > 0  
  
Insert into C_SecuritiesMst  
Select Exchange,Segment,Company,@OldParty,BankDpId,Dp_Acc_Code,Dp_Type,Inst_Type,Isin,  
Scrip_Cd,Series,Sum(Case When DrCr = 'C' Then Qty Else -Qty End),'D', 1,@EffDate,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type,1,  
GetDate(),1,@Remark,1,'','',GetDate(),'N','Party',1,  
'','','' from C_SecuritiesMst  
Where Exchange = @Exchange  
And Segment = @Segment  
And B_BankDpId = @DpId   
And B_Dp_Acc_Code = @CltDpId  
And Party_Code = @OldParty  
And Scrip_Cd Like @Scrip_Cd
And Filler12 <> ''  
And Party_Code <> 'BROKER'  
And EffDate <= @EffDate + ' 23:59:59'  
Group by Exchange,Segment,Company,Party_Code, Inst_Type,Isin,Scrip_Cd, Series,B_BankDpId,B_Dp_Acc_Code,B_Dp_Type, BankDpId,Dp_Acc_Code,Dp_Type Having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) > 0  

If @Exchange = 'NSE' And @Segment = 'FUTURES'
Begin 	
	Update C_SecuritiesMst Set BankDpId = BankId, Dp_Acc_Code=CltDpId, Dp_Type=Depository From NSEFO.DBO.Client4 Client4
	Where C_SecuritiesMst.Party_Code = Client4.Party_Code And DefDp = 1 And Depository In ('NSDL', 'CDSL') And BankDpId = ''  
	And C_SecuritiesMst.Party_Code in (@OldParty, @NewParty)  
	And Scrip_Cd Like @Scrip_Cd

	Update C_SecuritiesMst Set BankDpId = DpId, Dp_Acc_Code=CltDpNo, Dp_Type=DpType From NSEFO.DBO.MultiCltId MultiCltId
	Where C_SecuritiesMst.Party_Code = MultiCltId.Party_Code And DpType In ('NSDL', 'CDSL') And BankDpId = ''  
	And C_SecuritiesMst.Party_Code in (@OldParty, @NewParty)  
	And Scrip_Cd Like @Scrip_Cd
End
Else
Begin
	Update C_SecuritiesMst Set BankDpId = BankId, Dp_Acc_Code=CltDpId, Dp_Type=Depository From Client4
	Where C_SecuritiesMst.Party_Code = Client4.Party_Code And DefDp = 1 And Depository In ('NSDL', 'CDSL') And BankDpId = ''  
	And C_SecuritiesMst.Party_Code in (@OldParty, @NewParty)  
	And Scrip_Cd Like @Scrip_Cd

	Update C_SecuritiesMst Set BankDpId = DpId, Dp_Acc_Code=CltDpNo, Dp_Type=DpType From MultiCltId
	Where C_SecuritiesMst.Party_Code = MultiCltId.Party_Code And DpType In ('NSDL', 'CDSL') And BankDpId = ''  
	And C_SecuritiesMst.Party_Code in (@OldParty, @NewParty)  
	And Scrip_Cd Like @Scrip_Cd
End

GO
