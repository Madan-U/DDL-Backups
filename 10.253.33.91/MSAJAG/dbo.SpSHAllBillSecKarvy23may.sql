-- Object: PROCEDURE dbo.SpSHAllBillSecKarvy23may
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc SpSHAllBillSecKarvy23may (@Sett_No varchar(10),@Sett_Type Varchar(2), @Party_code varchar(10)) as
SELECT  s.party_code,  s.billno, s.scrip_cd, s.series, scripname=scrip1.short_name,
sdt=substring(convert(VARchar,sauda_date,109),1,11),  s.sell_buy, s.markettype,
  pqty=isnull((case sell_buy  when 1 then SUM( s.tradeqty) end),0),
 sqty=isnull((case sell_buy  when 2 then SUM( s.tradeqty) end),0),
 pnetrate=isnull((case sell_buy  when 1 then ( case when service_chrg = 1 then 
		sum(( s.marketrate  +  s.Nbrokapp+(nsertax/tradeqty)) *tradeqty)/sum(tradeqty)
		else
		sum(( s.marketrate  +  s.Nbrokapp) *tradeqty)/sum(tradeqty)
		end ) 
	end),0),
 snetrate=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			sum(( s.marketrate  -  s.Nbrokapp-(nsertax/tradeqty)) *tradeqty)/sum(tradeqty)
		else
		sum(( s.marketrate  -  s.Nbrokapp) *tradeqty)/sum(tradeqty)
		end ) 
	end),0),
 pamt=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			SUM(( s.marketrate +  s.Nbrokapp) * tradeqty + nsertax)
		else
			SUM(( s.marketrate +  s.Nbrokapp) * tradeqty)
		end ) 
	end),0),
 samt=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			SUM(( s.marketrate -  s.Nbrokapp) * tradeqty - nsertax)
		else
			SUM(( s.marketrate -  s.Nbrokapp) * tradeqty)
		end ) 
	 end),0),
NewFixmargin=0,
NewAddMar = 0,
OldFixMargin=0,
OldAddMar=0,
/*settlementflag =		
			
				
		(CASE WHEN  s.billflag =1 or  s.tmark ='D' THEN  'D'  
           		ELSE 
				(CASE WHEN   s.billflag =4  THEN  'D'  
					ELSE
						(CASE WHEN   s.billflag =5  THEN  'D'   else  ' '
 						 END) 
					END) 
			END) ,*/s.billflag
from settlement s,scrip1,scrip2,client2
where  s.scrip_cd=scrip2.scrip_cd
 and  s.series=scrip2.series
 and scrip2.co_code=scrip1.co_code
 and scrip2.series=scrip1.series
          and  s.sett_no = @sett_no
        and  s.sett_type = @Sett_Type
 and  s.Party_Code=@party_Code
/* AND  s.BILLNO <> '0' */
 AND  s.TRADEQTY <> '0'
and client2.party_code =  s.party_code   and s.billflag='2' or s.billflag='3'
GROUP BY   s.party_code,  s.billno, s.scrip_cd, s.series, scrip1.short_name,
substring(convert(VARchar,sauda_date,109),1,11),  s.sell_buy, s.markettype,
n_netrate,CLIENT2.SERVICE_CHRG,s.tmark,s.sett_type,s.billflag

UNION ALL

