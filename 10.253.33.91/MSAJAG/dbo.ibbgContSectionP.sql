-- Object: PROCEDURE dbo.ibbgContSectionP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc ibbgContSectionP (@Sdate varchar(12), @Sett_Type varchar(2), @ContNo varchar(6),@flag smallint,@Sett_no Varchar(10),@Party_code Varchar(12))
  as 
if @flag = 1
begin
 SELECT  isettlement.contractNo,isettlement.party_code,isettlement.order_no ,tm=convert(char,sauda_date,108),
  isettlement.trade_no, isettlement.sauda_date,isettlement.scrip_cd,scripname=scrip1.short_name,sdt=convert(char,sauda_date,103),
  isettlement.sell_buy,isettlement.markettype,broker_chrg=isnull(isettlement.broker_chrg,0),
 service_tax=( case when service_chrg = 1 then  
			0
		else
			isnull(isettlement.service_tax,0)
		end),
 pqty=isnull((case sell_buy
  when 1 then isettlement.tradeqty end),0),
  sqty=isnull((case sell_buy
  when 2 then isettlement.tradeqty end),0),
  prate=isnull((case sell_buy
   when 1 then isettlement.marketrate end),0),
  srate=isnull((case sell_buy
  when 2 then isettlement.marketrate end),0),
  pbrok=isnull((case sell_buy
  when 1 then  ( case when service_chrg = 1 then  
			isettlement.brokapplied + (nsertax/tradeqty) 
		else 
			isettlement.brokapplied 
		end)
	end),0),
  sbrok=isnull((case sell_buy
   when 2 then  ( case when service_chrg = 1 then  
			isettlement.brokapplied - (nsertax/tradeqty) 
		else 
			isettlement.brokapplied 
		end)
	end),0),
pnetrate=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			isettlement.marketrate + isettlement.brokapplied + (nsertax/tradeqty)
		else
			isettlement.marketrate + isettlement.brokapplied 
		end ) 
	end),0),
 snetrate=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			isettlement.marketrate - isettlement.brokapplied - (nsertax/tradeqty)
		else
			isettlement.marketrate - isettlement.brokapplied 
		end ) 
	end),0),
 pamt=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			(isettlement.marketrate + isettlement.brokapplied) * tradeqty + nsertax
		else
			(isettlement.marketrate + isettlement.brokapplied) * tradeqty
		end ) 
	end),0),
 samt=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			(isettlement.marketrate - isettlement.brokapplied) * tradeqty - nsertax
		else
			(isettlement.marketrate - isettlement.brokapplied) * tradeqty
		end ) 
	 end),0),
  Brokerage=isnull((tradeqty*brokapplied),0), isettlement.sett_no
  from isettlement,scrip1,scrip2, client2 
  where isettlement.scrip_cd=scrip2.scrip_cd
  and isettlement.series=scrip2.series
  and scrip2.co_code=scrip1.co_code
  and scrip2.series=scrip1.series
 and rtrim(isettlement.sett_type) = @sett_Type
  and isettlement.sauda_date LIKE  @sdate + '%'
  and isettlement.tradeqty <> 0
 and convert(int,isettlement.contractno) = @ContNo 
and client2.Party_code = isettlement.party_code
and isettlement.party_code = @Party_code
and isettlement.sett_no = @Sett_no
 order by scrip1.short_name
end
else if @flag=2
begin
 SELECT  history.contractNo,history.party_code,history.order_no ,tm=convert(char,sauda_date,108),
  history.trade_no, history.sauda_date,history.scrip_cd,scripname=scrip1.short_name,sdt=convert(char,sauda_date,103),
  history.sell_buy,history.markettype,broker_chrg=isnull(history.broker_chrg,0),
  service_tax=( case when service_chrg = 1 then  
			0
		else
			isnull(history.service_tax,0)
		end),
  pqty=isnull((case sell_buy
   when 1 then history.tradeqty end),0),
  sqty=isnull((case sell_buy
   when 2 then history.tradeqty end),0),
  prate=isnull((case sell_buy
   when 1 then history.marketrate end),0),
  srate=isnull((case sell_buy
   when 2 then history.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then  ( case when service_chrg = 1 then  
			History.brokapplied + (nsertax/tradeqty) 
		else 
			History.brokapplied 
		end)
	end),0),
  sbrok=isnull((case sell_buy
   when 2 then  ( case when service_chrg = 1 then  
			History.brokapplied - (nsertax/tradeqty) 
		else 
			History.brokapplied 
		end)
	end),0),
pnetrate=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			History.marketrate + History.brokapplied + (nsertax/tradeqty)
		else
			History.marketrate + History.brokapplied 
		end ) 
	end),0),
 snetrate=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			History.marketrate - History.brokapplied - (nsertax/tradeqty)
		else
			History.marketrate - History.brokapplied 
		end ) 
	end),0),
 pamt=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			(History.marketrate + History.brokapplied) * tradeqty + nsertax
		else
			(History.marketrate + History.brokapplied) * tradeqty
		end ) 
	end),0),
 samt=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			(History.marketrate - History.brokapplied) * tradeqty - nsertax
		else
			(History.marketrate - History.brokapplied) * tradeqty
		end ) 
	 end),0),
 Brokerage=isnull((tradeqty*brokapplied),0), history.sett_no
 from history,scrip1,scrip2, Client2
 where history.scrip_cd=scrip2.scrip_cd
  and history.series=scrip2.series
 and scrip2.co_code=scrip1.co_code
 and scrip2.series=scrip1.series
 and rtrim(history.sett_type) = @sett_Type
 and history.sauda_date like  @sdate + '%'
  and history.tradeqty <> 0
  and convert(int,history.contractno) = @ContNo 
