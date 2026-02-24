-- Object: FUNCTION citrus_usr.fn_charge_ctgry_list
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_charge_ctgry_list](@pa_cham_slab_no varchar(1000))  
returns varchar(8000)  
as  
begin   
  
declare @l_string varchar(8000)  
  
set @l_string = ''  
  
select @l_string = @l_string + case when chacm_subcm_cd  = '0' then 'ALL' else chacm_subcm_cd end  + ','  from charge_ctgry_mapping where chacm_cham_id = @pa_cham_slab_no   
  
return @l_string   
  
end

GO
