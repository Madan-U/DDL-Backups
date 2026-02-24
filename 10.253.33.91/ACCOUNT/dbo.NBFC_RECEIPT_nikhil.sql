-- Object: PROCEDURE dbo.NBFC_RECEIPT_nikhil
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

    
   --NBFC_RECEIPT_nikhil 'MAY 25 2015','MAY 26 2015'
    
CREATE proc [dbo].[NBFC_RECEIPT_nikhil]           
(          
@TODATE varchar (11),          
@FROMDATE  varchar(11)          
)AS          
BEGIN           
SELECT * INTO #TEMP1 FROM (
SELECT           
[CLTCODE BANKCODE]= A.CLTCODE,          
[DRCR]=b.DRCR,      
 [DRCR BANKDRR]=a.DRCR,       
[VDT]=A.VDT,          
[VAMT BANK_AMT]=A.VAMT,    
[CLTCODE]=B.CLTCODE,    
[VAMT]  =B.VAMT,        
[NARRATION]=A.NARRATION,          
[DDNO]=A.DDNO,          
[RELDT]=A.RELDT,
[BOOKTYPE]=B.BOOKTYPE,
[EXCHANGE]='NSE'
         
        
--INTO #TEMP1          
FROM           
 ( SELECT CLTCODE,L.vdt,L.vno,L.narration,L.vamt,L.DRCR,L1.ddno,          
 L.vtyp,L1.reldt,L.BOOKTYPE          
FROM LEDGER L(NOLOCK), LEDGER1 L1 (NOLOCK)          
          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE           
AND L.DRCR ='D' AND L.VTYP =2  AND L.vdt>= @TODATE AND  L.vdt< = @FROMDATE + ' 23:59:59:999' AND L1.reldt ='')  A        
INNER JOIN           
( SELECT CLTCODE,L.vdt,L.vno,L.narration,L.vamt,L.DRCR,L1.ddno,          
 L.vtyp,L1.reldt,L.BOOKTYPE          
 FROM LEDGER L(NOLOCK), LEDGER1 L1 (NOLOCK)          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE           
and L.DRCR ='C' AND L.VTYP =2  AND L.VDT>= @TODATE AND  L.vdt< = @FROMDATE + ' 23:59:59:999'  AND L1.reldt ='')   B       
on A.VNO =B.VNO AND A.VTYP =B.VTYP AND A.BOOKTYPE= B.BOOKTYPE

-----BSE-----

UNION ALL

SELECT           
[CLTCODE BANKCODE]= A.CLTCODE,          
[DRCR]=b.DRCR,      
 [DRCR BANKDRR]=a.DRCR,       
[VDT]=A.VDT,          
[VAMT BANK_AMT]=A.VAMT,    
[CLTCODE]=B.CLTCODE,    
[VAMT]  =B.VAMT,        
[NARRATION]=A.NARRATION,          
[DDNO]=A.DDNO,          
[RELDT]=A.RELDT,
[BOOKTYPE]=B.BOOKTYPE,
[EXCHANGE]='BSE'
         
        
--INTO #TEMP1          
FROM           
 ( SELECT CLTCODE,L.vdt,L.vno,L.narration,L.vamt,L.DRCR,L1.ddno,          
 L.vtyp,L1.reldt,L.BOOKTYPE          
FROM [AngelBSECM].ACCOUNT_AB.DBO.LEDGER L(NOLOCK),[AngelBSECM].ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)          
          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE           
AND L.DRCR ='D' AND L.VTYP =2  AND L.vdt>= @TODATE AND  L.vdt< = @FROMDATE + ' 23:59:59:999' AND L1.reldt ='')  A        
INNER JOIN           
( SELECT CLTCODE,L.vdt,L.vno,L.narration,L.vamt,L.DRCR,L1.ddno,          
 L.vtyp,L1.reldt,L.BOOKTYPE          
 FROM  [AngelBSECM].ACCOUNT_AB.DBO.LEDGER L(NOLOCK), [AngelBSECM].ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE           
and L.DRCR ='C' AND L.VTYP =2  AND L.VDT>= @TODATE AND  L.vdt< = @FROMDATE + ' 23:59:59:999'  AND L1.reldt ='')   B       
on A.VNO =B.VNO AND A.VTYP =B.VTYP AND A.BOOKTYPE= B.BOOKTYPE

----NSEFO----
UNION ALL



SELECT           
[CLTCODE BANKCODE]= A.CLTCODE,          
[DRCR]=b.DRCR,      
 [DRCR BANKDRR]=a.DRCR,       
