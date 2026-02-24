-- Object: PROCEDURE dbo.RPT_ACC_BANKBOOK_NEW_COST
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

--Exec rpt_Acc_BankBook_New_COST 'Jan  1 2007', 'Feb  2 2007', '01/04/2006', 'BA0095', 'broker', 'broker', '10', 'vdt'
/*SELECT * FROM LEDGER WHERE VNO = '200600007245' AND VTYP = 5
SELECT * FROM LEDGER2 WHERE VNO = '200600007245' AND VTYPE = 5

Exec rpt_Acc_BankBook_New 'Jan 23 2007', 'Jan 23 2007', '01/04/2006', 'BA0095', 'broker', 'broker', '22', 'vdt'*/


 --SELECT DISTINCT L.CLTCODE, A.BRANCHCODE FROM LEDGER L, ACMAST A WHERE L.CLTCODE = A.CLTCODE AND L.VDT >= 'APR  1 2005' AND A.ACCAT = 2  
  
--EXEC RPT_ACC_BANKBOOK_NEW 'APR  1 2005', 'MAR 11 2006', '01/04/2005', 'BANK01', 'BROKER', 'GOG', '%'  
  
 /****** OBJECT:  STORED PROCEDURE DBO.RPT_ACC_BANKBOOK_NEW    SCRIPT DATE: 07/08/2005 3:55:36 PM ******/          
--EXEC RPT_ACC_BANKBOOK_NEW 'APR  1 2005', 'JUL  5 2005', '01/04/2005', '33117', 'BROKER', 'BROKER', '%'             
--EXEC RPT_ACC_BANKBOOK_NEW '01/04/2005', '31/03/2006', 'JUN  1 2005', 'JUN 29 2005', '33117', '33117', 'BROKER', 'BROKER', '%','VOUCHERDATE', 'ACCOUNT', 'VDT', 'BANK BOOK',''                  
--EXEC RPT_ACC_BANKBOOK_NEW 'JUN  1 2005', 'JUN  1 2005', '01/04/2005', '711129', 'BROKER', 'BROKER', '%'                    
--EXEC RPT_ACC_BANKBOOK_NEW_BR 'APR  1 2005', 'MAR 31 2006', 'APR  1 2005', 'BANK01', 'BROKER', 'BROKER', 'TR001'  
CREATE PROC RPT_ACC_BANKBOOK_NEW_COST  
--EXEC RPT_ACC_BANKBOOK_NEW 'MAY  2 2005', 'MAY  2 2005', 'APR  1 2005', '711129', 'BROKER', 'BROKER', '%'                    
      @FDATE VARCHAR(11),            /* AS MMM DD YYYY */                      
      @TDATE VARCHAR(11),            /* AS MMM DD YYYY */                      
      @SDATE VARCHAR(11),            /* AS MMM DD YYYY */                      
      @FCODE VARCHAR(10),                      
      @STATUSID VARCHAR(30),                      
      @STATUSNAME VARCHAR(30),                      
      @BRANCH VARCHAR(10),  
      @SELECTIONBY VARCHAR(3) = 'VDT'                       
                      
AS                      
                      
DECLARE                      
 @@OPENDATE AS VARCHAR(11),                      
 @@REPDATE AS VARCHAR(8),                      
 @@STARTDATE AS VARCHAR(11),   
 @@COSTCODE AS SMALLINT  
  
  
                      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                      
                    
CREATE TABLE [DBO].[#TBL_GLREPORT] (                    
 [SRNO] [INT] IDENTITY (1, 1) NOT NULL ,                    
 [BOOKTYPE] [CHAR] (2) NULL ,                    
 [VOUDT] [VARCHAR] (10) NULL ,                    
 [EFFDT] [VARCHAR] (10) NULL ,                    
 [SHORTDESC] [CHAR] (6) NOT NULL DEFAULT(' ') ,                    
 [DRAMT] [MONEY] NULL ,                    
 [CRAMT] [MONEY] NULL ,                    
 [VNO] [VARCHAR] (12) NULL ,                    
 [NARRATION] [VARCHAR] (500) NULL ,                    
 [DDNO] [VARCHAR] (15) NULL ,                    
 [CLTCODE] [VARCHAR] (10) NOT NULL ,                    
 [LONGNAME] [VARCHAR] (100) NULL ,                    
 [VDT] [DATETIME] NULL ,                    
 [VTYP] [SMALLINT] NOT NULL ,                    
 [ACCAT] [CHAR] (2) NULL ,                    
 [OPBAL] [MONEY] NOT NULL ,                    
 [CROSAC] [VARCHAR] (10) NOT NULL ,                    
 [ACNAME] [VARCHAR] (100) NULL ,                    
 [BRANCHCODE] [VARCHAR] (10) NULL , 
 [LNO] [INT] NULL,                   
 [PROCID] [BIGINT] NULL ,                    
 [REPDATE] [VARCHAR] (8) NULL ,                    
 [MAINCODE] [VARCHAR] (10) NULL ,                    
 [VCHDT] [DATETIME] NULL                    
)                    
                    
                      
--DELETE #TBL_GLREPORT WHERE PROCID = @@SPID                                    
DELETE TBL_OPPBALANCE WHERE PROCID = @@SPID  
  
