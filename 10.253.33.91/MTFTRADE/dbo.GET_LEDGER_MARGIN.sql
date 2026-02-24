-- Object: PROCEDURE dbo.GET_LEDGER_MARGIN
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

CREATE PROC [dbo].[GET_LEDGER_MARGIN]            
AS            
SELECT CLTCODE = party_code INTO #ACMAST             
FROM ANGELFO.NSEFO.DBO.TBL_MARGINPARTY       
            
CREATE CLUSTERED INDEX CLTIDX ON #ACMAST            
(            
 CLTCODE            
)            

TRUNCATE TABLE LEDGER_MARGIN            
/*            
SELECT L.VTYP,L.VNO,EDT=(CASE WHEN RELDT = 'JAN  1 1900'             
         THEN '2049-12-31'            
         ELSE RELDT             
       END),            
    L.LNO,L.ACNAME,L.DRCR,VAMT,VDT,VNO1,L.REFNO,BALAMT,            
    NODAYS,CDT,L.CLTCODE,L.BOOKTYPE,ENTEREDBY,PDT,CHECKEDBY,            
    ACTNODAYS,NARRATION            
INTO #LEDGER_MARGIN            
FROM LEDGER L (NOLOCK), LEDGER1 L1 (NOLOCK), #ACMAST A (NOLOCK)            
WHERE L.VNO = L1.VNO            
AND L.VTYP = L1.VTYP            
AND L.BOOKTYPE = L1.BOOKTYPE            
AND L.VTYP IN (2,3)            
AND L.CLTCODE = A.CLTCODE             
*/            
            
INSERT INTO LEDGER_MARGIN            
SELECT L.* FROM LEDGER L (NOLOCK),             
    #ACMAST A (NOLOCK)            
WHERE VDT >= 'APR  1 2014'            
AND L.CLTCODE = A.CLTCODE             
/*
INSERT INTO LEDGER_MARGIN 
SELECT L.* FROM MTFTRADE.DBO.LEDGER L (NOLOCK),             
    ACMAST A (NOLOCK)            
WHERE VDT >= 'APR  1 2014'            
AND L.CLTCODE = A.CLTCODE  */
/*           
UPDATE LEDGER_MARGIN SET EDT = (CASE WHEN RELDT = 'JAN  1 1900'             
         THEN '2049-12-31'            
         ELSE RELDT             
       END)            
FROM LEDGER1 L1            
WHERE LEDGER_MARGIN.VNO = L1.VNO            
AND LEDGER_MARGIN.VTYP = L1.VTYP            
AND LEDGER_MARGIN.BOOKTYPE = L1.BOOKTYPE          
AND LEDGER_MARGIN.VTYP = 2          
AND LEDGER_MARGIN.BOOKTYPE <> (CASE WHEN VDT >= 'JAN 29 2015' THEN '' ELSE 'E8' END)          
        
UPDATE LEDGER_MARGIN SET EDT = VDT         
WHERE VTYP = 2           
AND ENTEREDBY = 'TPR'          
AND EDT >= GETDATE()          
AND CHECKEDBY = 'ONLINE'          
AND EDT >= '2049-12-31'         
/*        
SELECT VNO, VTYP, CLTCODE, VDT = CONVERT(VARCHAR,VDT,103), EDT,        
VAMT, ENTEREDBY, CHECKEDBY FROM LEDGER_MARGIN          
WHERE VTYP = 2           
AND ENTEREDBY = 'TPR'          
AND EDT >= GETDATE()          
AND CHECKEDBY = 'ONLINE'          
*/ 

*/

GO
