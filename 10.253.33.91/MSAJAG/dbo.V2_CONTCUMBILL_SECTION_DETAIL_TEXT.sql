-- Object: PROCEDURE dbo.V2_CONTCUMBILL_SECTION_DETAIL_TEXT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE  PROC [dbo].[V2_CONTCUMBILL_SECTION_DETAIL_TEXT](                              
           @STATUSID       VARCHAR(15),                              
           @STATUSNAME     VARCHAR(25),                              
           @SAUDA_DATE     VARCHAR(11),                              
           @SETT_NO        VARCHAR(7),                              
           @SETT_TYPE      VARCHAR(2),                              
           @FROMPARTY_CODE VARCHAR(10),                              
           @TOPARTY_CODE   VARCHAR(10),                              
           @FROMBRANCH     VARCHAR(10),                              
           @TOBRANCH       VARCHAR(10),      
     @BRANCHFLAG       VARCHAR(10),                                  
           @FROMSUB_BROKER VARCHAR(10),                              
           @TOSUB_BROKER   VARCHAR(10),                              
           @CONTFLAG       VARCHAR(10),                                
          @PRINTF         VARCHAR(6) = 'ALL',                              
    @DIGIFLAG    VARCHAR(7) = 'ALL')                                 
AS                              
 --EXEC V2_CONTCUMBILL_SECTION_DETAIL_TEXT 'broker','broker','Jul 18 2011','2011136','N','M888','M888','','zzzzzzzzzz','BRANCHGROUP','','zzzzzzzzzz','CONTRACT','ECN' ,''                              
                          
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
 ORDERBYFLAG = (CASE                     
                            WHEN @COLNAME = 'ORD_N' THEN PARTYNAME                    
                            WHEN @COLNAME = 'ORD_P' THEN M.PARTY_CODE                    
                            WHEN @COLNAME = 'ORD_BP' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(M.PARTY_CODE))                    
                            WHEN @COLNAME = 'ORD_BN' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(PARTYNAME))                    
                            WHEN @COLNAME = 'ORD_DP' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(M.PARTY_CODE))                    
                            WHEN @COLNAME = 'ORD_DN' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(PARTYNAME))                    
                            ELSE RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(M.PARTY_CODE))                    
                          END),               
     CONTRACTNO,                              
        M.PARTY_CODE,                                 
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
      /*  PARTYNAME,                                 
        L_ADDRESS1,                               
        L_ADDRESS2,                                 
        L_ADDRESS3,                                 
        L_CITY,                                 
 L_STATE,                              
        L_ZIP, */                                
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
--        SCRIPNAME1='',                              
 ISIN,                              
 BRANCH_GROUP,    
 START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,AREA,REGION,FAMILY,PARTYNAME,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_STATE,L_ZIP,
 SEBI_NO,    
 Participant_Code,CL_TYPE,
 USER_ID,          
 REMARK_ID=CONVERT(VARCHAR(12),''),          
REMARK_DESC=CONVERT(VARCHAR(100),''),           
REMARK_IDDESC=CONVERT(VARCHAR(200),'')              
--INTO CONTRACTTEXT 
INTO #CONTRACT_DATA 
  FROM     CONTRACT_DATA D WITH (NOLOCK),                              
        CONTRACT_MASTER M WITH (NOLOCK),                                 
           MSAJAG.DBO.FUN_PRINTF(@PRINTF) P,  
           BRANCHGROUP BG (nolock)                                         
  WHERE    M.SETT_TYPE = D.SETT_TYPE                              
           AND M.SETT_NO = D.SETT_NO                              
     AND M.PARTY_CODE = D.PARTY_CODE                              
           AND M.SETT_TYPE = @SETT_TYPE                              
           AND M.SETT_NO = @SETT_NO                              
           AND M.PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE   
     AND M.BRANCH_CD = BG.BRANCH_CODE    
           AND BG.BRANCH_GROUP BETWEEN @FROMBRANCH AND @TOBRANCH                                                               
         --  AND BRANCH_CD BETWEEN @FROMBRANCH                         
           --                   AND @TOBRANCH                              
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
  ORDER BY BRANCH_GROUP,ORDERBYFLAG,                              
          -- BRANCH_CD,                              
           SUB_BROKER,                              
           TRADER,                              
           M.PARTY_CODE,                              
           PARTYNAME,                              
           CONTRACTNO DESC,                              
           SCRIPNAME1,                              
    SCRIPNAMEFORORDERBY,                               
    ORDERFLAG,                              
           SCRIPNAME,                              
           M.SETT_NO,                              
           M.SETT_TYPE,                              
           TM,                              
           ORDER_NO,                              
           TRADE_NO       
      
