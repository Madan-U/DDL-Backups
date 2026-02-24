-- Object: FUNCTION citrus_usr.fn_splitstrin_first_letter
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--SELECT citrus_usr.fn_splitstrin_first_letter('vishal koulg ggg',16,'' )    
    
CREATE FUNCTION [citrus_usr].[fn_splitstrin_first_letter](@pa_string VARCHAR(8000),@pa_fix_len VARCHAR(50),@pa_modified VARCHAR(8000))      
RETURNs VARCHAR(8000)      
AS      
BEGIN      
  declare @l_1 numeric        
   ,@l_counter NUMERIC        
   ,@l_count NUMERIC        
   ,@l_string VARCHAR(100)       
   ,@l_remaining VARCHAR(500)     
   ,@l_modified VARCHAR(500)     
   ,@last_modified VARCHAR(500)     
   SET @l_modified = @pa_modified    
   SET @l_counter = 1         
   SET @last_modified = ''    
    
   SELECT @pa_string = replace(@pa_string+' ',' ','|')        
   SELECT @l_1 = citrus_usr.ufn_CountString(@pa_string,'|')  
         
   SET @l_string = ''        
   IF LEN(@pa_string) > @pa_fix_len        
   BEGIN  
           
     WHILE (@l_1 > @l_counter)        
     BEGIN        
       SET @l_string = @l_string   + LEFT(citrus_usr.FN_SPLITVAL_BY(@pa_string,@l_counter,'|'),1) + ' '       
       SET @l_counter = @l_counter + 1        
     END  
       
    SET @l_string  = @l_string + citrus_usr.FN_SPLITVAL_BY(@pa_string,@l_counter,'|')  
         
   END        
   ELSE         
   BEGIN        
     SET @l_string = REPLACE(@pa_string,'|',' ')     
       
   END   
          
           
       
      
    
   
           
   RETURN @l_string  
         
END

GO
