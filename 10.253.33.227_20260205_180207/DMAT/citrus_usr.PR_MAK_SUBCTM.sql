-- Object: PROCEDURE citrus_usr.PR_MAK_SUBCTM
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--2	EDT	HO	11	GAT	GAT	G	0	0	*|~*	|*~|


CREATE PROCEDURE [citrus_usr].[PR_MAK_SUBCTM](@PA_ID             VARCHAR(8000)  
                             ,@PA_ACTION         VARCHAR(20)  
                             ,@PA_LOGIN_NAME     VARCHAR(20)  
                             ,@PA_CLICM_ID       NUMERIC
                             ,@PA_SUBCM_CD      VARCHAR(20)   = ''  
                             ,@PA_SUBCM_DESC     VARCHAR(200)  = ''  
                             ,@PA_SUBCM_RMKS     VARCHAR(200)
                             ,@PA_VALUES         VARCHAR(8000)  
                             ,@PA_CHK_YN         INT  
                             ,@ROWDELIMITER      CHAR(4)       = '*|~*'  
                             ,@COLDELIMITER      CHAR(4)       = '|*~|'  
                             ,@PA_ERRMSG         VARCHAR(8000) OUTPUT  
)  
AS  
/*  
*********************************************************************************  
 SYSTEM         : Citrus  
 MODULE NAME    : PR_MAK_SUBCM  
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE MAKER CHECKER FACILITY FOR SUB CATEGORY MASTER  
 COPYRIGHT(C)   : Marketplace Technologies PVT. LTD.  
 VERSION HISTORY: 1.0  
 VERS.  AUTHOR            DATE          REASON  
 -----  -------------     ------------  -----------------------------------------
 1.0    TUSHAR            9-OCT-2007    VERSION.  
--------------------------------------------------------------------------------- 
*********************************************************************************  
*/  
BEGIN
  --
  SET NOCOUNT ON
  --
  DECLARE @@T_ERRORSTR      VARCHAR(8000)
        , @L_SUBCMM_ID     BIGINT
        , @L_SUBCM_ID        BIGINT
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
         SELECT @L_SUBCM_ID = ISNULL(MAX(SUBCM_ID),0)+ 1
         FROM  SUB_CTGRY_MSTR WITH (NOLOCK)
         --
         BEGIN TRANSACTION
         --
         INSERT INTO SUB_CTGRY_MSTR 
         ( SUBCM_ID
         , SUBCM_CLICM_ID
         , SUBCM_CD
         , SUBCM_DESC
         , SUBCM_RMKS
         , SUBCM_CREATED_BY
         , SUBCM_CREATED_DT
         , SUBCM_LST_UPD_BY
         , SUBCM_LST_UPD_DT
         , SUBCM_DELETED_IND
         )
         VALUES
         ( @L_SUBCM_ID
         , @PA_CLICM_ID
         , @PA_SUBCM_CD
         , @PA_SUBCM_DESC
         , @PA_SUBCM_RMKS
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
           SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+CONVERT(VARCHAR,@PA_CLICM_ID)+@COLDELIMITER+@PA_SUBCM_CD+@COLDELIMITER+@PA_SUBCM_DESC+@COLDELIMITER+ISNULL(@PA_SUBCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER  
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
         SELECT @L_SUBCM_ID = ISNULL(MAX(SUBCM_ID),0)+1
         FROM SUB_CTGRY_MSTR WITH (NOLOCK)
         --
         SELECT @L_SUBCMM_ID = ISNULL(MAX(SUBCM_ID),0)+1
         FROM SUB_CTGRY_MSTR_MAK WITH (NOLOCK)
         --
         BEGIN TRANSACTION
         --
         IF @L_SUBCMM_ID > @L_SUBCM_ID
         BEGIN
           --
           SET  @L_SUBCM_ID = @L_SUBCMM_ID
           --
         END
         --
         INSERT INTO SUB_CTGRY_MSTR_MAK
         ( SUBCM_ID
         , SUBCM_CLICM_ID
         , SUBCM_CD
         , SUBCM_DESC
         , SUBCM_RMKS
         , SUBCM_CREATED_BY
         , SUBCM_CREATED_DT
         , SUBCM_LST_UPD_BY
         , SUBCM_LST_UPD_DT
         , SUBCM_DELETED_IND)
         VALUES
         ( @L_SUBCM_ID
         , @PA_CLICM_ID
         , @PA_SUBCM_CD
         , @PA_SUBCM_DESC
         , @PA_SUBCM_RMKS
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
           SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+CONVERT(VARCHAR,@PA_CLICM_ID)+@COLDELIMITER+@PA_SUBCM_CD+@COLDELIMITER+@PA_SUBCM_DESC+@COLDELIMITER+ISNULL(@PA_SUBCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER  
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
       IF EXISTS(SELECT SUBCM_ID
                 FROM   SUB_CTGRY_MSTR WITH(NOLOCK)
                 WHERE  SUBCM_ID = CONVERT(INT, @@CURRSTRING))
       BEGIN
       --
         BEGIN TRANSACTION
         --
         UPDATE SUBCM WITH (ROWLOCK)
         SET    SUBCM.SUBCM_CLICM_ID       = SUBCMM.SUBCM_CLICM_ID 
              , SUBCM.SUBCM_CD             = SUBCMM.SUBCM_CD             
              , SUBCM.SUBCM_DESC           = SUBCMM.SUBCM_DESC           
              , SUBCM.SUBCM_RMKS           = SUBCMM.SUBCM_RMKS           
              , SUBCM.SUBCM_LST_UPD_BY     = @PA_LOGIN_NAME
              , SUBCM.SUBCM_LST_UPD_DT     = GETDATE()
              , SUBCM.SUBCM_DELETED_IND    = 1
         FROM   SUB_CTGRY_MSTR             SUBCM
              , SUB_CTGRY_MSTR_MAK         SUBCMM
         WHERE  SUBCM.SUBCM_ID           = CONVERT(INT,@@CURRSTRING)
         AND    SUBCMM.SUBCM_ID          = SUBCM.SUBCM_ID          
         AND    SUBCM.SUBCM_DELETED_IND  = 1
         AND    SUBCMM.SUBCM_DELETED_IND = 0
         AND    SUBCMM.SUBCM_CREATED_BY <> @PA_LOGIN_NAME
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR  > 0
         BEGIN    --ERROR STRING WILL BE GENERATED IF ANY ERROR ERROR REPORTED
         --
           SELECT @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+convert(varchar,SUBCM_CLICM_ID)+@COLDELIMITER+SUBCM_CD+@COLDELIMITER+SUBCM_DESC+@COLDELIMITER+ISNULL(@PA_SUBCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER  
											FROM  SUB_CTGRY_MSTR_MAK WITH (NOLOCK)
           WHERE SUBCM_ID  = CONVERT(INT,@@CURRSTRING) 
           --
           ROLLBACK TRANSACTION
         --
         END
         ELSE
         BEGIN
           --
           UPDATE SUB_CTGRY_MSTR_MAK WITH (ROWLOCK)
           SET    SUBCM_DELETED_IND  = 1
                , SUBCM_LST_UPD_BY   = @PA_LOGIN_NAME
                , SUBCM_LST_UPD_DT   = GETDATE()
           WHERE  SUBCM_ID           = CONVERT(INT,@@CURRSTRING)
           AND    SUBCM_CREATED_BY  <> @PA_LOGIN_NAME
           AND    SUBCM_DELETED_IND  = 0
           --
           SET @@L_ERROR = @@ERROR
           --
           IF @@L_ERROR  > 0
           BEGIN                     --IF ANY ERROR REPORTED THE GENERATE THE ERROR MESSAGE STRING
             --
             SELECT @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+convert(varchar,SUBCM_CLICM_ID)+@COLDELIMITER+SUBCM_CD+@COLDELIMITER+SUBCM_DESC+@COLDELIMITER+ISNULL(@PA_SUBCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER  
													FROM  SUB_CTGRY_MSTR_MAK WITH (NOLOCK)
             WHERE SUBCM_ID  = CONVERT(INT,@@CURRSTRING) 
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
         INSERT INTO SUB_CTGRY_MSTR
         ( SUBCM_ID
         , SUBCM_CLICM_ID
         , SUBCM_CD
         , SUBCM_DESC
         , SUBCM_RMKS
         , SUBCM_CREATED_BY
         , SUBCM_CREATED_DT
         , SUBCM_LST_UPD_BY
         , SUBCM_LST_UPD_DT
         , SUBCM_DELETED_IND
         )
         SELECT SUBCMM.SUBCM_ID
														, SUBCMM.SUBCM_CLICM_ID
														, SUBCMM.SUBCM_CD
														, SUBCMM.SUBCM_DESC
														, SUBCMM.SUBCM_RMKS
														, SUBCMM.SUBCM_CREATED_BY
														, SUBCMM.SUBCM_CREATED_DT
														, SUBCMM.SUBCM_LST_UPD_BY
														, SUBCMM.SUBCM_LST_UPD_DT
              , 1
         FROM   SUB_CTGRY_MSTR_MAK        SUBCMM WITH (NOLOCK)
         WHERE  SUBCMM.SUBCM_ID           = CONVERT(INT,@@CURRSTRING)
         AND    SUBCMM.SUBCM_LST_UPD_BY  <> @PA_LOGIN_NAME
         AND    SUBCMM.SUBCM_DELETED_IND  = 0
         --
         SET @@L_ERROR = CONVERT(INT, @@ERROR)
         --
         IF @@L_ERROR  > 0
         BEGIN
           --
           SELECT @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+convert(varchar,SUBCM_CLICM_ID)+@COLDELIMITER+SUBCM_CD+@COLDELIMITER+SUBCM_DESC+@COLDELIMITER+ISNULL(@PA_SUBCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER  
											FROM  SUB_CTGRY_MSTR_MAK WITH (NOLOCK)
           WHERE SUBCM_ID  = CONVERT(INT,@@CURRSTRING) 
           --
           ROLLBACK TRANSACTION
           --
         END
         ELSE
         BEGIN
           --
           UPDATE SUB_CTGRY_MSTR_MAK WITH (ROWLOCK)
											SET    SUBCM_DELETED_IND  = 1
																, SUBCM_LST_UPD_BY   = @PA_LOGIN_NAME
																, SUBCM_LST_UPD_DT   = GETDATE()
											WHERE  SUBCM_ID           = CONVERT(INT,@@CURRSTRING)
											AND    SUBCM_LST_UPD_BY  <> @PA_LOGIN_NAME
           AND    SUBCM_DELETED_IND  = 0

           SET @@L_ERROR = @@ERROR
           --
           IF @@L_ERROR > 0
           BEGIN
           --
             SELECT @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+convert(varchar,SUBCM_CLICM_ID)+@COLDELIMITER+SUBCM_CD+@COLDELIMITER+SUBCM_DESC+@COLDELIMITER+ISNULL(@PA_SUBCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER  
													FROM  SUB_CTGRY_MSTR_MAK WITH (NOLOCK)
             WHERE SUBCM_ID  = CONVERT(INT,@@CURRSTRING) 
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
       UPDATE SUB_CTGRY_MSTR_MAK WITH (ROWLOCK)
							SET    SUBCM_DELETED_IND  = 3
												, SUBCM_LST_UPD_BY   = @PA_LOGIN_NAME
												, SUBCM_LST_UPD_DT   = GETDATE()
							WHERE  SUBCM_ID           = CONVERT(INT,@@CURRSTRING)
							AND    SUBCM_LST_UPD_BY  <> @PA_LOGIN_NAME
       AND    SUBCM_DELETED_IND  = 0
       --
       SET @@L_ERROR = @@ERROR
       --
       IF @@L_ERROR > 0
       BEGIN
       --
         SELECT @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+convert(varchar,SUBCM_CLICM_ID)+@COLDELIMITER+SUBCM_CD+@COLDELIMITER+SUBCM_DESC+@COLDELIMITER+ISNULL(@PA_SUBCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER  
									FROM  SUB_CTGRY_MSTR_MAK WITH (NOLOCK)
         WHERE SUBCM_ID  = CONVERT(INT,@@CURRSTRING) 
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
       UPDATE SUB_CTGRY_MSTR       WITH (ROWLOCK)
							SET    SUBCM_DELETED_IND  = 0
												, SUBCM_LST_UPD_BY   = @PA_LOGIN_NAME
												, SUBCM_LST_UPD_DT   = GETDATE()
							WHERE  SUBCM_ID           = CONVERT(INT,@@CURRSTRING)
							--
       SET @@L_ERROR = @@ERROR
       --
       IF @@L_ERROR > 0
       BEGIN
         --
         SELECT @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+convert(varchar,SUBCM_CLICM_ID)+@COLDELIMITER+SUBCM_CD+@COLDELIMITER+SUBCM_DESC+@COLDELIMITER+ISNULL(@PA_SUBCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER  
									FROM  SUB_CTGRY_MSTR WITH (NOLOCK)
         WHERE SUBCM_ID  = CONVERT(INT,@@CURRSTRING) 
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
         UPDATE SUB_CTGRY_MSTR WITH (ROWLOCK)
         SET    SUBCM_CLICM_ID  = @PA_CLICM_ID
              , SUBCM_CD         = @PA_SUBCM_CD
              , SUBCM_DESC       = @PA_SUBCM_DESC
              , SUBCM_RMKS       = @PA_SUBCM_RMKS
              , SUBCM_LST_UPD_BY = @PA_LOGIN_NAME
              , SUBCM_LST_UPD_DT = GETDATE()
         WHERE  SUBCM_ID         = CONVERT(INT, @@CURRSTRING)
         AND    SUBCM_DELETED_IND= 1
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR > 0
         BEGIN
         --
           SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+CONVERT(VARCHAR,@PA_CLICM_ID)+@COLDELIMITER+@PA_SUBCM_CD+@COLDELIMITER+@PA_SUBCM_DESC+@COLDELIMITER+ISNULL(@PA_SUBCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER  
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
         UPDATE SUB_CTGRY_MSTR_MAK WITH (ROWLOCK)
         SET    SUBCM_DELETED_IND = 2
              , SUBCM_LST_UPD_BY  = @PA_LOGIN_NAME
              , SUBCM_LST_UPD_DT  = GETDATE()
         WHERE  SUBCM_ID          = CONVERT(INT, @@CURRSTRING)
         AND    SUBCM_DELETED_IND = 0
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR > 0
         BEGIN
         --
           SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+CONVERT(VARCHAR,@PA_CLICM_ID)+@COLDELIMITER+@PA_SUBCM_CD+@COLDELIMITER+@PA_SUBCM_DESC+@COLDELIMITER+ISNULL(@PA_SUBCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER  
           --
           ROLLBACK TRANSACTION
         --
         END
         ELSE
         BEGIN
         --
           INSERT INTO SUB_CTGRY_MSTR_MAK
											( SUBCM_ID
											, SUBCM_CLICM_ID
											, SUBCM_CD
											, SUBCM_DESC
											, SUBCM_RMKS
											, SUBCM_CREATED_BY
											, SUBCM_CREATED_DT
											, SUBCM_LST_UPD_BY
											, SUBCM_LST_UPD_DT
											, SUBCM_DELETED_IND
           )
           VALUES
           (CONVERT(INT,@@CURRSTRING)
           , @PA_CLICM_ID
											, @PA_SUBCM_CD
											, @PA_SUBCM_DESC
											, @PA_SUBCM_RMKS
											, @PA_LOGIN_NAME
											, GETDATE()
											, @PA_LOGIN_NAME
											, GETDATE()
           ,0
           )
           --
           SET @@L_ERROR = @@ERROR
           --
           IF @@L_ERROR > 0
           BEGIN
           --
             SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+CONVERT(VARCHAR,@PA_CLICM_ID)+@COLDELIMITER+@PA_SUBCM_CD+@COLDELIMITER+@PA_SUBCM_DESC+@COLDELIMITER+ISNULL(@PA_SUBCM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER  
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
