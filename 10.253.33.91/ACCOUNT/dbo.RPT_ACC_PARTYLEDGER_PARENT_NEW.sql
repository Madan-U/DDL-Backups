-- Object: PROCEDURE dbo.RPT_ACC_PARTYLEDGER_PARENT_NEW
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

      
--Exec RPT_ACC_PARTYLEDGER_PARENT_NEW 'Apr  1 2011','nov  7 2011','H25314','H25314','ACCODE','vdt','broker','broker',''      
      
/*SELECT * FROM LEDGER WHERE VNO = '200800000004' AND VTYP = 2      
SELECT * FROM LEDGER WHERE CLTCODE = '0A143' AND VDT >= 'APR  1 2008'      
SELECT * FROM LEDGER WHERE DRCR IS NULL      
SELECT * FROM LEDGER1 WHERE DRCR IS NULL      
UPDATE LEDGER1 SET DRCR = 'C' WHERE DRCR IS NULL*/      
--EXEC RPT_ACC_PARTYLEDGER_PARENT 'APR  1 2008','JAN  5 2009','0A143','0A143','ACCODE','VDT','BROKER','BROKER',''      
--  EXEC RPT_ACC_PARTYLEDGER_PARENT 'Oct  1 2010','Oct  4 2010','98RP61','98RP61','ACCODE','vdt','broker','broker',''      
CREATE PROCEDURE [dbo].[RPT_ACC_PARTYLEDGER_PARENT_NEW]      
(      
 @FDATE VARCHAR(11),            /* AS MMM DD YYYY */      
 @TDATE VARCHAR(11),            /* AS MMM DD YYYY */      
 @FCODE VARCHAR(10),      
 @TCODE VARCHAR(10),      
 @STRORDER VARCHAR(6),      
 @SELECTBY VARCHAR(3),      
 @STATUSID VARCHAR(15),      
 @STATUSNAME VARCHAR(15),      
 @STRBRANCH VARCHAR(10),      
 @ONDEMAND bit =0      
)      
      
AS      
/*========================================================================      
      EXEC RPT_ACC_PARTYLEDGER_ALL      
            'NOV  1 2005',      
            'DEC 31 2005',      
            'A',      
            'ZZZ',      
            'ACCODE',      
            'VDT',      
            'BROKER',      
            'UNDEFINED',      
            ''      
========================================================================*/      
      
DECLARE      
 @@OPENDATE   AS VARCHAR(11)      
-------------------------------------------------      
-- CREATING TEMPORARY TABLE      
-------------------------------------------------      
CREATE TABLE #OPPBALANCE      
(      
 CLTCODE VARCHAR(10),      
 OPPBAL MONEY      
)      
      
CREATE TABLE #LEDGERDATA (      
 [VTYP] [SMALLINT] NOT NULL,      
 [VNO] [VARCHAR](12) NOT NULL,      
 [EDT] [DATETIME] NULL,      
 [LNO] [INT] NOT NULL,      
 [ACNAME] [VARCHAR](100) NOT NULL,      
 [DRCR] [CHAR](1) NULL,      
 [VAMT] [MONEY] NULL,      
 [VDT] [DATETIME] NULL,      
 [VNO1] [VARCHAR](12) NULL,      
 [REFNO] [CHAR](20) NULL,      
 [BALAMT] [MONEY] NOT NULL,      
 [NODAYS] [INT] NULL,      
 [CDT] [DATETIME] NULL,      
 [CLTCODE] [VARCHAR](10) NOT NULL,      
 [BOOKTYPE] [CHAR](2) NOT NULL,      
 [ENTEREDBY] [VARCHAR](25) NULL,      
 [PDT] [DATETIME] NULL,      
 [CHECKEDBY] [VARCHAR](25) NULL,      
 [ACTNODAYS] [INT] NULL,      
 [NARRATION] [VARCHAR](234) NULL,      
 [SHORTDESC] [VARCHAR](35) NULL,      
 [PARENTCODE] VARCHAR(12)      
)      
-------------------------------------------------      
-- CREATING TEMPORARY TABLES      
-------------------------------------------------      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
/*CREATE TABLE #LEDGERCLIENTS(      
 [PARTY_CODE] [CHAR](10) NOT NULL,      
 [LONG_NAME] [VARCHAR](100) NULL,      
 [BANK_NAME] [VARCHAR](50) NOT NULL,      
 [L_ADDRESS1] [VARCHAR](40) NOT NULL,      
 [L_ADDRESS2] [VARCHAR](40) NULL,      
 [L_ADDRESS3] [VARCHAR](40) NULL,      
 [L_CITY] [VARCHAR](40) NULL,      
 [L_ZIP] [VARCHAR](10) NULL,      
 [RES_PHONE1] [VARCHAR](15) NULL,      
 [BRANCH_CD] [VARCHAR](10) NULL,      
 [FAMILY] [VARCHAR](10) NOT NULL,      
 [SUB_BROKER] [VARCHAR](10) NOT NULL,      
 [TRADER] [VARCHAR](20) NULL,      
 [CL_TYPE] [VARCHAR](3) NOT NULL,      
 [CLTDPID] [VARCHAR](20) NOT NULL,      
 [PARENTCODE] [VARCHAR](10) NOT NULL      
)      
      
/*GETTING CLIENT LIST*/      
INSERT INTO #LEDGERCLIENTS      
SELECT      
 C2.PARTY_CODE,      
 C1.LONG_NAME,      
 BANK_NAME = ISNULL(C4.BANKID, ''),      
 L_ADDRESS1,      
 L_ADDRESS2,      
 L_ADDRESS3,      
 L_CITY,      
 L_ZIP,      
 RES_PHONE1,      
 C1.BRANCH_CD,      
 FAMILY,      
 C1.SUB_BROKER,      
 TRADER,      
 CL_TYPE,      
 CLTDPID = ISNULL(CLTDPID, ''),      
 PARENTCODE      
