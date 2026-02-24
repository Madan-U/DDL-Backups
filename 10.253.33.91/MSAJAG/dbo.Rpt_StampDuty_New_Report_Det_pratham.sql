-- Object: PROCEDURE dbo.Rpt_StampDuty_New_Report_Det_pratham
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

--EXEC Rpt_StampDuty_New_Report_Det_pratham 'sep  1 2015','sep 30 2015','%',0    
    
    
--EXEC Rpt_StampDuty_New_Report_Det_pratham 'NOV  1 2015','NOV 30 2015','%',0      
      
          
CREATE PROC [dbo].[Rpt_StampDuty_New_Report_Det_pratham]           
 (          
 @START_DATE VARCHAR(11),           
 @END_DATE VARCHAR(11),           
 @STATE VARCHAR(50),          
 @RPT_TYPE INT = 0          
 )          
          
 AS              
          
          
 -- EXEC RPT_STAMPDUTY_NEW_REPORT_DET 'JUN 25 2000','JUN 25 2009','%',0           
              
 SELECT  SETTLEMENT.Party_Code,SETTLEMENT.sett_no,  instrument, SETTLEMENT.series ,     
  SAUDA_DATE = (CASE WHEN @RPT_TYPE = 0 THEN '' ELSE LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11) END),       
  SUM(BROKER_CHRG)AS STAMPDUTY,         
  CONTRACTNO = CONTRACTNO,          
  SETTLEMENT.SETT_TYPE,                     
  TAMT = SUM(CASE WHEN BILLFLAG IN (2,3) THEN TRADEQTY * MARKETRATE ELSE 0 END),                        
  DAMT = SUM(CASE WHEN BILLFLAG IN (1,4,5) THEN TRADEQTY * MARKETRATE ELSE 0 END),          
  CTSTAMP = SUM(CASE WHEN BILLFLAG IN (2,3) THEN BROKER_CHRG ELSE 0 END),                        
  CDSTAMP = SUM(CASE WHEN BILLFLAG IN (1,4,5) THEN BROKER_CHRG ELSE 0 END),          
  ATSTAMP = CONVERT(NUMERIC(18,4),0),                        
  ADSTAMP = CONVERT(NUMERIC(18,4),0),          
  TOTAMT = SUM(TRADEQTY * MARKETRATE),           
  CL_TYPE,           
  L_STATE          
 INTO           
  #STAMPDUTY           
 FROM           
  SETTLEMENT (NOLOCK), CLIENT2 (NOLOCK), CLIENT1 (NOLOCK), SETT_MST (NOLOCK) S2                     
 WHERE           
  SETTLEMENT.SETT_NO = S2.SETT_NO AND SETTLEMENT.SETT_TYPE = S2.SETT_TYPE                    
  AND S2.END_DATE >= @START_DATE AND S2.END_DATE <= @END_DATE + ' 23:59:59'                    
  AND TRADE_NO NOT LIKE '%C%' AND SETTLEMENT.PARTY_CODE = CLIENT2.PARTY_CODE                         
  AND CLIENT1.CL_CODE = CLIENT2.CL_CODE                         
  AND AUCTIONPART NOT LIKE 'F%' AND AUCTIONPART NOT LIKE 'A%'                        
  AND TRADEQTY > 0              
  AND L_STATE LIKE @STATE            
 GROUP BY    SETTLEMENT.Party_Code,SETTLEMENT.sett_no,  instrument,  SETTLEMENT.series ,   
  SETTLEMENT.SETT_TYPE, CL_TYPE, L_STATE,CONTRACTNO,          
  (CASE WHEN @RPT_TYPE = 0 THEN '' ELSE LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11) END)          
                      
          
 INSERT INTO #STAMPDUTY                    
 SELECT   ISETTLEMENT.Party_Code,ISETTLEMENT.sett_no, instrument,   ISettlement.series ,      
  SAUDA_DATE = (CASE WHEN @RPT_TYPE = 0 THEN '' ELSE LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11) END),        
  SUM(BROKER_CHRG)AS STAMPDUTY,         
  CONTRACTNO = CONTRACTNO,          
  ISETTLEMENT.SETT_TYPE,                    
  TAMT = 0,                        
  DAMT = SUM(TRADEQTY * ISETTLEMENT.DUMMY1),          
  CTSTAMP = 0,                        
  CDSTAMP = SUM(BROKER_CHRG),          
  ATSTAMP = CONVERT(NUMERIC(18,4),0),                        
  ADSTAMP = CONVERT(NUMERIC(18,4),0),          
  TOTAMT = SUM(TRADEQTY * ISETTLEMENT.DUMMY1),CL_TYPE,L_STATE                     
 FROM           
  ISETTLEMENT (NOLOCK),CLIENT2 (NOLOCK), CLIENT1 (NOLOCK), SETT_MST (NOLOCK) S2                     
 WHERE           
  ISETTLEMENT.SETT_NO = S2.SETT_NO AND ISETTLEMENT.SETT_TYPE = S2.SETT_TYPE                    
  AND S2.END_DATE >= @START_DATE AND S2.END_DATE <= @END_DATE + ' 23:59:59'                    
  AND TRADE_NO NOT LIKE '%C%' AND ISETTLEMENT.PARTY_CODE = CLIENT2.PARTY_CODE                         
  AND CLIENT1.CL_CODE = CLIENT2.CL_CODE                         
  AND AUCTIONPART NOT LIKE 'F%'  AND AUCTIONPART NOT LIKE 'A%'                        
  AND TRADEQTY > 0               
  AND L_STATE LIKE @STATE            
 GROUP BY     ISETTLEMENT.Party_Code,ISETTLEMENT.sett_no, instrument,  ISETTLEMENT.series ,   
  ISETTLEMENT.SETT_TYPE, CL_TYPE, L_STATE, CONTRACTNO,          
  (CASE WHEN @RPT_TYPE = 0 THEN '' ELSE LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11) END)          
                    
 INSERT INTO #STAMPDUTY                    
 SELECT    HISTORY.Party_Code,HISTORY.sett_no, instrument,  HISTORY.SERIES   ,     
  SAUDA_DATE = (CASE WHEN @RPT_TYPE = 0 THEN '' ELSE LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11) END),        
  SUM(BROKER_CHRG)AS STAMPDUTY,         
  CONTRACTNO = CONTRACTNO,          
  HISTORY.SETT_TYPE,                    
  TAMT = SUM(CASE WHEN BILLFLAG IN (2,3) THEN TRADEQTY * MARKETRATE ELSE 0 END),                        
  DAMT = SUM(CASE WHEN BILLFLAG IN (1,4,5) THEN TRADEQTY * MARKETRATE ELSE 0 END),          
  CTSTAMP = SUM(CASE WHEN BILLFLAG IN (2,3) THEN BROKER_CHRG ELSE 0 END),                        
  CDSTAMP = SUM(CASE WHEN BILLFLAG IN (1,4,5) THEN BROKER_CHRG ELSE 0 END),          
  ATSTAMP = CONVERT(NUMERIC(18,4),0),                        
  ADSTAMP = CONVERT(NUMERIC(18,4),0),                      
  TOTAMT = SUM(TRADEQTY * MARKETRATE), CL_TYPE, L_STATE                     
 FROM           
  HISTORY (NOLOCK), CLIENT2 (NOLOCK), CLIENT1 (NOLOCK), SETT_MST (NOLOCK) S2                     
 WHERE           
  HISTORY.SETT_NO = S2.SETT_NO AND HISTORY.SETT_TYPE = S2.SETT_TYPE            
  AND S2.END_DATE >= @START_DATE AND S2.END_DATE <= @END_DATE + ' 23:59:59'                    
  AND TRADE_NO NOT LIKE '%C%' AND HISTORY.PARTY_CODE = CLIENT2.PARTY_CODE                        
  AND CLIENT1.CL_CODE = CLIENT2.CL_CODE                         
  AND AUCTIONPART NOT LIKE 'F%'  AND AUCTIONPART NOT LIKE 'A%'                        
  AND TRADEQTY > 0               
  AND L_STATE LIKE @STATE            
 GROUP BY     HISTORY.Party_Code,HISTORY.sett_no, instrument,   HISTORY.series ,  
  HISTORY.SETT_TYPE, CL_TYPE, L_STATE, CONTRACTNO,          
  (CASE WHEN @RPT_TYPE = 0 THEN '' ELSE LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11) END)          
                    
 INSERT INTO #STAMPDUTY                    
 SELECT      IHISTORY.Party_Code,IHISTORY.sett_no,instrument, IHISTORY.series ,     
  SAUDA_DATE = (CASE WHEN @RPT_TYPE = 0 THEN '' ELSE LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11) END),       
  SUM(BROKER_CHRG)AS STAMPDUTY,          
  CONTRACTNO = CONTRACTNO,          
  IHISTORY.SETT_TYPE,                    
  TAMT = 0,                        
  DAMT = SUM(TRADEQTY * IHISTORY.DUMMY1),          
  CTSTAMP = 0,                        
  CDSTAMP = SUM(BROKER_CHRG),          
  ATSTAMP = CONVERT(NUMERIC(18,4),0),                        
  ADSTAMP = CONVERT(NUMERIC(18,4),0),                       
  TOTAMT = SUM(TRADEQTY * IHISTORY.DUMMY1),CL_TYPE,L_STATE                     
 FROM           
  IHISTORY (NOLOCK),CLIENT2 (NOLOCK), CLIENT1 (NOLOCK), SETT_MST (NOLOCK) S2                     
 WHERE           
  IHISTORY.SETT_NO = S2.SETT_NO AND IHISTORY.SETT_TYPE = S2.SETT_TYPE                    
  AND S2.END_DATE >= @START_DATE AND S2.END_DATE <= @END_DATE + ' 23:59:59'                    
  AND TRADE_NO NOT LIKE '%C%' AND IHISTORY.PARTY_CODE = CLIENT2.PARTY_CODE                         
  AND CLIENT1.CL_CODE = CLIENT2.CL_CODE                         
  AND AUCTIONPART NOT LIKE 'F%'  AND AUCTIONPART NOT LIKE 'A%'                        
  AND TRADEQTY > 0               
  AND L_STATE LIKE @STATE            
 GROUP BY     IHISTORY.Party_Code,IHISTORY.sett_no, instrument,   IHISTORY.series ,  
  IHISTORY.SETT_TYPE, CL_TYPE, L_STATE, CONTRACTNO,          
  (CASE WHEN @RPT_TYPE = 0 THEN '' ELSE LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11) END)          
          
          
          
          
 UPDATE #STAMPDUTY SET           
 ATSTAMP = (CASE WHEN CL_TYPE = 'PRO'          
   THEN TAMT * PROSTAMPDUTY / 100          
   ELSE TAMT * TRDSTAMPDUTY / 100          
     END),          
 ADSTAMP = (CASE WHEN CL_TYPE = 'PRO'          
   THEN DAMT * PROSTAMPDUTY / 100          
   ELSE DAMT * DELSTAMPDUTY / 100          
     END)          
 FROM STATE_MASTER (NOLOCK)          
 WHERE L_STATE = STATE          
          
 UPDATE #STAMPDUTY SET           
 ATSTAMP = (CASE WHEN CL_TYPE = 'PRO'          
   THEN TAMT * PROSTAMPDUTY / 100      
   ELSE TAMT * TRDSTAMPDUTY / 100          
     END),          
 ADSTAMP = (CASE WHEN CL_TYPE = 'PRO'          
   THEN DAMT * PROSTAMPDUTY / 100          
   ELSE DAMT * DELSTAMPDUTY / 100          
     END)          
 FROM STATE_MASTER (NOLOCK)         
 WHERE STATE = 'MAHARASHTRA'          
 AND L_STATE NOT IN (SELECT STATE FROM STATE_MASTER)          
          
 UPDATE           
  #STAMPDUTY SET          
  CONTRACTNO = CONTCOUNT          
 FROM          
  (       
  SELECT    Party_Code, sett_no, sett_type,       
   SAUDA_DATE,          
   STAMPDUTY,      
   instrument,    
   CONTCOUNT = COUNT(1),          
   L_STATE,          
   CONTRACTNO          
  FROM          
   #STAMPDUTY          
  GROUP BY          
  Party_Code, sett_no, sett_type, STAMPDUTY, instrument,     
   SAUDA_DATE,          
   L_STATE,          
   CONTRACTNO          
  ) A          
 WHERE           
  #STAMPDUTY.SAUDA_DATE = A.SAUDA_DATE          
  AND #STAMPDUTY.L_STATE = A.L_STATE          
  AND #STAMPDUTY.CONTRACTNO = A.CONTRACTNO          
          
          
 SELECT     Party_Code, sett_no, sett_type,  STAMPDUTY, instrument, series ,    
  L_STATE,                      
  SAUDA_DATE = (CASE WHEN @RPT_TYPE = 1 THEN SAUDA_DATE ELSE '' END),          
  PRODELAMOUNT = CONVERT(NUMERIC(18,4),             
    SUM(CASE WHEN CL_TYPE = 'PRO'             
      THEN (CASE WHEN SETT_TYPE IN ('W', 'C')                     
                   THEN DAMT + TAMT                   
                   ELSE DAMT          
            END)             
              ELSE 0            
        END)),                    
  PROTRDAMOUNT = CONVERT(NUMERIC(18,4),             
    SUM(CASE WHEN CL_TYPE = 'PRO'             
      THEN (CASE WHEN SETT_TYPE IN ('W', 'C')                     
                   THEN 0            
                   ELSE TAMT          
            END)             
              ELSE 0            
        END)),                    
  NRMDELAMOUNT = CONVERT(NUMERIC(18,4),             
    SUM(CASE WHEN CL_TYPE <> 'PRO'             
      THEN (CASE WHEN SETT_TYPE IN ('W', 'C')                     
                   THEN DAMT + TAMT                   
                   ELSE DAMT               
            END)             
              ELSE 0            
        END)),                  
  NRMTRDAMOUNT = CONVERT(NUMERIC(18,4),             
    SUM(CASE WHEN CL_TYPE <> 'PRO'             
      THEN (CASE WHEN SETT_TYPE IN ('W', 'C')                     
                   THEN 0            
                   ELSE TAMT          
            END)             
              ELSE 0            
        END)),            
            
  PROCDSTAMP = CONVERT(NUMERIC(18,4),             
    SUM(CASE WHEN CL_TYPE = 'PRO'             
      THEN (CASE WHEN SETT_TYPE IN ('W', 'C')                     
                   THEN CDSTAMP + CTSTAMP                   
                   ELSE CDSTAMP          
            END)             
              ELSE 0            
        END)),                    
  PROCTSTAMP = CONVERT(NUMERIC(18,4),             
    SUM(CASE WHEN CL_TYPE = 'PRO'             
      THEN (CASE WHEN SETT_TYPE IN ('W', 'C')                     
                   THEN 0            
                   ELSE CTSTAMP          
            END)             
              ELSE 0            
        END)),                    
  NRMCDSTAMP = CONVERT(NUMERIC(18,4),             
    SUM(CASE WHEN CL_TYPE <> 'PRO'             
      THEN (CASE WHEN SETT_TYPE IN ('W', 'C')                     
                   THEN CDSTAMP + CTSTAMP                   
                   ELSE CDSTAMP               
            END)             
              ELSE 0            
        END)),                    
  NRMCTSTAMP = CONVERT(NUMERIC(18,4),             
    SUM(CASE WHEN CL_TYPE <> 'PRO'             
      THEN (CASE WHEN SETT_TYPE IN ('W', 'C')                     
                   THEN 0            
                   ELSE CTSTAMP          
            END)             
              ELSE 0            
        END)),           
          
  --PROADSTAMP = CONVERT(NUMERIC(18,4),             
  --  SUM(CASE WHEN CL_TYPE = 'PRO'             
  --    THEN (CASE WHEN SETT_TYPE IN ('W', 'C')                     
  --                 THEN ADSTAMP + ATSTAMP                   
  --                 ELSE ADSTAMP          
  --          END)             
  --            ELSE 0            
  --      END)),                    
  --PROATSTAMP = CONVERT(NUMERIC(18,4),             
  --  SUM(CASE WHEN CL_TYPE = 'PRO'             
  --    THEN (CASE WHEN SETT_TYPE IN ('W', 'C')                     
  --                 THEN 0            
  --                 ELSE ATSTAMP          
  --          END)             
  --            ELSE 0            
  --      END)),                    
  --NRMADSTAMP = CONVERT(NUMERIC(18,4),             
  --  SUM(CASE WHEN CL_TYPE <> 'PRO'             
  --    THEN (CASE WHEN SETT_TYPE IN ('W', 'C')                     
  --                 THEN ADSTAMP + ATSTAMP                   
  --                 ELSE ADSTAMP               
  --          END)             
  --            ELSE 0            
  --      END)),                    
  --NRMATSTAMP = CONVERT(NUMERIC(18,4),             
  --  SUM(CASE WHEN CL_TYPE <> 'PRO'             
  --    THEN (CASE WHEN SETT_TYPE IN ('W', 'C')                     
  --                 THEN 0            
  --    ELSE ATSTAMP          
  --          END)             
  --            ELSE 0            
  --      END)),          
  TOTALAMT = CONVERT(NUMERIC(18,4), SUM(TOTAMT))        
  --NOOFCONTRACT = CONVERT(VARCHAR,SUM(CONVERT(NUMERIC,CONTRACTNO)))          
 INTO           
  #STAMPDUTY_REPORT                    
 FROM           
  #STAMPDUTY              
 GROUP BY      Party_Code, sett_no, sett_type, STAMPDUTY,instrument,series,      
  L_STATE, (CASE WHEN @RPT_TYPE = 1 THEN SAUDA_DATE ELSE '' END)          
          
          
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
 SELECT           
  EXCHANGE = 'NSE',           
  SEGMENT = 'CAPITAL',         
   Party_Code, sett_no, sett_type,      
   instrument,   
   series ,   
  L_STATE,          
  SAUDA_DATE,          
  PRODELAMOUNT,          
  PROTRDAMOUNT,          
  NRMDELAMOUNT,          
  NRMTRDAMOUNT,          
  PROCDSTAMP,          
  PROCTSTAMP,          
  NRMCDSTAMP,          
  NRMCTSTAMP,          
  --PROADSTAMP,          
  --PROATSTAMP,          
  --NRMADSTAMP,          
  --NRMATSTAMP,          
  TOTALAMT,          
  STAMPDUTY
 -- TOTALSTAMP = (PROADSTAMP+PROATSTAMP+NRMADSTAMP+NRMATSTAMP),           
  --NOOFCONTRACT          
 FROM           
  #STAMPDUTY_REPORT                 
 ORDER BY           
  L_STATE,          
  SAUDA_DATE,        
  instrument

GO
