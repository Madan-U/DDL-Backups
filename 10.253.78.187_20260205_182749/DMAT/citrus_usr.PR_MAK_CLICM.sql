-- Object: PROCEDURE citrus_usr.PR_MAK_CLICM
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--pr_mak_clicm '0','EDTMSTR','HO','FI','FI','3|*~|','','',0,'*|~*','|*~|',''  
  
--select * from client_ctgry_mstr  
CREATE PROCEDURE [citrus_usr].[PR_MAK_CLICM](@PA_ID             VARCHAR(8000)      
                             ,@PA_ACTION         VARCHAR(20)      
                             ,@PA_LOGIN_NAME     VARCHAR(20)      
                             ,@PA_CLICM_CD       VARCHAR(20)   = ''      
                             ,@PA_CLICM_DESC     VARCHAR(200)  = ''      
                             ,@PA_CLICM_BUSM_YN  VARCHAR(8000)     
                             ,@PA_CLICM_RMKS     VARCHAR(200)      
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
 MODULE NAME    : PR_MAK_CLICM      
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE MAKER CHECKER FACILITY FOR CLIENT CATEGORY MASTER      
 COPYRIGHT(C)   : Marketplace Technologies PVT. LTD.      
 VERSION HISTORY: 1.0      
 VERS.  AUTHOR            DATE          REASON      
 -----  -------------     ------------  -----------------------------------------    
 2.0    SUKHVINDER/TUSHAR 4-JAN-2007    VERSION.      
---------------------------------------------------------------------------------     
*********************************************************************************      
*/      
BEGIN      
--      
  SET NOCOUNT ON      
  --      
  DECLARE @T_ERRORSTR          VARCHAR(8000)      
        , @L_CLICMM_ID         BIGINT      
        , @L_CLICM_ID          BIGINT      
        , @L_ERROR             BIGINT      
        , @DELIMETER           VARCHAR(10)      
        , @REMAININGSTRING     VARCHAR(8000)      
        , @CURRSTRING          VARCHAR(8000)      
        , @FOUNDAT             INT      
        , @DELIMETERLENGTH     INT      
        , @L_CLICM_ENTTM_ID    NUMERIC      
        , @L_COUNTER           NUMERIC      
        , @l_exists            NUMERIC      
        , @REMAININGSTRING_VAL VARCHAR(8000)      
        , @FOUNDAT_VAL         INT      
        , @L_DELIMETER         VARCHAR(10)      
        , @CURRSTRING_VAL      VARCHAR(8000)      
        , @l_enttm_id          NUMERIC      
        , @l_ind               NUMERIC      
        , @TEMP_ID             NUMERIC       
        , @L_DELETED_IND       SMALLINT    
        , @L_BUSM_BIT          integer    
        , @l_access_cd         VARCHAR(50)    
        , @L_BUSM_CD           varchar(25)        
  --    
  SET @l_busm_bit      = 0    
  --    
  CREATE TABLE #TEMP_CLICMM (      
        [CLICM_ID] [numeric](18, 0) NOT NULL ,      
        [CLICM_ENTTM_ID] [numeric](18, 0) NOT NULL ,      
        [CLICM_CD] [varchar] (20)  NOT NULL ,      
        [CLICM_DESC] [varchar] (200) NULL ,    
        [CLICM_BIT]  [int]          not null,    
        [CLICM_RMKS] [varchar] (250) NULL ,      
        [CLICM_CREATED_BY] [varchar] (25) NOT NULL ,      
        [CLICM_CREATED_DT] [datetime] NOT NULL ,      
        [CLICM_LST_UPD_BY] [varchar] (25) NOT NULL ,      
        [CLICM_LST_UPD_DT] [datetime] NOT NULL ,      
        [CLICM_DELETED_IND] [smallint] NOT NULL       
        )      
              
   CREATE TABLE #TEMP_CLICM (      
        [CLICM_ID] [numeric](18, 0) NOT NULL ,      
        [CLICM_ENTTM_ID] [numeric](18, 0) NOT NULL ,      
        [CLICM_CD] [varchar] (20)  NOT NULL ,      
        [CLICM_DESC] [varchar] (200) NULL ,    
        [CLICM_BIT]  [int]          not null,    
        [CLICM_RMKS] [varchar] (250) NULL ,      
        [CLICM_CREATED_BY] [varchar] (25) NOT NULL ,      
        [CLICM_CREATED_DT] [datetime] NOT NULL ,      
        [CLICM_LST_UPD_BY] [varchar] (25) NOT NULL ,      
        [CLICM_LST_UPD_DT] [datetime] NOT NULL ,      
        [CLICM_DELETED_IND] [smallint] NOT NULL       
        )      
              
  IF @PA_ACTION<>'APP' AND @PA_ACTION<>'REJ'    and @pa_chk_yn = 1  
  BEGIN      
  --      
     INSERT INTO #TEMP_CLICMM      
     ( clicm_id      
      ,clicm_enttm_id      
      ,clicm_cd     
      ,clicm_desc      
      ,clicm_bit    
      ,clicm_rmks      
      ,clicm_created_by      
      ,clicm_created_dt      
      ,clicm_lst_upd_by      
      ,clicm_lst_upd_dt      
      ,clicm_deleted_ind      
     )      
     SELECT  CLICM_ID      
            ,CLICM_ENTTM_ID      
            ,CLICM_CD      
            ,CLICM_DESC      
            ,clicm_bit    
            ,CLICM_RMKS      
            ,CLICM_CREATED_BY      
            ,CLICM_CREATED_DT      
            ,CLICM_LST_UPD_BY      
            ,CLICM_LST_UPD_DT      
            ,CLICM_DELETED_IND      
     FROM    CLIENT_CTGRY_MSTR_MAK      
     WHERE   CLICM_DELETED_IND = 0      
     AND     CLICM_ID          = @PA_ID      
     --    
     INSERT INTO #TEMP_CLICM      
     ( CLICM_ID      
      ,CLICM_ENTTM_ID      
      ,CLICM_CD      
      ,CLICM_DESC    
      ,CLICM_BIT    
      ,CLICM_RMKS      
      ,CLICM_CREATED_BY      
      ,CLICM_CREATED_DT      
      ,CLICM_LST_UPD_BY      
      ,CLICM_LST_UPD_DT      
      ,CLICM_DELETED_IND      
     )      
     SELECT CLICM.CLICM_ID      
          , ENTCM.ENTCM_ENTTM_ID      
          , CLICM.CLICM_CD      
          , CLICM.CLICM_DESC    
          , CLICM.CLICM_BIT    
          , CLICM.CLICM_RMKS      
          , CLICM.CLICM_CREATED_BY      
          , CLICM.CLICM_CREATED_DT      
          , CLICM.CLICM_LST_UPD_BY      
          , CLICM.CLICM_LST_UPD_DT      
          , CLICM.CLICM_DELETED_IND      
      FROM  CLIENT_CTGRY_MSTR   CLICM      
          , ENTTM_CLICM_MAPPING ENTCM      
      WHERE CLICM.CLICM_ID          = ENTCM.ENTCM_CLICM_ID       
      AND   CLICM.CLICM_DELETED_IND = 1      
      AND   CLICM_ID                = @PA_ID      
  --      
  END      
  --      
  SET @L_DELIMETER     = @ROWDELIMITER      
  SET @L_ERROR         = 0      
  SET @T_ERRORSTR      = ''      
  SET @DELIMETER       = @ROWDELIMITER      
  SET @DELIMETERLENGTH = LEN(@ROWDELIMITER)      
  SET @REMAININGSTRING = @PA_ID      
  --      
  WHILE @REMAININGSTRING <> ''      
  BEGIN      
  --      
      SET @FOUNDAT = 0      
      SET @FOUNDAT =  PATINDEX('%'+@DELIMETER+'%',@REMAININGSTRING)      
      --      
      IF @FOUNDAT > 0      
      BEGIN      
      --      
        SET @CURRSTRING      = SUBSTRING(@REMAININGSTRING, 0,@FOUNDAT)      
        SET @REMAININGSTRING = SUBSTRING(@REMAININGSTRING, @FOUNDAT+@DELIMETERLENGTH,LEN(@REMAININGSTRING)- @FOUNDAT+@DELIMETERLENGTH)      
      --      
      END      
      ELSE      
      BEGIN      
      --      
        SET @CURRSTRING      = @REMAININGSTRING      
        SET @REMAININGSTRING = ''      
      --      
      END      
      --      
      IF @CURRSTRING <> ''      
      BEGIN      
      --      
        IF (ISNULL(@pa_id,'') <> '') AND (ISNULL(@pa_login_name,'')<>'')      
        BEGIN      
        --    
          --**clicm_BIT**--    
          DECLARE @l          INT    
                , @l_busm_id  INT     
          --          
          SET @l_counter = CITRUS_USR.UFN_COUNTSTRING(@PA_CLICM_BUSM_YN,'|*~|')    
          SET @l         = 1    
          --    
          WHILE @l <= @l_counter     
          BEGIN--#1    
          --    
            SET @l_busm_id       = CONVERT(INT,CITRUS_USR.FN_SPLITVAL(@PA_CLICM_BUSM_YN,@l))    
            print @l_busm_id   
            --    
            SELECT @L_BUSM_CD    = BUSM_CD      
            FROM   BUSINESS_MSTR   WITH (NOLOCK)    
            WHERE  BUSM_ID       = CONVERT(INT, @l_busm_id)    
            --    
            SELECT @l_access_cd   = CASE WHEN @l_busm_cd ='ALL'  THEN 'BUS_%'     
                                         ELSE 'BUS_' + @l_busm_cd     
                                         END   
            print  citrus_usr.fn_get_busm_access(@l_access_cd)    
            --                                 
            SET @l_busm_bit = citrus_usr.fn_get_busm_access(@l_access_cd) | @l_busm_bit    
            print @l_busm_bit   
            --    
            SET @l = @l + 1                                
          --    
          END--#1    
          --**clicm_BIT**--    
          IF @PA_CHK_YN = 0      
          BEGIN      
          --    
            SELECT @L_CLICM_ID = CLICM_ID FROM CLIENT_CTGRY_MSTR WHERE CLICM_CD = @PA_CLICM_CD AND clicm_deleted_ind = 1      
            --    
            IF @PA_ACTION = 'EDTMSTR'      
            BEGIN      
            --      
              IF ISNULL(@PA_CLICM_CD,'') <> ''      
              BEGIN      
              --      
                BEGIN TRANSACTION        
                --    
                --SELECT @L_CLICM_ID = CLICM_ID FROM CLIENT_CTGRY_MSTR WHERE CLICM_CD = @PA_CLICM_CD    
                --    
                UPDATE client_ctgry_mstr   WITH (ROWLOCK)             
                SET    clicm_cd          = @pa_clicm_cd      
                     , clicm_desc        = @pa_clicm_desc      
                     , clicm_bit         = @L_BUSM_BIT       
                     , clicm_rmks        = @pa_clicm_rmks      
                     , clicm_lst_upd_by  = @pa_login_name      
                     , clicm_lst_upd_dt  = GETDATE()      
                WHERE  clicm_id          = @pa_id      
                AND    clicm_deleted_ind = 1      
                      
                SET @L_ERROR = @@ERROR      
                --      
                IF @L_ERROR  > 0      
                BEGIN      
                --      
                  ROLLBACK TRANSACTION          
                  --      
                  --SET @T_ERRORSTR = @T_ERRORSTR+@CURRSTRING+@COLDELIMITER+@PA_CLICM_CD+@COLDELIMITER+@PA_CLICM_DESC+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bit(@L_CLICM_ID,2,0),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bit(@L_CLICM_ID,1,0),'0')+@COLDELIMITER+ISNULL(@PA_CLICM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER      
                  SET @T_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER     
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
              ELSE      
              BEGIN      
              --      
                SET @T_ERRORSTR = 'One of the parameters PA_CLICM_CD is NULL'      
              --      
              END      
            --      
            END --@PA_ACTION='EDTMSTR'    
            --    
            ELSE IF @PA_ACTION = 'DELMSTR'      
            BEGIN      
              --      
              BEGIN TRANSACTION      
              --                     
              DELETE FROM enttm_clicm_mapping      
              WHERE  entcm_clicm_id    = @pa_id      
              AND    entcm_deleted_ind = 1      
              --      
              UPDATE client_ctgry_mstr   WITH (ROWLOCK)           
              SET    clicm_deleted_ind = 0      
                   , clicm_lst_upd_by  = @pa_login_name      
                   , clicm_lst_upd_dt  = GETDATE()      
              WHERE  clicm_id          = @pa_id      
              AND    clicm_deleted_ind = 1      
                    
              SET @L_ERROR = @@ERROR      
              --      
              IF @L_ERROR  > 0      
              BEGIN      
              --      
                ROLLBACK TRANSACTION         
              --      
                --SET @T_ERRORSTR = @T_ERRORSTR+@CURRSTRING+@COLDELIMITER+@PA_CLICM_CD+@COLDELIMITER+@PA_CLICM_DESC+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bit(@L_CLICM_ID,2,0),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bit(@L_CLICM_ID,1,0),'0')+@COLDELIMITER+ISNULL(@PA_CLICM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER      
                SET @T_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER     
              --      
              END      
              ELSE      
              BEGIN      
              --      
                COMMIT TRANSACTION         
              --      
              END      
            --      
            END  --@PA_ACTION='DELMSTR'    
                
            ELSE      
            BEGIN      
            --      
              SET @REMAININGSTRING_VAL = @PA_VALUES    
              --    
              WHILE @REMAININGSTRING_VAL <> ''        
              BEGIN--#3        
              --           
                SET @FOUNDAT_VAL  = 0        
                SET @FOUNDAT_VAL  =  PATINDEX('%'+@L_DELIMETER+'%', @REMAININGSTRING_VAL)        
                --        
                IF @FOUNDAT_VAL > 0        
                BEGIN        
   --        
                  SET @CURRSTRING_VAL      = SUBSTRING(@REMAININGSTRING_VAL, 0, @FOUNDAT_VAL)        
                  SET @REMAININGSTRING_VAL = SUBSTRING(@REMAININGSTRING_VAL, @FOUNDAT_VAL+@DELIMETERLENGTH, LEN(@REMAININGSTRING_VAL)- @FOUNDAT_VAL+@DELIMETERLENGTH)        
                --        
                END        
                ELSE        
                BEGIN        
                --        
                  SET @CURRSTRING_VAL      = @REMAININGSTRING_VAL        
                  SET @REMAININGSTRING_VAL = ''        
                --        
                END        
                --        
                IF @CURRSTRING_VAL <> ''        
                BEGIN--#4        
                --        
                  SET @l_enttm_id  = CITRUS_USR.FN_SPLITVAL(@CURRSTRING_VAL,1)        
                  SET @l_ind       = CITRUS_USR.FN_SPLITVAL(@CURRSTRING_VAL,2)        
                        
                  IF @PA_ACTION = 'INS'      
                  BEGIN      
                  --      
                    IF EXISTS (SELECT CLICM_ID FROM CLIENT_CTGRY_MSTR WHERE CLICM_CD=@PA_CLICM_CD)      
                    BEGIN      
                    --      
                      SET @L_EXISTS = 1     
                      --    
                      --SELECT @L_CLICM_ID = CLICM_ID FROM CLIENT_CTGRY_MSTR WHERE CLICM_CD = @PA_CLICM_CD      
                    --      
                    END      
                    ELSE       
                    BEGIN      
                    --      
                      SET @L_EXISTS = 0        
                      --            
                      SELECT @L_CLICM_ID = ISNULL(MAX(CLICM_ID),0)+1      
                      FROM  CLIENT_CTGRY_MSTR WITH (NOLOCK)      
                    --      
                    END      
                    --    
                    BEGIN TRANSACTION      
                    --    
                    IF  @L_EXISTS = 0      
                    BEGIN      
                    --      
                      INSERT INTO CLIENT_CTGRY_MSTR      
                      (CLICM_ID      
                      ,CLICM_CD      
                      ,CLICM_DESC    
                      ,clicm_bit     
                      ,CLICM_RMKS      
                      ,CLICM_CREATED_BY      
                      ,CLICM_CREATED_DT      
                      ,CLICM_LST_UPD_BY      
                      ,CLICM_LST_UPD_DT      
                      ,CLICM_DELETED_IND      
                      )      
                      VALUES      
                      (@L_CLICM_ID      
                      ,@PA_CLICM_CD      
                      ,@PA_CLICM_DESC    
                      ,@L_BUSM_BIT     
                      ,@PA_CLICM_RMKS      
                      ,@PA_LOGIN_NAME      
                      ,GETDATE()      
                      ,@PA_LOGIN_NAME      
                      ,GETDATE()      
                      ,1      
                      )      
                    --      
                    END      
                    --      
                    SET @L_ERROR = @@ERROR      
                    --     
                    IF @L_ERROR  > 0      
                    BEGIN      
                    --      
                      ROLLBACK TRANSACTION          
                      --      
                      --SET @T_ERRORSTR = @T_ERRORSTR+@CURRSTRING+@COLDELIMITER+isnull(@PA_CLICM_CD,'')+@COLDELIMITER+isnull(@PA_CLICM_DESC,'')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bit(@L_CLICM_ID-1,2,0),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bit(@L_CLICM_ID-1,1,0),'0')+@COLDELIMITER+ISNULL(@PA_CLICM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER      
                      SET @T_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER     
                    --      
                    END      
                    ELSE      
                    BEGIN      
                    --      
                      INSERT INTO ENTTM_CLICM_MAPPING      
                      (ENTCM_ENTTM_ID      
                      ,ENTCM_CLICM_ID      
                      ,ENTCM_CREATED_BY      
                      ,ENTCM_CREATED_DT      
              ,ENTCM_LST_UPD_BY      
                      ,ENTCM_LST_UPD_DT      
                      ,ENTCM_DELETED_IND      
                       )      
                      VALUES      
                      (@l_enttm_id      
                      ,@L_CLICM_ID      
                      ,@PA_LOGIN_NAME      
                      ,GETDATE()      
                      ,@PA_LOGIN_NAME      
                      ,GETDATE()      
                      ,1      
                      )      
                      --      
                      SET @L_ERROR = @@ERROR      
                      --      
                      IF @L_ERROR  > 0      
                      BEGIN      
                      --      
                        ROLLBACK TRANSACTION          
                        --      
                        --SET @T_ERRORSTR = @T_ERRORSTR+@CURRSTRING+@COLDELIMITER+isnull(@PA_CLICM_CD,'')+@COLDELIMITER+isnull(@PA_CLICM_DESC,'')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bit(@L_CLICM_ID-1,2,0),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bit(@L_CLICM_ID-1,1,0),'0')+@COLDELIMITER+ISNULL(@PA_CLICM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER      
                        SET @T_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER     
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
                  END --@PA_ACTION='INS'      
                  ELSE IF ISNULL(@PA_ACTION,'' )= ''      
                  BEGIN      
                  --      
                    BEGIN TRANSACTION      
                    --                          
                    IF @l_ind = 1      
                    BEGIN      
                    --      
                      INSERT INTO enttm_clicm_mapping      
                      ( entcm_enttm_id      
                      , entcm_clicm_id      
                      , entcm_created_by      
                      , entcm_created_dt      
                      , entcm_lst_upd_by      
                      , entcm_lst_upd_dt      
                      , entcm_deleted_ind      
                      )      
                      VALUES      
                      ( @l_enttm_id      
                      , @pa_id      
                      , @pa_login_name, GETDATE(), @pa_login_name, GETDATE(), 1      
                      )      
                    --      
                    END      
                    ELSE IF @l_ind = 0      
                    BEGIN      
                    --      
                      DELETE enttm_clicm_mapping            
                      WHERE  entcm_enttm_id    = @l_enttm_id      
                      AND    entcm_clicm_id    = @pa_id      
                      AND    entcm_deleted_ind = 1      
                    --      
                    END      
                    --      
                    SET @L_ERROR = @@ERROR      
                    --      
                    IF @L_ERROR  > 0      
                    BEGIN      
                    --      
                      ROLLBACK TRANSACTION         
                      --      
                      --SET @T_ERRORSTR = @T_ERRORSTR+@CURRSTRING+@COLDELIMITER+isnull(@PA_CLICM_CD,'')+@COLDELIMITER+isnull(@PA_CLICM_DESC,'')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bit(@L_CLICM_ID-1,2,0),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bit(@L_CLICM_ID-1,1,0),'0')+@COLDELIMITER+ISNULL(@PA_CLICM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER      
                      SET @T_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER     
                    --      
                    END      
                    ELSE      
                    BEGIN      
                    --      
                      COMMIT TRANSACTION         
                    --      
                    END      
                          
                  --      
                  END --ISNULL(@PA_ACTION,'')=''      
                        
                --        
                END --#4       
              --      
              END --#3       
        
            --      
            END      
          --      
          END --@PA_CHK_YN=0    
              
          ELSE IF @PA_CHK_YN = 1      
          BEGIN      
          --    
            SELECT @L_CLICM_ID = CLICM_ID FROM CLIENT_CTGRY_MSTR WHERE CLICM_CD = @PA_CLICM_CD AND clicm_deleted_ind = 1     
                
            IF @PA_ACTION='EDTMSTR'      
            BEGIN      
            --      
              BEGIN TRANSACTION       
      
              UPDATE CLIENT_CTGRY_MSTR_MAK  WITH (ROWLOCK)      
              SET    CLICM_DELETED_IND = 2      
                   , CLICM_LST_UPD_BY  = @PA_LOGIN_NAME      
                   , CLICM_LST_UPD_DT  = GETDATE()      
              WHERE  CLICM_ID          = @PA_ID      
              AND    CLICM_DELETED_IND = 0      
              --      
              SET @L_ERROR = @@ERROR      
              --      
              IF @L_ERROR > 0      
              BEGIN      
              --      
                SET @T_ERRORSTR = CONVERT(VARCHAR, @L_ERROR)+@COLDELIMITER+@ROWDELIMITER     
                --      
                ROLLBACK TRANSACTION         
              --      
              END      
              ELSE      
              BEGIN      
              --      
                UPDATE #TEMP_CLICMM               
                SET    clicm_cd          = @pa_clicm_cd    
                     , clicm_desc        = @pa_clicm_desc      
                     , clicm_bit         = @L_BUSM_BIT      
                     , clicm_rmks        = @pa_clicm_rmks      
                     , clicm_lst_upd_by  = @pa_login_name      
                     , clicm_lst_upd_dt  = GETDATE()      
                WHERE  clicm_id          = @pa_id      
                AND    clicm_deleted_ind = 0      
                      
                INSERT INTO CLIENT_CTGRY_MSTR_MAK      
                (CLICM_ID      
                ,CLICM_ENTTM_ID      
                ,CLICM_CD      
                ,CLICM_DESC    
                ,clicm_bit    
                ,CLICM_RMKS      
                ,CLICM_CREATED_BY      
                ,CLICM_CREATED_DT      
                ,CLICM_LST_UPD_BY      
                ,CLICM_LST_UPD_DT      
                ,CLICM_DELETED_IND      
                )      
                SELECT CLICM_ID      
                ,CLICM_ENTTM_ID      
                ,CLICM_CD      
                ,CLICM_DESC    
                ,clicm_bit    
                ,CLICM_RMKS      
                ,CLICM_CREATED_BY      
                ,CLICM_CREATED_DT      
                ,CLICM_LST_UPD_BY      
                ,CLICM_LST_UPD_DT      
             ,CLICM_DELETED_IND      
                FROM #TEMP_CLICMM       
                WHERE CLICM_ID=@PA_ID      
                      
                --      
                SET @L_ERROR = @@ERROR      
                --      
                IF @L_ERROR > 0      
                BEGIN      
                --      
                  SET @T_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER     
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
              END --ELSE      
            --      
            END --@PA_ACTION='EDTMSTR'      
            ELSE IF @PA_ACTION = 'DELMSTR'      
            BEGIN      
            --      
               UPDATE #TEMP_CLICM               
               SET    clicm_deleted_ind = 4      
               WHERE  clicm_id          = @pa_id      
               AND    clicm_deleted_ind = 1      
                      
               INSERT INTO client_ctgry_mstr_mak      
               ( clicm_id      
               , clicm_cd      
               , clicm_desc    
               , clicm_bit    
               , clicm_rmks      
               , clicm_enttm_id      
               , clicm_created_by      
               , clicm_created_dt     
               , clicm_lst_upd_by      
               , clicm_lst_upd_dt      
               , clicm_deleted_ind      
               )      
               SELECT  CLICM_ID      
                      ,CLICM_CD      
                      ,CLICM_DESC    
                      ,clicm_bit    
                      ,CLICM_RMKS      
                      ,CLICM_ENTTM_ID      
                      ,CLICM_CREATED_BY      
                      ,CLICM_CREATED_DT      
                      ,CLICM_LST_UPD_BY      
                      ,CLICM_LST_UPD_DT      
                      ,CLICM_DELETED_IND      
               FROM    #TEMP_CLICM       
               WHERE   CLICM_ID=@PA_ID      
            --      
            END      
            ELSE      
            BEGIN      
            --      
              IF @PA_ACTION='INS'      
              BEGIN      
              --      
                 SET @REMAININGSTRING_VAL = @PA_VALUES        
                 WHILE @REMAININGSTRING_VAL <> ''        
                 BEGIN--#3        
                 --           
                   SET @FOUNDAT_VAL  = 0        
                   SET @FOUNDAT_VAL  =  PATINDEX('%'+@L_DELIMETER+'%', @REMAININGSTRING_VAL)        
                   --        
                   IF @FOUNDAT_VAL > 0        
                   BEGIN        
                   --        
                     SET @CURRSTRING_VAL      = SUBSTRING(@REMAININGSTRING_VAL, 0, @FOUNDAT_VAL)        
                     SET @REMAININGSTRING_VAL = SUBSTRING(@REMAININGSTRING_VAL, @FOUNDAT_VAL+@DELIMETERLENGTH, LEN(@REMAININGSTRING_VAL)- @FOUNDAT_VAL+@DELIMETERLENGTH)        
                   --        
                   END        
                   ELSE        
                   BEGIN        
                   --        
                     SET @CURRSTRING_VAL      = @REMAININGSTRING_VAL        
                     SET @REMAININGSTRING_VAL = ''        
                   --        
                   END        
                   --        
                   IF @CURRSTRING_VAL <> ''        
                   BEGIN--#4        
                   --        
                     SET @l_enttm_id  = CITRUS_USR.FN_SPLITVAL(@CURRSTRING_VAL,1)        
                     SET @l_ind       = CITRUS_USR.FN_SPLITVAL(@CURRSTRING_VAL,2)        
                         
                     IF EXISTS (SELECT CLICM_ID FROM CLIENT_CTGRY_MSTR_MAK WHERE CLICM_CD=@PA_CLICM_CD)      
                     BEGIN      
                     --      
                       SET @L_EXISTS = 1      
                 --SELECT @L_CLICM_ID = CLICM_ID FROM CLIENT_CTGRY_MSTR_MAK WHERE CLICM_CD=@PA_CLICM_CD      
                     --      
                     END      
                     ELSE       
                     BEGIN      
                     --      
                       SET @L_EXISTS = 0        
                               
                       SELECT @L_CLICMM_ID = ISNULL(MAX(CLICM_ID),0)+1      
                       FROM  CLIENT_CTGRY_MSTR_MAK WITH (NOLOCK)      
                             
                       SELECT @L_CLICM_ID = ISNULL(MAX(CLICM_ID),0)+1      
                       FROM  CLIENT_CTGRY_MSTR WITH (NOLOCK)      
                             
                             
                       IF @L_CLICMM_ID > @L_CLICM_ID        
                       BEGIN        
                       --        
                         SET  @L_CLICM_ID = @L_CLICMM_ID        
                       --        
                       END        
                     --      
                     END      
                     --      
                     BEGIN TRANSACTION       
                       
                     INSERT INTO CLIENT_CTGRY_MSTR_MAK      
                     (CLICM_ID      
                     ,CLICM_ENTTM_ID      
                     ,CLICM_CD      
                     ,CLICM_DESC    
                     ,clicm_bit    
                     ,CLICM_RMKS      
                     ,CLICM_CREATED_BY      
                     ,CLICM_CREATED_DT      
                     ,CLICM_LST_UPD_BY      
                     ,CLICM_LST_UPD_DT      
                     ,CLICM_DELETED_IND      
)      
                     VALUES      
                     (@L_CLICM_ID      
                     ,@l_enttm_id      
                     ,@PA_CLICM_CD      
                     ,@PA_CLICM_DESC    
                     ,@L_BUSM_BIT      
                     ,@PA_CLICM_RMKS      
                     ,@PA_LOGIN_NAME      
                     ,GETDATE()      
                     ,@PA_LOGIN_NAME      
                     ,GETDATE()      
                     ,0      
                     )      
                     --      
                     SET @L_ERROR = @@ERROR      
                     --      
                     IF @L_ERROR  > 0      
                     BEGIN      
                     --      
                       ROLLBACK TRANSACTION            
                       --      
                       SET @T_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER     
                     --      
                     END      
                     ELSE      
                     BEGIN      
                     --      
                       COMMIT TRANSACTION            
                     --      
                     END      
                   --        
                   END --#4       
                 --      
                 END --#3       
              --      
              END --ELSE      
              ELSE IF @PA_ACTION = 'APP'      
              BEGIN --APP      
              --      
                SET @L_CLICM_ID       = RTRIM(LTRIM(CITRUS_USR.FN_SPLITVAL(@CURRSTRING, 1)))      
                SET @L_CLICM_ENTTM_ID = RTRIM(LTRIM(CITRUS_USR.FN_SPLITVAL(@CURRSTRING, 2)))      
                      
                SELECT @L_DELETED_IND = CLICM_DELETED_IND       
                FROM   CLIENT_CTGRY_MSTR_MAK      
                WHERE  CLICM_ID         = @L_CLICM_ID      
                AND    CLICM_ENTTM_ID   = @L_CLICM_ENTTM_ID       
                AND    CLICM_CREATED_BY <> @PA_LOGIN_NAME      
                --      
                IF @L_DELETED_IND=4      
                BEGIN      
                --      
                  UPDATE client_ctgry_mstr_mak            
                  SET    clicm_deleted_ind  = 5      
                       , clicm_lst_upd_by   = @pa_login_name      
                       , clicm_lst_upd_dt   = GETDATE()      
                  WHERE  clicm_id           = @l_clicm_id      
              AND    CLICM_ENTTM_ID     = @L_CLICM_ENTTM_ID      
                  AND    clicm_deleted_ind  = 4      
                  --      
                  UPDATE client_ctgry_mstr                
                  SET    clicm_deleted_ind  = 0      
                       , clicm_lst_upd_by   = @PA_LOGIN_NAME      
                       , clicm_lst_upd_dt   = GETDATE()      
                  WHERE  clicm_id           = @L_CLICM_ID      
                  AND    clicm_deleted_ind  = 1      
                  --      
                  DELETE enttm_clicm_mapping            
                  WHERE  entcm_clicm_id    = @L_CLICM_ID      
                  AND    ENTCM_ENTTM_ID    = @L_CLICM_ENTTM_ID      
                  AND    entcm_deleted_ind = 1      
                --      
                END      
                ELSE IF @L_DELETED_IND=6      
                BEGIN      
                --      
                  UPDATE client_ctgry_mstr_mak             
                  SET    clicm_deleted_ind  = 7      
                       , clicm_lst_upd_by   = @PA_LOGIN_NAME      
                       , clicm_lst_upd_dt   = GETDATE()      
                  WHERE  clicm_id           = @L_CLICM_ID      
                  AND    clicm_enttm_id     = @L_CLICM_ENTTM_ID      
                  AND    clicm_deleted_ind  = 6      
                  --      
                  DELETE enttm_clicm_mapping             
                  WHERE  entcm_clicm_id    = @L_CLICM_ID      
                  AND    entcm_enttm_id    = @L_CLICM_ENTTM_ID      
                  AND    entcm_deleted_ind = 1      
                --      
                END      
                --      
                ELSE IF EXISTS(SELECT CLICM_ID      
                          FROM   CLIENT_CTGRY_MSTR      
                          WHERE  CLICM_ID = @L_CLICM_ID      
                          AND    CLICM_DELETED_IND = 1      
                         )      
                BEGIN --EXISTS      
                --      
                   BEGIN TRANSACTION      
                   --      
                   UPDATE CLICM WITH (ROWLOCK)      
                   SET    CLICM.CLICM_CD           = CLICMM.CLICM_CD      
                        , CLICM.CLICM_DESC         = CLICMM.CLICM_DESC     
                        , clicm.clicm_bit          = clicmm.clicm_bit    
                        , CLICM.CLICM_RMKS         = CLICMM.CLICM_RMKS      
                        , CLICM.CLICM_LST_UPD_BY   = @PA_LOGIN_NAME      
                        , CLICM.CLICM_LST_UPD_DT   = GETDATE()      
                        , CLICM.CLICM_DELETED_IND  = 1      
                   FROM   CLIENT_CTGRY_MSTR        CLICM      
                        , CLIENT_CTGRY_MSTR_MAK    CLICMM      
                   WHERE  CLICM.CLICM_ID           = @L_CLICM_ID      
                   AND    CLICMM.CLICM_ENTTM_ID    = @L_CLICM_ENTTM_ID      
                   AND    CLICMM.CLICM_ID          = CLICM.CLICM_ID      
                   AND    CLICM.CLICM_DELETED_IND  = 1      
                   AND    CLICMM.CLICM_DELETED_IND = 0      
                   AND    CLICMM.CLICM_CREATED_BY  <> @PA_LOGIN_NAME      
                   --      
                   SET @L_ERROR = @@ERROR      
                   --      
                   IF @L_ERROR  > 0      
                   BEGIN      
                   --      
                     /*SELECT @T_ERRORSTR = @T_ERRORSTR+CONVERT(VARCHAR,@L_CLICM_ID)+@COLDELIMITER+A.CLICM_CD+@COLDELIMITER+A.CLICM_DESC+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bit(@L_CLICM_ID,2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_b 
 
it(@L_CLICM_ID,1,1),'0')+@COLDELIMITER+ISNULL(A.CLICM_RMKS,'')+@COLDELIMITER+B.ENTTM_DESC+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER      
                     FROM CLIENT_CTGRY_MSTR_MAK A  WITH (NOLOCK)      
                        , ENTITY_TYPE_MSTR      B  WITH (NOLOCK)      
                     WHERE A.CLICM_ENTTM_ID    = B.ENTTM_ID      
                     AND   A.CLICM_ID      = @L_CLICM_ID      
                     AND   A.CLICM_ENTTM_ID    = @L_CLICM_ENTTM_ID      
                     AND   A.CLICM_DELETED_IND = 0      
                     */    
                     SET @T_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER     
                     --      
                     ROLLBACK TRANSACTION      
                   --      
                   END      
                   ELSE      
                   BEGIN      
                    --      
                      UPDATE CLIENT_CTGRY_MSTR_MAK  WITH (ROWLOCK)      
                      SET    CLICM_DELETED_IND  = 1      
                           , CLICM_LST_UPD_BY   = @PA_LOGIN_NAME      
                           , CLICM_LST_UPD_DT   = GETDATE()      
                      WHERE  CLICM_ID           = @L_CLICM_ID      
                      AND    CLICM_ENTTM_ID     = @L_CLICM_ENTTM_ID      
                      AND    CLICM_CREATED_BY  <> @PA_LOGIN_NAME      
                      AND    CLICM_DELETED_IND  = 0      
                      --      
                      IF EXISTS(SELECT *       
                                FROM   enttm_clicm_mapping     entcm       
                                WHERE  entcm.entcm_clicm_id    = @l_clicm_id      
                                AND    entcm.entcm_enttm_id    = @l_clicm_enttm_id      
                                AND    entcm.entcm_deleted_ind = 1      
                                )      
                      BEGIN      
                      --      
                        SET @l_exists = 1      
                      --      
                      END      
                      ELSE      
                      BEGIN      
                      --      
                        SET @l_exists = 0      
                      --      
                      END      
                      --      
                      IF @l_exists=0      
                      BEGIN      
                      --      
                    INSERT INTO ENTTM_CLICM_MAPPING      
                        (ENTCM_ENTTM_ID      
                        ,ENTCM_CLICM_ID      
                        ,ENTCM_CREATED_BY      
                        ,ENTCM_CREATED_DT      
                        ,ENTCM_LST_UPD_BY      
                        ,ENTCM_LST_UPD_DT      
                        ,ENTCM_DELETED_IND      
                        )      
                        VALUES      
                        (@L_CLICM_ENTTM_ID      
                        ,@L_CLICM_ID      
                        ,@PA_LOGIN_NAME      
                        ,GETDATE()      
                        ,@PA_LOGIN_NAME      
                        ,GETDATE()      
                        ,1      
                        )      
                        --      
                        SET @L_ERROR = @@ERROR      
                        IF  @L_ERROR > 0      
                        BEGIN      
                        --      
                          ROLLBACK TRANSACTION      
                          --      
                          /*SELECT @T_ERRORSTR = @T_ERRORSTR+CONVERT(VARCHAR,@L_CLICM_ID)+@COLDELIMITER+A.CLICM_CD+@COLDELIMITER+A.CLICM_DESC+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bit(@L_CLICM_ID,2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_cl
i  
cm_bit(@L_CLICM_ID,1,1),'0')+@COLDELIMITER+ISNULL(A.CLICM_RMKS,'')+@COLDELIMITER+B.ENTTM_DESC+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER      
                          FROM  CLIENT_CTGRY_MSTR_MAK A WITH (NOLOCK)      
                             ,  ENTITY_TYPE_MSTR      B WITH (NOLOCK)      
                          WHERE A.CLICM_ENTTM_ID    = B.ENTTM_ID      
                          AND   A.CLICM_ID          = @L_CLICM_ID      
                          AND   A.CLICM_ENTTM_ID    = @L_CLICM_ENTTM_ID      
                          AND   A.CLICM_DELETED_IND = 0      
                          */    
                          SET @T_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER     
                      --      
                        END      
                        ELSE      
                        BEGIN      
                        --      
                           COMMIT TRANSACTION      
                        --      
                        END      
                      --      
                      END --@l_exists=0      
                    --      
                    END      
                  --      
                  END ----EXISTS      
                  ELSE      
                  BEGIN      
                  --      
                    BEGIN TRANSACTION       
                    --      
                      INSERT INTO CLIENT_CTGRY_MSTR      
                      ( CLICM_ID      
                      , CLICM_CD      
                      , CLICM_DESC      
                      , clicm_bit    
                      , CLICM_RMKS      
                      , CLICM_CREATED_BY      
                      , CLICM_CREATED_DT      
                      , CLICM_LST_UPD_BY      
                      , CLICM_LST_UPD_DT      
                      , CLICM_DELETED_IND      
                      )      
                      SELECT CLICMM.CLICM_ID      
                           , CLICMM.CLICM_CD      
                           , CLICMM.CLICM_DESC    
                           , clicmm.clicm_bit    
                           , CLICMM.CLICM_RMKS      
                           , CLICMM.CLICM_CREATED_BY      
                           , CLICMM.CLICM_CREATED_DT      
                           , @PA_LOGIN_NAME      
                           , GETDATE()      
                           , 1      
                      FROM   CLIENT_CTGRY_MSTR_MAK   CLICMM  WITH (NOLOCK)      
                      WHERE  CLICMM.CLICM_ID        = @L_CLICM_ID      
                      AND    CLICMM.CLICM_ENTTM_ID  = @L_CLICM_ENTTM_ID      
                      AND    CLICMM.CLICM_CREATED_BY  <> @PA_LOGIN_NAME      
                      AND    CLICMM.CLICM_DELETED_IND  = 0      
                      --      
                      SET @L_ERROR = CONVERT(INT, @@ERROR)      
                      --      
                IF @L_ERROR  > 0      
                      BEGIN      
                      --      
                        /*SELECT @T_ERRORSTR = @T_ERRORSTR+CONVERT(VARCHAR,@L_CLICM_ID)+@COLDELIMITER+A.CLICM_CD+@COLDELIMITER+A.CLICM_DESC+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bit(@L_CLICM_ID,2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm
  
_bit(@L_CLICM_ID,1,1),'0')+@COLDELIMITER+ISNULL(A.CLICM_RMKS,'')+@COLDELIMITER+B.ENTTM_DESC+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER      
                        FROM  CLIENT_CTGRY_MSTR_MAK A WITH (NOLOCK)      
                           ,  ENTITY_TYPE_MSTR      B WITH (NOLOCK)      
                        WHERE A.CLICM_ENTTM_ID    = B.ENTTM_ID      
                        AND   A.CLICM_ID          = @L_CLICM_ID      
                        AND   A.CLICM_ENTTM_ID    = @L_CLICM_ENTTM_ID      
                        AND   A.CLICM_DELETED_IND = 0      
                        */    
                        SET @T_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER     
                        --      
                        ROLLBACK TRANSACTION           
                      --      
                      END      
                      ELSE      
                      BEGIN      
                      --      
                        UPDATE CLIENT_CTGRY_MSTR_MAK  WITH (ROWLOCK)      
                        SET    CLICM_DELETED_IND  = 1      
                             , CLICM_LST_UPD_BY   = @PA_LOGIN_NAME      
                             , CLICM_LST_UPD_DT   = GETDATE()      
                        WHERE  CLICM_ID               = @L_CLICM_ID      
                        AND    CLICM_ENTTM_ID  = @L_CLICM_ENTTM_ID      
                        AND    CLICM_CREATED_BY  <> @PA_LOGIN_NAME      
                        AND    CLICM_DELETED_IND  = 0      
  --                             
                        INSERT INTO ENTTM_CLICM_MAPPING      
                        (ENTCM_ENTTM_ID      
                        ,ENTCM_CLICM_ID      
                        ,ENTCM_CREATED_BY      
                        ,ENTCM_CREATED_DT      
                        ,ENTCM_LST_UPD_BY      
                        ,ENTCM_LST_UPD_DT      
                        ,ENTCM_DELETED_IND      
                        )      
                        VALUES      
                        (@L_CLICM_ENTTM_ID      
                        ,@L_CLICM_ID      
                        ,@PA_LOGIN_NAME      
                        ,GETDATE()      
                        ,@PA_LOGIN_NAME      
                        ,GETDATE()      
                        ,1      
                        )      
                        --      
                        SET @L_ERROR = @@ERROR      
                        IF  @L_ERROR > 0      
                        BEGIN      
                        --      
                          /*    
                          SELECT @T_ERRORSTR = @T_ERRORSTR+CONVERT(VARCHAR,@L_CLICM_ID)+@COLDELIMITER+A.CLICM_CD+@COLDELIMITER+A.CLICM_DESC+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bit(@L_CLICM_ID,2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm
  
_bit(@L_CLICM_ID,1,1),'0')+@COLDELIMITER+ISNULL(A.CLICM_RMKS,'')+@COLDELIMITER+B.ENTTM_DESC+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER      
                          FROM  CLIENT_CTGRY_MSTR_MAK A WITH (NOLOCK)      
                             ,  ENTITY_TYPE_MSTR      B WITH (NOLOCK)      
                          WHERE A.CLICM_ENTTM_ID    = B.ENTTM_ID      
                          AND   A.CLICM_ID          = @L_CLICM_ID      
                          AND   A.CLICM_ENTTM_ID    = @L_CLICM_ENTTM_ID      
                          AND   A.CLICM_DELETED_IND = 0      
                          */    
                          SET @T_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER     
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
                  
              ELSE IF @PA_ACTION = 'REJ'      
              BEGIN      
              --      
                SET @L_CLICM_ID       = RTRIM(LTRIM(CITRUS_USR.FN_SPLITVAL(@CURRSTRING, 1)))      
                SET @L_CLICM_ENTTM_ID = RTRIM(LTRIM(CITRUS_USR.FN_SPLITVAL(@CURRSTRING, 2)))      
                --      
                BEGIN TRANSACTION      
                --    
                UPDATE CLIENT_CTGRY_MSTR_MAK  WITH (ROWLOCK)      
                SET    CLICM_DELETED_IND = 3      
                     , CLICM_LST_UPD_BY  = @PA_LOGIN_NAME      
                     , CLICM_LST_UPD_DT  = GETDATE()      
                WHERE CLICM_ID              = @L_CLICM_ID      
                AND   CLICM_ENTTM_ID        = @L_CLICM_ENTTM_ID      
                AND   CLICM_DELETED_IND     IN (0,4,6)      
                --      
                SET @L_ERROR = @@ERROR      
                --      
                IF @L_ERROR > 0      
                BEGIN      
                --      
                  /*    
                  SELECT @T_ERRORSTR = @T_ERRORSTR+CONVERT(VARCHAR,@L_CLICM_ID)+@COLDELIMITER+A.CLICM_CD+@COLDELIMITER+A.CLICM_DESC+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bit(@L_CLICM_ID,2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bit(@L_
  
CLICM_ID,1,1),'0')+@COLDELIMITER+ISNULL(A.CLICM_RMKS,'')+@COLDELIMITER+B.ENTTM_DESC+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER      
                  FROM  CLIENT_CTGRY_MSTR_MAK A WITH (NOLOCK)      
                     ,  ENTITY_TYPE_MSTR      B WITH (NOLOCK)      
                  WHERE A.CLICM_ENTTM_ID    = B.ENTTM_ID      
                  AND   A.CLICM_ID          = @L_CLICM_ID      
                  AND   A.CLICM_ENTTM_ID    = @L_CLICM_ENTTM_ID      
                  AND   A.CLICM_DELETED_IND = 0    
                  */    
                  SET @T_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER     
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
              ELSE if ISNULL(@PA_ACTION,'') =''      
              BEGIN      
              --      
                 SET @REMAININGSTRING_VAL = RTRIM(CONVERT(VARCHAR,@PA_VALUES))      
                 WHILE @REMAININGSTRING_VAL <> ''        
                 BEGIN--#3        
                 --           
                   SET @FOUNDAT_VAL  = 0        
                   SET @FOUNDAT_VAL  =  PATINDEX('%*|~*%', @REMAININGSTRING_VAL)        
                   --        
                   IF @FOUNDAT_VAL > 0        
                   BEGIN        
                   --        
                     SET @CURRSTRING_VAL      = SUBSTRING(@REMAININGSTRING_VAL, 0, @FOUNDAT_VAL)        
                     SET @REMAININGSTRING_VAL = SUBSTRING(@REMAININGSTRING_VAL, @FOUNDAT_VAL+@DELIMETERLENGTH, LEN(@REMAININGSTRING_VAL)- @FOUNDAT_VAL+@DELIMETERLENGTH)        
                   --        
                   END        
                   ELSE        
                   BEGIN        
                   --        
                     SET @CURRSTRING_VAL      = RTRIM(LTRIM(@REMAININGSTRING_VAL))        
                     SET @REMAININGSTRING_VAL = ''        
                   --        
                   END        
                   --        
                   IF ISNULL(@CURRSTRING_VAL,'') <> ''        
                   BEGIN--#4        
                   --        
                     SET @l_enttm_id  = CONVERT(NUMERIC, CITRUS_USR.FN_SPLITVAL(@CURRSTRING_VAL, 1))      
                     SET @l_ind       = CONVERT(NUMERIC, CITRUS_USR.FN_SPLITVAL(@CURRSTRING_VAL, 2))      
                     --      
                     IF @L_IND = 1      
                     BEGIN --@L_IND=1      
                     --    
                       BEGIN TRANSACTION    
                       --    
                       INSERT INTO client_ctgry_mstr_mak      
                       ( clicm_id      
                       , clicm_cd      
                       , clicm_desc    
                       , clicm_bit    
                       , clicm_rmks      
                       , clicm_enttm_id      
                       , clicm_created_by      
                       , clicm_created_dt      
                       , clicm_lst_upd_by      
                       , clicm_lst_upd_dt      
                       , clicm_deleted_ind      
                       )      
                       VALUES      
                       ( @pa_id      
                        ,@pa_clicm_cd                         
                        ,@pa_clicm_desc      
                        ,@L_BUSM_BIT      
                        ,@pa_clicm_rmks      
                        ,@l_enttm_id      
                        ,@pa_login_name      
                        ,GETDATE()      
                        ,@pa_login_name      
                        ,GETDATE()      
                        ,0      
                       )      
                     --      
                     END--@L_IND=1    
                     --    
                     ELSE IF @L_IND=0      
                     BEGIN      
                     --      
                       BEGIN TRANSACTION      
                       --      
                       SELECT @TEMP_ID = ISNULL(CLICM_ID,0)       
                       FROM   CLIENT_CTGRY_MSTR       
                       WHERE  CLICM_ID = CONVERT(NUMERIC, @PA_ID)      
      
                       IF @TEMP_ID <> 0      
                       BEGIN      
                       --      
                         INSERT INTO client_ctgry_mstr_mak      
                         ( clicm_id      
                         , clicm_cd      
                         , clicm_desc    
                         , clicm_bit    
                         , clicm_rmks      
                         , clicm_enttm_id      
                         , clicm_created_by      
                         , clicm_created_dt      
                         , clicm_lst_upd_by      
                         , clicm_lst_upd_dt      
                         , clicm_deleted_ind      
                         )      
                         VALUES      
                         ( @pa_id      
                         , @pa_clicm_cd      
                         , @pa_clicm_desc    
                         , @L_BUSM_BIT      
                         , @pa_clicm_rmks      
                         , @l_enttm_id      
                         , @pa_login_name, GETDATE(), @pa_login_name, GETDATE(), 6      
                         )      
                       --      
                       END      
                       ELSE      
                       BEGIN      
                       --      
                         UPDATE CLIENT_CTGRY_MSTR_MAK      
                         SET    clicm_deleted_ind = 3      
                              , clicm_lst_upd_by  = @pa_login_name      
                              , clicm_lst_upd_dt  = GETDATE()      
                         WHERE CLICM_ID = CONVERT(NUMERIC, @PA_ID)      
                         AND   CLICM_ENTTM_ID = @l_enttm_id      
                         AND   CLICM_DELETED_IND IN (0,4,6)      
                       --      
                       END      
                     --         
                     END      
                         
                     SET @L_ERROR = @@ERROR      
                     --      
                     IF @L_ERROR > 0      
                     BEGIN      
                     --      
                       /*    
                       SELECT @T_ERRORSTR = @T_ERRORSTR+CONVERT(VARCHAR,@L_CLICM_ID)+@COLDELIMITER+A.CLICM_CD+@COLDELIMITER+A.CLICM_DESC+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bit(@L_CLICM_ID,2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_clicm_bi
  
t(@L_CLICM_ID,1,1),'0')+@COLDELIMITER+ISNULL(A.CLICM_RMKS,'')+@COLDELIMITER+B.ENTTM_DESC+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER      
                       FROM  CLIENT_CTGRY_MSTR_MAK A WITH (NOLOCK)      
                          ,  ENTITY_TYPE_MSTR      B WITH (NOLOCK)      
                       WHERE A.CLICM_ENTTM_ID    = B.ENTTM_ID      
                       AND   A.CLICM_ID          = @L_CLICM_ID      
                       AND   A.CLICM_ENTTM_ID    = @L_CLICM_ENTTM_ID      
                       AND   A.CLICM_DELETED_IND = 0      
                       */    
                       SET @T_ERRORSTR = @COLDELIMITER+CONVERT(VARCHAR, @L_ERROR)+@ROWDELIMITER     
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
                   END --#4       
                 --      
                 END --#3       
              --      
              END      
            --      
            END      
          --      
          END --@PA_CHK_YN=1      
                
        --      
        END --(ISNULL(@pa_id,'') <> '') AND (ISNULL(@pa_login_name,'')<>'')      
              
      IF @L_ERROR<>0      
      BEGIN      
      --      
         SET @PA_ERRMSG = @T_ERRORSTR      
      --      
      END      
      ELSE      
      BEGIN      
      --      
         SET @PA_ERRMSG = 'Client Category Successfully Inserted/Updated'      
      --      
      END      
      --      
     END      
   --      
   END      
 --        
 END

GO