FROM      
 BSEDB_AB.DBO.CLIENT1 C1 WITH(NOLOCK),      
 BSEDB_AB.DBO.CLIENT2 C2 WITH(NOLOCK)      
 LEFT OUTER JOIN      
 BSEDB_AB.DBO.CLIENT4 C4 WITH(NOLOCK)      
  ON      
  (      
   C2.PARTY_CODE = C4.PARTY_CODE      
   AND DEPOSITORY NOT IN ('NSDL', 'CDSL')      
   AND DEFDP = 0      
  )      
WHERE      
 C1.CL_CODE = C2.CL_CODE      
 AND C2.PARTY_CODE BETWEEN @FCODE AND @TCODE      
 AND C2.PARENTCODE BETWEEN @FCODE AND @TCODE      
 AND C1.BRANCH_CD LIKE (      
  CASE      
  WHEN @STATUSID = 'BRANCH'      
  THEN @STATUSNAME      
  ELSE '%'      
  END      
  )      
 AND SUB_BROKER LIKE (      
  CASE      
  WHEN @STATUSID = 'SUBBROKER'      
  THEN @STATUSNAME      
  ELSE '%'      
  END      
  )      
 AND SUB_BROKER LIKE (      
  CASE      
  WHEN @STATUSID = 'SUB_BROKER'      
  THEN @STATUSNAME      
  ELSE '%'      
  END      
  )      
 AND TRADER LIKE (      
  CASE      
  WHEN @STATUSID = 'TRADER'      
  THEN @STATUSNAME      
  ELSE '%'      
  END      
  )      
 AND AREA LIKE (      
  CASE      
  WHEN @STATUSID = 'AREA'      
  THEN @STATUSNAME      
  ELSE '%'      
  END      
  )      
 AND REGION LIKE (      
  CASE      
  WHEN @STATUSID = 'REGION'      
  THEN @STATUSNAME      
  ELSE '%'      
  END      
  )      
 AND C1.FAMILY LIKE (      
  CASE      
  WHEN @STATUSID = 'FAMILY'      
  THEN @STATUSNAME      
  ELSE '%'      
  END      
  )      
 AND C2.PARTY_CODE LIKE (      
  CASE      
  WHEN @STATUSID = 'CLIENT'      
  THEN @STATUSNAME      
  ELSE '%'      
  END      
  )      
 AND C1.BRANCH_CD LIKE @STRBRANCH +'%'*/      
      
      
