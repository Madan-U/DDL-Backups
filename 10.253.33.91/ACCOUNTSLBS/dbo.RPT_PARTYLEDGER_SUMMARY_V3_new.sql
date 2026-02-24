-- Object: PROCEDURE dbo.RPT_PARTYLEDGER_SUMMARY_V3_new
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE  PROC [dbo].[RPT_PARTYLEDGER_SUMMARY_V3_new]      
 @FDATE VARCHAR(11),      
 @TDATE VARCHAR(11),      
 @STDDATE VARCHAR(11),      
 @LSTDATE VARCHAR(11),      
 @STATUSID VARCHAR(20),      
 @STATUSNAME VARCHAR(20),      
 @DISPLAYRPT VARCHAR(3),      
 @FPARTY VARCHAR(10),      
 @TPARTY VARCHAR(10),      
 @REPORTNAME VARCHAR(100),    
 @SESSIONID VARCHAR(10)       
-- @SPID INT ,   
      
AS      
      
DECLARE      
@@SQL AS VARCHAR(2000),      
@@RECCOUNTER AS NUMERIC,      
@@SHAREDB AS VARCHAR(25),      
@@OBJID AS INT      
  
    
SELECT @@OBJID = ISNULL(OBJECT_ID('NEWPARTYLEDGER1'), 0)      
IF @@OBJID = 0      
 BEGIN      
  EXEC CREATEPARTYLEDGER_new      
 END      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
DELETE FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
    
      
SELECT TOP 1 @@SHAREDB = SHAREDB FROM OWNER      
      
IF @REPORTNAME = 'BRANCH'      
 BEGIN      
  IF @STATUSID = 'BROKER' OR @STATUSID = 'BRANCH' OR @STATUSID = 'AREA' OR @STATUSID = 'REGION'      
   BEGIN      
 PRINT CONVERT(VARCHAR,@@SPID)  
    --INSERT LEDGER RECORDS      
    SELECT @@SQL = "INSERT INTO NEWPARTYLEDGER1 (BRANCH_CODE, BRANCH, VAMT, UNREALISED, VDT, EDT, SPID , SESSIONID) "      
    SELECT @@SQL = @@SQL + "SELECT C.BRANCH_CD, B.BRANCH, CASE WHEN DRCR = 'C' THEN ISNULL(L.VAMT, 0) ELSE -ISNULL(L.VAMT, 0) END AS VAMT, "      
    SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
    /*IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "CASE WHEN VDT <= '" + @TDATE + " 23:59:59' AND EDT > '" + @TDATE + " 23:59:59' THEN CASE WHEN DRCR = 'C' THEN ISNULL(L.VAMT, 0) ELSE -ISNULL(L.VAMT, 0) END ELSE 0 END AS UNREALISED, "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
     END    */  
    
    SELECT @@SQL = @@SQL + "L.VDT, L.EDT, " + CONVERT(VARCHAR,@@SPID) + ", " + @SESSIONID     
       
    SELECT @@SQL = @@SQL + "FROM " + @@SHAREDB + ".DBO.CLIENT1 C, LEDGER L, " + @@SHAREDB + ".DBO.BRANCH B "      
    SELECT @@SQL = @@SQL + "WHERE C.CL_CODE = L.CLTCODE "      
    SELECT @@SQL = @@SQL + "AND C.BRANCH_CD = B.BRANCH_CODE "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.VDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.EDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    IF @STATUSID = 'BROKER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
     END      
    ELSE IF @STATUSID = 'AREA'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
      SELECT @@SQL = @@SQL + "AND C.AREA = '" + @STATUSNAME + "'"      
     END      
    ELSE IF @STATUSID = 'REGION'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
      SELECT @@SQL = @@SQL + "AND C.REGION = '" + @STATUSNAME + "'"      
     END      
    ELSE IF @STATUSID = 'BRANCH'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD = '" + @STATUSNAME + "'"      
     END      
  
 SELECT @@SQL = @@SQL + "INSERT INTO NEWPARTYLEDGER1 (BRANCH_CODE, BRANCH, VAMT, UNREALISED, VDT, EDT, SPID , SESSIONID) "      
    SELECT @@SQL = @@SQL + "SELECT C.BRANCH_CD, B.BRANCH, VAMT = 0, "      
 IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "CASE WHEN VDT <= '" + @TDATE + " 23:59:59' AND EDT > '" + @TDATE + " 23:59:59' THEN CASE WHEN DRCR = 'C' THEN ISNULL(L.VAMT, 0) ELSE -ISNULL(L.VAMT, 0) END ELSE 0 END AS UNREALISED, "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
     END      
    
    SELECT @@SQL = @@SQL + "L.VDT, L.EDT, " + CONVERT(VARCHAR,@@SPID) + ", " + @SESSIONID     
       
    SELECT @@SQL = @@SQL + "FROM " + @@SHAREDB + ".DBO.CLIENT1 C, LEDGER L, " + @@SHAREDB + ".DBO.BRANCH B "      
    SELECT @@SQL = @@SQL + "WHERE C.CL_CODE = L.CLTCODE "      
    SELECT @@SQL = @@SQL + "AND C.BRANCH_CD = B.BRANCH_CODE "      
    /*IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.VDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.EDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END    */  
    IF @STATUSID = 'BROKER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
     END      
    ELSE IF @STATUSID = 'AREA'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
      SELECT @@SQL = @@SQL + "AND C.AREA = '" + @STATUSNAME + "'"      
     END      
    ELSE IF @STATUSID = 'REGION'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
      SELECT @@SQL = @@SQL + "AND C.REGION = '" + @STATUSNAME + "'"      
     END      
    ELSE IF @STATUSID = 'BRANCH'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD = '" + @STATUSNAME + "'"      
     END    
    EXEC (@@SQL)      
        
    --INSERT MARGINLEDGER RECORDS      
    SELECT @@SQL = "INSERT INTO NEWPARTYLEDGER1 (BRANCH_CODE, BRANCH, MAMT, UNREALISED, VDT, EDT, SPID, SESSIONID) "      
    SELECT @@SQL = @@SQL + "SELECT C.BRANCH_CD, B.BRANCH, CASE WHEN M.DRCR = 'C' THEN ISNULL(M.AMOUNT, 0) ELSE -ISNULL(M.AMOUNT, 0) END AS MAMT, "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "CASE WHEN L.VDT <= '" + @TDATE + " 23:59:59' AND L.EDT > '" + @TDATE + " 23:59:59' THEN CASE WHEN M.DRCR = 'C' THEN ISNULL(M.AMOUNT, 0) ELSE -ISNULL(M.AMOUNT, 0) END ELSE 0 END AS UNREALISED, "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
     END      
    
    SELECT @@SQL = @@SQL + "L.VDT, L.EDT, " + CONVERT(VARCHAR,@@SPID) + ", " + @SESSIONID     
    
   SELECT @@SQL = @@SQL + "FROM " + @@SHAREDB + ".DBO.CLIENT1 C, MARGINLEDGER M, LEDGER L, " + @@SHAREDB + ".DBO.BRANCH B "      
    SELECT @@SQL = @@SQL + "WHERE C.CL_CODE = L.CLTCODE "      
    SELECT @@SQL = @@SQL + "AND C.BRANCH_CD = B.BRANCH_CODE "      
    SELECT @@SQL = @@SQL + "AND M.VNO = L.VNO AND M.VTYP = L.VTYP AND M.BOOKTYPE = L.BOOKTYPE AND M.LNO = L.LNO "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND M.VDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.EDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    IF @STATUSID = 'BROKER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
     END      
    ELSE IF @STATUSID = 'AREA'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
      SELECT @@SQL = @@SQL + "AND C.AREA = '" + @STATUSNAME + "'"      
     END      
    ELSE IF @STATUSID = 'REGION'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
      SELECT @@SQL = @@SQL + "AND C.REGION = '" + @STATUSNAME + "'"      
     END      
    ELSE IF @STATUSID = 'BRANCH'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD = '" + @STATUSNAME + "'"      
     END      
    PRINT @@SQL      
    EXEC (@@SQL)      
