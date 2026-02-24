-- Object: PROCEDURE dbo.SpSettBillSection
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpSettBillSection    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.SpSettBillSection    Script Date: 3/21/01 12:50:31 PM ******/

/****** Object:  Stored Procedure dbo.SpSettBillSection    Script Date: 20-Mar-01 11:39:10 PM ******/
CREATE proc SpSettBillSection (@Sett_No varchar(10), @Sett_Type varchar(2), @Party varchar(10)) as
SELECT settlement.party_code, settlement.billno,settlement.contractno, settlement.order_no ,tm=convert(char,sauda_date,8),
 settlement.trade_no, settlement.sauda_date,settlement.scrip_cd,settlement.series,
 scripname=scrip1.short_name,sdt=substring(convert(VARchar,sauda_date,109),1,11),
 settlement.sell_buy,settlement.markettype,
 service_tax = isnull(settlement.service_tax,0),
 NSertax ,  N_NetRate,
 pqty=isnull((case sell_buy
  when 1 then settlement.tradeqty end),0),
 sqty=isnull((case sell_buy
  when 2 then settlement.tradeqty end),0),
 prate=isnull((case sell_buy
  when 1 then settlement.marketrate end),0),
 srate=isnull((case sell_buy
  when 2 then settlement.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then settlement.brokapplied end),0),
 sbrok=isnull((case sell_buy
  when 2 then settlement.brokapplied end),0),
 pnetrate=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			settlement.marketrate + settlement.brokapplied + (nsertax/tradeqty)
		else
			settlement.marketrate + settlement.brokapplied 
		end ) 
	end),0),
 snetrate=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			settlement.marketrate - settlement.brokapplied - (nsertax/tradeqty)
		else
			settlement.marketrate - settlement.brokapplied 
		end ) 
	end),0),
 pamt=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			(settlement.marketrate + settlement.brokapplied) * tradeqty + nsertax
		else
			(settlement.marketrate + settlement.brokapplied) * tradeqty
		end ) 
	end),0),
 samt=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			(settlement.marketrate - settlement.brokapplied) * tradeqty - nsertax
		else
			(settlement.marketrate - settlement.brokapplied) * tradeqty
		end ) 
	 end),0),
 Brokerage=isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,
 NewBrokerage =isnull(tradeqty*convert(numeric(9,2),nbrokapp),0) ,
settlementflag =(CASE WHEN   settlement.TMark = '$'  and sell_buy =1 THEN 'PB'  
		ELSE		
			(CASE WHEN   settlement.TMark = '$'  and sell_buy =2 THEN 'PL'  
			ELSE
				(CASE when  settlement.sett_type = 'L' Or  settlement.sett_type = 'P' Then
					(CASE When Sell_Buy = 1 then 'PC' 
					else 'SC'	
					end )
				else
					 (CASE WHEN  settlement.billflag =1 or  settlement.tmark ='D' THEN  'DEL'  
			 	                    ELSE 
					          (CASE WHEN   settlement.billflag =4  THEN  'DEL'  
					            ELSE
						(CASE WHEN   settlement.billflag =5  THEN  'DEL'  
 						  ELSE
							(CASE WHEN  settlement.billflag =2  THEN  'PC' 
							Else
								(CASE WHEN  settlement.billflag =3  THEN  'SC' 
								End )
							  END) 
						END) 
					          END) 
				                END) 
			                 END )
		          End)
		end)
from settlement,scrip1,scrip2,client2
where settlement.scrip_cd=scrip2.scrip_cd
 and settlement.series=scrip2.series
 and scrip2.co_code=scrip1.co_code
 and scrip2.series=scrip1.series
          and settlement.sett_no = @sett_no
        and settlement.sett_type = @sett_type
 and settlement.Party_Code like LTRIM(RTRIM(@Party))
 AND SETTLEMENT.BILLNO <> '0' 
 AND SETTLEMENT.TRADEQTY <> '0'
and client2.party_code = settlement.party_code
order by scrip1.short_name

GO
