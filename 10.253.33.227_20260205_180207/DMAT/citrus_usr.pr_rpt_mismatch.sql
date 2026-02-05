-- Object: PROCEDURE citrus_usr.pr_rpt_mismatch
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_rpt_mismatch](@pa_tab varchar(100) )  
as  
begin   
if @pa_tab = 'relationship'  
--select count(entr_sba) count ,entr_sba  
--from entity_relationship   
--where getdate() between entr_from_dt and isnull(entr_to_dt,getdate())  
--and entr_deleted_ind =1   
--group by entr_sba  
--having count(entr_sba)>1  
if @pa_tab = 'relationship'  
SELECT A.* FROM (select count(entr_sba) count ,entr_sba  
from entity_relationship   
where getdate() between entr_from_dt and isnull(entr_to_dt,getdate())  
and entr_deleted_ind =1   
group by entr_sba  
having count(entr_sba)>1  
union  
select '1' , dpam_sba_no 
from dp_acct_mstr where dpam_sba_no not in 
(select entr_sba from entity_relationship where getdate () between entr_from_Dt and isnull (entr_to_Dt,'DEc 31 2100') and entr_deleted_ind = '1') 
and dpam_Stam_cd = 'active'
and dpam_sba_no not like '220%'
union
select count(entr_sba) count ,entr_sba  
from entity_relationship A  
where getdate() not between entr_from_dt and isnull(entr_to_dt,getdate())  
and entr_deleted_ind =1   
group by entr_sba  
having count(entr_sba)>1 AND 0= (SELECT COUNT(ENTR_SBA) FROM entity_relationship B WHERE A.entr_sba = B.entr_sba AND B.ENTR_DELETED_IND = 1 AND getdate()  between B.entr_from_dt and isnull(B.entr_to_dt,getdate()))  
UNION  
select count(entr_sba) count ,entr_sba  
from entity_relationship A  
where getdate() not between entr_from_dt and isnull(entr_to_dt,getdate())  
and entr_deleted_ind =1   
group by entr_sba  
having 1= (SELECT COUNT(ENTR_SBA) FROM entity_relationship B WHERE A.entr_sba = B.entr_sba AND B.ENTR_DELETED_IND = 1 )  
union 
select 1,entr_sba +':BASE LOCATION MISSING' from entity_relationship where isnull (entr_dummy5,  '0')='0'
					and entr_sba in (select dpam_Sba_no  from dp_acct_mstr where dpam_stam_Cd = 'active')
					and getdate() between entr_from_dt and isnull(entr_to_dt ,'Dec 31 2100')
					and left (entr_sba ,5) ='12033'
					and entr_deleteD_ind = '1'
union

select count(entr_sba) count ,entr_sba from  
entity_relationship where ENTR_SBA like '120332%' and entr_crn_no
 in (select DPAM_CRN_NO from dp_acct_mstr where DPAM_SBA_NO= DPAM_ACCT_NO and DPAM_DELETED_IND = '1') 
 group by entr_sba  
--union   
--select -1 count ,entr_sba+':br/ba not mapped'  
--from entity_relationship   
--where getdate() between entr_from_dt and isnull(entr_to_dt,getdate())  
--and entr_deleted_ind =1   
--and (isnull(entr_sb,0) = 0 and isnull(entr_br,0) = 0)  
--group by entr_sba
) A , DP_ACCT_MSTR  ,dps8_pc1 
WHERE DPAM_SBA_NO = replace (replace (ENTR_SBA ,':br/ba not mapped','')  ,':BASE LOCATION MISSING','')
AND (ClosAppDt =''  and BOAcctStatus ='1' )
and boid = dpam_sba_no
AND DPAM_SBA_NO LIKE '12033%'  

  
  
