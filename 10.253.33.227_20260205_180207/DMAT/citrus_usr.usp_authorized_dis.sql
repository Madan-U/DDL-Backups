-- Object: PROCEDURE citrus_usr.usp_authorized_dis
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


CREATE proc [citrus_usr].[usp_authorized_dis]
as begin

declare @entrydate date=cast( getdate() as date) 


select * into #angel from tbl_DIS_Request_Status
--where counter_dpid  in ('12033201','12033200') and cast([entryon] as date)  = @entrydate
where  cast([entryon] as date)  = @entrydate


--select   ITPAN as counterpan from AngelDP4.dmat.dbo.TBL_CLIENT_MASTER cm where client_code in 
--(select counter_dpid + counter_account as dp from #angel) 

select   ITPAN as targetpan,a.targetdp,a.inst_id into #target from(select ITPAN,client_code from AngelDP4.dmat.dbo.TBL_CLIENT_MASTER) cm  join 
(select counter_dpid + counter_account as targetdp,inst_id from #angel)  a
on cm.client_code=a.targetdp

select   ITPAN as soucepan,a.sourcedp,a.inst_id into #source from(select ITPAN,client_code from AngelDP4.dmat.dbo.TBL_CLIENT_MASTER) cm  join 
(select accountno as sourcedp,inst_id from #angel)  a
on cm.client_code=a.sourcedp


select  c.party_code,c.sub_broker,sb.panno sbpan,t.* into #targetclient from [AngelNseCM].msajag.dbo.client_details c join #target t 
on t.targetpan=c.pan_gir_no
join (select sbtag,panno from MIS.SB_COMP.dbo.sb_broker)sb
on sb.sbtag=c.sub_broker


--case 0

--Source should no sb 

select distinct soucepan,s.sourcedp,s.inst_id into #rejectedforsb from #source s  join 
(select  sbtag,panno from MIS.SB_COMP.dbo.sb_broker )sb
on s.soucepan=sb.panno


update s 
set s.Status ='Hold',reason='Off-market transaction received from broker' from (select * from tbl_DIS_Request_Status
where   cast([entryon] as date)  = @entrydate and status<>'Hold'
) s join #rejectedforsb r 
on r.inst_id=s.inst_id



select t.* into #rejected from #targetclient t
join  #source s
on t.inst_id=s.inst_id and t.sbpan=s.soucepan

update s 
set s.Status ='Hold',reason='Off-market transaction received from mapped client' from (select * from tbl_DIS_Request_Status
where   cast([entryon] as date)  = @entrydate and status<>'Hold'
) s join #rejected r 
on r.inst_id=s.inst_id



print ('case 2')

---case 2




IF OBJECT_ID(N'tempdb..#target') IS NOT NULL
DROP TABLE #target

IF OBJECT_ID(N'tempdb..#source') IS NOT NULL
DROP TABLE #source


IF OBJECT_ID(N'tempdb..#rejected') IS NOT NULL
DROP TABLE #rejected




--select * into #angel from tbl_DIS_Request_Status
--where left(counter_dpid,8)  in ('12033201','12033200') and cast([entryon] as date)  = @entrydate


select   ITPAN as targetpan,a.targetdp,a.inst_id into #target_ from(select ITPAN,client_code from AngelDP4.dmat.dbo.TBL_CLIENT_MASTER) cm  join 
(select counter_dpid + counter_account as targetdp,inst_id from #angel)  a
on cm.client_code=a.targetdp

select   ITPAN as soucepan,a.sourcedp,a.inst_id into #source_ from(select ITPAN,client_code from AngelDP4.dmat.dbo.TBL_CLIENT_MASTER) cm  join 
(select accountno as sourcedp,inst_id from #angel)  a
on cm.client_code=a.sourcedp



select  c.party_code,c.sub_broker,sb.panno sbpan,t.* into #source_client from [AngelNseCM].msajag.dbo.client_details c join #source_ t 
on t.soucepan=c.pan_gir_no
join (select sbtag,panno from MIS.SB_COMP.dbo.sb_broker)sb
on sb.sbtag=c.sub_broker



--case 0

--Target should no sb 

select distinct targetpan,t.targetdp,t.inst_id into #rejectedforsb_ from #target_ t  join 
(select  sbtag,panno from MIS.SB_COMP.dbo.sb_broker )sb
on t.targetpan=sb.panno


update s 
set s.Status ='Hold',reason='Off-market transaction received to broker' from (select * from tbl_DIS_Request_Status
where cast([entryon] as date)  = @entrydate and status<>'Hold'
) s join #rejectedforsb_ r 
on r.inst_id=s.inst_id




select t.* into #rejected_   from #source_client s
join  #target_ t
on t.inst_id=s.inst_id and t.targetpan=s.sbpan


update s 
set s.Status ='Hold',reason='Off-market transaction received from mapped client' from (select * from tbl_DIS_Request_Status
where   cast([entryon] as date)  = @entrydate and status<>'Hold'
) s join #rejected_ r 
on r.inst_id=s.inst_id




drop table #angel
drop table #target_
drop table #source_

drop table #source_client
drop table #rejected_

end

GO
