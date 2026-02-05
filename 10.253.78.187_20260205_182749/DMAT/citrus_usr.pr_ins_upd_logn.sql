-- Object: PROCEDURE citrus_usr.pr_ins_upd_logn
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



CREATE PROCEDURE [citrus_usr].[pr_ins_upd_logn]( @pa_id          varchar(8000)  
                               , @pa_action      varchar(20)  
                               , @pa_login_name  varchar(20)  
                               , @pa_values      varchar(8000)  
                               , @pa_values_excsm_list varchar(8000)
                               , @pa_chk_yn      numeric  
                               , @rowdelimiter   char(4)  = '*|~*'  
                               , @coldelimiter   char(4)  = '|*~|'  
                               , @pa_errmsg      varchar(8000) output  
                               )   
AS   
/*  
*********************************************************************************  
 system         : class  
 module name    : pr_ins_upd_logn  
 description    : this procedure will add new user  to  login_names  
 copyright(c)   : enc software solutions pvt. ltd.  
 version history:  
 vers.  author            date        reason  
 -----  -------------     ----------   -------------------------------------------------  
 1.0    hari r            30-aug-2006  initial version.  
 2.0    sukhvinder/tushar 29-dec-2006  initial version.  
-----------------------------------------------------------------------------------*/  
--  
BEGIN  
--  
  DECLARE @@l_errorstr                varchar(8000)  
        , @@delimeter_row             char(6)  
        , @@delimeter_col             char(6)  
        , @@delimeterlength           integer  
        , @@remainingstring_id        varchar(8000)  
        , @@remainingstring_value     varchar(8000)  
        , @@remainingstring_rol_value varchar(8000)  
        , @@currstring_id             varchar(8000)  
        , @@currstring_value          varchar(8000)  
        , @@currstring_rol_value      varchar(8000)  
        , @@foundat                   integer  
        , @@l_action                  char(3)  
        , @@l_error                   numeric  
        , @@delimeterlength_value     integer  
        , @delimeter_value            char(10)  
        , @@l_user_name               varchar(20)   
        , @@l_pswd                    varchar(200)  
        , @@l_enttm_id                numeric  
        , @@l_ent_id                  numeric  
        , @@l_short_name              varchar(50)  
        , @@l_from_dt                 datetime  
        , @@l_to_dt                   datetime  
        , @@l_sbum_id                 numeric  
          
          
          
        ,@l_psw_exp_on                NUMERIC  
        ,@l_logn_tot_att              NUMERIC  
        ,@l_logn_status               CHAR(1)  
        ,@l_usr_email                 VARCHAR(50)  
        ,@l_login_ip                  VARCHAR(200)  
        ,@l_menu_pref                 CHAR(1)  
          
		      ,@l_old_pswd                  VARCHAR(50)              
        ,@l_user_name                 VARCHAR(25)
        ,@l_pswd                      VARCHAR(50)
        ,@l_new_pswd                  VARCHAR(50)            
          
          ,@l_level					  NUMERIC	 
 ,@l_Rmks  VARCHAR(1000) 
   --  
   SET @@l_errorstr             = 0  
   SET @@delimeter_row          = '%'+@rowdelimiter+'%'  
   SET @@delimeter_col          = '%'+@coldelimiter+'%'  
   SET @@delimeterlength        = len(@rowdelimiter)  
   SET @@remainingstring_id     = @pa_id  
   SET @@remainingstring_value  = @pa_values  
   SET @@l_action               = ''  
   --   
   IF ISNULL(@pa_id,'') <> '' AND ISNULL(@pa_action,'') <> '' AND ISNULL(@pa_login_name,'') <> ''  
   BEGIN --#2  
   --  
      WHILE @@remainingstring_id <> ''  
      BEGIN --#3  
      --  
        SET @@foundat = 0  
        SET @@foundat =  patindex('%'+@@delimeter_row +'%',@@remainingstring_id)  
        --  
        IF @@foundat > 0  
        BEGIN  
        --  
          SET @@currstring_id      = substring(@@remainingstring_id, 0, @@foundat)  
          SET @@remainingstring_id = substring(@@remainingstring_id, @@foundat+@@delimeterlength, len(@@remainingstring_id)- @@foundat+@@delimeterlength)  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @@currstring_id      = @@remainingstring_id  
          SET @@remainingstring_id = ''  
        --  
        END  
        --  
        IF @@currstring_id <> ''  
        BEGIN --currstring_id  
        --  
          SET @delimeter_value        = '%'+ @rowdelimiter + '%'  
          SET @@delimeterlength_value = len(@rowdelimiter)  
          SET @@remainingstring_value = @pa_values  
          --  
          WHILE @@remainingstring_value <> ''  
          BEGIN --@@remainingstring_value <> ''  
          --  
            SET @@foundat = 0  
            SET @@foundat =  patindex('%'+@delimeter_value+'%',@@remainingstring_value)  
            --  
            IF @@foundat > 0  
            BEGIN  
            --  
  
              SET @@currstring_value      = substring(@@remainingstring_value, 0,@@foundat)  
              SET @@remainingstring_value = substring(@@remainingstring_value, @@foundat+@@delimeterlength_value,len(@@remainingstring_value)- @@foundat+@@delimeterlength_value)  
            --  
            END  
            ELSE  
            BEGIN  
            --  
              SET @@currstring_value = @@remainingstring_value  
              SET @@remainingstring_value = ''  
            --  
            END  
            --  
            IF @@currstring_value <> ''  
            BEGIN --@@currstring_value <> ''  
            --  
