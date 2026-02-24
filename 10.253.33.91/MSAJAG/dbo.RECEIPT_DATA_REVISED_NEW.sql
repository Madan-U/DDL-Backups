-- Object: PROCEDURE dbo.RECEIPT_DATA_REVISED_NEW
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

        
        
CREATE PROC [dbo].[RECEIPT_DATA_REVISED_NEW]                   
(                  
@FROMDATE datetime ,                  
@TODATE   datetime             
               
)                  
AS                   
BEGIN                   
SELECT  * INTO #TEMP FROM (                  
SELECT                  
                 
[CLTCODE]=CLTCODE,                  
[VDT]    =L.VDT,                  
[VNO]    =L.VNO,        
[VAMT]   =L.VAMT,                  
[DRCR]   =L.DRCR,                  
[DDNO]   =L1.DDNO,                  
[VTYP]   =L.VTYP,                  
[RELDT]  =L1.RELDT,                  
[BOOKTYPE]=L.BOOKTYPE,
[NARRATION]=L.NARRATION,                  
[EXCHANGE]='NSE'                  
          
FROM ACCOUNT..LEDGER L (NOLOCK) , ACCOUNT..LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE           
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
          
UNION ALL                  
                  
SELECT CLTCODE,L.VDT,L.VNO,L.VAMT,L.DRCR,L1.DDNO,                  
 L.VTYP,L1.RELDT,L.BOOKTYPE,L.NARRATION,'NSE'                  
 FROM ACCOUNT..LEDGER L(NOLOCK), ACCOUNT..LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                  
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'        
        
        
----BSE-----        
UNION ALL         
SELECT                  
                 
[CLTCODE]=CLTCODE,                  
[VDT]    =L.VDT,                  
[VNO]    =L.VNO,        
[VAMT]   =L.VAMT,                  
[DRCR]   =L.DRCR,                  
[DDNO]   =L1.DDNO,                  
[VTYP]   =L.VTYP,                  
[RELDT]  =L1.RELDT,                  
[BOOKTYPE]=L.BOOKTYPE,        
[NARRATION]=L.NARRATION,                  
[EXCHANGE]='BSE'                  
          
FROM [AngelBSECM].ACCOUNT_AB.DBO.LEDGER L (NOLOCK) , [AngelBSECM].ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE          
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
          
UNION ALL                  
                  
SELECT CLTCODE,L.VDT,L.VNO,L.VAMT,L.DRCR,L1.DDNO,                  
 L.VTYP,L1.RELDT,L.BOOKTYPE,L.NARRATION,'BSE'                  
 FROM [AngelBSECM].ACCOUNT_AB.DBO.LEDGER L(NOLOCK),[AngelBSECM].ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                  
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
        
        
------nsefo------        
UNION ALL         
SELECT                  
                 
[CLTCODE]=CLTCODE,                  
[VDT]    =L.VDT,                  
[VNO]    =L.VNO,        
[VAMT]   =L.VAMT,                  
[DRCR]   =L.DRCR,                  
[DDNO]   =L1.DDNO,                  
[VTYP]   =L.VTYP,                  
[RELDT]  =L1.RELDT,                  
[BOOKTYPE]=L.BOOKTYPE,        
[NARRATION]=L.NARRATION,                  
[EXCHANGE]='NSEFO'                  
          
FROM [ANGELFO].ACCOUNTFO.DBO.LEDGER L (NOLOCK) , [ANGELFO].ACCOUNTFO.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE          
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
          
UNION ALL                  
                  
SELECT CLTCODE,L.VDT,L.VNO,L.VAMT,L.DRCR,L1.DDNO,                  
 L.VTYP,L1.RELDT,L.BOOKTYPE,L.NARRATION,'NSEFO'                  
 FROM [ANGELFO].ACCOUNTFO.DBO.LEDGER L(NOLOCK),[ANGELFO].ACCOUNTFO.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                  
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'         
        
        
----NSECURFO-----        
        
UNION ALL         
SELECT          
                 
[CLTCODE]=CLTCODE,                  
[VDT]    =L.VDT,                  
[VNO]    =L.VNO,        
[VAMT]   =L.VAMT,                  
[DRCR]   =L.DRCR,                  
[DDNO]   =L1.DDNO,                  
[VTYP]   =L.VTYP,                  
[RELDT]  =L1.RELDT,                  
[BOOKTYPE]=L.BOOKTYPE,        
[NARRATION]=L.NARRATION,                  
[EXCHANGE]='NSECURFO'                  
          
FROM [ANGELFO].ACCOUNTCURFO.DBO.LEDGER L (NOLOCK) , [ANGELFO].ACCOUNTCURFO.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE          
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
          
UNION ALL              
                  
