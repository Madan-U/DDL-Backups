-- Object: PROCEDURE dbo.V2_PROCESSFORTODAY_BKP_20220913
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




CREATE PROC [dbo].[V2_PROCESSFORTODAY_BKP_20220913](  
           @PROCESSFLAG VARCHAR(15),  
           @UNAME       VARCHAR(50),  
           @SETT_NO     VARCHAR(7),  
           @SETT_TYPE   VARCHAR(2),  
           @PROCESSDATE VARCHAR(11))  

		   WITH RECOMPILE 
AS  

  DECLARE
		@OTHER_SETT_TYPE VARCHAR(2),
		@OTHER_SETT_NO	VARCHAR(7),
		@CLEARINGCODE	VARCHAR(10),
	@BROK_SQ_OFF	INT
		

SET @OTHER_SETT_TYPE = ''
SET @OTHER_SETT_NO = ''
SET @CLEARINGCODE = ''
SET @BROK_SQ_OFF = 0

SELECT @CLEARINGCODE = ISNULL(CLEARINGCODE,''), @BROK_SQ_OFF = ISNULL(BROK_SQ_OFF,0)  FROM TBL_INTEROP_SETTING
WHERE  @PROCESSDATE BETWEEN FROM_DATE AND TO_DATE 



IF @CLEARINGCODE = 'NSCCL'
BEGIN
	SELECT @OTHER_SETT_TYPE = BSE_SETT_TYPE FROM TBL_INTEROP_SETT_TYPE 
		   WHERE NSE_SETT_TYPE = @Sett_Type AND @PROCESSDATE BETWEEN FROM_DATE AND TO_DATE	
	SELECT @OTHER_SETT_NO = SETT_NO FROM [ANAND].bsedb_ab.DBO.Sett_Mst Where Start_date >= @PROCESSDATE 
		   and Start_date <= @PROCESSDATE + ' 23:59' And Sett_Type = @OTHER_SETT_TYPE   
