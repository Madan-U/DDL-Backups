-- Object: PROCEDURE citrus_usr.procd_mis
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--[procd_mis] '','het','','','jun 02 2008','jul 05 2009'
CREATE PROCEDURE  [citrus_usr].[procd_mis](@PA_ID            VARCHAR(20)                                                                                                                                                                             
, @PA_LOGIN_NAME    VARCHAR(20)                                                                                                                                          
, @Pa_cd    VARCHAR(20)  
, @PA_desc          VARCHAR(20)                                                                                                       
, @PA_FROM_DT        VARCHAR(11)                                                                                                                                                                                                                  
, @PA_TO_DT          VARCHAR(11) 
)                                                                                                                                                                                   



As

BEGIN 


BEGIN                                                                                   
DECLARE  @tb_reqhid  TABLE(reqh_id NUMERIC)                                                                                                                                                                                                             

INSERT INTO  @tb_reqhid(reqh_id)           
SELECT DISTINCT wfrh.reqh_id     reqh_id                                                                                                                                                                  
FROM  wf_request_history        wfrh                                                                                                      
,wf_action_tree             wfat                                                                    
,wf_rol_action_mapping      wfram                                                                                                                                                                                                    
WHERE wfrh.reqh_rolam_id       = wfat.actt_parent_id                                                                                                                              
AND   wfat.actt_child_id      = wfram.rolam_id                                                                                                                                                                                                     
AND   wfram.rolam_rol_id  IN(Select entro_rol_id from entity_roles where entro_logn_name = @PA_LOGIN_NAME)                                                                                                                                                                                             
AND   wfrh.reqh_status        ='A'                                                                                                
AND   wfrh.reqh_deleted_ind   =1                                                                                             
AND   wfat.actt_deleted_ind   =1                                             
AND   wfram.rolam_deleted_ind = 1  



SELECT wfrh.reqh_id  BOD  into #BOD
FROM   wf_request_history         wfrh                                                                                                                         
,wf_rol_action_mapping    wfram                                                                                                                                                     
,wf_action_mstr    wfam                                                                                                                                                                                          
,wf_process_mstr     wfpm                                             
,entity_mstr        entm                                                                                          
, login_names             logn                                                                                                                                                                                                      
WHERE  wfrh.reqh_rolam_id        = wfram.rolam_id                                                                                                                                                                                                              
AND    wfram.rolam_actm_id      = wfam.actm_id                                                                                                  
AND    wfam.actm_procm_id        = wfpm.procm_id                                                                   
AND    wfrh.reqh_id IN (SELECT reqh_id FROM @tb_reqhid)                                                                                                          
AND  entm.entm_id = logn.logn_ent_id                                                                                                                                                                                                        
and  logn.logn_name= reqh_created_by                                                                                                                                             
AND  wfrh.reqh_deleted_ind   =1                                                        
AND    wfpm.procm_deleted_ind =1                                                                                                                                                                                                
AND    wfram.rolam_deleted_ind = 1                                                                          
AND    wfam.actm_deleted_ind   =1  
AND    wfpm.procm_id LIKE CASE WHEN LTRIM(RTRIM(@pa_id))   = '' THEN '%' ELSE @pa_id END                                                                                                                                  
and    case when wfrh.reqh_assign_to ='' then @pa_login_name else wfrh.reqh_assign_to end= @pa_login_name                                                                                                                                       
AND    case when exists(select entm_id from entity_mstr where entm_short_name =REQH_BRANCH_CD and isnull(entm_parent_id,0) = 0 ) then 'Y' else citrus_usr.ACCESS_RIGHT_FOR_WORKFLOW(@pa_login_name ,REQH_BRANCH_CD ,'')   end  ='Y'
and convert(datetime,convert(varchar(11),reqh_created_dt,109)) between @pa_from_dt and @pa_to_dt
--                AND    convert(varchar,wfrh.reqh_lst_upd_dt,103)   >=  CASE WHEN LTRIM(RTRIM(@pa_from_dt)) <> '' THEN convert(varchar,@pa_from_dt,103) ELSE '01/01/1900' END --CONVERT(DATETIME,@PA_FROM_DT)                                                               
--               AND    convert(varchar,wfrh.reqh_lst_upd_dt,103)  <=  CASE WHEN LTRIM(RTRIM(@pa_to_dt))   <> '' THEN convert(varchar,@pa_to_dt,103)  ELSE '01/01/3000' END --CONVERT(DATETIME,@PA_TO_DT)                                                                                          




SELECT  wfrh.reqh_id [Assign] into #Assign
FROM   wf_request_history         wfrh                                                                                                                         
,wf_rol_action_mapping    wfram                                                                                                                                                     
,wf_action_mstr    wfam                                                                                                                                                                                          
,wf_process_mstr     wfpm                                             
,entity_mstr        entm                                                                                          
, login_names             logn                                                                                                                                                                                                      
WHERE  wfrh.reqh_rolam_id        = wfram.rolam_id                                                                                                                                                                                                              
AND    wfram.rolam_actm_id      = wfam.actm_id                                                                                                  
AND    wfam.actm_procm_id        = wfpm.procm_id                                                                   
AND    wfrh.reqh_id IN (SELECT reqh_id FROM @tb_reqhid)                                                                                                          
AND  entm.entm_id = logn.logn_ent_id                                                                                                                                                                                                        
and  logn.logn_name= reqh_created_by                                                                                                                                             
AND  wfrh.reqh_deleted_ind   =1                                                        
AND    wfpm.procm_deleted_ind =1                                                                                                                                                                                                
AND    wfram.rolam_deleted_ind = 1                                                                          
AND    wfam.actm_deleted_ind   =1  
AND    wfpm.procm_id LIKE CASE WHEN LTRIM(RTRIM(@pa_id))   = '' THEN '%' ELSE @pa_id END                                                                                                                               
and    case when wfrh.reqh_assign_to ='' then @pa_login_name else wfrh.reqh_assign_to end= @pa_login_name                                                                                                                                       
AND    case when exists(select entm_id from entity_mstr where entm_short_name =REQH_BRANCH_CD and isnull(entm_parent_id,0) = 0 ) then 'Y' else citrus_usr.ACCESS_RIGHT_FOR_WORKFLOW(@pa_login_name ,REQH_BRANCH_CD ,'')   end  ='Y'
AND    convert(varchar(11),wfrh.reqh_lst_upd_dt ,103)   =  convert(varchar(11),getdate() ,103)  



