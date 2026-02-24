-- Object: PROCEDURE dbo.V2_EQUITY_FOUT_BALANCES_UP
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE PROC [dbo].[V2_EQUITY_FOUT_BALANCES_UP](                       
          @UNAME VARCHAR(20) = 'PROCESS',              
          @BALDATE VARCHAR(11) = '')                       
                      
AS                       
                
  IF @BALDATE = ''              
  BEGIN              
    SELECT @BALDATE = LEFT(GETDATE(),11)              
  END                
                
  TRUNCATE TABLE NSEFO_TBL_CLIENTMARGIN               
  TRUNCATE TABLE BSEFO_TBL_CLIENTMARGIN               
  TRUNCATE TABLE NSECURFO_TBL_CLIENTMARGIN
              
  INSERT INTO NSEFO_TBL_CLIENTMARGIN               
  EXEC NSEFO.DBO.CLIENTMARGIN_GET @BALDATE              
              
  INSERT INTO BSEFO_TBL_CLIENTMARGIN               
  EXEC BSEFO.DBO.CLIENTMARGIN_GET @BALDATE              

  INSERT INTO NSECURFO_TBL_CLIENTMARGIN               
  EXEC NSECURFO.DBO.CLIENTMARGIN_GET @BALDATE              
                  
  TRUNCATE TABLE V2_EQUITY_FOUT_BALANCES                       
                        
  INSERT INTO V2_EQUITY_FOUT_BALANCES                      
  SELECT PARTY_CODE,                      
         BILLAMOUNT,                      
         LEDGERAMOUNT,                      
         CASH_COLL,                      
         NONCASH_COLL,                      
         INITIALMARGIN,                      
         MTMMARGIN,                      
         ADDMARGIN,                       
         0,0,0,0,0,0,0,                      
         0,0,0,0,0,0,0, 
		 0,0,0,0,0,0,0,                     
         0,0,0,0,0,0,0,                      
         0,0,                       
         @UNAME,                       
         GETDATE()                       
  FROM   NSEFO_TBL_CLIENTMARGIN                      
                        
  UPDATE V2_EQUITY_FOUT_BALANCES                       
  SET    BF_BILLAMOUNT = BILLAMOUNT,                      
         BF_LEDGERAMOUNT = LEDGERAMOUNT,                      
         BF_CASH_COLL = CASH_COLL,                      
         BF_NONCASH_COLL = NONCASH_COLL,                      
         BF_INITIALMARGIN = INITIALMARGIN,                      
         BF_MTMMARGIN = MTMMARGIN,                      
         BF_ADDMARGIN = ADDMARGIN,                       
         CREATEDATE = GETDATE()                       
  FROM   BSEFO_TBL_CLIENTMARGIN N                       
  WHERE  V2_EQUITY_FOUT_BALANCES.PARTY_CODE = N.PARTY_CODE                       
                        
  INSERT INTO V2_EQUITY_FOUT_BALANCES                      
  SELECT PARTY_CODE,                      
         0,0,0,0,0,0,0,                      
         BILLAMOUNT,                      
         LEDGERAMOUNT,                      
         CASH_COLL,                      
         NONCASH_COLL,                      
         INITIALMARGIN,                      
         MTMMARGIN,                      
         ADDMARGIN,                       
		 0,0,0,0,0,0,0, 
         0,0,0,0,0,0,0,                      
         0,0,0,0,0,0,0,                      
         0,0,                       
         @UNAME,                       
         GETDATE()                       
  FROM   BSEFO_TBL_CLIENTMARGIN N                      
  WHERE  NOT EXISTS (SELECT PARTY_CODE                       
                     FROM   V2_EQUITY_FOUT_BALANCES F                       
                     WHERE  N.PARTY_CODE = F.PARTY_CODE)                      