and Client2.Party_code = History.Party_code
And history.sett_no = @Sett_no
And History.party_code = @Party_code 
order by scrip1.short_name
end
else if @flag = 3
begin
 SELECT  isettlement.contractNo,isettlement.party_code,isettlement.order_no ,tm=convert(char,sauda_date,108),
 isettlement.trade_no, isettlement.sauda_date,isettlement.scrip_cd,scripname=scrip1.short_name,sdt=convert(char,sauda_date,103),
 isettlement.sell_buy,isettlement.markettype,broker_chrg=isnull(isettlement.broker_chrg,0),
 service_tax=( case when service_chrg = 1 then  
			0
		else
			isnull(isettlement.service_tax,0)
		end),
 pqty=isnull((case sell_buy
 when 1 then isettlement.tradeqty end),0),
 sqty=isnull((case sell_buy
 when 2 then isettlement.tradeqty end),0),
 prate=isnull((case sell_buy
 when 1 then isettlement.marketrate end),0),
 srate=isnull((case sell_buy
 when 2 then isettlement.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then  ( case when service_chrg = 1 then  
			isettlement.brokapplied + (nsertax/tradeqty) 
		else 
			isettlement.brokapplied 
		end)
	end),0),
  sbrok=isnull((case sell_buy
   when 2 then  ( case when service_chrg = 1 then  
			isettlement.brokapplied - (nsertax/tradeqty) 
		else 
			isettlement.brokapplied 
		end)
	end),0),
pnetrate=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			isettlement.marketrate + isettlement.brokapplied + (nsertax/tradeqty)
		else
			isettlement.marketrate + isettlement.brokapplied 
		end ) 
	end),0),
 snetrate=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			isettlement.marketrate - isettlement.brokapplied - (nsertax/tradeqty)
		else
			isettlement.marketrate - isettlement.brokapplied 
		end ) 
	end),0),
 pamt=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			(isettlement.marketrate + isettlement.brokapplied) * tradeqty + nsertax
		else
			(isettlement.marketrate + isettlement.brokapplied) * tradeqty
		end ) 
	end),0),
 samt=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			(isettlement.marketrate - isettlement.brokapplied) * tradeqty - nsertax
		else
			(isettlement.marketrate - isettlement.brokapplied) * tradeqty
		end ) 
	 end),0),
 Brokerage=isnull((tradeqty*brokapplied),0), isettlement.sett_no
 from isettlement,scrip1,scrip2, Client2
 where isettlement.scrip_cd=scrip2.scrip_cd
 and isettlement.series=scrip2.series
 and scrip2.co_code=scrip1.co_code
 and scrip2.series=scrip1.series
 and rtrim(isettlement.sett_type) = @sett_Type
 and isettlement.sauda_date LIKE  @sdate + '%'
 and isettlement.tradeqty <> 0
and isettlement.party_code = client2.party_code
 and convert(int,isettlement.contractno) = @ContNo
and isettlement.party_code = @Party_code
and isettlement.sett_no = @Sett_no
  
union all
 SELECT  history.contractNo,history.party_code,history.order_no ,tm=convert(char,sauda_date,108),
 history.trade_no, history.sauda_date,history.scrip_cd,scripname=scrip1.short_name,sdt=convert(char,sauda_date,103),
 history.sell_buy,history.markettype,broker_chrg=isnull(history.broker_chrg,0),
 service_tax=( case when service_chrg = 1 then  
			0
		else
			isnull(history.service_tax,0)
		end),
 pqty=isnull((case sell_buy
 when 1 then history.tradeqty end),0),
 sqty=isnull((case sell_buy
 when 2 then history.tradeqty end),0),
 prate=isnull((case sell_buy
 when 1 then history.marketrate end),0),
 srate=isnull((case sell_buy
 when 2 then history.marketrate end),0),
  pbrok=isnull((case sell_buy
  when 1 then  ( case when service_chrg = 1 then  
			History.brokapplied + (nsertax/tradeqty) 
		else 
			History.brokapplied 
		end)
	end),0),
  sbrok=isnull((case sell_buy
   when 2 then  ( case when service_chrg = 1 then  
			History.brokapplied - (nsertax/tradeqty) 
		else 
			History.brokapplied 
		end)
	end),0),
pnetrate=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			History.marketrate + History.brokapplied + (nsertax/tradeqty)
		else
			History.marketrate + History.brokapplied 
		end ) 
	end),0),
 snetrate=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			History.marketrate - History.brokapplied - (nsertax/tradeqty)
		else
			History.marketrate - History.brokapplied 
		end ) 
	end),0),
 pamt=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			(History.marketrate + History.brokapplied) * tradeqty + nsertax
		else
			(History.marketrate + History.brokapplied) * tradeqty
		end ) 
	end),0),
 samt=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			(History.marketrate - History.brokapplied) * tradeqty - nsertax
		else
			(History.marketrate - History.brokapplied) * tradeqty
		end ) 
	 end),0),
 Brokerage=isnull((tradeqty*brokapplied),0), history.sett_no
 from history,scrip1,scrip2, client2
 where history.scrip_cd=scrip2.scrip_cd
 and history.series=scrip2.series
 and scrip2.co_code=scrip1.co_code
 and scrip2.series=scrip1.series
 and rtrim(history.sett_type) = @sett_Type
 and history.sauda_date like  @sdate + '%'
 and history.tradeqty <> 0
 and convert(int,history.contractno) = @ContNo 
and client2.party_code = history.party_code
And history.sett_no = @Sett_no
And History.party_code = @Party_code 

 order by scrip1.short_name
end

GO
