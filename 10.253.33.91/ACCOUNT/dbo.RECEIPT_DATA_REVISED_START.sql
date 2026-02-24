-- Object: PROCEDURE dbo.RECEIPT_DATA_REVISED_START
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


                                          
 --      [RECEIPT_DATA_REVISED_START]     '14/03/2018'   ,'20/03/2018'                                                   
CREATE PROC [dbo].[RECEIPT_DATA_REVISED_START]                                                                          
(                                                                        
@fromdate varchar(11) ,                                                                          
@todate   varchar(11)                                                                                                                                          
)                                                                          
AS                                                                           
                                                                                                       
IF LEN(@fromdate) = 10 AND CHARINDEX('/', @fromdate) > 0                                                      
                                                      
BEGIN                                                      
                                                      
      SET @fromdate = CONVERT(VARCHAR(11), CONVERT(DATETIME, @fromdate, 103), 120)                                                      
                                                      
END                                                      
                                                      
IF LEN(@todate) = 10 AND CHARINDEX('/', @todate) > 0                                                      
                                                      
BEGIN                                                      
                                                      
      SET @todate = CONVERT(VARCHAR(11), CONVERT(DATETIME, @todate, 103), 120)                                                      
                                                      
END                                                      
                                                      
                                                                                 
                                                      
BEGIN                                                                           
SELECT  * INTO #TEMP FROM (                                                                          
SELECT                                                                          
  
[CLTCODE]=CLTCODE,                                                                          
[VDT]    =L.VDT,                                                                          
[VNO]    =L.VNO,                                                                
REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                                                          
[VAMT]   =L.VAMT,                                                                          
[DRCR]   =L.DRCR,                                                                          
[DDNO]   =L1.DDNO,                                                                          
[VTYP]   =L.VTYP,                                                                          
[RELDT]  =L1.RELDT,                                                                          
[BOOKTYPE]=L.BOOKTYPE,                                                                
[EXCHANGE]='NSE'                                                                          
  
FROM LEDGER L (NOLOCK) , LEDGER1 L1 (NOLOCK)                                                                          
WHERE  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'     AND L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                   
AND L.DRCR ='D' AND L.VTYP =2                                                
  
UNION ALL                                                                          
  
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                  
L.VTYP,L1.RELDT,L.BOOKTYPE,'NSE'                                                                          
FROM LEDGER L(NOLOCK), LEDGER1 L1 (NOLOCK)                                                                          
WHERE  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'     AND L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                          
AND L.DRCR ='C' AND L.VTYP =2                          
  
----BSE-----                                                                
UNION ALL                                                                 
SELECT                                                                          
  
[CLTCODE]=CLTCODE,                                                                          
[VDT]    =L.VDT,                                                                 
[VNO]    =L.VNO,                                                                
REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                                                          
[VAMT]   =L.VAMT,                                                                          
[DRCR]   =L.DRCR,                                                                          
[DDNO]   =L1.DDNO,                                                   
[VTYP]   =L.VTYP,                                                                          
[RELDT]  =L1.RELDT,                                 
[BOOKTYPE]=L.BOOKTYPE,                                                                
[EXCHANGE]='BSE'                                                                          
  
FROM AngelBSECM.ACCOUNT_AB.DBO.LEDGER L (NOLOCK) , AngelBSECM.ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)                                                                          
WHERE  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'     AND L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                  
AND L.DRCR ='D' AND L.VTYP =2                                                               
  
UNION ALL                                                                          
  
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                                                          
L.VTYP,L1.RELDT,L.BOOKTYPE,'BSE'                                                                          
FROM AngelBSECM.ACCOUNT_AB.DBO.LEDGER L(NOLOCK),AngelBSECM.ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)                                                                          
WHERE  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'     AND L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                        
AND L.DRCR ='C' AND L.VTYP =2                                                                      
  
----NSEFO------                                                                
UNION ALL                                                                 
SELECT                                                                          
  
