-- Object: PROCEDURE dbo.rpt_newclient
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_newclient    Script Date: 04/27/2001 4:32:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newclient    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newclient    Script Date: 20-Mar-01 11:39:01 PM ******/





/****** Object:  Stored Procedure dbo.rpt_newclient    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newclient    Script Date: 12/27/00 8:58:56 PM ******/

CREATE PROCEDURE rpt_newclient AS
select distinct party_code from trade4432 where party_code not in (select party_code from client2)

GO
