-- Object: PROCEDURE dbo.subbroksett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.subbroksett    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.subbroksett    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.subbroksett    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.subbroksett    Script Date: 2/5/01 12:06:29 PM ******/

/****** Object:  Stored Procedure dbo.subbroksett    Script Date: 12/27/00 8:59:04 PM ******/

CREATE PROCEDURE subbroksett
@subbroker varchar(15),
@settno varchar(7),
@settype varchar(3)
as
select s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from settlement s, client1 c1, client2 c2, subbrokers sb
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker and s.sett_no=@settno and sett_type=@settype
group by s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy
union
select s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from history s, client1 c1, client2 c2, subbrokers sb
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker and s.sett_no=@settno and sett_type=@settype
group by s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy
order by s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy

GO
