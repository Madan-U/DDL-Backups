-- Object: PROCEDURE dbo.FASTTRADE_DepositDetails_EQ
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Procedure [dbo].[FASTTRADE_DepositDetails_EQ] (@TradeDate Varchar(11)) AS
Declare 
@RmsValue Varchar(200),
@FldName Varchar(50),
@MyQry varchar(4000),
@RMSCur Cursor

CREATE TABLE [#DepostDetails] 
(
	[BackOfficeId] [varchar] (10)  ,
	[ClientName] [varchar] (30)  ,
	[ExchangeSegment] [varchar] (10)  ,
	[TotalDeposit] [money]  ,
	[NonCashComponentDeposit] [money] ,
	[UnRelealizedAmount] [int]  ,
	[PendingRequestFor] [int]  ,
	[UserLevelDeposit] [varchar] (1)  
)



Set @RmsValue = ''
Set @MyQry = ''

Select @RmsValue = @RmsValue + FldName from Rms_Settings
where FLdType = 'CLIENT'
and FldFlag = 'Y'

Select @TradeDate = Left(Max(Sauda_Date),11) From RMSAllSegment Where Sauda_date <= @TradeDate + ' 23:59:59'

If @RmsValue <> ''
begin
	Set @MyQry = ' Insert Into #DepostDetails '
	Set @MyQry = @MyQry + ' Select * From ( '
	Set @MyQry = @MyQry + ' Select Party_Code, '
	Set @MyQry = @MyQry + ' Party_Name, ExchangeSegment = ''EQ'',' 
	Set @MyQry = @MyQry + ' TotalDeposit='+ @RmsValue + ','
	Set @MyQry = @MyQry + ' NonCashComponentDeposit = (Case When ''' + @RmsValue + ''' Like ''%Tot_collateral_nb-Cash_deposit%'' '
	Set @MyQry = @MyQry + '	Then Tot_collateral_nb-Cash_deposit '
	Set @MyQry = @MyQry + '	Else 0 End), '
	Set @MyQry = @MyQry + ' UnRelealizedAmount = 0, '
	Set @MyQry = @MyQry + ' PendingRequestFor = 0, '
	Set @MyQry = @MyQry + ' UserLevelDeposit = 5 '
	Set @MyQry = @MyQry + ' From RMSAllSegment '
	Set @MyQry = @MyQry + ' Where left(Sauda_Date,11) = ' + '''' + @TradeDate + ''''
	Set @MyQry = @MyQry + ' And Party_Code <> Branch_Cd) A '
	Set @MyQry = @MyQry + ' Where Not (TotalDeposit = 0 And NonCashComponentDeposit = 0) '
	Execute (@MyQry)
end 

Set @RmsValue = ''
Set @MyQry = ''

Select @RmsValue = @RmsValue + FldName from Rms_Settings
where FLdType = 'BRANCH'
and FldFlag = 'Y'

If @RmsValue <> ''
Begin
	Set @MyQry = @MyQry + ' Insert Into #DepostDetails '
	Set @MyQry = @MyQry + ' Select Branch_Cd, Long_Name, ExchangeSegment=''EQ'', TotalDeposit = Sum(TotalDeposit), '
	Set @MyQry = @MyQry + ' NonCashComponentDeposit = Sum(NonCashComponentDeposit), '
	Set @MyQry = @MyQry + ' UnRelealizedAmount = 0, '
	Set @MyQry = @MyQry + ' PendingRequestFor = 0, '
	Set @MyQry = @MyQry + ' UserLevelDeposit = 5 '
	Set @MyQry = @MyQry + ' From ( '
	Set @MyQry = @MyQry + ' Select Party_Code, Branch_Cd, '
	Set @MyQry = @MyQry + ' TotalDeposit='+ @RmsValue + ','
	Set @MyQry = @MyQry + ' NonCashComponentDeposit = (Case When ''' + @RmsValue + ''' Like ''%Tot_collateral_nb-Cash_deposit%'' '
	Set @MyQry = @MyQry + '	Then Tot_collateral_nb-Cash_deposit '
	Set @MyQry = @MyQry + '	Else 0 End) '
	Set @MyQry = @MyQry + ' From RMSAllSegment '
	Set @MyQry = @MyQry + ' Where left(Sauda_Date,11) = ' + '''' + @TradeDate + ''''
	Set @MyQry = @MyQry + ' And Party_Code = Branch_Cd) A, Branch '
	Set @MyQry = @MyQry + ' Where A.Branch_Cd = Branch.Branch_Code '
	Set @MyQry = @MyQry + ' Group By Branch_Cd, Long_Name '
	Set @MyQry = @MyQry + ' Having Not (Sum(TotalDeposit) = 0 And Sum(NonCashComponentDeposit) = 0) '
	Execute (@MyQry)
End

Set @RmsValue = ''
Set @MyQry = ''

Select @RmsValue = @RmsValue + FldName from Rms_Settings
where FLdType = 'CLIENTBRANCH'
and FldFlag = 'Y'

If @RmsValue <> ''
Begin
	Set @MyQry = @MyQry + ' Insert Into #DepostDetails '
	Set @MyQry = @MyQry + ' Select Branch_Cd, Long_Name, ExchangeSegment=''EQ'', TotalDeposit = Sum(TotalDeposit), '
	Set @MyQry = @MyQry + ' NonCashComponentDeposit = Sum(NonCashComponentDeposit), '
	Set @MyQry = @MyQry + ' UnRelealizedAmount = 0, '
	Set @MyQry = @MyQry + ' PendingRequestFor = 0, '
	Set @MyQry = @MyQry + ' UserLevelDeposit = 5 '
	Set @MyQry = @MyQry + ' From ( '
	Set @MyQry = @MyQry + ' Select Party_Code, Branch_Cd, '
	Set @MyQry = @MyQry + ' TotalDeposit='+ @RmsValue + ','
	Set @MyQry = @MyQry + ' NonCashComponentDeposit = (Case When ''' + @RmsValue + ''' Like ''%Tot_collateral_nb-Cash_deposit%'' '
	Set @MyQry = @MyQry + '	Then Tot_collateral_nb-Cash_deposit '
	Set @MyQry = @MyQry + '	Else 0 End) '
	Set @MyQry = @MyQry + ' From RMSAllSegment '
	Set @MyQry = @MyQry + ' Where left(Sauda_Date,11) = ' + '''' + @TradeDate + ''''
	Set @MyQry = @MyQry + ' And Party_Code <> Branch_Cd) A, Branch '
	Set @MyQry = @MyQry + ' Where A.Branch_Cd = Branch.Branch_Code '
	Set @MyQry = @MyQry + ' Group By Branch_Cd, Long_Name '
	Set @MyQry = @MyQry + ' Having Not (Sum(TotalDeposit) = 0 And Sum(NonCashComponentDeposit) = 0) '
	Set @MyQry = @MyQry + ' Order By Branch_Cd '
	Execute (@MyQry)
End

Select BackOfficeId,ClientName,ExchangeSegment,
TotalDeposit=Sum(TotalDeposit),
NonCashComponentDeposit=Sum(NonCashComponentDeposit),
UnRelealizedAmount=Sum(UnRelealizedAmount),
PendingRequestFor=Sum(PendingRequestFor),
UserLevelDeposit
From #DepostDetails
Group by BackOfficeId,ClientName,ExchangeSegment, UserLevelDeposit
Order By BackOfficeId

DROP TABLE #DepostDetails

GO
