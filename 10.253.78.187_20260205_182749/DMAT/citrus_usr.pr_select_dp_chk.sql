-- Object: PROCEDURE citrus_usr.pr_select_dp_chk
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

/*  
  
  
This is for select procedure for view data  
  
  
*/  
  
  
  
  
  
CREATE  PROCEDURE [citrus_usr].[pr_select_dp_chk]      
(      
  @pa_query_id   NUMERIC                  
  ,@pa_scr_id     NUMERIC                 
  ,@pa_tab        VARCHAR(20)                    
  ,@pa_login_name VARCHAR(20)                 
  ,@rowdelimiter  CHAR(20) =  '*|~*'                
  ,@coldelimiter  CHAR(4) =  '|*~|'                
  ,@pa_ref_cur    VARCHAR(8000) output                
)                
      
AS       
      
/*      
exec pr_select_dp_chk 1,104,'DP_CLIENT','VISHAL','','|*~|',''    
    
declare @p7 varchar(1)    
set @p7=NULL    
exec pr_select_dp_chk @pa_query_id=1,@pa_scr_id='104',@pa_tab='DP_CLIENT',@pa_login_name='VISHAL',@rowdelimiter='',@coldelimiter='|*~|',@pa_ref_cur=@p7 output    
select @p7    
       
*/      
               
      
      
/*******************************************************************************                
 System         : CITRUS                
 Module Name    : pr_select_dp_chk                
 Description    : This procedure will return values to populate the Client_Mstr Checker screen                
 Copyright(c)   : Marketplace Technologies Pvt. Ltd.                
 Version History:                
 Vers.  Author          Date         Reason                
 -----  -------------   ----------   ------------------------------------------------                
 1.0    Tushar          22-Aug-2007  Initial Version.                
********************************************************************************/                
BEGIN                
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED              
--                


