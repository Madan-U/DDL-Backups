-- Object: PROCEDURE dbo.GET_FUNDTRANSFER_ENTRIES_BAK_25072018
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------



create PROCEDURE [dbo].[GET_FUNDTRANSFER_ENTRIES_BAK_25072018]
	@START_DATE VARCHAR(11),
	@CLTCODE_FR VARCHAR(10),
	@CLTCODE_TO VARCHAR(10),
	@BRANCHCODE VARCHAR(10),
	@EXCH_FR VARCHAR(10),
	@EXCH_TO VARCHAR(10),
	@SOURCE_SERVER VARCHAR(25),
	@SOURCE_DB  VARCHAR(25),
	@SOURCE_SHAREDB  VARCHAR(25),
	@DESTINATION_SERVER VARCHAR(25),
	@DESTINATION_DB  VARCHAR(25),
	@DESTINATION_SHAREDB  VARCHAR(25),
	@SESSIONID VARCHAR(20)

AS
	
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
SET NOCOUNT ON 

CREATE TABLE #FUND_TRF_CLIENT
(
	CLTCODE VARCHAR(10),
	ACNAME VARCHAR(100),
	BRANCHCODE VARCHAR(10)
)

DECLARE
	@@SQL VARCHAR(MAX)

SET @@SQL = "INSERT INTO #FUND_TRF_CLIENT "
SET @@SQL = @@SQL + "SELECT "
SET @@SQL = @@SQL + "	A.CLTCODE, "
SET @@SQL = @@SQL + "	A.ACNAME, "
SET @@SQL = @@SQL + "	A.BRANCHCODE "
SET @@SQL = @@SQL + "FROM "
SET @@SQL = @@SQL + "	" + @SOURCE_SERVER + "." + @SOURCE_DB + ".DBO.ACMAST A WITH (NOLOCK), "
SET @@SQL = @@SQL + "	" + @DESTINATION_SERVER + "." + @DESTINATION_DB + ".DBO.ACMAST AA WITH (NOLOCK) "
SET @@SQL = @@SQL + "WHERE "
SET @@SQL = @@SQL + "	A.ACCAT = 4 "
SET @@SQL = @@SQL + "	AND A.CLTCODE BETWEEN '" + @CLTCODE_FR + "' AND '" + @CLTCODE_TO + "'"
SET @@SQL = @@SQL + "	AND A.BRANCHCODE LIKE '" + @BRANCHCODE + "' "
SET @@SQL = @@SQL + "	AND A.CLTCODE = AA.CLTCODE"

EXEC (@@SQL)

SET @@SQL = "DELETE L "
SET @@SQL = @@SQL + "	FROM   #FUND_TRF_CLIENT L, "
SET @@SQL = @@SQL + "	" + @SOURCE_SERVER + "." + @SOURCE_SHAREDB + ".DBO.CLIENT5 C5 "
SET @@SQL = @@SQL + " WHERE  CLTCODE = CL_CODE "
SET @@SQL = @@SQL + "       AND INACTIVEFROM < CONVERT(VARCHAR(11), GETDATE()) "

EXEC (@@SQL)

SET @@SQL = "DELETE L "
SET @@SQL = @@SQL + "FROM   #FUND_TRF_CLIENT L, "
SET @@SQL = @@SQL + "  " + @DESTINATION_SERVER + "." + @DESTINATION_SHAREDB + ".DBO.CLIENT5 C5 "
SET @@SQL = @@SQL + " WHERE  CLTCODE = CL_CODE "
SET @@SQL = @@SQL + "       AND INACTIVEFROM < CONVERT(VARCHAR(11), GETDATE()) "

EXEC (@@SQL)

DELETE F 
FROM   #FUND_TRF_CLIENT F, 
       MSAJAG.DBO.CLIENT_DETAILS O 
WHERE  CLTCODE = CL_CODE 
       AND CL_TYPE IN ( 'NBF', 'TMF' ) 
       
