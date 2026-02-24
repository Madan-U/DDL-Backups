-- Object: PROCEDURE citrus_usr.pr_get_holding_summary_KARVY
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--exec pr_get_holding_summary_KARVY 'nov 14 2018','1203320015335949','1203320015397757','',''
CREATE proc [citrus_usr].[pr_get_holding_summary_KARVY](@pa_for_date datetime
, @pa_from_boid varchar(100)
, @pa_to_boid varchar(100)
, @pa_holdingtype varchar(100)
, @pa_status varchar(100)
)
as
begin 


DECLARE @L_FIN_ID NUMERIC
SELECT @L_FIN_ID = FIN_ID FROM FINANCIAL_YR_MSTR  WHERE @pa_for_date BETWEEN FIN_START_DT AND FIN_END_DT AND FIN_DELETED_IND = 1 

DECLARE @L_SQL VARCHAR(8000)
SET @L_SQL = ''
SET @L_SQL = ' SELECT LDG_ACCOUNT_ID , SUM(LDG_AMOUNT) BALANCE INTO ##BALANCE_AMOUNT FROM LEDGER'+CONVERT(VARCHAR,@L_FIN_ID) +' WHERE LDG_ACCOUNT_TYPE =''p''  AND LDG_DELETED_IND = 1 
GROUP BY LDG_ACCOUNT_ID  ' 

EXEC (@L_SQL)


create table #tmphldg 
(
	[DPHMCD_DPM_ID] [numeric](18, 0) NOT NULL,
	[DPHMCD_DPAM_ID] [numeric](10, 0) NOT NULL,
	[DPHMCD_ISIN] [varchar](20) NOT NULL,
	[DPHMCD_CURR_QTY] [numeric](18, 3) NULL,
	[DPHMCD_FREE_QTY] [numeric](18, 3) NULL,
	[DPHMCD_FREEZE_QTY] [numeric](18, 3) NULL,
	[DPHMCD_PLEDGE_QTY] [numeric](18, 3) NULL,
	[DPHMCD_DEMAT_PND_VER_QTY] [numeric](18, 3) NULL,
	[DPHMCD_REMAT_PND_CONF_QTY] [numeric](18, 3) NULL,
	[DPHMCD_DEMAT_PND_CONF_QTY] [numeric](18, 3) NULL,
	[DPHMCD_SAFE_KEEPING_QTY] [numeric](18, 3) NULL,
	[DPHMCD_LOCKIN_QTY] [numeric](18, 3) NULL,
	[DPHMCD_ELIMINATION_QTY] [numeric](18, 3) NULL,
	[DPHMCD_EARMARK_QTY] [numeric](18, 3) NULL,
	[DPHMCD_AVAIL_LEND_QTY] [numeric](18, 3) NULL,
	[DPHMCD_LEND_QTY] [numeric](18, 3) NULL,
	[DPHMCD_BORROW_QTY] [numeric](18, 3) NULL,
	[dphmcd_holding_dt] datetime
--, rate numeric(18,3),tradingid varchar(100)
	)  
	
	insert into  #tmphldg
	exec  [pr_get_holding_fix_latest]   3,@PA_FOR_DATE,@PA_FOR_DATE,@pa_from_boid,@pa_to_boid,''
	
	
	
	SELECT DPAM_ID , DPAM_SBA_NO , DPAM_SBA_NAME , '' FACODE, '' FAMCODE, DPAM_ACCT_NO DP_REF_NO 
	, PriPhNum MOBILE , BOActDt ,DPHMCD_ISIN ISIN , DPHMCD_CURR_QTY 
	, rate=  (select top 1 CLOPM_CDSL_RT from closing_price_mstr_cdsl where CLOPM_ISIN_CD = DPHMCD_ISIN and CLOPM_DT <=@pa_for_date  order by CLOPM_DT desc )
	INTO #TEMPDATA_HOLDING
	FROM #tmphldg 
	LEFT OUTER JOIN DP_ACCT_MSTR ON DPAM_ID = DPHMCD_DPAM_ID 
	LEFT OUTER JOIN dps8_pc1 ON BOId = DPAM_SBA_NO 
			
			
	 SELECT 	DPAM_SBA_NO , DPAM_SBA_NAME, FACODE,	FAMCODE,DP_REF_NO,MOBILE,LEFT(BOActDt,2)+'/'+SUBSTRING(BOActDt,3,2)+'/' + RIGHT(BOActDt,4) ACTIVATIONDATE, COUNT(ISIN ) NOOFISIN 
	 , SUM(DPHMCD_CURR_QTY*RATE) VALUATION
	 ,  BALANCE
	 , (SELECT MAX(CDSHM_TRAS_DT) FROM CDSL_HOLDING_DTLS WHERE CDSHM_BEN_ACCT_NO = DPAM_SBA_NO AND CDSHM_TRAS_DT < = @pa_for_date ) LASTTRADEDDT
	 --into ytemphldkalp16112018
	 FROM #TEMPDATA_HOLDING LEFT OUTER JOIN ##BALANCE_AMOUNT ON DPAM_ID  = LDG_ACCOUNT_ID 
	 GROUP BY  DPAM_SBA_NO , DPAM_SBA_NAME, FACODE,	FAMCODE,DP_REF_NO,MOBILE,BOActDt, BALANCE
	 
	 
    DROP TABLE #TEMPDATA_HOLDING	
    DROP TABLE ##BALANCE_AMOUNT
	
end

GO
