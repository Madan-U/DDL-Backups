-- Object: PROCEDURE dbo.Rpt_lastopentry
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


/*  
This Query Is Used If Opening Entry For Current Yr Is Not Found  
This Query Gives Us The Latest Opeing Entry Date  
*/  
CREATE Procedure Rpt_lastopentry  
@Sdtcur Datetime  
As  
Select   Isnull(Left((Convert(Varchar, Max(Vdt), 109)), 11), '') From Account.Dbo.Ledger Where Vtyp = '18' And  
Vdt < @Sdtcur

GO
