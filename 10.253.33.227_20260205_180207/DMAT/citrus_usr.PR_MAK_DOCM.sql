-- Object: PROCEDURE citrus_usr.PR_MAK_DOCM
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--PR_MAK_DOCM '1','','SS',2,'PP','PASSPORT','','BSE|*~|CASH|*~|3|*~|7|*~|9|*~|MNODE|*~|M|*~|*|~*', 0,'*|~*','|*~|',''
-- 1  SS 2 PP PASSPORT  BSE|*~|CASH|*~|3|*~|7|*~|9|*~|MNODE|*~|M|*~|*|~* 0 *|~* |*~|
CREATE  PROCEDURE [citrus_usr].[PR_MAK_DOCM](@PA_ID            VARCHAR(8000)
                           ,@PA_ACTION        VARCHAR(20)
                           ,@PA_LOGIN_NAME    VARCHAR(20)
                           ,@PA_DOCM_DOC_ID   INT
                           ,@PA_DOCM_CD       VARCHAR(20)
                           ,@PA_DOCM_DESC     VARCHAR(50)
                           ,@PA_DOCM_RMKS     VARCHAR(200)
                           ,@PA_VALUES        VARCHAR(8000)--'EXCH|*~|SEG|*~|PROM_ID|*~|ENTTM_ID|*~|CLICM_ID|*~|M|*~|*|~*'
                           ,@PA_CHK_YN        INT
                           ,@ROWDELIMITER     CHAR(4)
                           ,@COLDELIMITER     CHAR(4)
                           ,@PA_ERRMSG        VARCHAR(8000) OUTPUT
 )
