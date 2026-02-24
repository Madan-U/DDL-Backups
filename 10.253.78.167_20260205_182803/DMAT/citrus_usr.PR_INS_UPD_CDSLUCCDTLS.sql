-- Object: PROCEDURE citrus_usr.PR_INS_UPD_CDSLUCCDTLS
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------




CREATE PROCEDURE [citrus_usr].[PR_INS_UPD_CDSLUCCDTLS](@PA_ID          VARCHAR(8000)
                           ,@PA_ACTION      VARCHAR(20)
                           ,@PA_LOGIN_NAME  VARCHAR(20)
                           ,@PA_CUDM_BOID VARCHAR(16)
						   ,@PA_CUDM_UCC VARCHAR(100)
						   ,@PA_CUDM_EXID VARCHAR(10)
						   ,@PA_CUDM_CMID VARCHAR(10)
						   ,@PA_CUDM_TMCD VARCHAR(20)
						   ,@PA_CUDM_SEGID VARCHAR(30)
						   ,@PA_CUDM_LINKSTATUS  VARCHAR(200)
						   ,@PA_CUDM_CONSENTFLG CHAR(1)
						   ,@PA_CUDM_DPAM_ID NUMERIC
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
        , @L_SMCUDM_ID      BIGINT
        , @L_CUDM_ID        BIGINT
        , @@L_ERROR         BIGINT
        , @DELIMETER        VARCHAR(10)
        , @@REMAININGSTRING VARCHAR(8000)
        , @@CURRSTRING      VARCHAR(8000)
        , @@FOUNDAT         INTEGER
        , @@DELIMETERLENGTH INT
		, @L_BOID VARCHAR(16)
  --
  SELECT @L_BOID = DPAM_SBA_NO FROM DP_ACCT_MSTR WHERE DPAM_DELETED_IND =1 AND DPAM_ID = @PA_CUDM_DPAM_ID

  IF @L_BOID  <> '' AND @PA_CUDM_BOID <> @L_BOID
  BEGIN
		SET @PA_CUDM_BOID = @L_BOID
  END
  

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
         SELECT @L_CUDM_ID = ISNULL(MAX(CUDM_ID),0)+ 1
         FROM  CDSL_UCC_DTLS_MSTR WITH (NOLOCK)
         --
         BEGIN TRANSACTION
         --
         INSERT INTO CDSL_UCC_DTLS_MSTR
         ( CUDM_ID 
		 , CUDM_BOID
,CUDM_UCC
,CUDM_EXID
,CUDM_CMID
,CUDM_TMCD
,CUDM_SEGID
,CUDM_LINKSTATUS
,CUDM_CONSENTFLG
,CUDM_DPAM_ID
,CUDM_CREATED_BY
,CUDM_CREATED_DT
,CUDM_LST_UPD_BY
,CUDM_LST_UPD_DT
,CUDM_DELETED_IND
         )
         VALUES
         ( @L_CUDM_ID
       , @PA_CUDM_BOID
		,@PA_CUDM_UCC
		,@PA_CUDM_EXID
		,@PA_CUDM_CMID
		,@PA_CUDM_TMCD
		,@PA_CUDM_SEGID
		,@PA_CUDM_LINKSTATUS
		,@PA_CUDM_CONSENTFLG
		,@PA_CUDM_DPAM_ID
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
           SET @@T_ERRORSTR = @@T_ERRORSTR+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
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
       IF @PA_CHK_YN in (1,2) -- IF MAKER IS INSERTING
       BEGIN
	   print 'maker'
         --
         SELECT @L_SMCUDM_ID = ISNULL(MAX(SM.CUDM_ID),0)+1
         FROM CDSL_UCC_DTLS_MAK SM WITH (NOLOCK)
         --
         SELECT @L_CUDM_ID = ISNULL(MAX(S.CUDM_ID),0)+1
         FROM CDSL_UCC_DTLS_MSTR S WITH (NOLOCK)
         --
         BEGIN TRANSACTION
         --
         IF @L_SMCUDM_ID > @L_CUDM_ID
         BEGIN
           --
           SET  @L_CUDM_ID = @L_SMCUDM_ID
           --
         END
         --
         INSERT INTO CDSL_UCC_DTLS_MAK
         ( CUDM_ID
,CUDM_BOID
,CUDM_UCC
,CUDM_EXID
,CUDM_CMID
,CUDM_TMCD
,CUDM_SEGID
,CUDM_LINKSTATUS
,CUDM_CONSENTFLG
,CUDM_DPAM_ID
,CUDM_CREATED_BY
,CUDM_CREATED_DT
,CUDM_LST_UPD_BY
,CUDM_LST_UPD_DT
,CUDM_DELETED_IND)
         VALUES
         ( @L_CUDM_ID
       , @PA_CUDM_BOID
		,@PA_CUDM_UCC
		,@PA_CUDM_EXID
		,@PA_CUDM_CMID
		,@PA_CUDM_TMCD
		,@PA_CUDM_SEGID
		,@PA_CUDM_LINKSTATUS
		,@PA_CUDM_CONSENTFLG
		,@PA_CUDM_DPAM_ID
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
           SET @@T_ERRORSTR = @@T_ERRORSTR+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
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
       IF EXISTS(SELECT CUDM_ID
                 FROM   CDSL_UCC_DTLS_MSTR WITH(NOLOCK)
                 WHERE  CUDM_ID = CONVERT(INT, @@CURRSTRING))
       BEGIN
       --
         BEGIN TRANSACTION
         --    
UPDATE CUDM WITH (ROWLOCK)
         SET   CUDM.CUDM_BOID =  CUDMAK.CUDM_BOID
,CUDM.CUDM_UCC= CUDMAK.CUDM_UCC
,CUDM.CUDM_EXID= CUDMAK.CUDM_EXID
,CUDM.CUDM_CMID= CUDMAK.CUDM_CMID
,CUDM.CUDM_TMCD= CUDMAK.CUDM_TMCD
,CUDM.CUDM_SEGID= CUDMAK.CUDM_SEGID
,CUDM.CUDM_LINKSTATUS= CUDMAK.CUDM_LINKSTATUS
,CUDM.CUDM_CONSENTFLG= CUDMAK.CUDM_CONSENTFLG
,CUDM.CUDM_DPAM_ID= CUDMAK.CUDM_DPAM_ID
,CUDM.CUDM_LST_UPD_BY= @PA_LOGIN_NAME 
,CUDM.CUDM_LST_UPD_DT = GETDATE()
         FROM   CDSL_UCC_DTLS_MSTR                CUDM
              , CDSL_UCC_DTLS_MAK            CUDMAK
         WHERE  CUDM.CUDM_ID             = CONVERT(INT,@@CURRSTRING)
         AND    CUDMAK.CUDM_ID          = CUDM.CUDM_ID
         AND    CUDM.CUDM_DELETED_IND    = 1
         AND    CUDMAK.CUDM_DELETED_IND = 0
         AND    CUDMAK.CUDM_LST_UPD_BY <> @PA_LOGIN_NAME
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR  > 0
         BEGIN    --ERROR STRING WILL BE GENERATED IF ANY ERROR ERROR REPORTED
         --
           SELECT @@T_ERRORSTR = @@T_ERRORSTR+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
           FROM  CDSL_UCC_DTLS_MAK WITH (NOLOCK)
           WHERE CUDM_ID = CONVERT(INT, @@CURRSTRING)
           AND   CUDM_DELETED_IND = 0
           --
           ROLLBACK TRANSACTION
         --
         END
         ELSE
         BEGIN
           --
           UPDATE CDSL_UCC_DTLS_MAK WITH (ROWLOCK)
           SET    CUDM_DELETED_IND  = 1
                , CUDM_LST_UPD_BY   = @PA_LOGIN_NAME
                , CUDM_LST_UPD_DT   = GETDATE()
           WHERE  CUDM_ID           = CONVERT(INT,@@CURRSTRING)
           AND    CUDM_CREATED_BY  <> @PA_LOGIN_NAME
           AND    CUDM_DELETED_IND  = 0
           --
           SET @@L_ERROR = @@ERROR
           --
           IF @@L_ERROR  > 0
           BEGIN                     --IF ANY ERROR REPORTED THE GENERATE THE ERROR MESSAGE STRING
             --
             SELECT @@T_ERRORSTR    = @@T_ERRORSTR+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
             FROM  CDSL_UCC_DTLS_MAK WITH (NOLOCK)
             WHERE CUDM_ID          = CONVERT(INT,@@CURRSTRING)
             AND   cudm_DELETED_IND = 0
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
         INSERT INTO CDSL_UCC_DTLS_MSTR
         ( CUDM_ID
,CUDM_BOID
,CUDM_UCC
,CUDM_EXID
,CUDM_CMID
,CUDM_TMCD
,CUDM_SEGID
,CUDM_LINKSTATUS
,CUDM_CONSENTFLG
,CUDM_DPAM_ID
,CUDM_CREATED_BY
,CUDM_CREATED_DT
,CUDM_LST_UPD_BY
,CUDM_LST_UPD_DT
,CUDM_DELETED_IND
         )
         SELECT CUDM_ID
,CUDM_BOID
,CUDM_UCC
,CUDM_EXID
,CUDM_CMID
,CUDM_TMCD
,CUDM_SEGID
,CUDM_LINKSTATUS
,CUDM_CONSENTFLG
,CUDM_DPAM_ID
,CUDM_CREATED_BY
,CUDM_CREATED_DT
              , @PA_LOGIN_NAME
              , GETDATE()
              , 1
         FROM   CDSL_UCC_DTLS_MAK           CUDMMAK WITH (NOLOCK)
         WHERE  CUDMMAK.CUDM_ID           = CONVERT(INT,@@CURRSTRING)
         AND    CUDMMAK.CUDM_CREATED_BY  <> @PA_LOGIN_NAME
         AND    CUDMMAK.CUDM_DELETED_IND  = 0
         --
         SET @@L_ERROR = CONVERT(INT, @@ERROR)
         --
         IF @@L_ERROR  > 0
         BEGIN
           --
           SELECT @@T_ERRORSTR=@@T_ERRORSTR+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
           FROM   CDSL_UCC_DTLS_MAK WITH (NOLOCK)
           WHERE  CUDM_ID          = CONVERT(INT,@@CURRSTRING)
           AND    CUDM_DELETED_IND = 0
           --
           ROLLBACK TRANSACTION
           --
         END
         ELSE
         BEGIN
           --
           UPDATE CDSL_UCC_DTLS_MAK WITH (ROWLOCK)
           SET    CUDM_DELETED_IND  = 1
                , CUDM_LST_UPD_BY   = @PA_LOGIN_NAME
                , CUDM_LST_UPD_DT   = GETDATE()
           WHERE  CUDM_ID           = CONVERT(INT,@@CURRSTRING)
           AND    CUDM_CREATED_BY  <> @PA_LOGIN_NAME
           AND    CUDM_DELETED_IND  = 0

           SET @@L_ERROR = @@ERROR
           --
           IF @@L_ERROR > 0
           BEGIN
           --
             SELECT @@T_ERRORSTR    = @@T_ERRORSTR+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
             FROM  CDSL_UCC_DTLS_MAK WITH (NOLOCK)
             WHERE CUDM_ID          = CONVERT(INT, @@CURRSTRING)
             AND   CUDM_DELETED_IND = 0
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
       UPDATE CDSL_UCC_DTLS_MAK WITH (ROWLOCK)
       SET    CUDM_DELETED_IND = 3
            , CUDM_LST_UPD_BY  = @PA_LOGIN_NAME
            , CUDM_LST_UPD_DT  = GETDATE()
       WHERE  CUDM_ID          = CONVERT(INT,@@CURRSTRING)
       AND    CUDM_DELETED_IND = 0
       --
       SET @@L_ERROR = @@ERROR
       --
       IF @@L_ERROR > 0
       BEGIN
       --
         SELECT @@T_ERRORSTR = @@T_ERRORSTR+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
         FROM  CDSL_UCC_DTLS_MAK WITH (NOLOCK)
         WHERE CUDM_ID = CONVERT(INT,@@CURRSTRING)
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
       UPDATE CDSL_UCC_DTLS_MSTR WITH (ROWLOCK)
       SET    CUDM_DELETED_IND = 0
            , CUDM_LST_UPD_BY  = @PA_LOGIN_NAME
            , CUDM_LST_UPD_DT  = GETDATE()
       WHERE  CUDM_ID          = CONVERT(INT,@@CURRSTRING)
       --
       SET @@L_ERROR = @@ERROR
       --
       IF @@L_ERROR > 0
       BEGIN
         --
         SELECT @@T_ERRORSTR=@@T_ERRORSTR+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
         FROM   CDSL_UCC_DTLS_MSTR WITH (NOLOCK)
         WHERE  CUDM_ID          = CONVERT(INT,@@CURRSTRING)
         AND    CUDM_DELETED_IND = 1
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
         UPDATE CUDM WITH (ROWLOCK)
         SET   CUDM.CUDM_BOID =  @pa_CUDM_BOID
,CUDM.CUDM_UCC= @pa_CUDM_UCC
,CUDM.CUDM_EXID= @pa_CUDM_EXID
,CUDM.CUDM_CMID= @pa_CUDM_CMID
,CUDM.CUDM_TMCD= @pa_CUDM_TMCD
,CUDM.CUDM_SEGID= @pa_CUDM_SEGID
,CUDM.CUDM_LINKSTATUS= @pa_CUDM_LINKSTATUS
,CUDM.CUDM_CONSENTFLG= @pa_CUDM_CONSENTFLG
,CUDM.CUDM_DPAM_ID= @pa_CUDM_DPAM_ID
,CUDM.CUDM_LST_UPD_BY= @PA_LOGIN_NAME 
,CUDM.CUDM_LST_UPD_DT = GETDATE()
         FROM   CDSL_UCC_DTLS_MSTR                CUDM
             
         WHERE  CUDM.CUDM_ID             = CONVERT(INT,@@CURRSTRING)
         
         AND    CUDM.CUDM_DELETED_IND    = 1
         
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR > 0
         BEGIN
         --
           SET @@T_ERRORSTR = @@T_ERRORSTR+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
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
       IF @PA_CHK_YN in (1,2) -- IF MAKER OR CHEKER IS EDITING
       BEGIN
       --
         BEGIN TRANSACTION
         --
         UPDATE CDSL_UCC_DTLS_MAK WITH (ROWLOCK)
         SET    CUDM_DELETED_IND = 2
              , CUDM_LST_UPD_BY  = @PA_LOGIN_NAME
              , CUDM_LST_UPD_DT  = GETDATE()
         WHERE  CUDM_ID          = CONVERT(INT, @@CURRSTRING)
         AND    CUDM_DELETED_IND = 0
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR > 0
         BEGIN
         --
           SET @@T_ERRORSTR=@@T_ERRORSTR+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
           --
           ROLLBACK TRANSACTION
         --
         END
         ELSE
         BEGIN
         --
 INSERT INTO CDSL_UCC_DTLS_MAK
           (CUDM_ID
,CUDM_BOID
,CUDM_UCC
,CUDM_EXID
,CUDM_CMID
,CUDM_TMCD
,CUDM_SEGID
,CUDM_LINKSTATUS
,CUDM_CONSENTFLG
,CUDM_DPAM_ID
,CUDM_CREATED_BY
,CUDM_CREATED_DT
,CUDM_LST_UPD_BY
,CUDM_LST_UPD_DT
,CUDM_DELETED_IND
           )
           VALUES
           (CONVERT(INT,@@CURRSTRING)
           ,@pa_CUDM_BOID
,@pa_CUDM_UCC
,@pa_CUDM_EXID
,@pa_CUDM_CMID
,@pa_CUDM_TMCD
,@pa_CUDM_SEGID
,@pa_CUDM_LINKSTATUS
,@pa_CUDM_CONSENTFLG
,@pa_CUDM_DPAM_ID
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
             SET @@T_ERRORSTR=@@T_ERRORSTR+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER
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