END
 

  IF @PROCESSFLAG <> 'IMPORT TRADE'  
    BEGIN  
      IF (SELECT COUNT(1)  
          FROM   (SELECT TOP 1 PARTY_CODE  
                  FROM   SETTLEMENT  
                  WHERE  SETT_TYPE = @SETT_TYPE  
                         AND SETT_NO = @SETT_NO
		  UNION SELECT TOP 1 PARTY_CODE  
                  FROM   ISETTLEMENT  
                  WHERE  SETT_TYPE = @SETT_TYPE  
                         AND SETT_NO = @SETT_NO
		  UNION SELECT TOP 1 PARTY_CODE  
                  FROM   [ANAND].bsedb_ab.DBO.SETTLEMENT  
                  WHERE  SETT_TYPE = @OTHER_SETT_TYPE  
                         AND SETT_NO = @OTHER_SETT_NO
		  UNION SELECT TOP 1 PARTY_CODE  
                  FROM   [ANAND].bsedb_ab.DBO.ISETTLEMENT  
                  WHERE  SETT_TYPE = @OTHER_SETT_TYPE  
                         AND SETT_NO = @OTHER_SETT_NO) A) = 0  
        BEGIN  
          RETURN  
        END  
    END  
      
  DECLARE  @PROCESSCURSOR CURSOR,  
           @POSTFLAG      INT  
                            
  SET @POSTFLAG = 1  

  IF @PROCESSFLAG <> 'IMPORT TRADE'  
    BEGIN                      
  INSERT INTO V2_PROCESS_STATUS_LOG  
             (EXCHANGE,  
              SEGMENT,  
              BUSINESSDATE,  
              SETT_NO,  
              SETT_TYPE,  
              PROCESSNAME,  
              FILENAME,  
              START_END_FLAG,  
              PROCESSDATE,  
              PROCESSBY,  
              MACHINEIP)  
  VALUES     ('NSE',  
              'CAPITAL',  
              @PROCESSDATE,  
              @SETT_NO,  
              @SETT_TYPE,  
              @PROCESSFLAG,  
              '',  
              1,  
              GETDATE(),  
              @UNAME,  
              '')  
  END

  IF @PROCESSFLAG = 'IMPORT TRADE'  
    BEGIN                      
  INSERT INTO V2_PROCESS_STATUS_LOG  
             (EXCHANGE,  
              SEGMENT,  
              BUSINESSDATE,  
              SETT_NO,  
              SETT_TYPE,  
              PROCESSNAME,  
              FILENAME,  
              START_END_FLAG,  
              PROCESSDATE,  
              PROCESSBY,  
              MACHINEIP)  
  VALUES     ('NSE',  
              'CAPITAL',  
              @PROCESSDATE,  
              '',  
              '',  
              @PROCESSFLAG,  
              '',  
              1,  
              GETDATE(),  
              @UNAME,  
              '')  
  END

  IF @PROCESSFLAG = 'BILLING'  
    BEGIN
 

	  IF @OTHER_SETT_TYPE <> ''
	  BEGIN
	  --IF @BROK_SQ_OFF = 1
	--	BEGIN
	  
	--	EXEC PROC_SETTFLAG_START @SETT_NO, @SETT_TYPE, @PROCESSDATE, '0', 'ZZZZZZZZZZ'
		---return
		 
		--	EXEC PROC_SETTFLAG_SET
		----UPDATE COMBINE_SETTLEMENT SET NBROKAPP = BROKAPPLIED, N_NETRATE = NETRATE,
		---- NSERTAX = SERVICE_TAX, BILLFLAG = SETTFLAG
		--EXEC PROC_SETTFLAG_END @SETT_NO, @SETT_TYPE, @PROCESSDATE, '0', 'ZZZZZZZZZZ'
		--END
		
		EXEC [ANAND].bsedb_ab.DBO.BSEBILLALLTRADE  
			 @OTHER_SETT_NO ,  
			 @OTHER_SETT_TYPE 
		
		EXEC [ANAND].bsedb_ab.DBO.NODELCARRYFORWARD  
         @OTHER_SETT_NO ,  
			 @OTHER_SETT_TYPE  
	  END

      EXEC BILLALLTRADE  
         @SETT_NO ,  
         @SETT_TYPE  
		      
      UPDATE V2_BUSINESS_PROCESS  
      SET    BILLING = BILLING + 1,  
             VBB = 0,  
             STT = 0,  
             VALAN = 0,  
             CONTRACT = 0,  
             POSTING = 0,  
             LASTUPDATEDATE = GETDATE(),  
             LASTUPDATEBY = @UNAME  
      WHERE  SETT_NO = @SETT_NO  
             AND SETT_TYPE = @SETT_TYPE  
             AND LEFT(BUSINESS_DATE,11) = @PROCESSDATE  
             AND OPEN_CLOSE = 0                                 
    END  
      
  IF @PROCESSFLAG = 'VBB'  
    BEGIN  
	 
	  IF @OTHER_SETT_TYPE <> ''
	  BEGIN
		EXEC [ANAND].bsedb_ab.DBO.PR_CHARGES_DETAIL  
			 @OTHER_SETT_NO ,  
			 @OTHER_SETT_TYPE,  
			 '0','ZZZZZZZZZZ'   
	  END
	 
	
      EXEC PR_CHARGES_DETAIL  
         @SETT_NO ,  
         @SETT_TYPE ,  
         '0' ,  
         'ZZZZZZZZZZ'  
    
	  
      UPDATE V2_BUSINESS_PROCESS  
      SET    VBB = VBB + 1,  
             STT = 0,  
             VALAN = 0,  
             CONTRACT = 0,  
             POSTING = 0,  
             LASTUPDATEDATE = GETDATE(),  
             LASTUPDATEBY = @UNAME  
      WHERE  SETT_NO = @SETT_NO  
             AND SETT_TYPE = @SETT_TYPE  
             AND LEFT(BUSINESS_DATE,11) = @PROCESSDATE  
             AND OPEN_CLOSE = 0  
    END  
      
  IF @PROCESSFLAG = 'STT'  
    BEGIN  
         IF @OTHER_SETT_TYPE <> ''
         BEGIN
		 print 'sure'
		 print @OTHER_SETT_TYPE
		 
              EXEC [ANAND].bsedb_ab.DBO.STT_CHARGES_FINAL  
                      @OTHER_SETT_TYPE ,  
                      @PROCESSDATE,  
                      '0','ZZZZZZZZZZ'   

					  
         END

