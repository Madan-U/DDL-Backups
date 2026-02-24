-- Object: PROCEDURE dbo.bak_PR_CHARGES_DETAIL_17042017
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


--[PR_CHARGES_DETAIL] '2014065','n','a','zzzzz'    
create PROC [dbo].[bak_PR_CHARGES_DETAIL_17042017]                       
(                    
 @F_SETT_NO VARCHAR(7),                      
 @F_SETT_TYPE VARCHAR(2),                      
 @FROM_PARTY VARCHAR(10),                      
 @TO_PARTY VARCHAR(10)                    
)                      
 AS                      
DECLARE                     
 @SETTCUR CURSOR,                    
 @PARTY_CODE VARCHAR(10),                            
 @SETT_NO VARCHAR(7),                            
 @SETT_TYPE VARCHAR(2),                            
 @SAUDA_DATE VARCHAR(11),                            
 @CONTRACTNO VARCHAR(14),                            
 @TRADE_NO VARCHAR(20),                            
 @ORDER_NO VARCHAR(16),                            
 @SCRIP_CD VARCHAR(12),                            
 @SERIES VARCHAR(3),                         
 @BUYRATE MONEY,                            
 @SELLRATE MONEY,                            
 @TRDBUYQTY INT,                            
 @TRDSELLQTY INT,                            
 @DELBUYQTY INT,                            
 @DELSELLQTY INT,                      
 @TRDBUYQTYORG INT,                            
 @TRDSELLQTYORG INT,                            
 @DELBUYQTYORG INT,                            
 @DELSELLQTYORG INT,                      
 @TRDBUY_TURNOVER MONEY,                            
 @TRDSELL_TURNOVER MONEY,                            
 @DELBUY_TURNOVER MONEY,                            
 @DELSELL_TURNOVER MONEY,                            
 @SP_COMPUTATIONLEVEL CHAR(1),                            
 @SP_COMPUTATIONON CHAR(1),                            
 @SP_COMPUTATIONTYPE CHAR(1),                       
 @SCHEMEID INT,                         
 @MIN_BROKAMT MONEY,                            
 @MAX_BROKAMT MONEY,                            
 @MIN_SCRIPAMT MONEY,                            
 @MAX_SCRIPAMT MONEY,                            
 @SP_TRD_TYPE CHAR(3)                   
DECLARE                     
 @SCHEMECUR CURSOR,                            
 @SP_COMPUTATION_LEVEL CHAR(1),                            
 @SP_MULTIPLIER MONEY,                            
 @SP_BUY_BROK_TYPE CHAR(1),                            
 @SP_SELL_BROK_TYPE CHAR(1),                            
 @SP_BUY_BROK NUMERIC (18,4),                            
 @SP_SELL_BROK NUMERIC (18,4),                            
 @SP_VALUE_FROM NUMERIC (18,4),                            
 @SP_VALUE_TO NUMERIC (18,4),                            
 @BUYFLAG INT,                            
 @SELLFLAG INT,                            
 @SP_SCHEME_TYPE INT                            
                            
DECLARE                             
 @BUY_TURNOVER MONEY,                            
 @NEWBUYTURNOVER MONEY,                            
 @NEWBUYTURNOVER_1 MONEY,                      
 @NEWBUYTURNOVERORG MONEY,                            
 @SELL_TURNOVER MONEY,                            
 @NEWSELLTURNOVER MONEY,                            
 @NEWSELLTURNOVER_1 MONEY,                            
 @NEWSELLTURNOVERORG MONEY,                            
 @BUYBROKERAGE MONEY,                            
 @SELLBROKERAGE MONEY,                      
 @BUYBROKERAGE_1 MONEY,                            
 @SELLBROKERAGE_1 MONEY,                
                
 @SEBI_LIMIT MONEY                
                    
TRUNCATE TABLE VBB_CHARGES_DETAIL_TEMP                      
TRUNCATE TABLE VBB_CHARGES_DETAIL_TEMP_1                      
TRUNCATE TABLE VBB_CHARGES_DETAIL_TEMP_2                      
TRUNCATE TABLE VBB_SETTLEMENT                      
TRUNCATE TABLE TRD_SCHEME_MAPPING                    
TRUNCATE TABLE TRD_CONTRACT_ROUNDING                     
                
SELECT @SEBI_LIMIT = 2.5   
        
                    
SET NOCOUNT ON                          
INSERT INTO VBB_SETTLEMENT SELECT SETT_NO,SETT_TYPE,SAUDA_DATE,                    
 PARTY_CODE,CONTRACTNO,TRADE_NO,ORDER_NO,SCRIP_CD,SERIES,                    
 MARKETRATE,SELL_BUY,BILLFLAG,TRADEQTY,NBROKAPP,AUCTIONPART                    
FROM                    
 SETTLEMENT                    
WHERE                    
 SETT_NO = @F_SETT_NO AND                 
 SETT_TYPE = @F_SETT_TYPE AND                    
 PARTY_CODE BETWEEN  @FROM_PARTY AND @TO_PARTY AND                    
 TRADEQTY > 0                 
 --ORDER BY   PARTY_CODE         
            

DROP INDEX [partyidx] ON [dbo].[VBB_Settlement] 

CREATE CLUSTERED INDEX [partyidx] ON [dbo].[VBB_Settlement] 
(
	[Sauda_Date] ASC,
	[Party_Code] ASC,
	[Sett_No] ASC,
	[Sett_Type] ASC
)


SELECT DISTINCT PARTY_CODE, SAUDA_DATE = CONVERT(DATETIME,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11))                       
INTO #SETT                      
FROM VBB_SETTLEMENT                      

CREATE CLUSTERED INDEX [partyidx] ON [dbo].#SETT 
(
	[Party_Code] ASC
)
            
TRUNCATE TABLE TRD_SETT_MST                  
INSERT INTO TRD_SETT_MST                  
  SELECT *                  
  FROM   SETT_MST                  
  WHERE  SETT_NO = @F_SETT_NO AND                       
 SETT_TYPE = @F_SETT_TYPE             
              
