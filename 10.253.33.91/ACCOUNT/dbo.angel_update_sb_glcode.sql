-- Object: PROCEDURE dbo.angel_update_sb_glcode
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE procedure angel_update_sb_glcode  
as  
  
set transaction isolation level read uncommitted  
set nocount on  


select * into #file1 from mis.remisior.dbo.remi_ledcode where coname='ACDLCM' AND LEDGERCODE <> '' 
  
insert into acmast  
select   
name,name,'LIABILITIE',3,'BOI01',ledgercode,name,'L0403000000','',0,branch_Code,0,'P','HDFC BANK','',''  
from #file1 a, (select distinct sub_Broker, Name, branch_code from MSAJAG.dbo.subbrokers )b where a.sbcode=b.sub_Broker   
and ledgercode not in (select cltcode from acmast)   



select distinct subbrokercode,srname,calctype,c.branch_Code 
into #abc
from (select subbrokercode,calctype from mis.remisior.dbo.angelsubbrok where company='ACDLCM') a,
(SELECT srcode,srname from mis.remisior.dbo.srmast where company='ACDLCM') b,
(select sub_Broker,branch_code from msajag.dbo.subbrokers ) c
where a.subbrokercode=b.srcode and c.sub_Broker=a.calctype

select distinct subbrokercode,srname,branch_code into #fff from #abc

--- audit system required
/*
update #abc set branch_code = b.branch_code from #fff b where #abc.subbrokercode=b.subbrokercode
drop table #fff

select subbrokercode,srname,branch_Code from #abc

update #fff set branch_code='XF' where subbrokercode = 'MJJ1'
update #fff set branch_code='HO' where subbrokercode = 'MRU1'
update #fff set branch_code='BVI' where subbrokercode = 'RMK1'
update #fff set branch_code='YB' where subbrokercode = 'VCM1'
update #fff set branch_code='XD' where subbrokercode = 'VSG1'

select * from #fff where subbrokercode in 
(select subbrokercode  from #fff group by subbrokercode having count(*) > 1)

select * from #abc where subbrokercode in 
(select subbrokercode  from #fff group by subbrokercode having count(*) > 1)
*/
--------------------------------

insert into acmast  
select   
name,name,'LIABILITIE',3,'BOI01',ledgercode,name,'L0403000000','',0,branch_Code,0,'P','HDFC BANK','',''  
from #file1 a, 
(
select sub_Broker=subbrokercode,name=srname,branch_code from #fff
)b where a.sbcode=b.sub_Broker   
and ledgercode not in (select cltcode from acmast)

GO
