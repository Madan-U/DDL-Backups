-- Object: PROCEDURE dbo.acname
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.acname    Script Date: 01/04/1980 1:40:34 AM ******/



/****** Object:  Stored Procedure dbo.acname    Script Date: 11/28/2001 12:23:39 PM ******/

/****** Object:  Stored Procedure dbo.acname    Script Date: 29-Sep-01 8:12:01 PM ******/

/****** Object:  Stored Procedure dbo.acname    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.acname    Script Date: 8/7/01 6:03:47 PM ******/

/****** Object:  Stored Procedure dbo.acname    Script Date: 7/8/01 3:22:47 PM ******/

/****** Object:  Stored Procedure dbo.acname    Script Date: 2/17/01 3:34:13 PM ******/


/****** Object:  Stored Procedure dbo.acname    Script Date: 20-Mar-01 11:43:32 PM ******/

CREATE PROCEDURE acname
@clcode varchar(6)
AS
select distinct acname from ledger, MSAJAG.DBO.client1
where cl_code= @clcode  and acname=short_name

GO
