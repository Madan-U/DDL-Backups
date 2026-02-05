-- Object: PROCEDURE citrus_usr.PR_INS_UPD_DPACCTCLOSE
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--select * from BATCHNO_CDSL_MSTR  
--select * from CLOSURE_ACCT_cdsl_MSTR  
--select * from CLOSURE_ACCT_CDSL_MAK  
  
    
    
/*       
 -------- WHEN CHECKER PAGE IS -----------------    
EXEC PR_INS_UPD_DPACCTCLOSE	0	INS	HO	12345678	1234567800000990	14/05/2009	S	2	99	B	852	258	0	0	0	1	*|~*	|*~|	    
 
-------- WHEN SIMPLE PAGE IS ----------------- 
    
exec PR_INS_UPD_DPACCTCLOSE '0','INS','VISHAL',12345678	,1234567800000041,'19/05/2009','A',1,91	,'N','','',0,0,0,1,'*|~*','|*~|',''	

exec PR_INS_UPD_DPACCTCLOSE '0','INS','VISHAL',12345678	,1234567800000041,'19/05/2009','A',1,91	,'N','','',0,0,0,0,'*|~*','|*~|',''	
  
    
*/    
CREATE PROCEDURE [citrus_usr].[PR_INS_UPD_DPACCTCLOSE]    
   (    
       @PA_ID                 VARCHAR(8000)            
      ,@PA_ACTION             VARCHAR(20)            
      ,@PA_LOGIN_NAME         VARCHAR(20)            
      ,@PA_DPMID              VARCHAR(25)           
      ,@PA_BO_ID              VARCHAR(16)         
      ,@PA_CLSR_DATE          VARCHAR(11)         
      ,@PA_TRX_TYPE           CHAR(1)          
      ,@PA_INI_BY             CHAR(1)          
      ,@PA_REASON_CD          CHAR(2)          
      ,@PA_REMAINING_BAL      CHAR(1)          
      ,@PA_NEW_BO_ID          VARCHAR(16)          
      ,@PA_RMKS               VARCHAR(100)          
      ,@PA_REQ_INT_REFNO      VARCHAR(20)          
      ,@PA_STATUS             VARCHAR(5)          
      ,@PA_ERROR_CD           VARCHAR(100)          
      ,@PA_CHK_YN             INT            
      ,@ROWDELIMITER          CHAR(4) =  '*|~*'            
      ,@COLDELIMITER          CHAR(4) = '|*~|'            
      ,@PA_ERRMSG             VARCHAR(8000) OUTPUT            
)            
AS            
/*            
*********************************************************************************            
 SYSTEM         : Citrus            
 MODULE NAME    : PR_INS_UPD_DPACCTCLOSE            
 DESCRIPTION    : THIS PROCEDURE WILL ADD NEW VALUES TO  ACCOUNT CLOSURE            
 COPYRIGHT(C)   : Marketplace Technology pvt. ltd.            
 VERSION HISTORY:            
 VERS.  AUTHOR           DATE        REASON            
 -----  -------------   ----------   -------------------------------------------------            
 1.0    TUSHAR          19.01.2008             
-----------------------------------------------------------------------------------          
*********************************************************************************           
*/            
--            
BEGIN            
--            
  SET NOCOUNT ON            
            
  DECLARE @T_ERRORSTR      VARCHAR(8000)          
          , @L_CLSRM_ID       BIGINT          
          , @L_CLSR_ID        BIGINT          
          , @L_ERROR         BIGINT          
          , @DELIMETER        VARCHAR(10)          
          , @@REMAININGSTRING VARCHAR(8000)          
          , @@CURRSTRING      VARCHAR(8000)          
          , @@FOUNDAT         INTEGER          
          , @@DELIMETERLENGTH INT                      
          , @L_DPM_ID         NUMERIC          
          , @L_DPAM_ID        NUMERIC        
    --          
    SET @L_ERROR         = 0          
    SET @T_ERRORSTR      = ''          
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
       SELECT @L_DPM_ID = DPM_ID          
      FROM  DP_MSTR  WHERE DPM_DPID = @PA_DPMID AND DPM_DELETED_IND = 1            
           
       SELECT @L_DPAM_ID = DPAM_ID         
       FROM DP_ACCT_MSTR WHERE DPAM_sba_NO = @PA_BO_ID AND DPAM_DELETED_IND = 1        
        
       IF @PA_ACTION = 'INS'  --ACTION TYPE = INS BEGINS HERE          
       BEGIN          
         --          
         IF @PA_CHK_YN = 0 -- IF MAKER CHECKER FUNCTIONALITY IS NOT REQD          
         BEGIN          
         --          
           SELECT @L_CLSR_ID = ISNULL(MAX(CLSR_ID),0)+ 1          
           FROM  CLOSURE_ACCT_CDSL WITH (NOLOCK)             
           --          
           BEGIN TRANSACTION          
           --   
       
	 PRINT('YES')

           INSERT INTO CLOSURE_ACCT_CDSL          
           (CLSR_ID          
           ,CLSR_DPM_ID          
           ,CLSR_BO_ID          
           ,CLSR_TRX_TYPE          
           ,CLSR_INI_BY          
           ,CLSR_REASON_CD          
           ,CLSR_REMAINING_BAL          
           ,CLSR_NEW_BO_ID          
           ,CLSR_RMKS          
           ,CLSR_REQ_INT_REFNO          
           ,CLSR_STATUS          
           ,CLSR_ERROR_CD          
           ,CLSR_CREATED_BY          
           ,CLSR_CREATED_DT          
           ,CLSR_LST_UPD_BY          
           ,CLSR_LST_UPD_DT          
           ,CLSR_DELETED_IND         
           ,CLSR_DATE         
           ,CLSR_DPAM_ID
		         
           )          
           VALUES          
           (@L_CLSR_ID          
           ,@L_DPM_ID          
           ,@PA_BO_ID          
           ,@PA_TRX_TYPE          
           ,@PA_INI_BY          
           ,@PA_REASON_CD          
           ,@PA_REMAINING_BAL          
           ,@PA_NEW_BO_ID          
           ,@PA_RMKS          
           ,@PA_REQ_INT_REFNO          
           ,@PA_STATUS          
           ,@PA_ERROR_CD          
           ,@PA_LOGIN_NAME          
           ,GETDATE()          
           ,@PA_LOGIN_NAME          
           ,GETDATE()          
           ,1         
           ,COnvert(DATETIME,@PA_CLSR_DATE,103)         
           ,@L_DPAM_ID        
           )          
           --          
           SET @l_error = @@error          
           IF @l_error <> 0          
           BEGIN          
           --          
             IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)          
             BEGIN          
             --          
               SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)          
             --          
             END          
             ELSE          
             BEGIN          
             --          
               SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'          
             --          
          END          
          
             ROLLBACK TRANSACTION           
           --          
           END          
           ELSE          
           BEGIN          
           --          
             COMMIT TRANSACTION     
   

