-- Object: PROCEDURE dbo.ProcRemisierBrokerageComputation_new
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


/*

#BROKTABLE_CM
#BROKTABLE_FO
#BROKTABLE_NCDX
#BROKTABLE_MCDX
#RemisierAllParty
#RemisierSpecificParty
#RemisierBlockedParty
#PARTYLIST
#REMBROK
#FOREMBROK
#FOREMBROK_1
#NCDXREMBROK
#NCDXREMBROK_1
#MCDXREMBROK
#MCDXREMBROK_1
#ExchPartyDatewiseDetails
#ExchPartywiseDetails
#ExchangeSubBrokerPartywise
#ExchangeSubBrokSchemewise
#ExchPartyDatewiseDetailsBranch
#ExchPartywiseDetailsBranch
#ExchBranchSchemewiseBranch
*/

create PROCEDURE [dbo].[ProcRemisierBrokerageComputation_new]                      
(
	@Sett_No Varchar(7), 
	@Sett_Type Varchar(2)
)                      
AS                      
BEGIN
	--SET NOCOUNT ON                       
	DECLARE 
		@FromDate Varchar(11),                      
		@ToDate       Varchar(11),                      
		@Funds_Payin  Varchar(11),                       
		@Funds_Payout Varchar(11),                      
		@TDSPercentage  NUMERIC(10,4)

	SELECT  @FromDate  = Left(Start_Date,11),            
	 @ToDate    = Left(End_Date,11),                      
	 @Funds_Payin    = Left(Funds_Payin,11),                      
	 @Funds_Payout   = Left(Funds_Payout,11),
	 @TDSPercentage = ISNULL(TDSPercentage, 5.61)
	FROM REM_SETT_MST                       
	WHERE SETT_NO = @SETT_NO                      
	AND SETT_TYPE = @SETT_TYPE                      
   AND ISNULL(STATUS, '') <> 'C'				-- TO BE REMOVED

	--- For the given settlement is not in open position then do not calculate the remisier brokerage sharing           
	IF @FromDate IS NULL
		RETURN

	--- Check For the selected settlement whether the bill has been posted or not? 
	IF EXISTS (SELECT 1 FROM REM_ACCBILL WHERE BROK_SHARED_SETTNO = @SETT_NO AND BILL_POSTED = 1)
		RETURN

	BEGIN TRANSACTION RemisierBrokergeComputation

	--- SELECT THE RECORDS FOR NSE
	SELECT EXCHANGE = CONVERT(CHAR(5),'NSECM'), * INTO #BROKTABLE_CM FROM MSAJAG.DBO.BROKTABLE
	
	--- SELECT THE RECORDS FOR BSE
	INSERT INTO #BROKTABLE_CM SELECT EXCHANGE = CONVERT(CHAR(5),'BSECM'), * FROM BSEDB.DBO.BROKTABLE
	
-- -- 	--- SELECT THE RECORDS FOR NSEFO
-- -- 	INSERT INTO #BROKTABLE_CM SELECT EXCHANGE = CONVERT(CHAR(5),'NSEFO'), * FROM NSEFO.DBO.BROKTABLE
-- -- 	
-- -- 	--- SELECT THE RECORDS FOR NCDX
-- -- 	INSERT INTO #BROKTABLE_CM SELECT EXCHANGE = CONVERT(CHAR(5),'NCDX'), * FROM NCDX.DBO.BROKTABLE
-- -- 	
-- -- 	--- SELECT THE RECORDS FOR MCDX
-- -- 	INSERT INTO #BROKTABLE_CM SELECT EXCHANGE = CONVERT(CHAR(5),'MCDX'), * FROM MCDX.DBO.BROKTABLE

	SELECT DISTINCT B.* INTO #BROKTABLE_FO                       
		FROM NSEFO.DBO.BROKTABLE B, RemisierBrokerageMaster RM, RemisierBrokerageScheme R                      
		WHERE R.FutTableNo = Table_No                      
		or R.OptTableNo = Table_No                      
		or R.OptExTableNo = Table_No                      
		or R.FutFinalTableNo = Table_No                      
		And (RM.Segment = 'FUTURES' OR RM.Segment = 'ALL')
		And RM.SchemeID = R.SchemeID                     
		--AND RM.FromDate BETWEEN @FromDate AND @ToDate

	SELECT DISTINCT B.* INTO #BROKTABLE_NCDX                       
		FROM NCDX.DBO.BROKTABLE B, RemisierBrokerageMaster RM, RemisierBrokerageScheme R                      
		WHERE R.FutTableNo = Table_No                      
		or R.OptTableNo = Table_No                      
		or R.OptExTableNo = Table_No                      
		or R.FutFinalTableNo = Table_No                      
		And (RM.Segment = 'COMMODITY' OR RM.Segment = 'ALL')
		And RM.SchemeID = R.SchemeID                     
		--AND RM.FromDate BETWEEN @FromDate AND @ToDate

	SELECT DISTINCT B.* INTO #BROKTABLE_MCDX                       
		FROM MCDX.DBO.BROKTABLE B, RemisierBrokerageMaster RM, RemisierBrokerageScheme R                      
		WHERE R.FutTableNo = Table_No                      
		or R.OptTableNo = Table_No                      
		or R.OptExTableNo = Table_No                      
		or R.FutFinalTableNo = Table_No                      
		And (RM.Segment = 'COMMODITY' OR RM.Segment = 'ALL')
		And RM.SchemeID = R.SchemeID                     
		--AND RM.FromDate BETWEEN @FromDate AND @ToDate
/*

	---- Remisier All Party List
	SELECT
		R.RemType, 
		R.RemPartyCd,
		R.SchemeOrSlab,
		C1.Branch_Cd AS BranchCode, 
		--C1.Sub_Broker AS SubBroker, 
		C2.Dummy10 AS SubBroker, 
		C2.Party_Code AS PartyCode, 	
		R.SchemeID, 
		R.FromDate, 
		R.ToDate,
		R.Segment,
		R.Exchange,
		R.BrokType
	INTO #RemisierAllParty
	FROM RemisierBrokerageMaster R, Client1 AS C1, Client2 AS C2 
	WHERE 
		C1.Cl_Code = C2.Cl_Code
		AND C1.Branch_Cd = CASE  WHEN R.RemType = 'BR' THEN R.RemCode ELSE C1.Branch_Cd END
-- -- 		AND C1.Sub_Broker = CASE WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN R.RemCode
-- -- 										 ELSE	C1.Sub_Broker END
		AND C2.Dummy10 = CASE WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN R.RemCode
										 ELSE	C2.Dummy10 END
		AND C2.Party_Code = CASE WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN C2.Party_Code 
										 WHEN R.RemType = 'BR' THEN C2.Party_Code END
		AND R.EntityCode = 'ALL' 
		--AND R.FromDate BETWEEN @FromDate AND @ToDate
		AND R.FromDate <= @FromDate AND R.ToDate >= @ToDate

	--- Remisier Specific Party List
	SELECT 
		R.RemType,
		R.RemPartyCd,
		R.SchemeOrSlab,
		C1.Branch_Cd AS BranchCode, 
		--C1.Sub_Broker AS SubBroker, 
		C2.Dummy10 AS SubBroker, 
		C2.Party_Code AS PartyCode, 	
		R.SchemeID, 
		R.FromDate, 
		R.ToDate,
		R.Segment,
		R.Exchange,
		R.BrokType
	INTO #RemisierSpecificParty
	FROM RemisierBrokerageMaster R, Client1 AS C1, Client2 AS C2
	WHERE 
		C1.Cl_Code = C2.Cl_Code
		AND C1.Branch_Cd = CASE WHEN R.RemType = 'BR' THEN R.RemCode ELSE C1.Branch_Cd END
-- -- 		AND C1.Sub_Broker = CASE --WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN R.RemCode
-- -- 								  		 WHEN R.RemType = 'SUB' AND R.EntityCode <> 'ALL' THEN C1.Sub_Broker
-- -- 								  		 WHEN R.RemType = 'BR'  AND R.EntityCode <> 'ALL' THEN R.EntityCode 
-- -- 										 ELSE	C1.Sub_Broker END
		AND C2.Dummy10 = CASE --WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN R.RemCode
								  		 WHEN R.RemType = 'SUB' AND R.EntityCode <> 'ALL' THEN C2.Dummy10
								  		 WHEN R.RemType = 'BR'  AND R.EntityCode <> 'ALL' THEN R.EntityCode 
										 ELSE	C2.Dummy10 END
		AND C2.Party_Code = CASE --WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN C2.Party_Code 
										 WHEN R.RemType = 'SUB' AND R.EntityCode <> 'ALL' THEN R.EntityCode
										 WHEN R.RemType = 'BR' THEN C2.Party_Code END
		AND R.EntityCode <> 'ALL' 
		--AND R.FromDate BETWEEN @FromDate AND @ToDate
		AND R.FromDate <= @FromDate AND R.ToDate >= @ToDate

	--- Remisier Blocked Partt List
	SELECT 
		CASE R.RemType WHEN 'PARTY' THEN 'SUB' 
							WHEN 'SUB' THEN 'BR'
							WHEN 'BR' THEN 'BR' 
		END AS SubBrokerOrBranch,
		C1.Branch_Cd AS BranchCode, 
		--C1.Sub_Broker AS SubBroker, 
		C2.Dummy10 AS SubBroker, 
		C2.Party_Code AS PartyCode, 	
		R.FromDate, 
		R.ToDate,
		R.Segment,
		R.Exchange
	INTO #RemisierBlockedParty
	FROM RemisierBrokerageBlocked R, Client1 AS C1, Client2 AS C2
	WHERE 
		C1.Cl_Code = C2.Cl_Code
		AND C1.Branch_Cd =  CASE WHEN R.RemType = 'BR' THEN R.RemCode ELSE C1.Branch_Cd END
		--AND C1.Sub_Broker = CASE WHEN R.RemType = 'SUB' THEN R.RemCode ELSE C1.Sub_Broker END
		AND C2.Dummy10 = CASE WHEN R.RemType = 'SUB' THEN R.RemCode ELSE C2.Dummy10 END
		AND C2.Party_Code = CASE WHEN R.RemType = 'PARTY' THEN R.RemCode ELSE C2.Party_Code END
		--AND R.FromDate BETWEEN @FromDate AND @ToDate
		AND R.FromDate <= @FromDate AND R.ToDate >= @ToDate
*/

	---- Remisier All Party List
	SELECT
		R.RemType, 
		R.RemPartyCd,
		R.SchemeOrSlab,
		C1.Branch_Cd AS BranchCode, 
		--C1.Sub_Broker AS SubBroker, 
		C1.SBU AS SubBroker, 
		C1.Party_Code AS PartyCode, 	
		R.SchemeID, 
		R.FromDate, 
		R.ToDate,
		R.Segment,
		R.Exchange,
		R.BrokType
	INTO #RemisierAllParty
	FROM RemisierBrokerageMaster R, Client_Details AS C1 
	WHERE 
		C1.Branch_Cd = CASE  WHEN R.RemType = 'BR' THEN R.RemCode ELSE C1.Branch_Cd END
-- -- 		AND C1.Sub_Broker = CASE WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN R.RemCode
-- -- 										 ELSE	C1.Sub_Broker END
		AND C1.SBU = CASE WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN R.RemCode
										 ELSE	C1.SBU END
		AND C1.Party_Code = CASE WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN C1.Party_Code 
										 WHEN R.RemType = 'BR' THEN C1.Party_Code END
		AND R.EntityCode = 'ALL' 
		--AND R.FromDate BETWEEN @FromDate AND @ToDate
		AND R.FromDate <= @FromDate AND R.ToDate >= @ToDate

	--- Remisier Specific Party List
	SELECT 
		R.RemType,
		R.RemPartyCd,
		R.SchemeOrSlab,
		C1.Branch_Cd AS BranchCode, 
		--C1.Sub_Broker AS SubBroker, 
		C1.SBU AS SubBroker, 
		C1.Party_Code AS PartyCode, 	
		R.SchemeID, 
		R.FromDate, 
		R.ToDate,
		R.Segment,
		R.Exchange,
		R.BrokType
	INTO #RemisierSpecificParty
	FROM RemisierBrokerageMaster R, Client_Details AS C1
	WHERE 
		C1.Branch_Cd = CASE WHEN R.RemType = 'BR' THEN R.RemCode ELSE C1.Branch_Cd END
-- -- 		AND C1.Sub_Broker = CASE --WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN R.RemCode
-- -- 								  		 WHEN R.RemType = 'SUB' AND R.EntityCode <> 'ALL' THEN C1.Sub_Broker
-- -- 								  		 WHEN R.RemType = 'BR'  AND R.EntityCode <> 'ALL' THEN R.EntityCode 
-- -- 										 ELSE	C1.Sub_Broker END
		AND C1.SBU = CASE --WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN R.RemCode
								  		 WHEN R.RemType = 'SUB' AND R.EntityCode <> 'ALL' THEN C1.SBU
								  		 WHEN R.RemType = 'BR'  AND R.EntityCode <> 'ALL' THEN R.EntityCode 
										 ELSE	C1.SBU END
		AND C1.Party_Code = CASE --WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN C1.Party_Code 
										 WHEN R.RemType = 'SUB' AND R.EntityCode <> 'ALL' THEN R.EntityCode
										 WHEN R.RemType = 'BR' THEN C1.Party_Code END
		AND R.EntityCode <> 'ALL' 
		--AND R.FromDate BETWEEN @FromDate AND @ToDate
		AND R.FromDate <= @FromDate AND R.ToDate >= @ToDate

	--- Remisier Blocked Partt List
	SELECT 
		CASE R.RemType WHEN 'PARTY' THEN 'SUB' 
							WHEN 'SUB' THEN 'BR'
							WHEN 'BR' THEN 'BR' 
		END AS SubBrokerOrBranch,
		C1.Branch_Cd AS BranchCode, 
		--C1.Sub_Broker AS SubBroker, 
		C1.SBU AS SubBroker, 
		C1.Party_Code AS PartyCode, 	
		R.FromDate, 
		R.ToDate,
		R.Segment,
		R.Exchange
	INTO #RemisierBlockedParty
	FROM RemisierBrokerageBlocked R, Client_Details AS C1
	WHERE 
		C1.Branch_Cd =  CASE WHEN R.RemType = 'BR' THEN R.RemCode ELSE C1.Branch_Cd END
		--AND C1.Sub_Broker = CASE WHEN R.RemType = 'SUB' THEN R.RemCode ELSE C1.Sub_Broker END
		AND C1.SBU = CASE WHEN R.RemType = 'SUB' THEN R.RemCode ELSE C1.SBU END
		AND C1.Party_Code = CASE WHEN R.RemType = 'PARTY' THEN R.RemCode ELSE C1.Party_Code END
		--AND R.FromDate BETWEEN @FromDate AND @ToDate
		AND R.FromDate <= @FromDate AND R.ToDate >= @ToDate

	--- All Remisier Party List
	SELECT BranchCode, SubBroker, PartyCode INTO #PARTYLIST	FROM #RemisierAllParty 
	UNION 
	SELECT BranchCode, SubBroker, PartyCode FROM #RemisierSpecificParty

