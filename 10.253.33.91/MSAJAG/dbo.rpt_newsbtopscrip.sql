-- Object: PROCEDURE dbo.rpt_newsbtopscrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_newsbtopscrip    Script Date: 04/27/2001 4:32:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newsbtopscrip    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newsbtopscrip    Script Date: 20-Mar-01 11:39:01 PM ******/









/* report : misnews
   file : topscrip_sett.asp
*/

/* changed by mousami on 06/02/2001
     added family login
*/     
CREATE PROCEDURE rpt_newsbtopscrip
@statusid varchar(15),
@statusname varchar(25)

AS

if @statusid='broker'
begin
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'eq'
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topsc) */
union all
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'be'
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topscw)*/
union all
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'ae'
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
union all
select series='BE',t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and (t.series ='01' or t.series='02' or t.series='03' or  t.series='04' or t.series='05') 
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topscm)*/
order by  t.scrip_cd,t.series,t.markettype,t.sell_Buy
end 

if @statusid='branch'
begin
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1, branches b
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'eq'
and b.branch_cd=@statusname and b.short_name=c1.trader
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topsc)*/
union all
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1, branches b
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'be'
and b.branch_cd=@statusname and b.short_name=c1.trader
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topscw)*/
union all
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1, branches b
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'ae'
and b.branch_cd=@statusname and b.short_name=c1.trader
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topscm)*/
union all
select series='BE',t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1, branches b
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and (t.series ='01' or t.series='02' or t.series='03' or  t.series='04' or t.series='05') 
and b.branch_cd=@statusname and b.short_name=c1.trader
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
order by  t.scrip_cd,t.series,t.markettype,t.sell_Buy
end 

if @statusid='subbroker'
begin
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1, subbrokers sb
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'eq'
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topsc)*/
union all
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1, subbrokers sb

where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'be'
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topscw)*/
union all
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1, subbrokers sb
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'ae'
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topscm)*/
union all
select series='BE',t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1,subbrokers sb
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and (t.series ='01' or t.series='02' or t.series='03' or  t.series='04' or t.series='05') 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
order by  t.scrip_cd,t.series,t.markettype,t.sell_Buy
end 


if @statusid='trader'

begin
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'eq'
and c1.trader=@statusname
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topsc)*/
union all
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'be'
and c1.trader=@statusname
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topscw)*/
union all
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'ae'
and c1.trader=@statusname
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topscm)*/
union all
select series='BE',t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and (t.series ='01' or t.series='02' or t.series='03' or  t.series='04' or t.series='05') 
and c1.trader=@statusname
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
order by  t.scrip_cd,t.series,t.markettype,t.sell_Buy
end 

if @statusid='client'
begin
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'eq' and
t.party_code=@statusname
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topsc)*/
union all
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'be' and
t.party_code=@statusname
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topscw) */
union all
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'ae' and
t.party_code=@statusname
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topscm)*/
union all
select series='BE',t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and (t.series ='01' or t.series='02' or t.series='03' or  t.series='04' or t.series='05') 
and t.party_code=@statusname
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
order by  t.scrip_cd,t.series,t.markettype,t.sell_Buy
end 



if @statusid='family'
begin
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'eq'
and c1.family=@statusname
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topsc) */
union all
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'be'
and c1.family=@statusname
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topscw)*/
union all
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'ae'
and c1.family=@statusname
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
union all
select series='BE',t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy,t.markettype 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and (t.series ='01' or t.series='02' or t.series='03' or  t.series='04' or t.series='05') 
and c1.family=@statusname
group by  t.series,t.scrip_cd,t.markettype,t.sell_Buy 
/*having sum(t.tradeqty * t.marketrate) >convert(money,@topscm)*/
order by  t.scrip_cd,t.series,t.markettype,t.sell_Buy
end

GO
