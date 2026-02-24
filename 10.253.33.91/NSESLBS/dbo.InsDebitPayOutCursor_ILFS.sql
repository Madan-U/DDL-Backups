-- Object: PROCEDURE dbo.InsDebitPayOutCursor_ILFS
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE PROC INSDEBITPAYOUTCURSOR_ILFS(
           @AcType VARCHAR(4))
AS
  DECLARE  @Party_Code   VARCHAR(10),
           @HoldAmt      NUMERIC(18,6),
           @LedAmt       NUMERIC(18,6),
           @PayVal       NUMERIC(18,6),
           @CurVal       NUMERIC(18,6),
           @Sett_No      VARCHAR(7),
           @Sett_Type    VARCHAR(2),
           @CertNo       VARCHAR(12),
           @Cl_Rate      NUMERIC(18,6),
           @DebitQty     INT,
           @PoolQty      INT,
           @PoolQty_TEMP FLOAT,
           @DpType       VARCHAR(4),
           @PayCur       CURSOR,
           @RecCur       CURSOR,
           @SNo          INT
                         
  TRUNCATE TABLE DELPAYOUT
  
  EXEC BENPAYOUT_LEDGERBAL
  
  /*================================================================================================  
       Getting Holding from All Beneficiary Account From NSE   
================================================================================================*/
  IF @AcType = 'BEN'
    BEGIN
      INSERT INTO DELPAYOUT
      SELECT   'NSE',
               D.SETT_NO,
               D.SETT_TYPE,
               D.PARTY_CODE,
               D.SCRIP_CD,
               D.SERIES,
               D.CERTNO,
               ACTYPE = 'BEN',
               DEBITQTY = SUM(D.QTY),
               PAYQTY = 0,
               SHRTQTY = 0,
               0,
               '',
               LEDBAL = 0,
               EFFBAL = 0,
               CL_RATE = 0,
               GETDATE(),
               0
      FROM     DELTRANS D WITH (Index (DelHold ),NOLOCK),
               DELIVERYDP DP WITH(NOLOCK)
      WHERE    DRCR = 'D'
               AND FILLER2 = 1
               AND DELIVERED = '0'
               AND BCLTDPID = DP.DPCLTNO
               AND BDPID = DP.DPID
               AND DESCRIPTION NOT LIKE '%POOL%'
	       AND AccountType <> 'MAR'	
               AND TRTYPE = 904
               AND CERTNO LIKE 'IN%'
               AND PARTY_CODE NOT IN ('BROKER','Party','EXE')
      GROUP BY D.SETT_NO,D.SETT_TYPE,D.PARTY_CODE,D.SCRIP_CD,
               D.SERIES,D.CERTNO
               
      INSERT INTO DELPAYOUT
      SELECT   'BSE',
               D.SETT_NO,
               D.SETT_TYPE,
               D.PARTY_CODE,
               D.SCRIP_CD,
               D.SERIES,
               D.CERTNO,
               ACTYPE = 'BEN',
               DEBITQTY = SUM(D.QTY),
               PAYQTY = 0,
               SHRTQTY = 0,
               0,
               '',
               LEDBAL = 0,
               EFFBAL = 0,
               CL_RATE = 0,
               GETDATE(),
               0
      FROM     BSEDB.DBO.DELTRANS D WITH (Index (DelHold ),NOLOCK),
               BSEDB.DBO.DELIVERYDP DP WITH(NOLOCK) 
      WHERE    DRCR = 'D'
               AND FILLER2 = 1
               AND DELIVERED = '0'
               AND BCLTDPID = DP.DPCLTNO
               AND BDPID = DP.DPID
               AND DESCRIPTION NOT LIKE '%POOL%'
	       AND AccountType <> 'MAR'	
               AND TRTYPE = 904
               AND CERTNO LIKE 'IN%'
               AND PARTY_CODE NOT IN ('BROKER','Party','EXE')
      GROUP BY D.SETT_NO,D.SETT_TYPE,D.PARTY_CODE,D.SCRIP_CD,
               D.SERIES,D.CERTNO
    END
    
  IF @AcType = 'POOL'
    BEGIN
      INSERT INTO DELPAYOUT
      SELECT   'NSE',
               D.SETT_NO,
               D.SETT_TYPE,
               D.PARTY_CODE,
               D.SCRIP_CD,
               D.SERIES,
               D.CERTNO,
               ACTYPE = 'POOL',
               DEBITQTY = 0,
               PAYQTY = 0,
               SHRTQTY = 0,
               POOLQTY = SUM(D.QTY),
               BDPTYPE,
               LEDBAL = 0,
               EFFBAL = 0,
               CL_RATE = 0,
               GETDATE(),
               0
      FROM     DELTRANS D WITH (Index (DelHold ),NOLOCK),
               DELIVERYDP DP WITH(NOLOCK) 
      WHERE    DRCR = 'D'
               AND FILLER2 = 1
               AND DELIVERED = '0'
               AND BCLTDPID = DP.DPCLTNO
               AND BDPID = DP.DPID
               AND DESCRIPTION LIKE '%POOL%'
	       AND AccountType <> 'MAR'	
               AND TRTYPE = 904
               AND CERTNO LIKE 'IN%'
               AND PARTY_CODE NOT IN ('BROKER','Party','EXE')
      GROUP BY D.SETT_NO,D.SETT_TYPE,D.PARTY_CODE,D.SCRIP_CD,
               D.SERIES,D.CERTNO,BDPTYPE
               
      INSERT INTO DELPAYOUT
      SELECT   'BSE',
               D.SETT_NO,
               D.SETT_TYPE,
               D.PARTY_CODE,
               D.SCRIP_CD,
               D.SERIES,
               D.CERTNO,
               ACTYPE = 'POOL',
               DEBITQTY = 0,
               PAYQTY = 0,
               SHRTQTY = 0,
               POOLQTY = SUM(D.QTY),
               BDPTYPE,
               LEDBAL = 0,
               EFFBAL = 0,
               CL_RATE = 0,
               GETDATE(),
               0
      FROM     BSEDB.DBO.DELTRANS D WITH (Index (DelHold ),NOLOCK),
               BSEDB.DBO.DELIVERYDP DP WITH(NOLOCK)
      WHERE    DRCR = 'D'
               AND FILLER2 = 1
               AND DELIVERED = '0'
               AND BCLTDPID = DP.DPCLTNO
               AND BDPID = DP.DPID
               AND DESCRIPTION LIKE '%POOL%'
	       AND AccountType <> 'MAR'	
               AND TRTYPE = 904
               AND CERTNO LIKE 'IN%'
               AND PARTY_CODE NOT IN ('BROKER','Party','EXE')
      GROUP BY D.SETT_NO,D.SETT_TYPE,D.PARTY_CODE,D.SCRIP_CD,
               D.SERIES,D.CERTNO,BDPTYPE
    END
    
  /*================================================================================================  
       Populate Latest Closing Prices For All Securities  
================================================================================================*/
  SELECT SCRIP_CD,
         SERIES,
         CL_RATE,
         SYSDATE
  INTO   #NSE_LATESTCLOSING
  FROM   CLOSING C WITH (NOLOCK)
  WHERE  SYSDATE = (SELECT MAX(SYSDATE)
                    FROM   CLOSING WITH (NOLOCK)
                    WHERE  SCRIP_CD = C.SCRIP_CD
                           AND SERIES = C.SERIES)
                   
  SELECT SCRIP_CD,
         SERIES,
         CL_RATE,
         SYSDATE
  INTO   #BSE_LATESTCLOSING
  FROM   BSEDB.DBO.CLOSING C WITH (NOLOCK)
  WHERE  SYSDATE = (SELECT MAX(SYSDATE)
                    FROM   BSEDB.DBO.CLOSING WITH (NOLOCK)
                    WHERE  SCRIP_CD = C.SCRIP_CD
                           AND SERIES = C.SERIES)
                   
  /*================================================================================================  
      Update Latest Closing Prices  
================================================================================================*/
  UPDATE DELPAYOUT
  SET    CL_RATE = C.CL_RATE
  FROM   #NSE_LATESTCLOSING C
  WHERE  C.SCRIP_CD = DELPAYOUT.SCRIP_CD
         AND C.SERIES = DELPAYOUT.SERIES
                        
  UPDATE DELPAYOUT
  SET    CL_RATE = C.CL_RATE
  FROM   #BSE_LATESTCLOSING C
  WHERE  C.SCRIP_CD = DELPAYOUT.SCRIP_CD
         AND C.SERIES = DELPAYOUT.SERIES
                        
  /*================================================================================================  
      Update Security Payout Dates  
================================================================================================*/
  UPDATE DELPAYOUT
  SET    PAYOUTDATE = SEC_PAYOUT
  FROM   SETT_MST S
  WHERE  S.SETT_NO = DELPAYOUT.SETT_NO
         AND S.SETT_TYPE = DELPAYOUT.SETT_TYPE
         AND DELPAYOUT.EXCHANGE = 'NSE'
                                  
  UPDATE DELPAYOUT
  SET    PAYOUTDATE = SEC_PAYOUT
  FROM   BSEDB.DBO.SETT_MST S
  WHERE  S.SETT_NO = DELPAYOUT.SETT_NO
         AND S.SETT_TYPE = DELPAYOUT.SETT_TYPE
         AND DELPAYOUT.EXCHANGE = 'BSE'
                                  
  SELECT PARTY_CODE,
         BAL = ((CASE 
                   WHEN EDTBAL < 0 THEN EDTBAL * DEBITBALPERCENTAGE / 100
                   ELSE EDTBAL
                 END)) - FUTBAL
  INTO   #PAYOUT_LEDGER
  FROM   (SELECT   PARTY_CODE,
                   EDTBAL = SUM(CASE 
                                  WHEN EXCHANGE = 'NSE'
                                       AND SEGMENT = 'FUTURES' THEN (CASE 
                                                                       WHEN (EDTBAL - MARGINREQ) < 0 THEN (EDTBAL - MARGINREQ)
                                                                       ELSE 0
                                                                     END)
                                  ELSE EDTBAL
                                END),
                   FUTBAL = SUM(FUTBAL) * FUTBALPERCENTAGE / 100,
                   DEBITBALPERCENTAGE
          FROM     (SELECT   PARTY_CODE,
                             PAYOUT_LEDGER.CL_TYPE,
                             EXCHANGE,
                             SEGMENT,
                             EDTBAL = SUM(EDTBAL),
                             FUTBAL = SUM(FUTBAL),
                             MARGINREQ = (CASE 
                                            WHEN SUM(INITIALMARGIN + EXPOSUREMARGIN - COLLATERALAMT) > 0
                                                 AND ISNULL(MARGINFLAG,'Y') = 'Y' THEN SUM(INITIALMARGIN + EXPOSUREMARGIN - COLLATERALAMT)
                                            WHEN SUM(INITIALMARGIN - COLLATERALAMT) > 0
                                                 AND ISNULL(MARGINFLAG,'Y') = 'I' THEN SUM(INITIALMARGIN - COLLATERALAMT)
                                            WHEN SUM(EXPOSUREMARGIN - COLLATERALAMT) > 0
                                                 AND ISNULL(MARGINFLAG,'Y') = 'E' THEN SUM(EXPOSUREMARGIN - COLLATERALAMT)
                                            ELSE 0
                                          END),
                             DEBITBALPERCENTAGE = ISNULL(DEBITBALPERCENTAGE,0),
                             FUTBALPERCENTAGE = ISNULL(FUTBALPERCENTAGE,0)
                    FROM     PAYOUT_LEDGER
                             LEFT OUTER JOIN CLIENTTYPE
                               ON (PAYOUT_LEDGER.CL_TYPE = CLIENTTYPE.CL_TYPE)
                    GROUP BY PARTY_CODE,PAYOUT_LEDGER.CL_TYPE,EXCHANGE,SEGMENT,
                             ISNULL(MARGINFLAG,'Y'),ISNULL(DEBITBALPERCENTAGE,0),ISNULL(FUTBALPERCENTAGE,0)) PAYOUT_LEDGER
          GROUP BY PARTY_CODE,DEBITBALPERCENTAGE,FUTBALPERCENTAGE) PAYOUT_LEDGER
         
  UPDATE DELPAYOUT
  SET    LEDBAL = A.BAL
  FROM   #PAYOUT_LEDGER A
  WHERE  A.PARTY_CODE = DELPAYOUT.PARTY_CODE
                        
  /*====================================================================================================================    
      Update Payout Qty for Clients set as Always Payout (DebitFLag = 1).     
====================================================================================================================*/
  IF @AcType = 'BEN'
    BEGIN
      UPDATE DELPAYOUT
      SET    ACTPAYOUT = DEBITQTY
      FROM   (SELECT PARTY_CODE
              FROM   DELPARTYFLAG WITH(NOLOCK)
              WHERE  DEBITFLAG = 1
              UNION 
              SELECT PARTY_CODE
              FROM   BSEDB.DBO.DELPARTYFLAG WITH(NOLOCK)
              WHERE  DEBITFLAG = 1) D
      WHERE  DEBITQTY > 0
             AND DELPAYOUT.PARTY_CODE = D.PARTY_CODE
                                        
      UPDATE DELPAYOUT
      SET    ACTPAYOUT = DEBITQTY
      WHERE  LEDBAL >= 0
             AND DEBITQTY > 0
                            
      SET @PAYCUR = CURSOR FOR SELECT   PARTY_CODE,
                                        LEDBAL,
                                        HOLDAMT = SUM(DEBITQTY * CL_RATE)
                               FROM     DELPAYOUT WITH(NOLOCK)
                               WHERE    ACTPAYOUT = 0
                               GROUP BY PARTY_CODE,LEDBAL
                               ORDER BY PARTY_CODE
      
      OPEN @PAYCUR
      
      FETCH NEXT FROM @PAYCUR
      INTO @PARTY_CODE,
           @LEDAMT,
           @HOLDAMT
      
      WHILE @@FETCH_STATUS = 0
        BEGIN
          SELECT @PAYVAL = @LEDAMT + @HOLDAMT
          
          SELECT @CURVAL = 0
          
          SET @RECCUR = CURSOR FOR SELECT   SNO,
                                            SETT_NO,
                                            SETT_TYPE,
                                            CERTNO,
                                            DEBITQTY,
                                            CL_RATE,
                                            DPTYPE
                                   FROM     DELPAYOUT WITH(NOLOCK)
                                   WHERE    CL_RATE > 0
                                            AND PARTY_CODE = @PARTY_CODE
                                   ORDER BY EXCHANGE,
                                            PAYOUTDATE,
                                            CL_RATE,
                                            SETT_NO,
                                            SCRIP_CD
          
          OPEN @RECCUR
          
          FETCH NEXT FROM @RECCUR
          INTO @SNO,
               @SETT_NO,
               @SETT_TYPE,
               @CERTNO,
               @DEBITQTY,
               @CL_RATE,
               @DPTYPE
          
          WHILE @@FETCH_STATUS = 0
                AND @PAYVAL > 0
            BEGIN
              SELECT @CURVAL = @DEBITQTY * @CL_RATE
              
              IF @CURVAL <= @PAYVAL
                BEGIN
                  UPDATE DELPAYOUT
                  SET    ACTPAYOUT = @DEBITQTY
                  WHERE  SNO = @SNO
                  
                  /*SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE  
                   AND PARTY_CODE = @PARTY_CODE  
     AND CERTNO = @CERTNO   
     AND DPTYPE = @DPTYPE*/
                  SELECT @PAYVAL = @PAYVAL - @CURVAL
                END
              ELSE
                BEGIN
                  SELECT @POOLQTY_TEMP = @PAYVAL / @CL_RATE
                                                   
                  IF @POOLQTY_TEMP >= CONVERT(INT,@POOLQTY_TEMP)
                    SELECT @DEBITQTY = CONVERT(INT,@POOLQTY_TEMP)
                  ELSE
                    SELECT @DEBITQTY = CONVERT(INT,@POOLQTY_TEMP) - 1
                                                                    
                  UPDATE DELPAYOUT
                  SET    ACTPAYOUT = @DEBITQTY
                  WHERE  SNO = @SNO
                  
                  /*                          WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE  
                   AND PARTY_CODE = @PARTY_CODE  
     AND CERTNO = @CERTNO   
     AND DPTYPE = @DPTYPE*/
                  SELECT @PAYVAL = 0
                                   
                --     SELECT @PAYVAL = @PAYVAL - (@DEBITQTY * @CL_RATE)
                END
              
              FETCH NEXT FROM @RECCUR
              INTO @SNO,
                   @SETT_NO,
                   @SETT_TYPE,
                   @CERTNO,
                   @DEBITQTY,
                   @CL_RATE,
                   @DPTYPE
            END
          
          CLOSE @RECCUR
          
          DEALLOCATE @RECCUR
          
          FETCH NEXT FROM @PAYCUR
          INTO @PARTY_CODE,
               @LEDAMT,
               @HOLDAMT
        END
      
      CLOSE @PAYCUR
      
      DEALLOCATE @PAYCUR
      
      /*====================================================================================================================    
      Update Payout Qty for Clients set as Always Transfer To Ben (DebitFLag = 2).     
====================================================================================================================*/
      UPDATE DELPAYOUT
      SET    ACTPAYOUT = 0
      FROM   (SELECT PARTY_CODE
              FROM   DELPARTYFLAG WITH(NOLOCK) 
              WHERE  DEBITFLAG = 2
              UNION 
              SELECT PARTY_CODE
              FROM   BSEDB.DBO.DELPARTYFLAG WITH(NOLOCK) 
              WHERE  DEBITFLAG = 2) D
      WHERE  DEBITQTY > 0
             AND DELPAYOUT.PARTY_CODE = D.PARTY_CODE
    END
  ELSE
    BEGIN
      UPDATE DELPAYOUT
      SET    ACTPAYOUT = POOLQTY
      FROM   (SELECT PARTY_CODE
              FROM   DELPARTYFLAG WITH(NOLOCK) 
              WHERE  DEBITFLAG = 1
              UNION 
              SELECT PARTY_CODE
              FROM   BSEDB.DBO.DELPARTYFLAG WITH(NOLOCK) 
              WHERE  DEBITFLAG = 1) D
      WHERE  POOLQTY > 0
             AND DELPAYOUT.PARTY_CODE = D.PARTY_CODE
                                        
      UPDATE DELPAYOUT
      SET    ACTPAYOUT = POOLQTY
      WHERE  LEDBAL >= 0
             AND POOLQTY > 0
                           
      SET @PAYCUR = CURSOR FOR SELECT   PARTY_CODE,
                                        LEDBAL,
                                        HOLDAMT = SUM(POOLQTY * CL_RATE)
                               FROM     DELPAYOUT WITH(NOLOCK) 
                               WHERE    ACTPAYOUT = 0
                               GROUP BY PARTY_CODE,LEDBAL
                               ORDER BY PARTY_CODE
      
      OPEN @PAYCUR
      
      FETCH NEXT FROM @PAYCUR
      INTO @PARTY_CODE,
           @LEDAMT,
           @HOLDAMT
      
      WHILE @@FETCH_STATUS = 0
        BEGIN
          SELECT @PAYVAL = @LEDAMT + @HOLDAMT
          
          SELECT @CURVAL = 0
          
          SET @RECCUR = CURSOR FOR SELECT   SNO,
                                            SETT_NO,
                                            SETT_TYPE,
                                            CERTNO,
                                            POOLQTY,
                                            CL_RATE,
                                            DPTYPE
                                   FROM     DELPAYOUT WITH(NOLOCK) 
                                   WHERE    CL_RATE > 0
                                            AND PARTY_CODE = @PARTY_CODE
                                            AND ACTPAYOUT = 0
                                   ORDER BY EXCHANGE,
                                            PAYOUTDATE,
                                            CL_RATE,
                                            SETT_NO,
                                            SCRIP_CD
          
          OPEN @RECCUR
          
          FETCH NEXT FROM @RECCUR
          INTO @SNO,
               @SETT_NO,
               @SETT_TYPE,
               @CERTNO,
               @PoolQty,
               @CL_RATE,
               @DPTYPE
          
          WHILE @@FETCH_STATUS = 0
                AND @PAYVAL > 0
            BEGIN
              SELECT @CURVAL = @PoolQty * @CL_RATE
              
              IF @CURVAL <= @PAYVAL
                BEGIN
                  UPDATE DELPAYOUT WITH(ROWLOCK) 
                  SET    ACTPAYOUT = @PoolQty
                  WHERE  SNO = @SNO
                  
                  /*                          WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE  
                   AND PARTY_CODE = @PARTY_CODE  
     AND CERTNO = @CERTNO   
     AND DPTYPE = @DPTYPE*/
                  SELECT @PAYVAL = @PAYVAL - @CURVAL
                END
              ELSE
                BEGIN
                  SELECT @POOLQTY_TEMP = @PAYVAL / @CL_RATE
                                                   
                  IF @POOLQTY_TEMP >= CONVERT(INT,@POOLQTY_TEMP)
                    SELECT @PoolQty = CONVERT(INT,@POOLQTY_TEMP)
                  ELSE
                    SELECT @PoolQty = CONVERT(INT,@POOLQTY_TEMP) - 1
                                                                   
                  UPDATE DELPAYOUT WITH(ROWLOCK) 
                  SET    ACTPAYOUT = @PoolQty
                  WHERE  SNO = @SNO
                  
                  /*                          WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE  
                   AND PARTY_CODE = @PARTY_CODE  
     AND CERTNO = @CERTNO   
     AND DPTYPE = @DPTYPE*/
                  SELECT @PAYVAL = 0
                                   
                --     SELECT @PAYVAL = @PAYVAL - (@PoolQty * @CL_RATE)
                END
              
              FETCH NEXT FROM @RECCUR
              INTO @SNO,
                   @SETT_NO,
                   @SETT_TYPE,
                   @CERTNO,
                   @PoolQty,
                   @CL_RATE,
                   @DPTYPE
            END
          
          CLOSE @RECCUR
          
          DEALLOCATE @RECCUR
          
          FETCH NEXT FROM @PAYCUR
          INTO @PARTY_CODE,
               @LEDAMT,
               @HOLDAMT
        END
      
      CLOSE @PAYCUR
      
      DEALLOCATE @PAYCUR
      
      /*====================================================================================================================    
      Update Payout Qty for Clients set as Always Transfer To Ben (DebitFLag = 2).     
====================================================================================================================*/
      UPDATE DELPAYOUT
      SET    ACTPAYOUT = 0
      FROM   (SELECT PARTY_CODE
              FROM   DELPARTYFLAG WITH(NOLOCK) 
              WHERE  DEBITFLAG = 2
              UNION 
              SELECT PARTY_CODE
              FROM   BSEDB.DBO.DELPARTYFLAG WITH(NOLOCK) 
              WHERE  DEBITFLAG = 2) D
      WHERE  POOLQTY > 0
             AND DELPAYOUT.PARTY_CODE = D.PARTY_CODE
    END
  
  INSERT INTO DELPAYOUTLOG
  SELECT EXCHANGE,
         SETT_NO,
         SETT_TYPE,
         PARTY_CODE,
         SCRIP_CD,
         SERIES,
         CERTNO,
         ACTYPE,
         DEBITQTY,
         PAYQTY,
         SHRTQTY,
         POOLQTY,
         DPTYPE,
         LEDBAL,
         EFFBAL,
         CL_RATE,
         PAYOUTDATE,
         ACTPAYOUT,
         RUNDATE = GETDATE()
  FROM   DELPAYOUT
         
  UPDATE DELPAYOUT
  SET    PAYOUTDATE = GETDATE()

GO
