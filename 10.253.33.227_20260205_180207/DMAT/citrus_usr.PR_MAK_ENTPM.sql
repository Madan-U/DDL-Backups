-- Object: PROCEDURE citrus_usr.PR_MAK_ENTPM
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_MAK_ENTPM] (@PA_ID             VARCHAR(8000)
                             ,@PA_ACTION         VARCHAR(20)
                             ,@PA_LOGIN_NAME     VARCHAR(20)
                             ,@PA_ENTPM_PROP_ID  INT
                             ,@PA_ENTPM_CD       VARCHAR(200)
                             ,@PA_ENTPM_DESC     VARCHAR(8000)
                             ,@PA_ENTPM_CLI_YN   INT
                             ,@PA_ENTPM_RMKS     VARCHAR(200)
                             ,@PA_ENTPM_DATATYPE VARCHAR(5)
                             ,@PA_VALUES         VARCHAR(8000)
                             ,@PA_CHK_YN         INT
                             ,@ROWDELIMITER      CHAR(4)
                             ,@COLDELIMITER      CHAR(4)
                             ,@PA_ERRMSG         VARCHAR(8000) OUTPUT
 )
AS
/*
*********************************************************************************
 SYSTEM         : CLASS
 MODULE NAME    : PR_MAK_ENTPM
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE MAKER CHECKER FACILITY FOR ENTITY_PROPERTY_MSTR
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.
 VERSION HISTORY: 
 VERS.  AUTHOR            DATE         REASON
 -----  -------------     ----------   -------------------------------------------------
 2.0    SUKHVINDER/TUSHAR 23-FEB-2007  CHANGES IN TABLE
-----------------------------------------------------------------------------------*/
--
BEGIN
--
  SET NOCOUNT ON
  --
  DECLARE @@REMAININGSTRING_VAL VARCHAR(8000)
        , @@CURRSTRING_VAL      VARCHAR(8000)
        , @@FOUNDAT_VAL         INT
        , @@REMAININGSTRING_ID  VARCHAR(8000)
        , @@CURRSTRING_ID       VARCHAR(8000)
        , @@FOUNDAT_ID          INT
        , @@DELIMETERLENGTH     INT
        , @L_ERRORSTR           VARCHAR(8000)
        , @L_SENTPM_ID          NUMERIC
        , @L_ENTPM_ID           NUMERIC
        , @L_ENTPMM_ID          NUMERIC
        , @L_ENTPM_PROP_ID      NUMERIC
        , @L_ENTPM_PROP_ID_MAK  NUMERIC
        , @L_DELIMETER          VARCHAR(10)
        , @L_EXCH_CD            VARCHAR(25)
        , @L_SEG_CD             VARCHAR(25)
        , @L_EXCSM_EXCH_CD      VARCHAR(25)
        , @L_EXCSM_SEG_CD       VARCHAR(25)
        , @L_PROM_DESC          VARCHAR(100)
        , @L_PROM_ID            NUMERIC
        , @L_ENTTM_ID           NUMERIC
        , @L_CLICM_ID           NUMERIC
        , @L_MND_FLG            SMALLINT
        , @L_EXCPM_ID           NUMERIC
        , @L_ERROR              BIGINT
        , @L_NODE               CHAR(5)
        , @L_EXISTS             NUMERIC
        , @L_DELETED_IND        SMALLINT
   --
  IF @PA_CHK_YN = 1
  BEGIN--#TABLE
  --
    IF @PA_ACTION <> 'APP' AND @PA_ACTION <> 'REJ'
    BEGIN --ACTIONS
    --
      CREATE TABLE #T_ENTPMM
      (ENTPM_ID          NUMERIC
      ,ENTPM_PROP_ID     NUMERIC
      ,ENTPM_CLICM_ID    NUMERIC
      ,ENTPM_ENTTM_ID    NUMERIC
      ,ENTPM_EXCPM_ID    CHAR (10)
      ,ENTPM_MDTY        SMALLINT
      ,ENTPM_CD          VARCHAR(20)
      ,ENTPM_DESC        VARCHAR(100)
      ,ENTPM_CLI_YN      INT 
      ,ENTPM_RMKS        VARCHAR(250)
      ,ENTPM_CREATED_BY  VARCHAR(25)
      ,ENTPM_CREATED_DT  DATETIME 
      ,ENTPM_LST_UPD_BY  VARCHAR(25)
      ,ENTPM_LST_UPD_DT  DATETIME
      ,ENTPM_DELETED_IND SMALLINT
      ,ENTPM_DATATYPE    VARCHAR(5) 
      ) 
      --
      INSERT INTO #T_ENTPMM
      (ENTPM_ID         
      ,ENTPM_PROP_ID
      ,ENTPM_CLICM_ID
      ,ENTPM_ENTTM_ID  
      ,ENTPM_EXCPM_ID 
      ,ENTPM_MDTY  
      ,ENTPM_CD   
      ,ENTPM_DESC   
      ,ENTPM_CLI_YN 
      ,ENTPM_RMKS     
      ,ENTPM_CREATED_BY
      ,ENTPM_CREATED_DT
      ,ENTPM_LST_UPD_BY 
      ,ENTPM_LST_UPD_DT 
      ,ENTPM_DELETED_IND
      ,ENTPM_DATATYPE 
      )
      SELECT ENTPM_ID        
           , ENTPM_PROP_ID   
           , ENTPM_CLICM_ID  
           , ENTPM_ENTTM_ID  
           , ENTPM_EXCPM_ID  
           , ENTPM_MDTY      
           , ENTPM_CD        
           , ENTPM_DESC      
           , ENTPM_CLI_YN    
           , ENTPM_RMKS      
           , ENTPM_CREATED_BY  
           , ENTPM_CREATED_DT  
           , ENTPM_LST_UPD_BY  
           , ENTPM_LST_UPD_DT  
           , ENTPM_DELETED_IND
           , ENTPM_DATATYPE 
      FROM   ENTITY_PROPERTY_MSTR_MAK WITH(NOLOCK)   
      WHERE  ENTPM_DELETED_IND = 0
      AND    ENTPM_PROP_ID     = @PA_ENTPM_PROP_ID     
      --
      CREATE TABLE #T_ENTPM
      (ENTPM_ID            NUMERIC
      ,ENTPM_PROP_ID       NUMERIC
      ,ENTPM_CLICM_ID      NUMERIC
      ,ENTPM_ENTTM_ID      NUMERIC
      ,ENTPM_EXCPM_ID      NUMERIC
      ,ENTPM_CD            VARCHAR(20)
      ,ENTPM_DESC          VARCHAR(100)
      ,ENTPM_CLI_YN        INT
      ,ENTPM_RMKS          VARCHAR(250)
      ,ENTPM_MDTY          SMALLINT
      ,ENTPM_CREATED_BY    VARCHAR(25)
      ,ENTPM_CREATED_DT    DATETIME
      ,ENTPM_LST_UPD_BY    VARCHAR(25)
      ,ENTPM_LST_UPD_DT    VARCHAR(25)
      ,ENTPM_DELETED_IND   SMALLINT
      ,ENTPM_DATATYPE      VARCHAR(5) 
      )
      --
      INSERT INTO #T_ENTPM
      (ENTPM_ID
      ,ENTPM_PROP_ID
      ,ENTPM_CLICM_ID
      ,ENTPM_ENTTM_ID
      ,ENTPM_EXCPM_ID
      ,ENTPM_CD
      ,ENTPM_DESC
      ,ENTPM_CLI_YN
      ,ENTPM_RMKS
      ,ENTPM_MDTY
      ,ENTPM_CREATED_BY
      ,ENTPM_CREATED_DT
      ,ENTPM_LST_UPD_BY
      ,ENTPM_LST_UPD_DT
      ,ENTPM_DELETED_IND
      ,ENTPM_DATATYPE 
      )
      SELECT ENTPM_ID
           , ENTPM_PROP_ID
           , ENTPM_CLICM_ID
           , ENTPM_ENTTM_ID
           , ENTPM_EXCPM_ID
           , ENTPM_CD
           , ENTPM_DESC
           , ENTPM_CLI_YN
           , ENTPM_RMKS
           , ENTPM_MDTY
           , ENTPM_CREATED_BY
           , ENTPM_CREATED_DT
           , ENTPM_LST_UPD_BY
           , ENTPM_LST_UPD_DT
           , ENTPM_DELETED_IND
           , ENTPM_DATATYPE  
      FROM   ENTITY_PROPERTY_MSTR WITH(NOLOCK)
      WHERE  ENTPM_DELETED_IND  = 1
      AND    ENTPM_PROP_ID      = @PA_ENTPM_PROP_ID
    --  
    END--ACTIONS  
  --
  END--#TABLE
  --
  SET @L_ERROR             = 0
  SET @L_ERRORSTR          = ''
  SET @L_DELIMETER         = '%'+ @ROWDELIMITER + '%'
  SET @@DELIMETERLENGTH    = LEN(@ROWDELIMITER)
  SET @@REMAININGSTRING_ID = @PA_ID
  SET @L_ENTPM_PROP_ID     = 0
  --
  WHILE @@REMAININGSTRING_ID <> ''
  BEGIN--RVID
  --
    SET @@FOUNDAT_ID  = 0
    SET @@FOUNDAT_ID  = PATINDEX('%'+@L_DELIMETER+'%', @@REMAININGSTRING_ID)
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
    BEGIN--CID
    --
      IF @PA_CHK_YN = 0
      BEGIN--CHK0
      --
        IF @PA_ACTION = 'EDTMSTR'
        BEGIN--EDTMSTR0
        --
          BEGIN TRANSACTION
          --
          UPDATE ENTITY_PROPERTY_MSTR WITH(ROWLOCK)
          SET    ENTPM_CD          = @PA_ENTPM_CD
               , ENTPM_DESC        = @PA_ENTPM_DESC
               , ENTPM_RMKS        = @PA_ENTPM_RMKS
               , ENTPM_DATATYPE    = @PA_ENTPM_DATATYPE
          WHERE  ENTPM_PROP_ID     = @PA_ENTPM_PROP_ID
          AND    ENTPM_DELETED_IND = 1
          --
          SET @L_ERROR = @@ERROR
          --
          IF @L_ERROR > 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            SET @L_ERRORSTR = CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
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
        ELSE IF @PA_ACTION = 'DELMSTR'
        BEGIN--DELMSTR0
        --
          BEGIN TRANSACTION
          --
          UPDATE ENTITY_PROPERTY_MSTR WITH(ROWLOCK)
          SET    ENTPM_DELETED_IND  = 0
               , ENTPM_LST_UPD_BY   = @PA_LOGIN_NAME
               , ENTPM_LST_UPD_DT   = GETDATE()
          WHERE  ENTPM_PROP_ID      = CONVERT(NUMERIC, @@CURRSTRING_ID)
          AND    ENTPM_DELETED_IND  = 1
          --
          SET @L_ERROR = @@ERROR
          --
          IF @L_ERROR > 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            SET @L_ERRORSTR = CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
          --
          END
          ELSE
          BEGIN
          --
            COMMIT TRANSACTION
          --
          END
        --
        END--DELMSTR0
        ELSE IF ISNULL(RTRIM(LTRIM(@PA_ACTION)),'') = ''
        BEGIN--ISNULL0
        --
          SET @@REMAININGSTRING_VAL = @PA_VALUES
          --
          WHILE @@REMAININGSTRING_VAL <> ''
          BEGIN--RV2
          --
            SET @@FOUNDAT_VAL  = 0
            SET @@FOUNDAT_VAL  =  PATINDEX('%'+@L_DELIMETER+'%', @@REMAININGSTRING_VAL)
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
            IF @@CURRSTRING_VAL <> ''
            BEGIN--CID2
            --
              SET @L_EXCH_CD  = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,1)
              SET @L_SEG_CD   = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,2)
              SET @L_PROM_ID  = CONVERT(NUMERIC, citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,3))
              SET @L_ENTTM_ID = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,4)
              SET @L_CLICM_ID = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,5)
              SET @L_NODE     = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,6)
              SET @L_MND_FLG  = CASE citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,7) WHEN 'M' THEN 1 WHEN 'N'THEN 0 ELSE 2 END
              --
              SELECT TOP 1 @L_EXCPM_ID     = EXCPM.EXCPM_ID
              FROM  EXCH_SEG_MSTR EXCSM    WITH(NOLOCK)
                  , EXCSM_PROD_MSTR EXCPM  WITH(NOLOCK)
              WHERE EXCPM.EXCPM_EXCSM_ID   = EXCSM.EXCSM_ID
              AND   EXCSM.EXCSM_EXCH_CD    = @L_EXCH_CD
              AND   EXCSM.EXCSM_SEG_CD     = @L_SEG_CD
              AND   EXCPM.EXCPM_PROM_ID    = @L_PROM_ID
              AND   EXCSM_DELETED_IND      = 1
              AND   EXCPM_DELETED_IND      = 1
              --
              IF @L_MND_FLG = 1 OR @L_MND_FLG = 0
              BEGIN--FLG=1/0
              --
                IF ISNULL(@PA_ENTPM_CD,'') <> ''
                BEGIN--CD
                --
                  SELECT @L_ENTPM_PROP_ID = ISNULL(ENTPMM.ENTPM_PROP_ID,0)
                  FROM   ENTITY_PROPERTY_MSTR_MAK ENTPMM WITH(NOLOCK)
                  WHERE  ENTPMM.ENTPM_CD  = @PA_ENTPM_CD
                  AND    ENTPMM.ENTPM_DELETED_IND IN (1,0)
                  --
                  IF @L_ENTPM_PROP_ID = 0
                  BEGIN--#111
                  --
                    SELECT @L_ENTPM_PROP_ID     = ISNULL(MAX(ENTPM.ENTPM_PROP_ID), 0)
                    FROM   ENTITY_PROPERTY_MSTR   ENTPM WITH(NOLOCK)
                    WHERE  ENTPM.ENTPM_CD       = @PA_ENTPM_CD
                    AND    ENTPM.ENTPM_DELETED_IND IN (0,1)
                  --
                  END--#111
                  --
                  IF @L_ENTPM_PROP_ID = 0
                  BEGIN--#222
                  --
                    SELECT @L_ENTPM_PROP_ID_MAK = ISNULL(MAX(ENTPMM.ENTPM_PROP_ID), 0) + 1
                    FROM   ENTITY_PROPERTY_MSTR_MAK  ENTPMM WITH(NOLOCK)
                    --
                    SELECT @L_ENTPM_PROP_ID = ISNULL(MAX(ENTPM.ENTPM_PROP_ID), 0) + 1
                    FROM   ENTITY_PROPERTY_MSTR  ENTPM  WITH(NOLOCK)
                    --
                    IF @L_ENTPM_PROP_ID_MAK > @L_ENTPM_PROP_ID
                    BEGIN
                    --
                      SET @L_ENTPM_PROP_ID = @L_ENTPM_PROP_ID_MAK
                    --
                    END
                    --
                  END--#222
                  --
                  IF EXISTS(SELECT * FROM ENTITY_PROPERTY_MSTR ENTPM WITH (NOLOCK)
                            WHERE ENTPM.ENTPM_PROP_ID     = @L_ENTPM_PROP_ID
                            AND   ENTPM.ENTPM_CLICM_ID    = @L_CLICM_ID
                            AND   ENTPM.ENTPM_ENTTM_ID    = @L_ENTTM_ID
                            AND   ENTPM.ENTPM_EXCPM_ID    = @L_EXCPM_ID
                            )
                  BEGIN--A
                  --
                    SET @L_EXISTS = 1
                  --
                  END--A
                  ELSE
                  BEGIN--B
                  --
                    SET @L_EXISTS = 0
                  --
                  END--B
                  --
                  IF @L_EXISTS = 0
                  BEGIN--#0
                  --
                    SELECT @L_ENTPM_ID = ISNULL(MAX(ENTPM_ID),0)+1
                    FROM ENTITY_PROPERTY_MSTR WITH(NOLOCK)
                    --
                    BEGIN TRANSACTION
                    --
                    INSERT INTO ENTITY_PROPERTY_MSTR
                    (ENTPM_ID
                    ,ENTPM_PROP_ID
                    ,ENTPM_CLICM_ID
                    ,ENTPM_ENTTM_ID
                    ,ENTPM_EXCPM_ID
                    ,ENTPM_CD
                    ,ENTPM_DESC
                    ,ENTPM_RMKS
                    ,ENTPM_CLI_YN
                    ,ENTPM_CREATED_BY
                    ,ENTPM_CREATED_DT
                    ,ENTPM_LST_UPD_BY
                    ,ENTPM_LST_UPD_DT
                    ,ENTPM_DELETED_IND
                    ,ENTPM_MDTY
                    ,ENTPM_DATATYPE
                    )
                    VALUES
                    (@L_ENTPM_ID
                    ,@L_ENTPM_PROP_ID
                    ,@L_CLICM_ID
                    ,@L_ENTTM_ID
                    ,@L_EXCPM_ID
                    ,@PA_ENTPM_CD
                    ,@PA_ENTPM_DESC
                    ,@PA_ENTPM_RMKS
                    ,@PA_ENTPM_CLI_YN
                    ,@PA_LOGIN_NAME
                    ,GETDATE()
                    ,@PA_LOGIN_NAME
                    ,GETDATE()
                    ,1
                    ,@L_MND_FLG
                    ,@PA_ENTPM_DATATYPE
                    )
                    --
                    SET @L_ERROR = @@ERROR
                    --
                    IF @L_ERROR > 0
                    BEGIN
                    --
                      ROLLBACK TRANSACTION
                    --
                      SET @L_ERRORSTR = CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
                    --
                    END
                    ELSE
                    BEGIN
                    --
                      COMMIT TRANSACTION
                    --
                    END
                  --
                  END --#0
                  IF @L_EXISTS = 1
                  BEGIN--#1
                  --
                    BEGIN TRANSACTION
                    --
                    UPDATE ENTITY_PROPERTY_MSTR   WITH(ROWLOCK)
                    SET    ENTPM_CD            = UPPER(@PA_ENTPM_CD)
                         , ENTPM_DESC          = @PA_ENTPM_DESC
                         , ENTPM_RMKS          = @PA_ENTPM_RMKS
                         , ENTPM_MDTY          = @L_MND_FLG
                         , ENTPM_DATATYPE      = @PA_ENTPM_DATATYPE
                         , ENTPM_LST_UPD_BY    = @PA_LOGIN_NAME
                         , ENTPM_LST_UPD_DT    = GETDATE()
                         , ENTPM_DELETED_IND   = 1
                    WHERE  ENTPM_PROP_ID       = @PA_ENTPM_PROP_ID
                    AND    ENTPM_CLICM_ID      = @L_CLICM_ID
                    AND    ENTPM_ENTTM_ID      = @L_ENTTM_ID
                    AND    ENTPM_EXCPM_ID      = @L_EXCPM_ID
                    AND    ENTPM_DELETED_IND   = 1
                    --
                    SET @L_ERROR = @@ERROR
                    --
                    IF @L_ERROR > 0
                    BEGIN
                    --
                      ROLLBACK TRANSACTION
                    --
                      SET @L_ERRORSTR = CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
                    END
                    ELSE
                    BEGIN
                    --
                      COMMIT TRANSACTION
                    --
                    END
                  --
                  END--#1
                --
                END --CD
                ELSE
                BEGIN
                --
                  SET @L_ERRORSTR = 'ONE OR ALL OF THE PARAMETERS IS/ARE NULL'
                --
                END
              --
              END--FLG=1/0
              ELSE IF @L_MND_FLG=2
              BEGIN--FLG=2
              --
                /*IF EXISTS(SELECT *
                          FROM  ENTITY_PROPERTY_MSTR   ENTPM
                          WHERE ENTPM.ENTPM_PROP_ID     = @PA_ENTPM_PROP_ID
                          AND   ENTPM.ENTPM_CLICM_ID    = @L_CLICM_ID
                          AND   ENTPM.ENTPM_ENTTM_ID    = @L_ENTTM_ID
                          AND   ENTPM.ENTPM_EXCPM_ID    = @L_EXCPM_ID
                          AND   ENTPM.ENTPM_DELETED_IND = 1)
                BEGIN--EXISTS*/
                --
                  BEGIN TRANSACTION
                  --
                  UPDATE ENTITY_PROPERTY_MSTR  WITH(ROWLOCK)
                  SET    ENTPM_DELETED_IND  = 0
                       , ENTPM_LST_UPD_BY   = @PA_LOGIN_NAME
                       , ENTPM_LST_UPD_DT   = GETDATE()
                  WHERE  ENTPM_PROP_ID      = @PA_ENTPM_PROP_ID
                  AND    ENTPM_CLICM_ID     = @L_CLICM_ID
                  AND    ENTPM_ENTTM_ID     = @L_ENTTM_ID
                  AND    ENTPM_EXCPM_ID     = @L_EXCPM_ID
                  AND    ENTPM_DELETED_IND  = 1
                  --
                  SET @L_ERROR = @@ERROR
                  --
                  IF @L_ERROR > 0
                  BEGIN
                  --
                    ROLLBACK TRANSACTION
                  --
                    SET @L_ERRORSTR = CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
                  --
                  END
                  ELSE
                  BEGIN
                  --
                    COMMIT TRANSACTION
                  --
                  END
                --
                /*END--EXISTS
                ELSE
                BEGIN--NOTEXISTS
                --
                  SET @L_ERRORSTR = 'ONE OR ALL OF THE PARAMETERS IS/ARE NULL'
                --
                END--NOTEXISTS*/
              --
              END--FLG=2
            --
            END--CID2
          --
          END--RV2
        --
        END--ISNULL0
      --
      END--CHK=0
      ELSE
      BEGIN--CHK=1
      ----
        IF @PA_ACTION = 'EDTMSTR'
        BEGIN--EDTMSTR
        --
          BEGIN TRANSACTION
          --
          UPDATE ENTITY_PROPERTY_MSTR_MAK  WITH (ROWLOCK)
          SET    ENTPM_DELETED_IND = 2
               , ENTPM_LST_UPD_BY  = @PA_LOGIN_NAME
               , ENTPM_LST_UPD_DT  = GETDATE()
          WHERE  ENTPM_PROP_ID     = @PA_ENTPM_PROP_ID
          AND    ENTPM_DELETED_IND = 0
          --
          UPDATE #T_ENTPMM
          SET    ENTPM_CD       = @PA_ENTPM_CD
               , ENTPM_DESC     = @PA_ENTPM_DESC
               , ENTPM_RMKS     = @PA_ENTPM_RMKS
               , ENTPM_DATATYPE = @PA_ENTPM_DATATYPE
          WHERE  ENTPM_PROP_ID  = @PA_ENTPM_PROP_ID
          --
          INSERT INTO ENTITY_PROPERTY_MSTR_MAK
          (ENTPM_ID
          ,ENTPM_PROP_ID
          ,ENTPM_CLICM_ID
          ,ENTPM_ENTTM_ID
          ,ENTPM_EXCPM_ID
          ,ENTPM_CD
          ,ENTPM_DESC
          ,ENTPM_CLI_YN
          ,ENTPM_RMKS
          ,ENTPM_MDTY
          ,ENTPM_CREATED_BY
          ,ENTPM_CREATED_DT
          ,ENTPM_LST_UPD_BY
          ,ENTPM_LST_UPD_DT
          ,ENTPM_DELETED_IND
          ,ENTPM_DATATYPE
          )
          SELECT ENTPM_ID
                ,ENTPM_PROP_ID
                ,ENTPM_CLICM_ID
                ,ENTPM_ENTTM_ID
                ,ENTPM_EXCPM_ID
                ,ENTPM_CD
                ,ENTPM_DESC
                ,ENTPM_CLI_YN
                ,ENTPM_RMKS
                ,ENTPM_MDTY
                ,ENTPM_CREATED_BY
                ,ENTPM_CREATED_DT
                ,ENTPM_LST_UPD_BY
                ,ENTPM_LST_UPD_DT
                ,ENTPM_DELETED_IND
                ,ENTPM_DATATYPE 
          FROM   #T_ENTPMM
          WHERE  ENTPM_PROP_ID = @PA_ENTPM_PROP_ID
          --
          SET @L_ERROR = @@ERROR
          --
          IF @L_ERROR> 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            SET @L_ERRORSTR = CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
          --
          END
          ELSE
          BEGIN
          --
            COMMIT TRANSACTION
          --
          END
        --
        END--EDTMSTR
        ELSE IF @PA_ACTION = 'DELMSTR'
        BEGIN--DELMSTR1
        --
          BEGIN TRANSACTION
          --
          UPDATE #T_ENTPM
          SET    ENTPM_DELETED_IND = 4
          WHERE  ENTPM_ID          = CONVERT(NUMERIC, @@CURRSTRING_ID)
          AND    ENTPM_DELETED_IND = 1
          --
          INSERT INTO ENTITY_PROPERTY_MSTR_MAK
          (ENTPM_ID         
          ,ENTPM_PROP_ID 
          ,ENTPM_CLICM_ID
          ,ENTPM_ENTTM_ID 
          ,ENTPM_EXCPM_ID 
          ,ENTPM_MDTY 
          ,ENTPM_CD 
          ,ENTPM_DESC  
          ,ENTPM_CLI_YN 
          ,ENTPM_RMKS 
          ,ENTPM_CREATED_BY 
          ,ENTPM_CREATED_DT 
          ,ENTPM_LST_UPD_BY
          ,ENTPM_LST_UPD_DT
          ,ENTPM_DELETED_IND
          ,ENTPM_DATATYPE 
          )
          SELECT ENTPM_ID        
               , ENTPM_PROP_ID   
               , ENTPM_CLICM_ID  
               , ENTPM_ENTTM_ID  
               , ENTPM_EXCPM_ID  
               , ENTPM_MDTY      
               , ENTPM_CD        
               , ENTPM_DESC      
               , ENTPM_CLI_YN    
               , ENTPM_RMKS      
               , ENTPM_CREATED_BY  
               , ENTPM_CREATED_DT  
               , ENTPM_LST_UPD_BY  
               , ENTPM_LST_UPD_DT  
               , ENTPM_DELETED_IND
               , ENTPM_DATATYPE 
          FROM   #T_ENTPMM   
          WHERE  ENTPM_PROP_ID     = CONVERT(NUMERIC, @@CURRSTRING_ID)
          --
          SET @L_ERROR = @@ERROR
          --
          IF @L_ERROR> 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            SET @L_ERRORSTR = CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
          --
          END
          ELSE
          BEGIN
          --
            COMMIT TRANSACTION
          --
          END
        --
        END--DELMSTR1
        ELSE IF @PA_ACTION = 'REJ'
        BEGIN--REJ
        --
          BEGIN TRANSACTION
          --
          UPDATE ENTITY_PROPERTY_MSTR_MAK  WITH (ROWLOCK)
          SET    ENTPM_DELETED_IND = 3
               , ENTPM_LST_UPD_BY  = @PA_LOGIN_NAME
               , ENTPM_LST_UPD_DT  = GETDATE()
          WHERE  ENTPM_ID          = CONVERT(NUMERIC, @@CURRSTRING_ID)
          AND    ENTPM_DELETED_IND IN (0,4,6)
          --
          SET @L_ERROR = @@ERROR
          --
          IF @L_ERROR > 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            SET @L_ERRORSTR = CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
          --
          END
          ELSE
          BEGIN
          --
            COMMIT TRANSACTION
          --
          END
        --
        END--REJ
        ELSE IF @PA_ACTION = 'APP'
        BEGIN--APP
        --
          SELECT @L_DELETED_IND = ENTPM_DELETED_IND
          FROM  ENTITY_PROPERTY_MSTR_MAK WITH(NOLOCK)
          WHERE ENTPM_ID        = CONVERT(NUMERIC, @@CURRSTRING_ID)
          --
          IF @L_DELETED_IND = 4
          BEGIN--IND=4
          --
            BEGIN TRANSACTION
            --
            UPDATE ENTITY_PROPERTY_MSTR_MAK  WITH(ROWLOCK)
            SET    ENTPM_DELETED_IND  = 5
                 , ENTPM_LST_UPD_BY   = @PA_LOGIN_NAME
                 , ENTPM_LST_UPD_DT   = GETDATE()
            WHERE  ENTPM_ID           = CONVERT(NUMERIC, @@CURRSTRING_ID)
            AND    ENTPM_DELETED_IND  = 4
            --
            SET @L_ERROR = @@ERROR
            --
            IF @L_ERROR > 0
            BEGIN--RINS
            --
              SET @L_ERRORSTR = @COLDELIMITER + CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
              --
              ROLLBACK TRANSACTION
              --
              RETURN
            --
            END--RINS
            --
            UPDATE ENTITY_PROPERTY_MSTR   WITH(ROWLOCK)
            SET    ENTPM_DELETED_IND  = 0
                 , ENTPM_LST_UPD_BY   = @PA_LOGIN_NAME
                 , ENTPM_LST_UPD_DT   = GETDATE()
            WHERE  ENTPM_ID           = CONVERT(NUMERIC, @@CURRSTRING_ID)
            AND    ENTPM_DELETED_IND  = 1
            --
            SET @L_ERROR = @@ERROR
            --
            IF @L_ERROR > 0
            BEGIN--RINS
            --
              SET @L_ERRORSTR = @COLDELIMITER + CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
              --
              ROLLBACK TRANSACTION
              --
              RETURN
            --
            END--RINS
            --
            COMMIT TRANSACTION
            --
          END--IND=4
          ELSE IF @L_DELETED_IND = 6
          BEGIN--IND=6
          --
            BEGIN TRANSACTION
            --
            UPDATE ENTITY_PROPERTY_MSTR_MAK WITH(ROWLOCK)
            SET    ENTPM_DELETED_IND  = 7
                 , ENTPM_LST_UPD_BY   = @PA_LOGIN_NAME
                 , ENTPM_LST_UPD_DT   = GETDATE()
            WHERE  ENTPM_ID           = CONVERT(NUMERIC, @@CURRSTRING_ID)
            AND    ENTPM_DELETED_IND  = 6
            --
            UPDATE ENTITY_PROPERTY_MSTR  WITH(ROWLOCK)
            SET    ENTPM_DELETED_IND  = 0
                 , ENTPM_LST_UPD_BY   = @PA_LOGIN_NAME
                 , ENTPM_LST_UPD_DT   = GETDATE()
            WHERE  ENTPM_PROP_ID      = @PA_ENTPM_PROP_ID
            AND    ENTPM_DELETED_IND  = 1
            --
            SET @L_ERROR = @@ERROR
            --
            IF @L_ERROR > 0
            BEGIN--RINS
            --
              SET @L_ERRORSTR = @COLDELIMITER + CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
              --
              ROLLBACK TRANSACTION
              --
              RETURN
            --
            END--RINS
            --
            COMMIT TRANSACTION
          --
          END--IND=6 
          --
          IF EXISTS(SELECT ENTPM_ID
                    FROM ENTITY_PROPERTY_MSTR  WITH(NOLOCK)
                    WHERE ENTPM_ID=CONVERT(NUMERIC, @@CURRSTRING_ID))
          BEGIN--#EXIST
          --
            BEGIN TRANSACTION
            --
            UPDATE ENTPM WITH(ROWLOCK)
            SET    ENTPM.ENTPM_PROP_ID        = ENTPMM.ENTPM_PROP_ID
                 , ENTPM.ENTPM_CD             = ENTPMM.ENTPM_CD
                 , ENTPM.ENTPM_DESC           = ENTPMM.ENTPM_DESC
                 , ENTPM.ENTPM_RMKS           = ENTPMM.ENTPM_RMKS
                 , ENTPM.ENTPM_MDTY           = ENTPMM.ENTPM_MDTY
                 , ENTPM.ENTPM_DATATYPE       = ENTPMM.ENTPM_DATATYPE
                 , ENTPM.ENTPM_LST_UPD_BY     = @PA_LOGIN_NAME
                 , ENTPM.ENTPM_LST_UPD_DT     = GETDATE()
                 , ENTPM.ENTPM_DELETED_IND    = 1
            FROM   ENTITY_PROPERTY_MSTR       ENTPM
                 , ENTITY_PROPERTY_MSTR_MAK   ENTPMM
            WHERE  ENTPM.ENTPM_ID             = CONVERT(NUMERIC, @@CURRSTRING_ID)
            AND    ENTPM.ENTPM_DELETED_IND    = 1
            AND    ENTPMM.ENTPM_DELETED_IND   = 0
            AND    ENTPMM.ENTPM_CREATED_BY   <> @PA_LOGIN_NAME
            --
            UPDATE ENTITY_PROPERTY_MSTR_MAK  WITH(ROWLOCK)
            SET    ENTPM_DELETED_IND          = 1
                 , ENTPM_LST_UPD_BY           = @PA_LOGIN_NAME
                 , ENTPM_LST_UPD_DT           = GETDATE()
            WHERE  ENTPM_ID                   = CONVERT(INT, @@CURRSTRING_ID)
            AND    ENTPM_CREATED_BY          <> @PA_LOGIN_NAME
            AND    ENTPM_DELETED_IND          = 0
            --
            SET @L_ERROR = @@ERROR
            --
            IF @L_ERROR > 0
            BEGIN
            --
              ROLLBACK TRANSACTION
            --
              SET @L_ERRORSTR = CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
            --
            END
            ELSE
            BEGIN
            --
              COMMIT TRANSACTION
            --
            END
          --
          END--#EXIST
          ELSE
          BEGIN--NOTEXIST
          --
            BEGIN TRANSACTION
            --
            INSERT INTO ENTITY_PROPERTY_MSTR
            (ENTPM_ID
            ,ENTPM_PROP_ID
            ,ENTPM_CLICM_ID
            ,ENTPM_ENTTM_ID
            ,ENTPM_EXCPM_ID
            ,ENTPM_CD
            ,ENTPM_DESC
            ,ENTPM_CLI_YN
            ,ENTPM_RMKS
            ,ENTPM_CREATED_BY
            ,ENTPM_CREATED_DT
            ,ENTPM_LST_UPD_BY
            ,ENTPM_LST_UPD_DT
            ,ENTPM_DELETED_IND
            ,ENTPM_MDTY
            ,ENTPM_DATATYPE
            )
            SELECT ENTPMM.ENTPM_ID
                  ,ENTPMM.ENTPM_PROP_ID
                  ,ENTPMM.ENTPM_CLICM_ID
                  ,ENTPMM.ENTPM_ENTTM_ID
                  ,ENTPMM.ENTPM_EXCPM_ID
                  ,ENTPMM.ENTPM_CD
                  ,ENTPMM.ENTPM_DESC
                  ,ENTPMM.ENTPM_CLI_YN
                  ,ENTPMM.ENTPM_RMKS
                  ,ENTPMM.ENTPM_CREATED_BY
                  ,ENTPMM.ENTPM_CREATED_DT
                  ,@PA_LOGIN_NAME
                  ,GETDATE()
                  ,1
                  ,ENTPMM.ENTPM_MDTY
                  ,ENTPMM.ENTPM_DATATYPE
             FROM  ENTITY_PROPERTY_MSTR_MAK ENTPMM  WITH(NOLOCK)
             WHERE ENTPMM.ENTPM_ID          = CONVERT(INT, @@CURRSTRING_ID)
             AND   ENTPMM.ENTPM_CREATED_BY <> @PA_LOGIN_NAME
             AND   ENTPMM.ENTPM_DELETED_IND = 0
             --
             UPDATE ENTITY_PROPERTY_MSTR_MAK  WITH(ROWLOCK)
             SET    ENTPM_DELETED_IND       = 1
                  , ENTPM_LST_UPD_BY        = @PA_LOGIN_NAME
                  , ENTPM_LST_UPD_DT        = GETDATE()
             WHERE  ENTPM_ID = CONVERT(INT,@@CURRSTRING_ID)
             AND    ENTPM_CREATED_BY       <> @PA_LOGIN_NAME
             AND    ENTPM_DELETED_IND       = 0
             --
             SET @L_ERROR = @@ERROR
             --
             IF @L_ERROR > 0
             BEGIN --#1
             --
               ROLLBACK TRANSACTION
               --
               SET @L_ERRORSTR = CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
             --
             END   --#1
             ELSE
             BEGIN--#2
             --
               COMMIT TRANSACTION
             --
             END  --#2
          --
          END--NOTEXIST
        --
        END --APP
        ELSE IF ISNULL(RTRIM(LTRIM(@PA_ACTION)),'') = ''
        BEGIN--NULL
        --
          SET @@REMAININGSTRING_VAL = @PA_VALUES
          --
          WHILE @@REMAININGSTRING_VAL <> ''
          BEGIN--RV3
          --
            SET @@FOUNDAT_VAL  = 0
            SET @@FOUNDAT_VAL  =  PATINDEX('%'+@L_DELIMETER+'%', @@REMAININGSTRING_VAL)
            --
            IF @@FOUNDAT_VAL > 0
            BEGIN
            --
              SET @@CURRSTRING_VAL      = SUBSTRING(@@REMAININGSTRING_VAL, 0, @@FOUNDAT_VAL)
              SET @@REMAININGSTRING_VAL = SUBSTRING(@@REMAININGSTRING_VAL, @@FOUNDAT_VAL+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING_VAL)-@@FOUNDAT_VAL+@@DELIMETERLENGTH)
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
            IF @@CURRSTRING_VAL <> ''
            BEGIN--CV3
            --
              SET @L_EXCH_CD  = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,1)
              SET @L_SEG_CD   = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,2)
              SET @L_PROM_ID  = CONVERT(NUMERIC, citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,3))
              SET @L_ENTTM_ID = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,4)
              SET @L_CLICM_ID = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,5)
              SET @L_NODE     = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,6)
              SET @L_MND_FLG  = CASE citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,7) WHEN 'M' THEN 1 WHEN 'N' THEN 0 ELSE 2 END
              --
              SELECT TOP 1 @L_EXCPM_ID        = EXCPM.EXCPM_ID
              FROM   EXCH_SEG_MSTR EXCSM   WITH(NOLOCK)
                 ,   EXCSM_PROD_MSTR EXCPM WITH(NOLOCK)
              WHERE  EXCPM.EXCPM_EXCSM_ID     = EXCSM.EXCSM_ID
              AND    EXCSM.EXCSM_EXCH_CD      = @L_EXCH_CD
              AND    EXCSM.EXCSM_SEG_CD       = @L_SEG_CD
              AND    EXCPM.EXCPM_PROM_ID      = @L_PROM_ID
              --
              IF @L_MND_FLG = 1 OR @L_MND_FLG = 0
              BEGIN--FLG1/0
              --
                 IF ISNULL(@PA_ENTPM_CD,'') <> ''
                 BEGIN--CD
                 --
                   SELECT @L_ENTPM_PROP_ID = ISNULL(ENTPMM.ENTPM_PROP_ID,0)
                   FROM   ENTITY_PROPERTY_MSTR_MAK ENTPMM WITH(NOLOCK)
                   WHERE  ENTPMM.ENTPM_CD = @PA_ENTPM_CD
                   AND    ENTPMM.ENTPM_DELETED_IND IN (1,0)
                   --
                   IF @L_ENTPM_PROP_ID=0
                   BEGIN
                   --
                     SELECT @L_ENTPM_PROP_ID = ISNULL(MAX(ENTPM.ENTPM_PROP_ID), 0)
                     FROM   ENTITY_PROPERTY_MSTR            ENTPM  WITH(NOLOCK)
                     WHERE  ENTPM.ENTPM_CD           = @PA_ENTPM_CD
                     AND    ENTPM.ENTPM_DELETED_IND IN (0,1);
                   --
                   END
                   --
                   IF @L_ENTPM_PROP_ID = 0
                   BEGIN--PROP_ID = 0
                   --
                     SELECT @L_ENTPM_PROP_ID_MAK = ISNULL(MAX(ENTPMM.ENTPM_PROP_ID), 0) + 1
                     FROM   ENTITY_PROPERTY_MSTR_MAK  ENTPMM  WITH(NOLOCK)
                     --
                     SELECT @L_ENTPM_PROP_ID = ISNULL(MAX(ENTPM.ENTPM_PROP_ID), 0) + 1
                     FROM   ENTITY_PROPERTY_MSTR  ENTPM  WITH(NOLOCK)
                     --
                     IF @L_ENTPM_PROP_ID_MAK > @L_ENTPM_PROP_ID
                     BEGIN--001
                     --
                       SET @L_ENTPM_PROP_ID = @L_ENTPM_PROP_ID_MAK
                     --
                     END--001
                   --
                   END--PROP_ID = 0
                   --
                   IF EXISTS(SELECT * FROM ENTITY_PROPERTY_MSTR_MAK  ENTPM  WITH(NOLOCK)
                             WHERE  ENTPM.ENTPM_PROP_ID     = @L_ENTPM_PROP_ID
                             AND    ENTPM.ENTPM_CLICM_ID    = @L_CLICM_ID
                             AND    ENTPM.ENTPM_ENTTM_ID    = @L_ENTTM_ID
                             AND    ENTPM.ENTPM_EXCPM_ID    = @L_EXCPM_ID
                             AND    ENTPM.ENTPM_DELETED_IND = 0)
                   BEGIN--#1
                   --
                     SET @L_EXISTS = 1
                   --
                   END--#1
                   ELSE
                   BEGIN--#0
                   --
                     SET @L_EXISTS = 0
                   --
                   END--#0
                   --
                   IF @L_EXISTS = 0
                   BEGIN--@L_EXISTS=0
                   --
                     BEGIN TRANSACTION
                     --
                     SELECT @L_ENTPMM_ID = ISNULL(MAX(ENTPM_ID),0)+1
                     FROM ENTITY_PROPERTY_MSTR_MAK  WITH(NOLOCK)

                     SELECT @L_ENTPM_ID  = ISNULL(MAX(ENTPM_ID),0)+1
                     FROM ENTITY_PROPERTY_MSTR   WITH(NOLOCK)

                     IF @L_ENTPMM_ID > @L_ENTPM_ID
                     BEGIN
                     --
                       SET @L_ENTPM_ID = @L_ENTPMM_ID
                     --
                     END
                     --
                     INSERT INTO ENTITY_PROPERTY_MSTR_MAK
                     (ENTPM_ID
                     ,ENTPM_PROP_ID
                     ,ENTPM_CLICM_ID
                     ,ENTPM_ENTTM_ID
                     ,ENTPM_EXCPM_ID
                     ,ENTPM_CD
                     ,ENTPM_DESC
                     ,ENTPM_CLI_YN
                     ,ENTPM_RMKS
                     ,ENTPM_CREATED_BY
                     ,ENTPM_CREATED_DT
                     ,ENTPM_LST_UPD_BY
                     ,ENTPM_LST_UPD_DT
                     ,ENTPM_DELETED_IND
                     ,ENTPM_MDTY
                     ,ENTPM_DATATYPE
                      )
                      VALUES
                     (@L_ENTPM_ID
                     ,@L_ENTPM_PROP_ID
                     ,@L_CLICM_ID
                     ,@L_ENTTM_ID
                     ,@L_EXCPM_ID
                     ,@PA_ENTPM_CD
                     ,@PA_ENTPM_DESC
                     ,@PA_ENTPM_CLI_YN
                     ,@PA_ENTPM_RMKS
                     ,@PA_LOGIN_NAME
                     ,GETDATE()
                     ,@PA_LOGIN_NAME
                     ,GETDATE()
                     ,0
                     ,@L_MND_FLG
                     ,@PA_ENTPM_DATATYPE
                     )
                     --
                     SET @L_ERROR = @@ERROR
                     --
                     IF @L_ERROR > 0
                     BEGIN
                     --
                       ROLLBACK TRANSACTION
                       --
                       SET @L_ERRORSTR = CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
                     --
                     END
                     ELSE
                     BEGIN
                     --
                       COMMIT TRANSACTION
                     --
                     END
                   --
                   END--@L_EXISTS=0
                   IF @L_EXISTS=1
                   BEGIN--@L_EXISTS=1
                   --
                     BEGIN TRANSACTION
                     --
                     UPDATE ENTITY_PROPERTY_MSTR_MAK  WITH (ROWLOCK)
                     SET    ENTPM_DELETED_IND = 2
                          , ENTPM_LST_UPD_BY  = @PA_LOGIN_NAME
                          , ENTPM_LST_UPD_DT  = GETDATE()
                     WHERE  ENTPM_PROP_ID     = @L_ENTPM_PROP_ID
																					AND    ENTPM_CLICM_ID    = @L_CLICM_ID
																					AND    ENTPM_ENTTM_ID    = @L_ENTTM_ID
                     AND    ENTPM_EXCPM_ID    = @L_EXCPM_ID
                     AND    ENTPM_DELETED_IND = 0
                     --
                     SELECT @L_ENTPM_ID      = ISNULL(MAX(ENTPM_ID),0)+1
                     FROM ENTITY_PROPERTY_MSTR_MAK  WITH(NOLOCK)
                     --
                     INSERT INTO ENTITY_PROPERTY_MSTR_MAK
                     (ENTPM_ID
                     ,ENTPM_PROP_ID
                     ,ENTPM_CLICM_ID
                     ,ENTPM_ENTTM_ID
                     ,ENTPM_EXCPM_ID
                     ,ENTPM_CD
                     ,ENTPM_DESC
                     ,ENTPM_CLI_YN
                     ,ENTPM_RMKS
                     ,ENTPM_CREATED_BY
                     ,ENTPM_CREATED_DT
                     ,ENTPM_LST_UPD_BY
                     ,ENTPM_LST_UPD_DT
                     ,ENTPM_DELETED_IND
                     ,ENTPM_MDTY
                     ,ENTPM_DATATYPE
                     )
                     VALUES
                     (@L_ENTPM_ID
                     ,@L_ENTPM_PROP_ID
                     ,@L_CLICM_ID
                     ,@L_ENTTM_ID
                     ,@L_EXCPM_ID
                     ,@PA_ENTPM_CD
                     ,@PA_ENTPM_DESC
                     ,@PA_ENTPM_CLI_YN
                     ,@PA_ENTPM_RMKS
                     ,@PA_LOGIN_NAME
                     ,GETDATE()
                     ,@PA_LOGIN_NAME
                     ,GETDATE()
                     ,0
                     ,@L_MND_FLG
                     ,@PA_ENTPM_DATATYPE
                     )
                     --
                     SET @L_ERROR = @@ERROR
                     --
                     IF @L_ERROR > 0
                     BEGIN
                     --
                       ROLLBACK TRANSACTION
                       --
                       SET @L_ERRORSTR = CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
                     --
                     END
                     ELSE
                     BEGIN
                     --
                       COMMIT TRANSACTION
                     --
                     END
                   --
                   END----@L_EXISTS=1
                 --
                 END--CD
                 ELSE
                 BEGIN--NO_CD
                 --
                   SET @L_ERRORSTR = 'ONE OR ALL OF THE PARAMETERS IS/ARE NULL'
                 --
                 END--NO_CD
              --
              END--FLG1/0
              ELSE IF @L_MND_FLG = 2
              BEGIN--FLG/2
              --
                BEGIN TRANSACTION
                --
                SELECT @L_ENTPM_ID             = ISNULL(ENTPM_ID,0) 
                FROM   ENTITY_PROPERTY_MSTR    ENTPM  WITH(NOLOCK)
                WHERE  ENTPM.ENTPM_PROP_ID     = @PA_ENTPM_PROP_ID
                AND    ENTPM.ENTPM_CLICM_ID    = @L_CLICM_ID
                AND    ENTPM.ENTPM_ENTTM_ID    = @L_ENTTM_ID
                AND    ENTPM.ENTPM_EXCPM_ID    = @L_EXCPM_ID
                AND    ENTPM.ENTPM_DELETED_IND = 1
                --
                IF @L_ENTPM_ID  <> 0
                BEGIN --<>0
                --
                  INSERT INTO ENTITY_PROPERTY_MSTR_MAK
                  ( ENTPM_ID
                  , ENTPM_PROP_ID
                  , ENTPM_CLICM_ID
                  , ENTPM_ENTTM_ID
                  , ENTPM_EXCPM_ID
                  , ENTPM_CD
                  , ENTPM_DESC
                  , ENTPM_CLI_YN
                  , ENTPM_MDTY
                  , ENTPM_RMKS
                  , ENTPM_CREATED_BY
                  , ENTPM_CREATED_DT
                  , ENTPM_LST_UPD_BY
                  , ENTPM_LST_UPD_DT
                  , ENTPM_DELETED_IND
                  , ENTPM_DATATYPE
                  )
                  VALUES
                  ( @L_ENTPM_ID
                  , @PA_ENTPM_PROP_ID
                  , @L_CLICM_ID
                  , @L_ENTTM_ID
                  , @L_EXCPM_ID
                  , @PA_ENTPM_CD
                  , @PA_ENTPM_DESC
                  , @PA_ENTPM_CLI_YN
                  , @L_MND_FLG
                  , @PA_ENTPM_RMKS
                  , @PA_LOGIN_NAME
                  , GETDATE()
                  , @PA_LOGIN_NAME
                  , GETDATE()
                  , 6
                  , @PA_ENTPM_DATATYPE
                  )
                  --
                  SET @L_ERROR = @@ERROR
                  --
                  IF @L_ERROR > 0
                  BEGIN--#1
                  --
                    SET @L_ERRORSTR = CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
                    --
                    ROLLBACK TRANSACTION
                    --
                    RETURN
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
                  UPDATE ENTITY_PROPERTY_MSTR_MAK  WITH (ROWLOCK)
                  SET    ENTPM_DELETED_IND = 6
                        ,ENTPM_LST_UPD_BY  = @PA_LOGIN_NAME
                        ,ENTPM_LST_UPD_DT  = GETDATE()
                  WHERE  ENTPM_PROP_ID     = @PA_ENTPM_PROP_ID
                  AND    ENTPM_CLICM_ID    = @L_CLICM_ID
                  AND    ENTPM_ENTTM_ID    = @L_ENTTM_ID
                  AND    ENTPM_EXCPM_ID    = @L_EXCPM_ID
                  --
                  SET @L_ERROR = @@ERROR
                  --
                  IF @L_ERROR > 0
                  BEGIN--#1
                  --
                    SET @L_ERRORSTR = CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
                    --
                    ROLLBACK TRANSACTION
                    --
                    RETURN
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
              END--FLG/2
              ELSE
              BEGIN--NOFLAG
              --
                SET @L_ERRORSTR = 'ONE OR ALL OF THE PARAMETERS IS/ARE NULL'
              --
              END--NOFLAG
            --
            END--CV3
          --
          END--RV3
        --
        END--NULL
      ----
      END--CHK=1
    --
    END--CID
  ---------
  END--RVID
  --
  IF ISNULL(RTRIM(LTRIM(@L_ERRORSTR)),'') = ''
  BEGIN
  --
    SET @L_ERRORSTR = 'Properties successfully inserted\edited '+ @ROWDELIMITER
  --
  END
  ELSE
  BEGIN
  --
    SET @PA_ERRMSG = @L_ERRORSTR
  --
  END
--
END--MAIN BEGIN

GO
