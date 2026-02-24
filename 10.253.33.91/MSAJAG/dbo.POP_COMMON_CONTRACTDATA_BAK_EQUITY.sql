-- Object: PROCEDURE dbo.POP_COMMON_CONTRACTDATA_BAK_EQUITY
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROCEDURE [dbo].[POP_COMMON_CONTRACTDATA_BAK_EQUITY]   
(  
@FROMDATE VARCHAR(11),  
@USERNAME VARCHAR(20) = '',  
@CONTRACTGROUP VARCHAR(20) = ''  
)  
  
AS                                                     
/*                                      
EXEC POP_COMMON_CONTRACTDATA_ANGEL 'SEP  9 2015','SURESH'                                      
EXEC POP_COMMON_CONTRACTDATA_ANGEL 'DEC 24 2014','','ZZZZZZZZZZZZZ'                                      
*/                                   
SET NOCOUNT ON;

DECLARE @SDDATE DATETIME
SET @SDDATE=GETDATE()

                             
EXEC POP_COMMON_CONTRACTDATA_DATAFETCH  @FROMDATE  
  
                                      
DECLARE @FROMPARTY VARCHAR(10)                                      
DECLARE @TOPARTY VARCHAR(10)                                      
                                      
SET @FROMPARTY = ''                                      
SET @TOPARTY = 'zzzzzzzzzzzz'                                      
                                      
CREATE TABLE #CONTRACT (                                      
 CONTRACTNO VARCHAR(10),                                      
 CONTRACTNO_NEW VARCHAR(10),                                      
 SAUDA_DATE DATETIME,                                      
 SETT_NO VARCHAR(10),                                      
 SETT_TYPE VARCHAR(3),                                      
 SETT_DATE VARCHAR(11),                                      
 EXCHANGE VARCHAR(3),                                      
 SEGMENT VARCHAR(10),                                      
 ORDER_NO VARCHAR(20),                                      
 ORDER_TIME VARCHAR(8),                                      
 TRADE_NO VARCHAR(16),                                      
 TRADE_TIME VARCHAR(8),                                      
 SCRIPNAME VARCHAR(100),                                      
 QTY BIGINT,                                      
 TMARK VARCHAR(1),                                      
 SELL_BUY VARCHAR(1),                                      
  MARKETRATE NUMERIC (36,18),                                  
 MARKETAMT NUMERIC (36,18),                                  
 BROKERAGE NUMERIC (36,18),                                  
 SERVICE_TAX NUMERIC (36,18),                                  
 INS_CHRG NUMERIC (36,18),                                  
 NETAMOUNT NUMERIC (36,18),                                  
 SEBI_TAX NUMERIC (36,18),                                  
 TURN_TAX NUMERIC (36,18),                                  
 BROKER_CHRG NUMERIC (36,18),                                  
 OTHER_CHRG NUMERIC (36,18),                                  
 NETAMOUNTALL NUMERIC (36,18),                                  
 BROK NUMERIC (36,18),                                  
 NETRATE NUMERIC (36,18),                                  
 CL_RATE NUMERIC (36,18),                                      
 BROKERSEBIREGNO VARCHAR(20),                                      
 MEMBERCODE VARCHAR(50),                                      
 CINNO VARCHAR(100),                                      
 SETTTYPE_DESC VARCHAR(35),                                      
 BFCF_FLAG VARCHAR(6),                                      
 CONTRACT_HEADER_DET VARCHAR(200),                                      
 REMARK VARCHAR(100),                                      
 COMPANYNAME VARCHAR(100),                                      
 USER_ID VARCHAR(20),                                      
 REMARK_ID VARCHAR(1),                                      
 REMARK_DESC VARCHAR(200),                                      
NETOBLIGATION NUMERIC (36,18),                                    
 BRANCH_CD VARCHAR(15),                                      
 SUB_BROKER VARCHAR(15),                                      
 TRADER VARCHAR(25),                                      
 AREA VARCHAR(25),                                      
 REGION VARCHAR(25),                                      
 FAMILY VARCHAR(15),                                      
 PARTY_CODE VARCHAR(15),                     PARTYNAME VARCHAR(100),                                      
 L_ADDRESS1 VARCHAR(100),                                      
 L_ADDRESS2 VARCHAR(100),                                      
 L_ADDRESS3 VARCHAR(100),                                      
 L_STATE VARCHAR(50),                                      
 L_CITY VARCHAR(50),              
 L_ZIP VARCHAR(10),                                      
 OFF_PHONE1 VARCHAR(50),                                      
 OFF_PHONE2 VARCHAR(50),                   
 PAN_GIR_NO VARCHAR(15),                                      
 MAPIDID VARCHAR(20),                                      
 UCC_CODE VARCHAR(20),      
 SEBI_NO VARCHAR(25),                                      
 PARTICIPANT_CODE VARCHAR(16),                                      
 CL_TYPE VARCHAR(3),                                      
 SERVICE_CHRG TINYINT,                                      
 PRINTF TINYINT ,                                    
 BOOKTYPE INT,            
 INSTRUMENT INT,  
 ISIN VARCHAR(12)       
 )                                      
                                      
CREATE CLUSTERED INDEX [IDXCONT] ON [DBO].[#CONTRACT] (                                      
 [PARTY_CODE],                                      
 [EXCHANGE],                                      
 [SEGMENT],                                      
 [SCRIPNAME] ,   
 [USER_ID],  
 [ORDER_NO]                                   
 )                      
  
CREATE NONCLUSTERED INDEX [IDXUSER] ON [DBO].[#CONTRACT] (    
 [ORDER_NO],
 [TRADE_NO]  ,  
 [USER_ID] ,
 [SETT_TYPE])  
   
CREATE TABLE #CONTRACT_TERMINAL_MAPPING  
(  
TERMINAL_ID VARCHAR(10),  
ORDER_NO VARCHAR(20),  
REMARK_ID VARCHAR(1),  
REMARK_DESC VARCHAR(200)  
)  
  
CREATE CLUSTERED INDEX [INDXCONTMAP] ON [DBO].[#CONTRACT_TERMINAL_MAPPING] ([ORDER_NO],[TERMINAL_ID])    
                                      
CREATE TABLE #MTOM_FNO (                                      
 PARTY_CODE VARCHAR(15),                                      
 MTM NUMERIC (36,18),                                        
 EXCHANGE VARCHAR(5),                                      
 SEGMENT VARCHAR(10)                                      
 )                                      
                                      
