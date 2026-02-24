-- Object: FUNCTION citrus_usr.fn_modify_slipno
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--select citrus_usr.fn_modify_slipno('000000002','9')

CREATE function [citrus_usr].[fn_modify_slipno](@pa_slip_no varchar(20),@pa_len numeric)
returns varchar(20)
as
begin
  declare @l_count numeric
  ,@l_counter numeric
  ,@l_slip_no varchar(100)
  set @l_counter = 1
  set @l_slip_no = '' 
  select @l_count = @pa_len - len(@pa_slip_no) 
  
  if @l_count = 0
  set @l_slip_no = @pa_slip_no


  while @l_counter <= @l_count 
  begin
    if @l_counter = 1 
    set @l_slip_no = '0' + @l_slip_no + @pa_slip_no
    else 
    set @l_slip_no = '0' + @l_slip_no 


    set @l_counter  = @l_counter  + 1 
  end 

  return @l_slip_no
  

end

GO