SELECT wfrh.reqh_id   [Completed] into #Completed                                                                             
FROM   wf_request_history  wfrh                                                                                                                   
,wf_rol_action_mapping      wfram                                                                                                                                                                                                   
,wf_action_mstr       wfam                                          
,wf_process_mstr            wfpm                                                
,entity_mstr        entm                                                                                                                       
,login_names    logn                                                     
WHERE  wfrh.reqh_rolam_id       = wfram.rolam_id                                                                                                                                                                                     
AND    wfram.rolam_actm_id    = wfam.actm_id                                                                                                                                                 
AND    wfam.actm_procm_id     = wfpm.procm_id                                                                                                                                       
AND    entm.entm_id = logn.logn_ent_id                                                                                            
and    logn.logn_name= reqh_created_by  
and wfram.rolam_rol_id  IN(Select entro_rol_id from entity_roles where entro_logn_name = @PA_LOGIN_NAME)                                                                                                                                                                                                                               

AND    wfpm.procm_id LIKE CASE WHEN LTRIM(RTRIM(@pa_id))   = '' THEN '%' ELSE @pa_id END  
and convert(datetime,convert(varchar(11),reqh_created_dt,109)) between @pa_from_dt and @pa_to_dt                                                         
AND    wfrh.reqh_deleted_ind   =1                                                                                                                                                                                                                   
AND    wfpm.procm_deleted_ind =1                                                                                                                                                
AND    wfram.rolam_deleted_ind = 1                                                                                                                             
AND    wfam.actm_deleted_ind   =1 
and    reqh_created_by  = @PA_LOGIN_NAME
AND    case when exists(select entm_id from entity_mstr where entm_short_name =REQH_BRANCH_CD and isnull(entm_parent_id,0) = 0 ) then 'Y' else citrus_usr.ACCESS_RIGHT_FOR_WORKFLOW(@pa_login_name ,REQH_BRANCH_CD ,'')   end  ='Y'     
-- And    wfrh.reqh_udn_no LIKE CASE WHEN LTRIM(RTRIM(@PA_RMKS)) = '' THEN '%' ELSE @PA_RMKS END                                                                          




SELECT wfrh.reqh_id    [Today Completed]  into  #Today_Completed                                                                         
FROM   wf_request_history  wfrh                                                                                                                   
,wf_rol_action_mapping      wfram                                                                                                                                                                                                   
,wf_action_mstr       wfam                                          
,wf_process_mstr            wfpm                                                
,entity_mstr        entm                                                                                                                       
,login_names    logn                                                     
WHERE  wfrh.reqh_rolam_id       = wfram.rolam_id                                                                                                                                                                                     
AND    wfram.rolam_actm_id    = wfam.actm_id                                                                                                                                                 
AND    wfam.actm_procm_id     = wfpm.procm_id                                                                                                                                       
AND    entm.entm_id = logn.logn_ent_id                                                                                            
and    logn.logn_name= reqh_created_by  
and wfram.rolam_rol_id  IN(Select entro_rol_id from entity_roles where entro_logn_name = @PA_LOGIN_NAME)                                                                                                                                                                                                                               

AND    wfpm.procm_id LIKE CASE WHEN LTRIM(RTRIM(@pa_id))   = '' THEN '%' ELSE @pa_id END  
AND    convert(varchar(11),wfrh.reqh_lst_upd_dt ,103)   =  convert(varchar(11),getdate() ,103)                                                      
AND    wfrh.reqh_deleted_ind   =1                                                                                                                                                                                                                   
AND    wfpm.procm_deleted_ind =1                                                                                                                                                
AND    wfram.rolam_deleted_ind = 1                                                                                                                             
AND    wfam.actm_deleted_ind   =1 
and    reqh_created_by  = @PA_LOGIN_NAME
AND    case when exists(select entm_id from entity_mstr where entm_short_name =REQH_BRANCH_CD and isnull(entm_parent_id,0) = 0 ) then 'Y' else citrus_usr.ACCESS_RIGHT_FOR_WORKFLOW(@pa_login_name ,REQH_BRANCH_CD ,'')   end  ='Y'     




select count([BOD])[BOD] ,count([Assign]) [Assign],count([Completed]) [Completed], count([Today Completed]) [Today Completed]
,case when count([Assign]) = 0  then 0 else ( count([Today Completed])* 100)/count([Assign])  end [% Completed]
, convert(varchar(11),REQH_CREATED_DT,103) Date  --,case when sum(Assign) = 0  then 0 else (sum([Today Completed])* 100)/sum(Assign ) end [% Completed]
from wf_request_history left outer join 
#BOD on REQH_ID = [BOD] left outer join 
#Assign on REQH_ID = [Assign] left outer join 
#Completed on REQH_ID = [Completed] left outer join
#Today_Completed on REQH_ID = [Today Completed]
where convert(datetime,convert(varchar(11),reqh_created_dt,109)) between @pa_from_dt and @pa_to_dt
group by convert(datetime,convert(varchar(11),reqh_created_dt,109))

                                                                                        




END  
end

GO
