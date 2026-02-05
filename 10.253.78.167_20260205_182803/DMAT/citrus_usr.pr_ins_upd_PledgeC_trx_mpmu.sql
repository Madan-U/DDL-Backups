-- Object: PROCEDURE citrus_usr.pr_ins_upd_PledgeC_trx_mpmu
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------







--	0	INS	VISHAL	12345678	CRTE	PLEDGE	1234567890123456	PL9	07/02/2009	12	11	07/02/2009	HAND DELIVERY	5	CASH			0	CRTE	REM	*|~*	|*~|	
    
/* 

ALTER TABLE CMPLEDGED_MAK   ADD PLDTCM_CLOSURE_BY  VARCHAR(25)
ALTER TABLE CMPLEDGED_MAK   ADD PLDTCM_SECURITTIES VARCHAR(25)

ALTER TABLE CDSL_MARGINPLEDGE_DTLS   ADD PLDTCM_CLOSURE_BY  VARCHAR(25)
ALTER TABLE CDSL_MARGINPLEDGE_DTLS   ADD PLDTCM_SECURITTIES VARCHAR(25)

PLDTCM_ID BIGINT
,PLDTCM_DTLS_ID BIGINT
,PLDTCM_DPM_ID  BIGINT
,PLDTCM_DPAM_ID NUMERIC(10,0)
,PLDTCM_REQUEST_DT DATETIME
,PLDTCM_EXEC_DT DATETIME
,PLDTCM_SLIP_NO VARCHAR(25)
,PLDTCM_ISIN    VARCHAR(50)
,PLDTCM_QTY     NUMERIC(18,3)
,PLDTCM_TRASTM_CD VARCHAR(50)
,PLDTCM_AGREEMENT_NO VARCHAR(20)
,PLDTCM_SETUP_DT DATETIME
,PLDTCM_EXPIRY_DT DATETIME
,PLDTCM_PLDG_DPID VARCHAR(25)
,PLDTCM_PLDG_DPNAME VARCHAR(100)
,PLDTCM_PLDG_CLIENTID VARCHAR(16)
,PLDTCM_PLDG_CLIENTNAME VARCHAR(100)
,PLDTCM_REASON   VARCHAR(50)
,PLDTCM_PSN      VARCHAR(25)	
,PLDTCM_TRANS_NO VARCHAR(50)
,PLDTCM_BATCH_NO VARCHAR(25)
,PLDTCM_BROKER_BATCH_NO VARCHAR(25)
,PLDTCM_BROKER_REF_NO   VARCHAR(25)
,PLDTCM_STATUS          VARCHAR(10)
,PLDTCM_CREATED_BY      VARCHAR(25)
,PLDTCM_CREATED_DATE    DATETIME
,PLDTCM_UPDATED_BY      VARCHAR(25)
,PLDTCM_UPDATED_DATE    DATETIME 
,PLDTCM_DELETED_IND     SMALLINT 
,PLDTCM_RMKS            VARCHAR(250)
    
*/  

create PROCEDURE [citrus_usr].[pr_ins_upd_PledgeC_trx_mpmu]
             (@PA_ID              VARCHAR(8000)      
             ,@PA_ACTION          VARCHAR(20)      
             ,@PA_LOGIN_NAME      VARCHAR(20)      
             ,@PA_DPM_DPID        VARCHAR(50)    
             ,@PA_DPAM_ACCT_NO    VARCHAR(50)    
             ,@PA_SLIP_NO         VARCHAR(20)     
             ,@PA_REQ_DT          VARCHAR(11)    
             ,@PA_EXE_DT          VARCHAR(11)    
             ,@PA_SETUP_DT        VARCHAR(11)    
             ,@PA_EXPIRE_DT       VARCHAR(11)               
             ,@PA_AGREE_NO        VARCHAR(50)    
             ,@PA_PLEDGEE_DPID    VARCHAR(20)    
             ,@PA_PLEDGEE_ACCTNO  VARCHAR(20)    
             ,@PA_PLEDGEE_DEMAT_NAME  VARCHAR(100)    
             ,@PA_PLDTCM_CLOSURE_BY  VARCHAR(25)
             ,@PA_PLDTCM_SECURITTIES VARCHAR(25)
             ,@PA_PLDTCM_SUB_STATUS VARCHAR(10)
             ,@PA_VALUES          VARCHAR(8000)    
             ,@PA_DESC            VARCHAR(500)  
             ,@PA_RMKS            VARCHAR(250)   
			 ,@PA_UCC VARCHAR(20)
			 ,@PA_EXID VARCHAR(5)
			 ,@PA_SEGID VARCHAR(5)
			 ,@PA_CMID VARCHAR(20)
			 ,@PA_EID CHAR(2)
			 ,@PA_TMCMID VARCHAR(20)

             ,@PA_CHK_YN          INT                   
             ,@ROWDELIMITER       CHAR(4)       = '*|~*'      
             ,@COLDELIMITER       CHAR(4)       = '|*~|'      
             ,@PA_ERRMSG          VARCHAR(8000) OUTPUT      
)      
AS    
/*    
*********************************************************************************    
 SYSTEM         : DP    
 MODULE NAME    : PR_INS_UPD_ONMC2P_TRX    
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE MAKER CHECKER FACILITY FOR TRANSACTION DETAILS    
 COPYRIGHT(C)   : MARKETPLACE TECHNOLOGIES     
 VERSION HISTORY: 1.0    
 VERS.  AUTHOR            DATE          REASON    
 -----  -------------     ------------  --------------------------------------------------    
 1.0    TUSHAR            05-DEC-2007   VERSION.    
-----------------------------------------------------------------------------------*/    
BEGIN    
--    
DECLARE @T_ERRORSTR      VARCHAR(8000)    
      , @L_ERROR         BIGINT    
      , @DELIMETER       VARCHAR(10)    
      , @REMAININGSTRING VARCHAR(8000)    
      , @CURRSTRING      VARCHAR(8000)    
      , @FOUNDAT         INTEGER    
      , @DELIMETERLENGTH INT    
      , @L_PLDT_ID      NUMERIC    
      , @L_DPTDM_ID     NUMERIC    
      , @DELIMETER_VALUE VARCHAR(10)    
      , @DELIMETERLENGTH_VALUE VARCHAR(10)    
      , @REMAININGSTRING_VALUE VARCHAR(8000)    
      , @CURRSTRING_VALUE VARCHAR(8000)    
      , @L_ACCESS1      INT    
      , @L_ACCESS       INT    
      , @L_EXCM_ID      NUMERIC    
      , @L_EXCM_CD      VARCHAR(500)    
      , @L_DPM_ID       NUMERIC    
      , @L_DELETED_IND  SMALLINT    
      , @L_DPAM_ID      NUMERIC    
      , @LINE_NO        NUMERIC    
      , @L_TR_DPID      VARCHAR(25)     
      , @L_TR_SETT_TYPE VARCHAR(50)    
      , @L_TR_SETM_NO   VARCHAR(50)    
      , @L_ISIN         VARCHAR(25)     
      , @L_QTY          VARCHAR(25)    
      , @L_VALUE		VARCHAR(25)
      , @L_ORG_QTY      VARCHAR(25)    
      , @L_TRASTM_ID    VARCHAR(25)    
      , @L_ACTION       VARCHAR(25)    
      , @L_DTLS_ID      NUMERIC    
      , @L_DTLSM_ID     NUMERIC    
	  , @L_ID			VARCHAR(20)    
      , @@C_ACCESS_CURSOR CURSOR    
      , @C_DELETED_IND    VARCHAR(20)    
      , @C_PLDT_ID        VARCHAR(20)    
      , @L_TRASTM_DESC    VARCHAR(20)    
      , @L_MAX_HIGH_VAL   NUMERIC(18,5)    
      , @L_HIGH_VAL_YN     CHAR(1)      
      , @L_VAL_YN     CHAR(1)      
,@L_REL_DT VARCHAR(11)    
,@L_REL_RSN VARCHAR(20)    
,@L_REJ_RSN VARCHAR(20)   
,@L_SEQ_NO   VARCHAR(20)  
  
  
SET @L_TRASTM_ID = @PA_DESC  
  
  
                     
SET @L_VAL_YN  = CITRUS_USR.FN_GET_HIGH_VAL('',0,'DORMANT',@PA_DPAM_ACCT_NO,CONVERT(DATETIME,@PA_REQ_DT,103))        
          
