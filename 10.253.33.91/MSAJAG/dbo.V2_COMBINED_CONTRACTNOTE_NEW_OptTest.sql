-- Object: PROCEDURE dbo.V2_COMBINED_CONTRACTNOTE_NEW_OptTest
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





              
              
CREATE PROCEDURE [dbo].[V2_COMBINED_CONTRACTNOTE_NEW_OptTest] (              
 @STATUSID VARCHAR(15),              
 @STATUSNAME VARCHAR(25),              
 @FROMDATE VARCHAR(11),              
 @TODATE VARCHAR(11),              
 @FROMPARTY VARCHAR(10),              
 @TOPARTY VARCHAR(10),              
 @FROMBRANCH VARCHAR(10),              
 @TOBRANCH VARCHAR(10),              
 @FROMSUB_BROKER VARCHAR(10),              
 @TOSUB_BROKER VARCHAR(10),              
 @FROMCONTRACT VARCHAR(10),              
 @TOCONTRACT VARCHAR(10),              
 @CONTFLAG VARCHAR(10),              
 @EXCHANGE VARCHAR(15),              
 --@SEGMENT  VARCHAR(7),                                
 @BOUNCEDFLAG INT ,              
 @PRINTFLAG VARCHAR(6),              
 --@SETT_TYPE VARCHAR(2) = '',              
 @COMPANY_NAME VARCHAR(100),
 @CONTRACTGROUP VARCHAR(20) = ''                
-- @PRINTF         VARCHAR(6) = 'ALL'              
 )              

AS
              
/*              
 EXEC V2_COMBINED_CONTRACTNOTE_NEW 'broker','broker','Jan 1 2014','Jan 1 2014','grgn3516','grgn3516',              
 '','zzzzzzzzzzz','','zzzzzzzzzzz','','99999999',              
 '','',0,'','','Angel Broking Pvt Ltd.(Erstwhile Angel Broking Ltd.)','NONECN'               
 EXEC [V2_COMBINED_CONTRACTNOTE_NEW] 'BROKER','BROKER','JUL 10 2012','JUL 10 2012','','zzzzzz','','ZZZZZZZZ','','ZZZZZZ','','99999999','','',0,''              
 EXEC V2_COMBINED_CONTRACTNOTE 'BROKER','BROKER','Aug  8 2012','Aug  8 2012','','zzzzzz','','ZZZZZZZZ','','ZZZZZZ','','99999999','CONTRACT','',0,''              
*/              
              
IF @TODATE = ''              
BEGIN              
 SET @TODATE = @FROMDATE              
END              
              
IF @TOPARTY = ''              
BEGIN              
 SET @TOPARTY = 'zzzzzzzzzz'              
END              
              
IF @TOBRANCH = ''              
BEGIN              
 SET @TOBRANCH = 'zzzzzzzzzz'              
END              
              
IF @TOSUB_BROKER = ''              
BEGIN              
 SET @TOSUB_BROKER = 'zzzzzzzzzz'              
END              
              
IF @TOCONTRACT = ''              
BEGIN              
 SET @TOCONTRACT = '9999999999'              
END           
          
          
--IF (SELECT COUNT(1) FROM COMMON_CONTRACT_DATA (NOLOCK) WHERE SAUDA_DATE BETWEEN @FROMDATE AND @FROMDATE + ' 23:59:59' AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY) > 0            
--BEGIN            
--print 'vin'        
 EXEC V2_COMBINED_CONTRACTNOTE_DETAIL_OptTest @STATUSID,@STATUSNAME,@FROMDATE,@TODATE,@FROMPARTY,@TOPARTY,@FROMBRANCH,@TOBRANCH,@FROMSUB_BROKER,@TOSUB_BROKER,@FROMCONTRACT,@TOCONTRACT,@CONTFLAG,@EXCHANGE,@BOUNCEDFLAG,@PRINTFLAG,@COMPANY_NAME,@CONTRACTGROUP
