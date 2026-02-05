-- Object: PROCEDURE citrus_usr.pr_mak_holm
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_mak_holm](@pa_id          VARCHAR(8000)  
                           , @pa_action      VARCHAR(20)  
                           , @pa_login_name  VARCHAR(20)  
                           , @pa_excm_id     NUMERIC       
                           , @pa_holm_dt     VARCHAR(20)   = ''  
                           , @pa_holm_desc   VARCHAR(200)  
                           , @pa_chk_yn      INT  
                           , @rowdelimiter   CHAR(4)       = '*|~*'  
                           , @coldelimiter   CHAR(4)       = '|*~|'  
                           , @pa_errmsg      VARCHAR(8000) output  
)  
AS
/*
*********************************************************************************
 SYSTEM         : dp
 MODULE NAME    : pr_mak_holm
 DESCRIPTION    : this procedure will contain the maker checker facility for holiday_mstr
 COPYRIGHT(C)   : marketplace technologies 
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  --------------------------------------------------
 1.0    TUSHAR            08-OCT-2007   VERSION.
-----------------------------------------------------------------------------------*/
BEGIN
--
DECLARE @t_errorstr      VARCHAR(8000)
      , @l_error         BIGINT
      , @delimeter       VARCHAR(10)
      , @remainingstring VARCHAR(8000)
      , @currstring      VARCHAR(8000)
      , @foundat         INTEGER
      , @delimeterlength INT
      , @l_holm_id       NUMERIC
      , @l_holmm_id       NUMERIC
      , @l_excm_id       NUMERIC
      , @l_holm_dt       DATETIME
      
SET @l_error         = 0
SET @t_errorstr      = ''
SET @delimeter        = '%'+ @ROWDELIMITER + '%'
SET @delimeterlength = LEN(@ROWDELIMITER)
SET @remainingstring = @pa_id  

Set @pa_holm_dt = convert(varchar(11),CONVERT(datetime,replace(@pa_holm_dt,'-','/'),103),109)

