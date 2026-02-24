-- Object: PROCEDURE dbo.FUNDS_FLOW_NEW
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROCEDURE FUNDS_FLOW_NEW       
 @FROMDATE VARCHAR(11),                
 @TODATE VARCHAR(11),          
 @BRANCHCODE VARCHAR(10)                
AS                
                
DECLARE @@STARTDATE VARCHAR(11)                
                
SELECT @@STARTDATE = SDTCUR FROM PARAMETER WHERE @FROMDATE BETWEEN SDTCUR AND LDTCUR                
                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                  
SELECT BRANCH_CD = RTRIM(BRANCH_CD), VDT, NARRATION, AMOUNT = SUM(AMOUNT), SORTBY  FROM                
(                
 SELECT                             
  X.BRANCH_CD, VDT = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE), 103), NARRATION = 'NSE OPENING BALANCE', SORTBY = 1,                         
  AMOUNT = ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN -L.VAMT ELSE L.VAMT END),0)                              
 FROM LEDGER L JOIN                              
  (SELECT C2.PARTY_CODE, C1.BRANCH_CD, C1.CL_CODE FROM  MSAJAG.DBO.CLIENT2 C2 JOIN MSAJAG.DBO.CLIENT1 C1 ON (C1.CL_CODE = C2.CL_CODE ) ) X  ON (L.CLTCODE = X.PARTY_CODE)                              
 WHERE                             
  L.EDT >= CONVERT(DATETIME, @@STARTDATE,109)                              
  AND L.EDT < CONVERT(DATETIME, @FROMDATE,109)                        
  AND L.VAMT <> 0                            
  AND L.NARRATION NOT LIKE 'FUNDS TRANSFER%'          
  AND X.BRANCH_CD LIKE @BRANCHCODE          
 GROUP BY                            
  X.BRANCH_CD        
               
UNION ALL                
            
 SELECT                             
  X.BRANCH_CD, VDT = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE), 103),NARRATION = 'NSE OPENING BALANCE', SORTBY = 1,                    
  AMOUNT = ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN L.VAMT ELSE -L.VAMT END),0)                              
 FROM LEDGER L JOIN                              
  (SELECT C2.PARTY_CODE, C1.BRANCH_CD, C1.CL_CODE FROM  MSAJAG.DBO.CLIENT2 C2 JOIN MSAJAG.DBO.CLIENT1 C1 ON (C1.CL_CODE = C2.CL_CODE ) ) X  ON (L.CLTCODE = X.PARTY_CODE)                              
 WHERE                             
  L.EDT >= CONVERT(DATETIME, @@STARTDATE,109)                              
  AND L.VDT < CONVERT(DATETIME, @@STARTDATE,109)                              
  AND L.VAMT <> 0                            
  AND L.NARRATION NOT LIKE 'FUNDS TRANSFER%'             
  AND X.BRANCH_CD LIKE @BRANCHCODE                         
 GROUP BY                            
  X.BRANCH_CD       
                   
UNION ALL               
                         
 SELECT                             
  X.BRANCH_CD, VDT = CONVERT(VARCHAR(11), EDT, 103),NARRATION = 'NSE ' + L.NARRATION, SORTBY = 2,                         
  AMOUNT = ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN -L.VAMT ELSE L.VAMT END),0)                              
 FROM LEDGER L JOIN                              
  (SELECT C2.PARTY_CODE, C1.BRANCH_CD, C1.CL_CODE FROM  MSAJAG.DBO.CLIENT2 C2 JOIN MSAJAG.DBO.CLIENT1 C1 ON (C1.CL_CODE = C2.CL_CODE ) ) X  ON (L.CLTCODE = X.PARTY_CODE)                              
 WHERE                             
  L.VTYP <> 18             
  AND L.EDT >= CONVERT(DATETIME, @FROMDATE,109)                              
  AND L.EDT <= CONVERT(DATETIME, @TODATE + ' 23:59',109)                              
  AND L.VAMT <> 0                            
  AND L.NARRATION NOT LIKE 'FUNDS TRANSFER%'            
  AND X.BRANCH_CD LIKE @BRANCHCODE                     
 GROUP BY              
  X.BRANCH_CD, L.NARRATION, CONVERT(VARCHAR(11), EDT, 103)         
            
