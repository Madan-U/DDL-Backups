-- Object: PROCEDURE dbo.InsertToLedger2
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE proc INSERTTOLEDGER2                         
(                      
      @SESSIONID VARCHAR(15),                        
      @VNO VARCHAR(12),                        
      @BRANCHFLAG TINYINT,                        
      @COSTCENTERFLAG TINYINT,                        
      @COSTENABLE CHAR(1),                        
      @STATUSID AS VARCHAR(30),                        
      @STATUSNAME AS VARCHAR(30)                        
)                       
                      
AS                        
                      
SET NOCOUNT ON                      
                      
DECLARE                        
      @@ONLYALL TINYINT,                        
      @@ONEBRANCH TINYINT,                        
      @@MULTIBRANCH TINYINT,                        
      @@ONEBRANCHALL TINYINT,                        
      @@MULTIBRANCHALL TINYINT,                        
      @@ALLCOUNT SMALLINT,                        
      @@BRANCHCOUNT SMALLINT,                        
      @@OLDBRANCH VARCHAR(10),                        
      @@VTYPE VARCHAR(2),                        
      @@PARTY2 VARCHAR(10),                        
      @@COSTBREAKUP TINYINT,                        
      @@COSTCODE1 INT,                        
                        
/*=======================================================================================                      
      FIELDS RETRIVED FROM TEMPLEDGER2                       
=======================================================================================*/                      
      @@CATEGORY VARCHAR(20),                        
      @@BRANCH VARCHAR(25),                        
      @@AMT    MONEY,                        
      @@VTYP VARCHAR(2),                        
      @@VNO  VARCHAR(12),                        
      @@LNO  INT,                        
      @@DRCR CHAR(1),                        
      @@COSTCODE SMALLINT,                        
      @@BOOKTYPE VARCHAR(2),                        
      @@SESSIONID VARCHAR(25),                        
      @@PARTY_CODE VARCHAR(10),                        
      @@MAINBR AS VARCHAR(10),                           
      @@RCURSOR AS CURSOR                        
                        
IF @BRANCHFLAG = 1 AND @COSTCENTERFLAG  = 1                        
BEGIN                        
/*=======================================================================================                      
      0 = TRUE   1 = FALSE                          
=======================================================================================*/                      
      SELECT @@ONLYALL = 0               /* TRUE */                        
      SELECT @@ONEBRANCH = 1             /* TRUE */                        
      SELECT @@MULTIBRANCH = 1           /* FALSE */                        
      SELECT @@ONEBRANCHALL = 1          /* FALSE */                        
      SELECT @@MULTIBRANCHALL = 1        /* FALSE */                        
                              
      SELECT @@ALLCOUNT = 0                        
      SELECT @@BRANCHCOUNT = 0                        
      SELECT @@OLDBRANCH = ''                        
                        
      SELECT @@MAINBR =                       
                  (                      
                        SELECT                       
                              BRANCHNAME                       
                        FROM BRANCHACCOUNTS                       
                        WHERE DEFAULTAC = 1                      
                  )                       
                        
      SELECT @@VTYPE =                       
                  (                      
                        SELECT DISTINCT                       
                              VTYPE                       
                        FROM TEMPLEDGER2                       
                        WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                              AND VNO = @VNO                      
                  )                       
                           
      SELECT @@COSTBREAKUP =                       
                  (                                            SELECT                       
                              COUNT(*)                       
                        FROM TEMPLEDGER2                 
                        WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                              AND CATEGORY = 'BRANCH'                       
                           AND VNO = @VNO                       
                              AND COSTFLAG = 'C'                      
                  )                       
                        
/*=======================================================================================                      
            IF @@VTYPE = 8 AND @@COSTBREAKUP > 0                        
      =======================================================================================*/                      
      IF @@COSTBREAKUP > 0                        
      BEGIN                        
            DELETE                       
   T1              
            FROM TEMPLEDGER2 T1                       
            WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
