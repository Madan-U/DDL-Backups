-- Object: PROCEDURE dbo.rpt_accvdesc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accvdesc    Script Date: 01/19/2002 12:15:12 ******/

/****** Object:  Stored Procedure dbo.rpt_accvdesc    Script Date: 01/04/1980 5:06:25 AM ******/

/*this procedure gives us the discription for supplied vtype*/
create procedure 
rpt_accvdesc 
@vtype smallint
as
select Vdesc from account.dbo.vmast where 
vtype = @vtype

GO