SELECT  s.party_code,  s.billno, s.scrip_cd, s.series /*scripname=scrip1.short_name*/, scripname='*'+scrip1.short_name,
sdt=substring(convert(VARchar,sauda_date,109),1,11),  s.sell_buy, s.markettype,
 pqty=isnull((case sell_buy  when 1 then SUM( s.tradeqty) end),0),
 sqty=isnull((case sell_buy  when 2 then SUM( s.tradeqty) end),0),
 pnetrate=isnull((case sell_buy  when 1 then ( case when service_chrg = 1 then 
			sum(( s.marketrate  +  s.Nbrokapp+(nsertax/tradeqty)) *tradeqty)/sum(tradeqty)
		else
		sum(( s.marketrate  +  s.Nbrokapp) *tradeqty)/sum(tradeqty)
		end ) 
	end),0),
 snetrate=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			sum(( s.marketrate  -  s.Nbrokapp-(nsertax/tradeqty)) *tradeqty)/sum(tradeqty)
		else
		sum(( s.marketrate -  s.Nbrokapp) *tradeqty)/sum(tradeqty)
		end ) 
	end),0),
 pamt=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			SUM(( s.marketrate +  s.Nbrokapp) * tradeqty + nsertax)
		else
			SUM(( s.marketrate +  s.Nbrokapp) * tradeqty)
		end ) 
	end),0),
 samt=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			SUM(( s.marketrate -  s.Nbrokapp) * tradeqty - nsertax)
		else
			SUM(( s.marketrate -  s.Nbrokapp) * tradeqty)
		end ) 
	 end),0),
NewfIXMARGIN = ( case when (client2.albmdelchrg = 0 or albmdelchrg = 2 ) then (Case when TMARK <> '$' then ISNULL(( SELECT fixmargin FROM MARGIN1 WHERE SETT_NO= s.SETT_NO AND SETT_TYPE =  s.SETT_TYPE ),0)  *SUM(TRADEQTY*MARKETRATE)/100 else 0 end ) else 0 end) , 
NewADDMAR =  ( case when (client2.albmdelchrg = 0 or albmdelchrg = 2 ) then ISNULL((Case when TMARK <> '$' then ISNULL(( SELECT AddMargin FROM MARGIN2 WHERE SETT_TYPE =  s.SETT_TYPE AND SCRIP_CD =  s.SCRIP_CD  and sett_no =  s.sett_no ),0)*SUM(TRADEQTY*MARKETRATE)/100 else 0 end ),0) else 0 end ),
OldFixMargin=0,
OldAddMar=0/*,settlementflag= '*' */,s.billflag
from settlement s, scrip1 ,scrip2 , client2 
           where  s.sett_no = ( select min(sett_no) from sett_mst where sett_no > @sett_no and sett_Type = 'N')
           and  s.sett_type = 'L'
       and  s.Party_code =@party_Code
                   and  s.scrip_cd = scrip2.scrip_cd
                   and  s.series = scrip2.series
                   and scrip1.co_code = scrip2.co_Code
    and scrip1.series = scrip2.series
           and TRADEQTY <> '0'
and  s.party_code = client2.party_code and s.billflag='2' or s.billflag='3'
GROUP BY   s.party_code,  s.billno, s.scrip_cd, s.series, scrip1.short_name,
substring(convert(VARchar,sauda_date,109),1,11),  s.sell_buy, s.markettype,
n_netrate,client2.SERVICE_CHRG,SETT_NO,SETT_TYPE,TMARK,client2.albmdelchrg,s.tmark,s.sett_type,s.billflag

UNION ALL

SELECT  s.party_code,  s.billno, s.scrip_cd, s.series, /*scripname=scrip1.short_name,*/ scripname='~'+scrip1.short_name,
sdt=substring(convert(VARchar,sauda_date,109),1,11),  s.sell_buy, s.markettype,
 pqty=isnull((case sell_buy when 2 then SUM(tradeqty) end),0),
 sqty=isnull((case sell_buy when 1 then SUM(tradeqty) end),0),
 pnetrate=isnull((case sell_buy when 2 then Rate end),0),
 snetrate=isnull((case sell_buy  when 1 then Rate end),0),
 pamt=isnull((case sell_buy when 2 then SUM(Rate*TradeQty) end),0),
 samt=isnull((case sell_buy when 1 then SUM(Rate*TradeQty) end),0),
