-- Object: PROCEDURE dbo.sbsettturn
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbsettturn    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbsettturn    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbsettturn    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbsettturn    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbsettturn    Script Date: 12/27/00 8:59:01 PM ******/

/*** file :positionreport.asp
     report :client position 
displays details of asettlement for a particular client
**/
/* displays total buy and sell (qty and amt) of a particular subbroker till today */
CREATE PROCEDURE sbsettturn
@subbroker varchar(15)
AS
select s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from settlement s, client1 c1, client2 c2, subbrokers sb
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
group by s.sell_buy
union
select s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from history s, client1 c1, client2 c2, subbrokers sb
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
group by s.sell_buy
order by sell_buy

GO
