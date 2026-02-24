-- Object: PROCEDURE dbo.rpt_mishisrep
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mishisrep    Script Date: 04/27/2001 4:32:44 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mishisrep    Script Date: 3/21/01 12:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mishisrep    Script Date: 20-Mar-01 11:39:00 PM ******/










/* report : misnews 
   file: historyreport.asp
*/
/* displays trades confirmed for a paticular client  for a particular date */
/* changed by mousami on 6th mar 2001
     added family login
*/

CREATE PROCEDURE rpt_mishisrep
@statusid varchar(15),
@statusname varchar(25),
@name varchar(21),
@scrip varchar(10),
@code varchar(10),
@trader varchar(15),
@sdate varchar(12),
@series varchar(3)

AS

if @statusid='broker'
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code , t4.markettype
from trade t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@name)+'%' and t4.Scrip_cd like ltrim(@scrip)+'%'
and t4.party_code like ltrim(@code)+'%'
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and series like ltrim(@series)+'%'
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code ,  t4.markettype
from settlement t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@name)+'%' and t4.Scrip_cd like ltrim(@scrip)+'%'
and t4.party_code like ltrim(@code)+'%'
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and series like ltrim(@series)+'%'
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,  t4.markettype 
from history t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@name)+'%' and t4.Scrip_cd like  ltrim(@scrip)+'%'
and t4.party_code like ltrim(@code)+'%'
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and series like ltrim(@series)+'%'
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end

if @statusid='branch'
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code, t4.markettype 
from trade t4,client1 c1,client2 c2, branches b
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@name)+'%' and t4.Scrip_cd like ltrim(@scrip)+'%'
and t4.party_code like ltrim(@code)+'%'
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and b.branch_cd=@statusid and b.short_name=c1.trader
and series like ltrim(@series)+'%'
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code, t4.markettype 
from settlement t4,client1 c1,client2 c2, branches b
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@name)+'%' and t4.Scrip_cd like ltrim(@scrip)+'%'
and t4.party_code like ltrim(@code)+'%'
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and b.branch_cd=@statusid and b.short_name=c1.trader
and series like ltrim(@series)+'%'
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code, t4.markettype 
from history t4,client1 c1,client2 c2, branches b
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@name)+'%' and t4.Scrip_cd like  ltrim(@scrip)+'%'
and t4.party_code like ltrim(@code)+'%'
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and b.branch_cd=@statusid and b.short_name=c1.trader
and series like ltrim(@series)+'%'
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end

if @statusid='subbroker'
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code , t4.markettype
from trade t4,client1 c1,client2 c2, subbrokers sb
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@name)+'%' and t4.Scrip_cd like ltrim(@scrip)+'%'
and t4.party_code like ltrim(@code)+'%'
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
and series like ltrim(@series)+'%'
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code, t4.markettype 
from settlement t4,client1 c1,client2 c2, subbrokers sb
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@name)+'%' and t4.Scrip_cd like ltrim(@scrip)+'%'
and t4.party_code like ltrim(@code)+'%'
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
and series like ltrim(@series)+'%'
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code, t4.markettype 
from history t4,client1 c1,client2 c2, subbrokers sb
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@name)+'%' and t4.Scrip_cd like  ltrim(@scrip)+'%'
and t4.party_code like ltrim(@code)+'%'
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
and series like ltrim(@series)+'%'
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end


if @statusid='trader'
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code , t4.markettype
from trade t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@name)+'%' and t4.Scrip_cd like ltrim(@scrip)+'%'
and t4.party_code like ltrim(@code)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and c1.trader=@statusname
and series like ltrim(@series)+'%'
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code , t4.markettype
from settlement t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@name)+'%' and t4.Scrip_cd like ltrim(@scrip)+'%'
and t4.party_code like ltrim(@code)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and c1.trader=@statusname
and series like ltrim(@series)+'%'
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code , t4.markettype
from history t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@name)+'%' and t4.Scrip_cd like  ltrim(@scrip)+'%'
and t4.party_code like ltrim(@code)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and c1.trader=@statusname
and series like ltrim(@series)+'%'
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end

if @statusid='client'
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code , t4.markettype
from trade t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code and t4.Scrip_cd like ltrim(@scrip)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and t4.party_code=@statusname
and series like ltrim(@series)+'%'
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code, t4.markettype 
from settlement t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
t4.Scrip_cd like ltrim(@scrip)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and t4.party_code=@statusname
and series like ltrim(@series)+'%'
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code, t4.markettype 
from history t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
t4.Scrip_cd like  ltrim(@scrip)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and t4.party_code=@statusname
and series like ltrim(@series)+'%'
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end


if @statusid='family'
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code , t4.markettype
from trade t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@name)+'%' and t4.Scrip_cd like ltrim(@scrip)+'%'
and t4.party_code like ltrim(@code)+'%'
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and series like ltrim(@series)+'%'
and c1.family=@statusname
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code ,  t4.markettype
from settlement t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@name)+'%' and t4.Scrip_cd like ltrim(@scrip)+'%'
and t4.party_code like ltrim(@code)+'%'
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and series like ltrim(@series)+'%'
and c1.family=@statusname
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,  t4.markettype 
from history t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@name)+'%' and t4.Scrip_cd like  ltrim(@scrip)+'%'
and t4.party_code like ltrim(@code)+'%'
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t4.sauda_date,103)=@sdate
and series like ltrim(@series)+'%'
and c1.family=@statusname
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end

GO
