-- Object: PROCEDURE citrus_usr.pr_ins_upd_conc_mod_BAK_26082015
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


CREATE  PROCEDURE [citrus_usr].[pr_ins_upd_conc_mod_BAK_26082015](
								@pa_id           VARCHAR(8000)        
                               ,@pa_action       VARCHAR(20)        
                               ,@pa_login_name   VARCHAR(20)        
                               ,@pa_ent_id       NUMERIC        
                               ,@pa_acct_no      VARCHAR(20)        
                               ,@pa_values       VARCHAR(8000)        
                               ,@pa_chk_yn       INT      
							   ,@pa_conc_concm_id numeric
							   ,@pa_conc_concm_cd varchar(20)
							   ,@pa_crn_no       numeric
							   ,@pa_conc_value	 varchar(50)
                               ,@rowdelimiter    CHAR(4)        
                               ,@coldelimiter    CHAR(4)        
                               ,@pa_msg          VARCHAR(8000) OUTPUT        
)        
AS        
BEGIN        
--        
   DECLARE @@t_errorstr      VARCHAR(8000)        
      , @@l_error            BIGINT        
      , @l_entac_concm_cd    VARCHAR(20)        
      , @l_concm_desc        VARCHAR(50)        
      , @l_concmak_id        NUMERIC         
      , @l_action            CHAR(1)       
      , @L_EDT_DEL_ID        NUMERIC  
		
	  
       
	  IF @pa_chk_yn = 1   or @pa_chk_yn = 2        
      BEGIN        
      --        
              
        IF EXISTS(SELECT concmak.conc_ent_id       
                  FROM   contact_channels_mak       concmak      
                  WHERE  concmak.conc_deleted_ind   IN (0,4,8)      
                  AND    concmak.conc_ent_id      = @pa_crn_no      
                  AND    concmak.conc_concm_id    = @pa_conc_concm_id)      
                        
        BEGIN                
        --      
          UPDATE contact_channels_mak      
          SET    conc_deleted_ind =  3       
          WHERE  conc_ent_id      = @pa_crn_no      
          AND    conc_deleted_ind IN (0,4,8)      
          AND    conc_concm_id    = @pa_conc_concm_id      
        --      
        END      
      
      
        IF @pa_action='EDT'    
        BEGIN        
        --        
          BEGIN TRANSACTION            
                
          SELECT @l_concmak_id=isnull(MAX(concmak_id),0)+1 FROM contact_channels_mak          

          
          IF EXISTS(SELECT ENTAC.ENTAC_ENT_ID FROM ENTITY_ADR_CONC ENTAC WHERE  ENTAC.ENTAC_ENT_ID = @pa_crn_no AND ENTAC.ENTAC_CONCM_ID = @pa_conc_concm_id)                          
          BEGIN      
          --      
            SET @L_EDT_DEL_ID = 8      
          --      
          END      
          ELSE      
          BEGIN      
          --      
            SET @L_EDT_DEL_ID = 0  
          --      
          END      
      
--          IF @L_EDT_DEL_ID = 8 OR @pa_conc_value <> ''
--          begin
          INSERT INTO contact_channels_mak        
          (concmak_id        
          ,conc_id        
          ,conc_value        
          ,conc_ent_id        
          ,conc_concm_id        
          ,conc_concm_cd        
          ,conc_created_by        
          ,conc_created_dt        
          ,conc_lst_upd_by        
          ,conc_lst_upd_dt        
          ,conc_deleted_ind        
          )        
          VALUES        
          (@l_concmak_id  --done       
          ,@pa_crn_no        
          ,@pa_conc_value        
          ,@pa_ent_id        
          ,@pa_conc_concm_id        
          ,@pa_conc_concm_cd        
          ,@pa_login_name        
          ,getdate()        
          ,@pa_login_name        
          ,getdate()        
          , @L_EDT_DEL_ID)        
                                 
                                 
           --end                      
             
          SET @@l_error = @@error        
          --        
          IF @@l_error > 0 --if any error reports then generate the error string        
          BEGIN        
          --        
            SELECT @l_concm_desc     = concm_desc        
            FROM   conc_code_mstr    WITH(NOLOCK)        
            WHERE  concm_id          = @pa_conc_concm_id        
            AND    concm_deleted_ind = 1        
            --        
            SET @@t_errorstr = '#'+@l_concm_desc+'Could not be Inserted'+@rowdelimiter+@@t_errorstr       
            --        
            ROLLBACK TRANSACTION        
          --        
          END        
          ELSE        
          BEGIN        
            --        
            COMMIT TRANSACTION        
                  
            --      
            SELECT @l_action = CASE @pa_action WHEN 'INS' THEN 'I'      
                                               WHEN 'EDT' THEN (CASE @pa_conc_value WHEN '' THEN 'D' ELSE 'E' END) END      
            --      
            EXEC pr_ins_upd_list @pa_crn_no, @l_action,'CONTACT CHANNELS', @pa_login_name,'*|~*','|*~|',''      
            --        
          END            
        --        
        END    
        
	  IF @@t_errorstr=''        
	  BEGIN        
		--        
	   SET @pa_msg = 'Contact Channels Successfully Inserted/Edited'+ @rowdelimiter        
		--        
	  END        
	  ELSE        
	  BEGIN        
		--        
		SET @pa_msg = @@t_errorstr        
		--        
	  END        
	  --        
	  END --END FOR CONDITION CHECKING PA_IS,PA_ACTION,PA_LOGIN_NAME IS NULL OR NOT        
--        
END  --END OF MAIN BEGIN

GO
