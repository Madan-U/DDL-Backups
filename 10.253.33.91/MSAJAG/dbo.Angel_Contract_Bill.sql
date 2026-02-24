-- Object: PROCEDURE dbo.Angel_Contract_Bill
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

Create Proc Angel_Contract_Bill(@fdate as varchar(11))
as

set @fdate = convert(varchar(11),convert(datetime,@fdate,103))

select Party_code,SCRIP_CD,BILLFLAG,COUNT(*) AS Cnt into #x from SETTLEMENT (nolock)
where convert(varchar(11),sauda_date) = @fdate group by Party_code,SCRIP_CD,BILLFLAG

select 
case when x.Party_code is null then y.Party_code else x.Party_code end as Party_code,
case when x.scrip_cd is null then y.scrip_cd else x.scrip_cd end as scrip_cd,
isnull(x.trading,0) as trading,
isnull(y.del,0) as del into #y
from
(select Party_code,Scrip_cd,sum(cnt) as Trading from #x where BILLFLAG in ('2','3') group by Scrip_cd,Party_code)x
full outer join
(select Party_code,Scrip_cd,sum(cnt) as Del from #x where BILLFLAG in ('4','5') group by Scrip_cd,Party_code) y
on x.scrip_cd = y.scrip_cd and x.Party_code = y.Party_code

select @fdate as UPD_Date,'NSECM' as Segment,Party_Code,
'' as Branch_Cd, '' as Sub_Broker, '' as Contract,
ceiling((convert(dec,case when sum(trading) <> 0 and sum(del) <> 0 then sum(trading)+sum(del)+3 else sum(trading)+sum(del)+2 end)+9)/31) as ConCumBill
from #y group by party_code

GO
