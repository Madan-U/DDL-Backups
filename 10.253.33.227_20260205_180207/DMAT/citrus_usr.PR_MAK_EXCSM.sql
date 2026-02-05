-- Object: PROCEDURE citrus_usr.PR_MAK_EXCSM
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_MAK_EXCSM](@PA_ID                VARCHAR(8000)  
                             ,@PA_ACTION           VARCHAR(20)  
                             ,@PA_LOGIN_NAME       VARCHAR(20)  
                             ,@PA_COMPM_ID         INTEGER  
                             ,@PA_EXCH_CD          VARCHAR(20)
                             ,@PA_EXCH_SHORT_NAME  VARCHAR(20)
                             ,@PA_EXCH_DESC        VARCHAR(100)
                             ,@PA_SEG_CD           VARCHAR(20)  
                             ,@PA_SUB_SEG_CD       VARCHAR(20)  
                             ,@PA_DESC             VARCHAR(50)  
                             ,@PA_PARENT_ID        INTEGER  
                             ,@PA_EXCSM_RMKS       VARCHAR(200)  
                             ,@PA_CHK_YN           INT  
                             ,@ROWDELIMITER        CHAR(4) =  '*|~*'  
                             ,@COLDELIMITER        CHAR(4) = '|*~|'  
                             ,@PA_ERRMSG           VARCHAR(8000) OUTPUT  
                                                                                                                        )  