--print @@currstring_value
              SET @@l_user_name  = citrus_usr.fn_splitval(@@currstring_value,1)  
              SET @@l_pswd       = citrus_usr.fn_splitval(@@currstring_value,2)  
              SET @@l_enttm_id   = citrus_usr.fn_splitval(@@currstring_value,3)  
              SET @@l_ent_id     = citrus_usr.fn_splitval(@@currstring_value,4)  
              SET @@l_short_name = citrus_usr.fn_splitval(@@currstring_value,5)  
              SET @@l_from_dt    = CONVERT(DATETIME,citrus_usr.fn_splitval(@@currstring_value,6),103)  
              SET @@l_to_dt      = CONVERT(DATETIME,citrus_usr.fn_splitval(@@currstring_value,7),103)  
              SET @@l_sbum_id    = citrus_usr.fn_splitval(@@currstring_value,8)  
              SET @l_psw_exp_on  = citrus_usr.fn_splitval(@@currstring_value,9)  
              SET @l_logn_tot_att= citrus_usr.fn_splitval(@@currstring_value,10)  
              SET @l_logn_status = citrus_usr.fn_splitval(@@currstring_value,11)  
              SET @l_usr_email   = citrus_usr.fn_splitval(@@currstring_value,12)  
              SET @l_login_ip    = citrus_usr.fn_splitval(@@currstring_value,13)  
              SET @l_menu_pref   = citrus_usr.fn_splitval(@@currstring_value,14)  
              set @l_level       = citrus_usr.fn_splitval(@@currstring_value,15)  
                  set @l_Rmks       = citrus_usr.fn_splitval(@@currstring_value,16)  

              IF @@l_enttm_id = 0
              BEGIN
              --
                SELECT @@l_enttm_id  =  ENTTM_ID FROM ENTITY_TYPE_MSTR WHERE ENTTM_DESC ='CLIENT' and enttm_deleted_ind =1 
              -- 
              END   
                
                
              --         
              IF @pa_chk_yn = 0  
              BEGIN --chk_yn  
              --          
                IF @pa_action = 'INS'  
                BEGIN --ins  
                --  
                  BEGIN transaction  
                  --  
                  INSERT INTO login_names  
                  (logn_name  
                  ,logn_pswd  
                  ,logn_enttm_id  
                  ,logn_ent_id  
                  ,logn_short_name  
                  ,logn_from_dt  
                  ,logn_to_dt  
                  ,logn_sbum_id  
                  ,logn_psw_exp_on  
                  ,logn_total_att  
                  ,logn_no_of_att  
                  ,logn_status  
                  ,logn_usr_email  
                  ,logn_usr_ip  
                  ,logn_menu_pref  
                  ,logn_created_by  
                  ,logn_created_dt  
                  ,logn_lst_upd_by  
                  ,logn_lst_upd_dt  
                  ,logn_deleted_ind  ,logn_level ,LOGN_RMKS
                  )  
                  VALUES  
                  (@@l_user_name  
                  ,@@l_pswd  
                  ,@@l_enttm_id  
                  ,@@l_ent_id  
                  ,@@l_short_name  
                  ,CONVERT(datetime, @@l_from_dt, 103)  
                  ,CONVERT(datetime, @@l_to_dt, 103)  
                  ,@@l_sbum_id  
                  ,@l_psw_exp_on    
                  ,@l_logn_tot_att  
                  ,0  
                  ,@l_logn_status   
                  ,@l_usr_email     
                  ,@l_login_ip      
                  ,@l_menu_pref     
                  ,@pa_login_name  
                  ,GETDATE()  
                  ,@pa_login_name  
    ,GETDATE()  
                  ,1   ,@l_level,@l_Rmks
                  )  
                  --  
                  SET @@l_error  = @@ERROR  
                  --  
                  IF  @@l_error <> 0  
                  BEGIN --roll  
                  --  
                    ROLLBACK TRANSACTION  
                    --  
                    SET @@l_errorstr = CONVERT(varchar, @@l_error)+@coldelimiter+@rowdelimiter  
                  --  
                  END  --roll  
                  ELSE  
                  BEGIN  
                  --  
                    COMMIT TRANSACTION  
                  --  
                  END  
                --  
                END --ins  
                --  
                IF @pa_action = 'EDT'  
                BEGIN  
                --  
                  IF EXISTS(SELECT logn_name   
                            FROM   login_names   
                            WHERE  logn_name = @@l_user_name  
                           )  
                  BEGIN   
                  --  
                    BEGIN TRANSACTION  
                    --  
                    delete  
                    FROM   entity_roles  
                    WHERE  entro_logn_name        = @@l_user_name  
                    AND    entro_deleted_ind = 1   
                                          
                    DELETE   
                    FROM   login_names   
                    WHERE  logn_name        = @@l_user_name  
                    AND    logn_deleted_ind = 1  
                    --  
                    INSERT INTO login_names  
                    (logn_name  
                    ,logn_pswd  
                    ,logn_enttm_id  
                    ,logn_ent_id  
                    ,logn_short_name  
                    ,logn_from_dt  
                    ,logn_to_dt  
                    ,logn_sbum_id  
                    ,logn_psw_exp_on  
                    ,logn_total_att  
                    ,logn_no_of_att  
                    ,logn_status  
                    ,logn_usr_email  
                    ,logn_usr_ip  
                    ,logn_menu_pref  
                    ,logn_created_by  
                    ,logn_created_dt  
                    ,logn_lst_upd_by  
                    ,logn_lst_upd_dt  
                    ,logn_deleted_ind ,logn_level ,LOGN_RMKS
                    )  
                    VALUES  
                    (@@l_user_name  
                    ,@@l_pswd  
                    ,@@l_enttm_id  
                    ,@@l_ent_id  
                    ,@@l_short_name  
                    ,CONVERT(datetime, @@l_from_dt, 103)  
                    ,CONVERT(datetime, @@l_to_dt, 103)  
                    ,@@l_sbum_id  
                    ,@l_psw_exp_on    
                    ,@l_logn_tot_att  
                    ,0  
                    ,@l_logn_status   
                    ,@l_usr_email     
                    ,@l_login_ip      
                    ,@l_menu_pref     
                    ,@pa_login_name  
                    ,GETDATE()  
                    ,@pa_login_name  
                    ,GETDATE()  
                    ,1   ,@l_level,@l_Rmks	
                    )  
                    --  
                    SET @@l_error  = @@ERROR  
                    --  
                    IF  @@l_error <> 0  
                    BEGIN --roll  
                    --  
                      ROLLBACK TRANSACTION  
                      --  
                      SET @@l_errorstr = CONVERT(varchar, @@l_error)+@coldelimiter+@rowdelimiter   
                    --  
                    END  --roll  
                    ELSE  
                    BEGIN  
                    --  
                      COMMIT TRANSACTION  
                    --  
                    END  
                  --  
                  END  
                --  
                END --edt  
                --  
                IF @pa_action = 'DEL'   
                BEGIN  
                --  
                  BEGIN TRANSACTION   
                  --  
                  UPDATE login_names        WITH (ROWLOCK)        
                  SET    logn_to_dt       = ISNULL(@@l_to_dt, getdate())  
                       , logn_deleted_ind = 0  
                       , logn_lst_upd_by  = @pa_login_name  
                       , logn_lst_upd_dt  = GETDATE()  
                  WHERE  logn_name        = @pa_login_name  
                  AND    logn_deleted_ind = 1  
  
                  SET @@l_error  = @@ERROR  
                  --  
                  IF  @@l_error <> 0  
                  BEGIN --roll  
                  --  
                    ROLLBACK TRANSACTION  
                    --   
                    SET @@l_errorstr = CONVERT(varchar, @@l_error)+@coldelimiter+@rowdelimiter   
                  --  
                  END  --roll  
                  ELSE  
                  BEGIN  
                  --  
                    COMMIT TRANSACTION  
                  --  
                  END  
                --  
                END  
                --  
              END --chk_yn  
              ELSE IF @pa_chk_yn = 1  
              BEGIN  
              --  
                PRINT 'UNDER PROCESS'  
              --  
              END  
            --       
            END --@@currstring_value <> ''  
          --  
          END  --@@remainingstring_value <> ''  
       --  
       END --currstring_id  
     --    
    END --#3  
  --  
  END --#2  
  IF @pa_action = 'CHANGEPASSEDT'   
  BEGIN  
  --  
    SELECT @l_old_pswd = logn_pswd FROM login_names WHERE  logn_name  = @pa_login_name
    
    SET @l_user_name = citrus_usr.fn_splitval(@pa_id,1)
    SET @l_pswd  = citrus_usr.fn_splitval(@pa_id,2)
    SET @l_new_pswd  = citrus_usr.fn_splitval(@pa_id,3)
   
    IF @l_pswd = @l_old_pswd 
    BEGIN
    --
      UPDATE login_names        WITH (ROWLOCK)            
      SET    logn_pswd        = @l_new_pswd 			           
           , logn_lst_upd_dt  = GETDATE()
      WHERE  logn_name        = @l_user_name
      AND    logn_deleted_ind = 1 
    
      SET @pa_errmsg =  '1'+@coldelimiter+@rowdelimiter 
    --
    END
    ELSE
    BEGIN
    --
      SET @pa_errmsg =  '0'+@coldelimiter+@rowdelimiter 
    --
    END 
  --  
  END
  IF @PA_ACTION <> 'CHANGEPASSEDT' 
  BEGIN
  --       
    SET @pa_errmsg =  @@l_errorstr      
  --
  END
--  
END

GO
