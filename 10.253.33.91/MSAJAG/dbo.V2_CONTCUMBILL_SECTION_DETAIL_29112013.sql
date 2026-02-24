-- Object: PROCEDURE dbo.V2_CONTCUMBILL_SECTION_DETAIL_29112013
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE  PROC V2_CONTCUMBILL_SECTION_DETAIL_29112013(                                
           @STATUSID       VARCHAR(15),                                
           @STATUSNAME     VARCHAR(25),                                
           @SAUDA_DATE     VARCHAR(11),                                
           @SETT_NO        VARCHAR(7),                                
           @SETT_TYPE      VARCHAR(2),                                
           @FROMPARTY_CODE VARCHAR(10),                                
           @TOPARTY_CODE   VARCHAR(10),                                
           @FROMBRANCH     VARCHAR(10),                                
           @TOBRANCH       VARCHAR(10),                                
           @FROMSUB_BROKER VARCHAR(10),                                
           @TOSUB_BROKER   VARCHAR(10),                                
           @CONTFLAG       VARCHAR(10),                                  
          @PRINTF         VARCHAR(6) = 'ALL',                                
    @DIGIFLAG    VARCHAR(7) = 'ALL')                                   
AS                                
                                
                            
 IF ISNULL(@PRINTF,'') = ''                             
 SELECT @PRINTF = 'ALL'                            
                            
 IF ISNULL(@DIGIFLAG,'') = ''                             
 SELECT @DIGIFLAG = 'ALL'                            
                            
  DECLARE  @COLNAME VARCHAR(6)                                
                                  
  SELECT @COLNAME = ''                                
                                  
  IF @CONTFLAG = 'CONTRACT'                                
    SELECT @COLNAME = RPT_CODE                                
    FROM   V2_CONTRACTPRINT_SETTING                                
    WHERE  RPT_TYPE = 'ORDER'                                
           AND RPT_PRINTFLAG = 1                                
  ELSE                                
    SELECT @COLNAME = RPT_CODE                                
    FROM   V2_CONTRACTPRINT_SETTING                                
    WHERE  RPT_TYPE = 'ORDER'                                
           AND RPT_PRINTFLAG_DIGI = 1                                
                                
 SELECT                                  
 ORDERBYFLAG = (CASE WHEN @COLNAME = 'ORD_N'                                 
     THEN PARTYNAME                                
     WHEN @COLNAME = 'ORD_P'                                
     THEN M.PARTY_CODE                                
     WHEN @COLNAME = 'ORD_BP'                                
     THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(M.PARTY_CODE))                                
     WHEN @COLNAME = 'ORD_BN'                                
     THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(PARTYNAME))                                
     WHEN @COLNAME = 'ORD_DP'                                
     THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(M.PARTY_CODE))                                
     WHEN @COLNAME = 'ORD_DN'                                
     THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(PARTYNAME))                                
     ELSE RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(M.PARTY_CODE))                                
      END),                                 
 CONTRACTNO,                                
        M.PARTY_CODE,                                   
        ORDER_NO,                                   
        ORDER_TIME,                                   
        TM = (CASE WHEN D.SETT_TYPE  IN ('A','X')THEN '15:00:00'ELSE TM END ), ---CHANGES DONE ON 24062013 BY SURESH--REQUESTED BY Vilas                                
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
        PQTY,                                   
        SQTY,                                 
        RATE = PRATE + SRATE,                                 
        PRATE,                                   
        SRATE,                                 
        BROK = PBROK+SBROK,                                 
        PBROK,                                   
        SBROK,                                 
        NETRATE = PNETRATE + SNETRATE,                                 
        PNETRATE,                                   
        SNETRATE,                                 
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
        M.SETT_NO,                                 
        M.SETT_TYPE,                                   
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
        M.PRINTF,                                   
        MAPIDID,                                   
 UCC_CODE,                                
        ORDERFLAG,                                
 SCRIPNAMEFORORDERBY,             
SCRIPNAME1,                                 
--    SCRIPNAME1='',                                
 ISIN,                                
 SEBI_NO,                                
 PARTICIPANT_CODE                                
  FROM     CONTRACT_DATA D,                                
  CONTRACT_MASTER M WITH (NOLOCK),                                   
          MSAJAG.DBO.FUN_PRINTF(@PRINTF) P                                 
  WHERE    M.SETT_TYPE = D.SETT_TYPE                                
           AND M.SETT_NO = D.SETT_NO                                
    AND M.PARTY_CODE = D.PARTY_CODE                                
           AND M.SETT_TYPE = @SETT_TYPE                                
           AND M.SETT_NO = @SETT_NO                                
           AND M.PARTY_CODE BETWEEN @FROMPARTY_CODE                                
                                    AND @TOPARTY_CODE                                
           AND BRANCH_CD BETWEEN @FROMBRANCH                                
                              AND @TOBRANCH                                
         AND SUB_BROKER BETWEEN @FROMSUB_BROKER                                
                                  AND @TOSUB_BROKER                                
           AND @STATUSNAME = (CASE                                 
                                WHEN @STATUSID = 'BRANCH' THEN M.BRANCH_CD                                
                                WHEN @STATUSID = 'SUBBROKER' THEN M.SUB_BROKER                                
                                WHEN @STATUSID = 'TRADER' THEN M.TRADER                                
                                WHEN @STATUSID = 'FAMILY' THEN M.FAMILY                                
                                WHEN @STATUSID = 'AREA' THEN M.AREA                                
     WHEN @STATUSID = 'REGION' THEN M.REGION                                
                                WHEN @STATUSID = 'CLIENT' THEN M.PARTY_CODE                                
                                ELSE 'BROKER'                                
                              END)                                
  AND M.PRINTF = P.PRINTF                                   
       AND 1 = (CASE                    
         WHEN @CONTFLAG = 'CONTRACT'                                    
           AND M.PRINTF = 1 THEN 0                                    
         ELSE 1                                    
       END)                                
    AND 1 = (CASE WHEN @DIGIFLAG = 'ALL'                                 
THEN 1                                 
      ELSE (CASE WHEN M.PARTY_CODE IN (SELECT PARTY_CODE FROM TBL_ECNBOUNCED T WHERE LEFT(T.SDATE,11) = @SAUDA_DATE)                                 
     THEN 1                                
     ELSE 0                                 
      END)                                
    END)                               
  ORDER BY ORDERBYFLAG,                                
           BRANCH_CD,                                
           SUB_BROKER,                                
           TRADER,                                
           M.PARTY_CODE,                                
           PARTYNAME,                                
           SCRIPNAME1,        
           CONTRACTNO DESC,        
  SCRIPNAMEFORORDERBY,                                 
  ORDERFLAG,                                
           SCRIPNAME,        
           SELL_BUY,                                
           M.SETT_NO,                                
           M.SETT_TYPE,                                
           TM,                                
           ORDER_NO,                                
           TRADE_NO

GO
