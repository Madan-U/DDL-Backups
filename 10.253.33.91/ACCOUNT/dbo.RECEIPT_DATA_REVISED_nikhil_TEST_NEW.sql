-- Object: PROCEDURE dbo.RECEIPT_DATA_REVISED_nikhil_TEST_NEW
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

              
--RECEIPT_DATA_REVISED_nikhil_TEST_NEW '26/08/2015','04/09/2015'                      
                                  
CREATE PROC [dbo].[RECEIPT_DATA_REVISED_nikhil_TEST_NEW]                                            
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
SELECT *   
INTO #TEMP FROM (                                            
                                  
SELECT                                            
                                           
[CLTCODE]=CLTCODE,                                            
[VDT]    =L.VDT,                                            
[VNO]    =L.VNO,                                  
[NARRATION]=left(REPLACE(LTRIM(RTRIM(L.NARRATION)), '"', ''),100),                                         
[VAMT]   =L.VAMT,                                            
[DRCR]   =L.DRCR,                                            
[DDNO]   =L1.DDNO,                                            
[VTYP]   =L.VTYP,                                            
[RELDT]  =L1.RELDT,                                            
[BOOKTYPE]=L.BOOKTYPE,                                  
[EXCHANGE]='BSE'                                            
                                    
FROM ANAND.ACCOUNT_AB.DBO.LEDGER L (NOLOCK) , ANAND.ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)                                            
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                    
AND L.DRCR ='D' AND L.VTYP ='2' AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                
                                    
UNION ALL                                            
                                            
SELECT CLTCODE,L.VDT,L.VNO,[NARRATION]=left(REPLACE(LTRIM(RTRIM(L.NARRATION)), '"', ''),100),L.VAMT,L.DRCR,L1.DDNO,                                            
 L.VTYP,L1.RELDT,L.BOOKTYPE,[EXCHANGE]='BSE'                                            
 FROM ANAND.ACCOUNT_AB.DBO.LEDGER L(NOLOCK),ANAND.ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)                                            
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                          
AND L.DRCR ='C' AND L.VTYP ='2'  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                     
                                  
  )A                                            
                                      
                                    
-- CREATE CLUSTERED INDEX IDX_CL ON #TEMP                              
--(                              
-- CLTCODE ,VDT                              
--)                              
       
                           
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'/','')     
where NARRATION like '%/%'                      
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'|','')                      
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
                  
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'"',' ')                      
where narration like '%"%'   
                                   
SELECT        
                                                         
[CLTCODE]=REPLACE(LTRIM(RTRIM(A.CLTCODE)), ' ', ''),                                  
CONVERT(VARCHAR(11), CONVERT(DATETIME, A.vdt, 103), 103) as VDT,                                                 
[VNO]=REPLACE(LTRIM(RTRIM(A.vno)), ' ', ''),                                                                                                                                                                                                                                                    
[NARRATION]=left(REPLACE(LTRIM(RTRIM(A.narration)), '"', ''),100),                      
[EXCHANGE]=REPLACE(LTRIM(RTRIM(A.EXCHANGE)), ' ', ''),                                                       
[VAMT]=REPLACE(LTRIM(RTRIM(A.vamt)), ' ', ''),                                              
[DRCR]=REPLACE(LTRIM(RTRIM(A.DRCR)), ' ', ''),                            
[DDNO]=REPLACE(LTRIM(RTRIM(A.ddno)), ' ', ''),                                                       
[VTYP]=REPLACE(LTRIM(RTRIM(A.vtyp)), ' ', ''),                                 
CONVERT(VARCHAR(11), CONVERT(DATETIME, A.reldt, 103), 103) as RELDT,                                                                                     
[BOOKTYPE]=REPLACE(LTRIM(RTRIM(A.BOOKTYPE)), ' ', ''),                                             
[SHORT_NAME]=REPLACE(LTRIM(RTRIM(B.SHORT_NAME)), ' ', ''),               
[REGION]=REPLACE(LTRIM(RTRIM(B.REGION)), ' ', ''),                                            
[BRANCH_CD]=REPLACE(LTRIM(RTRIM(B.BRANCH_CD)), ' ', ''),                                         
[SUB_BROKER]=REPLACE(LTRIM(RTRIM(B.SUB_BROKER)), ' ', '') ,                                        
--B.BANK_NAME AS BANK_NAME ,                                         
[AC_NUM]=REPLACE(LTRIM(RTRIM(B.AC_NUM)), ' ', '')         
                                                                        
FROM #TEMP AS A LEFT OUTER JOIN        
                                          
MSAJAG.DBO.CLIENT_DETAILS AS B ON A.CLTCODE = B.CL_CODE       
                     
ORDER BY EXCHANGE        
                                        
 END

GO