SELECT CLTCODE,L.VDT,L.VNO,L.VAMT,L.DRCR,L1.DDNO,                  
 L.VTYP,L1.RELDT,L.BOOKTYPE,L.NARRATION,'NSECURFO'                  
 FROM [ANGELFO].ACCOUNTCURFO.DBO.LEDGER L(NOLOCK),[ANGELFO].ACCOUNTCURFO.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                  
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'         
        
----MCDX----        
        
UNION ALL         
SELECT                  
                 
[CLTCODE]=CLTCODE,                  
[VDT]    =L.VDT,                  
[VNO]    =L.VNO,        
[VAMT]   =L.VAMT,                  
[DRCR]   =L.DRCR,                  
[DDNO]   =L1.DDNO,                  
[VTYP]   =L.VTYP,                  
[RELDT]  =L1.RELDT,                  
[BOOKTYPE]=L.BOOKTYPE,        
[NARRATION]=L.NARRATION,                  
[EXCHANGE]='MCDX'                  
          
FROM [ANGELCOMMODITY].ACCOUNTMCDX.DBO.LEDGER L (NOLOCK) , [ANGELCOMMODITY].ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE          
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
          
UNION ALL                  
                  
SELECT CLTCODE,L.VDT,L.VNO,L.VAMT,L.DRCR,L1.DDNO,                  
 L.VTYP,L1.RELDT,L.BOOKTYPE,L.NARRATION,'MCDX'                  
 FROM [ANGELCOMMODITY].ACCOUNTMCDX.DBO.LEDGER L(NOLOCK),[ANGELCOMMODITY].ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                  
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
        
        
----MCDXCDS----        
        
UNION ALL         
SELECT                  
                 
[CLTCODE]=CLTCODE,                  
[VDT]    =L.VDT,                  
[VNO]    =L.VNO,        
[VAMT]   =L.VAMT,                  
[DRCR]   =L.DRCR,                  
[DDNO]   =L1.DDNO,                  
[VTYP]   =L.VTYP,                  
[RELDT]  =L1.RELDT,                  
[BOOKTYPE]=L.BOOKTYPE,        
[NARRATION]=L.NARRATION,                  
[EXCHANGE]='MCDXCDS'                  
          
FROM [ANGELCOMMODITY].ACCOUNTMCDXCDS.DBO.LEDGER L (NOLOCK) , [ANGELCOMMODITY].ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE          
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
          
UNION ALL                  
                  
SELECT CLTCODE,L.VDT,L.VNO,L.VAMT,L.DRCR,L1.DDNO,                  
 L.VTYP,L1.RELDT,L.BOOKTYPE,L.NARRATION,'MCDXCDS'                  
 FROM [ANGELCOMMODITY].ACCOUNTMCDXCDS.DBO.LEDGER L(NOLOCK),[ANGELCOMMODITY].ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                  
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
        
----NCDX----        
        
UNION ALL         
SELECT                  
                 
[CLTCODE]=CLTCODE,                  
[VDT]    =L.VDT,                  
[VNO]    =L.VNO,        
[VAMT]   =L.VAMT,                  
[DRCR]   =L.DRCR,                  
[DDNO]   =L1.DDNO,                  
[VTYP]   =L.VTYP,                  
[RELDT]  =L1.RELDT,                  
[BOOKTYPE]=L.BOOKTYPE,        
[NARRATION]=L.NARRATION,                  
[EXCHANGE]='NCDX'                  
          
FROM [ANGELCOMMODITY].ACCOUNTNCDX.DBO.LEDGER L (NOLOCK) , [ANGELCOMMODITY].ACCOUNTNCDX.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE          
AND L.DRCR ='D' AND L.VTYP =2 AND L.VDT >= @FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
          
UNION ALL                  
                  
SELECT CLTCODE,L.VDT,L.VNO,L.VAMT,L.DRCR,L1.DDNO,                  
 L.VTYP,L1.RELDT,L.BOOKTYPE,L.NARRATION,'NCDX'                  
 FROM [ANGELCOMMODITY].ACCOUNTNCDX.DBO.LEDGER L(NOLOCK),[ANGELCOMMODITY].ACCOUNTNCDX.DBO.LEDGER1 L1 (NOLOCK)                  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                  
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59:59.999'           
        
          
  )A                  
                  
SELECT                  
A.*,                  
[SHORT_NAME]=B.SHORT_NAME,                  
[REGION]=B.REGION,                  
[BRANCH_CD]=B.BRANCH_CD,                  
[SUB_BROKER]=B.SUB_BROKER,                  
[BANK_NAME]=B.BANK_NAME,                  
[AC_NUM]=B.AC_NUM                 
                  
                  
FROM   #TEMP A LEFT OUTER JOIN                  
MSAJAG.DBO.CLIENT_DETAILS B ON A.CLTCODE = B.CL_CODE  ORDER BY EXCHANGE                 
 END                  
                   
                   
 ---EXEC RECEIPT_DATA_REVISED_NEW 'MAY 10 2015','MAY 21 2015'

GO