TRUNCATE TABLE TRD_CLIENT2                
INSERT INTO TRD_CLIENT2              
SELECT CL_CODE,EXCHANGE,TRAN_CAT,SCRIP_CAT,PARTY_CODE,TABLE_NO,SUB_TABLENO,MARGIN,TURNOVER_TAX,                
SEBI_TURN_TAX,INSURANCE_CHRG,SERVICE_CHRG,STD_RATE,P_TO_P,EXPOSURE_LIM,DEMAT_TABLENO,BANKID,                
CLTDPNO,PRINTF,ALBMDELCHRG,ALBMDELIVERY,ALBMCF_TABLENO,MF_TABLENO,SB_TABLENO,BROK1_TABLENO,                
BROK2_TABLENO,BROK3_TABLENO,BROKERNOTE,OTHER_CHRG,BROK_SCHEME,CONTCHARGE,MINCONTAMT,ADDLEDGERBAL,                
DUMMY1,DUMMY2,INSCONT,SERTAXMETHOD,DUMMY6,DUMMY7,DUMMY8,DUMMY9,DUMMY10                
FROM CLIENT2                
WHERE EXISTS (SELECT PARTY_CODE FROM #SETT WHERE #SETT.PARTY_CODE = CLIENT2.PARTY_CODE)          
ORDER BY CL_CODE            
            
TRUNCATE TABLE TRD_CLIENT1            
INSERT INTO TRD_CLIENT1            
SELECT CL_CODE,SHORT_NAME,LONG_NAME,L_ADDRESS1,L_ADDRESS2,L_CITY,L_STATE,L_NATION,L_ZIP,FAX,RES_PHONE1,            
RES_PHONE2,OFF_PHONE1,OFF_PHONE2,EMAIL,BRANCH_CD,CREDIT_LIMIT,CL_TYPE,CL_STATUS,GL_CODE,FD_CODE,FAMILY,            
PENALTY,SUB_BROKER,CONFIRM_FAX,PHONEOLD,L_ADDRESS3,MOBILE_PAGER,PAN_GIR_NO,TRADER,WARD_NO,REGION,AREA,CLRATING            
FROM CLIENT1            
WHERE EXISTS (SELECT PARTY_CODE FROM #SETT WHERE #SETT.PARTY_CODE = CLIENT1.CL_CODE)         
ORDER BY CL_CODE            
                    
DECLARE @SAUDA_DATE_FROM VARCHAR(11)                    
                    
SELECT @SAUDA_DATE_FROM = MIN(SAUDA_DATE) FROM VBB_SETTLEMENT                    
                    
/* POPULATE TRD TABLES FOR BROKERAGE MAPPING AND ROUNDING */                    
                    
  INSERT INTO TRD_SCHEME_MAPPING                    
  SELECT *                    
  FROM   SCHEME_MAPPING M                    
  WHERE  SP_DATE_TO > @SAUDA_DATE_FROM                     
         AND EXISTS (SELECT DISTINCT PARTY_CODE                    
                     FROM   VBB_SETTLEMENT S                    
                     WHERE  M.SP_PARTY_CODE = S.PARTY_CODE)           
   ORDER BY   SP_PARTY_CODE               
                    
  INSERT INTO TRD_CONTRACT_ROUNDING                    
  SELECT *                    
  FROM   CONTRACT_ROUNDING M                    
  WHERE  CR_DATE_TO > @SAUDA_DATE_FROM                     
         AND EXISTS (SELECT DISTINCT PARTY_CODE                    
                     FROM   VBB_SETTLEMENT S                    
                     WHERE  M.CR_PARTY_CODE = S.PARTY_CODE)           
  ORDER BY   CR_PARTY_CODE                   
                    
/* DELETE RECORDS FROM TEMPORARY VBB SETTLEMENT TABLE FOR CLIENT WHERE VBB IS NOT DEFINED */                    
                    
  DELETE FROM VBB_SETTLEMENT                    
  WHERE       NOT EXISTS (SELECT DISTINCT PARTY_CODE                    
                          FROM   (SELECT PARTY_CODE = SP_PARTY_CODE                    
                                  FROM   TRD_SCHEME_MAPPING (nolock)                   
                                  WHERE  SAUDA_DATE BETWEEN SP_DATE_FROM AND SP_DATE_TO                    
           UNION                     
                                  SELECT PARTY_CODE = CR_PARTY_CODE                    
                                  FROM   TRD_CONTRACT_ROUNDING (nolock)                    
                                  WHERE  SAUDA_DATE BETWEEN CR_DATE_FROM AND CR_DATE_TO) A                    
                          WHERE  A.PARTY_CODE = VBB_SETTLEMENT.PARTY_CODE)                    
                    
/*------------------------------------------------------------------------------------------*/                    
INSERT INTO VBB_CHARGES_DETAIL_TEMP_1                       
SELECT                     
 PARTY_CODE,SETT_NO,SETT_TYPE,SAUDA_DATE,CONTRACTNO='0',                    
 TRADE_NO,ORDER_NO,SCRIP_CD,SERIES,                      
 BUYRATE = (CASE WHEN SUM(TRDBUY_QTY+DELBUY_QTY) > 0                       
           THEN SUM((TRDBUY_QTY+DELBUY_QTY)*BUYRATE) / SUM(TRDBUY_QTY+DELBUY_QTY)                       
    ELSE 0                      
      END),                      
 SELLRATE = (CASE WHEN SUM(TRDSELL_QTY+DELSELL_QTY) > 0                       
           THEN SUM((TRDSELL_QTY+DELSELL_QTY)*SELLRATE) / SUM(TRDSELL_QTY+DELSELL_QTY)                       
    ELSE 0                       
      END),                      
 TRDBUY_QTY=SUM(TRDBUY_QTY),                      
 TRDSELL_QTY=SUM(TRDSELL_QTY),                      
 DELBUY_QTY=SUM(DELBUY_QTY),                      
 DELSELL_QTY=SUM(DELSELL_QTY),                      
 TRDBUYBROKERAGE=(CASE WHEN SUM(RND_TRDBUY_TURNOVER) >= SUM(TRDBUY_TURNOVER) AND SUM(DELBUY_TURNOVER) > 0                       
         THEN SUM(TRDBUYBROKERAGE_1)                       
         ELSE SUM(TRDBUYBROKERAGE_1)                      
    END),                      
 TRDSELLBROKERAGE=(CASE WHEN SUM(RND_TRDSELL_TURNOVER) >= SUM(TRDSELL_TURNOVER) AND SUM(DELSELL_TURNOVER) > 0                       
         THEN SUM(TRDSELLBROKERAGE_1)                       
         ELSE SUM(TRDSELLBROKERAGE_1)                      
    END),                      
 DELBUYBROKERAGE=SUM(DELBUYBROKERAGE),                      
 DELSELLBROKERAGE=SUM(DELSELLBROKERAGE),                      
 TOTALBROKERAGE = 0,                      
 TRDBUY_TURNOVER=SUM(TRDBUY_TURNOVER),                      
 TRDSELL_TURNOVER=SUM(TRDSELL_TURNOVER),                      
 DELBUY_TURNOVER=SUM(DELBUY_TURNOVER),                      
 DELSELL_TURNOVER=SUM(DELSELL_TURNOVER),                      
 SP_COMPUTATION_LEVEL,                      
 SP_MIN_BROKAMT,SP_MAX_BROKAMT,SP_MIN_SCRIPAMT,SP_MAX_SCRIPAMT                      
FROM                     
(                      
 SELECT                     
  PARTY_CODE,SETT_NO,SETT_TYPE,SAUDA_DATE,CONTRACTNO='0',                      
  TRADE_NO = (CASE WHEN SP_COMPUTATION_LEVEL = 'T' THEN TRADE_NO ELSE '' END),                            
  ORDER_NO = (CASE WHEN SP_COMPUTATION_LEVEL IN ('T', 'O') THEN ORDER_NO ELSE '' END),                      
  SCRIP_CD = (CASE WHEN SP_COMPUTATION_LEVEL <> 'C' THEN SCRIP_CD ELSE '' END),                            
  SERIES = (CASE WHEN SP_COMPUTATION_LEVEL <> 'C' THEN SERIES ELSE '' END),                      
  BUYRATE = (CASE WHEN SUM(TRDBUY_QTY+DELBUY_QTY) > 0                       
            THEN SUM((TRDBUY_QTY+DELBUY_QTY)*MARKETRATE) / SUM(TRDBUY_QTY+DELBUY_QTY)                       
  ELSE 0                       
       END),          
  SELLRATE = (CASE WHEN SUM(TRDSELL_QTY+DELSELL_QTY) > 0                       
            THEN SUM((TRDSELL_QTY+DELSELL_QTY)*MARKETRATE) / SUM(TRDSELL_QTY+DELSELL_QTY)                       
  ELSE 0                       
       END),                        
  TRDBUY_QTY=SUM(TRDBUY_QTY),                      
  TRDSELL_QTY=SUM(TRDSELL_QTY),                      
  DELBUY_QTY=SUM(DELBUY_QTY),                      
  DELSELL_QTY=SUM(DELSELL_QTY),                      
  TRDBUY_TURNOVER=SUM(TRDBUY_TURNOVER),                      
  TRDSELL_TURNOVER=SUM(TRDSELL_TURNOVER),                      
  RND_TRDBUY_TURNOVER = PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDBUY_TURNOVER),SP_MULTIPLIER),      
  RND_TRDSELL_TURNOVER = PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDSELL_TURNOVER),SP_MULTIPLIER),                      
  DELBUY_TURNOVER=SUM(DELBUY_TURNOVER),                      
  DELSELL_TURNOVER=SUM(DELSELL_TURNOVER),                      
  TRDBUYBROKERAGE_1 = (CASE WHEN SP_SCHEME_TYPE = 0                             
                     THEN  (PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDBUY_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER *                
                            (CASE WHEN SP_BUY_BROK_TYPE = 'P'                             
                           THEN SP_BUY_BROK/100                             
                           ELSE SP_BUY_BROK                             
                           END))                             
             WHEN (SUM(TRDBUY_TURNOVER+DELBUY_TURNOVER) >= SUM(TRDSELL_TURNOVER+DELSELL_TURNOVER) AND SP_SCHEME_TYPE = 1)                             
        OR (SUM(TRDBUY_TURNOVER+DELBUY_TURNOVER) > SUM(TRDSELL_TURNOVER+DELSELL_TURNOVER) AND SP_SCHEME_TYPE = 3)                            
             THEN (PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDBUY_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER *                             
           (CASE WHEN SP_BUY_BROK_TYPE = 'P'                             
                 THEN SP_BUY_BROK/100                             
          ELSE SP_BUY_BROK                             
            END))                            
             ELSE (PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDBUY_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER *                             
           (CASE WHEN SP_SELL_BROK_TYPE = 'P'                             
     THEN SP_SELL_BROK/100                             
          ELSE SP_SELL_BROK                             
            END))                            
         END),                      
    TRDSELLBROKERAGE_1 = (CASE WHEN SP_SCHEME_TYPE = 0                             
             THEN  (PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDSELL_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER *                             
                         (CASE WHEN SP_SELL_BROK_TYPE = 'P'                             
       THEN SP_SELL_BROK/100                             
                 ELSE SP_SELL_BROK                             
                      END))                            
             WHEN (SUM(TRDBUY_TURNOVER+DELBUY_TURNOVER) >= SUM(TRDSELL_TURNOVER+DELSELL_TURNOVER) AND SP_SCHEME_TYPE = 1)                             
        OR (SUM(TRDBUY_TURNOVER+DELBUY_TURNOVER) > SUM(TRDSELL_TURNOVER+DELSELL_TURNOVER) AND SP_SCHEME_TYPE = 3)                            
             THEN (PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDSELL_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER *                             
           (CASE WHEN SP_SELL_BROK_TYPE = 'P'                             
                 THEN SP_SELL_BROK/100                             
          ELSE SP_SELL_BROK                             
            END))                            
             ELSE (PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDSELL_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER *                             
           (CASE WHEN SP_BUY_BROK_TYPE = 'P'                             
          THEN SP_BUY_BROK/100                             
          ELSE SP_BUY_BROK                             
            END))                            
         END),                      
  TRDBUYBROKERAGE_2 = (CASE WHEN SUM(TRDBUY_TURNOVER) > 0 THEN (CASE WHEN SP_SCHEME_TYPE = 0                             
                     THEN  ((PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDBUY_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER-1) *                             
                            (CASE WHEN SP_BUY_BROK_TYPE = 'P'                             
                           THEN SP_BUY_BROK/100                             
                           ELSE SP_BUY_BROK                             
                           END))                             
             WHEN (SUM(TRDBUY_TURNOVER+DELBUY_TURNOVER) >= SUM(TRDSELL_TURNOVER+DELSELL_TURNOVER) AND SP_SCHEME_TYPE = 1)                             
        OR (SUM(TRDBUY_TURNOVER+DELBUY_TURNOVER) > SUM(TRDSELL_TURNOVER+DELSELL_TURNOVER) AND SP_SCHEME_TYPE = 3)                            
             THEN ((PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDBUY_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER-1) *                             
           (CASE WHEN SP_BUY_BROK_TYPE = 'P'                             
                 THEN SP_BUY_BROK/100                             
          ELSE SP_BUY_BROK                             
            END))                    
             ELSE ((PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDBUY_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER-1) *                             
           (CASE WHEN SP_SELL_BROK_TYPE = 'P'                             
          THEN SP_SELL_BROK/100                             
          ELSE SP_SELL_BROK                             
           END))                            
         END) ELSE 0 END),                      
    TRDSELLBROKERAGE_2 = (CASE WHEN SUM(TRDSELL_TURNOVER) > 0 THEN (CASE WHEN SP_SCHEME_TYPE = 0                             
             THEN  ((PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDSELL_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER-1) *                             
                         (CASE WHEN SP_SELL_BROK_TYPE = 'P'                             
                 THEN SP_SELL_BROK/100                             
                 ELSE SP_SELL_BROK                             
    END))                            
             WHEN (SUM(TRDBUY_TURNOVER+DELBUY_TURNOVER) >= SUM(TRDSELL_TURNOVER+DELSELL_TURNOVER) AND SP_SCHEME_TYPE = 1)                             
        OR (SUM(TRDBUY_TURNOVER+DELBUY_TURNOVER) > SUM(TRDSELL_TURNOVER+DELSELL_TURNOVER) AND SP_SCHEME_TYPE = 3)                            
     THEN ((PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDSELL_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER-1) *                             
           (CASE WHEN SP_SELL_BROK_TYPE = 'P'                             
                 THEN SP_SELL_BROK/100                           
          ELSE SP_SELL_BROK                             
            END))                            
             ELSE ((PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDSELL_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER-1) *                             
           (CASE WHEN SP_BUY_BROK_TYPE = 'P'                             
          THEN SP_BUY_BROK/100                             
          ELSE SP_BUY_BROK                             
            END))                            
         END) ELSE 0 END),                      
  DELBUYBROKERAGE=(PRADNYA.DBO.ROUNDEDTURNOVER(SUM(DELBUY_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER *                             
      (CASE WHEN SP_BUY_BROK_TYPE = 'P'                             
                        THEN SP_BUY_BROK/100                             
                        ELSE SP_BUY_BROK                             
                   END)),                      
  DELSELLBROKERAGE=(PRADNYA.DBO.ROUNDEDTURNOVER(SUM(DELSELL_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER *                             
                  (CASE WHEN SP_SELL_BROK_TYPE = 'P'        
                        THEN SP_SELL_BROK/100                             
                        ELSE SP_SELL_BROK                             
             END)),                      
  SP_COMPUTATION_LEVEL,SP_BROK_COMPUTEON,SP_BROK_COMPUTETYPE,SP_SCHEME_TYPE,SP_SCHEME_ID,SP_MULTIPLIER,                      
  SP_BUY_BROK,SP_SELL_BROK,SP_RES_MULTIPLIER,SP_RES_BUY_BROK,SP_RES_SELL_BROK,SP_VALUE_FROM,SP_VALUE_TO,                      
  SP_MIN_BROKAMT,SP_MAX_BROKAMT,SP_MIN_SCRIPAMT,SP_MAX_SCRIPAMT,SP_BUY_BROK_TYPE,SP_SELL_BROK_TYPE                      
 FROM (                      
  SELECT                         
     S.PARTY_CODE,S.SETT_NO,S.SETT_TYPE,SAUDA_DATE=LEFT(START_DATE,11), CONTRACTNO='0',                     
     TRADE_NO=PRADNYA.DBO.REPLACETRADENO(TRADE_NO),                       
     ORDER_NO, S.SCRIP_CD, S.SERIES, MARKETRATE, SELL_BUY,      
     TRDBUY_QTY = (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2 THEN TRADEQTY ELSE 0 END),                            
     TRDSELL_QTY = (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3 THEN TRADEQTY ELSE 0 END),                            
     DELBUY_QTY = (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 4 THEN TRADEQTY ELSE 0 END),                            
     DELSELL_QTY = (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 5 THEN TRADEQTY ELSE 0 END),                      
     TRDBUY_TURNOVER = (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2                       
        THEN CASE WHEN SP_BROK_COMPUTEON = 'T'                       
THEN TRADEQTY*MARKETRATE                       
           ELSE TRADEQTY                       
             END                       
        ELSE 0                      
                        END),                            
     TRDSELL_TURNOVER = (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3                       
        THEN CASE WHEN SP_BROK_COMPUTEON = 'T'                       
           THEN TRADEQTY*MARKETRATE                       
           ELSE TRADEQTY                       
             END                       
        ELSE 0                      
                        END),                           
     DELBUY_TURNOVER = (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 4                       
        THEN CASE WHEN SP_BROK_COMPUTEON = 'T'            
           THEN TRADEQTY*MARKETRATE                       
           ELSE TRADEQTY                       
             END                       
        ELSE 0                      
                        END),                      
     DELSELL_TURNOVER = (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 5                       
        THEN CASE WHEN SP_BROK_COMPUTEON = 'T'                       
           THEN TRADEQTY*MARKETRATE                       
           ELSE TRADEQTY                       
             END                       
        ELSE 0                      
                        END),                        
     SP_COMPUTATION_LEVEL, SP_BROK_COMPUTEON, SP_BROK_COMPUTETYPE, SP_SCHEME_TYPE, SP_SCHEME_ID, SP_MULTIPLIER,                      
     SP_BUY_BROK,SP_SELL_BROK,SP_RES_MULTIPLIER, SP_RES_BUY_BROK,SP_RES_SELL_BROK,SP_VALUE_FROM,SP_VALUE_TO,                      
     SP_MIN_BROKAMT,SP_MAX_BROKAMT,SP_MIN_SCRIPAMT,SP_MAX_SCRIPAMT, SP_BUY_BROK_TYPE,SP_SELL_BROK_TYPE,SP_TRD_TYPE                        
   FROM VBB_SETTLEMENT S, TRD_SCHEME_MAPPING M, TRD_SETT_MST SM, TRD_CLIENT1 C1, TRD_CLIENT2 C2                      
   WHERE C1.CL_CODE = C2.CL_CODE                      
   AND C2.PARTY_CODE = S.PARTY_CODE                      
   AND C1.CL_TYPE <> 'INS'                      
   AND SAUDA_DATE BETWEEN SP_DATE_FROM AND SP_DATE_TO                            
   AND S.PARTY_CODE = SP_PARTY_CODE                      
   AND S.SETT_NO = SM.SETT_NO AND S.SETT_TYPE = SM.SETT_TYPE                      
   AND SCRIP_CD LIKE (CASE WHEN SP_SCRIP = 'ALL' THEN '%' ELSE SP_SCRIP END)                   
   AND 1 = (CASE WHEN SP_SCRIP = 'ALL' AND SCRIP_CD NOT IN                             
            (SELECT SP_SCRIP FROM TRD_SCHEME_MAPPING M                      
         WHERE SAUDA_DATE BETWEEN SP_DATE_FROM AND SP_DATE_TO                            
                       AND S.PARTY_CODE = SP_PARTY_CODE)                      
                 THEN 1                               
                 ELSE (CASE WHEN SP_SCRIP = 'ALL' THEN 0 ELSE 1 END)                      
     END)                      
            AND SP_TRD_TYPE = (CASE WHEN BILLFLAG < 4                       
               THEN 'TRD'                       
                                    ELSE 'DEL'                
                               END)                      
   AND AUCTIONPART NOT LIKE 'A%' AND AUCTIONPART NOT LIKE 'F%'                      
   AND TRADE_NO NOT LIKE '%C%'                      
   AND MARKETRATE > 0 AND TRADEQTY > 0                      
   AND SP_BROK_COMPUTETYPE = 'V'                     
  )     
  SETT_MAPPING                      
 GROUP BY                     
  PARTY_CODE,SETT_NO,SETT_TYPE,SAUDA_DATE,                      
  (CASE WHEN SP_COMPUTATION_LEVEL = 'T' THEN TRADE_NO ELSE '' END),                            
  (CASE WHEN SP_COMPUTATION_LEVEL IN ('T', 'O') THEN ORDER_NO ELSE '' END),                      
  (CASE WHEN SP_COMPUTATION_LEVEL <> 'C' THEN SCRIP_CD ELSE '' END),                            
  (CASE WHEN SP_COMPUTATION_LEVEL <> 'C' THEN SERIES ELSE '' END),                      
  SP_COMPUTATION_LEVEL,SP_BROK_COMPUTEON,SP_BROK_COMPUTETYPE,SP_SCHEME_TYPE,SP_SCHEME_ID,SP_MULTIPLIER,                      
  SP_BUY_BROK,SP_SELL_BROK,SP_RES_MULTIPLIER,SP_RES_BUY_BROK,SP_RES_SELL_BROK,SP_VALUE_FROM,SP_VALUE_TO,                      
  SP_MIN_BROKAMT,SP_MAX_BROKAMT,SP_MIN_SCRIPAMT,SP_MAX_SCRIPAMT,SP_BUY_BROK_TYPE,SP_SELL_BROK_TYPE,                     
  SP_TRD_TYPE                      
 HAVING (CASE WHEN SP_TRD_TYPE = 'TRD'                       
       THEN SUM(TRDBUY_TURNOVER+TRDSELL_TURNOVER)                      
       ELSE SUM(DELBUY_TURNOVER+DELSELL_TURNOVER)                      
  END)                      
   > SP_VALUE_FROM                         
     AND                         
        (CASE WHEN SP_TRD_TYPE = 'TRD'                       
       THEN SUM(TRDBUY_TURNOVER+TRDSELL_TURNOVER)                      
       ELSE SUM(DELBUY_TURNOVER+DELSELL_TURNOVER)                      
  END)                      
   <=   (CASE WHEN SP_VALUE_TO = -1                             
              THEN (CASE WHEN SP_TRD_TYPE = 'TRD'                       
                  THEN SUM(TRDBUY_TURNOVER+TRDSELL_TURNOVER)                      
             ELSE SUM(DELBUY_TURNOVER+DELSELL_TURNOVER)                      
             END)                      
              ELSE SP_VALUE_TO                            
         END)                      
 ) SETT_MAPPINGFINAL                      
GROUP BY                     
 PARTY_CODE,SETT_NO,SETT_TYPE,SAUDA_DATE,CONTRACTNO,TRADE_NO,ORDER_NO,SCRIP_CD,SERIES,                      
 SP_COMPUTATION_LEVEL,SP_MIN_BROKAMT,SP_MAX_BROKAMT,SP_MIN_SCRIPAMT,SP_MAX_SCRIPAMT                      
                
SET @SETTCUR = CURSOR FOR                      
SELECT PARTY_CODE,SETT_NO,SETT_TYPE,SAUDA_DATE,CONTRACTNO,                      
  TRADE_NO = (CASE WHEN SP_COMPUTATION_LEVEL = 'T' THEN TRADE_NO ELSE '' END),                            
  ORDER_NO = (CASE WHEN SP_COMPUTATION_LEVEL IN ('T', 'O') THEN ORDER_NO ELSE '' END),                      
  SCRIP_CD = (CASE WHEN SP_COMPUTATION_LEVEL <> 'C' THEN SCRIP_CD ELSE '' END),                            
  SERIES = (CASE WHEN SP_COMPUTATION_LEVEL <> 'C' THEN SERIES ELSE '' END),                      
  BUYRATE = (CASE WHEN SUM(TRDBUY_QTY+DELBUY_QTY) > 0                       
                  THEN SUM((TRDBUY_QTY+DELBUY_QTY)*MARKETRATE) / SUM(TRDBUY_QTY+DELBUY_QTY)                       
    ELSE 0                       
             END),                      
  SELLRATE = (CASE WHEN SUM(TRDSELL_QTY+DELSELL_QTY) > 0                       
                  THEN SUM((TRDSELL_QTY+DELSELL_QTY)*MARKETRATE) / SUM(TRDSELL_QTY+DELSELL_QTY)                       
    ELSE 0                       
             END),                        
TRDBUY_QTY=SUM(TRDBUY_QTY),                      
TRDSELL_QTY=SUM(TRDSELL_QTY),                      
DELBUY_QTY=SUM(DELBUY_QTY),                      
DELSELL_QTY=SUM(DELSELL_QTY),                      
TRDBUY_TURNOVER=SUM(TRDBUY_TURNOVER),             
TRDSELL_TURNOVER=SUM(TRDSELL_TURNOVER),                      
DELBUY_TURNOVER=SUM(DELBUY_TURNOVER),                      
DELSELL_TURNOVER=SUM(DELSELL_TURNOVER),                      
SP_COMPUTATION_LEVEL,SP_BROK_COMPUTEON,SP_BROK_COMPUTETYPE,SP_SCHEME_ID,                      
SP_MIN_BROKAMT,SP_MAX_BROKAMT,SP_MIN_SCRIPAMT,SP_MAX_SCRIPAMT,SP_TRD_TYPE                      
FROM (                     
 SELECT                         
  S.PARTY_CODE,S.SETT_NO,S.SETT_TYPE,SAUDA_DATE=LEFT(START_DATE,11), CONTRACTNO='0',                     
  TRADE_NO=PRADNYA.DBO.REPLACETRADENO(TRADE_NO),                       
  ORDER_NO, SCRIP_CD, S.SERIES, MARKETRATE, SELL_BUY,                      
  TRDBUY_QTY = (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2 THEN TRADEQTY ELSE 0 END),                            
  TRDSELL_QTY = (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3 THEN TRADEQTY ELSE 0 END),                            
  DELBUY_QTY = (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 4 THEN TRADEQTY ELSE 0 END),                            
  DELSELL_QTY = (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 5 THEN TRADEQTY ELSE 0 END),                      
  TRDBUY_TURNOVER = (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2                       
  THEN CASE WHEN SP_BROK_COMPUTEON = 'T'                       
  THEN TRADEQTY*MARKETRATE                       
  ELSE TRADEQTY         
    END                       
  ELSE 0                      
               END),                            
  TRDSELL_TURNOVER = (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3                       
  THEN CASE WHEN SP_BROK_COMPUTEON = 'T'                       
  THEN TRADEQTY*MARKETRATE                       
  ELSE TRADEQTY                       
    END                       
  ELSE 0                      
               END),                           
  DELBUY_TURNOVER = (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 4                       
  THEN CASE WHEN SP_BROK_COMPUTEON = 'T'                       
  THEN TRADEQTY*MARKETRATE                       
  ELSE TRADEQTY                       
    END                       
  ELSE 0                      
               END),                           
  DELSELL_TURNOVER = (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 5                       
  THEN CASE WHEN SP_BROK_COMPUTEON = 'T'                       
  THEN TRADEQTY*MARKETRATE                       
  ELSE TRADEQTY                       
    END                       
  ELSE 0                      
               END),                        
  SP_COMPUTATION_LEVEL,SP_BROK_COMPUTEON,SP_BROK_COMPUTETYPE,SP_SCHEME_ID,                      
  SP_MIN_BROKAMT,SP_MAX_BROKAMT,SP_MIN_SCRIPAMT,SP_MAX_SCRIPAMT,SP_TRD_TYPE                      
 FROM                     
  VBB_SETTLEMENT S, TRD_SCHEME_MAPPING M, TRD_SETT_MST SM, TRD_CLIENT1 C1, TRD_CLIENT2 C2                      
 WHERE C1.CL_CODE = C2.CL_CODE                      
 AND C2.PARTY_CODE = S.PARTY_CODE                      
 AND C1.CL_TYPE <> 'INS'                      
 AND SAUDA_DATE BETWEEN SP_DATE_FROM AND SP_DATE_TO                            
 AND S.PARTY_CODE = SP_PARTY_CODE                      
 AND SCRIP_CD LIKE (CASE WHEN SP_SCRIP = 'ALL' THEN '%' ELSE SP_SCRIP END)                      
 AND 1 = (CASE WHEN SP_SCRIP = 'ALL' AND SCRIP_CD NOT IN                             
          (SELECT SP_SCRIP FROM TRD_SCHEME_MAPPING M                      
       WHERE SAUDA_DATE BETWEEN SP_DATE_FROM AND SP_DATE_TO                            
                     AND S.PARTY_CODE = SP_PARTY_CODE)                      
               THEN 1                               
               ELSE (CASE WHEN SP_SCRIP = 'ALL' THEN 0 ELSE 1 END)                      
   END)                      
          AND SP_TRD_TYPE = (CASE WHEN BILLFLAG < 4                       
             THEN 'TRD'                       
                                  ELSE 'DEL'                       
                           END)                      
 AND AUCTIONPART NOT LIKE 'A%' AND AUCTIONPART NOT LIKE 'F%'                      
 AND TRADE_NO NOT LIKE '%C%'                      
 AND S.SETT_NO = SM.SETT_NO                      
 AND S.SETT_TYPE = SM.SETT_TYPE                      
 AND MARKETRATE > 0 AND TRADEQTY > 0                      
 AND SP_BROK_COMPUTETYPE = 'I'                      
    AND SP_VALUE_FROM = (SELECT MIN(SP_VALUE_FROM) FROM                             
        TRD_SCHEME_MAPPING                      
       WHERE SP_SCHEME_ID = M.SP_SCHEME_ID)                      
)                      
SETT_MAPPING                
GROUP BY PARTY_CODE,SETT_NO,SETT_TYPE,SAUDA_DATE,CONTRACTNO,             
(CASE WHEN SP_COMPUTATION_LEVEL = 'T' THEN TRADE_NO ELSE '' END),                            
(CASE WHEN SP_COMPUTATION_LEVEL IN ('T', 'O') THEN ORDER_NO ELSE '' END),                      
(CASE WHEN SP_COMPUTATION_LEVEL <> 'C' THEN SCRIP_CD ELSE '' END),                            
(CASE WHEN SP_COMPUTATION_LEVEL <> 'C' THEN SERIES ELSE '' END),                      
SP_COMPUTATION_LEVEL,SP_BROK_COMPUTEON,SP_BROK_COMPUTETYPE,SP_SCHEME_ID,                      
SP_MIN_BROKAMT,SP_MAX_BROKAMT,SP_MIN_SCRIPAMT,SP_MAX_SCRIPAMT,SP_TRD_TYPE                      
                      
OPEN @SETTCUR                      
FETCH NEXT FROM @SETTCUR INTO                       
 @PARTY_CODE, @SETT_NO, @SETT_TYPE, @SAUDA_DATE, @CONTRACTNO, @TRADE_NO, @ORDER_NO, @SCRIP_CD, @SERIES, @BUYRATE,                       
 @SELLRATE, @TRDBUYQTY, @TRDSELLQTY, @DELBUYQTY, @DELSELLQTY, @TRDBUY_TURNOVER, @TRDSELL_TURNOVER, @DELBUY_TURNOVER,                       
 @DELSELL_TURNOVER, @SP_COMPUTATIONLEVEL, @SP_COMPUTATIONON, @SP_COMPUTATIONTYPE,                       
 @SCHEMEID, @MIN_BROKAMT, @MAX_BROKAMT, @MIN_SCRIPAMT, @MAX_SCRIPAMT, @SP_TRD_TYPE                      
WHILE @@FETCH_STATUS = 0                       
BEGIN                       
                      
  SET @SCHEMECUR = CURSOR FOR                            
  SELECT                            
   SP_COMPUTATION_LEVEL,                            
   SP_MULTIPLIER,                            
   SP_BUY_BROK_TYPE,                            
   SP_SELL_BROK_TYPE,                            
   SP_BUY_BROK,                            
   SP_SELL_BROK,                            
   SP_VALUE_FROM,                       
   SP_VALUE_TO,                            
   SP_SCHEME_TYPE                            
  FROM TRD_SCHEME_MAPPING                            
  WHERE                            
   @SAUDA_DATE BETWEEN SP_DATE_FROM AND SP_DATE_TO                            
   AND SP_PARTY_CODE = @PARTY_CODE                        
   AND SP_TRD_TYPE = @SP_TRD_TYPE                       
          AND SP_SCHEME_ID = @SCHEMEID                      
  ORDER BY SP_VALUE_FROM                      
                      
  OPEN @SCHEMECUR                            
  FETCH NEXT FROM                             
  @SCHEMECUR INTO @SP_COMPUTATION_LEVEL,@SP_MULTIPLIER,@SP_BUY_BROK_TYPE,@SP_SELL_BROK_TYPE,                            
  @SP_BUY_BROK,@SP_SELL_BROK,@SP_VALUE_FROM,@SP_VALUE_TO,@SP_SCHEME_TYPE                            
                       
 IF @SP_TRD_TYPE = 'TRD'                      
 BEGIN                       
 SET @NEWBUYTURNOVER  = @TRDBUY_TURNOVER                         
 SET @NEWSELLTURNOVER    = @TRDSELL_TURNOVER                       
 SET @BUY_TURNOVER = @TRDBUY_TURNOVER                         
 SET @SELL_TURNOVER = @TRDSELL_TURNOVER                      
 SET @NEWBUYTURNOVER_1   = 0                      
 SET @NEWSELLTURNOVER_1   = 0                      
 END                      
 ELSE                      
 BEGIN                      
 SET @NEWBUYTURNOVER     = @DELBUY_TURNOVER                         
 SET @NEWSELLTURNOVER    = @DELSELL_TURNOVER                          
 SET @BUY_TURNOVER = @DELBUY_TURNOVER                         
 SET @SELL_TURNOVER = @DELSELL_TURNOVER                           
 SET @NEWBUYTURNOVER_1   = 0                      
 SET @NEWSELLTURNOVER_1   = 0                      
 END                      
        SET @NEWBUYTURNOVERORG  = 0                         
        SET @NEWSELLTURNOVERORG = 0                         
        SET @BUYBROKERAGE       = 0                         
        SET @SELLBROKERAGE      = 0                            
        SET @BUYBROKERAGE_1    = 0                         
        SET @SELLBROKERAGE_1      = 0                            
                      
 WHILE @@FETCH_STATUS = 0 AND (@NEWBUYTURNOVER > 0 OR @NEWSELLTURNOVER > 0)                         
 BEGIN         
        /*--------------------------------------------------------------------*/                         
        SET @BUYBROKERAGE      = 0                         
        SET @SELLBROKERAGE     = 0                         
        SET @BUYBROKERAGE_1       = 0                         
        SET @SELLBROKERAGE_1      = 0                            
 SET @TRDBUYQTYORG = 0                      
 SET @DELBUYQTYORG = 0                      
 SET @TRDSELLQTYORG = 0                      
 SET @DELSELLQTYORG = 0                      
 IF @NEWBUYTURNOVER > 0                         
 BEGIN                         
 IF @BUY_TURNOVER >= @SP_VALUE_TO AND @SP_VALUE_TO > -1                         
 BEGIN           
         SET @NEWBUYTURNOVER    = (@SP_VALUE_TO - @SP_VALUE_FROM)/@SP_MULTIPLIER                         
         SET @NEWBUYTURNOVERORG = @NEWBUYTURNOVER * @SP_MULTIPLIER                      
  SET @TRDBUYQTYORG = 0                      
  SET @DELBUYQTYORG = 0                      
  SET @NEWBUYTURNOVER_1 = @NEWBUYTURNOVER                      
 END                         
 ELSE                         
 BEGIN                     
  SET @NEWBUYTURNOVER     = @BUY_TURNOVER - @SP_VALUE_FROM                         
  IF @NEWBUYTURNOVER < 0                          
   SET @NEWBUYTURNOVER     = 0                         
  SET @NEWBUYTURNOVERORG  = @NEWBUYTURNOVER                         
  SELECT  @NEWBUYTURNOVER = PRADNYA.DBO.ROUNDEDTURNOVER(@NEWBUYTURNOVER,@SP_MULTIPLIER)                         
  SELECT  @NEWBUYTURNOVER = @NEWBUYTURNOVER / @SP_MULTIPLIER                         
                      
  IF @SP_TRD_TYPE = 'TRD'                       
   SET @NEWBUYTURNOVER_1 = @NEWBUYTURNOVER - 1                        
  ELSE                      
   SET @NEWBUYTURNOVER_1 = @NEWBUYTURNOVER                      
                      
  SELECT  @BUYFLAG        = 1                      
  SET @TRDBUYQTYORG = @TRDBUYQTY                      
  SET @DELBUYQTYORG = @DELBUYQTY                       
 END                         
 IF @NEWBUYTURNOVER    > 0                         
 BEGIN             
  SELECT  @BUYBROKERAGE = CASE WHEN @SP_SCHEME_TYPE = 0                       
          THEN CASE WHEN @SP_BUY_BROK_TYPE ='P'                         
                                  THEN @NEWBUYTURNOVER * @SP_BUY_BROK /100                         
                                         ELSE @NEWBUYTURNOVER * @SP_BUY_BROK              
                                    END                         
                               ELSE                 
                                    CASE WHEN (@NEWBUYTURNOVER >= @NEWSELLTURNOVER AND @SP_SCHEME_TYPE = 1) OR (@NEWBUYTURNOVER   >= @NEWSELLTURNOVER AND @SP_SCHEME_TYPE =3)                         
                                  THEN CASE WHEN @SP_BUY_BROK_TYPE ='P'                       
                                     THEN @NEWBUYTURNOVER * @SP_BUY_BROK /100                       
                                                   ELSE @NEWBUYTURNOVER * @SP_BUY_BROK                       
                                END                         
                                  ELSE                       
                                CASE WHEN @SP_SELL_BROK_TYPE ='P'                         
                                                   THEN @NEWBUYTURNOVER * @SP_SELL_BROK /100                         
                                                          ELSE @NEWBUYTURNOVER * @SP_SELL_BROK                       
                                                     END                         
                                           END                         
                          END                      
  SELECT  @BUYBROKERAGE_1 = CASE WHEN @SP_SCHEME_TYPE = 0                       
          THEN CASE WHEN @SP_BUY_BROK_TYPE ='P'                         
                                  THEN @NEWBUYTURNOVER_1 * @SP_BUY_BROK /100                         
                ELSE @NEWBUYTURNOVER_1 * @SP_BUY_BROK                       
                                    END                         
                               ELSE                         
                                    CASE WHEN (@NEWBUYTURNOVER >= @NEWSELLTURNOVER AND @SP_SCHEME_TYPE = 1) OR (@NEWBUYTURNOVER   >= @NEWSELLTURNOVER AND @SP_SCHEME_TYPE =3)                         
                                  THEN CASE WHEN @SP_BUY_BROK_TYPE ='P'                       
                                     THEN @NEWBUYTURNOVER_1 * @SP_BUY_BROK /100                       
                                   ELSE @NEWBUYTURNOVER_1 * @SP_BUY_BROK                       
                                END                         
                                  ELSE                         
                                CASE WHEN @SP_SELL_BROK_TYPE ='P'                         
                                                   THEN @NEWBUYTURNOVER_1 * @SP_SELL_BROK /100                         
           ELSE @NEWBUYTURNOVER_1 * @SP_SELL_BROK                       
      END                         
                                           END                      
                          END                 
END                         
ELSE                      
BEGIN                          
 SELECT  @BUYBROKERAGE = 0    --SELECT @NEWBUYTURNOVER = 0                          
 SELECT  @BUYBROKERAGE_1 = 0                      
END                      
END                           
IF @NEWSELLTURNOVER     > 0                         
BEGIN                         
 IF @SELL_TURNOVER >= @SP_VALUE_TO AND @SP_VALUE_TO        > -1                         
 BEGIN                         
  SET @NEWSELLTURNOVER    = (@SP_VALUE_TO - @SP_VALUE_FROM)/@SP_MULTIPLIER                         
  SET @NEWSELLTURNOVERORG = @NEWSELLTURNOVER * @SP_MULTIPLIER                       
  SET @TRDSELLQTYORG = 0                      
  SET @DELSELLQTYORG = 0                      
  SET @NEWSELLTURNOVER = @NEWSELLTURNOVER                      
 END                         
 ELSE                         
 BEGIN                         
  SET @NEWSELLTURNOVER     = @SELL_TURNOVER - @SP_VALUE_FROM                         
  IF @NEWSELLTURNOVER < 0                          
   SET @NEWSELLTURNOVER     = 0                         
  SET @NEWSELLTURNOVERORG  = @NEWSELLTURNOVER                         
  SELECT  @NEWSELLTURNOVER = PRADNYA.DBO.ROUNDEDTURNOVER(@NEWSELLTURNOVER,@SP_MULTIPLIER)                         
  SELECT  @NEWSELLTURNOVER = @NEWSELLTURNOVER / @SP_MULTIPLIER                         
  SELECT  @SELLFLAG        = 1                      
  SET @TRDSELLQTYORG = @TRDSELLQTY                      
  SET @DELSELLQTYORG = @DELSELLQTY                          
  IF @SP_TRD_TYPE = 'TRD'                       
   SET @NEWSELLTURNOVER_1 = @NEWSELLTURNOVER - 1                        
  ELSE                      
   SET @NEWSELLTURNOVER = @NEWSELLTURNOVER                      
                       
 END                         
  IF @NEWSELLTURNOVER    > 0                         
  BEGIN                          
   SELECT  @SELLBROKERAGE =                         
          CASE                       
                  WHEN @SP_SCHEME_TYPE = 0                       
                  THEN                         
                  CASE                       
                          WHEN @SP_SELL_BROK_TYPE ='P'                         
                          THEN @NEWSELLTURNOVER * @SP_SELL_BROK /100                         
                          ELSE @NEWSELLTURNOVER * @SP_SELL_BROK                       
                  END                         
                  ELSE                         
                  CASE                       
                          WHEN (@NEWBUYTURNOVER >= @NEWSELLTURNOVER                       
                          AND @SP_SCHEME_TYPE    =1)                         
                          OR (@NEWBUYTURNOVER   >= @NEWSELLTURNOVER                       
                          AND @SP_SCHEME_TYPE    =3)                         
                          THEN          
                          CASE                       
                                  WHEN @SP_SELL_BROK_TYPE ='P'                         
                                  THEN @NEWSELLTURNOVER * @SP_SELL_BROK /100                                                           
          ELSE @NEWSELLTURNOVER * @SP_SELL_BROK                       
                          END                         
                          ELSE                         
                          CASE                       
                                  WHEN @SP_BUY_BROK_TYPE ='P'                         
                                  THEN @NEWSELLTURNOVER * @SP_BUY_BROK /100                         
                                  ELSE @NEWSELLTURNOVER * @SP_BUY_BROK                       
                          END                         
                  END                         
          END                        
                      
   SELECT  @SELLBROKERAGE_1 =                         
          CASE                       
                  WHEN @SP_SCHEME_TYPE = 0                       
                  THEN                         
                  CASE                       
                          WHEN @SP_SELL_BROK_TYPE ='P'                         
                          THEN @NEWSELLTURNOVER_1 * @SP_SELL_BROK /100                         
                          ELSE @NEWSELLTURNOVER_1 * @SP_SELL_BROK                       
                  END                         
                  ELSE                         
                  CASE                       
                          WHEN (@NEWBUYTURNOVER >= @NEWSELLTURNOVER                       
                          AND @SP_SCHEME_TYPE    =1)                         
                          OR (@NEWBUYTURNOVER   >= @NEWSELLTURNOVER                       
                          AND @SP_SCHEME_TYPE    =3)                         
                  THEN                         
                          CASE                       
                      WHEN @SP_SELL_BROK_TYPE ='P'                         
                                  THEN @NEWSELLTURNOVER_1 * @SP_SELL_BROK /100                         
                              ELSE @NEWSELLTURNOVER_1 * @SP_SELL_BROK                       
                          END                         
                          ELSE                         
                          CASE                       
                         WHEN @SP_BUY_BROK_TYPE ='P'                         
                                  THEN @NEWSELLTURNOVER_1 * @SP_BUY_BROK /100                         
                                  ELSE @NEWSELLTURNOVER_1 * @SP_BUY_BROK                       
                          END                         
                 END                         
          END                       
  END                         
 ELSE                         
 BEGIN                      
  SELECT  @SELLBROKERAGE = 0                      
  SELECT  @SELLBROKERAGE_1 = 0                      
 END                       
 END                           
--INSERT INTO TEMP TABLE                      
IF (@NEWBUYTURNOVER > 0 OR @NEWSELLTURNOVER > 0)                      
INSERT INTO VBB_CHARGES_DETAIL_TEMP                      
SELECT @PARTY_CODE, @SETT_NO, @SETT_TYPE, @SAUDA_DATE, @CONTRACTNO, @TRADE_NO, @ORDER_NO, @SCRIP_CD, @SERIES, @BUYRATE,                       
 @SELLRATE, @TRDBUYQTYORG, @TRDSELLQTYORG, @DELBUYQTYORG, @DELSELLQTYORG,                       
 (CASE WHEN @SP_TRD_TYPE = 'TRD' THEN @BUYBROKERAGE ELSE 0 END),                       
 (CASE WHEN @SP_TRD_TYPE = 'TRD' THEN @SELLBROKERAGE ELSE 0 END),                       
 (CASE WHEN @SP_TRD_TYPE = 'DEL' THEN @BUYBROKERAGE ELSE 0 END),                       
 (CASE WHEN @SP_TRD_TYPE = 'DEL' THEN @SELLBROKERAGE ELSE 0 END),                      
 (CASE WHEN @SP_TRD_TYPE = 'TRD' THEN @BUYBROKERAGE_1 ELSE 0 END),                       
 (CASE WHEN @SP_TRD_TYPE = 'TRD' THEN @SELLBROKERAGE_1 ELSE 0 END),                       
 (CASE WHEN @SP_TRD_TYPE = 'DEL' THEN @BUYBROKERAGE_1 ELSE 0 END),                       
 (CASE WHEN @SP_TRD_TYPE = 'DEL' THEN @SELLBROKERAGE_1 ELSE 0 END),                      
  CD_TOTALBROKERAGE = 0,                      
 (CASE WHEN @SP_TRD_TYPE = 'TRD' THEN @NEWBUYTURNOVERORG ELSE 0 END),                       
 (CASE WHEN @SP_TRD_TYPE = 'TRD' THEN @NEWSELLTURNOVERORG ELSE 0 END),                       
 (CASE WHEN @SP_TRD_TYPE = 'DEL' THEN @NEWBUYTURNOVERORG ELSE 0 END),                       
 (CASE WHEN @SP_TRD_TYPE = 'DEL' THEN @NEWSELLTURNOVERORG ELSE 0 END),                      
 (CASE WHEN @SP_TRD_TYPE = 'TRD' THEN @NEWBUYTURNOVER*@SP_MULTIPLIER ELSE 0 END),                       
 (CASE WHEN @SP_TRD_TYPE = 'TRD' THEN @NEWSELLTURNOVER*@SP_MULTIPLIER ELSE 0 END),                       
 @SP_COMPUTATIONLEVEL, @MIN_BROKAMT, @MAX_BROKAMT, @MIN_SCRIPAMT, @MAX_SCRIPAMT                      
                      
IF @SP_VALUE_TO  = -1                         
BEGIN                         
 SELECT  @NEWBUYTURNOVER  = 0                         
 SELECT  @NEWSELLTURNOVER = 0                         
END                         
/*--------------------------------------------------------------------*/                         
FETCH NEXT                       
FROM      @SCHEMECUR                      
INTO    @SP_COMPUTATION_LEVEL,                      
        @SP_MULTIPLIER,                      
        @SP_BUY_BROK_TYPE,                      
 @SP_SELL_BROK_TYPE,                         
        @SP_BUY_BROK,                      
        @SP_SELL_BROK,                      
        @SP_VALUE_FROM,                      
        @SP_VALUE_TO,                      
        @SP_SCHEME_TYPE                         
END                         
CLOSE @SCHEMECUR                         
DEALLOCATE @SCHEMECUR                         
                            
 FETCH NEXT FROM @SETTCUR INTO                       
  @PARTY_CODE, @SETT_NO, @SETT_TYPE, @SAUDA_DATE, @CONTRACTNO, @TRADE_NO, @ORDER_NO, @SCRIP_CD, @SERIES, @BUYRATE,                       
  @SELLRATE, @TRDBUYQTY, @TRDSELLQTY, @DELBUYQTY, @DELSELLQTY, @TRDBUY_TURNOVER, @TRDSELL_TURNOVER, @DELBUY_TURNOVER,                       
  @DELSELL_TURNOVER, @SP_COMPUTATIONLEVEL, @SP_COMPUTATIONON, @SP_COMPUTATIONTYPE,                      
  @SCHEMEID, @MIN_BROKAMT, @MAX_BROKAMT, @MIN_SCRIPAMT, @MAX_SCRIPAMT, @SP_TRD_TYPE                      
END                      
                      
INSERT INTO VBB_CHARGES_DETAIL_TEMP_1                      
SELECT CD_PARTY_CODE,CD_SETT_NO,CD_SETT_TYPE,CD_SAUDA_DATE,CD_CONTRACTNO,CD_TRADE_NO,CD_ORDER_NO,CD_SCRIP_CD,CD_SERIES,                      
BUYRATE = (CASE WHEN SUM(CD_TRDBUY_QTY+CD_DELBUY_QTY) > 0                       
          THEN SUM((CD_TRDBUY_QTY+CD_DELBUY_QTY)*CD_BUYRATE) / SUM(CD_TRDBUY_QTY+CD_DELBUY_QTY)                       
   ELSE 0                      
     END),                      
SELLRATE = (CASE WHEN SUM(CD_TRDSELL_QTY+CD_DELSELL_QTY) > 0                       
          THEN SUM((CD_TRDSELL_QTY+CD_DELSELL_QTY)*CD_SELLRATE) / SUM(CD_TRDSELL_QTY+CD_DELSELL_QTY)                       
   ELSE 0                       
     END),                      
TRDBUY_QTY=SUM(CD_TRDBUY_QTY),                      
TRDSELL_QTY=SUM(CD_TRDSELL_QTY),                      
DELBUY_QTY=SUM(CD_DELBUY_QTY),                      
DELSELL_QTY=SUM(CD_DELSELL_QTY),                      
TRDBUYBROKERAGE=(CASE WHEN SUM(CD_RND_TRDBUY_TURNOVER) >= SUM(CD_TRDBUY_TURNOVER) AND SUM(CD_DELBUY_TURNOVER) > 0                       
        THEN SUM(CD_TRDBUYBROKERAGE)      --SUM(CD_TRDBUYBROKERAGE_1)                       
        ELSE SUM(CD_TRDBUYBROKERAGE)                      
   END),                      
TRDSELLBROKERAGE=(CASE WHEN SUM(CD_RND_TRDSELL_TURNOVER) >= SUM(CD_TRDSELL_TURNOVER) AND SUM(CD_DELSELL_TURNOVER) > 0                       
        THEN SUM(CD_TRDSELLBROKERAGE) -- SUM(CD_TRDSELLBROKERAGE_1)                       
        ELSE SUM(CD_TRDSELLBROKERAGE)                      
   END),                      
DELBUYBROKERAGE=SUM(CD_DELBUYBROKERAGE),                      
DELSELLBROKERAGE=SUM(CD_DELSELLBROKERAGE),                      
CD_TOTALBROKERAGE = 0,                      
TRDBUY_TURNOVER=SUM(CD_TRDBUY_TURNOVER),                      
TRDSELL_TURNOVER=SUM(CD_TRDSELL_TURNOVER),                      
DELBUY_TURNOVER=SUM(CD_DELBUY_TURNOVER),                      
DELSELL_TURNOVER=SUM(CD_DELSELL_TURNOVER),                      
CD_COMPUTATION_LEVEL,                      
CD_MIN_BROKAMT,CD_MAX_BROKAMT,CD_MIN_SCRIPAMT,CD_MAX_SCRIPAMT                      
FROM VBB_CHARGES_DETAIL_TEMP                      
GROUP BY CD_PARTY_CODE,CD_SETT_NO,CD_SETT_TYPE,CD_SAUDA_DATE,                      
CD_CONTRACTNO,CD_TRADE_NO,CD_ORDER_NO,CD_SCRIP_CD,CD_SERIES,                      
CD_COMPUTATION_LEVEL,CD_MIN_BROKAMT,CD_MAX_BROKAMT,CD_MIN_SCRIPAMT,CD_MAX_SCRIPAMT                      
                      
UPDATE VBB_CHARGES_DETAIL_TEMP_1 SET CD_TOTALBROKERAGE = CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE + CD_DELBUYBROKERAGE + CD_DELSELLBROKERAGE                      
                      
INSERT INTO VBB_CHARGES_DETAIL_TEMP_2                      
SELECT CD_PARTY_CODE,CD_SETT_NO,CD_SETT_TYPE,CD_SAUDA_DATE,CD_CONTRACTNO,CD_TRADE_NO,CD_ORDER_NO,CD_SCRIP_CD,                      
CD_SERIES,CD_BUYRATE,CD_SELLRATE,CD_TRDBUY_QTY,CD_TRDSELL_QTY,CD_DELBUY_QTY,CD_DELSELL_QTY,                      
CD_TRDBUYBROKERAGE,CD_TRDSELLBROKERAGE,CD_DELBUYBROKERAGE,CD_DELSELLBROKERAGE,                      
CD_TOTALBROKERAGE = (CASE WHEN (CD_TOTALBROKERAGE) > 0                       
                   THEN (CASE WHEN CD_MAX_BROKAMT = - 1                       
                              THEN (CASE WHEN CD_MIN_BROKAMT <> 0                      
                                  THEN PRADNYA.DBO.FNMAX(CD_MIN_BROKAMT,(CD_TOTALBROKERAGE))                      
                                  ELSE (CD_TOTALBROKERAGE)                     
                      END)                         
                                 ELSE PRADNYA.DBO.FNMIN(CD_MAX_BROKAMT,                      
                     (CASE WHEN CD_MIN_BROKAMT <> 0                      
                                                THEN PRADNYA.DBO.FNMAX(CD_MIN_BROKAMT,(CD_TOTALBROKERAGE))                         
                                                ELSE (CD_TOTALBROKERAGE)                         
                                           END))                      
                  END)                      
                           ELSE 0                      
              END),                      
CD_TRDBUY_TURNOVER,CD_TRDSELL_TURNOVER,CD_DELBUY_TURNOVER,CD_DELSELL_TURNOVER,                   
CD_COMPUTATION_LEVEL,CD_MIN_BROKAMT,CD_MAX_BROKAMT,CD_MIN_SCRIPAMT,CD_MAX_SCRIPAMT                      
FROM VBB_CHARGES_DETAIL_TEMP_1                      
                      
--TRUNCATE TABLE VBB_CHARGES_DETAIL_TEMP_1                      
                      
INSERT INTO VBB_CHARGES_DETAIL_TEMP_1                       
SELECT CD_PARTY_CODE,CD_SETT_NO,CD_SETT_TYPE,CD_SAUDA_DATE,CD_CONTRACTNO,                      
CD_TRADE_NO='',CD_ORDER_NO='',CD_SCRIP_CD,CD_SERIES,                      
BUYRATE = (CASE WHEN SUM(CD_TRDBUY_QTY+CD_DELBUY_QTY) > 0                       
          THEN SUM((CD_TRDBUY_QTY+CD_DELBUY_QTY)*CD_BUYRATE) / SUM(CD_TRDBUY_QTY+CD_DELBUY_QTY)                       
   ELSE 0                      
     END),                      
SELLRATE = (CASE WHEN SUM(CD_TRDSELL_QTY+CD_DELSELL_QTY) > 0                       
          THEN SUM((CD_TRDSELL_QTY+CD_DELSELL_QTY)*CD_SELLRATE) / SUM(CD_TRDSELL_QTY+CD_DELSELL_QTY)                       
   ELSE 0                       
     END),                      
TRDBUY_QTY=SUM(CD_TRDBUY_QTY),                      
TRDSELL_QTY=SUM(CD_TRDSELL_QTY),                      
DELBUY_QTY=SUM(CD_DELBUY_QTY),                      
DELSELL_QTY=SUM(CD_DELSELL_QTY),                      
CD_TRDBUYBROKERAGE=SUM(CD_TRDBUYBROKERAGE),                      
CD_TRDSELLBROKERAGE=SUM(CD_TRDSELLBROKERAGE),                      
CD_DELBUYBROKERAGE=SUM(CD_DELBUYBROKERAGE),                      
CD_DELSELLBROKERAGE=SUM(CD_DELSELLBROKERAGE),                      
CD_TOTALBROKERAGE = (CASE WHEN CD_COMPUTATION_LEVEL IN ('C', 'S')                       
     THEN SUM(CD_TOTALBROKERAGE)                      
     ELSE (CASE WHEN SUM(CD_TOTALBROKERAGE) > 0                       
                       THEN (CASE WHEN CD_MAX_SCRIPAMT = - 1                       
                                  THEN (CASE WHEN CD_MIN_SCRIPAMT <> 0                      
            THEN PRADNYA.DBO.FNMAX(CD_MIN_SCRIPAMT,SUM(CD_TOTALBROKERAGE))                      
                                      ELSE SUM(CD_TOTALBROKERAGE)                         
                          END)                         
                                 ELSE PRADNYA.DBO.FNMIN(CD_MAX_SCRIPAMT,                      
                         (CASE WHEN CD_MIN_BROKAMT <> 0                      
                                                    THEN PRADNYA.DBO.FNMAX(CD_MIN_SCRIPAMT,SUM(CD_TOTALBROKERAGE))                         
                                                    ELSE SUM(CD_TOTALBROKERAGE)                         
                                   END))                      
                      END)                      
                              ELSE 0                      
                  END)                      
       END),                      
CD_TRDBUY_TURNOVER=SUM(CD_TRDBUY_TURNOVER),                      
CD_TRDSELL_TURNOVER=SUM(CD_TRDSELL_TURNOVER),                      
CD_DELBUY_TURNOVER=SUM(CD_DELBUY_TURNOVER),                      
CD_DELSELL_TURNOVER=SUM(CD_DELSELL_TURNOVER),                      
CD_COMPUTATION_LEVEL,CD_MIN_BROKAMT,CD_MAX_BROKAMT,CD_MIN_SCRIPAMT,CD_MAX_SCRIPAMT                      
FROM VBB_CHARGES_DETAIL_TEMP_2 WHERE CD_COMPUTATION_LEVEL NOT IN ('C', 'S')                       
GROUP BY CD_PARTY_CODE,CD_SETT_NO,CD_SETT_TYPE,CD_SAUDA_DATE,CD_CONTRACTNO,CD_SCRIP_CD,CD_SERIES,                      
CD_COMPUTATION_LEVEL,CD_MIN_BROKAMT,CD_MAX_BROKAMT,CD_MIN_SCRIPAMT,CD_MAX_SCRIPAMT                      
HAVING                       
SUM(CD_TOTALBROKERAGE) <> (CASE WHEN CD_COMPUTATION_LEVEL IN ('C', 'S')                       
     THEN SUM(CD_TOTALBROKERAGE)                      
     ELSE (CASE WHEN SUM(CD_TOTALBROKERAGE) > 0                       
                       THEN (CASE WHEN CD_MAX_SCRIPAMT = - 1                       
                                  THEN (CASE WHEN CD_MIN_SCRIPAMT <> 0                      
                                         THEN PRADNYA.DBO.FNMAX(CD_MIN_SCRIPAMT,SUM(CD_TOTALBROKERAGE))                      
                                      ELSE SUM(CD_TOTALBROKERAGE)                         
                          END)                         
                                         ELSE PRADNYA.DBO.FNMIN(CD_MAX_SCRIPAMT,                      
                         (CASE WHEN CD_MIN_BROKAMT <> 0                      
                                                    THEN PRADNYA.DBO.FNMAX(CD_MIN_SCRIPAMT,SUM(CD_TOTALBROKERAGE))                         
                                                    ELSE SUM(CD_TOTALBROKERAGE)                         
                                               END))                      
                      END)                      
                        ELSE 0           
                  END)                      
       END)                      
                      
INSERT INTO VBB_CHARGES_DETAIL_TEMP_1                      
SELECT * FROM VBB_CHARGES_DETAIL_TEMP_2 C2                      
WHERE NOT EXISTS (SELECT CD_PARTY_CODE FROM VBB_CHARGES_DETAIL_TEMP_1 C1                      
WHERE C1.CD_PARTY_CODE = C2.CD_PARTY_CODE                      
AND C1.CD_SETT_NO = C2.CD_SETT_NO                      
AND C1.CD_SETT_TYPE = C2.CD_SETT_TYPE                      
AND C1.CD_SCRIP_CD = C2.CD_SCRIP_CD                      
AND C1.CD_SERIES = C2.CD_SERIES )                      
                      
--TRUNCATE TABLE VBB_CHARGES_DETAIL_TEMP_2                      
                      
INSERT INTO VBB_CHARGES_DETAIL_TEMP_2                      
SELECT S.PARTY_CODE,S.SETT_NO,S.SETT_TYPE,SAUDA_DATE=LEFT(START_DATE,11),                       
  CONTRACTNO, TRADE_NO='',                       
  ORDER_NO='', SCRIP_CD = 'BROKERAGE',                       
  SERIES=(CASE WHEN S.SETT_TYPE = 'W' THEN 'BE' ELSE 'EQ' END),                       
  BUYRATE = (CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END) > 0                       
    THEN SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY*MARKETRATE ELSE 0 END)                       
    / SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END)                      
    ELSE 0                       
      END),                      
  SELLRATE = (CASE WHEN SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END) > 0                       
    THEN SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY*MARKETRATE ELSE 0 END)                       
    / SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END)                      
    ELSE 0                       
      END),                      
  TRDBUY_QTY = SUM(CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2 THEN TRADEQTY ELSE 0 END),                            
  TRDSELL_QTY = SUM(CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3 THEN TRADEQTY ELSE 0 END),                            
  DELBUY_QTY = SUM(CASE WHEN SELL_BUY = 1 AND BILLFLAG = 4 THEN TRADEQTY ELSE 0 END),                            
  DELSELL_QTY = SUM(CASE WHEN SELL_BUY = 2 AND BILLFLAG = 5 THEN TRADEQTY ELSE 0 END),            
  TRDBUY_BROKERAGE = SUM(CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2 THEN TRADEQTY*NBROKAPP ELSE 0 END),                            
  TRDSELL_BROKERAGE = SUM(CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3 THEN TRADEQTY*NBROKAPP ELSE 0 END),                            
  DELBUY_BROKERAGE = SUM(CASE WHEN SELL_BUY = 1 AND BILLFLAG = 4 THEN TRADEQTY*NBROKAPP ELSE 0 END),                            
  DELSELL_BROKERAGE = SUM(CASE WHEN SELL_BUY = 2 AND BILLFLAG = 5 THEN TRADEQTY*NBROKAPP ELSE 0 END),                      
  TOTAL_BROKERAGE = (CASE WHEN SUM(TRADEQTY*NBROKAPP) > 0                       
                   THEN (CASE WHEN CR_MAX_CONTRACTAMT = - 1                       
                         THEN (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                  THEN PRADNYA.DBO.FNMAX(CR_MIN_CONTRACTAMT,SUM(TRADEQTY*NBROKAPP))                      
                           ELSE SUM(TRADEQTY*NBROKAPP)                         
                             END)                         
                              ELSE PRADNYA.DBO.FNMIN(CR_MAX_CONTRACTAMT,                      
              (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                         THEN PRADNYA.DBO.FNMAX(CR_MIN_CONTRACTAMT,SUM(TRADEQTY*NBROKAPP))                         
                                         ELSE SUM(TRADEQTY*NBROKAPP)                        
                                    END))                      
                         END)                      
                   ELSE 0                      
              END),                      
  TRDBUY_TURNOVER = SUM(CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2                       
     THEN TRADEQTY*MARKETRATE                       
     ELSE 0                      
                     END),                            
  TRDSELL_TURNOVER = SUM(CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3                       
     THEN TRADEQTY*MARKETRATE                      
     ELSE 0                      
                     END),                          
  DELBUY_TURNOVER = SUM(CASE WHEN SELL_BUY = 1 AND BILLFLAG = 4                       
     THEN TRADEQTY*MARKETRATE                       
     ELSE 0                      
                     END),                           
  DELSELL_TURNOVER = SUM(CASE WHEN SELL_BUY = 2 AND BILLFLAG = 5                       
     THEN TRADEQTY*MARKETRATE                       
     ELSE 0                      
                     END),                      
