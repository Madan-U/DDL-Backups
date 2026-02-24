-- Object: PROCEDURE citrus_usr.PR_RPT_BSDA
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select dpm_excsm_id,* from dp_mstr where default_dp = dpm_id
--EXEC PR_RPT_BSDA 'Feb 29 2016','Feb 29 2016','3'
CREATE   procedure [citrus_usr].[PR_RPT_BSDA]
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
--return 
declare @l_dpm numeric
declare @l_dp_exchange varchar(100)
select @l_dpm = dpm_id,@l_dp_exchange = case when dpm_dpid like 'in%' then 'NSDL' else 'CDSL' end 
 from dp_mstr where default_dp = dpm_excsm_id-- and dpm_excsm_id = @pa_dpm_id and dpm_deleted_ind = 1



select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
into #account_properties from account_properties 
where accp_accpm_prop_cd = 'AMC_DT' 
and accp_value not in ('','//')
and accp_value not in ('','//','Jan  1 1900')



INSERT INTO #account_properties 
select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
from account_properties O
where accp_accpm_prop_cd = 'BILL_START_DT' 
and accp_value not in ('','//')
AND NOT EXISTS (SELECT 1 FROM account_properties I WHERE O.ACCP_CLISBA_ID = I.ACCP_CLISBA_ID AND I.ACCP_ACCPM_PROP_CD ='AMC_DT' AND ACCP_VALUE <> '')


create index ix_1 on #account_properties(accp_clisba_id , accp_value )

if @l_dp_exchange ='cdsl'
begin 

  IF EXISTS (SELECT  1 FROM SYS.OBJECTS WHERE NAME ='dps8_pc1')
