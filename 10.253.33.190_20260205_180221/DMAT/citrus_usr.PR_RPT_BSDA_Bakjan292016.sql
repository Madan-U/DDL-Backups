-- Object: PROCEDURE citrus_usr.PR_RPT_BSDA_Bakjan292016
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select dpm_excsm_id,* from dp_mstr where default_dp = dpm_id
--EXEC PR_RPT_BSDA '4','','','',''
create  procedure [citrus_usr].[PR_RPT_BSDA_Bakjan292016]
(
--@PA_DPM_ID INT
--,@PA_FROM_ACC VARCHAR(16)
--,@PA_TO_ACC VARCHAR(16)
--,@PA_EFF_DATE DATETIME
--,@pa_profile_type varchar(20)
@pa_from_dt datetime
,@pa_to_dt datetime
,@pa_login_name varchar(100)
)
AS
BEGIN

declare @l_dpm numeric
declare @l_dp_exchange varchar(100)
select @l_dpm = dpm_id,@l_dp_exchange = case when dpm_dpid like 'in%' then 'NSDL' else 'CDSL' end 
 from dp_mstr where default_dp = dpm_excsm_id-- and dpm_excsm_id = @pa_dpm_id and dpm_deleted_ind = 1

if @l_dp_exchange ='cdsl'
begin 

  IF EXISTS (SELECT  1 FROM SYS.OBJECTS WHERE NAME ='dps8_pc1')
begin 
   IF EXISTS (SELECT  1 FROM SYS.OBJECTS WHERE NAME ='holdingallforview')
	   select ''''+BOID BOID 
	,dpam_sba_name [Client_name] 
	,convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0)))) [Holding_Valuation]
	,dpam_bbo_code [BBOcode]
	,a.brom_desc [Current_tariff] 
	--,a.brom_desc [Tariff_to_be_changed]
	--,case When sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0))) <'50000' then 'NEED TO CHANGE CLIENT TO BSDA' 
	--when sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0))) BETWEEN '50001' AND '200000' then 'NEED TO CLIENT TO BSDA' 
	--END 
	--[REMARKS]--,a.BROM_ID
	from dps8_pc1 with(nolock)
	,DP_ACCT_MSTR with(nolock) 
	left outer join client_dp_brkg with(nolock) on CLIDB_DPAM_ID = DPAM_ID and GETDATE() between clidb_eff_from_dt and isnull(clidb_eff_to_dt ,'dec 31 2100')
	left outer join brokerage_mstr a with(nolock) on a.brom_id = CLIDB_BROM_ID 
	left outer join holdingallforview with(nolock) on DPHMCD_DPAM_ID = DPAM_ID 
	where isnull(Filler9 ,'')in('','N')
	and BOId = DPAM_SBA_NO AND DPAM_STAM_CD = 'ACTIVE'  and dpam_dpm_id = @l_dpm
	AND DPAM_SBA_NO NOT LIKE '220%'
	group by BOID,dpam_sba_name,dpam_bbo_code,brom_desc,BROM_ID
	having convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0)))) < 200001
	
	 
	order by 1 

ELSE 
  select ''''+BOID BOID 
	,dpam_sba_name [Client_name] 
	,convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPHMC_FREE_QTY,0)))) [Holding_Valuation]
	,dpam_bbo_code [BBOcode]
	,a.brom_desc [Current_tariff] 
	--,a.brom_desc [Tariff_to_be_changed]
	--,case When sum((isnull(RATE,0)*isnull(DPHMC_FREE_QTY,0))) <'50000' then 'NEED TO CHANGE CLIENT TO BSDA' 
	--when sum((isnull(RATE,0)*isnull(DPHMC_FREE_QTY,0))) BETWEEN '50001' AND '200000' then 'NEED TO CLIENT TO BSDA' 
	--END 
	--[REMARKS] --,a.BROM_ID
	from dps8_pc1 with(nolock)
	,DP_ACCT_MSTR  with(nolock)
	left outer join client_dp_brkg with(nolock) on CLIDB_DPAM_ID = DPAM_ID and GETDATE() between clidb_eff_from_dt and isnull(clidb_eff_to_dt ,'dec 31 2100')
	left outer join brokerage_mstr a with(nolock)  on a.brom_id = CLIDB_BROM_ID 
	left outer join (SELECT DPHMC.*,CLOPM_CDSL_RT RATE FROM  DP_HLDG_MSTR_CDSL DPHMC with(nolock) , CLOSING_LAST_CDSL with(nolock) WHERE CLOPM_ISIN_CD = DPHMC_ISIN ) DPHMC on DPHMC_DPAM_ID = DPAM_ID 
	where isnull(Filler9 ,'')in('','N')
	and BOId = DPAM_SBA_NO AND DPAM_STAM_CD = 'ACTIVE'  and dpam_dpm_id = @l_dpm
	AND DPAM_SBA_NO NOT LIKE '220%'
	group by BOID,dpam_sba_name,dpam_bbo_code,brom_desc,BROM_ID
	having convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPHMC_FREE_QTY,0)))) < 200001
	 
	order by 1 

end 
else 
begin