SET @T_ERRORSTR     ='SUCCESS'    
           --          
           END          
         --          
         END          
         --          
         IF @PA_CHK_YN = 1 -- IF MAKER IS INSERTING          
         BEGIN          
           --     
	
PRINT('NO') 
    
           SELECT @L_CLSRM_ID = ISNULL(MAX(CLSRM.CLSR_ID),0)+1          
           FROM   CLOSURE_ACCT_CDSL_MAK CLSRM WITH (NOLOCK)          
           --          
           SELECT @L_CLSR_ID = ISNULL(MAX(CLSR.CLSR_ID),0)+1          
           FROM CLOSURE_ACCT_CDSL CLSR WITH (NOLOCK)          
           --          
           BEGIN TRANSACTION          
           --          
           IF @L_CLSRM_ID > @L_CLSR_ID          
           BEGIN          
             --          
             SET  @L_CLSR_ID = @L_CLSRM_ID          
             --          
           END          
           --          
			
           INSERT INTO CLOSURE_ACCT_CDSL_MAK          
           (
			CLSR_ID          
           ,CLSR_DPM_ID          
           ,CLSR_BO_ID          
           ,CLSR_TRX_TYPE          
           ,CLSR_INI_BY          
           ,CLSR_REASON_CD          
           ,CLSR_REMAINING_BAL          
           ,CLSR_NEW_BO_ID          
           ,CLSR_RMKS          
           ,CLSR_REQ_INT_REFNO          
           ,CLSR_STATUS          
           ,CLSR_ERROR_CD          
           ,CLSR_CREATED_BY          
           ,CLSR_CREATED_DT          
           ,CLSR_LST_UPD_BY          
           ,CLSR_LST_UPD_DT          
           ,CLSR_DELETED_IND          
           ,CLSR_DATE        
           ,CLSR_DPAM_ID         
           )          
           VALUES          
           (@L_CLSR_ID          
           ,@L_DPM_ID          
           ,@PA_BO_ID          
           ,@PA_TRX_TYPE          
           ,@PA_INI_BY          
           ,@PA_REASON_CD          
           ,@PA_REMAINING_BAL          
           ,@PA_NEW_BO_ID          
           ,@PA_RMKS          
           ,@PA_REQ_INT_REFNO          
           ,@PA_STATUS          
           ,@PA_ERROR_CD          
           ,@PA_LOGIN_NAME          
           ,GETDATE()          
           ,@PA_LOGIN_NAME          
           ,GETDATE()          
           ,0         
           ,COnvert(DATETIME,@PA_CLSR_DATE,103)        
           ,@L_DPAM_ID        
           )          
           --         
           SET @l_error = @@error          
           IF @l_error <> 0          
           BEGIN          
           --          
             IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)          
             BEGIN          
             --          
               SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)          
             --          
             END          
             ELSE          
             BEGIN          
             --          
               SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'          
             --          
             END          
          
             ROLLBACK TRANSACTION           
           --          
           END          
           ELSE          
           BEGIN          
           --          
             COMMIT TRANSACTION       
        
  SET @T_ERRORSTR     ='SUCCESS'    
      
           --          
           END          
         --          
         END          
       --          
       END  --ACTION TYPE = INS ENDS HERE          
       --          



