-- Object: PROCEDURE dbo.Rpt_todaydate
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

Create Procedure Rpt_todaydate
As
Select Convert(Varchar, Getdate(), 103)

GO