-- RETURN            
--END           
 /*         
              
DECLARE @COLNAME VARCHAR(6)              
              
SELECT @COLNAME = ''              
              
IF @CONTFLAG = 'CONTRACT'              
BEGIN              
 SELECT @COLNAME = RPT_CODE              
 FROM V2_CONTRACTPRINT_SETTING_COMBINED              
 WHERE RPT_TYPE = 'ORDER'              
  AND RPT_PRINTFLAG = 1              
END              
ELSE              
BEGIN              
 SELECT @COLNAME = RPT_CODE              
 FROM V2_CONTRACTPRINT_SETTING_COMBINED              
 WHERE RPT_TYPE = 'ORDER'              
  AND RPT_PRINTFLAG_DIGI = 1              
END              
              
CREATE TABLE #CONTRACT (              
 ORDERBYFLAG VARCHAR(100),              
 CONTRACTNO VARCHAR(10),              
 SAUDA_DATE VARCHAR(11),              
 SETT_NO  VARCHAR(10),              
 SETT_TYPE VARCHAR(3),              
 SETT_DATE VARCHAR(11),              
 PARTY_CODE VARCHAR(15),              
 PARTYNAME VARCHAR(100),              
 L_ADDRESS1 VARCHAR(100),              
 L_ADDRESS2 VARCHAR(100),              
 L_ADDRESS3 VARCHAR(100),              
 L_STATE  VARCHAR(50),              
 L_CITY  VARCHAR(50),              
 L_ZIP  VARCHAR(10),              
 OFF_PHONE1 VARCHAR(50),              
 OFF_PHONE2 VARCHAR(50),              
 PAN_GIR_NO VARCHAR(15),              
 EXCHANGE VARCHAR(3),              
 SEGMENT  VARCHAR(10),              
 ORDER_NO VARCHAR(20),              
 ORDER_TIME VARCHAR(8),              
 TRADE_NO VARCHAR(16),       
 TRADE_TIME VARCHAR(8),              
 SCRIPNAME VARCHAR(100),              
 QTY   BIGINT,              
 TMARK     VARCHAR(1),              
 SELL_BUY VARCHAR(1),              
 MARKETRATE MONEY,              
 MARKETAMT NUMERIC(20, 4),              
 BROKERAGE MONEY,          
 SERVICE_TAX MONEY,              
 INS_CHRG MONEY,              
 NETAMOUNT NUMERIC(20, 4),              
 SEBI_TAX MONEY,              
 TURN_TAX MONEY,              
 BROKER_CHRG MONEY,              
 OTHER_CHRG MONEY,              
 NETAMOUNTALL NUMERIC(20, 4),              
 PRINTF  INT,              
 BROK  NUMERIC(20, 4),              
 NETRATE  NUMERIC(20, 4),              
 CL_RATE  NUMERIC(20, 4),              
 UCC_CODE VARCHAR(15),              
 BROKERSEBIREGNO VARCHAR(20),              
 MEMBERCODE VARCHAR(50),              
 CINNO  VARCHAR(100),              
 BRANCH_CD VARCHAR(20),              
 SUB_BROKER VARCHAR(20),              
 SETTTYPE_DESC VARCHAR(35),              
 BFCF_FLAG VARCHAR(6),              
 CONTRACT_HEADER_DET VARCHAR(200),              
 REMARK  VARCHAR(100),              
 COMPANYNAME VARCHAR(100),              
 REMARK_ID VARCHAR(1),              
 REMARK_DESC VARCHAR(200)              
 )              
               
               
CREATE TABLE #PARTY (PARTYCODE VARCHAR(10))              
              
DECLARE @COMPANYNAME VARCHAR(150)              
DECLARE @EXCHANGE_NEW VARCHAR(3)              
DECLARE @SEGMENT_NEW VARCHAR(10)              
DECLARE @SHAREDB VARCHAR(35)              
DECLARE @SHARESERVER VARCHAR(35)              
DECLARE @ACCOUNTDB VARCHAR(35)              
DECLARE @ACCOUNTSERVER VARCHAR(35)              
              
              
              
DECLARE @EXCHANGEWISE_CURSOR CURSOR DECLARE @STRSQL VARCHAR(8000) SELECT EXCHANGE,              
 SEGMENT INTO #CLIENT_BROK_DETAILS FROM MSAJAG.DBO.CLIENT_BROK_DETAILS(NOLOCK) GROUP BY EXCHANGE,              
 SEGMENT SET @EXCHANGEWISE_CURSOR = CURSOR              
FOR              
SELECT DISTINCT COMPANYNAME,              
 EXCHANGE = M.EXCHANGE,              
 SEGMENT = M.SEGMENT,              
 SHAREDB,              
 SHARESERVER,              
 ACCOUNTDB,              
 ACCOUNTSERVER              
           
FROM PRADNYA..MULTICOMPANY M(NOLOCK),              
 #CLIENT_BROK_DETAILS CB(NOLOCK)              
WHERE CATEGORY IN (              
  'EQUITY',              
  'DERIVATIVES',              
  'CURRENCY'              
  ) --M.EXCHANGE NOT IN ('UCX','USM','USX','FDX', 'NCX', 'MCX', 'ACE')                                
 AND M.SEGMENT NOT IN ('SLBS')              
 AND SEGMENT_DESCRIPTION NOT LIKE '%PCM%'              
 AND CB.EXCHANGE = M.EXCHANGE              
 AND CB.SEGMENT = M.SEGMENT              
 AND PRIMARYSERVER = 1              
 --AND CB.EXCHANGE = (CASE WHEN @EXCHANGE = '' THEN CB.EXCHANGE ELSE @EXCHANGE END)                                
 --AND CB.SEGMENT = (CASE WHEN @SEGMENT = '' THEN CB.SEGMENT ELSE @SEGMENT END)                                
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
               
OPEN @EXCHANGEWISE_CURSOR              
              
FETCH NEXT              
FROM @EXCHANGEWISE_CURSOR              
INTO @COMPANYNAME,              
 @EXCHANGE_NEW,              
 @SEGMENT_NEW,              
 @SHAREDB,              
 @SHARESERVER,              
 @ACCOUNTDB,             
 @ACCOUNTSERVER              
               
              
              
              
              
WHILE @@FETCH_STATUS = 0              
BEGIN              
              
              
 /*                                
 IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME=@SHAREDB) > 0                                
 BEGIN                                
 */              
 SET @STRSQL = ''              
 IF @SEGMENT_NEW = 'CAPITAL'              
 BEGIN              
               
  SET @STRSQL = 'IF (SELECT COUNT(1) FROM ' + @SHARESERVER + '.' + @SHAREDB + '.SYS.TABLES WHERE NAME=''CONTRACT_DATA'') > 0 '              
                
  SET @STRSQL = @STRSQL + ' BEGIN '              
              
  IF @BOUNCEDFLAG = 0              
  BEGIN              
   SET @STRSQL = @STRSQL + 'TRUNCATE TABLE #PARTY '              
   SET @STRSQL = @STRSQL + ' INSERT INTO #PARTY '              
   SET @STRSQL = @STRSQL + ' SELECT DISTINCT PARTY_CODE FROM '              
   SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.CONTRACT_MASTER WITH (NOLOCK) WHERE CONVERT(DATETIME,START_DATE,103) BETWEEN ''' + @FROMDATE + ''' AND ''' + @TODATE + ' 23:59:59'' AND PARTY_CODE BETWEEN ''' + @FROMPARTY + ''' AND '
  
    
'      
        
' + @TOPARTY + ''''              
  END              
  ELSE              
  BEGIN              
   SET @STRSQL = @STRSQL + 'TRUNCATE TABLE #PARTY '              
   SET @STRSQL = @STRSQL + ' INSERT INTO #PARTY '              
   SET @STRSQL = @STRSQL + ' SELECT DISTINCT PARTY_CODE FROM '              
   SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.TBL_ECNBOUNCED WITH (NOLOCK) WHERE SAUDA_DATE BETWEEN ''' + @FROMDATE + ''' AND ''' + @TODATE + ' 23:59:59'''              
  END              
              
  SET @STRSQL = @STRSQL + ' END '              
              
  PRINT @STRSQL              
              
  EXEC (@STRSQL)              
              
  SET @STRSQL = 'IF (SELECT COUNT(1) FROM ' + @SHARESERVER + '.' + @SHAREDB + '.SYS.TABLES WHERE NAME=''CONTRACT_DATA'') > 0 '              
  SET @STRSQL = @STRSQL + 'BEGIN '              
  SET @STRSQL = @STRSQL + 'INSERT INTO #CONTRACT '              
  SET @STRSQL = @STRSQL + 'SELECT '              
  SET @STRSQL = @STRSQL + ' ORDERBYFLAG = (CASE '              
  SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_N'' THEN PARTYNAME '              
  SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_P'' THEN M.PARTY_CODE '              
  SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_BP'' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(M.PARTY_CODE)) '              
  SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_BN'' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(PARTYNAME))'              
  SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_DP'' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(M.PARTY_CODE))'              
  SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_DN'' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(PARTYNAME))'              
  SET @STRSQL = @STRSQL + '  ELSE RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(M.PARTY_CODE))'              
  SET @STRSQL = @STRSQL + ' END),'              
  SET @STRSQL = @STRSQL + ' CONTRACTNO,'              
  SET @STRSQL = @STRSQL + ' SAUDA_DATE = CONVERT(VARCHAR,CONVERT(DATETIME,SAUDA_DATE,109),103),'              
              
  IF @SHAREDB = 'BSEDB'              
  BEGIN              
   SET @STRSQL = @STRSQL + ' SETT_NO = ' + @SHAREDB + '.DBO.CONVERTSETTNO(D.SETT_NO,1),'              
  END              
  ELSE              
  BEGIN              
   SET @STRSQL = @STRSQL + ' SETT_NO = D.SETT_NO,'              
  END              
              
  SET @STRSQL = @STRSQL + ' SETT_TYPE = D.SETT_TYPE,'              
  SET @STRSQL = @STRSQL + ' SETT_DATE = FUNDS_PAYIN,'              
  SET @STRSQL = @STRSQL + ' PARTY_CODE= D.PARTY_CODE,'              
  SET @STRSQL = @STRSQL + ' PARTYNAME,'              
  SET @STRSQL = @STRSQL + ' L_ADDRESS1,'              
  SET @STRSQL = @STRSQL + ' L_ADDRESS2,'              
  SET @STRSQL = @STRSQL + ' L_ADDRESS3,'              
  SET @STRSQL = @STRSQL + ' L_STATE,'              
  SET @STRSQL = @STRSQL + ' L_CITY,'              
  SET @STRSQL = @STRSQL + ' L_ZIP,'              
  SET @STRSQL = @STRSQL + ' OFF_PHONE1,'              
  SET @STRSQL = @STRSQL + ' OFF_PHONE2,'              
  SET @STRSQL = @STRSQL + ' PAN_GIR_NO,'              
  SET @STRSQL = @STRSQL + ' EXCHANGE = ''' + @EXCHANGE_NEW + ''','              
  SET @STRSQL = @STRSQL + ' SEGMENT = ''' + @SEGMENT_NEW + ''','              
  SET @STRSQL = @STRSQL + ' ORDER_NO,'              
  SET @STRSQL = @STRSQL + ' ORDER_TIME,'           
  SET @STRSQL = @STRSQL + ' TRADE_NO,'              
  SET @STRSQL = @STRSQL + ' TRADE_TIME=TM,'              
  SET @STRSQL = @STRSQL + ' SCRIPNAME,'              
  SET @STRSQL = @STRSQL + ' QTY=PQTY+SQTY,'              
  SET @STRSQL = @STRSQL + ' TMARK,'              
  SET @STRSQL = @STRSQL + ' SELL_BUY=(CASE WHEN SELL_BUY = 1 THEN ''B'' ELSE ''S'' END),'              
  SET @STRSQL = @STRSQL + ' MARKETRATE = PRATE+SRATE,'              
  SET @STRSQL = @STRSQL + ' MARKETAMT = ((PRATE + SRATE)*(PQTY+SQTY)),'              
  SET @STRSQL = @STRSQL + ' BROKERAGE,'              
  --SET @STRSQL = @STRSQL + ' CASE WHEN SELL_BUY =1 THEN PBROK ELSE SBROK END BROKERAGE,'                                 
  SET @STRSQL = @STRSQL + ' SERVICE_TAX=NSERTAX,'              
  SET @STRSQL = @STRSQL + ' INS_CHRG,'              
  SET @STRSQL = @STRSQL + ' NETAMOUNT = ('              
  SET @STRSQL = @STRSQL + ' CASE'              
  SET @STRSQL = @STRSQL + '  WHEN SELL_BUY = 1'              
  SET @STRSQL = @STRSQL + '  THEN -(PAMT)'              
  SET @STRSQL = @STRSQL + '  ELSE (SAMT)'              
  SET @STRSQL = @STRSQL + ' END),'              
  SET @STRSQL = @STRSQL + ' SEBI_TAX,'              
  SET @STRSQL = @STRSQL + ' TURN_TAX,'              
  SET @STRSQL = @STRSQL + ' BROKER_CHRG,'              
  SET @STRSQL = @STRSQL + ' OTHER_CHRG,'              
  SET @STRSQL = @STRSQL + ' NETAMOUNTALL = ('        SET @STRSQL = @STRSQL + ' CASE'              
  SET @STRSQL = @STRSQL + '  WHEN SELL_BUY = 1'              
  SET @STRSQL = @STRSQL + '  THEN -(PAMT+NSERTAX+INS_CHRG+SEBI_TAX+TURN_TAX+BROKER_CHRG+OTHER_CHRG)'              
  SET @STRSQL = @STRSQL + '  ELSE (SAMT-NSERTAX-INS_CHRG-SEBI_TAX-TURN_TAX-BROKER_CHRG-OTHER_CHRG)'              
  SET @STRSQL = @STRSQL + ' END),'              
  SET @STRSQL = @STRSQL + ' M.PRINTF, '              
  SET @STRSQL = @STRSQL + ' BROK = (PBROK+SBROK),'              
  SET @STRSQL = @STRSQL + ' NETRATE = (PNETRATE+SNETRATE),'              
  SET @STRSQL = @STRSQL + ' CL_RATE = 0, '              
  SET @STRSQL = @STRSQL + ' UCC_CODE = '''', '              
  SET @STRSQL = @STRSQL + ' BROKERSEBIREGNO = O.BROKERSEBIREGNO,MEMBERCODE=O.MEMBERCODE,CINNO=O.CIN,BRANCH_CD,SUB_BROKER, '              
  SET @STRSQL = @STRSQL + ' SETTTYPE_DESC = (CASE '              
  SET @STRSQL = @STRSQL + '  WHEN D.SETT_TYPE = ''D''  THEN ''Rolling'''              
  SET @STRSQL = @STRSQL + '  WHEN D.SETT_TYPE = ''C''  THEN ''Odd Lot'''              
  SET @STRSQL = @STRSQL + '  WHEN D.SETT_TYPE = ''F''  THEN ''Debenture'''              
  SET @STRSQL = @STRSQL + '  WHEN D.SETT_TYPE = ''AC'' THEN ''Auction Odd Lot'''              
  SET @STRSQL = @STRSQL + '  WHEN D.SETT_TYPE = ''AF'' THEN ''Auction Defenture'''              
  SET @STRSQL = @STRSQL + '  WHEN D.SETT_TYPE = ''N''  THEN ''Normal'''              
  SET @STRSQL = @STRSQL + '  WHEN D.SETT_TYPE = ''A''  THEN ''Auction'''              
  SET @STRSQL = @STRSQL + '  WHEN D.SETT_TYPE = ''X''  THEN ''Auction Trade For Trade'''              
  SET @STRSQL = @STRSQL + '  WHEN D.SETT_TYPE = ''W''  THEN ''Trade For Trade'''              
  SET @STRSQL = @STRSQL + '  WHEN D.SETT_TYPE = ''MN'' THEN ''Normal'''              
  SET @STRSQL = @STRSQL + '  WHEN D.SETT_TYPE = ''AN'' THEN ''Auction Normal'''              
  SET @STRSQL = @STRSQL + '  WHEN D.SETT_TYPE = ''AD'' THEN ''Auction Rolling'''              
  SET @STRSQL = @STRSQL + '  WHEN D.SETT_TYPE = ''MW'' THEN ''Trade For Trade'''              
  SET @STRSQL = @STRSQL + '  WHEN D.SETT_TYPE = ''MX'' THEN ''Auction Trade For Trade'''              
  SET @STRSQL = @STRSQL + '  WHEN D.SETT_TYPE = ''OS'' THEN ''Offer For Sale'''              
  SET @STRSQL = @STRSQL + '  WHEN D.SETT_TYPE = ''TS'' THEN ''Offer For Sale'''              
  SET @STRSQL = @STRSQL + '  ELSE '''' END), BFCF_FLAG = '''', '              
  SET @STRSQL = @STRSQL + ' CONTRACT_HEADER_DET = '''', '              
  SET @STRSQL = @STRSQL + ' REMARK = '''', '              
  SET @STRSQL = @STRSQL + ' COMPANYNAME = O.COMPANY, '              
  SET @STRSQL = @STRSQL + ' REMARK_ID = '''', '              
  SET @STRSQL = @STRSQL + ' REMARK_DESC = '''' '              
  SET @STRSQL = @STRSQL + 'FROM '              
  SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.CONTRACT_DATA D WITH (NOLOCK),'              
  SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.CONTRACT_MASTER M WITH (NOLOCK),'              
  SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.OWNER O WITH (NOLOCK),'              
  SET @STRSQL = @STRSQL + ' ' + 'MSAJAG.DBO.FUN_PRINTF(''' + @PRINTF + ''') T '               
  --SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.PRINTF_SETTINGS T(NOLOCK)'                                   
  SET @STRSQL = @STRSQL + 'WHERE'              
  SET @STRSQL = @STRSQL + ' M.SETT_TYPE = D.SETT_TYPE'              
  --SET @STRSQL = @STRSQL + ' AND T.PRINTF_FLAG = ''' + @PRINTFLAG + ''''                  
  SET @STRSQL = @STRSQL + ' AND T.PRINTF = D.PRINTF '                  
  SET @STRSQL = @STRSQL + ' AND M.SETT_NO = D.SETT_NO'              
  SET @STRSQL = @STRSQL + ' AND M.PARTY_CODE = D.PARTY_CODE'              
  SET @STRSQL = @STRSQL + ' AND M.PARTY_CODE BETWEEN ''' + @FROMPARTY + ''' AND ''' + @TOPARTY + ''''              
  SET @STRSQL = @STRSQL + ' AND CONVERT(DATETIME,D.SAUDA_DATE,109) BETWEEN ''' + @FROMDATE + ''' AND ''' + @TODATE + ' 23:59:59'''              
  SET @STRSQL = @STRSQL + ' AND CONTRACTNO BETWEEN ''' + @FROMCONTRACT + ''' AND ''' + @TOCONTRACT + ''''              
  SET @STRSQL = @STRSQL + ' AND BRANCH_CD BETWEEN ''' + @FROMBRANCH + ''' AND ''' + @TOBRANCH + ''''              
  SET @STRSQL = @STRSQL + ' AND SUB_BROKER BETWEEN ''' + @FROMSUB_BROKER + ''' AND ''' + @TOSUB_BROKER + ''''              
  SET @STRSQL = @STRSQL + ' AND ''' + @STATUSNAME + ''' = ('              
  SET @STRSQL = @STRSQL + ' CASE'              
  SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''BRANCH'' THEN M.BRANCH_CD'              
  SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''SUBBROKER'' THEN M.SUB_BROKER'              
  SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''TRADER'' THEN M.TRADER'              
  SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''FAMILY'' THEN M.FAMILY'              
  SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''AREA'' THEN M.AREA'              
  SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''REGION'' THEN M.REGION'              
  SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''CLIENT'' THEN M.PARTY_CODE'              
  SET @STRSQL = @STRSQL + '  ELSE ''BROKER'''              
  SET @STRSQL = @STRSQL + ' END)'              
  SET @STRSQL = @STRSQL + ' AND EXISTS ( SELECT DISTINCT PARTYCODE FROM #PARTY P (NOLOCK) WHERE P.PARTYCODE = D.PARTY_CODE )'              
  --SET @STRSQL = @STRSQL + ' AND EXISTS ( SELECT DISTINCT PRINT_FLAG FROM CLIENT_PRINT_SETTINGS CP (NOLOCK) '                                
  --SET @STRSQL = @STRSQL + '     WHERE M.PRINTF = CP.PRINT_FLAG '                                
  --SET @STRSQL = @STRSQL + '     AND CP.VALID_REPORT LIKE (CASE WHEN '+ CONVERT(VARCHAR,@BOUNCEDFLAG) +' = 0 THEN ''%'''+ @CONTFLAG +'''%'' ELSE CP.VALID_REPORT END) '                                
  --SET @STRSQL = @STRSQL + '    )'                                
  SET @STRSQL = @STRSQL + 'ORDER BY'              
  SET @STRSQL = @STRSQL + ' ORDERBYFLAG,'              
  SET @STRSQL = @STRSQL + ' BRANCH_CD,'              
  SET @STRSQL = @STRSQL + ' SUB_BROKER,'              
  SET @STRSQL = @STRSQL + ' TRADER,'              
  SET @STRSQL = @STRSQL + ' D.PARTY_CODE,'              
  SET @STRSQL = @STRSQL + ' CONTRACTNO DESC,'              
  SET @STRSQL = @STRSQL + ' PARTYNAME,'              
  SET @STRSQL = @STRSQL + ' SCRIPNAME,'              
  SET @STRSQL = @STRSQL + ' ORDER_NO,'              
  SET @STRSQL = @STRSQL + ' TRADE_NO'              
  SET @STRSQL = @STRSQL + ' END'              
              
  PRINT @STRSQL              
  EXEC (@STRSQL)              
              
  --select * from #CONTRACT                               
  --return                            
  PRINT 'hi'              
 END              
 ELSE              
  IF @SEGMENT_NEW = 'FUTURES'              
  BEGIN              
   SET @STRSQL = 'IF (SELECT COUNT(1) FROM ' + @SHARESERVER + '.' + @SHAREDB + '.SYS.TABLES WHERE NAME=''CONTRACT_DATA'') > 0 '            
   SET @STRSQL = @STRSQL + 'BEGIN '              
              
   IF @BOUNCEDFLAG = 0              
   BEGIN              
    SET @STRSQL = @STRSQL + ' TRUNCATE TABLE #PARTY '              
    SET @STRSQL = @STRSQL + ' INSERT INTO #PARTY '              
    --SET @STRSQL = @STRSQL + ' SELECT DISTINCT PARTY_CODE FROM '                                 
    --SET @STRSQL = @STRSQL + ' '+ @SHARESERVER + '.' + @SHAREDB + '.DBO.CONTRACT_MASTER WITH (NOLOCK) WHERE TRADE_DATE BETWEEN '''+ @FROMDATE +''' AND '''+ @TODATE + ' 23:59:59'''                                
    --SET @STRSQL = @STRSQL + ' SELECT DISTINCT CL_CODE FROM '              
    --SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.CLIENT1 WITH (NOLOCK) WHERE CL_CODE BETWEEN  ''' + @FROMPARTY + ''' AND ''' + @TOPARTY + ''' '              
    IF @SHAREDB = 'BSEFO'              
    BEGIN              
     SET @STRSQL = @STRSQL + ' SELECT DISTINCT PARTY_CODE FROM '              
        SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.BFOBILLVALAN WITH (NOLOCK) WHERE PARTY_CODE BETWEEN  ''' + @FROMPARTY + ''' AND ''' + @TOPARTY + ''' '              
    END              
    ELSE              
    BEGIN              
     SET @STRSQL = @STRSQL + ' SELECT DISTINCT PARTY_CODE FROM '              
     SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.FOBILLVALAN WITH (NOLOCK) WHERE PARTY_CODE BETWEEN  ''' + @FROMPARTY + ''' AND ''' + @TOPARTY + ''' '              
    END              
                  
       --PRINT @STRSQL              
   END              
   ELSE              
   BEGIN              
    SET @STRSQL = @STRSQL + ' TRUNCATE TABLE #PARTY '              
    SET @STRSQL = @STRSQL + ' INSERT INTO #PARTY '              
    SET @STRSQL = @STRSQL + ' SELECT DISTINCT PARTY_CODE FROM '              
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.TBL_ECNBOUNCED WITH (NOLOCK) WHERE SAUDA_DATE BETWEEN ''' + @FROMDATE + ''' AND ''' + @TODATE + ' 23:59:59'''              
   END              
              
   SET @STRSQL = @STRSQL + ' END '              
              
   PRINT @STRSQL              
              
   EXEC (@STRSQL)              
                 
   /* FOR BF TRADE */              
   SET @STRSQL = ''              
   SET @STRSQL = @STRSQL + 'INSERT INTO #CONTRACT '              
   SET @STRSQL = @STRSQL + 'SELECT '              
   SET @STRSQL = @STRSQL + ' ORDERBYFLAG = (CASE '              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_N'' THEN PARTY_NAME '              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_P'' THEN M.CL_CODE '              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_BP'' THEN RTRIM(LTRIM(BRANCH_CODE)) + RTRIM(LTRIM(M.CL_CODE)) '              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_BN'' THEN RTRIM(LTRIM(BRANCH_CODE)) + RTRIM(LTRIM(PARTY_NAME))'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_DP'' THEN RTRIM(LTRIM(BRANCH_CODE)) + RTRIM(LTRIM(M.SUB_BROKER)) + RTRIM(LTRIM(D.TRADER)) + RTRIM(LTRIM(M.CL_CODE))'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_DN'' THEN RTRIM(LTRIM(BRANCH_CODE)) + RTRIM(LTRIM(M.SUB_BROKER)) + RTRIM(LTRIM(D.TRADER)) + RTRIM(LTRIM(PARTY_NAME))'              
   SET @STRSQL = @STRSQL + '  ELSE RTRIM(LTRIM(BRANCH_CODE)) + RTRIM(LTRIM(M.SUB_BROKER)) + RTRIM(LTRIM(D.TRADER)) + RTRIM(LTRIM(M.CL_CODE))'              
   SET @STRSQL = @STRSQL + ' END),'              
   SET @STRSQL = @STRSQL + ' CONTRACTNO,'              
   SET @STRSQL = @STRSQL + ' SAUDA_DATE = CONVERT(VARCHAR,SAUDA_DATE,103),'              
   SET @STRSQL = @STRSQL + ' SETT_NO = '''','              
   SET @STRSQL = @STRSQL + ' SETT_TYPE = '''','              
   SET @STRSQL = @STRSQL + ' SETT_DATE = '''','              
   SET @STRSQL = @STRSQL + ' PARTY_CODE= D.PARTY_CODE,'              
   SET @STRSQL = @STRSQL + ' PARTYNAME = D.PARTY_NAME,'              
   SET @STRSQL = @STRSQL + ' L_ADDRESS1,'              
   SET @STRSQL = @STRSQL + ' L_ADDRESS2,'              
   SET @STRSQL = @STRSQL + ' L_ADDRESS3,'              
   SET @STRSQL = @STRSQL + ' L_STATE,'              
   SET @STRSQL = @STRSQL + ' L_CITY,'              
   SET @STRSQL = @STRSQL + ' L_ZIP,'              
   SET @STRSQL = @STRSQL + ' OFF_PHONE1,'              
   SET @STRSQL = @STRSQL + ' OFF_PHONE2,'              
   SET @STRSQL = @STRSQL + ' PAN_GIR_NO,'              
   SET @STRSQL = @STRSQL + ' EXCHANGE = ''' + @EXCHANGE_NEW + ''','              
   SET @STRSQL = @STRSQL + ' SEGMENT  = ''' + @SEGMENT_NEW + ''','              
   SET @STRSQL = @STRSQL + ' ORDER_NO = '''','              
   SET @STRSQL = @STRSQL + ' ORDER_TIME = '''','              
   SET @STRSQL = @STRSQL + ' TRADE_NO = '''','              
   SET @STRSQL = @STRSQL + ' TRADE_TIME='''','              
              
   IF @SHAREDB = 'BSEFO'              
   BEGIN              
    SET @STRSQL = @STRSQL + ' SCRIPNAME = RTRIM(PRODUCT_CODE) + '' '' + RTRIM(SERIES_CODE) + '' '' + CONVERT(VARCHAR,SERIES_ID,108),'              
   END              
   ELSE              
   BEGIN              
    SET @STRSQL = @STRSQL + ' SCRIPNAME = ('              
    SET @STRSQL = @STRSQL + ' CASE '              
    SET @STRSQL = @STRSQL + '  WHEN INST_TYPE LIKE ''FUT%'' THEN RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' '' + LEFT(EXPIRYDATE,11) '              
    SET @STRSQL = @STRSQL + '  ELSE RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' '' + LEFT(EXPIRYDATE,11) + '' '' + RTRIM(CAST(CAST(STRIKE_PRICE AS NUMERIC(18,0)) AS VARCHAR)) + '' '' + RTRIM(OPTION_TYPE) '              
    SET @STRSQL = @STRSQL + ' END),'              
   END              
              
   SET @STRSQL = @STRSQL + ' QTY=ABS(SUM(PQTY-SQTY)),'              
   SET @STRSQL = @STRSQL + ' TMARK= '''','              
   SET @STRSQL = @STRSQL + ' SELL_BUY=(CASE WHEN SUM(PQTY-SQTY) > 0 THEN ''B'' ELSE ''S'' END),'              
   SET @STRSQL = @STRSQL + ' MARKETRATE = (CASE WHEN SUM(PQTY-SQTY) <> 0 THEN (SUM(PRATE*PQTY)-SUM(SRATE*SQTY))/SUM(PQTY-SQTY) ELSE 0 END),'              
   SET @STRSQL = @STRSQL + ' MARKETAMT = (SUM(PRATE*PQTY)-SUM(SRATE*SQTY)),'              
   SET @STRSQL = @STRSQL + ' BROKERAGE = SUM(PBROKAMT-SBROKAMT),'              
   SET @STRSQL = @STRSQL + ' SERVICE_TAX = SUM(SERVICE_TAX),'              
   SET @STRSQL = @STRSQL + ' INS_CHRG = SUM(INS_CHRG),'            
                 
   SET @STRSQL = @STRSQL + ' NETAMOUNT = (CASE WHEN SUM(PQTY-SQTY) > 0 THEN SUM((PBILLAMT+PBROKAMT)-(SBILLAMT+SBROKAMT)) ELSE SUM((PBILLAMT+PBROKAMT)-(SBILLAMT+SBROKAMT)) END),'              
    --SET @STRSQL = @STRSQL + ' NETAMOUNT = 0,'              
   SET @STRSQL = @STRSQL + ' SEBI_TAX = SUM(SEBI_TAX),'              
   SET @STRSQL = @STRSQL + ' TURN_TAX = SUM(TURN_TAX),'              
   SET @STRSQL = @STRSQL + ' BROKER_CHRG = SUM(BROKER_NOTE),'              
   SET @STRSQL = @STRSQL + ' OTHER_CHRG = SUM(D.OTHER_CHRG),'              
   SET @STRSQL = @STRSQL + ' NETAMOUNTALL= 0,'              
   SET @STRSQL = @STRSQL + ' C2.PRINTF, '              
   SET @STRSQL = @STRSQL + ' BROK  = (CASE WHEN SUM(PQTY-SQTY) <> 0 THEN SUM(PBROKAMT-SBROKAMT)/SUM(PQTY-SQTY) ELSE 0 END),'              
   SET @STRSQL = @STRSQL + ' NETRATE = 0,'              
   SET @STRSQL = @STRSQL + ' CL_RATE = (CASE WHEN SUM(PQTY-SQTY) <> 0 THEN  ABS(SUM((PQTY-SQTY)*CL_RATE) / SUM(PQTY-SQTY)) ELSE 0 END), '              
   SET @STRSQL = @STRSQL + ' UCC_CODE = '''', '              
   SET @STRSQL = @STRSQL + ' BROKERSEBIREGNO = O.BROKERSEBIREGNO,MEMBERCODE=O.MEMBERCODE,CINNO=O.CIN,BRANCH_CD,M.SUB_BROKER,SETTTYPE_DESC='''', BFCF_FLAG = ''BF_'' '              
              
   IF @SHAREDB = 'BSEFO'              
   BEGIN              
    SET @STRSQL = @STRSQL + '+RIGHT(LEFT(PRODUCT_CODE,1),3), '              
   END              
   ELSE              
   BEGIN              
    SET @STRSQL = @STRSQL + '+LEFT(INST_TYPE,1), '              
   END              
              
   SET @STRSQL = @STRSQL + ' CONTRACT_HEADER_DET = '''', '              
   SET @STRSQL = @STRSQL + ' REMARK = '''', '              
   SET @STRSQL = @STRSQL + ' COMPANYNAME = O.COMPANY, '              
   SET @STRSQL = @STRSQL + ' REMARK_ID = '''', '              
   SET @STRSQL = @STRSQL + ' REMARK_DESC = '''' '              
   SET @STRSQL = @STRSQL + 'FROM '              
              
   --SET @STRSQL = @STRSQL + ' MSAJAG.DBO.PRINTF_SETTINGS T(NOLOCK),'                                   
   IF @SHAREDB = 'BSEFO'              
   BEGIN              
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.BFOBILLVALAN D WITH (NOLOCK),'              
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.CLIENT1 M WITH (NOLOCK),'              
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.BFOOWNER O WITH (NOLOCK),'              
    SET @STRSQL = @STRSQL + ' ' + 'MSAJAG.DBO.FUN_PRINTF(''' + @PRINTF + ''') P , '               
    --SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.FUN_PRINTF(@PRINTF) P  ,'               
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.CLIENT2 C2 WITH (NOLOCK)'              
   END              
   ELSE              
   BEGIN              
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.FOBILLVALAN D WITH (NOLOCK),'      SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.CLIENT1 M WITH (NOLOCK),'              
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.FOOWNER O WITH (NOLOCK),'              
    SET @STRSQL = @STRSQL + ' ' + 'MSAJAG.DBO.FUN_PRINTF(''' + @PRINTF + ''') P , '                
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.CLIENT2 C2 WITH (NOLOCK)'              
   END              
              
   --SELECT TOP 5 * FROM CLIENT1                            
   SET @STRSQL = @STRSQL + 'WHERE'              
   SET @STRSQL = @STRSQL + ' 1 = 1'              
   --SET @STRSQL = @STRSQL + ' M.SETT_TYPE = D.SETT_TYPE'                                
   --SET @STRSQL = @STRSQL + ' AND M.SETT_NO = D.SETT_NO'                      
   SET @STRSQL = @STRSQL + ' AND M.CL_CODE = C2.PARTY_CODE'              
   SET @STRSQL = @STRSQL + ' AND C2.PRINTF = P.PRINTF '               
   SET @STRSQL = @STRSQL + ' AND M.CL_CODE = D.PARTY_CODE'              
              
   IF @SHAREDB = 'NSEFO'              
   BEGIN              
    SET @STRSQL = @STRSQL + ' and INST_TYPE like ''fut%'' '              
    --SET @STRSQL = @STRSQL + ' AND TRADETYPE = ''BF'' '              
    --SET @STRSQL = @STRSQL + ' AND (PQTY-SQTY) <> 0 '              
                 
   END              
              
   IF (              
     @SHAREDB = 'NSECURFO'              
     OR @SHAREDB = 'MCDXCDS'              
     )              
   BEGIN              
    SET @STRSQL = @STRSQL + ' and INST_TYPE like ''fut%'' '              
   END              
              
   -- SET @STRSQL = @STRSQL + ' AND LEFT(M.TRADE_DATE,11) = LEFT(D.SAUDA_DATE,11) '                                
   SET @STRSQL = @STRSQL + ' AND M.CL_CODE BETWEEN ''' + @FROMPARTY + ''' AND ''' + @TOPARTY + ''''              
   SET @STRSQL = @STRSQL + ' AND D.SAUDA_DATE BETWEEN ''' + @FROMDATE + ''' AND ''' + @TODATE + ' 23:59:59'''              
   SET @STRSQL = @STRSQL + ' AND CONTRACTNO BETWEEN ''' + @FROMCONTRACT + ''' AND ''' + @TOCONTRACT + ''''              
   SET @STRSQL = @STRSQL + ' AND M.BRANCH_CD BETWEEN ''' + @FROMBRANCH + ''' AND ''' + @TOBRANCH + ''''              
   SET @STRSQL = @STRSQL + ' AND M.SUB_BROKER BETWEEN ''' + @FROMSUB_BROKER + ''' AND ''' + @TOSUB_BROKER + ''''              
   SET @STRSQL = @STRSQL + ' AND ''' + @STATUSNAME + ''' = ('              
   SET @STRSQL = @STRSQL + ' CASE'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''BRANCH'' THEN M.BRANCH_CD'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''SUBBROKER'' THEN M.SUB_BROKER'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''TRADER'' THEN M.TRADER'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''FAMILY'' THEN M.FAMILY'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''AREA'' THEN M.AREA'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''REGION'' THEN M.REGION'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''CLIENT'' THEN M.CL_CODE'              
   SET @STRSQL = @STRSQL + '  ELSE ''BROKER'''              
   SET @STRSQL = @STRSQL + ' END)'              
   --SET @STRSQL = @STRSQL + ' AND EXISTS ( SELECT DISTINCT PARTYCODE FROM #PARTY P (NOLOCK) WHERE P.PARTYCODE = D.PARTY_CODE )'                                
   --SET @STRSQL = @STRSQL + ' AND EXISTS ( SELECT DISTINCT PRINT_FLAG FROM CLIENT_PRINT_SETTINGS CP (NOLOCK) '                                
   --SET @STRSQL = @STRSQL + '     WHERE M.PRINTF = CP.PRINT_FLAG '                                
   --SET @STRSQL = @STRSQL + '     AND CP.VALID_REPORT LIKE (CASE WHEN '+ CONVERT(VARCHAR,@BOUNCEDFLAG) +' = 0 THEN ''%'''+ @CONTFLAG +'''%'' ELSE CP.VALID_REPORT END) '                                
   --SET @STRSQL = @STRSQL + '    )'                                
   SET @STRSQL = @STRSQL + ' AND TRADETYPE = ''BF'' '              
   SET @STRSQL = @STRSQL + ' AND (PQTY-SQTY) <> 0 '              
   --SET @STRSQL = @STRSQL + ' AND T.PRINTF_FLAG = ''' + @PRINTFLAG + ''''                  
   --SET @STRSQL = @STRSQL + ' AND T.PRINTF = C2.PRINTF '                  
   SET @STRSQL = @STRSQL + 'GROUP BY '              
   SET @STRSQL = @STRSQL + ' (CASE '              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_N'' THEN PARTY_NAME '              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_P'' THEN M.CL_CODE '              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_BP'' THEN RTRIM(LTRIM(BRANCH_CODE)) + RTRIM(LTRIM(M.CL_CODE)) '              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_BN'' THEN RTRIM(LTRIM(BRANCH_CODE)) + RTRIM(LTRIM(PARTY_NAME))'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_DP'' THEN RTRIM(LTRIM(BRANCH_CODE)) + RTRIM(LTRIM(M.SUB_BROKER)) + RTRIM(LTRIM(D.TRADER)) + RTRIM(LTRIM(M.CL_CODE))'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_DN'' THEN RTRIM(LTRIM(BRANCH_CODE)) + RTRIM(LTRIM(M.SUB_BROKER)) + RTRIM(LTRIM(D.TRADER)) + RTRIM(LTRIM(PARTY_NAME))'              
   SET @STRSQL = @STRSQL + '  ELSE RTRIM(LTRIM(BRANCH_CODE)) + RTRIM(LTRIM(M.SUB_BROKER)) + RTRIM(LTRIM(D.TRADER)) + RTRIM(LTRIM(M.CL_CODE))'              
   SET @STRSQL = @STRSQL + ' END),'              
   SET @STRSQL = @STRSQL + ' CONTRACTNO,'              
   SET @STRSQL = @STRSQL + ' CONVERT(VARCHAR,SAUDA_DATE,103),'              
   SET @STRSQL = @STRSQL + ' D.PARTY_CODE,'              
   SET @STRSQL = @STRSQL + ' D.PARTY_NAME,'              
   SET @STRSQL = @STRSQL + ' L_ADDRESS1,'              
   SET @STRSQL = @STRSQL + ' L_ADDRESS2,'              
   SET @STRSQL = @STRSQL + ' L_ADDRESS3,'              
   SET @STRSQL = @STRSQL + ' L_STATE,'              
   SET @STRSQL = @STRSQL + ' L_CITY,'              
   SET @STRSQL = @STRSQL + ' L_ZIP,'              
   SET @STRSQL = @STRSQL + ' OFF_PHONE1,'              
   SET @STRSQL = @STRSQL + ' OFF_PHONE2,'              
   SET @STRSQL = @STRSQL + ' PAN_GIR_NO,C2.PRINTF,'              
              
   IF @SHAREDB = 'BSEFO'              
   BEGIN              
    SET @STRSQL = @STRSQL + ' RTRIM(PRODUCT_CODE) + '' '' + RTRIM(SERIES_CODE) + '' '' + CONVERT(VARCHAR,SERIES_ID,108),RIGHT(LEFT(PRODUCT_CODE,1),3),'              
   END              
   ELSE              
   BEGIN              
    SET @STRSQL = @STRSQL + ' CASE '              
    SET @STRSQL = @STRSQL + '  WHEN INST_TYPE LIKE ''FUT%'' THEN RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' '' + LEFT(EXPIRYDATE,11) '              
    SET @STRSQL = @STRSQL + '  ELSE RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' '' + LEFT(EXPIRYDATE,11) + '' '' + RTRIM(CAST(CAST(STRIKE_PRICE AS NUMERIC(18,0)) AS VARCHAR)) + '' '' + RTRIM(OPTION_TYPE) '              
    SET @STRSQL = @STRSQL + ' END,LEFT(INST_TYPE,1),'              
   END              
              
   --SET @STRSQL = @STRSQL + ' M.UCC_CODE, '                                
   SET @STRSQL = @STRSQL + ' O.BROKERSEBIREGNO,O.MEMBERCODE,O.CIN,BRANCH_CD,M.SUB_BROKER,O.COMPANY '              
   SET @STRSQL = @STRSQL + 'ORDER BY'              
   SET @STRSQL = @STRSQL + ' ORDERBYFLAG,'              
   SET @STRSQL = @STRSQL + ' BRANCH_CD,'              
   SET @STRSQL = @STRSQL + ' M.SUB_BROKER,'              
   SET @STRSQL = @STRSQL + ' D.PARTY_CODE,'              
   SET @STRSQL = @STRSQL + ' CONTRACTNO DESC,'              
   SET @STRSQL = @STRSQL + ' PARTYNAME,'              
   SET @STRSQL = @STRSQL + ' ORDER_NO,'              
   SET @STRSQL = @STRSQL + ' TRADE_NO'              
              
   PRINT @STRSQL              
   EXEC (@STRSQL)              
              
                 
              
   /* FOR BT TRADE */              
   SET @STRSQL = 'IF (SELECT COUNT(1) FROM ' + @SHARESERVER + '.' + @SHAREDB + '.SYS.TABLES WHERE NAME=''CONTRACT_DATA'') > 0 '              
   SET @STRSQL = @STRSQL + 'BEGIN '              
   SET @STRSQL = @STRSQL + 'INSERT INTO #CONTRACT '              
   SET @STRSQL = @STRSQL + 'SELECT '              
   SET @STRSQL = @STRSQL + ' ORDERBYFLAG = (CASE '              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_N'' THEN PARTYNAME '              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_P'' THEN M.PARTY_CODE '              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_BP'' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(M.PARTY_CODE)) '              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_BN'' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(PARTYNAME))'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_DP'' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUBBROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(M.PARTY_CODE))'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @COLNAME + ''' = ''ORD_DN'' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUBBROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(PARTYNAME))'              
   SET @STRSQL = @STRSQL + '  ELSE RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUBBROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(M.PARTY_CODE))'              
   SET @STRSQL = @STRSQL + ' END),'              
   SET @STRSQL = @STRSQL + ' CONTRACTNO,'              
   SET @STRSQL = @STRSQL + ' SAUDA_DATE = CONVERT(VARCHAR,CONVERT(DATETIME,SAUDA_DATE,109),103),'              
   SET @STRSQL = @STRSQL + ' SETT_NO = '''','              
   SET @STRSQL = @STRSQL + ' SETT_TYPE = '''','              
   SET @STRSQL = @STRSQL + ' SETT_DATE = '''','              
   SET @STRSQL = @STRSQL + ' PARTY_CODE= D.PARTY_CODE,'              
   SET @STRSQL = @STRSQL + ' PARTYNAME,'              
   SET @STRSQL = @STRSQL + ' L_ADDRESS1,'              
   SET @STRSQL = @STRSQL + ' L_ADDRESS2,'              
   SET @STRSQL = @STRSQL + ' L_ADDRESS3,'              
   SET @STRSQL = @STRSQL + ' L_STATE,'              
   SET @STRSQL = @STRSQL + ' L_CITY,'              
   SET @STRSQL = @STRSQL + ' L_ZIP,'              
   SET @STRSQL = @STRSQL + ' OFF_PHONE1,'              
   SET @STRSQL = @STRSQL + ' OFF_PHONE2,'              
   SET @STRSQL = @STRSQL + ' PAN_GIR_NO,'              
   SET @STRSQL = @STRSQL + ' EXCHANGE = ''' + @EXCHANGE_NEW + ''','              
   SET @STRSQL = @STRSQL + ' SEGMENT = ''' + @SEGMENT_NEW + ''','              
   SET @STRSQL = @STRSQL + ' ORDER_NO,'              
   SET @STRSQL = @STRSQL + ' ORDER_TIME,'              
   SET @STRSQL = @STRSQL + ' TRADE_NO,'              
   SET @STRSQL = @STRSQL + ' TRADE_TIME=TRADETIME,'              
              
   IF @SHAREDB = 'BSEFO'              
   BEGIN              
    SET @STRSQL = @STRSQL + ' SCRIPNAME = RTRIM(PRODUCT_CODE) + '' '' + RTRIM(SERIES_CODE) + '' '' + CONVERT(VARCHAR,SERIES_ID,108),'              
   END              
   ELSE              
    IF @SHAREDB = 'NSECURFO'              
    BEGIN              
     SET @STRSQL = @STRSQL + ' SCRIPNAME = ('              
     SET @STRSQL = @STRSQL + ' CASE '              
     SET @STRSQL = @STRSQL + '  WHEN INST_TYPE LIKE ''FUT%'' THEN RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' '' + LEFT(EXPIRYDATE,11) '              
     SET @STRSQL = @STRSQL + '  ELSE RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' '' + LEFT(EXPIRYDATE,11) + '' '' + RTRIM(CAST(CAST(STRIKE_PRICE AS NUMERIC(18,2)) AS VARCHAR)) + '' '' + RTRIM(AUCTIONPART) '              
     SET @STRSQL = @STRSQL + ' END),'              
    END              
    ELSE              
    BEGIN              
     SET @STRSQL = @STRSQL + ' SCRIPNAME = ('              
     SET @STRSQL = @STRSQL + ' CASE '              
     SET @STRSQL = @STRSQL + '  WHEN INST_TYPE LIKE ''FUT%'' THEN RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' '' + LEFT(EXPIRYDATE,11) '              
     SET @STRSQL = @STRSQL + '  ELSE RTRIM(INST_TYPE) + '' '' + RTRIM(SYMBOL) + '' '' + LEFT(EXPIRYDATE,11) + '' '' + RTRIM(CAST(CAST(STRIKE_PRICE AS NUMERIC(18,0)) AS VARCHAR)) + '' '' + RTRIM(OPTION_TYPE) '              
     SET @STRSQL = @STRSQL + ' END),'              
    END              
              
   SET @STRSQL = @STRSQL + ' QTY=PQTY+SQTY,'              
   SET @STRSQL = @STRSQL + ' TMARK= '''','              
   SET @STRSQL = @STRSQL + ' SELL_BUY=(CASE WHEN SELL_BUY = 1 THEN ''B'' ELSE ''S'' END),'              
   SET @STRSQL = @STRSQL + ' MARKETRATE = PRATE+SRATE,'              
   SET @STRSQL = @STRSQL + ' MARKETAMT = 0,'              
   -- SET @STRSQL = @STRSQL + ' MARKETAMT = ((PRATE + SRATE)*(PQTY+SQTY)),'                                    
   SET @STRSQL = @STRSQL + ' BROKERAGE,'              
   --  SET @STRSQL = @STRSQL + ' CASE WHEN SELL_BUY =1 THEN PBROK ELSE SBROK END BROKERAGE,'                                
   SET @STRSQL = @STRSQL + ' SERVICE_TAX,'              
   SET @STRSQL = @STRSQL + ' INS_CHRG,'              
              
   IF @SHAREDB = 'BSEFO'              
   BEGIN              
    SET @STRSQL = @STRSQL + ' NETAMOUNT = ('              
    SET @STRSQL = @STRSQL + ' CASE'              
    SET @STRSQL = @STRSQL + '  WHEN SELL_BUY = 1'              
    --    SET @STRSQL = @STRSQL + '  THEN -(PAMT+(pbrok*pqty))'                                
    --    SET @STRSQL = @STRSQL + '  ELSE (SAMT-(sbrok*sqty))'                                
    SET @STRSQL = @STRSQL + '  THEN -(PAMT)'              
    SET @STRSQL = @STRSQL + '  ELSE (SAMT)'              
    SET @STRSQL = @STRSQL + ' end)  ,'              
   END              
   ELSE              
   BEGIN             
    SET @STRSQL = @STRSQL + ' NETAMOUNT = case when left(inst_type,3) = ''FUT'' then ('              
    SET @STRSQL = @STRSQL + ' CASE'              
    SET @STRSQL = @STRSQL + '  WHEN SELL_BUY = 1'              
    --    SET @STRSQL = @STRSQL + '  THEN -(PAMT+(pbrok*pqty))'                                
    --    SET @STRSQL = @STRSQL + '  ELSE (SAMT-(sbrok*sqty))'                                
    SET @STRSQL = @STRSQL + '  THEN -(PAMT)'              
    SET @STRSQL = @STRSQL + '  ELSE (SAMT)'              
    SET @STRSQL = @STRSQL + ' END) else '              
    SET @STRSQL = @STRSQL + ' (CASE'              
    SET @STRSQL = @STRSQL + '  WHEN SELL_BUY = 1'              
    SET @STRSQL = @STRSQL + '  THEN -(PAMT+(pbrok*pqty))'                                
    SET @STRSQL = @STRSQL + '  ELSE (SAMT-(sbrok*sqty))'                                
    --SET @STRSQL = @STRSQL + '  THEN -(PAMT)'              
    --SET @STRSQL = @STRSQL + '  ELSE (SAMT)'              
    SET @STRSQL = @STRSQL + ' END) end ,'              
   END              
              
   SET @STRSQL = @STRSQL + ' SEBI_TAX,'              
   SET @STRSQL = @STRSQL + ' TURN_TAX,'              
   SET @STRSQL = @STRSQL + ' BROKER_CHRG,'              
   SET @STRSQL = @STRSQL + ' D.OTHER_CHRG,'              
   SET @STRSQL = @STRSQL + ' NETAMOUNTALL = ('              
   SET @STRSQL = @STRSQL + ' CASE'              
   SET @STRSQL = @STRSQL + '  WHEN SELL_BUY = 1'              
   SET @STRSQL = @STRSQL + '  THEN -(PAMT+NSERTAX+INS_CHRG+SEBI_TAX+TURN_TAX+BROKER_CHRG+D.OTHER_CHRG)'              
   SET @STRSQL = @STRSQL + '  ELSE (SAMT-NSERTAX-INS_CHRG-SEBI_TAX-TURN_TAX-BROKER_CHRG-D.OTHER_CHRG)'              
   SET @STRSQL = @STRSQL + ' END),'              
   SET @STRSQL = @STRSQL + ' M.PRINTF, '              
   SET @STRSQL = @STRSQL + ' BROK = (PBROK+SBROK),'              
   --  SET @STRSQL = @STRSQL + ' NETRATE = (PNETRATE+SNETRATE),'                                
   SET @STRSQL = @STRSQL + ' NETRATE = PRATE+PBROK+SRATE-SBROK ,'              
   SET @STRSQL = @STRSQL + ' CL_RATE = 0, '              
   SET @STRSQL = @STRSQL + ' UCC_CODE = '''', '              
   SET @STRSQL = @STRSQL + ' BROKERSEBIREGNO = O.BROKERSEBIREGNO,MEMBERCODE=O.MEMBERCODE,CINNO=O.CIN,BRANCH_CD,SUBBROKER,SETTTYPE_DESC='''', BFCF_FLAG = ''BT_'''              
              
   IF @SHAREDB = 'BSEFO'              
   BEGIN              
    SET @STRSQL = @STRSQL + '+RIGHT(LEFT(PRODUCT_CODE,1),3), '              
   END              
   ELSE              
   BEGIN              
    SET @STRSQL = @STRSQL + '+LEFT(INST_TYPE,1), '              
   END              
              
   SET @STRSQL = @STRSQL + ' CONTRACT_HEADER_DET = '''', '              
   SET @STRSQL = @STRSQL + ' REMARK = '''', '              
   SET @STRSQL = @STRSQL + ' COMPANYNAME = O.COMPANY, '              
   SET @STRSQL = @STRSQL + ' REMARK_ID = '''', '              
   SET @STRSQL = @STRSQL + ' REMARK_DESC = '''' '              
   SET @STRSQL = @STRSQL + 'FROM '              
   --SET @STRSQL = @STRSQL + 'MSAJAG.DBO.PRINTF_SETTINGS T(NOLOCK),'                                   
   SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.CONTRACT_DATA D WITH (NOLOCK),'              
   SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.CONTRACT_MASTER M WITH (NOLOCK),'              
              
   IF @SHAREDB = 'BSEFO'              
   BEGIN              
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.BFOOWNER O WITH (NOLOCK)'              
   END              
   ELSE              
   BEGIN              
    SET @STRSQL = @STRSQL + ' ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.FOOWNER O WITH (NOLOCK)'              
   END              
              
   SET @STRSQL = @STRSQL + 'WHERE'              
   SET @STRSQL = @STRSQL + ' 1 = 1'              
   --SET @STRSQL = @STRSQL + ' M.SETT_TYPE = D.SETT_TYPE'                                
   --SET @STRSQL = @STRSQL + ' AND M.SETT_NO = D.SETT_NO'                          
   --SET @STRSQL = @STRSQL + ' AND T.PRINTF_FLAG = ''' + @PRINTFLAG + ''''                  
   --SET @STRSQL = @STRSQL + ' AND T.PRINTF = M.PRINTF '                          
   SET @STRSQL = @STRSQL + ' AND M.PARTY_CODE = D.PARTY_CODE'              
   SET @STRSQL = @STRSQL + ' AND LEFT(M.TRADE_DATE,11) = LEFT(D.SAUDA_DATE,11) '              
   SET @STRSQL = @STRSQL + ' AND M.PARTY_CODE BETWEEN ''' + @FROMPARTY + ''' AND ''' + @TOPARTY + ''''              
   SET @STRSQL = @STRSQL + ' AND D.SAUDA_DATE BETWEEN ''' + @FROMDATE + ''' AND ''' + @TODATE + ' 23:59:59'''              
   SET @STRSQL = @STRSQL + ' AND CONTRACTNO BETWEEN ''' + @FROMCONTRACT + ''' AND ''' + @TOCONTRACT + ''''              
   SET @STRSQL = @STRSQL + ' AND BRANCH_CD BETWEEN ''' + @FROMBRANCH + ''' AND ''' + @TOBRANCH + ''''              
   SET @STRSQL = @STRSQL + ' AND SUBBROKER BETWEEN ''' + @FROMSUB_BROKER + ''' AND ''' + @TOSUB_BROKER + ''''              
   SET @STRSQL = @STRSQL + ' AND ''' + @STATUSNAME + ''' = ('              
   SET @STRSQL = @STRSQL + ' CASE'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''BRANCH'' THEN M.BRANCH_CD'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''SUBBROKER'' THEN M.SUBBROKER'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''TRADER'' THEN M.TRADER'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''FAMILY'' THEN M.FAMILY'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''AREA'' THEN M.AREA'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''REGION'' THEN M.REGION'              
   SET @STRSQL = @STRSQL + '  WHEN ''' + @STATUSID + ''' = ''CLIENT'' THEN M.PARTY_CODE'              
   SET @STRSQL = @STRSQL + '  ELSE ''BROKER'''              
   SET @STRSQL = @STRSQL + ' END)'              
   SET @STRSQL = @STRSQL + ' AND EXISTS ( SELECT DISTINCT PARTYCODE FROM #PARTY P (NOLOCK) WHERE P.PARTYCODE = D.PARTY_CODE )'              
   --SET @STRSQL = @STRSQL + ' AND EXISTS ( SELECT DISTINCT PRINT_FLAG FROM CLIENT_PRINT_SETTINGS CP (NOLOCK) '                       
   --SET @STRSQL = @STRSQL + '     WHERE M.PRINTF = CP.PRINT_FLAG '                                
   --SET @STRSQL = @STRSQL + '     AND CP.VALID_REPORT LIKE (CASE WHEN '+ CONVERT(VARCHAR,@BOUNCEDFLAG) +' = 0 THEN ''%'''+ @CONTFLAG +'''%'' ELSE CP.VALID_REPORT END) '                                
   --SET @STRSQL = @STRSQL + '    )'                                
   SET @STRSQL = @STRSQL + 'ORDER BY'              
   SET @STRSQL = @STRSQL + ' ORDERBYFLAG,'              
   SET @STRSQL = @STRSQL + ' BRANCH_CD,'              
   SET @STRSQL = @STRSQL + ' SUBBROKER,'              
   SET @STRSQL = @STRSQL + ' TRADER,'              
   SET @STRSQL = @STRSQL + ' D.PARTY_CODE,'              
   SET @STRSQL = @STRSQL + ' CONTRACTNO DESC,'              
   SET @STRSQL = @STRSQL + ' PARTYNAME,'              
   SET @STRSQL = @STRSQL + ' ORDER_NO,'              
   SET @STRSQL = @STRSQL + ' TRADE_NO'              
   SET @STRSQL = @STRSQL + ' END '              
              
   PRINT @STRSQL              
   EXEC (@STRSQL)              
              
                 
   IF @SHAREDB <> 'BSEFO'              
   BEGIN              
    SET @STRSQL = 'UPDATE #CONTRACT SET CL_RATE = ISNULL(F.CL_RATE,0) '              
    SET @STRSQL = @STRSQL + ' FROM ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.FOCLOSING F (NOLOCK) '              
    SET @STRSQL = @STRSQL + ' WHERE LEFT(CONVERT(DATETIME,SAUDA_DATE,103),11) = LEFT(F.TRADE_DATE,11)'              
    SET @STRSQL = @STRSQL + ' AND SCRIPNAME = (CASE WHEN F.INST_TYPE LIKE ''FUT%'' THEN RTRIM(F.INST_TYPE) + '' '' + RTRIM(F.SYMBOL) + '' '' + LEFT(F.EXPIRYDATE,11) ELSE RTRIM(F.INST_TYPE) + '' '' + RTRIM(F.SYMBOL) + '' '' + LEFT(F.EXPIRYDATE,11) + '''' 
   
   
      
        
          
            