-------------------------------------------------------------------------------        
    IF @DISPLAYRPT = 'EDT'      
     BEGIN      
      --DELETING OVERLAPING ENTRIES OF EFFECTIVE DATE ACCROSS THE YEAR      
      --INSTEAD OF GIVING REVERSAL EFFECT      
      --THIS SAVES UNION JOIN      
      SELECT @@SQL = "DELETE FROM NEWPARTYLEDGER1 WHERE VDT < '" + @STDDATE + "' AND EDT >= '" + @STDDATE + "' "      
      SELECT @@SQL = @@SQL + "AND SPID = @@SPID"      
      EXEC (@@SQL)      
-----------------------------------------      
     END      
    SELECT @@RECCOUNTER = ISNULL(COUNT(*), 0) FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
    IF @@RECCOUNTER <= 0      
     BEGIN      
      SELECT BRANCH_CODE, BRANCH,SECTORAMOUNT = 0, LEDGERAMOUNT = 0,SECTORMARGIN =0 ,MARGINAMOUNT = 0,SECTORUNREALISED = 0, UNREALISED = 0, SECTORTOTAL= 0,HTOTAL = 0,SESSIONID      
      FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
      DELETE FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
      RETURN      
     END      
    SELECT @@SQL = "SELECT BRANCH_CODE, BRANCH,ISNULL(SUM(VAMT), 0) AS SECTORAMOUNT, ISNULL(SUM(VAMT), 0) AS LEDGERAMOUNT,ISNULL(SUM(MAMT), 0) AS SECTORMARGIN ,ISNULL(SUM(MAMT), 0) AS MARGINAMOUNT"      
    SELECT @@SQL = @@SQL + ",  ISNULL(SUM(UNREALISED), 0) AS SECTORUNREALISED,ISNULL(SUM(UNREALISED), 0) AS UNREALISED "      
    SELECT @@SQL = @@SQL + ",ISNULL(SUM(VAMT + MAMT), 0) AS SECTORTOTAL, ISNULL(SUM(VAMT + MAMT), 0) AS HTOTAL , SESSIONID "      
    SELECT @@SQL = @@SQL + "FROM NEWPARTYLEDGER1 "      
    SELECT @@SQL = @@SQL + "WHERE SPID = @@SPID "      
    SELECT @@SQL = @@SQL + "GROUP BY BRANCH_CODE, BRANCH , SESSIONID "      
    SELECT @@SQL = @@SQL + "ORDER BY BRANCH_CODE, BRANCH "      
    --SELECT @@SQL = @@SQL + "COMPUTE SUM(ISNULL(SUM(VAMT), 0)), SUM(ISNULL(SUM(MAMT), 0)) "      
/*    IF @DISPLAYRPT = 'VDT'      
     BEGIN*/      
--      SELECT @@SQL = @@SQL + ", SUM(ISNULL(SUM(UNREALISED), 0)) "      
--     END      
--    SELECT @@SQL = @@SQL + ", SUM(ISNULL(SUM(VAMT + MAMT), 0)) "      
    PRINT @@SQL      
    EXEC (@@SQL)      
-----------------------------------------      
    DELETE FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
   END      
  ELSE      
   BEGIN      
    PRINT 'THE COMBINATION OF LOGIN AND REPORT NOT ALLOWED'      
    SELECT * FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
   END      
 END      
      
IF @REPORTNAME = 'AREA'      
 BEGIN      
  IF @STATUSID = 'AREA' OR @STATUSID = 'BROKER' OR @STATUSID = 'REGION'      
   BEGIN      
    --INSERTING NORMAL LEDGER RECORDS      
    SELECT @@SQL = "INSERT INTO NEWPARTYLEDGER1 (AREA, BRANCH, VAMT, UNREALISED, VDT, EDT, SPID , SESSIONID ) "      
    SELECT @@SQL = @@SQL + "SELECT A.AREACODE, A.DESCRIPTION, CASE WHEN DRCR = 'C' THEN ISNULL(L.VAMT, 0) ELSE -ISNULL(L.VAMT, 0) END AS VAMT, "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "CASE WHEN L.VDT <= '" + @TDATE + " 23:59:59' AND L.EDT > '" + @TDATE + " 23:59:59' THEN CASE WHEN DRCR = 'C' THEN ISNULL(L.VAMT, 0) ELSE -ISNULL(L.VAMT, 0) END ELSE 0 END AS UNREALISED, "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
     END      
    
    SELECT @@SQL = @@SQL + "L.VDT, L.EDT, " + CONVERT(VARCHAR,@@SPID) + ", " + @SESSIONID     
    
    
    SELECT @@SQL = @@SQL + "FROM " + @@SHAREDB + ".DBO.CLIENT1 C, LEDGER L, " + @@SHAREDB + ".DBO.AREA A "      
    SELECT @@SQL = @@SQL + "WHERE C.CL_CODE = L.CLTCODE "      
    SELECT @@SQL = @@SQL + "AND C.AREA = A.AREACODE AND C.BRANCH_CD = A.BRANCH_CODE "      
    SELECT @@SQL = @@SQL + "AND C.AREA BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.VDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.EDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    IF @STATUSID = 'AREA'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.AREA = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'REGION'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.REGION = '" + @STATUSNAME + "' "      
     END      
    PRINT (@@SQL)      
    EXEC (@@SQL)      
        
    --INSERTING MARGIN LEDGER RECORDS      
    SELECT @@SQL = "INSERT INTO NEWPARTYLEDGER1 (AREA, BRANCH, MAMT, UNREALISED, VDT, EDT, SPID , SESSIONID) "      
    SELECT @@SQL = @@SQL + "SELECT A.AREACODE, A.DESCRIPTION, "      
    SELECT @@SQL = @@SQL + "(CASE WHEN M.DRCR = 'C' THEN ISNULL(M.AMOUNT, 0) ELSE -ISNULL(M.AMOUNT, 0) END) AS MAMT, "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "(CASE WHEN L.VDT <= '" + @TDATE + " 23:59:59' AND L.EDT > '" + @TDATE + " 23:59:59' THEN (CASE WHEN M.DRCR = 'C' THEN ISNULL(M.AMOUNT, 0) ELSE -ISNULL(M.AMOUNT, 0) END) ELSE 0 END ) AS UNREALISED, "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
     END      
    
    SELECT @@SQL = @@SQL + "L.VDT, L.EDT, " + CONVERT(VARCHAR,@@SPID) + ", " + @SESSIONID     
    
    
    SELECT @@SQL = @@SQL + "FROM " + @@SHAREDB + ".DBO.CLIENT1 C, MARGINLEDGER M, " + @@SHAREDB + ".DBO.AREA A, "      
    SELECT @@SQL = @@SQL + "LEDGER L "      
    SELECT @@SQL = @@SQL + "WHERE C.CL_CODE = M.PARTY_CODE "      
    SELECT @@SQL = @@SQL + "AND C.AREA = A.AREACODE AND C.BRANCH_CD = A.BRANCH_CODE "      
    SELECT @@SQL = @@SQL + "AND M.VNO = L.VNO AND M.VTYP = L.VTYP AND M.BOOKTYPE = L.BOOKTYPE AND M.LNO = L.LNO "      
    SELECT @@SQL = @@SQL + "AND C.AREA BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND M.VDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.EDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    IF @STATUSID = 'AREA'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.AREA = '" + @STATUSNAME + "' "      
     END      
    IF @STATUSID = 'REGION'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.REGION = '" + @STATUSNAME + "' "      
     END      
        
    PRINT (@@SQL)      
    EXEC (@@SQL)      
        
    IF @DISPLAYRPT = 'EDT'      
     BEGIN      
      --DELETING OVERLAPING ENTRIES OF EFFECTIVE DATE ACCROSS THE YEAR      
      --INSTEAD OF GIVING REVERSAL EFFECT      
      --THIS SAVES UNION JOIN      
      SELECT @@SQL = "DELETE FROM NEWPARTYLEDGER1 WHERE VDT < '" + @STDDATE + "' AND EDT >= '" + @STDDATE + "' "      
      SELECT @@SQL = @@SQL + "AND SPID = @@SPID"      
      EXEC (@@SQL)      
     END      
    SELECT @@RECCOUNTER = ISNULL(COUNT(*), 0) FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
    IF @@RECCOUNTER <= 0      
     BEGIN      
      SELECT AREA, BRANCH AS AREANAME,SECTORAMOUNT = 0, LEDGERAMOUNT = 0,SECTORMARGIN =0 ,MARGINAMOUNT = 0,SECTORUNREALISED = 0, UNREALISED = 0, SECTORTOTAL= 0,HTOTAL = 0 ,SESSIONID          
      FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
      DELETE FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
      RETURN      
     END      
      
    SELECT @@SQL = "SELECT AREA, BRANCH,ISNULL(SUM(VAMT), 0) AS SECTORAMOUNT, ISNULL(SUM(VAMT), 0) AS LEDGERAMOUNT,ISNULL(SUM(MAMT), 0) AS SECTORMARGIN ,ISNULL(SUM(MAMT), 0) AS MARGINAMOUNT"      
    SELECT @@SQL = @@SQL + ",  ISNULL(SUM(UNREALISED), 0) AS SECTORUNREALISED,ISNULL(SUM(UNREALISED), 0) AS UNREALISED "      
    SELECT @@SQL = @@SQL + ",ISNULL(SUM(VAMT + MAMT), 0) AS SECTORTOTAL, ISNULL(SUM(VAMT + MAMT), 0) AS HTOTAL, SESSIONID "      
    SELECT @@SQL = @@SQL + "FROM NEWPARTYLEDGER1 "      
      
          
    SELECT @@SQL = @@SQL + "WHERE SPID = @@SPID "      
    SELECT @@SQL = @@SQL + "GROUP BY AREA, BRANCH, SESSIONID "      
    SELECT @@SQL = @@SQL + "ORDER BY AREA, BRANCH "      
    --SELECT @@SQL = @@SQL + "COMPUTE SUM(ISNULL(SUM(VAMT), 0)), SUM(ISNULL(SUM(MAMT), 0)), "      
