-- Object: PROCEDURE dbo.NSECMVALAN_BAK_19jul2020
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------









CREATE PROC [dbo].[NSECMVALAN_BAK_19jul2020] (                                
@SETT_NO	VARCHAR(7),                                           
@SETT_TYPE	VARCHAR(2),                                
@SDATE		VARCHAR(11),                                
@PARTY_CODE VARCHAR(10),                                
@SCRIP_CD	VARCHAR(12),                                
@SERIES		VARCHAR(3),                                
@STATUSNAME	 VARCHAR(15)
)           with recompile                     
AS                
/* DROP PROC NSECMVALAN */                                
                                
/* SET NOCOUNT ON */                                
            
DECLARE @SAUDA_DATE DATETIME                                

----------------------------------------------
DECLARE @SETT_NO_L VARCHAR(7)                                           
DECLARE @SETT_TYPE_L VARCHAR(2)                                
DECLARE @SDATE_L VARCHAR(11)                              
DECLARE @PARTY_CODE_L VARCHAR(10)
DECLARE @SCRIP_CD_L VARCHAR(12)                              
DECLARE @SERIES_L VARCHAR(3)                              
DECLARE @STATUSNAME_L VARCHAR(15)

SET @SETT_NO_L = @SETT_NO                                           
SET @SETT_TYPE_L = @SETT_TYPE                                
SET @SDATE_L = @SDATE                              
SET @PARTY_CODE_L = @PARTY_CODE
SET @SCRIP_CD_L = @SCRIP_CD                              
SET @SERIES_L = @SERIES                              
SET @STATUSNAME_L = @STATUSNAME


----------------------------------------------

IF @PARTY_CODE_L = ''                                 
 SELECT @PARTY_CODE_L = '%'                                
                                
IF @SCRIP_CD_L = ''                                 
 SELECT @SCRIP_CD_L = '%'                                
                                
IF @SERIES_L = ''                                 
 SELECT @SERIES_L = '%'                                
                                
IF @SDATE_L = ''                                 
   SELECT @SDATE_L = '%'                                
              
  DECLARE  @TRDTURNOVER_TAX NUMERIC(18,6),              
           @PROTURNOVER_TAX NUMERIC(18,6),              
           @DELTURNOVER_TAX NUMERIC(18,6),              
           @TRDSEBI_TAX     NUMERIC(18,6),              
           @PROSEBI_TAX     NUMERIC(18,6),              
           @DELSEBI_TAX     NUMERIC(18,6),              
           @TRDBROKER_CHRG  NUMERIC(18,6),              
           @PROBROKER_CHRG  NUMERIC(18,6),              
           @DELBROKER_CHRG  NUMERIC(18,6)              
            
 SELECT @SAUDA_DATE = START_DATE             
 FROM SETT_MST            
 WHERE SETT_NO = @SETT_NO_L              
   AND SETT_TYPE = @SETT_TYPE_L                                            
            
  SELECT @TRDTURNOVER_TAX = TURNOVER_TAX,              
         @TRDSEBI_TAX = SEBITURN_TAX,              
         @TRDBROKER_CHRG = BROKER_NOTE              
  FROM   TAXES,              
         SETT_MST S              
  WHERE  TRANS_CAT = 'TRD'              
         AND SETT_NO = @SETT_NO_L              
         AND SETT_TYPE = @SETT_TYPE_L              
         AND START_DATE BETWEEN FROM_DATE AND TO_DATE              
                                                            
  SELECT @DELTURNOVER_TAX = TURNOVER_TAX,              
         @DELSEBI_TAX = SEBITURN_TAX,              
         @DELBROKER_CHRG = BROKER_NOTE              
  FROM   TAXES,              
         SETT_MST S              
  WHERE  TRANS_CAT = 'DEL'              
         AND SETT_NO = @SETT_NO_L              
         AND SETT_TYPE = @SETT_TYPE_L              
         AND START_DATE BETWEEN FROM_DATE AND TO_DATE              
                                                            
  SELECT @PROTURNOVER_TAX = TURNOVER_TAX,              
         @PROSEBI_TAX = SEBITURN_TAX,              
         @PROBROKER_CHRG = BROKER_NOTE              
  FROM   TAXES,              
         SETT_MST S              
  WHERE  TRANS_CAT = 'PRO'              
         AND SETT_NO = @SETT_NO_L              
         AND SETT_TYPE = @SETT_TYPE_L              
         AND START_DATE BETWEEN FROM_DATE AND TO_DATE              
                            
SELECT *,             
PTRDRATE = CONVERT(NUMERIC(18,4),0),              
STRDRATE = CONVERT(NUMERIC(18,4),0),              
PDELRATE = CONVERT(NUMERIC(18,4),0),              
SDELRATE = CONVERT(NUMERIC(18,4),0)               
INTO #CMBILLVALAN                            
FROM CMBILLVALAN WHERE 1 = 2                             
                                
INSERT INTO PROCESS_MONITOR VALUES ('VALAN GENERATION',@SETT_NO_L + @SETT_TYPE_L,'','NSECMVALAN','START','DELETE FROM #CMBILLVALAN',GETDATE(),GETDATE())                                
                                
INSERT INTO PROCESS_MONITOR VALUES ('VALAN GENERATION',@SETT_NO_L + @SETT_TYPE_L,'','NSECMVALAN','DONE-DELETE FROM #CMBILLVALAN. RECCOUNT: ' + CONVERT(CHAR,@@ROWCOUNT),'INSERT NORMAL TRADE FROM SETTLEMENT_VALAN W/O ND SCRIP',GETDATE(),GETDATE())                    
       
    
ALTER TABLE #CMBILLVALAN  
ALTER COLUMN PARTY_NAME VARCHAR(100)      

TRUNCATE TABLE SETTLEMENT_VALAN
TRUNCATE TABLE ISETTLEMENT_VALAN

INSERT INTO SETTLEMENT_VALAN        
SELECT * FROM SETTLEMENT 
WHERE SETT_NO = @SETT_NO_L
AND SETT_TYPE = @SETT_TYPE_L  

INSERT INTO ISETTLEMENT_VALAN 
SELECT * FROM ISETTLEMENT 
WHERE SETT_NO = @SETT_NO_L
AND SETT_TYPE = @SETT_TYPE_L 

SELECT * INTO #CLIENT1 FROM CLIENT1
WHERE EXISTS (SELECT PARTY_CODE FROM SETTLEMENT_VALAN WHERE PARTY_CODE = CL_CODE) 

