-- Object: PROCEDURE dbo.Dump_InActiveData
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

Create Proc Dump_InActiveData as
Select * From BAK_Inactive_det
Where Live_Inactive_Date <> Old_Inactive_date

GO
