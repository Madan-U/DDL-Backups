-- Object: PROCEDURE dbo.C_CollateralAsOnDate
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc C_CollateralAsOnDate(
@TransDate Varchar(11),
@DpId Varchar(8),
@CltDpId Varchar(16),
@IsIn Varchar(20),
@Flag Int,
@Exchange Varchar(3),
@Segment Varchar(20)) As
--print @flag
If @Flag = 1
	Begin    
		Select Scrip_Cd, Series, IsIn, Qty = Sum(Case When DrCr = 'C' Then Qty Else -Qty End)    
		From C_SecuritiesMst     
		Where EffDate <= @TransDate + ' 23:59:59'    
		And IsIn = @IsIn
		And B_BankDpId = @DpId    
		And B_Dp_Acc_Code = @CltDpId
		And party_code <> 'BROKER'  
		Group By Scrip_Cd, Series, IsIn    
		Having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) <> 0    
		Order By Scrip_Cd, Series, IsIn    
	End    
Else
	Begin
		Select Party_Code, Scrip_Cd, Series, IsIn, Qty = Sum(Case When DrCr = 'C' Then Qty Else -Qty End)
		From C_SecuritiesMst
		Where EffDate <= @TransDate + ' 23:59:59'  
		And IsIn = @IsIn
		And B_BankDpId = @DpId
		And B_Dp_Acc_Code = @CltDpId
		And Exchange = @Exchange
		And Segment = @Segment
		And party_code <> 'BROKER'
		Group By Party_Code, Scrip_Cd, Series, IsIn
		Having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) <> 0
		Order By Party_Code, Scrip_Cd, Series, IsIn
	End

GO