CD_COMPUTATION_LEVEL='',CR_MIN_CONTRACTAMT,CR_MAX_CONTRACTAMT,CD_MIN_SCRIPAMT=0,CD_MAX_SCRIPAMT=-1                      
FROM VBB_SETTLEMENT S WITH (NOLOCK), TRD_SETT_MST SM WITH (NOLOCK), TRD_CONTRACT_ROUNDING C WITH (NOLOCK),   
TRD_CLIENT1 C1 WITH (NOLOCK), TRD_CLIENT2 C2 WITH (NOLOCK)                      
WHERE s.Sett_No = @F_SETT_NO and s.Sett_Type = @F_SETT_TYPE 
and S.SETT_NO = SM.SETT_NO                       
AND S.SETT_TYPE = SM.SETT_TYPE                      
AND C1.CL_CODE = C2.PARTY_CODE                      
AND C2.PARTY_CODE = S.PARTY_CODE                      
AND C1.CL_TYPE <> 'INS'                      
AND C1.CL_TYPE <> 'NRI'                    
AND C.CR_PARTY_CODE = S.PARTY_CODE                      
AND AUCTIONPART NOT LIKE 'A%' AND AUCTIONPART NOT LIKE 'F%'                      
AND TRADE_NO NOT LIKE '%C%'                      
AND SAUDA_DATE BETWEEN CR_DATE_FROM AND CR_DATE_TO  + ' 23:59'                    
AND NOT EXISTS (SELECT CD_PARTY_CODE FROM VBB_CHARGES_DETAIL_TEMP_1 C1                      
WHERE C1.CD_SETT_NO = S.SETT_NO                      
AND C1.CD_SETT_TYPE = S.SETT_TYPE
AND C1.CD_PARTY_CODE = S.PARTY_CODE)                      
GROUP BY S.PARTY_CODE,S.SETT_NO,S.SETT_TYPE, CONTRACTNO, LEFT(START_DATE,11), CR_MIN_CONTRACTAMT,CR_MAX_CONTRACTAMT                      
HAVING (CASE WHEN SUM(TRADEQTY*NBROKAPP) > 0                       
THEN (CASE WHEN CR_MAX_CONTRACTAMT = - 1                       
THEN (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
THEN PRADNYA.DBO.FNMAX(CR_MIN_CONTRACTAMT,SUM(TRADEQTY*NBROKAPP))                      
ELSE SUM(TRADEQTY*NBROKAPP)                         
END)                         
ELSE PRADNYA.DBO.FNMIN(CR_MAX_CONTRACTAMT,                      
(CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
THEN PRADNYA.DBO.FNMAX(CR_MIN_CONTRACTAMT,SUM(TRADEQTY*NBROKAPP))                         
ELSE SUM(TRADEQTY*NBROKAPP)                        
END))                      
END)                      
ELSE 0                      
END) < SUM(TRADEQTY*NBROKAPP)                      
                    
                    
INSERT INTO VBB_CHARGES_DETAIL_TEMP_2                      
SELECT S.PARTY_CODE,S.SETT_NO,S.SETT_TYPE,SAUDA_DATE=LEFT(START_DATE,11),                       
  CONTRACTNO, TRADE_NO='',                       
  ORDER_NO='', SCRIP_CD = 'BROKERAGE',                       
  SERIES=(CASE WHEN S.SETT_TYPE = 'W' THEN 'BE' ELSE 'EQ' END),                       
  BUYRATE = (CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END) > 0                       
    THEN SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY*MARKETRATE ELSE 0 END)                       
    / SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END)                      
    ELSE 0                       
      END),                      
  SELLRATE = (CASE WHEN SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END) > 0                       
    THEN SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY*MARKETRATE ELSE 0 END)                       
    / SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END)                      
    ELSE 0                       
      END),                      
  TRDBUY_QTY = SUM(CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2 THEN TRADEQTY ELSE 0 END),                            
  TRDSELL_QTY = SUM(CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3 THEN TRADEQTY ELSE 0 END),                            
  DELBUY_QTY = SUM(CASE WHEN SELL_BUY = 1 AND BILLFLAG = 4 THEN TRADEQTY ELSE 0 END),                            
  DELSELL_QTY = SUM(CASE WHEN SELL_BUY = 2 AND BILLFLAG = 5 THEN TRADEQTY ELSE 0 END),                      
  TRDBUY_BROKERAGE = SUM(CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2 THEN TRADEQTY*NBROKAPP ELSE 0 END),       
  TRDSELL_BROKERAGE = SUM(CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3 THEN TRADEQTY*NBROKAPP ELSE 0 END),                            
  DELBUY_BROKERAGE = SUM(CASE WHEN SELL_BUY = 1 AND BILLFLAG = 4 THEN TRADEQTY*NBROKAPP ELSE 0 END),                            
  DELSELL_BROKERAGE = SUM(CASE WHEN SELL_BUY = 2 AND BILLFLAG = 5 THEN TRADEQTY*NBROKAPP ELSE 0 END),                      
  TOTAL_BROKERAGE = (CASE WHEN SUM(TRADEQTY*NBROKAPP) > 0                       
                   THEN (CASE WHEN CR_MAX_CONTRACTAMT = - 1                       
                         THEN (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                  THEN PRADNYA.DBO.FNMAX(CR_MIN_CONTRACTAMT,SUM(TRADEQTY*NBROKAPP))                      
                           ELSE SUM(TRADEQTY*NBROKAPP)                         
                             END)                         
                              ELSE PRADNYA.DBO.FNMIN(CR_MAX_CONTRACTAMT,                      
              (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                         THEN PRADNYA.DBO.FNMAX(CR_MIN_CONTRACTAMT,SUM(TRADEQTY*NBROKAPP))                         
                                         ELSE SUM(TRADEQTY*NBROKAPP)                        
                                    END))                      
                         END)                      
                   ELSE 0                      
              END),                      
  TRDBUY_TURNOVER = SUM(CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2                       
     THEN TRADEQTY*MARKETRATE                       
     ELSE 0                      
   END),                            
  TRDSELL_TURNOVER = SUM(CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3                       
     THEN TRADEQTY*MARKETRATE                       
     ELSE 0                      
                     END),                           
  DELBUY_TURNOVER = SUM(CASE WHEN SELL_BUY = 1 AND BILLFLAG = 4                    
     THEN TRADEQTY*MARKETRATE                       
     ELSE 0               
                     END),                           
  DELSELL_TURNOVER = SUM(CASE WHEN SELL_BUY = 2 AND BILLFLAG = 5                       
     THEN TRADEQTY*MARKETRATE                       
     ELSE 0                      
                     END),                      
