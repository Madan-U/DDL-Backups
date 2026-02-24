-- Object: PROCEDURE dbo.IPO_CHECKLEDBAL
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROCEDURE [dbo].[IPO_CHECKLEDBAL]      
(      
      @DTBAL VARCHAR (3),        
      @FPARTY VARCHAR (10),         
      @USER VARCHAR (25),  
      @BALAMT money output,  
      @ERRORCODE int output  
)      
      
AS          
        
CREATE TABLE [#MPO_LEDGERBALANCE_UP] (    
 [MPO_PARTYCODE] [VARCHAR] (10) NOT NULL ,    
 [MPO_PARTYNAME] [VARCHAR] (100) NULL ,    
 [MPO_EXCHANGE] [VARCHAR] (3) NOT NULL ,    
 [MPO_SEGMENT] [VARCHAR] (20) NOT NULL ,    
 [MPO_LEDGERBAL] [MONEY] NOT NULL ,    
 [MPO_RUNBY] [VARCHAR] (25) NOT NULL ,    
 [MPO_RUNDATE] [DATETIME] NOT NULL ,    
 [MPO_STATUS] [CHAR] (1) NOT NULL ,    
 [MPO_CALCBY] [CHAR] (3) NOT NULL ,    
 [MPO_BRANCHCODE] [VARCHAR] (20) NULL     
) ON [PRIMARY]    
      
