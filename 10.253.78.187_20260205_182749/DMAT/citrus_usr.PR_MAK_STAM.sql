-- Object: PROCEDURE citrus_usr.PR_MAK_STAM
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_MAK_STAM](@PA_ID          VARCHAR(8000)
                           ,@PA_ACTION      VARCHAR(20)
                           ,@PA_LOGIN_NAME  VARCHAR(20)
                           ,@PA_STAM_CD     VARCHAR(20)   = ''
                           ,@PA_STAM_DESC   VARCHAR(20)   = ''
                           ,@PA_STAM_RMKS   VARCHAR(200)
                           ,@PA_CHK_YN      INT
                           ,@ROWDELIMITER   CHAR(4)       = '*|~*'
                           ,@COLDELIMITER   CHAR(4)       = '|*~|'
                           ,@PA_ERRMSG      VARCHAR(8000) OUTPUT
)
AS
/*
*********************************************************************************
 SYSTEM         : CLASS
 MODULE NAME    : PR_MAK_STAM
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE MAKER CHECKER FACILITY FOR STATUS MASTER
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  --------------------------------------------------
 2.0    SUKHVINDER/TUSHAR 15-DEC-2006    VERSION.
-----------------------------------------------------------------------------------*/
--
BEGIN
  --
  SET NOCOUNT ON
  --
  DECLARE @@T_ERRORSTR      VARCHAR(8000)
        , @L_SMSTAM_ID      BIGINT
        , @L_STAM_ID        BIGINT
        , @@L_ERROR         BIGINT
        , @DELIMETER        VARCHAR(10)
        , @@REMAININGSTRING VARCHAR(8000)
        , @@CURRSTRING      VARCHAR(8000)
        , @@FOUNDAT         INTEGER
        , @@DELIMETERLENGTH INT
  --
  SET @@L_ERROR         = 0
  SET @@T_ERRORSTR      = ''
  SET @DELIMETER        = '%'+ @ROWDELIMITER + '%'
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
     IF @PA_ACTION = 'INS'  --ACTION TYPE = INS BEGINS HERE
     BEGIN
       --
       IF @PA_CHK_YN = 0 -- IF MAKER CHECKER FUNCTIONALITY IS NOT REQD
       BEGIN
       --
         SELECT @L_STAM_ID = ISNULL(MAX(STAM_ID),0)+ 1
         FROM  STATUS_MSTR WITH (NOLOCK)
         --
         BEGIN TRANSACTION
         --
         INSERT INTO STATUS_MSTR
         ( STAM_ID
         , STAM_CD
         , STAM_DESC
         , STAM_RMKS
         , STAM_CREATED_BY
         , STAM_CREATED_DT
         , STAM_LST_UPD_BY
         , STAM_LST_UPD_DT
         , STAM_DELETED_IND
         )
         VALUES
         ( @L_STAM_ID
         , @PA_STAM_CD
         , @PA_STAM_DESC
         , @PA_STAM_RMKS
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
           SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_STAM_CD+@COLDELIMITER+@PA_STAM_DESC+@COLDELIMITER+ISNULL(@PA_STAM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
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
         SELECT @L_SMSTAM_ID = ISNULL(MAX(SM.STAM_ID),0)+1
         FROM STATUS_MSTR_MAK SM WITH (NOLOCK)
         --
         SELECT @L_STAM_ID = ISNULL(MAX(S.STAM_ID),0)+1
         FROM STATUS_MSTR S WITH (NOLOCK)
         --
         BEGIN TRANSACTION
         --
         IF @L_SMSTAM_ID > @L_STAM_ID
         BEGIN
           --
           SET  @L_STAM_ID = @L_SMSTAM_ID
           --
         END
         --
         INSERT INTO STATUS_MSTR_MAK
         ( STAM_ID
         , STAM_CD
         , STAM_DESC
         , STAM_RMKS
         , STAM_CREATED_BY
         , STAM_CREATED_DT
         , STAM_LST_UPD_BY
         , STAM_LST_UPD_DT
         , STAM_DELETED_IND)
         VALUES
         ( @L_STAM_ID
         , @PA_STAM_CD
         , @PA_STAM_DESC
         , @PA_STAM_RMKS
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
           SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_STAM_CD+@COLDELIMITER+@PA_STAM_DESC+@COLDELIMITER+ISNULL(@PA_STAM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
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

     IF @PA_ACTION = 'APP'
     BEGIN
     --
       IF EXISTS(SELECT STAM_ID
                 FROM   STATUS_MSTR WITH(NOLOCK)
                 WHERE  STAM_ID = CONVERT(INT, @@CURRSTRING))
       BEGIN
       --
         BEGIN TRANSACTION
         --
         UPDATE STAM WITH (ROWLOCK)
         SET    STAM.STAM_CD             = STAMMAK.STAM_CD
              , STAM.STAM_DESC           = STAMMAK.STAM_DESC
              , STAM.STAM_RMKS           = STAMMAK.STAM_RMKS
              , STAM.STAM_LST_UPD_BY     = @PA_LOGIN_NAME
              , STAM.STAM_LST_UPD_DT     = GETDATE()
              , STAM.STAM_DELETED_IND    = 1
         FROM   STATUS_MSTR                STAM
              , STATUS_MSTR_MAK            STAMMAK
         WHERE  STAM.STAM_ID             = CONVERT(INT,@@CURRSTRING)
         AND    STAMMAK.STAM_ID          = STAM.STAM_ID
         AND    STAM.STAM_DELETED_IND    = 1
         AND    STAMMAK.STAM_DELETED_IND = 0
         AND    STAMMAK.STAM_CREATED_BY <> @PA_LOGIN_NAME
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR  > 0
         BEGIN    --ERROR STRING WILL BE GENERATED IF ANY ERROR ERROR REPORTED
         --
           SELECT @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+STAM_CD+@COLDELIMITER+STAM_DESC+@COLDELIMITER+ISNULL(STAM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
           FROM  STATUS_MSTR_MAK WITH (NOLOCK)
           WHERE STAM_ID = CONVERT(INT, @@CURRSTRING)
           AND   STAM_DELETED_IND = 0
           --
           ROLLBACK TRANSACTION
         --
         END
         ELSE
         BEGIN
           --
           UPDATE STATUS_MSTR_MAK WITH (ROWLOCK)
           SET    STAM_DELETED_IND  = 1
                , STAM_LST_UPD_BY   = @PA_LOGIN_NAME
                , STAM_LST_UPD_DT   = GETDATE()
           WHERE  STAM_ID           = CONVERT(INT,@@CURRSTRING)
           AND    STAM_CREATED_BY  <> @PA_LOGIN_NAME
           AND    STAM_DELETED_IND  = 0
           --
           SET @@L_ERROR = @@ERROR
           --
           IF @@L_ERROR  > 0
           BEGIN                     --IF ANY ERROR REPORTED THE GENERATE THE ERROR MESSAGE STRING
             --
             SELECT @@T_ERRORSTR    = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+STAM_CD+@COLDELIMITER+STAM_DESC+@COLDELIMITER+ISNULL(STAM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
             FROM  STATUS_MSTR_MAK WITH (NOLOCK)
             WHERE STAM_ID          = CONVERT(INT,@@CURRSTRING)
             AND   STAM_DELETED_IND = 0
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
         INSERT INTO STATUS_MSTR
         ( STAM_ID
         , STAM_CD
         , STAM_DESC
         , STAM_RMKS
         , STAM_CREATED_BY
         , STAM_CREATED_DT
         , STAM_LST_UPD_BY
         , STAM_LST_UPD_DT
         , STAM_DELETED_IND
         )
         SELECT STAMM.STAM_ID
              , STAMM.STAM_CD
              , STAMM.STAM_DESC
              , STAMM.STAM_RMKS
              , STAMM.STAM_CREATED_BY
              , STAMM.STAM_CREATED_DT
              , @PA_LOGIN_NAME
              , GETDATE()
              , 1
         FROM   STATUS_MSTR_MAK           STAMM WITH (NOLOCK)
         WHERE  STAMM.STAM_ID           = CONVERT(INT,@@CURRSTRING)
         AND    STAMM.STAM_CREATED_BY  <> @PA_LOGIN_NAME
         AND    STAMM.STAM_DELETED_IND  = 0
         --
         SET @@L_ERROR = CONVERT(INT, @@ERROR)
         --
         IF @@L_ERROR  > 0
         BEGIN
           --
           SELECT @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+STAM_CD+@COLDELIMITER+STAM_DESC+@COLDELIMITER+ISNULL(STAM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
           FROM   STATUS_MSTR_MAK WITH (NOLOCK)
           WHERE  STAM_ID          = CONVERT(INT,@@CURRSTRING)
           AND    STAM_DELETED_IND = 0
           --
           ROLLBACK TRANSACTION
           --
         END
         ELSE
         BEGIN
           --
           UPDATE STATUS_MSTR_MAK WITH (ROWLOCK)
           SET    STAM_DELETED_IND  = 1
                , STAM_LST_UPD_BY   = @PA_LOGIN_NAME
                , STAM_LST_UPD_DT   = GETDATE()
           WHERE  STAM_ID           = CONVERT(INT,@@CURRSTRING)
           AND    STAM_CREATED_BY  <> @PA_LOGIN_NAME
           AND    STAM_DELETED_IND  = 0

           SET @@L_ERROR = @@ERROR
           --
           IF @@L_ERROR > 0
           BEGIN
           --
             SELECT @@T_ERRORSTR    = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+STAM_CD+@COLDELIMITER+STAM_DESC+@COLDELIMITER+ISNULL(STAM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
             FROM  STATUS_MSTR_MAK WITH (NOLOCK)
             WHERE STAM_ID          = CONVERT(INT, @@CURRSTRING)
             AND   STAM_DELETED_IND = 0
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
       BEGIN TRANSACTION
       --
       UPDATE STATUS_MSTR_MAK WITH (ROWLOCK)
       SET    STAM_DELETED_IND = 3
            , STAM_LST_UPD_BY  = @PA_LOGIN_NAME
            , STAM_LST_UPD_DT  = GETDATE()
       WHERE  STAM_ID          = CONVERT(INT,@@CURRSTRING)
       AND    STAM_DELETED_IND = 0
       --
       SET @@L_ERROR = @@ERROR
       --
       IF @@L_ERROR > 0
       BEGIN
       --
         SELECT @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+STAM_CD+@COLDELIMITER+STAM_DESC+@COLDELIMITER+ISNULL(STAM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
         FROM  STATUS_MSTR_MAK WITH (NOLOCK)
         WHERE STAM_ID = CONVERT(INT,@@CURRSTRING)
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
     IF @PA_ACTION = 'DEL'
     BEGIN
       --
       BEGIN TRANSACTION
       --
       UPDATE STATUS_MSTR WITH (ROWLOCK)
       SET    STAM_DELETED_IND = 0
            , STAM_LST_UPD_BY  = @PA_LOGIN_NAME
            , STAM_LST_UPD_DT  = GETDATE()
       WHERE  STAM_ID          = CONVERT(INT,@@CURRSTRING)
       --
       SET @@L_ERROR = @@ERROR
       --
       IF @@L_ERROR > 0
       BEGIN
         --
         SELECT @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+STAM_CD+@COLDELIMITER+STAM_DESC+@COLDELIMITER+ISNULL(STAM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
         FROM   STATUS_MSTR WITH (NOLOCK)
         WHERE  STAM_ID          = CONVERT(INT,@@CURRSTRING)
         AND    STAM_DELETED_IND = 1
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
     IF @PA_ACTION = 'EDT'  --ACTION TYPE = EDT BEGINS HERE
     BEGIN
     --
       IF @PA_CHK_YN = 0 -- IF NO MAKER CHECKER
       BEGIN
       --
         BEGIN TRANSACTION
         --
         UPDATE STATUS_MSTR WITH (ROWLOCK)
         SET    STAM_CD         = @PA_STAM_CD
              , STAM_DESC       = @PA_STAM_DESC
              , STAM_RMKS       = @PA_STAM_RMKS
              , STAM_LST_UPD_BY = @PA_LOGIN_NAME
              , STAM_LST_UPD_DT = GETDATE()
         WHERE  STAM_ID         = CONVERT(INT, @@CURRSTRING)
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR > 0
         BEGIN
         --
           SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_STAM_CD+@COLDELIMITER+@PA_STAM_DESC+@COLDELIMITER+ISNULL(@PA_STAM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
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
         UPDATE STATUS_MSTR_MAK WITH (ROWLOCK)
         SET    STAM_DELETED_IND = 2
              , STAM_LST_UPD_BY  = @PA_LOGIN_NAME
              , STAM_LST_UPD_DT  = GETDATE()
         WHERE  STAM_ID          = CONVERT(INT, @@CURRSTRING)
         AND    STAM_DELETED_IND = 0
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR > 0
         BEGIN
         --
           SET @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_STAM_CD+@COLDELIMITER+@PA_STAM_DESC+@COLDELIMITER+ISNULL(@PA_STAM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
           --
           ROLLBACK TRANSACTION
         --
         END
         ELSE
         BEGIN
         --
           INSERT INTO STATUS_MSTR_MAK
           (STAM_ID
           ,STAM_CD
           ,STAM_DESC
           ,STAM_RMKS
           ,STAM_CREATED_BY
           ,STAM_CREATED_DT
           ,STAM_LST_UPD_BY
           ,STAM_LST_UPD_DT
           ,STAM_DELETED_IND
           )
           VALUES
           (CONVERT(INT,@@CURRSTRING)
           ,@PA_STAM_CD
           ,@PA_STAM_DESC
           ,@PA_STAM_RMKS
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
             SET @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_STAM_CD+@COLDELIMITER+@PA_STAM_DESC+@COLDELIMITER+ISNULL(@PA_STAM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
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