CD_COMPUTATION_LEVEL='',CR_MIN_CONTRACTAMT,CR_MAX_CONTRACTAMT,CD_MIN_SCRIPAMT=0,CD_MAX_SCRIPAMT=-1                      
FROM VBB_SETTLEMENT S (NOLOCK), TRD_SETT_MST SM (NOLOCK), TRD_CONTRACT_ROUNDING C (NOLOCK), TRD_CLIENT1 C1 (NOLOCK), TRD_CLIENT2 C2 (NOLOCK)                      
WHERE s.Sett_No = @F_SETT_NO and s.Sett_Type = @F_SETT_TYPE 
and C1.CL_CODE = C2.CL_CODE                      
AND C2.CL_CODE = S.PARTY_CODE                      
AND C1.CL_TYPE <> 'INS'                      
AND C1.CL_TYPE = 'NRI'                    
AND S.SETT_NO = SM.SETT_NO                       
AND S.SETT_TYPE = SM.SETT_TYPE                      
AND C.CR_PARTY_CODE = S.PARTY_CODE                      
AND AUCTIONPART NOT LIKE 'A%' AND AUCTIONPART NOT LIKE 'F%'                      
AND TRADE_NO NOT LIKE '%C%'                      
AND SAUDA_DATE BETWEEN CR_DATE_FROM AND CR_DATE_TO + ' 23:59'                     
AND NOT EXISTS (SELECT CD_PARTY_CODE FROM VBB_CHARGES_DETAIL_TEMP_1 C1                      
WHERE  C1.CD_SETT_NO = S.SETT_NO                      
AND C1.CD_SETT_TYPE = S.SETT_TYPE 
and C1.CD_PARTY_CODE = S.PARTY_CODE)                      
GROUP BY S.PARTY_CODE,S.SETT_NO,S.SETT_TYPE, CONTRACTNO, LEFT(START_DATE,11), CR_MIN_CONTRACTAMT,CR_MAX_CONTRACTAMT                      
HAVING (CASE WHEN SUM(TRADEQTY*NBROKAPP) > 0                       
                   THEN (CASE WHEN CR_MAX_CONTRACTAMT = - 1                       
                         THEN (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                  THEN PRADNYA.DBO.FNMAX(CR_MIN_CONTRACTAMT,SUM(TRADEQTY*NBROKAPP))                      
                           ELSE SUM(TRADEQTY*NBROKAPP)                         
                             END)                         
                              ELSE PRADNYA.DBO.FNMIN(CR_MAX_CONTRACTAMT,                      
              (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                         THEN PRADNYA.DBO.FNMAX(CR_MIN_CONTRACTAMT,SUM(TRADEQTY*NBROKAPP))                         
                        ELSE SUM(TRADEQTY*NBROKAPP)                        
                                    END))                      
                         END)                      
                   ELSE 0                      
              END) < SUM(TRADEQTY*NBROKAPP)                      
                    
                      
