-- Object: PROCEDURE dbo.V2_COMBINED_CONTRACTNOTE_DETAIL_newyogeshmar122015
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


          
CREATE PROCEDURE [dbo].[V2_COMBINED_CONTRACTNOTE_DETAIL]             
 (            
 @STATUSID VARCHAR(15),            
 @STATUSNAME VARCHAR(25),            
 @FROMDATE VARCHAR(11),            
 @TODATE VARCHAR(11),            
 @FROMPARTY VARCHAR(10),            
 @TOPARTY VARCHAR(10),            
 @FROMBRANCH VARCHAR(10),            
 @TOBRANCH VARCHAR(10),            
 @FROMSUB_BROKER VARCHAR(10),            
 @TOSUB_BROKER VARCHAR(10),            
 @FROMCONTRACT VARCHAR(10),            
 @TOCONTRACT VARCHAR(10),            
 @CONTFLAG VARCHAR(10),            
 @EXCHANGE VARCHAR(15),            
 @BOUNCEDFLAG INT = 0,            
 @PRINTFLAG VARCHAR(6),            
 --@SETT_TYPE VARCHAR(2) = '',            
 @COMPANY_NAME VARCHAR(100) = ''         
-- @PRINTF         VARCHAR(6) = 'ALL'                  
 )            
 AS       
       
--EXEC V2_COMBINED_CONTRACTNOTE_DETAIL 'broker','broker','Jul 25 2014','Jul 25 2014','s127282','s127282',      
--'','zzzzzzzzzzz','','zzzzzzzzzzz','','99999999','CONTRACT','ALL',0,'',      
--'Angel Broking Pvt Ltd.(Erstwhile Angel Broking Ltd.)','ALL'       
        
             
            
 /*            
 EXEC [V2_COMBINED_CONTRACTNOTE_NEW] 'BROKER','BROKER','JUL 10 2012','JUL 10 2012','','ZZZZZZ','','ZZZZZZZZ','','ZZZZZZ','','99999999','','',0,''            
 EXEC [V2_COMBINED_CONTRACTNOTE_DETAIL] 'BROKER','BROKER','JUL 10 2012','JUL 10 2012','','ZZZZZZ','','ZZZZZZZZ','','ZZZZZZ','','99999999','','',0,''            
 */          
        
         
