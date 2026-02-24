-- Object: PROCEDURE dbo.confdateproc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.confdateproc    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.confdateproc    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.confdateproc    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.confdateproc    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.confdateproc    Script Date: 12/27/00 8:58:47 PM ******/

/****** Object:  Stored Procedure dbo.confdateproc    Script Date: 12/18/99 8:24:12 AM ******/
CREATE PROCEDURE confdateproc AS
select distinct convert(varchar,sauda_date,103) from confparty order by convert(varchar,sauda_date,103)

GO