UPDATE SETTLEMENT SET                       
BROKAPPLIED = 0, NETRATE = MARKETRATE,                       
NBROKAPP = 0, N_NETRATE = MARKETRATE,                       
SERVICE_TAX = 0, NSERTAX = 0                       
FROM VBB_CHARGES_DETAIL_TEMP_2(nolock)                      
WHERE VBB_CHARGES_DETAIL_TEMP_2.CD_SETT_NO = SETTLEMENT.SETT_NO                      
AND VBB_CHARGES_DETAIL_TEMP_2.CD_SETT_TYPE = SETTLEMENT.SETT_TYPE                      
AND VBB_CHARGES_DETAIL_TEMP_2.CD_PARTY_CODE = SETTLEMENT.PARTY_CODE                       
AND VBB_CHARGES_DETAIL_TEMP_2.CD_CONTRACTNO = SETTLEMENT.CONTRACTNO                    
                    
UPDATE SETTLEMENT SET                       
BROKAPPLIED = 0, NETRATE = MARKETRATE,                       
NBROKAPP = 0, N_NETRATE = MARKETRATE,                       
SERVICE_TAX = 0, NSERTAX = 0                       
FROM VBB_CHARGES_DETAIL_TEMP_1                       
WHERE VBB_CHARGES_DETAIL_TEMP_1.CD_SETT_NO = SETTLEMENT.SETT_NO                      
AND VBB_CHARGES_DETAIL_TEMP_1.CD_SETT_TYPE = SETTLEMENT.SETT_TYPE                      
AND VBB_CHARGES_DETAIL_TEMP_1.CD_PARTY_CODE = SETTLEMENT.PARTY_CODE                       
AND VBB_CHARGES_DETAIL_TEMP_1.CD_SCRIP_CD = SETTLEMENT.SCRIP_CD                      
AND VBB_CHARGES_DETAIL_TEMP_1.CD_SERIES = SETTLEMENT.SERIES                      
                   
                   
INSERT INTO VBB_CHARGES_DETAIL_TEMP_2                      
SELECT S.PARTY_CODE,S.SETT_NO,S.SETT_TYPE,SAUDA_DATE=LEFT(START_DATE,11),                       
  CONTRACTNO, TRADE_NO='',                       
  ORDER_NO='', SCRIP_CD = 'BROKERAGE',                       
  SERIES=(CASE WHEN S.SETT_TYPE = 'W' THEN 'BE' ELSE 'EQ' END),                       
  BUYRATE = 0,                      
  SELLRATE = 0,                      
  TRDBUY_QTY = 0,                            
  TRDSELL_QTY = 0,                            
  DELBUY_QTY = 0,                            
  DELSELL_QTY = 0,                      
  TRDBUY_BROKERAGE = 0,                            
  TRDSELL_BROKERAGE = 0,                            
  DELBUY_BROKERAGE = 0,                            
  DELSELL_BROKERAGE = 0,                      
  TOTAL_BROKERAGE = (CASE WHEN SUM(TRADEQTY*NBROKAPP) > 0                       
                   THEN (CASE WHEN CR_MAX_CONTRACTAMT = - 1                       
                         THEN (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                              THEN PRADNYA.DBO.FNMAX(PRADNYA.DBO.FNMIN(SUM(TRADEQTY*MARKETRATE)*@SEBI_LIMIT/100,CR_MIN_CONTRACTAMT),SUM(TRADEQTY*NBROKAPP))                      
                           ELSE SUM(TRADEQTY*NBROKAPP)                         
                             END)                         
                              ELSE PRADNYA.DBO.FNMIN(CR_MAX_CONTRACTAMT,                      
              (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                         THEN PRADNYA.DBO.FNMAX(PRADNYA.DBO.FNMIN(SUM(TRADEQTY*MARKETRATE)*@SEBI_LIMIT/100,CR_MIN_CONTRACTAMT),SUM(TRADEQTY*NBROKAPP))                         
                                         ELSE SUM(TRADEQTY*NBROKAPP)                        
                                    END))                      
                         END)                      
                   ELSE 0                      
              END) - SUM(TRADEQTY*NBROKAPP),                      
  TRDBUY_TURNOVER = 0,                            
  TRDSELL_TURNOVER = 0,                           
  DELBUY_TURNOVER = 0,                 
  DELSELL_TURNOVER = 0,                      
