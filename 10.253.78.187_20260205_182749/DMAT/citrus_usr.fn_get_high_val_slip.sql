-- Object: FUNCTION citrus_usr.fn_get_high_val_slip
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

  
CREATE  function [citrus_usr].[fn_get_high_val_slip](@l_details varchar(8000),@pa_request_date datetime)      
returns char(5)      
as      
begin      
--      
  declare @l_yn char(5)      
  declare @l_rate numeric(18,5)      
  , @l_max_high_val numeric(18,5)      
  , @firstapp varchar(2)    
  ,@l_string varchar(1000)  
  ,@l_counter numeric  
  ,@l_count numeric  
  ,@l_val numeric(18,3)  
  Select @l_max_high_val = bitrm_bit_location from bitmap_ref_mstr
   where bitrm_parent_cd = 'HIGH_VAL_CDSL'    and bitrm_deleted_ind = 1      
       
  set @l_counter  = 1   
  set  @l_val = 0   
  select @l_count  = citrus_usr.ufn_countstring(@l_details,'*|~*')  
  set @l_string  =''  
  while @l_count  > = @l_counter  
  begin   
  
     set @l_string  = citrus_usr.FN_SPLITVAL_by(@l_details,@l_counter,'*|~*')  
       
          
     select top 1 @l_rate = clopm_cdsl_rt from CLOSING_LAST_cdsl   
     where clopm_isin_cd = citrus_usr.FN_SPLITVAL(@l_string   ,2) order by 1 desc        
            
     set @l_val =   @l_val + citrus_usr.FN_SPLITVAL(@l_string   ,3) * @l_rate   
       
     set @l_counter = @l_counter + 1   
       
  end   
      
  set @l_yn = case when @l_val >= @l_max_high_val then 'Y' ELSE 'N' END        
    
  return @l_yn      
--      
end

GO
