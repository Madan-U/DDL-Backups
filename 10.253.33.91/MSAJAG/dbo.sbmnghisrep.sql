-- Object: PROCEDURE dbo.sbmnghisrep
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmnghisrep    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbmnghisrep    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.sbmnghisrep    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbmnghisrep    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmnghisrep    Script Date: 12/27/00 8:59:00 PM ******/

/*** File : historyreport.asp
     Report : Management Info
displays details of trade for a particular day 
 ***/  
CREATE PROCEDURE sbmnghisrep
@subbroker varchar(15),
@partyname varchar(21),
@scripcd varchar(10),
@partycode varchar(10),
@tradername varchar(15),
@tdate varchar(10)
AS
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code 
from trade t4,client1 c1,client2 c2, subbrokers sb
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.sub_broker = sb.sub_broker and
sb.sub_broker = @subbroker and
c1.short_name like ltrim(@partyname)+'%' and t4.Scrip_cd like ltrim(@scripcd)+'%'
and t4.party_code like ltrim(@partycode)+'%'
and c1.trader like ltrim(@tradername)+'%'
and convert(varchar,t4.sauda_date,101)=@tdate
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code 
from settlement t4,client1 c1,client2 c2, subbrokers sb 
where c2.party_code = t4.party_code and 
c1.sub_broker = sb.sub_broker and
sb.sub_broker = @subbroker and
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@partyname)+'%' and t4.Scrip_cd like ltrim(@scripcd)+'%'
and t4.party_code like ltrim(@partycode)+'%'
and c1.trader like ltrim(@tradername)+'%'
and convert(varchar,t4.sauda_date,101)=@tdate
union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code 
from history t4,client1 c1,client2 c2, subbrokers sb
where c2.party_code = t4.party_code and 
c1.sub_broker = sb.sub_broker and
sb.sub_broker = @subbroker and
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@partyname)+'%' and t4.Scrip_cd like ltrim(@scripcd)+'%'
and t4.party_code like ltrim(@partycode)+'%'
and c1.trader like ltrim(@tradername)+'%'
and convert(varchar,t4.sauda_date,101)=@tdate
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date

GO
