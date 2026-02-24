-- Object: PROCEDURE dbo.V2_CALCULATE_FOUT_BALANCES
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE  PROC [DBO].[V2_CALCULATE_FOUT_BALANCES](        
         @COLL_COMPO_PER MONEY = 1)      
      
AS      
    
  SET NOCOUNT ON    
    
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
    
  DECLARE  @@rmsdate VARCHAR(11)    
                         
  SELECT TOP 1 @@rmsdate = ISNULL(LEFT(SAUDA_DATE,11),LEFT(GETDATE(),11))    
  FROM   MSAJAG..RMSALLSEGMENT    
  WHERE  SAUDA_DATE >= LEFT(GETDATE()-3,11)    
  ORDER BY 1 DESC     
    
  IF @COLL_COMPO_PER < 0.1 SET @COLL_COMPO_PER = 0.1        
        
  IF @COLL_COMPO_PER > 1 SET @COLL_COMPO_PER = 1        
        
  DECLARE       
    @FROMDATE VARCHAR(11),       
    @PROCESSPARAMS VARCHAR(100)      
      
  SELECT @FROMDATE = LEFT(CONVERT(VARCHAR,GETDATE(),109),11)        
      
  TRUNCATE TABLE V2_FOUT_LEDGERBALANCES_TEMP      
      
  INSERT INTO V2_FOUT_LEDGERBALANCES_TEMP      
  SELECT PARTY_CODE = C1.CL_CODE,      
         PARTY_NAME = C1.LONG_NAME,      
         FAMILY_CODE = C1.FAMILY,      
         FAMILY_NAME = C1.FAMILY,      
         BRANCH_CODE = C1.BRANCH_CD,      
         BRANCH_NAME = ISNULL(BR.BRANCH,'UNSPECIFIED'),      
         TRADER = C1.TRADER,      
         TRADER_NAME = ISNULL(TR.LONG_NAME,'UNSPECIFIED'),      
         SUBBROKER_CODE = C1.SUB_BROKER,      
         SUBBROKER_NAME = ISNULL(SR.NAME,'UNSPECIFIED'),      
         AREACODE = ISNULL(C1.AREA,''),      
         AREANAME = ISNULL(AR.DESCRIPTION,'UNSPECIFIED'),      
         REGION_CODE = ISNULL(C1.REGION,''),      
         REGION_NAME = ISNULL(RE.DESCRIPTION,'UNSPECIFIED'),      
         RES_PHONE = ISNULL(C1.RES_PHONE1,''),      
         NSEBALANCE = 0,      
         BSEBALANCE = 0,      
         NSEFOBALANCE = 0,      
	 NSXCURBALANCE =0,
	 MCXCURBALANCE =0,
         NSEESTIMATED1 = 0,      
         NSEESTIMATED2 = 0,      
         BSEESTIMATED1 = 0,      
         BSEESTIMATED2 = 0,      
         FAACTUAL = 0,      
         NONCASH = 0,      
         CASH = 0,      
         IMMARGIN = 0,      
         VARMARGIN = 0,      
         REPDATE = GETDATE(),     
         BEN_HOLDING = 0       
  FROM   MSAJAG.DBO.CLIENT_DETAILS C1 WITH(NOLOCK)      
           LEFT OUTER JOIN MSAJAG.DBO.BRANCH BR WITH(NOLOCK)      
           ON (C1.BRANCH_CD = BR.BRANCH_CODE)      
           LEFT OUTER JOIN MSAJAG.DBO.SUBBROKERS SR WITH(NOLOCK)      
           ON (C1.SUB_BROKER = SR.SUB_BROKER)      
           LEFT OUTER JOIN MSAJAG.DBO.BRANCHES TR WITH(NOLOCK)      
           ON (C1.TRADER = TR.SHORT_NAME)      
           LEFT OUTER JOIN (SELECT AREACODE, DESCRIPTION = MAX(DESCRIPTION) FROM MSAJAG.DBO.AREA WITH(NOLOCK) GROUP BY AREACODE)  AR      
           ON (C1.AREA = AR.AREACODE)      
           LEFT OUTER JOIN (SELECT REGIONCODE, DESCRIPTION = MAX(DESCRIPTION) FROM MSAJAG.DBO.REGION WITH(NOLOCK) GROUP BY REGIONCODE)  RE      
           ON (C1.REGION = RE.REGIONCODE)      
     
  UPDATE  V2_FOUT_LEDGERBALANCES_TEMP     
  SET     FAMILY_NAME = LONG_NAME     
  FROM    MSAJAG.DBO.CLIENT_DETAILS     
  WHERE   V2_FOUT_LEDGERBALANCES_TEMP.PARTY_CODE = FAMILY     
    
