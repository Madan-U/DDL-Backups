-- Object: PROCEDURE citrus_usr.pr_ins_upd_cmr_rpt_bak_latesh
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create PROCEDURE  [citrus_usr].[pr_ins_upd_cmr_rpt_bak_latesh]  
                              (   
                                    @pa_id            VARCHAR(2000)  
                                   ,@pa_action        VARCHAR(20)                        
                                   ,@pa_boid          VARCHAR(20)                      
                                   ,@pa_reqdate       VARCHAR(25)                      
                                   ,@pa_reqstat       VARCHAR(250)                      
                                   ,@pa_reportpath    VARCHAR(250)                      
                                   ,@pa_created_by    VARCHAR(8000)                     
                                   ,@pa_created_dt    VARCHAR(8000)                    
                                   ,@pa_lastupdate_by VARCHAR(25)                        
                                   ,@pa_lastupdate_dt CHAR(10)     
								   ,@pa_excsm_id      numeric     
								   ,@pa_login_pr_entm_id numeric              
								   ,@pa_login_entm_cd_chain  varchar(8000)              
                                   ,@pa_out varchar(30)     out               
                                  )                      
AS                 
  
DECLARE @l_str1 VARCHAR(8000)    
,@l_str2 VARCHAR(500)    
,@l_str3 VARCHAR(500)  
,@l_str4 VARCHAR(500)  
,@l_counter INT    
,@l_max_counter INT    

DECLARE @@DPMID INT                     
SELECT @@DPMID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @pa_excsm_id AND DPM_DELETED_IND =1 
DECLARE @@L_CHILD_ENTM_ID      NUMERIC              
SELECT @@L_CHILD_ENTM_ID    =  CITRUS_USR.FN_GET_CHILD(@PA_LOGIN_PR_ENTM_ID , @PA_LOGIN_ENTM_CD_CHAIN)

CREATE TABLE #temp_crm (boid VARCHAR(1000) , cpath varchar(1000))   
truncate table #temp_crm    
  
if @pa_action = 'save'  
  
begin  
  
insert into CMR_dtls_mstr  
     (             
     CMR_boid  
     ,CMR_reqdt  
     ,CMR_reqstat  
     ,CMR_reportpath  
     ,CMR_created_by  
     ,CMR_created_dt  
     ,CMR_lst_upd_by  
     ,CMR_lst_upd_dt  
     ,CMR_deleted_ind
	 ,CMR_excsm_id )  
     values   
                    (@pa_boid  
     , getdate()  
     , @pa_reqstat  
     , @pa_reportpath  
     , @pa_created_by  
     , getdate()  
     , @pa_lastupdate_by  
     , @pa_lastupdate_dt  
     ,0
	 ,@pa_excsm_id)  
       
  
end  
  
  
  
if @pa_action = 'select'  
  
begin  
  
select CMR_boid,CMR_reqdt 
from CMR_dtls_mstr ,CITRUS_USR.FN_ACCT_LIST(@@DPMID ,@PA_LOGIN_PR_ENTM_ID,@@L_CHILD_ENTM_ID) ACCOUNT 		         
where CMR_deleted_ind = 0   
and CMR_boid = account.dpam_sba_no
and CMR_boid like case when @pa_boid ='' then '%' else @pa_boid end  
and convert(varchar(11),CMR_reqdt,109) like case when @pa_reqdate ='' then '%' else @pa_reqdate end   
and CMR_excsm_id = @pa_excsm_id
  
end  
  
  
if @pa_action = 'save_pending'  
   
begin  
  
  SET @l_counter = 1    
  SET @l_str1 = @pa_id  
  SET @l_str3 = @pa_reportpath    
  SET @l_max_counter = citrus_usr.ufn_countstring(@l_str1,'*|~*')    
  WHILE @l_counter  <= @l_max_counter    
  BEGIN    
  --     
    SELECT @l_str2 = citrus_usr.FN_SPLITVAL_ROW(@l_str1,@l_counter)    
    SELECT @l_str4 = citrus_usr.FN_SPLITVAL_ROW(@l_str3,@l_counter)    
    INSERT INTO #temp_crm VALUES(@l_str2,@l_str4)    
       
    SET @l_counter   = @l_counter   + 1    
  --      
  END   
  
update CMR_dtls_mstr  
set CMR_deleted_ind = 1 ,CMR_reportpath = cpath  
from CMR_dtls_mstr,#temp_crm  
where CMR_boid = boid  
  
  
  
--update CMR_dtls_mstr  
--set CMR_reportpath = (select cpath from #temp_crm )  
drop table #temp_crm  
  
end

GO
