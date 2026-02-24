-- Object: VIEW citrus_usr.holding_AUDIT
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

      
CREATE view [citrus_usr].[holding_AUDIT]        
as        
select  CONVERT(VARCHAR(8), DPHMC_holding_dt, 112)  hld_hold_date         
,dpam_sba_no hld_ac_code         
, '' hld_cat         
, DPHMC_isin hld_isin_code         
,'' hld_ac_type         
        
,DPHMC_FREE_QTY FREE_QTY          
,DPHMC_FREEZE_QTY FREEZE_QTY        
,DPHMC_PLEDGE_QTY PLEDGE_QTY        
,DPHMC_DEMAT_PND_VER_QTY DEMAT_PND_VER_QTY        
,DPHMC_REMAT_PND_CONF_QTY REMAT_PND_CONF_QTY        
,DPHMC_DEMAT_PND_CONF_QTY DEMAT_PND_CONF_QTY        
,DPHMC_SAFE_KEEPING_QTY SAFE_KEEPING_QTY        
,DPHMC_LOCKIN_QTY LOCKIN_QTY        
,DPHMC_ELIMINATION_QTY ELIMINATION_QTY        
,DPHMC_EARMARK_QTY EARMARK_QTY        
,DPHMC_AVAIL_LEND_QTY AVAIL_LEND_QTY        
,DPHMC_LEND_QTY LEND_QTY        
,DPHMC_BORROW_QTY  BORROW_QTY         
,DPHMC_FREE_QTY+DPHMC_FREEZE_QTY+DPHMC_PLEDGE_QTY+DPHMC_DEMAT_PND_VER_QTY+DPHMC_REMAT_PND_CONF_QTY        
+DPHMC_DEMAT_PND_CONF_QTY+DPHMC_SAFE_KEEPING_QTY+DPHMC_LOCKIN_QTY+DPHMC_ELIMINATION_QTY+DPHMC_EARMARK_QTY        
+DPHMC_AVAIL_LEND_QTY+DPHMC_LEND_QTY+DPHMC_BORROW_QTY netqty         
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
,isnull(0.00,0.000) Rate         
,0.00       
Valuation        
,DPHMC_holding_dt HOLDINGDT, DPAM_BBO_CODE tradingid  , replace(replace(isnull(entm_short_name ,''),'_ba',''),'_br','') [branch]    
--,citrus_usr.[fn_find_relations_nm_forview](dpam_sba_no,'BR') BR     
 from dp_hldg_mstr_cdsl --holdingall_dumpforaudit         
left outer join isin_mstr on isin_cd = DPHMC_isin         
--left outer join (select max(CLOPM_DT) lastdt , clopm_isin_cd isincd from closing_price_mstr_cdsl where CLOPM_DT <= (select top 1 DPHMC_holding_dt from holdingallforview) and CLOPM_CDSL_RT <> 0  group by CLOPM_ISIN_CD ) lastdt         
------left outer join closing_price_mstr_cdsl         
--on DPHMC_isin  = isincd        
--left outer join closing_price_mstr_cdsl on lastdt = CLOPM_DT and isincd =  clopm_isin_cd        
--right outer join isin_mstr on isin_Cd = CLOPM_ISIN_CD         
,dp_acct_mstr--, client_ctgry_mstr , entity_type_mstr      
left outer join entity_relationship   on entr_sba = dpam_sba_no     
left outer join entity_mstr on (entm_id = entr_sb or entm_id = entr_br)    
--left outer join securitymstr on convert(numeric,sec_cd) = ISIN_SEC_TYPE        
where  dpam_id = DPHMC_dpam_id         
--and clicm_cd = dpam_clicm_Cd        
and getdate() between isnull(ENTR_FROM_DT,'jan 01 1900') and isnull(ENTR_TO_DT,'jan 01 2900')    
and ENTR_DELETED_IND = 1   
--and enttm_Cd = dpam_enttm_Cd

GO
