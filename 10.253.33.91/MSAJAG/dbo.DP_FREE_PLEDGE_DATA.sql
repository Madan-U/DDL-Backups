-- Object: PROCEDURE dbo.DP_FREE_PLEDGE_DATA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

     
     
     
 CREATE PROCEDURE [dbo].[DP_FREE_PLEDGE_DATA]    
 AS     
 BEGIN     
     
     
truncate table FREE_VALUE_SSRS_DATA    
     
SELECT  HLD_AC_CODE,TRADINGID,HLD_ISIN_CODE,SECURITYNAME,SECURITYTYPE,FREE_QTY,PLEDGE_QTY     
INTO #HOLD1     
FROM AGMUBODPL3.dmat.citrus_usr.HOLDING WITH(NOLOCK)     
      
  SELECT * INTO #CLOSIN1 FROM  AGMUBODPL3.dmat.citrus_usr.VW_ISIN_RATE_MASTER A,    
  (SELECT ISIN AS ISIN_NO,MAX(RATE_DATE) RATE  FROM  AGMUBODPL3.dmat.citrus_usr.VW_ISIN_RATE_MASTER WHERE  RATE_DATE <=GETDATE() GROUP BY ISIN )B    
  WHERE A.ISIN=B.ISIN_NO  AND A.RATE_DATE =B.RATE     
      
     
      
     
 SELECT HLD_AC_CODE,TRADINGID,count(HLD_ISIN_CODE)as ISIN_COUNT,    
 SUM(FREE_QTY*CLOSE_PRICE)FREE_VALUE ,SUM(PLEDGE_QTY*CLOSE_PRICE)AS PLEDGE_VALUE    
      
  INTO #D1    
     FROM #HOLD1 A, #CLOSIN1 WHERE ISIN=HLD_ISIN_CODE     
   GROUP BY HLD_AC_CODE,TRADINGID,FREE_QTY,PLEDGE_QTY    
       
   SELECT hld_ac_code,tradingid,SUM(ISIN_COUNT)AS ISIN_COUNT,  SUM(FREE_VALUE )AS FREE_VALUE,SUM(PLEDGE_VALUE)AS PLEDGE_VALUE     
   INTO #D2    
    FROM #D1   GROUP BY hld_ac_code,tradingid    
      
      
   
       
   SELECT hld_ac_code,tradingid,FIRST_HOLD_NAME,ACTIVE_DATE,    
   STATUS,ISIN_COUNT,FREE_VALUE,PLEDGE_VALUE    
   INTO #POA    
    FROM #D2 A,AGMUBODPL3.dmat.citrus_usr.TBL_CLIENT_MASTER B    
   WHERE A.hld_ac_code=B.CLIENT_CODE    
     
     
   
       
   SELECT A.*,  
   --( CASE WHEN B.POA_STATUS='A'THEN 'YES'ELSE 'NO'END)AS POA_STATUS   ,  
   B.POA_TYPE ,MAX(CONVERT (DATETIME ,POA_DATE_FROM))AS POA_DATE_FROM  
   INTO #VERTICAL    
   
    FROM #POA A    
LEFT OUTER JOIN    
   AGMUBODPL3.dmat.citrus_usr.TBL_CLIENT_POA B    
   ON A.hld_ac_code=B.CLIENT_CODE    
GROUP BY hld_ac_code,tradingid,FIRST_HOLD_NAME,ACTIVE_DATE,STATUS,ISIN_COUNT,FREE_VALUE,PLEDGE_VALUE,B.POA_TYPE  
  
   
SELECT hld_ac_code,tradingid,FIRST_HOLD_NAME,ACTIVE_DATE,STATUS,ISIN_COUNT,FREE_VALUE,PLEDGE_VALUE,A.POA_TYPE,A.POA_DATE_FROM,  
( CASE WHEN B.POA_STATUS='A'THEN 'YES'ELSE 'NO'END)AS POA_STATUS   
into #VERTICAL1  
 FROM #VERTICAL A  
LEFT OUTER JOIN  
AGMUBODPL3.dmat.citrus_usr.TBL_CLIENT_POA B  
 ON A.hld_ac_code=B.CLIENT_CODE WHERE A.POA_DATE_FROM =CONVERT (DATETIME ,B.POA_DATE_FROM)   
GROUP BY hld_ac_code,tradingid,FIRST_HOLD_NAME,ACTIVE_DATE,STATUS,ISIN_COUNT,FREE_VALUE,PLEDGE_VALUE,A.POA_TYPE,A.POA_DATE_FROM,POA_STATUS  
  
   
       
   insert into FREE_VALUE_SSRS_DATA    
   SELECT distinct a.*,(CASE WHEN b.B2C='Y'THEN 'B2C'ELSE 'B2B'END)AS B2B_B2C,b.COMB_LAST_DATE AS LAST_TRADE_DATE   
          
    FROM #VERTICAL1 A    
   LEFT OUTER JOIN    
   INTRANET.RISK.DBO.CLIENT_DETAILS B    
   ON A.tradingid=B.CL_CODE    
   order by hld_ac_code    
     
   
       
   DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = 'J:\Backoffice\Automation\DP_REPORT\'                           
SET @FILE = @PATH + 'DP_DATA' +'_'+ CONVERT(VARCHAR(11),GETDATE() , 112) + '.csv' --Folder Name         
DECLARE @S VARCHAR(MAX)                                  
SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''hld_ac_code'''',''''tradingid'''',''''FIRST_HOLD_NAME'''',''''ACTIVE_DATE'''',''''STATUS'''',''''ISIN_COUNT'''',''''FREE_VALUE'''',''''PLEDGE_VALUE'''',''''POA_TYPE'''',''''POA_DATE_FROM'''',''''POA_
STATUS'''',''''B2B_B2C'''',''''LAST_TRADE_DATE'''''    --Column Name        
SET @S = @S + ' UNION ALL SELECT   cast([hld_ac_code] as varchar), cast([tradingid] as varchar), cast([FIRST_HOLD_NAME] as varchar),CONVERT (VARCHAR (11),ACTIVE_DATE,109) as ACTIVE_DATE, cast([STATUS] as varchar),cast([ISIN_COUNT] as varchar),cast([FREE_V
ALUE] as varchar),cast([PLEDGE_VALUE] as varchar),cast([POA_TYPE] as varchar),CONVERT (VARCHAR (11),POA_DATE_FROM,109) as POA_DATE_FROM,cast([POA_STATUS] as varchar),cast([B2B_B2C] as varchar),  CONVERT (VARCHAR (11),LAST_TRADE_DATE,109) as LAST_TRADE_DAT
E FROM [MSAJAG].[DBO].[FREE_VALUE_SSRS_DATA]    " QUERYOUT ' --Convert data type if required        
        
 +@file+ ' -c -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''         
--   PRINT  (@S)         
EXEC(@S)     
       
END

GO