begin 
   IF EXISTS (SELECT  1 FROM SYS.OBJECTS WHERE NAME ='holdingallforview')
   
   --select * from bakjul116_tmp_bsda
   
	   select  ''''+BOID BOID 
	,dpam_sba_name [Client_name] 
	,convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0)))) [Holding_Valuation]
	,isnull(dpam_bbo_code,'') [BBOcode]
	,a.brom_desc [Current_tariff] 
	,BOID as dpam_sba_no
	,isnull(PANGIR,'') PAN_GIR_NO--citrus_usr.fn_ucc_entp(DPAM_CRN_NO,'PAN_GIR_NO','') PAN_GIR_NO
	--,a.brom_desc [Tariff_to_be_changed]
	--,case When sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0))) <'50000' then 'NEED TO CHANGE CLIENT TO BSDA' 
	--when sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0))) BETWEEN '50001' AND '200000' then 'NEED TO CLIENT TO BSDA' 
	--END 
	--[REMARKS]--,a.BROM_ID
	--into bakjul116_tmp_bsda
	from dps8_pc1 with(nolock)
	,DP_ACCT_MSTR with(nolock) 
	left outer join client_dp_brkg with(nolock) on CLIDB_DPAM_ID = DPAM_ID and GETDATE() between clidb_eff_from_dt and isnull(clidb_eff_to_dt ,'dec 31 2100') and CLIDB_DELETED_IND = '1'
	left outer join brokerage_mstr a with(nolock) on a.brom_id = CLIDB_BROM_ID 
	left outer join holdingallforview with(nolock) on DPHMCD_DPAM_ID = DPAM_ID 
	,#account_properties
	where isnull(Filler9 ,'')in('','N')
	and BOId = DPAM_SBA_NO AND DPAM_STAM_CD = 'ACTIVE'  and dpam_dpm_id = @l_dpm
	AND DPAM_SBA_NO NOT LIKE '220%'
	
	and ACCP_CLISBA_ID=dpam_id
	and month(accp_value)=month(@pa_from_dt)--'02'
	and year(accp_value) in ('1994','1995','1996','1997','1998','1999','2000','2001','2002','2003','2004','2005','2006'
	,'2007','2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024','2025')
	and BROM_ID  not in (select BROM_ID from brokerage_mstr where  BROM_DESC  like '%lif%'  )
	--and exists (
	--select clic_dpam_id from client_charges_cdsl where CLIC_DPAM_ID=DPAM_ID and CLIC_DELETED_IND=1
	--and month(CLIC_TRANS_DT)=month(accp_value)
	--and year(CLIC_TRANS_DT)=year(accp_value)
	--and (CLIC_CHARGE_NAME like '%acmain%'   or CLIC_CHARGE_NAME like 'VERSON 2.5 NORMAL_AC%')	 
	--)
	 and DPAM_CLICM_CD='21'
	 and exists (SELECT boid from ANGEL_BSDA_IMPORT_MSTR where DPAM_SBA_NO=boid and BILLMONTH=@pa_to_dt)
	and  exists ( SELECT DISTINCT  BOID FROM DPS8_PC16 WHERE TYPEOFTRANS<>'3' and DPAM_SBA_NO=boid)
	group by BOID,dpam_sba_name,dpam_bbo_code,brom_desc,BROM_ID,DPAM_CRN_NO,PANGIR
	having convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0)))) < 1000001
	
	 
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
	,#account_properties
	where isnull(Filler9 ,'')in('','N')
	and BOId = DPAM_SBA_NO AND DPAM_STAM_CD = 'ACTIVE'  and dpam_dpm_id = @l_dpm
	AND DPAM_SBA_NO NOT LIKE '220%'
	
	and ACCP_CLISBA_ID=dpam_id
	and month(accp_value)=month(@pa_from_dt)--'02'
	and year(accp_value) in ('1994','1995','1996','1997','1998','1999','2000','2001','2002','2003','2004','2005','2006'
	,'2007','2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024','2025')
	and BROM_ID  not in (select BROM_ID from brokerage_mstr where BROM_DESC  like '%lif%' )
	--and exists (
	--select clic_dpam_id from client_charges_cdsl where CLIC_DPAM_ID=DPAM_ID and CLIC_DELETED_IND=1
	--and month(CLIC_TRANS_DT)=month(accp_value)
	--and year(CLIC_TRANS_DT)=year(accp_value)
	--and (CLIC_CHARGE_NAME like '%acmain%'   or CLIC_CHARGE_NAME like 'VERSON 2.5 NORMAL_AC%')	 
	--)
	and DPAM_CLICM_CD='21'
	and  exists ( SELECT DISTINCT  BOID FROM DPS8_PC16 WHERE TYPEOFTRANS<>'3' and DPAM_SBA_NO=boid)
	
	group by BOID,dpam_sba_name,dpam_bbo_code,brom_desc,BROM_ID
	having convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPHMC_FREE_QTY,0)))) < 1000001
	 
	order by 1 

end 
else 
begin

IF EXISTS (SELECT  1 FROM SYS.OBJECTS WHERE NAME ='holdingallforview')
	   select ''''+dpam_sba_no  dpam_sba_no 
	,dpam_sba_name [Client_name] 
	,convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0)))) [Holding_Valuation]
	--,dpam_bbo_code [BBOcode]
	,a.brom_desc [Current_tariff] 
	--,a.brom_desc [Tariff_to_be_changed]
	--,case When sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0))) <'50000' then 'NEED TO CHANGE CLIENT TO BSDA' 
	--when sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0))) BETWEEN '50001' AND '200000' then 'NEED TO CLIENT TO BSDA' 
	--END 
	--[REMARKS]--,a.BROM_ID
	from DP_ACCT_MSTR with(nolock) 
	left outer join client_dp_brkg with(nolock) on CLIDB_DPAM_ID = DPAM_ID and GETDATE() between clidb_eff_from_dt and isnull(clidb_eff_to_dt ,'dec 31 2100')
	left outer join brokerage_mstr a with(nolock) on a.brom_id = CLIDB_BROM_ID 
	left outer join holdingallforview with(nolock) on DPHMCD_DPAM_ID = DPAM_ID 
	,#account_properties
	where citruS_usr.fn_ucc_accp(dpam_id,'bsda','') <> 'Y'
	AND DPAM_STAM_CD = 'ACTIVE'  and dpam_dpm_id = @l_dpm
	AND DPAM_SBA_NO NOT LIKE '220%'
	and ACCP_CLISBA_ID=dpam_id
	and month(accp_value)=month(@pa_from_dt) --'02'
	and year(accp_value) in ('1994','1995','1996','1997','1998','1999','2000','2001','2002','2003','2004','2005','2006'
	,'2007','2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024','2025')
	and BROM_ID  not in (select BROM_ID from brokerage_mstr where BROM_DESC  like '%lif%'  )
	--and exists (
	--select clic_dpam_id from client_charges_cdsl where CLIC_DPAM_ID=DPAM_ID and CLIC_DELETED_IND=1
	--and month(CLIC_TRANS_DT)=month(accp_value)
	--and year(CLIC_TRANS_DT)=year(accp_value)
	--and (CLIC_CHARGE_NAME like '%acmain%'   or CLIC_CHARGE_NAME like 'VERSON 2.5 NORMAL_AC%')	 
	--)
	and DPAM_CLICM_CD='21'
	and  exists ( SELECT DISTINCT  BOID FROM DPS8_PC16 WHERE TYPEOFTRANS<>'3' and DPAM_SBA_NO=boid)
	group by dpam_sba_no,dpam_sba_name,brom_desc,BROM_ID
	having convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0)))) < 1000001
	
	 
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
	and DPAM_CLICM_CD='21'
	and  exists ( SELECT DISTINCT  BOID FROM DPS8_PC16 WHERE TYPEOFTRANS<>'3' and DPAM_SBA_NO=boid)
	group by dpam_sba_no,dpam_sba_name,brom_desc,BROM_ID
	having convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPHMC_FREE_QTY,0)))) < 1000001
	 
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
	and DPAM_CLICM_CD<>'21'
	and  exists ( SELECT DISTINCT  BOID FROM DPS8_PC16 WHERE TYPEOFTRANS<>'3' and DPAM_SBA_NO=boid)
	group by dpam_sba_no,dpam_sba_name,brom_desc,BROM_ID
	having convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPDHM_QTY,0)))) < 1000001
	 
	order by 1 


end 
 
END

GO
