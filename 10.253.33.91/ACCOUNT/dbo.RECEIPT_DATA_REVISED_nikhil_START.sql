-- Object: PROCEDURE dbo.RECEIPT_DATA_REVISED_nikhil_START
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

                                                                                                    
CREATE PROC [dbo].[RECEIPT_DATA_REVISED_nikhil_START]                                                                                                                                  
(                                                           
                                                                                                                                 
@FROMDATE varchar(11) ,                                                                                                                                  
@TODATE   varchar(11)                                                            
                                                                                                                                                                                                
)                                                                                                                                  
AS                                                                                                                                   
                                                          
IF LEN(@FROMDATE) = 10 AND CHARINDEX('/', @FROMDATE) > 0                                                          
                                                                                                              
BEGIN                                                                 
                                                                                                       
SET @FROMDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE, 103), 109)                                                            
                                                                                                            
END                                                              
                                                                                                          
IF LEN(@TODATE) = 10 AND CHARINDEX('/', @TODATE) > 0                                                           
                                                                                                             
BEGIN                                                           
                                                                                                             
SET @TODATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TODATE, 103), 109)                                                            
                                                                                                            
END                                                                                                              
                                                          
print @FROMDATE                                                                                                              
                                                          
BEGIN                                                                                                                                   
SELECT  * INTO #TEMP FROM                                                           
(                                                                                                                                  
SELECT                                                                                                                                  
CLTCODE,                                                                                                                                  
L.VDT,                                                                                                                                  
L.VNO,                                                                                                                        
REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                          
L.VAMT,                
L.DRCR,                                                     
L1.DDNO,                                                  
L.VTYP,                     
L1.RELDT,                                                 
L.BOOKTYPE,                                                                                               
'NSE' AS EXCHANGE                                                     
FROM LEDGER L (NOLOCK) , LEDGER1 L1 (NOLOCK)                               
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                                                      
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                   
                                                          
UNION ALL                                                                                                                      
                                           
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                                                          
L.VTYP,L1.RELDT,L.BOOKTYPE,'NSE'                                                                                                               
FROM LEDGER L(NOLOCK), LEDGER1 L1 (NOLOCK)                                                                                                                                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                                              
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                
                                                          
----BSE-----                                                                                    
UNION ALL                                                           
                                                                                                                        
SELECT                                                                                                                                  
CLTCODE,                                                                                                      
L.VDT,                                                                                                                         
L.VNO,                                                                                                                        
REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                                                                                                                  
L.VAMT,                                                                                                                                  
L.DRCR,                                                                                                                                  
L1.DDNO,                                                                                                           
L.VTYP,                                                                                                                                  
L1.RELDT,                                                                                         
L.BOOKTYPE,                                                                                                                        
'BSE' AS EXCHANGE                                                                                                                                 
FROM ANAND.ACCOUNT_AB.DBO.LEDGER L (NOLOCK) , ANAND.ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)                                                                                                                                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                           
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                                        
                                                          
UNION ALL                                                                     
                                                          
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                                                           
L.VTYP,L1.RELDT,L.BOOKTYPE,'BSE' AS EXCHANGE                                                                                                      
FROM ANAND.ACCOUNT_AB.DBO.LEDGER L(NOLOCK),ANAND.ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)                                                           
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                     
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                  
                                                          
----NSEFO------                                                                                                                        
UNION ALL                                                       
                                                                                                                        
SELECT                                                                                                     
CLTCODE,                                       
L.VDT,                                                                            
L.VNO,                                                                                                                        
REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                                                                                          
L.VAMT,                                                            
L.DRCR,                                                                                                                 
L1.DDNO,                                                                        
L.VTYP,                                                                                  
L1.RELDT,                                                                                                                                  
L.BOOKTYPE,                                                                                                                   
'NSEFO' AS EXCHANGE                                                                                                         
FROM ANGELFO.ACCOUNTFO.DBO.LEDGER L (NOLOCK) , ANGELFO.ACCOUNTFO.DBO.LEDGER1 L1 (NOLOCK)                                                                                                
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                                                                          
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                               
                                                          
UNION ALL                                                                                                                                  
                                                          
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                                                                                                                  
L.VTYP,L1.RELDT,L.BOOKTYPE,'NSEFO' AS EXCHANGE                                                                            
FROM ANGELFO.ACCOUNTFO.DBO.LEDGER L(NOLOCK),ANGELFO.ACCOUNTFO.DBO.LEDGER1 L1 (NOLOCK)                                                                               
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                                                      
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                                                         
                           