/*=======================================================================================      
PARTY CODE UPDATE IS COMPLETE      
    BALANCE_1 = EFFECTIVE DATE WISE NET BALANCE AFTER EXCLUDING [Receipt Bank] ENTRIES      
    BALANCE_2 = TOTAL [Receipt Bank] BASED ON VOUCHER DATE       
    ACTUAL_1 = VOUCHER DATE WISE NET BALANCE AFTER EXCLUDING [Receipt Bank] ENTRIES      
    ACTUAL_2 = TOTAL [Receipt Bank] BASED ON EFFECTIVE DATE       
      
    NSEBALANCE = BALANCE_1 + BALANCE_2      
    FAACTUAL = ACTUAL_1 + ACTUAL_2          
=======================================================================================*/      
      
  UPDATE V2_FOUT_LEDGERBALANCES_TEMP          
  SET    NSEBALANCE = BALANCE_1 +  BALANCE_2,          
         FAACTUAL = FAACTUAL + ACTUAL_1 + ACTUAL_2          
  FROM   (SELECT L.CLTCODE,          
                 BALANCE_1 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE       
                                                                WHEN EDT <= @FROMDATE + ' 23:59:59'     
                                                                   AND VTYP <> 2 THEN (CASE     
                                                                                           WHEN L.DRCR = 'D' THEN VAMT     
                                                                                           ELSE -VAMT     
                                                                                         END)              
                                                                ELSE 0     
                                                              END),0)),      
                 BALANCE_2 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE       
                                                                WHEN VTYP = 2 THEN -VAMT           
                                                                ELSE 0     
                                                              END),0)),      
                 ACTUAL_1 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE       
                                                               WHEN VTYP <> 2 THEN (CASE     
                                                                                      WHEN L.DRCR = 'D' THEN VAMT     
                                                                                      ELSE -VAMT     
                                                                                    END)          
                                                               ELSE 0     
                                                             END),0)),      
                 ACTUAL_2 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE           
                                                               WHEN EDT <= @FROMDATE + ' 23:59:59'     
                                                                    AND VTYP = 2 THEN -VAMT           
                                                               ELSE 0     
                                                             END),0))       
          FROM   ACCOUNT.DBO.LEDGER L WITH(NOLOCK),      
                 ACCOUNT.DBO.PARAMETER P WITH(NOLOCK),      
                 V2_FOUT_LEDGERBALANCES_TEMP FL WITH(NOLOCK)          
          WHERE  VDT BETWEEN SDTCUR AND @FROMDATE + ' 23:59'          
                 AND @FROMDATE BETWEEN SDTCUR AND LDTCUR          
                 AND L.CLTCODE = FL.PARTY_CODE      
          GROUP BY L.CLTCODE) A       
  WHERE  V2_FOUT_LEDGERBALANCES_TEMP.PARTY_CODE=A.CLTCODE          
      
      
