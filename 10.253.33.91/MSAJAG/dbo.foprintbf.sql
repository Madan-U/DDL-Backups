-- Object: PROCEDURE dbo.foprintbf
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.foprintbf    Script Date: 5/26/01 4:17:00 PM ******/
CREATE proc foprintbf (@party varchar(10),@sdate varchar(11)) as
select 
pqty = ( case when s.sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when s.sell_buy = 2 then sum(s.tradeqty) else 0 end )  ,
netrate = isnull((  select foclosing.cl_rate from foclosing
             	                  where foclosing.trade_date = ( select max(trade_date) from foclosing 
		                  where foclosing.trade_date < @sdate+ ' 23:59' ) 
 		 		  and foclosing.Inst_Type = s.inst_type
                                  and foclosing.symbol=s.symbol   and foclosing.option_type = s.option_type and foclosing.strike_price = s.strike_price
                                  and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                                 
                ),0),
cl_rate = isnull(( select fofinalclosing.cl_rate from fofinalclosing
                         where left(convert(varchar,fofinalclosing.closingdate,109),11)  like @sdate
                         		and foscrip2.maturitydate = fofinalclosing.closingdate
                                        and fofinalclosing.UnderlyingAsset=s.symbol   
                         
                     
           ),isnull(( select foclosing.cl_rate from foclosing
                         where left(convert(varchar,foclosing.trade_date,109),11)  like @sdate 
                         and foclosing.Inst_Type = s.inst_type and foclosing.symbol=s.symbol and foclosing.option_type = s.option_type and foclosing.strike_price = s.strike_price
                         and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                     
           ),0)),



Party_Code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,
sdate = left(convert(varchar,sauda_date,109),11),sell_buy ,
/*Service_Tax=0,*/
/*Brok=0,*/
service_tax=(case  when s.billflag > 3 then 
                            Sum( NSerTax  )
                           else
                               0 
               end),
Brok= (case  when s.billflag > 3 then 
                            Sum(abs(NBrokApp)*tradeqty)
                           else
                               0 
               end),

sebi_tax=0,turn_tax=0, s.strike_price, s.option_type /* sebi tax and turn tax are added on 18 april and added in the group by clause*/
from FoSettlement s,foclosing c,foscrip2 
where party_code=@party and
      c.Inst_Type = s.inst_type and
      c.Symbol = s.symbol and
      c.strike_price = s.strike_price and 
      c.option_type = s.option_type and
      s.billflag>3 and
      left(convert(varchar,c.trade_date,109),11) = left(convert(varchar,sauda_date,109),11) and 
      left(convert(varchar,sauda_date,109),11) <= ( select max(sauda_date)
                                                   from fosettlement 
                                                   where sauda_date+1<= @sdate+ ' 23:59'
                                                 )
     and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
                         and foscrip2.inst_type=c.inst_type
    		         and foscrip2.symbol=c.symbol   
                         and foscrip2.option_type = c.option_type and foscrip2.strike_price = c.strike_price
                         and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103)
                         and left(convert(varchar,foscrip2.maturitydate,109),11) = @sdate       
group by left(convert(varchar,sauda_date,109),11),party_code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,sell_Buy,convert(varchar,s.expirydate,103),convert(varchar,c.expirydate,103),sebi_tax,turn_tax,foscrip2.maturitydate,s.billflag, s.strike_price, s.option_type

union all

select 
pqty = ( case when sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when sell_buy = 2 then sum(s.tradeqty) else 0 end ),
isnull(s.price,0),
Cl_Rate =   isnull(( select fofinalclosing.cl_rate from fofinalclosing
                         where left(convert(varchar,fofinalclosing.closingdate,109),11)  like @sdate
                         		and foscrip2.maturitydate = fofinalclosing.closingdate
                                        and fofinalclosing.UnderlyingAsset=s.symbol   
                         
                     
           ),c.cl_rate),
Party_Code,
s.Inst_Type,
s.Symbol,
S.EXPIRYDATE,
sdate=left(convert(varchar,sauda_date,109),11),
sell_buy,
/*service_tax = sum(SERVICE_TAX),*/
service_tax=(case  when s.billflag > 3 then 
                            Sum( NSerTax  )
                           else
                               0 
               end),

/*Brok=Sum(Brokapplied*tradeqty),*/

Brok= (case  when s.billflag > 3 then 
                            Sum(abs(NBrokApp)*tradeqty)
                           else
                              Sum(Brokapplied*tradeqty)
               end),



/*Brok=Sum(abs(NBrokApp-Brokapplied)*tradeqty),*/
/*sebi_tax=sum(sebi_tax),turn_tax=sum(turn_tax) /* sebi tax and turn tax are added on 18 april and added in the group by clause*/ */
sebi_tax=0,turn_tax=0, s.strike_price, s.option_type

from FoSettlement s,foclosing c,foscrip2
where    party_code=@party and
         c.Inst_Type = s.inst_type and
	 c.Symbol = s.symbol and
                c.strike_price = s.strike_price and 
                c.option_type = s.option_type and 
   	  left(convert(varchar,c.trade_date,109),11) = left(convert(varchar,sauda_date,109),11) and
          left(convert(varchar,sauda_date,109),11) = ( select left(convert(varchar,max(sauda_date),109),11) 
                                                      from fosettlement 
						      where left(convert(varchar,sauda_date,109),11) like @sdate
                                                     ) 
and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
           and foscrip2.inst_type=c.inst_type
           and foscrip2.symbol=c.symbol   
           and foscrip2.strike_price = c.strike_price
           and foscrip2.option_type = c.option_type
           and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103)
           and left(convert(varchar,foscrip2.maturitydate,109),11) = @sdate 
           and s.billflag>3
group by left(convert(varchar,sauda_date,109),11),s.price,c.cl_rate,party_code,s.Inst_Type,
s.Symbol,S.EXPIRYDATE,left(convert(varchar,sauda_date,109),11),sell_Buy ,convert(varchar,c.expirydate,103), convert(varchar,s.expirydate,103),sebi_tax,turn_tax,foscrip2.maturitydate,s.billflag,s.strike_price,s.option_type
order by party_code,s.inst_type,s.symbol,s.expirydate

GO
