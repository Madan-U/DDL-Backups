-- Object: PROCEDURE dbo.rpt_FoTotalMtom
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_FoTotalMtom    Script Date: 5/11/01 6:19:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_FoTotalMtom    Script Date: 5/7/2001 9:02:52 PM ******/

/****** Object:  Stored Procedure dbo.rpt_FoTotalMtom    Script Date: 5/5/2001 2:43:41 PM ******/

/****** Object:  Stored Procedure dbo.rpt_FoTotalMtom    Script Date: 5/5/2001 1:24:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_FoTotalMtom    Script Date: 4/30/01 5:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_FoTotalMtom    Script Date: 10/26/00 6:04:45 PM ******/






/****** Object:  Stored Procedure dbo.rpt_FoTotalMtom    Script Date: 12/27/00 8:59:11 PM ******/
/*
Used In      : NSE FO
Report Name  : Bill Report
File Name    : billreport.asp
Tables Used  : fosettlement, foclosing
Function     : Returns netrate,closing rate, pqty, sqty, contract descriptor of a particular contract descriptor
Written By   : Amolika Patil 
*/
/*CREATE Procedure rpt_FoTotalMtom (@Sdate Varchar(11)) as 
select 
pqty = ( case when s.sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when s.sell_buy = 2 then sum(s.tradeqty) else 0 end )  ,
netrate = isnull((  select cl_rate from foclosing 
              where left(convert(varchar,trade_date,106),11) = ( select left(convert(varchar,max(trade_date),106),11) from foclosing 
                    where trade_date < @SDate ) 
        and Inst_Type = s.inst_type and symbol = s.symbol and convert(varchar,expirydate,106) = convert(varchar,s.expirydate,106)
           ),0),
cl_rate = isnull(( select cl_rate from foclosing 
            where left(convert(varchar,trade_date,106),11)  like @SDate and Inst_Type = s.inst_type and symbol = s.symbol  and convert(varchar,expirydate,106) = convert(varchar,s.expirydate,106)
           ),0),
Party_Code,s.Inst_Type,s.Symbol,convert(varchar,S.EXPIRYDATE,106) as expirydate,
sdate = left(convert(varchar,sauda_date,106),11),sell_buy ,Service_Tax=0
from FoSettlement s,foclosing c
where c.Inst_Type = s.inst_type and
      c.Symbol = s.symbol and
      left(convert(varchar,c.trade_date,106),11) = left(convert(varchar,sauda_date,106),11) and 
      left(convert(varchar,sauda_date,106),11) <= ( select left(convert(varchar,max(sauda_date),106),11)
                                                   from fosettlement 
                                                   where left(convert(varchar,sauda_date+1,106),11) <= @Sdate
                                                 )
and convert(varchar,c.expirydate,106) = convert(varchar,s.expirydate,106)
group by left(convert(varchar,sauda_date,106),11),party_code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,sell_Buy,convert(varchar,s.expirydate,106),convert(varchar,c.expirydate,106)
union all
select 
pqty = ( case when sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when sell_buy = 2 then sum(s.tradeqty) else 0 end ),
isnull(s.netrate,0),isnull(c.cl_rate,0),Party_Code,s.Inst_Type,s.Symbol,convert(varchar,S.EXPIRYDATE,106) as expirydate,
sdate=left(convert(varchar,sauda_date,106),11),sell_buy,Service_Tax=SUM(SERVICE_TAX)
 from FoSettlement s,foclosing c
where c.Inst_Type = s.inst_type and
  c.Symbol = s.symbol and
 left(convert(varchar,c.trade_date,106),11) = left(convert(varchar,sauda_date,106),11) and
         left(convert(varchar,sauda_date,106),11) = ( select left(convert(varchar,max(sauda_date),106),11) 
                                                      from fosettlement 
            where left(convert(varchar,sauda_date,106),11) like @SDate
                                                     ) 
and convert(varchar,c.expirydate,106) = convert(varchar,s.expirydate,106)
group by left(convert(varchar,sauda_date,106),11),s.netrate,c.cl_rate,party_code,s.Inst_Type,
s.Symbol,S.EXPIRYDATE,left(convert(varchar,sauda_date,106),11),sell_Buy ,convert(varchar,c.expirydate,106), convert(varchar,s.expirydate,106)
order by s.inst_type, s.symbol, s.expirydate*/
CREATE Procedure rpt_FoTotalMtom (@Sdate Varchar(11)) as 
select 
pqty = ( case when s.sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when s.sell_buy = 2 then sum(s.tradeqty) else 0 end )  ,
netrate = isnull((  select cl_rate from foclosing 
              where left(convert(varchar,trade_date,106),11) = ( select left(convert(varchar,max(trade_date),106),11) from foclosing 
                    where left(convert(varchar,trade_date,106),11) < @SDate ) 
        and Inst_Type = s.inst_type and symbol=s.symbol and convert(varchar,expirydate,106) = convert(varchar,s.expirydate,106)
           ),0),
cl_rate = isnull(( select cl_rate from foclosing 
            where left(convert(varchar,trade_date,106),11)  like @SDate and Inst_Type = s.inst_type and symbol=s.symbol and convert(varchar,expirydate,106) = convert(varchar,s.expirydate,106)
           ),0),
Party_Code,s.Inst_Type,s.Symbol,convert(varchar,S.EXPIRYDATE,106) as expirydate,
sdate = left(convert(varchar,sauda_date,106),11),sell_buy ,Service_Tax=0,Brok=0
from FoSettlement s,foclosing c
where c.Inst_Type = s.inst_type and
      c.Symbol = s.symbol and
      left(convert(varchar,c.trade_date,106),11) = left(convert(varchar,sauda_date,106),11) and 
      left(convert(varchar,sauda_date,106),11) <= ( select left(convert(varchar,max(sauda_date),106),11)
                                                   from fosettlement 
                                                   where left(convert(varchar,sauda_date+1,106),11) <= @Sdate
                                                 )
and convert(varchar,c.expirydate,106) = convert(varchar,s.expirydate,106)
group by left(convert(varchar,sauda_date,106),11),party_code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,sell_Buy,convert(varchar,s.expirydate,106),convert(varchar,c.expirydate,106)
union all
select 
pqty = ( case when sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when sell_buy = 2 then sum(s.tradeqty) else 0 end ),
isnull(s.price,0),isnull(c.cl_rate,0),Party_Code,s.Inst_Type,s.Symbol,convert(varchar,S.EXPIRYDATE,106) as expirydate,
sdate=left(convert(varchar,sauda_date,106),11),sell_buy,service_tax = sum(SERVICE_TAX),Brok=Sum(Brokapplied*tradeqty) 
from FoSettlement s,foclosing c
where c.Inst_Type = s.inst_type and
  c.Symbol = s.symbol and
 left(convert(varchar,c.trade_date,106),11) = left(convert(varchar,sauda_date,106),11) and
         left(convert(varchar,sauda_date,106),11) = ( select left(convert(varchar,max(sauda_date),106),11) 
                                                      from fosettlement 
            where left(convert(varchar,sauda_date,106),11) like @SDate
                                                     ) 
and convert(varchar,c.expirydate,106) = convert(varchar,s.expirydate,106)
group by left(convert(varchar,sauda_date,106),11),s.price,c.cl_rate,party_code,s.Inst_Type,
s.Symbol,S.EXPIRYDATE,left(convert(varchar,sauda_date,106),11),sell_Buy ,convert(varchar,c.expirydate,103), convert(varchar,s.expirydate,106)
order by s.inst_type, s.symbol,party_code

GO