/*--------------------------------------------------------------------------------------------------------------          
BSE CASH      
UPDATE EDT LEDGER BALANCES - RECEIPT BANK ENTRIES IGNORED          
UPDATE TOTAL RECEIPT BANK ENTRIES AMOUNT AS ON VDT      
UPDATE THE ACTUAL CONSOLIDATED LEDGER BALANCE (FAACTUAL)          
RECEIPT BANK ENTRIES CONSIDERED ON EFFECTIVE DATE BASIS          
--------------------------------------------------------------------------------------------------------------*/          
  UPDATE V2_FOUT_LEDGERBALANCES_TEMP          
  SET    BSEBALANCE = BALANCE_1 +  BALANCE_2,          
         FAACTUAL = FAACTUAL + ACTUAL_1 + ACTUAL_2          
  FROM   (SELECT L.CLTCODE,          
                 BALANCE_1 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE       
                                                                WHEN EDT <= @FROMDATE + ' 23:59:59'     
                                                                     AND VTYP <> 2 THEN (CASE     
                                                                                           WHEN L.DRCR = 'D' THEN VAMT     
                                                                                           ELSE -VAMT     
                                                                                         END)              
                                                                ELSE 0     
                                                              END),0)),      
                 BALANCE_2 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE       
                                                                WHEN VTYP = 2 THEN -VAMT           
                                                                ELSE 0     
                                                              END),0)),      
                 ACTUAL_1 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE       
                                                               WHEN VTYP <> 2 THEN (CASE     
                                                                                      WHEN L.DRCR = 'D' THEN VAMT     
                                                                                      ELSE -VAMT     
                                                                                    END)          
                                                               ELSE 0     
                                                             END),0)),      
                 ACTUAL_2 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE           
                                                               WHEN EDT <= @FROMDATE + ' 23:59:59'     
                                                                    AND VTYP = 2 THEN -VAMT           
                                                               ELSE 0     
                                                             END),0))       
          FROM   ACCOUNTBSE.DBO.LEDGER L WITH(NOLOCK),      
                 ACCOUNTBSE.DBO.PARAMETER P WITH(NOLOCK),      
                 V2_FOUT_LEDGERBALANCES_TEMP FL WITH(NOLOCK)          
          WHERE  VDT BETWEEN SDTCUR AND @FROMDATE + ' 23:59'          
                 AND @FROMDATE BETWEEN SDTCUR AND LDTCUR          
                 AND L.CLTCODE = FL.PARTY_CODE      
          GROUP BY L.CLTCODE) A       
  WHERE  V2_FOUT_LEDGERBALANCES_TEMP.PARTY_CODE=A.CLTCODE          
      
/*--------------------------------------------------------------------------------------------------------------          
NSE DERIVATIVES      
UPDATE EDT LEDGER BALANCES - RECEIPT BANK ENTRIES IGNORED          
UPDATE TOTAL RECEIPT BANK ENTRIES AMOUNT AS ON VDT      
UPDATE THE ACTUAL CONSOLIDATED LEDGER BALANCE (FAACTUAL)          
RECEIPT BANK ENTRIES CONSIDERED ON EFFECTIVE DATE BASIS          
--------------------------------------------------------------------------------------------------------------*/          
  UPDATE V2_FOUT_LEDGERBALANCES_TEMP          
  SET    NSEFOBALANCE = BALANCE_1 +  BALANCE_2,          
         FAACTUAL = FAACTUAL + ACTUAL_1 + ACTUAL_2          
  FROM   (SELECT L.CLTCODE,          
                 BALANCE_1 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE       
                                                                WHEN EDT <= @FROMDATE + ' 23:59:59'     
                                                                     AND VTYP <> 2 THEN (CASE     
                                                                                           WHEN L.DRCR = 'D' THEN VAMT     
                                                                                           ELSE -VAMT     
                                                                                         END)              
                                                                ELSE 0     
                                                              END),0)),      
                 BALANCE_2 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE       
                                                                WHEN VTYP = 2 THEN -VAMT           
                                                                ELSE 0     
                                                              END),0)),      
                 ACTUAL_1 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE       
                                                               WHEN VTYP <> 2 THEN (CASE     
                                                                                      WHEN L.DRCR = 'D' THEN VAMT     
                                                                                      ELSE -VAMT     
                                                                                    END)          
                                                               ELSE 0     
                                                             END),0)),      
                 ACTUAL_2 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE           
                                                               WHEN EDT <= @FROMDATE + ' 23:59:59'     
                                                                    AND VTYP = 2 THEN -VAMT           
                                                               ELSE 0     
                                                             END),0))       
          FROM   ACCOUNTFO.DBO.LEDGER L WITH(NOLOCK),      
                 ACCOUNTFO.DBO.PARAMETER P WITH(NOLOCK),      
                 V2_FOUT_LEDGERBALANCES_TEMP FL WITH(NOLOCK)          
          WHERE  VDT BETWEEN SDTCUR AND @FROMDATE + ' 23:59'          
                 AND @FROMDATE BETWEEN SDTCUR AND LDTCUR          
                 AND L.CLTCODE = FL.PARTY_CODE      
          GROUP BY L.CLTCODE) A       
  WHERE  V2_FOUT_LEDGERBALANCES_TEMP.PARTY_CODE=A.CLTCODE          

