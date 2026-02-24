-- Object: PROCEDURE dbo.rpt_exchallpartylist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_exchallpartylist    Script Date: 01/19/2002 12:15:14 ******/

/****** Object:  Stored Procedure dbo.rpt_exchallpartylist    Script Date: 01/04/1980 5:06:26 AM ******/



/* report : exchangewise all party ledger */
/* displays list of clients from client master */


CREATE PROCEDURE  rpt_exchallpartylist


AS


select distinct party_code from clientmaster
order by party_code

GO
