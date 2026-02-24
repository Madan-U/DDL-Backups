-- Object: PROCEDURE dbo.rpt_accvdesc
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accvdesc    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_accvdesc    Script Date: 11/28/2001 12:23:46 PM ******/

/*this procedure gives us the discription for supplied vtype*/
create procedure 
rpt_accvdesc 
@vtype smallint
as
select Vdesc from account.dbo.vmast where 
vtype = @vtype

GO
