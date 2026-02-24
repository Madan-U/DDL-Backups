-- Object: PROCEDURE dbo.rpt_accchkpathsegbalsign
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accchkpathsegbalsign    Script Date: 01/19/2002 12:15:11 ******/

/****** Object:  Stored Procedure dbo.rpt_accchkpathsegbalsign    Script Date: 01/04/1980 5:06:24 AM ******/
create procedure rpt_accchkpathsegbalsign
@sharedb varchar(15)
as
select conpath ,segment ,balsign from account.dbo.owner 
where sharedb = @sharedb

GO
