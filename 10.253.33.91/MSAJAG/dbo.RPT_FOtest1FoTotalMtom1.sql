-- Object: PROCEDURE dbo.RPT_FOtest1FoTotalMtom1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.RPT_FOtest1FoTotalMtom1    Script Date: 5/11/01 12:09:00 PM ******/

/****** Object:  Stored Procedure dbo.RPT_FOtest1FoTotalMtom1    Script Date: 5/7/2001 9:02:51 PM ******/

/****** Object:  Stored Procedure dbo.RPT_FOtest1FoTotalMtom1    Script Date: 5/5/2001 2:43:40 PM ******/

/****** Object:  Stored Procedure dbo.RPT_FOtest1FoTotalMtom1    Script Date: 5/5/2001 1:24:17 PM ******/

/****** Object:  Stored Procedure dbo.RPT_FOtest1FoTotalMtom1    Script Date: 4/30/01 5:50:18 PM ******/

/****** Object:  Stored Procedure dbo.RPT_FOtest1FoTotalMtom1    Script Date: 10/26/00 6:04:44 PM ******/






CREATE Procedure RPT_FOtest1FoTotalMtom1 (@Sdate Varchar(11)) as 
select 
pqty = ( case when s.sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when s.sell_buy = 2 then sum(s.tradeqty) else 0 end )  ,
netrate = isnull((  select foclosing.cl_rate from foclosing
                                where foclosing.trade_date = ( select max(trade_date) from foclosing 
                    where foclosing.trade_date < @SDate + ' 23:59') 
        and foclosing.Inst_Type = s.inst_type
                                  and foclosing.symbol=s.symbol    and foclosing.strike_price=s.strike_price and foclosing.option_type=s.option_type 
                                  and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                                 
                ),0),
cl_rate = isnull(( select foclosing.cl_rate from foclosing
                         where left(convert(varchar,foclosing.trade_date,109),11)  like @SDate 
                         and foclosing.Inst_Type = s.inst_type and foclosing.symbol=s.symbol 
		 and foclosing.strike_price=s.strike_price and foclosing.option_type=s.option_type
                         and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                     
           ),0),
Party_Code,s.Inst_Type,s.Symbol,convert(varchar,S.EXPIRYDATE,106) as expirydate,
sdate = left(convert(varchar,sauda_date,109),11),sell_buy ,Service_Tax=0,Brok=0,s.expirydate as expdate
from FoSettlement s,foclosing c,foscrip2 
where c.Inst_Type = s.inst_type and
      c.Symbol = s.symbol and
	c.strike_price=s.strike_price and c.option_type=s.option_type  and
      left(convert(varchar,c.trade_date,109),11) = left(convert(varchar,sauda_date,109),11) and 
      left(convert(varchar,sauda_date,109),11) <= ( select max(sauda_date)
                                                   from fosettlement 
                                                   where sauda_date+1 <= @Sdate + ' 23:59'
                                                 )
     and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
                         and foscrip2.inst_type=c.inst_type
               and foscrip2.symbol=c.symbol   
and foscrip2.strike_price=c.strike_price and foscrip2.option_type=c.option_type 
                         and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103)
                    /*     and left(convert(varchar,foscrip2.maturitydate,109),11) <> @sdate      this was modified on 2nd feb 2001 the below line was added */
                        and foscrip2.maturitydate > @Sdate + ' 23:59:00'
and left(s.inst_type,3) = 'FUT'
and left( foscrip2.inst_type,3) = 'FUT'
and left(c.inst_type,3) = 'FUT'
group by left(convert(varchar,sauda_date,109),11),party_code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,sell_Buy,convert(varchar,s.expirydate,103),convert(varchar,c.expirydate,103),
s.option_type, s.strike_price
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
sdate=left(convert(varchar,sauda_date,109),11),
sell_buy,
service_tax = sum(SERVICE_TAX),
Brok=Sum(Brokapplied*tradeqty) ,s.expirydate as expdate
from FoSettlement s,foclosing c,foscrip2
where c.Inst_Type = s.inst_type and
  c.Symbol = s.symbol 
 and c.strike_price=s.strike_price and c.option_type=s.option_type and
      left(convert(varchar,c.trade_date,109),11) = left(convert(varchar,sauda_date,109),11) and
          left(convert(varchar,sauda_date,109),11) = ( select left(convert(varchar,max(sauda_date),109),11) 
                                                      from fosettlement 
            where left(convert(varchar,sauda_date,109),11) like @SDate
                                                     ) 
and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
           and foscrip2.inst_type=c.inst_type
           and foscrip2.symbol=c.symbol   
           and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103)
 and foscrip2.strike_price=c.strike_price and foscrip2.option_type=c.option_type 
       /*    and left(convert(varchar,foscrip2.maturitydate,109),11) <> @sdate  this was modified on 2nd feb 2001 the below line was added * */
          and foscrip2.maturitydate > @Sdate +' 23:59:00'
   group by left(convert(varchar,sauda_date,109),11),s.price,c.cl_rate,party_code,s.Inst_Type,
s.Symbol,S.EXPIRYDATE,left(convert(varchar,sauda_date,109),11),sell_Buy ,convert(varchar,c.expirydate,103), convert(varchar,s.expirydate,103),
s.option_type, s.strike_price
order by party_code, s.expdate,s.inst_type,s.symbol

GO