+ RTRIM(CAST(CAST(F.STRIKE_PRICE AS NUMERIC(18,0)) AS VARCHAR)) + '' '' + RTRIM(F.OPTION_TYPE) END) '              
    SET @STRSQL = @STRSQL + ' AND LEFT(BFCF_FLAG,2) = ''BT'' '              
   END              
              
   IF @SHAREDB = 'BSEFO'              
   BEGIN              
    SET @STRSQL = 'UPDATE #CONTRACT SET CL_RATE = ISNULL(F.CLOSE_PRICE,0) '              
    SET @STRSQL = @STRSQL + ' FROM ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.BFOCLOSING F (NOLOCK) '              
    SET @STRSQL = @STRSQL + ' WHERE LEFT(CONVERT(DATETIME,SAUDA_DATE,103),11) = LEFT(F.TRADE_DATE,11)'              
    SET @STRSQL = @STRSQL + ' AND SCRIPNAME = (RTRIM(F.PRODUCT_CODE) + '' '' + RTRIM(F.SERIES_CODE) + '' '' + CONVERT(VARCHAR,F.SERIES_ID,108)) '              
    SET @STRSQL = @STRSQL + ' AND LEFT(BFCF_FLAG,2) = ''BT'''              
   END              
              
   PRINT @STRSQL           EXEC (@STRSQL)              
                 
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
  @ACCOUNTSERVER              
