-- Object: PROCEDURE dbo.rpt_datewisegrossexpscrdtl
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/* datewise gross exposure  */
/* displays datewise sum of buy and sell figures for a settlement number and type with albm effect */


CREATE PROCEDURE   rpt_datewisegrossexpscrdtl


@trader varchar(15),
@party varchar(10),
@scripcd varchar(12),
@name varchar(21),
@settype varchar(3),
@settno varchar(7),
@fdate varchar(25)


as
select  sett_type, a.party_code, sdate=left(convert(varchar,sauda_date,109),11), c1.short_name, c1.trader, scrip_cd , sett_type,qty=sum(qty), amount=sum(amount) , sell_buy
from scripdetail  a, client1 c1, client2 c2
where c1.cl_code=c2.cl_code and c2.party_code=a.party_code
and c1.trader like ltrim(@trader)+'%' and a.party_code like ltrim(@party)+'%' and scrip_cd like ltrim(@scripcd)+'%' and c1.short_name like ltrim(@name)+'%'  
and sett_type=@settype
and sett_no=@settno 
and sauda_date <= ltrim(@fdate) + ' 23:59:59'
group by left(convert(varchar,sauda_date,109),11),a.party_code,c1.short_name,c1.trader,scrip_cd,sett_type,sell_buy
order by left(convert(varchar,sauda_date,109),11),a.party_code,c1.short_name,c1.trader,scrip_cd,sett_type,sell_buy

GO
