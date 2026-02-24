-- Object: PROCEDURE dbo.V2_SLBS_CONFIRMATION_BAK_16102019
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
              
--EXEC V2_SLBS_CONFIRMATION 'BROKER','BROKER','OCT 10 2011','2011192','L','0','ZZZ','','ZZZZZZZZZZ','','ZZZZZZZZZZ','CONTRACT'                 
                  
        
CREATE  PROC [DBO].[V2_SLBS_CONFIRMATION]                    
(                    
 @STATUSID VARCHAR(15),                    
 @STATUSNAME VARCHAR(25),                     
 @SAUDA_DATE VARCHAR(11),                     
 @SETT_NO VARCHAR(7),                     
 @SETT_TYPE VARCHAR(2),                    
 @FROMPARTY_CODE VARCHAR(10),                     
 @TOPARTY_CODE VARCHAR(10),                     
 @FROMBRANCH VARCHAR(10),                    
 @TOBRANCH VARCHAR(10),                    
 @FROMSUB_BROKER VARCHAR(10),                    
 @TOSUB_BROKER VARCHAR(10),                    
 @CONTFLAG VARCHAR(10)                    
 )                     
AS                     
                    
DECLARE @COLNAME VARCHAR(6),                    
        @SDT DATETIME                     
                    
SELECT @SDT = CONVERT(DATETIME,@SAUDA_DATE)                    
                    
SELECT @COLNAME = ''                    
IF @CONTFLAG = 'CONTRACT'                     
 SELECT @COLNAME = RPT_CODE FROM V2_SLBSMEMO_PRINTING                     
 WHERE RPT_TYPE = 'ORDER' AND RPT_PRINTFLAG = 1                    
ELSE                    
 SELECT @COLNAME = RPT_CODE FROM V2_SLBSMEMO_PRINTING                     
 WHERE RPT_TYPE = 'ORDER' AND RPT_PRINTFLAG_DIGI = 1                    
                    
 --SET NOCOUNT ON                     
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                     
                    
        SELECT  CONTRACTNO,                       
                BILLNO,                       
                TRADE_NO,                       
                PARTY_CODE,                       
                SCRIP_CD,                       
                TRADEQTY,                       
                SERIES,                       
                ORDER_NO,                     
                MARKETRATE = CONVERT(NUMERIC(18,9),MARKETRATE),                       
                SAUDA_DATE,                       
                SELL_BUY,                     
                SETTFLAG,                       
                BROKAPPLIED,                       
    SCHEME,                    
                NETRATE,                       
                AMOUNT,                       
                INS_CHRG,                       
                TURN_TAX,                       
                OTHER_CHRG,                       
                SEBI_TAX,                       
                BROKER_CHRG,                       
                SERVICE_TAX,                       
                BILLFLAG,                       
                SETT_NO,                       
                NBROKAPP,                       
                NSERTAX,                       
                N_NETRATE,                       
                SETT_TYPE,                       
                TMARK,                    
    CPID                    
                    
        INTO    #SETT                     
        FROM    SETTLEMENT                     
        WHERE   1 = 2                     
              
  INSERT                   
        INTO    #SETT                   
        SELECT  CONTRACTNO,                         
                BILLNO=0,                         
    TRADE_NO=PRADNYA.DBO.REPLACETRADENO(TRADE_NO),                         
                PARTY_CODE,                         
                SCRIP_CD,                         
                TRADEQTY=SUM(TRADEQTY),                         
                SERIES,                  
                ORDER_NO,                  
                MARKETRATE = SUM(MARKETRATE*TRADEQTY)/SUM(TRADEQTY),                  
                SAUDA_DATE,          
                SELL_BUY,                  
                SETTFLAG,                     
                BROKAPPLIED=SUM(TRADEQTY*BROKAPPLIED),              
                SCHEME=(CASE WHEN SETT_TYPE = 'L' AND SELL_BUY = 2                 
        THEN 0                 
        WHEN SETT_TYPE = 'P' AND SELL_BUY = 1                 
    THEN 0                 
        ELSE SCHEME                 
      END),                     
                NETRATE=SUM(TRADEQTY*NETRATE)/SUM(TRADEQTY),                     
                AMOUNT=SUM(AMOUNT),                 
                INS_CHRG=SUM(INS_CHRG),                  
                TURN_TAX=SUM(TURN_TAX),                  
                OTHER_CHRG=SUM(OTHER_CHRG),                  
    SEBI_TAX=SUM(SEBI_TAX),                  
                BROKER_CHRG=SUM(BROKER_CHRG),                  
                SERVICE_TAX=SUM(SERVICE_TAX),                     
                BILLFLAG,                  
                SETT_NO,                     
                NBROKAPP=SUM(TRADEQTY*NBROKAPP),                     
                NSERTAX=SUM(NSERTAX),                    
                N_NETRATE=SUM(TRADEQTY*N_NETRATE)/SUM(TRADEQTY),                     
                SETT_TYPE,                     
    TMARK,                  
                CPID                  
        FROM    SETTLEMENT                   
        WHERE   SETT_TYPE = @SETT_TYPE                   
                AND SAUDA_DATE LIKE @SAUDA_DATE + '%'                   
                AND AUCTIONPART NOT IN ('AP', 'AR')                   
    AND MARKETRATE > 0 AND TRADEQTY > 0                 
                AND PARTY_CODE >= @FROMPARTY_CODE AND PARTY_CODE <= @TOPARTY_CODE                  
      GROUP BY  CONTRACTNO,                 
    PRADNYA.DBO.REPLACETRADENO(TRADE_NO),                        
    PARTY_CODE,                         
    SCRIP_CD,                  
    SERIES,                  
    ORDER_NO,                  
    MARKETRATE,                  
    SAUDA_DATE,                  
    SELL_BUY,                  
    SETTFLAG,                  
    BILLFLAG,                  
    SETT_NO,                  
    SETT_TYPE,                  
    TMARK,                
    CPID,              
    SCHEME               
                        
                         
                    
 SELECT DISTINCT S2.SCRIP_CD, S2.SERIES, SHORT_NAME INTO #SCRIP                    
 FROM SCRIP1 S1, SCRIP2 S2, #SETT S                    
 WHERE S1.CO_CODE   = S2.CO_CODE                       
 AND S2.SERIES    = S1.SERIES                       
 AND S2.SCRIP_CD  = S.SCRIP_CD                       
 AND S2.SERIES    = S.SERIES                    
          
          