CREATE TABLE #PARTY (PARTYCODE VARCHAR(10))        
CREATE CLUSTERED INDEX [INDXPARTYCODE] ON [DBO].[#PARTY] (PARTYCODE)        
  
                                
                                      
CREATE TABLE #FOCLOSING                                      
 (                            
 SRNO  INT IDENTITY(1,1),                                      
 TRADE_DATE DATETIME,                                      
 SCRIPNAME VARCHAR(150),                                      
 CL_RATE  NUMERIC (36,18),  
 EXCHANGE VARCHAR(10),                                        
 SEGMENT VARCHAR(20)  
 )                                      
                                       
CREATE CLUSTERED INDEX [INDXCLOSING] ON [DBO].[#FOCLOSING] ([SCRIPNAME])                                      
                                      
DECLARE @FNOBILL_FLAG INT   
SET @FNOBILL_FLAG = 0  
DECLARE @CONTRACT_GROUP INT
DECLARE @CONTRACT_T1T2 INT  
  
SELECT @FNOBILL_FLAG = ISNULL(FNO_CONTRACT_BILL,''), @CONTRACT_GROUP = ISNULL(CONTRACTGROUP,0),@CONTRACT_T1T2 = ISNULL(CONTRACTNO_T1T2,0) FROM TBL_COMMONCONTRACT_MASTER (NOLOCK)  
WHERE @FROMDATE BETWEEN EFFECTIVE_FROM  AND EFFECTIVE_TO  
                                      
DECLARE @COMPANYNAME VARCHAR(150)                                      
DECLARE @EXCHANGE_NEW VARCHAR(3)                                      
DECLARE @SEGMENT_NEW VARCHAR(10)                                      
DECLARE @SHAREDB VARCHAR(35)                                      
DECLARE @SHARESERVER VARCHAR(35)                                      
DECLARE @ACCOUNTDB VARCHAR(35)                    
DECLARE @ACCOUNTSERVER VARCHAR(35)                                      
DECLARE @CONTRACTGROUP_NEW VARCHAR(20)  
DECLARE @CONTRACTGROUP_NEW1 VARCHAR(20)  
                                      
DECLARE @EXCHANGEWISE_CURSOR CURSOR   
DECLARE @EXCHANGEWISE_CURSOR_NEW CURSOR   
DECLARE @STRSQL VARCHAR(8000)   
SELECT EXCHANGE,                                      
 SEGMENT INTO #CLIENT_BROK_DETAILS FROM MSAJAG.DBO.CLIENT_BROK_DETAILS(NOLOCK)   
 GROUP BY EXCHANGE,SEGMENT   
  
SELECT DISTINCT COMPANYNAME,                                      
 EXCHANGE = M.EXCHANGE,                                      
 SEGMENT = M.SEGMENT,                                      
 SHAREDB,                                      
 SHARESERVER,                                      
 ACCOUNTDB,                                      
 ACCOUNTSERVER,  
 CONTRACTGROUP_NEW = (CASE WHEN @CONTRACT_GROUP = 1 THEN ISNULL(CONTRACTGROUP,'') ELSE '' END)   
 INTO #CONTMULTI  
FROM PRADNYA..MULTICOMPANY M(NOLOCK)  
,#CLIENT_BROK_DETAILS CB(NOLOCK)                                      
WHERE                                       
CATEGORY IN (                                      
  'EQUITY',                             
  'DERIVATIVES',                                      
  'CURRENCY'                                      
  )                                      
 --TEST                                       
 --AND M.EXCHANGE='BSE'               
 --TEST                                      
 AND M.SEGMENT NOT IN ('SLBS')                                      
 AND SEGMENT_DESCRIPTION NOT LIKE '%PCM%'                                      
 AND CB.EXCHANGE = M.EXCHANGE    
 --AND M.EXCHANGE <>'BSX'                                    
 AND CB.SEGMENT = M.SEGMENT                                      
 AND PRIMARYSERVER = 1                                      
 AND ISNULL(CONTRACTGROUP,'') = (CASE WHEN @CONTRACTGROUP = '' THEN ISNULL(CONTRACTGROUP,'') ELSE @CONTRACTGROUP END)  
  
   
  
   
 SET @EXCHANGEWISE_CURSOR = CURSOR  FOR                                      
 select * from #CONTMULTI  
                                      
/*                       
 AND M.EXCHANGE + M.SEGMENT = (                                      
  CASE                                       
   WHEN @EXCHANGE = ''                                      
    THEN M.EXCHANGE + M.SEGMENT                                      
   WHEN @EXCHANGE = 'CASH'                                      
    THEN (                                      
      SELECT DISTINCT EXCHANGE + SEGMENT                                      
      FROM PRADNYA..MULTICOMPANY M1(NOLOCK)                                      
      WHERE SEGMENT = 'CAPITAL'                                      
       AND M1.EXCHANGE = M.EXCHANGE                                      
  AND M1.SEGMENT = M.SEGMENT                                      
      )                                      
   WHEN @EXCHANGE = 'FUTURES'                                      
    THEN (                                      
      SELECT DISTINCT EXCHANGE + SEGMENT                                      
      FROM PRADNYA..MULTICOMPANY M2(NOLOCK)                                      
      WHERE SEGMENT = 'FUTURES'                             
       AND M2.EXCHANGE = M.EXCHANGE                                      
       AND M2.SEGMENT = M.SEGMENT                                      
      )                                      
   ELSE @EXCHANGE                                      
   END                                      
  )                                      
 AND COMPANYNAME = (CASE WHEN @COMPANY_NAME = '' THEN COMPANYNAME ELSE @COMPANY_NAME END)                                      
 */                                      
OPEN @EXCHANGEWISE_CURSOR                                      
                                      
FETCH NEXT                            
FROM @EXCHANGEWISE_CURSOR                                      
INTO @COMPANYNAME,                                      
 @EXCHANGE_NEW,                                      
 @SEGMENT_NEW,                                      
 @SHAREDB,                       
 @SHARESERVER,                                      
 @ACCOUNTDB,                                      
 @ACCOUNTSERVER,  
 @CONTRACTGROUP_NEW                                      
                                    
WHILE @@FETCH_STATUS = 0                                      
BEGIN                                      
 SET @STRSQL = '' 
 
 IF @SHARESERVER = @@SERVICENAME
	BEGIN
		SET @SHARESERVER =''
	END
	ELSE
	BEGIN
		SET @SHARESERVER = @SHARESERVER + '.'
	END
 IF @SHARESERVER = @@SERVICENAME AND @SHAREDB = 'MSAJAG'	  
	BEGIN
	    SET @SHAREDB = ''
	END	                               
                                      
 IF @SEGMENT_NEW = 'CAPITAL'                                      
 BEGIN   
 --PRINT 'D1'                                                                                                             
  SET @STRSQL = 'IF (SELECT COUNT(1) FROM ' + @SHARESERVER + @SHAREDB + '.SYS.TABLES WHERE NAME=''CONTRACT_DATA_COMMON'') > 0 '                                      
  SET @STRSQL = @STRSQL + ' BEGIN '                                      
  SET @STRSQL = @STRSQL + 'TRUNCATE TABLE #PARTY '                                      
  SET @STRSQL = @STRSQL + ' INSERT INTO #PARTY '                                      
  SET @STRSQL = @STRSQL + ' SELECT DISTINCT PARTY_CODE FROM '                                      
  SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.CONTRACT_MASTER_COMMON WITH (NOLOCK) WHERE CONVERT(DATETIME,START_DATE,103) BETWEEN ''' + @FROMDATE + ''' AND ''' + @FROMDATE + ' 23:59:59'' 
  AND PARTY_CODE BETWEEN ''' + @FROMPARTY + ''' AND ''' + @TOPARTY + ''''                                      
  SET @STRSQL = @STRSQL + ' END '                               
  --PRINT 'D2'                                                                                                                                               
  --PRINT @STRSQL                                      
  EXEC (@STRSQL)                                      
                                      
  SET @STRSQL = 'IF (SELECT COUNT(1) FROM ' + @SHARESERVER + @SHAREDB + '.SYS.TABLES WHERE NAME=''CONTRACT_DATA_COMMON'') > 0 '              
  SET @STRSQL = @STRSQL + 'BEGIN '                                      
  SET @STRSQL = @STRSQL + 'INSERT INTO #CONTRACT '                                      
  SET @STRSQL = @STRSQL + 'SELECT '                                      
  SET @STRSQL = @STRSQL + ' CONTRACTNO,'                                      
  SET @STRSQL = @STRSQL + ' CONTRACTNO_NEW = CONTRACTNO,'                                      
  SET @STRSQL = @STRSQL + ' SAUDA_DATE = CONVERT(DATETIME,SAUDA_DATE,109),'                                      
                     
  IF @SHAREDB = 'BSEDB_AB'                                      
  BEGIN                                      
   SET @STRSQL = @STRSQL + ' SETT_NO =   MSAJAG.DBO.CONVERTSETTNO(D.SETT_NO,1),'                                      
  END                                      
  ELSE                                      
  BEGIN                                      
   SET @STRSQL = @STRSQL + ' SETT_NO = D.SETT_NO,'                                  
  END                                      
                                    
  SET @STRSQL = @STRSQL + ' SETT_TYPE = D.SETT_TYPE,'                                      
  SET @STRSQL = @STRSQL + ' SETT_DATE = FUNDS_PAYIN,'                                      
  SET @STRSQL = @STRSQL + ' EXCHANGE = ''' + @EXCHANGE_NEW + ''','                                      
  SET @STRSQL = @STRSQL + ' SEGMENT = ''' + @SEGMENT_NEW + ''','                                      
  SET @STRSQL = @STRSQL + ' ORDER_NO,'                       
  SET @STRSQL = @STRSQL + ' ORDER_TIME,'                                      
  SET @STRSQL = @STRSQL + ' TRADE_NO,'            
  SET @STRSQL = @STRSQL + ' TRADE_TIME=TM,'                                      
  SET @STRSQL = @STRSQL + ' SCRIPNAME,'                                      
  SET @STRSQL = @STRSQL + ' QTY=PQTY+SQTY,'                                      
  SET @STRSQL = @STRSQL + ' TMARK,'                                      
  SET @STRSQL = @STRSQL + ' SELL_BUY,'                          
  SET @STRSQL = @STRSQL + ' MARKETRATE = PRATE+SRATE,'                                      
  SET @STRSQL = @STRSQL + ' MARKETAMT = ((PRATE + SRATE)*(PQTY+SQTY)),'                    
  SET @STRSQL = @STRSQL + ' BROKERAGE,'                                      
  SET @STRSQL = @STRSQL + ' SERVICE_TAX = NSERTAX,'                                      
  SET @STRSQL = @STRSQL + ' INS_CHRG,'                                      
  SET @STRSQL = @STRSQL + ' NETAMOUNT = ('                                      
  SET @STRSQL = @STRSQL + ' CASE'                                      
  SET @STRSQL = @STRSQL + ' WHEN SELL_BUY = 1'                                      
  SET @STRSQL = @STRSQL + ' THEN -(PAMT)'                                      
  SET @STRSQL = @STRSQL + ' ELSE (SAMT)'                                      
  SET @STRSQL = @STRSQL + ' END),'                                      
  SET @STRSQL = @STRSQL + ' SEBI_TAX,'                                      
  SET @STRSQL = @STRSQL + ' TURN_TAX,'        
  SET @STRSQL = @STRSQL + ' BROKER_CHRG,'                   
  SET @STRSQL = @STRSQL + ' OTHER_CHRG,'                                      
  SET @STRSQL = @STRSQL + ' NETAMOUNTALL = ('                                      
  SET @STRSQL = @STRSQL + ' CASE'                                      
  SET @STRSQL = @STRSQL + ' WHEN SELL_BUY = 1'                                      
  SET @STRSQL = @STRSQL + ' THEN -(PAMT+NSERTAX+INS_CHRG+SEBI_TAX+TURN_TAX+BROKER_CHRG+OTHER_CHRG)'                                      
  SET @STRSQL = @STRSQL + ' ELSE (SAMT-NSERTAX-INS_CHRG-SEBI_TAX-TURN_TAX-BROKER_CHRG-OTHER_CHRG)'                                      
  SET @STRSQL = @STRSQL + ' END),'                                      
  SET @STRSQL = @STRSQL + ' BROK = (PBROK+SBROK),'                                      
  SET @STRSQL = @STRSQL + ' NETRATE = (CASE WHEN SELL_BUY = 1 '                                      
  SET @STRSQL = @STRSQL + ' THEN (CASE WHEN PQTY >0 THEN PAMT/PQTY ELSE 0 END) '                                      
  SET @STRSQL = @STRSQL + ' ELSE (CASE WHEN SQTY >0 THEN SAMT/SQTY ELSE 0 END) END),'                                      
  SET @STRSQL = @STRSQL + ' CL_RATE = 0, '                                      
  SET @STRSQL = @STRSQL + ' BROKERSEBIREGNO = O.BROKERSEBIREGNO,MEMBERCODE=O.MEMBERCODE,CINNO=O.CIN, '                                      
  SET @STRSQL = @STRSQL + ' SETTTYPE_DESC = (CASE '                                      
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''D''  THEN ''MKTROLLING'''                                      
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''C''  THEN ''ODD LOT'''                                      
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''RD''  THEN ''MKTROLLING'''                                      
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''RC''  THEN ''ODD LOT'''                                      
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''F''  THEN ''DEBENTURE'''                                      
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''AC'' THEN ''AUCTION ODD LOT'''                                      
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''AF'' THEN ''AUCTION DEFENTURE'''                                      
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''M''  THEN ''NORMAL'''         
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''M''  THEN ''NORMAL'''  
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''Z''  THEN ''TRADE FOR TRADE'''  
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''A''  THEN ''AUCTION'''                                      
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''X''  THEN ''AUCTION TRADE FOR TRADE'''                                      
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''W''  THEN ''TRADE FOR TRADE'''                                      
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''MN'' THEN ''NORMAL'''                                      
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''AN'' THEN ''AUCTION NORMAL'''                                      
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''AD'' THEN ''AUCTION ROLLING'''                                      
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''MW'' THEN ''TRADE FOR TRADE'''                                      
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''MX'' THEN ''AUCTION TRADE FOR TRADE'''                                      
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''OS'' THEN ''OFFER FOR SALE'''   
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''T'' THEN ''OFFER FOR SALE'''   
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''H'' THEN ''OFFER FOR SALE'''   
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''BX'' THEN ''BUY BACK'''   
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''DX'' THEN ''DELISTING'''    
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''TX'' THEN ''TAKEOVER'''     
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''OB'' THEN ''BUY BACK'''   
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''DL'' THEN ''DELISTING'''    
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''TK'' THEN ''TAKEOVER'''                                   
  SET @STRSQL = @STRSQL + ' WHEN D.SETT_TYPE = ''TS'' THEN ''OFFER FOR SALE'''                                      
  SET @STRSQL = @STRSQL + ' ELSE '''' END), BFCF_FLAG = '''', '                                      
  SET @STRSQL = @STRSQL + ' CONTRACT_HEADER_DET = '''', '                               
  SET @STRSQL = @STRSQL + ' REMARK = '''', '                                      
  SET @STRSQL = @STRSQL + ' COMPANYNAME = O.COMPANY, USER_ID='''', '                                      
  SET @STRSQL = @STRSQL + ' REMARK_ID = '''', '                                      
  SET @STRSQL = @STRSQL + ' REMARK_DESC = '''', '                                      
  SET @STRSQL = @STRSQL + ' NETOBLIGATION = 0, '                                      
  SET @STRSQL = @STRSQL + ' M.BRANCH_CD, '                         
  SET @STRSQL = @STRSQL + ' M.SUB_BROKER, '                                      
  SET @STRSQL = @STRSQL + ' M.TRADER, '                                     
  SET @STRSQL = @STRSQL + ' M.AREA, '                                      
  SET @STRSQL = @STRSQL + ' M.REGION, '                                      
  SET @STRSQL = @STRSQL + ' M.FAMILY, '                                      
  SET @STRSQL = @STRSQL + ' PARTY_CODE= D.PARTY_CODE,'                                      
  SET @STRSQL = @STRSQL + ' M.PARTYNAME,'                                      
  SET @STRSQL = @STRSQL + ' M.L_ADDRESS1,'                                      
  SET @STRSQL = @STRSQL + ' M.L_ADDRESS2,'                                      
  SET @STRSQL = @STRSQL + ' M.L_ADDRESS3,'                                      
  SET @STRSQL = @STRSQL + ' M.L_STATE,'                                      
  SET @STRSQL = @STRSQL + ' M.L_CITY,'                                      
  SET @STRSQL = @STRSQL + ' M.L_ZIP,'                                      
  SET @STRSQL = @STRSQL + ' M.OFF_PHONE1,'                                      
  SET @STRSQL = @STRSQL + ' M.OFF_PHONE2,'                                      
  SET @STRSQL = @STRSQL + ' M.PAN_GIR_NO,'                 
  SET @STRSQL = @STRSQL + ' M.MAPIDID,'                                      
  SET @STRSQL = @STRSQL + ' M.UCC_CODE,'                                      
  SET @STRSQL = @STRSQL + ' M.SEBI_NO,'                                      
  SET @STRSQL = @STRSQL + ' M.PARTICIPANT_CODE,'                
  SET @STRSQL = @STRSQL + ' M.CL_TYPE,'                                      
  SET @STRSQL = @STRSQL + ' M.SERVICE_CHRG,'                                      
  SET @STRSQL = @STRSQL + ' M.PRINTF,'   
  SET @STRSQL = @STRSQL + ' BOOKTYPE='''' , '           
  SET @STRSQL = @STRSQL + ' INSTRUMENT='''' , '   
  SET @STRSQL = @STRSQL + ' ISIN=D.ISIN '   
       
  SET @STRSQL = @STRSQL + ' FROM '                                      
  SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.CONTRACT_DATA_COMMON D WITH (NOLOCK),'                              
  SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.CONTRACT_MASTER_COMMON M WITH (NOLOCK),'                                      
  SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.OWNER O WITH (NOLOCK)'                                      
  SET @STRSQL = @STRSQL + ' WHERE'                                      
  SET @STRSQL = @STRSQL + ' M.SETT_TYPE = D.SETT_TYPE'                                     
  SET @STRSQL = @STRSQL + ' AND M.SETT_NO = D.SETT_NO'                                      
  SET @STRSQL = @STRSQL + ' AND M.PARTY_CODE = D.PARTY_CODE'                                      
  SET @STRSQL = @STRSQL + ' AND M.PARTY_CODE BETWEEN ''' + @FROMPARTY + ''' AND ''' + @TOPARTY + ''''                                      
  
  SET @STRSQL = @STRSQL + ' AND CONVERT(DATETIME,D.SAUDA_DATE,109) >= ''' + @FROMDATE + ''' AND CONVERT(DATETIME,D.SAUDA_DATE,109) <= ''' + @FROMDATE + ' 23:59:59'''                                      
    
      
  SET @STRSQL = @STRSQL + ' AND EXISTS ( SELECT DISTINCT PARTYCODE FROM #PARTY P (NOLOCK) WHERE P.PARTYCODE = D.PARTY_CODE )'                                     
  SET @STRSQL = @STRSQL + ' ORDER BY'                                      
  SET @STRSQL = @STRSQL + ' SAUDA_DATE,'                                      
  SET @STRSQL = @STRSQL + ' D.PARTY_CODE '                   
  SET @STRSQL = @STRSQL + ' END'                                      
                                      
  --PRINT @STRSQL    
  EXEC (@STRSQL)                             
                               
                         
  SET @STRSQL = ' UPDATE #CONTRACT SET USER_ID = S.USER_ID FROM '                                      
  SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.SETTLEMENT S WITH (NOLOCK) '                                      
  SET @STRSQL = @STRSQL + ' WHERE S.SAUDA_DATE >= ''' + @FROMDATE + ''' AND S.SAUDA_DATE <= ''' + @FROMDATE + ' 23:59:59'''                                      
  SET @STRSQL = @STRSQL + ' AND S.ORDER_NO = #CONTRACT.ORDER_NO AND S.TRADE_NO = #CONTRACT.TRADE_NO '                                      
  SET @STRSQL = @STRSQL + ' AND S.PARTY_CODE = #CONTRACT.PARTY_CODE '                                      
  SET @STRSQL = @STRSQL + ' AND S.SETT_TYPE = #CONTRACT.SETT_TYPE '                 
  SET @STRSQL = @STRSQL + ' AND #CONTRACT.EXCHANGE = ''' + @EXCHANGE_NEW + ''' '                                      
  SET @STRSQL = @STRSQL + ' AND #CONTRACT.SEGMENT = ''' + @SEGMENT_NEW + ''' '                                      
      
                                      
  --PRINT @STRSQL                          
   EXEC (@STRSQL)                            
                             
                                     
                                      
  --EXEC (@STRSQL)  COMMENTED FOR TESTING SINU                                      
/*                                      
  SET @STRSQL = 'IF (SELECT COUNT(1) FROM ' + @SHARESERVER + '.' + @SHAREDB + '.SYS.TABLES WHERE NAME=''TBL_CONTRACT_TERMINAL_MAPPING'') > 0 '                                      
  SET @STRSQL = @STRSQL + 'BEGIN '                                      
  SET @STRSQL = @STRSQL + 'IF (SELECT COUNT(1) FROM ' + @SHARESERVER + '.' + @SHAREDB + '.SYS.COLUMNS WHERE [NAME] = ''USER_ID'' AND [OBJECT_ID] IN (SELECT DISTINCT OBJECT_ID FROM ' + @SHARESERVER + '.' + @SHAREDB + '.SYS.TABLES WHERE NAME = ''CONTRACT_D
 
  
   
ATA_COMMON'')) > 0 '                                      
  SET @STRSQL = @STRSQL + 'BEGIN '                                      
  SET @STRSQL = @STRSQL + ' UPDATE #CONTRACT SET REMARK_ID = ISNULL(T.REMARK_ID,''''), REMARK_DESC = ISNULL(T.REMARK_DESC,'''') '                                      
  SET @STRSQL = @STRSQL + ' FROM ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.TBL_CONTRACT_TERMINAL_MAPPING T WITH (NOLOCK) '                               
  SET @STRSQL = @STRSQL + ' WHERE #CONTRACT.USER_ID = (CASE WHEN ISNULL(T.TERMINAL_ID,'''') <> '''' THEN ISNULL(T.TERMINAL_ID,'''') ELSE #CONTRACT.USER_ID END) '                                      
  SET @STRSQL = @STRSQL + ' AND #CONTRACT.ORDER_NO = (CASE WHEN ISNULL(T.ORDER_NO,'''') <> '''' THEN ISNULL(T.ORDER_NO,'''') ELSE #CONTRACT.ORDER_NO END) '                                      
  SET @STRSQL = @STRSQL + ' AND CONVERT(DATETIME,SAUDA_DATE,103) BETWEEN FROM_DATE AND END_DATE '                                      
  SET @STRSQL = @STRSQL + ' AND EXCHANGE = ''' + @EXCHANGE_NEW + ''' AND SEGMENT = ''' + @SEGMENT_NEW + ''' '                                      
  SET @STRSQL = @STRSQL + 'END '                                      
  SET @STRSQL = @STRSQL + 'END '                                      
*/  
  SET @STRSQL = 'IF (SELECT COUNT(1) FROM ' + @SHARESERVER + @SHAREDB + '.SYS.TABLES WHERE NAME=''TBL_CONTRACT_TERMINAL_MAPPING'') > 0 '    
  SET @STRSQL = @STRSQL + 'BEGIN '    
 SET @STRSQL = @STRSQL + ' TRUNCATE TABLE #CONTRACT_TERMINAL_MAPPING '  
 SET @STRSQL = @STRSQL + ' INSERT INTO #CONTRACT_TERMINAL_MAPPING '  
 SET @STRSQL = @STRSQL + ' SELECT TERMINAL_ID,ORDER_NO,REMARK_ID,REMARK_DESC FROM ' + @SHARESERVER + @SHAREDB + '.DBO.TBL_CONTRACT_TERMINAL_MAPPING WITH (NOLOCK) '  
 SET @STRSQL = @STRSQL + ' WHERE ''' + @FROMDATE + ''' = FROM_DATE '  
   
 SET @STRSQL = @STRSQL + ' UPDATE #CONTRACT SET REMARK_ID = ISNULL(T.REMARK_ID,''''), REMARK_DESC = ISNULL(T.REMARK_DESC,'''') '    
  --SET @STRSQL = @STRSQL + ' FROM ' + @SHARESERVER + @SHAREDB + '.DBO.TBL_CONTRACT_TERMINAL_MAPPING T (NOLOCK) '    
  SET @STRSQL = @STRSQL + ' FROM #CONTRACT_TERMINAL_MAPPING T '    
  SET @STRSQL = @STRSQL + ' WHERE #CONTRACT.ORDER_NO = T.ORDER_NO '    
  SET @STRSQL = @STRSQL + ' AND ISNULL(T.ORDER_NO,'''') <> '''' '    
--  SET @STRSQL = @STRSQL + ' AND CONVERT(DATETIME,SAUDA_DATE,103) BETWEEN CONVERT(DATETIME,CONVERT(VARCHAR,FROM_DATE,103),103) AND END_DATE '    
  --SET @STRSQL = @STRSQL + ' AND CONVERT(VARCHAR(11),SAUDA_DATE,109) BETWEEN CONVERT(VARCHAR(11),FROM_DATE,109) AND CONVERT(VARCHAR(11),END_DATE,109) '      
  --SET @STRSQL = @STRSQL + ' AND SAUDA_DATE BETWEEN FROM_DATE AND END_DATE '      
  SET @STRSQL = @STRSQL + ' AND EXCHANGE = ''' + @EXCHANGE_NEW + ''' AND SEGMENT = ''' + @SEGMENT_NEW + ''' '    
  --SET @STRSQL = @STRSQL + 'END '   
    
  SET @STRSQL = @STRSQL + ' UPDATE #CONTRACT SET REMARK_ID = ISNULL(T.REMARK_ID,''''), REMARK_DESC = ISNULL(T.REMARK_DESC,'''') '    
  --SET @STRSQL = @STRSQL + ' FROM ' + @SHARESERVER + @SHAREDB + '.DBO.TBL_CONTRACT_TERMINAL_MAPPING T (NOLOCK) '    
  SET @STRSQL = @STRSQL + ' FROM #CONTRACT_TERMINAL_MAPPING T '    
  SET @STRSQL = @STRSQL + ' WHERE #CONTRACT.USER_ID = T.TERMINAL_ID '    
  SET @STRSQL = @STRSQL + ' AND ISNULL(T.TERMINAL_ID,'''') <> '''' '    
--  SET @STRSQL = @STRSQL + ' AND CONVERT(DATETIME,SAUDA_DATE,103) BETWEEN CONVERT(DATETIME,CONVERT(VARCHAR,FROM_DATE,103),103) AND END_DATE '    
  --SET @STRSQL = @STRSQL + ' AND CONVERT(VARCHAR(11),SAUDA_DATE,109) BETWEEN CONVERT(VARCHAR(11),FROM_DATE,109) AND CONVERT(VARCHAR(11),END_DATE,109) '      
  --SET @STRSQL = @STRSQL + ' AND SAUDA_DATE BETWEEN FROM_DATE AND END_DATE '      
  SET @STRSQL = @STRSQL + ' AND EXCHANGE = ''' + @EXCHANGE_NEW + ''' AND SEGMENT = ''' + @SEGMENT_NEW + ''' '    
  --SET @STRSQL = @STRSQL + 'END '    
  SET @STRSQL = @STRSQL + 'END '                                          
  --PRINT @STRSQL                                      
  EXEC (@STRSQL)                                      
                            
  --PRINT 'ABC'                                      
END  
   
 ELSE   
  --PRINT 'ABC1'                                      
  IF @SEGMENT_NEW = 'FUTURES'                                      
  BEGIN  
  --PRINT 'ABC2'                                                                          
   SET @STRSQL = 'IF (SELECT COUNT(1) FROM ' + @SHARESERVER + @SHAREDB + '.SYS.TABLES WHERE NAME=''CONTRACT_DATA_COMMON'') > 0 '                                      
   SET @STRSQL = @STRSQL + 'BEGIN '                                      
   SET @STRSQL = @STRSQL + ' TRUNCATE TABLE #PARTY '                                      
   SET @STRSQL = @STRSQL + ' INSERT INTO #PARTY '                                      
                     
   IF (                                      
     @SHAREDB = 'BSEFO'                    
    -- OR @SHAREDB = 'BSECURFO'                                      
     )                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + ' SELECT DISTINCT PARTY_CODE FROM '                                      
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.BFOBILLVALAN WITH (NOLOCK) WHERE PARTY_CODE BETWEEN  ''' + @FROMPARTY + ''' AND ''' + @TOPARTY + ''' '                                      
    SET @STRSQL = @STRSQL + ' AND SAUDA_DATE BETWEEN ''' + @FROMDATE + ''' AND ''' + @FROMDATE + ' 23:59:59'''                                      
   END                          
   ELSE                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + ' SELECT DISTINCT PARTY_CODE FROM '                                      
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.FOBILLVALAN WITH (NOLOCK) WHERE PARTY_CODE BETWEEN  ''' + @FROMPARTY + ''' AND ''' + @TOPARTY + ''' '                                      
    SET @STRSQL = @STRSQL + ' AND SAUDA_DATE BETWEEN ''' + @FROMDATE + ''' AND ''' + @FROMDATE + ' 23:59:59'''                                      
   END                                      
                                      
   SET @STRSQL = @STRSQL + ' END '                                      
                                      
   --PRINT @STRSQL                                      
   EXEC (@STRSQL)                                      
                                      
   /* FOR BF TRADE */                                      
   SET @STRSQL = ''                                      
   SET @STRSQL = @STRSQL + 'INSERT INTO #CONTRACT '                                      
   SET @STRSQL = @STRSQL + 'SELECT '                                      
   SET @STRSQL = @STRSQL + ' CONTRACTNO,'                                      
   SET @STRSQL = @STRSQL + ' CONTRACTNO_NEW = CONTRACTNO,'                                      
   SET @STRSQL = @STRSQL + ' SAUDA_DATE,'                                      
   SET @STRSQL = @STRSQL + ' SETT_NO = '''','                                      
   SET @STRSQL = @STRSQL + ' SETT_TYPE = '''','                                      
   SET @STRSQL = @STRSQL + ' SETT_DATE = '''','                                      
   SET @STRSQL = @STRSQL + ' EXCHANGE = ''' + @EXCHANGE_NEW + ''','                                      
   SET @STRSQL = @STRSQL + ' SEGMENT  = ''' + @SEGMENT_NEW + ''','                                      
   SET @STRSQL = @STRSQL + ' ORDER_NO = '''','                                      
   SET @STRSQL = @STRSQL + ' ORDER_TIME = '''','          
   SET @STRSQL = @STRSQL + ' TRADE_NO = '''','                                      
   SET @STRSQL = @STRSQL + ' TRADE_TIME='''','                                      
   IF (                                      
     @SHAREDB = 'BSEFO'                                      
   --  OR @SHAREDB = 'BSECURFO'                                      
     )                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + ' SCRIPNAME = RTRIM(PRODUCT_CODE) + '' '' + RTRIM(SERIES_CODE) + '' '' + CONVERT(VARCHAR,SERIES_ID,108),'                                      
   END                                      
   ELSE                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + ' SCRIPNAME = ('                                      
    SET @STRSQL = @STRSQL + ' CASE '                                     
    SET @STRSQL = @STRSQL + ' WHEN LEFT(INST_TYPE,3) = ''FUT'' THEN RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' '' + LEFT(EXPIRYDATE,11) '                                      
    SET @STRSQL = @STRSQL + ' ELSE RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' '' + LEFT(EXPIRYDATE,11) + '' '' + CONVERT(VARCHAR,STRIKE_PRICE) + '' '' + RTRIM(OPTION_TYPE) '                                      
    SET @STRSQL = @STRSQL + ' END),'             
   END                                      
                                      
   SET @STRSQL = @STRSQL + ' QTY=ABS(SUM(PQTY-SQTY)),'                                      
   SET @STRSQL = @STRSQL + ' TMARK= '''','                                      
   SET @STRSQL = @STRSQL + ' SELL_BUY=(CASE WHEN SUM(PQTY-SQTY) > 0 THEN 1 ELSE 2 END),'                                      
   --SET @STRSQL = @STRSQL + ' MARKETRATE = (CASE WHEN SUM(PQTY-SQTY) <> 0 THEN (SUM(PRATE*PQTY)-SUM(SRATE*SQTY))/SUM(PQTY-SQTY) ELSE 0 END),'                                      
   SET @STRSQL = @STRSQL + ' MARKETRATE = (CASE WHEN SUM(PQTY-SQTY) <> 0 THEN (SUM(PAMT)-SUM(SAMT) )/SUM(PQTY-SQTY) ELSE 0 END),'                      
   SET @STRSQL = @STRSQL + ' MARKETAMT = (SUM(PRATE*PQTY)-SUM(SRATE*SQTY)),'                                      
   SET @STRSQL = @STRSQL + ' BROKERAGE = SUM(PBROKAMT-SBROKAMT),'                                      
   SET @STRSQL = @STRSQL + ' SERVICE_TAX = SUM(SERVICE_TAX),'                                      
   SET @STRSQL = @STRSQL + ' INS_CHRG = SUM(INS_CHRG),'                                      
--   SET @STRSQL = @STRSQL + ' NETAMOUNT = (CASE WHEN SUM(PQTY-SQTY) > 0 THEN SUM(PBILLAMT-SBILLAMT) ELSE SUM(SBILLAMT-PBILLAMT) END),'                                      
   SET @STRSQL = @STRSQL + ' NETAMOUNT = (SUM(SBILLAMT-PBILLAMT)),'                                      
   SET @STRSQL = @STRSQL + ' SEBI_TAX = SUM(SEBI_TAX),'                                      
   SET @STRSQL = @STRSQL + ' TURN_TAX = SUM(TURN_TAX),'                                      
   SET @STRSQL = @STRSQL + ' BROKER_CHRG = SUM(BROKER_NOTE),'                                      
   SET @STRSQL = @STRSQL + ' OTHER_CHRG = SUM(D.OTHER_CHRG),'                                      
   SET @STRSQL = @STRSQL + ' NETAMOUNTALL= 0,'                                      
   SET @STRSQL = @STRSQL + ' BROK  = (CASE WHEN SUM(PQTY-SQTY) <> 0 THEN SUM(PBROKAMT-SBROKAMT)/SUM(PQTY-SQTY) ELSE 0 END),'                                      
   SET @STRSQL = @STRSQL + ' NETRATE = 0,'                                      
   SET @STRSQL = @STRSQL + ' CL_RATE = (CASE WHEN SUM(PQTY-SQTY) <> 0 THEN  ABS(SUM((PQTY-SQTY)*CL_RATE) / SUM(PQTY-SQTY)) ELSE 0 END), '                                      
   SET @STRSQL = @STRSQL + ' BROKERSEBIREGNO = O.BROKERSEBIREGNO,'                                      
   SET @STRSQL = @STRSQL + ' MEMBERCODE = O.MEMBERCODE,'                                      
   SET @STRSQL = @STRSQL + ' CINNO = O.CIN,'                                      
   SET @STRSQL = @STRSQL + ' SETTTYPE_DESC='''','                                      
   SET @STRSQL = @STRSQL + ' BFCF_FLAG = ''BF_'''                                      
                                      
   IF (                                      
     @SHAREDB = 'BSEFO'                                      
     --OR @SHAREDB = 'BSECURFO'                                      
     )                                      
   BEGIN      
    SET @STRSQL = @STRSQL + '+RIGHT(LEFT(PRODUCT_CODE,1),3), '                                      
   END                                      
   ELSE                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + '+LEFT(INST_TYPE,1), '                                      
   END                                      
                                      
   SET @STRSQL = @STRSQL + ' CONTRACT_HEADER_DET = '''', '                                      
   SET @STRSQL = @STRSQL + ' REMARK = '''', '                                      
   SET @STRSQL = @STRSQL + ' COMPANYNAME = O.COMPANY, USER_ID='''', '                                      
   SET @STRSQL = @STRSQL + ' REMARK_ID = '''', '                                      
   SET @STRSQL = @STRSQL + ' REMARK_DESC = '''', '                                
   SET @STRSQL = @STRSQL + ' NETOBLIGATION = 0, '                    
 SET @STRSQL = @STRSQL + ' M.BRANCH_CD, '                                      
   SET @STRSQL = @STRSQL + ' M.SUB_BROKER, '                         
   SET @STRSQL = @STRSQL + ' M.TRADER, '                                      
   SET @STRSQL = @STRSQL + ' M.AREA, '                                      
   SET @STRSQL = @STRSQL + ' M.REGION, '                                      
   SET @STRSQL = @STRSQL + ' M.FAMILY, '                                      
   SET @STRSQL = @STRSQL + ' PARTY_CODE= D.PARTY_CODE,'                                      
   SET @STRSQL = @STRSQL + ' PARTYNAME = LONG_NAME,'                                      
   SET @STRSQL = @STRSQL + ' M.L_ADDRESS1,'                                      
   SET @STRSQL = @STRSQL + ' M.L_ADDRESS2,'                                      
   SET @STRSQL = @STRSQL + ' M.L_ADDRESS3,'                                      
   SET @STRSQL = @STRSQL + ' M.L_STATE,'                                      
   SET @STRSQL = @STRSQL + ' M.L_CITY,'                                      
   SET @STRSQL = @STRSQL + ' M.L_ZIP,'                                      
   SET @STRSQL = @STRSQL + ' M.OFF_PHONE1,'                                      
   SET @STRSQL = @STRSQL + ' M.OFF_PHONE2,'                                      
   SET @STRSQL = @STRSQL + ' M.PAN_GIR_NO,'                                      
   SET @STRSQL = @STRSQL + ' MAPIDID = '''','                                      
   SET @STRSQL = @STRSQL + ' UCC_CODE= '''','                                      
   SET @STRSQL = @STRSQL + ' SEBI_NO = FD_CODE,'                                      
   SET @STRSQL = @STRSQL + ' PARTICIPANT_CODE = BANKID,'                                      
   SET @STRSQL = @STRSQL + ' M.CL_TYPE,'                                      
   SET @STRSQL = @STRSQL + ' SERVICE_CHRG,'                                      
  SET @STRSQL = @STRSQL + ' C2.PRINTF,'   
  SET @STRSQL = @STRSQL + ' BOOKTYPE='''' , '                                  
  SET @STRSQL = @STRSQL + ' INSTRUMENT='''' , '   
  SET @STRSQL = @STRSQL + ' ISIN='''' '   
    
   SET @STRSQL = @STRSQL + ' FROM '                                      
                                      
   IF (                                      
     @SHAREDB = 'BSEFO'                                     
    -- OR @SHAREDB = 'BSECURFO'                                      
     )                                      
   BEGIN                                  
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.BFOBILLVALAN D WITH (NOLOCK),'                                      
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.CLIENT1 M WITH (NOLOCK),'                                      
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.BFOOWNER O WITH (NOLOCK),'                                      
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.CLIENT2 C2 WITH (NOLOCK)'                                   
   END                                      
   ELSE                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.FOBILLVALAN D WITH (NOLOCK),'                                      
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.CLIENT1 M WITH (NOLOCK),'                              
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.FOOWNER O WITH (NOLOCK),'                                      
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.CLIENT2 C2 WITH (NOLOCK)'                                      
   END                                      
                                      
   SET @STRSQL = @STRSQL + 'WHERE'                                      
   SET @STRSQL = @STRSQL + ' 1 = 1'                                      
SET @STRSQL = @STRSQL + ' AND M.CL_CODE = C2.PARTY_CODE'    
   SET @STRSQL = @STRSQL + ' AND M.CL_CODE = D.PARTY_CODE'                                      
                                      
   IF @SHAREDB = 'NSEFO'                            
   BEGIN                                      
    SET @STRSQL = @STRSQL + ' AND LEFT(INST_TYPE,3) = ''FUT'' '                                      
   END                                      
                                      
   IF (                
     @SHAREDB = 'NSECURFO'                                      
     OR @SHAREDB = 'MCDXCDS'                                      
     )                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + ' AND LEFT(INST_TYPE,3) = ''FUT'' '                                      
   END                                      
                                      
   SET @STRSQL = @STRSQL + ' AND M.CL_CODE BETWEEN ''' + @FROMPARTY + ''' AND ''' + @TOPARTY + ''''                                      
   SET @STRSQL = @STRSQL + ' AND D.SAUDA_DATE BETWEEN ''' + @FROMDATE + ''' AND ''' + @FROMDATE + ' 23:59:59'''                                      
   ---SET @STRSQL = @STRSQL + ' AND TRADETYPE = ''BF'' '
   SET @STRSQL = @STRSQL + ' AND (TRADETYPE = ''BF'' OR (TRADETYPE = ''BT'' AND (PQTY-SQTY) <> 0 AND AUCTIONPART=''CA'' )) '                                      
   SET @STRSQL = @STRSQL + ' AND (PQTY-SQTY) <> 0 '                                      
   SET @STRSQL = @STRSQL + 'GROUP BY '                                      
   SET @STRSQL = @STRSQL + ' CONTRACTNO,'                                      
   SET @STRSQL = @STRSQL + ' SAUDA_DATE,'                                      
   SET @STRSQL = @STRSQL + ' M.BRANCH_CD, '                                      
   SET @STRSQL = @STRSQL + ' M.SUB_BROKER, '                                      
   SET @STRSQL = @STRSQL + ' M.TRADER, '                                      
   SET @STRSQL = @STRSQL + ' M.AREA, '                                      
   SET @STRSQL = @STRSQL + ' M.REGION, '                                      
   SET @STRSQL = @STRSQL + ' M.FAMILY, '                                      
   SET @STRSQL = @STRSQL + ' D.PARTY_CODE,'                                      
   SET @STRSQL = @STRSQL + ' LONG_NAME,'                                    
   SET @STRSQL = @STRSQL + ' M.L_ADDRESS1,'               
   SET @STRSQL = @STRSQL + ' M.L_ADDRESS2,'                                      
   SET @STRSQL = @STRSQL + ' M.L_ADDRESS3,'                                      
   SET @STRSQL = @STRSQL + ' M.L_STATE,'                                      
   SET @STRSQL = @STRSQL + ' M.L_CITY,'                                      
   SET @STRSQL = @STRSQL + ' M.L_ZIP,'                                      
   SET @STRSQL = @STRSQL + ' M.OFF_PHONE1,'                                      
   SET @STRSQL = @STRSQL + ' M.OFF_PHONE2,'      
   SET @STRSQL = @STRSQL + ' M.PAN_GIR_NO,'                                      
   SET @STRSQL = @STRSQL + ' FD_CODE,'                                      
   SET @STRSQL = @STRSQL + ' BANKID,'                                      
   SET @STRSQL = @STRSQL + ' M.CL_TYPE,'                                      
   SET @STRSQL = @STRSQL + ' SERVICE_CHRG,'                                      
   SET @STRSQL = @STRSQL + ' PRINTF, '                                      
                                      
   IF (                                      
     @SHAREDB = 'BSEFO'                                      
   -- OR @SHAREDB = 'BSECURFO'                                      
     )                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + ' RTRIM(PRODUCT_CODE) + '' '' + RTRIM(SERIES_CODE) + '' '' + CONVERT(VARCHAR,SERIES_ID,108),RIGHT(LEFT(PRODUCT_CODE,1),3),'                                      
END                                      
   ELSE                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + ' CASE '                                      
    SET @STRSQL = @STRSQL + ' WHEN LEFT(INST_TYPE,3) = ''FUT'' THEN RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' '' + LEFT(EXPIRYDATE,11) '                                      
    SET @STRSQL = @STRSQL + ' ELSE RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' '' + LEFT(EXPIRYDATE,11) + '' '' + CONVERT(VARCHAR,STRIKE_PRICE) + '' '' + RTRIM(OPTION_TYPE) '                                      
    SET @STRSQL = @STRSQL + ' END,LEFT(INST_TYPE,1),'                                      
   END                                      
                                      
   SET @STRSQL = @STRSQL + ' O.BROKERSEBIREGNO,O.MEMBERCODE,O.CIN,BRANCH_CD,M.SUB_BROKER,O.COMPANY '                                      
   SET @STRSQL = @STRSQL + 'ORDER BY '                                      
   SET @STRSQL = @STRSQL + ' SAUDA_DATE, '                                      
   SET @STRSQL = @STRSQL + ' D.PARTY_CODE '                                      
                                      
   --PRINT @STRSQL                               
                                      
   EXEC (@STRSQL)                                      
                                      
   /* FOR BT TRADE */                                      
   SET @STRSQL = 'IF (SELECT COUNT(1) FROM ' + @SHARESERVER + @SHAREDB + '.SYS.TABLES WHERE NAME=''CONTRACT_DATA_COMMON'') > 0 '                                      
   SET @STRSQL = @STRSQL + 'BEGIN '                                      
   SET @STRSQL = @STRSQL + 'INSERT INTO #CONTRACT '                                      
   SET @STRSQL = @STRSQL + ' SELECT CONTRACTNO,'                                      
   SET @STRSQL = @STRSQL + ' CONTRACTNO_NEW = CONTRACTNO,'                                      
   SET @STRSQL = @STRSQL + ' SAUDA_DATE,'                                      
   SET @STRSQL = @STRSQL + ' SETT_NO = '''','                                      
   SET @STRSQL = @STRSQL + ' SETT_TYPE = '''','                                      
   SET @STRSQL = @STRSQL + ' SETT_DATE = '''','                                      
   SET @STRSQL = @STRSQL + ' EXCHANGE = ''' + @EXCHANGE_NEW + ''','                                      
   SET @STRSQL = @STRSQL + ' SEGMENT = ''' + @SEGMENT_NEW + ''','                      
   SET @STRSQL = @STRSQL + ' ORDER_NO,'                                      
   SET @STRSQL = @STRSQL + ' ORDER_TIME,'                                      
   SET @STRSQL = @STRSQL + ' TRADE_NO,'                    
   SET @STRSQL = @STRSQL + ' TRADE_TIME=TRADETIME,'                                      
                                      
   IF (                                      
     @SHAREDB = 'BSEFO'                                      
   --  OR @SHAREDB = 'BSECURFO'                                      
     )                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + ' SCRIPNAME = RTRIM(PRODUCT_CODE) + '' '' + RTRIM(SERIES_CODE) + '' '' + CONVERT(VARCHAR,SERIES_ID,108),'                                      
   END                                      
   ELSE                                  
    IF @SHAREDB = 'NSECURFO'                                      
    BEGIN                                      
     SET @STRSQL = @STRSQL + ' SCRIPNAME = ('                                      
     SET @STRSQL = @STRSQL + ' CASE '                                      
     SET @STRSQL = @STRSQL + ' WHEN LEFT(INST_TYPE,3) = ''FUT'' THEN RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' '' + LEFT(EXPIRYDATE,11) '                                      
     SET @STRSQL = @STRSQL + ' ELSE RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' '' + LEFT(EXPIRYDATE,11) + '' '' + CONVERT(VARCHAR,STRIKE_PRICE) + '' '' + RTRIM(AUCTIONPART) '                                      
     SET @STRSQL = @STRSQL + ' END),'                                      
    END                      
    ELSE                                      
    BEGIN                                      
     SET @STRSQL = @STRSQL + ' SCRIPNAME = ('                           
     SET @STRSQL = @STRSQL + ' CASE '                                      
     SET @STRSQL = @STRSQL + ' WHEN LEFT(INST_TYPE,3) = ''FUT'' THEN RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' '' + LEFT(EXPIRYDATE,11) '                                      
     SET @STRSQL = @STRSQL + ' ELSE RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' '' + LEFT(EXPIRYDATE,11) + '' '' + CONVERT(VARCHAR,STRIKE_PRICE) + '' '' + RTRIM(OPTION_TYPE) '                                      
     SET @STRSQL = @STRSQL + ' END),'                                      
    END                                      
                                   
   SET @STRSQL = @STRSQL + ' QTY =PQTY+SQTY,'                                      
   SET @STRSQL = @STRSQL + ' TMARK = '''','                                      
   SET @STRSQL = @STRSQL + ' SELL_BUY = (CASE WHEN SELL_BUY = 1 THEN 1 ELSE 2 END),'                                      
   SET @STRSQL = @STRSQL + ' MARKETRATE = PRATE+SRATE,'                  
   --SET @STRSQL = @STRSQL + ' MARKETAMT = 0,'                                      
   SET @STRSQL = @STRSQL + ' MARKETAMT = ((PRATE + SRATE)*(PQTY+SQTY)),'                                      
   SET @STRSQL = @STRSQL + ' BROKERAGE,'                               
   SET @STRSQL = @STRSQL + ' SERVICE_TAX,'                                      
   SET @STRSQL = @STRSQL + ' INS_CHRG,'                                      
                                      
   IF (                                      
     @SHAREDB = 'BSEFO'                                      
    -- OR @SHAREDB = 'BSECURFO'                                      
     )                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + ' NETAMOUNT = ('                                      
    SET @STRSQL = @STRSQL + ' CASE'                                      
    SET @STRSQL = @STRSQL + ' WHEN SELL_BUY = 1'                                      
    SET @STRSQL = @STRSQL + ' THEN -(PAMT)'                                      
    SET @STRSQL = @STRSQL + ' ELSE (SAMT)'                                      
    SET @STRSQL = @STRSQL + ' END)  ,'                                      
   END                                      
   ELSE                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + ' NETAMOUNT = CASE WHEN LEFT(INST_TYPE,3) = ''FUT'' THEN ('                                      
    SET @STRSQL = @STRSQL + ' CASE'                                      
    SET @STRSQL = @STRSQL + ' WHEN SELL_BUY = 1'     
    SET @STRSQL = @STRSQL + ' THEN -(PAMT)'                                      
    SET @STRSQL = @STRSQL + ' ELSE (SAMT)'                                      
    SET @STRSQL = @STRSQL + ' END) ELSE '                                      
    SET @STRSQL = @STRSQL + ' (CASE'                                      
    SET @STRSQL = @STRSQL + ' WHEN SELL_BUY = 1'                                      
    SET @STRSQL = @STRSQL + ' THEN -(PAMT)'                                      
    SET @STRSQL = @STRSQL + ' ELSE (SAMT)'                                      
    SET @STRSQL = @STRSQL + ' END) END ,'                                      
   END                                      
                                      
   SET @STRSQL = @STRSQL + ' SEBI_TAX,'                                      
   SET @STRSQL = @STRSQL + ' TURN_TAX,'                                      
   SET @STRSQL = @STRSQL + ' BROKER_CHRG,'                                      
   SET @STRSQL = @STRSQL + ' D.OTHER_CHRG,'                                      
   SET @STRSQL = @STRSQL + ' NETAMOUNTALL = ('                                      
   SET @STRSQL = @STRSQL + ' CASE'                                      
   SET @STRSQL = @STRSQL + ' WHEN SELL_BUY = 1'                                      
   SET @STRSQL = @STRSQL + ' THEN -(PAMT+NSERTAX+INS_CHRG+SEBI_TAX+TURN_TAX+BROKER_CHRG+D.OTHER_CHRG)'                          
   SET @STRSQL = @STRSQL + ' ELSE (SAMT-NSERTAX-INS_CHRG-SEBI_TAX-TURN_TAX-BROKER_CHRG-D.OTHER_CHRG)'                                      
   SET @STRSQL = @STRSQL + ' END),'                                      
   SET @STRSQL = @STRSQL + ' BROK = (PBROK+SBROK),'                                  
   --SET @STRSQL = @STRSQL + ' NETRATE = (PNETRATE+SNETRATE),'                                                        
   --SET @STRSQL = @STRSQL + ' NETRATE = PRATE+PBROK+SRATE-SBROK ,'                                      
   SET @STRSQL = @STRSQL + ' NETRATE = (CASE WHEN SELL_BUY = 1 '                                    
   SET @STRSQL = @STRSQL + ' THEN (CASE WHEN PQTY >0 THEN PAMT/PQTY ELSE 0 END) '                                      
   SET @STRSQL = @STRSQL + ' ELSE (CASE WHEN SQTY >0 THEN SAMT/SQTY ELSE 0 END) END),'                                      
   SET @STRSQL = @STRSQL + ' CL_RATE = 0, '                                      
   SET @STRSQL = @STRSQL + ' BROKERSEBIREGNO = O.BROKERSEBIREGNO,MEMBERCODE=O.MEMBERCODE,CINNO=O.CIN,SETTTYPE_DESC='''', BFCF_FLAG = ''BT_'''      
                                      
   IF (                                      
     @SHAREDB = 'BSEFO'                                      
  --   OR @SHAREDB = 'BSECURFO'                                      
     )                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + '+RIGHT(LEFT(PRODUCT_CODE,1),3), '                                      
   END                                      
   ELSE                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + '+LEFT(INST_TYPE,1), '                                      
   END                                      
                                      
   SET @STRSQL = @STRSQL + ' CONTRACT_HEADER_DET = '''', '                                      
   SET @STRSQL = @STRSQL + ' REMARK = '''', '                                      
   SET @STRSQL = @STRSQL + ' COMPANYNAME = O.COMPANY, USER_ID='''', '                                      
   SET @STRSQL = @STRSQL + ' REMARK_ID = '''', '                                      
   SET @STRSQL = @STRSQL + ' REMARK_DESC = '''', '                                      
   SET @STRSQL = @STRSQL + ' NETOBLIGATION = 0, '                                      
   SET @STRSQL = @STRSQL + ' M.BRANCH_CD, '                                      
   SET @STRSQL = @STRSQL + ' M.SUBBROKER, '        
   SET @STRSQL = @STRSQL + ' M.TRADER, '                                      
   SET @STRSQL = @STRSQL + ' M.AREA, '                                      
   SET @STRSQL = @STRSQL + ' M.REGION, '                                      
   SET @STRSQL = @STRSQL + ' M.FAMILY, '                                      
   SET @STRSQL = @STRSQL + ' PARTY_CODE= D.PARTY_CODE,'                                      
   SET @STRSQL = @STRSQL + ' M.PARTYNAME,'                                      
   SET @STRSQL = @STRSQL + ' M.L_ADDRESS1,'                                      
   SET @STRSQL = @STRSQL + ' M.L_ADDRESS2,'                                      
   SET @STRSQL = @STRSQL + ' M.L_ADDRESS3,'                                      
   SET @STRSQL = @STRSQL + ' M.L_STATE,'                                      
   SET @STRSQL = @STRSQL + ' M.L_CITY,'                                      
   SET @STRSQL = @STRSQL + ' M.L_ZIP,'                                      
   SET @STRSQL = @STRSQL + ' M.OFF_PHONE1,'                                      
   SET @STRSQL = @STRSQL + ' M.OFF_PHONE2,'                                      
   SET @STRSQL = @STRSQL + ' M.PAN_GIR_NO,'                                      
   SET @STRSQL = @STRSQL + ' M.MAPIDID,'                                      
   SET @STRSQL = @STRSQL + ' M.UCC_CODE,'                                      
   SET @STRSQL = @STRSQL + ' M.SEBI_NO,'                                      
   SET @STRSQL = @STRSQL + ' PARTICIPANT_CODE = '''','               
   SET @STRSQL = @STRSQL + ' CL_TYPE = '''','                                      
   SET @STRSQL = @STRSQL + ' M.SERVICE_CHRG,'                                      
  SET @STRSQL = @STRSQL + ' M.PRINTF, '          
 IF  @SHAREDB = 'MCDXCDS'          
  BEGIN              
  SET @STRSQL = @STRSQL + ' PRICEUNIT,QTY_UNIT, '            
  END           
  ELSE            
 BEGIN            
 SET @STRSQL = @STRSQL + ' 0,0, '           
 END         
   SET @STRSQL = @STRSQL + ' ISIN='''' '    
   SET @STRSQL = @STRSQL + 'FROM '                                      
   SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.CONTRACT_DATA_COMMON D WITH (NOLOCK),'                                      
   SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.CONTRACT_MASTER_COMMON M WITH (NOLOCK),'                                      
                                      
   IF (                                      
     @SHAREDB = 'BSEFO'                                      
    -- OR @SHAREDB = 'BSECURFO'                                      
     )                                      
   BEGIN                                     
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.BFOOWNER O WITH (NOLOCK)'                                      
   END                                      
   ELSE                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.FOOWNER O WITH (NOLOCK)'                                      
   END                                      
                                      
   SET @STRSQL = @STRSQL + 'WHERE'                                      
   SET @STRSQL = @STRSQL + ' 1 = 1'                                      
   SET @STRSQL = @STRSQL + ' AND M.PARTY_CODE = D.PARTY_CODE'                                      
   SET @STRSQL = @STRSQL + ' AND LEFT(M.TRADE_DATE,11) = LEFT(D.SAUDA_DATE,11) '                                      
   SET @STRSQL = @STRSQL + ' AND M.PARTY_CODE BETWEEN ''' + @FROMPARTY + ''' AND ''' + @TOPARTY + ''''                                      
   SET @STRSQL = @STRSQL + ' AND D.SAUDA_DATE BETWEEN ''' + @FROMDATE + ''' AND ''' + @FROMDATE + ' 23:59:59'''                                      
   --SET @STRSQL = @STRSQL + ' AND EXISTS ( SELECT DISTINCT PARTYCODE FROM #PARTY P (NOLOCK) WHERE P.PARTYCODE = D.PARTY_CODE )'                                      
   SET @STRSQL = @STRSQL + 'ORDER BY'                                      
   SET @STRSQL = @STRSQL + ' SAUDA_DATE,'                                      
   SET @STRSQL = @STRSQL + ' D.PARTY_CODE'                                      
   SET @STRSQL = @STRSQL + ' END '                                      
                                      
   --PRINT @STRSQL                 
                                      
   EXEC (@STRSQL)                                      
                                         
   IF (@SHAREDB = 'BSEFO')                              
   BEGIN                                      
    SET @STRSQL = ' INSERT INTO #FOCLOSING '                                          
    SET @STRSQL = @STRSQL + ' SELECT TRADE_DATE, '                                    
    SET @STRSQL = @STRSQL + ' SCRIPNAME = RTRIM(PRODUCT_CODE) + '' '' + RTRIM(SERIES_CODE) + '' '' + CONVERT(VARCHAR,SERIES_ID,108), '                                      
    SET @STRSQL = @STRSQL + ' CL_RATE = CLOSE_PRICE, '  
    SET @STRSQL = @STRSQL + ' EXCHANGE = ''' + @EXCHANGE_NEW + ''',SEGMENT = ''' + @SEGMENT_NEW + ''' '                                                                              
    SET @STRSQL = @STRSQL + ' FROM ' + @SHARESERVER + @SHAREDB + '.DBO.BFOCLOSING WITH (NOLOCK) '                
    SET @STRSQL = @STRSQL + ' WHERE TRADE_DATE  BETWEEN ''' + @FROMDATE + ''' AND ''' + @FROMDATE + ' 23:59:59'''                                      
   END                    
   ELSE         
   BEGIN                                      
    SET @STRSQL = ' INSERT INTO #FOCLOSING '               
    SET @STRSQL = @STRSQL + ' SELECT TRADE_DATE, '                                      
    SET @STRSQL = @STRSQL + ' SCRIPNAME = (CASE WHEN LEFT(INST_TYPE,3) = ''FUT'' THEN RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' ''+ LEFT(EXPIRYDATE,11) '                                      
    SET @STRSQL = @STRSQL + ' ELSE RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' '' + LEFT(EXPIRYDATE,11) + '' ''+ CONVERT(VARCHAR,STRIKE_PRICE) + '' '' + RTRIM(OPTION_TYPE) END), '                                      
    SET @STRSQL = @STRSQL + '  CL_RATE ,'    
    SET @STRSQL = @STRSQL + ' EXCHANGE = ''' + @EXCHANGE_NEW + ''',SEGMENT = ''' + @SEGMENT_NEW + ''' '                                                                              
    SET @STRSQL = @STRSQL + ' FROM ' + @SHARESERVER + @SHAREDB + '.DBO.FOCLOSING WITH (NOLOCK) '                                      
    SET @STRSQL = @STRSQL + ' WHERE TRADE_DATE  BETWEEN ''' + @FROMDATE + ''' AND ''' + @FROMDATE + ' 23:59:59'' AND LEFT(INST_TYPE,3) = ''FUT'' '                                      
   END                                       
   EXEC (@STRSQL)                                      
                                        
                                      
                                      
   IF (@SHAREDB = 'BSEFO')                                      
   BEGIN                                      
    SET @STRSQL = ' UPDATE #CONTRACT SET USER_ID = S.TERMINALID FROM '                                      
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.BFOSETTLEMENT S WITH (NOLOCK) '                                      
   END                                      
   ELSE                                      
   BEGIN                                      
   SET @STRSQL = ' UPDATE #CONTRACT SET USER_ID = S.USER_ID FROM '                                      
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + @SHAREDB + '.DBO.FOSETTLEMENT S WITH (NOLOCK) '                                      
END                                      
   SET @STRSQL = @STRSQL + ' WHERE S.SAUDA_DATE BETWEEN ''' + @FROMDATE + ''' AND ''' + @FROMDATE + ' 23:59:59'''                                      
   SET @STRSQL = @STRSQL + ' AND S.ORDER_NO = #CONTRACT.ORDER_NO AND S.TRADE_NO = #CONTRACT.TRADE_NO '                                      
   SET @STRSQL = @STRSQL + ' AND S.PARTY_CODE = #CONTRACT.PARTY_CODE '                                      
   SET @STRSQL = @STRSQL + ' AND #CONTRACT.EXCHANGE = ''' + @EXCHANGE_NEW + ''' '                                      
   SET @STRSQL = @STRSQL + ' AND #CONTRACT.SEGMENT = ''' + @SEGMENT_NEW + ''' '                                      
                                      
   --PRINT @STRSQL                                      
   EXEC (@STRSQL)                                       
                                         
    
   SET @STRSQL = 'IF (SELECT COUNT(1) FROM ' + @SHARESERVER + @SHAREDB + '.SYS.TABLES WHERE NAME=''TBL_CONTRACT_TERMINAL_MAPPING'') > 0 '    
   SET @STRSQL = @STRSQL + 'BEGIN '    
   --SET @STRSQL = @STRSQL + 'IF (SELECT COUNT(1) FROM ' + @SHARESERVER + @SHAREDB + '.SYS.COLUMNS WHERE [NAME] = ''USER_ID''     
   --      AND [OBJECT_ID] IN (SELECT DISTINCT OBJECT_ID FROM ' + @SHARESERVER + @SHAREDB + '.SYS.TABLES WHERE NAME = ''CONTRACT_DATA'')) > 0 '    
   --SET @STRSQL = @STRSQL + 'BEGIN '    
  
SET @STRSQL = @STRSQL + ' TRUNCATE TABLE #CONTRACT_TERMINAL_MAPPING '  
SET @STRSQL = @STRSQL + ' INSERT INTO #CONTRACT_TERMINAL_MAPPING '  
SET @STRSQL = @STRSQL + ' SELECT TERMINAL_ID,ORDER_NO,REMARK_ID,REMARK_DESC FROM ' + @SHARESERVER + @SHAREDB + '.DBO.TBL_CONTRACT_TERMINAL_MAPPING '  
SET @STRSQL = @STRSQL + ' WHERE ''' + @FROMDATE + ''' = FROM_DATE '  
/*  
   SET @STRSQL = @STRSQL + ' UPDATE #CONTRACT SET REMARK_ID = ISNULL(T.REMARK_ID,''''), REMARK_DESC = ISNULL(T.REMARK_DESC,'''') '    
   --SET @STRSQL = @STRSQL + ' FROM ' + @SHARESERVER + @SHAREDB + '.DBO.TBL_CONTRACT_TERMINAL_MAPPING T (NOLOCK) '    
   SET @STRSQL = @STRSQL + ' FROM #CONTRACT_TERMINAL_MAPPING T (NOLOCK) '   
   SET @STRSQL = @STRSQL + ' WHERE (#CONTRACT.USER_ID = (CASE WHEN ISNULL(T.TERMINAL_ID,'''') <> '''' THEN ISNULL(T.TERMINAL_ID,'''') ELSE #CONTRACT.USER_ID END) '    
   SET @STRSQL = @STRSQL + ' AND #CONTRACT.ORDER_NO = (CASE WHEN ISNULL(T.ORDER_NO,'''') <> '''' THEN ISNULL(T.ORDER_NO,'''') ELSE #CONTRACT.ORDER_NO END)) '    
   SET @STRSQL = @STRSQL + ' AND (ISNULL(T.TERMINAL_ID,'''') <> '''' OR ISNULL(T.ORDER_NO,'''') <> '''')'    
   --SET @STRSQL = @STRSQL + ' AND CONVERT(DATETIME,SAUDA_DATE,103) BETWEEN CONVERT(DATETIME,CONVERT(VARCHAR,FROM_DATE,103),103) AND END_DATE '    
   --SET @STRSQL = @STRSQL + ' AND SAUDA_DATE BETWEEN FROM_DATE AND END_DATE '      
   SET @STRSQL = @STRSQL + ' AND EXCHANGE = ''' + @EXCHANGE_NEW + ''' AND SEGMENT = ''' + @SEGMENT_NEW + ''' '    
   --SET @STRSQL = @STRSQL + 'END '    
   SET @STRSQL = @STRSQL + 'END '    
*/  
  
  SET @STRSQL = @STRSQL + ' UPDATE #CONTRACT SET REMARK_ID = ISNULL(T.REMARK_ID,''''), REMARK_DESC = ISNULL(T.REMARK_DESC,'''') '    
  --SET @STRSQL = @STRSQL + ' FROM ' + @SHARESERVER + @SHAREDB + '.DBO.TBL_CONTRACT_TERMINAL_MAPPING T (NOLOCK) '    
  SET @STRSQL = @STRSQL + ' FROM #CONTRACT_TERMINAL_MAPPING T '    
  SET @STRSQL = @STRSQL + ' WHERE #CONTRACT.ORDER_NO = T.ORDER_NO '    
  SET @STRSQL = @STRSQL + ' AND ISNULL(T.ORDER_NO,'''') <> '''' '    
--  SET @STRSQL = @STRSQL + ' AND CONVERT(DATETIME,SAUDA_DATE,103) BETWEEN CONVERT(DATETIME,CONVERT(VARCHAR,FROM_DATE,103),103) AND END_DATE '    
  --SET @STRSQL = @STRSQL + ' AND CONVERT(VARCHAR(11),SAUDA_DATE,109) BETWEEN CONVERT(VARCHAR(11),FROM_DATE,109) AND CONVERT(VARCHAR(11),END_DATE,109) '      
  --SET @STRSQL = @STRSQL + ' AND SAUDA_DATE BETWEEN FROM_DATE AND END_DATE '      
  SET @STRSQL = @STRSQL + ' AND EXCHANGE = ''' + @EXCHANGE_NEW + ''' AND SEGMENT = ''' + @SEGMENT_NEW + ''' '    
  --SET @STRSQL = @STRSQL + 'END '   
    
  SET @STRSQL = @STRSQL + ' UPDATE #CONTRACT SET REMARK_ID = ISNULL(T.REMARK_ID,''''), REMARK_DESC = ISNULL(T.REMARK_DESC,'''') '    
  --SET @STRSQL = @STRSQL + ' FROM ' + @SHARESERVER + @SHAREDB + '.DBO.TBL_CONTRACT_TERMINAL_MAPPING T (NOLOCK) '    
  SET @STRSQL = @STRSQL + ' FROM #CONTRACT_TERMINAL_MAPPING T '    
  SET @STRSQL = @STRSQL + ' WHERE #CONTRACT.USER_ID = T.TERMINAL_ID '    
  SET @STRSQL = @STRSQL + ' AND ISNULL(T.TERMINAL_ID,'''') <> '''' '    
--  SET @STRSQL = @STRSQL + ' AND CONVERT(DATETIME,SAUDA_DATE,103) BETWEEN CONVERT(DATETIME,CONVERT(VARCHAR,FROM_DATE,103),103) AND END_DATE '    
  --SET @STRSQL = @STRSQL + ' AND CONVERT(VARCHAR(11),SAUDA_DATE,109) BETWEEN CONVERT(VARCHAR(11),FROM_DATE,109) AND CONVERT(VARCHAR(11),END_DATE,109) '      
  --SET @STRSQL = @STRSQL + ' AND SAUDA_DATE BETWEEN FROM_DATE AND END_DATE '      
  SET @STRSQL = @STRSQL + ' AND EXCHANGE = ''' + @EXCHANGE_NEW + ''' AND SEGMENT = ''' + @SEGMENT_NEW + ''' '    
  --SET @STRSQL = @STRSQL + 'END '    
  SET @STRSQL = @STRSQL + 'END '     
   --PRINT @STRSQL    
    
   EXEC (@STRSQL)    
                              
                            
                                         
   SET @STRSQL = 'UPDATE #CONTRACT SET CL_RATE = ISNULL(F.CL_RATE,0) '                                      
   SET @STRSQL = @STRSQL + ' FROM #FOCLOSING F '                                      
   SET @STRSQL = @STRSQL + ' WHERE F.SCRIPNAME = #CONTRACT.SCRIPNAME '     
   SET @STRSQL = @STRSQL + ' AND  F.EXCHANGE = #CONTRACT.EXCHANGE '   
   SET @STRSQL = @STRSQL + ' AND  F.SEGMENT = #CONTRACT.SEGMENT '                                    
   SET @STRSQL = @STRSQL + ' AND LEFT(BFCF_FLAG,2) = ''BT'' '                                      
   EXEC (@STRSQL)                                      
                                         
   TRUNCATE TABLE #FOCLOSING               
             
                                         
   /*                         
   --IF @SHAREDB <> 'BSEFO'                                       
   IF (                                      
     @SHAREDB <> 'BSEFO'                                      
     --OR @SHAREDB <> 'BSECURFO'                                      
     )                                      
   BEGIN                                      
    SET @STRSQL = 'UPDATE #CONTRACT SET CL_RATE = ISNULL(F.CL_RATE,0) '                                      
    SET @STRSQL = @STRSQL + ' FROM ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.FOCLOSING F WITH (NOLOCK) '                                      
    SET @STRSQL = @STRSQL + ' WHERE F.TRADE_DATE BETWEEN ''' + @FROMDATE + ''' AND ''' + @FROMDATE + ' 23:59:59'''                                      
    SET @STRSQL = @STRSQL + ' AND SCRIPNAME = (CASE WHEN F.INST_TYPE LIKE ''FUT%'' THEN RTRIM(F.INST_TYPE) + '' '' + RTRIM(F.SYMBOL) + '' ''                                       
         + LEFT(F.EXPIRYDATE,11) ELSE RTRIM(F.INST_TYPE) + '' '' + RTRIM(F.SYMBOL) + '' '' + LEFT(F.EXPIRYDATE,11) + ''''                                       
         + RTRIM(CAST(CAST(F.STRIKE_PRICE AS NUMERIC(18,0)) AS VARCHAR)) + '' '' + RTRIM(F.OPTION_TYPE) END) '                                      
    SET @STRSQL = @STRSQL + ' AND LEFT(BFCF_FLAG,2) = ''BT'' '                                      
   END                                      
                                      
   IF (@SHAREDB = 'BSEFO')             
   BEGIN                                      
    SET @STRSQL = 'UPDATE #CONTRACT SET CL_RATE = ISNULL(F.CLOSE_PRICE,0) '                                      
    SET @STRSQL = @STRSQL + ' FROM ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.BFOCLOSING F WITH (NOLOCK) '                                      
    SET @STRSQL = @STRSQL + ' WHERE F.TRADE_DATE BETWEEN ''' + @FROMDATE + ''' AND ''' + @FROMDATE + ' 23:59:59'''                                      
    SET @STRSQL = @STRSQL + ' AND SCRIPNAME = (RTRIM(F.PRODUCT_CODE) + '' '' + RTRIM(F.SERIES_CODE) + '' '' + CONVERT(VARCHAR,F.SERIES_ID,108)) '                                      
    SET @STRSQL = @STRSQL + ' AND LEFT(BFCF_FLAG,2) = ''BT'''                                      
   END                                      
                                      
   IF (@SHAREDB = 'BSECURFO')                                      
   BEGIN                                      
    SET @STRSQL = 'UPDATE #CONTRACT SET CL_RATE = ISNULL(F.CL_RATE,0) '                                      
    SET @STRSQL = @STRSQL + ' FROM ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.FOCLOSING F WITH (NOLOCK) '                                      
    SET @STRSQL = @STRSQL + ' WHERE F.TRADE_DATE BETWEEN ''' + @FROMDATE + ''' AND ''' + @FROMDATE + ' 23:59:59'''                                
    --SET @STRSQL = @STRSQL + ' AND SCRIPNAME = (RTRIM(F.PRODUCT_CODE) + '' '' + RTRIM(F.SERIES_CODE) + '' '' + CONVERT(VARCHAR,F.SERIES_ID,108)) '                                      
   SET @STRSQL = @STRSQL + ' AND SCRIPNAME = (RTRIM(F.SYMBOL)) '                                      
    -- + '' '' + RTRIM(F.SERIES_CODE) + '' '' + CONVERT(VARCHAR,F.SERIES_ID,108)) '                                      
    --SET @STRSQL = @STRSQL + ' AND LEFT(BFCF_FLAG,2) = ''BT'''                                      
   END                                      
                                      
   --PRINT @STRSQL                                      
   EXEC (@STRSQL)                       
   */                                      
                                      
   SET @STRSQL = ' INSERT INTO #MTOM_FNO '                                      
   SET @STRSQL = @STRSQL + ' SELECT PARTY_CODE, MTM = SUM(SBILLAMT - PBILLAMT), EXCHANGE = ''' + @EXCHANGE_NEW + ''', SEGMENT = ''' + @SEGMENT_NEW + ''' '                                      
                                   
   --   IF @SHAREDB = 'BSEFO'                  
   IF (                                      
     @SHAREDB = 'BSEFO'                         
     --OR @SHAREDB = 'BSECURFO'                           
     )                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + ' FROM ' + @SHARESERVER + @SHAREDB + '.DBO.BFOBILLVALAN F WITH (NOLOCK) '                                      
   END                                      
   ELSE                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + ' FROM ' + @SHARESERVER + @SHAREDB + '.DBO.FOBILLVALAN F WITH (NOLOCK) '                                      
   END                                      
                                      
   SET @STRSQL = @STRSQL + ' WHERE SAUDA_DATE BETWEEN ''' + @FROMDATE + ''' AND ''' + @FROMDATE + ' 23:59:59'''                                      
   SET @STRSQL = @STRSQL + ' AND PARTY_CODE BETWEEN ''' + @FROMPARTY + ''' AND ''' + @TOPARTY + ''''                                      
   /*                                      
   IF @SHAREDB = 'BSEFO'                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + ' AND RIGHT(F.PRODUCT_CODE,3) = ''FUT'' '                                      
   END                                      
   ELSE                                      
   BEGIN                                      
    SET @STRSQL = @STRSQL + ' AND LEFT(F.INST_TYPE,3) = ''FUT'' '                                      
   END                                      
   */                                    
   SET @STRSQL = @STRSQL + ' GROUP BY PARTY_CODE '                                      
                                      
   --PRINT @STRSQL                                      
                                      
   EXEC (@STRSQL)                                      
  END                                      
             
 --END                                                        
 FETCH NEXT                              
 FROM @EXCHANGEWISE_CURSOR                                      
 INTO @COMPANYNAME,                                      
  @EXCHANGE_NEW,                   
  @SEGMENT_NEW,                                      
  @SHAREDB,                                      
  @SHARESERVER,                                      
  @ACCOUNTDB,                                      
  @ACCOUNTSERVER,  
  @CONTRACTGROUP_NEW  
END                                      
                                      
CLOSE @EXCHANGEWISE_CURSOR                                      
                                      
DEALLOCATE @EXCHANGEWISE_CURSOR                                      
                                      
UPDATE #CONTRACT                                      
SET NETOBLIGATION = MTM                                      
FROM #MTOM_FNO F(NOLOCK)                                      
WHERE F.PARTY_CODE = #CONTRACT.PARTY_CODE                                      
 AND F.EXCHANGE = #CONTRACT.EXCHANGE                                      
 AND F.SEGMENT = #CONTRACT.SEGMENT                  
UPDATE #CONTRACT SET NETAMOUNT =            
        CASE WHEN SELL_BUY =2 THEN ROUND((MARKETRATE - CL_RATE) * QTY,4) - BROKERAGE                    
        ELSE ROUND((CL_RATE-MARKETRATE) * QTY,4) - BROKERAGE END                    
                              
WHERE SEGMENT = 'FUTURES'                    
AND EXCHANGE <> 'MCD'                
AND LEFT(BFCF_FLAG, 2) = 'BT'             
                                        
            
              
                     
UPDATE #CONTRACT SET NETAMOUNT =             
        CASE WHEN SELL_BUY =2 THEN ROUND((MARKETRATE - CL_RATE) * QTY*CONVERT(INT,BOOKTYPE)/CONVERT(INT,INSTRUMENT)  ,4) - BROKERAGE                   
            
        ELSE ROUND((CL_RATE-MARKETRATE) * QTY*CONVERT(INT,BOOKTYPE)/CONVERT(INT,INSTRUMENT),4) - BROKERAGE END                   
                    
         
        
                  
WHERE SEGMENT = 'FUTURES'                    
AND EXCHANGE = 'MCD'                
AND LEFT(BFCF_FLAG, 2) = 'BT'         
                                  
SELECT  * INTO #CLIENT_DETAILS FROM MSAJAG..CLIENT_DETAILS  WHERE CL_CODE IN (SELECT DISTINCT PARTY_CODE FROM #CONTRACT )                        
  
CREATE CLUSTERED INDEX IDX_CL ON #CLIENT_DETAILS  
(  
 cl_code  
)  
  
UPDATE #CONTRACT      
SET CL_TYPE = ISNULL(C.CL_TYPE, ''),                                      
MAPIDID = MAPIN_ID,                 
UCC_CODE = C.UCC_CODE                                      
FROM #CLIENT_DETAILS C(NOLOCK)                                      
WHERE C.CL_CODE = #CONTRACT.PARTY_CODE                            
 AND SEGMENT = 'FUTURES'    
  
  
  
/*  
UPDATE #CONTRACT      
SET CL_TYPE = ISNULL(C.CL_TYPE, ''),                                      
 MAPIDID = MAPIN_ID,                 
 UCC_CODE = C.UCC_CODE                                      
FROM MSAJAG..CLIENT_DETAILS C(NOLOCK)                                      
WHERE C.CL_CODE = #CONTRACT.PARTY_CODE                            
 AND SEGMENT = 'FUTURES'     
   
 */                                   
                                      
UPDATE #CONTRACT                                      
SET SCRIPNAME = SCRIPNAME + ' (' + LEFT(BFCF_FLAG, 2) + ')'                                      
WHERE SEGMENT = 'FUTURES'                                      
 AND LEN(BFCF_FLAG) <> 0   
   
 UPDATE #CONTRACT                                      
SET SCRIPNAME = 'BROKERAGE'                                      
WHERE SEGMENT = 'FUTURES'   
 AND  LEFT(SCRIPNAME,5)='BROKE'                                   
  
                                     
                                      
UPDATE #CONTRACT                                      
SET CONTRACTNO = A.CONTRACTNO                                      
FROM (                                      
 SELECT SAUDA_DATE = LEFT(SAUDA_DATE, 11),                                      
  PARTY_CODE,                                      
  SETT_TYPE,                                      
  CONTRACTNO                                      
 FROM #CONTRACT(NOLOCK)                                      
 WHERE CONTRACTNO <> 0                                      
 GROUP BY LEFT(SAUDA_DATE, 11),                                      
  PARTY_CODE,                                      
  CONTRACTNO,                           
  SETT_TYPE                                      
 ) A                                      
WHERE A.PARTY_CODE = #CONTRACT.PARTY_CODE                                      
 AND LEFT(A.SAUDA_DATE, 11) = LEFT(#CONTRACT.SAUDA_DATE, 11)                                      
 AND A.SETT_TYPE = #CONTRACT.SETT_TYPE                                      
 AND #CONTRACT.SCRIPNAME = 'BROKERAGE'                                      
 AND #CONTRACT.SCRIPNAME = ''                                      
 AND #CONTRACT.CONTRACTNO = 0                                      
                                      
UPDATE #CONTRACT                                      
SET CONTRACT_HEADER_DET = EXCHANGE + ' - ' + SEGMENT + ' - ' + (CASE WHEN SEGMENT = 'CAPITAL' THEN SETTTYPE_DESC + ' (' + LTRIM(RTRIM(SETT_NO)) + ' - ' + LTRIM(RTRIM(SETT_TYPE)) + ' - ' + LTRIM(RTRIM(SETT_DATE)) + ' - REF. NO: ' + LTRIM(RTRIM(CONTRACTNO)

  
  
)+ ')' ELSE 'REF. NO: ' + LTRIM(RTRIM(CONTRACTNO)) END)                                      
                                      
--SCRIPNAME_NEW = (CASE WHEN REMARK_ID <> '' THEN '(' + REMARK_ID + ')' ELSE '' END) + LTRIM(RTRIM(SCRIPNAME))                                      
UPDATE #CONTRACT                                      
SET CONTRACT_HEADER_DET = EXCHANGE + ' - ' + SEGMENT                                      
WHERE SEGMENT = 'FUTURES'                                      
 AND BFCF_FLAG = 'BF_F'                                   
 AND LEFT(BFCF_FLAG, 2) = 'BT'                                      
                                      
UPDATE #CONTRACT                                      
SET CONTRACTNO = 0                                      
WHERE #CONTRACT.SCRIPNAME LIKE '%BROKERAGE%'            
  
  
--print '111'                            
                                      
--------------------------------- COMMON CONTRACT NO UPDATE STARTS HERE ----------------------------                                      
DECLARE @CONTGEN_COMMON INT                                      
                                      
IF (                                      
  SELECT COUNT(1)                                      
  FROM CONTGEN_COMMON                                      
  WHERE @FROMDATE BETWEEN START_DATE AND END_DATE                                      
  ) = 0                                      
BEGIN                                      
 RAISERROR (                                      
   'CANNOT PROCEED. PLEASE CONFIGURE THE CONT GEN COMMON FIRST',                                      
   16,                                      
   1                                      
   )                                      
                                      
 RETURN                                      
END                                     
                                      
BEGIN TRANSACTION                                      
                                      
SELECT @CONTGEN_COMMON = ISNULL(CONVERT(INT, CONTRACTNO), 0)                                      
FROM CONTGEN_COMMON                                      
WHERE @FROMDATE BETWEEN START_DATE AND END_DATE                                      
                                      
CREATE TABLE #CONTRACTNO (                                      
 SNO INT IDENTITY(1,1) NOT NULL,                                      
 PARTY_CODE VARCHAR(20),
 SETT_DATE	VARCHAR(11)                                      
 )                                      
             
CREATE CLUSTERED INDEX IDXPARTY ON #CONTRACTNO (PARTY_CODE)                                      
                                      
UPDATE #CONTRACT                                      
SET CONTRACTNO_NEW = ''        
  
  
SELECT DISTINCT EXCHANGE = LTRIM(RTRIM(EXCHANGE))+LTRIM(RTRIM(SEGMENT))  
INTO #EXCHANGE_NEW  
FROM #CONTRACT                                
  
CREATE TABLE #OLDCONTRACTNO  
(  
 PARTY_CODE VARCHAR(10),  
 CONTRACTNO_NEW VARCHAR(10)  
)  
  
CREATE CLUSTERED INDEX IDXPARTY ON #OLDCONTRACTNO (PARTY_CODE)                                      
  
 SET @EXCHANGEWISE_CURSOR_NEW = CURSOR  FOR                                      
 SELECT DISTINCT CONTRACTGROUP_NEW FROM #CONTMULTI  
 GROUP BY CONTRACTGROUP_NEW  
 ORDER BY CONTRACTGROUP_NEW  
  
 OPEN @EXCHANGEWISE_CURSOR_NEW  
 FETCH NEXT FROM @EXCHANGEWISE_CURSOR_NEW INTO @CONTRACTGROUP_NEW1  
 BEGIN  
 TRUNCATE TABLE #OLDCONTRACTNO  
 TRUNCATE TABLE #CONTRACTNO  
  
 INSERT  INTO #OLDCONTRACTNO   
 SELECT DISTINCT PARTY_CODE, CONTRACTNO_NEW FROM COMMON_CONTRACT_DATA (NOLOCK)                                      
 WHERE SAUDA_DATE BETWEEN @FROMDATE AND @FROMDATE + ' 23:59:59'  
 AND EXISTS (SELECT DISTINCT EXCHANGE FROM #CONTMULTI C 
 WHERE C.EXCHANGE+C.SEGMENT = LTRIM(RTRIM(COMMON_CONTRACT_DATA.EXCHANGE))+LTRIM(RTRIM(COMMON_CONTRACT_DATA.SEGMENT))  
    AND CONTRACTGROUP_NEW = @CONTRACTGROUP_NEW1)  

  /*
  DECLARE @SEG INT
  SELECT @SEG=COUNT(1) FROM COMMON_CONTRACT_DATA (NOLOCK)                                      
 WHERE SAUDA_DATE BETWEEN @FROMDATE AND @FROMDATE + ' 23:59:59'  
 AND EXCHANGE IN ('NSE','BSE')

 IF @SEG =0
    BEGIN 
	   INSERT  INTO #OLDCONTRACTNO   
	   SELECT PARTY_CODE,CONTRACTNOTENO FROM TBL_COMMONCONTRACTNOMASTER_CLOUD(NOLOCK)
	   WHERE TRADEDATE BETWEEN @FROMDATE AND @FROMDATE + ' 23:59:59' 
 
	   DECLARE @MXCONTNO INT
	   SELECT @MXCONTNO=MAX(ISNULL(RWNO,0)) FROM TBL_COMMONCONTRACTNOMASTER_CLOUD(NOLOCK)
	   WHERE TRADEDATE BETWEEN @FROMDATE AND @FROMDATE + ' 23:59:59' 

	   UPDATE CONTGEN_COMMON  SET CONTRACTNO = @MXCONTNO                                      
		WHERE @FROMDATE BETWEEN START_DATE AND END_DATE   
		
	SET @CONTGEN_COMMON =@MXCONTNO
		
		  
    END  
  */
 UPDATE #CONTRACT                                      
 SET CONTRACTNO_NEW = C.CONTRACTNO_NEW                                      
 FROM #OLDCONTRACTNO C(NOLOCK)                                      
 WHERE C.PARTY_CODE = #CONTRACT.PARTY_CODE                                      
    AND EXISTS (SELECT DISTINCT EXCHANGE FROM #CONTMULTI C 
	WHERE C.EXCHANGE+C.SEGMENT = LTRIM(RTRIM(#CONTRACT.EXCHANGE))+LTRIM(RTRIM(#CONTRACT.SEGMENT))  
    AND CONTRACTGROUP_NEW = @CONTRACTGROUP_NEW1)  
                                          
 INSERT INTO #CONTRACTNO                                      
 SELECT DISTINCT PARTY_CODE,
 SETT_DATE = (
			CASE 
				WHEN @CONTRACT_T1T2 = 1 THEN (CASE WHEN EXCHANGE IN ('NSE','BSE') AND SEGMENT='CAPITAL' THEN SETT_DATE ELSE '' END) 
				ELSE '' 
			END)                                      
 FROM #CONTRACT                                      
 WHERE SAUDA_DATE BETWEEN @FROMDATE AND @FROMDATE + ' 23:59:59'  
 AND CONTRACTNO_NEW = ''            
    AND EXISTS (SELECT DISTINCT EXCHANGE FROM #CONTMULTI C WHERE C.EXCHANGE+C.SEGMENT = LTRIM(RTRIM(#CONTRACT.EXCHANGE))+LTRIM(RTRIM(#CONTRACT.SEGMENT))  
    AND CONTRACTGROUP_NEW = @CONTRACTGROUP_NEW1)  
 --print 111  
  
                                          
 UPDATE #CONTRACT                                      
 SET CONTRACTNO_NEW = STUFF('0000000000', 11 - LEN(@CONTGEN_COMMON + SNO), LEN(@CONTGEN_COMMON + SNO), @CONTGEN_COMMON + SNO)                                      
 FROM #CONTRACTNO T                                      
 WHERE #CONTRACT.PARTY_CODE = T.PARTY_CODE                                      
    AND EXISTS (SELECT DISTINCT EXCHANGE FROM #CONTMULTI C WHERE C.EXCHANGE+C.SEGMENT = LTRIM(RTRIM(#CONTRACT.EXCHANGE))+LTRIM(RTRIM(#CONTRACT.SEGMENT))  
    AND CONTRACTGROUP_NEW = @CONTRACTGROUP_NEW1)  
                                         
/* ---- START CHANGES FOR T1T2 SETTELEMENT ---*/

UPDATE #CONTRACT
SET CONTRACTNO_NEW = STUFF('0000000', 8 - LEN(@CONTGEN_COMMON + SNO), LEN(@CONTGEN_COMMON + SNO), @CONTGEN_COMMON + SNO)
FROM #CONTRACT B,
	#CONTRACTNO T
WHERE B.PARTY_CODE = T.PARTY_CODE
AND B.SETT_DATE = T.SETT_DATE
--AND B.SEGMENT = 'CAPITAL'
AND @CONTRACT_T1T2 = 1
AND EXISTS (SELECT DISTINCT EXCHANGE FROM #CONTMULTI C WHERE C.EXCHANGE+C.SEGMENT = LTRIM(RTRIM(B.EXCHANGE))+LTRIM(RTRIM(B.SEGMENT))  
AND CONTRACTGROUP_NEW = @CONTRACTGROUP_NEW1) 

/* ---- END CHANGES FOR T1T2 SETTELEMENT ---*/ 
 
 SELECT @CONTGEN_COMMON = @CONTGEN_COMMON + ISNULL(MAX(SNO), 0)                                      
 FROM #CONTRACTNO                                      
                                      
 UPDATE CONTGEN_COMMON                                 
 SET CONTRACTNO = @CONTGEN_COMMON                                      
 WHERE @FROMDATE BETWEEN START_DATE AND END_DATE                                      
  
 --print 1111  
   
 FETCH NEXT FROM @EXCHANGEWISE_CURSOR_NEW INTO @CONTRACTGROUP_NEW1  
END  
CLOSE @EXCHANGEWISE_CURSOR_NEW  
DEALLOCATE @EXCHANGEWISE_CURSOR_NEW  
  
DROP TABLE #CONTRACTNO                                      
--print 11111                                      
--------------------------------- COMMON CONTRACT NO UPDATE ENDS HERE ----------------------------         
DELETE                                      
FROM COMMON_CONTRACT_DATA                                      
WHERE SAUDA_DATE BETWEEN @FROMDATE AND @FROMDATE + ' 23:59:59'                                      
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                      
AND EXISTS (SELECT DISTINCT EXCHANGE FROM #EXCHANGE_NEW C WHERE C.EXCHANGE = LTRIM(RTRIM(COMMON_CONTRACT_DATA.EXCHANGE))+LTRIM(RTRIM(COMMON_CONTRACT_DATA.SEGMENT)))  

-----SET IDENTITY_INSERT COMMON_CONTRACT_DATA OFF                                      
INSERT INTO COMMON_CONTRACT_DATA                                      
SELECT *  
FROM #CONTRACT                                      
ORDER BY PARTY_CODE,                                      
 EXCHANGE,                                      
 SEGMENT,                                      
 SCRIPNAME     
------- SET IDENTITY_INSERT COMMON_CONTRACT_DATA ON                                     
                                      
/* FOR LOG OF USER*/                            
DECLARE @EXCHANGE VARCHAR(20)                                      
DECLARE @DESC VARCHAR(MAX)                                      
DECLARE @SEGMENT VARCHAR(20)                                      
                                      
SELECT DISTINCT EXCHANGE,                                      
 SEGMENT,                                      
 EXCHANGE_DET = EXCHANGE + '-' + SEGMENT                                      
INTO #EXCHANGE                                      
FROM COMMON_CONTRACT_DATA                                      
WHERE SAUDA_DATE BETWEEN @FROMDATE AND @FROMDATE + ' 23:59:59'                                      
AND EXISTS (SELECT DISTINCT EXCHANGE FROM #EXCHANGE_NEW C WHERE C.EXCHANGE = LTRIM(RTRIM(COMMON_CONTRACT_DATA.EXCHANGE))+LTRIM(RTRIM(COMMON_CONTRACT_DATA.SEGMENT)))  
ORDER BY EXCHANGE,                                      
 SEGMENT                                      
                                      
ALTER TABLE #EXCHANGE                                      
                                      
ALTER COLUMN EXCHANGE_DET VARCHAR(MAX)                                      
                                      
SET @EXCHANGE = ''                                      
SET @DESC = ''                                     
SET @SEGMENT = ''                                      
                                      
UPDATE #EXCHANGE                                     
SET @DESC = EXCHANGE_DET = @DESC + '|' + EXCHANGE_DET,                              
 @EXCHANGE = EXCHANGE,                                      
 @SEGMENT = SEGMENT                                      
                                      
DECLARE @DESCRIPTION VARCHAR(MAX)                                      
                                      
SET @DESCRIPTION = (                                      
  SELECT MAX(EXCHANGE_DET)                                      
  FROM #EXCHANGE                                      
  )                                      
                                    
IF LEN(@DESCRIPTION) > 0                                      
BEGIN                                      
 INSERT INTO [COMMONCN_PROCESS_LOG]                                      
 VALUES (                                      
  @FROMDATE,                                  
  @USERNAME,                                      
  @DESCRIPTION,                                      
  GETDATE()                                      
  )                         
END                                      
                                 
/* END FOR LOG OF USER*/                                 
                                
                                
--EXEC PROC_MARING_REPORT_NEW  @FROMDATE    
  
 UPDATE COMMON_CONTRACT_DATA SET TRADE_TIME = '16:00:00'  WHERE SAUDA_DATE >= @FROMDATE  AND SAUDA_DATE <= @FROMDATE  + ' 23:59' 
  AND SETT_TYPE IN ('A','AD','AC','X') AND CONTRACTNO = '0000000' AND TRADE_TIME = '11:00:00'
  
  
UPDATE CLIENT_BROK_DETAILS  
SET DEACTIVE_VALUE = 'R',DEACTIVE_REMARKS = '',MODIFIEDBY = 'CCN',MODIFIEDON = GETDATE()  
FROM COMMON_CONTRACT_DATA , CLIENT_BROK_DETAILS  
WHERE COMMON_CONTRACT_DATA.SAUDA_DATE >= @FROMDATE  
AND COMMON_CONTRACT_DATA.SAUDA_DATE <= @FROMDATE   + ' 23:59' 
AND CLIENT_BROK_DETAILS.CL_CODE=COMMON_CONTRACT_DATA.PARTY_CODE  
AND CLIENT_BROK_DETAILS.DEACTIVE_VALUE = 'D'  
AND CLIENT_BROK_DETAILS.INACTIVE_FROM >= GETDATE()  
AND  CLIENT_BROK_DETAILS.EXCHANGE NOT IN ('NCX','MCX')                            
                                     
COMMIT                 

INSERT INTO CCN_STATUS (SAUDA_DATE,PROCESS_FOR,PROCESS_START_DATE,PROCESS_END_DATE) 
SELECT SAUDA_DATE=@FROMDATE,PROCESS_FOR=@CONTRACTGROUP,PROCESS_START_DATE=@SDDATE,PROCESS_END_DATE =GETDATE()
                     
                                      
DROP TABLE #PARTY                                      
                     
DROP TABLE #CONTRACT                                      
                                      
DROP TABLE #CLIENT_BROK_DETAILS                                      
                                      
DROP TABLE #MTOM_FNO                                      
                                      
DROP TABLE #EXCHANGE   
set xact_abort off

GO
