-- Object: PROCEDURE dbo.SpWAllBillSecKarvy
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc  SpWAllBillSecKarvy (@Sett_No varchar(10),@Sett_Type Varchar(2), @Party_code varchar(10)) as
SELECT s.party_code, s.billno,s.scrip_cd,s.series, scripname=s1.short_name,
sdt=substring(convert(VARchar,sauda_date,109),1,11), s.sell_buy,s.markettype,
  pqty=isnull((case sell_buy  when 1 then SUM(s.tradeqty) end),0),
 sqty=isnull((case sell_buy  when 2 then SUM(s.tradeqty) end),0),
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
NewFixmargin = 0,
NewAddMar = 0,
OldFixMargin = 0,
OldAddMar = 0,
settlementflag =(CASE WHEN  s.billflag =1 or  s.tmark ='D' THEN  'D'  
           		ELSE 
				(CASE WHEN   s.billflag =4  THEN  'D'  
					ELSE
						(CASE WHEN   s.billflag =5  THEN  'D'  else  ' '
 						 END) 
					END) 
			END)
from  settlement s,scrip1 s1 ,scrip2 s2 ,client2 c2
where  s.scrip_cd=s2.scrip_cd
 and  s.series=s2.series
 and s2.co_code=s1.co_code
 and s2.series=s1.series
          and  s.sett_no = @sett_no
        and  s.sett_type = @Sett_Type
 and  s.Party_Code=@party_Code
 AND  s.BILLNO <> '0' 
 AND  s.TRADEQTY <> '0'
and c2.party_code =  s.party_code
GROUP BY   s.party_code,  s.billno, s.scrip_cd, s.series, s1.short_name,
substring(convert(VARchar,sauda_date,109),1,11),  s.sell_buy, s.markettype,
n_netrate,c2.SERVICE_CHRG,s.tmark,s.sett_type,s.billflag
union all 
/* spalbmplusbillsectionp*/
SELECT s.party_code,s.billno,s.scrip_cd,s.series,scripname=s1.short_name , /*,scripname='*'+s1.short_name */
sdt=substring(convert(VARchar,sauda_date,109),1,11),
 s.sell_buy,s.markettype,
pqty=isnull((case sell_buy
  when 1 then sum(tradeqty) end),0),
 sqty=isnull((case sell_buy
  when 2 then sum(tradeqty) end),0),
 
 pnetrate=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
   sum(( s.marketrate  +  s.Nbrokapp+(nsertax/tradeqty)) *tradeqty)/sum(tradeqty)
		else
		sum(( s.marketrate  +  s.Nbrokapp) *tradeqty)/sum(tradeqty)
  end ) 
 end),0),
 snetrate=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
  sum(( s.marketrate -  s.Nbrokapp-(nsertax/tradeqty)) *tradeqty)/sum(tradeqty)
		else
		sum(( s.marketrate -  s.Nbrokapp) *tradeqty)/sum(tradeqty)
  end ) 
 end),0),
 pamt=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
   sum((s.marketrate + s.Nbrokapp) * tradeqty + nsertax)
  else
   sum((s.marketrate + s.Nbrokapp) * tradeqty)
  end ) 
 end),0),
 samt=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
   sum((s.marketrate - s.Nbrokapp) * tradeqty - nsertax)
  else
   sum((s.marketrate - s.Nbrokapp) * tradeqty)
  end ) 
  end),0),
newfIXMARGIN = ( case when (c2.albmdelchrg = 0 or albmdelchrg = 2 ) then (Case when TMARK <> '$' then ISNULL(( SELECT fixmargin FROM MARGIN1 WHERE SETT_NO=S.SETT_NO AND SETT_TYPE = S.SETT_TYPE ),0)  * sum(TRADEQTY*MARKETRATE)/100 else 0 end ) else 0 end) , 
newADDMAR =  ( case when (c2.albmdelchrg = 0 or albmdelchrg = 2 ) then ISNULL((Case when TMARK <> '$' then ISNULL(( SELECT AddMargin FROM MARGIN2 WHERE SETT_TYPE = S.SETT_TYPE AND SCRIP_CD = S.SCRIP_CD  and sett_no = S.sett_no ),0)*sum(TRADEQTY*MARKETRATE)/100 else 0 end ),0) else 0 end ),
oldfixmargin=0,
oldaddmar=0,
settlementflag ='*'
from settlement  s, scrip1 s1 ,scrip2 s2, client2 c2
           where S.sett_type = 'P'
       and s.Party_code =@Party_code
                   and s.scrip_cd = s2.scrip_cd
                   and s.series = s2.series
                   and s1.co_code = s2.co_Code
    and s1.series = s2.series
           and TRADEQTY <> '0'
 and s.sett_no = ( select min(sett_no) from sett_mst where sett_no >@sett_no and sett_Type = 'W' )
