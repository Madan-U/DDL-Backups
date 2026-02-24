-- Object: PROCEDURE dbo.rpt_clcode
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clcode    Script Date: 01/19/2002 12:15:13 ******/

/****** Object:  Stored Procedure dbo.rpt_clcode    Script Date: 01/04/1980 5:06:26 AM ******/




/****** Object:  Stored Procedure dbo.rpt_clcode    Script Date: 2/17/01 5:19:40 PM ******/

/* report : allpartyledger
   file : datewise.asp
   report: allpartyledger
   file : cumledger.asp
*/
/* selects client code of a partycode */

/* changed by mousami on 01/03/2001
 removed hardcoding 
 for sharedatabase and added hardcoding for account databse*/
 
CREATE PROCEDURE rpt_clcode
@partycode varchar(10)
AS
select cl_code from client2 where
party_code=@partycode

GO
