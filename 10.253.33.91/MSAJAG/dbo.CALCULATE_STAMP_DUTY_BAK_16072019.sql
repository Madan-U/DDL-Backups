-- Object: PROCEDURE dbo.CALCULATE_STAMP_DUTY_BAK_16072019
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create  PROC [dbo].[CALCULATE_STAMP_DUTY_BAK_16072019]                  
(                        
 @SETT_TYPE VARCHAR(2),                  
 @SAUDA_DATE VARCHAR(11),                  
 @FROMPARTY VARCHAR(10),                         
 @TOPARTY VARCHAR(10)                        
)    
AS                  
                  
DECLARE @SETT_NO VARCHAR(7)                  
                  
SELECT @SETT_NO = SETT_NO FROM SETT_MST WHERE SETT_TYPE = @SETT_TYPE                  
AND @SAUDA_DATE BETWEEN START_DATE AND END_DATE                  
                  
--BEGIN TRAN    
    
 SELECT STATE,TRDSTAMPDUTY,DELSTAMPDUTY,PROSTAMPDUTY,MIN_MULTIPLIER,FOR_TURNOVER,MAXIMUM_LIMIT,    
           DEL_MIN_MULTIPLIER,DEL_FOR_TURNOVER,WDMSTAMPDUTY,WDMMin_Multiplier ,DEL_MAXIMUM_LIMIT     
    INTO #STATE_MASTER     
   FROM STATE_MASTER_DATA     
     WHERE @SAUDA_DATE BETWEEN YEAR_START_DATE AND YEAR_END_DATE    
 IF (SELECT ISNULL(COUNT(1), 0) FROM #STATE_MASTER ) > 0     
 BEGIN    
  SELECT DISTINCT PARTY_CODE INTO #SETT     
  FROM SETTLEMENT    
  WHERE SETT_NO = @SETT_NO                 
  AND SETT_TYPE = @SETT_TYPE                
  AND TRADE_NO NOT LIKE '%C%'                
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')                
  AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY   
    
  
  
  
    
  SELECT * INTO #CLIENT2 FROM CLIENT2 WHERE PARTY_CODE IN (SELECT PARTY_CODE FROM #SETT)      
  SELECT * INTO #CLIENT1 FROM CLIENT1 WHERE CL_CODE IN (SELECT PARTY_CODE FROM #SETT)  
  
  
    --------ADDED FOR WDM GUJRAT

 SELECT DISTINCT PARTY_CODE INTO #WDM FROM  SETTLEMENT S,CLIENT1 C

WHERE  SETT_NO = @SETT_NO                       

  AND SETT_TYPE = @SETT_TYPE  AND SERIES IN ('H2','H3','H4','H5','H6','H7','H8','H9','HA','HB','HC','HD','HE','M1','N1','N2','N3','N4','N5','N6',
'N7','N8','N9','NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ',
'NR','NS','NT','NU','NV','NW','NX','NY','NZ','U7','UZ','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9',
'YA','YB','YC','YD','YG'
)       

AND L_STATE ='GUJARAT' AND S.PARTY_CODE =CL_CODE 

    
      
  UPDATE #CLIENT1 SET L_STATE = STATE FROM OWNER      
  WHERE L_STATE NOT IN (SELECT STATE FROM #STATE_MASTER )    
    
  
      
    
    
  SELECT CLIENTTAXES_NEW.PARTY_CODE INTO #CLTAX     
  FROM CLIENTTAXES_NEW                  
  WHERE @SAUDA_DATE BETWEEN CLIENTTAXES_NEW.FROMDATE AND CLIENTTAXES_NEW.TODATE                  
  AND BROKER_NOTE = 0 AND EXISTS (SELECT PARTY_CODE FROM #SETT WHERE #SETT.PARTY_CODE = CLIENTTAXES_NEW.PARTY_CODE)    
  
    
    
    
  UPDATE SETTLEMENT SET BROKER_CHRG = 0                
  WHERE SETT_NO = @SETT_NO                 
  AND SETT_TYPE = @SETT_TYPE                
  AND TRADE_NO NOT LIKE '%C%'                
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')                
  AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                
  AND EXISTS (SELECT PARTY_CODE FROM #CLTAX                  
  WHERE SETTLEMENT.PARTY_CODE = #CLTAX.PARTY_CODE)  
  
   
                  
  UPDATE SETTLEMENT SET BROKER_CHRG =       
   (CASE WHEN CL_TYPE = 'PRO' THEN TRADEQTY*MARKETRATE*PROSTAMPDUTY/100      
   ELSE       
    TRADEQTY*MARKETRATE*(CASE WHEN BILLFLAG IN (2,3)                 
    THEN TRDSTAMPDUTY/100 ELSE DELSTAMPDUTY/100 END)                
   END)      
        FROM #STATE_MASTER, #CLIENT1 C1, #CLIENT2 C2                      
  WHERE SETT_NO = @SETT_NO                 
  AND SETT_TYPE = @SETT_TYPE                
  AND C1.CL_CODE = C2.CL_CODE                
  AND C2.PARTY_CODE = SETTLEMENT.PARTY_CODE                   
  AND L_STATE=STATE        
  AND TRADE_NO NOT LIKE '%C%'                
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')                
  AND C2.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY    
  AND NOT EXISTS (SELECT PARTY_CODE FROM #CLTAX                
  WHERE SETTLEMENT.PARTY_CODE = #CLTAX.PARTY_CODE)
  

--STAMP DUTY FOR BOND-    
    
  UPDATE SETTLEMENT SET Broker_Chrg = TRADEQTY*MARKETRATE*WDMSTAMPDUTY /100               
  FROM #STATE_MASTER, #CLIENT1 C1, #CLIENT2 C2              
  WHERE C1.CL_CODE = C2.CL_CODE              
  AND C2.PARTY_CODE = SETTLEMENT.PARTY_CODE                 
  and l_state=state      
  AND SETT_NO = @SETT_NO               
  AND SETT_TYPE = @SETT_TYPE              
  AND TRADE_NO NOT LIKE '%C%'            
  AND TRADEQTY > 0 And MarketRate > 0                
  AND SERIES IN ('H2','H3','H4','H5','H6','H7','H8','H9','HA','HB','HC','HD','HE','M1','N1','N2','N3','N4','N5','N6',
'N7','N8','N9','NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ',
'NR','NS','NT','NU','NV','NW','NX','NY','NZ','U7','UZ','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9',
'YA','YB','YC','YD','YG'
)                      
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')              
  And C2.Party_Code Between @FromParty And @ToParty              
  AND NOT EXISTS (SELECT PARTY_CODE FROM #CLTAX                  
  WHERE SETTLEMENT.PARTY_CODE = #CLTAX.PARTY_CODE)    
  AND SETTLEMENT.PARTY_CODE NOT IN (SELECT * FROM #WDM)  
  AND WDMSTAMPDUTY > -1  
  

  
        
  SELECT SETT_NO, SETT_TYPE, S.PARTY_CODE, L_STATE,    
  BROKER_NOTE = SUM(CASE WHEN SERIES NOT IN    ('H2','H3','H4','H5','H6','H7','H8','H9','HA','HB','HC','HD','HE','M1','N1','N2','N3','N4','N5','N6',
'N7','N8','N9','NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ',
'NR','NS','NT','NU','NV','NW','NX','NY','NZ','U7','UZ','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9',
'YA','YB','YC','YD','YG'
)                   
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')  THEN BROKER_CHRG ELSE 0 END),    

  BROKER_NOTE_WDM = SUM(CASE WHEN SERIES IN     ('H2','H3','H4','H5','H6','H7','H8','H9','HA','HB','HC','HD','HE','M1','N1','N2','N3','N4','N5','N6',
'N7','N8','N9','NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ',
'NR','NS','NT','NU','NV','NW','NX','NY','NZ','U7','UZ','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9',
'YA','YB','YC','YD','YG'
)                  
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS') THEN BROKER_CHRG ELSE 0 END),    
TRD_BROKER_NOTE = SUM(CASE WHEN BILLFLAG < 4 AND SERIES NOT IN  ('H2','H3','H4','H5','H6','H7','H8','H9','HA','HB','HC','HD','HE','M1','N1','N2','N3','N4','N5','N6',
'N7','N8','N9','NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ',
'NR','NS','NT','NU','NV','NW','NX','NY','NZ','U7','UZ','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9',
'YA','YB','YC','YD','YG'
)                     
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')    THEN BROKER_CHRG ELSE 0 END),
DEL_BROKER_NOTE = SUM(CASE WHEN BILLFLAG > 3 AND SERIES NOT IN  ('H2','H3','H4','H5','H6','H7','H8','H9','HA','HB','HC','HD','HE','M1','N1','N2','N3','N4','N5','N6',
'N7','N8','N9','NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ',
'NR','NS','NT','NU','NV','NW','NX','NY','NZ','U7','UZ','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9',
'YA','YB','YC','YD','YG'
) AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')  THEN BROKER_CHRG ELSE 0 END),


  TOBECHRG_STAMPDUTY = SUM(CASE WHEN SERIES NOT IN    ('H2','H3','H4','H5','H6','H7','H8','H9','HA','HB','HC','HD','HE','M1','N1','N2','N3','N4','N5','N6',
'N7','N8','N9','NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ',
'NR','NS','NT','NU','NV','NW','NX','NY','NZ','U7','UZ','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9',
'YA','YB','YC','YD','YG'
)                    
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')  THEN BROKER_CHRG ELSE 0 END),    
  TOBECHRG_STAMPDUTY_wdm = SUM(CASE WHEN SERIES IN   ('H2','H3','H4','H5','H6','H7','H8','H9','HA','HB','HC','HD','HE','M1','N1','N2','N3','N4','N5','N6',
'N7','N8','N9','NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ',
'NR','NS','NT','NU','NV','NW','NX','NY','NZ','U7','UZ','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9',
'YA','YB','YC','YD','YG'
)                     
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')  THEN BROKER_CHRG ELSE 0 END),    
  TURNOVER = SUM(CASE WHEN SERIES NOT IN  ('H2','H3','H4','H5','H6','H7','H8','H9','HA','HB','HC','HD','HE','M1','N1','N2','N3','N4','N5','N6',
'N7','N8','N9','NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ',
'NR','NS','NT','NU','NV','NW','NX','NY','NZ','U7','UZ','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9',
'YA','YB','YC','YD','YG'
)                      
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')  THEN TRADEQTY*MARKETRATE ELSE 0 END),                  
  TRD_TURNOVER = SUM(CASE WHEN BILLFLAG < 4 AND SERIES NOT IN  ('H2','H3','H4','H5','H6','H7','H8','H9','HA','HB','HC','HD','HE','M1','N1','N2','N3','N4','N5','N6',
'N7','N8','N9','NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ',
'NR','NS','NT','NU','NV','NW','NX','NY','NZ','U7','UZ','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9',
'YA','YB','YC','YD','YG'
)                     
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')   THEN TRADEQTY*MARKETRATE ELSE 0 END),                
  DEL_TURNOVER = SUM(CASE WHEN BILLFLAG > 3 AND SERIES NOT IN  ('H2','H3','H4','H5','H6','H7','H8','H9','HA','HB','HC','HD','HE','M1','N1','N2','N3','N4','N5','N6',
'N7','N8','N9','NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ',
'NR','NS','NT','NU','NV','NW','NX','NY','NZ','U7','UZ','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9',
'YA','YB','YC','YD','YG'
)                     
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')    THEN TRADEQTY*MARKETRATE ELSE 0 END),                
  WDM_TURNOVER = SUM(CASE WHEN SERIES IN  ('H2','H3','H4','H5','H6','H7','H8','H9','HA','HB','HC','HD','HE','M1','N1','N2','N3','N4','N5','N6',
'N7','N8','N9','NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ',
'NR','NS','NT','NU','NV','NW','NX','NY','NZ','U7','UZ','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9',
'YA','YB','YC','YD','YG'
)                     
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS') 
           THEN TRADEQTY*MARKETRATE ELSE 0 END),    
  ROUNDEDTURNOVER = SUM(CASE WHEN SERIES NOT IN  ('H2','H3','H4','H5','H6','H7','H8','H9','HA','HB','HC','HD','HE','M1','N1','N2','N3','N4','N5','N6',
'N7','N8','N9','NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ',
'NR','NS','NT','NU','NV','NW','NX','NY','NZ','U7','UZ','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9',
'YA','YB','YC','YD','YG'
)                    
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS') THEN TRADEQTY*MARKETRATE ELSE 0 END),                  
  TRD_ROUNDEDTURNOVER = SUM(CASE WHEN BILLFLAG < 4 AND SERIES NOT IN  ('H2','H3','H4','H5','H6','H7','H8','H9','HA','HB','HC','HD','HE','M1','N1','N2','N3','N4','N5','N6',
'N7','N8','N9','NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ',
'NR','NS','NT','NU','NV','NW','NX','NY','NZ','U7','UZ','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9',
'YA','YB','YC','YD','YG'
)                      
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')         THEN TRADEQTY*MARKETRATE ELSE 0 END),                
  DEL_ROUNDEDTURNOVER = SUM(CASE WHEN BILLFLAG > 3 AND SERIES NOT IN  ('H2','H3','H4','H5','H6','H7','H8','H9','HA','HB','HC','HD','HE','M1','N1','N2','N3','N4','N5','N6',
'N7','N8','N9','NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ',
'NR','NS','NT','NU','NV','NW','NX','NY','NZ','U7','UZ','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9',
'YA','YB','YC','YD','YG'
)                    
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS') 
            THEN TRADEQTY*MARKETRATE ELSE 0 END),    
  WDM_ROUNDEDTURNOVER = SUM(CASE WHEN SERIES IN  ('H2','H3','H4','H5','H6','H7','H8','H9','HA','HB','HC','HD','HE','M1','N1','N2','N3','N4','N5','N6',
'N7','N8','N9','NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ',
'NR','NS','NT','NU','NV','NW','NX','NY','NZ','U7','UZ','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9',
'YA','YB','YC','YD','YG'
)                     
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')  
           THEN TRADEQTY*MARKETRATE ELSE 0 END)    
  INTO #STAMP                  
        FROM SETTLEMENT S, #CLIENT1 C1, #CLIENT2 C2                        
  WHERE SETT_NO = @SETT_NO                  
  AND SETT_TYPE = @SETT_TYPE                  
  AND C1.CL_CODE = C2.CL_CODE                  
  AND C2.PARTY_CODE = S.PARTY_CODE                 
  AND TRADE_NO NOT LIKE '%C%'                  
  AND TRADEQTY > 0 AND MARKETRATE > 0                   
  AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')                  
  AND L_STATE IN (SELECT STATE FROM #STATE_MASTER     
      WHERE (MIN_MULTIPLIER > 0 OR MAXIMUM_LIMIT > 0))    
  AND C2.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY    
  AND NOT EXISTS (SELECT PARTY_CODE FROM #CLTAX                  
  WHERE S.PARTY_CODE = #CLTAX.PARTY_CODE)             
  GROUP BY SETT_NO, SETT_TYPE, S.PARTY_CODE, L_STATE                  
    

    
  UPDATE #STAMP SET     
  ROUNDEDTURNOVER  = PRADNYA.DBO.ROUNDEDTURNOVER(TURNOVER, FOR_TURNOVER),    
  TRD_ROUNDEDTURNOVER = PRADNYA.DBO.ROUNDEDTURNOVER(TRD_TURNOVER, FOR_TURNOVER),        
  DEL_ROUNDEDTURNOVER = PRADNYA.DBO.ROUNDEDTURNOVER(DEL_TURNOVER, DEL_FOR_TURNOVER),               
  WDM_ROUNDEDTURNOVER = PRADNYA.DBO.ROUNDEDTURNOVER(WDM_ROUNDEDTURNOVER, FOR_TURNOVER)    
  FROM #STATE_MASTER     
  WHERE L_STATE = STATE                  
  AND FOR_TURNOVER > 0    
    

  /*FOR TOTAL TURNOVER*/
  UPDATE #STAMP SET                   
  TOBECHRG_STAMPDUTY =     
   (CASE WHEN FOR_TURNOVER = DEL_FOR_TURNOVER AND MIN_MULTIPLIER = DEL_MIN_MULTIPLIER   
      THEN (CASE WHEN (ROUNDEDTURNOVER/FOR_TURNOVER*MIN_MULTIPLIER) > MAXIMUM_LIMIT AND MAXIMUM_LIMIT > 0                   
        THEN MAXIMUM_LIMIT                  
        WHEN (ROUNDEDTURNOVER/FOR_TURNOVER*MIN_MULTIPLIER) > BROKER_NOTE                  
        THEN (ROUNDEDTURNOVER/FOR_TURNOVER*MIN_MULTIPLIER)               
        WHEN BROKER_NOTE > MAXIMUM_LIMIT AND MAXIMUM_LIMIT > 0                    
        THEN MAXIMUM_LIMIT                  
        ELSE BROKER_NOTE                   
      END)                  
       ELSE      
        (CASE WHEN (TRD_ROUNDEDTURNOVER/FOR_TURNOVER * MIN_MULTIPLIER) +    
          (DEL_ROUNDEDTURNOVER/DEL_FOR_TURNOVER * DEL_MIN_MULTIPLIER)  
          > MAXIMUM_LIMIT AND MAXIMUM_LIMIT > 0                 
        THEN MAXIMUM_LIMIT                
        WHEN (TRD_ROUNDEDTURNOVER/FOR_TURNOVER * MIN_MULTIPLIER) +    
          (DEL_ROUNDEDTURNOVER/DEL_FOR_TURNOVER * DEL_MIN_MULTIPLIER)  
           > BROKER_NOTE     
        THEN (TRD_ROUNDEDTURNOVER/FOR_TURNOVER * MIN_MULTIPLIER) +    
          (DEL_ROUNDEDTURNOVER/DEL_FOR_TURNOVER * DEL_MIN_MULTIPLIER)   
        WHEN BROKER_NOTE > MAXIMUM_LIMIT AND MAXIMUM_LIMIT > 0                  
        THEN MAXIMUM_LIMIT                
        ELSE BROKER_NOTE                 
      END)    
   END)    
     
    
  FROM #STATE_MASTER WHERE L_STATE = STATE    
  AND FOR_TURNOVER > 0    AND ISNULL(DEL_MAXIMUM_LIMIT,'0')= '0' 
  /* FOR TOTAL TURNOVER*/

  	UPDATE #STAMP SET               
		TOBECHRG_STAMPDUTY = 
			(CASE WHEN FOR_TURNOVER = DEL_FOR_TURNOVER AND MIN_MULTIPLIER = DEL_MIN_MULTIPLIER AND MAXIMUM_LIMIT = DEL_MAXIMUM_LIMIT
				  THEN (CASE WHEN (ROUNDEDTURNOVER/FOR_TURNOVER*MIN_MULTIPLIER /*+ WDM_ROUNDEDTURNOVER/FOR_TURNOVER*WDMMin_Multiplier*/) > MAXIMUM_LIMIT AND MAXIMUM_LIMIT > 0               
							 THEN MAXIMUM_LIMIT              
							 WHEN (ROUNDEDTURNOVER/FOR_TURNOVER*MIN_MULTIPLIER /*+ WDM_ROUNDEDTURNOVER/FOR_TURNOVER*WDMMin_Multiplier*/) > BROKER_NOTE              
							 THEN (ROUNDEDTURNOVER/FOR_TURNOVER*MIN_MULTIPLIER /*+ WDM_ROUNDEDTURNOVER/FOR_TURNOVER*WDMMin_Multiplier*/)           
							 WHEN BROKER_NOTE > MAXIMUM_LIMIT AND MAXIMUM_LIMIT > 0                
							 THEN MAXIMUM_LIMIT              
							 ELSE BROKER_NOTE               
						END)              
				   ELSE  
					   (CASE WHEN MAXIMUM_LIMIT = DEL_MAXIMUM_LIMIT
							 THEN 
								   (CASE WHEN (TRD_ROUNDEDTURNOVER/FOR_TURNOVER * MIN_MULTIPLIER) +
											  (DEL_ROUNDEDTURNOVER/DEL_FOR_TURNOVER * DEL_MIN_MULTIPLIER) /*+
											  (WDM_ROUNDEDTURNOVER/FOR_TURNOVER * WDMMin_Multiplier)*/ > MAXIMUM_LIMIT AND MAXIMUM_LIMIT > 0             
										 THEN MAXIMUM_LIMIT            
										 WHEN (TRD_ROUNDEDTURNOVER/FOR_TURNOVER * MIN_MULTIPLIER) +
											  (DEL_ROUNDEDTURNOVER/DEL_FOR_TURNOVER * DEL_MIN_MULTIPLIER) /*+
											  (WDM_ROUNDEDTURNOVER/FOR_TURNOVER * WDMMin_Multiplier)*/ > BROKER_NOTE 
										 THEN (TRD_ROUNDEDTURNOVER/FOR_TURNOVER * MIN_MULTIPLIER) +
											  (DEL_ROUNDEDTURNOVER/DEL_FOR_TURNOVER * DEL_MIN_MULTIPLIER) /*+
											  (WDM_ROUNDEDTURNOVER/FOR_TURNOVER * WDMMin_Multiplier)*/
										 WHEN BROKER_NOTE > MAXIMUM_LIMIT AND MAXIMUM_LIMIT > 0              
										 THEN MAXIMUM_LIMIT            
										 ELSE BROKER_NOTE             
									END)
							 ELSE
								(CASE WHEN (TRD_ROUNDEDTURNOVER/FOR_TURNOVER * MIN_MULTIPLIER) > MAXIMUM_LIMIT AND MAXIMUM_LIMIT > 0             
										 THEN MAXIMUM_LIMIT            
										 WHEN (TRD_ROUNDEDTURNOVER/FOR_TURNOVER * MIN_MULTIPLIER) > TRD_BROKER_NOTE 
										 THEN (TRD_ROUNDEDTURNOVER/FOR_TURNOVER * MIN_MULTIPLIER)
										 WHEN TRD_BROKER_NOTE > MAXIMUM_LIMIT AND MAXIMUM_LIMIT > 0              
										 THEN MAXIMUM_LIMIT            
										 ELSE TRD_BROKER_NOTE             
									END)
								 +
								 (CASE WHEN (DEL_ROUNDEDTURNOVER/DEL_FOR_TURNOVER * DEL_MIN_MULTIPLIER) > DEL_MAXIMUM_LIMIT AND DEL_MAXIMUM_LIMIT > 0             
										 THEN DEL_MAXIMUM_LIMIT            
										 WHEN (DEL_ROUNDEDTURNOVER/DEL_FOR_TURNOVER * DEL_MIN_MULTIPLIER) > DEL_BROKER_NOTE 
										 THEN (DEL_ROUNDEDTURNOVER/DEL_FOR_TURNOVER * DEL_MIN_MULTIPLIER)  
										 WHEN DEL_BROKER_NOTE > DEL_MAXIMUM_LIMIT AND DEL_MAXIMUM_LIMIT > 0              
										 THEN DEL_MAXIMUM_LIMIT            
										 ELSE DEL_BROKER_NOTE             
									END)
						END)
			END)

		FROM #STATE_MASTER WHERE L_STATE = STATE
		AND FOR_TURNOVER > 0 AND  ISNULL(DEL_MAXIMUM_LIMIT,'0') <> '0' 








    
  
  
UPDATE #STAMP SET TOBECHRG_STAMPDUTY = TOBECHRG_STAMPDUTY + TOBECHRG_STAMPDUTY_WDM  
  
   
    
  UPDATE SETTLEMENT SET BROKER_CHRG = 0                   
  WHERE EXISTS (SELECT PARTY_CODE FROM #STAMP                  
  WHERE SETTLEMENT.SETT_NO = @SETT_NO                  
  AND SETTLEMENT.SETT_TYPE = @SETT_TYPE            
  AND #STAMP.SETT_NO = SETTLEMENT.SETT_NO                  
  AND #STAMP.SETT_TYPE = SETTLEMENT.SETT_TYPE                  
  AND #STAMP.PARTY_CODE = SETTLEMENT.PARTY_CODE)  
  
  

                    
    
  SELECT SETT_NO, SETT_TYPE, PARTY_CODE,                   
  --TRADESCRIPSELL = MIN(RTRIM(TRADE_NO)+RTRIM(SCRIP_CD)+CONVERT(VARCHAR,SELL_BUY))                  
  SRNO = MIN(SRNO)    
  INTO #SETTSTAMP FROM SETTLEMENT                  
  WHERE SETTLEMENT.SETT_NO = @SETT_NO                  
  AND SETTLEMENT.SETT_TYPE = @SETT_TYPE                  
  AND EXISTS (SELECT PARTY_CODE FROM #STAMP                  
  WHERE #STAMP.SETT_NO = SETTLEMENT.SETT_NO              
  AND #STAMP.SETT_TYPE = SETTLEMENT.SETT_TYPE                  
  AND #STAMP.PARTY_CODE = SETTLEMENT.PARTY_CODE)    
  AND TRADE_NO NOT LIKE '%C%'     
  GROUP BY SETT_NO, SETT_TYPE, PARTY_CODE                  
    
  UPDATE SETTLEMENT SET BROKER_CHRG = TOBECHRG_STAMPDUTY                  
  FROM #STAMP, #SETTSTAMP                  
  WHERE SETTLEMENT.SETT_NO = @SETT_NO                  
  AND SETTLEMENT.SETT_TYPE = @SETT_TYPE                  
  AND #STAMP.SETT_NO = SETTLEMENT.SETT_NO                  
  AND #STAMP.SETT_TYPE = SETTLEMENT.SETT_TYPE                  
  AND #STAMP.PARTY_CODE = SETTLEMENT.PARTY_CODE                  
  AND #SETTSTAMP.SETT_NO = SETTLEMENT.SETT_NO                  
  AND #SETTSTAMP.SETT_TYPE = SETTLEMENT.SETT_TYPE                  
  AND #SETTSTAMP.PARTY_CODE = SETTLEMENT.PARTY_CODE            
  --AND #SETTSTAMP.TRADESCRIPSELL = RTRIM(TRADE_NO)+RTRIM(SCRIP_CD)+CONVERT(VARCHAR,SELL_BUY)    
  AND #SETTSTAMP.SRNO = SETTLEMENT.SRNO    
 END    
--COMMIT TRAN

GO
