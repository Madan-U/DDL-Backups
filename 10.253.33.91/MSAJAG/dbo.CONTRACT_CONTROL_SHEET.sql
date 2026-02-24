-- Object: PROCEDURE dbo.CONTRACT_CONTROL_SHEET
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[CONTRACT_CONTROL_SHEET]                        
(                          
  @FROMDATE VARCHAR(11),                          
  @TODATE VARCHAR(11),                          
  @FROMBRANCH VARCHAR(10),                                 
  @TOBRANCH VARCHAR(10),                         
  @FROMBRANCHGROUP VARCHAR(10),                          
  @TOBRANCHGROUP VARCHAR(10),                    
  @STATUSID VARCHAR(15),                          
  @STATUSNAME VARCHAR(25),                        
  @PRINTOPTIONS VARCHAR(25)                        
 )                         
 AS                         
                       
                       
IF @FROMBRANCH='ALL' BEGIN SET @FROMBRANCH='' END                              
IF @TOBRANCH='' OR  @TOBRANCH='ALL' BEGIN SET @TOBRANCH='ZZZZZZZ' END                              
IF @TODATE = ''                   
IF @FROMBRANCHGROUP='' BEGIN SET @TOBRANCHGROUP='ZZZZZZZ' END                                      
BEGIN                                    
 SET @TODATE = @FROMDATE                                    
END                         
--EXEC CONTRACT_CONTROL_SHEET 'JUN 17 2009', 'JUN 17 2014', '00', 'ZZZZ', 'ALL', 'ALL', 'BROKER', 'BROKER', 'ALL'                         
                           
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                         
                        
                        
CREATE TABLE [#CON](                    
 [PARTY CODE] [CHAR](10) NOT NULL,    
 [PARTY NAME] [VARCHAR] (100) NULL,                     
 [BRANCH] [VARCHAR](10) NULL,                        
 [SUBBROKER] [VARCHAR](10) NULL,                  
 [BRANCHGROUP] [VARCHAR](10) NULL                  
 )                         
                             
