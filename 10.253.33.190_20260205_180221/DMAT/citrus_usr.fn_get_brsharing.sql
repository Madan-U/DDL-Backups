-- Object: FUNCTION citrus_usr.fn_get_brsharing
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_get_brsharing](@pa_sba_no varchar(16))
returns numeric(10,3)
as
begin 

Declare @l_count numeric
,@l_month numeric
,@l_per numeric(10,3)
select @l_count = count(entr_sba) from entity_relationship where entr_deleted_ind = 1 
and  entr_sba =@pa_sba_no

select  top 1 @l_month = datediff(mm,entr_from_Dt,entr_to_dt) from entity_relationship where entr_deleted_ind = 1
and  entr_sba = @pa_sba_no
order by entr_from_Dt

select @l_per = case when @l_count <> 1 and @l_month < 3 then 1 
when @l_count <> 1 and @l_month between 3 and 5 then 0.75
when @l_count <> 1 and @l_month between 6 and 8 then 0.50
when @l_count <> 1 and @l_month >= 9 then 0.25
when @l_count = 1 then 1
else 1 end 

return @l_per


end

GO
