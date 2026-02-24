-- Object: PROCEDURE dbo.RPT_COMBINED_CONTRACTNOTE
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE  PROC RPT_COMBINED_CONTRACTNOTE
	(
	@STATUSID VARCHAR(15),
	@STATUSNAME VARCHAR(25), 
	@FROMDATE VARCHAR(11),
	@TODATE VARCHAR(11),
	@SETT_TYPE VARCHAR(3),
	@FROMPARTY VARCHAR(15),
	@TOPARTY VARCHAR(15)
	)

	AS

	---EXEC RPT_COMBINED_CONTRACTNOTE 'BROKER','BROKER','Feb 16 2006','Feb 16 2006','','0','ZZZZZ'

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT
		C2.PARTY_CODE,
		FD_CODE,
		CLIENTNAME = C1.LONG_NAME,
		DPID = ISNULL(C4.BANKID,''),
		SERVICE_CHRG,
		OTHER_CHRG,
		INSURANCE_CHRG,
	        BROKERNOTE, 
	        TURNOVER_TAX, 
	        SEBI_TURN_TAX 

	INTO 	
		#CLIENTMASTER 
	FROM
		CLIENT1 C1 (NOLOCK),
		CLIENT2 C2 (NOLOCK)
			LEFT OUTER JOIN
			CLIENT4 C4 ON
			( 
			C2.PARTY_CODE = C4.PARTY_CODE
			AND DEPOSITORY IN ('NSDL','CDSL')
			AND DEFDP = 1
			)
	WHERE
		C1.CL_CODE = C2.CL_CODE
		AND C2.PARTY_CODE >= @FROMPARTY
		AND C2.PARTY_CODE <= @TOPARTY
                AND @STATUSNAME = (   
                CASE 
                        WHEN @STATUSID = 'BRANCH' 
                        THEN C1.BRANCH_CD 
                        WHEN @STATUSID = 'SUBBROKER' 
                        THEN C1.SUB_BROKER 
                        WHEN @STATUSID = 'TRADER' 
                        THEN C1.TRADER 
                        WHEN @STATUSID = 'FAMILY' 
                        THEN C1.FAMILY 
                        WHEN @STATUSID = 'AREA' 
                        THEN C1.AREA 
                        WHEN @STATUSID = 'REGION' 
                        THEN C1.REGION 
                        WHEN @STATUSID = 'CLIENT' 
                        THEN C2.PARTY_CODE 
                        ELSE 'BROKER' END) 

	----------------------------- DATA FROM SETTLEMENT -----------------------------

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT
		TRADEDATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11),
		YY = YEAR(SAUDA_DATE),
		MM = MONTH(SAUDA_DATE),
		DD = DAY(SAUDA_DATE),
		CLIENTID = S.PARTY_CODE,
		DPID = DPID,
		CLIENTNAME = CLIENTNAME,
		EXCHANGE = 'NSE',
		SETT_NO,
		NSESCRIP_CD = S.SCRIP_CD,
		BSESCRIP_CD = ' ',
		SCRIP_CD = S.SCRIP_CD,
		SCRIPNAME = S1.LONG_NAME,
		CONTRACTNO,
		SELLBUY = (CASE WHEN SELL_BUY = 1
				THEN 'BUY'
				ELSE 'SELL'
				END),
		QTY = SUM(TRADEQTY),
		MARKETRATE = SUM(TRADEQTY * MARKETRATE)/SUM(TRADEQTY),
		NETRATE = SUM(TRADEQTY * N_NETRATE)/SUM(TRADEQTY),
		BROKERAGE = SUM(TRADEQTY * NBROKAPP),
		SERVICE_TAX = SUM(CASE 
			        WHEN SERVICE_CHRG = 0 
			        THEN NSERTAX 
			        ELSE 0 END ),
		OTHER_CHRG = SUM(CASE 
			        WHEN C.OTHER_CHRG = 1 
			        THEN S.OTHER_CHRG 
			        ELSE 0 END ),
		NETAMOUNT = SUM(CASE WHEN SELL_BUY = 1
		                THEN TRADEQTY*(N_NETRATE + 
							(CASE WHEN SERVICE_CHRG = 1 
		                        THEN NSERTAX/TRADEQTY 
		                        ELSE 0 
								END )) +

									(CASE When SERVICE_CHRG <> 2 
										Then NSERTAX 
										Else 0 
										End) + 
									(CASE When INSURANCE_CHRG = 1 
										Then INS_CHRG 
										Else 0 
										End) + 
									(CASE When Turnover_tax = 1 
										Then turn_tax 
										Else 0 
										End) +
					                (CASE 
				                        WHEN BROKERNOTE = 1 
				                        THEN BROKER_CHRG 
				                        ELSE 0 
										END) +
									(CASE 
				                        WHEN SEBI_TURN_TAX = 1 
				                        THEN SEBI_TAX 
				                        ELSE 0 
										END) +			
									(CASE 
				                        WHEN C.OTHER_CHRG = 1 
				                        THEN S.OTHER_CHRG 
				                        ELSE 0 
										END )
		 
		                ELSE TRADEQTY*(N_NETRATE - 
							(CASE WHEN SERVICE_CHRG = 1 
		                       	THEN NSERTAX/TRADEQTY 
		                       	ELSE 0 
								END )) -

									(CASE When SERVICE_CHRG <> 2 
										Then NSERTAX 
										Else 0 
										End) - 
									(CASE When INSURANCE_CHRG = 1 
										Then INS_CHRG 
										Else 0 
										End) - 
									(CASE When Turnover_tax = 1 
										Then turn_tax 
										Else 0 
										End) -
					                (CASE 
				                        WHEN BROKERNOTE = 1 
				                        THEN BROKER_CHRG 
				                        ELSE 0 
										END) -
									(CASE 
				                        WHEN SEBI_TURN_TAX = 1 
				                        THEN SEBI_TAX 
				                        ELSE 0 
										END) -			
									(CASE 
				                        WHEN C.OTHER_CHRG = 1 
				                        THEN S.OTHER_CHRG 
				                        ELSE 0 
										END )
						END),			
		RBINO = FD_CODE,
		INS_CHRG = SUM(CASE 
			        WHEN INSURANCE_CHRG = 1 

			        THEN INS_CHRG 
			        ELSE 0 END )

	/*INTO 
		#SETT*/

	FROM
		SETTLEMENT S (NOLOCK),
		#CLIENTMASTER C (NOLOCK),
		SCRIP1 S1 (NOLOCK),
		SCRIP2 S2 (NOLOCK)

	WHERE
		S.PARTY_CODE   = C.PARTY_CODE
		AND S1.CO_CODE = S2.CO_CODE
		AND S1.SERIES  = S2.SERIES
		AND S.SCRIP_CD = S2.SCRIP_CD
		AND S.SERIES   = S1.SERIES
		AND S.SAUDA_DATE >= @FROMDATE
		AND S.SAUDA_DATE <= @TODATE + ' 23:59:59'
		AND S.SETT_TYPE LIKE @SETT_TYPE +'%'
		AND TRADEQTY > 0

	GROUP BY
		YEAR(SAUDA_DATE),
		MONTH(SAUDA_DATE),
		DAY(SAUDA_DATE),
		LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11),
		S.PARTY_CODE,
		DPID,
		CLIENTNAME,
		SETT_NO,
		S.SCRIP_CD,
		S1.LONG_NAME,
		CONTRACTNO,
		SELL_BUY,
		FD_CODE

	----------------------------- DATA FROM ISETTLEMENT -----------------------------
	UNION

	/*SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	INSERT INTO
		#SETT*/
	SELECT
		TRADEDATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11),
		YY = YEAR(SAUDA_DATE),
		MM = MONTH(SAUDA_DATE),
		DD = DAY(SAUDA_DATE),
		CLIENTID = S.PARTY_CODE,
		DPID = DPID,
		CLIENTNAME = CLIENTNAME,
		EXCHANGE = 'NSE',
		SETT_NO,
		NSESCRIP_CD = S.SCRIP_CD,
		BSESCRIP_CD = ' ',
		SCRIP_CD = S.SCRIP_CD,
		SCRIPNAME = S1.LONG_NAME,
		CONTRACTNO,
		SELLBUY = (CASE WHEN SELL_BUY = 1
				THEN 'BUY'
				ELSE 'SELL'
				END),
		QTY = SUM(TRADEQTY),
		MARKETRATE = SUM(TRADEQTY * MARKETRATE)/SUM(TRADEQTY),
		NETRATE = SUM(TRADEQTY * N_NETRATE)/SUM(TRADEQTY),
		BROKERAGE = SUM(TRADEQTY * NBROKAPP),
		SERVICE_TAX = SUM(CASE 
			        WHEN SERVICE_CHRG = 0 
			        THEN NSERTAX 
			        ELSE 0 END ),
		OTHER_CHRG = SUM(CASE 
			        WHEN C.OTHER_CHRG = 1 
			        THEN S.OTHER_CHRG 
			        ELSE 0 END ),
		NETAMOUNT = SUM(CASE WHEN SELL_BUY = 1
		                THEN TRADEQTY*(N_NETRATE + 
							(CASE WHEN SERVICE_CHRG = 1 
		                        THEN NSERTAX/TRADEQTY 
		                        ELSE 0 
								END )) +

									(CASE When SERVICE_CHRG <> 2 
										Then NSERTAX 
										Else 0 
										End) + 
									(CASE When INSURANCE_CHRG = 1 
										Then INS_CHRG 
										Else 0 
										End) + 
									(CASE When Turnover_tax = 1 
										Then turn_tax 
										Else 0 
										End) +
					                (CASE 
				                        WHEN BROKERNOTE = 1 
				                        THEN BROKER_CHRG 
				                        ELSE 0 
										END) +
									(CASE 
				                        WHEN SEBI_TURN_TAX = 1 
				                        THEN SEBI_TAX 
				                        ELSE 0 
										END) +			
									(CASE 
				                        WHEN C.OTHER_CHRG = 1 
				                        THEN S.OTHER_CHRG 
				                        ELSE 0 
										END )
		 
		                ELSE TRADEQTY*(N_NETRATE - 
							(CASE WHEN SERVICE_CHRG = 1 
		                       	THEN NSERTAX/TRADEQTY 
		                       	ELSE 0 
								END )) -

									(CASE When SERVICE_CHRG <> 2 
										Then NSERTAX 
										Else 0 
										End) - 
									(CASE When INSURANCE_CHRG = 1 
										Then INS_CHRG 
										Else 0 
										End) - 
									(CASE When Turnover_tax = 1 
										Then turn_tax 
										Else 0 
										End) -
					                (CASE 
				                        WHEN BROKERNOTE = 1 
				                        THEN BROKER_CHRG 
				                        ELSE 0 
										END) -
									(CASE 
				                        WHEN SEBI_TURN_TAX = 1 
				                        THEN SEBI_TAX 
				                        ELSE 0 
										END) -			
									(CASE 
				                        WHEN C.OTHER_CHRG = 1 
				                        THEN S.OTHER_CHRG 
				                        ELSE 0 
										END )
						END),			
		RBINO = FD_CODE,
		INS_CHRG = SUM(CASE 
			        WHEN INSURANCE_CHRG = 1 

			        THEN INS_CHRG 
			        ELSE 0 END )

	FROM
		ISETTLEMENT S (NOLOCK),
		#CLIENTMASTER C (NOLOCK),
		SCRIP1 S1 (NOLOCK),
		SCRIP2 S2 (NOLOCK)

	WHERE
		S.PARTY_CODE   = C.PARTY_CODE
		AND S1.CO_CODE = S2.CO_CODE
		AND S1.SERIES  = S2.SERIES
		AND S.SCRIP_CD = S2.SCRIP_CD
		AND S.SERIES   = S1.SERIES
		AND S.SAUDA_DATE >= @FROMDATE
		AND S.SAUDA_DATE <= @TODATE + ' 23:59:59'
		AND S.SETT_TYPE LIKE @SETT_TYPE +'%'
		AND TRADEQTY > 0

	GROUP BY
		YEAR(SAUDA_DATE),
		MONTH(SAUDA_DATE),
		DAY(SAUDA_DATE),
		LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11),
		S.PARTY_CODE,
		DPID,
		CLIENTNAME,
		SETT_NO,
		S.SCRIP_CD,
		S1.LONG_NAME,
		CONTRACTNO,
		SELL_BUY,
		FD_CODE


	----------------------------- DATA FROM BSEDB SETTLEMENT -----------------------------
	UNION

	/*SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	INSERT INTO
		#SETT*/
	SELECT
		TRADEDATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11),
		YY = YEAR(SAUDA_DATE),
		MM = MONTH(SAUDA_DATE),
		DD = DAY(SAUDA_DATE),
		CLIENTID = S.PARTY_CODE,
		DPID = DPID,
		CLIENTNAME = CLIENTNAME,
		EXCHANGE = 'BSE',
		SETT_NO,
		NSESCRIP_CD = ' ',
		BSESCRIP_CD = S.SCRIP_CD,
		SCRIP_CD = S.SCRIP_CD,
		SCRIPNAME = S1.LONG_NAME,
		CONTRACTNO,
		SELLBUY = (CASE WHEN SELL_BUY = 1
				THEN 'BUY'
				ELSE 'SELL'
				END),
		QTY = SUM(TRADEQTY),
		MARKETRATE = SUM(TRADEQTY * MARKETRATE)/SUM(TRADEQTY),
		NETRATE = SUM(TRADEQTY * N_NETRATE)/SUM(TRADEQTY),
		BROKERAGE = SUM(TRADEQTY * NBROKAPP),
		SERVICE_TAX = SUM(CASE 
			        WHEN SERVICE_CHRG = 0 
			        THEN NSERTAX 
			        ELSE 0 END ),
		OTHER_CHRG = SUM(CASE 
			        WHEN C.OTHER_CHRG = 1 
			        THEN S.OTHER_CHRG 
			        ELSE 0 END ),
		NETAMOUNT = SUM(CASE WHEN SELL_BUY = 1
		                THEN TRADEQTY*(N_NETRATE + 
							(CASE WHEN SERVICE_CHRG = 1 
		                        THEN NSERTAX/TRADEQTY 
		                        ELSE 0 
								END )) +

									(CASE When SERVICE_CHRG <> 2 
										Then NSERTAX 
										Else 0 
										End) + 
									(CASE When INSURANCE_CHRG = 1 
										Then INS_CHRG 
										Else 0 
										End) + 
									(CASE When Turnover_tax = 1 
										Then turn_tax 
										Else 0 
										End) +
					                (CASE 
				                        WHEN BROKERNOTE = 1 
				                        THEN BROKER_CHRG 
				                        ELSE 0 
										END) +
									(CASE 
				                        WHEN SEBI_TURN_TAX = 1 
				                        THEN SEBI_TAX 
				                        ELSE 0 
										END) +			
									(CASE 
				                        WHEN C.OTHER_CHRG = 1 
				                        THEN S.OTHER_CHRG 
				                        ELSE 0 
										END )
		 
		                ELSE TRADEQTY*(N_NETRATE - 
							(CASE WHEN SERVICE_CHRG = 1 
		                       	THEN NSERTAX/TRADEQTY 
		                       	ELSE 0 
								END )) -

									(CASE When SERVICE_CHRG <> 2 
										Then NSERTAX 
										Else 0 
										End) - 
									(CASE When INSURANCE_CHRG = 1 
										Then INS_CHRG 
										Else 0 
										End) - 
									(CASE When Turnover_tax = 1 
										Then turn_tax 
										Else 0 
										End) -
					                (CASE 
				                        WHEN BROKERNOTE = 1 
				                        THEN BROKER_CHRG 
				                        ELSE 0 
										END) -
									(CASE 
				                        WHEN SEBI_TURN_TAX = 1 
				                        THEN SEBI_TAX 
				                        ELSE 0 
										END) -			
									(CASE 
				                        WHEN C.OTHER_CHRG = 1 
				                        THEN S.OTHER_CHRG 
				                        ELSE 0 
										END )
						END),			
		RBINO = FD_CODE,
		INS_CHRG = SUM(CASE 
			        WHEN INSURANCE_CHRG = 1 
			        THEN INS_CHRG 
			        ELSE 0 END )
	
	FROM
		BSEDB.DBO.SETTLEMENT S (NOLOCK),
		#CLIENTMASTER C (NOLOCK),
		BSEDB.DBO.SCRIP1 S1 (NOLOCK),
		BSEDB.DBO.SCRIP2 S2 (NOLOCK)

	WHERE
		S.PARTY_CODE   = C.PARTY_CODE
		AND S1.CO_CODE = S2.CO_CODE
		AND S1.SERIES  = S2.SERIES
		AND S.SCRIP_CD = S2.BSECODE
		AND S.SAUDA_DATE >= @FROMDATE
		AND S.SAUDA_DATE <= @TODATE + ' 23:59:59'
		AND S.SETT_TYPE LIKE @SETT_TYPE +'%'
		AND TRADEQTY > 0

	GROUP BY
		YEAR(SAUDA_DATE),
		MONTH(SAUDA_DATE),
		DAY(SAUDA_DATE),
		LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11),
		S.PARTY_CODE,
		DPID,
		CLIENTNAME,
		SETT_NO,
		S.SCRIP_CD,
		S1.LONG_NAME,
		CONTRACTNO,
		SELL_BUY,
		FD_CODE


	----------------------------- DATA FROM BSEDB ISETTLEMENT -----------------------------

	UNION


	/*SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	INSERT INTO
		#SETT*/
	SELECT
		TRADEDATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11),
		YY = YEAR(SAUDA_DATE),
		MM = MONTH(SAUDA_DATE),
		DD = DAY(SAUDA_DATE),
		CLIENTID = S.PARTY_CODE,
		DPID = DPID,
		CLIENTNAME = CLIENTNAME,
		EXCHANGE = 'BSE',
		SETT_NO,
		NSESCRIP_CD = ' ',
		BSESCRIP_CD = S.SCRIP_CD,
		SCRIP_CD = S.SCRIP_CD,
		SCRIPNAME = S1.LONG_NAME,
		CONTRACTNO,
		SELLBUY = (CASE WHEN SELL_BUY = 1
				THEN 'BUY'
				ELSE 'SELL'
				END),
		QTY = SUM(TRADEQTY),
		MARKETRATE = SUM(TRADEQTY * MARKETRATE)/SUM(TRADEQTY),
		NETRATE = SUM(TRADEQTY * N_NETRATE)/SUM(TRADEQTY),
		BROKERAGE = SUM(TRADEQTY * NBROKAPP),
		SERVICE_TAX = SUM(CASE 
			        WHEN SERVICE_CHRG = 0 
			        THEN NSERTAX 
			        ELSE 0 END ),
		OTHER_CHRG = SUM(CASE 
			        WHEN C.OTHER_CHRG = 1 
			        THEN S.OTHER_CHRG 
			        ELSE 0 END ),
		NETAMOUNT = SUM(CASE WHEN SELL_BUY = 1
		                THEN TRADEQTY*(N_NETRATE + 
							(CASE WHEN SERVICE_CHRG = 1 
		                        THEN NSERTAX/TRADEQTY 
		                        ELSE 0 
								END )) +

									(CASE When SERVICE_CHRG <> 2 
										Then NSERTAX 
										Else 0 
										End) + 
									(CASE When INSURANCE_CHRG = 1 
										Then INS_CHRG 
										Else 0 
										End) + 
									(CASE When Turnover_tax = 1 
										Then turn_tax 
										Else 0 
										End) +
					                (CASE 
				                        WHEN BROKERNOTE = 1 
				                        THEN BROKER_CHRG 
				                        ELSE 0 
										END) +
									(CASE 
				                        WHEN SEBI_TURN_TAX = 1 
				                        THEN SEBI_TAX 
				                        ELSE 0 
										END) +			
									(CASE 
				                        WHEN C.OTHER_CHRG = 1 
				                        THEN S.OTHER_CHRG 
				                        ELSE 0 
										END )
		 
		                ELSE TRADEQTY*(N_NETRATE - 
							(CASE WHEN SERVICE_CHRG = 1 
		                       	THEN NSERTAX/TRADEQTY 
		                       	ELSE 0 
								END )) -

									(CASE When SERVICE_CHRG <> 2 
										Then NSERTAX 
										Else 0 
										End) - 
									(CASE When INSURANCE_CHRG = 1 
										Then INS_CHRG 
										Else 0 
										End) - 
									(CASE When Turnover_tax = 1 
										Then turn_tax 
										Else 0 
										End) -
					                (CASE 
				                        WHEN BROKERNOTE = 1 
				                        THEN BROKER_CHRG 
				                        ELSE 0 
										END) -
									(CASE 
				                        WHEN SEBI_TURN_TAX = 1 
				                        THEN SEBI_TAX 
				                        ELSE 0 
										END) -			
									(CASE 
				                        WHEN C.OTHER_CHRG = 1 
				                        THEN S.OTHER_CHRG 
				                        ELSE 0 
										END )
						END),			
 
		RBINO = FD_CODE,
		INS_CHRG = SUM(CASE 
			        WHEN INSURANCE_CHRG = 1 
			        THEN INS_CHRG 
			        ELSE 0 END )
	
	FROM
		BSEDB.DBO.ISETTLEMENT S (NOLOCK),
		#CLIENTMASTER C (NOLOCK),
		BSEDB.DBO.SCRIP1 S1 (NOLOCK),
		BSEDB.DBO.SCRIP2 S2 (NOLOCK)

	WHERE
		S.PARTY_CODE   = C.PARTY_CODE
		AND S1.CO_CODE = S2.CO_CODE
		AND S1.SERIES  = S2.SERIES
		AND S.SCRIP_CD = S2.BSECODE
		AND S.SAUDA_DATE >= @FROMDATE
		AND S.SAUDA_DATE <= @TODATE + ' 23:59:59'
		AND S.SETT_TYPE LIKE @SETT_TYPE +'%'
		AND TRADEQTY > 0

	GROUP BY
		YEAR(SAUDA_DATE),
		MONTH(SAUDA_DATE),
		DAY(SAUDA_DATE),
		LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11),
		S.PARTY_CODE,
		DPID,
		CLIENTNAME,
		SETT_NO,
		S.SCRIP_CD,
		S1.LONG_NAME,
		CONTRACTNO,
		SELL_BUY,
		FD_CODE

	-----------------------------------------------------------------------

	/*
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT
		*
	FROM
		#SETT*/

	ORDER BY
		YY,
		MM,
		DD,
		CLIENTID,
		CONTRACTNO,
		SCRIP_CD,
		NSESCRIP_CD,
		BSESCRIP_CD,
		SELLBUY

	-----------------------------------------------------------------------

GO
