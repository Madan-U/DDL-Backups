-- Object: PROCEDURE dbo.RPT_ACC_PARTYLEDGER_ALL_PARENT_Comm
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


--Exec RPT_ACC_PARTYLEDGER_ALL_PARENT 'Apr  1 2010','Jan  7 2011','rp61','rp61','ACCODE','vdt','broker','broker',''        
--EXEC RPT_ACC_PARTYLEDGER_ALL_PARENT 'APR  1 2008', 'JAN  5 2009', '0A141', '0A143', 'ACCODE', 'VDT', 'BROKER', 'BROKER', ''                
CREATE PROCEDURE [dbo].[RPT_ACC_PARTYLEDGER_ALL_PARENT_Comm]                  
                @FDATE      VARCHAR(11),            /* AS MMM DD YYYY */                  
                @TDATE      VARCHAR(11),            /* AS MMM DD YYYY */                  
                @FCODE      VARCHAR(10),                  
                @TCODE      VARCHAR(10),                  
                @STRORDER   VARCHAR(6),                  
                @SELECTBY   VARCHAR(3),                  
                @STATUSID   VARCHAR(15),                  
                @STATUSNAME VARCHAR(15),                  
                @STRBRANCH  VARCHAR(10),                  
                @ORDERFLG   VARCHAR(1)  = 'N',                  
                @SINGLE     VARCHAR(1)  = 'N'                  
                                                            
AS                  
                  
  BEGIN          
          
 CREATE TABLE #LEDGERCLIENTS(          
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
SELECT * FROM MSAJAG.DBO.GETCLIENTS_PARENT(@STATUSID, @STATUSNAME, @FCODE, @TCODE, @STRBRANCH)          
/**SELECT          
 C2.PARTY_CODE,          
 C1.LONG_NAME,          
 BANK_NAME = '',          
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
 CLTDPID = '',          
 PARENTCODE          
FROM          
 BSEDB_AB.DBO.CLIENT1 C1 WITH(NOLOCK),          
 BSEDB_AB.DBO.CLIENT2 C2 WITH(NOLOCK)          
/* LEFT OUTER JOIN          
 BSEDB_AB.DBO.CLIENT4 C4 WITH(NOLOCK)          
  ON          
  (          
   C2.PARTY_CODE = C4.PARTY_CODE          
   AND DEPOSITORY NOT IN ('NSDL', 'CDSL')          
   AND DEFDP = 0          
  )*/          
WHERE          
 C1.CL_CODE = C2.CL_CODE          
-- AND C2.PARTY_CODE BETWEEN @FCODE AND @TCODE          
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
 AND C1.BRANCH_CD LIKE @STRBRANCH +'%'                  
*/      
                    
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
      [LNO]        INT,            
      [PDT]        [DATETIME]   NULL,                  
      [SEGMENT]    [VARCHAR](4)   NULL,                  
      [ENTITY]     [VARCHAR](50)   NULL,                  
      [ORDERSEG]   [BIGINT]   NULL,                  
   [REQ_MAR]    [VARCHAR](50)   NULL )                  
    ON [PRIMARY]                  
              
                
    INSERT INTO #TMPLEDGERNEW                  
               (BOOKTYPE,                  
                VOUDT,                  
                EFFDT,                  
                SHORTDESC,                  
                DRAMT,                  
                CRAMT,                  
                VNO,                  
                DDNO,                  
                NARRATION,                  
                CLTCODE,                  
                VTYP,                  
                VDT,                  
                EDT,                  
                ACNAME,                  
                OPBAL,                  
                L_ADDRESS1,                  
                L_ADDRESS2,                  
                L_ADDRESS3,                  
                L_CITY,                  
                L_ZIP,                  
                RES_PHONE1,                  
                BRANCH_CD,                  
                CROSAC,                  
                EDIFF,                  
                FAMILY,                  
                SUB_BROKER,                  
                TRADER,                  
                CL_TYPE,                  
                BANK_NAME,                  
                CLTDPID,                  
                LNO,                  
                PDT)                  
    EXEC ACCOUNT.DBO.RPT_ACC_PARTYLEDGER_PARENT_NEW              
      @FDATE ,                  
      @TDATE ,                  
      @FCODE ,                  
      @TCODE ,               
      @STRORDER ,                  
      @SELECTBY ,                  
      @STATUSID ,                  
      @STATUSNAME ,                  
      @STRBRANCH               
        
              
    IF @ORDERFLG = 'N'                  
      BEGIN                  
