-- Object: PROCEDURE dbo.V2_Rpt_Acc_PartyLedger_All_07052014
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE [dbo].[V2_Rpt_Acc_PartyLedger_All]    
                @fdate      VARCHAR(11),            /* As mmm dd yyyy */    
                @tdate      VARCHAR(11),            /* As mmm dd yyyy */    
                @fcode      VARCHAR(10),    
                @tcode      VARCHAR(10),    
                @strorder   VARCHAR(6),    
                @selectby   VARCHAR(3),     
                @statusid   VARCHAR(15),    
                @statusname VARCHAR(15),    
                @strbranch  VARCHAR(10),    
                @orderflg   VARCHAR(1)  = 'N',    
                @EXCSEGMENT VARCHAR(1000) = '',    
                @ENTITY_TYPE VARCHAR(20) = 'ENTITY',    
                @Single     VARCHAR(1)  = 'N',    
                @FORPDF  VARCHAR(1) = 'N'    
                    
    
AS    
/*    
select * from COMPANY_MASTER_SETTING    
 Exec [V2_Rpt_Acc_PartyLedger_All] 'Apr 1 2008','Mar 2 2009','0','0a143','ACCODE','vdt','broker','broker','','','','','ACCOUNT~ACCOUNTBSE~ACCOUNTFO'    
commit    
Exec [V2_Rpt_Acc_PartyLedger_All] 'sep  1 2012','sep 30 2012','A10148','A10148','ACCODE','vdt','broker','broker','',''    
  
commit    
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
  [CLTDPID]    [VARCHAR](16)   NULL,    
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
 SELECT @@DB = " INSERT INTO #DBNAME SELECT ACCOUNTDB, EXCHANGE, SEGMENT, ACCOUNTSERVER, SHAREDB, GROUPID, ORDER_SEGMENT FROM COMPANY_MASTER_SETTING (NOLOCK) WHERE EXCHANGE + '~' + SEGMENT IN ('" + REPLACE(@EXCSEGMENT,',',''',''') + "') ORDER BY EXCHANGE 
"        
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
 BEGIN   
 SET @@SQL = @@SQL +" EXEC "+ @@ACCOUNTSVR +"."+@@ACCOUNTDB+"..RPT_ACC_PARTYLEDGER "    
 END  
 ELSE  
 BEGIN   
 SET @@SQL = @@SQL +" EXEC "+@@ACCOUNTDB+"..RPT_ACC_PARTYLEDGER "    
 END  
   
 SET @@SQL = @@SQL +"'" +@fdate +"', "    
 SET @@SQL = @@SQL +"'" +@tdate +"', "    
 SET @@SQL = @@SQL +"'" +@fcode +"', "    
 SET @@SQL = @@SQL +"'" +@tcode +"', "    
 SET @@SQL = @@SQL +"'" +@strorder +"', "    
 SET @@SQL = @@SQL +"'" +@selectby +"', "    
 SET @@SQL = @@SQL +"'" +@statusid +"', "    
 SET @@SQL = @@SQL +"'" +@statusname+"', "    
 SET @@SQL = @@SQL +"'" +@strbranch +"'"     
    --return    
    
print  @@SQL  
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
 --IF @@ACCOUNTDB = 'ACCOUNT'    
 -- SET @@SQL = @@SQL + "        ORDERSEG = 1"    
 --ELSE IF @@ACCOUNTDB = 'ACCOUNTBSE'    
 -- SET @@SQL = @@SQL + "        ORDERSEG = 2"    
 --ELSE IF @@ACCOUNTDB = 'ACCOUNTFO'    
 -- SET @@SQL = @@SQL + "        ORDERSEG = 3"    
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
SET @@SQL = @@SQL + " ACNAME, "    
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
 BEGIN   
 SET @@SQL = @@SQL + "    EXEC "+ @@ACCOUNTSVR +"."+@@ACCOUNTDB+"..RPT_ACC_MARGINLEDGER "    
 END   
ELSE  
 BEGIN   
 SET @@SQL = @@SQL + "    EXEC "+@@ACCOUNTDB+"..RPT_ACC_MARGINLEDGER "    
END  
SET @@SQL = @@SQL +"'" + @fdate +"', "    
SET @@SQL = @@SQL +"'" + @tdate +"', "    
SET @@SQL = @@SQL +"'" + @fcode +"', "    
SET @@SQL = @@SQL +"'" + @tcode +"', "    
SET @@SQL = @@SQL +"'" + @strorder +"', "    
SET @@SQL = @@SQL +"'" + @selectby +"', "    
SET @@SQL = @@SQL +"'" + @statusid +"', "    
SET @@SQL = @@SQL +"'" + @statusname +"', "    
SET @@SQL = @@SQL +"'" +@strbranch+"'"      
    
EXEC (@@SQL)   
   
    IF @orderflg = 'N'    
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
  
IF ( SELECT ISNULL(COUNT(1),0) FROM #TMPLEDGERNEW  
  WHERE VTYP = '15'  
     AND EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL' ) > 0  
BEGIN  
  
 SELECT * INTO #NSEBILL FROM #TMPLEDGERNEW  
 WHERE VTYP = '15'  
    AND EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL'  
  
 SELECT N.BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT=PAMT,CRAMT=0,N.VNO,DDNO,NARRATION=LEFT(N.NARRATION,LEN(N.NARRATION)-11) + '-' + SCRIP_CD,CLTCODE,N.VTYP,  
     N.VDT,EDT,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,  
     BRANCH_CD,CROSAC,EDIFF,FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,  
     PDT,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES   
 INTO #NSELED FROM #NSEBILL N, BILLPOSTED B,   
 (  
 SELECT SETT_NO,SETT_TYPE,SAUDA_DATE,PARTY_CODE,SCRIP_CD,SERIES,  
 PAMT=(CASE WHEN SUM(PAMT-SAMT) > 0   
      THEN SUM(PAMT-SAMT)  
      ELSE 0   
    END),  
 SAMT=(CASE WHEN SUM(PAMT-SAMT) < 0   
      THEN SUM(SAMT-PAMT)  
      ELSE 0   
    END),  
 TRDTYPE  
 FROM MSAJAG.DBO.TBL_VALAN_DETAIL   
 GROUP BY SETT_NO,SETT_TYPE,SAUDA_DATE,PARTY_CODE,SCRIP_CD,SERIES,TRDTYPE  
 ) V  
    WHERE B.VNO = N.VNO   
    AND B.VTYP = N.VTYP  
    AND B.SETT_NO = V.SETT_NO  
 AND B.SETT_TYPE = V.SETT_TYPE  
 AND N.CLTCODE = V.PARTY_CODE  
 AND PAMT > 0   
  
 INSERT INTO #NSELED   
 SELECT N.BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT=0,CRAMT=SAMT,N.VNO,DDNO,NARRATION=LEFT(N.NARRATION,LEN(N.NARRATION)-11) + '-' + SCRIP_CD,CLTCODE,N.VTYP,  
     N.VDT,EDT,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,  
     BRANCH_CD,CROSAC,EDIFF,FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,  
     PDT,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES   
 FROM #NSEBILL N, BILLPOSTED B,   
 (  
 SELECT SETT_NO,SETT_TYPE,SAUDA_DATE,PARTY_CODE,SCRIP_CD,SERIES,  
 PAMT=(CASE WHEN SUM(PAMT-SAMT) > 0   
      THEN SUM(PAMT-SAMT)  
      ELSE 0   
    END),  
 SAMT=(CASE WHEN SUM(PAMT-SAMT) < 0   
      THEN SUM(SAMT-PAMT)  
      ELSE 0   
    END),  
 TRDTYPE  
 FROM MSAJAG.DBO.TBL_VALAN_DETAIL   
 GROUP BY SETT_NO,SETT_TYPE,SAUDA_DATE,PARTY_CODE,SCRIP_CD,SERIES,TRDTYPE  
 ) V  
    WHERE B.VNO = N.VNO   
    AND B.VTYP = N.VTYP  
    AND B.SETT_NO = V.SETT_NO  
 AND B.SETT_TYPE = V.SETT_TYPE  
 AND N.CLTCODE = V.PARTY_CODE  
 AND SAMT > 0   
  
 DELETE FROM #TMPLEDGERNEW  
 WHERE VTYP = '15'  
    AND EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL'   
 AND VNO IN (SELECT VNO FROM #NSELED WHERE #NSELED.VNO = #TMPLEDGERNEW.VNO)  
  
 INSERT INTO #TMPLEDGERNEW  
 SELECT * FROM #NSELED  
END  
  
IF ( SELECT ISNULL(COUNT(1),0) FROM #TMPLEDGERNEW  
  WHERE VTYP = '15'  
     AND EXCHANGE = 'BSE' AND SEGMENT = 'CAPITAL' ) > 0  
BEGIN  
  
 SELECT * INTO #BSEBILL FROM #TMPLEDGERNEW  
 WHERE VTYP = '15'  
    AND EXCHANGE = 'BSE' AND SEGMENT = 'CAPITAL'  
  
 SELECT VNO,VTYP,BOOKTYPE,VDT,BILLDATE,NARRATION,USERNAME,POSTDATE,EDTDR,EDTCR,V.SETT_NO,V.SETT_TYPE,  
    SAUDA_DATE,PARTY_CODE,SCRIP_CD,SERIES,PAMT,SAMT,TRDTYPE  
    into #LEDBILL FROM ANAND.ACCOUNT_AB.DBO.BILLPOSTED B,   
 (  
 SELECT SETT_NO,SETT_TYPE,SAUDA_DATE,PARTY_CODE,SCRIP_CD,SERIES,  
 PAMT=(CASE WHEN SUM(PAMT-SAMT) > 0   
      THEN SUM(PAMT-SAMT)  
      ELSE 0   
    END),  
 SAMT=(CASE WHEN SUM(PAMT-SAMT) < 0   
      THEN SUM(SAMT-PAMT)  
      ELSE 0   
    END),  
 TRDTYPE  
 FROM ANAND.BSEDB_AB.DBO.TBL_VALAN_DETAIL   
 GROUP BY SETT_NO,SETT_TYPE,SAUDA_DATE,PARTY_CODE,SCRIP_CD,SERIES,TRDTYPE  
 ) V  
 WHERE B.SETT_NO = V.SETT_NO  
 AND B.SETT_TYPE = V.SETT_TYPE  
 AND BILLDATE >= @FDATE  
 AND BILLDATE <= @TDATE + ' 23:59'  
 AND PARTY_CODE >= @FCODE AND PARTY_CODE <= @TCODE  
  
  
 SELECT N.BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT=PAMT,CRAMT=0,N.VNO,DDNO,NARRATION=LEFT(N.NARRATION,LEN(N.NARRATION)-11) + '-' + SCRIP_CD,CLTCODE,N.VTYP,  
     N.VDT,EDT,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,  
     BRANCH_CD,CROSAC,EDIFF,FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,  
     PDT,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES   
 INTO #BSELED FROM #BSEBILL N, #LEDBILL B  
    WHERE B.VNO = N.VNO   
    AND B.VTYP = N.VTYP  
 AND N.CLTCODE = B.PARTY_CODE  
 AND PAMT > 0   
  
 INSERT INTO #BSELED   
 SELECT N.BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT=0,CRAMT=SAMT,N.VNO,DDNO,NARRATION=LEFT(N.NARRATION,LEN(N.NARRATION)-11) + '-' + SCRIP_CD,CLTCODE,N.VTYP,  
     N.VDT,EDT,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,  
     BRANCH_CD,CROSAC,EDIFF,FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,  
     PDT,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES   
 FROM #BSEBILL N, #LEDBILL B  
    WHERE B.VNO = N.VNO   
    AND B.VTYP = N.VTYP  
 AND N.CLTCODE = B.PARTY_CODE  
 AND SAMT > 0   
  
 DELETE FROM #TMPLEDGERNEW  
 WHERE VTYP = '15'  
    AND EXCHANGE = 'BSE' AND SEGMENT = 'CAPITAL'   
 AND VNO IN (SELECT VNO FROM #BSELED WHERE #BSELED.VNO = #TMPLEDGERNEW.VNO)  
  
 INSERT INTO #TMPLEDGERNEW  
 SELECT * FROM #BSELED 
  
END  
  
    IF @orderflg = 'N'    
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
     FROM   #TMPLEDGERNEW L WITH (NoLock),    
               #FINOPBAL T WITH (NoLock)    
        WHERE      
   L.CLTCODE = T.CLTCODE                         
   AND L.ORDERSEG = T.ORDERSEG    
      END    
      UPDATE #TMPLEDGERNEW SET ACTIVE_SEG = 'NSE,BSE,FNO,COMMODITY'    
    
 DELETE FROM #TMPLEDGERNEW WHERE VTYP = 18 AND VNO IS NOT NULL    
    IF @FORPDF = 'Y'    
  BEGIN    
   ALTER TABLE #TMPLEDGERNEW ADD  PDFLINES INT    
   UPDATE #TMPLEDGERNEW SET PDFLINES = LEN(LTRIM(RTRIM(ISNULL(NARRATION, '')))) / 35 + 1 WHERE VTYP <> '18'    
   UPDATE #TMPLEDGERNEW SET PDFLINES = (I.LNO + 1) FROM (SELECT CLTCODE, LNO = SUM(PDFLINES) FROM #TMPLEDGERNEW GROUP BY CLTCODE) I    
     WHERE #TMPLEDGERNEW.CLTCODE = I.CLTCODE    
    
    
   UPDATE #TMPLEDGERNEW SET PARTYROWCOUNT = CEILING(CONVERT(NUMERIC(10,2), LEN(ISNULL(NARRATION, ''))) / 35)    
   UPDATE #TMPLEDGERNEW SET PARTYROWCOUNT = 1 WHERE LEN(ISNULL(NARRATION, '')) = 0    
   UPDATE #TMPLEDGERNEW SET PARTYROWCOUNT = (SELECT SUM(PARTYROWCOUNT) /*+ COUNT(DISTINCT ORDERSEG)*/ FROM #TMPLEDGERNEW I WHERE #TMPLEDGERNEW.CLTCODE = I.CLTCODE GROUP BY CLTCODE)    
   UPDATE #TMPLEDGERNEW SET PARTYROWCOUNT = PARTYROWCOUNT + (SELECT (COUNT(DISTINCT ORDERSEG) * 1) + 1 FROM #TMPLEDGERNEW I WHERE #TMPLEDGERNEW.CLTCODE = I.CLTCODE GROUP BY CLTCODE)    
   UPDATE #TMPLEDGERNEW SET TOTALPAGES = .dbo.PARTYLEDGERPAGES(PARTYROWCOUNT)    
    
    
  END    
    IF @strorder = 'ACCODE'    
      BEGIN    
        IF @selectby = 'vdt'    
          BEGIN    
            IF @orderflg = 'N'    
              BEGIN    
                SELECT   *    
                FROM     #TMPLEDGERNEW    
        
                ORDER BY CLTCODE,    
                         ORDERSEG,    
                         VOUDT    
              END    
            ELSE    
              BEGIN    
                SELECT   *    
                FROM     #TMPLEDGERNEW    
                ORDER BY CLTCODE,    
                         ORDERSEG,    
                         VOUDT    
              END    
          END    
        ELSE    
          BEGIN    
            IF @orderflg = 'N'    
              BEGIN    
                SELECT   *    
                FROM     #TMPLEDGERNEW    
                ORDER BY CLTCODE,    
                         ORDERSEG,    
                         EFFDT    
              END    
            ELSE    
              BEGIN    
                SELECT   *    
                FROM     #TMPLEDGERNEW    
                ORDER BY CLTCODE,    
                         ORDERSEG,    
                         EFFDT    
              END    
          END    
      END    
  ELSE    
 BEGIN    
 IF @selectby = 'vdt'    
          BEGIN    
            IF @orderflg = 'N'    
              BEGIN    
                SELECT   *    
                FROM     #TMPLEDGERNEW T    
                ORDER BY ACNAME,    
                         ORDERSEG,    
                         VOUDT    
              END    
            ELSE    
              BEGIN    
                SELECT   *    
                FROM     #TMPLEDGERNEW    
                ORDER BY ACNAME,    
                         ORDERSEG,    
                         VOUDT    
              END    
          END    
        ELSE    
          BEGIN    
            IF @orderflg = 'N'    
              BEGIN    
                SELECT   *    
                FROM     #TMPLEDGERNEW    
                ORDER BY ACNAME,    
                         ORDERSEG,    
                         EFFDT    
              END    
            ELSE    
              BEGIN    
                SELECT   *    
                FROM     #TMPLEDGERNEW    
                ORDER BY ACNAME,    
                         ORDERSEG,    
                         EFFDT    
              END    
          END    
      END    
  END

GO
