-- Object: PROCEDURE dbo.rpt_fotest1forthedate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_fotest1forthedate    Script Date: 5/11/01 12:09:00 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest1forthedate    Script Date: 5/7/2001 9:02:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest1forthedate    Script Date: 5/5/2001 2:43:39 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest1forthedate    Script Date: 5/5/2001 1:24:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest1forthedate    Script Date: 4/30/01 5:50:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest1forthedate    Script Date: 10/26/00 6:04:44 PM ******/







CREATE PROCEDURE rpt_fotest1forthedate

@sdate varchar(12),
@partycode varchar(10)

AS

select 
pqty = ( case when sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when sell_buy = 2 then sum(s.tradeqty) else 0 end ),
netrate = isnull(s.price,0),
cl_rate = isnull(c.cl_rate,0),
Party_Code,
s.Inst_Type,
s.Symbol,
convert(varchar,S.EXPIRYDATE,106) as expirydate,
sdate=left(convert(varchar,sauda_date,109),11),
sell_buy,
service_tax = sum(SERVICE_TAX),
Brok=Sum(Brokapplied*tradeqty) ,s.expirydate as expdate,
sebitax = sum(sebi_tax),
turntax = sum(turn_tax), s.strike_price, s.option_type, s.price, s.billno
from FoSettlement s,foclosing c,foscrip2
where c.Inst_Type = s.inst_type and
  c.Symbol = s.symbol 
 and c.strike_price=s.strike_price and c.option_type=s.option_type and
      left(convert(varchar,c.trade_date,109),11) = left(convert(varchar,sauda_date,109),11) and
          left(convert(varchar,sauda_date,109),11) = ( select left(convert(varchar,max(sauda_date),109),11) 
                                                      from fosettlement 
            where left(convert(varchar,sauda_date,109),11) like @sdate
                                                     ) 
and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
           and foscrip2.inst_type=c.inst_type
           and foscrip2.symbol=c.symbol   
 and foscrip2.strike_price=c.strike_price and foscrip2.option_type=c.option_type 
           and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103)
and s.party_code = @partycode
       /*    and left(convert(varchar,foscrip2.maturitydate,109),11) <> 'jun 20 2000'  this was modified on 2nd feb 2001 the below line was added * */
          and foscrip2.maturitydate > @sdate +' 23:59'
   group by left(convert(varchar,sauda_date,109),11),s.price,c.cl_rate,party_code,s.Inst_Type,
s.Symbol,S.EXPIRYDATE,left(convert(varchar,sauda_date,109),11),sell_Buy ,convert(varchar,c.expirydate,103), convert(varchar,s.expirydate,103),
 s.strike_price, s.option_type, s.price, s.billno
order by s.expdate,party_code,s.inst_type,s.symbol, s.billno

GO