SELECT @@COSTCODE = -1  
  
IF @STATUSID <> 'BROKER'  
 BEGIN  
  SELECT TOP 1 @@COSTCODE = COSTCODE FROM COSTMAST WHERE COSTNAME = @STATUSNAME   
 END  
ELSE IF @STATUSID = 'BROKER'  
 BEGIN  
  IF @BRANCH <> '' OR @BRANCH <> '%'  
   BEGIN  
    SELECT TOP 1 @@COSTCODE = COSTCODE FROM COSTMAST WHERE COSTNAME = @BRANCH   
   END  
 END  
  
SELECT @@STARTDATE = LEFT(CONVERT(VARCHAR, CONVERT(DATETIME, @SDATE,103), 109), 11)                      
  
IF @SELECTIONBY = 'VDT'   
BEGIN  
 IF @STATUSID = 'BROKER'  
  BEGIN                      
   IF @BRANCH = '' OR @BRANCH = '%'  
    BEGIN  
     PRINT 'CAME HERE - I'  
     INSERT INTO TBL_OPPBALANCE                            
     SELECT   
      CLTCODE,   
      SUM(OPBAL) AS OPBAL,  
      SPID ,   
      CURDATE   
     FROM                      
      (SELECT   
       CLTCODE,  
       SUM(CASE DRCR WHEN 'D' THEN VAMT ELSE -VAMT END) AS OPBAL,  
       @@SPID AS SPID,   
       CONVERT(VARCHAR,GETDATE(),112) AS CURDATE                           
      FROM   
       LEDGER                          
      WHERE   
       CLTCODE = @FCODE   
       AND VTYP = 18   
       AND VDT LIKE @@STARTDATE + '%'  
      GROUP BY   
       CLTCODE  
      UNION ALL                      
      SELECT   
       CLTCODE,  
       SUM(CASE DRCR WHEN 'D' THEN VAMT ELSE -VAMT END) AS OPBAL,  
       @@SPID AS SPID,   
       CONVERT(VARCHAR,GETDATE(),112) AS CURDATE                      
      FROM   
       LEDGER                            
      WHERE   
       CLTCODE = @FCODE   
       AND VDT >= @@STARTDATE   
       AND VDT <  @FDATE                      
       AND VTYP <> 18                      
      GROUP BY   
       CLTCODE) A  
     GROUP BY   
      CLTCODE,   
      SPID,   
      CURDATE  
   
                       
     INSERT INTO #TBL_GLREPORT                    
     SELECT   
      L.BOOKTYPE,                       
      VOUDT=CONVERT(VARCHAR,L.VDT,103),   
      EFFDT=CONVERT(VARCHAR,L.EDT,103),   
      ISNULL(SHORTDESC,'') SHORTDESC,                                                               
      DRAMT=(CASE WHEN UPPER(L.DRCR) = 'C' THEN VAMT ELSE 0 END),                                                                
      CRAMT=(CASE WHEN UPPER(L.DRCR) = 'D' THEN VAMT ELSE 0 END),                              
      L.VNO,   
      REPLACE( L.NARRATION,'"','') NARRATION,                                                 
      DDNO = (CASE WHEN ISNULL(L1.DDNO,'')='0' THEN '' ELSE ISNULL(L1.DDNO,'') END),                                     
      L.CLTCODE ,  
      A.LONGNAME,  
      VDT,   
      L.VTYP,                                                                
      ACCAT,   
      OPBAL=0,  
      CROSAC='',  
      A.ACNAME,  
      A.BRANCHCODE,
      L.LNO,  
      @@SPID,   
      CONVERT(VARCHAR,GETDATE(),112), '',   
      L.VDT                    
     FROM   
      LEDGER L     
      LEFT JOIN (SELECT VTYP, BOOKTYPE, VNO, DDNO= MAX(DDNO) FROM LEDGER1 GROUP BY VTYP, BOOKTYPE, VNO) L1                      
      ON (L1.VTYP=L.VTYP AND L1.BOOKTYPE = L.BOOKTYPE AND L1.VNO = L.VNO),                    
      (SELECT VNO, VTYP, BOOKTYPE FROM LEDGER WHERE VDT BETWEEN @FDATE AND @TDATE + ' 23:59:59' AND CLTCODE = @FCODE) LL,                    
      VMAST V, ACMAST A                    
     WHERE   
      L.VNO = L1.VNO                    
      AND L.VTYP = L1.VTYP                    
      AND L.BOOKTYPE = L1.BOOKTYPE                    
      AND L.VNO = LL.VNO                    
      AND L.VTYP = LL.VTYP                    
      AND L.BOOKTYPE = LL.BOOKTYPE                    
      AND L.CLTCODE = A.CLTCODE                    
      AND L.VTYP = V.VTYPE                    
      AND L.CLTCODE <> @FCODE                    
      AND L.VTYP <> 18                    
    END  
   ELSE  
    BEGIN  
     PRINT 'CAME HERE - II'  
     INSERT INTO TBL_OPPBALANCE                            
     SELECT   
      CLTCODE,   
      SUM(OPBAL) AS OPBAL,  
      SPID ,   
      CURDATE   
  FROM                      
      (SELECT   
       L2.CLTCODE,  
       SUM(CASE L2.DRCR WHEN 'D' THEN L2.CAMT ELSE -L2.CAMT END) AS OPBAL,  
       @@SPID AS SPID,   
       CONVERT(VARCHAR,GETDATE(),112) AS CURDATE  
      FROM   
       LEDGER L, LEDGER2 L2  
      WHERE   
       L.VNO = L2.VNO  
       AND L.VTYP = L2.VTYPE  
       AND L.BOOKTYPE = L2.BOOKTYPE  
       AND L.LNO = L2.LNO  
       AND L.CLTCODE = L2.CLTCODE  
       AND L2.CLTCODE = @FCODE   
       AND L2.COSTCODE = @@COSTCODE  
       AND L.VTYP = 18   
       AND L.VDT LIKE @@STARTDATE + '%'  
      GROUP BY   
       L2.CLTCODE   
     
      UNION ALL  
     
      SELECT   
       L2.CLTCODE,  
       SUM(CASE L2.DRCR WHEN 'D' THEN L2.CAMT ELSE -L2.CAMT END) AS OPBAL,  
       @@SPID AS SPID,   
       CONVERT(VARCHAR,GETDATE(),112) AS CURDATE                      
      FROM   
       LEDGER L, LEDGER2 L2  
      WHERE   
       L.VNO = L2.VNO  
       AND L.VTYP = L2.VTYPE  
       AND L.BOOKTYPE = L2.BOOKTYPE  
       AND L.LNO = L2.LNO  
       AND L.CLTCODE = L2.CLTCODE  
       AND L2.CLTCODE = @FCODE   
       AND L2.COSTCODE = @@COSTCODE  
       AND L.VDT >= @@STARTDATE   
       AND L.VDT <  @FDATE   
       AND L2.VTYPE <> 18                      
      GROUP BY   
       L2.CLTCODE) A  
     GROUP BY   
      CLTCODE,   
      SPID,   
      CURDATE  
   
     INSERT INTO #TBL_GLREPORT                    
     SELECT   
      L.BOOKTYPE,                       
      VOUDT=CONVERT(VARCHAR,L.VDT,103),   
      EFFDT=CONVERT(VARCHAR,L.EDT,103),   
      ISNULL(SHORTDESC,'') SHORTDESC,                                                               
      DRAMT=(CASE WHEN UPPER(L2.DRCR) = 'C' THEN CAMT ELSE 0 END),                                                                
      CRAMT=(CASE WHEN UPPER(L2.DRCR) = 'D' THEN CAMT ELSE 0 END),                              
      L.VNO,   
      REPLACE( L.NARRATION,'"','') NARRATION,                                                 
      DDNO = (CASE WHEN ISNULL(L1.DDNO,'')='0' THEN '' ELSE ISNULL(L1.DDNO,'') END),                                     
      L2.CLTCODE ,  
      A.LONGNAME,  
      VDT,   
      L.VTYP,                                                                
      ACCAT,   
      OPBAL=0,  
      CROSAC='',  
      A.ACNAME,  
      A.BRANCHCODE,
      L.LNO,  
      @@SPID,   
      CONVERT(VARCHAR,GETDATE(),112), '',   
      L.VDT                    
     FROM   
      LEDGER L     
      LEFT JOIN (SELECT VTYP, BOOKTYPE, VNO, DDNO= MAX(DDNO) FROM LEDGER1 GROUP BY VTYP, BOOKTYPE, VNO) L1                      
      ON (L1.VTYP=L.VTYP AND L1.BOOKTYPE = L.BOOKTYPE AND L1.VNO = L.VNO),                    
      (SELECT VNO, VTYP, BOOKTYPE FROM LEDGER WHERE VDT BETWEEN @FDATE AND @TDATE + ' 23:59:59' AND CLTCODE = @FCODE) LL,                    
      VMAST V, ACMAST A, LEDGER2 L2                    
     WHERE   
