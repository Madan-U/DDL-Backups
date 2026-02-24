-- Object: PROCEDURE dbo.brhisrep
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brhisrep    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brhisrep    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brhisrep    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brhisrep    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brhisrep    Script Date: 12/27/00 8:58:44 PM ******/

CREATE PROCEDURE brhisrep
@br varchar(3),
@shortname varchar(21),
@scripcd varchar(10),
@partycode varchar(10),
@trader varchar(15),
@series varchar(2),
@sdate varchar(10)
AS
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code 
from trade t4,client1 c1,client2 c2,branches b 
where c2.party_code = t4.party_code 
and b.short_name = c1.trader and b.branch_cd = @br
and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@shortname) +'%' 
and t4.Scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%' 
and c1.trader like ltrim(@trader)+'%' and t4.series like ltrim(@series)+'%' 
and convert(varchar,t4.sauda_date,103)= @sdate 
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty,
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code 
from settlement t4,client1 c1,client2 c2,branches b 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and b.short_name = c1.trader and b.branch_cd = @br
and c1.short_name like ltrim(@shortname) +'%' and t4.Scrip_cd like ltrim(@scripcd)+'%' 
and t4.party_code like ltrim(@partycode)+'%' and c1.trader like ltrim(@trader)+'%' and t4.series like ltrim(@series)+'%' 
and convert(varchar,t4.sauda_date,103)= @sdate 
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty,
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code 
from history t4,client1 c1,client2 c2,branches b 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and b.short_name = c1.trader and b.branch_cd = @br
and c1.short_name like ltrim(@shortname) +'%' and t4.Scrip_cd like ltrim(@scripcd)+'%' 
and t4.party_code like ltrim(@partycode)+'%' and c1.trader like ltrim(@trader)+'%' and t4.series like ltrim(@series)+'%' 
and convert(varchar,t4.sauda_date,103)= @sdate
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date

GO
