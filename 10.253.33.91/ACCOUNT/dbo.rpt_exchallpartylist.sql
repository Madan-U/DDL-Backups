-- Object: PROCEDURE dbo.rpt_exchallpartylist
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_exchallpartylist    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_exchallpartylist    Script Date: 11/28/2001 12:23:49 PM ******/



/* report : exchangewise all party ledger */
/* displays list of clients from client master */


CREATE PROCEDURE  rpt_exchallpartylist


AS


select distinct party_code from msajag.dbo.clientmaster
order by party_code

GO
