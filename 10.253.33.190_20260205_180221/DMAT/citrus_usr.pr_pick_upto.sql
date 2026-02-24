-- Object: FUNCTION citrus_usr.pr_pick_upto
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[pr_pick_upto](@pa_string varchar(8000),@pa_upto numeric)
returns varchar(8000)
as
begin
declare @l_str varchar(8000)
,@l_count numeric

set @l_count = 1 
set @l_str  = ''
while @l_count <= @pa_upto
begin

set @l_str = @l_str  + citrus_usr.fn_splitval_by(replace(@pa_string,' ','|'),@l_count,'|') + ' '

set @l_count = @l_count + 1 
end 

return @l_str--+'|'+convert(varchar,len(@l_str))+'|'

end

GO
