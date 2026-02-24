-- Object: PROCEDURE dbo.YEAREND
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------



        
 /*            
SELECT * FROM LEDGER WHERE VNO  ='200800000001' AND VTYP = 18            
EXEC YEAREND 'APR  1 2007', 'MAR 31 2008', 18, '200804010001', '01', 'APR  1 2008', 'OPENING BALANCE'          
*/            
CREATE PROC [dbo].[YEAREND]            
 @SDTCUR VARCHAR(11),            
 @LDTCUR VARCHAR(11),            
 @VTYP SMALLINT,            
 @VNO VARCHAR(12),            
 @BOOKTYPE VARCHAR(2),            
 @VDT VARCHAR(11),            
 @MSG1 VARCHAR(234),          
 @PNL_CODE VARCHAR(10) = '99999'          
AS            
/*            
 EXEC YEAREND 'APR  1 2006', 'MAR 31 2007', 18, '200700000001', '01', 'APR  1 2007', 'TEST OPENING ENTRY'            
 EXEC YEAREND 'Apr  1 2006','Mar 31 2007', 18, '200700000001', '01', 'Apr  1 2007', 'Opening balance'            
 SELECT COUNT(1) FROM LEDGER WHERE VTYP = 18 AND VDT >= 'APR  1 2007'            
             
*/            
          
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED            
            
 DELETE FROM LEDGER WHERE VNO = @VNO AND VTYP = @VTYP AND BOOKTYPE = @BOOKTYPE            
 DELETE FROM LEDGER2 WHERE VNO = @VNO AND VTYPE = @VTYP AND BOOKTYPE = @BOOKTYPE            
 DELETE FROM LEDGER3 WHERE VNO = @VNO AND VTYP = @VTYP AND BOOKTYPE = @BOOKTYPE            
 DELETE FROM MARGINLEDGER WHERE VNO = @VNO AND VTYP = @VTYP AND BOOKTYPE = @BOOKTYPE            
            
 CREATE TABLE #VDT            
 (            
  CLTCODE VARCHAR(10),            
  ACNAME VARCHAR(100),            
  DRCR VARCHAR(1),            
  BALANCE MONEY            
 )            
            
 INSERT INTO #VDT            
  (CLTCODE, ACNAME, DRCR, BALANCE)            
 SELECT            
  A.CLTCODE,            
  ACNAME = ISNULL(A.LONGNAME, ''),            
  DRCR = CASE WHEN SUM(CASE WHEN L.DRCR = 'D' THEN L.VAMT ELSE -L.VAMT END) >= 0 THEN 'D' ELSE 'C' END,            
  VAMT = ROUND(ABS(SUM(CASE WHEN L.DRCR = 'D' THEN L.VAMT ELSE -L.VAMT END)),2)            
 FROM            
  LEDGER L LEFT OUTER JOIN ACMAST A ON L.CLTCODE = A.CLTCODE            
 WHERE            
  L.VDT BETWEEN @SDTCUR  AND @LDTCUR + ' 23:59:59'            
  AND (A.ACTYP LIKE 'ASS%' OR A.ACTYP LIKE 'LIAB%')            
  AND L.CLTCODE <> @PNL_CODE            
 GROUP BY            
  A.CLTCODE,            
  A.LONGNAME            
            
            
 CREATE TABLE #EDT            
 (            
  CLTCODE VARCHAR(10),            
  BALANCE MONEY            
 )            
            
 INSERT INTO #EDT            
  (CLTCODE, BALANCE)            
 SELECT            
  A.CLTCODE,            
  BALANCE = ROUND(SUM(CASE WHEN L.VTYP = 18 THEN BALAMT ELSE CASE WHEN L.DRCR = 'D' THEN L.VAMT ELSE -L.VAMT END END),2)            
 FROM            
  LEDGER L LEFT OUTER JOIN ACMAST A ON L.CLTCODE = A.CLTCODE            
 WHERE            
  L.EDT BETWEEN @SDTCUR AND @LDTCUR + ' 23:59:59'            
  AND (A.ACTYP LIKE 'ASS%' OR A.ACTYP LIKE 'LIAB%')            
  AND L.CLTCODE <> @PNL_CODE            
 GROUP BY            
  A.CLTCODE            
            
            
 CREATE TABLE #LEDGER            
 (            
  VTYP SMALLINT,            
  VNO VARCHAR(12),            
  EDT DATETIME,            
  LNO INT IDENTITY(1,1),            
  ACNAME VARCHAR(100),            
  DRCR CHAR(1),            
  VAMT MONEY,            
  VDT DATETIME,            
  VNO1 VARCHAR(12),            
  REFNO CHAR(12),            
  BALAMT MONEY,            
  NODAYS INT,            
  CDT DATETIME,            
  CLTCODE VARCHAR(10),            
  BOOKTYPE VARCHAR(2),            
  ENTEREDBY VARCHAR(25),            
  PDT DATETIME,            
  CHECKEDBY VARCHAR(25),            
  ACTNODAYS INT,            
  NARRATION VARCHAR(234)            
 )            
            
