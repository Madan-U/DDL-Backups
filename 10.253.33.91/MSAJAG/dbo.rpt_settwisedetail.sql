-- Object: PROCEDURE dbo.rpt_settwisedetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_settwisedetail    Script Date: 04/27/2001 4:32:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settwisedetail    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settwisedetail    Script Date: 20-Mar-01 11:39:03 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settwisedetail    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settwisedetail    Script Date: 12/27/00 8:58:58 PM ******/

/* report : sbbroksett 
   file :sett.asp
*/
/* displays details of settlement for a particular settlement number and type for a subbroker */
CREATE PROCEDURE rpt_settwisedetail
@statusname varchar(25),
@settno varchar(7),
@settype varchar(3)
AS
select s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from settlement s, client1 c1, client2 c2, subbrokers sb
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@statusname and s.sett_no=@settno and sett_type=@settype
group by s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy
union all
select s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from history s, client1 c1, client2 c2, subbrokers sb
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@statusname and s.sett_no=@settno and sett_type=@settype
group by s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy
order by s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy

GO
