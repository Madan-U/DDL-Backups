-- Object: PROCEDURE dbo.pms_scpdetails_STb_acdlcm
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE procedure pms_scpdetails_STb_acdlcm (@pmscode as varchar(10),@pmsname as varchar(50), @fdate as datetime, @tdate as datetime, @afdate as datetime, @loca as varchar(25))
as

--exec cldetails 'AA','08/01/2004','08/10/2004','04/01/2004'
-- fdate as fromdate
-- tdate as uptodate
-- afdate is accounting date from

/*
declare @pmscode as varchar(10)
declare @pmsname as varchar(10)
declare @fdate as datetime 
declare @tdate as datetime
declare @afdate as datetime
declare @loca as varchar(10)

set @pmscode = 'RAJEN'
set @pmsname = 'RAJEN'
set @fdate = '01/01/2001'
set @tdate = '10/18/2004'
set @afdate = '04/01/2004'
set @loca = 'SURAT'
*/

select pmscode=@pmscode,pmsname=@pmsname,clientid=scrip_Cd,
clientname=scrip_cd, netqty,
LEdger=0, open_position=isnull(open_position,0), bookpl=isnull(bookpl,0),
tradpl=isnull(tradpl,0), not_pl=isnull(not_pl,0),tover=isnull(tover,0),brokerage=isnull(brokerage,0)
from

(
select scrip_cd,not_pl=sum(case when netqty > 0 then open_position-(netqty*rate) else 0 end),
open_position=sum(case when netqty > 0 then open_position else 0 end),
bookpl=sum(bookpl), tradpl=sum(tradpl),tover=sum(tover),netqty=sum(case when netqty > 0 then netqty else 0 end),
brokerage=sum(brokerage) from 
(
select party_code, scrip_cd, netqty=sum(pqtydel-sqtydel),
tradpl=sum(pamttrd-samttrd), rate=isnull(rate,case when sum(pqtydel-sqtydel) <> 0 then sum(pamtdel-samtdel)/sum(pqtydel-sqtydel) else 0 end) ,
open_position=(case when sum(pqtydel-sqtydel)<>0 then sum(pamtdel-samtdel) else 0 end),
bookpl=(case when sum(pqtydel-sqtydel)=0 then sum(pamtdel-samtdel) else 0 end),
tover=sum(pamtdel+samtdel+pamttrd+samttrd),brokerage=sum(pbrokdel+sbrokdel+pbroktrd+sbroktrd)
from 
(
select a.*, b.rate from anand1.msajag.dbo.cmbillvalan a left outer join 
(select x.* from INTRANET.risk.dbo.cpcumm x, (select scode, mfdate=max(mfdate) 
from INTRANET.risk.dbo.cpcumm where mfdate <= @tdate+' 23:59:59.000' group by scode ) y 
where x.scode=y.scode and y.mfdate=x.mfdate
) b on b.scode=a.scrip_cd 
) CM,
(select * from INTRANET.PMS_ST.DBO.CLIENTMAST WHERE PMSCODE=@pmscode and eff_to >= @tdate and location LIKE @loca) CL
where cl.clientid=cm.party_Code and sauda_date >= cl.eff_from+'00:00:00.00' and sauda_date <= @tdate+'23:59:59.000'
group by party_code, scrip_cd, rate
) tvalan
group by scrip_cd

) aa
--(select scrip_name=scrip_cd,bsecode from bsedb_ab.dbo.scrip2) scp where aa.scrip_Cd=scp.bsecode

--) valan on valan.party_Code=ledger.cltcode 
--on ledger.cltcode=cl.clientid
--where 
--pms.pmscode=cl.pmscode and cl.clientid=ledger.cltcode and pms.pmscode=@pmscode
order by scrip_cd

GO