and s.party_code = c2.party_code
GROUP BY  s.party_code, s.billno,s.scrip_cd,s.series, s1.short_name,
substring(convert(VARchar,sauda_date,109),1,11), s.sell_buy,s.markettype,
n_netrate,c2.SERVICE_CHRG,SETT_NO,SETT_TYPE,TMARK,c2.albmdelchrg
union all
SELECT s.party_code, s.billno,s.scrip_cd,s.series, scripname=s1.short_name,
sdt=substring(convert(VARchar,sauda_date,109),1,11), s.sell_buy,s.markettype,
  pqty=isnull((case sell_buy  when 1 then SUM(s.tradeqty) end),0),
 sqty=isnull((case sell_buy  when 2 then SUM(s.tradeqty) end),0),
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
NewFixmargin = 0,
NewAddMar = 0,
OldFixMargin = 0,
OldAddMar = 0,
settlementflag =(CASE WHEN  s.billflag =1 or  s.tmark ='D' THEN  'D'  
           		ELSE 
				(CASE WHEN   s.billflag =4  THEN  'D'  
					ELSE
						(CASE WHEN   s.billflag =5  THEN  'D'  else ' '
 						 END) 
					END) 
			END)
from  history s,scrip1 s1 ,scrip2 s2 ,client2 c2
where  s.scrip_cd=s2.scrip_cd
 and  s.series=s2.series
 and s2.co_code=s1.co_code
 and s2.series=s1.series
          and  s.sett_no = @sett_no
        and  s.sett_type = @Sett_Type
 and  s.Party_Code=@party_Code
 AND  s.BILLNO <> '0' 
 AND  s.TRADEQTY <> '0'
and c2.party_code =  s.party_code
GROUP BY   s.party_code,  s.billno, s.scrip_cd, s.series, s1.short_name,
substring(convert(VARchar,sauda_date,109),1,11),  s.sell_buy, s.markettype,
n_netrate,c2.SERVICE_CHRG,s.tmark,s.sett_type,s.billflag
union all 
/* spalbmplusbillsectionp*/
SELECT s.party_code,s.billno,s.scrip_cd,s.series,scripname=s1.short_name ,/*,scripname='*'+s1.short_name ,*/
sdt=substring(convert(VARchar,sauda_date,109),1,11),
 s.sell_buy,s.markettype,
pqty=isnull((case sell_buy
  when 1 then sum(tradeqty) end),0),
 sqty=isnull((case sell_buy
  when 2 then sum(tradeqty) end),0),
 
 pnetrate=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
   sum(( s.marketrate  +  s.Nbrokapp+(nsertax/tradeqty)) *tradeqty)/sum(tradeqty)
		else
		sum(( s.marketrate  +  s.Nbrokapp) *tradeqty)/sum(tradeqty)
  end ) 
 end),0),
 snetrate=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
  sum(( s.marketrate -  s.Nbrokapp-(nsertax/tradeqty)) *tradeqty)/sum(tradeqty)
		else
		sum(( s.marketrate -  s.Nbrokapp) *tradeqty)/sum(tradeqty)
  end ) 
 end),0),
 pamt=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
   sum((s.marketrate + s.Nbrokapp) * tradeqty + nsertax)
  else
   sum((s.marketrate + s.Nbrokapp) * tradeqty)
  end ) 
 end),0),
 samt=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
   sum((s.marketrate - s.Nbrokapp) * tradeqty - nsertax)
  else
   sum((s.marketrate - s.Nbrokapp) * tradeqty)
  end ) 
  end),0),
