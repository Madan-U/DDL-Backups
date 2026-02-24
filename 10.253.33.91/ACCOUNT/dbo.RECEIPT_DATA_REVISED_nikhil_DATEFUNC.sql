-- Object: PROCEDURE dbo.RECEIPT_DATA_REVISED_nikhil_DATEFUNC
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

        
--RECEIPT_DATA_REVISED_nikhil '26/08/2015','26/08/2015'                
                            
CREATE PROC [dbo].[RECEIPT_DATA_REVISED_nikhil_DATEFUNC]                                      
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
SELECT  * INTO #TEMP FROM (                                      
SELECT                                      
                                     
[CLTCODE]=CLTCODE,                                      
[VDT]    =L.VDT,                                      
[VNO]    =L.VNO,                            
[NARRATION]=L.NARRATION,                                      
[VAMT]   =L.VAMT,                                      
[DRCR]   =L.DRCR,                                      
[DDNO]   =L1.DDNO,                                      
[VTYP]   =L.VTYP,                                      
[RELDT]  =L1.RELDT,                                      
[BOOKTYPE]=L.BOOKTYPE,                            
[EXCHANGE]='NSE'                                      
                              
FROM LEDGER L (NOLOCK) , LEDGER1 L1 (NOLOCK)                                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                               
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                               
                              
UNION ALL                                      
                                      
SELECT CLTCODE,L.VDT,L.VNO,L.NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                      
 L.VTYP,L1.RELDT,L.BOOKTYPE,'NSE'                                      
 FROM LEDGER L(NOLOCK), LEDGER1 L1 (NOLOCK)                                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                      
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                            
                            
                            
----BSE-----                            
UNION ALL                             
SELECT                                      
                                     
[CLTCODE]=CLTCODE,                                      
[VDT]    =L.VDT,                                      
[VNO]    =L.VNO,                            
[NARRATION]=L.NARRATION,                                      
[VAMT]   =L.VAMT,                                      
[DRCR]   =L.DRCR,                                      
[DDNO]   =L1.DDNO,                                      
[VTYP]   =L.VTYP,                                      
[RELDT]  =L1.RELDT,                                      
[BOOKTYPE]=L.BOOKTYPE,                            
[EXCHANGE]='BSE'                                      
                              
FROM ANAND.ACCOUNT_AB.DBO.LEDGER L (NOLOCK) , ANAND.ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)                                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                              
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                          
                              
UNION ALL                                      
                                      
SELECT CLTCODE,L.VDT,L.VNO,L.NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                      
 L.VTYP,L1.RELDT,L.BOOKTYPE,'BSE'                                      
 FROM ANAND.ACCOUNT_AB.DBO.LEDGER L(NOLOCK),ANAND.ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)                                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                    
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                               
                            
                            
----NSEFO------                            
UNION ALL                             
SELECT                                      
                                     
[CLTCODE]=CLTCODE,                                      
[VDT]    =L.VDT,                                      
[VNO]    =L.VNO,                            
[NARRATION]=L.NARRATION,                                      
[VAMT]   =L.VAMT,                                      
[DRCR]   =L.DRCR,                     
[DDNO]   =L1.DDNO,                                      
[VTYP]   =L.VTYP,                                      
[RELDT]  =L1.RELDT,                                      
[BOOKTYPE]=L.BOOKTYPE,                            
[EXCHANGE]='NSEFO'                           
                              
FROM ANGELFO.ACCOUNTFO.DBO.LEDGER L (NOLOCK) , ANGELFO.ACCOUNTFO.DBO.LEDGER1 L1 (NOLOCK)                                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                              
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                               
                              
UNION ALL                                      
                                      
SELECT CLTCODE,L.VDT,L.VNO,L.NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                      
 L.VTYP,L1.RELDT,L.BOOKTYPE,'NSEFO'                                      
 FROM ANGELFO.ACCOUNTFO.DBO.LEDGER L(NOLOCK),ANGELFO.ACCOUNTFO.DBO.LEDGER1 L1 (NOLOCK)                                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                      
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                             
                            
                            
--NSECURFO-----                            
                            
UNION ALL                             
SELECT                                      
                                     
[CLTCODE]=CLTCODE,                                 
[VDT]    =L.VDT,                                      
[VNO]    =L.VNO,                            
[NARRATION]=L.NARRATION,                                      
[VAMT]   =L.VAMT,                                      
[DRCR]   =L.DRCR,                                      
[DDNO]   =L1.DDNO,                                      
[VTYP]   =L.VTYP,                                      
[RELDT]  =L1.RELDT,                                      
[BOOKTYPE]=L.BOOKTYPE,                            
[EXCHANGE]='NSECURFO'                                      
                              
FROM ANGELFO.ACCOUNTCURFO.DBO.LEDGER L (NOLOCK) , ANGELFO.ACCOUNTCURFO.DBO.LEDGER1 L1 (NOLOCK)                                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                              
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                               
                              
UNION ALL                                  
                                      
SELECT CLTCODE,L.VDT,L.VNO,L.NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                      
 L.VTYP,L1.RELDT,L.BOOKTYPE,'NSECURFO'                                      
 FROM ANGELFO.ACCOUNTCURFO.DBO.LEDGER L(NOLOCK),ANGELFO.ACCOUNTCURFO.DBO.LEDGER1 L1 (NOLOCK)                                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                      
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                             
        
--MCDX----                            
                            
UNION ALL                             
SELECT                                      
                                     
