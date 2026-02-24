-- Object: PROCEDURE dbo.POP_CONTRACTDATA_26122013
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/*                     
BEGIN TRAN                  
EXEC POP_CONTRACTDATA_01112013 '2011030','N','Feb 14 2011','0','z'                  
ROLLBACK                    
*/                    
CREATE PROC POP_CONTRACTDATA_26122013(                                  
           @SETT_NO        VARCHAR(7),                                  
           @SETT_TYPE      VARCHAR(2),                                  
           @SAUDA_DATE     VARCHAR(11),                                  
           @FROMPARTY_CODE VARCHAR(10),                                  
           @TOPARTY_CODE   VARCHAR(10))                                  
AS                                  
                                  
  DECLARE  @ColName VARCHAR(6),                                  
           @SDT     DATETIME                                  
                                                      
  SELECT @SDT = CONVERT(DATETIME,@SAUDA_DATE)                                  
                                                  
  DELETE FROM CONTRACT_DATA                                  
  WHERE       SETT_NO = @SETT_NO                                  
              AND SETT_TYPE = @SETT_TYPE                                  
              AND PARTY_CODE BETWEEN @FROMPARTY_CODE                                  
                                     AND @TOPARTY_CODE                                  
                                                                           
  DELETE FROM CONTRACT_DATA_DET                                  
  WHERE       SETT_NO = @SETT_NO                                  
              AND SETT_TYPE = @SETT_TYPE                                  
              AND PARTY_CODE BETWEEN @FROMPARTY_CODE                                  
                                     AND @TOPARTY_CODE                                  
                                                                           
  DELETE FROM CONTRACT_MASTER                                  
  WHERE       SETT_NO = @SETT_NO                                  
              AND SETT_TYPE = @SETT_TYPE                                  
              AND PARTY_CODE BETWEEN @FROMPARTY_CODE                                  
                                     AND @TOPARTY_CODE                                  
                          
  SELECT * INTO #CHARGES_DETAIL FROM CHARGES_DETAIL                          
  WHERE       CD_SETT_NO = @SETT_NO                                  
              AND CD_SETT_TYPE = @SETT_TYPE                                  
              AND CD_PARTY_CODE BETWEEN @FROMPARTY_CODE                                  
                                     AND @TOPARTY_CODE                           
                                                                           
  TRUNCATE TABLE CONTRACT_DATA_TMP                                  
                                    
  SET NOCOUNT ON                                  
                                    
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED                                  
                                    
  SELECT CONTRACTNO,                                  
         BILLNO,                                  
         TRADE_NO,                                  
         PARTY_CODE,                                  
         SCRIP_CD,                                  
         TRADEQTY,                                  
         SERIES,                                  
         ORDER_NO,                                  
         MARKETRATE,                                  
         SAUDA_DATE,                                  
         SELL_BUY,                                  
         SETTFLAG,                                  
         BROKAPPLIED,                                  
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
         CPID,      
         USER_ID                                 
  INTO   #SETT                     
  FROM   SETTLEMENT                                  
  WHERE  1 = 2     
    
                                    
  INSERT INTO #SETT                 
  SELECT CONTRACTNO,                                  
         BILLNO,                                  
         TRADE_NO = '00000000000',                                  
         PARTY_CODE,                                  
         SCRIP_CD,                                  
         TRADEQTY,                                  
         SERIES,                                  
         ORDER_NO = '0000000000000000',                                  
         MARKETRATE,                                  
         SAUDA_DATE = LEFT(SAUDA_DATE,11),                                  
         SELL_BUY,                                  
         SETTFLAG,                               
         BROKAPPLIED,                                  
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
         CPID = '        ',      
         USER_ID                                  
  FROM   SETTLEMENT                                  
  WHERE  SETT_NO = @SETT_NO                                  
         AND SETT_TYPE = @SETT_TYPE                                  
         AND SAUDA_DATE NOT LIKE @SAUDA_DATE + '%'                                  
         AND AUCTIONPART NOT IN ('AP','AR')                                  
         AND MARKETRATE > 0                                  
         AND PARTY_CODE >= @FROMPARTY_CODE                                  
        AND PARTY_CODE <= @TOPARTY_CODE      
                              
                                                             
  INSERT INTO #SETT                                  
  SELECT CONTRACTNO,                                  
         BILLNO,                                  
         TRADE_NO,                                  
         PARTY_CODE,                                  
         SCRIP_CD,                                  
         TRADEQTY,                                  
         SERIES,                                  
         ORDER_NO,                                  
         MARKETRATE,                                  
         SAUDA_DATE,                                  
         SELL_BUY,                                  
         SETTFLAG,                                  
         BROKAPPLIED,                                  
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
         CPID,      
         USER_ID     
         FROM   SETTLEMENT                                  
  WHERE  SETT_TYPE = @SETT_TYPE                                  
         AND SAUDA_DATE LIKE @SAUDA_DATE + '%'                                  
         AND AUCTIONPART NOT IN ('AP','AR')                                  
         AND MARKETRATE > 0                                  
         AND PARTY_CODE >= @FROMPARTY_CODE                                  
         AND PARTY_CODE <= @TOPARTY_CODE                                  
                                                             
  DELETE FROM #SETT                                  
  WHERE       SAUDA_DATE > @SAUDA_DATE + ' 23:59:59'                                  
          
  CREATE INDEX [DELPOS] ON [DBO].[#SETT] (                                  
        [SETT_NO],                                  
        [SETT_TYPE],                                  
        [PARTY_CODE],                                  
        [SCRIP_CD],                                  
        [SERIES])                                  
              
  SELECT DISTINCT S2.SCRIP_CD,                                  
                  S2.SERIES,                                  
                  SHORT_NAME                                  
  INTO   #SCRIP                                  
  FROM   SCRIP1 S1,                                  
         SCRIP2 S2,                                  
         #SETT S                                  
  WHERE  S1.CO_CODE = S2.CO_CODE                                  
         AND S2.SERIES = S1.SERIES                                  
         AND S2.SCRIP_CD = S.SCRIP_CD                                  
         AND S2.SERIES = S.SERIES                                  
                                                           
  CREATE CLUSTERED INDEX [SCR] ON [DBO].[#SCRIP] (                                  
        [SCRIP_CD],                 
        [SERIES])                                  
                          
                          
 UPDATE #SETT SET PARTY_CODE = PARENTCODE                          
 FROM CLIENT2                           
 WHERE CLIENT2.PARTY_CODE = #SETT.PARTY_CODE                          
                           
 UPDATE #CHARGES_DETAIL SET CD_PARTY_CODE = PARENTCODE                          
 FROM CLIENT2                           
 WHERE CLIENT2.PARTY_CODE = CD_PARTY_CODE                          
                                    
  /*=========================================================================                                                                      
                /*FOR THE #SETT*/                                     
                =========================================================================*/                                  
  SELECT C2.PARTY_CODE,                                  
         C1.LONG_NAME,                                  
         C1.L_ADDRESS1,                                  
         C1.L_ADDRESS2,                                  
         C1.L_ADDRESS3,                      
         C1.L_CITY,                                  
         C1.L_STATE,                                  
         C1.L_ZIP,                                  
         C1.BRANCH_CD,                                  
         C1.SUB_BROKER,                                  
         C1.TRADER,                                  
         C1.AREA,                                  
         C1.REGION,      
         C1.FAMILY,                                  
         C1.PAN_GIR_NO,                                  
        OFF_PHONE1=(CASE WHEN LEN(RES_PHONE1) = 0 AND LEN(RES_PHONE2) = 0 AND LEN(OFF_PHONE1) = 0 AND LEN(OFF_PHONE2) = 0                                
       THEN MOBILE_PAGER                                 
       WHEN LEN(RES_PHONE1) = 0 AND LEN(RES_PHONE2) = 0 AND LEN(OFF_PHONE1) = 0                             
       THEN OFF_PHONE2                                 
       WHEN LEN(RES_PHONE1) = 0 AND LEN(RES_PHONE2) = 0                                 
       THEN OFF_PHONE1                                
       WHEN LEN(RES_PHONE1) = 0                                
       THEN RES_PHONE2                                
  ELSE                                 
         RES_PHONE1                          
     END),                                   
         OFF_PHONE2 = C1.MOBILE_PAGER,                                  
         PRINTF,                                  
         MAPIDID = CONVERT(VARCHAR(20),''),                                  
         UCC_CODE = CONVERT(VARCHAR(20),''),                                  
         C2.SERVICE_CHRG,                                  
         BROKERNOTE,                                  
         TURNOVER_TAX,                                  
         SEBI_TURN_TAX,                                  
         C2.OTHER_CHRG,                                  
         INSURANCE_CHRG,                                  
      SEBI_NO = FD_CODE,                                  
         PARTICIPANT_CODE = BANKID,                                  
         CL_TYPE                                  
  INTO   #CLIENTMASTER                                  
  FROM   CLIENT1 C1 WITH (NOLOCK),                                  
         CLIENT2 C2 WITH (NOLOCK)                                  
                                           
  WHERE  C2.CL_CODE = C1.CL_CODE                                  
         AND C2.PARTY_CODE BETWEEN @FROMPARTY_CODE                                  
                                   AND @TOPARTY_CODE                                  
         AND C2.PARTY_CODE IN (SELECT DISTINCT PARTY_CODE                                  
                               FROM   #SETT)                                  
                                        
  CREATE CLUSTERED INDEX [PARTY] ON [DBO].[#CLIENTMASTER] (                                  
        [PARTY_CODE])                                  
                                    
  UPDATE #CLIENTMASTER                                  
  SET    MAPIDID = UC.MAPIDID,                                  
         UCC_CODE = UC.UCC_CODE                                  
  FROM   UCC_CLIENT UC                                  
  WHERE  #CLIENTMASTER.PARTY_CODE = UC.PARTY_CODE                                  
                           
  INSERT INTO CONTRACT_DATA_TMP                                  
  SELECT CONTRACTNO,                                  
         S.PARTY_CODE,                                  
         ORDER_NO,                                  
         ORDER_TIME = (CASE                                   
                         WHEN CPID = 'NIL' THEN '        '                                  
                         ELSE RIGHT(CPID,8)                                  
                       END),                                  
         TM = CONVERT(VARCHAR,SAUDA_DATE,108),                                  
         TRADE_NO,                                  
         SAUDA_DATE,                                  
         S.SCRIP_CD,                                  
         S.SERIES,                                  
         SCRIPNAME = (CASE                                   
                        WHEN LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11) <> @SAUDA_DATE THEN 'BF-'                                  
                        ELSE ''                                  
                      END) + S2.SHORT_NAME + '  ',                                  
         SDT = CONVERT(VARCHAR,@SDT,103),                                  
         SELL_BUY,                                  
   BROKER_CHRG = (CASE                                   
                          WHEN BROKERNOTE = 1 THEN BROKER_CHRG                                  
                          ELSE 0                                  
                        END),                                  
         TURN_TAX = (CASE                                   
                       WHEN TURNOVER_TAX = 1 THEN TURN_TAX                                  
              ELSE 0                                  
                     END),                                  
         SEBI_TAX = (CASE                                   
                       WHEN SEBI_TURN_TAX = 1 THEN SEBI_TAX                                  
                       ELSE 0                                  
                     END),                                  
         OTHER_CHRG = (CASE                                  
    WHEN C1.OTHER_CHRG = 1 THEN S.OTHER_CHRG                                  
                         ELSE 0                                  
                       END),                                  
         INS_CHRG = (CASE                                   
                       WHEN INSURANCE_CHRG = 1 THEN INS_CHRG                                  
                       ELSE 0                                  
                     END),                                  
         SERVICE_TAX = (CASE                                   
                          WHEN SERVICE_CHRG = 0 THEN NSERTAX                                  
                          ELSE 0                                  
  END),                                  
         NSERTAX = (CASE                                   
                      WHEN SERVICE_CHRG = 0 THEN NSERTAX                                  
                      ELSE 0                                  
                    END),                                  
         SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),                                  
         PQTY = (CASE                                   
 WHEN SELL_BUY = 1 THEN TRADEQTY                                  
                   ELSE 0                                  
         END),                                  
         SQTY = (CASE                                   
                   WHEN SELL_BUY = 2 THEN TRADEQTY                                  
                   ELSE 0                                  
                 END),                                  
         PRATE = (CASE                                   
                    WHEN SELL_BUY = 1 THEN MARKETRATE                                  
                    ELSE 0                                  
                  END),                                  
         SRATE = (CASE                                   
                    WHEN SELL_BUY = 2 THEN MARKETRATE                                  
                    ELSE 0                                  
                  END),                                  
         PBROK = (CASE                                   
                    WHEN SELL_BUY = 1 THEN NBROKAPP + (CASE                                   
                                                         WHEN SERVICE_CHRG = 1 THEN NSERTAX / TRADEQTY                                  
        ELSE 0                                  
                                                       END)                                  
                    ELSE 0                                  
                  END),                                  
         SBROK = (CASE                                   
                    WHEN SELL_BUY = 2 THEN NBROKAPP + (CASE                                   
                                                         WHEN SERVICE_CHRG = 1 THEN NSERTAX / TRADEQTY                                                                                           ELSE 0                                  
                                                       END)                                  
                    ELSE 0                                  
                  END),                                  
         PNETRATE = (CASE                                   
                       WHEN SELL_BUY = 1 THEN N_NETRATE + (CASE                               
                                                             WHEN SERVICE_CHRG = 1 THEN NSERTAX / TRADEQTY                                  
              ELSE 0                                  
                                                           END)                                  
                       ELSE 0                                  
                     END),                                  
         SNETRATE = (CASE                                   
                       WHEN SELL_BUY = 2 THEN N_NETRATE - (CASE                              
                                                             WHEN SERVICE_CHRG = 1 THEN NSERTAX / TRADEQTY                                  
                                          ELSE 0                          
                                                           END)                                  
                       ELSE 0                                  
                     END),                                  
         PAMT = (CASE                                   
                   WHEN SELL_BUY = 1 THEN TRADEQTY * (N_NETRATE + (CASE                                   
                                                                     WHEN SERVICE_CHRG = 1 THEN NSERTAX / TRADEQTY                                  
                                                                     ELSE 0                                  
                                                        END))                                  
                   ELSE 0                                  
                 END),                                  
         SAMT = (CASE                                   
                WHEN SELL_BUY = 2 THEN TRADEQTY * (N_NETRATE - (CASE                                   
                                                                     WHEN SERVICE_CHRG = 1 THEN NSERTAX / TRADEQTY                                  
                                                                     ELSE 0                                  
                                                                   END))                                  
                   ELSE 0                                  
                 END),                                  
         BROKERAGE = TRADEQTY * NBROKAPP + (CASE                                   
                                              WHEN SERVICE_CHRG = 1 THEN NSERTAX                                  
                                              ELSE 0                            
                                            END),                                  
         S.SETT_NO,                                  
         S.SETT_TYPE,                                  
         TRADETYPE = '  ',                                  
         TMARK = CASE                                   
                   WHEN BILLFLAG = 1                                  
                         OR BILLFLAG = 4                                  
                         OR BILLFLAG = 5 THEN 'D'                                  
                   ELSE ''                                  
                 END,      
                                                   
         /*TO DISPLAY THE HEADER PART*/                                  
         PARTYNAME = C1.LONG_NAME,                                  
         C1.L_ADDRESS1,                                  
         C1.L_ADDRESS2,                                  
         C1.L_ADDRESS3,                                  
         C1.L_CITY,                                  
         C1.L_STATE,                                  
         C1.L_ZIP,                                  
         C1.SERVICE_CHRG,                                  
         C1.BRANCH_CD,                                  
         C1.SUB_BROKER,                                  
         C1.TRADER,                                  
  C1.PAN_GIR_NO,                                  
         C1.OFF_PHONE1,                                  
         C1.OFF_PHONE2,                                  
         PRINTF,                                  
         MAPIDID,                                  
         UCC_CODE,                                  
         ORDERFLAG = 0,                                 
         SCRIPNAMEFORORDERBY = S2.SHORT_NAME,                                  
         SCRIPNAME1 = CONVERT(VARCHAR,(CASE                                   
                                         WHEN CL_TYPE = 'NRI' THEN LTRIM(RTRIM(SELL_BUY))                                  
                                         ELSE ''                                  
                                       END),52),                                  
         SEBI_NO,                                  
         PARTICIPANT_CODE,                                  
         ACTSELL_BUY = SELL_BUY,                                  
         ISIN = CONVERT(VARCHAR(12),''),                                  
  START_DATE = CONVERT(CHAR,(START_DATE),103),                                  
         END_DATE = CONVERT(CHAR,(END_DATE),103),                                  
         FUNDS_PAYIN = CONVERT(VARCHAR,FUNDS_PAYIN,103),                                  
         FUNDS_PAYOUT = CONVERT(VARCHAR,FUNDS_PAYOUT,103),                                  
         AREA,                                  
         REGION,                                  
         CL_TYPE,                                  
         FAMILY,    
         USER_ID                                  
  FROM   #SETT S WITH (NOLOCK),                                  
         #CLIENTMASTER C1 WITH (NOLOCK),                                  
         SETT_MST M WITH (NOLOCK),                                  
         #SCRIP S2                                  
  WHERE  S.SETT_NO = @SETT_NO                                  
         AND S.SETT_TYPE = @SETT_TYPE                                  
         AND S.PARTY_CODE BETWEEN @FROMPARTY_CODE                                  
                                  AND @TOPARTY_CODE                                  
         AND S.SETT_NO = M.SETT_NO                                  
         AND S.SETT_TYPE = M.SETT_TYPE                                  
         AND M.END_DATE LIKE @SAUDA_DATE + '%'                                  
         AND S2.SCRIP_CD = S.SCRIP_CD                                  
         AND S2.SERIES = S.SERIES                                  
         AND S.PARTY_CODE = C1.PARTY_CODE                                  
         AND S.TRADEQTY > 0                                  
                            
  --  return                        
