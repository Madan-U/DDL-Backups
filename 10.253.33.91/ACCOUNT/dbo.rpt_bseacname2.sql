-- Object: PROCEDURE dbo.rpt_bseacname2
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bseacname2    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bseacname2    Script Date: 11/28/2001 12:23:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseacname2    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseacname2    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseacname2    Script Date: 8/7/01 6:03:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseacname2    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseacname2    Script Date: 2/17/01 3:34:16 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bseacname2    Script Date: 20-Mar-01 11:43:34 PM ******/

/* report : allpartyledger
   file : allparty.asp
*/
/* displays name of a client from ledger */
CREATE PROCEDURE rpt_bseacname2 
@cltcode varchar(10)
as
select distinct acname 
from ledger, bsedb.dbo.client1 
where cl_code=@cltcode 
and acname=short_name

GO