/*    IF @DISPLAYRPT = 'VDT'      
     BEGIN*/      
--      SELECT @@SQL = @@SQL + "SUM(ISNULL(SUM(UNREALISED), 0)), "      
--     END      
--    SELECT @@SQL = @@SQL + "SUM(ISNULL(SUM(VAMT + MAMT), 0)) "      
    PRINT (@@SQL)      
    EXEC (@@SQL)      
    DELETE FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
   END      
  ELSE      
   BEGIN      
  PRINT 'THE COMBINATION OF LOGIN AND REPORT NOT ALLOWED'      
    SELECT * FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
   END      
 END      
      
IF @REPORTNAME = 'REGION'      
 BEGIN      
  IF @STATUSID = 'AREA' OR @STATUSID = 'BROKER' OR @STATUSID = 'REGION'      
   BEGIN      
    --INSERTING NORMAL LEDGER RECORDS      
    SELECT @@SQL = "INSERT INTO NEWPARTYLEDGER1 (REGION, BRANCH, VAMT, UNREALISED, VDT, EDT, SPID, SESSIONID) "      
    SELECT @@SQL = @@SQL + "SELECT R.REGIONCODE, R.DESCRIPTION, CASE WHEN DRCR = 'C' THEN ISNULL(L.VAMT, 0) ELSE -ISNULL(L.VAMT, 0) END AS VAMT, "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL +   "CASE WHEN L.VDT <= '" + @TDATE + " 23:59:59' AND L.EDT > '" + @TDATE + " 23:59:59' THEN CASE WHEN DRCR = 'C' THEN ISNULL(L.VAMT, 0) ELSE -ISNULL(L.VAMT, 0) END ELSE 0 END AS UNREALISED, "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
     END      
    
    SELECT @@SQL = @@SQL + "L.VDT, L.EDT, " + CONVERT(VARCHAR,@@SPID) + ", " + @SESSIONID     
     
    SELECT @@SQL = @@SQL + "FROM " + @@SHAREDB + ".DBO.CLIENT1 C, LEDGER L, " + @@SHAREDB + ".DBO.REGION R "      
    SELECT @@SQL = @@SQL + "WHERE C.CL_CODE = L.CLTCODE "      
    SELECT @@SQL = @@SQL + "AND C.REGION = R.REGIONCODE AND C.BRANCH_CD = R.BRANCH_CODE "      
    SELECT @@SQL = @@SQL + "AND C.REGION BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.VDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.EDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    IF @STATUSID = 'AREA'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.AREA = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'REGION'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.REGION = '" + @STATUSNAME + "' "      
     END      
    PRINT (@@SQL)      
    EXEC (@@SQL)      
     
    --INSERTING MARGIN LEDGER RECORDS      
    SELECT @@SQL = "INSERT INTO NEWPARTYLEDGER1 (REGION, BRANCH, MAMT, UNREALISED, VDT, EDT, SPID, SESSIONID) "      
    SELECT @@SQL = @@SQL + "SELECT R.REGIONCODE, R.DESCRIPTION, "      
    SELECT @@SQL = @@SQL + "(CASE WHEN M.DRCR = 'C' THEN ISNULL(M.AMOUNT, 0) ELSE -ISNULL(M.AMOUNT, 0) END) AS MAMT, "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "(CASE WHEN L.VDT <= '" + @TDATE + " 23:59:59' AND L.EDT > '" + @TDATE + " 23:59:59' THEN (CASE WHEN M.DRCR = 'C' THEN ISNULL(M.AMOUNT, 0) ELSE -ISNULL(M.AMOUNT, 0) END) ELSE 0 END ) AS UNREALISED, "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
     END      
     
    SELECT @@SQL = @@SQL + "L.VDT, L.EDT, " + CONVERT(VARCHAR,@@SPID) + ", " + @SESSIONID     
  
    SELECT @@SQL = @@SQL + "FROM " + @@SHAREDB + ".DBO.CLIENT1 C, MARGINLEDGER M, " + @@SHAREDB + ".DBO.REGION R, "      
    SELECT @@SQL = @@SQL + "LEDGER L "      
    SELECT @@SQL = @@SQL + "WHERE C.CL_CODE = M.PARTY_CODE "      
    SELECT @@SQL = @@SQL + "AND C.REGION = R.REGIONCODE AND C.BRANCH_CD = R.BRANCH_CODE "      
    SELECT @@SQL = @@SQL + "AND M.VNO = L.VNO AND M.VTYP = L.VTYP AND M.BOOKTYPE = L.BOOKTYPE AND M.LNO = L.LNO "      
    SELECT @@SQL = @@SQL + "AND C.REGION BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND M.VDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.EDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    IF @STATUSID = 'AREA'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.AREA = '" + @STATUSNAME + "' "      
     END      
    IF @STATUSID = 'REGION'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.REGION = '" + @STATUSNAME + "' "      
     END      
        
    PRINT (@@SQL)      
    EXEC (@@SQL)      
        
    IF @DISPLAYRPT = 'EDT'      
     BEGIN      
      
      --DELETING OVERLAPING ENTRIES OF EFFECTIVE DATE ACCROSS THE YEAR      
      --INSTEAD OF GIVING REVERSAL EFFECT      
      --THIS SAVES UNION JOIN      
      SELECT @@SQL = "DELETE FROM NEWPARTYLEDGER1 WHERE VDT < '" + @STDDATE + "' AND EDT >= '" + @STDDATE + "' "      
      SELECT @@SQL = @@SQL + "AND SPID = @@SPID"      
      EXEC (@@SQL)      
     END      
    SELECT @@RECCOUNTER = ISNULL(COUNT(*), 0) FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
    IF @@RECCOUNTER <= 0      
     BEGIN      
      SELECT REGION, BRANCH AS REGIONNAME, SECTORAMOUNT = 0, LEDGERAMOUNT = 0,SECTORMARGIN =0 ,MARGINAMOUNT = 0,SECTORUNREALISED = 0, UNREALISED = 0, SECTORTOTAL= 0,HTOTAL = 0,SESSIONID          
       FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
      DELETE FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
      RETURN      
     END      
   SELECT @@SQL = "SELECT REGION, BRANCH,ISNULL(SUM(VAMT), 0) AS SECTORAMOUNT, ISNULL(SUM(VAMT), 0) AS LEDGERAMOUNT,ISNULL(SUM(MAMT), 0) AS SECTORMARGIN ,ISNULL(SUM(MAMT), 0) AS MARGINAMOUNT"      
    SELECT @@SQL = @@SQL + ",  ISNULL(SUM(UNREALISED), 0) AS SECTORUNREALISED,ISNULL(SUM(UNREALISED), 0) AS UNREALISED "      
    SELECT @@SQL = @@SQL + ",ISNULL(SUM(VAMT + MAMT), 0) AS SECTORTOTAL, ISNULL(SUM(VAMT + MAMT), 0) AS HTOTAL, SESSIONID "      
    SELECT @@SQL = @@SQL + "FROM NEWPARTYLEDGER1 "      
    SELECT @@SQL = @@SQL + "WHERE SPID = @@SPID "      
    SELECT @@SQL = @@SQL + "GROUP BY REGION, BRANCH, SESSIONID "      
    SELECT @@SQL = @@SQL + "ORDER BY REGION, BRANCH "      
    --SELECT @@SQL = @@SQL + "COMPUTE SUM(ISNULL(SUM(VAMT), 0)), SUM(ISNULL(SUM(MAMT), 0)), "      