END              
              
CLOSE @EXCHANGEWISE_CURSOR              
              
DEALLOCATE @EXCHANGEWISE_CURSOR              
              
-- COMPUTING MTM FOR FUTURES BT                                
/*UPDATE #CONTRACT SET NETAMOUNT = (CASE WHEN SELL_BUY = 'B' THEN NETRATE - CL_RATE ELSE CL_RATE - NETRATE END ) * QTY                                
WHERE SEGMENT ='FUTURES'                                
AND RIGHT(BFCF_FLAG,1) = 'F'                                  
AND LEFT(BFCF_FLAG,2) = 'BT'*/              
--AND SCRIPNAME=T.INST_TYPE+' '+LTRIM(RTRIM(T.SYMBOL))+' '+CONVERT(VARCHAR(11),T.EXPIRYDATE,109)                    
--DELETE FROM #CONTRACT WHERE NOT EXISTS ( SELECT DISTINCT PRINT_FLAG FROM CLIENT_PRINT_SETTINGS CP (NOLOCK)                                
--WHERE #CONTRACT.PRINTF = CP.PRINT_FLAG                                 
--AND CP.VALID_REPORT LIKE (CASE WHEN @BOUNCEDFLAG = 0 THEN '%' + @CONTFLAG + '%' ELSE CP.VALID_REPORT END) )               
              
              
UPDATE #CONTRACT              
SET SCRIPNAME = SCRIPNAME + ' (' + LEFT(BFCF_FLAG, 2) + ')'              
WHERE SEGMENT = 'FUTURES'              
AND LEN(BFCF_FLAG) <> 0              
              
