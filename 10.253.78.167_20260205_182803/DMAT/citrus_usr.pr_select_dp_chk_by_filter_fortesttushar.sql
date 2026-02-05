-- Object: PROCEDURE citrus_usr.pr_select_dp_chk_by_filter_fortesttushar
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


/*  
  
exec pr_select_dp_chk_by_filter 1,104,'DP_CLIENT','VISHAL','3','','|*~|',''   
  
exec pr_select_dp_chk_by_filter 1,104,'DP_CLIENT','VISHAL','S','123','|*~|',''   
   
  
  
 
*/   
CREATE PROCEDURE [citrus_usr].[pr_select_dp_chk_by_filter_fortesttushar]      
(      
  @pa_query_id   NUMERIC                  
  ,@pa_scr_id     NUMERIC                 
  ,@pa_tab        VARCHAR(20)                    
  ,@pa_login_name VARCHAR(20)       
  ,@pa_filter     varchar(100) --0 FOR ALL , 1 for active modification , 2 for inactive client , 3 FOR  brokerage change            
  ,@rowdelimiter  varCHAR(20) =  '*|~*'                
  ,@coldelimiter  varCHAR(4) =  '|*~|'                
  ,@pa_ref_cur    VARCHAR(8000) output                
)                
      
AS     

--set @pa_filter = '0'  

declare @rowdelimiter1	 varchar(100)
 set @rowdelimiter1 =  case when isnumeric(left(@rowdelimiter,5))=0 and isnumeric(substring(@rowdelimiter,6,4))=1 and isnumeric(right(@rowdelimiter,1))=0 then @rowdelimiter else @rowdelimiter end 
 set @rowdelimiter =  case when isnumeric(left(@rowdelimiter,5))=0 and isnumeric(substring(@rowdelimiter,6,4))=1 and isnumeric(right(@rowdelimiter,1))=0 then @rowdelimiter else '' end 
 exec pr_insert_missing_prop
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
                  
  DECLARE @t_clim   TABLE(client_code NUMERIC,name VARCHAR(200), short_name varchar(150), client_type varchar(200), enttm_id NUMERIC , category_type VARCHAR(200), clicm_id NUMERIC, clim_id NUMERIC, logn_email VARCHAR(100))                
  DECLARE @t_entpm  TABLE(entp_ent_id NUMERIC,entp_entpm_cd VARCHAR(50), entp_value varchar(50))                
            
                  
  DECLARE @t_chk    TABLE(client_code NUMERIC,name VARCHAR(200),short_name VARCHAR(150),client_type VARCHAR(200),category_type VARCHAR(200),vld_pan_number VARCHAR(50),pan_number VARCHAR(50),datacolsreqd VARCHAR(1000),disp_cols VARCHAR(5))                
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
  print '11'
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
           select entp_ent_id from entity_properties_mak , client_mstr_MAK where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)
           union
           select in_clim.clim_crn_no from client_mstr_mak in_clim where convert(varchar,in_clim.clim_Crn_no ) = @rowdelimiter and clim_deleted_ind in (0,8)
           union
           select in_clim.clim_crn_no from client_mstr_mak in_clim where convert(varchar(100),in_clim.CLIM_LST_UPD_BY  ) = @rowdelimiter and clim_deleted_ind in (0,8) ) a         
    WHERE  climm.clim_lst_upd_by      = logn.logn_name              
    AND    climm.clim_deleted_ind     IN (0, 4, 8)           
    and    a.entp_ent_id              = climm.clim_crn_no    
    AND    CASE WHEN @pa_filter in ('0','3') THEN '0'   
                WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   
                                                                          WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  
    and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2')  
                  union    
                  select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
                                                        union  
                                                        select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
                  and   @pa_filter = '3'  
                  and   clidb_deleted_ind in (0,4,8)
                  )  
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
                                            
              
       and not exists (select dpam_Crn_no from DP_ACCT_MSTR where DPAM_CRN_NO = climm.clim_crn_no and DPAM_STAM_CD ='active'           )
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
                select entp_ent_id from entity_properties_mak , client_mstr_MAK where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)
           union
            select clim_crn_no from client_mstr_mak in_clim where convert(varchar,in_clim.clim_Crn_no ) = @rowdelimiter and clim_deleted_ind in (0,8)
             union
            select clim_crn_no from client_mstr_mak in_clim where convert(varchar(100),in_clim.clim_LST_UPD_BY ) = @rowdelimiter and clim_deleted_ind in (0,8) ) a         
    WHERE  clim.clim_lst_upd_by       = logn.logn_name              
    AND    clim.clim_deleted_ind      = 1                
    and    a.entp_ent_id              = clim.clim_crn_no       
    AND    CASE WHEN @pa_filter in ('0','3') THEN '0'   
                WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   
                                                                          WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  
   
    --AND    clim.clim_lst_upd_by      <> @pa_login_name    
    and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2')  
                  union    
                  select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
                                                        union  
                                                        select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
                  and   @pa_filter = '3' 
  and   clidb_deleted_ind in (0,4,8) 
                  )            
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
                
    and not exists (select dpam_Crn_no from DP_ACCT_MSTR where DPAM_CRN_NO = clim.clim_crn_no and DPAM_STAM_CD ='active'           )                
                    
  --                
  END                
  ELSE IF @pa_tab ='DP_CLIENT' and @l_enttm_parent = ''                
  BEGIN                
  --                
  print '12'
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
                select entp_ent_id from entity_properties_mak , client_mstr_MAK where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)
           union
           select clim_crn_no from client_mstr_mak in_clim where  convert(varchar,in_clim.clim_Crn_no )= @rowdelimiter and clim_deleted_ind in (0,8) 
           UNION 
           select clim_crn_no from client_mstr_mak in_clim where  convert(varchar(100),in_clim.clim_LST_UPD_BY )= @rowdelimiter and clim_deleted_ind in (0,8) ) a         
    WHERE  climm.clim_lst_upd_by      = logn.logn_name              
    AND    climm.clim_deleted_ind    IN (0, 4, 8)   
               
    and a.entp_ent_id = climm.clim_crn_no       
   AND    CASE WHEN @pa_filter in ('0','3') THEN '0'   
                WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   
                                                                          WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  
   
    --AND    climm.clim_lst_upd_by    <> @pa_login_name    
  and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2')  
                  union    
                  select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
                                                        union  
                                                        select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
                  and   @pa_filter = '3' 
  and   clidb_deleted_ind in (0,4,8) 
                  )      
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
                                        and 
                                        
                                        (not exists (select dpam_Crn_no from DP_ACCT_MSTR where DPAM_CRN_NO = climm.clim_crn_no and DPAM_STAM_CD ='active'           )        
											--or exists (select	 1 from ACCP_MAK,DP_ACCT_MSTR 
											--			where dpam_crn_no = climm.clim_crn_no 
											--			and ACCP_ACCPM_PROP_CD in ('BBO_CODE') 
											--			and ACCP_CLISBA_ID = dpam_id  
											--			and accp_deleted_ind in (0,4,6,8)
											--			)                 
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
                select entp_ent_id from entity_properties_mak , client_mstr_MAK where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)
           union
           select clim_crn_no from client_mstr_mak in_clim where convert(varchar,in_clim.clim_Crn_no ) = @rowdelimiter and clim_deleted_ind in (0,8)
           union
           select clim_crn_no from client_mstr_mak in_clim where convert(varchar(100),in_clim.clim_LST_UPD_BY ) = @rowdelimiter and clim_deleted_ind in (0,8) ) a         
