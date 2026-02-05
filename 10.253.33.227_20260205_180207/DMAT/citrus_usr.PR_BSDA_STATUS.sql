-- Object: PROCEDURE citrus_usr.PR_BSDA_STATUS
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------




CREATE   procedure [citrus_usr].[PR_BSDA_STATUS]
(
@PA_DPM_ID INT
,@PA_FROM_ACC VARCHAR(16)
,@PA_TO_ACC VARCHAR(16)
,@PA_EFF_DATE DATETIME
,@pa_profile_type varchar(20)
)
AS
BEGIN



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
AND NOT EXISTS (SELECT 1 FROM account_properties I WHERE O.ACCP_CLISBA_ID = I.ACCP_CLISBA_ID AND I.ACCP_ACCPM_PROP_CD ='AMC_DT'
AND ACCP_VALUE <> '')

   print @PA_EFF_DATE

select BOID 
,isnull(dpam_sba_name,'') [Client_name] 
,convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0)))) [Holding_Valuation]
,isnull(dpam_bbo_code,'') [BBOcode]
,isnull(a.brom_desc,'') [Current_tariff] 
--,a.brom_desc [Tariff_to_be_changed]
,isnull(case when  a.brom_desc LIKE '%LIF%' then a.brom_desc 
--when  a.brom_desc LIKE '%ZERO%' then a.brom_desc 
when sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0))) <='400000' then 'BSDA' 
when sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0))) BETWEEN '400001' AND '1000000' then 'BSDA1' 
when sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0))) > '1000001' then 'VERSION 2.5 NORMAL'
END,'') [Tariff_to_be_changed]
,isnull(case when  a.brom_desc LIKE '%LIF%' then 'LIFE' 
--when  a.brom_desc LIKE '%ZERO%' then 'LIFE'
when sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0))) <='400000' then 'NEED TO CHANGE BSDA' 
when sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0))) BETWEEN '400001' AND '1000000' then 'NEED TO CHANGE BSDA1' 
when sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0))) > '1000001' then 'NEED TO DEACTIVE BSDA'
END,'') [REMARKS],a.BROM_ID
--into #tmp
--into bak_tmp02082023
from dps8_pc1
,DP_ACCT_MSTR 
left outer join client_dp_brkg on CLIDB_DPAM_ID = DPAM_ID 
and GETDATE() between clidb_eff_from_dt and isnull(clidb_eff_to_dt ,'dec 31 2900') AND CLIDB_DELETED_IND = '1'
left outer join brokerage_mstr a on a.brom_id = CLIDB_BROM_ID 
left outer join holdingallforview on DPHMCD_DPAM_ID = DPAM_ID 
,#account_properties 
where Filler9 ='Y'
and BOId = DPAM_SBA_NO AND DPAM_STAM_CD = 'ACTIVE' 
and ACCP_CLISBA_ID = DPAM_ID  and month(accp_value)= month(@PA_EFF_DATE ) 
and Year(accp_value)<> year(@PA_EFF_DATE ) --added for current year not to be included
AND BROM_DESC NOT IN ( 'FREE LT AMC','ITRADE PREMIER PRO')-- ,'ITRADE PREMIER PRO' added as per mail from vishal dated 03112025 -for 10 yr free amc
and  isnull(smart_flag ,'N') = 'Y' -- added for smart flag issue report on 15092022 by vishal
--and isnull(a.brom_desc,'') <>'Itrade Prime VBB'
group by BOID,dpam_sba_name,dpam_bbo_code,brom_desc,BROM_ID
HAVING a.brom_desc <> case when  a.brom_desc LIKE '%LIF%' then a.brom_desc 
--when  a.brom_desc LIKE '%ZERO%' then a.brom_desc 
when sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0))) <='400000' then 'BSDA' 
when sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0))) BETWEEN '400001' AND '1000000' then 'BSDA1' 
when sum((isnull(RATE,0)*isnull(DPHMCD_CURR_QTY-DPHMCD_DEMAT_PND_VER_QTY-DPHMCD_LOCKIN_QTY,0))) > '1000001' then 'VERSION 2.5 NORMAL' 

END 
order by 1 

--delete from ins_tariff
--insert into ins_tariff
--select boid,[Current_tariff] ,[Tariff_to_be_changed],'2023-06-01 00:00:00.000','BSDA' from #tmp

END

GO
