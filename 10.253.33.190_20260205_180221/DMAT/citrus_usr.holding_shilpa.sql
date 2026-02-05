-- Object: VIEW citrus_usr.holding_shilpa
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE view [citrus_usr].[holding_shilpa]
as
select  CONVERT(VARCHAR(8), dphmcd_holding_dt, 112)  hld_hold_date	
,dpam_sba_no hld_ac_code	
, '' hld_cat	
, dphmcd_isin hld_isin_code	
,'' hld_ac_type	

,DPHMCD_FREE_QTY FREE_QTY  
,DPHMCD_FREEZE_QTY FREEZE_QTY
,DPHMCD_PLEDGE_QTY PLEDGE_QTY
,DPHMCD_DEMAT_PND_VER_QTY DEMAT_PND_VER_QTY
,DPHMCD_REMAT_PND_CONF_QTY REMAT_PND_CONF_QTY
,DPHMCD_DEMAT_PND_CONF_QTY DEMAT_PND_CONF_QTY
,DPHMCD_SAFE_KEEPING_QTY SAFE_KEEPING_QTY
,DPHMCD_LOCKIN_QTY LOCKIN_QTY
,DPHMCD_ELIMINATION_QTY ELIMINATION_QTY
,DPHMCD_EARMARK_QTY EARMARK_QTY
,DPHMCD_AVAIL_LEND_QTY AVAIL_LEND_QTY
,DPHMCD_LEND_QTY LEND_QTY
,DPHMCD_BORROW_QTY  BORROW_QTY 
,DPHMCD_FREE_QTY+DPHMCD_FREEZE_QTY+DPHMCD_PLEDGE_QTY+DPHMCD_DEMAT_PND_VER_QTY+DPHMCD_REMAT_PND_CONF_QTY
+DPHMCD_DEMAT_PND_CONF_QTY+DPHMCD_SAFE_KEEPING_QTY+DPHMCD_LOCKIN_QTY+DPHMCD_ELIMINATION_QTY+DPHMCD_EARMARK_QTY
+DPHMCD_AVAIL_LEND_QTY+DPHMCD_LEND_QTY+DPHMCD_BORROW_QTY netqty 
,''   hld_ccid	
,'' hld_market_type	
,'' hld_settlement	
,'' hld_blf	
,'' hld_blc	
,'' hld_lrd	
,'' hld_pendingdt
,isin_name SecurityName 
,isnull(ISIN_SECURITY_TYPE_DESCRIPTION,'')  SecurityType 
--,'' BeneficiaryType 
,isnull(CLOPM_CDSL_RT,0) Rate 
,(DPHMCD_FREE_QTY+DPHMCD_FREEZE_QTY+DPHMCD_PLEDGE_QTY+DPHMCD_DEMAT_PND_VER_QTY+DPHMCD_REMAT_PND_CONF_QTY
+DPHMCD_DEMAT_PND_CONF_QTY+DPHMCD_SAFE_KEEPING_QTY+DPHMCD_LOCKIN_QTY+DPHMCD_ELIMINATION_QTY+DPHMCD_EARMARK_QTY
+DPHMCD_AVAIL_LEND_QTY+DPHMCD_LEND_QTY+DPHMCD_BORROW_QTY)* isnull(CLOPM_CDSL_RT,0) Valuation
,dphmcd_holding_dt HOLDINGDT
from holdingallforview ,dp_acct_mstr, client_ctgry_mstr , entity_type_mstr 
,(select max(CLOPM_DT) lastdt ,clopm_isin_cd isin  from closing_price_mstr_cdsl,holdingallforview where CLOPM_DT < dphmcd_holding_dt and clopm_isin_cd = dphmcd_isin group by CLOPM_ISIN_CD ) lastdt 
left outer join closing_price_mstr_cdsl on CLOPM_DT = lastdt and clopm_isin_cd = isin
right outer join isin_mstr on isin_Cd = CLOPM_ISIN_CD 
--left outer join securitymstr on convert(numeric,sec_cd) = ISIN_SEC_TYPE
where  dpam_id = dphmcd_dpam_id 
and clicm_cd = dpam_clicm_Cd
and enttm_Cd = dpam_enttm_Cd
and dphmcd_isin = isin_Cd

GO
