-- Object: PROCEDURE dbo.fodailymtom2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.fodailymtom2    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.fodailymtom2    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.fodailymtom2    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.fodailymtom2    Script Date: 20-Mar-01 11:38:50 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

CREATE proc fodailymtom2
( @startdate varchar(11),
 @finishdate varchar(11)) as 

select  distinct s1.party_code,s1.inst_type,s1.symbol,s1.sec_name,s1.expirydate,left(convert(varchar,s1.sauda_date,105),11)sauda_date,
s1.strike_price,s1.option_type,

Pqty = isnull(( select sum(tradeqty) from fosettlement 
         where sell_buy = 1 and 
               fosettlement.inst_type=s1.inst_type and 
               fosettlement.symbol=s1.symbol and 
               fosettlement.expirydate=s1.expirydate and
   fosettlement.strike_price=s1.strike_price and
                fosettlement.option_type =s1.option_type  and
                  

left(convert(varchar,fosettlement.sauda_date,105),11)=left(convert(varchar,s1.sauda_date,105),11) and
left(convert(varchar,fosettlement.sauda_date,105),11) between @startdate and @finishdate 
               and (s1.party_code = fosettlement.party_code)),0),
SQty = isnull(( select sum(tradeqty) from fosettlement 
          where sell_buy = 2 and 
                fosettlement.inst_type=s1.inst_type and 
		fosettlement.symbol=s1.symbol and 
		fosettlement.expirydate=s1.expirydate and 	
   fosettlement.strike_price=s1.strike_price and
                fosettlement.option_type =s1.option_type  and
                  

left(convert(varchar,fosettlement.sauda_date,105),11)=left(convert(varchar,s1.sauda_date,105),11) and
left(convert(varchar,fosettlement.sauda_date,105),11) between @startdate and @finishdate and  
		(s1.party_code = fosettlement.party_code)),0),
buyamt = isnull(( select sum(amount) from fosettlement 
          where sell_buy = 1 and 
                fosettlement.inst_type=s1.inst_type and 
		fosettlement.symbol=s1.symbol and 
		fosettlement.expirydate=s1.expirydate and 	
   fosettlement.strike_price=s1.strike_price and
                fosettlement.option_type =s1.option_type  and
                  

left(convert(varchar,fosettlement.sauda_date,105),11)=left(convert(varchar,s1.sauda_date,105),11) and
left(convert(varchar,fosettlement.sauda_date,105),11) between @startdate and @finishdate  and 
		(s1.party_code = fosettlement.party_code)),0),
sellamt = isnull(( select sum(amount) from fosettlement 
          where sell_buy = 2 and 
                fosettlement.inst_type=s1.inst_type and 
		fosettlement.symbol=s1.symbol and 
		fosettlement.expirydate=s1.expirydate and 	
   fosettlement.strike_price=s1.strike_price and
                fosettlement.option_type =s1.option_type  and
                  

left(convert(varchar,fosettlement.sauda_date,105),11)=left(convert(varchar,s1.sauda_date,105),11) and
left(convert(varchar,fosettlement.sauda_date,105),11) between @startdate and @finishdate  and
   		(s1.party_code = fosettlement.party_code)),0)
from fosettlement s1 
where left(convert(varchar,s1..sauda_date,105),11) between @startdate and @finishdate
order by s1.party_code,s1.inst_type,s1.symbol,s1.sec_name,s1.expirydate,left(convert(varchar,s1.sauda_date,105),11),s1.strike_price,
s1.option_type

GO