/*    IF @DISPLAYRPT = 'VDT'      
     BEGIN*/      
    --  SELECT @@SQL = @@SQL + "SUM(ISNULL(SUM(UNREALISED), 0)), "      
--     END      
    --SELECT @@SQL = @@SQL + "SUM(ISNULL(SUM(VAMT + MAMT), 0)) "      
    PRINT (@@SQL)      
    EXEC (@@SQL)      
    DELETE FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
   END      
  ELSE      
   BEGIN      
    PRINT 'THE COMBINATION OF LOGIN AND REPORT NOT ALLOWED'      
    SELECT * FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
   END      
 END      
      
IF @REPORTNAME = 'SUBBROKER'      
 BEGIN      
  IF @STATUSID = 'AREA' OR @STATUSID = 'BROKER' OR @STATUSID = 'REGION' OR @STATUSID = 'SUBBROKER' OR @STATUSID = 'TRADER' OR @STATUSID = 'BRANCH'      
   BEGIN      
    --INSERTING NORMAL LEDGER RECORDS      
    SELECT @@SQL = "INSERT INTO NEWPARTYLEDGER1 (SUB_BROKER, BRANCH, VAMT, UNREALISED, VDT, EDT, SPID, SESSIONID) "      
    SELECT @@SQL = @@SQL + "SELECT S.SUB_BROKER, S.NAME, CASE WHEN DRCR = 'C' THEN ISNULL(L.VAMT, 0) ELSE -ISNULL(L.VAMT, 0) END AS VAMT, "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "CASE WHEN L.VDT <= '" + @TDATE + " 23:59:59' AND L.EDT > '" + @TDATE + " 23:59:59' THEN CASE WHEN DRCR = 'C' THEN ISNULL(L.VAMT, 0) ELSE -ISNULL(L.VAMT, 0) END ELSE 0 END AS UNREALISED, "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
     END      
    
    SELECT @@SQL = @@SQL + "L.VDT, L.EDT, " + CONVERT(VARCHAR,@@SPID) + ", " + @SESSIONID     
    
    SELECT @@SQL = @@SQL + "FROM " + @@SHAREDB + ".DBO.CLIENT1 C, LEDGER L, " + @@SHAREDB + ".DBO.SUBBROKERS S "      
    SELECT @@SQL = @@SQL + "WHERE C.CL_CODE = L.CLTCODE "      
    SELECT @@SQL = @@SQL + "AND C.SUB_BROKER = S.SUB_BROKER "      
    SELECT @@SQL = @@SQL + "AND C.SUB_BROKER BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.VDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.EDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    IF @STATUSID = 'AREA'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.AREA = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'REGION'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.REGION = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'BRANCH'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'SUBBROKER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.SUB_BROKER = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'TRADER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.TRADER = '" + @STATUSNAME + "' "      
     END      
    PRINT (@@SQL)      
    EXEC (@@SQL)      
        
    --INSERTING MARGIN LEDGER RECORDS      
    SELECT @@SQL = "INSERT INTO NEWPARTYLEDGER1 (SUB_BROKER, BRANCH, MAMT, UNREALISED, VDT, EDT, SPID, SESSIONID) "      
    SELECT @@SQL = @@SQL + "SELECT S.SUB_BROKER, S.NAME, "      
    SELECT @@SQL = @@SQL + "(CASE WHEN M.DRCR = 'C' THEN ISNULL(M.AMOUNT, 0) ELSE -ISNULL(M.AMOUNT, 0) END) AS MAMT, "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "(CASE WHEN L.VDT <= '" + @TDATE + " 23:59:59' AND L.EDT > '" + @TDATE + " 23:59:59' THEN (CASE WHEN M.DRCR = 'C' THEN ISNULL(M.AMOUNT, 0) ELSE -ISNULL(M.AMOUNT, 0) END) ELSE 0 END ) AS UNREALISED, "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
     END      
    
    SELECT @@SQL = @@SQL + "L.VDT, L.EDT, " + CONVERT(VARCHAR,@@SPID) + ", " + @SESSIONID     
    
    SELECT @@SQL = @@SQL + "FROM " + @@SHAREDB + ".DBO.CLIENT1 C, MARGINLEDGER M, " + @@SHAREDB + ".DBO.SUBBROKERS S, "      
    SELECT @@SQL = @@SQL + "LEDGER L "      
    SELECT @@SQL = @@SQL + "WHERE C.CL_CODE = M.PARTY_CODE "      
    SELECT @@SQL = @@SQL + "AND C.SUB_BROKER = S.SUB_BROKER "      
    SELECT @@SQL = @@SQL + "AND M.VNO = L.VNO AND M.VTYP = L.VTYP AND M.BOOKTYPE = L.BOOKTYPE AND M.LNO = L.LNO "      
    SELECT @@SQL = @@SQL + "AND C.SUB_BROKER BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND M.VDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.EDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    IF @STATUSID = 'AREA'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.AREA = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'REGION'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.REGION = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'BRANCH'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'SUBBROKER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.SUB_BROKER = '" + @STATUSNAME + "' "      
     END      
        
    PRINT (@@SQL)      
    EXEC (@@SQL)      
        
    IF @DISPLAYRPT = 'EDT'      
     BEGIN      
      --DELETING OVERLAPING ENTRIES OF EFFECTIVE DATE ACCROSS THE YEAR      
      --INSTEAD OF GIVING REVERSAL EFFECT      
      --THIS SAVES UNION JOIN      
      SELECT @@SQL = "DELETE FROM NEWPARTYLEDGER1 WHERE VDT < '" + @STDDATE + "' AND EDT >= '" + @STDDATE + "' "      
      SELECT @@SQL = @@SQL + "AND SPID = @@SPID"      
      EXEC (@@SQL)      
     END      
    SELECT @@RECCOUNTER = ISNULL(COUNT(*), 0) FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
    IF @@RECCOUNTER <= 0      
     BEGIN      
      SELECT SUB_BROKER, BRANCH AS SUBNAME, SECTORAMOUNT = 0, LEDGERAMOUNT = 0,SECTORMARGIN =0 ,MARGINAMOUNT = 0,SECTORUNREALISED = 0, UNREALISED = 0, SECTORTOTAL= 0,HTOTAL = 0 ,SESSIONID      
      FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
      DELETE FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
      RETURN      
     END      
   SELECT @@SQL = "SELECT SUB_BROKER, BRANCH,ISNULL(SUM(VAMT), 0) AS SECTORAMOUNT, ISNULL(SUM(VAMT), 0) AS LEDGERAMOUNT,ISNULL(SUM(MAMT), 0) AS SECTORMARGIN ,ISNULL(SUM(MAMT), 0) AS MARGINAMOUNT"      
    SELECT @@SQL = @@SQL + ",  ISNULL(SUM(UNREALISED), 0) AS SECTORUNREALISED,ISNULL(SUM(UNREALISED), 0) AS UNREALISED "      
    SELECT @@SQL = @@SQL + ",ISNULL(SUM(VAMT + MAMT), 0) AS SECTORTOTAL, ISNULL(SUM(VAMT + MAMT), 0) AS HTOTAL, SESSIONID "      
    SELECT @@SQL = @@SQL + "FROM NEWPARTYLEDGER1 "      
    SELECT @@SQL = @@SQL + "WHERE SPID = @@SPID "      
    SELECT @@SQL = @@SQL + "GROUP BY SUB_BROKER, BRANCH, SESSIONID "      
    SELECT @@SQL = @@SQL + "ORDER BY SUB_BROKER, BRANCH "      
   -- SELECT @@SQL = @@SQL + "COMPUTE SUM(ISNULL(SUM(VAMT), 0)), SUM(ISNULL(SUM(MAMT), 0)), "      
