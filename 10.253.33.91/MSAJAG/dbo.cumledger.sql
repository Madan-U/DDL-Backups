-- Object: PROCEDURE dbo.cumledger
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.cumledger    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.cumledger    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.cumledger    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.cumledger    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.cumledger    Script Date: 12/27/00 8:58:48 PM ******/

CREATE PROCEDURE cumledger
@cltcode varchar(10)
as
select distinct acname from ledger where cltcode=@cltcode

GO
