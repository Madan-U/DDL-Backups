-- Object: PROCEDURE citrus_usr.pr_get_prov_bill
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--exec pr_get_prov_bill 'ALL','jul 01 2012','jul 31 2012'
--exec pr_get_prov_bill '12010900','jun 30 2012','jun 30 2012'
CREATE proc [citrus_usr].[pr_get_prov_bill](@pa_dpid varchar(20),@pa_from_dt datetime,@pa_to_dt datetime)
as
begin 

if @pa_dpid = 'ALL'
begin 
select dpm_dpid,dpam_sba_no , isnull(accp_value ,'') [bbocode],brom_desc scheme, sum(clic_charge_amt) AMOUNT
,convert(numeric(18,2),sum(clic_charge_amt)*0.1236) ST  
,case when [citrus_usr].[fn_find_relations_Acctlvl_bill](clic_dpam_id , 'BR') <>'' 
		then replace([citrus_usr].[fn_find_relations_Acctlvl_bill](clic_dpam_id , 'BR') ,'_BR','')
		else replace([citrus_usr].[fn_find_relations_Acctlvl_bill](clic_dpam_id , 'BA'),'_BA','') end 
from   client_charges_Cdsl left outer join account_properties on accp_clisba_id = CLIC_DPAM_ID and accp_accpm_prop_cd = 'BBO_CODE' and accp_deleted_ind = 1 ,dp_Acct_mstr, dp_mstr , client_dp_brkg , brokerage_mstr

where clic_dpam_id = dpam_id 
and dpm_id = dpam_dpm_id 
and brom_id = clidb_brom_id 
and clidb_dpam_id = dpam_id 
and CLIC_TRANS_DT between clidb_eff_from_dt
and isnull(clidb_eff_to_dt,'dec 31 2100')
and clic_charge_name in (
'DEMAT COURIER CHARGE',
'DEMAT REJECTION CHARGE',
'TRANSACTION CHARGES'
)
and  clic_trans_dt between @pa_from_dt and @pa_to_dt
group by clic_dpam_id , dpm_dpid,dpam_sba_no,brom_desc,isnull(accp_value ,'')  order by 1,2 

 

end 
else 
begin 
select dpm_dpid,dpam_sba_no , isnull(accp_value ,'')  [bbocode], brom_desc scheme, sum(clic_charge_amt) AMOUNT
,convert(numeric(18,2),sum(clic_charge_amt)*0.1236) ST  
from  client_charges_Cdsl  left outer join account_properties on accp_clisba_id = clic_dpam_id and accp_accpm_prop_cd = 'BBO_CODE' and accp_deleted_ind = 1 ,dp_Acct_mstr, dp_mstr , client_dp_brkg , brokerage_mstr
where clic_dpam_id = dpam_id 
and dpm_dpid = @pa_dpid
and dpm_id = dpam_dpm_id 
and brom_id = clidb_brom_id 
and CLIC_TRANS_DT between clidb_eff_from_dt and isnull(clidb_eff_to_dt,'dec 31 2100')
and clidb_dpam_id = dpam_id 
and clic_charge_name in (
'DEMAT COURIER CHARGE',
'DEMAT REJECTION CHARGE',
'TRANSACTION CHARGES'
)
and  clic_trans_dt between @pa_from_dt and @pa_to_dt
group by dpm_dpid,dpam_sba_no,brom_desc,isnull(accp_value ,'')  order by 1,2

end 
end

GO