/*CREATE INDEX [BRANCHINDEX]                 
                ON [dbo].[CONTRACTTEXT]                 
                (                 
                        [SAUDA_DATE],                 
                        [PARTY_CODE]                 
                )                   
                
IF @BRANCHFLAG='BRANCH'                
    SElect * from CONTRACTTEXT (nolock)               
    where BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH             
                  
                     
ELSE                
    SElect * from CONTRACTTEXT T (nolock)  LEFT OUTER JOIN BRANCHGROUP BG (nolock)                  
           ON T.BRANCH_CD=BG.BRANCH_CODE                              
    where  BG.BRANCH_GROUP BETWEEN @FROMBRANCH AND @TOBRANCH    
    order by  BRANCH_GROUP,party_code            
                   
                     
                
DROP TABLE CONTRACTTEXT   
*/

 UPDATE #CONTRACT_DATA                     
  SET    SCRIPNAME ='(' + M.REMARK_ID + ')' + LTRIM(RTRIM(SCRIPNAME)),                
   REMARK_ID=M.REMARK_ID,                
   REMARK_DESC=M.REMARK_DESC                
  FROM    #CONTRACT_DATA CN,TBL_CONTRACT_TERMINAL_MAPPING M                
  where   USER_ID=TERMINAL_ID AND CN.ORDER_NO LIKE M.ORDER_NO + '%'            
      AND SAUDA_DATE BETWEEN FROM_DATE AND m.END_DATE + '23:59:59'               
      and scrip_cd <> 'BROKERAGE'             
                  
               
               
SELECT DISTINCT PARTY_CODE,REMARK_DESC ='('+REMARK_ID+')'+':-'+ REMARK_DESC             
INTO   #REMARK                 
FROM   #CONTRACT_DATA C          
where  LEN(REMARK_ID) > 0                
GROUP BY REMARK_ID,REMARK_DESC,PARTY_CODE             
            
            
            
select distinct PARTY_CODE=t1.PARTY_CODE,            
  STUFF((SELECT distinct ' ' + t2.REMARK_DESC            
         from #REMARK t2            
         where t1.PARTY_CODE = t2.PARTY_CODE            
            FOR XML PATH(''), TYPE            
        ).value('.', 'NVARCHAR(MAX)')             
        ,1,0,'') REMARK_DESC            
into  #REMARK1                   
from #REMARK t1            
            
            
            
            
      
/*SELECT DISTINCT PARTY_CODE,REMARK_DESC =(SELECT DISTINCT '('+REMARK_ID+')'+':-'+ REMARK_DESC + ',' AS [data()] FROM #CONTRACT_DATA where LEN(REMARK_ID) > 0 FOR XML PATH(''))                
INTO   #REMARK                 
FROM   #CONTRACT_DATA C                
where  LEN(REMARK_ID) > 0                
GROUP BY REMARK_ID,REMARK_DESC,PARTY_CODE */            
            
            
                
                
                
/*UPDATE #REMARK                
SET REMARK_DESC=LEFT(REMARK_DESC,LEN(REMARK_DESC)-1) */              
                
                
                
UPDATE #CONTRACT_DATA                
SET  REMARK_IDDESC=R.REMARK_DESC                
FROM #REMARK1 R,#CONTRACT_DATA CN                
where                 
R.PARTY_CODE=CN.PARTY_CODE                
                
                           
   select * from  #CONTRACT_DATA
   ORDER BY BRANCH_GROUP,ORDERBYFLAG,                              
          -- BRANCH_CD,                              
           SUB_BROKER,                              
           TRADER,                              
           PARTY_CODE,                              
           PARTYNAME,                              
           CONTRACTNO DESC,                              
           SCRIPNAME1,                              
    SCRIPNAMEFORORDERBY,                               
    ORDERFLAG,                              
           SCRIPNAME,                              
           SETT_NO,                              
           SETT_TYPE,                              
           TM,                              
           ORDER_NO,                              
           TRADE_NO

GO