CREATE TABLE [DBO].[#LEDGERTRANSFER] 
  ( 
     [BRANCHCODE]    [VARCHAR](10) NULL, 
     [CLTCODE]       [VARCHAR](10) NOT NULL, 
     [ACNAME]        [CHAR](100) NOT NULL, 
     [LEDGERBALANCE] [MONEY] NULL, 
     [AMOUNT]        [MONEY] NULL 
  ) 
ON [PRIMARY] 

SET @@SQL = "INSERT INTO #LEDGERTRANSFER "
SET @@SQL = @@SQL + "SELECT BRANCHCODE, "
SET @@SQL = @@SQL + "       CLTCODE, "
SET @@SQL = @@SQL + "       ACNAME, "
SET @@SQL = @@SQL + "       LEDGERBALANCE = SUM(LEDGERBALANCE), "
SET @@SQL = @@SQL + "       AMOUNT = 0 "
SET @@SQL = @@SQL + "FROM   (SELECT A.BRANCHCODE, "
SET @@SQL = @@SQL + "               A.CLTCODE, "
SET @@SQL = @@SQL + "               A.ACNAME, "
SET @@SQL = @@SQL + "               LEDGERBALANCE = SUM(CASE "
SET @@SQL = @@SQL + "                                     WHEN L.DRCR = 'C' THEN L.VAMT "
SET @@SQL = @@SQL + "                                     ELSE -L.VAMT "
SET @@SQL = @@SQL + "                                   END) "
SET @@SQL = @@SQL + "        FROM   " + @SOURCE_SERVER + "." + @SOURCE_DB + ".DBO.LEDGER L WITH (NOLOCK), "
SET @@SQL = @@SQL + "               #FUND_TRF_CLIENT A "
SET @@SQL = @@SQL + "        WHERE  L.CLTCODE = A.CLTCODE "
SET @@SQL = @@SQL + "               AND L.EDT >= '" + @START_DATE + " 00:00:00' "
SET @@SQL = @@SQL + "               AND L.EDT <= CONVERT(VARCHAR(11), GETDATE()) "
SET @@SQL = @@SQL + "                            + ' 23:59:59' "
SET @@SQL = @@SQL + "        GROUP  BY A.CLTCODE, "
SET @@SQL = @@SQL + "                  A.ACNAME, "
SET @@SQL = @@SQL + "                  A.BRANCHCODE "

SET @@SQL = @@SQL + "        UNION ALL "
SET @@SQL = @@SQL + "        SELECT A.BRANCHCODE, "
SET @@SQL = @@SQL + "               A.CLTCODE, "
SET @@SQL = @@SQL + "               A.ACNAME, "
SET @@SQL = @@SQL + "               LEDGERBALANCE = SUM(CASE "
SET @@SQL = @@SQL + "                                     WHEN L.DRCR = 'D' THEN L.VAMT "
SET @@SQL = @@SQL + "                                     ELSE -L.VAMT "
SET @@SQL = @@SQL + "                                   END) "
SET @@SQL = @@SQL + "        FROM   " + @SOURCE_SERVER + "." + @SOURCE_DB + ".DBO.LEDGER L WITH (NOLOCK), "
SET @@SQL = @@SQL + "               #FUND_TRF_CLIENT A  "
SET @@SQL = @@SQL + "        WHERE  L.CLTCODE = A.CLTCODE "
SET @@SQL = @@SQL + "               AND L.EDT >= '" + @START_DATE + " 00:00:00' "
SET @@SQL = @@SQL + "               AND L.VDT < '" + @START_DATE + "'"
SET @@SQL = @@SQL + "        GROUP  BY A.CLTCODE, "
SET @@SQL = @@SQL + "                  A.ACNAME, "
SET @@SQL = @@SQL + "                  A.BRANCHCODE "

SET @@SQL = @@SQL + "        UNION ALL "
SET @@SQL = @@SQL + "        SELECT A.BRANCHCODE, "
SET @@SQL = @@SQL + "               A.CLTCODE, "
SET @@SQL = @@SQL + "               A.ACNAME, "
SET @@SQL = @@SQL + "               LEDGERBALANCE = -SUM(CASE "
SET @@SQL = @@SQL + "                                      WHEN L.DRCR = 'C' THEN L.VAMT "
SET @@SQL = @@SQL + "                                      ELSE 0 "
SET @@SQL = @@SQL + "                                    END) "
SET @@SQL = @@SQL + "        FROM   " + @SOURCE_SERVER + "." + @SOURCE_DB + ".DBO.LEDGER L (NOLOCK), "
SET @@SQL = @@SQL + "               #FUND_TRF_CLIENT A, "
SET @@SQL = @@SQL + "               " + @SOURCE_SERVER + "." + @SOURCE_DB + ".DBO.LEDGER1 L1 (NOLOCK) "
SET @@SQL = @@SQL + "        WHERE  L.CLTCODE = A.CLTCODE "
SET @@SQL = @@SQL + "               AND L.VDT >= '" + @START_DATE + " 00:00:00' "
SET @@SQL = @@SQL + "               AND L.VDT <= CONVERT(VARCHAR(11), GETDATE()) "
SET @@SQL = @@SQL + "                            + ' 23:59:59' "
SET @@SQL = @@SQL + "               AND L.VTYP = 2 "
SET @@SQL = @@SQL + "               AND L.VNO = L1.VNO "
SET @@SQL = @@SQL + "               AND L.VTYP = L1.VTYP "
SET @@SQL = @@SQL + "               AND L.BOOKTYPE = L1.BOOKTYPE "
SET @@SQL = @@SQL + "               AND L.LNO = L1.LNO "
SET @@SQL = @@SQL + "               AND L1.RELDT = '' "
SET @@SQL = @@SQL + "        GROUP  BY A.CLTCODE, "
SET @@SQL = @@SQL + "                  A.ACNAME, "
SET @@SQL = @@SQL + "                  A.BRANCHCODE "

SET @@SQL = @@SQL + "        UNION ALL "
SET @@SQL = @@SQL + "        SELECT A.BRANCHCODE, "
SET @@SQL = @@SQL + "               A.CLTCODE, "
SET @@SQL = @@SQL + "               A.ACNAME, "
SET @@SQL = @@SQL + "               LEDGERBALANCE = SUM(CASE "
SET @@SQL = @@SQL + "                                     WHEN L.DRCR = 'C' THEN 0 "
SET @@SQL = @@SQL + "                                     ELSE -L.VAMT "
SET @@SQL = @@SQL + "                                   END) "
SET @@SQL = @@SQL + "        FROM   " + @SOURCE_SERVER + "." + @SOURCE_DB + ".DBO.LEDGER L WITH (NOLOCK), "
SET @@SQL = @@SQL + "               #FUND_TRF_CLIENT A "
SET @@SQL = @@SQL + "        WHERE  L.CLTCODE = A.CLTCODE "
SET @@SQL = @@SQL + "               AND L.VDT >= '" + @START_DATE + " 00:00:00' "
SET @@SQL = @@SQL + "               AND L.VDT <= CONVERT(VARCHAR(11), GETDATE()) "
SET @@SQL = @@SQL + "                            + ' 23:59:59' "
SET @@SQL = @@SQL + "               AND L.EDT >= CONVERT(VARCHAR(11), GETDATE() + 1) "
SET @@SQL = @@SQL + "        GROUP  BY A.CLTCODE, "
SET @@SQL = @@SQL + "                  A.ACNAME, "
SET @@SQL = @@SQL + "                  A.BRANCHCODE "
SET @@SQL = @@SQL + "       ) F "
SET @@SQL = @@SQL + "GROUP  BY CLTCODE, "
SET @@SQL = @@SQL + "          ACNAME, "
SET @@SQL = @@SQL + "          BRANCHCODE "
SET @@SQL = @@SQL + "HAVING SUM(LEDGERBALANCE) > 0 "

EXEC (@@SQL) 

SET @@SQL = "INSERT INTO #LEDGERTRANSFER "
SET @@SQL = @@SQL + "SELECT BRANCHCODE, "
SET @@SQL = @@SQL + "       CLTCODE, "
SET @@SQL = @@SQL + "       ACNAME, "
SET @@SQL = @@SQL + "       LEDGERBALANCE = 0, "
SET @@SQL = @@SQL + "       AMOUNT = SUM(AMOUNT) "
SET @@SQL = @@SQL + "FROM   (SELECT BRANCHCODE, "
SET @@SQL = @@SQL + "               A.CLTCODE, "
SET @@SQL = @@SQL + "               A.ACNAME, "
SET @@SQL = @@SQL + "               AMOUNT = SUM(CASE "
SET @@SQL = @@SQL + "                              WHEN L.DRCR = 'C' THEN L.VAMT "
SET @@SQL = @@SQL + "                              ELSE -L.VAMT "
SET @@SQL = @@SQL + "                            END) "
SET @@SQL = @@SQL + "        FROM   " + @DESTINATION_SERVER + "." + @DESTINATION_DB + ".DBO.LEDGER L WITH (NOLOCK), "
SET @@SQL = @@SQL + "               #FUND_TRF_CLIENT A "
SET @@SQL = @@SQL + "        WHERE  L.CLTCODE = A.CLTCODE "
SET @@SQL = @@SQL + "               AND L.EDT >= '" + @START_DATE + " 00:00:00' "
SET @@SQL = @@SQL + "               AND L.EDT <= CONVERT(VARCHAR(11), GETDATE()) "
SET @@SQL = @@SQL + "                            + ' 23:59:59' "
SET @@SQL = @@SQL + "        GROUP  BY A.CLTCODE, "
SET @@SQL = @@SQL + "                  A.ACNAME, "
SET @@SQL = @@SQL + "                  BRANCHCODE "

SET @@SQL = @@SQL + "        UNION ALL "
SET @@SQL = @@SQL + "        SELECT BRANCHCODE, "
SET @@SQL = @@SQL + "               A.CLTCODE, "
SET @@SQL = @@SQL + "               A.ACNAME, "
SET @@SQL = @@SQL + "               AMOUNT = SUM(CASE "
SET @@SQL = @@SQL + "                              WHEN L.DRCR = 'D' THEN L.VAMT "
SET @@SQL = @@SQL + "                              ELSE -L.VAMT "
SET @@SQL = @@SQL + "                            END) "
SET @@SQL = @@SQL + "        FROM   " + @DESTINATION_SERVER + "." + @DESTINATION_DB + ".DBO.LEDGER L WITH (NOLOCK), "
SET @@SQL = @@SQL + "               #FUND_TRF_CLIENT A "
SET @@SQL = @@SQL + "        WHERE  L.CLTCODE = A.CLTCODE "
SET @@SQL = @@SQL + "               AND L.EDT >= '" + @START_DATE + " 00:00:00' "
SET @@SQL = @@SQL + "               AND L.VDT < '" + @START_DATE + "'"
SET @@SQL = @@SQL + "        GROUP  BY A.CLTCODE, "
SET @@SQL = @@SQL + "                  A.ACNAME, "
SET @@SQL = @@SQL + "                  BRANCHCODE "

SET @@SQL = @@SQL + "        UNION ALL "
SET @@SQL = @@SQL + "        SELECT BRANCHCODE, "
SET @@SQL = @@SQL + "               A.CLTCODE, "
SET @@SQL = @@SQL + "               A.ACNAME, "
SET @@SQL = @@SQL + "               AMOUNT = -SUM(CASE "
SET @@SQL = @@SQL + "                               WHEN L.DRCR = 'C' THEN L.VAMT "
SET @@SQL = @@SQL + "                               ELSE 0 "
SET @@SQL = @@SQL + "                             END) "
SET @@SQL = @@SQL + "        FROM   " + @DESTINATION_SERVER + "." + @DESTINATION_DB + ".DBO.LEDGER L WITH (NOLOCK), "
SET @@SQL = @@SQL + "               #FUND_TRF_CLIENT A, "
SET @@SQL = @@SQL + "               " + @DESTINATION_SERVER + "." + @DESTINATION_DB + ".DBO.LEDGER1 L1 (NOLOCK) "
SET @@SQL = @@SQL + "        WHERE  L.CLTCODE = A.CLTCODE "
SET @@SQL = @@SQL + "               AND L.VDT >= '" + @START_DATE + " 00:00:00' "
SET @@SQL = @@SQL + "               AND L.VDT <= CONVERT(VARCHAR(11), GETDATE()) "
SET @@SQL = @@SQL + "                            + ' 23:59:59' "
SET @@SQL = @@SQL + "               AND L.VTYP = 2 "
SET @@SQL = @@SQL + "               AND L.VNO = L1.VNO "
SET @@SQL = @@SQL + "               AND L.VTYP = L1.VTYP "
SET @@SQL = @@SQL + "               AND L.BOOKTYPE = L1.BOOKTYPE "
SET @@SQL = @@SQL + "               AND L.LNO = L1.LNO "
SET @@SQL = @@SQL + "               AND L1.RELDT = '' "
SET @@SQL = @@SQL + "        GROUP  BY A.CLTCODE, "
SET @@SQL = @@SQL + "                  A.ACNAME, "
SET @@SQL = @@SQL + "                  BRANCHCODE "

SET @@SQL = @@SQL + "        UNION ALL "
SET @@SQL = @@SQL + "        SELECT BRANCHCODE, "
SET @@SQL = @@SQL + "               A.CLTCODE, "
SET @@SQL = @@SQL + "               A.ACNAME, "
SET @@SQL = @@SQL + "               AMOUNT = SUM(CASE "
SET @@SQL = @@SQL + "                              WHEN L.DRCR = 'C' THEN 0 "
SET @@SQL = @@SQL + "                              ELSE -L.VAMT "
SET @@SQL = @@SQL + "                            END) "
SET @@SQL = @@SQL + "        FROM   " + @DESTINATION_SERVER + "." + @DESTINATION_DB + ".DBO.LEDGER L WITH (NOLOCK), "
SET @@SQL = @@SQL + "               #FUND_TRF_CLIENT A "
SET @@SQL = @@SQL + "        WHERE  L.CLTCODE = A.CLTCODE "
SET @@SQL = @@SQL + "               AND L.VDT >= '" + @START_DATE + " 00:00:00' "
SET @@SQL = @@SQL + "               AND L.VDT <= CONVERT(VARCHAR(11), GETDATE()) "
SET @@SQL = @@SQL + "                            + ' 23:59:59' "
SET @@SQL = @@SQL + "               AND L.EDT >= CONVERT(VARCHAR(11), GETDATE() + 1) "
SET @@SQL = @@SQL + "        GROUP  BY A.CLTCODE, "
SET @@SQL = @@SQL + "                  A.ACNAME, "
SET @@SQL = @@SQL + "                  BRANCHCODE "
SET @@SQL = @@SQL + "       ) F "
SET @@SQL = @@SQL + "GROUP  BY CLTCODE, "
SET @@SQL = @@SQL + "          ACNAME, "
SET @@SQL = @@SQL + "          BRANCHCODE"

EXEC (@@SQL)      

SELECT BRANCHCODE = MAX(BRANCHCODE), 
       A.CLTCODE, 
       ACNAME = MAX(A.ACNAME), 
       LEDGERBALANCE = SUM(LEDGERBALANCE), 
       AMOUNT = ABS(SUM(AMOUNT)) 
INTO   #LEDGERTRANSFER_F 
FROM   #LEDGERTRANSFER A 
GROUP  BY A.CLTCODE 
HAVING SUM(LEDGERBALANCE) > 1 
       AND SUM(AMOUNT) < 0 
ORDER  BY BRANCHCODE, 
          A.CLTCODE 

INSERT INTO FUNDSTRANSFER_LOG 
SELECT PARTYCODE = CLTCODE, 
       EXCH_FR = @EXCH_FR, 
       EXCH_TO = @EXCH_TO, 
       TRF_DT = GETDATE(), 
       EXCHFR_AMT = SUM(LEDGERBALANCE), 
       EXCHTO_AMT = SUM(CASE 
                          WHEN ACNAME <> '' THEN AMOUNT 
                          ELSE 0 
                        END), 
       TOTAMT_LED_MAR_COL = SUM(AMOUNT), 
       CHK_BY = @CLTCODE_TO, 
       CHK_DT = GETDATE() 
FROM   #LEDGERTRANSFER 
GROUP  BY CLTCODE 
HAVING SUM(LEDGERBALANCE) > 1 
       AND SUM(AMOUNT) < 0 

SELECT BRANCHCODE, 
       CLTCODE, 
       ACNAME, 
       LEDGERBALANCE, 
       AMOUNT 
FROM   #LEDGERTRANSFER_F 
WHERE  AMOUNT >= 1 
ORDER  BY BRANCHCODE, 
          CLTCODE 

DELETE LEDGERTRANSFER 
WHERE  SESSIONID = @SESSIONID 

INSERT INTO LEDGERTRANSFER 
SELECT *, 
       @SESSIONID 
FROM   #LEDGERTRANSFER_F 

DROP TABLE #LEDGERTRANSFER_F 

DROP TABLE #LEDGERTRANSFER

GO
