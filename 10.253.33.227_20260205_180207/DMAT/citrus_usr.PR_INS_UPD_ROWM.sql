-- Object: PROCEDURE citrus_usr.PR_INS_UPD_ROWM
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--PR_INS_UPD_ROWM '0','INS','SS',6,'11|*~|12|*~|13|*~|*|~*',0,'*|~*','|*~|',''
CREATE PROCEDURE [citrus_usr].[PR_INS_UPD_ROWM](@PA_ID           VARCHAR(8000)
                               ,@PA_ACTION       VARCHAR(20)
                               ,@PA_LOGIN_NAME   VARCHAR(20)
                               ,@PA_ROL_ID       NUMERIC
                               ,@PA_WFA_ID       VARCHAR(8000)
                               ,@PA_CHK_YN       INT
                               ,@ROWDELIMITER    CHAR(4)       = '*|~*'
                               ,@COLDELIMITER    CHAR(4)       = '|*~|'
                               ,@PA_ERRMSG       VARCHAR(8000) OUTPUT
)
AS
/*
*********************************************************************************
 SYSTEM          : CLASS
 MODULE NAME     : PR_INS_UPD_ROWM
 DESCRIPTION     : 
 COPYRIGHT(C)    : MARKETPLACE TECHNOLGIES PVT LTD
 VERSION HISTORY : 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  -----------------------------------------
 1.0    SUKHVINDER        29-MARCH-2007 1
 --------------------------------------------------------------------------------*/