insert  INTO #CLIENT1 
SELECT * FROM CLIENT1
WHERE EXISTS (SELECT PARTY_CODE FROM iSETTLEMENT_VALAN WHERE PARTY_CODE = CL_CODE) 
and not exists (select cl_code from #CLIENT1 where #CLIENT1.cl_code = client1.cl_code ) 

SELECT * INTO #CLIENT2 FROM CLIENT2
WHERE EXISTS (SELECT CL_CODE FROM #CLIENT1 WHERE CLIENT2.Cl_Code = #CLIENT1.CL_CODE) 
 
CREATE CLUSTERED INDEX [INDXSETT] ON [dbo].[#CMBILLVALAN] 
(
	[SETT_NO] ASC,
	[SETT_TYPE] ASC
)

CREATE CLUSTERED INDEX [INDXPARTY] ON [dbo].[#Client2] 
(
	[Party_code] ASC
)
CREATE CLUSTERED INDEX [INDXPARTY] ON [dbo].[#Client1] 
(
	[CL_code] ASC
)
                                
INSERT INTO #CMBILLVALAN                                 
/* NORMAL TRADE FROM SETTLEMENT_VALAN WITHOUT ND SCRIP */             
SELECT S.SETT_NO,S.SETT_TYPE,BILLNO,S.CONTRACTNO,S.PARTY_CODE,PARTY_NAME= C1.Short_Name,S.SCRIP_CD,S.SERIES,                                
SCRIP_NAME='',ISIN='',SAUDA_DATE=LEFT(CONVERT(VARCHAR,S.SAUDA_DATE,109),11),                                
PQTYTRD = SUM(CASE WHEN BILLNO > 0                                 
             THEN (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2                                 
          THEN TRADEQTY                                
          ELSE 0                                 
     END )                                 
      ELSE (CASE WHEN SELL_BUY = 1 AND SETTFLAG = 2                                 
          THEN TRADEQTY                                 
          ELSE 0                                 
     END )                                 
      END),                                 
PAMTTRD = SUM(CASE WHEN BILLNO > 0                                 
             THEN (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2                     
        THEN (CASE WHEN SERVICE_CHRG = 1                                 
                           THEN TRADEQTY * N_NETRATE + NSERTAX                                   
                           ELSE TRADEQTY * N_NETRATE                                 
                  END )                                
          ELSE 0                                 
     END )                                 
      ELSE (CASE WHEN SELL_BUY = 1 AND SETTFLAG = 2                                 
        THEN (CASE WHEN SERVICE_CHRG = 1                                 
                           THEN TRADEQTY * N_NETRATE + NSERTAX                                   
                           ELSE TRADEQTY * N_NETRATE                                 
                  END )                                
          ELSE 0                                 
     END )                                 
      END),                                 
PQTYDEL = SUM(CASE WHEN BILLNO > 0                                 
             THEN (CASE WHEN SELL_BUY = 1 AND BILLFLAG IN (1,4)                                 
          THEN TRADEQTY                                
          ELSE 0                                 
     END )                                 
      ELSE (CASE WHEN SELL_BUY = 1 AND SETTFLAG IN (1,4)                                
          THEN TRADEQTY                                 
          ELSE 0                                 
     END )                                 
      END),                                 
PAMTDEL = SUM(CASE WHEN BILLNO > 0                                 
             THEN (CASE WHEN SELL_BUY = 1 AND BILLFLAG IN (1,4)                                
        THEN (CASE WHEN SERVICE_CHRG = 1                                 
                           THEN TRADEQTY * N_NETRATE + NSERTAX                                   
                           ELSE TRADEQTY * N_NETRATE                                 
                  END )                      
          ELSE 0                                 
     END )                                 
      ELSE (CASE WHEN SELL_BUY = 1 AND SETTFLAG IN (1,4)                                
THEN (CASE WHEN SERVICE_CHRG = 1                                 
                           THEN TRADEQTY * N_NETRATE + NSERTAX                                   
           ELSE TRADEQTY * N_NETRATE                                 
                  END )                                
          ELSE 0                                 
     END )                                 
      END),                       
SQTYTRD = SUM(CASE WHEN BILLNO > 0                           
             THEN (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3                                
          THEN TRADEQTY                                
          ELSE 0                                 
     END )                                 
      ELSE (CASE WHEN SELL_BUY = 2 AND SETTFLAG = 3         
          THEN TRADEQTY                                 
          ELSE 0                                 
     END )                                 
      END),                                 
SAMTTRD = SUM(CASE WHEN BILLNO > 0                                 
             THEN (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3                                 
        THEN (CASE WHEN SERVICE_CHRG = 1                                 
            THEN TRADEQTY * N_NETRATE - NSERTAX                                   
                           ELSE TRADEQTY * N_NETRATE                                 
                  END )                                
 ELSE 0                                 
     END )                                 
      ELSE (CASE WHEN SELL_BUY = 2 AND SETTFLAG = 3                                 
        THEN (CASE WHEN SERVICE_CHRG = 1                                 
                           THEN TRADEQTY * N_NETRATE - NSERTAX                                   
              ELSE TRADEQTY * N_NETRATE                                 
                  END )                                
          ELSE 0                                 
     END )                                 
      END),                                 
SQTYDEL = SUM(CASE WHEN BILLNO > 0                                 
             THEN (CASE WHEN SELL_BUY = 2 AND BILLFLAG IN (1,5)                                
          THEN TRADEQTY                                
          ELSE 0                                 
     END )                                 
      ELSE (CASE WHEN SELL_BUY = 2 AND SETTFLAG IN (1,5)                                
        THEN TRADEQTY                                 
          ELSE 0                                 
     END )                                 
      END),                                 
SAMTDEL = SUM(CASE WHEN BILLNO > 0                                 
             THEN (CASE WHEN SELL_BUY = 2 AND BILLFLAG IN (1,5)                                
        THEN (CASE WHEN SERVICE_CHRG = 1                                 
                           THEN TRADEQTY * N_NETRATE - NSERTAX                                   
                           ELSE TRADEQTY * N_NETRATE                                 
                  END )                                
          ELSE 0                                 
     END )                                 
      ELSE (CASE WHEN SELL_BUY = 2 AND SETTFLAG IN (1,5)                                
        THEN (CASE WHEN SERVICE_CHRG = 1                                 
                           THEN TRADEQTY * N_NETRATE - NSERTAX                                   
                           ELSE TRADEQTY * N_NETRATE                                 
                  END )                                
          ELSE 0                                 
     END )                                 
      END),                                 
                                
/*                                
PBROKTRD = SUM((CASE WHEN SELL_BUY = 1                                 
   THEN TRADEQTY*BROKAPPLIED                                
   ELSE 0                                 
      END)),                                 
SBROKTRD = SUM((CASE WHEN SELL_BUY = 2                                
   THEN TRADEQTY*BROKAPPLIED                                
   ELSE 0                                 
      END)),                                 
PBROKDEL = SUM((CASE WHEN SELL_BUY = 1                                 
   THEN TRADEQTY*(NBROKAPP - BROKAPPLIED)                                
   ELSE 0                                 
      END)),                                 
SBROKDEL = SUM((CASE WHEN SELL_BUY = 2                                 
   THEN TRADEQTY*(NBROKAPP - BROKAPPLIED)                                
   ELSE 0                                 
      END)),                                 
*/                                
PBROKTRD = SUM(CASE WHEN BILLNO > 0                                 
         THEN (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2                                 
                      THEN TRADEQTY*NBROKAPP                               
                      ELSE 0                                 
            END)                                
  ELSE                                
            (CASE WHEN SELL_BUY = 1 AND SETTFLAG = 2                                
                      THEN TRADEQTY*NBROKAPP                                
                      ELSE 0                                 
            END)                                
              END),                                 
SBROKTRD = SUM(CASE WHEN BILLNO > 0                                 
         THEN (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3                                
                      THEN TRADEQTY*NBROKAPP                                
                      ELSE 0                                 
            END)                                
  ELSE                                
            (CASE WHEN SELL_BUY = 2 AND SETTFLAG = 3           
THEN TRADEQTY*NBROKAPP                                
                      ELSE 0                                 
            END)                                
              END),                                
PBROKDEL = SUM(CASE WHEN BILLNO > 0                                 
         THEN (CASE WHEN SELL_BUY = 1 AND BILLFLAG IN (1,4)                                 
                      THEN TRADEQTY*NBROKAPP                                
                      ELSE 0                                 
            END)                                
  ELSE                                
            (CASE WHEN SELL_BUY = 1 AND SETTFLAG IN (1,4)                                
                      THEN TRADEQTY*NBROKAPP                                
                      ELSE 0                                 
            END)                                
              END),                                
SBROKDEL =  SUM(CASE WHEN BILLNO > 0                                 
         THEN (CASE WHEN SELL_BUY = 2 AND BILLFLAG IN (1,5)                                 
                      THEN TRADEQTY*NBROKAPP                                
        ELSE 0                                 
            END)                                
  ELSE                                
            (CASE WHEN SELL_BUY = 2 AND SETTFLAG IN (1,5)                                
                      THEN TRADEQTY*NBROKAPP                                
                      ELSE 0                                 
            END)                                
              END),                                
FAMILY,FAMILYNAME='',TERMINAL_ID='0',CLIENTTYPE=CL_TYPE,TRADETYPE='S',TRADER,SUB_BROKER,BRANCH_CD,PARTIPANTCODE,                                
PAMT = ISNULL(SUM(CASE WHEN SELL_BUY = 1                                 
      THEN (CASE WHEN SERVICE_CHRG = 2                                 
                 THEN TRADEQTY * N_NETRATE                                   
          ELSE TRADEQTY * N_NETRATE + NSERTAX                                
     END ) +                                 
    (CASE WHEN DISPCHARGE = 1                                  
          THEN (CASE WHEN TURNOVER_TAX = 1                                 
                       THEN TURN_TAX                                
                     ELSE 0                                 
         END )                                 
          ELSE 0                                
     END ) +                                 
    (CASE WHEN DISPCHARGE = 1                                 
          THEN (CASE WHEN SEBI_TURN_TAX = 1                                 
       THEN (SEBI_TAX)                                   
              ELSE 0                                 
         END )                                    
          ELSE 0                                 
     END ) +                                 
    (CASE WHEN DISPCHARGE = 1                                 
    THEN (CASE WHEN INSURANCE_CHRG = 1                                 
       THEN INS_CHRG                                
                     ELSE 0                                 
         END )                                
       ELSE 0                                 
     END ) +                                 
    (CASE WHEN DISPCHARGE = 1                                 
          THEN (CASE WHEN BROKERNOTE = 1                                 
       THEN (BROKER_CHRG)                                   
              ELSE 0                                 
                       END )                                    
                 ELSE 0                                 
     END ) +                                 
    (CASE WHEN DISPCHARGE = 1                                 
          THEN (CASE WHEN C2.OTHER_CHRG = 1                                 
       THEN (S.OTHER_CHRG)                                   
                     ELSE 0                                 
         END )                                    
                               ELSE 0                                
  END )                                  
   ELSE 0                                 
   END),0),                                  
SAMT = ISNULL(SUM(CASE WHEN SELL_BUY = 2                                 
      THEN (CASE WHEN SERVICE_CHRG = 2                                 
                 THEN TRADEQTY * N_NETRATE                  
          ELSE TRADEQTY * N_NETRATE - NSERTAX                                
     END ) -                                 
    (CASE WHEN DISPCHARGE = 1                                 
          THEN (CASE WHEN TURNOVER_TAX = 1                                 
            THEN TURN_TAX                                
                     ELSE 0                                 
         END )                                    
          ELSE 0                                
     END ) -                                 
    (CASE WHEN DISPCHARGE = 1                                 
          THEN (CASE WHEN SEBI_TURN_TAX = 1                                 
THEN (SEBI_TAX)                                   
              ELSE 0                                 
         END )                                    
          ELSE 0                                 
     END ) -                                 
    (CASE WHEN DISPCHARGE = 1                                 
          THEN (CASE WHEN INSURANCE_CHRG = 1                                 
       THEN INS_CHRG                                
                     ELSE 0                                 
         END )                                
          ELSE 0                                 
     END ) -                                 
    (CASE WHEN DISPCHARGE = 1                                 
          THEN (CASE WHEN BROKERNOTE = 1                          
       THEN (BROKER_CHRG)                                   
              ELSE 0                                 
                       END )                                    
                 ELSE 0                                 
     END ) -                                
    (CASE WHEN DISPCHARGE = 1                                 
          THEN (CASE WHEN C2.OTHER_CHRG = 1                                 
       THEN (S.OTHER_CHRG)                                   
                     ELSE 0                                 
         END )                                    
                               ELSE 0                                
                          END )                                  
   ELSE 0                END),0),      
PRATE = SUM(CASE WHEN SELL_BUY = 1 THEN (TRADEQTY*S.DUMMY1) ELSE 0 END),                                  
SRATE = SUM(CASE WHEN SELL_BUY = 2 THEN (TRADEQTY*S.DUMMY1) ELSE 0 END),                                
TrdAmt = Sum(TradeQty*S.MarketRate),             
DelAmt = Sum((Case When BillFlag in (1,4,5)            
         Then TradeQty*S.MarketRate            
        Else 0             
   End)),  
SERINEX = SERVICE_CHRG,                                
SERVICE_TAX = SUM(NSERTAX),                                
EXSERVICE_TAX = SUM(CASE WHEN SERVICE_CHRG = 2                                 
        THEN (NSERTAX)                                
        ELSE 0                                 
   END),                                 
TURN_TAX = SUM(CASE WHEN DISPCHARGE = 1                                 
   THEN (CASE WHEN TURNOVER_TAX = 1                                 
              THEN (TURN_TAX)                                   
                 ELSE 0                                 
         END)                                    
          ELSE 0                                 
     END ),                                
SEBI_TAX = SUM(CASE WHEN DISPCHARGE = 1                                 
   THEN (CASE WHEN SEBI_TURN_TAX = 1                                 
              THEN (SEBI_TAX)                                   
       ELSE 0                                 
         END)                                    
   ELSE 0                                 
     END),                                  
INS_CHRG = SUM(CASE WHEN DISPCHARGE = 1                                 
   THEN (CASE WHEN INSURANCE_CHRG = 1                                 
       THEN (INS_CHRG)                                   
            ELSE 0                                 
         END)                                    
   ELSE 0                                 
     END),                                
BROKER_CHRG = SUM(CASE WHEN DISPCHARGE = 1            
      THEN (CASE WHEN BROKERNOTE = 1                     
          THEN (BROKER_CHRG)                                   
                 ELSE 0                                 
            END)                                    
      ELSE 0                                 
        END),                                
OTHER_CHRG = SUM(CASE WHEN DISPCHARGE = 1                                 
     THEN (CASE WHEN C2.OTHER_CHRG = 1                                 
                THEN (S.OTHER_CHRG)                                   
                ELSE 0                                 
           END)                                    
     ELSE 0                                 
       END),                                  
REGION=ISNULL(REGION,''), START_DATE='', END_DATE='', UPDATE_DATE=LEFT(CONVERT(VARCHAR,GETDATE(),109),11), STATUS_NAME=@STATUSNAME_L,                                
EXCHANGE='NSE',SEGMENT='CAPITAL',MEMBERTYPE=MEMBERCODE,CompanyName=C1.L_STATE,DUMMY1='',DUMMY2='',DUMMY3='',DUMMY4=0,DUMMY5=0,  AREA = ISNULL(AREA,''),              
PTRDRATE = SUM(CASE               
              WHEN SELL_BUY = 1              
                   AND BILLFLAG = 2              
                   AND AUCTIONPART NOT LIKE 'A%'              
                   AND AUCTIONPART NOT LIKE 'F%' THEN TRADEQTY * S.MARKETRATE              
              ELSE 0              
            END),              
STRDRATE = SUM(CASE               
              WHEN SELL_BUY = 2              
                   AND BILLFLAG = 3              
                   AND AUCTIONPART NOT LIKE 'A%'              
                   AND AUCTIONPART NOT LIKE 'F%' THEN TRADEQTY * S.MARKETRATE              
              ELSE 0             
            END),              
PDELRATE = SUM(CASE               
              WHEN SELL_BUY = 1              
                   AND BILLFLAG <> 2              
                   AND AUCTIONPART NOT LIKE 'A%'              
                   AND AUCTIONPART NOT LIKE 'F%' THEN TRADEQTY * S.MARKETRATE              
              ELSE 0              
            END),              
SDELRATE = SUM(CASE               
              WHEN SELL_BUY = 2              
                   AND BILLFLAG <> 3              
                   AND AUCTIONPART NOT LIKE 'A%'              
                   AND AUCTIONPART NOT LIKE 'F%' THEN TRADEQTY * S.MARKETRATE              
              ELSE 0              
            END)              
FROM SETTLEMENT_VALAN S , #CLIENT2 C2, OWNER, #CLIENT1  C1                                 
WHERE S.SETT_NO = @SETT_NO_L AND S.SETT_TYPE = @SETT_TYPE_L AND TRADEQTY > 0                
AND AUCTIONPART NOT IN ('AP','AR')                
AND MARKETRATE > 0                 
AND C2.PARTY_CODE = S.PARTY_CODE AND C1.CL_CODE = C2.CL_CODE                                  
GROUP BY SETT_NO,SETT_TYPE,CONTRACTNO,BILLNO,S.PARTY_CODE,C1.Short_Name,S.SCRIP_CD,S.SERIES,LEFT(CONVERT(VARCHAR,S.SAUDA_DATE,109),11),                          
C1.FAMILY,TRADER,SUB_BROKER,PARTIPANTCODE,MEMBERCODE,C1.L_STATE,                                
SERVICE_CHRG,BRANCH_CD,CL_TYPE, DUMMY8, DUMMY9, DUMMY10, REGION, AREA                              
    
                                
INSERT INTO PROCESS_MONITOR VALUES ('VALAN GENERATION',@SETT_NO_L + @SETT_TYPE_L,'','NSECMVALAN','DONE-INSERT NORMAL TRADE FROM SETTLEMENT_VALAN W/O ND SCRIP. RECCOUNT: ' + CONVERT(CHAR,@@ROWCOUNT),'INSERT INSTITUTIONAL TRADE FROM ISETTLEMENT_VALAN',GETDATE(),GETDATE())
            
    
                         
INSERT INTO #CMBILLVALAN                
SELECT S.CD_SETT_NO,S.CD_SETT_TYPE,BILLNO=0,CONTRACTNO='0',S.CD_PARTY_CODE,                    
PARTY_NAME= C1.Short_Name,SCRIP_CD = (CASE WHEN S.CD_SCRIP_CD = '' THEN 'BROKERAGE' ELSE S.CD_SCRIP_CD END),                    
SERIES = (CASE WHEN S.CD_SERIES = '' THEN (CASE WHEN CD_SETT_TYPE = 'W' THEN 'BE' ELSE 'EQ' END) ELSE S.CD_SERIES END),                    
SCRIP_NAME='',ISIN='',SAUDA_DATE=LEFT(CONVERT(VARCHAR,S.CD_SAUDA_DATE,109),11),                          
PQTYTRD = 0,                           
PAMTTRD = SUM(CD_TRDBUYBROKERAGE                     
       +(CASE WHEN SERVICE_CHRG = 1                           
                THEN CD_TRDBUYSERTAX                              
  ELSE 0                    
           END)),                           
PQTYDEL =0,                           
PAMTDEL = SUM(CD_DELBUYBROKERAGE                     
       + (CASE WHEN SERVICE_CHRG = 1                           
          THEN CD_DELBUYSERTAX                              
  ELSE 0                    
           END)),                    
SQTYTRD =0,                           
SAMTTRD= SUM(CD_TRDSELLBROKERAGE                     
       + (CASE WHEN SERVICE_CHRG = 1                           
                THEN CD_TRDSELLSERTAX                              
  ELSE 0                    
           END)),                           
SQTYDEL =0,                           
SAMTDEL =SUM(CD_DELSELLBROKERAGE                     
       + (CASE WHEN SERVICE_CHRG = 1                           
                THEN CD_DELSELLSERTAX                              
  ELSE 0                    
           END)),                           
PBROKTRD =  SUM(CD_TRDBUYBROKERAGE),                           
SBROKTRD =  SUM(CD_TRDSELLBROKERAGE),                    
PBROKDEL =  SUM(CD_DELBUYBROKERAGE),                    
SBROKDEL = SUM(CD_DELSELLBROKERAGE),                    
FAMILY,FAMILYNAME='',TERMINAL_ID='0',CLIENTTYPE=CL_TYPE,TRADETYPE='S',TRADER,SUB_BROKER,BRANCH_CD,MEMBERCODE,                          
PAMT = SUM(CD_TRDBUYBROKERAGE+ CD_DELBUYBROKERAGE                    
       + (CASE WHEN SERVICE_CHRG = 1                           
                THEN CD_TRDBUYSERTAX+CD_DELBUYSERTAX                              
  ELSE 0                    
           END)),                            
SAMT = SUM(CD_TRDSELLBROKERAGE+ CD_DELSELLBROKERAGE                    
       + (CASE WHEN SERVICE_CHRG = 1                           
                THEN CD_TRDSELLSERTAX+CD_DELSELLSERTAX                              
  ELSE 0                    
           END)),                            
PRATE = 0,                    
SRATE = 0,                    
TRDAMT = 0,                    
DELAMT =0,                           
SERINEX=SERVICE_CHRG,                          
SERVICE_TAX=SUM(CD_TRDBUYSERTAX+CD_DELBUYSERTAX+CD_TRDSELLSERTAX+CD_DELSELLSERTAX ),                          
EXSERVICE_TAX= SUM(CASE WHEN SERVICE_CHRG = 2                           
        THEN (CD_TRDBUYSERTAX+CD_DELBUYSERTAX+CD_TRDSELLSERTAX+CD_DELSELLSERTAX )                          
        ELSE 0                           
   END),                           
TURN_TAX = 0,                          
SEBI_TAX =0,                            
INS_CHRG =0,                          
BROKER_CHRG =0,                          
OTHER_CHRG =0,                            
REGION, START_DATE='', END_DATE='', UPDATE_DATE=LEFT(CONVERT(VARCHAR,GETDATE(),109),11), STATUS_NAME=@STATUSNAME_L,                          
EXCHANGE='NSE',SEGMENT='CAPITAL',MEMBERTYPE=MEMBERCODE,CompanyName=C1.L_STATE,DUMMY1='',DUMMY2='',DUMMY3='',DUMMY4=0,DUMMY5=0, AREA=ISNULL(AREA,''),              
PTRDRATE = 0, STRDRATE = 0, PDELRATE = 0, SDELRATE = 0                
FROM CHARGES_DETAIL S, #CLIENT2 C2, OWNER,#CLIENT1  C1                           
WHERE C2.PARTY_CODE = S.CD_PARTY_CODE AND C1.CL_CODE = C2.CL_CODE                          
AND S.CD_SETT_NO = @SETT_NO_L AND S.CD_SETT_TYPE = @SETT_TYPE_L                          
GROUP BY CD_SETT_NO,CD_SETT_TYPE,S.CD_PARTY_CODE,C1.Short_Name,S.CD_SCRIP_CD,S.CD_SERIES,LEFT(CONVERT(VARCHAR,S.CD_SAUDA_DATE,109),11),                          
C1.FAMILY,TRADER,SUB_BROKER,MEMBERCODE,C1.L_STATE,SERVICE_CHRG,BRANCH_CD,CL_TYPE, REGION, AREA                
                              
                                
INSERT INTO #CMBILLVALAN                     
                                
SELECT S.SETT_NO,S.SETT_TYPE,BILLNO,S.CONTRACTNO,S.PARTY_CODE,PARTY_NAME= C1.Short_Name,S.SCRIP_CD,S.SERIES,                                
SCRIP_NAME='',ISIN='',SAUDA_DATE=LEFT(CONVERT(VARCHAR,S.SAUDA_DATE,109),11),                                
PQTYTRD = SUM(CASE WHEN BILLNO > 0                                 
             THEN (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2                                 
          THEN TRADEQTY                                
          ELSE 0                                 
     END )                                 
      ELSE (CASE WHEN SELL_BUY = 1 AND SETTFLAG = 2                                 
          THEN TRADEQTY                                 
          ELSE 0                                 
     END )                                 
      END),                                 
PAMTTRD = SUM(CASE WHEN BILLNO > 0                                 
             THEN (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2                                 
        THEN (CASE WHEN SERVICE_CHRG = 1                                 
                           THEN TRADEQTY * N_NETRATE + NSERTAX                                   
                  ELSE TRADEQTY * N_NETRATE                                 
                  END )                                
          ELSE 0                                 
     END )                                 
      ELSE (CASE WHEN SELL_BUY = 1 AND SETTFLAG = 2                                 
        THEN (CASE WHEN SERVICE_CHRG = 1                                 
                           THEN TRADEQTY * N_NETRATE + NSERTAX                                   
                           ELSE TRADEQTY * N_NETRATE                                 
                  END )                                
          ELSE 0                                 
     END )                                 
      END),                                 
PQTYDEL = SUM(CASE WHEN BILLNO > 0        
             THEN (CASE WHEN SELL_BUY = 1 AND BILLFLAG IN (1,4)                                 
          THEN TRADEQTY                                
          ELSE 0                                 
     END )                                 
      ELSE (CASE WHEN SELL_BUY = 1 AND SETTFLAG IN (1,4)                                
          THEN TRADEQTY                                 
          ELSE 0                                 
     END )                                 
      END),                                 
PAMTDEL = SUM(CASE WHEN BILLNO > 0                                 
             THEN (CASE WHEN SELL_BUY = 1 AND BILLFLAG IN (1,4)                                
        THEN (CASE WHEN SERVICE_CHRG = 1                                 
                           THEN TRADEQTY * N_NETRATE + NSERTAX                                   
                           ELSE TRADEQTY * N_NETRATE                                 
                  END )                                
          ELSE 0                                 
     END )         
      ELSE (CASE WHEN SELL_BUY = 1 AND SETTFLAG IN (1,4)                                
        THEN (CASE WHEN SERVICE_CHRG = 1                                 
                        THEN TRADEQTY * N_NETRATE + NSERTAX                                   
                      ELSE TRADEQTY * N_NETRATE                               
                  END )                                
          ELSE 0                                 
     END )                                 
      END),                                 
SQTYTRD = SUM(CASE WHEN BILLNO > 0                                 
             THEN (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3                                
          THEN TRADEQTY                                
          ELSE 0                                 
     END )                                 
      ELSE (CASE WHEN SELL_BUY = 2 AND SETTFLAG = 3                                 
          THEN TRADEQTY                                 
          ELSE 0                                 
     END )                                 
      END),                                 
SAMTTRD = SUM(CASE WHEN BILLNO > 0                              
             THEN (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3                                 
        THEN (CASE WHEN SERVICE_CHRG = 1                                 
                           THEN TRADEQTY * N_NETRATE - NSERTAX                                   
                           ELSE TRADEQTY * N_NETRATE                                 
                  END )                                
          ELSE 0                                 
     END )                                 
      ELSE (CASE WHEN SELL_BUY = 2 AND SETTFLAG = 3                                 
        THEN (CASE WHEN SERVICE_CHRG = 1                                 
                           THEN TRADEQTY * N_NETRATE - NSERTAX                                   
                           ELSE TRADEQTY * N_NETRATE                                 
                  END )                                
          ELSE 0                                 
     END )                                 
      END),                                 
SQTYDEL = SUM(CASE WHEN BILLNO > 0                                 
             THEN (CASE WHEN SELL_BUY = 2 AND BILLFLAG IN (1,5)               
          THEN TRADEQTY                                
          ELSE 0                                 
     END )                                 
      ELSE (CASE WHEN SELL_BUY = 2 AND SETTFLAG IN (1,5)                                
          THEN TRADEQTY                            
          ELSE 0                                 
     END )                               
      END),                                 
SAMTDEL = SUM(CASE WHEN BILLNO > 0                                 
             THEN (CASE WHEN SELL_BUY = 2 AND BILLFLAG IN (1,5)                                
        THEN (CASE WHEN SERVICE_CHRG = 1                                 
                           THEN TRADEQTY * N_NETRATE - NSERTAX                                   
                           ELSE TRADEQTY * N_NETRATE                                 
                  END )                                
          ELSE 0                                 
     END )                                 
      ELSE (CASE WHEN SELL_BUY = 2 AND SETTFLAG IN (1,5)                                
        THEN (CASE WHEN SERVICE_CHRG = 1                                 
                           THEN TRADEQTY * N_NETRATE - NSERTAX               
                           ELSE TRADEQTY * N_NETRATE                                 
                  END )                                
          ELSE 0                                 
     END )                                 
      END),                                 
PBROKTRD = SUM(CASE WHEN BILLNO > 0                                 
         THEN (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2                                 
                      THEN TRADEQTY*NBROKAPP                                
                      ELSE 0       
            END)                                
  ELSE                                
            (CASE WHEN SELL_BUY = 1 AND SETTFLAG = 2                                
                      THEN TRADEQTY*NBROKAPP                                
                ELSE 0                                 
            END)                                
              END),                                 
SBROKTRD = SUM(CASE WHEN BILLNO > 0                                 
         THEN (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3                                
                      THEN TRADEQTY*NBROKAPP                                
                      ELSE 0                                 
            END)                                
  ELSE                                
            (CASE WHEN SELL_BUY = 2 AND SETTFLAG = 3                                
                      THEN TRADEQTY*NBROKAPP                                
                      ELSE 0                                 
            END)                                
END),                                
PBROKDEL = SUM(CASE WHEN BILLNO > 0                                 
         THEN (CASE WHEN SELL_BUY = 1 AND BILLFLAG IN (1,4)                                 
                      THEN TRADEQTY*NBROKAPP                                
                      ELSE 0                                 
            END)                                
  ELSE                                
            (CASE WHEN SELL_BUY = 1 AND SETTFLAG IN (1,4)                                
     THEN TRADEQTY*NBROKAPP                                
                      ELSE 0                                 
           END)                                
              END),                                
SBROKDEL =  SUM(CASE WHEN BILLNO > 0                                 
         THEN (CASE WHEN SELL_BUY = 2 AND BILLFLAG IN (1,5)                                 
                      THEN TRADEQTY*NBROKAPP                                
                      ELSE 0                                 
            END)                                
  ELSE                                
            (CASE WHEN SELL_BUY = 2 AND SETTFLAG IN (1,5)                                
                      THEN TRADEQTY*NBROKAPP                                
                      ELSE 0                                 
            END)                                
              END),                                
FAMILY,FAMILYNAME='',TERMINAL_ID='0',CLIENTTYPE=CL_TYPE,TRADETYPE='I',TRADER,SUB_BROKER,BRANCH_CD,PARTIPANTCODE,                  
PAMT = ISNULL(SUM(CASE WHEN SELL_BUY = 1                                 
      THEN (CASE WHEN SERVICE_CHRG = 2                                 
                 THEN TRADEQTY * N_NETRATE     
          ELSE TRADEQTY * N_NETRATE + NSERTAX                                
     END )                                 
   ELSE 0                                 
   END),0),                                  
SAMT = ISNULL(SUM(CASE WHEN SELL_BUY = 2                                 
      THEN (CASE WHEN SERVICE_CHRG = 2                                 
                 THEN TRADEQTY * N_NETRATE                                   
          ELSE TRADEQTY * N_NETRATE - NSERTAX                                
     END )                                 
   ELSE 0                                 
   END),0),                                  
PRATE = 0,                                  
SRATE = 0,                                
TRDAMT = SUM(TRADEQTY*S.MARKETRATE),                                 
DELAMT = SUM(TRADEQTY*S.MARKETRATE),                                 
SERINEX = SERVICE_CHRG,                                
SERVICE_TAX = SUM(NSERTAX),                                
EXSERVICE_TAX = SUM(CASE WHEN SERVICE_CHRG = 2                                 
        THEN (NSERTAX)                                
        ELSE 0                                 
   END),                                
TURN_TAX = SUM(CASE WHEN TURNOVER_TAX = 1                                       
       THEN TURN_TAX                  
            ELSE 0                                       
         END),                                
SEBI_TAX = 0,                                  
INS_CHRG = SUM(CASE WHEN DISPCHARGE = 1                                 
   THEN (CASE WHEN INSURANCE_CHRG = 1                                 
       THEN (INS_CHRG)                                   
            ELSE 0                                 
         END)                                    
   ELSE 0                                 
     END),                                
BROKER_CHRG = SUM(CASE WHEN BROKERNOTE = 1                                       
       THEN BROKER_CHRG                  
            ELSE 0                                       
         END),                                
OTHER_CHRG = 0,                                  
REGION=ISNULL(REGION,''), START_DATE='', END_DATE='', UPDATE_DATE=LEFT(CONVERT(VARCHAR,GETDATE(),109),11), STATUS_NAME=@STATUSNAME_L,                                
EXCHANGE='NSE',SEGMENT='CAPITAL',MEMBERTYPE=MEMBERCODE,CompanyName=C1.L_STATE,DUMMY1='',DUMMY2='',DUMMY3='',DUMMY4=0,DUMMY5=0, AREA = ISNULL(AREA,''),              
PTRDRATE = 0,              
STRDRATE = 0,              
PDELRATE = SUM(CASE               
                WHEN SELL_BUY = 1 then             
                     TRADEQTY * S.MARKETRATE              
                ELSE 0              
              END),              
SDELRATE = SUM(CASE               
                WHEN SELL_BUY = 2              
                     THEN TRADEQTY * S.MARKETRATE              
                ELSE 0              
              END)              
FROM ISETTLEMENT_VALAN S , #CLIENT2 C2, OWNER,#CLIENT1  C1                                 
WHERE S.SETT_NO = @SETT_NO_L AND S.SETT_TYPE = @SETT_TYPE_L                                 
AND AUCTIONPART NOT IN ('AP','AR','FP','FS','FL','FC')              
AND TRADEQTY > 0                      
AND C2.PARTY_CODE = S.PARTY_CODE AND C1.CL_CODE = C2.CL_CODE                                  
GROUP BY SETT_NO,SETT_TYPE,CONTRACTNO,BILLNO,S.PARTY_CODE,C1.Short_Name,S.SCRIP_CD,S.SERIES,LEFT(CONVERT(VARCHAR,S.SAUDA_DATE,109),11),                                
C1.FAMILY,TRADER,SUB_BROKER,PARTIPANTCODE,MEMBERCODE,C1.L_STATE,                                
SERVICE_CHRG,BRANCH_CD,CL_TYPE, DUMMY8, DUMMY9, DUMMY10, REGION, AREA                              
        
UPDATE #CMBILLVALAN SET SERVICE_TAX = 0, EXSERVICE_TAX = 0              
WHERE EXSERVICE_TAX > 0              
              
  UPDATE #CMBILLVALAN SET         
  INS_CHRG = ROUND(TOTALSTT,0),             
  SBROKTRD = 0,        
  PBROKTRD=0,              
  PBROKDEL = PBROKTRD+PBROKDEL-ROUND(PSTTDEL,0),               
  SBROKDEL = SBROKTRD+SBROKDEL-ROUND(SSTTDEL+SSTTTRD,0)        
  /*              
  SET    INS_CHRG = (CASE               
                       WHEN SBROKTRD - SSTTTRD >= 0              
                            AND (CASE               
                                   WHEN SBROKDEL = 0 THEN PBROKDEL - (TOTALSTT - ROUND(TOTALSTT,0)) - PSTTDEL              
                                   ELSE PBROKDEL - PSTTDEL              
                                 END) >= 0              
                        AND (CASE               
                                   WHEN SBROKDEL > 0 THEN SBROKDEL - (TOTALSTT - ROUND(TOTALSTT,0)) - SSTTDEL              
                                   ELSE 0              
                                 END) >= 0 THEN ROUND(TOTALSTT,0)              
                       ELSE 0              
                     END),              
         SBROKTRD = (CASE               
                       WHEN SBROKTRD - SSTTTRD >= 0              
                            AND (CASE               
   WHEN SBROKDEL = 0 THEN PBROKDEL - (TOTALSTT - ROUND(TOTALSTT,0)) - PSTTDEL              
                                   ELSE PBROKDEL - PSTTDEL              
                                 END) >= 0              
                            AND (CASE               
                                   WHEN SBROKDEL > 0 THEN SBROKDEL - (TOTALSTT - ROUND(TOTALSTT,0)) - SSTTDEL              
                                   ELSE 0              
                                 END) >= 0 THEN SBROKTRD - SSTTTRD              
                       ELSE SBROKTRD              
                     END),              
         PBROKDEL = (CASE               
                       WHEN SBROKTRD - SSTTTRD >= 0              
                   AND (CASE               
                                   WHEN SBROKDEL = 0 THEN PBROKDEL - (TOTALSTT - ROUND(TOTALSTT,0)) - PSTTDEL              
                                   ELSE PBROKDEL - PSTTDEL              
                                 END) >= 0              
                    AND (CASE               
                                   WHEN SBROKDEL > 0 THEN SBROKDEL - (TOTALSTT - ROUND(TOTALSTT,0)) - SSTTDEL              
                                   ELSE 0              
                                 END) >= 0 THEN (CASE               
                                                   WHEN SBROKDEL = 0 THEN PBROKDEL - (TOTALSTT - ROUND(TOTALSTT,0)) - PSTTDEL              
                                                   ELSE PBROKDEL - PSTTDEL              
                                                 END)              
                       ELSE PBROKDEL              
                     END),           
/*           
         SBROKDEL = (CASE               
                       WHEN SBROKTRD - SSTTTRD >= 0              
                            AND (CASE               
                                   WHEN SBROKDEL = 0 THEN PBROKDEL - (TOTALSTT - ROUND(TOTALSTT,0)) - PSTTDEL              
                                   ELSE PBROKDEL - PSTTDEL              
                                 END) >= 0              
                            AND (CASE               
                                   WHEN SBROKDEL > 0 THEN SBROKDEL - (TOTALSTT - ROUND(TOTALSTT,0)) - SSTTDEL              
                                   ELSE 0              
                        END) >= 0 THEN (CASE               
                                                   WHEN SBROKDEL > 0 THEN SBROKDEL - (TOTALSTT - ROUND(TOTALSTT,0)) - SSTTDEL              
                                                   ELSE 0              
                                                 END)              
                       ELSE SBROKDEL              
                     END)              
*/        
  SBROKDEL = (CASE               
                       WHEN SBROKTRD - SSTTTRD >= 0              
                            AND (CASE               
                                   WHEN SBROKDEL = 0 THEN PBROKDEL - (TOTALSTT - ROUND(TOTALSTT,0)) - PSTTDEL              
                                   ELSE PBROKDEL - PSTTDEL              
                                 END) >= 0              
                            AND (CASE               
                                   WHEN SBROKDEL > 0 THEN SBROKDEL - (case when (TOTALSTT - ROUND(TOTALSTT,0)) > 0 then -(TOTALSTT - ROUND(TOTALSTT,0)) else (TOTALSTT - ROUND(TOTALSTT,0)) end) - SSTTDEL              
                                   ELSE 0              
                                 END) >= 0 THEN (CASE               
                                           WHEN SBROKDEL > 0 THEN SBROKDEL - (case when (TOTALSTT - ROUND(TOTALSTT,0)) > 0 then -(TOTALSTT - ROUND(TOTALSTT,0)) else (TOTALSTT - ROUND(TOTALSTT,0)) end) - SSTTDEL              
                                                   ELSE 0              
                                                 END)              
                       ELSE SBROKDEL              
                     END)        
  */        
  FROM   STT_CLIENTDETAIL              
  WHERE  #CMBILLVALAN.SETT_NO = @SETT_NO_L              
         AND #CMBILLVALAN.SETT_TYPE = @SETT_TYPE_L              
         AND #CMBILLVALAN.SETT_NO = STT_CLIENTDETAIL.SETT_NO              
         AND #CMBILLVALAN.SETT_TYPE = STT_CLIENTDETAIL.SETT_TYPE              
         AND #CMBILLVALAN.PARTY_CODE = STT_CLIENTDETAIL.PARTY_CODE              
         AND #CMBILLVALAN.SCRIP_CD = STT_CLIENTDETAIL.SCRIP_CD              
         AND #CMBILLVALAN.SERIES = STT_CLIENTDETAIL.SERIES              
         AND LEFT(#CMBILLVALAN.SAUDA_DATE,11) = LEFT(STT_CLIENTDETAIL.SAUDA_DATE,11)              
         AND TRADETYPE IN ('I','S')              
         --AND CLIENTTYPE = 'INS'              
         AND INS_CHRG = 0              
         AND SERVICE_TAX = 0              
         AND (PBROKTRD + SBROKTRD + PBROKDEL + SBROKDEL) > 0              
         AND (#CMBILLVALAN.PQTYTRD + #CMBILLVALAN.SQTYTRD + #CMBILLVALAN.PQTYDEL + #CMBILLVALAN.SQTYDEL) > 0              
              
SELECT PARTY_CODE, C1.BRANCH_CD INTO #CL FROM #CLIENT1 C1, #CLIENT2 C2                                 
WHERE C1.CL_CODE = C2.CL_CODE                                
AND L_STATE = 'JAMMU AND KASHMIR'             
            
IF @SAUDA_DATE >= 'OCT  1 2012' AND @SAUDA_DATE < 'OCT  1 2014'            
BEGIN              
 INSERT INTO #CL              
 SELECT CL_CODE, BRANCH_CD FROM #CLIENT1              
 WHERE ( CL_TYPE IN ('NON', 'NRI')                  
 OR CL_STATUS = 'FII' )                
END            
                                                  
  UPDATE #CMBILLVALAN              
  SET    BROKER_CHRG = (CASE               
                       WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE+ STRDRATE) * @PROBROKER_CHRG / 100 + (PDELRATE) * @PROBROKER_CHRG / 100 + (SDELRATE) * @PROBROKER_CHRG / 100              
                       ELSE (PTRDRATE + STRDRATE) * @TRDBROKER_CHRG / 100 + (PDELRATE) * @DELBROKER_CHRG / 100 + (SDELRATE) * @DELBROKER_CHRG / 100              
                     END),              
         PBROKTRD = PBROKTRD - ((CASE WHEN PBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROBROKER_CHRG / 100              
                                  ELSE (PTRDRATE) * @TRDBROKER_CHRG / 100              
                                END) >= 0               
        THEN  (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROBROKER_CHRG / 100              
      ELSE (PTRDRATE) * @TRDBROKER_CHRG / 100              
                                END)              
      ELSE 0 END) +               
      (CASE WHEN SBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROBROKER_CHRG / 100              
                                  ELSE (STRDRATE) * @TRDBROKER_CHRG / 100              
                                END) < 0 THEN (CASE               
                   WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROBROKER_CHRG / 100              
                                  ELSE (STRDRATE) * @TRDBROKER_CHRG / 100              
                                END)              
       ELSE 0 END)),              
         SBROKTRD = SBROKTRD - ((CASE WHEN SBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROBROKER_CHRG / 100              
                                  ELSE (STRDRATE) * @TRDBROKER_CHRG / 100              
                                END) >= 0               
        THEN  (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROBROKER_CHRG / 100              
                                  ELSE (STRDRATE) * @TRDBROKER_CHRG / 100              
                                END)              
      ELSE 0 END) +               
      (CASE WHEN PBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROBROKER_CHRG / 100              
                                  ELSE (PTRDRATE) * @TRDBROKER_CHRG / 100              
                                END) < 0 THEN (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROBROKER_CHRG / 100              
ELSE (PTRDRATE) * @TRDBROKER_CHRG / 100              
                                END)              
       ELSE 0 END)),              
         PBROKDEL = PBROKDEL - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PDELRATE) * @PROBROKER_CHRG / 100              
                                  ELSE (PDELRATE) * @DELBROKER_CHRG / 100              
                                END),              
         SBROKDEL = SBROKDEL - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (SDELRATE) * @PROBROKER_CHRG / 100              
                                  ELSE (SDELRATE) * @DELBROKER_CHRG / 100              
                                END)              
  WHERE  #CMBILLVALAN.SETT_NO = @SETT_NO_L              
         AND #CMBILLVALAN.SETT_TYPE = @SETT_TYPE_L              
         AND TRADETYPE IN ('I','S')              
         --AND CLIENTTYPE = 'INS'              
         AND BROKER_CHRG = 0              
         AND (PBROKTRD - ((CASE WHEN PBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROBROKER_CHRG / 100              
                                  ELSE (PTRDRATE) * @TRDBROKER_CHRG / 100              
                                END) >= 0               
        THEN  (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROBROKER_CHRG / 100              
                                  ELSE (PTRDRATE) * @TRDBROKER_CHRG / 100              
                                END)              
      ELSE 0 END) +               
      (CASE WHEN SBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROBROKER_CHRG / 100              
                                  ELSE (STRDRATE) * @TRDBROKER_CHRG / 100              
                                END) < 0 THEN (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROBROKER_CHRG / 100              
                                  ELSE (STRDRATE) * @TRDBROKER_CHRG / 100              
                                END)              
       ELSE 0 END))) >= 0              
         AND (SBROKTRD - ((CASE WHEN SBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROBROKER_CHRG / 100              
                                  ELSE (STRDRATE) * @TRDBROKER_CHRG / 100              
                                END) >= 0               
        THEN  (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROBROKER_CHRG / 100              
                                  ELSE (STRDRATE) * @TRDBROKER_CHRG / 100              
  END)              
      ELSE 0 END) +               
      (CASE WHEN PBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROBROKER_CHRG / 100              
                                  ELSE (PTRDRATE) * @TRDBROKER_CHRG / 100              
                                END) < 0 THEN (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROBROKER_CHRG / 100              
                                  ELSE (PTRDRATE) * @TRDBROKER_CHRG / 100              
                                END)              
       ELSE 0 END))) >= 0              
         AND (PBROKDEL - (CASE          
                            WHEN CLIENTTYPE = 'PRO' THEN (PDELRATE) * @PROBROKER_CHRG / 100              
                            ELSE (PDELRATE) * @DELBROKER_CHRG / 100              
                          END)) >= 0              
         AND (SBROKDEL - (CASE               
                            WHEN CLIENTTYPE = 'PRO' THEN (SDELRATE) * @PROBROKER_CHRG / 100              
                            ELSE (SDELRATE) * @DELBROKER_CHRG / 100              
                          END)) >= 0              
         AND (PQTYTRD + SQTYTRD + PQTYDEL + SQTYDEL) > 0
         AND NOT EXISTS (SELECT C.PARTY_CODE FROM #CMBILLVALAN C where C.SETT_NO = @SETT_NO_L              
         AND C.SETT_TYPE = @SETT_TYPE_L              
         AND C.TRADETYPE IN ('I','S') and C.broker_chrg > 0 AND #CMBILLVALAN.party_code = c.PARTY_CODE)                                        
   --AND SERVICE_TAX = 0         
                                                                                       
  UPDATE #CMBILLVALAN              
  SET    SERVICE_TAX = (PBROKTRD + SBROKTRD + PBROKDEL + SBROKDEL) - PBROKTRD * 100               
       / (100 + GLOBALS.SERVICE_TAX) - SBROKTRD * 100 / (100 + GLOBALS.SERVICE_TAX) - PBROKDEL * 100               
       / (100 + GLOBALS.SERVICE_TAX) - SBROKDEL * 100 / (100 + GLOBALS.SERVICE_TAX),              
         PBROKTRD = PBROKTRD * 100 / (100 + GLOBALS.SERVICE_TAX),              
         SBROKTRD = SBROKTRD * 100 / (100 + GLOBALS.SERVICE_TAX),              
         PBROKDEL = PBROKDEL * 100 / (100 + GLOBALS.SERVICE_TAX),              
         SBROKDEL = SBROKDEL * 100 / (100 + GLOBALS.SERVICE_TAX)              
  FROM   GLOBALS              
  WHERE  #CMBILLVALAN.SETT_NO = @SETT_NO_L              
         AND #CMBILLVALAN.SETT_TYPE = @SETT_TYPE_L              
         AND TRADETYPE IN ('I','S')              
         --AND CLIENTTYPE = 'INS'              
         AND #CMBILLVALAN.SERVICE_TAX = 0              
         AND (PBROKTRD + SBROKTRD + PBROKDEL + SBROKDEL) > 0              
         AND SAUDA_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT              
         AND PARTY_CODE NOT IN (SELECT PARTY_CODE FROM #CL)              
               
  UPDATE #CMBILLVALAN              
  SET    TURN_TAX = (CASE               
                       WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE+ STRDRATE) * @PROTURNOVER_TAX / 100 + (PDELRATE) * @PROTURNOVER_TAX / 100 + (SDELRATE) * @PROTURNOVER_TAX / 100              
                       ELSE (PTRDRATE + STRDRATE) * @TRDTURNOVER_TAX / 100 + (PDELRATE) * @DELTURNOVER_TAX / 100 + (SDELRATE) * @DELTURNOVER_TAX / 100              
                     END),              
         PBROKTRD = PBROKTRD - ((CASE WHEN PBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROTURNOVER_TAX / 100              
                                  ELSE (PTRDRATE) * @TRDTURNOVER_TAX / 100              
                                END) >= 0               
        THEN  (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROTURNOVER_TAX / 100              
                                  ELSE (PTRDRATE) * @TRDTURNOVER_TAX / 100              
                                END)              
      ELSE 0 END) +               
      (CASE WHEN SBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROTURNOVER_TAX / 100           
                       ELSE (STRDRATE) * @TRDTURNOVER_TAX / 100              
                                END) < 0 THEN (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROTURNOVER_TAX / 100              
                                  ELSE (STRDRATE) * @TRDTURNOVER_TAX / 100              
                                END)              
       ELSE 0 END)),              
         SBROKTRD = SBROKTRD - ((CASE WHEN SBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROTURNOVER_TAX / 100              
                                  ELSE (STRDRATE) * @TRDTURNOVER_TAX / 100              
                                END) >= 0               
        THEN  (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROTURNOVER_TAX / 100              
                                  ELSE (STRDRATE) * @TRDTURNOVER_TAX / 100              
                                END)              
      ELSE 0 END) +               
      (CASE WHEN PBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROTURNOVER_TAX / 100              
                                  ELSE (PTRDRATE) * @TRDTURNOVER_TAX / 100              
                                END) < 0 THEN (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROTURNOVER_TAX / 100              
                                  ELSE (PTRDRATE) * @TRDTURNOVER_TAX / 100              
                                END)              
       ELSE 0 END)),              
         PBROKDEL = PBROKDEL - (CASE               
  WHEN CLIENTTYPE = 'PRO' THEN (PDELRATE) * @PROTURNOVER_TAX / 100              
                                  ELSE (PDELRATE) * @DELTURNOVER_TAX / 100              
                                END),              
         SBROKDEL = SBROKDEL - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (SDELRATE) * @PROTURNOVER_TAX / 100              
                                  ELSE (SDELRATE) * @DELTURNOVER_TAX / 100              
                                END)              
  WHERE  #CMBILLVALAN.SETT_NO = @SETT_NO_L              
         AND #CMBILLVALAN.SETT_TYPE = @SETT_TYPE_L              
         AND TRADETYPE IN ('I','S')              
         --AND CLIENTTYPE = 'INS'              
         AND TURN_TAX = 0              
         AND (PBROKTRD - ((CASE WHEN PBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROTURNOVER_TAX / 100              
                                  ELSE (PTRDRATE) * @TRDTURNOVER_TAX / 100              
                                END) >= 0               
        THEN  (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROTURNOVER_TAX / 100              
                                  ELSE (PTRDRATE) * @TRDTURNOVER_TAX / 100              
                                END)              
      ELSE 0 END) +               
      (CASE WHEN SBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROTURNOVER_TAX / 100              
                                  ELSE (STRDRATE) * @TRDTURNOVER_TAX / 100              
                                END) < 0 THEN (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROTURNOVER_TAX / 100              
                                  ELSE (STRDRATE) * @TRDTURNOVER_TAX / 100              
                                END)              
       ELSE 0 END))) >= 0              
         AND (SBROKTRD - ((CASE WHEN SBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROTURNOVER_TAX / 100              
                                  ELSE (STRDRATE) * @TRDTURNOVER_TAX / 100              
                                END) >= 0               
        THEN  (CASE               
        WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROTURNOVER_TAX / 100              
                                  ELSE (STRDRATE) * @TRDTURNOVER_TAX / 100              
                                END)              
      ELSE 0 END) +               
      (CASE WHEN PBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROTURNOVER_TAX / 100              
                                  ELSE (PTRDRATE) * @TRDTURNOVER_TAX / 100              
                                END) < 0 THEN (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROTURNOVER_TAX / 100              
                                  ELSE (PTRDRATE) * @TRDTURNOVER_TAX / 100              
                                END)              
       ELSE 0 END))) >= 0              
         AND (PBROKDEL - (CASE               
           WHEN CLIENTTYPE = 'PRO' THEN (PDELRATE) * @PROTURNOVER_TAX / 100              
                            ELSE (PDELRATE) * @DELTURNOVER_TAX / 100              
                          END)) >= 0              
         AND (SBROKDEL - (CASE               
                            WHEN CLIENTTYPE = 'PRO' THEN (SDELRATE) * @PROTURNOVER_TAX / 100              
                            ELSE (SDELRATE) * @DELTURNOVER_TAX / 100              
                          END)) >= 0              
         AND (PQTYTRD + SQTYTRD + PQTYDEL + SQTYDEL) > 0                                        
          
  UPDATE #CMBILLVALAN              
  SET    SEBI_TAX = (CASE               
                       WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE+ STRDRATE) * @PROSEBI_TAX / 100 + (PDELRATE) * @PROSEBI_TAX / 100 + (SDELRATE) * @PROSEBI_TAX / 100              
                       ELSE (PTRDRATE + STRDRATE) * @TRDSEBI_TAX / 100 + (PDELRATE) * @DELSEBI_TAX / 100 + (SDELRATE) * @DELSEBI_TAX / 100              
                     END),              
         PBROKTRD = PBROKTRD - ((CASE WHEN PBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROSEBI_TAX / 100              
                                  ELSE (PTRDRATE) * @TRDSEBI_TAX / 100              
                                END) >= 0               
        THEN  (CASE               
                             WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROSEBI_TAX / 100              
                                  ELSE (PTRDRATE) * @TRDSEBI_TAX / 100              
                                END)              
      ELSE 0 END) +               
      (CASE WHEN SBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROSEBI_TAX / 100              
                                  ELSE (STRDRATE) * @TRDSEBI_TAX / 100              
                                END) < 0 THEN (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROSEBI_TAX / 100              
                                  ELSE (STRDRATE) * @TRDSEBI_TAX / 100              
                                END)              
       ELSE 0 END)),              
         SBROKTRD = SBROKTRD - ((CASE WHEN SBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROSEBI_TAX / 100              
                                  ELSE (STRDRATE) * @TRDSEBI_TAX / 100              
                                END) >= 0               
        THEN  (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROSEBI_TAX / 100              
                                  ELSE (STRDRATE) * @TRDSEBI_TAX / 100              
                                END)              
      ELSE 0 END) +               
      (CASE WHEN PBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROSEBI_TAX / 100              
                                  ELSE (PTRDRATE) * @TRDSEBI_TAX / 100              
                                END) < 0 THEN (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROSEBI_TAX / 100              
                                  ELSE (PTRDRATE) * @TRDSEBI_TAX / 100              
                                END)              
       ELSE 0 END)),              
         PBROKDEL = PBROKDEL - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PDELRATE) * @PROSEBI_TAX / 100              
                                  ELSE (PDELRATE) * @DELSEBI_TAX / 100              
                                END),              
         SBROKDEL = SBROKDEL - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (SDELRATE) * @PROSEBI_TAX / 100              
                                  ELSE (SDELRATE) * @DELSEBI_TAX / 100              
   END)              
  WHERE  #CMBILLVALAN.SETT_NO = @SETT_NO_L              
         AND #CMBILLVALAN.SETT_TYPE = @SETT_TYPE_L              
         AND TRADETYPE IN ('I','S')              
         --AND CLIENTTYPE = 'INS'              
         AND SEBI_TAX = 0              
         AND (PBROKTRD - ((CASE WHEN PBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROSEBI_TAX / 100              
                                  ELSE (PTRDRATE) * @TRDSEBI_TAX / 100              
                                END) >= 0               
        THEN  (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROSEBI_TAX / 100              
                                  ELSE (PTRDRATE) * @TRDSEBI_TAX / 100              
                                END)              
      ELSE 0 END) +               
      (CASE WHEN SBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROSEBI_TAX / 100              
                                  ELSE (STRDRATE) * @TRDSEBI_TAX / 100              
                                END) < 0 THEN (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROSEBI_TAX / 100              
                                  ELSE (STRDRATE) * @TRDSEBI_TAX / 100              
                                END)              
       ELSE 0 END))) >= 0              
         AND (SBROKTRD - ((CASE WHEN SBROKTRD - (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROSEBI_TAX / 100              
                                  ELSE (STRDRATE) * @TRDSEBI_TAX / 100              
                    END) >= 0               
        THEN  (CASE               
                                  WHEN CLIENTTYPE = 'PRO' THEN (STRDRATE) * @PROSEBI_TAX / 100              
                                  ELSE (STRDRATE) * @TRDSEBI_TAX / 100              
   END)              
      ELSE 0 END) +               
      (CASE WHEN PBROKTRD - (CASE               
    WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROSEBI_TAX / 100              
                                  ELSE (PTRDRATE) * @TRDSEBI_TAX / 100              
                                END) < 0 THEN (CASE               
    WHEN CLIENTTYPE = 'PRO' THEN (PTRDRATE) * @PROSEBI_TAX / 100              
                                  ELSE (PTRDRATE) * @TRDSEBI_TAX / 100              
                                END)              
       ELSE 0 END))) >= 0              
         AND (PBROKDEL - (CASE               
                            WHEN CLIENTTYPE = 'PRO' THEN (PDELRATE) * @PROSEBI_TAX / 100              
                            ELSE (PDELRATE) * @DELSEBI_TAX / 100              
                          END)) >= 0              
         AND (SBROKDEL - (CASE               
                            WHEN CLIENTTYPE = 'PRO' THEN (SDELRATE) * @PROSEBI_TAX / 100              
                            ELSE (SDELRATE) * @DELSEBI_TAX / 100              
                          END)) >= 0              
                                
