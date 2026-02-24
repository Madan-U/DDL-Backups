-- Object: PROCEDURE dbo.CBO_SHOWLEDGERBALANCE
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------


    
CREATE PROCEDURE [dbo].[CBO_SHOWLEDGERBALANCE](    
                @STATUSID   VARCHAR(25),    
                @STATUSNAME VARCHAR(25),    
                @EXCHANGE   VARCHAR(25),    
                @SEGMENT    VARCHAR(25),    
                @SEGMENTDB  VARCHAR(25),    
                @FROMCODE   VARCHAR(25),    
                @TOCODE     VARCHAR(25),    
                @DATEFROM   VARCHAR(11),    
                @DATETO     VARCHAR(11),    
                @SEARCHWHAT VARCHAR(20) = 'CLIENT',
				@RPT_TYPE VARCHAR(20) = 'SUMMARY')    
    
AS    
    
    -- exec CBO_SHOWLEDGERBALANCE 'broker', 'broker', 'mtf', 'mtf', 'mtftrade', 'dcr101', 'dcr101', 'jul  1 2017', 'jul 31 2017'
/*==============================================================================================================      
        EXEC CBO_SHOWLEDGERBALANCE @NOOFDAYS 10    
==============================================================================================================*/    
    
  SET NOCOUNT ON    
    
  CREATE TABLE [DBO].[#SEGMENT] (    
   [EXCHANGE]  [VARCHAR] (25) NOT NULL ,    
   [SEGMENT]   [VARCHAR] (25) NOT NULL ,    
   [SEGMENTDB] [VARCHAR] (25) NOT NULL ,    
  ) ON [PRIMARY]    
    
  IF @SEGMENTDB <> 'ALL'     
       INSERT INTO #SEGMENT     
       SELECT @EXCHANGE,     
              @SEGMENT,     
              @SEGMENTDB    
    
  IF @SEGMENTDB = 'ALL'     
     AND @SEGMENT = 'EQUITIES'     
     AND @EXCHANGE = 'ALL'     
       INSERT INTO #SEGMENT    
       SELECT EXCHANGE,     
              SEGMENT,     
              ACCOUNTDB     
       FROM   MULTICOMPANY     
       WHERE  EXCHANGE IN ('NSE','BSE')     
    
  IF @SEGMENTDB = 'ALL'     
     AND @SEGMENT IN ('CAPITAL','FUTURES')      
     AND @EXCHANGE = 'ALL'     
       INSERT INTO #SEGMENT    
       SELECT EXCHANGE,     
              SEGMENT,     
              ACCOUNTDB     
       FROM   MULTICOMPANY     
       WHERE  EXCHANGE IN ('NSE','BSE')    
              AND SEGMENT = @SEGMENT     
     
  IF @SEGMENTDB = 'ALL'     
     AND @SEGMENT = 'EQUITIES'     
     AND @EXCHANGE IN ('NSE','BSE')     
       INSERT INTO #SEGMENT    
       SELECT EXCHANGE,     
              SEGMENT,     
              ACCOUNTDB     
       FROM   MULTICOMPANY     
       WHERE  EXCHANGE = @EXCHANGE    
    
  CREATE TABLE [DBO].[#BALANCE] (    
   [ENT_CODE] [VARCHAR] (25) NOT NULL ,    
   [ENT_NAME] [VARCHAR] (100) NOT NULL ,    
   [LEDBAL]   [MONEY] NOT NULL ,    
   [MARBAL]   [MONEY] NOT NULL ,    
   [UCLBAL]   [MONEY] NOT NULL ,     
   [EXCHANGE] [VARCHAR] (25) NOT NULL ,    
   [SEGMENT]  [VARCHAR] (25) NOT NULL     
  ) ON [PRIMARY]    
    
  DECLARE  @@ACCCUR       AS CURSOR,    
           @@ACCOUNTDB   VARCHAR(25),    
           @@EXCHANGE    VARCHAR(25),    
           @@SEGMENT     VARCHAR(25),    
           @@SQL         VARCHAR(5000)    
      
  SET @@ACCCUR = CURSOR FOR SELECT  SEGMENTDB,     
                                    EXCHANGE,     
                                    SEGMENT      
                            FROM    #SEGMENT      
    
  OPEN @@ACCCUR    
      
  FETCH NEXT FROM @@ACCCUR    
  INTO @@ACCOUNTDB,    
       @@EXCHANGE,     
       @@SEGMENT            
  WHILE @@FETCH_STATUS = 0    
    BEGIN    
      SELECT @@SQL = ' '    
      SELECT @@SQL = @@SQL + 'INSERT INTO #BALANCE '    
      SELECT @@SQL = @@SQL + 'EXECUTE ' + @@ACCOUNTDB + '.DBO.CBO_GETLEDGERBALANCE '     
      SELECT @@SQL = @@SQL + '@STATUSID   = ''' + @STATUSID + ''', '    
      SELECT @@SQL = @@SQL + '@STATUSNAME = ''' + @STATUSNAME + ''', '    
      SELECT @@SQL = @@SQL + '@EXCHANGE   = ''' + @@EXCHANGE + ''', '    
      SELECT @@SQL = @@SQL + '@SEGMENT    = ''' + @@SEGMENT + ''', '    
      SELECT @@SQL = @@SQL + '@FROMCODE   = ''' + @FROMCODE + ''', '    
      SELECT @@SQL = @@SQL + '@TOCODE     = ''' + @TOCODE + ''', '    
      SELECT @@SQL = @@SQL + '@DATEFROM   = ''' + @DATEFROM + ''', '    
      SELECT @@SQL = @@SQL + '@DATETO     = ''' + @DATETO + ''', '    
      SELECT @@SQL = @@SQL + '@SEARCHWHAT = ''' + @SEARCHWHAT + ''' '    
          
        
print @@SQL    
EXEC( @@SQL)  
      FETCH NEXT FROM @@ACCCUR    
      INTO @@ACCOUNTDB,    
           @@EXCHANGE,     
           @@SEGMENT            
    END    
      
  CLOSE @@ACCCUR    
  DEALLOCATE @@ACCCUR              
    
  SELECT   ENT_CODE,     
           ENT_NAME,     
           LEDBAL = SUM(LEDBAL),     
           MARBAL = SUM(MARBAL),     
           UCLBAL = SUM(UCLBAL),     
    CLRBAL = SUM((LEDBAL + MARBAL) - UCLBAL)     
  FROM     #BALANCE     
  GROUP BY ENT_CODE,ENT_NAME     
  ORDER BY 1

GO