DECLARE @PREDATE VARCHAR(11)          
SELECT @PREDATE = LEFT(MAX(SYSDATE),11)          
 FROM MSAJAG.DBO.CLOSING C (NOLOCK)          
 WHERE SYSDATE < @SAUDA_DATE          
          
 SELECT           
  SCRIP_CD,CL_RATE            
 INTO           
  #CLOSING          
 FROM MSAJAG.DBO.CLOSING C (NOLOCK)          
 WHERE SYSDATE BETWEEN @PREDATE AND @PREDATE + ' 23:59'                   
 AND SERIES = 'EQ'          
          
          
 CREATE CLUSTERED INDEX [SCR]                       
         ON [DBO].[#SCRIP]                       
         (                       
                 [SCRIP_CD],                    
   [SERIES]                    
         )                    
                    
                /*=========================================================================                                                      
                /*FOR THE #SETT*/                     
                =========================================================================*/                     
        SELECT  C2.PARTY_CODE,                     
                C1.LONG_NAME,                     
                C1.L_ADDRESS1,                     
                C1.L_ADDRESS2,                     
                C1.L_ADDRESS3,                     
                C1.L_CITY,                     
                C1.L_STATE,                     
                C1.L_ZIP,                     
                C1.BRANCH_CD ,                     
 C1.SUB_BROKER,                     
                C1.TRADER,                     
                C1.PAN_GIR_NO,                     
                C1.OFF_PHONE1,                     
                C1.OFF_PHONE2,                     
                PRINTF,                     
                MAPIDID=CONVERT(VARCHAR(20),''),                    
 UCC_CODE=CONVERT(VARCHAR(20),''),                    
                C2.SERVICE_CHRG,                     
                BROKERNOTE,                     
                TURNOVER_TAX,                     
                SEBI_TURN_TAX,                     
                C2.OTHER_CHRG,                     
                INSURANCE_CHRG,                    
     SEBI_NO = FD_CODE,          
  PARTICIPANT_CODE=BANKID,                    
  CL_TYPE                    
        INTO    #CLIENTMASTER                     
        FROM    CLIENT1 C1                     
        WITH                       
                (                       
                        NOLOCK                       
                )                       
                ,                     
                CLIENT2 C2                     
   WITH                       
                (                       
                        NOLOCK                       
                )                     
                    
        WHERE   C2.CL_CODE       = C1.CL_CODE                     
                AND C2.PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE                     
                AND @STATUSNAME = (                       
                CASE                     
       WHEN @STATUSID = 'BRANCH'                     
                        THEN C1.BRANCH_CD                     
                        WHEN @STATUSID = 'SUBBROKER'                     
                        THEN C1.SUB_BROKER                     
                        WHEN @STATUSID = 'TRADER'                     
                        THEN C1.TRADER                     
                        WHEN @STATUSID = 'FAMILY'                     
                        THEN C1.FAMILY                     
                        WHEN @STATUSID = 'AREA'                     
                        THEN C1.AREA                     
                        WHEN @STATUSID = 'REGION'                     
                        THEN C1.REGION                     
                        WHEN @STATUSID = 'CLIENT'                     
                        THEN C2.PARTY_CODE                     
                        ELSE 'BROKER' END)                     
                AND BRANCH_CD >= @FROMBRANCH                     
                AND BRANCH_CD <= @TOBRANCH                    
              AND SUB_BROKER >= @FROMSUB_BROKER                     
                AND SUB_BROKER <= @TOSUB_BROKER                     
                AND C2.PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #SETT)                    
                    
        CREATE CLUSTERED INDEX [PARTY]                       
                ON [DBO].[#CLIENTMASTER]                       
                (                       
                        [PARTY_CODE]                    
                )                    
                    
        UPDATE #CLIENTMASTER SET MAPIDID = UC.MAPIDID, UCC_CODE = UC.UCC_CODE                    
 FROM UCC_CLIENT UC                     
        WHERE #CLIENTMASTER.PARTY_CODE = UC.PARTY_CODE                     
                  
                  
 SELECT  CONTRACTNO,                     
                S.PARTY_CODE,                     
                ORDER_NO,                     
                ORDER_TIME=(                       
                CASE                     
                        WHEN CPID = 'NIL'                     
                        THEN '        '                     
                        ELSE RIGHT(CPID,8) END),                     
                TM=CONVERT(VARCHAR,SAUDA_DATE,108),                     
                TRADE_NO,        
                SAUDA_DATE,                     
                S.SCRIP_CD,                     
                S.SERIES,                     
                SCRIPNAME = (                     
                CASE                     
                        WHEN LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11) <> @SAUDA_DATE                     
                        THEN 'BF-'                     
              ELSE '' END ) + S2.SHORT_NAME + '   ' ,                     
                SDT = CONVERT(VARCHAR,@SDT,103),                     
                SELL_BUY,                     
                BROKER_CHRG =(                     
                CASE                     
                        WHEN BROKERNOTE = 1                     
                        THEN BROKER_CHRG                     
                        ELSE 0 END ),                     
                TURN_TAX =(                     
                CASE                     
                        WHEN TURNOVER_TAX = 1                     
                        THEN TURN_TAX                     
                        ELSE 0 END ),                     
                SEBI_TAX =(                     
                CASE                     
                        WHEN SEBI_TURN_TAX = 1                     
                        THEN SEBI_TAX                     
                        ELSE 0 END ),                     
                OTHER_CHRG =(                     
                CASE                     
                        WHEN C1.OTHER_CHRG = 1                     
                        THEN S.OTHER_CHRG                     
       ELSE 0 END ) ,                     
                INS_CHRG = (                     
                CASE                     
                        WHEN INSURANCE_CHRG = 1                     
                        THEN INS_CHRG                     
                        ELSE 0 END ),                     
                SERVICE_TAX = (                     
                CASE                     
                        WHEN SERVICE_CHRG = 0                     
                        THEN NSERTAX                     
                        ELSE 0 END ),                     
                NSERTAX = (                     
                CASE                     
                        WHEN SERVICE_CHRG = 0                     
                        THEN NSERTAX                     
                        ELSE 0 END ),                     
                SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),                     
                PQTY        = (                     
                CASE                     
                        WHEN SELL_BUY = 1                     
                        THEN TRADEQTY                     
                        ELSE 0 END ),                     
                SQTY = (                     
                CASE                     
                        WHEN SELL_BUY = 2                     
                        THEN TRADEQTY                     
                        ELSE 0 END ),                     
                PRATE = (                     
                CASE                     
                        WHEN SELL_BUY = 1                     
                        THEN MARKETRATE                     
                        ELSE 0 END ),                     
                SRATE = (                     
                CASE                     
                        WHEN SELL_BUY = 2                     
                        THEN MARKETRATE                     
                        ELSE 0 END ),                     
                PBROK = (                     
                CASE                     
                        WHEN SELL_BUY = 1                     
                        THEN NBROKAPP + (                     
                        CASE                     
                                WHEN SERVICE_CHRG = 1                     
              THEN NSERTAX                     
                                ELSE 0 END )                     
      ELSE 0 END ),                     
                SBROK = (                     
                CASE                     
                        WHEN SELL_BUY = 2                     
                        THEN NBROKAPP + (                     
                        CASE                     
                                WHEN SERVICE_CHRG = 1                     
                                THEN NSERTAX                  
                                ELSE 0 END )                     
                        ELSE 0 END ),                    
                PSCHEME = (                     
                CASE                     
                        WHEN SELL_BUY = 1                     
                        THEN S.SCHEME                     
                        ELSE 0 END ),                     
                SSCHEME = (                     
                CASE                     
                        WHEN SELL_BUY = 2                    
                        THEN S.SCHEME                     
                        ELSE 0 END ),                    
                  
    PSCHEMENETRATE =(                     
                CASE                     
                        WHEN SELL_BUY = 1                     
                    THEN (S.SCHEME + S.MARKETRATE)                  
                        ELSE 0 END ),                     
                    
    SSCHEMENETRATE =(                     
                CASE                     
                        WHEN SELL_BUY = 2                     
                        THEN (S.SCHEME + S.MARKETRATE)                     
                        ELSE 0 END ),                     
                  
                PNETRATE = (                     
                CASE                     
                        WHEN SELL_BUY = 1                     
                        THEN N_NETRATE + (                     
                        CASE                     
                                WHEN SERVICE_CHRG = 1                     
                                THEN NSERTAX/TRADEQTY                     
                                ELSE 0 END )                     
                        ELSE 0 END ),                     
                SNETRATE = (                     
                CASE                     
                        WHEN SELL_BUY = 2                     
                        THEN N_NETRATE - (                     
                        CASE                     
                                WHEN SERVICE_CHRG = 1                     
                                THEN NSERTAX/TRADEQTY                     
                                ELSE 0 END )                     
                        ELSE 0 END ),                     
                PAMT = (                     
          CASE                     
                        WHEN SELL_BUY = 1                     
                        THEN TRADEQTY*(N_NETRATE + (                     
                        CASE                     
                                WHEN SERVICE_CHRG = 1                     
                                THEN NSERTAX/TRADEQTY        
                                ELSE 0 END ))                     
                        ELSE 0 END ),                     
                SAMT = (                     
                CASE                     
                        WHEN SELL_BUY = 2                     
                        THEN TRADEQTY*(N_NETRATE - (                     
                        CASE                     
                                WHEN SERVICE_CHRG = 1                     
                                THEN NSERTAX/TRADEQTY                     
                                ELSE 0 END ))                     
                        ELSE 0 END ),                     
                BROKERAGE = NBROKAPP+(               
                CASE                     
                        WHEN SERVICE_CHRG = 1                     
                        THEN NSERTAX                     
                        ELSE 0 END ),              
                PTOTCHARGE = (CASE WHEN SELL_BUY = 1   
           THEN NBROKAPP  
           ELSE 0   
         END),                
                STOTCHARGE = (CASE WHEN SELL_BUY = 2   
              THEN NBROKAPP  
         ELSE 0 END),                
                     
                S.SETT_NO,                     
                S.SETT_TYPE,                     
                TRADETYPE = '  ',                     
    TMARK     =                     
                CASE                     
                        WHEN BILLFLAG = 1                     
                        OR BILLFLAG   = 4                     
                        OR BILLFLAG   = 5                     
                        THEN 'D'                     
             ELSE '' END ,                     
                /*TO DISPLAY THE HEADER PART*/                     
                PARTYNAME = C1.LONG_NAME,                     
                C1.L_ADDRESS1,                     
                C1.L_ADDRESS2,                     
                C1.L_ADDRESS3,                     
                C1.L_CITY,                    
  C1.L_STATE,                     
                C1.L_ZIP,                     
                C1.SERVICE_CHRG,                     
                C1.BRANCH_CD ,                     
                C1.SUB_BROKER,                     
                C1.TRADER,                     
                C1.PAN_GIR_NO,                     
                C1.OFF_PHONE1,                     
                C1.OFF_PHONE2,                     
                PRINTF,                     
                MAPIDID,                     
  UCC_CODE,                    
                ORDERFLAG  = 0,                     
  SCRIPNAMEFORORDERBY=S2.SHORT_NAME,                    
                SCRIPNAME1 = CONVERT(VARCHAR,(CASE WHEN CL_TYPE = 'NRI'                     
       THEN LTRIM(RTRIM(S2.SHORT_NAME)) + '_' + LTRIM(RTRIM(SELL_BUY))                     
              ELSE ''                     
         END), 52),                           
  SEBI_NO,                    
  PARTICIPANT_CODE,                    
  ACTSELL_BUY = SELL_BUY                    
                    
        INTO    #CONTSETT                
        FROM    #SETT S                     
        WITH                       
                (                       
                        NOLOCK                       
                )                       
                ,                     
                #CLIENTMASTER C1                     
        WITH                       
                (                       
                        NOLOCK                       
             )                       
                ,                     
                SETT_MST M                     
        WITH                       
                (                       
                        NOLOCK   
                )                       
                ,                     
                #SCRIP S2                     
        WHERE   S.SETT_NO       = @SETT_NO                     
                AND S.SETT_TYPE = @SETT_TYPE                     
                AND S.PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE                
                AND S.SETT_NO   = M.SETT_NO                     
                AND S.SETT_TYPE = M.SETT_TYPE                     
                AND M.END_DATE LIKE @SAUDA_DATE + '%'                     
                AND S2.SCRIP_CD  = S.SCRIP_CD                     
                AND S2.SERIES    = S.SERIES                     
                AND S.PARTY_CODE = C1.PARTY_CODE                     
                AND S.TRADEQTY   > 0                     
                                  
