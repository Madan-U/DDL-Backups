-- Object: PROCEDURE dbo.PROC_NSEVALAN_DETAIL
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC [dbo].[PROC_NSEVALAN_DETAIL]
(
	@SETT_NO	VARCHAR(7),
	@SETT_TYPE	VARCHAR(2)
)

AS

DELETE FROM TBL_VALAN_DETAIL 
WHERE SETT_NO = @SETT_NO 
AND SETT_TYPE = @SETT_TYPE

INSERT INTO TBL_VALAN_DETAIL 
SELECT SETT_NO
	,SETT_TYPE
	,SAUDA_DATE = CONVERT(DATETIME, SAUDA_DATE)
	,PARTY_CODE
	,SCRIP_CD
	,SERIES
	,PAMT = SUM(PAMT)
	,SAMT = SUM(SAMT)
	,TRDTYPE
FROM (
	SELECT SETT_NO
		,SETT_TYPE
		,SAUDA_DATE = LEFT(SAUDA_DATE, 11)
		,S.PARTY_CODE
		,S.SCRIP_CD
		,S.SERIES
		,PAMT = SUM(ISNULL((
					CASE 
						WHEN SELL_BUY = 1
							THEN (
									CASE 
										WHEN SERVICE_CHRG = 2
											THEN (TRADEQTY * (N_NETRATE))
										ELSE (TRADEQTY * (N_NETRATE) + NSERTAX)
										END
									) + (
									CASE 
										WHEN DISPCHARGE = 1
											THEN (
													CASE 
														WHEN TURNOVER_TAX = 1
															THEN (TURN_TAX)
														ELSE 0
														END
													)
										ELSE 0
										END
									) + (
									CASE 
										WHEN DISPCHARGE = 1
											THEN (
													CASE 
														WHEN SEBI_TURN_TAX = 1
															THEN (SEBI_TAX)
														ELSE 0
														END
													)
										ELSE 0
										END
									) + (
									CASE 
										WHEN DISPCHARGE = 1
											THEN (
													CASE 
														WHEN INSURANCE_CHRG = 1
															THEN (INS_CHRG)
														ELSE 0
														END
													)
										ELSE 0
										END
									) + (
									CASE 
										WHEN DISPCHARGE = 1
											THEN (
													CASE 
														WHEN BROKERNOTE = 1
															THEN (BROKER_CHRG)
														ELSE 0
														END
													)
										ELSE 0
										END
									) + (
									CASE 
										WHEN DISPCHARGE = 1
											THEN (
													CASE 
														WHEN C2.OTHER_CHRG = 1
															OR AUCTIONPART LIKE 'F%'
															THEN (S.OTHER_CHRG)
														ELSE 0
														END
													)
										ELSE 0
										END
									)
						END
					), 0))
		,SAMT = SUM(ISNULL((
					CASE 
						WHEN SELL_BUY = 2
							THEN (
									CASE 
										WHEN SERVICE_CHRG = 2
											THEN (TRADEQTY * (N_NETRATE))
										ELSE (TRADEQTY * (N_NETRATE) - NSERTAX)
										END
									) - (
									CASE 
										WHEN DISPCHARGE = 1
											THEN (
													CASE 
														WHEN TURNOVER_TAX = 1
															THEN (TURN_TAX)
														ELSE 0
														END
													)
										ELSE 0
										END
									) - (
									CASE 
										WHEN DISPCHARGE = 1
											THEN (
													CASE 
														WHEN SEBI_TURN_TAX = 1
															THEN (SEBI_TAX)
														ELSE 0
														END
													)
										ELSE 0
										END
									) - (
									CASE 
										WHEN DISPCHARGE = 1
											THEN (
													CASE 
														WHEN INSURANCE_CHRG = 1
															THEN (INS_CHRG)
														ELSE 0
														END
													)
										ELSE 0
										END
									) - (
									CASE 
										WHEN DISPCHARGE = 1
											THEN (
													CASE 
														WHEN BROKERNOTE = 1
															THEN (BROKER_CHRG)
														ELSE 0
														END
													)
										ELSE 0
										END
									) - (
									CASE 
										WHEN DISPCHARGE = 1
											THEN (
													CASE 
														WHEN C2.OTHER_CHRG = 1
															OR AUCTIONPART LIKE 'F%'
															THEN (S.OTHER_CHRG)
														ELSE 0
														END
													)
										ELSE 0
										END
									)
						END
					), 0))
		,TRDTYPE = (
			CASE 
				WHEN SETTFLAG IN (
						2
						,3
						)
					THEN 'TRADING'
				ELSE 'DELIVERY'
				END
			)
	FROM ISETTLEMENT_VALAN S
		,CLIENT2 C2
		,OWNER
		,CLIENT1
	WHERE SETT_NO = @SETT_NO
		AND SETT_TYPE = @SETT_TYPE
		AND C2.PARTY_CODE = S.PARTY_CODE
		AND CLIENT1.CL_CODE = C2.CL_CODE
	GROUP BY SETT_NO
		,SETT_TYPE
		,LEFT(SAUDA_DATE, 11)
		,S.PARTY_CODE
		,S.SCRIP_CD
		,S.SERIES
		,SETTFLAG
	
	UNION ALL
		
	SELECT CD_SETT_NO
		,CD_SETT_TYPE
		,SAUDA_DATE = LEFT(CD_SAUDA_DATE, 11)
		,S.CD_PARTY_CODE
		,S.CD_SCRIP_CD
		,S.CD_SERIES
		,PAMT = SUM(CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE + CD_DELBUYBROKERAGE + CD_DELSELLBROKERAGE) + SUM(CASE 
				WHEN SERVICE_CHRG <> 2
					THEN (CD_TRDBUYSERTAX + CD_TRDSELLSERTAX + CD_DELBUYSERTAX + CD_DELSELLSERTAX)
				ELSE 0
				END)
		,SAMT = 0
		,TRDTYPE = 'TRADING'
	FROM CHARGES_DETAIL S
		,CLIENT2 C2
		,CLIENT1
		,OWNER
	WHERE C2.PARTY_CODE = S.CD_PARTY_CODE
		AND CLIENT1.CL_CODE = C2.CL_CODE
		AND S.CD_SETT_NO = @SETT_NO
		AND S.CD_SETT_TYPE = @SETT_TYPE
	GROUP BY CD_SETT_NO
		,CD_SETT_TYPE
		,LEFT(CD_SAUDA_DATE, 11)
		,S.CD_PARTY_CODE
		,S.CD_SCRIP_CD
		,S.CD_SERIES
	) A
GROUP BY SETT_NO
	,SETT_TYPE
	,SAUDA_DATE
	,PARTY_CODE
	,SCRIP_CD
	,SERIES
	,TRDTYPE
ORDER BY PARTY_CODE
		,SCRIP_CD
		,SERIES

GO
