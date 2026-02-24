-- Object: PROCEDURE dbo.CONTRACT_CONTROL_SHEET_COMM
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
    
    
    
    
CREATE PROC [DBO].[CONTRACT_CONTROL_SHEET_COMM]                          
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
 CLIENT_BROK_DETAILS A (NOLOCK),                          
 COMMON_CONTRACT_DATA B (NOLOCK) ,                          
 [AngelBSECM].BSEDB_AB.DBO.BRANCHGROUP C (NOLOCK)                
 WHERE                          
 A.CL_CODE = B.PARTY_CODE                          
 AND B.BRANCH_CD = C.BRANCH_CODE                         
 AND BRANCH_CD >= @FROMBRANCH                                   
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
 AND A.PRINT_OPTIONS <> '0'                      
 AND C.BRANCH_GROUP = 'MUM'                     
                       
END      
                          
                          
IF @PRINTOPTIONS='NONECN' OR @PRINTOPTIONS='ALL'                          
BEGIN                          
PRINT @PRINTOPTIONS             
                      
SELECT DISTINCT CL_CODE into #CL              
 FROM CLIENT_BROK_DETAILS (NOLOCK) WHERE PRINT_OPTIONS = 0  AND CL_CODE IN              
  (SELECT CL_CODE FROM CLIENT_DETAILS (NOLOCK)               
  WHERE REGION = 'MUMBAI' AND CL_CODE NOT LIKE '98%' and BRANCH_CD NOT IN ('YD') and Inactive_from >= @FROMDATE )              
                
---               
               
SELECT DISTINCT PARTY_CODE INTO #RPT              
 FROM COMMON_CONTRACT_DATA (NOLOCK)               
 WHERE SAUDA_DATE LIKE @FROMDATE +'%'              
  AND PARTY_CODE in              
  (Select * from #CL)                
  ORDER BY PARTY_CODE              
               
  -- DROP TABLE #MAR              
                
  INSERT INTO #RPT               
  SELECT DISTINCT PARTY_CODE FROM TBL_MAR_REPORT (NOLOCK)               
  WHERE TRADE_DAY LIKE @FROMDATE +'%' AND PARTY_CODE IN               
  (Select * from #CL)                
  --AND repatriat_bank_ac_no NOT LIKE 'ecn%')              
  GROUP BY PARTY_CODE               
  HAVING SUM(INIT_MARGIN+ADD_MARGIN) > 0               
                
  ---              
  INSERT INTO [#CON]              
  SELECT CL_CODE,long_name as PARTYNAME,BRANCH_CD,SUB_BROKER,BRANCH_GROUP  FROM CLIENT_DETAILS AS A,[AngelBSECM].BSEDB_AB.DBO.BRANCHGROUP C (NOLOCK)  WHERE CL_CODE IN              
  (SELECT DISTINCT PARTY_CODE FROM #RPT ) AND REGION = 'MUMBAI' AND CL_CODE NOT LIKE '98%'  AND C.BRANCH_GROUP = 'MUM'            
    AND A.BRANCH_CD = C.BRANCH_CODE              
   ORDER BY CL_CODE,PARTYNAME,BRANCH_CD,SUB_BROKER,BRANCH_GROUP             
              
DROP TABLE   #RPT                
DROP TABLE #CL               
                    
END                          
                          
                          
IF @PRINTOPTIONS='ALL'                          
BEGIN                          
 SELECT * FROM #CON                          
                    
END                          
ELSE                          
BEGIN                          
 SELECT  DISTINCT                      
 *                   
 FROM #CON                         
                        
END                          
DROP TABLE [#CON]

GO