/*      L.VNO = L1.VNO                    
      AND L.VTYP = L1.VTYP                    
      AND L.BOOKTYPE = L1.BOOKTYPE      */              
      L.VNO = L2.VNO  
      AND L.VTYP = L2.VTYPE   
      AND L.BOOKTYPE = L2.BOOKTYPE  
      AND L.LNO = L2.LNO  
 --     AND L.DRCR = L2.DRCR  
      AND L.VNO = LL.VNO                    
      AND L.VTYP = LL.VTYP                    
      AND L.BOOKTYPE = LL.BOOKTYPE                    
      AND L2.CLTCODE = A.CLTCODE                    
      AND L.VTYP = V.VTYPE                    
      AND L.CLTCODE <> @FCODE                    
      AND L2.COSTCODE = @@COSTCODE  
      AND L.VTYP <> 18    
   
    END  
  END  
 ELSE  
  BEGIN  
   INSERT INTO TBL_OPPBALANCE                            
   SELECT   
    CLTCODE,   
    SUM(OPBAL) AS OPBAL,  
    SPID ,   
    CURDATE   
   FROM                      
    (SELECT   
     L2.CLTCODE,  
     SUM(CASE L2.DRCR WHEN 'D' THEN L2.CAMT ELSE -L2.CAMT END) AS OPBAL,  
     @@SPID AS SPID,   
     CONVERT(VARCHAR,GETDATE(),112) AS CURDATE  
    FROM   
     LEDGER L, LEDGER2 L2  
    WHERE   
     L.VNO = L2.VNO  
AND L.VTYP = L2.VTYPE  
     AND L.BOOKTYPE = L2.BOOKTYPE  
     AND L.LNO = L2.LNO  
     AND L.CLTCODE = L2.CLTCODE  
     AND L2.CLTCODE = @FCODE   
     AND L2.COSTCODE = @@COSTCODE  
     AND L.VTYP = 18   
     AND L.VDT LIKE @@STARTDATE + '%'  
    GROUP BY   
     L2.CLTCODE   
   
    UNION ALL  
   
    SELECT   
     L2.CLTCODE,  
     SUM(CASE L2.DRCR WHEN 'D' THEN L2.CAMT ELSE -L2.CAMT END) AS OPBAL,  
     @@SPID AS SPID,   
     CONVERT(VARCHAR,GETDATE(),112) AS CURDATE                      
    FROM   
     LEDGER L, LEDGER2 L2  
    WHERE   
     L.VNO = L2.VNO  
     AND L.VTYP = L2.VTYPE  
     AND L.BOOKTYPE = L2.BOOKTYPE  
     AND L.LNO = L2.LNO  
     AND L.CLTCODE = L2.CLTCODE  
     AND L2.CLTCODE = @FCODE   
     AND L2.COSTCODE = @@COSTCODE  
     AND L.VDT >= @@STARTDATE   
     AND L.VDT <  @FDATE   
     AND L2.VTYPE <> 18                      
    GROUP BY   
     L2.CLTCODE) A  
   GROUP BY   
    CLTCODE,   
    SPID,   
    CURDATE  
   
     INSERT INTO #TBL_GLREPORT                    
     SELECT   
      L.BOOKTYPE,                       
      VOUDT=CONVERT(VARCHAR,L.VDT,103),   
      EFFDT=CONVERT(VARCHAR,L.EDT,103),   
   
      ISNULL(SHORTDESC,'') SHORTDESC,                                                               
      DRAMT=(CASE WHEN UPPER(L2.DRCR) = 'C' THEN CAMT ELSE 0 END),                                                                
      CRAMT=(CASE WHEN UPPER(L2.DRCR) = 'D' THEN CAMT ELSE 0 END),                              
      L.VNO,   
      REPLACE( L.NARRATION,'"','') NARRATION,                                                 
      DDNO = (CASE WHEN ISNULL(L1.DDNO,'')='0' THEN '' ELSE ISNULL(L1.DDNO,'') END),                                     
      L.CLTCODE ,  
      A.LONGNAME,  
      VDT,   
      L.VTYP,                                                                
      ACCAT,   
      OPBAL=0,  
      CROSAC='',  
      A.ACNAME,  
      A.BRANCHCODE,  
      L.LNO,
      @@SPID,   
      CONVERT(VARCHAR,GETDATE(),112), '',   
      L.VDT                    
     FROM   
      LEDGER L     
      LEFT JOIN (SELECT VTYP, BOOKTYPE, VNO, DDNO= MAX(DDNO) FROM LEDGER1 GROUP BY VTYP, BOOKTYPE, VNO) L1                      
      ON (L1.VTYP=L.VTYP AND L1.BOOKTYPE = L.BOOKTYPE AND L1.VNO = L.VNO),                    
      (SELECT VNO, VTYP, BOOKTYPE FROM LEDGER WHERE VDT BETWEEN @FDATE AND @TDATE + ' 23:59:59' AND CLTCODE = @FCODE) LL,                    
      VMAST V, ACMAST A, LEDGER2 L2                    
     WHERE   
