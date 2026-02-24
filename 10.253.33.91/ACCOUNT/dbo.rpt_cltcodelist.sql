-- Object: PROCEDURE dbo.rpt_cltcodelist
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_cltcodelist    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_cltcodelist    Script Date: 11/28/2001 12:23:49 PM ******/




/****** Object:  Stored Procedure dbo.rpt_cltcodelist    Script Date: 2/17/01 5:19:41 PM ******/


/****** Object:  Stored Procedure dbo.rpt_cltcodelist    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cltcodelist    Script Date: 20-Mar-01 11:38:55 PM ******/



/* report : allpartyledger
   file : clientlist.asp
*/
/* calculates list of all clients from ledger*/
/*changed by mousami on 05/09/2001
    now list of clients will contain clients of type 4 only .This is told by sheetal
*/

/* changed by mousami on 01/03/2001
     added account database hardcoding to accounts tables
     and removed hardcoding for sharedatabse for sharedatabase tables */

CREATE PROCEDURE rpt_cltcodelist
@statusid varchar(15),
@statusname varchar(25)
AS
 if @statusid = 'broker' 
 begin
  select distinct l.cltcode from account.dbo.ledger l ,account.dbo. acmast a 
  where a.cltcode=l.cltcode and a.accat=4
  order by l.cltcode
 end
 if @statusid = 'branch' 
 begin
  select distinct l.cltcode from account.dbo.ledger l, client1 c1,client2 c2, branches b, account.dbo.acmast a
  where b.branch_cd=@statusname and b.short_name=c1.trader and l.cltcode=c2.party_code and
  c1.cl_code=c2.cl_code
  and a.cltcode=l.cltcode and a.accat=4
  order by l.cltcode
 end
 if @statusid = 'trader' 
 begin
  select distinct l.cltcode from account.dbo.ledger l, client1 c1, client2 c2, account.dbo.acmast a
  where c1.trader=@statusname  and c1.cl_code=c2.cl_code and l.cltcode=c2.party_code
 and  a.cltcode=l.cltcode and a.accat=4	
  order by l.cltcode
 end 
 
 if @statusid = 'subbroker' 
 begin
  select distinct l.cltcode from account.dbo.ledger l,client1 c1, client2 c2, subbrokers sb, account.dbo.acmast a
  where sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker and
  c1.cl_code=c2.cl_code and l.cltcode=c2.party_code
  and a.cltcode=l.cltcode and a.accat=4
  order by l.cltcode
 end 
 if @statusid = 'client' 
 begin
  select distinct l.cltcode from account.dbo.ledger l, client1 c1, client2 c2, account.dbo.acmast a
  where l.cltcode=@statusname and  c1.cl_code=c2.cl_code and l.cltcode=c2.party_code
  and a.cltcode=l.cltcode and a.accat=4
  order by l.cltcode
 end
 if @statusid = 'family' 
 begin
  select distinct l.cltcode from account.dbo.ledger l ,account.dbo. acmast a , client1 c1, client2 c2
  where a.cltcode=l.cltcode and a.accat=4
  and c1.cl_code=c2.cl_code 
  and c2.party_code=l.cltcode
  and c1.family=@statusname
  order by l.cltcode
 end

GO
