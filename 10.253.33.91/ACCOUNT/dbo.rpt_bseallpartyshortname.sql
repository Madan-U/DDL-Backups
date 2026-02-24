-- Object: PROCEDURE dbo.rpt_bseallpartyshortname
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bseallpartyshortname    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bseallpartyshortname    Script Date: 11/28/2001 12:23:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseallpartyshortname    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseallpartyshortname    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseallpartyshortname    Script Date: 8/7/01 6:03:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseallpartyshortname    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseallpartyshortname    Script Date: 2/17/01 3:34:16 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bseallpartyshortname    Script Date: 20-Mar-01 11:43:34 PM ******/

CREATE PROCEDURE rpt_bseallpartyshortname
@clcode varchar(6)
 AS
select distinct short_name from  bsedb.dbo.client1 where cl_code=@clcode

GO
