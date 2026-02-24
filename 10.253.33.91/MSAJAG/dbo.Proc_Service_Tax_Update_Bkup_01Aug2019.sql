-- Object: PROCEDURE dbo.Proc_Service_Tax_Update_Bkup_01Aug2019
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


--exec  PROC_SERVICE_TAX_UPDATE 'n','sep 23 2014','bksbin0000','bksbin0000'  
CREATE PROC [dbo].[Proc_Service_Tax_Update_Bkup_01Aug2019]          
(              
 @SETT_TYPE VARCHAR(2),               
 @SAUDA_DATE VARCHAR(11),               
 @FROMPARTY VARCHAR(10),               
 @TOPARTY VARCHAR(10)              
)               
AS           
        
------------------------------2.5 BROK ON MARKETRATE 0.25P ON 10---------------             
       
 IF CONVERT(DATETIME,@SAUDA_DATE) >= CONVERT(DATETIME,'OCT 10 2013')       
 BEGIN              
     
    
SELECT DISTINCT PARTY_CODE, SAUDA_DATE = CONVERT(DATETIME,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11))               
INTO #SETTSER              
FROM SETTLEMENT              
WHERE SETT_TYPE = @SETT_TYPE AND SAUDA_DATE LIKE @SAUDA_DATE + '%'    
AND TRADEQTY > 0     
    
INSERT INTO #SETTSER              
SELECT DISTINCT PARTY_CODE, SAUDA_DATE = CONVERT(DATETIME,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11))               
FROM ISETTLEMENT              
WHERE SETT_TYPE = @SETT_TYPE AND SAUDA_DATE LIKE @SAUDA_DATE + '%'    
AND TRADEQTY > 0     
    