UPDATE #TMPLEDGERNEW                  
        SET    SEGMENT = '2BSE',                  
               ENTITY = 'SETTLEMENT LEDGER',                  
 ORDERSEG = 1                  
        WHERE  SEGMENT IS NULL                  
     END                  
    ELSE                  
      BEGIN                  
        UPDATE #TMPLEDGERNEW                  
        SET    SEGMENT = '2BSE',                  
               ENTITY = 'CAPITAL - BSE',                  
               ORDERSEG = 2                  
        WHERE  SEGMENT IS NULL                  
                                 
      END                  
              
               
    INSERT INTO #TMPLEDGERNEW                  
               (BOOKTYPE,                  
                VOUDT,                  
                EFFDT,                  
                SHORTDESC,                  
                DRAMT,                  
                CRAMT,                  
                VNO,                  
                DDNO,                  
                NARRATION,                  
                CLTCODE,                  
                VTYP,                  
                VDT,                  
                EDT,                  
                ACNAME,                  
                OPBAL,                  
                L_ADDRESS1,                  
                L_ADDRESS2,                  
                L_ADDRESS3,                  
                L_CITY,                  
                L_ZIP,                  
                RES_PHONE1,                  
                BRANCH_CD,                  
                CROSAC,                  
                EDIFF,                  
                FAMILY,                  
                SUB_BROKER,                  
                TRADER,                  
                CL_TYPE,                  
                BANK_NAME,                  
                CLTDPID,                  
                LNO,                  
                PDT)                  
    EXEC ACCOUNT.DBO.RPT_ACC_MARGINLEDGER_PARENT_NEW                  
      @FDATE ,                  
      @TDATE ,                  
      @FCODE ,                  
      @TCODE ,                  
      @STRORDER ,                  
      @SELECTBY ,                  
      @STATUSID ,                  
      @STATUSNAME ,                  
      @STRBRANCH                  
                        
    IF @ORDERFLG = 'N'                  
      BEGIN                  
        UPDATE #TMPLEDGERNEW                  
        SET    SEGMENT = '6BSE',                  
               ENTITY = 'MARGIN  LEDGER',                  
               ORDERSEG = 2                  
        WHERE  SEGMENT IS NULL                  
      END                  
    ELSE                  
      BEGIN                  
        UPDATE #TMPLEDGERNEW                  
        SET    SEGMENT = '6BSE',                  
               ENTITY = 'MARGIN - BSE',                  
               ORDERSEG = 5                  
        WHERE  SEGMENT IS NULL                  
      END                  
                        
      
