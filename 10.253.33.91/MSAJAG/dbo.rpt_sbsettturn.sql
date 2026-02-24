-- Object: PROCEDURE dbo.rpt_sbsettturn
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_sbsettturn    Script Date: 04/27/2001 4:32:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbsettturn    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbsettturn    Script Date: 20-Mar-01 11:39:03 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbsettturn    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbsettturn    Script Date: 12/27/00 8:58:58 PM ******/

/* report : subroksett
   file : subbrokturn.asp
*/
/* displays total buy and sell (qty and amt) of a particular subbroker till today */
CREATE PROCEDURE rpt_sbsettturn
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid='subbroker'
begin
select sb.sub_broker,s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from settlement s, client1 c1, client2 c2, subbrokers sb
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@statusname
group by sb.sub_broker,s.sell_buy
union all
select sb.sub_broker,s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from history s, client1 c1, client2 c2, subbrokers sb
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@statusname
group by sb.sub_broker,s.sell_buy
order by sb.sub_broker,s.sell_buy
end
if @statusid='broker'
begin
select sb.sub_broker ,s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from settlement s, client1 c1, client2 c2, subbrokers sb
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker 
group by sb.sub_broker,s.sell_buy
union all
select sb.sub_broker, s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from history s, client1 c1, client2 c2, subbrokers sb
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker 
group by sb.sub_broker,s.sell_buy
order by sb.sub_broker,s.sell_buy
end

GO