[CLTCODE]=CLTCODE,                                                                    
[VDT]    =L.VDT,                    
[VNO]    =L.VNO,                                                                
REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                                  
[VAMT]   =L.VAMT,                                                                          
[DRCR]   =L.DRCR,                                                         
[DDNO]   =L1.DDNO,                                                                          
[VTYP]   =L.VTYP,                          
[RELDT]  =L1.RELDT,                                                                          
[BOOKTYPE]=L.BOOKTYPE,                                                                
[EXCHANGE]='NSEFO'                              
  
FROM ANGELFO.ACCOUNTFO.DBO.LEDGER L (NOLOCK) , ANGELFO.ACCOUNTFO.DBO.LEDGER1 L1 (NOLOCK)                                        
WHERE  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'     AND L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                  
AND L.DRCR ='D' AND L.VTYP =2                                                                 
  
UNION ALL                                                                          
  
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                                                          
L.VTYP,L1.RELDT,L.BOOKTYPE,'NSEFO'                                                                          
FROM ANGELFO.ACCOUNTFO.DBO.LEDGER L(NOLOCK),ANGELFO.ACCOUNTFO.DBO.LEDGER1 L1 (NOLOCK)                                                                          
WHERE  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'     AND L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                              
AND L.DRCR ='C' AND L.VTYP =2                                                                
  
--NSECURFO                                                             
  
UNION ALL                                                                 
SELECT                                                                          
  
[CLTCODE]=CLTCODE,                                                                     
[VDT]    =L.VDT,                                                                          
[VNO]    =L.VNO,                                                                
REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                                                          
[VAMT]   =L.VAMT,                                                                          
[DRCR]   =L.DRCR,                                                                          
[DDNO]   =L1.DDNO,                                                                          
[VTYP]   =L.VTYP,                                                                          
[RELDT]  =L1.RELDT,                                                                          
[BOOKTYPE]=L.BOOKTYPE,                                           
[EXCHANGE]='NSECURFO'                                                                          
  
FROM ANGELFO.ACCOUNTCURFO.DBO.LEDGER L (NOLOCK) , ANGELFO.ACCOUNTCURFO.DBO.LEDGER1 L1 (NOLOCK)                                                                          
WHERE  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'     AND  L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                  
AND L.DRCR ='D' AND L.VTYP =2                                                                   
  
UNION ALL                                                            
  
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                                            
L.VTYP,L1.RELDT,L.BOOKTYPE,'NSECURFO'                                                                          
FROM ANGELFO.ACCOUNTCURFO.DBO.LEDGER L(NOLOCK),ANGELFO.ACCOUNTCURFO.DBO.LEDGER1 L1 (NOLOCK)                                      
WHERE  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'     AND L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                          
AND L.DRCR ='C' AND L.VTYP =2                                                                
  
--MCDX----                                                                
  
UNION ALL                                                    
SELECT                                                                          
  
[CLTCODE]=CLTCODE,       
[VDT]    =L.VDT,                                                                 
[VNO]    =L.VNO,                                                          
REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                                                          
[VAMT]   =L.VAMT,                                                                          
[DRCR]   =L.DRCR,                                                                          
[DDNO]   =L1.DDNO,                                                                          
[VTYP]   =L.VTYP,                                                                          
[RELDT]  =L1.RELDT,                              
[BOOKTYPE]=L.BOOKTYPE,                                                                
[EXCHANGE]='MCDX'                                                                          
  
FROM ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L (NOLOCK) , ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK)                                                                          
WHERE  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'     AND L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                         
AND L.DRCR ='D' AND L.VTYP =2                                                                
  
UNION ALL                                                                          
  
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                                                          
L.VTYP,L1.RELDT,L.BOOKTYPE,'MCDX'                                                                          
FROM ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L(NOLOCK),ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK)                                                                          
WHERE  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'     AND  L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                          
AND L.DRCR ='C' AND L.VTYP =2                                     
  