UPDATE    
 #CONTSETT                            
SET                            
 BROKERAGE = (CASE WHEN SELL_BUY =1                         
     THEN (CASE WHEN TMARK = '' THEN CD_TRDBUYBROKERAGE ELSE CD_DELBUYBROKERAGE END)                        
     ELSE (CASE WHEN TMARK = '' THEN CD_TRDSELLBROKERAGE ELSE CD_DELSELLBROKERAGE END)                        
       END)                        
           + (CASE WHEN SERVICE_CHRG = 1                         
     THEN CASE WHEN SELL_BUY =1                         
        THEN (CASE WHEN TMARK = '' THEN CD_TRDBUYSERTAX ELSE CD_DELBUYSERTAX END)                        
        ELSE (CASE WHEN TMARK = '' THEN CD_TRDSELLSERTAX ELSE CD_DELSELLSERTAX END)                        
   END                            
            ELSE 0                         
       END),            
PTOTCHARGE=(CASE WHEN SELL_BUY =1                         
     THEN (CASE WHEN TMARK = '' THEN CD_TRDBUYBROKERAGE ELSE CD_DELBUYBROKERAGE END)                        
     ELSE 0                        
       END),              
STOTCHARGE=(CASE WHEN SELL_BUY =1                         
     THEN 0                        
     ELSE (CASE WHEN TMARK = '' THEN CD_TRDSELLBROKERAGE ELSE CD_DELSELLBROKERAGE END)                        
       END),                             
 SERVICE_TAX = SERVICE_TAX + (CASE WHEN SERVICE_CHRG = 0                         
     THEN CASE WHEN SELL_BUY =1                         
        THEN (CASE WHEN TMARK = '' THEN CD_TRDBUYSERTAX ELSE CD_DELBUYSERTAX END)                        
        ELSE (CASE WHEN TMARK = '' THEN CD_TRDSELLSERTAX ELSE CD_DELSELLSERTAX END)                        
   END                            
            ELSE 0                         
       END),         
 NSERTAX = NSERTAX + (CASE WHEN SERVICE_CHRG = 0                         
     THEN CASE WHEN SELL_BUY =1                         
        THEN (CASE WHEN TMARK = '' THEN CD_TRDBUYSERTAX ELSE CD_DELBUYSERTAX END)                        
        ELSE (CASE WHEN TMARK = '' THEN CD_TRDSELLSERTAX ELSE CD_DELSELLSERTAX END)                        
   END                            
            ELSE 0                         
       END),                        
                        
PAMT     = (CASE WHEN SELL_BUY =1                         
     THEN PAMT + (CASE WHEN TMARK = '' THEN CD_TRDBUYBROKERAGE ELSE CD_DELBUYBROKERAGE END)                        
     ELSE 0                        
       END)                        
           + (CASE WHEN SERVICE_CHRG = 1                         
     THEN CASE WHEN SELL_BUY =1                         
        THEN (CASE WHEN TMARK = '' THEN CD_TRDBUYSERTAX ELSE CD_DELBUYSERTAX END)                        
        ELSE 0                        
   END                            
            ELSE 0                         
       END),                        
