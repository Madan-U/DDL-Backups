-- Object: PROCEDURE citrus_usr.PR_MAK_USER
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_MAK_USER] (@PA_ID               VARCHAR(8000)
                             ,@PA_ACTION           VARCHAR(20)
                             ,@PA_LOGIN_NAME       VARCHAR(20)
                             ,@PA_USER_NAME        VARCHAR(20)
                             ,@PA_PSWD             VARCHAR(60)
                             ,@PA_ENTTM_ID         NUMERIC
                             ,@PA_ENT_ID           NUMERIC
                             ,@PA_SHORT_NAME       VARCHAR(50)
                             ,@PA_FROM_DT          VARCHAR(11)
                             ,@PA_TO_DT            VARCHAR(11)
                             ,@PA_PSW_EXP_ON       NUMERIC
                             ,@PA_LOGN_TOT_ATT     NUMERIC
                             ,@PA_LOGN_STATUS      VARCHAR(10)
                             ,@PA_USR_EMAIL        VARCHAR(50)
                             ,@PA_LOGIN_IP         VARCHAR(25)
                             ,@PA_MENU_PREF        VARCHAR(10)
                             ,@PA_VALUES           VARCHAR(8000)
                             ,@PA_CHK_YN           NUMERIC
                             ,@ROWDELIMITER        CHAR(4) = '*|~*'
                             ,@COLDELIMITER        CHAR(4) = '|*~|'
                             ,@PA_ERRMSG           VARCHAR(8000) OUT
                            )
