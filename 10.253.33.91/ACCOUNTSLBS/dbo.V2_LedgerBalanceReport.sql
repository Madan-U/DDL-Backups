-- Object: PROCEDURE dbo.V2_LedgerBalanceReport
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------



CREATE PROCEDURE V2_LedgerBalanceReport
(          
      @SDATE VARCHAR(11),            
      @FPARTY VARCHAR(10),             
      @TPARTY VARCHAR(10),         
      @EFFDATE VARCHAR(11), 
      @CL_TYPE VARCHAR(3)
)          

AS              
            
/*===========================================================================    
      EXEC V2_LedgerBalanceReport
            @SDATE = 'APR  1 2005',     
            @FPARTY = '',     
            @TPARTY = '',     
            @EFFDATE = 'MAR  4 2006', 
            @CL_TYPE = '' 
===========================================================================*/    
    
SET NOCOUNT ON    
    
IF @FPARTY = ''                           
BEGIN                           
      SET @FPARTY = '0000000000'         
END                          
          
IF @TPARTY = ''                           
BEGIN                           
      SET @TPARTY = 'ZZZZZZZZZZ'          
END             
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
DECLARE     
      @@RECCOUNT INT    
    
SET @@RECCOUNT = 0    
    
SELECT @@RECCOUNT = COUNT(1) FROM SETTPAYOUT WHERE LEFT(REQUESTDT,11) = LEFT(GETDATE(),11) AND STATUS = 'P'     
    
      IF @@RECCOUNT <> 0     
      BEGIN    
            SELECT ':: SORRY!! CANNOT PROCEED. THERE ARE SOME REQUESTS PENDING. PLEASE REJECT/APPROVE TO RECALCULATE ::'    
            RETURN    
      END    
    