UPDATE V2_EQUITY_FOUT_BALANCES                       
  SET    NX_BILLAMOUNT = BILLAMOUNT,                      
         NX_LEDGERAMOUNT = LEDGERAMOUNT,                      
         NX_CASH_COLL = CASH_COLL,                      
         NX_NONCASH_COLL = NONCASH_COLL,                      
         NX_INITIALMARGIN = INITIALMARGIN,                      
         NX_MTMMARGIN = MTMMARGIN,                      
         NX_ADDMARGIN = ADDMARGIN,                       
         CREATEDATE = GETDATE()                       
  FROM   BSEFO_TBL_CLIENTMARGIN N                       
  WHERE  V2_EQUITY_FOUT_BALANCES.PARTY_CODE = N.PARTY_CODE                       
                        
  INSERT INTO V2_EQUITY_FOUT_BALANCES                      
  SELECT PARTY_CODE,                      
         0,0,0,0,0,0,0,
		 0,0,0,0,0,0,0,                       
         BILLAMOUNT,                      
         LEDGERAMOUNT,                      
         CASH_COLL,                      
         NONCASH_COLL,                      
         INITIALMARGIN,                      
         MTMMARGIN,                      
         ADDMARGIN,                       
         0,0,0,0,0,0,0,                      
         0,0,0,0,0,0,0,                      
         0,0,                       
         @UNAME,                       
         GETDATE()                       
  FROM   BSEFO_TBL_CLIENTMARGIN N                      
  WHERE  NOT EXISTS (SELECT PARTY_CODE                       
                     FROM   V2_EQUITY_FOUT_BALANCES F                       
                     WHERE  N.PARTY_CODE = F.PARTY_CODE)   
                        
  CREATE TABLE [#C_BALANCES] (                      
    [PARTY_CODE]    [VARCHAR](10)   NULL,                      
    [LEDGERAMOUNT]  [MONEY]   NULL,                      
    [CHARGESAMOUNT] [MONEY]   NULL)                      
  ON [PRIMARY]                      
                        
----------------------------------------------------------------------                
--NSECM BALANCES                
----------------------------------------------------------------------                
  INSERT INTO #C_BALANCES                      
  SELECT   CLTCODE,                      
           SUM(LEDGERAMOUNT),                      
           SUM(CHARGESAMOUNT)                      
  FROM     (SELECT   L.CLTCODE,                      
                     LEDGERAMOUNT = SUM(CASE        
                                          WHEN DRCR = 'C' THEN VAMT                      
                                          ELSE -VAMT                      
                                  END),                      
                     CHARGESAMOUNT = 0                      
            FROM     ACCOUNT.DBO.LEDGER L,                      
                  ACCOUNT.DBO.ACMAST A,                      
                     ACCOUNT.DBO.PARAMETER P                      
            WHERE    L.CLTCODE = A.CLTCODE                      
   AND A.ACCAT = 4                      
                     AND @BALDATE BETWEEN SDTCUR AND LDTCUR                      
                     AND VDT >= SDTCUR                      
                     AND VDT <= @BALDATE + ' 23:59:00'                      
            GROUP BY L.CLTCODE                    
            UNION ALL                      
            SELECT   CLTCODE = PARTY_CODE,                      
          LEDGERAMOUNT = 0,                      
                     CHARGESAMOUNT = SUM(CASE                       
                                           WHEN DRCR = 'C' THEN AMOUNT                      
  ELSE -AMOUNT                      
                                         END)                      
            FROM     ACCOUNT.DBO.MARGINLEDGER L,                      
                     ACCOUNT.DBO.ACMAST A,                      
                     ACCOUNT.DBO.PARAMETER P                      
            WHERE    L.PARTY_CODE = A.CLTCODE                      
                     AND A.ACCAT = 4                      
                     AND @BALDATE BETWEEN SDTCUR AND LDTCUR                      
                     AND VDT >= SDTCUR                      
                     AND VDT <= @BALDATE + ' 23:59:00'                    
            GROUP BY PARTY_CODE) A                      
  GROUP BY CLTCODE                      
                    
  UPDATE V2_EQUITY_FOUT_BALANCES                       
  SET    NC_LEDGERAMOUNT = LEDGERAMOUNT,                      
         NC_CASH_COLL = CHARGESAMOUNT,                       
         CREATEDATE = GETDATE()                       
  FROM   #C_BALANCES N                       
  WHERE  V2_EQUITY_FOUT_BALANCES.PARTY_CODE = N.PARTY_CODE                       
                        
  INSERT INTO V2_EQUITY_FOUT_BALANCES                      
  SELECT PARTY_CODE,                      
         0,0,0,0,0,0,0,                      
         0,0,0,0,0,0,0,                      
         0,                
         LEDGERAMOUNT,                      
         CHARGESAMOUNT,                       
         0,0,0,0,                      
         0,0,0,0,0,0,0,                      
         0,0,                
         @UNAME,                       
         GETDATE()                       
  FROM   #C_BALANCES N                      
  WHERE  NOT EXISTS (SELECT PARTY_CODE                       
                     FROM   V2_EQUITY_FOUT_BALANCES F                       
                     WHERE  N.PARTY_CODE = F.PARTY_CODE)                       
                
  TRUNCATE TABLE  #C_BALANCES                
                
