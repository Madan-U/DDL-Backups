-- Object: PROCEDURE dbo.SpHistBillSection
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpHistBillSection    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.SpHistBillSection    Script Date: 3/21/01 12:50:31 PM ******/

/****** Object:  Stored Procedure dbo.SpHistBillSection    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.SpHistBillSection    Script Date: 2/5/01 12:06:29 PM ******/

/****** Object:  Stored Procedure dbo.SpHistBillSection    Script Date: 12/27/00 8:59:04 PM ******/

CREATE proc SpHistBillSection (@Sett_No varchar(10), @Sett_Type varchar(2), @Party varchar(10)) as
SELECT History.party_code, History.billno,History.contractno, History.order_no ,tm=convert(char,sauda_date,8),
 History.trade_no, History.sauda_date,History.scrip_cd,History.series,
 scripname=scrip1.short_name,sdt=substring(convert(VARchar,sauda_date,109),1,11),
 History.sell_buy,History.markettype,
 service_tax = isnull(History.service_tax,0),
 NSertax ,  N_NetRate,
 pqty=isnull((case sell_buy
  when 1 then History.tradeqty end),0),
 sqty=isnull((case sell_buy
  when 2 then History.tradeqty end),0),
 prate=isnull((case sell_buy
  when 1 then History.marketrate end),0),
 srate=isnull((case sell_buy
  when 2 then History.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then History.brokapplied end),0),
 sbrok=isnull((case sell_buy
  when 2 then History.brokapplied end),0),
pnetrate=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			history.marketrate + history.brokapplied + (nsertax/tradeqty)
		else
			history.marketrate + history.brokapplied 
		end ) 
	end),0),
 snetrate=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			history.marketrate - history.brokapplied - (nsertax/tradeqty)
		else
			history.marketrate - history.brokapplied 
		end ) 
	end),0),
 pamt=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			(history.marketrate + history.brokapplied) * tradeqty + nsertax
		else
			(history.marketrate + history.brokapplied) * tradeqty
		end ) 
	end),0),
 samt=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			(history.marketrate - history.brokapplied) * tradeqty - nsertax
		else
			(history.marketrate - history.brokapplied) * tradeqty
		end ) 
	 end),0),
 Brokerage=isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,
 NewBrokerage =isnull(tradeqty*convert(numeric(9,2),nbrokapp),0) ,
settlementflag =(CASE WHEN  history.TMark = '$'  and sell_buy =1 THEN 'PB'  
		ELSE		
			(CASE WHEN  history.TMark = '$'  and sell_buy =2 THEN 'PL'  
			ELSE
				(CASE when history.sett_type = 'L' Or history.sett_type = 'P' Then
					(CASE When Sell_Buy = 1 then 'PC' 
					else 'SC'	
					end )
				else
					 (CASE WHEN history.billflag =1 or history.tmark ='D' THEN  'DEL'  
			 	                    ELSE 
					          (CASE WHEN  history.billflag =4  THEN  'DEL'  
					            ELSE
						(CASE WHEN  history.billflag =5  THEN  'DEL'  
 						  ELSE
							(CASE WHEN history.billflag =2  THEN  'PC' 
							Else
								(CASE WHEN history.billflag =3  THEN  'SC' 
								End )
							  END) 
						END) 
					          END) 
				                END) 
			                 END )
		          End)
		end)
from History,scrip1,scrip2, Client2
where History.scrip_cd=scrip2.scrip_cd
 and History.series=scrip2.series
 and scrip2.co_code=scrip1.co_code
 and scrip2.series=scrip1.series
        and History.sett_no = @sett_no
        and History.sett_type = @sett_type
 and History.Party_Code like LTRIM(RTRIM(@Party))
 AND History.BILLNO <> '0' 
 AND History.TRADEQTY <> '0'
and Client2.Party_code = History.Party_Code
order by scrip1.short_name

GO
