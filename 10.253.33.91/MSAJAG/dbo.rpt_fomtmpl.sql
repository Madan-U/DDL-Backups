-- Object: PROCEDURE dbo.rpt_fomtmpl
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomtmpl    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomtmpl    Script Date: 5/7/2001 9:02:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomtmpl    Script Date: 5/5/2001 2:43:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomtmpl    Script Date: 5/5/2001 1:24:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomtmpl    Script Date: 4/30/01 5:50:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomtmpl    Script Date: 10/26/00 6:04:43 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fomtmpl    Script Date: 12/27/00 8:59:10 PM ******/
/*
Used In      : NSE FO
Report Name  : Margin Report
File Name    : margin.asp
Tables Used  : fosettlement, foclosing
Function     : Returns netrate, pqty, sqty, closing rate of a particular date
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_fomtmpl
@sdate varchar(12)
AS
select 
pqty = ( case when s.sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when s.sell_buy = 2 then sum(s.tradeqty) else 0 end )  ,
netrate = isnull((  select cl_rate from foclosing 
              where left(convert(varchar,trade_date,106),11) = ( select left(convert(varchar,max(trade_date),106),11) from foclosing 
                    where trade_date < @sdate ) 
        and Inst_Type = s.inst_type and convert(varchar,expirydate,106) = convert(varchar,s.expirydate,106)
      and symbol = s.symbol 
           ),0),
cl_rate = isnull(( select cl_rate from foclosing 
            where left(convert(varchar,trade_date,106),11)  like @sdate and Inst_Type = s.inst_type  and convert(varchar,expirydate,106) = convert(varchar,s.expirydate,106)
            and symbol = s.symbol
           ),0),
Party_Code,s.Inst_Type,s.Symbol,convert(varchar,s.expirydate,106) as expirydate,
sdate = left(convert(varchar,sauda_date,106),11),sell_buy ,Service_Tax=0
from FoSettlement s,foclosing c
where c.Inst_Type = s.inst_type and
      c.Symbol = s.symbol and
      left(convert(varchar,c.trade_date,106),11) = left(convert(varchar,sauda_date,106),11) and 
      left(convert(varchar,sauda_date,106),11) <= ( select left(convert(varchar,max(sauda_date),106),11)
                                                   from fosettlement 
                                                   where left(convert(varchar,sauda_date+1,106),11) <= @sdate
                                                 )
and convert(varchar,c.expirydate,106) = convert(varchar,s.expirydate,106)
group by left(convert(varchar,sauda_date,106),11),party_code,s.Inst_Type,s.Symbol,s.expirydate,sell_Buy,convert(varchar,s.expirydate,106),convert(varchar,c.expirydate,106),Service_Tax
union all
select 
pqty = ( case when sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when sell_buy = 2 then sum(s.tradeqty) else 0 end ),
isnull(s.netrate,0),isnull(c.cl_rate,0),Party_Code,s.Inst_Type,s.Symbol,convert(varchar,s.expirydate,106) as expirydate,
sdate=left(convert(varchar,sauda_date,106),11),sell_buy,Service_Tax=SUM(SERVICE_TAX)
 from FoSettlement s,foclosing c
where c.Inst_Type = s.inst_type and
  c.Symbol = s.symbol and
 left(convert(varchar,c.trade_date,106),11) = left(convert(varchar,sauda_date,106),11) and
         left(convert(varchar,sauda_date,106),11) = ( select left(convert(varchar,max(sauda_date),106),11) 
                                                      from fosettlement 
            where left(convert(varchar,sauda_date,106),11) like @sdate
                                                     ) 
and convert(varchar,c.expirydate,106) = convert(varchar,s.expirydate,106)
group by left(convert(varchar,sauda_date,106),11),s.netrate,c.cl_rate,party_code,s.Inst_Type,
s.Symbol,s.expirydate,left(convert(varchar,sauda_date,106),11),sell_Buy ,convert(varchar,c.expirydate,106), convert(varchar,s.expirydate,106)

GO