UPDATE #CONTRACT              
SET CONTRACTNO = A.CONTRACTNO              
FROM (              
 SELECT SAUDA_DATE = LEFT(SAUDA_DATE, 11),              
  PARTY_CODE,              
  SETT_TYPE,              
  CONTRACTNO              
 /*NETAMOUNT = SUM(CASE                     
    WHEN SELL_BUY = 1                    
     THEN PAMT + (NSERTAX + INS_CHRG + BROKER_CHRG + TURN_TAX + SEBI_TAX + OTHER_CHRG)                    
    ELSE SAMT - (NSERTAX + INS_CHRG + BROKER_CHRG + TURN_TAX + SEBI_TAX + OTHER_CHRG)                    
END),                    
  NETAMOUNT1 = SUM(PAMT - SAMT) + SUM(NSERTAX + INS_CHRG + BROKER_CHRG + TURN_TAX + SEBI_TAX + OTHER_CHRG)*/              
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
               
               
               
/*UPDATE #CONTRACT              
SET    CONTRACTNO = A.CONTRACTNO              
FROM (              
 SELECT SAUDA_DATE = LEFT(SAUDA_DATE, 11),              
  PARTY_CODE,              
  ---SETT_TYPE,              
  CONTRACTNO              
 /*NETAMOUNT = SUM(CASE                     
    WHEN SELL_BUY = 1                    
     THEN PAMT + (NSERTAX + INS_CHRG + BROKER_CHRG + TURN_TAX + SEBI_TAX + OTHER_CHRG)                    
    ELSE SAMT - (NSERTAX + INS_CHRG + BROKER_CHRG + TURN_TAX + SEBI_TAX + OTHER_CHRG)                    
END),                    
  NETAMOUNT1 = SUM(PAMT - SAMT) + SUM(NSERTAX + INS_CHRG + BROKER_CHRG + TURN_TAX + SEBI_TAX + OTHER_CHRG)*/              
 FROM #CONTRACT(NOLOCK)              
 WHERE CONTRACTNO <> 0              
 AND #CONTRACT.SEGMENT = 'FUTURES'              
 AND #CONTRACT.EXCHANGE = 'NSE'              
 GROUP BY LEFT(SAUDA_DATE, 11),              
  PARTY_CODE,              
  CONTRACTNO              
                
  --SETT_TYPE              
 ) A              
