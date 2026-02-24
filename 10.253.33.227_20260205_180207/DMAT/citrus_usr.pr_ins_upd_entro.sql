-- Object: PROCEDURE citrus_usr.pr_ins_upd_entro
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_ins_upd_entro]( @pa_id         varchar(8000)
                                , @pa_action            varchar(20)
                                , @pa_login_name        varchar(20)
                                , @pa_values            varchar(8000)
								, @pa_values_excsm_list varchar(8000)
                                , @pa_chk_yn     numeric
                                , @rowdelimiter  char(4) =  '*|~*'
                                , @coldelimiter  char(4)  = '|*~|'
                                , @pa_errmsg     varchar(8000) output
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
         , @@delimeterlength           int
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
         , @@l_user_anme               varchar(20) 
         , @@l_pswd                    varchar(50)
         , @@l_enttm_id                numeric
         , @@l_ent_id                  numeric
         , @@l_short_name              varchar(50)
         , @@l_from_dt                 datetime
         , @@l_to_dt                   datetime
         , @@counter                   numeric
         , @@temp                      numeric 
         , @@l_ent_rol_id              numeric
         , @l_logn_from_dt             datetime  
         , @l_out varchar(25)
         ,@l_temp_rol numeric
    --
    SET @@l_errorstr             = 0
    SET @@delimeter_row          = '%'+ @rowdelimiter + '%'
    SET @@delimeter_col          = '%'+ @coldelimiter + '%'
    SET @@delimeterlength        = len(@rowdelimiter)
    SET @@remainingstring_id     = @pa_id
    SET @@remainingstring_value  = @pa_values
    SET @@temp = 1
    SET @@l_action               = ''
    SET @@counter                = 0 
    --
    SELECT @l_logn_from_dt = logn_from_dt
    FROM   login_names
    WHERE  logn_name       = @pa_login_name
    print  @l_logn_from_dt
    --
    IF isnull(@pa_id,'') <> '' AND isnull(@pa_action,'') <> '' AND isnull(@pa_login_name,'') <> ''
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
          IF @pa_action = 'EDT'
          BEGIN
          --
            DELETE FROM entity_roles
            WHERE entro_logn_name = ltrim(rtrim(@pa_id))
          --
          END
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
                SET @@currstring_value      = @@remainingstring_value
                SET @@remainingstring_value = ''
              --
              END
              --
              IF @@currstring_value <> ''
              BEGIN --@@currstring_value <> ''
              --
                SET @@counter = citrus_usr.ufn_countstring(@@currstring_value,'|*~|')
                --   
                WHILE @@counter <> 0          
                BEGIN
                -- 
                
                
                    select @l_temp_rol =  citrus_usr.fn_splitval(@@currstring_value,@@temp)
                
					exec pr_mak_roles_actions_newlogic  @l_temp_rol
					,@pa_values_excsm_list
					,@PA_ID
					,@pa_errmsg = @l_out out
					
					print @pa_errmsg
					print @l_out 
                
                
                  SET @@l_ent_rol_id  = @l_out
                  --
                  IF @pa_chk_yn = 0
                  BEGIN --chk_yn
                  --        
                    IF @pa_action = 'INS' or @pa_action = 'EDT'
                    BEGIN --ins
                    --
                      BEGIN TRANSACTION
                      --
                     INSERT INTO entity_roles
                      (entro_logn_name
                      ,entro_rol_id
                      ,entro_created_by
                      ,entro_created_dt
                      ,entro_lst_upd_by
                      ,entro_lst_upd_dt
                      ,entro_deleted_ind
                      ,entro_logn_from_dt
                      )
                      SELECT @pa_id
                           , @@l_ent_rol_id
                           , @pa_login_name
                           , getdate()
                           , @pa_login_name
                           , getdate()
                           , 1
                           , logn_from_dt
                      FROM   login_names with (NOLOCK)
                      WHERE  logn_name       = @pa_id
                      and     logn_deleted_ind = 1
                      -- 
                      SET @@l_error  = @@error
                      --
                      IF @@l_error <> 0
                      BEGIN  --a3
                      --
                        ROLLBACK TRANSACTION
                      --
                      END   --a3
                      ELSE
                      BEGIN --a4
                      --
                        COMMIT TRANSACTION
                      --
                      END  --a4
                      --
                      SET @@temp    = @@temp + 1
                     --
                    END --ins or edit
                    ELSE  IF @pa_action ='DEL'
                    BEGIN
                    --
                      UPDATE entity_roles
                      SET    entro_deleted_ind = 0
                      WHERE  entro_logn_name   = ltrim(rtrim(@pa_id))
                      AND    entro_deleted_ind = 1
                    --
                    END
                  --
                  END --chk_yn
                  ELSE IF @pa_chk_yn = 1
                  BEGIN
                  --
                    PRINT 'under process'
                  --
                  END
                  --
                  SET @@counter = @@counter - 1              
                --
                END--counter
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
    --
    IF @@l_error = 0
    BEGIN
    --
       SET @pa_errmsg= 'user successfully inserted/edited'
    --   
    END
--
END

GO