/*GETTING LAST OPENING DATE */      
 IF UPPER(@SELECTBY) = 'VDT'      
 BEGIN      
  SELECT      
  @@OPENDATE =      
  (      
   SELECT      
   LEFT(CONVERT(VARCHAR, ISNULL(MAX(SDTCUR), 0), 109), 11)      
   FROM PARAMETER WITH(NOLOCK)      
   WHERE SDTCUR < = @FDATE      
  )      
 END      
 ELSE      
 BEGIN      
  SELECT      
  @@OPENDATE =      
  (      
   SELECT      
   LEFT(CONVERT(VARCHAR, ISNULL(MAX(SDTCUR), 0), 109), 11)      
   FROM PARAMETER WITH(NOLOCK)      
   WHERE SDTCUR < = @FDATE      
  )      
 END      
      
 IF @ONDEMAND = 0      
 BEGIN      
 /*GETTING OPENING BALANCE*/      
  IF @SELECTBY = 'VDT'      
  BEGIN      
   IF @@OPENDATE = @FDATE      
   BEGIN      
    INSERT      
    INTO #OPPBALANCE      
    SELECT      
     PARENTCODE,      
     OPPBAL = ISNULL(SUM(      
     CASE      
     WHEN UPPER(B.DRCR) = 'D'      
     THEN B.VAMT      
     ELSE -B.VAMT      
     END      
     ), 0)      
    FROM LEDGER B WITH(NOLOCK), #LEDGERCLIENTS C2 WITH(NOLOCK)      
    WHERE      
     B.CLTCODE = C2.PARTY_CODE      
/*     AND PARENTCODE > = @FCODE      
     AND PARENTCODE < = @TCODE                  */      
     AND B.VDT LIKE @FDATE + '%'      
     AND VTYP = 18      
    GROUP BY PARENTCODE      
   END      
   ELSE      
   BEGIN      
    INSERT      
    INTO #OPPBALANCE      
    SELECT      
     PARENTCODE,      
     OPPBAL = ISNULL(SUM(      
     CASE      
     WHEN UPPER(B.DRCR) = 'D'      
     THEN B.VAMT      
     ELSE -B.VAMT      
     END      
     ), 0)      
    FROM LEDGER B WITH(NOLOCK), #LEDGERCLIENTS C2 WITH(NOLOCK)      
    WHERE      
     B.CLTCODE = C2.PARTY_CODE      
