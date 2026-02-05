-- Object: PROCEDURE citrus_usr.pr_branch_list
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--pr_branch_list 'RG',90  
  
create procedure [citrus_usr].[pr_branch_list](@pa_entity_type varchar(25),@pa_entity_id numeric)      
as      
begin      
--      
  create table  #temp(branch_id int)     
     
  declare @br_colname varchar(50)    
       , @log_colname  varchar(50)    
       , @l            varchar(8000)    
    
    
     
    select @br_colname = entem_entr_col_name from enttm_entr_mapping where entem_enttm_cd = 'BR'    
    select @log_colname = entem_entr_col_name from enttm_entr_mapping where entem_enttm_cd in (select entm_enttm_cd from entity_mstr where entm_id  = @pa_entity_id)    
    set @l =  'select  distinct ' + @br_colname  + ' branch_id from entity_relationship  where  ' +  @log_colname + ' = ' + convert(varchar,@pa_entity_id)  + ' and ' + @br_colname +  ' <> 0'
    print @l  
    exec(@l)  
       

--      
end

GO
