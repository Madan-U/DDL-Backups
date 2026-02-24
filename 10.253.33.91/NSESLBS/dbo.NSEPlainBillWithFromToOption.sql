-- Object: PROCEDURE dbo.NSEPlainBillWithFromToOption
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE   PROC NSEPlainBillWithFromToOption        
 (              
      @StatusID VARCHAR(15),         
      @StatusName VARCHAR(25), 
		@OptionDateOrSetNo Char(1),   --- S->For Settlement Option ; D-> For Date Option             
      @FromSettNo VARCHAR(7),         
      @ToSettNo VARCHAR(7),
      @FromDate VARCHAR(11),         
      @ToDate VARCHAR(11),
      @SettType VARCHAR(2),              
      @BranchCD VARCHAR(10),
		@SubBroker VARCHAR(10),         
      @FromParty VARCHAR(10),         
      @ToParty VARCHAR(10)              
)         
AS              
              
	SET NOCOUNT ON        
        
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        

	IF @BranchCD = '' OR @BranchCD = '%'
		SET @BranchCD = NULL 
	IF @SubBroker = '' OR @SubBroker = '%'
		SET @SubBroker = NULL

	SET @FromSettNo =	CASE @OptionDateOrSetNo 
							WHEN 'S' THEN
								 CASE WHEN @FromSettNo = '' THEN (SELECT MIN(SETT_NO) FROM SETT_MST WHERE SETT_TYPE = @SettType) ELSE @FromSettNo END 		
							WHEN 'D' THEN
							    CASE WHEN @FromDate = '' THEN 
										(SELECT MIN(SETT_NO) FROM SETT_MST WHERE SETT_TYPE = @SettType) ELSE 
										(SELECT MIN(SETT_NO) FROM SETT_MST WHERE SETT_TYPE = @SettType AND START_DATE >= @FromDate) 
								 END
							END


	SET @ToSettNo	=  CASE @OptionDateOrSetNo 
							WHEN 'S' THEN
								 CASE WHEN @ToSettNo = '' THEN (SELECT MAX(SETT_NO) FROM SETT_MST WHERE SETT_TYPE = @SettType) ELSE @ToSettNo END 		
							WHEN 'D' THEN
							    CASE WHEN @ToDate = '' THEN 
										(SELECT MAX(SETT_NO) FROM SETT_MST WHERE SETT_TYPE = @SettType) ELSE 
										(SELECT MAX(SETT_NO) FROM SETT_MST WHERE SETT_TYPE = @SettType AND END_DATE <= @ToDate) 
								 END
						 	END


   SELECT         
      PARTY_CODE,         
      C1.LONG_NAME,         
      C1.BRANCH_CD,         
      SERVICE_CHRG        
   INTO #CLIENTMASTER         
   FROM CLIENT1 C1,         
      CLIENT2 C2         
   WHERE C1.CL_CODE = C2.CL_CODE         
      AND C2.PARTY_CODE BETWEEN @FromParty AND @ToParty         
      AND C1.BRANCH_CD = ISNULL(@BranchCD, C1.BRANCH_CD)
		AND C1.SUB_BROKER = ISNULL(@SubBroker, C1.SUB_BROKER)
      AND @StatusName =         
            (CASE         
                  WHEN @StatusID = 'BRANCH' THEN C1.BRANCH_CD        
                  WHEN @StatusID = 'SUBBROKER' THEN C1.SUB_BROKER        
                  WHEN @StatusID = 'TRADER' THEN C1.TRADER        
                  WHEN @StatusID = 'FAMILY' THEN C1.FAMILY        
                  WHEN @StatusID = 'AREA' THEN C1.AREA        
                  WHEN @StatusID = 'REGION' THEN C1.REGION        
                  WHEN @StatusID = 'CLIENT' THEN C2.PARTY_CODE        
            ELSE         
                  'BROKER'        
            END)        

   SELECT      
      S.SETT_NO,         
      S.SETT_TYPE,       
	   S.BILLNo,          
      S.PARTY_CODE,         
      C2.LONG_NAME,         
      C2.BRANCH_CD,         
      S.SCRIP_CD,         
      S.SERIES,         
      SCRIP_NAME = S1.LONG_NAME,         
      SEC_PAYIN = CONVERT(VARCHAR,SEC_PAYIN,103),
      START_DATE = CONVERT(VARCHAR,START_DATE,103),         
      END_DATE = CONVERT(VARCHAR,END_DATE,103),         
      PQTY = SUM(        
            CASE         
                  WHEN SELL_BUY = 1         
                  THEN TRADEQTY         
                  ELSE 0         
            END        
            ),         
		PNetRate = (Case When Sum(Case When Sell_Buy = 1       
  							  Then N_NetRate*Tradeqty       
                                     Else 0       
                                End) > 0       
                       Then Sum(Case When Sell_Buy = 1       
                                     Then N_NetRate*Tradeqty       
                                     Else 0       
                                End) /       
                            Sum(Case When Sell_Buy = 1       
                                     Then TradeQty       
                                     Else 0       
                                End)      
         			Else 0       
                  End),      
      PAMT = SUM(        
            CASE         
                  WHEN SELL_BUY = 1         
                  THEN TRADEQTY*N_NETRATE         
                  ELSE 0         
            END        
            ),         
      SQTY = SUM(        
            CASE         
                  WHEN SELL_BUY = 2         
                  THEN TRADEQTY         
                  ELSE 0         
            END        
            ),         
  		SNetRate = (Case When Sum(Case When Sell_Buy = 2      
     											Then N_NetRate*Tradeqty       
                                 	Else 0       
										  End) > 0       
                          Then Sum(Case When Sell_Buy = 2      
                                        Then N_NetRate*Tradeqty       
         									Else 0       
                                   End) /       
                               Sum(Case When Sell_Buy = 2      
                                        Then TradeQty       
                            Else 0       
                                   End)      
            			Else 0       
                     End),      
         SAMT = SUM(        
               CASE         
                     WHEN SELL_BUY = 2         
                     THEN TRADEQTY*N_NETRATE         
                     ELSE 0         
               END        
               ),         
         NQTY = SUM(        
               CASE         
                     WHEN SELL_BUY = 1         
                     THEN TRADEQTY         
                     ELSE -TRADEQTY         
               END        
               ),         
         NAMT = SUM(        
               CASE         
                     WHEN SELL_BUY = 2         
                     THEN TRADEQTY*N_NETRATE         
                     ELSE - TRADEQTY*N_NETRATE         
               END        
               ),         
         BROKERAGE = 0,         
         SERVICE_TAX = SUM(CASE WHEN SERVICE_CHRG <> 2 THEN NSERTAX ELSE 0 END),         
         STAMPDUTY = SUM(BROKER_CHRG),         
         SEBITAX = SUM(SEBI_TAX),         
         TURNOVER_TAX=SUM(S.TURN_TAX),         
         STT = SUM(INS_CHRG),         
         OTHER_CHRG = SUM(S.OTHER_CHRG)         
     INTO #SETT FROM SETTLEMENT S,         
         SETT_MST M,         
         SCRIP1 S1,         
         SCRIP2 S2,         
         #CLIENTMASTER C2         
   WHERE C2.PARTY_CODE = S.PARTY_CODE         
         AND S.SETT_NO = M.SETT_NO         
         AND S.SETT_TYPE = M.SETT_TYPE         
         AND S.SCRIP_CD = S2.SCRIP_CD         
         AND S.SERIES = S2.SERIES         
         AND S1.CO_CODE = S2.CO_CODE         
   		AND S1.SERIES = S2.SERIES         
         AND AUCTIONPART NOT LIKE 'A%'         
         AND MARKETRATE > 0         
      	AND S.SETT_NO BETWEEN @FromSettNo AND @ToSettNo
         AND S.SETT_TYPE = @SettType         
         AND S.PARTY_CODE BETWEEN @FromParty AND @ToParty         
   GROUP BY S.SETT_NO,         
         S.SETT_TYPE,         
         S.PARTY_CODE,         
  			S.BILLNo,       
         C2.LONG_NAME,         
         C2.BRANCH_CD,         
         S.SCRIP_CD,         
         S.SERIES,         
         S1.LONG_NAME,
         CONVERT(VARCHAR,SEC_PAYIN,103),         
         CONVERT(VARCHAR,START_DATE,103),         
         CONVERT(VARCHAR,END_DATE,103)      

		INSERT INTO #SETT  
      SELECT      
            S.SETT_NO,         
            S.SETT_TYPE,       
       		S.BILLNo,          
            S.PARTY_CODE,         
            C2.LONG_NAME,         
            C2.BRANCH_CD,         
            S.SCRIP_CD,         
            S.SERIES,         
            SCRIP_NAME = S1.LONG_NAME,
            SEC_PAYIN = CONVERT(VARCHAR,SEC_PAYIN,103),         
            START_DATE = CONVERT(VARCHAR,START_DATE,103),         
            END_DATE = CONVERT(VARCHAR,END_DATE,103),         
            PQTY = SUM(        
                  CASE         
                        WHEN SELL_BUY = 1         
                        THEN TRADEQTY         
                        ELSE 0         
                  END        
                  ),         
     			PNetRate = (Case When Sum(Case When Sell_Buy = 1       
        							  Then N_NetRate*Tradeqty       
                                           Else 0       
                                      End) > 0       
                             Then Sum(Case When Sell_Buy = 1       
                                           Then N_NetRate*Tradeqty       
                                           Else 0       
                                      End) /       
                                  Sum(Case When Sell_Buy = 1       
                                           Then TradeQty       
                                           Else 0       
                                      End)      
               Else 0       
                        End),      
            PAMT = SUM(        
                  CASE         
                        WHEN SELL_BUY = 1         
                        THEN TRADEQTY*N_NETRATE         
                        ELSE 0         
                  END        
                  ),         
            SQTY = SUM(        
                  CASE         
                        WHEN SELL_BUY = 2         
                        THEN TRADEQTY         
                        ELSE 0         
                  END        
                  ),         
     			SNetRate = (Case When Sum(Case When Sell_Buy = 2      
        							  Then N_NetRate*Tradeqty       
                                           Else 0       
                                      End) > 0       
                             Then Sum(Case When Sell_Buy = 2      
                                           Then N_NetRate*Tradeqty       
            				 Else 0       
                                      End) /       
                                  Sum(Case When Sell_Buy = 2      
                                           Then TradeQty       
                               Else 0       
                                      End)      
               			 Else 0       
                        End),      
            SAMT = SUM(        
                  CASE         
                        WHEN SELL_BUY = 2         
                        THEN TRADEQTY*N_NETRATE         
                        ELSE 0         
                  END        
                  ),         
            NQTY = SUM(        
                  CASE         
                        WHEN SELL_BUY = 1         
                        THEN TRADEQTY         
                        ELSE -TRADEQTY         
                  END        
                  ),         
            NAMT = SUM(        
                  CASE         
                        WHEN SELL_BUY = 2         
                        THEN TRADEQTY*N_NETRATE         
                        ELSE - TRADEQTY*N_NETRATE         
                  END        
                  ),         
            BROKERAGE = 0,         
            SERVICE_TAX = SUM(CASE WHEN SERVICE_CHRG <> 2 THEN NSERTAX ELSE 0 END),         
            STAMPDUTY = SUM(BROKER_CHRG),         
            SEBITAX = SUM(SEBI_TAX),         
            TURNOVER_TAX=SUM(S.TURN_TAX),         
            STT = SUM(INS_CHRG),         
            OTHER_CHRG = SUM(S.OTHER_CHRG)         
      FROM HISTORY S,         
            SETT_MST M,         
            SCRIP1 S1,         
            SCRIP2 S2,         
            #CLIENTMASTER C2         
      WHERE C2.PARTY_CODE = S.PARTY_CODE         
            AND S.SETT_NO = M.SETT_NO         
            AND S.SETT_TYPE = M.SETT_TYPE         
            AND S.SCRIP_CD = S2.SCRIP_CD         
            AND S.SERIES = S2.SERIES         
            AND S1.CO_CODE = S2.CO_CODE         
            AND S1.SERIES = S2.SERIES         
            AND AUCTIONPART NOT LIKE 'A%'         
            AND MARKETRATE > 0         
            AND S.SETT_NO BETWEEN @FromSettNo AND @ToSettNo
            AND S.SETT_TYPE = @SettType         
            AND S.PARTY_CODE BETWEEN @FromParty AND @ToParty         
      GROUP BY S.SETT_NO,         
            S.SETT_TYPE,         
            S.PARTY_CODE,         
          	S.BILLNo,       
            C2.LONG_NAME,         
            C2.BRANCH_CD,         
            S.SCRIP_CD,         
            S.SERIES,         
            S1.LONG_NAME,
            CONVERT(VARCHAR,SEC_PAYIN,103),         
            CONVERT(VARCHAR,START_DATE,103),         
            CONVERT(VARCHAR,END_DATE,103)      
  
	INSERT INTO #SETT  
	SELECT CD_SETT_NO,CD_SETT_TYPE,BILLNO=0,CD_PARTY_CODE,  
		C2.LONG_NAME,BRANCH_CD,CD_SCRIP_CD,CD_SERIES,SCRIP_NAME=S1.LONG_NAME,  
		SEC_PAYIN,START_DATE,END_DATE,PQTY=0,PNetRate=0,  
		PAMT = CD_TrdBuyBrokerage + CD_DELBuyBrokerage +   
		      (Case When Service_Chrg <> 2   
		     THEN CD_TrdBuySerTax + CD_DelBuySerTax  
		     ELSE 0  
		       END),  
		SQTY=0,SNetRate=0,  
		SAMT = CD_TrdsellBrokerage + CD_DELsellBrokerage +   
		      (Case When Service_Chrg <> 2   
		     THEN CD_TrdSellSerTax + CD_DelSellSerTax  
		     ELSE 0  
		       END),  
		NQTY=0,  
		NAMT=CD_TrdsellBrokerage + CD_DELsellBrokerage +  
		      (Case When Service_Chrg <> 2   
		     THEN CD_TrdSellSerTax + CD_DelSellSerTax  
		     ELSE 0  
		       END) -   
		      (CD_TrdBuyBrokerage + CD_DELBuyBrokerage +  
		      (Case When Service_Chrg <> 2   
		     THEN CD_TrdBuySerTax + CD_DelBuySerTax  
		     ELSE 0  
		       END)),  
		BROKERAGE=0,  
		SERVICE_TAX=(Case When Service_Chrg = 0  
		           THEN CD_TrdBuySerTax + CD_DelBuySerTax + CD_TrdSellSerTax + CD_DelSellSerTax   
		           ELSE 0  
		             END),  
		STAMPDUTY=0,SEBITAX=0,TURNOVER_TAX=0,STT=0,OTHER_CHRG=0  
	FROM CHARGES_DETAIL S,               
		SETT_MST M,         
		SCRIP1 S1,         
		SCRIP2 S2,         
		#CLIENTMASTER C2   
	WHERE C2.PARTY_CODE = CD_PARTY_CODE         
		AND CD_SETT_NO = M.SETT_NO         
		AND CD_SETT_TYPE = M.SETT_TYPE         
		AND CD_SCRIP_CD = S2.SCRIP_CD         
		AND CD_SERIES = S2.SERIES         
		AND S1.CO_CODE = S2.CO_CODE         
		AND S1.SERIES = S2.SERIES         
      AND CD_SETT_NO BETWEEN @FromSettNo AND @ToSettNo
		AND CD_SETT_TYPE = @SettType         
		AND CD_PARTY_CODE BETWEEN @FromParty AND @ToParty     
  
	SELECT SETT_NO,SETT_TYPE,BILLNo,PARTY_CODE,LONG_NAME,BRANCH_CD,  
		SCRIP_CD,SERIES,SCRIP_NAME,SEC_PAYIN,START_DATE,END_DATE,  
		PQTY=SUM(PQTY),SQTY=SUM(SQTY),  
		PNetRate=0,SNetRate=0,  
		PAMT=SUM(PAMT),SAMT=SUM(SAMT),  
		NQTY=SUM(NQTY),NAMT=SUM(NAMT),  
		BROKERAGE=SUM(BROKERAGE),  
		SERVICE_TAX=SUM(SERVICE_TAX),  
		STAMPDUTY=SUM(STAMPDUTY),SEBITAX=SUM(SEBITAX),  
		TURNOVER_TAX=SUM(TURNOVER_TAX),STT=SUM(STT),OTHER_CHRG=SUM(OTHER_CHRG)  
	FROM #SETT  
	GROUP BY SETT_NO,SETT_TYPE,BILLNo,PARTY_CODE,LONG_NAME,BRANCH_CD,  
		SCRIP_CD,SERIES,SCRIP_NAME,SEC_PAYIN,START_DATE,END_DATE  
	ORDER BY
		PARTY_CODE, 
		SETT_NO,  
		SETT_TYPE,         
		LONG_NAME,         
		SCRIP_NAME       
      
/*

DECLARE              
      @StatusID VARCHAR(15),         
      @StatusName VARCHAR(25),  
		@OptionDateOrSetNo Char(1),            
      @FromSettNo VARCHAR(7),         
      @ToSettNo VARCHAR(7),         
      @FromDate VARCHAR(11),         
      @ToDate VARCHAR(11),
      @SettType VARCHAR(2),              
      @BranchCD VARCHAR(10),         
      @FromParty VARCHAR(10),         
      @ToParty VARCHAR(10)              

SET   @StatusID = 'broker'
SET   @StatusName = 'broker'
SET   @OptionDateOrSetNo = 'D'
SET   @FromSettNo = '2007097'
SET   @ToSettNo = ''
SET   @FromDate = '' --'01 May 2007'
SET   @ToDate  = '' --'25 May 2007'
SET   @SettType ='N'
SET   @BranchCD = '%'
SET   @FromParty = '0'
SET   @ToParty = 'Z'

EXEC NSEPlainBillWithFromToOption
      @StatusID,
      @StatusName,
		@OptionDateOrSetNo,
      @FromSettNo,
      @ToSettNo,
      @FromDate,
      @ToDate,
      @SettType,
      @BranchCD,
      @FromParty,
      @ToParty


*/

GO
