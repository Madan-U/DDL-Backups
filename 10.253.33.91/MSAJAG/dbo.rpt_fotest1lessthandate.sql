-- Object: PROCEDURE dbo.rpt_fotest1lessthandate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_fotest1lessthandate    Script Date: 5/11/01 12:09:00 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest1lessthandate    Script Date: 5/7/2001 9:02:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest1lessthandate    Script Date: 5/5/2001 2:43:40 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest1lessthandate    Script Date: 5/5/2001 1:24:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest1lessthandate    Script Date: 4/30/01 5:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest1lessthandate    Script Date: 10/26/00 6:04:45 PM ******/







CREATE PROCEDURE rpt_fotest1lessthandate

@sdate varchar(12),
@partycode varchar(10)

AS

if (select count(*) from foaccbill where party_code = @partycode and billdate = @sdate  + ' 23:59' ) > 1 
begin
select 
pqty = ( case when s.sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when s.sell_buy = 2 then sum(s.tradeqty) else 0 end )  ,
netrate = isnull((  select foclosing.cl_rate from foclosing
                                where foclosing.trade_date = ( select max(trade_date) from foclosing 
                    where foclosing.trade_date < @sdate + ' 23:59') 
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
sdate = left(convert(varchar,sauda_date,109),11),sell_buy ,Service_Tax=0,Brok=0,s.expirydate as expdate,
sebitax = sum(sebi_tax),
turntax = sum(turn_tax),
s.strike_price, s.option_type, s.billno
from FoSettlement s,foclosing c,foscrip2 
where c.Inst_Type = s.inst_type and
      c.Symbol = s.symbol 
 and c.strike_price=s.strike_price and c.option_type=s.option_type  and
      left(convert(varchar,c.trade_date,109),11) = left(convert(varchar,sauda_date,109),11) and 
      left(convert(varchar,sauda_date,109),11) <= ( select max(sauda_date)
                                                   from fosettlement 
                                                   where sauda_date+1 <= @sdate + ' 23:59'
                                                 )
     and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
                         and foscrip2.inst_type=c.inst_type
               and foscrip2.symbol=c.symbol   
 and foscrip2.strike_price=c.strike_price and foscrip2.option_type=c.option_type 
and s.party_code = @partycode
                         and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103)
                    /*     and left(convert(varchar,foscrip2.maturitydate,109),11) <> 'Jun 20 2000'      this was modified on 2nd feb 2001 the below line was added */
                        and foscrip2.maturitydate > @sdate + ' 23:59:00'
and left(s.inst_type,3) = 'FUT'
and left( foscrip2.inst_type,3) = 'FUT'
and left(c.inst_type,3) = 'FUT'
group by left(convert(varchar,sauda_date,109),11),party_code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,sell_Buy,convert(varchar,s.expirydate,103),
s.strike_price, s.option_type,
convert(varchar,c.expirydate,103),
foscrip2.maturitydate,c.cl_rate, s.billno
order by s.party_code, s.inst_type, s.symbol, s.expirydate, s.billno
/*order by s.expdate,party_code,s.inst_type,s.symbol*/
end 
else
begin
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

Party_Code,s.Inst_Type,s.Symbol,convert(varchar,S.EXPIRYDATE,106) as expirydate,
sdate = left(convert(varchar,sauda_date,109),11),sell_buy ,Service_Tax=0,Brok=0,sebi_tax=0,turn_tax=0 /* sebi tax and turn tax are added on 18 april and added in the group by clause*/,
s.strike_price, s.option_type, s.billno
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
and s.party_code = @partycode
                    /*     and left(convert(varchar,foscrip2.maturitydate,109),11) <> @sdate      this was modified on 2nd feb 2001 the below line was added */
                        and foscrip2.maturitydate > @Sdate + ' 23:59:00'
and left(s.inst_type,3) = 'FUT'
and left( foscrip2.inst_type,3) = 'FUT'
and left(c.inst_type,3) = 'FUT'
group by left(convert(varchar,sauda_date,109),11),party_code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,sell_Buy,convert(varchar,s.expirydate,103),convert(varchar,c.expirydate,103),sebi_tax,turn_tax,s.strike_price,s.option_type,
s.strike_price, s.option_type, s.billno
order by s.party_code, s.inst_type, s.symbol, s.expirydate, s.billno







/*
select 
pqty = ( case when s.sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when s.sell_buy = 2 then sum(s.tradeqty) else 0 end )  ,
netrate = isnull((  select foclosing.cl_rate from foclosing
                                where foclosing.trade_date = ( select max(trade_date) from foclosing 
                    where foclosing.trade_date < @sdate + ' 23:59') 
        and foclosing.Inst_Type = s.inst_type
                                  and foclosing.symbol=s.symbol   and foclosing.strike_price=s.strike_price and foclosing.option_type=s.option_type 
                                  and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                                 
                ),0),*/
/*cl_rate = isnull(( select foclosing.cl_rate from foclosing
                         where left(convert(varchar,foclosing.trade_date,109),11)  like @sdate
                         and foclosing.Inst_Type = s.inst_type and foclosing.symbol=s.symbol 
                         and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                     
           ),0),*/

/*
Cl_Rate =   isnull(( select fofinalclosing.cl_rate from fofinalclosing
                         where left(convert(varchar,fofinalclosing.closingdate,109),11)  like @sdate
                         		and foscrip2.maturitydate = fofinalclosing.closingdate
                                        and fofinalclosing.UnderlyingAsset=s.symbol   
                         
                     
           ),isnull(( select foclosing.cl_rate from foclosing
                         where left(convert(varchar,foclosing.trade_date,109),11)  like @sdate
                         and foclosing.Inst_Type = s.inst_type and foclosing.symbol=s.symbol 
	           and foclosing.strike_price=s.strike_price and foclosing.option_type=s.option_type 
                         and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                     
           ),0)),*/
/*
cl_rate = isnull(( select foclosing.cl_rate from foclosing
                         where left(convert(varchar,foclosing.trade_date,109),11)  like @SDate 
                         and foclosing.Inst_Type = s.inst_type and foclosing.symbol=s.symbol 
                          and foclosing.strike_price=s.strike_price and foclosing.option_type=s.option_type 
                         and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                     
           ),0),
Party_Code,s.Inst_Type,s.Symbol,convert(varchar,S.EXPIRYDATE,106) as expirydate,
sdate = left(convert(varchar,sauda_date,109),11),sell_buy ,Service_Tax=0,Brok=0,s.expirydate as expdate,
sebitax = sum(sebi_tax),
turntax = sum(turn_tax),
s.strike_price, s.option_type
from FoSettlement s,foclosing c,foscrip2 
where c.Inst_Type = s.inst_type and
      c.Symbol = s.symbol 
 and c.strike_price=s.strike_price and c.option_type=s.option_type  and
      left(convert(varchar,c.trade_date,109),11) = left(convert(varchar,sauda_date,109),11) and 
      left(convert(varchar,sauda_date,109),11) <= ( select max(sauda_date)
                                                   from fosettlement 
                                                   where sauda_date+1 <= @sdate + ' 23:59'
                                                 )
     and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
                         and foscrip2.inst_type=c.inst_type
               and foscrip2.symbol=c.symbol   
 and foscrip2.strike_price=c.strike_price and foscrip2.option_type=c.option_type 
and s.party_code = @partycode
                         and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103)*/
                    /*     and left(convert(varchar,foscrip2.maturitydate,109),11) <> 'Jun 20 2000'      this was modified on 2nd feb 2001 the below line was added */
/*                        and foscrip2.maturitydate >= @sdate *//*+ ' 23:59:00'*/
/*group by left(convert(varchar,sauda_date,109),11),party_code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,sell_Buy,convert(varchar,s.expirydate,103),
convert(varchar,c.expirydate,103),
foscrip2.maturitydate,c.cl_rate, s.strike_price, s.option_type
order by s.expdate,party_code,s.inst_type,s.symbol*/
end

GO