IF @DTBAL = 'VDT'        
BEGIN        
      ------------------------------------------------------------------------------------------      
      --POPULATING NSE CASH SEGMENT LEDGER BALANCES      
      ------------------------------------------------------------------------------------------      
      INSERT INTO       
            #MPO_LEDGERBALANCE_UP        
      SELECT       
            MPO_PARTYCODE = L.CLTCODE,      
            MPO_PARTYNAME = A.LONGNAME,      
            MPO_EXCHANGE = 'NSE',      
            MPO_SEGMENT = 'CAPITAL',      
            MPO_LEDGERBAL = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE - VAMT END),      
            MPO_RUNBY = @USER,      
            MPO_RUNDATE = GETDATE(),      
            MPO_STATUS = 'I',      
            MPO_CALCBY = @DTBAL,      
            MPO_BRANCHCODE = A.BRANCHCODE       
      FROM       
            ACCOUNT..LEDGER L,      
            ACCOUNT..ACMAST A,       
            ACCOUNT..PARAMETER P      
      WHERE       
            L.VDT >= SDTCUR       
            AND L.VDT <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:00'      
            AND L.CLTCODE = @FPARTY     
            AND L.CLTCODE = A.CLTCODE      
            AND A.ACCAT = 4      
            AND GETDATE() BETWEEN SDTCUR AND LDTCUR      
      GROUP BY       
            L.CLTCODE, A.LONGNAME, A.BRANCHCODE      
            
      ------------------------------------------------------------------------------------------      
      --POPULATING BSE CASH SEGMENT LEDGER BALANCES      
      ------------------------------------------------------------------------------------------      
      INSERT INTO       
            #MPO_LEDGERBALANCE_UP        
      SELECT       
            MPO_PARTYCODE = L.CLTCODE,      
            MPO_PARTYNAME = A.LONGNAME,      
            MPO_EXCHANGE = 'BSE',      
            MPO_SEGMENT = 'CAPITAL',      
            MPO_LEDGERBAL = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE - VAMT END),      
            MPO_RUNBY = @USER,      
            MPO_RUNDATE = GETDATE(),      
            MPO_STATUS = 'I',      
            MPO_CALCBY = @DTBAL,      
            MPO_BRANCHCODE = A.BRANCHCODE       
      FROM       
            ACCOUNTBSE..LEDGER  L,      
            ACCOUNTBSE..ACMAST A,       
            ACCOUNTBSE..PARAMETER P      
      WHERE       
            L.VDT >= SDTCUR       
            AND L.VDT <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:00'      
            AND L.CLTCODE = @FPARTY     
            AND L.CLTCODE = A.CLTCODE      
            AND A.ACCAT = 4      
            AND GETDATE() BETWEEN SDTCUR AND LDTCUR      
      GROUP BY       
            L.CLTCODE, A.LONGNAME, A.BRANCHCODE      
            
      ------------------------------------------------------------------------------------------      
      --POPULATING NSE DERIVATIVES SEGMENT LEDGER BALANCES      
      ------------------------------------------------------------------------------------------      
 /*
     INSERT INTO       
            #MPO_LEDGERBALANCE_UP        
      SELECT       
            MPO_PARTYCODE = L.CLTCODE,      
            MPO_PARTYNAME = A.LONGNAME,      
            MPO_EXCHANGE = 'NSE',      
            MPO_SEGMENT = 'FUTURES',      
            MPO_LEDGERBAL = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE - VAMT END),      
            MPO_RUNBY = @USER,      
            MPO_RUNDATE = GETDATE(),      
            MPO_STATUS = 'I',      
            MPO_CALCBY = @DTBAL,      
            MPO_BRANCHCODE = A.BRANCHCODE       
      FROM       
            ACCOUNTFO..LEDGER  L,      
            ACCOUNTFO..ACMAST A,       
            ACCOUNTFO..PARAMETER P      
      WHERE       
            L.VDT >= SDTCUR       
            AND L.VDT <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:00'      
            AND L.CLTCODE = @FPARTY     
            AND L.CLTCODE = A.CLTCODE      
            AND A.ACCAT = 4      
            AND GETDATE() BETWEEN SDTCUR AND LDTCUR      
      GROUP BY       
            L.CLTCODE, A.LONGNAME, A.BRANCHCODE      
*/
END  --FOR VDT WISE COMPUTATION      
ELSE       
BEGIN  --FOR EDT WISE COMPUTATION      
      ------------------------------------------------------------------------------------------      
      --POPULATING NSE CASH SEGMENT LEDGER BALANCES @EDT      
      ------------------------------------------------------------------------------------------      
      INSERT INTO       
            #MPO_LEDGERBALANCE_UP        
      SELECT       
            MPO_PARTYCODE = L.CLTCODE,      
            MPO_PARTYNAME = A.LONGNAME,      
            MPO_EXCHANGE = 'NSE',      
            MPO_SEGMENT = 'CAPITAL',      
            MPO_LEDGERBAL = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE - VAMT END),      
            MPO_RUNBY = @USER,      
            MPO_RUNDATE = GETDATE(),      
            MPO_STATUS = 'I',      
            MPO_CALCBY = @DTBAL,      
            MPO_BRANCHCODE = A.BRANCHCODE       
      FROM       
            ACCOUNT..LEDGER  L,      
            ACCOUNT..ACMAST A,       
            ACCOUNT..PARAMETER P      
      WHERE       
            L.VDT >= SDTCUR       
            AND L.EDT <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:00'      
            AND L.CLTCODE = @FPARTY     
            AND L.CLTCODE = A.CLTCODE      
            AND A.ACCAT = 4      
            AND GETDATE() BETWEEN SDTCUR AND LDTCUR      
      GROUP BY       
            L.CLTCODE, A.LONGNAME, A.BRANCHCODE      
            
      ------------------------------------------------------------------------------------------      
      --POPULATING BSE CASH SEGMENT LEDGER BALANCES @EDT      
      ------------------------------------------------------------------------------------------      
      INSERT INTO       
            #MPO_LEDGERBALANCE_UP        
      SELECT       
            MPO_PARTYCODE = L.CLTCODE,      
            MPO_PARTYNAME = A.LONGNAME,      
            MPO_EXCHANGE = 'BSE',      
            MPO_SEGMENT = 'CAPITAL',      
            MPO_LEDGERBAL = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE - VAMT END),      
            MPO_RUNBY = @USER,      
            MPO_RUNDATE = GETDATE(),      
            MPO_STATUS = 'I',      
            MPO_CALCBY = @DTBAL,      
            MPO_BRANCHCODE = A.BRANCHCODE       
      FROM       
            ACCOUNTBSE..LEDGER  L,      
            ACCOUNTBSE..ACMAST A,       
            ACCOUNTBSE..PARAMETER P      
      WHERE       
            L.VDT >= SDTCUR       
            AND L.EDT <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:00'      
            AND L.CLTCODE = @FPARTY     
            AND L.CLTCODE = A.CLTCODE      
            AND A.ACCAT = 4      
            AND GETDATE() BETWEEN SDTCUR AND LDTCUR      
      GROUP BY       
            L.CLTCODE, A.LONGNAME, A.BRANCHCODE      
            
      ------------------------------------------------------------------------------------------      
      --POPULATING NSE DERIVATIVES SEGMENT LEDGER BALANCES @EDT      
      ------------------------------------------------------------------------------------------      
