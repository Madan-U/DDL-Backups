-- Object: PROCEDURE citrus_usr.pr_select_trxgen_cdsl_0710
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

-- SELECT * FROM BITMAP_REF_MSTR 
--ROLLBACK   

/*  
 
EXEC PR_SELECT_TRXGEN_CDSL	'CLSR_ACCT_GEN','may 21 2009','may 21 2009','2','CDSL',3,'HO','','Y','*|~*','|*~|',''	

*/  
Create PROCEDURE [citrus_usr].[pr_select_trxgen_cdsl_0710]        
(        
 @PA_TRX_TAB VARCHAR(8000),        
 @PA_FROM_DT VARCHAR(20),        
 @PA_TO_DT VARCHAR(20),        
 @PA_BATCH_NO VARCHAR(10),        
 @PA_BATCH_TYPE VARCHAR(2),        
 @PA_EXCSM_ID INT,        
 @PA_LOGINNAME VARCHAR(20),        
 @PA_POOL_ACCTNO VARCHAR(16),      
 @PA_BROKER_YN CHAR(1),       
 @ROWDELIMITER VARCHAR(20),        
 @COLDELIMITER VARCHAR(20),        
 @PA_OUTPUT VARCHAR(20) OUTPUT        
)        
AS        
BEGIN        
--        
/*        
P-PENDING        
O-OVERDUWE        
S-UPLOAD SUCCESS        
F-FAIL        
E-EXECUTE        
R-REJECT        
0-INTIAL        
*/        
  DECLARE @@L_TRX_CD VARCHAR(5)        
  ,@L_QTY VARCHAR(100)        
  ,@L_TOTQTY VARCHAR(100)         
  ,@L_SQL VARCHAR(8000)        
  ,@L_TRX_TAB VARCHAR(8000)        
  ,@REMAININGSTRING VARCHAR(8000)        
  ,@FOUNDAT INT        
  ,@DELIMETER  VARCHAR(50)        
  ,@CURRSTRING  VARCHAR(500)        
  ,@DELIMETERLENGTH INT        
  ,@L_DPM_ID INT         
  ,@L_TOT_REC INT        
  ,@L_TRANS_TYPE VARCHAR(8000)         
  SET @DELIMETER        = '%'+ @ROWDELIMITER + '%'        
  SET @DELIMETERLENGTH = LEN(@ROWDELIMITER)        
  SET @REMAININGSTRING = @PA_TRX_TAB          
  SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND =1           
  SET @L_TOT_REC = 0      
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
      SET @L_TRX_TAB = CITRUS_USR.FN_SPLITVAL(@CURRSTRING,1)        
     PRINT @L_TRX_TAB    
    IF @PA_BROKER_YN = 'Y'       
    
    BEGIN      
          
            
  IF @L_TRX_TAB = 'EP'        
      BEGIN        
       --        
             
    
          --FOR EXCH FILELOOKUP        
          --SETTLEMNT LOOKUP + OTHER SETTL_NO        
        IF @PA_BATCH_TYPE = 'BN'        
        BEGIN     
    
         
          SELECT CONVERT(CHAR(2),ISNULL(EXCM_SHORT_NAME,0))        
               + CONVERT(CHAR(2),ISNULL(FILLM_FILE_VALUE,''))        
              + CONVERT(CHAR(8),ISNULL(CONVERT(VARCHAR,DPTDC_CM_ID),''))        
              + CONVERT(CHAR(13),ISNULL(CASE WHEN SETTM_TYPE_CDSL = 'TT' THEN 'W' WHEN SETTM_TYPE_CDSL = 'NR' THEN 'N' WHEN SETTM_TYPE_CDSL = 'NA' THEN 'A' ELSE SETTM_TYPE_CDSL END,0)+ISNULL(DPTDC_OTHER_SETTLEMENT_NO,''))        
              + CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,''))        
              + CONVERT(CHAR(12),ISNULL(DPTDC_ISIN,'') )        
                 + CONVERT(VARCHAR(16),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DPTDC_QTY)),13,3,'L','0'))          
              + CONVERT(CHAR(16),ISNULL(DPTDC_COUNTER_DEMAT_ACCT_NO,''))        
              + CONVERT(CHAR(16),DPTDC_SLIP_NO+'/'+DPTDC_INTERNAL_REF_NO)      
              + CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),DPTDC_EXECUTION_DT,103),'/',''))  DETAILS      
      , ABS(DPTDC_QTY) QTY      
            FROM   DP_TRX_DTLS_CDSL         
            LEFT OUTER JOIN  SETTLEMENT_TYPE_MSTR  ON CONVERT(VARCHAR,SETTM_ID) = DPTDC_OTHER_SETTLEMENT_TYPE AND DPTDC_OTHER_SETTLEMENT_TYPE <> ''      
             , DP_ACCT_MSTR        
                   
             , EXCHANGE_MSTR        
             , CC_MSTR        
             , EXCH_SEG_MSTR        
             , BITMAP_REF_MSTR      
             , FILE_LOOKUP_MSTR       
            WHERE  DPAM_ID      = DPTDC_DPAM_ID        
            AND    EXCM_ID      = DPTDC_EXCM_ID        
            AND    FILLM_DB_VALUE = EXCM_SHORT_NAME      
            AND    FILLM_FILE_NAME = 'CH_CDSL'      
            AND    DPAM_DELETED_IND   = 1        
            AND    DPTDC_DELETED_IND  = 1        
            --AND    SETTM_DELETED_IND  = 1        
            --AND    SETTM_ID           = CASE WHEN ISNULL(DPTDC_OTHER_SETTLEMENT_TYPE,'') = '' THEN SETTM_ID   ELSE  DPTDC_OTHER_SETTLEMENT_TYPE END          
            AND    EXCM_CD            = EXCSM_EXCH_CD        
            AND    EXCSM_DESC         = BITRM_CHILD_CD        
            AND    CONVERT(INT,CCM_EXCSM_BIT) & POWER(2,BITRM_BIT_LOCATION-1) >0        
            AND    EXCSM_DELETED_IND  = 1        
            AND    CCM_DELETED_IND  = 1        
            AND    ISNULL(DPTDC_STATUS,'P')='P'        
            AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
            AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
            AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB        
            AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
            AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
      
               SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM DP_TRX_DTLS_CDSL ,DP_ACCT_MSTR        
                                       WHERE  ISNULL(DPTDC_STATUS,'P')='P' AND DPTDC_DPAM_ID = DPAM_ID         
               AND    DPAM_DPM_ID   = @L_DPM_ID          
               AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
               AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
               AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB        
               AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
      
               IF @L_TOT_REC > 0         
               BEGIN         
                 /* UPDATE IN DP_TRX_DTLS_CDSL*/       
      
               SELECT @L_TRANS_TYPE = DPTDC_INTERNAL_TRASTM FROM DP_TRX_DTLS_CDSL ,DP_ACCT_MSTR        
               WHERE  ISNULL(DPTDC_STATUS,'P')='P' AND DPTDC_DPAM_ID = DPAM_ID         
               AND    DPAM_DPM_ID   = @L_DPM_ID          
               AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
               AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
               AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB         
               AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
               AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
      
               UPDATE D1 SET DPTDC_BATCH_NO=@PA_BATCH_NO FROM DP_TRX_DTLS_CDSL D1 ,DP_ACCT_MSTR D2        
               WHERE  DPTDC_DPAM_ID = DPAM_ID         
               AND    DPAM_DPM_ID   = @L_DPM_ID          
               AND    ISNULL(DPTDC_STATUS,'P')='P'        
               AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
               AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
               AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB         
               AND    D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
               AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
      
      
               /* UPDATE IN BITMAP REF MSTR*/         
               UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
      WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @L_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID        
        
        
               /* INSERT INTO BATCH TABLE*/        
      
      
      
                 IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@L_TRX_TAB)        
                 BEGIN        
    
        
                  INSERT INTO BATCHNO_CDSL_MSTR                                            
                  (          
                   BATCHC_DPM_ID,        
                   BATCHC_NO,        
                   BATCHC_RECORDS ,        
                   BATCHC_TRANS_TYPE,                
                   BATCHC_TYPE,        
                   BATCHC_FILEGEN_DT,      
                   BATCHC_STATUS,        
                   BATCHC_CREATED_BY,        
                   BATCHC_CREATED_DT ,        
                   BATCHC_DELETED_IND        
                  )        
                  VALUES        
                  (        
                   @L_DPM_ID,        
                   @PA_BATCH_NO,        
                   @L_TOT_REC,        
                   @L_TRANS_TYPE,        
                   'T',        
                   CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',      
                   'P',        
                   @PA_LOGINNAME,        
                   GETDATE(),        
                   1        
                  )            
                                                           END        
                 END        
      
                      END           
                      ELSE        
        BEGIN        
          SELECT CONVERT(CHAR(2),ISNULL(EXCM_SHORT_NAME,0))        
              + CONVERT(CHAR(2),ISNULL(FILLM_FILE_VALUE,''))        
              + CONVERT(CHAR(8),ISNULL(CONVERT(VARCHAR,DPTDC_CM_ID),''))        
              + CONVERT(CHAR(13),ISNULL(CASE WHEN SETTM_TYPE_CDSL = 'TT' THEN 'W' WHEN SETTM_TYPE_CDSL = 'NR' THEN 'N' WHEN SETTM_TYPE_CDSL = 'NA' THEN 'A' ELSE SETTM_TYPE_CDSL END,0)+ISNULL(DPTDC_OTHER_SETTLEMENT_NO,''))        
              + CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,''))        
              + CONVERT(CHAR(12),ISNULL(DPTDC_ISIN,'') )        
              + CONVERT(VARCHAR(16),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DPTDC_QTY)),13,3,'L','0'))          
              + CONVERT(CHAR(16),ISNULL(DPTDC_COUNTER_DEMAT_ACCT_NO,''))        
              + CONVERT(CHAR(16),DPTDC_SLIP_NO+'/'+DPTDC_INTERNAL_REF_NO)      
              + CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),DPTDC_EXECUTION_DT,103),'/',''))  DETAILS      
              , ABS(DPTDC_QTY) QTY      
            FROM   DP_TRX_DTLS_CDSL         
            LEFT OUTER JOIN  SETTLEMENT_TYPE_MSTR  ON CONVERT(VARCHAR,SETTM_ID) = DPTDC_OTHER_SETTLEMENT_TYPE AND DPTDC_OTHER_SETTLEMENT_TYPE <> ''      
             , DP_ACCT_MSTR        
                  
             , EXCHANGE_MSTR        
             , CC_MSTR        
             , EXCH_SEG_MSTR        
             , BITMAP_REF_MSTR        
             , FILE_LOOKUP_MSTR       
            WHERE  DPAM_ID      = DPTDC_DPAM_ID        
            AND    EXCM_ID      = DPTDC_EXCM_ID       
            AND    FILLM_DB_VALUE = EXCM_SHORT_NAME      
            AND    FILLM_FILE_NAME = 'CH_CDSL'      
            AND    DPAM_DELETED_IND   = 1        
            AND    DPTDC_DELETED_IND  = 1       
            --AND    SETTM_DELETED_IND  = 1        
            --AND    SETTM_ID           = CASE WHEN ISNULL(DPTDC_OTHER_SETTLEMENT_TYPE,'') = '' THEN SETTM_ID   ELSE  DPTDC_OTHER_SETTLEMENT_TYPE END          
            AND    EXCM_CD            = EXCSM_EXCH_CD        
            AND    EXCSM_DESC         = BITRM_CHILD_CD        
            AND    CONVERT(INT,CCM_EXCSM_BIT) & POWER(2,BITRM_BIT_LOCATION-1) >0        
                                          AND    ISNULL(DPTDC_STATUS,'P') = 'P'        
                                          AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = @PA_BATCH_NO        
            AND    EXCSM_DELETED_IND  = 1        
            AND    CCM_DELETED_IND  = 1        
            AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
            AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB        
            AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
            AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
      
         END         
       --        
      END        
      IF @L_TRX_TAB = 'NP'        
      BEGIN        
      --        
        --FOR EXCH FILELOOKUP        
        --SETTLEMNT LOOKUP + OTHER SETTL_NO        
                      IF @PA_BATCH_TYPE = 'BN'        
        BEGIN        
        SELECT 'D'+ CONVERT(CHAR(2),'01')        
             + CONVERT(CHAR(2),ISNULL(FILLM_FILE_VALUE,''))        
             + CONVERT(CHAR(2),ISNULL(EXCM_SHORT_NAME,0))        
             + CONVERT(CHAR(13),ISNULL(CASE WHEN SETTM_TYPE_CDSL = 'TT' THEN 'W' WHEN SETTM_TYPE_CDSL = 'NR' THEN 'N' WHEN SETTM_TYPE_CDSL = 'NA' THEN 'A' ELSE SETTM_TYPE_CDSL END,0)+ISNULL(DPTDC_OTHER_SETTLEMENT_NO,''))        
             + CONVERT(CHAR(6),ISNULL(RIGHT(DPM_DPID,6),''))        
             + CONVERT(CHAR(8),ISNULL(CONVERT(VARCHAR,DPTDC_CM_ID),'') )        
             + CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,'') )        
             + CONVERT(CHAR(12),ISNULL(DPTDC_ISIN,'') )       
      
             + CONVERT(CHAR(6),'000000')        
             + CONVERT(CHAR(4),'0000')        
             + CONVERT(VARCHAR(16),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DPTDC_QTY)),13,3,'L','0'))          
             + 'S'        
             + CONVERT(CHAR(16),DPTDC_SLIP_NO+'/'+DPTDC_INTERNAL_REF_NO)  DETAILS      
             , ABS(DPTDC_QTY) QTY      
        FROM  DP_TRX_DTLS_CDSL         
        LEFT OUTER JOIN  SETTLEMENT_TYPE_MSTR  ON CONVERT(VARCHAR,SETTM_ID) = DPTDC_OTHER_SETTLEMENT_TYPE AND DPTDC_OTHER_SETTLEMENT_TYPE <> ''      
             , DP_ACCT_MSTR        
              
             , EXCHANGE_MSTR        
             , CC_MSTR        
             , EXCH_SEG_MSTR        
             , BITMAP_REF_MSTR        
             ,DP_MSTR       
             , FILE_LOOKUP_MSTR      
        WHERE  DPAM_ID      = DPTDC_DPAM_ID        
        AND    DPAM_DPM_ID  = DPM_ID      
        AND    FILLM_DB_VALUE = EXCM_SHORT_NAME      
        AND    FILLM_FILE_NAME = 'CH_CDSL'      
        AND    EXCM_ID      = DPTDC_EXCM_ID        
        AND    DPAM_DELETED_IND   = 1        
        AND    DPTDC_DELETED_IND  = 1        
        --AND    SETTM_DELETED_IND  = 1        
        --AND    SETTM_ID           = CASE WHEN ISNULL(DPTDC_OTHER_SETTLEMENT_TYPE,'') = '' THEN SETTM_ID   ELSE  DPTDC_OTHER_SETTLEMENT_TYPE END          
        AND    EXCM_CD            = EXCSM_EXCH_CD        
        AND    EXCSM_DESC         = BITRM_CHILD_CD        
        AND    CONVERT(INT,CCM_EXCSM_BIT) & POWER(2,BITRM_BIT_LOCATION-1) >0        
        AND    EXCSM_DELETED_IND  = 1        
        AND    CCM_DELETED_IND  = 1        
        AND    ISNULL(DPTDC_STATUS,'P')='P'        
        AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
        AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
        AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB        
        AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
        AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
      
      
         SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM DP_TRX_DTLS_CDSL ,DP_ACCT_MSTR        
                              WHERE  ISNULL(DPTDC_STATUS,'P')='P' AND DPTDC_DPAM_ID = DPAM_ID         
                              AND    DPAM_DPM_ID   = @L_DPM_ID          
         AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
         AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
         AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB          
         AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
         AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
      
         IF @L_TOT_REC > 0         
         BEGIN         
            /* UPDATE IN DP_TRX_DTLS_CDSL*/        
        
         
        
            SELECT @L_TRANS_TYPE = DPTDC_INTERNAL_TRASTM FROM DP_TRX_DTLS_CDSL ,DP_ACCT_MSTR        
            WHERE  ISNULL(DPTDC_STATUS,'P')='P' AND DPTDC_DPAM_ID = DPAM_ID         
            AND    DPAM_DPM_ID   = @L_DPM_ID          
            AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
            AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
            AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB       
            AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END        
            AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
      
            UPDATE D1 SET DPTDC_BATCH_NO=@PA_BATCH_NO FROM DP_TRX_DTLS_CDSL D1 ,DP_ACCT_MSTR D2        
            WHERE  DPTDC_DPAM_ID = DPAM_ID         
            AND    DPAM_DPM_ID   = @L_DPM_ID          
            AND    ISNULL(DPTDC_STATUS,'P')='P'        
            AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
            AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
            AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB        
            AND    D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
            AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
      
               /* UPDATE IN BITMAP REF MSTR*/         
            UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
            WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @L_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID        
      
            /* INSERT INTO BATCH TABLE*/        
      
      
      
                IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@L_TRX_TAB)        
                 BEGIN        
                  INSERT INTO BATCHNO_CDSL_MSTR                                             
                  (          
                   BATCHC_DPM_ID,        
                   BATCHC_NO,        
                   BATCHC_RECORDS ,        
                   BATCHC_TRANS_TYPE,      
                   BATCHC_FILEGEN_DT,                 
                   BATCHC_TYPE,        
                   BATCHC_STATUS,        
                   BATCHC_CREATED_BY,        
                   BATCHC_CREATED_DT ,        
                   BATCHC_DELETED_IND        
                  )        