-- -- Select * Into ##RemisierAllParty from #RemisierAllParty
-- -- Select * Into ##RemisierSpecificParty from #RemisierSpecificParty
-- -- Select * Into ##RemisierBlockedParty from #RemisierBlockedParty
-- -- Select * Into ##PARTYLIST from #PARTYLIST

	--- Data From BSEDB.SETTLEMENT
	SELECT S.SETT_NO,                      
	       S.SETT_TYPE,                      
	       S.PARTY_CODE,                      
	       S.SCRIP_CD,                      
	       S.SERIES,                      
	       SAUDA_DATE =CONVERT(CHAR(11), S.SAUDA_DATE,109),                      
	       S.TRADE_NO,                      
	       S.ORDER_NO,                      
	       S.SELL_BUY,                      
	       S.TRADEQTY,                      
	       S.MARKETRATE,                      
	       BROKAPPLIED,                      
	       NBROKAPP,                      
	       BILLFLAG,                      
	       --REMCODE = SUB_BROKER,
          REMCODE = C2.DUMMY10,            
	       BRANCH_CD,                      
	       REM_BROKAPPLIED = CONVERT(NUMERIC(18,4),0),                      
	       REM_NBROKAPP = CONVERT(NUMERIC(18,4),0),                      
	       STATUS = '0',                      
	       SLABTYPE = CONVERT(VARCHAR(10),''),                      
	       FROMDATE = CONVERT(DATETIME,@FromDate),                      
	       TODATE = CONVERT(DATETIME,@ToDate + ' 23:59:59'),                      
	       REMPARTYCD = CONVERT(VARCHAR(10),''),                  
	       EXCHANGEID = 'BSECM',  
			 SCHEMEID = CONVERT(INT, 0),
			 SCHEMEORSLAB = CONVERT(VARCHAR(7),''),		-- SCHEME/SLAB
			 REMTYPE = CONVERT(VARCHAR(3),'')				-- SUB/BR
			-- BROKTYPE = CONVERT(VARCHAR(10),'') 	      -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT
	INTO   #REMBROK                      
	FROM   BSEDB.DBO.CLIENT1 C1,                      
	       BSEDB.DBO.CLIENT2 C2,                      
	       BSEDB.DBO.SETTLEMENT S, 
			 #PARTYLIST P
	WHERE  
			S.SAUDA_DATE >= @FromDate                      
       	AND S.SAUDA_DATE <= @ToDate + ' 23:59'                      
	      AND C1.CL_CODE = C2.CL_CODE                      
	      AND C2.PARTY_CODE = S.PARTY_CODE                      
	      AND AUCTIONPART NOT IN ('AP',                      
	                               'AR',                      
	                               'FP',                      
	                               'FS',                      
	                               'FA',                      
	                               'FC',                      
	                               'FL')                      
			AND S.PARTY_CODE = P.PARTYCODE  

	--- Data From BSEDB.HISTORY	                    
	INSERT INTO   #REMBROK                      
	SELECT S.SETT_NO,                      
	       S.SETT_TYPE,                      
	       S.PARTY_CODE,                      
	       S.SCRIP_CD,                      
	       S.SERIES,                      
			 SAUDA_DATE =CONVERT(CHAR(11), S.SAUDA_DATE,109),
	       S.TRADE_NO,                      
	       S.ORDER_NO,                      
	       S.SELL_BUY,                      
			 S.TRADEQTY,                      
	       S.MARKETRATE,                      
	       BROKAPPLIED,               
	       NBROKAPP,                      
	       BILLFLAG,                      
	       --REMCODE = SUB_BROKER,
          REMCODE = C2.DUMMY10,            
	       BRANCH_CD,                      
	       REM_BROKAPPLIED = CONVERT(NUMERIC(18,4),0),                      
	       REM_NBROKAPP = CONVERT(NUMERIC(18,4),0),                      
	       STATUS = '0',                      
	       SLABTYPE = CONVERT(VARCHAR(10),''),           
	       FROMDATE = CONVERT(DATETIME,@FromDate),                      
	       TODATE = CONVERT(DATETIME,@ToDate + ' 23:59:59'),                      
	       REMPARTYCD = CONVERT(VARCHAR(10),''),                  
	       EXCHANGEID = 'BSECM' ,  
			 SCHEMEID = CONVERT(INT, 0),
			 SCHEMEORSLAB = CONVERT(VARCHAR(7),''),		-- SCHEME/SLAB
			 REMTYPE = CONVERT(VARCHAR(3),'')				-- SUB/BR
			-- BROKTYPE = CONVERT(VARCHAR(10),'') 	      -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT                     
	FROM   BSEDB.DBO.CLIENT1 C1,                      
	       BSEDB.DBO.CLIENT2 C2,                      
	       BSEDB.DBO.HISTORY S,
			 #PARTYLIST P
	WHERE  
			S.SAUDA_DATE >= @FromDate                      
       	AND S.SAUDA_DATE <= @ToDate + ' 23:59'                      
	      AND C1.CL_CODE = C2.CL_CODE                      
	      AND C2.PARTY_CODE = S.PARTY_CODE                      
	      AND AUCTIONPART NOT IN ('AP',                      
	                               'AR',                      
	                               'FP',                      
	                               'FS',                      
	                               'FA',                      
	                               'FC',                      
	                               'FL')                      
			AND S.PARTY_CODE = P.PARTYCODE  

	--- Data From MSAJAG.SETTLEMENT	                      
	INSERT INTO #REMBROK                      
	SELECT S.SETT_NO,                      
	       S.SETT_TYPE,                      
	       S.PARTY_CODE,                      
	       S.SCRIP_CD,                      
	       S.SERIES,                      
			 SAUDA_DATE =CONVERT(CHAR(11), S.SAUDA_DATE,109),
	       S.TRADE_NO,                      
	       S.ORDER_NO,                      
	       S.SELL_BUY,                      
	       S.TRADEQTY,                      
	       S.MARKETRATE,                      
	       BROKAPPLIED,                      
	       NBROKAPP,                      
	       BILLFLAG,                      
	       --REMCODE = SUB_BROKER,
          REMCODE = C2.DUMMY10,            
	       BRANCH_CD,                      
	       REM_BROKAPPLIED = CONVERT(NUMERIC(18,4),0),                      
	       REM_NBROKAPP = CONVERT(NUMERIC(18,4),0),                      
	       STATUS = '0',                      
	       SLABTYPE = CONVERT(VARCHAR(10),''),                      
	       FROMDATE = CONVERT(DATETIME,@FromDate),                      
	       TODATE = CONVERT(DATETIME,@ToDate + ' 23:59:59'),                      
	       REMPARTYCD = CONVERT(VARCHAR(10),''),                  
	       EXCHANGEID = 'NSECM',  
			 SCHEMEID = CONVERT(INT, 0),
			 SCHEMEORSLAB = CONVERT(VARCHAR(7),''),		-- SCHEME/SLAB
			 REMTYPE = CONVERT(VARCHAR(3),'')				-- SUB/BR
			-- BROKTYPE = CONVERT(VARCHAR(10),'') 	      -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT                        
	FROM   CLIENT1 C1,                      
	       CLIENT2 C2,                      
	       SETTLEMENT S,
			 #PARTYLIST P
	WHERE  
			S.SAUDA_DATE >= @FromDate                      
       	AND S.SAUDA_DATE <= @ToDate + ' 23:59'                      
	      AND C1.CL_CODE = C2.CL_CODE                      
	      AND C2.PARTY_CODE = S.PARTY_CODE                      
	      AND AUCTIONPART NOT IN ('AP',                      
	                               'AR',                      
	                               'FP',                      
	                               'FS',                      
	                               'FA',                      
	                               'FC',                      
	                               'FL')                      
			AND S.PARTY_CODE = P.PARTYCODE  

	--- Data From MSAJAG.HISTORY		             
	INSERT INTO #REMBROK                      
	SELECT S.SETT_NO,                      
	       S.SETT_TYPE,                      
	       S.PARTY_CODE,                      
	       S.SCRIP_CD,                      
	       S.SERIES,                      
			 SAUDA_DATE =CONVERT(CHAR(11), S.SAUDA_DATE,109),
	       S.TRADE_NO,                      
			 S.ORDER_NO,                
	       S.SELL_BUY,                      
	       S.TRADEQTY,                      
	       S.MARKETRATE,                      
	       BROKAPPLIED,                      
	       NBROKAPP,                      
	       BILLFLAG,                      
	       --REMCODE = SUB_BROKER,
          REMCODE = C2.DUMMY10,            
	       BRANCH_CD,                      
	       REM_BROKAPPLIED = CONVERT(NUMERIC(18,4),0),                      
	       REM_NBROKAPP = CONVERT(NUMERIC(18,4),0),                      
	       STATUS = '0',                      
	       SLABTYPE = CONVERT(VARCHAR(10),''),                      
	       FROMDATE = CONVERT(DATETIME,@FromDate),                      
	       TODATE = CONVERT(DATETIME,@ToDate + ' 23:59:59'),                      
	       REMPARTYCD = CONVERT(VARCHAR(10),''),                  
	       EXCHANGEID = 'NSECM',  
			 SCHEMEID = CONVERT(INT, 0),
			 SCHEMEORSLAB = CONVERT(VARCHAR(7),''),		-- SCHEME/SLAB
			 REMTYPE = CONVERT(VARCHAR(3),'')				-- SUB/BR
			-- BROKTYPE = CONVERT(VARCHAR(10),'') 	      -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT                       
	FROM   CLIENT1 C1,                      
	       CLIENT2 C2,                      
	       HISTORY S,
			 #PARTYLIST P
	WHERE  
			S.SAUDA_DATE >= @FromDate                      
       	AND S.SAUDA_DATE <= @ToDate + ' 23:59'                      
	      AND C1.CL_CODE = C2.CL_CODE                      
	      AND C2.PARTY_CODE = S.PARTY_CODE                      
	      AND AUCTIONPART NOT IN ('AP',                      
	                               'AR',                      
	                               'FP',                      
	                               'FS',                      
	                               'FA',                      
	                               'FC',                      
	                               'FL')                      
			AND S.PARTY_CODE = P.PARTYCODE  

	--- Data From NSEFO.FOSETTLEMENT	                      
	SELECT S.PARTY_CODE, INST_TYPE, SYMBOL, EXPIRYDATE, STRIKE_PRICE, OPTION_TYPE, AUCTIONPART, SETTFLAG,                        
      SAUDA_DATE =CONVERT(CHAR(11), S.SAUDA_DATE,109), TRADE_NO, ORDER_NO, SELL_BUY,                 
		TRADEQTY, PRICE, BROKERAGE=BROKAPPLIED*TRADEQTY,                       
      --REMCODE = SUB_BROKER,
      REMCODE = C2.DUMMY10,            
		BRANCH_CD,                       
		REM_BROKAPPLIED=CONVERT(NUMERIC(18,4),0), REM_NBROKAPP=CONVERT(NUMERIC(18,4),0), Status = '0',                      
		SLABTYPE=CONVERT(VARCHAR(10),''),                      
		FROMDATE = CONVERT(DATETIME,@FromDate),                       
		TODATE = CONVERT(DATETIME,@ToDate + ' 23:59:59'),                      
		MPRICE = STRIKE_PRICE+PRICE,                      
		MULTIPLIER = 1,                      
		REMPARTYCD = CONVERT(VARCHAR(10),''),                   
		EXCHANGEID = 'NSEFO',  
		SCHEMEID = CONVERT(INT, 0),
		SCHEMEORSLAB = CONVERT(VARCHAR(7),''),		-- SCHEME/SLAB
		REMTYPE = CONVERT(VARCHAR(3),'')				-- SUB/BR
		-- BROKTYPE = CONVERT(VARCHAR(10),'') 	      -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT                     
	INTO #FOREMBROK                      
	FROM NSEFO.DBO.CLIENT1 C1, NSEFO.DBO.CLIENT2 C2, NSEFO.DBO.FOSETTLEMENT S, #PARTYLIST P                      
	WHERE 
		S.SAUDA_DATE >= @FromDate                      
	 	AND S.SAUDA_DATE <= @ToDate + ' 23:59'                      
		AND C1.CL_CODE = C2.CL_CODE                      
		AND C2.PARTY_CODE = S.PARTY_CODE                      
		AND AUCTIONPART <> 'CA'                      
  	   AND PRICE > 0    
		AND S.PARTY_CODE = P.PARTYCODE  
                
	--- Update SchemeID For All Party (For CAPITAL MARKET & SUB BROKER Only)
	UPDATE #REMBROK SET
		 SLABTYPE = R.BrokType, -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT
		 SCHEMEID = R.SchemeID,
		 SCHEMEORSLAB = R.SchemeOrSlab, -- SCHEME/SLAB
		 REMTYPE =	R.RemType, -- SUB/BR
		 REMPARTYCD = R.RemPartyCd
	FROM #REMBROK A, #RemisierAllParty R
	WHERE
		A.PARTY_CODE = R.PARTYCODE AND
		A.SAUDA_DATE BETWEEN R.FROMDATE AND R.TODATE AND
		(R.SEGMENT = 'CAPITAL' OR R.SEGMENT = 'ALL') AND
		EXCHANGEID = CASE WHEN R.EXCHANGE IN ('CM','ALL') THEN EXCHANGEID ELSE R.EXCHANGE END
		AND R.REMTYPE = 'SUB'

	--- Overright SchemeID For Specific Party (For CAPITAL MARKET & SUB BROKER Only)
	UPDATE #REMBROK SET
		 SLABTYPE = R.BrokType, -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT
		 SCHEMEID = R.SchemeID,
		 SCHEMEORSLAB = R.SchemeOrSlab, -- SCHEME/SLAB
		 REMTYPE =	R.RemType, -- SUB/BR
		 REMPARTYCD = R.RemPartyCd
	FROM #REMBROK A, #RemisierSpecificParty R
	WHERE
		A.PARTY_CODE = R.PARTYCODE AND
		A.SAUDA_DATE BETWEEN R.FROMDATE AND R.TODATE AND
		(R.SEGMENT = 'CAPITAL' OR R.SEGMENT = 'ALL') AND
		EXCHANGEID = CASE WHEN R.EXCHANGE IN ('CM','ALL') THEN EXCHANGEID ELSE R.EXCHANGE END
		AND R.REMTYPE = 'SUB'

-- -- 	--- Update SchemeID With Zero For Blocked Parties (For CAPITAL MARKET & SUB BROKER Only)
-- -- 	UPDATE #REMBROK SET
-- -- 		 SLABTYPE = '', -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT
-- -- 		 SCHEMEID = 0,
-- -- 		 SCHEMEORSLAB = '', -- SCHEME/SLAB
-- -- 		 REMTYPE =	'', -- SUB/BR
-- -- 		 REMPARTYCD = ''
-- -- 	FROM #REMBROK A, #RemisierBlockedParty R
-- -- 	WHERE
-- -- 		A.Party_Code = R.PartyCode AND
-- -- 		A.Sauda_Date BETWEEN R.FromDate AND R.ToDate AND
-- -- 		(R.Segment = 'CAPITAL' OR R.Segment = 'ALL') AND
-- -- 		R.SubBrokerOrBranch = 'SUB'

--select * from #REMBROK

	--- If any party is excluded for the SUB brokerage sharing then the same Party should be excluded for BR sharing also.	
	DELETE FROM #REMBROK 
		WHERE Party_Code IN (SELECT PartyCode FROM #RemisierBlockedParty 
										  --WHERE @FromDate >= FromDate AND @ToDate <= ToDate AND SubBrokerOrBranch = 'SUB')
											 WHERE FromDate<=@FromDate AND ToDate>=@ToDate AND SubBrokerOrBranch = 'SUB')

--select * from #REMBROK

	--- Update SchemeID For All Party (For FUTURES & SUB BROKER Only)
	UPDATE #FOREMBROK SET
		 SLABTYPE = R.BrokType, -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT
		 SCHEMEID = R.SchemeID,
		 SCHEMEORSLAB = R.SchemeOrSlab, -- SCHEME/SLAB
		 REMTYPE =	R.RemType, -- SUB/BR
		 REMPARTYCD = R.RemPartyCd
	FROM #FOREMBROK A, #RemisierAllParty R
	WHERE
		A.PARTY_CODE = R.PARTYCODE AND
		A.SAUDA_DATE BETWEEN R.FROMDATE AND R.TODATE AND
		(R.Segment = 'FUTURES' OR R.Segment = 'ALL') AND
		EXCHANGEID = CASE WHEN R.EXCHANGE IN ('FO','ALL') THEN EXCHANGEID ELSE R.EXCHANGE END
		AND R.REMTYPE = 'SUB'

	--- Overright SchemeID For Specific Party (For FUTURES MARKET & SUB BROKER Only)
	UPDATE #FOREMBROK SET
		 SLABTYPE = R.BrokType, -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT
		 SCHEMEID = R.SchemeID,
		 SCHEMEORSLAB = R.SchemeOrSlab, -- SCHEME/SLAB
		 REMTYPE =	R.RemType, -- SUB/BR
		 REMPARTYCD = R.RemPartyCd
	FROM #FOREMBROK A, #RemisierSpecificParty R
	WHERE
		A.PARTY_CODE = R.PARTYCODE AND
		A.SAUDA_DATE BETWEEN R.FROMDATE AND R.TODATE AND
		(R.Segment = 'FUTURES' OR R.Segment = 'ALL') AND
		EXCHANGEID = CASE WHEN R.EXCHANGE IN ('FO','ALL') THEN EXCHANGEID ELSE R.EXCHANGE END
		AND R.REMTYPE = 'SUB'