WHERE  clim.clim_lst_upd_by       = logn
.logn_name              
    AND    clim.clim_deleted_ind      = 1                
    and a.entp_ent_id = clim.clim_crn_no  
    AND    CASE WHEN @pa_filter in ('0','3') THEN '0'   
                WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   
                                                                          WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  
        
    --AND    clim.clim_lst_upd_by      <> @pa_login_name     
  and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2')  
                  union    
                  select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
                                                        union  
                                                        select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
                  and   @pa_filter = '3'  
  and   clidb_deleted_ind in (0,4,8)
                  )     
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
                                        
                                        and (not exists (select dpam_Crn_no from DP_ACCT_MSTR 
                                        where DPAM_CRN_NO = clim.clim_crn_no 
                                        and DPAM_STAM_CD ='active'           )                                                     
                                        --or exists (select	 1 
                                        --from ACCP_MAK,DP_ACCT_MSTR 
                                        --where dpam_crn_no = clim.clim_crn_no 
                                        --and ACCP_ACCPM_PROP_CD in ('BBO_CODE') 
                                        --and ACCP_CLISBA_ID = dpam_id  
                                        --and accp_deleted_ind in (0,4,6,8))  
                                               
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
                select entp_ent_id from entity_properties_mak , client_mstr_MAK where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)
           union
           select clim_crn_no from client_mstr_mak in_clim where convert(varchar,in_clim.clim_Crn_no ) = @rowdelimiter and clim_deleted_ind in (0,8)
           union
           select clim_crn_no from client_mstr_mak in_clim where convert(varchar(100),in_clim.clim_LST_UPD_BY ) = @rowdelimiter and clim_deleted_ind in (0,8) ) a         
