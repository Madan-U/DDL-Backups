-- Object: PROCEDURE citrus_usr.pr_count_account
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--exec pr_count_account @pa_id=3,@pa_from_dt='Jan 01 2010',@pa_to_dt='Jun 01 2010',@pa_out=''
--pr_count_account 2,'jun 06 2008','jun 09 2010',''
CREATE PROC [citrus_usr].[pr_count_account](@pa_id NUMERIC , @pa_from_dt DATETIME ,@pa_to_dt DATETIME,@pa_out VARCHAR(8000) OUT)
AS
BEGIN

declare @l_dpm_id int
select @l_dpm_id = dpam_dpm_id from dp_acct_mstr where dpam_excsm_id = @pa_id

--print @l_dpm_id

select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
into #account_properties from account_properties where accp_accpm_prop_cd = 'BILL_START_DT' 
and ltrim(rtrim(accp_value)) not in ('/ /', '/ /','','//')  
and left(accp_value,2)<>'00'
and isdate(accp_value) = 1


select isnull(citrus_usr.fn_find_relations_nm_by_dpamno(dpam_sba_no,'BR'),'') AS BRANCH, count(dpam_sba_no) AS SBA_NO,stam_desc 
from dp_Acct_mstr , status_mstr 
, #account_properties 
where accp_Clisba_id = dpam_id and stam_cd = dpam_stam_Cd
and accp_value between convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103)
AND DPAM_DPM_ID = @l_dpm_id 
group by isnull(citrus_usr.fn_find_relations_nm_by_dpamno(dpam_sba_no,'BR'),''), stam_desc
order by isnull(citrus_usr.fn_find_relations_nm_by_dpamno(dpam_sba_no,'BR'),'')

	
END

GO
