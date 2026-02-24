-- Object: FUNCTION citrus_usr.fn_get_DIS_high_nsdl
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_get_DIS_high_nsdl](@pa_flag char(25), @pa_slip_no varchar(1000), @pa_values varchar(8000))        
returns numeric(18,3)        
as        
begin        
        
        
declare @l_retrun numeric(18,3)        
set @l_retrun = 0        
if @pa_flag = 'RPT'        
begin        
select @l_retrun = sum(convert(numeric(18,3),abs(dptd_qty*isnull(clopm_nsdl_rt,0))))        
from CLOSING_LAST_NSDL right outer join dp_trx_dtls
on CLOPM_ISIN_CD = DPTD_ISIN        
where dptd_slip_no  = @pa_slip_no      
group by dptd_slip_no        
end         
else         
begin        
  declare @l_count numeric        
  ,@l_counter      numeric        
  ,@l_values       varchar(1000)        
  set @l_counter      = 1        
  set @l_count = citrus_usr.ufn_countstring(@pa_values,'*|~*')        
        
  while @l_counter <= @l_count        
  begin        
           
   set @l_values = citrus_usr.fn_splitval_row(@pa_values,@l_counter)        
        
   select @l_retrun = isnull(@l_retrun,'0') + citrus_usr.fn_splitval(@l_values,3)*isnull(clopm_NSDL_rt,0)        
   from   CLOSING_LAST_NSDL    
   where  CLOPM_ISIN_CD = citrus_usr.fn_splitval(@l_values,2)                      
           
        
            
    set @l_counter =@l_counter +1        
  end        
          
end         
return @l_retrun        
        
        
end

GO
