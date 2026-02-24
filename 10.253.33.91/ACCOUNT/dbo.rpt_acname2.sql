-- Object: PROCEDURE dbo.rpt_acname2
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acname2    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_acname2    Script Date: 11/28/2001 12:23:46 PM ******/




/****** Object:  Stored Procedure dbo.rpt_acname2    Script Date: 2/17/01 5:19:38 PM ******/

/* report : allpartyledger
   file : allparty.asp
*/
/* displays name of a client from ledger */

/*changed by mousami on 01/03/2001
removed hardcoding 
for sharedatabase and added hardcoding for account databse*/

CREATE PROCEDURE rpt_acname2 
@cltcode varchar(10)
as
select distinct acname from account.dbo. ledger,client1 
where cl_code=@cltcode and acname=short_name

GO