INSERT INTO PROCESS_MONITOR VALUES ('VALAN GENERATION',@SETT_NO_L + @SETT_TYPE_L,'','NSECMVALAN','DONE-INSERT INSTITUTIONAL TRADE FROM ISETTLEMENT_VALAN. RECCOUNT: ' + CONVERT(CHAR,@@ROWCOUNT),'UPDATE SCRIPNAME/SECTOR/TRACK FROM SCRIP1 & 2',GETDATE(),GETDATE())   
       
    
      
        
        
          
            
              
                                
UPDATE #CMBILLVALAN SET SCRIP_NAME = S1.LONG_NAME/*, SECTOR = S2.SECTOR, TRACK = S2.TRACK*/ FROM SCRIP1 S1, SCRIP2 S2                                 
WHERE S1.CO_CODE = S2.CO_CODE AND S1.SERIES = S2.SERIES AND S2.SCRIP_CD = #CMBILLVALAN.SCRIP_CD                          
AND #CMBILLVALAN.SERIES = S2.SERIES                            
                                
INSERT INTO PROCESS_MONITOR VALUES ('VALAN GENERATION',@SETT_NO_L + @SETT_TYPE_L,'','NSECMVALAN','DONE-UPDATE SCRIPNAME/SECTOR/TRACK FROM SCRIP1 & 2. RECCOUNT: ' + CONVERT(CHAR,@@ROWCOUNT),'UPDATE ISIN FROM MULTIISIN',GETDATE(),GETDATE())                     
  
    
      
          
           
                                
UPDATE #CMBILLVALAN SET ISIN = M.ISIN FROM MULTIISIN M                                 
WHERE M.SCRIP_CD = #CMBILLVALAN.SCRIP_CD AND VALID = 1                                 
AND M.SERIES = #CMBILLVALAN.SERIES                                
AND #CMBILLVALAN.SETT_NO = @SETT_NO_L AND #CMBILLVALAN.SETT_TYPE = @SETT_TYPE_L 

  
DECLARE @SAUDA_DATE_NEW varchar(11)
SELECT  @SAUDA_DATE_NEW = START_DATE             
FROM SETT_MST            
WHERE SETT_NO = @SETT_NO_L              
AND SETT_TYPE = @SETT_TYPE_L  
          

