-- Object: PROCEDURE citrus_usr.pr_ins_upd_mig_list
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_ins_upd_mig_list](@pa_id          varchar(8000)          
                                    ,@pa_clisba_no   varchar(25)          
                                    ,@pa_prom_cd     varchar(25)           
                                    ,@pa_action      varchar(20)          
                                    ,@pa_table       varchar(50)          
                                    ,@pa_login_name  varchar(20)          
                                    ,@rowdelimiter   char(4)       = '*|~*'          
                                    ,@coldelimiter   char(4)       = '|*~|'          
                                    ,@pa_errmsg      varchar(8000) output          
                                    )          
AS          
BEGIN--#1          
--          
  SET NOCOUNT ON          
  --    
  
  SELECT @pa_clisba_no = clisba_no FROM client_sub_accts WHERE clisba_id =   @pa_clisba_no
      
  IF NOT EXISTS(SELECT clim_sub_acct          
                FROM   client_mig_status          
                WHERE  clim_crn_no   = convert(numeric, @pa_id)          
                AND    clim_sub_acct = @pa_clisba_no          
                AND    citrus_usr.fn_pms_access(@pa_id, @pa_clisba_no,'GET',@pa_prom_cd) = 1          
                AND    clim_e_comltd = 1          
                )          
  BEGIN          
  --        
    INSERT INTO client_mig_status          
    (clim_crn_no          
    ,clim_sub_acct          
    ,excpm_id          
    ,clim_tab          
    ,clim_status          
    ,clim_created_dt          
    ,clim_created_by          
    ,clim_lst_upd_dt          
    ,clim_lst_upd_by          
    ,clim_e_comltd          
    ,clim_edittype          
    )          
    VALUES          
    (@pa_id          
    ,@pa_clisba_no          
    ,0          
    ,@pa_table          
    ,0          
    ,getdate()          
    ,@pa_login_name          
    ,getdate()          
    ,@pa_login_name          
    ,0          
    ,@pa_action          
    )          
  --            
  END          
  /*    
  ELSE          
  BEGIN          
  --          
    UPDATE client_mig_status  WITH (ROWLOCK)          
    SET    clim_status      = 0          
         , clim_e_comltd    = 0          
         , clim_edittype    = 'U'          
         , clim_lst_upd_by  = @pa_login_name          
         , clim_lst_upd_dt  = getdate()          
    WHERE  clim_crn_no      = convert(numeric, @pa_id)          
    AND    clim_sub_acct    = convert(varchar, @pa_clisba_no)          
    AND    citrus_usr.fn_pms_access(@pa_id, @pa_clisba_no,'GET',@pa_prom_cd) = 1          
    AND    clim_e_comltd = 1          
  --          
  END    
  */          
--          
END--#1

GO