UPDATE                                       
 CONTRACT_DATA_TMP                                      
SET                                      
 Brokerage = (Case When Sell_Buy =1                     
 Then (Case When TMARK = '' Then CD_TrdBuyBrokerage Else CD_DelBuyBrokerage End)                                  
     Else (Case When TMARK = '' Then CD_TrdSellBrokerage Else CD_DelSellBrokerage End)                                  
       End)                            
           + (Case When Service_Chrg = 1                                   
     Then Case When Sell_Buy =1                                   
        Then (Case When TMARK = '' Then CD_TrdBuySerTax Else CD_DelBuySerTax End)                                  
        Else (Case When TMARK = '' Then CD_TrdSellSerTax Else CD_DelSellSerTax End)                                  
   End              
            Else 0                                   
       End),                                      
 Service_Tax = (Case When Service_Chrg = 0                                   
     Then Case When Sell_Buy =1                                   
        Then (Case When TMARK = '' Then CD_TrdBuySerTax Else CD_DelBuySerTax End)                                  
        Else (Case When TMARK = '' Then CD_TrdSellSerTax Else CD_DelSellSerTax End)                                  
   End                                      
            Else 0                                   
       End),                                      
 NSerTax = (Case When Service_Chrg = 0                                   
Then Case When Sell_Buy =1                                   
        Then (Case When TMARK = '' Then CD_TrdBuySerTax Else CD_DelBuySerTax End)                                  
        Else (Case When TMARK = '' Then CD_TrdSellSerTax Else CD_DelSellSerTax End)                                  
   End                                      
            Else 0                                   
       End),                                  
                                  