UNION ALL                
            
 SELECT                             
  X.BRANCH_CD, VDT = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE), 103),NARRATION = 'BSE OPENING BALANCE', SORTBY = 3,                          
  AMOUNT = ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN -L.VAMT ELSE L.VAMT END),0)                              
 FROM ACCOUNTBSE.DBO.LEDGER L JOIN                              
  (SELECT C2.PARTY_CODE, C1.BRANCH_CD, C1.CL_CODE FROM  BSEDB.DBO.CLIENT2 C2 JOIN BSEDB.DBO.CLIENT1 C1 ON (C1.CL_CODE = C2.CL_CODE ) ) X  ON (L.CLTCODE = X.PARTY_CODE)                              
 WHERE                      
  L.EDT >= CONVERT(DATETIME, @@STARTDATE,109)                      
  AND L.EDT < CONVERT(DATETIME, @FROMDATE,109)                        
  AND L.VAMT <> 0                            
  AND L.NARRATION NOT LIKE 'FUNDS TRANSFER%'             
  AND X.BRANCH_CD LIKE @BRANCHCODE                         
 GROUP BY                            
  X.BRANCH_CD         
            
UNION ALL                
            
 SELECT                             
  X.BRANCH_CD, VDT = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE), 103),NARRATION = 'BSE OPENING BALANCE', SORTBY = 3 ,                     
  AMOUNT = ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN L.VAMT ELSE -L.VAMT END),0)                              
 FROM ACCOUNTBSE.DBO.LEDGER L JOIN                              
  (SELECT C2.PARTY_CODE, C1.BRANCH_CD, C1.CL_CODE FROM  BSEDB.DBO.CLIENT2 C2 JOIN BSEDB.DBO.CLIENT1 C1 ON (C1.CL_CODE = C2.CL_CODE ) ) X  ON (L.CLTCODE = X.PARTY_CODE)                              
 WHERE                             
  L.EDT >= CONVERT(DATETIME, @@STARTDATE,109)                              
  AND L.VDT < CONVERT(DATETIME, @@STARTDATE,109)                              
  AND L.VAMT <> 0                            
  AND L.NARRATION NOT LIKE 'FUNDS TRANSFER%'            
  AND X.BRANCH_CD LIKE @BRANCHCODE                          
 GROUP BY                            
  X.BRANCH_CD , L.EDT              
                   
UNION ALL             
                           
 SELECT                             
  X.BRANCH_CD, VDT = CONVERT(VARCHAR(11), EDT, 103),NARRATION = 'BSE ' + L.NARRATION, SORTBY = 4,                         
  AMOUNT = ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN -L.VAMT ELSE L.VAMT END),0)                              
 FROM ACCOUNTBSE.DBO.LEDGER L JOIN                              
  (SELECT C2.PARTY_CODE, C1.BRANCH_CD, C1.CL_CODE FROM  BSEDB.DBO.CLIENT2 C2 JOIN BSEDB.DBO.CLIENT1 C1 ON (C1.CL_CODE = C2.CL_CODE ) ) X  ON (L.CLTCODE = X.PARTY_CODE)                              
 WHERE                             
  L.VTYP <> 18             
  AND L.EDT >= CONVERT(DATETIME, @FROMDATE,109)                              
  AND L.EDT <= CONVERT(DATETIME, @TODATE + ' 23:59',109)                              
  AND L.VAMT <> 0                            
  AND L.NARRATION NOT LIKE 'FUNDS TRANSFER%'                     
  AND X.BRANCH_CD LIKE @BRANCHCODE            
 GROUP BY              
  X.BRANCH_CD, L.NARRATION, CONVERT(VARCHAR(11), EDT, 103)         
               
) A                
GROUP BY                
 RTRIM(BRANCH_CD), NARRATION, SORTBY, VDT                
ORDER BY                 
 BRANCH_CD,CONVERT(DATETIME, VDT, 103) , SORTBY, NARRATION

GO