NewFixmargin=0,
NewAddMar = 0,
OldfIXMARGIN = ( case when (client2.albmdelchrg = 0 or albmdelchrg = 2 ) then (Case when TMARK <> '$' then ISNULL(( SELECT fixmargin FROM MARGIN1 WHERE SETT_NO= s.SETT_NO AND SETT_TYPE =  s.SETT_TYPE ),0)  *SUM(TRADEQTY*MARKETRATE)/100 else 0 end ) else 0 end) , 
OldADDMAR =  ( case when (client2.albmdelchrg = 0 or albmdelchrg = 2 ) then ISNULL((Case when TMARK <> '$' then ISNULL(( SELECT AddMargin FROM MARGIN2 WHERE SETT_TYPE =  s.SETT_TYPE AND SCRIP_CD =  s.SCRIP_CD  and sett_no =  s.sett_no ),0)*SUM(TRADEQTY*MARKETRATE)/100 else 0 end ),0) else 0 end ),
/*settlementflag='~' */s.billflag
 from  settlement s, AlbmRate A , scrip1 , scrip2 , client2 
           where  s.sett_no = @sett_no
           and  s.sett_type = 'L'
       and  s.Party_code = @party_Code
    and  s.sett_no = a.sett_no
    and  s.sett_type = a.sett_type
    and  s.scrip_cd = a.scrip_cd
    and  s.series = a.series
    and  s.scrip_cd = scrip2.scrip_cd
    and  s.series = scrip2.series
                and scrip1.co_Code = scrip2.co_code
    AND scrip1..SERIES = scrip2..SERIES
           and TRADEQTY <> '0'
and  s.party_code = client2.party_code   and s.billflag='2'  or  s.billflag='3'
GROUP BY   s.party_code,  s.billno, s.scrip_cd, s.series, scrip1.short_name,
substring(convert(VARchar,sauda_date,109),1,11),  s.sell_buy, s.markettype,
n_netrate,client2.SERVICE_CHRG, s.SETT_NO, s.SETT_TYPE,TMARK,client2.albmdelchrg,Rate,s.tmark,s.sett_type,s.billflag

UNION ALL

SELECT  s.party_code, s.billno, s.scrip_cd,  s.series, scripname=scrip1.short_name,
sdt=substring(convert(VARchar,sauda_date,109),1,11), s.sell_buy,  s.markettype,
  pqty=isnull((case sell_buy  when 1 then SUM(  s.tradeqty) end),0),
 sqty=isnull((case sell_buy  when 2 then SUM(  s.tradeqty) end),0),
 pnetrate=isnull((case sell_buy  when 1 then ( case when service_chrg = 1 then 
			sum(( s.marketrate  +  s.Nbrokapp+(nsertax/tradeqty)) *tradeqty)/sum(tradeqty)
		else
		sum(( s.marketrate  +  s.Nbrokapp) *tradeqty)/sum(tradeqty)
		end ) 
	end),0),
 snetrate=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			sum(( s.marketrate  -  s.Nbrokapp-(nsertax/tradeqty)) *tradeqty)/sum(tradeqty)
		else
		sum(( s.marketrate  -  s.Nbrokapp) *tradeqty)/sum(tradeqty)
		end ) 
	end),0),
 pamt=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			SUM((  s.marketrate + s.Nbrokapp) * tradeqty + nsertax)
		else
			SUM((  s.marketrate + s.Nbrokapp) * tradeqty)
		end ) 
	end),0),
 samt=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			SUM((  s.marketrate - s.Nbrokapp) * tradeqty - nsertax)
		else
			SUM((  s.marketrate - s.Nbrokapp) * tradeqty)
		end ) 
	 end),0),
NewFixmargin=0,
NewAddMar = 0,
OldFixmargin=0,
OldAddMar = 0,
/*settlementflag =		
			
				
		(CASE WHEN  s.billflag =1 or  s.tmark ='D' THEN  'D'  
           		ELSE 
				(CASE WHEN   s.billflag =4  THEN  'D'  
					ELSE
						(CASE WHEN   s.billflag =5  THEN  'D'   else  ' '
 						 END) 
					END) 
			END) , */ s.billflag
