-- Object: PROCEDURE dbo.rpt_fobillsummary1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fobillsummary1    Script Date: 5/11/01 6:19:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobillsummary1    Script Date: 5/7/2001 9:02:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobillsummary1    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobillsummary1    Script Date: 5/5/2001 1:24:09 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobillsummary1    Script Date: 4/30/01 5:50:07 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobillsummary1    Script Date: 10/26/00 6:04:40 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fobillsummary1    Script Date: 12/27/00 8:59:09 PM ******/
/*
Used In      : NSE FO
Report Name  : Bill Report
File Name    : Bill Details
Tables Used  : fosettlement, foclosing, foaccbill
Function     : Returns the pqty, sqty, closing rate for a particular date
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_fobillsummary1
@code varchar(10),
@fdate varchar(12),
@tdate varchar(12)
AS
select pqty = ( case when s.sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when s.sell_buy = 2 then sum(s.tradeqty) else 0 end )  ,
netrate = (select cl_rate from foclosing 
where trade_date = ( select distinct max(trade_date) from foclosing 
            where left(convert(varchar,trade_date,103),11) < ( select distinct left(convert(varchar,max(trade_date),103),11) 
            from foclosing 
            where left(convert(varchar,trade_date,106),11) = @tdate ) )),
cl_rate = (select cl_rate from foclosing 
                  where left(convert(varchar,trade_date,106),11)  = @tdate)
,s.Party_Code,s.Inst_Type,s.Symbol,convert(varchar,s.expirydate,106) as expirydate,sdate = left(convert(varchar,sauda_date,106),11),
s.sell_buy ,a.bill_no,a.amount
from FoSettlement s,foclosing c, foaccbill a
where c.Inst_Type = s.inst_type and c.Symbol = s.symbol and 
left(convert(varchar,c.trade_date,103),11) = left(convert(varchar,sauda_date,103),11)  
and left(convert(varchar,sauda_date,103),11) < ( select distinct left(convert(varchar,max(sauda_date),103),11) from fosettlement where left(convert(varchar,sauda_date,106),11) = @tdate) 
and s.party_code = @code
and s.party_code = a.party_code
and left(convert(varchar,sauda_date,106),11)>= @fdate
and left(convert(varchar,s.sauda_date,103),11) = left(convert(varchar,a.billdate,103),11) 
group by left(convert(varchar,sauda_date,106),11),s.party_code,s.Inst_Type,s.expirydate,a.bill_no,
s.Symbol,s.sell_Buy ,a.amount
union all
select pqty = ( case when s.sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when s.sell_buy = 2 then sum(s.tradeqty) else 0 end )
,s.netrate,c.cl_rate,s.Party_Code,s.Inst_Type,s.Symbol,convert(varchar,s.expirydate,106) as expirydate,
sdate=left(convert(varchar,sauda_date,106),11),s.sell_buy ,a.bill_no,a.amount
from FoSettlement s,foclosing c, foaccbill a
where c.Inst_Type = s.inst_type and
  c.Symbol = s.symbol and
 left(convert(varchar,c.trade_date,103),11) = left(convert(varchar,sauda_date,103),11) 
 and left(convert(varchar,sauda_date,103),11) = ( select distinct left(convert(varchar,max(sauda_date),103),11) from fosettlement 
         where left(convert(varchar,sauda_date,106),11) = @fdate ) 
and s.party_code = @code
and s.party_code = a.party_code
and left(convert(varchar,s.sauda_date,103),11) = left(convert(varchar,a.billdate,103),11) 
group by left(convert(varchar,sauda_date,106),11),s.netrate,c.cl_rate,s.party_code,s.Inst_Type,s.expirydate,
s.Symbol,left(convert(varchar,sauda_date,106),11),s.sell_Buy ,a.bill_no,a.amount
order by sdate ,expirydate, s.inst_type, s.symbol

GO
