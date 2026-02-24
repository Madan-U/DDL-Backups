-- Object: PROCEDURE citrus_usr.PR_INS_UPD_WFPM
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_INS_UPD_WFPM] (@PA_ID           VARCHAR(8000)
                                ,@PA_ACTION      VARCHAR(20)
                                ,@PA_LOGIN_NAME  VARCHAR(20)
                                ,@PA_WFPM_CD     VARCHAR(20)   = ''
                                ,@PA_WFPM_DESC   VARCHAR(200)   = ''
                                ,@PA_WFPM_RMKS   VARCHAR(200)
                                ,@PA_CHK_YN      INT
                                ,@ROWDELIMITER   CHAR(4)       = '*|~*'
                                ,@COLDELIMITER   CHAR(4)       = '|*~|'
                                ,@PA_ERRMSG      VARCHAR(8000) OUTPUT
)
AS
/*
*********************************************************************************
 SYSTEM         : CLASS
 MODULE NAME    : PR_MAK_WFPM
 DESCRIPTION    : 
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  --------------------------------------------------
 1.0    TUSHAR            24-MARCH-2007 VERSION.
-----------------------------------------------------------------------------------*/
--
BEGIN
  --
  SET NOCOUNT ON
  --
  DECLARE @@T_ERRORSTR     VARCHAR(8000),
          @L_WFPM_ID        NUMERIC ,
          @@L_ERROR         BIGINT,
          @DELIMETER        VARCHAR(10),
          @@REMAININGSTRING VARCHAR(8000),
          @@CURRSTRING      VARCHAR(8000),
          @@FOUNDAT         INTEGER,
          @@DELIMETERLENGTH INT
  --
  SET @@L_ERROR = 0
  SET @@T_ERRORSTR=''
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
     IF @PA_CHK_YN = 0 -- IF MAKER CHECKER FUNCTIONALITY IS NOT REQD
     BEGIN
       --
       IF @PA_ACTION = 'INS'  --ACTION TYPE = INS BEGINS HERE
       BEGIN
       --
         SELECT @L_WFPM_ID = ISNULL(MAX(WFPM_ID),0)+ 1
         FROM  WF_PROCESS_MSTR WITH (NOLOCK)
         --
         BEGIN TRANSACTION
         --
         INSERT INTO WF_PROCESS_MSTR
         ( WFPM_ID
         , WFPM_CD
         , WFPM_DESC
         , WFPM_RMKS
         , WFPM_CREATED_BY
         , WFPM_CREATED_DT
         , WFPM_LST_UPD_BY
         , WFPM_LST_UPD_DT
         , WFPM_DELETED_IND
         )
         VALUES
         ( @L_WFPM_ID
         , @PA_WFPM_CD
         , @PA_WFPM_DESC
         , @PA_WFPM_RMKS
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
           SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_WFPM_CD+@COLDELIMITER+@PA_WFPM_DESC+@COLDELIMITER+ISNULL(@PA_WFPM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
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
         UPDATE WF_PROCESS_MSTR WITH (ROWLOCK)
         SET    WFPM_DELETED_IND = 0
              , WFPM_LST_UPD_BY  = @PA_LOGIN_NAME
              , WFPM_LST_UPD_DT  = GETDATE()
         WHERE   WFPM_ID         = CONVERT(INT,@@CURRSTRING)
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR > 0
         BEGIN
           --
           SELECT @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+WFPM_CD+@COLDELIMITER+WFPM_DESC+@COLDELIMITER+ISNULL(WFPM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
           FROM   WF_PROCESS_MSTR WITH (NOLOCK)
           WHERE  WFPM_ID          = CONVERT(INT,@@CURRSTRING)
           AND    WFPM_DELETED_IND = 1
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
           BEGIN TRANSACTION
           --
           UPDATE WF_PROCESS_MSTR WITH (ROWLOCK)
           SET    WFPM_CD         = @PA_WFPM_CD
                , WFPM_DESC       = @PA_WFPM_DESC
                , WFPM_RMKS       = @PA_WFPM_RMKS
                , WFPM_LST_UPD_BY = @PA_LOGIN_NAME
                , WFPM_LST_UPD_DT = GETDATE()
           WHERE  WFPM_ID         = CONVERT(INT, @@CURRSTRING)
           --
           SET @@L_ERROR = @@ERROR
           --
           IF @@L_ERROR > 0
           BEGIN
           --
             SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_WFPM_CD+@COLDELIMITER+@PA_WFPM_DESC+@COLDELIMITER+ISNULL(@PA_WFPM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
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
        END  --ACTION TYPE = EDT ENDS HERE
      --
      END
      --
       SET @PA_ERRMSG = @@T_ERRORSTR
     --
     END
   --
   END
--
END

GO
