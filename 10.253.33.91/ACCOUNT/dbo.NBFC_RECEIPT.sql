-- Object: PROCEDURE dbo.NBFC_RECEIPT
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------



CREATE proc NBFC_RECEIPT       
(      
@fromdate varchar (11),      
@todate  varchar(11)      
)AS      
BEGIN       
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
[RELDT]=A.RELDT  
     
    
INTO #TEMP1      
FROM       
 ( SELECT CLTCODE,L.vdt,L.vno,L.narration,L.vamt,L.DRCR,L1.ddno,      
 L.vtyp,L1.reldt,L.BOOKTYPE      
FROM LEDGER L(NOLOCK), LEDGER1 L1 (NOLOCK)      
      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE       
AND L.DRCR ='D' AND L.VTYP =2  AND L.vdt>= @fromdate AND  L.vdt< = @todate + ' 23:59:59:999' AND L1.reldt ='')  A    
INNER JOIN       
( SELECT CLTCODE,L.vdt,L.vno,L.narration,L.vamt,L.DRCR,L1.ddno,      
 L.vtyp,L1.reldt,L.BOOKTYPE      
 FROM LEDGER L(NOLOCK), LEDGER1 L1 (NOLOCK)      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE       
and L.DRCR ='C' AND L.VTYP =2  AND L.VDT>= @fromdate AND  L.vdt< = @todate + ' 23:59:59:999'  AND L1.reldt ='')   B   
on A.VNO =B.VNO AND A.VTYP =B.VTYP AND A.BOOKTYPE= B.BOOKTYPE      
      
SELECT A.*,b.SHORT_NAME,b.REGION,b.BRANCH_CD,b.SUB_BROKER,'NSE' AS EXCHANGE FROM #TEMP1 A      
left outer JOIN      
msajag.dbo.client_details B on A.CLTCODE  = B.cl_code       
END    
    
--exec nbfc_receipt 'may 10 2015' , 'may 25 2015'

GO
