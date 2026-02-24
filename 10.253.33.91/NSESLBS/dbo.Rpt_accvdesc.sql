-- Object: PROCEDURE dbo.Rpt_accvdesc
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

Create Procedure 
Rpt_accvdesc 
@Vtype Smallint
As
Select Vdesc From Account.Dbo.Vmast Where 
Vtype = @Vtype

GO
