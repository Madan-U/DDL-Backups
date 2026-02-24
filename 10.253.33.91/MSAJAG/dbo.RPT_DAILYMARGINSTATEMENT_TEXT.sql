-- Object: PROCEDURE dbo.RPT_DAILYMARGINSTATEMENT_TEXT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------







CREATE PROC [dbo].[RPT_DAILYMARGINSTATEMENT_TEXT]    
  
 (                                  
 @MDATE VARCHAR(11),                                  
 @FROMPARTY VARCHAR(15),                                  
 @TOPARTY VARCHAR(15),                                  
 @FROMBRANCH VARCHAR(15)  = '',                                  
 @TOBRANCH VARCHAR(15)  = 'ZZZZZZZZ',     
 @BRANCHFLAG       VARCHAR(10),                                     
 @FROMSUBBROKER VARCHAR(15) = '',                                  
 @TOSUBBROKER VARCHAR(15) = 'ZZZZZZZZ',                                  
 @STATUSID VARCHAR(15),                                  
 @STATUSNAME VARCHAR(25),                                  
 @WITHCOLL INT = 0,                                  
 @BOUNCEDFLAG INT ,                                  
 @SEGMENT CHAR(1) = 'N',                                  
 @FLAG VARCHAR(10)                                   
 )                                  
                                  
 AS                                  
                                  
 /*                                  
 SELECT * FROM Tbl_Mar_Report                                a  
 EXEC RPT_DAILYMARGINSTATEMENT 'APR 13 2010', '0A141','0A141','','ZZZZZZZZZ','','ZZZZZZZZZ','BROKER','BROKER',1,0,'C'                                  
 */                     
                               
                                  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                  
 IF (CHARINDEX('/',@MDATE) > 0)                                  
 BEGIN                                  
  SELECT @MDATE = CONVERT(VARCHAR,CONVERT(DATETIME,@MDATE,103),109)                                  
 END                                  
                      
					  
  SELECT * INTO #TBL_MAR_REPORT_COMM FROM 
 ANGELCOMMODITY.MCDX.DBO.TBL_MAR_REPORT WITH(NOLOCK)  WHERE TRADE_DAY    BETWEEN 'MAY  2 2023' AND 'MAY  2 2023' + ' 23:59:59'                             
 AND PARTY_CODE BETWEEN 'A000000' AND 'ZZZZZZZ' 

 CREATE INDEX #TRADE_DAY ON #TBL_MAR_REPORT_COMM(TRADE_DAY,PARTY_CODE)

 SELECT DISTINCT PARTY_CODE                                  
 INTO #MCLIENT                                  
 FROM Tbl_Mar_Report (NOLOCK)                                 
 WHERE TRADE_DAY BETWEEN @MDATE AND @MDATE + ' 23:59:59' 
 union all
 select DISTINCT PARTY_CODE FROM 
 #TBL_MAR_REPORT_COMM  WHERE TRADE_DAY    BETWEEN @MDATE AND @MDATE + ' 23:59:59'                             
 AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY  
 --AND PARTY_CODE  IN (SELECT * FROM BULK_CLIENT)                        
                     
                  
 CREATE NONCLUSTERED INDEX [IND] ON [dbo].[#MCLIENT]                       
(                      
 [PARTY_CODE] ASC                        
 )                     
     
 SELECT DISTINCT CL_CODE,PRINT_OPTIONS=MAX(CASE WHEN PRINT_OPTIONS IN ('2') THEN 2 ELSE 0 END)  INTO #CLIENT_BROK_DETAILS FROM CLIENT_BROK_DETAILS (NOLOCK)        
 WHERE --EXCHANGE NOT IN ('MCX','NCX') AND 
 CL_CODE IN (SELECT * FROM #MCLIENT)  
 GROUP BY   CL_CODE            
           
  CREATE NONCLUSTERED INDEX [IND1] ON [DBO].[#CLIENT_BROK_DETAILS]                               
(                              
 [cl_code] ASC                                
 )  	                    
      
                                   
 SELECT                                  
  PARTY_CODE = CL_CODE,                                  
  PARTYNAME = LONG_NAME,                                  
  L_ADDRESS1,                                  
  L_ADDRESS2,                                  
  L_ADDRESS3,                                  
  L_CITY,                                  
  L_ZIP,                                  
  L_STATE,                                  
  L_NATION,                                  
  RES_PHONE = RES_PHONE1 + RES_PHONE2,                                  
  OFF_PHONE = OFF_PHONE1 + OFF_PHONE2,                                  
  EMAIL,                                  
  PAN_GIR_NO,                                  
  BRANCH_CD,                                  
  SUB_BROKER                                  
 INTO                                  
  #CLIENTMASTER                                  
 FROM                                  
  CLIENT1 C1 (NOLOCK),    
  BRANCHGROUP B(nolock)                                  
 WHERE                                  
  CL_CODE BETWEEN @FROMPARTY AND @TOPARTY                                  
  AND B.BRANCH_GROUP BETWEEN @FROMBRANCH AND @TOBRANCH    
    AND C1.Branch_cd=B.BRANCH_CODE                                   
  AND SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER                     
                         
  --AND CL_CODE IN (SELECT PARTY_CODE FROM #MCLIENT)                                  
  AND EXISTS (SELECT party_code FROM #MCLIENT where c1.Cl_Code = #MCLIENT.PARTY_CODE)                              
  AND @STATUSNAME = (                                  
  CASE                                  
   WHEN @STATUSID = 'BRANCH'                                  
   THEN C1.BRANCH_CD                                  
   WHEN @STATUSID = 'SUBBROKER'                                  
   THEN C1.SUB_BROKER                                  
   WHEN @STATUSID = 'TRADER'                                  
   THEN C1.TRADER                        
   WHEN @STATUSID = 'FAMILY'                                  
   THEN C1.FAMILY                                  
   WHEN @STATUSID = 'AREA'             
   THEN C1.AREA                                  
   WHEN @STATUSID = 'REGION'                                  
   THEN C1.REGION                                  
   WHEN @STATUSID = 'CLIENT'                                 
   THEN CL_CODE                                  
   ELSE 'BROKER'                                  
  END)     
    
  
                            
                     
CREATE NONCLUSTERED INDEX [IND] ON [dbo].#CLIENTMASTER                       
(                      
 [PARTY_CODE] ASC                        
)                     
                                  
 CREATE TABLE #MARGIN_DETAIL                                  
  (                                  
  EXCHANGE VARCHAR(3),                                  
  SEGMENT     VARCHAR(10),                                  
  PARTY_CODE   VARCHAR(15),                       
  MARGINDATE   DATETIME,                                  
  LED_MARGIN_AMT  MONEY,                                  
  NONCASH_AMT   MONEY,                                  
  BGFD_AMT   MONEY,                                  
  OTHER_MARGIN  MONEY,                                  
  TOTAL_MARGIN_AVL MONEY,                                  
  INITIALMARGIN  MONEY,                                  
  EXPOSURE_MARGIN  MONEY,                                  
  TOTAL_MARGIN  MONEY,                                  
  EXCESS_SHORTFALL MONEY,                                  
  ADD_MARGIN   MONEY,                                  
  MARGIN_STATUS  MONEY,                                  
  )                                  
                                  
INSERT INTO #MARGIN_DETAIL                                  
 SELECT                                  
  EXCHANGE = T.EXCHANGE,                                  
  SEGMENT = T.SEGMENT,                                  
  PARTY_CODE  = T.PARTY_CODE,                                  
  MARGINDATE  = LEFT(TRADE_DAY,11),                                  
  LED_MARGIN_AMT = SUM(CASH-FD_BG),                                  
  NONCASH_AMT  = SUM(NONCASH),                                  
  BGFD_AMT  = SUM(FD_BG),                                  
  OTHER_MARGIN = SUM(ANY_OTHER_COLL),                                  
  TOTAL_MARGIN_AVL= SUM(TOTALCOLL),                                  
  INITIALMARGIN = ISNULL(SUM(INIT_MARGIN),0),                                  
  EXPOSURE_MARGIN = ISNULL(SUM(EXP_MARGIN),0),                                  
  TOTAL_MARGIN = ISNULL(SUM(TOTALMARGIN),0),                                  
  EXCESS_SHORTFALL= ISNULL(SUM(EXG_MAR_SHORT),0),                                  
  --ADD_MARGIN  = ISNULL(SUM(ADD_MARGIN),0),                                  
  --MARGIN_STATUS = ISNULL(SUM(MARGIN_STATUS),0)  
  ADD_MARGIN  = CASE WHEN  ISNULL(SUM(ADD_MARGIN),0)<0 THEN ABS(ISNULL(SUM(ADD_MARGIN),0))  ELSE 0 END ,                                  
  MARGIN_STATUS = CASE WHEN  ISNULL(SUM(ADD_MARGIN),0)<0 THEN ISNULL(SUM(MARGIN_STATUS),0)  ELSE ISNULL(SUM(EXG_MAR_SHORT),0) END                                   
 FROM                                  
  Tbl_Mar_Report T (NOLOCK),                                  
  #CLIENTMASTER  C (NOLOCK)                                  
 WHERE                                  
  TRADE_DAY BETWEEN @MDATE AND @MDATE + ' 23:59:59'                                  
  AND T.PARTY_CODE = C.PARTY_CODE                                  
  --AND T.EXCHANGE = 'NSE'                                  
  --AND T.SEGMENT = 'CAPITAL'                                  
 GROUP BY                               
  T.PARTY_CODE,                                  
  LEFT(TRADE_DAY,11),                                  
  EXCHANGE,                                  
  SEGMENT   
  
 UNION ALL
 SELECT                                          
 EXCHANGE = T.EXCHANGE,                                          
 SEGMENT = T.SEGMENT,                                          
 PARTY_CODE  = T.PARTY_CODE,                                          
 MARGINDATE  = LEFT(TRADE_DAY,11),                                          
 LED_MARGIN_AMT = SUM(CASH-FD_BG),                                          
 NONCASH_AMT  = SUM(NONCASH),                            
 BGFD_AMT  = SUM(FD_BG),                                          
 OTHER_MARGIN = SUM(ANY_OTHER_COLL),                                          
 TOTAL_MARGIN_AVL= SUM(TOTALCOLL),       
 INITIALMARGIN = ISNULL(SUM(INIT_MARGIN),0),                                          
 EXPOSURE_MARGIN = ISNULL(SUM(EXP_MARGIN),0),                                          
 TOTAL_MARGIN = ISNULL(SUM(TOTALMARGIN),0),                                          
 EXCESS_SHORTFALL= ISNULL(SUM(EXG_MAR_SHORT),0),                                 
 --ADD_MARGIN  = ISNULL(SUM(ADD_MARGIN),0),                                          
 --MARGIN_STATUS = ISNULL(SUM(MARGIN_STATUS),0) 
 ADD_MARGIN  = CASE WHEN  ISNULL(SUM(ADD_MARGIN),0)<0 THEN ABS(ISNULL(SUM(ADD_MARGIN),0))  ELSE 0 END ,                                  
 MARGIN_STATUS = CASE WHEN  ISNULL(SUM(ADD_MARGIN),0)<0 THEN ISNULL(SUM(MARGIN_STATUS),0)  ELSE ISNULL(SUM(EXG_MAR_SHORT),0) END                                           
FROM                                          
 #TBL_MAR_REPORT_COMM T WITH (NOLOCK),            
 #CLIENTMASTER  C (NOLOCK)                                          
WHERE                                          
 TRADE_DAY BETWEEN @MDATE AND @MDATE + ' 23:59:59'                                          
 AND T.PARTY_CODE = C.PARTY_CODE                                          
 --AND T.EXCHANGE = 'NSE'                                          
 --AND T.SEGMENT = 'CAPITAL'                                          
 GROUP BY                                       
 T.PARTY_CODE,                                          
 LEFT(TRADE_DAY,11),                                          
 EXCHANGE,                                          
 SEGMENT                                          
           
  UNION ALL
  
 SELECT                                          
 EXCHANGE = 'DP' ,                                          
 SEGMENT = 'HOLD',                                          
 PARTY_CODE  = T.PARTY_CODE,                                          
 MARGINDATE  = LEFT(effdate,11),                                          
 LED_MARGIN_AMT = SUM(0),                                          
 NONCASH_AMT  = SUM(MRG_FINALAMOUNT),                            
 BGFD_AMT  = SUM(0),                                          
 OTHER_MARGIN = SUM(0),                                          
 TOTAL_MARGIN_AVL= SUM(MRG_FINALAMOUNT),       
 INITIALMARGIN = ISNULL(SUM(0),0),                                          
 EXPOSURE_MARGIN = ISNULL(SUM(0),0),                                          
 TOTAL_MARGIN = ISNULL(SUM(0),0),                                          
 EXCESS_SHORTFALL= ISNULL(SUM(MRG_FINALAMOUNT),0),                                 
 --ADD_MARGIN  = ISNULL(SUM(ADD_MARGIN),0),                                          
 --MARGIN_STATUS = ISNULL(SUM(MARGIN_STATUS),0) 
 ADD_MARGIN  = 0,                               
 MARGIN_STATUS = SUM(MRG_FINALAMOUNT)                                       
FROM                                          
 V2_TBL_COLLATERAL_MARGIN_COMBINE T (NOLOCK),            
 #CLIENTMASTER  C (NOLOCK)                                          
WHERE                                          
 effdate BETWEEN @MDATE AND @MDATE + ' 23:59:59'                                          
 AND T.PARTY_CODE = C.PARTY_CODE  AND EXCHANGE ='POA'                                         
 --AND T.EXCHANGE = 'NSE'                                          
 --AND T.SEGMENT = 'CAPITAL'                                          
 GROUP BY                                       
 T.PARTY_CODE,                                          
 LEFT(effdate,11),                                          
 EXCHANGE,                                          
 SEGMENT     
   ----------------MTF ADDED
 
  UNION ALL

  

 SELECT                                          

 EXCHANGE = 'MTF' ,                                          

 SEGMENT = 'COLLATERAL',                                          

 PARTY_CODE  = T.PARTY_CODE,                                          

 MARGINDATE  = LEFT(MARGINDATE,11),                                          

 LED_MARGIN_AMT = SUM(0),                                          

 NONCASH_AMT  = SUM(TDAY_NONCASH),                            

 BGFD_AMT  = SUM(0),                                          

 OTHER_MARGIN = SUM(0),                                          

 TOTAL_MARGIN_AVL= SUM(TDAY_NONCASH),       

 INITIALMARGIN = ISNULL(SUM(0),0),                                          

 EXPOSURE_MARGIN = ISNULL(SUM(0),0),                                          

 TOTAL_MARGIN = ISNULL(SUM(0),0),                                          

 EXCESS_SHORTFALL= ISNULL(SUM(TDAY_NONCASH),0),                                 

 --ADD_MARGIN  = ISNULL(SUM(ADD_MARGIN),0),                                          

 --MARGIN_STATUS = ISNULL(SUM(MARGIN_STATUS),0) 

 ADD_MARGIN  = 0,                               

 MARGIN_STATUS = SUM(TDAY_NONCASH)                                       

FROM                                          

 TBL_COMBINE_REPORTING_DETAIL T (NOLOCK),            

 #CLIENTMASTER  C (NOLOCK)                                          

WHERE                                          

 MARGINDATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'                                          

 AND T.PARTY_CODE = C.PARTY_CODE  AND EXCHANGE ='MTF'                                         

 --AND T.EXCHANGE = 'NSE'                                          

 --AND T.SEGMENT = 'CAPITAL'                                          

 GROUP BY                                       

 T.PARTY_CODE,                                          

 LEFT(MARGINDATE,11),                                          

 EXCHANGE,                                          

 SEGMENT     
                                 
                                           
--DELETE FROM #MARGIN_DETAIL                                            
--WHERE EXISTS (                                            
-- SELECT DISTINCT PARTY_CODE                                            
-- FROM                                            
-- (                                            
-- SELECT PARTY_CODE FROM #MARGIN_DETAIL                 
-- GROUP BY PARTY_CODE                                             
-- HAVING SUM(INITIALMARGIN+EXPOSURE_MARGIN+ADD_MARGIN) = 0                                            
-- ) A                                            
-- WHERE A.PARTY_CODE = #MARGIN_DETAIL.PARTY_CODE                        
--) 

 

 /* ADDED FOR CASH NON CASH COLL START */  



SELECT distinct PARTY_CODE,EXCHANGE,SEGMENT,SUM(MRG_FINALAMOUNT)TDAY_NONCASH into #noncash
 FROM V2_TBL_COLLATERAL_MARGIN_COMBINE WHERE EFFDATE  BETWEEN @MDATE AND @MDATE + ' 23:59:59'
and SEGMENT ='CAPITAL' and party_code BETWEEN @FROMPARTY AND @TOPARTY   
group by PARTY_CODE,EXCHANGE,SEGMENT

CREATE INDEX IX_CL ON #noncash (party_code,EXCHANGE,SEGMENT)


UPDATE #MARGIN_DETAIL SET NONCASH_AMT =0
WHERE SEGMENT ='CAPITAL'

UPDATE  M
SET NONCASH_AMT =t.TDAY_NONCASH ,TOTAL_MARGIN_AVL=LED_MARGIN_AMT+TDAY_NONCASH+0,
EXCESS_SHORTFALL=LED_MARGIN_AMT+T.TDAY_NONCASH+0-TOTAL_MARGIN,MARGIN_STATUS=LED_MARGIN_AMT+TDAY_NONCASH+0-TOTAL_MARGIN
FROM #noncash T ,#MARGIN_DETAIL M
WHERE T.PARTY_CODE =M.PARTY_CODE
AND T.EXCHANGE =M.EXCHANGE AND T.SEGMENT =M.SEGMENT
AND T.SEGMENT ='CAPITAL'
--AND T.MARGINDATE  BETWEEN @MDATE AND @MDATE + ' 23:59:59'  

UPDATE  M
SET TOTAL_MARGIN_AVL=LED_MARGIN_AMT+NONCASH_AMT+0,
EXCESS_SHORTFALL=LED_MARGIN_AMT+NONCASH_AMT+0-TOTAL_MARGIN,MARGIN_STATUS=LED_MARGIN_AMT+NONCASH_AMT+0-TOTAL_MARGIN
FROM #MARGIN_DETAIL M 
WHERE M.PARTY_CODE NOT in 
(SELECT PARTY_CODE FROM #noncash)
AND SEGMENT ='CAPITAL'




    /* ADDED FOR CASH NON CASH COLL END */       




DELETE FROM #MARGIN_DETAIL                                            
WHERE EXISTS (                                            
 SELECT DISTINCT PARTY_CODE                                            
 FROM                                            
 (                                            
 SELECT PARTY_CODE FROM #MARGIN_DETAIL                 
 GROUP BY PARTY_CODE                                             
 HAVING SUM(ABS(INITIALMARGIN)+ABS(EXPOSURE_MARGIN)+ABS(ADD_MARGIN)) = 0                                            
 ) A                                            
 WHERE A.PARTY_CODE = #MARGIN_DETAIL.PARTY_CODE                        
)                                            
   
               
 SELECT                                  
  PARTY_CODE  = M.PARTY_CODE,                                  
  MARGINDATE  = CONVERT(VARCHAR,MARGINDATE,103),                                  
  EXCHANGE,                                
  SEGMENT,                                  
  LED_MARGIN_AMT = SUM(LED_MARGIN_AMT),                                  
  NONCASH_AMT  = SUM(NONCASH_AMT),                                  
  BGFD_AMT  = SUM(BGFD_AMT),                                  
  OTHER_MARGIN = SUM(OTHER_MARGIN),                                  
  TOTAL_MARGIN_AVL= SUM(TOTAL_MARGIN_AVL),                            
  INITIALMARGIN = SUM(INITIALMARGIN),                                  
  EXPOSURE_MARGIN = SUM(EXPOSURE_MARGIN),                                  
  TOTAL_MARGIN = SUM(TOTAL_MARGIN),                                  
  EXCESS_SHORTFALL= SUM(EXCESS_SHORTFALL),                                  
  ADD_MARGIN  = SUM(ADD_MARGIN),                                  
  MARGIN_STATUS = SUM(MARGIN_STATUS),                                  
  PARTYNAME,                                  
  L_ADDRESS1,                                  
  L_ADDRESS2,                                  
  L_ADDRESS3,                                  
  L_CITY,                                  
  L_ZIP,                            L_STATE,                                  
  L_NATION,                                  
  RES_PHONE,                                  
  OFF_PHONE,                                  
  EMAIL,                                  
  PAN_GIR_NO,                                  
  BRANCH_CD,                                  
  SUB_BROKER,                                  
  RPT_ORD = '1DET',                                  
  SCRIP_CD= CONVERT(VARCHAR(20),''),                                  
  SERIES = CONVERT(VARCHAR(5),''),                                  
  QTY = CONVERT(NUMERIC(18,4),0),                                  
  SEC_CLRATE = CONVERT(NUMERIC(18,4),0),                                  
  SEC_AMOUNT = CONVERT(NUMERIC(18,4),0),                                  
  SEC_HAIRCUT = CONVERT(NUMERIC(18,4),0),                                  
  SEC_FAMOUNT = CONVERT(NUMERIC(18,4),0),                                  
  BGNO = CONVERT(VARCHAR(20),''),                                  
  BG_AMOUNT = CONVERT(NUMERIC(18,4),0),                                  
  BG_EXPIRYDATE = CONVERT(VARCHAR(11),''),                                  
  FDRNO = CONVERT(VARCHAR(20),''),                                  
  FDR_AMOUNT = CONVERT(NUMERIC(18,4),0),                                  
  FDR_EXPIRYDATE = CONVERT(VARCHAR(11),''),                                  
  SCRIPNAME = CONVERT(VARCHAR(100),''),                                  
 ISIN = CONVERT(VARCHAR(12),'') 
 INTO                     
  #FINAL_REPORT                                  
 FROM                                  
  #MARGIN_DETAIL M (NOLOCK),                                  
  #CLIENTMASTER  C (NOLOCK)                                  
 WHERE                                  
  M.PARTY_CODE = C.PARTY_CODE                                  
 GROUP BY                                  
  M.PARTY_CODE,                                 
  CONVERT(VARCHAR,MARGINDATE,103),                                  
  EXCHANGE,                                  
  SEGMENT,                                  
  PARTYNAME,                                  
  L_ADDRESS1,                                  
  L_ADDRESS2,                                  
  L_ADDRESS3,                                  
  L_CITY,                                  
  L_ZIP,                                  
  L_STATE,                                  
  L_NATION,                                  
  RES_PHONE,                                  
  OFF_PHONE,                                  
  EMAIL,                                  
  PAN_GIR_NO,                                  
  BRANCH_CD,                                  
  SUB_BROKER                                  
 ORDER BY              
  PARTY_CODE    
  
   CREATE NONCLUSTERED INDEX [FIND] ON [dbo].[#FINAL_REPORT]                       
(                      
 [PARTY_CODE] ASC                        
 )                     
          
                                
                              
                                  
 IF (@WITHCOLL = 1)                                  
 BEGIN                
 /*                  
 SELECT * INTO #COLLATERALDETAILS                              
 FROM   MSAJAG.DBO.COLLATERALDETAILS C (NOLOCK)                                  
 WHERE  EFFDATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'                                  
    AND EXISTS (SELECT DISTINCT PARTY_CODE FROM #FINAL_REPORT WHERE c.Party_Code = #FINAL_REPORT.PARTY_CODE)   
	 AND  EXCHANGE NOT IN ('MCX','NCX')             */
SELECT * INTO #COLLATERALDETAILS                                      
FROM   MSAJAG.DBO.COLLATERALDETAILS C (NOLOCK)                                          
WHERE  EFFDATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'                                          
AND EXISTS (SELECT DISTINCT PARTY_CODE FROM #FINAL_REPORT   
WHERE C.PARTY_CODE = #FINAL_REPORT.PARTY_CODE) --AND  EXCHANGE NOT IN ('MCX','NCX') 
AND   Coll_Type <> 'SEC'

INSERT INTO  #COLLATERALDETAILS
SELECT  EFFDATE,EXCHANGE=(CASE WHEN EXCHANGE='POA' THEN 'DP' ELSE EXCHANGE END) ,SEGMENT= (CASE WHEN SEGMENT='POA' THEN 'HOLDING' ELSE SEGMENT END) ,
PARTY_CODE,SCRIP_CD,SERIES,ISIN,MRG_CL_RATE,AMOUNT=QTY*MRG_CL_RATE,
QTY,MRG_VAR_MARGIN,MRG_FINALAMOUNT,0,0,''PERCENTAGECASH,PERECNTAGENONCASH,COLL_TYPE,''CLIENT_TYPE,'','',createdon,CASH_NCASH,'','','',''
FROM V2_TBL_COLLATERAL_MARGIN_COMBINE C WHERE EFFDATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'
AND Coll_Type = 'SEC'        AND EXISTS (SELECT DISTINCT PARTY_CODE FROM #FINAL_REPORT   
WHERE C.PARTY_CODE = #FINAL_REPORT.PARTY_CODE)
	 
	 
	 
	                     
 END                              
                                  
                                  
 IF (@WITHCOLL = 1)                                  
 BEGIN                                  
  SELECT                                  
   PARTY_CODE,                                  
   MARGINDATE,          
   EXCHANGE,                                  
   SEGMENT,                                  
   SCRIP_CD,                                  
   SERIES,                                  
   QTY = SUM(QTY),                                  
   SEC_CLRATE = SEC_CLRATE,                                  
   SEC_AMOUNT = SUM(SEC_AMOUNT),                                  
   SEC_HAIRCUT = SEC_HAIRCUT,                                  
   SEC_FAMOUNT = SUM(SEC_FAMOUNT),                                  
   BGNO,                          
   BG_AMOUNT = SUM(BG_AMOUNT),                                  
   BG_EXPIRYDATE,                               
   FDRNO,                                  
   FDR_AMOUNT = SUM(FDR_AMOUNT),                                  
   FDR_EXPIRYDATE,                                  
   SCRIPNAME = CONVERT(VARCHAR(100),''),                                  
   COLL_TYPE = '2' + UPPER(COLL_TYPE),                                  
ISIN
  INTO                                  
   #COLL_DETAIL                                  
  FROM                                  
   (                          
   SELECT                                  
    party_code=upper(PARTY_CODE),                                  
    MARGINDATE = CONVERT(VARCHAR,EFFDATE,103),                                  
    EXCHANGE,                                  
    SEGMENT,                                  
    SCRIP_CD = (                                  
    CASE                                   
     WHEN COLL_TYPE = 'SEC'                                   
     THEN SCRIP_CD ELSE ''                                   
    END),                                  
    SERIES,                                  
    QTY = (                
    CASE                                   
     WHEN COLL_TYPE = 'SEC'                                   
     THEN QTY ELSE 0                                   
    END),                                  
    SEC_CLRATE = (                                  
    CASE                                   
     WHEN COLL_TYPE = 'SEC'                                   
     THEN CL_RATE ELSE 0                                   
    END),                                  
    SEC_AMOUNT = (                                  
    CASE                                   
     WHEN COLL_TYPE = 'SEC'                                   
     THEN AMOUNT ELSE 0                                   
    END),                                  
    SEC_HAIRCUT = (                                  
    CASE                                   
     WHEN COLL_TYPE = 'SEC'                                   
     THEN HAIRCUT ELSE 0                                   
    END),                                  
    SEC_FAMOUNT = (                                  
    CASE                                   
     WHEN COLL_TYPE = 'SEC'                                   
     THEN FINALAMOUNT ELSE 0                                   
    END),                                  
    BGNO =(                                  
    CASE                                  
     WHEN COLL_TYPE = 'BG'        
     THEN FD_BG_NO ELSE ''                                  
    END),                                  
    BG_AMOUNT =(                                  
    CASE                                  
     WHEN COLL_TYPE = 'BG'                                  
     THEN FINALAMOUNT ELSE 0                                  
    END),                                  
    BG_EXPIRYDATE = (                                  
    CASE                                  
     WHEN COLL_TYPE = 'BG'                                     THEN CONVERT(VARCHAR,MATURITY_DATE,103) ELSE ''                                  
    END),                                  
    FDRNO =(                                  
    CASE                                  
     WHEN COLL_TYPE = 'FD'                                  
     THEN FD_BG_NO ELSE ''                                  
    END),                                  
    FDR_AMOUNT =(                                  
    CASE                                  
     WHEN COLL_TYPE = 'FD'                                  
     THEN FINALAMOUNT ELSE 0                                  
    END),                                  
    FDR_EXPIRYDATE = (                                  
    CASE                                  
     WHEN COLL_TYPE = 'FD'                                  
     THEN CONVERT(VARCHAR,MATURITY_DATE,103) ELSE ''                                  
    END),                                  
    COLL_TYPE ,ISIN                                 
   FROM                                  
    #COLLATERALDETAILS C (NOLOCK)                                  
   WHERE                                  
    --PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #FINAL_REPORT)                                  
    EFFDATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'                                  
    AND COLL_TYPE <> 'MARGIN'                                  
/*    AND EXCHANGE <> 'NSE'                                  
    AND SEGMENT <> 'FUTURES'                                  
*/                                  
   ) COLL                                  
  GROUP BY                                  
   PARTY_CODE,                                  
   MARGINDATE,                                  
   SCRIP_CD,                                  
   SERIES,                                  
   SEC_CLRATE,                                  
   SEC_HAIRCUT,                                  
   BGNO,                                  
   BG_EXPIRYDATE,                                  
   FDRNO,                                  
   FDR_EXPIRYDATE,                                  
   UPPER(COLL_TYPE),                                  
   EXCHANGE,                
   SEGMENT,                                  
ISIN
                                   
--SELECT * FROM #COLL_DETAIL       
 

SELECT  A.* INTO #FO_TBL_COLLATERAL_MARGIN FROM ANGELFO.NSEFO.DBO.TBL_COLLATERAL_MARGIN  A WITH(NOLOCK) ,#CLIENTMASTER C WITH(NOLOCK)
WHERE  EFFDATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'   AND                                 
 A.PARTY_CODE =C.PARTY_CODE

 SELECT  A.* INTO #COMM_TBL_COLLATERAL_MARGIN FROM ANGELCOMMODITY.MCDXCDS.DBO.TBL_COLLATERAL_MARGIN  A WITH(NOLOCK) ,#CLIENTMASTER C WITH(NOLOCK)
WHERE  EFFDATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'  AND                                 
 A.PARTY_CODE =C.PARTY_CODE

 CREATE INDEX #MPARTY ON #FO_TBL_COLLATERAL_MARGIN (EFFDATE, PARTY_CODE)
  CREATE INDEX #MCOMM ON #COMM_TBL_COLLATERAL_MARGIN (EFFDATE ,PARTY_CODE)             
                              
                                  
UPDATE T                                   
                                  
SET T.SEC_AMOUNT = T1.AMOUNT,                                  
T.SEC_FAMOUNT = T1.FINALAMOUNT,
T.SEC_CLRATE =T1.CL_RATE ,    
T.SEC_HAIRCUT =T1.HAIRCUT                                   
                                  
FROM #COLL_DETAIL T, #FO_TBL_COLLATERAL_MARGIN T1 with (nolock)                                  
WHERE                                   
T.PARTY_CODE=T1.PARTY_CODE                                  
AND EXCHANGE='NSE' AND SEGMENT='FUTURES'                                  
--AND CONVERT(VARCHAR(11),T.MARGINDATE,103)=CONVERT(VARCHAR(11),T1.EFFDATE,103)                                  
AND T1.EFFDATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'                               
AND T.SCRIP_CD=T1.SCRIP_CD                                  
AND T1.COLL_TYPE = 'SEC'                                        
                                  
UPDATE T                                   
SET T.SEC_AMOUNT = T1.AMOUNT,                                  
T.SEC_FAMOUNT = T1.FINALAMOUNT ,
T.SEC_CLRATE =T1.CL_RATE ,    
T.SEC_HAIRCUT =T1.HAIRCUT 
                                 
FROM #COLL_DETAIL T, #COMM_TBL_COLLATERAL_MARGIN T1 with (nolock)                               
WHERE                                   
T.PARTY_CODE=T1.PARTY_CODE                                  
AND EXCHANGE='MCD' AND SEGMENT='FUTURES'                                  
--AND CONVERT(VARCHAR(11),T.MARGINDATE,103)=CONVERT(VARCHAR(11),T1.EFFDATE,103)                                
AND T1.EFFDATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'                                 
AND T.SCRIP_CD=T1.SCRIP_CD                                  
AND T1.COLL_TYPE = 'SEC'                                        
                              
                                  
  ALTER TABLE #FINAL_REPORT                                  
  ALTER COLUMN  RPT_ORD VARCHAR(7)                                  
                                    
                                  
  INSERT INTO #FINAL_REPORT                                  
  SELECT                                  
   PARTY_CODE  = M.PARTY_CODE,                                  
   MARGINDATE,                                  
   EXCHANGE,                                  
   SEGMENT,                                  
   LED_MARGIN_AMT = 0,                                  
   NONCASH_AMT  = 0,                                  
   BGFD_AMT  = 0,                                  
   OTHER_MARGIN = 0,                                  
   TOTAL_MARGIN_AVL= 0,                                  
   INITIALMARGIN = 0,                                  
   EXPOSURE_MARGIN = 0,                                 TOTAL_MARGIN = 0,                                  
   EXCESS_SHORTFALL= 0,                                  
   ADD_MARGIN  = 0,                                  
   MARGIN_STATUS = 0,                                  
   PARTYNAME,                                  
   L_ADDRESS1,                                  
   L_ADDRESS2,                                  
   L_ADDRESS3,                                  
   L_CITY,                                  
   L_ZIP,                                  
   L_STATE,                                  
   L_NATION,                                  
   RES_PHONE,                                  
   OFF_PHONE,                                  
   EMAIL,                                  
   PAN_GIR_NO,                                  
   BRANCH_CD,                                  
   SUB_BROKER,                                  
   RPT_ORD = UPPER(COLL_TYPE),                                  
   SCRIP_CD,                                  
   SERIES,                                  
   QTY,                                  
   SEC_CLRATE,                                  
   SEC_AMOUNT,                                  
   SEC_HAIRCUT,                                  
   SEC_FAMOUNT,                                  
   BGNO,                                  
   BG_AMOUNT,                                  
   BG_EXPIRYDATE,                                  
   FDRNO,                                  
   FDR_AMOUNT,                                  
   FDR_EXPIRYDATE,                                  
   SCRIPNAME = SCRIP_CD,                                  
ISIN
  FROM                                  
   #COLL_DETAIL   M (NOLOCK),                                  
   #CLIENTMASTER  C (NOLOCK)                                  
  WHERE                                  
   M.PARTY_CODE = C.PARTY_CODE                         
 END                                  
                                  
                                  
                                  
 UPDATE #FINAL_REPORT                                  
 SET  SCRIPNAME = ISNULL(S1.LONG_NAME,#FINAL_REPORT.SCRIP_CD)                                  
 FROM SCRIP1 S1 (NOLOCK),                                   
   SCRIP2 S2 (NOLOCK)                                  
 WHERE S1.CO_CODE = S2.CO_CODE                                  
   AND S1.SERIES = S2.SERIES                                  
   AND #FINAL_REPORT.SCRIP_CD = S2.SCRIP_CD                                  
   AND #FINAL_REPORT.SERIES = S2.SERIES                                  
   AND #FINAL_REPORT.EXCHANGE = 'NSE'                                  
   AND #FINAL_REPORT.RPT_ORD = '2SEC'                                  
                                   
                                  
 SELECT                                  
  FI.PARTY_CODE,                                  
  MARGINDATE,                                  
  EXCHANGE = (                                  
  CASE                                  
   WHEN SEGMENT ='CAPITAL' THEN FI.EXCHANGE + '-CASH'                                  
   WHEN SEGMENT ='FUTURES' THEN FI.EXCHANGE + '-F&O'                                  
   ELSE FI.EXCHANGE + '-' + SEGMENT                                  
  END),                                  
  SEGMENT,           
  LED_MARGIN_AMT = SUM(LED_MARGIN_AMT),                                  
  NONCASH_AMT = SUM(NONCASH_AMT),                                  
  BGFD_AMT = SUM(BGFD_AMT),                                  
  OTHER_MARGIN = SUM(OTHER_MARGIN),                                  
  TOTAL_MARGIN_AVL = SUM(TOTAL_MARGIN_AVL),                                  
  INITIALMARGIN = SUM(INITIALMARGIN),                                  
  EXPOSURE_MARGIN = SUM(EXPOSURE_MARGIN),                                  
  TOTAL_MARGIN = SUM(TOTAL_MARGIN),                                  
  EXCESS_SHORTFALL = SUM(EXCESS_SHORTFALL),                                  
  ADD_MARGIN = SUM(ADD_MARGIN),                                  
  MARGIN_STATUS = SUM(MARGIN_STATUS),                                  
  PARTYNAME,                                  
  L_ADDRESS1,                                  
  L_ADDRESS2,                                  
  L_ADDRESS3,                                  
  L_CITY,                                  
  L_ZIP,                                
  L_STATE,                                  
  L_NATION,                                  
  RES_PHONE,                                  
  OFF_PHONE,                                  
  EMAIL,                                  
  PAN_GIR_NO,                                  
  BRANCH_CD,                                  
  SUB_BROKER,                                  
  RPT_ORD,                                  
  SCRIP_CD,                                  
  SERIES,                                  
  QTY = SUM(QTY),                                  
  SEC_CLRATE,                                  
  SEC_AMOUNT = SUM(SEC_AMOUNT)  , --(CASE WHEN SEGMENT <> 'CAPITAL' THEN SUM(SEC_AMOUNT)  ELSE 0 END),                                  
  SEC_HAIRCUT = SUM(SEC_HAIRCUT),                                  
  SEC_FAMOUNT = SUM(SEC_FAMOUNT),                                  
  BGNO,                                  
  BG_AMOUNT = SUM(BG_AMOUNT),                                  
  BG_EXPIRYDATE,                                  
  FDRNO,                                  
  FDR_AMOUNT = SUM(FDR_AMOUNT),                                  
FDR_EXPIRYDATE,                                  
  SCRIPNAME  ,                                 
ISIN
  INTO #FINAL_REPORTNEW                                  
 FROM                                   
  #FINAL_REPORT FI,                           
  #CLIENT_BROK_DETAILS C2  ,                      
   PRINTF_SETTINGS T                          
  --MSAJAG.DBO.FUN_PRINTF(@FLAG) C2                                   
                                   
 WHERE                                   
                                    
 T.PRINTF = C2.PRINT_OPTIONS                                  
                                   
 AND FI.PARTY_CODE=C2.CL_CODE                                   
                                   
 AND T.PRINTF_FLAG = @FLAG    
                              
                                   
 GROUP BY                                  
  FI.PARTY_CODE,                                  
  MARGINDATE,                                  
  CASE                                  
   WHEN SEGMENT ='CAPITAL' THEN FI.EXCHANGE + '-CASH'                                  
  WHEN SEGMENT ='FUTURES' THEN FI.EXCHANGE + '-F&O'                                  
   ELSE FI.EXCHANGE + '-' + SEGMENT                                  
  END,                                  
  SEGMENT,                                  
  PARTYNAME,                                  
  L_ADDRESS1,                                  
  L_ADDRESS2,                                  
  L_ADDRESS3,                                  
  L_CITY,                                  
  L_ZIP,                                  
  L_STATE,                                  
  L_NATION,                                  
  RES_PHONE,                                  
  OFF_PHONE,                                  
  EMAIL,                                  
  PAN_GIR_NO,                                  
  BRANCH_CD,                                  
  SUB_BROKER,                                  
  RPT_ORD,                                  
  SCRIP_CD,                                  
  SERIES,                                  
  SEC_CLRATE,                                  
  BGNO,                                  
  BG_EXPIRYDATE,                                  
  FDRNO,                                  
  FDR_EXPIRYDATE,                                  
  SCRIPNAME,                          
ISIN
 ORDER BY              
  BRANCH_CD,                                  
  SUB_BROKER,FI.PARTY_CODE,RPT_ORD,EXCHANGE,SEGMENT                      
                     
                     
                     
--PRINT @BOUNCEDFLAG                     
                    
                     
 IF  @BOUNCEDFLAG = 0                     
 BEGIN                     
---- PRINT 'SURESH'                                
SELECT * FROM #FINAL_REPORTNEW           
--WHERE (TOTAL_MARGIN <> 0 OR SEC_AMOUNT <> 0 )            
ORDER BY        
 BRANCH_CD,                                  
 SUB_BROKER,PARTY_CODE,RPT_ORD,EXCHANGE,SEGMENT                    
END                    
ELSE                    
BEGIN                     
 ----PRINT 'SURESH1'                     
                          
 CREATE TABLE #PARTY                                  
 (                                  
  PARTYCODE VARCHAR(15)                  
 )                                 
                               
  INSERT INTO #PARTY                                  
  SELECT DISTINCT PARTY_CODE FROM TBL_ECNBOUNCED WITH (NOLOCK) WHERE SDate BETWEEN @MDATE AND @MDATE + ' 23:59:59'                                  
                     
              
CREATE NONCLUSTERED INDEX [IND] ON [dbo].[#PARTY]                       
(                      
 [PARTYCODE] ASC                        
 )                 
               
SELECT * FROM #FINAL_REPORTNEW WHERE PARTY_CODE IN (SELECT PARTYCODE FROM #PARTY)             
--AND (TOTAL_MARGIN <> 0 OR SEC_AMOUNT <> 0 )  

ORDER BY       
BRANCH_CD, SUB_BROKER,PARTY_CODE,RPT_ORD,EXCHANGE,SEGMENT       
                 
END                                  
--WHERE (TOTAL_MARGIN <> 0 OR (SEC_AMOUNT <> 0 AND EXCHANGE NOT LIKE 'MCX-F&O%' AND EXCHANGE NOT LIKE 'NCX-F&O%'))

GO
