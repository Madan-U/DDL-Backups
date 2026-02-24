-- Object: PROCEDURE dbo.FoTotalMtom
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.FoTotalMtom    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.FoTotalMtom    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.FoTotalMtom    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.FoTotalMtom    Script Date: 20-Mar-01 11:38:50 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

/*procedure updated on 16 jan 2001*/
/*created by ranjeet choudhary*/
CREATE Procedure FoTotalMtom (@Sdate Varchar(11)) as 
select 
pqty = ( case when s.sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when s.sell_buy = 2 then sum(s.tradeqty) else 0 end )  ,
netrate = isnull((  select cl_rate from foclosing 
             	where trade_date = ( select max(trade_date) from foclosing 
		                  where trade_date < @SDate+ ' 23:59' ) 
 		 		  and Inst_Type = s.inst_type and symbol=s.symbol and convert(varchar,expirydate,103) = convert(varchar,s.expirydate,103)
                                                            and option_type=s.option_type and strike_price=s.strike_price
           ),0),
cl_rate = isnull(( select cl_rate from foclosing 
            where left(convert(varchar,trade_date,109),11)  like @SDate and Inst_Type = s.inst_type and symbol=s.symbol and convert(varchar,expirydate,103) = convert(varchar,s.expirydate,103)
and option_type=s.option_type and strike_price=s.strike_price
           ),0),
Party_Code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,
sdate = left(convert(varchar,sauda_date,109),11),sell_buy ,Service_Tax=0,Brok=0
from FoSettlement s,foclosing c
where c.Inst_Type = s.inst_type and
      c.Symbol = s.symbol 
  and c.option_type=s.option_type and c.strike_price=s.strike_price and
      left(convert(varchar,c.trade_date,109),11) = left(convert(varchar,sauda_date,109),11) and 
      left(convert(varchar,sauda_date,109),11) <= ( select max(sauda_date)
                                                   from fosettlement 
                                                   where sauda_date+1 <= @Sdate+ ' 23:59'
                                                 )
and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
group by left(convert(varchar,sauda_date,109),11),party_code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,sell_Buy,convert(varchar,s.expirydate,103),convert(varchar,c.expirydate,103),
s.strike_price,s.option_type

union all

select 
pqty = ( case when sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when sell_buy = 2 then sum(s.tradeqty) else 0 end ),
isnull(s.price,0),isnull(c.cl_rate,0),Party_Code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,
sdate=left(convert(varchar,sauda_date,109),11),sell_buy,service_tax = sum(SERVICE_TAX),Brok=Sum(Brokapplied*tradeqty) 
from FoSettlement s,foclosing c
where c.Inst_Type = s.inst_type and
	 c.Symbol = s.symbol and
  c.option_type=s.option_type and c.strike_price=s.strike_price and
	left(convert(varchar,c.trade_date,109),11) = left(convert(varchar,sauda_date,109),11) and
         left(convert(varchar,sauda_date,109),11) = ( select left(convert(varchar,max(sauda_date),109),11) 
                                                      from fosettlement 
						      where left(convert(varchar,sauda_date,109),11) like @SDate
                                                     ) 
and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
group by left(convert(varchar,sauda_date,109),11),s.price,c.cl_rate,party_code,s.Inst_Type,
s.Symbol,S.EXPIRYDATE,left(convert(varchar,sauda_date,109),11),sell_Buy ,convert(varchar,c.expirydate,103), convert(varchar,s.expirydate,103),
s.strike_price,s.option_type
order by party_code

GO