CD_COMPUTATION_LEVEL='',CR_MIN_CONTRACTAMT,CR_MAX_CONTRACTAMT,CD_MIN_SCRIPAMT=0,CD_MAX_SCRIPAMT=-1                
FROM VBB_SETTLEMENT S (NOLOCK), TRD_SETT_MST SM (NOLOCK), TRD_CONTRACT_ROUNDING C (NOLOCK), TRD_CLIENT1 C1 (NOLOCK), TRD_CLIENT2 C2(NOLOCK)                      
WHERE s.Sett_No = @F_SETT_NO and s.Sett_Type = @F_SETT_TYPE 
and C1.CL_CODE = C2.CL_CODE                      
AND C2.CL_CODE = S.PARTY_CODE                      
AND C1.CL_TYPE <> 'INS'                      
AND C1.CL_TYPE <> 'NRI'                    
AND S.SETT_NO = SM.SETT_NO                       
AND S.SETT_TYPE = SM.SETT_TYPE                      
AND C.CR_PARTY_CODE = S.PARTY_CODE                      
AND AUCTIONPART NOT LIKE 'A%' AND AUCTIONPART NOT LIKE 'F%'                      
AND TRADE_NO NOT LIKE '%C%'                      
AND SAUDA_DATE BETWEEN CR_DATE_FROM AND CR_DATE_TO                      
AND NOT EXISTS (SELECT CD_PARTY_CODE FROM VBB_CHARGES_DETAIL_TEMP_1 C1                      
WHERE C1.CD_PARTY_CODE = S.PARTY_CODE                      
AND C1.CD_SETT_NO = S.SETT_NO                      
AND C1.CD_SETT_TYPE = S.SETT_TYPE)                      
GROUP BY S.PARTY_CODE,S.SETT_NO,S.SETT_TYPE, S.CONTRACTNO, LEFT(START_DATE,11), CR_MIN_CONTRACTAMT,CR_MAX_CONTRACTAMT                      
HAVING (CASE WHEN SUM(TRADEQTY*NBROKAPP) > 0                       
                   THEN (CASE WHEN CR_MAX_CONTRACTAMT = - 1                       
                         THEN (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                  THEN PRADNYA.DBO.FNMAX(PRADNYA.DBO.FNMIN(SUM(TRADEQTY*MARKETRATE)*@SEBI_LIMIT/100,CR_MIN_CONTRACTAMT),SUM(TRADEQTY*NBROKAPP))                      
                           ELSE SUM(TRADEQTY*NBROKAPP)                         
                             END)                         
                              ELSE PRADNYA.DBO.FNMIN(CR_MAX_CONTRACTAMT,                      
              (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                         THEN PRADNYA.DBO.FNMAX(PRADNYA.DBO.FNMIN(SUM(TRADEQTY*MARKETRATE)*@SEBI_LIMIT/100,CR_MIN_CONTRACTAMT),SUM(TRADEQTY*NBROKAPP))                         
                      ELSE SUM(TRADEQTY*NBROKAPP)                        
                                    END))                      
                         END)                      
                   ELSE 0                      
              END) > SUM(TRADEQTY*NBROKAPP)                      
                    