print 'Suresh1'

	  	
      EXEC STT_CHARGES_FINAL  
         @SETT_TYPE ,  
         @PROCESSDATE ,  
         '0' ,  
         'ZZZZZZZZZZ'  
          
      UPDATE V2_BUSINESS_PROCESS  
      SET    STT = STT + 1,  
             VALAN = 0,  
             CONTRACT = 0,  
             POSTING = 0,  
             LASTUPDATEDATE = GETDATE(),  
             LASTUPDATEBY = @UNAME  
      WHERE  SETT_NO = @SETT_NO  
             AND SETT_TYPE = @SETT_TYPE  
             AND LEFT(BUSINESS_DATE,11) = @PROCESSDATE  
             AND OPEN_CLOSE = 0  
                                
    END  
      
  IF @PROCESSFLAG = 'VALAN'  
    BEGIN  
	  
	  IF @OTHER_SETT_TYPE <> ''
	  BEGIN
		EXEC [ANAND].bsedb_ab.DBO.BSEVALANGENERATE  
			 @OTHER_SETT_NO ,  
			 @OTHER_SETT_TYPE,  
			 '0'  

		 EXEC [ANAND].bsedb_ab.DBO.INSPROC  
         @OTHER_SETT_NO ,  
         @OTHER_SETT_TYPE  
          
		 EXEC [ANAND].bsedb_ab.DBO.DELPROC  
         @OTHER_SETT_NO ,  
         @OTHER_SETT_TYPE  
	  END

      EXEC NSEVALANGENERATE  
         @SETT_NO ,  
         @SETT_TYPE ,  
         0  
          
      EXEC INSPROC  
         @SETT_NO ,  
         @SETT_TYPE  
          
      EXEC DELPROC  
         @SETT_NO ,  
         @SETT_TYPE  
          
      UPDATE V2_BUSINESS_PROCESS  
      SET    VALAN = VALAN + 1,  
             CONTRACT = 0,  
             POSTING = 0,  
             LASTUPDATEDATE = GETDATE(),  
             LASTUPDATEBY = @UNAME  
      WHERE  SETT_NO = @SETT_NO  
             AND SETT_TYPE = @SETT_TYPE  
             AND LEFT(BUSINESS_DATE,11) = @PROCESSDATE  
             AND OPEN_CLOSE = 0  
                                
    END  
      
  IF @PROCESSFLAG = 'CONTRACTPOP'  
    BEGIN  
	  IF @OTHER_SETT_TYPE <> ''
	  BEGIN	
		EXEC [ANAND].bsedb_ab.DBO.POP_CONTRACTDATA  
			 @OTHER_SETT_NO ,  
			 @OTHER_SETT_TYPE,  
			 @PROCESSDATE ,  
			 '0' ,  
			 'ZZZZZZZZZZ'  
      END

	  EXEC POP_CONTRACTDATA  
			 @SETT_NO ,  
			 @SETT_TYPE ,  
			 @PROCESSDATE ,  
			 '0' ,  
			 'ZZZZZZZZZZ'  
	      
      UPDATE V2_BUSINESS_PROCESS  
      SET    CONTRACT = CONTRACT + 1,  
             LASTUPDATEDATE = GETDATE(),  
             LASTUPDATEBY = @UNAME  
      WHERE  SETT_NO = @SETT_NO  
             AND SETT_TYPE = @SETT_TYPE  
             AND LEFT(BUSINESS_DATE,11) = @PROCESSDATE  
             AND OPEN_CLOSE = 0  
                                
    END  
      
  IF @PROCESSFLAG = 'POSTING'  
    BEGIN  
  
      SELECT *, VTYPE = 15 INTO #ACCBILL FROM ACCBILL  
      WHERE SETT_NO = @SETT_NO  
      AND SETT_TYPE = @SETT_TYPE  
      AND AMOUNT <> 0
  
      INSERT INTO #ACCBILL  
      SELECT *, VTYPE = 21 FROM IACCBILL  
      WHERE SETT_NO = @SETT_NO  
      AND SETT_TYPE = @SETT_TYPE  
      AND AMOUNT <> 0
  
      SELECT * INTO #BILLMATCH FROM ACCOUNT.DBO.BILLMATCH  
      WHERE SETT_NO = @SETT_NO  
      AND SETT_TYPE = @SETT_TYPE  
      AND AMOUNT <> 0
  
      SELECT @POSTFLAG = ISNULL(COUNT(1),0)  
      FROM   (SELECT   A.SETT_NO,  
                       A.SETT_TYPE,  
                       POSTFLAG = ISNULL(B.SETT_NO,'0')  
              FROM     #ACCBILL A  
                       LEFT OUTER JOIN #BILLMATCH B  
                         ON (A.SETT_TYPE = B.SETT_TYPE  
                             AND A.SETT_NO = B.SETT_NO  
                             AND A.PARTY_CODE = B.PARTY_CODE  
                             AND A.AMOUNT = B.AMOUNT  
        AND A.VTYPE = B.VTYPE  
                             AND SELL_BUY = (CASE   
                                               WHEN DRCR = 'D' THEN 1  
                                               ELSE 2  
                                             END))  
              WHERE    A.SETT_NO = @SETT_NO  
                       AND A.SETT_TYPE = @SETT_TYPE  
                       AND NOT EXISTS (SELECT ACCODE  
                                       FROM   VALANACCOUNT  
                                       WHERE  ACCODE = A.PARTY_CODE)  
              GROUP BY A.SETT_NO,A.SETT_TYPE,ISNULL(B.SETT_NO,'0')  
              UNION   
              SELECT B.SETT_NO,  
                     B.SETT_TYPE,  
                     POSTFLAG = '0'  
              FROM   #BILLMATCH B  
              WHERE  SETT_NO = @SETT_NO  
                     AND SETT_TYPE = @SETT_TYPE  
                     AND NOT EXISTS (SELECT PARTY_CODE  
                                     FROM   #ACCBILL A  
                                     WHERE  A.SETT_TYPE = B.SETT_TYPE  
                                            AND A.SETT_NO = B.SETT_NO  
                                            AND A.PARTY_CODE = B.PARTY_CODE  
         AND A.VTYPE = B.VTYPE)) P  
      WHERE  POSTFLAG = '0'  
                          
      UPDATE V2_BUSINESS_PROCESS  
      SET    POSTING = (CASE   
                          WHEN @POSTFLAG = 0 THEN 1  
                          ELSE 0  
                        END),  
             LASTUPDATEDATE = GETDATE(),  
             LASTUPDATEBY = @UNAME  
      WHERE  SETT_NO = @SETT_NO  
             AND SETT_TYPE = @SETT_TYPE  
             AND LEFT(BUSINESS_DATE,11) = @PROCESSDATE  
             AND OPEN_CLOSE = 0  
                                
    END  

  IF @PROCESSFLAG <> 'IMPORT TRADE'  
    BEGIN        
  INSERT INTO V2_PROCESS_STATUS_LOG  
             (EXCHANGE,  
              SEGMENT,  
              BUSINESSDATE,  
              SETT_NO,  
              SETT_TYPE,  
              PROCESSNAME,  
              FILENAME,  
              START_END_FLAG,  
              PROCESSDATE,  
              PROCESSBY,  
              MACHINEIP)  
  VALUES     ('NSE',  
              'CAPITAL',  
              @PROCESSDATE,  
              @SETT_NO,  
              @SETT_TYPE,  
              @PROCESSFLAG,  
              '',  
              2,  
              GETDATE(),  
              @UNAME,  
              '')  
  END

  IF @PROCESSFLAG = 'IMPORT TRADE'  
    BEGIN  

	INSERT INTO V2_PROCESS_STATUS_LOG  
	     (EXCHANGE,  
	      SEGMENT,  
	      BUSINESSDATE,  
	      SETT_NO,  
	      SETT_TYPE,  
	      PROCESSNAME,  
	      FILENAME,  
	      START_END_FLAG,  
	      PROCESSDATE,  
	      PROCESSBY,  
	      MACHINEIP)  
	SELECT 'NSE',  
	      'CAPITAL',  
	      @PROCESSDATE,  
	      SETT_NO,  
	      SETT_TYPE,  
	      'IMPORT TRADE',  
	      '',  
	      2,  
	      GETDATE(),  
	      @UNAME,  
	      ''  
	FROM V2_BUSINESS_PROCESS  
        WHERE  LEFT(BUSINESS_DATE,11) = @PROCESSDATE
             AND SETT_TYPE IN (SELECT DISTINCT SETT_TYPE FROM BBGSETTLEMENT
		               WHERE LEFT(SAUDA_DATE,11) = @PROCESSDATE
			       UNION
			       SELECT DISTINCT SETT_TYPE FROM BBGISETTLEMENT
		               WHERE LEFT(SAUDA_DATE,11) = @PROCESSDATE)

	  IF @CLEARINGCODE = 'NSCCL' or @CLEARINGCODE = ''
	  BEGIN	
		  UPDATE V2_BUSINESS_PROCESS  
		  SET    IMPORT_TRADE = IMPORT_TRADE + 1,
				 BILLING = 0,  
				 VBB = 0,  
				 STT = 0,  
				 VALAN = 0,  
				 CONTRACT = 0,  
				 POSTING = 0,  
				 LASTUPDATEDATE = GETDATE(),  
				 LASTUPDATEBY = @UNAME  
		  WHERE  LEFT(BUSINESS_DATE,11) = @PROCESSDATE
				 AND SETT_TYPE IN (SELECT DISTINCT SETT_TYPE FROM BBGSETTLEMENT
						   WHERE LEFT(SAUDA_DATE,11) = @PROCESSDATE
					   UNION
					   SELECT DISTINCT SETT_TYPE FROM BBGISETTLEMENT
						   WHERE LEFT(SAUDA_DATE,11) = @PROCESSDATE)
	END
	 
	IF @CLEARINGCODE = 'ICCL'
	BEGIN	
		UPDATE [ANAND].bsedb_ab.DBO.V2_BUSINESS_PROCESS  
		SET    IMPORT_TRADE = IMPORT_TRADE + 1,
		BILLING = 0,  
		VBB = 0,  
		STT = 0,  
		VALAN = 0,  
		CONTRACT = 0,  
		POSTING = 0,  
		LASTUPDATEDATE = GETDATE(),  
		LASTUPDATEBY = @UNAME  
		WHERE  LEFT(BUSINESS_DATE,11) = @PROCESSDATE
		AND SETT_TYPE IN (SELECT DISTINCT BSE_SETT_TYPE FROM TBL_INTEROP_SETT_TYPE 
					WHERE @PROCESSDATE BETWEEN FROM_DATE AND TO_DATE
					AND NSE_SETT_TYPE IN (SELECT DISTINCT SETT_TYPE FROM BBGSETTLEMENT
						   WHERE LEFT(SAUDA_DATE,11) = @PROCESSDATE
					   UNION
					   SELECT DISTINCT SETT_TYPE FROM BBGISETTLEMENT
						   WHERE LEFT(SAUDA_DATE,11) = @PROCESSDATE))
	END
 END

GO