[CLTCODE]=CLTCODE,                                      
[VDT]    =L.VDT,                                      
[VNO]    =L.VNO,                      
[NARRATION]=L.NARRATION,                                      
[VAMT]   =L.VAMT,                                      
[DRCR]   =L.DRCR,                                      
[DDNO]   =L1.DDNO,                                      
[VTYP]   =L.VTYP,                                      
[RELDT]  =L1.RELDT,                                   
[BOOKTYPE]=L.BOOKTYPE,                            
[EXCHANGE]='MCDX'                                      
                              
FROM ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L (NOLOCK) , ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK)                                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                              
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                               
                              
UNION ALL                                      
                                      
SELECT CLTCODE,L.VDT,L.VNO,L.NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                      
 L.VTYP,L1.RELDT,L.BOOKTYPE,'MCDX'                                      
 FROM ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L(NOLOCK),ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK)                                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                      
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                               
                            
                            
--MCDXCDS----                            
                            
UNION ALL                             
SELECT                                      
                                     
[CLTCODE]=CLTCODE,                                      
[VDT]    =L.VDT,                                      
[VNO]    =L.VNO,                            
[NARRATION]=L.NARRATION,                        [VAMT]   =L.VAMT,                                      
[DRCR]   =L.DRCR,                                      
[DDNO]   =L1.DDNO,                                      
[VTYP]   =L.VTYP,                                      
[RELDT]  =L1.RELDT,                                      
[BOOKTYPE]=L.BOOKTYPE,                            
[EXCHANGE]='MCDXCDS'                                      
                              
FROM ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER L (NOLOCK) , ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK)                       
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                              
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                               
                              
UNION ALL                                      
                                      
SELECT CLTCODE,L.VDT,L.VNO,L.NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                      
 L.VTYP,L1.RELDT,L.BOOKTYPE,'MCDXCDS'                                      
 FROM ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER L(NOLOCK),ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK)                                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                      
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                               
                            
--NCDX----            
                            
UNION ALL                             
SELECT                                      
                                     
[CLTCODE]=CLTCODE,                                      
[VDT]    =L.VDT,                                      
[VNO]    =L.VNO,                            
[NARRATION]=L.NARRATION,                                      
[VAMT]   =L.VAMT,                    
[DRCR]   =L.DRCR,                                
[DDNO]   =L1.DDNO,                                      
[VTYP]   =L.VTYP,                                      
[RELDT]  =L1.RELDT,                                      
[BOOKTYPE]=L.BOOKTYPE,                            
[EXCHANGE]='NCDX'                                      
                              
FROM ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER L (NOLOCK) , ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER1 L1 (NOLOCK)                                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                              
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59'                               
                              
UNION ALL                                      
                                      
SELECT CLTCODE,L.VDT,L.VNO,L.NARRATION,L.VAMT,L.DRCR,L1.DDNO,                       
 L.VTYP,L1.RELDT,L.BOOKTYPE,'NCDX'                                      
 FROM ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER L(NOLOCK),ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER1 L1 (NOLOCK)                                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                      
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                               
                            
                              
  )A                                      
                                
                              
 CREATE CLUSTERED INDEX IDX_CL ON #TEMP                        
(                        
 CLTCODE ,VDT                        
)                        
                         
                         
--UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'/','')                  
--where narration like '%/%'                  
--UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'|','')                  
--where narration like '%|%'                  
--UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,':','')        --where narration like '%:%'                  
--UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'.','')                  
--where narration like '%.%'                  
                  
--UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'_',' ')                  
--where narration like '%_%'                  
                  
--UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'-',' ')                  
--where narration like '%-%'                  
                  
--UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,')',' ')                  
--where narration like '%)%'                  
                  
--UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'(',' ')                  
--where narration like '%(%'                  
                  
--UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'&',' ')                  
--where narration like '%&%'                  
                
--UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'#',' ')                    
--where narration like '%#%'                    
                
--UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,',',' ')                    
--where narration like '%,%'                  
                
--UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,':-',' ')                    
--where narration like '%:-%'                  
                
--UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,' ','')                    
--where narration like '% %'                    
                  
--select NARRATION from #temp                  
--where narration like '%%'     
----where narration like '%:/.?=_-$(){}~&%'                  
--return                  
                                    
SELECT                     
                                   
[CLTCODE]=REPLACE(LTRIM(RTRIM(A.CLTCODE)), '  ', ' '),   
--[VDT]=A.vdt,                            
CONVERT(VARCHAR(11), CONVERT(DATETIME, A.vdt, 103), 103) as VDT,                                           
[VNO]=A.vno,                               
--[NARRATION]=REPLACE(A.narration , '"', ''),                                                                                                                                                                                                        
                
[NARRATION]=left(REPLACE(A.narration , '"', ''),100),                  
[EXCHANGE]=A.EXCHANGE,                                                   
[VAMT]=A.vamt,                                        
[DRCR]=A.DRCR,                      
[DDNO]=A.ddno,                                                 
[VTYP]=A.vtyp,                         
--[RELDT]=A.reldt,     
CONVERT(VARCHAR(11), CONVERT(DATETIME, A.reldt, 103), 103) as RELDT,                                                                               
[BOOKTYPE]=A.BOOKTYPE,                                       
[SHORT_NAME]=B.SHORT_NAME,                                      
[REGION]=B.REGION,                                      
[BRANCH_CD]=B.BRANCH_CD,                                   
[SUB_BROKER]=B.SUB_BROKER,                                      
[BANK_NAME]=B.BANK_NAME,                                      
[AC_NUM]=B.AC_NUM                    
                                                   
FROM #TEMP AS A LEFT OUTER JOIN                                      
MSAJAG.DBO.CLIENT_DETAILS AS B ON A.CLTCODE = B.CL_CODE                
ORDER BY EXCHANGE                     
                  
                                  
 END

GO