--MCDXCDS----                                                                
  
UNION ALL                                                    
SELECT                                                                          
  
[CLTCODE]=CLTCODE,                                           
[VDT]    =L.VDT,                                                                          
[VNO]    =L.VNO,                                                                
REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                                        
[VAMT]   =L.VAMT,                                         
[DRCR]   =L.DRCR,                                                                          
[DDNO]   =L1.DDNO,                                                                          
[VTYP]   =L.VTYP,                                                                          
[RELDT]  =L1.RELDT,                                                  
[BOOKTYPE]=L.BOOKTYPE,                                                              
[EXCHANGE]='MCDXCDS'                                                                          
  
FROM ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER L (NOLOCK) , ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK)                                                           
WHERE  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'     AND L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                  
AND L.DRCR ='D' AND L.VTYP =2                                       
  
UNION ALL                                                                          
  
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                        
L.VTYP,L1.RELDT,L.BOOKTYPE,'MCDXCDS'                                           
FROM ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER L(NOLOCK),ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK)                                                                          
WHERE  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'     AND L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                       
AND L.DRCR ='C' AND L.VTYP =2                                                                 
  
--NCDX----                                                
  
UNION ALL                      
SELECT                                                                          
  
[CLTCODE]=CLTCODE,                                                                          
[VDT]    =L.VDT,                                                                          
[VNO]    =L.VNO,                                                                
REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                                                          
[VAMT]   =L.VAMT,                                                        
[DRCR]   =L.DRCR,                                                                    
[DDNO]   =L1.DDNO,                                                               
[VTYP]   =L.VTYP,                                                                          
[RELDT]  =L1.RELDT,                                                                          
[BOOKTYPE]=L.BOOKTYPE,                                                                
[EXCHANGE]='NCDX'                                                                          
  
FROM ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER L (NOLOCK) , ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER1 L1 (NOLOCK)                                                  
WHERE  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'     AND L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                  
AND L.DRCR ='D' AND L.VTYP =2                     
  
UNION ALL                                                                          
  
SELECT CLTCODE,L.VDT,L.VNO,REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,L.VAMT,L.DRCR,L1.DDNO,                                                           
L.VTYP,L1.RELDT,L.BOOKTYPE,'NCDX'                                                                          
FROM ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER L(NOLOCK),ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER1 L1 (NOLOCK)                                                                          
WHERE  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'     AND L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                                                          
AND L.DRCR ='C' AND L.VTYP =2            


union all 
SELECT                                                                          
  
[CLTCODE]=CLTCODE,                                                                          
[VDT]    =L.VDT,                                                                          
[VNO]    =L.VNO,                                                                
REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                                                          
[VAMT]   =(CASE WHEN L.DRAMOUNT =0 THEN CRAMOUNT ELSE DRAMOUNT END),                                                        
[DRCR]   =(CASE WHEN L.DRAMOUNT =0 THEN 'CR' ELSE 'DR' END),                                                                    
[DDNO]   = INSTNO,                                                               
[VTYP]   =L.VTYPE,                                                                          
[RELDT]  =(CASE WHEN L.VTYPE =2 THEN CR_RELDT ELSE DR_RELDT END),                                                                          
[BOOKTYPE]='01',                                                                
[EXCHANGE]='MFSS'                                                                          
FROM ANGELFO.BBO_FA.DBO.MFSS_LEDGER_BSE L (NOLOCK) , ANGELFO.BBO_FA.DBO.ACC_TBL4  T4 WITH(NOLOCK)  ,ANGELFO.BBO_FA.DBO.ACC_TBL1   T1   WITH(NOLOCK)                                        
WHERE   T1.SNO =T4.MASTERSNO  AND L.VTYPE=T1.VTYPE and  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'  
AND L.VTYPE =2 AND L.VNO =T1.VNO
                                                                                                                            

                                                                                                                                                              
                   
)A                                             
  
  
---- CREATE CLUSTERED INDEX IDX_CL ON #TEMP                                                            
----(                                                            
---- CLTCODE ,VDT                                                            
----)                                                            
UPDATE #TEMP SET DDNO = REPLACE(DDNO,'|','')                                                
where DDNO like '%|%'     
UPDATE #TEMP SET DDNO = REPLACE(DDNO,',','')                                                
where DDNO like '%,%'   
  
