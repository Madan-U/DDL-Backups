-- Object: PROCEDURE citrus_usr.pr_get_holding_summary
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create proc pr_get_holding_summary(@pa_for_date datetime
, @pa_from_boid varchar(100)
, @pa_to_boid varchar(100)
, @pa_holdingtype varchar(100)
, @pa_status varchar(100)
)
as
begin 



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
	
	
	SELECT DPAM_SBA_NO , DPAM_SBA_NAME , '' FACODE, '' FAMCODE, DPAM_ACCT_NO DP_REF_NO 
	, PriPhNum MOBILE , BOActDt ,DPHMCD_ISIN , DPHMCD_CURR_QTY 
	, rate=  (select top 1 CLOPM_CDSL_RT from closing_price_mstr_cdsl where CLOPM_ISIN_CD = DPHMCD_ISIN and CLOPM_DT <=@pa_for_date  order by CLOPM_DT desc )
	INTO #TEMPDATA 
	FROM #tmphldg 
	LEFT OUTER JOIN DP_ACCT_MSTR ON DPAM_ID = DPHMCD_DPAM_ID 
	LEFT OUTER JOIN dps8_pc1 ON BOId = DPAM_SBA_NO 
			

end

GO
