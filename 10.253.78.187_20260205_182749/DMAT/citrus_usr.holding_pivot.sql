-- Object: VIEW citrus_usr.holding_pivot
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE view [citrus_usr].[holding_pivot]
as
select  CONVERT(VARCHAR(8), dphmcd_holding_dt, 112)  hld_hold_date	
,dpam_sba_no hld_ac_code	
, '' hld_cat	
, dphmcd_isin hld_isin_code	
,CITRUS_USR.FN_SPLITVAL_BY(bentype,1,'-') hld_ac_type	
,QTY
,''   hld_ccid	
,'' hld_market_type	
,'' hld_settlement	
,'' hld_blf	
,'' hld_blc	
,'' hld_lrd	
,'' hld_pendingdt
,isin_name SecurityName 
,isnull(ISIN_SECURITY_TYPE_DESCRIPTION,'')  SecurityType 
,CITRUS_USR.FN_SPLITVAL_BY(bentype,2,'-') BeneficiaryType 
,isnull(RATE,0.000) Rate 
,QTY * isnull(rate,0.000) Valuation
,dphmcd_holding_dt HOLDINGDT, tradingid
from (SELECT DPHMCD_DPM_ID
,DPHMCD_DPAM_ID
,DPHMCD_ISIN 
,dphmcd_holding_dt, case when bentype = 'DPHMCD_FREE_QTY' then '11-Beneficiary'
when bentype = 'DPHMCD_FREEZE_QTY' then '50-Frozed Balance'
when bentype = 'DPHMCD_PLEDGE_QTY' then '14-Pledge'
when bentype = 'DPHMCD_DEMAT_PND_VER_QTY' then '12-Pending Demat'
when bentype = 'DPHMCD_REMAT_PND_CONF_QTY' then '13-Pending Remat'
when bentype = 'DPHMCD_DEMAT_PND_CONF_QTY' then '12-Pending Demat'
when bentype = 'DPHMCD_SAFE_KEEPING_QTY' then 'DPHMCD_SAFE_KEEPING_QTY'
when bentype = 'DPHMCD_LOCKIN_QTY' then '51-Lock in Balance'
when bentype = 'DPHMCD_ELIMINATION_QTY' then 'DPHMCD_ELIMINATION_QTY'
when bentype = 'DPHMCD_EARMARK_QTY' then '52-Ear Marked'
when bentype = 'DPHMCD_AVAIL_LEND_QTY' then 'DPHMCD_AVAIL_LEND_QTY'
when bentype = 'DPHMCD_LEND_QTY' then 'DPHMCD_LEND_QTY'
when bentype = 'DPHMCD_BORROW_QTY' then 'DPHMCD_BORROW_QTY' END bentype

							 , qty ,  rate, tradingid
FROM 
(
  SELECT DPHMCD_DPM_ID
,DPHMCD_DPAM_ID
,DPHMCD_ISIN 
,dphmcd_holding_dt
,DPHMCD_FREE_QTY
,DPHMCD_FREEZE_QTY
,DPHMCD_PLEDGE_QTY
,DPHMCD_DEMAT_PND_VER_QTY
,DPHMCD_REMAT_PND_CONF_QTY
,DPHMCD_DEMAT_PND_CONF_QTY
,DPHMCD_SAFE_KEEPING_QTY
,DPHMCD_LOCKIN_QTY
,DPHMCD_ELIMINATION_QTY
,DPHMCD_EARMARK_QTY
,DPHMCD_AVAIL_LEND_QTY
,DPHMCD_LEND_QTY
,DPHMCD_BORROW_QTY   , rate, tradingid
FROM holdingallforview
) MyTable
UNPIVOT
(qty FOR bentype IN (DPHMCD_FREE_QTY
,DPHMCD_FREEZE_QTY
,DPHMCD_PLEDGE_QTY
,DPHMCD_DEMAT_PND_VER_QTY
,DPHMCD_REMAT_PND_CONF_QTY
,DPHMCD_DEMAT_PND_CONF_QTY
,DPHMCD_SAFE_KEEPING_QTY
,DPHMCD_LOCKIN_QTY
,DPHMCD_ELIMINATION_QTY
,DPHMCD_EARMARK_QTY
,DPHMCD_AVAIL_LEND_QTY
,DPHMCD_LEND_QTY
,DPHMCD_BORROW_QTY  ))AS MyUnPivot
where qty <> 0
) holdingallforview ,isin_mstr ,dp_acct_mstr --, client_ctgry_mstr , entity_type_mstr 
--,(select top 1 CLOPM_DT lastdt from closing_price_mstr_cdsl where CLOPM_DT < (select top 1 dphmcd_holding_dt from holdingallforview) order by 1 desc) lastdt 
--left outer join closing_price_mstr_cdsl on CLOPM_DT = lastdt 
--left outer join isin_mstr on isin_Cd = CLOPM_ISIN_CD 
--left outer join securitymstr on convert(numeric,sec_cd) = ISIN_SEC_TYPE
where  dpam_id = dphmcd_dpam_id 
--and clicm_cd = dpam_clicm_Cd
--and enttm_Cd = dpam_enttm_Cd
and dphmcd_isin = isin_Cd

GO