----------------------------------------------------------------------                
--BSECM BALANCES                
----------------------------------------------------------------------                
  INSERT INTO #C_BALANCES                      
  SELECT   CLTCODE,                      
           SUM(LEDGERAMOUNT),                      
           SUM(CHARGESAMOUNT)                      
  FROM     (SELECT   L.CLTCODE,                      
                     LEDGERAMOUNT = SUM(CASE                       
                                          WHEN DRCR = 'C' THEN VAMT                      
                                          ELSE -VAMT                      
                                        END),                      
                     CHARGESAMOUNT = 0                      
            FROM     ACCOUNTBSE.DBO.LEDGER L,                    
                     ACCOUNTBSE.DBO.ACMAST A,                      
                     ACCOUNTBSE.DBO.PARAMETER P                      
            WHERE    L.CLTCODE = A.CLTCODE                      
                     AND A.ACCAT = 4                      
                     AND @BALDATE BETWEEN SDTCUR AND LDTCUR                      
                     AND VDT >= SDTCUR                      
                     AND VDT <= LEFT(@BALDATE,11) + ' 23:59:00'                      
            GROUP BY L.CLTCODE                    
            UNION ALL                      
            SELECT   CLTCODE = PARTY_CODE,                                       LEDGERAMOUNT = 0,                      
                     CHARGESAMOUNT = SUM(CASE                       
                                           WHEN DRCR = 'C' THEN AMOUNT                      
                                           ELSE -AMOUNT                      
                                         END)              
            FROM     ACCOUNTBSE.DBO.MARGINLEDGER L,                      
                     ACCOUNTBSE.DBO.ACMAST A,                      
                     ACCOUNTBSE.DBO.PARAMETER P                      
            WHERE    L.PARTY_CODE = A.CLTCODE                      
                     AND A.ACCAT = 4                      
                     AND @BALDATE BETWEEN SDTCUR AND LDTCUR                      
                     AND VDT >= SDTCUR                      
                     AND VDT <= @BALDATE + ' 23:59:00'                    
            GROUP BY PARTY_CODE) A                      
  GROUP BY CLTCODE                      
                    
  UPDATE V2_EQUITY_FOUT_BALANCES                       
  SET    BC_LEDGERAMOUNT = LEDGERAMOUNT,                
         BC_CASH_COLL = CHARGESAMOUNT,                       
         CREATEDATE = GETDATE()                       
  FROM   #C_BALANCES N                       
  WHERE  V2_EQUITY_FOUT_BALANCES.PARTY_CODE = N.PARTY_CODE                       
                        
  INSERT INTO V2_EQUITY_FOUT_BALANCES                      
  SELECT PARTY_CODE,                      
         0,0,0,0,0,0,0,                      
         0,0,0,0,0,0,0,                      
         0,                
         0,0,                
         0,0,0,0,                      
         0,                
         LEDGERAMOUNT,                      
         CHARGESAMOUNT,                       
         0,0,0,0,                      
         0,0,                
         @UNAME,                       
         GETDATE()                       
  FROM   #C_BALANCES N                      
  WHERE  NOT EXISTS (SELECT PARTY_CODE                       
            FROM   V2_EQUITY_FOUT_BALANCES F                       
                     WHERE  N.PARTY_CODE = F.PARTY_CODE)                       
                
  TRUNCATE TABLE  #C_BALANCES                
                
