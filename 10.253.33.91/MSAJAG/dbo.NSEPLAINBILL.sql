-- Object: PROCEDURE dbo.NSEPLAINBILL
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE PROC [dbo].[NSEPLAINBILL]        
 (              
      @STATUSID VARCHAR(15),         
      @STATUSNAME VARCHAR(25),              
      @SETT_NO VARCHAR(7),         
      @SETT_TYPE VARCHAR(2),              
      @BRANCH_CD VARCHAR(10),         
      @SUBBROKER VARCHAR(10),         
      @FROMPARTY VARCHAR(10),         
      @TOPARTY VARCHAR(10)              
)         
        
AS              
              
SET NOCOUNT ON        
        
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
        
      SELECT         
            PARTY_CODE,         
            C1.LONG_NAME,         
            C1.BRANCH_CD,         
            SERVICE_CHRG        
      INTO #CLIENTMASTER         
      FROM CLIENT1 C1,         
            CLIENT2 C2         
      WHERE C1.CL_CODE = C2.CL_CODE         
            AND C2.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY         
            AND C1.BRANCH_CD LIKE (
                  CASE
                        WHEN @BRANCH_CD = ''
                        THEN '%'
                        ELSE @BRANCH_CD
                  END
		  )
            AND C1.SUB_BROKER LIKE (
                  CASE
                        WHEN @SUBBROKER = ''
                        THEN '%'
                        ELSE @SUBBROKER
                  END
                  )         
             AND @STATUSNAME =         
                  (CASE         
                        WHEN @STATUSID = 'BRANCH' THEN C1.BRANCH_CD        
                        WHEN @STATUSID = 'SUBBROKER' THEN C1.SUB_BROKER        
                        WHEN @STATUSID = 'TRADER' THEN C1.TRADER        
                        WHEN @STATUSID = 'FAMILY' THEN C1.FAMILY        
                        WHEN @STATUSID = 'AREA' THEN C1.AREA        
                        WHEN @STATUSID = 'REGION' THEN C1.REGION        
                        WHEN @STATUSID = 'CLIENT' THEN C2.PARTY_CODE        
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
            AND S.SETT_NO = @SETT_NO         
            AND S.SETT_TYPE = @SETT_TYPE         
            AND S.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY         
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
            AND S.SETT_NO = @SETT_NO         
            AND S.SETT_TYPE = @SETT_TYPE         
            AND S.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY         
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
  CD_SETT_NO,CD_SETT_TYPE,BILLNO=0,CD_PARTY_CODE,        
  C2.LONG_NAME,BRANCH_CD,CD_SCRIP_CD,CD_SERIES,SCRIP_NAME=S1.LONG_NAME,--C2.OFF_PHONE2,        
  SEC_PAYIN=CONVERT(VARCHAR,SEC_PAYIN,103),START_DATE=CONVERT(VARCHAR,START_DATE,103),    
  END_DATE=CONVERT(VARCHAR,END_DATE,103),PQTY=0,SQTY=0,PNetRate=0,SNetRate=0,        
  PAMT = SUM(CD_TrdBuyBrokerage + CD_DELBuyBrokerage) +         
 SUM(Case When Service_Chrg <> 0    
       THEN CD_TrdBuySerTax + CD_DelBuySerTax        
       ELSE 0        
         END),    
  SAMT = SUM(CD_TrdsellBrokerage + CD_DELsellBrokerage) +         
        SUM(Case When Service_Chrg <> 0  
       THEN CD_TrdSellSerTax + CD_DelSellSerTax        
       ELSE 0        
         END),        
  NQTY=0,        
  NAMT=SUM(CD_TrdsellBrokerage + CD_DELsellBrokerage) +        
        SUM(Case When Service_Chrg <> 0         
       THEN CD_TrdSellSerTax + CD_DelSellSerTax        
       ELSE 0        
         END) -         
        (SUM(CD_TrdBuyBrokerage + CD_DELBuyBrokerage) +        
        SUM(Case When Service_Chrg <> 0         
       THEN CD_TrdBuySerTax + CD_DelBuySerTax        
       ELSE 0        
         END)),        
  BROKERAGE=0,        
  SERVICE_TAX=SUM(Case When Service_Chrg = 0        
             THEN CD_TrdBuySerTax + CD_DelBuySerTax + CD_TrdSellSerTax + CD_DelSellSerTax         
             ELSE 0        
               END),        
  STAMPDUTY=0,SEBITAX=0,TURNOVER_TAX=0,STT=0,OTHER_CHRG=0
 FROM         
  CHARGES_DETAIL S,                     
  SETT_MST M,               
  SCRIP1 S1,               
  SCRIP2 S2,               
  #CLIENTMASTER C2         
 WHERE         
  C2.PARTY_CODE = CD_PARTY_CODE               
  AND CD_SETT_NO = M.SETT_NO               
  AND CD_SETT_TYPE = M.SETT_TYPE               
  AND CD_SCRIP_CD = S2.SCRIP_CD
  AND S1.CO_CODE = S2.CO_CODE
  AND S1.SERIES = S2.SERIES
  AND CD_SERIES = S1.SERIES
  AND CD_SETT_NO = @SETT_NO               
  AND CD_SETT_TYPE = @SETT_TYPE               
  AND CD_PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY    
GROUP BY
  CD_SETT_NO,CD_SETT_TYPE,CD_PARTY_CODE,        
  C2.LONG_NAME,BRANCH_CD,CD_SCRIP_CD,CD_SERIES,S1.LONG_NAME,
  CONVERT(VARCHAR,SEC_PAYIN,103),CONVERT(VARCHAR,START_DATE,103),    
  CONVERT(VARCHAR,END_DATE,103)


SELECT SETT_NO,SETT_TYPE,BILLNo,PARTY_CODE,LONG_NAME,BRANCH_CD,  
SCRIP_CD,SERIES,SCRIP_NAME,SEC_PAYIN,START_DATE,END_DATE,  
PQTY=SUM(PQTY),SQTY=SUM(SQTY),  
PNetRate=(Case When SUM(PQTY) > 0 Then SUM(PAMT)/SUM(PQTY) Else 0 End),
SNetRate=(Case When SUM(SQTY) > 0 Then SUM(SAMT)/SUM(SQTY) Else 0 End),  
PAMT=SUM(PAMT),SAMT=SUM(SAMT),  
NQTY=SUM(NQTY),NAMT=SUM(NAMT),  
BROKERAGE=SUM(BROKERAGE),  
SERVICE_TAX=SUM(SERVICE_TAX),  
STAMPDUTY=SUM(STAMPDUTY),SEBITAX=SUM(SEBITAX),  
TURNOVER_TAX=SUM(TURNOVER_TAX),STT=SUM(STT),OTHER_CHRG=SUM(OTHER_CHRG)  
FROM #SETT  
GROUP BY SETT_NO,SETT_TYPE,BILLNo,PARTY_CODE,LONG_NAME,BRANCH_CD,  
SCRIP_CD,SERIES,SCRIP_NAME,SEC_PAYIN,START_DATE,END_DATE  
ORDER BY SETT_NO,  
SETT_TYPE,         
BRANCH_CD,         
LONG_NAME,         
PARTY_CODE,         
SCRIP_NAME

GO