WHERE A.PARTY_CODE = #CONTRACT.PARTY_CODE              
 AND LEFT(A.SAUDA_DATE, 11) = LEFT(#CONTRACT.SAUDA_DATE, 11)              
 AND #CONTRACT.CONTRACTNO = 0              
 --AND A.SETT_TYPE = #CONTRACT.SETT_TYPE              
 --AND #CONTRACT.SCRIPNAME = 'BROKERAGE'              
 AND #CONTRACT.SEGMENT = 'FUTURES'              
 AND #CONTRACT.EXCHANGE = 'NSE'              
--AND A.CONTRACTNO = #CONTSETTNEW.CONTRACTNO                   
              
              
*/              
              
                             
UPDATE #CONTRACT              
SET CONTRACT_HEADER_DET = EXCHANGE + ' - ' + SEGMENT + ' - ' + (              
  CASE               
   WHEN SEGMENT = 'CAPITAL'              
    THEN SETTTYPE_DESC + ' (' + LTRIM(RTRIM(SETT_NO)) + ' - ' + LTRIM(RTRIM(SETT_TYPE)) + ' - ' + LTRIM(RTRIM(SETT_DATE)) + ' - ' + LTRIM(RTRIM(CONTRACTNO)) + ')'              
   ELSE LTRIM(RTRIM(CONTRACTNO))              
   END              
  )              
              
UPDATE #CONTRACT              
SET CONTRACT_HEADER_DET = EXCHANGE + ' - ' + SEGMENT              
WHERE SEGMENT = 'FUTURES'              
 AND BFCF_FLAG = 'BF_F'              
 AND LEFT(BFCF_FLAG, 2) = 'BT'              
               
ALTER TABLE #CONTRACT ADD BILLNO     INT              
ALTER TABLE #CONTRACT ADD BILLNO_DET VARCHAR(200)              
              
               
               
--Updated bill no for NSE FO AND NSE currrency for BF trade              
              
--SELECT PARTY_CODE,CONTRACTNO,              
              
              
              
UPDATE #CONTRACT                  
SET  BILLNO = FA.BILL_NO                  
FROM NSEFO.DBO.FOACCBILL FA ,#CONTRACT C                 
WHERE FA.PARTY_CODE = C.PARTY_CODE                  
   AND FA.BILLDATE >= @FROMDATE                   
   AND FA.BILLDATE <= @TODATE +' 23:59:59'               
   AND C.SEGMENT = 'FUTURES'              
   AND C.EXCHANGE = 'NSE'              
   --AND C.BFCF_FLAG = 'BF_F'              
                 
UPDATE #CONTRACT                  
SET  BILLNO = FA.BILL_NO                  
FROM NSECURFO.DBO.FOACCBILL FA ,#CONTRACT C                 
WHERE FA.PARTY_CODE = C.PARTY_CODE                  
   AND FA.BILLDATE >= @FROMDATE                   
   AND FA.BILLDATE <= @TODATE +' 23:59:59'               
   AND C.SEGMENT = 'FUTURES'              
   AND C.EXCHANGE = 'NSX'              
   AND C.BFCF_FLAG = 'BF_F'              
                 
--Updated bill no                 
              
SELECT DISTINCT PARTY_CODE,              
 SAUDA_DATE,              
 SETTLEMENT_DET = STUFF((              
   SELECT DISTINCT EXCHANGE + '-' + SEGMENT + '-' + LTRIM(RTRIM(SETT_NO)) + '-' + LTRIM(RTRIM(SETTTYPE_DESC)) + '-' + Sett_Date + '-' + LTRIM(RTRIM(CONTRACTNO)) + '#'              
   FROM #CONTRACT C              
   WHERE B.PARTY_CODE = C.PARTY_CODE              
    AND B.SAUDA_DATE = C.SAUDA_DATE              
    AND C.SEGMENT = 'CAPITAL'              
    AND C.CONTRACTNO <> 0              
   ORDER BY 1              
   FOR XML PATH('')              
   ), 1, 0, ''),              
 CONTRACTNO_DET = STUFF((              
   SELECT DISTINCT EXCHANGE + '-' + SEGMENT + '-' + LTRIM(RTRIM(CONTRACTNO)) + '#'              
   FROM #CONTRACT C              
   WHERE B.PARTY_CODE = C.PARTY_CODE              
    AND B.SAUDA_DATE = C.SAUDA_DATE              
    AND C.CONTRACTNO <> 0              
   ORDER BY 1              
   FOR XML PATH('')              
   ), 1, 0, ''),              
 BILLNO_DET = STUFF((              
   SELECT DISTINCT EXCHANGE + ' ' + SEGMENT + ': ' + LTRIM(RTRIM(BILLNO)) + '#'              
   FROM #CONTRACT C              
   WHERE B.PARTY_CODE = C.PARTY_CODE              
    AND B.SAUDA_DATE = C.SAUDA_DATE              
    AND C.BILLNO <> 0              
   ORDER BY 1              
   FOR XML PATH('')              
   ), 1, 0, ''),              
 BROKERSEBIREGNO_DET = STUFF((              
   SELECT DISTINCT EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(BROKERSEBIREGNO)) + '#'              
   FROM #CONTRACT C              
   WHERE B.PARTY_CODE = C.PARTY_CODE              
    AND B.SAUDA_DATE = C.SAUDA_DATE              
   ORDER BY 1              
   FOR XML PATH('')              
   ), 1, 0, ''),              
 MEMBERCODE_DET = STUFF((              
   SELECT DISTINCT EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(MEMBERCODE)) + '#'              
   FROM #CONTRACT C              
   WHERE B.PARTY_CODE = C.PARTY_CODE              
    AND B.SAUDA_DATE = C.SAUDA_DATE              
   ORDER BY 1              
   FOR XML PATH('')              
   ), 1, 0, ''),              
 CIN_DET=STUFF((              
   SELECT DISTINCT EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(CINNO)) + '#'              
   FROM #CONTRACT C              
   WHERE B.PARTY_CODE = C.PARTY_CODE              
    AND B.SAUDA_DATE = C.SAUDA_DATE              
   ORDER BY 1              
   FOR XML PATH('')              
   ), 1, 0, '')               
               