UPDATE #CMBILLVALAN SET ISIN = M.ISIN FROM TBL_EXCHG_SCRIP_MAP M                                 
WHERE M.NSE_SCRIP_CD = #CMBILLVALAN.SCRIP_CD --AND VALID = 1                                 
AND M.NSE_SERIES = #CMBILLVALAN.SERIES                                
AND #CMBILLVALAN.SETT_NO = @SETT_NO_L AND #CMBILLVALAN.SETT_TYPE = @SETT_TYPE_L  
AND @SAUDA_DATE_NEW BETWEEN FROM_DATE AND TO_DATE  
AND #CMBILLVALAN.ISIN= ''                            
                             
INSERT INTO PROCESS_MONITOR VALUES ('VALAN GENERATION',@SETT_NO_L + @SETT_TYPE_L,'','NSECMVALAN','DONE-UPDATE ISIN FROM MULTIISIN. RECCOUNT: ' + CONVERT(CHAR,@@ROWCOUNT),'UPDATE FAMILY_NAME FROM #CLIENT1',GETDATE(),GETDATE())                                
                                
UPDATE #CMBILLVALAN SET FAMILY_NAME = C1.Short_Name FROM #CLIENT1 C1                                
WHERE C1.CL_CODE = #CMBILLVALAN.FAMILY                                 
AND #CMBILLVALAN.SETT_NO = @SETT_NO_L AND #CMBILLVALAN.SETT_TYPE = @SETT_TYPE_L                                
AND #CMBILLVALAN.SAUDA_DATE LIKE @SDATE_L + '%'                                
AND #CMBILLVALAN.SCRIP_CD LIKE @SCRIP_CD_L AND #CMBILLVALAN.SERIES LIKE @SERIES_L                                
AND #CMBILLVALAN.PARTY_CODE LIKE @PARTY_CODE_L                                
                                