[VDT]=A.VDT,          
[VAMT BANK_AMT]=A.VAMT,    
[CLTCODE]=B.CLTCODE,    
[VAMT]  =B.VAMT,        
[NARRATION]=A.NARRATION,          
[DDNO]=A.DDNO,          
[RELDT]=A.RELDT,
[BOOKTYPE]=B.BOOKTYPE,
[EXCHANGE]='NSEFO'
         
        
--INTO #TEMP1          
FROM           
 ( SELECT CLTCODE,L.vdt,L.vno,L.narration,L.vamt,L.DRCR,L1.ddno,          
 L.vtyp,L1.reldt,L.BOOKTYPE          
FROM [ANGELFO].ACCOUNTFO.DBO.LEDGER L(NOLOCK),[ANGELFO].ACCOUNTFO.DBO.LEDGER1 L1 (NOLOCK)          
          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE           
AND L.DRCR ='D' AND L.VTYP =2  AND L.vdt>= @TODATE AND  L.vdt< = @FROMDATE + ' 23:59:59:999' AND L1.reldt ='')  A        
INNER JOIN           
( SELECT CLTCODE,L.vdt,L.vno,L.narration,L.vamt,L.DRCR,L1.ddno,          
 L.vtyp,L1.reldt,L.BOOKTYPE          
 FROM  [ANGELFO].ACCOUNTFO.DBO.LEDGER L(NOLOCK), [ANGELFO].ACCOUNTFO.DBO.LEDGER1 L1 (NOLOCK)          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE           
and L.DRCR ='C' AND L.VTYP =2  AND L.VDT>= @TODATE AND  L.vdt< = @FROMDATE + ' 23:59:59:999'  AND L1.reldt ='')   B       
on A.VNO =B.VNO AND A.VTYP =B.VTYP AND A.BOOKTYPE= B.BOOKTYPE


----NSECURFO----

UNION ALL



SELECT           
[CLTCODE BANKCODE]= A.CLTCODE,          
[DRCR]=b.DRCR,      
 [DRCR BANKDRR]=a.DRCR,       
[VDT]=A.VDT,          
[VAMT BANK_AMT]=A.VAMT,    
[CLTCODE]=B.CLTCODE,    
[VAMT]  =B.VAMT,        
[NARRATION]=A.NARRATION,          
[DDNO]=A.DDNO,          
[RELDT]=A.RELDT,
[BOOKTYPE]=B.BOOKTYPE,
[EXCHANGE]='NSECURFO'
         
        
--INTO #TEMP1          
FROM           
 ( SELECT CLTCODE,L.vdt,L.vno,L.narration,L.vamt,L.DRCR,L1.ddno,          
 L.vtyp,L1.reldt,L.BOOKTYPE          
FROM [ANGELFO].ACCOUNTCURFO.DBO.LEDGER L(NOLOCK),[ANGELFO].ACCOUNTCURFO.DBO.LEDGER1 L1 (NOLOCK)          
          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE           
AND L.DRCR ='D' AND L.VTYP =2  AND L.vdt>= @TODATE AND  L.vdt< = @FROMDATE + ' 23:59:59:999' AND L1.reldt ='')  A        
INNER JOIN           
( SELECT CLTCODE,L.vdt,L.vno,L.narration,L.vamt,L.DRCR,L1.ddno,          
 L.vtyp,L1.reldt,L.BOOKTYPE          
 FROM  [ANGELFO].ACCOUNTCURFO.DBO.LEDGER L(NOLOCK), [ANGELFO].ACCOUNTCURFO.DBO.LEDGER1 L1 (NOLOCK)          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE           
and L.DRCR ='C' AND L.VTYP =2  AND L.VDT>= @TODATE AND  L.vdt< = @FROMDATE + ' 23:59:59:999'  AND L1.reldt ='')   B       
on A.VNO =B.VNO AND A.VTYP =B.VTYP AND A.BOOKTYPE= B.BOOKTYPE

---MCDX---

UNION ALL



SELECT           
[CLTCODE BANKCODE]= A.CLTCODE,          
[DRCR]=b.DRCR,      
 [DRCR BANKDRR]=a.DRCR,       
[VDT]=A.VDT,          
[VAMT BANK_AMT]=A.VAMT,    
[CLTCODE]=B.CLTCODE,    
[VAMT]  =B.VAMT,        
[NARRATION]=A.NARRATION,          
[DDNO]=A.DDNO,          
[RELDT]=A.RELDT,
[BOOKTYPE]=B.BOOKTYPE,
[EXCHANGE]='MCDX'
         
        
--INTO #TEMP1          
FROM           
 ( SELECT CLTCODE,L.vdt,L.vno,L.narration,L.vamt,L.DRCR,L1.ddno,          
 L.vtyp,L1.reldt,L.BOOKTYPE          
FROM [ANGELCOMMODITY].ACCOUNTMCDX.DBO.LEDGER L(NOLOCK),[ANGELCOMMODITY].ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK)          
          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE           
AND L.DRCR ='D' AND L.VTYP =2  AND L.vdt>= @TODATE AND  L.vdt< = @FROMDATE + ' 23:59:59:999' AND L1.reldt ='')  A        
INNER JOIN           
( SELECT CLTCODE,L.vdt,L.vno,L.narration,L.vamt,L.DRCR,L1.ddno,          
 L.vtyp,L1.reldt,L.BOOKTYPE          
 FROM  [ANGELCOMMODITY].ACCOUNTMCDX.DBO.LEDGER L(NOLOCK), [ANGELCOMMODITY].ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK)          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE           
