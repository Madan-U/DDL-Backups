-- Object: PROCEDURE dbo.BR_YEAREND
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROCEDURE BR_YEAREND
 @SDTCUR VARCHAR(11),      
 @LDTCUR VARCHAR(11),      
 @VTYP   SMALLINT,      
 @VNO VARCHAR(12),      
 @BOOKTYPE CHAR(2),      
 @VDT    DATETIME,
 @PNLCODE VARCHAR(10)      
      
AS      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
      
DECLARE      
 @@MAINCTRLAC AS VARCHAR(10),      
 @@MAINACNAME AS VARCHAR(100),      
 @@MAINCOSTCODE AS INT,      
 @@LNO AS INT,      
 @@COSTCODE AS SMALLINT,      
 @@AMT AS MONEY,      
 @@RCURSOR AS CURSOR
  
    
      
SELECT       
 @@LNO =       
 (       
 SELECT       
  LNO       
 FROM LEDGER       
 WHERE VTYP = @VTYP       
  AND BOOKTYPE = @BOOKTYPE       
  AND VNO = @VNO       
  AND CLTCODE = @PNLCODE       
 )      
      
SELECT       
 @@MAINCTRLAC =       
 (       
 SELECT       
  MAINCONTROLAC       
 FROM BRANCHACCOUNTS       
 WHERE DEFAULTAC = 1      
 )      
      
SELECT @@MAINCOSTCODE = COSTCODE FROM COSTMAST WHERE COSTNAME IN(SELECT BRANCHNAME FROM BRANCHACCOUNTS WHERE DEFAULTAC = 1)      
      
SELECT       
 @@MAINACNAME =       
 (       
 SELECT       
  ACNAME       
 FROM ACMAST       
 WHERE CLTCODE = @@MAINCTRLAC       
 )    

TRUNCATE TABLE LEDGER_BRANCHBREAKUP

INSERT INTO LEDGER_BRANCHBREAKUP
SELECT VNO, VTYPE, BOOKTYPE, LNO, CLTCODE, CAMT, COSTCODE, DRCR 
FROM LEDGER2 L2 WITH (NOLOCK) WHERE CLTCODE NOT IN (@@MAINCTRLAC, @PNLCODE) 
AND EXISTS(SELECT VNO FROM LEDGER L WITH (NOLOCK) WHERE VDT > = @SDTCUR + ' 00:00:00'           
 AND VDT <= @LDTCUR + ' 23:59:59' AND L2.VTYPE = L.VTYP           
AND L2.BOOKTYPE = L.BOOKTYPE           
 AND L2.VNO = L.VNO           
 AND L2.LNO = L.LNO   )  
      
TRUNCATE TABLE BRANCHWISECLBAL 

INSERT INTO BRANCHWISECLBAL
SELECT   
 L2.CLTCODE,           
 A.ACNAME ,           
 COSTCODE,           
 BALANCE=SUM(           
 CASE           
  WHEN UPPER(L2.DRCR) = 'D'           
  THEN CAMT           
  ELSE -CAMT           
 END          
 )           
FROM LEDGER_BRANCHBREAKUP L2,           
 ACMAST A           
  
WHERE 
L2.CLTCODE = A.CLTCODE
 AND           
 (          
  A.ACTYP LIKE 'ASS%'           
  OR A.ACTYP LIKE 'LIAB%'          
 )           
          
GROUP BY COSTCODE,           
 L2.CLTCODE,           
 A.ACNAME        
      
/*
INSERT       
INTO BRANCHWISECLBAL       
SELECT       
 L2.CLTCODE,       
 A.ACNAME ,       
 COSTCODE,       
 BALANCE=SUM(       
 CASE       
  WHEN UPPER(L2.DRCR) = 'D'       
  THEN CAMT       
  ELSE -CAMT       
 END      
 )       
FROM LEDGER2 L2       
LEFT OUTER JOIN       
 ACMAST A       
 ON L2.CLTCODE = A.CLTCODE,       
 LEDGER L       
WHERE L2.VTYPE = L.VTYP       
 AND L2.BOOKTYPE = L.BOOKTYPE       
 AND L2.VNO = L.VNO       
 AND L2.LNO = L.LNO       
 AND L.VDT > = @SDTCUR + ' 00:00:00'       
 AND L.VDT <= @LDTCUR + ' 23:59:59'       
 AND       
 (      
  A.ACTYP LIKE 'ASS%'       
  OR A.ACTYP LIKE 'LIAB%'      
 )       
 AND L2.CLTCODE NOT IN (@@MAINCTRLAC, @PNLCODE)       
GROUP BY COSTCODE,       
 L2.CLTCODE,       
 A.ACNAME
*/
INSERT       
  INTO BRANCHWISECLBAL       
	SELECT      
	  @@MAINCTRLAC,       
	  @@MAINACNAME,       
	  COSTCODE,      
	  -(SUM(BALANCE))
	 FROM      
	  BRANCHWISECLBAL      
	 GROUP BY      
	  COSTCODE 

    

/*      
SET @@RCURSOR = CURSOR FOR      
 SELECT      
  COSTCODE,      
  SUM(BALANCE)      
 FROM      
  BRANCHWISECLBAL      
 GROUP BY      
  COSTCODE      
      
OPEN @@RCURSOR      
 FETCH NEXT FROM      
  @@RCURSOR       
 INTO      
  @@COSTCODE,      
  @@AMT      
      
WHILE @@FETCH_STATUS = 0      
 BEGIN      
  INSERT       
  INTO BRANCHWISECLBAL VALUES      
   (       
    @@MAINCTRLAC,       
    @@MAINACNAME,       
    @@COSTCODE,       
    -(@@AMT)       
   )      
      
  FETCH NEXT FROM      
   @@RCURSOR       
  INTO      
   @@COSTCODE,      
   @@AMT      
 END      
      
CLOSE @@RCURSOR      
DEALLOCATE @@RCURSOR     
*/ 
      
INSERT       
INTO LEDGER2       
SELECT       
 L.VTYP,       
 L.VNO,       
 L.LNO,       
 (      
 CASE       
  WHEN (CASE WHEN COSTCODE = @@MAINCOSTCODE AND L.CLTCODE = @@MAINCTRLAC THEN 0 ELSE BALANCE END) >= 0       
  THEN 'D'       
  ELSE 'C'       
 END      
 ),       
 ABS(CASE WHEN COSTCODE = @@MAINCOSTCODE AND L.CLTCODE = @@MAINCTRLAC THEN 0 ELSE BALANCE END),       
 COSTCODE,       
 L.BOOKTYPE,       
 B.CLTCODE       
FROM LEDGER L,       
 BRANCHWISECLBAL B       
WHERE L.VTYP = @VTYP       
 AND L.BOOKTYPE = @BOOKTYPE       
 AND L.VNO = @VNO       
 AND L.CLTCODE = B.CLTCODE      
 AND L.CLTCODE NOT IN       
 (       
 SELECT       
  BRCONTROLAC       
 FROM BRANCHACCOUNTS       
 )      
      
INSERT       
INTO LEDGER2       
SELECT       
 @VTYP,       
 @VNO,       
 @@LNO,       
 (      
 CASE       
  WHEN BALANCE >= 0       
  THEN 'D'       
  ELSE 'C'       
 END      
 ),       
 ABS(BALANCE),       
 COSTCODE,       
 @BOOKTYPE,       
 CLTCODE       
FROM BRANCHWISECLBAL B       
WHERE CLTCODE IN       
 (       
 SELECT       
  BRCONTROLAC       
 FROM BRANCHACCOUNTS       
 )

GO
