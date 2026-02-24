-- Object: PROCEDURE citrus_usr.pr_select_chk
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--PR_SELECT_CHK 1,'35','CLIENT','BR1','*|~*','|*~|',''  
  
CREATE  PROCEDURE [citrus_usr].[pr_select_chk]( @pa_query_id   NUMERIC        
                              ,@pa_scr_id     NUMERIC       
                              ,@pa_tab        VARCHAR(20)          
                              ,@pa_login_name VARCHAR(20)       
                              ,@rowdelimiter  CHAR(20) =  '*|~*'      
                              ,@coldelimiter  CHAR(4) =  '|*~|'      
                              ,@pa_ref_cur    VARCHAR(8000) output      
                              )      
AS      
/*******************************************************************************      
 System         : CITRUS      
 Module Name    : pr_select_chk      
 Description    : This procedure will return values to populate the Client_Mstr Checker screen      
 Copyright(c)   : ENC Software Solutions Pvt. Ltd.      
 Version History:      
 Vers.  Author          Date         Reason      
 -----  -------------   ----------   ------------------------------------------------      
 1.0    Tushar          16-APR-2007  Initial Version.      
********************************************************************************/      
BEGIN      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
--      
        
  DECLARE @t_clim   TABLE(client_code NUMERIC,name VARCHAR(200), short_name varchar(50), client_type varchar(200), enttm_id NUMERIC , category_type VARCHAR(200), clicm_id NUMERIC, clim_id NUMERIC, logn_email VARCHAR(100))      
  DECLARE @t_entpm  TABLE(entp_ent_id NUMERIC,entp_entpm_cd VARCHAR(50), entp_value varchar(50))      
  --DECLARE @t_entm   TABLE(entm_id NUMERIC,name VARCHAR(50),entm_short_name VARCHAR(50) ,entm_enttm_cd varchar(20),enttm_id NUMERIC ,entm_clicm_cd VARCHAR(20) ,clicm_id NUMERIC,entmmak_id  NUMERIC)      
        
  DECLARE @t_chk    TABLE(client_code NUMERIC,name VARCHAR(200),short_name VARCHAR(50),client_type VARCHAR(200),category_type VARCHAR(200),vld_pan_number VARCHAR(50),pan_number VARCHAR(50),datacolsreqd VARCHAR(1000),disp_cols VARCHAR(5),vld_form_no varchar(25))      
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
	  IF @pa_tab ='CLIENT' and @l_enttm_parent <> ''      
	  BEGIN      
	  --      
		INSERT INTO @t_clim      
		(client_code       
		,name       
		,short_name       
		,client_type       
		,enttm_id       
		,category_type       
		,clicm_id      
		,clim_id    
		,logn_email)      
		SELECT climm.clim_crn_no            client_code      
			 , climm.clim_name1+' '+ISNULL(climm.clim_name2,'')+' '+ISNULL(climm.clim_name3,'') name      
			 , climm.clim_short_name        short_name      
			 , enttm.enttm_desc             client_type      
			 , enttm.enttm_id               enttm_id      
			 , clicm.clicm_desc             category_type      
			 , clicm.clicm_id               clicm_id      
			 , climm.clim_id                clim_id    
			 , logn.logn_usr_email          logn_email    
		FROM   client_mstr_mak              climm  WITH (NOLOCK)      
			 , entity_type_mstr             enttm  WITH (NOLOCK)      
			 , client_ctgry_mstr            clicm  WITH (NOLOCK)    
			 , login_names                  logn    WITH (NOLOCK)    
              ,(select entp_ent_id from entity_properties , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter
                and entp_ent_id not in (select entp_ent_id from entity_properties_mak , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8))
				union
				select entp_ent_id from entity_properties_mak , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)
                UNION
                select entp_ent_id from entity_properties_mak , client_mstr_MAK where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)) a 
		WHERE  climm.clim_clicm_cd        = clicm.clicm_cd      
		AND    climm.clim_enttm_cd        = enttm.enttm_cd      
        and    a.entp_ent_id              = climm.clim_crn_no
		AND    climm.clim_lst_upd_by      = logn.logn_name    
		AND    climm.clim_deleted_ind    IN (0, 4, 8)      
		--AND    climm.clim_lst_upd_by    <> @pa_login_name  
	   AND    exists (SELECT clim_crn_no      
										 FROM   client_list WITH (NOLOCK)      
										 WHERE  clim_crn_no = climm.clim_crn_no      
										 and    clim_deleted_ind = 1      
										 AND    clim_status      in (1,10)
										 and    clim_tab not in ('dp acct mstr','dp holder dtls','dp poa dtls')
										)  
		AND    not exists (SELECT clim_lst_upd_by
										  FROM   client_list clil WITH (NOLOCK)      
										  WHERE  clim_deleted_ind = 1      
										  AND    clim_status      in (1,10)  
										  and    clil.clim_crn_no = climm.clim_crn_no 
										  and clim_lst_upd_by= @pa_login_name)
		--AND    getdate()                BETWEEN logn.logn_from_dt and logn.logn_to_dt    
	      
		AND    climm.clim_lst_upd_by  IN (SELECT distinct  LOGN_NAME FROM LOGIN_NAMES,ENTITY_TYPE_MSTR WHERE ENTTM_ID = LOGN_ENTTM_ID
										  AND ENTTM_ID IN (SELECT TOP 1 LOGN_ENTTM_ID  FROM LOGIN_NAMES WHERE LOGN_NAME = @pa_login_name AND LOGN_DELETED_IND = 1))
	                                  
	    
	        
		INSERT INTO @t_clim      
		(client_code       
		,name       
		,short_name       
		,client_type       
		,enttm_id       
		,category_type       
		,clicm_id      
		,clim_id    
		,logn_email)
		SELECT clim.clim_crn_no             client_code      
			 , clim.clim_name1+' '+ISNULL(clim.clim_name2,'')+' '+ISNULL(clim.clim_name3,'') name      
			 , clim.clim_short_name         short_name      
			 , enttm.enttm_desc             client_type      
			 , enttm.enttm_id               enttm_id      
			 , clicm.clicm_desc             category_type      
			 , clicm.clicm_id               clicm_id      
			 , 0                            clim_id       
			 , logn.logn_usr_email          logn_email       
		FROM   client_mstr                  clim    WITH (NOLOCK)      
			 , entity_type_mstr             enttm   WITH (NOLOCK)      
			 , client_ctgry_mstr            clicm   WITH (NOLOCK)      
			 , login_names                  logn    WITH (NOLOCK)    
             ,(select entp_ent_id from entity_properties , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter
                and entp_ent_id not in (select entp_ent_id from entity_properties_mak , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8))
				union
				select entp_ent_id from entity_properties_mak , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)
                UNION
                select entp_ent_id from entity_properties_mak , client_mstr_MAK where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)) a 
		WHERE  clim.clim_clicm_cd         = clicm.clicm_cd  
        and    a.entp_ent_id              = clim.clim_crn_no    
		AND    clim.clim_enttm_cd         = enttm.enttm_cd      
		AND    clim.clim_lst_upd_by       = logn.logn_name    
		AND    clim.clim_deleted_ind      = 1      
	   -- AND    clim.clim_lst_upd_by      <> @pa_login_name   
	   AND    exists (SELECT clim_crn_no      
										 FROM   client_list WITH (NOLOCK)      
										 WHERE  clim_crn_no = clim.clim_crn_no      
										 and    clim_deleted_ind = 1      
										 AND    clim_status      in (1,10)
										 and    clim_tab not in ('dp acct mstr','dp holder dtls','dp poa dtls')
										) 
		AND    not exists (SELECT clim_lst_upd_by
										  FROM   client_list clil WITH (NOLOCK)      
										  WHERE  clim_deleted_ind = 1      
										  AND    clim_status      in (1,10)  
										  and    clil.clim_crn_no = clim.clim_crn_no 
										  and clim_lst_upd_by= @pa_login_name)
		--AND    getdate()                 BETWEEN logn.logn_from_dt and logn.logn_to_dt    
	          
		AND    clim.clim_crn_no      NOT IN (SELECT clim_crn_no              
											 FROM   client_mstr_mak WITH (NOLOCK)              
											 WHERE  clim_deleted_ind IN (0,4,8)    
											)                                            
		AND    clim.clim_lst_upd_by  IN (SELECT distinct  LOGN_NAME FROM LOGIN_NAMES,ENTITY_TYPE_MSTR WHERE ENTTM_ID = LOGN_ENTTM_ID
										  AND ENTTM_ID IN (SELECT TOP 1 LOGN_ENTTM_ID  FROM LOGIN_NAMES WHERE LOGN_NAME = @pa_login_name AND LOGN_DELETED_IND = 1))
	      
	          
	          
	  --      
	  END      
	  ELSE IF @pa_tab ='CLIENT' and @l_enttm_parent = ''      
	  BEGIN      
	  --      
		INSERT INTO @t_clim      
		(client_code       
		,name       
		,short_name       
		,client_type       
		,enttm_id       
		,category_type       
		,clicm_id      
		,clim_id    
		,logn_email)      
		SELECT climm.clim_crn_no            client_code      
			 , climm.clim_name1+' '+ISNULL(climm.clim_name2,'')+' '+ISNULL(climm.clim_name3,'') name      
			 , climm.clim_short_name        short_name      
			 , enttm.enttm_desc             client_type      
			 , enttm.enttm_id               enttm_id      
			 , clicm.clicm_desc             category_type      
			 , clicm.clicm_id               clicm_id      
			 , climm.clim_id                clim_id    
			 , logn.logn_usr_email          logn_email    
		FROM   client_mstr_mak              climm  WITH (NOLOCK)      
			 , entity_type_mstr             enttm  WITH (NOLOCK)      
			 , client_ctgry_mstr            clicm  WITH (NOLOCK)    
			 , login_names                  logn    WITH (NOLOCK)    
       ,(select entp_ent_id from entity_properties , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter
                and entp_ent_id not in (select entp_ent_id from entity_properties_mak , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8))
				union
				select entp_ent_id from entity_properties_mak , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)
                UNION
                select entp_ent_id from entity_properties_mak , client_mstr_MAK where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)) a 
		WHERE  climm.clim_clicm_cd        = clicm.clicm_cd      
		AND    climm.clim_enttm_cd        = enttm.enttm_cd      
        and    a.entp_ent_id              = climm.clim_crn_no
		AND    climm.clim_lst_upd_by      = logn.logn_name    
		AND    climm.clim_deleted_ind    IN (0, 4, 8)      
		--AND    climm.clim_lst_upd_by    <> @pa_login_name 
	 AND    exists (SELECT clim_crn_no      
										 FROM   client_list WITH (NOLOCK)      
										 WHERE  clim_crn_no = climm.clim_crn_no      
										 and    clim_deleted_ind = 1      
										 AND    clim_status      in (1,10)
										 and    clim_tab not in ('dp acct mstr','dp holder dtls','dp poa dtls')
										) 
		 AND    not exists (SELECT clim_lst_upd_by
										  FROM   client_list clil WITH (NOLOCK)      
										  WHERE  clim_deleted_ind = 1      
										  AND    clim_status      in (1,10)  
										  and    clil.clim_crn_no = climm.clim_crn_no 
										  and clim_lst_upd_by= @pa_login_name)
		--AND    getdate()                BETWEEN logn.logn_from_dt and logn.logn_to_dt    
	      
	        
		 INSERT INTO @t_clim      
		(client_code       
		,name       
		,short_name       
		,client_type       
		,enttm_id       
		,category_type       
		,clicm_id      
		,clim_id    
		,logn_email)
		SELECT clim.clim_crn_no             client_code      
			 , clim.clim_name1+' '+ISNULL(clim.clim_name2,'')+' '+ISNULL(clim.clim_name3,'') name      
			 , clim.clim_short_name         short_name      
			 , enttm.enttm_desc             client_type      
			 , enttm.enttm_id               enttm_id      
			 , clicm.clicm_desc             category_type      
			 , clicm.clicm_id               clicm_id      
			 , 0                            clim_id       
			 , logn.logn_usr_email          logn_email       
		FROM   client_mstr                  clim    WITH (NOLOCK)      
			 , entity_type_mstr             enttm   WITH (NOLOCK)      
			 , client_ctgry_mstr            clicm   WITH (NOLOCK)      
			 , login_names                  logn    WITH (NOLOCK)    
             ,(select entp_ent_id from entity_properties , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter
                and entp_ent_id not in (select entp_ent_id from entity_properties_mak , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8))
				union
				select entp_ent_id from entity_properties_mak , client_mstr where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)
                UNION
                select entp_ent_id from entity_properties_mak , client_mstr_MAK where clim_crn_no = entp_ent_id and entp_entpm_cd  = 'PAN_GIR_NO' and entp_value  = @rowdelimiter and entp_deleted_ind in (0,8)) a 
		WHERE  clim.clim_clicm_cd         = clicm.clicm_cd      
		AND    clim.clim_enttm_cd         = enttm.enttm_cd      
        and    a.entp_ent_id              = clim.clim_crn_no
		AND    clim.clim_lst_upd_by       = logn.logn_name    
		AND    clim.clim_deleted_ind      = 1      
		--AND    clim.clim_lst_upd_by      <> @pa_login_name    
	     
		--AND    getdate()                 BETWEEN logn.logn_from_dt and logn.logn_to_dt    
		AND    exists (SELECT clim_crn_no      
										 FROM   client_list WITH (NOLOCK)      
										 WHERE  clim_crn_no = clim.clim_crn_no      
										 and    clim_deleted_ind = 1      
										 AND    clim_status      in (1,10)
										 and    clim_tab not in ('dp acct mstr','dp holder dtls','dp poa dtls')
										)    
		AND    not exists (SELECT clim_lst_upd_by
										  FROM   client_list clil WITH (NOLOCK)      
										  WHERE  clil.clim_crn_no = clim.clim_crn_no 
										  and    clim_deleted_ind = 1      
										  AND    clim_status      in (1,10)  
	                                      
										  and clim_lst_upd_by= @pa_login_name)
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
    IF @pa_tab ='CLIENT' and @l_enttm_parent <> ''      
	  BEGIN      
	  --      
		INSERT INTO @t_clim      
		(client_code       
		,name       
		,short_name       
		,client_type       
		,enttm_id       
		,category_type       
		,clicm_id      
		,clim_id    
		,logn_email)      
		SELECT climm.clim_crn_no            client_code      
			 , climm.clim_name1+' '+ISNULL(climm.clim_name2,'')+' '+ISNULL(climm.clim_name3,'') name      
			 , climm.clim_short_name        short_name      
			 , enttm.enttm_desc             client_type      
			 , enttm.enttm_id               enttm_id      
			 , clicm.clicm_desc             category_type      
			 , clicm.clicm_id               clicm_id      
			 , climm.clim_id                clim_id    
			 , logn.logn_usr_email          logn_email    
		FROM   client_mstr_mak              climm  WITH (NOLOCK)      
			 , entity_type_mstr             enttm  WITH (NOLOCK)      
			 , client_ctgry_mstr            clicm  WITH (NOLOCK)    
			 , login_names                  logn    WITH (NOLOCK)    
		WHERE  climm.clim_clicm_cd        = clicm.clicm_cd      
		AND    climm.clim_enttm_cd        = enttm.enttm_cd      
		AND    climm.clim_lst_upd_by      = logn.logn_name    
		AND    climm.clim_deleted_ind    IN (0, 4, 8)      
		--AND    climm.clim_lst_upd_by    <> @pa_login_name  
	   AND    exists (SELECT clim_crn_no      
										 FROM   client_list WITH (NOLOCK)      
										 WHERE  clim_crn_no = climm.clim_crn_no      
										 and    clim_deleted_ind = 1      
										 AND    clim_status      in (1,10)
										 and    clim_tab not in ('dp acct mstr','dp holder dtls','dp poa dtls')
										)  
		AND    not exists (SELECT clim_lst_upd_by
										  FROM   client_list clil WITH (NOLOCK)      
										  WHERE  clim_deleted_ind = 1      
										  AND    clim_status      in (1,10)  
										  and    clil.clim_crn_no = climm.clim_crn_no 
										  and clim_lst_upd_by= @pa_login_name)
		--AND    getdate()                BETWEEN logn.logn_from_dt and logn.logn_to_dt    
	      
		AND    climm.clim_lst_upd_by  IN (SELECT distinct  LOGN_NAME FROM LOGIN_NAMES,ENTITY_TYPE_MSTR WHERE ENTTM_ID = LOGN_ENTTM_ID
										  AND ENTTM_ID IN (SELECT TOP 1 LOGN_ENTTM_ID  FROM LOGIN_NAMES WHERE LOGN_NAME = @pa_login_name AND LOGN_DELETED_IND = 1))
	                                  
	    
	        
		INSERT INTO @t_clim      
		(client_code       
		,name       
		,short_name       
		,client_type       
		,enttm_id       
		,category_type       
		,clicm_id      
		,clim_id    
		,logn_email)
		SELECT clim.clim_crn_no             client_code      
			 , clim.clim_name1+' '+ISNULL(clim.clim_name2,'')+' '+ISNULL(clim.clim_name3,'') name      
			 , clim.clim_short_name         short_name      
			 , enttm.enttm_desc             client_type      
			 , enttm.enttm_id               enttm_id      
			 , clicm.clicm_desc             category_type      
			 , clicm.clicm_id               clicm_id      
			 , 0                            clim_id       
			 , logn.logn_usr_email          logn_email       
		FROM   client_mstr                  clim    WITH (NOLOCK)      
			 , entity_type_mstr             enttm   WITH (NOLOCK)      
			 , client_ctgry_mstr            clicm   WITH (NOLOCK)      
			 , login_names                  logn    WITH (NOLOCK)    
		WHERE  clim.clim_clicm_cd         = clicm.clicm_cd      
		AND    clim.clim_enttm_cd         = enttm.enttm_cd      
		AND    clim.clim_lst_upd_by       = logn.logn_name    
		AND    clim.clim_deleted_ind      = 1      
	   -- AND    clim.clim_lst_upd_by      <> @pa_login_name   
	   AND    exists (SELECT clim_crn_no      
										 FROM   client_list WITH (NOLOCK)      
										 WHERE  clim_crn_no = clim.clim_crn_no      
										 and    clim_deleted_ind = 1      
										 AND    clim_status      in (1,10)
										 and    clim_tab not in ('dp acct mstr','dp holder dtls','dp poa dtls')
										) 
		AND    not exists (SELECT clim_lst_upd_by
										  FROM   client_list clil WITH (NOLOCK)      
										  WHERE  clim_deleted_ind = 1      
										  AND    clim_status      in (1,10)  
										  and    clil.clim_crn_no = clim.clim_crn_no 
										  and clim_lst_upd_by= @pa_login_name)
		--AND    getdate()                 BETWEEN logn.logn_from_dt and logn.logn_to_dt    
	          
		AND    clim.clim_crn_no      NOT IN (SELECT clim_crn_no              
											 FROM   client_mstr_mak WITH (NOLOCK)              
											 WHERE  clim_deleted_ind IN (0,4,8)    
											)                                            
		AND    clim.clim_lst_upd_by  IN (SELECT distinct  LOGN_NAME FROM LOGIN_NAMES,ENTITY_TYPE_MSTR WHERE ENTTM_ID = LOGN_ENTTM_ID
										  AND ENTTM_ID IN (SELECT TOP 1 LOGN_ENTTM_ID  FROM LOGIN_NAMES WHERE LOGN_NAME = @pa_login_name AND LOGN_DELETED_IND = 1))
	      
	          
	          
	  --      
	  END      
	  ELSE IF @pa_tab ='CLIENT' and @l_enttm_parent = ''      
	  BEGIN      
	  --      
		INSERT INTO @t_clim      
		(client_code       
		,name       
		,short_name       
		,client_type       
		,enttm_id       
		,category_type       
		,clicm_id      
		,clim_id    
		,logn_email)      
		SELECT climm.clim_crn_no            client_code      
			 , climm.clim_name1+' '+ISNULL(climm.clim_name2,'')+' '+ISNULL(climm.clim_name3,'') name      
			 , climm.clim_short_name        short_name      
			 , enttm.enttm_desc             client_type      
			 , enttm.enttm_id               enttm_id      
			 , clicm.clicm_desc             category_type      
			 , clicm.clicm_id               clicm_id      
			 , climm.clim_id                clim_id    
			 , logn.logn_usr_email          logn_email    
		FROM   client_mstr_mak              climm  WITH (NOLOCK)      
			 , entity_type_mstr             enttm  WITH (NOLOCK)      
			 , client_ctgry_mstr            clicm  WITH (NOLOCK)    
			 , login_names                  logn    WITH (NOLOCK)    
		WHERE  climm.clim_clicm_cd        = clicm.clicm_cd      
		AND    climm.clim_enttm_cd        = enttm.enttm_cd      
		AND    climm.clim_lst_upd_by      = logn.logn_name    
		AND    climm.clim_deleted_ind    IN (0, 4, 8)      
		--AND    climm.clim_lst_upd_by    <> @pa_login_name 
	 AND    exists (SELECT clim_crn_no      
										 FROM   client_list WITH (NOLOCK)      
										 WHERE  clim_crn_no = climm.clim_crn_no      
										 and    clim_deleted_ind = 1      
										 AND    clim_status      in (1,10)
										 and    clim_tab not in ('dp acct mstr','dp holder dtls','dp poa dtls')
										) 
		 AND    not exists (SELECT clim_lst_upd_by
										  FROM   client_list clil WITH (NOLOCK)      
										  WHERE  clim_deleted_ind = 1      
										  AND    clim_status      in (1,10)  
										  and    clil.clim_crn_no = climm.clim_crn_no 
										  and clim_lst_upd_by= @pa_login_name)
		--AND    getdate()                BETWEEN logn.logn_from_dt and logn.logn_to_dt    
	      
	        
		 INSERT INTO @t_clim      
		(client_code       
		,name       
		,short_name       
		,client_type       
		,enttm_id       
		,category_type       
		,clicm_id      
		,clim_id    
		,logn_email)
		SELECT clim.clim_crn_no             client_code      
			 , clim.clim_name1+' '+ISNULL(clim.clim_name2,'')+' '+ISNULL(clim.clim_name3,'') name      
			 , clim.clim_short_name         short_name      
			 , enttm.enttm_desc             client_type      
			 , enttm.enttm_id               enttm_id      
			 , clicm.clicm_desc             category_type      
			 , clicm.clicm_id               clicm_id      
			 , 0                            clim_id       
			 , logn.logn_usr_email          logn_email       
		FROM   client_mstr                  clim    WITH (NOLOCK)      
			 , entity_type_mstr             enttm   WITH (NOLOCK)      
			 , client_ctgry_mstr            clicm   WITH (NOLOCK)      
			 , login_names                  logn    WITH (NOLOCK)    
		WHERE  clim.clim_clicm_cd         = clicm.clicm_cd      
		AND    clim.clim_enttm_cd         = enttm.enttm_cd      
		AND    clim.clim_lst_upd_by       = logn.logn_name    
		AND    clim.clim_deleted_ind      = 1      
		--AND    clim.clim_lst_upd_by      <> @pa_login_name    
	     
		--AND    getdate()                 BETWEEN logn.logn_from_dt and logn.logn_to_dt    
		AND    exists (SELECT clim_crn_no      
										 FROM   client_list WITH (NOLOCK)      
										 WHERE  clim_crn_no = clim.clim_crn_no      
										 and    clim_deleted_ind = 1      
										 AND    clim_status      in (1,10)
										 and    clim_tab not in ('dp acct mstr','dp holder dtls','dp poa dtls')
										)    
		AND    not exists (SELECT clim_lst_upd_by
										  FROM   client_list clil WITH (NOLOCK)      
										  WHERE  clil.clim_crn_no = clim.clim_crn_no 
										  and    clim_deleted_ind = 1      
										  AND    clim_status      in (1,10)  
	                                      
										  and clim_lst_upd_by= @pa_login_name)
		AND    clim.clim_crn_no      NOT IN (SELECT clim_crn_no              
											 FROM   client_mstr_mak WITH (NOLOCK)              
											 WHERE  clim_deleted_ind IN (0,4,8)    
											)                                            
	          
	  --      
	  END     
  --
  end
 
  IF @pa_tab='ENTITY'      
  BEGIN      
  --      
    INSERT INTO @t_clim      
    (client_code       
    ,name       
    ,short_name       
    ,client_type       
    ,enttm_id       
    ,category_type       
    ,clicm_id      
    ,clim_id    
    ,logn_email)      
    SELECT entmm.entm_id                client_code      
         , entmm.entm_name1+' '+ISNULL(entmm.entm_name2,'')+' '+ISNULL(entmm.entm_name3,'') name      
         , entmm.entm_short_name        short_name      
         , enttm.enttm_desc             client_type      
         , enttm.enttm_id               enttm_id      
         , clicm.clicm_desc             category_type      
         , clicm.clicm_id               clicm_id      
         , entmm.entmak_id              clim_id          
         , logn.logn_usr_email          logn_email        
    FROM   entity_mstr_mak              entmm  WITH (NOLOCK)      
         , entity_type_mstr             enttm  WITH (NOLOCK)      
         , client_ctgry_mstr            clicm  WITH (NOLOCK)      
         , login_names                  logn    WITH (NOLOCK)    
    WHERE  entmm.entm_clicm_cd        = clicm.clicm_cd      
    AND    entmm.entm_enttm_cd        = enttm.enttm_cd      
    AND    entmm.entm_lst_upd_by      = logn.logn_name     
    AND    entmm.entm_deleted_ind     IN (0, 4, 8)      
    AND    entmm.entm_lst_upd_by      <> @pa_login_name    
    AND    getdate()                  BETWEEN logn.logn_from_dt and logn.logn_to_dt    
    AND    entmm.entm_id              IN (SELECT entm_id      
                                         FROM   entity_list WITH (NOLOCK)      
                                         WHERE  entm_deleted_ind = 1    
                                         AND    entm_status      = 1     
                                        )    
       
    INSERT INTO @t_clim      
    (client_code       
    ,name       
    ,short_name       
    ,client_type       
    ,enttm_id       
    ,category_type       
    ,clicm_id      
    ,clim_id    
    ,logn_email) 
    SELECT entm.entm_id                client_code      
         , entm.entm_name1+' '+ISNULL(entm.entm_name2,'')+' '+ISNULL(entm.entm_name3,'') name      
         , entm.entm_short_name         short_name      
         , enttm.enttm_desc             client_type      
         , enttm.enttm_id   enttm_id      
         , clicm.clicm_desc             category_type      
         , clicm.clicm_id               clicm_id      
         , 0                            clim_id          
         , logn.logn_usr_email          logn_email         
    FROM   entity_mstr                  entm    WITH (NOLOCK)      
         , entity_type_mstr             enttm   WITH (NOLOCK)      
         , client_ctgry_mstr            clicm   WITH (NOLOCK)      
         , login_names                  logn    WITH (NOLOCK)      
    WHERE  entm.entm_clicm_cd         = clicm.clicm_cd      
    AND    entm.entm_enttm_cd         = enttm.enttm_cd      
    AND    entm.entm_lst_upd_by       = logn.logn_name    
    AND    entm.entm_deleted_ind      = 1    
    AND    entm.entm_lst_upd_by       <> @pa_login_name    
    AND    getdate()                  BETWEEN logn.logn_from_dt and logn.logn_to_dt    
    AND    entm.entm_id               IN (SELECT entm_id      
                                          FROM   entity_list WITH (NOLOCK)      
                                          WHERE  entm_deleted_ind = 1    
                                          AND    entm_status      = 1     
                                         )    
    AND    entm.entm_id               NOT IN (SELECT entm_id            
                                              FROM   entity_mstr_mak WITH (NOLOCK)            
                                              WHERE  entm_deleted_ind in (0,4,8)    
                                             )                                                       
                                              
                                              
                                              
                                              
  --      
  END      
        
        
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
      AND    entpm.entp_entpm_cd    IN ('PAN_GIR_NO','FORMNO')      
      UNION      
      SELECT entp.entp_ent_id          entp_ent_id      
           , entp.entp_entpm_cd        entp_entpm_cd      
           , entp.entp_value           entp_value      
      FROM   entity_properties         entp      
      WHERE  entp.entp_deleted_ind   = 1      
      AND    entp.entp_entpm_cd      IN ('PAN_GIR_NO','FORMNO')   
      AND    entp.entp_ent_id       IN (SELECT clim_crn_no      
                                        FROM   client_list      
                                        WHERE  clim_deleted_ind = 1      
                                        AND    clim_status     in (1,10)
                                       )      
        
        
      SELECT @l_scr_id          = scr.scr_id      
      FROM   screens              scr      
      WHERE  scr.scr_checker_yn = 2      
      AND    scr.scr_name       = (SELECT scr2.scr_name          scr_name      
                                   FROM   screens                scr2      
                                   WHERE  scr2.scr_id          = @pa_scr_id      
                                   AND    scr2.scr_deleted_ind = 1      
                                  )        
        
        
      INSERT INTO @t_chk      
      (client_code       
      ,name       
      ,short_name       
      ,client_type       
      ,category_type       
      ,vld_pan_number       
      ,pan_number       
      ,datacolsreqd       
      ,disp_cols  
      ,vld_form_no     
      )      
      SELECT client_code      
            ,name       
            ,short_name       
            ,client_type      
            ,category_type      
            ,''      
            ,''      
            ,CONVERT(VARCHAR,@l_scr_id)+@coldelimiter+CONVERT(VARCHAR,client_code)+@coldelimiter+CONVERT(VARCHAR,clicm_id)+@coldelimiter+CONVERT(VARCHAR,enttm_id)+@coldelimiter+CONVERT(VARCHAR,clim_id)+@coldelimiter+CONVERT(VARCHAR(1000),logn_email) + @coldelimiter   +name
 
            ,'5' 
            ,''     
      FROM @t_clim      
      
    IF @pa_query_id = 1      
    BEGIN      
    --      
      UPDATE @t_chk      
      SET    vld_pan_number          = entpm.entp_value      
      FROM   @t_chk                      
           , @t_entpm entpm                
      WHERE  entpm.entp_ent_id       = client_code      
      AND    entpm.entp_entpm_cd     ='PAN_GIR_NO'      

      UPDATE @t_chk      
      SET    vld_form_no             = entpm.entp_value      
      FROM   @t_chk                      
           , @t_entpm entpm                
      WHERE  entpm.entp_ent_id       = client_code      
      AND    entpm.entp_entpm_cd     ='FORMNO'
      
      
      SELECT DISTINCT chk.client_code           client_code      
            ,chk.name                           name       
            ,chk.short_name                     short_name       
            ,chk.client_type                    client_type      
            ,chk.category_type                  category_type      
            ,ISNULL(chk.vld_pan_number,'')      vld_pan_number      
            ,ISNULL(chk.pan_number,'')          pan_number      
            ,chk.datacolsreqd + @coldelimiter+ISNULL(chk.vld_pan_number,'')+@coldelimiter+ISNULL(chk.vld_form_no,'')   datacolsreqd      
            ,chk.disp_cols                      disp_cols      
      FROM  @t_chk                              chk      
      
    --      
    END      
    ELSE IF @pa_query_id=2      
    BEGIN      
    --      
      --l_clim_tab2(i) := ty_clim_type2(t_clim_tab(i).client_code, t_clim_tab(i).name, t_clim_tab(i).short_name, t_clim_tab(i).client_type, t_clim_tab(i).category_type, t_clim_tab(i).datacolsreqd, t_clim_tab(i).disp_cols);      
      SELECT DISTINCT chk.client_code      client_code      
            ,chk.name             name            
            ,chk.short_name       short_name      
            ,chk.client_type      client_type      
            ,chk.category_type    category_type      
            ,chk.datacolsreqd     datacolsreqd      
            ,chk.disp_cols        disp_cols      
      FROM   @t_chk               chk      
    --      
    END      
       
        
      
--      
END

GO