SAMT     = (CASE WHEN SELL_BUY = 2                        
     THEN SAMT - (CASE WHEN TMARK = '' THEN CD_TRDSELLBROKERAGE ELSE CD_DELSELLBROKERAGE END)                        
     ELSE 0                     
       END)                        
           + (CASE WHEN SERVICE_CHRG = 1                         
     THEN CASE WHEN SELL_BUY = 2                        
        THEN (CASE WHEN TMARK = '' THEN CD_TRDSELLSERTAX ELSE CD_DELSELLSERTAX END)                        
        ELSE 0                        
   END                            
            ELSE 0                         
       END)                             
FROM                            
 CHARGES_DETAIL                            
WHERE                            
 CD_SETT_NO = #CONTSETT.SETT_NO                          
 AND CD_SETT_TYPE = #CONTSETT.SETT_TYPE                          
 AND CD_PARTY_CODE = #CONTSETT.PARTY_CODE                             
 AND CD_SCRIP_CD = #CONTSETT.SCRIP_CD                          
 AND CD_SERIES = #CONTSETT.SERIES                          
 AND CD_TRADE_NO = TRADE_NO                            
 AND CD_ORDER_NO = ORDER_NO                    
       
 INSERT                       
INTO    #CONTSETT                    
 SELECT  CONTRACTNO='0',                             
                S.CD_PARTY_CODE,                             
     CD_ORDER_NO,                             
                ORDER_TIME='',                             
                TM='',                             
                TRADE_NO='',                             
                CD_SAUDA_DATE,                             
                S.CD_SCRIP_CD,                             
                S.CD_SERIES,                             
                SCRIPNAME = (                             
                CASE                          
                        WHEN LEFT(CONVERT(VARCHAR,CD_SAUDA_DATE,109),11) <> @SAUDA_DATE                             
                        THEN 'BF-'                             
                        ELSE '' END ) + ISNULL(S2.SHORT_NAME,'BROKERAGE') + '   ' ,                    
                SDT = CONVERT(VARCHAR,@SDT,103),                             
                SELL_BUY=1,                             
                BROKER_CHRG =0,                             
                TURN_TAX =0,                             
                SEBI_TAX =0,                             
                OTHER_CHRG =0,                             
                INS_CHRG =0,                             
                SERVICE_TAX = (                             
                CASE                             
                        WHEN SERVICE_CHRG = 0                             
                        THEN CD_TRDBUYSERTAX+CD_DELBUYSERTAX+CD_TRDSELLSERTAX+CD_DELSELLSERTAX                          
ELSE 0 END ),                             
                NSERTAX = (                             
                CASE                             
                        WHEN SERVICE_CHRG = 0                             
                        THEN CD_TRDBUYSERTAX+CD_DELBUYSERTAX+CD_TRDSELLSERTAX+CD_DELSELLSERTAX                  
                        ELSE 0 END ),                             
                SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,CD_SAUDA_DATE,109),11),                             
                PQTY = 0,                             
                SQTY = 0,                             
                PRATE = 0,                             
                SRATE = 0,                             
                PBROK = 0,                             
                SBROK = 0,               
                PSCHEME = 0,                     
                SSCHEME = 0,              
