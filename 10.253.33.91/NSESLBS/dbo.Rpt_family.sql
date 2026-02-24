-- Object: PROCEDURE dbo.Rpt_family
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/* Familywise Ledger */  
/* Finds Families From Client1 */  
CREATE Procedure Rpt_family
@Statusid Varchar(15),   
@Statusname  Varchar(25)  
As  
If @Statusid = 'Broker'  
	Begin  
		Select Distinct Family From Client1  
		Order By Family  
	End  
If @Statusid = 'Family'  
	Begin  
		Select Distinct Family From Client1  
		Where Family = @Statusname  
		Order By Family  
	End  
If @Statusid = 'Branch'
	Begin
		Select Distinct Family From Client1
		Where Branch_Cd = @Statusname
		Order by Family
	End
If @Statusid = 'SubBroker'
	Begin
		Select Distinct Family From Client1
		Where Sub_Broker = @Statusname
		Order by Family
	End
If @Statusid = 'Trader'
	Begin
		Select Distinct Family From Client1
		Where Trader = @Statusname
		Order by Family
	End
Else
	Begin
		Select Family From Client1
		Where 1 = 0
	End

GO
