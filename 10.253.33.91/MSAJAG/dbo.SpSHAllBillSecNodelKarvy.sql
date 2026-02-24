-- Object: PROCEDURE dbo.SpSHAllBillSecNodelKarvy
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc SpSHAllBillSecNodelKarvy (@Sett_No varchar(10),@Sett_Type Varchar(2), @Party_code varchar(10)) as

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
settlementflag =		
			
				
		(CASE WHEN  s.billflag =1 or  s.tmark ='D' THEN  'D'  
           		ELSE 
				(CASE WHEN   s.billflag =4  THEN  'D'  
					ELSE
						(CASE WHEN   s.billflag =5  THEN  'D'   else  ' '
 						 END) 
					END) 
			END) 
from settlement s,scrip1,scrip2,client2,Sett_mst S1 
where s.Sauda_date between S1.start_date and S1.End_date 
 and s.Sett_type = S1.Sett_Type and s.series = S1.Series and s.Sett_no<>S1.Sett_no and 
 s.scrip_cd=scrip2.scrip_cd 

 and  s.series=scrip2.series
 and scrip2.co_code=scrip1.co_code
 and scrip2.series=scrip1.series
          and  s1.sett_no = @Sett_No
        and  s.sett_type =  @Sett_Type
 and  s.Party_Code= @party_code

 AND  s.TRADEQTY <> '0'
and client2.party_code =  s.party_code
GROUP BY   s.party_code,  s.billno, s.scrip_cd, s.series, scrip1.short_name,
substring(convert(VARchar,sauda_date,109),1,11),  s.sell_buy, s.markettype,
n_netrate,CLIENT2.SERVICE_CHRG,s.tmark,s.sett_type,s.billflag
union all
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
settlementflag =		
			
				
		(CASE WHEN  s.billflag =1 or  s.tmark ='D' THEN  'D'  
           		ELSE 
				(CASE WHEN   s.billflag =4  THEN  'D'  
					ELSE
						(CASE WHEN   s.billflag =5  THEN  'D'   else  ' '
 						 END) 
					END) 
			END) 
from history s,scrip1,scrip2,client2,Sett_mst S1 
where s.Sauda_date between S1.start_date and S1.End_date 
 and s.Sett_type = S1.Sett_Type and s.series = S1.Series and s.Sett_no<>S1.Sett_no and 
 s.scrip_cd=scrip2.scrip_cd 

 and  s.series=scrip2.series
 and scrip2.co_code=scrip1.co_code
 and scrip2.series=scrip1.series
          and  s1.sett_no = @Sett_No
        and  s.sett_type =  @Sett_Type
 and  s.Party_Code=@party_code

 AND  s.TRADEQTY <> '0'
and client2.party_code =  s.party_code
GROUP BY   s.party_code,  s.billno, s.scrip_cd, s.series, scrip1.short_name,
substring(convert(VARchar,sauda_date,109),1,11),  s.sell_buy, s.markettype,
n_netrate,CLIENT2.SERVICE_CHRG,s.tmark,s.sett_type,s.billflag
order by  settlementflag, s.scrip_cd,SELL_BUY

GO