--------------------------------------------------------------------------------------



            
       IF @PA_ACTION = 'APP'          
       BEGIN          
       --cOMMENTED BY JITESH ON 25032010          
--         IF EXISTS(SELECT CLSR_ID          
--                   FROM   CLOSURE_ACCT_CDSL WITH(NOLOCK)          
--                   WHERE  CLSR_ID = CONVERT(bigINT, @@CURRSTRING)) 
		 IF EXISTS(SELECT CLSR_ID          
                   FROM   CLOSURE_ACCT_CDSL_MAK WITH(NOLOCK)          
                   WHERE  CLSR_ID = CONVERT(bigINT, @@CURRSTRING)
				   AND CLSR_DELETED_IND = 6) 
				   	        
         BEGIN          
         --          
      
           BEGIN TRANSACTION          
           --   
      
           UPDATE CLSR WITH (ROWLOCK)          
           SET    CLSR.CLSR_DPM_ID      = CLSRM.CLSR_DPM_ID        
                 ,CLSR_DPAM_ID          = CLSRM.CLSR_DPAM_ID                       
                 ,CLSR.CLSR_BO_ID       = CLSRM.CLSR_BO_ID                        
                 ,CLSR.CLSR_DATE        = CLSRM.CLSR_DATE             
                 ,CLSR.CLSR_TRX_TYPE    = CLSRM.CLSR_TRX_TYPE                     
                 ,CLSR.CLSR_INI_BY      = CLSRM.CLSR_INI_BY                        
                 ,CLSR.CLSR_REASON_CD   = CLSRM.CLSR_REASON_CD                    
				 ,CLSR.CLSR_REMAINING_BAL   = CLSRM.CLSR_REMAINING_BAL                
                 ,CLSR.CLSR_NEW_BO_ID      = CLSRM.CLSR_NEW_BO_ID                    
                 ,CLSR.CLSR_RMKS               = CLSRM.CLSR_RMKS                         
                 ,CLSR.CLSR_REQ_INT_REFNO      = CLSRM.CLSR_REQ_INT_REFNO                
                 ,CLSR.CLSR_STATUS             = CLSRM.CLSR_STATUS                       
                 ,CLSR.CLSR_ERROR_CD           = CLSRM.CLSR_ERROR_CD                     
           FROM   CLOSURE_ACCT_CDSL CLSR          
                , CLOSURE_ACCT_CDSL_MAK CLSRM          
           WHERE  CLSR.CLSR_ID             = CONVERT(bigINT,@@CURRSTRING)          
           AND    CLSRM.CLSR_ID            = CLSR.CLSR_ID          
           AND    CLSR.CLSR_DELETED_IND    = 1          
           AND    CLSRM.CLSR_DELETED_IND   = 6          
           AND    CLSRM.CLSR_CREATED_BY <> @PA_LOGIN_NAME      
      
           --          
           SET @L_ERROR= @@ERROR          
           --          
           IF @L_ERROR > 0          
           BEGIN    --ERROR STRING WILL BE GENERATED IF ANY ERROR ERROR REPORTED          
           --          
       ROLLBACK TRANSACTION          
           --          
           END  
