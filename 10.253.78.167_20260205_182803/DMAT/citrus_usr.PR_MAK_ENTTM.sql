-- Object: PROCEDURE citrus_usr.PR_MAK_ENTTM
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE  PROCEDURE [citrus_usr].[PR_MAK_ENTTM](@PA_ID                VARCHAR(8000)  
                              ,@PA_ACTION            VARCHAR(20)  
                              ,@PA_LOGIN_NAME        VARCHAR(20)  
                              ,@PA_ENTTM_CD          VARCHAR(20)  
                              ,@PA_ENTTM_PREFIX      VARCHAR(20)  
                              ,@PA_ENTTM_DESC        VARCHAR(20)  
                              ,@PA_ENTTM_CLI_YN      INT
                              ,@PA_ENTTM_ENT_YN      INT
                              ,@PA_ENTTM_OTH_YN      INT
                              ,@PA_ENTTM_PARENT_CD   VARCHAR(20)  
                              ,@PA_ENTTM_RMKS        VARCHAR(200) 
                              ,@PA_ENTTM_BUSM_YN     CHAR(25) 
                              ,@PA_CHK_YN            INT  
                              ,@ROWDELIMITER         CHAR(4) = '*|~*'  
                              ,@COLDELIMITER         CHAR(4) = '|*~|'  
                              ,@PA_ERRMSG            VARCHAR(8000) OUTPUT  
 )  
