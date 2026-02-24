-- Object: PROCEDURE dbo.CBO_GETLEDGERBALANCE
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

CREATE PROCEDURE [dbo].[CBO_GETLEDGERBALANCE](      
                @STATUSID   VARCHAR(25),      
                @STATUSNAME VARCHAR(25),      
                @EXCHANGE   VARCHAR(25),      
                @SEGMENT    VARCHAR(25),      
                @FROMCODE   VARCHAR(25),      
                @TOCODE     VARCHAR(25),      
                @DATEFROM VARCHAR(11),      
                @DATETO   VARCHAR(11),      
                @SEARCHWHAT VARCHAR(20) = 'CLIENT')      
      
  AS      
      
  SET NOCOUNT ON       
      
  CREATE TABLE [DBO].[#LEDBALANCE] (      
   [ENT_CODE] [VARCHAR] (25) NOT NULL ,      
   [ENT_NAME] [VARCHAR] (100) NOT NULL ,      
   [LEDBAL] [MONEY] NOT NULL ,      
   [DRCR] [VARCHAR] (1) NOT NULL,       
   [BALFLAG] [INT] NOT NULL,       
   [LEDFLAG] [INT] NOT NULL       
  ) ON [PRIMARY]    
  
  
  
 
      
  INSERT INTO #LEDBALANCE       
  SELECT   ENT_CODE,       
           ENT_NAME,       
           LEDBAL = SUM(VAMT),      
           DRCR,        
           BALFLAG = 1,       
           LEDFLAG = 1       
  FROM     LEDGER L (NOLOCK),       
           .DBO.CBO_FN_GETCODELIST(@STATUSID,@STATUSNAME,@FROMCODE,@TOCODE,@SEARCHWHAT) M,       
           PARAMETER P       
  WHERE    @DATETO BETWEEN SDTCUR AND LDTCUR       
   AND VDT >=SDTCUR     
           AND VDT <= @DATETO + ' 23:59:59'       
           AND PARTY_CODE = CLTCODE       
  GROUP BY ENT_CODE,ENT_NAME,DRCR
  
  INSERT INTO #LEDBALANCE       
  SELECT   ENT_CODE,       
           ENT_NAME,       
           LEDBAL = SUM(VAMT),      
           DRCR,        
           BALFLAG = 2,       
           LEDFLAG = 1       
  FROM     LEDGER L (NOLOCK),       
           .DBO.CBO_FN_GETCODELIST(@STATUSID,@STATUSNAME,@FROMCODE,@TOCODE,@SEARCHWHAT) M,       
           PARAMETER P       
  WHERE    VDT BETWEEN SDTCUR AND LDTCUR       
           AND EDT > @DATETO + ' 23:59:59'       
           AND PARTY_CODE = CLTCODE       
  GROUP BY ENT_CODE,ENT_NAME,DRCR      
      
  SELECT   ENT_CODE,       
           ENT_NAME,       
           LEDBAL = SUM(CASE       
                          WHEN LEDFLAG = 1       
                               AND BALFLAG = 1 THEN (CASE       
                                                       WHEN DRCR = 'D' THEN -LEDBAL       
                                                       ELSE LEDBAL       
                                                     END)      
                          ELSE 0       
                        END),      
           MARBAL = SUM(CASE       
                          WHEN LEDFLAG = 2       
                               AND BALFLAG = 1 THEN (CASE       
                                                       WHEN DRCR = 'D' THEN -LEDBAL       
                                                       ELSE LEDBAL       
                                                     END)      
                          ELSE 0       
                        END),      
           UCLBAL = SUM(CASE       
                          WHEN LEDFLAG = 1       
                               AND BALFLAG = 2 THEN (CASE       
                                                       WHEN DRCR = 'D' THEN -LEDBAL       
                                                       ELSE LEDBAL       
                                      END)      
                          ELSE 0       
                        END),       
           @EXCHANGE,       
           @SEGMENT       
  FROM     #LEDBALANCE       
 GROUP BY ENT_CODE, ENT_NAME

GO
