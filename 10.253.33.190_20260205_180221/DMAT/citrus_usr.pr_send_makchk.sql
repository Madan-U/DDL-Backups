-- Object: PROCEDURE citrus_usr.pr_send_makchk
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--sp_help client_mstr_mak order by 1 desc    
-- 55119|*~|*|~*  SEND_TO_CHK HO DP_CLIENT 2 *|~* |*~|   
CREATE  PROCEDURE [citrus_usr].[pr_send_makchk](@pa_id  VARCHAR(200)          
                                ,@pa_app_sba           VARCHAR(500)                
                                ,@pa_action            VARCHAR(20)          
                                ,@pa_login_name        VARCHAR(20)          
                                ,@pa_values            VARCHAR(8000)          
                                ,@pa_chk_yn            VARCHAR(20)          
                                ,@rowdelimiter         CHAR(4) =  '*|~*'          
                                ,@coldelimiter         CHAR(4)  = '|*~|'          
                                ,@pa_msg               VARCHAR(8000) OUTPUT          
                                )          
AS          
BEGIN          
--          
   DECLARE  @delimeter_id           VARCHAR(10)          
           ,@@delimeterlength_id    INT          
           ,@@remainingstring_id    VARCHAR(8000)          
           ,@@currstring_id         VARCHAR(8000)          
           ,@@foundat               INTEGER          
           ,@l_crn_no               NUMERIC          
           ,@l_rmks                 VARCHAR(8000)           
           --,@l_clisba_no          VARCHAR(50)            
           ,@l_clisba_id            VARCHAR(50)           
           ,@l_mak_id               VARCHAR(50)           
          
  IF @pa_id <> ''          
  BEGIN           
  --          
    SET @delimeter_id        = '%'+ @rowdelimiter + '%'          
    SET @@delimeterlength_id = LEN(@rowdelimiter)          
          
    SET @@remainingstring_id = @pa_id          
    --          
    WHILE @@remainingstring_id <> ''          
    BEGIN          
    --          
      SET @@foundat = 0          
      SET @@foundat =  PATINDEX('%'+@delimeter_id+'%',@@remainingstring_id)          
      --          
      IF  @@FOUNDAT > 0          
      BEGIN          
      --          
        SET @@currstring_id      = SUBSTRING(@@remainingstring_id, 0,@@foundat)          
        SET @@remainingstring_id = SUBSTRING(@@remainingstring_id, @@foundat+@@delimeterlength_id,LEN(@@remainingstring_id)- @@foundat+@@delimeterlength_id)          
      --          
      END          
      ELSE          
      BEGIN          
      --          
        SET @@currstring_id = @@remainingstring_id          
        SET @@remainingstring_id = ''          
      --          
      END          
      --          
      IF @@currstring_id <> ''          
      BEGIN          
      --            
        SET @l_crn_no = CONVERT(NUMERIC, citrus_usr.fn_splitval(@@currstring_id,1))          
        SET @l_rmks   = CONVERT(VARCHAR(250), citrus_usr.fn_splitval(@@currstring_id,2))          
          
        IF @pa_values = 'CLIENT'          
        BEGIN          
        --          
          IF @pa_action = 'SEND_TO_MAK'          
          BEGIN          
          --        
            IF  @l_rmks  <> ''        
            BEGIN        
            --        
              update client_mstr_mak SET clim_rmks = @l_rmks WHERE clim_crn_no = @l_crn_no         
            --        
            END        
            if exists(select clim_Crn_no from client_list where clim_crn_no  = @l_crn_no and clim_status = 4 and clim_deleted_ind = 1)    
            begin    
            --    
              UPDATE client_list           
              SET    clim_status      = 20          
              WHERE  clim_crn_no      = @l_crn_no          
              AND    clim_deleted_ind = 1    
              and clim_status = 4   
            --    
            end    
            else    
            begin    
            --    
              UPDATE client_list           
              SET    clim_status      = 2         
              WHERE  clim_crn_no      = @l_crn_no          
              AND    clim_deleted_ind = 1      
            --    
            end  
            
             update  c set clic_mod_deleted_ind = '3' from client_list_modified C, dp_acct_mstr 
		     where clic_mod_deleted_ind = '0' and clic_mod_dpam_sba_no = dpam_sba_no and dpam_crn_no = @l_crn_no
          --          
     END          
          ELSE IF @pa_action = 'SEND_TO_CHK'          
          BEGIN          
          --    
            if exists(select clim_Crn_no from client_list where clim_crn_no  = @l_crn_no and clim_status = 3 and clim_deleted_ind = 1)    
            begin    
            --           
              UPDATE client_list           
              SET    clim_status      = 10          
              WHERE  clim_crn_no      = @l_crn_no          
              AND    clim_deleted_ind = 1    
              and    clim_status = 3  
            --    
            end    
            else    
            begin    
            --    
              UPDATE client_list           
              SET    clim_status      = 1          
              WHERE  clim_crn_no      = @l_crn_no          
              AND    clim_deleted_ind = 1      
            --    
            end         
          --          
          END          
        --          
        END          
        ELSE IF @pa_values = 'ENTITY'          
        BEGIN          
        --          
          IF @pa_action = 'SEND_TO_MAK'          
          BEGIN          
          --        
            IF  @l_rmks  <> ''        
            BEGIN        
            --        
              update entity_mstr_mak SET entm_rmks = @l_rmks WHERE entm_id = @l_crn_no         
            --        
            END          
            UPDATE entity_list           
            SET    entm_status      = 2          
            WHERE  entm_id          = @l_crn_no          
            AND    entm_deleted_ind = 1          
          --          
          END          
          ELSE IF @pa_action = 'SEND_TO_CHK'          
          BEGIN          
          --          
            UPDATE entity_list           
            SET    entm_status      = 1          
            WHERE  entm_id          = @l_crn_no          
            AND    entm_deleted_ind = 1          
          --          
          END          
        --          
        END          
        ELSE IF @pa_values = 'DP_CLIENT'          
        BEGIN          
        --          
          IF @pa_action = 'SEND_TO_MAK'          
          BEGIN          
          --          
            IF  @l_rmks  <> ''        
            BEGIN        
            --        
              update client_mstr_mak SET clim_rmks = @l_rmks WHERE clim_crn_no = @l_crn_no         
            --        
            END      
    
    
            if exists(select clim_Crn_no from client_list where clim_crn_no  = @l_crn_no and clim_status = 2 and clim_deleted_ind = 1)    
            begin    
            --       
              UPDATE client_list           
              SET    clim_status      = 20          
              FROM   client_list        clil          
              WHERE  clim_crn_no      = @l_crn_no          
              AND    clim_deleted_ind = 1   
              and clim_status = 2  
            --    
            end    
            else    
            begin    
            --    
              UPDATE client_list           
              SET    clim_status      = 4          
              FROM   client_list        clil          
              WHERE  clim_crn_no      = @l_crn_no          
              AND    clim_deleted_ind = 1        
            --    
            end 
            
            update  c set clic_mod_deleted_ind = '3' from client_list_modified C, dp_acct_mstr 
		     where clic_mod_deleted_ind = '0' and clic_mod_dpam_sba_no = dpam_sba_no and dpam_crn_no = @l_crn_no   
          --          
          END          
          ELSE IF @pa_action = 'SEND_TO_CHK'          
          BEGIN          
          --    
          print '111'      
            if exists(select clim_Crn_no from client_list where clim_crn_no  = @l_crn_no and clim_status = 1 and clim_deleted_ind = 1)    
            begin    
            --     
              UPDATE client_list           
              SET    clim_status      = 10          
              FROM   client_list        clil          
              WHERE  clim_crn_no      = @l_crn_no          
              AND    clim_deleted_ind = 1          
              and clim_status = 1  
            --    
            end       
            else      
            begin    
            --    
       UPDATE client_list           
              SET    clim_status      = 3         
              FROM   client_list        clil          
              WHERE  clim_crn_no      = @l_crn_no          
              AND    clim_deleted_ind = 1         
            --    
            end    
          --          
          END          
        --          
        END          
                  
      --          
      END          
    --          
    END          
  --          
  END          
  ELSE IF @pa_app_sba <> ''          
  BEGIN          
  --          
    SET @delimeter_id        = '%'+ @rowdelimiter + '%'          
    SET @@delimeterlength_id = LEN(@rowdelimiter)          
          
    SET @@remainingstring_id = @pa_app_sba          
    --          
    WHILE @@remainingstring_id <> ''          
    BEGIN          
    --          
      SET @@foundat = 0          
      SET @@foundat =  PATINDEX('%'+@delimeter_id+'%',@@remainingstring_id)          
      --          
      IF  @@FOUNDAT > 0          
      BEGIN          
      --          
        SET @@currstring_id      = SUBSTRING(@@remainingstring_id, 0,@@foundat)          
        SET @@remainingstring_id = SUBSTRING(@@remainingstring_id, @@foundat+@@delimeterlength_id,LEN(@@remainingstring_id)- @@foundat+@@delimeterlength_id)          
      --          
      END          
      ELSE          
      BEGIN          
      --          
        SET @@currstring_id = @@remainingstring_id          
        SET @@remainingstring_id = ''          
      --          
      END          
      --          
      IF @@currstring_id <> ''          
      BEGIN          
      --            
          SET @l_crn_no    = CONVERT(NUMERIC, citrus_usr.fn_splitval(@@currstring_id,1))          
          SET @l_mak_id = CONVERT(VARCHAR, citrus_usr.fn_splitval(@@currstring_id,2))          
          --SET @l_clisba_id = CONVERT(VARCHAR, citrus_usr.fn_splitval(@@currstring_id,2))          
                    
          IF @pa_values = 'CLIENT'          
          BEGIN          
          --           
            IF @pa_action = 'SEND_TO_MAK'          
            BEGIN          
            --          
              IF  @l_rmks  <> ''        
              BEGIN        
              --        
                update client_mstr_mak SET clim_rmks = @l_rmks WHERE clim_crn_no = @l_crn_no         
              --        
              END      
    
              if exists(select clim_Crn_no from client_list where clim_crn_no  = @l_crn_no and clim_status = 4 and clim_deleted_ind = 1)    
             begin    
             --    
               UPDATE client_list           
               SET    clim_status        = 20         
               FROM   client_list          clil          
                  ,   client_sub_accts_mak clisbam           
               WHERE  clim_crn_no       = @l_crn_no          
               AND    clisbam.clisba_id = clil.clisba_no             
               AND    clisbam.clisba_id = @l_mak_id          
               AND    clil.clim_deleted_ind  = 1          
             --    
             end    
             else    
             begin    
             --    
                UPDATE client_list           
               SET    clim_status        = 2          
               FROM   client_list          clil          
                  ,   client_sub_accts_mak clisbam           
               WHERE  clim_crn_no       = @l_crn_no          
               AND    clisbam.clisba_id = clil.clisba_no             
               AND    clisbam.clisba_id = @l_mak_id          
               AND    clil.clim_deleted_ind  = 1      
             --    
             end   
             
             update  c set clic_mod_deleted_ind = '3' from client_list_modified C, dp_acct_mstr 
		     where clic_mod_deleted_ind = '0' and clic_mod_dpam_sba_no = dpam_sba_no and dpam_crn_no = @l_crn_no 
            --           
            END          
            ELSE IF @pa_action = 'SEND_TO_CHK'          
            BEGIN          
            --    
              if exists(select clim_Crn_no from client_list where clim_crn_no  = @l_crn_no and clim_status = 3 and clim_deleted_ind = 1)    
              begin    
              --          
                UPDATE client_list           
                SET    clim_status       = 10          
                FROM   client_list          clil          
                   ,   client_sub_accts_mak clisbam           
                WHERE  clim_crn_no       = @l_crn_no          
                AND    clisbam.clisba_id = clil.clisba_no             
                AND    clisbam.clisba_id = @l_mak_id          
                AND    clil.clim_deleted_ind  = 1          
              --    
              end    
              else    
              begin    
              --    
                UPDATE client_list           
                SET    clim_status       = 1          
                FROM   client_list          clil          
                   ,   client_sub_accts_mak clisbam           
                WHERE  clim_crn_no       = @l_crn_no          
                AND    clisbam.clisba_id = clil.clisba_no             
				AND    clisbam.clisba_id = @l_mak_id          
                AND    clil.clim_deleted_ind  = 1          
              --    
              end     
            --          
            END          
          --          
          END          
          ELSE IF @pa_values = 'DP_CLIENT'          
          BEGIN          
          --          
            IF @pa_action = 'SEND_TO_MAK'          
            BEGIN          
            --          
              IF  @l_rmks  <> ''        
            BEGIN        
            --        
              update client_mstr_mak SET clim_rmks = @l_rmks WHERE clim_crn_no = @l_crn_no         
            --        
            END     
              if exists(select clim_Crn_no from client_list where clim_crn_no  = @l_crn_no and clim_status = 2 and clim_deleted_ind = 1)    
              begin    
              --        
                UPDATE client_list           
                SET    clim_status            = 20          
                FROM   client_list              clil          
                   ,   dp_acct_mstr_mak         dpamm           
                WHERE  clim_crn_no            = dpam_crn_no          
                AND    dpamm.dpam_id      = clil.clisba_no             
                AND    dpamm.dpam_crn_no         = @l_crn_no          
				AND    dpamm.dpam_id             = @l_mak_id      
                AND    clil.clim_deleted_ind  = 1          
              --    
              end      
              else    
              begin    
              --    
                UPDATE client_list           
                SET    clim_status            = 4          
                FROM   client_list              clil          
                   ,   dp_acct_mstr_mak         dpamm           
                WHERE  clim_crn_no            = dpam_crn_no          
                AND    dpamm.dpam_id      = clil.clisba_no             
                AND    dpamm.dpam_crn_no         = @l_crn_no   
				AND    dpamm.dpam_id             = @l_mak_id         
                AND    clil.clim_deleted_ind  = 1        
              --    
              end 
              
              update  c set clic_mod_deleted_ind = '3' from client_list_modified C, dp_acct_mstr 
		     where clic_mod_deleted_ind = '0' and clic_mod_dpam_sba_no = dpam_sba_no and dpam_crn_no = @l_crn_no   
            --           
            END          
            ELSE IF @pa_action = 'SEND_TO_CHK'          
            BEGIN          
            --    
              if exists(select clim_Crn_no from client_list where clim_crn_no  = @l_crn_no and clim_status = 1 and clim_deleted_ind = 1)    
              begin    
              --          
                UPDATE client_list           
                SET    clim_status            = 10          
                FROM   client_list              clil          
                   ,   dp_acct_mstr_mak         dpamm           
                WHERE  clim_crn_no            = dpam_crn_no          
                AND    dpamm.dpam_id      = clil.clisba_no             
                AND    dpamm.dpam_crn_no          = @l_crn_no          
				AND    dpamm.dpam_id             = @l_mak_id  
                AND    clil.clim_deleted_ind  = 1          
              --    
              end    
              else    
              begin    
              --    
                UPDATE client_list           
                SET    clim_status            = 3          
                FROM   client_list              clil          
                   ,   dp_acct_mstr_mak         dpamm           
                WHERE  clim_crn_no            = dpam_crn_no          
                AND    dpamm.dpam_id      = clil.clisba_no             
                AND    dpamm.dpam_crn_no          = @l_crn_no          
				AND    dpamm.dpam_id             = @l_mak_id  
                AND    clil.clim_deleted_ind  = 1       
              --    
              end     
            --          
            END           
          --          
          END          
      --          
      END          
    --          
    END          
  --          
  END          
--          
END

GO