VALUES        
                  (        
                   @L_DPM_ID,        
                   @PA_BATCH_NO,        
                   @L_TOT_REC,        
                   @L_TRANS_TYPE,      
                   CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',        
                   'T',        
                   'P',        
                   @PA_LOGINNAME,        
                   GETDATE(),        
                   1        
                  )            
                                                           END        
      
         END        
      
                          END        
                      ELSE         
                          BEGIN        
        SELECT 'D'+CONVERT(CHAR(2),'01')        
             + CONVERT(CHAR(2),ISNULL(FILLM_FILE_VALUE,''))        
             + CONVERT(CHAR(2),ISNULL(EXCM_SHORT_NAME,0))        
             + CONVERT(CHAR(13),ISNULL(CASE WHEN SETTM_TYPE_CDSL = 'TT' THEN 'W' WHEN SETTM_TYPE_CDSL = 'NR' THEN 'N' WHEN SETTM_TYPE_CDSL = 'NA' THEN 'A' ELSE SETTM_TYPE_CDSL END,0)+ISNULL(DPTDC_OTHER_SETTLEMENT_NO,''))        
             + CONVERT(CHAR(6),ISNULL(RIGHT(DPM_DPID,6),''))         
             + CONVERT(CHAR(8),ISNULL(CONVERT(VARCHAR,DPTDC_CM_ID),'') )       
             + CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,'') )        
             + CONVERT(CHAR(12),ISNULL(DPTDC_ISIN,'') )        
             + CONVERT(CHAR(6),'000000')        
             + CONVERT(CHAR(4),'0000')        
             + CONVERT(VARCHAR(16),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DPTDC_QTY)),13,3,'L','0'))          
             + 'S'        
             + CONVERT(CHAR(16),DPTDC_SLIP_NO+'/'+DPTDC_INTERNAL_REF_NO)  DETAILS      
             , ABS(DPTDC_QTY) QTY      
        FROM  DP_TRX_DTLS_CDSL         
        LEFT OUTER JOIN  SETTLEMENT_TYPE_MSTR  ON CONVERT(VARCHAR,SETTM_ID) = DPTDC_OTHER_SETTLEMENT_TYPE AND DPTDC_OTHER_SETTLEMENT_TYPE <> ''      
             , DP_ACCT_MSTR        
              
             , EXCHANGE_MSTR        
             , CC_MSTR        
             , EXCH_SEG_MSTR        
             , BITMAP_REF_MSTR        
              ,DP_MSTR      
              , FILE_LOOKUP_MSTR      
        WHERE  DPAM_ID      = DPTDC_DPAM_ID        
        AND    DPAM_DPM_ID      = DPM_ID       
        AND    FILLM_DB_VALUE = EXCM_SHORT_NAME      
        AND    FILLM_FILE_NAME = 'CH_CDSL'      
        AND    EXCM_ID      = DPTDC_EXCM_ID        
        AND    DPAM_DELETED_IND   = 1        
        AND    DPTDC_DELETED_IND  = 1        
        --AND    SETTM_DELETED_IND  = 1        
        --  AND    SETTM_ID           = CASE WHEN ISNULL(DPTDC_OTHER_SETTLEMENT_TYPE,'') = '' THEN SETTM_ID   ELSE  DPTDC_OTHER_SETTLEMENT_TYPE END          
        AND    EXCM_CD            = EXCSM_EXCH_CD        
        AND    EXCSM_DESC         = BITRM_CHILD_CD        
        AND    CONVERT(INT,CCM_EXCSM_BIT) & POWER(2,BITRM_BIT_LOCATION-1) >0        
        AND    EXCSM_DELETED_IND  = 1        
        AND    CCM_DELETED_IND  = 1        
        AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
                          AND    ISNULL(DPTDC_STATUS,'P')='P'        
            AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = @PA_BATCH_NO        
        AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
        AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB        
        AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
      
        END         
      --        
      END        
      IF @L_TRX_TAB IN ('OFFM')        
      BEGIN        
      --         
         -- IN CASE OF REQUEST FOR OFF MARKET        
        IF @PA_BATCH_TYPE = 'BN'        
         BEGIN        
          SELECT DISTINCT REPLACE(CONVERT(VARCHAR(11),DPTDC_EXECUTION_DT,103),'/','')        
                + ISNULL(DPAM_SBA_NO,'')        
 + ISNULL(DPTDC_COUNTER_DP_ID,'') + ISNULL(DPTDC_COUNTER_DEMAT_ACCT_NO,'')        
                + ISNULL(CONVERT(CHAR(12),DPTDC_ISIN),'')        
                + CONVERT(VARCHAR(16),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DPTDC_QTY)),12,3,'L','0'))          
                + CASE  WHEN DPTDC_INTERNAL_TRASTM IN('BOCM','CMCM') THEN 'S' WHEN DPTDC_INTERNAL_TRASTM = 'CMBO' THEN 'S' ELSE 'S' END        
                + ISNULL(DPTDC_CASH_TRF,'')        
                + ISNULL(CONVERT(VARCHAR(10),DPTDC_REASON_CD),'2')        
                + CONVERT(CHAR(16),DPTDC_SLIP_NO+'/'+DPTDC_INTERNAL_REF_NO)      
                +  CASE WHEN ISNULL(DPTDC_SETTLEMENT_NO,'') <> '' THEN CONVERT(CHAR(13),ISNULL(CITRUS_USR.GETCDSLINTERDPSETTTYPE('',DPTDC_SETTLEMENT_NO,SETTM_TYPE_CDSL),'')   +ISNULL(DPTDC_SETTLEMENT_NO,''))  ELSE CONVERT(CHAR(13),'') END       
                                                                   DETAILS--SPACE(13) DETAILS        
                , ABS(DPTDC_QTY) QTY      
           FROM   DP_TRX_DTLS_CDSL         
                                            LEFT OUTER JOIN  SETTLEMENT_TYPE_MSTR  ON CONVERT(VARCHAR,SETTM_ID) = DPTDC_MKT_TYPE AND DPTDC_MKT_TYPE <> ''      
                , DP_ACCT_MSTR        
           WHERE  DPAM_ID  = DPTDC_DPAM_ID        
           AND    DPAM_DELETED_IND  = 1        
           AND    ISNULL(DPTDC_STATUS,'P')='P'        
           AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
           AND    DPTDC_DELETED_IND  = 1        
           AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
           AND    DPTDC_INTERNAL_TRASTM IN ('CMBO','CMCM','BOBO','BOCM')        
           AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
           AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
      
           SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM DP_TRX_DTLS_CDSL ,DP_ACCT_MSTR        
           WHERE  ISNULL(DPTDC_STATUS,'P')='P' AND DPTDC_DPAM_ID = DPAM_ID         
           AND    DPAM_DPM_ID   = @L_DPM_ID          
           AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
           AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
           AND    DPTDC_INTERNAL_TRASTM IN ('CMBO','CMCM','BOBO','BOCM')        
           AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END        
           AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
      
           IF @L_TOT_REC > 0         
            BEGIN        
               /* UPDATE IN DP_TRX_DTLS_CDSL*/       
      
               SELECT @L_TRANS_TYPE = DPTDC_INTERNAL_TRASTM FROM DP_TRX_DTLS_CDSL ,DP_ACCT_MSTR        
               WHERE  ISNULL(DPTDC_STATUS,'P')='P' AND DPTDC_DPAM_ID = DPAM_ID         
               AND    DPAM_DPM_ID   = @L_DPM_ID          
               AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
               AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
               AND    DPTDC_INTERNAL_TRASTM IN ('CMBO','CMCM','BOBO','BOCM')        
               AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END        
               AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
      
               UPDATE D1 SET DPTDC_BATCH_NO=@PA_BATCH_NO FROM DP_TRX_DTLS_CDSL D1 ,DP_ACCT_MSTR D2        
               WHERE  DPTDC_DPAM_ID = DPAM_ID         
               AND    DPAM_DPM_ID   = @L_DPM_ID          
               AND    ISNULL(DPTDC_STATUS,'P')='P'        
               AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
              AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
               AND    DPTDC_INTERNAL_TRASTM IN ('CMBO','CMCM','BOBO','BOCM')        
               AND    D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
               AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
      
      
               /* UPDATE IN BITMAP REF MSTR*/         
               UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
               WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @L_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD = @L_DPM_ID       
               AND BITRM_BIT_LOCATION = @PA_EXCSM_ID         
      
      
      
      
               /* INSERT INTO BATCH TABLE*/                    
      
                IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@L_TRX_TAB)        
    BEGIN        
      
                  INSERT INTO BATCHNO_CDSL_MSTR                                             
                  (          
                   BATCHC_DPM_ID,        
                   BATCHC_NO,        
                   BATCHC_RECORDS ,        
                   BATCHC_TRANS_TYPE,       
                   BATCHC_FILEGEN_DT,                
                   BATCHC_TYPE,        
                   BATCHC_STATUS,        
                   BATCHC_CREATED_BY,        
                   BATCHC_CREATED_DT ,        
                   BATCHC_DELETED_IND        
                  )        
                  VALUES        
                  (        
                   @L_DPM_ID,        
                   @PA_BATCH_NO,        
                   @L_TOT_REC,        
                   @L_TRX_TAB,--@L_TRANS_TYPE,      
                   CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',        
                   'T',        
                   'P',        
                   @PA_LOGINNAME,        
                   GETDATE(),        
                   1        
                  )            
                   END        
            END                    
      
         END        
                          ELSE        
         BEGIN         
          SELECT DISTINCT REPLACE(CONVERT(VARCHAR(11),DPTDC_EXECUTION_DT,103),'/','')        
                + ISNULL(DPAM_SBA_NO,'')        
                + ISNULL(DPTDC_COUNTER_DP_ID,'') + ISNULL(DPTDC_COUNTER_DEMAT_ACCT_NO,'')        
                + ISNULL(CONVERT(CHAR(12),DPTDC_ISIN),'')        
                + CONVERT(VARCHAR(16),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DPTDC_QTY)),12,3,'L','0'))          
                + CASE  WHEN DPTDC_INTERNAL_TRASTM IN('BOCM','CMCM') THEN 'S' WHEN DPTDC_INTERNAL_TRASTM = 'CMBO' THEN 'S' ELSE 'S' END        
                + ISNULL(DPTDC_CASH_TRF,'')        
                + ISNULL(CONVERT(VARCHAR(10),DPTDC_REASON_CD),'2')        
                + CONVERT(CHAR(16),DPTDC_SLIP_NO+'/'+DPTDC_INTERNAL_REF_NO)      
                +  CASE WHEN ISNULL(DPTDC_SETTLEMENT_NO,'') <> '' THEN CONVERT(CHAR(13),ISNULL(CITRUS_USR.GETCDSLINTERDPSETTTYPE('',DPTDC_SETTLEMENT_NO,SETTM_TYPE_CDSL),'')   +ISNULL(DPTDC_SETTLEMENT_NO,''))  ELSE CONVERT(CHAR(13),'') END  DETAILS      
                , ABS(DPTDC_QTY) QTY      
           FROM   DP_TRX_DTLS_CDSL         
                                                   LEFT OUTER JOIN  SETTLEMENT_TYPE_MSTR  ON CONVERT(VARCHAR,SETTM_ID) = DPTDC_MKT_TYPE AND DPTDC_MKT_TYPE <> ''      
                , DP_ACCT_MSTR        
           WHERE  DPAM_ID  = DPTDC_DPAM_ID        
           AND    DPAM_DELETED_IND  = 1        
           AND    DPTDC_DELETED_IND  = 1        
           AND    ISNULL(DPTDC_STATUS,'P')='P'        
           AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = @PA_BATCH_NO        
           AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
           AND    DPTDC_INTERNAL_TRASTM IN ('CMBO','CMCM','BOBO','BOCM')        
           AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
           AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
      
         END         
      
      --        
      END        
      IF @L_TRX_TAB = 'ID'        
      BEGIN        
      --        
        --POOL DPAM_ACCT_NO POOL 'B' ELSE 'S'        
        --SETTLEMNT LOOKUP + OTHER SETTL_NO        
        IF @PA_BATCH_TYPE = 'BN'        
         BEGIN        
            SELECT CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),DPTDC_EXECUTION_DT,103),'/',''))        
                + CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,SPACE(8)))        
                + CONVERT(CHAR(12),ISNULL(DPTDC_ISIN,''))        
                + CONVERT(CHAR(15),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DPTDC_QTY)),12,3,'L','0'))          
                + 'S' --CASE  WHEN ISNULL(CITRUS_USR.FN_ACCT_ENTP(DPAM_ID,'CMBP_ID'),'') = '' THEN 'S' ELSE 'B'END        
                + ISNULL(DPTDC_CASH_TRF,'X')        
                + CASE WHEN LTRIM(RTRIM(ISNULL(DPTDC_COUNTER_CMBP_ID,''))) <> '' THEN  CONVERT(CHAR(8),'') ELSE CONVERT(CHAR(8),ISNULL(DPTDC_COUNTER_DEMAT_ACCT_NO,'')) END       
                + CASE WHEN CONVERT(CHAR(8),ISNULL(DPTDC_COUNTER_CMBP_ID,'')) <> '' THEN CONVERT(CHAR(8),ISNULL(DPTDC_COUNTER_CMBP_ID,'')) ELSE  CONVERT(CHAR(8),ISNULL(DPTDC_COUNTER_DP_ID,'')) END        
                + CASE WHEN ISNULL(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' THEN CONVERT(CHAR(9),ISNULL(CITRUS_USR.GETCDSLINTERDPSETTTYPE('',DPTDC_OTHER_SETTLEMENT_NO,SETTM_TYPE_CDSL),'')   +ISNULL(DPTDC_OTHER_SETTLEMENT_NO,''))  ELSE CONVERT(CHAR(9),'') END 
   
   
     
                + CONVERT(CHAR(16),DPTDC_SLIP_NO+'/'+DPTDC_INTERNAL_REF_NO)  DETAILS        
               , ABS(DPTDC_QTY) QTY      
           FROM   DP_TRX_DTLS_CDSL         
                  LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR  ON CONVERT(VARCHAR,SETTM_ID) = DPTDC_OTHER_SETTLEMENT_TYPE AND DPTDC_OTHER_SETTLEMENT_TYPE <> ''      
                , DP_ACCT_MSTR        
      
           WHERE  DPAM_ID            = DPTDC_DPAM_ID        
           AND    DPAM_DELETED_IND   = 1        
           AND    DPTDC_DELETED_IND  = 1        
           AND    ISNULL(DPTDC_STATUS,'P')='P'        
           AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
           AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
           AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB       
           AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
           AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
      
           SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM DP_TRX_DTLS_CDSL,DP_ACCT_MSTR         
           WHERE  ISNULL(DPTDC_STATUS,'P')='P' AND DPTDC_DPAM_ID = DPAM_ID         
           AND    DPAM_DPM_ID   = @L_DPM_ID          
           AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
           AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
           AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB         
           AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
           AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
           IF @L_TOT_REC > 0        
           BEGIN         
      
               /* UPDATE IN DP_TRX_DTLS_CDSL*/        
      
               SELECT @L_TRANS_TYPE = DPTDC_INTERNAL_TRASTM FROM DP_TRX_DTLS_CDSL ,DP_ACCT_MSTR        
               WHERE  ISNULL(DPTDC_STATUS,'P')='P' AND DPTDC_DPAM_ID = DPAM_ID         
               AND    DPAM_DPM_ID   = @L_DPM_ID          
               AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
               AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
               AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB        
               AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
               AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
      
               UPDATE D1 SET DPTDC_BATCH_NO=@PA_BATCH_NO FROM DP_TRX_DTLS_CDSL D1 ,DP_ACCT_MSTR D2        
               WHERE  DPTDC_DPAM_ID = DPAM_ID         
               AND    DPAM_DPM_ID   = @L_DPM_ID          
               AND    ISNULL(DPTDC_STATUS,'P')='P'        
               AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
               AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
               AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB         
               AND    D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
               AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
      
      
               /* UPDATE IN BITMAP REF MSTR*/         
               UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
               WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @L_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID        
      
               /* INSERT INTO BATCH TABLE*/        
      
      
      
                IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@L_TRX_TAB)        
                 BEGIN        
                  INSERT INTO BATCHNO_CDSL_MSTR                                             
                  (          
                   BATCHC_DPM_ID,        
                   BATCHC_NO,        
                   BATCHC_RECORDS ,        
                   BATCHC_TRANS_TYPE,      
                   BATCHC_FILEGEN_DT,      
                   BATCHC_TYPE,        
                   BATCHC_STATUS,        
                   BATCHC_CREATED_BY,        
                   BATCHC_CREATED_DT ,        
                   BATCHC_DELETED_IND        
                  )        
                  VALUES        
                  (        
                   @L_DPM_ID,        
                   @PA_BATCH_NO,        
                   @L_TOT_REC,        
                   @L_TRANS_TYPE,      
                   CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',        
                   'T',        
                   'P',        
                   @PA_LOGINNAME,        
                   GETDATE(),        
                   1        
                  )            
                                                           END          
           END         
         END        
                          ELSE        
         BEGIN         
           SELECT CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),DPTDC_EXECUTION_DT,103),'/',''))        
                + CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,''))        
                + CONVERT(CHAR(12),ISNULL(DPTDC_ISIN,''))        
                + CONVERT(CHAR(15),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DPTDC_QTY)),12,3,'L','0'))          
                + 'S' --CASE  WHEN ISNULL(CITRUS_USR.FN_ACCT_ENTP(DPAM_ID,'CMBP_ID'),'') = '' THEN 'S' ELSE 'B'END        
                + ISNULL(DPTDC_CASH_TRF,'X')        
                + CASE WHEN LTRIM(RTRIM(ISNULL(DPTDC_COUNTER_CMBP_ID,''))) <> '' THEN  CONVERT(CHAR(8),'') ELSE CONVERT(CHAR(8),ISNULL(DPTDC_COUNTER_DEMAT_ACCT_NO,'')) END       
                + CASE WHEN CONVERT(CHAR(8),ISNULL(DPTDC_COUNTER_CMBP_ID,'')) <> '' THEN CONVERT(CHAR(8),ISNULL(DPTDC_COUNTER_CMBP_ID,'')) ELSE  CONVERT(CHAR(8),ISNULL(DPTDC_COUNTER_DP_ID,'')) END        
                + CASE WHEN ISNULL(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' THEN CONVERT(CHAR(9),ISNULL(CITRUS_USR.GETCDSLINTERDPSETTTYPE('',DPTDC_OTHER_SETTLEMENT_NO,SETTM_TYPE_CDSL),'')   +ISNULL(DPTDC_OTHER_SETTLEMENT_NO,''))  ELSE CONVERT(CHAR(9),'') END  
  
    
                + CONVERT(CHAR(16),DPTDC_SLIP_NO+'/'+DPTDC_INTERNAL_REF_NO)  DETAILS        
                , ABS(DPTDC_QTY) QTY      
           FROM   DP_TRX_DTLS_CDSL         
            LEFT OUTER JOIN  SETTLEMENT_TYPE_MSTR  ON CONVERT(VARCHAR,SETTM_ID) = DPTDC_OTHER_SETTLEMENT_TYPE AND DPTDC_OTHER_SETTLEMENT_TYPE <> ''      
                , DP_ACCT_MSTR        
      
           WHERE  DPAM_ID            = DPTDC_DPAM_ID        
           AND    DPAM_DELETED_IND   = 1        
           AND    DPTDC_DELETED_IND  = 1        
           AND    ISNULL(DPTDC_STATUS,'P')='P'        
           AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = @PA_BATCH_NO        
           AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
           AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB       
           AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
           AND    ISNULL(DPTDC_BROKERBATCH_NO,'') <> ''      
      
         END         
      
      --        
      END        
      IF @L_TRX_TAB= 'DMAT'        
      BEGIN        
      --        
        /*BO ID  --ACCT_NO        
        ISIN   --ISIN        
        DRF QTY --DEMRM_QTY        
        DRF NUMB --DEMRM_DRF_NO        
        DISPATCH DOC ID --LATER ON         
        DISPATCH NAME --LATER ON         
        DISPATCH DATE --LATER ON         
        NUMBER OF CERTIFICATES--DEMRM_TOTAL_CERTIFICATES        
        LOCKIN STATUS --DEMED_STATUS        
        LOCKIN CODE--DEMRM_LOCKIN_REASON_CD        
        LOCKIN REMARK --DEMRD_RMKS        
        LOCKIN EXPIRY DATE --LATER ON */        
        --COUNT TOTAL CERTI FROM PROCEDURE        
        IF @PA_BATCH_TYPE = 'BN'        
         BEGIN        
          SELECT CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,''))        
          + CONVERT(CHAR(12),ISNULL(DEMRM_ISIN,''))        
          + CONVERT(CHAR(16),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DEMRM_QTY)),13,3,'L','0'))         
          + CONVERT(CHAR(16),ISNULL(DEMRM_SLIP_SERIAL_NO,''))         
          + CONVERT(CHAR(20),CONVERT(VARCHAR(20),CASE WHEN ISNULL(DISP_DOC_ID,0) =0 THEN '' ELSE CONVERT(VARCHAR(20),DISP_DOC_ID) END))        
          + CONVERT(CHAR(30),ISNULL(DISP_NAME,''))        
          + CASE WHEN CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),ISNULL(DISP_DT,SPACE(8)),103),'/','')) = '01011900' THEN  CONVERT(CHAR(8),'00000000') ELSE CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),ISNULL(DISP_DT,SPACE(8)),103),'/','')) END       
          + CONVERT(CHAR(5),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(5),ISNULL(DEMRM_TOTAL_CERTIFICATES,'0')),5,0,'L','0'))        
          + CONVERT(CHAR(1),ISNULL(DEMRM_FREE_LOCKEDIN_YN,''))        
          + CONVERT(CHAR(2),ISNULL(DEMRM_LOCKIN_REASON_CD,''))        
          + CONVERT(CHAR(50),CASE WHEN LTRIM(RTRIM(ISNULL(DEMRM_RMKS,'')))='' THEN SPACE(50) ELSE LTRIM(RTRIM(ISNULL(DEMRM_RMKS,''))) END )       
          + CASE WHEN CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),ISNULL(DEMRM_LOCKIN_RELEASE_DT,SPACE(8)),103),'/','')) = '01011900' OR ISNULL(DEMRM_FREE_LOCKEDIN_YN,'N')='N'  THEN  CONVERT(CHAR(8),'00000000') ELSE CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR
  
    