--Added by Jitesh on 12-Oct-2010
		ELSE IF EXISTS(SELECT CLSR_ID          
                   FROM   CLOSURE_ACCT_CDSL_MAK WITH(NOLOCK)          
                   WHERE  CLSR_ID = CONVERT(bigINT, @@CURRSTRING)
				   AND CLSR_DELETED_IND = 4) 
				   	        
         BEGIN          
         --          
      
           BEGIN TRANSACTION          
           --   
      
           UPDATE CLSR WITH (ROWLOCK)          
           SET    CLSR_LST_UPD_BY=@pa_login_name
				,CLSR_LST_UPD_DT=getdate()
				,CLSR_DELETED_IND =0
           FROM   CLOSURE_ACCT_CDSL CLSR          
                , CLOSURE_ACCT_CDSL_MAK CLSRM          
           WHERE  CLSR.CLSR_ID             = CONVERT(bigINT,@@CURRSTRING)          
           AND    CLSRM.CLSR_ID            = CLSR.CLSR_ID          
           AND    CLSR.CLSR_DELETED_IND    = 1          
           AND    CLSRM.CLSR_DELETED_IND   = 4          
           AND    CLSRM.CLSR_CREATED_BY <> @PA_LOGIN_NAME  
		END  
--End by Jitesh on 12-Oct-2010       
           ELSE          
           BEGIN          
             --    
    
             UPDATE CLOSURE_ACCT_CDSL_MAK WITH (ROWLOCK)          
             SET    CLSR_DELETED_IND  = 5         
                  , CLSR_LST_UPD_BY   = @PA_LOGIN_NAME          
                  , CLSR_LST_UPD_DT   = GETDATE()          
             WHERE  CLSR_ID           = CONVERT(bigINT,@@CURRSTRING)          
             AND    CLSR_CREATED_BY  <> @PA_LOGIN_NAME          
             AND    CLSR_DELETED_IND  = 4        
             --          
             SET @l_error = @@error          
             IF @l_error <> 0          
             BEGIN                 
			 -- 
			   --Added by Jitesh on 12-Oct-2010         
               IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)          
               BEGIN          
               --          
                 SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)          
               --          
               END          
               ELSE          
               BEGIN          
               --          
                 SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'          
               --          
               END          
          
               ROLLBACK TRANSACTION           
             --          
             END          
             ELSE          
             BEGIN          
             --          
               COMMIT TRANSACTION     
    
    SET @T_ERRORSTR     ='SUCCESS'         
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
      
           INSERT INTO CLOSURE_ACCT_CDSL          
           (CLSR_ID          
           ,CLSR_DPM_ID          
           ,CLSR_BO_ID    
           ,CLSR_TRX_TYPE          
           ,CLSR_INI_BY          
           ,CLSR_REASON_CD          
           ,CLSR_REMAINING_BAL          
           ,CLSR_NEW_BO_ID          
           ,CLSR_RMKS          
           ,CLSR_REQ_INT_REFNO          
           ,CLSR_STATUS          
           ,CLSR_ERROR_CD          
           ,CLSR_CREATED_BY          
           ,CLSR_CREATED_DT          
           ,CLSR_LST_UPD_BY          
           ,CLSR_LST_UPD_DT          
           ,CLSR_DELETED_IND        
           ,CLSR_DATE          
           ,CLSR_DPAM_ID        
           )          
           SELECT CLSR_ID          
                 ,CLSR_DPM_ID          
                 ,CLSR_BO_ID          
                 ,CLSR_TRX_TYPE          
                 ,CLSR_INI_BY          
                 ,CLSR_REASON_CD          
                 ,CLSR_REMAINING_BAL          
                 ,CLSR_NEW_BO_ID                         
				 ,CLSR_RMKS          
                 ,CLSR_REQ_INT_REFNO          
                 ,CLSR_STATUS          
                 ,CLSR_ERROR_CD          
                 ,CLSR_CREATED_BY          
                 ,CLSR_CREATED_DT          
                 ,CLSR_LST_UPD_BY          
                 ,CLSR_LST_UPD_DT          
                 ,1          
                 ,CLSR_DATE        
                 ,CLSR_DPAM_ID        
           FROM   CLOSURE_ACCT_CDSL_MAK                  CLSRM WITH (NOLOCK)          
           WHERE  CLSRM.CLSR_ID           = CONVERT(bigINT,@@CURRSTRING)          
           AND    CLSRM.CLSR_CREATED_BY  <> @PA_LOGIN_NAME          
           AND    CLSRM.CLSR_DELETED_IND  = 0          
           --          
           SET @L_ERROR= CONVERT(INT, @@ERROR)          
           --          
           IF @L_ERROR > 0          
           BEGIN          
           --          
            
				IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)  
                BEGIN  
                --  
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)  
                --  
                END  
                ELSE  
                BEGIN  
                --  
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'  
                --  
                END  
				 ROLLBACK TRANSACTION          
           --          
           END          
           ELSE          
           BEGIN          
             -- 
        
             UPDATE CLOSURE_ACCT_CDSL_MAK WITH (ROWLOCK)          
             SET    CLSR_DELETED_IND  = 1          
                  , CLSR_LST_UPD_BY   = @PA_LOGIN_NAME          
                  , CLSR_LST_UPD_DT   = GETDATE()          
             WHERE  CLSR_ID           = CONVERT(bigINT,@@CURRSTRING)          
             AND    CLSR_CREATED_BY  <> @PA_LOGIN_NAME          
             AND    CLSR_DELETED_IND  = 0          
            
             SET @l_error = @@error          
             IF @l_error <> 0          
             BEGIN          
             --          
               IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)          
               BEGIN          
               --          
                 SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)          
               --          
               END          
               ELSE          
               BEGIN          
               --          
                 SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'          
               --          
               END          
          
               ROLLBACK TRANSACTION           
             --          
             END          
             ELSE          
             BEGIN         
             --          
               COMMIT TRANSACTION      
