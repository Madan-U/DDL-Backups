-- Object: PROCEDURE dbo.partycode
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.partycode    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.partycode    Script Date: 11/28/2001 12:23:45 PM ******/

/****** Object:  Stored Procedure dbo.partycode    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.partycode    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.partycode    Script Date: 8/7/01 6:03:50 PM ******/

/****** Object:  Stored Procedure dbo.partycode    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.partycode    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.partycode    Script Date: 20-Mar-01 11:43:34 PM ******/

CREATE PROCEDURE partycode
@clcode varchar(6)
AS
select distinct party_code from MSAJAG.DBO.client2, ledger 
where cl_code=@clcode and party_code=cltcode

GO
