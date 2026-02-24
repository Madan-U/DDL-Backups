-- Object: PROCEDURE dbo.Rpt_acccompanyname
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

Create Proc Rpt_acccompanyname
@Sharedb Varchar(15)
As
Select Companyname From Multicompany Where Sharedb = @Sharedb

GO
