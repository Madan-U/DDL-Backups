-- Object: FUNCTION citrus_usr.fn_get_child
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--select citrus_usr.[fn_get_child](0,'BASIS POINT|*~|FAM111|*~|')  
--select * from entity_mstr order by  1 desc  
--select citrus_usr.[fn_get_child](0,'JMF HO_HO|*~|RG_RE|*~|')  
CREATE function [citrus_usr].[fn_get_child](@pa_parent_id int ,@pa_values varchar(8000))    
returns int     
as    
BEGIN    
--    
    
declare @l table (entm_id int ,cd varchar(25))    
DECLARE @l_counter NUMERIC            
      , @l_count   NUMERIC            
      , @l_entm_id NUMERIC      
      , @l_enttm_cd VARCHAR(20)    
      , @l_id     int    
    
    
          
            
     SET @l_count  = 1            
            
     SET @l_counter = citrus_usr.ufn_countstring(@pa_values,'|*~|')            
            
     WHILE @l_count  <= @l_counter            
     BEGIN          
     --            
            
       SELECT @l_entm_id =  entm_id , @l_enttm_cd = entm_enttm_cd FROM entity_mstr WHERE entm_short_name = (citrus_usr.fn_splitval(@pa_values,@l_count ))            
            
       INSERT INTO @l VALUES(@l_entm_id,@l_enttm_cd)             
            
       SET @l_count  = @l_count  + 1       
           
     
     --            
     END            
            
  INSERT INTO @l    
  select distinct a.enttm_id, isnull(b.enttm_parent_cd,a.enttm_cd) from entity_type_mstr a , entity_type_mstr b     
  where a.enttm_cd = b.enttm_parent_cd    
  and   a.enttm_cd in(select cd from @l)    
    
    
  delete from @l where cd in     
  (select distinct isnull(b.enttm_parent_cd,a.enttm_cd) from entity_type_mstr a , entity_type_mstr b     
  where a.enttm_cd = b.enttm_parent_cd    
  and   a.enttm_cd in(select cd from @l))    
      
    
 select top 1 @l_id  = entm_id  from @l     
    
if @pa_parent_id = @l_id      
set @l_id = 0     
    
    
return isnull(@l_id,0)    
    
    
    
    
    
--    
END

GO
