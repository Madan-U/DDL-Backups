-- Object: PROCEDURE dbo.rpt_fotmtransdetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fotmtransdetail    Script Date: 5/11/01 6:19:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotmtransdetail    Script Date: 5/7/2001 9:02:52 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotmtransdetail    Script Date: 5/5/2001 2:43:40 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotmtransdetail    Script Date: 5/5/2001 1:24:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotmtransdetail    Script Date: 4/30/01 5:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotmtransdetail    Script Date: 10/26/00 6:04:45 PM ******/


CREATE procedure rpt_fotmtransdetail

@fdatest varchar(12) ,
@fdateend varchar(12),
@partycode varchar(10),
@expirydate smalldatetime,
@symbol varchar(12),
@insttype varchar(6)

as

select  s.order_no, s.tradingfees ,s.tradeqty ,s.price ,s.sell_buy,
s.clearingfees from fotmsettlement s  ,fotminfo tm
where  left(convert(varchar,s.activitytime,109),11) >= @fdatest and
left(convert(varchar,s.activitytime,109),11)  <= @fdatest + ' 23:59:59' and 
s.expirydate = @expirydate and 
s.symbol =@symbol and 
s.inst_type = @insttype  and
s.tm_code=tm.tm_code 
and tm.tm_code=(select tm_code from fotminfo where party_code =@partycode)

GO