INSERT INTO PROCESS_MONITOR VALUES ('VALAN GENERATION',@SETT_NO_L + @SETT_TYPE_L,'','NSECMVALAN','DONE-UPDATE FAMILY_NAME FROM #CLIENT1. RECCOUNT: ' + CONVERT(CHAR,@@ROWCOUNT),'UPDATE START/ENDDATE FROM SETT_MST',GETDATE(),GETDATE())                           
 
     
     
                                
UPDATE #CMBILLVALAN SET START_DATE = LEFT(CONVERT(VARCHAR,S.START_DATE,109),11),END_DATE = LEFT(CONVERT(VARCHAR,S.END_DATE,109),11)                                
FROM SETT_MST S WHERE S.SETT_NO = #CMBILLVALAN.SETT_NO AND S.SETT_TYPE = #CMBILLVALAN.SETT_TYPE                                
AND #CMBILLVALAN.SETT_NO = @SETT_NO_L AND #CMBILLVALAN.SETT_TYPE = @SETT_TYPE_L                                
AND #CMBILLVALAN.SAUDA_DATE LIKE @SDATE_L + '%'                                
AND #CMBILLVALAN.SCRIP_CD LIKE @SCRIP_CD_L AND #CMBILLVALAN.SERIES LIKE @SERIES_L                                
AND #CMBILLVALAN.PARTY_CODE LIKE @PARTY_CODE_L                                
                                