/*    IF @DISPLAYRPT = 'VDT'      
     BEGIN*/      
    --  SELECT @@SQL = @@SQL + "SUM(ISNULL(SUM(UNREALISED), 0)), "      
--     END      
   -- SELECT @@SQL = @@SQL + "SUM(ISNULL(SUM(VAMT + MAMT), 0)) "      
    PRINT (@@SQL)      
    EXEC (@@SQL)      
    DELETE FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
   END      
  ELSE      
   BEGIN      
    PRINT 'THE COMBINATION OF LOGIN AND REPORT NOT ALLOWED'      
    SELECT * FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
   END      
 END      
      
IF @REPORTNAME = 'TRADER'      
 BEGIN      
  IF @STATUSID = 'AREA' OR @STATUSID = 'BROKER' OR @STATUSID = 'REGION' OR @STATUSID = 'SUBBROKER' OR @STATUSID = 'TRADER' OR @STATUSID = 'BRANCH'      
   BEGIN      
    --INSERTING NORMAL LEDGER RECORDS      
    SELECT @@SQL = "INSERT INTO NEWPARTYLEDGER1 (TRADER, BRANCH, VAMT, UNREALISED, VDT, EDT, SPID, SESSIONID) "      
    SELECT @@SQL = @@SQL + "SELECT T.SHORT_NAME, T.LONG_NAME, CASE WHEN DRCR = 'C' THEN ISNULL(L.VAMT, 0) ELSE -ISNULL(L.VAMT, 0) END AS VAMT, "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "CASE WHEN L.VDT <= '" + @TDATE + " 23:59:59' AND L.EDT > '" + @TDATE + " 23:59:59' THEN CASE WHEN DRCR = 'C' THEN ISNULL(L.VAMT, 0) ELSE -ISNULL(L.VAMT, 0) END ELSE 0 END AS UNREALISED, "      
     END      
    ELSE      
     BEGIN     
      SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
     END      
    
    SELECT @@SQL = @@SQL + "L.VDT, L.EDT, " + CONVERT(VARCHAR,@@SPID) + ", " + @SESSIONID     
    
    SELECT @@SQL = @@SQL + "FROM " + @@SHAREDB + ".DBO.CLIENT1 C, LEDGER L, " + @@SHAREDB + ".DBO.BRANCHES T "      
    SELECT @@SQL = @@SQL + "WHERE C.CL_CODE = L.CLTCODE "      
    SELECT @@SQL = @@SQL + "AND C.TRADER = T.SHORT_NAME AND C.BRANCH_CD = T.BRANCH_CD "      
    SELECT @@SQL = @@SQL + "AND C.TRADER BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.VDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.EDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    IF @STATUSID = 'AREA'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.AREA = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'REGION'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.REGION = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'BRANCH'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'SUBBROKER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.SUB_BROKER = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'TRADER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.TRADER = '" + @STATUSNAME + "' "      
     END      
    PRINT (@@SQL)      
    EXEC (@@SQL)      
        
    --INSERTING MARGIN LEDGER RECORDS      
    SELECT @@SQL = "INSERT INTO NEWPARTYLEDGER1 (TRADER, BRANCH, CLTCODE, ACNAME, MAMT, UNREALISED, VDT, EDT, SPID, SESSIONID) "      
    SELECT @@SQL = @@SQL + "SELECT T.SHORT_NAME, T.LONG_NAME, C.CL_CODE, C.LONG_NAME, "      
    SELECT @@SQL = @@SQL + "(CASE WHEN M.DRCR = 'C' THEN ISNULL(M.AMOUNT, 0) ELSE -ISNULL(M.AMOUNT, 0) END) AS MAMT, "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "(CASE WHEN L.VDT <= '" + @TDATE + " 23:59:59' AND L.EDT > '" + @TDATE + " 23:59:59' THEN (CASE WHEN M.DRCR = 'C' THEN ISNULL(M.AMOUNT, 0) ELSE -ISNULL(M.AMOUNT, 0) END) ELSE 0 END ) AS UNREALISED, "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
     END      
    
    SELECT @@SQL = @@SQL + "L.VDT, L.EDT, " + CONVERT(VARCHAR,@@SPID) + ", " + @SESSIONID     
    
    SELECT @@SQL = @@SQL + "FROM " + @@SHAREDB + ".DBO.CLIENT1 C, MARGINLEDGER M, " + @@SHAREDB + ".DBO.BRANCHES T, "      
    SELECT @@SQL = @@SQL + "LEDGER L "      
    SELECT @@SQL = @@SQL + "WHERE C.CL_CODE = M.PARTY_CODE "      
    SELECT @@SQL = @@SQL + "AND C.TRADER = T.SHORT_NAME AND C.BRANCH_CD = T.BRANCH_CD "      
    SELECT @@SQL = @@SQL + "AND M.VNO = L.VNO AND M.VTYP = L.VTYP AND M.BOOKTYPE = L.BOOKTYPE AND M.LNO = L.LNO "      
    SELECT @@SQL = @@SQL + "AND C.TRADER BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND M.VDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.EDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    IF @STATUSID = 'AREA'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.AREA = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'REGION'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.REGION = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'BRANCH'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'SUBBROKER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.SUB_BROKER = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'TRADER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.TRADER = '" + @STATUSNAME + "' "      
     END      
    
    PRINT (@@SQL)      
    EXEC (@@SQL)      
        
    IF @DISPLAYRPT = 'EDT'      
     BEGIN      
      --DELETING OVERLAPING ENTRIES OF EFFECTIVE DATE ACCROSS THE YEAR      
      --INSTEAD OF GIVING REVERSAL EFFECT      
      --THIS SAVES UNION JOIN      
      SELECT @@SQL = "DELETE FROM NEWPARTYLEDGER1 WHERE VDT < '" + @STDDATE + "' AND EDT >= '" + @STDDATE + "' "      
      SELECT @@SQL = @@SQL + "AND SPID = @@SPID"      
      EXEC (@@SQL)      
     END      
    SELECT @@RECCOUNTER = ISNULL(COUNT(*), 0) FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
    IF @@RECCOUNTER <= 0      
     BEGIN      
      SELECT TRADER, BRANCH AS TRADERNAME, SECTORAMOUNT = 0, LEDGERAMOUNT = 0,SECTORMARGIN =0 ,MARGINAMOUNT = 0,SECTORUNREALISED = 0, UNREALISED = 0, SECTORTOTAL= 0,HTOTAL = 0, SESSIONID       
      FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
      DELETE FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
      RETURN      
     END      
    SELECT @@SQL = "SELECT TRADER, BRANCH,ISNULL(SUM(VAMT), 0) AS SECTORAMOUNT, ISNULL(SUM(VAMT), 0) AS LEDGERAMOUNT,ISNULL(SUM(MAMT), 0) AS SECTORMARGIN ,ISNULL(SUM(MAMT), 0) AS MARGINAMOUNT"      
    SELECT @@SQL = @@SQL + ",  ISNULL(SUM(UNREALISED), 0) AS SECTORUNREALISED,ISNULL(SUM(UNREALISED), 0) AS UNREALISED "      
    SELECT @@SQL = @@SQL + ",ISNULL(SUM(VAMT + MAMT), 0) AS SECTORTOTAL, ISNULL(SUM(VAMT + MAMT), 0) AS HTOTAL, SESSIONID "      
    SELECT @@SQL = @@SQL + "FROM NEWPARTYLEDGER1 "      
    SELECT @@SQL = @@SQL + "WHERE SPID = @@SPID "      
    SELECT @@SQL = @@SQL + "GROUP BY TRADER, BRANCH, SESSIONID "      
    SELECT @@SQL = @@SQL + "ORDER BY TRADER, BRANCH "      
  --  SELECT @@SQL = @@SQL + "COMPUTE SUM(ISNULL(SUM(VAMT), 0)), SUM(ISNULL(SUM(MAMT), 0)), "      
