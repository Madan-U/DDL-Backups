-- Object: PROCEDURE dbo.rpt_shortname
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_shortname    Script Date: 20-Mar-01 11:43:35 PM ******/

/* report : traderledger
   file : allparty.asp
*/
/* displays short name of a particular party code*/
CREATE PROCEDURE rpt_shortname
@clcode varchar(7)
AS
select distinct short_name from msajag.dbo.client1 where cl_code=@clcode

GO
