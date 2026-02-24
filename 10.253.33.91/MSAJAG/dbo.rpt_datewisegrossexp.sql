-- Object: PROCEDURE dbo.rpt_datewisegrossexp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*  report : datewise gross exposure */
/* finds all trades of a party for settlement types with albm effect */

/* report : datewise gross exposure */

CREATE PROCEDURE rpt_datewisegrossexp

@settno varchar(7),
@trader varchar(15),
@party varchar(10),
@scripcd varchar(12),
@name varchar(25),
@sauda_date varchar(25) 

AS



select sett_no, sett_type, a.party_code, c1.short_name, c1.trader, scrip_cd , sett_type, qty=isnull(sum(tradeqty),0), amount = isnull(sum(tradeqty*marketrate),0), sell_buy
from rpt_datesettnormal a, client1 c1, client2 c2
where c1.cl_code=c2.cl_code and c2.party_code=a.party_code
and c1.trader like ltrim(@trader)+'%' and a.party_code like ltrim(@party)+'%' and scrip_cd like ltrim(@scripcd)+'%' and c1.short_name like ltrim(@name)+'%'  
and sett_no=@settno 
and a.sauda_date <=@sauda_date  + ' 23:59:59'
group by sett_no,a.party_code,c1.short_name,c1.trader,scrip_cd,sett_type,sell_buy
union all
select sett_no, sett_type, a.party_code, c1.short_name, c1.trader, scrip_cd  , sett_type,  isnull(sum(tradeqty),0), amount = isnull(sum(tradeqty*a.rate),0),sell_buy
from  rpt_dategrossexpoppalbmScrip   a, client1 c1, client2 c2
where c1.cl_code=c2.cl_code and c2.party_code=a.party_code
and c1.trader like ltrim(@trader)+'%' and a.party_code like ltrim(@party)+'%' and scrip_cd like ltrim(@scripcd)+'%' and c1.short_name like ltrim(@name)+'%'  
and sauda_date <=@sauda_date  + ' 23:59:59'
and sett_no=@settno 
group by sett_no,a.party_code,c1.short_name,c1.trader,scrip_cd,sett_type,sell_buy
order by sett_no,a.party_code,c1.short_name,c1.trader,scrip_cd,sett_type,sell_buy

GO
