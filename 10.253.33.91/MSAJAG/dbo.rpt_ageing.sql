-- Object: PROCEDURE dbo.rpt_ageing
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_ageing    Script Date: 01/19/2002 12:15:12 ******/

/****** Object:  Stored Procedure dbo.rpt_ageing    Script Date: 01/04/1980 5:06:25 AM ******/






/****** Object:  Stored Procedure dbo.rpt_ageing    Script Date: 09/07/2001 11:09:01 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ageing    Script Date: 3/23/01 7:59:30 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ageing    Script Date: 08/18/2001 8:24:01 PM ******/


/****** Object:  Stored Procedure dbo.rpt_ageing    Script Date: 7/8/01 3:28:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ageing    Script Date: 2/17/01 5:19:38 PM ******/


/****** Object:  Stored Procedure dbo.rpt_ageing    Script Date: 3/21/01 12:50:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ageing    Script Date: 20-Mar-01 11:38:53 PM ******/


/*Modified by amolika on 1st march : removed msajag.dbo. & added account.dbo. for all accounts tables*/
/*Changes made by sheetal on 24/01/2001 to refno and use vtyp,vno,lno,drcr instead */
/* report : ageing report 
   file : ageingreport.asp
*/
/* shows last balances of a client  as on a particular date */
CREATE PROCEDURE rpt_ageing

@statusid varchar(15),
@statusname varchar(25),
@vdt varchar(12)

AS

 if @statusid='broker'
 begin
  select vdt=convert(varchar,vdt,101), c1.cl_code,balamt ,l1.cltcode, l1.acname 
  from account.dbo.ledger l1, account.dbo.acmast a , client1 c1, client2 c2
  where vdt = (select max(vdt) from account.dbo.ledger l where vdt <=@vdt +' 23:59:59' and l.cltcode =l1.cltcode) 
  and a.cltcode=l1.cltcode and a.accat=4 and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode 
  order by l1.acname,vdt,vtyp,vno,vno1,lno,drcr
  
  /*select vdt, c1.cl_code,balamt ,l1.cltcode, l1.acname 
  from ledger l1, acmast a , msajag.dbo.client1 c1, msajag.dbo.client2 c2 
  where vdt = (select max(vdt) from ledger l where vdt <=@vdt +' 23:59:59' and l.cltcode =l1.cltcode) 
  and a.cltcode=l1.cltcode and a.accat=4 and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode 
  order by l1.acname,vdt,vtyp,vno1,refno */
 end

 

if @statusid='branch'
 begin
  select vdt=convert(varchar,vdt,101), c1.cl_code,balamt ,l1.cltcode, l1.acname 
  from account.dbo.ledger l1, account.dbo.acmast a , client1 c1, client2 c2 , branches b
  where vdt = (select max(vdt) from account.dbo.ledger l where vdt <=@vdt +' 23:59:59' and l.cltcode =l1.cltcode) 
  and a.cltcode=l1.cltcode and a.accat=4 and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode and
  b.branch_cd=@statusname and b.short_name=c1.trader
  order by l1.acname,vdt,vtyp,vno,vno1,lno,drcr
  /*select vdt, c1.cl_code,balamt ,l1.cltcode, l1.acname 
  from ledger l1, acmast a , msajag.dbo.client1 c1, msajag.dbo.client2 c2 , msajag.dbo.branches b
  where vdt = (select max(vdt) from ledger l where vdt <=@vdt +' 23:59:59' and l.cltcode =l1.cltcode) 
  and a.cltcode=l1.cltcode and a.accat=4 and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode and
  b.branch_cd=@statusname and b.short_name=c1.trader
  order by l1.acname,vdt,vtyp,vno1,refno */
 end