PAmt     = (Case When Sell_Buy =1                                   
     Then PAmt + (Case When TMARK = '' Then CD_TrdBuyBrokerage Else CD_DelBuyBrokerage End)                                  
     Else 0                                  
       End)                                  
           + (Case When Service_Chrg = 1                                   
     Then Case When Sell_Buy =1                                   
        Then (Case When TMARK = '' Then CD_TrdBuySerTax Else CD_DelBuySerTax End)                  
        Else 0                                  
   End                                      
            Else 0                                   
       End),                                  
SAmt     = (Case When Sell_Buy = 2                                  
     Then SAmt - (Case When TMARK = '' Then CD_TrdSellBrokerage Else CD_DelSellBrokerage End)                                  
     Else 0                                  
       End)                                  
           + (Case When Service_Chrg = 1                                   
     Then Case When Sell_Buy = 2                                  
     Then (Case When TMARK = '' Then CD_TrdSellSerTax Else CD_DelSellSerTax End)                                  
        Else 0                                  
   End                                      
            Else 0                                   
       End)                                       
FROM                                      
 #CHARGES_DETAIL                                       
WHERE                                      
 CD_Sett_No = CONTRACT_DATA_TMP.Sett_No                                    
 And CD_Sett_Type = CONTRACT_DATA_TMP.Sett_Type                                    
 And CD_Party_Code = CONTRACT_DATA_TMP.Party_Code                                       
 And CD_Scrip_Cd = CONTRACT_DATA_TMP.Scrip_Cd                                    
 And CD_Series = CONTRACT_DATA_TMP.Series                                    
 And CD_Trade_No = Trade_No                                      
 And CD_Order_No = Order_No                              
                              
        INSERT                                 
        INTO    CONTRACT_DATA_TMP                              
                              
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
                        THEN CD_TrdBuySerTax+CD_DelBuySerTax                                    
                        ELSE 0 END ),                                       
                NSERTAX = (                                       
                CASE                                       
                        WHEN SERVICE_CHRG = 0                                       
                        THEN CD_TrdBuySerTax+CD_DelBuySerTax                                    
                        ELSE 0 END ),                                       
                SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,CD_SAUDA_DATE,109),11),                                       
                PQTY = 0,                                       
                SQTY = 0,                        
                PRATE = 0,                 
                SRATE = 0,                                       
                PBROK = 0,                                       
                SBROK = 0,                                       
                PNETRATE =0,                                       
     SNETRATE =0,                                       
                PAMT =CD_TrdBuyBrokerage+CD_DelBuyBrokerage+(                                       
                CASE                                       
                        WHEN SERVICE_CHRG = 1                                        
                        THEN CD_TrdBuySerTax+CD_DelBuySerTax                                 
                        ELSE 0 END ),                                       
                SAMT = 0,                              
                BROKERAGE = CD_TrdBuyBrokerage+CD_DelBuyBrokerage+(                                       
                CASE                                       
                        WHEN SERVICE_CHRG = 1                                        
                        THEN CD_TrdBuySerTax+CD_DelBuySerTax                                   
                        ELSE 0 END ),                                       
                S.CD_SETT_NO,                            
                S.CD_SETT_TYPE,                                       
                TRADETYPE = '  ',                                       
                TMARK     = ' ',      
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
                ORDERFLAG  = 4,                                       
  SCRIPNAMEForOrderBy=ISNULL(S2.SHORT_NAME,'ZZZBROKERAGE'),                                    
                /*SCRIPNAME1 = Convert(Varchar,(Case When Cl_Type = 'NRI'                                       
       Then LTRIM(RTRIM(ISNULL(S2.SHORT_NAME,'BROKERAGE'))) + '_' + LTRIM(RTRIM(1))                                       
              Else ''                      
         End), 52),*/                        
                        
    SCRIPNAME1 = CONVERT(VARCHAR,(CASE                                   
                                         WHEN CL_TYPE = 'NRI' THEN LTRIM(RTRIM(1))                                  
                                         ELSE ''                                  
                END),52),                         
                        
                                             
   SEBI_NO,                                      
   Participant_Code,                                
   ActSell_buy = 1, ISIN = '', START_DATE = CONVERT(VARCHAR,START_DATE,103), END_DATE =  CONVERT(VARCHAR,END_DATE,103),                              