AS  
/*  
**********************************************************************************************  
 SYSTEM         : CLASS  
 MODULE NAME    : PKG_MAK_ENTTM  
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE MAKER CHECKER FACILITY FOR ENTITY_TYPE_MSTR  
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.  
 VERSION HISTORY: 2.0  
 VERS.  AUTHOR             DATE         REASON  
 -----  -------------      ----------   --------------------------------------------------------  
 1.0    HARI R             24-AUG-2006  INITIAL VERSION.  
 2.0    HARI.R             20-SEP-2006  TWO EXTRA FIELDS WERE ADDED(ENTTM_CLI_YN,ENTTM_PARENT_CD)  
 3.0    SUKHVINDER/TUSHAR  18-DEC-2006  REMARKS FIELDS WERE ADDED  
--------------------------------------------------------------------------------------------------*/  
--  
SET NOCOUNT ON  
--  
DECLARE @T_ERRORSTR       VARCHAR(8000)  
      , @L_SMENTTM_ID     BIGINT  
      , @L_ENTTM_ID       BIGINT  
      , @L_ERROR          BIGINT  
      , @DELIMETER        VARCHAR(10)  
      , @REMAININGSTRING  VARCHAR(8000)  
      , @CURRSTRING       VARCHAR(8000)  
      , @FOUNDAT          INTEGER  
      , @DELIMETERLENGTH  INT  
      , @L_ENTTM_CLI_YN   INT  
      , @L_ENTTM_ENT_YN   INT
      , @L_ENTTM_OTH_YN   INT
      , @L_ENTR_COL_NAME  VARCHAR(25)  
      , @L_OLD_ENTTM_CD   VARCHAR(25)
      , @L_BUSM_CD        VARCHAR(200)
      , @L_BUSM_BIT       integer
      , @l_access_cd      VARCHAR(50)
 --
 SET @l_busm_bit      = 0
 SET @L_ERROR         = 0  
 SET @T_ERRORSTR      = ''  
 SET @L_ENTTM_CLI_YN  = 0  
 SET @L_ENTTM_ENT_YN  = 0 
 SET @L_ENTTM_OTH_YN  = 0 
 SET @DELIMETER        = '%'+ @ROWDELIMITER + '%'  
 SET @DELIMETERLENGTH = LEN(@ROWDELIMITER)  
 SET @REMAININGSTRING = @PA_ID  
 --  
 WHILE @REMAININGSTRING <> ''  
 BEGIN  
    --  
    SET @FOUNDAT = 0  
    SET @FOUNDAT =  PATINDEX('%'+@DELIMETER+'%',@REMAININGSTRING)  
  
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
       IF @PA_ACTION = 'INS'  
       BEGIN  
       --  
         SELECT TOP 1 @L_ENTR_COL_NAME  = ENTEM.ENTEM_ENTR_COL_NAME  
         FROM   ENTTM_ENTR_MAPPING ENTEM WITH(NOLOCK)  
         WHERE  ENTEM_ENTTM_CD IS NULL  
         AND    ENTEM.ENTEM_DELETED_IND  = 1  
       --  
       END  
       ELSE IF @PA_ACTION = 'EDT'  
       BEGIN  
       --  
         SELECT @L_OLD_ENTTM_CD        = ENTTM.ENTTM_CD  
         FROM   ENTITY_TYPE_MSTR  ENTTM WITH(NOLOCK)  
         WHERE  ENTTM.ENTTM_ID          = @PA_ID  
         AND    ENTTM.ENTTM_DELETED_IND = 1  
       --  
       END  
       --  
       IF @PA_ENTTM_ENT_YN = 1  
       BEGIN  
       --  
         SET @L_ENTTM_CLI_YN = POWER(2,0) | ISNULL(@L_ENTTM_CLI_YN,0) 
       --  
       END
       IF @PA_ENTTM_CLI_YN = 1  
							BEGIN  
							--  
									SET @L_ENTTM_CLI_YN = POWER(2,1) | ISNULL(@L_ENTTM_CLI_YN,0) 
							--  
       END
       IF @PA_ENTTM_OTH_YN = 1  
							BEGIN  
							--  
									SET @L_ENTTM_CLI_YN = POWER(2,2) | ISNULL(@L_ENTTM_CLI_YN,0) 
							--  
       END
        
       --**ENTTM_BIT**--
       DECLARE @l_counter  INT
             , @l          INT
             , @l_busm_id  INT 
       --      
       SET @l_counter = CITRUS_USR.UFN_COUNTSTRING(@PA_ENTTM_BUSM_YN,'|*~|')
       SET @l         = 1
       --
       WHILE @l <= @l_counter 
       BEGIN--#1
       --
         SET @l_busm_id       = CONVERT(INT,CITRUS_USR.FN_SPLITVAL(@PA_ENTTM_BUSM_YN,@l))
         --
         SELECT @L_BUSM_CD    = BUSM_CD  
         FROM   BUSINESS_MSTR   WITH (NOLOCK)
         WHERE  BUSM_ID       = CONVERT(INT, @l_busm_id)
         --
         SELECT @l_access_cd   = CASE WHEN @l_busm_cd ='ALL'  THEN 'BUS_%' 
                                      ELSE 'BUS_' + @l_busm_cd 
                                      END
         --                             
         SET @l_busm_bit = citrus_usr.fn_get_busm_access(@l_access_cd) | @l_busm_bit
         --
         SET @l = @l + 1                            
       --
       END--#1
       --SELECT @L_BUSM_CD   = BUSM_CD  
       --FROM   BUSINESS_MSTR   WITH (NOLOCK)
       --WHERE  BUSM_ID       = CONVERT(NUMERIC, @PA_ENTTM_BUSM_YN)
       --
       --SELECT @L_BUSM_BIT = CASE WHEN @L_BUSM_CD = 'ALL' THEN CITRUS_USR.FN_GET_BUSM_ACCESS('BUS_%')
       --                           ELSE CITRUS_USR.FN_GET_BUSM_ACCESS('BUS_'+ @L_BUSM_CD +'%')
       --                           END
       --**ENTTM_BIT**--
       --
       IF @PA_ACTION = 'INS'  
       BEGIN  
       --  
         IF @PA_CHK_YN = 0 -- IF MAKER CHECKER FUNCTIONALITY IS NOT REQD  
         BEGIN  
         --
           BEGIN TRANSACTION  
           --
           SELECT @L_ENTTM_ID     = BITRM_BIT_LOCATION+1  
           FROM   BITMAP_REF_MSTR    WITH(NOLOCK)  
           WHERE  BITRM_PARENT_CD = 'ENTITY_ID'  
           AND    BITRM_CHILD_CD  = 'ENTITY_ID'  
           --  
           UPDATE BITMAP_REF_MSTR    WITH(ROWLOCK)  
           SET    BITRM_BIT_LOCATION =  BITRM_BIT_LOCATION+1  
           WHERE  BITRM_PARENT_CD    = 'ENTITY_ID'  
           AND    BITRM_CHILD_CD     = 'ENTITY_ID'  
           --  
           INSERT INTO ENTITY_TYPE_MSTR  
           (ENTTM_ID  
           ,ENTTM_CD  
           ,ENTTM_PREFIX  
           ,ENTTM_DESC  
           ,ENTTM_CLI_YN  
           ,ENTTM_PARENT_CD  
           ,ENTTM_RMKS  
           ,ENTTM_CREATED_BY  
           ,ENTTM_CREATED_DT  
           ,ENTTM_LST_UPD_BY  
           ,ENTTM_LST_UPD_DT  
           ,ENTTM_DELETED_IND
           ,ENTTM_BIT
           )  
           VALUES  
           (@L_ENTTM_ID  
           ,@PA_ENTTM_CD  
           ,@PA_ENTTM_PREFIX  
           ,@PA_ENTTM_DESC  
           ,@L_ENTTM_CLI_YN  
           ,@PA_ENTTM_PARENT_CD  
           ,@PA_ENTTM_RMKS  
           ,@PA_LOGIN_NAME  
           ,GETDATE()  
           ,@PA_LOGIN_NAME  
           ,GETDATE()
           ,1
           ,@L_BUSM_BIT
           )  
           --  
           SET @L_ERROR = @@ERROR  
           --  
           IF @L_ERROR > 0  
           BEGIN  
           --  
             ROLLBACK TRANSACTION  
             --  
             --SET @T_ERRORSTR = ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(@PA_ENTTM_CD,'')+@COLDELIMITER+ISNULL(@PA_ENTTM_PREFIX,'')+@COLDELIMITER+ISNULL(@PA_ENTTM_DESC,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_CLI_YN)+@COLDELIMITER+ISNULL(@PA_ENTTM_PARENT_CD,'')+@COLDELIMITER+ISNULL(@PA_ENTTM_BUSM_YN,'')+@COLDELIMITER+ISNULL(@PA_ENTTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
             SET @T_ERRORSTR = ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(@PA_ENTTM_CD,'')+@COLDELIMITER+ISNULL(@PA_ENTTM_PREFIX,'')+@COLDELIMITER+ISNULL(@PA_ENTTM_DESC,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_CLI_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_ENT_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_OTH_YN)+@COLDELIMITER+ISNULL(@PA_ENTTM_PARENT_CD,'')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(@L_ENTTM_ID-1,2,0),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(@L_ENTTM_ID-1,1,0),'0')+@COLDELIMITER+ISNULL(@PA_ENTTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
           --  
           END  
           ELSE  
           BEGIN  
           -- 
            IF @L_ENTTM_CLI_YN&1  = 1
            BEGIN
            -- 
             UPDATE ENTTM_ENTR_MAPPING WITH(ROWLOCK)  
             SET    ENTEM_ENTTM_CD   = @PA_ENTTM_CD  
                   ,ENTEM_LST_UPD_BY = @PA_LOGIN_NAME  
                   ,ENTEM_LST_UPD_DT = GETDATE()  
             WHERE  ENTEM_ENTR_COL_NAME = @L_ENTR_COL_NAME  
             AND    ENTEM_DELETED_IND = 1   
            --
            END
             --  
             COMMIT TRANSACTION  
           --  
           END  
        --  
        END  
  
        IF @PA_CHK_YN = 1 -- IF MAKER IS INSERTING  
        BEGIN  
          --  
          BEGIN TRANSACTION  
          --  
          SELECT @L_ENTTM_ID    = BITRM_BIT_LOCATION+1  
          FROM BITMAP_REF_MSTR WITH(NOLOCK)  
          WHERE BITRM_PARENT_CD = 'ENTITY_ID'  
          AND BITRM_CHILD_CD    = 'ENTITY_ID'  
          --  
          UPDATE BITMAP_REF_MSTR WITH(ROWLOCK)  
          SET BITRM_BIT_LOCATION = BITRM_BIT_LOCATION+1  
          WHERE BITRM_PARENT_CD  = 'ENTITY_ID'  
          AND BITRM_CHILD_CD     = 'ENTITY_ID'  
          --  
          INSERT INTO ENTITY_TYPE_MSTR_MAK  
          (ENTTM_ID  
          ,ENTTM_CD  
          ,ENTTM_PREFIX  
          ,ENTTM_DESC  
          ,ENTTM_CLI_YN  
          ,ENTTM_PARENT_CD  
          ,ENTTM_RMKS  
          ,ENTTM_CREATED_BY  
          ,ENTTM_CREATED_DT  
          ,ENTTM_LST_UPD_BY  
          ,ENTTM_LST_UPD_DT  
          ,ENTTM_DELETED_IND
          ,ENTTM_BIT 
          )  
          VALUES  
          (@L_ENTTM_ID  
          ,@PA_ENTTM_CD  
          ,@PA_ENTTM_PREFIX  
          ,@PA_ENTTM_DESC  
          ,@L_ENTTM_CLI_YN  
          ,@PA_ENTTM_PARENT_CD  
          ,@PA_ENTTM_RMKS  
          ,@PA_LOGIN_NAME  
          ,GETDATE()  
          ,@PA_LOGIN_NAME  
          ,GETDATE()  
          ,0
          ,@L_BUSM_BIT
          )  
          --  
          SET @L_ERROR = @@ERROR  
          --  
          IF @L_ERROR > 0  
          BEGIN  
          --  
            SET @T_ERRORSTR=ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(@PA_ENTTM_CD,'')+@COLDELIMITER+ISNULL(@PA_ENTTM_PREFIX,'')+@COLDELIMITER+ISNULL(@PA_ENTTM_DESC,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_CLI_YN)+CONVERT(VARCHAR,@L_ENTTM_ENT_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_OTH_YN)+@COLDELIMITER+ISNULL(@PA_ENTTM_PARENT_CD,'')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(@L_ENTTM_ID-1,2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(@L_ENTTM_ID-1,1,1),'0')+@COLDELIMITER+ISNULL(@PA_ENTTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
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
      END  --ACTION TYPE = INS ENDS HERE  
  
      IF @PA_ACTION = 'APP'  
      BEGIN  
      --  
        IF EXISTS(SELECT ENTTM_ID  
                  FROM   ENTITY_TYPE_MSTR  WITH (NOLOCK)  
                  WHERE  ENTTM_ID = CONVERT(INT, @CURRSTRING)  
                 )  
        BEGIN  
        --  
          BEGIN TRANSACTION  
          --  
          UPDATE ENTTM                      WITH (ROWLOCK)  
          SET    ENTTM.ENTTM_CD           = ENTTMM.ENTTM_CD  
                ,ENTTM.ENTTM_PREFIX       = ENTTMM.ENTTM_PREFIX  
                ,ENTTM.ENTTM_DESC         = ENTTMM.ENTTM_DESC  
                ,ENTTM.ENTTM_CLI_YN       = ENTTMM.ENTTM_CLI_YN  
                ,ENTTM.ENTTM_PARENT_CD    = ENTTMM.ENTTM_PARENT_CD  
                ,ENTTM.ENTTM_RMKS         = ENTTMM.ENTTM_RMKS
                ,ENTTM.ENTTM_BIT          = ENTTMM.ENTTM_BIT
                ,ENTTM.ENTTM_LST_UPD_BY   = @PA_LOGIN_NAME  
                ,ENTTM.ENTTM_LST_UPD_DT   = GETDATE()  
                ,ENTTM.ENTTM_DELETED_IND  = 1  
          FROM   ENTITY_TYPE_MSTR           ENTTM  
                ,ENTITY_TYPE_MSTR_MAK       ENTTMM  
          WHERE  ENTTM.ENTTM_ID           = CONVERT(INT,@CURRSTRING)  
          AND    ENTTM.ENTTM_DELETED_IND  = 1  
          AND    ENTTMM.ENTTM_DELETED_IND = 0  
          AND    ENTTMM.ENTTM_CREATED_BY <> @PA_LOGIN_NAME  
          --  
          SET @L_ERROR = @@ERROR  
          --  
          IF  @L_ERROR > 0  
          BEGIN  
          --  
            SELECT  @T_ERRORSTR      = ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(ENTTM_CD,'')+@COLDELIMITER+ISNULL(ENTTM_PREFIX,'')+@COLDELIMITER+ISNULL(ENTTM_DESC,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_CLI_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_ENT_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_OTH_YN)+@COLDELIMITER+ISNULL(ENTTM_PARENT_CD,'')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),1,1),'0')+@COLDELIMITER+ISNULL(ENTTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER
            FROM    ENTITY_TYPE_MSTR_MAK  WITH (NOLOCK)  
            WHERE   ENTTM_ID          = CONVERT(INT,@CURRSTRING)  
            AND     ENTTM_DELETED_IND = 0  
            --  
            ROLLBACK TRANSACTION  
          --  
          END  
          ELSE  
          BEGIN  
          --  
            UPDATE  ENTITY_TYPE_MSTR_MAK  WITH (ROWLOCK)  
            SET     ENTTM_DELETED_IND  = 1  
                   ,ENTTM_LST_UPD_BY   = @PA_LOGIN_NAME  
                   ,ENTTM_LST_UPD_DT   = GETDATE()  
            WHERE   ENTTM_ID           = CONVERT(INT,@CURRSTRING)  
            AND     ENTTM_CREATED_BY  <> @PA_LOGIN_NAME  
            AND     ENTTM_DELETED_IND  = 0  
            --  
            SET @L_ERROR = @@ERROR  
            --  
            IF @L_ERROR > 0  
            BEGIN  
            -- 
              SELECT @T_ERRORSTR      = ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(ENTTM_CD,'')+@COLDELIMITER+ISNULL(ENTTM_PREFIX,'')+@COLDELIMITER+ISNULL(ENTTM_DESC,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_CLI_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_ENT_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_OTH_YN)+@COLDELIMITER+ISNULL(ENTTM_PARENT_CD,'')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),1,1),'0')+@COLDELIMITER+ISNULL(ENTTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
              FROM   ENTITY_TYPE_MSTR_MAK  WITH (NOLOCK)  
              WHERE  ENTTM_ID          = CONVERT(INT,@CURRSTRING)  
              AND    ENTTM_DELETED_IND = 0  
              --  
              ROLLBACK TRANSACTION  
            --  
            END  
            ELSE  
            BEGIN  
            --  
              SELECT @L_OLD_ENTTM_CD        = ENTTM.ENTTM_CD  
              FROM   ENTITY_TYPE_MSTR ENTTM    WITH(NOLOCK)  
              WHERE  ENTTM.ENTTM_ID          = CONVERT(INT,@CURRSTRING)  
              AND    ENTTM.ENTTM_DELETED_IND = 1  
              --  
              IF @L_OLD_ENTTM_CD <> UPPER(@PA_ENTTM_CD)  
              BEGIN  
              --  
                UPDATE ENTTM_ENTR_MAPPING  WITH(ROWLOCK)  
                SET    ENTEM_ENTTM_CD    = UPPER(@PA_ENTTM_CD)  
                WHERE  ENTEM_ENTTM_CD    = @L_OLD_ENTTM_CD  
                AND    ENTEM_DELETED_IND = 1  
              --  
              END  
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
          INSERT INTO ENTITY_TYPE_MSTR  
          (ENTTM_ID  
          ,ENTTM_CD  
          ,ENTTM_PREFIX  
          ,ENTTM_DESC  
          ,ENTTM_CLI_YN  
          ,ENTTM_PARENT_CD  
          ,ENTTM_RMKS  
          ,ENTTM_CREATED_BY  
          ,ENTTM_CREATED_DT  
          ,ENTTM_LST_UPD_BY  
          ,ENTTM_LST_UPD_DT  
          ,ENTTM_DELETED_IND 
          ,ENTTM_BIT
          )  
          SELECT ENTTMM.ENTTM_ID  
                ,ENTTMM.ENTTM_CD  
                ,ENTTMM.ENTTM_PREFIX  
                ,ENTTMM.ENTTM_DESC  
                ,ENTTMM.ENTTM_CLI_YN  
                ,ENTTMM.ENTTM_PARENT_CD  
                ,ENTTMM.ENTTM_RMKS  
                ,ENTTMM.ENTTM_CREATED_BY  
                ,ENTTMM.ENTTM_CREATED_DT  
                ,@PA_LOGIN_NAME  
                ,GETDATE()  
                ,1
                ,ENTTMM.ENTTM_BIT
          FROM  ENTITY_TYPE_MSTR_MAK ENTTMM  WITH (NOLOCK)  
          WHERE ENTTMM.ENTTM_ID          = CONVERT(INT,@CURRSTRING)  
          AND   ENTTMM.ENTTM_CREATED_BY <> @PA_LOGIN_NAME  
          AND   ENTTMM.ENTTM_DELETED_IND = 0  
          --  
          SET @L_ERROR = CONVERT(INT,@@ERROR)  
          --  
          IF @L_ERROR > 0  
          BEGIN  
            --  
            SELECT  @T_ERRORSTR      = ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(ENTTM_CD,'')+@COLDELIMITER+ISNULL(ENTTM_PREFIX,'')+@COLDELIMITER+ISNULL(ENTTM_DESC,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_CLI_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_ENT_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_OTH_YN)+@COLDELIMITER+ISNULL(ENTTM_PARENT_CD,'')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),1,1),'0')+@COLDELIMITER+ISNULL(ENTTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
            FROM    ENTITY_TYPE_MSTR_MAK  WITH (NOLOCK)  
            WHERE   ENTTM_ID          = CONVERT(INT,@CURRSTRING)  
            AND     ENTTM_DELETED_IND = 0  
            --  
            ROLLBACK TRANSACTION  
            --  
          END  
          ELSE  
          BEGIN  
            --  
            UPDATE ENTITY_TYPE_MSTR_MAK  WITH (ROWLOCK)  
            SET    ENTTM_DELETED_IND  = 1  
                  ,ENTTM_LST_UPD_BY   = @PA_LOGIN_NAME  
                  ,ENTTM_LST_UPD_DT   = GETDATE()  
            WHERE  ENTTM_ID           = CONVERT(INT,@CURRSTRING)  
            AND    ENTTM_CREATED_BY  <> @PA_LOGIN_NAME  
            AND    ENTTM_DELETED_IND  = 0  
            --  
            SET @L_ERROR = @@ERROR  
            --  
            IF @L_ERROR > 0  
            BEGIN  
            --  
              SELECT @T_ERRORSTR     = ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(ENTTM_CD,'')+@COLDELIMITER+ISNULL(ENTTM_PREFIX,'')+@COLDELIMITER+ISNULL(ENTTM_DESC,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_CLI_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_ENT_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_OTH_YN)+@COLDELIMITER+ISNULL(ENTTM_PARENT_CD,'')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),1,1),'0')+@COLDELIMITER+ISNULL(ENTTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
              FROM  ENTITY_TYPE_MSTR_MAK WITH (NOLOCK)  
              WHERE ENTTM_ID          = CONVERT(INT,@CURRSTRING)  
              AND   ENTTM_DELETED_IND = 0  
              --  
              ROLLBACK TRANSACTION  
            --  
            END  
            ELSE  
            BEGIN  
            --  
              SELECT TOP 1 @L_ENTR_COL_NAME = ENTEM.ENTEM_ENTR_COL_NAME  
              FROM   ENTTM_ENTR_MAPPING   ENTEM WITH(NOLOCK)  
              WHERE  ENTEM_ENTTM_CD    IS NULL  
              AND    ENTEM_DELETED_IND  = 1  
              --  
              SELECT  @PA_ENTTM_CD    =  ENTTM_CD  
              FROM  ENTITY_TYPE_MSTR_MAK WITH (NOLOCK)  
              WHERE ENTTM_ID          = CONVERT(INT,@CURRSTRING)  
              AND   ENTTM_DELETED_IND = 1  
              --  
              UPDATE ENTTM_ENTR_MAPPING     WITH(ROWLOCK)  
              SET    ENTEM_ENTTM_CD       = @PA_ENTTM_CD  
                    ,ENTEM_LST_UPD_BY     = @PA_LOGIN_NAME  
                    ,ENTEM_LST_UPD_DT     = GETDATE()  
              WHERE  ENTEM_ENTR_COL_NAME  = @L_ENTR_COL_NAME  
              AND    ENTEM_DELETED_IND    = 1  
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
        IF @PA_CHK_YN = 1 -- IF CHEKER IS REJECTING  
        BEGIN  
          --  
          BEGIN TRANSACTION  
          --  
          UPDATE ENTITY_TYPE_MSTR_MAK WITH(ROWLOCK)  
          SET    ENTTM_DELETED_IND = 3  
                ,ENTTM_LST_UPD_BY = @PA_LOGIN_NAME  
                ,ENTTM_LST_UPD_DT = GETDATE()  
          WHERE  ENTTM_ID = CONVERT(INT,@CURRSTRING)  
          AND    ENTTM_DELETED_IND = 0  
          --  
          SET @L_ERROR = @@ERROR  
          --  
          IF @L_ERROR > 0  
          BEGIN  
          --  
            SELECT @T_ERRORSTR = ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(ENTTM_CD,'')+@COLDELIMITER+ISNULL(ENTTM_PREFIX,'')+@COLDELIMITER+ISNULL(ENTTM_DESC,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_CLI_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_ENT_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_OTH_YN)+@COLDELIMITER+ISNULL(ENTTM_PARENT_CD,'')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),1,1),'0')+@COLDELIMITER+ISNULL(ENTTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
            FROM   ENTITY_TYPE_MSTR_MAK WITH (NOLOCK)  
            WHERE  ENTTM_ID = CONVERT(INT,@CURRSTRING)  
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
      END          --ACTION TYPE = REJ ENDS HERE  
  
      IF @PA_ACTION = 'DEL'  --ACTION TYPE = DEL BEGINS HERE  
      BEGIN  
        --  
        BEGIN TRANSACTION  
        --  
        DELETE FROM ENTTM_ENTR_MAPPING
        WHERE  ENTEM_ENTTM_CD = (SELECT ENTTM_CD FROM ENTITY_TYPE_MSTR  WHERE  ENTTM_ID   = CONVERT(INT, @CURRSTRING))
        AND ENTEM_DELETED_IND    = 1
        --
        UPDATE ENTITY_TYPE_MSTR WITH (ROWLOCK)  
        SET    ENTTM_DELETED_IND = 0  
              ,ENTTM_LST_UPD_BY  = @PA_LOGIN_NAME  
              ,ENTTM_LST_UPD_DT  = GETDATE()  
        WHERE  ENTTM_ID          = CONVERT(INT, @CURRSTRING)  
        --  
        SET @L_ERROR = @@ERROR  
        --  
        IF @L_ERROR > 0     --IF ANY ERROR REPORTS THEN GENERATE THE ERROR STRING  
        BEGIN  
        --  
          SELECT @T_ERRORSTR     = ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(ENTTM_CD,'')+@COLDELIMITER+ISNULL(ENTTM_PREFIX,'')+@COLDELIMITER+ISNULL(ENTTM_DESC,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_CLI_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_ENT_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_OTH_YN)+@COLDELIMITER+ISNULL(ENTTM_PARENT_CD,'')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),1,1),'0')+@COLDELIMITER+ISNULL(ENTTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
          FROM   ENTITY_TYPE_MSTR_MAK  WITH (NOLOCK)  
          WHERE  ENTTM_ID         = CONVERT(INT,@CURRSTRING)  
          AND    ENTTM_DELETED_IND = 1  
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
  
      IF @PA_ACTION = 'EDT'  --ACTION TYPE = EDT BEGINS HERE  
      BEGIN  
      --  
        IF @PA_CHK_YN = 0 -- IF NO MAKER CHECKER  
        BEGIN  
        --  
          BEGIN TRANSACTION  
          --  
          UPDATE ENTITY_TYPE_MSTR   WITH (ROWLOCK)  
          SET    ENTTM_CD         = @PA_ENTTM_CD  
                ,ENTTM_PREFIX     = @PA_ENTTM_PREFIX  
                ,ENTTM_DESC       = @PA_ENTTM_DESC  
                ,ENTTM_CLI_YN     = @L_ENTTM_CLI_YN  
                ,ENTTM_PARENT_CD  = @PA_ENTTM_PARENT_CD  
                ,ENTTM_RMKS       = @PA_ENTTM_RMKS  
                ,ENTTM_LST_UPD_BY = @PA_LOGIN_NAME  
                ,ENTTM_LST_UPD_DT = GETDATE()
                ,ENTTM_BIT        = @L_BUSM_BIT
          WHERE ENTTM_ID          = CONVERT(INT,@CURRSTRING)  
          --  
          SET @L_ERROR = @@ERROR  
          --  
          IF @L_ERROR > 0  
          BEGIN  
          --  
            SET @T_ERRORSTR=ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(@PA_ENTTM_CD,'')+@COLDELIMITER+ISNULL(@PA_ENTTM_PREFIX,'')+@COLDELIMITER+ISNULL(@PA_ENTTM_DESC,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_CLI_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_ENT_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_OTH_YN)+@COLDELIMITER+ISNULL(@PA_ENTTM_PARENT_CD,'')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),2,0),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),1,0),'0')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
            --  
            ROLLBACK TRANSACTION  
          --  
          END  
          ELSE  
          BEGIN  
          --  
            IF @L_OLD_ENTTM_CD <> UPPER(@PA_ENTTM_CD)  
            BEGIN  
            --  
              UPDATE ENTTM_ENTR_MAPPING WITH(ROWLOCK)  
              SET    ENTEM_ENTTM_CD    = UPPER(@PA_ENTTM_CD)  
              WHERE  ENTEM_ENTTM_CD    = @L_OLD_ENTTM_CD  
              AND    ENTEM_DELETED_IND =  1  
            --  
            END  
            --  
            COMMIT TRANSACTION  
          --  
          END  
        --  
        END  
  
        IF @PA_CHK_YN = 1 -- IF MAKER OR CHEKER IS EDITING  
        BEGIN  
        --  
          BEGIN TRANSACTION  
          --  
          UPDATE ENTITY_TYPE_MSTR_MAK WITH (ROWLOCK)  
          SET    ENTTM_DELETED_IND = 2  
                ,ENTTM_LST_UPD_BY  = @PA_LOGIN_NAME  
                ,ENTTM_LST_UPD_DT  = GETDATE()  
          WHERE  ENTTM_ID          = CONVERT(INT,@CURRSTRING)  
          AND    ENTTM_DELETED_IND = 0  
          --  
          SET @L_ERROR = @@ERROR  
          --  
          IF @L_ERROR > 0  
          BEGIN  
          --  
            SET @T_ERRORSTR = ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(@PA_ENTTM_CD,'')+@COLDELIMITER+ISNULL(@PA_ENTTM_PREFIX,'')+@COLDELIMITER+ISNULL(@PA_ENTTM_DESC,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_CLI_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_ENT_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_OTH_YN)+@COLDELIMITER+ISNULL(@PA_ENTTM_PARENT_CD,'')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),1,1),'0')+@COLDELIMITER+ISNULL(@PA_ENTTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
            --  
            ROLLBACK TRANSACTION  
          --  
          END  
          ELSE  
          BEGIN  
          --  
            INSERT INTO ENTITY_TYPE_MSTR_MAK  
            (ENTTM_ID  
            ,ENTTM_CD  
            ,ENTTM_PREFIX  
            ,ENTTM_DESC  
            ,ENTTM_CLI_YN  
            ,ENTTM_PARENT_CD  
            ,ENTTM_RMKS  
            ,ENTTM_CREATED_BY  
            ,ENTTM_CREATED_DT  
            ,ENTTM_LST_UPD_BY  
            ,ENTTM_LST_UPD_DT  
            ,ENTTM_DELETED_IND
            ,ENTTM_BIT
            )  
            VALUES
            (CONVERT(INT,@CURRSTRING)  
            ,@PA_ENTTM_CD  
            ,@PA_ENTTM_PREFIX  
            ,@PA_ENTTM_DESC  
            ,@L_ENTTM_CLI_YN  
            ,@PA_ENTTM_PARENT_CD  
            ,@PA_ENTTM_RMKS  
            ,@PA_LOGIN_NAME  
            ,GETDATE()  
            ,@PA_LOGIN_NAME  
            ,GETDATE()  
            ,0
            ,@L_BUSM_BIT
            )  
            --  
            SET @L_ERROR = @@ERROR  
            --  
            IF @L_ERROR > 0      --IF ANY ERROR REPORTS THEN GENERATE THE ERROR STRING  
            BEGIN  
            --  
              SET @T_ERRORSTR = ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(@PA_ENTTM_CD,'')+@COLDELIMITER+ISNULL(@PA_ENTTM_PREFIX,'')+@COLDELIMITER+ISNULL(@PA_ENTTM_DESC,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_CLI_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_ENT_YN)+@COLDELIMITER+CONVERT(VARCHAR,@L_ENTTM_OTH_YN)+@COLDELIMITER+ISNULL(@PA_ENTTM_PARENT_CD,'')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),2,1),'0')+@COLDELIMITER+ISNULL(citrus_usr.fn_get_enttm_bit(CONVERT(INT,@CURRSTRING),1,1),'0')+@COLDELIMITER+ISNULL(@PA_ENTTM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
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
    END  --END OF THE LOOP  
    --  
    SET @PA_ERRMSG = @T_ERRORSTR  
--  
END

GO
