-- Object: PROCEDURE dbo.foopenpostilldate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.foopenpostilldate    Script Date: 5/26/01 4:17:00 PM ******/

CREATE proc foopenpostilldate (@sdate varchar(11),@party varchar(11)) as
select 
  ( case when s.sell_buy = 1 then isnull(sum(s.tradeqty),0) else 0 end )-
 ( case when s.sell_buy = 2 then isnull(sum(s.tradeqty),0) else 0 end )  as qty ,
Party_Code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,s.option_type,s.strike_price
 from foSettlement s,foclosing c,foscrip2 
where  c.Inst_Type = s.inst_type and
      c.Symbol = s.symbol and
       c.option_type = s.option_type and
        c.strike_price = s.strike_price and 
      left(convert(varchar,c.trade_date,109),11) = left(convert(varchar,sauda_date,109),11) and 
      left(convert(varchar,sauda_date,109),11) <= ( select max(sauda_date)
                                                   from fosettlement 
                                                   where sauda_date+1 <= @Sdate + ' 23:59'
                                                 )
     and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
                         and foscrip2.inst_type=c.inst_type
    		         and foscrip2.symbol=c.symbol   and foscrip2.option_type = s.option_type
                         and foscrip2.strike_price = s.strike_price
                         and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103)
                    /*     and left(convert(varchar,foscrip2.maturitydate,109),11) <> @sdate      this was modified on 2nd feb 2001 the below line was added */
                        and foscrip2.maturitydate > @Sdate + ' 23:59:00'
                         and s.party_code=@party
group by s.expirydate,s.Inst_Type,s.Symbol,S.EXPIRYDATE,s.party_code,
sell_Buy,s.option_type,s.strike_price
union
select 
 ( case when sell_buy = 1 then isnull(sum(s.tradeqty),0) else 0 end )-
 ( case when sell_buy = 2 then isnull(sum(s.tradeqty),0) else 0 end ),
Party_Code,
s.Inst_Type,s.Symbol,
S.EXPIRYDATE,s.option_type,s.strike_price

from foSettlement s,foclosing c,foscrip2
where  c.Inst_Type = s.inst_type and
      c.Symbol = s.symbol and
      left(convert(varchar,c.trade_date,109),11) = left(convert(varchar,sauda_date,109),11) and 
      left(convert(varchar,sauda_date,109),11) <= ( select max(sauda_date)
                                                   from fosettlement 
                                                   where sauda_date+1 <= @Sdate + ' 23:59'
                                                 )
     and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
                         and foscrip2.inst_type=c.inst_type
    		         and foscrip2.symbol=c.symbol   
                         and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103)
                    /*     and left(convert(varchar,foscrip2.maturitydate,109),11) <> @sdate      this was modified on 2nd feb 2001 the below line was added */
                        and foscrip2.maturitydate > @Sdate + ' 23:59:00'
           and s.party_code=@party
group by s.expirydate,s.Inst_Type,s.Symbol,S.EXPIRYDATE,s.party_code,
sell_Buy,s.option_type,s.strike_price
order by S.EXPIRYDATE,s.Inst_Type,s.Symbol,party_code

GO
