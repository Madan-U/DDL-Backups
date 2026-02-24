-- Object: PROCEDURE dbo.rpt_clcode
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clcode    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_clcode    Script Date: 11/28/2001 12:23:48 PM ******/




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