IF @PA_ACTION <> 'APP'  AND @PA_ACTION <> 'REJ'           
BEGIN    
--    
  CREATE TABLE #CMPLEDGED_MAK    
  (PLDTCM_ID BIGINT
	,PLDTCM_DTLS_ID BIGINT
	,PLDTCM_DPM_ID  BIGINT
	,PLDTCM_DPAM_ID NUMERIC(10,0)
	,PLDTCM_REQUEST_DT DATETIME
	,PLDTCM_EXEC_DT DATETIME
	,PLDTCM_SLIP_NO VARCHAR(25)
	,PLDTCM_ISIN    VARCHAR(50)
	,PLDTCM_QTY     NUMERIC(18,3)
	,PLDTCM_TRASTM_CD VARCHAR(50)
	,PLDTCM_AGREEMENT_NO VARCHAR(20)
	,PLDTCM_SETUP_DT DATETIME
	,PLDTCM_EXPIRY_DT DATETIME
	,PLDTCM_PLDG_DPID VARCHAR(25)
	,PLDTCM_PLDG_DPNAME VARCHAR(100)
	,PLDTCM_PLDG_CLIENTID VARCHAR(16)
	,PLDTCM_PLDG_CLIENTNAME VARCHAR(100)
	,PLDTCM_REASON   VARCHAR(50)
	,PLDTCM_PSN      VARCHAR(25)	
	,PLDTCM_TRANS_NO VARCHAR(50)
	,PLDTCM_BATCH_NO VARCHAR(25)
	,PLDTCM_BROKER_BATCH_NO VARCHAR(25)
	,PLDTCM_BROKER_REF_NO   VARCHAR(25)
	,PLDTCM_STATUS          VARCHAR(10)
	,PLDTCM_CREATED_BY      VARCHAR(25)
	,PLDTCM_CREATED_DATE    DATETIME
	,PLDTCM_UPDATED_BY      VARCHAR(25)
	,PLDTCM_UPDATED_DATE    DATETIME 
	,PLDTCM_DELETED_IND     SMALLINT
	,PLDTCM_RMKS            VARCHAR(250)
    ,PLDTCM_CLOSURE_BY  VARCHAR(25)
    ,PLDTCM_SECURITTIES VARCHAR(25)
    ,PLDTCM_SUB_STATUS VARCHAR(25)
	,PLDTCM_VALUE NUMERIC(18,3)
,PLDTCM_UCC	varchar(20)
,PLDTCM_EXID	varchar(5)
,PLDTCM_SEGID	varchar(5)
,PLDTCM_CMID	varchar(20)
,PLDTCM_EID	char(2)
,PLDTCM_TMCMID	varchar(20)
  )    
  INSERT INTO #CMPLEDGED_MAK    
  (PLDTCM_ID 
	,PLDTCM_DTLS_ID 
	,PLDTCM_DPM_ID  
	,PLDTCM_DPAM_ID 
	,PLDTCM_REQUEST_DT 
	,PLDTCM_EXEC_DT 
	,PLDTCM_SLIP_NO 
	,PLDTCM_ISIN    
	,PLDTCM_QTY     
	,PLDTCM_TRASTM_CD 
	,PLDTCM_AGREEMENT_NO 
	,PLDTCM_SETUP_DT 
	,PLDTCM_EXPIRY_DT
	,PLDTCM_PLDG_DPID 
	,PLDTCM_PLDG_DPNAME 
	,PLDTCM_PLDG_CLIENTID
	,PLDTCM_PLDG_CLIENTNAME 
	,PLDTCM_REASON   
	,PLDTCM_PSN      
	,PLDTCM_TRANS_NO 
	,PLDTCM_BATCH_NO 
	,PLDTCM_BROKER_BATCH_NO 
	,PLDTCM_BROKER_REF_NO   
	,PLDTCM_STATUS          
	,PLDTCM_CREATED_BY      
	,PLDTCM_CREATED_DATE    
	,PLDTCM_UPDATED_BY      
	,PLDTCM_UPDATED_DATE    
	,PLDTCM_DELETED_IND     
	,PLDTCM_RMKS   
    ,PLDTCM_CLOSURE_BY  
    ,PLDTCM_SECURITTIES 
    ,PLDTCM_SUB_STATUS
	,PLDTCM_VALUE 
	,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID
   )    
  SELECT PLDTCM_ID 
	,PLDTCM_DTLS_ID 
	,PLDTCM_DPM_ID  
	,PLDTCM_DPAM_ID 
	,PLDTCM_REQUEST_DT 
	,PLDTCM_EXEC_DT 
	,PLDTCM_SLIP_NO 
	,PLDTCM_ISIN    
	,PLDTCM_QTY     
	,PLDTCM_TRASTM_CD 
	,PLDTCM_AGREEMENT_NO 
	,PLDTCM_SETUP_DT 
	,PLDTCM_EXPIRY_DT
	,PLDTCM_PLDG_DPID 
	,PLDTCM_PLDG_DPNAME 
	,PLDTCM_PLDG_CLIENTID
	,PLDTCM_PLDG_CLIENTNAME 
	,PLDTCM_REASON   
	,PLDTCM_PSN      
	,PLDTCM_TRANS_NO 
	,PLDTCM_BATCH_NO 
	,PLDTCM_BROKER_BATCH_NO 
	,PLDTCM_BROKER_REF_NO   
	,PLDTCM_STATUS          
	,PLDTCM_CREATED_BY      
	,PLDTCM_CREATED_DATE    
	,PLDTCM_UPDATED_BY      
	,PLDTCM_UPDATED_DATE    
	,PLDTCM_DELETED_IND     
	,PLDTCM_RMKS 
    ,PLDTCM_CLOSURE_BY  
    ,PLDTCM_SECURITTIES 
    ,PLDTCM_SUB_STATUS 
	,PLDTCM_VALUE
		,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID

  FROM CMPLEDGED_MAK     
  WHERE PLDTCM_DTLS_ID = @PA_ID    
--    
END    
IF @PA_ACTION = 'INS'     OR @PA_ACTION = 'EDT' 
BEGIN    
--    
      
  /*SELECT @L_DTLS_ID   = ISNULL(MAX(PLDT_DTLS_ID),0) + 1 FROM NSDL_PLEDGE_DTLS      
                    
  SELECT @L_DTLSM_ID   = ISNULL(MAX(PLDT_DTLS_ID),0) + 1 FROM NPLEDGED_MAK    
      
  IF @L_DTLSM_ID  > @L_DTLS_ID       
  BEGIN    
  --    
    SET @L_DTLS_ID = @L_DTLSM_ID       
  --    
  END    
      
  IF @PA_CHK_YN = 0    
  BEGIN    
  --    
    SELECT @L_DTLS_ID = ISNULL(MAX(PLDT_DTLS_ID),0) + 1 FROM  NSDL_PLEDGE_DTLS     
  --    
  END*/   

  DECLARE  @L_COUNT_ROW BIGINT
  SET   @L_COUNT_ROW  = CITRUS_USR.UFN_COUNTSTRING(@PA_VALUES,'*|~*')    
  BEGIN TRANSACTION    
        
    UPDATE BITMAP_REF_MSTR WITH(TABLOCK)    
    SET    BITRM_DELETED_IND = 1     
    WHERE  BITRM_ID = 1     
    AND    BITRM_DELETED_IND = 1     
        
      IF @PA_ACTION = 'INS'    
      BEGIN   
      SELECT @L_DTLS_ID = BITRM_BIT_LOCATION     
      FROM  BITMAP_REF_MSTR     
      WHERE BITRM_PARENT_CD = 'PLDTCM_DTLS_ID'    
        
      UPDATE BITMAP_REF_MSTR WITH(TABLOCK)    
      SET    BITRM_BIT_LOCATION  = BITRM_BIT_LOCATION  + 1     
      WHERE BITRM_PARENT_CD = 'PLDTCM_DTLS_ID'    
      END  
        
      SELECT @L_PLDT_ID = BITRM_BIT_LOCATION     
      FROM  BITMAP_REF_MSTR     
      WHERE BITRM_PARENT_CD = 'PLDTCM_ID'    
        
      UPDATE BITMAP_REF_MSTR WITH(TABLOCK)    
      SET    BITRM_BIT_LOCATION  = BITRM_BIT_LOCATION  + @L_COUNT_ROW     
      WHERE BITRM_PARENT_CD = 'PLDTCM_ID'    
        
        SET @L_COUNT_ROW = 0
        
   COMMIT TRANSACTION    
       
--    
END    
IF @PA_ACTION = 'EDT'     
BEGIN    
--    
  IF @PA_CHK_YN = 0    
  BEGIN    
  --    
    SELECT @L_DTLS_ID = PLDTCM_DTLS_ID FROM  CDSL_MARGINPLEDGE_DTLS WHERE PLDTCM_DTLS_ID = CONVERT(NUMERIC,@PA_ID) AND PLDTCM_TRASTM_CD = @L_TRASTM_ID    
  --    
  END    
  ELSE    
  BEGIN    
  --    
    SELECT @L_DTLS_ID = PLDTCM_DTLS_ID FROM  CMPLEDGED_MAK WHERE PLDTCM_DTLS_ID = CONVERT(NUMERIC,@PA_ID) AND PLDTCM_TRASTM_CD = @L_TRASTM_ID    
  --    
  END    
--     
END    
    
    
DECLARE @L_STR1 VARCHAR(8000)    
,@L_STR2 VARCHAR(500)    
,@L_COUNTER INT    
,@L_MAX_COUNTER INT    
CREATE TABLE #TEMP_ID (ID INT)    
    