--NSECURFO                                                                  
                                                          
UNION ALL                                                           
                                                                  
SELECT                                                                        
CLTCODE,                                                                                  
L.VDT,                       
L.VNO,                                                                                                                        
REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                                                
L.VAMT,                                                                                          
L.DRCR,                                                                                                                                  
L1.DDNO,                                                                                                                                  
L.VTYP,                                                                                                        
L1.RELDT,                                                                 
L.BOOKTYPE,                                                                                                   
'NSECURFO' AS EXCHANGE                                                                                                                                  
FROM ANGELFO.ACCOUNTCURFO.DBO.LEDGER L (NOLOCK) , ANGELFO.ACCOUNTCURFO.DBO.LEDGER1 L1 (NOLOCK)                                                                                                                                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                                                                          
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                                                           
                                                          
UNION ALL                                                      
                                                          
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                                                    
L.VTYP,L1.RELDT,L.BOOKTYPE,'NSECURFO' AS EXCHANGE                                                                                                                                  
FROM ANGELFO.ACCOUNTCURFO.DBO.LEDGER L(NOLOCK),ANGELFO.ACCOUNTCURFO.DBO.LEDGER1 L1 (NOLOCK)                                                                                              
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                   
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                                                         
                                                          
--MCDX----               
                                                 
UNION ALL       
SELECT                   
CLTCODE,                                                                      
L.VDT,                                     
L.VNO,                                                                                                                  
REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                                                                        
L.VAMT,                                                                                                                                  
L.DRCR,                                                                                       
L1.DDNO,                                                                                       
L.VTYP,                                                                                                                                  
L1.RELDT,                                                                  
L.BOOKTYPE,                                                  
'MCDX' AS EXCHANGE                                                                                        FROM ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L (NOLOCK) , ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK)                                          
  
    
      
        
          
            
              
                
                  
                                                    
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                                 
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                           
                                                          
UNION ALL                                                                                                                                  
                                                          
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                                                                                                                  
L.VTYP,L1.RELDT,L.BOOKTYPE,'MCDX' AS EXCHANGE                                                                                                                                  
FROM ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L(NOLOCK),ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK)                                                                                                                                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                                                                                  
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                             
                                                          
--MCDXCDS----                                                                                                                        
                                                 
UNION ALL                                                                                                            
SELECT                                                                                                                                  
CLTCODE,                                                                     
L.VDT,                                                                                                                                  
L.VNO,                                                                                                                        
REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                   
L.VAMT,                                                                                                 
L.DRCR,                                                       
L1.DDNO,                                                                                                    
L.VTYP,                                                          
L1.RELDT,                                                            
L.BOOKTYPE,                                                                                                                      
'MCDXCDS' AS EXCHANGE                                                                                                           
FROM ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER L (NOLOCK) , ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK)                                    
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                       
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                              
                                                          
UNION ALL                                                                                                                 
                       
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                                                                                
L.VTYP,L1.RELDT,L.BOOKTYPE,'MCDXCDS' AS EXCHANGE                                                                                                                                  
FROM ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER L(NOLOCK),ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK)                                                                                                               
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                               
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                             
                                                          
--NCDX----                                                                                                        
                                                          
UNION ALL                                                                              
SELECT                                                                                 
CLTCODE,                                                                                                                                  
L.VDT,                                    
L.VNO,                                                                                                             
REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                               
L.VAMT,                                                                                                                
L.DRCR,                                                                                                                            
L1.DDNO,                                                                                                      
L.VTYP,                                                                                                                                  
L1.RELDT,                                                                                                                                  
L.BOOKTYPE,                                                                                                                        
'NCDX' AS EXCHANGE                                                                                                                                 
FROM ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER L (NOLOCK) , ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER1 L1 (NOLOCK)                                                                                                          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                        
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                
                                                          
UNION ALL                                                                                                                            
                                                          
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                                                  
L.VTYP,L1.RELDT,L.BOOKTYPE,'NCDX' AS EXCHANGE                                                
FROM ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER L(NOLOCK),ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER1 L1 (NOLOCK)                                                                                               
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                            
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                                                           
                                                          
)A                                                                                                       
                                                          
                    
-- CREATE CLUSTERED INDEX IDX_CL ON #TEMP                                                                                                                    
--(                                                                                                                    
-- CLTCODE ,VDT                                                                                                  
--)                                                         
                                                                                                                 
 UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'*','')                                                                      
