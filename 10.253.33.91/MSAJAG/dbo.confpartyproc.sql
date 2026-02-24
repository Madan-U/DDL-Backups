-- Object: PROCEDURE dbo.confpartyproc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.confpartyproc    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.confpartyproc    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.confpartyproc    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.confpartyproc    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.confpartyproc    Script Date: 12/27/00 8:58:48 PM ******/

/****** Object:  Stored Procedure dbo.confpartyproc    Script Date: 12/18/99 8:24:03 AM ******/
CREATE PROCEDURE confpartyproc AS
select distinct party_code from confparty order by party_code

GO