--IF ISNULL(@PRINTF,'') = ''                                       
--SELECT @PRINTF = 'ALL'                                      
           
            
 IF @TODATE = ''            
 BEGIN            
  SET @TODATE = @FROMDATE            
 END            
            
 IF @TOPARTY = ''            
 BEGIN            
  SET @TOPARTY = 'ZZZZZZZZZZ'            
 END        
       
 IF @FROMBRANCH =  'ALL'      
 BEGIN            
  SET @FROMBRANCH = '00000'            
 END        
       
  IF @TOBRANCH = 'ALL'      
 BEGIN            
  SET @TOBRANCH = 'ZZZZZZZZZZ'            
 END         
            
 IF @TOBRANCH = ''       
 BEGIN            
  SET @TOBRANCH = 'ZZZZZZZZZZ'            
 END            
            
 IF @TOSUB_BROKER = ''            
 BEGIN            
  SET @TOSUB_BROKER = 'ZZZZZZZZZZ'            
 END            
            
 IF @TOCONTRACT = ''            
 BEGIN            
  SET @TOCONTRACT = '9999999999'            
 END            
            
 DECLARE @COLNAME VARCHAR(6)            
 SET @COLNAME = ''            
            
 IF @CONTFLAG = 'CONTRACT'            
 BEGIN            
  SELECT @COLNAME = RPT_CODE            
  FROM V2_CONTRACTPRINT_SETTING_COMBINED            
  WHERE RPT_TYPE = 'ORDER' AND RPT_PRINTFLAG = 1            
 END            
 ELSE            
 BEGIN            
  SELECT @COLNAME = RPT_CODE            
  FROM V2_CONTRACTPRINT_SETTING_COMBINED            
  WHERE RPT_TYPE = 'ORDER' AND RPT_PRINTFLAG_DIGI = 1            
 END            
            
 CREATE TABLE #PARTY            
 (            
  PARTYCODE VARCHAR(15)            
 )             
            
 IF @BOUNCEDFLAG = 0            
 BEGIN            
  INSERT INTO #PARTY            
  SELECT DISTINCT PARTY_CODE FROM COMMON_CONTRACT_DATA WITH (NOLOCK)             
  WHERE SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59' AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY            
 END            
 ELSE            
 BEGIN            
  INSERT INTO #PARTY            
  SELECT DISTINCT PARTY_CODE FROM TBL_ECNBOUNCED WITH (NOLOCK) WHERE SDate BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'            
 END          
         
       
        
            
 SELECT            
  ORDERBYFLAG = (            
  CASE            
   WHEN @COLNAME = 'ORD_N'  THEN PARTYNAME            
   WHEN @COLNAME = 'ORD_P'  THEN PARTY_CODE            
   WHEN @COLNAME = 'ORD_BP' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(PARTY_CODE))            
   WHEN @COLNAME = 'ORD_BN' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(PARTYNAME))            
   WHEN @COLNAME = 'ORD_DP' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(PARTY_CODE))            
   WHEN @COLNAME = 'ORD_DN' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(PARTYNAME))            
   ELSE RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(PARTY_CODE))            
  END),              
  CONTRACTNO,            
  CONTRACTNO_NEW,            
  SAUDA_DATE=CONVERT(VARCHAR,CONVERT(DATETIME,SAUDA_DATE,109),103),            
  SETT_NO,            
  SETT_TYPE,            
  SETT_DATE,            
  PARTY_CODE,            
  PARTYNAME,            
  L_ADDRESS1,            
  L_ADDRESS2,            
  L_ADDRESS3,            
  L_STATE,            
  L_CITY,            
  L_ZIP,            
  OFF_PHONE1,            
  OFF_PHONE2,            
  PAN_GIR_NO,            
  EXCHANGE,            
  SEGMENT,            
  ORDER_NO,            
  ORDER_TIME,            
  TRADE_NO,            
  TRADE_TIME,            
  SCRIPNAME,            
  QTY,            
  TMARK,            
  SELL_BUY = (CASE WHEN SELL_BUY = 1 THEN 'BUY' ELSE 'SELL' END),            
  MARKETRATE,            
  MARKETAMT,            
  BROKERAGE,            
  SERVICE_TAX,            
  INS_CHRG,            
  NETAMOUNT,            
  SEBI_TAX,            
  TURN_TAX,            
  BROKER_CHRG,            
  OTHER_CHRG,            
  NETAMOUNTALL,            
  PRINTF=C.PRINTF,            
  BROK,            
  NETRATE,            
  CL_RATE,            
  UCC_CODE,            
  BROKERSEBIREGNO,            
  MEMBERCODE,            
  CINNO,            
  BRANCH_CD,            
  SUB_BROKER,            
  TRADER,            
  AREA,            
  REGION,            
  FAMILY,             
  MAPIDID,            
  SEBI_NO,            
  PARTICIPANT_CODE,
  USER_ID,            
  CL_TYPE,            
  SERVICE_CHRG,            
  SETTTYPE_DESC,            
  BFCF_FLAG,            
  CONTRACT_HEADER_DET,            
  REMARK=REMARK_ID,            