TRUNCATE TABLE TRD_CLIENT2        
INSERT INTO TRD_CLIENT2        
SELECT CL_CODE,EXCHANGE,TRAN_CAT,SCRIP_CAT,PARTY_CODE,TABLE_NO,SUB_TABLENO,MARGIN,TURNOVER_TAX,        
SEBI_TURN_TAX,INSURANCE_CHRG,SERVICE_CHRG,STD_RATE,P_TO_P,EXPOSURE_LIM,DEMAT_TABLENO,BANKID,        
CLTDPNO,PRINTF,ALBMDELCHRG,ALBMDELIVERY,ALBMCF_TABLENO,MF_TABLENO,SB_TABLENO,BROK1_TABLENO,        
BROK2_TABLENO,BROK3_TABLENO,BROKERNOTE,OTHER_CHRG,BROK_SCHEME,CONTCHARGE,MINCONTAMT,ADDLEDGERBAL,        
DUMMY1,DUMMY2,INSCONT,SERTAXMETHOD,DUMMY6,DUMMY7,DUMMY8,DUMMY9,DUMMY10        
FROM CLIENT2        
WHERE EXISTS (SELECT PARTY_CODE FROM #SETTSER WHERE #SETTSER.PARTY_CODE = CLIENT2.PARTY_CODE)   
  
     
UPDATE SETTLEMENT SET       
NBROKAPP = (CASE WHEN MARKETRATE >= 10       
     THEN (CASE WHEN ROUND((MARKETRATE*2.5/100),2) > (MARKETRATE*2.5/100)       
          THEN ROUND((MARKETRATE*2.5/100),2)-0.01       
       ELSE ROUND((MARKETRATE*2.5/100),2)       
        END)      
     ELSE .25      
   END),      
BROKAPPLIED = (CASE WHEN MARKETRATE >= 10       
     THEN (CASE WHEN ROUND((MARKETRATE*2.5/100),2) > (MARKETRATE*2.5/100)       
          THEN ROUND((MARKETRATE*2.5/100),2)-0.01       
       ELSE ROUND((MARKETRATE*2.5/100),2)       
        END)      
     ELSE .25      
   END),      
NETRATE = (CASE WHEN SELL_BUY = 1       
    THEN MARKETRATE +      
    (CASE WHEN MARKETRATE >= 10       
       THEN (CASE WHEN ROUND((MARKETRATE*2.5/100),2) > (MARKETRATE*2.5/100)       
               THEN ROUND((MARKETRATE*2.5/100),2)-0.01       
            ELSE ROUND((MARKETRATE*2.5/100),2)       
             END)      
          ELSE .25      
        END)      
           ELSE MARKETRATE -      
    (CASE WHEN MARKETRATE >= 10       
       THEN (CASE WHEN ROUND((MARKETRATE*2.5/100),2) > (MARKETRATE*2.5/100)       
               THEN ROUND((MARKETRATE*2.5/100),2)-0.01       
            ELSE ROUND((MARKETRATE*2.5/100),2)       
             END)      
          ELSE .25      
        END)      
     END),      
N_NETRATE = (CASE WHEN SELL_BUY = 1       
    THEN MARKETRATE +      
    (CASE WHEN MARKETRATE >= 10       
       THEN (CASE WHEN ROUND((MARKETRATE*2.5/100),2) > (MARKETRATE*2.5/100)       
               THEN ROUND((MARKETRATE*2.5/100),2)-0.01       
            ELSE ROUND((MARKETRATE*2.5/100),2)       
             END)      
          ELSE .25      
        END)      
           ELSE MARKETRATE -      
    (CASE WHEN MARKETRATE >= 10       
       THEN (CASE WHEN ROUND((MARKETRATE*2.5/100),2) > (MARKETRATE*2.5/100)       
               THEN ROUND((MARKETRATE*2.5/100),2)-0.01       
            ELSE ROUND((MARKETRATE*2.5/100),2)       
             END)      
          ELSE .25      
        END)      
     END)      
WHERE SETT_TYPE = @SETT_TYPE       
AND SAUDA_DATE LIKE @SAUDA_DATE + '%'       
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY       
AND TRADEQTY > 0 AND MARKETRATE > 0       
AND (NBROKAPP) > (CASE WHEN MARKETRATE >= 10 THEN (MARKETRATE*2.5/100) ELSE .25 END)      
END      
------------------------------------------------------------------------------------------------    
       
        
UPDATE SETTLEMENT SET           
SERVICE_TAX = (CASE WHEN SERVICE_CHRG = 1 AND SERTAXMETHOD = 1           
        THEN 0 ELSE ((TRADEQTY*BROKAPPLIED)+          
       (CASE WHEN TURNOVER_AC = 1 AND TURNOVER_TAX = 1           
      THEN TURN_TAX          
             ELSE 0           
        END)+          
       (CASE WHEN SEBI_TURN_AC = 1 AND SEBI_TURN_TAX = 1           
      THEN SEBI_TAX          
             ELSE 0           
        END)+          
       (CASE WHEN BROKER_NOTE_AC = 1 AND BROKERNOTE = 1           
      THEN BROKER_CHRG          
             ELSE 0           
        END)+          
       (CASE WHEN OTHER_CHRG_AC = 1 AND C2.OTHER_CHRG = 1          
      THEN SETTLEMENT.OTHER_CHRG          
             ELSE 0           
        END)+          
       (CASE WHEN STT_TAX_AC = 1 AND C2.INSURANCE_CHRG = 1          
      THEN SETTLEMENT.OTHER_CHRG          
             ELSE 0           
        END)) * G.SERVICE_TAX/100 END),          
NSERTAX    = (CASE WHEN SERVICE_CHRG = 1 AND SERTAXMETHOD = 1           
        THEN 0 ELSE ((TRADEQTY*NBROKAPP)+          
       (CASE WHEN TURNOVER_AC = 1 AND TURNOVER_TAX = 1           
      THEN TURN_TAX          
             ELSE 0           
        END)+          
       (CASE WHEN SEBI_TURN_AC = 1 AND SEBI_TURN_TAX = 1           
      THEN SEBI_TAX          
             ELSE 0           
        END)+          
       (CASE WHEN BROKER_NOTE_AC = 1 AND BROKERNOTE = 1           
      THEN BROKER_CHRG          
             ELSE 0           
        END)+          
       (CASE WHEN OTHER_CHRG_AC = 1 AND C2.OTHER_CHRG = 1          
      THEN SETTLEMENT.OTHER_CHRG          
             ELSE 0           
        END)+          
       (CASE WHEN STT_TAX_AC = 1 AND C2.INSURANCE_CHRG = 1          
      THEN SETTLEMENT.OTHER_CHRG          
             ELSE 0           
        END)) * G.SERVICE_TAX/100 END)         
FROM GLOBALS G, TRD_CLIENT2 C2          
WHERE SETT_TYPE = @SETT_TYPE          
AND SAUDA_DATE LIKE @SAUDA_DATE + '%'          
AND SETTLEMENT.PARTY_CODE = C2.PARTY_CODE          
AND C2.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY          
AND AUCTIONPART NOT LIKE 'A%'                 
AND SAUDA_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT          
          
UPDATE ISETTLEMENT SET           
SERVICE_TAX = (CASE WHEN SERVICE_CHRG = 1 AND SERTAXMETHOD = 1           
        THEN 0 ELSE ((TRADEQTY*BROKAPPLIED)+          
       (CASE WHEN TURNOVER_AC = 1 AND TURNOVER_TAX = 1           
      THEN TURN_TAX          
             ELSE 0           
        END)+          
       (CASE WHEN SEBI_TURN_AC = 1 AND SEBI_TURN_TAX = 1           
      THEN SEBI_TAX          
             ELSE 0           
        END)+          
       (CASE WHEN BROKER_NOTE_AC = 1 AND BROKERNOTE = 1           
      THEN BROKER_CHRG          
             ELSE 0           
        END)+          
       (CASE WHEN OTHER_CHRG_AC = 1 AND C2.OTHER_CHRG = 1          
      THEN ISETTLEMENT.OTHER_CHRG          
             ELSE 0           
        END)+          
       (CASE WHEN STT_TAX_AC = 1 AND C2.INSURANCE_CHRG = 1          
      THEN ISETTLEMENT.OTHER_CHRG          
             ELSE 0           
        END)) * G.SERVICE_TAX/100 END),          
NSERTAX    = (CASE WHEN SERVICE_CHRG = 1 AND SERTAXMETHOD = 1           
        THEN 0 ELSE ((TRADEQTY*NBROKAPP)+          
       (CASE WHEN TURNOVER_AC = 1 AND TURNOVER_TAX = 1           
      THEN TURN_TAX          
             ELSE 0           
        END)+          
       (CASE WHEN SEBI_TURN_AC = 1 AND SEBI_TURN_TAX = 1           
      THEN SEBI_TAX          
             ELSE 0           
        END)+          
       (CASE WHEN BROKER_NOTE_AC = 1 AND BROKERNOTE = 1           
      THEN BROKER_CHRG          
             ELSE 0           
        END)+          
       (CASE WHEN OTHER_CHRG_AC = 1 AND C2.OTHER_CHRG = 1          
      THEN ISETTLEMENT.OTHER_CHRG        
             ELSE 0           
        END)+          
       (CASE WHEN STT_TAX_AC = 1 AND C2.INSURANCE_CHRG = 1          
      THEN ISETTLEMENT.OTHER_CHRG          
             ELSE 0           
        END)) * G.SERVICE_TAX/100 END)         
FROM GLOBALS G, TRD_CLIENT2 C2          
WHERE SETT_TYPE = @SETT_TYPE          
AND SAUDA_DATE LIKE @SAUDA_DATE + '%'          
AND ISETTLEMENT.PARTY_CODE = C2.PARTY_CODE          
AND C2.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY          
AND AUCTIONPART NOT LIKE 'A%'           
AND SAUDA_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT

GO
