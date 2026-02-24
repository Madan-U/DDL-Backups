-- Object: PROCEDURE citrus_usr.PR_INS_UPD_WFAT
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_INS_UPD_WFAT](@PA_ID              VARCHAR(8000)
                               ,@PA_ACTION          VARCHAR(20)
                               ,@PA_LOGIN_NAME      VARCHAR(20)
                               ,@PA_WFAT_PARENT_ID  NUMERIC
                               ,@PA_WFAT_CHILD_ID   VARCHAR(8000)
                               ,@PA_CHK_YN          INT
                               ,@ROWDELIMITER       CHAR(4)       = '*|~*'
                               ,@COLDELIMITER       CHAR(4)       = '|*~|'
                               ,@PA_ERRMSG          VARCHAR(8000) OUTPUT
)
AS
/*
*********************************************************************************
 SYSTEM          : CLASS
 MODULE NAME     : PR_INS_UPD_WFAT
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
  DECLARE @@L_ERRORSTR                 VARCHAR(8000)
        , @@L_ERROR                    BIGINT
        , @@DELIMETER                  VARCHAR(10)
        -- 
        , @@REMAININGSTRING_ID         VARCHAR(8000)
        , @@CURRSTRING_ID              VARCHAR(8000)
        --
        , @@REMAININGSTRING_CHILD_ID   VARCHAR(8000)
        , @@CURRSTRING_CHILD_ID        VARCHAR(8000)
        --
        , @@FOUNDAT                    INTEGER
        , @@DELIMETERLENGTH            INT
  --
  SET @@L_ERROR                  = 0
  SET @@L_ERRORSTR               = ''
  SET @@DELIMETER                = '%'+ @COLDELIMITER + '%'
  SET @@DELIMETERLENGTH          = LEN(@COLDELIMITER)
  SET @@REMAININGSTRING_ID       = @PA_ID 
  SET @@REMAININGSTRING_CHILD_ID = @PA_WFAT_CHILD_ID 
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
        WHILE @@REMAININGSTRING_CHILD_ID <> ''
        BEGIN--WFA_ID
        --
          SET @@FOUNDAT = 0
          SET @@FOUNDAT =  PATINDEX('%'+@@DELIMETER+'%',@@REMAININGSTRING_CHILD_ID)
          --
          IF @@FOUNDAT > 0
          BEGIN
          --
            SET @@CURRSTRING_CHILD_ID      = SUBSTRING(@@REMAININGSTRING_CHILD_ID, 0,@@FOUNDAT)
            SET @@REMAININGSTRING_CHILD_ID = SUBSTRING(@@REMAININGSTRING_CHILD_ID, @@FOUNDAT+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING_CHILD_ID)-@@FOUNDAT+@@DELIMETERLENGTH)
          --
          END
          ELSE
          BEGIN
          --
            SET @@CURRSTRING_CHILD_ID      = @@REMAININGSTRING_CHILD_ID
            SET @@REMAININGSTRING_CHILD_ID = ''
          --
          END
          --
          IF ISNULL(@@CURRSTRING_CHILD_ID,'') <> '' AND @@CURRSTRING_CHILD_ID <> '*|~*'
          BEGIN--#3
          --
            IF @PA_ACTION = 'INS'
            BEGIN--INS
            --
              BEGIN TRANSACTION
              --
              INSERT INTO WF_ACTION_TREE
              ( WFAT_PARENT_ID
              , WFAT_CHILD_ID
              , WFAT_CREATED_BY
              , WFAT_CREATED_DT
              , WFAT_LST_UPD_BY
              , WFAT_LST_UPD_DT
              , WFAT_DELETED_IND
              )
              VALUES
              ( @PA_WFAT_PARENT_ID
              , CONVERT(NUMERIC, @@CURRSTRING_CHILD_ID)
              , @PA_LOGIN_NAME
              , GETDATE()
              , @PA_LOGIN_NAME
              , GETDATE()
              , 1
              )
            --  
            END--INS
            --
            IF @PA_ACTION = 'DEL'
            BEGIN--DEL
            --
              BEGIN TRANSACTION
              --
              UPDATE WF_ACTION_TREE   WITH (ROWLOCK) 
              SET    WFAT_DELETED_IND = 0
                   , WFAT_LST_UPD_BY  = @PA_LOGIN_NAME
                   , WFAT_LST_UPD_DT  = GETDATE()
              WHERE  WFAT_PARENT_ID   = @PA_WFAT_PARENT_ID
              AND    WFAT_CHILD_ID    = CONVERT(NUMERIC, @@CURRSTRING_CHILD_ID)
              AND    WFAT_DELETED_IND = 1
            --  
            END--DEL
            --
            SET @@L_ERROR = @@ERROR
            --
            IF @@L_ERROR  > 0
            BEGIN--ROLL
            --
              ROLLBACK TRANSACTION
              --
              SET @@L_ERRORSTR = @@L_ERRORSTR+CONVERT(VARCHAR, @@CURRSTRING_ID)+@COLDELIMITER+ISNULL(@PA_WFAT_PARENT_ID,'0')+@COLDELIMITER+CONVERT(VARCHAR,@@CURRSTRING_CHILD_ID)+@COLDELIMITER++CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
            --
            END  --ROLL
            ELSE
            BEGIN--COM
            --
              COMMIT TRANSACTION
            --
            END  --COM
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
    UPDATE WF_ACTION_TREE   WITH (ROWLOCK)
    SET    WFAT_DELETED_IND = 0
         , WFAT_LST_UPD_BY  = @PA_LOGIN_NAME
         , WFAT_LST_UPD_DT  = GETDATE()
    WHERE  WFAT_PARENT_ID   = CONVERT(NUMERIC, @PA_WFAT_PARENT_ID)
    AND    WFAT_DELETED_IND = 1
  --  
  END --DELMSTR
  --
  SET @PA_ERRMSG = @@L_ERRORSTR
--  
END--#1

GO
