-- Object: PROCEDURE dbo.RPT_KRA_CDSL_CLIENT_DATA_17032015_suresh
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

              
                        
                            
CREATE PROC [DBO].[RPT_KRA_CDSL_CLIENT_DATA_17032015_suresh]                            
 (                            
 @FROMDATE VARCHAR(11),                            
 @TODATE  VARCHAR(11),                            
 @FROMPARTY VARCHAR(15),                            
 @TOPARTY VARCHAR(15),                            
 @OPT_TYPE VARCHAR(2),                            
 @FROMBRANCH VARCHAR(15),                            
 @TOBRANCH VARCHAR(15),                            
 @STATUSID VARCHAR(15),                            
 @STATUSNAME VARCHAR(25),                            
 @BATCHDATE VARCHAR(15) = '',                            
 @USERNAME VARCHAR(20) = '',                            
 @CL_TYPE VARCHAR(1),                            
 @CL_FILTER INT = 0,                            
 @SESSIONID VARCHAR(12) = ''                            
 )                            
                            
 AS                            
                            
 ---EXEC RPT_KRA_CDSL_CLIENT_DATA 'JAN  1 2000','JAN 20 2012','','ZZZZZZZ','A','','ZZZZZZZZ','BROKER','BROKER','2012011701'                            
                            
 CREATE TABLE #CLIENT                            
  (                            
  PARTY_CODE VARCHAR(15),                            
  PAN_GIR_NO VARCHAR(20),                            
  SYSTEMDATE VARCHAR(11)                            
  )                            
                            
 DECLARE @BATCH_DATE VARCHAR(11)                            
 DECLARE @BATCH_NO VARCHAR(10)                            
 DECLARE @STARTKRA_DATE VARCHAR(11)                            
 DECLARE @ENDTKRA_DATE VARCHAR(11)                            
 DECLARE @POSCODE VARCHAR(20)                            
                            
 SET @BATCH_DATE = LEFT(@BATCHDATE,8)                            
 SET @BATCH_NO = RIGHT(@BATCHDATE,(LEN(@BATCHDATE)-LEN(@BATCH_DATE)))                            
 IF (@CL_TYPE = 'N')                             
 BEGIN                            
  SET @STARTKRA_DATE = 'JAN  1 2012'                            
  SET @ENDTKRA_DATE = LEFT(GETDATE(),11)                            
 END                             
 ELSE IF (@CL_TYPE = 'O')                             
 BEGIN                            
  SET @STARTKRA_DATE = @FROMDATE    
                        
 SET @ENDTKRA_DATE = 'JAN  1 2012'                            
 END                             
 SELECT @POSCODE = POS_CODE FROM OWNER(NOLOCK)                            
                            
 /*                            
 IF CONVERT(VARCHAR,CONVERT(DATETIME,@FROMDATE,109),112) < '20120101'                            
 BEGIN                            
  SET @FROMDATE = 'JAN  1 2012'                            
 END                            
 */                            
                            
 IF @TOPARTY = ''                            
 BEGIN                            
  SET @TOPARTY = 'ZZZZZZZZZ'                            
 END                            
                            
 IF @TOBRANCH = ''                            
 BEGIN                            
  SET @TOBRANCH = 'ZZZZZZZZZ'                            
 END                            
                            
 IF @OPT_TYPE = ''                            
 BEGIN                            
  SET @OPT_TYPE = 'A'                            
 END                             
                            
                            
 IF (@CL_FILTER = 1)                            
 BEGIN        
       
 print '01'                          
  SELECT                             
   PARTY_CODE =  (                            
   CASE                             
    WHEN ISNULL(CHARINDEX(',', 1),0) > 0 THEN LEFT(FILE_DATA,ISNULL(CHARINDEX(',',FILE_DATA, 1),0)-1)                             
    ELSE FILE_DATA                             
   END)                              
  INTO                            
   #SEL_PARTY        
  FROM CLASSFILEUPD WHERE SESSION_ID =  @SESSIONID                
  AND FILE_DATA NOT LIKE 'PARTY%'                            
                              
  INSERT INTO #CLIENT                            
  SELECT                            
   PARTY_CODE = S.PARTY_CODE,                             
   PAN_GIR_NO,                            
   SYSTEMDATE = CONVERT(VARCHAR(11),MIN(SYSTEMDATE),103)                            
  FROM                            
   CLIENT_DETAILS C (NOLOCK),                            
   CLIENT_BROK_DETAILS CB (NOLOCK),                            
   #SEL_PARTY S (NOLOCK)                            
  WHERE                            
   C.CL_CODE = CB.CL_CODE                            
   AND C.PARTY_CODE = S.PARTY_CODE                            
   AND EXCHANGE NOT IN ('MCX','NCX')                            
  GROUP BY                            
   S.PARTY_CODE,                             
   PAN_GIR_NO                            
 END                            
 ELSE                            
 BEGIN                            
 print '02'                          
  IF (@OPT_TYPE = 'M')                            
  BEGIN                            
   INSERT INTO #CLIENT                            
   SELECT                            
    PARTY_CODE,                             
    PAN_GIR_NO,                            
    SYSTEMDATE = CONVERT(VARCHAR(11),SYSTEMDATE,103)                            
   FROM                            
    CLIENT_DETAILS C (NOLOCK),                            
    (                            
    SELECT                             
     CL_CODE,                            
     INACTIVE_FROM = MAX(INACTIVE_FROM),                            
     ACTIVE_DATE  = MIN(ACTIVE_DATE),                            
     SYSTEMDATE  = MIN(SYSTEMDATE),                            
     MODIFIEDON  = MAX(MODIFIEDON)                            
    FROM                            
     CLIENT_BROK_DETAILS (NOLOCK)                            
    WHERE                             
     EXCHANGE NOT IN ('MCX','NCX')                            
    GROUP BY                            
     CL_CODE                            
    ) CB                            
   WHERE                            
    C.CL_CODE = CB.CL_CODE                            
    AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                            
    AND BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH                            
    AND C.MODIFIDEDON BETWEEN @FROMDATE AND @TODATE + ' 23:59'                              
    AND LEFT(SYSTEMDATE,11) <> LEFT(C.MODIFIDEDON,11)                            
    AND SYSTEMDATE >= @STARTKRA_DATE                            
    AND LEFT(C.CL_CODE,2) <> '98'                             
   GROUP BY                            
    PARTY_CODE,                             
    PAN_GIR_NO,                            
    CONVERT(VARCHAR(11),SYSTEMDATE,103)                            
                            
  END                            
  IF (@OPT_TYPE = 'S')                            
  BEGIN         
  print '03'                                             
   INSERT INTO #CLIENT                            
   SELECT                            
    PARTY_CODE,                             
    PAN_GIR_NO,                            
    SYSTEMDATE = CONVERT(VARCHAR(11),SYSTEMDATE,103)                           
   FROM                            
    CLIENT_DETAILS C (NOLOCK),                            
    (                            
    SELECT                             
     CL_CODE,                            
     INACTIVE_FROM = MAX(INACTIVE_FROM),                            
     ACTIVE_DATE  = MIN(ACTIVE_DATE),                            
     SYSTEMDATE  = MIN(SYSTEMDATE),                            
     MODIFIEDON  = MAX(MODIFIEDON)                            
    FROM                            
     CLIENT_BROK_DETAILS (NOLOCK)                            
    WHERE     
     EXCHANGE NOT IN ('MCX','NCX')                            
    GROUP BY                            
     CL_CODE                            
    ) CB                            
   WHERE                            
    C.CL_CODE = CB.CL_CODE                            
    AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY      
    AND BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH                            
    AND ACTIVE_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59'                              
    AND INACTIVE_FROM NOT BETWEEN @FROMDATE AND @TODATE + ' 23:59'                              
    AND SYSTEMDATE >= @STARTKRA_DATE                            
    AND LEFT(C.CL_CODE,2) <> '98'                            
                                
   GROUP BY                            
    PARTY_CODE,                             
    PAN_GIR_NO,                            
    CONVERT(VARCHAR(11),SYSTEMDATE,103)                            
  END                            
                            
  IF (@OPT_TYPE = 'I')                            
  BEGIN          
  print '04'                                            
   INSERT INTO #CLIENT                            
   SELECT                            
    PARTY_CODE,                             
    PAN_GIR_NO,                            
    SYSTEMDATE = CONVERT(VARCHAR(11),SYSTEMDATE,103)                            
   FROM                            
    CLIENT_DETAILS C (NOLOCK),                            
    (                            
    SELECT                             
     CL_CODE,                            
     INACTIVE_FROM = MAX(INACTIVE_FROM),                            
     ACTIVE_DATE  = MIN(ACTIVE_DATE),                            
     SYSTEMDATE  = MIN(SYSTEMDATE),                            
     MODIFIEDON  = MAX(MODIFIEDON)                            
    FROM                            
     CLIENT_BROK_DETAILS (NOLOCK)                            
    WHERE                             
     EXCHANGE NOT IN ('MCX','NCX')                            
    GROUP BY                            
     CL_CODE                            
    ) CB                            
   WHERE                            
    C.CL_CODE = CB.CL_CODE                            
    AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                            
    AND BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH                            
    AND INACTIVE_FROM BETWEEN @FROMDATE AND @TODATE + ' 23:59'                              
    AND SYSTEMDATE >= @STARTKRA_DATE                            
    AND LEFT(C.CL_CODE,2) <> '98'                             
                                
   GROUP BY                         
    PARTY_CODE,                             
    PAN_GIR_NO,                            
    CONVERT(VARCHAR(11),SYSTEMDATE,103)                            
                            
  END                            
  IF (@OPT_TYPE = 'A' OR @OPT_TYPE = 'T')                            
  BEGIN          
  print '05'                                            
   INSERT INTO #CLIENT                            
   SELECT                            
    PARTY_CODE,                             
    PAN_GIR_NO,                            
    SYSTEMDATE = CONVERT(VARCHAR(11),SYSTEMDATE,103)                            
   FROM                         
    CLIENT_DETAILS C (NOLOCK),                            
    (                            
    SELECT                             
     CL_CODE,                            
     INACTIVE_FROM = MAX(INACTIVE_FROM),                            
     ACTIVE_DATE  = MIN(ACTIVE_DATE),                            
     SYSTEMDATE  = MIN(SYSTEMDATE),                            
     MODIFIEDON  = MAX(MODIFIEDON)                            
    FROM                            
     CLIENT_BROK_DETAILS (NOLOCK)                            
    WHERE                             
     EXCHANGE NOT IN ('MCX','NCX')                   
    GROUP BY                            
     CL_CODE                            
    ) CB                            
   WHERE                            
    C.CL_CODE = CB.CL_CODE                            
    AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                            
    AND BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH                            
    AND SYSTEMDATE >= @STARTKRA_DATE                            
    AND ACTIVE_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59'                            
    AND INACTIVE_FROM > ACTIVE_DATE                            
    AND LEFT(C.CL_CODE,2) <> '98'                            
                                
   GROUP BY                     
    PARTY_CODE,                             
    PAN_GIR_NO,                            
    CONVERT(VARCHAR(11),SYSTEMDATE,103)                            
  END               
                
                            
                            
  IF (@OPT_TYPE = 'T')                            
  BEGIN          
  print '06'                                            
   CREATE TABLE #TCLIENT                           
   (                            
    PARTY_CODE VARCHAR(15)                            
   )                             
                               
   INSERT INTO #TCLIENT                            
   SELECT                            
    DISTINCT                            
    PARTY_CODE                            
   FROM                            
    CMBILLVALAN C (NOLOCK)                            
   WHERE                            
    SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'                            
    AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                            
    AND BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH                            
                            
   UNION                            
                            
   SELECT                            
    DISTINCT                            
    PARTY_CODE                            
   FROM                            
    BSEDB_AB.DBO.CMBILLVALAN C (NOLOCK)                            
   WHERE                            
    SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'                            
    AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                            
    AND BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH                            
                                  
   UNION                            
                            
   SELECT                            
    DISTINCT                            
