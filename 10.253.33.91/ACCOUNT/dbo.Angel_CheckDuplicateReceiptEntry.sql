-- Object: PROCEDURE dbo.Angel_CheckDuplicateReceiptEntry
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE procedure Angel_CheckDuplicateReceiptEntry    
as    
    
select * into #bse_cr from ledger where vdt >='Jan 19 2008 00:00' and vtyp=2 and drcr='C'    
select * into #bse_dr from ledger where vdt >='Jan 19 2008 00:00' and vtyp=3 and drcr='D'    
    
select ddno,vno,lno into #chqnodr from ledger1 where vtyp=3 and vno >='200801190000'    
select ddno,vno,lno into #chqno from ledger1 where vtyp=2 and vno >='200801190000'    
    
select a.*,b.ddno into #bse1dr from #bse_dr a, #chqnodr b where a.vno=b.vno and a.lno=b.lno    
select a.*,b.ddno into #bse1 from #bse_cr a, #chqno b where a.vno=b.vno and a.lno=b.lno    
    
--where cltcode+'|'+convert(varchar(15),vamt)+'|'+convert(varchar(25),ddno)     
--in (select cltcode+'|'+convert(varchar(15),vamt)+'|'+convert(varchar(25),ddno)  from #bse1dr)    
    
    
delete from #bse1     
where cltcode+'|'+convert(varchar(25),ddno)     
in (select cltcode+'|'+convert(varchar(25),ddno)  from #bse1dr)    


------------------------------------------------
select 
MAXvno1=max(case when left(vno,3)='208' then '2008'+substring(vno,4,12) else vno end),
MINvno1=mIN(case when left(vno,3)='208' then '2008'+substring(vno,4,12) else vno end),
cltcode,vamt,ddno,lno 
into #xx
from #bse1 where ddno <> '0' 
group by cltcode,vamt,ddno,lno

select MAXVNO=
(case when len(MAXVNO1) > 12 THEN
'208'+substring(MAXvno1,5,12) ELSE MAXVNO1 END),
MINVNO=
(case when len(MINVNO1) > 12 THEN
'208'+substring(MINvno1,5,12) ELSE MINVNO1 END),
CLTCODE,VAMT,DDNO,LNO
INTO #YY
from #xx

--------------------    
    
    
select a.*,bvno=b.vno,bcltcode=b.cltcode,bvamt=b.vamt ,bddno=b.ddno     
into #bse_kand    
from    
--(select vno=min(vno),cltcode,vamt,ddno,lno from #bse1 where ddno <> '0' group by cltcode,vamt,ddno,lno) a,    
--(select vno=max(vno),cltcode,vamt,ddno,lno from #bse1 where ddno <> '0' group by cltcode,vamt,ddno,lno) b    
(select vno=MINVNO,cltcode,vamt,ddno,lno from #YY ) a,    
(select vno=MAXVNO,cltcode,vamt,ddno,lno from #YY ) b    
where a.ddno=b.ddno and a.vno <> b.vno    
and a.cltcode=b.cltcode and a.lno=b.lno     
and a.vamt=b.vamt    
    
delete from ledger where vno in (select bvno from #bse_kand where cltcode >='A0001' and cltcode <='ZZZZZ') and vtyp=2     
delete from ledger1 where vno in (select bvno from #bse_kand where cltcode >='A0001' and cltcode <='ZZZZZ') and vtyp=2     
delete from ledger2 where vno in (select bvno from #bse_kand where cltcode >='A0001' and cltcode <='ZZZZZ') and vtype=2     
delete from ledger3 where vno in (select bvno from #bse_kand where cltcode >='A0001' and cltcode <='ZZZZZ') and vtyp=2     
    
delete from ledger where vno in (select bvno from #bse_kand where cltcode ='5100000001' ) and vtyp=2     
delete from ledger1 where vno in (select bvno from #bse_kand where cltcode ='5100000001' ) and vtyp=2     
delete from ledger2 where vno in (select bvno from #bse_kand where cltcode ='5100000001' ) and vtype=2     
delete from ledger3 where vno in (select bvno from #bse_kand where cltcode ='5100000001' ) and vtyp=2

GO