WHERE  clim.clim_lst_upd_by       = logn
.logn_name              
    AND    clim.clim_deleted_ind      = 1                
    and a.entp_ent_id = clim.clim_crn_no  
    AND    CASE WHEN @pa_filter in ('0','3') THEN '0'   
                WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   
                                                                          WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  
        
    --AND    clim.clim_lst_upd_by      <> @pa_login_name     
  and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2')  
                  union    
                  select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
                                                        union  
                                                        select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
                  and   @pa_filter = '3'  
  and   clidb_deleted_ind in (0,4,8)
                  )     
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
                                        
                                        --and (not exists (select dpam_Crn_no from DP_ACCT_MSTR 
                                        --where DPAM_CRN_NO = clim.clim_crn_no 
                                        --and DPAM_STAM_CD ='active'           )                                                     
                                        and  exists (select	 1 
                                        from ACCP_MAK,DP_ACCT_MSTR 
                                        where dpam_crn_no = clim.clim_crn_no 
                                        and ACCP_ACCPM_PROP_CD in ('BBO_CODE') 
                                        and ACCP_CLISBA_ID = dpam_id  
                                        and accp_deleted_ind in (0,4,6,8)) 
                                        union 
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
                select entp_ent_id from entity_properties_mak , client_mstr_MAK where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)
           union
           select clim_crn_no from client_mstr_mak in_clim where  convert(varchar,in_clim.clim_Crn_no )= @rowdelimiter and clim_deleted_ind in (0,8) 
           UNION 
           select clim_crn_no from client_mstr_mak in_clim where  convert(varchar(100),in_clim.clim_LST_UPD_BY )= @rowdelimiter and clim_deleted_ind in (0,8) ) a         
    WHERE  climm.clim_lst_upd_by      = logn.logn_name              
    AND    climm.clim_deleted_ind    IN (0, 4, 8)   
               
    and a.entp_ent_id = climm.clim_crn_no       
   AND    CASE WHEN @pa_filter in ('0','3') THEN '0'   
                WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   
                                                                          WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  
   
    --AND    climm.clim_lst_upd_by    <> @pa_login_name    
  and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2')  
                  union    
                  select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
                                                        union  
                                                        select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
                  and   @pa_filter = '3' 
  and   clidb_deleted_ind in (0,4,8) 
                  )      
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
                                        and 
                                        
                                       -- (not exists (select dpam_Crn_no from DP_ACCT_MSTR where DPAM_CRN_NO = climm.clim_crn_no and DPAM_STAM_CD ='active'           )        
											 exists (select	 1 from ACCP_MAK,DP_ACCT_MSTR 
														where dpam_crn_no = climm.clim_crn_no 
														and ACCP_ACCPM_PROP_CD in ('BBO_CODE') 
														and ACCP_CLISBA_ID = dpam_id  
														and accp_deleted_ind in (0,4,6,8)
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
    print '13'
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
   AND    CASE WHEN @pa_filter in ('0','3') THEN '0'   
                WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   
                                                                          WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  
             
   --AND    climm.clim_clicm_cd        IS NULL        
   --AND    climm.clim_enttm_cd        IS NULL        
   AND    climm.clim_lst_upd_by      <> @pa_login_name   
  and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2')  
                  union    
                  select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
                                                        union  
                                                        select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
                  and   @pa_filter = '3'
  and   clidb_deleted_ind in (0,4,8)  
                  )             
   AND    getdate()                  BETWEEN logn.logn_from_dt and logn.logn_to_dt             
   AND    climm.clim_crn_no          IN (SELECT clim_crn_no                
              FROM   client_list WITH (NOLOCK)                
              WHERE  clim_deleted_ind = 1                
              AND    clim_status      in (3,10)              
              )          
   AND    climm.clim_lst_upd_by      IN (SELECT distinct  LOGN_NAME FROM LOGIN_NAMES,ENTITY_TYPE_MSTR WHERE ENTTM_ID = LOGN_ENTTM_ID          
              AND ENTTM_ID IN (SELECT TOP 1 LOGN_ENTTM_ID  FROM LOGIN_NAMES WHERE LOGN_NAME = @pa_login_name AND LOGN_DELETED_IND = 1))          
   and climm.clim_lst_upd_by  like  ltrim(rtrim(@rowdelimiter1 ))   +'%'
   and not exists (select dpam_Crn_no from DP_ACCT_MSTR where DPAM_CRN_NO = climm.clim_crn_no and DPAM_STAM_CD ='active'           )
                
                    
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
   AND    CASE WHEN @pa_filter in ('0','3') THEN '0'   
                WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   
                                                                          WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  
            
   AND    getdate()                 BETWEEN logn.logn_from_dt and logn.logn_to_dt   
  and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2')  
                  union    
                  select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
                                                        union  
                                                        select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
                  and   @pa_filter = '3'  
  and   clidb_deleted_ind in (0,4,8)
                  )             
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
                  and clim.clim_lst_upd_by  like  ltrim(rtrim(@rowdelimiter1 ))   +'%'
                  and not exists (select dpam_Crn_no from DP_ACCT_MSTR where DPAM_CRN_NO = clim.clim_crn_no and DPAM_STAM_CD ='active'           )
                      
                      
    --                
    END                
    ELSE IF @pa_tab ='DP_CLIENT' and @l_enttm_parent = ''                
    BEGIN                
    --    
  
IF @pa_filter='0'

