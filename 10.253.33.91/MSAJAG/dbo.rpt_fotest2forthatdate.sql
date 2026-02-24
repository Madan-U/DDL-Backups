-- Object: PROCEDURE dbo.rpt_fotest2forthatdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_fotest2forthatdate    Script Date: 5/11/01 12:09:00 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest2forthatdate    Script Date: 5/7/2001 9:02:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest2forthatdate    Script Date: 5/5/2001 2:43:40 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest2forthatdate    Script Date: 5/5/2001 1:24:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest2forthatdate    Script Date: 4/30/01 5:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotest2forthatdate    Script Date: 10/26/00 6:04:45 PM ******/







CREATE PROCEDURE rpt_fotest2forthatdate

@sdate varchar(12),
@partycode varchar(10)

AS

select 
pqty = ( case when sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when sell_buy = 2 then sum(s.tradeqty) else 0 end ),
netrate = isnull(s.price,0),

Cl_Rate =   isnull(( select fofinalclosing.cl_rate from fofinalclosing
                         where left(convert(varchar,fofinalclosing.closingdate,109),11)  like @sdate
                         		and foscrip2.maturitydate = fofinalclosing.closingdate
                                        and fofinalclosing.UnderlyingAsset=s.symbol   
                         
                     
           ),c.cl_rate),
Party_Code,
s.Inst_Type,
s.Symbol,
S.EXPIRYDATE,
sdate=left(convert(varchar,sauda_date,109),11),sell_buy,
service_tax=(case  when s.billflag > 3 then 
                            Sum( NSerTax  )
                           else
                               0 
               end),



Brok= (case  when s.billflag > 3 then 
                            Sum(abs(NBrokApp)*tradeqty)
                           else
                              Sum(Brokapplied*tradeqty)
               end),

/*service_tax = sum(SERVICE_TAX),
Brok=Sum(Brokapplied*tradeqty) ,*/
 convert(varchar,s.expirydate,106) as expdate,
sebitax = sum(sebi_tax),
turntax = sum(turn_tax), s.strike_price, s.option_type, s.price
from FoSettlement s,foclosing c,foscrip2
where c.Inst_Type = s.inst_type and
  c.Symbol = s.symbol and
 c.strike_price=s.strike_price and c.option_type =s.option_type  and
      left(convert(varchar,c.trade_date,109),11) = left(convert(varchar,sauda_date,109),11) and
          left(convert(varchar,sauda_date,109),11) = ( select left(convert(varchar,max(sauda_date),109),11) 
                                                      from fosettlement 
            where left(convert(varchar,sauda_date,109),11) like @sdate
                                                     ) 
and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
           and foscrip2.inst_type=c.inst_type
           and foscrip2.symbol=c.symbol   and
 c.strike_price=s.strike_price and c.option_type =s.option_type  
and s.party_code = @partycode
           and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103)
           and left(convert(varchar,foscrip2.maturitydate,109),11) like @sdate
    
group by left(convert(varchar,sauda_date,109),11),s.price,c.cl_rate,party_code,s.Inst_Type,
s.Symbol,S.EXPIRYDATE,left(convert(varchar,sauda_date,109),11),sell_Buy ,convert(varchar,c.expirydate,103), convert(varchar,s.expirydate,103), foscrip2.maturitydate,
s.strike_price, s.option_type, s.billflag, s.price
order by expdate,party_code,s.inst_type,s.symbol

GO
