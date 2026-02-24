-- Object: PROCEDURE dbo.rpt_bseageing
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bseageing    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bseageing    Script Date: 11/28/2001 12:23:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseageing    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseageing    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseageing    Script Date: 8/7/01 6:03:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseageing    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseageing    Script Date: 2/17/01 3:34:16 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bseageing    Script Date: 20-Mar-01 11:43:34 PM ******/

/* report : ageing report 
   file : ageingreport.asp
*/
/* shows last balances of a client  as on a particular date */
CREATE PROCEDURE rpt_bseageing
@statusid varchar(15),
@statusname varchar(25),
@vdt varchar(12)
AS
if @statusid='broker'
begin
select vdt, c1.cl_code,balamt ,l1.cltcode, l1.acname 
from ledger l1, acmast a , bsedb.dbo.client1 c1, bsedb.dbo.client2 c2 
where vdt = (select max(vdt) from ledger l where vdt <=@vdt +' 23:59:59' and l.cltcode =l1.cltcode) 
and a.cltcode=l1.cltcode and a.accat=4 and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode 
order by l1.acname,vdt,vtyp,vno1,refno 
end
if @statusid='branch'
begin
select vdt, c1.cl_code,balamt ,l1.cltcode, l1.acname 
from ledger l1, acmast a ,bsedb.dbo.client1 c1, bsedb.dbo.client2 c2 , bsedb.dbo.branches b
where vdt = (select max(vdt) from ledger l where vdt <=@vdt +' 23:59:59' and l.cltcode =l1.cltcode) 
and a.cltcode=l1.cltcode and a.accat=4 and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode and
b.branch_cd=@statusname and b.short_name=c1.trader
order by l1.acname,vdt,vtyp,vno1,refno 
end
if @statusid='subbroker'
begin
select vdt, c1.cl_code,balamt ,l1.cltcode, l1.acname 
from ledger l1, acmast a , bsedb.dbo.client1 c1, bsedb.dbo.client2 c2 ,bsedb.dbo.subbrokers sb
where vdt = (select max(vdt) from ledger l where vdt <=@vdt +' 23:59:59' and l.cltcode =l1.cltcode) 
and a.cltcode=l1.cltcode and a.accat=4 and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode 
and sb.sub_broker=c1.sub_broker
and sb.sub_broker=@statusname
order by l1.acname,vdt,vtyp,vno1,refno 
end
if @statusid='trader'
begin
select vdt, c1.cl_code,balamt ,l1.cltcode, l1.acname 
from ledger l1, acmast a , bsedb.dbo.client1 c1, bsedb.dbo.client2 c2 
where vdt = (select max(vdt) from ledger l where vdt <=@vdt + ' 23:59:59' and l.cltcode =l1.cltcode) 
and a.cltcode=l1.cltcode and a.accat=4 and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode 
and c1.trader=@statusname
order by l1.acname,vdt,vtyp,vno1,refno 
end
if @statusid='client'
begin
select vdt, c1.cl_code,balamt ,l1.cltcode, l1.acname 
from ledger l1, acmast a , bsedb.dbo.client1 c1,bsedb.dbo.client2 c2 
where vdt = (select max(vdt) from ledger l where vdt <=@vdt +' 23:59:59' and l.cltcode =l1.cltcode) 
and a.cltcode=l1.cltcode and a.accat=4 and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode 
and l1.cltcode=@statusname
order by l1.acname,vdt,vtyp,vno1,refno 
end

GO