SET @T_ERRORSTR     ='SUCCESS'        
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
         UPDATE CLOSURE_ACCT_CDSL_MAK WITH (ROWLOCK)          
         SET    CLSR_DELETED_IND = 3          
              , CLSR_LST_UPD_BY  = @PA_LOGIN_NAME          
              , CLSR_LST_UPD_DT  = GETDATE()          
         WHERE  CLSR_ID          = CONVERT(bigINT,@@CURRSTRING)          
         AND    CLSR_DELETED_IND = 0          
         --          
         SET @l_error = @@error          
         IF @l_error <> 0          
         BEGIN          
         --          
           IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)          
           BEGIN          
           --          
             SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)          
           --          
           END          
           ELSE          
           BEGIN          
           --          
             SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'          
           --          
           END          
          
           ROLLBACK TRANSACTION           
         --          
         END          
         ELSE          
         BEGIN          
         --          
           COMMIT TRANSACTION     
    
  SET @T_ERRORSTR     ='SUCCESS'         
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
         /*UPDATE CLOSURE_ACCT_CDSL WITH (ROWLOCK)          
         SET    CLSR_DELETED_IND = 0          
              , CLSR_LST_UPD_BY  = @PA_LOGIN_NAME          
              , CLSR_LST_UPD_DT  = GETDATE()          
         WHERE  CLSR_ID          = CONVERT(INT,@@CURRSTRING)    */      
		 IF @PA_CHK_YN = 0
		 BEGIN  

			delete from CLOSURE_ACCT_CDSL WHERE  CLSR_ID          = CONVERT(bigINT,@@CURRSTRING)
		 end

		else
		begin
			INSERT INTO CLOSURE_ACCT_CDSL_MAK          
             (CLSR_ID          
             ,CLSR_DPM_ID          
             ,CLSR_BO_ID          
             ,CLSR_TRX_TYPE          
             ,CLSR_INI_BY          
             ,CLSR_REASON_CD          
             ,CLSR_REMAINING_BAL          
             ,CLSR_NEW_BO_ID          
             ,CLSR_RMKS          
             ,CLSR_REQ_INT_REFNO          
             ,CLSR_STATUS          
             ,CLSR_ERROR_CD          
             ,CLSR_CREATED_BY          
             ,CLSR_CREATED_DT          
             ,CLSR_LST_UPD_BY          
             ,CLSR_LST_UPD_DT          
             ,CLSR_DELETED_IND          
             ,CLSR_DATE        
             ,CLSR_DPAM_ID        
             )          
             VALUES          
             (CONVERT(bigINT,@@CURRSTRING)                
             ,@L_DPM_ID          
             ,@PA_BO_ID          
             ,@PA_TRX_TYPE          
             ,@PA_INI_BY          
             ,@PA_REASON_CD          
             ,@PA_REMAINING_BAL          
             ,@PA_NEW_BO_ID          
             ,@PA_RMKS          
             ,@PA_REQ_INT_REFNO          
             ,@PA_STATUS          
             ,@PA_ERROR_CD          
             ,@PA_LOGIN_NAME          
             ,GETDATE()          
             ,@PA_LOGIN_NAME          
             ,GETDATE()          
             ,4         
             ,COnvert(DATETIME,@PA_CLSR_DATE,103)      
             ,@L_DPAM_ID        
             )
		end      
         --          
         SET @l_error = @@error          
         IF @l_error <> 0          
         BEGIN          
         --          
           IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)          
           BEGIN          
           --          
             SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)          
           --          
           END          
           ELSE          
           BEGIN          
           --          
             SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'          
           --          
           END          
          
           ROLLBACK TRANSACTION           
         --          
         END          
         ELSE          
         BEGIN          
         --          
           COMMIT TRANSACTION      
    