/*     AND PARENTCODE > = @FCODE      
     AND PARENTCODE < = @TCODE                                            */      
     AND B.VDT > = @@OPENDATE + ' 00:00:00'      
     AND VDT < @FDATE      
    GROUP BY PARENTCODE      
   END      
  END      
  ELSE      
  BEGIN      
   IF @@OPENDATE = @FDATE      
   BEGIN      
   INSERT      
   INTO #OPPBALANCE      
   SELECT      
    CLTCODE,      
    OPBAL = SUM(OPBAL)      
    FROM      
    (      
    SELECT      
     CLTCODE = PARENTCODE,      
     OPBAL = ISNULL(SUM(      
     CASE      
     WHEN UPPER(DRCR) = 'D'      
     THEN VAMT      
     ELSE -VAMT      
    END      
    ), 0)      
    FROM LEDGER B WITH(NOLOCK), #LEDGERCLIENTS C2 WITH(NOLOCK)      
    WHERE      
     B.CLTCODE = C2.PARTY_CODE      
/*     AND PARENTCODE > = @FCODE      
     AND PARENTCODE < = @TCODE                                                  */      
     AND EDT LIKE @@OPENDATE + '%'      
     AND VTYP = 18      
    GROUP BY PARENTCODE      
      
   UNION ALL      
      
   SELECT      
    CLTCODE = PARENTCODE,      
    OPPBAL = ISNULL(SUM(      
    CASE      
    WHEN UPPER(B.DRCR) = 'C'      
    THEN B.VAMT      
    ELSE -B.VAMT      
    END      
    ), 0)      
   FROM LEDGER B WITH(NOLOCK), #LEDGERCLIENTS C2 WITH(NOLOCK)      
   WHERE      
    B.CLTCODE = C2.PARTY_CODE      
/*    AND PARENTCODE > = @FCODE      
    AND PARENTCODE < = @TCODE                                                 */      
    AND B.VDT < @@OPENDATE      
    AND EDT >= @@OPENDATE      
   GROUP BY PARENTCODE      
   )      
   T      
   GROUP BY CLTCODE      
  END      
  ELSE      BEGIN      
   INSERT      
   INTO #OPPBALANCE      
   SELECT      
   CLTCODE,      
   OPBAL = SUM(OPBAL)      
   FROM      
   (      
   SELECT      
   CLTCODE = PARENTCODE,      
   OPBAL = ISNULL(SUM(      
   CASE      
   WHEN UPPER(DRCR) = 'D'      
   THEN VAMT      
   ELSE -VAMT      
   END      
   ), 0)      
   FROM LEDGER B WITH(NOLOCK), #LEDGERCLIENTS C2 WITH(NOLOCK)      
   WHERE      
   B.CLTCODE = C2.PARTY_CODE      
/*   AND PARENTCODE > = @FCODE      
   AND PARENTCODE < = @TCODE                                             */      
   AND EDT LIKE @@OPENDATE + '%'      
   AND VTYP = 18      
   GROUP BY PARENTCODE      
   UNION ALL      
   SELECT      
   CLTCODE = PARENTCODE,      
   OPBAL = SUM(      
   CASE      
   WHEN UPPER(DRCR) = 'D'      
   THEN VAMT      
   ELSE -VAMT      
   END      
   )      
   FROM LEDGER B WITH(NOLOCK), #LEDGERCLIENTS C2 WITH(NOLOCK)      
   WHERE      
   B.CLTCODE = C2.PARTY_CODE      
/*   AND PARENTCODE > = @FCODE      
   AND PARENTCODE < = @TCODE                                                */      
   AND EDT > = @@OPENDATE + ' 00:00:00'      
   AND EDT < @FDATE      
   AND VTYP <> 18      
   GROUP BY PARENTCODE      
   UNION ALL      
   SELECT      
   CLTCODE = PARENTCODE,      
   OPPBAL = ISNULL(SUM(      
   CASE      
   WHEN UPPER(B.DRCR) = 'C'      
   THEN B.VAMT      
   ELSE -B.VAMT      
   END      
   ), 0)      
   FROM LEDGER B WITH(NOLOCK), #LEDGERCLIENTS C2 WITH(NOLOCK)      
   WHERE      
   B.CLTCODE = C2.PARTY_CODE      
/*   AND PARENTCODE > = @FCODE      
   AND PARENTCODE < = @TCODE                                               */      
   AND B.VDT < @@OPENDATE      
   AND EDT >= @@OPENDATE      
   GROUP BY PARENTCODE      
   )      
   T      
   GROUP BY CLTCODE      
  END      
 END      
      
      
      
      
 /*GETTING FIILTERED LEDGER*/      
 IF @SELECTBY = 'VDT'      
 BEGIN      
  INSERT      
  INTO #LEDGERDATA      
  SELECT      
   VTYP,VNO,EDT,LNO,ACNAME,DRCR,VAMT,VDT,VNO1,REFNO,BALAMT,NODAYS,CDT,CLTCODE,BOOKTYPE,ENTEREDBY,PDT,CHECKEDBY,ACTNODAYS,L.NARRATION,      
   ISNULL(V.SHORTDESC, '') SHORTDESC, PARENTCODE = ''      
  FROM      
   (SELECT * FROM LEDGER L1 WITH(NOLOCK)       
   WHERE VDT > = @FDATE + ' 00:00:00' AND VDT < = @TDATE +' 23:59:59'      
   AND EXISTS(      
    SELECT PARTY_CODE, PARENTCODE FROM #LEDGERCLIENTS C2      
    WHERE      
    L1.CLTCODE = C2.PARTY_CODE      
   )) L,      
   VMAST V WITH(NOLOCK)      
  WHERE      
   L.VTYP = V.VTYPE      
      
 END      
 ELSE      
 BEGIN      
  INSERT      
  INTO #LEDGERDATA      
   SELECT      
   VTYP,VNO,EDT,LNO,ACNAME,DRCR,VAMT,VDT,VNO1,REFNO,BALAMT,NODAYS,CDT,CLTCODE,BOOKTYPE,ENTEREDBY,PDT,CHECKEDBY,ACTNODAYS,L.NARRATION,      
   ISNULL(V.SHORTDESC, '') SHORTDESC, PARENTCODE = ''      
  FROM      
   (SELECT * FROM LEDGER L1 WITH(NOLOCK) WHERE EDT > = @FDATE + ' 00:00:00' AND EDT < = @TDATE +' 23:59:59'      
   AND EXISTS(      
    SELECT PARTY_CODE, PARENTCODE FROM #LEDGERCLIENTS C2      
    WHERE      
    L1.CLTCODE = C2.PARTY_CODE      
   )) L,      
   VMAST V WITH(NOLOCK)      
  WHERE      
   L.VTYP = V.VTYPE      
 END      
