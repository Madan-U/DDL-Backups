-- Object: PROCEDURE dbo.rpt_accbalsign
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accbalsign    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_accbalsign    Script Date: 11/28/2001 12:23:45 PM ******/


/*this procedure gives us the balsign from owner for current module*/
create proc rpt_accbalsign
@conpath varchar(25)
as
select balsign from account.dbo.owner
where conpath = @conpath

GO