(11),ISNULL(DEMRM_LOCKIN_RELEASE_DT,SPACE(8)),103),'/','')) END  DETAILS      
          ,ABS(DEMRM_QTY) QTY      
          FROM DEMAT_REQUEST_MSTR        
           LEFT OUTER JOIN DMAT_DISPATCH ON DEMRM_ID=DISP_DEMRM_ID      
          ,DP_ACCT_MSTR        
           WHERE DEMRM_DPAM_ID     = DPAM_ID         
           AND   DPAM_DELETED_IND  = 1        
           AND   DEMRM_DELETED_IND = 1        
           AND    ISNULL(DEMRM_STATUS,'P')='P'        
           AND    LTRIM(RTRIM(ISNULL(DEMRM_BATCH_NO,''))) = ''        
           AND   DEMRM_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'             
           AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
      
           SELECT @L_TOT_REC = COUNT(DEMRM_ID) FROM DEMAT_REQUEST_MSTR LEFT OUTER JOIN DMAT_DISPATCH ON DEMRM_ID=DISP_DEMRM_ID ,DP_ACCT_MSTR      
                                            ,DEMAT_REQUEST_DTLS      
           WHERE  ISNULL(DEMRM_STATUS,'P')='P' AND DEMRM_DPAM_ID = DPAM_ID AND DEMRM_ID= DEMRD_DEMRM_ID          
           AND    DPAM_DPM_ID      = @L_DPM_ID          
           AND    LTRIM(RTRIM(ISNULL(DEMRM_BATCH_NO,''))) = ''        
           AND    DEMRM_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                  AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
      
           IF @L_TOT_REC > 0        
           BEGIN         
      
              /* UPDATE IN DEMAT_REQUEST_MSTR*/         
              UPDATE D1 SET DEMRM_BATCH_NO=@PA_BATCH_NO FROM DEMAT_REQUEST_MSTR D1 ,DP_ACCT_MSTR D2        
              WHERE  DEMRM_DPAM_ID = DPAM_ID         
              AND    DPAM_DPM_ID   = @L_DPM_ID          
              AND    ISNULL(DEMRM_STATUS,'P')='P'        
              AND    LTRIM(RTRIM(ISNULL(DEMRM_BATCH_NO,''))) = ''        
              AND    DEMRM_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
              AND    D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END        
              /* UPDATE IN BITMAP REF MSTR*/         
              UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
              WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_'  + @L_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID        
      
              /* INSERT INTO BATCH TABLE*/                          
                IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@L_TRX_TAB)        
                 BEGIN        
                  INSERT INTO BATCHNO_CDSL_MSTR                                             
                  (          
                   BATCHC_DPM_ID,        
                   BATCHC_NO,        
                   BATCHC_RECORDS ,        
                   BATCHC_TRANS_TYPE,      
                   BATCHC_FILEGEN_DT,                 
                   BATCHC_TYPE,        
                   BATCHC_STATUS,        
                   BATCHC_CREATED_BY,        
                   BATCHC_CREATED_DT ,        
                   BATCHC_DELETED_IND        
                  )        
                  VALUES        
                  (        
                   @L_DPM_ID,        
                   @PA_BATCH_NO,        
                   @L_TOT_REC,        
                   @L_TRX_TAB,      
                   CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  ,      
                   'T',        
                   'P',        
                   @PA_LOGINNAME,        
                   GETDATE(),        
                   1        
              )            
                 END        
           END         
      
         END        
         ELSE        
         BEGIN         
          SELECT CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,''))        
            + CONVERT(CHAR(12),ISNULL(DEMRM_ISIN,''))        
            + CONVERT(CHAR(16),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DEMRM_QTY)),13,3,'L','0'))         
            + CONVERT(CHAR(16),ISNULL(DEMRM_SLIP_SERIAL_NO,''))         
            + CONVERT(CHAR(20),CONVERT(VARCHAR(20),CASE WHEN ISNULL(DISP_DOC_ID,0) =0 THEN '' ELSE CONVERT(VARCHAR(20),DISP_DOC_ID) END))        
            + CONVERT(CHAR(30),ISNULL(DISP_NAME,''))        
            + CASE WHEN CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),ISNULL(DISP_DT,SPACE(8)),103),'/','')) = '01011900' THEN  CONVERT(CHAR(8),'00000000') ELSE CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),ISNULL(DISP_DT,SPACE(8)),103),'/','')) END      
            + CONVERT(CHAR(5),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(5),ISNULL(DEMRM_TOTAL_CERTIFICATES,'0')),5,0,'L','0'))          
            + CONVERT(CHAR(1),ISNULL(DEMRM_FREE_LOCKEDIN_YN,''))        
            + CONVERT(CHAR(2),ISNULL(DEMRM_LOCKIN_REASON_CD,''))        
            + CONVERT(CHAR(50),CASE WHEN LTRIM(RTRIM(ISNULL(DEMRM_RMKS,'')))='' THEN SPACE(50) ELSE LTRIM(RTRIM(ISNULL(DEMRM_RMKS,''))) END )       
            + CASE WHEN CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),ISNULL(DEMRM_LOCKIN_RELEASE_DT,SPACE(8)),103),'/','')) = '01011900'  OR ISNULL(DEMRM_FREE_LOCKEDIN_YN,'N')='N' THEN  CONVERT(CHAR(8),'00000000') ELSE CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),ISNULL(DEMRM_LOCKIN_RELEASE_DT,SPACE(8)),103),'/','')) END  DETAILS      
           ,ABS(DEMRM_QTY) QTY      
           FROM  DEMAT_REQUEST_MSTR        
              LEFT OUTER JOIN DMAT_DISPATCH ON DEMRM_ID=DISP_DEMRM_ID      
            ,DP_ACCT_MSTR        
           WHERE DEMRM_DPAM_ID     = DPAM_ID         
           AND   DPAM_DELETED_IND  = 1        
           AND   DEMRM_DELETED_IND = 1        
           AND   ISNULL(DEMRM_STATUS,'P')='P'        
           AND   LTRIM(RTRIM(ISNULL(DEMRM_BATCH_NO,''))) = @PA_BATCH_NO        
           AND   DEMRM_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'             
           AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
         END         
      
      
      --        
      END        
