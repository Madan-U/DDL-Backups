-- Object: FUNCTION citrus_usr.fn_get_accesscode
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

Create function [citrus_usr].[fn_get_accesscode](@pa_values varchar(8000))
returns numeric(18,0)
as 
begin

declare @@l_rola_access1       INT  
         , @L_delimeter           VARCHAR(10)    
         , @Loop_counter          NUMERIC   
         , @Loop_counter_dec      NUMERIC  
         , @@c_bitrm_bit_location INT  
         , @@c_access_cursor      CURSOR    
         , @@c_excsm_id           NUMERIC 
         , @@l_excsm_id           NUMERIC   
          
  
  declare @l_counter numeric
  ,@l_count numeric
  declare @t table(excsm_id numeric) 
  
  
  set @@l_rola_access1 = 0 
  
  set @l_count  = citrus_usr.ufn_countstring(@pa_values,'|*~|')
  
  set @l_counter = 1 
  
  while @l_counter <= @l_count
  begin
  
  insert into @t
  select citrus_usr.fn_splitval(@pa_values,@l_counter)
  
  
  set @l_counter  = @l_counter  + 1 
  
  end 
  
  
  
  
  SET    @@c_access_cursor  = CURSOR FAST_FORWARD FOR    
                      SELECT bitrm_bit_location   
                      FROM   (SELECT bitrm_bit_location  
									 ,bitrm_parent_cd  
									 ,excsm_id  
							   FROM   bitmap_ref_mstr bitrm  
									 ,exch_seg_mstr excsm  
							   WHERE  excsm.excsm_desc        = bitrm.bitrm_child_cd  
							   AND    bitrm.bitrm_parent_cd     IN ('ACCESS1', 'ACCESS2')  
							   AND    bitrm.bitrm_deleted_ind = 1  
							   AND    excsm.excsm_deleted_ind = 1  
							   ) a
					   WHERE excsm_id in (select excsm_id from @t)
                      --  
                      OPEN  @@c_access_cursor    
                      FETCH NEXT FROM @@c_access_cursor INTO @@c_bitrm_bit_location  
                      --  
  
                      while @@fetch_status = 0    
                      BEGIN  
                      --    
                       SET @@l_rola_access1 = power(2, @@c_bitrm_bit_location -1) | @@l_rola_access1    
                         
                       FETCH NEXT FROM @@c_access_cursor INTO @@c_bitrm_bit_location  
                      --    
                      END  
                      --  
                        CLOSE      @@c_access_cursor    
                        DEALLOCATE @@c_access_cursor  
                        
                        return @@l_rola_access1
                        
end

GO