COMPANYNAME,            
  REMARK_ID,            
  REMARK_DESC,            
  NETOBLIGATION,             
  SETTLEMENT_DET = CONVERT(VARCHAR(600),''),            
  CONTRACTNO_DET = CONVERT(VARCHAR(600),''),            
  BROKERSEBIREGNO_DET = CONVERT(VARCHAR(600),''),            
  MEMBERCODE_DET = CONVERT(VARCHAR(600),''),            
  CIN_DET   = CONVERT(VARCHAR(600),''),            
  NETAMOUNTEX  = CONVERT(NUMERIC(20, 6),0),            
  SEBI_TAXEX  = CONVERT(NUMERIC(18, 4),0),            
  TURN_TAXEX  = CONVERT(NUMERIC(18, 4),0),            
  BROKER_CHRGEX = CONVERT(NUMERIC(18, 4),0),            
  OTHER_CHRGEX = CONVERT(NUMERIC(18, 4),0),            
  INS_CHRGEX  = CONVERT(NUMERIC(18, 4),0),            
  SERVICE_TAXEX = CONVERT(NUMERIC(18, 4),0),            
  SCRIPNAME_NEW = CONVERT(VARCHAR(300),''),            
  REMARK_DET  = CONVERT(VARCHAR(300),'')            
 INTO            
  #CONTRACT              
 FROM             
  COMMON_CONTRACT_DATA C (NOLOCK),            
 -- CLIENT_PRINT_SETTINGS  CP (NOLOCK),                 
  #PARTY P,        
  MSAJAG.DBO.FUN_PRINTF(@PRINTFLAG) CP            
 WHERE            
  SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'            
  AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY            
  AND CONTRACTNO BETWEEN @FROMCONTRACT AND @TOCONTRACT            
