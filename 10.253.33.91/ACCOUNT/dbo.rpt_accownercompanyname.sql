-- Object: PROCEDURE dbo.rpt_accownercompanyname
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accownercompanyname    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_accownercompanyname    Script Date: 11/28/2001 12:23:46 PM ******/

CREATE proc rpt_accownercompanyname
@sharedb varchar(15)
as
select companyname from account.dbo.owner where sharedb = @sharedb

GO
