-- Object: PROCEDURE citrus_usr.PR_MAK_CONCM
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--PR_MAK_CONCM  '35','EDT','HO','DDDF','DDD', 4|*~| 0 7 C 1 *|~*  |*~|
CREATE   PROCEDURE [citrus_usr].[PR_MAK_CONCM](@PA_ID                VARCHAR(8000)
                              ,@PA_ACTION            VARCHAR(20)
                              ,@PA_LOGIN_NAME        VARCHAR(20)
                              ,@PA_CONCM_CD          VARCHAR(20)
                              ,@PA_CONCM_DESC        VARCHAR(200)
                              ,@PA_CONCM_CLI_YN      VARCHAR(20)
                              ,@PA_BUSM_ID           VARCHAR(25)          
                              ,@PA_ADR_CONC          VARCHAR(20)
                              ,@PA_CONCM_RMKS        VARCHAR(200)
                              ,@PA_CHK_YN            INT
                              ,@ROWDELIMITER         CHAR(4)
                              ,@COLDELIMITER         CHAR(4)
                              ,@PA_ERRMSG            VARCHAR(8000) OUTPUT
)
AS
/*
*********************************************************************************
 SYSTEM         : CLASS
 MODULE NAME    : PR_MAK_CONCM
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE MAKER CHECKER FACILITY FOR CONTRACT CHANNEL MASTER
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.
 VERSION HISTORY:
 VERS.  AUTHOR           DATE        REASON
 -----  -------------   ----------   -------------------------------------------------
 1.0    HARI R          18-SEP-2006  INITIAL VERSION.
 2.0    HARI R          22-SEP-2006  NEWFIELD(CONCM_CLI_YN) IN THE TABLE AND TWO NEW
                                     PAREMETERS(@PA_CONCM_CLI_YN,@PA_ADR_CONC) IN THE PROCEDURE
-----------------------------------------------------------------------------------*/
--
BEGIN
  --
  SET NOCOUNT ON
  --
  DECLARE @@T_ERRORSTR      VARCHAR(8000)
        , @L_CMCONCM_ID     BIGINT
        , @L_CONCM_ID       BIGINT
        , @@L_ERROR         BIGINT
        , @DELIMETER        VARCHAR(10)
        , @@REMAININGSTRING VARCHAR(8000)
        , @@CURRSTRING      VARCHAR(8000)
        , @@FOUNDAT         INTEGER
        , @@DELIMETERLENGTH INT
        , @@L_ENTTM_CLI_YN  INT
        , @l_busm_cd        VARCHAR(50)
        , @l_access_cd      VARCHAR(50)
        , @l_counter        NUMERIC
        , @l                NUMERIC
        , @l_busm_id        NUMERIC
  --
  SET @@L_ERROR = 0
  SET @@T_ERRORSTR = ''
  SET @@L_ENTTM_CLI_YN = 0
  SET @DELIMETER = '%'+ @ROWDELIMITER + '%'
  SET @@DELIMETERLENGTH = LEN(@ROWDELIMITER)
  SET @@REMAININGSTRING = @PA_ID
  --
  WHILE @@REMAININGSTRING <> ''
  BEGIN
   --
   SET @@FOUNDAT = 0
   SET @@FOUNDAT =  PATINDEX('%'+@DELIMETER+'%',@@REMAININGSTRING)
   --
   IF @@FOUNDAT > 0
   BEGIN
     --
     SET @@CURRSTRING      = SUBSTRING(@@REMAININGSTRING, 0,@@FOUNDAT)
     SET @@REMAININGSTRING = SUBSTRING(@@REMAININGSTRING, @@FOUNDAT+@@DELIMETERLENGTH,LEN(@@REMAININGSTRING)- @@FOUNDAT+@@DELIMETERLENGTH)
     --
   END
   ELSE
   BEGIN
     --
     SET @@CURRSTRING      = @@REMAININGSTRING
     SET @@REMAININGSTRING = ''
     --
   END
   --
   IF @@CURRSTRING <> ''
   BEGIN
     --
     IF @PA_CONCM_CLI_YN = 1
     BEGIN
       --
       SET @@L_ENTTM_CLI_YN = 1 | @@L_ENTTM_CLI_YN
       --
     END

     IF @PA_ADR_CONC = 'C'
     BEGIN
     --
       SET @@L_ENTTM_CLI_YN = 2 | @@L_ENTTM_CLI_YN
     --
     END
     
     IF @PA_BUSM_ID <> ''
     BEGIN
     --
        SET @l_counter = citrus_usr.ufn_countstring(@pa_busm_id,'|*~|')
        SET @l         = 1

        WHILE @l <= @l_counter 
        BEGIN
        --
          SET @l_busm_id       = citrus_usr.fn_splitval(@pa_busm_id,@l)  

          SELECT @l_busm_cd    = busm_cd  FROM business_mstr WHERE busm_deleted_ind = 1 and busm_id = @l_busm_id

          SELECT @l_access_cd  = CASE WHEN @l_busm_cd ='ALL'  THEN 'BUS_%' 
                                      ELSE 'BUS_' + @l_busm_cd 
                                      END
          SET @@L_ENTTM_CLI_YN = citrus_usr.fn_get_busm_access(@l_access_cd) | @@L_ENTTM_CLI_YN  

          SET @l = @l + 1
        --
        END
     --
     END
     --
     IF @PA_ACTION = 'INS'  --ACTION TYPE = INS BEGINS HERE
     BEGIN
       --
       IF @PA_CHK_YN = 0 -- IF MAKER CHECKER FUNCTIONALITY IS NOT REQD
       BEGIN
         --
         BEGIN TRANSACTION
         --
         SELECT @L_CONCM_ID = ISNULL(MAX(CONCM_ID),0)+1
         FROM  CONC_CODE_MSTR WITH (NOLOCK)
         --
         INSERT INTO CONC_CODE_MSTR
         ( CONCM_ID
         , CONCM_CD
         , CONCM_DESC
         , CONCM_CLI_YN
         , CONCM_RMKS
         , CONCM_CREATED_BY
         , CONCM_CREATED_DT
         , CONCM_LST_UPD_BY
         , CONCM_LST_UPD_DT
         , CONCM_DELETED_IND
         )
         VALUES
         ( @L_CONCM_ID
         , @PA_CONCM_CD
         , @PA_CONCM_DESC
         , @@L_ENTTM_CLI_YN
         , @PA_CONCM_RMKS
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
         BEGIN
         --
            --SET @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_CONCM_CD+@COLDELIMITER+@PA_CONCM_DESC+@COLDELIMITER+@PA_CONCM_CLI_YN+@COLDELIMITER+@PA_ADR_CONC+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(@L_CONCM_ID,1),'0')+@COLDELIMITER+ISNULL(@PA_CONCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
            SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_CONCM_CD+@COLDELIMITER+@PA_CONCM_DESC+@COLDELIMITER+@PA_CONCM_CLI_YN+@COLDELIMITER+@PA_ADR_CONC+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(@L_CONCM_ID-1,2,0),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(@L_CONCM_ID-1,1,0),'0')+@COLDELIMITER+ISNULL(@PA_CONCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
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
       IF @PA_CHK_YN = 1 -- IF MAKER IS INSERTING
       BEGIN
         --
         SELECT @L_CMCONCM_ID=ISNULL(MAX(CM.CONCM_ID),0)+1 FROM CONC_CODE_MSTR_MAK CM  WITH (NOLOCK)
         --
         SELECT @L_CONCM_ID=ISNULL(MAX(C.CONCM_ID),0)+1 FROM CONC_CODE_MSTR C  WITH (NOLOCK)
         --
         IF @L_CMCONCM_ID > @L_CONCM_ID
         BEGIN
         --
           SET  @L_CONCM_ID = @L_CMCONCM_ID
         --
         END
         --
         BEGIN TRANSACTION
         --
         INSERT INTO CONC_CODE_MSTR_MAK
         ( CONCM_ID
         , CONCM_CD
         , CONCM_DESC
         , CONCM_CLI_YN
         , CONCM_RMKS
         , CONCM_CREATED_BY
         , CONCM_CREATED_DT
         , CONCM_LST_UPD_BY
         , CONCM_LST_UPD_DT
         , CONCM_DELETED_IND
         )
         VALUES
         ( @L_CONCM_ID
         , @PA_CONCM_CD
         , @PA_CONCM_DESC
         , @@L_ENTTM_CLI_YN
         , @PA_CONCM_RMKS
         , @PA_LOGIN_NAME
         , GETDATE()
         , @PA_LOGIN_NAME
         , GETDATE()
         , 0
         )
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR  > 0
         BEGIN
         --
           --SET @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_CONCM_CD+@COLDELIMITER+@PA_CONCM_DESC+@COLDELIMITER+@PA_CONCM_CLI_YN+@COLDELIMITER+@PA_ADR_CONC+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(@L_CONCM_ID,1),'0')+@COLDELIMITER+ISNULL(@PA_CONCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
           SET @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_CONCM_CD+@COLDELIMITER+@PA_CONCM_DESC+@COLDELIMITER+@PA_CONCM_CLI_YN+@COLDELIMITER+@PA_ADR_CONC+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(@L_CONCM_ID-1,2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(@L_CONCM_ID-1,1,1),'0')+@COLDELIMITER+ISNULL(@PA_CONCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
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
     END  --ACTION TYPE = INS ENDS HERE
     --
     IF @PA_ACTION = 'APP'    --ACTION TYPE = APP STARTS HERE
     BEGIN
       --
       IF EXISTS(SELECT CONCM_ID
                 FROM   CONC_CODE_MSTR  WITH (NOLOCK)
                 WHERE  CONCM_ID = CONVERT(INT, @@CURRSTRING))
       BEGIN
         --
         BEGIN TRANSACTION
         --
         UPDATE CONCM  WITH (ROWLOCK)
         SET    CONCM.CONCM_CD             = CONCMM.CONCM_CD
              , CONCM.CONCM_DESC           = CONCMM.CONCM_DESC
              , CONCM.CONCM_CLI_YN         = CONCMM.CONCM_CLI_YN
              , CONCM.CONCM_LST_UPD_BY     = @PA_LOGIN_NAME
              , CONCM.CONCM_LST_UPD_DT     = GETDATE()
              , CONCM.CONCM_DELETED_IND    = 1
         FROM   CONC_CODE_MSTR               CONCM
              , CONC_CODE_MSTR_MAK           CONCMM
         WHERE  CONCM.CONCM_ID             = CONVERT(INT,@@CURRSTRING)
         AND    CONCMM.CONCM_ID            = CONCM.CONCM_ID
         AND    CONCM.CONCM_DELETED_IND    = 1
         AND    CONCMM.CONCM_DELETED_IND   = 0
         AND    CONCMM.CONCM_CREATED_BY    <> @PA_LOGIN_NAME
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR  > 0
         BEGIN
         --
           SELECT @@T_ERRORSTR     = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+CONCM_CD+@COLDELIMITER+CONCM_DESC+@COLDELIMITER+CONVERT(VARCHAR,CONCM_CLI_YN)+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),1,1),'0')+@COLDELIMITER+ISNULL(CONCM_RMKS,'')+@COLDELIMITER+(CASE WHEN 2 & CONCM_CLI_YN =2 THEN 'C' ELSE 'A' END)+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
           FROM  CONC_CODE_MSTR_MAK  WITH (NOLOCK)
           WHERE CONCM_ID          = CONVERT(INT, @@CURRSTRING)
           AND   CONCM_DELETED_IND = 0
           --
           ROLLBACK TRANSACTION
         --
         END
         ELSE
         BEGIN
         --
           UPDATE CONC_CODE_MSTR_MAK  WITH (ROWLOCK)
           SET    CONCM_DELETED_IND  = 1
                , CONCM_LST_UPD_BY   = @PA_LOGIN_NAME
                , CONCM_LST_UPD_DT   = GETDATE()
           WHERE  CONCM_ID           = CONVERT(INT,@@CURRSTRING)
           AND    CONCM_CREATED_BY   <> @PA_LOGIN_NAME
           AND    CONCM_DELETED_IND  = 0
           --
           SET @@L_ERROR = @@ERROR
           --
           IF @@L_ERROR  > 0
           BEGIN                     --IF ANY ERROR REPORTED THE GENERATE THE ERROR MESSAGE STRING
             --
             SELECT @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+CONCM_CD+@COLDELIMITER+CONCM_DESC+@COLDELIMITER+CONVERT(VARCHAR,CONCM_CLI_YN)+@COLDELIMITER+(CASE WHEN 2 & CONCM_CLI_YN =2 THEN 'C' ELSE 'A' END)+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),1,1),'0')+@COLDELIMITER+ISNULL(CONCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
             FROM  CONC_CODE_MSTR_MAK  WITH (NOLOCK)
             WHERE CONCM_ID          = CONVERT(INT,@@CURRSTRING)
             AND   CONCM_DELETED_IND = 0
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
       ELSE
       BEGIN
         --
         BEGIN TRANSACTION
         --
         INSERT INTO CONC_CODE_MSTR
         ( CONCM_ID
         , CONCM_CD
         , CONCM_DESC
         , CONCM_CLI_YN
         , CONCM_CREATED_BY
         , CONCM_CREATED_DT
         , CONCM_LST_UPD_BY
         , CONCM_LST_UPD_DT
         , CONCM_DELETED_IND
         )
         SELECT CONCMM.CONCM_ID
              , CONCMM.CONCM_CD
              , CONCMM.CONCM_DESC
              , CONCMM.CONCM_CLI_YN
              , CONCMM.CONCM_CREATED_BY
              , CONCMM.CONCM_CREATED_DT
              , @PA_LOGIN_NAME
              , GETDATE()
              , 1
         FROM   CONC_CODE_MSTR_MAK           CONCMM  WITH (NOLOCK)
         WHERE  CONCMM.CONCM_ID           = CONVERT(INT,@@CURRSTRING)
         AND    CONCMM.CONCM_CREATED_BY  <> @PA_LOGIN_NAME
         AND    CONCMM.CONCM_DELETED_IND  = 0
         --
         SET @@L_ERROR = CONVERT(INT, @@ERROR)
         --
         IF @@L_ERROR  > 0
         BEGIN
           --
           SELECT @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+CONCM_CD+@COLDELIMITER+CONCM_DESC+@COLDELIMITER+CONVERT(VARCHAR,CONCM_CLI_YN)+@COLDELIMITER+(CASE WHEN 2 & CONCM_CLI_YN =2 THEN 'C' ELSE 'A' END)+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),1,1),'0')+@COLDELIMITER+ISNULL(CONCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
           FROM   CONC_CODE_MSTR_MAK  WITH (NOLOCK)
           WHERE  CONCM_ID          = CONVERT(INT,@@CURRSTRING)
           AND    CONCM_DELETED_IND = 0
           --
           ROLLBACK TRANSACTION
           --
         END
         ELSE
         BEGIN
           --
           UPDATE CONC_CODE_MSTR_MAK  WITH (ROWLOCK)
           SET    CONCM_DELETED_IND  = 1
                , CONCM_LST_UPD_BY   = @PA_LOGIN_NAME
                , CONCM_LST_UPD_DT   = GETDATE()
           WHERE  CONCM_ID           = CONVERT(INT,@@CURRSTRING)
           AND    CONCM_CREATED_BY  <> @PA_LOGIN_NAME
           AND    CONCM_DELETED_IND  = 0
           --
           SET @@L_ERROR = @@ERROR
           --
           IF  @@L_ERROR > 0
           BEGIN
             --
             SELECT @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+CONCM_CD+@COLDELIMITER+CONCM_DESC+@COLDELIMITER+CONVERT(VARCHAR,CONCM_CLI_YN)+@COLDELIMITER+(CASE WHEN 2 & CONCM_CLI_YN =2 THEN 'C' ELSE 'A' END)+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),1,1),'0')+@COLDELIMITER+ISNULL(CONCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
             FROM  CONC_CODE_MSTR_MAK  WITH (NOLOCK)
             WHERE CONCM_ID          = CONVERT(INT,@@CURRSTRING)
             AND   CONCM_DELETED_IND = 0
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

     IF @PA_ACTION = 'REJ'    --ACTION TYPE = REJ BEGINS HERE
     BEGIN
       --
       IF @PA_CHK_YN = 1 -- IF CHECKER IS REJECTING
       BEGIN
         --
         BEGIN TRANSACTION
         --
         UPDATE CONC_CODE_MSTR_MAK  WITH (ROWLOCK)
         SET    CONCM_DELETED_IND = 3
              , CONCM_LST_UPD_BY  = @PA_LOGIN_NAME
              , CONCM_LST_UPD_DT  = GETDATE()
         WHERE  CONCM_ID          = CONVERT(INT,@@CURRSTRING)
         AND    CONCM_DELETED_IND = 0
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR > 0      --IF ANY ERROR REPORTS THEN GENERATE THE ERROR STRING
         BEGIN
           --
           SELECT @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+CONCM_CD+@COLDELIMITER+CONCM_DESC+@COLDELIMITER+CONVERT(VARCHAR,CONCM_CLI_YN)+@COLDELIMITER+(CASE WHEN 2 & CONCM_CLI_YN =2 THEN 'C' ELSE 'A' END)+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),1,1),'0')+@COLDELIMITER+ISNULL(CONCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
           FROM  CONC_MSTR_MAK  WITH (NOLOCK)
           WHERE CONCM_ID    =   CONVERT(INT,@@CURRSTRING)
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
     END          --ACTION TYPE = REJ ENDS HERE
     --
     IF @PA_ACTION = 'DEL' --ACTION TYPE = DEL BEGINS HERE
     BEGIN
       --
       BEGIN TRANSACTION
       --
       UPDATE CONC_CODE_MSTR  WITH (ROWLOCK)
       SET    CONCM_DELETED_IND = 0
            , CONCM_LST_UPD_BY  = @PA_LOGIN_NAME
            , CONCM_LST_UPD_DT  = GETDATE()
       WHERE  CONCM_ID          = CONVERT(INT,@@CURRSTRING)
       --
       SET @@L_ERROR = @@ERROR
       --
       IF @@L_ERROR > 0     --IF ANY ERROR REPORTS THEN GENERATE THE ERROR STRING
       BEGIN
         --
         SELECT @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+CONCM_CD+@COLDELIMITER+CONCM_DESC+@COLDELIMITER+CONVERT(VARCHAR,CONCM_CLI_YN)+@COLDELIMITER+(CASE WHEN 2 & CONCM_CLI_YN =2 THEN 'C' ELSE 'A' END)+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),2,0),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),1,0),'0')+@COLDELIMITER+ISNULL(CONCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
         FROM   CONC_CODE_MSTR      WITH (NOLOCK)
         WHERE  CONCM_ID          = CONVERT(INT,@@CURRSTRING)
         AND    CONCM_DELETED_IND = 1
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
     END  --ACTION TYPE = DEL ENDS HERE
     --
     IF @PA_ACTION = 'EDT'  --ACTION TYPE = EDT BEGINS HERE
     BEGIN
       --
       IF @PA_CHK_YN = 0 -- IF NO MAKER CHECKER
       BEGIN
         --
         BEGIN TRANSACTION
         --
         UPDATE CONC_CODE_MSTR  WITH (ROWLOCK)
         SET    CONCM_CD         = @PA_CONCM_CD
              , CONCM_DESC       = @PA_CONCM_DESC
              , CONCM_CLI_YN     = @@L_ENTTM_CLI_YN
              , CONCM_RMKS       = @PA_CONCM_RMKS
              , CONCM_LST_UPD_BY = @PA_LOGIN_NAME
              , CONCM_LST_UPD_DT = GETDATE()
         WHERE  CONCM_ID         = CONVERT(INT, @@CURRSTRING)
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR > 0
         BEGIN
           --
           SET @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_CONCM_CD+@COLDELIMITER+@PA_CONCM_DESC+@COLDELIMITER+@PA_CONCM_CLI_YN+@COLDELIMITER+@PA_ADR_CONC+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),2,0),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),1,0),'0')+@COLDELIMITER+ISNULL(@PA_CONCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
           --
           ROLLBACK TRANSACTION
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
       IF @PA_CHK_YN = 1 -- IF MAKER OR CHEKER IS EDITING
       BEGIN
         --
         BEGIN TRANSACTION
         --
         UPDATE CONC_CODE_MSTR_MAK  WITH (ROWLOCK)
         SET    CONCM_DELETED_IND = 2
              , CONCM_LST_UPD_BY  = @PA_LOGIN_NAME
              , CONCM_LST_UPD_DT  = GETDATE()
         WHERE  CONCM_ID          = CONVERT(INT, @@CURRSTRING)
         AND    CONCM_DELETED_IND = 0
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR > 0
         BEGIN
           --
           SET @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_CONCM_CD+@COLDELIMITER+@PA_CONCM_DESC+@COLDELIMITER+@PA_CONCM_CLI_YN+@COLDELIMITER+@PA_ADR_CONC+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),1,1),'0')+@COLDELIMITER+ISNULL(@PA_CONCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
           --
           ROLLBACK TRANSACTION
           --
         END
         ELSE
         BEGIN
           --
           INSERT INTO CONC_CODE_MSTR_MAK
           ( CONCM_ID
           , CONCM_CD
           , CONCM_DESC
           , CONCM_CLI_YN
           , CONCM_RMKS
           , CONCM_CREATED_BY
           , CONCM_CREATED_DT
           , CONCM_LST_UPD_BY
           , CONCM_LST_UPD_DT
           , CONCM_DELETED_IND
           )
           VALUES
           ( CONVERT(INT,@@CURRSTRING)
           , @PA_CONCM_CD
           , @PA_CONCM_DESC
           , @@L_ENTTM_CLI_YN
           , @PA_CONCM_RMKS
           , @PA_LOGIN_NAME
           , GETDATE()
           , @PA_LOGIN_NAME
           , GETDATE()
           , 0
           )
           --
           SET @@L_ERROR = @@ERROR
           --
           IF @@L_ERROR > 0
           BEGIN
             --
             SET @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_CONCM_CD+@COLDELIMITER+@PA_CONCM_DESC+@COLDELIMITER+@PA_CONCM_CLI_YN+@COLDELIMITER+@PA_ADR_CONC+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_concm_bit(CONVERT(INT, @@CURRSTRING),1,1),'0')+@COLDELIMITER+ISNULL(@PA_CONCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
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
     END  --ACTION TYPE = EDT ENDS HERE
    --
   END
   --
  SET @PA_ERRMSG = @@T_ERRORSTR
  --
  END
  --
END

GO
