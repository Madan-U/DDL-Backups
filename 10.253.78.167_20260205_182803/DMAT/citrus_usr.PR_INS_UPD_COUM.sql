-- Object: PROCEDURE citrus_usr.PR_INS_UPD_COUM
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--SELECT * FROM COURIER_MSTR  
CREATE PROCEDURE [citrus_usr].[PR_INS_UPD_COUM](@PA_ID          VARCHAR(8000)      
                           ,@PA_ACTION      VARCHAR(20)      
                           ,@PA_LOGIN_NAME  VARCHAR(20)      
                          ,@pa_coum_no varchar (50)  
       ,@pa_coum_adr1 varchar(50)  
       ,@pa_coum_adr2 varchar(50)  
       ,@pa_coum_adr3 varchar(50)  
       ,@pa_coum_adr_city varchar(50)  
       ,@pa_coum_adr_state varchar(50)  
       ,@pa_coum_adr_country varchar(50)  
       ,@pa_coum_adr_zip varchar(50)  
       ,@pa_coum_cont_per varchar(100)  
       ,@pa_coum_off_ph1 varchar(25)  
       ,@pa_coum_off_ph2 varchar(25)  
       ,@pa_coum_off_fax1 varchar(25)  
       ,@pa_coum_off_fax2 varchar(25)  
       ,@pa_coum_res_ph1 varchar(25)  
       ,@pa_coum_res_ph2 varchar(25)  
       ,@pa_coum_mobile varchar(25)  
       ,@pa_coum_email varchar(25)  
       ,@pa_coum_rmks varchar(250)  
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
        , @l_coum_id         BIGINT      
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
         SELECT @l_coum_id = ISNULL(MAX(coum_id),0)+ 1  
         FROM  COURIER_MSTR WITH (NOLOCK)  
         --      
         BEGIN TRANSACTION      
         --      
         INSERT INTO COURIER_MSTR      
         (coum_id  
  ,coum_no  
  ,coum_adr1  
  ,coum_adr2  
  ,coum_adr3  
  ,coum_adr_city  
  ,coum_adr_state  
  ,coum_adr_country  
  ,coum_adr_zip  
  ,coum_cont_per  
  ,coum_off_ph1  
  ,coum_off_ph2  
  ,coum_off_fax1  
  ,coum_off_fax2  
  ,coum_res_ph1  
  ,coum_res_ph2  
  ,coum_mobile  
  ,coum_email  
  ,coum_created_by  
  ,coum_created_dt  
  ,coum_lst_upd_by  
  ,coum_lst_upd_dt  
  ,coum_deleted_ind  
  ,coum_rmks  
     )      
         VALUES      
         (@l_coum_id         
        ,@pa_coum_no   
  ,@pa_coum_adr1   
  ,@pa_coum_adr2   
  ,@pa_coum_adr3   
  ,@pa_coum_adr_city   
  ,@pa_coum_adr_state   
  ,@pa_coum_adr_country   
  ,@pa_coum_adr_zip   
  ,@pa_coum_cont_per   
  ,@pa_coum_off_ph1   
  ,@pa_coum_off_ph2   
  ,@pa_coum_off_fax1   
  ,@pa_coum_off_fax2   
  ,@pa_coum_res_ph1   
  ,@pa_coum_res_ph2   
  ,@pa_coum_mobile   
  ,@pa_coum_email   
    
         , @PA_LOGIN_NAME      
         , GETDATE()      
         , @PA_LOGIN_NAME      
         , GETDATE()      
         , 1    
         ,@pa_coum_rmks     
         )      
         --      
         SET @@L_ERROR = @@ERROR      
         --      
         IF @@L_ERROR  > 0      
         BEGIN      
         --      
           ROLLBACK TRANSACTION      
           --      
           SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER      
          +@pa_coum_no +@COLDELIMITER      
  +@pa_coum_adr1 +@COLDELIMITER      
  +@pa_coum_adr2 +@COLDELIMITER      
  +@pa_coum_adr3 +@COLDELIMITER      
  +@pa_coum_adr_city +@COLDELIMITER      
  +@pa_coum_adr_state +@COLDELIMITER      
  +@pa_coum_adr_country+@COLDELIMITER       
  +@pa_coum_adr_zip +@COLDELIMITER      
  +@pa_coum_cont_per +@COLDELIMITER      
  +@pa_coum_off_ph1 +@COLDELIMITER      
  +@pa_coum_off_ph2 +@COLDELIMITER      
  +@pa_coum_off_fax1 +@COLDELIMITER      
  +@pa_coum_off_fax2 +@COLDELIMITER      
  +@pa_coum_res_ph1 +@COLDELIMITER      
  +@pa_coum_res_ph2 +@COLDELIMITER      
  +@pa_coum_mobile +@COLDELIMITER      
  +@pa_coum_email +@COLDELIMITER      
  +@pa_coum_rmks +@COLDELIMITER      
               
           +CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER      
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
             
     --      
     END  --ACTION TYPE = INS ENDS HERE      
     --      
      
           
     --      
     IF @PA_ACTION = 'DEL'      
     BEGIN      
       --      
       BEGIN TRANSACTION      
       --      
       UPDATE COURIER_MSTR WITH (ROWLOCK)      
       SET    coum_deleted_ind = 0      
            , coum_lst_upd_by  = @PA_LOGIN_NAME      
            , coum_lst_upd_dt  = GETDATE()      
       WHERE  coum_id          = CONVERT(INT,@@CURRSTRING)      
       --      
       SET @@L_ERROR = @@ERROR      
       --      
       IF @@L_ERROR > 0      
       BEGIN      
         --      
         SELECT @@T_ERRORSTR=''  
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
           
               
                   
         UPDATE COURIER_MSTR WITH (ROWLOCK)      
         SET   coum_no = @pa_coum_no  
   , coum_adr1= @pa_coum_adr1  
   , coum_adr2= @pa_coum_adr2  
   , coum_adr3= @pa_coum_adr3  
   , coum_adr_city= @pa_coum_adr_city  
   , coum_adr_state= @pa_coum_adr_state  
   , coum_adr_country= @pa_coum_adr_country  
   , coum_adr_zip= @pa_coum_adr_zip  
   , coum_cont_per= @pa_coum_cont_per  
   , coum_off_ph1= @pa_coum_off_ph1  
   , coum_off_ph2= @pa_coum_off_ph2  
   , coum_off_fax1= @pa_coum_off_fax1  
   , coum_off_fax2= @pa_coum_off_fax2  
   , coum_res_ph1= @pa_coum_res_ph1  
   , coum_res_ph2= @pa_coum_res_ph2  
   , coum_mobile= @pa_coum_mobile  
   , coum_email= @pa_coum_email  
   , coum_lst_upd_by= @pa_login_name  
   , coum_lst_upd_dt= GETDATE()  
   , coum_rmks= @pa_coum_rmks  
         WHERE coum_id       = CONVERT(INT, @@CURRSTRING)      
         --      
               
                      
         SET @@L_ERROR = @@ERROR      
         --      
         IF @@L_ERROR > 0      
         BEGIN      
         --      
          SET @@T_ERRORSTR = 'Successful'
               

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