AND C.COMPANYNAME = (CASE WHEN @COMPANY_NAME <> '' THEN @COMPANY_NAME ELSE C.COMPANYNAME END)            
 AND BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH                      
  AND SUB_BROKER BETWEEN @FROMSUB_BROKER AND @TOSUB_BROKER            
  AND @STATUSNAME = (            
  CASE            
   WHEN @STATUSID = 'BRANCH'  THEN BRANCH_CD                      
   WHEN @STATUSID = 'SUBBROKER' THEN SUB_BROKER                      
   WHEN @STATUSID = 'TRADER'  THEN TRADER                      
   WHEN @STATUSID = 'FAMILY'  THEN FAMILY                      
   WHEN @STATUSID = 'AREA'   THEN AREA                      
   WHEN @STATUSID = 'REGION'  THEN REGION                      
   WHEN @STATUSID = 'CLIENT'  THEN PARTY_CODE                      
   ELSE 'BROKER'                      
  END)          
  AND C.PARTY_CODE = P.PARTYCODE                
  AND C.PRINTF =  CP.PRINTF        
                           
 --AND CP.VALID_REPORT LIKE (CASE WHEN @BOUNCEDFLAG = 0 THEN '%' + @CONTFLAG + '%' ELSE CP.VALID_REPORT END)            
           
       
            
            
 CREATE CLUSTERED INDEX [IDXCONT]                   
         ON [DBO].[#CONTRACT]               
         (                   
   [PARTY_CODE],                
   [EXCHANGE],            
   [SEGMENT],            
   [SCRIPNAME]            
         )                
            
            
 /*            
 SELECT DISTINCT PARTY_CODE,            
  SAUDA_DATE,            
  SETTLEMENT_DET = STUFF((            
    SELECT DISTINCT EXCHANGE + '-' + SEGMENT + '-' + LTRIM(RTRIM(SETT_NO)) + '-' + LTRIM(RTRIM(SETTTYPE_DESC)) + '-' + Sett_Date + '-' + LTRIM(RTRIM(CONTRACTNO)) + '#'            
    FROM #CONTRACT C            
   WHERE B.PARTY_CODE = C.PARTY_CODE            
     AND B.SAUDA_DATE = C.SAUDA_DATE            
     AND C.SEGMENT = 'CAPITAL'            
     AND C.CONTRACTNO <> 0            
    ORDER BY 1            
    FOR XML PATH('')            
    ), 1, 0, ''),            
  CONTRACTNO_DET = STUFF((            
    SELECT DISTINCT EXCHANGE + '-' + SEGMENT + '-' + LTRIM(RTRIM(CONTRACTNO)) + '#'            
    FROM #CONTRACT C            
    WHERE B.PARTY_CODE = C.PARTY_CODE            
     AND B.SAUDA_DATE = C.SAUDA_DATE            
     AND C.CONTRACTNO <> 0            
    ORDER BY 1            
    FOR XML PATH('')            
    ), 1, 0, ''),            
  BROKERSEBIREGNO_DET = STUFF((            
    SELECT DISTINCT EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(BROKERSEBIREGNO)) + '#'            
    FROM #CONTRACT C            
    WHERE B.PARTY_CODE = C.PARTY_CODE            
     AND B.SAUDA_DATE = C.SAUDA_DATE            
    ORDER BY 1            
    FOR XML PATH('')            
    ), 1, 0, ''),            
  MEMBERCODE_DET = STUFF((            
    SELECT DISTINCT EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(MEMBERCODE)) + '#'            
    FROM #CONTRACT C            
    WHERE B.PARTY_CODE = C.PARTY_CODE            
     AND B.SAUDA_DATE = C.SAUDA_DATE            
    ORDER BY 1            
    FOR XML PATH('')            
    ), 1, 0, ''),            
  CIN_DET=STUFF((            
    SELECT DISTINCT EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(CINNO)) + '#'            
    FROM #CONTRACT C            
    WHERE B.PARTY_CODE = C.PARTY_CODE            
     AND B.SAUDA_DATE = C.SAUDA_DATE            
    ORDER BY 1            
    FOR XML PATH('')            
    ), 1, 0, '')              
 INTO #CONTSETT_DET            
 FROM #CONTRACT B            
 */            
            
            
 DECLARE @PARTY_CODE VARCHAR(20)            
 DECLARE @DESC varchar(MAX)            
 DECLARE @SAUDA_DATE VARCHAR(20)            
              
 SELECT DISTINCT PARTY_CODE,SAUDA_DATE,             
 SETTLEMENT_DET=EXCHANGE + '-' + SEGMENT + '-' + LTRIM(RTRIM(SETT_NO)) + '-' + LTRIM(RTRIM(SETTTYPE_DESC)) + '-' + SETT_DATE + '-' + LTRIM(RTRIM(CONTRACTNO)) + '#'            
 INTO #SETTLEMENT_DET            
 FROM #CONTRACT            
 WHERE SEGMENT = 'CAPITAL'            
 AND CONTRACTNO <> 0            
 ORDER BY PARTY_CODE            
            
 ALTER TABLE #SETTLEMENT_DET            
 ALTER COLUMN SETTLEMENT_DET VARCHAR(MAX)            
            
 SET @DESC = ''            
 SET @PARTY_CODE = ''            
 SET @SAUDA_DATE = ''            
            
 UPDATE #SETTLEMENT_DET            
 SET @DESC = SETTLEMENT_DET = CASE            
    WHEN @PARTY_CODE = PARTY_CODE AND @SAUDA_DATE = SAUDA_DATE             
    THEN @DESC + '' + SETTLEMENT_DET            
    ELSE SETTLEMENT_DET END,            
 @PARTY_CODE = PARTY_CODE,            
 @SAUDA_DATE = SAUDA_DATE            
            
 SELECT DISTINCT PARTY_CODE,SAUDA_DATE,            
 CONTRACTNO_DET=EXCHANGE + '-' + SEGMENT + '-' + LTRIM(RTRIM(CONTRACTNO)) + '#'            
 INTO #CONTRACTNO_DET            
 FROM #CONTRACT C            
 WHERE CONTRACTNO <> 0            
 ORDER BY PARTY_CODE            
            
 ALTER TABLE #CONTRACTNO_DET            
 ALTER COLUMN CONTRACTNO_DET VARCHAR(MAX)            
            
 SET @DESC = ''            
 SET @PARTY_CODE = ''            
 SET @SAUDA_DATE = ''            
            
 UPDATE #CONTRACTNO_DET            
 SET @DESC = CONTRACTNO_DET = CASE            
    WHEN @PARTY_CODE = PARTY_CODE AND @SAUDA_DATE = SAUDA_DATE             
    THEN @DESC + '' + CONTRACTNO_DET            
    ELSE CONTRACTNO_DET END,            
 @PARTY_CODE = PARTY_CODE,            
 @SAUDA_DATE = SAUDA_DATE     
            
 SELECT DISTINCT PARTY_CODE,SAUDA_DATE,            
 BROKERSEBIREGNO_DET=EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(BROKERSEBIREGNO)) + '#'            
 INTO #BROKERSEBIREGNO_DET            
 FROM #CONTRACT C            
 WHERE CONTRACTNO <> 0            
 ORDER BY PARTY_CODE            
                
 ALTER TABLE #BROKERSEBIREGNO_DET            
 ALTER COLUMN BROKERSEBIREGNO_DET VARCHAR(MAX)            
            
 SET @DESC = ''            
 SET @PARTY_CODE = ''            
 SET @SAUDA_DATE = ''            
            
 UPDATE #BROKERSEBIREGNO_DET            
 SET @DESC = BROKERSEBIREGNO_DET = CASE            
    WHEN @PARTY_CODE = PARTY_CODE AND @SAUDA_DATE = SAUDA_DATE            
    THEN @DESC + '' + BROKERSEBIREGNO_DET            
    ELSE BROKERSEBIREGNO_DET END,            
 @PARTY_CODE = PARTY_CODE,            
 @SAUDA_DATE = SAUDA_DATE            
            
 SELECT DISTINCT PARTY_CODE,SAUDA_DATE,            
 MEMBERCODE_DET = EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(MEMBERCODE)) + '#'            
 INTO #MEMBERCODE_DET            
 FROM #CONTRACT C            
 WHERE CONTRACTNO <> 0            
 ORDER BY PARTY_CODE            
                
 ALTER TABLE #MEMBERCODE_DET            
 ALTER COLUMN MEMBERCODE_DET VARCHAR(MAX)            
            
 SET @DESC = ''            
 SET @PARTY_CODE = ''            
 SET @SAUDA_DATE = ''            
            
 UPDATE #MEMBERCODE_DET            
 SET @DESC = MEMBERCODE_DET = CASE            
    WHEN @PARTY_CODE = PARTY_CODE AND @SAUDA_DATE = SAUDA_DATE            
    THEN @DESC + '' + MEMBERCODE_DET            
    ELSE MEMBERCODE_DET END,            
 @PARTY_CODE = PARTY_CODE,            
 @SAUDA_DATE = SAUDA_DATE            
            
 SELECT DISTINCT  PARTY_CODE,SAUDA_DATE,            
 CIN_DET=EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(CINNO)) + '#'            
 INTO #CIN_DET            
 FROM #CONTRACT            
 WHERE CONTRACTNO <> 0            
 ORDER BY PARTY_CODE            
                
 ALTER TABLE #CIN_DET            
 ALTER COLUMN CIN_DET VARCHAR(MAX)            
            
 SET @DESC = ''            
 SET @PARTY_CODE = ''            
 SET @SAUDA_DATE = ''            
            
 UPDATE #CIN_DET            
 SET @DESC = CIN_DET = CASE            
    WHEN @PARTY_CODE = PARTY_CODE AND @SAUDA_DATE = SAUDA_DATE            
    THEN @DESC + '' + CIN_DET            
    ELSE CIN_DET END,            
 @PARTY_CODE = PARTY_CODE,            
 @SAUDA_DATE = SAUDA_DATE            
            
            
 SELECT DISTINCT  PARTY_CODE,SAUDA_DATE,            
 REMARK_DET = '('+REMARK_ID+')'+':-'+ REMARK_DESC + '#'            
 INTO #REMARK_DET            
 FROM #CONTRACT            
 WHERE REMARK_ID <> ''            
 ORDER BY PARTY_CODE            
                
 ALTER TABLE #REMARK_DET            
 ALTER COLUMN REMARK_DET VARCHAR(MAX)            
            
 SET @DESC = ''            
 SET @PARTY_CODE = ''            
 SET @SAUDA_DATE = ''            
            
 UPDATE #REMARK_DET            
 SET @DESC = REMARK_DET = CASE            
    WHEN @PARTY_CODE = PARTY_CODE AND @SAUDA_DATE = SAUDA_DATE            
    THEN @DESC + ' ' + REMARK_DET            
    ELSE REMARK_DET END,            
 @PARTY_CODE = PARTY_CODE,            
 @SAUDA_DATE = SAUDA_DATE            
            
            
 SELECT A1.PARTY_CODE,A1.SAUDA_DATE,SETTLEMENT_DET,CONTRACTNO_DET,BROKERSEBIREGNO_DET,MEMBERCODE_DET,CIN_DET,REMARK_DET            
 INTO #CONTSETT_DET            
 FROM            
 (            
  SELECT DISTINCT PARTY_CODE,SAUDA_DATE FROM #CONTRACT            
 ) A1            
 LEFT OUTER JOIN            
 (            
  SELECT PARTY_CODE,SAUDA_DATE,SETTLEMENT_DET=MAX(SETTLEMENT_DET) FROM #SETTLEMENT_DET            
  GROUP BY PARTY_CODE,SAUDA_DATE            
 ) A            
 ON (A1.SAUDA_DATE = A.SAUDA_DATE AND A1.PARTY_CODE = A.PARTY_CODE)            
 LEFT OUTER JOIN            
 (            
  SELECT PARTY_CODE,SAUDA_DATE,CONTRACTNO_DET=MAX(CONTRACTNO_DET) FROM #CONTRACTNO_DET            
  GROUP BY PARTY_CODE,SAUDA_DATE            
 ) B            
 ON (A1.SAUDA_DATE = B.SAUDA_DATE AND A1.PARTY_CODE = B.PARTY_CODE)            
 LEFT OUTER JOIN            
 (            
  SELECT PARTY_CODE,SAUDA_DATE,BROKERSEBIREGNO_DET=MAX(BROKERSEBIREGNO_DET) FROM #BROKERSEBIREGNO_DET            
  GROUP BY PARTY_CODE,SAUDA_DATE            
 ) C            
 ON (A1.SAUDA_DATE = C.SAUDA_DATE AND A1.PARTY_CODE = C.PARTY_CODE)            
 LEFT OUTER JOIN            
 (            
  SELECT PARTY_CODE,SAUDA_DATE,MEMBERCODE_DET=MAX(MEMBERCODE_DET) FROM #MEMBERCODE_DET            
  GROUP BY PARTY_CODE,SAUDA_DATE            
 ) D            
 ON (A1.SAUDA_DATE = D.SAUDA_DATE AND A1.PARTY_CODE = D.PARTY_CODE)            
 LEFT OUTER JOIN            
 (            
  SELECT PARTY_CODE,SAUDA_DATE,CIN_DET=MAX(CIN_DET) FROM #CIN_DET            
  GROUP BY PARTY_CODE,SAUDA_DATE            
 ) E            
 ON (A1.SAUDA_DATE = E.SAUDA_DATE AND A1.PARTY_CODE = E.PARTY_CODE)            
 LEFT OUTER JOIN            
 (            
  SELECT PARTY_CODE,SAUDA_DATE,REMARK_DET=MAX(REMARK_DET) FROM #REMARK_DET            
  GROUP BY PARTY_CODE,SAUDA_DATE            
 ) F            
 ON (A1.SAUDA_DATE = F.SAUDA_DATE AND A1.PARTY_CODE = F.PARTY_CODE)            
            
        
 DROP TABLE #SETTLEMENT_DET            
 DROP TABLE #CONTRACTNO_DET            
 DROP TABLE #BROKERSEBIREGNO_DET            
 DROP TABLE #MEMBERCODE_DET            
 DROP TABLE #CIN_DET            
 DROP TABLE #REMARK_DET            
            
            
            
 UPDATE #CONTRACT            
 SET  SETTLEMENT_DET = ISNULL(C.SETTLEMENT_DET,''),            
   CONTRACTNO_DET = ISNULL(C.CONTRACTNO_DET,''),            
   BROKERSEBIREGNO_DET = ISNULL(C.BROKERSEBIREGNO_DET,''),            
   MEMBERCODE_DET = ISNULL(C.MEMBERCODE_DET,''),            
   CIN_DET= ISNULL(C.CIN_DET,''),            
   REMARK_DET= ISNULL(C.REMARK_DET,'')            
 FROM #CONTSETT_DET C            
 WHERE #CONTRACT.PARTY_CODE = C.PARTY_CODE            
 AND  #CONTRACT.SAUDA_DATE = C.SAUDA_DATE            
              
            
 SELECT PARTY_CODE,            
   SAUDA_DATE,            
   EXCHANGE,            
   SEGMENT,            
   SERVICE_TAX = SUM(SERVICE_TAX),            
   INS_CHRG = SUM(INS_CHRG),            
   NETAMOUNT = SUM(NETAMOUNT),            
   SEBI_TAX = SUM(SEBI_TAX),            
   TURN_TAX = SUM(TURN_TAX),            
   BROKER_CHRG = SUM(BROKER_CHRG),            
   OTHER_CHRG = SUM(OTHER_CHRG),            
   NETOBLIGATION = MAX(NETOBLIGATION)            
 INTO #CONTRACT1            
 FROM #CONTRACT            
 GROUP BY             
   PARTY_CODE,            
   SAUDA_DATE,            
   EXCHANGE,            
   SEGMENT            
            
            
 UPDATE #CONTRACT            
 SET  NETAMOUNTEX = (            
   CASE            
    WHEN C1.SEGMENT = 'FUTURES' THEN C1.NETOBLIGATION            
    ELSE C1.NETAMOUNT            
   END),            
   SEBI_TAXEX = C1.SEBI_TAX,            
   TURN_TAXEX = C1.TURN_TAX,            
   BROKER_CHRGEX = C1.BROKER_CHRG,            
   OTHER_CHRGEX = C1.OTHER_CHRG,            
   INS_CHRGEX = C1.INS_CHRG,            
   SERVICE_TAXEX = C1.SERVICE_TAX            
 FROM #CONTRACT C(NOLOCK),            
   #CONTRACT1 C1(NOLOCK)            
 WHERE C.PARTY_CODE = C1.PARTY_CODE            
 AND  C.SAUDA_DATE = C1.SAUDA_DATE            
 AND  C.EXCHANGE = C1.EXCHANGE            
 AND  C.SEGMENT = C1.SEGMENT            
             
 UPDATE #CONTRACT            
 SET  SCRIPNAME_NEW = SCRIPNAME            
             
             
 /*           
UPDATE #CONTRACT            
 SET  SCRIPNAME_NEW = SCRIPNAME + (CASE WHEN REMARK_ID <> '' THEN ' (' + REMARK_ID + ')' ELSE '' END)
 */ 
 
 
    UPDATE #CONTRACT            
  SET    SCRIPNAME ='(' + M.REMARK_ID + ')' + LTRIM(RTRIM(SCRIPNAME)),        
   REMARK_ID=M.REMARK_ID,        
   REMARK_DESC=M.REMARK_DESC        
  FROM    #CONTRACT CN,TBL_CONTRACT_TERMINAL_MAPPING M        
  where   USER_ID=TERMINAL_ID AND CN.ORDER_NO LIKE M.ORDER_NO + '%'    
      AND SAUDA_DATE BETWEEN FROM_DATE AND END_DATE + '23:59:59'       
      and SCRIPNAME <> 'BROKERAGE'          
             
             
 If @STATUSID ='BROKER'           
 BEGIN
            
 SELECT * FROM #CONTRACT             
 ORDER BY            
   --ORDERBYFLAG,    
   BRANCH_CD,    
  -- SUB_BROKER,            
   PARTY_CODE,            
   EXCHANGE,            
   SEGMENT,            
   BFCF_FLAG,            
   CONTRACTNO DESC,            
   SETT_TYPE,            
   SCRIPNAME,            
   SELL_BUY,            
   ORDER_NO,            
   TRADE_NO 
 
   
   END
   ELSE
   BEGIN 
   
    SELECT * FROM #CONTRACT             
 ORDER BY            
   --ORDERBYFLAG,    
   BRANCH_CD,    
   SUB_BROKER,            
   PARTY_CODE,            
   EXCHANGE,            
   SEGMENT,            
   BFCF_FLAG,            
   CONTRACTNO DESC,            
   SETT_TYPE,            
   SCRIPNAME,            
   SELL_BUY,            
   ORDER_NO,            
   TRADE_NO 
   END

GO
