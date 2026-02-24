-- Object: PROCEDURE dbo.NEWPARTYBALANCES1_CSV
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


--EXEC NEWPARTYBALANCES1_CSV '0A141', '0A141','99555', 'APR 1 2008','APR 1 2008', 'DEC 30 2008','12/26/2008','PARTY', '30', '30', '', 'BROKER', 'BROKER'
CREATE PROCEDURE [dbo].[NEWPARTYBALANCES1_CSV]
                @FROMPARTY  VARCHAR(10),
                @TOPARTY    VARCHAR(10),
                @GLCODE     VARCHAR(10),
                @OPENDATE   VARCHAR(11),
                @FROMDT     VARCHAR(11),
                @TODATE     VARCHAR(11),
                @VDT        VARCHAR(11),
                @REPORTTYPE VARCHAR(30),
                @INTRATEDR  INT,
                @INTRATECR  INT,
                @BRANCHCODE VARCHAR(10),
                @STATUSID   VARCHAR(15),
                @STATUSNAME VARCHAR(25)
                
AS

  DECLARE  @@BALCUR      AS CURSOR,
           @@BALDATE     AS DATETIME,
           @@ENDDATENEW  AS DATETIME,
           @@ENDDATE     AS DATETIME,
           @@NARRATION   AS VARCHAR(100)
                            
  SET NOCOUNT ON
  
  SELECT @@NARRATION = 'INTEREST CALCULATION FROM ' + @FROMDT + ' TO ' + @TODATE
  
  SELECT @@BALDATE = @FROMDT + ' 23:59'
  
  SELECT @@ENDDATE = @TODATE + ' 23:59'
  
  SELECT @@ENDDATENEW = DATEADD(DAY,1,@@BALDATE)
  
  CREATE TABLE #TEMP_PARTYBAL (
    CLTCODE     VARCHAR(12),
    BALANCEDATE DATETIME,
    BALANCE     MONEY,
    INT_BAL     MONEY,
    FLAG        VARCHAR(5))
  
  CREATE TABLE #TEMP_CSV (
    SNO     INT   IDENTITY ( 1,1 ),
    VDT     varchar(10),
    EDT     varchar(10),
    CLTCODE VARCHAR(12),
    DRCR    CHAR(1),
    INT_BAL MONEY,
    NARR    VARCHAR(60),
    BRANCH  VARCHAR(12))
  
  CREATE TABLE #TEMP_CSV_FINAL (
    SNO     INT,
    VDT     varchar(10),
    EDT     varchar(10),
    CLTCODE VARCHAR(12),
    DRCR    CHAR(1),
    INT_BAL MONEY,
    NARR    VARCHAR(60),
    BRANCH  VARCHAR(12))
  
  IF UPPER(RTRIM(@REPORTTYPE)) = 'PARTY'
    BEGIN
      WHILE @@BALDATE < = @@ENDDATE
        BEGIN
          INSERT INTO #TEMP_PARTYBAL
                     (CLTCODE,
                      BALANCEDATE,
                      BALANCE)
          SELECT   L.CLTCODE,
                   @@BALDATE,
                   SUM(CASE 
                         WHEN UPPER(DRCR) = 'D' THEN VAMT
                         ELSE -VAMT
                       END)
          FROM     LEDGER L,
                   ACMAST A,
                   MSAJAG..CLIENT1 C1,
                   MSAJAG..CLIENT2 C2
          WHERE    EDT > = 'APR  1 2003' + ' 00:00'
                   AND EDT < = @@BALDATE
                   AND L.CLTCODE = A.CLTCODE
                   AND A.ACCAT = 4
                   AND A.CLTCODE > = @FROMPARTY
                   AND A.CLTCODE < = @TOPARTY
                   AND C1.CL_CODE = C2.PARTY_CODE
                   AND A.CLTCODE = C1.CL_CODE
                   AND A.BRANCHCODE LIKE RTRIM(@BRANCHCODE) + '%'
                   AND @STATUSNAME = (CASE 
                                        WHEN @STATUSID = 'BRANCH' THEN C1.BRANCH_CD
                                        WHEN @STATUSID = 'SUBBROKER' THEN C1.SUB_BROKER
                                        WHEN @STATUSID = 'TRADER' THEN C1.TRADER
                                        WHEN @STATUSID = 'FAMILY' THEN C1.FAMILY
                                        WHEN @STATUSID = 'AREA' THEN C1.AREA
                                        WHEN @STATUSID = 'REGION' THEN C1.REGION
                                        WHEN @STATUSID = 'CLIENT' THEN C2.PARTY_CODE
                                        ELSE 'BROKER'
                                      END)
          GROUP BY L.CLTCODE
          ORDER BY L.CLTCODE
          
          SELECT @@BALDATE = DATEADD(DAY,1,@@BALDATE)
        END
    END
  ELSE
    IF UPPER(RTRIM(@REPORTTYPE)) = 'FAMILY'
      BEGIN
        WHILE @@BALDATE < = @@ENDDATE
          BEGIN
            INSERT INTO #TEMP_PARTYBAL
                       (CLTCODE,
                        BALANCEDATE,
                        BALANCE)
            SELECT   C.FAMILY,
                     @@BALDATE,
                     SUM(CASE 
                           WHEN UPPER(DRCR) = 'D' THEN VAMT
                           ELSE -VAMT
                         END)
            FROM     LEDGER L,
                     MSAJAG.DBO.CLIENTMASTER C,
                     MSAJAG..CLIENT1 C1,
                     MSAJAG..CLIENT2 C2
            WHERE    EDT > = @OPENDATE + ' 00:00:00'
                     AND EDT < = @@BALDATE
                     AND L.CLTCODE = C.PARTY_CODE
                     AND C.FAMILY > = @FROMPARTY
                     AND C.FAMILY < = @TOPARTY
                     AND C1.CL_CODE = C2.PARTY_CODE
                     AND C.PARTY_CODE = C1.CL_CODE
                     AND C.BRANCH_CD LIKE RTRIM(@BRANCHCODE) + '%'
                     AND @STATUSNAME = (CASE 
                                          WHEN @STATUSID = 'BRANCH' THEN C1.BRANCH_CD
                                          WHEN @STATUSID = 'SUBBROKER' THEN C1.SUB_BROKER
                                          WHEN @STATUSID = 'TRADER' THEN C1.TRADER
                                          WHEN @STATUSID = 'FAMILY' THEN C1.FAMILY
                                          WHEN @STATUSID = 'AREA' THEN C1.AREA
                                          WHEN @STATUSID = 'REGION' THEN C1.REGION
                                          WHEN @STATUSID = 'CLIENT' THEN C2.PARTY_CODE
                                          ELSE 'BROKER'
                                        END)
            GROUP BY C.FAMILY
            ORDER BY C.FAMILY
            
            SELECT @@BALDATE = DATEADD(DAY,1,@@BALDATE)
          END
      END
    ELSE
      IF UPPER(RTRIM(@REPORTTYPE)) = 'FAMILYPARTY'
        BEGIN
          WHILE @@BALDATE < = @@ENDDATE
            BEGIN
              INSERT INTO #TEMP_PARTYBAL
                         (CLTCODE,
                          BALANCEDATE,
                          BALANCE)
              SELECT   L.CLTCODE,
                       @@BALDATE,
                       SUM(CASE 
                             WHEN UPPER(DRCR) = 'D' THEN VAMT
                             ELSE -VAMT
                           END)
              FROM     LEDGER L,
                       MSAJAG.DBO.CLIENTMASTER C,
                       MSAJAG..CLIENT1 C1,
                       MSAJAG..CLIENT2 C2
              WHERE    EDT > = @OPENDATE + ' 00:00'
                       AND EDT < = @@BALDATE
                       AND L.CLTCODE = C.PARTY_CODE
                       AND C.FAMILY > = 'S06786'
                       AND C.FAMILY < = @TOPARTY
                       AND C1.CL_CODE = C2.PARTY_CODE
                       AND C.PARTY_CODE = C1.CL_CODE
                       AND C.BRANCH_CD LIKE RTRIM(@BRANCHCODE) + '%'
                       AND @STATUSNAME = (CASE 
                                            WHEN @STATUSID = 'BRANCH' THEN C1.BRANCH_CD
                                            WHEN @STATUSID = 'SUBBROKER' THEN C1.SUB_BROKER
                                            WHEN @STATUSID = 'TRADER' THEN C1.TRADER
                                            WHEN @STATUSID = 'FAMILY' THEN C1.FAMILY
                                            WHEN @STATUSID = 'AREA' THEN C1.AREA
                                            WHEN @STATUSID = 'REGION' THEN C1.REGION
                                            WHEN @STATUSID = 'CLIENT' THEN C2.PARTY_CODE
                                            ELSE 'BROKER'
                                          END)
              GROUP BY L.CLTCODE
              ORDER BY L.CLTCODE
              
              SELECT @@BALDATE = DATEADD(DAY,1,@@BALDATE)
            END
        END
  
  --CALCULATE INTEREST AMOUNT AND UPDATE TO INT_BAL
  UPDATE #TEMP_PARTYBAL
  SET    INT_BAL = CASE 
                     WHEN BALANCE > 0 THEN ROUND((BALANCE * @INTRATEDR / 100) / 365,2)
                     ELSE ROUND((BALANCE * @INTRATECR / 100) / 365,2)
                   END
  
  --GENERATE CLIENT SIDE RECORD FOR CSV FILE
  INSERT INTO #TEMP_CSV
  SELECT   @VDT,
           @VDT,
           CLTCODE,
           CASE 
             WHEN SUM(INT_BAL) > 0 THEN 'D'
             ELSE 'C'
           END,
           round(SUM(INT_BAL),2),
           @@NARRATION,
           'ALL'
  FROM     #TEMP_PARTYBAL
  GROUP BY CLTCODE
  ORDER BY CLTCODE
  
  INSERT INTO #TEMP_CSV_FINAL
  SELECT *
  FROM   #TEMP_CSV
 
  
  --GENERATE REVERSE SIDE RECORD FOR CSV FILE
  INSERT INTO #TEMP_CSV_FINAL
  SELECT SNO,
         VDT,
         EDT,
         @GLCODE,
         CASE DRCR 
           WHEN 'D' THEN 'C'
           ELSE DRCR
         END,
         INT_BAL,
         NARR,
         BRANCH
  FROM   #TEMP_CSV

  
  SELECT   
		SNO, CONVERT(VARCHAR(11),CONVERT(DATETIME,VDT),103) AS VDT, CONVERT(VARCHAR(11),CONVERT(DATETIME,EDT),103) AS EDT,CLTCODE,DRCR,INT_BAL,NARR,BRANCH
  FROM     
		#TEMP_CSV_FINAL
  WHERE 
		INT_BAL >0	
  ORDER BY SNO,
           CLTCODE
  
  DROP TABLE #TEMP_PARTYBAL
  
  DROP TABLE #TEMP_CSV
  
  DROP TABLE #TEMP_CSV_FINAL

GO