from  history s,scrip1,scrip2,client2
where  s.scrip_cd=scrip2.scrip_cd
 and  s..series=scrip2.series
 and scrip2.co_code=scrip1.co_code
 and scrip2.series=scrip1.series
          and  s.sett_no = @sett_no
        and  s.sett_type = @Sett_Type
 and  s.Party_Code=@party_Code
/* AND  s.BILLNO <> '0' */
 AND  s.TRADEQTY <> '0'
and client2.party_code =  s.party_code and s.billflag='2'  or  s.billflag='3'
GROUP BY   s.party_code,  s.billno,  s.scrip_cd,  s.series, scrip1.short_name,
substring(convert(VARchar,sauda_date,109),1,11),  s.sell_buy,  s.markettype,
n_netrate,CLIENT2.SERVICE_CHRG,s.tmark,s.sett_type,s.billflag

union all

SELECT  s.party_code,  s.billno,  s.scrip_cd,  s.series, /* scripname='*'+scrip1.short_name,*/ scripname='*'+scrip1.short_name,
sdt=substring(convert(VARchar,sauda_date,109),1,11),  s.sell_buy,  s.markettype,
 pqty=isnull((case sell_buy  when 1 then SUM(  s.tradeqty) end),0),
 sqty=isnull((case sell_buy  when 2 then SUM(  s.tradeqty) end),0),
 pnetrate=isnull((case sell_buy  when 1 then ( case when service_chrg = 1 then 
			sum(( s.marketrate  +  s.Nbrokapp+(nsertax/tradeqty)) *tradeqty)/sum(tradeqty)
		else
		sum(( s.marketrate  +  s.Nbrokapp) *tradeqty)/sum(tradeqty)
		end ) 
	end),0),
 snetrate=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			sum(( s.marketrate -  s.Nbrokapp-(nsertax/tradeqty)) *tradeqty)/sum(tradeqty)
		else
		sum(( s.marketrate  -  s.Nbrokapp) *tradeqty)/sum(tradeqty)
		end ) 
	end),0),
 pamt=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			SUM((  s.marketrate +  s.Nbrokapp) * tradeqty + nsertax)
		else
			SUM((  s.marketrate +  s.Nbrokapp) * tradeqty)
		end ) 
	end),0),
 samt=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			SUM((  s.marketrate -  s.Nbrokapp) * tradeqty - nsertax)
		else
			SUM((  s.marketrate -  s.Nbrokapp) * tradeqty)
		end ) 
	 end),0),
NewfIXMARGIN = ( case when (client2.albmdelchrg = 0 or albmdelchrg = 2 ) then (Case when TMARK <> '$' then ISNULL(( SELECT fixmargin FROM MARGIN1 WHERE SETT_NO=  s.SETT_NO AND SETT_TYPE =  s.SETT_TYPE ),0)  *SUM(TRADEQTY*MARKETRATE)/100 else 0 end ) else 0 end) , 
NewADDMAR =  ( case when (client2.albmdelchrg = 0 or albmdelchrg = 2 ) then ISNULL((Case when TMARK <> '$' then ISNULL(( SELECT AddMargin FROM MARGIN2 WHERE SETT_TYPE =  s.SETT_TYPE AND SCRIP_CD =  s.SCRIP_CD  and sett_no =  s.sett_no ),0)*SUM(TRADEQTY*MARKETRATE)/100 else 0 end ),0) else 0 end ),
OldFixmargin=0,
OldAddMar = 0,/*settlementflag='*',*/ s.BILLFLAG
from history s, scrip1 ,scrip2 , client2 
           where  s.sett_no = ( select min(sett_no) from sett_mst where sett_no > @sett_no and sett_Type = 'N')
           and  s.sett_type = 'L'
       and  s.Party_code = @party_Code
                   and  s.scrip_cd = scrip2.scrip_cd
                   and  s.series = scrip2.series
                   and scrip1.co_code = scrip2.co_Code
    and scrip1.series = scrip2.series
           and TRADEQTY <> '0'