FUNDS_PAYIN = CONVERT(VARCHAR,FUNDS_PAYIN,103), FUNDS_PAYOUT =  CONVERT(VARCHAR,FUNDS_PAYOUT,103),                              
AREA, REGION, CL_TYPE, FAMILY , USER_ID ='        '                                                             
        FROM    #CHARGES_DETAIL S LEFT OUTER JOIN #SCRIP S2                                      
 ON (    S2.SCRIP_CD = S.CD_SCRIP_CD                                 
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
  AND CD_TrdBuyBrokerage+CD_DelBuyBrokerage > 0                              
  AND (CD_Trade_No = '' OR CD_TRADE_NO='0000'        )                      
                              
                              
        INSERT                                 
        INTO    CONTRACT_DATA_TMP                              
                              
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
                SELL_BUY=2,                                       
     BROKER_CHRG =0,                                       
                TURN_TAX =0,                                       
                SEBI_TAX =0,                                       
                OTHER_CHRG =0,                                       
                INS_CHRG =0,                              
                SERVICE_TAX = (                                       
                CASE                                       
                        WHEN SERVICE_CHRG = 0                                       
                        THEN CD_TrdSellSerTax+CD_DelSellSerTax                                    
                        ELSE 0 END ),                                       
                NSERTAX = (                                       
                CASE                                       
                        WHEN SERVICE_CHRG = 0                                       
  THEN CD_TrdSellSerTax+CD_DelSellSerTax                                    
                        ELSE 0 END ),                                       
                SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,CD_SAUDA_DATE,109),11),                                       
                PQTY = 0,                                    
                SQTY = 0,                                       
                PRATE = 0,                                       
                SRATE = 0,                                       
                PBROK = 0,                                       
                SBROK = 0,                                       
                PNETRATE =0,                                       
                SNETRATE =0,                                       
                PAMT = 0,                                       
                SAMT = -(CD_TrdSellBrokerage+CD_DelSellBrokerage+(                                       
                CASE                                       
                        WHEN SERVICE_CHRG = 1                                        
                        THEN CD_TrdSellSerTax+CD_DelSellSerTax                                    
                        ELSE 0 END )),                              
                BROKERAGE = CD_TrdSellBrokerage+CD_DelSellBrokerage+(                                       
            CASE                                       
                       WHEN SERVICE_CHRG = 1                                        
                        THEN CD_TrdSellSerTax+CD_DelSellSerTax                                    
                        ELSE 0 END ),                                       
                S.CD_SETT_NO,                                       
                S.CD_SETT_TYPE,                                       
                TRADETYPE = '  ',                                       
                TMARK     = ' ',       
                      
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
                ORDERFLAG  = 4,                                 
  SCRIPNAMEForOrderBy=ISNULL(S2.SHORT_NAME,'ZZZBROKERAGE'),                                    
                /*SCRIPNAME1 = Convert(Varchar,(Case When Cl_Type = 'NRI'                                       
       Then LTRIM(RTRIM(ISNULL(S2.SHORT_NAME,'BROKERAGE'))) + '_' + LTRIM(RTRIM(2))                                       
              Else ''                                       
         End), 52),*/                                             
    SCRIPNAME1 = CONVERT(VARCHAR,(CASE                                   
                                         WHEN CL_TYPE = 'NRI' THEN LTRIM(RTRIM(2))                                  
                                         ELSE ''                                  
                                       END),52),                        
   SEBI_NO,                                      
   Participant_Code,                                      
   ActSell_buy = 2, ISIN = '', START_DATE = CONVERT(VARCHAR,START_DATE,103), END_DATE =  CONVERT(VARCHAR,END_DATE,103),                              
