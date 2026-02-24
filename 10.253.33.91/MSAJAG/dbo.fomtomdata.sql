-- Object: PROCEDURE dbo.fomtomdata
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.fomtomdata    Script Date: 5/26/01 4:17:00 PM ******/

CREATE proc fomtomdata (@Sdate Varchar(11),@partycode varchar(10))as

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
     @@sebitax as money,
     @@turntax as money,
     @@billamount as money,

   /* the field holds the value which are calculated */
     @@mtom as money,
     @@brok as money,
     @@sertax as money,
     @@broksertax as money,
     @@sebit as money,
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
select @@sebit=0
select @@turnt=0



set @@flag=cursor for 
   select 
	pqty = ( case when s.sell_buy = 1 then sum(s.tradeqty) else 0 end ),
	sqty = ( case when s.sell_buy = 2 then sum(s.tradeqty) else 0 end )  ,
	netrate = isnull((  select foclosing.cl_rate from foclosing
             	                  where foclosing.trade_date = ( select max(trade_date) from foclosing 
		                  where foclosing.trade_date < @SDate + ' 23:59') 
 		 		  and foclosing.Inst_Type = s.inst_type
                                  and foclosing.symbol=s.symbol   
                                  and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                                 
                ),0),

cl_rate = isnull(( select foclosing.cl_rate from foclosing
                         where left(convert(varchar,foclosing.trade_date,109),11)  like @SDate 
                         and foclosing.Inst_Type = s.inst_type and foclosing.symbol=s.symbol 
                         and convert(varchar,foclosing.expirydate,103) = convert(varchar,s.expirydate,103)
                     
           ),0),
Party_Code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,
sdate = left(convert(varchar,sauda_date,109),11),sell_buy ,Service_Tax=0,Brok=0,sebi_tax=0,turn_tax=0 /* sebi tax and turn tax are added on 18 april and added in the group by clause*/
from FoSettlement s,foclosing c,foscrip2 

    where s.party_code=@partycode and
          c.Inst_Type = s.inst_type and
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
 and foscrip2.maturitydate > @Sdate + ' 23:59:00'
group by left(convert(varchar,sauda_date,109),11),party_code,s.Inst_Type,s.Symbol,S.EXPIRYDATE,sell_Buy,convert(varchar,s.expirydate,103),convert(varchar,c.expirydate,103),sebi_tax,turn_tax

union all

select 
pqty = ( case when sell_buy = 1 then sum(s.tradeqty) else 0 end ),
sqty = ( case when sell_buy = 2 then sum(s.tradeqty) else 0 end ),
netrate=isnull(s.price,0),
isnull(c.cl_rate,0),
Party_Code,
s.Inst_Type,
s.Symbol,
S.EXPIRYDATE,
sdate=left(convert(varchar,sauda_date,109),11),
sell_buy,
service_tax = sum(SERVICE_TAX),
Brok=Sum(Brokapplied*tradeqty) ,
sebi_tax=sum(sebi_tax),turn_tax =sum(turn_tax)/* sebi tax and turn tax are added on 18 april and added in the group by clause*/
from FoSettlement s,foclosing c,foscrip2

where s.party_code=@partycode and
  c.Inst_Type = s.inst_type and
	 c.Symbol = s.symbol and
   	  left(convert(varchar,c.trade_date,109),11) = left(convert(varchar,sauda_date,109),11) and
          left(convert(varchar,sauda_date,109),11) = ( select left(convert(varchar,max(sauda_date),109),11) 
                                                      from fosettlement 
						      where left(convert(varchar,sauda_date,109),11) like @SDate
                                                     ) 
and convert(varchar,c.expirydate,103) = convert(varchar,s.expirydate,103)
           and foscrip2.inst_type=c.inst_type
           and foscrip2.symbol=c.symbol   
           and convert(varchar,c.expirydate,103) = convert(varchar,foscrip2.expirydate,103)
       /*    and left(convert(varchar,foscrip2.maturitydate,109),11) <> @sdate  this was modified on 2nd feb 2001 the below line was added * */          and foscrip2.maturitydate > @Sdate +' 23:59:00'
  
group by left(convert(varchar,sauda_date,109),11),s.price,c.cl_rate,party_code,s.Inst_Type,
s.Symbol,S.EXPIRYDATE,left(convert(varchar,sauda_date,109),11),sell_Buy ,convert(varchar,c.expirydate,103), convert(varchar,s.expirydate,103),sebi_tax,turn_tax 
order by party_code,s.inst_type,s.symbol

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
     @@sebitax ,
     @@turntax 
     

   while @@fetch_status =0
    begin 	
      select  @@mtom = @@mtom + ((( @@sqty * (@@netrate - @@cl_rate))) + ((@@pqty * (@@Cl_rate - @@netrate))))
      select  @@brok=@@brok+@@brokapplied
      select  @@sertax=@@sertax+@@servicetax 
      select  @@sebit=@@sebit+@@sebitax
      select  @@turnt=@@turnt+@@turntax
      select  @@billamt=@@billamt+((( @@sqty * (@@netrate - @@cl_rate))) + ((@@pqty * (@@Cl_rate - @@netrate))))
     
      If @@billamt > 0 
          begin
             select   @@billamt = @@billamt - @@brokapplied - @@servicetax - @@sebitax-@@turntax
          end
      Else
          begin
             select    @@billamt = @@billamt - @@brokapplied  - @@servicetax - @@sebitax-@@turntax
          end
          
          select @@broksertax=@@brok+@@sertax +@@sebit+@@turnt
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
     @@sebitax,
     @@turntax     
    end
   
   select  @@partycode as party_code,@@mtom as mtom,@@brok as brokerage,@@sertax as servicetax ,@@broksertax as totalbrokerageandsertax ,@@billamount as billamount,@@sebit as totalsebitax,@@turnt as totalturntax
close @@flag
deallocate @@flag

GO