BEGIN 
print 'sfsfs'

   INSERT INTO @t_clim                
   (client_code                 
   ,name                 
   ,short_name                 
   ,clim_id              
   ,logn_email)                
   SELECT climm.clim_crn_no            client_code                
     , climm.clim_name1+' '+ISNULL(climm.clim_name2,'')+' '+ISNULL(climm.clim_name3,'') name                
     , climm.clim_short_name + ' - ' + dpam_acct_no         short_name                
     , climm.clim_id                clim_id              
     , logn.logn_usr_email          logn_email              
   FROM   client_mstr_mak              climm  WITH (NOLOCK)          
     , login_names                  logn   WITH (NOLOCK) ,dp_acct_mstr_mak with(nolock)             
   WHERE  climm.clim_lst_upd_by      = logn.logn_name              
   AND    climm.clim_deleted_ind    IN (0, 4, 8)                
   AND    climm.clim_lst_upd_by    <> @pa_login_name   and dpam_crn_no=climm.CLIM_CRN_NO   
  and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2')  
                  union    
                  select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
                                                        union  
                                                        select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
                  and   @pa_filter = '3'  and   clidb_deleted_ind in (0,4,8)    

                  )  
   AND    CASE WHEN @pa_filter in ('0','3') THEN '0'   
                WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   
                                                                          WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  
      
   --AND    climm.clim_clicm_cd      IS NULL        
   --AND    climm.clim_enttm_cd      IS NULL  
      
   AND    getdate()                BETWEEN logn.logn_from_dt and logn.logn_to_dt              
   AND    climm.clim_crn_no        IN (SELECT clim_crn_no                
            FROM   client_list WITH (NOLOCK)                
            WHERE  clim_deleted_ind = 1                
            AND    clim_status      in (10,3)             
            )   and climm.clim_lst_upd_by  like  ltrim(rtrim(@rowdelimiter1 )) +'%'
            and not exists (select dpam_Crn_no from DP_ACCT_MSTR where DPAM_CRN_NO = climm.clim_crn_no and DPAM_STAM_CD ='active'           )
            and exists (select accd_clisba_id from accd_mak,dp_acct_mstr_mak where  accd_clisba_id=DPAM_ID
            and DPAM_DELETED_IND in(0,1) and ACCD_DELETED_IND in (0,1) and climm.CLIM_CRN_NO=DPAM_CRN_NO and ACCD_ACCDOCM_DOC_ID='12')
            --not exists removed bz client modification client not come on 06/07/2015
            
   UNION                
                    
   SELECT clim.clim_crn_no             client_code                
     , clim.clim_name1+' '+ISNULL(clim.clim_name2,'')+' '+ISNULL(clim.clim_name3,'') name                
     ,  clim.clim_short_name + ' - '  +  dpam_acct_no         short_name                
     , 0                            clim_id           
     , logn.logn_usr_email          logn_email                 
   FROM   client_mstr                  clim    WITH (NOLOCK)                
     , login_names                  logn    WITH (NOLOCK)    ,dp_acct_mstr_mak with(nolock)          
   WHERE  clim.clim_lst_upd_by       = logn.logn_name              
   AND    clim.clim_deleted_ind      = 1                
   AND    clim.clim_lst_upd_by      <> @pa_login_name     and dpam_crn_no=clim.CLIM_CRN_NO 
   AND    CASE WHEN @pa_filter in ('0','3') THEN '0'   
                  WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   
                                                                          WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  
    
   --AND    clim.clim_clicm_cd      IS NULL        
   --AND    clim.clim_enttm_cd      IS NULL     AND    getdate()                 BETWEEN logn.logn_from_dt and logn.logn_to_dt              
  and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2')  
                  union    
                  select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
                                                        union  
                                                        select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
                  and   @pa_filter = '3'
  and   clidb_deleted_ind in (0,4,8)  
                  )  
   AND    clim.clim_crn_no      IN (SELECT clim_crn_no                
            FROM   client_list WITH (NOLOCK)                
            WHERE  clim_deleted_ind = 1                
            AND    clim_status      in (10,3)             
           )              
   AND    clim.clim_crn_no      NOT IN (SELECT clim_crn_no                        
             FROM   client_mstr_mak WITH (NOLOCK)                        
             WHERE  clim_deleted_ind IN (0,4,8)              
            )    and clim.clim_lst_upd_by  like  ltrim(rtrim(@rowdelimiter1 ))   +'%'
            
            and  not exists (select dpam_Crn_no from DP_ACCT_MSTR where DPAM_CRN_NO = clim.clim_crn_no and DPAM_STAM_CD ='active'           )
            and exists (select accd_clisba_id from ACCD_MAK,dp_acct_mstr_MAK where  accd_clisba_id=DPAM_ID
            and DPAM_DELETED_IND IN (0,1) and ACCD_DELETED_IND IN (0,1) and clim.CLIM_CRN_NO=DPAM_CRN_NO and ACCD_ACCDOCM_DOC_ID='12')            
            --not exists removed bz client modification client not come on 06/07/2015
END 

