-- Object: PROCEDURE dbo.rpt_acccompanyname
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acccompanyname    Script Date: 01/19/2002 12:15:11 ******/

/****** Object:  Stored Procedure dbo.rpt_acccompanyname    Script Date: 01/04/1980 5:06:24 AM ******/
CREATE proc rpt_acccompanyname
@sharedb varchar(15)
as
select companyname from msajag.dbo.multicompany where sharedb = @sharedb

GO
