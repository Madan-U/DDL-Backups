-- Object: PROCEDURE citrus_usr.PR_INS_UPD_WFA
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_INS_UPD_WFA](@PA_ID          VARCHAR(8000)
                               ,@PA_ACTION      VARCHAR(20)
                               ,@PA_LOGIN_NAME  VARCHAR(20)
                               ,@PA_WFPM_ID     VARCHAR(20)
                               ,@PA_WFA_START   VARCHAR(10)
                               ,@PA_WFA_END     VARCHAR(10)
                               ,@PA_WFA_ACT_CD  VARCHAR(20)   = ''
                               ,@PA_WFA_DESC    VARCHAR(200)   = ''
                               ,@PA_WFA_RMKS    VARCHAR(200)
                               ,@PA_CHK_YN      INT
                               ,@ROWDELIMETER   CHAR(4)       = '*|~*'
                               ,@COLDELIMETER   CHAR(4)       = '|*~|'
                               ,@PA_ERRMSG      VARCHAR(8000) OUTPUT
)
AS
/*
*********************************************************************************
 SYSTEM         : CLASS
 MODULE NAME    : PR_MAK_WFA
 DESCRIPTION    : 
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  --------------------------------------------------
 1.0    TUSHAR            24-MAr-2007    VERSION.
-----------------------------------------------------------------------------------*/
--
BEGIN--1
  --
  SET NOCOUNT ON
  --
  DECLARE @@T_ERRORSTR      VARCHAR(8000),
          @L_WFA_ID         NUMERIC ,
          @L_WFA_ACT_ID     BIGINT,
          @@L_ERROR         BIGINT,
          @DELIMETER        VARCHAR(10),
          @@REMAININGSTRING VARCHAR(8000),
          @@CURRSTRING      VARCHAR(8000),
          @@FOUNDAT         INTEGER,
          @@DELIMETERLENGTH INT
  --
  SET @@L_ERROR = 0
  SET @@T_ERRORSTR=''
  SET @DELIMETER = '%'+ @ROWDELIMETER + '%'
  SET @@DELIMETERLENGTH = LEN(@ROWDELIMETER)
  SET @@REMAININGSTRING = @PA_ID
  --
  WHILE @@REMAININGSTRING <> ''
  BEGIN--2
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
   BEGIN--3
     --
     IF @PA_CHK_YN = 0 -- IF MAKER CHECKER FUNCTIONALITY IS NOT REQD
     BEGIN--4
       --
       IF @PA_ACTION = 'INS'  --ACTION TYPE = INS BEGINS HERE
       BEGIN--5
       --
         SELECT @L_WFA_ID = ISNULL(MAX(WFA_ID),0)+ 1
         FROM  WF_ACTIONS WITH (NOLOCK)
         
         --WFA_ACT_ID
         
         IF not EXISTS(SELECT  ISNULL(WFA.WFA_ACT_ID,0)  
         FROM   WF_ACTIONS WFA  
         WHERE  WFA.WFA_ACT_CD=@PA_WFA_ACT_CD  
         AND    WFA.WFA_DELETED_IND IN (1,0)  )
         BEGIN
            SET @L_WFA_ACT_ID=0  
         END
         ELSE
         BEGIN
         --
           SELECT @L_WFA_ACT_ID = ISNULL(WFA.WFA_ACT_ID,0)  
           FROM   WF_ACTIONS WFA  
           WHERE  WFA.WFA_ACT_CD=@PA_WFA_ACT_CD  
           AND    WFA.WFA_DELETED_IND IN (1,0)
         --
         END
         
         --
         IF @L_WFA_ACT_ID=0  
         BEGIN  
         --  
           SELECT @L_WFA_ACT_ID = ISNULL(MAX(WFA.WFA_ACT_ID), 0)  +1
           FROM   WF_ACTIONS WFA  
           
         --  
         END  
         --
         BEGIN TRANSACTION
         --
         
         IF @PA_WFPM_ID<>''
         BEGIN
         --
           IF @PA_WFA_START = '1'
           BEGIN
           --
             UPDATE WF_ACTIONS WITH (ROWLOCK)
             SET    WFA_START      = 0
             WHERE  WFA_START      = 1
             AND    WFA_WFPM_ID    = @PA_WFPM_ID
           --
           END
         --
         END
         
         
         
         INSERT INTO WF_ACTIONS
         ( WFA_ID
         , WFA_ACT_ID
         , WFA_START
         , WFA_END
         , WFA_ACT_CD
         , WFA_DESC
         , WFA_RMKS
         , WFA_WFPM_ID
         , WFA_CREATED_BY
         , WFA_CREATED_DT
         , WFA_LST_UPD_BY
         , WFA_LST_UPD_DT
         , WFA_DELETED_IND
         )
         VALUES
         ( @L_WFA_ID
         , @L_WFA_ACT_ID
         , @PA_WFA_START
         , @PA_WFA_END
         , @PA_WFA_ACT_CD
         , @PA_WFA_DESC
         , @PA_WFA_RMKS
         , @PA_WFPM_ID 
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
           SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMETER+@PA_WFA_ACT_CD+@COLDELIMETER+@PA_WFA_DESC+@COLDELIMETER+ISNULL(@PA_WFA_RMKS,'')+@COLDELIMETER+ISNULL(@PA_WFPM_ID,'0')+@COLDELIMETER+ISNULL(@PA_WFA_START,'0')+@COLDELIMETER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMETER
         --
         END
         ELSE
         BEGIN
         --
           COMMIT TRANSACTION
         --
         END
       --
       END--5
       --
       
       IF @PA_ACTION = 'DEL'
       BEGIN--6
         --
         BEGIN TRANSACTION
         --
         UPDATE WF_ACTIONS WITH (ROWLOCK)
         SET    WFA_DELETED_IND = 0
              , WFA_LST_UPD_BY  = @PA_LOGIN_NAME
              , WFA_LST_UPD_DT  = GETDATE()
         WHERE  WFA_ID         = CONVERT(INT,@@CURRSTRING)
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR > 0
         BEGIN
           --
           SELECT @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMETER+WFA_ACT_CD+@COLDELIMETER+WFA_DESC+@COLDELIMETER+ISNULL(WFA_RMKS,'')+@COLDELIMETER+ISNULL(WFA_WFPM_ID,'0')+@COLDELIMETER+ISNULL(WFA_START,'0')+@COLDELIMETER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMETER
           FROM   WF_ACTIONS WITH (NOLOCK)
           WHERE  WFA_ID          = CONVERT(INT,@@CURRSTRING)
           AND    WFA_DELETED_IND = 1
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
       END--6
       --
       IF @PA_ACTION = 'EDT'  --ACTION TYPE = EDT BEGINS HERE
       BEGIN--7
       --
         BEGIN TRANSACTION
         --
           IF @PA_WFA_START = '1'
           BEGIN
           --
         
             UPDATE WF_ACTIONS WITH (ROWLOCK)
             SET    WFA_START      = 0
             WHERE  WFA_START      = 1
             AND    WFA_WFPM_ID    = @PA_WFPM_ID
           
           --

             UPDATE WF_ACTIONS WITH (ROWLOCK)
             SET    WFA_ACT_CD     = @PA_WFA_ACT_CD
                  , WFA_START      = @PA_WFA_START  
                  , WFA_DESC       = @PA_WFA_DESC
                  , WFA_RMKS       = @PA_WFA_RMKS
                  , WFA_LST_UPD_BY = @PA_LOGIN_NAME
                  , WFA_LST_UPD_DT = GETDATE()
             WHERE  WFA_ID         = CONVERT(INT, @@CURRSTRING)
             --AND    WFA_WFPM_ID    = @PA_WFPM_ID
           --
           END
           ELSE
           BEGIN
           --
             UPDATE WF_ACTIONS WITH (ROWLOCK)
             SET    WFA_ACT_CD     = @PA_WFA_ACT_CD
                  , WFA_START      = @PA_WFA_START  
                  , WFA_DESC       = @PA_WFA_DESC
                  , WFA_RMKS       = @PA_WFA_RMKS
                  , WFA_LST_UPD_BY = @PA_LOGIN_NAME
                  , WFA_LST_UPD_DT = GETDATE()
             WHERE  WFA_ID         = CONVERT(INT, @@CURRSTRING) 
             AND    WFA_WFPM_ID    = @PA_WFPM_ID
           --
           END
           --
           SET @@L_ERROR = @@ERROR
           --
           IF @@L_ERROR > 0
           BEGIN
           --
             SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMETER+@PA_WFA_ACT_CD+@COLDELIMETER+@PA_WFA_DESC+@COLDELIMETER+ISNULL(@PA_WFA_RMKS,'')+@COLDELIMETER+ISNULL(@PA_WFPM_ID,'0')+@COLDELIMETER+ISNULL(@PA_WFA_START,'0')+@COLDELIMETER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMETER
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
       END--7 
   --
   END--4
   --
     SET @PA_ERRMSG = @@T_ERRORSTR
   --
   END--3
  --
  END--2
--
END--1

GO