INSERT INTO PROCESS_MONITOR VALUES ('VALAN GENERATION',@SETT_NO_L + @SETT_TYPE_L,'','NSECMVALAN','DONE-UPDATE START/ENDDATE FROM SETT_MST. RECCOUNT: ' + CONVERT(CHAR,@@ROWCOUNT),'UPDATE REGION FROM CLIENTSETTINGS',GETDATE(),GETDATE())                         
  
      CREATE NONCLUSTERED INDEX IDX_CMBILLVALAN ON #CMBILLVALAN      
(      
    SETT_NO ASC,  
 SETT_TYPE ASC,  
 SAUDA_DATE ASC,  
 PARTY_CODE ASC,  
 SCRIP_CD ASC,  
 SERIES ASC,  
 TERMINAL_ID ASC,  
 CONTRACTNO ASC,  
 TRADETYPE ASC   
)       
      
        
         
/*                                
UPDATE #CMBILLVALAN SET REGION = CLIENTSETTINGS.REGION FROM CLIENTSETTINGS                                
WHERE #CMBILLVALAN.PARTY_CODE = CLIENTSETTINGS.PARTY_CODE                                
AND #CMBILLVALAN.SETT_TYPE = @SETT_TYPE_L                                
AND #CMBILLVALAN.SETT_NO = @SETT_NO_L                                 
AND #CMBILLVALAN.SAUDA_DATE > CLIENTSETTINGS.FROMDATE AND                                
#CMBILLVALAN.SAUDA_DATE <= CLIENTSETTINGS.TODATE                                
*/                            
                            
