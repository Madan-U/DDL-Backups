-- Object: PROCEDURE dbo.RECEIPT_DATA_REVISED_nikhil_PO
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

                                                              
CREATE PROC [dbo].[RECEIPT_DATA_REVISED_nikhil_PO]                                                                                            
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
AND L.DRCR ='D' AND L.VTYP IN (2,3) AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                     
                    
UNION ALL                                                                                            
     
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                    
L.VTYP,L1.RELDT,L.BOOKTYPE,'NSE'                                                                         
FROM LEDGER L(NOLOCK), LEDGER1 L1 (NOLOCK)                                                                                            
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                        
AND L.DRCR ='C' AND L.VTYP IN (2,3)  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                          
                    
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
AND L.DRCR ='D' AND L.VTYP IN (2,3) AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                
                    
UNION ALL                                                                                            
                    
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                                                                            
L.VTYP,L1.RELDT,L.BOOKTYPE,'BSE' AS EXCHANGE                                                                                            
FROM ANAND.ACCOUNT_AB.DBO.LEDGER L(NOLOCK),ANAND.ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)                                                                                            
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                                          
AND L.DRCR ='C' AND L.VTYP IN (2,3)  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                     
                    
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
AND L.DRCR ='D' AND L.VTYP IN (2,3) AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                         
                    
UNION ALL                                                                                            
                    
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                                                                            
L.VTYP,L1.RELDT,L.BOOKTYPE,'NSEFO' AS EXCHANGE                                                                                            
FROM ANGELFO.ACCOUNTFO.DBO.LEDGER L(NOLOCK),ANGELFO.ACCOUNTFO.DBO.LEDGER1 L1 (NOLOCK)                                                                           
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                
AND L.DRCR ='C' AND L.VTYP IN (2,3)  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                   
                    
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
AND L.DRCR ='D' AND L.VTYP IN (2,3) AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                     
                    
UNION ALL                
                    
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                              
L.VTYP,L1.RELDT,L.BOOKTYPE,'NSECURFO' AS EXCHANGE                                                                                            
FROM ANGELFO.ACCOUNTCURFO.DBO.LEDGER L(NOLOCK),ANGELFO.ACCOUNTCURFO.DBO.LEDGER1 L1 (NOLOCK)                                                        
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE             
AND L.DRCR ='C' AND L.VTYP IN (2,3)  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                   
                    
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
'MCDX' AS EXCHANGE                                                                    
FROM ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L (NOLOCK) , ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK)                                                                                            
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                           
AND L.DRCR ='D' AND L.VTYP IN (2,3) AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                     
                    
UNION ALL                                                                                            
                    
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                                                                            
L.VTYP,L1.RELDT,L.BOOKTYPE,'MCDX' AS EXCHANGE                                                                                            
FROM ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L(NOLOCK),ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK)                                                                                            
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                                            
AND L.DRCR ='C' AND L.VTYP IN (2,3)  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                       
                    
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
AND L.DRCR ='D' AND L.VTYP IN (2,3) AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                        
                    
UNION ALL                                                                                            
                    
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                                          
L.VTYP,L1.RELDT,L.BOOKTYPE,'MCDXCDS' AS EXCHANGE                                                                                            
FROM ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER L(NOLOCK),ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK)                                                                         
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                         
AND L.DRCR ='C' AND L.VTYP IN (2,3)  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                     
                    
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
AND L.DRCR ='D' AND L.VTYP IN (2,3) AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                          
                    
UNION ALL                                                                                            
                    
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                                                             
L.VTYP,L1.RELDT,L.BOOKTYPE,'NCDX' AS EXCHANGE          
FROM ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER L(NOLOCK),ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER1 L1 (NOLOCK)                                                                                            
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                 
AND L.DRCR ='C' AND L.VTYP IN (2,3)  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                                                                     
                    
)A                                                                                                                                                       
                    
SELECT                                                     
[EXCHANGE] = REPLACE(LTRIM(RTRIM(A.EXCHANGE)), ' ', '') ,                    
[CLTCODE] = REPLACE(LTRIM(RTRIM(A.CLTCODE)), ' ', ''),                                                                                  
CONVERT(VARCHAR(11), CONVERT(DATETIME, A.vdt, 103), 103) as VDT,                                                                                             
[VNO] = REPLACE(LTRIM(RTRIM(A.vno)), ' ', ''),                                        
LEFT(REPLACE(REPLACE(REPLACE(A.NARRATION,'''',''),'""',''),'"',''),500) AS NARRATION,                                                                                                                                              
[VAMT] = REPLACE(LTRIM(RTRIM(A.vamt)), ' ', ''),                                                                                             
[DRCR] = REPLACE(LTRIM(RTRIM(A.DRCR)), ' ', ''),                                                
REPLACE(REPLACE(REPLACE(A.DDNO,',',''),'.',''),'''','') AS DDNO, 
(case when VTYP='2' THEN 'PAYIN' ELSE 'PAYOUT' END) AS TYPE,                                                                
[VTYP] = A.vtyp,                                                                                 
CONVERT(VARCHAR(11), CONVERT(DATETIME, A.reldt, 103), 103) as RELDT,                                                                                                                         
LTRIM(A.BOOKTYPE) AS BOOKTYPE ,                                                                                          
[SHORT_NAME] = REPLACE(LTRIM(RTRIM(B.SHORT_NAME)), ' ', ''),                                                               
[REGION] = REPLACE(LTRIM(RTRIM(B.REGION)), ' ', ''),                                                                                            
[BRANCH_CD] = REPLACE(LTRIM(RTRIM(B.BRANCH_CD)), ' ', ''),                                                                               
[SUB_BROKER] = REPLACE(LTRIM(RTRIM(B.SUB_BROKER)), ' ', '') ,                                                                                        
REPLACE(REPLACE(REPLACE(B.BANK_NAME,'''',''),'""',''),',','') AS BANK_NAME,                                                                                       
LTRIM(B.AC_NUM)AS AC_NUM                                  
FROM #TEMP AS A LEFT OUTER JOIN                                      
MSAJAG.DBO.CLIENT_DETAILS AS B ON A.CLTCODE = B.CL_CODE    
WHERE CLTCODE IN ('PTA20300',
'PTA20301',
'PTA20302',
'PTA20303',
'PTA20304',
'PTA20306',
'PTA20311',
'PTA20312',
'PTA20314',
'PTA20315',
'PTA20316',
'PTA20317',
'PTA20318',
'PTA20319',
'PTA20320',
'PTA20321',
'PTA20322',
'PTA20323',
'PTA20324',
'PTA20325',
'PTA20326',
'PTA20327',
'PTA20328',
'PTA20329',
'PTA20330',
'PTA20331',
'PTA20332',
'PTA20333',
'PTA20334')                                                               
ORDER BY EXCHANGE                    
                 
END                                           
                    
--RECEIPT_DATA_REVISED_nikhil_PO '01/04/2012','31/03/2015'

GO
