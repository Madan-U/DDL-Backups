-- Object: PROCEDURE dbo.fomtomdata1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.fomtomdata1    Script Date: 5/26/01 4:17:00 PM ******/
CREATE proc fomtomdata1 (@Sdate Varchar(11),@partycode varchar(10))as

/*Create Date : 7 march 2001 - Ranjeet Chouhdary*/
/*this cursor gives the output as total mtom, total brokerage,total service tax for a particular party code and */
/*and for a particular date*/
/*This cursor returns total mtom for the party code for the date as passed as parameter*/
/*and for the date passed as parameter */
/*Table used: Read only table: BFOSEttlement,bfoscrip2,bfoclosing */
/**/

 declare
   /* the below fields hold the value from the select query*/
     @@pqty as int,
     @@sqty as int,
     @@netrate as money,
     @@cl_rate as money,
     @@partycode as varchar(10),
     @@instru as varchar (7),
     @@symbol as varchar (7),
     @@expirydate as smalldatetime,
     @@sdate as datetime,
     @@sellbuy as int,
     @@servicetax as money,
     @@brokapplied as money,
     @@nbrokapp as money,
     @@turntax as money,
     @@billamount as money,

   /* the field holds the value which are calculated */
     @@mtom as money,
     @@brok as money,
     @@sertax as money,
     @@broksertax as money,
     @@nbrok as money,
     @@turnt as money,
     @@billamt as money,
     @@billamout as money,
     @@flag as cursor


/* setting the compuatational fields as zero here*/

select @@Mtom=0       /*This field holds total the mtom figure*/
select @@Brok=0       /*This field holds the total brokerage*/
select @@SerTax = 0   /*This field holds the total service tax*/
select @@broksertax=0
select @@billamt=0
select @@billamount=0
select @@nbrok=0
select @@turnt=0



set @@flag=cursor for 
   select 
pqty = ( case when s.sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when s.sell_buy = 2 then sum(s.tradeqty) else 0 end )  ,
netrate = isnull((  select foclosing.cl_rate from foclosing
             	                  where foclosing.trade_date = ( select max(trade_date) from foclosing 
		                  where foclosing.trade_date < @sdate+ ' 23:59' ) 
 		 		  and foclosing.Inst_Type = s.inst_type
                                  and foclosing.symbol=s.symbol   
                                  and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                                 
                ),0),
cl_rate = isnull(( select fofinalclosing.cl_rate from fofinalclosing
                         where left(convert(varchar,fofinalclosing.closingdate,109),11)  like @sdate
                         		and foscrip2.maturitydate = fofinalclosing.closingdate
                                        and fofinalclosing.UnderlyingAsset=s.symbol   
                         
                     
           ),isnull(( select foclosing.cl_rate from foclosing
                         where left(convert(varchar,foclosing.trade_date,109),11)  like @sdate 
                         and foclosing.Inst_Type = s.inst_type and foclosing.symbol=s.symbol 
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

NBrokApp= (case  when s.billflag > 3 then 
                           (abs(NBrokApp))
                           else
                               0 
               end),
turn_tax=0 /* sebi tax and turn tax are added on 18 april and added in the group by clause*/
from FoSettlement s,foclosing c,foscrip2 
where party_code=@partycode and
      c.Inst_Type = s.inst_type and
      c.Symbol = s.symbol and
      s.billflag>3 and
      left(convert(varchar,c.trade_date,109),11) = left(convert(varchar,sauda_date,109),11) and 
      left(convert(varchar,sauda_date,109),11) <= ( select max(sauda_date)
                                                   from fosettlement 
                                                   where sauda_date+1<= @sdate+ ' 23:59'
                                                 )
     and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
                         and foscrip2.inst_type=c.inst_type
    		         and foscrip2.symbol=c.symbol   
                         and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103)
                         and left(convert(varchar,foscrip2.maturitydate,109),11) = @sdate       
group by left(convert(varchar,sauda_date,109),11),party_code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,sell_Buy,convert(varchar,s.expirydate,103),convert(varchar,c.expirydate,103),NBrokApp,turn_tax,foscrip2.maturitydate,s.billflag

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
NBrokApp= (case  when s.billflag > 3 then 
                           (abs(NBrokApp))
                           else
                               0 
               end),turn_tax=0

from FoSettlement s,foclosing c,foscrip2
where    party_code=@partycode and
         c.Inst_Type = s.inst_type and
	 c.Symbol = s.symbol and
   	  left(convert(varchar,c.trade_date,109),11) = left(convert(varchar,sauda_date,109),11) and
          left(convert(varchar,sauda_date,109),11) = ( select left(convert(varchar,max(sauda_date),109),11) 
                                                      from fosettlement 
						      where left(convert(varchar,sauda_date,109),11) like @sdate
                                                     ) 
and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
           and foscrip2.inst_type=c.inst_type
           and foscrip2.symbol=c.symbol   
           and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103)
           and left(convert(varchar,foscrip2.maturitydate,109),11) = @sdate 
           and s.billflag>3
group by left(convert(varchar,sauda_date,109),11),s.price,c.cl_rate,party_code,s.Inst_Type,
s.Symbol,S.EXPIRYDATE,left(convert(varchar,sauda_date,109),11),sell_Buy ,convert(varchar,c.expirydate,103), convert(varchar,s.expirydate,103),NBrokApp,turn_tax,foscrip2.maturitydate,s.billflag
order by party_code,s.inst_type,s.symbol,s.expirydate




open @@flag
  fetch next from @@flag into
     @@pqty ,
     @@sqty ,
     @@netrate,
     @@cl_rate,
     @@partycode,
     @@instru ,
     @@symbol ,
     @@expirydate ,
     @@sdate ,
     @@sellbuy,
     @@servicetax ,
     @@brokapplied,
     @@NBrokApp ,
     @@turntax 
     

   while @@fetch_status =0
    begin 	
      select  @@mtom = @@mtom + ((( @@sqty * (@@netrate - @@cl_rate))) + ((@@pqty * (@@Cl_rate - @@netrate))))
      select  @@brok=@@brok+@@brokapplied
      select  @@sertax=@@sertax+@@servicetax 
      select  @@NBrok=@@NBrokApp
      select  @@turnt=@@turnt+@@turntax
      select  @@billamt=@@billamt+((( @@sqty * (@@netrate - @@cl_rate))) + ((@@pqty * (@@Cl_rate - @@netrate))))
     
      If @@billamt > 0 
          begin
             select   @@billamt = @@billamt - @@brokapplied - @@servicetax 
          end
      Else
          begin
             select    @@billamt = @@billamt - @@brokapplied  - @@servicetax 
          end
          
          select @@broksertax=@@brok+@@sertax 
          select @@billamount=@@billamt   

     fetch next from @@flag into
     @@pqty ,
     @@sqty ,
     @@netrate,
     @@cl_rate,
     @@partycode,
     @@instru ,
     @@symbol ,
     @@expirydate ,
     @@sdate ,
     @@sellbuy,
     @@servicetax ,
     @@brokapplied, 
     @@nbrokapp,
     @@turntax     
    end
   
   select  @@partycode as party_code,@@mtom as mtom,@@brok as brokerage,@@sertax as servicetax ,@@broksertax as totalbrokerageandsertax ,@@billamount as billamount,@@NBrokApp as nbrokapp,@@turnt as totalturntax
close @@flag
deallocate @@flag

GO