AS
/*
*********************************************************************************
 SYSTEM         : CLASS
 MODULE NAME    : PR_MAK_DOCM
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE MAKER CHECKER FACILITY FOR DOCUMENT_MSTR
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.
 VERSION HISTORY:
 VERS.  AUTHOR            DATE         REASON
 -----  -------------     ----------   -------------------------------------------------
 1.0    HARI N            15-DEC-2006
 2.0    SUKHVINDER/TUSHAR 25-JAN-2007  CHNAGES IN TABLE
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
        , @L_SDOCM_ID           NUMERIC
        , @L_DOCM_ID            NUMERIC
        , @L_DOCMM_ID           NUMERIC
        , @L_DOCM_DOC_ID        NUMERIC
        , @l_docm_doc_id_mak    NUMERIC
        --, @L_DOCMM_DOC_ID       NUMERIC
        , @L_DELIMETER          VARCHAR(10)
        , @L_EXCH_CD            VARCHAR(25)
        , @L_SEG_CD             VARCHAR(25)
        , @L_ERR_ENTTM_DESC     VARCHAR(100)
        , @L_ERR_CLICM_DESC     VARCHAR(100)
        , @L_ERR_EXCPM_ID       NUMERIC
        , @L_ERR_EXCPM_PROM_ID  NUMERIC
        , @L_ERR_DOCM_CD        VARCHAR(25)
        , @L_ERR_DOCM_DESC      VARCHAR(100)
        , @L_ERR_DOCM_DOC_ID    NUMERIC

        , @L_ERR_DOCM_RMKS      VARCHAR(250)
        , @L_ERR_DOCM_MDTY      CHAR(2)
        , @L_ERR_EXCSM_EXCH_CD  VARCHAR(25)
        , @L_ERR_EXCSM_SEG_CD   VARCHAR(25)
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
        , @L_DELETED_IND         SMALLINT
        ,@@c_excpm_id           NUMERIC
  DECLARE @@c_excpm  CURSOR
  --

  CREATE TABLE #T_DOCM
  ([DOCM_ID]          [numeric](10, 0) NOT NULL ,
   [DOCM_DOC_ID]      [numeric](10, 0) NOT NULL ,
   [DOCM_CLICM_ID]    [numeric](18, 0) NULL ,
   [DOCM_ENTTM_ID]    [numeric](18, 0) NULL ,
   [DOCM_EXCPM_ID]    [numeric](18, 0) NULL ,
   [DOCM_CD]          [varchar] (20)  NOT NULL ,
   [DOCM_DESC]        [varchar] (100)  NULL ,
   [DOCM_RMKS]        [varchar] (250)  NULL ,
   [DOCM_MDTY]        [smallint] NULL,
   [DOCM_CREATED_BY]  [varchar] (25)  NOT NULL ,
   [DOCM_CREATED_DT]  [datetime] NOT NULL ,
   [DOCM_LST_UPD_BY]  [varchar] (25)  NOT NULL ,
   [DOCM_LST_UPD_DT]  [varchar] (25)  NOT NULL ,
   [DOCM_DELETED_IND] [smallint] NOT NULL )
   
   CREATE TABLE #T_DOC_MSTR
     ([DOCM_ID]          [numeric](10, 0) NOT NULL ,
      [DOCM_DOC_ID]      [numeric](10, 0) NOT NULL ,
      [DOCM_CLICM_ID]    [numeric](18, 0) NULL ,
      [DOCM_ENTTM_ID]    [numeric](18, 0) NULL ,
      [DOCM_EXCPM_ID]    [numeric](18, 0) NULL ,
      [DOCM_CD]          [varchar] (20)  NOT NULL ,
      [DOCM_DESC]        [varchar] (100)  NULL ,
      [DOCM_RMKS]        [varchar] (250)  NULL ,
      [DOCM_MDTY]        [smallint] NULL,
      [DOCM_CREATED_BY]  [varchar] (25)  NOT NULL ,
      [DOCM_CREATED_DT]  [datetime] NOT NULL ,
      [DOCM_LST_UPD_BY]  [varchar] (25)  NOT NULL ,
      [DOCM_LST_UPD_DT]  [varchar] (25)  NOT NULL ,
      [DOCM_DELETED_IND] [smallint] NOT NULL )

  
  
  
  INSERT INTO #T_DOCM
   (DOCM_ID
   ,DOCM_DOC_ID
   ,DOCM_CLICM_ID
   ,DOCM_ENTTM_ID
   ,DOCM_EXCPM_ID
   ,DOCM_CD
   ,DOCM_DESC
   ,DOCM_RMKS
   ,DOCM_MDTY
   ,DOCM_CREATED_BY
   ,DOCM_CREATED_DT
   ,DOCM_LST_UPD_BY
   ,DOCM_LST_UPD_DT
   ,DOCM_DELETED_IND)
   SELECT DOCM_ID
         ,DOCM_DOC_ID
         ,DOCM_CLICM_ID
         ,DOCM_ENTTM_ID
         ,DOCM_EXCPM_ID
         ,DOCM_CD
         ,DOCM_DESC
         ,DOCM_RMKS
         ,DOCM_MDTY
         ,DOCM_CREATED_BY
         ,DOCM_CREATED_DT
         ,DOCM_LST_UPD_BY
         ,DOCM_LST_UPD_DT
         ,DOCM_DELETED_IND
   FROM   DOCUMENT_MSTR_MAK
   WHERE  DOCM_DELETED_IND = 0
   AND    DOCM_DOC_ID=@PA_DOCM_DOC_ID
   
   INSERT INTO #T_DOC_MSTR
      (DOCM_ID
      ,DOCM_DOC_ID
      ,DOCM_CLICM_ID
      ,DOCM_ENTTM_ID
      ,DOCM_EXCPM_ID
      ,DOCM_CD
      ,DOCM_DESC
      ,DOCM_RMKS
      ,DOCM_MDTY
      ,DOCM_CREATED_BY
      ,DOCM_CREATED_DT
      ,DOCM_LST_UPD_BY
      ,DOCM_LST_UPD_DT
      ,DOCM_DELETED_IND)
      SELECT DOCM_ID
            ,DOCM_DOC_ID
            ,DOCM_CLICM_ID
            ,DOCM_ENTTM_ID
            ,DOCM_EXCPM_ID
            ,DOCM_CD
            ,DOCM_DESC
            ,DOCM_RMKS
            ,DOCM_MDTY
            ,DOCM_CREATED_BY
            ,DOCM_CREATED_DT
            ,DOCM_LST_UPD_BY
            ,DOCM_LST_UPD_DT
            ,DOCM_DELETED_IND
      FROM   DOCUMENT_MSTR
      WHERE  DOCM_DELETED_IND = 1
      AND    DOCM_DOC_ID=@PA_DOCM_DOC_ID
   
   
  
  --
  SET @L_ERROR = 0
  SET @L_ERRORSTR          = ''
  SET @L_DELIMETER         = '%'+ @ROWDELIMITER + '%'
  SET @@DELIMETERLENGTH    = LEN(@ROWDELIMITER)
  SET @@REMAININGSTRING_ID = @PA_ID
  SET @L_DOCM_DOC_ID = 0
  --
  WHILE @@REMAININGSTRING_ID <> ''
  BEGIN --#1
    --
     SET @@FOUNDAT_ID  = 0
     SET @@FOUNDAT_ID  =  PATINDEX('%'+@L_DELIMETER+'%', @@REMAININGSTRING_ID)
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
      SET @@CURRSTRING_ID = @@REMAININGSTRING_ID
      SET @@REMAININGSTRING_ID = ''
     --
     END
     --
     IF @@CURRSTRING_ID <> ''
     BEGIN --#2
     --
       IF @PA_CHK_YN=0
       BEGIN--#@PA_CHK_YN=0
       --
         IF @PA_ACTION='EDTMSTR'
         BEGIN --#@PA_ACTION='EDTMSTR'
         --
           BEGIN TRANSACTION

           UPDATE DOCUMENT_MSTR
           SET    DOCM_CD   = @PA_DOCM_CD
                , DOCM_DESC = @PA_DOCM_DESC
                , DOCM_RMKS = @PA_DOCM_RMKS
           WHERE  DOCM_DOC_ID = @PA_DOCM_DOC_ID
           AND    DOCM_DELETED_IND = 1
           --
           SET @L_ERROR = @@ERROR
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
         END
         IF @PA_ACTION='DELMSTR'
         BEGIN
         --
           UPDATE DOCUMENT_MSTR
           SET    DOCM_DELETED_IND = 0
           WHERE  DOCM_DOC_ID   = @PA_ID
           AND    DOCM_DELETED_IND = 1
         --
         END
         ELSE IF ISNULL(@PA_ACTION,'')=''
         BEGIN  --#@PA_ACTION IS NULL
         --
         
          SET @@REMAININGSTRING_VAL = @PA_VALUES
          WHILE @@REMAININGSTRING_VAL <> ''
          BEGIN--#3

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
            BEGIN--#4
            --
              SET @L_EXCH_CD  = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,1)
              SET @L_SEG_CD   = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,2)
              SET @L_PROM_ID  = CONVERT(NUMERIC, citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,3))
              SET @L_ENTTM_ID = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,4)
              SET @L_CLICM_ID = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,5)
              SET @L_NODE     = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,6)
              SET @L_MND_FLG  = CASE citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,7) WHEN 'M' THEN 1 WHEN 'N' THEN 0 ELSE 2 END
            --
     
            /*SELECT TOP 1 @L_EXCPM_ID     = EXCPM.EXCPM_ID
            FROM EXCH_SEG_MSTR EXCSM   WITH(NOLOCK)
               , EXCSM_PROD_MSTR EXCPM WITH(NOLOCK)
            WHERE EXCPM.EXCPM_EXCSM_ID   = EXCSM.EXCSM_ID
            AND EXCSM.EXCSM_EXCH_CD      = @L_EXCH_CD
            AND EXCSM.EXCSM_SEG_CD       = @L_SEG_CD
            AND EXCPM.EXCPM_PROM_ID      = @L_PROM_ID
            AND EXCSM_DELETED_IND        = 1
            AND EXCPM_DELETED_IND        = 1 */
            
            
            SET @@c_excpm  = CURSOR FAST_FORWARD FOR  
                             SELECT  EXCPM.EXCPM_ID
                             FROM EXCH_SEG_MSTR EXCSM   WITH(NOLOCK)
                                , EXCSM_PROD_MSTR EXCPM WITH(NOLOCK)
                             WHERE EXCPM.EXCPM_EXCSM_ID   = EXCSM.EXCSM_ID
                             AND EXCSM.EXCSM_EXCH_CD      = @L_EXCH_CD
                             AND EXCSM.EXCSM_SEG_CD       = @L_SEG_CD
                             AND EXCPM.EXCPM_PROM_ID      = @L_PROM_ID
                             AND EXCSM_DELETED_IND        = 1
                             AND EXCPM_DELETED_IND        = 1 
            OPEN  @@c_excpm  
            FETCH NEXT FROM @@c_excpm INTO @@c_excpm_id                 

            WHILE @@fetch_status = 0  
            BEGIN
            --  
            
               IF @L_MND_FLG=1 OR @L_MND_FLG=0
               BEGIN
               --

                 IF ISNULL(@PA_DOCM_CD,'')<>''
                 BEGIN
                 --

                   SELECT @L_DOCM_DOC_ID = ISNULL(DOCMM.DOCM_DOC_ID,0)
                   FROM   DOCUMENT_MSTR_MAK DOCMM
                   WHERE  DOCMM.DOCM_CD=@PA_DOCM_CD
                   AND    DOCMM.DOCM_DELETED_IND IN (1,0)

                   IF @L_DOCM_DOC_ID=0
                   BEGIN
                   --
                     SELECT @l_docm_doc_id = ISNULL(MAX(docm.docm_doc_id), 0)
                     FROM   document_mstr            docm
                     WHERE  docm.docm_cd           = @pa_docm_cd
                     AND    docm.docm_deleted_ind IN (0,1);
                   --
                   END
                   IF @l_docm_doc_id = 0
                   BEGIN
                   --
                     SELECT @l_docm_doc_id_mak=ISNULL(MAX(docmm.docm_doc_id), 0) + 1
                     FROM   document_mstr_mak  docmm;
                     --
                     SELECT @l_docm_doc_id=ISNULL(MAX(docm.docm_doc_id), 0) + 1
                     FROM   document_mstr  docm;
                     --
                     IF @l_docm_doc_id_mak>@l_docm_doc_id
                     BEGIN
                     --
                       SET @l_docm_doc_id=@l_docm_doc_id_mak
                     --
                     END
                     --
                   END --@l_docm_doc_id = 0

                   --


                   IF EXISTS(SELECT * FROM   document_mstr           docm
                             WHERE  docm.docm_doc_id      = @l_docm_doc_id
                             AND    docm.docm_clicm_id    = @l_clicm_id
                             AND    docm.docm_enttm_id    = @l_enttm_id
                             AND    docm.docm_excpm_id    = @@c_excpm_id    
                             )
                   BEGIN
                   --
                     SET @L_EXISTS = 1
                   --
                   END
                   ELSE
                   BEGIN
                   --
                     SET @L_EXISTS = 0
                   --
                   END

                   IF @L_EXISTS=0
                   BEGIN
                   --
                     SELECT @L_DOCM_ID = ISNULL(MAX(DOCM_ID),0)+1
                     FROM DOCUMENT_MSTR

                     BEGIN TRANSACTION
                     --
                     
                      INSERT INTO DOCUMENT_MSTR
                       (DOCM_ID
                       ,DOCM_DOC_ID
                       ,DOCM_CLICM_ID
                       ,DOCM_ENTTM_ID
                       ,DOCM_EXCPM_ID
                       ,DOCM_CD
                       ,DOCM_DESC
                       ,DOCM_RMKS
                       ,DOCM_CREATED_BY
                       ,DOCM_CREATED_DT
                       ,DOCM_LST_UPD_BY
                       ,DOCM_LST_UPD_DT
                       ,DOCM_DELETED_IND
                       ,DOCM_MDTY
                       )
                       VALUES
                       (@L_DOCM_ID
                       ,@L_DOCM_DOC_ID
                       ,@L_CLICM_ID
                       ,@L_ENTTM_ID
                       ,@@c_excpm_id 
                       ,@PA_DOCM_CD
                       ,@PA_DOCM_DESC
                       ,@PA_DOCM_RMKS
                       ,@PA_LOGIN_NAME
                       ,GETDATE()
                       ,@PA_LOGIN_NAME
                       ,GETDATE()
                       ,1
                       ,@L_MND_FLG
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
                   END
                   IF @L_EXISTS = 1
                   BEGIN
                   --
                     BEGIN TRANSACTION
                    
                     UPDATE DOCUMENT_MSTR  WITH(ROWLOCK)
                     SET    DOCM_CD           = UPPER(@PA_DOCM_CD)
                          , DOCM_DESC         = @PA_DOCM_DESC
                          , DOCM_RMKS         = @PA_DOCM_RMKS
                          , DOCM_MDTY         = @L_MND_FLG
                          , DOCM_LST_UPD_BY   = @PA_LOGIN_NAME
                          , DOCM_LST_UPD_DT   = GETDATE()
                          , DOCM_DELETED_IND  = 1   --AFTER REMOVE THEN INSERT SAME RECORD--TUSHAR.13.03.2007
                     WHERE  DOCM_DOC_ID       = @PA_DOCM_DOC_ID
                     AND    DOCM_CLICM_ID     = @L_CLICM_ID
                     AND    DOCM_ENTTM_ID     = @L_ENTTM_ID
                     AND    DOCM_EXCPM_ID     = @@c_excpm_id 

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
                    --
                   END -- @L_EXISTS
                 --
                 END --CD
                 ELSE
                 BEGIN
                 --
                   SET @L_ERRORSTR = 'One Or All Of The Parameters Is/Are Null'
                 --
                 END
                --
                END --@L_MND_FLG=1 OR @L_MND_FLG=0
                ELSE IF @L_MND_FLG=2
                BEGIN
                --

                  IF EXISTS(SELECT *
                            FROM   document_mstr           docm
                            WHERE  docm.docm_doc_id      = @PA_DOCM_DOC_ID
                            AND    docm.docm_clicm_id    = @l_clicm_id
                            AND    docm.docm_enttm_id    = @l_enttm_id
                            AND    docm.docm_excpm_id    = @@c_excpm_id 
                            AND    docm.docm_deleted_ind = 1)
                  BEGIN
                  --
                   BEGIN TRANSACTION
                   --

                     UPDATE DOCUMENT_MSTR  WITH(ROWLOCK)
                     SET    DOCM_DELETED_IND = 0
                          , DOCM_LST_UPD_BY  = @PA_LOGIN_NAME
                          , DOCM_LST_UPD_DT  = GETDATE()
                     WHERE  docm_doc_id      = @PA_DOCM_DOC_ID
                     AND    docm_clicm_id    = @l_clicm_id
                     AND    docm_enttm_id    = @l_enttm_id
                     AND    docm_excpm_id    = @@c_excpm_id 
                    --
                    SET @L_ERROR = @@ERROR

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
                  END
                  ELSE
                  BEGIN
                  --
                    SET @L_ERRORSTR = 'One Or All Of The Parameters Is/Are Null'
                  --
                  END
                --
                END
                --
                FETCH NEXT FROM @@c_excpm INTO @@c_excpm_id
              --
              END --#CURSOR WHILE
            END --#4
            --
          END--#3
         END--#PA_ACTION IS NULL
        END --CKH_YN
        IF @PA_CHK_YN=1
         BEGIN
         --
           IF @PA_ACTION ='EDTMSTR'
           BEGIN
           --
             BEGIN TRANSACTION
           --
            
             UPDATE DOCUMENT_MSTR_MAK  WITH (ROWLOCK)
             SET   DOCM_DELETED_IND = 2
                  ,DOCM_LST_UPD_BY  = @PA_LOGIN_NAME
                  ,DOCM_LST_UPD_DT  = GETDATE()
             WHERE DOCM_DOC_ID      = @PA_DOCM_DOC_ID
             AND   DOCM_DELETED_IND = 0
           --
             SET @L_ERROR = @@ERROR
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
              
              
              UPDATE #T_DOCM
              SET    DOCM_CD         = @PA_DOCM_CD
                   , DOCM_DESC       = @PA_DOCM_DESC
                   , DOCM_RMKS       = @PA_DOCM_RMKS
                   , DOCM_CREATED_BY = @PA_LOGIN_NAME
                   , DOCM_CREATED_DT = GETDATE()
                   , DOCM_LST_UPD_BY = @PA_LOGIN_NAME
                   , DOCM_LST_UPD_DT = GETDATE()
              WHERE  DOCM_DOC_ID = @PA_DOCM_DOC_ID
             
   
             
              
              INSERT INTO DOCUMENT_MSTR_MAK
              (DOCM_ID
              ,DOCM_DOC_ID
              ,DOCM_CLICM_ID
              ,DOCM_ENTTM_ID
              ,DOCM_EXCPM_ID
              ,DOCM_CD
              ,DOCM_DESC
              ,DOCM_RMKS
              ,DOCM_MDTY
              ,DOCM_CREATED_BY
              ,DOCM_CREATED_DT
              ,DOCM_LST_UPD_BY
              ,DOCM_LST_UPD_DT
              ,DOCM_DELETED_IND
              
              )
              SELECT DOCM_ID
                    ,DOCM_DOC_ID
                    ,DOCM_CLICM_ID
                    ,DOCM_ENTTM_ID
                    ,DOCM_EXCPM_ID
                    ,DOCM_CD
                    ,DOCM_DESC
                    ,DOCM_RMKS
                    ,DOCM_MDTY
                    ,DOCM_CREATED_BY
                    ,DOCM_CREATED_DT
                    ,DOCM_LST_UPD_BY
                    ,DOCM_LST_UPD_DT
                    ,DOCM_DELETED_IND
              FROM   #T_DOCM
              WHERE  DOCM_DOC_ID=@PA_DOCM_DOC_ID

             
              SET @L_ERROR = @@ERROR
            
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
             END
           END
           ELSE IF @PA_ACTION='DELMSTR'
           BEGIN
           --
             UPDATE #T_DOC_MSTR
             SET    DOCM_DELETED_IND = 4
             WHERE  DOCM_DOC_ID      = @PA_DOCM_DOC_ID
             AND    DOCM_DELETED_IND = 1
             
             
             INSERT INTO DOCUMENT_MSTR_MAK
             (DOCM_ID
             ,DOCM_DOC_ID
             ,DOCM_CLICM_ID
             ,DOCM_ENTTM_ID
             ,DOCM_EXCPM_ID
             ,DOCM_CD
             ,DOCM_DESC
             ,DOCM_RMKS
             ,DOCM_MDTY
             ,DOCM_CREATED_BY
             ,DOCM_CREATED_DT
             ,DOCM_LST_UPD_BY
             ,DOCM_LST_UPD_DT
             ,DOCM_DELETED_IND)
             SELECT DOCM_ID
                    ,DOCM_DOC_ID
                    ,DOCM_CLICM_ID
                    ,DOCM_ENTTM_ID
                    ,DOCM_EXCPM_ID
                    ,DOCM_CD
                    ,DOCM_DESC
                    ,DOCM_RMKS
                    ,DOCM_MDTY
                    ,DOCM_CREATED_BY
                    ,DOCM_CREATED_DT
                    ,DOCM_LST_UPD_BY
                    ,DOCM_LST_UPD_DT
                    ,DOCM_DELETED_IND
              FROM  #T_DOC_MSTR
              WHERE DOCM_DOC_ID      = @PA_DOCM_DOC_ID
             
          
           --
           END
           
           ELSE IF @PA_ACTION='APP'
           BEGIN
              
              
              SELECT @L_DELETED_IND = ISNULL(DOCM_DELETED_IND ,0)
              FROM   DOCUMENT_MSTR_MAK 
              WHERE  DOCM_ID = CONVERT(INT, @@CURRSTRING_ID)
              
              IF @L_DELETED_IND = 4
              BEGIN
              --
                UPDATE DOCUMENT_MSTR_MAK        
                SET    DOCM_DELETED_IND = 5
                     , DOCM_LST_UPD_BY  = @PA_LOGIN_NAME
                     , DOCM_LST_UPD_DT  = GETDATE()
                WHERE  DOCM_DOC_ID      = CONVERT(INT, @@CURRSTRING_ID)
                AND    DOCM_DELETED_IND = 4  
              --
                 UPDATE DOCUMENT_MSTR           
                 SET    DOCM_DELETED_IND = 0
                      , DOCM_LST_UPD_BY  = @PA_LOGIN_NAME
                      , DOCM_LST_UPD_DT  = GETDATE()
                 WHERE  DOCM_DOC_ID      = CONVERT(INT, @@CURRSTRING_ID)
                 AND    DOCM_DELETED_IND = 1
              --
              END
              ELSE IF @L_DELETED_IND = 6
              BEGIN
              --
                UPDATE DOCUMENT_MSTR_MAK        
                SET    DOCM_DELETED_IND = 7
                     , DOCM_LST_UPD_BY  = @PA_LOGIN_NAME
                     , DOCM_LST_UPD_DT  = GETDATE()
                WHERE  DOCM_ID          = CONVERT(INT, @@CURRSTRING_ID)
                AND    DOCM_DELETED_IND = 6
                --
                
                UPDATE DOCUMENT_MSTR           
                SET    DOCM_DELETED_IND = 0
                     , DOCM_LST_UPD_BY  = @PA_LOGIN_NAME
                     , DOCM_LST_UPD_DT  = GETDATE()
                WHERE  DOCM_ID          = CONVERT(INT, @@CURRSTRING_ID)
                AND    DOCM_DELETED_IND = 1
              --
              END
              ELSE IF EXISTS(SELECT DOCM_ID
                             FROM DOCUMENT_MSTR  WITH(NOLOCK)
                             WHERE DOCM_ID=CONVERT(INT, @@CURRSTRING_ID)
                             )
              BEGIN --#EXIST
              --
                BEGIN TRANSACTION
              --
                UPDATE DOCM WITH(ROWLOCK)
                SET DOCM.DOCM_DOC_ID       = DOCMM.DOCM_DOC_ID
                  , DOCM.DOCM_CD           = DOCMM.DOCM_CD
                  , DOCM.DOCM_DESC         = DOCMM.DOCM_DESC
                  , DOCM.DOCM_RMKS         = DOCMM.DOCM_RMKS
                  , DOCM.DOCM_MDTY         = DOCMM.DOCM_MDTY
                  , DOCM.DOCM_LST_UPD_BY   = @PA_LOGIN_NAME
                  , DOCM.DOCM_LST_UPD_DT   = GETDATE()
                  , DOCM.DOCM_DELETED_IND  = 1
                FROM  DOCUMENT_MSTR DOCM,
                      DOCUMENT_MSTR_MAK  DOCMM
                WHERE DOCM.DOCM_ID           = CONVERT(INT, @@CURRSTRING_ID)
                AND   DOCM.DOCM_DELETED_IND  = 1
                AND   DOCMM.DOCM_DELETED_IND = 0
                AND   DOCMM.DOCM_CREATED_BY <> @PA_LOGIN_NAME
              --
                SET @L_ERROR = @@ERROR
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
                  UPDATE DOCUMENT_MSTR_MAK  WITH(ROWLOCK)
                  SET    DOCM_DELETED_IND = 1
                       , DOCM_LST_UPD_BY  = @PA_LOGIN_NAME
                       , DOCM_LST_UPD_DT  = GETDATE()
                  WHERE DOCM_ID = CONVERT(INT, @@CURRSTRING_ID)
                  AND   DOCM_CREATED_BY <> @PA_LOGIN_NAME
                  AND   DOCM_DELETED_IND  = 0
                --
                  SET @L_ERROR = @@ERROR
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
                END --#002
                --
              END  --#EXIST
              ELSE
              BEGIN --#NOT EXIST
              --
                BEGIN TRANSACTION
              --
                INSERT INTO DOCUMENT_MSTR
                 (DOCM_ID
                 ,DOCM_DOC_ID
                 ,DOCM_CLICM_ID
                 ,DOCM_ENTTM_ID
                 ,DOCM_EXCPM_ID
                 ,DOCM_CD
                 ,DOCM_DESC
                 ,DOCM_RMKS
                 ,DOCM_CREATED_BY
                 ,DOCM_CREATED_DT
                 ,DOCM_LST_UPD_BY
                 ,DOCM_LST_UPD_DT
                 ,DOCM_DELETED_IND
                 ,DOCM_MDTY
                 )
                 SELECT DOCMM.DOCM_ID
                       ,DOCMM.DOCM_DOC_ID
                       ,DOCMM.DOCM_CLICM_ID
                       ,DOCMM.DOCM_ENTTM_ID
                       ,DOCMM.DOCM_EXCPM_ID
                       ,DOCMM.DOCM_CD
                       ,DOCMM.DOCM_DESC
                       ,DOCMM.DOCM_RMKS
                       ,DOCMM.DOCM_CREATED_BY
                       ,DOCMM.DOCM_CREATED_DT
                       ,@PA_LOGIN_NAME
                       ,GETDATE()
                       ,1
                       ,DOCMM.DOCM_MDTY
                  FROM  DOCUMENT_MSTR_MAK DOCMM  WITH(NOLOCK)
                  WHERE DOCMM.DOCM_ID          = CONVERT(INT, @@CURRSTRING_ID)
                  AND   DOCMM.DOCM_CREATED_BY  <> @PA_LOGIN_NAME
                  AND   DOCMM.DOCM_DELETED_IND = 0
                  --
                  SET @L_ERROR = @@ERROR
                  IF @L_ERROR> 0
                  BEGIN --#1
                  --
                    ROLLBACK TRANSACTION
    
                    SET @L_ERRORSTR = CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
                  --
                  END--#1
                  ELSE
                  BEGIN--#2
                  --
                    UPDATE DOCUMENT_MSTR_MAK  WITH(ROWLOCK)
                    SET    DOCM_DELETED_IND = 1
                          ,DOCM_LST_UPD_BY  = @PA_LOGIN_NAME
                          ,DOCM_LST_UPD_DT  = GETDATE()
                    WHERE DOCM_ID = CONVERT(INT,@@CURRSTRING_ID)
                    AND   DOCM_CREATED_BY  <> @PA_LOGIN_NAME
                    AND   DOCM_DELETED_IND  = 0
                    -- 
                    SET @L_ERROR = @@ERROR
                    IF @L_ERROR > 0
                    BEGIN --#001
                    --
                      ROLLBACK TRANSACTION
                      SET @L_ERRORSTR = CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER
                    --
                    END   --#001
                    ELSE
                    BEGIN--#002
                    --
                      COMMIT TRANSACTION
                    --
                    END  --#002
                    --
                  END --#2
                  --
              END  --#NOT EXIST
            END--APP
            ELSE IF @PA_ACTION='REJ'
            BEGIN
            --
              BEGIN TRANSACTION
              --
              UPDATE DOCUMENT_MSTR_MAK  WITH (ROWLOCK)
              SET    DOCM_DELETED_IND = 3
                    ,DOCM_LST_UPD_BY  = @PA_LOGIN_NAME
                    ,DOCM_LST_UPD_DT  = GETDATE()
               WHERE DOCM_ID           = CONVERT(INT, @@CURRSTRING_ID)
               AND   DOCM_DELETED_IND  IN (0,4,6)
              --
              SET @L_ERROR = @@ERROR
              IF @L_ERROR > 0
              BEGIN
              --
                ROLLBACK TRANSACTION
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
            END --REJ
            ELSE IF ISNULL(@PA_ACTION,'')=''
            BEGIN
            --
              SET @@REMAININGSTRING_VAL = @PA_VALUES
              WHILE @@REMAININGSTRING_VAL <> ''
              BEGIN--#3
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
               BEGIN--#4
               --
                 SET @L_EXCH_CD  = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,1)
                 SET @L_SEG_CD   = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,2)
                 SET @L_PROM_ID  = CONVERT(NUMERIC, citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,3))
                 SET @L_ENTTM_ID = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,4)
                 SET @L_CLICM_ID = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,5)
                 SET @L_NODE     = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,6)
                 SET @L_MND_FLG  = CASE citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,7) WHEN 'M' THEN 1 WHEN 'N' THEN 0 ELSE 2 END
               --
                 SELECT TOP 1 @L_EXCPM_ID     = EXCPM.EXCPM_ID
                 FROM EXCH_SEG_MSTR EXCSM   WITH(NOLOCK)
                    , EXCSM_PROD_MSTR EXCPM WITH(NOLOCK)
                 WHERE EXCPM.EXCPM_EXCSM_ID   = EXCSM.EXCSM_ID
                 AND EXCSM.EXCSM_EXCH_CD      = @L_EXCH_CD
                 AND EXCSM.EXCSM_SEG_CD       = @L_SEG_CD
                 AND EXCPM.EXCPM_PROM_ID      = @L_PROM_ID
                 AND EXCSM_DELETED_IND        = 1
                 AND EXCPM_DELETED_IND        = 1 

                  IF ISNULL(@PA_DOCM_CD,'')<>''
                  BEGIN
                  --
                    IF @L_MND_FLG=1 OR @L_MND_FLG=0
                    BEGIN
                    --
                      SELECT @L_DOCM_DOC_ID = ISNULL(DOCMM.DOCM_DOC_ID,0)
                      FROM   DOCUMENT_MSTR_MAK DOCMM
                      WHERE  DOCMM.DOCM_CD=@PA_DOCM_CD
                      AND    DOCMM.DOCM_DELETED_IND IN (1,0)

                      IF @L_DOCM_DOC_ID=0
                      BEGIN
                      --
                        SELECT @l_docm_doc_id = ISNULL(MAX(docm.docm_doc_id), 0)
                        FROM   document_mstr            docm
                        WHERE  docm.docm_cd           = @pa_docm_cd
                        AND    docm.docm_deleted_ind IN (0,1);
                      --
                      END
                      IF @l_docm_doc_id = 0
                      BEGIN
                      --
                        SELECT @l_docm_doc_id_mak=ISNULL(MAX(docmm.docm_doc_id), 0) + 1
                        FROM   document_mstr_mak  docmm;
                        --
                        SELECT @l_docm_doc_id=ISNULL(MAX(docm.docm_doc_id), 0) + 1
                        FROM   document_mstr  docm;
                        --
                        IF @l_docm_doc_id_mak>@l_docm_doc_id
                        BEGIN
                        --
                          SET @l_docm_doc_id=@l_docm_doc_id_mak
                        -- 
                        END
                        -- 
                       END --@l_docm_doc_id = 0
          
                       IF EXISTS(SELECT * FROM   document_mstr_mak           docm
                       WHERE  docm.docm_doc_id      = @l_docm_doc_id
                       AND    docm.docm_clicm_id    = @l_clicm_id
                       AND    docm.docm_enttm_id    = @l_enttm_id
                       AND    docm.docm_excpm_id    = @L_excpm_id
                       AND    docm.docm_deleted_ind = 0)
                       BEGIN
                       --
                         SET @L_EXISTS = 1
                       --
                       END
                       ELSE
                       BEGIN
                       --
                         SET @L_EXISTS = 0
                       --
                       END
                       
                       IF @L_EXISTS=0
                       BEGIN
                       --
                         BEGIN TRANSACTION

                         SELECT @L_DOCMM_ID = ISNULL(MAX(DOCM_ID),0)+1
                         FROM DOCUMENT_MSTR_MAK
                         
                         SELECT @L_DOCM_ID = ISNULL(MAX(DOCM_ID),0)+1
                         FROM DOCUMENT_MSTR
                         
                         IF @L_DOCMM_ID>@L_DOCM_ID
                         BEGIN
                         --
                           SET @L_DOCM_ID = @L_DOCMM_ID
                         --
                         END

                         INSERT INTO DOCUMENT_MSTR_MAK
                         (DOCM_ID
                         ,DOCM_DOC_ID
                         ,DOCM_CLICM_ID
                         ,DOCM_ENTTM_ID
                         ,DOCM_EXCPM_ID
                         ,DOCM_CD
                         ,DOCM_DESC
                         ,DOCM_RMKS
                         ,DOCM_CREATED_BY
                         ,DOCM_CREATED_DT
                         ,DOCM_LST_UPD_BY
                         ,DOCM_LST_UPD_DT
                         ,DOCM_DELETED_IND
                         ,DOCM_MDTY
                         )
                         VALUES
                         (@L_DOCM_ID
                         ,@L_DOCM_DOC_ID
                         ,@L_CLICM_ID
                         ,@L_ENTTM_ID
                         ,@L_EXCPM_ID
                         ,@PA_DOCM_CD
                         ,@PA_DOCM_DESC
                         ,@PA_DOCM_RMKS
                         ,@PA_LOGIN_NAME 
                         ,GETDATE()
                         ,@PA_LOGIN_NAME
                         ,GETDATE()
                         ,0
                         ,@L_MND_FLG
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
                       END --EXIST=0
                       IF @L_EXISTS=1
                       BEGIN
                       --
                         BEGIN TRANSACTION
                       --
                         UPDATE DOCUMENT_MSTR_MAK  WITH (ROWLOCK)
                         SET   DOCM_DELETED_IND = 2
                              ,DOCM_LST_UPD_BY  = @PA_LOGIN_NAME
                              ,DOCM_LST_UPD_DT  = GETDATE()
                         WHERE  DOCM_DOC_ID      = @L_DOCM_DOC_ID
																									AND    DOCM_CLICM_ID    = @L_CLICM_ID
																									AND    DOCM_ENTTM_ID    = @L_ENTTM_ID
																									AND    DOCM_EXCPM_ID    = @L_EXCPM_ID
                         AND    docm_deleted_ind = 0
                       --
                         SET @L_ERROR = @@ERROR
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
                           SELECT @L_DOCM_ID = ISNULL(MAX(DOCM_ID),0)+1
                           FROM DOCUMENT_MSTR_MAK

                           INSERT INTO DOCUMENT_MSTR_MAK
                           (DOCM_ID
                           ,DOCM_DOC_ID
                           ,DOCM_CLICM_ID
                           ,DOCM_ENTTM_ID
                           ,DOCM_EXCPM_ID
                           ,DOCM_CD
                           ,DOCM_DESC
                           ,DOCM_RMKS
                           ,DOCM_CREATED_BY
                           ,DOCM_CREATED_DT
                           ,DOCM_LST_UPD_BY
                           ,DOCM_LST_UPD_DT
                           ,DOCM_DELETED_IND
                           ,DOCM_MDTY
                           ) 
                           VALUES
                           (@L_DOCM_ID
                           ,@L_DOCM_DOC_ID
                           ,@L_CLICM_ID
                           ,@L_ENTTM_ID
                           ,@L_EXCPM_ID
                           ,@PA_DOCM_CD
                           ,@PA_DOCM_DESC
                           ,@PA_DOCM_RMKS
                           ,@PA_LOGIN_NAME
                           ,GETDATE()
                           ,@PA_LOGIN_NAME
                           ,GETDATE()
                           ,0
                           ,@L_MND_FLG
                           )
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
                         END
                         --
                       END--EXIST=1
                       ELSE
                       BEGIN
                       --
                         SET @L_ERRORSTR = 'One Or All Of The Parameters Is/Are Null'
                       --
                       END
                  --
                  END
                  ELSE IF @L_MND_FLG=2
                  BEGIN
                  --
                    BEGIN TRANSACTION
                    --
                    SELECT @l_docm_id = ISNULL(DOCM_ID ,0)
                    FROM DOCUMENT_MSTR 
                    WHERE DOCM_DOC_ID=@pa_docm_doc_id
                    AND   DOCM_ENTTM_ID= @l_enttm_id
                    AND   DOCM_CLICM_ID= @l_clicm_id
                    AND   DOCM_EXCPM_ID= @l_excpm_id
                    AND   DOCM_DELETED_IND=1
                   
                    IF @L_DOCM_ID<>0
                    BEGIN
                    --
                      INSERT INTO document_mstr_mak
                      ( docm_id
                      , docm_doc_id
                      , docm_clicm_id
                      , docm_enttm_id
                      , docm_excpm_id
                      , docm_cd
                      , docm_desc
                      , docm_mdty
                      , docm_rmks
                      , docm_created_by
                      , docm_created_dt
                      , docm_lst_upd_by
                      , docm_lst_upd_dt
                      , docm_deleted_ind
                      )
                      VALUES
                      ( @l_docm_id
                      , @pa_docm_doc_id
                      , @l_clicm_id
                      , @l_enttm_id
                      , @l_excpm_id
                      , @pa_docm_cd
                      , @pa_docm_desc
                      , @l_mnd_flg 
                      , @pa_docm_rmks
                      , @pa_login_name, GETDATE(), @pa_login_name, GETDATE(), 6
                      )
                    --
                    END
                    ELSE
                    BEGIN
                    --
                      UPDATE DOCUMENT_MSTR_MAK  WITH (ROWLOCK)
                      SET    DOCM_DELETED_IND = 6
                            ,DOCM_LST_UPD_BY  = @PA_LOGIN_NAME
                            ,DOCM_LST_UPD_DT  = GETDATE()
                      WHERE DOCM_DOC_ID=@pa_docm_doc_id
                      AND   DOCM_ENTTM_ID= @l_enttm_id
                      AND   DOCM_CLICM_ID= @l_clicm_id
                      AND   DOCM_EXCPM_ID= @l_excpm_id
                    --
                    END
                    IF @@ERROR > 0
                    BEGIN
                    --
                      ROLLBACK TRANSACTION
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
                  END
                  ELSE
                  BEGIN
                  --
                    SET @L_ERRORSTR = 'One Or All Of The Parameters Is/Are Null'
                  --
                  END
                 --
               END--CD
              --
             END --#4
            --
           END--#3
         END
        --
       END
       --
      END--#2
       --
    END--#1

    IF ISNULL(RTRIM(LTRIM(@L_ERRORSTR)),'') = ''
    BEGIN
    --
      SET @L_ERRORSTR = 'Documents Successfully Inserted\Edited '+ @ROWDELIMITER
    --
    END
    ELSE
    BEGIN
    --
      SET @PA_ERRMSG = @L_ERRORSTR
    --
    END

END --MAIN BEGIN

GO