AS  
/*  
*********************************************************************************  
 SYSTEM         : Citrus  
 MODULE NAME    : PR_MAK_EXCSM  
 DESCRIPTION    : THIS PROCEDURE WILL ADD NEW VALUES TO  EXCH_SEG_MSTR  
 COPYRIGHT(C)   : Marketplace Technology pvt. ltd.  
 VERSION HISTORY:  
 VERS.  AUTHOR           DATE        REASON  
 -----  -------------   ----------   -------------------------------------------------  
 1.0    Sukhvinder      11.01.2007   CHANGES IN WHENEVER ENTER VALUE IN EXCHS_MSTR NEW VALUE INSERT INTO BITMAP_REF  
-----------------------------------------------------------------------------------
********************************************************************************* 
*/  
--  
BEGIN  
  --  
  SET NOCOUNT ON  
  --
  IF @PA_PARENT_ID = 0  
  BEGIN  
  --  
    SET @PA_PARENT_ID = NULL  
  --  
  END  
  --  
  DECLARE @T_ERRORSTR          VARCHAR(8000)  
        , @L_SEXCSM_ID         NUMERIC  
        , @L_EXCSM_ID          NUMERIC  
        , @L_ERROR             BIGINT  
        , @DELIMETER           VARCHAR(10)  
        , @REMAININGSTRING     VARCHAR(8000)  
        , @CURRSTRING          VARCHAR(8000)  
        , @FOUNDAT             INTEGER  
        , @DELIMETERLENGTH     INT  
        , @L_BIT_LOCN          INT  
        , @L_BITRM_ID          NUMERIC  
        , @L_BITRM_CHILD_CD    VARCHAR(50)  
        , @L_PA_DESC           VARCHAR(50)  
        , @L_EXCPM_ID          NUMERIC
        , @L_BUSM_CD           VARCHAR(200)
        , @L_BUSM_BIT          NUMERIC
        , @L_EXCM_ID           NUMERIC
        , @L_EXCM_CD           VARCHAR(20)
  -- 
  SET @L_BUSM_BIT      = 0  
  SET @L_ERROR         = 0  
  SET @L_EXCSM_ID      = NULL  
  SET @T_ERRORSTR      = ''  
  SET @DELIMETER       = '%'+ @ROWDELIMITER + '%'  
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
    IF @CURRSTRING <> ''  
    BEGIN  
    --
      /*
      --**EXCSM_BIT**--
       DECLARE @l_counter  INT
             , @l          INT
             , @l_busm_id  INT 
       --      
       SET @l_counter = CITRUS_USR.UFN_COUNTSTRING(@PA_EXCSM_BUSM_YN,'|*~|')
       SET @l         = 1
       --
       WHILE @l <= @l_counter 
       BEGIN--#1
       --
         SET @l_busm_id       = CONVERT(INT,CITUS_USR.FN_SPLITVAL(@PA_EXCSM_BUSM_YN,@l))
         --
         SELECT @L_BUSM_CD    = BUSM_CD  
         FROM   BUSINESS_MSTR   WITH (NOLOCK)
         WHERE  BUSM_ID       = CONVERT(INT, @l_busm_id)
         --
         SELECT @L_BUSM_BIT  = CASE WHEN @L_BUSM_CD = 'ALL' THEN CITRUS_USR.FN_GET_BUSM_ACCESS('BUS_%')
                                    ELSE CITRUS_USR.FN_GET_BUSM_ACCESS('BUS_'+ @L_BUSM_CD +'%')
                                    END
         SET @l = @l + 1                            
       --
       END--#1
      --**EXCSM_BIT**--
      */
      IF @PA_ACTION = 'INS'  --ACTION TYPE = INS BEGINS HERE  
      BEGIN  
        --  
        IF @PA_CHK_YN = 0 -- IF MAKER CHECKER FUNCTIONALITY IS NOT REQD  
        BEGIN  
          --
          BEGIN TRANSACTION
          
          SELECT @L_EXCSM_ID = ISNULL(MAX(EXCSM_ID),0)+1  
          FROM EXCH_SEG_MSTR WITH(NOLOCK)  
          --  
          INSERT INTO EXCH_SEG_MSTR  
          (EXCSM_ID  
          ,EXCSM_COMPM_ID  
          ,EXCSM_EXCH_CD  
          ,EXCSM_SEG_CD  
          ,EXCSM_SUB_SEG_CD  
          ,EXCSM_DESC  
          ,EXCSM_PARENT_ID  
          ,EXCSM_RMKS  
          ,EXCSM_CREATED_BY  
          ,EXCSM_CREATED_DT  
          ,EXCSM_LST_UPD_BY  
          ,EXCSM_LST_UPD_DT  
          ,EXCSM_DELETED_IND
          ,EXCSM_BIT
          )  
          VALUES  
          (@L_EXCSM_ID  
          ,@PA_COMPM_ID  
          ,@PA_EXCH_CD  
          ,@PA_SEG_CD  
          ,REPLACE(@PA_SUB_SEG_CD, ' ', @PA_SEG_CD)  
          ,@PA_DESC  
          ,@PA_PARENT_ID  
          ,@PA_EXCSM_RMKS  
          ,@PA_LOGIN_NAME  
          ,GETDATE()  
          ,@PA_LOGIN_NAME  
          ,GETDATE()  
          ,1
          ,@L_BUSM_BIT
          )  
          --
          SET @L_ERROR = @@ERROR          
          
          IF @L_ERROR > 0  
										BEGIN  
										--  
												SET @T_ERRORSTR=ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(@PA_EXCH_CD,'')+@COLDELIMITER+ISNULL(@PA_EXCH_SHORT_NAME,'')+@COLDELIMITER+ISNULL(@PA_EXCH_DESC,'')+@COLDELIMITER+ISNULL(@PA_SEG_CD,'')+@COLDELIMITER+ISNULL(@PA_SUB_SEG_CD,'')+@COLDELIMITER+ISNULL(@PA_DESC,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,@PA_PARENT_ID),0)+@COLDELIMITER+CONVERT(VARCHAR,@PA_COMPM_ID)+@COLDELIMITER+ISNULL(@PA_EXCSM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
												
												ROLLBACK TRANSACTION
										--  
          END
          ELSE
          BEGIN
          --
											SELECT @L_BIT_LOCN     = MAX(BITRM_BIT_LOCATION) + 1  
											FROM   BITMAP_REF_MSTR   WITH (NOLOCK)  
											WHERE  BITRM_PARENT_CD = 'ACCESS1'  
											--  
											IF NOT EXISTS(SELECT BITRM_BIT_LOCATION  
																									FROM   BITMAP_REF_MSTR  WITH (NOLOCK)  
																									WHERE  BITRM_PARENT_CD = 'ACCESS1'  
																									)  
											BEGIN  
											--  
												SET @L_BIT_LOCN = 1  
											--  
											END  
											--  
											SELECT @L_BITRM_ID = MAX(BITRM_ID)+1  
											FROM BITMAP_REF_MSTR  WITH (NOLOCK)  
											--
											

											INSERT INTO BITMAP_REF_MSTR  
											(BITRM_ID  
											,BITRM_PARENT_CD  
											,BITRM_CHILD_CD  
											,BITRM_BIT_LOCATION  
											,BITRM_CREATED_BY  
											,BITRM_CREATED_DT  
											,BITRM_LST_UPD_BY  
											,BITRM_LST_UPD_DT  
											,BITRM_DELETED_IND  
											)  
											VALUES  
											(@L_BITRM_ID  
											,'ACCESS1'  
											,@PA_DESC  
											,@L_BIT_LOCN  
											,@PA_LOGIN_NAME  
											,GETDATE()  
											,@PA_LOGIN_NAME  
											,GETDATE()  
											,1  
											)  
											--  
											SET @L_ERROR = @@ERROR  
											--  
											IF @L_ERROR > 0  
											BEGIN  
													--  
													SET @T_ERRORSTR=ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(@PA_EXCH_CD,'')+@COLDELIMITER+ISNULL(@PA_EXCH_SHORT_NAME,'')+@COLDELIMITER+ISNULL(@PA_EXCH_DESC,'')+@COLDELIMITER+ISNULL(@PA_SEG_CD,'')+@COLDELIMITER+ISNULL(@PA_SUB_SEG_CD,'')+@COLDELIMITER+ISNULL(@PA_DESC,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,@PA_PARENT_ID),0)+@COLDELIMITER+CONVERT(VARCHAR,@PA_COMPM_ID)+@COLDELIMITER+ISNULL(@PA_EXCSM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  

													ROLLBACK TRANSACTION
													--  
											END  
											ELSE
											BEGIN
											--
													IF NOT EXISTS (select * from exchange_mstr where excm_cd in (select excsm_exch_cd from exch_seg_mstr where excsm_id = @L_EXCSM_ID  ))
													BEGIN
													--

															SELECT @L_EXCM_ID = ISNULL(MAX(EXCM_ID),0)+1  
															FROM EXCHANGE_MSTR WITH(NOLOCK)  

															INSERT INTO EXCHANGE_MSTR
															(EXCM_ID
															,EXCM_CD
															,EXCM_SHORT_NAME
															,EXCM_DESC
															,EXCM_RMKS
															,EXCM_CREATED_BY
															,EXCM_CREATED_DT
															,EXCM_LST_UPD_BY
															,EXCM_LST_UPD_DT
															,EXCM_DELETED_IND
															)
															VALUES
															(@L_EXCM_ID
															,@PA_EXCH_CD
															,@PA_EXCH_SHORT_NAME
															,@PA_EXCH_DESC
															,''
															,@PA_LOGIN_NAME
															,GETDATE()
															,@PA_LOGIN_NAME
															,GETDATE()
															,1
															)
												--
												END

										--
										END
										--
										SET @L_ERROR = @@ERROR     
										--  
										IF @L_ERROR > 0  
										BEGIN  
										--  
												SET @T_ERRORSTR=ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(@PA_EXCH_CD,'')+@COLDELIMITER+ISNULL(@PA_EXCH_SHORT_NAME,'')+@COLDELIMITER+ISNULL(@PA_EXCH_DESC,'')+@COLDELIMITER+ISNULL(@PA_SEG_CD,'')+@COLDELIMITER+ISNULL(@PA_SUB_SEG_CD,'')+@COLDELIMITER+ISNULL(@PA_DESC,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,@PA_PARENT_ID),0)+@COLDELIMITER+CONVERT(VARCHAR,@PA_COMPM_ID)+@COLDELIMITER+ISNULL(@PA_EXCSM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  

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
        IF @PA_CHK_YN = 1 -- IF MAKER IS INSERTING  
        BEGIN  
        --  
          SELECT @L_EXCSM_ID = ISNULL(MAX(SM.EXCSM_ID),0)+1  
          FROM EXCH_SEG_MSTR_MAK SM WITH(NOLOCK)  
          --  
          SELECT @L_SEXCSM_ID = ISNULL(MAX(S.EXCSM_ID),0)+1  
          FROM EXCH_SEG_MSTR S WITH(NOLOCK)  
          --  
          IF @L_SEXCSM_ID < @L_EXCSM_ID  
          BEGIN  
          --  
            SET @L_SEXCSM_ID = @L_EXCSM_ID  
          --  
          END  
          --  
          INSERT INTO EXCH_SEG_MSTR_MAK  
          (EXCSM_ID  
          ,EXCSM_COMPM_ID  
          ,EXCSM_EXCH_CD  
          ,EXCSM_SEG_CD  
          ,EXCSM_SUB_SEG_CD  
          ,EXCSM_DESC  
          ,EXCSM_PARENT_ID  
          ,EXCSM_RMKS  
          ,EXCSM_CREATED_BY  
          ,EXCSM_CREATED_DT  
          ,EXCSM_LST_UPD_BY  
          ,EXCSM_LST_UPD_DT  
          ,EXCSM_DELETED_IND 
          ,EXCSM_BIT
          )  
          VALUES  
          (@L_SEXCSM_ID  
          ,@PA_COMPM_ID  
          ,@PA_EXCH_CD  
          ,@PA_SEG_CD  
          ,REPLACE(@PA_SUB_SEG_CD, ' ', @PA_SEG_CD)  
          ,@PA_DESC  
          ,@PA_PARENT_ID  
          ,@PA_EXCSM_RMKS  
          ,@PA_LOGIN_NAME  
          ,GETDATE()  
          ,@PA_LOGIN_NAME  
          ,GETDATE()  
          ,0
          ,@L_BUSM_BIT
          )  
          --  
          SET @L_ERROR = @@ERROR    --COMMON ERROR FOR BOTH THE CASES  
          --  
          IF @L_ERROR > 0  
          BEGIN  
          --  
            SET @T_ERRORSTR=ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(@PA_EXCH_CD,'')+@COLDELIMITER+ISNULL(@PA_EXCH_SHORT_NAME,'')+@COLDELIMITER+ISNULL(@PA_EXCH_DESC,'')+@COLDELIMITER+ISNULL(@PA_SEG_CD,'')+@COLDELIMITER+ISNULL(@PA_SUB_SEG_CD,'')+@COLDELIMITER+ISNULL(@PA_DESC,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,@PA_PARENT_ID),0)+@COLDELIMITER+CONVERT(VARCHAR,@PA_COMPM_ID)+@COLDELIMITER+ISNULL(@PA_EXCSM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
          --  
          END
          ELSE
          BEGIN
          --
            IF EXISTS (select * from excm_mak where excm_cd = @pa_exch_cd and EXCM_DELETED_IND =0)
												BEGIN
												--
												  UPDATE EXCM_MAK 
												  SET    EXCM_DELETED_IND = 2
												       , EXCM_LST_UPD_BY  = @pa_login_name
												       , EXCM_LST_UPD_DT  = GETDATE()
												            
												  WHERE  EXCM_CD          = @pa_exch_cd
												  AND    EXCM_DELETED_IND = 0
            --
            END
														
														SELECT @L_EXCM_ID = ISNULL(MAX(EXCM_ID),0)+1  
														FROM EXCM_MAK WITH(NOLOCK)  

														INSERT INTO EXCM_MAK
														(EXCM_ID
														,EXCM_CD
														,EXCM_SHORT_NAME
														,EXCM_DESC
														,EXCM_RMKS
														,EXCM_CREATED_BY
														,EXCM_CREATED_DT
														,EXCM_LST_UPD_BY
														,EXCM_LST_UPD_DT
														,EXCM_DELETED_IND
														)
														VALUES
														(@L_EXCM_ID
														,@PA_EXCH_CD
														,@PA_EXCH_SHORT_NAME
														,@PA_EXCH_DESC
														,''
														,@PA_LOGIN_NAME
														,GETDATE()
														,@PA_LOGIN_NAME
														,GETDATE()
														,0
														)
												
          --
          END
        --  
        END  
      --  
      END  --ACTION TYPE = INS ENDS HERE  
      --  
      IF @PA_ACTION = 'APP'    --ACTION TYPE = APP STARTS HERE  
      BEGIN--APP  
      --  
        IF EXISTS(SELECT EXCSM_ID  
                  FROM   EXCH_SEG_MSTR  WITH (NOLOCK)  
                  WHERE  EXCSM_ID = CONVERT(INT, @CURRSTRING)  
                  AND EXCSM_DELETED_IND  = 1)  
        BEGIN --#1  
        --  
          BEGIN TRANSACTION  
          --  
          UPDATE EXCSM WITH(ROWLOCK)  
          SET    EXCSM.EXCSM_COMPM_ID     = @PA_COMPM_ID  
                ,EXCSM.EXCSM_EXCH_CD      = EXCSMM.EXCSM_EXCH_CD  
                ,EXCSM.EXCSM_SEG_CD       = EXCSMM.EXCSM_SEG_CD  
                ,EXCSM.EXCSM_SUB_SEG_CD   = EXCSMM.EXCSM_SUB_SEG_CD  
                ,EXCSM.EXCSM_DESC         = EXCSMM.EXCSM_DESC  
                ,EXCSM.EXCSM_PARENT_ID    = EXCSMM.EXCSM_PARENT_ID  
                ,EXCSM.EXCSM_RMKS         = EXCSMM.EXCSM_RMKS
                ,EXCSM.EXCSM_BIT          = EXCSMM.EXCSM_BIT
                ,EXCSM.EXCSM_LST_UPD_BY   = @PA_LOGIN_NAME  
                ,EXCSM.EXCSM_DELETED_IND  = 1  
          FROM   EXCH_SEG_MSTR EXCSM,  
                 EXCH_SEG_MSTR_MAK  EXCSMM  
          WHERE  EXCSM.EXCSM_ID           = CONVERT(INT,@CURRSTRING)  
          AND    EXCSMM.EXCSM_DELETED_IND = 0  
          AND    EXCSM.EXCSM_DELETED_IND  = 1  
          AND    EXCSMM.EXCSM_CREATED_BY <> @PA_LOGIN_NAME  
          --  
          SET @L_ERROR = @@ERROR  
          --  
          IF @L_ERROR > 0  
          BEGIN--#01  
          --  
            SELECT @T_ERRORSTR      = ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(EXCSM_EXCH_CD,'')+@COLDELIMITER+ISNULL(EXCM_SHORT_NAME,'')+@COLDELIMITER+ISNULL(EXCM_DESC,'')+@COLDELIMITER+ISNULL(EXCSM_SEG_CD,'')+@COLDELIMITER+ISNULL(EXCSM_SUB_SEG_CD,'')+@COLDELIMITER+ISNULL(EXCSM_DESC,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,EXCSM_PARENT_ID),0)+@COLDELIMITER+CONVERT(VARCHAR,EXCSM_COMPM_ID)+@COLDELIMITER+ISNULL(EXCSM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
            FROM   EXCH_SEG_MSTR_MAK WITH(NOLOCK)
                  ,EXCM_MAK          WITH(NOLOCK)
            WHERE  EXCM_CD           = EXCSM_EXCH_CD
            and    EXCSM_ID          = CONVERT(INT,@CURRSTRING)  
            AND    EXCSM_DELETED_IND = 0  
            AND    EXCM_DELETED_IND  = 0  
            --  
            ROLLBACK TRANSACTION  
          --  
          END--#01  
          -- 
          
          UPDATE EXCHANGE_MSTR     
										SET    EXCM_CD         = EXCMM.EXCM_CD
																,EXCM_SHORT_NAME = EXCMM.EXCM_SHORT_NAME
																,EXCM_DESC       = EXCMM.EXCM_DESC
																,EXCM_LST_UPD_BY = @PA_LOGIN_NAME
																,EXCM_LST_UPD_DT = GETDATE()
										FROM   EXCM_MAK          EXCMM
										     , EXCH_SEG_MSTR_MAK EXCSMM
										WHERE  EXCSM_ID           = CONVERT(INT,@CURRSTRING)  
										AND    EXCMM.EXCM_CD      = EXCSM_EXCH_CD
										AND    EXCMM.EXCM_CREATED_BY  <> @PA_LOGIN_NAME  
          AND    EXCMM.EXCM_DELETED_IND  = 0 
          
          
          UPDATE EXCH_SEG_MSTR_MAK    WITH(ROWLOCK)  
          SET    EXCSM_DELETED_IND  = 1  
                ,EXCSM_LST_UPD_BY   = @PA_LOGIN_NAME  
                ,EXCSM_LST_UPD_DT   = GETDATE()  
          WHERE  EXCSM_ID           = CONVERT(INT,@CURRSTRING)  
          AND    EXCSM_CREATED_BY  <> @PA_LOGIN_NAME  
          AND    EXCSM_DELETED_IND  = 0  
          
          UPDATE EXCM_MAK    WITH(ROWLOCK)  
										SET    EXCM_DELETED_IND  = 1  
																,EXCM_LST_UPD_BY   = @PA_LOGIN_NAME  
																,EXCM_LST_UPD_DT   = GETDATE()  
										FROM   EXCH_SEG_MSTR_MAK  						
										WHERE  EXCSM_ID           = CONVERT(INT,@CURRSTRING)  
										AND    EXCM_CD            = EXCSM_EXCH_CD
										AND    EXCM_CREATED_BY  <> @PA_LOGIN_NAME  
          AND    EXCM_DELETED_IND  = 0  
          --  
          
             
          
          SET @L_ERROR = @@ERROR  
          --  
          IF @L_ERROR > 0  
          BEGIN--#02  
          --  
            SELECT @T_ERRORSTR      = ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(EXCSM_EXCH_CD,'')+@COLDELIMITER+ISNULL(EXCM_SHORT_NAME,'')+@COLDELIMITER+ISNULL(EXCM_DESC,'')+@COLDELIMITER+ISNULL(EXCSM_SEG_CD,'')+@COLDELIMITER+ISNULL(EXCSM_SUB_SEG_CD,'')+@COLDELIMITER+ISNULL(EXCSM_DESC,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,EXCSM_PARENT_ID),0)+@COLDELIMITER+CONVERT(VARCHAR,EXCSM_COMPM_ID)+@COLDELIMITER+ISNULL(EXCSM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
												FROM   EXCH_SEG_MSTR_MAK WITH(NOLOCK)
																		,EXCM_MAK          WITH(NOLOCK)
												WHERE  EXCM_CD           = EXCSM_EXCH_CD
												and    EXCSM_ID          = CONVERT(INT,@CURRSTRING)  
            AND    EXCSM_DELETED_IND = 0  
            AND    EXCM_DELETED_IND = 0
            --  
            ROLLBACK TRANSACTION  
          --  
          END--#02  
          --  
          COMMIT TRANSACTION  
        --  
        END--#1  
        ELSE  
        BEGIN--#2  
        --  
          BEGIN TRANSACTION  
          --  
          INSERT INTO EXCH_SEG_MSTR  
          (EXCSM_ID  
          ,EXCSM_COMPM_ID  
          ,EXCSM_EXCH_CD  
          ,EXCSM_SEG_CD  
          ,EXCSM_SUB_SEG_CD  
          ,EXCSM_DESC  
          ,EXCSM_PARENT_ID  
          ,EXCSM_RMKS  
          ,EXCSM_CREATED_BY  
          ,EXCSM_CREATED_DT  
          ,EXCSM_LST_UPD_BY  
          ,EXCSM_LST_UPD_DT  
          ,EXCSM_DELETED_IND
          ,EXCSM_BIT
          )  
          SELECT EXCSMM.EXCSM_ID  
          ,EXCSMM.EXCSM_COMPM_ID  
          ,EXCSMM.EXCSM_EXCH_CD  
          ,EXCSMM.EXCSM_SEG_CD  
          ,EXCSMM.EXCSM_SUB_SEG_CD  
          ,EXCSMM.EXCSM_DESC  
          ,EXCSMM.EXCSM_PARENT_ID  
          ,EXCSMM.EXCSM_RMKS  
          ,EXCSMM.EXCSM_CREATED_BY  
          ,EXCSMM.EXCSM_CREATED_DT  
          ,@PA_LOGIN_NAME  
          ,GETDATE()  
          ,1
          ,EXCSMM.EXCSM_BIT
          FROM   EXCH_SEG_MSTR_MAK EXCSMM  WITH (NOLOCK)  
          WHERE  EXCSMM.EXCSM_ID          = CONVERT(INT,@CURRSTRING)  
          AND    EXCSMM.EXCSM_CREATED_BY <> @PA_LOGIN_NAME  
          AND    EXCSMM.EXCSM_DELETED_IND = 0  
          --  
          SET @L_ERROR = @@ERROR  
          --  
          IF @L_ERROR > 0  
          BEGIN--#R1  
          --  
            SELECT @T_ERRORSTR      = ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(EXCSM_EXCH_CD,'')+@COLDELIMITER+ISNULL(EXCM_SHORT_NAME,'')+@COLDELIMITER+ISNULL(EXCM_DESC,'')+@COLDELIMITER+ISNULL(EXCSM_SEG_CD,'')+@COLDELIMITER+ISNULL(EXCSM_SUB_SEG_CD,'')+@COLDELIMITER+ISNULL(EXCSM_DESC,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,EXCSM_PARENT_ID),0)+@COLDELIMITER+CONVERT(VARCHAR,EXCSM_COMPM_ID)+@COLDELIMITER+ISNULL(EXCSM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
												FROM   EXCH_SEG_MSTR_MAK WITH(NOLOCK)
																		,EXCM_MAK          WITH(NOLOCK)
												WHERE  EXCM_CD           = EXCSM_EXCH_CD
												and    EXCSM_ID          = CONVERT(INT,@CURRSTRING)  
												AND    EXCSM_DELETED_IND = 0  
            AND    EXCM_DELETED_IND = 0
            --  
            ROLLBACK TRANSACTION  
          --  
          END--#R1  
          ELSE  
          BEGIN--#C1  
          --  
            SELECT @L_BIT_LOCN    = MAX(BITRM_BIT_LOCATION) + 1  
            FROM   BITMAP_REF_MSTR WITH (NOLOCK)  
            WHERE  BITRM_PARENT_CD = 'ACCESS1'  
            --  
            IF NOT EXISTS(SELECT BITRM_BIT_LOCATION  
                          FROM   BITMAP_REF_MSTR  WITH (NOLOCK)  
                          WHERE  BITRM_PARENT_CD = 'ACCESS1'  
                         )  
            BEGIN--#NE  
            --  
              SET @L_BIT_LOCN = 1  
            --  
            END--#NE  
            --  
            SELECT @L_BITRM_ID = MAX(BITRM_ID) + 1  
            FROM BITMAP_REF_MSTR  WITH (NOLOCK)  
            --  
            SELECT @L_PA_DESC              = EXCSMM.EXCSM_DESC  
            FROM   EXCH_SEG_MSTR_MAK EXCSMM  WITH (NOLOCK)  
            WHERE  EXCSMM.EXCSM_ID          = CONVERT(INT,@CURRSTRING)  
            AND    EXCSMM.EXCSM_CREATED_BY <> @PA_LOGIN_NAME  
            AND    EXCSMM.EXCSM_DELETED_IND = 0  
            --  
            INSERT INTO BITMAP_REF_MSTR  
            (BITRM_ID  
            ,BITRM_PARENT_CD  
            ,BITRM_CHILD_CD  
            ,BITRM_BIT_LOCATION  
            ,BITRM_CREATED_BY  
            ,BITRM_CREATED_DT  
            ,BITRM_LST_UPD_BY  
            ,BITRM_LST_UPD_DT  
            ,BITRM_DELETED_IND  
            )  
            VALUES  
            (@L_BITRM_ID  
            ,'ACCESS1'  
            ,@L_PA_DESC  
            ,@L_BIT_LOCN  
            ,@PA_LOGIN_NAME  
            ,GETDATE()  
            ,@PA_LOGIN_NAME  
            ,GETDATE()  
            ,1  
            )  
            --  
            SET @L_ERROR = @@ERROR  
            --  
            IF @L_ERROR > 0  
            BEGIN--#R2  
            --  
              SELECT @T_ERRORSTR      = ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(EXCSM_EXCH_CD,'')+@COLDELIMITER+ISNULL(EXCM_SHORT_NAME,'')+@COLDELIMITER+ISNULL(EXCM_DESC,'')+@COLDELIMITER+ISNULL(EXCSM_SEG_CD,'')+@COLDELIMITER+ISNULL(EXCSM_SUB_SEG_CD,'')+@COLDELIMITER+ISNULL(EXCSM_DESC,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,EXCSM_PARENT_ID),0)+@COLDELIMITER+CONVERT(VARCHAR,EXCSM_COMPM_ID)+@COLDELIMITER+ISNULL(EXCSM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
														FROM   EXCH_SEG_MSTR_MAK WITH(NOLOCK)
																				,EXCM_MAK          WITH(NOLOCK)
														WHERE  EXCM_CD           = EXCSM_EXCH_CD
														and    EXCSM_ID          = CONVERT(INT,@CURRSTRING)  
														AND    EXCSM_DELETED_IND = 0  
														AND    EXCM_DELETED_IND = 0 
              --  
              ROLLBACK TRANSACTION  
            --  
            END--#R2  
            ELSE  
            BEGIN--#C2  
            --
              IF NOT EXISTS (select * from exchange_mstr where excm_cd in (select excsm_exch_cd from exch_seg_mstr where excsm_id = CONVERT(INT,@CURRSTRING)))
              BEGIN
              --
																INSERT INTO EXCHANGE_MSTR
																(EXCM_ID
																,EXCM_CD
																,EXCM_SHORT_NAME
																,EXCM_DESC
																,EXCM_RMKS
																,EXCM_CREATED_BY
																,EXCM_CREATED_DT
																,EXCM_LST_UPD_BY
																,EXCM_LST_UPD_DT
																,EXCM_DELETED_IND
																)
																SELECT EXCM_ID
																      ,EXCM_CD
																						,EXCM_SHORT_NAME
																						,EXCM_DESC
																						,EXCM_RMKS
																						,EXCM_CREATED_BY
																						,EXCM_CREATED_DT 
												          ,@PA_LOGIN_NAME  
																      ,GETDATE()  
																      ,1
														  FROM   EXCH_SEG_MSTR_MAK EXCSMM  WITH (NOLOCK)  
														        ,EXCM_MAK                  WITH (NOLOCK)    
														  WHERE  EXCSMM.EXCSM_ID          = CONVERT(INT,@CURRSTRING)  
														  AND    EXCM_CD                  = EXCSM_EXCH_CD
																AND    EXCM_CREATED_BY     <> @PA_LOGIN_NAME  
                AND    EXCM_DELETED_IND         = 0 
																
																
														--
														END
            
              UPDATE EXCH_SEG_MSTR_MAK WITH(ROWLOCK)  
              SET    EXCSM_DELETED_IND   = 1  
                    ,EXCSM_LST_UPD_BY    = @PA_LOGIN_NAME  
                    ,EXCSM_LST_UPD_DT    = GETDATE()  
              WHERE  EXCSM_ID            = CONVERT(INT,@CURRSTRING)  
              AND    EXCSM_CREATED_BY   <> @PA_LOGIN_NAME  
              AND    EXCSM_DELETED_IND   = 0 
              
              UPDATE EXCM_MAK WITH(ROWLOCK)  
														SET    EXCM_DELETED_IND   = 1  
																				,EXCM_LST_UPD_BY    = @PA_LOGIN_NAME  
																				,EXCM_LST_UPD_DT    = GETDATE()  
														FROM   EXCH_SEG_MSTR_MAK 						
														WHERE  EXCSM_ID            = CONVERT(INT,@CURRSTRING)  
														AND    EXCSM_EXCH_CD       = EXCM_CD
														AND    EXCM_CREATED_BY   <> @PA_LOGIN_NAME  
              AND    EXCM_DELETED_IND   = 0 
              
              --  
              SET @L_ERROR = @@ERROR  
              --  
              IF @L_ERROR > 0  
              BEGIN--#R3  
              --  
                SELECT @T_ERRORSTR      = ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(EXCSM_EXCH_CD,'')+@COLDELIMITER+ISNULL(EXCM_SHORT_NAME,'')+@COLDELIMITER+ISNULL(EXCM_DESC,'')+@COLDELIMITER+ISNULL(EXCSM_SEG_CD,'')+@COLDELIMITER+ISNULL(EXCSM_SUB_SEG_CD,'')+@COLDELIMITER+ISNULL(EXCSM_DESC,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,EXCSM_PARENT_ID),0)+@COLDELIMITER+CONVERT(VARCHAR,EXCSM_COMPM_ID)+@COLDELIMITER+ISNULL(EXCSM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
																FROM   EXCH_SEG_MSTR_MAK WITH(NOLOCK)
																						,EXCM_MAK          WITH(NOLOCK)
																WHERE  EXCM_CD           = EXCSM_EXCH_CD
																and    EXCSM_ID          = CONVERT(INT,@CURRSTRING)  
																AND    EXCSM_DELETED_IND = 0  
                AND    EXCM_DELETED_IND = 0
                --  
                ROLLBACK TRANSACTION  
              --  
              END--#R3  
              ELSE  
              BEGIN--#C3  
              --  
                COMMIT TRANSACTION   
              --  
              END--#C3  
            --  
            END--#C2  
          --  
          END  --#C1  
        --  
        END--#2  
     --  
     END--APP  
     --  
     IF @PA_ACTION ='REJ'    --ACTION TYPE = REJ BEGINS HERE  
     BEGIN  
       --  
       IF @PA_CHK_YN = 1 -- IF CHEKER IS REJECTING  
       BEGIN  
         --  
         BEGIN TRANSACTION  
         --  
         UPDATE EXCH_SEG_MSTR_MAK  WITH(ROWLOCK)  
         SET    EXCSM_DELETED_IND = 3  
               ,EXCSM_LST_UPD_BY  = @PA_LOGIN_NAME  
               ,EXCSM_LST_UPD_DT  = GETDATE()  
         WHERE  EXCSM_ID          = CONVERT(INT,@CURRSTRING)  
         AND    EXCSM_DELETED_IND = 0  
         
         
         UPDATE EXCM_MAK  WITH(ROWLOCK)  
									SET    EXCM_DELETED_IND = 3  
															,EXCM_LST_UPD_BY  = @PA_LOGIN_NAME  
															,EXCM_LST_UPD_DT  = GETDATE()  
									FROM   EXCH_SEG_MSTR_MAK 						
									WHERE  EXCM_CD          =  EXCSM_EXCH_CD
									AND    EXCSM_ID         = CONVERT(INT,@CURRSTRING)
         AND    EXCM_DELETED_IND = 0 
         --  
         SET @L_ERROR = @@ERROR  
         --  
         IF @L_ERROR > 0      --IF ANY ERROR REPORTS THEN GENERATE THE ERROR STRING  
         BEGIN  
           --  
           SELECT @T_ERRORSTR      = ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(EXCSM_EXCH_CD,'')+@COLDELIMITER+ISNULL(EXCM_SHORT_NAME,'')+@COLDELIMITER+ISNULL(EXCM_DESC,'')+@COLDELIMITER+ISNULL(EXCSM_SEG_CD,'')+@COLDELIMITER+ISNULL(EXCSM_SUB_SEG_CD,'')+@COLDELIMITER+ISNULL(EXCSM_DESC,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,EXCSM_PARENT_ID),0)+@COLDELIMITER+CONVERT(VARCHAR,EXCSM_COMPM_ID)+@COLDELIMITER+ISNULL(EXCSM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
											FROM   EXCH_SEG_MSTR_MAK WITH(NOLOCK)
																	,EXCM_MAK          WITH(NOLOCK)
											WHERE  EXCM_CD           = EXCSM_EXCH_CD
											and    EXCSM_ID          = CONVERT(INT,@CURRSTRING)  
											AND    EXCSM_DELETED_IND = 0  
           AND    EXCM_DELETED_IND  = 0
           
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
									UPDATE EXCHANGE_MSTR        WITH(ROWLOCK)  
									SET    EXCM_DELETED_IND  = 0  
															,EXCM_LST_UPD_BY   = @PA_LOGIN_NAME  
															,EXCM_LST_UPD_DT   = GETDATE()  
									FROM   EXCH_SEG_MSTR       EXCSM      
									WHERE  EXCSM_ID          = CONVERT(INT,@CURRSTRING)  
									AND    EXCM_CD           = EXCSM_EXCH_CD
									AND    EXCM_DELETED_IND  = 1   
       
       --  
       SET @L_ERROR = @@ERROR  
       --  
       IF @L_ERROR > 0  
       BEGIN  
       --  
         ROLLBACK TRANSACTION  
         --  
         SELECT @T_ERRORSTR      = ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(EXCSM_EXCH_CD,'')+@COLDELIMITER+ISNULL(EXCSM_SEG_CD,'')+@COLDELIMITER+ISNULL(EXCSM_SUB_SEG_CD,'')+@COLDELIMITER+ISNULL(EXCSM_DESC,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,EXCSM_PARENT_ID),0)+@COLDELIMITER+CONVERT(VARCHAR,EXCSM_COMPM_ID)+@COLDELIMITER+ISNULL(EXCSM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
         FROM  EXCH_SEG_MSTR       WITH(NOLOCK)  
         WHERE EXCSM_ID          = CONVERT(INT,@CURRSTRING)  
         AND   EXCSM_DELETED_IND = 1  
       --  
       END  
       ELSE  
       BEGIN  
       --
         UPDATE EXCH_SEG_MSTR        WITH(ROWLOCK)  
									SET    EXCSM_DELETED_IND  = 0  
															,EXCSM_LST_UPD_BY   = @PA_LOGIN_NAME  
															,EXCSM_LST_UPD_DT   = GETDATE()  
									WHERE  EXCSM_ID           = CONVERT(INT,@CURRSTRING)  
         AND    EXCSM_DELETED_IND  = 1  
         
         COMMIT TRANSACTION  
       --  
       END  
     --  
     END  --ACTION TYPE = DEL ENDS HERE  
  
     IF @PA_ACTION ='EDT'  --ACTION TYPE = EDT BEGINS HERE  
     BEGIN  
       --  
       IF @PA_CHK_YN = 0 -- IF NO MAKER CHECKER  
       BEGIN  
         --  
         BEGIN TRANSACTION  
         --  
         SELECT @L_BITRM_CHILD_CD = EXCSM.EXCSM_DESC  
         FROM   EXCH_SEG_MSTR        EXCSM  WITH (NOLOCK)  
         WHERE  EXCSM.EXCSM_ID     = @PA_ID  
         --
         
         UPDATE EXCHANGE_MSTR       WITH(ROWLOCK)  
									SET    EXCM_CD           = @PA_EXCH_CD
														, EXCM_DESC         = @PA_EXCH_DESC
														, EXCM_SHORT_NAME   = @PA_EXCH_SHORT_NAME
														, EXCM_LST_UPD_BY   = @PA_LOGIN_NAME  
														, EXCM_LST_UPD_DT   = GETDATE()
									FROM   EXCH_SEG_MSTR       EXCSM
									WHERE  EXCSM_EXCH_CD     = EXCM_CD
									AND    EXCSM_ID          = CONVERT(INT,@CURRSTRING) 
									AND    EXCM_DELETED_IND  = 1
									AND    EXCSM_DELETED_IND = 1
         
         
         UPDATE EXCH_SEG_MSTR      WITH(ROWLOCK)  
         SET    EXCSM_COMPM_ID   = @PA_COMPM_ID  
              , EXCSM_EXCH_CD    = @PA_EXCH_CD  
              , EXCSM_SEG_CD     = @PA_SEG_CD  
              , EXCSM_SUB_SEG_CD = @PA_SUB_SEG_CD  
              , EXCSM_DESC       = @PA_DESC  
              , EXCSM_PARENT_ID  = @PA_PARENT_ID  
              , EXCSM_RMKS       = @PA_EXCSM_RMKS  
              , EXCSM_LST_UPD_BY = @PA_LOGIN_NAME  
              , EXCSM_LST_UPD_DT = GETDATE()
              , EXCSM_BIT        = @L_BUSM_BIT
         WHERE  EXCSM_ID         = CONVERT(INT,@CURRSTRING)  
  
         IF @PA_DESC <> @L_BITRM_CHILD_CD  
         --  
         BEGIN  
         --  
           UPDATE BITMAP_REF_MSTR  WITH (ROWLOCK)  
           SET    BITRM_CHILD_CD   = @PA_DESC  
                , BITRM_LST_UPD_BY = @PA_LOGIN_NAME  
                , BITRM_LST_UPD_DT = GETDATE()  
           WHERE  BITRM_PARENT_CD  = 'ACCESS1'  
           AND    BITRM_CHILD_CD   = @L_BITRM_CHILD_CD  
           
           
           
         --  
         END
         
        	
         --  
         SET @L_ERROR = @@ERROR  
         --  
         IF @L_ERROR > 0  
         BEGIN  
         --  
           ROLLBACK TRANSACTION  
           --  
           SET @T_ERRORSTR=@T_ERRORSTR+@CURRSTRING+@COLDELIMITER+@PA_EXCH_CD+@COLDELIMITER+@PA_SEG_CD+@COLDELIMITER+@PA_SUB_SEG_CD+@COLDELIMITER+@PA_DESC+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,@PA_PARENT_ID),0)+@COLDELIMITER+CONVERT(VARCHAR,@PA_COMPM_ID)+@COLDELIMITER+ISNULL(@PA_EXCSM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
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
  
       IF @PA_CHK_YN = 1 -- IF MAKER OR CHEKER IS EDITING  
       BEGIN  
       --  
         BEGIN TRANSACTION  
         --
									SELECT @L_EXCM_CD         = EXCSM_EXCH_CD
									FROM   EXCH_SEG_MSTR_MAK    
									WHERE  EXCSM_ID           = CONVERT(INT,@CURRSTRING)  
									AND    EXCSM_DELETED_IND  = 0  
         
         UPDATE EXCH_SEG_MSTR_MAK    WITH(ROWLOCK)  
         SET    EXCSM_DELETED_IND  = 2  
               ,EXCSM_LST_UPD_BY   = @PA_LOGIN_NAME  
               ,EXCSM_LST_UPD_DT   = GETDATE()  
         WHERE  EXCSM_ID           = CONVERT(INT,@CURRSTRING)  
         AND    EXCSM_DELETED_IND  = 0  
         
         SELECT @L_EXCM_ID  = EXCM_ID 
									FROM   EXCH_SEG_MSTR_MAK   						
									     , EXCM_MAK
									WHERE  EXCSM_ID           = CONVERT(INT,@CURRSTRING)  
									AND    EXCM_CD            = EXCSM_EXCH_CD
         AND    EXCM_DELETED_IND   = 0
         
         IF ISNULL(CONVERT(VARCHAR,@L_EXCM_ID),'') = ''
         BEGIN
         --
           SELECT @L_EXCM_ID  = EXCM_ID 
											FROM   EXCH_SEG_MSTR   						
																, EXCM_MAK
											WHERE  EXCSM_ID           = CONVERT(INT,@CURRSTRING)  
											AND    EXCM_CD            = EXCSM_EXCH_CD
           AND    EXCM_DELETED_IND   = 1
         --
         END
         IF ISNULL(CONVERT(VARCHAR,@L_EXCM_ID),'') = ''
									BEGIN
         --
           SELECT @L_EXCM_ID = ISNULL(MAX(EXCM_ID),0)+1  
											FROM EXCM_MAK WITH(NOLOCK) 
         --
         END
         
         IF NOT EXISTS(SELECT * FROM EXCH_SEG_MSTR_MAK WHERE EXCSM_EXCH_CD = @L_EXCM_CD AND EXCSM_DELETED_IND = 0)
         BEGIN
         --
											UPDATE EXCM_MAK    WITH(ROWLOCK)  
											SET    EXCM_DELETED_IND  = 2  
																	,EXCM_LST_UPD_BY   = @PA_LOGIN_NAME  
																	,EXCM_LST_UPD_DT   = GETDATE()  
											WHERE  EXCM_ID           = @L_EXCM_ID
											AND    EXCM_DELETED_IND  = 0
									--
									END
         --  
         SET @L_ERROR = @@ERROR  
         --  
         IF @L_ERROR > 0  
         BEGIN  
         --  
           SET @T_ERRORSTR=ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(@PA_EXCH_CD,'')+@COLDELIMITER+ISNULL(@PA_SEG_CD,'')+@COLDELIMITER+ISNULL(@PA_SUB_SEG_CD,'')+@COLDELIMITER+ISNULL(@PA_DESC,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,@PA_PARENT_ID),0)+@COLDELIMITER+CONVERT(VARCHAR,@PA_COMPM_ID)+@COLDELIMITER+ISNULL(@PA_EXCSM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
           --  
           ROLLBACK TRANSACTION  
         --  
         END  
         ELSE  
         BEGIN  
         --  
           INSERT INTO EXCH_SEG_MSTR_MAK  
           (EXCSM_ID  
           ,EXCSM_COMPM_ID  
           ,EXCSM_EXCH_CD  
           ,EXCSM_SEG_CD  
           ,EXCSM_SUB_SEG_CD  
           ,EXCSM_DESC  
           ,EXCSM_PARENT_ID  
           ,EXCSM_RMKS  
           ,EXCSM_CREATED_BY  
           ,EXCSM_CREATED_DT  
           ,EXCSM_LST_UPD_BY  
           ,EXCSM_LST_UPD_DT  
           ,EXCSM_DELETED_IND 
           ,EXCSM_BIT
           )  
           VALUES  
           (CONVERT(INT,@CURRSTRING)  
           ,@PA_COMPM_ID  
           ,@PA_EXCH_CD  
           ,@PA_SEG_CD  
           ,REPLACE(@PA_SUB_SEG_CD, ' ', @PA_SEG_CD)  
           ,@PA_DESC  
           ,@PA_PARENT_ID  
           ,@PA_EXCSM_RMKS  
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
             SET @T_ERRORSTR=ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(@PA_EXCH_CD,'')+@COLDELIMITER+ISNULL(@PA_SEG_CD,'')+@COLDELIMITER+ISNULL(@PA_SUB_SEG_CD,'')+@COLDELIMITER+ISNULL(@PA_DESC,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,@PA_PARENT_ID),0)+@COLDELIMITER+CONVERT(VARCHAR,@PA_COMPM_ID)+@COLDELIMITER+ISNULL(@PA_EXCSM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
             --  
             ROLLBACK TRANSACTION  
           --  
           END  
           ELSE  
           BEGIN  
           --  
             
             INSERT INTO EXCM_MAK
													(EXCM_ID
													,EXCM_CD
													,EXCM_SHORT_NAME
													,EXCM_DESC
													,EXCM_RMKS
													,EXCM_CREATED_BY
													,EXCM_CREATED_DT
													,EXCM_LST_UPD_BY
													,EXCM_LST_UPD_DT
													,EXCM_DELETED_IND
													)
													VALUES
													(@L_EXCM_ID
													,@PA_EXCH_CD
													,@PA_EXCH_SHORT_NAME
													,@PA_EXCH_DESC
													,''
													,@PA_LOGIN_NAME
													,GETDATE()
													,@PA_LOGIN_NAME
													,GETDATE()
													,0
             )
             SET @L_ERROR = @@ERROR  
													--  
													IF @L_ERROR > 0  
													BEGIN  
													--  
															SET @T_ERRORSTR=ISNULL(@T_ERRORSTR,'')+@CURRSTRING+@COLDELIMITER+ISNULL(@PA_EXCH_CD,'')+@COLDELIMITER+ISNULL(@PA_SEG_CD,'')+@COLDELIMITER+ISNULL(@PA_SUB_SEG_CD,'')+@COLDELIMITER+ISNULL(@PA_DESC,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,@PA_PARENT_ID),0)+@COLDELIMITER+CONVERT(VARCHAR,@PA_COMPM_ID)+@COLDELIMITER+ISNULL(@PA_EXCSM_RMKS,'')+@COLDELIMITER+CONVERT(VARCHAR,@L_ERROR)+@ROWDELIMITER  
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
       --  
     END  --ACTION TYPE = EDT ENDS HERE  
    --  
    END  
    -- 
    SET @PA_ERRMSG = @T_ERRORSTR  
    --  
  END  
  --  
END

GO