/*   
   INSERT INTO       
            #MPO_LEDGERBALANCE_UP        
      SELECT       
            MPO_PARTYCODE = L.CLTCODE,      
            MPO_PARTYNAME = A.LONGNAME,      
            MPO_EXCHANGE = 'NSE',      
            MPO_SEGMENT = 'FUTURES',      
            MPO_LEDGERBAL = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE - VAMT END),      
            MPO_RUNBY = @USER,      
            MPO_RUNDATE = GETDATE(),      
            MPO_STATUS = 'I',      
            MPO_CALCBY = @DTBAL,      
            MPO_BRANCHCODE = A.BRANCHCODE       
      FROM       
            ACCOUNTFO..LEDGER  L,      
            ACCOUNTFO..ACMAST A,       
            ACCOUNTFO..PARAMETER P      
      WHERE       
            L.VDT >= SDTCUR       
            AND L.EDT <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:00'      
            AND L.CLTCODE = @FPARTY     
            AND L.CLTCODE = A.CLTCODE      
            AND A.ACCAT = 4      
            AND GETDATE() BETWEEN SDTCUR AND LDTCUR      
      GROUP BY       
            L.CLTCODE, A.LONGNAME, A.BRANCHCODE      
 */     
      
      IF @DTBAL = 'FDT'  --FOR FUTURE DATED DEBIT AFTER NETTING INTRA-DAY      
      BEGIN      
            ---------------------------------------------------------------------------------------------------------------------      
            --POPULATING NSE CASH SEGMENT LEDGER BALANCES FOR FUTURE DATE DEBITS AFTER NETTING INTRA-DAY      
            ---------------------------------------------------------------------------------------------------------------------      
            INSERT INTO       
                  #MPO_LEDGERBALANCE_UP        
            SELECT       
                  MPO_PARTYCODE = L.CLTCODE,      
                  MPO_PARTYNAME = A.LONGNAME,      
                  MPO_EXCHANGE = 'NSE',      
                  MPO_SEGMENT = 'CAPITAL',      
                  MPO_LEDGERBAL = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE - VAMT END),      
                  MPO_RUNBY = @USER,      
                  MPO_RUNDATE = LEFT(CONVERT(VARCHAR,L.EDT,109),11),      
                  MPO_STATUS = 'I',      
                  MPO_CALCBY = @DTBAL,      
                  MPO_BRANCHCODE = A.BRANCHCODE       
            FROM       
                  ACCOUNT..LEDGER  L,      
                  ACCOUNT..ACMAST A,       
                  ACCOUNT..PARAMETER P      
            WHERE       
                  L.EDT > LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:59'       
                  AND L.VDT <= LDTCUR      
                  AND L.CLTCODE = @FPARTY     
                  AND L.CLTCODE = A.CLTCODE      
                  AND A.ACCAT = 4      
                  AND GETDATE() BETWEEN SDTCUR AND LDTCUR      
            GROUP BY       
                  L.CLTCODE, A.LONGNAME, A.BRANCHCODE, LEFT(CONVERT(VARCHAR,L.EDT,109),11)      
            HAVING SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE - VAMT END) < 0      
   
            ---------------------------------------------------------------------------------------------------------------------      
            --POPULATING BSE CASH SEGMENT LEDGER BALANCES FOR FUTURE DATE DEBITS AFTER NETTING INTRA-DAY      
            ---------------------------------------------------------------------------------------------------------------------      
            INSERT INTO       
                  #MPO_LEDGERBALANCE_UP        
            SELECT       
                  MPO_PARTYCODE = L.CLTCODE,      
                  MPO_PARTYNAME = A.LONGNAME,      
                  MPO_EXCHANGE = 'BSE',      
                  MPO_SEGMENT = 'CAPITAL',      
                  MPO_LEDGERBAL = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE - VAMT END),      
                  MPO_RUNBY = @USER,      
                  MPO_RUNDATE = LEFT(CONVERT(VARCHAR,L.EDT,109),11),      
                  MPO_STATUS = 'I',      
                  MPO_CALCBY = @DTBAL,      
                  MPO_BRANCHCODE = A.BRANCHCODE       
            FROM       
                  ACCOUNTBSE..LEDGER  L,      
                  ACCOUNTBSE..ACMAST A,       
                  ACCOUNTBSE..PARAMETER P      
            WHERE       
                  L.EDT > LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:59'       
                  AND L.VDT <= LDTCUR      
                  AND L.CLTCODE = @FPARTY     
                  AND L.CLTCODE = A.CLTCODE      
                  AND A.ACCAT = 4      
                  AND GETDATE() BETWEEN SDTCUR AND LDTCUR      
            GROUP BY       
                  L.CLTCODE, A.LONGNAME, A.BRANCHCODE, LEFT(CONVERT(VARCHAR,L.EDT,109),11)      
            HAVING SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE - VAMT END) < 0      
      
            ---------------------------------------------------------------------------------------------------------------------      
            --POPULATING NSE DERIVATIVE SEGMENT LEDGER BALANCES FOR FUTURE DATE DEBITS AFTER NETTING INTRA-DAY      
            ---------------------------------------------------------------------------------------------------------------------      
