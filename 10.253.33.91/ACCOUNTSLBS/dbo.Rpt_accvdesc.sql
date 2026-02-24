-- Object: PROCEDURE dbo.Rpt_accvdesc
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

/*this Procedure Gives Us The Discription For Supplied Vtype*/
Create Procedure 
Rpt_accvdesc 
@Vtype Smallint
As
Select Vdesc From Account.Dbo.Vmast Where 
Vtype = @Vtype

GO