INSERT INTO VBB_CHARGES_DETAIL_TEMP_2                      
SELECT S.PARTY_CODE,S.SETT_NO,S.SETT_TYPE,SAUDA_DATE=LEFT(START_DATE,11),                       
  CONTRACTNO, TRADE_NO='',                       
  ORDER_NO='', SCRIP_CD = 'BROKERAGE',                       
  SERIES=(CASE WHEN S.SETT_TYPE = 'W' THEN 'BE' ELSE 'EQ' END),                       
  BUYRATE = 0,                      
  SELLRATE = 0,                      
  TRDBUY_QTY = SUM(CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2 THEN TRADEQTY ELSE 0 END),                            
  TRDSELL_QTY = SUM(CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3 THEN TRADEQTY ELSE 0 END),                            
  DELBUY_QTY = SUM(CASE WHEN SELL_BUY = 1 AND BILLFLAG = 4 THEN TRADEQTY ELSE 0 END),                            
  DELSELL_QTY = SUM(CASE WHEN SELL_BUY = 2 AND BILLFLAG = 5 THEN TRADEQTY ELSE 0 END),                      
  TRDBUY_BROKERAGE = 0,                            
  TRDSELL_BROKERAGE = 0,                            
  DELBUY_BROKERAGE = 0,                
  DELSELL_BROKERAGE = 0,                      
  TOTAL_BROKERAGE = (CASE WHEN SUM(TRADEQTY*NBROKAPP) > 0                       
                   THEN (CASE WHEN CR_MAX_CONTRACTAMT = - 1                       
                THEN (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                  THEN PRADNYA.DBO.FNMAX( PRADNYA.DBO.FNMIN(SUM(TRADEQTY*MARKETRATE)*@SEBI_LIMIT/100,CR_MIN_CONTRACTAMT),SUM(TRADEQTY*NBROKAPP))                      
                           ELSE SUM(TRADEQTY*NBROKAPP)                         
                             END)                         
                              ELSE PRADNYA.DBO.FNMIN(CR_MAX_CONTRACTAMT,              
              (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                         THEN PRADNYA.DBO.FNMAX(PRADNYA.DBO.FNMIN(SUM(TRADEQTY*MARKETRATE)*@SEBI_LIMIT/100,CR_MIN_CONTRACTAMT),SUM(TRADEQTY*NBROKAPP))                         
                                         ELSE SUM(TRADEQTY*NBROKAPP)                        
                                    END))                      
                      END)                      
                   ELSE 0                      
              END) - SUM(TRADEQTY*NBROKAPP),                      
  TRDBUY_TURNOVER = 0,                            
  TRDSELL_TURNOVER = 0,                           
  DELBUY_TURNOVER = 0,                           
  DELSELL_TURNOVER = 0,                      
CD_COMPUTATION_LEVEL='',CR_MIN_CONTRACTAMT,CR_MAX_CONTRACTAMT,CD_MIN_SCRIPAMT=0,CD_MAX_SCRIPAMT=-1                      
FROM VBB_SETTLEMENT S(NOLOCK), TRD_SETT_MST SM(NOLOCK), TRD_CONTRACT_ROUNDING C(NOLOCK),   
TRD_CLIENT1 C1(NOLOCK), TRD_CLIENT2 C2(NOLOCK)                      
WHERE s.Sett_No = @F_SETT_NO and s.Sett_Type = @F_SETT_TYPE 
and C1.CL_CODE = C2.CL_CODE                      
AND C2.CL_CODE = S.PARTY_CODE                      
AND C1.CL_TYPE <> 'INS'                      
AND C1.CL_TYPE = 'NRI'                    
AND S.SETT_NO = SM.SETT_NO                       
AND S.SETT_TYPE = SM.SETT_TYPE                      
AND C.CR_PARTY_CODE = S.PARTY_CODE                      
AND AUCTIONPART NOT LIKE 'A%' AND AUCTIONPART NOT LIKE 'F%'                      
AND TRADE_NO NOT LIKE '%C%'                      
AND SAUDA_DATE BETWEEN CR_DATE_FROM AND CR_DATE_TO                      
AND NOT EXISTS (SELECT CD_PARTY_CODE FROM VBB_CHARGES_DETAIL_TEMP_1 C1                      
WHERE C1.CD_PARTY_CODE = S.PARTY_CODE                      
AND C1.CD_SETT_NO = S.SETT_NO                      
AND C1.CD_SETT_TYPE = S.SETT_TYPE)                      
GROUP BY S.PARTY_CODE,S.SETT_NO,S.SETT_TYPE, CONTRACTNO, LEFT(START_DATE,11), CR_MIN_CONTRACTAMT,CR_MAX_CONTRACTAMT                      
HAVING (CASE WHEN SUM(TRADEQTY*NBROKAPP) > 0                       
                   THEN (CASE WHEN CR_MAX_CONTRACTAMT = - 1                       
                         THEN (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                  THEN PRADNYA.DBO.FNMAX( PRADNYA.DBO.FNMIN(SUM(TRADEQTY*MARKETRATE)*@SEBI_LIMIT/100,CR_MIN_CONTRACTAMT) ,SUM(TRADEQTY*NBROKAPP))                      
                           ELSE SUM(TRADEQTY*NBROKAPP)                         
                             END)                         
                              ELSE PRADNYA.DBO.FNMIN(CR_MAX_CONTRACTAMT,                      
              (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                         THEN PRADNYA.DBO.FNMAX(PRADNYA.DBO.FNMIN(SUM(TRADEQTY*MARKETRATE)*@SEBI_LIMIT/100,CR_MIN_CONTRACTAMT),SUM(TRADEQTY*NBROKAPP))                         
                                         ELSE SUM(TRADEQTY*NBROKAPP)                        
                                    END))                      
                         END)                
                   ELSE 0                      
              END) > SUM(TRADEQTY*NBROKAPP)                      
                      
INSERT INTO VBB_CHARGES_DETAIL_TEMP_2                       
SELECT CD_PARTY_CODE,CD_SETT_NO,CD_SETT_TYPE,CD_SAUDA_DATE,CD_CONTRACTNO,                      
CD_TRADE_NO='',CD_ORDER_NO='',CD_SCRIP_CD='BROKERAGE',CD_SERIES=(CASE WHEN CD_SETT_TYPE = 'W' THEN 'BE' ELSE 'EQ' END),                   
BUYRATE = (CASE WHEN SUM(CD_TRDBUY_QTY+CD_DELBUY_QTY) > 0                       
          THEN SUM((CD_TRDBUY_QTY+CD_DELBUY_QTY)*CD_BUYRATE) / SUM(CD_TRDBUY_QTY+CD_DELBUY_QTY)                       
   ELSE 0                      
     END),                      
SELLRATE = (CASE WHEN SUM(CD_TRDSELL_QTY+CD_DELSELL_QTY) > 0                       
          THEN SUM((CD_TRDSELL_QTY+CD_DELSELL_QTY)*CD_SELLRATE) / SUM(CD_TRDSELL_QTY+CD_DELSELL_QTY)                       
   ELSE 0                       
     END),                      
TRDBUY_QTY=SUM(CD_TRDBUY_QTY),                      
TRDSELL_QTY=SUM(CD_TRDSELL_QTY),                      
DELBUY_QTY=SUM(CD_DELBUY_QTY),         
DELSELL_QTY=SUM(CD_DELSELL_QTY),                      
CD_TRDBUYBROKERAGE=SUM(CD_TRDBUYBROKERAGE),                      
CD_TRDSELLBROKERAGE=SUM(CD_TRDSELLBROKERAGE),                      
CD_DELBUYBROKERAGE=SUM(CD_DELBUYBROKERAGE),                      
CD_DELSELLBROKERAGE=SUM(CD_DELSELLBROKERAGE),                      
CD_TOTALBROKERAGE = (CASE WHEN SUM(CD_TOTALBROKERAGE) > 0                       
                   THEN (CASE WHEN CR_MAX_CONTRACTAMT = - 1                       
                         THEN (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                  THEN PRADNYA.DBO.FNMAX(CR_MIN_CONTRACTAMT,SUM(CD_TOTALBROKERAGE))                      
                           ELSE SUM(CD_TOTALBROKERAGE)                         
                             END)                         
                              ELSE PRADNYA.DBO.FNMIN(CR_MAX_CONTRACTAMT,                      
              (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                         THEN PRADNYA.DBO.FNMAX(CR_MIN_CONTRACTAMT,SUM(CD_TOTALBROKERAGE))                         
                                         ELSE SUM(CD_TOTALBROKERAGE)                        
                                    END))                      
                         END)               
                   ELSE 0                      
              END),                      
CD_TRDBUY_TURNOVER=SUM(CD_TRDBUY_TURNOVER),                      
CD_TRDSELL_TURNOVER=SUM(CD_TRDSELL_TURNOVER),                      
CD_DELBUY_TURNOVER=SUM(CD_DELBUY_TURNOVER),                      
CD_DELSELL_TURNOVER=SUM(CD_DELSELL_TURNOVER),                      
CD_COMPUTATION_LEVEL,CD_MIN_BROKAMT,CD_MAX_BROKAMT,CD_MIN_SCRIPAMT,CD_MAX_SCRIPAMT                      
FROM VBB_CHARGES_DETAIL_TEMP_1, TRD_CONTRACT_ROUNDING        
WHERE CD_PARTY_CODE = CR_PARTY_CODE                      
AND CD_SAUDA_DATE BETWEEN CR_DATE_FROM AND CR_DATE_TO                      
GROUP BY CD_PARTY_CODE,CD_SETT_NO,CD_SETT_TYPE,CD_SAUDA_DATE,CD_CONTRACTNO,                      
CD_COMPUTATION_LEVEL,CD_MIN_BROKAMT,CD_MAX_BROKAMT,CD_MIN_SCRIPAMT,CD_MAX_SCRIPAMT,CR_MIN_CONTRACTAMT, CR_MAX_CONTRACTAMT                      
HAVING (CASE WHEN SUM(CD_TOTALBROKERAGE) > 0                       
                   THEN (CASE WHEN CR_MAX_CONTRACTAMT = - 1                       
                         THEN (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                  THEN PRADNYA.DBO.FNMAX(CR_MIN_CONTRACTAMT,SUM(CD_TOTALBROKERAGE))                      
                           ELSE SUM(CD_TOTALBROKERAGE)                         
                             END)                         
                              ELSE PRADNYA.DBO.FNMIN(CR_MAX_CONTRACTAMT,                      
              (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
         THEN PRADNYA.DBO.FNMAX(CR_MIN_CONTRACTAMT,SUM(CD_TOTALBROKERAGE))                         
                                         ELSE SUM(CD_TOTALBROKERAGE)                        
                                    END))                      
                         END)                      
                   ELSE 0                      
              END) < SUM(CD_TOTALBROKERAGE)                      
                      
