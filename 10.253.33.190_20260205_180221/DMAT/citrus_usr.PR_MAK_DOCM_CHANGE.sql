-- Object: PROCEDURE citrus_usr.PR_MAK_DOCM_CHANGE
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--
--PR_MAK_DOCM_CHANGE '0','INS','SS',1,'SUKHI1','SUKHI2','RMKS','BSE|*~|DERIVATIVES|*~|1|*~|12|*~|10|*~|M|*~|*|~*',0,'','|*~|','*|~*'
CREATE PROCEDURE [citrus_usr].[PR_MAK_DOCM_CHANGE](@PA_ID            VARCHAR(8000)
                                   ,@PA_ACTION        VARCHAR(20)
                                   ,@PA_LOGIN_NAME    VARCHAR(20)
                                   ,@PA_DOCM_DOC_ID   INT
                                   ,@PA_DOCM_CD       VARCHAR(20)
                                   ,@PA_DOCM_DESC     VARCHAR(20)
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
 VERS.  AUTHOR            DATE        REASON
 -----  -------------     ----------   -------------------------------------------------
 1.0    SUKHVINDER/TUSHAR 15-DEC-2006
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
        , @L_SDOCM_ID           BIGINT
        , @L_DOCM_ID            BIGINT
        , @L_DOCM_DOC_ID        BIGINT
        , @L_DELIMETER          VARCHAR(10)
        , @L_EXCH_CD            VARCHAR(25)
        , @L_SEG_CD             VARCHAR(25)
        , @L_PROM_ID            NUMERIC
        , @L_ENTTM_ID           NUMERIC
        , @L_CLICM_ID           NUMERIC
        , @L_MND_FLG            CHAR(2)
        , @L_EXCPM_ID           NUMERIC
  --
  SET @L_ERRORSTR          = ''
  SET @L_DELIMETER         = '%'+ @ROWDELIMITER + '%'
  SET @@DELIMETERLENGTH    = LEN(@ROWDELIMITER)
  SET @@REMAININGSTRING_ID = @PA_VALUES
  --
  IF (ISNULL(@PA_ID, '') <> '') AND (ISNULL(@PA_ACTION, '') <> '') AND (ISNULL(@PA_LOGIN_NAME, '')<> '') --#00
  BEGIN
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
       SET @@REMAININGSTRING_VAL = @PA_VALUES
       --
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
           SET @L_PROM_ID  = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,3)
           SET @L_ENTTM_ID = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,4)
           SET @L_CLICM_ID = citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,5)
           SET @L_MND_FLG  = CASE citrus_usr.FN_SPLITVAL(@@CURRSTRING_VAL,6) WHEN 'M' THEN '1' ELSE '0' END
           --
           IF @PA_CHK_YN = 0
           BEGIN--#CHKYN=0
           --
             IF @pa_action = 'INS'
             BEGIN --#INS
             --
               SELECT @L_DOCM_ID = isnull(MAX(DOCM_ID),0)+1
               FROM  DOCUMENT_MSTR WITH (NOLOCK)
               --
               IF EXISTS(SELECT DOCM_DOC_ID
                         FROM DOCUMENT_MSTR WITH (NOLOCK)
                         WHERE DOCM_CD = @PA_DOCM_CD
                         AND   DOCM_DELETED_IND IN(1,0)
                         )
               BEGIN --#EXIST
               --
                 SELECT @L_DOCM_DOC_ID = MAX(isnull(DOCM_DOC_ID,0))
                 FROM DOCUMENT_MSTR  WITH (NOLOCK)
                 WHERE DOCM_DELETED_IND IN(1,0)
                 AND DOCM_CD = @PA_DOCM_CD
               --
               END --#EXIST
               ELSE
               BEGIN --#NOT EXIST
               --
                 SELECT @L_DOCM_DOC_ID = MAX(isnull(DOCM_DOC_ID,0))+1
                 FROM DOCUMENT_MSTR  WITH (NOLOCK)
                 WHERE DOCM_DELETED_IND IN(1,0)
               --
               END --#NOT EXIST
               --
               SELECT @L_EXCPM_ID        = EXCPM.EXCPM_ID
               FROM EXCH_SEG_MSTR EXCSM,EXCSM_PROD_MSTR EXCPM
               WHERE EXCPM.EXCPM_EXCSM_ID= EXCSM.EXCSM_ID
               AND EXCSM.EXCSM_EXCH_CD   = @L_EXCH_CD
               AND EXCSM.EXCSM_SEG_CD    = @L_SEG_CD
               AND EXCPM.EXCPM_PROM_ID   = @L_PROM_ID
               --
               IF ISNULL(@L_EXCPM_ID, 0) <> 0
               BEGIN --#@L_EXCPM_ID <> 0
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
                 ,1
                 ,@L_MND_FLG
                 )
                 --
                 IF @@ERROR > 0
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
               END --#@L_EXCPM_ID <> 0
             --
             END --#INS
           --
           END  --#CHKYN=0
         --
         END  --#4
       --
       END --#3
     --
     END  --#2
    --
    END--#1
  --
  END --#00
--
END --#END OF BEGIN

GO
