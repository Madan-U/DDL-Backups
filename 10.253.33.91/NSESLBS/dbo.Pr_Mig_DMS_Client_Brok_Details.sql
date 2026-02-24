-- Object: PROCEDURE dbo.Pr_Mig_DMS_Client_Brok_Details
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE Pr_Mig_DMS_Client_Brok_Details        
(        
  @pa_CanAddData AS Bit,        
  @pa_CanModifyData AS Bit,        
  @pa_CanDeleteData AS Bit,        
  @pa_err AS VarChar(250) OUTPUT         
)        
AS        
BEGIN        

-- -- 	IF EXISTS(SELECT 1 FROM TEMPDB.DBO.SYSOBJECTS WHERE NAME = '#CLIENT_BROK_DETAILS' AND XTYPE = 'U')
-- -- 		DELETE FROM #CLIENT_BROK_DETAILS
-- -- 	ELSE
-- -- 	   SELECT *, 
-- -- 		   CONVERT(CHAR(10), ' ') AS STATUS_FLAG, 
-- -- 		    0 AS PROFILE_ID, 
-- -- 			CONVERT(VARCHAR(20), '') AS PROFILE_NAME,
-- -- 		   'N' AS VALID_CL_CODE, 
-- -- 		   'N' AS VALID_PROFILE_ID, 
-- -- 		   'N' AS VALID_CUSTODIAN, 
-- -- 		   ' ' AS MODIFIED, 
-- -- 		   'N' AS RECORD_FOUND, 
-- -- 		   'N' AS VALID_RECORD 
-- -- 		   INTO #CLIENT_BROK_DETAILS
-- -- 		   FROM CLIENT_BROK_DETAILS WHERE 1 = 0 
   
 --- INSERT THE RECORD INTO #CLIENT_BROK_DETAILS  FROM DMSClientDetails   FOR (BSE-CAPITAL)   
  INSERT INTO #CLIENT_BROK_DETAILS        
  (        
	MODIFIED,
	PROFILE_ID,
	PROFILE_NAME,
   ACTIVE_DATE,        
   BROK_EFF_DATE,        
   BROK_SCHEME,        
   CHARGED,        
   CHECKACTIVECLIENT,        
   CL_CODE,        
   CLIENT_RATING,        
   CREDIT_LIMIT,        
   CUSTODIAN_CODE,        
   DEBIT_BALANCE,        
   DEL_BROK,        
   DEL_EFF_DT,        
   DEL_OTHER_CHRGS,        
   DEL_SEBI_FEES,        
   DEL_STAMP_DUTY,        
   DEL_STT,        
   DEL_TRAN_CHRGS,        
   EXCHANGE,        
   FUT_BROK,        
   FUT_BROK_APPLICABLE,        
   FUT_FUT_FIN_BROK,        
   FUT_OPT_BROK,        
   FUT_OPT_EXC,        
   FUT_OTHER_CHRGS,        
   FUT_SEBI_FEES,        
   FUT_STAMP_DUTY,        
   FUT_STT,        
   FUT_TRAN_CHRGS,        
   IMP_STATUS,        
   INACTIVE_FROM,        
   INST_CONTRACT,        
   INST_DEL_BROK,        
   INST_TRD_BROK,        
   INTER_SETT,        
   MAINTENANCE,        
   MARKET_TYPE,        
   MODIFIEDBY,        
   MODIFIEDON,        
   MULTIPLIER,        
   NO_OF_COPIES,        
   PARTICIPANT_CODE,        
   PAY_AC_NO,        
   PAY_B3B_PAYMENT,        
   PAY_BANK_NAME,        
   PAY_BRANCH_NAME,        
   PAY_PAYMENT_MODE,        
   PRINT_OPTIONS,        
   REQD_BY_BROKER,        
   REQD_BY_EXCH,        
   ROUND_STYLE,        
   ROUND_TO_DIGIT,        
   ROUND_TO_PAISE,        
   ROUNDING_METHOD,        
   SEGMENT,        
   SER_TAX,        
   SER_TAX_METHOD,        
   STATUS,        
   STP_PROVIDER,        
   STP_RP_STYLE,        
   SYSTEMDATE,        
   TRD_BROK,        
   TRD_EFF_DT,        
   TRD_OTHER_CHRGS,        
   TRD_SEBI_FEES,        
   TRD_STAMP_DUTY,        
   TRD_STT,        
   TRD_TRAN_CHRGS,   
	VALID_CL_CODE, 
	VALID_PROFILE_ID, 
	VALID_CUSTODIAN, 
	RECORD_FOUND, 
	VALID_RECORD 
     
  )        
   SELECT
	MODIFIED  = CASE MODIFIED  WHEN '' THEN 'N' ELSE MODIFIED  END,
	PROFILE_ID = 0,
	PROFILE_NAME = UPPER(RTRIM(BrokerageSlab)),     
   ACTIVE_DATE = LEFT(GETDATE(),11) + ' 23:59:59',               
   BROK_EFF_DATE = LEFT(GETDATE(),11) + ' 23:59:59',       
   BROK_SCHEME = 0 ,        
   CHARGED = 0,        
   CHECKACTIVECLIENT = 0,        
   CL_CODE = ClientCode,        
   CLIENT_RATING = '',        
   CREDIT_LIMIT = 0,        
   CUSTODIAN_CODE = '',        
   DEBIT_BALANCE = 0,        
   DEL_BROK = 0,        
   DEL_EFF_DT = LEFT(GETDATE(),11) + ' 23:59:59',          
   DEL_OTHER_CHRGS = 0,        
   DEL_SEBI_FEES = 0,        
   DEL_STAMP_DUTY = 0,        
   DEL_STT = 0,        
   DEL_TRAN_CHRGS = 0,        
   EXCHANGE = 'BSE',        
   FUT_BROK = 1,        
   FUT_BROK_APPLICABLE = 1,        
   FUT_FUT_FIN_BROK =1,        
   FUT_OPT_BROK =1,        
   FUT_OPT_EXC =1,        
   FUT_OTHER_CHRGS =0,        
   FUT_SEBI_FEES =0,        
   FUT_STAMP_DUTY =0,        
   FUT_STT =0,        
   FUT_TRAN_CHRGS =0,        
   IMP_STATUS = 0,        
   INACTIVE_FROM = 'DEC 31 2049',        
   INST_CONTRACT = CASE TradeClubbingOn WHEN 'N' THEN 'N' WHEN 'S' THEN 'S' WHEN 'O' THEN 'O' ELSE 'S' END,        
   INST_DEL_BROK = 0,        
   INST_TRD_BROK = 0,        
   INTER_SETT = 0,        
   MAINTENANCE = 0,        
   MARKET_TYPE = 0,        
   MODIFIEDBY = 'DMS Migration',        
   MODIFIEDON = GetDate(),        
   MULTIPLIER = RoundingMultiplierForBrokerage,        
   NO_OF_COPIES = 0,        
   PARTICIPANT_CODE = '',        
   PAY_AC_NO = '',--LEFT(AccountNo, 10),        
   PAY_B3B_PAYMENT =1,        
   PAY_BANK_NAME = '',--LEFT(BankName,50),        
   PAY_BRANCH_NAME = '',--LEFT(BanksBranch,50),1        
   PAY_PAYMENT_MODE = 'C' ,        
   PRINT_OPTIONS = CASE PrintContract WHEN 'Y' THEN 1 ELSE 0 END,        
   REQD_BY_BROKER = 0,        
   REQD_BY_EXCH = 0,        
   ROUND_STYLE = 0,--dbo.fnGetRoundingStyle(),        
   ROUND_TO_DIGIT = BrokerageAccuracy,
   ROUND_TO_PAISE = (POWER(10, BrokerageAccuracy) * RoundingMultiplierForBrokerage),        
   ROUNDING_METHOD = CASE RoundBrokerageTo WHEN 'RU' THEN 'ACTUAL' WHEN 'TU' THEN 'NEXT' ELSE 'RU' END,        
   SEGMENT = 'CAPITAL',        
   SER_TAX = CASE IncludeSTInBrokerage WHEN 'Y' THEN 2 ELSE 0 END,
   SER_TAX_METHOD = 0,        
   STATUS = 'U' ,        
   STP_PROVIDER = '',        
   STP_RP_STYLE = 0,        
   GETDATE() AS SYSTEMDATE,        
   TRD_BROK = 0,        
   TRD_EFF_DT = LEFT(GETDATE(),11) + ' 23:59:59',        
   TRD_OTHER_CHRGS = 0,        
   TRD_SEBI_FEES = 0,        
   TRD_STAMP_DUTY = 0,        
   TRD_STT = 0,   
   TRD_TRAN_CHRGS = 0,        
   'Y' AS VALID_CL_CODE, 
   'Y' AS VALID_PROFILE_ID, 
   -- VALID_CUSTODIAN = CASE WHEN ISNULL(CUSTODIAN_CODE, '') = '' THEN 'Y' ELSE 'N' END , 
	'Y' AS VALID_CUSTODIAN,
   'N' AS RECORD_FOUND, 
   'N' AS VALID_RECORD 
  FROM DMSClientDetails  
 WHERE ClientCode IN (SELECT Party_Code FROM #CLIENT_DETAILS WHERE VALID_RECORD = 'Y' AND MODIFIED = 'N')    
      
 IF @@ERROR <> 0         
 BEGIN        
  SET @pa_err = @@ERROR        
  RETURN        
 END        

 --- INSERT THE RECORD INTO #CLIENT_BROK_DETAILS  FROM DMSClientDetails   FOR (NSE-CAPITAL)   
  INSERT INTO #CLIENT_BROK_DETAILS        
  (        
	MODIFIED,
	PROFILE_ID,
	PROFILE_NAME,
   ACTIVE_DATE,        
   BROK_EFF_DATE,        
   BROK_SCHEME,        
   CHARGED,        
   CHECKACTIVECLIENT,        
   CL_CODE,        
   CLIENT_RATING,        
   CREDIT_LIMIT,        
   CUSTODIAN_CODE,        
   DEBIT_BALANCE,        
   DEL_BROK,        
   DEL_EFF_DT,        
   DEL_OTHER_CHRGS,        
   DEL_SEBI_FEES,        
   DEL_STAMP_DUTY,        
   DEL_STT,        
   DEL_TRAN_CHRGS,        
   EXCHANGE,        
   FUT_BROK,        
   FUT_BROK_APPLICABLE,        
   FUT_FUT_FIN_BROK,        
   FUT_OPT_BROK,        
   FUT_OPT_EXC,        
   FUT_OTHER_CHRGS,        
   FUT_SEBI_FEES,        
   FUT_STAMP_DUTY,        
   FUT_STT,        
   FUT_TRAN_CHRGS,        
   IMP_STATUS,        
   INACTIVE_FROM,        
   INST_CONTRACT,        
   INST_DEL_BROK,        
   INST_TRD_BROK,        
   INTER_SETT,        
   MAINTENANCE,        
   MARKET_TYPE,        
   MODIFIEDBY,        
   MODIFIEDON,        
   MULTIPLIER,        
   NO_OF_COPIES,        
   PARTICIPANT_CODE,        
   PAY_AC_NO,        
   PAY_B3B_PAYMENT,        
   PAY_BANK_NAME,        
   PAY_BRANCH_NAME,        
   PAY_PAYMENT_MODE,        
   PRINT_OPTIONS,        
   REQD_BY_BROKER,        
   REQD_BY_EXCH,        
   ROUND_STYLE,        
   ROUND_TO_DIGIT,        
   ROUND_TO_PAISE,        
   ROUNDING_METHOD,        
   SEGMENT,        
   SER_TAX,        
   SER_TAX_METHOD,        
   STATUS,        
   STP_PROVIDER,        
   STP_RP_STYLE,        
   SYSTEMDATE,        
   TRD_BROK,        
   TRD_EFF_DT,        
   TRD_OTHER_CHRGS,        
   TRD_SEBI_FEES,        
   TRD_STAMP_DUTY,        
   TRD_STT,        
   TRD_TRAN_CHRGS,   
	VALID_CL_CODE, 
	VALID_PROFILE_ID, 
	VALID_CUSTODIAN, 
	RECORD_FOUND, 
	VALID_RECORD 
     
  )        
   SELECT
	MODIFIED  = CASE MODIFIED  WHEN '' THEN 'N' ELSE MODIFIED  END,
	PROFILE_ID = 0,
	PROFILE_NAME = UPPER(RTRIM(BrokerageSlab)),     
   ACTIVE_DATE = LEFT(GETDATE(),11) + ' 23:59:59',               
   BROK_EFF_DATE = LEFT(GETDATE(),11) + ' 23:59:59',       
   BROK_SCHEME = 0 ,        
   CHARGED = 0,        
   CHECKACTIVECLIENT = 0,        
   CL_CODE = ClientCode,        
   CLIENT_RATING = '',        
   CREDIT_LIMIT = 0,        
   CUSTODIAN_CODE = '',        
   DEBIT_BALANCE = 0,        
   DEL_BROK = 0,        
   DEL_EFF_DT = LEFT(GETDATE(),11) + ' 23:59:59',          
   DEL_OTHER_CHRGS = 0,        
   DEL_SEBI_FEES = 0,        
   DEL_STAMP_DUTY = 0,        
   DEL_STT = 0,        
   DEL_TRAN_CHRGS = 0,        
   EXCHANGE = 'NSE',        
   FUT_BROK = 1,        
   FUT_BROK_APPLICABLE = 1,        
   FUT_FUT_FIN_BROK =1,        
   FUT_OPT_BROK =1,        
   FUT_OPT_EXC =1,        
   FUT_OTHER_CHRGS =0,        
   FUT_SEBI_FEES =0,        
   FUT_STAMP_DUTY =0,        
   FUT_STT =0,        
   FUT_TRAN_CHRGS =0,        
   IMP_STATUS = 0,        
   INACTIVE_FROM = 'DEC 31 2049',        
   INST_CONTRACT = CASE TradeClubbingOn WHEN 'N' THEN 'N' WHEN 'S' THEN 'S' WHEN 'O' THEN 'O' ELSE 'S' END,        
   INST_DEL_BROK = 0,        
   INST_TRD_BROK = 0,        
   INTER_SETT = 0,        
   MAINTENANCE = 0,        
   MARKET_TYPE = 0,        
   MODIFIEDBY = 'DMS Migration',        
   MODIFIEDON = GetDate(),        
   MULTIPLIER = RoundingMultiplierForBrokerage,        
   NO_OF_COPIES = 0,        
   PARTICIPANT_CODE = '',        
   PAY_AC_NO = '',--LEFT(AccountNo, 10),        
   PAY_B3B_PAYMENT =1,        
   PAY_BANK_NAME = '',--LEFT(BankName,50),        
   PAY_BRANCH_NAME = '',--LEFT(BanksBranch,50),1        
   PAY_PAYMENT_MODE = 'C' ,        
   PRINT_OPTIONS = CASE PrintContract WHEN 'Y' THEN 1 ELSE 0 END,        
   REQD_BY_BROKER = 0,        
   REQD_BY_EXCH = 0,        
   ROUND_STYLE = 0,--dbo.fnGetRoundingStyle(),        
   ROUND_TO_DIGIT = BrokerageAccuracy,
   ROUND_TO_PAISE = (POWER(10, BrokerageAccuracy) * RoundingMultiplierForBrokerage),        
   ROUNDING_METHOD = CASE RoundBrokerageTo WHEN 'RU' THEN 'ACTUAL' WHEN 'TU' THEN 'NEXT' ELSE 'RU' END,        
   SEGMENT = 'CAPITAL',        
   SER_TAX = CASE IncludeSTInBrokerage WHEN 'Y' THEN 2 ELSE 0 END,
   SER_TAX_METHOD = 0,        
   STATUS = 'U' ,        
   STP_PROVIDER = '',        
   STP_RP_STYLE = 0,        
   GETDATE() AS SYSTEMDATE,        
   TRD_BROK = 0,        
   TRD_EFF_DT = LEFT(GETDATE(),11) + ' 23:59:59',        
   TRD_OTHER_CHRGS = 0,        
   TRD_SEBI_FEES = 0,        
   TRD_STAMP_DUTY = 0,        
   TRD_STT = 0,   
   TRD_TRAN_CHRGS = 0,        
   'Y' AS VALID_CL_CODE, 
   'Y' AS VALID_PROFILE_ID, 
    --VALID_CUSTODIAN = CASE WHEN ISNULL(CUSTODIAN_CODE, '') = '' THEN 'Y' ELSE 'N' END , 
	'Y' AS VALID_CUSTODIAN,
   'N' AS RECORD_FOUND, 
   'N' AS VALID_RECORD 
  FROM DMSClientDetails  
 WHERE ClientCode IN (SELECT Party_Code FROM #CLIENT_DETAILS WHERE VALID_RECORD = 'Y' AND MODIFIED = 'N')    
      
 IF @@ERROR <> 0         
 BEGIN        
  SET @pa_err = @@ERROR        
  RETURN        
 END        

 --- INSERT THE RECORD INTO #CLIENT_BROK_DETAILS  FROM DMSClientDetails   FOR (NSE-FUTURES)   
  INSERT INTO #CLIENT_BROK_DETAILS        
  (        
	MODIFIED,
	PROFILE_ID,
	PROFILE_NAME,
   ACTIVE_DATE,        
   BROK_EFF_DATE,        
   BROK_SCHEME,        
   CHARGED,        
   CHECKACTIVECLIENT,        
   CL_CODE,        
   CLIENT_RATING,        
   CREDIT_LIMIT,        
   CUSTODIAN_CODE,        
   DEBIT_BALANCE,        
   DEL_BROK,        
   DEL_EFF_DT,        
   DEL_OTHER_CHRGS,        
   DEL_SEBI_FEES,        
   DEL_STAMP_DUTY,        
   DEL_STT,        
   DEL_TRAN_CHRGS,        
   EXCHANGE,        
   FUT_BROK,        
   FUT_BROK_APPLICABLE,        
   FUT_FUT_FIN_BROK,        
   FUT_OPT_BROK,        
   FUT_OPT_EXC,        
   FUT_OTHER_CHRGS,        
   FUT_SEBI_FEES,        
   FUT_STAMP_DUTY,        
   FUT_STT,        
   FUT_TRAN_CHRGS,        
   IMP_STATUS,        
   INACTIVE_FROM,        
   INST_CONTRACT,        
   INST_DEL_BROK,        
   INST_TRD_BROK,        
   INTER_SETT,        
   MAINTENANCE,        
   MARKET_TYPE,        
   MODIFIEDBY,        
   MODIFIEDON,        
   MULTIPLIER,        
   NO_OF_COPIES,        
   PARTICIPANT_CODE,        
   PAY_AC_NO,        
   PAY_B3B_PAYMENT,        
   PAY_BANK_NAME,        
   PAY_BRANCH_NAME,        
   PAY_PAYMENT_MODE,        
   PRINT_OPTIONS,        
   REQD_BY_BROKER,        
   REQD_BY_EXCH,        
   ROUND_STYLE,        
   ROUND_TO_DIGIT,        
   ROUND_TO_PAISE,        
   ROUNDING_METHOD,        
   SEGMENT,        
   SER_TAX,        
   SER_TAX_METHOD,        
   STATUS,        
   STP_PROVIDER,        
   STP_RP_STYLE,        
   SYSTEMDATE,        
   TRD_BROK,        
   TRD_EFF_DT,        
   TRD_OTHER_CHRGS,        
   TRD_SEBI_FEES,        
   TRD_STAMP_DUTY,        
   TRD_STT,        
   TRD_TRAN_CHRGS,   
	VALID_CL_CODE, 
	VALID_PROFILE_ID, 
	VALID_CUSTODIAN, 
	RECORD_FOUND, 
	VALID_RECORD 
     
  )        
   SELECT
	MODIFIED  = CASE MODIFIED  WHEN '' THEN 'N' ELSE MODIFIED  END,
	PROFILE_ID = 0,
	PROFILE_NAME = UPPER(RTRIM(BrokerageSlab)),     
   ACTIVE_DATE = LEFT(GETDATE(),11) + ' 23:59:59',               
   BROK_EFF_DATE = LEFT(GETDATE(),11) + ' 23:59:59',       
   BROK_SCHEME = 0 ,        
   CHARGED = 0,        
   CHECKACTIVECLIENT = 0,        
   CL_CODE = ClientCode,        
   CLIENT_RATING = '',        
   CREDIT_LIMIT = 0,        
   CUSTODIAN_CODE = '',        
   DEBIT_BALANCE = 0,        
   DEL_BROK = 0,        
   DEL_EFF_DT = LEFT(GETDATE(),11) + ' 23:59:59',          
   DEL_OTHER_CHRGS = 0,        
   DEL_SEBI_FEES = 0,        
   DEL_STAMP_DUTY = 0,        
   DEL_STT = 0,        
   DEL_TRAN_CHRGS = 0,        
   EXCHANGE = 'NSE',        
   FUT_BROK = 1,        
   FUT_BROK_APPLICABLE = 1,        
   FUT_FUT_FIN_BROK =1,        
   FUT_OPT_BROK =1,        
   FUT_OPT_EXC =1,        
   FUT_OTHER_CHRGS =0,        
   FUT_SEBI_FEES =0,        
   FUT_STAMP_DUTY =0,        
   FUT_STT =0,        
   FUT_TRAN_CHRGS =0,        
   IMP_STATUS = 0,        
   INACTIVE_FROM = 'DEC 31 2049',        
   INST_CONTRACT = CASE TradeClubbingOn WHEN 'N' THEN 'N' WHEN 'S' THEN 'S' WHEN 'O' THEN 'O' ELSE 'S' END,        
   INST_DEL_BROK = 0,        
   INST_TRD_BROK = 0,        
   INTER_SETT = 0,        
   MAINTENANCE = 0,        
   MARKET_TYPE = 0,        
   MODIFIEDBY = 'DMS Migration',        
   MODIFIEDON = GetDate(),        
   MULTIPLIER = RoundingMultiplierForBrokerage,        
   NO_OF_COPIES = 0,        
   PARTICIPANT_CODE = '',        
   PAY_AC_NO = '',--LEFT(AccountNo, 10),        
   PAY_B3B_PAYMENT =1,        
   PAY_BANK_NAME = '',--LEFT(BankName,50),        
   PAY_BRANCH_NAME = '',--LEFT(BanksBranch,50),1        
   PAY_PAYMENT_MODE = 'C' ,        
   PRINT_OPTIONS = CASE PrintContract WHEN 'Y' THEN 1 ELSE 0 END,        
   REQD_BY_BROKER = 0,        
   REQD_BY_EXCH = 0,        
   ROUND_STYLE = 0,--dbo.fnGetRoundingStyle(),        
   ROUND_TO_DIGIT = BrokerageAccuracy,
   ROUND_TO_PAISE = (POWER(10, BrokerageAccuracy) * RoundingMultiplierForBrokerage),        
   ROUNDING_METHOD = CASE RoundBrokerageTo WHEN 'RU' THEN 'ACTUAL' WHEN 'TU' THEN 'NEXT' ELSE 'RU' END,        
   SEGMENT = 'FUTURES',        
   SER_TAX = CASE IncludeSTInBrokerage WHEN 'Y' THEN 2 ELSE 0 END,
   SER_TAX_METHOD = 0,        
   STATUS = 'U' ,        
   STP_PROVIDER = '',        
   STP_RP_STYLE = 0,        
   GETDATE() AS SYSTEMDATE,        
   TRD_BROK = 0,        
   TRD_EFF_DT = LEFT(GETDATE(),11) + ' 23:59:59',        
   TRD_OTHER_CHRGS = 0,        
   TRD_SEBI_FEES = 0,        
   TRD_STAMP_DUTY = 0,        
   TRD_STT = 0,   
   TRD_TRAN_CHRGS = 0,        
   'Y' AS VALID_CL_CODE, 
   'Y' AS VALID_PROFILE_ID, 
   -- VALID_CUSTODIAN = CASE WHEN ISNULL(CUSTODIAN_CODE, '') = '' THEN 'Y' ELSE 'N' END , 
	'Y' AS VALID_CUSTODIAN,
   'N' AS RECORD_FOUND, 
   'N' AS VALID_RECORD 
  FROM DMSClientDetails  
 WHERE ClientCode IN (SELECT Party_Code FROM #CLIENT_DETAILS WHERE VALID_RECORD = 'Y' AND MODIFIED = 'N')    
      
 IF @@ERROR <> 0         
 BEGIN        
  SET @pa_err = @@ERROR        
  RETURN        
 END        

/*
 --- Validate CL_CODE        
 UPDATE #CLIENT_BROK_DETAILS SET VALID_CL_CODE = 'Y'         
  FROM #CLIENT_BROK_DETAILS AS A, CLIENT_DETAILS AS B         
  WHERE A.CL_CODE = B.CL_CODE        
        
 IF @@ERROR <> 0         
 BEGIN        
  SET @pa_err = @@ERROR        
  RETURN        
 END        
      
 --- Validate PROFILE_ID        
 UPDATE #CLIENT_BROK_DETAILS SET VALID_PROFILE_ID = 'Y', PROFILE_ID = B.PROFILE_ID         
  FROM #CLIENT_BROK_DETAILS AS A, CLIENT_PROFILE AS B         
  WHERE A.EXCHANGE = B.EXCHANGE AND A.SEGMENT = B.SEGMENT         
--  AND A.PROFILE_ID = B.PROFILE_ID        
  AND UPPER(RTRIM(A.PROFILE_NAME)) = UPPER(RTRIM(B.PROFILE_NAME))
      
 IF @@ERROR <> 0         
 BEGIN        
  SET @pa_err = @@ERROR     
  RETURN        
 END        
*/

---- CUSTODIAN VALIDATION FOR BSE
 UPDATE #CLIENT_BROK_DETAILS SET VALID_CUSTODIAN = 'Y'         
  FROM #CLIENT_BROK_DETAILS AS A, BSEDB.DBO.CUSTODIAN AS B         
  WHERE A.EXCHANGE = 'BSE' AND A.SEGMENT = 'CAPITAL'        
  AND A.CUSTODIAN_CODE = B.CUSTODIANCODE  	
  AND ISNULL(A.CUSTODIAN_CODE, '') <> ''
	
---- CUSTODIAN VALIDATION FOR NSE
 UPDATE #CLIENT_BROK_DETAILS SET VALID_CUSTODIAN = 'Y'         
  FROM #CLIENT_BROK_DETAILS AS A, MSAJAG.DBO.CUSTODIAN AS B         
  WHERE A.EXCHANGE = 'NSE' AND A.SEGMENT = 'CAPITAL'        
  AND A.CUSTODIAN_CODE = B.CUSTODIANCODE  	
  AND ISNULL(A.CUSTODIAN_CODE, '') <> ''

---- CUSTODIAN VALIDATION FOR NSEFO
 UPDATE #CLIENT_BROK_DETAILS SET VALID_CUSTODIAN = 'Y'         
  FROM #CLIENT_BROK_DETAILS AS A, NSEFO.DBO.CUSTODIAN AS B         
  WHERE A.EXCHANGE = 'NSE' AND A.SEGMENT = 'FUTURES'        
  AND A.CUSTODIAN_CODE = B.CUSTODIANCODE  	
  AND ISNULL(A.CUSTODIAN_CODE, '') <> ''

---- CUSTODIAN VALIDATION FOR MCDX
 UPDATE #CLIENT_BROK_DETAILS SET VALID_CUSTODIAN = 'Y'         
  FROM #CLIENT_BROK_DETAILS AS A, MCDX.DBO.CUSTODIAN AS B         
  WHERE A.EXCHANGE = 'MCX' AND A.SEGMENT = 'FUTURES'        
  AND A.CUSTODIAN_CODE = B.CUSTODIANCODE  	
  AND ISNULL(A.CUSTODIAN_CODE, '') <> ''

---- CUSTODIAN VALIDATION FOR NCDX
 UPDATE #CLIENT_BROK_DETAILS SET VALID_CUSTODIAN = 'Y'         
  FROM #CLIENT_BROK_DETAILS AS A, NCDX.DBO.CUSTODIAN AS B         
  WHERE A.EXCHANGE = 'NCX' AND A.SEGMENT = 'FUTURES'        
  AND A.CUSTODIAN_CODE = B.CUSTODIANCODE  	
  AND ISNULL(A.CUSTODIAN_CODE, '') <> ''

 --- Check whether the record is present in CLIENT_BROK_DETAILS or Not        
 UPDATE #CLIENT_BROK_DETAILS SET RECORD_FOUND = 'Y'         
  FROM #CLIENT_BROK_DETAILS AS A, CLIENT_BROK_DETAILS AS B         
  WHERE A.CL_CODE = B.CL_CODE AND A.EXCHANGE = B.EXCHANGE         
  AND A.SEGMENT = B.SEGMENT AND A.VALID_CL_CODE = 'Y'         
  --AND A.PROFILE_ID = B.PROFILE_ID        
          
 IF @@ERROR <> 0         
 BEGIN        
  SET @pa_err = @@ERROR        
  RETURN        
 END        
        
 --- Update whether the record is valid or not        
 UPDATE #CLIENT_BROK_DETAILS SET         
  VALID_RECORD = CASE WHEN MODIFIED = 'N' AND RECORD_FOUND = 'N' THEN 'Y'   --- Record Addition        
          WHEN MODIFIED = 'M' AND RECORD_FOUND = 'Y' THEN 'Y'  				 --- Record Modification        
          WHEN MODIFIED = 'D' AND RECORD_FOUND = 'Y' THEN 'Y'   				 --- Record Deletion        
          ELSE 'N'         
       END        
 WHERE VALID_CL_CODE = 'Y' AND VALID_PROFILE_ID = 'Y' AND VALID_CUSTODIAN = 'Y'       
        
 IF @@ERROR <> 0         
 BEGIN        
  SET @pa_err = @@ERROR        
  RETURN        
 END        
        
/*																CLIENT PROFILE  
 --- UPDATE BROKERAGE & COMMON DETAILS        
 UPDATE #CLIENT_BROK_DETAILS SET         
  BROK_SCHEME = B.BROK_SCHEME,        
  CLIENT_RATING = B.CLIENT_RATING,        
  DEBIT_BALANCE = ISNULL(B.DEBIT_BALANCE,0),        
  INST_DEL_BROK = ISNULL(B.INSTDEL_TABLENO,0),        
  INST_TRD_BROK = ISNULL(B.INSTTRD_TABLENO,0),        
  INTER_SETT = ISNULL(B.INTER_SETTLEMENT,0),        
  ROUND_STYLE = ISNULL(B.ROUND_STYLE,0),        
  SER_TAX = ISNULL(B.SERVICE_TAX,0),        
  SER_TAX_METHOD = ISNULL(B.SERVICE_TAX_METHOD,0),        
  PRINT_OPTIONS = ISNULL(B.PRINT_OPTION,0),        
  TRD_BROK = ISNULL(B.TRD_TABLENO,0),        
  DEL_BROK = ISNULL(B.DEL_TABLENO,0)        
   FROM #CLIENT_BROK_DETAILS AS A, CLIENT_PROFILE AS B         
   WHERE A.VALID_RECORD = 'Y' AND A.EXCHANGE = B.EXCHANGE         
   AND A.SEGMENT = B.SEGMENT 
	--AND A.PROFILE_ID = B.PROFILE_ID         
   AND UPPER(RTRIM(A.PROFILE_NAME)) = UPPER(RTRIM(B.PROFILE_NAME))
*/
  
------------------------					Hard Coded Brokerage Scheme Table
/*
FOR NSE and BSE: 		
	Table No  ->1 is for Trading/Inst TRD		
	Table No  ->100 is for Del/Inst Del		
		
For NSEFO:		
	Table NO -->1 For fut and OPT 		
*/

 --- UPDATE BROKERAGE & COMMON DETAILS        
 UPDATE #CLIENT_BROK_DETAILS SET         
   BROK_SCHEME = 0, 											-- Default       
   CLIENT_RATING = 'HIG',        
   DEBIT_BALANCE = 0,        
   INST_DEL_BROK = CASE WHEN EXCHANGE = 'BSE' AND SEGMENT = 'CAPITAL' THEN 100  WHEN EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL' THEN 100  ELSE 0 END,
   INST_TRD_BROK = CASE WHEN EXCHANGE = 'BSE' AND SEGMENT = 'CAPITAL' THEN 1  WHEN EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL' THEN 1 ELSE 0 END,
   INTER_SETT = 0,        
   ROUND_STYLE = 0,        
   TRD_BROK = CASE WHEN EXCHANGE = 'BSE' AND SEGMENT = 'CAPITAL' THEN 1  WHEN EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL' THEN 1 ELSE 0 END,
   DEL_BROK = CASE WHEN EXCHANGE = 'BSE' AND SEGMENT = 'CAPITAL' THEN 100  WHEN EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL' THEN 100 ELSE 0 END,
	FUT_BROK = CASE WHEN EXCHANGE = 'NSE' AND SEGMENT = 'FUTURES' THEN 1 ELSE 0 END,
	FUT_OPT_BROK = CASE WHEN EXCHANGE = 'NSE' AND SEGMENT = 'FUTURES' THEN 1 ELSE 0 END,
	FUT_FUT_FIN_BROK  = CASE WHEN EXCHANGE = 'NSE' AND SEGMENT = 'FUTURES' THEN 1 ELSE 0 END,
	FUT_OPT_EXC = CASE WHEN EXCHANGE = 'NSE' AND SEGMENT = 'FUTURES' THEN 1 ELSE 0 END,
	FUT_BROK_APPLICABLE = 0 -- On Premium    --CASE WHEN EXCHANGE = 'NSE' AND SEGMENT = 'FUTURES' THEN 2 ELSE 0 END
  FROM #CLIENT_BROK_DETAILS
  WHERE VALID_RECORD = 'Y' 
    
 IF @@ERROR <> 0         
 BEGIN        
  SET @pa_err = @@ERROR        
  RETURN        
 END        
        
 --- UPDATE TRADING CHARGES DETAILS (FOR CASH & FUTURE)        
 UPDATE #CLIENT_BROK_DETAILS SET    
   TRD_OTHER_CHRGS = ISNULL(B.OTHER_CHRG,0),        
   TRD_SEBI_FEES = ISNULL(B.SEBITURN_TAX,0),        
   TRD_STAMP_DUTY = ISNULL(B.BROKER_NOTE,0),        
   TRD_STT = ISNULL(B.INSURANCE_CHRG,0),        
   TRD_TRAN_CHRGS = ISNULL(B.TURNOVER_TAX,0),
	FUT_OTHER_CHRGS = CASE WHEN ISNULL(B.OTHER_CHRG,0) > 0 THEN 1 ELSE  0 END,
   FUT_SEBI_FEES = CASE WHEN ISNULL(B.SEBITURN_TAX,0) > 0 THEN 1 ELSE  0 END,
   FUT_STAMP_DUTY = CASE WHEN ISNULL(B.BROKER_NOTE,0) > 0 THEN 1 ELSE  0 END,
   FUT_STT = CASE WHEN ISNULL(B.INSURANCE_CHRG,0) > 0 THEN 1 ELSE  0 END,
	FUT_TRAN_CHRGS = CASE WHEN ISNULL(B.TURNOVER_TAX,0) > 0 THEN 1 ELSE  0 END
   FROM #CLIENT_BROK_DETAILS AS A, CLIENT_MASTER_TAXES AS B         
   WHERE A.VALID_RECORD = 'Y' AND A.EXCHANGE = B.EXCHANGE         
   AND A.SEGMENT = B.SEGMENT AND B.TRANS_CAT IN ('TRD', 'FUT')        
        
 IF @@ERROR <> 0         
 BEGIN        
  SET @pa_err = @@ERROR        
  RETURN        
 END        
        
 --- UPDATE DELIVERY CHARGES DETAILS (FOR CASH & OPTIONS)         
 UPDATE #CLIENT_BROK_DETAILS SET         
   DEL_OTHER_CHRGS = ISNULL(B.OTHER_CHRG,0),        
   DEL_SEBI_FEES = ISNULL(B.SEBITURN_TAX,0),        
   DEL_STAMP_DUTY = ISNULL(B.BROKER_NOTE,0),        
   DEL_STT = ISNULL(B.INSURANCE_CHRG,0),        
   DEL_TRAN_CHRGS = ISNULL(B.TURNOVER_TAX,0),
	FUT_OTHER_CHRGS = CASE WHEN ISNULL(B.OTHER_CHRG,0) > 0 THEN 1 ELSE  0 END,
   FUT_SEBI_FEES = CASE WHEN ISNULL(B.SEBITURN_TAX,0) > 0 THEN 1 ELSE  0 END,
   FUT_STAMP_DUTY = CASE WHEN ISNULL(B.BROKER_NOTE,0) > 0 THEN 1 ELSE  0 END,
   FUT_STT = CASE WHEN ISNULL(B.INSURANCE_CHRG,0) > 0 THEN 1 ELSE  0 END,
	FUT_TRAN_CHRGS = CASE WHEN ISNULL(B.TURNOVER_TAX,0) > 0 THEN 1 ELSE 0 END
   FROM #CLIENT_BROK_DETAILS AS A, CLIENT_MASTER_TAXES AS B         
   WHERE A.VALID_RECORD = 'Y' AND A.EXCHANGE = B.EXCHANGE         
   AND A.SEGMENT = B.SEGMENT AND B.TRANS_CAT IN ('DEL', 'OPT')         
        
 IF @@ERROR <> 0         
 BEGIN        
  SET @pa_err = @@ERROR        
  RETURN        
 END        
    
 ---- Update Payment Details For All Branch    
 UPDATE #CLIENT_BROK_DETAILS SET    
    PAY_B3B_PAYMENT = 0,        
    PAY_AC_NO = B.CltCode,        
    PAY_BANK_NAME = B.AcName,        
    PAY_BRANCH_NAME = B.Branch,        
    PAY_PAYMENT_MODE = 'C'        
 FROM #CLIENT_BROK_DETAILS A, BranchPayMode B    
 WHERE A.EXCHANGE = B.EXCHANGE     
  AND A.SEGMENT = B.SEGMENT    
  AND BRANCH = 'ALL'    
    
 IF @@ERROR <> 0         
 BEGIN        
  SET @pa_err = @@ERROR        
  RETURN        
 END        
    
 ---- Update Payment Details For Specific Branch    
 UPDATE #CLIENT_BROK_DETAILS SET    
    PAY_B3B_PAYMENT = 0,        
    PAY_AC_NO = B.CltCode,        
    PAY_BANK_NAME = B.AcName,        
    PAY_BRANCH_NAME = B.Branch,        
    PAY_PAYMENT_MODE = 'C'      
 FROM #CLIENT_BROK_DETAILS A, BranchPayMode B, CLIENT_DETAILS C    
 WHERE A.CL_CODE = C.CL_CODE    
  AND A.EXCHANGE = B.EXCHANGE     
  AND A.SEGMENT = B.SEGMENT    
  AND C.BRANCH_CD = B.Branch    
    
 IF @@ERROR <> 0         
 BEGIN        
  SET @pa_err = @@ERROR        
  RETURN        
 END        
            
 --- INSERT THE RECORD INTO CLIENT_BROK_DETAILS        
 IF @pa_CanAddData = 1        
  INSERT INTO CLIENT_BROK_DETAILS        
  (        
   ACTIVE_DATE,        
   BROK_EFF_DATE,        
   BROK_SCHEME,        
   CHARGED,        
   CHECKACTIVECLIENT,        
   CL_CODE,        
   CLIENT_RATING,        
   CREDIT_LIMIT,        
   CUSTODIAN_CODE,        
   DEBIT_BALANCE,        
   DEL_BROK,        
   DEL_EFF_DT,        
   DEL_OTHER_CHRGS,        
   DEL_SEBI_FEES,        
   DEL_STAMP_DUTY,        
   DEL_STT,        
   DEL_TRAN_CHRGS,        
   EXCHANGE,        
   FUT_BROK,        
   FUT_BROK_APPLICABLE,        
   FUT_FUT_FIN_BROK,        
   FUT_OPT_BROK,        
   FUT_OPT_EXC,        
   FUT_OTHER_CHRGS,        
   FUT_SEBI_FEES,        
   FUT_STAMP_DUTY,        
   FUT_STT,        
   FUT_TRAN_CHRGS,        
   IMP_STATUS,        
   INACTIVE_FROM,        
   INST_CONTRACT,        
   INST_DEL_BROK,        
   INST_TRD_BROK,        
   INTER_SETT,        
   MAINTENANCE,        
   MARKET_TYPE,        
   MODIFIEDBY,        
   MODIFIEDON,        
   MULTIPLIER,        
   NO_OF_COPIES,        
   PARTICIPANT_CODE,        
   PAY_AC_NO,        
   PAY_B3B_PAYMENT,        
   PAY_BANK_NAME,        
   PAY_BRANCH_NAME,        
   PAY_PAYMENT_MODE,        
   PRINT_OPTIONS,        
   REQD_BY_BROKER,        
   REQD_BY_EXCH,        
   ROUND_STYLE,        
   ROUND_TO_DIGIT,        
   ROUND_TO_PAISE,        
   ROUNDING_METHOD,        
   SEGMENT,        
   SER_TAX,        
   SER_TAX_METHOD,        
   STATUS,        
   STP_PROVIDER,        
   STP_RP_STYLE,        
   SYSTEMDATE,        
   TRD_BROK,        
   TRD_EFF_DT,        
   TRD_OTHER_CHRGS,        
   TRD_SEBI_FEES,        
   TRD_STAMP_DUTY,        
   TRD_STT,        
   TRD_TRAN_CHRGS        
  )        
  SELECT        
   GETDATE() AS ACTIVE_DATE,        
   BROK_EFF_DATE,        
   BROK_SCHEME,        
   CHARGED,        
   CHECKACTIVECLIENT,        
   CL_CODE,        
   CLIENT_RATING,        
   CREDIT_LIMIT,        
   CUSTODIAN_CODE,        
   DEBIT_BALANCE,        
   DEL_BROK,        
   DEL_EFF_DT,        
   DEL_OTHER_CHRGS,        
   DEL_SEBI_FEES,        
   DEL_STAMP_DUTY,        
   DEL_STT,        
   DEL_TRAN_CHRGS,        
   EXCHANGE,        
   FUT_BROK,        
   FUT_BROK_APPLICABLE,        
   FUT_FUT_FIN_BROK,        
   FUT_OPT_BROK,        
   FUT_OPT_EXC,        
   FUT_OTHER_CHRGS,        
   FUT_SEBI_FEES,        
   FUT_STAMP_DUTY,        
   FUT_STT,        
   FUT_TRAN_CHRGS,        
   IMP_STATUS,        
   INACTIVE_FROM = 'DEC 31 2049', --CASE STATUS_FLAG WHEN 'ACTIVE' THEN 'DEC 31 2049' ELSE CONVERT(CHAR(11), GETDATE(), 109) END,        
   INST_CONTRACT,        
   INST_DEL_BROK,        
   INST_TRD_BROK,        
   INTER_SETT,        
   MAINTENANCE,        
   MARKET_TYPE,        
   MODIFIEDBY,        
   MODIFIEDON,        
   MULTIPLIER,        
   NO_OF_COPIES,        
   PARTICIPANT_CODE,        
   PAY_AC_NO,        
   PAY_B3B_PAYMENT,        
   PAY_BANK_NAME,        
   PAY_BRANCH_NAME,        
   PAY_PAYMENT_MODE,        
   PRINT_OPTIONS,        
   REQD_BY_BROKER,        
   REQD_BY_EXCH,        
   ROUND_STYLE,        
   ROUND_TO_DIGIT,        
   ROUND_TO_PAISE,        
   ROUNDING_METHOD,        
   SEGMENT,        
   SER_TAX,        
   SER_TAX_METHOD,        
   STATUS,        
   STP_PROVIDER,        
   STP_RP_STYLE,        
   GETDATE() AS SYSTEMDATE,        
   TRD_BROK,        
   TRD_EFF_DT,        
   TRD_OTHER_CHRGS,        
   TRD_SEBI_FEES,        
   TRD_STAMP_DUTY,        
   TRD_STT,   
   TRD_TRAN_CHRGS        
  FROM #CLIENT_BROK_DETAILS        
   WHERE VALID_RECORD = 'Y' AND MODIFIED = 'N'        
        
 IF @@ERROR <> 0         
 BEGIN        
  SET @pa_err = @@ERROR        
  RETURN        
 END        
        
 --- MODIFY THE EXISTING RECORD        
 IF @pa_CanModifyData =  1        
  UPDATE CLIENT_BROK_DETAILS SET         
   CHARGED = B.CHARGED,        
   CHECKACTIVECLIENT = B.CHECKACTIVECLIENT,        
   CUSTODIAN_CODE = B.CUSTODIAN_CODE,        
   FUT_BROK = B.FUT_BROK,        
   FUT_BROK_APPLICABLE = B.FUT_BROK_APPLICABLE,        
   FUT_FUT_FIN_BROK = B.FUT_FUT_FIN_BROK,        
   FUT_OPT_BROK = B.FUT_OPT_BROK,        
   FUT_OPT_EXC = B.FUT_OPT_EXC,        
   FUT_OTHER_CHRGS = B.FUT_OTHER_CHRGS,        
   FUT_SEBI_FEES = B.FUT_SEBI_FEES,        
   FUT_STAMP_DUTY = B.FUT_STAMP_DUTY,        
   FUT_STT = B.FUT_STT,        
   FUT_TRAN_CHRGS = B.FUT_TRAN_CHRGS,        
   IMP_STATUS = 0,        
   --INACTIVE_FROM NILL  
   INACTIVE_FROM = 'DEC 31 2049', --CASE B.STATUS_FLAG WHEN 'ACTIVE' THEN 'DEC 31 2049' ELSE CONVERT(CHAR(11), GETDATE(), 109) END,              
   INST_CONTRACT = B.INST_CONTRACT,        
   MAINTENANCE = B.MAINTENANCE,        
   MARKET_TYPE = B.MARKET_TYPE,        
   MODIFIEDBY = B.MODIFIEDBY,        
   MODIFIEDON = B.MODIFIEDON,        
   MULTIPLIER = B.MULTIPLIER,        
   NO_OF_COPIES = B.NO_OF_COPIES,        
 --   PARTICIPANT_CODE = B.PARTICIPANT_CODE,        
 --   PAY_AC_NO = B.PAY_AC_NO  ,        
 --   PAY_B3B_PAYMENT = B.PAY_B3B_PAYMENT ,        
 --   PAY_BANK_NAME = B.PAY_BANK_NAME,         
 --   PAY_BRANCH_NAME = B.PAY_BRANCH_NAME,         
 --   PAY_PAYMENT_MODE = B.PAY_PAYMENT_MODE,         
 --   REQD_BY_BROKER = B.REQD_BY_BROKER,        
 --   REQD_BY_EXCH = B.REQD_BY_EXCH,        
 --   ROUND_TO_DIGIT = B.ROUND_TO_DIGIT,        
 --   ROUND_TO_PAISE = B.ROUND_TO_PAISE,        
 --   ROUNDING_METHOD = B.ROUNDING_METHOD,        
   STATUS = 'U',         
 --   STP_PROVIDER = B.STP_PROVIDER,        
 --   STP_RP_STYLE = B.STP_RP_STYLE,        
   SYSTEMDATE = B.SYSTEMDATE,        
   TRD_EFF_DT = B.TRD_EFF_DT,        
   BROK_SCHEME = B.BROK_SCHEME,        
   TRD_BROK = B.TRD_BROK,        
   DEL_BROK = B.DEL_BROK,        
   SER_TAX = B.SER_TAX,        
   SER_TAX_METHOD = B.SER_TAX_METHOD,        
   ROUND_STYLE = B.ROUND_STYLE,        
   CLIENT_RATING = B.CLIENT_RATING,        
   DEBIT_BALANCE = B.CLIENT_RATING,        
   INTER_SETT = B.INTER_SETT,        
   TRD_STT = B.TRD_STT,        
   TRD_TRAN_CHRGS = B.TRD_TRAN_CHRGS,        
   TRD_SEBI_FEES = B.TRD_SEBI_FEES,        
   TRD_STAMP_DUTY = B.TRD_STAMP_DUTY,        
   TRD_OTHER_CHRGS = B.TRD_OTHER_CHRGS,        
   DEL_STT = B.DEL_STT,        
   DEL_TRAN_CHRGS = B.DEL_TRAN_CHRGS,        
   DEL_SEBI_FEES = B.DEL_SEBI_FEES,        
   DEL_STAMP_DUTY = B.DEL_STAMP_DUTY,        
   DEL_OTHER_CHRGS = B.DEL_OTHER_CHRGS,        
   DEL_EFF_DT = B.DEL_EFF_DT,        
   BROK_EFF_DATE = B.BROK_EFF_DATE,        
   INST_TRD_BROK = B.INST_TRD_BROK,        
	INST_DEL_BROK = B.INST_DEL_BROK,        
   ACTIVE_DATE = B.ACTIVE_DATE,        
   PRINT_OPTIONS = B.PRINT_OPTIONS        
    FROM CLIENT_BROK_DETAILS AS A, #CLIENT_BROK_DETAILS AS B         
    WHERE A.EXCHANGE = B.EXCHANGE AND A.SEGMENT = B.SEGMENT         
    AND A.CL_CODE = B.CL_CODE AND B.VALID_RECORD = 'Y'         
    AND B.MODIFIED = 'M'        
        
 IF @@ERROR <> 0         
 BEGIN        
  SET @pa_err = @@ERROR        
  RETURN        
 END        
         
 IF @pa_CanDeleteData = 1        
  --- REMOVE BROK DETAILS RECORDS        
  DELETE CLIENT_BROK_DETAILS FROM CLIENT_BROK_DETAILS AS A, #CLIENT_BROK_DETAILS AS B         
    WHERE A.EXCHANGE = B.EXCHANGE AND A.SEGMENT = B.SEGMENT         
    AND A.CL_CODE = B.CL_CODE AND B.VALID_RECORD = 'Y'         
    AND B.MODIFIED = 'D'         
        
 IF @@ERROR = 0         
  SET @pa_err = ''        
 ELSE        
  SET @pa_err = @@ERROR        
        
        
-- -- VALID_RECORD = 'Y' AND MODIFIED = 'N' ---- VALID INSERT        
-- -- VALID_RECORD = 'N' AND MODIFIED = 'N' ---- INVALID INSERT        
-- -- VALID_RECORD = 'Y' AND MODIFIED = 'M' ---- VALID MODIFY        
-- -- VALID_RECORD = 'N' AND MODIFIED = 'M' ---- INVALID MODIFY        
-- -- VALID_RECORD = 'Y' AND MODIFIED = 'D' ---- VALID DELETE        
-- -- VALID_RECORD = 'N' AND MODIFIED = 'D' ---- INVALID DELETE        
        
END        
        
        
/*        
        
        
DECLARE        
 @CanAddData AS Bit,        
 @CanModifyData AS Bit,        
 @CanDeleteData AS Bit,        
 @pa_err AS VarChar(250)         
        
SET @CanAddData = 1        
SET @CanModifyData = 1        
SET @CanDeleteData = 1        
        
EXEC Pr_Mig_DMS_Client_Brok_Details @CanAddData, @CanModifyData, @CanDeleteData,@pa_err OUTPUT        
        
SELECT * FROM #CLIENT_BROK_DETAILS        
        
SELECT * FROM CLIENT_BROK_DETAILS WHERE MODIFIEDBY = 'CITRUS-MIG'        
        
        
*/

GO
