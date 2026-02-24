-- Object: PROCEDURE dbo.sbtranshistoryreport
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbtranshistoryreport    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbtranshistoryreport    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbtranshistoryreport    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbtranshistoryreport    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.sbtranshistoryreport    Script Date: 12/27/00 8:59:02 PM ******/

/**  file  = historyreport.asp
      report  client transaction 
displays details of trades for a particular day
   ***/
CREATE PROCEDURE
sbtranshistoryreport
@partyname varchar(21),
@scripcd varchar(10),
@partycode varchar(10),
@tradername varchar(15),
@tdate varchar(10),
@series varchar(2),
@subbroker varchar(15)
AS
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code
 from trade t4,client1 c1,client2 c2 , subbrokers sb
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%'
 and t4.Scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%'
and c1.trader like ltrim(@tradername)+'%' and t4.series like ltrim(@series)+'%'
 and convert(varchar,t4.sauda_date,103)= @tdate
and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
 union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, t4.marketrate,
t4.user_id,t4.sauda_date,t4.party_code from settlement t4, subbrokers sb,client1 c1,client2 c2
 where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name 
like  ltrim(@partyname)+'%' and t4.Scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%' 
and c1.trader like ltrim(@tradername)+'%' and t4.series like ltrim(@series)+'%' and convert(varchar,t4.sauda_date,103)= @tdate
and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
 union all 
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty,
 t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code from history t4,client1 c1,client2 c2 , subbrokers sb
 where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' and 
t4.Scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%'  and c1.trader like ltrim(@tradername)+'%' and t4.series like ltrim(@series)+'%' 
and convert(varchar,t4.sauda_date,103) = @tdate
and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date

GO
