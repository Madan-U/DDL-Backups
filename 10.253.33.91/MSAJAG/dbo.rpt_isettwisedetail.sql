-- Object: PROCEDURE dbo.rpt_isettwisedetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_isettwisedetail    Script Date: 04/27/2001 4:32:44 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isettwisedetail    Script Date: 3/21/01 12:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isettwisedetail    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isettwisedetail    Script Date: 2/5/01 12:06:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isettwisedetail    Script Date: 12/27/00 8:59:12 PM ******/

/* report : sbbroksett 
   file :sett.asp
*/
/* displays details of settlement for a particular settlement number and type for a subbroker */
CREATE PROCEDURE rpt_isettwisedetail
@statusname varchar(25),
@settno varchar(7),
@settype varchar(3),
@pcode varchar(15)
AS
select s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from isettlement s, client1 c1, client2 c2, subbrokers sb
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@statusname and s.sett_no=@settno and sett_type=@settype
and s.partipantcode like ltrim(@pcode)+ '%'
group by s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy
union all
select s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy, qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from ihistory s, client1 c1, client2 c2, subbrokers sb
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@statusname and s.sett_no=@settno and sett_type=@settype
and s.partipantcode like ltrim(@pcode)+ '%'
group by s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy
order by s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy

GO
