-- Object: FUNCTION citrus_usr.fn_createheirarchy_update
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_createheirarchy_update](@tmptable varchar(100),@enttm_cd varchar(20)) returns varchar(8000)  
as  
begin  
declare @@ssql varchar(8000)  
  
select @@ssql = 'update ' + @tmptable + ' set group_cd = ' + entem_entr_col_name + ' from entity_relationship where  dpam_sba_no = entr_sba and eff_from = entr_from_dt and eff_to= ISNULL(entr_to_dt,''jan  1 2900'') and entr_deleted_ind = 1'  
from enttm_entr_mapping  
where entem_enttm_cd = @enttm_cd  
  
 RETURN isnull(@@ssql + ' update ' + @tmptable + ' set group_cd = 1 where isnull(group_cd,0) = 0','')  
end

GO
