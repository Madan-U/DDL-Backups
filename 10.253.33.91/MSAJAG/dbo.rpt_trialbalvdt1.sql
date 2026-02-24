-- Object: PROCEDURE dbo.rpt_trialbalvdt1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/* report : trial balance        file : trialbal.asp
 displays trial balance */

/*
This procedure is executed when user selects sort by date = vdt 
and opening entry date exists for selected year
*/
  
CREATE PROCEDURE rpt_trialbalvdt1
@statusid varchar(15),
@statusname varchar(25),
@vdt varchar(12),
@openentrydate varchar(12),
@flag varchar(15)
AS

if @flag="codewise" 
begin
 	if @statusid = 'broker'
 	begin
 		 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  		Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'D' and cltcode = l.cltcode 
  			and vdt >= @openentrydate and vdt <= @vdt + ' 23:59:59') - 
 		 (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and cltcode = l.cltcode 
			and vdt >= @openentrydate and  vdt <= @vdt + ' 23:59:59') 
  		From account.dbo.Ledger l where  
		vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
  		group by l.Cltcode , l.acname 
		order by  l.Cltcode , l.acname 
 	end 
 
	 if @statusid = 'branch'
	 begin
		  select l.cltcode , clcode=isnull((select cl_code from client2 c2 
		  where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
		  Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'D' and cltcode = l.cltcode 
			  	and vdt >= @openentrydate and  vdt <= @vdt + ' 23:59:59') - 
		  (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and cltcode = l.cltcode 
			and vdt >= @openentrydate and  vdt <= @vdt + ' 23:59:59') 
		  From account.dbo.Ledger l, branches b,client1 c1, client2 c2
		  where  vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate  
		  and b.branch_cd=@statusname
		  and b.short_name=c1.trader
		  and c1.cl_code=c2.cl_code
		  and c2.party_code=l.cltcode
		  group by l.Cltcode, l.acname 
               	  order by  l.Cltcode , l.acname 
	 end 
 
	 if @statusid = 'trader'
	 begin
		  select l.cltcode , clcode=isnull((select cl_code from client2 c2 
		  where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
		  Amount = ( select isnull(round(sum(round(vamt,2)),2),0) from account.dbo.ledger where drcr = 'D' 
				and cltcode = l.cltcode  and  vdt <= @vdt + ' 23:59:59'and vdt >= @openentrydate )- 
		  (select isnull(round(sum(round(vamt,2)),2),0) from account.dbo.ledger where drcr = 'C' 
				and cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate ) 
		  From account.dbo.Ledger l,  client1 c1, client2 c2
		  where   vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate 
		  and c1.trader=@statusname
		  and c1.cl_code=c2.cl_code
		  and c2.party_code=l.cltcode
		  group by l.Cltcode, l.acname 
	    	  order by   l.Cltcode , l.acname 
	 end 
	 if @statusid='subbroker'
	 begin
		  select l.cltcode , clcode=isnull((select cl_code from client2 c2 
		  where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
		  Amount = ( select isnull(round(sum(round(vamt,2)),2),0) from account.dbo.ledger where drcr = 'D' and cltcode = l.cltcode 
		  and   vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate )- 
		  (select isnull(round(sum(round(vamt,2)),2),0) from account.dbo.ledger where drcr = 'C' and cltcode = l.cltcode 
			and  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate )  
		  From account.dbo.Ledger l, client1 c1, client2 c2, subbrokers sb
		  where vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate 
		  and sb.sub_broker=@statusname
		  and sb.sub_broker=c1.sub_broker
		  and c1.cl_code=c2.cl_code
		  and c2.party_code=l.cltcode
		  group by l.Cltcode, l.acname 
               	  order by  l.Cltcode , l.acname 
	 end
	 if @statusid='client'
	 begin
		  select l.cltcode , clcode=isnull((select cl_code from client2 c2   where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
		  Amount = ( select isnull(round(sum(round(vamt,2)),2),0) from account.dbo.ledger where drcr = 'D' and cltcode = l.cltcode 
			and vdt >= @openentrydate   and vdt <= @vdt + ' 23:59:59')- 
		  (select isnull(round(sum(round(vamt,2)),2),0) from account.dbo.ledger where drcr = 'C' and cltcode = l.cltcode
			and vdt >= @openentrydate  and vdt <= @vdt + ' 23:59:59') 
		  From account.dbo.Ledger l , client1 C1, client2 C2
		  where  vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate 
		  and  c1.cl_code=c2.cl_code
		  and c2.party_code=l.cltcode
		  and l.cltcode=@statusname
		  group by l.Cltcode, l.acname 
                  order by  l.Cltcode , l.acname 
	 end

end /* this end for query order by  codewise*/



if @flag="namewise" 
begin
 	if @statusid = 'broker'
 	begin
 		 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  		Amount = ( select isnull(sum(round(vamt,2)),0) from account.dbo.ledger where drcr = 'D' and cltcode = l.cltcode 
  		and vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate ) - 
 		 (select isnull(sum(round(vamt,2)),0) from account.dbo.ledger where drcr = 'C' and cltcode = l.cltcode 
		and  vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate ) 
  		From account.dbo.Ledger l where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
  		group by l.Cltcode , l.acname 
		order by  l.acname , l.Cltcode
 	end 
 
	 if @statusid = 'branch'
	 begin
		  select l.cltcode , clcode=isnull((select cl_code from client2 c2 
		  where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
		  Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'D' and cltcode = l.cltcode 
		  and vdt >= @openentrydate and  vdt <= @vdt + ' 23:59:59') - 
		  (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and cltcode = l.cltcode 
		  and vdt >= @openentrydate and vdt <= @vdt + ' 23:59:59') 
		  From account.dbo.Ledger l, branches b,client1 c1, client2 c2
		  where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
		  and b.branch_cd=@statusname
		  and b.short_name=c1.trader
		  and c1.cl_code=c2.cl_code
		  and c2.party_code=l.cltcode
		  group by l.Cltcode, l.acname 
                  order by  l.acname , l.Cltcode

	 end 
 
	 if @statusid = 'trader'
	 begin
		  select l.cltcode , clcode=isnull((select cl_code from client2 c2 
		  where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
		  Amount = ( select isnull(round(sum(round(vamt,2)),2),0) from account.dbo.ledger where drcr = 'D' and cltcode = l.cltcode 
		  and vdt >= @openentrydate and vdt <= @vdt + ' 23:59:59')- 
		  (select isnull(round(sum(round(vamt,2)),2),0) from account.dbo.ledger where drcr = 'C' and cltcode = l.cltcode 
		  and vdt >= @openentrydate and  vdt <= @vdt + ' 23:59:59') 
		  From account.dbo.Ledger l,  client1 c1, client2 c2
		  where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
		  and c1.trader=@statusname
		  and c1.cl_code=c2.cl_code
		  and c2.party_code=l.cltcode
		  group by l.Cltcode, l.acname 
                   order by  l.acname , l.Cltcode
	 end 
	 if @statusid='subbroker'
	 begin
		  select l.cltcode , clcode=isnull((select cl_code from client2 c2 
		  where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
		  Amount = ( select isnull(round(sum(round(vamt,2)),2),0) from account.dbo.ledger where drcr = 'D' and cltcode = l.cltcode 
		 	and vdt >= @openentrydate  and	vdt <= @vdt + ' 23:59:59')- 
		  (select isnull(round(sum(round(vamt,2)),2),0) from account.dbo.ledger where drcr = 'C' and cltcode = l.cltcode 
			and vdt >= @openentrydate and vdt <= @vdt + ' 23:59:59') 
		  From account.dbo.Ledger l, client1 c1, client2 c2, subbrokers sb
		  where vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate 
		  and sb.sub_broker=@statusname
		  and sb.sub_broker=c1.sub_broker
		  and c1.cl_code=c2.cl_code
		  and c2.party_code=l.cltcode
		  group by l.Cltcode, l.acname 
		  order by  l.acname , l.Cltcode
	 end
	 if @statusid='client'
	 begin
		  select l.cltcode , clcode=isnull((select cl_code from client2 c2 
		  where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
		  Amount = ( select isnull(round(sum(round(vamt,2)),2),0) from account.dbo.ledger where drcr = 'D' and cltcode = l.cltcode 
			and vdt >= @openentrydate   and vdt <= @vdt + ' 23:59:59')- 
		  (select isnull(round(sum(round(vamt,2)),2),0) from account.dbo.ledger where drcr = 'C' and cltcode = l.cltcode 
			and vdt >= @openentrydate and  vdt <= @vdt + ' 23:59:59') 
		  From account.dbo.Ledger l , client1 C1, client2 C2
		  where  vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate 
		  and  c1.cl_code=c2.cl_code
		  and c2.party_code=l.cltcode
		  and l.cltcode=@statusname
		  group by l.Cltcode, l.acname 
                  order by  l.acname , l.Cltcode 
	 end

end /* this end for query order by namewise */

GO