DELETE FROM VBB_CHARGES_DETAIL_TEMP_1                       
WHERE EXISTS (SELECT CD_PARTY_CODE FROM VBB_CHARGES_DETAIL_TEMP_2                      
WHERE VBB_CHARGES_DETAIL_TEMP_1.CD_SETT_NO = VBB_CHARGES_DETAIL_TEMP_2.CD_SETT_NO                      
AND VBB_CHARGES_DETAIL_TEMP_1.CD_SETT_TYPE = VBB_CHARGES_DETAIL_TEMP_2.CD_SETT_TYPE 
and VBB_CHARGES_DETAIL_TEMP_1.CD_PARTY_CODE = VBB_CHARGES_DETAIL_TEMP_2.CD_PARTY_CODE                      )                      
                      
INSERT INTO VBB_CHARGES_DETAIL_TEMP_2                       
SELECT CD_PARTY_CODE,CD_SETT_NO,CD_SETT_TYPE,CD_SAUDA_DATE,CD_CONTRACTNO,                      
CD_TRADE_NO='',CD_ORDER_NO='',CD_SCRIP_CD='BROKERAGE',CD_SERIES=(CASE WHEN CD_SETT_TYPE = 'W' THEN 'BE' ELSE 'EQ' END),                      
BUYRATE = 0,                      
SELLRATE = 0,                      
TRDBUY_QTY=SUM(CD_TRDBUY_QTY),                      
TRDSELL_QTY=SUM(CD_TRDSELL_QTY),                      
DELBUY_QTY=SUM(CD_DELBUY_QTY),                      
DELSELL_QTY=SUM(CD_DELSELL_QTY),                      
CD_TRDBUYBROKERAGE=SUM(CD_TRDBUYBROKERAGE),                      
CD_TRDSELLBROKERAGE=SUM(CD_TRDSELLBROKERAGE),                      
CD_DELBUYBROKERAGE=SUM(CD_DELBUYBROKERAGE),                      
CD_DELSELLBROKERAGE=SUM(CD_DELSELLBROKERAGE),                      
CD_TOTALBROKERAGE = (CASE WHEN SUM(CD_TOTALBROKERAGE) > 0                       
               THEN (CASE WHEN CR_MAX_CONTRACTAMT = - 1                       
                         THEN (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                  THEN PRADNYA.DBO.FNMAX(PRADNYA.DBO.FNMIN((SUM(CD_TRDBUY_TURNOVER+CD_TRDSELL_TURNOVER+CD_DELBUY_TURNOVER+CD_DELSELL_TURNOVER)*@SEBI_LIMIT/100),CR_MIN_CONTRACTAMT)                
          ,SUM(CD_TOTALBROKERAGE))                      
                           ELSE SUM(CD_TOTALBROKERAGE)                         
                             END)                         
                              ELSE PRADNYA.DBO.FNMIN(CR_MAX_CONTRACTAMT,                      
              (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                         THEN PRADNYA.DBO.FNMAX(PRADNYA.DBO.FNMIN((SUM(CD_TRDBUY_TURNOVER+CD_TRDSELL_TURNOVER+CD_DELBUY_TURNOVER+CD_DELSELL_TURNOVER)*@SEBI_LIMIT/100),CR_MIN_CONTRACTAMT),                
          SUM(CD_TOTALBROKERAGE))                         
      ELSE SUM(CD_TOTALBROKERAGE)                        
                                    END))                      
                         END)                      
                   ELSE 0                                  END) - SUM(CD_TOTALBROKERAGE),                      
CD_TRDBUY_TURNOVER=0,                      
CD_TRDSELL_TURNOVER=0,                      
CD_DELBUY_TURNOVER=0,                      
CD_DELSELL_TURNOVER=0,                      
CD_COMPUTATION_LEVEL,CD_MIN_BROKAMT,CD_MAX_BROKAMT,CD_MIN_SCRIPAMT,CD_MAX_SCRIPAMT                      
FROM VBB_CHARGES_DETAIL_TEMP_1, TRD_CONTRACT_ROUNDING                      
WHERE CD_PARTY_CODE = CR_PARTY_CODE                      
AND CD_SAUDA_DATE BETWEEN CR_DATE_FROM AND CR_DATE_TO                      
GROUP BY CD_PARTY_CODE,CD_SETT_NO,CD_SETT_TYPE,CD_SAUDA_DATE,CD_CONTRACTNO,                      
CD_COMPUTATION_LEVEL,CD_MIN_BROKAMT,CD_MAX_BROKAMT,CD_MIN_SCRIPAMT,CD_MAX_SCRIPAMT, CR_MIN_CONTRACTAMT, CR_MAX_CONTRACTAMT                      
HAVING (CASE WHEN SUM(CD_TOTALBROKERAGE) > 0                       
                   THEN (CASE WHEN CR_MAX_CONTRACTAMT = - 1                       
                         THEN (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                  THEN PRADNYA.DBO.FNMAX(PRADNYA.DBO.FNMIN((SUM(CD_TRDBUY_TURNOVER+CD_TRDSELL_TURNOVER+CD_DELBUY_TURNOVER+CD_DELSELL_TURNOVER)*@SEBI_LIMIT/100),CR_MIN_CONTRACTAMT),                
         SUM(CD_TOTALBROKERAGE))                      
                           ELSE SUM(CD_TOTALBROKERAGE)                                                      END)                         
                              ELSE PRADNYA.DBO.FNMIN(CR_MAX_CONTRACTAMT,                      
              (CASE WHEN CR_MIN_CONTRACTAMT <> 0                      
                                       THEN PRADNYA.DBO.FNMAX(PRADNYA.DBO.FNMIN((SUM(CD_TRDBUY_TURNOVER+CD_TRDSELL_TURNOVER+CD_DELBUY_TURNOVER+CD_DELSELL_TURNOVER)*@SEBI_LIMIT/100),CR_MIN_CONTRACTAMT),                
          SUM(CD_TOTALBROKERAGE))                         
                                         ELSE SUM(CD_TOTALBROKERAGE)                        
                                    END))                      
                         END)                      
                   ELSE 0                      
              END) > SUM(CD_TOTALBROKERAGE)                      
                
                      
INSERT INTO VBB_CHARGES_DETAIL_TEMP_2                      
SELECT * FROM VBB_CHARGES_DETAIL_TEMP_1                      
                      
UPDATE VBB_CHARGES_DETAIL_TEMP_2                       
SET CD_TRDBUYBROKERAGE = 0, CD_TRDSELLBROKERAGE = 0, CD_DELBUYBROKERAGE = 0, CD_DELSELLBROKERAGE = 0                      
WHERE CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE + CD_DELBUYBROKERAGE + CD_DELSELLBROKERAGE <> CD_TOTALBROKERAGE                      
                      
UPDATE VBB_CHARGES_DETAIL_TEMP_2                       
SET CD_TRDBUYBROKERAGE = (CASE WHEN (CD_TRDBUY_QTY + CD_DELBUY_QTY) >= (CD_TRDSELL_QTY + CD_DELSELL_QTY)                      
          THEN (CASE WHEN CD_TRDBUY_QTY > CD_DELBUY_QTY                       
       THEN CD_TOTALBROKERAGE                      
       ELSE CD_TRDBUYBROKERAGE                      
         END)                      
                      
          ELSE CD_TRDBUYBROKERAGE                      
     END),                   
   CD_TRDSELLBROKERAGE = (CASE WHEN (CD_TRDBUY_QTY + CD_DELBUY_QTY) < (CD_TRDSELL_QTY + CD_DELSELL_QTY)                      
          THEN (CASE WHEN CD_TRDSELL_QTY > CD_DELSELL_QTY                       
       THEN CD_TOTALBROKERAGE                      
       ELSE CD_TRDSELLBROKERAGE                      
         END)                      
          ELSE CD_TRDSELLBROKERAGE                      
     END),                            
    CD_DELBUYBROKERAGE = (CASE WHEN (CD_TRDBUY_QTY + CD_DELBUY_QTY) >= (CD_TRDSELL_QTY + CD_DELSELL_QTY)                      
          THEN (CASE WHEN CD_TRDBUY_QTY > CD_DELBUY_QTY                       
       THEN CD_DELBUYBROKERAGE                      
       ELSE CD_TOTALBROKERAGE                      
         END)                      
          ELSE CD_TRDBUYBROKERAGE                      
     END),                      
   CD_DELSELLBROKERAGE = (CASE WHEN (CD_TRDBUY_QTY + CD_DELBUY_QTY) < (CD_TRDSELL_QTY + CD_DELSELL_QTY)                      
          THEN (CASE WHEN CD_TRDSELL_QTY > CD_DELSELL_QTY                       
       THEN CD_DELSELLBROKERAGE                      
       ELSE CD_TOTALBROKERAGE                      
         END)                      
          ELSE CD_TRDSELLBROKERAGE                      
     END),                      
   CD_TRDBUY_QTY = (CASE WHEN CD_BUYRATE = 0 THEN 0 ELSE CD_TRDBUY_QTY END),                        
   CD_TRDSELL_QTY = (CASE WHEN CD_SELLRATE = 0 THEN 0 ELSE CD_TRDSELL_QTY END),                        
   CD_DELBUY_QTY = (CASE WHEN CD_BUYRATE = 0 THEN 0 ELSE CD_DELBUY_QTY END),                        
   CD_DELSELL_QTY = (CASE WHEN CD_SELLRATE = 0 THEN 0 ELSE CD_DELSELL_QTY END)                      
WHERE CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE + CD_DELBUYBROKERAGE + CD_DELSELLBROKERAGE <> CD_TOTALBROKERAGE                      
                      
DELETE FROM CHARGES_DETAIL                       
WHERE CD_SETT_NO = @F_SETT_NO                      
AND CD_SETT_TYPE = @F_SETT_TYPE                      
AND CD_PARTY_CODE BETWEEN @FROM_PARTY AND @TO_PARTY                      
                    
UPDATE VBB_CHARGES_DETAIL_TEMP_2 SET                     
CD_SCRIP_CD='BROKERAGE',                    
CD_SERIES=(CASE WHEN CD_SETT_TYPE = 'W' THEN 'BE' ELSE 'EQ' END)                    
WHERE CD_SCRIP_CD = ''                    
                      
INSERT INTO CHARGES_DETAIL                      
SELECT CD_PARTY_CODE,CD_SETT_NO,CD_SETT_TYPE,CD_SAUDA_DATE,CD_CONTRACTNO,CD_TRADE_NO,CD_ORDER_NO,                      
CD_SCRIP_CD,CD_SERIES,CD_BUYRATE,CD_SELLRATE,CD_TRDBUY_QTY,CD_TRDSELL_QTY,CD_DELBUY_QTY,CD_DELSELL_QTY,                      
CD_TRDBUYBROKERAGE,CD_TRDSELLBROKERAGE,CD_DELBUYBROKERAGE,CD_DELSELLBROKERAGE,CD_TOTALBROKERAGE,                      
CD_TRDBUYSERTAX=CD_TRDBUYBROKERAGE*SERVICE_TAX/100,                      
CD_TRDSELLSERTAX=CD_TRDSELLBROKERAGE*SERVICE_TAX/100,                      
CD_DELBUYSERTAX=CD_DELBUYBROKERAGE*SERVICE_TAX/100,                      
CD_DELSELLSERTAX=CD_DELSELLBROKERAGE*SERVICE_TAX/100,                      
CD_TOTALSERTAX=CD_TOTALBROKERAGE*SERVICE_TAX/100,                      
CD_TRDBUY_TURNOVER,CD_TRDSELL_TURNOVER,CD_DELBUY_TURNOVER,CD_DELSELL_TURNOVER,CD_COMPUTATION_LEVEL,                      
CD_MIN_BROKAMT,CD_MAX_BROKAMT,CD_MIN_SCRIPAMT,CD_MAX_SCRIPAMT,CD_TIMESTAMP=GETDATE()                      
FROM VBB_CHARGES_DETAIL_TEMP_2, GLOBALS                      
WHERE CD_SAUDA_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT              
            
            
IF (CONVERT(DATETIME,@Sauda_Date_FROM) < 'OCT  1 2014')
BEGIN  
UPDATE CHARGES_DETAIL            
SET             
CD_TRDBUYSERTAX=0,            
CD_TRDSELLSERTAX=0,            
CD_DELBUYSERTAX=0,            
CD_DELSELLSERTAX=0,            
CD_TOTALSERTAX=0            
FROM                       
 TRD_CLIENT2 C2 (NOLOCK), TRD_CLIENT1 C1 (NOLOCK)                        
WHERE                          
 C1.CL_CODE = C2.CL_CODE                        
AND  CD_SETT_NO = @F_SETT_NO                    
AND CD_SETT_TYPE = @F_SETT_TYPE                    
AND CD_PARTY_CODE BETWEEN @FROM_PARTY AND @TO_PARTY                         
 AND C2.PARTY_CODE=CD_PARTY_CODE                         
 AND L_STATE =  'JAMMU AND KASHMIR'            
 AND C2.SERVICE_CHRG=0
 END

GO