-- -- 	--- Update SchemeID With Zero For Blocked Parties (For FUTURES MARKET & SUB BROKER Only)
-- -- 	UPDATE #FOREMBROK SET
-- -- 		 SLABTYPE = '', -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT
-- -- 		 SCHEMEID = 0,
-- -- 		 SCHEMEORSLAB = '', -- SCHEME/SLAB
-- -- 		 REMTYPE =	'', -- SUB/BR
-- -- 		 REMPARTYCD = ''
-- -- 	FROM #FOREMBROK A, #RemisierBlockedParty R
-- -- 	WHERE
-- -- 		A.Party_Code = R.PartyCode AND
-- -- 		A.Sauda_Date BETWEEN R.FromDate AND R.ToDate AND
-- -- 		(R.Segment = 'FUTURES' OR R.Segment = 'ALL') AND
-- -- 		R.SubBrokerOrBranch = 'SUB'

	--- If any party is excluded for the SUB brokerage sharing then the same Party should be excluded for BR sharing also.	
	DELETE FROM #FOREMBROK 
		WHERE Party_Code IN ( SELECT PartyCode FROM #RemisierBlockedParty 
										  WHERE @FromDate >= FromDate AND @ToDate <= ToDate AND SubBrokerOrBranch = 'SUB')

	-- Update Remisier Trading Brokerage For Scheme For Capital Market
	UPDATE #REMBROK  SET REM_BROKAPPLIED =                    
	 					(CASE                       
                   WHEN #REMBROK.STATUS = 'N' THEN 0                      
						 ELSE (CASE                       
                        WHEN (#REMBROK.BILLFLAG = 1                      
                              AND #BROKTABLE_CM.VAL_PERC = 'V'         
                              AND SELL_BUY = 1) THEN  /* #BROKTABLE_CM.Normal */                      
                              ((Floor((#BROKTABLE_CM.NORMAL * Power(10,#BROKTABLE_CM.ROUND_TO) + #BROKTABLE_CM.ROFIG + #BROKTABLE_CM.ERRNUM) / (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) * (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) / Power(10,#BROKTABLE_CM.ROUND_TO))       
			               WHEN (#REMBROK.BILLFLAG = 1            
                              AND #BROKTABLE_CM.VAL_PERC = 'V'                      
                           AND SELL_BUY = 2) THEN /* #BROKTABLE_CM.Normal  */                      
                             ((Floor((#BROKTABLE_CM.NORMAL * Power(10,#BROKTABLE_CM.ROUND_TO) + #BROKTABLE_CM.ROFIG + #BROKTABLE_CM.ERRNUM) / (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) * (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) / Power(10,#BROKTABLE_CM.ROUND_TO))        
                        WHEN (#REMBROK.BILLFLAG = 1                      
                              AND #BROKTABLE_CM.VAL_PERC = 'P'                      
                              AND SELL_BUY = 1) THEN ((Floor((((#BROKTABLE_CM.NORMAL / 100) * #REMBROK.MARKETRATE) * Power(10,#BROKTABLE_CM.ROUND_TO) + #BROKTABLE_CM.ROFIG + #BROKTABLE_CM.ERRNUM) / (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) * (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) / Power(10,#BROKTABLE_CM.ROUND_TO))                      
                        WHEN (#REMBROK.BILLFLAG = 1                      
                              AND #BROKTABLE_CM.VAL_PERC = 'P'                      
                           AND SELL_BUY = 2) THEN /* round((#BROKTABLE_CM.Normal /100 )* #REMBROK.marketrate,#BROKTABLE_CM.Round_To)         */                      
                          ((Floor((((#BROKTABLE_CM.NORMAL / 100) * #REMBROK.MARKETRATE) * Power(10,#BROKTABLE_CM.ROUND_TO) + #BROKTABLE_CM.ROFIG + #BROKTABLE_CM.ERRNUM) / (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) * (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) / Power(10,#BROKTABLE_CM.ROUND_TO))                      
                        WHEN (#REMBROK.BILLFLAG = 2                      
                              AND #BROKTABLE_CM.VAL_PERC = 'V') THEN /* ((#BROKTABLE_CM.day_puc)) */                      
                             ((Floor((((#BROKTABLE_CM.DAY_PUC)) * Power(10,#BROKTABLE_CM.ROUND_TO) + #BROKTABLE_CM.ROFIG + #BROKTABLE_CM.ERRNUM) / (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) * (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) / Power(10,#BROKTABLE_CM.ROUND_TO))   
                        WHEN (#REMBROK.BILLFLAG = 2                      
                           AND #BROKTABLE_CM.VAL_PERC = 'P') THEN /* round((#BROKTABLE_CM.day_puc/100) * #REMBROK.marketrate,#BROKTABLE_CM.Round_To)  */                      
                             ((Floor((((#BROKTABLE_CM.DAY_PUC / 100) * #REMBROK.MARKETRATE) * Power(10,#BROKTABLE_CM.ROUND_TO) + #BROKTABLE_CM.ROFIG + #BROKTABLE_CM.ERRNUM) / (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) * (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) / Power(10,#BROKTABLE_CM.ROUND_TO))                      
                        WHEN (#REMBROK.BILLFLAG = 3                      
                              AND #BROKTABLE_CM.VAL_PERC = 'V') THEN /* #BROKTABLE_CM.day_sales */                      
                             ((Floor((#BROKTABLE_CM.DAY_SALES * Power(10,#BROKTABLE_CM.ROUND_TO) + #BROKTABLE_CM.ROFIG + #BROKTABLE_CM.ERRNUM) / (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) * (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) / Power(10,#BROKTABLE_CM.ROUND_TO))     
                        WHEN (#REMBROK.BILLFLAG = 3                      
                              AND #BROKTABLE_CM.VAL_PERC = 'P') THEN /*round((#BROKTABLE_CM.day_sales/ 100) * #REMBROK.marketrate ,#BROKTABLE_CM.Round_To) */                      
                             ((Floor((((#BROKTABLE_CM.DAY_SALES / 100) * #REMBROK.MARKETRATE) * Power(10,#BROKTABLE_CM.ROUND_TO) + #BROKTABLE_CM.ROFIG + #BROKTABLE_CM.ERRNUM) / (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) * (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) / Power(10,#BROKTABLE_CM.ROUND_TO))                      
                        WHEN (#REMBROK.BILLFLAG = 4                      
                              AND #BROKTABLE_CM.VAL_PERC = 'V') THEN /* #BROKTABLE_CM.sett_purch  */                      
									  ((Floor((#BROKTABLE_CM.SETT_PURCH * Power(10,#BROKTABLE_CM.ROUND_TO) + #BROKTABLE_CM.ROFIG + #BROKTABLE_CM.ERRNUM) / (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) * (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) / Power(10,#BROKTABLE_CM.ROUND_TO))          
                        WHEN (#REMBROK.BILLFLAG = 4                      
                              AND #BROKTABLE_CM.VAL_PERC = 'P') THEN /* round((#BROKTABLE_CM.sett_purch/100) * #REMBROK.marketrate ,#BROKTABLE_CM.Round_To) */                      
                             ((Floor((((#BROKTABLE_CM.SETT_PURCH / 100) * #REMBROK.MARKETRATE) * Power(10,#BROKTABLE_CM.ROUND_TO) + #BROKTABLE_CM.ROFIG + #BROKTABLE_CM.ERRNUM) / (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) * (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) / Power(10,#BROKTABLE_CM.ROUND_TO))                      
                        WHEN (#REMBROK.BILLFLAG = 5                      
                              AND #BROKTABLE_CM.VAL_PERC = 'V') THEN /* #BROKTABLE_CM.sett_sales */                      
                             ((Floor((#BROKTABLE_CM.SETT_SALES * Power(10,#BROKTABLE_CM.ROUND_TO) + #BROKTABLE_CM.ROFIG + #BROKTABLE_CM.ERRNUM) / (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) * (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) / Power(10,#BROKTABLE_CM.ROUND_TO))    
                        WHEN (#REMBROK.BILLFLAG = 5                      
                              AND #BROKTABLE_CM.VAL_PERC = 'P') THEN /* round((#BROKTABLE_CM.sett_sales/100) * #REMBROK.marketrate ,#BROKTABLE_CM.Round_To)*/                      
                             ((Floor((((#BROKTABLE_CM.SETT_SALES / 100) * #REMBROK.MARKETRATE) * Power(10,#BROKTABLE_CM.ROUND_TO) + #BROKTABLE_CM.ROFIG + #BROKTABLE_CM.ERRNUM) / (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) * (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) / Power(10,#BROKTABLE_CM.ROUND_TO))                      
                        ELSE 0                      
                      END)                      
                 END)                      
	FROM   #BROKTABLE_CM,                      
	       #REMBROK,                      
			 RemisierBrokerageScheme R,
	       (SELECT   SETT_NO,                      
	                 SETT_TYPE,                      
	                 PARTY_CODE,                  
	                 SCRIP_CD,                      
	                 SERIES, 
                    EXCHANGEID, 
	                 PQTY = SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END),                      
	                 SQTY = SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END),                      
	                 PRATE = (CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END) > 0      
	                               		THEN SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY * MARKETRATE ELSE 0 END) /                      
	                                    	  SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END)                      
	                        	ELSE 0 END),      

 	                 SRATE = (CASE WHEN SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END) > 0      
	                               		THEN SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY * MARKETRATE ELSE 0 END) /                      
	                                    	  SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END)                      
	                        	ELSE 0 END)      
	        FROM     #REMBROK                      
	        GROUP BY SETT_NO,                      
	                 SETT_TYPE,                      
	                 PARTY_CODE,                      
	                 SCRIP_CD,                      
	                 SERIES,
						  EXCHANGEID) C                      
	WHERE  
		#REMBROK.SchemeID > 0 
		AND #REMBROK.SchemeID = R.SchemeID
		AND #REMBROK.SchemeOrSlab = 'SCHEME'
		AND C.SETT_NO = #REMBROK.SETT_NO                      
		AND C.SETT_TYPE = #REMBROK.SETT_TYPE                      
		AND C.SETT_TYPE = #REMBROK.SETT_TYPE                      
		AND C.SCRIP_CD = #REMBROK.SCRIP_CD                      
		AND C.SERIES = #REMBROK.SERIES   
		AND C.EXCHANGEID = #REMBROK.EXCHANGEID                   
		AND TRDTABLENO = #BROKTABLE_CM.TABLE_NO                      
		AND BILLFLAG IN (2, 3)                      
		AND #BROKTABLE_CM.LINE_NO = 
	   (Case When R.Brokscheme = 2  Then (Select Min(#BROKTABLE_CM.Line_No) From #BROKTABLE_CM   
	        Where R.TrdTableNo = #BROKTABLE_CM.Table_No  
	        And Trd_Del = 
			 (Case When C.Pqty = C.Sqty   
			       Then (Case When C.Prate > = C.Srate   
			                  Then (Case When #REMBROK.Sell_Buy = 1  Then 'F' Else 'S' End )  
			 				 Else  
			 				 (Case When ( #REMBROK.Sell_Buy = 2 ) Then 'F' Else 'S'  End )       
					  	    End)  
			  Else (Case When C.Pqty > = C.Sqty   
			             Then (Case When ( #REMBROK.Sell_Buy = 1 ) Then 'F' Else 'S' End )  
			             Else  
			             (Case When ( #REMBROK.Sell_Buy = 2 ) Then 'F' Else 'S' End )
	              End )  
	        End )  
			  And	#REMBROK.SchemeID = R.SchemeID     
	        And #REMBROK.Marketrate <= #BROKTABLE_CM.Upper_Lim
			  AND #REMBROK.EXCHANGEID = #BROKTABLE_CM.EXCHANGE)   
	    Else   
	    (Case When R.Brokscheme = 1 Then (Select Min(#BROKTABLE_CM.Line_No) From #BROKTABLE_CM   
	    		 Where R.TrdTableNo = #BROKTABLE_CM.Table_No                                                    
	          And Trd_Del = 
				(Case When C.Pqty > = C.Sqty   
	         		Then (Case When #REMBROK.Sell_Buy = 1 Then 'F' Else 'S' End )  
	          Else  
	               (Case When ( #REMBROK.Sell_Buy = 2 ) Then 'F' Else 'S' End )       
	          End )  
	          And #REMBROK.SchemeID = R.SchemeID       
	          And #REMBROK.Marketrate < = #BROKTABLE_CM.Upper_Lim
				 AND #REMBROK.EXCHANGEID = #BROKTABLE_CM.EXCHANGE)              
	     Else (Case When R.Brokscheme = 3 Then (Select Min(#BROKTABLE_CM.Line_No) From #BROKTABLE_CM   
	     		  Where R.TrdTableNo = #BROKTABLE_CM.Table_No  
	           And Trd_Del = 
				 (Case When C.Pqty > C.Sqty   
	                Then (Case When #REMBROK.Sell_Buy = 1 Then 'F' Else 'S' End )  
	                Else  
	                     (Case When #REMBROK.Sell_Buy = 2 Then 'F' Else 'S' End ) 
	           End )  
	           And	#REMBROK.SchemeID = R.SchemeID      
	           And #REMBROK.Marketrate < = #BROKTABLE_CM.Upper_Lim
				  AND #REMBROK.EXCHANGEID = #BROKTABLE_CM.EXCHANGE)            
	     Else   
	     (Select Min(#BROKTABLE_CM.Line_No) From #BROKTABLE_CM   
	      	  Where R.TrdTableNo = #BROKTABLE_CM.Table_No  
	           And	#REMBROK.SchemeID = R.SchemeID           
	           And #REMBROK.Marketrate < = #BROKTABLE_CM.Upper_Lim 
				  AND #REMBROK.EXCHANGEID = #BROKTABLE_CM.EXCHANGE) 
	      End )  
	    End )  
	 End )  
	------------------------	End of Remisier Trading Brokerage Updation

	---- Update Remisier Delivery Brokerage                       
	UPDATE #REMBROK                      
	SET    REM_NBROKAPP = (CASE                       
	                         WHEN (#BROKTABLE_CM.VAL_PERC = 'V') THEN ((Floor((#BROKTABLE_CM.NORMAL * Power(10,#BROKTABLE_CM.ROUND_TO) + #BROKTABLE_CM.ROFIG + #BROKTABLE_CM.ERRNUM) / (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) * (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) / Power(10,#BROKTABLE_CM.ROUND_TO))                      
	                         WHEN (#BROKTABLE_CM.VAL_PERC = 'P') THEN ((Floor((((#BROKTABLE_CM.NORMAL / 100) *#REMBROK.MARKETRATE) * Power(10,#BROKTABLE_CM.ROUND_TO) + #BROKTABLE_CM.ROFIG + #BROKTABLE_CM.ERRNUM) / (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) * (#BROKTABLE_CM.ROFIG + #BROKTABLE_CM.NOZERO)) / Power(10,#BROKTABLE_CM.ROUND_TO))                      
	                         ELSE BROKAPPLIED                      
	                       END)   
	FROM   #BROKTABLE_CM,                      
	       #REMBROK,                      
			 RemisierBrokerageScheme R                       
	WHERE  #REMBROK.SchemeID > 0
			 AND #REMBROK.SchemeID = R.SchemeID                       
			 AND #REMBROK.SchemeOrSlab = 'SCHEME'
	       AND R.DELTABLENO = #BROKTABLE_CM.TABLE_NO                      
	       AND #BROKTABLE_CM.LINE_NO = (SELECT MIN(#BROKTABLE_CM.LINE_NO) FROM #BROKTABLE_CM WHERE DELTABLENO = #BROKTABLE_CM.TABLE_NO  AND TRD_DEL = 'D'                      
	           								AND  #REMBROK.SchemeID = R.SchemeID AND #REMBROK.MARKETRATE <= #BROKTABLE_CM.UPPER_LIM)           
	       AND #REMBROK.BILLFLAG IN (1,4,5)   
			 AND #REMBROK.EXCHANGEID = #BROKTABLE_CM.EXCHANGE                   

	---- Update Remisier Brokerage NSEFO Trades	                      
	Update #FOREMBROK set                         
	 REM_BROKAPPLIED =                      
	  (((case when ( #FOREMBROK.SettFlag = 1 and broktable.val_perc ='V' and #FOREMBROK.sell_buy = 1)                        
	  Then ((floor(( broktable.Normal*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ))/power(10,broktable.round_to))                        
	  when ( #FOREMBROK.SettFlag = 1 and broktable.val_perc ='V' and #FOREMBROK.sell_buy = 2)                
	  Then ((floor(( broktable.Normal*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ))/power(10,broktable.round_to))                        
	  when ( #FOREMBROK.SettFlag = 1 and broktable.val_perc ='P' and #FOREMBROK.sell_buy = 1)                        
	  Then ((floor((((broktable.Normal*MultiPlier /100 ) * MPrice)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))                        
	  when ( #FOREMBROK.SettFlag = 1 and broktable.val_perc ='P' and #FOREMBROK.sell_buy = 2)                        
	  Then                         
	   ((floor(( ((broktable.Normal*MultiPlier /100 )* MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when (#FOREMBROK.SettFlag = 2  and broktable.val_perc ='V' )       Then                         
	   ((floor(( ((Broktable.Day_puc*MultiPlier))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when (#FOREMBROK.SettFlag = 2  and broktable.val_perc ='P' )                         
	  Then                         
	   ((floor(( ((Broktable.Day_puc*MultiPlier/100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when (#FOREMBROK.SettFlag = 3  and broktable.val_perc ='V' )                        
	  Then                         
	   ((floor(( Broktable.day_sales*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when (#FOREMBROK.SettFlag = 3  and broktable.val_perc ='P' )                        
	  Then                       
	   ((floor(( ((Broktable.day_sales*MultiPlier/ 100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when ( #FOREMBROK.SettFlag = 4  and broktable.val_perc ='V' )                        
	  Then                         
	   ((floor(( Broktable.Sett_purch*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when ( #FOREMBROK.SettFlag = 4  and broktable.val_perc ='P' )                        
	  Then                         
	   ((floor(( ((Broktable.Sett_purch*MultiPlier/100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when ( #FOREMBROK.SettFlag = 5  and broktable.val_perc ='V' )                        
	  Then                         
	   ((floor(( Broktable.Sett_sales*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when ( #FOREMBROK.SettFlag = 5  and broktable.val_perc ='P' )                        
	  Then                         
	   ((floor(( ((Broktable.Sett_sales*MultiPlier/100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	        when (#FOREMBROK.SettFlag = 8  and broktable.val_perc ='V' )                       
	                                    Then                       
	          ((floor(( ((MultiPlier*broktable.Sett_purch))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	                              when (#FOREMBROK.SettFlag = 8  and broktable.val_perc ='P' )                       
	                                     Then                       
	          ((floor(( ((MultiPlier*Broktable.Sett_purch/100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	                          
	        when (#FOREMBROK.SettFlag = 9  and broktable.val_perc ='V' )                      
	                                     Then                       
	          ((floor(( MultiPlier*Broktable.Sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	                          when (#FOREMBROK.SettFlag = 9  and broktable.val_perc ='P' )                      
	                                     Then                       
	          ((floor(( ((MultiPlier*Broktable.Sett_sales/ 100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                 
	                        when ( #FOREMBROK.SettFlag = 6  and broktable.val_perc ='V' )                      
	                                     Then                       
	          ((floor((MultiPlier* Broktable.Sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	     power(10,broktable.round_to))                      
	                                 when ( #FOREMBROK.SettFlag = 6  and broktable.val_perc ='P' )                      
	                                Then                       
	 ((floor(( ((MultiPlier*Broktable.Sett_purch/100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	                     when ( #FOREMBROK.SettFlag = 7  and broktable.val_perc ='V' )                      
	                                     Then                       
	          ((floor((MultiPlier* Broktable.Sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	                     when ( #FOREMBROK.SettFlag = 7  and broktable.val_perc ='P' )                      
	                                     Then                       
	          ((floor(( ((MultiPlier*Broktable.Sett_sales/100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	  Else  0                         
	  End                         
	 )))                    
	FROM                       
	 #BROKTABLE_FO BrokTable,                      
	 #FOREMBROK,                      
	 RemisierBrokerageScheme R,	
    ( SELECT RemCode,inst_type,symbol,expirydate,                        
	   PQty=SUM(Case When Sell_buy = 1 Then TradeQty Else 0 End),                        
	   SQty=SUM(Case When Sell_buy = 2 Then TradeQty Else 0 End),                        
	   PRate=(Case When SUM(Case When Sell_buy = 1 Then TradeQty Else 0 End) > 0                      
	          Then SUM(Case When Sell_buy = 1 Then TradeQty*Price Else 0 End) /                      
	        SUM(Case When Sell_buy = 1 Then TradeQty Else 0 End)                      
	          Else 0 End),                        
	   SRate=(Case When SUM(Case When Sell_buy = 2 Then TradeQty Else 0 End) > 0                      
	          Then SUM(Case When Sell_buy = 2 Then TradeQty*Price Else 0 End) /                      
	        SUM(Case When Sell_buy = 2 Then TradeQty Else 0 End)                      
	          Else 0 End),                        
	   SDate=Left(Convert(Varchar,sauda_date,109),11),option_type,strike_price,AuctionPart                      
	   FROM #FOREMBROK                      
	   GROUP BY RemCode,inst_type,symbol,expirydate,Left(Convert(Varchar,sauda_date,109),11),option_type,strike_price,AuctionPart                      
	       ) S                      
	WHERE                      
	 #FOREMBROK.RemCode = S.RemCode and                       
	 #FOREMBROK.SchemeID > 0 and                        
  	 #FOREMBROK.SchemeID  = R.SchemeID and
	 #FOREMBROK.SchemeOrSlab = 'SCHEME' and
	 #FOREMBROK.AuctionPart = S.AuctionPart and                        
	 #FOREMBROK.inst_type=S.inst_type and                       
	 #FOREMBROK.symbol=S.symbol and                        
	 #FOREMBROK.expirydate=S.expirydate  AND                        
	 #FOREMBROK.strike_price = s.strike_price and                                        
	 #FOREMBROK.option_type = s.option_type and                      
	 --#FOREMBROK.sauda_date between From_Date and To_Date and                       
	 --R.RECTYPE = 'FUTURES' And                       
	 #FOREMBROK.sauda_date like S.sdate + '%' AND                        
	 Broktable.Table_no = (                       
	    CASE                       
	        WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = ''                      
	        THEN FutTableNo                      
	        WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = 'EA'                      
	        THEN FutFinalTableNo                       
	        WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart <> 'EA'                      
	      THEN OptTableNo                      
	        WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart = 'EA'                      
	 THEN OptExTableNo                      
	    END                       
	    )                       
	    AND Broktable.Line_no = (                       
	    CASE                
	        WHEN BrokScheme  = 1                      
	        THEN                       
	        (                       
	        SELECT                       
	            Min(Broktable.line_no)                       
	 FROM #BROKTABLE_FO Broktable                       
	        WHERE Broktable.Table_no =(                       
	            CASE                       
	                WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = ''                      
	 THEN FutTableNo                      
	         WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = 'EA'                      
	         THEN FutFinalTableNo                       
	         WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart <> 'EA'                      
	         THEN OptTableNo                      
	         WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart = 'EA'                      
	  THEN OptExTableNo         
	            END                       
	            )                       
	            AND Trd_Del = (                       
	            CASE                       
	                WHEN ((s.Pqty >= s.Sqty)                       
	                AND #FOREMBROK.Settflag in (1,2,3,4,5))                       
	                THEN (                  
	                CASE                       
	                    WHEN ( #FOREMBROK.Sell_Buy = 1 )                       
	                    THEN 'F'                       
	                    ELSE 'S'                       
	                END                       
	                )                       
	                WHEN #FOREMBROK.Settflag in(6,7)                       
	                THEN 'S'                       
	                WHEN #FOREMBROK.Settflag in(8,9)                       
	                THEN 'F'                       
	                WHEN ((s.Pqty < s.Sqty)                       
	                AND #FOREMBROK.Settflag in (1,2,3,4,5))                       
	                THEN (                       
	       CASE                       
	                    WHEN ( #FOREMBROK.Sell_Buy = 2 )                       
	                    THEN 'F'                       
	                    ELSE 'S'                       
	                END                       
	                )                       
	                WHEN #FOREMBROK.Settflag in(6,7)                       
	                THEN 'S'                       
	                WHEN #FOREMBROK.Settflag in(8,9)                       
	                THEN 'F'                       
	                WHEN #FOREMBROK.settflag = 0                       
	                THEN 'F'                       
	            END                       
	            )                       
	            AND #FOREMBROK.RemCode = s.RemCode                       
	            AND MPrice <= Broktable.upper_lim                       
	     )                       
	        WHEN BrokScheme = 3                  
	        THEN                       
	        (                       
	        SELECT                       
	            min(Broktable.line_no)                       
	        FROM #BROKTABLE_FO broktable                       
	        WHERE Broktable.table_no = (                       
	            CASE    WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = ''                      
	  THEN FutTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = 'EA'                      
	  THEN FutFinalTableNo                       
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart <> 'EA'                      
	  THEN OptTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart = 'EA'                      
	  THEN OptExTableNo                      
	            END                       
	            )                       
	            AND Trd_Del = (               
	            CASE                       
	                WHEN ((s.Pqty > s.Sqty)                       
	                AND #FOREMBROK.Settflag in (1,2,3,4,5))                       
	                THEN (                       
	                CASE                       
	                    WHEN ( #FOREMBROK.Sell_Buy = 1 )                       
	                    THEN 'F'                       
	                    ELSE 'S'                       
	                END                       
	                )                       
	                WHEN #FOREMBROK.Settflag in(6,7)                       
	                THEN 'S'                       
	                WHEN #FOREMBROK.Settflag in(8,9)                       
	                THEN 'F'                       
	                WHEN ((s.Pqty <= s.Sqty)                       
	                AND #FOREMBROK.Settflag in (1,2,3,4,5))                       
	                THEN (                       
	                CASE                       
	   WHEN ( #FOREMBROK.Sell_Buy = 2 )                       
	                    THEN 'F'                       
	                    ELSE 'S'       
	                END                       
	                )                       
	                WHEN #FOREMBROK.Settflag in(6,7)                       
	                THEN 'S'                       
	                WHEN #FOREMBROK.Settflag in(8,9)                       
	                THEN 'F'                       
	                WHEN #FOREMBROK.settflag = 0                       
	                THEN 'F'                       
	         END                       
	            )                       
	            AND #FOREMBROK.RemCode = s.RemCode                       
	            AND MPrice <= Broktable.upper_lim                       
	        )                       
	        WHEN BrokScheme = 2                      
	        THEN                       
	        (                       
	        SELECT                       
	            min(Broktable.line_no)                       
	        FROM #BROKTABLE_FO broktable                       
	        WHERE Broktable.table_no = (                       
	            CASE                       
	  WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = ''                      
	  THEN FutTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = 'EA'                      
	  THEN FutFinalTableNo                       
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart <> 'EA'                      
	  THEN OptTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart = 'EA'                      
	  THEN OptExTableNo                      
	            END                       
	            )                       
	            AND Trd_Del = (Case When S.Pqty = S.Sqty                       
	       Then (Case When S.Prate >= S.Srate                       
	                  Then (Case When #FOREMBROK.Sell_Buy = 1                      
	                             Then 'F'                       
	    Else 'S'                      
	                 End )                      
	           Else                      
	                              (Case When ( #FOREMBROK.Sell_Buy = 2 )                       
	                                      Then 'F'                      
	                             Else 'S'                      
	                        End )                           
	                   End)                      
	                            Else (Case When S.Pqty >= S.Sqty                       
	                                              Then (Case When ( #FOREMBROK.Sell_Buy = 1 )                       
	                                                         Then 'F'                        
	                                                         Else 'S'                      
	                                                    End )                      
	                                              Else                      
	                                                   (Case When ( #FOREMBROK.Sell_Buy = 2 )                       
	       Then 'F'                        
	                                          Else 'S'                      
	                                                    End )                           
	                  End )                      
	                 End )                       
	            AND #FOREMBROK.RemCode = S.RemCode                       
	            AND MPrice <= Broktable.upper_lim                       
	        )                       
	        ELSE                       
	        (                       
	        SELECT                       
	            min(line_no)                       
	        FROM #BROKTABLE_FO broktable                       
	        WHERE MPrice <= Broktable.upper_lim                       
	            AND broktable.table_no = (                       
	            CASE                       
	  WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = ''                      
	  THEN FutTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = 'EA'                      
	  THEN FutFinalTableNo                       
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart <> 'EA'                      
	  THEN OptTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart = 'EA'                   
	  THEN OptExTableNo                      
	            END                       
	            )                       
	        )                       
	    END                       
	    )                        
	------ End of Remisier Brokerage For FOTrades Updation
	              
	SELECT PARTY_CODE,INST_TYPE,SYMBOL,EXPIRYDATE,STRIKE_PRICE,OPTION_TYPE,AUCTIONPART,              
	SAUDA_DATE,TRADE_NO=Pradnya.DBO.ReplaceTradeNo(Trade_No),ORDER_NO,              
	SELL_BUY,TRADEQTY=Sum(TRADEQTY),PRICE,Brokerage=Sum(Brokerage),              
	REMCODE,BRANCH_CD,REM_Brokerage=Sum(REM_BROKAPPLIED*TradeQty),              
	REM_NBROKAPP=0,Status,SLABTYPE,FROMDATE,              
	TODATE,MPrice,Multiplier,REMPARTYCD,EXCHANGEID, SCHEMEID, SCHEMEORSLAB, REMTYPE              
	INTO #FOREMBROK_1 From #FOREMBROK              
	GROUP BY PARTY_CODE,INST_TYPE,SYMBOL,EXPIRYDATE,STRIKE_PRICE,OPTION_TYPE,AUCTIONPART,              
	SAUDA_DATE,Pradnya.DBO.ReplaceTradeNo(Trade_No),ORDER_NO,              
	SELL_BUY,PRICE,REMCODE,BRANCH_CD,Status,SLABTYPE,FROMDATE,              
	TODATE,MPrice,Multiplier,REMPARTYCD,EXCHANGEID, SCHEMEID, SCHEMEORSLAB, REMTYPE                

   ---------- Update NSEFO Brokerage From  NSEFO.DBO.CHARGES_DETAIL Table	              
	UPDATE                 
	 #FOREMBROK_1                
	SET                
	 Brokerage = (Case When Sell_Buy =1 then CD_Tot_BuyBrok Else CD_Tot_SellBrok End)              
	FROM                
	 NSEFO.DBO.CHARGES_DETAIL                
	WHERE                
	 Convert(Varchar,CD_Sauda_Date,103) = Convert(Varchar,Sauda_Date,103)                
	 And CD_Party_Code = #FOREMBROK_1.Party_Code                 
	 And CD_Inst_Type = Inst_Type              
	 And CD_Symbol = Symbol                
	 And Convert(Varchar,CD_Expiry_Date,106) = Convert(Varchar,ExpiryDate,106)                
	 And CD_Option_Type = Option_Type                
	 And CD_Strike_Price = Strike_Price                
	 And CD_Trade_No = Trade_No                
	 And CD_Order_No = Order_No               


	--- Data From NCDX.FOSETTLEMENT	                      
	SELECT S.PARTY_CODE, INST_TYPE, SYMBOL, EXPIRYDATE, STRIKE_PRICE, OPTION_TYPE, AUCTIONPART, SETTFLAG,                        
		SAUDA_DATE, TRADE_NO, ORDER_NO, SELL_BUY,                 
		TRADEQTY, PRICE, BROKERAGE=BROKAPPLIED*TRADEQTY,                       
      --REMCODE = SUB_BROKER,
      REMCODE = C2.DUMMY10,            
		BRANCH_CD,                       
		REM_BROKAPPLIED=CONVERT(NUMERIC(18,4),0), REM_NBROKAPP=CONVERT(NUMERIC(18,4),0), Status = '0',                      
		SLABTYPE=CONVERT(VARCHAR(10),''),                      
		FROMDATE = CONVERT(DATETIME,@FromDate),                       
		TODATE = CONVERT(DATETIME,@ToDate + ' 23:59:59'),                      
		MPRICE = STRIKE_PRICE+PRICE,                      
		MULTIPLIER = 1,                      
		REMPARTYCD = CONVERT(VARCHAR(10),''),                   
		EXCHANGEID = 'NCDX',  
		SCHEMEID = CONVERT(INT, 0),
		SCHEMEORSLAB = CONVERT(VARCHAR(7),''),		-- SCHEME/SLAB
		REMTYPE = CONVERT(VARCHAR(3),''),				-- SUB/BR
		BOOKTYPE,
		INSTRUMENT
		-- BROKTYPE = CONVERT(VARCHAR(10),'') 	      -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT                     
	INTO #NCDXREMBROK                      
	FROM NCDX.DBO.CLIENT1 C1, NCDX.DBO.CLIENT2 C2, NCDX.DBO.FOSETTLEMENT S, #PARTYLIST P                      
	WHERE 
		S.SAUDA_DATE >= @FromDate                      
	 	AND S.SAUDA_DATE <= @ToDate + ' 23:59'                      
		AND C1.CL_CODE = C2.CL_CODE                      
		AND C2.PARTY_CODE = S.PARTY_CODE                      
		AND AUCTIONPART <> 'CA'                      
  	   AND PRICE > 0    
		AND S.PARTY_CODE = P.PARTYCODE  

	--- Update SchemeID For All Party (For COMMODITY & SUB BROKER Only)
	UPDATE #NCDXREMBROK SET
		 SLABTYPE = R.BrokType, -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT
		 SCHEMEID = R.SchemeID,
		 SCHEMEORSLAB = R.SchemeOrSlab, -- SCHEME/SLAB
		 REMTYPE =	R.RemType, -- SUB/BR
		 REMPARTYCD = R.RemPartyCd
	FROM #NCDXREMBROK A, #RemisierAllParty R
	WHERE
		A.PARTY_CODE = R.PARTYCODE AND
		A.SAUDA_DATE BETWEEN R.FROMDATE AND R.TODATE AND
		(R.Segment = 'COMMODITY' OR R.Segment = 'ALL') AND
		EXCHANGEID = CASE WHEN R.EXCHANGE IN ('NCDX','ALL') THEN EXCHANGEID ELSE R.EXCHANGE END
		AND R.REMTYPE = 'SUB'

	--- Overright SchemeID For Specific Party (For COMMODITY MARKET & SUB BROKER Only)
	UPDATE #NCDXREMBROK SET
		 SLABTYPE = R.BrokType, -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT
		 SCHEMEID = R.SchemeID,
		 SCHEMEORSLAB = R.SchemeOrSlab, -- SCHEME/SLAB
		 REMTYPE =	R.RemType, -- SUB/BR
		 REMPARTYCD = R.RemPartyCd
	FROM #NCDXREMBROK A, #RemisierSpecificParty R
	WHERE
		A.PARTY_CODE = R.PARTYCODE AND
		A.SAUDA_DATE BETWEEN R.FROMDATE AND R.TODATE AND
		(R.Segment = 'COMMODITY' OR R.Segment = 'ALL') AND
		EXCHANGEID = CASE WHEN R.EXCHANGE IN ('NCDX','ALL') THEN EXCHANGEID ELSE R.EXCHANGE END
		AND R.REMTYPE = 'SUB'

	--- If any party is excluded for the SUB brokerage sharing then the same Party should be excluded for BR sharing also.	
	DELETE FROM #NCDXREMBROK 
		WHERE Party_Code IN ( SELECT PartyCode FROM #RemisierBlockedParty 
										  WHERE @FromDate >= FromDate AND @ToDate <= ToDate AND SubBrokerOrBranch = 'SUB')


	---- Update Remisier Brokerage NCDX Trades	                      
	Update #NCDXREMBROK set                         
	 REM_BROKAPPLIED =                      
	  (((case when ( #NCDXREMBROK.SettFlag = 1 and broktable.val_perc ='V' and #NCDXREMBROK.sell_buy = 1)                        
	  Then ((floor(( broktable.Normal*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ))/power(10,broktable.round_to))                        
	  when ( #NCDXREMBROK.SettFlag = 1 and broktable.val_perc ='V' and #NCDXREMBROK.sell_buy = 2)                
	  Then ((floor(( broktable.Normal*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ))/power(10,broktable.round_to))                        
	  when ( #NCDXREMBROK.SettFlag = 1 and broktable.val_perc ='P' and #NCDXREMBROK.sell_buy = 1)                        
	  Then ((floor((((broktable.Normal*MultiPlier /100 ) * MPrice)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))                        
	  when ( #NCDXREMBROK.SettFlag = 1 and broktable.val_perc ='P' and #NCDXREMBROK.sell_buy = 2)                        
	  Then                         
	   ((floor(( ((broktable.Normal*MultiPlier /100 )* MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when (#NCDXREMBROK.SettFlag = 2  and broktable.val_perc ='V' )       Then                         
	   ((floor(( ((Broktable.Day_puc*MultiPlier))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when (#NCDXREMBROK.SettFlag = 2  and broktable.val_perc ='P' )                         
	  Then                         
	   ((floor(( ((Broktable.Day_puc*MultiPlier/100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when (#NCDXREMBROK.SettFlag = 3  and broktable.val_perc ='V' )                        
	  Then                         
	   ((floor(( Broktable.day_sales*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when (#NCDXREMBROK.SettFlag = 3  and broktable.val_perc ='P' )                        
	  Then                       
	   ((floor(( ((Broktable.day_sales*MultiPlier/ 100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when ( #NCDXREMBROK.SettFlag = 4  and broktable.val_perc ='V' )                        
	  Then                         
	   ((floor(( Broktable.Sett_purch*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when ( #NCDXREMBROK.SettFlag = 4  and broktable.val_perc ='P' )                        
	  Then                         
	   ((floor(( ((Broktable.Sett_purch*MultiPlier/100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when ( #NCDXREMBROK.SettFlag = 5  and broktable.val_perc ='V' )                        
	  Then                         
	   ((floor(( Broktable.Sett_sales*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when ( #NCDXREMBROK.SettFlag = 5  and broktable.val_perc ='P' )                        
	  Then                         
	   ((floor(( ((Broktable.Sett_sales*MultiPlier/100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	        when (#NCDXREMBROK.SettFlag = 8  and broktable.val_perc ='V' )                       
	                                    Then                       
	          ((floor(( ((MultiPlier*broktable.Sett_purch))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	                              when (#NCDXREMBROK.SettFlag = 8  and broktable.val_perc ='P' )                       
	                                     Then                       
	          ((floor(( ((MultiPlier*Broktable.Sett_purch/100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	                          
	        when (#NCDXREMBROK.SettFlag = 9  and broktable.val_perc ='V' )                      
	                                     Then                       
	          ((floor(( MultiPlier*Broktable.Sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	                          when (#NCDXREMBROK.SettFlag = 9  and broktable.val_perc ='P' )                      
	                                     Then                       
	          ((floor(( ((MultiPlier*Broktable.Sett_sales/ 100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                 
	                        when ( #NCDXREMBROK.SettFlag = 6  and broktable.val_perc ='V' )                      
	                                     Then                       
	          ((floor((MultiPlier* Broktable.Sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	     power(10,broktable.round_to))                      
	                                 when ( #NCDXREMBROK.SettFlag = 6  and broktable.val_perc ='P' )                      
	                                Then                       
	 ((floor(( ((MultiPlier*Broktable.Sett_purch/100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	                     when ( #NCDXREMBROK.SettFlag = 7  and broktable.val_perc ='V' )                      
	                                     Then                       
	          ((floor((MultiPlier* Broktable.Sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	                     when ( #NCDXREMBROK.SettFlag = 7  and broktable.val_perc ='P' )                      
	                                     Then                       
	          ((floor(( ((MultiPlier*Broktable.Sett_sales/100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	  Else  0                         
	  End                         
	 )))                    
	FROM                       
	 #BROKTABLE_NCDX BrokTable,                      
	 #NCDXREMBROK,                      
	 RemisierBrokerageScheme R,	
    ( SELECT RemCode,inst_type,symbol,expirydate,                        
	   PQty=SUM(Case When Sell_buy = 1 Then TradeQty Else 0 End),                        
	   SQty=SUM(Case When Sell_buy = 2 Then TradeQty Else 0 End),                        
	   PRate=(Case When SUM(Case When Sell_buy = 1 Then TradeQty Else 0 End) > 0                      
	          Then SUM(Case When Sell_buy = 1 Then TradeQty*Price Else 0 End) /                      
	        SUM(Case When Sell_buy = 1 Then TradeQty Else 0 End)                      
	          Else 0 End),                        
	   SRate=(Case When SUM(Case When Sell_buy = 2 Then TradeQty Else 0 End) > 0                      
	          Then SUM(Case When Sell_buy = 2 Then TradeQty*Price Else 0 End) /                      
	        SUM(Case When Sell_buy = 2 Then TradeQty Else 0 End)                      
	          Else 0 End),                        
	   SDate=Left(Convert(Varchar,sauda_date,109),11),option_type,strike_price,AuctionPart                      
	   FROM #NCDXREMBROK                      
	   GROUP BY RemCode,inst_type,symbol,expirydate,Left(Convert(Varchar,sauda_date,109),11),option_type,strike_price,AuctionPart                      
	       ) S                      
	WHERE                      
	 #NCDXREMBROK.RemCode = S.RemCode and                       
	 #NCDXREMBROK.SchemeID > 0 and                        
  	 #NCDXREMBROK.SchemeID  = R.SchemeID and
	 #NCDXREMBROK.SchemeOrSlab = 'SCHEME' and
	 #NCDXREMBROK.AuctionPart = S.AuctionPart and                        
	 #NCDXREMBROK.inst_type=S.inst_type and                       
	 #NCDXREMBROK.symbol=S.symbol and                        
	 #NCDXREMBROK.expirydate=S.expirydate  AND                        
	 #NCDXREMBROK.strike_price = s.strike_price and                                        
	 #NCDXREMBROK.option_type = s.option_type and                      
	 --#NCDXREMBROK.sauda_date between From_Date and To_Date and                       
	 --R.RECTYPE = 'FUTURES' And                       
	 #NCDXREMBROK.sauda_date like S.sdate + '%' AND                        
	 Broktable.Table_no = (                       
	    CASE                       
	        WHEN Left(S.Inst_Type,3) = 'FUT' And #NCDXREMBROK.AuctionPart = ''                      
	        THEN FutTableNo                      
	        WHEN Left(S.Inst_Type,3) = 'FUT' And #NCDXREMBROK.AuctionPart = 'EA'                      
	        THEN FutFinalTableNo                       
	        WHEN Left(S.Inst_Type,3) = 'OPT' And #NCDXREMBROK.AuctionPart <> 'EA'                      
	      THEN OptTableNo                      
	        WHEN Left(S.Inst_Type,3) = 'OPT' And #NCDXREMBROK.AuctionPart = 'EA'                      
	 THEN OptExTableNo                      
	    END                       
	    )                       
	    AND Broktable.Line_no = (                       
	    CASE                
	        WHEN BrokScheme  = 1                      
	        THEN                       
	        (                       
	        SELECT                       
	            Min(Broktable.line_no)                       
	 FROM #BROKTABLE_NCDX Broktable                       
	        WHERE Broktable.Table_no =(                       
	            CASE                       
	                WHEN Left(S.Inst_Type,3) = 'FUT' And #NCDXREMBROK.AuctionPart = ''                      
	 THEN FutTableNo                      
	         WHEN Left(S.Inst_Type,3) = 'FUT' And #NCDXREMBROK.AuctionPart = 'EA'                      
	         THEN FutFinalTableNo                       
	         WHEN Left(S.Inst_Type,3) = 'OPT' And #NCDXREMBROK.AuctionPart <> 'EA'                      
	         THEN OptTableNo                      
	         WHEN Left(S.Inst_Type,3) = 'OPT' And #NCDXREMBROK.AuctionPart = 'EA'                      
	  THEN OptExTableNo         
	            END                       
	            )                       
	            AND Trd_Del = (                       
	            CASE                       
	                WHEN ((s.Pqty >= s.Sqty)                       
	                AND #NCDXREMBROK.Settflag in (1,2,3,4,5))                       
	                THEN (                  
	                CASE                       
	                    WHEN ( #NCDXREMBROK.Sell_Buy = 1 )                       
	                    THEN 'F'                       
	                    ELSE 'S'                       
	                END                       
	                )                       
	                WHEN #NCDXREMBROK.Settflag in(6,7)                       
	                THEN 'S'                       
	                WHEN #NCDXREMBROK.Settflag in(8,9)                       
	                THEN 'F'                       
	                WHEN ((s.Pqty < s.Sqty)                       
	                AND #NCDXREMBROK.Settflag in (1,2,3,4,5))                       
	                THEN (                       
	       CASE                       
	                    WHEN ( #NCDXREMBROK.Sell_Buy = 2 )                       
	                    THEN 'F'                       
	                    ELSE 'S'                       
	                END                       
	                )                       
	                WHEN #NCDXREMBROK.Settflag in(6,7)                       
	                THEN 'S'                       
	                WHEN #NCDXREMBROK.Settflag in(8,9)                       
	                THEN 'F'                       
	                WHEN #NCDXREMBROK.settflag = 0                       
	                THEN 'F'                       
	            END                       
	            )                       
	            AND #NCDXREMBROK.RemCode = s.RemCode                       
	            AND MPrice <= Broktable.upper_lim                       
	     )                       
	        WHEN BrokScheme = 3                  
	        THEN                       
	        (                       
	        SELECT                       
	            min(Broktable.line_no)                       
	        FROM #BROKTABLE_NCDX broktable                       
	        WHERE Broktable.table_no = (                       
	            CASE    WHEN Left(S.Inst_Type,3) = 'FUT' And #NCDXREMBROK.AuctionPart = ''                      
	  THEN FutTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'FUT' And #NCDXREMBROK.AuctionPart = 'EA'                      
	  THEN FutFinalTableNo                       
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #NCDXREMBROK.AuctionPart <> 'EA'                      
	  THEN OptTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #NCDXREMBROK.AuctionPart = 'EA'                      
	  THEN OptExTableNo                      
	            END                       
	            )                       
	            AND Trd_Del = (               
	            CASE                       
	                WHEN ((s.Pqty > s.Sqty)                       
	                AND #NCDXREMBROK.Settflag in (1,2,3,4,5))                       
	                THEN (                       
	                CASE                       
	                    WHEN ( #NCDXREMBROK.Sell_Buy = 1 )                       
	                    THEN 'F'                       
	                    ELSE 'S'                       
	                END                       
	                )                       
	                WHEN #NCDXREMBROK.Settflag in(6,7)                       
	                THEN 'S'                       
	                WHEN #NCDXREMBROK.Settflag in(8,9)                       
	                THEN 'F'                       
	                WHEN ((s.Pqty <= s.Sqty)                       
	                AND #NCDXREMBROK.Settflag in (1,2,3,4,5))                       
	                THEN (                       
	                CASE                       
	   WHEN ( #NCDXREMBROK.Sell_Buy = 2 )                       
	                    THEN 'F'                       
	                    ELSE 'S'       
	                END                       
	                )                       
	                WHEN #NCDXREMBROK.Settflag in(6,7)                       
	                THEN 'S'                       
	                WHEN #NCDXREMBROK.Settflag in(8,9)                       
	                THEN 'F'                       
	                WHEN #NCDXREMBROK.settflag = 0                       
	                THEN 'F'                       
	         END                       
	            )                       
	            AND #NCDXREMBROK.RemCode = s.RemCode                       
	            AND MPrice <= Broktable.upper_lim                       
	        )                       
	        WHEN BrokScheme = 2                      
	        THEN                       
	        (                       
	        SELECT                       
	            min(Broktable.line_no)                       
	        FROM #BROKTABLE_NCDX broktable                       
	        WHERE Broktable.table_no = (                       
	            CASE                       
	  WHEN Left(S.Inst_Type,3) = 'FUT' And #NCDXREMBROK.AuctionPart = ''                      
	  THEN FutTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'FUT' And #NCDXREMBROK.AuctionPart = 'EA'                      
	  THEN FutFinalTableNo                       
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #NCDXREMBROK.AuctionPart <> 'EA'                      
	  THEN OptTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #NCDXREMBROK.AuctionPart = 'EA'                      
	  THEN OptExTableNo                      
	            END                       
	            )                       
	            AND Trd_Del = (Case When S.Pqty = S.Sqty                       
	       Then (Case When S.Prate >= S.Srate                       
	                  Then (Case When #NCDXREMBROK.Sell_Buy = 1                      
	                             Then 'F'                       
	    Else 'S'                      
	                 End )                      
	           Else                      
	                              (Case When ( #NCDXREMBROK.Sell_Buy = 2 )                       
	                                      Then 'F'                      
	                             Else 'S'                      
	                        End )                           
	                   End)                      
	                            Else (Case When S.Pqty >= S.Sqty                       
	                                              Then (Case When ( #NCDXREMBROK.Sell_Buy = 1 )                       
	                                                         Then 'F'                        
	                                                         Else 'S'                      
	                                                    End )                      
	                                              Else                      
	                                                   (Case When ( #NCDXREMBROK.Sell_Buy = 2 )                       
	       Then 'F'                        
	                                          Else 'S'                      
	                                                    End )                           
	                  End )                      
	                 End )                       
	            AND #NCDXREMBROK.RemCode = S.RemCode                       
	            AND MPrice <= Broktable.upper_lim                       
	        )                       
	        ELSE                       
	        (                       
	        SELECT                       
	            min(line_no)                       
	        FROM #BROKTABLE_NCDX broktable                       
	        WHERE MPrice <= Broktable.upper_lim                       
	            AND broktable.table_no = (                       
	            CASE                       
	  WHEN Left(S.Inst_Type,3) = 'FUT' And #NCDXREMBROK.AuctionPart = ''                      
	  THEN FutTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'FUT' And #NCDXREMBROK.AuctionPart = 'EA'                      
	  THEN FutFinalTableNo                       
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #NCDXREMBROK.AuctionPart <> 'EA'                      
	  THEN OptTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #NCDXREMBROK.AuctionPart = 'EA'                   
	  THEN OptExTableNo                      
	            END                       
	            )                       
	        )                       
	    END                       
	    )                        
	------ End of Remisier Brokerage For FOTrades Updation

	SELECT PARTY_CODE,INST_TYPE,SYMBOL,EXPIRYDATE,STRIKE_PRICE,OPTION_TYPE,AUCTIONPART,              
	SAUDA_DATE,TRADE_NO=Pradnya.DBO.ReplaceTradeNo(Trade_No),ORDER_NO,              
	SELL_BUY,TRADEQTY=Sum(TRADEQTY),PRICE,Brokerage=Sum(Brokerage*(BookType/Instrument)),              
   REMCODE,	BRANCH_CD,                       
	REM_Brokerage=Sum(REM_BROKAPPLIED*TradeQty*(BookType/Instrument)),              
	REM_NBROKAPP=0,Status,SLABTYPE,FROMDATE,              
	TODATE,MPrice,Multiplier,REMPARTYCD,EXCHANGEID, SCHEMEID, SCHEMEORSLAB, REMTYPE              
	INTO #NCDXREMBROK_1 From #NCDXREMBROK              
	GROUP BY PARTY_CODE,INST_TYPE,SYMBOL,EXPIRYDATE,STRIKE_PRICE,OPTION_TYPE,AUCTIONPART,              
	SAUDA_DATE,Pradnya.DBO.ReplaceTradeNo(Trade_No),ORDER_NO,              
	SELL_BUY,PRICE,REMCODE,BRANCH_CD,Status,SLABTYPE,FROMDATE,              
	TODATE,MPrice,Multiplier,REMPARTYCD,EXCHANGEID, SCHEMEID, SCHEMEORSLAB, REMTYPE                

   ---------- Update NCDX Brokerage From  NCDX.DBO.CHARGES_DETAIL Table	              
	UPDATE                 
	 #NCDXREMBROK_1                
	SET                
	 Brokerage = (Case When Sell_Buy =1 then CD_Tot_BuyBrok Else CD_Tot_SellBrok End)              
	FROM                
	 NCDX.DBO.CHARGES_DETAIL                
	WHERE                
	 Convert(Varchar,CD_Sauda_Date,103) = Convert(Varchar,Sauda_Date,103)                
	 And CD_Party_Code = #NCDXREMBROK_1.Party_Code                 
	 And CD_Inst_Type = Inst_Type              
	 And CD_Symbol = Symbol                
	 And Convert(Varchar,CD_Expiry_Date,106) = Convert(Varchar,ExpiryDate,106)                
	 And CD_Option_Type = Option_Type                
	 And CD_Strike_Price = Strike_Price                
	 And CD_Trade_No = Trade_No                
	 And CD_Order_No = Order_No               


	--- Data From MCDX.FOSETTLEMENT	                      
	SELECT S.PARTY_CODE, INST_TYPE, SYMBOL, EXPIRYDATE, STRIKE_PRICE, OPTION_TYPE, AUCTIONPART, SETTFLAG,                        
		SAUDA_DATE, TRADE_NO, ORDER_NO, SELL_BUY,                 
		TRADEQTY, PRICE, BROKERAGE=BROKAPPLIED*TRADEQTY,                       
		--REMCODE = SUB_BROKER, 
		REMCODE = C2.DUMMY10,
		BRANCH_CD,                       
		REM_BROKAPPLIED=CONVERT(NUMERIC(18,4),0), REM_NBROKAPP=CONVERT(NUMERIC(18,4),0), Status = '0',                      
		SLABTYPE=CONVERT(VARCHAR(10),''),                      
		FROMDATE = CONVERT(DATETIME,@FromDate),                       
		TODATE = CONVERT(DATETIME,@ToDate + ' 23:59:59'),                      
		MPRICE = STRIKE_PRICE+PRICE,                      
		MULTIPLIER = 1,                      
		REMPARTYCD = CONVERT(VARCHAR(10),''),                   
		EXCHANGEID = 'MCDX',  
		SCHEMEID = CONVERT(INT, 0),
		SCHEMEORSLAB = CONVERT(VARCHAR(7),''),		-- SCHEME/SLAB
		REMTYPE = CONVERT(VARCHAR(3),''),				-- SUB/BR
		BOOKTYPE,
		INSTRUMENT
		-- BROKTYPE = CONVERT(VARCHAR(10),'') 	      -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT                     
	INTO #MCDXREMBROK                      
	FROM MCDX.DBO.CLIENT1 C1, MCDX.DBO.CLIENT2 C2, MCDX.DBO.FOSETTLEMENT S, #PARTYLIST P                      
	WHERE 
		S.SAUDA_DATE >= @FromDate                      
	 	AND S.SAUDA_DATE <= @ToDate + ' 23:59'                      
		AND C1.CL_CODE = C2.CL_CODE                      
		AND C2.PARTY_CODE = S.PARTY_CODE                      
		AND AUCTIONPART <> 'CA'                      
  	   AND PRICE > 0    
		AND S.PARTY_CODE = P.PARTYCODE  

	--- Update SchemeID For All Party (For COMMODITY & SUB BROKER Only)
	UPDATE #MCDXREMBROK SET
		 SLABTYPE = R.BrokType, -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT
		 SCHEMEID = R.SchemeID,
		 SCHEMEORSLAB = R.SchemeOrSlab, -- SCHEME/SLAB
		 REMTYPE =	R.RemType, -- SUB/BR
		 REMPARTYCD = R.RemPartyCd
	FROM #MCDXREMBROK A, #RemisierAllParty R
	WHERE
		A.PARTY_CODE = R.PARTYCODE AND
		A.SAUDA_DATE BETWEEN R.FROMDATE AND R.TODATE AND
		(R.Segment = 'COMMODITY' OR R.Segment = 'ALL') AND
		EXCHANGEID = CASE WHEN R.EXCHANGE IN ('MCDX','ALL') THEN EXCHANGEID ELSE R.EXCHANGE END
		AND R.REMTYPE = 'SUB'

	--- Overright SchemeID For Specific Party (For COMMODITY MARKET & SUB BROKER Only)
	UPDATE #MCDXREMBROK SET
		 SLABTYPE = R.BrokType, -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT
		 SCHEMEID = R.SchemeID,
		 SCHEMEORSLAB = R.SchemeOrSlab, -- SCHEME/SLAB
		 REMTYPE =	R.RemType, -- SUB/BR
		 REMPARTYCD = R.RemPartyCd
	FROM #MCDXREMBROK A, #RemisierSpecificParty R
	WHERE
		A.PARTY_CODE = R.PARTYCODE AND
		A.SAUDA_DATE BETWEEN R.FROMDATE AND R.TODATE AND
		(R.Segment = 'COMMODITY' OR R.Segment = 'ALL') AND
		EXCHANGEID = CASE WHEN R.EXCHANGE IN ('MCDX','ALL') THEN EXCHANGEID ELSE R.EXCHANGE END
		AND R.REMTYPE = 'SUB'

	--- If any party is excluded for the SUB brokerage sharing then the same Party should be excluded for BR sharing also.	
	DELETE FROM #MCDXREMBROK 
		WHERE Party_Code IN ( SELECT PartyCode FROM #RemisierBlockedParty 
										  WHERE @FromDate >= FromDate AND @ToDate <= ToDate AND SubBrokerOrBranch = 'SUB')

	---- Update Remisier Brokerage MCDX Trades	                      
	Update #MCDXREMBROK set                         
	 REM_BROKAPPLIED =                      
	  (((case when ( #MCDXREMBROK.SettFlag = 1 and broktable.val_perc ='V' and #MCDXREMBROK.sell_buy = 1)                        
	  Then ((floor(( broktable.Normal*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ))/power(10,broktable.round_to))                        
	  when ( #MCDXREMBROK.SettFlag = 1 and broktable.val_perc ='V' and #MCDXREMBROK.sell_buy = 2)                
	  Then ((floor(( broktable.Normal*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ))/power(10,broktable.round_to))                        
	  when ( #MCDXREMBROK.SettFlag = 1 and broktable.val_perc ='P' and #MCDXREMBROK.sell_buy = 1)                        
	  Then ((floor((((broktable.Normal*MultiPlier /100 ) * MPrice)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))                        
	  when ( #MCDXREMBROK.SettFlag = 1 and broktable.val_perc ='P' and #MCDXREMBROK.sell_buy = 2)                        
	  Then                         
	   ((floor(( ((broktable.Normal*MultiPlier /100 )* MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when (#MCDXREMBROK.SettFlag = 2  and broktable.val_perc ='V' )       Then                         
	   ((floor(( ((Broktable.Day_puc*MultiPlier))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when (#MCDXREMBROK.SettFlag = 2  and broktable.val_perc ='P' )                         
	  Then                         
	   ((floor(( ((Broktable.Day_puc*MultiPlier/100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when (#MCDXREMBROK.SettFlag = 3  and broktable.val_perc ='V' )                        
	  Then                         
	   ((floor(( Broktable.day_sales*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when (#MCDXREMBROK.SettFlag = 3  and broktable.val_perc ='P' )                        
	  Then                       
	   ((floor(( ((Broktable.day_sales*MultiPlier/ 100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when ( #MCDXREMBROK.SettFlag = 4  and broktable.val_perc ='V' )                        
	  Then                         
	   ((floor(( Broktable.Sett_purch*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when ( #MCDXREMBROK.SettFlag = 4  and broktable.val_perc ='P' )                        
	  Then                         
	   ((floor(( ((Broktable.Sett_purch*MultiPlier/100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when ( #MCDXREMBROK.SettFlag = 5  and broktable.val_perc ='V' )                        
	  Then                         
	   ((floor(( Broktable.Sett_sales*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	  when ( #MCDXREMBROK.SettFlag = 5  and broktable.val_perc ='P' )                        
	  Then                         
	   ((floor(( ((Broktable.Sett_sales*MultiPlier/100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
	   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
	   power(10,broktable.round_to))                        
	        when (#MCDXREMBROK.SettFlag = 8  and broktable.val_perc ='V' )                       
	                                    Then                       
	          ((floor(( ((MultiPlier*broktable.Sett_purch))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	                              when (#MCDXREMBROK.SettFlag = 8  and broktable.val_perc ='P' )                       
	                                     Then                       
	          ((floor(( ((MultiPlier*Broktable.Sett_purch/100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	                          
	        when (#MCDXREMBROK.SettFlag = 9  and broktable.val_perc ='V' )                      
	                                     Then                       
	          ((floor(( MultiPlier*Broktable.Sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	                          when (#MCDXREMBROK.SettFlag = 9  and broktable.val_perc ='P' )                      
	                                     Then                       
	          ((floor(( ((MultiPlier*Broktable.Sett_sales/ 100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                 
	                        when ( #MCDXREMBROK.SettFlag = 6  and broktable.val_perc ='V' )                      
	                                     Then                       
	          ((floor((MultiPlier* Broktable.Sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	     power(10,broktable.round_to))                      
	                                 when ( #MCDXREMBROK.SettFlag = 6  and broktable.val_perc ='P' )                      
	                                Then                       
	 ((floor(( ((MultiPlier*Broktable.Sett_purch/100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	                     when ( #MCDXREMBROK.SettFlag = 7  and broktable.val_perc ='V' )                      
	                                     Then                       
	          ((floor((MultiPlier* Broktable.Sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	                     when ( #MCDXREMBROK.SettFlag = 7  and broktable.val_perc ='P' )                      
	                                     Then                       
	          ((floor(( ((MultiPlier*Broktable.Sett_sales/100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
	          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
	          power(10,broktable.round_to))                      
	  Else  0                         
	  End                         
	 )))                    
	FROM                       
	 #BROKTABLE_MCDX BrokTable,                      
	 #MCDXREMBROK,                      
	 RemisierBrokerageScheme R,	
    ( SELECT RemCode,inst_type,symbol,expirydate,                        
	   PQty=SUM(Case When Sell_buy = 1 Then TradeQty Else 0 End),                        
	   SQty=SUM(Case When Sell_buy = 2 Then TradeQty Else 0 End),                        
	   PRate=(Case When SUM(Case When Sell_buy = 1 Then TradeQty Else 0 End) > 0                      
	          Then SUM(Case When Sell_buy = 1 Then TradeQty*Price Else 0 End) /                      
	        SUM(Case When Sell_buy = 1 Then TradeQty Else 0 End)                      
	          Else 0 End),                        
	   SRate=(Case When SUM(Case When Sell_buy = 2 Then TradeQty Else 0 End) > 0                      
	          Then SUM(Case When Sell_buy = 2 Then TradeQty*Price Else 0 End) /                      
	        SUM(Case When Sell_buy = 2 Then TradeQty Else 0 End)                      
	          Else 0 End),                        
	   SDate=Left(Convert(Varchar,sauda_date,109),11),option_type,strike_price,AuctionPart                      
	   FROM #MCDXREMBROK                      
	   GROUP BY RemCode,inst_type,symbol,expirydate,Left(Convert(Varchar,sauda_date,109),11),option_type,strike_price,AuctionPart                      
	       ) S                      
	WHERE                      
	 #MCDXREMBROK.RemCode = S.RemCode and                       
	 #MCDXREMBROK.SchemeID > 0 and                        
  	 #MCDXREMBROK.SchemeID  = R.SchemeID and
	 #MCDXREMBROK.SchemeOrSlab = 'SCHEME' and
	 #MCDXREMBROK.AuctionPart = S.AuctionPart and                        
	 #MCDXREMBROK.inst_type=S.inst_type and                       
	 #MCDXREMBROK.symbol=S.symbol and                        
	 #MCDXREMBROK.expirydate=S.expirydate  AND                        
	 #MCDXREMBROK.strike_price = s.strike_price and                                        
	 #MCDXREMBROK.option_type = s.option_type and                      
	 --#MCDXREMBROK.sauda_date between From_Date and To_Date and                       
	 --R.RECTYPE = 'FUTURES' And                       
	 #MCDXREMBROK.sauda_date like S.sdate + '%' AND                        
	 Broktable.Table_no = (                       
	    CASE                       
	        WHEN Left(S.Inst_Type,3) = 'FUT' And #MCDXREMBROK.AuctionPart = ''                      
	        THEN FutTableNo                      
	        WHEN Left(S.Inst_Type,3) = 'FUT' And #MCDXREMBROK.AuctionPart = 'EA'                      
	        THEN FutFinalTableNo                       
	        WHEN Left(S.Inst_Type,3) = 'OPT' And #MCDXREMBROK.AuctionPart <> 'EA'                      
	      THEN OptTableNo                      
	        WHEN Left(S.Inst_Type,3) = 'OPT' And #MCDXREMBROK.AuctionPart = 'EA'                      
	 THEN OptExTableNo                      
	    END                       
	    )                       
	    AND Broktable.Line_no = (                       
	    CASE                
	        WHEN BrokScheme  = 1                      
	        THEN                       
	        (                       
	        SELECT                       
	            Min(Broktable.line_no)                       
	 FROM #BROKTABLE_MCDX Broktable                       
	        WHERE Broktable.Table_no =(                       
	            CASE                       
	                WHEN Left(S.Inst_Type,3) = 'FUT' And #MCDXREMBROK.AuctionPart = ''                      
	 THEN FutTableNo                      
	         WHEN Left(S.Inst_Type,3) = 'FUT' And #MCDXREMBROK.AuctionPart = 'EA'                      
	         THEN FutFinalTableNo                       
	         WHEN Left(S.Inst_Type,3) = 'OPT' And #MCDXREMBROK.AuctionPart <> 'EA'                      
	         THEN OptTableNo                      
	         WHEN Left(S.Inst_Type,3) = 'OPT' And #MCDXREMBROK.AuctionPart = 'EA'                      
	  THEN OptExTableNo         
	            END                       
	            )                       
	            AND Trd_Del = (                       
	            CASE                       
	                WHEN ((s.Pqty >= s.Sqty)                       
	                AND #MCDXREMBROK.Settflag in (1,2,3,4,5))                       
	                THEN (                  
	                CASE                       
	                    WHEN ( #MCDXREMBROK.Sell_Buy = 1 )                       
	                    THEN 'F'                       
	                    ELSE 'S'                       
	                END                       
	                )                       
	                WHEN #MCDXREMBROK.Settflag in(6,7)                       
	                THEN 'S'                       
	                WHEN #MCDXREMBROK.Settflag in(8,9)                       
	                THEN 'F'                       
	                WHEN ((s.Pqty < s.Sqty)                       
	                AND #MCDXREMBROK.Settflag in (1,2,3,4,5))                       
	                THEN (                       
	       CASE                       
	                    WHEN ( #MCDXREMBROK.Sell_Buy = 2 )                       
	                    THEN 'F'                       
	                    ELSE 'S'                       
	                END                       
	                )                       
	                WHEN #MCDXREMBROK.Settflag in(6,7)                       
	                THEN 'S'                       
	                WHEN #MCDXREMBROK.Settflag in(8,9)                       
	                THEN 'F'                       
	                WHEN #MCDXREMBROK.settflag = 0                       
	                THEN 'F'                       
	            END                       
	            )                       
	            AND #MCDXREMBROK.RemCode = s.RemCode                       
	            AND MPrice <= Broktable.upper_lim                       
	     )                       
	        WHEN BrokScheme = 3                  
	        THEN                       
	        (                       
	        SELECT                       
	            min(Broktable.line_no)                       
	        FROM #BROKTABLE_MCDX broktable                       
	        WHERE Broktable.table_no = (                       
	            CASE    WHEN Left(S.Inst_Type,3) = 'FUT' And #MCDXREMBROK.AuctionPart = ''                      
	  THEN FutTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'FUT' And #MCDXREMBROK.AuctionPart = 'EA'                      
	  THEN FutFinalTableNo                       
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #MCDXREMBROK.AuctionPart <> 'EA'                      
	  THEN OptTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #MCDXREMBROK.AuctionPart = 'EA'                      
	  THEN OptExTableNo                      
	            END                       
	            )                       
	            AND Trd_Del = (               
	            CASE                       
	                WHEN ((s.Pqty > s.Sqty)                       
	                AND #MCDXREMBROK.Settflag in (1,2,3,4,5))                       
	                THEN (                       
	                CASE                       
	                    WHEN ( #MCDXREMBROK.Sell_Buy = 1 )                       
	                    THEN 'F'                       
	                    ELSE 'S'                       
	                END                       
	                )                       
	                WHEN #MCDXREMBROK.Settflag in(6,7)                       
	                THEN 'S'                       
	                WHEN #MCDXREMBROK.Settflag in(8,9)                       
	                THEN 'F'                       
	                WHEN ((s.Pqty <= s.Sqty)                       
	                AND #MCDXREMBROK.Settflag in (1,2,3,4,5))                       
	                THEN (                       
	                CASE                       
	   WHEN ( #MCDXREMBROK.Sell_Buy = 2 )                       
	                    THEN 'F'                       
	                    ELSE 'S'       
	                END                       
	                )                       
	                WHEN #MCDXREMBROK.Settflag in(6,7)                       
	                THEN 'S'                       
	                WHEN #MCDXREMBROK.Settflag in(8,9)                       
	                THEN 'F'                       
	                WHEN #MCDXREMBROK.settflag = 0                       
	                THEN 'F'                       
	         END                       
	            )                       
	            AND #MCDXREMBROK.RemCode = s.RemCode                       
	            AND MPrice <= Broktable.upper_lim                       
	        )                       
	        WHEN BrokScheme = 2                      
	        THEN                       
	        (                       
	        SELECT                       
	            min(Broktable.line_no)                       
	        FROM #BROKTABLE_MCDX broktable                       
	        WHERE Broktable.table_no = (                       
	            CASE                       
	  WHEN Left(S.Inst_Type,3) = 'FUT' And #MCDXREMBROK.AuctionPart = ''                      
	  THEN FutTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'FUT' And #MCDXREMBROK.AuctionPart = 'EA'                      
	  THEN FutFinalTableNo                       
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #MCDXREMBROK.AuctionPart <> 'EA'                      
	  THEN OptTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #MCDXREMBROK.AuctionPart = 'EA'                      
	  THEN OptExTableNo                      
	            END                       
	            )                       
	            AND Trd_Del = (Case When S.Pqty = S.Sqty                       
	       Then (Case When S.Prate >= S.Srate                       
	                  Then (Case When #MCDXREMBROK.Sell_Buy = 1                      
	                             Then 'F'                       
	    Else 'S'                      
	                 End )                      
	           Else                      
	                              (Case When ( #MCDXREMBROK.Sell_Buy = 2 )                       
	                                      Then 'F'                      
	                             Else 'S'                      
	                        End )                           
	                   End)                      
	                            Else (Case When S.Pqty >= S.Sqty                       
	                                              Then (Case When ( #MCDXREMBROK.Sell_Buy = 1 )                       
	                                                         Then 'F'                        
	                                                         Else 'S'                      
	                                                    End )                      
	                                              Else                      
	                                                   (Case When ( #MCDXREMBROK.Sell_Buy = 2 )                       
	       Then 'F'                        
	                                          Else 'S'                      
	                                                    End )                           
	                  End )                      
	                 End )                       
	            AND #MCDXREMBROK.RemCode = S.RemCode                       
	            AND MPrice <= Broktable.upper_lim                       
	        )                       
	        ELSE                       
	        (                       
	        SELECT                       
	            min(line_no)                       
	        FROM #BROKTABLE_MCDX broktable                       
	        WHERE MPrice <= Broktable.upper_lim                       
	            AND broktable.table_no = (                       
	            CASE                       
	  WHEN Left(S.Inst_Type,3) = 'FUT' And #MCDXREMBROK.AuctionPart = ''                      
	  THEN FutTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'FUT' And #MCDXREMBROK.AuctionPart = 'EA'                      
	  THEN FutFinalTableNo                       
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #MCDXREMBROK.AuctionPart <> 'EA'                      
	  THEN OptTableNo                      
	  WHEN Left(S.Inst_Type,3) = 'OPT' And #MCDXREMBROK.AuctionPart = 'EA'                   
	  THEN OptExTableNo                      
	            END                       
	            )                       
	        )                       
	    END                       
	    )                        
	------ End of Remisier Brokerage For FOTrades Updation
   

	SELECT PARTY_CODE,INST_TYPE,SYMBOL,EXPIRYDATE,STRIKE_PRICE,OPTION_TYPE,AUCTIONPART,              
	SAUDA_DATE,TRADE_NO=Pradnya.DBO.ReplaceTradeNo(Trade_No),ORDER_NO,              
	SELL_BUY,TRADEQTY=Sum(TRADEQTY),PRICE,Brokerage=Sum(Brokerage*(BookType/Instrument)),              
	REMCODE,	BRANCH_CD,
	REM_Brokerage=Sum(REM_BROKAPPLIED*TradeQty*(BookType/Instrument)),              
	REM_NBROKAPP=0,Status,SLABTYPE,FROMDATE,              
	TODATE,MPrice,Multiplier,REMPARTYCD,EXCHANGEID, SCHEMEID, SCHEMEORSLAB, REMTYPE              
	INTO #MCDXREMBROK_1 From #MCDXREMBROK              
	GROUP BY PARTY_CODE,INST_TYPE,SYMBOL,EXPIRYDATE,STRIKE_PRICE,OPTION_TYPE,AUCTIONPART,              
	SAUDA_DATE,Pradnya.DBO.ReplaceTradeNo(Trade_No),ORDER_NO,              
	SELL_BUY,PRICE,REMCODE,BRANCH_CD,Status,SLABTYPE,FROMDATE,              
	TODATE,MPrice,Multiplier,REMPARTYCD,EXCHANGEID, SCHEMEID, SCHEMEORSLAB, REMTYPE                

   ---------- Update MCDX Brokerage From  MCDX.DBO.CHARGES_DETAIL Table	              
	UPDATE                 
	 #MCDXREMBROK_1                
	SET                
	 Brokerage = (Case When Sell_Buy =1 then CD_Tot_BuyBrok Else CD_Tot_SellBrok End)              
	FROM                
	 MCDX.DBO.CHARGES_DETAIL                
	WHERE                
	 Convert(Varchar,CD_Sauda_Date,103) = Convert(Varchar,Sauda_Date,103)                
	 And CD_Party_Code = #MCDXREMBROK_1.Party_Code                 
	 And CD_Inst_Type = Inst_Type              
	 And CD_Symbol = Symbol                
	 And Convert(Varchar,CD_Expiry_Date,106) = Convert(Varchar,ExpiryDate,106)                
	 And CD_Option_Type = Option_Type                
	 And CD_Strike_Price = Strike_Price                
	 And CD_Trade_No = Trade_No                
	 And CD_Order_No = Order_No               

---*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
---- Remisier Brokerage Calculation Startes Here

	CREATE TABLE #ExchPartyDatewiseDetails(
			Segment VARCHAR(10) DEFAULT(''),
			Exchange VARCHAR(5) DEFAULT(''),
			SubBrokerCode VARCHAR(10) DEFAULT(''),
			BranchCode VARCHAR(10) DEFAULT(''),
			PartyCode VARCHAR(10) DEFAULT(''),
			SaudaDate DATETIME,
			TurnOver NUMERIC(18,4) DEFAULT(0),
			BrokEarned NUMERIC(18,4) DEFAULT(0),
			RemBrok NUMERIC(18,4) DEFAULT(0),
			RemBrokPayable NUMERIC(18,4) DEFAULT(0),
			BalanceBrok NUMERIC(18,4) DEFAULT(0),
			SchemeID INT DEFAULT(0),
			BranchSchemeID  INT DEFAULT(0),
			SchemeOrSlab VARCHAR(7) DEFAULT(''),
			SubBrokParty VARCHAR(10) DEFAULT(''),
			BranchParty VARCHAR(10) DEFAULT(''),
			SlabType VARCHAR(10) DEFAULT(''),
			RemBrokPayableForBranch NUMERIC(18,4) DEFAULT(0),
			AppliedBrokForCutOff_2 VARCHAR(15) DEFAULT(''))			--- EARNED_BROK/REM_BROK
	
	CREATE TABLE #ExchPartywiseDetails(
			Segment VARCHAR(10) DEFAULT(''),
			Exchange VARCHAR(5) DEFAULT(''),
			SubBrokerCode VARCHAR(10) DEFAULT(''),
			BranchCode VARCHAR(10) DEFAULT(''),
			PartyCode VARCHAR(10) DEFAULT(''),
			TurnOver NUMERIC(18,4) DEFAULT(0),
			BrokEarned NUMERIC(18,4) DEFAULT(0),
			RemBrok NUMERIC(18,4) DEFAULT(0),
			RemBrokPayable NUMERIC(18,4) DEFAULT(0),
			BalanceBrok NUMERIC(18,4) DEFAULT(0),
			SchemeID INT DEFAULT(0),
			SchemeOrSlab VARCHAR(7) DEFAULT(''),
			SubBrokParty VARCHAR(10) DEFAULT(''),
			SlabType VARCHAR(10) DEFAULT(''),
			AppliedBrokForCutOff_2 VARCHAR(15) DEFAULT(''))			--- EARNED_BROK/REM_BROK

	CREATE TABLE #ExchangeSubBrokerPartywise(
			Segment VARCHAR(10) DEFAULT(''),
			Exchange VARCHAR(5) DEFAULT(''),
			SubBrokerCode VARCHAR(10) DEFAULT(''),
			BranchCode VARCHAR(10) DEFAULT(''),
			TurnOver NUMERIC(18,4) DEFAULT(0),
			BrokEarned NUMERIC(18,4) DEFAULT(0),
			RemBrok NUMERIC(18,4) DEFAULT(0),
			RemBrokPayable NUMERIC(18,4) DEFAULT(0),
			BalanceBrok NUMERIC(18,4) DEFAULT(0),
			SchemeID INT DEFAULT(0),
			SchemeOrSlab VARCHAR(7) DEFAULT(''),
			SubBrokParty VARCHAR(10) DEFAULT(''),
			SlabType VARCHAR(10) DEFAULT(''),
			SharePercentage NUMERIC(18,4) DEFAULT(0),
			AppliedBrokForCutOff_2 VARCHAR(15) DEFAULT(''))			--- EARNED_BROK/REM_BROK

	--- Collect NSECM Trade Details
	INSERT INTO #ExchPartyDatewiseDetails(
			Segment,
			Exchange,
			SubBrokerCode,
			BranchCode,
			PartyCode,
			SaudaDate,
			TurnOver,
			BrokEarned,
			RemBrok,
			RemBrokPayable,
			BalanceBrok,
			SchemeID,
			SchemeOrSlab,
			SubBrokParty,
			SlabType)
		
		--- Collect BSECM Trade Details
		SELECT 
			Segment = 'CAPITAL',
			Exchange = 'BSECM',
			SubBrokerCode = REMCODE,
			BranchCode = BRANCH_CD,
			PartyCode = PARTY_CODE,
			SaudaDate = SAUDA_DATE,
			TurnOver = SUM(TRADEQTY * MARKETRATE),
			BrokEarned = SUM(TRADEQTY * NBROKAPP), 
			RemBrok = SUM(TRADEQTY * REM_BROKAPPLIED) + SUM(TRADEQTY * REM_NBROKAPP),
			RemBrokPayable = 0,
			BalanceBrok = SUM(TRADEQTY * NBROKAPP), 
			SchemeID = SCHEMEID,
			SchemeOrSlab = SCHEMEORSLAB,
			SubBrokParty = REMPARTYCD,
			SlabType = SLABTYPE
		FROM #REMBROK 
		WHERE EXCHANGEID = 'BSECM'	
		GROUP BY REMCODE, BRANCH_CD, SAUDA_DATE, PARTY_CODE, SCHEMEID, SCHEMEORSLAB, SLABTYPE, REMPARTYCD

	UNION ALL

		--- Collect NSECM Trade Details
		SELECT 
			Segment = 'CAPITAL',
			Exchange = 'NSECM',
			SubBrokerCode = REMCODE,
			BranchCode = BRANCH_CD,
			PartyCode = PARTY_CODE,
			SaudaDate = SAUDA_DATE,
			TurnOver = SUM(TRADEQTY * MARKETRATE),
			BrokEarned = SUM(TRADEQTY * NBROKAPP), 
			RemBrok = SUM(TRADEQTY * REM_BROKAPPLIED) + SUM(TRADEQTY * REM_NBROKAPP),
			RemBrokPayable = 0,
			BalanceBrok = SUM(TRADEQTY * NBROKAPP), 
			SchemeID = SCHEMEID,
			SchemeOrSlab = SCHEMEORSLAB,
			SubBrokParty = REMPARTYCD,
			SlabType = SLABTYPE
		FROM #REMBROK 
		WHERE EXCHANGEID = 'NSECM'	
		GROUP BY REMCODE, BRANCH_CD, SAUDA_DATE, PARTY_CODE, SCHEMEID, SCHEMEORSLAB, SLABTYPE, REMPARTYCD

	UNION ALL
	
	--- Collect NSEFO Trade Details
		SELECT 
			Segment = 'FUTURES',
			Exchange = 'NSEFO',
			SubBrokerCode = REMCODE,
			BranchCode = BRANCH_CD,
			PartyCode = PARTY_CODE,
			SaudaDate = SAUDA_DATE,
			TurnOver = SUM(TRADEQTY * MPRICE),
			BrokEarned = SUM(BROKERAGE), 
			RemBrok = SUM(REM_BROKERAGE),
			RemBrokPayable = 0,
			BalanceBrok = SUM(BROKERAGE), 
			SchemeID = SCHEMEID,
			SchemeOrSlab = SCHEMEORSLAB,
			SubBrokParty = REMPARTYCD,
			SlabType = SLABTYPE
		FROM #FOREMBROK_1 
		WHERE EXCHANGEID = 'NSEFO'	
		GROUP BY REMCODE, BRANCH_CD, SAUDA_DATE, PARTY_CODE, SCHEMEID, SCHEMEORSLAB, SLABTYPE, REMPARTYCD

	UNION ALL
	
	--- Collect NCDX Trade Details
		SELECT 
			Segment = 'COMMODITY',
			Exchange = 'NCDX',
			SubBrokerCode = REMCODE,
			BranchCode = BRANCH_CD,
			PartyCode = PARTY_CODE,
			SaudaDate = SAUDA_DATE,
			TurnOver = SUM(TRADEQTY * MPRICE),
			BrokEarned = SUM(BROKERAGE), 
			RemBrok = SUM(REM_BROKERAGE),
			RemBrokPayable = 0,
			BalanceBrok = SUM(BROKERAGE), 
			SchemeID = SCHEMEID,
			SchemeOrSlab = SCHEMEORSLAB,
			SubBrokParty = REMPARTYCD,
			SlabType = SLABTYPE
		FROM #NCDXREMBROK_1 
		WHERE EXCHANGEID = 'NCDX'	
		GROUP BY REMCODE, BRANCH_CD, SAUDA_DATE, PARTY_CODE, SCHEMEID, SCHEMEORSLAB, SLABTYPE, REMPARTYCD


	UNION ALL
	
	--- Collect MCDX Trade Details
		SELECT 
			Segment = 'COMMODITY',
			Exchange = 'MCDX',
			SubBrokerCode = REMCODE,
			BranchCode = BRANCH_CD,
			PartyCode = PARTY_CODE,
			SaudaDate = SAUDA_DATE,
			TurnOver = SUM(TRADEQTY * MPRICE),
			BrokEarned = SUM(BROKERAGE), 
			RemBrok = SUM(REM_BROKERAGE),
			RemBrokPayable = 0,
			BalanceBrok = SUM(BROKERAGE), 
			SchemeID = SCHEMEID,
			SchemeOrSlab = SCHEMEORSLAB,
			SubBrokParty = REMPARTYCD,
			SlabType = SLABTYPE
		FROM #NCDXREMBROK_1 
		WHERE EXCHANGEID = 'MCDX'	
		GROUP BY REMCODE, BRANCH_CD, SAUDA_DATE, PARTY_CODE, SCHEMEID, SCHEMEORSLAB, SLABTYPE, REMPARTYCD

	--- Collect All Trades Details by Exch+Partywise
	INSERT INTO #ExchPartywiseDetails(
			Segment,
			Exchange,
			SubBrokerCode,
			BranchCode,
			PartyCode,
			TurnOver,
			BrokEarned,
			RemBrok,
			RemBrokPayable,
			BalanceBrok,
			SchemeID,
			SchemeOrSlab,
			SubBrokParty,
			SlabType)
	SELECT
			Segment,
			Exchange,
			SubBrokerCode,
			BranchCode,
			PartyCode,
			TurnOver = SUM(TurnOver),
			BrokEarned = SUM(BrokEarned),
			RemBrok = SUM(RemBrok),
			RemBrokPayable = SUM(RemBrokPayable),
			BalanceBrok = SUM(BalanceBrok),
			SchemeID,
			SchemeOrSlab,
			SubBrokParty,
			SlabType
	FROM #ExchPartyDatewiseDetails
	GROUP BY
			Segment,
			Exchange,
			SubBrokerCode,
			BranchCode,
			PartyCode,
			SchemeID,
			SchemeOrSlab,
			SubBrokParty,
			SlabType

	--- Collect All Trades Details by Exch+SubBroker+SubBrokerParty
	INSERT INTO #ExchangeSubBrokerPartywise(
			Segment,
			Exchange,
			SubBrokerCode,
			BranchCode,
			TurnOver,
			BrokEarned,
			RemBrok,
			RemBrokPayable,
			BalanceBrok,
			SchemeID,
			SchemeOrSlab,
			SubBrokParty,
			SlabType)
	SELECT
			Segment,
			Exchange,
			SubBrokerCode,
			BranchCode = '',						-- Since SBU Logic
			TurnOver = SUM(TurnOver),
			BrokEarned = SUM(BrokEarned),
			RemBrok = SUM(RemBrok),
			RemBrokPayable = SUM(RemBrokPayable),
			BalanceBrok = SUM(BalanceBrok),
			SchemeID,
			SchemeOrSlab,
			SubBrokParty,
			SlabType
	FROM #ExchPartywiseDetails
	GROUP BY
			Segment,
			Exchange,
			SubBrokerCode,
			--BranchCode,		-- Since SBU Logic
			SchemeID,
			SchemeOrSlab,
			SubBrokParty,
			SlabType

	--- Compute Remisier Payable Brokerage based on the slab type ('CUT-OFF-1'/'CUT-OFF-2')
	UPDATE #ExchangeSubBrokerPartywise SET 
			RemBrokPayable = (CASE                       
                               WHEN SlabType = 'CUT-OFF-1' THEN (CASE WHEN BrokEarned > RemBrok THEN BrokEarned - RemBrok  ELSE 0 END)
                               WHEN SlabType = 'CUT-OFF-2' THEN (CASE WHEN BrokEarned > RemBrok THEN RemBrok  ELSE BrokEarned END)
									END),

			BalanceBrok = 	BrokEarned - (CASE                       
			                               WHEN SlabType = 'CUT-OFF-1' THEN (CASE WHEN BrokEarned > RemBrok THEN BrokEarned - RemBrok  ELSE 0 END)
			                               WHEN SlabType = 'CUT-OFF-2' THEN (CASE WHEN BrokEarned > RemBrok THEN RemBrok  ELSE BrokEarned END)
												  END),
				           
			AppliedBrokForCutOff_2 = (CASE                       
				                               WHEN SlabType = 'CUT-OFF-1' THEN ''
				                               WHEN SlabType = 'CUT-OFF-2' THEN (CASE WHEN BrokEarned > RemBrok THEN 'REM_BROK' ELSE 'EARNED_BROK' END)
													END)

	--- UPDATE RemBrokPayable ExchPartywiseDetails table
	UPDATE #ExchPartywiseDetails SET 
				RemBrokPayable = CASE WHEN B.SlabType = 'CUT-OFF-1' AND B.RemBrokPayable >0 AND (B.BrokEarned - B.RemBrok) > 0 
													THEN ((A.BrokEarned - A.RemBrok) * (B.RemBrokPayable/(B.BrokEarned - B.RemBrok)) )
											 WHEN B.SlabType = 'CUT-OFF-2' AND B.AppliedBrokForCutOff_2 = 'EARNED_BROK' AND B.BrokEarned > 0
													THEN (A.BrokEarned*(B.RemBrokPayable/B.BrokEarned))										 ---   'EARNED_BROK'
											ELSE (CASE WHEN B.RemBrok > 0 THEN (A.RemBrok*(B.RemBrokPayable/B.RemBrok)) ELSE 0 END) ---   'REM_BROK'
										END,
				BalanceBrok = A.BrokEarned - CASE WHEN B.SlabType = 'CUT-OFF-1' AND B.RemBrokPayable >0 AND (B.BrokEarned - B.RemBrok) > 0
													THEN ((A.BrokEarned - A.RemBrok) * (B.RemBrokPayable/(B.BrokEarned - B.RemBrok)) )
											 WHEN B.SlabType = 'CUT-OFF-2' AND B.AppliedBrokForCutOff_2 = 'EARNED_BROK' AND B.BrokEarned > 0
													THEN (A.BrokEarned*(B.RemBrokPayable/B.BrokEarned))											---   'EARNED_BROK'
											 ELSE (CASE WHEN B.RemBrok > 0 THEN (A.RemBrok*(B.RemBrokPayable/B.RemBrok))	ELSE 0 END) ---   'REM_BROK'
										END,
				AppliedBrokForCutOff_2 = B.AppliedBrokForCutOff_2
	FROM 	#ExchPartywiseDetails A, #ExchangeSubBrokerPartywise B 
	WHERE 
	A.Segment = B.Segment
	AND A.Exchange = B.Exchange
	AND A.SubBrokerCode = B.SubBrokerCode
	--AND A.BranchCode = B.BranchCode			-- Since SBU Logic
	AND A.SchemeID = B.SchemeID
	AND A.SchemeOrSlab = B.SchemeOrSlab
	AND A.SubBrokParty = B.SubBrokParty
	AND A.SlabType = B.SlabType

	--- UPDATE RemBrokPayable ExchPartyDatewiseDetails table
	UPDATE #ExchPartyDatewiseDetails SET 
				RemBrokPayable = CASE WHEN B.SlabType = 'CUT-OFF-1' AND B.RemBrokPayable >0 AND (B.BrokEarned - B.RemBrok) > 0 
													THEN ((A.BrokEarned - A.RemBrok) * (B.RemBrokPayable/(B.BrokEarned - B.RemBrok)) )
											 WHEN B.SlabType = 'CUT-OFF-2' AND B.AppliedBrokForCutOff_2 = 'EARNED_BROK' AND B.BrokEarned > 0
													THEN (A.BrokEarned*(B.RemBrokPayable/B.BrokEarned))											---   'EARNED_BROK'
											ELSE (CASE WHEN B.RemBrok > 0 THEN (A.RemBrok*(B.RemBrokPayable/B.RemBrok))	ELSE 0 END) ---   'REM_BROK'
										END,
				BalanceBrok = A.BrokEarned - CASE WHEN B.SlabType = 'CUT-OFF-1' AND B.RemBrokPayable >0 AND (B.BrokEarned - B.RemBrok) > 0
													THEN ((A.BrokEarned - A.RemBrok) * (B.RemBrokPayable/(B.BrokEarned - B.RemBrok)) )
											 WHEN B.SlabType = 'CUT-OFF-2' AND B.AppliedBrokForCutOff_2 = 'EARNED_BROK' AND B.BrokEarned > 0
													THEN (A.BrokEarned*(B.RemBrokPayable/B.BrokEarned))										 ---   'EARNED_BROK'
											ELSE (CASE WHEN B.RemBrok > 0 THEN (A.RemBrok*(B.RemBrokPayable/B.RemBrok)) ELSE 0 END) ---   'REM_BROK'
										END,
				AppliedBrokForCutOff_2 = B.AppliedBrokForCutOff_2
	FROM 	#ExchPartyDatewiseDetails A, #ExchPartywiseDetails B 
	WHERE 
	A.Segment = B.Segment
	AND A.Exchange = B.Exchange
	AND A.SubBrokerCode = B.SubBrokerCode
	AND A.BranchCode = B.BranchCode
	AND A.PartyCode = B.PartyCode
	AND A.SchemeID = B.SchemeID
	AND A.SchemeOrSlab = B.SchemeOrSlab
	AND A.SubBrokParty = B.SubBrokParty
	AND A.SlabType = B.SlabType

	UPDATE #ExchPartyDatewiseDetails SET BalanceBrok = ISNULL(BrokEarned,0) - ISNULL(RemBrokPayable, 0)
	
	UPDATE #ExchPartywiseDetails SET BalanceBrok = ISNULL(BrokEarned,0) - ISNULL(RemBrokPayable, 0)
	
	UPDATE #ExchangeSubBrokerPartywise SET BalanceBrok = ISNULL(BrokEarned,0) - ISNULL(RemBrokPayable, 0)

	CREATE TABLE #ExchangeSubBrokSchemewise(
			SubBrokerCode VARCHAR(10) DEFAULT(''),
			BranchCode VARCHAR(10) DEFAULT(''),
			TurnOver NUMERIC(18,4) DEFAULT(0),
			BrokEarned NUMERIC(18,4) DEFAULT(0),
			RemBrok NUMERIC(18,4) DEFAULT(0),
			RemBrokPayable NUMERIC(18,4) DEFAULT(0),
			OrigBalanceBrok NUMERIC(18,4) DEFAULT(0),
			BalanceBrok NUMERIC(18,4) DEFAULT(0),
			SchemeID INT DEFAULT(0),
			SubBrokParty VARCHAR(10) DEFAULT(''),
			SlabType VARCHAR(10) DEFAULT(''),
			SharePercentage NUMERIC(18,4) DEFAULT(0))

	INSERT INTO #ExchangeSubBrokSchemewise(
			SubBrokerCode,
			BranchCode,
			TurnOver,
			BrokEarned,
			RemBrok,
			RemBrokPayable,
			OrigBalanceBrok,
			BalanceBrok,
			SchemeID,
			SubBrokParty,
			SlabType)
	SELECT 
			SubBrokerCode,
			BranchCode='',		-- Since SBU Logic
			TurnOver = SUM(TurnOver),
			BrokEarned = SUM(BrokEarned),
			RemBrok = 0,
			RemBrokPayable = 0,
			OrigBalanceBrok = SUM(BalanceBrok),
			BalanceBrok = SUM(BalanceBrok),
			SchemeID,
			SubBrokParty,
			SlabType
	FROM #ExchangeSubBrokerPartywise
	WHERE SchemeOrSlab = 'SLAB'
			AND ISNULL(SchemeID,0) <> 0
	GROUP BY
			SubBrokerCode,
			--BranchCode,		-- Since SBU Logic
			SchemeID,
			SubBrokParty,
			SlabType
	
	UPDATE #ExchangeSubBrokSchemewise SET 
			SharePercentage = SHAREPER,
			RemBrok = (CASE WHEN ValPerc = 'P' THEN 
								 BalanceBrok * (CASE WHEN SHAREPER> 0 THEN ISNULL(SHAREPER,0) / 100 ELSE 0 END)
							ELSE ISNULL(SHAREPER,0) 
							END)	,                       

			RemBrokPayable = (CASE WHEN ValPerc = 'P' THEN 
										 BalanceBrok * (CASE WHEN ISNULL(SHAREPER,0) > 0 THEN ISNULL(SHAREPER,0) / 100 ELSE 0 END)
									ELSE ISNULL(SHAREPER,0) 
									END),	                       

	       BalanceBrok = BalanceBrok - 
								 (CASE WHEN ValPerc = 'P' THEN 
										 BalanceBrok * (CASE WHEN ISNULL(SHAREPER,0) > 0 THEN ISNULL(SHAREPER,0) / 100 ELSE 0 END)
										 ELSE ISNULL(SHAREPER,0) 
                 			  END)	
	FROM #ExchangeSubBrokSchemewise A, RemisierBrokerageScheme S
	WHERE A.SchemeID = S.SchemeID AND A.SlabType ='FLAT'
	AND BalanceBrok BETWEEN ISNULL(LOWERLIMIT,0) AND ISNULL(UPPERLIMIT,9999999999)   

	--------------  Updating of Slab-Incr Brokerage For SubBroker
	DECLARE  @REMCUR               CURSOR,                      
	         @REMCODE              VARCHAR(10),                      
	         @CUR_REMCODE          VARCHAR(10),                      
	         @BRANCH_CD            VARCHAR(10),                      
	         @CUR_BRANCH_CD        VARCHAR(10),                      
	  			@REM_PARTYCODE        VARCHAR(10),                      
	   		@CUR_REM_PARTYCODE    VARCHAR(10),                      
	         @SHARE_PER            NUMERIC(18,4),                      
	   		@BALANCE_BROKERAGE    NUMERIC(18,4),                      
	         @REM_BROKERAGE        NUMERIC(18,4),                      
	         @CURBALANCE_BROKERAGE NUMERIC(18,4),                      
	         @REMTYPE              VARCHAR(10),                      
	         @LOWER_LIMIT          NUMERIC(18,4),                      
	         @UPPER_LIMIT          NUMERIC(18,4),                      
	         @SCHEMEID 				 INT,
				@CUR_SCHEMEID			 INT,
				@VALPERC 	          VARCHAR(10)                      
             
	SET @REMCUR = CURSOR FOR SELECT R.SCHEMEID,
											  R.SubBrokerCode,                      
	                                --R.BranchCode,         -- Since SBU Logic             
	               					  SHARE_PER = ISNULL(S.SHAREPER,0),                      
	                                BalanceBrok,                      
	                                LOWER_LIMIT = ISNULL(LOWERLIMIT,0),                      
	                                UPPER_LIMIT = ISNULL(UPPERLIMIT,9999999999),                      
	                   				  SubBrokParty,                   
											  VALPERC
	                         FROM   #ExchangeSubBrokSchemewise R                      
	                                LEFT OUTER JOIN RemisierBrokerageScheme S                      
	                                  ON (R.SchemeID = S.SchemeID)                      
	                         WHERE  SlabType = 'INCR'    
	       ORDER BY R.BranchCode, R.SubBrokerCode, LOWERLIMIT      
	                      
	OPEN @REMCUR                      
	                      
	FETCH NEXT FROM @REMCUR         
	INTO @SCHEMEID,
		  @REMCODE,                      
	    -- @BRANCH_CD,                     -- Since SBU Logic 
	     @SHARE_PER,                      
	     @BALANCE_BROKERAGE,                      
	    -- @REMTYPE,                      
	     @LOWER_LIMIT,                      
	     @UPPER_LIMIT,                      
	  	  @REM_PARTYCODE,
		  @VALPERC                      
	                      
	WHILE @@FETCH_STATUS = 0                      
	  BEGIN                       
	  --SELECT @BRANCH_CD, @SHARE_PER, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT                      
	   -- SET @CUR_BRANCH_CD = @BRANCH_CD                      -- Since SBU Logic
	    SET @CUR_REMCODE = @REMCODE
		 SET @CUR_SCHEMEID = @SCHEMEID                 
	 	 SET @CUR_REM_PARTYCODE = @REM_PARTYCODE                      
	    SET @REM_BROKERAGE = 0                      
	    SET @CURBALANCE_BROKERAGE = @BALANCE_BROKERAGE                      
	    IF @BALANCE_BROKERAGE > 0                      
	       AND @SHARE_PER > 0                      
	      BEGIN                      
	        WHILE @CUR_REMCODE = @REMCODE                      
	              --AND @CUR_BRANCH_CD = @BRANCH_CD                      -- Since SBU Logic
					  AND @CUR_SCHEMEID = @SCHEMEID 
					  AND @CUR_REM_PARTYCODE = @REM_PARTYCODE 
	              AND @@FETCH_STATUS = 0                      
	          BEGIN                      
	            IF @CUR_REMCODE = @REMCODE
						AND @CUR_SCHEMEID = @SCHEMEID                      
	               AND @CUR_REM_PARTYCODE = @REM_PARTYCODE                      
	               AND @BALANCE_BROKERAGE > 0                      
	               AND @CURBALANCE_BROKERAGE > 0                      
	               AND @SHARE_PER > 0                      
	               AND @@FETCH_STATUS = 0                      
	              BEGIN                      
	                IF @BALANCE_BROKERAGE >= @UPPER_LIMIT                      
	                  BEGIN                      
							  IF @VALPERC = 'P'
	                    		SET @REM_BROKERAGE = @REM_BROKERAGE + ((@UPPER_LIMIT - @LOWER_LIMIT) * @SHARE_PER / 100)                      
								ELSE	--- 'V'
	                    		SET @REM_BROKERAGE = @REM_BROKERAGE + @SHARE_PER

	                    SET @CURBALANCE_BROKERAGE = @CURBALANCE_BROKERAGE - (@UPPER_LIMIT - @LOWER_LIMIT)                      
	                    IF @CURBALANCE_BROKERAGE < 0                      
	                      SET @CURBALANCE_BROKERAGE = 0                      
	                  END                      
	                ELSE                      
	                  BEGIN      
							  IF @VALPERC = 'P'	                
	                    		SET @REM_BROKERAGE = @REM_BROKERAGE + @CURBALANCE_BROKERAGE * @SHARE_PER / 100                      
							  ELSE		--- 'V'
	                    		SET @REM_BROKERAGE = @REM_BROKERAGE + @SHARE_PER 

	                    SET @CURBALANCE_BROKERAGE = 0                     
	                    SET @BALANCE_BROKERAGE = 0             
	                  END                      
	              END                      
	              --SELECT @REMCODE, @BRANCH_CD, @SHARE_PER, @CURBALANCE_BROKERAGE, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT, @REM_BROKERAGE                      
	            FETCH NEXT FROM @REMCUR                      
	            INTO @SCHEMEID, 
						  @REMCODE,                      
	                 --@BRANCH_CD,                      -- Since SBU Logic
	                 @SHARE_PER,                      
	                 @BALANCE_BROKERAGE,                      
	                -- @REMTYPE,                      
	                 @LOWER_LIMIT,                      
	                 @UPPER_LIMIT,                      
	        			  @REM_PARTYCODE,
						  @VALPERC                      
	          END                      
	        UPDATE #ExchangeSubBrokSchemewise                      
	        SET    RemBrokPayable = @REM_BROKERAGE,                      
	               BalanceBrok = BalanceBrok - @REM_BROKERAGE--,                      
	           --REMPARTYCD = @CUR_REM_PARTYCODE, SlabType = 'INCR'                      
	        WHERE  SubBrokerCode = @CUR_REMCODE                      
	               --AND BranchCode = @CUR_BRANCH_CD  -- Since SBU Logic
						AND SCHEMEID = @SCHEMEID                    
						AND SubBrokParty = @CUR_REM_PARTYCODE
	                             
	      END                      
	    ELSE                      
	      BEGIN                      
	      --SELECT @REMCODE, @BRANCH_CD, @SHARE_PER, @CURBALANCE_BROKERAGE, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT, @REM_BROKERAGE                      
	        FETCH NEXT FROM @REMCUR                      
	        INTO @SCHEMEID, 
					 @REMCODE,                      
	             --@BRANCH_CD,             -- Since SBU Logic         
	             @SHARE_PER,                      
	             @BALANCE_BROKERAGE,                      
	             --@REMTYPE,                 
	             @LOWER_LIMIT,                      
	             @UPPER_LIMIT,                      
	    			 @REM_PARTYCODE,
					 @VALPERC                       
	      END                      
	  END     


	--- UPDATE RemBrokPayable #ExchangeSubBrokerPartywise table
	UPDATE #ExchangeSubBrokerPartywise SET 
				SharePercentage = B.SharePercentage,
				RemBrokPayable = CASE WHEN B.OrigBalanceBrok > 0 THEN (A.BalanceBrok*(B.RemBrokPayable/B.OrigBalanceBrok)) ELSE 0 END,
				AppliedBrokForCutOff_2 = ''
	FROM 	#ExchangeSubBrokerPartywise A, #ExchangeSubBrokSchemewise B 
	WHERE 
	A.SubBrokerCode = B.SubBrokerCode
	--AND A.BranchCode = B.BranchCode	-- Since SBU Logic
	AND A.SchemeID = B.SchemeID
	AND A.SchemeOrSlab = 'SLAB'
	--AND B.SlabType = 'FLAT'
	AND A.SubBrokParty = B.SubBrokParty
	AND A.SlabType = B.SlabType

	--- UPDATE RemBrokPayable ExchPartywiseDetails table
	UPDATE #ExchPartywiseDetails SET 
				RemBrokPayable = CASE WHEN B.BalanceBrok > 0 THEN (A.BalanceBrok*(B.RemBrokPayable/B.BalanceBrok)) ELSE 0 END,
				AppliedBrokForCutOff_2 = ''
	FROM 	#ExchPartywiseDetails A, #ExchangeSubBrokerPartywise B 
	WHERE 
	A.SubBrokerCode = B.SubBrokerCode
	--AND A.BranchCode = B.BranchCode			-- Since SBU Logic
	AND A.Segment =  B.Segment
	AND A.Exchange = B.Exchange
	AND A.SchemeID = B.SchemeID
	AND A.SchemeOrSlab = 'SLAB'
	AND A.SubBrokParty = B.SubBrokParty
	AND A.SlabType = B.SlabType

	--- UPDATE RemBrokPayable ExchPartyDatewiseDetails table
	UPDATE #ExchPartyDatewiseDetails SET 
				RemBrokPayable = CASE WHEN B.BalanceBrok > 0 THEN (A.BalanceBrok*(B.RemBrokPayable/B.BalanceBrok)) ELSE 0 END,
				AppliedBrokForCutOff_2 = ''
	FROM 	#ExchPartyDatewiseDetails A, #ExchPartywiseDetails B 
	WHERE 
	A.Segment = B.Segment
	AND A.Exchange = B.Exchange
	AND A.SubBrokerCode = B.SubBrokerCode
	AND A.BranchCode = B.BranchCode
	AND A.PartyCode = B.PartyCode
	AND A.SchemeID = B.SchemeID
	AND A.SchemeOrSlab = B.SchemeOrSlab
	AND A.SubBrokParty = B.SubBrokParty
	AND A.SlabType = B.SlabType
	AND A.SchemeOrSlab = 'SLAB'

	UPDATE #ExchPartyDatewiseDetails SET BalanceBrok = ISNULL(BrokEarned,0) - ISNULL(RemBrokPayable, 0)
	
	UPDATE #ExchPartywiseDetails SET BalanceBrok = ISNULL(BrokEarned,0) - ISNULL(RemBrokPayable, 0)
	
	UPDATE #ExchangeSubBrokerPartywise SET BalanceBrok = ISNULL(BrokEarned,0) - ISNULL(RemBrokPayable, 0)

	UPDATE #ExchangeSubBrokSchemewise SET BalanceBrok = ISNULL(BrokEarned,0) - ISNULL(RemBrokPayable, 0)

--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
	----- BRANCH REMISIER BROKERAGE CALCULATION

	CREATE TABLE #ExchPartyDatewiseDetailsBranch(
			Segment VARCHAR(10) DEFAULT(''),
			Exchange VARCHAR(5) DEFAULT(''),
			SubBrokerCode VARCHAR(10) DEFAULT(''),			
			BranchCode VARCHAR(10) DEFAULT(''),
			PartyCode VARCHAR(10) DEFAULT(''),
			SaudaDate DATETIME,
			TurnOver NUMERIC(18,4) DEFAULT(0),
			BrokEarned NUMERIC(18,4) DEFAULT(0),
			RemBrok NUMERIC(18,4) DEFAULT(0),
			RemBrokPayable NUMERIC(18,4) DEFAULT(0),
			BalanceBrok NUMERIC(18,4) DEFAULT(0),
			SchemeID INT DEFAULT(0),
			BranchParty VARCHAR(10) DEFAULT(''),
			SlabType VARCHAR(10) DEFAULT(''),
			SharePercentage NUMERIC(18,4) DEFAULT(0))
	
	CREATE TABLE #ExchPartywiseDetailsBranch(
			Segment VARCHAR(10) DEFAULT(''),
			Exchange VARCHAR(5) DEFAULT(''),
			SubBrokerCode VARCHAR(10) DEFAULT(''),
			BranchCode VARCHAR(10) DEFAULT(''),
			PartyCode VARCHAR(10) DEFAULT(''),
			TurnOver NUMERIC(18,4) DEFAULT(0),
			BrokEarned NUMERIC(18,4) DEFAULT(0),
			RemBrok NUMERIC(18,4) DEFAULT(0),
			RemBrokPayable NUMERIC(18,4) DEFAULT(0),
			BalanceBrok NUMERIC(18,4) DEFAULT(0),
			SchemeID INT DEFAULT(0),
			BranchParty VARCHAR(10) DEFAULT(''),
			SlabType VARCHAR(10) DEFAULT(''),
			SharePercentage NUMERIC(18,4) DEFAULT(0))

	CREATE TABLE #ExchBranchSchemewiseBranch(
			BranchCode VARCHAR(10) DEFAULT(''),
			TurnOver NUMERIC(18,4) DEFAULT(0),
			BrokEarned NUMERIC(18,4) DEFAULT(0),
			RemBrok NUMERIC(18,4) DEFAULT(0),
			RemBrokPayable NUMERIC(18,4) DEFAULT(0),
			OrigBalanceBrok NUMERIC(18,4) DEFAULT(0),
			BalanceBrok NUMERIC(18,4) DEFAULT(0),
			SchemeID INT DEFAULT(0),
			BranchParty VARCHAR(10) DEFAULT(''),
			SlabType VARCHAR(10) DEFAULT(''),
			SharePercentage NUMERIC(18,4) DEFAULT(0))

	INSERT INTO #ExchPartyDatewiseDetailsBranch(
			Segment,
			Exchange,
			SubBrokerCode,
			BranchCode,
			PartyCode,
			SaudaDate,
			TurnOver,
			BrokEarned,
			RemBrok,
			RemBrokPayable,
			BalanceBrok,
			SchemeID,
			BranchParty,
			SlabType)

		--- Collect Segment+Exchange+Party+Datewise Details 		
		SELECT 
			Segment,
			Exchange,
			SubBrokerCode='',		-- Since SBU Logic 
			BranchCode,
			PartyCode,
			SaudaDate,
			TurnOver,
			BrokEarned,
			RemBrok = 0,
			RemBrokPayable = 0,
			BalanceBrok,
			SchemeID = 0,
			BranchParty = '',
			SlabType = '' 
		FROM #ExchPartyDatewiseDetails 
		WHERE BalanceBrok > 0
		AND SubBrokerCode NOT IN (SELECT SUBBROKER FROM #RemisierBlockedParty 
 										  WHERE @FromDate >= FromDate AND @ToDate <= ToDate AND SubBrokerOrBranch = 'BR')

--- If any sub broker is blocked, remove those transaction from the table.
-- -- 	DELETE FROM #ExchPartyDatewiseDetailsBranch 
-- -- 		WHERE SubBrokerCode IN (SELECT SUBBROKER FROM #RemisierBlockedParty 
-- -- 										  WHERE @FromDate >= FromDate AND @ToDate <= ToDate AND SubBrokerOrBranch = 'BR')

/*
	--- Update SchemeID For All Sub Broker (For BRANCHS Only)
	UPDATE #ExchPartyDatewiseDetailsBranch SET 
			SchemeID = B.SchemeID,
			BranchParty = B.RemPartyCd,
			SlabType = B.BrokType
	FROM #ExchPartyDatewiseDetailsBranch A, #RemisierAllParty B
	WHERE
		A.BRANCHCODE = B.BRANCHCODE AND
		A.PARTYCODE = B.PARTYCODE AND
		--A.SubBrokerCode = B.SUBBROKER AND 		-- Since SBU Logic 
		A.SAUDADATE BETWEEN B.FROMDATE AND B.TODATE AND
		B.REMTYPE = 'BR'

	--- Overright SchemeID For Specific Sub Broker (For CAPITAL & FUTURES MARKET - BRANCHS Only)
	UPDATE #ExchPartyDatewiseDetailsBranch SET 
			SchemeID = B.SchemeID,
			BranchParty = B.RemPartyCd,
			SlabType = B.BrokType
	FROM #ExchPartyDatewiseDetailsBranch A, #RemisierSpecificParty B
	WHERE
		A.BRANCHCODE = B.BRANCHCODE AND
		A.PARTYCODE = B.PARTYCODE AND
		--A.SubBrokerCode = B.SUBBROKER AND 			-- Since SBU Logic 
		A.SAUDADATE BETWEEN B.FROMDATE AND B.TODATE AND
		B.REMTYPE = 'BR'
*/

--- Update SchemeID For All Sub Broker (For BRANCHS Only)
	UPDATE #ExchPartyDatewiseDetailsBranch SET 
			SchemeID = B.SchemeID,
			BranchParty = B.RemPartyCd,
			SlabType = B.BrokType
	FROM #ExchPartyDatewiseDetailsBranch A, #RemisierAllParty B
	WHERE
		A.BRANCHCODE = B.BRANCHCODE AND
		A.PARTYCODE = B.PARTYCODE AND
		--A.SubBrokerCode = B.SUBBROKER AND 		-- Since SBU Logic 
		A.SAUDADATE BETWEEN B.FROMDATE AND B.TODATE AND
		B.REMTYPE = 'BR' AND
	   A.SEGMENT = CASE WHEN B.SEGMENT IN ('ALL') THEN A.SEGMENT ELSE B.SEGMENT END AND
		A.EXCHANGE = CASE WHEN B.EXCHANGE IN ('ALL') THEN A.EXCHANGE ELSE B.EXCHANGE END

	--- Overright SchemeID For Specific Sub Broker (For CAPITAL & FUTURES MARKET - BRANCHS Only)
	UPDATE #ExchPartyDatewiseDetailsBranch SET 
			SchemeID = B.SchemeID,
			BranchParty = B.RemPartyCd,
			SlabType = B.BrokType
	FROM #ExchPartyDatewiseDetailsBranch A, #RemisierSpecificParty B
	WHERE
		A.BRANCHCODE = B.BRANCHCODE AND
		A.PARTYCODE = B.PARTYCODE AND
		--A.SubBrokerCode = B.SUBBROKER AND 			-- Since SBU Logic 
		A.SAUDADATE BETWEEN B.FROMDATE AND B.TODATE AND
		B.REMTYPE = 'BR' AND
	   A.SEGMENT = CASE WHEN B.SEGMENT IN ('ALL') THEN A.SEGMENT ELSE B.SEGMENT END AND
		A.EXCHANGE = CASE WHEN B.EXCHANGE IN ('ALL') THEN A.EXCHANGE ELSE B.EXCHANGE END	

	--- Remove the records where as no brach sharing has found.
	DELETE FROM #ExchPartyDatewiseDetailsBranch WHERE ISNULL(SchemeID, 0) = 0

	--- Collect All Trades Details by Exch+Partywise
	INSERT INTO #ExchPartywiseDetailsBranch(
			Segment,
			Exchange,
			SubBrokerCode,
			BranchCode,
			PartyCode,
			TurnOver,
			BrokEarned,
			RemBrok,
			RemBrokPayable,
			BalanceBrok,
			SchemeID,
			BranchParty,
			SlabType)
	SELECT
			Segment,
			Exchange,
			SubBrokerCode,
			BranchCode,
			PartyCode,
			TurnOver = SUM(TurnOver),
			BrokEarned = SUM(BrokEarned),
			RemBrok = 0,
			RemBrokPayable = 0,
			BalanceBrok = SUM(BalanceBrok),
			SchemeID,
			BranchParty,
			SlabType
	FROM #ExchPartyDatewiseDetailsBranch
	GROUP BY
			Segment,
			Exchange,
			SubBrokerCode,
			BranchCode,
			PartyCode,
			SchemeID,
			BranchParty,
			SlabType

	INSERT INTO #ExchBranchSchemewiseBranch(
			BranchCode,
			TurnOver,
			BrokEarned,
			RemBrok,
			RemBrokPayable,
			OrigBalanceBrok,
			BalanceBrok,
			SchemeID,
			BranchParty,
			SlabType)
	SELECT 
			BranchCode,
			TurnOver = SUM(TurnOver),
			BrokEarned = SUM(BrokEarned),
			RemBrok = 0,
			RemBrokPayable = 0,
			OrigBalanceBrok = SUM(BalanceBrok),
			BalanceBrok = SUM(BalanceBrok),
			SchemeID,
			BranchParty,
			SlabType
	FROM #ExchPartywiseDetailsBranch
	WHERE ISNULL(SchemeID,0) <> 0
	GROUP BY
			BranchCode,
			SchemeID,
			BranchParty,
			SlabType
	
	UPDATE #ExchBranchSchemewiseBranch SET 
			SharePercentage = SHAREPER,
			RemBrok = (CASE WHEN ValPerc = 'P' THEN 
								 BalanceBrok * (CASE WHEN SHAREPER> 0 THEN ISNULL(SHAREPER,0) / 100 ELSE 0 END)
							ELSE ISNULL(SHAREPER,0) 
							END)	,                       

			RemBrokPayable = (CASE WHEN ValPerc = 'P' THEN 
										 BalanceBrok * (CASE WHEN ISNULL(SHAREPER,0) > 0 THEN ISNULL(SHAREPER,0) / 100 ELSE 0 END)
									ELSE ISNULL(SHAREPER,0) 
									END),	                       

	       BalanceBrok = BalanceBrok - 
								 (CASE WHEN ValPerc = 'P' THEN 
										 BalanceBrok * (CASE WHEN ISNULL(SHAREPER,0) > 0 THEN ISNULL(SHAREPER,0) / 100 ELSE 0 END)
										 ELSE ISNULL(SHAREPER,0) 
                 			  END)	
	FROM #ExchBranchSchemewiseBranch A, RemisierBrokerageScheme S
	WHERE A.SchemeID = S.SchemeID AND A.SlabType ='FLAT'
	AND BalanceBrok BETWEEN ISNULL(LOWERLIMIT,0) AND ISNULL(UPPERLIMIT,9999999999)   

	--------------  Updating of Slab-Incr Brokerage For Branch
	DECLARE  @REMCUR_BRANCH CURSOR                      
             
	SET @REMCUR_BRANCH = CURSOR FOR SELECT R.SCHEMEID,
	                                R.BranchCode,                      
	               					  SHARE_PER = ISNULL(S.SHAREPER,0),                      
	                                BalanceBrok,                      
	                                LOWER_LIMIT = ISNULL(LOWERLIMIT,0),                      
	                                UPPER_LIMIT = ISNULL(UPPERLIMIT,9999999999),                      
	                   				  BranchParty,                   
											  VALPERC
	                         FROM   #ExchBranchSchemewiseBranch R                      
	                                LEFT OUTER JOIN RemisierBrokerageScheme S                      
	                                  ON (R.SchemeID = S.SchemeID)                      
	                         WHERE  SlabType = 'INCR'    
	       ORDER BY R.BranchCode, LOWERLIMIT      
	                      
	OPEN @REMCUR_BRANCH                      
	                      
	FETCH NEXT FROM @REMCUR_BRANCH         
	INTO @SCHEMEID,
	     @BRANCH_CD,                      
	     @SHARE_PER,                      
	     @BALANCE_BROKERAGE,                      
	     @LOWER_LIMIT,                      
	     @UPPER_LIMIT,                      
	  	  @REM_PARTYCODE,
		  @VALPERC                      
	                      
	WHILE @@FETCH_STATUS = 0                      
	  BEGIN                       
	  --SELECT @BRANCH_CD, @SHARE_PER, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT                      
	    SET @CUR_BRANCH_CD = @BRANCH_CD                      
		 SET @CUR_SCHEMEID = @SCHEMEID                 
	    SET @REM_BROKERAGE = 0                      
	    SET @CURBALANCE_BROKERAGE = @BALANCE_BROKERAGE                      
	    IF @BALANCE_BROKERAGE > 0                      
	       AND @SHARE_PER > 0                      
	      BEGIN                      
	        WHILE @CUR_BRANCH_CD = @BRANCH_CD                      
					  AND @CUR_SCHEMEID = @SCHEMEID 
					  AND @CUR_REM_PARTYCODE = @REM_PARTYCODE 
	              AND @@FETCH_STATUS = 0                      
	          BEGIN                      
	            IF @CUR_BRANCH_CD = @BRANCH_CD                      
						AND @CUR_SCHEMEID = @SCHEMEID                      
	               AND @CUR_REM_PARTYCODE = @REM_PARTYCODE                      
	               AND @BALANCE_BROKERAGE > 0                      
	               AND @CURBALANCE_BROKERAGE > 0                      
	               AND @SHARE_PER > 0                      
	               AND @@FETCH_STATUS = 0                      
	              BEGIN                      
	                IF @BALANCE_BROKERAGE >= @UPPER_LIMIT                      
	                  BEGIN                      
							  IF @VALPERC = 'P'
	                    		SET @REM_BROKERAGE = @REM_BROKERAGE + ((@UPPER_LIMIT - @LOWER_LIMIT) * @SHARE_PER / 100)                      
								ELSE	--- 'V'
	                    		SET @REM_BROKERAGE = @REM_BROKERAGE + @SHARE_PER

	                    SET @CURBALANCE_BROKERAGE = @CURBALANCE_BROKERAGE - (@UPPER_LIMIT - @LOWER_LIMIT)                      
	                    IF @CURBALANCE_BROKERAGE < 0                      
	                      SET @CURBALANCE_BROKERAGE = 0                      
	                  END                      
	                ELSE                      
	                  BEGIN      
							  IF @VALPERC = 'P'	                
	                    		SET @REM_BROKERAGE = @REM_BROKERAGE + @CURBALANCE_BROKERAGE * @SHARE_PER / 100                      
							  ELSE		--- 'V'
	                    		SET @REM_BROKERAGE = @REM_BROKERAGE + @SHARE_PER 

	                    SET @CURBALANCE_BROKERAGE = 0                     
	                    SET @BALANCE_BROKERAGE = 0             
	                  END                      
	              END                      
	              --SELECT @REMCODE, @BRANCH_CD, @SHARE_PER, @CURBALANCE_BROKERAGE, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT, @REM_BROKERAGE                      
	            FETCH NEXT FROM @REMCUR_BRANCH                      
	            INTO @SCHEMEID, 
	                 @BRANCH_CD,                      
	                 @SHARE_PER,                      
	                 @BALANCE_BROKERAGE,                      
	                 @LOWER_LIMIT,                      
	                 @UPPER_LIMIT,                      
	        			  @REM_PARTYCODE,
						  @VALPERC                      
	          END                      
	        UPDATE #ExchBranchSchemewiseBranch                      
	        SET    RemBrokPayable = @REM_BROKERAGE,                      
	               BalanceBrok = BalanceBrok - @REM_BROKERAGE--,                      
	           --REMPARTYCD = @CUR_REM_PARTYCODE, SlabType = 'INCR'                      
	        WHERE BranchCode = @CUR_BRANCH_CD  
					AND SCHEMEID = @SCHEMEID                    
					AND BranchParty = @CUR_REM_PARTYCODE
	                             
	      END                      
	    ELSE                      
	      BEGIN                      
	      --SELECT @REMCODE, @BRANCH_CD, @SHARE_PER, @CURBALANCE_BROKERAGE, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT, @REM_BROKERAGE                      
	        FETCH NEXT FROM @REMCUR_BRANCH                      
	        INTO @SCHEMEID, 
	             @BRANCH_CD,                      
	             @SHARE_PER,                      
	             @BALANCE_BROKERAGE,                      
	             @LOWER_LIMIT,                      
	             @UPPER_LIMIT,                      
	    			 @REM_PARTYCODE,
					 @VALPERC                       
	      END                      
	  END     

	CLOSE @REMCUR_BRANCH
	DEALLOCATE @REMCUR_BRANCH

	--- UPDATE RemBrokPayable #ExchPartywiseDetailsBranch table
	UPDATE #ExchPartywiseDetailsBranch SET 
				SharePercentage = B.SharePercentage,
				RemBrokPayable = CASE WHEN B.OrigBalanceBrok > 0 THEN (A.BalanceBrok*(B.RemBrokPayable/B.OrigBalanceBrok)) ELSE 0 END
	FROM 	#ExchPartywiseDetailsBranch A, #ExchBranchSchemewiseBranch B 
	WHERE 
	A.BranchCode = B.BranchCode
	AND A.SchemeID = B.SchemeID
	AND A.BranchParty = B.BranchParty
	AND A.SlabType = B.SlabType

	--- UPDATE RemBrokPayable #ExchBranchSchemewiseBranch table
	UPDATE #ExchPartyDatewiseDetailsBranch SET 
				SharePercentage = B.SharePercentage,
				RemBrokPayable = CASE WHEN B.BalanceBrok > 0 THEN (A.BalanceBrok*(B.RemBrokPayable/B.BalanceBrok)) ELSE 0 END
	FROM 	#ExchPartyDatewiseDetailsBranch A, #ExchPartywiseDetailsBranch B 
	WHERE 
	A.Segment = B.Segment
	AND A.Exchange = B.Exchange
	AND A.BranchCode = B.BranchCode
	AND A.PartyCode = B.PartyCode
	AND A.SchemeID = B.SchemeID
	AND A.BranchParty = B.BranchParty
	AND A.SlabType = B.SlabType

	select * from #ExchangeSubBrokerPartywise

	--- Remove the records where remisier brokerage is not set
	DELETE FROM #ExchangeSubBrokerPartywise WHERE ISNULL(SchemeID, 0) = 0

	select * from #ExchangeSubBrokerPartywise

--- Insert Branch Details into #ExchangeSubBrokerPartywise From 
	INSERT INTO #ExchangeSubBrokerPartywise(
			Segment,
			Exchange,
			SubBrokerCode,
			BranchCode,
			TurnOver,
			BrokEarned,
			RemBrok,
			RemBrokPayable,
			BalanceBrok,
			SchemeID,
			SchemeOrSlab,
			SubBrokParty,
			SlabType,
			SharePercentage)
	SELECT
			Segment,
			Exchange,
			SubBrokerCode= '',
			BranchCode,
			TurnOver = SUM(TurnOver),
			BrokEarned = SUM(BrokEarned),
			RemBrok = SUM(RemBrok),
			RemBrokPayable = SUM(RemBrokPayable),
			BalanceBrok = SUM(BalanceBrok),
			SchemeID,
			SchemeOrSlab='SLAB',
			SubBrokParty=BranchParty,
			SlabType,
			SharePercentage
	FROM #ExchPartywiseDetailsBranch
	GROUP BY
			Segment,
			Exchange,
			BranchCode,
			SchemeID,
			BranchParty,
			SlabType,
			SharePercentage

	UPDATE #ExchPartyDatewiseDetails SET 
		RemBrokPayableForBranch	= B.RemBrokPayable,
		BranchSchemeID = B.SchemeID,
		BranchParty = B.BranchParty
	FROM #ExchPartyDatewiseDetails A, #ExchPartyDatewiseDetailsBranch B
	WHERE 
		A.PartyCode = B.PartyCode
		AND A.Segment = B.Segment
		AND A.Exchange = B.Exchange
		--AND A.SubBrokerCode = B.SubBrokerCode		-- Since SBU Logic 
		AND A.BranchCode = B.BranchCode
		AND A.SaudaDate = B.SaudaDate

--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*

-- -- 	SELECT * INTO ##BROKTABLE_CM FROM #BROKTABLE_CM
-- -- 	SELECT * INTO ##REMBROK FROM #REMBROK
-- -- 	SELECT * INTO ##ExchPartyDatewiseDetails FROM #ExchPartyDatewiseDetails
-- -- 	SELECT * INTO ##ExchangeSubBrokerPartywise FROM #ExchangeSubBrokerPartywise
-- -- 	SELECT * INTO ##ExchPartywiseDetails FROM #ExchPartywiseDetails
-- -- 	SELECT * INTO ##ExchangeSubBrokSchemewise FROM #ExchangeSubBrokSchemewise
-- -- 
-- -- 	SELECT * INTO ##ExchPartyDatewiseDetailsBranch FROM #ExchPartyDatewiseDetailsBranch
-- -- 	SELECT * INTO ##ExchPartywiseDetailsBranch FROM #ExchPartywiseDetailsBranch
-- -- 	SELECT * INTO ##ExchBranchSchemewiseBranch FROM #ExchBranchSchemewiseBranch

	---- REMOVE THE EXISTING RECORDS IN THE RemisierBrokerageTrans TABLE	                  
	DELETE FROM RemisierBrokerageTrans WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE                      

	--select * from #ExchangeSubBrokerPartywise

	--select * from #ExchPartyDatewiseDetails

	--- Insert Records Into RemisierBrokerageTrans For Scheme Type Brokerage
	INSERT INTO RemisierBrokerageTrans
	(
		SETT_NO,
		SETT_TYPE,
		REMCODE,
		BRANCH_CD,
		SHARE_PER,
		SEGMENT,
		EXCHANGE,
		BROKERAGE,
		REMTYPE,
		FROMDATE,
		TODATE,
		REMPARTYCD,
		SLABTYPE,
		--REMBROKERAGE,
		REMBROKERAGEPAYABLE,
		REM_TDS,
		REM_ST,
		REM_CESS,
		REM_EDNCESS,
		TDSPERCENTAGE,
		BrokSchemeID
	)
	SELECT 
		SETT_NO = @SETT_NO,
		SETT_TYPE = @SETT_TYPE,
		REMCODE = R.SubBrokerCode,
		BRANCH_CD = R.BranchCode,
		SHARE_PER = R.SharePercentage, --CASE WHEN SchemeOrSlab = 'SLAB' THEN SharePercentage ELSE 0 END,
		SEGMENT = R.Segment,
		EXCHANGE = R.Exchange,
		BROKERAGE = R.BrokEarned,
		REMTYPE = CASE WHEN R.SubBrokerCode = '' THEN 'BR' ELSE 'SUB' END,
		FROMDATE = @FROMDATE,
		TODATE = @TODATE,
		REMPARTYCD = R.SubBrokParty,
		SLABTYPE = R.SlabType,
		--REMBROKERAGE = RemBrok,
		REMBROKERAGEPAYABLE = R.RemBrokPayable,
		REM_TDS =0,
		REM_ST = 0,
		REM_CESS =0,
		REM_EDNCESS = 0,
		TDSPERCENTAGE = ISNULL(S.TDSPercentage, @TDSPercentage),
		BrokSchemeID=SchemeID  
	FROM #ExchangeSubBrokerPartywise R 
      LEFT OUTER JOIN RemisierBrokerageTDS S                        
        ON (S.RemCode = CASE WHEN SubBrokerCode = '' THEN R.BranchCode ELSE R.SubBrokerCode END  
-- --     AND @FROMDATE >= S.FROMDATE                        
-- --             AND @TODATE <= S.TODATE )  
    AND @FROMDATE >= S.FROMDATE                        
            AND @TODATE <= S.TODATE )  
	WHERE ISNULL(RemBrokPayable, 0) > 0

	---- REMOVE THE EXISTING RECORDS IN THE RemisierBrokerageTransDatewise TABLE	    
	DELETE FROM RemisierBrokerageTransDatewise WHERE SettNo = @SETT_NO  AND SettType = @SETT_TYPE

	INSERT INTO RemisierBrokerageTransDatewise(
			SettNo,
			SettType,
			Segment,
			Exchange,
			SubBrokerCode,
			BranchCode,
			PartyCode,
			SaudaDate,
			TurnOver,
			BrokEarned,
			RemBrokPayable,
			BalanceBrok,
			SchemeID,
			BranchSchemeID,
			SubBrokerParty,
			BranchParty,
			RemBrokPayableForBranch)
	SELECT
			SettNo = @SETT_NO,
			SettType = @SETT_TYPE,
			Segment,
			Exchange,
			SubBrokerCode,
			BranchCode,
			PartyCode,
			SaudaDate=Convert(Char(11), SaudaDate,109),
			TurnOver,
			BrokEarned,
			RemBrokPayable,
			BalanceBrok,
			SchemeID,
			BranchSchemeID,
			SubBrokerParty=SubBrokParty,
			BranchParty,
			RemBrokPayableForBranch
	FROM #ExchPartyDatewiseDetails
	WHERE SchemeID <> 0 OR BranchSchemeID <> 0

	---- Post Entries From RemisierBrokerageTrans to REM_ACC_BILL Table
	EXEC ProcRemisierBrokeragePostAccBill @Sett_No, @Sett_Type, @FromDate, @ToDate

	DROP TABLE #BROKTABLE_CM
	DROP TABLE #BROKTABLE_FO
	DROP TABLE #BROKTABLE_NCDX
	DROP TABLE #BROKTABLE_MCDX
	DROP TABLE #RemisierAllParty
	DROP TABLE #RemisierSpecificParty
	DROP TABLE #RemisierBlockedParty
	DROP TABLE #PARTYLIST
	DROP TABLE #REMBROK
	DROP TABLE #FOREMBROK
	DROP TABLE #FOREMBROK_1
	DROP TABLE #NCDXREMBROK
	DROP TABLE #NCDXREMBROK_1
	DROP TABLE #MCDXREMBROK
	DROP TABLE #MCDXREMBROK_1
	DROP TABLE #ExchPartyDatewiseDetails
	DROP TABLE #ExchPartywiseDetails
	DROP TABLE #ExchangeSubBrokerPartywise
	DROP TABLE #ExchangeSubBrokSchemewise
	DROP TABLE #ExchPartyDatewiseDetailsBranch
	DROP TABLE #ExchPartywiseDetailsBranch
	DROP TABLE #ExchBranchSchemewiseBranch
	
	IF @@ERROR = 0 
		COMMIT TRANSACTION RemisierBrokergeComputation          
	ELSE
		ROLLBACK TRANSACTION RemisierBrokergeComputation          

END

/*


EXEC ProcRemisierBrokerageComputation '2006001', 'RM'

Select * From Rem_Brok_Trans
Select * From RemisierBrokerageTransDateWise
Select * From RemisierBrokerageTrans

Select * From Rem_AccBill

SELECT NARRATION, AMT=SUM(CASE SELL_BUY WHEN 1 THEN -AMOUNT ELSE AMOUNT END) FROM REM_ACCBILL
WHERE SETT_NO = '2006001'
GROUP BY NARRATION

SELECT EXCHANGE, PARTY_CODE, SELL_BUY, AMOUNT, BRANCHCD, NARRATION, BROK_SHARED_SETTNO, BILL_FOR FROM REM_ACCBILL 
WHERE SETT_NO = '2006001' 
ORDER BY BILL_FOR, EXCHANGE

*/

GO
