-- Object: FUNCTION citrus_usr.fn_splitstrin_byspace_for_print
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--select * from report_message
--SELECT CITRUS_USR.[fn_splitstrin_byspace_for_print]('Tushar Ashokkumar Patel 1/a vrindavan park, mahesana nagar, nizampura, vadodara 390002, gujarat, indiaVHBJHBJHJHBJHJVBHMBNMBNMBNMBNMN,MNM,NM,NM,NM,NKGHJGHGJGHJHGJMHGKHJKHJH',32,'',1)
CREATE FUNCTION [citrus_usr].[fn_splitstrin_byspace_for_print](@pa_string VARCHAR(8000),@pa_fix_len VARCHAR(50),@pa_modified VARCHAR(8000),@l_idd int = 1)      
RETURNs VARCHAR(8000)      
AS      
BEGIN      
  if @pa_modified = ''
  set @pa_string = citrus_usr.[fn_new_line_arragement](@pa_string,@pa_fix_len)
  declare @l_1 numeric        
   ,@l_counter NUMERIC        
   ,@l_count NUMERIC        
   ,@l_string VARCHAR(8000)       
   ,@l_remaining VARCHAR(8000)     
   ,@l_modified VARCHAR(8000)     
   ,@last_modified VARCHAR(8000)     
   SET @l_modified = @pa_modified    
   SET @l_counter = 1         
   SET @last_modified = ''    
    
   SELECT @pa_string = replace(@pa_string,' ','|')        
   SELECT @l_1 = citrus_usr.ufn_CountString(LEFT(replace(@pa_string,' ','|'),@pa_fix_len),'|')      
         
   SET @l_string = ''        
   IF LEN(@pa_string) > @pa_fix_len        
   begin        
     WHILE (@l_1 >= @l_counter)        
     BEGIN        
           
       SET @l_string = @l_string + ' ' + citrus_usr.FN_SPLITVAL_BY(@pa_string,@l_counter,'|')        
       SET @l_counter = @l_counter + 1        
     END    
         
     IF @pa_fix_len = 150    
     BEGIN    
     SET @l_modified  = @l_modified  + CONVERT(CHAR(150),LTRIM(@l_string ))       
  END    
  ELSE IF @pa_fix_len = 75    
     BEGIN    
     SET @l_modified  = @l_modified  + CONVERT(CHAR(75),LTRIM(@l_string ))       
  END    
  ELSE IF @pa_fix_len = 15    
     BEGIN    
     SET @l_modified  = @l_modified  + CONVERT(CHAR(15),LTRIM(@l_string ))       
  END    
  ELSE IF @pa_fix_len = 32    
     BEGIN    
     SET @l_modified  = @l_modified  + CONVERT(CHAR(32),LTRIM(@l_string ))       
  END    
  ELSE IF @pa_fix_len = 20    
     BEGIN    
     SET @l_modified  = @l_modified  + CONVERT(CHAR(20),LTRIM(@l_string ))       
  END    
  ELSE IF @pa_fix_len = 16   
     BEGIN    
     SET @l_modified  = @l_modified  + CONVERT(CHAR(16),LTRIM(@l_string ))       
  END 
  ELSE IF @pa_fix_len = 158
     BEGIN    
     SET @l_modified  = @l_modified  + CONVERT(CHAR(158),LTRIM(@l_string ))       
  END 
 ELSE IF @pa_fix_len = 145
     BEGIN    
     SET @l_modified  = @l_modified  + CONVERT(CHAR(145),LTRIM(@l_string ))       
  END    
   
   SET @l_remaining = SUBSTRING(@pa_string,LEN(replace(@l_string,' ','|'))+1,LEN(@pa_string))      
   IF @l_remaining<>''      
   begin      
   SET @pa_string =REPLACE(@l_remaining,'|',' ') 
   set @pa_string =ltrim(@pa_string)   
   set @l_idd = @l_idd + 1
			if @l_idd < 32
			begin
			--  
   SELECT @last_modified = citrus_usr.[fn_splitstrin_byspace_for_print](@pa_string ,@pa_fix_len , @l_modified ,@l_idd)    
   end
			else 
			begin
			--
			SELECT @last_modified = @l_modified  
			--
			end
    
   END   
     
         
   END        
   ELSE         
   BEGIN        
    SET @l_string = REPLACE(@pa_string,'|',' ')     
        
         IF @pa_fix_len = 150    
     BEGIN    
     SET @l_modified  = @l_modified  + CONVERT(CHAR(150),LTRIM(@l_string ))       
  END    
  ELSE IF @pa_fix_len = 75    
     BEGIN    
     SET @l_modified  = @l_modified  + CONVERT(CHAR(75),LTRIM(@l_string ))       
  END    
  ELSE IF @pa_fix_len = 15    
     BEGIN    
     SET @l_modified  = @l_modified  + CONVERT(CHAR(15),LTRIM(@l_string ))       
  END    
  ELSE IF @pa_fix_len = 32    
     BEGIN    
     SET @l_modified  = @l_modified  + CONVERT(CHAR(32),LTRIM(@l_string ))       
  END    
  ELSE IF @pa_fix_len = 20    
     BEGIN    
     SET @l_modified  = @l_modified  + CONVERT(CHAR(20),LTRIM(@l_string ))       
  END   
  ELSE IF @pa_fix_len = 16   
     BEGIN    
     SET @l_modified  = @l_modified  + CONVERT(CHAR(16),LTRIM(@l_string ))       
  END  
   ELSE IF @pa_fix_len = 158 
     BEGIN    
     SET @l_modified  = @l_modified  + CONVERT(CHAR(158),LTRIM(@l_string ))       
  END        
   ELSE IF @pa_fix_len = 145
     BEGIN    
     SET @l_modified  = @l_modified  + CONVERT(CHAR(145),LTRIM(@l_string ))       
  END    
      
     SET @last_modified = @l_modified    
   END   
          
           
       
      
    
           
       
           
   RETURN @last_modified    
         
END

GO