if @pa_tab = 'brokerage'  
SELECT A.* FROM 
(select count(clidb_dpam_id) count,dpam_sba_no, clidb_dpam_id   
from client_dp_brkg, dp_acct_mstr  
where clidb_dpam_id = dpam_id and getdate() between clidb_eff_from_dt and isnull(clidb_eff_to_dt,getdate())  
and clidb_deleted_ind =1   
and dpam_deleted_ind =1   
group by clidb_dpam_id , dpam_sba_no  
having count(clidb_brom_id)>1  
union all   
select 1,dpam_sba_no , clidb_dpam_id from client_dp_brkg, dp_acct_mstr  
where clidb_dpam_id = dpam_id   
and clidb_deleted_ind =1   
and dpam_deleted_ind  =1   
and  getdate() not between clidb_eff_from_dt and isnull(clidb_eff_to_dt,getdate())  
and clidb_dpam_id in (  
select clidb_dpam_id   
from client_dp_brkg, dp_acct_mstr  
where clidb_dpam_id = dpam_id   
and clidb_deleted_ind =1   
and dpam_deleted_ind =1   
group by clidb_dpam_id , dpam_sba_no  
having count(clidb_brom_id)=1)  
union all 
 select 1,dpam_sba_no , a.clidb_dpam_id from client_dp_brkg a , client_dp_brkg b , dp_acct_mstr dpam
 where a.clidb_dpam_id = b.clidb_dpam_id 
 and a.CLIDB_DPAM_ID = dpam.dpam_id
 and a.clidb_eff_from_dt > b.clidb_eff_from_dt 
 and a.clidb_eff_to_dt < b.clidb_eff_to_dt
 and a.clidb_eff_to_dt not in ('2900-01-01 00:00:00.000','2900-01-01 00:00:00.000','2100-12-31 00:00:00.000')
 and a.CLIDB_DELETED_IND = 1 
 and b.CLIDB_DELETED_IND = 1
union all   
select 1,dpam_sba_no ,dpam_id from dp_acct_mstr   
where not exists   
(select 1 from client_dp_brkg where clidb_dpam_id = dpam_id and clidb_deleted_ind =  1  
 and getdate() between clidb_eff_from_dt and isnull(clidb_eff_to_dt,'dec 31 2100'))  
-- union all 
-- select 1,dpam_sba_no,dpam_id from dp_acct_mstr, client_dp_brkg
--where DPAM_ID = CLIDB_DPAM_ID 
--and DPAM_ID not in (select DPAM_ID from client_dp_brkg)
union ALL
select 1,dpam_sba_no,dpam_id  from client_dp_brkg with(nolock),DP_ACCT_MSTR  with(nolock)
where dpam_id = CLIDB_DPAM_ID 
and clidb_eff_to_dt > (
select top 1 clidb_eff_from_dt from client_dp_brkg inn with(nolock)  where GETDATE() between inn.clidb_eff_from_dt and ISNULL(inn.clidb_eff_to_dt,'dec 31 2100')
and DPAM_ID = inn.CLIDB_DPAM_ID 
and inn.CLIDB_DELETED_IND = 1 )
and CLIDB_DELETED_IND = 1 
AND GETDATE() > ISNULL(clidb_eff_to_dt ,'DEC 31 2100')
and exists (select 1 from client_dp_brkg inn2 with(nolock) where CLIDB_DELETED_IND  = 1 and inn2.CLIDB_DPAM_ID = DPAM_ID group by inn2.CLIDB_DPAM_ID having COUNT(1)>1)


union all   
select '-1' count,dpam_sba_no+':general tarrif', clidb_dpam_id   
from client_dp_brkg, dp_acct_mstr  
where clidb_dpam_id = dpam_id and getdate() between clidb_eff_from_dt and isnull(clidb_eff_to_dt,getdate())  
and clidb_deleted_ind =1   
and dpam_deleted_ind =1   
and clidb_brom_id = '110'  
group by clidb_dpam_id , dpam_sba_no  
having count(clidb_brom_id)=1) A, DP_ACCT_MSTR  B  
WHERE B.DPAM_SBA_NO = replace(A.DPAM_SBA_NO ,':general tarrif','')  
AND DPAM_STAM_CD ='ACTIVE'  
AND A.DPAM_SBA_NO LIKE '12033%'  
  union all
  
  select '1' count,dpam_sba_no+':Wrong Tariff', clidb_dpam_id   
from client_dp_brkg, dp_acct_mstr  
where clidb_dpam_id = dpam_id and getdate() between clidb_eff_from_dt and isnull(clidb_eff_to_dt,getdate())  
and clidb_deleted_ind =1   
and dpam_deleted_ind =1   
and clidb_brom_id = '0'  

union all 
select '1' count ,dpam_sba_no , clidb_dpam_id  
from client_dp_brkg, dp_acct_mstr where  clidb_deleted_ind = '1' and dpam_id = clidb_dpam_id 
and clidb_eff_from_dt >= '2018-03-01 00:00:00.000' and dpam_sba_no like '120%' 
group by clidb_eff_to_dt, clidb_dpam_id ,dpam_sba_no
having count(clidb_eff_to_dt)>1

  
  
  
if @pa_tab = 'Form_no_mismatch'  
select inwcr_frmno from inw_client_reg   
where inwcr_frmno not in (select dpam_acct_no from dp_acct_mstr where dpam_deleted_ind = 1)  
and inwcr_deleted_ind = 1   
  
if @pa_tab = 'Year_End'  
select ldg_voucher_no,sum(ldg_amount)ldg_amount from ledger2,  (SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO,acct_type,group_id FROM citrus_usr.fn_gl_acct_list(3 ,1,0) ) account where ldg_dpm_id = 3  
 and ldg_voucher_dt <= 'Mar 31 2010 23:59:59' and ldg_account_id = account.dpam_id   
 and ldg_account_type = account.acct_type  and (ldg_voucher_dt between eff_from and eff_to)   
 and ldg_deleted_ind = 1   
 and ldg_voucher_no <> '0'  
group by ldg_voucher_no   
having sum(ldg_amount) <> 0  
  
if @pa_tab = 'Activatedatemismatch'  
begin   
--  
declare @ssql varchar(8000)  
,@l_fin_id numeric  
  
select @l_fin_id  = fin_id from financial_yr_mstr   
where getdate() between FIN_START_DT and FIN_END_DT   
and FIN_DELETED_IND = 1   
  
--set @ssql  = 'select * from dp_acct_mstr , entity_relationship , ledger'+ convert(varchar,@l_fin_id)  
--set @ssql  = @ssql  +' where ldg_account_id = dpam_id and entr_sba = dpam_sba_no '  
--set @ssql  = @ssql  +' and   ldg_voucher_dt < ENTR_FROM_DT and entr_deleted_ind = 1 and ldg_deleted_ind =1 and dpam_deleted_ind = 1 '  
  
set @ssql  = 'select dpam_sba_no ,ldg_voucher_no, min(ldg_voucher_dt) ldg_voucher_dt from dp_acct_mstr , entity_relationship , ledger'+ convert(varchar,@l_fin_id)  
set @ssql  = @ssql  +' where ldg_account_id = dpam_id and entr_sba = dpam_sba_no '  
set @ssql  = @ssql  +' and   ldg_voucher_dt < ENTR_FROM_DT and entr_deleted_ind = 1 and ldg_deleted_ind =1  
 and dpam_deleted_ind = 1   
group by dpam_sba_no,ldg_voucher_no, ldg_voucher_dt  
having min(entr_from_dt) < min(ldg_voucher_dt) '  
  
  
print @ssql    
exec(@ssql  )  
  
  
--  
end   
   
  
  
  
  
end

GO