END      
ELSE      
BEGIN      
 /*GETTING OPENING BALANCE*/      
 IF @SELECTBY = 'VDT'      
 BEGIN      
  IF @@OPENDATE = @FDATE      
  BEGIN      
   INSERT      
   INTO #OPPBALANCE      
   SELECT      
   PARENTCODE,      
   OPPBAL = ISNULL(SUM(      
   CASE      
   WHEN UPPER(B.DRCR) = 'D'      
   THEN B.VAMT      
   ELSE -B.VAMT      
   END      
   ), 0)      
   FROM LEDGER B WITH(NOLOCK), #LEDGERCLIENTS C2 WITH(NOLOCK)      
   WHERE      
   B.CLTCODE = C2.PARTY_CODE      
   AND PARENTCODE > = @FCODE      
   AND PARENTCODE < = @TCODE      
   AND B.VDT LIKE @FDATE + '%'      
   AND VTYP = 18      
   GROUP BY PARENTCODE      
  END      
  ELSE      
  BEGIN      
   INSERT      
   INTO #OPPBALANCE      
   SELECT      
   PARENTCODE,      
   OPPBAL = ISNULL(SUM(      
   CASE                                                                     WHEN UPPER(B.DRCR) = 'D'      
   THEN B.VAMT      
   ELSE -B.VAMT      
   END      
   ), 0)      
   FROM LEDGER B WITH(NOLOCK), #LEDGERCLIENTS C2 WITH(NOLOCK)      
   WHERE      
   B.CLTCODE = C2.PARTY_CODE      
   AND PARENTCODE > = @FCODE      
   AND PARENTCODE < = @TCODE      
   AND B.VDT > = @@OPENDATE + ' 00:00:00'      
   AND VDT < @FDATE      
   AND VTYP <> 8      
   GROUP BY PARENTCODE      
  END      
 END      
 ELSE      
 BEGIN      
  IF @@OPENDATE = @FDATE      
  BEGIN      
   INSERT      
   INTO #OPPBALANCE      
   SELECT      
    CLTCODE,      
    OPBAL = SUM(OPBAL)      
    FROM      
    (      
    SELECT      
    CLTCODE = PARENTCODE,      
    OPBAL = ISNULL(SUM(      
    CASE      
    WHEN UPPER(DRCR) = 'D'      
    THEN VAMT      
    ELSE -VAMT      
    END      
    ), 0)      
   FROM LEDGER B WITH(NOLOCK), #LEDGERCLIENTS C2 WITH(NOLOCK)      
   WHERE      
    B.CLTCODE = C2.PARTY_CODE      
/*    AND PARENTCODE > = @FCODE      
    AND PARENTCODE < = @TCODE                                                  */      
    AND EDT LIKE @@OPENDATE + '%'      
    AND VTYP = 18      
   GROUP BY PARENTCODE      
   UNION ALL      
   SELECT      
    CLTCODE = PARENTCODE,      
    OPPBAL = ISNULL(SUM(      
    CASE      
    WHEN UPPER(B.DRCR) = 'C'      
    THEN B.VAMT      
    ELSE -B.VAMT      
    END      
    ), 0)      
   FROM LEDGER B WITH(NOLOCK), #LEDGERCLIENTS C2 WITH(NOLOCK)      
   WHERE      
    B.CLTCODE = C2.PARTY_CODE      
/*    AND PARENTCODE > = @FCODE      
    AND PARENTCODE < = @TCODE                                                 */      
    AND B.VDT < @@OPENDATE      
    AND EDT >= @@OPENDATE      
    AND VTYP <> 8      
   GROUP BY PARENTCODE      
   )      
   T      
   GROUP BY CLTCODE      
  END      
  ELSE      
  BEGIN      
   INSERT      
   INTO #OPPBALANCE      
   SELECT      
    CLTCODE,      
    OPBAL = SUM(OPBAL)      
    FROM      
    (      
    SELECT      
    CLTCODE = PARENTCODE,      
    OPBAL = ISNULL(SUM(      
    CASE      
    WHEN UPPER(DRCR) = 'D'      
    THEN VAMT      
    ELSE -VAMT      
    END      
    ), 0)      
   FROM LEDGER B WITH(NOLOCK), #LEDGERCLIENTS C2 WITH(NOLOCK)      
   WHERE      
    B.CLTCODE = C2.PARTY_CODE      
/*    AND PARENTCODE > = @FCODE      
    AND PARENTCODE < = @TCODE                                             */      
    AND EDT LIKE @@OPENDATE + '%'      
    AND VTYP = 18      
   GROUP BY PARENTCODE      
   UNION ALL      
   SELECT      
    CLTCODE = PARENTCODE,      
    OPBAL = SUM(      
    CASE      
    WHEN UPPER(DRCR) = 'D'      
    THEN VAMT      
    ELSE -VAMT      
    END      
    )      
   FROM LEDGER B WITH(NOLOCK), #LEDGERCLIENTS C2 WITH(NOLOCK)      
   WHERE      
    B.CLTCODE = C2.PARTY_CODE      
/*    AND PARENTCODE > = @FCODE      
    AND PARENTCODE < = @TCODE                                                */      
    AND EDT > = @@OPENDATE + ' 00:00:00'      
    AND EDT < @FDATE      
    AND VTYP NOT IN (8, 18)      
   GROUP BY PARENTCODE      
   UNION ALL      
   SELECT      
    CLTCODE = PARENTCODE,      
    OPPBAL = ISNULL(SUM(      
    CASE      
    WHEN UPPER(B.DRCR) = 'C'      
    THEN B.VAMT      
    ELSE -B.VAMT      
    END      
    ), 0)      
   FROM LEDGER B WITH(NOLOCK), #LEDGERCLIENTS C2 WITH(NOLOCK)      
   WHERE      
    B.CLTCODE = C2.PARTY_CODE      
/*    AND PARENTCODE > = @FCODE      
    AND PARENTCODE < = @TCODE                      */      
    AND B.VDT < @@OPENDATE      
    AND EDT >= @@OPENDATE      
   GROUP BY PARENTCODE      
   )      
   T      
   GROUP BY CLTCODE      
  END      
 END      
      
      
      
      
 /*GETTING FIILTERED LEDGER*/      
 IF @SELECTBY = 'VDT'      
 BEGIN      
  INSERT      
  INTO #LEDGERDATA      
   SELECT      
   VTYP,VNO,EDT,LNO,ACNAME,DRCR,VAMT,VDT,VNO1,REFNO,BALAMT,NODAYS,CDT,CLTCODE,BOOKTYPE,ENTEREDBY,PDT,CHECKEDBY,ACTNODAYS,L.NARRATION,      
   ISNULL(V.SHORTDESC, '') SHORTDESC, PARENTCODE      
  FROM      
   (SELECT * FROM LEDGER WITH(NOLOCK) WHERE VDT > = @FDATE + ' 00:00:00' AND VDT < = @TDATE +' 23:59:59') L,      
   (SELECT * FROM VMAST WITH(NOLOCK) WHERE VTYPE <> 8) V,      
   (SELECT PARTY_CODE, PARENTCODE FROM #LEDGERCLIENTS      
  WHERE      
   PARENTCODE > = @FCODE      
   AND PARENTCODE < = @TCODE) C2      
  WHERE      
   L.VTYP = V.VTYPE      
   AND L.CLTCODE = C2.PARTY_CODE      
 END      
 ELSE      
 BEGIN      
  INSERT      
  INTO #LEDGERDATA      
   SELECT      
   VTYP,VNO,EDT,LNO,ACNAME,DRCR,VAMT,VDT,VNO1,REFNO,BALAMT,NODAYS,CDT,CLTCODE,BOOKTYPE,ENTEREDBY,PDT,CHECKEDBY,ACTNODAYS,L.NARRATION,      
   ISNULL(V.SHORTDESC, '') SHORTDESC, PARENTCODE      
  FROM       
   (SELECT * FROM LEDGER WITH(NOLOCK) WHERE EDT > = @FDATE + ' 00:00:00' AND EDT < = @TDATE +' 23:59:59') L ,      
   (SELECT * FROM VMAST WITH(NOLOCK) WHERE VTYPE <> 8) V,      
   (SELECT PARTY_CODE, PARENTCODE FROM #LEDGERCLIENTS      
  WHERE       
   PARENTCODE > = @FCODE      
   AND PARENTCODE < = @TCODE) C2      
  WHERE      
   L.VTYP = V.VTYPE      
   AND L.CLTCODE = C2.PARTY_CODE      
 END      
