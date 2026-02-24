-- Object: FUNCTION citrus_usr.fngetdate
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fngetdate](@pa_dt varchar(10))    
returns varchar(11)    
as     
begin    
        
 return  case when ltrim(rtrim(@pa_dt )) not in ( '' ,'01010001','01011900','01011901') and right(@pa_dt,4) >= 1900
 then left(@pa_dt ,2)+'/'+substring(@pa_dt,3,2)+'/'+right(@pa_dt,4) else '01/01/1900' end     
    
    
end

GO