IF @pa_filter  ='1'
BEGIN
print 'yyyyyy'
print '24'   
print @rowdelimiter1 + 'uu'
         

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
     --, client_list_modified              
     --, dp_acct_mstr dpam with (nolock)
   WHERE  climm.clim_lst_upd_by      = logn.logn_name              
   AND    climm.clim_deleted_ind    IN (0, 4, 8)                
   AND    climm.clim_lst_upd_by    <> @pa_login_name   
   --and	  dpam.DPAM_CRN_NO =   climm.CLIM_CRN_NO
   --and    dpam.DPAM_SBA_NO = clic_mod_dpam_sba_no
   --and   clic_mod_batch_no is null
	and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2') 
	union    
	select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
										union  
										select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
	and   @pa_filter = '3'  and   clidb_deleted_ind in (0,4,8)    

	)  
	AND    CASE WHEN @pa_filter in ('0','3') THEN '0'   
	WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   
														  WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  

	--AND    climm.clim_clicm_cd      IS NULL        
	--AND    climm.clim_enttm_cd      IS NULL  

	AND    getdate()                BETWEEN logn.logn_from_dt and logn.logn_to_dt              
	AND    climm.clim_crn_no        IN (SELECT clim_crn_no                
	FROM   client_list WITH (NOLOCK)                
	WHERE  clim_deleted_ind = 1                
	AND    clim_status      in (10,3)             
	)   and climm.clim_lst_upd_by  like  ltrim(rtrim(@rowdelimiter1 )) +'%'
	and  exists (select dpam_Crn_no from DP_ACCT_MSTR,client_list_modified  where DPAM_CRN_NO = climm.clim_crn_no 
	and DPAM_STAM_CD ='active' 
	and DPAM_SBA_NO = clic_mod_dpam_sba_no 
	and clic_mod_batch_no = '0' )
	
                    
   UNION                
        
   SELECT clim.clim_crn_no             client_code                
     , clim.clim_name1+' '+ISNULL(clim.clim_name2,'')+' '+ISNULL(clim.clim_name3,'') name                
     , clim.clim_short_name         short_name                
     , 0                            clim_id           
     , logn.logn_usr_email          logn_email                 
   FROM   client_mstr                  clim    WITH (NOLOCK)                
     , login_names                  logn    WITH (NOLOCK)
     , client_list_modified 
     , dp_acct_mstr dpam with (NOLOCK)              
   WHERE  clim.clim_lst_upd_by       = logn.logn_name              
   AND    clim.clim_deleted_ind      = 1                
   AND    clim.clim_lst_upd_by      <> @pa_login_name  
   and	  dpam.DPAM_CRN_NO =   clim.CLIM_CRN_NO
   and    dpam.DPAM_SBA_NO = clic_mod_dpam_sba_no AND clic_mod_deleted_ind = '0'
	and   ISNULL(clic_mod_batch_no ,'0')='0'
   AND    CASE WHEN @pa_filter in ('0','3') THEN '0'   
                  WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   
                                                                          WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  
    
   --AND    clim.clim_clicm_cd      IS NULL        
   --AND    clim.clim_enttm_cd      IS NULL     AND    getdate()                 BETWEEN logn.logn_from_dt and logn.logn_to_dt              
  and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2')  
                  union    
                  select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
                                                        union  
                                                        select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
                  and   @pa_filter = '3'
  and   clidb_deleted_ind in (0,4,8)  
                  )  
   AND    clim.clim_crn_no      IN (SELECT clim_crn_no                
            FROM   client_list WITH (NOLOCK)                
            WHERE  clim_deleted_ind = 1                
            AND    clim_status      in (10,3)             
           )              
           
   AND    clim.clim_crn_no      NOT IN (SELECT clim_crn_no                        
             FROM   client_mstr_mak WITH (NOLOCK)                        
             WHERE  clim_deleted_ind IN (0,4,8)              
            )    and clim.clim_lst_upd_by  like  ltrim(rtrim(@rowdelimiter1 ))   +'%'
            
            and   exists (select dpam_Crn_no from DP_ACCT_MSTR,client_list_modified 
            where DPAM_CRN_NO = clim.clim_crn_no 
            and DPAM_STAM_CD ='active' AND clic_mod_deleted_ind = '0'
            and DPAM_SBA_NO = clic_mod_dpam_sba_no 
			and ISNULL(clic_mod_batch_no ,'0')='0'  )
			union 
			  SELECT climm.clim_crn_no            client_code                
     , climm.clim_name1+' '+ISNULL(climm.clim_name2,'')+' '+ISNULL(climm.clim_name3,'') name                
     , climm.clim_short_name        short_name                
     , climm.clim_id                clim_id              
     , logn.logn_usr_email          logn_email              
   FROM   client_mstr_mak              climm  WITH (NOLOCK)          
     , login_names                  logn   WITH (NOLOCK) 
     --, client_list_modified              
     --, dp_acct_mstr dpam with (nolock)
   WHERE  climm.clim_lst_upd_by      = logn.logn_name              
   AND    climm.clim_deleted_ind    IN (0, 4, 8)                
   AND    climm.clim_lst_upd_by    <> @pa_login_name   
   --and	  dpam.DPAM_CRN_NO =   climm.CLIM_CRN_NO
   --and    dpam.DPAM_SBA_NO = clic_mod_dpam_sba_no
   --and   clic_mod_batch_no is null
	and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2') 
	union    
	select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
										union  
										select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
	and   @pa_filter = '3'  and   clidb_deleted_ind in (0,4,8)    

	)  
	AND    CASE WHEN @pa_filter in ('0','3') THEN '0'   
	WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   
														  WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  

	--AND    climm.clim_clicm_cd      IS NULL        
	--AND    climm.clim_enttm_cd      IS NULL  

	AND    getdate()                BETWEEN logn.logn_from_dt and logn.logn_to_dt              
	AND    climm.clim_crn_no        IN (SELECT clim_crn_no                
	FROM   client_list WITH (NOLOCK)                
	WHERE  clim_deleted_ind = 1                
	AND    clim_status      in (10,3)             
	)   and climm.clim_lst_upd_by  like  ltrim(rtrim(@rowdelimiter1 )) +'%'
	--and  exists (select dpam_Crn_no from DP_ACCT_MSTR,client_list_modified  where DPAM_CRN_NO = climm.clim_crn_no 
	--and DPAM_STAM_CD ='active' 
	--and DPAM_SBA_NO = clic_mod_dpam_sba_no 
	--and clic_mod_batch_no = '0' )
	 and  exists (select	 1 
                                        from ACCP_MAK,DP_ACCT_MSTR 
                                        where dpam_crn_no = climm.clim_crn_no 
                                        and ACCP_ACCPM_PROP_CD in ('BBO_CODE') 
                                        and ACCP_CLISBA_ID = dpam_id  
                                        and accp_deleted_ind in (0,4,6,8)) 
	
                    
   UNION                
        
   SELECT clim.clim_crn_no             client_code                
     , clim.clim_name1+' '+ISNULL(clim.clim_name2,'')+' '+ISNULL(clim.clim_name3,'') name                
     , clim.clim_short_name         short_name                
     , 0                            clim_id           
     , logn.logn_usr_email          logn_email                 
   FROM   client_mstr                  clim    WITH (NOLOCK)                
     , login_names                  logn    WITH (NOLOCK)
     , client_list_modified 
     , dp_acct_mstr dpam with (NOLOCK)              
   WHERE  clim.clim_lst_upd_by       = logn.logn_name              
   AND    clim.clim_deleted_ind      = 1                
   AND    clim.clim_lst_upd_by      <> @pa_login_name  
   and	  dpam.DPAM_CRN_NO =   clim.CLIM_CRN_NO
   and    dpam.DPAM_SBA_NO = clic_mod_dpam_sba_no AND clic_mod_deleted_ind = '0'
	and   ISNULL(clic_mod_batch_no ,'0')='0'
   AND    CASE WHEN @pa_filter in ('0','3') THEN '0'   
                  WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   
                                                                          WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  
    
   --AND    clim.clim_clicm_cd      IS NULL        
   --AND    clim.clim_enttm_cd      IS NULL     AND    getdate()                 BETWEEN logn.logn_from_dt and logn.logn_to_dt              
  and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2')  
                  union    
                  select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
                                                        union  
                                                        select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
                  and   @pa_filter = '3'
  and   clidb_deleted_ind in (0,4,8)  
                  )  
   AND    clim.clim_crn_no      IN (SELECT clim_crn_no                
            FROM   client_list WITH (NOLOCK)                
            WHERE  clim_deleted_ind = 1                
            AND    clim_status      in (10,3)             
           )              
           
   AND    clim.clim_crn_no      NOT IN (SELECT clim_crn_no                        
             FROM   client_mstr_mak WITH (NOLOCK)                        
             WHERE  clim_deleted_ind IN (0,4,8)              
            )    and clim.clim_lst_upd_by  like  ltrim(rtrim(@rowdelimiter1 ))   +'%'
             and  exists (select	 1 
                                        from ACCP_MAK,DP_ACCT_MSTR 
                                        where dpam_crn_no = clim.clim_crn_no 
                                        and ACCP_ACCPM_PROP_CD in ('BBO_CODE') 
                                        and ACCP_CLISBA_ID = dpam_id  
                                        and accp_deleted_ind in (0,4,6,8)) 
            
   --         and   exists (select dpam_Crn_no from DP_ACCT_MSTR,client_list_modified 
   --         where DPAM_CRN_NO = clim.clim_crn_no 
   --         and DPAM_STAM_CD ='active' AND clic_mod_deleted_ind = '0'
   --         and DPAM_SBA_NO = clic_mod_dpam_sba_no 
			--and ISNULL(clic_mod_batch_no ,'0')='0'  )
			
		--	UNION
			
		--	SELECT clim.clim_crn_no             client_code                
  --   , clim.clim_name1+' '+ISNULL(clim.clim_name2,'')+' '+ISNULL(clim.clim_name3,'') name                
  --   , clim.clim_short_name         short_name                
  --   , 0                            clim_id           
  --   , logn.logn_usr_email          logn_email                 
  -- FROM   client_mstr                  clim    WITH (NOLOCK)                
  --   , login_names                  logn    WITH (NOLOCK)
     
  --   , dp_acct_mstr dpam with (NOLOCK)              
  -- WHERE  clim.clim_lst_upd_by       = logn.logn_name              
  -- AND    clim.clim_deleted_ind      = 1                
  -- AND    clim.clim_lst_upd_by      <> @pa_login_name  
  -- and	  dpam.DPAM_CRN_NO =   clim.CLIM_CRN_NO
  
  -- AND    CASE WHEN @pa_filter in ('0','3') THEN '0'   
  --                WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   
  --                                                                        WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  
    
  -- --AND    clim.clim_clicm_cd      IS NULL        
  -- --AND    clim.clim_enttm_cd      IS NULL     AND    getdate()                 BETWEEN logn.logn_from_dt and logn.logn_to_dt              
  --and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2')  
  --                union    
  --                select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
  --                                                      union  
  --                                                      select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
  --                and   @pa_filter = '1'
  --and   clidb_deleted_ind in (0,4,8)  
  --                )  
  -- AND    clim.clim_crn_no      IN (SELECT clim_crn_no                
  --          FROM   client_list WITH (NOLOCK)                
  --          WHERE  clim_deleted_ind = 1                
  --          AND    clim_status      in (10,3)             
  --         )              
           
  -- AND    clim.clim_crn_no      NOT IN (SELECT clim_crn_no                        
  --           FROM   client_mstr_mak WITH (NOLOCK)                        
  --           WHERE  clim_deleted_ind IN (0,4,8)              
  --          )    and clim.clim_lst_upd_by  like  ltrim(rtrim(@rowdelimiter1 ))   +'%'
            
           
           
			
