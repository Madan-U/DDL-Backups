-- Object: PROCEDURE dbo.rpt_clientwise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_clientwise    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clientwise    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clientwise    Script Date: 20-Mar-01 11:38:55 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clientwise    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clientwise    Script Date: 12/27/00 8:58:54 PM ******/

/* report : sbsett.asp
   file : clientwise.asp
*/
CREATE PROCEDURE rpt_clientwise  
@statusname varchar(25),
@partycode varchar(6),
@settno varchar(7),
@settype varchar(3)
AS
select c1.short_name,s.party_code,s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from settlement s, client1 c1, client2 c2, subbrokers sb
where s.party_code=@partycode and c2.cl_code=c1.cl_code and s.party_code=c2.party_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@statusname and s.sett_no=@settno and sett_type=@settype
group by s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy,s.party_code,c1.short_name
union all
select c1.short_name,s.party_code,s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from history s, client1 c1, client2 c2, subbrokers sb
where s.party_code=@partycode and c2.cl_code=c1.cl_code  and s.party_code=c2.party_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@statusname and s.sett_no=@settno and sett_type=@settype
group by s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy,s.party_code,c1.short_name
order by s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy

GO
