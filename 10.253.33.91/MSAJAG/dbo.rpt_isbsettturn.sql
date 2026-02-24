-- Object: PROCEDURE dbo.rpt_isbsettturn
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_isbsettturn    Script Date: 04/27/2001 4:32:43 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isbsettturn    Script Date: 3/21/01 12:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isbsettturn    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isbsettturn    Script Date: 2/5/01 12:06:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isbsettturn    Script Date: 12/27/00 8:59:12 PM ******/

/* report : subroksett
   file : subbrokturn.asp
*/
/* displays total buy and sell (qty and amt) of a particular subbroker till today for institutional trades */
CREATE PROCEDURE rpt_isbsettturn
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid='subbroker'
begin
select sb.sub_broker,s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from isettlement s, client1 c1, client2 c2, subbrokers sb
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@statusname
group by sb.sub_broker,s.sell_buy
union all
select sb.sub_broker,s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from ihistory s, client1 c1, client2 c2, subbrokers sb
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@statusname
group by sb.sub_broker,s.sell_buy
order by sb.sub_broker,s.sell_buy
end
if @statusid='broker'
begin
select sb.sub_broker ,s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from isettlement s, client1 c1, client2 c2, subbrokers sb
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker 
group by sb.sub_broker,s.sell_buy
union all
select sb.sub_broker, s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from ihistory s, client1 c1, client2 c2, subbrokers sb
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker 
group by sb.sub_broker,s.sell_buy
order by sb.sub_broker,s.sell_buy
end

GO