IF @L_TRX_TAB= 'CLSR_ACCT_GEN'         
      BEGIN  
           


 SELECT CONVERT(VARCHAR(16),ISNULL(CLSR_BO_ID,''))AS CLSR_BO_ID ,
		CONVERT(VARCHAR(1),ISNULL(CLSR_TRX_TYPE,''))AS CLSR_TRX_TYPE,
		CONVERT(VARCHAR(2),ISNULL(CLSR_INI_BY,''))AS CLSR_INI_BY ,
		CONVERT(VARCHAR(2),ISNULL(CLSR_REASON_CD,'')) AS CLSR_REASON_CD ,
		CONVERT(VARCHAR(1),ISNULL(CLSR_REMAINING_BAL,''))AS CLSR_REMAINING_BAL ,
		CONVERT(VARCHAR(16),ISNULL(CLSR_NEW_BO_ID,''))AS CLSR_NEW_BO_ID ,
		CONVERT(VARCHAR(100),ISNULL(CLSR_RMKS,'')) AS CLSR_RMKS,
		CONVERT(VARCHAR(16),ISNULL(CLSR_ID,'')) AS CLSR_REQ_INT_REFNO  
		FROM CLOSURE_ACCT_CDSL 
		WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
  	

		SELECT @L_TOT_REC = COUNT(CLSR_ID) FROM CLOSURE_ACCT_CDSL      
		WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       




--SELECT @L_TOT_REC = COUNT(CLSR_ID) FROM CLOSURE_ACCT_CDSL      
--WHERE  CLSR_DATE BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)  AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)        
				 
PRINT(@L_TOT_REC)
	IF @L_TOT_REC > 0 
	
BEGIN         
          /* UPDATE IN BITMAP_REF_MSTR TABLE */         
          
 		    UPDATE BITMAP_REF_MSTR SET BITRM_VALUES = CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
            WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_CLOSURE_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID 
 	  
 	      print(@PA_BATCH_NO)
		   UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO =  @PA_BATCH_NO 
		   WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
 			