--CHANGED FOR MAKER MASTER EDIT    
IF @PA_ACTION = 'EDT' AND @PA_VALUES <> '0' AND @PA_CHK_YN = 1 AND EXISTS(SELECT PLDTCM_ID FROM CDSL_MARGINPLEDGE_DTLS WHERE PLDTCM_DTLS_ID = @PA_ID AND PLDTCM_DELETED_IND = 1)    
BEGIN     
--  
PRINT 'DDDD'  
  SET @L_COUNTER = 1    
  SET @L_STR1 = @PA_VALUES    
  SET @L_MAX_COUNTER = CITRUS_USR.UFN_COUNTSTRING(@L_STR1,'*|~*')    
  WHILE @L_COUNTER  <= @L_MAX_COUNTER    
  BEGIN    
  --     
    SELECT @L_STR2 = CITRUS_USR.FN_SPLITVAL_ROW(@L_STR1,@L_COUNTER)    
    INSERT INTO #TEMP_ID VALUES(CASE WHEN CITRUS_USR.FN_SPLITVAL(@L_STR2,1) = 'D' THEN   CITRUS_USR.FN_SPLITVAL(@L_STR2,2) ELSE CITRUS_USR.FN_SPLITVAL(@L_STR2,6) END)    
        
    SET @L_COUNTER   = @L_COUNTER   + 1    
  --      
  END    
      
  INSERT INTO CMPLEDGED_MAK        
  (PLDTCM_ID 
	,PLDTCM_DTLS_ID 
	,PLDTCM_DPM_ID  
	,PLDTCM_DPAM_ID 
	,PLDTCM_REQUEST_DT 
	,PLDTCM_EXEC_DT 
	,PLDTCM_SLIP_NO 
	,PLDTCM_ISIN    
	,PLDTCM_QTY     
	,PLDTCM_TRASTM_CD 
	,PLDTCM_AGREEMENT_NO 
	,PLDTCM_SETUP_DT 
	,PLDTCM_EXPIRY_DT
	,PLDTCM_PLDG_DPID 
	,PLDTCM_PLDG_DPNAME 
	,PLDTCM_PLDG_CLIENTID
	,PLDTCM_PLDG_CLIENTNAME 
	,PLDTCM_REASON   
	,PLDTCM_PSN      
	,PLDTCM_TRANS_NO 
	,PLDTCM_BATCH_NO 
	,PLDTCM_BROKER_BATCH_NO 
	,PLDTCM_BROKER_REF_NO   
	,PLDTCM_STATUS          
	,PLDTCM_CREATED_BY      
	,PLDTCM_CREATED_DATE    
	,PLDTCM_UPDATED_BY      
	,PLDTCM_UPDATED_DATE    
	,PLDTCM_DELETED_IND     
	,PLDTCM_RMKS 
    ,PLDTCM_CLOSURE_BY  
    ,PLDTCM_SECURITTIES 
    ,PLDTCM_SUB_STATUS
	,PLDTCM_VALUE 
		,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID

  )         
  SELECT PLDTCM_ID 
	,PLDTCM_DTLS_ID 
	,PLDTCM_DPM_ID  
	,PLDTCM_DPAM_ID 
	,CONVERT(DATETIME,@PA_REQ_DT,103) 
	,CONVERT(DATETIME,@PA_EXE_DT,103)  
	,@PA_SLIP_NO 
	,PLDTCM_ISIN    
	,PLDTCM_QTY     
	,PLDTCM_TRASTM_CD 
	,@PA_AGREE_NO 
	,CONVERT(DATETIME,@PA_SETUP_DT,103) 
	,CONVERT(DATETIME,@PA_EXPIRE_DT,103)
	,@PA_PLEDGEE_DPID 
	,PLDTCM_PLDG_DPNAME
	,@PA_PLEDGEE_ACCTNO
	,@PA_PLEDGEE_DEMAT_NAME 
	,PLDTCM_REASON   
	,PLDTCM_PSN      
	,PLDTCM_TRANS_NO 
	,PLDTCM_BATCH_NO 
	,PLDTCM_BROKER_BATCH_NO 
	,PLDTCM_BROKER_REF_NO   
	,'P'          
	,PLDTCM_CREATED_BY      
	,PLDTCM_CREATED_DATE    
	,PLDTCM_UPDATED_BY      
	,PLDTCM_UPDATED_DATE    
	,'6'     
	,PLDTCM_RMKS 
    ,@PA_PLDTCM_CLOSURE_BY  
    ,@PA_PLDTCM_SECURITTIES 
    ,@PA_PLDTCM_SUB_STATUS
	,PLDTCM_VALUE 
		,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID

  FROM  CDSL_MARGINPLEDGE_DTLS        
  WHERE PLDTCM_ID       NOT IN (SELECT ID FROM #TEMP_ID)    
  AND   PLDTCM_DTLS_ID  = @PA_ID    
  AND   PLDTCM_DELETED_IND   =  1     
      
      
--    
END    
ELSE IF @PA_ACTION = 'EDT' AND @PA_VALUES <> '0' AND @PA_CHK_YN = 1 AND NOT EXISTS(SELECT PLDTCM_ID FROM CDSL_MARGINPLEDGE_DTLS WHERE PLDTCM_DTLS_ID = @PA_ID AND PLDTCM_DELETED_IND = 1)    
BEGIN    
--    
     
  SET @L_COUNTER = 1    
  SET @L_STR1 = @PA_VALUES    
  SET @L_MAX_COUNTER = CITRUS_USR.UFN_COUNTSTRING(@L_STR1,'*|~*')    
  WHILE @L_COUNTER  <= @L_MAX_COUNTER    
  BEGIN    
  --     
    SELECT @L_STR2 = CITRUS_USR.FN_SPLITVAL_ROW(@L_STR1,@L_COUNTER)    
    INSERT INTO #TEMP_ID VALUES(CASE WHEN CITRUS_USR.FN_SPLITVAL(@L_STR2,1) = 'D' THEN   CITRUS_USR.FN_SPLITVAL(@L_STR2,2) ELSE CITRUS_USR.FN_SPLITVAL(@L_STR2,6) END)    
    
    SET @L_COUNTER   = @L_COUNTER   + 1    
  --      
  END    
       

  DELETE FROM    CMPLEDGED_MAK        
  WHERE PLDTCM_ID       NOT IN (SELECT ID FROM #TEMP_ID)     
  AND   PLDTCM_DTLS_ID  = @PA_ID    
  AND   PLDTCM_DELETED_IND   IN (0,4,6)    
       
  INSERT INTO CMPLEDGED_MAK        
		  (PLDTCM_ID 
			,PLDTCM_DTLS_ID 
			,PLDTCM_DPM_ID  
			,PLDTCM_DPAM_ID 
			,PLDTCM_REQUEST_DT 
			,PLDTCM_EXEC_DT 
			,PLDTCM_SLIP_NO 
			,PLDTCM_ISIN    
			,PLDTCM_QTY     
			,PLDTCM_TRASTM_CD 
			,PLDTCM_AGREEMENT_NO 
			,PLDTCM_SETUP_DT 
			,PLDTCM_EXPIRY_DT
			,PLDTCM_PLDG_DPID 
			,PLDTCM_PLDG_DPNAME 
			,PLDTCM_PLDG_CLIENTID
			,PLDTCM_PLDG_CLIENTNAME 
			,PLDTCM_REASON   
			,PLDTCM_PSN      
			,PLDTCM_TRANS_NO 
			,PLDTCM_BATCH_NO 
			,PLDTCM_BROKER_BATCH_NO 
			,PLDTCM_BROKER_REF_NO   
			,PLDTCM_STATUS          
			,PLDTCM_CREATED_BY      
			,PLDTCM_CREATED_DATE    
			,PLDTCM_UPDATED_BY      
			,PLDTCM_UPDATED_DATE    
			,PLDTCM_DELETED_IND     
			,PLDTCM_RMKS 
			,PLDTCM_CLOSURE_BY  
			,PLDTCM_SECURITTIES 
            ,PLDTCM_SUB_STATUS
			,PLDTCM_VALUE 
				,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID

		  )         
		  SELECT PLDTCM_ID 
			,PLDTCM_DTLS_ID 
			,PLDTCM_DPM_ID  
			,PLDTCM_DPAM_ID 
			,CONVERT(DATETIME,@PA_REQ_DT,103) 
			,CONVERT(DATETIME,@PA_EXE_DT,103)  
			,@PA_SLIP_NO 
			,PLDTCM_ISIN    
			,PLDTCM_QTY     
			,PLDTCM_TRASTM_CD 
			,@PA_AGREE_NO 
				,CONVERT(DATETIME,@PA_SETUP_DT,103) 
	        ,CONVERT(DATETIME,@PA_EXPIRE_DT,103)
			,@PA_PLEDGEE_DPID 
			,PLDTCM_PLDG_DPNAME
			,@PA_PLEDGEE_ACCTNO
			,@PA_PLEDGEE_DEMAT_NAME 
			,PLDTCM_REASON   
			,PLDTCM_PSN      
			,PLDTCM_TRANS_NO 
			,PLDTCM_BATCH_NO 
			,PLDTCM_BROKER_BATCH_NO 
			,PLDTCM_BROKER_REF_NO   
			,'P'          
			,PLDTCM_CREATED_BY      
			,PLDTCM_CREATED_DATE    
			,PLDTCM_UPDATED_BY      
			,PLDTCM_UPDATED_DATE    
			,0     
			,PLDTCM_RMKS 
            ,@PA_PLDTCM_CLOSURE_BY  
			,@PA_PLDTCM_SECURITTIES
            ,@PA_PLDTCM_SUB_STATUS 
			,PLDTCM_VALUE
				,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID

  FROM  #CMPLEDGED_MAK        
  WHERE PLDTCM_ID       NOT IN (SELECT ID FROM #TEMP_ID)    
  AND   PLDTCM_DTLS_ID  = @PA_ID    
  AND   PLDTCM_DELETED_IND   IN (0,4,6)    
--    
END    
    
DECLARE @C_ACCESS_CURSOR CURSOR    
SET @L_EXCM_CD = ''    
SET @L_ACCESS1       = 0     
SET @L_ERROR         = 0    
SET @T_ERRORSTR      = ''    
SET @DELIMETER        = '%'+ @ROWDELIMITER + '%'    
SET @DELIMETERLENGTH = LEN(@ROWDELIMITER)    
SET @REMAININGSTRING = @PA_ID      
    
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
      SET @DELIMETER_VALUE        = '%'+ @ROWDELIMITER + '%'    
      SET @DELIMETERLENGTH_VALUE = LEN(@ROWDELIMITER)    
      SET @REMAININGSTRING_VALUE = @PA_VALUES    
      --    
      WHILE @REMAININGSTRING_VALUE <> ''    
      BEGIN    
      --    
    
        SET @FOUNDAT = 0    
        SET @FOUNDAT = PATINDEX('%'+@DELIMETER_VALUE+'%',@REMAININGSTRING_VALUE)    
        --    
        IF @FOUNDAT > 0    
        BEGIN    
          --    
          SET @CURRSTRING_VALUE      = SUBSTRING(@REMAININGSTRING_VALUE, 0,@FOUNDAT)    
          SET @REMAININGSTRING_VALUE = SUBSTRING(@REMAININGSTRING_VALUE, @FOUNDAT+@DELIMETERLENGTH_VALUE,LEN(@REMAININGSTRING_VALUE)- @FOUNDAT+@DELIMETERLENGTH_VALUE)    
          --    
        END    
        ELSE    
        BEGIN    
          --    
          SET @CURRSTRING_VALUE = @REMAININGSTRING_VALUE    
          SET @REMAININGSTRING_VALUE = ''    
        --    
        END    
        --    
        IF @CURRSTRING_VALUE <> ''    
        BEGIN    
        --    
          SET @LINE_NO = @LINE_NO + 1    
          --TARGET_CLIENT_ID (16 CHARACTERS) + COLDEL + TARGET_SETT_TYPE + COLDEL + TARGET_SETT_NO + COLDEL + ISIN + COLDEL + QTY + COLDEL + ROWDEL    
                      
          SET @L_ACTION             = CITRUS_USR.FN_SPLITVAL(@CURRSTRING_VALUE,1)          
                       
          IF @L_ACTION = 'A' OR @L_ACTION ='E'    
          BEGIN    
          --    
            SET @L_ISIN              = CITRUS_USR.FN_SPLITVAL(@CURRSTRING_VALUE,2)                            
            --SET @L_ORG_QTY           = CITRUS_USR.FN_SPLITVAL(@CURRSTRING_VALUE,3)                            
            SET @L_QTY               = CITRUS_USR.FN_SPLITVAL(@CURRSTRING_VALUE,3)     
            SET @L_REL_RSN           = CITRUS_USR.FN_SPLITVAL(@CURRSTRING_VALUE,4)     
            SET @L_SEQ_NO            = CASE WHEN CITRUS_USR.FN_SPLITVAL(@CURRSTRING_VALUE,5) ='' THEN @L_PLDT_ID + 1 ELSE CITRUS_USR.FN_SPLITVAL(@CURRSTRING_VALUE,5)  END--@L_PLDT_ID + 1
            SET @L_ID                = CITRUS_USR.FN_SPLITVAL(@CURRSTRING_VALUE,6)    
            SET @L_VALUE			 = CITRUS_USR.FN_SPLITVAL(@CURRSTRING_VALUE,7)    
            SET @L_QTY               = CONVERT(VARCHAR(25),CONVERT(NUMERIC(18,5),-1*CONVERT(NUMERIC(18,5),@L_QTY)))    
            SET @L_HIGH_VAL_YN       = CASE WHEN @L_VAL_YN = 'Y' THEN 'Y' ELSE CITRUS_USR.FN_GET_HIGH_VAL(@L_ISIN,ABS(@L_QTY),'HIGH_VALUE','','') END    
            IF @L_VALUE=''
            BEGIN
            SET @L_VALUE='0'
            END            
          --    
          END    
          ELSE    
          BEGIN    
          --    
            SET @L_ID                = CITRUS_USR.FN_SPLITVAL(@CURRSTRING_VALUE,2)     
          --    
          END    

          SELECT @L_DPAM_ID     = DPAM_ID , @L_DPM_ID = DPAM_DPM_ID FROM DP_ACCT_MSTR, DP_MSTR WHERE DPM_DELETED_IND = 1   AND DPM_ID = DPAM_DPM_ID AND DPM_DPID = @PA_DPM_DPID AND DPAM_SBA_NO = @PA_DPAM_ACCT_NO    

              
          IF @PA_CHK_YN = 0    
          BEGIN    
          --    

    
            IF @PA_ACTION = 'INS' OR @L_ACTION = 'A'    
            BEGIN    
            --    
              BEGIN TRANSACTION    
    
              --SELECT @L_PLDT_ID   = ISNULL(MAX(PLDT_ID),0) + 1 FROM NSDL_PLEDGE_DTLS      
                  
              SET @L_PLDT_ID = @L_PLDT_ID + 1    
                  
              INSERT INTO CDSL_MARGINPLEDGE_DTLS    
              (PLDTCM_ID
														,PLDTCM_DTLS_ID
														,PLDTCM_DPM_ID
														,PLDTCM_DPAM_ID
														,PLDTCM_REQUEST_DT
														,PLDTCM_EXEC_DT
														,PLDTCM_SLIP_NO
														,PLDTCM_ISIN
														,PLDTCM_QTY														
														,PLDTCM_TRASTM_CD
														,PLDTCM_AGREEMENT_NO
														,PLDTCM_SETUP_DT
														,PLDTCM_EXPIRY_DT
														,PLDTCM_PLDG_DPID
														,PLDTCM_PLDG_DPNAME
														,PLDTCM_PLDG_CLIENTID
														,PLDTCM_PLDG_CLIENTNAME
														,PLDTCM_REASON
														,PLDTCM_PSN
														,PLDTCM_STATUS
														,PLDTCM_CREATED_BY
														,PLDTCM_CREATED_DATE
														,PLDTCM_UPDATED_BY
														,PLDTCM_UPDATED_DATE
														,PLDTCM_DELETED_IND
														,PLDTCM_RMKS
														,PLDTCM_CLOSURE_BY  
														,PLDTCM_SECURITTIES
														,PLDTCM_SUB_STATUS 
														,PLDTCM_VALUE
															,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID

              )VALUES     
              (@L_PLDT_ID     
              ,@L_DTLS_ID    
              ,@L_DPM_ID    
              ,@L_DPAM_ID    
              ,CONVERT(DATETIME,@PA_REQ_DT,103)    
              ,CONVERT(DATETIME,@PA_EXE_DT,103)    
              ,@PA_SLIP_NO    
              ,@L_ISIN                  
              ,@L_QTY       
              ,@L_TRASTM_ID    
              ,@PA_AGREE_NO    
              ,CONVERT(DATETIME,@PA_SETUP_DT,103) 
	           ,CONVERT(DATETIME,@PA_EXPIRE_DT,103)
              ,@PA_PLEDGEE_DPID 
              ,''
              ,@PA_PLEDGEE_ACCTNO   
              ,@PA_PLEDGEE_DEMAT_NAME 
              ,@L_REL_RSN               
              ,@L_SEQ_NO               
              ,'P'    
              ,@PA_LOGIN_NAME    
              ,GETDATE()    
              ,@PA_LOGIN_NAME    
              ,GETDATE()    
              ,1
              ,@PA_RMKS
             ,@PA_PLDTCM_CLOSURE_BY  
			 ,@PA_PLDTCM_SECURITTIES
             ,@PA_PLDTCM_SUB_STATUS 
             ,@L_VALUE
			 			 ,@PA_UCC 
			 ,@PA_EXID 
			 ,@PA_SEGID 
			 ,@PA_CMID 
			 ,@PA_EID 
			 ,@PA_TMCMID 
              )    
                  
                  
    
              SET @L_ERROR = @@ERROR    
              IF @L_ERROR <> 0    
              BEGIN    
              --    
                IF EXISTS(SELECT ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = @L_ERROR)    
                BEGIN    
                --    
                  SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': '+ ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = CONVERT(VARCHAR,@L_ERROR)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': CAN NOT PROCESS, PLEASE CONTACT YOUR ADMINISTRATOR!'    
                --    
                END    
    
                ROLLBACK TRANSACTION     
              --    
              END    
              ELSE    
              BEGIN    
              --    
                SET @T_ERRORSTR = CONVERT(VARCHAR,@L_DTLS_ID)     
                COMMIT TRANSACTION    
              --    
              END    
    
            --    
            END    
            IF @PA_ACTION = 'EDT' OR @L_ACTION = 'E'    
            BEGIN    
            --    
              BEGIN TRANSACTION    
              PRINT @L_ACTION     
              IF @PA_ACTION = 'EDT'     
              BEGIN    
              --    
                UPDATE CDSL_MARGINPLEDGE_DTLS     
                SET    PLDTCM_DPAM_ID = @L_DPAM_ID    
                      ,PLDTCM_REQUEST_DT = CONVERT(DATETIME,@PA_REQ_DT,103)    
                      ,PLDTCM_EXEC_DT = CONVERT(DATETIME,@PA_EXE_DT,103)    
                      ,PLDTCM_SETUP_DT = CONVERT(DATETIME,@PA_SETUP_DT,103)    
                      ,PLDTCM_EXPIRY_DT = CONVERT(DATETIME,@PA_EXPIRE_DT,103)    
                      ,PLDTCM_SLIP_NO = @PA_SLIP_NO    
                      ,PLDTCM_AGREEMENT_NO = @PA_AGREE_NO    
                      ,PLDTCM_PLDG_DPID = @PA_PLEDGEE_DPID     
                      ,PLDTCM_PLDG_CLIENTID = @PA_PLEDGEE_ACCTNO    
                      ,PLDTCM_UPDATED_BY = @PA_LOGIN_NAME    
                      ,PLDTCM_UPDATED_DATE = GETDATE()    
                      ,PLDTCM_PLDG_CLIENTNAME = @PA_PLEDGEE_DEMAT_NAME  
                      ,PLDTCM_RMKS = @PA_RMKS                      
                      ,PLDTCM_CLOSURE_BY  = @PA_PLDTCM_CLOSURE_BY
			          ,PLDTCM_SECURITTIES = @PA_PLDTCM_SECURITTIES
                      ,PLDTCM_SUB_STATUS = @PA_PLDTCM_SUB_STATUS  
					  ,PLDTCM_VALUE = @L_VALUE
					  	,PLDTCM_UCC=@PA_UCC
	,PLDTCM_EXID=@PA_EXID
	,PLDTCM_SEGID=@PA_SEGID 
	,PLDTCM_CMID=@PA_CMID 
	,PLDTCM_EID=@PA_EID 
	,PLDTCM_TMCMID=@PA_TMCMID

                WHERE  PLDTCM_DTLS_ID    = CONVERT(INT,@CURRSTRING)    
                AND    PLDTCM_DELETED_IND = 1    
              --    
              END    
              IF @L_ACTION = 'E'    
              BEGIN    
              --    
                    
                UPDATE  CDSL_MARGINPLEDGE_DTLS     
                SET     PLDTCM_DPAM_ID = @L_DPAM_ID    
                       ,PLDTCM_REQUEST_DT = CONVERT(DATETIME,@PA_REQ_DT,103)    
                       ,PLDTCM_EXEC_DT = CONVERT(DATETIME,@PA_EXE_DT,103)    
                       ,PLDTCM_SETUP_DT =CONVERT(DATETIME,@PA_SETUP_DT,103)    
                       ,PLDTCM_EXPIRY_DT =CONVERT(DATETIME,@PA_EXPIRE_DT,103)    
                       ,PLDTCM_SLIP_NO = @PA_SLIP_NO    
                       ,PLDTCM_ISIN =@L_ISIN    
                       ,PLDTCM_QTY =@L_QTY    
                       ,PLDTCM_AGREEMENT_NO = @PA_AGREE_NO    
                       ,PLDTCM_PLDG_DPID = @PA_PLEDGEE_DPID     
                       ,PLDTCM_PLDG_CLIENTID = @PA_PLEDGEE_ACCTNO    
                       ,PLDTCM_REASON =@L_REL_RSN    
                       ,PLDTCM_PSN=@L_SEQ_NO   
                       ,PLDTCM_UPDATED_BY = @PA_LOGIN_NAME    
                       ,PLDTCM_UPDATED_DATE = GETDATE()    
                       ,PLDTCM_PLDG_CLIENTNAME = @PA_PLEDGEE_DEMAT_NAME  
                       ,PLDTCM_RMKS = @PA_RMKS
                       ,PLDTCM_VALUE = @L_VALUE 
                      ,PLDTCM_CLOSURE_BY  = @PA_PLDTCM_CLOSURE_BY
			          ,PLDTCM_SECURITTIES = @PA_PLDTCM_SECURITTIES
                      ,PLDTCM_SUB_STATUS  = @PA_PLDTCM_SUB_STATUS 
					  	,PLDTCM_EXID=@PA_EXID
	,PLDTCM_SEGID=@PA_SEGID 
	,PLDTCM_CMID=@PA_CMID 
	,PLDTCM_EID=@PA_EID 
	,PLDTCM_TMCMID=@PA_TMCMID

                WHERE   PLDTCM_ID                   = @L_ID    
                AND     PLDTCM_DELETED_IND          = 1    
              --    
              END    
                  
                  
              SET @L_ERROR = @@ERROR    
              IF @L_ERROR <> 0    
              BEGIN    
              --    
                IF EXISTS(SELECT ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = @L_ERROR)    
                BEGIN    
                --    
                  SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': '+ ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = CONVERT(VARCHAR,@L_ERROR)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': CAN NOT PROCESS, PLEASE CONTACT YOUR ADMINISTRATOR!'    
                --    
                END    
    
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
            IF @PA_ACTION = 'DEL' OR @L_ACTION = 'D'    
            BEGIN    
            --    
              BEGIN TRANSACTION    
    
              IF @PA_ACTION = 'DEL'    
              BEGIN    
              --    
                  
                DELETE USED FROM CDSL_MARGINPLEDGE_DTLS,DP_ACCT_MSTR,USED_SLIP USED WHERE DPAM_ID = PLDTCM_DPAM_ID AND USES_DPAM_ACCT_NO = DPAM_SBA_NO AND PLDTCM_DTLS_ID = CONVERT(BIGINT,@CURRSTRING)                      
                    
                UPDATE CDSL_MARGINPLEDGE_DTLS    
                SET    PLDTCM_DELETED_IND = 0    
                     , PLDTCM_UPDATED_DATE  = GETDATE()    
                     , PLDTCM_UPDATED_BY  = @PA_LOGIN_NAME    
                WHERE  PLDTCM_DELETED_IND = 1    
                AND    PLDTCM_DTLS_ID     = CONVERT(BIGINT,@CURRSTRING)    
                    
                    
                   
                    
              --    
              END    
              IF @L_ACTION = 'D'    
              BEGIN    
              --    
                DELETE USED FROM CDSL_MARGINPLEDGE_DTLS,DP_ACCT_MSTR,USED_SLIP USED WHERE DPAM_ID = PLDTCM_DPAM_ID AND USES_DPAM_ACCT_NO = DPAM_SBA_NO AND PLDTCM_ID          = @L_ID        
                    
                UPDATE CDSL_MARGINPLEDGE_DTLS    
                SET    PLDTCM_DELETED_IND = 0    
                     , PLDTCM_UPDATED_DATE  = GETDATE()    
                     , PLDTCM_UPDATED_BY  = @PA_LOGIN_NAME    
                WHERE  PLDTCM_DELETED_IND = 1    
                AND    PLDTCM_ID          = @L_ID    
                    
                               
              --    
              END    
                   
              SET @L_ERROR = @@ERROR    
              IF @L_ERROR <> 0    
              BEGIN    
              --    
                IF EXISTS(SELECT ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = @L_ERROR)    
                BEGIN    
                --    
                  SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': '+ ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = CONVERT(VARCHAR,@L_ERROR)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': CAN NOT PROCESS, PLEASE CONTACT YOUR ADMINISTRATOR!'    
                --    
                END    
    
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
          ELSE IF @PA_CHK_YN = 1    
          BEGIN    
          --    
            SELECT @L_DPAM_ID     = DPAM_ID FROM DP_ACCT_MSTR, DP_MSTR WHERE DPM_DELETED_IND = 1   AND DPM_ID = DPAM_DPM_ID AND DPM_DPID = @PA_DPM_DPID AND DPAM_SBA_NO = @PA_DPAM_ACCT_NO    
                
            IF @PA_ACTION = 'INS'    
            BEGIN    
            --    
    
              BEGIN TRANSACTION    
           
                  
              /*SELECT @L_PLDT_ID   = ISNULL(MAX(PLDT_ID),0) + 1 FROM NSDL_PLEDGE_DTLS      
                  
              SELECT @L_DPTDM_ID   = ISNULL(MAX(PLDT_ID),0) + 1 FROM NPLEDGED_MAK    
                  
              IF @L_DPTDM_ID   > @L_PLDT_ID       
              BEGIN    
              --    
                SET @L_PLDT_ID = @L_DPTDM_ID       
              --    
              END*/    
                  
              SET @L_PLDT_ID = @L_PLDT_ID + 1    
                  
                                
              INSERT INTO CMPLEDGED_MAK    
              (PLDTCM_ID
														,PLDTCM_DTLS_ID
														,PLDTCM_DPM_ID
														,PLDTCM_DPAM_ID
													 ,PLDTCM_REQUEST_DT
												  ,PLDTCM_EXEC_DT
														,PLDTCM_SLIP_NO
														,PLDTCM_ISIN
														,PLDTCM_QTY
														,PLDTCM_TRASTM_CD
														,PLDTCM_AGREEMENT_NO
														,PLDTCM_SETUP_DT
														,PLDTCM_EXPIRY_DT
														,PLDTCM_PLDG_DPID
														,PLDTCM_PLDG_DPNAME
														,PLDTCM_PLDG_CLIENTID
														,PLDTCM_PLDG_CLIENTNAME
														,PLDTCM_REASON
														,PLDTCM_PSN
														,PLDTCM_STATUS
														,PLDTCM_CREATED_BY
														,PLDTCM_CREATED_DATE
														,PLDTCM_UPDATED_BY
														,PLDTCM_UPDATED_DATE
														,PLDTCM_DELETED_IND
														,PLDTCM_RMKS
														,PLDTCM_CLOSURE_BY  
														,PLDTCM_SECURITTIES
														,PLDTCM_SUB_STATUS 
														,PLDTCM_VALUE
															,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID

              )VALUES     
              (@L_PLDT_ID     
              ,@L_DTLS_ID    
              ,@L_DPM_ID    
              ,@L_DPAM_ID    
              ,CONVERT(DATETIME,@PA_REQ_DT,103)    
              ,CONVERT(DATETIME,@PA_EXE_DT,103)    
              ,@PA_SLIP_NO    
              ,@L_ISIN                  
              ,@L_QTY       
              ,@L_TRASTM_ID    
              ,@PA_AGREE_NO    
              	,CONVERT(DATETIME,@PA_SETUP_DT,103) 
	          ,CONVERT(DATETIME,@PA_EXPIRE_DT,103)
              ,@PA_PLEDGEE_DPID 
              ,'' 
              ,@PA_PLEDGEE_ACCTNO   
              ,@PA_PLEDGEE_DEMAT_NAME
              ,@L_REL_RSN               
              ,@L_SEQ_NO               
              ,'P'    
              ,@PA_LOGIN_NAME    
              ,GETDATE()    
              ,@PA_LOGIN_NAME    
              ,GETDATE()    
              ,CASE WHEN @L_HIGH_VAL_YN = 'Y' THEN -1 ELSE 0 END 
              ,@PA_RMKS
				,@PA_PLDTCM_CLOSURE_BY  
				,@PA_PLDTCM_SECURITTIES
				, @PA_PLDTCM_SUB_STATUS 
				,ISNULL(@L_VALUE ,'0')
							 ,@PA_UCC 
			 ,@PA_EXID 
			 ,@PA_SEGID 
			 ,@PA_CMID 
			 ,@PA_EID 
			 ,@PA_TMCMID 

              )    
                  
    
      
              SET @L_ERROR = @@ERROR    
              IF @L_ERROR <> 0    
              BEGIN    
              --    
                IF EXISTS(SELECT ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = @L_ERROR)    
                BEGIN    
                --    
                  SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': '+ ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = CONVERT(VARCHAR,@L_ERROR)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': CAN NOT PROCESS, PLEASE CONTACT YOUR ADMINISTRATOR!'    
                --    
                END    
    
                ROLLBACK TRANSACTION     
              --    
              END    
              ELSE    
              BEGIN    
              --    
                  
                SET @T_ERRORSTR = CONVERT(VARCHAR,@L_DTLS_ID)     
                    
                COMMIT TRANSACTION    
              --    
              END    
            --    
            END    
            IF @PA_ACTION = 'EDT' OR @L_ACTION ='E'    
            BEGIN    
            --    
    
              BEGIN TRANSACTION    
     
              IF @PA_VALUES = '0'    
              BEGIN    
              --    
                UPDATE CMPLEDGED_MAK     
                SET    PLDTCM_DELETED_IND = 2    
                     , PLDTCM_UPDATED_DATE  = GETDATE()    
                     , PLDTCM_UPDATED_BY  = @PA_LOGIN_NAME    
                WHERE  PLDTCM_DTLS_ID     = CONVERT(INT,@CURRSTRING)    
              --    
              END    
              ELSE    
              BEGIN    
              --    
                IF @L_ID <> '' AND  @L_ACTION <> 'D'    
                BEGIN    
                --    
                  UPDATE CMPLEDGED_MAK     
                  SET    PLDTCM_DELETED_IND = 2    
                       , PLDTCM_UPDATED_DATE  = GETDATE()    
                       , PLDTCM_UPDATED_BY  = @PA_LOGIN_NAME    
                  WHERE  PLDTCM_ID          = @L_ID    
                --    
                END    
              --    
              END    
         
              IF EXISTS(SELECT PLDTCM_ID FROM CDSL_MARGINPLEDGE_DTLS WHERE PLDTCM_ID = @L_ID AND PLDTCM_DELETED_IND = 1)    
              BEGIN    
              --    
                     
                SET @L_DELETED_IND = 6    
    
                IF @PA_VALUES = '0'    
                BEGIN    
                --    
                  INSERT INTO CMPLEDGED_MAK    
                  (PLDTCM_ID
																		,PLDTCM_DTLS_ID
																		,PLDTCM_DPM_ID
																		,PLDTCM_DPAM_ID
																		,PLDTCM_REQUEST_DT
																		,PLDTCM_EXEC_DT
																		,PLDTCM_SLIP_NO
																		,PLDTCM_ISIN
																		,PLDTCM_QTY
																		,PLDTCM_TRASTM_CD
																		,PLDTCM_AGREEMENT_NO
																		,PLDTCM_SETUP_DT
																		,PLDTCM_EXPIRY_DT
																		,PLDTCM_PLDG_DPID
																		,PLDTCM_PLDG_DPNAME
																		,PLDTCM_PLDG_CLIENTID
																		,PLDTCM_PLDG_CLIENTNAME
																		,PLDTCM_REASON
																		,PLDTCM_PSN
																		,PLDTCM_STATUS
																		,PLDTCM_CREATED_BY
																		,PLDTCM_CREATED_DATE
																		,PLDTCM_UPDATED_BY
																		,PLDTCM_UPDATED_DATE
																		,PLDTCM_DELETED_IND
																		,PLDTCM_RMKS
																		,PLDTCM_CLOSURE_BY  
																		,PLDTCM_SECURITTIES
																		,PLDTCM_SUB_STATUS 
																		,PLDTCM_VALUE
																			,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID

																		)    
                  SELECT PLDTCM_ID     
																	,PLDTCM_DTLS_ID    
																	,@L_DPM_ID    
																	,PLDTCM_DPAM_ID  
																	,CONVERT(DATETIME,@PA_REQ_DT,103)    
																	,CONVERT(DATETIME,@PA_EXE_DT,103)    
																	,@PA_SLIP_NO    
																	,PLDTCM_ISIN                 
																	,PLDTCM_QTY       
																	,@L_TRASTM_ID    
																	,@PA_AGREE_NO    
																		,CONVERT(DATETIME,@PA_SETUP_DT,103) 
	                                                                ,CONVERT(DATETIME,@PA_EXPIRE_DT,103)
																	,@PA_PLEDGEE_DPID 
																	,'' 
																	,@PA_PLEDGEE_ACCTNO   
																	,@PA_PLEDGEE_DEMAT_NAME
																	,PLDTCM_REASON               
																	,PLDTCM_PSN             
																	,'P'    
																	,PLDTCM_CREATED_BY    
																	,PLDTCM_CREATED_DATE 
																	,@PA_LOGIN_NAME    
																	,GETDATE()    
																	,@L_DELETED_IND
																	,@PA_RMKS
															,@PA_PLDTCM_CLOSURE_BY  
																		,@PA_PLDTCM_SECURITTIES
															,@PA_PLDTCM_SUB_STATUS
															,PLDTCM_VALUE 
																,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID


                  FROM  CDSL_MARGINPLEDGE_DTLS    
                  WHERE PLDTCM_DTLS_ID       =  CONVERT(INT,@CURRSTRING)    
                  AND   PLDTCM_DELETED_IND   =  1     
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  IF @L_ACTION = 'A'    
                  BEGIN    
                  --    
                    --SELECT @L_ID = ISNULL(MAX(PLDT_ID),0) + 1 FROM NPLEDGED_MAK    
                    SET @L_PLDT_ID = @L_PLDT_ID + 1 
					SET @L_DELETED_IND = CASE WHEN @L_HIGH_VAL_YN = 'Y' THEN -1 ELSE 0 END                                
                  --    
                  END    
                  IF @L_ACTION <> 'D'    
                  BEGIN    
                  --    
							INSERT INTO CMPLEDGED_MAK    
							(PLDTCM_ID
							,PLDTCM_DTLS_ID
							,PLDTCM_DPM_ID
							,PLDTCM_DPAM_ID
							,PLDTCM_REQUEST_DT
							,PLDTCM_EXEC_DT
							,PLDTCM_SLIP_NO
							,PLDTCM_ISIN
							,PLDTCM_QTY
							,PLDTCM_TRASTM_CD
							,PLDTCM_AGREEMENT_NO
							,PLDTCM_SETUP_DT
							,PLDTCM_EXPIRY_DT
							,PLDTCM_PLDG_DPID
							,PLDTCM_PLDG_DPNAME
							,PLDTCM_PLDG_CLIENTID
							,PLDTCM_PLDG_CLIENTNAME
							,PLDTCM_REASON
							,PLDTCM_PSN
							,PLDTCM_STATUS
							,PLDTCM_CREATED_BY
							,PLDTCM_CREATED_DATE
							,PLDTCM_UPDATED_BY
							,PLDTCM_UPDATED_DATE
							,PLDTCM_DELETED_IND
							,PLDTCM_RMKS
							,PLDTCM_CLOSURE_BY  
							,PLDTCM_SECURITTIES
							,PLDTCM_SUB_STATUS 
							,PLDTCM_VALUE
								,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID

							)VALUES     
							(@L_PLDT_ID     
							,@L_DTLS_ID    
							,@L_DPM_ID    
							,@L_DPAM_ID    
							,CONVERT(DATETIME,@PA_REQ_DT,103)    
							,CONVERT(DATETIME,@PA_EXE_DT,103)    
							,@PA_SLIP_NO    
							,@L_ISIN                  
							,@L_QTY       
							,@L_TRASTM_ID    
							,@PA_AGREE_NO    
							,CONVERT(DATETIME,@PA_SETUP_DT,103) 
							,CONVERT(DATETIME,@PA_EXPIRE_DT,103)
							,@PA_PLEDGEE_DPID 
							,'' 
							,@PA_PLEDGEE_ACCTNO   
							,@PA_PLEDGEE_DEMAT_NAME
							,@L_REL_RSN               
							,@L_SEQ_NO               
							,'P'    
							,@PA_LOGIN_NAME    
							,GETDATE()    
							,@PA_LOGIN_NAME    
							,GETDATE()    
							,@L_DELETED_IND
							,@PA_RMKS
							,@PA_PLDTCM_CLOSURE_BY  
							,@PA_PLDTCM_SECURITTIES
							,@PA_PLDTCM_SUB_STATUS 
							,@L_VALUE 
										 ,@PA_UCC 
			 ,@PA_EXID 
			 ,@PA_SEGID 
			 ,@PA_CMID 
			 ,@PA_EID 
			 ,@PA_TMCMID 

							)    
                  --    
                  END    
                --    
                END    
              --    
              END    
              ELSE    
              BEGIN    
              --    
                SET @L_DELETED_IND = 0     
                IF @PA_VALUES = '0'     
                BEGIN    
                --    
                  INSERT INTO CMPLEDGED_MAK    
							(PLDTCM_ID
							,PLDTCM_DTLS_ID
							,PLDTCM_DPM_ID
							,PLDTCM_DPAM_ID
							,PLDTCM_REQUEST_DT
							,PLDTCM_EXEC_DT
							,PLDTCM_SLIP_NO
							,PLDTCM_ISIN
							,PLDTCM_QTY
							,PLDTCM_TRASTM_CD
							,PLDTCM_AGREEMENT_NO
							,PLDTCM_SETUP_DT
							,PLDTCM_EXPIRY_DT
							,PLDTCM_PLDG_DPID
							,PLDTCM_PLDG_DPNAME
							,PLDTCM_PLDG_CLIENTID
							,PLDTCM_PLDG_CLIENTNAME
							,PLDTCM_REASON
							,PLDTCM_PSN
							,PLDTCM_STATUS
							,PLDTCM_CREATED_BY
							,PLDTCM_CREATED_DATE
							,PLDTCM_UPDATED_BY
							,PLDTCM_UPDATED_DATE
							,PLDTCM_DELETED_IND
							,PLDTCM_RMKS
							,PLDTCM_CLOSURE_BY  
							,PLDTCM_SECURITTIES
							,PLDTCM_SUB_STATUS 
							,PLDTCM_VALUE
								,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID


							)    
																		SELECT PLDTCM_ID     
																	,PLDTCM_DTLS_ID    
																	,@L_DPM_ID    
																	,PLDTCM_DPAM_ID  
																	,CONVERT(DATETIME,@PA_REQ_DT,103)    
																	,CONVERT(DATETIME,@PA_EXE_DT,103)    
																	,@PA_SLIP_NO    
																	,PLDTCM_ISIN                 
																	,PLDTCM_QTY       
																	,@L_TRASTM_ID    
																	,@PA_AGREE_NO    
																		,CONVERT(DATETIME,@PA_SETUP_DT,103) 
	                                                                 ,CONVERT(DATETIME,@PA_EXPIRE_DT,103)
																	,@PA_PLEDGEE_DPID 
																	,'' 
																	,@PA_PLEDGEE_ACCTNO   
																	,@PA_PLEDGEE_DEMAT_NAME
																	,PLDTCM_REASON               
																	,PLDTCM_PSN             
																	,'P'    
																	,PLDTCM_CREATED_BY    
																	,PLDTCM_CREATED_DATE 
																	,@PA_LOGIN_NAME    
																	,GETDATE()    
																	,@L_DELETED_IND
																	,@PA_RMKS
																	,@PA_PLDTCM_CLOSURE_BY  
																	,@PA_PLDTCM_SECURITTIES
																	,@PA_PLDTCM_SUB_STATUS 
																	,PLDTCM_VALUE
																		,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID


                  FROM  #CMPLEDGED_MAK    
                  WHERE PLDTCM_DTLS_ID       =  CONVERT(INT,@CURRSTRING)    
                  AND   PLDTCM_DELETED_IND   =  0    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  IF @L_ACTION = 'A'    
                  BEGIN    
                  --    
                    --SELECT @L_ID = ISNULL(MAX(PLDT_ID),0) + 1 FROM NPLEDGED_MAK    
                    SET @L_PLDT_ID = @L_PLDT_ID + 1    
                  --    
                  END    
                  IF @L_ACTION <> 'D'    
                  BEGIN    
                  --    
    
                    INSERT INTO CMPLEDGED_MAK    
																				(PLDTCM_ID
																				,PLDTCM_DTLS_ID
																				,PLDTCM_DPM_ID
																				,PLDTCM_DPAM_ID
																				,PLDTCM_REQUEST_DT
																				,PLDTCM_EXEC_DT
																				,PLDTCM_SLIP_NO
																				,PLDTCM_ISIN
																				,PLDTCM_QTY
																				,PLDTCM_TRASTM_CD
																				,PLDTCM_AGREEMENT_NO
																				,PLDTCM_SETUP_DT
																				,PLDTCM_EXPIRY_DT
																				,PLDTCM_PLDG_DPID
																				,PLDTCM_PLDG_DPNAME
																				,PLDTCM_PLDG_CLIENTID
																				,PLDTCM_PLDG_CLIENTNAME
																				,PLDTCM_REASON
																				,PLDTCM_PSN
																				,PLDTCM_STATUS
																				,PLDTCM_CREATED_BY
																				,PLDTCM_CREATED_DATE
																				,PLDTCM_UPDATED_BY
																				,PLDTCM_UPDATED_DATE
																				,PLDTCM_DELETED_IND
																				,PLDTCM_RMKS
,PLDTCM_CLOSURE_BY  
			,PLDTCM_SECURITTIES
,PLDTCM_SUB_STATUS 
,PLDTCM_VALUE
	,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID


																				)VALUES     
																				(@L_PLDT_ID     
																				,@L_DTLS_ID    
																				,@L_DPM_ID    
																				,@L_DPAM_ID    
																				,CONVERT(DATETIME,@PA_REQ_DT,103)    
																				,CONVERT(DATETIME,@PA_EXE_DT,103)    
																				,@PA_SLIP_NO    
																				,@L_ISIN                  
																				,@L_QTY       
																				,@L_TRASTM_ID    
																				,@PA_AGREE_NO    
																					,CONVERT(DATETIME,@PA_SETUP_DT,103) 
																				,CONVERT(DATETIME,@PA_EXPIRE_DT,103)
																				,@PA_PLEDGEE_DPID 
																				,'' 
																				,@PA_PLEDGEE_ACCTNO   
																				,@PA_PLEDGEE_DEMAT_NAME
																				,@L_REL_RSN               
																				,@L_SEQ_NO               
																				,'P'    
																				,@PA_LOGIN_NAME    
																				,GETDATE()    
																				,@PA_LOGIN_NAME    
																				,GETDATE()    
																				,CASE WHEN @L_HIGH_VAL_YN = 'Y' THEN -1 ELSE 0 END 
																				,@PA_RMKS
,@PA_PLDTCM_CLOSURE_BY  
			,@PA_PLDTCM_SECURITTIES
,@PA_PLDTCM_SUB_STATUS 
,@L_VALUE 
			 ,@PA_UCC 
			 ,@PA_EXID 
			 ,@PA_SEGID 
			 ,@PA_CMID 
			 ,@PA_EID 
			 ,@PA_TMCMID 
																				)    
                        
                  --    
                  END    
                --    
                END    
                   
                   
              --    
              END    
               SET @L_ERROR = @@ERROR    
               IF @L_ERROR <> 0    
               BEGIN    
               --    
                 IF EXISTS(SELECT ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = @L_ERROR)    
                 BEGIN    
                 --    
                   SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': '+ ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = CONVERT(VARCHAR,@L_ERROR)    
                 --    
                 END    
                 ELSE    
                 BEGIN    
                 --    
                   SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': CAN NOT PROCESS, PLEASE CONTACT YOUR ADMINISTRATOR!'    
                 --    
                 END    
    
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
            IF @PA_ACTION = 'DEL' OR @L_ACTION = 'D'     
            BEGIN    
   --    
    
              IF EXISTS(SELECT * FROM CMPLEDGED_MAK WHERE PLDTCM_DTLS_ID = CONVERT(NUMERIC,@CURRSTRING) AND PLDTCM_DELETED_IND IN (0,-1))    
              BEGIN    
              --    
                IF @L_ACTION = 'D'     
                BEGIN    
                --    
                  DELETE FROM CMPLEDGED_MAK    
                  WHERE  PLDTCM_DELETED_IND IN (0,-1)   
                  AND    PLDTCM_ID          = CONVERT(NUMERIC,@L_ID)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  DELETE FROM CMPLEDGED_MAK    
                  WHERE  PLDTCM_DELETED_IND IN (0,-1)     
                  AND    PLDTCM_DTLS_ID          = CONVERT(NUMERIC,@CURRSTRING)    
                --    
                END    
              --    
              END    
              ELSE    
              BEGIN    
              --    
                BEGIN TRANSACTION     
                    
                IF @L_ACTION = 'D'     
                BEGIN    
                --    
                INSERT INTO CMPLEDGED_MAK    
																(PLDTCM_ID
																,PLDTCM_DTLS_ID
																,PLDTCM_DPM_ID
																,PLDTCM_DPAM_ID
																,PLDTCM_REQUEST_DT
																,PLDTCM_EXEC_DT
																,PLDTCM_SLIP_NO
																,PLDTCM_ISIN
																,PLDTCM_QTY
																,PLDTCM_TRASTM_CD
																,PLDTCM_AGREEMENT_NO
																,PLDTCM_SETUP_DT
																,PLDTCM_EXPIRY_DT
																,PLDTCM_PLDG_DPID
																,PLDTCM_PLDG_DPNAME
																,PLDTCM_PLDG_CLIENTID
																,PLDTCM_PLDG_CLIENTNAME
																,PLDTCM_REASON
																,PLDTCM_PSN
																,PLDTCM_STATUS
																,PLDTCM_CREATED_BY
																,PLDTCM_CREATED_DATE
																,PLDTCM_UPDATED_BY
																,PLDTCM_UPDATED_DATE
																,PLDTCM_DELETED_IND
																	,PLDTCM_RMKS
,PLDTCM_CLOSURE_BY  
			,PLDTCM_SECURITTIES
,PLDTCM_SUB_STATUS
,PLDTCM_VALUE 
	,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID

)
                  SELECT  PLDTCM_ID
																		,PLDTCM_DTLS_ID
																		,PLDTCM_DPM_ID
																		,PLDTCM_DPAM_ID
																		,PLDTCM_REQUEST_DT
																		,PLDTCM_EXEC_DT
																		,PLDTCM_SLIP_NO
																		,PLDTCM_ISIN
																		,PLDTCM_QTY
																		,PLDTCM_TRASTM_CD
																		,PLDTCM_AGREEMENT_NO
																		,PLDTCM_SETUP_DT
																		,PLDTCM_EXPIRY_DT
																		,PLDTCM_PLDG_DPID
																		,PLDTCM_PLDG_DPNAME
																		,PLDTCM_PLDG_CLIENTID
																		,PLDTCM_PLDG_CLIENTNAME
																		,PLDTCM_REASON
																		,PLDTCM_PSN
																		,PLDTCM_STATUS
																		,PLDTCM_CREATED_BY
																		,PLDTCM_CREATED_DATE
																		,PLDTCM_UPDATED_BY
																		,PLDTCM_UPDATED_DATE
																		,4
																				,PLDTCM_RMKS
,PLDTCM_CLOSURE_BY  
			,PLDTCM_SECURITTIES
,PLDTCM_SUB_STATUS 
,PLDTCM_VALUE
	,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID

                  FROM CDSL_MARGINPLEDGE_DTLS    
                  WHERE PLDTCM_DELETED_IND      = 1     
                  AND   PLDTCM_DTLS_ID          = CONVERT(NUMERIC,@CURRSTRING)    
                  AND   PLDTCM_ID               = CONVERT(NUMERIC,@L_ID)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  INSERT INTO CMPLEDGED_MAK    
																		(PLDTCM_ID
																		,PLDTCM_DTLS_ID
																		,PLDTCM_DPM_ID
																		,PLDTCM_DPAM_ID
																		,PLDTCM_REQUEST_DT
																		,PLDTCM_EXEC_DT
																		,PLDTCM_SLIP_NO
																		,PLDTCM_ISIN
																		,PLDTCM_QTY
																		,PLDTCM_TRASTM_CD
																		,PLDTCM_AGREEMENT_NO
																		,PLDTCM_SETUP_DT
																		,PLDTCM_EXPIRY_DT
																		,PLDTCM_PLDG_DPID
																		,PLDTCM_PLDG_DPNAME
																		,PLDTCM_PLDG_CLIENTID
																		,PLDTCM_PLDG_CLIENTNAME
																		,PLDTCM_REASON
																		,PLDTCM_PSN
																		,PLDTCM_STATUS
																		,PLDTCM_CREATED_BY
																		,PLDTCM_CREATED_DATE
																		,PLDTCM_UPDATED_BY
																		,PLDTCM_UPDATED_DATE
																		,PLDTCM_DELETED_IND
																			,PLDTCM_RMKS
,PLDTCM_CLOSURE_BY  
			,PLDTCM_SECURITTIES
,PLDTCM_SUB_STATUS
,PLDTCM_VALUE
	,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID

 )
																				SELECT  PLDTCM_ID
																				,PLDTCM_DTLS_ID
																				,PLDTCM_DPM_ID
																				,PLDTCM_DPAM_ID
																				,PLDTCM_REQUEST_DT
																				,PLDTCM_EXEC_DT
																				,PLDTCM_SLIP_NO
																				,PLDTCM_ISIN
																				,PLDTCM_QTY
																				,PLDTCM_TRASTM_CD
																				,PLDTCM_AGREEMENT_NO
																				,PLDTCM_SETUP_DT
																				,PLDTCM_EXPIRY_DT
																				,PLDTCM_PLDG_DPID
																				,PLDTCM_PLDG_DPNAME
																				,PLDTCM_PLDG_CLIENTID
																				,PLDTCM_PLDG_CLIENTNAME
																				,PLDTCM_REASON
																				,PLDTCM_PSN
																				,PLDTCM_STATUS
																				,PLDTCM_CREATED_BY
																				,PLDTCM_CREATED_DATE
																				,PLDTCM_UPDATED_BY
																				,PLDTCM_UPDATED_DATE
																				,4
																				,PLDTCM_RMKS
,PLDTCM_CLOSURE_BY  
			,PLDTCM_SECURITTIES
,PLDTCM_SUB_STATUS
,PLDTCM_VALUE 
	,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID

                 FROM CDSL_MARGINPLEDGE_DTLS    
                 WHERE PLDTCM_DELETED_IND      = 1     
                 AND   PLDTCM_DTLS_ID          = CONVERT(NUMERIC,@CURRSTRING)    
                --    
                END    
                    
                SET @L_ERROR = @@ERROR    
                IF @L_ERROR <> 0    
                BEGIN    
                --    
                  IF EXISTS(SELECT ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = @L_ERROR)    
                  BEGIN    
                  --    
                    SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': '+ ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = CONVERT(VARCHAR,@L_ERROR)    
                  --    
                  END    
                  ELSE    
                  BEGIN    
                  --    
                    SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': CAN NOT PROCESS, PLEASE CONTACT YOUR ADMINISTRATOR!'    
                  --    
                  END    
    
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
            ELSE IF @PA_ACTION = 'APP'    
            BEGIN    
            --    
    PRINT CONVERT(NUMERIC,@CURRSTRING)
	print 'pppppppppp'
              SET @@C_ACCESS_CURSOR =  CURSOR FAST_FORWARD FOR          
              SELECT PLDTCM_ID, PLDTCM_DELETED_IND  FROM CMPLEDGED_MAK WHERE PLDTCM_DTLS_ID = CONVERT(NUMERIC,@CURRSTRING) AND PLDTCM_DELETED_IND IN (0,4,6,-1)    
              --          
              OPEN @@C_ACCESS_CURSOR          
              FETCH NEXT FROM @@C_ACCESS_CURSOR INTO @C_PLDT_ID, @C_DELETED_IND     
              --          
              WHILE @@FETCH_STATUS = 0          
              BEGIN          
              --          
                 BEGIN TRANSACTION    
    
                 IF EXISTS(SELECT PLDTCM_ID FROM CMPLEDGED_MAK WHERE PLDTCM_ID = @C_PLDT_ID AND PLDTCM_DELETED_IND = 6)    
                 BEGIN    
                 --    
				 print 'update master'
                   UPDATE  DPTD     
                   SET    DPTD.PLDTCM_REQUEST_DT=DPTDM.PLDTCM_REQUEST_DT
						,DPTD.PLDTCM_EXEC_DT=DPTDM.PLDTCM_EXEC_DT
						,DPTD.PLDTCM_SLIP_NO=DPTDM.PLDTCM_SLIP_NO
						,DPTD.PLDTCM_ISIN=DPTDM.PLDTCM_ISIN
						,DPTD.PLDTCM_QTY=DPTDM.PLDTCM_QTY
						,DPTD.PLDTCM_AGREEMENT_NO=DPTDM.PLDTCM_AGREEMENT_NO
						,DPTD.PLDTCM_SETUP_DT=DPTDM.PLDTCM_SETUP_DT
						,DPTD.PLDTCM_EXPIRY_DT=DPTDM.PLDTCM_EXPIRY_DT
						,DPTD.PLDTCM_PLDG_DPID=DPTDM.PLDTCM_PLDG_DPID
						,DPTD.PLDTCM_PLDG_DPNAME=DPTDM.PLDTCM_PLDG_DPNAME
						,DPTD.PLDTCM_PLDG_CLIENTID=DPTDM.PLDTCM_PLDG_CLIENTID
						,DPTD.PLDTCM_PLDG_CLIENTNAME=DPTDM.PLDTCM_PLDG_CLIENTNAME
						,DPTD.PLDTCM_REASON=DPTDM.PLDTCM_REASON
						,DPTD.PLDTCM_PSN=DPTDM.PLDTCM_PSN
						,DPTD.PLDTCM_UPDATED_BY=DPTDM.PLDTCM_UPDATED_BY
						,DPTD.PLDTCM_UPDATED_DATE=DPTDM.PLDTCM_UPDATED_DATE
						,DPTD.PLDTCM_RMKS=DPTDM.PLDTCM_RMKS
						,DPTD.PLDTCM_CLOSURE_BY  = DPTDM.PLDTCM_CLOSURE_BY  
						,DPTD.PLDTCM_SECURITTIES = DPTDM.PLDTCM_SECURITTIES
                        ,DPTD.PLDTCM_SUB_STATUS =DPTDM.PLDTCM_SUB_STATUS 
                        ,DPTD.PLDTCM_VALUE = DPTDM.PLDTCM_VALUE
						,DPTD.PLDTCM_UCC=DPTDM.PLDTCM_UCC
						,DPTD.PLDTCM_EXID=DPTDM.PLDTCM_EXID
						,DPTD.PLDTCM_SEGID=DPTDM.PLDTCM_SEGID 
						,DPTD.PLDTCM_CMID=DPTDM.PLDTCM_CMID 
						,DPTD.PLDTCM_EID=DPTDM.PLDTCM_EID 
						,DPTD.PLDTCM_TMCMID=DPTDM.PLDTCM_TMCMID


                   FROM    CMPLEDGED_MAK                    DPTDM           
                          ,CDSL_MARGINPLEDGE_DTLS                 DPTD     
                   WHERE   DPTDM.PLDTCM_ID             = CONVERT(NUMERIC,@C_PLDT_ID)    
                   AND      DPTDM.PLDTCM_ID             = DPTD.PLDTCM_ID     
                   AND     DPTDM.PLDTCM_DTLS_ID        = DPTD.PLDTCM_DTLS_ID     
                   AND     DPTDM.PLDTCM_DELETED_IND    = 6      
    
                   SET @L_ERROR = @@ERROR    
                   IF @L_ERROR <> 0    
                   BEGIN    
                   --    
                     ROLLBACK TRANSACTION     
    
                     IF EXISTS(SELECT ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = @L_ERROR)    
                     BEGIN    
                     --    
                       SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': '+ ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = CONVERT(VARCHAR,@L_ERROR)    
                     --    
                     END    
                     ELSE    
                     BEGIN    
                     --    
                       SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': CAN NOT PROCESS, PLEASE CONTACT YOUR ADMINISTRATOR!'    
                     --    
                     END    
                   --    
                   END    
                   ELSE    
                   BEGIN    
                   --    
    
                     UPDATE CMPLEDGED_MAK     
                     SET    PLDTCM_DELETED_IND = 7    
                          , PLDTCM_UPDATED_DATE  = GETDATE()    
                          , PLDTCM_UPDATED_BY  = @PA_LOGIN_NAME    
                     WHERE  PLDTCM_ID          = CONVERT(NUMERIC,@C_PLDT_ID)    
                     AND    PLDTCM_DELETED_IND = 6    
    
    
                     COMMIT TRANSACTION    
                   --    
                   END    
                 --    
                 END    
                 ELSE IF EXISTS(SELECT PLDTCM_ID FROM CMPLEDGED_MAK WHERE PLDTCM_ID = CONVERT(NUMERIC,@C_PLDT_ID) AND PLDTCM_DELETED_IND IN (0,-1))    
                 BEGIN    
                 --    
    
                   INSERT INTO CDSL_MARGINPLEDGE_DTLS    
                   (PLDTCM_ID
																				,PLDTCM_DTLS_ID
																				,PLDTCM_DPM_ID
																				,PLDTCM_DPAM_ID
																				,PLDTCM_REQUEST_DT
																				,PLDTCM_EXEC_DT
																				,PLDTCM_SLIP_NO
																				,PLDTCM_ISIN
																				,PLDTCM_QTY
																				,PLDTCM_TRASTM_CD
																				,PLDTCM_AGREEMENT_NO
																				,PLDTCM_SETUP_DT
																				,PLDTCM_EXPIRY_DT
																				,PLDTCM_PLDG_DPID
																				,PLDTCM_PLDG_DPNAME
																				,PLDTCM_PLDG_CLIENTID
																				,PLDTCM_PLDG_CLIENTNAME
																				,PLDTCM_REASON
																				,PLDTCM_PSN
																				,PLDTCM_TRANS_NO
																				,PLDTCM_BATCH_NO
																				,PLDTCM_BROKER_BATCH_NO
																				,PLDTCM_BROKER_REF_NO
																				,PLDTCM_STATUS
																				,PLDTCM_CREATED_BY
																				,PLDTCM_CREATED_DATE
																				,PLDTCM_UPDATED_BY
																				,PLDTCM_UPDATED_DATE
																				,PLDTCM_DELETED_IND
																				,PLDTCM_RMKS
,PLDTCM_CLOSURE_BY
,PLDTCM_SECURITTIES
,PLDTCM_SUB_STATUS
,PLDTCM_VALUE 
	,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID

)    
                   SELECT     
                    PLDTCM_ID
																				,PLDTCM_DTLS_ID
																				,PLDTCM_DPM_ID
																				,PLDTCM_DPAM_ID
																				,PLDTCM_REQUEST_DT
																				,PLDTCM_EXEC_DT
																				,PLDTCM_SLIP_NO
																				,PLDTCM_ISIN
																				,PLDTCM_QTY
																				,PLDTCM_TRASTM_CD
																				,PLDTCM_AGREEMENT_NO
																				,PLDTCM_SETUP_DT
																				,PLDTCM_EXPIRY_DT
																				,PLDTCM_PLDG_DPID
																				,PLDTCM_PLDG_DPNAME
																				,PLDTCM_PLDG_CLIENTID
																				,PLDTCM_PLDG_CLIENTNAME
																				,PLDTCM_REASON
																				,PLDTCM_PSN
																				,PLDTCM_TRANS_NO
																				,PLDTCM_BATCH_NO
																				,PLDTCM_BROKER_BATCH_NO
																				,PLDTCM_BROKER_REF_NO
																				,PLDTCM_STATUS
																				,PLDTCM_CREATED_BY
																				,PLDTCM_CREATED_DATE
																				,@pa_login_name
																				,getdate()
																				,1
																				,PLDTCM_RMKS
,PLDTCM_CLOSURE_BY
,PLDTCM_SECURITTIES
,PLDTCM_SUB_STATUS
,PLDTCM_VALUE 
	,PLDTCM_UCC
	,PLDTCM_EXID
	,PLDTCM_SEGID
	,PLDTCM_CMID
	,PLDTCM_EID
	,PLDTCM_TMCMID

                   FROM  CMPLEDGED_MAK    
                   WHERE PLDTCM_DELETED_IND      = 0 
                   AND   PLDTCM_ID               = CONVERT(NUMERIC,@C_PLDT_ID)     
    
    
    
    
                   SET @L_ERROR = @@ERROR    
                   IF @L_ERROR <> 0    
                   BEGIN    
                   --    
                     ROLLBACK TRANSACTION     
    
                     IF EXISTS(SELECT ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = @L_ERROR)    
                     BEGIN    
                     --    
                       SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': '+ ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = CONVERT(VARCHAR,@L_ERROR)    
                     --    
                     END    
                     ELSE    
                     BEGIN    
                     --    
                       SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': CAN NOT PROCESS, PLEASE CONTACT YOUR ADMINISTRATOR!'    
                     --    
                     END    
                   --    
                   END    
                   ELSE    
                   BEGIN    
                   --    
    
                      IF EXISTS(SELECT PLDTCM_ID FROM CMPLEDGED_MAK WHERE PLDTCM_ID = CONVERT(NUMERIC,@C_PLDT_ID) AND PLDTCM_DELETED_IND IN (-1,0)  )    
                      BEGIN    
                      --    
                        UPDATE CMPLEDGED_MAK         
                        SET    PLDTCM_DELETED_IND = CASE WHEN  PLDTCM_DELETED_IND = -1 THEN 0 ELSE 1 END         
                             , PLDTCM_UPDATED_DATE  = GETDATE()        
                             , PLDTCM_UPDATED_BY  = @PA_LOGIN_NAME        
                        WHERE  PLDTCM_ID          = CONVERT(NUMERIC,@C_PLDT_ID)        
                        AND    PLDTCM_DELETED_IND IN (-1,0)       
                      --    
                      END    

                          
                     COMMIT TRANSACTION    
                   --    
                   END    
                 --    
                 END    
                 ELSE     
                 BEGIN    
                 --    
                   DELETE USED FROM CDSL_MARGINPLEDGE_DTLS,DP_ACCT_MSTR,USED_SLIP USED WHERE DPAM_ID = PLDTCM_DPAM_ID AND USES_DPAM_ACCT_NO = DPAM_SBA_NO AND PLDTCM_ID          = CONVERT(NUMERIC,@C_PLDT_ID)     
                       
                   UPDATE CDSL_MARGINPLEDGE_DTLS    
                   SET    PLDTCM_DELETED_IND = 0    
                        , PLDTCM_UPDATED_DATE  = GETDATE()    
                        , PLDTCM_UPDATED_BY  = @PA_LOGIN_NAME    
                   WHERE  PLDTCM_ID          = CONVERT(NUMERIC,@C_PLDT_ID)    
                   AND    PLDTCM_DELETED_IND = 1    
    
    
    
                   UPDATE CMPLEDGED_MAK     
                   SET    PLDTCM_DELETED_IND = 5    
                        , PLDTCM_UPDATED_DATE  = GETDATE()    
                        , PLDTCM_UPDATED_BY  = @PA_LOGIN_NAME    
                   WHERE  PLDTCM_ID          = CONVERT(NUMERIC,@C_PLDT_ID)    
                   AND    PLDTCM_DELETED_IND = 4    
    
                   COMMIT TRANSACTION    
                 --    
                 END    
    
    
               FETCH NEXT FROM @@C_ACCESS_CURSOR INTO @C_PLDT_ID, @C_DELETED_IND         
            --          
            END          
    
              CLOSE      @@C_ACCESS_CURSOR          
              DEALLOCATE @@C_ACCESS_CURSOR      
            --    
            END    
            ELSE IF @PA_ACTION = 'REJ'    
            BEGIN    
            --    
    
              BEGIN TRANSACTION    
                  
              UPDATE CMPLEDGED_MAK     
              SET    PLDTCM_DELETED_IND = 3    
                   , PLDTCM_UPDATED_DATE  = GETDATE()    
                   , PLDTCM_UPDATED_BY  = @PA_LOGIN_NAME    
              WHERE  PLDTCM_DTLS_ID     = CONVERT(NUMERIC,@CURRSTRING)    
              AND    PLDTCM_DELETED_IND IN (0,4,6)    
    
              SET @L_ERROR = @@ERROR    
              IF @L_ERROR <> 0    
              BEGIN    
              --    
                ROLLBACK TRANSACTION     
    
                IF EXISTS(SELECT ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = @L_ERROR)    
                BEGIN    
                --    
                  SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': '+ ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = CONVERT(VARCHAR,@L_ERROR)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': CAN NOT PROCESS, PLEASE CONTACT YOUR ADMINISTRATOR!'    
                --    
                END    
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
      END    
          
    --    
    END    
  --    
  END    
  SET @PA_ERRMSG = @T_ERRORSTR    
  PRINT @PA_ERRMSG     
  IF LEFT(LTRIM(RTRIM(@PA_ERRMSG)),5) <> 'ERROR'    
  BEGIN    
  --    
PRINT @L_TRASTM_ID
PRINT @L_TRASTM_ID
PRINT @PA_DPM_DPID
PRINT @PA_DPAM_ACCT_NO
PRINT @PA_SLIP_NO

    EXEC [PR_CHECKSLIPNO_PLEDGE] '',@L_TRASTM_ID,@L_TRASTM_ID, @PA_DPM_DPID,@PA_DPAM_ACCT_NO,@PA_SLIP_NO,@PA_LOGIN_NAME,''    
  --    
  END    
--    
END

GO
