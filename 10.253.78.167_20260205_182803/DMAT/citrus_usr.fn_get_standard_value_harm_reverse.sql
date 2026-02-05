-- Object: FUNCTION citrus_usr.fn_get_standard_value_harm_reverse
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create  function [citrus_usr].[fn_get_standard_value_harm_reverse](@pa_iso varchar(1000), @pa_new_value varchar(1000))  
returns varchar(1000)  
as  
begin   
return (isnull((  
select top 1 cdsl_old_values    from [Standard_value_list] where iso_tags =@pa_iso and (standard_value= @pa_new_value  ) and isnull(cdsl_old_values ,'') <> ''),''))  
  
end

GO
