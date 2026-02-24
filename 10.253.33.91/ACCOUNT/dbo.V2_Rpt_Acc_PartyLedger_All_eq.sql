-- Object: PROCEDURE dbo.V2_Rpt_Acc_PartyLedger_All_eq
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------






    
CREATE PROCEDURE [dbo].[V2_Rpt_Acc_PartyLedger_All_eq]            
                @FDATE      VARCHAR(11),            /* AS MMM DD YYYY */            
                @TDATE      VARCHAR(11),            /* AS MMM DD YYYY */            
                @FCODE      VARCHAR(10),            
                @TCODE      VARCHAR(10),            
                @STRORDER   VARCHAR(6),            
                @SELECTBY   VARCHAR(3),             
                @STATUSID   VARCHAR(15),            
                @STATUSNAME VARCHAR(15),            
                @STATUSNAME_TO VARCHAR(15),
                       
                @ORDERFLG   VARCHAR(1)  = 'N',            
                @EXCSEGMENT VARCHAR(1000) = '',            
                @ENTITY_TYPE VARCHAR(20) = 'ENTITY',            
                @SINGLE     VARCHAR(1)  = 'N',            
                @FORPDF  VARCHAR(1) = 'N',          
                @CSV   VARCHAR(1) = 'N'            
                            
            
AS            
/*            
SELECT * FROM COMPANY_MASTER_SETTING            
 EXEC [V2_RPT_ACC_PARTYLEDGER_ALL] 'APR 1 2008','MAR 2 2009','0','0A143','ACCODE','VDT','BROKER','BROKER','','','','','ACCOUNT~ACCOUNTBSE~ACCOUNTFO'            
COMMIT            
EXEC RPT_ACC_PARTYLEDGER_ALL 'APR  1 2008','MAR  2 2009','0','0A143','ACCODE','VDT','BROKER','BROKER','',''            
COMMIT            
*/            
            
  
          