/*    IF @DISPLAYRPT = 'VDT'      
     BEGIN*/      
  -- SELECT @@SQL = @@SQL + "SUM(ISNULL(SUM(UNREALISED), 0)), "      
--     END      
   -- SELECT @@SQL = @@SQL + "SUM(ISNULL(SUM(VAMT + MAMT), 0)) "      
    PRINT (@@SQL)      
    EXEC (@@SQL)      
    DELETE FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
   END      
  ELSE      
   BEGIN      
    PRINT 'THE COMBINATION OF LOGIN AND REPORT NOT ALLOWED'      
    SELECT * FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
   END      
 END      
      
IF @REPORTNAME = 'FAMILY'      
 BEGIN      
  IF @STATUSID = 'AREA' OR @STATUSID = 'BROKER' OR @STATUSID = 'REGION' OR @STATUSID = 'SUBBROKER' OR @STATUSID = 'TRADER' OR @STATUSID = 'FAMILY'      
   BEGIN      
    --INSERTING NORMAL LEDGER RECORDS      
    SELECT @@SQL = "INSERT INTO NEWPARTYLEDGER1 (FAMILY, BRANCH, VAMT, UNREALISED, VDT, EDT, SPID, SESSIONID) "      
    SELECT @@SQL = @@SQL + "SELECT F.FAMILY, F.FAMILYNAME, CASE WHEN DRCR = 'C' THEN ISNULL(L.VAMT, 0) ELSE -ISNULL(L.VAMT, 0) END AS VAMT, "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "CASE WHEN L.VDT <= '" + @TDATE + " 23:59:59' AND L.EDT > '" + @TDATE + " 23:59:59' THEN CASE WHEN DRCR = 'C' THEN ISNULL(L.VAMT, 0) ELSE -ISNULL(L.VAMT, 0) END ELSE 0 END AS UNREALISED, "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
     END      
    
    SELECT @@SQL = @@SQL + "L.VDT, L.EDT, " + CONVERT(VARCHAR,@@SPID) + ", " + @SESSIONID     
    
    SELECT @@SQL = @@SQL + "FROM " + @@SHAREDB + ".DBO.CLIENT1 C, LEDGER L, FAMILYMST F "      
    SELECT @@SQL = @@SQL + "WHERE C.CL_CODE = L.CLTCODE "      
    SELECT @@SQL = @@SQL + "AND C.FAMILY = F.FAMILY "      
    SELECT @@SQL = @@SQL + "AND C.FAMILY BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.VDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.EDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    IF @STATUSID = 'AREA'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.AREA = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'REGION'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.REGION = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'BRANCH'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'SUBBROKER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.SUB_BROKER = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'TRADER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.TRADER = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'FAMILY'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.FAMILY = '" + @STATUSNAME + "' "      
     END      
    PRINT (@@SQL)      
    EXEC (@@SQL)      
        
    --INSERTING MARGIN LEDGER RECORDS      
    SELECT @@SQL = "INSERT INTO NEWPARTYLEDGER1 (FAMILY, BRANCH, MAMT, UNREALISED, VDT, EDT, SPID, SESSIONID) "      
    SELECT @@SQL = @@SQL + "SELECT F.FAMILY, F.FAMILYNAME, "      
    SELECT @@SQL = @@SQL + "(CASE WHEN M.DRCR = 'C' THEN ISNULL(M.AMOUNT, 0) ELSE -ISNULL(M.AMOUNT, 0) END) AS MAMT, "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "(CASE WHEN L.VDT <= '" + @TDATE + " 23:59:59' AND L.EDT > '" + @TDATE + " 23:59:59' THEN (CASE WHEN M.DRCR = 'C' THEN ISNULL(M.AMOUNT, 0) ELSE -ISNULL(M.AMOUNT, 0) END) ELSE 0 END ) AS UNREALISED, "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
     END      
   
    SELECT @@SQL = @@SQL + "L.VDT, L.EDT, " + CONVERT(VARCHAR,@@SPID) + ", " + @SESSIONID     
   
    SELECT @@SQL = @@SQL + "FROM " + @@SHAREDB + ".DBO.CLIENT1 C, MARGINLEDGER M, FAMILYMST F, "      
    SELECT @@SQL = @@SQL + "LEDGER L "      
    SELECT @@SQL = @@SQL + "WHERE C.CL_CODE = M.PARTY_CODE "      
    SELECT @@SQL = @@SQL + "AND C.FAMILY = F.FAMILY "      
    SELECT @@SQL = @@SQL + "AND M.VNO = L.VNO AND M.VTYP = L.VTYP AND M.BOOKTYPE = L.BOOKTYPE AND M.LNO = L.LNO "      
    SELECT @@SQL = @@SQL + "AND C.FAMILY BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND M.VDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.EDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    IF @STATUSID = 'AREA'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.AREA = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'REGION'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.REGION = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'BRANCH'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'SUBBROKER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.SUB_BROKER = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'TRADER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.TRADER = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'FAMILY'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.FAMILY = '" + @STATUSNAME + "' "      
     END      
        
    PRINT (@@SQL)      
    EXEC (@@SQL)      
        
    IF @DISPLAYRPT = 'EDT'      
     BEGIN      
      --DELETING OVERLAPING ENTRIES OF EFFECTIVE DATE ACCROSS THE YEAR      
      --INSTEAD OF GIVING REVERSAL EFFECT      
      --THIS SAVES UNION JOIN      
      SELECT @@SQL = "DELETE FROM NEWPARTYLEDGER1 WHERE VDT < '" + @STDDATE + "' AND EDT >= '" + @STDDATE + "' "      
      SELECT @@SQL = @@SQL + "AND SPID = @@SPID"      
      EXEC (@@SQL)      
     END      
    SELECT @@RECCOUNTER = ISNULL(COUNT(*), 0) FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
    IF @@RECCOUNTER <= 0      
     BEGIN      
      SELECT FAMILY, BRANCH AS FAMILYNAME, SECTORAMOUNT = 0, LEDGERAMOUNT = 0,SECTORMARGIN =0 ,MARGINAMOUNT = 0,SECTORUNREALISED = 0, UNREALISED = 0, SECTORTOTAL= 0,HTOTAL = 0 ,SESSIONID           
      FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
      DELETE FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
      RETURN      
     END      
   SELECT @@SQL = "SELECT FAMILY, BRANCH,ISNULL(SUM(VAMT), 0) AS SECTORAMOUNT, ISNULL(SUM(VAMT), 0) AS LEDGERAMOUNT,ISNULL(SUM(MAMT), 0) AS SECTORMARGIN ,ISNULL(SUM(MAMT), 0) AS MARGINAMOUNT"      
    SELECT @@SQL = @@SQL + ",  ISNULL(SUM(UNREALISED), 0) AS SECTORUNREALISED,ISNULL(SUM(UNREALISED), 0) AS UNREALISED "      
    SELECT @@SQL = @@SQL + ",ISNULL(SUM(VAMT + MAMT), 0) AS SECTORTOTAL, ISNULL(SUM(VAMT + MAMT), 0) AS HTOTAL, SESSIONID "      
    SELECT @@SQL = @@SQL + "FROM NEWPARTYLEDGER1 "      
    SELECT @@SQL = @@SQL + "WHERE SPID = @@SPID "      
    SELECT @@SQL = @@SQL + "GROUP BY FAMILY, BRANCH, SESSIONID "      
    SELECT @@SQL = @@SQL + "ORDER BY FAMILY, BRANCH "      
    --SELECT @@SQL = @@SQL + "COMPUTE SUM(ISNULL(SUM(VAMT), 0)), SUM(ISNULL(SUM(MAMT), 0)), "      
