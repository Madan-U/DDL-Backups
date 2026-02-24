-- Object: PROCEDURE dbo.rpt_accbalsign
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accbalsign    Script Date: 01/19/2002 12:15:11 ******/

/****** Object:  Stored Procedure dbo.rpt_accbalsign    Script Date: 01/04/1980 5:06:24 AM ******/



/*this procedure gives us the balsign from owner for current module*/
create proc rpt_accbalsign
@conpath varchar(25)
as
select balsign from account.dbo.owner
where conpath = @conpath

GO
