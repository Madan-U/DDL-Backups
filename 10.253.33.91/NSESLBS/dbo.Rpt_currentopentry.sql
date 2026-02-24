-- Object: PROCEDURE dbo.Rpt_currentopentry
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



/*  
This Gives Us The Open Entry Date For Supplied Yr  
*/  
CREATE Procedure Rpt_currentopentry  
@Sdtcur Datetime ,   
@Ldtcur Datetime  
As  
/*  
Select Distinct Isnull(Convert(Varchar, Vdt, 109), '')  From Account.Dbo.Ledger Where Vtyp = '18' And  
Vdt > = Ltrim(@Sdtcur) And Vdt < = Ltrim(@Ldtcur) + ' 23:59:59'    
*/  
Select Distinct Isnull(Left(Convert(Varchar, Vdt, 109), 11), '')  From Account.Dbo.Ledger Where Vtyp = '18' And  
Vdt > = @Sdtcur And Vdt < = @Ldtcur  + ' 23:59:59'

GO