----------------------------------------------------------------------                
--COMMON POOL BALANCES                
----------------------------------------------------------------------                
  INSERT INTO #C_BALANCES                      
  SELECT   CLTCODE,                      
           SUM(LEDGERAMOUNT),                      
           SUM(CHARGESAMOUNT)                      
  FROM     (SELECT   L.CLTCODE,                      
                     LEDGERAMOUNT = SUM(CASE                       
                                          WHEN DRCR = 'C' THEN VAMT                      
                                          ELSE -VAMT                      
                                        END),                      
                     CHARGESAMOUNT = 0                      
            FROM     ACCCOMMON.DBO.LEDGER L,                      
                     ACCCOMMON.DBO.ACMAST A,                      
                     ACCCOMMON.DBO.PARAMETER P                      
            WHERE    L.CLTCODE = A.CLTCODE       
                     AND A.ACCAT = 4                      
                     AND @BALDATE BETWEEN SDTCUR AND LDTCUR                      
                     AND VDT >= SDTCUR                      
                     AND VDT <= @BALDATE + ' 23:59:00'                      
            GROUP BY L.CLTCODE                    
            UNION ALL                      
            SELECT   CLTCODE = PARTY_CODE,                      
                     LEDGERAMOUNT = 0,                      
                     CHARGESAMOUNT = SUM(CASE                       
                                           WHEN DRCR = 'C' THEN AMOUNT                      
                                           ELSE -AMOUNT                      
                                         END)                      
            FROM     ACCCOMMON.DBO.MARGINLEDGER L,                      
                     ACCCOMMON.DBO.ACMAST A,                      
      ACCCOMMON.DBO.PARAMETER P                      
            WHERE    L.PARTY_CODE = A.CLTCODE                      
                     AND A.ACCAT = 4                      
                     AND @BALDATE BETWEEN SDTCUR AND LDTCUR                      
                     AND VDT >= SDTCUR                      
                     AND VDT <= @BALDATE + ' 23:59:00'                    
            GROUP BY PARTY_CODE) A                      
  GROUP BY CLTCODE                      
                    
  UPDATE V2_EQUITY_FOUT_BALANCES                       
  SET    C_LEDGERAMOUNT = LEDGERAMOUNT,                      
         C_CHARGESAMOUNT = CHARGESAMOUNT,                       
         CREATEDATE = GETDATE()                       
  FROM   #C_BALANCES N                       
  WHERE  V2_EQUITY_FOUT_BALANCES.PARTY_CODE = N.PARTY_CODE                       
                        
  INSERT INTO V2_EQUITY_FOUT_BALANCES                      
  SELECT PARTY_CODE,                      
         0,0,0,0,0,0,0,                      
         0,0,0,0,0,0,0,                      
         0,0,0,0,0,0,0,                      
         0,0,0,0,0,0,0,                      
         C_LEDGERAMOUNT = LEDGERAMOUNT,                      
         C_CHARGESAMOUNT = CHARGESAMOUNT,                       
         @UNAME,                       
         GETDATE()                       
  FROM   #C_BALANCES N                      
  WHERE  NOT EXISTS (SELECT PARTY_CODE                       
                     FROM   V2_EQUITY_FOUT_BALANCES F                       
                     WHERE  N.PARTY_CODE = F.PARTY_CODE)                       
                    
  DROP TABLE #C_BALANCES                       
    
 --EXEC ACCCOMMODITY.DBO.V2_AGEING_CAL @@MDATE               
--EXEC ACCCOMMON.DBO.V2_AGEING_CAL

GO