/*UPDATING CROSS ACCOUNT CODE*/      
     UPDATE      
       #TMPLEDGERNEW      
            SET #TMPLEDGERNEW.CROSAC = B.CLTCODE      
      FROM LEDGER B WITH(NOLOCK),      
            ACMAST V WITH(NOLOCK)      
      WHERE B.CLTCODE = V.CLTCODE      
            AND V.ACCAT = 2      
            AND #TMPLEDGERNEW.BOOKTYPE = B.BOOKTYPE      
            AND #TMPLEDGERNEW.VNO = B.VNO      
            AND #TMPLEDGERNEW.VTYP = B.VTYP      
            AND LTRIM(RTRIM(#TMPLEDGERNEW.VTYP)) IN ('01', '1', '02', '2', '03', '3', '04', '4', '05', '5', '16', '17', '19', '20', '22', '23')                 
   /* INSERT INTO #TMPLEDGERNEW                  
              (VOUDT,                  
               EFFDT,                  
               SHORTDESC,                  
               DRAMT,                  
               CRAMT,                  
               VNO,                  
               DDNO,                  
               NARRATION,                  
               CLTCODE,                  
               VTYP,                  
               VDT,                  
               EDT)                  
    EXEC NSEFO.DBO.V2_GETMARGINREQ                  
      @TDATE ,                  
      @FCODE ,                  
      @TCODE ,                  
      @STATUSID ,                  
      @STATUSNAME ,                  
      @STRBRANCH                  
                  
    IF @ORDERFLG = 'N'                  
      BEGIN                  
        UPDATE #TMPLEDGERNEW                  
        SET    SEGMENT = '8NFO',                  
               ENTITY = 'MARGIN REQ - NFO',                  
               ORDERSEG = 3                  
        WHERE  SEGMENT IS NULL                  
      END                  
    ELSE                  
      BEGIN                  
        UPDATE #TMPLEDGERNEW                  
        SET    SEGMENT = '8NFO',                  
               ENTITY = 'MARGIN REQ - NFO',                  
               ORDERSEG = 7,                  
               OPBAL = 0                  
        WHERE SEGMENT IS NULL                  
      END                  
                  
--ADDED BY BHARAT                   
 INSERT INTO #TMPLEDGERNEW                  
              (VOUDT,                  
               EFFDT,                  
               SHORTDESC,                  
               DRAMT,                  
               CRAMT,                  
               VNO,                  
               DDNO,                  
               NARRATION,                  
   CLTCODE,                  
               VTYP,                  
               VDT,                  
               EDT,                  
      REQ_MAR)                  
    EXEC MSAJAG.DBO.V2_GETMARGINREQ_RMS                  
      @TDATE ,                  
     @FCODE ,                  
      @TCODE ,                  
      @STATUSID ,                  
      @STATUSNAME ,                  
      @STRBRANCH                  
                  
    IF @ORDERFLG = 'N'                  
      BEGIN                  
  UPDATE #TMPLEDGERNEW                  
        SET    SEGMENT = '8NSE',                  
               ENTITY = 'MARGIN REQ - NSE',                  
               ORDERSEG = 3,                  
               OPBAL = 0                  
        WHERE SEGMENT IS NULL                  
     AND REQ_MAR LIKE 'NSE-CAPITAL%'                  
                  
  UPDATE #TMPLEDGERNEW                  
     SET    SEGMENT = '8BSE',                  
               ENTITY = 'MARGIN REQ - BSE',                  
               ORDERSEG = 3,                  
               OPBAL = 0                  
        WHERE SEGMENT IS NULL                  
     AND REQ_MAR LIKE 'BSE-CAPITAL%'                   
                  
        UPDATE #TMPLEDGERNEW                  
        SET    SEGMENT = '8NFO',                  
               ENTITY = 'MARGIN REQ - DERIVATIVES',                  
               ORDERSEG = 3,                  
               OPBAL = 0                  
        WHERE SEGMENT IS NULL                  
     AND REQ_MAR LIKE 'NSE-FUTURES%'                     
      END                  
    ELSE                  
      BEGIN                  
  UPDATE #TMPLEDGERNEW                  
        SET    SEGMENT = '8NSE',                  
               ENTITY = 'MARGIN REQ - NSE',                  
               ORDERSEG = 7,                  
               OPBAL = 0                  
        WHERE SEGMENT IS NULL                  
     AND REQ_MAR LIKE 'NSE-CAPITAL%'                  
                  
  UPDATE #TMPLEDGERNEW                  
        SET  SEGMENT = '8BSE',                  
               ENTITY = 'MARGIN REQ - BSE',                  
               ORDERSEG = 8,                  
               OPBAL = 0                  
        WHERE SEGMENT IS NULL                  
     AND REQ_MAR LIKE 'BSE-CAPITAL%'                   
                  
        UPDATE #TMPLEDGERNEW                  
        SET    SEGMENT = '8NFO',                  
               ENTITY = 'MARGIN REQ - DERIVATIVES',                  
               ORDERSEG = 9,                  
               OPBAL = 0                  
        WHERE SEGMENT IS NULL                  
     AND REQ_MAR LIKE 'NSE-FUTURES%'                   
      END  */                
----                  
    IF @ORDERFLG = 'N'                  
      BEGIN                  
        SELECT   CLTCODE,                  
                 SEGMENT,                  
                 ORDERSEG,                  
                 OPBAL = MAX(OPBAL)                  
        INTO     #OPBAL                  
        FROM     #TMPLEDGERNEW  where CLTCODE IN (SELECT CLTCODE FROM OLDNEWCL)                 
        GROUP BY CLTCODE,SEGMENT,ORDERSEG                  
                                   
        SELECT   CLTCODE,                  
                 ORDERSEG,                  
                 OPBAL = SUM(OPBAL)                  
        INTO     #FINOPBAL                  
        FROM     #OPBAL  where CLTCODE IN (SELECT CLTCODE FROM OLDNEWCL)                 
        GROUP BY CLTCODE,ORDERSEG                  
                              
        UPDATE #TMPLEDGERNEW                  
        SET    OPBAL = 0                  
                                         
        UPDATE #TMPLEDGERNEW                  
        SET    OPBAL = T.OPBAL                  
        FROM   #TMPLEDGERNEW L WITH (NOLOCK),                  
               #FINOPBAL T WITH (NOLOCK)                 
        WHERE  L.CLTCODE = T.CLTCODE                  
               AND L.ORDERSEG = T.ORDERSEG                  
      END                  
                        
    IF @STRORDER = 'ACCODE'                  
      BEGIN                  
        IF @SELECTBY = 'VDT'                  
          BEGIN                  
            IF @ORDERFLG = 'N'                  
              BEGIN                  
                SELECT   *                  
                FROM     #TMPLEDGERNEW where   
                CLTCODE IN (SELECT CLTCODE FROM OLDNEWCL)                
                ORDER BY CLTCODE,                  
                         ORDERSEG,                  
                         VOUDT                  
              END                  
            ELSE                  
              BEGIN                  
                SELECT   *                  
                FROM     #TMPLEDGERNEW   
                where   
                CLTCODE IN (SELECT CLTCODE FROM OLDNEWCL)                    
                ORDER BY CLTCODE,                  
                         ORDERSEG,                  
                         VOUDT                  
              END                  
          END                  
        ELSE                  
          BEGIN                  
            IF @ORDERFLG = 'N'                  
              BEGIN                  
                SELECT   *                  
                FROM     #TMPLEDGERNEW  
                where   
                CLTCODE IN (SELECT CLTCODE FROM OLDNEWCL)                     
                ORDER BY CLTCODE,                  
                         ORDERSEG,                  
                         EFFDT                  
              END                  
            ELSE                  
              BEGIN              
                SELECT   *                  
                FROM     #TMPLEDGERNEW 
                where   
                CLTCODE IN (SELECT CLTCODE FROM OLDNEWCL)                      
                ORDER BY CLTCODE,                  
                         ORDERSEG,                  
       EFFDT                  
              END                  
          END                  
      END                  
  END

GO
