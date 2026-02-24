-- Object: PROCEDURE dbo.BENPAYOUT_LEDGERBAL
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROC BENPAYOUT_LEDGERBAL

AS

  DECLARE  @MarginDate VARCHAR(11)
                       
  TRUNCATE TABLE PAYOUT_LEDGER
  
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED
  
  /*=========================================================================================================    
      NSE CASH Effective Date Wise Balance    
=========================================================================================================*/
  INSERT INTO PAYOUT_LEDGER
  SELECT   PARTY_CODE = CLTCODE,
           CL_TYPE = '',
           EXCHANGE = 'NSE',
           SEGMENT = 'CAPITAL',
           EDTBAL = SUM(CASE 
                          WHEN DRCR = 'C' THEN VAMT
                          ELSE -VAMT
                        END),
           FUTBAL = 0,
           INITIALMARGIN = 0,
           EXPOSUREMARGIN = 0,
           COLLATERALAMT = 0
  FROM     ACCOUNT.DBO.LEDGER L WITH (nolock),
           ACCOUNT.DBO.PARAMETER P WITH(NOLOCK) 
  WHERE    EDT <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:59'
           AND EDT >= SDTCUR
           AND EDT <= LDTCUR
           AND CURYEAR = 1
  GROUP BY CLTCODE
           
  /*=========================================================================================================    
      NSE CASH Effective Date Wise Reverse Effect for over-lapping     
=========================================================================================================*/
  INSERT INTO PAYOUT_LEDGER
  SELECT   PARTY_CODE = CLTCODE,
           CL_TYPE = '',
           EXCHANGE = 'NSE',
           SEGMENT = 'CAPITAL',
           EDTBAL = SUM(CASE 
                          WHEN DRCR = 'D' THEN VAMT
                          ELSE -VAMT
                        END),
           FUTBAL = 0,
           INITIALMARGIN = 0,
           EXPOSUREMARGIN = 0,
           COLLATERALAMT = 0
  FROM     ACCOUNT.DBO.LEDGER L WITH (nolock),
           ACCOUNT.DBO.PARAMETER P WITH(NOLOCK) 
  WHERE    EDT <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:59'
           AND VDT < SDTCUR
           AND EDT >= SDTCUR
           AND CURYEAR = 1
  GROUP BY CLTCODE
           
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED
  
  /*=========================================================================================================    
      NSE CASH Future Dated Balance     
=========================================================================================================*/
  INSERT INTO PAYOUT_LEDGER
  SELECT   PARTY_CODE = CLTCODE,
           CL_TYPE = '',
           EXCHANGE = 'NSE',
           SEGMENT = 'CAPITAL',
           EDTBAL = 0,
           FUTBAL = SUM(CASE 
                          WHEN DRCR = 'D' THEN VAMT
                          ELSE -VAMT
                        END),
           INITIALMARGIN = 0,
           EXPOSUREMARGIN = 0,
           COLLATERALAMT = 0
  FROM     ACCOUNT.DBO.LEDGER L WITH (nolock),
           ACCOUNT.DBO.PARAMETER P WITH(NOLOCK) 
  WHERE    VDT <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:59'
           AND VDT >= SDTCUR
           AND VDT <= LDTCUR
           AND EDT >= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:59'
           AND CURYEAR = 1
           AND DRCR = 'D'
  GROUP BY CLTCODE
           
  /*=========================================================================================================    
      BSE CASH Effective Date Wise Balance    
=========================================================================================================*/
  INSERT INTO PAYOUT_LEDGER
  SELECT   PARTY_CODE = CLTCODE,
           CL_TYPE = '',
           EXCHANGE = 'BSE',
           SEGMENT = 'CAPITAL',
           EDTBAL = SUM(CASE 
                          WHEN DRCR = 'C' THEN VAMT
                          ELSE -VAMT
                        END),
           FUTBAL = 0,
           INITIALMARGIN = 0,
           EXPOSUREMARGIN = 0,
           COLLATERALAMT = 0
  FROM     ACCOUNTBSE.DBO.LEDGER L WITH (nolock),
           ACCOUNTBSE.DBO.PARAMETER P WITH(NOLOCK) 
  WHERE    EDT <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:59'
           AND EDT >= SDTCUR
           AND EDT <= LDTCUR
           AND CURYEAR = 1
  GROUP BY CLTCODE
           
  /*=========================================================================================================    
      BSE CASH Effective Date Wise Reverse Effect for over-lapping     
=========================================================================================================*/
  INSERT INTO PAYOUT_LEDGER
  SELECT   PARTY_CODE = CLTCODE,
           CL_TYPE = '',
           EXCHANGE = 'BSE',
           SEGMENT = 'CAPITAL',
           EDTBAL = SUM(CASE 
                          WHEN DRCR = 'D' THEN VAMT
                          ELSE -VAMT
                        END),
           FUTBAL = 0,
           INITIALMARGIN = 0,
           EXPOSUREMARGIN = 0,
           COLLATERALAMT = 0
  FROM     ACCOUNTBSE.DBO.LEDGER L WITH (nolock),
           ACCOUNTBSE.DBO.PARAMETER P WITH(NOLOCK) 
  WHERE    EDT <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:59'
           AND VDT < SDTCUR
           AND EDT >= SDTCUR
           AND CURYEAR = 1
  GROUP BY CLTCODE
           
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED
  
  /*=========================================================================================================    
      BSE CASH Future Dated Balance     
=========================================================================================================*/
  INSERT INTO PAYOUT_LEDGER
  SELECT   PARTY_CODE = CLTCODE,
           CL_TYPE = '',
           EXCHANGE = 'BSE',
           SEGMENT = 'CAPITAL',
           EDTBAL = 0,
           FUTBAL = SUM(CASE 
                          WHEN DRCR = 'D' THEN VAMT
                          ELSE -VAMT
                        END),
           INITIALMARGIN = 0,
           EXPOSUREMARGIN = 0,
           COLLATERALAMT = 0
  FROM     ACCOUNTBSE.DBO.LEDGER L WITH (nolock),
           ACCOUNTBSE.DBO.PARAMETER P WITH(NOLOCK) 
  WHERE    VDT <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:59'
           AND VDT >= SDTCUR
           AND VDT <= LDTCUR
           AND EDT >= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:59'
           AND CURYEAR = 1
           AND DRCR = 'D'
  GROUP BY CLTCODE
           
  /*=========================================================================================================    
      NSE FUTURES Effective Date Wise Balance    
=========================================================================================================*/
  INSERT INTO PAYOUT_LEDGER
  SELECT   PARTY_CODE = CLTCODE,
           CL_TYPE = '',
           EXCHANGE = 'NSE',
           SEGMENT = 'FUTURES',
           EDTBAL = SUM(CASE 
                          WHEN DRCR = 'C' THEN VAMT
                          ELSE -VAMT
                        END),
           FUTBAL = 0,
           INITIALMARGIN = 0,
           EXPOSUREMARGIN = 0,
           COLLATERALAMT = 0
  FROM     ACCOUNTFO.DBO.LEDGER L WITH (nolock),
           ACCOUNTFO.DBO.PARAMETER P WITH(NOLOCK) 
  WHERE    EDT <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:59'
           AND EDT >= SDTCUR
           AND EDT <= LDTCUR
           AND CURYEAR = 1
  GROUP BY CLTCODE
           
  /*=========================================================================================================    
      NSE FUTURES Effective Date Wise Reverse Effect for over-lapping     
=========================================================================================================*/
  INSERT INTO PAYOUT_LEDGER
  SELECT   PARTY_CODE = CLTCODE,
           CL_TYPE = '',
           EXCHANGE = 'NSE',
           SEGMENT = 'FUTURES',
           EDTBAL = SUM(CASE 
                          WHEN DRCR = 'D' THEN VAMT
                          ELSE -VAMT
                        END),
           FUTBAL = 0,
           INITIALMARGIN = 0,
           EXPOSUREMARGIN = 0,
           COLLATERALAMT = 0
  FROM     ACCOUNTFO.DBO.LEDGER L WITH (nolock),
           ACCOUNTFO.DBO.PARAMETER P WITH(NOLOCK) 
  WHERE    EDT <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:59'
           AND VDT < SDTCUR
           AND EDT >= SDTCUR
           AND CURYEAR = 1
  GROUP BY CLTCODE
           
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED
  
  /*=========================================================================================================    
      NSE FUTURES Future Dated Balance     
=========================================================================================================*/
  INSERT INTO PAYOUT_LEDGER
  SELECT   PARTY_CODE = CLTCODE,
           CL_TYPE = '',
           EXCHANGE = 'NSE',
           SEGMENT = 'FUTURES',
           EDTBAL = 0,
           FUTBAL = SUM(CASE 
                          WHEN DRCR = 'D' THEN VAMT
                          ELSE -VAMT
                        END),
           INITIALMARGIN = 0,
           EXPOSUREMARGIN = 0,
           COLLATERALAMT = 0
  FROM     ACCOUNTFO.DBO.LEDGER L WITH (nolock),
           ACCOUNTFO.DBO.PARAMETER P WITH(NOLOCK) 
  WHERE    VDT <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:59'
           AND VDT >= SDTCUR
           AND VDT <= LDTCUR
           AND EDT >= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:59'
           AND CURYEAR = 1
           AND DRCR = 'D'
  GROUP BY CLTCODE
           
  SELECT @MarginDate = LEFT(MAX(MDATE),11)
  FROM   NSEFO.DBO.FOMARGINNEW WITH(NOLOCK) 
  WHERE  MDATE <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:59'
                                                            
  INSERT INTO PAYOUT_LEDGER
  SELECT PARTY_CODE,
         CL_TYPE = '',
         EXCHANGE = 'NSE',
         SEGMENT = 'FUTURES',
         EDTBAL = 0,
         FUTBAL = 0,
         INITIALMARGIN = Spreadmargin,
         EXPOSUREMARGIN = MTOM,
         COLLATERALAMT = 0
  FROM   NSEFO.DBO.FOMARGINNEW WITH(NOLOCK) 
  WHERE  MDATE LIKE @MarginDate + '%'
                                  
  SELECT @MarginDate = LEFT(MAX(TRANS_DATE),11)
  FROM   MSAJAG.DBO.COLLATERAL WITH(NOLOCK) 
  WHERE  TRANS_DATE <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59:59'
         AND EXCHANGE = 'NSE'
         AND SEGMENT = 'FUTURES'
                       
  INSERT INTO PAYOUT_LEDGER
  SELECT PARTY_CODE,
         CL_TYPE = '',
         EXCHANGE = 'NSE',
         SEGMENT = 'FUTURES',
         EDTBAL = 0,
         FUTBAL = 0,
         INITIALMARGIN = 0,
         EXPOSUREMARGIN = 0,
         COLLATERALAMT = CASH + NONCASH
  FROM   MSAJAG.DBO.COLLATERAL WITH(NOLOCK) 
  WHERE  TRANS_DATE LIKE @MarginDate + '%'
         AND EXCHANGE = 'NSE'
         AND SEGMENT = 'FUTURES'
                       
  UPDATE PAYOUT_LEDGER WITH(ROWLOCK)
  SET    CL_TYPE = C1.CL_TYPE
  FROM   MSAJAG.DBO.CLIENT1 C1 WITH(NOLOCK),
         MSAJAG.DBO.CLIENT2 C2 WITH(NOLOCK) 
  WHERE  C1.CL_CODE = C2.CL_CODE
         AND C2.PARTY_CODE = PAYOUT_LEDGER.PARTY_CODE
         AND PAYOUT_LEDGER.CL_TYPE = ''
                                     
  UPDATE PAYOUT_LEDGER WITH(ROWLOCK)
  SET    CL_TYPE = C1.CL_TYPE
  FROM   BSEDB.DBO.CLIENT1 C1 WITH(NOLOCK),
         BSEDB.DBO.CLIENT2 C2 WITH(NOLOCK) 
  WHERE  C1.CL_CODE = C2.CL_CODE
         AND C2.PARTY_CODE = PAYOUT_LEDGER.PARTY_CODE
         AND PAYOUT_LEDGER.CL_TYPE = ''
                                     
  UPDATE PAYOUT_LEDGER WITH(ROWLOCK)
  SET    CL_TYPE = C1.CL_TYPE
  FROM   NSEFO.DBO.CLIENT1 C1 WITH(NOLOCK),
         NSEFO.DBO.CLIENT2 C2 WITH(NOLOCK) 
  WHERE  C1.CL_CODE = C2.CL_CODE
         AND C2.PARTY_CODE = PAYOUT_LEDGER.PARTY_CODE
         AND PAYOUT_LEDGER.CL_TYPE = ''

GO
