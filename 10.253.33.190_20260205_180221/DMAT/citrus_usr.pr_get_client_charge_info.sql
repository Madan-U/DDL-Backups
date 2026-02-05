-- Object: PROCEDURE citrus_usr.pr_get_client_charge_info
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_get_client_charge_info](@pa_dpmdpid varchar(8),@pa_flag char(100),@pa_month numeric,@pa_year numeric,@pa_client varchar(16))      
as      
begin      
      
      
DECLARE @L_DPM_ID NUMERIC      
      
      
if @pa_dpmdpid <> 'ALL'      
begin      
      
      
 SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DPM_DPID = @pa_dpmdpid       
      
 if @pa_flag = 'B-all' AND @pa_client = 'all'      
 begin      
      
  select dpam_sba_no ,sum(clic_charge_amt), brom_desc      
  from CLIENT_CHARGES_CDSL , DP_ACCT_MSTR , CLIENT_DP_BRKG , BROKERAGE_MSTR       
  WHERE CLIC_DPM_ID = @L_DPM_ID       
  AND MONTH(CLIC_TRANS_DT)= @pa_month       
  AND YEAR(CLIC_TRANS_DT) = @pa_year      
  AND CLIC_DPAM_ID = DPAM_ID      
  AND DPAM_ID = CLIDB_DPAM_ID       
  AND CLIDB_BROM_ID = BROM_ID       
  AND CLIC_TRANS_DT BETWEEN clidb_eff_from_dt AND ISNULL(clidb_eff_to_dt,'DEC 31 2100')      
  GROUP BY dpam_sba_no , brom_desc      
  ORDER BY dpam_sba_no      
        
 end       
 ELSE if @pa_flag = 'B-all' AND @pa_client <> ''      
 begin      
      
  select dpam_sba_no ,sum(clic_charge_amt), brom_desc      
  from CLIENT_CHARGES_CDSL , DP_ACCT_MSTR , CLIENT_DP_BRKG , BROKERAGE_MSTR       
  WHERE CLIC_DPM_ID = @L_DPM_ID       
  AND MONTH(CLIC_TRANS_DT)= @pa_month       
  AND YEAR(CLIC_TRANS_DT) = @pa_year      
  AND DPAM_SBA_NO = @pa_client      
  AND CLIC_DPAM_ID = DPAM_ID      
  AND DPAM_ID = CLIDB_DPAM_ID       
  AND CLIDB_BROM_ID = BROM_ID       
  AND CLIC_TRANS_DT BETWEEN clidb_eff_from_dt AND ISNULL(clidb_eff_to_dt,'DEC 31 2100')      
  GROUP BY dpam_sba_no , brom_desc      
  ORDER BY dpam_sba_no      
        
 end       
 ELSE if @pa_flag = 'B-DETAILS' AND @pa_client = 'all'      
 begin      
      
  select CLIC_CHARGE_NAME ,dpam_sba_no , sum(clic_charge_amt), brom_desc      
  from CLIENT_CHARGES_CDSL , DP_ACCT_MSTR , CLIENT_DP_BRKG , BROKERAGE_MSTR       
  WHERE CLIC_DPM_ID = @L_DPM_ID       
  AND MONTH(CLIC_TRANS_DT)= @pa_month       
  AND YEAR(CLIC_TRANS_DT) = @pa_year      
  AND CLIC_DPAM_ID = DPAM_ID      
  AND DPAM_ID = CLIDB_DPAM_ID       
  AND CLIDB_BROM_ID = BROM_ID       
  AND CLIC_TRANS_DT BETWEEN clidb_eff_from_dt AND ISNULL(clidb_eff_to_dt,'DEC 31 2100')      
  GROUP BY CLIC_CHARGE_NAME,dpam_sba_no , brom_desc      
  ORDER BY dpam_sba_no      
        
 end       
 ELSE if @pa_flag = 'B-DETAILS' AND @pa_client <> ''      
 begin      
      print 'dsdsds'
  select CLIC_CHARGE_NAME,dpam_sba_no , sum(clic_charge_amt), brom_desc      
  from CLIENT_CHARGES_CDSL , DP_ACCT_MSTR , CLIENT_DP_BRKG , BROKERAGE_MSTR       
  WHERE CLIC_DPM_ID = @L_DPM_ID       
  AND MONTH(CLIC_TRANS_DT)= @pa_month       
  AND YEAR(CLIC_TRANS_DT) = @pa_year      
  AND DPAM_SBA_NO = @pa_client      
  AND CLIC_DPAM_ID = DPAM_ID      
  AND DPAM_ID = CLIDB_DPAM_ID       
  AND CLIDB_BROM_ID = BROM_ID       
  AND CLIC_TRANS_DT BETWEEN clidb_eff_from_dt AND ISNULL(clidb_eff_to_dt,'DEC 31 2100')      
  GROUP BY CLIC_CHARGE_NAME,dpam_sba_no , brom_desc      
  ORDER BY dpam_sba_no      
        
 end       
 ELSE if @pa_flag = 'C-DETAILS' AND @pa_client <> ''      
 begin      
      
  select C.*      
  from CHARGE_MSTR C, PROFILE_CHARGES , CLIENT_DP_BRKG, DP_ACCT_MSTR      
  WHERE CHAM_SLAB_NO = PROC_SLAB_NO       
  AND PROC_PROFILE_ID = CLIDB_BROM_ID       
  AND DPAM_ID = CLIDB_DPAM_ID       
  AND DPAM_SBA_NO = @pa_client      
  AND GETDATE() BETWEEN clidb_eff_from_dt AND ISNULL(clidb_eff_to_dt ,'DEC 31 2100')      
 end       
 ELSE if @pa_flag = 'T-DETAILS' AND @pa_client <> ''      
 begin      
      
  select cdshm_tras_dt,cdshm_ben_acct_no,CDSHM_TRANS_NO,CDSHM_ISIN,cdshm_qty,cdshm_tratm_type_desc,CDSHM_COUNTER_BOID    
,CDSHM_COUNTER_DPID    
,CDSHM_COUNTER_CMBPID    
,cdshm_charge , CDSHM_DP_CHARGE     
  from cdsl_holding_dtls C      
  WHERE cdshm_ben_acct_no = @pa_client      
  and month(CDSHM_TRAS_DT) = @pa_month      
  and year(CDSHM_TRAS_DT) = @pa_year      
  and cdshm_charge <> 0       
 end       
      
end       
      
end

GO
