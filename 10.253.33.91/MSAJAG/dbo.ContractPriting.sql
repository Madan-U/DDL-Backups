-- Object: PROCEDURE dbo.ContractPriting
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/* This is new Procedure not used any where 
 exec ContractPriting 'apr  1 2002','N','a01001','br0001','All',''
sp_helptext ContractPriting
*/
CREATE proc ContractPriting (
@Sdate varchar(12), 
@Sett_Type varchar(2), 
@FrmPrty varchar(10),
@ToPrty  varchar(10),
@Branch varchar(10),
@SubBr  varchar(10))
as 
Declare 
@@Getstyle As Cursor,
@@Sett_no As Varchar(12)

Select @Sdate = Ltrim(Rtrim(@Sdate))
If Len(@Sdate) = 10 
Begin
          Select @Sdate = STUFF(@Sdate, 4, 1,'  ')
End

Set @@Getstyle = Cursor for 
        Select Sett_no from sett_mst where Sett_type = @Sett_type and Start_Date < @Sdate + ' 00:01:01' and End_date > @Sdate + ' 00:01:01' 
        Open @@Getstyle
  Fetch next from @@Getstyle into @@sett_no
Close @@Getstyle
if @branch = 'ALL' 
Begin 
----------------------------------------------------------------------------------------------------
	/* This all Are Normal Trades without Branch wise selection*/