--           UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO = @PA_BATCH_NO 
--		   WHERE CLSR_DATE BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106) AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)        
-- 			
-- 
          /* INSERT INTO BATCHNO_CDSL_MSTR */                          
				
			IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1)        
                 BEGIN        
                  INSERT INTO BATCHNO_CDSL_MSTR                                             
                  (          
                   BATCHC_DPM_ID,        
                   BATCHC_NO,        
                   BATCHC_RECORDS,        
                   BATCHC_TRANS_TYPE,      
                   BATCHC_FILEGEN_DT,                 
                   BATCHC_TYPE,        
                   BATCHC_STATUS,        
                   BATCHC_CREATED_BY,        
                   BATCHC_CREATED_DT ,        
                   BATCHC_DELETED_IND        
                  )        
                  VALUES        
                  (        
                   @L_DPM_ID,        
                   @PA_BATCH_NO,        
                   CONVERT(NUMERIC,@L_TOT_REC),       
				   'ACCOUNT CLOSURE',      
                   CONVERT(VARCHAR,CONVERT(DATETIME,@PA_FROM_DT,103),106)+' 00:00:00'  ,      
                   'T',        
                   'P',        
                   @PA_LOGINNAME,        
                   GETDATE(),        
                   1        
                  ) 
  
        
			END                 
			END
			END 
			END   
   

    ELSE IF @PA_BROKER_YN = 'N'      

    BEGIN      
    --      
            IF @L_TRX_TAB = 'EP'        
            BEGIN        
             --        
                --FOR EXCH FILELOOKUP        
                --SETTLEMNT LOOKUP + OTHER SETTL_NO        
              IF @PA_BATCH_TYPE = 'BN'        
              BEGIN        
                SELECT CONVERT(CHAR(2),ISNULL(EXCM_SHORT_NAME,0))        
                     + CONVERT(CHAR(2),ISNULL(FILLM_FILE_VALUE,''))        
                    + CONVERT(CHAR(8),ISNULL(CONVERT(VARCHAR,DPTDC_CM_ID),''))        
                    + CONVERT(CHAR(13),ISNULL(CASE WHEN SETTM_TYPE_CDSL = 'TT' THEN 'W' WHEN SETTM_TYPE_CDSL = 'NR' THEN 'N' WHEN SETTM_TYPE_CDSL = 'NA' THEN 'A' ELSE SETTM_TYPE_CDSL END,0)+ISNULL(DPTDC_OTHER_SETTLEMENT_NO,''))        
                    + CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,''))        
                    + CONVERT(CHAR(12),ISNULL(DPTDC_ISIN,'') )        
                       + CONVERT(VARCHAR(16),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DPTDC_QTY)),13,3,'L','0'))          
                    + CONVERT(CHAR(16),ISNULL(DPTDC_COUNTER_DEMAT_ACCT_NO,''))        
                    + CONVERT(CHAR(16),DPTDC_SLIP_NO+'/'+DPTDC_INTERNAL_REF_NO)        
                    + CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),DPTDC_EXECUTION_DT,103),'/',''))  DETAILS      
                   , ABS(DPTDC_QTY) QTY      
                  FROM   DP_TRX_DTLS_CDSL         
                  LEFT OUTER JOIN  SETTLEMENT_TYPE_MSTR  ON CONVERT(VARCHAR,SETTM_ID) = DPTDC_OTHER_SETTLEMENT_TYPE AND DPTDC_OTHER_SETTLEMENT_TYPE <> ''      
                   , DP_ACCT_MSTR        
                        
                   , EXCHANGE_MSTR        
                   , CC_MSTR        
                   , EXCH_SEG_MSTR        
                   , BITMAP_REF_MSTR      
                   , FILE_LOOKUP_MSTR       
                  WHERE  DPAM_ID      = DPTDC_DPAM_ID        
                  AND    EXCM_ID      = DPTDC_EXCM_ID        
                  AND    FILLM_DB_VALUE = EXCM_SHORT_NAME      
                  AND    FILLM_FILE_NAME = 'CH_CDSL'      
                  AND    DPAM_DELETED_IND   = 1        
                  AND    DPTDC_DELETED_IND  = 1        
                  --AND    SETTM_DELETED_IND  = 1        
                  --AND    SETTM_ID           = CASE WHEN ISNULL(DPTDC_OTHER_SETTLEMENT_TYPE,'') = '' THEN SETTM_ID   ELSE  DPTDC_OTHER_SETTLEMENT_TYPE END          
                  AND    EXCM_CD            = EXCSM_EXCH_CD        
                  AND    EXCSM_DESC         = BITRM_CHILD_CD        
                  AND    CONVERT(INT,CCM_EXCSM_BIT) & POWER(2,BITRM_BIT_LOCATION-1) >0        
                  AND    EXCSM_DELETED_IND  = 1        
                  AND    CCM_DELETED_IND  = 1        
                  AND    ISNULL(DPTDC_STATUS,'P')='P'        
                  AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
                  AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                  AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB        
                  AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
                  AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
                     SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM DP_TRX_DTLS_CDSL ,DP_ACCT_MSTR        
                                             WHERE  ISNULL(DPTDC_STATUS,'P')='P' AND DPTDC_DPAM_ID = DPAM_ID         
                     AND    DPAM_DPM_ID   = @L_DPM_ID          
                     AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
                     AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                     AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB        
                     AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
                     AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
                     IF @L_TOT_REC > 0         
                     BEGIN         
                       /* UPDATE IN DP_TRX_DTLS_CDSL*/       
            
                     SELECT @L_TRANS_TYPE = DPTDC_INTERNAL_TRASTM FROM DP_TRX_DTLS_CDSL ,DP_ACCT_MSTR        
                     WHERE  ISNULL(DPTDC_STATUS,'P')='P' AND DPTDC_DPAM_ID = DPAM_ID         
                     AND    DPAM_DPM_ID   = @L_DPM_ID          
                     AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
                     AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                     AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB         
                     AND  DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
                     AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
                     UPDATE D1 SET DPTDC_BATCH_NO=@PA_BATCH_NO FROM DP_TRX_DTLS_CDSL D1 ,DP_ACCT_MSTR D2        
                     WHERE  DPTDC_DPAM_ID = DPAM_ID         
                     AND    DPAM_DPM_ID   = @L_DPM_ID          
                     AND    ISNULL(DPTDC_STATUS,'P')='P'        
                     AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
                     AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                     AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB         
                     AND    D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
                     AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
            
                     /* UPDATE IN BITMAP REF MSTR*/         
                     UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
                     WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @L_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID        
            
                     /* INSERT INTO BATCH TABLE*/        
            
            
            
                       IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@L_TRX_TAB)        
                       BEGIN        
                        INSERT INTO BATCHNO_CDSL_MSTR                                             
                        (          
                         BATCHC_DPM_ID,        
                         BATCHC_NO,        
                         BATCHC_RECORDS ,        
                 BATCHC_TRANS_TYPE,                 
                         BATCHC_TYPE,        
                         BATCHC_FILEGEN_DT,      
                         BATCHC_STATUS,        
                         BATCHC_CREATED_BY,        
                         BATCHC_CREATED_DT ,        
                         BATCHC_DELETED_IND        
                        )        
                        VALUES        
                        (        
                         @L_DPM_ID,        
                         @PA_BATCH_NO,        
                         @L_TOT_REC,        
                         @L_TRANS_TYPE,        
                         'T',       
                         CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',       
                         'P',        
                         @PA_LOGINNAME,        
                         GETDATE(),        
                         1        
                        )            
                                                                 END        
                        END        
            
                            END           
                            ELSE        
              BEGIN        
                SELECT CONVERT(CHAR(2),ISNULL(EXCM_SHORT_NAME,0))        
                     + CONVERT(CHAR(2),ISNULL(FILLM_FILE_VALUE,''))        
                    + CONVERT(CHAR(8),ISNULL(CONVERT(VARCHAR,DPTDC_CM_ID),''))        
                    + CONVERT(CHAR(13),ISNULL(CASE WHEN SETTM_TYPE_CDSL = 'TT' THEN 'W' WHEN SETTM_TYPE_CDSL = 'NR' THEN 'N' WHEN SETTM_TYPE_CDSL = 'NA' THEN 'A' ELSE SETTM_TYPE_CDSL END,0)+ISNULL(DPTDC_OTHER_SETTLEMENT_NO,''))        
                    + CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,''))        
                    + CONVERT(CHAR(12),ISNULL(DPTDC_ISIN,'') )        
                       + CONVERT(VARCHAR(16),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DPTDC_QTY)),13,3,'L','0'))          
       + CONVERT(CHAR(16),ISNULL(DPTDC_COUNTER_DEMAT_ACCT_NO,''))        
                    + CONVERT(CHAR(16),DPTDC_SLIP_NO+'/'+DPTDC_INTERNAL_REF_NO)       
                    + CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),DPTDC_EXECUTION_DT,103),'/',''))  DETAILS      
                    , ABS(DPTDC_QTY) QTY      
                  FROM   DP_TRX_DTLS_CDSL         
                         LEFT OUTER JOIN  SETTLEMENT_TYPE_MSTR  ON CONVERT(VARCHAR,SETTM_ID) = DPTDC_OTHER_SETTLEMENT_TYPE AND DPTDC_OTHER_SETTLEMENT_TYPE <> ''      
                   , DP_ACCT_MSTR        
                   , EXCHANGE_MSTR        
                   , CC_MSTR        
                   , EXCH_SEG_MSTR        
                   , BITMAP_REF_MSTR        
                   , FILE_LOOKUP_MSTR       
                  WHERE  DPAM_ID      = DPTDC_DPAM_ID        
                  AND    EXCM_ID      = DPTDC_EXCM_ID       
                  AND    FILLM_DB_VALUE = EXCM_SHORT_NAME      
                  AND    FILLM_FILE_NAME = 'CH_CDSL'      
                  AND    DPAM_DELETED_IND   = 1        
                  AND    DPTDC_DELETED_IND  = 1        
                  --AND    SETTM_DELETED_IND  = 1        
                  --AND    SETTM_ID           = CASE WHEN ISNULL(DPTDC_OTHER_SETTLEMENT_TYPE,'') = '' THEN SETTM_ID   ELSE  DPTDC_OTHER_SETTLEMENT_TYPE END          
                  AND    EXCM_CD            = EXCSM_EXCH_CD        
                  AND    EXCSM_DESC         = BITRM_CHILD_CD        
                  AND    CONVERT(INT,CCM_EXCSM_BIT) & POWER(2,BITRM_BIT_LOCATION-1) >0        
                                                AND    ISNULL(DPTDC_STATUS,'P') = 'P'        
                                                AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = @PA_BATCH_NO        
                  AND    EXCSM_DELETED_IND  = 1        
                  AND    CCM_DELETED_IND  = 1        
                  AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                  AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB        
      AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
                  AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
               END         
             --        
            END        
            IF @L_TRX_TAB = 'NP'        
            BEGIN        
            --        
              --FOR EXCH FILELOOKUP        
              --SETTLEMNT LOOKUP + OTHER SETTL_NO        
              IF @PA_BATCH_TYPE = 'BN'        
              BEGIN        
              SELECT 'D'+ CONVERT(CHAR(2),'01')        
                   + CONVERT(CHAR(2),ISNULL(FILLM_FILE_VALUE,''))        
                   + CONVERT(CHAR(2),ISNULL(EXCM_SHORT_NAME,0))        
                   + CONVERT(CHAR(13),ISNULL(CASE WHEN SETTM_TYPE_CDSL = 'TT' THEN 'W' WHEN SETTM_TYPE_CDSL = 'NR' THEN 'N' WHEN SETTM_TYPE_CDSL = 'NA' THEN 'A' ELSE SETTM_TYPE_CDSL END,0)+ISNULL(DPTDC_OTHER_SETTLEMENT_NO,''))        
                   + CONVERT(CHAR(6),ISNULL(RIGHT(DPM_DPID,6),''))         
                   + CONVERT(CHAR(8),ISNULL(CONVERT(VARCHAR,DPTDC_CM_ID),'') )        
                   + CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,'') )        
                   + CONVERT(CHAR(12),ISNULL(DPTDC_ISIN,'') )       
            
                   + CONVERT(CHAR(6),'000000')        
                   + CONVERT(CHAR(4),'0000')        
                   + CONVERT(VARCHAR(16),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DPTDC_QTY)),13,3,'L','0'))          
                   + 'S'        
                   + CONVERT(CHAR(16),DPTDC_SLIP_NO+'/'+DPTDC_INTERNAL_REF_NO)  DETAILS      
                   , ABS(DPTDC_QTY) QTY      
              FROM  DP_TRX_DTLS_CDSL         
                    LEFT OUTER JOIN  SETTLEMENT_TYPE_MSTR  ON CONVERT(VARCHAR,SETTM_ID) = DPTDC_OTHER_SETTLEMENT_TYPE AND DPTDC_OTHER_SETTLEMENT_TYPE <> ''      
                   , DP_ACCT_MSTR        
                   , EXCHANGE_MSTR        
                   , CC_MSTR        
                   , EXCH_SEG_MSTR        
                   , BITMAP_REF_MSTR        
                   ,DP_MSTR       
                   , FILE_LOOKUP_MSTR      
              WHERE  DPAM_ID      = DPTDC_DPAM_ID        
              AND    DPAM_DPM_ID  = DPM_ID      
              AND    FILLM_DB_VALUE = EXCM_SHORT_NAME      
              AND    FILLM_FILE_NAME = 'CH_CDSL'      
              AND    EXCM_ID      = DPTDC_EXCM_ID        
              AND    DPAM_DELETED_IND   = 1        
              AND    DPTDC_DELETED_IND  = 1        
              --AND    SETTM_DELETED_IND  = 1        
              --AND    SETTM_ID           = CASE WHEN ISNULL(DPTDC_OTHER_SETTLEMENT_TYPE,'') = '' THEN SETTM_ID   ELSE  DPTDC_OTHER_SETTLEMENT_TYPE END          
              AND    EXCM_CD            = EXCSM_EXCH_CD        
              AND    EXCSM_DESC         = BITRM_CHILD_CD        
              AND    CONVERT(INT,CCM_EXCSM_BIT) & POWER(2,BITRM_BIT_LOCATION-1) >0        
              AND    EXCSM_DELETED_IND  = 1        
              AND    CCM_DELETED_IND  = 1        
              AND    ISNULL(DPTDC_STATUS,'P')='P'        
              AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
              AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
              AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB        
              AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
              AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
            
               SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM DP_TRX_DTLS_CDSL ,DP_ACCT_MSTR        
                                    WHERE  ISNULL(DPTDC_STATUS,'P')='P' AND DPTDC_DPAM_ID = DPAM_ID         
                                    AND    DPAM_DPM_ID   = @L_DPM_ID          
               AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
               AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
               AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB          
               AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
               AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
               IF @L_TOT_REC > 0         
               BEGIN         
                  /* UPDATE IN DP_TRX_DTLS_CDSL*/        
            
                  SELECT @L_TRANS_TYPE = DPTDC_INTERNAL_TRASTM FROM DP_TRX_DTLS_CDSL ,DP_ACCT_MSTR        
                  WHERE  ISNULL(DPTDC_STATUS,'P')='P' AND DPTDC_DPAM_ID = DPAM_ID         
                  AND    DPAM_DPM_ID   = @L_DPM_ID          
                  AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
                  AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                  AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB       
                  AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END        
                  AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
                  UPDATE D1 SET DPTDC_BATCH_NO=@PA_BATCH_NO FROM DP_TRX_DTLS_CDSL D1 ,DP_ACCT_MSTR D2        
                  WHERE  DPTDC_DPAM_ID = DPAM_ID         
                  AND    DPAM_DPM_ID   = @L_DPM_ID          
                  AND    ISNULL(DPTDC_STATUS,'P')='P'        
                  AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
                  AND    DPTDC_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                  AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB        
                  AND    D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
                  AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
                     /* UPDATE IN BITMAP REF MSTR*/         
                  UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
                  WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @L_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID        
            
                  /* INSERT INTO BATCH TABLE*/        
            
            
            
                      IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@L_TRX_TAB)        
                       BEGIN        
                        INSERT INTO BATCHNO_CDSL_MSTR                                             
                        (          
                         BATCHC_DPM_ID,        
                         BATCHC_NO,        
                         BATCHC_RECORDS ,        
                         BATCHC_TRANS_TYPE,      
                         BATCHC_FILEGEN_DT,                 
                         BATCHC_TYPE,        
                         BATCHC_STATUS,        
                         BATCHC_CREATED_BY,        
                         BATCHC_CREATED_DT ,        
                         BATCHC_DELETED_IND        
                        )        
                        VALUES        
                        (        
                         @L_DPM_ID,        
                         @PA_BATCH_NO,        
                         @L_TOT_REC,        
                         @L_TRANS_TYPE,      
                         CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',        
                         'T',        
                         'P',        
                         @PA_LOGINNAME,        
                         GETDATE(),        
                         1        
                        )            
                   END        
            
               END        
            
                                END        
                            ELSE         
                                BEGIN        
              SELECT 'D'+CONVERT(CHAR(2),'01')        
                   + CONVERT(CHAR(2),ISNULL(FILLM_FILE_VALUE,''))        
                   + CONVERT(CHAR(2),ISNULL(EXCM_SHORT_NAME,0))        
                   + CONVERT(CHAR(13),ISNULL(CASE WHEN SETTM_TYPE_CDSL = 'TT' THEN 'W' WHEN SETTM_TYPE_CDSL = 'NR' THEN 'N' WHEN SETTM_TYPE_CDSL = 'NA' THEN 'A' ELSE SETTM_TYPE_CDSL END,0)+ISNULL(DPTDC_OTHER_SETTLEMENT_NO,''))        
                   + CONVERT(CHAR(6),ISNULL(RIGHT(DPM_DPID,6),''))          
                   + CONVERT(CHAR(8),ISNULL(CONVERT(VARCHAR,DPTDC_CM_ID),'') )       
                   + CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,'') )        
                   + CONVERT(CHAR(12),ISNULL(DPTDC_ISIN,'') )        
                   + CONVERT(CHAR(6),'000000')        
                   + CONVERT(CHAR(4),'0000')        
                   + CONVERT(VARCHAR(16),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DPTDC_QTY)),13,3,'L','0'))          
                   + 'S'        
                   + CONVERT(CHAR(16),DPTDC_SLIP_NO+'/'+DPTDC_INTERNAL_REF_NO)  DETAILS      
                   , ABS(DPTDC_QTY) QTY      
              FROM  DP_TRX_DTLS_CDSL         
                    LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR  ON CONVERT(VARCHAR,SETTM_ID) = DPTDC_OTHER_SETTLEMENT_TYPE AND DPTDC_OTHER_SETTLEMENT_TYPE <> ''      
                   , DP_ACCT_MSTR        
                         
      , EXCHANGE_MSTR        
                   , CC_MSTR        
                   , EXCH_SEG_MSTR        
                   , BITMAP_REF_MSTR        
                    ,DP_MSTR      
                    , FILE_LOOKUP_MSTR      
              WHERE  DPAM_ID      = DPTDC_DPAM_ID        
              AND    DPAM_DPM_ID      = DPM_ID       
              AND    FILLM_DB_VALUE = EXCM_SHORT_NAME      
              AND    FILLM_FILE_NAME = 'CH_CDSL'      
              AND    EXCM_ID      = DPTDC_EXCM_ID        
              AND    DPAM_DELETED_IND   = 1        
              AND    DPTDC_DELETED_IND  = 1        
              --AND    SETTM_DELETED_IND  = 1        
              --AND    SETTM_ID           = CASE WHEN ISNULL(DPTDC_OTHER_SETTLEMENT_TYPE,'') = '' THEN SETTM_ID   ELSE  DPTDC_OTHER_SETTLEMENT_TYPE END          
              AND    EXCM_CD            = EXCSM_EXCH_CD        
              AND    EXCSM_DESC         = BITRM_CHILD_CD        
              AND    CONVERT(INT,CCM_EXCSM_BIT) & POWER(2,BITRM_BIT_LOCATION-1) >0        
              AND    EXCSM_DELETED_IND  = 1        
              AND    CCM_DELETED_IND  = 1        
                                AND    ISNULL(DPTDC_STATUS,'P')='P'        
                  AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = @PA_BATCH_NO        
              AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
              AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB        
              AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
              AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
              END         
            --        
            END        
            IF @L_TRX_TAB IN ('OFFM')        
            BEGIN        
            --         
               -- IN CASE OF REQUEST FOR OFF MARKET        
              IF @PA_BATCH_TYPE = 'BN'        
               BEGIN        
                SELECT DISTINCT REPLACE(CONVERT(VARCHAR(11),DPTDC_EXECUTION_DT,103),'/','')        
                      + ISNULL(DPAM_SBA_NO,'')        
                      + ISNULL(DPTDC_COUNTER_DP_ID,'') + ISNULL(DPTDC_COUNTER_DEMAT_ACCT_NO,'')        
                      + ISNULL(CONVERT(CHAR(12),DPTDC_ISIN),'')        
                      + CONVERT(VARCHAR(16),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DPTDC_QTY)),12,3,'L','0'))      
                      + CASE  WHEN DPTDC_INTERNAL_TRASTM IN('BOCM','CMCM') THEN 'S' WHEN DPTDC_INTERNAL_TRASTM = 'CMBO' THEN 'S' ELSE 'S' END        
                      + ISNULL(DPTDC_CASH_TRF,'')        
                      + ISNULL(CONVERT(VARCHAR(10),DPTDC_REASON_CD),'0')        
                      + CONVERT(CHAR(16),DPTDC_SLIP_NO+'/'+DPTDC_INTERNAL_REF_NO)      
                      +  CASE WHEN ISNULL(DPTDC_SETTLEMENT_NO,'') <> '' THEN CONVERT(CHAR(13),ISNULL(CITRUS_USR.GETCDSLINTERDPSETTTYPE('',DPTDC_SETTLEMENT_NO,SETTM_TYPE_CDSL),'')   +ISNULL(DPTDC_SETTLEMENT_NO,''))  ELSE CONVERT(CHAR(13),'') END  DETAILS 
  
     
      
                         , ABS(DPTDC_QTY) QTY      
                 FROM   DP_TRX_DTLS_CDSL         
                   LEFT OUTER JOIN  SETTLEMENT_TYPE_MSTR  ON CONVERT(VARCHAR,SETTM_ID) = DPTDC_MKT_TYPE AND DPTDC_MKT_TYPE <> ''      
                      , DP_ACCT_MSTR        
                 WHERE  DPAM_ID  = DPTDC_DPAM_ID        
                 AND    DPAM_DELETED_IND  = 1        
                 AND    ISNULL(DPTDC_STATUS,'P')='P'        
                 AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
                 AND    DPTDC_DELETED_IND  = 1        
                 AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                 AND    DPTDC_INTERNAL_TRASTM IN ('CMBO','CMCM','BOBO','BOCM')   
                 AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
                                                  AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
      
      
                 SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM DP_TRX_DTLS_CDSL ,DP_ACCT_MSTR        
                 WHERE  ISNULL(DPTDC_STATUS,'P')='P' AND DPTDC_DPAM_ID = DPAM_ID         
                 AND    DPAM_DPM_ID   = @L_DPM_ID          
                 AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
                 AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                 AND    DPTDC_INTERNAL_TRASTM IN ('CMBO','CMCM','BOBO','BOCM')        
                 AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END        
                 AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
                 IF @L_TOT_REC > 0         
                  BEGIN        
                     /* UPDATE IN DP_TRX_DTLS_CDSL*/       
            
                     SELECT @L_TRANS_TYPE = DPTDC_INTERNAL_TRASTM FROM DP_TRX_DTLS_CDSL ,DP_ACCT_MSTR        
                     WHERE  ISNULL(DPTDC_STATUS,'P')='P' AND DPTDC_DPAM_ID = DPAM_ID         
                     AND    DPAM_DPM_ID   = @L_DPM_ID          
                     AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
                     AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                     AND    DPTDC_INTERNAL_TRASTM IN ('CMBO','CMCM','BOBO','BOCM')        
                     AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END        
                     AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
                     UPDATE D1 SET DPTDC_BATCH_NO=@PA_BATCH_NO FROM DP_TRX_DTLS_CDSL D1 ,DP_ACCT_MSTR D2        
                     WHERE  DPTDC_DPAM_ID = DPAM_ID         
                     AND    DPAM_DPM_ID   = @L_DPM_ID          
                     AND    ISNULL(DPTDC_STATUS,'P')='P'        
                     AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
                     AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                     AND    DPTDC_INTERNAL_TRASTM IN ('CMBO','CMCM','BOBO','BOCM')        
                     AND    D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
                     AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
            
                     /* UPDATE IN BITMAP REF MSTR*/         
                     UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
                     WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @L_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD = @L_DPM_ID       
                     AND BITRM_BIT_LOCATION = @PA_EXCSM_ID         
            
            
            
            
                     /* INSERT INTO BATCH TABLE*/                    
            
                      IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@L_TRX_TAB)        
                       BEGIN        
            
                        INSERT INTO BATCHNO_CDSL_MSTR                                             
                        (          
                         BATCHC_DPM_ID,        
                         BATCHC_NO,        
                         BATCHC_RECORDS ,        
             BATCHC_TRANS_TYPE,       
                         BATCHC_FILEGEN_DT,                
                         BATCHC_TYPE,        
                         BATCHC_STATUS,        
                         BATCHC_CREATED_BY,        
                         BATCHC_CREATED_DT ,        
                         BATCHC_DELETED_IND        
                        )        
                        VALUES        
                        (        
                         @L_DPM_ID,        
                         @PA_BATCH_NO,        
                         @L_TOT_REC,        
                         @L_TRX_TAB,--@L_TRANS_TYPE,      
                         CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',        
                         'T',        
                         'P',        
                         @PA_LOGINNAME,        
                         GETDATE(),        
                         1        
                        )            
                         END        
                  END                    
            
               END        
                                ELSE        
               BEGIN         
                SELECT DISTINCT REPLACE(CONVERT(VARCHAR(11),DPTDC_EXECUTION_DT,103),'/','')        
                      + ISNULL(DPAM_SBA_NO,'')        
                      + ISNULL(DPTDC_COUNTER_DP_ID,'') + ISNULL(DPTDC_COUNTER_DEMAT_ACCT_NO,'')        
                      + ISNULL(CONVERT(CHAR(12),DPTDC_ISIN),'')        
                      + CONVERT(VARCHAR(16),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DPTDC_QTY)),12,3,'L','0'))          
                      + CASE  WHEN DPTDC_INTERNAL_TRASTM IN('BOCM','CMCM') THEN 'S' WHEN DPTDC_INTERNAL_TRASTM = 'CMBO' THEN 'S' ELSE 'S' END        
                      + ISNULL(DPTDC_CASH_TRF,'')        
                      + ISNULL(CONVERT(VARCHAR(10),DPTDC_REASON_CD),'0')        
                      + CONVERT(CHAR(16),DPTDC_SLIP_NO+'/'+DPTDC_INTERNAL_REF_NO)       
                      +  CASE WHEN ISNULL(DPTDC_SETTLEMENT_NO,'') <> '' THEN CONVERT(CHAR(13),ISNULL(CITRUS_USR.GETCDSLINTERDPSETTTYPE('',DPTDC_SETTLEMENT_NO,SETTM_TYPE_CDSL),'')   +ISNULL(DPTDC_SETTLEMENT_NO,''))  ELSE CONVERT(CHAR(13),'') END  DETAILS 
  
     
                          , ABS(DPTDC_QTY) QTY      
                 FROM   DP_TRX_DTLS_CDSL         
                 LEFT OUTER JOIN  SETTLEMENT_TYPE_MSTR  ON CONVERT(VARCHAR,SETTM_ID) = DPTDC_MKT_TYPE AND DPTDC_MKT_TYPE <> ''      
                      , DP_ACCT_MSTR        
                 WHERE  DPAM_ID  = DPTDC_DPAM_ID        
                 AND    DPAM_DELETED_IND  = 1        
                 AND    DPTDC_DELETED_IND  = 1        
                 AND    ISNULL(DPTDC_STATUS,'P')='P'        
                 AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = @PA_BATCH_NO        
                 AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                 AND    DPTDC_INTERNAL_TRASTM IN ('CMBO','CMCM','BOBO','BOCM')        
                 AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
                 AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
               END         
            
            --        
            END        
            IF @L_TRX_TAB = 'ID'        
            BEGIN        
            --        
              --POOL DPAM_ACCT_NO POOL 'B' ELSE 'S'        
              --SETTLEMNT LOOKUP + OTHER SETTL_NO        
              IF @PA_BATCH_TYPE = 'BN'        
               BEGIN        
                  SELECT CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),DPTDC_EXECUTION_DT,103),'/',''))        
                      + CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,SPACE(8)))        
                      + CONVERT(CHAR(12),ISNULL(DPTDC_ISIN,''))        
                      + CONVERT(CHAR(15),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DPTDC_QTY)),12,3,'L','0'))          
                      + 'S' --CASE  WHEN ISNULL(CITRUS_USR.FN_ACCT_ENTP(DPAM_ID,'CMBP_ID'),'') = '' THEN 'S' ELSE 'B'END        
                      + ISNULL(DPTDC_CASH_TRF,'X')        
                      + CASE WHEN LTRIM(RTRIM(ISNULL(DPTDC_COUNTER_CMBP_ID,''))) <> '' THEN  CONVERT(CHAR(8),'') ELSE CONVERT(CHAR(8),ISNULL(DPTDC_COUNTER_DEMAT_ACCT_NO,'')) END       
                      + CASE WHEN CONVERT(CHAR(8),ISNULL(DPTDC_COUNTER_CMBP_ID,'')) <> '' THEN CONVERT(CHAR(8),ISNULL(DPTDC_COUNTER_CMBP_ID,'')) ELSE  CONVERT(CHAR(8),ISNULL(DPTDC_COUNTER_DP_ID,'')) END        
                      + CASE WHEN ISNULL(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' THEN CONVERT(CHAR(9),ISNULL(CITRUS_USR.GETCDSLINTERDPSETTTYPE('',DPTDC_OTHER_SETTLEMENT_NO,SETTM_TYPE_CDSL),'')   +ISNULL(DPTDC_OTHER_SETTLEMENT_NO,''))  ELSE CONVERT(CHAR(9),'')
  
    
 END      
                      + CONVERT(CHAR(16),DPTDC_SLIP_NO+'/'+DPTDC_INTERNAL_REF_NO)  DETAILS        
                     , ABS(DPTDC_QTY) QTY      
                 FROM   DP_TRX_DTLS_CDSL         
                    LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR  ON CONVERT(VARCHAR,SETTM_ID) = DPTDC_OTHER_SETTLEMENT_TYPE AND DPTDC_OTHER_SETTLEMENT_TYPE <> ''      
                    , DP_ACCT_MSTR        
            
                 WHERE  DPAM_ID            = DPTDC_DPAM_ID        
                 AND    DPAM_DELETED_IND   = 1        
                 AND    DPTDC_DELETED_IND  = 1        
                 AND    ISNULL(DPTDC_STATUS,'P')='P'        
                 AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
                 AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                 AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB       
                 AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
                 AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
                 SELECT @L_TOT_REC = COUNT(DPTDC_ID) FROM DP_TRX_DTLS_CDSL,DP_ACCT_MSTR         
                 WHERE  ISNULL(DPTDC_STATUS,'P')='P' AND DPTDC_DPAM_ID = DPAM_ID         
                 AND    DPAM_DPM_ID   = @L_DPM_ID          
                 AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
                 AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                 AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB         
                 AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
                 AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
                 IF @L_TOT_REC > 0        
                 BEGIN         
            
                     /* UPDATE IN DP_TRX_DTLS_CDSL*/        
            
                     SELECT @L_TRANS_TYPE = DPTDC_INTERNAL_TRASTM FROM DP_TRX_DTLS_CDSL ,DP_ACCT_MSTR        
                     WHERE  ISNULL(DPTDC_STATUS,'P')='P' AND DPTDC_DPAM_ID = DPAM_ID         
                     AND    DPAM_DPM_ID   = @L_DPM_ID          
                     AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
                     AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                     AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB        
                     AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
                     AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
                     UPDATE D1 SET DPTDC_BATCH_NO=@PA_BATCH_NO FROM DP_TRX_DTLS_CDSL D1 ,DP_ACCT_MSTR D2        
                     WHERE DPTDC_DPAM_ID = DPAM_ID         
                     AND    DPAM_DPM_ID   = @L_DPM_ID          
                     AND    ISNULL(DPTDC_STATUS,'P')='P'        
                     AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = ''        
                     AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                     AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB         
                     AND    D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
                     AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
            
                     /* UPDATE IN BITMAP REF MSTR*/         
                     UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
                     WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + @L_TRX_TAB + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID        
            
                     /* INSERT INTO BATCH TABLE*/        
            
            
            
                      IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@L_TRX_TAB)        
                       BEGIN        
                        INSERT INTO BATCHNO_CDSL_MSTR                                             
                        (          
                         BATCHC_DPM_ID,        
                         BATCHC_NO,        
                         BATCHC_RECORDS ,        
                         BATCHC_TRANS_TYPE,      
                         BATCHC_FILEGEN_DT,      
                         BATCHC_TYPE,        
                         BATCHC_STATUS,        
                         BATCHC_CREATED_BY,        
                         BATCHC_CREATED_DT ,        
                         BATCHC_DELETED_IND        
                        )        
                        VALUES        
                        (        
                         @L_DPM_ID,        
                         @PA_BATCH_NO,        
                         @L_TOT_REC,        
                         @L_TRANS_TYPE,      
                         CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',        
                         'T',        
                         'P',        
                         @PA_LOGINNAME,        
                         GETDATE(),        
                         1        
                        )            
                                                                 END          
                 END         
               END        
                                ELSE        
               BEGIN         
                 SELECT CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),DPTDC_EXECUTION_DT,103),'/',''))        
                      + CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,''))        
                      + CONVERT(CHAR(12),ISNULL(DPTDC_ISIN,''))        
                      + CONVERT(CHAR(15),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DPTDC_QTY)),12,3,'L','0'))          
                      + 'S' --CASE  WHEN ISNULL(CITRUS_USR.FN_ACCT_ENTP(DPAM_ID,'CMBP_ID'),'') = '' THEN 'S' ELSE 'B'END        
                      + ISNULL(DPTDC_CASH_TRF,'X')        
                      + CASE WHEN LTRIM(RTRIM(ISNULL(DPTDC_COUNTER_CMBP_ID,''))) <> '' THEN  CONVERT(CHAR(8),'') ELSE CONVERT(CHAR(8),ISNULL(DPTDC_COUNTER_DEMAT_ACCT_NO,'')) END       
                      + CASE WHEN CONVERT(CHAR(8),ISNULL(DPTDC_COUNTER_CMBP_ID,'')) <> '' THEN CONVERT(CHAR(8),ISNULL(DPTDC_COUNTER_CMBP_ID,'')) ELSE  CONVERT(CHAR(8),ISNULL(DPTDC_COUNTER_DP_ID,'')) END        
                      + CASE WHEN ISNULL(DPTDC_OTHER_SETTLEMENT_NO,'') <> '' THEN CONVERT(CHAR(9),ISNULL(CITRUS_USR.GETCDSLINTERDPSETTTYPE('',DPTDC_OTHER_SETTLEMENT_NO,SETTM_TYPE_CDSL),'')   +ISNULL(DPTDC_OTHER_SETTLEMENT_NO,''))  ELSE CONVERT(CHAR(9),''
)  
    
 END      
                      + CONVERT(CHAR(16),DPTDC_SLIP_NO+'/'+DPTDC_INTERNAL_REF_NO)  DETAILS        
                      , ABS(DPTDC_QTY) QTY      
                 FROM   DP_TRX_DTLS_CDSL         
                  LEFT OUTER JOIN  SETTLEMENT_TYPE_MSTR  ON CONVERT(VARCHAR,SETTM_ID) = DPTDC_OTHER_SETTLEMENT_TYPE AND DPTDC_OTHER_SETTLEMENT_TYPE <> ''      
                      , DP_ACCT_MSTR        
            
                 WHERE  DPAM_ID            = DPTDC_DPAM_ID        
                 AND    DPAM_DELETED_IND   = 1        
                 AND    DPTDC_DELETED_IND  = 1        
                 AND    ISNULL(DPTDC_STATUS,'P')='P'        
                 AND    LTRIM(RTRIM(ISNULL(DPTDC_BATCH_NO,''))) = @PA_BATCH_NO        
                 AND    DPTDC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                 AND    DPTDC_INTERNAL_TRASTM = @L_TRX_TAB       
                 AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
                 AND ISNULL(DPTDC_BROKERBATCH_NO,'') = ''      
            
               END         
            
            --        
            END        
            IF @L_TRX_TAB= 'DMAT'        
            BEGIN        
            --        
              /*BO ID  --ACCT_NO        
              ISIN   --ISIN        
              DRF QTY --DEMRM_QTY        
              DRF NUMB --DEMRM_DRF_NO        
              DISPATCH DOC ID --LATER ON         
              DISPATCH NAME --LATER ON         
              DISPATCH DATE --LATER ON         
              NUMBER OF CERTIFICATES--DEMRM_TOTAL_CERTIFICATES        
              LOCKIN STATUS --DEMED_STATUS        
              LOCKIN CODE--DEMRM_LOCKIN_REASON_CD        
              LOCKIN REMARK --DEMRD_RMKS        
              LOCKIN EXPIRY DATE --LATER ON */        
              --COUNT TOTAL CERTI FROM PROCEDURE        
              IF @PA_BATCH_TYPE = 'BN'        
               BEGIN        
                SELECT CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,''))        
                + CONVERT(CHAR(12),ISNULL(DEMRM_ISIN,''))        
                + CONVERT(CHAR(16),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DEMRM_QTY)),13,3,'L','0'))         
                + CONVERT(CHAR(16),ISNULL(DEMRM_SLIP_SERIAL_NO,''))         
                                                                + CONVERT(CHAR(20),CONVERT(VARCHAR(20),CASE WHEN ISNULL(DISP_DOC_ID,0) =0 THEN '' ELSE CONVERT(VARCHAR(20),DISP_DOC_ID) END))        
                                  + CONVERT(CHAR(30),ISNULL(DISP_NAME,''))      
                + CASE WHEN CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),ISNULL(DISP_DT,SPACE(8)),103),'/','')) = '01011900' THEN  CONVERT(CHAR(8),'00000000') ELSE CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),ISNULL(DISP_DT,SPACE(8)),103),'/','')) END      
  
         + CONVERT(CHAR(5),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(5),ISNULL(DEMRM_TOTAL_CERTIFICATES,'0')),5,0,'L','0'))          
                + CONVERT(CHAR(1),ISNULL(DEMRM_FREE_LOCKEDIN_YN,''))        
                + CONVERT(CHAR(2),ISNULL(DEMRM_LOCKIN_REASON_CD,''))        
                + CONVERT(CHAR(50),CASE WHEN LTRIM(RTRIM(ISNULL(DEMRM_RMKS,'')))='' THEN SPACE(50) ELSE LTRIM(RTRIM(ISNULL(DEMRM_RMKS,''))) END )       
                + CASE WHEN CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),ISNULL(DEMRM_LOCKIN_RELEASE_DT,SPACE(8)),103),'/','')) = '01011900'  OR ISNULL(DEMRM_FREE_LOCKEDIN_YN,'N')='N' THEN  CONVERT(CHAR(8),'00000000') ELSE CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),ISNULL(DEMRM_LOCKIN_RELEASE_DT,SPACE(8)),103),'/','')) END  DETAILS      
                                                                ,ABS(DEMRM_QTY) QTY      
                 FROM  DEMAT_REQUEST_MSTR        
                 LEFT OUTER JOIN DMAT_DISPATCH ON DEMRM_ID=DISP_DEMRM_ID      
                 ,DP_ACCT_MSTR        
                 WHERE DEMRM_DPAM_ID     = DPAM_ID         
                 AND   DPAM_DELETED_IND  = 1        
                 AND   DEMRM_DELETED_IND = 1        
                 AND    ISNULL(DEMRM_STATUS,'P')='P'        
                 AND    LTRIM(RTRIM(ISNULL(DEMRM_BATCH_NO,''))) = ''      
                 AND   ISNULL(DEMRM_INTERNAL_REJ,'') = ''         
                 AND   DEMRM_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'             
                 AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
            
                 SELECT @L_TOT_REC = COUNT(DEMRM_ID) FROM DEMAT_REQUEST_MSTR LEFT OUTER JOIN DMAT_DISPATCH ON DEMRM_ID=DISP_DEMRM_ID ,DP_ACCT_MSTR,DEMAT_REQUEST_DTLS        
                 WHERE  ISNULL(DEMRM_STATUS,'P')='P' AND DEMRM_DPAM_ID = DPAM_ID   AND DEMRM_ID= DEMRD_DEMRM_ID          
                 AND    DPAM_DPM_ID      = @L_DPM_ID          
                 AND    LTRIM(RTRIM(ISNULL(DEMRM_BATCH_NO,''))) = ''       
                 AND   ISNULL(DEMRM_INTERNAL_REJ,'') = ''       
                 AND    DEMRM_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                        AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
            
                 IF @L_TOT_REC > 0        
                 BEGIN         
            
                    /* UPDATE IN DEMAT_REQUEST_MSTR*/         
                    UPDATE D1 SET DEMRM_BATCH_NO=@PA_BATCH_NO FROM DEMAT_REQUEST_MSTR D1 ,DP_ACCT_MSTR D2        
                    WHERE  DEMRM_DPAM_ID = DPAM_ID         
                    AND    DPAM_DPM_ID   = @L_DPM_ID          
                    AND    ISNULL(DEMRM_STATUS,'P')='P'        
                    AND    LTRIM(RTRIM(ISNULL(DEMRM_BATCH_NO,''))) = ''      
                    AND   ISNULL(DEMRM_INTERNAL_REJ,'') = ''        
                    AND    DEMRM_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
                    AND    D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END        
                    /* UPDATE IN BITMAP REF MSTR*/         
                    UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
                    WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_'  + @L_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID        
            
                    /* INSERT INTO BATCH TABLE*/                          
                      IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE=@L_TRX_TAB)        
                       BEGIN        
                        INSERT INTO BATCHNO_CDSL_MSTR                                             
                        (          
                         BATCHC_DPM_ID,        
                         BATCHC_NO,        
                         BATCHC_RECORDS ,        
                         BATCHC_TRANS_TYPE,      
                         BATCHC_FILEGEN_DT,                 
                         BATCHC_TYPE,        
                         BATCHC_STATUS,        
                         BATCHC_CREATED_BY,        
                         BATCHC_CREATED_DT ,        
                         BATCHC_DELETED_IND        
                        )        
                        VALUES        
                        (        
       @L_DPM_ID,        
                         @PA_BATCH_NO,        
                         @L_TOT_REC,        
                         @L_TRX_TAB,      
                         CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  ,      
                         'T',        
                         'P',        
                         @PA_LOGINNAME,        
                         GETDATE(),        
                         1        
                        )            
                                                                 END        
                 END         
            
               END        
                                ELSE        
               BEGIN         
