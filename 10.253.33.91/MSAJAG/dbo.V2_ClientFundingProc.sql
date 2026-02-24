-- Object: PROCEDURE dbo.V2_ClientFundingProc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC [DBO].[V2_CLIENTFUNDINGPROC]                
(                
      @STARTDATE VARCHAR(11),                
      @ENDDATE VARCHAR(11),                
      @FPARTY VARCHAR(10),                
      @TPARTY VARCHAR(10)                
)                
                
AS                
                
/*----------------------------------------------------------------------------------------------------------------------                
CLIENT FUNDING PROCESS: FINAL VERSION SEP 16 2005                
----------------------------------------------------------------------------------------------------------------------*/                
      SET NOCOUNT ON                
                      
      IF @STARTDATE = '' OR LEN(LTRIM(RTRIM(@STARTDATE))) <> 11                
      BEGIN                
            SELECT RUNDATE = GETDATE(), RUNDATE_109 = 'PLEASE ENTER CORRECT START DATE'                
            RETURN                
      END                
                      
      IF @ENDDATE = '' OR LEN(LTRIM(RTRIM(@ENDDATE))) <> 11                
      BEGIN                
            SELECT RUNDATE = GETDATE(), RUNDATE_109 = 'PLEASE ENTER CORRECT END DATE'                
            RETURN                
      END                
                      
                      
      DECLARE                
            @LEDRCUR CURSOR,                 
            @RUNDATE VARCHAR(11),                
            @DATEDIFF INT                
                            
      SELECT @DATEDIFF = DATEDIFF(DAY,CONVERT(DATETIME,@STARTDATE),CONVERT(DATETIME,@ENDDATE))                
                      
      IF @DATEDIFF < 0                 
      BEGIN                
            SELECT RUNDATE = GETDATE(), RUNDATE_109 = 'START DATE CANNOT BE GREATER THAN END DATE'                
            RETURN                
      END                
                      
      IF @DATEDIFF > 15                 
      BEGIN                
            SELECT RUNDATE = GETDATE(), RUNDATE_109 = 'PROCESS CANNOT BE EXECUTED FOR MORE THAN 15 DAYS'                
            RETURN                
      END                
                      
      CREATE TABLE #DATECOUNT                
      (                      
            RUNDATE DATETIME                
      )                
                