IF @PRINTOPTIONS='ECN' OR @PRINTOPTIONS='ALL'                        
BEGIN                        
PRINT @PRINTOPTIONS                        
INSERT INTO                        
[#CON]                        
SELECT  DISTINCT                      
 [PARTY CODE] = B.PARTY_CODE,     
 [PARTY NAME] = B.PARTYNAME,                       
 [BRANCH] = B.BRANCH_CD,                       
 [SUBBROKER] = B.SUB_BROKER,                  
 [BRANCHGROUP] = C.BRANCH_GROUP                  
FROM                        
 COMMON_CONTRACT_DATA B (NOLOCK)                        
 left ouTER JOIN   
 [AngelBSECM].BSEDB_AB.DBO.BRANCHGROUP C (NOLOCK) on   B.BRANCH_CD = C.BRANCH_CODE                                  
 WHERE                        
  
  BRANCH_CD >= @FROMBRANCH                                 
    AND BRANCH_CD <= @TOBRANCH               
    AND B.SAUDA_DATE >= @FROMDATE AND b.SAUDA_DATE < =@TODATE + ' 23:59:59'                                   
    AND @STATUSNAME = (                              
     CASE                              
             WHEN @STATUSID = 'BRANCH'                                 
             THEN B.BRANCH_CD                                 
             WHEN @STATUSID = 'SUBBROKER'                                 
             THEN B.SUB_BROKER                                 
             WHEN @STATUSID = 'TRADER'                                 
             THEN B.TRADER                                 
             WHEN @STATUSID = 'FAMILY'                                 
             THEN B.FAMILY                                 
             WHEN @STATUSID = 'AREA'                                 
             THEN B.AREA                                 
             WHEN @STATUSID = 'REGION'                                 
             THEN B.REGION                                 
             WHEN @STATUSID = 'CLIENT'                                 
             THEN B.PARTY_CODE                              
             ELSE 'BROKER'                               
 END)                     
 AND PRINTF <> '0'                    
                  
                     
END                        
                        
                        
IF @PRINTOPTIONS='NONECN' OR @PRINTOPTIONS='ALL'                        
BEGIN            
PRINT @PRINTOPTIONS           
                    
SELECT DISTINCT CL_CODE into #CL            
 FROM CLIENT_BROK_DETAILS (NOLOCK) WHERE PRINT_OPTIONS IN ( 0,5) AND EXCHANGE NOT IN ('MCX','NCX')     
 AND CL_CODE IN            
  (SELECT CL_CODE FROM CLIENT_DETAILS (NOLOCK)             
  WHERE CL_CODE NOT LIKE '98%' and Inactive_from >= @FROMDATE )      
  
SELECT DISTINCT CL_CODE into #CLt            
 FROM CLIENT_BROK_DETAILS (NOLOCK) WHERE PRINT_OPTIONS IN ( 0,5) AND EXCHANGE IN ('MCX','NCX')     
 AND CL_CODE IN            
  (SELECT CL_CODE FROM CLIENT_DETAILS (NOLOCK)             
  WHERE CL_CODE NOT LIKE '98%' and Inactive_from >= @FROMDATE )     
      
  CREATE NONCLUSTERED INDEX #CL1 ON #CL    
  (CL_CODE ASC)    
  
    CREATE NONCLUSTERED INDEX #CLr1 ON #CLt    
  (CL_CODE ASC)    
  
---             
SELECT DISTINCT PARTY_CODE INTO #RPT            
 FROM COMMON_CONTRACT_DATA (NOLOCK)             
 WHERE SAUDA_DATE >= @FROMDATE AND SAUDA_DATE < =@TODATE + ' 23:59:59'    
  AND PARTY_CODE in            
  (Select * from #CL)              
  ORDER BY PARTY_CODE            
             
  -- DROP TABLE #MAR       
  -----------COMMODITIES    
  INSERT INTO #RPT     
  SELECT DISTINCT PARTY_CODE            
 FROM ANGELCOMMODITY.MCDX.DBO.CONTRACT_DATA WITH(NOLOCK)             
 WHERE SAUDA_DATE >= @FROMDATE AND SAUDA_DATE < =@TODATE + ' 23:59:59'    
  AND PARTY_CODE in            
  (Select * from #CLt)              
  ORDER BY PARTY_CODE      
      
  INSERT INTO #RPT     
 SELECT DISTINCT PARTY_CODE            
 FROM ANGELCOMMODITY.NCDX.DBO.CONTRACT_DATA WITH(NOLOCK)             
 WHERE SAUDA_DATE >= @FROMDATE AND SAUDA_DATE < =@TODATE + ' 23:59:59'    
  AND PARTY_CODE in            
  (Select * from #CLt)              
  ORDER BY PARTY_CODE     
     
           
              
  INSERT INTO #RPT             
  SELECT DISTINCT PARTY_CODE FROM TBL_MAR_REPORT (NOLOCK)             
  WHERE TRADE_DAY >= @FROMDATE AND TRADE_DAY<= @FROMDATE +' 23:59' AND PARTY_CODE IN             
  (Select * from #CL)              
  --AND repatriat_bank_ac_no NOT LIKE 'ecn%')            
  GROUP BY PARTY_CODE             
  HAVING SUM(INIT_MARGIN+ADD_MARGIN) > 0        
      
  INSERT INTO #RPT             
  SELECT DISTINCT PARTY_CODE FROM ANGELCOMMODITY.MCDX.DBO.TBL_MAR_REPORT WITH(NOLOCK)             
  WHERE TRADE_DAY >= @FROMDATE AND TRADE_DAY<= @FROMDATE +' 23:59' AND PARTY_CODE IN             
  (Select * from #CLt)              
  --AND repatriat_bank_ac_no NOT LIKE 'ecn%')            
  GROUP BY PARTY_CODE             
  HAVING SUM(INIT_MARGIN+ADD_MARGIN) > 0       
      
      
  CREATE NONCLUSTERED INDEX #RP1 ON #RPT    
  ( PARTY_CODE ASC)    
           
              
  ---            
  INSERT INTO [#CON]            
  SELECT CL_CODE,long_name as PARTYNAME,BRANCH_CD,SUB_BROKER,BRANCH_GROUP  FROM CLIENT_DETAILS AS A  
  LEFT OUTER JOIN   
  [AngelBSECM].BSEDB_AB.DBO.BRANCHGROUP C (NOLOCK) ON A.BRANCH_CD = C.BRANCH_CODE    
   WHERE CL_CODE IN            
  (SELECT DISTINCT PARTY_CODE FROM #RPT ) AND  CL_CODE NOT LIKE '98%'            
              
   ORDER BY CL_CODE,PARTYNAME,BRANCH_CD,SUB_BROKER,BRANCH_GROUP           
            
DROP TABLE   #RPT              
DROP TABLE #CL             
                  
END                        
                        
                        
IF @PRINTOPTIONS='ALL'                        
BEGIN                        
 SELECT * FROM #CON   ORDER BY BRANCHGROUP ,BRANCH, [PARTY CODE]                 
                  
END                        
ELSE                        
BEGIN                        
 SELECT  DISTINCT                    
 *                 
 FROM #CON     ORDER BY BRANCHGROUP ,BRANCH, [PARTY CODE]                      
                      
END                        
DROP TABLE [#CON]

GO
