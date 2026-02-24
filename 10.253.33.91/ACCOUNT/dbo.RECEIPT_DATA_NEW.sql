-- Object: PROCEDURE dbo.RECEIPT_DATA_NEW
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC [dbo].[RECEIPT_DATA_NEW]                
(                  
  @FROMDATE VARCHAR(11),                  
  @TODATE VARCHAR(11)                  
 )                           
 AS                  
 BEGIN                  
 SELECT DISTINCT
 [EXCHANGE]='NSE',                           
 [CLTCODE] = A.CLTCODE,  
 [VDATE] = A.VDT,  
 [V_NO] = A.VNO,                  
 [NARRATION] = A.NARRATION,                  
 [VAMT] = A.VAMT,  
 [DRCR] = A.DRCR,  
 [DDNO] = A.DDNO,                  
 [VTYP] = A.VTYP,  
 [RELDT] = A.RELDT,            
 [BOOKTYPE] = A.BOOKTYPE  
INTO  #NIK1                    
 FROM                  
(  
SELECT L.CLTCODE,L.VDT,L.VNO,L.NARRATION,L.VAMT,L.DRCR,L1.DDNO,L.VTYP,L1.RELDT,L.BOOKTYPE  
FROM LEDGER L(NOLOCK), LEDGER1 L1 (NOLOCK)  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE   
AND L.DRCR ='D' AND L.VTYP =2  AND L.VDT >= CONVERT(VARCHAR(23), @FROMDATE, 121) AND L.VDT < =CONVERT(VARCHAR(23), @TODATE, 121) + ' 23:59:59'   
UNION ALL  
SELECT L.CLTCODE,L.VDT,L.VNO,L.NARRATION,L.VAMT,L.DRCR,L1.DDNO,L.VTYP,L1.RELDT,L.BOOKTYPE  
FROM LEDGER L(NOLOCK), LEDGER1 L1 (NOLOCK)  
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE   
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >= CONVERT(VARCHAR(23), @FROMDATE, 121) AND L.VDT < =CONVERT(VARCHAR(23), @TODATE, 121) + ' 23:59:59') A  
      
                 
SELECT          
A.*,          
[SHORT_NAME]=B.SHORT_NAME,          
[REGION]=B.REGION,          
[BRANCH_CD]=B.BRANCH_CD,          
[SUB_BROKER]=B.SUB_BROKER,          
[BANK_NAME]=B.BANK_NAME,          
[AC_NUM]=B.AC_NUM          
FROM  #NIK1 A LEFT OUTER JOIN          
MSAJAG.DBO.CLIENT_DETAILS B ON A.CLTCODE = B.CL_CODE           
 END 
 
 --EXEC RECEIPT_DATA_NEW 'MAY 10 2015','MAY 12 2015'

GO