SET @T_ERRORSTR     ='SUCCESS'        
         --          
         END          
       END          
       --          
       IF @PA_ACTION = 'EDT'--ACTION TYPE = EDT BEGINS HERE          
       BEGIN          
       --       
       
         IF @PA_CHK_YN = 0 -- IF NO MAKER CHECKER          
         BEGIN          
         --     
           
           BEGIN TRANSACTION          
           --          
            UPDATE CLSR WITH (ROWLOCK)          
            SET    CLSR.CLSR_DPM_ID             = @L_DPM_ID         
                  ,CLSR.CLSR_DPAM_ID            = @L_DPAM_ID                       
                  ,CLSR.CLSR_BO_ID              = @PA_BO_ID                        
                  ,CLSR.CLSR_DATE               = COnvert(DATETIME,@PA_CLSR_DATE,103)                                    
                  ,CLSR.CLSR_TRX_TYPE           = @PA_TRX_TYPE                     
                  ,CLSR.CLSR_INI_BY             = @PA_INI_BY                        
                  ,CLSR.CLSR_REASON_CD          = @PA_REASON_CD                    
                  ,CLSR.CLSR_REMAINING_BAL      = @PA_REMAINING_BAL                
                  ,CLSR.CLSR_NEW_BO_ID          = @PA_NEW_BO_ID                    
                  ,CLSR.CLSR_RMKS               = @PA_RMKS                         
                  ,CLSR.CLSR_REQ_INT_REFNO      = @PA_REQ_INT_REFNO                
                  ,CLSR.CLSR_STATUS             = @PA_STATUS                       
                  ,CLSR.CLSR_ERROR_CD           = @PA_ERROR_CD         
            FROM   CLOSURE_ACCT_CDSL            CLSR          
            WHERE  CLSR.CLSR_ID                 = CONVERT(bigINT,@@CURRSTRING)          
            AND    CLSR.CLSR_DELETED_IND        = 1          
                      
           --          
          SET @l_error = @@error          
          IF @l_error <> 0          
          BEGIN          
          --          
            IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)          
            BEGIN          
            --          
              SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)          
            --          
            END          
            ELSE          
            BEGIN          
            --          
              SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'          
            --          
            END          
         
            ROLLBACK TRANSACTION           
          --          
          END          
          ELSE          
          BEGIN          
          --          
            COMMIT TRANSACTION       
    
