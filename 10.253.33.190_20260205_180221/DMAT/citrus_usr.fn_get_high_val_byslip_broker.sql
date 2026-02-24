-- Object: FUNCTION citrus_usr.fn_get_high_val_byslip_broker
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select citrus_usr.fn_get_high_val_byslip('E|*~|INE002A01018|*~|100000.000|*~|14538|*~|*|~*E|*~|INE614G01033|*~|100000.000|*~|14539|*~|*|~*E|*~|INE238A01026|*~|100000.000|*~|14540|*~|*|~*A|*~|INE032A01015|*~|96|*~|*|~*D|*~|14541|*~|*|~*')    
    
CREATE function [citrus_usr].[fn_get_high_val_byslip_broker](@pa_slip varchar(8000))    
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
    
    
Select @l_max_high_val = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd = 'HIGH_VAL_CDSL'        
and bitrm_deleted_ind = 1          
    
    
    

    
select  @l_valuation = sum(isnull(clopm_cdsl_rt   ,0)   * abs(dptdc_qty))
from CLOSING_LAST_CDSL       , dptdc_mak 
where clopm_isin_cd = DPTDC_ISIN
and DPTDC_DELETED_IND in (0,-1)
and dptdc_slip_no = @pa_slip
         
    
    
set @l_yn =  case when @l_valuation >= @l_max_high_val then 'Y' ELSE 'N' END      
    
    
    
return @l_yn       
    
end

GO