declare @rowdelimiter1	 varchar(100)
 set @rowdelimiter1 =  case when isnumeric(left(@rowdelimiter,5))=0 and isnumeric(substring(@rowdelimiter,6,4))=1 and isnumeric(right(@rowdelimiter,1))=0 then @rowdelimiter else @rowdelimiter end 
 set @rowdelimiter =  case when isnumeric(left(@rowdelimiter,5))=0 and isnumeric(substring(@rowdelimiter,6,4))=1 and isnumeric(right(@rowdelimiter,1))=0 then @rowdelimiter else '' end 

                  
  DECLARE @t_clim   TABLE(client_code NUMERIC,name VARCHAR(200), short_name varchar(50), client_type varchar(200), enttm_id NUMERIC , category_type VARCHAR(200), clicm_id NUMERIC, clim_id NUMERIC, logn_email VARCHAR(100))                
  DECLARE @t_entpm  TABLE(entp_ent_id NUMERIC,entp_entpm_cd VARCHAR(50), entp_value varchar(50))                
            
                  
  DECLARE @t_chk    TABLE(client_code NUMERIC,name VARCHAR(200),short_name VARCHAR(50),client_type VARCHAR(200),category_type VARCHAR(200),vld_pan_number VARCHAR(50),pan_number VARCHAR(50),datacolsreqd VARCHAR(1000),disp_cols VARCHAR(5))                
  DECLARE @l_scr_id NUMERIC                 
                  
  --****************change for chk access control                
            
  DECLARE @l_enttm_parent varchar(25)          
            
  SELECT top 1 @l_enttm_parent  = ISNULL(enttm_parent_cd,'')           
  FROM   login_names           
       , entity_type_mstr           
  WHERE  enttm_id  = logn_enttm_id           
  AND    logn_name = @pa_login_name           
  AND    enttm_deleted_ind = 1           
  AND    logn_deleted_ind  = 1           
            
            
  --****************change for chk access control          
  if @rowdelimiter <> ''        
  begin         
  IF @pa_tab ='DP_CLIENT' and @l_enttm_parent <> ''                
  BEGIN                
  --                
    INSERT INTO @t_clim                
    (client_code                 
    ,name                 
    ,short_name                 
    ,clim_id              
    ,logn_email)                
    SELECT climm.clim_crn_no            client_code                
         , climm.clim_name1+' '+ISNULL(climm.clim_name2,'')+' '+ISNULL(climm.clim_name3,'') name                
         , climm.clim_short_name        short_name                
         , climm.clim_id                clim_id              
         , logn.logn_usr_email          logn_email              
    FROM   client_mstr_mak              climm  WITH (NOLOCK)                
         , login_names                  logn   WITH (NOLOCK)              
         ,(select entp_ent_id from entity_properties , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter        
                and entp_ent_id not in (select entp_ent_id from entity_properties_mak , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8))        
    union        
    select entp_ent_id from entity_properties_mak , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)        
                UNION        
                select entp_ent_id from entity_properties_mak , client_mstr_MAK where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)) a         
    WHERE  climm.clim_lst_upd_by      = logn.logn_name              
    AND    climm.clim_deleted_ind     IN (0, 4, 8)           
    and    a.entp_ent_id              = climm.clim_crn_no             
    --AND    climm.clim_clicm_cd        IS NULL        
    --AND    climm.clim_enttm_cd        IS NULL        
    --AND    climm.clim_lst_upd_by      <> @pa_login_name              
    AND    @pa_login_name    not in (SELECT clim_lst_upd_by        
                                     FROM   client_list clil WITH (NOLOCK)              
                                     WHERE  clim_deleted_ind = 1              
                                     AND    clim_status      in (3,10)        
                                     and    clil.clim_crn_no = climm.clim_crn_no  )        
    AND    getdate()                  BETWEEN logn.logn_from_dt and logn.logn_to_dt             
    AND    climm.clim_crn_no          IN (SELECT clim_crn_no                
                                          FROM   client_list WITH (NOLOCK)                
                                          WHERE  clim_deleted_ind = 1                
                                          AND    clim_status      in (3,10)        
                                           and    clim_tab not in ('Client Sub Accts','Client DP Accts','CLIENT ACCOUNTS')         
                                          )          
    AND    climm.clim_lst_upd_by      IN (SELECT distinct  LOGN_NAME FROM LOGIN_NAMES,ENTITY_TYPE_MSTR WHERE ENTTM_ID = LOGN_ENTTM_ID          
                                          AND ENTTM_ID IN (SELECT TOP 1 LOGN_ENTTM_ID  FROM LOGIN_NAMES WHERE LOGN_NAME = @pa_login_name AND LOGN_DELETED_IND = 1))          
                                            
              
                  
    UNION                
                  
    SELECT clim.clim_crn_no             client_code                
         , clim.clim_name1+' '+ISNULL(clim.clim_name2,'')+' '+ISNULL(clim.clim_name3,'') name                
         , clim.clim_short_name         short_name                
         , 0                            clim_id                 
         , logn.logn_usr_email          logn_email                 
    FROM   client_mstr                  clim    WITH (NOLOCK)        
         , login_names                  logn    WITH (NOLOCK)              
          ,(select entp_ent_id from entity_properties , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter        
                and entp_ent_id not in (select entp_ent_id from entity_properties_mak , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8))        
    union        
    select entp_ent_id from entity_properties_mak , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)        
                UNION        
                select entp_ent_id from entity_properties_mak , client_mstr_MAK where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)) a         
    WHERE  clim.clim_lst_upd_by       = logn.logn_name              
    AND    clim.clim_deleted_ind      = 1                
    and    a.entp_ent_id              = clim.clim_crn_no        
    --AND    clim.clim_lst_upd_by      <> @pa_login_name              
    AND    @pa_login_name    not in (SELECT clim_lst_upd_by        
                                     FROM   client_list clil WITH (NOLOCK)              
                                     WHERE clim_deleted_ind = 1              
                                     AND    clim_status      in (3,10)           
                                      and    clil.clim_crn_no = clim.clim_crn_no)        
    AND    getdate()                 BETWEEN logn.logn_from_dt and logn.logn_to_dt              
    AND    clim.clim_crn_no      IN (SELECT clim_crn_no                
                                     FROM   client_list WITH (NOLOCK)                
           WHERE  clim_deleted_ind = 1                
                                     AND    clim_status      in (10,3)        
                                      and    clim_tab not in ('Client Sub Accts','Client DP Accts','CLIENT ACCOUNTS')         
                                    )              
    AND    clim.clim_crn_no      NOT IN (SELECT clim_crn_no                        
                                         FROM   client_mstr_mak WITH (NOLOCK)                        
                                         WHERE  clim_deleted_ind IN (0,4,8)              
                                        )                                                      
    AND    clim.clim_lst_upd_by  IN (SELECT distinct  LOGN_NAME FROM LOGIN_NAMES,ENTITY_TYPE_MSTR WHERE ENTTM_ID = LOGN_ENTTM_ID          
                                      AND ENTTM_ID IN (SELECT TOP 1 LOGN_ENTTM_ID  FROM LOGIN_NAMES WHERE LOGN_NAME = @pa_login_name AND LOGN_DELETED_IND = 1))          
                
                    
                    
  --                
  END                
  ELSE IF @pa_tab ='DP_CLIENT' and @l_enttm_parent = ''                
  BEGIN                
  --                
    INSERT INTO @t_clim                
    (client_code                 
    ,name                 
    ,short_name                 
    ,clim_id              
    ,logn_email)                
    SELECT climm.clim_crn_no            client_code                
         , climm.clim_name1+' '+ISNULL(climm.clim_name2,'')+' '+ISNULL(climm.clim_name3,'') name                
         , climm.clim_short_name        short_name                
         , climm.clim_id                clim_id              
         , logn.logn_usr_email          logn_email              
    FROM   client_mstr_mak              climm  WITH (NOLOCK)          
         , login_names                  logn   WITH (NOLOCK)              
         ,(select entp_ent_id from entity_properties , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter        
                and entp_ent_id not in (select entp_ent_id from entity_properties_mak , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8))        
    union        
    select entp_ent_id from entity_properties_mak , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)        
                UNION        
                select entp_ent_id from entity_properties_mak , client_mstr_MAK where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)) a         
    WHERE  climm.clim_lst_upd_by      = logn.logn_name              
    AND    climm.clim_deleted_ind    IN (0, 4, 8)                
    and a.entp_ent_id = climm.clim_crn_no        
    --AND    climm.clim_lst_upd_by    <> @pa_login_name        
   AND    @pa_login_name    not in (SELECT clim_lst_upd_by        
                                     FROM   client_list clil WITH (NOLOCK)              
                                     WHERE  clim_deleted_ind = 1              
                                     AND    clim_status      in (3,10)         
                                     and    clil.clim_crn_no = climm.clim_crn_no  )        
    --AND    climm.clim_clicm_cd      IS NULL        
    --AND    climm.clim_enttm_cd      IS NULL        
    AND    getdate()                BETWEEN logn.logn_from_dt and logn.logn_to_dt              
    AND    climm.clim_crn_no        IN (SELECT clim_crn_no                
                                        FROM   client_list WITH (NOLOCK)                
                                        WHERE  clim_deleted_ind = 1                
                                        AND    clim_status      in (10,3)         
                                           and    clim_tab not in ('Client Sub Accts','Client DP Accts','CLIENT ACCOUNTS')           
                                        )          
                  
    UNION                
                  
    SELECT clim.clim_crn_no             client_code                
         , clim.clim_name1+' '+ISNULL(clim.clim_name2,'')+' '+ISNULL(clim.clim_name3,'') name                
         , clim.clim_short_name         short_name                
         , 0        clim_id                 
         , logn.logn_usr_email          logn_email                 
    FROM   client_mstr                  clim    WITH (NOLOCK)                
         , login_names                  logn    WITH (NOLOCK)              
         ,(select entp_ent_id from entity_properties , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter        
                and entp_ent_id not in (select entp_ent_id from entity_properties_mak , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8))        
    union        
    select entp_ent_id from entity_properties_mak , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)        
                UNION        
                select entp_ent_id from entity_properties_mak , client_mstr_MAK where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)) a     WHERE  clim.clim_lst_upd_by       = logn
    