END      
      
      CREATE TABLE [#TMPLEDGER] (      
       [BOOKTYPE] [CHAR] (2)  NULL ,      
       [VOUDT] [DATETIME] NULL ,      
       [EFFDT] [DATETIME] NULL ,      
       [SHORTDESC] [VARCHAR] (35)  NULL ,      
       [DRAMT] [MONEY] NULL ,      
       [CRAMT] [MONEY] NULL ,      
       [VNO] [VARCHAR] (12)  NULL ,      
       [DDNO] [VARCHAR] (30)  NULL ,      
       [NARRATION] [VARCHAR] (234)  NULL ,      
       [CLTCODE] [VARCHAR] (10)  NOT NULL ,      
       [VTYP] [SMALLINT] NULL ,      
       [VDT] [VARCHAR] (30)  NULL ,      
       [EDT] [VARCHAR] (30)  NULL ,      
       [ACNAME] [VARCHAR] (100)  NULL ,      
       [OPBAL] [MONEY] NULL ,      
       [L_ADDRESS1] [VARCHAR] (40)  NOT NULL ,      
       [L_ADDRESS2] [VARCHAR] (40)  NULL ,      
       [L_ADDRESS3] [VARCHAR] (40)  NULL ,      
       [L_CITY] [VARCHAR] (40)  NULL ,      
       [L_ZIP] [VARCHAR] (10)  NULL ,      
       [RES_PHONE1] [VARCHAR] (15)  NULL ,      
       [BRANCH_CD] [VARCHAR] (10)  NOT NULL ,      
       [CROSAC] [VARCHAR] (10)  NULL ,      
       [EDIFF] [INT] NULL ,      
       [FAMILY] [VARCHAR] (10)  NOT NULL ,      
       [SUB_BROKER] [VARCHAR] (10)  NOT NULL ,      
       [TRADER] [VARCHAR] (20)  NOT NULL ,      
       [CL_TYPE] [VARCHAR] (3)  NOT NULL ,      
       [BANK_NAME] [VARCHAR] (50)  NOT NULL ,      
       [CLTDPID] [VARCHAR] (20)  NOT NULL ,      
       [LNO] [INT] NULL,      
       [PDT] [DATETIME] NULL,      
       [PARENTCODE] VARCHAR(10) NULL      
      ) ON [PRIMARY]      
      