FUNDS_PAYIN = CONVERT(VARCHAR,FUNDS_PAYIN,103), FUNDS_PAYOUT =  CONVERT(VARCHAR,FUNDS_PAYOUT,103),                              
AREA, REGION, CL_TYPE, FAMILY  ,      
USER_ID ='       '          
        FROM    #CHARGES_DETAIL S LEFT OUTER JOIN #SCRIP S2                                      
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
  AND CD_TrdSellBrokerage+CD_DelSellBrokerage > 0                                    
  AND (CD_Trade_No = ''  OR CD_TRADE_NO='0000')                      
                                    
  /*=========================================================================                                                                      
                /* ND RECORD BROUGHT FORWARD FOR SAME DAY OR PREVIOUS DAYS */                                     
                =========================================================================*/                                  
  INSERT INTO CONTRACT_DATA_TMP                                  
  SELECT CONTRACTNO,                                  
         S.PARTY_CODE,                                  
         ORDER_NO,                                  
         ORDER_TIME = (CASE                                   
                         WHEN CPID = 'NIL' THEN '        '                                  
                         ELSE RIGHT(CPID,8)                                  
                       END),                                  
         TM = CONVERT(VARCHAR,SAUDA_DATE,108),                                  
         TRADE_NO,                 
         SAUDA_DATE,                                  
         S.SCRIP_CD,                                  
         S.SERIES,                                  
         SCRIPNAME = (CASE                                   
                        WHEN LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11) = @SAUDA_DATE THEN 'ND-'                             
  ELSE 'BF-'                                  
         END) + S2.SHORT_NAME,                                  
         SDT = CONVERT(VARCHAR,@SDT,103),                                  
         SELL_BUY,                                  
         BROKER_CHRG = 0,                                  
         TURN_TAX = 0,                                  
         SEBI_TAX = 0,                                  
         S.OTHER_CHRG,                                  
         INS_CHRG = 0,                                  
         SERVICE_TAX = 0,                                  
         NSERTAX = 0,                                  
         SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),                                  
         PQTY = (CASE                                   
                   WHEN SELL_BUY = 1 THEN TRADEQTY                                  
                   ELSE 0                                  
               END),                                  
         SQTY = (CASE                                   
           WHEN SELL_BUY = 2 THEN TRADEQTY                                  
                   ELSE 0                                  
                 END),                                  
         PRATE = (CASE                                   
                    WHEN SELL_BUY = 1 THEN MARKETRATE                                  
                    ELSE 0                                  
                  END),                                  
    SRATE = (CASE                                   
                    WHEN SELL_BUY = 2 THEN MARKETRATE                                  
                    ELSE 0                                  
                  END),                                  
         PBROK = 0,                                  
         SBROK = 0,                                  
         PNETRATE = (CASE                                   
                       WHEN SELL_BUY = 1 THEN MARKETRATE                                  
                       ELSE 0                                  
                     END),                                  
         SNETRATE = (CASE                                   
   WHEN SELL_BUY = 2 THEN MARKETRATE                                  
ELSE 0                                  
                     END),                                  
         PAMT = (CASE                                   
                   WHEN SELL_BUY = 1 THEN TRADEQTY * MARKETRATE                                  
                   ELSE 0                                  
                 END),                                  
         SAMT = (CASE                                   
                   WHEN SELL_BUY = 2 THEN TRADEQTY * MARKETRATE                                  
                   ELSE 0                  
                 END),                                  
         BROKERAGE = 0,                                  
         S.SETT_NO,                                  
         S.SETT_TYPE,                                  
         TRADETYPE = 'BF',                                  
         TMARK = CASE                                   
          WHEN BILLFLAG = 1                              
                         OR BILLFLAG = 4                                  
                         OR BILLFLAG = 5 THEN ''                                  
                   ELSE ''                                  
                 END,      
               
         /*TO DISPLAY THE HEADER PART*/                                  
         PARTYNAME = C1.LONG_NAME,                                  
         C1.L_ADDRESS1,                                  
         C1.L_ADDRESS2,                                  
         C1.L_ADDRESS3,                                  
         C1.L_CITY,                                  
         C1.L_STATE,                                  
         C1.L_ZIP,                                  
         C1.SERVICE_CHRG,                                  
         C1.BRANCH_CD,                                  
         C1.SUB_BROKER,                                  
         C1.TRADER,                                  
         C1.PAN_GIR_NO,                                  
         C1.OFF_PHONE1,                                  
         C1.OFF_PHONE2,                                  
         PRINTF,                                  
         MAPIDID,                                  
         UCC_CODE,                                  
         ORDERFLAG = 0,                                  
         SCRIPNAMEFORORDERBY = S2.SHORT_NAME,                                  
         SCRIPNAME1 = CONVERT(VARCHAR,(CASE                                   
                                         WHEN CL_TYPE = 'NRI' THEN LTRIM(RTRIM(SELL_BUY))                                  
                                         ELSE ''                                  
                                       END),52),                                  
         SEBI_NO,                                  
         PARTICIPANT_CODE,                                  
         ACTSELL_BUY = SELL_BUY,                                  
         ISIN = CONVERT(VARCHAR(12),''),                                  
         START_DATE = CONVERT(CHAR,(START_DATE),103),                       
         END_DATE = CONVERT(CHAR,(END_DATE),103),                                  
         FUNDS_PAYIN = CONVERT(VARCHAR,FUNDS_PAYIN,103),                                  
         FUNDS_PAYOUT = CONVERT(VARCHAR,FUNDS_PAYOUT,103),                                  
         AREA,                                  
         REGION,                                  
         CL_TYPE,                                  
         FAMILY ,      
          USER_ID                                                             
  FROM   #SETT S WITH (NOLOCK),                                  
         #CLIENTMASTER C1 WITH (NOLOCK),                                  
         SETT_MST M WITH (NOLOCK),                                  
         #SCRIP S2                                  
  WHERE  SAUDA_DATE <= @SAUDA_DATE + ' 23:59'                                  
         AND S.PARTY_CODE BETWEEN @FROMPARTY_CODE                                  
                                  AND @TOPARTY_CODE                             
    AND M.END_DATE > @SAUDA_DATE + ' 23:59:59'                                  
         AND S.SETT_TYPE = @SETT_TYPE --AND S.SETT_NO > @SETT_NO AND S.SETT_TYPE = @SETT_TYPE                                                   
         AND S.SETT_NO = M.SETT_NO                        
         AND S.SETT_TYPE = M.SETT_TYPE                                  
