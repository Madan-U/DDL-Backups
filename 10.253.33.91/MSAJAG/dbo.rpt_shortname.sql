-- Object: PROCEDURE dbo.rpt_shortname
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_shortname    Script Date: 7/8/01 3:28:48 PM ******/


/****** Object:  Stored Procedure dbo.rpt_shortname    Script Date: 2/17/01 5:19:54 PM ******/


/****** Object:  Stored Procedure dbo.rpt_shortname    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_shortname    Script Date: 20-Mar-01 11:39:03 PM ******/


/*Modified by amolika on 1st march'2001 : removed newmsajag.dbo. */
/* report : traderledger
   file : allparty.asp
*/
/* displays short name of a particular party code*/
CREATE PROCEDURE rpt_shortname
@clcode varchar(7)
AS
select distinct short_name from  client1 where cl_code=@clcode

GO