/*--------------------------------------------------------------------------------------------------------------          
NSX CURRNECY       
UPDATE EDT LEDGER BALANCES - RECEIPT BANK ENTRIES IGNORED          
UPDATE TOTAL RECEIPT BANK ENTRIES AMOUNT AS ON VDT      
UPDATE THE ACTUAL CONSOLIDATED LEDGER BALANCE (FAACTUAL)          
RECEIPT BANK ENTRIES CONSIDERED ON EFFECTIVE DATE BASIS          
--------------------------------------------------------------------------------------------------------------*/          
  UPDATE V2_FOUT_LEDGERBALANCES_TEMP          
  SET    NSXCURBALANCE = BALANCE_1 +  BALANCE_2,          
         FAACTUAL = FAACTUAL + ACTUAL_1 + ACTUAL_2          
  FROM   (SELECT L.CLTCODE,          
                 BALANCE_1 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE       
                                                                WHEN EDT <= @FROMDATE + ' 23:59:59'     
                                                                     AND VTYP <> 2 THEN (CASE     
                                                                                           WHEN L.DRCR = 'D' THEN VAMT     
                                                                                           ELSE -VAMT     
                                                                                         END)              
                                                                ELSE 0     
                                                              END),0)),      
                 BALANCE_2 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE       
                                                                WHEN VTYP = 2 THEN -VAMT           
                                                                ELSE 0     
                                                              END),0)),      
                 ACTUAL_1 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE       
                                                               WHEN VTYP <> 2 THEN (CASE     
                                                                                      WHEN L.DRCR = 'D' THEN VAMT     
                                                                                      ELSE -VAMT     
                                                                                    END)          
                                                               ELSE 0     
                                                             END),0)),      
                 ACTUAL_2 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE           
                                                               WHEN EDT <= @FROMDATE + ' 23:59:59'     
                                                                    AND VTYP = 2 THEN -VAMT           
                                                               ELSE 0     
                                                             END),0))       
          FROM   ACCOUNTCURFO.DBO.LEDGER L WITH(NOLOCK),      
                 ACCOUNTCURFO.DBO.PARAMETER P WITH(NOLOCK),      
                 V2_FOUT_LEDGERBALANCES_TEMP FL WITH(NOLOCK)          
          WHERE  VDT BETWEEN SDTCUR AND @FROMDATE + ' 23:59'          
                 AND @FROMDATE BETWEEN SDTCUR AND LDTCUR          
                 AND L.CLTCODE = FL.PARTY_CODE      
          GROUP BY L.CLTCODE) A       
  WHERE  V2_FOUT_LEDGERBALANCES_TEMP.PARTY_CODE=A.CLTCODE 