AND S.SETT_NO = M.SETT_NO--ADD BY SURESH                      
         AND M.END_DATE NOT LIKE @SAUDA_DATE + '%'                                  
         AND S2.SCRIP_CD = S.SCRIP_CD                                  
   AND S2.SERIES = S.SERIES                                  
         AND S.PARTY_CODE = C1.PARTY_CODE                                  
         AND S.TRADEQTY > 0                                  
                                    
  /*=========================================================================                                                  
                /* ND RECORD CARRY FORWARD FOR SAME DAY OR PREVIOUS DAYS */                                     
             =========================================================================*/                                  
  INSERT INTO CONTRACT_DATA_TMP                                  
  SELECT CONTRACTNO,                                  
         S.PARTY_CODE,                                  
         ORDER_NO,                                  
         ORDER_TIME = (CASE                                   
                         WHEN CPID = 'NIL' THEN '        '                
                         ELSE RIGHT(CPID,8)                                  
                       END),                                  
         TM = CONVERT(VARCHAR,SAUDA_DATE,108),                                  
         TRADE_NO,                                  
         SAUDA_DATE,                   
         S.SCRIP_CD,                                  
         S.SERIES,                                  
         SCRIPNAME = 'CF-' + S2.SHORT_NAME,                                  
         SDT = CONVERT(VARCHAR,@SDT,103),                                  
         SELL_BUY = (CASE                                   
    WHEN SELL_BUY = 1 THEN 2                                  
                       ELSE 1                                  
                     END),                                  
         BROKER_CHRG = 0,                                  
         TURN_TAX = 0,                                  
         SEBI_TAX = 0,                                  
         S.OTHER_CHRG,                                  
         INS_CHRG = 0,                                  
         SERVICE_TAX = 0,                                  
         NSERTAX = 0,                                  
         SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),                                  
         PQTY = (CASE                                   
                   WHEN SELL_BUY = 2 THEN TRADEQTY                                  
                   ELSE 0                                  
                 END),                                  
         SQTY = (CASE                                   
                   WHEN SELL_BUY = 1 THEN TRADEQTY                                  
                   ELSE 0                                  
                 END),                                  
         PRATE = (CASE                                   
                    WHEN SELL_BUY = 2 THEN MARKETRATE                                  
                    ELSE 0                                  
                  END),                                  
         SRATE = (CASE                                   
                    WHEN SELL_BUY = 1 THEN MARKETRATE                                  
                    ELSE 0                                  
                  END),                                  
         PBROK = 0,                                           SBROK = 0,                                  
         PNETRATE = (CASE                                   
                       WHEN SELL_BUY = 2 THEN MARKETRATE                                  
                       ELSE 0                                  
                     END),                                  
         SNETRATE = (CASE                                   
                       WHEN SELL_BUY = 1 THEN MARKETRATE                                  
                       ELSE 0                                  
                     END),                                  
         PAMT = (CASE                                   
                   WHEN SELL_BUY = 2 THEN TRADEQTY * MARKETRATE                                  
                   ELSE 0                                  
                 END),                                  
         SAMT = (CASE                                   
                   WHEN SELL_BUY = 1 THEN TRADEQTY * MARKETRATE                                  
                   ELSE 0                                  
                 END),                                  
         BROKERAGE = 0,                                  
         S.SETT_NO,                                  
         S.SETT_TYPE,                                  
         TRADETYPE = 'CF',                
         TMARK = CASE                                   
                   WHEN BILLFLAG = 1                                  
                         OR BILLFLAG = 4                                  
                         OR BILLFLAG = 5 THEN ''                                  
                   ELSE ''                                  
                 END,          
     
         /*TO DISPLAY THE HEADER PART*/                                  
         PARTYNAME = C1.LONG_NAME,                                  
         C1.L_ADDRESS1,                                  
         C1.L_ADDRESS2,                                  
         C1.L_ADDRESS3,                                  
         C1.L_CITY,                                  
         C1.L_STATE,                                  
         C1.L_ZIP,                                  
         C1.SERVICE_CHRG,                                  
         C1.BRANCH_CD,                                  
         C1.SUB_BROKER,                                  
         C1.TRADER,                                  
         C1.PAN_GIR_NO,                                  
         C1.OFF_PHONE1,                                  
         C1.OFF_PHONE2,                                  
         PRINTF,                                  
         MAPIDID,                                  
         UCC_CODE,                                  
         ORDERFLAG = 1,                                  
         SCRIPNAMEFORORDERBY = S2.SHORT_NAME,                                  
         SCRIPNAME1 = CONVERT(VARCHAR,(CASE                                   
                                         WHEN CL_TYPE = 'NRI' THEN LTRIM(RTRIM(SELL_BUY))                                  
                                         ELSE ''                                  
                                       END),52),                                  
         SEBI_NO,                                  
         PARTICIPANT_CODE,                                  
         ACTSELL_BUY = SELL_BUY,                                  
         ISIN = CONVERT(VARCHAR(12),''),                                  
         START_DATE = CONVERT(CHAR,(START_DATE),103),                                  
         END_DATE = CONVERT(CHAR,(END_DATE),103),                                  
         FUNDS_PAYIN = CONVERT(VARCHAR,FUNDS_PAYIN,103),                                  
         FUNDS_PAYOUT = CONVERT(VARCHAR,FUNDS_PAYOUT,103),                                  
         AREA,                                  
         REGION,                                  
         CL_TYPE,                                  
   FAMILY ,      
          USER_ID                                                         
  FROM   #SETT S WITH (NOLOCK),                                  
         #CLIENTMASTER C1 WITH (NOLOCK),                                  
         SETT_MST M WITH (NOLOCK),                                  
         #SCRIP S2                                  
  WHERE  SAUDA_DATE <= @SAUDA_DATE + ' 23:59'                                  
         AND S.PARTY_CODE BETWEEN @FROMPARTY_CODE                                  
                                  AND @TOPARTY_CODE                                  
         AND M.END_DATE > @SAUDA_DATE + ' 23:59:59'                                  
         AND S.SETT_TYPE = @SETT_TYPE --AND S.SETT_NO > @SETT_NO AND S.SETT_TYPE = @SETT_TYPE                                      AND S.SETT_NO = M.SETT_NO                                  
         AND S.SETT_TYPE = M.SETT_TYPE                       