if @statusid='subbroker'
 begin
  select vdt=convert(varchar,vdt,101), c1.cl_code,balamt ,l1.cltcode, l1.acname 
  from account.dbo.ledger l1, account.dbo.acmast a , client1 c1, client2 c2 , subbrokers sb
  where vdt = (select max(vdt) from account.dbo.ledger l where vdt <=@vdt +' 23:59:59' and l.cltcode =l1.cltcode) 
  and a.cltcode=l1.cltcode and a.accat=4 and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode 
  and sb.sub_broker=c1.sub_broker
  and sb.sub_broker=@statusname
  order by l1.acname,vdt,vtyp,vno,vno1,lno,drcr
  /*select vdt, c1.cl_code,balamt ,l1.cltcode, l1.acname 
  from ledger l1, acmast a , msajag.dbo.client1 c1, msajag.dbo.client2 c2 , msajag.dbo.subbrokers sb
  where vdt = (select max(vdt) from ledger l where vdt <=@vdt +' 23:59:59' and l.cltcode =l1.cltcode) 
  and a.cltcode=l1.cltcode and a.accat=4 and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode 
  and sb.sub_broker=c1.sub_broker
  and sb.sub_broker=@statusname
  order by l1.acname,vdt,vtyp,vno1,refno*/
 end if @statusid='trader'
 begin
  select vdt=convert(varchar,vdt,101), c1.cl_code,balamt ,l1.cltcode, l1.acname 
  from account.dbo.ledger l1, account.dbo.acmast a , client1 c1, client2 c2 
  where vdt = (select max(vdt) from account.dbo.ledger l where vdt <=@vdt + ' 23:59:59' and l.cltcode =l1.cltcode) 
  and a.cltcode=l1.cltcode and a.accat=4 and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode 
  and c1.trader=@statusname
  order by l1.acname,vdt,vtyp,vno,vno1,lno,drcr 
  /*select vdt, c1.cl_code,balamt ,l1.cltcode, l1.acname 
  from ledger l1, acmast a , msajag.dbo.client1 c1, msajag.dbo.client2 c2 
  where vdt = (select max(vdt) from ledger l where vdt <=@vdt + ' 23:59:59' and l.cltcode =l1.cltcode) 
  and a.cltcode=l1.cltcode and a.accat=4 and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode 
  and c1.trader=@statusname
  order by l1.acname,vdt,vtyp,vno1,refno */
 end

 if @statusid='client'
 begin
  select vdt=convert(varchar,vdt,101), c1.cl_code,balamt ,l1.cltcode, l1.acname 
  from account.dbo.ledger l1, account.dbo.acmast a , client1 c1, client2 c2 
  where vdt = (select max(vdt) from account.dbo.ledger l where vdt <=@vdt +' 23:59:59' and l.cltcode =l1.cltcode) 
  and a.cltcode=l1.cltcode and a.accat=4 and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode 
  and l1.cltcode=@statusname
  order by l1.acname,vdt,vtyp,vno,vno1,lno,drcr
  /*select vdt, c1.cl_code,balamt ,l1.cltcode, l1.acname 
  from ledger l1, acmast a , msajag.dbo.client1 c1, msajag.dbo.client2 c2 
  where vdt = (select max(vdt) from ledger l where vdt <=@vdt +' 23:59:59' and l.cltcode =l1.cltcode) 
  and a.cltcode=l1.cltcode and a.accat=4 and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode 
  and l1.cltcode=@statusname
  order by l1.acname,vdt,vtyp,vno1,refno */
 end

 if @statusid='family'
 begin
  select vdt=convert(varchar,vdt,101), c1.cl_code,balamt ,l1.cltcode, l1.acname 
  from account.dbo.ledger l1, account.dbo.acmast a , client1 c1, client2 c2 
  where vdt = (select max(vdt) from account.dbo.ledger l where vdt <=@vdt +' 23:59:59' and l.cltcode =l1.cltcode) 
  and a.cltcode=l1.cltcode and a.accat=4 and c1.cl_code=c2.cl_code and  c2.party_code=l1.cltcode 
 and c1.family=@statusname
order by l1.acname,vdt,vtyp,vno,vno1,lno,drcr
end

GO