WHILE @remainingstring <> ''
BEGIN
--
  SET @foundat = 0
  SET @foundat =  PATINDEX('%'+@delimeter+'%',@remainingstring)
  --
  IF @foundat > 0
  BEGIN
  --
    SET @currstring      = SUBSTRING(@remainingstring, 0,@foundat)
    SET @remainingstring = SUBSTRING(@remainingstring, @foundat+@delimeterlength,LEN(@remainingstring)- @foundat+@delimeterlength)
  --
  END
  ELSE
  BEGIN
  --
    SET @currstring      = @remainingstring
    SET @remainingstring = ''
  --
  END
  --
  IF @currstring <> ''
  BEGIN
  --
    IF @pa_chk_yn = 0
    BEGIN
    --
      IF @pa_action = 'INS'
      BEGIN
      --
        BEGIN TRANSACTION
        
        --SELECT @l_holm_id = ISNULL(MAX(holm_id),0)+ 1 FROM  holiday_mstr WITH (NOLOCK) 
        
        SELECT @l_holmm_id = ISNULL(MAX(holm_id),0)+ 1 FROM  holm_mak WITH (NOLOCK)
        
        SELECT @l_holm_id = ISNULL(MAX(holm_id),0)+ 1 FROM  holiday_mstr WITH (NOLOCK)
        
        IF @l_holmm_id  > @l_holm_id 
        BEGIN
        --
          SET @l_holm_id = @l_holmm_id
        --
        END
        

        INSERT INTO holiday_mstr
        ( holm_id 
        , holm_excm_id
        , holm_dt
        , holm_desc
        , holm_created_by
        , holm_created_dt
        , holm_lst_upd_by
        , holm_lst_upd_dt
        , holm_deleted_ind
        )
        VALUES
        ( @l_holm_id 
        , @pa_excm_id
        , @pa_holm_dt
        , @pa_holm_desc
        , @PA_LOGIN_NAME
        , GETDATE()
        , @PA_LOGIN_NAME
        , GETDATE()
        , 1
        )

        
        SET @l_error = @@error
        IF @l_error <> 0
        BEGIN
        --
          ROLLBACK TRANSACTION 
        --
        END
        ELSE
        BEGIN
        --
          COMMIT TRANSACTION
        --
        END
      --
      END
      ELSE IF @pa_action = 'EDT'
      BEGIN
      --
        BEGIN TRANSACTION
        
        UPDATE holiday_mstr
        SET    holm_dt          = @pa_holm_dt
             , holm_desc        = @pa_holm_desc
             , holm_lst_upd_dt  = getdate()
        WHERE  holm_id          = CONVERT(INT,@currstring)
        AND    holm_excm_id     = @pa_excm_id
        AND    holm_deleted_ind = 1
        
        
        SET @l_error = @@error
        IF @l_error <> 0
        BEGIN
        --
          ROLLBACK TRANSACTION 
        --
        END
        ELSE
        BEGIN
        --
          COMMIT TRANSACTION
        --
        END
      --
      END
      ELSE IF @pa_action = 'DEL'
      BEGIN
      --
        BEGIN TRANSACTION
        
        UPDATE holiday_mstr
        SET    holm_lst_upd_dt  = getdate()
              ,holm_lst_upd_by = @pa_login_name
              ,holm_deleted_ind = 0
        WHERE  holm_excm_id     = @pa_excm_id
        AND    holm_dt          = @pa_holm_dt
        AND    holm_deleted_ind = 1
        
        SET @l_error = @@error
        IF @l_error <> 0
        BEGIN
        --
          ROLLBACK TRANSACTION 
        --
        END
        ELSE
        BEGIN
        --
          COMMIT TRANSACTION
        --
        END
      --
      END
    --
    END
    ELSE IF @pa_chk_yn = 1
    BEGIN
    --
      IF @pa_action = 'INS'
      BEGIN
      --
        BEGIN TRANSACTION
        
        SELECT @l_holmm_id = ISNULL(MAX(holm_id),0)+ 1 FROM  holm_mak WITH (NOLOCK)

        SELECT @l_holm_id = ISNULL(MAX(holm_id),0)+ 1 FROM  holiday_mstr WITH (NOLOCK)

        IF @l_holmm_id  > @l_holm_id 
        BEGIN
        --
          SET @l_holm_id = @l_holmm_id
        --
        END
        
        INSERT INTO holm_mak
        ( holm_id
        , holm_excm_id
        , holm_dt
        , holm_desc
        , holm_created_by
        , holm_created_dt
        , holm_lst_upd_by
        , holm_lst_upd_dt
        , holm_deleted_ind
        )
        VALUES
        ( @l_holm_id 
        , @pa_excm_id
        , @pa_holm_dt
        , @pa_holm_desc
        , @PA_LOGIN_NAME
        , GETDATE()
        , @PA_LOGIN_NAME
        , GETDATE()
        , 0
        )
        
        SET @l_error = @@error
        IF @l_error <> 0
        BEGIN
        --
          ROLLBACK TRANSACTION 
        --
        END
        ELSE
        BEGIN
        --
          COMMIT TRANSACTION
        --
        END
      --
      END
      ELSE IF @pa_action = 'DEL'
						BEGIN
						--
								BEGIN TRANSACTION
        
        DELETE FROM  holm_mak 
        WHERE holm_excm_id   = @pa_excm_id 
        AND holm_dt          = @pa_holm_dt 
        AND holm_deleted_ind = 0
         
								COMMIT TRANSACTION
						--
      END
      ELSE IF @pa_action = 'EDT'
      BEGIN
      --
        BEGIN TRANSACTION
        
        UPDATE holm_mak
        SET    holm_deleted_ind = 2
             , holm_lst_upd_dt  = getdate()
             , holm_lst_upd_by  = @pa_login_name
        WHERE  holm_id          = CONVERT(INT,@currstring)
        AND    holm_excm_id     = @pa_excm_id
        AND    holm_dt          = @pa_holm_dt
        AND    holm_deleted_ind = 0
        
        
        SET @l_error = @@error
        IF @l_error <> 0
        BEGIN
        --
          ROLLBACK TRANSACTION 
        --
        END
        ELSE
        BEGIN
        --
          SELECT @l_holmm_id = ISNULL(MAX(holm_id),0)+ 1 FROM  holm_mak WITH (NOLOCK)

          SELECT @l_holm_id = ISNULL(MAX(holm_id),0)+ 1 FROM  holm_mak WITH (NOLOCK)

          IF @l_holmm_id  > @l_holm_id 
          BEGIN
          --
            SET @l_holm_id = @l_holmm_id
          --
          END
                
          INSERT INTO holm_mak
          ( holm_id
          , holm_excm_id
          , holm_dt
          , holm_desc
          , holm_created_by
          , holm_created_dt
          , holm_lst_upd_by
          , holm_lst_upd_dt
          , holm_deleted_ind
          )
          VALUES
          ( @l_holm_id 
          , @pa_excm_id
          , @pa_holm_dt
          , @pa_holm_desc
          , @PA_LOGIN_NAME
          , GETDATE()
          , @PA_LOGIN_NAME
          , GETDATE()
          , 0
          )
          
          
          SET @l_error = @@error
          IF @l_error <> 0
          BEGIN
          --
            ROLLBACK TRANSACTION 
          --
          END
          ELSE
          BEGIN
          --
            COMMIT TRANSACTION
          --
          END
          
        --
        END
      --
      END
      ELSE IF @pa_action = 'APP'
      BEGIN
      --
        
        
        SELECT @l_excm_id  = holm_excm_id , @l_holm_dt = holm_dt FROM holm_mak where holm_id  = convert(numeric,@currstring)
        
        IF EXISTS(select * from holiday_mstr where holm_excm_id  = @l_excm_id and holm_dt = @l_holm_dt and holm_deleted_ind = 1)
        BEGIN
        --
          BEGIN TRANSACTION
          
          UPDATE holiday_mstr            
          SET    holm_dt               = holmm.holm_dt
               , holm_desc             = holmm.holm_desc
               , holm_lst_upd_dt       = holmm.holm_lst_upd_dt
          FROM   holm_mak                holmm     
          WHERE  holmm.holm_id         = convert(numeric,@currstring)
          AND    holmm.holm_deleted_ind      = 0  
          
          SET @l_error = @@error
          IF @l_error <> 0
          BEGIN
          --
            ROLLBACK TRANSACTION 
          --
          END
          ELSE
          BEGIN
          --
            UPDATE holm_mak 
            SET    holm_deleted_ind = 1
                 , holm_lst_upd_by  = @pa_login_name
                 , holm_lst_upd_dt  = getdate()
            WHERE  holm_id          = convert(numeric,@currstring)
            AND    holm_deleted_ind = 0

            COMMIT TRANSACTION
          --
          END
        --
        END
        ELSE
        BEGIN
        --
          BEGIN TRANSACTION
          
          INSERT INTO holiday_mstr
          ( holm_id 
          , holm_excm_id
          , holm_dt
          , holm_desc
          , holm_created_by
          , holm_created_dt
          , holm_lst_upd_by
          , holm_lst_upd_dt
          , holm_deleted_ind
          )
          SELECT holm_id
          , holm_excm_id
          , holm_dt
          , holm_desc
          , holm_created_by
          , holm_created_dt
          , holm_lst_upd_by
          , holm_lst_upd_dt
          , 1
          FROM  holm_mak
          WHERE holm_id = convert(numeric,@currstring)
          AND   holm_deleted_ind = 0
          
          SET @l_error = @@error
          IF @l_error <> 0
          BEGIN
          --
            ROLLBACK TRANSACTION 
          --
          END
          ELSE
          BEGIN
          --
            UPDATE holm_mak 
            SET    holm_deleted_ind = 1
                 , holm_lst_upd_by  = @pa_login_name
                 , holm_lst_upd_dt  = getdate()
            WHERE  holm_id          = convert(numeric,@currstring)
            AND    holm_deleted_ind = 0


            COMMIT TRANSACTION
          --
          END
        --
        END
      --
      END
      ELSE IF @pa_action = 'REJ'
      BEGIN
      --
        BEGIN TRANSACTION
        
        UPDATE holm_mak 
        SET    holm_deleted_ind = 3
             , holm_lst_upd_by  = @pa_login_name
             , holm_lst_upd_dt  = getdate()
        WHERE  holm_id          = convert(numeric,@currstring)
        AND    holm_deleted_ind = 0
        
        
        
        SET @l_error = @@error
        IF @l_error <> 0
        BEGIN
        --
          ROLLBACK TRANSACTION 
        --
        END
        ELSE
        BEGIN
        --
          COMMIT TRANSACTION
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
