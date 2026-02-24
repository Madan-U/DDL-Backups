-- Object: PROCEDURE dbo.rpt_bseclcode
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bseclcode    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bseclcode    Script Date: 11/28/2001 12:23:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclcode    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclcode    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclcode    Script Date: 8/7/01 6:03:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclcode    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclcode    Script Date: 2/17/01 3:34:16 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bseclcode    Script Date: 20-Mar-01 11:43:34 PM ******/

/* report : allpartyledger
   file : datewise.asp
   report: allpartyledger
   file : cumledger.asp
*/
/* selects client code of a partycode */
CREATE PROCEDURE rpt_bseclcode
@partycode varchar(10)
AS
select cl_code 
from bsedb.dbo.client2 
where party_code=@partycode

GO
