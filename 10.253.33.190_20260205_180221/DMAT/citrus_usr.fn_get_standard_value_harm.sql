-- Object: FUNCTION citrus_usr.fn_get_standard_value_harm
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_get_standard_value_harm](@pa_iso varchar(1000), @pa_old_value varchar(1000))  
returns varchar(1000)  
as  
begin   
return (isnull((  
select top 1 standard_value  from [Standard_value_list] where iso_tags =@pa_iso and (cdsl_old_values = @pa_old_value or Meaning = @pa_old_value   )),''))  
  
end

GO
