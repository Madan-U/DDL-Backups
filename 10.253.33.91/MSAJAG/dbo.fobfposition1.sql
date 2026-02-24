-- Object: PROCEDURE dbo.fobfposition1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.fobfposition1    Script Date: 5/26/01 4:17:00 PM ******/
CREATE proc fobfposition1(@sdate  varchar(11), @party  varchar(12)) as
select 
  ( case when s.sell_buy = 1 then sum(s.tradeqty) else 0 end )-
  ( case when s.sell_buy = 2 then sum(s.tradeqty) else 0 end )  as qty ,
netrate = isnull((  select foclosing.cl_rate from foclosing
                                where foclosing.trade_date = ( select max(trade_date) from foclosing 
                                where foclosing.trade_date < @sdate + ' 23:59' )  
		              and foclosing.Inst_Type = s.inst_type
                                            and foclosing.symbol=s.symbol   
                                           and foclosing.option_type=s.option_type
                                  and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                                 
                ),0),

/*the clrate is the final closing rate from fofinalclosing*/
/*cl_rate = isnull(( select fofinalclosing.cl_rate from fofinalclosing
                         where left(convert(varchar,fofinalclosing.closingdate,109),11)  like @sdate
                         		
                                        and fofinalclosing.UnderlyingAsset=s.symbol   
                         
                     
           ),0),*/




cl_rate = isnull(( select fofinalclosing.cl_rate from fofinalclosing
                         where left(convert(varchar,fofinalclosing.closingdate,109),11)  like @sdate
                         		and foscrip2.maturitydate = fofinalclosing.closingdate
                                        and fofinalclosing.UnderlyingAsset=s.symbol   
                         
                     
           ),isnull(( select foclosing.cl_rate from foclosing
                         where left(convert(varchar,foclosing.trade_date,109),11)  like @SDate 
                         and foclosing.Inst_Type = s.inst_type and foclosing.symbol=s.symbol and foclosing.strike_price=s.strike_price and foclosing.option_type=s.option_type and
                          convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                     
           ),0)),
Party_Code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,left(convert(varchar,s.expirydate,109),11) as expirydate1,s.strike_price,s.option_type
from foSettlement s,foclosing c,foscrip2
where c.Inst_Type = s.inst_type and
      c.Symbol = s.symbol and
   
      left(convert(varchar,c.trade_date,109),11) = left(convert(varchar,sauda_date,109),11) and 
      c.strike_price=s.strike_price and 
      c.option_type=s.option_type and
      left(convert(varchar,sauda_date,109),11) <= ( select max(sauda_date)
                                                   from fosettlement 
                                                   where sauda_date+1 <= @sdate + ' 23:59'
                                                 )
     and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
                               and foscrip2.inst_type=c.inst_type
    		         and foscrip2.symbol=c.symbol   
                         and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103) and
                                        foscrip2.strike_price=c.strike_price and 
                                       foscrip2.option_type=c.option_type 
                   	 and foscrip2.maturitydate >= @sdate + ' 23:59:00'   
                         and s.party_code=@party   
and left(s.inst_type,3) = 'FUT'
and left( foscrip2.inst_type,3) = 'FUT'
and left(c.inst_type,3) = 'FUT'
group by party_code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,convert(varchar,s.expirydate,103),s.strike_price,s.option_type,
sell_buy,convert(varchar,c.expirydate,103),foscrip2.maturitydate
order by s.expirydate

GO
