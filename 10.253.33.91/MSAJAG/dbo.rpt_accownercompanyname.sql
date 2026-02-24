-- Object: PROCEDURE dbo.rpt_accownercompanyname
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accownercompanyname    Script Date: 01/19/2002 12:15:11 ******/

/****** Object:  Stored Procedure dbo.rpt_accownercompanyname    Script Date: 01/04/1980 5:06:25 AM ******/
CREATE proc rpt_accownercompanyname
@sharedb varchar(15)
as
select companyname from account.dbo.owner where sharedb = @sharedb

GO