AS
/*******************************************************************************
 SYSTEM         : CLASS
 MODULE NAME    : PR_MAK_USER
 DESCRIPTION    : THIS PROCEDURE WILL CREATE USERS
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.
 VERSION HISTORY:
 VERS.  AUTHOR             DATE         REASON
 -----  -------------      ----------   ------------------------------------------------
 1.0    SUKHVINDER/TUSHAR  23-FEB-2007  INITIAL VERSION.
 2.0    SUKHVINDER/TUSHAR  26-FEB-2007  ADDITION OF FIELD 'FROM_DATE' AND 'TO_DATE'
********************************************************************/
BEGIN --#1
--
  SET NOCOUNT ON
  --
  DECLARE @@L_ERRORSTR               VARCHAR(8000)
        , @@DELIMETER_ROW            CHAR(6)
        , @@DELIMETER_COL            CHAR(6)
        , @@DELIMETERLENGTH          INT
        , @@REMAININGSTRING_ID       VARCHAR(8000)
        , @@CURRSTRING_ID            VARCHAR(8000)
        , @@REMAININGSTRING_VALUE    VARCHAR(8000)
        , @@CURRSTRING_VALUE         VARCHAR(8000)
        , @@FOUNDAT                  INTEGER
        , @@L_ACTION                 CHAR(3)
        , @@L_ERROR                  NUMERIC
  --
  SET @@L_ERRORSTR             = 0
  SET @@DELIMETER_ROW          = '%'+ @ROWDELIMITER + '%'
  SET @@DELIMETER_COL          = '%'+ @COLDELIMITER + '%'
  SET @@DELIMETERLENGTH        = LEN(@ROWDELIMITER)
  SET @@REMAININGSTRING_ID     = @PA_ID
  SET @@REMAININGSTRING_VALUE  = @PA_VALUES
  SET @@L_ACTION               = ''
  --
  --IF @PA_ACTION = 'EDT' AND ISNULL(@PA_VALUES,'') <> ''
  --BEGIN
  --
    /*CREATE TABLE #T_ROLES
    (ENTRO_LOGN_NAME VARCHAR(20)
    ,ENTRO_ROLE_ID   NUMERIC
    )
    --
    INSERT INTO #T_ROLES
    (ENTRO_LOGN_NAME
    ,ENTRO_ROLE_ID
    )
    --
    SELECT ENTRO_LOGN_NAME, ENTRO_ROLE_ID
    FROM ENTITY_ROLES
    WHERE ENTRO_LOGN_NAME = @PA_USER_NAME
    --
    DELETE FROM ENTITY_ROLES
    WHERE ENTRO_LOGN_NAME = @PA_USER_NAME*/
  --
  --END
  --
  IF ISNULL(@PA_ID,'') <> '' AND ISNULL(@PA_ACTION,'') <> '' AND ISNULL(@PA_LOGIN_NAME,'') <> ''
  BEGIN --#2
  --
    WHILE @@REMAININGSTRING_ID <> ''
    BEGIN --#3
    --
      SET @@FOUNDAT = 0
      SET @@FOUNDAT =  PATINDEX('%'+@@DELIMETER_ROW +'%',@@REMAININGSTRING_ID)
      --
      IF @@FOUNDAT > 0
      BEGIN
      --
        SET @@CURRSTRING_ID      = SUBSTRING(@@REMAININGSTRING_ID, 0, @@FOUNDAT)
        SET @@REMAININGSTRING_ID = SUBSTRING(@@REMAININGSTRING_ID, @@FOUNDAT+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING_ID)- @@FOUNDAT+@@DELIMETERLENGTH)
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
      IF @@CURRSTRING_ID <> ''
      BEGIN --CURRSTRING_ID
      --
        IF @PA_CHK_YN = 0
        BEGIN --CHK_YN
        --
          IF @pa_enttm_id = 0
          BEGIN
          --
            select @pa_enttm_id = enttm_id from entity_type_mstr where enttm_desc = 'CLIENT' and enttm_deleted_ind = 1 
          --
          END
          IF @PA_ACTION = 'INS'
          BEGIN --INS
          --
            BEGIN TRANSACTION
            --
            INSERT INTO LOGIN_NAMES
            (LOGN_NAME
            ,LOGN_PSWD
            ,LOGN_ENTTM_ID
            ,LOGN_ENT_ID
            ,LOGN_SHORT_NAME
            ,LOGN_FROM_DT
            ,LOGN_TO_DT
            ,LOGN_PSW_EXP_ON
            ,LOGN_TOTAL_ATT
            ,LOGN_NO_OF_ATT
            ,LOGN_STATUS
            ,LOGN_USR_EMAIL
            ,LOGN_USR_IP
            ,LOGN_MENU_PREF
            ,LOGN_CREATED_BY
            ,LOGN_CREATED_DT
            ,LOGN_LST_UPD_BY
            ,LOGN_LST_UPD_DT
            ,LOGN_DELETED_IND
            )
            VALUES
            (@PA_USER_NAME
            ,@PA_PSWD
            ,@PA_ENTTM_ID
            ,@PA_ENT_ID
            ,@PA_SHORT_NAME
            ,CONVERT(DATETIME, @PA_FROM_DT, 103)
            ,CONVERT(DATETIME, @PA_TO_DT, 103)
            ,@PA_PSW_EXP_ON  
            ,@PA_LOGN_TOT_ATT
            ,0
            ,@PA_LOGN_STATUS 
            ,@PA_USR_EMAIL   
            ,@PA_LOGIN_IP    
            ,@PA_MENU_PREF   
            ,@PA_LOGIN_NAME
            ,GETDATE()
            ,@PA_LOGIN_NAME
            ,GETDATE()
            ,1
            )
            SET @@L_ERROR  = @@ERROR
            --
            IF  @@L_ERROR <> 0
            BEGIN --ROLL
            --
              ROLLBACK TRANSACTION
            --
            END  --ROLL
            ELSE
            BEGIN --COMM
            --
               COMMIT TRANSACTION
               --
               WHILE @@REMAININGSTRING_VALUE <> ''
               BEGIN --#01
               --
                 SET @@FOUNDAT = 0
                 SET @@FOUNDAT =  PATINDEX('%'+@@DELIMETER_COL+'%',@@REMAININGSTRING_VALUE)
                 --
                 IF @@FOUNDAT > 0
                 BEGIN
                 --
                   SET @@CURRSTRING_VALUE      = SUBSTRING(@@REMAININGSTRING_VALUE, 0, @@FOUNDAT)
                   SET @@REMAININGSTRING_VALUE = SUBSTRING(@@REMAININGSTRING_VALUE, @@FOUNDAT+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING_VALUE)- @@FOUNDAT+@@DELIMETERLENGTH)
                 --
                 END
                 ELSE
                 BEGIN
                 --
                   SET @@CURRSTRING_VALUE      = @@REMAININGSTRING_VALUE
                   SET @@REMAININGSTRING_VALUE = ''
                 --
                 END
                 --
                 IF @@CURRSTRING_VALUE <> ''
                 BEGIN  --CURRSTRING_VALUE
                 --
                   BEGIN TRANSACTION
                   --
                   INSERT INTO ENTITY_ROLES
                   (ENTRO_LOGN_NAME
                   ,ENTRO_ROL_ID
                   ,ENTRO_CREATED_BY
                   ,ENTRO_CREATED_DT
                   ,ENTRO_LST_UPD_BY
                   ,ENTRO_LST_UPD_DT
                   ,ENTRO_DELETED_IND
                   )
                   VALUES
                   (@PA_USER_NAME
                   ,@@CURRSTRING_VALUE
                   ,@PA_LOGIN_NAME
                   ,GETDATE()
                   ,@PA_LOGIN_NAME
                   ,GETDATE()
                   ,1
                   )
                   --
                   SET @@L_ERROR  = @@ERROR
                   --
                   IF  @@L_ERROR <> 0
                   BEGIN --#A1
                   --
                     ROLLBACK TRANSACTION
                   --
                   END   --#A1
                   ELSE
                   BEGIN --#A2
                   --
                     COMMIT TRANSACTION
                   --
                   END --#A2
                 --
                 END --CURRSTRING_VALUE
               --
               END --#01
            --
            END  --COMM
          --
          END --INS
          --
          IF @PA_ACTION = 'EDT'
          BEGIN  --EDT
          --
            BEGIN TRANSACTION
            --
            UPDATE LOGIN_NAMES WITH(ROWLOCK)
            SET LOGN_NAME        = @PA_USER_NAME
              --, LOGN_PSWD        = @PA_PSWD
              , LOGN_ENTTM_ID    = @PA_ENTTM_ID
              , LOGN_ENT_ID      = @PA_ENT_ID
              , LOGN_SHORT_NAME  = @PA_SHORT_NAME
              , LOGN_FROM_DT     = CONVERT(DATETIME, @PA_FROM_DT, 103)
              , LOGN_TO_DT       = CONVERT(DATETIME, @PA_TO_DT, 103)
              , LOGN_PSW_EXP_ON  = @PA_PSW_EXP_ON  
              , LOGN_TOTAL_ATT   = @PA_LOGN_TOT_ATT
              , LOGN_USR_EMAIL   = @PA_USR_EMAIL  
              , LOGN_USR_IP      = @PA_LOGIN_IP
              , LOGN_MENU_PREF   = @PA_MENU_PREF
              , LOGN_STATUS      = @PA_LOGN_STATUS
              , LOGN_LST_UPD_BY  = @PA_LOGIN_NAME
              , LOGN_LST_UPD_DT  = GETDATE()
            WHERE LOGN_NAME      = @PA_USER_NAME
            --
            SET @@L_ERROR  = @@ERROR
            --
            IF @@L_ERROR <> 0
            BEGIN --EDT_ROLL
            --
              ROLLBACK TRANSACTION
            --
            END   --EDT_ROLL
            ELSE
            BEGIN --EDT_COMM
            --
              --FIRST DELETE ALL RECORDS FOR A  @PA_USER_NAME
              DELETE FROM ENTITY_ROLES
              WHERE ENTRO_LOGN_NAME = @PA_USER_NAME
              --
              COMMIT TRANSACTION
              --
              WHILE @@REMAININGSTRING_VALUE <> ''
              BEGIN --EDIT_RMV
              --
                SET @@FOUNDAT = 0
                SET @@FOUNDAT =  PATINDEX('%'+@@DELIMETER_COL+'%',@@REMAININGSTRING_VALUE)
                --
                IF @@FOUNDAT > 0
                BEGIN --A1
                --
                  SET @@CURRSTRING_VALUE      = SUBSTRING(@@REMAININGSTRING_VALUE, 0, @@FOUNDAT)
                  SET @@REMAININGSTRING_VALUE = SUBSTRING(@@REMAININGSTRING_VALUE, @@FOUNDAT+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING_VALUE)- @@FOUNDAT+@@DELIMETERLENGTH)
                --
                END   --A1
                ELSE
                BEGIN --A2
                --
                  SET @@CURRSTRING_VALUE      = @@REMAININGSTRING_VALUE
                  SET @@REMAININGSTRING_VALUE = ''
                --
                END  --A2
                --
                IF @@CURRSTRING_VALUE <> ''
                BEGIN --EDT_CV
                --
                  --IF NOT EXISTS(SELECT ENTRO_LOGN_NAME FROM #T_ROLES WHERE ENTRO_ROL_ID = RTRIM(LTRIM(@@CURRSTRING_VALUE)))
                  --BEGIN --NOT_EXIST
                  --
                    BEGIN TRANSACTION
                    --
                    INSERT INTO ENTITY_ROLES
                    (ENTRO_LOGN_NAME
                    ,ENTRO_ROL_ID
                    ,ENTRO_CREATED_BY
                    ,ENTRO_CREATED_DT
                    ,ENTRO_LST_UPD_BY
                    ,ENTRO_LST_UPD_DT
                    ,ENTRO_DELETED_IND
                    )
                    VALUES
                    (@PA_USER_NAME
                    ,@@CURRSTRING_VALUE
                    ,@PA_LOGIN_NAME
                    ,GETDATE()
                    ,@PA_LOGIN_NAME
                    ,GETDATE()
                    ,1
                    )
                    --
                    SET @@L_ERROR  = @@ERROR
                    --
                    IF @@L_ERROR <> 0
                    BEGIN  --A3
                    --
                      ROLLBACK TRANSACTION
                    --
                    END   --A3
                    ELSE
                    BEGIN --A4
                    --
                      COMMIT TRANSACTION
                    --
                    END  --A4
                  --
                  --END  --NOT_EXIST
                --
                END   --EDT_CV
              --
              END --EDIT_RMV
            --
            END  --EDT_COMM
          --
          END   --EDT
        --
        END --CHK_YN
      --
      END --CURRSTRING_ID
    --
    END --#3
  --
  END --#2
  --
  SET @PA_ERRMSG = @@L_ERROR
--
END  --#1

GO