AND S.SETT_NO = M.SETT_NO           ---ADD BY SURESH                      
         AND M.END_DATE NOT LIKE @SAUDA_DATE + '%'                                  
         AND S2.SCRIP_CD = S.SCRIP_CD                                  
         AND S2.SERIES = S.SERIES                                  
         AND S.PARTY_CODE = C1.PARTY_CODE                                  
         AND S.TRADEQTY > 0                                  
                    
  UPDATE CONTRACT_DATA_TMP                                  
  SET    START_DATE = CONVERT(CHAR,(S.START_DATE),103),                                  
         END_DATE = CONVERT(CHAR,(S.END_DATE),103),                                  
         FUNDS_PAYIN = CONVERT(VARCHAR,S.FUNDS_PAYIN,103),                                  
         FUNDS_PAYOUT = CONVERT(VARCHAR,S.FUNDS_PAYOUT,103),                                  
         SETT_NO = @SETT_NO                               
  FROM   SETT_MST S                                  
  WHERE  S.SETT_NO = @SETT_NO                                  
         AND S.SETT_TYPE = @SETT_TYPE                                  
                                                             
  UPDATE CONTRACT_DATA_TMP                                  
  SET    ISIN = M.ISIN                                  
  FROM   MULTIISIN M                                  
  WHERE  M.SCRIP_CD = CONTRACT_DATA_TMP.SCRIP_CD                                  
         AND M.SERIES = (CASE                                   
                           WHEN CONTRACT_DATA_TMP.SERIES = 'BL' THEN 'EQ'                                  
                           WHEN CONTRACT_DATA_TMP.SERIES = 'IL' THEN 'EQ'                                  
                           ELSE CONTRACT_DATA_TMP.SERIES                                  
                         END)                                  
         AND VALID = 1                                  
                                                       
  INSERT INTO CONTRACT_DATA                                  
  SELECT   CONTRACTNO,                                  
           PARTY_CODE,                                  
           ORDER_NO = '0000000000000000',                                  
           ORDER_TIME = '        ',                                  
           TM = '        ',                                  
           TRADE_NO = '00000000000',                                  
           SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),                                  
           SCRIP_CD,                                  
           SERIES,                     
           SCRIPNAME,                       
           SDT,                   
           SELL_BUY,                                  
           BROKER_CHRG = SUM(BROKER_CHRG),                                  
           TURN_TAX = SUM(TURN_TAX),                                  
           SEBI_TAX = SUM(SEBI_TAX),                          
           OTHER_CHRG = SUM(OTHER_CHRG),                                  
           INS_CHRG = SUM(INS_CHRG),                              
           SERVICE_TAX = SUM(SERVICE_TAX),                                  
           NSERTAX = SUM(NSERTAX),                                  
           SAUDA_DATE1,                                  
           PQTY = SUM(PQTY),                                  
           SQTY = SUM(SQTY),                                  
           PRATE = (CASE                                
                      WHEN SUM(PQTY) > 0 THEN SUM(PRATE * PQTY) / SUM(PQTY)                                  
                      ELSE 0                                  
 END),                                  
           SRATE = (CASE                                   
                      WHEN SUM(SQTY) > 0 THEN SUM(SRATE * SQTY) / SUM(SQTY)                                  
                      ELSE 0                                  
                    END),                                  
           PBROK = (CASE                                   
                      WHEN SUM(PQTY) > 0 THEN SUM(PBROK * PQTY) / SUM(PQTY)                                  
                      ELSE 0                                  
                    END),                                  
           SBROK = (CASE                                   
                      WHEN SUM(SQTY) > 0 THEN SUM(SBROK * SQTY) / SUM(SQTY)                                  
                      ELSE 0                                  
                    END),                                  
           PNETRATE = (CASE                                   
                         WHEN SUM(PQTY) > 0 THEN SUM(PNETRATE * PQTY) / SUM(PQTY)                                  
                         ELSE 0                                  
                       END),                                  
           SNETRATE = (CASE                                   
                         WHEN SUM(SQTY) > 0 THEN SUM(SNETRATE * SQTY) / SUM(SQTY)                 
                         ELSE 0                                  
                       END),                                  
           PAMT = SUM(PAMT),                                 
           SAMT = SUM(SAMT),                                  
           BROKERAGE = SUM(BROKERAGE),                                  
           SETT_NO,                                  
           SETT_TYPE,                                  
           TRADETYPE,                                  
           TMARK,       
           USER_ID,                                 
           PRINTF,                                  
           ORDERFLAG,                                  
           SCRIPNAMEFORORDERBY,                                
           SCRIPNAME1,                                  
           ACTSELL_BUY,                                  
           ISIN,                                  
           ROUNDTO = 4                                  
  FROM     CONTRACT_DATA_TMP WITH (NOLOCK)                                  
  WHERE    PRINTF = 3                                  
  GROUP BY CONTRACTNO,PARTY_CODE,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),SCRIP_CD,                                  
           SERIES,SCRIPNAME,SDT,SELL_BUY,                                  
           SETT_NO,SETT_TYPE,SAUDA_DATE1,TRADETYPE,                                  
           TMARK,PARTYNAME,L_ADDRESS1,L_ADDRESS2,                                  
           L_ADDRESS3,L_CITY,L_STATE,L_ZIP,                                  
           SERVICE_CHRG,BRANCH_CD,SUB_BROKER,TRADER,                                  
           PAN_GIR_NO,OFF_PHONE1,OFF_PHONE2,PRINTF,                                  
           MAPIDID,UCC_CODE,ORDERFLAG,SCRIPNAMEFORORDERBY,                                  
           SCRIPNAME1,SEBI_NO,PARTICIPANT_CODE,ACTSELL_BUY,                                  
           ISIN,USER_ID                                  
                                             
  INSERT INTO CONTRACT_DATA_DET                                  
  SELECT CONTRACTNO,                                  
         PARTY_CODE,                                  
         ORDER_NO,                                  
         ORDER_TIME,                                  
         TM,                                  
         TRADE_NO,                                  
         SAUDA_DATE,                                  
         SCRIP_CD,                                  