--
BEGIN--#1
--
  SET NOCOUNT ON
  --
  DECLARE @@L_ERRORSTR               VARCHAR(8000)
        , @@L_ROWM_ID                NUMERIC
        , @@L_ERROR                  BIGINT
        , @@DELIMETER                VARCHAR(10)
        --
        , @@REMAININGSTRING_ID       VARCHAR(8000)
        , @@CURRSTRING_ID            VARCHAR(8000)
        --
        , @@REMAININGSTRING_WFA_ID   VARCHAR(8000)
        , @@CURRSTRING_WFA_ID        VARCHAR(8000)
        --
        , @@FOUNDAT                  INTEGER
        , @@DELIMETERLENGTH          INT
  --
  SET @@L_ERROR                = 0
  SET @@L_ERRORSTR             = ''
  SET @@DELIMETER              = '%'+ @COLDELIMITER + '%'
  SET @@DELIMETERLENGTH        = LEN(@COLDELIMITER)
  SET @@REMAININGSTRING_ID     = @PA_ID 
  SET @@REMAININGSTRING_WFA_ID = @PA_WFA_ID  
  --
  WHILE @@REMAININGSTRING_ID <> ''
  BEGIN--ID
  --
    SET @@FOUNDAT = 0
    SET @@FOUNDAT =  PATINDEX('%'+@@DELIMETER+'%',@@REMAININGSTRING_ID)
    --
    IF @@FOUNDAT > 0
    BEGIN
    --
      SET @@CURRSTRING_ID      = SUBSTRING(@@REMAININGSTRING_ID, 0,@@FOUNDAT)
      SET @@REMAININGSTRING_ID = SUBSTRING(@@REMAININGSTRING_ID, @@FOUNDAT+@@DELIMETERLENGTH,LEN(@@REMAININGSTRING_ID)- @@FOUNDAT+@@DELIMETERLENGTH)
    --
    END
    ELSE
    BEGIN
    --
      SET @@CURRSTRING_ID      = @@REMAININGSTRING_ID
      SET @@REMAININGSTRING_ID = ''
    --
    END 
    --
    IF ISNULL(@@CURRSTRING_ID,'') <> ''
    BEGIN--CID
    --
      IF @PA_CHK_YN = 0 --MAKERCHECKER FUNCTIONALITY IS NOT REQD
      BEGIN--#0
      --
        WHILE @@REMAININGSTRING_WFA_ID <> ''
        BEGIN--WFA_ID
        --
          SET @@FOUNDAT = 0
          SET @@FOUNDAT =  PATINDEX('%'+@@DELIMETER+'%',@@REMAININGSTRING_WFA_ID)
          --
          IF @@FOUNDAT > 0
          BEGIN
          --
            SET @@CURRSTRING_WFA_ID      = SUBSTRING(@@REMAININGSTRING_WFA_ID, 0,@@FOUNDAT)
            SET @@REMAININGSTRING_WFA_ID = SUBSTRING(@@REMAININGSTRING_WFA_ID, @@FOUNDAT+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING_WFA_ID)-@@FOUNDAT+@@DELIMETERLENGTH)
          --
          END
          ELSE
          BEGIN
          --
            SET @@CURRSTRING_WFA_ID      = @@REMAININGSTRING_WFA_ID
            SET @@REMAININGSTRING_WFA_ID = ''
          --
          END
          --
          IF ISNULL(@@CURRSTRING_WFA_ID,'') <> '' AND @@CURRSTRING_WFA_ID <> '*|~*'
          BEGIN--#3
          --
            SET @@L_ROWM_ID = NULL
            --
            SELECT @@L_ROWM_ID = ISNULL(MAX(ROWM_ID),0)+ 1
            FROM   ROL_WFA_MAPPING WITH (NOLOCK)

            IF @PA_ACTION = 'INS'
            BEGIN--INS
            --
              BEGIN TRANSACTION
              --
              INSERT INTO ROL_WFA_MAPPING
              ( ROWM_ID
              , ROWM_ROL_ID
              , ROWM_WFA_ID
              , ROWM_CREATED_BY
              , ROWM_CREATED_DT
              , ROWM_LST_UPD_BY
              , ROWM_LST_UPD_DT
              , ROWM_DELETED_IND
              )
              VALUES
              ( @@L_ROWM_ID
              , @PA_ROL_ID
              , CONVERT(NUMERIC, @@CURRSTRING_WFA_ID)
              , @PA_LOGIN_NAME
              , GETDATE()
              , @PA_LOGIN_NAME
              , GETDATE()
              , 1
              )
              --
              SET @@L_ERROR = @@ERROR
              --
              IF @@L_ERROR  > 0
              BEGIN--ROLL
              --
                ROLLBACK TRANSACTION
                --
                SET @@L_ERRORSTR = @@L_ERRORSTR+@@CURRSTRING_ID+@COLDELIMITER+ISNULL(@PA_ROL_ID,'0')+@COLDELIMITER+CONVERT(VARCHAR,@@CURRSTRING_WFA_ID)+@COLDELIMITER++CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
              --
              END  --ROLL
              ELSE
              BEGIN--COM
              --
                COMMIT TRANSACTION
              --
              END  --COM
            --  
            END--INS
            --
            IF @PA_ACTION = 'DEL'
            BEGIN --DEL
            --
              BEGIN TRANSACTION
              --
              UPDATE ROL_WFA_MAPPING    WITH (ROWLOCK) 
              SET    ROWM_DELETED_IND = 0
                   , ROWM_LST_UPD_BY  = @PA_LOGIN_NAME
                   , ROWM_LST_UPD_DT  = GETDATE()
              WHERE  ROWM_ROL_ID      = @PA_ROL_ID
              AND    ROWM_WFA_ID      = CONVERT(NUMERIC, @@CURRSTRING_WFA_ID)
              AND    ROWM_DELETED_IND = 1
              --
              SET @@L_ERROR = @@ERROR
              --
              IF @@L_ERROR  > 0
              BEGIN--ROLL
              --
                ROLLBACK TRANSACTION
                --
                SET @@L_ERRORSTR = @@L_ERRORSTR+@@CURRSTRING_ID+@COLDELIMITER+ISNULL(@PA_ROL_ID,'0')+@COLDELIMITER+CONVERT(VARCHAR,@@CURRSTRING_WFA_ID)+@COLDELIMITER++CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
              --
              END  --ROLL
              ELSE
              BEGIN--COM
              --
                COMMIT TRANSACTION
              --
              END  --COM
            --  
            END  --DEL
          --
          END--#3
        --  
        END--WFA_ID  
      --
      END  --#0
    --  
    END--CID  
  --
  END--ID
  --
  IF @PA_ACTION = 'DELMSTR'
  BEGIN--DELMSTR
  --
    BEGIN TRANSACTION
    --
    UPDATE ROL_WFA_MAPPING    WITH (ROWLOCK)
    SET    ROWM_DELETED_IND = 0
         , ROWM_LST_UPD_BY  = @PA_LOGIN_NAME
         , ROWM_LST_UPD_DT  = GETDATE()
    WHERE  ROWM_ROL_ID      = @PA_ROL_ID
    AND    ROWM_DELETED_IND = 1
    --
    SET @@L_ERROR = @@ERROR
    --
    IF @@L_ERROR  > 0
    BEGIN--ROLL
    --
      ROLLBACK TRANSACTION
    --
    END  --ROLL
    ELSE
    BEGIN--COM
    --
      COMMIT TRANSACTION
    --
    END  --COM
  --
  END--DELMSTR 
  --
  SET @PA_ERRMSG = @@L_ERRORSTR
--  
END--#1

GO
