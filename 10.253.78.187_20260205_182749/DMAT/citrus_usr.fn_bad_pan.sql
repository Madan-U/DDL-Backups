-- Object: FUNCTION citrus_usr.fn_bad_pan
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create function [citrus_usr].[fn_bad_pan](@pa_pan_no varchar(15) )
returns varchar(1) 
as
begin 

declare @l_flag char(1)

if len(@pa_pan_no) <> 10 
	or isnumeric(substring(@pa_pan_no,1,1)) = 1 
	or isnumeric(substring(@pa_pan_no,2,1)) = 1 
	or isnumeric(substring(@pa_pan_no,3,1)) = 1 
	or isnumeric(substring(@pa_pan_no,4,1)) = 1 
	or isnumeric(substring(@pa_pan_no,5,1)) = 1 
	or isnumeric(substring(@pa_pan_no,6,1)) = 0 
	or isnumeric(substring(@pa_pan_no,7,1)) = 0 
	or isnumeric(substring(@pa_pan_no,8,1)) = 0 
	or isnumeric(substring(@pa_pan_no,9,1)) = 0 
	or isnumeric(right(@pa_pan_no,1)) = 1
    or @pa_pan_no LIKE '%[^a-zA-Z0-9]%'
    
begin 

set @l_flag = 'Y'

end     
    return isnull(@l_flag,'N') 

end

GO