SELECT CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,''))        
+ CONVERT(CHAR(12),ISNULL(DEMRM_ISIN,''))        
+ CONVERT(CHAR(16),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(DEMRM_QTY)),13,3,'L','0'))         
+ CONVERT(CHAR(16),ISNULL(DEMRM_SLIP_SERIAL_NO,''))         
+ CONVERT(CHAR(20),CONVERT(VARCHAR(20),CASE WHEN ISNULL(DISP_DOC_ID,0) =0 THEN '' ELSE CONVERT(VARCHAR(20),DISP_DOC_ID) END))        
+ CONVERT(CHAR(30),ISNULL(DISP_NAME,''))        
+ CASE WHEN CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),ISNULL(DISP_DT,SPACE(8)),103),'/','')) = '01011900' THEN  CONVERT(CHAR(8),'00000000') ELSE CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),ISNULL(DISP_DT,SPACE(8)),103),'/','')) END     
+ CONVERT(CHAR(5),CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(5),ISNULL(DEMRM_TOTAL_CERTIFICATES,'0')),5,0,'L','0'))          
+ CONVERT(CHAR(1),ISNULL(DEMRM_FREE_LOCKEDIN_YN,''))        
+ CONVERT(CHAR(2),ISNULL(DEMRM_LOCKIN_REASON_CD,''))        
+ CONVERT(CHAR(50),CASE WHEN LTRIM(RTRIM(ISNULL(DEMRM_RMKS,'')))='' THEN SPACE(50) ELSE LTRIM(RTRIM(ISNULL(DEMRM_RMKS,''))) END )       
+ CASE WHEN CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),ISNULL(DEMRM_LOCKIN_RELEASE_DT,SPACE(8)),103),'/','')) = '01011900'  OR ISNULL(DEMRM_FREE_LOCKEDIN_YN,'N')='N' THEN  CONVERT(CHAR(8),'00000000') ELSE CONVERT(CHAR(8),REPLACE(CONVERT(VARCHAR(11),ISNULL(DEMRM_LOCKIN_RELEASE_DT,SPACE(8)),103),'/','')) END  DETAILS ,ABS(DEMRM_QTY) QTY      
FROM  DEMAT_REQUEST_MSTR        
LEFT OUTER JOIN DMAT_DISPATCH ON DEMRM_ID=DISP_DEMRM_ID      
,DP_ACCT_MSTR        
WHERE DEMRM_DPAM_ID     = DPAM_ID         
AND   DPAM_DELETED_IND  = 1        
AND   DEMRM_DELETED_IND = 1        
AND   ISNULL(DEMRM_STATUS,'P')='P'       
AND   ISNULL(DEMRM_INTERNAL_REJ,'') = ''       
AND   LTRIM(RTRIM(ISNULL(DEMRM_BATCH_NO,''))) = @PA_BATCH_NO        
AND   DEMRM_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'             
AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
END         
            
            
            --        
            END       
      