newfIXMARGIN = ( case when (c2.albmdelchrg = 0 or albmdelchrg = 2 ) then (Case when TMARK <> '$' then ISNULL(( SELECT fixmargin FROM MARGIN1 WHERE SETT_NO=S.SETT_NO AND SETT_TYPE = S.SETT_TYPE ),0)  * sum(TRADEQTY*MARKETRATE)/100 else 0 end ) else 0 end) , 
newADDMAR =  ( case when (c2.albmdelchrg = 0 or albmdelchrg = 2 ) then ISNULL((Case when TMARK <> '$' then ISNULL(( SELECT AddMargin FROM MARGIN2 WHERE SETT_TYPE = S.SETT_TYPE AND SCRIP_CD = S.SCRIP_CD  and sett_no = S.sett_no ),0)*sum(TRADEQTY*MARKETRATE)/100 else 0 end ),0) else 0 end ),
oldfixmargin=0,
oldaddmar=0,
settlementflag ='*'
from History s, scrip1 s1 ,scrip2 s2, client2 c2
           where S.sett_type = 'P'
       and s.Party_code =@Party_code
                   and s.scrip_cd = s2.scrip_cd
                   and s.series = s2.series
                   and s1.co_code = s2.co_Code
    and s1.series = s2.series
           and TRADEQTY <> '0'
 and s.sett_no = ( select min(sett_no) from sett_mst where sett_no >@sett_no and sett_Type = 'W' )
and s.party_code = c2.party_code
GROUP BY  s.party_code, s.billno,s.scrip_cd,s.series, s1.short_name,
substring(convert(VARchar,sauda_date,109),1,11), s.sell_buy,s.markettype,
n_netrate,c2.SERVICE_CHRG,SETT_NO,SETT_TYPE,TMARK,c2.albmdelchrg
union all
/*spalbmoppbillsctionp*/
SELECT s.party_code, billno,s.scrip_cd,s.series,scripname=s1.short_name, /*,scripname='~'+s1.short_name,*/
sdt=substring(convert(VARchar,sauda_date,109),1,11),sell_buy,markettype,
 pqty=isnull((case sell_buy
  when 2 then sum(tradeqty) end),0),
 sqty=isnull((case sell_buy
  when 1 then sum(tradeqty) end),0),
pnetrate=isnull((case sell_buy
  when 2 then Rate end),0),
 snetrate=isnull((case sell_buy
  when 1 then Rate end),0),
 pamt=isnull((case sell_buy
  when 2 then sum(Rate*TradeQty) end),0),
 samt=isnull((case sell_buy
  when 1 then sum(Rate*TradeQty) end),0),
newfixmargin=0,
newaddmar=0,
oldfIXMARGIN = ( case when (c2.albmdelchrg = 0 or albmdelchrg = 2 ) then (Case when TMARK <> '$' then ISNULL(( SELECT fixmargin FROM MARGIN1 WHERE SETT_NO=S.SETT_NO AND SETT_TYPE = S.SETT_TYPE ),0)  *sum(TRADEQTY*MARKETRATE)/100 else 0 end ) else 0 end) , 
oldADDMAR =  ( case when (c2.albmdelchrg = 0 or albmdelchrg = 2 ) then ISNULL((Case when TMARK <> '$' then ISNULL(( SELECT AddMargin FROM MARGIN2 WHERE SETT_TYPE = S.SETT_TYPE AND SCRIP_CD = S.SCRIP_CD  and sett_no = S.sett_no ),0)* sum(TRADEQTY*MARKETRATE)/100 else 0 end ),0) else 0 end ),
settlementflag ='~'
from albmtradesett s,scrip1 s1, scrip2 s2, client2 c2
           where S.sett_type = 'P'
       and s.Party_code = @Party_code
                   and s.scrip_cd = s2.scrip_cd
                   and s.series = s2.series
                   and s1.co_code = s2.co_Code
    and s1.series = s2.series
           and TRADEQTY <> '0'
 and s.sett_no = @sett_no
and s.party_code = c2.party_code
GROUP BY  s.party_code, s.billno,s.scrip_cd,s.series, s1.short_name,
substring(convert(VARchar,sauda_date,109),1,11), s.sell_buy,s.markettype,
n_netrate,c2.SERVICE_CHRG,s.SETT_NO,s.SETT_TYPE,TMARK,c2.albmdelchrg,Rate
order by settlementflag,s.scrip_cd,SELL_BUY

GO
