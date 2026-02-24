-- Object: PROCEDURE citrus_usr.pr_authentication
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------



CREATE PROCEDURE  [citrus_usr].[pr_authentication](@pa_login_name  VARCHAR(20)
                                   ,@pa_ref_cur     VARCHAR(8000) output
                                  )

AS
/***********************************************************************************
 SYSTEM           : CLASS
 MODULE NAME      : PR_AUTHENTICATION
 DESCRIPTION      : SCRIPT TO AUTHENTICATE USER
 COPYRIGHT(C)     : ENC SOFTWARE SOLUTIONS PVT. LTD.
 VERSION HISTORY  :
 VERS.  AUTHOR          DATE         REASON
 -----  -------------   ----------   ------------------------------------------------
 1.0    TUSHAR PATEL    06-JAN-2007  INITIAL VERSION.
 **********************************************************************************/
 --
 BEGIN
 --
       SELECT logn.logn_pswd                 logn_pswd
            , logn.logn_ent_id               logn_ent_id
            , enttm.enttm_cd                 enttm_cd    
            , logn.logn_short_name           logn_short_name
            , entro.entro_rol_id             entro_rol_id
            , isnull(logn.logn_from_dt,'')   logn_from_dt 
            , isnull(logn.logn_to_dt,'')     logn_to_dt
            , ISNULL(logn.logn_total_att,0)  logn_total_att
            , ISNULL(logn.logn_no_of_att,0)  logn_no_of_att
            , ISNULL(logn.logn_status,'')    logn_status
            , ISNULL(logn.logn_menu_pref,'') logn_menu_pref
            , ISNULL(logn.logn_usr_ip,'')    logn_usr_ip
            , getdate()                      curr_dt
            , logn.logn_sbum_id              logn_sbum_id
            , ISNULL(logn.logn_usr_email,'') logn_usr_email
            --, isnull(entm_name1,'') entm_name1       
            --, isnull(entm_short_name,'') entm_short_name     
            , LOGN_CREATED_DT      
            , LOGN_LST_UPD_DT        
			, LOGN_PSW_EXP_ON
			 , isnull(entm_name1,'') entm_name1   
            , isnull(entm_short_name,'') entm_short_name 
            , LOGN_CREATED_DT  
            , LOGN_LST_UPD_DT    
			
       FROM   login_names                    logn    with(nolock)
            , entity_roles                   entro   with(nolock)
            , entity_type_mstr               enttm   with(nolock)     , entity_mstr         
       WHERE  entro.entro_logn_name        = logn.logn_name
       AND    logn.logn_enttm_id           = enttm.enttm_id
        and    logn.logn_ent_id             = entm_id  
       AND    logn.logn_deleted_ind        = 1
       AND    entro.entro_deleted_ind      = 1
       AND    logn.logn_name               = @pa_login_name
       AND    getdate()                    BETWEEN logn_from_dt AND logn_to_dt
       
       SELECT DMAT_Err_log ,DMAT_List_log,CONVERT(VARCHAR(10), GETDATE(), 101) currdate ,CONVERT(VARCHAR(10),DMAT_Message_Display_Date ,101)DMAT_Message_Display_Date
       from DMAT_Setting
      
      
      
     
 --
 END

GO