/*--------------------------------------------------------------------------------------------------------------          
MCX CURRENCY       
UPDATE EDT LEDGER BALANCES - RECEIPT BANK ENTRIES IGNORED          
UPDATE TOTAL RECEIPT BANK ENTRIES AMOUNT AS ON VDT      
UPDATE THE ACTUAL CONSOLIDATED LEDGER BALANCE (FAACTUAL)          
RECEIPT BANK ENTRIES CONSIDERED ON EFFECTIVE DATE BASIS          
--------------------------------------------------------------------------------------------------------------*/          
  UPDATE V2_FOUT_LEDGERBALANCES_TEMP          
  SET    MCXCURBALANCE = BALANCE_1 +  BALANCE_2,          
         FAACTUAL = FAACTUAL + ACTUAL_1 + ACTUAL_2          
  FROM   (SELECT L.CLTCODE,          
                 BALANCE_1 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE       
                                                                WHEN EDT <= @FROMDATE + ' 23:59:59'     
                                                                     AND VTYP <> 2 THEN (CASE     
                                                                                           WHEN L.DRCR = 'D' THEN VAMT     
                                                                                           ELSE -VAMT     
                                                                                         END)              
                                                                ELSE 0     
                                                              END),0)),      
                 BALANCE_2 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE       
                                                                WHEN VTYP = 2 THEN -VAMT           
                                                                ELSE 0     
                                                              END),0)),      
                 ACTUAL_1 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE       
                                                               WHEN VTYP <> 2 THEN (CASE     
                                                                                      WHEN L.DRCR = 'D' THEN VAMT     
                                                                                      ELSE -VAMT     
                                                                                    END)          
                                                               ELSE 0     
                                                             END),0)),      
                 ACTUAL_2 = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE           
                                                               WHEN EDT <= @FROMDATE + ' 23:59:59'     
                                                                    AND VTYP = 2 THEN -VAMT           
                                                               ELSE 0     
                                                             END),0))       
          FROM   ACCOUNTMCDXCDS.DBO.LEDGER L WITH(NOLOCK),      
                 ACCOUNTMCDXCDS.DBO.PARAMETER P WITH(NOLOCK),      
                 V2_FOUT_LEDGERBALANCES_TEMP FL WITH(NOLOCK)          
          WHERE  VDT BETWEEN SDTCUR AND @FROMDATE + ' 23:59'          
                 AND @FROMDATE BETWEEN SDTCUR AND LDTCUR          
                 AND L.CLTCODE = FL.PARTY_CODE      
          GROUP BY L.CLTCODE) A       
  WHERE  V2_FOUT_LEDGERBALANCES_TEMP.PARTY_CODE=A.CLTCODE 

      
CREATE TABLE [#LED]      
(                    
    [VDT] [DATETIME] NULL ,                    
    [CLTCODE] [VARCHAR] (10) NOT NULL ,       
    [DRCR] [CHAR] (1) NULL ,                    
    [VAMT] [MONEY] NULL ,                    
    [NARRATION] [VARCHAR] (234) NULL      
) ON [PRIMARY]               
      
CREATE NONCLUSTERED INDEX [VDT] ON [#LED] ([VDT]) ON [PRIMARY]                    
      
/*--------------------------------------------------------------------------------------------------------------          
RETRIEVING NSE VDT WISE BILL AMOUNTS FOR FUTURE DATED BILLS I.E. (EFFECTIVE DATE > RUNDATE)          
--------------------------------------------------------------------------------------------------------------*/                 
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED             
    INSERT INTO #LED      
    SELECT      
        VDT, CLTCODE, DRCR, VAMT, NARRATION      
    FROM      
        ACCOUNT.DBO.LEDGER L WITH(NOLOCK)      
    WHERE      
        VDT <= @FROMDATE + ' 23:59:59'       
        AND EDT >= @FROMDATE + ' 23:59:59'          
        AND (VTYP = 15 OR VTYP = 21)       
      
    SELECT      
        EXC='NSE',      
        VDT,      
        L.CLTCODE,         
        AMOUNT=CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN DRCR = 'D' THEN VAMT ELSE -VAMT END),0) )       
    INTO      
        #LEDGERESTIMATE          
    FROM      
        #LED L WITH(NOLOCK),      
        MSAJAG.DBO.SETT_MST S WITH(NOLOCK)      
    WHERE                 
        L.NARRATION LIKE '%' + RTRIM(SETT_NO) + 'NSECM' + RTRIM(SETT_TYPE) + '%'        
        AND VDT >= S.START_DATE          
        AND VDT <= S.SEC_PAYIN          
    GROUP BY      
        VDT,      
        L.CLTCODE       
      
      