INSERT INTO #LEDGER            
 (VTYP, VNO, EDT, ACNAME, DRCR, VAMT, VDT, VNO1, REFNO, BALAMT, NODAYS, CDT, CLTCODE, BOOKTYPE, ENTEREDBY, PDT, CHECKEDBY, ACTNODAYS, NARRATION)            
SELECT            
 VTYP = @VTYP,            
 VNO = @VNO,            
 EDT = @VDT,            
 ACNAME = V.ACNAME,            
 DRCR = V.DRCR,            
 VAMT = V.BALANCE,            
 VDT = @VDT,            
 VNO1 = @VNO,            
 REFNO = '',            
 BALAMT = ISNULL(E.BALANCE, 0),            
 NODAYS = 0,            
 CDT = GETDATE(),            
 V.CLTCODE,            
 BOOKTYPE = @BOOKTYPE,            
 ENTEREDBY = 'SYSTEM',            
 PDT = GETDATE(),            
 CHECKEDBY = 'SYSTEM',            
 ACTNODAYS = 0,            
 NARRATION = @MSG1            
FROM            
 #VDT V LEFT OUTER JOIN #EDT E ON V.CLTCODE = E.CLTCODE            
            
            
CREATE TABLE #PANDL            
(            
 VDTBAL MONEY,            
 EDTBAL MONEY            
)            
INSERT INTO #PANDL SELECT VDTBAL = ROUND(SUM(CASE WHEN DRCR = 'D' THEN VAMT ELSE -VAMT END),2), EDTBAL = ROUND((SUM(BALAMT)),2) FROM #LEDGER            
            
INSERT INTO #LEDGER            
 (VTYP, VNO, EDT, ACNAME, DRCR, VAMT, VDT, VNO1, REFNO, BALAMT, NODAYS, CDT, CLTCODE, BOOKTYPE, ENTEREDBY, PDT, CHECKEDBY, ACTNODAYS, NARRATION)            
SELECT            
 VTYP = @VTYP,            
 VNO = @VNO,            
 EDT = @VDT,            
 ACNAME = ISNULL(A.ACNAME, 'PROFIT AND LOSS A/C'),            
 DRCR = CASE WHEN VDTBAL < 0 THEN 'D' ELSE 'C' END,            
 VAMT = ABS(VDTBAL),            
 VDT = @VDT,            
 VNO1 = @VNO,            
 REFNO = '',            
 BALAMT = EDTBAL,            
 NODAYS = 0,            
 CDT = GETDATE(),            
 A.CLTCODE,            
 BOOKTYPE = @BOOKTYPE,            
 ENTEREDBY = 'SYSTEM',            
 PDT = GETDATE(),            
 CHECKEDBY = 'SYSTEM',            
 ACTNODAYS = 0,            
 NARRATION = @MSG1            
FROM            
 #PANDL,            
 ACMAST A            
WHERE            
 A.CLTCODE = @PNL_CODE            
            
            
            
DROP TABLE #VDT            
DROP TABLE #EDT            
DROP TABLE #PANDL            
            
CREATE TABLE #MVDT            
(            
 PARTY_CODE VARCHAR(10),            
 MCLTCODE VARCHAR(10),            
 EXCHANGE VARCHAR(3),            
 SEGMENT VARCHAR(20),            
 DRCR VARCHAR(1),            
 AMOUNT MONEY            
)            
            
INSERT INTO #MVDT            
 (PARTY_CODE, MCLTCODE, EXCHANGE, SEGMENT, DRCR, AMOUNT)            
SELECT            
 PARTY_CODE,            
 MCLTCODE,            
 EXCHANGE,            
 SEGMENT,            
 DRCR = CASE WHEN SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END) >= 0 THEN 'D' ELSE 'C' END,            
 AMOUNT = ROUND(SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END),2)            
FROM            
 MARGINLEDGER            
WHERE            
 VDT BETWEEN @SDTCUR AND @LDTCUR + ' 23:59:59'            
GROUP BY            
 PARTY_CODE,            
 MCLTCODE,            
 EXCHANGE,            
 SEGMENT            
            
CREATE TABLE #MEDT            
(            
 PARTY_CODE VARCHAR(10),            
 MCLTCODE VARCHAR(10),            
 EXCHANGE VARCHAR(3),            
 SEGMENT VARCHAR(20),            
 AMOUNT MONEY            
)            
            
INSERT INTO #MEDT            
 (PARTY_CODE, MCLTCODE, EXCHANGE, SEGMENT, AMOUNT)            