END               

 

IF @pa_filter='4'

BEGIN 
print 'yuyu'
   INSERT INTO @t_clim                
   (client_code                 
   ,name                 
   ,short_name                 
   ,clim_id              
   ,logn_email)                
   SELECT climm.clim_crn_no            client_code                
     , climm.clim_name1+' '+ISNULL(climm.clim_name2,'')+' '+ISNULL(climm.clim_name3,'') name                
     , climm.clim_short_name + ' - ' + dpam_acct_no         short_name                
     , climm.clim_id                clim_id              
     , logn.logn_usr_email          logn_email              
   FROM   client_mstr_mak              climm  WITH (NOLOCK)          
     , login_names                  logn   WITH (NOLOCK) ,dp_acct_mstr_mak with(nolock)             
   WHERE  climm.clim_lst_upd_by      = logn.logn_name              
   AND    climm.clim_deleted_ind    IN (0, 4, 8)                
   AND    climm.clim_lst_upd_by    <> @pa_login_name   and dpam_crn_no=climm.CLIM_CRN_NO   and DPAM_ACCT_NO like 'W%'
  and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2','4')  
                  union    
                  select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
                                                        union  
                                                        select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
                  and   @pa_filter = '4'  and   clidb_deleted_ind in (0,4,8)    

                  )  
   AND    CASE WHEN @pa_filter in ('0','3') THEN '0'  
   WHEN @pa_filter in ('4') THEN '4' 
                WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'  WHEN @pa_filter in ('4') THEN '4'  
                                                                          WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  
      
   --AND    climm.clim_clicm_cd      IS NULL        
   --AND    climm.clim_enttm_cd      IS NULL  
      
   AND    getdate()                BETWEEN logn.logn_from_dt and logn.logn_to_dt              
   AND    climm.clim_crn_no        IN (SELECT clim_crn_no                
            FROM   client_list WITH (NOLOCK)                
            WHERE  clim_deleted_ind = 1                
            AND    clim_status      in (10,3)             
            )   and climm.clim_lst_upd_by  like  ltrim(rtrim(@rowdelimiter1 )) +'%'
            and not exists (select dpam_Crn_no from DP_ACCT_MSTR where DPAM_CRN_NO = climm.clim_crn_no and DPAM_STAM_CD ='active'           )
            and exists (select accd_clisba_id from accd_mak,dp_acct_mstr_mak where  accd_clisba_id=DPAM_ID
            and DPAM_DELETED_IND in (0,1) and ACCD_DELETED_IND in (0,1) and climm.CLIM_CRN_NO=DPAM_CRN_NO and ACCD_ACCDOCM_DOC_ID='12')            
            --not exists removed bz client modification client not come on 06/07/2015
                    
   UNION                
                    
   SELECT clim.clim_crn_no             client_code                
     , clim.clim_name1+' '+ISNULL(clim.clim_name2,'')+' '+ISNULL(clim.clim_name3,'') name                
     ,  clim.clim_short_name + ' - '  +  dpam_acct_no         short_name                
     , 0                            clim_id           
     , logn.logn_usr_email          logn_email                 
   FROM   client_mstr                  clim    WITH (NOLOCK)                
     , login_names                  logn    WITH (NOLOCK)    ,dp_acct_mstr_mak with(nolock)          
   WHERE  clim.clim_lst_upd_by       = logn.logn_name              
   AND    clim.clim_deleted_ind      = 1                
   AND    clim.clim_lst_upd_by      <> @pa_login_name     and dpam_crn_no=clim.CLIM_CRN_NO  and DPAM_ACCT_NO like 'W%'
   AND    CASE WHEN @pa_filter in ('0','3') THEN '0'
   WHEN @pa_filter in ('4') THEN '4'   
                  WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   WHEN @pa_filter in ('4') THEN '4' 
                                                                          WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  
    
   --AND    clim.clim_clicm_cd      IS NULL        
   --AND    clim.clim_enttm_cd      IS NULL     AND    getdate()                 BETWEEN logn.logn_from_dt and logn.logn_to_dt              
  and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2','4')  
                  union    
                  select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
                                                        union  
                                                        select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
                  and   @pa_filter = '4'
  and   clidb_deleted_ind in (0,4,8)  
                  )  
   AND    clim.clim_crn_no      IN (SELECT clim_crn_no                
            FROM   client_list WITH (NOLOCK)                
            WHERE  clim_deleted_ind = 1                
            AND    clim_status      in (10,3)             
           )              
   AND    clim.clim_crn_no      NOT IN (SELECT clim_crn_no                        
             FROM   client_mstr_mak WITH (NOLOCK)                        
             WHERE  clim_deleted_ind IN (0,4,8)              
            )    and clim.clim_lst_upd_by  like  ltrim(rtrim(@rowdelimiter1 ))   +'%'
           
            and  not exists (select dpam_Crn_no from DP_ACCT_MSTR where DPAM_CRN_NO = clim.clim_crn_no and DPAM_STAM_CD ='active'           )
            --not exists removed bz client modification client not come on 06/07/2015
            --and exists (select accd_clisba_id from accd_mak,dp_acct_mstr_mak where ACCD_DELETED_IND=0 and accd_clisba_id=DPAM_ID
            --and DPAM_DELETED_IND=0 and ACCD_DELETED_IND=0 and clim.CLIM_CRN_NO=DPAM_CRN_NO and ACCD_ACCDOCM_DOC_ID='12')            
            and exists (select accd_clisba_id from ACCD_MAK,dp_acct_mstr_MAK where accd_clisba_id=DPAM_ID
            and DPAM_DELETED_IND IN (0,1) and ACCD_DELETED_IND IN (0,1) and clim.CLIM_CRN_NO=DPAM_CRN_NO and ACCD_ACCDOCM_DOC_ID='12')              
