-- Object: PROCEDURE dbo.Angel_checkUnpostedReceiptEntry
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

create procedure Angel_checkUnpostedReceiptEntry
as

select * into #bse_cr from ledger where vdt >='Jan 21 2008 00:00' and vtyp=2 and drcr='C'
select ddno,vno,lno into #chqno from ledger1 where vtyp=2 and vno >='200801210000'
select a.*,b.ddno into #bse1 from #bse_cr a, #chqno b where a.vno=b.vno and a.lno=b.lno

select * into #aa from intranet.testdb.dbo.payin where posted_status='Y' and segment='ACDLCM' 
and vdate >='Jan 21 2008 00:00'

update #aa set ddno=REPLACE(DDNO,' ','')
update #aa set ddno=REPLACE(DDNO,'A','4')
update #aa set ddno=REPLACE(DDNO,'','/')
update #aa set ddno=REPLACE(DDNO,'O','0')

update #BSE1 set ddno=REPLACE(DDNO,' ','')
update #BSE1 set ddno=REPLACE(DDNO,'A','4')
update #BSE1 set ddno=REPLACE(DDNO,'','/')
update #BSE1 set ddno=REPLACE(DDNO,'O','0')




select * from (select * from #aa where len(ddno)<= 7 )a 
left outer join (
select * from #bse1 where len(ddno)<= 7
) b 
on a.cltcode=b.cltcode and  convert(int,a.ddno)=convert(int,b.ddno)
where isnull(b.ddno,0)=0 



update intranet.testdb.dbo.payin 
set posted_status='N'
where srno in
(
select srno
from (select * from #aa where len(ddno)<= 7 )a 
left outer join (select * from #bse1 where len(ddno)<= 7) b 
on a.cltcode=b.cltcode and  convert(int,a.ddno)=convert(int,b.ddno)
where isnull(b.ddno,0)=0 
) and segment='ACDLCM'

GO