--                  AND UPPER(RTRIM(BRANCH)) = 'ALL'                       
                  AND VNO = @VNO                       
                  AND COSTFLAG = 'A'                       
                  AND EXISTS                       
                        (                       
                              SELECT DISTINCT                       
                    PARTY_CODE                       
                              FROM TEMPLEDGER2 T2              
                              WHERE COSTFLAG = 'C'                       
    AND T1.PARTY_CODE = T2.PARTY_CODE              
    AND T1.LNO = T2.LNO            
                        )                       
    --IF @@VTYPE <> 3 AND @@VTYPE <> 8                        
            UPDATE                       
     TEMPLEDGER2                       
                  SET COSTFLAG = 'A'             
          
    /*IF @@VTYPE = 8                 
    BEGIN          
   UPDATE TEMPLEDGER2 SET COSTFLAG = 'C', COSTCODE = C.COSTCODE          
   FROM COSTMAST C, ACMAST A          
   WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID) AND VNO = @VNO AND COSTFLAG = 'A' AND UPPER(RTRIM(BRANCH)) <> 'ALL'  
   AND TEMPLEDGER2.PARTY_CODE = A.CLTCODE AND BRANCHCODE <> 'ALL'  
   AND UPPER(RTRIM(TEMPLEDGER2.BRANCH)) = UPPER(RTRIM(COSTNAME))          
    END        */  
                  
     IF @@VTYPE = 5 OR @@VTYPE = 6 OR @@VTYPE = 7 OR @@VTYPE = 8 OR @@VTYPE = 24                        
     BEGIN                        
           UPDATE                       
                 TEMPLEDGER2                       
                 SET BRANCH = 'HO'                       
           WHERE UPPER(RTRIM(BRANCH)) = 'ALL'                       
                 AND COSTFLAG = 'A'                      
   AND VNO = @VNO                     
     END                        
      END                        
                        
      SET @@RCURSOR = CURSOR FOR                        
            SELECT                       
                  CATEGORY,                      
                  BRANCH,                      
                  PAIDAMT,                      
                  VTYPE,                      
                  VNO,                      
                  LNO,                      
                  DRCR,                      
                  COSTCODE,                      
                  BOOKTYPE,                      
                  SESSIONID,                      
                  PARTY_CODE                       
            FROM TEMPLEDGER2                       
            WHERE CATEGORY = 'BRANCH'                       
                  AND RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                  AND VNO =@VNO               
                  AND COSTFLAG = 'A'                       
      OPEN @@RCURSOR                        
      FETCH NEXT FROM @@RCURSOR                         
      INTO @@CATEGORY, @@BRANCH, @@AMT, @@VTYP, @@VNO, @@LNO, @@DRCR, @@COSTCODE, @@BOOKTYPE, @@SESSIONID , @@PARTY_CODE                         
                        
      WHILE @@FETCH_STATUS = 0                        
      BEGIN                        
            IF RTRIM(@@BRANCH) = 'ALL'                        
            BEGIN                        
                  SELECT @@ALLCOUNT = @@ALLCOUNT + 1                        
            END                        
            ELSE                    
            IF RTRIM(@@BRANCH) = @@OLDBRANCH                        
            BEGIN                        
                  SELECT @@ONLYALL = 1                        
            END                        
            ELSE                        
            IF @@OLDBRANCH = ''                        
            BEGIN                        
            SELECT @@ONLYALL = 1                        
                  SELECT @@OLDBRANCH = RTRIM(@@BRANCH)                        
                  SELECT @@BRANCHCOUNT = @@BRANCHCOUNT + 1                        
            END                        
            ELSE                         
            BEGIN                        
                  SELECT @@ONLYALL = 1                        
    SELECT @@BRANCHCOUNT = @@BRANCHCOUNT + 1                        
                  SELECT @@MULTIBRANCH = 0                        
                  SELECT @@ONEBRANCH = 1                                   
            END                        
                                  
            FETCH NEXT FROM @@RCURSOR                   
         INTO @@CATEGORY, @@BRANCH, @@AMT, @@VTYP, @@VNO, @@LNO, @@DRCR, @@COSTCODE, @@BOOKTYPE, @@SESSIONID , @@PARTY_CODE                         
      END                        
      CLOSE @@RCURSOR                        
      DEALLOCATE @@RCURSOR                        
                        