SELECT                                                                                                  
[CLTCODE]=LEFT(REPLACE(LTRIM(RTRIM(A.CLTCODE)), ' ', ''),100),                                        
CONVERT(VARCHAR(11), CONVERT(DATETIME, A.vdt, 103), 103) as VDT,                                                       
[VNO]=REPLACE(LTRIM(RTRIM(A.vno)), ' ', ''),    
--LEFT(REPLACE(REPLACE(REPLACE(A.NARRATION,'''',''),'""',''),'"',''),100) AS NARRATION,                                                                                                                             
[NARRATION]=left(REPLACE(LTRIM(RTRIM(A.narration)), '"', ''),100),                            
[EXCHANGE]=REPLACE(LTRIM(RTRIM(A.EXCHANGE)), ' ', ''),                                                             
[VAMT]=REPLACE(LTRIM(RTRIM(A.vamt)), ' ', ''),                                                    
[DRCR]=REPLACE(LTRIM(RTRIM(A.DRCR)), ' ', ''),  
--LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ltrim(rtrim(A.ddno)),'''',''),'""',''),'"',''),',',''),'.',''),100) AS DDNO ,                                                                                           
RIGHT(LEFT(LTRIM(RTRIM(A.ddno)),36),12) AS DDNO,
--REPLACE(SUBSTRING(RTRIM(LTRIM(A.ddno)),CASE WHEN CHARINDEX('/',RTRIM(LTRIM(A.ddno)))=0 THEN 
--len(RTRIM(LTRIM(A.ddno))) ELSE CHARINDEX('/',RTRIM(LTRIM(A.ddno))) END+1, 
--LEN(RTRIM(LTRIM(A.ddno)))),REVERSE(SUBSTRING(REVERSE(RTRIM(LTRIM(A.ddno))),1,
--CHARINDEX('/',REVERSE(RTRIM(LTRIM(A.ddno)))))),'') AS DDNO,
[VTYP]=REPLACE(LTRIM(RTRIM(A.vtyp)), ' ', ''),                                       
CONVERT(VARCHAR(11), CONVERT(DATETIME, A.reldt, 103), 103) as RELDT,                                                                                           
[BOOKTYPE]=REPLACE(LTRIM(RTRIM(A.BOOKTYPE)), ' ', ''),                                                   
[SHORT_NAME]=REPLACE(LTRIM(RTRIM(B.SHORT_NAME)), ' ', ''),                     
[REGION]=REPLACE(LTRIM(RTRIM(B.REGION)), ' ', ''),                                                  
[BRANCH_CD]=REPLACE(LTRIM(RTRIM(B.BRANCH_CD)), ' ', ''),                                               
[SUB_BROKER]=REPLACE(LTRIM(RTRIM(B.SUB_BROKER)), ' ', '') ,                                              
REPLACE(REPLACE(REPLACE(B.BANK_NAME,'''',''),'""',''),',','') AS BANK_NAME,                                                 
[AC_NUM]=REPLACE(LTRIM(RTRIM(B.AC_NUM)), ' ', '')                   
FROM #TEMP AS A LEFT OUTER JOIN                    
MSAJAG.DBO.CLIENT_DETAILS AS B ON A.CLTCODE = B.CL_CODE      
-------------where CLTCODE IN ('H34399','ZR418' )     
                               
ORDER BY EXCHANGE                     
  
END                         
  
 --RECEIPT_DATA_REVISED_START '12/10/2015','12/10/2015'

GO