SERIES,                                
         SCRIPNAME,                        
         SDT,                                  
         SELL_BUY,                                  
         BROKER_CHRG,                                  
         TURN_TAX,                                  
         SEBI_TAX,                                  
         OTHER_CHRG,                                  
   INS_CHRG,                                  
         SERVICE_TAX,                                  
         NSERTAX,                                  
         SAUDA_DATE1,                                  
         PQTY,                                  
         SQTY,                                  
         PRATE,                                  
         SRATE,                                  
         PBROK,                                  
         SBROK,                                  
         PNETRATE,                                  
         SNETRATE,                                  
         PAMT,                                  
         SAMT,                                  
         BROKERAGE,                                  
         SETT_NO,                                  
         SETT_TYPE,                                  
         TRADETYPE,                                  
         TMARK,      
               
         PRINTF,                                  
         ORDERFLAG,                                  
         SCRIPNAMEFORORDERBY,                                  
         SCRIPNAME1,                                  
         ACTSELL_BUY,                                  
         ISIN,                                  
         ROUNDTO = 2 ,      
         USER_ID                                                             
  FROM   CONTRACT_DATA_TMP WITH (NOLOCK)                                  
  WHERE  PRINTF = 3                                  
                                                    
  INSERT INTO CONTRACT_DATA                                  
  SELECT CONTRACTNO,                                  
         PARTY_CODE,                                  
         ORDER_NO,                                  
         ORDER_TIME,                                  
         TM,                                  
         TRADE_NO,                                  
         SAUDA_DATE,                                  
         SCRIP_CD,                                  
         SERIES,                                  
         SCRIPNAME,                     
         SDT,                                  
         SELL_BUY,                                  
 BROKER_CHRG,                                  
         TURN_TAX,                                  
         SEBI_TAX,                                  
         OTHER_CHRG,                                  
         INS_CHRG,                                  
         SERVICE_TAX,                                  
         NSERTAX,                                  
         SAUDA_DATE1,                                  
         PQTY,                                  
         SQTY,                                  
         PRATE,                                  
         SRATE,                                  
         PBROK,                                  
         SBROK,                                  
         PNETRATE,                                  
         SNETRATE,                                  
         PAMT,                                  
         SAMT,                                  
         BROKERAGE,                                  
         SETT_NO,                                  
         SETT_TYPE,                                  
         TRADETYPE,                                  
         TMARK,      
                                           
         PRINTF,                                  
         ORDERFLAG,                              
         SCRIPNAMEFORORDERBY,                               
         SCRIPNAME1,                                  
         ACTSELL_BUY,                                  
         ISIN,                                  
         ROUNDTO = 2 ,      
         USER_ID                                 
  FROM   CONTRACT_DATA_TMP WITH (NOLOCK)                                  
  WHERE  PRINTF <> 3                                  
                                                     
  UPDATE CONTRACT_DATA                                  
  SET    ORDER_NO = S.ORDER_NO,                                  
         TM = CONVERT(VARCHAR,S.SAUDA_DATE,108),                                  
         TRADE_NO = S.TRADE_NO,                                  
         ORDER_TIME = S.ORDER_TIME                                  
  FROM   CONTRACT_DATA_TMP S WITH (NOLOCK)                                  
 WHERE  CONTRACT_DATA.SETT_NO = @SETT_NO                            
         AND CONTRACT_DATA.SETT_TYPE = @SETT_TYPE                                  
         AND S.SETT_NO = @SETT_NO                                  
         AND S.SETT_TYPE = @SETT_TYPE                                  
         AND S.PARTY_CODE = CONTRACT_DATA.PARTY_CODE                                  
         AND S.SCRIP_CD = CONTRACT_DATA.SCRIP_CD                                  
    AND S.SERIES = CONTRACT_DATA.SERIES                                  
         AND CONTRACT_DATA.SAUDA_DATE LIKE @SAUDA_DATE + '%'                                  
         AND S.PRINTF = CONTRACT_DATA.PRINTF                                  
      AND S.SAUDA_DATE LIKE @SAUDA_DATE + '%'                                  
         AND S.CONTRACTNO = CONTRACT_DATA.CONTRACTNO                                  
         AND S.ACTSELL_BUY = CONTRACT_DATA.ACTSELL_BUY                                  
         AND S.PRINTF = 3                                  
         AND S.SAUDA_DATE = (SELECT MIN(SAUDA_DATE)                                  
                             FROM   CONTRACT_DATA_TMP ISETT WITH (NOLOCK)                       
                             WHERE  ISETT.SETT_NO = @SETT_NO                                  
                                    AND ISETT.SETT_TYPE = @SETT_TYPE                                  
                                    AND ISETT.SETT_NO = S.SETT_NO                                  
                                    AND ISETT.SETT_TYPE = S.SETT_TYPE                                  
                                    AND S.PARTY_CODE = ISETT.PARTY_CODE                                  
                                    AND S.SCRIP_CD = ISETT.SCRIP_CD                                  
                                    AND S.SERIES = ISETT.SERIES                                  
                                  AND ISETT.SAUDA_DATE LIKE @SAUDA_DATE + '%'                                  
                                    AND S.CONTRACTNO = ISETT.CONTRACTNO                                  
                                    AND S.ACTSELL_BUY = ISETT.ACTSELL_BUY                                  
                                    AND PRINTF = 3)                                  
                                                              
 INSERT INTO CONTRACT_MASTER                     
                    
                    
SELECT  SETT_TYPE, SETT_NO, C1.PARTY_CODE,                                                
         START_DATE,                                                                                      
                  END_DATE,                                                                                      
                  FUNDS_PAYIN,                                                      
                  FUNDS_PAYOUT,                                                                                      
                  C.BRANCH_CD,                                                
                  C.SUB_BROKER,                                                                                     
                  C.TRADER,                                                                                      
                  C.AREA,                                       
                  C.REGION,                                                                                      
                  C.FAMILY,                                                                                      
                  PARTYNAME=C.LONG_NAME,                                                                                      
                  C.L_ADDRESS1,                                                                                      
                  C.L_ADDRESS2,                                                
                  C.L_ADDRESS3,                                                                                      
                  C.L_CITY,                                                                                      
      C.L_STATE,                                                                                      
                  C.L_ZIP,               
                  C.PAN_GIR_NO,                                                                                      
                  C1.OFF_PHONE1,                                                                                      
                  C1.OFF_PHONE2,                                                                                      
                  MAPIDID=max(MAPIDID),                                                                     
                  UCC_CODE=max(UCC_CODE),                                                                                      
                  SEBI_NO=max(SEBI_NO),                                                                                 
      PARTICIPANT_CODE,                                                                                      
                  C.CL_TYPE,                                               
       C2.SERVICE_CHRG,                                                                                  
               C2.PRINTF                                                                  
  FROM CONTRACT_DATA_TMP C1, CLIENT1 C, CLIENT2 C2                     
    WHERE  C.CL_CODE = C1.PARTY_CODE                    
           AND C.CL_CODE = C2.PARTY_CODE                                              
group by SETT_TYPE, SETT_NO, C1.PARTY_CODE,                                                
         START_DATE,                                                                                      
                  END_DATE,                                                   
                  FUNDS_PAYIN,                                                                
                  FUNDS_PAYOUT,                                                                                      
                  C.BRANCH_CD,                       
                  C.SUB_BROKER,                                                                                     
                  C.TRADER,                                                                                      
                  C.AREA,                                                                                      
                  C.REGION,                                                                                      
                  C.FAMILY,                                                                                      
                  C.LONG_NAME,                                                      
                  C.L_ADDRESS1,                                                                     
                  C.L_ADDRESS2,                                                
                  C.L_ADDRESS3,                                                                                      
                  C.L_CITY,                                                                                      
                  C.L_STATE,                                                                                      
                  C.L_ZIP,                                                                                      
                  C.PAN_GIR_NO,                                                          
                  C1.OFF_PHONE1,                              
                  C1.OFF_PHONE2,                                                                             
      PARTICIPANT_CODE,                                              
                                                                                    
                  C.CL_TYPE,                                                                                      
                  C2.SERVICE_CHRG,                                                                                      
                  C2.PRINTF

GO