/*GETTING LDDGER ENTRIES*/      
      INSERT      
            INTO #TMPLEDGER      
      SELECT      
            L.BOOKTYPE,      
            VOUDT = L.VDT,      
            EFFDT = L.EDT,      
            L.SHORTDESC,      
            DRAMT = (      
            CASE      
             WHEN UPPER(L.DRCR) = 'D'      
                  THEN L.VAMT      
                  ELSE 0      
            END),      
            CRAMT = (      
            CASE      
                  WHEN UPPER(L.DRCR) = 'C'      
                  THEN L.VAMT      
                  ELSE 0      
            END      
            ),      
            L.VNO,      
            DDNO = SPACE(15),      
            L.NARRATION,      
            C.PARTY_CODE CLTCODE,      
            L.VTYP,      
            CONVERT(VARCHAR, L.VDT, 103) VDT,      
            CONVERT(VARCHAR, L.EDT, 103) EDT,      
--            L.ACNAME ,      
            C.LONG_NAME,      
            OPBAL = VAMT,      
   C.L_ADDRESS1,      
            C.L_ADDRESS2,      
            C.L_ADDRESS3,      
            C.L_CITY,      
            C.L_ZIP,      
            C.RES_PHONE1,      
            C.BRANCH_CD,      
            L.CLTCODE CROSAC ,      
            EDIFF = DATEDIFF(D, L.EDT, GETDATE()),      
            C.FAMILY,      
            C.SUB_BROKER,      
            C.TRADER,      
            C.CL_TYPE,      
            C.BANK_NAME,      
            C.CLTDPID,      
            L.LNO,      
      L.PDT,      
      C.PARENTCODE      
      FROM #LEDGERDATA L WITH(NOLOCK)      
      RIGHT OUTER JOIN      
            #LEDGERCLIENTS C WITH(NOLOCK)      
            ON      
            (      
                  L.CLTCODE = C.PARTY_CODE      
            )      
      
      
      
/*UPDATING OPENING BLANACE*/      
      UPDATE      
            #TMPLEDGER      
            SET OPBAL = 0      
      
      UPDATE      
            #TMPLEDGER      
            SET OPBAL = T.OPPBAL      
      FROM #TMPLEDGER L WITH(NOLOCK),      
            #OPPBALANCE T WITH(NOLOCK)      
      WHERE L.PARENTCODE = T.CLTCODE      
      
      
      
