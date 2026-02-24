-- Object: PROCEDURE dbo.albmprtgetdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.albmprtgetdate    Script Date: 3/17/01 9:55:43 PM ******/

/****** Object:  Stored Procedure dbo.albmprtgetdate    Script Date: 3/21/01 12:49:59 PM ******/

/****** Object:  Stored Procedure dbo.albmprtgetdate    Script Date: 20-Mar-01 11:38:42 PM ******/

/****** Object:  Stored Procedure dbo.albmprtgetdate    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.albmprtgetdate    Script Date: 12/27/00 8:58:42 PM ******/

/* this sp is used in albmprintctlprj contol.to get the server date */
CREATE PROCEDURE albmprtgetdate AS
select convert(varchar,getdate(),101)

GO