PSCHEMENETRATE =0,                     
                    
  SSCHEMENETRATE =0,                                                     
                PNETRATE =0,                             
                SNETRATE =0,                             
                PAMT =CD_TRDBUYBROKERAGE+CD_DELBUYBROKERAGE+CD_TRDSELLBROKERAGE+CD_DELSELLBROKERAGE+(                             
                CASE                          
                        WHEN SERVICE_CHRG = 1                              
                        THEN CD_TRDBUYSERTAX+CD_DELBUYSERTAX+CD_TRDSELLSERTAX+CD_DELSELLSERTAX                          
                        ELSE 0 END ),           
                SAMT =0,                             
                BROKERAGE = CD_TRDBUYBROKERAGE+CD_DELBUYBROKERAGE+CD_TRDSELLBROKERAGE+CD_DELSELLBROKERAGE+(                             
                CASE                             
                        WHEN SERVICE_CHRG = 1                              
                        THEN CD_TRDBUYSERTAX+CD_DELBUYSERTAX+CD_TRDSELLSERTAX+CD_DELSELLSERTAX                          
                        ELSE 0 END ),                             
                S.CD_SETT_NO,                             
                S.CD_SETT_TYPE,                             
                TRADETYPE = '  ',                             
                TMARK     = ' ',                             
                --TO DISPLAY THE HEADER PART                    
                PARTYNAME = C1.LONG_NAME,                             
                C1.L_ADDRESS1,                             
                C1.L_ADDRESS2,                             
                C1.L_ADDRESS3,                             
                C1.L_CITY,                            
  C1.L_STATE,                             
                C1.L_ZIP,                             
                C1.SERVICE_CHRG,                             
                C1.BRANCH_CD ,                    
                C1.SUB_BROKER,                             
                C1.TRADER,                             
                C1.PAN_GIR_NO,                             
                C1.OFF_PHONE1,                             
                C1.OFF_PHONE2,                             
                PRINTF,                             
                MAPIDID,                             
  UCC_CODE,                            
                ORDERFLAG  = 4,                             
  SCRIPNAMEFORORDERBY=ISNULL(S2.SHORT_NAME,'ZZZBROKERAGE'),                          
                SCRIPNAME1 = CONVERT(VARCHAR,(CASE WHEN CL_TYPE = 'NRI'                             
       THEN LTRIM(RTRIM(ISNULL(S2.SHORT_NAME,'BROKERAGE'))) + '_' + LTRIM(RTRIM(1))                             
              ELSE ''                             
         END), 52),                                   
   SEBI_NO,                            
   PARTICIPANT_CODE,                            
   ACTSELL_BUY = 1,                    
                PSCHEME = 0,                     
                SSCHEME = 0                    
                    
                    
        FROM    CHARGES_DETAIL S LEFT OUTER JOIN #SCRIP S2                            
 ON (    S2.SCRIP_CD  = S.CD_SCRIP_CD                             
             AND S2.SERIES    = S.CD_SERIES   ),                             
                #CLIENTMASTER C1                             
        WITH                               
                (                               
                        NOLOCK                               
                )                               
                ,                             
                SETT_MST M                             
        WITH                               
                (                               
   NOLOCK                               
                )                               
                                           
        WHERE   S.CD_SETT_NO       = @SETT_NO                             
                AND S.CD_SETT_TYPE = @SETT_TYPE                             
                AND S.CD_PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE                      
                AND S.CD_SETT_NO   = M.SETT_NO                             
                AND S.CD_SETT_TYPE = M.SETT_TYPE                             
                AND M.END_DATE LIKE @SAUDA_DATE + '%'                             
                AND S.CD_PARTY_CODE = C1.PARTY_CODE                             
  AND CD_TRDBUYBROKERAGE+CD_DELBUYBROKERAGE+CD_TRDSELLBROKERAGE+CD_DELSELLBROKERAGE > 0                          
  AND CD_TRADE_NO = ''                     
                    
                    
                /*=========================================================================                                                      
                /* ND RECORD BROUGHT FORWARD FOR SAME DAY OR PREVIOUS DAYS */                     
                =========================================================================*/                     
        
                    
         CREATE INDEX [DELPOS]                       
                ON [DBO].[#CONTSETT]                       
                (                       
                        [SAUDA_DATE],                       
                        [SETT_TYPE],                       
                        [PARTY_CODE],                       
                        [SCRIP_CD],                       
                        [SERIES]                       
                )                    
                    
                    
  SELECT  CONTRACTNO,                     
                PARTY_CODE,                     
                ORDER_NO   ='0000000000000000',                     
                ORDER_TIME ='        ',                     
                TM         ='        ',                     
                TRADE_NO   ='00000000000',                     
                SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),                     
                SCRIP_CD,                     
                SERIES,                     
                SCRIPNAME=CONVERT(VARCHAR(100),SCRIPNAME),                     
                SDT,                     
                SELL_BUY,                     
                BROKER_CHRG =SUM(BROKER_CHRG),                     
                TURN_TAX    =SUM(TURN_TAX),                     
                SEBI_TAX    =SUM(SEBI_TAX),                     
                OTHER_CHRG  =SUM(OTHER_CHRG),                     
                INS_CHRG    = SUM(INS_CHRG),       
                SERVICE_TAX = SUM(SERVICE_TAX),                     
                NSERTAX     =SUM(NSERTAX),                     
                SAUDA_DATE1,                     
                PQTY =SUM(PQTY),                     
                SQTY =SUM(SQTY),                     
                PRATE=(                     
                CASE                     
                        WHEN SUM(PQTY) > 0                     
                        THEN SUM(PRATE*PQTY)/SUM(PQTY)                     
                        ELSE 0 END ),                     
                SRATE=(                     
                CASE                     
      WHEN SUM(SQTY) > 0                     
                        THEN SUM(SRATE*SQTY)/SUM(SQTY)                     
                        ELSE 0 END ),                     
                PBROK=(                     
                CASE                     
                        WHEN SUM(PQTY) > 0                     
                        THEN SUM(PBROK*PQTY)/SUM(PQTY)                     
                        ELSE 0 END ),                     
                SBROK=(                     
                CASE                     
                        WHEN SUM(SQTY) > 0                     
                        THEN SUM(SBROK*SQTY)/SUM(SQTY)                     
                        ELSE 0 END ),                     
                PSCHEME = (          
                CASE                     
                        WHEN SUM(PQTY) > 0                     
                        THEN SUM(PSCHEME*PQTY)/SUM(PQTY)                      
                        ELSE 0 END ),                     
                SSCHEME = (                     
                CASE                     
                        WHEN SUM(SQTY) > 0                     
                        THEN SUM(SSCHEME*SQTY)/SUM(SQTY)                      
      ELSE 0 END ),                     
    PSCHEMENETRATE = (                     
                CASE                     
      WHEN SUM(PQTY) > 0                     
                        THEN SUM(PSCHEMENETRATE*PQTY)/SUM(PQTY)                      
                        ELSE 0 END ),                  
    SSCHEMENETRATE = (                     
                CASE                     
                        WHEN SUM(SQTY) > 0                     
                        THEN SUM(SSCHEMENETRATE*SQTY)/SUM(SQTY)                      
                        ELSE 0 END ),                  
                PNETRATE=(                     
                CASE                     
                        WHEN SUM(PQTY) > 0                     
                        THEN SUM(PAMT)/SUM(PQTY)                     
                        ELSE 0 END ),                     
             SNETRATE=(                     
                CASE                     
                        WHEN SUM(SQTY) > 0                     
                  THEN SUM(SRATE*SQTY)/SUM(SQTY)                     
                        ELSE 0 END ),                     
                PAMT     =SUM(PAMT),                     
                SAMT     =SUM(SAMT),                     
                BROKERAGE=SUM(BROKERAGE),                     
    PTOTCHARGE=SUM(PTOTCHARGE),                
    STOTCHARGE=SUM(STOTCHARGE),                
                SETT_NO,                     
                SETT_TYPE,                     
                TRADETYPE,                     
                TMARK,                     
                PARTYNAME,                     
                L_ADDRESS1,                     
                L_ADDRESS2,                     
                L_ADDRESS3,                     
                L_CITY,                     
    L_STATE,                    
    L_ZIP,                     
                SERVICE_CHRG,                     
                BRANCH_CD,                     
                SUB_BROKER,                     
                TRADER,                     
                PAN_GIR_NO,                     
                OFF_PHONE1,                     
    OFF_PHONE2,                     
    PRINTF,              
    MAPIDID,                     
    UCC_CODE,                    
    ORDERFLAG,                    
    SCRIPNAMEFORORDERBY=CONVERT(VARCHAR(100),SCRIPNAMEFORORDERBY),                     
    SCRIPNAME1,                        
    SEBI_NO,                    
    PARTICIPANT_CODE,                    
    ACTSELL_BUY,                    
                ISIN = CONVERT(VARCHAR(12),''),          
    SLP = CONVERT(NUMERIC(18,4),0),          
    RETURNSESSIONNO = CONVERT(VARCHAR(12),'')          
        INTO    #CONTSETTNEW                     
        FROM    #CONTSETT                     
        WITH                      
                (                       
                        NOLOCK                       
                )                     
        WHERE   PRINTF IN ('3','4','6')                    
        GROUP BY CONTRACTNO,                     
                PARTY_CODE,                     
                LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),                     
                SCRIP_CD,                     
                SERIES,                     
                SCRIPNAME,  
                SDT,                     
                SELL_BUY,                     
                SETT_NO,                     
                SETT_TYPE,                     
                SAUDA_DATE1,                     
                TRADETYPE,                     
                TMARK,                     
                PARTYNAME,                     
                L_ADDRESS1,                     
  L_ADDRESS2,                     
                L_ADDRESS3,                     
                L_CITY,                     
    L_STATE,                    
    L_ZIP,                     
    SERVICE_CHRG,                     
    BRANCH_CD,                     
    SUB_BROKER,                     
    TRADER,                     
    PAN_GIR_NO,                     
    OFF_PHONE1,                     
    OFF_PHONE2,                     
    PRINTF,                     
    MAPIDID,                     
    UCC_CODE,                    
    ORDERFLAG,                    
    SCRIPNAMEFORORDERBY,                    
    SCRIPNAME1,                    
    SEBI_NO,                    
    PARTICIPANT_CODE,                    
    ACTSELL_BUY                  
                  
        INSERT                     
        INTO    #CONTSETTNEW SELECT  *,                     
                ISIN = CONVERT(VARCHAR(12),''),          
    SLP = CONVERT(NUMERIC(18,4),0),          
    RETURNSESSIONNO = CONVERT(VARCHAR(12),'')                     
        FROM    #CONTSETT                     
        WITH                       
                (                       
                        NOLOCK                       
                )                     
        WHERE   PRINTF NOT IN ('3','4','6')                    
                    
        CREATE INDEX [DELPOS]                       
           ON [DBO].[#CONTSETTNEW]                       
                (                       
                        [SAUDA_DATE],                       
                        [SETT_TYPE],                       
                        [PARTY_CODE],                       
                        [SCRIP_CD],                       
                        [SERIES]                       
                )                    
                    
        UPDATE #CONTSETTNEW                     
                SET ORDER_NO = S.ORDER_NO,                     
                TM           = CONVERT(VARCHAR,S.SAUDA_DATE,108),                     
                TRADE_NO     = S.TRADE_NO,                     
                ORDER_TIME   = S.ORDER_TIME                     
        FROM    #CONTSETT S                     
        WITH                       
                (                       
                        NOLOCK                       
                )                     
        WHERE   S.PRINTF     = #CONTSETTNEW.PRINTF                     
                AND S.PRINTF IN ('3','4','6')                    
                AND S.SAUDA_DATE LIKE @SAUDA_DATE + '%'                     
                AND S.SCRIP_CD      = #CONTSETTNEW.SCRIP_CD                     
                AND S.SERIES        = #CONTSETTNEW.SERIES                     
                AND S.PARTY_CODE    = #CONTSETTNEW.PARTY_CODE                     
                AND S.CONTRACTNO    = #CONTSETTNEW.CONTRACTNO                     
                AND S.ACTSELL_BUY   = #CONTSETTNEW.ACTSELL_BUY                     
                AND S.SAUDA_DATE =                     
                (SELECT MIN(SAUDA_DATE)                     
                FROM    #CONTSETT ISETT                     
                WITH                       
                        (                       
                                NOLOCK                       
                        )                     
                WHERE   PRINTF IN ('3','4','6')                    
                      AND ISETT.SAUDA_DATE LIKE @SAUDA_DATE + '%'                     
                        AND S.SCRIP_CD    = ISETT.SCRIP_CD                     
                        AND S.SERIES      = ISETT.SERIES                     
                        AND S.PARTY_CODE  = ISETT.PARTY_CODE                     
                        AND S.CONTRACTNO  = ISETT.CONTRACTNO                     
                        AND S.ACTSELL_BUY = ISETT.ACTSELL_BUY                     
                )                     
        UPDATE #CONTSETTNEW                     
                SET ISIN = M.ISIN                     
        FROM    MULTIISIN M                     
        WHERE   M.SCRIP_CD   = #CONTSETTNEW.SCRIP_CD                        
                AND M.SERIES = (                    
                CASE                     
                        WHEN #CONTSETTNEW.SERIES = 'BL'              
                        THEN 'EQ'                     
                        WHEN #CONTSETTNEW.SERIES = 'IL'                     
                        THEN 'EQ'                     
                        ELSE #CONTSETTNEW.SERIES   END)                        
                AND VALID = 1                     
           
 UPDATE #CONTSETTNEW           
 SET SLP = #CLOSING.CL_RATE          
 FROM #CLOSING           
 WHERE #CONTSETTNEW.SCRIP_CD = #CLOSING.SCRIP_CD             
        
          
 UPDATE #CONTSETTNEW SET RETURNSESSIONNO = R.SETT_NO, SCRIPNAME = RTRIM(LTRIM(SCRIPNAME)) + '-' + REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,EXPIRYDATE),106),' ',''),        
 SCRIPNAMEFORORDERBY = RTRIM(LTRIM(SCRIPNAMEFORORDERBY)) + '-' + REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,EXPIRYDATE),106),' ','')        
 FROM (          
  SELECT DISTINCT SETT_NO, EXPIRYDATE, T.SERIES FROM TRD_SETT_POS T, SETT_MST S          
  WHERE SAUDA_DATE LIKE @SAUDA_DATE + '%' AND S.SEC_PAYIN = CONVERT(DATETIME,EXPIRYDATE)          
  AND S.SETT_TYPE = 'P'          
   ) R          
 WHERE #CONTSETTNEW.SERIES = R.SERIES          
           
 IF (@CONTFLAG = 'CONTRACT')                     
 BEGIN                     
 SELECT ORDERBYFLAG = (CASE WHEN @COLNAME = 'ORD_N'                     
              THEN PARTYNAME                    
         WHEN @COLNAME = 'ORD_P'                    
         THEN PARTY_CODE                    
         WHEN @COLNAME = 'ORD_BP'                    
         THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(PARTY_CODE))                    
         WHEN @COLNAME = 'ORD_BN'                    
         THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(PARTYNAME))                    
         WHEN @COLNAME = 'ORD_DP'                    
         THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(PARTY_CODE))                    
         WHEN @COLNAME = 'ORD_DN'                    
         THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(PARTYNAME))                    
              ELSE RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(PARTY_CODE))                    
                END),                    
  CONTRACTNO,                       
                PARTY_CODE,                       
                ORDER_NO,                       
                ORDER_TIME,                       
     TM,                     
                TRADE_NO,                       
                SAUDA_DATE,                       
                SCRIP_CD,                       
                SERIES,                       
                SCRIPNAME,                     
  PSCRIPNAME = (                    
  CASE                     
   WHEN SELL_BUY=1                     
   THEN SCRIPNAME                     
   ELSE '' END),                     
  SSCRIPNAME = (                    
  CASE                     
   WHEN SELL_BUY=2               
   THEN SCRIPNAME                     
   ELSE '' END),                     
                SDT,                       
                SELL_BUY,                      
                BROKER_CHRG,                       
                TURN_TAX,                    
                PBROKER_CHRG=(                    
    CASE                    
     WHEN SELL_BUY = 1                    
     THEN BROKER_CHRG                    
     ELSE 0 END),                    
    SBROKER_CHRG=(                    
    CASE                    
     WHEN SELL_BUY = 2                    
     THEN BROKER_CHRG                    
     ELSE 0 END),                    
     PTURN_TAX=(                    
    CASE                    
     WHEN SELL_BUY = 1                    
     THEN TURN_TAX                    
     ELSE 0 END),                    
    STURN_TAX=(                    
    CASE                    
     WHEN SELL_BUY = 2                    
     THEN TURN_TAX                    
     ELSE 0 END),                    
     POTHER_CHRG=(                    
    CASE                    
     WHEN SELL_BUY = 1                    
     THEN OTHER_CHRG                    
     ELSE 0 END),                    
    SOTHER_CHRG=(                    
    CASE                    
     WHEN SELL_BUY = 2                    
     THEN OTHER_CHRG                    
     ELSE 0 END),                         
                SEBI_TAX,                       
                OTHER_CHRG,                       
                INS_CHRG,                     
                PINS_CHRG=(                       
                CASE                     
                        WHEN SELL_BUY = 1                     
                        THEN INS_CHRG                    
                        ELSE 0 END),   
                SINS_CHRG=(                       
                CASE                     
                      WHEN SELL_BUY = 2                     
                        THEN INS_CHRG                     
                        ELSE 0 END),                     
                SERVICE_TAX,                       
                NSERTAX,                    
    PNSERTAX=(                    
    CASE                     
                        WHEN SELL_BUY = 1                     
                        THEN NSERTAX                     
                        ELSE 0 END),                     
    SNSERTAX=(                    
    CASE                     
                        WHEN SELL_BUY = 2                     
                        THEN NSERTAX                     
                        ELSE 0 END),                     
                SAUDA_DATE1,                       
    QTY = (PQTY + SQTY),                    
                PQTY,                       
                SQTY,                     
                RATE = PRATE + SRATE,                     
                PRATE,                       
                SRATE,                     
                BROK = PBROK+SBROK,                     
                PBROK,                       
                SBROK,                     
                PSCHEME,                     
                SSCHEME,                  
    SCHEME = (PSCHEME + SSCHEME),                  
    PSCHEMENETRATE,                  
    SSCHEMENETRATE,                  
    SCHEMENETRATE = (PSCHEMENETRATE + SSCHEMENETRATE),                  
                NETRATE = PNETRATE +SNETRATE,                     
                PNETRATE= PNETRATE, --(CASE WHEN PQTY > 0 THEN PAMT/PQTY ELSE 0 END),          
                SNETRATE= SNETRATE,--SRATE, --(CASE WHEN SQTY > 0 THEN (SRATE*SQTY)/SQTY ELSE 0 END),          
                AMT = (                       
                CASE                     
                        WHEN SELL_BUY = 1                     
                        THEN -PAMT                     
ELSE SAMT END),                       
                PAMT,                       
                SAMT,                     
             AMTSTT = (                       
                CASE                     
                        WHEN SELL_BUY = 1                     
                        THEN -(PAMT+INS_CHRG)                     
                        ELSE (SAMT-INS_CHRG) END),                     
                PAMTSTT = (                       
                CASE                     
                        WHEN SELL_BUY = 1                     
                        THEN PAMT+INS_CHRG                     
                        ELSE 0 END),                     
                SAMTSTT = (                       
                CASE                     
                        WHEN SELL_BUY = 2                     
                        THEN SAMT-INS_CHRG                     
                        ELSE 0 END),                    
    AMTSER = (                       
    CASE                     
      WHEN SELL_BUY = 1                     
      THEN -(PAMT+NSERTAX)                     
      ELSE (SAMT-NSERTAX) END),                     
    PAMTSER = (                       
    CASE                     
      WHEN SELL_BUY = 1                     
      THEN PAMT+NSERTAX                     
      ELSE 0 END),                     
    SAMTSER = (                       
    CASE                     
      WHEN SELL_BUY = 2                     
      THEN SAMT-NSERTAX                     
      ELSE 0 END),                    
    AMTSERSTT = (                       
    CASE                     
      WHEN SELL_BUY = 1                     
      THEN -(PAMT+NSERTAX+INS_CHRG)                     
      ELSE (SAMT-NSERTAX-INS_CHRG) END),                     
    PAMTSERSTT = (                       
    CASE                     
      WHEN SELL_BUY = 1                     
      THEN PAMT+NSERTAX+INS_CHRG                     
      ELSE 0 END),                     
    SAMTSERSTT = (                       
    CASE                     
      WHEN SELL_BUY = 2                     
      THEN SAMT-NSERTAX-INS_CHRG                    
      ELSE 0 END),                    
          
    AMTSERSTTSTAMPTRANS = (                       
    CASE                     
      WHEN SELL_BUY = 1                     
      THEN -(PAMT+NSERTAX+INS_CHRG+BROKER_CHRG+TURN_TAX)                     
      ELSE (SAMT-NSERTAX-INS_CHRG-BROKER_CHRG-TURN_TAX) END),                          
    PAMTSERSTTSTAMPTRANS = (                       
    CASE                     
      WHEN SELL_BUY = 1                     
      THEN PAMT+NSERTAX+INS_CHRG+BROKER_CHRG+TURN_TAX                     
      ELSE 0 END),                     
    SAMTSERSTTSTAMPTRANS = (                       
    CASE                     
      WHEN SELL_BUY = 2                     
      THEN SAMT-NSERTAX-INS_CHRG-BROKER_CHRG-TURN_TAX                    
      ELSE 0 END),                    
                    
                MARKETAMT  = (PRATE + SRATE) * (PQTY+SQTY),                     
                PMARKETAMT = PRATE * PQTY ,                     
                SMARKETAMT = SRATE * SQTY ,                     
                BROKERAGE,                       
    PBROKERAGE=(CASE WHEN SELL_BUY = 1 THEN BROKERAGE ELSE 0 END),                       
    SBROKERAGE=(CASE WHEN SELL_BUY = 2 THEN BROKERAGE ELSE 0 END),                
    PTOTCHARGE,                
    STOTCHARGE,                       
    SETT_NO,                     
    SETT_TYPE,                       
    TRADETYPE,                       
    TMARK,                       
    PARTYNAME,                       
    L_ADDRESS1,                     
    L_ADDRESS2,                       
    L_ADDRESS3,                       
    L_CITY,                       
    L_STATE,                    
    L_ZIP,                       
    SERVICE_CHRG,                     
    BRANCH_CD,                       
    SUB_BROKER,                       
    TRADER,                       
    PAN_GIR_NO,                       
    OFF_PHONE1,                     
    OFF_PHONE2,                       
    PRINTF,                       
    MAPIDID,                       
    UCC_CODE,                    
    ORDERFLAG,                    
    SCRIPNAMEFORORDERBY,                    
    SCRIPNAME1,                    
    ISIN,                    
    SEBI_NO,                    
    PARTICIPANT_CODE,          
    SLP = SLP,          
    RETURNSESSIONNO                    
        FROM    #CONTSETTNEW                     
        WITH                       
                (                       
               NOLOCK                       
                )                     
        WHERE   PRINTF NOT IN ('1','2','6')                    
        ORDER BY ORDERBYFLAG,                    
    BRANCH_CD,                     
    SUB_BROKER,                     
    TRADER,                     
    PARTY_CODE,                     
    PARTYNAME,                    
    SCRIPNAMEFORORDERBY,                    
    SCRIPNAME1,                     
    CONTRACTNO DESC,                    
    ORDERFLAG,                     
    SETT_NO,                     
    SETT_TYPE,                     
    TM,                    
    ORDER_NO,                     
    TRADE_NO                     
 END                     
        ELSE                     
 BEGIN                     
 SELECT                      
 ORDERBYFLAG = (CASE WHEN @COLNAME = 'ORD_N'                     
     THEN PARTYNAME                    
     WHEN @COLNAME = 'ORD_P'                    
     THEN PARTY_CODE                    
     WHEN @COLNAME = 'ORD_BP'                    
     THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(PARTY_CODE))                    
     WHEN @COLNAME = 'ORD_BN'                    
     THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(PARTYNAME))                    
     WHEN @COLNAME = 'ORD_DP'                    
     THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(PARTY_CODE))                    
     WHEN @COLNAME = 'ORD_DN'                    
     THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(PARTYNAME))                    
     ELSE RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(PARTY_CODE))                    
      END),                     
 CONTRACTNO,                    
        PARTY_CODE,                       
        ORDER_NO,                       
        ORDER_TIME,                       
        TM,                     
        TRADE_NO,          
        SAUDA_DATE,                       
        SCRIP_CD,                       
        SERIES,                       
        SCRIPNAME,                     
 PSCRIPNAME = (                    
 CASE                     
  WHEN SELL_BUY=1                     
  THEN SCRIPNAME                     
  ELSE '' END),                     
 SSCRIPNAME = (                    
 CASE                     
  WHEN SELL_BUY=2                     
  THEN SCRIPNAME                     
  ELSE '' END),                     
        SDT,                       
 SELL_BUY,                    
        BROKER_CHRG,                       
        TURN_TAX,                    
        PBROKER_CHRG=(                    
 CASE                    
  WHEN SELL_BUY = 1                    
  THEN BROKER_CHRG                    
  ELSE 0 END),                    
        SBROKER_CHRG=(                    
 CASE                    
  WHEN SELL_BUY = 2                    
  THEN BROKER_CHRG                    
  ELSE 0 END),                    
        PTURN_TAX=(                    
 CASE                    
  WHEN SELL_BUY = 1               
  THEN TURN_TAX                    
  ELSE 0 END),                    
        STURN_TAX=(                    
 CASE                    
  WHEN SELL_BUY = 2                    
  THEN TURN_TAX                    
  ELSE 0 END),          
     POTHER_CHRG=(                    
    CASE                    
     WHEN SELL_BUY = 1                    
     THEN OTHER_CHRG                    
     ELSE 0 END),                    
    SOTHER_CHRG=(                    
    CASE                    
     WHEN SELL_BUY = 2                    
     THEN OTHER_CHRG                    
     ELSE 0 END),              
        SEBI_TAX,                       
        OTHER_CHRG,                       
        INS_CHRG,                     
        PINS_CHRG=(                       
        CASE                     
                WHEN SELL_BUY = 1                     
                THEN INS_CHRG                     
                ELSE 0 END),                     
        SINS_CHRG=(                       
        CASE                     
                WHEN SELL_BUY = 2                     
                THEN INS_CHRG                     
                ELSE 0 END),       
        SERVICE_TAX,                       
        NSERTAX,                    
  PNSERTAX=(                    
        CASE                     
                WHEN SELL_BUY = 1                     
                THEN NSERTAX                     
                ELSE 0 END),                     
  SNSERTAX=(                    
        CASE                     
                WHEN SELL_BUY = 2                     
                THEN NSERTAX                     
                ELSE 0 END),                     
        SAUDA_DATE1,                       
        QTY = (PQTY + SQTY),                       
        PQTY,                       
        SQTY,                     
        RATE = PRATE + SRATE,                     
        PRATE,                  
        SRATE,                     
        BROK = PBROK+SBROK,                     
        PBROK,                       
        SBROK,                     
        PSCHEME,                     
        SSCHEME,                    
  SCHEME = (PSCHEME + SSCHEME),                  
  PSCHEMENETRATE,                  
  SSCHEMENETRATE,                  
  SCHEMENETRATE = (PSCHEMENETRATE + SSCHEMENETRATE),                  
        NETRATE = (          
        CASE          
                WHEN SELL_BUY = 1          
                THEN -PAMT          
                ELSE SAMT           
  END)/(PQTY + SQTY),            
        PNETRATE= PNETRATE,--(CASE WHEN PQTY > 0 THEN PAMT/PQTY ELSE 0 END),          
        SNETRATE= SNETRATE,--SRATE, --(CASE WHEN SQTY > 0 THEN SAMT/SQTY ELSE 0 END),          
        AMT = (          
        CASE          
                WHEN SELL_BUY = 1          
                THEN -PAMT          
                ELSE SAMT END),          
        PAMT,                       
        SAMT,                     
        AMTSTT = (                       
        CASE                     
                WHEN SELL_BUY = 1                     
                THEN -(PAMT+INS_CHRG)                     
                ELSE (SAMT-INS_CHRG) END),                     
        PAMTSTT = (                       
        CASE                     
                WHEN SELL_BUY = 1                     
                THEN PAMT+INS_CHRG                     
                ELSE 0 END),                     
        SAMTSTT = (                       
       CASE                     
                WHEN SELL_BUY = 2                     
                THEN SAMT-INS_CHRG                     
                ELSE 0 END),                    
  AMTSER = (                    
        CASE                     
       WHEN SELL_BUY = 1                     
                THEN -(PAMT+NSERTAX)                     
                ELSE (SAMT-NSERTAX) END),                     
        PAMTSER = (                       
        CASE                     
                WHEN SELL_BUY = 1                     
                THEN PAMT+NSERTAX                     
                ELSE 0 END),                     
        SAMTSER = (                       
        CASE                     
                WHEN SELL_BUY = 2                     
                THEN SAMT-NSERTAX                     
                ELSE 0 END),                            
  AMTSERSTT = (                       
        CASE                     
                WHEN SELL_BUY = 1                     
                THEN -(PAMT+NSERTAX+INS_CHRG)                     
                ELSE (SAMT-NSERTAX-INS_CHRG) END),                     
        PAMTSERSTT = (                       
        CASE                     
                WHEN SELL_BUY = 1                     
                THEN PAMT+NSERTAX+INS_CHRG                     
                ELSE 0 END),                     
        SAMTSERSTT = (                       
        CASE                     
                WHEN SELL_BUY = 2                     
                THEN SAMT-NSERTAX-INS_CHRG                    
                ELSE 0 END),                    
                            
        AMTSERSTTSTAMPTRANS = (                       
       CASE                     
                WHEN SELL_BUY = 1                     
                THEN -(PAMT+NSERTAX+INS_CHRG+BROKER_CHRG+TURN_TAX)                     
                ELSE (SAMT-NSERTAX-INS_CHRG-BROKER_CHRG-TURN_TAX) END),                     
        PAMTSERSTTSTAMPTRANS = (                       
        CASE                     
                WHEN SELL_BUY = 1                     
                THEN PAMT+NSERTAX+INS_CHRG+BROKER_CHRG+TURN_TAX                     
                ELSE 0 END),                     
        SAMTSERSTTSTAMPTRANS = (                       
        CASE                     
                WHEN SELL_BUY = 2                     
                THEN SAMT-NSERTAX-INS_CHRG-BROKER_CHRG-TURN_TAX                    
                ELSE 0 END),                    
                    
  MARKETAMT  = (PRATE + SRATE) * (PQTY+SQTY),                     
        PMARKETAMT = PRATE * PQTY ,                     
        SMARKETAMT = SRATE * SQTY ,                     
        BROKERAGE,                       
        PBROKERAGE=(CASE WHEN SELL_BUY = 1 THEN BROKERAGE ELSE 0 END),                       
        SBROKERAGE=(CASE WHEN SELL_BUY = 2 THEN BROKERAGE ELSE 0 END),                
  PTOTCHARGE,                
 STOTCHARGE,                       
        SETT_NO,                     
        SETT_TYPE,                       
        TRADETYPE,                       
        TMARK,                       
        PARTYNAME,                       
        L_ADDRESS1,                     
        L_ADDRESS2,                       
        L_ADDRESS3,                       
        L_CITY,                   
  L_STATE,                    
  L_ZIP,                       
  SERVICE_CHRG,                     
  BRANCH_CD,                       
  SUB_BROKER,                       
  TRADER,                       
  PAN_GIR_NO,                       
  OFF_PHONE1,                     
  OFF_PHONE2,                       
  PRINTF,                       
  MAPIDID,                       
  UCC_CODE,                    
  ORDERFLAG,                    
  SCRIPNAMEFORORDERBY,                    
  SCRIPNAME1,                    
  ISIN,                    
  SEBI_NO,                    
  PARTICIPANT_CODE,          
  SLP = SLP,          
  RETURNSESSIONNO          
FROM    #CONTSETTNEW                    
WITH                       
  (                       
                NOLOCK                       
        )                     
--WHERE   PRINTF NOT IN ('0','3')                    
ORDER BY                    
  ORDERBYFLAG,                    
  BRANCH_CD,                     
  SUB_BROKER,                     
  TRADER,                     
  PARTY_CODE,                     
  PARTYNAME,                    
  SCRIPNAMEFORORDERBY,                    
  SCRIPNAME1,                    
  CONTRACTNO DESC,                     
 ORDERFLAG,                     
  SETT_NO,                     
  SETT_TYPE,                    
  TM,                     
  ORDER_NO,                     
  TRADE_NO                     
END

GO
