-- Object: PROCEDURE dbo.sp_clientmargindetails
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--exec sp_clientmargindetails 'broker','broker','0','ZZZ','Aug 8 2000','Aug 8 2007','%','%',1 

CREATE Proc sp_clientmargindetails
	(
	@statusid varchar(15),
	@statusname varchar(25),
	@fromparty varchar(20),
	@toparty varchar(20),
	@fromdate varchar(11),
	@todate varchar(11),
	@branch varchar(10),
	@trader varchar(10),
	@orderby int
	)
	
	AS  
      
	if @fromparty = ''    
		begin    
		   set @fromparty = '0'    
		end     
    
	if @toparty = ''    
	      begin    
	            set @toparty = 'zzzzzzz'    
	      end       

    	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
	Select
		Party_Code,
		Branch_cd,
		Sub_Broker,
		Trader
	INTO 
		#ClientList
	From
		Client1 (NoLock), 
		Client2 (NoLock)
	Where
		Client1.Cl_Code = Client2.Cl_Code  
		AND party_code >= @fromparty        
		AND party_code <= @toparty        
		AND branch_cd like @branch      
		AND trader like @trader      
		AND @STATUSNAME =   
		(CASE   
			WHEN @STATUSID = 'BRANCH' THEN BRANCH_CD  
			WHEN @STATUSID = 'SUBBROKER' THEN SUB_BROKER  
			WHEN @STATUSID = 'TRADER' THEN TRADER  
			WHEN @STATUSID = 'FAMILY' THEN FAMILY  
			WHEN @STATUSID = 'AREA' THEN AREA  
			WHEN @STATUSID = 'REGION' THEN REGION  
			WHEN @STATUSID = 'CLIENT' THEN PARTY_CODE  
			ELSE
			'BROKER'
		END)
  
  
	SELECT
		(CASE WHEN @orderby = 1 
			THEN FO.PARTY_CODE
			ELSE CONVERT(VARCHAR,MARGINDATE,112)
			END),
		(CASE WHEN @orderby = 1 
			THEN CONVERT(VARCHAR,MARGINDATE,112)
			ELSE FO.PARTY_CODE
			END),
		FO.PARTY_CODE,
		margindate = left(convert(varchar,margindate,109),11),
		Billdate = left(Convert(Varchar,margindate,103),11),
		C.branch_cd,
		C.sub_broker,
		C.trader,
		FO.short_name,
		billamount = isnull(billamount,0),
		ledgeramount = isnull(ledgeramount,0),        
		cash_coll = isnull(cash_coll,0),
		noncash_coll=isnull(noncash_coll,0),
		initialmargin = isnull(initialmargin,0), 
		MTMMargin = IsNull(MTMMargin,0),
		RMSExcessAmount, 
		ShortFallMarginAdjustedNSE, 
		ShortFallMarginAdjustedBSE, 
		ShortFallMarginAdjustedPOA,
		year(margindate),
		month(margindate),
		day(margindate)
	From  
		--NSEFO.DBO.TBL_ClientMargin fo (NOLOCK)
		FoClientMarginReliable FO (NOLOCK),
		#ClientList C (NOLOCK)
	Where  
		FO.Party_code = C.Party_code
		And margindate >= @fromdate        
		And margindate <= @todate + ' 23:59:00'        
	   
	Order By
		1,
		2

GO