END --4    
          

IF @pa_filter='5'

BEGIN 

   INSERT INTO @t_clim                
   (client_code                 
   ,name                 
   ,short_name                 
   ,clim_id              
   ,logn_email)                
   SELECT climm.clim_crn_no            client_code                
     , climm.clim_name1+' '+ISNULL(climm.clim_name2,'')+' '+ISNULL(climm.clim_name3,'') name                
     , climm.clim_short_name + ' - ' + dpam_acct_no         short_name                
     , climm.clim_id                clim_id              
     , logn.logn_usr_email          logn_email              
   FROM   client_mstr_mak              climm  WITH (NOLOCK)          
     , login_names                  logn   WITH (NOLOCK) ,dp_acct_mstr_mak with(nolock)             
   WHERE  climm.clim_lst_upd_by      = logn.logn_name              
   AND    climm.clim_deleted_ind    IN (0, 4, 8)                
   AND    climm.clim_lst_upd_by    <> @pa_login_name   and dpam_crn_no=climm.CLIM_CRN_NO   and DPAM_ACCT_NO not like 'W%'
  and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2','5')  
                  union    
                  select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
                                                        union  
                                                        select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
                  and   @pa_filter = '5'  and   clidb_deleted_ind in (0,4,8)    

                  )  
   AND    CASE WHEN @pa_filter in ('0','3') THEN '0'   WHEN @pa_filter in ('5') THEN '5'  
                WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   WHEN @pa_filter in ('5') THEN '5'  
                                                                          WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  
      
   --AND    climm.clim_clicm_cd      IS NULL        
   --AND    climm.clim_enttm_cd      IS NULL  
      
   AND    getdate()                BETWEEN logn.logn_from_dt and logn.logn_to_dt              
   AND    climm.clim_crn_no        IN (SELECT clim_crn_no                
            FROM   client_list WITH (NOLOCK)                
            WHERE  clim_deleted_ind = 1                
            AND    clim_status      in (10,3)             
            )   and climm.clim_lst_upd_by  like  ltrim(rtrim(@rowdelimiter1 )) +'%'
            and not exists (select dpam_Crn_no from DP_ACCT_MSTR where DPAM_CRN_NO = climm.clim_crn_no and DPAM_STAM_CD ='active'           )
            and exists (select accd_clisba_id from accd_mak,dp_acct_mstr_mak where accd_clisba_id=DPAM_ID
            and DPAM_DELETED_IND in (0,1) and ACCD_DELETED_IND in (0,1) and climm.CLIM_CRN_NO=DPAM_CRN_NO and ACCD_ACCDOCM_DOC_ID='12')            
            --not exists removed bz client modification client not come on 06/07/2015
                    
  -- UNION                
   INSERT INTO @t_clim                
   (client_code                 
   ,name                 
   ,short_name                 
   ,clim_id              
   ,logn_email)                    
   SELECT clim.clim_crn_no             client_code                
     , clim.clim_name1+' '+ISNULL(clim.clim_name2,'')+' '+ISNULL(clim.clim_name3,'') name                
     ,  clim.clim_short_name + ' - '  +  dpam_acct_no         short_name                
     , 0                            clim_id           
     , logn.logn_usr_email          logn_email                 
   FROM   client_mstr                  clim    WITH (NOLOCK)                
     , login_names                  logn    WITH (NOLOCK)    ,dp_acct_mstr_mak with(nolock)          
   WHERE  clim.clim_lst_upd_by       = logn.logn_name              
   AND    clim.clim_deleted_ind      = 1                
   AND    clim.clim_lst_upd_by      <> @pa_login_name     and dpam_crn_no=clim.CLIM_CRN_NO and DPAM_ACCT_NO not like 'W%'
   AND    CASE WHEN @pa_filter in ('0','3') THEN '0'   WHEN @pa_filter in ('5') THEN '5'  
                  WHEN @pa_filter IN('1','2') THEN CLIM_STAM_CD END = CASE WHEN @pa_filter in ('0','3') THEN '0'   WHEN @pa_filter in ('5') THEN '5'  
                                                                          WHEN @pa_filter IN ('1','2') THEN case when @pa_filter ='1' then 'ACTIVE' when @pa_filter ='2' then 'CI'  end END  
    
   --AND    clim.clim_clicm_cd      IS NULL        
   --AND    clim.clim_enttm_cd      IS NULL     AND    getdate()                 BETWEEN logn.logn_from_dt and logn.logn_to_dt              
  and    exists(select 1 clidb_dpam_id   where @pa_filter IN('0','1','2','5')  
                  union    
                  select clidb_dpam_id from clib_mak , (select dpam_id from dp_acct_mstr where dpam_crn_no = clim_crn_no and dpam_deleted_ind = 1   
                                                        union  
                                                        select dpam_id from dp_acct_mstr_mak where dpam_crn_no = clim_crn_no and dpam_deleted_ind in (8)) a where a.dpam_id = clidb_dpam_id   
                  and   @pa_filter = '5'
  and   clidb_deleted_ind in (0,4,8)  
                  )  
   AND    clim.clim_crn_no      IN (SELECT clim_crn_no                
            FROM   client_list WITH (NOLOCK)                
            WHERE  clim_deleted_ind = 1                
            AND    clim_status      in (10,3)             
           )              
   AND    clim.clim_crn_no      NOT IN (SELECT clim_crn_no                        
             FROM   client_mstr_mak WITH (NOLOCK)                        
             WHERE  clim_deleted_ind IN (0,4,8)              
            )    and clim.clim_lst_upd_by  like  ltrim(rtrim(@rowdelimiter1 ))   +'%'
            
            and  not exists (select dpam_Crn_no from DP_ACCT_MSTR where DPAM_CRN_NO = clim.clim_crn_no and DPAM_STAM_CD ='active'           )
            --and exists (select accd_clisba_id from accd_mak,dp_acct_mstr_mak where ACCD_DELETED_IND=0 and accd_clisba_id=DPAM_ID
            --and DPAM_DELETED_IND=0 and ACCD_DELETED_IND=0 and clim.CLIM_CRN_NO=DPAM_CRN_NO and ACCD_ACCDOCM_DOC_ID='12')            
            and exists (select accd_clisba_id from AccD_MAK,dp_acct_mstr_MAK where accd_clisba_id=DPAM_ID
            and DPAM_DELETED_IND IN (0,1)  and ACCD_DELETED_IND IN (0,1) and clim.CLIM_CRN_NO=DPAM_CRN_NO and ACCD_ACCDOCM_DOC_ID='12')              
            --not exists removed bz client modification client not come on 06/07/2015
            and not exists (select 1 from @t_clim where clim.clim_crn_no = client_code)
           -- select * from @t_clim where client_code = '226919'
           
END --5    

     
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
      AND  scr.scr_name       = (SELECT scr2.scr_name          scr_name                
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
            ,replace(chk.short_name,'''','')                     short_name                 
            ,ISNULL(chk.vld_pan_number,'')      vld_pan_number                
            ,ISNULL(chk.pan_number,'')          pan_number                
            ,replace(chk.datacolsreqd + @coldelimiter +ISNULL(chk.vld_pan_number,'') ,'''','')                  datacolsreqd                
            ,chk.disp_cols                      disp_cols                
  FROM   @t_chk                             chk                
                
    --                
    END                
    ELSE IF @pa_query_id=2                
    BEGIN                
    --                
              
      SELECT DISTINCT chk.client_code      client_code                
            ,replace(chk.name,'''','')                      name                      
            ,chk.short_name                short_name                
            ,replace(chk.datacolsreqd,'''','')              datacolsreqd                
            ,chk.disp_cols                 disp_cols                
      FROM   @t_chk                        chk                
    --                
    END                
                 
                  
                
--                
END

GO
