-- Object: PROCEDURE dbo.rpt_tranhistoryrpt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_tranhistoryrpt    Script Date: 04/27/2001 4:32:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_tranhistoryrpt    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_tranhistoryrpt    Script Date: 20-Mar-01 11:39:04 PM ******/





/****** Object:  Stored Procedure dbo.rpt_tranhistoryrpt    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_tranhistoryrpt    Script Date: 12/27/00 8:58:58 PM ******/

/* report : client transaction 
   file : historyreport.asp
*/
/* changed by mousami on  17 mar 2001 
     added family login
*/

/* displays list of trades confirmed for a particular client or clients for a particular date */

CREATE PROCEDURE rpt_tranhistoryrpt
@statusid varchar(15),
@statusname varchar(25),
@partycode varchar(6),
@partyname varchar(21),
@scripcd varchar(12),
@series varchar(3),
@trader varchar(15),
@tdate varchar(10)
AS
if @statusid = 'broker' 
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, t4.marketrate,t4.user_id,
t4.sauda_date,t4.party_code,t4.markettype
from trade t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and t4.Scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%' and c1.trader like ltrim(@trader)+'%' 
and t4.series like ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like ltrim(@tdate)+'%' 
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,t4.markettype 
from settlement t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name 
like ltrim(@partyname)+'%' and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%' 
and c1.trader like  ltrim(@trader)+'%' and t4.series like  ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like  ltrim(@tdate)+'%' 
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty,
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,t4.markettype 
from history t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name 
like  ltrim(@partyname)+'%' and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%' and c1.trader like  ltrim(@trader)+'%' 
and t4.series like  ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like  ltrim(@tdate)+'%' 
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end
if @statusid = 'branch' 
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, t4.marketrate,t4.user_id,
t4.sauda_date,t4.party_code,t4.markettype 
from trade t4,client1 c1,client2 c2 ,branches b
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and t4.Scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%' and c1.trader like ltrim(@trader)+'%' 
and t4.series like ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like ltrim(@tdate)+'%' 
and b.branch_cd=@statusname and b.short_name=c1.trader
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,t4.markettype 
from settlement t4,client1 c1,client2 c2 ,branches b
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name 
like ltrim(@partyname)+'%' and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%' 
and c1.trader like  ltrim(@trader)+'%' and t4.series like  ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like  ltrim(@tdate)+'%' 
and b.branch_cd=@statusname and b.short_name=c1.trader
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty,
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,t4.markettype 
from history t4,client1 c1,client2 c2 ,branches b
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name 
like  ltrim(@partyname)+'%' and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%' and c1.trader like  ltrim(@trader)+'%' 
and t4.series like  ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like  ltrim(@tdate)+'%' 
and b.branch_cd=@statusname and b.short_name=c1.trader
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end
if @statusid = 'trader' 
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, t4.marketrate,t4.user_id,
t4.sauda_date,t4.party_code,t4.markettype 
from trade t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and t4.Scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%' and c1.trader =@statusname 
and t4.series like ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like ltrim(@tdate)+'%' 
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,t4.markettype 
from settlement t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name 
like ltrim(@partyname)+'%' and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%' 
and  c1.trader =@statusname and t4.series like  ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like  ltrim(@tdate)+'%' 
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty,
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,t4.markettype 
from history t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name 
like  ltrim(@partyname)+'%' and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%' 
and  c1.trader =@statusname
and t4.series like  ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like  ltrim(@tdate)+'%' 
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end 
if @statusid = 'subbroker' 
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, t4.marketrate,t4.user_id,
t4.sauda_date,t4.party_code,t4.markettype 
from trade t4,client1 c1,client2 c2 , subbrokers sb
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and t4.Scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%' and c1.trader like ltrim(@trader)+'%' 
and t4.series like ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like ltrim(@tdate)+'%' 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,t4.markettype 
from settlement t4,client1 c1,client2 c2 , subbrokers sb
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name 
like ltrim(@partyname)+'%' and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%' 
and c1.trader like  ltrim(@trader)+'%' and t4.series like  ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like  ltrim(@tdate)+'%' 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty,
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,t4.markettype 
from history t4,client1 c1,client2 c2 , subbrokers sb
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name 
like  ltrim(@partyname)+'%' and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%' and c1.trader like  ltrim(@trader)+'%' 
and t4.series like  ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like  ltrim(@tdate)+'%' 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end 
if @statusid = 'client' 
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, t4.marketrate,t4.user_id,
t4.sauda_date,t4.party_code ,t4.markettype
from trade t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and t4.Scrip_cd like ltrim(@scripcd)+'%' and t4.party_code =@statusname
and t4.series like ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like ltrim(@tdate)+'%' 
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,t4.markettype 
from settlement t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code =@statusname 
and t4.series like  ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like  ltrim(@tdate)+'%' 
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty,
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,t4.markettype 
from history t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code = @statusname 
and t4.series like  ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like  ltrim(@tdate)+'%' 
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end


if @statusid = 'family'
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, t4.marketrate,t4.user_id,
t4.sauda_date,t4.party_code,t4.markettype
from trade t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and t4.Scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%' and c1.trader like ltrim(@trader)+'%' 
and t4.series like ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like ltrim(@tdate)+'%' 
and c1.family=@statusname
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,t4.markettype 
from settlement t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name 
like ltrim(@partyname)+'%' and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%' 
and c1.trader like  ltrim(@trader)+'%' and t4.series like  ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like  ltrim(@tdate)+'%' 
and c1.family=@statusname
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty,
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,t4.markettype 
from history t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name 
like  ltrim(@partyname)+'%' and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%' and c1.trader like  ltrim(@trader)+'%' 
and t4.series like  ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103) like  ltrim(@tdate)+'%' 
and c1.family=@statusname
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end

GO
