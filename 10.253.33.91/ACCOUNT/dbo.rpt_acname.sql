-- Object: PROCEDURE dbo.rpt_acname
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acname    Script Date: 20-Mar-01 11:43:34 PM ******/

/* report : allpartyledger
   file : singlparty.asp
   report : allpartyledger 
   file : cumledger.asp
*/
/* displays name of a client from ledger */
CREATE PROCEDURE rpt_acname 
@cltcode varchar(10)
as
select acname from ledger where cltcode=@cltcode

GO
