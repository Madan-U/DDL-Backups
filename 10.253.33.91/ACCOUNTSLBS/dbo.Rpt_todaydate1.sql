-- Object: PROCEDURE dbo.Rpt_todaydate1
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

Create Procedure Rpt_todaydate1
As
Select Convert(varchar(11),getdate(),109)

GO