where narration like '%*%'                                       
                                  
 UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,';','')                                                                      
where narration like '%;%'                                                                                       
                                                          
 UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'/','')                                                                                                        
where narration like '%/%'                                                            
                                                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'|',' ')                                                                                             
where narration like '%|%'                                                                                    
                                                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,':','')                                                                                                        
where narration like '%:%'                                                                                   
                                                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'.','')                                       
where narration like '%.%'    
                                                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'_',' ')                                                        
where narration like '%_%'             
                                                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'-',' ')                       
where narration like '%-%'                                                                                                   
                                                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,')',' ')                                                                   
where narration like '%)%'                                                                                                        
                                                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'(',' ')                                    
where narration like '%(%'                                                                                                        
                                                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'&',' ')                         
where narration like '%&%'                                                                                             
                                                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'#',' ')                                                                                              
where narration like '%#%'                                                                                                        
                                                      
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,',',' ')                                                                                                        
where narration like '%,%'                                                                                                      
                                                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,':-',' ')                                                                                        
where narration like '%:-%'                                                            
                                                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'%', '')                                                                                                        
where narration like '%%%'                                                        
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'?', '')                                                                                                  
where narration like '%?%'                                                                           
                                                          
UPDATE #TEMP SET DDNO = REPLACE(DDNO,'|','')                                                                                              
where DDNO like '%|%'                                                             
UPDATE #TEMP SET DDNO = REPLACE(DDNO,',','')                                                        
where DDNO like '%,%'                                                                       
                                                          
--update #TEMP set ddno=REPLACE(DDNO,'','0')                                                                        
--update #TEMP set ddno=REPLACE(DDNO,'A','4')                                               
--update #TEMP set ddno=REPLACE(DDNO,'','/')                                                                        
--update #TEMP set ddno=REPLACE(DDNO,'O','0')                                                                        
                                               
--update #TEMP set ddno=REPLACE(DDNO,' ','')                                                                        
--update #TEMP set ddno=REPLACE(DDNO,'A','4')                                                                        
--update #TEMP set ddno=REPLACE(DDNO,'','/')                                                                        
--update #TEMP set ddno=REPLACE(DDNO,'O','0')                                           
                                                          
                                                          
                                                    
