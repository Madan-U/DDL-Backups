-- Object: PROCEDURE dbo.rpt_alldebtors
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_alldebtors    Script Date: 01/19/2002 12:15:13 ******/

/****** Object:  Stored Procedure dbo.rpt_alldebtors    Script Date: 01/04/1980 5:06:25 AM ******/



/* report : debtors
   file : drlist.asp
*/
/*
Modified by neelambari on 29 aug 2001
made changed for the user to allow selection of sorting by vdt or edt
*/
/* calculates balances of all client accounts of a ledger for a particular date */
/*  changed by mousami on 09/02/2001 */


CREATE  PROCEDURE rpt_alldebtors 
@sortbydate varchar(4),
@vdt datetime ,
@statusid varchar(15),
@statusname varchar(25)
AS
If @sortbydate ='vdt' begin
 if @statusid='broker'
 begin
  	select l.cltcode , l.acname, clcode=(select cl_code from client2 c2
	  where c2.party_code=l.cltcode),Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger 
	  where drcr = 'D' and cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59')
	  - (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and 
	  cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59') From account.dbo.Ledger l , account.dbo.acmast a, client2 c2
	  where a.accat=4 and a.cltcode=l.cltcode 
	  and c2.party_code=l.cltcode
	  group by l.Cltcode,l.acname 
	  order by l.cltcode
 end 
 if @statusid='branch'
 begin
	  select l.cltcode , l.acname, clcode=(select cl_code from client2 
	  c2 where c2.party_code=l.cltcode),Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger 
	  where drcr = 'D' and cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59')
	  - (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and 
	  cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59') From account.dbo.Ledger l , account.dbo.acmast a , 
	  client2 c2,  client1 c1, branches b 
	  where a.accat=4 and a.cltcode=l.cltcode and l.cltcode=c2.party_code 
	  and b.branch_cd=@statusname and b.short_name=c1.trader and c2.cl_code=c1.cl_code
	  group by l.Cltcode,l.acname 
	  order by l.cltcode
 end
 if @statusid='trader'
 begin
	  select l.cltcode , l.acname, clcode=(select cl_code from  client2 
	  c2 where c2.party_code=l.cltcode),Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger 
	  where drcr = 'D' and cltcode = l.cltcode and vdt <= @vdt +'  23:59:59')
	  - (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and 
	  cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59')
	 From account.dbo.Ledger l , account.dbo.acmast a ,  client2 c2 ,
	 client1 c1 
	  where a.accat=4 and a.cltcode=l.cltcode and l.cltcode=c2.party_code 
	  and c1.cl_code=c2.cl_code 
	  and c1.trader=@statusname
	  group by l.Cltcode,l.acname 
	    order by l.cltcode
 end
 if @statusid='subbroker'
 begin
	  select l.cltcode , l.acname, clcode=(select cl_code from  client2 
	  c2 where c2.party_code=l.cltcode),Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger 
	  where drcr = 'D' and cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59')
	  - (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and 
	  cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59') From account.dbo.Ledger l , account.dbo.acmast a ,client2 c2 ,
	 client1 c1, subbrokers sb
	  where a.accat=4 and a.cltcode=l.cltcode and l.cltcode=c2.party_code 
	  and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
	  and c1.cl_code=c2.cl_code 
	  group by l.Cltcode,l.acname 
	    order by l.cltcode
 end
 if @statusid='client'
 begin
	  select l.cltcode , l.acname, clcode=(select cl_code from client2 
	  c2 where c2.party_code=l.cltcode),Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger 
	  where drcr = 'D' and cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59')
	  - (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and 
	  cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59') From account.dbo.Ledger l , account.dbo.acmast a , client2 c2 ,
	  client1 c1 
	  where a.accat=4 and a.cltcode=l.cltcode and l.cltcode=c2.party_code 
	  and l.cltcode=@statusname
	  and c1.cl_code=c2.cl_code
	  group by l.Cltcode,l.acname 
	    order by l.cltcode
 end
 if @statusid='family'
 begin
	  select l.cltcode , l.acname, clcode=(select cl_code from  client2 c2
	  where c2.party_code=l.cltcode),Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger 
	  where drcr = 'D' and cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59')
	  - (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and 
	  cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59') From account.dbo.Ledger l , account.dbo.acmast a , client2 c2 , client1 c1
	  where a.accat=4 and a.cltcode=l.cltcode and l.cltcode=c2.party_code 
	  and c1.family=@statusname and c1.cl_code=c2.cl_code
	  group by l.Cltcode,l.acname 
	    order by l.cltcode
 end 


end


/*  --------------  The part below is executed if sort by date selected is = edt         -----------------------*/

If @sortbydate ='edt' begin
 if @statusid='broker'
 begin
  	select l.cltcode , l.acname, clcode=(select cl_code from client2 c2
	  where c2.party_code=l.cltcode),Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger 
	  where drcr = 'D' and cltcode = l.cltcode and edt <= @vdt + ' 23:59:59')
	  - (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and 
	  cltcode = l.cltcode and edt <= @vdt + ' 23:59:59') From account.dbo.Ledger l , account.dbo.acmast a, client2 c2
	  where a.accat=4 and a.cltcode=l.cltcode 
	  and c2.party_code=l.cltcode
	  group by l.Cltcode,l.acname 
	  order by l.cltcode
 end 
 if @statusid='branch'
 begin
	  select l.cltcode , l.acname, clcode=(select cl_code from client2 
	  c2 where c2.party_code=l.cltcode),Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger 
	  where drcr = 'D' and cltcode = l.cltcode and edt <= @vdt + ' 23:59:59')
	  - (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and 
	  cltcode = l.cltcode and edt <= @vdt + ' 23:59:59') From account.dbo.Ledger l , account.dbo.acmast a , 
	  client2 c2,  client1 c1, branches b 
	  where a.accat=4 and a.cltcode=l.cltcode and l.cltcode=c2.party_code 
	  and b.branch_cd=@statusname and b.short_name=c1.trader and c2.cl_code=c1.cl_code
	  group by l.Cltcode,l.acname 
	  order by l.cltcode
 end
 if @statusid='trader'
 begin
	  select l.cltcode , l.acname, clcode=(select cl_code from  client2 
	  c2 where c2.party_code=l.cltcode),Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger 
	  where drcr = 'D' and cltcode = l.cltcode and edt <= @vdt + ' 23:59:59')
	  - (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and 
	  cltcode = l.cltcode and edt <= @vdt + ' 23:59:59') From account.dbo.Ledger l , account.dbo.acmast a ,  client2 c2 ,
          client1 c1 
	  where a.accat=4 and a.cltcode=l.cltcode and l.cltcode=c2.party_code 
	  and c1.cl_code=c2.cl_code 
	  and c1.trader=@statusname
	  group by l.Cltcode,l.acname 
	    order by l.cltcode
 end
 if @statusid='subbroker'
 begin
	  select l.cltcode , l.acname, clcode=(select cl_code from  client2 
	  c2 where c2.party_code=l.cltcode),Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger 
	  where drcr = 'D' and cltcode = l.cltcode and edt <= @vdt + ' 23:59:59')
	  - (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and 
	  cltcode = l.cltcode and edt <= @vdt + ' 23:59:59')From account.dbo.Ledger l , account.dbo.acmast a ,client2 c2 ,
	 client1 c1, subbrokers sb
	  where a.accat=4 and a.cltcode=l.cltcode and l.cltcode=c2.party_code 
	  and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
	  and c1.cl_code=c2.cl_code 
	  group by l.Cltcode,l.acname 
	    order by l.cltcode
 end
 if @statusid='client'
 begin
	  select l.cltcode , l.acname, clcode=(select cl_code from client2 
	  c2 where c2.party_code=l.cltcode),Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger 
	  where drcr = 'D' and cltcode = l.cltcode and edt <= @vdt + ' 23:59:59')
	  - (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and 
	  cltcode = l.cltcode and edt <= @vdt + ' 23:59:59') From account.dbo.Ledger l , account.dbo.acmast a , client2 c2 ,
	  client1 c1 
	  where a.accat=4 and a.cltcode=l.cltcode and l.cltcode=c2.party_code 
	  and l.cltcode=@statusname
	  and c1.cl_code=c2.cl_code
	  group by l.Cltcode,l.acname 
	    order by l.cltcode
 end
 if @statusid='family'
 begin
	  select l.cltcode , l.acname, clcode=(select cl_code from  client2 c2
	  where c2.party_code=l.cltcode),Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger 
	  where drcr = 'D' and cltcode = l.cltcode and edt <= @vdt + ' 23:59:59')
	  - (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and 
	  cltcode = l.cltcode and edt <= @vdt + ' 23:59:59') From account.dbo.Ledger l , account.dbo.acmast a , client2 c2 , client1 c1
	  where a.accat=4 and a.cltcode=l.cltcode and l.cltcode=c2.party_code 
	  and c1.family=@statusname and c1.cl_code=c2.cl_code
	  group by l.Cltcode,l.acname 
	    order by l.cltcode
 end 


end

GO