/*      L.VNO = L1.VNO                    
      AND L.VTYP = L1.VTYP                    
      AND L.BOOKTYPE = L1.BOOKTYPE       */             
      L.VNO = L2.VNO  
      AND L.VTYP = L2.VTYPE   
      AND L.BOOKTYPE = L2.BOOKTYPE  
      AND L.LNO = L2.LNO  
 --     AND L.DRCR = L2.DRCR  
      AND L.VNO = LL.VNO                    
      AND L.VTYP = LL.VTYP                    
      AND L.BOOKTYPE = LL.BOOKTYPE                    
      AND L.CLTCODE = A.CLTCODE                    
      AND L.VTYP = V.VTYPE                    
      AND L2.CLTCODE <> @FCODE                    
      AND L2.COSTCODE = @@COSTCODE  
      AND L.VTYP <> 18    
  END  
END  
ELSE  
BEGIN  
 IF @STATUSID = 'BROKER'  
  BEGIN                      
   IF @BRANCH = '' OR @BRANCH = '%'  
    BEGIN  
     PRINT 'CAME HERE - I'  
     INSERT INTO TBL_OPPBALANCE                            
     SELECT   
      CLTCODE,   
      SUM(OPBAL) AS OPBAL,  
      SPID ,   
      CURDATE   
     FROM                      
      (SELECT   
       CLTCODE,  
       SUM(CASE DRCR WHEN 'D' THEN VAMT ELSE -VAMT END) AS OPBAL,  
       @@SPID AS SPID,   
       CONVERT(VARCHAR,GETDATE(),112) AS CURDATE                           
      FROM   
       LEDGER                          
      WHERE   
       CLTCODE = @FCODE   
       AND VTYP = 18   
       AND EDT LIKE @@STARTDATE + '%'  
      GROUP BY   
       CLTCODE  
      UNION ALL                      
      SELECT   
       CLTCODE,  
       SUM(CASE DRCR WHEN 'D' THEN VAMT ELSE -VAMT END) AS OPBAL,  
       @@SPID AS SPID,   
       CONVERT(VARCHAR,GETDATE(),112) AS CURDATE                      
      FROM   
       LEDGER                            
      WHERE   
       CLTCODE = @FCODE   
       AND EDT >= @@STARTDATE   
       AND EDT <  @FDATE                      
       AND VTYP <> 18                      
      GROUP BY   
       CLTCODE  
      UNION ALL                      
      SELECT   
       CLTCODE,  
       SUM(CASE DRCR WHEN 'D' THEN VAMT ELSE -VAMT END) AS OPBAL,  
       @@SPID AS SPID,   
       CONVERT(VARCHAR,GETDATE(),112) AS CURDATE                      
      FROM   
       LEDGER                            
      WHERE   
       CLTCODE = @FCODE   
       AND VDT < @@STARTDATE   
       AND EDT >= @@STARTDATE   
       AND VTYP <> 18                      
      GROUP BY   
       CLTCODE) A  
     GROUP BY   
      CLTCODE,   
      SPID,   
      CURDATE  
   
                       
     INSERT INTO #TBL_GLREPORT                    
     SELECT   
      L.BOOKTYPE,                       
      VOUDT=CONVERT(VARCHAR,L.VDT,103),   
      EFFDT=CONVERT(VARCHAR,L.EDT,103),   
      ISNULL(SHORTDESC,'') SHORTDESC,                                                               
      DRAMT=(CASE WHEN UPPER(L.DRCR) = 'C' THEN VAMT ELSE 0 END),                                                                
      CRAMT=(CASE WHEN UPPER(L.DRCR) = 'D' THEN VAMT ELSE 0 END),                              
      L.VNO,   
      REPLACE( L.NARRATION,'"','') NARRATION,                                                 
      DDNO = (CASE WHEN ISNULL(L1.DDNO,'')='0' THEN '' ELSE ISNULL(L1.DDNO,'') END),                                     
      L.CLTCODE ,  
      A.LONGNAME,  
      VDT,   
      L.VTYP,                                                                
      ACCAT,   
      OPBAL=0,  
      CROSAC='',  
      A.ACNAME,  
      A.BRANCHCODE,
      L.LNO,  
      @@SPID,   
      CONVERT(VARCHAR,GETDATE(),112), '',   
      L.VDT                    
     FROM   
      LEDGER L     
      LEFT JOIN (SELECT VTYP, BOOKTYPE, VNO, DDNO= MAX(DDNO) FROM LEDGER1 GROUP BY VTYP, BOOKTYPE, VNO) L1                      
      ON (L1.VTYP=L.VTYP AND L1.BOOKTYPE = L.BOOKTYPE AND L1.VNO = L.VNO),                    
      (SELECT VNO, VTYP, BOOKTYPE FROM LEDGER WHERE EDT BETWEEN @FDATE AND @TDATE + ' 23:59:59' AND CLTCODE = @FCODE) LL,                    
      VMAST V, ACMAST A                    
     WHERE   
      L.VNO = LL.VNO                    
      AND L.VTYP = LL.VTYP                    
      AND L.BOOKTYPE = LL.BOOKTYPE                    
      AND L.CLTCODE = A.CLTCODE                    
      AND L.VTYP = V.VTYPE                    
      AND L.CLTCODE <> @FCODE                    
      AND L.VTYP <> 18                    
    END  
   ELSE  
    BEGIN  
     PRINT 'CAME HERE - II'  
     INSERT INTO TBL_OPPBALANCE                            
     SELECT   
      CLTCODE,   
      SUM(OPBAL) AS OPBAL,  
      SPID ,   
      CURDATE   
     FROM                      
      (SELECT   
       L2.CLTCODE,  
       SUM(CASE L2.DRCR WHEN 'D' THEN L2.CAMT ELSE -L2.CAMT END) AS OPBAL,  
       @@SPID AS SPID,   
       CONVERT(VARCHAR,GETDATE(),112) AS CURDATE  
      FROM   
       LEDGER L, LEDGER2 L2  
      WHERE   
       L.VNO = L2.VNO  
       AND L.VTYP = L2.VTYPE  
       AND L.BOOKTYPE = L2.BOOKTYPE  
       AND L.LNO = L2.LNO  
       AND L.CLTCODE = L2.CLTCODE  
       AND L2.CLTCODE = @FCODE   
       AND L2.COSTCODE = @@COSTCODE  
       AND L.VTYP = 18   
       AND L.EDT LIKE @@STARTDATE + '%'  
      GROUP BY   
       L2.CLTCODE   
     
      UNION ALL  
     
      SELECT   
       L2.CLTCODE,  
      SUM(CASE L2.DRCR WHEN 'D' THEN L2.CAMT ELSE -L2.CAMT END) AS OPBAL,  
       @@SPID AS SPID,   
       CONVERT(VARCHAR,GETDATE(),112) AS CURDATE                      
      FROM   
       LEDGER L, LEDGER2 L2  
      WHERE   
       L.VNO = L2.VNO  
       AND L.VTYP = L2.VTYPE  
       AND L.BOOKTYPE = L2.BOOKTYPE  
       AND L.LNO = L2.LNO  
       AND L.CLTCODE = L2.CLTCODE  
       AND L2.CLTCODE = @FCODE   
       AND L2.COSTCODE = @@COSTCODE  
       AND L.EDT >= @@STARTDATE   
       AND L.EDT <  @FDATE   
       AND L2.VTYPE <> 18                      
      GROUP BY   
       L2.CLTCODE  
  
      UNION ALL  
     
      SELECT   
       L2.CLTCODE,  
       SUM(CASE L2.DRCR WHEN 'D' THEN L2.CAMT ELSE -L2.CAMT END) AS OPBAL,  
       @@SPID AS SPID,   
       CONVERT(VARCHAR,GETDATE(),112) AS CURDATE                      
      FROM   
       LEDGER L, LEDGER2 L2  
      WHERE   
       L.VNO = L2.VNO  
       AND L.VTYP = L2.VTYPE  
       AND L.BOOKTYPE = L2.BOOKTYPE  
       AND L.LNO = L2.LNO  
       AND L.CLTCODE = L2.CLTCODE  
       AND L2.CLTCODE = @FCODE   
       AND L2.COSTCODE = @@COSTCODE  
       AND L.EDT >= @@STARTDATE   
       AND L.VDT <  @@STARTDATE   
       AND L2.VTYPE <> 18                      
      GROUP BY   
       L2.CLTCODE) A  
     GROUP BY   
      CLTCODE,   
      SPID,   
      CURDATE  
   
     INSERT INTO #TBL_GLREPORT                    
     SELECT   
      L.BOOKTYPE,                       
      VOUDT=CONVERT(VARCHAR,L.VDT,103),   
      EFFDT=CONVERT(VARCHAR,L.EDT,103),   
      ISNULL(SHORTDESC,'') SHORTDESC,                                                               
      DRAMT=(CASE WHEN UPPER(L2.DRCR) = 'C' THEN CAMT ELSE 0 END),                                                                
      CRAMT=(CASE WHEN UPPER(L2.DRCR) = 'D' THEN CAMT ELSE 0 END),                              
      L.VNO,   
      REPLACE( L.NARRATION,'"','') NARRATION,                                                 
      DDNO = (CASE WHEN ISNULL(L1.DDNO,'')='0' THEN '' ELSE ISNULL(L1.DDNO,'') END),                                     
      L.CLTCODE ,  
      A.LONGNAME,  
      VDT,   
      L.VTYP,                                                                
      ACCAT,   
      OPBAL=0,  
      CROSAC='',  
      A.ACNAME,  
      A.BRANCHCODE,  
      L.LNO,
      @@SPID,   
      CONVERT(VARCHAR,GETDATE(),112), '',   
      L.VDT                    
     FROM   
      LEDGER L     
      LEFT JOIN (SELECT VTYP, BOOKTYPE, VNO, DDNO= MAX(DDNO) FROM LEDGER1 GROUP BY VTYP, BOOKTYPE, VNO) L1                      
      ON (L1.VTYP=L.VTYP AND L1.BOOKTYPE = L.BOOKTYPE AND L1.VNO = L.VNO),                    
      (SELECT VNO, VTYP, BOOKTYPE FROM LEDGER WHERE EDT BETWEEN @FDATE AND @TDATE + ' 23:59:59' AND CLTCODE = @FCODE) LL,                    
      VMAST V, ACMAST A, LEDGER2 L2                    
     WHERE   
      L.VNO = L2.VNO  
      AND L.VTYP = L2.VTYPE   
      AND L.BOOKTYPE = L2.BOOKTYPE  
      AND L.LNO = L2.LNO  
      AND L.VNO = LL.VNO                    
      AND L.VTYP = LL.VTYP                    
      AND L.BOOKTYPE = LL.BOOKTYPE                    
      AND L.CLTCODE = A.CLTCODE                    
      AND L.VTYP = V.VTYPE                    
      AND L.CLTCODE <> @FCODE                    
      AND L2.COSTCODE = @@COSTCODE  
      AND L.VTYP <> 18    
   
    END  
  END  
 ELSE  
  BEGIN  
   INSERT INTO TBL_OPPBALANCE                            
   SELECT   
    CLTCODE,   
    SUM(OPBAL) AS OPBAL,  
    SPID ,   
    CURDATE   
   FROM                      
    (SELECT   
     L2.CLTCODE,  
     SUM(CASE L2.DRCR WHEN 'D' THEN L2.CAMT ELSE -L2.CAMT END) AS OPBAL,  
     @@SPID AS SPID,   
     CONVERT(VARCHAR,GETDATE(),112) AS CURDATE  
    FROM   
     LEDGER L, LEDGER2 L2  
    WHERE   
     L.VNO = L2.VNO  
     AND L.VTYP = L2.VTYPE  
 AND L.BOOKTYPE = L2.BOOKTYPE  
     AND L.LNO = L2.LNO  
     AND L.CLTCODE = L2.CLTCODE  
     AND L2.CLTCODE = @FCODE   
     AND L2.COSTCODE = @@COSTCODE  
     AND L.VTYP = 18   
     AND L.EDT LIKE @@STARTDATE + '%'  
    GROUP BY   
     L2.CLTCODE   
   
    UNION ALL  
   
    SELECT   
     L2.CLTCODE,  
     SUM(CASE L2.DRCR WHEN 'D' THEN L2.CAMT ELSE -L2.CAMT END) AS OPBAL,  
     @@SPID AS SPID,   
     CONVERT(VARCHAR,GETDATE(),112) AS CURDATE                      
    FROM   
     LEDGER L, LEDGER2 L2  
    WHERE   
     L.VNO = L2.VNO  
     AND L.VTYP = L2.VTYPE  
     AND L.BOOKTYPE = L2.BOOKTYPE  
     AND L.LNO = L2.LNO  
     AND L.CLTCODE = L2.CLTCODE  
     AND L2.CLTCODE = @FCODE   
     AND L2.COSTCODE = @@COSTCODE  
     AND L.EDT >= @@STARTDATE   
     AND L.EDT <  @FDATE                      
     AND L2.VTYPE <> 18                      
    GROUP BY   
     L2.CLTCODE  
   
    UNION ALL  
   
    SELECT   
     L2.CLTCODE,  
     SUM(CASE L2.DRCR WHEN 'D' THEN L2.CAMT ELSE -L2.CAMT END) AS OPBAL,  
     @@SPID AS SPID,   
     CONVERT(VARCHAR,GETDATE(),112) AS CURDATE                      
    FROM   
     LEDGER L, LEDGER2 L2  
    WHERE   
     L.VNO = L2.VNO  
     AND L.VTYP = L2.VTYPE  
     AND L.BOOKTYPE = L2.BOOKTYPE  
     AND L.LNO = L2.LNO  
     AND L.CLTCODE = L2.CLTCODE  
     AND L2.CLTCODE = @FCODE   
     AND L2.COSTCODE = @@COSTCODE  
     AND L.EDT >= @@STARTDATE   
     AND L.VDT <  @@STARTDATE           
     AND L2.VTYPE <> 18                      
    GROUP BY   
     L2.CLTCODE) A  
   GROUP BY   
    CLTCODE,   
    SPID,   
    CURDATE  
   
     INSERT INTO #TBL_GLREPORT                    
     SELECT   
      L.BOOKTYPE,                       
      VOUDT=CONVERT(VARCHAR,L.VDT,103),   
      EFFDT=CONVERT(VARCHAR,L.EDT,103),   
   
      ISNULL(SHORTDESC,'') SHORTDESC,                                                               
      DRAMT=(CASE WHEN UPPER(L2.DRCR) = 'C' THEN CAMT ELSE 0 END),                                                                
      CRAMT=(CASE WHEN UPPER(L2.DRCR) = 'D' THEN CAMT ELSE 0 END),                              
      L.VNO,   
      REPLACE( L.NARRATION,'"','') NARRATION,                                                 
      DDNO = (CASE WHEN ISNULL(L1.DDNO,'')='0' THEN '' ELSE ISNULL(L1.DDNO,'') END),                                     
      L.CLTCODE ,  
      A.LONGNAME,  
      VDT,   
      L.VTYP,                                                                
      ACCAT,   
      OPBAL=0,  
      CROSAC='',  
      A.ACNAME,  
      A.BRANCHCODE,  
      L.LNO,
      @@SPID,   
      CONVERT(VARCHAR,GETDATE(),112), '',   
      L.VDT                    
     FROM   
      LEDGER L     
      LEFT JOIN (SELECT VTYP, BOOKTYPE, VNO, DDNO= MAX(DDNO) FROM LEDGER1 GROUP BY VTYP, BOOKTYPE, VNO) L1                      
      ON (L1.VTYP=L.VTYP AND L1.BOOKTYPE = L.BOOKTYPE AND L1.VNO = L.VNO),                    
      (SELECT VNO, VTYP, BOOKTYPE FROM LEDGER WHERE EDT BETWEEN @FDATE AND @TDATE + ' 23:59:59' AND CLTCODE = @FCODE) LL,                    
      VMAST V, ACMAST A, LEDGER2 L2                    
     WHERE   
      L.VNO = L2.VNO  
      AND L.VTYP = L2.VTYPE   
      AND L.BOOKTYPE = L2.BOOKTYPE  
      AND L.LNO = L2.LNO  
      AND L.VNO = LL.VNO                    
      AND L.VTYP = LL.VTYP                    
      AND L.BOOKTYPE = LL.BOOKTYPE                    
      AND L.CLTCODE = A.CLTCODE                    
      AND L.VTYP = V.VTYPE                    
      AND L2.CLTCODE <> @FCODE                    
      AND L2.COSTCODE = @@COSTCODE  
      AND L.VTYP <> 18    
  END  