/*    IF @DISPLAYRPT = 'VDT'      
     BEGIN*/      
    --  SELECT @@SQL = @@SQL + "SUM(ISNULL(SUM(UNREALISED), 0)), "      
--     END      
    --SELECT @@SQL = @@SQL + "SUM(ISNULL(SUM(VAMT + MAMT), 0)) "      
    PRINT (@@SQL)      
    EXEC (@@SQL)      
    DELETE FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
   END      
 END      
      
      
IF @REPORTNAME = 'PARTY'      
BEGIN      
  IF @STATUSID = 'BRANCH' OR @STATUSID = 'AREA' OR @STATUSID = 'BROKER' OR @STATUSID = 'REGION' OR @STATUSID = 'SUBBROKER' OR @STATUSID = 'TRADER' OR @STATUSID = 'FAMILY' OR @STATUSID = 'CLIENT'      
   BEGIN      
    --INSERTING NORMAL LEDGER RECORDS      
    SELECT @@SQL = "INSERT INTO NEWPARTYLEDGER1 (CLTCODE, BRANCH, VAMT, UNREALISED, VDT, EDT, SPID, SESSIONID) "      
    SELECT @@SQL = @@SQL + "SELECT C2.PARTY_CODE, C.LONG_NAME, CASE WHEN DRCR = 'C' THEN ISNULL(L.VAMT, 0) ELSE -ISNULL(L.VAMT, 0) END AS VAMT, "      
 SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
    /*IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "CASE WHEN L.VDT <= '" + @TDATE + " 23:59:59' AND L.EDT > '" + @TDATE + " 23:59:59' THEN CASE WHEN DRCR = 'C' THEN ISNULL(L.VAMT, 0) ELSE -ISNULL(L.VAMT, 0) END ELSE 0 END AS UNREALISED, "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
     END    */  
    
    SELECT @@SQL = @@SQL + "L.VDT, L.EDT, " + CONVERT(VARCHAR,@@SPID) + ", " + @SESSIONID     
    
    SELECT @@SQL = @@SQL + "FROM " + @@SHAREDB + ".DBO.CLIENT1 C, " + @@SHAREDB + ".DBO.CLIENT2 C2, LEDGER L "      
    SELECT @@SQL = @@SQL + "WHERE C.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = L.CLTCODE "      
    SELECT @@SQL = @@SQL + "AND C2.PARTY_CODE BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.VDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.EDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    IF @STATUSID = 'AREA'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.AREA = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'REGION'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.REGION = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'BRANCH'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'SUBBROKER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.SUB_BROKER = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'TRADER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.TRADER = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'FAMILY'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.FAMILY = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'CLIENT'     
    BEGIN      
      SELECT @@SQL = @@SQL + "AND C2.PARTY_CODE = '" + @STATUSNAME + "' "      
     END      
  
 SELECT @@SQL = @@SQL + "INSERT INTO NEWPARTYLEDGER1 (CLTCODE, BRANCH, VAMT, UNREALISED, VDT, EDT, SPID, SESSIONID) "      
    SELECT @@SQL = @@SQL + "SELECT C2.PARTY_CODE, C.LONG_NAME, VAMT = 0, "      
 IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "CASE WHEN L.VDT <= '" + @TDATE + " 23:59:59' AND L.EDT > '" + @TDATE + " 23:59:59' THEN CASE WHEN DRCR = 'C' THEN ISNULL(L.VAMT, 0) ELSE -ISNULL(L.VAMT, 0) END ELSE 0 END AS UNREALISED, "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
     END      
    
    SELECT @@SQL = @@SQL + "L.VDT, L.EDT, " + CONVERT(VARCHAR,@@SPID) + ", " + @SESSIONID     
    
    SELECT @@SQL = @@SQL + "FROM " + @@SHAREDB + ".DBO.CLIENT1 C, " + @@SHAREDB + ".DBO.CLIENT2 C2, LEDGER L "      
    SELECT @@SQL = @@SQL + "WHERE C.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = L.CLTCODE "      
    SELECT @@SQL = @@SQL + "AND C2.PARTY_CODE BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
    /*IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.VDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.EDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END    */  
    IF @STATUSID = 'AREA'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.AREA = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'REGION'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.REGION = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'BRANCH'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'SUBBROKER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.SUB_BROKER = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'TRADER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.TRADER = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'FAMILY'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.FAMILY = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'CLIENT'     
    BEGIN      
      SELECT @@SQL = @@SQL + "AND C2.PARTY_CODE = '" + @STATUSNAME + "' "      
     END      
    PRINT (@@SQL)      
    EXEC (@@SQL)      
        
    --INSERTING MARGIN LEDGER RECORDS      
    SELECT @@SQL = "INSERT INTO NEWPARTYLEDGER1 (CLTCODE, BRANCH, MAMT, UNREALISED, VDT, EDT, SPID, SESSIONID) "      
    SELECT @@SQL = @@SQL + "SELECT C2.PARTY_CODE, C.LONG_NAME, "      
    SELECT @@SQL = @@SQL + "(CASE WHEN M.DRCR = 'C' THEN ISNULL(M.AMOUNT, 0) ELSE -ISNULL(M.AMOUNT, 0) END) AS MAMT, "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "(CASE WHEN L.VDT <= '" + @TDATE + " 23:59:59' AND L.EDT > '" + @TDATE + " 23:59:59' THEN (CASE WHEN M.DRCR = 'C' THEN ISNULL(M.AMOUNT, 0) ELSE -ISNULL(M.AMOUNT, 0) END) ELSE 0 END ) AS UNREALISED, "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "UNREALISED = 0, "      
     END      
    SELECT @@SQL = @@SQL + "L.VDT, L.EDT, " + CONVERT(VARCHAR,@@SPID) + ", " + @SESSIONID     
    
    SELECT @@SQL = @@SQL + "FROM " + @@SHAREDB + ".DBO.CLIENT1 C, " + @@SHAREDB + ".DBO.CLIENT2 C2, MARGINLEDGER M, "      
    SELECT @@SQL = @@SQL + "LEDGER L "      
    SELECT @@SQL = @@SQL + "WHERE C.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = M.PARTY_CODE "      
    SELECT @@SQL = @@SQL + "AND M.VNO = L.VNO AND M.VTYP = L.VTYP AND M.BOOKTYPE = L.BOOKTYPE AND M.LNO = L.LNO "      
    SELECT @@SQL = @@SQL + "AND C2.PARTY_CODE BETWEEN '" + @FPARTY + "' AND '" + @TPARTY + "' "      
    IF @DISPLAYRPT = 'VDT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND M.VDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    ELSE      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND L.EDT BETWEEN '" + @STDDATE + "' AND '" + @TDATE + " 23:59:59' "      
     END      
    IF @STATUSID = 'AREA'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.AREA = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'REGION'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.REGION = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'BRANCH'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.BRANCH_CD = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'SUBBROKER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.SUB_BROKER = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'TRADER'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.TRADER = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'FAMILY'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C.FAMILY = '" + @STATUSNAME + "' "      
     END      
    ELSE IF @STATUSID = 'CLIENT'      
     BEGIN      
      SELECT @@SQL = @@SQL + "AND C2.PARTY_CODE = '" + @STATUSNAME + "' "      
     END      
        
    PRINT (@@SQL)      
    EXEC (@@SQL)      
        
    IF @DISPLAYRPT = 'EDT'      
     BEGIN      
      --DELETING OVERLAPING ENTRIES OF EFFECTIVE DATE ACCROSS THE YEAR      
      --INSTEAD OF GIVING REVERSAL EFFECT      
      --THIS SAVES UNION JOIN      
      SELECT @@SQL = "DELETE FROM NEWPARTYLEDGER1 WHERE VDT < '" + @STDDATE + "' AND EDT >= '" + @STDDATE + "' "      
      SELECT @@SQL = @@SQL + "AND SPID = @@SPID"      
      EXEC (@@SQL)      
     END      
    SELECT @@RECCOUNTER = ISNULL(COUNT(*), 0) FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
    IF @@RECCOUNTER <= 0      
     BEGIN      
      SELECT CLTCODE, BRANCH AS LONG_NAME,SECTORAMOUNT = 0, LEDGERAMOUNT = 0,SECTORMARGIN =0 ,MARGINAMOUNT = 0,SECTORUNREALISED = 0, UNREALISED = 0, SECTORTOTAL= 0,HTOTAL = 0,SESSIONID      
      FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
      DELETE FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
      RETURN      
     END      
    SELECT @@SQL = "SELECT CLTCODE, BRANCH,ISNULL(SUM(VAMT), 0) AS SECTORAMOUNT, ISNULL(SUM(VAMT), 0) AS LEDGERAMOUNT,ISNULL(SUM(MAMT), 0) AS SECTORMARGIN ,ISNULL(SUM(MAMT), 0) AS MARGINAMOUNT"      
    SELECT @@SQL = @@SQL + ",  ISNULL(SUM(UNREALISED), 0) AS SECTORUNREALISED,ISNULL(SUM(UNREALISED), 0) AS UNREALISED "      
    SELECT @@SQL = @@SQL + ",ISNULL(SUM(VAMT + MAMT), 0) AS SECTORTOTAL, ISNULL(SUM(VAMT + MAMT), 0) AS HTOTAL, SESSIONID "      
    SELECT @@SQL = @@SQL + "FROM NEWPARTYLEDGER1 "      
    SELECT @@SQL = @@SQL + "WHERE SPID = @@SPID "      
    SELECT @@SQL = @@SQL + "GROUP BY CLTCODE, BRANCH, SESSIONID "      
    SELECT @@SQL = @@SQL + "ORDER BY CLTCODE, BRANCH "      
   -- SELECT @@SQL = @@SQL + "COMPUTE SUM(ISNULL(SUM(VAMT), 0)), SUM(ISNULL(SUM(MAMT), 0)), "      
/*    IF @DISPLAYRPT = 'VDT'      
     BEGIN*/      
   --   SELECT @@SQL = @@SQL + "SUM(ISNULL(SUM(UNREALISED), 0)), "      
--     END      
   -- SELECT @@SQL = @@SQL + "SUM(ISNULL(SUM(VAMT + MAMT), 0)) "      
    PRINT (@@SQL)      
   EXEC (@@SQL)      
    DELETE FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
   END      
  ELSE      
   BEGIN      
    PRINT 'THE COMBINATION OF LOGIN AND REPORT NOT ALLOWED'      
    SELECT * FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID      
   END      
 END

GO