DELETE FROM CMBILLVALAN WHERE SETT_NO = @SETT_NO_L AND SETT_TYPE = @SETT_TYPE_L                                
                            
INSERT INTO CMBILLVALAN                            
SELECT SETT_NO,SETT_TYPE,BILLNO,CONTRACTNO,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,              
       SCRIP_NAME,ISIN,SAUDA_DATE,PQTYTRD,PAMTTRD,PQTYDEL,PAMTDEL,SQTYTRD,SAMTTRD,              
    SQTYDEL,SAMTDEL,PBROKTRD,SBROKTRD,PBROKDEL,SBROKDEL,FAMILY,FAMILY_NAME,TERMINAL_ID,              
    CLIENTTYPE,TRADETYPE,TRADER,SUB_BROKER,BRANCH_CD,PARTICIPANTCODE,PAMT,SAMT,PRATE,SRATE,              
       TRDAMT,DELAMT,SERINEX,SERVICE_TAX,EXSERVICE_TAX,TURN_TAX,SEBI_TAX,INS_CHRG,BROKER_CHRG,              
       OTHER_CHRG,REGION,START_DATE,END_DATE,UPDATE_DATE,STATUS_NAME,EXCHANGE,SEGMENT,MEMBERTYPE,              
       COMPANYNAME,SBU='',RELMGR='',GRP='',SECTOR='',TRACK='',AREA               
FROM #CMBILLVALAN                            
                            
DROP TABLE #CMBILLVALAN                            
                       
INSERT INTO PROCESS_MONITOR VALUES ('VALAN GENERATION',@SETT_NO_L + @SETT_TYPE_L,'','NSECMVALAN','DONE-UPDATE REGION FROM CLIENTSETTINGS. RECCOUNT: ' + CONVERT(CHAR,@@ROWCOUNT),'RETURN TO NSEVALANGENERATE',GETDATE(),GETDATE())

GO
