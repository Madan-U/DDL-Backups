-- Object: FUNCTION citrus_usr.fn_get_charge_list
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_get_charge_list]  
(@pa_dpam_id numeric  
,@pa_fromdt datetime  
,@pa_todate datetime  
,@pa_charge varchar(250))  
returns char(1)  
as  
begin   
  
  
return case when exists(select CHAM_CHARGE_TYPE   
      from charge_mstr   
      , client_dp_brkg   
      --, dp_acct_mstr   
      , profile_charges   
      where clidb_brom_id = proc_profile_id   
      and cham_slab_no = proc_slab_no  
      AND clidb_eff_from_dt between  @pa_fromdt and @pa_todate  
      and clidb_dpam_id = @pa_dpam_id   
      and CHAM_CHARGE_TYPE= @pa_charge  

      and cham_deleted_ind = 1   
      and proc_deleted_ind = 1   
      and clidb_deleted_ind = 1 ) then 'Y' else 'N' end   
end

GO