/*--------------------------------------------------------------------------------------------------------------          
RETRIEVING BSE VDT WISE BILL AMOUNTS FOR FUTURE DATED BILLS I.E. (EFFECTIVE DATE > RUNDATE)          
--------------------------------------------------------------------------------------------------------------*/          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED             
      
    TRUNCATE TABLE #LED                    
      
    INSERT INTO #LED      
    SELECT      
        VDT, CLTCODE, DRCR, VAMT, NARRATION      
    FROM      
        ACCOUNTBSE.DBO.LEDGER L WITH(NOLOCK)      
    WHERE      
        VDT <= @FROMDATE + ' 23:59:59'                   
        AND EDT >= @FROMDATE + ' 23:59:59'          
        AND (VTYP = 15 OR VTYP = 21)       
      
    INSERT INTO      
        #LEDGERESTIMATE        
    SELECT      
        EXC='BSE',      
        VDT,      
        L.CLTCODE,         
        AMOUNT=CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN DRCR = 'D' THEN VAMT ELSE -VAMT END),0) )       
    FROM      
        #LED L WITH(NOLOCK),      
        BSEDB.DBO.SETT_MST S WITH(NOLOCK)      
    WHERE      
        L.NARRATION LIKE '%' + RTRIM(SETT_NO) + 'BSECM' + RTRIM(SETT_TYPE) + '%'        
        AND VDT >= S.START_DATE          
        AND VDT <= S.SEC_PAYIN          
    GROUP BY      
        VDT,      
        L.CLTCODE        
      
/*--------------------------------------------------------------------------------------------------------------          
UPDATING NSE FUTURE DATED BILL AMOUNTS AS RETRIEVED IN THE ABOVE QUERY          
FOR THE MOST RECENT BILL AS ESTIMATED AMOUNT 1          
--------------------------------------------------------------------------------------------------------------*/          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED           
    UPDATE      
        V2_FOUT_LEDGERBALANCES_TEMP      
    SET      
        NSEESTIMATED1 = AMOUNT          
    FROM      
    (          
        SELECT      
            CLTCODE,      
            AMOUNT=ISNULL(SUM(AMOUNT),0)          
        FROM      
            #LEDGERESTIMATE L (NOLOCK)          
        WHERE      
            LEFT(VDT,11) =      
                (          
                SELECT      
                    LEFT(CONVERT(VARCHAR,MIN(VDT),109),11)        
                FROM      
                    #LEDGERESTIMATE (NOLOCK)          
                WHERE      
                    L.EXC = EXC      
                    AND EXC = 'NSE'      
                )          
        GROUP BY      
        CLTCODE      
    ) A       
    WHERE      
    V2_FOUT_LEDGERBALANCES_TEMP.PARTY_CODE=A.CLTCODE          
      
/*--------------------------------------------------------------------------------------------------------------          
UPDATING NSE FUTURE DATED BILL AMOUNTS AS RETRIEVED IN THE ABOVE QUERY          
FOR ALL BILLS OTHER THAN THE MOST RECENT BILL AS ESTIMATED AMOUNT 2          
--------------------------------------------------------------------------------------------------------------*/          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
    UPDATE      
        V2_FOUT_LEDGERBALANCES_TEMP          
    SET      
        NSEESTIMATED2 = AMOUNT          
    FROM      
    (          
        SELECT      
            CLTCODE,      
            AMOUNT=ISNULL(SUM(AMOUNT),0)      
        FROM      
            #LEDGERESTIMATE L  (NOLOCK)          
        WHERE      
            LEFT(VDT,11) <>       
                (          
                SELECT      
                    LEFT(CONVERT(VARCHAR,MIN(VDT),109),11)       
                FROM      
                    #LEDGERESTIMATE (NOLOCK)          
                WHERE      
                    L.EXC = EXC      
                    AND EXC = 'NSE'      
                )          
        GROUP BY      
            CLTCODE      
    ) A              
    WHERE      
        V2_FOUT_LEDGERBALANCES_TEMP.PARTY_CODE=A.CLTCODE          
      
