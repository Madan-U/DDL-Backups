-- Object: PROCEDURE citrus_usr.PR_MAK_PROM
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--PR_MAK_PROM '1','','HO','NORMAL','NORMAL','3|*~|0|*~|*|~*',0,'*|~*','|*~|',''
--PR_MAK_PROM '1','','HO','NORMAL','NORMAL','4|*~|0|*~|*|~*',0,'*|~*','|*~|',''
CREATE PROCEDURE [citrus_usr].[PR_MAK_PROM] (@PA_ID            VARCHAR(8000)
																												,@PA_ACTION        VARCHAR(20)
																												,@PA_LOGIN_NAME    VARCHAR(20)  
                            ,@PA_PROM_CD       VARCHAR(20)   = ''
																												,@PA_PROM_DESC     VARCHAR(20)   = ''
																												,@PA_PROM_RMKS     VARCHAR(200)
																												,@PA_VALUES        VARCHAR(8000)
																												,@PA_CHK_YN        INT
																												,@ROWDELIMITER     CHAR(4) = '*|~*'
																												,@COLDELIMITER     CHAR(4) = '|*~|'
																												,@PA_ERRMSG        VARCHAR(8000) OUTPUT
                              )
AS
/*
*********************************************************************************
 SYSTEM         : CLASS
 MODULE NAME    : PR_MAK_PRODM
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE MAKER CHECKER FACILITY FOR PRODUCT_MSTR
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.
 VERSION HISTORY:
 VERS.  AUTHOR            DATE         REASON
 -----  -------------     ----------   -------------------------------------------------
 1.0    HARI N            15-DEC-2006  INITIAL
 2.0    SUKHVINDER/TUSHAR 25-JAN-2007  CHANGES IN TABLE
 3.0    SUKHVINDER/TUSHAR 28-FEB-2007
-----------------------------------------------------------------------------------*/
--
BEGIN
--
  SET NOCOUNT ON
  --
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  --
  DECLARE @@REMAININGSTRING_VAL  VARCHAR(8000)
        , @@CURRSTRING_VAL       VARCHAR(8000)
        , @@FOUNDAT_VAL          INT
        , @@REMAININGSTRING_ID   VARCHAR(8000)
        , @@CURRSTRING_ID        VARCHAR(8000)
        , @@FOUNDAT_ID           INT
        , @@DELIMETERLENGTH      INT
        , @@L_ERRORSTR           VARCHAR(8000)
        , @@L_DELIMETER_ROW      CHAR(4)
        , @@L_DELIMETER_COL      CHAR(4)
        , @@L_ERROR              BIGINT
        , @@L_NODE               CHAR(5)
        , @@L_EXISTS             NUMERIC
        , @@L_PROM_ID            NUMERIC
        , @@L_EXCSM_ID           NUMERIC
        , @@L_DEL_FLAG           SMALLINT
        , @@L_EXCPM_ID           NUMERIC
        , @@L_PROMM_ID           NUMERIC
        , @@L_DELETED_IND        SMALLINT
        , @@L_TEMP_ID            NUMERIC
  --
  SET @@L_ERROR             = 0
  SET @@L_ERRORSTR          = ''
  SET @@L_DELIMETER_ROW     =  @ROWDELIMITER
  SET @@L_DELIMETER_COL     = '%'+ @COLDELIMITER + '%'
  SET @@DELIMETERLENGTH     = LEN(@ROWDELIMITER)
  SET @@REMAININGSTRING_ID  = @PA_ID
  SET @@REMAININGSTRING_VAL = @PA_VALUES
  --
  IF @PA_CHK_YN = 1
  BEGIN--#CHK1
  --
    IF @PA_ACTION <> 'APP' AND @PA_ACTION <> 'REJ'
    BEGIN --ACTIONS
    --
      CREATE TABLE #PRODUCTMSTRMAK
      (PROM_ID           NUMERIC
      ,PROM_CD           VARCHAR(20)
      ,PROM_DESC         VARCHAR(100)
      ,PROM_RMKS         VARCHAR(250)
      ,PROM_EXCSM_ID     NUMERIC
      ,PROM_CREATED_BY   VARCHAR(25)
      ,PROM_CREATED_DT   DATETIME
      ,PROM_LST_UPD_BY   VARCHAR(25)
      ,PROM_LST_UPD_DT   DATETIME
      ,PROM_DELETED_IND  SMALLINT
      )
      INSERT INTO #PRODUCTMSTRMAK
      (PROM_ID
      ,PROM_CD
      ,PROM_DESC
      ,PROM_RMKS
      ,PROM_EXCSM_ID
      ,PROM_CREATED_BY
      ,PROM_CREATED_DT
      ,PROM_LST_UPD_BY
      ,PROM_LST_UPD_DT
      ,PROM_DELETED_IND
      )
      SELECT PROM_ID
           , PROM_CD
           , PROM_DESC
           , PROM_RMKS
           , PROM_EXCSM_ID
           , PROM_CREATED_BY
           , PROM_CREATED_DT
           , PROM_LST_UPD_BY
           , PROM_LST_UPD_DT
           , PROM_DELETED_IND
      FROM  PRODUCT_MSTR_MAK WITH(NOLOCK)
      WHERE PROM_DELETED_IND = 0
      AND   PROM_ID          = @PA_ID
      --
      CREATE TABLE #PRODUCTMSTR
      (PROM_ID           NUMERIC
      ,PROM_CD           VARCHAR(20)
      ,PROM_DESC         VARCHAR(100)
      ,PROM_RMKS         VARCHAR(250)
      ,PROM_EXCSM_ID     NUMERIC
      ,PROM_CREATED_BY   VARCHAR(25)
      ,PROM_CREATED_DT   DATETIME
      ,PROM_LST_UPD_BY   VARCHAR(25)
      ,PROM_LST_UPD_DT   DATETIME
      ,PROM_DELETED_IND  SMALLINT
      )
      INSERT INTO #PRODUCTMSTR
      (PROM_ID
      ,PROM_CD
      ,PROM_DESC
      ,PROM_RMKS
      ,PROM_EXCSM_ID
      ,PROM_CREATED_BY
      ,PROM_CREATED_DT
      ,PROM_LST_UPD_BY
      ,PROM_LST_UPD_DT
      ,PROM_DELETED_IND
      )
      SELECT PROM_ID
           , PROM_CD
           , PROM_DESC
           , PROM_RMKS
           , EXCPM_EXCSM_ID
           , PROM_CREATED_BY
           , PROM_CREATED_DT
           , PROM_LST_UPD_BY
           , PROM_LST_UPD_DT
           , PROM_DELETED_IND
      FROM   PRODUCT_MSTR            PROM
           , EXCSM_PROD_MSTR         EXCPM
      WHERE  PROM.PROM_ID          = EXCPM.EXCPM_PROM_ID
      AND    PROM.PROM_DELETED_IND = 1
      AND    PROM_ID               = @PA_ID
    --
    END--ACTIONS
  --
  END--#CHK1
  --
  WHILE @@REMAININGSTRING_ID <> ''
  BEGIN --#01
  --
    SET @@FOUNDAT_ID  = 0
    SET @@FOUNDAT_ID  =  PATINDEX('%'+@@L_DELIMETER_ROW+'%', @@REMAININGSTRING_ID)
    --
    IF @@FOUNDAT_ID > 0
    BEGIN
    --
      SET @@CURRSTRING_ID      = SUBSTRING(@@REMAININGSTRING_ID, 0, @@FOUNDAT_ID)
      SET @@REMAININGSTRING_ID = SUBSTRING(@@REMAININGSTRING_ID, @@FOUNDAT_ID+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING_ID)- @@FOUNDAT_ID+@@DELIMETERLENGTH)
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
    BEGIN --CID
    --
        IF @PA_CHK_YN = 0
        BEGIN --PA_CHK_YN=0
        --
          IF @PA_ACTION = 'INS'
          BEGIN--INS0
          --
            BEGIN TRANSACTION
            --
            SELECT @@L_PROM_ID = ISNULL(MAX(PROM_ID),0)+ 1
            FROM  PRODUCT_MSTR WITH (NOLOCK)
            --
            INSERT INTO PRODUCT_MSTR
            (PROM_ID
            ,PROM_CD
            ,PROM_DESC
            ,PROM_RMKS
            ,PROM_CREATED_BY
            ,PROM_CREATED_DT
            ,PROM_LST_UPD_BY
            ,PROM_LST_UPD_DT
            ,PROM_DELETED_IND
            )
            VALUES
            (@@L_PROM_ID
            ,@PA_PROM_CD
            ,@PA_PROM_DESC
            ,@PA_PROM_RMKS
            ,@PA_LOGIN_NAME
            ,GETDATE()
            ,@PA_LOGIN_NAME
            ,GETDATE()
            ,1
            )
            --
            SET @@L_ERROR = @@ERROR
            --
            IF @@L_ERROR  > 0
            BEGIN
            --
              ROLLBACK TRANSACTION 
              --
              SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
            --
            END
            ELSE
            BEGIN
            --
              COMMIT TRANSACTION
            --
            END
            --
            IF @@L_ERROR = 0
            BEGIN --0
            -- 
              WHILE @@REMAININGSTRING_VAL <> ''
              BEGIN --RV1
              --
                BEGIN TRANSACTION
                --
                SET @@FOUNDAT_VAL  = 0
                SET @@FOUNDAT_VAL  =  PATINDEX('%'+@@L_DELIMETER_ROW+'%', @@REMAININGSTRING_VAL)
                --
                IF @@FOUNDAT_VAL > 0
                BEGIN
                --
                  SET @@CURRSTRING_VAL      = SUBSTRING(@@REMAININGSTRING_VAL, 0, @@FOUNDAT_VAL)
                  SET @@REMAININGSTRING_VAL = SUBSTRING(@@REMAININGSTRING_VAL, @@FOUNDAT_VAL+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING_VAL)- @@FOUNDAT_VAL+@@DELIMETERLENGTH)
                --
                END
                ELSE
                BEGIN
                --
                  SET @@CURRSTRING_VAL      = @@REMAININGSTRING_VAL
                  SET @@REMAININGSTRING_VAL = ''
                --
                END
                --
                IF ISNULL(@@CURRSTRING_VAL,'') <> ''
                BEGIN--CV
                --
                  SET @@L_EXCSM_ID = CONVERT(NUMERIC, citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL, 1))
                  SET @@L_DEL_FLAG = CONVERT(NUMERIC, citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL, 2))
                  --
                  IF @@L_DEL_FLAG = 0
                  BEGIN --FLAG=0
                  --
                    PRINT ''
                  --
                  END--FLAG=0
                  ELSE
                  BEGIN--FLAG=1
                  --
                    SELECT @@L_EXCPM_ID = ISNULL(MAX(EXCPM_ID),0)+ 1
                    FROM  EXCSM_PROD_MSTR WITH (NOLOCK)
                    --
                    INSERT INTO EXCSM_PROD_MSTR
                    (EXCPM_ID
                    ,EXCPM_EXCSM_ID
                    ,EXCPM_PROM_ID
                    ,EXCPM_CREATED_BY
                    ,EXCPM_CREATED_DT
                    ,EXCPM_LST_UPD_BY
                    ,EXCPM_LST_UPD_DT
                    ,EXCPM_DELETED_IND
                    )
                    VALUES
                    (@@L_EXCPM_ID
                    ,@@L_EXCSM_ID
                    ,@@L_PROM_ID
                    ,@PA_LOGIN_NAME
                    ,GETDATE()
                    ,@PA_LOGIN_NAME
                    ,GETDATE()
                    ,1
                    )
                    --
                    SET @@L_ERROR = @@ERROR
                    --
                    IF @@L_ERROR > 0
                    BEGIN
                    --
                      SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
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
                  END--FLAG=1
                --
                END--CV
              --
              END--RV1
            --  
            END --0
          --
          END--INS0
          ELSE IF ISNULL(RTRIM(LTRIM(@PA_ACTION)),'') = ''
          BEGIN --'NULL0
          --
            WHILE @@REMAININGSTRING_VAL <> ''
            BEGIN --RV2
            --
              SET @@FOUNDAT_VAL  = 0
              SET @@FOUNDAT_VAL  =  PATINDEX('%'+@@L_DELIMETER_ROW+'%', @@REMAININGSTRING_VAL)
              --
              IF @@FOUNDAT_VAL > 0
              BEGIN
              --
                SET @@CURRSTRING_VAL      = SUBSTRING(@@REMAININGSTRING_VAL, 0, @@FOUNDAT_VAL)
                SET @@REMAININGSTRING_VAL = SUBSTRING(@@REMAININGSTRING_VAL, @@FOUNDAT_VAL+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING_VAL)- @@FOUNDAT_VAL+@@DELIMETERLENGTH)
              --
              END
              ELSE
              BEGIN
              --
                SET @@CURRSTRING_VAL      = @@REMAININGSTRING_VAL
                SET @@REMAININGSTRING_VAL = ''
              --
              END
              --
              IF ISNULL(@@CURRSTRING_VAL,'') <> ''
              BEGIN --CV
              --
                SET @@L_EXCSM_ID = CONVERT(NUMERIC, citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL, 1))
                SET @@L_DEL_FLAG = CONVERT(NUMERIC, citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL, 2))
                --
                IF @@L_DEL_FLAG = 0
                BEGIN--FLAG=0
                --
                  BEGIN TRANSACTION
                  --
                  /*
                  UPDATE EXCSM_PROD_MSTR WITH(ROWLOCK)
                  SET    EXCPM_LST_UPD_BY  = @PA_LOGIN_NAME
                       , EXCPM_LST_UPD_DT  = GETDATE()
                       , EXCPM_DELETED_IND = 0
                  WHERE  EXCPM_PROM_ID     = @@CURRSTRING_ID
                  AND    EXCPM_EXCSM_ID    = @@L_EXCSM_ID
                  AND    EXCPM_DELETED_IND = 1
                  */
                  --
                  DELETE FROM EXCSM_PROD_MSTR
                  WHERE  EXCPM_PROM_ID     = @@CURRSTRING_ID
                  AND    EXCPM_EXCSM_ID    = @@L_EXCSM_ID
                  AND    EXCPM_DELETED_IND = 1
                  --
                  SET @@L_ERROR = @@ERROR
                  --
                  IF @@L_ERROR > 0
                  BEGIN--#1
                  --
                    SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
                    --
                    ROLLBACK TRANSACTION
                  --
                  END--#1
                  ELSE
                  BEGIN--#2
                  --
                    COMMIT TRANSACTION
                  --
                  END--#2
                --
                END--FLAG=0
                ELSE
                BEGIN--FLAG=1
                --
                  BEGIN TRANSACTION
                  --
                  SELECT @@L_EXCPM_ID = ISNULL(MAX(EXCPM_ID),0) + 1
                  FROM  EXCSM_PROD_MSTR WITH (NOLOCK)
                  --
                  INSERT INTO EXCSM_PROD_MSTR
                  (EXCPM_ID
                  ,EXCPM_EXCSM_ID
                  ,EXCPM_PROM_ID
                  ,EXCPM_CREATED_BY
                  ,EXCPM_CREATED_DT
                  ,EXCPM_LST_UPD_BY
                  ,EXCPM_LST_UPD_DT
                  ,EXCPM_DELETED_IND
                  )
                  VALUES
                  (@@L_EXCPM_ID
                  ,@@L_EXCSM_ID
                  ,@@CURRSTRING_ID
                  ,@PA_LOGIN_NAME
                  ,GETDATE()
                  ,@PA_LOGIN_NAME
                  ,GETDATE()
                  ,1
                  )
                  --
                  SET @@L_ERROR = @@ERROR
                  --
                  IF @@L_ERROR > 0
                  BEGIN--#1
                  --
                    SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
                    --
                    ROLLBACK TRANSACTION
                  --
                  END--#1
                  ELSE
                  BEGIN--#2
                  --
                    COMMIT TRANSACTION
                  --
                  END--#2
                --
                END--FLAG=1
              --
              END--CV
            --
            END--RV2
          --
          END--'NULL0
          ELSE IF ISNULL(RTRIM(LTRIM(@PA_ACTION)),'') = 'DELMSTR'
          BEGIN--'DELMSTR0
          --
            BEGIN TRANSACTION
            --
            UPDATE PRODUCT_MSTR        WITH (ROWLOCK)
            SET    PROM_DELETED_IND  = 0
                 , PROM_LST_UPD_BY   = @PA_LOGIN_NAME
                 , PROM_LST_UPD_DT   = GETDATE()
            WHERE  PROM_ID           = @@CURRSTRING_ID
            AND    PROM_DELETED_IND  = 1
            --
            SET @@L_ERROR = @@ERROR
            --
            IF @@L_ERROR > 0
            BEGIN --RINS
            --
              SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
              --
              ROLLBACK TRANSACTION
            --
            END   --RINS
            --
            /*
            UPDATE EXCSM_PROD_MSTR
            SET    EXCPM_DELETED_IND = 0
                 , EXCPM_LST_UPD_BY  = @PA_LOGIN_NAME
                 , EXCPM_LST_UPD_DT  = GETDATE()
            WHERE  EXCPM_ID          = @@CURRSTRING_ID
            AND    EXCPM_DELETED_IND = 1 
            */
            --
            DELETE EXCSM_PROD_MSTR
            WHERE  EXCPM_ID          = @@CURRSTRING_ID
            AND    EXCPM_DELETED_IND = 1
            --
            SET @@L_ERROR = @@ERROR
            --
            IF @@L_ERROR > 0
            BEGIN --RINS
            --
              SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
              --
              ROLLBACK TRANSACTION
            --
            END   --RINS
            --
            COMMIT TRANSACTION
          --
          END--'DELMSTR0
          ELSE IF @PA_ACTION = 'EDTMSTR'
          BEGIN--EDTMSTR0
          --
            BEGIN TRANSACTION
            --
            UPDATE PRODUCT_MSTR      WITH(ROWLOCK)
            SET    PROM_CD         = @PA_PROM_CD
                 , PROM_DESC       = @PA_PROM_DESC
                 , PROM_LST_UPD_BY = @PA_LOGIN_NAME
                 , PROM_LST_UPD_DT = GETDATE()
                 , PROM_RMKS       = @PA_PROM_RMKS
            WHERE PROM_ID          = @PA_ID
            AND PROM_DELETED_IND   = 1
            --
            SET @@L_ERROR = @@ERROR
            --
            IF @@L_ERROR  > 0
            BEGIN
            --
              SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
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
          END--EDTMSTR0
        --
        END--PA_CHK_YN=0

        ---**************---

        IF @PA_CHK_YN = 1
        BEGIN --PA_CHK_YN=1
        --
          IF @PA_ACTION = 'INS'
          BEGIN--INS1
          --
            IF EXISTS(SELECT DISTINCT PROM_ID 
                      FROM PRODUCT_MSTR_MAK WITH(NOLOCK)
                      WHERE PROM_CD = @PA_PROM_CD
                     )
            BEGIN--E1
            --
              SELECT @@L_PROM_ID = PROM_ID
              FROM PRODUCT_MSTR_MAK  WITH (NOLOCK)
              WHERE PROM_CD      = @PA_PROM_CD
            --
            END--E1
            ELSE
            BEGIN--E2
            --
              SELECT @@L_PROMM_ID = ISNULL(MAX(PROMM.PROM_ID),0)+1
              FROM PRODUCT_MSTR_MAK PROMM WITH (NOLOCK)
              --
              SELECT @@L_PROM_ID  = ISNULL(MAX(PROM.PROM_ID),0)+1
              FROM PRODUCT_MSTR PROM WITH (NOLOCK)
              --
              IF @@L_PROMM_ID > @@L_PROM_ID
              BEGIN
              --
                SET @@L_PROM_ID = @@L_PROMM_ID
              --
              END
            --
            END--E2
            --
            WHILE @@REMAININGSTRING_VAL <> ''
            BEGIN --RV1
            --
              SET @@FOUNDAT_VAL  = 0
              SET @@FOUNDAT_VAL  =  PATINDEX('%'+@@L_DELIMETER_ROW+'%', @@REMAININGSTRING_VAL)
              --
              IF @@FOUNDAT_VAL > 0
              BEGIN
              --
                SET @@CURRSTRING_VAL      = SUBSTRING(@@REMAININGSTRING_VAL, 0, @@FOUNDAT_VAL)
                SET @@REMAININGSTRING_VAL = SUBSTRING(@@REMAININGSTRING_VAL, @@FOUNDAT_VAL+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING_VAL)- @@FOUNDAT_VAL+@@DELIMETERLENGTH)
              --
              END
              ELSE
              BEGIN
              --
                SET @@CURRSTRING_VAL      = @@REMAININGSTRING_VAL
                SET @@REMAININGSTRING_VAL = ''
              --
              END
              --
              IF ISNULL(@@CURRSTRING_VAL,'') <> ''
              BEGIN --CV
              --
                SET @@L_EXCSM_ID = CONVERT(NUMERIC, citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL, 1))
                SET @@L_DEL_FLAG = CONVERT(NUMERIC, citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL, 2))
                --
                BEGIN TRANSACTION
                --
                INSERT INTO PRODUCT_MSTR_MAK
                (PROM_ID
                ,PROM_CD
                ,PROM_DESC
                ,PROM_RMKS
                ,PROM_EXCSM_ID
                ,PROM_CREATED_BY
                ,PROM_CREATED_DT
                ,PROM_LST_UPD_BY
                ,PROM_LST_UPD_DT
                ,PROM_DELETED_IND
                )
                VALUES
                (@@L_PROM_ID
                ,@PA_PROM_CD
                ,@PA_PROM_DESC
                ,@PA_PROM_RMKS
                ,@@L_EXCSM_ID
                ,@PA_LOGIN_NAME
                ,GETDATE()
                ,@PA_LOGIN_NAME
                ,GETDATE()
                ,0
                )
                --
                IF @@L_DEL_FLAG = 0
                BEGIN --FLAG=0
                --
                  --DELETE FROM EXCSM_PROD_MSTR
                  --WHERE EXCPM_EXCSM_ID = @@L_EXCSM_ID
                  PRINT ''
                --
                END--FLAG=0
                --
                SET  @@L_ERROR = @@ERROR
                --
                IF @@L_ERROR > 0
                BEGIN
                --
                  SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
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
              END--CV
            --
            END--RV1
          --
          END--INS1
          ELSE IF ISNULL(@PA_ACTION,'') = 'EDTMSTR'
          BEGIN --EDTMSTR1
          --
            BEGIN TRANSACTION
            --
            UPDATE PRODUCT_MSTR_MAK   WITH(ROWLOCK)
            SET    PROM_DELETED_IND = 2
                 , PROM_LST_UPD_BY  = @PA_LOGIN_NAME
                 , PROM_LST_UPD_DT  = GETDATE()
            WHERE  PROM_ID          = CONVERT(INT, @@CURRSTRING_ID)
            AND    PROM_DELETED_IND = 0
            --
            SET @@L_ERROR = @@ERROR
            --
            IF @@L_ERROR > 0
            BEGIN--RINS
            --
              SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
              --
              ROLLBACK TRANSACTION
            --
            END--RINS
            --
            UPDATE #PRODUCTMSTRMAK
            SET    PROM_CD          = @PA_PROM_CD
                 , PROM_DESC        = @PA_PROM_DESC
                 , PROM_RMKS        = @PA_PROM_RMKS
                 , PROM_LST_UPD_BY  = @PA_LOGIN_NAME
                 , PROM_LST_UPD_DT  = GETDATE()
            WHERE  PROM_ID          = CONVERT(INT, @@CURRSTRING_ID)
            AND    PROM_DELETED_IND = 0
            --
            INSERT INTO PRODUCT_MSTR_MAK
            (PROM_ID
            ,PROM_CD
            ,PROM_DESC
            ,PROM_EXCSM_ID
            ,PROM_CREATED_BY
            ,PROM_CREATED_DT
            ,PROM_LST_UPD_BY
            ,PROM_LST_UPD_DT
            ,PROM_DELETED_IND
            ,PROM_RMKS
            )
            SELECT PROM_ID
                 , PROM_CD
                 , PROM_DESC
                 , PROM_EXCSM_ID
                 , PROM_CREATED_BY
                 , PROM_CREATED_DT
                 , PROM_LST_UPD_BY
                 , PROM_LST_UPD_DT
                 , PROM_DELETED_IND
                 , PROM_RMKS
            FROM  #PRODUCTMSTRMAK
            WHERE  PROM_ID =  CONVERT(INT, @@CURRSTRING_ID)
            --
            SET @@L_ERROR = @@ERROR
            --
            IF @@L_ERROR > 0
            BEGIN--RINS
            --
              SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
              --
              ROLLBACK TRANSACTION
            --
            END--RINS
            --
            COMMIT TRANSACTION
          --
          END--EDTMSTR1
          ELSE IF ISNULL(LTRIM(RTRIM(@PA_ACTION)),'') = ''
          BEGIN--''1
          --
            WHILE @@REMAININGSTRING_VAL <> ''
            BEGIN --RV2
            --
              SET @@FOUNDAT_VAL  = 0
              SET @@FOUNDAT_VAL  =  PATINDEX('%*|~*%', @@REMAININGSTRING_VAL)
              --
              IF @@FOUNDAT_VAL > 0
              BEGIN
              --
                SET @@CURRSTRING_VAL      = SUBSTRING(@@REMAININGSTRING_VAL, 0, @@FOUNDAT_VAL)
                SET @@REMAININGSTRING_VAL = SUBSTRING(@@REMAININGSTRING_VAL, @@FOUNDAT_VAL+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING_VAL)- @@FOUNDAT_VAL+@@DELIMETERLENGTH)
              --
              END
              ELSE
              BEGIN
              --
                SET @@CURRSTRING_VAL      = @@REMAININGSTRING_VAL
                SET @@REMAININGSTRING_VAL = ''
              --
              END
              --
              IF ISNULL(@@CURRSTRING_VAL,'') <> ''
              BEGIN --CV
              --
                SET @@L_EXCSM_ID = CONVERT(NUMERIC, citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL, 1))
                SET @@L_DEL_FLAG = CONVERT(NUMERIC, citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL, 2))
                --
                IF @@L_DEL_FLAG = 0
                BEGIN--FLAG=0
                --
                  SELECT @@L_TEMP_ID      = ISNULL(PROM_ID,0) 
                  FROM   PRODUCT_MSTR WITH(NOLOCK) 
                  WHERE  PROM_ID          = CONVERT(INT, @@CURRSTRING_ID)
                  AND    PROM_DELETED_IND = 1 
                  --                  
                  IF @@L_TEMP_ID <> 0
                  BEGIN --<>0
                  --
                    BEGIN TRANSACTION
                    --
                    INSERT INTO PRODUCT_MSTR_MAK
                    ( PROM_ID
                    , PROM_CD
                    , PROM_DESC
                    , PROM_RMKS
                    , PROM_EXCSM_ID
                    , PROM_CREATED_BY
                    , PROM_CREATED_DT
                    , PROM_LST_UPD_BY
                    , PROM_LST_UPD_DT
                    , PROM_DELETED_IND
                    )
                    VALUES
                    ( @@CURRSTRING_ID
                    , @PA_PROM_CD
                    , @PA_PROM_DESC
                    , @PA_PROM_RMKS
                    , @@L_EXCSM_ID
                    , @PA_LOGIN_NAME
                    , GETDATE()
                    , @PA_LOGIN_NAME
                    , GETDATE()
                    , 6
                    )
                    --
                    SET @@L_ERROR = @@ERROR
                    --
                    IF @@L_ERROR > 0
                    BEGIN--#1
                    --
                      SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
                      --
                      ROLLBACK TRANSACTION
                    --
                    END--#1
                    ELSE
                    BEGIN--#2
                    --
                      COMMIT TRANSACTION
                    --
                    END--#2
                  --
                  END --<>0
                  ELSE
                  BEGIN--=0
                  --
                    BEGIN TRANSACTION
                    --
                    UPDATE PRODUCT_MSTR_MAK    WITH(ROWLOCK)
                    SET    PROM_DELETED_IND  = 3
                         , PROM_LST_UPD_BY   = @PA_LOGIN_NAME
                         , PROM_LST_UPD_DT   = GETDATE()
                    WHERE  PROM_ID           = CONVERT(INT, @@CURRSTRING_ID)
                    AND    PROM_EXCSM_ID     = @@L_EXCSM_ID
                    AND    PROM_DELETED_IND  IN (0,4,6)
                    --
                    SET @@L_ERROR = @@ERROR
                    --
                    IF @@L_ERROR > 0
                    BEGIN--#1
                    --
                      SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
                      --
                      ROLLBACK TRANSACTION
                    --
                    END--#1
                    ELSE
                    BEGIN--#2
                    --
                      COMMIT TRANSACTION
                    --
                    END--#2
                  --
                  END--=0
                --
                END--FLAG=0
                ELSE
                BEGIN--FLAG=1
                --
                  BEGIN TRANSACTION
                  --
                  INSERT INTO PRODUCT_MSTR_MAK
                  (PROM_ID
                  ,PROM_CD
                  ,PROM_DESC
                  ,PROM_RMKS
                  ,PROM_EXCSM_ID
                  ,PROM_CREATED_BY
                  ,PROM_CREATED_DT
                  ,PROM_LST_UPD_BY
                  ,PROM_LST_UPD_DT
                  ,PROM_DELETED_IND
                  )
                  VALUES
                  (@PA_ID
                  ,@PA_PROM_CD
                  ,@PA_PROM_DESC
                  ,@PA_PROM_RMKS
                  ,@@L_EXCSM_ID
                  ,@PA_LOGIN_NAME
                  ,GETDATE()
                  ,@PA_LOGIN_NAME
                  ,GETDATE()
                  ,0
                  )
                  --
                  SET @@L_ERROR = @@ERROR
                  --
                  IF @@L_ERROR > 0
                  BEGIN--RINS
                  --
                    SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
                    --
                    ROLLBACK TRANSACTION
                  --
                  END--RINS
                  ELSE
                  BEGIN--CINS
                  --
                    COMMIT TRANSACTION
                  --
                  END--CINS
                --
                END--FLAG=1
              --
              END--CV
            --
            END--RV2
          --
          END--''1
          ELSE IF @PA_ACTION = 'DELMSTR'
          BEGIN--DELMSTR1
          --
            BEGIN TRANSACTION
            --
            UPDATE #PRODUCTMSTR
            SET    PROM_DELETED_IND = 4
            WHERE  PROM_ID          = CONVERT(INT, @@CURRSTRING_ID)
            AND    PROM_DELETED_IND = 1
            --
            INSERT INTO PRODUCT_MSTR_MAK
            ( PROM_ID
            , PROM_CD
            , PROM_DESC
            , PROM_RMKS
            , PROM_EXCSM_ID
            , PROM_CREATED_BY
            , PROM_CREATED_DT
            , PROM_LST_UPD_BY
            , PROM_LST_UPD_DT
            , PROM_DELETED_IND
            )
            SELECT PROM_ID
                 , PROM_CD
                 , PROM_DESC
                 , PROM_RMKS
                 , PROM_EXCSM_ID
                 , PROM_CREATED_BY
                 , PROM_CREATED_DT
                 , PROM_LST_UPD_BY
                 , PROM_LST_UPD_DT
                 , PROM_DELETED_IND
            FROM #PRODUCTMSTR
            WHERE PROM_ID = CONVERT(INT, @@CURRSTRING_ID)
            --
            SET @@L_ERROR = @@ERROR
            --
            IF @@L_ERROR > 0
            BEGIN--RINS
            --
              SET @@L_ERRORSTR = @COLDELIMITER + CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
              --
              ROLLBACK TRANSACTION
            --
            END--RINS
            ELSE
            BEGIN--CINS
            --
              COMMIT TRANSACTION
            --
            END--CINS
          --
          END--DELMSTR1
          ELSE IF @PA_ACTION = 'APP'
          BEGIN--APP1
          --
            SET @@L_PROM_ID   = CONVERT(NUMERIC,citrus_usr.FN_SPLITVAL(@@CURRSTRING_ID, 1))
            SET @@L_EXCSM_ID  = CONVERT(NUMERIC,citrus_usr.FN_SPLITVAL(@@CURRSTRING_ID, 2))
            --
            SELECT @@L_DELETED_IND = PROM_DELETED_IND
            FROM  PRODUCT_MSTR_MAK WITH(NOLOCK)
            WHERE PROM_ID       = @@L_PROM_ID
            AND   PROM_EXCSM_ID = @@L_EXCSM_ID
            AND PROM_DELETED_IND IN(0,4,6) 
            --
            IF @@L_DELETED_IND = 4
            BEGIN--IND=4
            --
              BEGIN TRANSACTION
              --
              UPDATE PRODUCT_MSTR_MAK    WITH(ROWLOCK)
              SET    PROM_DELETED_IND  = 5
                   , PROM_LST_UPD_BY   = @PA_LOGIN_NAME
                   , PROM_LST_UPD_DT   = GETDATE()
              WHERE  PROM_ID           = @@L_PROM_ID
              AND    PROM_EXCSM_ID     = @@L_EXCSM_ID
              AND    PROM_DELETED_IND  = 4
              --
              SET @@L_ERROR = @@ERROR
              --
              IF @@L_ERROR > 0
              BEGIN--RINS
              --
                SET @@L_ERRORSTR = @COLDELIMITER + CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
                --
                ROLLBACK TRANSACTION
              --
              END--RINS
              --
              UPDATE PRODUCT_MSTR        WITH(ROWLOCK)
              SET    PROM_DELETED_IND  = 0
                   , PROM_LST_UPD_BY   = @PA_LOGIN_NAME
                   , PROM_LST_UPD_DT   = GETDATE()
              WHERE  PROM_ID           = @@L_PROM_ID
              AND    PROM_DELETED_IND  = 1
              --
              SET @@L_ERROR = @@ERROR
              --
              IF @@L_ERROR > 0
              BEGIN--RINS
              --
                SET @@L_ERRORSTR = @COLDELIMITER + CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
                --
                ROLLBACK TRANSACTION
              --
              END--RINS
              --
              /*
              UPDATE EXCSM_PROD_MSTR  WITH(ROWLOCK)
              SET    EXCPM_DELETED_IND = 0
                   , EXCPM_LST_UPD_BY  = @PA_LOGIN_NAME
                   , EXCPM_LST_UPD_DT  = GETDATE()
              WHERE  EXCPM_PROM_ID     = @@L_PROM_ID
              AND    EXCPM_EXCSM_ID    = @@L_EXCSM_ID
              AND    EXCPM_DELETED_IND = 1
              */
              DELETE FROM EXCSM_PROD_MSTR
              WHERE  EXCPM_PROM_ID     = @@L_PROM_ID
              AND    EXCPM_EXCSM_ID    = @@L_EXCSM_ID
              AND    EXCPM_DELETED_IND = 1
              --
              SET @@L_ERROR = @@ERROR
              --
              IF @@L_ERROR > 0
              BEGIN--RINS
              --
                SET @@L_ERRORSTR = @COLDELIMITER + CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
                --
                ROLLBACK TRANSACTION
              --
              END--RINS
              --
              COMMIT TRANSACTION
             --
            END--IND=4
            ELSE IF @@L_DELETED_IND = 6
            BEGIN--IND=6
            --
              BEGIN TRANSACTION
              --
              UPDATE PRODUCT_MSTR_MAK    WITH(ROWLOCK)
              SET    PROM_DELETED_IND  = 7
                   , PROM_LST_UPD_BY   = @PA_LOGIN_NAME
                   , PROM_LST_UPD_DT   = GETDATE()
              WHERE  PROM_ID           = @@L_PROM_ID
              AND    PROM_EXCSM_ID     = @@L_EXCSM_ID
              AND    PROM_DELETED_IND  = 6
              --
              SET @@L_ERROR = @@ERROR
              --
              IF @@L_ERROR > 0
              BEGIN--RINS
              --
                SET @@L_ERRORSTR = @COLDELIMITER + CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
                --
                ROLLBACK TRANSACTION
              --
              END--RINS
              --
              /*
              UPDATE EXCSM_PROD_MSTR  WITH(ROWLOCK)
              SET    EXCPM_DELETED_IND = 0
                   , EXCPM_LST_UPD_BY  = @PA_LOGIN_NAME
                   , EXCPM_LST_UPD_DT  = GETDATE()
              WHERE  EXCPM_PROM_ID     = @@L_PROM_ID
              AND    EXCPM_EXCSM_ID    = @@L_EXCSM_ID
              AND    EXCPM_DELETED_IND = 1
              */
              DELETE FROM EXCSM_PROD_MSTR
              WHERE  EXCPM_PROM_ID     = @@L_PROM_ID
              AND    EXCPM_EXCSM_ID    = @@L_EXCSM_ID
              AND    EXCPM_DELETED_IND = 1 
              --
              SET @@L_ERROR = @@ERROR
              --
              IF @@L_ERROR > 0
              BEGIN--RINS
              --
                SET @@L_ERRORSTR = @COLDELIMITER + CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
                --
                ROLLBACK TRANSACTION
              --
              END--RINS
              --
              COMMIT TRANSACTION
            --
            END--IND=6
            ELSE IF EXISTS(SELECT PROM_ID 
                           FROM PRODUCT_MSTR WITH (NOLOCK) 
                           WHERE PROM_ID = @@L_PROM_ID AND PROM_DELETED_IND=1
                          )
            BEGIN--EXISTS
            --
              BEGIN TRANSACTION
              --
              UPDATE PROM                     WITH (ROWLOCK)
              SET    PROM.PROM_CD           = PROMM.PROM_CD
                   , PROM.PROM_DESC         = PROMM.PROM_DESC
                   , PROM.PROM_RMKS         = PROMM.PROM_RMKS
                   , PROM.PROM_LST_UPD_BY   = @PA_LOGIN_NAME
                   , PROM.PROM_LST_UPD_DT   = GETDATE()
              FROM   PRODUCT_MSTR             PROM
                   , PRODUCT_MSTR_MAK         PROMM
              WHERE  PROMM.PROM_ID          = @@L_PROM_ID
              AND    PROMM.PROM_EXCSM_ID    = @@L_EXCSM_ID
              AND    PROMM.PROM_ID          = PROM.PROM_ID
              AND    PROM.PROM_DELETED_IND  = 1
              AND    PROMM.PROM_DELETED_IND = 0
              AND    PROMM.PROM_CREATED_BY <> @PA_LOGIN_NAME
              --
              SET @@L_ERROR = @@ERROR
              --
              IF @@L_ERROR  > 0
              BEGIN
              --
                SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
                --
                ROLLBACK TRANSACTION
              --
              END
              --
              UPDATE PRODUCT_MSTR_MAK    WITH (ROWLOCK)
              SET    PROM_DELETED_IND  = 1
                    ,PROM_LST_UPD_BY   = @PA_LOGIN_NAME
                    ,PROM_LST_UPD_DT   = GETDATE()
              WHERE  PROM_ID           = @@L_PROM_ID
              AND    PROM_EXCSM_ID     = @@L_EXCSM_ID
              AND    PROM_CREATED_BY  <> @PA_LOGIN_NAME
              AND    PROM_DELETED_IND  = 0
              --
              SET @@L_ERROR = @@ERROR
              --
              IF @@L_ERROR  > 0
              BEGIN
              --
                SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
                --
                ROLLBACK TRANSACTION
              --
              END
              --
              IF EXISTS(SELECT *
                        FROM   EXCSM_PROD_MSTR     EXCPM WITH(NOLOCK)
                        WHERE  EXCPM.EXCPM_PROM_ID     = @@L_PROM_ID
                        AND    EXCPM.EXCPM_EXCSM_ID    = @@L_EXCSM_ID
                        AND    EXCPM.EXCPM_DELETED_IND = 1 )
              BEGIN
              --
                SET @@L_EXISTS = 1
              --
              END
              ELSE
              BEGIN
              --
                SET @@L_EXISTS = 0
              --
              END
              --
              IF @@L_EXISTS = 0
              BEGIN --@@L_EXISTS
              --
                SELECT @@L_EXCPM_ID = ISNULL(MAX(EXCPM_ID),0)+ 1
                FROM  EXCSM_PROD_MSTR WITH (NOLOCK)
                --
                INSERT INTO EXCSM_PROD_MSTR
                (EXCPM_ID
                ,EXCPM_EXCSM_ID
                ,EXCPM_PROM_ID
                ,EXCPM_CREATED_BY
                ,EXCPM_CREATED_DT
                ,EXCPM_LST_UPD_BY
                ,EXCPM_LST_UPD_DT
                ,EXCPM_DELETED_IND
                )
                VALUES
                (@@L_EXCPM_ID
                ,@@L_EXCSM_ID
                ,@@L_PROM_ID
                ,@PA_LOGIN_NAME
                ,GETDATE()
                ,@PA_LOGIN_NAME
                ,GETDATE()
                ,1
                )
                --
                SET @@L_ERROR = @@ERROR
                --
                IF @@L_ERROR  > 0
                BEGIN
                --
                  SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
                  --
                  ROLLBACK TRANSACTION
                --
                END
              --
              END--@@L_EXISTS
              --
              COMMIT TRANSACTION
            --
            END--EXISTS
            ELSE
            BEGIN--NOTEXISTS
            --
              BEGIN TRANSACTION
              --
              INSERT INTO PRODUCT_MSTR
              (PROM_ID
              ,PROM_CD
              ,PROM_DESC
              ,PROM_RMKS
              ,PROM_CREATED_BY
              ,PROM_CREATED_DT
              ,PROM_LST_UPD_BY
              ,PROM_LST_UPD_DT
              ,PROM_DELETED_IND
              )
              SELECT PROM_ID
                   , PROM_CD
                   , PROM_DESC
                   , PROM_RMKS
                   , PROM_CREATED_BY
                   , PROM_CREATED_DT
                   , PROM_LST_UPD_BY
                   , PROM_LST_UPD_DT
                   , 1
              FROM PRODUCT_MSTR_MAK PROMM  WITH(NOLOCK)
              WHERE PROMM.PROM_ID          =  @@L_PROM_ID
              AND   PROMM.PROM_EXCSM_ID    =  @@L_EXCSM_ID
              AND   PROMM.PROM_CREATED_BY  <> @PA_LOGIN_NAME
              AND   PROMM.PROM_DELETED_IND =  0
              --
              SET @@L_ERROR = @@ERROR
              --
              IF @@L_ERROR  > 0
              BEGIN
              --
                SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
                --
                ROLLBACK TRANSACTION
              --
              END
              --
              UPDATE PRODUCT_MSTR_MAK  WITH (ROWLOCK)
              SET    PROM_DELETED_IND  = 1
                   , PROM_LST_UPD_BY   = @PA_LOGIN_NAME
                   , PROM_LST_UPD_DT   = GETDATE()
              WHERE  PROM_ID           = @@L_PROM_ID
              AND    PROM_EXCSM_ID     = @@L_EXCSM_ID
              AND    PROM_CREATED_BY  <> @PA_LOGIN_NAME
              AND    PROM_DELETED_IND  = 0
              --
              SET @@L_ERROR = @@ERROR
              --
              IF @@L_ERROR  > 0
              BEGIN
              --
                SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
                --
                ROLLBACK TRANSACTION
              --
              END
              --
              SELECT @@L_EXCPM_ID = ISNULL(MAX(EXCPM_ID),0)+ 1
              FROM  EXCSM_PROD_MSTR WITH (NOLOCK)
              --
              INSERT INTO EXCSM_PROD_MSTR
              (EXCPM_ID
              ,EXCPM_EXCSM_ID
              ,EXCPM_PROM_ID
              ,EXCPM_CREATED_BY
              ,EXCPM_CREATED_DT
              ,EXCPM_LST_UPD_BY
              ,EXCPM_LST_UPD_DT
              ,EXCPM_DELETED_IND
              )
              VALUES
              (@@L_EXCPM_ID
              ,@@L_EXCSM_ID
              ,@@L_PROM_ID
              ,@PA_LOGIN_NAME
              ,GETDATE()
              ,@PA_LOGIN_NAME
              ,GETDATE()
              ,1
              )
              --
              SET @@L_ERROR = @@ERROR
              --
              IF @@L_ERROR  > 0
              BEGIN
              --
                SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
                --
                ROLLBACK TRANSACTION
              --
              END
              --
              COMMIT TRANSACTION
            --
            END--NOTEXISTS
          --
          END--APP1
          ELSE IF @PA_ACTION = 'REJ'
          BEGIN--REJ1
          --
            SET  @@L_PROM_ID   = CONVERT(NUMERIC,citrus_usr.FN_SPLITVAL(@@CURRSTRING_ID, 1))
            SET  @@L_EXCSM_ID  = CONVERT(NUMERIC,citrus_usr.FN_SPLITVAL(@@CURRSTRING_ID, 2))
            --
            BEGIN TRANSACTION
            --
            UPDATE PRODUCT_MSTR_MAK   WITH (ROWLOCK)
            SET    PROM_DELETED_IND = 3
                 , PROM_LST_UPD_BY  = @PA_LOGIN_NAME
                 , PROM_LST_UPD_DT  = GETDATE()
            WHERE  PROM_ID          = @@L_PROM_ID
            AND    PROM_EXCSM_ID    = @@L_EXCSM_ID
            AND    PROM_DELETED_IND IN (0,4,6)
            --
            SET @@L_ERROR = @@ERROR
            --
            IF @@L_ERROR > 0
            BEGIN
            --
              SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
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
          END--REJ1
          IF @PA_ACTION = 'EDT'
          BEGIN--EDT1
          --
            BEGIN TRANSACTION
            --
            UPDATE PRODUCT_MSTR_MAK   WITH (ROWLOCK)
            SET    PROM_DELETED_IND = 2
                 , PROM_LST_UPD_BY  = @PA_LOGIN_NAME
                 , PROM_LST_UPD_DT  = GETDATE()
            WHERE  PROM_ID          = @@CURRSTRING_ID
            AND    PROM_DELETED_IND = 0
            --
            SET @@L_ERROR = @@ERROR
            --
            IF @@L_ERROR > 0
            BEGIN
            --
              SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
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
            WHILE @@REMAININGSTRING_VAL <> ''
            BEGIN --RV1
            --
              SET @@FOUNDAT_VAL  = 0
              SET @@FOUNDAT_VAL  =  PATINDEX('%'+@@L_DELIMETER_ROW+'%', @@REMAININGSTRING_VAL)
              --
              IF @@FOUNDAT_VAL > 0
              BEGIN
              --
                SET @@CURRSTRING_VAL      = SUBSTRING(@@REMAININGSTRING_VAL, 0, @@FOUNDAT_VAL)
                SET @@REMAININGSTRING_VAL = SUBSTRING(@@REMAININGSTRING_VAL, @@FOUNDAT_VAL+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING_VAL)- @@FOUNDAT_VAL+@@DELIMETERLENGTH)
              --
              END
              ELSE
              BEGIN
              --
                SET @@CURRSTRING_VAL      = @@REMAININGSTRING_VAL
                SET @@REMAININGSTRING_VAL = ''
              --
              END
              --
              IF ISNULL(@@CURRSTRING_VAL,'') <> ''
              BEGIN --CV
              --
                SET @@L_EXCSM_ID = CONVERT(NUMERIC, citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL, 1))
                SET @@L_DEL_FLAG = CONVERT(NUMERIC, citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL, 2))
                --
                BEGIN TRANSACTION
                --
                INSERT INTO PRODUCT_MSTR_MAK
                (PROM_ID
                ,PROM_CD
                ,PROM_DESC
                ,PROM_RMKS
                ,PROM_EXCSM_ID
                ,PROM_CREATED_BY
                ,PROM_CREATED_DT
                ,PROM_LST_UPD_BY
                ,PROM_LST_UPD_DT
                ,PROM_DELETED_IND
                )
                VALUES
                (@@CURRSTRING_ID
                ,@PA_PROM_CD
                ,@PA_PROM_DESC
                ,@PA_PROM_RMKS
                ,@@L_EXCSM_ID
                ,@PA_LOGIN_NAME
                ,GETDATE()
                ,@PA_LOGIN_NAME
                ,GETDATE()
                ,0
                )
                --
                SET @@L_ERROR = @@ERROR
                --
                IF @@L_ERROR > 0
                BEGIN
                --
                  SET @@L_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
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
              END--CV
            --
            END--RV1
          --
          END--EDT1
        --
        END--PA_CHK_YN=1
    --
    END--CID
 --
 END  --#01
 --
 IF ISNULL(RTRIM(LTRIM(@@L_ERRORSTR)),'') = ''
 BEGIN
 --
   SET @@L_ERRORSTR = 'Product Successfully Inserted\Edited '+ @ROWDELIMITER
 --
 END
 ELSE
 BEGIN
 --
   SET @PA_ERRMSG = @@L_ERRORSTR
 --
 END
--
END --MAIN BEGIN

GO