/*      SELECT "ALLCOUNT = " + CONVERT(VARCHAR,@@ALLCOUNT)                        
      SELECT "BRANCHCOUNT = " + CONVERT(VARCHAR,@@BRANCHCOUNT)  */                      
                        
      IF @@ONLYALL = 1                        
      BEGIN                        
            IF @@ALLCOUNT = 0                        
            BEGIN                        
                  IF @@BRANCHCOUNT = 1                        
                  BEGIN                        
                        SELECT @@ONEBRANCH = 0                        
                        SELECT @@MULTIBRANCH = 1                        
                        SELECT @@ONEBRANCHALL = 1                        
                        SELECT @@MULTIBRANCHALL = 1                        
                  END                        
                  ELSE                        
                  BEGIN                        
                        SELECT @@MULTIBRANCH = 0                        
                        SELECT @@ONEBRANCH = 1                        
                        SELECT @@ONEBRANCHALL = 1                        
                        SELECT @@MULTIBRANCHALL = 1                        
                  END                        
            END                        
            ELSE                        
            BEGIN                        
                  IF @@BRANCHCOUNT = 1                        
                  BEGIN                        
                        SELECT @@ONEBRANCHALL = 0                        
                        SELECT @@ONEBRANCH = 1                        
                        SELECT @@MULTIBRANCH = 1                        
           SELECT @@MULTIBRANCHALL = 1                        
                  END                        
                  ELSE                        
                  BEGIN                        
                        SELECT @@MULTIBRANCHALL = 0                        
                        SELECT @@ONEBRANCH = 1                        
                        SELECT @@MULTIBRANCH = 1                        
                        SELECT @@ONEBRANCHALL = 1                        
                  END                        
            END                        
      END                       
                        
      IF @@ONLYALL = 0                         
      BEGIN                        
            SELECT      
                  @@VTYPE =                       
                        (                      
                              SELECT DISTINCT                       
                                    VTYPE                       
                              FROM TEMPLEDGER2                       
                              WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                                    AND VNO = @VNO                      
                     )                       
