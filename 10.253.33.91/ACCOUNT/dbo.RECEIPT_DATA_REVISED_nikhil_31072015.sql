-- Object: PROCEDURE dbo.RECEIPT_DATA_REVISED_nikhil_31072015
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

   
        
        
CREATE PROC [dbo].[RECEIPT_DATA_REVISED_nikhil]                   
(                  
@FROMDATE DATETIME ,                  
@TODATE   DATETIME             
                
)                  
AS                   
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
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
          
UNION ALL                  
                  
SELECT CLTCODE,L.VDT,L.VNO,L.NARRATION,L.VAMT,L.DRCR,L1.DDNO,                  
 L.VTYP,L1.RELDT,L.BOOKTYPE,'NSE'                  
 FROM LEDGER L(NOLOCK), LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                  
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'        
        
        
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
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
          
UNION ALL                  
                  
SELECT CLTCODE,L.VDT,L.VNO,L.NARRATION,L.VAMT,L.DRCR,L1.DDNO,                  
 L.VTYP,L1.RELDT,L.BOOKTYPE,'BSE'                  
 FROM ANAND.ACCOUNT_AB.DBO.LEDGER L(NOLOCK),ANAND.ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                  
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
        
        
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
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
          
UNION ALL                  
                  
SELECT CLTCODE,L.VDT,L.VNO,L.NARRATION,L.VAMT,L.DRCR,L1.DDNO,                  
 L.VTYP,L1.RELDT,L.BOOKTYPE,'NSEFO'                  
 FROM ANGELFO.ACCOUNTFO.DBO.LEDGER L(NOLOCK),ANGELFO.ACCOUNTFO.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                  
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'         
        
        
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
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
          
UNION ALL              
                  
SELECT CLTCODE,L.VDT,L.VNO,L.NARRATION,L.VAMT,L.DRCR,L1.DDNO,                  
 L.VTYP,L1.RELDT,L.BOOKTYPE,'NSECURFO'                  
 FROM ANGELFO.ACCOUNTCURFO.DBO.LEDGER L(NOLOCK),ANGELFO.ACCOUNTCURFO.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                  
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'         
        
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
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
          
UNION ALL                  
                  
SELECT CLTCODE,L.VDT,L.VNO,L.NARRATION,L.VAMT,L.DRCR,L1.DDNO,                  
 L.VTYP,L1.RELDT,L.BOOKTYPE,'MCDX'                  
 FROM ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L(NOLOCK),ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                  
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
        
        
--MCDXCDS----        
        
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
[EXCHANGE]='MCDXCDS'                  
          
FROM ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER L (NOLOCK) , ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE          
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
          
UNION ALL                  
                  
SELECT CLTCODE,L.VDT,L.VNO,L.NARRATION,L.VAMT,L.DRCR,L1.DDNO,                  
 L.VTYP,L1.RELDT,L.BOOKTYPE,'MCDXCDS'                  
 FROM ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER L(NOLOCK),ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                  
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
        
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
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
          
UNION ALL                  
                  
SELECT CLTCODE,L.VDT,L.VNO,L.NARRATION,L.VAMT,L.DRCR,L1.DDNO,                  
 L.VTYP,L1.RELDT,L.BOOKTYPE,'NCDX'                  
 FROM ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER L(NOLOCK),ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                  
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
        
          
  )A                  
            
            
 CREATE CLUSTERED INDEX IDX_CL ON #TEMP    
(    
 CLTCODE ,VDT    
)    
                 
SELECT                  
[CLTCODE]=A.CLTCODE,      
[VDT]=A.vdt,                       
[VNO]=A.vno,           
[NARRATION]=REPLACE(A.narration , '"', ''),                                                                                                                                                                                                                   
 EXCHANGE    ,                               
[VAMT]=A.vamt,                    
[DRCR]=A.DRCR,  
[DDNO]=A.ddno,                             
[VTYP]=A.vtyp,     
[RELDT]=A.reldt,                     
[BOOKTYPE]=A.BOOKTYPE,                   
[SHORT_NAME]=B.SHORT_NAME,                  
[REGION]=B.REGION,                  
[BRANCH_CD]=B.BRANCH_CD,                  
[SUB_BROKER]=B.SUB_BROKER,                  
[BANK_NAME]=B.BANK_NAME,                  
[AC_NUM]=B.AC_NUM                 
                  
                  
FROM  #TEMP AS A LEFT OUTER JOIN                  
MSAJAG.DBO.CLIENT_DETAILS AS B ON A.CLTCODE = B.CL_CODE  ORDER BY EXCHANGE                 
 END

GO