and L.DRCR ='C' AND L.VTYP =2  AND L.VDT>= @TODATE AND  L.vdt< = @FROMDATE + ' 23:59:59:999'  AND L1.reldt ='')   B       
on A.VNO =B.VNO AND A.VTYP =B.VTYP AND A.BOOKTYPE= B.BOOKTYPE

---MCDXCDS---

UNION ALL



SELECT           
[CLTCODE BANKCODE]= A.CLTCODE,          
[DRCR]=b.DRCR,      
 [DRCR BANKDRR]=a.DRCR,       
[VDT]=A.VDT,          
[VAMT BANK_AMT]=A.VAMT,    
[CLTCODE]=B.CLTCODE,    
[VAMT]  =B.VAMT,        
[NARRATION]=A.NARRATION,          
[DDNO]=A.DDNO,          
[RELDT]=A.RELDT,
[BOOKTYPE]=B.BOOKTYPE,
[EXCHANGE]='MCDXCDS'
         
        
--INTO #TEMP1          
FROM           
 ( SELECT CLTCODE,L.vdt,L.vno,L.narration,L.vamt,L.DRCR,L1.ddno,          
 L.vtyp,L1.reldt,L.BOOKTYPE          
FROM [ANGELCOMMODITY].ACCOUNTMCDXCDS.DBO.LEDGER L(NOLOCK),[ANGELCOMMODITY].ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK)          
          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE           
AND L.DRCR ='D' AND L.VTYP =2  AND L.vdt>= @TODATE AND  L.vdt< = @FROMDATE + ' 23:59:59:999' AND L1.reldt ='')  A        
INNER JOIN           
( SELECT CLTCODE,L.vdt,L.vno,L.narration,L.vamt,L.DRCR,L1.ddno,          
 L.vtyp,L1.reldt,L.BOOKTYPE          
 FROM  [ANGELCOMMODITY].ACCOUNTMCDXCDS.DBO.LEDGER L(NOLOCK), [ANGELCOMMODITY].ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK)          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE           
and L.DRCR ='C' AND L.VTYP =2  AND L.VDT>= @TODATE AND  L.vdt< = @FROMDATE + ' 23:59:59:999'  AND L1.reldt ='')   B       
on A.VNO =B.VNO AND A.VTYP =B.VTYP AND A.BOOKTYPE= B.BOOKTYPE

---NCDX---

UNION ALL



SELECT           
[CLTCODE BANKCODE]= A.CLTCODE,          
[DRCR]=b.DRCR,      
 [DRCR BANKDRR]=a.DRCR,       
[VDT]=A.VDT,          
[VAMT BANK_AMT]=A.VAMT,    
[CLTCODE]=B.CLTCODE,    
[VAMT]  =B.VAMT,        
[NARRATION]=A.NARRATION,          
[DDNO]=A.DDNO,          
[RELDT]=A.RELDT,
[BOOKTYPE]=B.BOOKTYPE,
[EXCHANGE]='NCDX'
         
        
--INTO #TEMP1          
FROM           
 ( SELECT CLTCODE,L.vdt,L.vno,L.narration,L.vamt,L.DRCR,L1.ddno,          
 L.vtyp,L1.reldt,L.BOOKTYPE          
FROM [ANGELCOMMODITY].ACCOUNTNCDX.DBO.LEDGER L(NOLOCK),[ANGELCOMMODITY].ACCOUNTNCDX.DBO.LEDGER1 L1 (NOLOCK)          
          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE           
AND L.DRCR ='D' AND L.VTYP =2  AND L.vdt>= @TODATE AND  L.vdt< = @FROMDATE + ' 23:59:59:999' AND L1.reldt ='')  A        
INNER JOIN           
( SELECT CLTCODE,L.vdt,L.vno,L.narration,L.vamt,L.DRCR,L1.ddno,          
 L.vtyp,L1.reldt,L.BOOKTYPE          
 FROM  [ANGELCOMMODITY].ACCOUNTNCDX.DBO.LEDGER L(NOLOCK), [ANGELCOMMODITY].ACCOUNTNCDX.DBO.LEDGER1 L1 (NOLOCK)          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE           
and L.DRCR ='C' AND L.VTYP =2  AND L.VDT>= @TODATE AND  L.vdt< = @FROMDATE + ' 23:59:59:999'  AND L1.reldt ='')   B       
on A.VNO =B.VNO AND A.VTYP =B.VTYP AND A.BOOKTYPE= B.BOOKTYPE
 ) C         
          
SELECT C.*,b.SHORT_NAME,b.REGION,b.BRANCH_CD,b.SUB_BROKER FROM #TEMP1 C          
left outer JOIN          
msajag.dbo.client_details B on C.CLTCODE  = B.cl_code ORDER BY EXCHANGE          
END

GO