/*--------------------------------------------------------------------------------------------------------------          
UPDATING BSE FUTURE DATED BILL AMOUNTS AS RETRIEVED IN THE ABOVE QUERY          
FOR THE MOST RECENT BILL AS ESTIMATED AMOUNT 1          
--------------------------------------------------------------------------------------------------------------*/          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED           
    UPDATE      
        V2_FOUT_LEDGERBALANCES_TEMP          
    SET      
        BSEESTIMATED1 = AMOUNT          
    FROM      
    (          
        SELECT      
            CLTCODE,      
            AMOUNT=ISNULL(SUM(AMOUNT),0)      
        FROM      
            #LEDGERESTIMATE L (NOLOCK)          
        WHERE      
            LEFT(VDT,11) =      
                (          
                SELECT      
                    LEFT(CONVERT(VARCHAR,MIN(VDT),109),11)       
                FROM      
                    #LEDGERESTIMATE (NOLOCK)          
                WHERE      
                    L.EXC = EXC      
                    AND EXC = 'BSE'      
                )          
        GROUP BY      
        CLTCODE      
    ) A       
    WHERE      
    V2_FOUT_LEDGERBALANCES_TEMP.PARTY_CODE=A.CLTCODE         
      
/*--------------------------------------------------------------------------------------------------------------          
UPDATING BSE FUTURE DATED BILL AMOUNTS AS RETRIEVED IN THE ABOVE QUERY          
FOR ALL BILLS OTHER THAN THE MOST RECENT BILL AS ESTIMATED AMOUNT 2          
--------------------------------------------------------------------------------------------------------------*/          
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED           
    UPDATE      
        V2_FOUT_LEDGERBALANCES_TEMP          
    SET      
        BSEESTIMATED2 = AMOUNT          
    FROM      
    (          
        SELECT      
            CLTCODE,      
            AMOUNT=ISNULL(SUM(AMOUNT),0)      
FROM      
            #LEDGERESTIMATE L (NOLOCK)          
        WHERE      
            LEFT(VDT,11) <>       
            (          
            SELECT                    
                LEFT(CONVERT(VARCHAR,MIN(VDT),109),11)       
            FROM      
                #LEDGERESTIMATE (NOLOCK)          
            WHERE      
                L.EXC = EXC      
                AND EXC = 'BSE'          
            )          
    GROUP BY      
        CLTCODE      
    ) A       
    WHERE      
        V2_FOUT_LEDGERBALANCES_TEMP.PARTY_CODE=A.CLTCODE          
      
/*--------------------------------------------------------------------------------------------------------------          
  COLLATERAL AND NSEFO MARGIN REQUIREMENT UPDATE     
--------------------------------------------------------------------------------------------------------------*/          
      
DECLARE @@MARGINDATE VARCHAR(11)         
      
SELECT @@MARGINDATE = LEFT(MAX(TRANS_DATE),11) FROM MSAJAG.DBO.COLLATERAL (NOLOCK)        
      
    UPDATE V2_FOUT_LEDGERBALANCES_TEMP                
    SET    NONCASH = CC.NONCASH,                
           CASH = CC.CASH                
    FROM   (SELECT PARTY_CODE,                
                   CASH = SUM(CASH),                
                   NONCASH = SUM(NONCASH)        
            FROM   MSAJAG.DBO.COLLATERAL C   WITH(INDEX(PARTYCODE),NOLOCK)                
            WHERE  LEFT(TRANS_DATE,11) = @@MARGINDATE         
            GROUP BY PARTY_CODE) CC                
    WHERE   V2_FOUT_LEDGERBALANCES_TEMP.PARTY_CODE=CC.PARTY_CODE                
      
    UPDATE V2_FOUT_LEDGERBALANCES_TEMP          
    SET    IMMARGIN = ISNULL(MARGIN,0),     
           VARMARGIN = ISNULL(VMARGIN,0)           
    FROM   (SELECT PARTY_CODE,      
                   MARGIN = SUM(pspanmargin),     
                   VMARGIN = SUM(MTOM)        
            FROM   NSEFO.DBO.FOMARGINNEW F  WITH(INDEX(CLTYPEPARTYDATE),NOLOCK)         
            WHERE MDATE = (SELECT TOP 1 MDATE           
                           FROM   NSEFO.DBO.FOMARGINNEW (NOLOCK)          
                           WHERE  MDATE <= @FROMDATE +' 23:59:59'      
                           ORDER BY 1 DESC)                  
            GROUP BY PARTY_CODE) A       
    WHERE  V2_FOUT_LEDGERBALANCES_TEMP.PARTY_CODE=A.PARTY_CODE          
      