INTO #CONTSETT_DET              
FROM #CONTRACT B              
              
              
--select * from #CONTSETT_DET              
--return      
              
                               
              
              
ALTER TABLE #CONTRACT ADD SETTLEMENT_DET  VARCHAR(600)              
ALTER TABLE #CONTRACT ADD CONTRACTNO_DET  VARCHAR(500)              
ALTER TABLE #CONTRACT ADD BROKERSEBIREGNO_DET VARCHAR(500)              
ALTER TABLE #CONTRACT ADD MEMBERCODE_DET  VARCHAR(500)              
ALTER TABLE #CONTRACT ADD CIN_DET          VARCHAR(200)              
ALTER TABLE #CONTRACT ADD NETAMOUNTEX   NUMERIC(20, 4)              
ALTER TABLE #CONTRACT ADD SEBI_TAXEX   MONEY              
ALTER TABLE #CONTRACT ADD TURN_TAXEX   MONEY              
ALTER TABLE #CONTRACT ADD BROKER_CHRGEX   MONEY              
ALTER TABLE #CONTRACT ADD OTHER_CHRGEX   MONEY              
ALTER TABLE #CONTRACT ADD INS_CHRGEX   MONEY              
ALTER TABLE #CONTRACT ADD SERVICE_TAXEX   MONEY              
ALTER TABLE #CONTRACT ADD SCRIPNAME_NEW   VARCHAR(100)           
ALTER TABLE #CONTRACT ADD REMARK_DET  VARCHAR(600)                 
              
              
--select SETTLEMENT_DET,CONTRACTNO_DET,BROKERSEBIREGNO_DET,MEMBERCODE_DET from #CONTRACT                          
              
