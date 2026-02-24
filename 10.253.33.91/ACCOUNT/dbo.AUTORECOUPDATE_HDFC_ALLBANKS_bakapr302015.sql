-- Object: PROCEDURE dbo.AUTORECOUPDATE_HDFC_ALLBANKS_bakapr302015
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC AUTORECOUPDATE_HDFC_ALLBANKS(            
           @FILENAME       VARCHAR(100),            
           @UNAME          VARCHAR(100),            
           @BANKCODE       VARCHAR(10),            
           @STATUSID       VARCHAR(10),            
           @STATUSNAME     VARCHAR(100),            
           @BANK_TYPE      VARCHAR(10),            
           @STAT_TYPE      VARCHAR(10),            
           @LOGIN          VARCHAR(10),            
           @PWD            VARCHAR(15),            
           @PROCESS_STATUS BIT  = 0)            
            
AS            
            
  DECLARE  @@SQL_QUERY         AS VARCHAR(1000),            
           @@CROSSREFERENCENO INT,            
           @@TABLE_EXIST      VARCHAR(20),            
           @@RECORD_COUNT     TINYINT,            
           @@RECO_STATUS      CHAR(1),            
           @@FILE_EXIST       INT,            
           @@CLTCODE_EXIST    INT,            
           @@MICRNO           VARCHAR(20)            
                                        
  SET NOCOUNT ON            
              
  SELECT @@CLTCODE_EXIST = COUNT(1)            
  FROM   ACMAST WITH(NOLOCK)             
  WHERE  CLTCODE = @BANKCODE            
         AND ACCAT = 2            
                                 
  IF @@CLTCODE_EXIST = 0            
    BEGIN            
      SELECT 'BANK CODE DOSE NOT EXIST.'            
                  
      RETURN            
    END            
        
               
  SELECT @@MICRNO = ISNULL(MICRNO,0)            
  FROM   ACMAST WITH(NOLOCK)             
  WHERE  CLTCODE = @BANKCODE            
         AND ACCAT = 2            
                                 
  /*-------------------------VALIDATION FOR SINGLE VOUCHER TYPE BASED ON DRCR ------------------------*/            
  DECLARE  @@ERROR_COUNT        SMALLINT,            
           @@EXIST_COUNT_BEFORE SMALLINT,            
           @@EXIST_COUNT_AFTER  SMALLINT            
              
  SELECT @@ERROR_COUNT = COUNT(1)            
  FROM   (SELECT U_FILENAME            
          FROM   V2_UPLOADED_FILES WITH(NOLOCK)             
          WHERE  U_FILENAME = @FILENAME            
                 AND U_MODULE = 'HDFC_RECO UPLOAD') A            
              
  SELECT @@CROSSREFERENCENO = ISNULL(MAX(CONVERT(NUMERIC,CROSSREFERENCENO)),0)            
  FROM   BANKRECO WITH(NOLOCK)             
                     
  CREATE TABLE #HDFCRECO (            
    BOOKDATE VARCHAR(11))            
              
  CREATE TABLE #ICICIRECO (            
    SR_NO    INT,            
    TXN_ID   VARCHAR(25),            
    BOOKDATE VARCHAR(11))            
              
  IF @BANK_TYPE = 'CITYRECO' AND @STAT_TYPE = 'CSV'         
  BEGIN            
   SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO ADD REFERENCE_NO VARCHAR(20),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " DRCR CHAR(1),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " AMOUNT VARCHAR(20),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " REFNO VARCHAR(100)"            
  END            
  ELSE IF (@BANK_TYPE = 'HDFCRECO' AND @STAT_TYPE = 'TAB') OR (@BANK_TYPE = 'CITYRECO' AND @STAT_TYPE = 'TAB') OR @BANK_TYPE = 'UTIRECO'             
  BEGIN            
   SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO ADD [DESCRIPTION] VARCHAR(100), "            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " LEDGER_BALANCE VARCHAR(20),"              
   SELECT @@SQL_QUERY = @@SQL_QUERY + " CREDIT VARCHAR(20),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " DEBIT VARCHAR(20),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " VALUEDATE VARCHAR(11),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " REFERENCE_NO VARCHAR(20),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " TRANSACTION_BRANCH VARCHAR(30)"            
  END            
  ELSE IF @BANK_TYPE = 'HDFCRECO' AND @STAT_TYPE = 'CSV'            
  BEGIN            
   SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO ADD VALUEDATE VARCHAR(11), "            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " AMOUNT VARCHAR(20),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " DRCR CHAR(1),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " [DESCRIPTION] VARCHAR(100),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " REFERENCE_NO VARCHAR(20),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " TRANSACTION_BRANCH VARCHAR(30),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " RUNNING_BAL VARCHAR(20)"            
  END            
  ELSE IF @BANK_TYPE = 'ICICIRECO'             
  BEGIN            
   SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO ADD [DESCRIPTION] VARCHAR(100), "            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " REFERENCE_NO VARCHAR(20),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " DRCR CHAR(2),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " AMOUNT VARCHAR(20),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " RUNNING_BAL VARCHAR(20)"            
             
  END            
              
  EXEC (@@SQL_QUERY)               
              
  IF @BANK_TYPE = 'ICICIRECO'             
  BEGIN            
   SELECT @@SQL_QUERY = "ALTER TABLE #ICICIRECO ADD [DESCRIPTION] VARCHAR(100), "            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " REFERENCE_NO VARCHAR(20),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " DRCR CHAR(2),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " AMOUNT VARCHAR(20),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " RUNNING_BAL VARCHAR(20)"            
              
   EXEC (@@SQL_QUERY)            
  END            
              
  CREATE TABLE [#BANKRECOSAVE_TEMP]                  
   (                  
    CLTCODE VARCHAR(10),                  
    BOOKDATE DATETIME,                  
    [DESCRIPTION] VARCHAR(50),                  
    AMOUNT VARCHAR(20),                  
    DRCR VARCHAR(1),                  
    VALUEDATE DATETIME,                  
    REFERENCENO VARCHAR(30),                  
    STATUSID VARCHAR(15),                  
    STATUSNAME VARCHAR(25),                  
    LOGINNAME VARCHAR(25),                  
    STATUS VARCHAR(9),                  
    MICRNO INT,                  
    DUMMY1 VARCHAR(15) ,                  
    DUMMY2 VARCHAR(15),                  
    AMOUNTLEDGR1 VARCHAR(20),                  
    CROSSREFERENCENO [INT] IDENTITY (1, 1) NOT NULL                  
   )                  
  ON [PRIMARY]                  
                    
  CREATE TABLE [#BANKRECOSAVE]                  
   (                  
    CLTCODE VARCHAR(10),                  
    BOOKDATE DATETIME,                  
    [DESCRIPTION] VARCHAR(50),                  
    AMOUNT MONEY,                  
    DRCR VARCHAR(1),                  
    VALUEDATE DATETIME,                  
    REFERENCENO VARCHAR(30),                  
    STATUSID VARCHAR(15),                  
    STATUSNAME VARCHAR(25),                  
    LOGINNAME VARCHAR(25),                  
    CROSSREFERENCENO [INT],                  
    STATUS VARCHAR(9),                  
    MICRNO INT,                  
    DUMMY1 VARCHAR(15) ,                  
    DUMMY2 VARCHAR(15),                  
    AMOUNTLEDGR1 MONEY,             
    L1_SNO INT,             
    VTYP SMALLINT,             
    BOOKTYPE CHAR(2),             
    VNO VARCHAR(12),             
    SLIPNO INT             
   )                  
  ON [PRIMARY]                 
              
  CREATE TABLE #TESTIMPORT                            
  (                            
   OneRow Varchar(2000),                          
   SNO INT IDENTITY(1,1)                          
  )               
              
  IF @BANK_TYPE = 'ICICIRECO'            
  BEGIN            
   SELECT @@SQL_QUERY = "EXEC BULKCOPYRECO_ALLBANK '" + @FILENAME + "',  '#ICICIRECO','" + @BANK_TYPE + "','" + @STAT_TYPE + "','" + @LOGIN + "','" + @PWD + "'"            
               
  END            
  ELSE IF @BANK_TYPE <> 'CANARARECO'            
  BEGIN            
   SELECT @@SQL_QUERY = "EXEC BULKCOPYRECO_ALLBANK '" + @FILENAME + "',  '#HDFCRECO','" + @BANK_TYPE + "','" + @STAT_TYPE + "','" + @LOGIN + "','" + @PWD + "'"     
  END            
              
  --PRINT @@SQL_QUERY            
  EXEC (@@SQL_QUERY)             
              
  IF @BANK_TYPE = 'CITYRECO' AND @STAT_TYPE = 'CSV'           
  BEGIN            
   SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO "            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " ADD [DESCRIPTION] VARCHAR(100), "            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " VALUEDATE VARCHAR(11), "            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " CREDIT VARCHAR(20),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " DEBIT VARCHAR(20)"            
  END            
  ELSE IF (@BANK_TYPE = 'HDFCRECO' AND @STAT_TYPE = 'TAB') OR (@BANK_TYPE = 'CITYRECO' AND @STAT_TYPE = 'TAB') OR @BANK_TYPE = 'UTIRECO'             
  BEGIN            
   SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO "            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " ADD AMOUNT VARCHAR(20), "            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " DRCR VARCHAR(1) "            
  END            
  ELSE IF @BANK_TYPE = 'HDFCRECO' AND @STAT_TYPE = 'CSV'            
  BEGIN            
   SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO "            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " ADD CREDIT VARCHAR(20),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " DEBIT VARCHAR(20)"            
  END            
  ELSE IF @BANK_TYPE = 'ICICIRECO'            
  BEGIN            
   SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO "            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " ADD VALUEDATE VARCHAR(11), "            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " CREDIT VARCHAR(20),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " DEBIT VARCHAR(20) "            
  END            
  ELSE            
  BEGIN            
   SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO "            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " ADD [DESCRIPTION] VARCHAR(100), "            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " VALUEDATE VARCHAR(11), "            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " CREDIT VARCHAR(20),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " DEBIT VARCHAR(20),"            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " AMOUNT VARCHAR(20), "            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " DRCR VARCHAR(1), "            
   SELECT @@SQL_QUERY = @@SQL_QUERY + " REFERENCE_NO VARCHAR(20) "            
  END            
              
              
  EXEC (@@SQL_QUERY)            
              
  SELECT *            
  INTO   HDFCRECO            
  FROM   #HDFCRECO            
                     
  IF @BANK_TYPE = 'CITYRECO' AND @STAT_TYPE = 'CSV'          
    BEGIN            
      UPDATE HDFCRECO            
      SET    [DESCRIPTION] = 'CITY BANK RECONCILIATION FILE',            
             VALUEDATE = BOOKDATE            
    END            
  ELSE            
    IF (@BANK_TYPE = 'HDFCRECO'            
        AND @STAT_TYPE = 'TAB')            
        OR @BANK_TYPE = 'UTIRECO'            
      BEGIN            
        UPDATE HDFCRECO            
        SET    AMOUNT = CASE             
                          WHEN (DEBIT IS NULL             
                                 OR CONVERT(MONEY,DEBIT) = 0) THEN CREDIT            
                          ELSE DEBIT            
                        END,            
               DRCR = CASE             
                        WHEN (DEBIT IS NULL             
                               OR CONVERT(MONEY,DEBIT) = 0) THEN 'C'            
                        ELSE 'D'            
                      END            
      END            
    ELSE            
      IF @BANK_TYPE = 'ICICIRECO'            
        BEGIN            
          UPDATE HDFCRECO            
          SET    VALUEDATE = BOOKDATE,            
                 DRCR = (CASE             
                           WHEN DRCR = 'DR' THEN 'D'            
                           ELSE 'C'            
                         END)            
        END            
              
  IF @BANK_TYPE = 'CANARARECO'            
    BEGIN            
   SELECT @@SQL_QUERY = "INSERT INTO #TESTIMPORT EXEC MASTER.DBO.XP_CMDSHELL 'TYPE " + @FILENAME + "'"            
     EXEC(@@SQL_QUERY)                            
              
      DELETE FROM #TESTIMPORT            
      WHERE       ONEROW IS NULL            
                              
      DELETE FROM #TESTIMPORT            
      WHERE       ONEROW LIKE '****%'            
                                          
      INSERT INTO #BANKRECOSAVE_TEMP            
      SELECT @BANKCODE,            
             BOOKDATE = CONVERT(DATETIME,SUBSTRING(SUBSTRING(ONEROW,1,8),7,2) + '/' + SUBSTRING(SUBSTRING(ONEROW,1,8),5,2) + '/' + SUBSTRING(SUBSTRING(ONEROW,1,8),1,4),            
                                103),            
             [DESCRIPTION] = SUBSTRING(ONEROW,18,23),            
             AMOUNT = SUBSTRING(ONEROW,41,14),            
             DRCR = SUBSTRING(ONEROW,17,1),            
             VALUEDATE = CONVERT(DATETIME,SUBSTRING(SUBSTRING(ONEROW,1,8),7,2) + '/' + SUBSTRING(SUBSTRING(ONEROW,1,8),5,2) + '/' + SUBSTRING(SUBSTRING(ONEROW,1,8),1,4),            
                                 103),            
             REFERENCE_NO = SUBSTRING(ONEROW,9,8),            
             @STATUSID,            
             @STATUSNAME,            
             @UNAME,            
             'UNMATCHED',            
             @@MICRNO,            
             '',            
             '',            
             ''                         
      FROM   #TESTIMPORT            
                         
    END            
  ELSE            
    IF @BANK_TYPE = 'ICICIRECO'            
      BEGIN            
        INSERT INTO #BANKRECOSAVE_TEMP            
        SELECT @BANKCODE,            
               BOOKDATE = CONVERT(DATETIME,(LEFT(BOOKDATE,2) + '/' + SUBSTRING(BOOKDATE,4,2) + '/' + RIGHT(BOOKDATE,4)),            
                              101),            
               [DESCRIPTION],            
               AMOUNT,            
               DRCR,            
               VALUEDATE = CONVERT(DATETIME,RIGHT(VALUEDATE,4) + '-' + LEFT(VALUEDATE,2) + '-' + SUBSTRING(VALUEDATE,4,2)),            
               REFERENCE_NO,            
               @STATUSID,            
               @STATUSNAME,            
               @UNAME,            
               'UNMATCHED',            
               @@MICRNO,            
               '',            
               '',            
               ''            
        FROM   HDFCRECO            
                           
      END            
    ELSE            
      BEGIN            
        INSERT INTO #BANKRECOSAVE_TEMP            
        SELECT @BANKCODE,            
               BOOKDATE = CONVERT(DATETIME,(LEFT(BOOKDATE,2) + '/' + SUBSTRING(BOOKDATE,4,2) + '/' + RIGHT(BOOKDATE,4)),            
                                  103),            
               [DESCRIPTION],            
               AMOUNT,            
               DRCR,            
               VALUEDATE = CONVERT(DATETIME,RIGHT(VALUEDATE,4) + '-' + SUBSTRING(VALUEDATE,4,2) + '-' + LEFT(VALUEDATE,2)),            
               REFERENCE_NO,            
               @STATUSID,            
               @STATUSNAME,            
               @UNAME,            
               'UNMATCHED',            
               @@MICRNO,            
               '',            
               '',            
               ''            
        FROM   HDFCRECO            
      END            
                  
  DROP TABLE HDFCRECO            
              
  INSERT INTO #BANKRECOSAVE            
  SELECT @BANKCODE,            
         BOOKDATE,            
         [DESCRIPTION],            
         AMOUNT = CASE             
                    WHEN DRCR = 'D' THEN ABS(CONVERT(MONEY,AMOUNT))            
                    ELSE CONVERT(MONEY,AMOUNT)            
                  END,            
         DRCR,            
         VALUEDATE,            
         REFERENCENO = CONVERT(VARCHAR,CONVERT(BIGINT,REFERENCENO)),            
         @STATUSID,            
         @STATUSNAME,            
         @UNAME,            
         CROSSREFERENCNEO = CONVERT(INT,@@CROSSREFERENCENO + CROSSREFERENCENO),            
         'UNMATCHED',            
         @@MICRNO,            
         '',            
         '',            
         0,             
         0,             
         0,             
         '',             
         '',             
         0             
  FROM   #BANKRECOSAVE_TEMP            
  WHERE  REFERENCENO NOT LIKE '%[A-Z]%'            
                                          
  INSERT INTO #BANKRECOSAVE            
  SELECT @BANKCODE,            
         BOOKDATE,            
         [DESCRIPTION],            
         AMOUNT = CASE             
                    WHEN DRCR = 'D' THEN ABS(CONVERT(MONEY,AMOUNT))            
                    ELSE CONVERT(MONEY,AMOUNT)            
                  END,            
         DRCR,            
         VALUEDATE,            
         REFERENCENO,            
         @STATUSID,            
         @STATUSNAME,            
         @UNAME,            
         CROSSREFERENCNEO = CONVERT(INT,@@CROSSREFERENCENO + CROSSREFERENCENO),            
         'UNMATCHED',            
         @@MICRNO,            
         '',            
         '',            
         0,             
         0,             
         0,             
         '',             
         '',             
         0             
  FROM   #BANKRECOSAVE_TEMP            
  WHERE  REFERENCENO LIKE '%[A-Z]%'            
                                      
  INSERT INTO #BANKRECOSAVE            
  SELECT @BANKCODE,            
         BOOKDATE,            
         [DESCRIPTION],            
         AMOUNT = CASE             
                    WHEN DRCR = 'D' THEN ABS(CONVERT(MONEY,AMOUNT))            
                    ELSE CONVERT(MONEY,AMOUNT)            
                  END,            
         DRCR,            
         VALUEDATE,            
         REFERENCENO = ISNULL(CONVERT(VARCHAR,CONVERT(BIGINT,REFERENCENO)),            
                              0),            
         @STATUSID,            
         @STATUSNAME,            
         @UNAME,            
         CROSSREFERENCNEO = CONVERT(INT,@@CROSSREFERENCENO + CROSSREFERENCENO),            
         'UNMATCHED',            
         @@MICRNO,            
         '',            
         '',            
         0,             
         0,             
         0,             
         '',             
         '',             
         0             
  FROM   #BANKRECOSAVE_TEMP            
  WHERE  REFERENCENO IS NULL            
                     
  IF @BANK_TYPE = 'CANARARECO'            
    BEGIN            
      UPDATE #BANKRECOSAVE            
      SET    AMOUNT = CONVERT(MONEY,AMOUNT / 100)            
    END            
                
  /*CREATE TABLE #BANKRECOSAVE_DELETE                  
  (                  
   [DESCRIPTION] VARCHAR(250),                  
   AMOUNT MONEY,                  
   DRCR CHAR(1),                  
   REFERENCENO VARCHAR(25),                  
  CROSSREFERENCENO INT                  
  ) */            
  DECLARE  @@AMOUNTDIFF   MONEY,            
           @@STAMOUNTDIFF MONEY,            
           @@BOOKDATE_MIN DATETIME,            
           @@BOOKDATE_MAX DATETIME            
                                      
  SELECT @@BOOKDATE_MIN = MIN(BOOKDATE)            
  FROM   #BANKRECOSAVE            
                     
  SELECT @@BOOKDATE_MAX = MAX(BOOKDATE)            
  FROM   #BANKRECOSAVE            
                     
  CREATE TABLE #RECODUPS (            
    BOOKDATE         VARCHAR(11),            
    REFERENCENO      VARCHAR(25),            
    AMOUNT           MONEY,            
    DESCRIPTION      VARCHAR(200),            
    STATUS           VARCHAR(10),            
    CROSSREFERENCENO INT)            
              
  SET @@EXIST_COUNT_BEFORE = 0            
                                         
  SET @@EXIST_COUNT_AFTER = 0            
                                        
  DECLARE  @CLTCODE     VARCHAR(10),            
           @BOOKDATE    DATETIME,            
           @AMOUNT      MONEY,            
           @DRCR        CHAR(1),            
           @VALUEDATE   DATETIME,            
           @REFERENCENO VARCHAR(20),            
           @DESCRIPTION VARCHAR(200)            
                                    
  DECLARE CUR_CHECCK CURSOR  FOR            
  SELECT CLTCODE,            
         BOOKDATE,            
         AMOUNT,            
         DRCR,            
         VALUEDATE,            
         REFERENCENO,            
         [DESCRIPTION]            
  FROM   #BANKRECOSAVE            
  WHERE  AMOUNT < 0            
                              
  OPEN CUR_CHECCK            
              
  FETCH NEXT FROM CUR_CHECCK            
  INTO @CLTCODE,            
       @BOOKDATE,            
       @AMOUNT,            
       @DRCR,            
       @VALUEDATE,            
       @REFERENCENO,            
       @DESCRIPTION            
                   
  WHILE @@FETCH_STATUS = 0            
    BEGIN            
      /* NEW LOGIC TO UPLOAD THE SAME BOOKDATED BANK STATEMENT MULTIPLE TIMES */            
      IF @PROCESS_STATUS = 0            
        BEGIN            
          SELECT @@ERROR_COUNT = 0            
                                             
          SELECT @@EXIST_COUNT_BEFORE = COUNT(1)            
          FROM   BANKRECO WITH(NOLOCK)            
          WHERE  CLTCODE = @CLTCODE            
                 AND BOOKDATE = @BOOKDATE            
                 AND AMOUNT = ABS(@AMOUNT)            
                 AND DRCR = @DRCR            
                 AND VALUEDATE = @VALUEDATE            
                 AND ISNULL(REFERENCENO,'0') = ISNULL(@REFERENCENO,'0')            
        END            
                    
      /* NEW LOGIC TO UPLOAD THE SAME BOOKDATED BANK STATEMENT MULTIPLE TIMES */            
      SELECT @@CROSSREFERENCENO = MIN(CROSSREFERENCENO)            
      FROM   #BANKRECOSAVE            
      WHERE  [DESCRIPTION] = @DESCRIPTION            
             AND AMOUNT = ABS(@AMOUNT)            
             AND DRCR = @DRCR            
             AND ISNULL(REFERENCENO,'0') = ISNULL(@REFERENCENO,'0')            
             AND AMOUNT > 0            
                                      
      DELETE BR            
      FROM   #BANKRECOSAVE BR            
      WHERE  BR.CROSSREFERENCENO = @@CROSSREFERENCENO            
                                               
      IF @PROCESS_STATUS = 0            
        BEGIN            
          SELECT @@EXIST_COUNT_AFTER = COUNT(1)            
          FROM   #BANKRECOSAVE            
          WHERE  [DESCRIPTION] = @DESCRIPTION            
                 AND AMOUNT = ABS(@AMOUNT)            
                 AND DRCR = @DRCR            
                 AND ISNULL(REFERENCENO,'0') = ISNULL(@REFERENCENO,'0')            
                 AND AMOUNT > 0            
                                          
          IF @@EXIST_COUNT_BEFORE <> @@EXIST_COUNT_AFTER            
            BEGIN            
              INSERT INTO #RECODUPS            
              SELECT BOOKDATE = CONVERT(VARCHAR(11),BR.BOOKDATE,103),            
                     BR.REFERENCENO,          
                     BR.AMOUNT,            
                     BR.[DESCRIPTION],            
                     BR.STATUS,            
                     BR.CROSSREFERENCENO            
              FROM   (SELECT *            
                      FROM   BANKRECO WITH(NOLOCK)            
                      WHERE  BOOKDATE BETWEEN @@BOOKDATE_MIN AND @@BOOKDATE_MAX + ' 23:59'            
                             AND CLTCODE = @BANKCODE) BR            
              WHERE  CLTCODE = @CLTCODE            
                     AND BOOKDATE = @BOOKDATE            
                     AND AMOUNT = ABS(@AMOUNT)            
                     AND DRCR = @DRCR            
                     AND VALUEDATE = @VALUEDATE            
                     AND ISNULL(REFERENCENO,'0') = ISNULL(@REFERENCENO,'0')            
            END            
                        
          SET @@EXIST_COUNT_BEFORE = 0            
                                                 
          SET @@EXIST_COUNT_AFTER = 0            
        END            
                    
      FETCH NEXT FROM CUR_CHECCK            
      INTO @CLTCODE,            
           @BOOKDATE,            
           @AMOUNT,            
           @DRCR,            
           @VALUEDATE,            
           @REFERENCENO,            
           @DESCRIPTION            
    END            
                
  DELETE FROM #BANKRECOSAVE            
  WHERE       AMOUNT < 0            
                                   
  SELECT @@ERROR_COUNT = COUNT(1)            
  FROM   #RECODUPS            
                     
  IF @@ERROR_COUNT > 0            
    BEGIN            
      SELECT *            
      FROM   #RECODUPS            
                         
      RETURN            
    END            
                
  /* NEW LOGIC TO UPLOAD THE SAME BOOKDATED BANK STATEMENT MULTIPLE TIMES */            
  DELETE BR            
  FROM   BANKRECO B WITH(ROWLOCK),            
         #BANKRECOSAVE BR            
  WHERE  LTRIM(RTRIM(B.CLTCODE)) = LTRIM(RTRIM(BR.CLTCODE))            
         AND CONVERT(VARCHAR(11),B.BOOKDATE,109) = CONVERT(VARCHAR(11),BR.BOOKDATE,109)            
         AND LTRIM(RTRIM(B.[DESCRIPTION])) = LTRIM(RTRIM(BR.[DESCRIPTION]))            
         AND B.AMOUNT = BR.AMOUNT            
         AND LTRIM(RTRIM(B.DRCR)) = LTRIM(RTRIM(BR.DRCR))            
         AND CONVERT(VARCHAR(11),B.VALUEDATE,109) = CONVERT(VARCHAR(11),BR.VALUEDATE,109)            
         AND ISNULL(LTRIM(RTRIM(B.REFERENCENO)),'') = ISNULL(LTRIM(RTRIM(BR.REFERENCENO)),'')            
                                                                  
  SELECT @@ERROR_COUNT = COUNT(1)            
  FROM   #BANKRECOSAVE            
  WHERE  VALUEDATE IS NOT NULL            
                     
  IF @@ERROR_COUNT = 0            
    BEGIN            
      SELECT 'THE FILE YOU ARE TRYING TO UPLOAD IS ALREADY UPLOADED. PLEASE CHECK THE BANK RECONCILATION REPORT.'            
                
      RETURN            
    END            
                
  SELECT @@AMOUNTDIFF = ABS(BR.AMOUNT - BR1.AMOUNT)            
  FROM   (SELECT AMOUNT            
          FROM   #BANKRECOSAVE            
          WHERE  [DESCRIPTION] = 'OPENING BALANCE') BR,        
         (SELECT AMOUNT            
          FROM   #BANKRECOSAVE            
          WHERE  [DESCRIPTION] = 'CLOSING BALANCE') BR1            
                     
  IF @PROCESS_STATUS = 1            
    BEGIN            
      SELECT @@STAMOUNTDIFF = ABS(SUM(AMOUNT))            
      FROM   (SELECT AMOUNT = (CASE DRCR             
                                    WHEN 'D' THEN SUM(AMOUNT)            
                                    ELSE -SUM(AMOUNT)            
                                  END)            
              FROM   BANKRECO B WITH (NOLOCK)            
              WHERE  BOOKDATE BETWEEN @@BOOKDATE_MIN AND @@BOOKDATE_MAX            
                     AND CLTCODE = @BANKCODE            
                     AND NOT EXISTS (SELECT CROSSNO            
                                                  FROM   RECODUPS1 R WHERE R.CROSSNO = B.CROSSREFERENCENO)            
              GROUP BY DRCR             
              UNION ALL            
              SELECT AMOUNT = (CASE DRCR             
                                    WHEN 'D' THEN SUM(AMOUNT)            
                                    ELSE -SUM(AMOUNT)            
                                  END)            
              FROM   #BANKRECOSAVE            
              WHERE  VALUEDATE IS NOT NULL            
              GROUP BY DRCR) B            
 END            
  ELSE            
    BEGIN            
      SELECT @@STAMOUNTDIFF = ABS(SUM(AMOUNT))            
      FROM   (SELECT AMOUNT = (CASE DRCR             
 WHEN 'D' THEN SUM(AMOUNT)            
                                    ELSE -SUM(AMOUNT)            
                                  END)            
              FROM   BANKRECO B WITH (NOLOCK)            
              WHERE  BOOKDATE BETWEEN @@BOOKDATE_MIN AND @@BOOKDATE_MAX            
                     AND CLTCODE = @BANKCODE            
              GROUP BY DRCR             
              UNION ALL            
              SELECT AMOUNT = (CASE DRCR             
                                    WHEN 'D' THEN SUM(AMOUNT)            
                                    ELSE -SUM(AMOUNT)            
                                  END)            
              FROM   #BANKRECOSAVE            
              WHERE  VALUEDATE IS NOT NULL            
              GROUP BY DRCR) B            
    END            
                
  IF @@AMOUNTDIFF <> @@STAMOUNTDIFF            
    BEGIN            
      SELECT 'THERE IS SOME AMOUNT DIFFERENCE IN THE STATEMENT WHICH YOU ARE TRYING TO UOLOAD. PLEASE CHECK.'            
                         
      RETURN            
    END            
                
  DELETE FROM #BANKRECOSAVE            
  WHERE       VALUEDATE IS NULL            
                          
  /* NEW LOGIC TO UPLOAD THE SAME BOOKDATED BANK STATEMENT MULTIPLE TIMES */            
  SET @@TABLE_EXIST = ''      
                               
  SELECT @@TABLE_EXIST = NAME            
  FROM   SYSOBJECTS            
  WHERE  NAME = 'RECOPROCESS'            
                            
  IF @@TABLE_EXIST = ''            
    BEGIN            
      CREATE TABLE RECOPROCESS (            
        INPROCESS VARCHAR(1))            
                  
      INSERT INTO RECOPROCESS            
                 (INPROCESS)            
      VALUES     ('N')            
    END            
                
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED            
              
    SELECT @@RECORD_COUNT = COUNT(* )            
  FROM   RECOPROCESS            
                     
  IF @@RECORD_COUNT = 0            
    BEGIN            
      INSERT INTO RECOPROCESS            
                 (INPROCESS)            
      VALUES     ('N')            
    END            
                
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED            
              
  SELECT TOP 1 @@RECO_STATUS = INPROCESS            
  FROM   RECOPROCESS WITH (NOLOCK)            
                     
  IF @@RECO_STATUS = 'N'            
    BEGIN            
      BEGIN TRAN            
                  
      UPDATE RECOPROCESS            
      SET    INPROCESS = 'Y'            
    END            
  ELSE            
    BEGIN            
      SELECT 'BANK RECO UPLOAD PROCESS IS ALREADY RUNNING FROM SOME OTHER TERMINAL. PLEASE TRY AGAIN LATER.'            
                         
      RETURN            
    END            
                
  INSERT INTO V2_UPLOADED_FILES            
  SELECT @FILENAME,            
         @FILENAME,            
         COUNT(1),            
         'B',            
         GETDATE(),            
         @UNAME,            
         'HDFC_RECO UPLOAD'            
                     
  UPDATE #BANKRECOSAVE            
  SET    STATUS = 'MATCHED',             
         L1_SNO = LEDGER1.L1_SNO,             
         VTYP = LEDGER1.VTYP,             
         BOOKTYPE = LEDGER1.BOOKTYPE,             
         VNO = LEDGER1.VNO             
  FROM   LEDGER1 WITH (NOLOCK)            
  WHERE  (LEDGER1.VTYP = 2            
           OR LEDGER1.VTYP = 3            
           OR LEDGER1.VTYP = 5            
           OR LEDGER1.VTYP = 17            
           OR LEDGER1.VTYP = 19            
           OR LEDGER1.VTYP = 20)            
         AND UPPER(#BANKRECOSAVE.DRCR) = UPPER(LEDGER1.DRCR)            
         AND RTRIM(DDNO) = RTRIM(REFERENCENO)            
         AND CLTCODE = @BANKCODE            
         AND #BANKRECOSAVE.MICRNO = @@MICRNO          
         AND LEDGER1.RELDT = ''        
   AND #BANKRECOSAVE.AMOUNT = LEDGER1.RELAMT      
         AND #BANKRECOSAVE.AMOUNT = (SELECT SUM(RELAMT)            
                                     FROM   LEDGER1 L1 WITH(NOLOCK),            
                                            LEDGER L2 WITH(NOLOCK)            
                                     WHERE  L2.VNO = L1.VNO            
                                            AND L2.VTYP = L1.VTYP            
                                            AND L2.BOOKTYPE = L1.BOOKTYPE            
                                            AND RELDT = ''            
                                            AND CLTCODE = @BANKCODE            
                                            AND #BANKRECOSAVE.REFERENCENO = DDNO            
                                            AND #BANKRECOSAVE.DRCR = L1.DRCR            
                                            AND CONVERT(DATETIME, CONVERT(VARCHAR(11),#BANKRECOSAVE.VALUEDATE,101)) >= CONVERT(DATETIME, CONVERT(VARCHAR(11),VDT,101)))            
         AND #BANKRECOSAVE.MICRNO = ISNULL(LEDGER1.MICRNO,0)            
         AND REFERENCENO <> '0'            
                                        
  IF @@ERROR <> 0            
    BEGIN            
      SELECT 'THERE IS SOME PROBLEM IN BANKRECO UPDATES 1'            
                         
      ROLLBACK TRAN            
                  
      RETURN            
    END            
                
  IF @@ERROR <> 0            
    BEGIN            
      SELECT 'THERE IS SOME PROBLEM IN LEDGER UPDATES 1'            
                         
      ROLLBACK TRAN            
        
      RETURN            
    END            
            
  UPDATE LEDGER1 WITH (ROWLOCK)            
  SET    RELDT = VALUEDATE,            
         REFNO = #BANKRECOSAVE.CROSSREFERENCENO            
  FROM   #BANKRECOSAVE              
  WHERE  #BANKRECOSAVE.L1_SNO <> 0             
         AND LEDGER1.L1_SNO = #BANKRECOSAVE.L1_SNO             
            
                                                                
  IF @@ERROR <> 0            
    BEGIN            
      SELECT 'THERE IS SOME PROBLEM IN LEDGER1 UPDATES 1'            
                         
      ROLLBACK TRAN            
                  
      RETURN            
    END            
                
  UPDATE #BANKRECOSAVE            
  SET    AMOUNTLEDGR1 = BANKRECOCOMP.AMOUNT,            
         STATUS = 'MATCHED',             
         SLIPNO = BANKRECOCOMP.SLIPNO             
  FROM   (SELECT   SUM(RELAMT)   AS AMOUNT,            
                   SLIPNO        AS SLIPNO,            
                   UPPER(DRCR)   AS DRCR,            
                   MICRNO            
          FROM     LEDGER1 WITH(NOLOCK)            
          WHERE    MICRNO = @@MICRNO            
                   AND (VTYP = 2            
                         OR VTYP = 19            
                         OR VTYP = 5)            
                   AND SLIPNO <> ''            
                   AND RELDT = ''             
          GROUP BY SLIPNO,DRCR,MICRNO) BANKRECOCOMP            
  WHERE  UPPER(#BANKRECOSAVE.DRCR) = UPPER(BANKRECOCOMP.DRCR)            
         AND RTRIM(BANKRECOCOMP.SLIPNO) = RTRIM(REFERENCENO)            
         AND #BANKRECOSAVE.MICRNO = @@MICRNO            
         AND #BANKRECOSAVE.AMOUNT = BANKRECOCOMP.AMOUNT            
   AND #BANKRECOSAVE.MICRNO = BANKRECOCOMP.MICRNO            
         AND REFERENCENO <> '0'            
                                        
  IF @@ERROR <> 0            
    BEGIN            
      SELECT 'THERE IS SOME PROBLEM IN BANKRECO UPDATES 2'            
                         
      ROLLBACK TRAN            
                  
      RETURN            
    END            
            
  SELECT L1.VTYP,             
         L1.BOOKTYPE,             
         L1.VNO,             
         L1.L1_SNO,             
         #BANKRECOSAVE.VALUEDATE,             
         #BANKRECOSAVE.CROSSREFERENCENO             
  INTO   #LEDGER_UPDATES_FOR_SLIPS             
  FROM   #BANKRECOSAVE,             
         LEDGER1 L1 WITH(NOLOCK)      
  WHERE  L1.MICRNO = @@MICRNO               
         AND L1.SLIPNO = #BANKRECOSAVE.SLIPNO             
         AND #BANKRECOSAVE.SLIPNO <> 0             
            
  IF @@ERROR <> 0            
    BEGIN            
      SELECT 'THERE IS SOME PROBLEM IN LEDGER UPDATES 2'            
                         
      ROLLBACK TRAN            
                  
      RETURN            
    END            
                
  UPDATE LEDGER1 WITH (ROWLOCK)            
  SET    RELDT = VALUEDATE,            
         REFNO = #LEDGER_UPDATES_FOR_SLIPS.CROSSREFERENCENO            
  FROM   #LEDGER_UPDATES_FOR_SLIPS            
  WHERE  #LEDGER_UPDATES_FOR_SLIPS.L1_SNO <> 0             
         AND LEDGER1.L1_SNO = #LEDGER_UPDATES_FOR_SLIPS.L1_SNO             
                                          
  IF @@ERROR <> 0            
    BEGIN            
      SELECT 'THERE IS SOME PROBLEM IN LEDGER1 UPDATES 2'            
                         
      ROLLBACK TRAN            
                  
      RETURN            
    END            
                
  UPDATE L            
  SET    EDT = (CASE             
                  WHEN CONVERT(DATETIME,(CONVERT(VARCHAR(11),VALUEDATE,109))) < CONVERT(DATETIME,(CONVERT(VARCHAR(11),VDT,109))) THEN VDT            
                  ELSE VALUEDATE            
                END)            
  FROM   LEDGER L WITH (ROWLOCK),            
         (SELECT VTYP,            
                 BOOKTYPE,            
                 VNO,            
                 VALUEDATE            
          FROM   #BANKRECOSAVE            
          WHERE  VNO <> ''            
          UNION             
          SELECT VTYP,            
                 BOOKTYPE,            
                 VNO,            
   VALUEDATE            
          FROM   #LEDGER_UPDATES_FOR_SLIPS            
          WHERE  VNO <> '') LU            
  WHERE  LU.VNO = L.VNO            
         AND LU.VTYP = L.VTYP            
         AND LU.BOOKTYPE = L.BOOKTYPE            
         AND EDT LIKE 'DEC 31 2049%'            
                                  
  IF @@ERROR <> 0            
    BEGIN            
      SELECT 'THERE IS SOME PROBLEM IN LEDGER UPDATES EDT'            
                         
      ROLLBACK TRAN            
                  
      RETURN            
    END            
                
  IF @@ERROR <> 0            
    BEGIN            
      SELECT 'THERE IS SOME PROBLEM IN LEDGER UPDATES EDT 2'            
                         
      ROLLBACK TRAN            
                  
      RETURN            
    END            
                
  IF @PROCESS_STATUS = 1            
    BEGIN            
      DELETE FROM BANKRECO WITH (ROWLOCK)            
      WHERE       CLTCODE = @BANKCODE            
                  AND CROSSREFERENCENO IN (SELECT CROSSNO            
                                           FROM   RECODUPS1)            
    END            
                
  INSERT INTO BANKRECO            
             (CLTCODE,            
              BOOKDATE,            
              DESCRIPTION,            
              AMOUNT,            
              DRCR,            
              VALUEDATE,            
              REFERENCENO,            
              STATUSID,            
              STATUSNAME,            
              LOGINNAME,            
              CROSSREFERENCENO,            
              STATUS,            
              MICRNO,            
              DUMMY1,            
              DUMMY2)            
  SELECT B.CLTCODE,            
         B.BOOKDATE,            
         B.DESCRIPTION,            
         B.AMOUNT,            
         B.DRCR,            
         B.VALUEDATE,            
         B.REFERENCENO,            
         B.STATUSID,            
         B.STATUSNAME,         
         B.LOGINNAME,            
         B.CROSSREFERENCENO,            
         B.STATUS,            
         @@MICRNO,            
         '0',            
         '0'            
  FROM   #BANKRECOSAVE B            
                     
  INSERT INTO BANKRECO_LOG            
  SELECT B.CLTCODE,            
         B.BOOKDATE,            
         B.DESCRIPTION,            
         B.AMOUNT,            
         B.DRCR,            
         B.VALUEDATE,            
         B.REFERENCENO,            
         B.STATUSID,            
         B.STATUSNAME,            
         B.LOGINNAME,            
         B.CROSSREFERENCENO,            
         B.STATUS,            
         @@MICRNO,            
         '0',            
         '0',            
         0,     
   0,           
         'AUTO',            
         GETDATE(),            
         'MATCHED'            
  FROM   #BANKRECOSAVE B            
  WHERE  B.STATUS = 'MATCHED'            
                                
  INSERT INTO LEDGER1_BANKRECO_LOG            
  SELECT L1.*,            
         'AUTO',            
         GETDATE(),            
         'MATCHED'            
  FROM   LEDGER1 L1 WITH (NOLOCK),            
         (SELECT VTYP,            
                 BOOKTYPE,            
                 VNO            
          FROM   #BANKRECOSAVE            
          WHERE  VNO <> ''            
          UNION             
          SELECT VTYP,            
                 BOOKTYPE,            
                 VNO            
          FROM   #LEDGER_UPDATES_FOR_SLIPS            
          WHERE  VNO <> '') LU            
  WHERE  L1.VNO = LU.VNO            
         AND L1.VTYP = LU.VTYP            
         AND L1.BOOKTYPE = LU.BOOKTYPE            
                                       
  UPDATE RECOPROCESS            
  SET    INPROCESS = 'N'            
                                 
  COMMIT TRAN            
              
  SELECT 'UPDATED SUCCESSFULLY.'

GO