SELECT                       
                  @@PARTY2 =                       
                        (                      
                              SELECT DISTINCT                       
                                    PARTY_CODE                       
                              FROM TEMPLEDGER2                       
                              WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                                    AND UPPER(RTRIM(BRANCH)) = 'ALL'                       
                                    AND VNO = @VNO                       
                                    AND COSTFLAG = 'A'                       
                                    AND LNO = 1                      
                        )                       
            SELECT                       
                  @@COSTBREAKUP =                       
                        (                      
                              SELECT                       
                                    COUNT(*)           
                              FROM TEMPLEDGER2                       
                              WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                                    AND CATEGORY = 'BRANCH'                       
                                    AND VNO = @VNO            
                           AND COSTFLAG = 'C'                      
                        )                       
                            
            IF @@COSTBREAKUP > 0 AND (@@VTYPE = '3' OR @@VTYPE = '4')                         
            BEGIN                        
                  DELETE                       
                  FROM TEMPLEDGER2                       
                  WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                        AND CATEGORY = 'BRANCH'                       
                        AND UPPER(BRANCH) = 'ALL'                       
                  AND VNO = @VNO                       
                        AND COSTFLAG = 'A'                       
                            
              /*    DELETE                       
                  FROM TEMPLEDGER2                       
                  WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                        AND CATEGORY = 'BRANCH'                       
                        AND UPPER(DRCR) = 'C'                       
                        AND VNO = @VNO                       
                        AND COSTFLAG = 'C'             */          
                            
                  INSERT                   
                  INTO TEMPLEDGER2                       
                  SELECT                       
                        CATEGORY,                       
                        BRANCH,                       
                        PAIDAMT,                       
                        VTYPE,                       
                        VNO,      
                        1,                       
                        (                       
                              CASE                       
                                    WHEN DRCR = 'D'                       
                                    THEN 'C'                       
                                    ELSE 'D'                       
                              END                      
                ),                       
                        COSTCODE,                       
                        BOOKTYPE,                       
                        SESSIONID,           
                        @@PARTY2,                       
                        COSTFLAG,                       
                        1                       
                  FROM TEMPLEDGER2                       
                  WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                        AND CATEGORY = 'BRANCH'                       
                        AND VNO = @VNO                       
            END                        
            IF @@COSTBREAKUP > 0 AND (@@VTYPE = '1' OR @@VTYPE = '2' )                        
            BEGIN                        
             DELETE                       
                  FROM TEMPLEDGER2                       
                  WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                        AND CATEGORY = 'BRANCH'                       
                        AND UPPER(BRANCH) = 'ALL'                       
                        AND VNO = @VNO                       
                        AND COSTFLAG = 'A'                       
                            
                  DELETE                       
                  FROM TEMPLEDGER2                       
                  WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
        AND CATEGORY = 'BRANCH'                       
              AND UPPER(DRCR) = 'D'                       
                        AND VNO = @VNO                       
                        AND COSTFLAG = 'C'                       
                            
                  INSERT                       
                  INTO TEMPLEDGER2                       
                  SELECT                       
                        CATEGORY,                       
                        BRANCH,                       
                        PAIDAMT,                       
                        VTYPE,                       
                        VNO,                       
                        1,                       
   (                       
                              CASE                       
                                    WHEN DRCR = 'D'                       
                                    THEN 'C'                       
                                    ELSE 'D'                       
  END                      
                        ),                       
                        COSTCODE,                       
                        BOOKTYPE,                       
                        SESSIONID,                       
                        @@PARTY2,                       
                        COSTFLAG,                       
                        1                       
                  FROM TEMPLEDGER2                       
                  WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                        AND CATEGORY = 'BRANCH'                       
                        AND VNO = @VNO                       
            END                        
      END                        
                        
                        
      IF @@ONLYALL = 0                     
      BEGIN                         
            IF @STATUSID = 'BRANCH'                         
            BEGIN                        
                  INSERT                       
                  INTO LEDGER2                       
           SELECT                       
                        VTYPE,                       
                        VNO,                       
                        LNO,                       
                        DRCR,                       
                        PAIDAMT,                       
                        C.COSTCODE,                       
                        BOOKTYPE,                      
                        UPPER(PARTY_CODE)                       
                  FROM TEMPLEDGER2 T,                       
                        COSTMAST C                       
                  WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                        AND RTRIM(COSTNAME) = RTRIM(@STATUSNAME)       
                        AND CATEGORY = 'BRANCH'                       
                        AND VNO =@VNO                       
                        AND COSTFLAG = 'A'                       
            END                        
            ELSE                        
            BEGIN                        
                  INSERT                       
                  INTO LEDGER2                       
                  SELECT                       
                        VTYPE,                       
                        VNO,                       
                        LNO,                       
                        DRCR,                       
                        PAIDAMT,                       
                        C.COSTCODE,        
                        BOOKTYPE,                      
                        UPPER(PARTY_CODE)                       
     FROM TEMPLEDGER2 T,                       
                        BRANCHACCOUNTS B,                       
                        COSTMAST C                       
                  WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                        AND DEFAULTAC = 1                       
                        AND RTRIM(BRANCHNAME) = RTRIM(COSTNAME)                       
                        AND CATEGORY = 'BRANCH'                       
                        AND VNO =@VNO                       
                        AND COSTFLAG = 'A'                       
            END                        
      END                        
      ELSE                        
      IF @@ONEBRANCH = 0                        
      BEGIN                        
            INSERT                       
            INTO LEDGER2                       
            SELECT                       
                  VTYPE,                       
                  VNO,                       
                  LNO,                       
            DRCR,                       
                  PAIDAMT,                       
                  C.COSTCODE,                       
                  BOOKTYPE,                       
                  UPPER(PARTY_CODE )                       
            FROM TEMPLEDGER2 T,                       
                  COSTMAST C                       
            WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                  AND RTRIM(BRANCH) = RTRIM(COSTNAME)                       
                  AND CATEGORY = 'BRANCH'                       
  AND VNO =@VNO                       
                 AND COSTFLAG = 'A'                       
      END                        
      ELSE                        
      IF @@MULTIBRANCH = 0                        
      BEGIN                        
            INSERT                       
       INTO LEDGER2                       
            SELECT                       
                  VTYPE,                       
                  VNO,                       
                  LNO,                       
                  DRCR,                       
                  PAIDAMT,                       
          C.COSTCODE,                       
              BOOKTYPE,                       
                  UPPER(PARTY_CODE)            
            FROM TEMPLEDGER2 T,                       
                  COSTMAST C                       
            WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                  AND RTRIM(BRANCH) = RTRIM(COSTNAME)                       
                  AND CATEGORY = 'BRANCH'                       
                  AND VNO =@VNO                       
                  AND COSTFLAG = 'A'                       
                            
            INSERT                       
            INTO LEDGER2                       
            SELECT                       
                  VTYPE,                       
                  VNO,                       
                  LNO,                       
                  DRCR,                       
                  PAIDAMT,                       
                  COSTCODE=                       
 (                       
                              SELECT                       
                                    COSTCODE                       
                              FROM COSTMAST C,                       
                                    BRANCHACCOUNTS B                       
                    WHERE DEFAULTAC = 1                       
                                    AND RTRIM(BRANCHNAME) = RTRIM(COSTNAME)                      
                        ),                       
                  BOOKTYPE,                       
                  UPPER(BRCONTROLAC)                       
            FROM TEMPLEDGER2 T,                       
                  BRANCHACCOUNTS B                       
            WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                  AND RTRIM(BRANCH) = RTRIM(BRANCHNAME)                       
                  AND CATEGORY = 'BRANCH'                 
                  AND VNO =@VNO                       
                  AND COSTFLAG = 'A'                       
                  AND RTRIM(BRANCH) <> RTRIM(@@MAINBR)                       
                            
            INSERT                       
            INTO LEDGER2                       
            SELECT                       
                  VTYPE,                       
                  VNO,                       
                  LNO,                       
                  (                       
                        CASE                       
                              WHEN DRCR= 'D'                       
                              OR DRCR = 'D'                       
                              THEN 'C'                       
                              ELSE 'D'                       
                        END                      
                  ),                       
                  PAIDAMT,                       
                  C.COSTCODE,                       
              BOOKTYPE,                       
                  UPPER(MAINCONTROLAC)                       
            FROM TEMPLEDGER2 T,                       
                COSTMAST C,                       
                  BRANCHACCOUNTS B                       
            WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                  AND RTRIM(BRANCH) = RTRIM(COSTNAME)                       
                  AND RTRIM(BRANCHNAME) = RTRIM(BRANCH)                       
                  AND CATEGORY = 'BRANCH'                       
                  AND VNO =@VNO                       
                  AND COSTFLAG = 'A'                       
                  AND RTRIM(BRANCH) <> RTRIM(@@MAINBR)                       
      END                        
      ELSE                        
      IF @@ONEBRANCHALL = 0                         
      BEGIN                        
      SET @@RCURSOR = CURSOR FOR                        
            SELECT                       
                  BRANCH                       
            FROM TEMPLEDGER2                    
            WHERE CATEGORY = 'BRANCH'      
                  AND RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                  AND VNO = @VNO                       
                  AND BRANCH <> 'ALL'                       
      AND COSTFLAG = 'A'                
            ORDER BY BRANCH                    
            OPEN @@RCURSOR                        
            FETCH NEXT FROM @@RCURSOR INTO @@BRANCH                         
            WHILE @@FETCH_STATUS = 0                        
            BEGIN                        
            SELECT @@COSTCODE1 =                       
                        (                       
                              SELECT                       
                                    COSTCODE                       
                              FROM COSTMAST                       
                              WHERE RTRIM(@@BRANCH) = RTRIM(COSTNAME)                      
                        )                       
                  FETCH NEXT FROM @@RCURSOR INTO @@BRANCH                         
                  END                        
                  CLOSE @@RCURSOR                        
                  DEALLOCATE @@RCURSOR                        
                                  
                  INSERT                       
                  INTO LEDGER2                       
                  SELECT                       
                        VTYPE,                       
               VNO,                       
                        LNO,                       
                        DRCR,                       
                        PAIDAMT,                       
                        C.COSTCODE,                       
             BOOKTYPE,                       
          UPPER(PARTY_CODE)                       
                  FROM TEMPLEDGER2 T,                       
                        COSTMAST C                       
                  WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                        AND RTRIM(BRANCH) = RTRIM(COSTNAME)                       
                        AND CATEGORY = 'BRANCH'                  
                        AND VNO =@VNO                       
                        AND COSTFLAG = 'A'                       
                                  
                  INSERT                       
                  INTO LEDGER2                       
                  SELECT                       
                        VTYPE,                       
                        VNO,                       
                        LNO,                       
                        DRCR,                       
                        PAIDAMT,                       
                        @@COSTCODE1,                       
              BOOKTYPE,                       
                        UPPER(PARTY_CODE)                       
                  FROM TEMPLEDGER2 T                       
                  WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                        AND RTRIM(BRANCH) = 'ALL'                       
                        AND CATEGORY = 'BRANCH'                       
                        AND VNO =@VNO                       
AND COSTFLAG = 'A'                       
            END                        
      END         
                        
      IF @COSTCENTERFLAG  = 1                        
      BEGIN                        
            INSERT                       
            INTO LEDGER2                       
            SELECT                       
                  VTYPE,                       
                  @VNO,                       
                  LNO,                       
                  DRCR,                       
                  PAIDAMT,                       
                  COSTCODE,                       
                  BOOKTYPE,                      
                  UPPER(PARTY_CODE )                       
            FROM TEMPLEDGER2 T                       
     WHERE RTRIM(SESSIONID) = RTRIM(@SESSIONID)                       
                  AND VNO = @VNO                       
                  AND COSTFLAG = 'C'                       
      END

GO