SET @T_ERRORSTR     ='SUCCESS'       
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
           UPDATE CLOSURE_ACCT_CDSL_MAK WITH (ROWLOCK)          
           SET    CLSR_DELETED_IND = 2          
                , CLSR_LST_UPD_BY  = @PA_LOGIN_NAME          
                , CLSR_LST_UPD_DT  = GETDATE()          
           WHERE  CLSR_ID          = CONVERT(INT, @@CURRSTRING)          
           AND    CLSR_DELETED_IND in (0,4,6)          
           --          
           SET @L_ERROR= @@ERROR          
           --          
           IF @L_ERROR> 0          
           BEGIN          
           --          
             ROLLBACK TRANSACTION          
           --          
           END          
           ELSE          
           BEGIN          
           --          

             declare @l_dele_ind numeric
             select @l_dele_ind = case when exists(select clsr_id from CLOSURE_ACCT_CDSL where clsr_id  = CONVERT(bigINT,@@CURRSTRING)  and clsr_deleted_ind = 1)  then '6' else '0' end 
             INSERT INTO CLOSURE_ACCT_CDSL_MAK          
             (CLSR_ID          
             ,CLSR_DPM_ID          
             ,CLSR_BO_ID          
             ,CLSR_TRX_TYPE          
             ,CLSR_INI_BY          
             ,CLSR_REASON_CD          
             ,CLSR_REMAINING_BAL          
             ,CLSR_NEW_BO_ID          
             ,CLSR_RMKS          
             ,CLSR_REQ_INT_REFNO          
             ,CLSR_STATUS          
             ,CLSR_ERROR_CD          
             ,CLSR_CREATED_BY          
             ,CLSR_CREATED_DT          
             ,CLSR_LST_UPD_BY          
             ,CLSR_LST_UPD_DT          
             ,CLSR_DELETED_IND          
             ,CLSR_DATE        
             ,CLSR_DPAM_ID        
             )          
             VALUES          
             (CONVERT(bigINT,@@CURRSTRING)                
             ,@L_DPM_ID          
             ,@PA_BO_ID          
             ,@PA_TRX_TYPE          
             ,@PA_INI_BY          
             ,@PA_REASON_CD          
             ,@PA_REMAINING_BAL          
             ,@PA_NEW_BO_ID          
             ,@PA_RMKS          
             ,@PA_REQ_INT_REFNO          
             ,@PA_STATUS          
             ,@PA_ERROR_CD          
             ,@PA_LOGIN_NAME          
             ,GETDATE()          
             ,@PA_LOGIN_NAME          
             ,GETDATE()          
             ,@l_dele_ind          
             ,COnvert(DATETIME,@PA_CLSR_DATE,103)      
             ,@L_DPAM_ID        
             )          
             --          
             SET @l_error = @@error          
             IF @l_error <> 0          
             BEGIN          
             --          
               IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)          
               BEGIN          
               --          
                 SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)          
               --          
               END          
               ELSE          
               BEGIN          
               --          
                 SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'          
               --          
               END          
          
               ROLLBACK TRANSACTION           
             --          
             END          
             ELSE          
             BEGIN          
             --          
               COMMIT TRANSACTION    
SET @T_ERRORSTR     ='SUCCESS'          
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
         
    --          
    END          
  --     
SET @PA_ERRMSG = @T_ERRORSTR               
--          
END

GO
