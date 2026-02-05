-- Object: PROCEDURE citrus_usr.PR_MAK_COMP
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_MAK_COMP](@PA_ID               VARCHAR(8000)
                           ,@PA_ACTION           VARCHAR(20)
                           ,@PA_LOGIN_NAME       VARCHAR(20)
                           ,@PA_ROL_ID           NUMERIC
                           ,@PA_MDTRY_VALUES     VARCHAR(8000)
                           ,@PA_DISABLE_VALUES   VARCHAR(8000)
                           ,@PA_CHK_YN           NUMERIC
                           ,@ROWDELIMITER        CHAR(4) = '*|~*'
                           ,@COLDELIMITER        CHAR(4) = '|*~|'
                           ,@PA_ERRMSG           VARCHAR(8000) OUT
                           )
AS
/*******************************************************************************
 SYSTEM         : CLASS
 MODULE NAME    : PR_MAK_COMP
 DESCRIPTION    : THIS PROCEDURE WILL MAKE THE COMPONENTS MANDATORY(EXCHANGEWISE) OR DISABLED
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.
 VERSION HISTORY:
 VERS.  AUTHOR             DATE         REASON
 -----  -------------      ----------   ------------------------------------------------
 1.0    SUKHVINDER/TUSHAR  05-FEB-2007  INITIAL VERSION.
********************************************************************/
BEGIN
--
  SET NOCOUNT ON
  --
  DECLARE @@L_ERRORSTR               VARCHAR(8000)
        , @@DELIMETER                VARCHAR(10)
        , @@DELIMETERLENGTH          INT
        , @@L_ERROR                  NUMERIC
        --ID
        , @@REMAININGSTRING_ID       VARCHAR(8000)
        , @@CURRSTRING_ID            VARCHAR(8000)
        --MANDATORY
        , @@REMAININGSTRING_MVALUE   VARCHAR(8000)
        , @@CURRSTRING_MVALUE        VARCHAR(8000)
        --DISABLE
        , @@REMAININGSTRING_DVALUE   VARCHAR(8000)
        , @@CURRSTRING_DVALUE        VARCHAR(8000)
        --
        , @@FOUNDAT                  INTEGER
        , @@L_SCR_ID                 NUMERIC
        , @@L_COMP_ID                NUMERIC
        , @@L_EXCSM_ID               NUMERIC
        , @@L_ROLA_ACCESS1           INT
        , @@C_EXCSM_ID               NUMERIC
        , @@C_BITRM_BIT_LOCATION     NUMERIC
        , @@C_ACCESS_CURSOR          CURSOR
        , @@L_LOOP_COUNTER           INT
        , @@L_LOOP_COUNTER_DEC       INT
        , @@L_ACTION                 CHAR(3)
  --
  SET @@L_ERRORSTR             = NULL
  SET @@DELIMETER              = '%'+ @ROWDELIMITER + '%'
  SET @@DELIMETERLENGTH        = LEN(@ROWDELIMITER)
  SET @@REMAININGSTRING_ID     = @PA_ID
  SET @@REMAININGSTRING_MVALUE = @PA_MDTRY_VALUES
  SET @@REMAININGSTRING_DVALUE = @PA_DISABLE_VALUES
  SET @@L_ROLA_ACCESS1         = 0
  SET @@L_ACTION               = ''
  --
  CREATE TABLE #T_BITRM
  (BITRM_PARENT_CD     VARCHAR(25)
  ,BITRM_BIT_LOCATION  NUMERIC
  ,EXCSM_ID            NUMERIC
  )
  --
  INSERT INTO #T_BITRM
  (BITRM_PARENT_CD
  ,BITRM_BIT_LOCATION
  ,EXCSM_ID
  )
  SELECT BITRM.BITRM_PARENT_CD     BITRM_PARENT_CD
       , BITRM.BITRM_BIT_LOCATION  BITRM_BIT_LOCATION
       , EXCSM.EXCSM_ID            EXCSM_ID
  FROM   BITMAP_REF_MSTR           BITRM WITH (NOLOCK)
       , EXCH_SEG_MSTR             EXCSM WITH (NOLOCK)
  WHERE  EXCSM.EXCSM_DESC        = BITRM.BITRM_CHILD_CD
  AND    BITRM.BITRM_PARENT_CD  IN ('ACCESS1', 'ACCESS2')
  AND    BITRM.BITRM_DELETED_IND = 1
  AND    EXCSM.EXCSM_DELETED_IND = 1
  --
  IF ISNULL(@PA_ID,'') <> '' AND ISNULL(@PA_ACTION,'') <> '' AND ISNULL(@PA_LOGIN_NAME,'') <> ''
  BEGIN --#1
  --
    IF @PA_CHK_YN = 0
    BEGIN --#2
    --
      IF @PA_ACTION = 'EDT'
      BEGIN
      --
        DELETE FROM ROLES_COMPONENTS
        WHERE  ROLC_ROL_ID = @PA_ID
        --
        SET @@L_ACTION = 'INS'
      --
      END
      --
      IF @PA_ACTION = 'INS' OR @@L_ACTION = 'INS'
      BEGIN
      --
        WHILE @@REMAININGSTRING_ID <> ''
        BEGIN --#3
        --
          SET @@FOUNDAT = 0
          SET @@FOUNDAT =  PATINDEX('%'+@@DELIMETER+'%',@@REMAININGSTRING_ID)
          --
          IF @@FOUNDAT > 0
          BEGIN --#4
          --
            SET @@CURRSTRING_ID      = SUBSTRING(@@REMAININGSTRING_ID, 0, @@FOUNDAT)
            SET @@REMAININGSTRING_ID = SUBSTRING(@@REMAININGSTRING_ID, @@FOUNDAT+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING_ID)- @@FOUNDAT+@@DELIMETERLENGTH)
          --
          END   --#4
          ELSE
          BEGIN --#5
          --
            SET @@CURRSTRING_ID      = @@REMAININGSTRING_ID
            SET @@REMAININGSTRING_ID = ''
          --
          END   --#5
          --

          IF @@CURRSTRING_ID <> ''
          BEGIN --#6
          --
            WHILE @@REMAININGSTRING_MVALUE <> ''
            BEGIN --#7
            --
              SET @@FOUNDAT = 0
              SET @@FOUNDAT =  PATINDEX('%'+@@DELIMETER+'%', @@REMAININGSTRING_MVALUE)
              --
              IF @@FOUNDAT > 0
              BEGIN --#8
              --
                SET @@CURRSTRING_MVALUE      = SUBSTRING(@@REMAININGSTRING_MVALUE, 0,@@FOUNDAT)
                SET @@REMAININGSTRING_MVALUE = SUBSTRING(@@REMAININGSTRING_MVALUE, @@FOUNDAT+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING_MVALUE)- @@FOUNDAT+@@DELIMETERLENGTH)
              --
              END   --#8
              ELSE
              BEGIN --#9
              --
                SET @@CURRSTRING_MVALUE      = @@REMAININGSTRING_MVALUE
                SET @@REMAININGSTRING_MVALUE = ''
              --
              END   --#9
              --
              IF @@CURRSTRING_MVALUE  <> ''
              BEGIN --#10
              --
                SET @@L_SCR_ID           = citrus_usr.FN_SPLITVAL(@@CURRSTRING_MVALUE, 1)
                SET @@L_COMP_ID          = citrus_usr.FN_SPLITVAL(@@CURRSTRING_MVALUE, 2)
                SET @@L_LOOP_COUNTER     = citrus_usr.UFN_COUNTSTRING(@@CURRSTRING_MVALUE, @COLDELIMITER)-2
                SET @@L_LOOP_COUNTER_DEC = 3
                --
                WHILE @@L_LOOP_COUNTER <> 0
                BEGIN --#11
                --
                  SET @@L_EXCSM_ID       = citrus_usr.FN_SPLITVAL(@@CURRSTRING_MVALUE, @@L_LOOP_COUNTER_DEC)
                  --
                  SET @@C_ACCESS_CURSOR  = CURSOR FAST_FORWARD FOR
                  SELECT BITRM_BIT_LOCATION, EXCSM_ID
                  FROM #T_BITRM WHERE EXCSM_ID = @@L_EXCSM_ID
                  --
                  OPEN @@C_ACCESS_CURSOR
                  FETCH NEXT FROM @@C_ACCESS_CURSOR INTO @@C_BITRM_BIT_LOCATION, @@C_EXCSM_ID
                  --
                  IF @@FETCH_STATUS = 0
                  BEGIN  --#12
                  --
                    SET @@L_ROLA_ACCESS1 = POWER(2, @@C_BITRM_BIT_LOCATION -1) | @@L_ROLA_ACCESS1
                  --
                  END  --#12
                  --
                  CLOSE @@C_ACCESS_CURSOR
                  DEALLOCATE @@C_ACCESS_CURSOR
                  --
                  SET @@L_LOOP_COUNTER     = @@L_LOOP_COUNTER - 1
                  SET @@L_LOOP_COUNTER_DEC = @@L_LOOP_COUNTER_DEC + 1
                --
                END --#11
                --
                BEGIN TRANSACTION
                --
                INSERT INTO ROLES_COMPONENTS
                ( ROLC_ROL_ID
                , ROLC_SCR_ID
                , ROLC_COMP_ID
                , ROLC_MDTRY
                , ROLC_DISABLE
                , ROLC_CREATED_BY
                , ROLC_CREATED_DT
                , ROLC_LST_UPD_BY
                , ROLC_LST_UPD_DT
                , ROLC_DELETED_IND
                )
                VALUES
                ( @PA_ROL_ID
                , @@L_SCR_ID
                , @@L_COMP_ID
                , @@L_ROLA_ACCESS1
                , 0
                , @PA_LOGIN_NAME
                , GETDATE()
                , @PA_LOGIN_NAME
                , GETDATE()
                , 1
                )
                --
                SET @@L_ERROR = @@ERROR
                --
                IF @@L_ERROR > 0
                BEGIN
                --
                  SET @@L_ERRORSTR = CONVERT(VARCHAR, @@L_ERROR) + @ROWDELIMITER
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
                SET @@L_ROLA_ACCESS1 = 0
              --
              END  --#10
            --
            END   --#7  @@REMAININGSTRING_MVALUE
            -------------DISABLED---------------
            IF ISNULL(@PA_MDTRY_VALUES,'') = ''
            BEGIN--MDTRY=''
            --
              WHILE @@REMAININGSTRING_DVALUE <> ''
              BEGIN --#15
              --
                SET @@FOUNDAT = 0
                SET @@FOUNDAT =  PATINDEX('%'+@@DELIMETER+'%',@@REMAININGSTRING_DVALUE)
                --
                IF @@FOUNDAT > 0
                BEGIN --#8
                --
                  SET @@CURRSTRING_DVALUE      = SUBSTRING(@@REMAININGSTRING_DVALUE, 0,@@FOUNDAT)
                  SET @@REMAININGSTRING_DVALUE = SUBSTRING(@@REMAININGSTRING_DVALUE, @@FOUNDAT+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING_DVALUE)- @@FOUNDAT+@@DELIMETERLENGTH)
                  --
                END   --#8
                ELSE
                BEGIN --#9
                --
                  SET @@CURRSTRING_DVALUE      = @@REMAININGSTRING_DVALUE
                  SET @@REMAININGSTRING_DVALUE = ''
                --
                END   --#9
                --
                IF @@CURRSTRING_DVALUE <> ''
                BEGIN --#16
                --
                  SET @@L_SCR_ID  = citrus_usr.FN_SPLITVAL(@@CURRSTRING_DVALUE, 1)
                  SET @@L_COMP_ID = citrus_usr.FN_SPLITVAL(@@CURRSTRING_DVALUE, 2)
                  --
                  IF EXISTS(SELECT ROLC_ROL_ID
                            FROM   ROLES_COMPONENTS  WITH (NOLOCK)
                            WHERE  ROLC_ROL_ID      = @PA_ROL_ID
                            AND    ROLC_SCR_ID      = @@L_SCR_ID
                            AND    ROLC_COMP_ID     = @@L_COMP_ID
                            AND    ROLC_DELETED_IND = 1
                           )
                  BEGIN  --#17
                  --
                    BEGIN TRANSACTION
                    --
                    UPDATE ROLES_COMPONENTS  WITH (ROWLOCK)
                    SET    ROLC_DISABLE     = 1
                    WHERE  ROLC_ROL_ID      = @PA_ROL_ID
                    AND    ROLC_SCR_ID      = @@L_SCR_ID
                    AND    ROLC_COMP_ID     = @@L_COMP_ID
                    AND    ROLC_DELETED_IND = 1
                    --
                    SET @@L_ERROR = @@ERROR
                    --
                    IF @@L_ERROR > 0
                    BEGIN
                    --
                      SET @@L_ERRORSTR = CONVERT(VARCHAR, @@L_ERROR) + @ROWDELIMITER
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
                  END  --#17
                  ELSE
                  BEGIN --#18
                  --
                    BEGIN TRANSACTION
                    --
                    INSERT INTO ROLES_COMPONENTS
                    ( ROLC_ROL_ID
                    , ROLC_SCR_ID
                    , ROLC_COMP_ID
                    , ROLC_MDTRY
                    , ROLC_DISABLE
                    , ROLC_CREATED_BY
                    , ROLC_CREATED_DT
                    , ROLC_LST_UPD_BY
                    , ROLC_LST_UPD_DT
                    , ROLC_DELETED_IND
                    )
                    VALUES
                    ( @PA_ROL_ID
                    , @@L_SCR_ID
                    , @@L_COMP_ID
                    , 0
                    , 1
                    , @PA_LOGIN_NAME
                    , GETDATE()
                    , @PA_LOGIN_NAME
                    , GETDATE()
                    , 1
                    )
                    --
                    SET @@L_ERROR = @@ERROR
                    --
                    IF @@L_ERROR > 0
                    BEGIN  --#19
                    --
                      SET @@L_ERRORSTR = CONVERT(VARCHAR, @@L_ERROR) + @ROWDELIMITER
                      --
                      ROLLBACK TRANSACTION
                    --
                    END   --#19
                    ELSE
                    BEGIN --#20
                    --
                      COMMIT TRANSACTION
                    --
                   END    --#20
                  --
                  END  --#18
                --
                END  --#16
              --
              END --#15 @@REMAININGSTRING_DVALUE
            --
            END--MDTRY=''
          --
          END   --#6 @@CURRSTRING_ID
        --
        END --#3
      --
      END  --INS 0R INS
      ELSE
      BEGIN --DEL
      --
        BEGIN TRANSACTION
        --
        UPDATE ROLES_COMPONENTS WITH(ROWLOCK)
        SET    ROLC_DELETED_IND = 0
        WHERE  ROLC_ROL_ID      = @PA_ID
        --
        SET @@L_ERROR = @@ERROR
        --
        IF @@L_ERROR > 0
        BEGIN
        --
          SET @@L_ERRORSTR = CONVERT(VARCHAR, @@L_ERROR) + @ROWDELIMITER
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
      END --DEL
    --
    END   --#2
  --
  END   --#1
  --
  IF ISNULL(RTRIM(LTRIM(@@L_ERRORSTR)),'') = ''
  BEGIN
  --
    SET @PA_ERRMSG = 'Role Successfully Inserted/Edited'
  --
  END
  ELSE
  BEGIN
  --
    SET @PA_ERRMSG = @@L_ERRORSTR
  --
  END
--
END --END OF BEGIN

GO
