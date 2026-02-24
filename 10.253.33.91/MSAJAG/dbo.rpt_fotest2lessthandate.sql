-- Object: PROCEDURE dbo.rpt_fotest2lessthandate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_fotest2lessthandate    Script Date: 5/11/01 12:09:01 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest2lessthandate    Script Date: 5/7/2001 9:02:52 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest2lessthandate    Script Date: 5/5/2001 2:43:40 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest2lessthandate    Script Date: 5/5/2001 1:24:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest2lessthandate    Script Date: 4/30/01 5:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest2lessthandate    Script Date: 10/26/00 6:04:45 PM ******/







CREATE PROCEDURE rpt_fotest2lessthandate

@sdate varchar(12),
@partycode varchar(10)

AS

select 
pqty = ( case when s.sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when s.sell_buy = 2 then sum(s.tradeqty) else 0 end )  ,
netrate = isnull((  select foclosing.cl_rate from foclosing
                                where foclosing.trade_date = ( select max(trade_date) from foclosing 
                    where foclosing.trade_date < @sdate+ ' 23:59' ) 
        and foclosing.Inst_Type = s.inst_type
                                  and foclosing.symbol=s.symbol   
                                 and foclosing.strike_price=s.strike_price and foclosing.option_type =s.option_type 
                                  and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                                 
                ),0),


cl_rate = isnull(( select fofinalclosing.cl_rate from fofinalclosing
                         where left(convert(varchar,fofinalclosing.closingdate,109),11)  like @sdate
                         		and foscrip2.maturitydate = fofinalclosing.closingdate
                                        and fofinalclosing.UnderlyingAsset=s.symbol ),isnull(( select foclosing.cl_rate from foclosing
                         where left(convert(varchar,foclosing.trade_date,109),11)  like @SDate + '%' 
                         and foclosing.Inst_Type = s.inst_type and foclosing.symbol=s.symbol 
                          and foclosing.strike_price=s.strike_price and foclosing.option_type =s.option_type 
                         and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                     
           ),0)),
Party_Code,s.Inst_Type,s.Symbol, left(convert(varchar,S.EXPIRYDATE,109),11) as expirydate,
sdate = left(convert(varchar,sauda_date,109),11),sell_buy ,
Service_Tax=0,
Brok=0, 
/*
service_tax=(case  when s.billflag > 3 then 
                            Sum( NSerTax  )
                           else
                               0 
               end),
Brok= (case  when s.billflag > 3 then 
                            Sum(abs(NBrokApp)*tradeqty)
                           else
                               0 
               end),*/
convert(varchar,s.expirydate,106) as expdate, sebitax=0,turntax=0,
s.strike_price, s.option_type
from FoSettlement s,foclosing c,foscrip2 
where c.Inst_Type = s.inst_type and
        c.Symbol = s.symbol and c.strike_price=s.strike_price and c.option_type =s.option_type and
      left(convert(varchar,c.trade_date,109),11) = left(convert(varchar,sauda_date,109),11) and 
      left(convert(varchar,sauda_date,109),11) <= ( select max(sauda_date)
                                                   from fosettlement 
                                                   where sauda_date < @sdate
                                                 )
     and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
                         and foscrip2.inst_type=c.inst_type
               and foscrip2.symbol=c.symbol   
 and foscrip2.strike_price=s.strike_price and foscrip2.option_type =s.option_type  
                         and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103)
and s.party_code = @partycode
                         and left(convert(varchar,foscrip2.maturitydate,109),11) like  @sdate +'%'
and left(c.inst_type,3) = 'FUT'
and left(s.inst_type,3) = 'FUT'
and  left(foscrip2 .inst_type,3) = 'FUT'
group by left(convert(varchar,sauda_date,109),11),party_code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,sell_Buy,convert(varchar,s.expirydate,103),convert(varchar,c.expirydate,103),
foscrip2.maturitydate,c.cl_rate, s.strike_price, s.option_type, s.billflag

GO
