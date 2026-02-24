-- Object: PROCEDURE dbo.Saudasummarysettpt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.Saudasummarysettpt    Script Date: 3/17/01 9:56:05 PM ******/

/****** Object:  Stored Procedure dbo.Saudasummarysettpt    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.Saudasummarysettpt    Script Date: 20-Mar-01 11:39:04 PM ******/

CREATE PROCEDURE Saudasummarysettpt
@partycode varchar(10),
@fromdate varchar(25),
@todate  varchar(25),
@setttype varchar(2)
 AS
select distinct s.scrip_cd ,  
PAmt=round((case when s.sell_buy = 1 then sum(tradeqty*marketrate) else 0 end ),2), 
 SAmt=round((case when s.sell_buy = 2 then sum(tradeqty*marketrate) else 0 end ),2), 
 PQty=(case when s.sell_buy = 1 then sum(tradeqty) else 0 end ),  
SQty=(case when s.sell_buy = 2 then sum(tradeqty) else 0 end ) , 
Pbrk=round((case when s.sell_buy = 1 then sum(Brokapplied*tradeqty) else 0 end ),2),
 Sbrk=round((case when s.sell_buy = 2 then sum(Brokapplied*tradeqty) else 0 end ),2), s.sell_buy,s.series,s.SETT_TYPE 
 from settlement s where s.PARTY_CODE=@partycode and s.tradeqty > 0 and
 s.Sauda_date  >=@fromdate  and s.Sauda_date <=@todate and s.sett_type like @setttype 
 group by  s.scrip_cd,s.sell_buy ,s.series,s.SETT_TYPE 
union all
select Scrip_cd,pamt =  
(case when sell_buy = 2 then 
 isnull( sum(Tradeqty*rate ),0) end),
samt = (case when sell_buy = 1 then 
  isnull(sum(Tradeqty*rate ) ,0)  end),
pqty =  
(case when sell_buy = 2 then 
 isnull( sum(Tradeqty),0) end),
sqty = (case when sell_buy = 1 then 
  isnull(sum(Tradeqty) ,0)  end),
pbrok=0,sbrok=0, s.sell_buy,s.series,@setttype   from albmsaudasum s
where  sett_type = ( Case when @setttype = 'N' then 'L' else 'P' end) and sett_type in ('N','W' ) 
and  s.PARTY_CODE=@partycode and s.tradeqty > 0 and
 s.Sauda_date  >=@fromdate 
group by s.scrip_cd,s.sell_buy ,s.series,s.SETT_TYPE 
union all
select distinct s.scrip_cd ,  
PAmt=round((case when s.sell_buy = 1 then sum(tradeqty*marketrate) else 0 end ),2), 
 SAmt=round((case when s.sell_buy = 2 then sum(tradeqty*marketrate) else 0 end ),2), 
 PQty=(case when s.sell_buy = 1 then sum(tradeqty) else 0 end ),  
SQty=(case when s.sell_buy = 2 then sum(tradeqty) else 0 end ) , 
Pbrk=round((case when s.sell_buy = 1 then sum(Brokapplied*tradeqty) else 0 end ),2),
 Sbrk=round((case when s.sell_buy = 2 then sum(Brokapplied*tradeqty) else 0 end ),2), s.sell_buy,s.series,s.SETT_TYPE 
 from settlement s where s.PARTY_CODE=@partycode and s.tradeqty > 0 and
 s.Sauda_date  >=@fromdate  and s.Sauda_date <=@todate and sett_type  = ( Case when @setttype = 'N' then 'L' else 'P' end) and sett_type in ('N','W' ) 
 group by  s.scrip_cd,s.sell_buy ,s.series,s.SETT_TYPE 
 ORDER BY scrip_cd,sell_buy

GO