----PLEDGE      
      
      IF @L_TRX_TAB= 'PLEDGE'        
      BEGIN        
      --        
        IF @PA_BATCH_TYPE = 'BN'        
         BEGIN        
          SELECT CONVERT(CHAR(1),CASE WHEN PLDTC_TRASTM_CD IN('CRTE','CONF') THEN 'P'  WHEN PLDTC_TRASTM_CD IN('CLOS') THEN 'U' ELSE '' END )--'P','U','C','A'        
           + CONVERT(CHAR(1),CASE WHEN PLDTC_TRASTM_CD = 'CRTE' AND ISNULL(PLDTC_SUB_STATUS,'') = '' THEN 'S'      
                 WHEN PLDTC_TRASTM_CD = 'CONF' AND ISNULL(PLDTC_SUB_STATUS,'') = '' THEN 'A'      
                 WHEN PLDTC_TRASTM_CD = 'CLOS' AND ISNULL(PLDTC_SUB_STATUS,'') = '' THEN 'S'      
                 WHEN ISNULL(PLDTC_SUB_STATUS,'') <> '' THEN ISNULL(PLDTC_SUB_STATUS,'')       
                 ELSE '' END ) --'P' THEN 'S','A','R','C','E' --   'U' THEN 'S','A','R','C','E'--'A' THEN 'S','E'--'C' THEN 'S','E'      
           + CONVERT(CHAR(1),CASE WHEN PLDTC_TRASTM_CD = 'CRTE' AND ISNULL(PLDTC_SUB_STATUS,'') = '' THEN ISNULL(PLDTC_SECURITTIES,'') ELSE '' END)--'P''S' THEN 'F','L'         
           + CONVERT(CHAR(16),ISNULL(A.DPAM_SBA_NO,'')) --'P''S''L'         
           + CONVERT(CHAR(8),CASE WHEN PLDTC_TRASTM_CD = 'CRTE' AND ISNULL(PLDTC_SUB_STATUS,'') = '' THEN '00000000' ELSE ISNULL(PLDTC_PSN,'') END)  --'P''S' THEN '00000000' ELSE MEND PLDTC_PSN      
           + CONVERT(CHAR(16),ISNULL(A.DPAM_SBA_NO,''))        
           + CONVERT(CHAR(16),ISNULL(PLDTC_PLDG_CLIENTID,''))        
           + CONVERT(CHAR(12),ISNULL(PLDTC_ISIN,''))        
           + CONVERT(CHAR(16),CITRUS_USR.FN_FORMATSTR(ABS(PLDTC_QTY),13,3,'L','0'))--'P' OR ZEROS      
              + CONVERT(CHAR(15),CITRUS_USR.FN_FORMATSTR(ABS(PLDTC_QTY),13,3,'L','0'))--'P' OR ZEROS--PLEDGE VALUE?????????      
           + CONVERT(CHAR(8),CASE WHEN PLDTC_TRASTM_CD = 'CRTE' AND ISNULL(PLDTC_SUB_STATUS,'') = '' THEN REPLACE(CONVERT(VARCHAR(11),PLDTC_EXPIRY_DT,103),'/','') ELSE '00000000' END) --'P''S' ELSE ZEROS       
           + CONVERT(CHAR(16),CASE WHEN PLDTC_TRASTM_CD = 'CONF'  THEN PLDTC_ID ELSE '' END )  --'PLEDGEE DP INTERNAL REF NO'      
              + CONVERT(CHAR(16),CASE WHEN PLDTC_TRASTM_CD = 'CRTE'  THEN PLDTC_ID ELSE '' END ) --'PLEDGEE DP INTERNAL REF NO'        
           + CONVERT(CHAR(20),PLDTC_AGREEMENT_NO)  --'P''S'      
           + CONVERT(CHAR(4),'0000')       
           + CONVERT(CHAR(16),CITRUS_USR.FN_FORMATSTR(ABS(PLDTC_QTY),13,3,'L','0'))--UNPLEDGE / AUTO UNPLEDGE / CONFISCATE PART QUANTITY      
           + CONVERT(CHAR(100),PLDTC_RMKS)  DETAILS      
          ,CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(PLDTC_QTY)),13,3,'L','0') QTY      
          FROM  CDSL_PLEDGE_DTLS      
          ,DP_ACCT_MSTR  A      
          WHERE PLDTC_DPAM_ID = A.DPAM_ID         
          AND   A.DPAM_DELETED_IND  = 1        
          AND   PLDTC_DELETED_IND = 1        
          AND   ISNULL(PLDTC_STATUS,'P')='P'        
          AND   LTRIM(RTRIM(ISNULL(PLDTC_BATCH_NO,''))) = ''        
          AND   PLDTC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'             
          AND   DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
                 
            
          SELECT @L_TOT_REC = COUNT(PLDTC_ID) FROM CDSL_PLEDGE_DTLS ,DP_ACCT_MSTR        
          WHERE  ISNULL(PLDTC_STATUS,'P')='P' AND PLDTC_DPAM_ID = DPAM_ID         
          AND    DPAM_DPM_ID      = @L_DPM_ID          
          AND    LTRIM(RTRIM(ISNULL(PLDTC_BATCH_NO,''))) = ''        
          AND    PLDTC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
          AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
      
          IF @L_TOT_REC > 0                BEGIN         
          /* UPDATE IN DEMAT_REQUEST_MSTR*/         
          UPDATE D1 SET PLDTC_BATCH_NO=@PA_BATCH_NO FROM CDSL_PLEDGE_DTLS D1 ,DP_ACCT_MSTR D2        
          WHERE  PLDTC_DPAM_ID = DPAM_ID         
          AND    DPAM_DPM_ID   = @L_DPM_ID          
          AND    ISNULL(PLDTC_STATUS,'P')='P'        
          AND    LTRIM(RTRIM(ISNULL(PLDTC_BATCH_NO,''))) = ''        
          AND    PLDTC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
          AND    D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END        
      
          /* UPDATE IN BITMAP REF MSTR*/         
          UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
          WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_'  + @L_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID        
                  
              /* INSERT INTO BATCH TABLE*/                          
                IF NOT EXISTS(SELECT BATCHN_NO FROM BATCHNO_NSDL_MSTR   WHERE BATCHN_NO  = @PA_BATCH_NO AND BATCHN_DPM_ID = @L_DPM_ID AND BATCHN_DELETED_IND =1)        
                 BEGIN        
                  INSERT INTO BATCHNO_CDSL_MSTR                                             
                  (          
                   BATCHC_DPM_ID,        
                   BATCHC_NO,        
                   BATCHC_RECORDS ,        
                   BATCHC_TRANS_TYPE,      
                   BATCHC_FILEGEN_DT,                 
                   BATCHC_TYPE,        
                   BATCHC_STATUS,        
                   BATCHC_CREATED_BY,        
                   BATCHC_CREATED_DT ,        
                   BATCHC_DELETED_IND        
                  )        
                  VALUES        
                  (        
                   @L_DPM_ID,        
                   @PA_BATCH_NO,        
                   @L_TOT_REC,        
                   @PA_BATCH_TYPE,      
                   CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  ,      
                   'T',        
                   'P',        
                   @PA_LOGINNAME,        
                   GETDATE(),        
                   1        
                  )            
                                                           END        
           END         
      
         END        
                          ELSE        
         BEGIN         
          SELECT CONVERT(CHAR(1),CASE WHEN PLDTC_TRASTM_CD IN('CRTE','CONF') THEN 'P'  WHEN PLDTC_TRASTM_CD IN('CLOS') THEN 'U' ELSE '' END )--'P','U','C','A'        
           + CONVERT(CHAR(1),CASE WHEN PLDTC_TRASTM_CD = 'CRTE' AND ISNULL(PLDTC_SUB_STATUS,'') = '' THEN 'S'      
             WHEN PLDTC_TRASTM_CD = 'CONF' AND ISNULL(PLDTC_SUB_STATUS,'') = '' THEN 'A'      
             WHEN PLDTC_TRASTM_CD = 'CLOS' AND ISNULL(PLDTC_SUB_STATUS,'') = '' THEN 'S'      
             WHEN ISNULL(PLDTC_SUB_STATUS,'') <> '' THEN ISNULL(PLDTC_SUB_STATUS,'')       
             ELSE '' END ) --'P' THEN 'S','A','R','C','E' --   'U' THEN 'S','A','R','C','E'--'A' THEN 'S','E'--'C' THEN 'S','E'      
           + CONVERT(CHAR(1),CASE WHEN PLDTC_TRASTM_CD = 'CRTE' AND ISNULL(PLDTC_SUB_STATUS,'') = '' THEN ISNULL(PLDTC_SECURITTIES,'') ELSE '' END)--'P''S' THEN 'F','L'         
           + CONVERT(CHAR(16),ISNULL(A.DPAM_SBA_NO,'')) --'P''S''L'         
           + CONVERT(CHAR(8),CASE WHEN PLDTC_TRASTM_CD = 'CRTE' AND ISNULL(PLDTC_SUB_STATUS,'') = '' THEN '00000000' ELSE ISNULL(PLDTC_PSN,'') END)  --'P''S' THEN '00000000' ELSE MEND PLDTC_PSN      
           + CONVERT(CHAR(16),ISNULL(A.DPAM_SBA_NO,''))        
           + CONVERT(CHAR(16),ISNULL(PLDTC_PLDG_CLIENTID,''))        
           + CONVERT(CHAR(12),ISNULL(PLDTC_ISIN,''))        
           + CONVERT(CHAR(16),CITRUS_USR.FN_FORMATSTR(ABS(PLDTC_QTY),13,3,'L','0'))--'P' OR ZEROS      
           + CONVERT(CHAR(15),CITRUS_USR.FN_FORMATSTR(ABS(PLDTC_QTY),13,3,'L','0'))--'P' OR ZEROS--PLEDGE VALUE?????????      
           + CONVERT(CHAR(8),CASE WHEN PLDTC_TRASTM_CD = 'CRTE' AND ISNULL(PLDTC_SUB_STATUS,'') = '' THEN REPLACE(CONVERT(VARCHAR(11),PLDTC_EXPIRY_DT,103),'/','') ELSE '00000000' END) --'P''S' ELSE ZEROS       
           + CONVERT(CHAR(16),CASE WHEN PLDTC_TRASTM_CD = 'CONF'  THEN PLDTC_ID ELSE '' END )  --'PLEDGEE DP INTERNAL REF NO'      
              + CONVERT(CHAR(16),CASE WHEN PLDTC_TRASTM_CD = 'CRTE'  THEN PLDTC_ID ELSE '' END ) --'PLEDGEE DP INTERNAL REF NO'        
           + CONVERT(CHAR(20),PLDTC_AGREEMENT_NO)  --'P''S'      
           + CONVERT(CHAR(4),'0000') --'UNPLEDGE / AUTO UNPLEDGE / CONFISCATE PART COUNTER'       
           + CONVERT(CHAR(16),CITRUS_USR.FN_FORMATSTR(ABS(PLDTC_QTY),13,3,'L','0'))--UNPLEDGE / AUTO UNPLEDGE / CONFISCATE PART QUANTITY      
           + CONVERT(CHAR(100),PLDTC_RMKS)  DETAILS      
          ,CITRUS_USR.FN_FORMATSTR(CONVERT(VARCHAR(15),ABS(PLDTC_QTY)),13,3,'L','0') QTY      
          FROM  CDSL_PLEDGE_DTLS      
          ,DP_ACCT_MSTR  A      
          WHERE PLDTC_DPAM_ID = A.DPAM_ID         
          AND   A.DPAM_DELETED_IND  = 1        
          AND   PLDTC_DELETED_IND = 1        
          AND   ISNULL(PLDTC_STATUS,'P')='P'        
          AND   LTRIM(RTRIM(ISNULL(PLDTC_BATCH_NO,''))) = @PA_BATCH_NO      
          AND   PLDTC_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'             
          AND   DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
                 
         END         
      
      
      --        
      END        
