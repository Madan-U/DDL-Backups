-- Object: PROCEDURE dbo.test1FoTotalMtom
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.test1FoTotalMtom    Script Date: 5/26/01 4:17:02 PM ******/


/****** Object:  Stored Procedure dbo.test1FoTotalMtom    Script Date: 4/18/01 4:21:18 PM ******/


/****** Object:  Stored Procedure dbo.test1FoTotalMtom    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.test1FoTotalMtom    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.test1FoTotalMtom    Script Date: 20-Mar-01 11:39:11 PM ******/



/*Last update on 18 april added sebitax and turn_tax in the query*/
/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/
/*last updated  : 2nd feb 2001*/
/*procedure updated on 2nd feb  2001 because it does not close an existing open position in maturing contract if member has not traded to close the position*/
/*created by ranjeet choudhary*/
CREATE Procedure test1FoTotalMtom (@Sdate Varchar(11)) as 
select 
pqty = ( case when s.sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when s.sell_buy = 2 then sum(s.tradeqty) else 0 end )  ,
netrate = isnull((  select foclosing.cl_rate from foclosing
             	                  where foclosing.trade_date = ( select max(trade_date) from foclosing 
		                  where foclosing.trade_date < @SDate + ' 23:59') 
 		 		  and foclosing.Inst_Type = s.inst_type
                                  and foclosing.symbol=s.symbol   and foclosing.strike_price=s.strike_price and foclosing.option_type=s.option_type 
                                  and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                                 
                ),0),
cl_rate = isnull(( select foclosing.cl_rate from foclosing
                         where left(convert(varchar,foclosing.trade_date,109),11)  like @SDate 
                         and foclosing.Inst_Type = s.inst_type and foclosing.symbol=s.symbol 
                          and foclosing.strike_price=s.strike_price and foclosing.option_type=s.option_type 
                         and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                     
           ),0),

Party_Code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,
sdate = left(convert(varchar,sauda_date,109),11),sell_buy ,Service_Tax=0,Brok=0,sebi_tax=0,turn_tax=0 /* sebi tax and turn tax are added on 18 april and added in the group by clause*/
from FoSettlement s,foclosing c,foscrip2 
where c.Inst_Type = s.inst_type and
      c.Symbol = s.symbol 
 and c.strike_price=s.strike_price and c.option_type=s.option_type  and
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
group by left(convert(varchar,sauda_date,109),11),party_code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,sell_Buy,convert(varchar,s.expirydate,103),convert(varchar,c.expirydate,103),sebi_tax,turn_tax,s.strike_price,s.option_type

union all

select 
pqty = ( case when sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when sell_buy = 2 then sum(s.tradeqty) else 0 end ),
isnull(s.price,0),
isnull(c.cl_rate,0),
Party_Code,
s.Inst_Type,
s.Symbol,
S.EXPIRYDATE,
sdate=left(convert(varchar,sauda_date,109),11),
sell_buy,
service_tax = sum(SERVICE_TAX),
Brok=Sum(Brokapplied*tradeqty) ,
/*sebi_tax=sum(sebi_tax),
turn_tax=sum(turn_tax) *//* sebi tax and turn tax are added on 18 april and added in the group by clause*/

sebi_tax=sum(sebi_tax),
turn_tax=sum(turn_tax)

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
 and foscrip2.strike_price=c.strike_price and foscrip2.option_type=c.option_type 
           and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103)
       /*    and left(convert(varchar,foscrip2.maturitydate,109),11) <> @sdate  this was modified on 2nd feb 2001 the below line was added * */
          and foscrip2.maturitydate > @Sdate +' 23:59:00'
and left(s.inst_type,3) = 'FUT'
and left( foscrip2.inst_type,3) = 'FUT'
and left(c.inst_type,3) = 'FUT'
   group by left(convert(varchar,sauda_date,109),11),s.price,c.cl_rate,party_code,s.Inst_Type,
s.Symbol,S.EXPIRYDATE,left(convert(varchar,sauda_date,109),11),sell_Buy ,convert(varchar,c.expirydate,103), convert(varchar,s.expirydate,103),sebi_tax,turn_tax,s.strike_price,s.option_type
order by party_code,s.inst_type,s.symbol,s.expirydate

GO
