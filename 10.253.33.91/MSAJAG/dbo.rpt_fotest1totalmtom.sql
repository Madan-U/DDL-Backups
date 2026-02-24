-- Object: PROCEDURE dbo.rpt_fotest1totalmtom
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_fotest1totalmtom    Script Date: 5/11/01 12:09:00 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest1totalmtom    Script Date: 5/7/2001 9:02:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest1totalmtom    Script Date: 5/5/2001 2:43:40 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest1totalmtom    Script Date: 5/5/2001 1:24:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest1totalmtom    Script Date: 4/30/01 5:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest1totalmtom    Script Date: 10/26/00 6:04:45 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fotest1totalmtom    Script Date: 12/27/00 8:59:11 PM ******/
CREATE PROCEDURE rpt_fotest1totalmtom
@sdate varchar(12)
AS
select 
pqty = ( case when s.sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when s.sell_buy = 2 then sum(s.tradeqty) else 0 end )  ,
netrate = isnull((  select foclosing.cl_rate from foclosing
                                where left(convert(varchar,foclosing.trade_date,106),11) = ( select left(convert(varchar,max(trade_date),106),11) from foclosing 
                            where foclosing.trade_date < @sdate  ) 
        and foclosing.Inst_Type = s.inst_type
                                  and foclosing.symbol=s.symbol   
                                  and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                                 
                ),0),
cl_rate = isnull(( select foclosing.cl_rate from foclosing
                         where left(convert(varchar,foclosing.trade_date,106),11)  like @sdate
                         and foclosing.Inst_Type = s.inst_type and foclosing.symbol=s.symbol 
                         and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                     
           ),0),
Party_Code,s.Inst_Type,s.Symbol,convert(varchar,S.EXPIRYDATE,106) as expirydate,
sdate = left(convert(varchar,sauda_date,106),11),sell_buy ,Service_Tax=0,Brok=0
from FoSettlement s,foclosing c,foscrip2 
where c.Inst_Type = s.inst_type and
      c.Symbol = s.symbol and
      left(convert(varchar,c.trade_date,106),11) = left(convert(varchar,sauda_date,106),11) and 
      left(convert(varchar,sauda_date,106),11) <= ( select left(convert(varchar,max(sauda_date),106),11)
                                                   from fosettlement 
                                                   where sauda_date+1 <= @sdate
                                                 )
     and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
                         and foscrip2.inst_type=c.inst_type
               and foscrip2.symbol=c.symbol   
                         and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103)
                         and left(convert(varchar,foscrip2.maturitydate,106),11) <> @sdate
group by left(convert(varchar,sauda_date,106),11),party_code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,sell_Buy,convert(varchar,s.expirydate,103),convert(varchar,c.expirydate,103)
union all
select 
pqty = ( case when sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when sell_buy = 2 then sum(s.tradeqty) else 0 end ),
isnull(s.price,0),
isnull(c.cl_rate,0),
Party_Code,
s.Inst_Type,
s.Symbol,
convert(varchar,S.EXPIRYDATE,106) as expirydate,
sdate=left(convert(varchar,sauda_date,106),11),
sell_buy,
service_tax = sum(SERVICE_TAX),
Brok=Sum(Brokapplied*tradeqty) 
from FoSettlement s,foclosing c,foscrip2
where c.Inst_Type = s.inst_type and
  c.Symbol = s.symbol and
      left(convert(varchar,c.trade_date,106),11) = left(convert(varchar,sauda_date,106),11) and
          left(convert(varchar,sauda_date,106),11) = ( select left(convert(varchar,max(sauda_date),106),11) 
                                                      from fosettlement 
            where left(convert(varchar,sauda_date,106),11) like @sdate
                                                     ) 
and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
           and foscrip2.inst_type=c.inst_type
           and foscrip2.symbol=c.symbol   
           and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103)
           and left(convert(varchar,foscrip2.maturitydate,106),11) <> @sdate
    
group by left(convert(varchar,sauda_date,106),11),s.price,c.cl_rate,party_code,s.Inst_Type,
s.Symbol,S.EXPIRYDATE,left(convert(varchar,sauda_date,106),11),sell_Buy ,convert(varchar,c.expirydate,103), convert(varchar,s.expirydate,103)
order by party_code,s.inst_type,s.symbol

GO