--SELECT                                                                                           
--[EXCHANGE] = REPLACE(LTRIM(RTRIM(A.EXCHANGE)), ' ', '') ,                                                          
--[CLTCODE] = REPLACE(LTRIM(RTRIM(A.CLTCODE)), ' ', ''),                                              
--CONVERT(VARCHAR(11), CONVERT(DATETIME, A.vdt, 103), 103) as VDT,                                                                                                                                   
--[VNO] = REPLACE(LTRIM(RTRIM(A.vno)), ' ', ''),                                                                              
--LEFT(REPLACE(REPLACE(REPLACE(A.NARRATION,'''',''),'""',''),'"',''),500) AS NARRATION,                                                                                                                                                                       
  
    
      
        
          
            
             
--[VAMT] = REPLACE(LTRIM(RTRIM(A.vamt)), ' ', ''),                                                                                  
--[DRCR] = REPLACE(LTRIM(RTRIM(A.DRCR)), ' ', ''),                                                                                      
--REPLACE(REPLACE(REPLACE(A.DDNO,',',''),'.',''),'''','') AS DDNO,                   
--[VTYP] = A.vtyp,                                                                                                                       
--CONVERT(VARCHAR(11), CONVERT(DATETIME, A.reldt, 103), 103) as RELDT,                                                                                                                                                               
--LTRIM(A.BOOKTYPE) AS BOOKTYPE ,                                     
--[SHORT_NAME] = REPLACE(LTRIM(RTRIM(B.SHORT_NAME)), ' ', ''),                                                                                                     
--[REGION] = REPLACE(LTRIM(RTRIM(B.REGION)), ' ', ''),                                                                   
--[BRANCH_CD] = REPLACE(LTRIM(RTRIM(B.BRANCH_CD)), ' ', ''),                                                                                                                     
--[SUB_BROKER] = REPLACE(LTRIM(RTRIM(B.SUB_BROKER)), ' ', '') ,                                                                                                                              
--REPLACE(REPLACE(REPLACE(B.BANK_NAME,'''',''),'""',''),',','') AS BANK_NAME,                                                                                                                             
--LTRIM(B.AC_NUM)AS AC_NUM                                                                        
--FROM #TEMP AS A LEFT OUTER JOIN                                                                            
--MSAJAG.DBO.CLIENT_DETAILS AS B ON A.CLTCODE = B.CL_CODE                                                              
--where                                                       
----CLTCODE IN ('H34399','ZR418')                   --ORDER BY EXCHANGE                                                          
                                                      
                                                      
SELECT                                                                                                                      
--[CLTCODE] = REPLACE(LTRIM(RTRIM(A.CLTCODE)), ' ', ''),                                                      
[CLTCODE]=left(REPLACE(LTRIM(RTRIM(A.CLTCODE)), '"', ''),100),                                       
CONVERT(VARCHAR(11), CONVERT(DATETIME, A.vdt, 103), 103) as VDT,                                                                                                           
[VNO]=REPLACE(LTRIM(RTRIM(A.vno)), ' ', ''),                                    
LEFT(REPLACE(REPLACE(REPLACE(A.NARRATION,'''',''),'""',''),'"',''),500) AS NARRATION,                                                                                                                                                                         
   
    
      
       
--LEFT(REPLACE(REPLACE(REPLACE(REPLACE(A.NARRATION,'''',''),'""',''),'"',''),'?',''),500) AS NARRATION,                                                 
LEFT(REPLACE(REPLACE(REPLACE(A.EXCHANGE,'''',''),'""',''),'"',''),100) AS EXCHANGE,                                                                               
--[EXCHANGE] = REPLACE(LTRIM(RTRIM(A.EXCHANGE)), '', '') ,                                                                                            
[VAMT]=REPLACE(LTRIM(RTRIM(A.vamt)), ' ', ''),                                                                                                        
[DRCR]=REPLACE(LTRIM(RTRIM(A.DRCR)), ' ', ''),                                                                                      
REPLACE(REPLACE(REPLACE(A.DDNO,',',''),'.',''),'''','') AS DDNO,                                                    
[VTYP]=REPLACE(LTRIM(RTRIM(A.vtyp)), ' ', ''),                                                                                           
CONVERT(VARCHAR(11), CONVERT(DATETIME, A.reldt, 103), 103) as RELDT,                                                 
[BOOKTYPE]=REPLACE(LTRIM(RTRIM(A.BOOKTYPE)), ' ', '')             
--[SHORT_NAME]=REPLACE(LTRIM(RTRIM(B.SHORT_NAME)), ' ', ''),                                                                         
--[REGION]=REPLACE(LTRIM(RTRIM(B.REGION)), ' ', ''),                                                                                                      
--[BRANCH_CD]=REPLACE(LTRIM(RTRIM(B.BRANCH_CD)), ' ', ''),                                                                                               
--[SUB_BROKER]=REPLACE(LTRIM(RTRIM(B.SUB_BROKER)), ' ', '') ,                                                                                                  
----left(REPLACE(LTRIM(RTRIM(B.BANK_NAME)), '"', ''),100) AS BANK_NAME ,                                                  
--REPLACE(REPLACE(REPLACE(B.BANK_NAME,'''',''),'""',''),',','') AS BANK_NAME,                 
--[AC_NUM]=REPLACE(LTRIM(RTRIM(B.AC_NUM)), ' ', '')                                                                   
                                                                                                                                  
FROM #TEMP AS A LEFT OUTER JOIN                        
                                                                                                    
MSAJAG.DBO.CLIENT_DETAILS AS B ON A.CLTCODE = B.CL_CODE                                                       
WHERE                                                       
--CLTCODE LIKE '%L5000%'                                              
----('3014','5100000002')                                                      
--ddno='104328'                                                      
--and vno='201500180049'                          
 --NARRATION   LIKE 'AMT RECD AGAINST CHQ NO%' and EXCHANGE  IN ('NSE' )                                     
 --AND       
 --cltcode  IN ('02086','05016')                                                  
                                                      
NARRATION   LIKE '%BEING AMT RECEIVED BY ONLINE TRF%'                                                             
                                                                             
ORDER BY EXCHANGE                                                                         
                                   
END                                                            
                                                          
--RECEIPT_DATA_REVISED_nikhil_START '11/12/2015','18/12/2015'                                            
                                          
--RECEIPT_DATA_REVISED_nikhil '24/11/2015','03/12/2015'                                                      
       
--select * from [AngelBSECM].account_ab.dbo.ledger1 nolock where vno='201500131783'

GO