and  s.party_code = client2.party_code and s.billflag='2' or s.billflag='3'
GROUP BY   s.party_code,  s.billno,  s.scrip_cd,  s.series, scrip1.short_name,
substring(convert(VARchar,sauda_date,109),1,11),  s.sell_buy,  s.markettype,
n_netrate,client2.SERVICE_CHRG,SETT_NO,SETT_TYPE,TMARK,client2.albmdelchrg,s.billflag

union all

SELECT  s.party_code,  s.billno,  s.scrip_cd,  s.series, /*scripname=scrip1.short_name, */ scripname='~'+scrip1.short_name,
sdt=substring(convert(VARchar,sauda_date,109),1,11),  s.sell_buy,  s.markettype,
 pqty=isnull((case sell_buy when 2 then SUM(tradeqty) end),0),
 sqty=isnull((case sell_buy when 1 then SUM(tradeqty) end),0),
 pnetrate=isnull((case sell_buy when 2 then Rate end),0),
 snetrate=isnull((case sell_buy  when 1 then Rate end),0),
 pamt=isnull((case sell_buy when 2 then SUM(Rate*TradeQty) end),0),
 samt=isnull((case sell_buy when 1 then SUM(Rate*TradeQty) end),0),
NewFixmargin=0,
NewAddMar = 0,
 OldfIXMARGIN = ( case when (client2.albmdelchrg = 0 or albmdelchrg = 2 ) then (Case when TMARK <> '$' then ISNULL(( SELECT fixmargin FROM MARGIN1 WHERE SETT_NO=  s.SETT_NO AND SETT_TYPE =  s.SETT_TYPE ),0)  *SUM(TRADEQTY*MARKETRATE)/100 else 0 end ) else 0 end) , 
 OldADDMAR =  ( case when (client2.albmdelchrg = 0 or albmdelchrg = 2 ) then ISNULL((Case when TMARK <> '$' then ISNULL(( SELECT AddMargin FROM MARGIN2 WHERE SETT_TYPE =  s.SETT_TYPE AND SCRIP_CD =  s.SCRIP_CD  and sett_no =  s.sett_no ),0)*SUM(TRADEQTY*MARKETRATE)/100 else 0 end ),0) else 0 end )
/*,settlementflag= '~'*/,s.BILLFLAG
 from history s, AlbmRate A , scrip1 , scrip2 , client2 
           where  s.sett_no = @sett_no
           and  s.sett_type = 'L'
       and  s.Party_code = @party_Code
    and  s.sett_no = a.sett_no
    and  s.sett_type = a.sett_type
    and  s.scrip_cd = a.scrip_cd
    and  s.series = a.series
    and  s.scrip_cd = scrip2.scrip_cd
    and  s.series = scrip2.series
                and scrip1.co_Code = scrip2.co_code
    AND scrip1.SERIES = scrip2.SERIES
           and TRADEQTY <> '0'
and  s.party_code = client2.party_code  and s.billflag='2' or s.billflag='3'
GROUP BY   s.party_code,  s.billno,  s.scrip_cd,  s.series, scrip1.short_name,
substring(convert(VARchar,sauda_date,109),1,11),  s.sell_buy,  s.markettype,
n_netrate,client2.SERVICE_CHRG,  s.SETT_NO,  s.SETT_TYPE,TMARK,client2.albmdelchrg,Rate,s.billflag
/*ORDER BY scrip1.short_name,SELL_BUY*/
/*ORDER BY settlementflag, s.scrip_cd,SELL_BUY*/
ORDER BY   s.scrip_cd,s. billflag

GO