/*----------------------------------------------------------------------------------------------------------------------                
CURSOR TO GET THE PAY-IN DATES FOR WHICH PROCESS IS TO BE EXECUTED BASED ON THE PARAMETERS PROVIDED.                
----------------------------------------------------------------------------------------------------------------------*/                
      SET @LEDRCUR = CURSOR FOR                                     
                
      /*-----------------------                
      CURSOR QUERY BEGINS                
      -------------------------*/                
            SELECT DISTINCT                 
                  RUNDATE = LEFT(CONVERT(VARCHAR,PAYIN_DATE,109),11)                 
            FROM                 
                  ACCBILL                 
            WHERE PAYIN_DATE BETWEEN @STARTDATE AND @ENDDATE + ' 23:59'                
                      
            UNION                 
                      
            SELECT DISTINCT                 
                  RUNDATE = LEFT(CONVERT(VARCHAR,MARGIN_DATE,109),11)                 
            FROM                 
                  TBL_MG02 (NOLOCK)                
            WHERE                 
                  MARGIN_DATE BETWEEN @STARTDATE AND @ENDDATE + ' 23:59'                 
      /*-----------------------                
      CURSOR QUERY ENDS                
      -------------------------*/                
                      
      OPEN @LEDRCUR                                    
      FETCH NEXT FROM @LEDRCUR                 
      INTO                 
            @RUNDATE                
                
      WHILE @@FETCH_STATUS = 0                                
      BEGIN                                    
            IF @RUNDATE = '' OR LEN(LTRIM(RTRIM(@RUNDATE))) <> 11                
        BEGIN                
                  SELECT RUNDATE = GETDATE(), RUNDATE_109 = 'DATE NOT FOUND'                
                  RETURN                
            END                
                       
            IF @FPARTY = '' SET @FPARTY = '0000000000'                
            IF @TPARTY = '' SET @TPARTY = 'ZZZZZZZZZZ'                
                      
      /*----------------------------------------------------------------------------------------------------------------------                
      POPULATE CLIENTS HAVING EITHER,                 
      VARMARGIN REQUIREMENT FOR THE DATE                 
      OR                 
      BILLS DUE FOR THE DATE                
      ----------------------------------------------------------------------------------------------------------------------*/              
            TRUNCATE TABLE V2_CLIENTFUNDINGDATA_UP                 
                      
            INSERT INTO                 
                  V2_CLIENTFUNDINGDATA_UP                 
            SELECT                 
                  RUNDATE = @RUNDATE,                
                  EXCHANGE = 'NSE',                
                  SEGMENT = 'CAPITAL',                
                  PARTY_CODE,                
                  VARMARGIN = SUM(VARMARGIN),                 
                  COLLATERAL_CASH = 0,                
				  COLLATERAL_NONCASH = 0,                
                  COLLATERAL_TOTAL = 0,                
                  MARGINFUNDING = 0,                
                  BILLAMOUNT = SUM(BILLAMOUNT),                
                  LEDBAL = 0,                
                  FUTUREBILLS = 0,                
                  BILLFUNDING = 0,                
                  TOTALFUNDING = 0                
            FROM                 
                  (                
                        SELECT                 
                              PARTY_CODE,                 
                              BILLAMOUNT = SUM(CASE WHEN SELL_BUY = 1 THEN -AMOUNT ELSE AMOUNT END),                 
                              VARMARGIN = 0                 
                        FROM                 
                              ACCBILL (NOLOCK)                
                        WHERE                 
                              LEFT(CONVERT(VARCHAR,PAYIN_DATE,109),11) = @RUNDATE                 
                              AND PARTY_CODE BETWEEN @FPARTY AND @TPARTY                
                        GROUP BY                
                              PARTY_CODE                
                        HAVING                 
                              SUM(CASE WHEN SELL_BUY = 1 THEN -AMOUNT ELSE AMOUNT END) <> 0                
                
                        UNION ALL                                  
                
                        SELECT                 
                              PARTY_CODE,                 
                              BILLAMOUNT = 0,                 
                              VARMARGIN = SUM(-VARAMT)                 
                        FROM                 
                              TBL_MG02 (NOLOCK)                
                        WHERE                 
                              LEFT(CONVERT(VARCHAR,MARGIN_DATE,109),11) = @RUNDATE                 
                              AND PARTY_CODE BETWEEN @FPARTY AND @TPARTY                
                        GROUP BY                 
                              PARTY_CODE                
                        HAVING                 
                              SUM(VARAMT-MTOM) <> 0           
                        UNION ALL        
                        SELECT                 
                              PARTY_CODE,                 
                              BILLAMOUNT = 0,      
                              VARMARGIN = SUM(MTOM)                 
                        FROM                 
                              TBL_MG02 (NOLOCK)                
                        WHERE                 
                              LEFT(CONVERT(VARCHAR,MARGIN_DATE,109),11) = @RUNDATE                 
                              AND PARTY_CODE BETWEEN @FPARTY AND @TPARTY                
                        GROUP BY                 
                              PARTY_CODE                
                        HAVING                 
                              SUM(MTOM) < 0                
                  ) V                
            GROUP BY                
                  PARTY_CODE                
                      
                
      /*----------------------------------------------------------------------------------------------------------------------                
      DELETE QUERY TO IGNORE CLIENTS OF TYPE 'REM'                
      ----------------------------------------------------------------------------------------------------------------------*/                
      DELETE                 
            V2_CLIENTFUNDINGDATA_UP                
      FROM                 
            (                
                  SELECT                 
                        X.PARTY_CODE                 
                  FROM                 
                        V2_CLIENTFUNDINGDATA_UP X                
                        LEFT OUTER JOIN                
                        (                   
                              SELECT                 
                                    C2.PARTY_CODE,                 
                                    C1.CL_TYPE                
                              FROM                 
                                    CLIENT1 C1,                 
                                    CLIENT2 C2                
                              WHERE                  
                                    C1.CL_CODE = C2.CL_CODE                
                        ) Y                
                        ON                 
                        (                
                              Y.PARTY_CODE = X.PARTY_CODE                
                 )                
                  WHERE                 
                        ISNULL(Y.CL_TYPE,'REM') = 'REM'                
            ) ABC                
      WHERE                 
            V2_CLIENTFUNDINGDATA_UP.PARTY_CODE = ABC.PARTY_CODE                
                
                
      /*----------------------------------------------------------------------------------------------------------------------                
      UPDATE COLLATERAL INFORMATION FOR CLIENTS IN TEMP TABLE                
      ----------------------------------------------------------------------------------------------------------------------*/                
            UPDATE                 
                  V2_CLIENTFUNDINGDATA_UP                       
            SET                 
                  COLLATERAL_CASH = ACTUALCASH,                
				  COLLATERAL_NONCASH = ACTUALNONCASH,                
                  COLLATERAL_TOTAL = EFFECTIVECOLL                
            FROM                 
                  MSAJAG..COLLATERAL C (NOLOCK)                 
            WHERE                 
                  LEFT(CONVERT(VARCHAR,TRANS_DATE,109),11) = @RUNDATE                 
                  AND V2_CLIENTFUNDINGDATA_UP.PARTY_CODE = C.PARTY_CODE                 
                  AND V2_CLIENTFUNDINGDATA_UP.EXCHANGE = C.EXCHANGE                
                  AND V2_CLIENTFUNDINGDATA_UP.SEGMENT = C.SEGMENT                

            UPDATE                 
                  V2_CLIENTFUNDINGDATA_UP                       
            SET                               
				  COLLATERAL_NONCASH = COLLATERAL_NONCASH + FinalAmount,                
                  COLLATERAL_TOTAL = COLLATERAL_TOTAL  + FinalAmount             
            FROM                 
				   ( Select party_code, Exchange, Segment, FinalAmount = Sum(FinalAmount) From AngelDemat.MSAJAG.DBO.TBL_DELHOLDDATA
					 Where ProcessDate = @RunDate
					 And Exchange = 'NSE' And Segment = 'CAPITAL'
					 Group by party_code, Exchange, Segment) C
            WHERE                 
                  V2_CLIENTFUNDINGDATA_UP.PARTY_CODE = C.PARTY_CODE                 
                  AND V2_CLIENTFUNDINGDATA_UP.EXCHANGE = C.EXCHANGE                
                  AND V2_CLIENTFUNDINGDATA_UP.SEGMENT = C.SEGMENT 
                      
      /*----------------------------------------------------------------------------------------------------------------------                
      UPDATE VOUCHER DATE WISE LEDGER BALANCE FOR CLIENTS IN TEMP TABLE                
      ----------------------------------------------------------------------------------------------------------------------*/                
            UPDATE                 
                  V2_CLIENTFUNDINGDATA_UP                       
            SET                 
                  LEDBAL = L.LEDBAL                
            FROM                 
                  (                
                  SELECT                
                        CLTCODE,                  
                        LEDBAL = SUM(CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END)                
                  FROM                
                        ACCOUNT..LEDGER L (NOLOCK), ACCOUNT..PARAMETER P (NOLOCK)                
                  WHERE                 
                        VDT >= SDTCUR                
                        AND VDT <= @RUNDATE + ' 23:59'                
                        AND @RUNDATE BETWEEN SDTCUR AND LDTCUR                
                     AND CLTCODE IN (SELECT PARTY_CODE FROM V2_CLIENTFUNDINGDATA_UP (NOLOCK))                
                  GROUP BY                 
                        CLTCODE                
                  ) L                
            WHERE                      
                  PARTY_CODE = CLTCODE                 
                      
                      
      /*----------------------------------------------------------------------------------------------------------------------                
      UPDATE LEDGER BALANCE : REDUCE THE AMOUNTS FOR BILLS TO BE SETTLED IN FUTURE DATES.                
      ----------------------------------------------------------------------------------------------------------------------*/                
            UPDATE                 
                  V2_CLIENTFUNDINGDATA_UP                       
            SET                 
                  LEDBAL = LEDBAL - B.BILLAMOUNT,                  
                  FUTUREBILLS = B.BILLAMOUNT                 
            FROM                 
                  (                
                        SELECT                 
                              CLTCODE = PARTY_CODE,                 
                              BILLAMOUNT = SUM(CASE WHEN SELL_BUY = 1 THEN -AMOUNT ELSE AMOUNT END)                 
                        FROM                 
                              ACCBILL (NOLOCK)                
                        WHERE                 
                              PAYIN_DATE > @RUNDATE + ' 23:59'                
                              AND START_DATE <= @RUNDATE + ' 23:59'                
                              AND PARTY_CODE BETWEEN @FPARTY AND @TPARTY                
                        GROUP BY                
                              PARTY_CODE                
                        HAVING                 
     SUM(CASE WHEN SELL_BUY = 1 THEN -AMOUNT ELSE AMOUNT END) <> 0                
                  ) B                 
            WHERE                      
                  PARTY_CODE = CLTCODE                 
                      
                      
      /*----------------------------------------------------------------------------------------------------------------------                
      UPDATE MARGIN FUNDING AMOUNT AFTER ADJUSTING VAR MARGIN REQUIREMENT (-VE) WITH TOTAL COLLATERAL (+VE)                
      WHERE VAR MARGIN REQUIREMENT (-VE) + TOTAL COLLATERAL (+VE) IS LESS THAN ZERO.                
      ----------------------------------------------------------------------------------------------------------------------*/                
            UPDATE                 
                  V2_CLIENTFUNDINGDATA_UP                       
            SET                 
                  MARGINFUNDING =                 
                                                (CASE WHEN LEDBAL <= 0 THEN VARMARGIN + COLLATERAL_TOTAL                 
                                                ELSE                 
          (CASE WHEN LEDBAL > 0 THEN    
                                                            (CASE WHEN VARMARGIN + COLLATERAL_TOTAL + LEDBAL >= 0 THEN 0                 
                                                            ELSE                 
                                                                  VARMARGIN + COLLATERAL_TOTAL + LEDBAL                  
                                                            END)                 
                                                      ELSE 0                   
                                                      END)          
                                            END)                
            WHERE                 
                  VARMARGIN + COLLATERAL_TOTAL < 0                
                      
                      
      /*----------------------------------------------------------------------------------------------------------------------                
      VOUCHER DATE WISE SETTLEMENT FUNDING AMOUNT:                 
      UPDATE SETTLEMENT FUNDING AMOUNT FOR CASES WHERE BOTH LEDGER BALANCE AND BILL AMOUNT IS DEBIT.                
      FUNDING AMOUNT IS THE MINIMUM OF THE DEBIT IN LEDGER OR BILL        
      ----------------------------------------------------------------------------------------------------------------------*/                
            UPDATE                 
                  V2_CLIENTFUNDINGDATA_UP                       
            SET                 
                  BILLFUNDING = (CASE WHEN BILLAMOUNT > LEDBAL THEN BILLAMOUNT ELSE LEDBAL END)                
            WHERE                 
                  LEDBAL < 0                
                  AND BILLAMOUNT < 0                
                      
                      
      /*----------------------------------------------------------------------------------------------------------------------                
      UPDATE TOTAL FUNDING AMOUNT AS MARGIN FUNDING AMOUNT + SETTLEMENT FUNDING AMOUNT                
      ----------------------------------------------------------------------------------------------------------------------*/                
            UPDATE                 
                  V2_CLIENTFUNDINGDATA_UP                       
            SET                 
                  TOTALFUNDING = MARGINFUNDING + BILLFUNDING                
                      
                     
      /*----------------------------------------------------------------------------------------------------------------------                
      DELETE DATA FROM MAIN TABLE FOR THE DATE AND POPULATE FRESH DATA AS COMPUTED ABOVE.                
      SELECT OUTPUT PROVIDED FOR DATA COMPUTED IN ABOVE PROCESS.                
      ----------------------------------------------------------------------------------------------------------------------*/                
            DELETE V2_CLIENTFUNDINGDATA WHERE LEFT(CONVERT(VARCHAR,RUNDATE,109),11) = @RUNDATE                
                      
            INSERT INTO V2_CLIENTFUNDINGDATA SELECT * FROM V2_CLIENTFUNDINGDATA_UP (NOLOCK)                
                      
            INSERT INTO #DATECOUNT SELECT @RUNDATE                
                      
            FETCH NEXT FROM @LEDRCUR                 
            INTO                 
            @RUNDATE                
     END                                    
      CLOSE @LEDRCUR                                    
      DEALLOCATE @LEDRCUR                                     
                      
      SELECT                 
            RUNDATE,                 
            RUNDATE_109 = LEFT(CONVERT(VARCHAR,RUNDATE,109),11)                 
      FROM                 
            #DATECOUNT                
      ORDER BY                 
            RUNDATE                
                
/*----------------------------------------------------------------------------------------------------------------------                
END OF PROCESS                
----------------------------------------------------------------------------------------------------------------------*/

GO