SET NOCOUNT ON            
            
  BEGIN            
 IF LEN(@FDATE) = 10 AND CHARINDEX('/', @FDATE) > 0            
  BEGIN            
   SET @FDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FDATE, 103), 109)            
  END            
 IF LEN(@TDATE) = 10 AND CHARINDEX('/', @TDATE) > 0            
  BEGIN            
   SET @TDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TDATE, 103), 109)            
  END            
    CREATE TABLE [DBO].[#TMPLEDGERNEW] (            
  [BOOKTYPE]   [CHAR](2)   NULL,            
  [VOUDT]      [DATETIME]   NULL,            
  [EFFDT]      [DATETIME]   NULL,            
  [SHORTDESC]  [CHAR](6)   NULL,            
  [DRAMT]      [MONEY]   NULL,            
  [CRAMT]      [MONEY]   NULL,            
  [VNO]        [VARCHAR](12)   NULL,            
  [DDNO]       [VARCHAR](15)   NULL,            
  [NARRATION]  [VARCHAR](234)   NULL,            
  [CLTCODE]    [VARCHAR](10)   NOT NULL,            
  [VTYP]       [SMALLINT]   NULL,            
  [VDT]        [VARCHAR](30)   NULL,            
  [EDT]        [VARCHAR](30)   NULL,            
  [ACNAME]     [VARCHAR](100)   NULL,            
  [OPBAL]      [MONEY]   NULL,            
  [L_ADDRESS1] [VARCHAR](40)   NULL,            
  [L_ADDRESS2] [VARCHAR](40)   NULL,            
  [L_ADDRESS3] [VARCHAR](40)   NULL,            
  [L_CITY]     [VARCHAR](40)   NULL,            
  [L_ZIP]      [VARCHAR](10)   NULL,            
  [RES_PHONE1] [VARCHAR](15)   NULL,            
  [BRANCH_CD]  [VARCHAR](10)   NULL,            
  [CROSAC]     [VARCHAR](10)   NULL,            
  [EDIFF]      [INT]   NULL,            
  [FAMILY]     [VARCHAR](10)   NULL,            
  [SUB_BROKER] [VARCHAR](10)   NULL,            
  [TRADER]     [VARCHAR](20)   NULL,            
  [CL_TYPE]    [VARCHAR](3)   NULL,            
  [BANK_NAME]  [VARCHAR](50)   NULL,            
  [CLTDPID]    [VARCHAR](20)   NULL,            
  [LNO]        [INT]    NULL,            
  [PDT]        [DATETIME]   NULL,            
  [EXCHANGE] [VARCHAR] (15) NULL,            
  [SEGMENT]    [VARCHAR](10)   NULL,            
  [ENTITY]     [VARCHAR](50)   NULL,            
  [ORDERSEG]   [BIGINT]   NULL,            
  [ACTIVE_SEG] [VARCHAR] (MAX),            
  [PARTYROWCOUNT] [INT] NULL,            
  [TOTALPAGES] [INT] NULL            
      )            
    ON [PRIMARY]            
            
 CREATE TABLE [DBO].[#DBNAME]                
 (                
  ACCOUNTDB VARCHAR(20),                 
  EXCHANGE VARCHAR(6),                 
  SEGMENT VARCHAR(10),                
  ACCOUNTSERVER VARCHAR(20),              
  SHAREDB VARCHAR(20),            
  GROUPID VARCHAR(20),            
  ORDER_SEGMENT INT              
 ) ON [PRIMARY]              
DECLARE  @@DB VARCHAR(1000)            
            
IF @EXCSEGMENT = ''            
 SELECT @EXCSEGMENT = EXCHANGE + '~' + SEGMENT FROM OWNER            
            
IF @ENTITY_TYPE = 'ENTITY'         
        
 SELECT @@DB = " INSERT INTO #DBNAME SELECT ACCOUNTDB, EXCHANGE, SEGMENT, ACCOUNTSERVER, SHAREDB, GROUPID, ORDER_SEGMENT FROM COMPANY_MASTER_SETTING (NOLOCK) WHERE EXCHANGE + '~' + SEGMENT IN ('" + REPLACE(@EXCSEGMENT,',',''',''') + "') ORDER BY EXCHANGE "                

ELSE        
        
 SELECT @@DB = " INSERT INTO #DBNAME SELECT ACCOUNTDB, EXCHANGE, SEGMENT, ACCOUNTSERVER, SHAREDB, GROUPID, ORDER_SEGMENT FROM COMPANY_MASTER_SETTING (NOLOCK) WHERE GROUPID IN ('" + REPLACE(@EXCSEGMENT,',',''',''') + "') ORDER BY GROUPID "                
            
PRINT @@DB            
EXEC(@@DB)              
            
DECLARE @@MAINREC AS CURSOR,            
  @@ACCOUNTDB VARCHAR(20),              
  @@SHAREDB VARCHAR(20),                 
  @@ACCOUNTSVR VARCHAR(20),                
  @@EXCHANGE VARCHAR(15),                
  @@SEGMENT VARCHAR(15),            
  @@GROUPID VARCHAR(20),            
  @@ORDERSEG VARCHAR(3),            
  @@ORDERSECOUNT INT            
SET @@ORDERSECOUNT = (SELECT COUNT(1) FROM COMPANY_MASTER_SETTING)             
            
DECLARE @@SQL VARCHAR(MAX)            
--SET @@SQL = ""            
SET @@MAINREC = CURSOR FOR                
     SELECT ACCOUNTDB, EXCHANGE, SEGMENT,ACCOUNTSERVER,SHAREDB,GROUPID,ORDER_SEGMENT FROM #DBNAME               
                 
OPEN @@MAINREC                
 FETCH NEXT FROM @@MAINREC INTO @@ACCOUNTDB, @@EXCHANGE, @@SEGMENT, @@ACCOUNTSVR, @@SHAREDB,@@GROUPID,@@ORDERSEG                
  WHILE @@FETCH_STATUS = 0                
  BEGIN               
  PRINT @@ACCOUNTDB             
 SET @@SQL = " INSERT INTO #TMPLEDGERNEW "            
 SET @@SQL = @@SQL + " (BOOKTYPE, "            
 SET @@SQL = @@SQL +" VOUDT, "            
 SET @@SQL = @@SQL +" EFFDT, "            
 SET @@SQL = @@SQL +" SHORTDESC, "            
 SET @@SQL = @@SQL +" DRAMT, "            
 SET @@SQL = @@SQL +" CRAMT, "            
 SET @@SQL = @@SQL +" VNO, "            
 SET @@SQL = @@SQL +" DDNO, "            
 SET @@SQL = @@SQL +" NARRATION, "            
 SET @@SQL = @@SQL +" CLTCODE, "            
 SET @@SQL = @@SQL +" VTYP, "            
 SET @@SQL = @@SQL +" VDT, "            
 SET @@SQL = @@SQL +" EDT, "            
 SET @@SQL = @@SQL +" ACNAME, "            
 SET @@SQL = @@SQL +" OPBAL, "            
 SET @@SQL = @@SQL +" L_ADDRESS1, "            
 SET @@SQL = @@SQL +" L_ADDRESS2, "            
 SET @@SQL = @@SQL +" L_ADDRESS3, "            
 SET @@SQL = @@SQL +" L_CITY, "            
 SET @@SQL = @@SQL +" L_ZIP, "            
 SET @@SQL = @@SQL +" RES_PHONE1, "            
 SET @@SQL = @@SQL +" BRANCH_CD, "            
 SET @@SQL = @@SQL +" CROSAC, "            
 SET @@SQL = @@SQL +" EDIFF, "            
 SET @@SQL = @@SQL +" FAMILY, "            
 SET @@SQL = @@SQL +" SUB_BROKER, "            
 SET @@SQL = @@SQL +" TRADER, "            
 SET @@SQL = @@SQL +" CL_TYPE, "            
 SET @@SQL = @@SQL +" BANK_NAME, "            
 SET @@SQL = @@SQL +" CLTDPID, "            
 SET @@SQL = @@SQL +" LNO, "            
 SET @@SQL = @@SQL +" PDT) "            
           
 IF @@SERVERNAME <> @@ACCOUNTSVR     
        
 SET @@SQL = @@SQL +" EXEC "+@@ACCOUNTSVR+"."+@@ACCOUNTDB+"..RPT_ACC_PARTYLEDGER_EQ "     
          
 ELSE  
           
 SET @@SQL = @@SQL +" EXEC "+@@ACCOUNTDB+"..RPT_ACC_PARTYLEDGER_EQ "            
 SET @@SQL = @@SQL +"'" +@FDATE +"', "            
 SET @@SQL = @@SQL +"'" +@TDATE +"', "            
 SET @@SQL = @@SQL +"'" +@FCODE +"', "            
 SET @@SQL = @@SQL +"'" +@TCODE +"', "            
 SET @@SQL = @@SQL +"'" +@STRORDER +"', "            
 SET @@SQL = @@SQL +"'" +@SELECTBY +"', "            
 SET @@SQL = @@SQL +"'" +@STATUSID +"', "            
 SET @@SQL = @@SQL +"'" +@STATUSNAME+"', "            
 SET @@SQL = @@SQL +"'" +@STATUSNAME_TO+"' "               -- RETURN    
        
            
PRINT (@@SQL)             
EXEC (@@SQL)            
            
  IF @ORDERFLG = 'N'            
    BEGIN            
    UPDATE #TMPLEDGERNEW             
    SET EXCHANGE = @@EXCHANGE,             
     SEGMENT = @@SEGMENT,            
      ENTITY = 'SETTLEMENT LEDGER',            
     ORDERSEG = 1             
    WHERE  SEGMENT IS NULL             
END             
  ELSE             
   BEGIN            
    UPDATE #TMPLEDGERNEW             
      SET  EXCHANGE = @@EXCHANGE,            
       SEGMENT =@@SEGMENT,            
       ENTITY = CASE WHEN @ENTITY_TYPE = 'ENTITY' THEN @@SEGMENT +"-"+ @@EXCHANGE ELSE @@GROUPID + ' - SETTLEMENT LEDGER' END,            
       ORDERSEG = @@ORDERSEG             
    WHERE  SEGMENT IS NULL             
 END             
            
SET @@SQL = "  INSERT INTO #TMPLEDGERNEW "            
SET @@SQL = @@SQL + " (BOOKTYPE, "            
SET @@SQL = @@SQL + "  VOUDT, "            
SET @@SQL = @@SQL + "  EFFDT, "            
SET @@SQL = @@SQL + "  SHORTDESC, "            
SET @@SQL = @@SQL + "  DRAMT, "            
SET @@SQL = @@SQL + "  CRAMT, "            
SET @@SQL = @@SQL + "  VNO, "            
SET @@SQL = @@SQL + "  DDNO, "            
SET @@SQL = @@SQL + "  NARRATION, "            
SET @@SQL = @@SQL + "  CLTCODE, "            
SET @@SQL = @@SQL + "  VTYP, "            
SET @@SQL = @@SQL + "  VDT, "            
SET @@SQL = @@SQL + "  EDT, "            
SET @@SQL = @@SQL + "  ACNAME, "            
SET @@SQL = @@SQL + "  OPBAL, "            
SET @@SQL = @@SQL + "  L_ADDRESS1, "            
SET @@SQL = @@SQL + "  L_ADDRESS2, "            
SET @@SQL = @@SQL + "  L_ADDRESS3, "            
SET @@SQL = @@SQL + "  L_CITY, "            
SET @@SQL = @@SQL + "  L_ZIP, "            
SET @@SQL = @@SQL + "  RES_PHONE1, "            
SET @@SQL = @@SQL + "  BRANCH_CD, "            
SET @@SQL = @@SQL + "  CROSAC, "            
SET @@SQL = @@SQL + "  EDIFF, "            
SET @@SQL = @@SQL + "  FAMILY, "            
SET @@SQL = @@SQL + "  SUB_BROKER, "            
SET @@SQL = @@SQL + "  TRADER, "            
SET @@SQL = @@SQL + "  CL_TYPE, "            
SET @@SQL = @@SQL + "  BANK_NAME, "            
SET @@SQL = @@SQL + "  CLTDPID, "            
SET @@SQL = @@SQL + "  LNO, "            
SET @@SQL = @@SQL + "  PDT) "            
IF @@SERVERNAME <> @@ACCOUNTSVR            
SET @@SQL = @@SQL + "    EXEC "+ @@ACCOUNTSVR +"."+@@ACCOUNTDB+"..RPT_ACC_MARGINLEDGER "            
ELSE            
SET @@SQL = @@SQL + "    EXEC "+@@ACCOUNTDB+"..RPT_ACC_MARGINLEDGER "            
SET @@SQL = @@SQL +"'" + @FDATE +"', "            
SET @@SQL = @@SQL +"'" + @TDATE +"', "            
SET @@SQL = @@SQL +"'" + @FCODE +"', "            
SET @@SQL = @@SQL +"'" + @TCODE +"', "            
SET @@SQL = @@SQL +"'" + @STRORDER +"', "            
SET @@SQL = @@SQL +"'" + @SELECTBY +"', "            
SET @@SQL = @@SQL +"'" + @STATUSID +"', "            
SET @@SQL = @@SQL +"'" + @STATUSNAME +"', "            
SET @@SQL = @@SQL +"'" +@STATUSNAME_TO+"' "  
          
            
          PRINT (@@SQL)     
EXEC (@@SQL)            
    IF @ORDERFLG = 'N'            
      BEGIN            
  UPDATE #TMPLEDGERNEW             
   SET   EXCHANGE =@@EXCHANGE,            
   SEGMENT = @@SEGMENT ,            
   ENTITY = 'MARGIN  LEDGER',             
   ORDERSEG = 2             
  WHERE SEGMENT IS NULL             
      END            
    ELSE            
      BEGIN            
  UPDATE #TMPLEDGERNEW             
   SET    EXCHANGE = @@EXCHANGE,            
   SEGMENT = @@SEGMENT,            
   ENTITY = CASE WHEN @ENTITY_TYPE = 'ENTITY' THEN 'MARGIN-' + @@EXCHANGE ELSE @@GROUPID + ' - MARGIN LEDGER' END,            
   --IF @@ACCOUNTDB = 'ACCOUNT'            
   -- SET @@SQL = @@SQL + "        ORDERSEG = 4"            
   --ELSE IF @@ACCOUNTDB = 'ACCOUNTBSE'            
   -- SET @@SQL = @@SQL + "        ORDERSEG = 5"            
   --ELSE IF @@ACCOUNTDB = 'ACCOUNTFO'            
   -- SET @@SQL = @@SQL + "        ORDERSEG = 6"            
                
   ORDERSEG = @@ORDERSEG+ @@ORDERSECOUNT            
  WHERE  SEGMENT IS NULL             
 END            
             
            
FETCH NEXT FROM @@MAINREC INTO @@ACCOUNTDB, @@EXCHANGE, @@SEGMENT, @@ACCOUNTSVR, @@SHAREDB ,@@GROUPID, @@ORDERSEG               
END            
CLOSE @@MAINREC            
DEALLOCATE @@MAINREC            
            
--IF ((SELECT COUNT(1) FROM [#DBNAME] WHERE ACCOUNTDB = 'ACCOUNTFO') = 1)            
--BEGIN            
--    INSERT INTO #TMPLEDGERNEW            
--              (VOUDT,            
--               EFFDT,            
--               SHORTDESC,            
--               DRAMT,            
--               CRAMT,            
--               VNO,            
--               DDNO,            
--               NARRATION,            
--               CLTCODE,            
--               VTYP,            
--               VDT,            
--               EDT)            
--    EXEC NSEFO.DBO.V2_GETMARGINREQ            
--      @TDATE ,            
--      @FCODE ,            
--      @TCODE ,            
--  @STATUSID ,            
--      @STATUSNAME ,            
--      @STRBRANCH            
             
                  
--        UPDATE #TMPLEDGERNEW            
--        SET    EXCHANGE = 'NSE',            
--          SEGMENT = 'FUTURES',            
--               ENTITY = 'MARGIN REQ - NFO',            
--               ORDERSEG = (@@ORDERSECOUNT * 2)+ 1            
--        WHERE  SEGMENT IS NULL            
                  
--END            
            
    IF @ORDERFLG = 'N'            
      BEGIN            
        SELECT   CLTCODE,            
         EXCHANGE,            
                 SEGMENT,            
                 ORDERSEG,            
                 OPBAL = MAX(OPBAL)            
        INTO     #OPBAL            
        FROM     #TMPLEDGERNEW            
        GROUP BY CLTCODE,EXCHANGE,SEGMENT,ORDERSEG            
            
            
        SELECT   CLTCODE,            
                 ORDERSEG,            
                 OPBAL = SUM(OPBAL)            
        INTO     #FINOPBAL            
        FROM     #OPBAL            
        GROUP BY CLTCODE,ORDERSEG            
            
        UPDATE #TMPLEDGERNEW            
        SET    OPBAL = 0            
            
        UPDATE #TMPLEDGERNEW            
        SET    OPBAL = ISNULL(T.OPBAL,0)            
        FROM   #TMPLEDGERNEW L WITH (NOLOCK),            
               #FINOPBAL T WITH (NOLOCK)            
        WHERE              
   L.CLTCODE = T.CLTCODE                                 
   AND L.ORDERSEG = T.ORDERSEG            
      END            
      UPDATE #TMPLEDGERNEW SET ACTIVE_SEG = 'NSE,BSE,FNO,COMMODITY'            
            
IF @FORPDF = 'Y'  
 BEGIN  
  ALTER TABLE #TMPLEDGERNEW ADD PDFLINES INT  
  
  UPDATE #TMPLEDGERNEW  
  SET PDFLINES = LEN(LTRIM(RTRIM(ISNULL(NARRATION, '')))) / 35 + 1  
  WHERE VTYP <> '18'  
  
  UPDATE #TMPLEDGERNEW  
  SET PDFLINES = (I.LNO + 1)  
  FROM (  
   SELECT CLTCODE,  
    LNO = SUM(PDFLINES)  
   FROM #TMPLEDGERNEW  
   GROUP BY CLTCODE  
   ) I  
  WHERE #TMPLEDGERNEW.CLTCODE = I.CLTCODE  
  
  UPDATE #TMPLEDGERNEW  
  SET PARTYROWCOUNT = CEILING(CONVERT(NUMERIC(10, 2), LEN(ISNULL(NARRATION, ''))) / 25)  
  
  UPDATE #TMPLEDGERNEW  
  SET PARTYROWCOUNT = 1  
  WHERE LEN(ISNULL(NARRATION, '')) = 0  
  
  UPDATE #TMPLEDGERNEW  
  SET PARTYROWCOUNT = (  
    SELECT SUM(PARTYROWCOUNT) + COUNT(DISTINCT ORDERSEG)  
    FROM #TMPLEDGERNEW I  
    WHERE #TMPLEDGERNEW.CLTCODE = I.CLTCODE  
    GROUP BY CLTCODE  
    )  
  
  UPDATE #TMPLEDGERNEW  
  SET PARTYROWCOUNT = PARTYROWCOUNT + (  
    SELECT (COUNT(DISTINCT ORDERSEG) * 1) + 1  
    FROM #TMPLEDGERNEW I  
    WHERE #TMPLEDGERNEW.CLTCODE = I.CLTCODE  
    GROUP BY CLTCODE  
    )  
  
  UPDATE #TMPLEDGERNEW  
  SET TOTALPAGES =.DBO.PARTYLEDGERPAGES(PARTYROWCOUNT)  
  
  
  
        
/*            
   UPDATE #TMPLEDGERNEW SET PARTYROWCOUNT = CEILING(CONVERT(NUMERIC(10,2), LEN(ISNULL(NARRATION, ''))) / 35)            
   UPDATE #TMPLEDGERNEW SET PARTYROWCOUNT = 1 WHERE LEN(ISNULL(NARRATION, '')) = 0            
   UPDATE #TMPLEDGERNEW SET PARTYROWCOUNT = (SELECT SUM(PARTYROWCOUNT) /*+ COUNT(DISTINCT ORDERSEG)*/ FROM #TMPLEDGERNEW I WHERE #TMPLEDGERNEW.CLTCODE = I.CLTCODE GROUP BY CLTCODE)            
   UPDATE #TMPLEDGERNEW SET PARTYROWCOUNT = PARTYROWCOUNT + (SELECT (COUNT(DISTINCT ORDERSEG) * 1) + 1 FROM #TMPLEDGERNEW I WHERE #TMPLEDGERNEW.CLTCODE = I.CLTCODE GROUP BY CLTCODE)            
   UPDATE #TMPLEDGERNEW SET TOTALPAGES = .DBO.PARTYLEDGERPAGES(PARTYROWCOUNT)            
*/            
            
END            
            
            
--  BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT,CRAMT,VNO,DDNO,NARRATION,CLTCODE,VTYP,VDT,EDT,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,CROSAC,EDIFF,FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES          
          
          
IF @CSV = 'Y'          
BEGIN          
CREATE TABLE #PARTYLEDGERCSV          
(          
 CLTCODE VARCHAR(10),          
 VOUCHER_DATE VARCHAR(10),           
 EFFECTIVE_DATE VARCHAR(10),           
 VTYPE VARCHAR(15),           
 VNO VARCHAR(15),           
 AC_CODE VARCHAR(10),           
 PERTIULARS VARCHAR(500),           
 DDNO VARCHAR(20),           
 DRAMT MONEY,           
 CRAMT MONEY,          
 ENTITY     VARCHAR(50),            
 ORDERSEG   BIGINT,            
 BALANCE MONEY,          
 SNO INT IDENTITY(1, 1)          
)          
          
 INSERT INTO #PARTYLEDGERCSV          
 (          
  CLTCODE, VOUCHER_DATE, EFFECTIVE_DATE, VTYPE, VNO, AC_CODE,           
  PERTIULARS, DDNO, DRAMT, CRAMT, ENTITY, ORDERSEG          
 )          
 SELECT           
  CLTCODE, VOUCHER_DATE = '', EFFECTIVE_DATE = '', VTYPE = 'OPENING', VNO = '', AC_CODE = '',           
  PERTIULARS = 'OPENING ENTRY', DDNO = '', DRAMT = CASE WHEN MAX(OPBAL) > 0 THEN MAX(OPBAL) ELSE 0 END,           
  CRAMT = CASE WHEN MAX(OPBAL) <= 0 THEN MAX(OPBAL) ELSE 0 END, ENTITY, ORDERSEG          
 FROM               
  #TMPLEDGERNEW          
 GROUP BY          
  CLTCODE, ENTITY, ORDERSEG          
 ORDER BY           
  CLTCODE,            
  ORDERSEG          
          
 INSERT INTO #PARTYLEDGERCSV          
 (          
  CLTCODE, VOUCHER_DATE, EFFECTIVE_DATE, VTYPE, VNO, AC_CODE,           
  PERTIULARS, DDNO, DRAMT, CRAMT, ENTITY, ORDERSEG          
 )          
 SELECT           
  CLTCODE, VOUCHER_DATE = VOUDT, EFFECTIVE_DATE = EFFDT, VTYPE = SHORTDESC, VNO, AC_CODE = CROSAC,           
  PERTIULARS = NARRATION, DDNO, DRAMT, CRAMT, ENTITY, ORDERSEG          
 FROM               
  #TMPLEDGERNEW          
 WHERE           
    VOUDT IS NOT NULL          
 ORDER BY           
  CLTCODE,            
  ORDERSEG,            
  VOUDT            
            
 UPDATE P          
 SET BALANCE = (SELECT SUM(DRAMT - CRAMT) FROM #PARTYLEDGERCSV P1 WHERE P.CLTCODE = P1.CLTCODE AND P.ENTITY = P1.ENTITY AND P.ORDERSEG = P1.ORDERSEG AND P.SNO <= P1.SNO)          
 FROM #PARTYLEDGERCSV P          
           
 SELECT * FROM #PARTYLEDGERCSV ORDER BY CLTCODE, ORDERSEG, SNO          
           
END          
            
            
    IF @STRORDER = 'ACCODE'            
      BEGIN            
        IF @SELECTBY = 'VDT'            
          BEGIN            
            IF @ORDERFLG = 'N'            
              BEGIN            
                SELECT   BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT,CRAMT,VNO,DDNO,NARRATION,CLTCODE,VTYP,CONVERT(VARCHAR(11),VDT,103) AS VDT ,CONVERT(VARCHAR(11),EDT,103) AS EDT,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,CROSAC,EDIFF,FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES          
                FROM     #TMPLEDGERNEW  where  CLTCODE IN (SELECT CLTCODE FROM OLDNEWEQ)                     
                
                ORDER BY CLTCODE,            
                         ORDERSEG,            
                         VOUDT            
              END            
            ELSE            
              BEGIN            
                SELECT   BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT,CRAMT,VNO,DDNO,NARRATION,CLTCODE,VTYP,CONVERT(VARCHAR(11),VDT,103) AS VDT ,CONVERT(VARCHAR(11),EDT,103) AS EDT,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,CROSAC,EDIFF,FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES          
                FROM     #TMPLEDGERNEW  where  CLTCODE IN (SELECT CLTCODE FROM OLDNEWEQ)      
                ORDER BY CLTCODE,            
                         ORDERSEG,            
                         VOUDT            
              END            
          END            
        ELSE            
          BEGIN            
            IF @ORDERFLG = 'N'            
              BEGIN            
                SELECT   BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT,CRAMT,VNO,DDNO,NARRATION,CLTCODE,VTYP,CONVERT(VARCHAR(11),VDT,103) AS VDT ,CONVERT(VARCHAR(11),EDT,103) AS EDT,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,CROSAC,EDIFF,FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES          
                FROM     #TMPLEDGERNEW where  CLTCODE IN (SELECT CLTCODE FROM OLDNEWEQ)   
                ORDER BY CLTCODE,            
                         ORDERSEG,            
                         EFFDT            
              END            
            ELSE            
              BEGIN            
                SELECT   BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT,CRAMT,VNO,DDNO,NARRATION,CLTCODE,VTYP,CONVERT(VARCHAR(11),VDT,103) AS VDT ,CONVERT(VARCHAR(11),EDT,103) AS EDT,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,CROSAC,EDIFF,FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES          
                FROM     #TMPLEDGERNEW   where  CLTCODE IN (SELECT CLTCODE FROM OLDNEWEQ)       
                ORDER BY CLTCODE,            
                         ORDERSEG,            
                         EFFDT            
              END            
          END            
      END            
  ELSE            
 BEGIN            
 IF @SELECTBY = 'VDT'            
          BEGIN            
            IF @ORDERFLG = 'N'            
              BEGIN            
                SELECT   BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT,CRAMT,VNO,DDNO,NARRATION,CLTCODE,VTYP,CONVERT(VARCHAR(11),VDT,103) AS VDT ,CONVERT(VARCHAR(11),EDT,103) AS EDT,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,CROSAC,EDIFF,FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES          
                FROM     #TMPLEDGERNEW T where  CLTCODE IN (SELECT CLTCODE FROM OLDNEWEQ)      
                ORDER BY ACNAME,            
                         ORDERSEG,            
                         VOUDT            
              END            
            ELSE            
              BEGIN            
                SELECT   BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT,CRAMT,VNO,DDNO,NARRATION,CLTCODE,VTYP,CONVERT(VARCHAR(11),VDT,103) AS VDT ,CONVERT(VARCHAR(11),EDT,103) AS EDT,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,CROSAC,EDIFF,FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES          
                FROM     #TMPLEDGERNEW where  CLTCODE IN (SELECT CLTCODE FROM OLDNEWEQ)       
                ORDER BY ACNAME,            
                         ORDERSEG,            
                         VOUDT            
              END            
  END            
        ELSE            
          BEGIN            
            IF @ORDERFLG = 'N'            
              BEGIN            
                SELECT   BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT,CRAMT,VNO,DDNO,NARRATION,CLTCODE,VTYP,CONVERT(VARCHAR(11),VDT,103) AS VDT ,CONVERT(VARCHAR(11),EDT,103) AS EDT,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,CROSAC,EDIFF,FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES          
                FROM     #TMPLEDGERNEW where  CLTCODE IN (SELECT CLTCODE FROM OLDNEWEQ)             
                ORDER BY ACNAME,            
                         ORDERSEG,            
                         EFFDT            
              END            
            ELSE            
              BEGIN            
                SELECT   BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT,CRAMT,VNO,DDNO,NARRATION,CLTCODE,VTYP,CONVERT(VARCHAR(11),VDT,103) AS VDT ,CONVERT(VARCHAR(11),EDT,103) AS EDT,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,CROSAC,EDIFF,FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES          
                FROM     #TMPLEDGERNEW where  CLTCODE IN (SELECT CLTCODE FROM OLDNEWEQ)           
                ORDER BY ACNAME,            
                         ORDERSEG,            
                         EFFDT            
              END            
          END            
      END            
  END

GO
