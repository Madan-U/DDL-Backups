-- Object: FUNCTION citrus_usr.fn_get_high_val_byslip_fordebug
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select citrus_usr.fn_get_high_val_byslip('E|*~|INE002A01018|*~|100000.000|*~|14538|*~|*|~*E|*~|INE614G01033|*~|100000.000|*~|14539|*~|*|~*E|*~|INE238A01026|*~|100000.000|*~|14540|*~|*|~*A|*~|INE032A01015|*~|96|*~|*|~*D|*~|14541|*~|*|~*')    
    
CREATE   function [citrus_usr].[fn_get_high_val_byslip_fordebug](@pa_values varchar(8000))    
returns char(1)    
as    
begin    
declare @l_max_high_val numeric    
,@l_counter numeric    
,@l_count numeric    
,@l_value varchar(1000)    
,@l_qty numeric(18,3)    
,@l_valuation numeric(18,3)    
,@l_rate numeric(18,3)    
,@l_yn char(1)    
    
set @l_valuation = 0     
    
select @l_count  = citrus_usr.ufn_countstring(@pa_values ,'*|~*')    
set @l_counter = 1     
    
Select @l_max_high_val = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd = 'HIGH_VAL_NSDL'        
and bitrm_deleted_ind = 1          
    
while @l_counter < = @l_count    
begin    
    
    
    
set @l_value = citrus_usr.fn_splitval_by(@pa_values,@l_counter,'*|~*')    
    
if citrus_usr.fn_splitval(@l_value,1) in ('A','E')    
begin      
    
set @l_qty = citrus_usr.fn_splitval(@l_value,3)     
    
select top 1 @l_rate = isnull(clopm_cdsl_rt   ,0)   
from CLOSING_LAST_CDSL     
--from closing_price_mstr_cdsl     
where clopm_isin_cd = citrus_usr.fn_splitval(@l_value,2)    
order by CLOPM_DT desc            
    
set @l_valuation = @l_valuation + (@l_qty * isnull(@l_rate ,0) )    
    
end     
    
 set @l_counter = @l_counter +  1    
    
    
    
end      
    
set @l_yn =  case when @l_valuation >= @l_max_high_val then 'Y' ELSE 'N' END      
    
    
    
return @l_yn       
    
end

GO
