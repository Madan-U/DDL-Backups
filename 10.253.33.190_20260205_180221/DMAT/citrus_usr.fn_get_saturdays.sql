-- Object: FUNCTION citrus_usr.fn_get_saturdays
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select citrus_usr.fn_get_saturdays('jan 01 2009')
CREATE function [citrus_usr].[fn_get_saturdays](@pa_dt datetime)
returns varchar(8000)
as
begin

   declare @l_month numeric
   declare @l_string varchar(8000)
   select @l_month = month(@pa_dt)
   set @l_string  = ''
   while month(@pa_dt) = @l_month 
   begin
     if datename(dw,@pa_dt) = 'Saturday'
     set  @l_string   = isnull(@l_string,'')  + convert(varchar(11),@pa_dt,109)  + ','
     set @pa_dt = dateadd(dd,1,@pa_dt)

   end 
  return @l_string
end

GO
