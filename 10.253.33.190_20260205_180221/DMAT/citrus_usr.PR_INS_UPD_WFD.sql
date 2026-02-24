-- Object: PROCEDURE citrus_usr.PR_INS_UPD_WFD
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE   PROCEDURE [citrus_usr].[PR_INS_UPD_WFD](@PA_ID              VARCHAR(8000)  
                               ,@PA_ACTION         VARCHAR(20)  
                               ,@PA_LOGIN_NAME     VARCHAR(20)  
                               ,@PA_WFD_REQUEST_ID VARCHAR(20)  
                               ,@PA_WFD_ROWM_ID    VARCHAR(20)  
                               ,@PA_WFD_UDN_NO     VARCHAR(20)  
                               ,@PA_WFD_CRN_NO     VARCHAR(20)  
                               ,@PA_WFD_ACCT_NO    VARCHAR(20)  
                               ,@PA_WFD_NAME       VARCHAR(50)  
                               ,@PA_WFD_RMKS       VARCHAR(1000)  
                               ,@PA_CHK_YN         INT  
                               ,@ROWDELIMITER      CHAR(4)       = '*|~*'  
                               ,@COLDELIMITER      CHAR(4)       = '|*~|'  
                               ,@PA_ERRMSG         VARCHAR(8000) OUTPUT  
)  
AS  
/*  
*********************************************************************************  
 SYSTEM         : CLASS  
 MODULE NAME    : PR_MAK_WFD  
 DESCRIPTION    :   
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.  
 VERSION HISTORY: 1.0  
 VERS.  AUTHOR            DATE          REASON  
 -----  -------------     ------------  --------------------------------------------------  
 1.0    TUSHAR            28-MARCH-2007 VERSION.  
-----------------------------------------------------------------------------------*/  
--  
BEGIN  
  --  
  SET NOCOUNT ON  
  --  
  DECLARE @@T_ERRORSTR       VARCHAR(8000),  
          @L_WFD_ID          NUMERIC ,  
          @@L_ERROR          BIGINT,  
          @DELIMETER         VARCHAR(10),  
          @@REMAININGSTRING  VARCHAR(8000),  
          @@CURRSTRING       VARCHAR(8000),  
          @@FOUNDAT          INTEGER,  
          @@DELIMETERLENGTH  INT,  
          @L_WFD_UDN_NO      VARCHAR(20),  
          @L_WFD_ACCT_NO     VARCHAR(20),    
          @L_WFD_REQUEST_ID VARCHAR(20)  
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
         /*SELECT @L_WFD_ID = ISNULL(MAX(WFD_ID),0)+ 1  
         FROM  WF_DTLS WITH (NOLOCK)*/  
         --  
         BEGIN TRANSACTION  
         --  
           
         IF ISNULL(@PA_ID,'0')<>'0'  
         BEGIN  
         --  
           UPDATE WF_DTLS WITH(ROWLOCK)  
           SET    WFD_STATUS='S'  
           WHERE  WFD_STATUS='A'   
           AND    WFD_ID=ISNULL(CONVERT(NUMERIC,@PA_ID),0)  
           AND    WFD_DELETED_IND=1  
         --  
         END  
         IF @PA_WFD_REQUEST_ID=''  
         BEGIN  
         --  
           SELECT @L_WFD_REQUEST_ID=ISNULL(MAX(wfd_request_id), 0)+1  
           FROM   wf_dtls
           PRINT  @L_WFD_REQUEST_ID 
         --  
         END  
           
           
         IF ISNULL(@PA_ID,'0') <> '0'  
         BEGIN  
         --  
           SELECT @L_WFD_UDN_NO = WFD_UDN_NO,  
                  @L_WFD_ACCT_NO= WFD_ACCT_NO  
           FROM   WF_DTLS  
           WHERE  WFD_ID   = CONVERT(NUMERIC,@PA_ID)  
         --  
         END  
         ELSE  
         BEGIN  
         --  
           SET @L_WFD_UDN_NO =@PA_WFD_UDN_NO  
           SET @L_WFD_ACCT_NO=@PA_WFD_ACCT_NO  
         --  
         END  
           
           
         SELECT @L_WFD_ID = ISNULL(MAX(WFD_ID),0)+ 1  
         FROM  WF_DTLS WITH (NOLOCK)  
           
         INSERT INTO WF_DTLS  
         ( WFD_ID  
         , WFD_REQUEST_ID  
         , WFD_STATUS  
         , WFD_ROWM_ID  
         , WFD_UDN_NO  
         , WFD_CRN_NO  
         , WFD_ACCT_NO  
         , WFD_NAME  
         , WFD_REMARKS  
         , WFD_CREATED_BY  
         , WFD_CREATED_DT  
         , WFD_LST_UPD_BY  
         , WFD_LST_UPD_DT  
         , WFD_DELETED_IND  
         )  
         VALUES  
         ( @L_WFD_ID  
         , case @PA_WFD_REQUEST_ID when '' then convert(NUMERIC,@L_WFD_REQUEST_ID) else convert(numeric,@PA_WFD_REQUEST_ID) end  
         , 'A'--@PA_WFD_STATUS  
         , ISNULL(CONVERT(NUMERIC,@PA_WFD_ROWM_ID),0)    
         , ISNULL(@L_WFD_UDN_NO,'')    
         , ISNULL(CONVERT(NUMERIC,@PA_WFD_CRN_NO),0)    
         , @L_WFD_ACCT_NO  
         , @PA_WFD_NAME   
         , @PA_WFD_RMKS  
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
           SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+ISNULL(@PA_WFD_REQUEST_ID,'0')+@COLDELIMITER+ISNULL(@PA_WFD_ROWM_ID,'0')+@COLDELIMITER+ISNULL(@PA_WFD_UDN_NO,'0')+@COLDELIMITER+ISNULL(@PA_WFD_CRN_NO,'0')+@COLDELIMITER+ISNULL(@PA_WFD_ACCT_NO,'0')+@COLDELIMITER+ISNULL(@PA_WFD_NAME,'')+@COLDELIMITER+ISNULL(@PA_WFD_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER  
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
         
       /*IF @PA_ACTION = 'DEL'  
       BEGIN  
         --  
         BEGIN TRANSACTION  
         --  
         UPDATE WF_DTLS WITH (ROWLOCK)  
         SET    WFD_DELETED_IND = 0  
              , WFD_LST_UPD_BY  = @PA_LOGIN_NAME  
              , WFD_LST_UPD_DT  = GETDATE()  
         WHERE  WFD_ID         = CONVERT(INT,@@CURRSTRING)  
         --  
         SET @@L_ERROR = @@ERROR  
         --  
         IF @@L_ERROR > 0  
         BEGIN  
           --  
           SELECT @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,WFD_ROWM_ID),'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,WFD_UDN_NO),'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,WFD_CRN_NO),'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR
,WFD_ACCT_NO),'')+@COLDELIMITER+ISNULL(WFD_REMARKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER  
           FROM   WF_DTLS WITH (NOLOCK)  
           WHERE  WFD_ID          = CONVERT(INT,@@CURRSTRING)  
           AND    WFD_DELETED_IND = 1  
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
           UPDATE WF_DTLS         WITH (ROWLOCK)  
           SET    WFD_ROWM_ID =   @PA_WFD_ROWM_ID  
                , WFD_UDN_NO  =   @PA_WFD_UDN_NO  
                , WFD_CRN_NO  =   @PA_WFD_CRN_NO  
                , WFD_ACCT_NO =   @PA_WFD_ACCT_NO  
                , WFD_REMARKS =   @PA_WFD_RMKS  
                , WFD_LST_UPD_BY = @PA_LOGIN_NAME  
                , WFD_LST_UPD_DT = GETDATE()              WHERE  WFD_ID         = CONVERT(INT, @@CURRSTRING)  
           --  
           SET @@L_ERROR = @@ERROR  
           --  
           IF @@L_ERROR > 0  
       BEGIN  
           --  
             SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+ISNULL(@PA_WFD_ROWM_ID,'0')+@COLDELIMITER+ISNULL(@PA_WFD_UDN_NO,'0')+@COLDELIMITER+ISNULL(@PA_WFD_CRN_NO,'0')+@COLDELIMITER+ISNULL(@PA_WFD_ACCT_NO,'0')+@COLDELIMITER+ISNULL(@PA_WFD_RM
KS,'')+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER  
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
        END*/  --ACTION TYPE = EDT ENDS HERE  
      --  
      END  
      --  
        
     --  
     END  
   --  
   END
   
   IF LTRIM(RTRIM(@@T_ERRORSTR)) = ''
   BEGIN
   --
     SET @PA_ERRMSG = case @PA_WFD_REQUEST_ID when '' then convert(varchar,@L_WFD_REQUEST_ID) else convert(varchar,@PA_WFD_REQUEST_ID) end   + @ROWDELIMITER
     
   --  
   END  
   ELSE
   BEGIN
   --
     SET @PA_ERRMSG = @@T_ERRORSTR  
     --print @pa_errmsg
   --
   END
--  
END

GO