PARTY_CODE                            
   FROM                            
    NSEFO.DBO.FOBILLVALAN C (NOLOCK)                            
   WHERE                            
    SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'                            
    AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                            
    AND BRANCH_CODE BETWEEN @FROMBRANCH AND @TOBRANCH                            
                                
   DELETE FROM #CLIENT                             
   WHERE PARTY_CODE NOT IN (SELECT PARTY_CODE FROM #TCLIENT)                            
  END                            
                            
 END                            
                             
 /* ---  INSERT DISTINCT PARTY CODE --- */                            
                            
 SELECT                             
  DISTINCT                             
  PAN_GIR_NO,                             
  PARTY_CODE,                             
  FAMILY                             
 INTO                             
  #CLIENT_NEW                            
 FROM                             
  CLIENT_DETAILS (NOLOCK)                            
 WHERE                             
  PAN_GIR_NO <> ''                            
  AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                              
  /*AND PARTY_CODE NOT IN                             
   (                            
   SELECT                             
    DISTINCT                    
    PARTY_CODE                            
   FROM                             
    TBL_KRA_LOG T                            
   WHERE                             
    SRNO IN (SELECT MAX(SRNO) FROM TBL_KRA_LOG T1 (NOLOCK) WHERE T.PARTY_CODE = T1.PARTY_CODE)                            
    AND ISNULL(I_STATUS,1) = 0                            
   )   */                         
  AND PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #CLIENT (NOLOCK))                            
                            
 SELECT                             
  DISTINCT                             
  PAN_GIR_NO,                             
  FAMILY         
 INTO                             
  #CLIENT1                            
 FROM                             
  #CLIENT_NEW                            
 WHERE                             
  PAN_GIR_NO IN ( SELECT PAN_GIR_NO FROM #CLIENT_NEW GROUP BY PAN_GIR_NO HAVING COUNT(1) > 1 )                            
                 
 SELECT                             
  PAN_GIR_NO,                            
  PARTY_CODE                             
 INTO                             
  #FINAL_CLIENT                            
 FROM                             
  #CLIENT_NEW                            
 WHERE                             
  PAN_GIR_NO NOT IN (SELECT PAN_GIR_NO FROM #CLIENT_NEW GROUP BY PAN_GIR_NO HAVING COUNT(1) > 1 )         
                            
 INSERT INTO #FINAL_CLIENT                            
 SELECT                             
  PAN_GIR_NO,                             
  FAMILY                             
 FROM                             
  #CLIENT1                            
 WHERE                             
  PAN_GIR_NO NOT IN (SELECT PAN_GIR_NO FROM #CLIENT1 GROUP BY PAN_GIR_NO HAVING COUNT(1) > 1 )                            
                            
 INSERT INTO #FINAL_CLIENT                            
 SELECT                             
  PAN_GIR_NO,                             
  FAMILY=MIN(FAMILY)                             
 FROM                             
  #CLIENT1                            
 WHERE                             
  PAN_GIR_NO IN (SELECT PAN_GIR_NO FROM #CLIENT1 GROUP BY PAN_GIR_NO HAVING COUNT(1) > 1 )                            
 GROUP BY PAN_GIR_NO, FAMILY                            
                            
 /* ---  INSERT DISTINCT PARTY CODE --- */                    
            
                    
                            
 SELECT                            
  COMPANY_CODE = (CASE WHEN @POSCODE = '' THEN 'CDSL' ELSE @POSCODE END),                            
  BATCH_DATE  = CONVERT(VARCHAR(11),GETDATE(),103),                            
  APP_UPDTFLG  = (                
  CASE                
   WHEN @CL_TYPE = 'N' THEN '01'                
 ELSE '07'                
  END),                            
  APP_POS_CODE = (CASE WHEN @POSCODE = '' THEN 'CDSL' ELSE @POSCODE END),          
            
 -- APP_TYPE  = ISNULL(CU.CATEGORY,'') ,          
            
 APP_TYPE  = (CASE WHEN @CL_TYPE = 'N' THEN ISNULL(CU.CATEGORY,'')           
     ELSE CASE WHEN  ISNULL(C.CL_STATUS,'N')= 'IND' THEN 'I'           
        ELSE 'N'           
        END           
     END),                             
           
                            
  APP_NO   = ISNULL(CU.FORMNO,''), --C.PARTY_CODE,                         
  APP_DATE  = SYSTEMDATE,                            
  APP_PAN_NO = PAN_GIR_NO,                            
  APP_PAN_COPY = (                            
  CASE                             
   WHEN PAN_GIR_NO <> '' THEN 'Y'                            
   ELSE 'N'                            
  END),                            
  APP_EXMT  = ISNULL(CU.PAN_EXEMPT,'N'),                            
  APP_EXMT_CAT = (                            
  CASE                             
   WHEN ISNULL(CU.PAN_EXEMPT,'N') = 'Y' THEN ISNULL(CU.PAN_EXEMPT_CATEGORY,'')                            
   ELSE ''                            
  END),                            
  APP_EXMT_ID_PROOF = ISNULL(CU.PROOF_OF_ID,''),                            
  APP_IPV_FLAG = (                            
  CASE                             
   WHEN CU.CATEGORY = 'I' THEN                            
    /*(CASE                            
     WHEN (DEALING_WITH_OTHER_TM = '' OR DEALING_WITH_OTHER_TM ='N') THEN 'N'                             
     ELSE 'Y'                             
     END)*/                            
    ISNULL(IN_PERSON,'N')                            
   ELSE ''                             
END),                            
  APP_IPV_DATE = (                            
  CASE                             
   WHEN CU.CATEGORY = 'I' THEN                        
    ISNULL(CONVERT(VARCHAR(11),IN_PERSON_DATE,103),'')                            
   ELSE ''                             
  END),                      
 /* APP_GEN   = (                            
  CASE                             
   WHEN CU.CATEGORY = 'I' THEN SEX                            
   ELSE ''                            
  END), */          
            
            
   APP_GEN  = (CASE WHEN @CL_TYPE = 'N' THEN CASE                             
                                              WHEN CU.CATEGORY = 'I' THEN SEX                            
                                              ELSE ''                            
                                              END           
     ELSE CASE WHEN  ISNULL(C.CL_STATUS,'N')= 'IND' THEN SEX          
             ELSE ''           
        END           
     END),                             
           
            
                             
  APP_NAME  = LONG_NAME,                            
  APP_F_NAME  = (                            
  CASE                             
   WHEN CU.CATEGORY = 'I' THEN ISNULL(FATHERNAME,'')                            
   ELSE ''                            
  END),                            
  APP_REGNO = (                            
  CASE                             
   WHEN CU.CATEGORY = 'I' THEN ''                            
   ELSE LEFT(REGR_NO,30)                            
  END),               
  APP_DOB_INCORP = (                            
  CASE                             
   WHEN CU.CATEGORY = 'I' THEN CONVERT(VARCHAR(11),DOB,103)                            
   ELSE CONVERT(VARCHAR(11),CLIENT_AGREEMENT_ON,103)                            
  END),                            
  APP_COMMENCE_DT = (                            
  CASE                             
   WHEN CU.CATEGORY = 'I' THEN ''                            
   ELSE ISNULL(CONVERT(VARCHAR(11),CU.DATEOFCOMMENCMENT,103),'')                            
  END),           
            
            
  /*                           
  APP_NATIONALITY = (                            
  CASE                             
   WHEN CU.CATEGORY = 'I' THEN ISNULL(CU.NATIONALITY,'')                             
   ELSE ''                            
  END), */          
            
    APP_NATIONALITY  = (CASE WHEN @CL_TYPE = 'N' THEN CASE WHEN CU.CATEGORY = 'I' THEN ISNULL(CU.NATIONALITY,'')                             
                                                      ELSE ''                      
                                                      END          
                                                          
                        ELSE CASE WHEN  ISNULL(C.CL_STATUS,'N')= 'IND' THEN '01'           
                    ELSE ''           
                    END           
               END),          
               
          
                                
  APP_OTH_NATIONALITY = (                            
  CASE                             
   WHEN CU.CATEGORY = 'I' THEN ISNULL(CU.NATIONALITY_OTHER,'')                             
   ELSE ''                            
  END),                            
  APP_COMP_STATUS = (                            
  CASE                             
   WHEN CU.CATEGORY = 'N' THEN ISNULL(CU.STATUS,'')                  
   ELSE ''                            
  END),            
  APP_OTH_COMP_STATUS = (                            
  CASE                             
   WHEN CU.CATEGORY = 'N' THEN ISNULL(CU.STATUS_OTHER,'')                                 
   ELSE ''                            
  END),                            
  APP_RES_STATUS = (                            
  CASE                             
   WHEN CU.CATEGORY = 'I' THEN ISNULL(CU.RES_STATUS_IND,'')                             
   ELSE ''                            
  END),                            
  APP_RES_STATUS_PROOF = (                
  CASE                
   WHEN @CL_TYPE = 'N' THEN ''                
 ELSE '32'                
  END),                            
  APP_UID_NO  = ISNULL(CU.AADHAR_UID,''),                            
  APP_COR_ADD1 = ISNULL(L_ADDRESS1,''),                            
  APP_COR_ADD2 = ISNULL(L_ADDRESS2,''),                            
  APP_COR_ADD3 = ISNULL(L_ADDRESS3,''),                            
  APP_COR_CITY = ISNULL(L_CITY,''),              
  APP_COR_PINCD = ISNULL(L_ZIP,''),                            
  APP_COR_STATE = ISNULL(L_STATE,''),                            
  APP_COR_CTRY = ISNULL(L_NATION,''),                            
  APP_OFF_ISD  = '',                            
  APP_OFF_STD  = '',                            
  APP_OFF_NO  = ISNULL(OFF_PHONE1,''),                            
  APP_RES_ISD  = '',                            
  APP_RES_STD  = '',                            
  APP_RES_NO  = ISNULL(RES_PHONE1,''),                            
  APP_MOB_ISD  = '',                            
  APP_MOB_NO  = ISNULL(MOBILE_PAGER,''),                            
  APP_FAX_ISD  = '',                            
  APP_FAX_STD  = '',                            
  APP_FAX_NO  = ISNULL(FAX,''),                            
  APP_EMAIL  = ISNULL(EMAIL,''),                            
  --APP_COR_ADD_PROOF = ISNULL(CU.PROOF_OF_ADDRESS,''),                            
  APP_COR_ADD_PROOF = (                
  CASE                
   WHEN @CL_TYPE = 'N' THEN ISNULL(CU.PROOF_OF_ADDRESS,'')                
 ELSE '32'                
  END),                
  APP_COR_ADD_REF = ISNULL(CU.COR_ADD_PROOF_REF_ID,''),                            
  APP_COR_ADD_DT = ISNULL(CONVERT(VARCHAR(11),CU.COR_ADDRESS_PROOF_REF_DATE,103),''),                            
                            
  APP_PER_ADD_FLAG= (                            
  CASE                            
   WHEN ISNULL(P_ADDRESS1,'') = '' THEN 'Y'                            
   ELSE 'N'                            
  END),                            
  APP_PER_ADD1 = (                            
  CASE                            
   WHEN ISNULL(P_ADDRESS1,'') = '' THEN ISNULL(L_ADDRESS1,'')                            
   ELSE ISNULL(P_ADDRESS1,'')                            
  END),                            
  APP_PER_ADD2 = (                            
  CASE                            
   WHEN ISNULL(P_ADDRESS1,'') = '' THEN ISNULL(L_ADDRESS2,'')                            
   ELSE ISNULL(P_ADDRESS2,'')                            
  END),                            
  APP_PER_ADD3 = (                            
  CASE                            
   WHEN ISNULL(P_ADDRESS1,'') = '' THEN ISNULL(L_ADDRESS3,'')                            
   ELSE ISNULL(P_ADDRESS3,'')                            
  END),                            
  APP_PER_CITY = (                            
  CASE                            
   WHEN ISNULL(P_ADDRESS1,'') = '' THEN ISNULL(L_CITY,'')             
   ELSE ISNULL(P_CITY,'')                            
  END),                            
  APP_PER_PINCD = (                            
  CASE                            
   WHEN ISNULL(P_ADDRESS1,'') = '' THEN ISNULL(L_ZIP,'')                            
   ELSE ISNULL(P_ZIP,'')                            
  END),                            
  APP_PER_STATE = (                            
  CASE               
   WHEN ISNULL(P_ADDRESS1,'') = '' THEN ISNULL(L_STATE,'')                            
   ELSE ISNULL(P_STATE,'')                            
  END),                            
  APP_PER_CTRY = (                            
  CASE                            
   WHEN ISNULL(P_ADDRESS1,'') = '' THEN ISNULL(L_NATION,'')                            
   ELSE ISNULL(P_NATION,'')                            
  END),                            
  APP_PER_ADD_PROOF = ISNULL(CU.PERMFOREIGN_ADDRESS_PROFF,''),                            
  APP_PER_ADD_REF = ISNULL(PERMFOREIGN_REFID,''),                            
  APP_PER_ADD_DT = ISNULL(CONVERT(VARCHAR(11),CU.PERMFOREIGN_REFID_DATE,103),''),                            
                            
  APP_INCOME  = ISNULL(CU.GROSS_INCOME,''),                            
 /* APP_OCC   = (                            
  CASE                             
   WHEN CU.CATEGORY = 'I' THEN ISNULL(CU.OCCUPATION,'')                            
   ELSE ''                            
  END),   */                  
                    
  APP_OCC   = (                
  CASE                
   WHEN @CL_TYPE = 'N' THEN                 
 CASE                     
     WHEN CU.CATEGORY = 'I' THEN ISNULL(CU.OCCUPATION,'')                
     ELSE ''                
   END                
 ELSE '99'                
  END),                
  APP_OTH_OCC  = (                            
  CASE                             
   WHEN CU.CATEGORY = 'I' THEN ISNULL(CU.OCCUPATION_OTHER,'')                       
   ELSE ''                            
  END),                            
  APP_POL_CONN = ISNULL(CU.PEP,''),                            
  APP_DOC_PROOF = ISNULL(CU.DOCUMENTS,''),                            
  APP_INTERNAL_REF= C.PARTY_CODE,                            
  APP_BRANCH_CODE = BRANCH_CD,                            
  APP_MAR_STATUS = ISNULL(CU.MARITALSTATUS,''),                            
  APP_NETWRTH  = ISNULL(CU.NET_WORTH,0),                            
  APP_NETWORTH_DT = ISNULL(CONVERT(VARCHAR(11),CU.NET_WORTH_DATE,103),''),                            
  APP_INCORP_PLC = (                            
  CASE                             
   WHEN CU.CATEGORY = 'I' THEN ''                            
   ELSE ISNULL(CU.PLACEOFINCORPRATION,'')                            
  END),                            
  APP_OTHERINFO = '',                            
  APP_FILLER1  = '',                            
  APP_FILLER2  = '',                            
  APP_FILLER3  = '',                            
  APP_FILE_FLAG = 1,                  
  APP_ACC_OPENDT=SYSTEMDATE,                  
  APP_ACC_ACTIVEDT=SYSTEMDATE,                  
  APP_ACC_UPDTDT = SYSTEMDATE,                          
                            
  /* --- RESPONSE FILE TAG --- */                            
  APP_STATUS = '',                            
  APP_STATUSDT = '',                            
  APP_ERROR_DESC = '',                            
  APP_DUMP_TYPE = '',                            
  APP_DNLDDT  = CONVERT(VARCHAR(11),GETDATE(),103),                            
  /* --- RESPONSE FILE TAG --- */                            
                            
  APP_ADDLDATA_UPDTFLG  = CONVERT(VARCHAR(2),''),                             
  APP_ENTITY_PAN    = CONVERT(VARCHAR(20),''),                            
  APP_ADDLDATA_PAN   = CONVERT(VARCHAR(20),''),                            
  APP_ADDLDATA_NAME   = CONVERT(VARCHAR(120),''),                   
  APP_DIN_UID     = CONVERT(VARCHAR(12),''),                            
  APP_ADDLDATA_RELATIONSHIP = CONVERT(VARCHAR(2),''),                            
  APP_ADDLDATA_POLCONN  = CONVERT(VARCHAR(4),''),                            
  APP_ADDLDATA_FILLER1  = CONVERT(VARCHAR(20),''),                            
  APP_ADDLDATA_FILLER2  = CONVERT(VARCHAR(20),''),                            
  APP_ADDLDATA_FILLER3  = CONVERT(VARCHAR(20),'')                            
                            
  /* --- RESPONSE FILE ADDITIONAL TAG --- */                            
  ,APP_ADDLDATA_STATUS  = CONVERT(VARCHAR(2),''),                   
  APP_ADDLDATA_STATUSDT  = CONVERT(DATETIME,''),                            
  APP_ADDLDATA_ERROR_DESC  = CONVERT(VARCHAR(20),''),                            
  APP_ADDLDATA_DUMP_TYPE  = CONVERT(VARCHAR(2),''),                            
  APP_ADDLDATA_DNLDDT   = CONVERT(DATETIME,'')                            
  /* --- RESPONSE FILE ADDITIONAL TAG --- */                            
                            
 INTO                            
  #KRADATA                            
                     
 FROM                            
  CLIENT_DETAILS C (NOLOCK)                            
   LEFT OUTER JOIN CLIENTSTATUS CS (NOLOCK)                            
   ON                             
    ( C.CL_STATUS = CS.CL_STATUS ),                            
 CLIENT_MASTER_UCC_DATA CU (NOLOCK),                            
                            
                          
  (                             
  SELECT                             
   DISTINCT F.PARTY_CODE, SYSTEMDATE                             
  FROM                             
#CLIENT C,                             
   #FINAL_CLIENT F                             
  WHERE                             
   C.PARTY_CODE = F.PARTY_CODE                             
   AND C.PAN_GIR_NO = F.PAN_GIR_NO                             
  ) CB                      
                            
 WHERE                            
  C.PARTY_CODE = CB.PARTY_CODE                            
  AND C.PARTY_CODE = CU.PARTY_CODE                            
         AND @STATUSNAME = (                            
         CASE                            
   WHEN @STATUSID = 'BRANCH'                            
   THEN C.BRANCH_CD                            
   WHEN @STATUSID = 'SUBBROKER'                            
   THEN C.SUB_BROKER                            
   WHEN @STATUSID = 'TRADER'                            
   THEN C.TRADER                            
   WHEN @STATUSID = 'FAMILY'                            
   THEN C.FAMILY                            
   WHEN @STATUSID = 'AREA'                            
   THEN C.AREA                            
   WHEN @STATUSID = 'REGION'                            
   THEN C.REGION                            
   WHEN @STATUSID = 'CLIENT'                            
   THEN C.PARTY_CODE                            
   ELSE 'BROKER'                             
  END)                            
 ORDER BY                            
  C.PARTY_CODE                     
                      
                       
                            
                            
 UPDATE #KRADATA SET                             
  APP_COR_CTRY = ISNULL(CODE,'')                            
 FROM                             
  CLIENT_STATIC_CODES                            
 WHERE                
  APP_COR_CTRY = DESCRIPTION                            
  AND KRA_TYPE = 'CDSL'                        
  AND CATEGORY = 'COUNTRY'                            
                            
 UPDATE #KRADATA SET                             
  APP_PER_CTRY = ISNULL(CODE,'')                            
 FROM                             
  CLIENT_STATIC_CODES                            
 WHERE                             
  APP_PER_CTRY = DESCRIPTION                            
  AND KRA_TYPE = 'CDSL'                            
  AND CATEGORY = 'COUNTRY'                            
                            
 UPDATE #KRADATA SET                             
  APP_COR_STATE = ISNULL(CODE,'')                            
 FROM                             
  CLIENT_STATIC_CODES                            
 WHERE                             
  APP_COR_STATE = DESCRIPTION                            
  AND KRA_TYPE = 'CDSL'                            
  AND CATEGORY = 'STATE'                            
                            
 UPDATE #KRADATA SET                             
  APP_PER_STATE = ISNULL(CODE,'')                            
 FROM                             
  CLIENT_STATIC_CODES                            
 WHERE               
  APP_PER_STATE = DESCRIPTION                            
  AND KRA_TYPE = 'CDSL'                            
  AND CATEGORY = 'STATE'                            
                            
 UPDATE #KRADATA SET                             
  APP_RES_STATUS = (                            
  CASE                            
   WHEN APP_RES_STATUS = '01' THEN 'R'                            
   WHEN APP_RES_STATUS = '02' THEN 'N'                            
   WHEN APP_RES_STATUS = '03' THEN 'P'                            
   ELSE APP_RES_STATUS                            
  END)                            
 FROM                            
  CLIENT_STATIC_CODES                            
 WHERE                             
  KRA_TYPE = 'CDSL'                            
  AND CATEGORY = 'RESSTATUS'                            
                            
 INSERT INTO #KRADATA                              
 SELECT                            
  COMPANY_CODE = '',                            
  BATCH_DATE  = '',                            
  APP_UPDTFLG  = '',                            
  APP_POS_CODE = '',                            
  APP_TYPE  = '',                            
  APP_NO   = '',                            
  APP_DATE  = '',                            
  APP_PAN_NO  = '',                          
  APP_PAN_COPY = '',                            
  APP_EXMT  = '',                            
  APP_EXMT_CAT = '',                            
  APP_EXMT_ID_PROOF = '',                            
  APP_IPV_FLAG = '',                            
  APP_IPV_DATE = '',                            
  APP_GEN   = '',                            
  APP_NAME  = '',                            
  APP_F_NAME  = '',                            
  APP_REGNO  = '',                            
  APP_DOB_INCORP = '',                            
  APP_COMMENCE_DT = '',                            
  APP_NATIONALITY = '',                            
  APP_OTH_NATIONALITY = '',                            
  APP_COMP_STATUS = '',                            
  APP_OTH_COMP_STATUS = '',                            
  APP_RES_STATUS = '',                            
  APP_RES_STATUS_PROOF= '',                            
  APP_UID_NO  = '',                            
  APP_COR_ADD1 = '',                            
  APP_COR_ADD2 = '',               
  APP_COR_ADD3 = '',                            
  APP_COR_CITY = '',                            
  APP_COR_PINCD = '',                            
  APP_COR_STATE = '',                            
  APP_COR_CTRY = '',                            
  APP_OFF_ISD  = '',                            
  APP_OFF_STD  = '',                            
  APP_OFF_NO  = '',                            
  APP_RES_ISD  = '',                            
  APP_RES_STD  = '',                            
  APP_RES_NO  = '',                            
  APP_MOB_ISD  = '',                            
  APP_MOB_NO  = '',                            
  APP_FAX_ISD  = '',                            
  APP_FAX_STD  = '',                            
  APP_FAX_NO  = '',                            
  APP_EMAIL  = '',                           
  APP_COR_ADD_PROOF= '',                            
  APP_COR_ADD_REF = '',                            
  APP_COR_ADD_DT = '',                            
                            
  APP_PER_ADD_FLAG= '',                            
  APP_PER_ADD1 = '',                            
  APP_PER_ADD2 = '',                            
  APP_PER_ADD3 = '',                            
  APP_PER_CITY = '',                            
  APP_PER_PINCD = '',                            
  APP_PER_STATE = '',                            
  APP_PER_CTRY = '',                            
  APP_PER_ADD_PROOF= '',                          
  APP_PER_ADD_REF = '',                            
  APP_PER_ADD_DT = '',                            
                            
  APP_INCOME  = '',                            
  APP_OCC   = '',                            
  APP_OTH_OCC  = '',                            
  APP_POL_CONN = '',                            
  APP_DOC_PROOF = '',                            
  APP_INTERNAL_REF= C.CL_CODE,                            
  APP_BRANCH_CODE = '',                            
  APP_MAR_STATUS = '',                            
  APP_NETWRTH  = 0,                            
  APP_NETWORTH_DT = '',                            
  APP_INCORP_PLC = '',                            
  APP_OTHERINFO = '',                            
  APP_FILLER1  = '',                            
  APP_FILLER2  = '',                            
  APP_FILLER3  = '',                            
  APP_FILE_FLAG = 2,                  
  APP_ACC_OPENDT='',                  
  APP_ACC_ACTIVEDT='',                  
  APP_ACC_UPDTDT = '',                             
                            
  /* --- RESPONSE FILE COMMON TAG --- */                            
  APP_STATUS  = '',                            
  APP_STATUSDT = '',                            
  APP_ERROR_DESC = '',                            
  APP_DUMP_TYPE = '',                            
  APP_DNLDDT  = '',             
  /* --- RESPONSE FILE COMMON TAG --- */                            
                            
  APP_ADDLDATA_UPDTFLG  = '01',                             
  APP_ENTITY_PAN    = ISNULL(K.APP_PAN_NO,''),                            
  APP_ADDLDATA_PAN   = ISNULL(PANNO,''),                            
  APP_ADDLDATA_NAME   = ISNULL(CONTACT_NAME,''),                            
  APP_DIN_UID     = '',                            
APP_ADDLDATA_RELATIONSHIP = ISNULL(RELATIONSHIP,''),                            
 APP_ADDLDATA_POLCONN  = ISNULL(POLTICAL_CONNECTION,''),                            
  APP_ADDLDATA_FILLER1  = '',                            
  APP_ADDLDATA_FILLER2  = '',                            
  APP_ADDLDATA_FILLER3  = ''                            
                            
  /* --- RESPONSE FILE ADDITIONAL TAG --- */                            
  ,APP_ADDLDATA_STATUS  = '',                            
  APP_ADDLDATA_STATUSDT  = '',                            
  APP_ADDLDATA_ERROR_DESC  = '',                            
  APP_ADDLDATA_DUMP_TYPE  = '',                            
  APP_ADDLDATA_DNLDDT   = ''                            
  /* --- RESPONSE FILE ADDITIONAL TAG --- */                            
 FROM                            
  CLIENT_CONTACT_DETAILS C (NOLOCK),                            
  #KRADATA K (NOLOCK)                            
 WHERE                            
  C.CL_CODE = K.APP_INTERNAL_REF                            
  AND APP_TYPE = 'N'      
      
  --SELECT * FROM #KRADATA  ORDER BY APP_INTERNAL_REF                         
  --RETURN    
                            
 /*                            
 UPDATE                            
  #KRADATA                            
 SET                            
  APP_ADDLDATA_RELATIONSHIP = ISNULL(DESCRIPTION,'')                            
 FROM                            
  CLIENT_STATIC_CODES                             
 WHERE                             
  CATEGORY = 'RELATIONSHIP_WITH_APPLICANT'                             
  AND #KRADATA.APP_ADDLDATA_RELATIONSHIP = CODE                            
 */                       
                            
                
 IF @CL_TYPE = 'N'                
 BEGIN                
 SELECT                     
  '<ROOT>',                    
  '<HEADER><COMPANY_CODE>'+ COMPANY_CODE +'</COMPANY_CODE><BATCH_DATE>'+ BATCH_DATE +'</BATCH_DATE></HEADER>',                    
  '<KYCDATA>',                
  '<APP_UPDTFLG>'+ APP_UPDTFLG +'</APP_UPDTFLG>',                    
  '<APP_POS_CODE>'+ APP_POS_CODE +'</APP_POS_CODE>',                    
  '<APP_TYPE>'+ APP_TYPE +'</APP_TYPE>',                    
  '<APP_NO>'+ APP_NO +'</APP_NO>',                    
  '<APP_DATE>'+ APP_DATE +'</APP_DATE>',                    
  '<APP_PAN_NO>'+ APP_PAN_NO +'</APP_PAN_NO>',                    
  '<APP_PAN_COPY>'+ APP_PAN_COPY +'</APP_PAN_COPY>',                  
  '<APP_EXMT>'+ APP_EXMT +'</APP_EXMT>',                    
  '<APP_EXMT_CAT>'+ APP_EXMT_CAT +'</APP_EXMT_CAT>',                    
  '<APP_EXMT_ID_PROOF>'+ APP_EXMT_ID_PROOF +'</APP_EXMT_ID_PROOF>',                    
  '<APP_IPV_FLAG>'+ APP_IPV_FLAG +'</APP_IPV_FLAG>',                    
  '<APP_IPV_DATE>'+ APP_IPV_DATE +'</APP_IPV_DATE>',                    
  '<APP_GEN>'+ APP_GEN +'</APP_GEN>',                    
  '<APP_NAME>'+ APP_NAME +'</APP_NAME>',                    
  '<APP_F_NAME>'+ APP_F_NAME +'</APP_F_NAME>',                    
  '<APP_DOB_INCORP>'+ APP_DOB_INCORP +'</APP_DOB_INCORP>',                    
  '<APP_REGNO>'+ APP_REGNO +'</APP_REGNO>',                    
  '<APP_COMMENCE_DT>'+ APP_COMMENCE_DT +'</APP_COMMENCE_DT>',                    
  '<APP_NATIONALITY>'+ APP_NATIONALITY +'</APP_NATIONALITY>',                    
  '<APP_OTH_NATIONALITY>'+ APP_OTH_NATIONALITY +'</APP_OTH_NATIONALITY>',                    
  '<APP_COMP_STATUS>'+ APP_COMP_STATUS +'</APP_COMP_STATUS>',                    
  '<APP_OTH_COMP_STATUS>'+ APP_OTH_COMP_STATUS +'</APP_OTH_COMP_STATUS>',                    
  '<APP_RES_STATUS>'+APP_RES_STATUS +'</APP_RES_STATUS>',                    
  '<APP_RES_STATUS_PROOF>'+ APP_RES_STATUS_PROOF +'</APP_RES_STATUS_PROOF>',                    
  '<APP_UID_NO>'+ APP_UID_NO +'</APP_UID_NO>',                    
  '<APP_COR_ADD1>'+ APP_COR_ADD1 +'</APP_COR_ADD1>',                    
  '<APP_COR_ADD2>'+ APP_COR_ADD2 +'</APP_COR_ADD2>',                    
  '<APP_COR_ADD3>'+ APP_COR_ADD3 +'</APP_COR_ADD3>',                    
  '<APP_COR_CITY>'+ APP_COR_CITY +'</APP_COR_CITY>',                    
  '<APP_COR_PINCD>'+ APP_COR_PINCD +'</APP_COR_PINCD>',                    
  '<APP_COR_STATE>'+ APP_COR_STATE +'</APP_COR_STATE>',                    
  '<APP_COR_CTRY>'+ APP_COR_CTRY +'</APP_COR_CTRY>',                    
  '<APP_OFF_ISD>'+ APP_OFF_ISD +'</APP_OFF_ISD>',                    
  '<APP_OFF_STD>'+ APP_OFF_STD +'</APP_OFF_STD>',                    
  '<APP_OFF_NO>'+ APP_OFF_NO +'</APP_OFF_NO>',                    
  '<APP_RES_ISD>'+ APP_RES_ISD +'</APP_RES_ISD>',                    
  '<APP_RES_STD>'+ APP_RES_STD +'</APP_RES_STD>',                    
  '<APP_RES_NO>'+ APP_RES_NO +'</APP_RES_NO>',                    
  '<APP_MOB_ISD>'+ APP_MOB_ISD +'</APP_MOB_ISD>',                    
  '<APP_MOB_NO>'+ APP_MOB_NO +'</APP_MOB_NO>',                    
  '<APP_FAX_ISD>'+ APP_FAX_ISD +'</APP_FAX_ISD>',               
  '<APP_FAX_STD>'+ APP_FAX_STD +'</APP_FAX_STD>',                    
  '<APP_FAX_NO>'+ APP_FAX_NO +'</APP_FAX_NO>',                    
  '<APP_EMAIL>'+ APP_EMAIL +'</APP_EMAIL>',                    
  '<APP_COR_ADD_PROOF>'+ APP_COR_ADD_PROOF +'</APP_COR_ADD_PROOF>',                    
  '<APP_COR_ADD_REF>'+ APP_COR_ADD_REF +'</APP_COR_ADD_REF>',                    
  '<APP_COR_ADD_DT>'+ APP_COR_ADD_DT +'</APP_COR_ADD_DT>',                    
  '<APP_PER_ADD_FLAG>'+ APP_PER_ADD_FLAG +'</APP_PER_ADD_FLAG>',                    
  '<APP_PER_ADD1>'+ APP_PER_ADD1 +'</APP_PER_ADD1>',                    
  '<APP_PER_ADD2>'+ APP_PER_ADD2 +'</APP_PER_ADD2>',                    
  '<APP_PER_ADD3>'+ APP_PER_ADD3 +'</APP_PER_ADD3>',                    
  '<APP_PER_CITY>'+ APP_PER_CITY +'</APP_PER_CITY>',                    
  '<APP_PER_PINCD>'+ APP_PER_PINCD +'</APP_PER_PINCD>',                    
  '<APP_PER_STATE>'+ APP_PER_STATE +'</APP_PER_STATE>',                    
  '<APP_PER_CTRY>'+ APP_PER_CTRY +'</APP_PER_CTRY>',                    
  '<APP_PER_ADD_PROOF>'+ APP_PER_ADD_PROOF +'</APP_PER_ADD_PROOF>',                    
  '<APP_PER_ADD_REF>'+ APP_PER_ADD_REF +'</APP_PER_ADD_REF>',                    
  '<APP_PER_ADD_DT>'+ APP_PER_ADD_DT +'</APP_PER_ADD_DT>',                    
  '<APP_INCOME>'+ APP_INCOME +'</APP_INCOME>',                    
  '<APP_OCC>'+ APP_OCC +'</APP_OCC>',                    
  '<APP_OTH_OCC>'+ APP_OTH_OCC +'</APP_OTH_OCC>',                    
  '<APP_POL_CONN>'+ APP_POL_CONN +'</APP_POL_CONN>',                    
  '<APP_DOC_PROOF>'+ APP_DOC_PROOF +'</APP_DOC_PROOF>',                    
  '<APP_INTERNAL_REF>'+ APP_INTERNAL_REF +'</APP_INTERNAL_REF>',                    
  '<APP_BRANCH_CODE>'+ APP_BRANCH_CODE +'</APP_BRANCH_CODE>',                    
  '<APP_MAR_STATUS>'+ APP_MAR_STATUS+'</APP_MAR_STATUS>',                    
  '<APP_NETWRTH>'+ CONVERT(VARCHAR,APP_NETWRTH) +'</APP_NETWRTH>',                    
  '<APP_NETWORTH_DT>'+ APP_NETWORTH_DT +'</APP_NETWORTH_DT>',                   
  '<APP_INCORP_PLC>'+ APP_INCORP_PLC+'</APP_INCORP_PLC>',                    
  '<APP_OTHERINFO>'+ APP_OTHERINFO+'</APP_OTHERINFO>',                    
  '<APP_FILLER1>'+ APP_FILLER1+'</APP_FILLER1>',                    
  '<APP_FILLER2>'+ APP_FILLER2+'</APP_FILLER2>',                    
  '<APP_FILLER3>'+ APP_FILLER3+'</APP_FILLER3>',                    
  /*                    
  '<APP_STATUS></APP_STATUS>',                    
  '<APP_STATUSDT></APP_STATUSDT>',                    
  '<APP_ERROR_DESC></APP_ERROR_DESC>',                    
  '<APP_DUMP_TYPE></APP_DUMP_TYPE>',                    
  '<APP_DNLDDT></APP_DNLDDT>',                    
  */                    
  '</KYCDATA>',                    
  '<ADDITIONALDATA>',                    
  '<APP_ADDLDATA_UPDTFLG>'+ APP_ADDLDATA_UPDTFLG +'</APP_ADDLDATA_UPDTFLG>',                    
  '<APP_ENTITY_PAN>'+ APP_ENTITY_PAN +'</APP_ENTITY_PAN>',                    
  '<APP_ADDLDATA_PAN>'+ APP_ADDLDATA_PAN +'</APP_ADDLDATA_PAN>',                    
  '<APP_ADDLDATA_NAME>'+ APP_ADDLDATA_NAME +'</APP_ADDLDATA_NAME>',                    
  '<APP_ADDLDATA_DIN_UID></APP_ADDLDATA_DIN_UID>',                    
  '<APP_ADDLDATA_RELATIONSHIP>'+ APP_ADDLDATA_RELATIONSHIP +'</APP_ADDLDATA_RELATIONSHIP>',                    
  '<APP_ADDLDATA_POLCONN>'+ APP_ADDLDATA_POLCONN +'</APP_ADDLDATA_POLCONN>',                    
  '<APP_ADDLDATA_FILLER1></APP_ADDLDATA_FILLER1>',                    
  '<APP_ADDLDATA_FILLER2></APP_ADDLDATA_FILLER2>',                    
  '<APP_ADDLDATA_FILLER3></APP_ADDLDATA_FILLER3>',                    
  /*                    
  '<APP_ADDLDATA_STATUS></APP_ADDLDATA_STATUS>',                    
  '<APP_ADDLDATA_STATUSDT></APP_ADDLDATA_STATUSDT>',                    
  '<APP_ADDLDATA_ERROR_DESC></APP_ADDLDATA_ERROR_DESC>',                    
  '<APP_DUMP_TYPE></APP_DUMP_TYPE>',                    
  '<APP_DNLDDT></APP_DNLDDT>',                    
  */                    
  '</ADDITIONALDATA>',                    
  APP_FILE_FLAG                    
 FROM                     
  #KRADATA                    
 ORDER BY                     
  APP_FILE_FLAG                    
 END                
 ELSE                
 BEGIN                
 SELECT                             
  '<ROOT>',                            
  '<HEADER><COMPANY_CODE>'+ COMPANY_CODE +'</COMPANY_CODE><BATCH_DATE>'+ BATCH_DATE +'</BATCH_DATE></HEADER>',                            
  '<KYCDATA>',                            
  '<APP_UPDTFLG>'+ APP_UPDTFLG +'</APP_UPDTFLG>',                            
  '<APP_POS_CODE>'+ APP_POS_CODE +'</APP_POS_CODE>',                            
  '<APP_TYPE>'+ APP_TYPE +'</APP_TYPE>',                            
  --'<APP_NO>'+ APP_NO +'</APP_NO>',                            
  '<APP_DATE>'+ APP_DATE +'</APP_DATE>',                            
  '<APP_PAN_NO>'+ APP_PAN_NO +'</APP_PAN_NO>',                            
  '<APP_PAN_COPY>'+ APP_PAN_COPY +'</APP_PAN_COPY>',                            
  '<APP_EXMT>'+ APP_EXMT +'</APP_EXMT>',                            
  -- '<APP_EXMT_CAT>'+ APP_EXMT_CAT +'</APP_EXMT_CAT>',                            
  '<APP_EXMT_ID_PROOF>'+ APP_EXMT_ID_PROOF +'</APP_EXMT_ID_PROOF>',                            
  --'<APP_IPV_FLAG>'+ APP_IPV_FLAG +'</APP_IPV_FLAG>',                            
  --'<APP_IPV_DATE>'+ APP_IPV_DATE +'</APP_IPV_DATE>',                            
  '<APP_GEN>'+ APP_GEN +'</APP_GEN>',                            
  '<APP_NAME>'+ APP_NAME +'</APP_NAME>',                            
  --'<APP_F_NAME>'+ APP_F_NAME +'</APP_F_NAME>',            
  '<APP_F_NAME>'+ '.' +'</APP_F_NAME>',                           
  '<APP_DOB_INCORP>'+ APP_DOB_INCORP +'</APP_DOB_INCORP>',                            
  -- '<APP_REGNO>'+ APP_REGNO +'</APP_REGNO>',                            
  --'<APP_COMMENCE_DT>'+ APP_COMMENCE_DT +'</APP_COMMENCE_DT>',                            
  '<APP_NATIONALITY>'+ APP_NATIONALITY +'</APP_NATIONALITY>',                            
  -- '<APP_OTH_NATIONALITY>'+ APP_OTH_NATIONALITY +'</APP_OTH_NATIONALITY>',                            
  -- '<APP_COMP_STATUS>'+ APP_COMP_STATUS +'</APP_COMP_STATUS>',                            
  -- '<APP_OTH_COMP_STATUS>'+ APP_OTH_COMP_STATUS +'</APP_OTH_COMP_STATUS>',                            
  --'<APP_RES_STATUS>'+APP_RES_STATUS +'</APP_RES_STATUS>',             
    '<APP_RES_STATUS>' + 'R' + '</APP_RES_STATUS>',                           
  '<APP_RES_STATUS_PROOF>'+ APP_RES_STATUS_PROOF +'</APP_RES_STATUS_PROOF>',                            
  -- '<APP_UID_NO>'+ APP_UID_NO +'</APP_UID_NO>',                            
  '<APP_COR_ADD1>'+ APP_COR_ADD1 +'</APP_COR_ADD1>',                            
  '<APP_COR_ADD2>'+ APP_COR_ADD2 +'</APP_COR_ADD2>',                            
  -- '<APP_COR_ADD3>'+ APP_COR_ADD3 +'</APP_COR_ADD3>',                            
  '<APP_COR_CITY>'+ APP_COR_CITY +'</APP_COR_CITY>',                            
  '<APP_COR_PINCD>'+ APP_COR_PINCD +'</APP_COR_PINCD>',                            
  '<APP_COR_STATE>'+ APP_COR_STATE +'</APP_COR_STATE>',                            
  '<APP_COR_CTRY>'+ APP_COR_CTRY +'</APP_COR_CTRY>',                            
  -- '<APP_OFF_ISD>'+ APP_OFF_ISD +'</APP_OFF_ISD>',                            
  -- '<APP_OFF_STD>'+ APP_OFF_STD +'</APP_OFF_STD>',                            
  -- '<APP_OFF_NO>'+ APP_OFF_NO +'</APP_OFF_NO>',                            
  --  '<APP_RES_ISD>'+ APP_RES_ISD +'</APP_RES_ISD>',                            
  -- '<APP_RES_STD>'+ APP_RES_STD +'</APP_RES_STD>',                            
  -- '<APP_RES_NO>'+ APP_RES_NO +'</APP_RES_NO>',                            
  --  '<APP_MOB_ISD>'+ APP_MOB_ISD +'</APP_MOB_ISD>',                            
  --'<APP_MOB_NO>'+ APP_MOB_NO +'</APP_MOB_NO>',                            
  --'<APP_FAX_ISD>'+ APP_FAX_ISD +'</APP_FAX_ISD>',                          
  -- '<APP_FAX_STD>'+ APP_FAX_STD +'</APP_FAX_STD>',                            
  --'<APP_FAX_NO>'+ APP_FAX_NO +'</APP_FAX_NO>',                            
  -- '<APP_EMAIL>'+ APP_EMAIL +'</APP_EMAIL>',                            
  '<APP_COR_ADD_PROOF>'+ APP_COR_ADD_PROOF +'</APP_COR_ADD_PROOF>',                            
  --  '<APP_COR_ADD_REF>'+ APP_COR_ADD_REF +'</APP_COR_ADD_REF>',                            
  -- '<APP_COR_ADD_DT>'+ APP_COR_ADD_DT +'</APP_COR_ADD_DT>',                            
  '<APP_PER_ADD_FLAG>'+ 'Y' +'</APP_PER_ADD_FLAG>',                            
  --'<APP_PER_ADD1>'+ APP_PER_ADD1 +'</APP_PER_ADD1>',                            
  -- '<APP_PER_ADD2>'+ APP_PER_ADD2 +'</APP_PER_ADD2>',                            
  -- '<APP_PER_ADD3>'+ APP_PER_ADD3 +'</APP_PER_ADD3>',                            
  --'<APP_PER_CITY>'+ APP_PER_CITY +'</APP_PER_CITY>',                            
  -- '<APP_PER_PINCD>'+ APP_PER_PINCD +'</APP_PER_PINCD>',                            
  -- '<APP_PER_STATE>'+ APP_PER_STATE +'</APP_PER_STATE>',                            
  -- '<APP_PER_CTRY>'+ APP_PER_CTRY +'</APP_PER_CTRY>',                            
  -- '<APP_PER_ADD_PROOF>'+ APP_PER_ADD_PROOF +'</APP_PER_ADD_PROOF>',                            
  -- '<APP_PER_ADD_REF>'+ APP_PER_ADD_REF +'</APP_PER_ADD_REF>',                            
  -- '<APP_PER_ADD_DT>'+ APP_PER_ADD_DT +'</APP_PER_ADD_DT>',                            
  --  '<APP_INCOME>'+ APP_INCOME +'</APP_INCOME>',                            
  '<APP_OCC>'+ APP_OCC +'</APP_OCC>',        
  --'<APP_OTH_OCC>'+ APP_OTH_OCC +'</APP_OTH_OCC>',            
    '<APP_OTH_OCC>'+ '.' +'</APP_OTH_OCC>',                            
  '<APP_POL_CONN>'+ APP_POL_CONN +'</APP_POL_CONN>',                            
  -- '<APP_DOC_PROOF>'+ APP_DOC_PROOF +'</APP_DOC_PROOF>',                            
  -- '<APP_INTERNAL_REF>'+ APP_INTERNAL_REF +'</APP_INTERNAL_REF>',                            
  --  '<APP_BRANCH_CODE>'+ APP_BRANCH_CODE +'</APP_BRANCH_CODE>',                            
  '<APP_MAR_STATUS>'+ APP_MAR_STATUS+'</APP_MAR_STATUS>',                            
  --  '<APP_NETWRTH>'+ CONVERT(VARCHAR,APP_NETWRTH) +'</APP_NETWRTH>',                            
--  '<APP_NETWORTH_DT>'+ APP_NETWORTH_DT +'</APP_NETWORTH_DT>',                            
  --  '<APP_INCORP_PLC>'+ APP_INCORP_PLC+'</APP_INCORP_PLC>',                            
  --  '<APP_OTHERINFO>'+ APP_OTHERINFO+'</APP_OTHERINFO>',                            
  -- '<APP_FILLER1>'+ APP_FILLER1+'</APP_FILLER1>',                            
  --  '<APP_FILLER2>'+ APP_FILLER2+'</APP_FILLER2>',                            
  -- '<APP_FILLER3>'+ APP_FILLER3+'</APP_FILLER3>',                   
  '<APP_ACC_OPENDT>'+ APP_ACC_OPENDT+'</APP_ACC_OPENDT>',                  
  '<APP_ACC_ACTIVEDT>'+ APP_ACC_ACTIVEDT+'</APP_ACC_ACTIVEDT>',                  
  '<APP_ACC_UPDTDT>'+ APP_ACC_UPDTDT+'</APP_ACC_UPDTDT>',                           
  /*                            
  '<APP_STATUS></APP_STATUS>',                            
  '<APP_STATUSDT></APP_STATUSDT>',                            
  '<APP_ERROR_DESC></APP_ERROR_DESC>',                            
  '<APP_DUMP_TYPE></APP_DUMP_TYPE>',                            
  '<APP_DNLDDT></APP_DNLDDT>',                            
  */                            
  '</KYCDATA>',                            
  '<ADDITIONALDATA>',                            
  '<APP_ADDLDATA_UPDTFLG>'+ APP_ADDLDATA_UPDTFLG +'</APP_ADDLDATA_UPDTFLG>',                            
  '<APP_ENTITY_PAN>'+ APP_ENTITY_PAN +'</APP_ENTITY_PAN>',                            
  '<APP_ADDLDATA_PAN>'+ APP_ADDLDATA_PAN +'</APP_ADDLDATA_PAN>',                            
  '<APP_ADDLDATA_NAME>'+ APP_ADDLDATA_NAME +'</APP_ADDLDATA_NAME>',                            
  '<APP_ADDLDATA_DIN_UID></APP_ADDLDATA_DIN_UID>',                            
  '<APP_ADDLDATA_RELATIONSHIP>'+ APP_ADDLDATA_RELATIONSHIP +'</APP_ADDLDATA_RELATIONSHIP>',                            
  '<APP_ADDLDATA_POLCONN>'+ APP_ADDLDATA_POLCONN +'</APP_ADDLDATA_POLCONN>',                            
  '<APP_ADDLDATA_FILLER1></APP_ADDLDATA_FILLER1>',                            
  '<APP_ADDLDATA_FILLER2></APP_ADDLDATA_FILLER2>',                            
  '<APP_ADDLDATA_FILLER3></APP_ADDLDATA_FILLER3>',                            
  /*                            
  '<APP_ADDLDATA_STATUS></APP_ADDLDATA_STATUS>',                            
  '<APP_ADDLDATA_STATUSDT></APP_ADDLDATA_STATUSDT>',                            
  '<APP_ADDLDATA_ERROR_DESC></APP_ADDLDATA_ERROR_DESC>',                            
  '<APP_DUMP_TYPE></APP_DUMP_TYPE>',                            
  '<APP_DNLDDT></APP_DNLDDT>',                            
  */                            
  '</ADDITIONALDATA>',                            
  APP_FILE_FLAG                            
 FROM                             
  #KRADATA                            
 ORDER BY                             
  APP_FILE_FLAG,                            
  APP_INTERNAL_REF                            
                
 END                
                              
                            
                            
 /* --- INSERTING LOG TABLE --- */                            
                            
  INSERT INTO TBL_KRA_LOG                            
  SELECT                            
   'CDSL',                            
   APP_INTERNAL_REF,                            
   APP_PAN_NO,                            
   APP_UPDTFLG,                            
   @BATCH_NO,                      
   CONVERT(VARCHAR,CONVERT(DATETIME,@BATCH_DATE,112),109),                            
   'DOWNLOAD',                            
   'COMMON',                            
   '',                            
   '',                            
   '',                            
   '',                            
   '',                            
   @USERNAME,                            
   GETDATE(),                            
   0                            
  FROM                            
   #KRADATA                            
  WHERE                          
   APP_FILE_FLAG = 1                            
                            
                            
  INSERT INTO TBL_KRA_LOG                            
  SELECT                            
   'CDSL',                            
   APP_INTERNAL_REF,                            
   APP_PAN_NO,                            
   APP_UPDTFLG,                            
   @BATCH_NO,                            
   CONVERT(VARCHAR,CONVERT(DATETIME,@BATCH_DATE,112),109),                            
   'DOWNLOAD',                            
   'ADDITIONAL',                            
   '',                          
   '',                            
   '',                            
   '',                       
   '',                            
   @USERNAME,                            
   GETDATE(),              
   0                            
  FROM                            
   #KRADATA                            
  WHERE                            
   APP_FILE_FLAG = 2                            
                            
 /* --- INSERTING LOG TABLE --- */

GO
