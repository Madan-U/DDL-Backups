-- Object: PROCEDURE citrus_usr.CLI_DPBAL_New
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


CREATE PROC [citrus_usr].[CLI_DPBAL_New] (@CLTCODE VARCHAR(10))   
AS   



SELECT distinct *,RIGHT(CONVERT(VARCHAR(11),[NEXT AMC DT],113),9) AS MONTH_YEAR into #nise_party FROM (  
Select  dpam_sba_no AS Client_code ,dpam_bbo_code as nise_party_code , brom_desc,  
CONVERT(datetime, case when isnull(accp_value,'')  = '' then substring(BOActDt,5,4)+'-'+substring(BOActDt,3,2)+'-'+substring(BOActDt,1,2)+' 00:00:00.000'   
else isnull(accp_value,'') end) [AMC Date]  , CHAM_CHARGE_VALUE as amc_charge
,citrus_usr.Fn_get_nextamc(convert(datetime,CONVERT(datetime, case when isnull(accp_value,'')  = '' then substring(BOActDt,5,4)+'-'+substring(BOActDt,3,2)+'-'+substring(BOActDt,1,2)+' 00:00:00.000'   
else isnull(accp_value,'') end)),cham_charge_type,cham_bill_interval)[NEXT AMC DT]   
From dps8_pc1, dp_Acct_mstr left outer join account_properties on accp_clisba_id = dpam_id and accp_accpm_prop_cd = 'AMC_DT'   
,  client_dp_brkg , brokerage_mstr , charge_mstr ,profile_charges  
Where boid = dpam_sba_no and dpam_id = clidb_dpam_id and clidb_brom_id = brom_id   
and cham_slab_no = proc_slab_no and proc_profile_id = clidb_brom_id and proc_profile_id = brom_id   
And getdate() between clidb_eff_from_dt and clidb_eff_to_dt   
And cham_charge_type in ('F','AMCPRO')  
and dpam_deleted_ind = '1' and clidb_deleteD_ind = '1'   
and brom_deleted_ind = '1' and cham_deleted_ind = '1'  
and proc_deleted_ind = '1'  
and dpam_sba_no like '120%'  
and dpam_stam_cd = 'ACTIVE' )A  
WHERE NISE_PARTY_CODE =@CLTCODE



SELECT t.NISE_PARTY_CODE PARTY_CODE,t.CLIENT_CODE,isnull(amc_charge,0) AS AMC_DUE,isnull([NEXT AMC DT],'') AS AMCDATE,isnull(Actual_amount,'0') AS DP_LEDGER,   
isnull(Accrual_bal,0) Accrual_bal   
FROM  tbl_client_master t
left outer join   #nise_party S on t.client_code =s.client_code
left outer join   citrus_usr.Vw_Acc_Curr_Bal   v  on T.client_code= V.CLIENT_CODE    

where t.NISE_PARTY_CODE = @CLTCODE   
--union  
--SELECT 'j45628','j45628','0' AS AMC_DUE,'NA' AS AMCDATE,0 AS DP_LEDGER,   
--'0'  
      
      
    --CLI_DPBAL 'RP61'

GO
