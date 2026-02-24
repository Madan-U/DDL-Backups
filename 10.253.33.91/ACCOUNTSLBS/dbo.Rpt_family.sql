-- Object: PROCEDURE dbo.Rpt_family
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

/* Familywise Ledger */
/* Finds Families From Client1 */
Create Procedure Rpt_family
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

GO