SELECT            
 M.PARTY_CODE,            
 M.MCLTCODE,            
 M.EXCHANGE,            
 M.SEGMENT,            
 AMOUNT = ROUND(SUM(CASE WHEN M.DRCR = 'D' THEN M.AMOUNT ELSE -M.AMOUNT END),2)            
FROM            
 MARGINLEDGER M,            
 LEDGER L            
WHERE            
 M.VTYP = L.VTYP AND M.BOOKTYPE = L.BOOKTYPE AND M.VNO = L.VNO AND M.LNO = L.LNO            
 AND L.EDT BETWEEN @SDTCUR AND @LDTCUR + ' 23:59:59'            
GROUP BY            
 M.PARTY_CODE,            
 M.MCLTCODE,            
 M.EXCHANGE,            
 M.SEGMENT            
            
CREATE TABLE #MARGINLEDGER            
(            
 VTYP SMALLINT,            
 VNO VARCHAR(12),            
 LNO INT,            
 DRCR VARCHAR(1),            
 VDT DATETIME,            
 AMOUNT MONEY,            
 PARTY_CODE VARCHAR(10),            
 EXCHANGE VARCHAR(3),            
 SEGMENT VARCHAR(20),            
 SETT_NO MONEY,            
 SETT_TYPE VARCHAR(3),            
 BOOKTYPE VARCHAR(2),            
 MCLTCODE VARCHAR(10)            
)            
            
INSERT INTO #MARGINLEDGER            
 (VTYP, VNO, DRCR, VDT, AMOUNT, PARTY_CODE, EXCHANGE, SEGMENT, SETT_NO, SETT_TYPE, BOOKTYPE, MCLTCODE)            
SELECT            
 VTYP = @VTYP,            
 VNO = @VNO,            
 DRCR = V.DRCR,            
 VDT = @VDT,            
 AMOUNT = ABS(V.AMOUNT),            
 PARTY_CODE = V.PARTY_CODE,            
 EXCHANGE = V.EXCHANGE,            
 SEGMENT = V.SEGMENT,            
 SETT_NO = ISNULL(E.AMOUNT, 0),            
 SETT_TYPE = '',            
 BOOKTYPE = @BOOKTYPE,            
 MCLTCODE = V.MCLTCODE            
FROM            
 #MVDT V LEFT OUTER JOIN #MEDT E ON            
  V.PARTY_CODE = E.PARTY_CODE            
  AND V.MCLTCODE = E.MCLTCODE            
  AND V.EXCHANGE = E.EXCHANGE            
  AND V.SEGMENT = E.SEGMENT            
            
UPDATE            
 H            
SET            
 LNO = L.LNO            
FROM            
 #MARGINLEDGER H,            
 #LEDGER L            
WHERE            
 H.MCLTCODE = L.CLTCODE            
            
SELECT MCLTCODE, BALANCE = SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END) INTO #SUMMARGIN FROM #MARGINLEDGER GROUP BY MCLTCODE            
SELECT L.CLTCODE, BALANCE = SUM(CASE WHEN L.DRCR = 'D' THEN L.VAMT ELSE -L.VAMT END) INTO #SUMLEDGER FROM #LEDGER L, #SUMMARGIN M            
WHERE L.CLTCODE = M.MCLTCODE  GROUP BY L.CLTCODE            
DECLARE @ISDIFF INT            
SET @ISDIFF = 0            
SELECT            
 @ISDIFF = ISNULL(COUNT(1), 0) FROM #SUMMARGIN M, #SUMLEDGER L            
WHERE            
 M.MCLTCODE = L.CLTCODE            
 AND M.BALANCE <> L.BALANCE            
            
/*IF @ISDIFF <> 0            
 BEGIN            
  DROP TABLE #LEDGER            
  DROP TABLE #MARGINLEDGER            
  SELECT ERRNO = 1, ERRMSG = 'MARGIN BALANCE DOES NOT MATCH.'            
 END            
ELSE            
 BEGIN  */          
  INSERT INTO LEDGER SELECT * FROM #LEDGER            
  INSERT INTO LEDGER3 SELECT LNO, NARRATION, REFNO = '', VTYP, VNO, BOOKTYPE FROM #LEDGER            
  INSERT INTO MARGINLEDGER SELECT * FROM #MARGINLEDGER            
  ---EXEC BR_YEAREND  @SDTCUR, @LDTCUR, @VTYP, @VNO, @BOOKTYPE, @VDT, @PNL_CODE            
  DROP TABLE #LEDGER            
  DROP TABLE #MARGINLEDGER            
  SELECT ERRNO = 0, ERRMSG = 'OPENING BALANCES CALCULATED SUCCESSFULLY'            
-- END

GO