---PLEDGE      
---FRZ      
      IF @L_TRX_TAB= 'FRZ'        
      BEGIN        
      --        
        IF @PA_BATCH_TYPE = 'BN'        
         BEGIN        
                
            SELECT   ISNULL(FRE_TRANS_TYPE,SPACE(1))       
            + CONVERT(CHAR(8),CITRUS_USR.FN_FORMATSTR(FRE_ID,8,0,'L','0'))      
            + ISNULL(FRE_LEVEL,SPACE(1))      
            + ISNULL(CONVERT(VARCHAR(1),FRE_INITIATED_BY),'0')      
            + ISNULL(CONVERT(VARCHAR(1),FRE_SUB_OPTION),'0')      
            + CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,''))      
            + CONVERT(CHAR(12),ISNULL(FRE_ISIN,''))      
            + CONVERT(CHAR(1),ISNULL(FRE_QTY_TYPE,''))      
            + CONVERT(CHAR(16),CITRUS_USR.FN_FORMATSTR(ABS(FRE_QTY),16,3,'L','0'))      
            + CONVERT(CHAR(1),ISNULL(FRE_FROZEN_FOR,''))      
            + ISNULL(CONVERT(VARCHAR(1),FRE_ACTIVATION_TYPE),'0')      
            + CASE WHEN FRE_ACTIVATION_TYPE = 1 THEN '00000000' ELSE REPLACE(CONVERT(VARCHAR(11),FRE_ACTIVATION_DT,102),'.','') END      
            + REPLACE(CONVERT(VARCHAR(11),FRE_EXPIRY_DT,102),'.','')      
            + RIGHT('0' +ISNULL(CONVERT(CHAR(2),FRE_REASON_CD),'00'),2)      
            + CONVERT(CHAR(16),ISNULL(FRE_INT_REF_NO,''))      
            + CONVERT(CHAR(100),ISNULL(FRE_RMKS,'')) DETAILS      
            ,ABS(FRE_QTY) QTY      
            FROM FREEZE_UNFREEZE_DTLS_CDSL D1       
                  , DP_ACCT_MSTR D2         
            WHERE D1.FRE_DPAM_ID = CONVERT(VARCHAR,D2.DPAM_ID) AND DPAM_DPM_ID = @L_DPM_ID         
            AND D1.FRE_ACTIVATION_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'                                  
            AND LTRIM(RTRIM(ISNULL(D1.FRE_BATCH_NO,'0'))) = '0'       
            AND D1.FRE_TRANS_TYPE='S'      
            AND ISNULL(D1.FRE_UPLOAD_STATUS,'P')='P'      
            AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
            AND D1.FRE_DELETED_IND = 1         
                  
            
          SELECT @L_TOT_REC = COUNT(FRE_ID) FROM FREEZE_UNFREEZE_DTLS_CDSL ,DP_ACCT_MSTR        
          WHERE  ISNULL(FRE_UPLOAD_STATUS,'P')='P' AND FRE_DPAM_ID = CONVERT(VARCHAR,DPAM_ID)         
          AND    DPAM_DPM_ID      = @L_DPM_ID          
          AND    LTRIM(RTRIM(ISNULL(FRE_BATCH_NO,'0'))) = '0'        
          AND    FRE_ACTIVATION_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
          AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
      
          IF @L_TOT_REC > 0        
         BEGIN         
          /*UPDATE IN DEMAT_REQUEST_MSTR*/         
          UPDATE D1 SET FRE_BATCH_NO=@PA_BATCH_NO FROM FREEZE_UNFREEZE_DTLS_CDSL D1 ,DP_ACCT_MSTR D2        
          WHERE  FRE_DPAM_ID = CONVERT(VARCHAR,DPAM_ID)        
          AND    DPAM_DPM_ID   = @L_DPM_ID          
          AND    ISNULL(FRE_STATUS,'P')='P'        
          AND    LTRIM(RTRIM(ISNULL(FRE_BATCH_NO,'0'))) = '0'        
          AND    FRE_ACTIVATION_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
          AND    D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END        
      
          /* UPDATE IN BITMAP REF MSTR*/         
          UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
          WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_'  + @L_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID        
                  
              /* INSERT INTO BATCH TABLE*/                          
                IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1)        
                 BEGIN        
                  INSERT INTO BATCHNO_CDSL_MSTR                                             
                  (          
                   BATCHC_DPM_ID,        
                   BATCHC_NO,        
                   BATCHC_RECORDS ,        
                   BATCHC_TRANS_TYPE,      
                   BATCHC_FILEGEN_DT,                 
                   BATCHC_TYPE,        
                   BATCHC_STATUS,        
                   BATCHC_CREATED_BY,        
                   BATCHC_CREATED_DT ,        
                   BATCHC_DELETED_IND        
                  )        
                  VALUES        
                  (        
                   @L_DPM_ID,        
                   @PA_BATCH_NO,        
                   @L_TOT_REC,        
                   @PA_BATCH_TYPE,      
                   CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  ,      
                   'T',        
                   'P',        
                   @PA_LOGINNAME,        
                   GETDATE(),        
                   1        
                  )            
                                                           END        
           END         
      
         END        
                          ELSE        
         BEGIN         
            SELECT   ISNULL(FRE_TRANS_TYPE,SPACE(1))       
            + CONVERT(CHAR(8),CITRUS_USR.FN_FORMATSTR(FRE_ID,8,0,'L','0'))      
            + ISNULL(FRE_LEVEL,SPACE(1))      
            + ISNULL(CONVERT(VARCHAR(1),FRE_INITIATED_BY),'0')      
            + ISNULL(CONVERT(VARCHAR(1),FRE_SUB_OPTION),'0')      
            + CONVERT(CHAR(16),ISNULL(DPAM_SBA_NO,''))      
            + CONVERT(CHAR(12),ISNULL(FRE_ISIN,''))      
            + CONVERT(CHAR(1),ISNULL(FRE_QTY_TYPE,''))      
            + CONVERT(CHAR(16),CITRUS_USR.FN_FORMATSTR(ABS(FRE_QTY),16,3,'L','0'))      
            + CONVERT(CHAR(1),ISNULL(FRE_FROZEN_FOR,''))      
            + ISNULL(CONVERT(VARCHAR(1),FRE_ACTIVATION_TYPE),'0')      
            + CASE WHEN FRE_ACTIVATION_TYPE = 1 THEN '00000000' ELSE REPLACE(CONVERT(VARCHAR(11),FRE_ACTIVATION_DT,102),'.','') END      
            + REPLACE(CONVERT(VARCHAR(11),FRE_EXPIRY_DT,102),'.','')      
            + RIGHT('0' +ISNULL(CONVERT(CHAR(2),FRE_REASON_CD),'00'),2)      
            + CONVERT(CHAR(16),ISNULL(FRE_INT_REF_NO,''))      
            + CONVERT(CHAR(100),ISNULL(FRE_RMKS,'')) DETAILS      
            ,ABS(FRE_QTY) QTY      
            FROM FREEZE_UNFREEZE_DTLS_CDSL D1       
                  , DP_ACCT_MSTR D2         
            WHERE D1.FRE_DPAM_ID = CONVERT(VARCHAR,D2.DPAM_ID) AND DPAM_DPM_ID = @L_DPM_ID         
            AND D1.FRE_ACTIVATION_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'                                 
            AND LTRIM(RTRIM(ISNULL(D1.FRE_BATCH_NO,'0'))) = '0'       
                                                AND D1.FRE_TRANS_TYPE='S'      
                                                AND ISNULL(D1.FRE_UPLOAD_STATUS,'P')='P'      
            AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
            AND D1.FRE_DELETED_IND = 1        
      
         END         
      
      
      --        
      END        
---FRZ      
      
--UNFRZ      
      IF @L_TRX_TAB= 'UNFRZ'        
      BEGIN        
      --        
        IF @PA_BATCH_TYPE = 'BN'        
         BEGIN        
                
            SELECT ISNULL(D2.FRE_TRANS_TYPE,SPACE(1))       
             + CONVERT(CHAR(8),CITRUS_USR.FN_FORMATSTR(D2.FRE_ID,8,0,'L','0'))      
             +' 00                             0000000000000000 0                00                '      
             + CONVERT(CHAR(100),ISNULL(D2.FRE_RMKS,'')) DETAILS      
             ,ABS(D1.FRE_QTY) QTY      
            FROM FREEZE_UNFREEZE_DTLS_CDSL D1      
             ,FREEZE_UNFREEZE_DTLS_CDSL D2      
             ,DP_ACCT_MSTR D3      
            WHERE D1.FRE_ID = D2.FRE_ID      
             AND D1.FRE_DPAM_ID = D3.DPAM_ID      
             AND D2.FRE_TRANS_TYPE ='U'      
             AND D1.FRE_STATUS ='I'      
             AND D2.FRE_STATUS ='A'      
            AND D2.FRE_LST_UPD_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'                                  
            AND LTRIM(RTRIM(ISNULL(D1.FRE_BATCH_NO,'0'))) = '0'       
            AND ISNULL(D1.FRE_UPLOAD_STATUS,'P')='P'      
            AND D3.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
            AND D2.FRE_DELETED_IND = 1      
            AND D1.FRE_DELETED_IND = 1      
            AND D3.DPAM_DELETED_IND = 1       
            
          SELECT @L_TOT_REC = COUNT(FRE_ID) FROM FREEZE_UNFREEZE_DTLS_CDSL ,DP_ACCT_MSTR        
          WHERE  ISNULL(FRE_UPLOAD_STATUS,'P')='P' AND FRE_DPAM_ID = CONVERT(VARCHAR,DPAM_ID)         
          AND    DPAM_DPM_ID      = @L_DPM_ID          
          AND    LTRIM(RTRIM(ISNULL(FRE_BATCH_NO,'0'))) = '0'        
          AND    FRE_CREATED_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
          AND    DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END      
      
          IF @L_TOT_REC > 0        
          BEGIN         
          /* UPDATE IN DEMAT_REQUEST_MSTR*/         
          UPDATE D1 SET FRE_BATCH_NO=@PA_BATCH_NO FROM FREEZE_UNFREEZE_DTLS_CDSL D1 ,DP_ACCT_MSTR D2        
          WHERE  FRE_DPAM_ID = CONVERT(VARCHAR,DPAM_ID)         
          AND    DPAM_DPM_ID   = @L_DPM_ID          
          AND    ISNULL(FRE_STATUS,'P')='P'        
          AND    LTRIM(RTRIM(ISNULL(FRE_BATCH_NO,'0'))) = '0'        
          AND    FRE_CREATED_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
          AND    D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END        
      
          /* UPDATE IN BITMAP REF MSTR*/         
          UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
          WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_'  + @L_TRX_TAB + '_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID     
                  
              /* INSERT INTO BATCH TABLE*/                          
IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1)        
                 BEGIN        
                  INSERT INTO BATCHNO_CDSL_MSTR                                             
                  (          
                   BATCHC_DPM_ID,        
                   BATCHC_NO,        
                   BATCHC_RECORDS ,        
                   BATCHC_TRANS_TYPE,      
                   BATCHC_FILEGEN_DT,                 
                   BATCHC_TYPE,        
                   BATCHC_STATUS,        
                   BATCHC_CREATED_BY,        
                   BATCHC_CREATED_DT ,        
                   BATCHC_DELETED_IND        
                  )        
                  VALUES        
                  (        
                   @L_DPM_ID,        
                   @PA_BATCH_NO,        
                   @L_TOT_REC,        
                   @PA_BATCH_TYPE,      
                   CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  ,      
                   'T',        
                   'P',        
                   @PA_LOGINNAME,        
                   GETDATE(),        
                   1        
                  )            
  END        
    END         
		END        
 ELSE        
         BEGIN         

         SELECT ISNULL(D2.FRE_TRANS_TYPE,SPACE(1))       
           + CONVERT(CHAR(8),CITRUS_USR.FN_FORMATSTR(D2.FRE_ID,8,0,'L','0'))      
           +' 00                             0000000000000000 0                00                '      
           + CONVERT(CHAR(100),ISNULL(D2.FRE_RMKS,'')) DETAILS      
           ,ABS(D1.FRE_QTY) QTY      
         FROM FREEZE_UNFREEZE_DTLS_CDSL D1      
          ,FREEZE_UNFREEZE_DTLS_CDSL D2      
          ,DP_ACCT_MSTR D3      
         WHERE D1.FRE_ID = D2.FRE_ID      
          AND D1.FRE_DPAM_ID = D3.DPAM_ID      
          AND D2.FRE_TRANS_TYPE ='U'      
          AND D1.FRE_STATUS ='I'      
          AND D2.FRE_STATUS ='A'      
         AND D2.FRE_LST_UPD_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'                                  
         AND LTRIM(RTRIM(ISNULL(D1.FRE_BATCH_NO,'0'))) = '0'       
         AND ISNULL(D1.FRE_UPLOAD_STATUS,'P')='P'      
         AND D3.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END       
         AND D2.FRE_DELETED_IND = 1      
         AND D1.FRE_DELETED_IND = 1      
         AND D3.DPAM_DELETED_IND = 1      
      
         END         
      
      
      --        
      END        
        
--        IF @L_TRX_TAB= 'CLSR_ACCT_GEN1'         
--        BEGIN     
--			 SELECT * FROM CLOSURE_ACCT_CDSL WHERE  CLSR_DATE BETWEEN         
--			 CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT ,103),106)+' 00:00:00'    
--			 AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'           
--			 AND CLSR_DELETED_IND=1        
--        END         
  
    --      
    END      
  --        
  END        
  --        
  END        
  --
IF @L_TRX_TAB= 'CLSR_ACCT_GEN'         
      BEGIN 



SELECT CONVERT(VARCHAR(16),ISNULL(CLSR_BO_ID,''))AS CLSR_BO_ID ,
		CONVERT(VARCHAR(1),ISNULL(CLSR_TRX_TYPE,''))AS CLSR_TRX_TYPE,
		CONVERT(VARCHAR(2),ISNULL(CLSR_INI_BY,''))AS CLSR_INI_BY ,
		CONVERT(VARCHAR(2),ISNULL(CLSR_REASON_CD,'')) AS CLSR_REASON_CD ,
		CONVERT(VARCHAR(1),ISNULL(CLSR_REMAINING_BAL,''))AS CLSR_REMAINING_BAL ,
		CONVERT(VARCHAR(16),ISNULL(CLSR_NEW_BO_ID,''))AS CLSR_NEW_BO_ID ,
		CONVERT(VARCHAR(100),ISNULL(CLSR_RMKS,'')) AS CLSR_RMKS,
		CONVERT(VARCHAR(16),ISNULL(CLSR_ID,'')) AS CLSR_REQ_INT_REFNO  
		FROM CLOSURE_ACCT_CDSL WHERE  CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT   AND @PA_TO_DT      
   
         

SELECT @L_TOT_REC = COUNT(CLSR_ID) FROM CLOSURE_ACCT_CDSL      
		WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       




--	SELECT @L_TOT_REC = COUNT(CLSR_ID) FROM CLOSURE_ACCT_CDSL      
--	   WHERE  CLSR_DATE BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)  AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)        
--				 

PRINT(@L_TOT_REC)
	IF @L_TOT_REC > 0 
	BEGIN         
          /* UPDATE IN BITMAP_REF_MSTR TABLE */         
          
				UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
						  WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_CLOSURE_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID 
 
UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO = @PA_BATCH_NO 
		   WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
 			



--UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO = @PA_BATCH_NO WHERE CLSR_DATE BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'        
 		 
         

 /* INSERT INTO BATCHNO_CDSL_MSTR */                          
				IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1)        
                 BEGIN        
                  INSERT INTO BATCHNO_CDSL_MSTR                                             
                  (          
                   BATCHC_DPM_ID,        
                   BATCHC_NO,        
                   BATCHC_RECORDS,        
                   BATCHC_TRANS_TYPE,      
                   BATCHC_FILEGEN_DT,                 
                   BATCHC_TYPE,        
                   BATCHC_STATUS,        
                   BATCHC_CREATED_BY,        
                   BATCHC_CREATED_DT ,        
                   BATCHC_DELETED_IND        
                  )        
                  VALUES        
                  (        
                   @L_DPM_ID,        
                   @PA_BATCH_NO,        
                   CONVERT(NUMERIC,@L_TOT_REC),       
                   'ACCOUNT CLOSURE',      
                   CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+'00:00:00',      
                   'T',        
                   'P',        
                   @PA_LOGINNAME,        
                   GETDATE(),        
                   1        
                  ) 
 
        
			END                 
			END
			END 
			END
       
 
--

GO
