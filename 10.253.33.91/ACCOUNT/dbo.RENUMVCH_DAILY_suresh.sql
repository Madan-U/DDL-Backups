-- Object: PROCEDURE dbo.RENUMVCH_DAILY_suresh
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

create PROC RENUMVCH_DAILY_suresh      
--BEGIN TRAN      
--RENUMVCH_DAILY 2, '01'      
--COMMIT TRAN      
--ROLLBACK TRAN      
@VTYP SMALLINT,      
@BOOKTYPE VARCHAR(2)      
AS      
DECLARE      
@@OVNO AS VARCHAR(12),      
@@EXIST AS NUMERIC(10),      
@@LEXIST AS VARCHAR(12),      
@@VNO AS VARCHAR(12),      
@@VTYPE AS SMALLINT,      
@@BTYPE AS VARCHAR(2),    
@@VAMT AS MONEY,      
@@VDT AS VARCHAR(11),      
@@VDT1 AS DATETIME,      
@@LASTVNOEXIST VARCHAR(12),      
@@MAINREC AS CURSOR      
SET NOCOUNT ON      
     
      
SET @@MAINREC = CURSOR FOR      
SELECT DISTINCT VNO,VTYP,BOOKTYPE,vamt, convert(varchar(11),vdt,109)     
FROM   LEDGER l WITH(NOLOCK)        
where VDT <'apr  1 2013'
and VTYP=8
and VNO like '2013%'       
--AND exists (SELECT   VNO        
--FROM     LEDGER l1 WITH(NOLOCK)         
--WHERE    l.vno=l1.vno    
--     and l.vtyp=l1.vtyp and l.booktype=l1.booktype and     
-- l1.LNO = 2        
--     AND l1.VTYP = 8        
--     AND l1.VDT BETWEEN 'APR  1 2012'        
--                     AND 'MAR 31 2013 23:59'        
--GROUP BY l1.VNO,l1.VTYP,l1.BOOKTYPE        
--HAVING   COUNT(1) > 1) --and vno like '20071220%'    
--order by vno    
    
    
OPEN @@MAINREC      
 FETCH NEXT FROM @@MAINREC INTO @@VNO, @@VTYPE, @@BTYPE, @@VAMT,   @@VDT    
WHILE @@FETCH_STATUS = 0      
 BEGIN      
                  SELECT @@LASTVNOEXIST = ISNULL(COUNT(LASTVNO), 0) FROM LASTVNO WHERE VDT LIKE @@VDT + '%' AND VTYP = @@VTYPE AND BOOKTYPE = @@BTYPE      
                  IF @@LASTVNOEXIST = 0       
                  BEGIN      
                        SELECT @@OVNO = (SELECT CONVERT(VARCHAR(4),YEAR(@@VDT)) + RIGHT('0'+LTRIM(CONVERT(VARCHAR,MONTH(@@VDT))),2) + RIGHT('00'+LTRIM(CONVERT(VARCHAR,DAY(@@VDT))),2)+'0001')      
                        INSERT INTO LASTVNO VALUES(@@VTYPE, @@BTYPE, @@VDT, @@OVNO)      
                  END       
                  ELSE      
                  BEGIN      
                        SELECT @@OVNO = CONVERT(VARCHAR(12), CONVERT(NUMERIC, MAX(LASTVNO)) + 1) FROM LASTVNO WHERE VDT LIKE @@VDT + '%' AND VTYP = @@VTYPE AND BOOKTYPE = @@BTYPE      
                        UPDATE LASTVNO SET LASTVNO = @@OVNO WHERE VDT LIKE @@VDT + '%' AND VTYP = @@VTYPE AND BOOKTYPE = @@BTYPE      
                  END      
                  INSERT INTO LEDGERRENUM_LOG VALUES(@@VNO, @@VTYPE, @@BTYPE, @@OVNO)      
  PRINT 'UPDATING ' + @@VNO + ', VTYPE ' + CONVERT(VARCHAR, @@VTYPE) + ', BOOKTYPE ' + @@BTYPE + ' TO ' + @@OVNO + ' DAITED ' +@@VDT      
  UPDATE LEDGER SET VNO = @@OVNO WHERE VNO = @@VNO AND VTYP = @@VTYPE AND BOOKTYPE = @@BTYPE and vamt=@@VAMT      
  UPDATE LEDGER1 SET VNO = @@OVNO WHERE VNO = @@VNO AND VTYP = @@VTYPE AND BOOKTYPE = @@BTYPE and relamt=@@VAMT      
  UPDATE LEDGER2 SET VNO = @@OVNO WHERE VNO = @@VNO AND VTYPE = @@VTYPE AND BOOKTYPE = @@BTYPE and camt=@@VAMT     
  FETCH NEXT FROM @@MAINREC INTO @@VNO, @@VTYPE, @@BTYPE, @@VAMT,@@VDT      
 END

GO