/*UPDATING CHEQUE NUMBER*/      
      UPDATE      
            #TMPLEDGER      
     SET DDNO = L1.DDNO      
      FROM LEDGER1 L1 WITH(NOLOCK)      
      WHERE L1.VNO = #TMPLEDGER.VNO      
            AND L1.VTYP = #TMPLEDGER.VTYP      
            AND L1.BOOKTYPE = #TMPLEDGER.BOOKTYPE      
  AND L1.LNO = #TMPLEDGER.LNO      
      
      
 /*      
/*UPDATING CROSS ACCOUNT CODE*/      
     UPDATE      
       #TMPLEDGER      
            SET #TMPLEDGER.CROSAC = B.CLTCODE      
      FROM LEDGER B WITH(NOLOCK),      
            ACMAST V WITH(NOLOCK)      
      WHERE B.CLTCODE = V.CLTCODE      
            AND V.ACCAT = 2      
            AND #TMPLEDGER.BOOKTYPE = B.BOOKTYPE      
            AND #TMPLEDGER.VNO = B.VNO      
            AND #TMPLEDGER.VTYP = B.VTYP      
            AND LTRIM(RTRIM(#TMPLEDGER.VTYP)) IN ('01', '1', '02', '2', '03', '3', '04', '4', '05', '5', '16', '17', '19', '20', '22', '23')      
      
      
      
/*UPDATING BANK NAME*/      
      UPDATE      
            #TMPLEDGER      
            SET #TMPLEDGER.BANK_NAME = B.BANK_NAME      
      FROM BSEDB_AB.DBO.POBANK B WITH(NOLOCK)      
      WHERE LTRIM(RTRIM(CAST(B.BANKID AS CHAR))) = LTRIM(RTRIM(#TMPLEDGER.BANK_NAME))*/      
      
      
      
      
IF @STRORDER = 'ACCODE'      
BEGIN      
 IF @SELECTBY = 'VDT'      
 BEGIN      
  --PRINT 'T1'      
  SELECT      
  L.BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT,CRAMT,VNO,DDNO,NARRATION,CLTCODE=L.PARENTCODE,VTYP,VDT,EDT,    
L.ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,CROSAC = L.CLTCODE,EDIFF,FAMILY,    
SUB_BROKER,TRADER,CL_TYPE, BANK_NAME,CLTDPID,LNO,PDT      
  FROM #TMPLEDGER L WITH(NOLOCK) 
  --WHERE (CRAMT <> 0 OR DRAMT <> 0 OR OPBAL <> 0) --SRE-42136     
  ORDER BY L.CLTCODE,      
  VOUDT, PDT      
 END      
 ELSE      
 BEGIN      
  SELECT      
  L.BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT,CRAMT,VNO,DDNO,NARRATION,CLTCODE=L.PARENTCODE,VTYP,VDT,EDT,    
L.ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,CROSAC = L.CLTCODE,EDIFF,FAMILY,    
SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT      
  FROM #TMPLEDGER L WITH(NOLOCK)
  --WHERE  (CRAMT <> 0 OR DRAMT <> 0 OR OPBAL <> 0)      --SRE-42136
  ORDER BY L.CLTCODE,      
  EFFDT, PDT      
 END      
END      
ELSE      
BEGIN      
 IF @SELECTBY = 'VDT'      
 BEGIN      
  SELECT      
  L.BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT,CRAMT,VNO,DDNO,NARRATION,CLTCODE=L.PARENTCODE,VTYP,VDT,EDT,    
L.ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,CROSAC = L.CLTCODE,EDIFF,FAMILY,    
SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT      
  FROM #TMPLEDGER L WITH(NOLOCK)
  --WHERE  (CRAMT <> 0 OR DRAMT <> 0 OR OPBAL <> 0)      --SRE-42136
  ORDER BY L.ACNAME,      
  VOUDT, PDT      
 END      
 ELSE      
 BEGIN      
  SELECT      
  L.BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT,CRAMT,VNO,DDNO,NARRATION,CLTCODE=L.PARENTCODE,VTYP,VDT,EDT,    
L.ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,CROSAC = L.CLTCODE,EDIFF,FAMILY,    
SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT      
  FROM #TMPLEDGER L WITH(NOLOCK) 
  --WHERE (CRAMT <> 0 OR DRAMT <> 0 OR OPBAL <> 0)     --SRE-42136 
  ORDER BY L.ACNAME,      
  EFFDT, PDT      
 END      
END      
      
/*  ------------------------------   END OF THE PROC  -------------------------------------*/      
      
-------------------------------------------------      
-- DESTROYING TEMPORARY TABLE      
-------------------------------------------------      
TRUNCATE TABLE #OPPBALANCE      
--TRUNCATE TABLE #LEDGERCLIENTS      
TRUNCATE TABLE #LEDGERDATA      
      
DROP TABLE #OPPBALANCE      
--DROP TABLE #LEDGERCLIENTS      
DROP TABLE #LEDGERDATA      
-------------------------------------------------      
-- DESTROYING TEMPORARY TABLE      
-------------------------------------------------

GO