--select * from #CONTSETT_DET              
--return              
              
UPDATE #CONTRACT              
SET SETTLEMENT_DET = C.SETTLEMENT_DET,              
 CONTRACTNO_DET = C.CONTRACTNO_DET,              
 BILLNO_DET    = C.BILLNO_DET,              
 BROKERSEBIREGNO_DET = C.BROKERSEBIREGNO_DET,              
 MEMBERCODE_DET = C.MEMBERCODE_DET,              
 CIN_DET= C.CIN_DET              
FROM #CONTSETT_DET C              
WHERE #CONTRACT.PARTY_CODE = C.PARTY_CODE              
 AND #CONTRACT.SAUDA_DATE = C.SAUDA_DATE              
               
--select * from #CONTRACT                          
--return              
              
SELECT PARTY_CODE,              
 SAUDA_DATE,              
 EXCHANGE,         
 SEGMENT,              
 SERVICE_TAX = SUM(SERVICE_TAX),              
 INS_CHRG = SUM(INS_CHRG),              
 NETAMOUNT = SUM(NETAMOUNT),              
 SEBI_TAX = SUM(SEBI_TAX),              
 TURN_TAX = SUM(TURN_TAX),              
 BROKER_CHRG = SUM(BROKER_CHRG),              
 OTHER_CHRG = SUM(OTHER_CHRG)              
INTO #CONTRACT1              
FROM #CONTRACT              
GROUP BY PARTY_CODE,              
 SAUDA_DATE,              
 EXCHANGE,              
 SEGMENT              
              
UPDATE #CONTRACT              
SET NETAMOUNTEX = C1.NETAMOUNT,              
SEBI_TAXEX = C1.SEBI_TAX,              
 TURN_TAXEX = C1.TURN_TAX,              
 BROKER_CHRGEX = C1.BROKER_CHRG,              
 OTHER_CHRGEX = C1.OTHER_CHRG,              
 INS_CHRGEX = C1.INS_CHRG,              
 SERVICE_TAXEX = C1.SERVICE_TAX              
FROM #CONTRACT C(NOLOCK),              
 #CONTRACT1 C1(NOLOCK)              
WHERE C.PARTY_CODE = C1.PARTY_CODE              
 AND C.SAUDA_DATE = C1.SAUDA_DATE              
 AND C.EXCHANGE = C1.EXCHANGE              
 AND C.SEGMENT = C1.SEGMENT              
              
SELECT A.PARTY_CODE,              
 MTM              
INTO #FOBILL              
FROM (              
 SELECT PARTY_CODE,              
  SUM(SBILLAMT - PBILLAMT) MTM,              
  LEFT(SAUDA_DATE, 11) LDT              
 FROM ANGELFO.NSEFO.DBO.FOBILLVALAN              
 WHERE LEFT(SAUDA_DATE, 11) BETWEEN @FROMDATE AND @TODATE  + ' 23:59:59'              
    AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY              
 GROUP BY PARTY_CODE,              
  LEFT(SAUDA_DATE, 11)              
 ) A              
INNER JOIN (              
 SELECT DISTINCT PARTY_CODE,              
  LEFT(CONVERT(DATETIME, CONVERT(VARCHAR(11), #CONTRACT.SAUDA_DATE, 109), 103), 11) SDT              
 FROM #CONTRACT              
 WHERE #CONTRACT.SEGMENT = 'FUTURES'              
  AND Exchange = 'nse'              
   AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY              
 ) B              
 ON LDT = SDT              
  AND A.Party_Code = B.PARTY_CODE              
              
UPDATE #CONTRACT              
SET NETAMOUNTEX = MTM              
-- ,NETAMOUNT = MTM                    
--NETAMOUNT = (CASE WHEN SELL_BUY = 'B' THEN PBILLAMT ELSE SBILLAMT END )                     
FROM #FOBILL T              
WHERE #CONTRACT.SEGMENT = 'FUTURES'              
 AND #CONTRACT.EXCHANGE = 'NSE'              
 --AND LEFT(BFCF_FLAG,2) = 'BF'                    
 -- AND LEFT(CONVERT(DATETIME,CONVERT(VARCHAR(11),#CONTRACT.SAUDA_DATE,109),103),11) =LEFT(T.SAUDA_DATE, 11)                    
 AND T.PARTY_CODE = #CONTRACT.PARTY_CODE              
              
--AND TRADETYPE='BF'                   
DROP TABLE #FOBILL              
              
-----------NSX              
SELECT A.PARTY_CODE,              
 MTM              
INTO #FOBILL1              
FROM (              
 SELECT PARTY_CODE,              
  SUM(SBILLAMT - PBILLAMT) MTM,              
  LEFT(SAUDA_DATE, 11) LDT              
 FROM ANGELFO.NSECURFO.DBO.FOBILLVALAN              
 WHERE LEFT(SAUDA_DATE, 11) BETWEEN @FROMDATE AND @TODATE  + ' 23:59:59'              
    AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY              
 GROUP BY PARTY_CODE,              
  LEFT(SAUDA_DATE, 11)              
 ) A              
INNER JOIN (              
 SELECT DISTINCT PARTY_CODE,              
  LEFT(CONVERT(DATETIME, CONVERT(VARCHAR(11), #CONTRACT.SAUDA_DATE, 109), 103), 11) SDT              
 FROM #CONTRACT              
 WHERE #CONTRACT.SEGMENT = 'FUTURES'              
  AND Exchange = 'NSX'              
  AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY              
                
 ) B              
 ON LDT = SDT              
  AND A.Party_Code = B.PARTY_CODE              
              
UPDATE #CONTRACT              
SET NETAMOUNTEX = MTM              
-- ,NETAMOUNT = MTM                    
--NETAMOUNT = (CASE WHEN SELL_BUY = 'B' THEN PBILLAMT ELSE SBILLAMT END )                     
FROM #FOBILL1 T              
WHERE #CONTRACT.SEGMENT = 'FUTURES'              
 AND #CONTRACT.EXCHANGE = 'NSX'              
 --AND LEFT(BFCF_FLAG,2) = 'BF'                    
 -- AND LEFT(CONVERT(DATETIME,CONVERT(VARCHAR(11),#CONTRACT.SAUDA_DATE,109),103),11) =LEFT(T.SAUDA_DATE, 11)                    
 AND T.PARTY_CODE = #CONTRACT.PARTY_CODE              
              
--AND TRADETYPE='BF'                   
DROP TABLE #FOBILL1              
              
              
              
/*              
------------MCD-------              
SELECT A.PARTY_CODE,              
 MTM              
INTO #FOBILL2              
FROM (              
 SELECT PARTY_CODE,              
  SUM(SBILLAMT - PBILLAMT) MTM,              
  LEFT(SAUDA_DATE, 11) LDT              
 FROM MCDXCDS.DBO.FOBILLVALAN              
 GROUP BY PARTY_CODE,              
  LEFT(SAUDA_DATE, 11)              
 ) A              
INNER JOIN (              
 SELECT DISTINCT PARTY_CODE,              
  LEFT(CONVERT(DATETIME, CONVERT(VARCHAR(11), #CONTRACT.SAUDA_DATE, 109), 103), 11) SDT              
 FROM #CONTRACT              
 WHERE #CONTRACT.SEGMENT = 'FUTURES'              
  AND Exchange = 'MCD'              
 ) B              
 ON LDT = SDT              
  AND A.Party_Code = B.PARTY_CODE              
              
UPDATE #CONTRACT              
SET NETAMOUNTEX = MTM              
-- ,NETAMOUNT = MTM                    
--NETAMOUNT = (CASE WHEN SELL_BUY = 'B' THEN PBILLAMT ELSE SBILLAMT END )                     
FROM #FOBILL2 T              
WHERE #CONTRACT.SEGMENT = 'FUTURES'              
 AND #CONTRACT.EXCHANGE = 'MCD'              
 --AND LEFT(BFCF_FLAG,2) = 'BF'                    
 -- AND LEFT(CONVERT(DATETIME,CONVERT(VARCHAR(11),#CONTRACT.SAUDA_DATE,109),103),11) =LEFT(T.SAUDA_DATE, 11)                    
 AND T.PARTY_CODE = #CONTRACT.PARTY_CODE              
              
--AND TRADETYPE='BF'                   
DROP TABLE #FOBILL2              
*/              
              
              
UPDATE #CONTRACT              
SET CONTRACTNO = 0              
WHERE #CONTRACT.SCRIPNAME LIKE '%BROKERAGE%'              
              
UPDATE #CONTRACT              
SET  SCRIPNAME_NEW = (CASE WHEN REMARK_ID <> '' THEN '(' + REMARK_ID + ')' ELSE '' END) + LTRIM(RTRIM(SCRIPNAME))            
        
        
              
SELECT *              
FROM #CONTRACT              
ORDER BY PARTY_CODE,              
 EXCHANGE,              
 SEGMENT,              
 BFCF_FLAG,              
 CONTRACTNO DESC,              
 SETT_TYPE,              
 SCRIPNAME,              
 SELL_BUY,              
 ORDER_NO,              
 TRADE_NO              
               
              
DROP TABLE #PARTY              
DROP TABLE #CONTRACT           
DROP TABLE #CLIENT_BROK_DETAILS */

GO
