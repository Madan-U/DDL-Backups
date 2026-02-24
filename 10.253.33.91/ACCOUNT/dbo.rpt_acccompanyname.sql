-- Object: PROCEDURE dbo.rpt_acccompanyname
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acccompanyname    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_acccompanyname    Script Date: 11/28/2001 12:23:46 PM ******/

CREATE proc rpt_acccompanyname
@sharedb varchar(15)
as
select companyname from msajag.dbo.multicompany where sharedb = @sharedb

GO
