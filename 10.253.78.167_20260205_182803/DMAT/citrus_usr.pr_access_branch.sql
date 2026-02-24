-- Object: PROCEDURE citrus_usr.pr_access_branch
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--pr_access_branch 'on','rnasik'
CREATE proc [citrus_usr].[pr_access_branch](@pa_transaction varchar(150),@pa_login_name varchar(150))  
as  
begin  
  
declare @l_ent_id numeric  
  
declare @l_FLAG char(100)  
  
select @l_ent_id = entm_id   
from  entity_mstr   
 , login_names   
where LOGN_ENT_ID =  ENTM_ID  
and   logn_name =  @pa_login_name  
  
  if @l_ent_id <> 1
  begin 

   if @pa_transaction ='OFF'  
   begin  
  
  
    select @l_FLAG = case when count(1) = 0 then 'Y' else 'N' end   from entity_properties where entp_entpm_Cd   
    in ('OFFMPUNCHTMSATSUN'  
    ,'OFFMPUNCHTMMONFRI')  
    and entp_ent_id = @l_ent_id  

  
  
     if @l_FLAG  = 'Y'  
     begin  
      select @l_FLAG   flag 
     end   
     else    
     begin  
  
      if left(datename(dw,getdate()),3) in ('SUN','SAT')  
      begin  
       select @l_FLAG = case when entp_value  > convert(varchar,getdate(),108) then 'Y' else 'N' + '|*~|' + entp_value + '|*~|' + 'SAT-SUN' end  from entity_properties where entp_entpm_Cd   
       in ('OFFMPUNCHTMSATSUN')  
       and entp_ent_id = @l_ent_id  
      end   

      if left(datename(dw,getdate()),3) not in ('SUN','SAT')  
      begin  

       select @l_FLAG = case when entp_value  > convert(varchar,getdate(),108) then 'Y' else 'N' + '|*~|' + entp_value + '|*~|' + 'MON-FRI' end  from entity_properties where entp_entpm_Cd   
       in ('OFFMPUNCHTMMONFRI')  
       and entp_ent_id = @l_ent_id  

      end   
  
		select @l_FLAG Flag  

     end   



   end   
   if @pa_transaction ='ON'  
   begin  
   
    select @l_FLAG = case when count(1) = 0 then 'Y' else 'N' end   from entity_properties where entp_entpm_Cd   
    in ('ONMPUNCHTMSATSUN'  
     ,'ONMPUNCHTMMONFRI')  
    and entp_ent_id = @l_ent_id  
  
  
     if @l_FLAG  = 'Y'  
     begin  
      select @l_FLAG    flag
     end   
     else    
     begin  
  
      if left(datename(dw,getdate()),3) in ('SUN','SAT')  
      begin  
       select @l_FLAG = case when entp_value  > convert(varchar,getdate(),108) then 'Y' else 'N' + '|*~|' + entp_value + '|*~|' + 'SAT-SUN' end  from entity_properties where entp_entpm_Cd   
       in ('ONMPUNCHTMSATSUN'  
       )  
       and entp_ent_id = @l_ent_id  
      end   
      if left(datename(dw,getdate()),3) not in ('SUN','SAT')  
      begin  
       select @l_FLAG = case when entp_value  > convert(varchar,getdate(),108) then 'Y' else 'N' + '|*~|' + entp_value + '|*~|' + 'MON-FRI' end  from entity_properties where entp_entpm_Cd   
       in ('ONMPUNCHTMMONFRI')  
       and entp_ent_id = @l_ent_id  
      end   

     select @l_FLAG Flag  
  
     end   
  
  
  
  
   end   
   if @pa_transaction ='ID'  
   begin  
      
    select @l_FLAG = case when count(1) = 0 then 'Y' else 'N' end   from entity_properties where entp_entpm_Cd   
    in ('IDPUNCHTMESATSUN'  
     ,'IDPUNCHTMEMONFRI'  
     )  
    and entp_ent_id = @l_ent_id  
  
  
     if @l_FLAG  = 'Y'  
     begin  
      select @l_FLAG    flag
     end   
     else    
     begin  
  
      if left(datename(dw,getdate()),3) in ('SUN','SAT')  
      begin  
       select @l_FLAG = case when entp_value  > convert(varchar,getdate(),108) then 'Y' else 'N' + '|*~|' + entp_value + '|*~|' + 'SAT-SUN' end  from entity_properties where entp_entpm_Cd   
       in ('IDPUNCHTMESATSUN'  
       )  
       and entp_ent_id = @l_ent_id  
      end   
      if left(datename(dw,getdate()),3) not in ('SUN','SAT')  
      begin  
       select @l_FLAG = case when entp_value  > convert(varchar,getdate(),108) then 'Y' else 'N' + '|*~|' + entp_value + '|*~|' + 'MON-FRI' end  from entity_properties where entp_entpm_Cd   
       in ('IDPUNCHTMEMONFRI')  
       and entp_ent_id = @l_ent_id  
      end   
  
select @l_FLAG Flag    
     end   
  
   end   
   if @pa_transaction ='EP'  
   begin  
  
   select @l_FLAG = case when count(1) = 0 then 'Y' else 'N' end   from entity_properties where entp_entpm_Cd   
    in ('EPPUNCHTMSATSUN'  
     ,'EPPUNCHTMMONFRI')  
    and entp_ent_id = @l_ent_id  
  
  
     if @l_FLAG  = 'Y'  
     begin  
      select @l_FLAG    flag
     end   
     else    
     begin  
  
      if left(datename(dw,getdate()),3) in ('SUN','SAT')  
      begin  
       select @l_FLAG = case when entp_value  > convert(varchar,getdate(),108) then 'Y' else 'N' + '|*~|' + entp_value + '|*~|' + 'SAT-SUN' end  from entity_properties where entp_entpm_Cd   
       in ('EPPUNCHTMSATSUN'  
       )  
       and entp_ent_id = @l_ent_id  
      end   
      if left(datename(dw,getdate()),3) not in ('SUN','SAT')  
      begin  
       select @l_FLAG = case when entp_value  > convert(varchar,getdate(),108) then 'Y' else 'N' + '|*~|' + entp_value + '|*~|' + 'MON-FRI' end  from entity_properties where entp_entpm_Cd   
       in ('EPPUNCHTMMONFRI')  
       and entp_ent_id = @l_ent_id  
      end   
  
select @l_FLAG Flag    
     end   
  
  
   end   
  
end
  
  
end

GO