.logn_name              
    AND    clim.clim_deleted_ind      = 1                
    and a.entp_ent_id = clim.clim_crn_no        
    --AND    clim.clim_lst_upd_by      <> @pa_login_name        
    AND    @pa_login_name    not in (SELECT clim_lst_upd_by        
                                     FROM   client_list clil WITH (NOLOCK)              
                                     WHERE  clim_deleted_ind = 1              
                                     AND    clim_status      in (3,10)        
                                     and    clil.clim_crn_no = clim.clim_crn_no  )        
    --AND    clim.clim_clicm_cd      IS NULL        
    --AND    clim.clim_enttm_cd      IS NULL        
    AND    getdate()                 BETWEEN logn.logn_from_dt and logn.logn_to_dt AND    clim.clim_crn_no      IN (SELECT clim_crn_no                
                                     FROM   client_list WITH (NOLOCK)                
                                     WHERE  clim_deleted_ind = 1                
                                     AND    clim_status      in (10,3)           
                                     and    clim_tab not in ('Client Sub Accts','Client DP Accts','CLIENT ACCOUNTS')           
                                    )              
    AND    clim.clim_crn_no      NOT IN (SELECT clim_crn_no                        
                                         FROM   client_mstr_mak WITH (NOLOCK)                        
                                         WHERE  clim_deleted_ind IN (0,4,8)              
                                        )                              
                    
  --                
  END                
  end        
  else        
  begin        
  --        
    IF @pa_tab ='DP_CLIENT' and @l_enttm_parent <> ''                
    BEGIN                
    --                
   INSERT INTO @t_clim                
   (client_code                 
   ,name                 
   ,short_name                 
   ,clim_id              
   ,logn_email)                
   SELECT climm.clim_crn_no            client_code                
     , climm.clim_name1+' '+ISNULL(climm.clim_name2,'')+' '+ISNULL(climm.clim_name3,'') name                
     , climm.clim_short_name        short_name                
     , climm.clim_id                clim_id              
     , logn.logn_usr_email          logn_email              
   FROM   client_mstr_mak              climm  WITH (NOLOCK)                
     , login_names                  logn   WITH (NOLOCK)              
   WHERE  climm.clim_lst_upd_by      = logn.logn_name              
   AND    climm.clim_deleted_ind     IN (0, 4, 8)                
   --AND    climm.clim_clicm_cd        IS NULL        
   --AND    climm.clim_enttm_cd        IS NULL        
   AND    climm.clim_lst_upd_by      <> @pa_login_name              
   AND    getdate()                  BETWEEN logn.logn_from_dt and logn.logn_to_dt             
   AND    climm.clim_crn_no          IN (SELECT clim_crn_no                
              FROM   client_list WITH (NOLOCK)                
              WHERE  clim_deleted_ind = 1                
              AND    clim_status      in (3,10)              
              )          
   AND    climm.clim_lst_upd_by      IN (SELECT distinct  LOGN_NAME FROM LOGIN_NAMES,ENTITY_TYPE_MSTR WHERE ENTTM_ID = LOGN_ENTTM_ID          
              AND ENTTM_ID IN (SELECT TOP 1 LOGN_ENTTM_ID  FROM LOGIN_NAMES WHERE LOGN_NAME = @pa_login_name AND LOGN_DELETED_IND = 1))          
                                              
             and climm.clim_lst_upd_by = @rowdelimiter1        
                    
   UNION                
                    
   SELECT clim.clim_crn_no             client_code                
     , clim.clim_name1+' '+ISNULL(clim.clim_name2,'')+' '+ISNULL(clim.clim_name3,'') name                
     , clim.clim_short_name         short_name                
     , 0                            clim_id                 
     , logn.logn_usr_email          logn_email                 
   FROM   client_mstr                  clim    WITH (NOLOCK)        
     , login_names                  logn    WITH (NOLOCK)              
   WHERE  clim.clim_lst_upd_by       = logn.logn_name              
   AND    clim.clim_deleted_ind      = 1                
   AND    clim.clim_lst_upd_by      <> @pa_login_name              
   AND    getdate()                 BETWEEN logn.logn_from_dt and logn.logn_to_dt              
   AND    clim.clim_crn_no      IN (SELECT clim_crn_no                
            FROM   client_list WITH (NOLOCK)                
            WHERE  clim_deleted_ind = 1                
            AND    clim_status      in (10,3)             
           )              
   AND    clim.clim_crn_no      NOT IN (SELECT clim_crn_no                        
             FROM   client_mstr_mak WITH (NOLOCK)                        
             WHERE  clim_deleted_ind IN (0,4,8)              
            )                                                      
   AND    clim.clim_lst_upd_by  IN (SELECT distinct  LOGN_NAME FROM LOGIN_NAMES,ENTITY_TYPE_MSTR WHERE ENTTM_ID = LOGN_ENTTM_ID          
             AND ENTTM_ID IN (SELECT TOP 1 LOGN_ENTTM_ID  FROM LOGIN_NAMES WHERE LOGN_NAME = @pa_login_name AND LOGN_DELETED_IND = 1))          
            and clim.clim_lst_upd_by = @rowdelimiter1           
                      
                      
    --                
    END                
    ELSE IF @pa_tab ='DP_CLIENT' and @l_enttm_parent = ''                
    BEGIN                
    --                
   INSERT INTO @t_clim                
   (client_code                 
   ,name                 
   ,short_name   
   ,clim_id              
   ,logn_email)                
   SELECT climm.clim_crn_no            client_code                
     , climm.clim_name1+' '+ISNULL(climm.clim_name2,'')+' '+ISNULL(climm.clim_name3,'') name                
     , climm.clim_short_name        short_name                
     , climm.clim_id                clim_id              
     , logn.logn_usr_email          logn_email              
   FROM   client_mstr_mak              climm  WITH (NOLOCK)          
     , login_names                  logn   WITH (NOLOCK)              
   WHERE  climm.clim_lst_upd_by      = logn.logn_name              
   AND    climm.clim_deleted_ind    IN (0, 4, 8)                
   AND    climm.clim_lst_upd_by    <> @pa_login_name        
   --AND    climm.clim_clicm_cd      IS NULL        
   --AND    climm.clim_enttm_cd      IS NULL        
   AND    getdate()                BETWEEN logn.logn_from_dt and logn.logn_to_dt              
   AND    climm.clim_crn_no        IN (SELECT clim_crn_no                
            FROM   client_list WITH (NOLOCK)                
            WHERE  clim_deleted_ind = 1                
            AND    clim_status      in (10,3)             
            )          
                  and climm.clim_lst_upd_by = @rowdelimiter1       
   UNION                
                    
   SELECT clim.clim_crn_no             client_code                
     , clim.clim_name1+' '+ISNULL(clim.clim_name2,'')+' '+ISNULL(clim.clim_name3,'') name                
     , clim.clim_short_name         short_name                
     , 0                            clim_id           
     , logn.logn_usr_email          logn_email                 
   FROM   client_mstr                  clim    WITH (NOLOCK)                
     , login_names                  logn    WITH (NOLOCK)              
   WHERE  clim.clim_lst_upd_by       = logn.logn_name              
   AND    clim.clim_deleted_ind      = 1                
   AND    clim.clim_lst_upd_by      <> @pa_login_name        
   --AND    clim.clim_clicm_cd      IS NULL        
   --AND    clim.clim_enttm_cd      IS NULL     AND    getdate()                 BETWEEN logn.logn_from_dt and logn.logn_to_dt              
   AND    clim.clim_crn_no      IN (SELECT clim_crn_no                
            FROM   client_list WITH (NOLOCK)                
            WHERE  clim_deleted_ind = 1                
            AND    clim_status      in (10,3)             
           )              
   AND    clim.clim_crn_no      NOT IN (SELECT clim_crn_no                        
             FROM   client_mstr_mak WITH (NOLOCK)                        
             WHERE  clim_deleted_ind IN (0,4,8)              
            )                                                      
                    and clim.clim_lst_upd_by = @rowdelimiter1       
    --                
    END                
  --        
  end                
                  
  INSERT INTO @t_entpm                
      (entp_ent_id                
      ,entp_entpm_cd                
      ,entp_value                
      )                
      SELECT entpm.entp_ent_id         entp_ent_id                
           , entpm.entp_entpm_cd       entp_entpm_cd                
           , entpm.entp_value          entp_value                
      FROM   entity_properties_mak     entpm                
      WHERE  entpm.entp_deleted_ind IN (0, 4, 8)                
      AND    entpm.entp_entpm_cd    = 'PAN_GIR_NO'                
      UNION                
      SELECT entp.entp_ent_id          entp_ent_id                
           , entp.entp_entpm_cd        entp_entpm_cd                
           , entp.entp_value           entp_value                
      FROM   entity_properties         entp                
      WHERE  entp.entp_deleted_ind   = 1                
      AND    entp.entp_entpm_cd      = 'PAN_GIR_NO'                
      AND    entp.entp_ent_id       IN (SELECT clim_crn_no                
                                        FROM   client_list                
                                        WHERE  clim_deleted_ind = 1       
                                        AND    clim_status      in (3,10)        
                                       )                
                  
                  
      SELECT @l_scr_id          = scr.scr_id                
      FROM   screens              scr                
      WHERE  scr.scr_checker_yn = 1                
      AND    scr.scr_name       = (SELECT scr2.scr_name          scr_name                
                                   FROM   screens                scr2                
                                   WHERE  scr2.scr_id          = @pa_scr_id                
                                   AND    scr2.scr_deleted_ind = 1                
                                  )                  
                  
                  
      INSERT INTO @t_chk                
      (client_code          
      ,name                 
      ,short_name                 
      ,vld_pan_number                 
      ,pan_number                 
      ,datacolsreqd                 
      ,disp_cols                 
      )                
      SELECT client_code                
            ,name                 
            ,short_name                 
            ,''                
            ,''                
            ,CONVERT(VARCHAR,@l_scr_id)+@coldelimiter+CONVERT(VARCHAR,client_code)+@coldelimiter+CONVERT(VARCHAR,clim_id)+@coldelimiter+CONVERT(VARCHAR(1000),logn_email)  +@coldelimiter   +name        
            ,'3'                
      FROM @t_clim                
                
    IF @pa_query_id = 1                
    BEGIN                
    --                
      
      UPDATE @t_chk                
      SET    vld_pan_number          = entpm.entp_value                
      FROM   @t_chk                                
           , @t_entpm entpm                          
      WHERE  entpm.entp_ent_id    = client_code                
      AND    entpm.entp_entpm_cd     ='PAN_GIR_NO'                
                
                
      SELECT DISTINCT chk.client_code           client_code                
            ,chk.name                           name                 
            ,chk.short_name                     short_name                 
            ,ISNULL(chk.vld_pan_number,'')      vld_pan_number                
            ,ISNULL(chk.pan_number,'')          pan_number                
            ,chk.datacolsreqd + @coldelimiter +ISNULL(chk.vld_pan_number,'')                   datacolsreqd                
            ,chk.disp_cols                      disp_cols                
  FROM   @t_chk                             chk                
                
    --                
    END                
    ELSE IF @pa_query_id=2                
    BEGIN                
    --                
              
      SELECT DISTINCT chk.client_code      client_code                
            ,chk.name                      name                      
            ,chk.short_name                short_name                
            ,chk.datacolsreqd              datacolsreqd                
            ,chk.disp_cols                 disp_cols                
      FROM   @t_chk                        chk                
    --                
    END                
                 
                  
                
--                
END

GO
