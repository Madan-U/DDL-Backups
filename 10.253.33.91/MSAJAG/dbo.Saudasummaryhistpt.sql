-- Object: PROCEDURE dbo.Saudasummaryhistpt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/****** Object:  Stored Procedure dbo.Saudasummaryhistpt    Script Date: 05/09/2001 7:16:34 AM ******/

/****** Object:  Stored Procedure dbo.Saudasummaryhistpt    Script Date: 04/21/2001 6:05:34 PM ******/

/****** Object:  Stored Procedure dbo.Saudasummaryhistpt    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.Saudasummaryhistpt    Script Date: 20-Mar-01 11:39:04 PM ******/

/* This sp is used in the saudasummary
    created by amt on15/02/2001 
   table used  history*/

CREATE PROCEDURE Saudasummaryhistpt
@partycode varchar(10),
@fromdate varchar(20),
@todate  varchar(20),
@setttype  varchar(2)
 AS


select distinct h.scrip_cd ,  
PAmt=round((case when h.sell_buy = 1 then sum(tradeqty*marketrate) else 0 end ),2), 
 SAmt=round((case when h.sell_buy = 2 then sum(tradeqty*marketrate) else 0 end ),2),
  PQty=(case when h.sell_buy = 1 then sum(tradeqty) else 0 end ),  
SQty=(case when h.sell_buy = 2 then sum(tradeqty) else 0 end ),
 Pbrk=round((case when h.sell_buy = 1 then sum(Brokapplied*tradeqty) else 0 end ),2), 
Sbrk=round((case when h.sell_buy = 2 then sum(Brokapplied*tradeqty) else 0 end ),2), h.sell_buy ,h.series,h.SETT_TYPE 
from history h where h.PARTY_CODE=@partycode and h.tradeqty > 0 and
 h. Sauda_date  >=@fromdate and h. Sauda_date <=@todate  and h.sett_type like @setttype 
 group by  h.scrip_cd,h.sell_buy, h.series ,h.SETT_TYPE 
union all
select Scrip_cd,pamt =  
isnull((case when sell_buy = 2 then 
  sum(Tradeqty*rate ) end),0),
samt = isnull((case when sell_buy = 1 then 
  sum(Tradeqty*rate ) end),0),
pqty =  
 isnull((case when sell_buy = 2 then 
 sum(Tradeqty) end),0),
sqty =  isnull((case when sell_buy = 1 then 
 sum(Tradeqty)  end),0) ,
pbrok=0,sbrok=0, s.sell_buy,s.series,@setttype   from albmsaudasum s
where  sett_type = ( Case when @setttype = 'N' then 'L' else 'P' end) and @setttype in ('N','W' ) 
and  s.PARTY_CODE=@partycode and s.tradeqty > 0 and
 s.Sauda_date  >=@fromdate  and s.Sauda_date <=@todate 
group by s.scrip_cd,s.sell_buy ,s.series,s.SETT_TYPE 
union all
select distinct s.scrip_cd ,  
PAmt=round((case when s.sell_buy = 1 then sum(tradeqty*marketrate) else 0 end ),2), 
 SAmt=round((case when s.sell_buy = 2 then sum(tradeqty*marketrate) else 0 end ),2), 
 PQty=(case when s.sell_buy = 1 then sum(tradeqty) else 0 end ),  
SQty=(case when s.sell_buy = 2 then sum(tradeqty) else 0 end ) , 
Pbrk=round((case when s.sell_buy = 1 then sum(Brokapplied*tradeqty) else 0 end ),2),
 Sbrk=round((case when s.sell_buy = 2 then sum(Brokapplied*tradeqty) else 0 end ),2), s.sell_buy,s.series,s.SETT_TYPE 
 from history s where s.PARTY_CODE=@partycode and s.tradeqty > 0  and
 s.Sauda_date  >=@fromdate and s.Sauda_date <=@todate  and s.Sauda_date <=@todate and sett_type  = ( Case when @setttype = 'N' then 'L' else 'P' end) and @setttype in ('N','W' ) 
 group by  s.scrip_cd,s.sell_buy ,s.series,s.SETT_TYPE 
 ORDER BY scrip_cd,sell_buy 

/*
select distinct h.scrip_cd ,  
PAmt=round((case when h.sell_buy = 1 then sum(tradeqty*marketrate) else 0 end ),2), 
 SAmt=round((case when h.sell_buy = 2 then sum(tradeqty*marketrate) else 0 end ),2),
  PQty=(case when h.sell_buy = 1 then sum(tradeqty) else 0 end ),  
SQty=(case when h.sell_buy = 2 then sum(tradeqty) else 0 end ),
 Pbrk=round((case when h.sell_buy = 1 then sum(Brokapplied*tradeqty) else 0 end ),2), 
Sbrk=round((case when h.sell_buy = 2 then sum(Brokapplied*tradeqty) else 0 end ),2), h.sell_buy,h.series,h.SETT_TYPE 
from history h where h.PARTY_CODE=@partycode and h.tradeqty > 0 and
 h. Sauda_date  >=@fromdate and h. Sauda_date <=@todate and h.sett_type like @setttype 
 group by  h.scrip_cd,h.sell_buy,h.series,h.SETT_TYPE 
 ORDER BY scrip_cd,sell_buy 
*/

GO
