-- Object: PROCEDURE citrus_usr.PR_MAK_DPTM
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--PR_MAK_DPM '5','EDT','SS','LSDL','LSDL','LDSL',0, '*|~*','|*~|',''
CREATE PROCEDURE [citrus_usr].[PR_MAK_DPTM]( @PA_ID          VARCHAR(8000)
                            , @PA_ACTION      VARCHAR(20)
                            , @PA_LOGIN_NAME  VARCHAR(20)
                            , @PA_DPTM_CD     VARCHAR(20)   = ''
                            , @PA_DPTM_DESC   VARCHAR(20)   = ''
                            , @PA_DPTM_RMKS   VARCHAR(200)
                            , @PA_CHK_YN      INT
                            , @ROWDELIMITER   CHAR(4)       = '*|~*'
                            , @COLDELIMITER   CHAR(4)       = '|*~|'
                            , @PA_ERRMSG      VARCHAR(8000) OUTPUT
)
AS
/*
*********************************************************************************
 SYSTEM         : CLASS
 MODULE NAME    : PR_MAK_DPTM
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE MAKER CHECKER FACILITY FOR DP_TYPE MASTER
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  --------------------------------------------------
 1.0    SUKHVINDER/TUSHAR 04-JAN-2007    VERSION.
-----------------------------------------------------------------------------------*/
--
BEGIN
--
  SET NOCOUNT ON
  --
  DECLARE @@T_ERRORSTR      VARCHAR(8000)
        , @L_DPTMM_ID       BIGINT
        , @L_DPTM_ID        BIGINT
        , @@L_ERROR         BIGINT
        , @DELIMETER        VARCHAR(10)
        , @@REMAININGSTRING VARCHAR(8000)
        , @@CURRSTRING      VARCHAR(8000)
        , @@FOUNDAT         INTEGER
        , @@DELIMETERLENGTH INT
  --
  SET @@L_ERROR = 0
  SET @@T_ERRORSTR =''
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
     IF @PA_ACTION = 'INS'
     BEGIN
     --
       IF @PA_CHK_YN = 0 -- IF MAKER CHECKER FUNCTIONALITY IS NOT REQD
       BEGIN
       --
         BEGIN TRANSACTION
         --
         SELECT @L_DPTM_ID = ISNULL(MAX(DPTM_ID), 0) + 1
         FROM  DP_TYPE_MSTR WITH (NOLOCK)
         --
         INSERT INTO DP_TYPE_MSTR
         ( DPTM_ID
         , DPTM_CD
         , DPTM_DESC
         , DPTM_RMKS
         , DPTM_CREATED_BY
         , DPTM_CREATED_DT
         , DPTM_LST_UPD_BY
         , DPTM_LST_UPD_DT
         , DPTM_DELETED_IND
         )
         VALUES
         ( @L_DPTM_ID
         , @PA_DPTM_CD
         , @PA_DPTM_DESC
         , @PA_DPTM_RMKS
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
           ROLLBACK TRANSACTION
           --
           SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_DPTM_CD+@COLDELIMITER+@PA_DPTM_DESC+@COLDELIMITER+ISNULL(@PA_DPTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
         --
         END
         ELSE
         BEGIN
         --
           COMMIT TRANSACTION
         --
         END
       --
       END --END OF IF @PA_CHK_YN = 0
       --
       IF @PA_CHK_YN = 1 -- IF MAKER IS INSERTING
       BEGIN
       --
         BEGIN TRANSACTION
         --
         SELECT @L_DPTMM_ID = ISNULL(MAX(DPTMM.DPTM_ID),0)+1 FROM DP_TYPE_MSTR_MAK DPTMM WITH (NOLOCK)
         --
         SELECT @L_DPTM_ID = ISNULL(MAX(DTM.DPTM_ID),0)+1 FROM DP_TYPE_MSTR DTM WITH (NOLOCK)
         --
         IF @L_DPTMM_ID > @L_DPTM_ID
         BEGIN
         --
           SET  @L_DPTM_ID = @L_DPTMM_ID
         --
         END
         --
         INSERT INTO DP_TYPE_MSTR_MAK
         ( DPTM_ID
         , DPTM_CD
         , DPTM_DESC
         , DPTM_RMKS
         , DPTM_CREATED_BY
         , DPTM_CREATED_DT
         , DPTM_LST_UPD_BY
         , DPTM_LST_UPD_DT
         , DPTM_DELETED_IND)
         VALUES
         ( @L_DPTM_ID
         , @PA_DPTM_CD
         , @PA_DPTM_DESC
         , @PA_DPTM_RMKS
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
           ROLLBACK TRANSACTION
           --
           SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_DPTM_CD+@COLDELIMITER+@PA_DPTM_DESC+@COLDELIMITER+ISNULL(@PA_DPTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
         --
         END
         ELSE
         BEGIN
         --
           COMMIT TRANSACTION
         --
         END
       --
       END --END OF IF @PA_CHK_YN = 1
     --
     END  --ACTION TYPE = INS ENDS HERE
     --

     IF @PA_ACTION = 'APP'
     BEGIN
       --
       PRINT @@CURRSTRING
       IF EXISTS(SELECT DPTM_ID
                 FROM   DP_TYPE_MSTR
                 WHERE  DPTM_ID = CONVERT(INT, @@CURRSTRING)
                )
       BEGIN
         --
         BEGIN TRANSACTION
         --
         UPDATE DPTM WITH (ROWLOCK)
         SET    DPTM.DPTM_CD             = DPTMMAK.DPTM_CD
              , DPTM.DPTM_DESC           = DPTMMAK.DPTM_DESC
              , DPTM.DPTM_RMKS           = DPTMMAK.DPTM_RMKS
              , DPTM.DPTM_LST_UPD_BY     = @PA_LOGIN_NAME
              , DPTM.DPTM_LST_UPD_DT     = GETDATE()
              , DPTM.DPTM_DELETED_IND    = 1
         FROM   DP_TYPE_MSTR      DPTM
              , DP_TYPE_MSTR_MAK  DPTMMAK
         WHERE  DPTM.DPTM_ID             = CONVERT(INT,@@CURRSTRING)
         AND    DPTMMAK.DPTM_ID          = DPTM.DPTM_ID
         AND    DPTM.DPTM_DELETED_IND    = 1
         AND    DPTMMAK.DPTM_DELETED_IND = 0
         AND    DPTMMAK.DPTM_CREATED_BY <> @PA_LOGIN_NAME
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR  > 0
         BEGIN
         --
           SELECT @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+DPTM_CD+@COLDELIMITER+DPTM_DESC+@COLDELIMITER+ISNULL(DPTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
           FROM  DP_TYPE_MSTR_MAK WITH (NOLOCK)
           WHERE DPTM_ID = CONVERT(INT, @@CURRSTRING)
           AND   DPTM_DELETED_IND = 0
           --
           ROLLBACK TRANSACTION
         --
         END
         ELSE
         BEGIN
           --
           UPDATE DP_TYPE_MSTR_MAK WITH (ROWLOCK)
           SET    DPTM_DELETED_IND  = 1
                , DPTM_LST_UPD_BY   = @PA_LOGIN_NAME
                , DPTM_LST_UPD_DT   = GETDATE()
           WHERE  DPTM_ID           = CONVERT(INT,@@CURRSTRING)
           AND    DPTM_CREATED_BY  <> @PA_LOGIN_NAME
           AND    DPTM_DELETED_IND  = 0
           --
           SET @@L_ERROR = @@ERROR
           --
           IF @@L_ERROR  > 0
           BEGIN
           --
             SELECT @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+DPTM_CD+@COLDELIMITER+DPTM_DESC+@COLDELIMITER+ISNULL(DPTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
             FROM  DP_TYPE_MSTR_MAK WITH (NOLOCK)
             WHERE DPTM_ID          = CONVERT(INT,@@CURRSTRING)
             AND   DPTM_DELETED_IND = 0
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
         INSERT INTO DP_TYPE_MSTR
         ( DPTM_ID
         , DPTM_CD
         , DPTM_DESC
         , DPTM_RMKS
         , DPTM_CREATED_BY
         , DPTM_CREATED_DT
         , DPTM_LST_UPD_BY
         , DPTM_LST_UPD_DT
         , DPTM_DELETED_IND
         )
         SELECT DPTMM.DPTM_ID
              , DPTMM.DPTM_CD
              , DPTMM.DPTM_DESC
              , DPTMM.DPTM_RMKS
              , DPTMM.DPTM_CREATED_BY
              , DPTMM.DPTM_CREATED_DT
              , @PA_LOGIN_NAME
              , GETDATE()
              , 1
         FROM   DP_TYPE_MSTR_MAK           DPTMM WITH (NOLOCK)
         WHERE  DPTMM.DPTM_ID           = CONVERT(INT,@@CURRSTRING)
         AND    DPTMM.DPTM_CREATED_BY  <> @PA_LOGIN_NAME
         AND    DPTMM.DPTM_DELETED_IND  = 0
         --
         SET @@L_ERROR =  @@ERROR
         --
         IF @@L_ERROR  > 0
         BEGIN
           --
           SELECT @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+DPTM_CD+@COLDELIMITER+DPTM_DESC+@COLDELIMITER+ISNULL(DPTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
           FROM   DP_TYPE_MSTR_MAK WITH (NOLOCK)
           WHERE  DPTM_ID          = CONVERT(INT,@@CURRSTRING)
           AND    DPTM_DELETED_IND = 0
           --
           ROLLBACK TRANSACTION
           --
         END
         ELSE
         BEGIN
         --
           UPDATE DP_TYPE_MSTR_MAK WITH (ROWLOCK)
           SET    DPTM_DELETED_IND  = 1
                , DPTM_LST_UPD_BY   = @PA_LOGIN_NAME
                , DPTM_LST_UPD_DT   = GETDATE()
           WHERE  DPTM_ID           = CONVERT(INT,@@CURRSTRING)
           AND    DPTM_CREATED_BY  <> @PA_LOGIN_NAME
           AND    DPTM_DELETED_IND  = 0
           --
           SET @@L_ERROR = @@ERROR
           --
           IF @@L_ERROR > 0
           BEGIN
           --
             SELECT @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+DPTM_CD+@COLDELIMITER+DPTM_DESC+@COLDELIMITER+ISNULL(DPTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
             FROM  DP_TYPE_MSTR_MAK WITH (NOLOCK)
             WHERE DPTM_ID          = CONVERT(INT,@@CURRSTRING)
             AND   DPTM_DELETED_IND = 0
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

     IF @PA_ACTION ='REJ'
     BEGIN
       --
         BEGIN TRANSACTION
         --
         UPDATE DP_TYPE_MSTR_MAK WITH (ROWLOCK)
         SET    DPTM_DELETED_IND = 3
              , DPTM_LST_UPD_BY  = @PA_LOGIN_NAME
              , DPTM_LST_UPD_DT  = GETDATE()
         WHERE  DPTM_ID          = CONVERT(INT,@@CURRSTRING)
         AND    DPTM_DELETED_IND = 0
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR > 0
         BEGIN
           --
           SELECT @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+DPTM_CD+@COLDELIMITER+DPTM_DESC+@COLDELIMITER+ISNULL(DPTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
           FROM  DP_TYPE_MSTR_MAK WITH (NOLOCK)
           WHERE DPTM_ID = CONVERT(INT,@@CURRSTRING)
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
     --
     END          --ACTION TYPE = REJ ENDS HERE
     --
     IF @PA_ACTION = 'DEL'
     BEGIN
       --
       BEGIN TRANSACTION
       --
       UPDATE DP_TYPE_MSTR WITH (ROWLOCK)
       SET    DPTM_DELETED_IND = 0
            , DPTM_LST_UPD_BY  = @PA_LOGIN_NAME
            , DPTM_LST_UPD_DT  = GETDATE()
       WHERE   DPTM_ID         = CONVERT(INT,@@CURRSTRING)
       --
       SET @@L_ERROR = @@ERROR
       --
       IF @@L_ERROR > 0     --IF ANY ERROR REPORTS THEN GENERATE THE ERROR STRING
       BEGIN
       --
         SELECT @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+DPTM_CD+@COLDELIMITER+DPTM_DESC+@COLDELIMITER+ISNULL(DPTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
         FROM   DP_TYPE_MSTR WITH (NOLOCK)
         WHERE  DPTM_ID          = CONVERT(INT,@@CURRSTRING)
         AND    DPTM_DELETED_IND = 1
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
     IF @PA_ACTION = 'EDT'
     BEGIN
       --
       IF @PA_CHK_YN = 0 -- IF NO MAKER CHECKER
       BEGIN
       --
         BEGIN TRANSACTION
         --
         UPDATE DP_TYPE_MSTR WITH (ROWLOCK)
         SET    DPTM_CD          = @PA_DPTM_CD
              , DPTM_DESC        = @PA_DPTM_DESC
              , DPTM_RMKS        = @PA_DPTM_RMKS
              , DPTM_LST_UPD_BY  = @PA_LOGIN_NAME
              , DPTM_LST_UPD_DT  = GETDATE()
         WHERE  DPTM_ID          = CONVERT(INT, @@CURRSTRING)
         AND    DPTM_DELETED_IND = 1 
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR > 0
         BEGIN
         --
           SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_DPTM_CD+@COLDELIMITER+@PA_DPTM_DESC+@COLDELIMITER+ISNULL(@PA_DPTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
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
       IF @PA_CHK_YN = 1 -- IF MAKER OR CHEKER IS EDITING
       BEGIN
       --
         BEGIN TRANSACTION
         --
         UPDATE DP_TYPE_MSTR_MAK WITH (ROWLOCK)
         SET    DPTM_DELETED_IND = 2
              , DPTM_LST_UPD_BY  = @PA_LOGIN_NAME
              , DPTM_LST_UPD_DT  = GETDATE()
         WHERE  DPTM_ID          = CONVERT(INT, @@CURRSTRING)
         AND    DPTM_DELETED_IND = 0
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR > 0
         BEGIN
         --
           SET @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_DPTM_CD+@COLDELIMITER+@PA_DPTM_DESC+@COLDELIMITER+ISNULL(@PA_DPTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
           --
           ROLLBACK TRANSACTION
         --
         END
         ELSE
         BEGIN
           --
           INSERT INTO DP_TYPE_MSTR_MAK
           ( DPTM_ID
           , DPTM_CD
           , DPTM_DESC
           , DPTM_RMKS
           , DPTM_CREATED_BY
           , DPTM_CREATED_DT
           , DPTM_LST_UPD_BY
           , DPTM_LST_UPD_DT
           , DPTM_DELETED_IND
           )
           VALUES
           ( CONVERT(INT,@@CURRSTRING)
           , @PA_DPTM_CD
           , @PA_DPTM_DESC
           , @PA_DPTM_RMKS
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
             SET @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_DPTM_CD+@COLDELIMITER+@PA_DPTM_DESC+@COLDELIMITER+ISNULL(@PA_DPTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
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