/*--------------------------------------------------------------------------------------------------------------          
  BENEFICIARY ACCOUNT BALANCES UPDATE     
--------------------------------------------------------------------------------------------------------------*/          
    UPDATE V2_FOUT_LEDGERBALANCES_TEMP     
    SET    BEN_HOLDING = DEBITVALUEAFTERHAIRCUT     
    FROM   (SELECT PCODE = PARTY_CODE,    
                   DEBITVALUEAFTERHAIRCUT    
            FROM   MSAJAG..RMSALLSEGMENT    
            WHERE  SAUDA_DATE BETWEEN @@rmsdate AND @@rmsdate + ' 23:59') RMS    
    WHERE  PARTY_CODE = PCODE     
      
--------------------------------------------------------------------------------------------------------------*/          
--    select * from RMSALLSEGMENT  
      
DELETE FROM      
    V2_FOUT_LEDGERBALANCES_TEMP        
WHERE      
    NSEBALANCE           = 0        
    AND BSEBALANCE       = 0        
    AND NSEFOBALANCE     = 0        
    AND NSEESTIMATED1    = 0        
    AND NSEESTIMATED2    = 0        
    AND BSEESTIMATED1    = 0        
    AND BSEESTIMATED2    = 0        
    AND FAACTUAL         = 0        
    AND NONCASH          = 0        
    AND CASH             = 0        
    AND IMMARGIN         = 0        
    AND VARMARGIN        = 0       
    AND BEN_HOLDING      = 0     
    
/*--------------------------------------------------------------------------------------------------------------          
  FINAL INSERT     
--------------------------------------------------------------------------------------------------------------*/          
      
SELECT   @PROCESSPARAMS = PROCESSPARAMS FROM V2_PROCESS_MASTER WHERE PROCESSNAME = 'FOUT REPORT'      
      
    UPDATE V2_PROCESS_MASTER      
    SET       
        PROCESSFLAG = 'N',      
        PROCESSPARAMS = 'FOUT REPORT IS BEING CALCULATED FOR ' + @FROMDATE + ' AT ' + LEFT(CONVERT(VARCHAR,GETDATE(),109),20),      
        PROCESSBY = 'SYSTEM',      
        PROCESSDATE = GETDATE()      
    WHERE       
        PROCESSNAME = 'FOUT REPORT'      
      
      
BEGIN TRAN      
      
    TRUNCATE TABLE V2_FOUT_LEDGERBALANCES      
          
    INSERT INTO       
        V2_FOUT_LEDGERBALANCES      
    SELECT       
        *       
    FROM       
        V2_FOUT_LEDGERBALANCES_TEMP      
      
    IF @@ERROR = 0      
    BEGIN      
        COMMIT TRAN      
        SELECT @PROCESSPARAMS = 'FOUT REPORT CALCULATED FOR ' + @FROMDATE + ' AT ' + LEFT(CONVERT(VARCHAR,GETDATE(),109),20)                  
    END      
    ELSE      
    BEGIN      
        ROLLBACK TRAN      
    END      
      
    DROP TABLE #LEDGERESTIMATE          
    DROP TABLE #LED      
      
    UPDATE V2_PROCESS_MASTER      
    SET       
        PROCESSFLAG = 'Y',      
        PROCESSPARAMS = @PROCESSPARAMS,      
        PROCESSBY = 'SYSTEM',      
        PROCESSDATE = GETDATE()      
    WHERE       
        PROCESSNAME = 'FOUT REPORT'      
      
      
      
/*--------------------------------------------------------------------------------------------------------------          
END PROCESS      
--------------------------------------------------------------------------------------------------------------*/

GO
