-- Object: PROCEDURE dbo.RECEIPT_DATA_INSEPEC
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


--RECEIPT_DATA_REVISED_nikhil '01/04/2006','24/08/2015'

CREATE PROC [dbo].[RECEIPT_DATA_INSEPEC]                          
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
AND L.CLTCODE IN ('A15874','N9060','N9061','M15569','B9249','J6279','J11914','J19817','A21930','C17617')     
                 
                  
UNION ALL                          
                          
SELECT CLTCODE,L.VDT,L.VNO,L.NARRATION,L.VAMT,L.DRCR,L1.DDNO,                          
 L.VTYP,L1.RELDT,L.BOOKTYPE,'NSE'                          
 FROM LEDGER L(NOLOCK), LEDGER1 L1 (NOLOCK)                          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                          
AND L.DRCR ='C' AND L.VTYP =2  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                
 AND L.CLTCODE IN ('A15874','N9060','N9061','M15569','B9249','J6279','J11914','J19817','A21930','C17617')
 )A
 
 SELECT * FROM #TEMP
 
 END

GO
