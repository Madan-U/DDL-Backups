-- Object: PROCEDURE dbo.rpt_accchkpathsegbalsign
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accchkpathsegbalsign    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_accchkpathsegbalsign    Script Date: 11/28/2001 12:23:46 PM ******/

create procedure rpt_accchkpathsegbalsign
@sharedb varchar(15)
as
select conpath ,segment ,balsign from account.dbo.owner 
where sharedb = @sharedb

GO