----------------------------------------------------------------------------------------------------	/* This is header Part */
	select Partyname = client1.long_name, s.billno,  
	   client1.l_address1, client1.l_address2, client1.l_address3, client1.l_city, client1.l_zip,
	   client1.email, pan_gir_no=client1.pan_gir_no, client1.Res_Phone1,client1.Off_Phone1
	/* Detail sections */
	  ,s.contractNo, s.party_code, s.order_no , tm=convert(char,s.sauda_date,108),
	  s.trade_no, s.sauda_date, s.scrip_cd, scripname=scrip1.short_name, sdt=convert(char,s.sauda_date,103),
	  s.sell_buy, s.markettype, broker_chrg=isnull(s.broker_chrg,0),
	  service_tax=   0 
	  ,pqty=isnull((case s.sell_buy
	  when 1 then s.tradeqty end),0),
	  sqty=isnull((case s.sell_buy
	  when 2 then s.tradeqty end),0),
	  prate=isnull((case s.sell_buy
	   when 1 then s.Marketrate end),0),
	  srate=isnull((case s.sell_buy
	  when 2 then s.Marketrate end),0),
	  pbrok=isnull((case s.sell_buy
	  when 1 then  ( case when service_chrg = 1 then  
				s.NBrokApp   /*  + (nsertax/tradeqty)   */
			else 
				s.NBrokApp 
			end)
		end),0),
	  sbrok=isnull((case s.sell_buy
	   when 2 then  ( case when service_chrg = 1 then  
				s.NBrokApp    /*   - (nsertax/tradeqty)  */
			else 
				s.NBrokApp 
			end)
		end),0),
	pnetrate=isnull((case s.sell_buy
		  when 1 then ( case when service_chrg = 1 then 
				s.N_NetRate /* + s.NBrokApp     + (nsertax/tradeqty) */
			else
				s.N_NetRate
			end ) 
		end),0),
	 snetrate=isnull((case s.sell_buy
	  when 2 then ( case when service_chrg = 1 then 
				s.N_NetRate /* - s.NBrokApp      - (nsertax/tradeqty)  */
			else
				s.N_NetRate
			end ) 
		end),0),
	 pamt=isnull((case s.sell_buy
	  when 1 then ( case when service_chrg = 1 then 
				(s.N_NetRate + s.NBrokApp) * s.tradeqty   /*  + nsertax  */
			else
				(s.N_NetRate ) * s.tradeqty
			end ) 
		end),0),
	 samt=isnull((case s.sell_buy
	  when 2 then ( case when service_chrg = 1 then 
				(s.N_NetRate ) * s.tradeqty    /*    - nsertax   */
			else
				(s.N_NetRate) * s.tradeqty
			end ) 
		 end),0)
	/* This is Footer section columns */
	,NetBQty = ( select isnull(sum(tradeQty),0) 
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 1
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,NetSQty = ( select isnull(sum(tradeQty),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,NetBAmount = ( select isnull(sum(Amount),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 1
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,NetSAmount = ( select isnull(sum(Amount),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,BBrokerage = ( select isnull( sum(tradeqty*brokapplied),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 1
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,SBrokerage = ( select isnull( sum(tradeqty*brokapplied),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,BSerTax = ( select isnull(sum(service_tax),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,SSerTax = ( select isnull(sum(service_tax),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,s.sett_type , s.sett_no
	from client1 ,client2 , settlement s , scrip1 , scrip2 
	where client1.cl_code = client2.cl_code 
	and s.party_code = client2.party_code
	and s.series=scrip2.series
	and s.scrip_cd = scrip2.scrip_cd
	and scrip2.series=scrip1.series
	and scrip1.co_code = scrip2.co_code
	and rtrim(s.sett_type) = @sett_Type
	and s.sauda_date LIKE  @sdate + '%'
	and s.tradeqty <> 0
	and s.party_code >= @frmPrty
	and s.party_code <= @toPrty
----------------------------------------------------------------------------------------------------
---Following are the No delivery trades ---------
----------------------------------------------------------------------------------------------------
union 
	select Partyname = client1.long_name, s.billno,  
	   client1.l_address1, client1.l_address2, client1.l_address3, client1.l_city, client1.l_zip,
	   client1.email, pan_gir_no=client1.pan_gir_no, client1.Res_Phone1,client1.Off_Phone1
	/* Detail sections */
	  ,s.contractNo, s.party_code, s.order_no , tm=convert(char,s.sauda_date,108),
	  s.trade_no, s.sauda_date, s.scrip_cd, scripname=scrip1.short_name, sdt=convert(char,s.sauda_date,103),
	  s.sell_buy, s.markettype, broker_chrg=isnull(s.broker_chrg,0),
	  service_tax=   0 
	  ,pqty=isnull((case s.sell_buy
	  when 1 then s.tradeqty end),0),
	  sqty=isnull((case s.sell_buy
	  when 2 then s.tradeqty end),0),
	  prate=isnull((case s.sell_buy
	   when 1 then s.Marketrate end),0),
	  srate=isnull((case s.sell_buy
	  when 2 then s.Marketrate end),0),
	  pbrok=isnull((case s.sell_buy
	  when 1 then  ( case when service_chrg = 1 then  
				s.NBrokApp   /*  + (nsertax/tradeqty)   */
			else 
				s.NBrokApp 
			end)
		end),0),
	  sbrok=isnull((case s.sell_buy
	   when 2 then  ( case when service_chrg = 1 then  
				s.NBrokApp    /*   - (nsertax/tradeqty)  */
			else 
				s.NBrokApp 
			end)
		end),0),
	pnetrate=isnull((case s.sell_buy
		  when 1 then ( case when service_chrg = 1 then 
				s.N_NetRate /* + s.NBrokApp     + (nsertax/tradeqty) */
			else
				s.N_NetRate
			end ) 
		end),0),
	 snetrate=isnull((case s.sell_buy
	  when 2 then ( case when service_chrg = 1 then 
				s.N_NetRate /* - s.NBrokApp      - (nsertax/tradeqty)  */
			else
				s.N_NetRate
			end ) 
		end),0),
	 pamt=isnull((case s.sell_buy
	  when 1 then ( case when service_chrg = 1 then 
				(s.N_NetRate + s.NBrokApp) * s.tradeqty   /*  + nsertax  */
			else
				(s.N_NetRate ) * s.tradeqty
			end ) 
		end),0),
	 samt=isnull((case s.sell_buy
	  when 2 then ( case when service_chrg = 1 then 
				(s.N_NetRate ) * s.tradeqty    /*    - nsertax   */
			else
				(s.N_NetRate) * s.tradeqty
			end ) 
		 end),0)
	/* This is Footer section columns */
	,NetBQty = ( select isnull(sum(tradeQty),0) 
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 1
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,NetSQty = ( select isnull(sum(tradeQty),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,NetBAmount = ( select isnull(sum(Amount),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 1
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,NetSAmount = ( select isnull(sum(Amount),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,BBrokerage = ( select isnull( sum(tradeqty*brokapplied),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 1
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,SBrokerage = ( select isnull( sum(tradeqty*brokapplied),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,BSerTax = ( select isnull(sum(service_tax),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,SSerTax = ( select isnull(sum(service_tax),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,s.sett_type , s.sett_no
	from client1 ,client2 , settlement s , scrip1 , scrip2 
	where client1.cl_code = client2.cl_code 
	and s.party_code = client2.party_code
	and s.series=scrip2.series
	and s.scrip_cd = scrip2.scrip_cd
	and scrip2.series=scrip1.series
	and scrip1.co_code = scrip2.co_code
	and rtrim(s.sett_type) = @sett_Type
	and s.sauda_date LIKE  @sdate + '%'
	and s.tradeqty <> 0
	and s.party_code >= @frmPrty
	and s.party_code <= @toPrty
	and s.sett_no = @@sett_no
	order by s.sett_no, s.sett_type, scrip1.short_name
end 
else
Begin
----------------------------------------------------------------------------------------------------
	/* This all Are Normal Trades For Branch wise selection*/
----------------------------------------------------------------------------------------------------
	/* This is header Part */
	select Partyname = client1.long_name, s.billno,  
	   client1.l_address1, client1.l_address2, client1.l_address3, client1.l_city, client1.l_zip,
	   client1.email, pan_gir_no=client1.pan_gir_no, client1.Res_Phone1,client1.Off_Phone1
	/* Detail sections */
	  ,s.contractNo, s.party_code, s.order_no , tm=convert(char,s.sauda_date,108),
	  s.trade_no, s.sauda_date, s.scrip_cd, scripname=scrip1.short_name, sdt=convert(char,s.sauda_date,103),
	  s.sell_buy, s.markettype, broker_chrg=isnull(s.broker_chrg,0),
	  service_tax=   0 
	  ,pqty=isnull((case s.sell_buy
	  when 1 then s.tradeqty end),0),
	  sqty=isnull((case s.sell_buy
	  when 2 then s.tradeqty end),0),
	  prate=isnull((case s.sell_buy
	   when 1 then s.Marketrate end),0),
	  srate=isnull((case s.sell_buy
	  when 2 then s.Marketrate end),0),
	  pbrok=isnull((case s.sell_buy
	  when 1 then  ( case when service_chrg = 1 then  
				s.NBrokApp   /*  + (nsertax/tradeqty)   */
			else 
				s.NBrokApp 
			end)
		end),0),
	  sbrok=isnull((case s.sell_buy
	   when 2 then  ( case when service_chrg = 1 then  
				s.NBrokApp    /*   - (nsertax/tradeqty)  */
			else 
				s.NBrokApp 
			end)
		end),0),
	pnetrate=isnull((case s.sell_buy
		  when 1 then ( case when service_chrg = 1 then 
				s.N_NetRate /* + s.NBrokApp     + (nsertax/tradeqty) */
			else
				s.N_NetRate
			end ) 
		end),0),
	 snetrate=isnull((case s.sell_buy
	  when 2 then ( case when service_chrg = 1 then 
				s.N_NetRate /* - s.NBrokApp      - (nsertax/tradeqty)  */
			else
				s.N_NetRate
			end ) 
		end),0),
	 pamt=isnull((case s.sell_buy
	  when 1 then ( case when service_chrg = 1 then 
				(s.N_NetRate + s.NBrokApp) * s.tradeqty   /*  + nsertax  */
			else
				(s.N_NetRate ) * s.tradeqty
			end ) 
		end),0),
	 samt=isnull((case s.sell_buy
	  when 2 then ( case when service_chrg = 1 then 
				(s.N_NetRate ) * s.tradeqty    /*    - nsertax   */
			else
				(s.N_NetRate) * s.tradeqty
			end ) 
		 end),0)

	/* This is Footer section columns */
	,NetBQty = ( select isnull(sum(tradeQty),0) 
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 1
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,NetSQty = ( select isnull(sum(tradeQty),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,NetBAmount = ( select isnull(sum(Amount),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 1
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,NetSAmount = ( select isnull(sum(Amount),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,BBrokerage = ( select isnull( sum(tradeqty*brokapplied),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 1
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,SBrokerage = ( select isnull( sum(tradeqty*brokapplied),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,BSerTax = ( select isnull(sum(service_tax),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,SSerTax = ( select isnull(sum(service_tax),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,s.sett_type , s.sett_no
	from client1 ,client2 , settlement s , scrip1 , scrip2 
	where client1.cl_code = client2.cl_code 
	and s.party_code = client2.party_code
	and s.series=scrip2.series
	and s.scrip_cd = scrip2.scrip_cd
	and scrip2.series=scrip1.series
	and scrip1.co_code = scrip2.co_code
	and rtrim(s.sett_type) = @sett_Type
	and s.sauda_date LIKE  @sdate + '%'
	and s.tradeqty <> 0
	and client1.Branch_Cd = @Branch
	and Client1.Sub_Broker = @SubBr
	and s.party_code >= @frmPrty
	and s.party_code <= @toPrty
----------------------------------------------------------------------------------------------------
---Following are the No delivery trades ---------
----------------------------------------------------------------------------------------------------
union 
	select Partyname = client1.long_name, s.billno,  
	   client1.l_address1, client1.l_address2, client1.l_address3, client1.l_city, client1.l_zip,
	   client1.email, pan_gir_no=client1.pan_gir_no, client1.Res_Phone1,client1.Off_Phone1
	/* Detail sections */
	  ,s.contractNo, s.party_code, s.order_no , tm=convert(char,s.sauda_date,108),
	  s.trade_no, s.sauda_date, s.scrip_cd, scripname=scrip1.short_name, sdt=convert(char,s.sauda_date,103),
	  s.sell_buy, s.markettype, broker_chrg=isnull(s.broker_chrg,0),
	  service_tax=   0 
	  ,pqty=isnull((case s.sell_buy
	  when 1 then s.tradeqty end),0),
	  sqty=isnull((case s.sell_buy
	  when 2 then s.tradeqty end),0),
	  prate=isnull((case s.sell_buy
	   when 1 then s.Marketrate end),0),
	  srate=isnull((case s.sell_buy
	  when 2 then s.Marketrate end),0),
	  pbrok=isnull((case s.sell_buy
	  when 1 then  ( case when service_chrg = 1 then  
				s.NBrokApp   /*  + (nsertax/tradeqty)   */
			else 
				s.NBrokApp 
			end)
		end),0),
	  sbrok=isnull((case s.sell_buy
	   when 2 then  ( case when service_chrg = 1 then  
				s.NBrokApp    /*   - (nsertax/tradeqty)  */
			else 
				s.NBrokApp 
			end)
		end),0),
	pnetrate=isnull((case s.sell_buy
		  when 1 then ( case when service_chrg = 1 then 
				s.N_NetRate /* + s.NBrokApp     + (nsertax/tradeqty) */
			else
				s.N_NetRate
			end ) 
		end),0),
	 snetrate=isnull((case s.sell_buy
	  when 2 then ( case when service_chrg = 1 then 
				s.N_NetRate /* - s.NBrokApp      - (nsertax/tradeqty)  */
			else
				s.N_NetRate
			end ) 
		end),0),
	 pamt=isnull((case s.sell_buy
	  when 1 then ( case when service_chrg = 1 then 
				(s.N_NetRate + s.NBrokApp) * s.tradeqty   /*  + nsertax  */
			else
				(s.N_NetRate ) * s.tradeqty
			end ) 
		end),0),
	 samt=isnull((case s.sell_buy
	  when 2 then ( case when service_chrg = 1 then 
				(s.N_NetRate ) * s.tradeqty    /*    - nsertax   */
			else
				(s.N_NetRate) * s.tradeqty
			end ) 
		 end),0)

	/* This is Footer section columns */
	,NetBQty = ( select isnull(sum(tradeQty),0) 
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 1
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,NetSQty = ( select isnull(sum(tradeQty),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,NetBAmount = ( select isnull(sum(Amount),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 1
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,NetSAmount = ( select isnull(sum(Amount),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,BBrokerage = ( select isnull( sum(tradeqty*brokapplied),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 1
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,SBrokerage = ( select isnull( sum(tradeqty*brokapplied),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,BSerTax = ( select isnull(sum(service_tax),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,SSerTax = ( select isnull(sum(service_tax),0)
		from settlement where tradeQty <>0 and sett_type = @Sett_type 
		and sauda_date like @sdate + '%' and sell_buy = 2
		and party_code = s.party_code and contractNo = s.contractNo
		group By convert(varchar(11),sauda_date,109),sett_type , ContractNo 
		)
	,s.sett_type , s.sett_no
	from client1 ,client2 , settlement s , scrip1 , scrip2 
	where client1.cl_code = client2.cl_code 
	and s.party_code = client2.party_code
	and s.series=scrip2.series
	and s.scrip_cd = scrip2.scrip_cd
	and scrip2.series=scrip1.series
	and scrip1.co_code = scrip2.co_code
	and rtrim(s.sett_type) = @sett_Type
	and s.sauda_date LIKE  @sdate + '%'
	and s.tradeqty <> 0
	and client1.Branch_Cd = @Branch
	and Client1.Sub_Broker = @SubBr
	and s.party_code >= @frmPrty
	and s.sett_no = @@sett_no
	and s.party_code <= @toPrty
	order by s.sett_no, s.sett_type, scrip1.short_name
end

GO