END  
  
UPDATE #TBL_GLREPORT SET NARRATION = RTRIM(LONGNAME) + ' - ' + RTRIM(NARRATION) WHERE PROCID = @@SPID                    
UPDATE #TBL_GLREPORT SET OPBAL = TBL_OPPBALANCE.OPPBAL,CROSAC=''  FROM TBL_OPPBALANCE 
WHERE TBL_OPPBALANCE.CLTCODE = @FCODE AND TBL_OPPBALANCE.PROCID = @@SPID AND TBL_OPPBALANCE.PROCID = #TBL_GLREPORT.PROCID                    
UPDATE #TBL_GLREPORT SET CROSAC = CLTCODE WHERE PROCID = @@SPID                    
UPDATE #TBL_GLREPORT SET CLTCODE = @FCODE WHERE PROCID = @@SPID                    
UPDATE #TBL_GLREPORT SET ACNAME = A.ACNAME FROM ACMAST A WHERE #TBL_GLREPORT.CLTCODE = A.CLTCODE AND #TBL_GLREPORT.PROCID = @@SPID                    
                
INSERT INTO #TBL_GLREPORT SELECT '','','','',0,0,'','','',CLTCODE,'','',0,'',OPPBAL,CLTCODE,'','','',PROCID,REPDATE, '', ''                    
FROM TBL_OPPBALANCE WHERE CLTCODE NOT IN (SELECT CLTCODE FROM #TBL_GLREPORT WHERE PROCID = @@SPID)                        
            
DELETE FROM #TBL_GLREPORT WHERE DRAMT = 0 AND CRAMT = 0 AND OPBAL = 0 

UPDATE #TBL_GLREPORT SET BRANCHCODE = COSTNAME FROM LEDGER2 L2, COSTMAST C  
WHERE #TBL_GLREPORT.VNO = L2.VNO AND #TBL_GLREPORT.VTYP = L2.VTYPE AND #TBL_GLREPORT.BOOKTYPE = L2.BOOKTYPE AND #TBL_GLREPORT.LNO = L2.LNO AND #TBL_GLREPORT.CROSAC = L2.CLTCODE  
AND L2.COSTCODE = C.COSTCODE             
                    
--SELECT * FROM TBL_OPPBALANCE WHERE PROCID = @@SPID                    
--SELECT * FROM TBL_GLREPORT WHERE PROCID = @@SPID                    
SELECT   
      BOOKTYPE,  
      VOUDT VDT ,  
      EFFDT EDT ,  
      SHORTDESC,  
      DRAMT DEBIT,  
      CRAMT CREDIT,  
      VNO,  
      NARRATION,  
      DDNO,  
      CLTCODE,  
      LONGNAME,  
      VTYP,  
      ACCAT,  
      OPBAL,  
      CROSAC,  
      ACNAME,  
      BRANCHCODE                    
FROM   
      #TBL_GLREPORT    
WHERE   
      PROCID = @@SPID
      AND CLTCODE NOT IN(SELECT BRCONTROLAC FROM BRANCHACCOUNTS)
ORDER BY   
      CONVERT(DATETIME, LEFT(CONVERT(VARCHAR, VCHDT, 109),11)), CONVERT(NUMERIC, VTYP), VNO

GO