/*  
          INSERT INTO       
                  #MPO_LEDGERBALANCE_UP        
            SELECT       
                  MPO_PARTYCODE = L.CLTCODE,      
                  MPO_PARTYNAME = A.LONGNAME,      
                  MPO_EXCHANGE = 'NSE',      
                  MPO_SEGMENT = 'FUTURES',      
                  MPO_LEDGERBAL = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE - VAMT END),      
                  MPO_RUNBY = @USER,      
                  MPO_RUNDATE = LEFT(CONVERT(VARCHAR,L.EDT,109),11),      
                  MPO_STATUS = 'I',      
                  MPO_CALCBY = @DTBAL,      
                  MPO_BRANCHCODE = A.BRANCHCODE       
            FROM       
                  ACCOUNTFO..LEDGER  L,      
                  ACCOUNTFO..ACMAST A,       
                  ACCOUNTFO..PARAMETER P      
            WHERE       
                  L.EDT > LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:59'       
                  AND L.VDT <= LDTCUR      
                  AND L.CLTCODE = @FPARTY     
                  AND L.CLTCODE = A.CLTCODE      
                  AND A.ACCAT = 4      
                  AND GETDATE() BETWEEN SDTCUR AND LDTCUR      
            GROUP BY       
                  L.CLTCODE, A.LONGNAME, A.BRANCHCODE, LEFT(CONVERT(VARCHAR,L.EDT,109),11)      
            HAVING SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE - VAMT END) < 0      
*/ 
     END --FOR FUTURE DATED DEBIT AFTER NETTING INTRA-DAY      
END    --FOR EDT WISE COMPUTATION      
      
-----------------------------------------------------------------------------------------------------------------------      
--POPULATING DATA IN THE MAIN MONEY PAYOUT LEDGER BALANCE TABLE FOR GIVEN PARTY RANGE AFTER DELETING      
-----------------------------------------------------------------------------------------------------------------------      
      
SELECT       
      --MPO_PARTYCODE,      
      --MPO_PARTYNAME = MAX(MPO_PARTYNAME),      
      --MPO_LEDGERBAL = SUM(MPO_LEDGERBAL),      
      --MPO_RUNDATE = GETDATE(),     
      --MPO_RUNBY = @USER     
 @BALAMT = isnull(SUM(MPO_LEDGERBAL),0)  
FROM       
      #MPO_LEDGERBALANCE_UP      
GROUP BY       
      MPO_PARTYCODE    
  
  
SET @BALAMT = ISNULL(@balamt,0)  
set @errorcode = 0

GO