IF EXISTS (SELECT  1 FROM SYS.OBJECTS WHERE NAME ='holdingallforview')
	   select ''''+dpam_sba_no  dpam_sba_no 
	,dpam_sba_name [Client_name] 
	,convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0)))) [Holding_Valuation]
	--,dpam_bbo_code [BBOcode]
	,a.brom_desc [Current_tariff] 
	--,a.brom_desc [Tariff_to_be_changed]
	--,case When sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0))) <'50000' then 'NEED TO CHANGE CLIENT TO BSDA' 
	--when sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0))) BETWEEN '50001' AND '200000' then 'NEED TO CLIENT TO BSDA' 
	--END 
	--[REMARKS]--,a.BROM_ID
	from DP_ACCT_MSTR with(nolock) 
	left outer join client_dp_brkg with(nolock) on CLIDB_DPAM_ID = DPAM_ID and GETDATE() between clidb_eff_from_dt and isnull(clidb_eff_to_dt ,'dec 31 2100')
	left outer join brokerage_mstr a with(nolock) on a.brom_id = CLIDB_BROM_ID 
	left outer join holdingallforview with(nolock) on DPHMCD_DPAM_ID = DPAM_ID 
	where citruS_usr.fn_ucc_accp(dpam_id,'bsda','') <> 'Y'
	AND DPAM_STAM_CD = 'ACTIVE'  and dpam_dpm_id = @l_dpm
	AND DPAM_SBA_NO NOT LIKE '220%'
	group by dpam_sba_no,dpam_sba_name,brom_desc,BROM_ID
	having convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0)))) < 200001
	
	 
	order by 1 

ELSE 
  select  ''''+dpam_sba_no  dpam_sba_no  
	,dpam_sba_name [Client_name] 
	,convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPHMC_FREE_QTY,0)))) [Holding_Valuation]
	--,'' dpam_bbo_code [BBOcode]
	,a.brom_desc [Current_tariff] 
	--,a.brom_desc [Tariff_to_be_changed]
	--,case When sum((isnull(RATE,0)*isnull(DPHMC_FREE_QTY,0))) <'50000' then 'NEED TO CHANGE CLIENT TO BSDA' 
	--when sum((isnull(RATE,0)*isnull(DPHMC_FREE_QTY,0))) BETWEEN '50001' AND '200000' then 'NEED TO CLIENT TO BSDA' 
	--END 
	--[REMARKS] --,a.BROM_ID
	from DP_ACCT_MSTR  with(nolock)
	left outer join client_dp_brkg with(nolock) on CLIDB_DPAM_ID = DPAM_ID and GETDATE() between clidb_eff_from_dt and isnull(clidb_eff_to_dt ,'dec 31 2100')
	left outer join brokerage_mstr a with(nolock)  on a.brom_id = CLIDB_BROM_ID 
	left outer join (SELECT DPHMC.*,CLOPM_CDSL_RT RATE FROM  DP_HLDG_MSTR_CDSL DPHMC with(nolock) , CLOSING_LAST_CDSL with(nolock) WHERE CLOPM_ISIN_CD = DPHMC_ISIN ) DPHMC on DPHMC_DPAM_ID = DPAM_ID 
	where citrus_usr.fn_ucc_accp(dpam_id,'bsda','') <> 'Y'
	and DPAM_STAM_CD = 'ACTIVE'  and dpam_dpm_id = @l_dpm
	AND DPAM_SBA_NO NOT LIKE '220%'
	group by dpam_sba_no,dpam_sba_name,brom_desc,BROM_ID
	having convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPHMC_FREE_QTY,0)))) < 200001
	 
	order by 1 

end 

end 
else 
begin 

 select  ''''+dpam_sba_no  dpam_sba_no  
	,dpam_sba_name [Client_name] 
	,convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPDHM_QTY,0)))) [Holding_Valuation]
	--,'' dpam_bbo_code [BBOcode]
	,a.brom_desc [Current_tariff] 
	--,a.brom_desc [Tariff_to_be_changed]
	--,case When sum((isnull(RATE,0)*isnull(DPHMC_FREE_QTY,0))) <'50000' then 'NEED TO CHANGE CLIENT TO BSDA' 
	--when sum((isnull(RATE,0)*isnull(DPHMC_FREE_QTY,0))) BETWEEN '50001' AND '200000' then 'NEED TO CLIENT TO BSDA' 
	--END 
	--[REMARKS] --,a.BROM_ID
	from DP_ACCT_MSTR  with(nolock)
	left outer join client_dp_brkg with(nolock) on CLIDB_DPAM_ID = DPAM_ID and GETDATE() between clidb_eff_from_dt and isnull(clidb_eff_to_dt ,'dec 31 2100')
	left outer join brokerage_mstr a with(nolock)  on a.brom_id = CLIDB_BROM_ID 
	left outer join (SELECT DPHMC.*,CLOPM_NSDL_RT RATE FROM  DP_HLDG_MSTR_nsdl DPHMC with(nolock) , CLOSING_LAST_nsdl with(nolock) WHERE CLOPM_ISIN_CD = DPDHM_ISIN ) DPHMC on DPDHM_DPAM_ID  = DPAM_ID 
	where citrus_usr.fn_ucc_accp(dpam_id,'bsda','') <> 'Y'
	and DPAM_STAM_CD = 'ACTIVE'  and dpam_dpm_id = @l_dpm
	AND DPAM_SBA_NO NOT LIKE '220%'
	group by dpam_sba_no,dpam_sba_name,brom_desc,BROM_ID
	having convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPDHM_QTY,0)))) < 200001
	 
	order by 1 


end 
 
END

GO
