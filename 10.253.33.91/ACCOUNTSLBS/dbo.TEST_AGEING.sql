-- Object: PROCEDURE dbo.TEST_AGEING
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

--exec Ageingcursor_NEW1_SB '10100000', '10100010', 'Apr  1 2004', 'Nov 19 2004','party','',0, 'A','edt','broker','broker', 6,26,90,160,161,'101', 'VALSAD'

CREATE PROCEDURE TEST_AGEING
                @fromparty   VARCHAR(10),
                @toparty     VARCHAR(10),
                @opendate    VARCHAR(11),
                @todate      VARCHAR(11),
                @Reporttype  VARCHAR(15),
                @family      VARCHAR(10),
                @amoutgtthan MONEY,
                @ageoption   VARCHAR(1),
                @dttype      VARCHAR(3),
                @statusid    VARCHAR(10),
                @statusname  VARCHAR(25),
                @Days1       INT  = 6,
                @Days2       INT  = 29,
                @Days3       INT  = 90,
                @Days4       INT  = 180,
                @Days5       INT  = 181,
                @FrSb        VARCHAR(10)  = '0',
                @ToSb        VARCHAR(10)  = 'ZZZZ'
                                            
AS

  DECLARE  @@balcur      AS CURSOR,
           @@baldate     AS VARCHAR(11),
           @@openbaldt   AS VARCHAR(11),
           @@balamt      AS MONEY,
           @@ocltcode    AS VARCHAR(10),
           @@vtyp        AS SMALLINT,
           @@vno        VARCHAR(12),
           @@EVdt        AS DATETIME,
           @@vamt        AS MONEY,
           @@closbal     AS MONEY,
           @@cltcode     AS VARCHAR(10),
           @@Branchcode  AS VARCHAR(25),
           @@area        AS VARCHAR(25),
           @@drcr        AS VARCHAR(1),
           @@startdt     AS DATETIME
                            
  PRINT 'Strated '
  
  PRINT CONVERT(DATETIME,GETDATE(),113)
  
  SET NOCOUNT ON
  
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED
  
  SELECT @@startdt = (SELECT LEFT(CONVERT(VARCHAR,DATEADD(MM,-12,CONVERT(DATETIME,@todate)),
                                          109),11))
                     
  IF UPPER(@statusid) = 'BROKER'
    BEGIN
      SELECT @@branchcode = '%'
      
      SELECT @@area = '%'
    END
  ELSE
    IF UPPER(@statusid) = 'BRANCH'
      BEGIN
        SELECT @@branchcode = RTRIM(@statusname)
        
        SELECT @@area = '%'
      END
    ELSE
      IF UPPER(@statusid) = 'AREA'
        BEGIN
          SELECT @@branchcode = '%'
          
          SELECT @@area = RTRIM(@statusname)
        END
        
  SELECT CLTCODE,
         VDT         AS BALDATE,
         VAMT        CLOSBAL,
         AGEDAYS = 0
  INTO   #TEMPAGEING
  FROM   LEDGER
  WHERE  1 = 2
  
  SELECT CLTCODE,
         VDT         AS BALDATE,
         VAMT        CLOSBAL,
         AGEDAYS = 0
  INTO   #TEMPAGEING1
  FROM   LEDGER
  WHERE  1 = 2
             
  SELECT *
  INTO   #LEDGER
  FROM   LEDGER
  WHERE  1 = 2
             
  SELECT CLTCODE,
         VTYP,
         VNO,
         EDT     AS EVDT,
         VAMT,
         VAMT    CLOSBAL
  INTO   #LEDGERCURSOR
  FROM   LEDGER
  WHERE  1 = 2
             
  IF @dttype = 'vdt'
    BEGIN
      SELECT @@openbaldt = LEFT(CONVERT(VARCHAR,ISNULL(MAX(VDT),0),109),11)
      FROM   LEDGER
      WHERE  VTYP = '18'
             AND VDT < = @opendate
                         
      IF UPPER(@Reporttype) = 'PARTY'
        BEGIN
          INSERT INTO #TEMPAGEING1
          SELECT   L.CLTCODE,
                   BALDATE = @todate,
                   CLOSBAL = SUM(CASE 
                                   WHEN DRCR = 'd' THEN VAMT
                                   ELSE -VAMT
                                 END),
                   AGEDAYS = 0
          FROM     LEDGER L,
                   MSAJAG.DBO.CLIENT1 C1,
                   MSAJAG.DBO.CLIENT2 C2
          WHERE    L.CLTCODE = C2.PARTY_CODE
                   AND C1.CL_CODE = C2.CL_CODE
                   AND VDT >= @@openbaldt + ' 00:00:00'
                   AND VDT <= @todate + ' 23:59:59'
                   AND L.CLTCODE >= @fromparty
                   AND L.CLTCODE <= @toparty
                   AND C1.BRANCH_CD LIKE @@branchcode + '%'
                   AND AREA LIKE @@area + '%'
                   AND C1.SUB_BROKER >= @FrSb
                   AND C1.SUB_BROKER <= @ToSb
          GROUP BY L.CLTCODE
          ORDER BY L.CLTCODE
          
          INSERT INTO #TEMPAGEING
          SELECT   CLTCODE,
                   BALDATE = @todate,
                   CLOSBAL = SUM(CLOSBAL),
                   AGEDAYS = 0
          FROM     #TEMPAGEING1
          GROUP BY CLTCODE
          ORDER BY CLTCODE
        END
          
      IF UPPER(@Reporttype) = 'PARTY'
          OR UPPER(@Reporttype) = 'FAMILYPARTY'
        BEGIN
          INSERT INTO #LEDGER
          SELECT *
          FROM   LEDGER
          WHERE  VDT <= @todate + ' 23:59:59'
                 AND CLTCODE IN (SELECT DISTINCT CLTCODE
                                 FROM   #TEMPAGEING)
        END
        
      IF UPPER(@Reporttype) = 'PARTY'
          OR UPPER(@Reporttype) = 'FAMILYPARTY'
        BEGIN
          IF UPPER(RTRIM(@ageoption)) = 'D'
            BEGIN
              INSERT INTO #LEDGERCURSOR
              SELECT   L.CLTCODE,
                       VTYP,
                       VNO,
                       VDT,
                       VAMT,
                       CLOSBAL
              FROM     #LEDGER L,
                       #TEMPAGEING A
              WHERE    CLOSBAL >= 0
                       AND DRCR = (CASE 
                                     WHEN CLOSBAL >= 0 THEN 'd'
                                     ELSE 'c'
                                   END)
                       AND L.CLTCODE = A.CLTCODE
                       AND VDT <= @todate + ' 23:59:59'
                       --
                       AND VTYP <> '18'
              ORDER BY L.CLTCODE,
                       VDT DESC,
                       VTYP,
                       VNO
            END
            
          ELSE
            IF UPPER(RTRIM(@ageoption)) = 'C'
              BEGIN
                INSERT INTO #LEDGERCURSOR
                SELECT   L.CLTCODE,
                         VTYP,
                         VNO,
                         VDT,
                         VAMT,
                         CLOSBAL
                FROM     #LEDGER L,
                         #TEMPAGEING A
                WHERE    CLOSBAL < 0
                         AND DRCR = (CASE 
                                       WHEN CLOSBAL >= 0 THEN 'd'
                                       ELSE 'c'
                                     END)
                         AND L.CLTCODE = A.CLTCODE
                         AND VDT <= @todate + ' 23:59:59'
                         --
                         AND VTYP <> '18'
                ORDER BY L.CLTCODE,
                         VDT DESC,
                         VTYP,
                         VNO
              END
              
            ELSE
              BEGIN
                INSERT INTO #LEDGERCURSOR
                SELECT   L.CLTCODE,
                         VTYP,
                         VNO,
                         VDT,
                         VAMT,
                         CLOSBAL
                FROM     #LEDGER L,
                         #TEMPAGEING A
                WHERE    DRCR = (CASE 
                                   WHEN CLOSBAL >= 0 THEN 'd'
                                   ELSE 'c'
                                 END)
                         AND L.CLTCODE = A.CLTCODE
                         AND VDT <= @todate + ' 23:59:59'
                         --
                         AND VTYP <> '18'
                ORDER BY L.CLTCODE,
                         VDT DESC,
                         VTYP,
                         VNO
              END
        END

    END
    
  ELSE
    BEGIN
      SELECT @@openbaldt = LEFT(CONVERT(VARCHAR,ISNULL(MAX(EDT),0),109),11)
      FROM   LEDGER
      WHERE  VTYP = '18'
             AND EDT < = @opendate
                         
      IF UPPER(@Reporttype) = 'PARTY'
        BEGIN
          INSERT INTO #TEMPAGEING1
          SELECT   L.CLTCODE,
                   BALDATE = @todate,
                   CLOSBAL = SUM(CASE 
                                   WHEN DRCR = 'd' THEN VAMT
                                   ELSE -VAMT
                                 END),
                   AGEDAYS = 0
          FROM     LEDGER L,
                   ACMAST A,
                   MSAJAG.DBO.CLIENT1 C1
          WHERE    L.CLTCODE = A.CLTCODE
                   AND L.CLTCODE = C1.CL_CODE
                   AND EDT >= @@openbaldt + ' 00:00:00'
                   AND EDT <= @todate + ' 23:59:59'
                   AND L.CLTCODE >= @fromparty
                   AND L.CLTCODE <= @toparty
                   AND A.BRANCHCODE LIKE @@branchcode + '%'
                   AND A.ACCAT = 4
                   AND C1.SUB_BROKER >= @FrSb
                   AND C1.SUB_BROKER <= @ToSb
          GROUP BY L.CLTCODE
          ORDER BY L.CLTCODE
          
          INSERT INTO #TEMPAGEING
          SELECT   CLTCODE,
                   BALDATE = @todate,
                   CLOSBAL = SUM(CLOSBAL),
                   AGEDAYS = 0
          FROM     #TEMPAGEING1
          GROUP BY CLTCODE
          ORDER BY CLTCODE
                   
        END
           
      IF UPPER(@Reporttype) = 'PARTY'
          OR UPPER(@Reporttype) = 'FAMILYPARTY'
        BEGIN
          INSERT INTO #LEDGER
          SELECT *
          FROM   LEDGER
          WHERE  EDT <= @todate + ' 23:59:59'
                 AND CLTCODE IN (SELECT DISTINCT CLTCODE
                                 FROM   #TEMPAGEING)
        END
        
      IF UPPER(@Reporttype) = 'PARTY'
          OR UPPER(@Reporttype) = 'FAMILYPARTY'
        BEGIN
          IF UPPER(RTRIM(@ageoption)) = 'D'
            BEGIN
              INSERT INTO #LEDGERCURSOR
              SELECT   L.CLTCODE,
                       VTYP,
                       VNO,
                       EDT,
                       VAMT,
                       CLOSBAL
              FROM     #LEDGER L,
                       #TEMPAGEING A
              WHERE    CLOSBAL >= 0
                       AND DRCR = (CASE 
                                     WHEN CLOSBAL >= 0 THEN 'd'
                                     ELSE 'c'
                                   END)
                       AND L.CLTCODE = A.CLTCODE
                       AND EDT <= @todate + ' 23:59:59'
                       --
                       AND VTYP <> '18'
              ORDER BY L.CLTCODE,
                       EDT DESC,
                       VTYP,
                       VNO
            END
            
          ELSE
            IF UPPER(RTRIM(@ageoption)) = 'C'
              BEGIN
                INSERT INTO #LEDGERCURSOR
                SELECT   L.CLTCODE,
                         VTYP,
                         VNO,
                         EDT,
                         VAMT,
                         CLOSBAL
                FROM     #LEDGEREDT L,
                         #TEMPAGEING A
                WHERE    CLOSBAL < 0
                         AND DRCR = (CASE 
                                       WHEN CLOSBAL >= 0 THEN 'd'
                                       ELSE 'c'
                                     END)
                         AND L.CLTCODE = A.CLTCODE
                         AND EDT <= @todate + ' 23:59:59'
                         --
                         AND VTYP <> '18'
                ORDER BY L.CLTCODE,
                         EDT DESC,
                         VTYP,
                         VNO
              END
              
            ELSE
              BEGIN
                INSERT INTO #LEDGERCURSOR
                SELECT   L.CLTCODE,
                         VTYP,
                         VNO,
                         EDT,
                         VAMT,
                         CLOSBAL
                FROM     #LEDGER L,
                         #TEMPAGEING A
                WHERE    DRCR = (CASE 
                                   WHEN CLOSBAL >= 0 THEN 'd'
                                   ELSE 'c'
                                 END)
                         AND L.CLTCODE = A.CLTCODE
                         AND EDT <= @todate + ' 23:59:59'
                         --
                         AND VTYP <> '18'
                ORDER BY L.CLTCODE,
                         EDT DESC,
                         VTYP,
                         VNO
              END
        END
        
    END
    
  SET @@balcur = CURSOR FOR SELECT   CLTCODE,
                                     VTYP,
                                     VNO,
                                     EVDT,
                                     VAMT,
                                     CLOSBAL
                            FROM     #LEDGERCURSOR
                            ORDER BY CLTCODE,
                                     EVDT DESC,
                                     VTYP,
                                     VNO
  
  SELECT CLTCODE,
         VAMT    BALAMT,
         0       AGEDAYS,
         DRCR
  INTO   #FINTEMPAGEING
  FROM   #LEDGER
  WHERE  1 = 2
             
  OPEN @@balcur
  
  FETCH NEXT FROM @@balcur
  INTO @@cltcode,
       @@vtyp,
       @@vno,
       @@EVdt,
       @@vamt,
       @@closbal
       
  WHILE @@FETCH_STATUS = 0
    BEGIN
      SELECT @@ocltcode = @@cltcode
      
      SELECT @@balamt = ABS(@@closbal)
      
      IF @@closbal >= 0
        BEGIN
          SELECT @@drcr = 'd'
        END
      ELSE
        BEGIN
          SELECT @@drcr = 'c'
        END
        
      WHILE @@FETCH_STATUS = 0
            AND @@ocltcode = @@cltcode
            AND @@balamt > 0
        BEGIN
          IF @@balamt >= @@vamt
            BEGIN
              INSERT INTO #FINTEMPAGEING
              SELECT @@cltcode,
                     @@vamt,
                     DATEDIFF(DAY,@@EVdt,@todate),
                     @@drcr
              
              SELECT @@balamt = @@balamt - @@vamt
            END
            
          ELSE
            BEGIN
              INSERT INTO #FINTEMPAGEING
              SELECT @@cltcode,
                     @@balamt,
                     DATEDIFF(DAY,@@EVdt,@todate),
                     @@drcr
              
              SELECT @@balamt = @@balamt - @@vamt
            END
            
          FETCH NEXT FROM @@balcur
          INTO @@cltcode,
               @@vtyp,
               @@vno,
               @@EVdt,
               @@vamt,
               @@closbal
        END
        
      IF @@balamt > 0
        BEGIN
          INSERT INTO #FINTEMPAGEING
          SELECT @@ocltcode,
                 @@balamt,
                 181,
                 @@drcr
          
          SELECT @@balamt = @@balamt - @@vamt
        END
        
      WHILE @@FETCH_STATUS = 0
            AND @@ocltcode = @@cltcode
        BEGIN
          FETCH NEXT FROM @@balcur
          INTO @@cltcode,
               @@vtyp,
               @@vno,
               @@EVdt,
               @@vamt,
               @@closbal
        END
    END
    
  CLOSE @@balcur
  
  DEALLOCATE @@balcur
  
  PRINT 'cursor closed'
  
  PRINT CONVERT(DATETIME,GETDATE(),113)
  
  SELECT   CLTCODE,
           BALANCE = SUM(BALAMT),
           AGEDAYS = @Days1,
           DRCR
  INTO     #AGEINGLIST
  FROM     #FINTEMPAGEING
  WHERE    AGEDAYS >= 0
           AND AGEDAYS <= @Days1
  GROUP BY CLTCODE,DRCR
  ORDER BY CLTCODE,
           DRCR
           
  INSERT INTO #AGEINGLIST
  SELECT   CLTCODE,
           BALANCE = SUM(BALAMT),
           AGEDAYS = @Days2,
           DRCR
  FROM     #FINTEMPAGEING
  WHERE    AGEDAYS >= @Days1 + 1
           AND AGEDAYS <= @Days2
  GROUP BY CLTCODE,DRCR
  ORDER BY CLTCODE,
           DRCR
           
  INSERT INTO #AGEINGLIST
  SELECT   CLTCODE,
           BALANCE = SUM(BALAMT),
           AGEDAYS = @Days3,
           DRCR
  FROM     #FINTEMPAGEING
  WHERE    AGEDAYS >= @Days2 + 1
           AND AGEDAYS <= @Days3
  GROUP BY CLTCODE,DRCR
  ORDER BY CLTCODE,
           DRCR
           
  INSERT INTO #AGEINGLIST
  SELECT   CLTCODE,
           BALANCE = SUM(BALAMT),
           AGEDAYS = @Days4,
           DRCR
  FROM     #FINTEMPAGEING
  WHERE    AGEDAYS >= @Days3 + 1
           AND AGEDAYS <= @Days4
  GROUP BY CLTCODE,DRCR
  ORDER BY CLTCODE,
           DRCR
           
  INSERT INTO #AGEINGLIST
  SELECT   CLTCODE,
           BALANCE = SUM(BALAMT),
           AGEDAYS = @Days5,
           DRCR
  FROM     #FINTEMPAGEING
  WHERE    AGEDAYS >= @Days5
  GROUP BY CLTCODE,DRCR
  ORDER BY CLTCODE,
           DRCR
           
  PRINT 'done'
  
  PRINT CONVERT(DATETIME,GETDATE(),113)
  
  SELECT   A1.CLTCODE,
           SHORT_NAME = A2.SHORT_NAME,
           BALANCE,
           AGEDAYS,
           DRCR,
           A2.BRANCH_CD,
           A2.SUB_BROKER,
           B.BRANCH,
           S.NAME
  FROM     #AGEINGLIST A1,
           MSAJAG.DBO.CLIENT1 A2,
           MSAJAG.DBO.SUBBROKERS S,
           MSAJAG.DBO.BRANCH B--msajag.dbo.clientmaster a2--account.dbo.acmast  a2         
  WHERE    BALANCE >= @amoutgtthan
           AND A1.CLTCODE = A2.CL_CODE
           AND A2.BRANCH_CD = B.BRANCH_CODE
           AND A2.SUB_BROKER = S.SUB_BROKER
  ORDER BY A2.BRANCH_CD,
           A2.SUB_BROKER,
           A1.CLTCODE,
           A2.SHORT_NAME
           
  DROP TABLE #TEMPAGEING
  
  DROP TABLE #LEDGER
  
  DROP TABLE #LEDGERCURSOR
  
  DROP TABLE #AGEINGLIST
  
  DROP TABLE #FINTEMPAGEING

GO