/*===========================================================================    
      CREATE # TABLES FOR CANNED LEDGER BALANCES AND BILL AMOUNTS    
===========================================================================*/    
      CREATE TABLE #LEDGERBALANCE    
      (           
            PARTYCODE VARCHAR(10),            
            PARTYNAME VARCHAR(100),             
            CHEQUENAME VARCHAR(100),            
            BRANCHCODE VARCHAR(10),            
            CL_TYPE VARCHAR(3),            
            ACCAT VARCHAR(10),            
            BTOBPAYMENT INT,            
            TOTLEDBAL MONEY,            
            NSELEDBAL MONEY,            
            BSELEDBAL MONEY,            
            FNOLEDBAL MONEY,            
            SETT_NO VARCHAR(7),            
            NORMALBILLAMT MONEY,            
            T2TBILLAMT MONEY,            
            BILLAMT MONEY,            
            FUTUREPAYOUT MONEY,            
            SHORTAGE MONEY,            
            AMOUNTTOBEPAID MONEY,           
            PAYMODE VARCHAR(1),           
            BANKCODE VARCHAR(10),    
            RUNDATE DATETIME           
      )     
          
      CREATE  INDEX [PARTYCODE] ON [DBO].[#LEDGERBALANCE]([PARTYCODE]) ON [PRIMARY]           
          
      CREATE TABLE [#LEDGERBILLTMP]           
      (           
            [CLTCODE] [VARCHAR] (10)  NULL ,            
            [BRANCHCODE] [VARCHAR] (10)  NULL ,            
            [CL_TYPE] [VARCHAR] (3)  NULL ,            
            [LONGNAME] [VARCHAR] (100)  NULL ,            
            [ACCAT] [CHAR] (10)  NULL ,            
            [BTOBPAYMENT] [INT] NULL ,            
            [PAYMODE] [CHAR] (1)  NULL ,            
            [POBANKCODE] [VARCHAR] (10)  NULL,           
            [SETT_NO] [VARCHAR] (7) NOT NULL,           
            [NORMALBILLAMT] [MONEY],           
            [T2TBILLAMT] [MONEY],     
            [RUNDATE] [DATETIME]           
      ) ON [PRIMARY]          
    
    
/*===========================================================================    
      POPULATE BILL AMOUNTS FROM ACCBILL TABLE IN THE SHAREDB FOR NORMAL AND T2T SETTLEMENTS    
      DELETE CLIENTS WITH CLIENT TYPE SET AS ('MTF', 'PMS', 'WEB')     
===========================================================================*/     
      INSERT     
      INTO #LEDGERBILLTMP     
      SELECT     
            A.CLTCODE ,     
            A.BRANCHCODE,     
            C1.CL_TYPE, 
            LONGNAME,     
            ACCAT,     
            BTOBPAYMENT,     
            PAYMODE,     
            POBANKCODE,     
            SETT_NO = '',     
            NORMALBILLAMT = 0,     
            T2TBILLAMT = 0,     
            RUNDATE = GETDATE()     
      FROM ACMAST A WITH(NOLOCK), 
            MSAJAG.DBO.CLIENT1 C1 WITH(NOLOCK), 
            MSAJAG.DBO.CLIENT2 C2 WITH(NOLOCK) 
      WHERE A.CLTCODE BETWEEN @FPARTY AND @TPARTY     
            AND A.ACCAT IN (4, 104)                       
            AND A.CLTCODE = C2.PARTY_CODE
            AND C2.CL_CODE = C1.CL_CODE 
            AND C1.CL_TYPE LIKE @CL_TYPE 
            AND A.POBANKCODE IN     
                  (    
                  SELECT     
                              CLTCODE     
                        FROM ACMAST     
                        WITH(NOLOCK)     
                        WHERE ACCAT = 2    
                  )     
      GROUP BY A.CLTCODE,     
            A.BRANCHCODE,     
            C1.CL_TYPE, 
            LONGNAME,     
            ACCAT,     
            BTOBPAYMENT,     
            PAYMODE,     
            POBANKCODE                 
       
      CREATE  INDEX [CLTCODE] ON [DBO].[#LEDGERBILLTMP]([CLTCODE]) ON [PRIMARY]           
             
    
/*===========================================================================    
      CALCULATE NSE CASH LEDGER BALANCES FOR CLIENTS WITH CREDIT IN THE SELECTED SETTLEMENT     
===========================================================================*/    
      INSERT     
      INTO #LEDGERBALANCE     
      SELECT     
            L.CLTCODE ,     
            ACNAME = A.LONGNAME,     
            CHEQUENAME = A.LONGNAME,     
            A.BRANCHCODE,     
            A.CL_TYPE, 
            A.ACCAT,     
            A.BTOBPAYMENT ,     
            TOTLEDBAL = 0,     
            NSELEDBAL = SUM(    
                            CASE     
                              WHEN EDT BETWEEN @SDATE + ' 00:00:00' AND @EFFDATE + ' 23:59:00'     
                              THEN (
                              CASE     
                                    WHEN DRCR = 'D'     
                                    THEN -VAMT     
                                    ELSE VAMT     
                              END    
                              )    
                              ELSE 0     
                        END     
                  ) + SUM(    
                        CASE     
                              WHEN EDT > @EFFDATE + ' 23:59:00'     
                              THEN (    
                              CASE     
                                    WHEN DRCR = 'D'     
                                    THEN -VAMT     
                                    ELSE 0     
                              END    
                              )     
                              ELSE 0     
                        END     
                  ),     
            BSELEDBAL = 0,     
            FNOLEDBAL = 0,     
            A.SETT_NO,     
            A.NORMALBILLAMT,     
            A.T2TBILLAMT,     
            BILLAMT = A.NORMALBILLAMT + A.T2TBILLAMT,     
            FUTUREPAYOUT = 0 ,     
            SHORTAGE = 0,     
            AMOUNTTOBEPAID = 0,     
            A.PAYMODE,     
            A.POBANKCODE,     
            RUNDATE      
      FROM #LEDGERBILLTMP A WITH(NOLOCK),     
            ACCOUNT..LEDGER L WITH(NOLOCK)     
      WHERE L.CLTCODE = A.CLTCODE     
            AND L.VDT BETWEEN @SDATE + ' 00:00:00' AND @EFFDATE + ' 23:59:00'     
      GROUP BY A.BRANCHCODE,     
            A.CL_TYPE, 
            L.CLTCODE,     
            A.LONGNAME,     
            A.ACCAT,     
            A.BTOBPAYMENT,     
            A.PAYMODE,     
            A.POBANKCODE,     
            A.SETT_NO,     
            A.NORMALBILLAMT,     
            A.T2TBILLAMT,     
            RUNDATE      
      
      UNION ALL
      
      SELECT     
            L.CLTCODE ,     
            ACNAME = A.LONGNAME,     
            CHEQUENAME = A.LONGNAME,     
            A.BRANCHCODE,     
            A.CL_TYPE, 
            A.ACCAT,     
            A.BTOBPAYMENT ,     
            TOTLEDBAL = 0,     
            NSELEDBAL = SUM(    
                              CASE     
                                     WHEN DRCR = 'D'     
                                     THEN VAMT     
                                     ELSE -VAMT     
                              END                                
                              ),     
            BSELEDBAL = 0,     
            FNOLEDBAL = 0,     
            A.SETT_NO,     
            A.NORMALBILLAMT,     
            A.T2TBILLAMT,     
            BILLAMT = A.NORMALBILLAMT + A.T2TBILLAMT,     
            FUTUREPAYOUT = 0 ,     
            SHORTAGE = 0,     
            AMOUNTTOBEPAID = 0,     
            A.PAYMODE,     
            A.POBANKCODE,     
            RUNDATE      
      FROM #LEDGERBILLTMP A WITH(NOLOCK),     
            ACCOUNT..LEDGER L WITH(NOLOCK)     
      WHERE L.CLTCODE = A.CLTCODE     
            AND L.EDT >= @SDATE 
            AND L.VDT < @SDATE
      GROUP BY A.BRANCHCODE,     
            A.CL_TYPE, 
            L.CLTCODE,     
            A.LONGNAME,     
            A.ACCAT,     
            A.BTOBPAYMENT,     
            A.PAYMODE,     
            A.POBANKCODE,     
            A.SETT_NO,     
            A.NORMALBILLAMT,     
            A.T2TBILLAMT,     
            RUNDATE    
    
/*===========================================================================    
      CALCULATE BSE CASH LEDGER BALANCES FOR CLIENTS WITH CREDIT IN THE SELECTED SETTLEMENT     
===========================================================================*/    
      INSERT     
      INTO #LEDGERBALANCE     
      SELECT     
            L.CLTCODE ,     
            ACNAME = A.LONGNAME,     
            CHEQUENAME = A.LONGNAME,     
            A.BRANCHCODE,     
            A.CL_TYPE, 
            A.ACCAT,     
            A.BTOBPAYMENT ,     
            TOTLEDBAL = 0,     
            NSELEDBAL = 0,     
            BSELEDBAL = SUM(    
                            CASE     
                              WHEN EDT BETWEEN @SDATE + ' 00:00:00' AND @EFFDATE + ' 23:59:00'     
                              THEN (    
                              CASE     
                                    WHEN DRCR = 'D'     
                                    THEN -VAMT     
                                    ELSE VAMT     
                              END    
                              )    
                              ELSE 0     
                        END     
                  ) + SUM(    
                        CASE     
                             WHEN EDT > @EFFDATE + ' 23:59:00'     
                              THEN (    
                              CASE     
                                    WHEN DRCR = 'D'     
                                    THEN -VAMT     
                                    ELSE 0     
                              END    
                              )     
                              ELSE 0     
                        END     
                  ),     
            FNOLEDBAL = 0,     
            A.SETT_NO,     
            A.NORMALBILLAMT,     
            A.T2TBILLAMT,     
            BILLAMT = A.NORMALBILLAMT + A.T2TBILLAMT,     
            FUTUREPAYOUT = 0 ,     
            SHORTAGE = 0,     
            AMOUNTTOBEPAID = 0,     
            A.PAYMODE,     
            A.POBANKCODE,     
            RUNDATE      
      FROM #LEDGERBILLTMP A WITH(NOLOCK),     
            ACCOUNTBSE..LEDGER L WITH(NOLOCK)     
      WHERE L.CLTCODE = A.CLTCODE     
            AND L.VDT BETWEEN @SDATE + ' 00:00:00' AND @EFFDATE + ' 23:59:00'     
      GROUP BY A.BRANCHCODE,     
            A.CL_TYPE, 
            L.CLTCODE,     
            A.LONGNAME,     
            A.ACCAT,     
            A.BTOBPAYMENT,     
            A.PAYMODE,     
            A.POBANKCODE,     
            A.SETT_NO,     
            A.NORMALBILLAMT,     
            A.T2TBILLAMT,     
            RUNDATE      

      UNION ALL

      SELECT     
            L.CLTCODE ,     
            ACNAME = A.LONGNAME,     
            CHEQUENAME = A.LONGNAME,     
            A.BRANCHCODE,     
            A.CL_TYPE, 
            A.ACCAT,     
            A.BTOBPAYMENT ,     
            TOTLEDBAL = 0,     
            NSELEDBAL = 0,     
            BSELEDBAL = SUM(    
                              CASE     
                                  WHEN DRCR = 'D'     
                                  THEN VAMT     
                                  ELSE -VAMT     
                              END
                              ),     
            FNOLEDBAL = 0,     
            A.SETT_NO,     
            A.NORMALBILLAMT,     
            A.T2TBILLAMT,     
            BILLAMT = A.NORMALBILLAMT + A.T2TBILLAMT,     
            FUTUREPAYOUT = 0 ,     
            SHORTAGE = 0,     
            AMOUNTTOBEPAID = 0,     
            A.PAYMODE,     
            A.POBANKCODE,     
            RUNDATE      
      FROM #LEDGERBILLTMP A WITH(NOLOCK),     
            ACCOUNTBSE..LEDGER L WITH(NOLOCK)     
      WHERE L.CLTCODE = A.CLTCODE     
            AND L.EDT >= @SDATE 
            AND L.VDT < @SDATE
      GROUP BY A.BRANCHCODE,     
            A.CL_TYPE, 
            L.CLTCODE,     
            A.LONGNAME,     
            A.ACCAT,     
            A.BTOBPAYMENT,     
            A.PAYMODE,     
            A.POBANKCODE,     
            A.SETT_NO,     
            A.NORMALBILLAMT,     
            A.T2TBILLAMT,     
            RUNDATE    
    
/*===========================================================================    
      CALCULATE NSE DERIVATIVE LEDGER BALANCES FOR CLIENTS WITH CREDIT IN THE SELECTED SETTLEMENT     
===========================================================================*/    
      INSERT     
      INTO #LEDGERBALANCE     
      SELECT     
            L.CLTCODE ,     
            ACNAME = A.LONGNAME,     
            CHEQUENAME = A.LONGNAME,     
            A.BRANCHCODE,     
            A.CL_TYPE, 
            A.ACCAT,     
            A.BTOBPAYMENT ,     
            TOTLEDBAL = 0,     
            NSELEDBAL = 0,     
            BSELEDBAL = 0,     
            FNOLEDBAL = SUM(    
                            CASE     
                              WHEN EDT BETWEEN @SDATE + ' 00:00:00' AND @EFFDATE + ' 23:59:00'     
                              THEN (    
                              CASE     
                                    WHEN DRCR = 'D'     
                                    THEN -VAMT     
                                    ELSE VAMT     
                              END    
                              )    
                              ELSE 0     
                        END     
                  ) + SUM(    
                        CASE     
                              WHEN EDT > @EFFDATE + ' 23:59:00'     
                              THEN (    
                              CASE     
                                    WHEN DRCR = 'D'     
                                    THEN -VAMT     
                                    ELSE 0     
                              END    
                              )     
                              ELSE 0     
                        END     
                  ),     
            A.SETT_NO,     
            A.NORMALBILLAMT,     
            A.T2TBILLAMT,     
            BILLAMT = A.NORMALBILLAMT + A.T2TBILLAMT,     
            FUTUREPAYOUT = 0 ,     
            SHORTAGE = 0,     
            AMOUNTTOBEPAID = 0,     
            A.PAYMODE,     
            A.POBANKCODE,     
            RUNDATE      
      FROM #LEDGERBILLTMP A WITH(NOLOCK),     
            ACCOUNTFO..LEDGER L WITH(NOLOCK)     
      WHERE L.CLTCODE = A.CLTCODE     
            AND L.VDT BETWEEN @SDATE + ' 00:00:00' AND @EFFDATE + ' 23:59:00'     
      GROUP BY A.BRANCHCODE,     
            A.CL_TYPE, 
            L.CLTCODE,     
            A.LONGNAME,     
            A.ACCAT,     
            A.BTOBPAYMENT,     
            A.PAYMODE,     
            A.POBANKCODE,     
            A.SETT_NO,     
            A.NORMALBILLAMT,     
            A.T2TBILLAMT,     
            RUNDATE             
    
      UNION ALL

      SELECT     
            L.CLTCODE ,     
            ACNAME = A.LONGNAME,     
            CHEQUENAME = A.LONGNAME,     
            A.BRANCHCODE,     
            A.CL_TYPE, 
            A.ACCAT,     
            A.BTOBPAYMENT ,     
            TOTLEDBAL = 0,     
            NSELEDBAL = 0,     
            BSELEDBAL = 0,     
            FNOLEDBAL = SUM(    
                              CASE     
                                    WHEN DRCR = 'D'     
                                    THEN VAMT     
                                    ELSE -VAMT     
                              END    
                              ),     
            A.SETT_NO,     
            A.NORMALBILLAMT,     
            A.T2TBILLAMT,     
            BILLAMT = A.NORMALBILLAMT + A.T2TBILLAMT,     
            FUTUREPAYOUT = 0 ,     
            SHORTAGE = 0,     
            AMOUNTTOBEPAID = 0,     
            A.PAYMODE,     
            A.POBANKCODE,     
            RUNDATE      
      FROM #LEDGERBILLTMP A WITH(NOLOCK),     
            ACCOUNTFO..LEDGER L WITH(NOLOCK)     
      WHERE L.CLTCODE = A.CLTCODE     
            AND L.EDT >= @SDATE 
            AND L.VDT < @SDATE
      GROUP BY A.BRANCHCODE,     
            A.CL_TYPE, 
            L.CLTCODE,     
            A.LONGNAME,     
            A.ACCAT,     
            A.BTOBPAYMENT,     
            A.PAYMODE,     
            A.POBANKCODE,     
            A.SETT_NO,     
            A.NORMALBILLAMT,     
            A.T2TBILLAMT,     
            RUNDATE      
      HAVING SUM(    
                  CASE     
                        WHEN DRCR = 'D'     
                        THEN -VAMT     
                        ELSE VAMT     
                  END                       
            ) + SUM(    
                  CASE     
                        WHEN EDT > @EFFDATE + ' 23:59:00'      
                        THEN (    
                        CASE     
                              WHEN DRCR = 'D'     
                              THEN -VAMT     
                              ELSE 0     
                        END    
                        )     
                        ELSE 0     
                  END     
            ) < 0    
    
/*===========================================================================    
      INSERT INTO PHYSICAL TABLE FROM TEMP TABLE AFTER GROUPING AS REQUIRED     
===========================================================================*/    
      SELECT     
            PARTYCODE,    
            PARTYNAME,    
            CHEQUENAME,    
            BRANCHCODE,    
            CL_TYPE, 
            ACCAT,    
            BTOBPAYMENT,    
            TOTLEDBAL = SUM(NSELEDBAL + BSELEDBAL + FNOLEDBAL),    
            NSELEDBAL = SUM(NSELEDBAL),    
            BSELEDBAL = SUM(BSELEDBAL),    
            FNOLEDBAL = SUM(CASE WHEN FNOLEDBAL < 0 THEN FNOLEDBAL ELSE 0 END),    
/*            SETT_NO,    
            NORMALBILLAMT,    
            T2TBILLAMT,    
            BILLAMT,    */
            FUTUREPAYOUT,    
            SHORTAGE,    
            AMOUNTTOBEPAID,    
            PAYMODE,    
            BANKCODE,    
            RUNDATE     
      FROM #LEDGERBALANCE     
      GROUP BY PARTYCODE,    
            PARTYNAME,    
            CHEQUENAME,    
            BRANCHCODE,    
            CL_TYPE, 
            ACCAT,    
            BTOBPAYMENT,    
            SETT_NO,    
            NORMALBILLAMT,    
            T2TBILLAMT,    
            BILLAMT,    
            FUTUREPAYOUT,    
            SHORTAGE,    
            AMOUNTTOBEPAID,    
            PAYMODE,    
            BANKCODE,    
            RUNDATE     
      --HAVING    
            --SUM(NSELEDBAL + BSELEDBAL + FNOLEDBAL) > 0

GO
