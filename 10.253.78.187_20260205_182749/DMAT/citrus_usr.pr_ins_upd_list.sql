-- Object: PROCEDURE citrus_usr.pr_ins_upd_list
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_ins_upd_list](@pa_id          VARCHAR(8000)  
                                ,@pa_action      VARCHAR(20)  
                                ,@pa_table       VARCHAR(50)  
                                ,@pa_login_name  VARCHAR(20)  
                                ,@rowdelimiter   CHAR(4)       = '*|~*'  
                                ,@coldelimiter   CHAR(4)       = '|*~|'  
                                ,@pa_errmsg      VARCHAR(8000) OUTPUT  
)  
AS  
/*  
*********************************************************************************  
 SYSTEM         : CLASS  
 MODULE NAME    :   
 DESCRIPTION    :   
 COPYRIGHT(C)   : MARKETPLACE Technologies pvt. ltd.  
 VERSION HISTORY: 1.0  
 VERS.  AUTHOR            DATE          REASON  
 -----  -------------     ------------  --------------------------------------------------  
 2.0    TUSHAR            12-APR-2007   VERSION.  
-----------------------------------------------------------------------------------*/  
--  
BEGIN  
  --  
  SET NOCOUNT ON  
  --  
    DECLARE @l_clisba_no VARCHAR(50)  
          , @l_pa_id     VARCHAR(50)  
            
    IF @pa_table = 'Client Sub Accts'   OR @pa_table = 'dp acct mstr'  
    BEGIN    
    --  
      SET @l_pa_id       = citrus_usr.fn_splitval(@pa_id,1)  
      SET @l_clisba_no   = citrus_usr.fn_splitval(@pa_id,2)    
      SET @pa_id         = @l_pa_id  
    --    
    END    
    ELSE    
    BEGIN    
    --    
      SET @l_clisba_no = 0    
    --    
    END     
      
    IF @pa_id<>'' AND @pa_action<>'' AND @pa_table<>''  
    BEGIN  
    --  
          
      IF EXISTS(SELECT entm_id FROM entity_mstr WHERE entm_id = @pa_id) OR EXISTS(SELECT entm_id FROM entity_mstr_mak WHERE entm_id = @pa_id)  
      BEGIN  
      --  
         IF NOT EXISTS(SELECT entm_id FROM entity_list WHERE entm_deleted_ind=1 AND entm_id = @pa_id AND entm_tab=@pa_table) AND @pa_action <> 'A'  
         BEGIN  
         --  
           INSERT INTO entity_list  
           (entm_id  
           ,entm_ins_upd_del  
           ,entm_TAB  
           ,entm_status  
           ,entm_created_by  
           ,entm_created_dt  
           ,entm_lst_upd_by  
           ,entm_lst_upd_dt  
           ,entm_deleted_ind  
           )  
           VALUES  
           (@pa_id  
           ,@pa_action  
           ,@pa_table  
           ,0  
           ,@pa_login_name  
           ,GETDATE()  
           ,@pa_login_name  
           ,GETDATE()  
           ,1  
           )   
         --  
         END  
         ELSE IF @pa_action='A'  
         BEGIN  
         --  
           UPDATE entity_list  
           SET    entm_deleted_ind = 2  
           WHERE  entm_id          = @pa_id  
           AND    entm_tab         = @pa_table  
           AND    entm_deleted_ind = 1  
         --  
         END  
      --  
      END  
      ELSE   
      BEGIN  
      -- 
        if exists(SELECT clim_crn_no FROM client_list WHERE clim_deleted_ind=1 AND clim_crn_no = @pa_id AND (clim_tab=@pa_table and clim_tab <> 'Client Sub Accts' and clim_tab <> 'dp acct mstr') AND @pa_action <> 'A')   
        begin
        --
          update client_list 
          set    clim_lst_upd_by = @pa_login_name 
          WHERE  clim_deleted_ind=1 AND clim_crn_no = @pa_id 
          and    clim_deleted_ind = 1 
 
        --
        end
        IF NOT EXISTS(SELECT clim_crn_no FROM client_list WHERE clim_deleted_ind=1 AND clim_crn_no = @pa_id AND (clim_tab=@pa_table and clim_tab <> 'Client Sub Accts' and clim_tab <> 'dp acct mstr')) AND @pa_action <> 'A'  
        BEGIN  
        --  
          INSERT INTO client_list  
          (clim_crn_no  
          ,clim_ins_upd_del  
          ,clisba_no  
          ,clim_tab  
          ,clim_status  
          ,clim_created_by  
          ,clim_created_dt  
          ,clim_lst_upd_by  
          ,clim_lst_upd_dt  
          ,clim_deleted_ind  
          )  
          VALUES  
          (@pa_id  
          ,@pa_action  
          ,@l_clisba_no  
          ,@pa_table  
          ,0  
          ,@pa_login_name  
          ,GETDATE()  
          ,@pa_login_name  
          ,GETDATE()  
          ,1  
          )  
        --  
        END  
        ELSE IF @pa_action='A'  
        BEGIN  
        --  
          IF @pa_table = 'Client Sub Accts' or @pa_table = 'dp acct mstr'   
          BEGIN  
          --  
            IF isnull(@l_clisba_no,'') = ''  
            BEGIN  
            --  
              UPDATE client_list   
              SET    clim_deleted_ind = 2  
              WHERE  clim_crn_no = @l_pa_id  
              --AND    clisba_no        = @l_clisba_no  
              AND    clim_tab         = @pa_table  
              AND    clim_deleted_ind = 1  
            --  
            END  
            ELSE  
            BEGIN  
            --  
              UPDATE client_list   
              SET    clim_deleted_ind = 2  
              WHERE  clim_crn_no      = @l_pa_id  
              AND    clisba_no        = @l_clisba_no  
              AND    clim_tab         = @pa_table  
              AND    clim_deleted_ind = 1  
              --  
              IF @pa_table = 'Client Sub Accts'   
              BEGIN  
              --  
                select '1'
                ---EXEC pr_ins_upd_mig_list @l_pa_id, @l_clisba_no,'09', @pa_action, @pa_table, @pa_login_name,'*|~*', '|*~|',''  
              --  
              END  
            --  
            END  
          --  
          END  
          ELSE  
          BEGIN  
          --  
            UPDATE client_list   
            SET    clim_deleted_ind = 2  
            WHERE  clim_crn_no      = @pa_id  
            AND    clim_tab         = @pa_table  
            AND    clim_deleted_ind = 1  
          --  
          END  
        --  
        END  
         
      --  
      END  
        
    --  
    END  
    ELSE  
    BEGIN  
    --  
      SET @pa_errmsg = ''  
    --  
    END  
  --  
 END

GO
