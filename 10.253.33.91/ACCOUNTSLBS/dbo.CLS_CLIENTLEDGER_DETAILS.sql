-- Object: PROCEDURE dbo.CLS_CLIENTLEDGER_DETAILS
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------







CREATE PROCEDURE [dbo].[CLS_CLIENTLEDGER_DETAILS]        
                @FDATE      VARCHAR(11),                 
                @TDATE      VARCHAR(11),             
                @FCODE      VARCHAR(10),        
                @TCODE      VARCHAR(10),        
                @STRORDER   VARCHAR(6),        
                @SELECTBY   VARCHAR(3),         
                @STATUSID   VARCHAR(15),        
                @STATUSNAME VARCHAR(15),        
                @STATUSNAME_TO VARCHAR(15),      
                @ORDERFLG   VARCHAR(1)  = 'N',        
                @EXCSEGMENT VARCHAR(1000) ,        
                @ENTITY_TYPE VARCHAR(20) = 'ENTITY',        
                @SINGLE     VARCHAR(1)  = 'N',        
                @FORPDF  VARCHAR(1) = 'N',      
                @CSV   VARCHAR(1) = 'N',        
				@VTYPE   VARCHAR(2) = '',
				@ENTITY VARCHAR(25) ='',
				@ENTITY_LIST VARCHAR(8000) = '',
				@SHOWMARGIN INT = 0,
				@SESSIONID VARCHAR(500),
				@PARENTCHILD_FLAG CHAR(1) = 'C',
				@DASHBOARD CHAR(1) = 'N',
				@CHARGES_LEDGER INT = 2
                        
        
AS  
      
/*        
SELECT * FROM CLS_COMPANY_MASTER_SETTING        
 EXEC [CLS_RPT_ACC_PARTYLEDGER_ALL] 'APR 1 2008','MAR 2 2009','0','0A143','ACCODE','VDT','BROKER','BROKER','','','','','ACCOUNT~ACCOUNTBSE~ACCOUNTFO'        
COMMIT        
EXEC RPT_ACC_PARTYLEDGER_ALL 'APR  1 2008','MAR  2 2009','0','0A143','ACCODE','VDT','BROKER','BROKER','',''        
    
DROP PROC CLS_RPT_ACC_PARTYLEDGER_ALL_TEST    
COMMIT        
*/        
       
	  /* select  cl_Code as CLTCODE from msajag..Client_Details
	   return;*/


	   
--SELECT * FROM LEDGER_RMONEY  ORDER BY ORDERSEG ASC

--update LEDGER_RMONEY
--set BOOKTYPE = 01
--WHERE ORDERSEG = 18 

DECLARE 
	@ECNFLAG VARCHAR(2),
	@MARGINREQ VARCHAR(1)

SELECT @ECNFLAG = ISNULL(PVALUE, '') FROM CLS_CLIENT_LEDGER_PARAMETERS WHERE SESSIONID = @SESSIONID AND PKEY = 'ddlEcn'
SELECT @MARGINREQ = ISNULL(PVALUE, '') FROM CLS_CLIENT_LEDGER_PARAMETERS WHERE SESSIONID = @SESSIONID AND PKEY = 'margreq'
--SELECT @MARGINREQ 


SET NOCOUNT ON        
        
  BEGIN        
 IF LEN(@FDATE) = 10 AND CHARINDEX('/', @FDATE) > 0        
  BEGIN        
   SET @FDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FDATE, 103), 109)        
  END        
 IF LEN(@TDATE) = 10 AND CHARINDEX('/', @TDATE) > 0        
  BEGIN        
   SET @TDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TDATE, 103), 109)        
  END 

  IF @CHARGES_LEDGER IS NULL
	SET @CHARGES_LEDGER=2
	   
 DECLARE @YEAR_START VARCHAR(11),    
  @YEAR_END VARCHAR(20)      
  SELECT @YEAR_START = CONVERT(VARCHAR(11), SDTCUR, 109), @YEAR_END = CONVERT(VARCHAR(11), LDTCUR, 109) + ' 23:59:59' FROM PARAMETER WHERE @FDATE BETWEEN SDTCUR AND LDTCUR    
    
	DECLARE @WHERECLAUS VARCHAR(30)
	  
  CREATE TABLE [DBO].[#TMPLEDGERNEW] (        
  [BOOKTYPE]   [CHAR](2)   NULL,        
  [VOUDT]      [DATETIME]   NULL,        
  [EFFDT]      [DATETIME]   NULL,        
  [SHORTDESC]  [CHAR](6)   NULL,        
  [DRAMT]      [MONEY]   NULL,        
  [CRAMT]      [MONEY]   NULL,        
  [VNO]        [VARCHAR](12)   NULL,        
  [DDNO]       [VARCHAR](20)   NULL,        
  [NARRATION]  [VARCHAR](500)   NULL,        
  [CLTCODE]    [VARCHAR](10)   NOT NULL,        
  [VTYP]       [SMALLINT]   NULL,        
  [VDT]        [VARCHAR](30)   NULL,        
  [EDT]        [VARCHAR](30)   NULL,        
  [ACNAME]     [VARCHAR](100)   NULL,        
  [OPBAL]      [MONEY]   NULL,        
  [L_ADDRESS1] [VARCHAR](100)   NULL,        
  [L_ADDRESS2] [VARCHAR](100)   NULL,        
  [L_ADDRESS3] [VARCHAR](100)   NULL,        
  [L_CITY]     [VARCHAR](50)   NULL,        
  [L_ZIP]      [VARCHAR](25)   NULL,        
  [RES_PHONE1] [VARCHAR](15)   NULL,        
  [BRANCH_CD]  [VARCHAR](10)   NULL,        
  [CROSAC]     [VARCHAR](10)   NULL,        
  [EDIFF]      [INT]   NULL,        
  [FAMILY]     [VARCHAR](10)   NULL,        
  [SUB_BROKER] [VARCHAR](10)   NULL,        
  [TRADER]     [VARCHAR](20)   NULL,        
  [CL_TYPE]    [VARCHAR](3)   NULL,        
  [BANK_NAME]  [VARCHAR](100)   NULL,        
  [CLTDPID]    [VARCHAR](16)   NULL,        
  [LNO]        [INT]    NULL,        
  [PDT]        [DATETIME]   NULL,
  [EMAIL] VARCHAR(500),
  [MOBILE_PAGER] VARCHAR(50),    
  [PAN] VARCHAR(50),    
  [EXCHANGE] [VARCHAR] (15) NULL,        
  [SEGMENT]    [VARCHAR](10)   NULL,        
  [ENTITY]     [VARCHAR](50)   NULL,        
  [ORDERSEG]   [BIGINT]   NULL,        
  [ACTIVE_SEG] [VARCHAR] (8000),        
  [PARTYROWCOUNT] [INT] NULL,        
  [TOTALPAGES] [INT] NULL
    
      )        
    ON [PRIMARY]        
       
 CREATE TABLE [DBO].[#DBNAME]            
 (            
  ACCOUNTDB VARCHAR(20),             
  EXCHANGE VARCHAR(6),             
  SEGMENT VARCHAR(10),            
  ACCOUNTSERVER VARCHAR(20),          
  SHAREDB VARCHAR(20),        
  GROUPID VARCHAR(20),        
  ORDER_SEGMENT INT          
 ) ON [PRIMARY]          
DECLARE  @@DB VARCHAR(1000)        
        
IF @EXCSEGMENT = ''        
 SELECT @EXCSEGMENT = EXCHANGE + '~' + SEGMENT FROM OWNER        
   
IF @ENTITY_TYPE = 'ENTITY'         
 SELECT @@DB = " INSERT INTO #DBNAME SELECT ACCOUNTDB, EXCHANGE, SEGMENT, ACCOUNTSERVER, SHAREDB, GROUPID, ORDER_SEGMENT FROM CLS_COMPANY_MASTER_SETTING (NOLOCK) WHERE EXCHANGE + '~' + SEGMENT IN ('" + REPLACE(@EXCSEGMENT,',',''',''') + "') ORDER BY EXCHANGE "            
ELSE        
 SELECT @@DB = " INSERT INTO #DBNAME SELECT ACCOUNTDB, EXCHANGE, SEGMENT, ACCOUNTSERVER, SHAREDB, GROUPID, ORDER_SEGMENT FROM CLS_COMPANY_MASTER_SETTING (NOLOCK) WHERE GROUPID IN ('" + REPLACE(@EXCSEGMENT,',',''',''') + "') ORDER BY GROUPID "            
  
EXEC(@@DB)
	    
DECLARE @@MAINREC AS CURSOR,        
  @@ACCOUNTDB VARCHAR(20),          
  @@SHAREDB VARCHAR(20),             
  @@ACCOUNTSVR VARCHAR(20),            
  @@EXCHANGE VARCHAR(15),            
  @@SEGMENT VARCHAR(15),        
  @@GROUPID VARCHAR(20),        
  @@ORDERSEG VARCHAR(3),        
  @@ORDERSECOUNT INT        
SET @@ORDERSECOUNT = (SELECT COUNT(1) FROM CLS_COMPANY_MASTER_SETTING)     

--SELECT ACCOUNTDB, EXCHANGE, SEGMENT,ACCOUNTSERVER,SHAREDB,GROUPID,ORDER_SEGMENT FROM #DBNAME       
        
DECLARE @@SQL VARCHAR(8000)        
--SET @@SQL = ""        
SET @@MAINREC = CURSOR FOR            
     SELECT ACCOUNTDB, EXCHANGE, SEGMENT,ACCOUNTSERVER,SHAREDB,GROUPID,ORDER_SEGMENT FROM #DBNAME           
             
OPEN @@MAINREC            
 FETCH NEXT FROM @@MAINREC INTO @@ACCOUNTDB, @@EXCHANGE, @@SEGMENT, @@ACCOUNTSVR, @@SHAREDB,@@GROUPID,@@ORDERSEG            
  WHILE @@FETCH_STATUS = 0            
  BEGIN           

 IF (@@ACCOUNTDB <> 'BBO_FA'  AND (@CHARGES_LEDGER  = 0 OR @CHARGES_LEDGER  = 2))
 BEGIN
 IF (@@ACCOUNTDB <> 'ACCOUNT'  AND (@CHARGES_LEDGER  = 0 OR @CHARGES_LEDGER  = 2))
 BEGIN
	SET @@SQL = " DELETE FROM "+@@ACCOUNTSVR+"."+@@ACCOUNTDB+".DBO.FORMULA_CLIENT_MASTER_PARENT  WHERE SESSION_ID = '" + @SESSIONID + "'"
	SET @@SQL = @@SQL + " INSERT INTO "+@@ACCOUNTSVR+"."+@@ACCOUNTDB+".DBO.FORMULA_CLIENT_MASTER_PARENT SELECT * FROM FORMULA_CLIENT_MASTER_PARENT WHERE SESSION_ID = '" + @SESSIONID + "'"
	EXEC (@@SQL)
 END

 SET @@SQL = " INSERT INTO #TMPLEDGERNEW "        
 SET @@SQL = @@SQL + " (BOOKTYPE, "        
 SET @@SQL = @@SQL +" VOUDT, "        
 SET @@SQL = @@SQL +" EFFDT, "        
 SET @@SQL = @@SQL +" SHORTDESC, "        
 SET @@SQL = @@SQL +" DRAMT, "        
 SET @@SQL = @@SQL +" CRAMT, "        
 SET @@SQL = @@SQL +" VNO, "        
 SET @@SQL = @@SQL +" DDNO, "        
 SET @@SQL = @@SQL +" NARRATION, "        
 SET @@SQL = @@SQL +" CLTCODE, "        
 SET @@SQL = @@SQL +" VTYP, "        
 SET @@SQL = @@SQL +" VDT, "        
 SET @@SQL = @@SQL +" EDT, "        
 SET @@SQL = @@SQL +" ACNAME, "        
 SET @@SQL = @@SQL +" OPBAL, "        
 SET @@SQL = @@SQL +" L_ADDRESS1, "        
 SET @@SQL = @@SQL +" L_ADDRESS2, "        
 SET @@SQL = @@SQL +" L_ADDRESS3, "        
 SET @@SQL = @@SQL +" L_CITY, "        
 SET @@SQL = @@SQL +" L_ZIP, "        
 SET @@SQL = @@SQL +" RES_PHONE1, "        
 SET @@SQL = @@SQL +" BRANCH_CD, "        
 SET @@SQL = @@SQL +" CROSAC, "        
 SET @@SQL = @@SQL +" EDIFF, "        
 SET @@SQL = @@SQL +" FAMILY, "        
 SET @@SQL = @@SQL +" SUB_BROKER, "        
 SET @@SQL = @@SQL +" TRADER, "        
 SET @@SQL = @@SQL +" CL_TYPE, "        
 SET @@SQL = @@SQL +" BANK_NAME, "        
 SET @@SQL = @@SQL +" CLTDPID, "        
 SET @@SQL = @@SQL +" LNO, "        
 SET @@SQL = @@SQL +" PDT, "        
 SET @@SQL = @@SQL +" EMAIL, "        
SET @@SQL = @@SQL +" MOBILE_PAGER, "        
 SET @@SQL = @@SQL +" PAN) "    
 IF @@SERVERNAME <> @@ACCOUNTSVR        
 SET @@SQL = @@SQL +" EXEC "+@@ACCOUNTSVR+"."+@@ACCOUNTDB+"..CLS_CLIENTLEDGER_SEG_DETAILS "        
 ELSE        
 SET @@SQL = @@SQL +" EXEC "+@@ACCOUNTDB+"..CLS_CLIENTLEDGER_SEG_DETAILS "        
 SET @@SQL = @@SQL +"'" +@FDATE +"', "        
 SET @@SQL = @@SQL +"'" +@TDATE +"', "        
 SET @@SQL = @@SQL +"'" +@FCODE +"', "        
 SET @@SQL = @@SQL +"'" +@TCODE +"', "        
 SET @@SQL = @@SQL +"'" +@STRORDER +"', "        
 SET @@SQL = @@SQL +"'" +@SELECTBY +"', "        
 SET @@SQL = @@SQL +"'" +@SESSIONID+"' "        
   
   print @@SQL     
EXEC (@@SQL)

  IF @ORDERFLG = 'N'        
    BEGIN        
    UPDATE #TMPLEDGERNEW         
    SET EXCHANGE = @@EXCHANGE,         
     SEGMENT = @@SEGMENT,        
      ENTITY = 'SETTLEMENT LEDGER',        
     ORDERSEG = 1         
    WHERE  SEGMENT IS NULL         
  END         
  ELSE         
   BEGIN        
   UPDATE #TMPLEDGERNEW         
      SET  EXCHANGE = @@EXCHANGE,        
       SEGMENT =@@SEGMENT,        
       ENTITY = CASE WHEN @ENTITY_TYPE = 'ENTITY' THEN @@SEGMENT  +"-"+  @@EXCHANGE ELSE @@GROUPID + ' - SETTLEMENT LEDGER' END,        
       ORDERSEG = @@ORDERSEG         
    WHERE  SEGMENT IS NULL         
 END         
        
SET @@SQL = "  INSERT INTO #TMPLEDGERNEW "        
SET @@SQL = @@SQL + " (BOOKTYPE, "        
SET @@SQL = @@SQL + "  VOUDT, "        
SET @@SQL = @@SQL + "  EFFDT, "        
SET @@SQL = @@SQL + "  SHORTDESC, "        
SET @@SQL = @@SQL + "  DRAMT, "        
SET @@SQL = @@SQL + "  CRAMT, "        
SET @@SQL = @@SQL + "  VNO, "        
SET @@SQL = @@SQL + "  DDNO, "        
SET @@SQL = @@SQL + "  NARRATION, "        
SET @@SQL = @@SQL + "  CLTCODE, "        
SET @@SQL = @@SQL + "  VTYP, "        
SET @@SQL = @@SQL + "  VDT, "        
SET @@SQL = @@SQL + "  EDT, "        
SET @@SQL = @@SQL + "  ACNAME, "        
SET @@SQL = @@SQL + "  OPBAL, "        
SET @@SQL = @@SQL + "  L_ADDRESS1, "        
SET @@SQL = @@SQL + "  L_ADDRESS2, "        
SET @@SQL = @@SQL + "  L_ADDRESS3, "        
SET @@SQL = @@SQL + "  L_CITY, "        
SET @@SQL = @@SQL + "  L_ZIP, "        
SET @@SQL = @@SQL + "  RES_PHONE1, "        
SET @@SQL = @@SQL + "  BRANCH_CD, "        
SET @@SQL = @@SQL + "  CROSAC, "        
SET @@SQL = @@SQL + "  EDIFF, "        
SET @@SQL = @@SQL + "  FAMILY, "        
SET @@SQL = @@SQL + "  SUB_BROKER, "        
SET @@SQL = @@SQL + "  TRADER, "        
SET @@SQL = @@SQL + "  CL_TYPE, "        
SET @@SQL = @@SQL + "  BANK_NAME, "        
SET @@SQL = @@SQL + "  CLTDPID, "        
SET @@SQL = @@SQL + "  LNO, "        
SET @@SQL = @@SQL + "  PDT, "
SET @@SQL = @@SQL +" PAN) "            

IF @@SERVERNAME <> @@ACCOUNTSVR        
SET @@SQL = @@SQL + "    EXEC "+ @@ACCOUNTSVR +"."+@@ACCOUNTDB+"..CLS_RPT_ACC_MARGINLEDGER "        
ELSE        
SET @@SQL = @@SQL + "    EXEC "+@@ACCOUNTDB+"..CLS_RPT_ACC_MARGINLEDGER "        
SET @@SQL = @@SQL +"'" + @FDATE +"', "        
SET @@SQL = @@SQL +"'" + @TDATE +"', "        
SET @@SQL = @@SQL +"'" + @FCODE +"', "        
SET @@SQL = @@SQL +"'" + @TCODE +"', "        
SET @@SQL = @@SQL +"'" + @STRORDER +"', "        
SET @@SQL = @@SQL +"'" + @SELECTBY +"', "        
SET @@SQL = @@SQL +"'" + @STATUSID +"', "        
SET @@SQL = @@SQL +"'" + @STATUSNAME +"', "        
SET @@SQL = @@SQL +"'" +@STATUSNAME_TO+"', "        
SET @@SQL = @@SQL +"'" +@ENTITY+"', "        
SET @@SQL = @@SQL +"'" +@ENTITY_LIST+"' "                




IF @SHOWMARGIN = 1 
BEGIN
print @@SQL
	EXEC (@@SQL)
END
  IF @ORDERFLG = 'N'        
  BEGIN        
  UPDATE #TMPLEDGERNEW         
   SET   EXCHANGE =@@EXCHANGE,        
   SEGMENT = @@SEGMENT ,        
   ENTITY = 'MARGIN  LEDGER',         
   ORDERSEG = 2         
  WHERE SEGMENT IS NULL         
      END        
    ELSE        
      BEGIN        
  UPDATE #TMPLEDGERNEW         
   SET    EXCHANGE = @@EXCHANGE,        
   SEGMENT = @@SEGMENT,        
   ENTITY = CASE WHEN @ENTITY_TYPE = 'ENTITY' THEN 'MARGIN-' + @@EXCHANGE ELSE @@GROUPID + ' - MARGIN LEDGER' END,        
   --IF @@ACCOUNTDB = 'ACCOUNT'        
   -- SET @@SQL = @@SQL + "        ORDERSEG = 4"        
   --ELSE IF @@ACCOUNTDB = 'ACCOUNTBSE'        
   -- SET @@SQL = @@SQL + "        ORDERSEG = 5"        
   --ELSE IF @@ACCOUNTDB = 'ACCOUNTFO'        
   -- SET @@SQL = @@SQL + "        ORDERSEG = 6"        
            
   ORDERSEG = @@ORDERSEG+ @@ORDERSECOUNT        
  WHERE  SEGMENT IS NULL         
 END 
END  

IF (@@ACCOUNTDB = 'BBO_FA'   AND (@CHARGES_LEDGER  = 0 OR @CHARGES_LEDGER  = 2))
BEGIN
	 
SET @@SQL = " INSERT INTO #TMPLEDGERNEW "            
	 SET @@SQL = @@SQL + " (BOOKTYPE, "            
	 SET @@SQL = @@SQL +" VOUDT, "            
	 SET @@SQL = @@SQL +" EFFDT, "            
	 SET @@SQL = @@SQL +" SHORTDESC, "            
	 SET @@SQL = @@SQL +" DRAMT, "            
	 SET @@SQL = @@SQL +" CRAMT, "            
	 SET @@SQL = @@SQL +" VNO, "            
	 SET @@SQL = @@SQL +" DDNO, "            
	 SET @@SQL = @@SQL +" NARRATION, "            
	 SET @@SQL = @@SQL +" CLTCODE, "            
	 SET @@SQL = @@SQL +" VTYP, "            
	 SET @@SQL = @@SQL +" VDT, "            
	 SET @@SQL = @@SQL +" EDT, "            
	 SET @@SQL = @@SQL +" ACNAME, "            
	 SET @@SQL = @@SQL +" OPBAL, "            
	 SET @@SQL = @@SQL +" L_ADDRESS1, "            
	 SET @@SQL = @@SQL +" L_ADDRESS2, "            
	 SET @@SQL = @@SQL +" L_ADDRESS3, "            
	 SET @@SQL = @@SQL +" L_CITY, "            
	 SET @@SQL = @@SQL +" L_ZIP, "            
	 SET @@SQL = @@SQL +" RES_PHONE1, "            
	 SET @@SQL = @@SQL +" BRANCH_CD, "            
	 SET @@SQL = @@SQL +" CROSAC, "            
	 SET @@SQL = @@SQL +" EDIFF, "            
	 SET @@SQL = @@SQL +" FAMILY, "            
	 SET @@SQL = @@SQL +" SUB_BROKER, "            
	 SET @@SQL = @@SQL +" TRADER, "            
	 SET @@SQL = @@SQL +" CL_TYPE, "            
	 SET @@SQL = @@SQL +" BANK_NAME, "            
	 SET @@SQL = @@SQL +" CLTDPID, "            
	 SET @@SQL = @@SQL +" LNO, "            
	 SET @@SQL = @@SQL +" PDT) "  
	 
	 SET @@SQL = @@SQL +" EXEC BBO_FA..CLS_BBO_RPT_ACC_PARTYLEDGER_ALL_FORCLIENT " 
	 SET @@SQL = @@SQL +"'" +@FDATE +"', "     
	 SET @@SQL = @@SQL +"'" +@TDATE +"', "            
	 SET @@SQL = @@SQL +"'" +@FCODE +"', "            
	 SET @@SQL = @@SQL +"'" +@TCODE +"', "            
	 SET @@SQL = @@SQL +"'" +@STRORDER +"', "            
	 SET @@SQL = @@SQL +"'" +@SELECTBY +"', '' , 0 , '' ,'', 0, '' ,"  
	 SET @@SQL = @@SQL +"'" +@STATUSID +"', "            
	 SET @@SQL = @@SQL +"'" +@STATUSNAME+"', '',"            
	 SET @@SQL = @@SQL +"'" +@@EXCHANGE + "-" + @@SEGMENT+"', " 
	 SET @@SQL = @@SQL +"'" +@SESSIONID+"' "                
	      
--RETURN        

PRINT (@@SQL)  
EXEC (@@SQL)

IF @ORDERFLG = 'N'        
BEGIN        
	UPDATE #TMPLEDGERNEW         
	SET EXCHANGE = @@EXCHANGE,         
		SEGMENT = @@SEGMENT,        
		ENTITY = 'SETTLEMENT LEDGER',        
		ORDERSEG = 1         
	WHERE  SEGMENT IS NULL         
END         
ELSE         
BEGIN        
	UPDATE #TMPLEDGERNEW         
		SET  EXCHANGE = @@EXCHANGE,        
		SEGMENT =@@SEGMENT,        
		ENTITY = CASE WHEN @ENTITY_TYPE = 'ENTITY' THEN @@EXCHANGE  +"-"+ @@SEGMENT ELSE @@GROUPID + ' - SETTLEMENT LEDGER' END,        
		ORDERSEG = @@ORDERSEG         
	WHERE  SEGMENT IS NULL         
END         
        
SET @@SQL = "  INSERT INTO #TMPLEDGERNEW "        
SET @@SQL = @@SQL + " (BOOKTYPE, "        
SET @@SQL = @@SQL + "  VOUDT, "        
SET @@SQL = @@SQL + "  EFFDT, "        
SET @@SQL = @@SQL + "  SHORTDESC, "        
SET @@SQL = @@SQL + "  DRAMT, "        
SET @@SQL = @@SQL + "  CRAMT, "        
SET @@SQL = @@SQL + "  VNO, "        
SET @@SQL = @@SQL + "  DDNO, "        
SET @@SQL = @@SQL + "  NARRATION, "        
SET @@SQL = @@SQL + "  CLTCODE, "        
SET @@SQL = @@SQL + "  VTYP, "        
SET @@SQL = @@SQL + "  VDT, "        
SET @@SQL = @@SQL + "  EDT, "        
SET @@SQL = @@SQL + "  ACNAME, "        
SET @@SQL = @@SQL + "  OPBAL, "        
SET @@SQL = @@SQL + "  L_ADDRESS1, "        
SET @@SQL = @@SQL + "  L_ADDRESS2, "        
SET @@SQL = @@SQL + "  L_ADDRESS3, "        
SET @@SQL = @@SQL + "  L_CITY, "        
SET @@SQL = @@SQL + "  L_ZIP, "        
SET @@SQL = @@SQL + "  RES_PHONE1, "        
SET @@SQL = @@SQL + "  BRANCH_CD, "        
SET @@SQL = @@SQL + "  CROSAC, "        
SET @@SQL = @@SQL + "  EDIFF, "        
SET @@SQL = @@SQL + "  FAMILY, "        
SET @@SQL = @@SQL + "  SUB_BROKER, "        
SET @@SQL = @@SQL + "  TRADER, "        
SET @@SQL = @@SQL + "  CL_TYPE, "        
SET @@SQL = @@SQL + "  BANK_NAME, "        
SET @@SQL = @@SQL + "  CLTDPID, "        
SET @@SQL = @@SQL + "  LNO, "        
SET @@SQL = @@SQL + "  PDT, "
SET @@SQL = @@SQL +" PAN) "            

	IF @@SERVERNAME <> @@ACCOUNTSVR      
	BEGIN  
		SET @@SQL = @@SQL + "    EXEC "+ @@ACCOUNTSVR +"."+@@ACCOUNTDB+"..CLS_RPT_ACC_MARGINLEDGER "        
	END
	ELSE        
		BEGIN
	SET @@SQL = @@SQL + "    EXEC "+@@ACCOUNTDB+"..CLS_RPT_ACC_MARGINLEDGER "        
	END
	SET @@SQL = @@SQL +"'" + @FDATE +"', "        
	SET @@SQL = @@SQL +"'" + @TDATE +"', "        
	SET @@SQL = @@SQL +"'" + @FCODE +"', "        
	SET @@SQL = @@SQL +"'" + @TCODE +"', "        
	SET @@SQL = @@SQL +"'" + @STRORDER +"', "        
	SET @@SQL = @@SQL +"'" + @SELECTBY +"', "        
	SET @@SQL = @@SQL +"'" + @STATUSID +"', "        
	SET @@SQL = @@SQL +"'" + @STATUSNAME +"', "        
	SET @@SQL = @@SQL +"'" +@STATUSNAME_TO+"', "        
	SET @@SQL = @@SQL +"'" +@ENTITY+"', "        
	SET @@SQL = @@SQL +"'" +@ENTITY_LIST+"' "     
		           
IF @SHOWMARGIN = 1 
BEGIN
	PRINT(@@SQL)      
	EXEC (@@SQL)	
END

	IF @ORDERFLG = 'N'        
	BEGIN        
		UPDATE #TMPLEDGERNEW         
		SET   EXCHANGE =@@EXCHANGE,        
		SEGMENT = @@SEGMENT ,        
		ENTITY = 'MARGIN  LEDGER',         
		ORDERSEG = 2         
		WHERE SEGMENT IS NULL         
	END        
	ELSE        
	BEGIN        
		UPDATE #TMPLEDGERNEW         
		SET    EXCHANGE = @@EXCHANGE,        
		SEGMENT = @@SEGMENT,        
		ENTITY = CASE WHEN @ENTITY_TYPE = 'ENTITY' THEN 'MARGIN-' + @@EXCHANGE ELSE @@GROUPID + ' - MARGIN LEDGER' END,        
		--IF @@ACCOUNTDB = 'ACCOUNT'        
		-- SET @@SQL = @@SQL + "        ORDERSEG = 4"        
		--ELSE IF @@ACCOUNTDB = 'ACCOUNTBSE'        
		-- SET @@SQL = @@SQL + "        ORDERSEG = 5"        
		--ELSE IF @@ACCOUNTDB = 'ACCOUNTFO'        
		-- SET @@SQL = @@SQL + "        ORDERSEG = 6"        
            
		ORDERSEG = @@ORDERSEG+ @@ORDERSECOUNT        
		WHERE  SEGMENT IS NULL         
	END  
END  

IF @MARGINREQ = '1' AND @@SEGMENT = 'FUTURES' AND @@EXCHANGE = 'NSE'
BEGIN
	SET @@SQL = "  INSERT INTO #TMPLEDGERNEW( "        
	--SET @@SQL = @@SQL + " (BOOKTYPE, "        
	SET @@SQL = @@SQL + "  VOUDT, "        
	SET @@SQL = @@SQL + "  EFFDT, "        
	SET @@SQL = @@SQL + "  SHORTDESC, "        
	SET @@SQL = @@SQL + "  DRAMT, "        
	SET @@SQL = @@SQL + "  CRAMT, "        
	SET @@SQL = @@SQL + "  VNO, "        
	SET @@SQL = @@SQL + "  DDNO, "        
	SET @@SQL = @@SQL + "  NARRATION, "        
	SET @@SQL = @@SQL + "  CLTCODE, "        
	SET @@SQL = @@SQL + "  VTYP, "        
	SET @@SQL = @@SQL + "  VDT, "        
	SET @@SQL = @@SQL + "  EDT) "        
	/*SET @@SQL = @@SQL + "  ACNAME, "        
	SET @@SQL = @@SQL + "  OPBAL, "        
	SET @@SQL = @@SQL + "  L_ADDRESS1, "        
	SET @@SQL = @@SQL + "  L_ADDRESS2, "        
	SET @@SQL = @@SQL + "  L_ADDRESS3, "        
	SET @@SQL = @@SQL + "  L_CITY, "        
	SET @@SQL = @@SQL + "  L_ZIP, "        
	SET @@SQL = @@SQL + "  RES_PHONE1, "        
	SET @@SQL = @@SQL + "  BRANCH_CD, "        
	SET @@SQL = @@SQL + "  CROSAC, "        
	SET @@SQL = @@SQL + "  EDIFF, "        
	SET @@SQL = @@SQL + "  FAMILY, "        
	SET @@SQL = @@SQL + "  SUB_BROKER, "        
	SET @@SQL = @@SQL + "  TRADER, "        
	SET @@SQL = @@SQL + "  CL_TYPE, "        
	SET @@SQL = @@SQL + "  BANK_NAME, "        
	SET @@SQL = @@SQL + "  CLTDPID, "        
	SET @@SQL = @@SQL + "  LNO, "        
	SET @@SQL = @@SQL + "  PDT, "
	SET @@SQL = @@SQL +" PAN) "    */        

	SET @@SQL = @@SQL +"EXEC " + @@SHAREDB + "..CLS_V2_GETMARGINREQ "
	SET @@SQL = @@SQL +"'" + @TDATE + "',"
	SET @@SQL = @@SQL +"'" + @TDATE + "',"
	SET @@SQL = @@SQL +"'" + @FCODE + "',"
	SET @@SQL = @@SQL +"'" + @TCODE + "',"
	SET @@SQL = @@SQL +"'" + @STATUSID + "',"
	SET @@SQL = @@SQL +"'" + @STATUSNAME + "',"
	SET @@SQL = @@SQL +"'ho'"

	print 'MARGIN  REQ '+@@SQL
	EXEC (@@SQL)

	IF @ORDERFLG = 'N'        
	BEGIN        
		UPDATE #TMPLEDGERNEW         
		SET   EXCHANGE =@@EXCHANGE,        
		SEGMENT = @@SEGMENT ,        
		ENTITY = 'MARGIN  REQ',         
		ORDERSEG = 3         
		WHERE SEGMENT IS NULL         
	END        
	ELSE        
	BEGIN        
		UPDATE #TMPLEDGERNEW         
		SET    EXCHANGE = @@EXCHANGE,        
		SEGMENT = @@SEGMENT,        
		ENTITY = CASE WHEN @ENTITY_TYPE = 'ENTITY' THEN 'MARGREQ-' + @@EXCHANGE ELSE @@GROUPID + ' - MARGIN REQ' END,        
		--IF @@ACCOUNTDB = 'ACCOUNT'        
		-- SET @@SQL = @@SQL + "        ORDERSEG = 4"        
		--ELSE IF @@ACCOUNTDB = 'ACCOUNTBSE'        
		-- SET @@SQL = @@SQL + "        ORDERSEG = 5"        
		--ELSE IF @@ACCOUNTDB = 'ACCOUNTFO'        
		-- SET @@SQL = @@SQL + "        ORDERSEG = 6"        
            
		ORDERSEG = @@ORDERSEG+ @@ORDERSECOUNT        
		WHERE  SEGMENT IS NULL         
	END 
END    
         
        
FETCH NEXT FROM @@MAINREC INTO @@ACCOUNTDB, @@EXCHANGE, @@SEGMENT, @@ACCOUNTSVR, @@SHAREDB ,@@GROUPID, @@ORDERSEG           
END        
CLOSE @@MAINREC        
DEALLOCATE @@MAINREC     


IF @CHARGES_LEDGER <> '0'
BEGIN
	SET @@SQL = " INSERT INTO #TMPLEDGERNEW "        
	SET @@SQL = @@SQL + " (BOOKTYPE, "        
	SET @@SQL = @@SQL +" VOUDT, "        
	SET @@SQL = @@SQL +" EFFDT, "        
	SET @@SQL = @@SQL +" SHORTDESC, "        
	SET @@SQL = @@SQL +" DRAMT, "        
	SET @@SQL = @@SQL +" CRAMT, "        
	SET @@SQL = @@SQL +" VNO, "        
	SET @@SQL = @@SQL +" DDNO, "        
	SET @@SQL = @@SQL +" NARRATION, "        
	SET @@SQL = @@SQL +" CLTCODE, "        
	SET @@SQL = @@SQL +" VTYP, "        
	SET @@SQL = @@SQL +" VDT, "        
	SET @@SQL = @@SQL +" EDT, "        
	SET @@SQL = @@SQL +" ACNAME, "        
	SET @@SQL = @@SQL +" OPBAL, "        
	SET @@SQL = @@SQL +" L_ADDRESS1, "        
	SET @@SQL = @@SQL +" L_ADDRESS2, "        
	SET @@SQL = @@SQL +" L_ADDRESS3, "        
	SET @@SQL = @@SQL +" L_CITY, "        
	SET @@SQL = @@SQL +" L_ZIP, "        
	SET @@SQL = @@SQL +" RES_PHONE1, "        
	SET @@SQL = @@SQL +" BRANCH_CD, "        
	SET @@SQL = @@SQL +" CROSAC, "        
	SET @@SQL = @@SQL +" EDIFF, "        
	SET @@SQL = @@SQL +" FAMILY, "        
	SET @@SQL = @@SQL +" SUB_BROKER, "        
	SET @@SQL = @@SQL +" TRADER, "        
	SET @@SQL = @@SQL +" CL_TYPE, "        
	SET @@SQL = @@SQL +" BANK_NAME, "        
	SET @@SQL = @@SQL +" CLTDPID, "        
	SET @@SQL = @@SQL +" LNO, "        
	SET @@SQL = @@SQL +" PDT, "        
	SET @@SQL = @@SQL +" EMAIL, "        
	SET @@SQL = @@SQL +" MOBILE_PAGER, "        
	SET @@SQL = @@SQL +" PAN) "    
	IF @@SERVERNAME <> @@ACCOUNTSVR        
	SET @@SQL = @@SQL +" EXEC "+@@ACCOUNTSVR+".ACCOUNT..CLS_RPT_ACC_CHARGELEDGER_WPARENT "        
	ELSE        
	SET @@SQL = @@SQL +" EXEC ACCOUNT..CLS_RPT_ACC_CHARGELEDGER_WPARENT "        
	SET @@SQL = @@SQL +"'" +@FDATE +"', "        
	SET @@SQL = @@SQL +"'" +@TDATE +"', "        
	SET @@SQL = @@SQL +"'" +@FCODE +"', "        
	SET @@SQL = @@SQL +"'" +@TCODE +"', "        
	SET @@SQL = @@SQL +"'" +@STRORDER +"', "        
	SET @@SQL = @@SQL +"'" +@SELECTBY +"', "        
	SET @@SQL = @@SQL +"'" +@STATUSID +"', "        
	SET @@SQL = @@SQL +"'" +@STATUSNAME+"', "        
	SET @@SQL = @@SQL +"'" +@STATUSNAME_TO+"', "        
	SET @@SQL = @@SQL +"'" +@ENTITY+"', "        
	SET @@SQL = @@SQL +"'" +@ENTITY_LIST+"' ,"    
	SET @@SQL = @@SQL +"'" +@SESSIONID+"' "      
    
        
	--PRINT (@@SQL)  
        
	EXEC (@@SQL)   



	IF @ORDERFLG = 'N'        
	BEGIN        
		UPDATE #TMPLEDGERNEW         
		SET   EXCHANGE =@@EXCHANGE,        
		SEGMENT = @@SEGMENT ,        
		ENTITY = 'CHARGES  LEDGER',         
		ORDERSEG = 3         
		WHERE SEGMENT IS NULL         
	END        
	ELSE        
	BEGIN        
		UPDATE #TMPLEDGERNEW         
		SET    EXCHANGE = 'CHARGES',        
		SEGMENT = 'CHARGES',        
		ENTITY = 'CHARGES LEDGER',        
		--IF @@ACCOUNTDB = 'ACCOUNT'        
		-- SET @@SQL = @@SQL + "        ORDERSEG = 4"        
		--ELSE IF @@ACCOUNTDB = 'ACCOUNTBSE'        
		-- SET @@SQL = @@SQL + "        ORDERSEG = 5"        
		--ELSE IF @@ACCOUNTDB = 'ACCOUNTFO'        
		-- SET @@SQL = @@SQL + "        ORDERSEG = 6"        
            
		ORDERSEG = 99        
		WHERE  SEGMENT IS NULL         
	END  
END
        
/* UPDATE CITY STATE */
	UPDATE A
	SET A.[L_CITY] = ISNULL(B.l_city,'') + ', ' + ISNULL(B.l_state,'')
--			[RES_PHONE1]= B.MOBILE_PAGER
	from #TMPLEDGERNEW A
			inner join msajag..CLIENT_DETAILS B
			ON A.CLTCODE = b.CL_CODE
	
/* UPDATE CITY STATE */

--SELECT TOP 1 * FROM msajag..CLIENT_DETAILS B

--IF ((SELECT COUNT(1) FROM [#DBNAME] WHERE ACCOUNTDB = 'ACCOUNTFO') = 1)        
--BEGIN        
--    INSERT INTO #TMPLEDGERNEW        
--              (VOUDT,        
--               EFFDT,        
--               SHORTDESC,        
--               DRAMT,        
--               CRAMT,        
--               VNO,        
--               DDNO,        
--               NARRATION,        
--               CLTCODE,        
--               VTYP,        
--               VDT,        
--             EDT)        
--    EXEC BSEFO.DBO.V2_GETMARGINREQ        
--      @TDATE ,        
--      @FCODE ,        
--      @TCODE ,        
--  @STATUSID ,        
--      @STATUSNAME ,        
--      @STRBRANCH        
         
              
--        UPDATE #TMPLEDGERNEW        
--        SET    EXCHANGE = 'NSE',        
--          SEGMENT = 'FUTURES',        
--               ENTITY = 'MARGIN REQ - NFO',        
--               ORDERSEG = (@@ORDERSECOUNT * 2)+ 1        
--        WHERE  SEGMENT IS NULL        
              
--END  

--IF @FORPDF = 'Y'        
--  BEGIN        

--  --SET @WHERECLAUS  = "WHERE  NARRATION = 'TOTAL BALANCE' AND DRAMT <> 0 AND CRAMT <> 0"
-- -- DELETE FROM #TMPLEDGERNEW WHERE (CRAMT = 0 AND DRAMT = 0 AND OPBAL = 0)
--  end

        
    IF @ORDERFLG = 'N'        
      BEGIN        
        SELECT   CLTCODE,        
				 EXCHANGE,        
				 SEGMENT,        
                 ORDERSEG,        
                 OPBAL = MAX(OPBAL)        
        INTO     #OPBAL        
        FROM     #TMPLEDGERNEW        
        GROUP BY CLTCODE,EXCHANGE,SEGMENT,ORDERSEG        
        
        
        SELECT   CLTCODE,        
                 ORDERSEG,        
                 OPBAL = SUM(OPBAL),
				 EXCHANGE = MAX(EXCHANGE),
				 SEGMENT = MAX(SEGMENT)        
        INTO     #FINOPBAL        
        FROM     #OPBAL        
        GROUP BY CLTCODE,ORDERSEG        
        
        UPDATE #TMPLEDGERNEW        
        SET    OPBAL = 0        
        
        UPDATE #TMPLEDGERNEW        
        SET    OPBAL = ISNULL(T.OPBAL,0)        
        FROM   #TMPLEDGERNEW L WITH (NOLOCK),        
               #FINOPBAL T WITH (NOLOCK)        
        WHERE          
			L.CLTCODE = T.CLTCODE                             
			AND L.ORDERSEG = T.ORDERSEG

--		DELETE T
--		FROM #TMPLEDGERNEW T WHERE NARRATION = 'OPENING BALANCE' AND NOT EXISTS(SELECT CLTCODE FROM  #FINOPBAL O WHERE T.CLTCODE = O.CLTCODE AND T.EXCHANGE = O.EXCHANGE AND T.SEGMENT = O.SEGMENT)
      END        
      UPDATE #TMPLEDGERNEW SET ACTIVE_SEG = EXCHLIST FROM MSAJAG..CLS_GET_CLIENT_FAM_EXCH_LIST C WHERE #TMPLEDGERNEW.CLTCODE = CL_CODE
	  UPDATE #TMPLEDGERNEW SET L_ADDRESS3= REPLACE(L_ADDRESS3,'\','/') 

	  
IF @ORDERFLG = 'Y'        
BEGIN                
	INSERT INTO #TMPLEDGERNEW(SHORTDESC, DRAMT, CRAMT, NARRATION, CLTCODE, VTYP, VDT, EDT, ACNAME, OPBAL, PDT, EXCHANGE, SEGMENT, ENTITY, ORDERSEG, ACTIVE_SEG, VOUDT, EFFDT, CROSAC, L_ADDRESS1, L_ADDRESS2, L_ADDRESS3, L_CITY, L_ZIP,EMAIL,MOBILE_PAGER,PAN,BRANCH_CD)    
	SELECT 'OPBAL', DRAMT = CASE WHEN MAX(OPBAL) > 0 THEN MAX(OPBAL) ELSE 0 END, CRAMT = CASE WHEN MAX(OPBAL) < 0 THEN MAX(ABS(OPBAL)) ELSE 0 END, 'OPENING BALANCE', CLTCODE, 18, convert(VARCHAR(10), CONVERT(DATETIME, @YEAR_START), 103), convert(VARCHAR(10), CONVERT(DATETIME, @YEAR_START), 103), ACNAME, MAX(OPBAL), @YEAR_START, EXCHANGE, SEGMENT, ENTITY,  
	ORDERSEG, ACTIVE_SEG,    
	VOUDT = CONVERT(DATETIME, @YEAR_START), EFFDT = CONVERT(DATETIME, @YEAR_START), CLTCODE, L_ADDRESS1, L_ADDRESS2, L_ADDRESS3, L_CITY, L_ZIP,EMAIL,MOBILE_PAGER ,PAN,BRANCH_CD   
	FROM #TMPLEDGERNEW    
	GROUP BY CLTCODE, ACNAME, EXCHANGE, SEGMENT, ENTITY, ORDERSEG, ACTIVE_SEG, L_ADDRESS1, L_ADDRESS2, L_ADDRESS3, L_CITY, L_ZIP,EMAIL,MOBILE_PAGER,PAN,BRANCH_CD
	--HAVING CASE WHEN MAX(OPBAL) > 0 THEN MAX(OPBAL) ELSE 0 END <> 0 OR CASE WHEN MAX(OPBAL) < 0 THEN MAX(OPBAL) ELSE 0 END <> 0    
END 
ELSE
BEGIN
	INSERT INTO #TMPLEDGERNEW(SHORTDESC, DRAMT, CRAMT, NARRATION, CLTCODE, VTYP, VDT, EDT, ACNAME, OPBAL, PDT, EXCHANGE, SEGMENT, ENTITY, ORDERSEG, ACTIVE_SEG, VOUDT, EFFDT, CROSAC, L_ADDRESS1, L_ADDRESS2, L_ADDRESS3, L_CITY, L_ZIP,EMAIL,MOBILE_PAGER,PAN,BRANCH_CD)    
	SELECT 'OPBAL', DRAMT = CASE WHEN MAX(OPBAL) > 0 THEN MAX(OPBAL) ELSE 0 END, CRAMT = CASE WHEN MAX(OPBAL) < 0 THEN MAX(ABS(OPBAL)) ELSE 0 END, 'OPENING BALANCE', CLTCODE, 18, convert(VARCHAR(10), CONVERT(DATETIME, @YEAR_START), 103), convert(VARCHAR(10), CONVERT(DATETIME, @YEAR_START), 103), ACNAME, MAX(OPBAL), @YEAR_START, MAX(EXCHANGE), MAX(SEGMENT), ENTITY,  
	ORDERSEG, ACTIVE_SEG,    
	VOUDT = CONVERT(DATETIME, @YEAR_START), EFFDT = CONVERT(DATETIME, @YEAR_START), CLTCODE, L_ADDRESS1, L_ADDRESS2, L_ADDRESS3, L_CITY, max(L_ZIP),max(EMAIL),max(MOBILE_PAGER),max(PAN),max(BRANCH_CD)
	FROM #TMPLEDGERNEW    
	GROUP BY CLTCODE, ACNAME, ENTITY, ORDERSEG, ACTIVE_SEG, L_ADDRESS1, L_ADDRESS2, L_ADDRESS3, L_CITY/*, L_ZIP,EMAIL,MOBILE_PAGER,PAN,BRANCH_CD   */  
	--HAVING CASE WHEN MAX(OPBAL) > 0 THEN MAX(OPBAL) ELSE 0 END <> 0 OR CASE WHEN MAX(OPBAL) < 0 THEN MAX(OPBAL) ELSE 0 END <> 0    
END
    
-- SELECT * FROM #TMPLEDGERNEW      
--RETURN      
 DELETE FROM #TMPLEDGERNEW WHERE VTYP = 18 /*AND ISNULL(NARRATION, '') <> 'OPENING BALANCE'*/ AND ISNULL(SHORTDESC, '') <> 'OPBAL'    
    
/*SELECT * FROM #TMPLEDGERNEW T,    
(SELECT CLTCODE, COUNT(1) #TMPLEDGERNEW    
GROUP BY CLTCODE    
HAVING COUNT(1) = 1)    
WHERE T.CLTCODE = T1.CLTCODE AND T.DRAMT = 0 AND T.CRAMT = 0*/    
--select @YEAR_END,DATEADD(DAY,1,CONVERT(DATETIME, @YEAR_END))
IF @ORDERFLG = 'Y'        
BEGIN                    
	INSERT INTO #TMPLEDGERNEW(SHORTDESC, DRAMT, CRAMT, NARRATION, CLTCODE, VTYP, VDT, EDT, ACNAME, OPBAL, PDT, EXCHANGE, SEGMENT, ENTITY, ORDERSEG, ACTIVE_SEG, VOUDT, EFFDT, CROSAC)    
	SELECT 'TBAL', DRAMT = SUM(DRAMT), CRAMT = CASE WHEN SUM(CRAMT) < 0 THEN -SUM(CRAMT) ELSE SUM(CRAMT) END,     
	'TOTAL BALANCE', CLTCODE, 98, convert(VARCHAR(10), CONVERT(DATETIME, @YEAR_END), 103), convert(VARCHAR(10), CONVERT(DATETIME, @YEAR_END), 103), ACNAME, MAX(OPBAL), @YEAR_END, EXCHANGE, SEGMENT, ENTITY, ORDERSEG, ACTIVE_SEG,    
	VOUDT = DATEADD(DAY,1,CONVERT(DATETIME, @YEAR_END)), EFFDT = CONVERT(DATETIME, @YEAR_END), CLTCODE    
	FROM #TMPLEDGERNEW    
	GROUP BY CLTCODE, ACNAME, EXCHANGE, SEGMENT, ENTITY, ORDERSEG, ACTIVE_SEG     
END
ELSE
BEGIN
	INSERT INTO #TMPLEDGERNEW(SHORTDESC, DRAMT, CRAMT, NARRATION, CLTCODE, VTYP, VDT, EDT, ACNAME, OPBAL, PDT, EXCHANGE, SEGMENT, ENTITY, ORDERSEG, ACTIVE_SEG, VOUDT, EFFDT, CROSAC)    
	SELECT 'TBAL', DRAMT = SUM(DRAMT), CRAMT = CASE WHEN SUM(CRAMT) < 0 THEN -SUM(CRAMT) ELSE SUM(CRAMT) END,     
	'TOTAL BALANCE', CLTCODE, 98, convert(VARCHAR(10), CONVERT(DATETIME, @YEAR_END), 103), convert(VARCHAR(10), CONVERT(DATETIME, @YEAR_END), 103), ACNAME, MAX(OPBAL), @YEAR_END, EXCHANGE = MAX(EXCHANGE), SEGMENT = MAX(SEGMENT), ENTITY, ORDERSEG, ACTIVE_SEG,    
	VOUDT = DATEADD(DAY,1,CONVERT(DATETIME, @YEAR_END)), EFFDT = CONVERT(DATETIME, @YEAR_END), CLTCODE
	FROM #TMPLEDGERNEW    
	GROUP BY CLTCODE, ACNAME, ENTITY, ORDERSEG, ACTIVE_SEG     
END

INSERT INTO #TMPLEDGERNEW(SHORTDESC, DRAMT, CRAMT, NARRATION, CLTCODE, VTYP, VDT, EDT, ACNAME, OPBAL, PDT, EXCHANGE, SEGMENT, ENTITY, ORDERSEG, ACTIVE_SEG, VOUDT, EFFDT, CROSAC)    
SELECT SHORTDESC = 'NTBAL', DRAMT = SUM(DRAMT), CRAMT = CASE WHEN SUM(CRAMT) < 0 THEN -SUM(CRAMT) ELSE SUM(CRAMT) END,     
'NET BALANCE', CLTCODE, 99, convert(VARCHAR(10), CONVERT(DATETIME, @YEAR_END), 103), convert(VARCHAR(10), CONVERT(DATETIME, @YEAR_END), 103), ACNAME, MAX(OPBAL), @YEAR_END, EXCHANGE = MAX(EXCHANGE), SEGMENT = MAX(SEGMENT), ENTITY = MAX(ENTITY), ORDERSEG = MAX(ORDERSEG), ACTIVE_SEG = MAX(ACTIVE_SEG),    
VOUDT = DATEADD(DAY,1,CONVERT(DATETIME, @YEAR_END)), EFFDT = CONVERT(DATETIME, @YEAR_END), CLTCODE
FROM #TMPLEDGERNEW
WHERE SHORTDESC = 'TBAL'
GROUP BY CLTCODE, ACNAME --, ENTITY, ORDERSEG, ACTIVE_SEG


/* NEW PATCH ADDED TO UPDATE THE PARENT_CODE IN CASE OF PARENT SELECTION */
IF @PARENTCHILD_FLAG = 'P'
BEGIN
	UPDATE U SET CLTCODE = PARENT_CODE, ACNAME = PARENT_NAME FROM #TMPLEDGERNEW U, MSAJAG..CLS_CLIENT_PARTY_LEDGER C
	WHERE U.CLTCODE = C.PARTY_CODE
END
/* NEW PATCH ADDED TO UPDATE THE PARENT_CODE IN CASE OF PARENT SELECTION */     
         
 IF @FORPDF = 'Y'        
  BEGIN        

  --SET @WHERECLAUS  = "WHERE  NARRATION = 'TOTAL BALANCE' AND DRAMT <> 0 AND CRAMT <> 0"
 -- DELETE FROM #TMPLEDGERNEW WHERE (CRAMT <>0 AND DRAMT <> 0 OR OPBAL <> 0)

   ALTER TABLE #TMPLEDGERNEW ADD PDFLINES INT        
   UPDATE #TMPLEDGERNEW SET PDFLINES = LEN(LTRIM(RTRIM(ISNULL(NARRATION, '')))) / 35 + 1 WHERE VTYP <> '18'        
   UPDATE #TMPLEDGERNEW SET PDFLINES = (I.LNO + 1) FROM (SELECT CLTCODE, LNO = SUM(PDFLINES) FROM #TMPLEDGERNEW GROUP BY CLTCODE) I        
     WHERE #TMPLEDGERNEW.CLTCODE = I.CLTCODE        
        
        
   UPDATE #TMPLEDGERNEW SET PARTYROWCOUNT = CEILING(CONVERT(NUMERIC(10,2), LEN(ISNULL(NARRATION, ''))) / 35)        
   UPDATE #TMPLEDGERNEW SET PARTYROWCOUNT = 1 WHERE LEN(ISNULL(NARRATION, '')) = 0        
   UPDATE #TMPLEDGERNEW SET PARTYROWCOUNT = (SELECT SUM(PARTYROWCOUNT) /*+ COUNT(DISTINCT ORDERSEG)*/ FROM #TMPLEDGERNEW I WHERE #TMPLEDGERNEW.CLTCODE = I.CLTCODE GROUP BY CLTCODE)        
   UPDATE #TMPLEDGERNEW SET PARTYROWCOUNT = PARTYROWCOUNT + (SELECT (COUNT(DISTINCT ORDERSEG) * 1) + 1 FROM #TMPLEDGERNEW I WHERE #TMPLEDGERNEW.CLTCODE = I.CLTCODE GROUP BY CLTCODE)        
   UPDATE #TMPLEDGERNEW SET TOTALPAGES = .DBO.PARTYLEDGERPAGES(PARTYROWCOUNT)        
        
        
  END        
        
        
--  BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT,CRAMT,VNO,DDNO,NARRATION,CLTCODE,VTYP,VDT,EDT,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,CROSAC,EDIFF=ISNULL(EDIFF,0),FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES      
      
IF @CSV = 'Y'      
BEGIN  
  
CREATE TABLE #PARTYLEDGERCSV      
(      
 CLTCODE VARCHAR(10),      
 VOUCHER_DATE VARCHAR(10),       
 EFFECTIVE_DATE VARCHAR(10),     
 VTYPE VARCHAR(15),       
 VNO VARCHAR(15),       
 AC_CODE VARCHAR(10),       
 PERTIULARS VARCHAR(500),       
 DDNO VARCHAR(20),       
 DRAMT MONEY,       
 CRAMT MONEY,      
 ENTITY     VARCHAR(50),        
 ORDERSEG   BIGINT,        
 BALANCE MONEY,      
 SNO INT IDENTITY(1, 1)      
)   

    
 INSERT INTO #PARTYLEDGERCSV      
 (      
  CLTCODE, VOUCHER_DATE, EFFECTIVE_DATE, VTYPE, VNO, AC_CODE,       
  PERTIULARS, DDNO, DRAMT, CRAMT, ENTITY, ORDERSEG      
 ) 
 SELECT       
  CLTCODE, VOUCHER_DATE = '', EFFECTIVE_DATE = '', VTYPE = 'OPENING', VNO = '', AC_CODE = CLTCODE,       
  PERTIULARS = 'OPENING ENTRY', DDNO = '', DRAMT = CASE WHEN MAX(OPBAL) > 0 THEN MAX(OPBAL) ELSE 0 END,       
  CRAMT = CASE WHEN MAX(OPBAL) <= 0 THEN MAX(ABS(OPBAL)) ELSE 0 END, ENTITY, ORDERSEG      
 FROM   #TMPLEDGERNEW
 GROUP BY CLTCODE, ENTITY, ORDERSEG      
 ORDER BY       
  CLTCODE,        
  ORDERSEG      
  
 INSERT INTO #PARTYLEDGERCSV      
 (      
  CLTCODE, VOUCHER_DATE, EFFECTIVE_DATE, VTYPE, VNO, AC_CODE,       
  PERTIULARS, DDNO, DRAMT, CRAMT, ENTITY, ORDERSEG      
 )      
 SELECT   CLTCODE, VOUCHER_DATE = CONVERT(VARCHAR(10),VDT,103), EFFECTIVE_DATE = CONVERT(VARCHAR(10),EDT,103) , VTYPE = SHORTDESC, isnull(VNO,''), AC_CODE = CASE WHEN SHORTDESC = 'OPBAL ' THEN CLTCODE ELSE CROSAC END,   PERTIULARS = NARRATION, isnull(DDNO,''), DRAMT, CRAMT, ENTITY, ORDERSEG      
 FROM  #TMPLEDGERNEW      
 WHERE     VOUDT IS NOT NULL  AND VTYP <> 18    
 ORDER BY       
  CLTCODE,        
  ORDERSEG,        
  VOUDT        
        
 UPDATE P      
 SET BALANCE = (SELECT SUM( CRAMT-DRAMT) FROM #PARTYLEDGERCSV P1 WHERE P.CLTCODE = P1.CLTCODE AND P.ENTITY = P1.ENTITY AND P.ORDERSEG = P1.ORDERSEG AND P1.SNO <= P.SNO)      
 FROM #PARTYLEDGERCSV P      

 UPDATE #PARTYLEDGERCSV SET BALANCE = DRAMT - CRAMT WHERE PERTIULARS IN('TOTAL BALANCE', 'NET BALANCE')
       
 SELECT  *       FROM #PARTYLEDGERCSV ORDER BY CLTCODE, ORDERSEG, SNO      

RETURN
       
END      
    
	IF @VTYPE <> ''
	BEGIN
		DELETE FROM #TMPLEDGERNEW WHERE  VTYP <> @VTYPE
	END


DECLARE @SHOWQuartely INT
DECLARE @BOUNCE INT
DECLARE @CHKDISPATH VARCHAR(2)

SELECT @SHOWQuartely = PVALUE FROM CLS_CLIENT_LEDGER_PARAMETERS WHERE PKEY = 'CHK_QUARTELY' AND SESSIONID = @SESSIONID
SELECT @BOUNCE = PVALUE FROM CLS_CLIENT_LEDGER_PARAMETERS WHERE PKEY = 'CHK_BOUNCE' AND SESSIONID = @SESSIONID
SELECT @CHKDISPATH = PVALUE FROM CLS_CLIENT_LEDGER_PARAMETERS WHERE PKEY = 'chkDispath' AND SESSIONID = @SESSIONID

SET @SHOWQUARTELY = @SHOWQUARTELY + @BOUNCE


   /* CHANGES FOR ECN FLAG */
  
   IF(@ECNFLAG IN ('0','2') AND @SHOWQUARTELY <> 1 )
   BEGIN
   		--DELETE ALL JV ENTRY
		SELECT DISTINCT CLTCODE 
		INTO #QTR_CLIENTS
		FROM #TMPLEDGERNEW 
		WHERE VTYP NOT IN (8,18,98,99)
		--ISNULL(VTYP, '8') <> '8' 
				
		SELECT DISTINCT CLTCODE 
		INTO #QTR_CLIENTS1
		FROM #TMPLEDGERNEW 
		WHERE CRAMT - DRAMT >= 1000 
		AND NARRATION = 'NET BALANCE'
		
		DELETE  T FROM #TMPLEDGERNEW T
		WHERE NOT EXISTS (SELECT CLTCODE FROM #QTR_CLIENTS Q WHERE T.CLTCODE = Q.CLTCODE)
		  
		DELETE  T FROM #TMPLEDGERNEW T
		WHERE NOT EXISTS (SELECT CLTCODE FROM #QTR_CLIENTS1 Q WHERE T.CLTCODE = Q.CLTCODE)
		  
   END 
  

--IF(@CHKDISPATH = '1')
--BEGIN

--INSERT INTO ACCOUNT.DBO.TBL_DISPATCH_CLIENT_LEDGER 
--SELECT DISTINCT CLTCODE , [ACNAME],@SESSIONID
--FROM #TMPLEDGERNEW

--RETURN 

--END 

--select * from #TMPLEDGERNEW


  -- UPDATE B SET B.BRANCH_CD = A.BRANCH_CD, b.cltcode = ltrim(rtrim(cltcode)), b.crosac = ltrim(rtrim(crosac)) FROM MSAJAG..CLIENT_DETAILS A, #TMPLEDGERNEW B  WHERE A.PARTY_CODE = B.CLTCODE
   

 -- select distinct cltcode ,[ACNAME] into QLedger from  #TMPLEDGERNEW return 
   /* CHANGES FOR ECN FLAG */


   UPDATE #TMPLEDGERNEW SET VTYP = 0 WHERE SHORTDESC = 'OPBAL'

	IF @DASHBOARD = 'Y'
	  BEGIN
	  PRINT 'DASHBOARD'
	  /*
	  ALTER TABLE #TMPLEDGERNEW
	  ADD RBalance MONEY
	  */
	 

	  SELECT 'VOUDT' as VOUDT,'EFFDT' as EFFDT,'SHORTDESC' as SHORTDESC,'DRAMT' as DRAMT,'CRAMT' as CRAMT,'VNO' as VNO,
		'DDNO' as DDNO,'NARRATION' as NARRATION,'CLTCODE' as CLTCODE,'ACNAME' as ACNAME,'VTYP' as VTYP,'VDT' as VDT,'EDT' as EDT,'BRANCH_CD' as BRANCH_CD,'CROSAC' as CROSAC,'EDIFF' as EDIFF,'ENTITY' as ENTITY,'EXCSEG' as EXCSEG,
			 '0' AS ORDERSEG, 
			'VOUDT'+'$'+'EFFDT'+'$'+'SHORTDESC'+'$'+'DRAMT'+'$'+'CRAMT'+'$'+'VNO'+'$'+'DDNO'+'$'+'NARRATION'+'$'+'VTYP'+'$'+'VDT'+'$'+'EDT'+'$'+'EDIFF' AS CENTERBODY
			
	 UNION ALL 
	
	SELECT 	CONVERT(VARCHAR,  VOUDT)as VOUDT,CONVERT(VARCHAR,  EFFDT) as EFFDT, SHORTDESC as SHORTDESC,CONVERT(VARCHAR,DRAMT) as DRAMT,CONVERT(VARCHAR, CRAMT)  as CRAMT
			, CASE  WHEN  VNO IS NULL THEN '0' ELSE  VNO END  as VNO
			, CASE WHEN  DDNO  IS NULL THEN '0' ELSE  DDNO END  as DDNO
			, NARRATION as NARRATION , CLTCODE, ACNAME,CONVERT(VARCHAR, VTYP) as VTYP
			,CONVERT(VARCHAR, CONVERT(DATETIME, VDT,103),103) as VDT
			,CONVERT(VARCHAR, EDT)  as EDT
			, CASE WHEN  BRANCH_CD  IS NULL THEN '0' ELSE  BRANCH_CD END  as BRANCH_CD
			, CROSAC as CROSAC
			,CASE WHEN CONVERT(VARCHAR, EDIFF)  IS NULL THEN '0' ELSE CONVERT(VARCHAR, EDIFF) END  as EDIFF
			, ENTITY as ENTITY
			,EXCSEG= EXCHANGE+'-'+ SEGMENT ,-- RUNNINGBAL = SUM(T2.DRAMT - T2.CRAMT),
			 CONVERT(VARCHAR,  ORDERSEG) ORDERSEG,  
			CONVERT(VARCHAR,  VOUDT)+'$'+
			CONVERT(VARCHAR,  EFFDT)+'$'+
			 SHORTDESC+'$'+  
			CONVERT(VARCHAR, DRAMT)+'$'+  
			CONVERT(VARCHAR, CRAMT)+'$'+  
			ISNULL(  VNO  ,'0')+'$'+  
			ISNULL(  DDNO ,'0')+'$'+ 
			 NARRATION+'$'+  
			CONVERT(VARCHAR, VTYP)+'$'+
			CONVERT(VARCHAR, CONVERT(DATETIME, VDT,103),103)+'$'+  
			CONVERT(VARCHAR, EDT)+'$'+  
			ISNULL( CONVERT(VARCHAR, EDIFF) ,'0')  AS CENTERBODY
FROM #TMPLEDGERNEW 
ORDER BY ORDERSEG  , CLTCODE, VDT ,VNO 

--		INNER JOIN #TMPLEDGERNEW  AS t2
--	ON T1.CLTCODE >= T2.CLTCODE
--GROUP BY T1.VOUDT, T1.EFFDT , T1.SHORTDESC, T1.DRAMT ,T1.CRAMT , T1.VNO,T1.DDNO ,T1.NARRATION , T1.ENTITY ,
--	T1.CLTCODE, T1.ACNAME, T1.VTYP, T1.VDT, T1.EDT, T1.BRANCH_CD, T1.CROSAC, T1.EDIFF, T1.EXCHANGE, T1.SEGMENT

	  /*
	    INSERT INTO #TEMPDASHBOARD
		SELECT * FROM #TMPLEDGERNEW
		ORDER BY CLTCODE,ORDERSEG,  CONVERT(VARCHAR, CONVERT(DATETIME,VDT,103),103) ,VNO
	 */
	  END
	  ELSE
	  BEGIN	  
	  CREATE TABLE #LEDGER_RUNNING_DATA
	  (
		SNO INT IDENTITY(1, 1),
		BOOKTYPE VARCHAR(3),
		VOUDT DATETIME,
		EFFDT DATETIME,
		VDT VARCHAR(11),
		EDT VARCHAR(11), 
		SHORTDESC VARCHAR(100),
		VNO VARCHAR(12),
		CROSAC VARCHAR(10),
		DDNO VARCHAR(30),
		NARRATION VARCHAR(500),
		DRAMT MONEY,
		CRAMT MONEY,
		CLTCODE VARCHAR(10),
		VTYP INT,
		ACNAME VARCHAR(100),
		OPBAL MONEY,
		L_ADDRESS1 VARCHAR(100),
		L_ADDRESS2 VARCHAR(100),
		L_ADDRESS3 VARCHAR(100),
		L_CITY VARCHAR(50),
		L_ZIP VARCHAR(30),
		RES_PHONE1 VARCHAR(30),
		BRANCH_CD VARCHAR(20),
		EDIFF INT,
		FAMILY VARCHAR(10),
		SUB_BROKER VARCHAR(30),
		TRADER VARCHAR(30),
		CL_TYPE VARCHAR(10),
		BANK_NAME VARCHAR(100),
		CLTDPID VARCHAR(100),
		LNO INT,
		PDT DATETIME,
		EMAIL VARCHAR(100),
		MOBILE_PAGER VARCHAR(30),
		PAN VARCHAR(30),
		EXCHANGE VARCHAR(10),
		SEGMENT  VARCHAR(10),
		ENTITY  VARCHAR(20),
		ORDERSEG INT,
		ACTIVE_SEG  VARCHAR(100),
		PARTYROWCOUNT INT,
		TOTALPAGES INT, 
		CLTCODE_TODISPLAY VARCHAR(50), 
		CHECKSTATUS VARCHAR(20) , 
		COLORFLAG VARCHAR(10), 
		ENTITY_DESC VARCHAR(500), 
		REPORT_DATE VARCHAR(20),
		RUNNING_BAL MONEY
	)
	  IF @STRORDER = 'ACCODE'        
      BEGIN    
		
        IF @SELECTBY = 'VDT'        
          BEGIN        
            IF @ORDERFLG = 'N'        
              BEGIN
				INSERT INTO #LEDGER_RUNNING_DATA        
			    SELECT  BOOKTYPE,VOUDT,EFFDT,VDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),VDT,103) END,EDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),EDT,103) END, SHORTDESC = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE SHORTDESC END,VNO,CROSAC,DDNO = ISNULL(CASE WHEN DDNO = '0' THEN NULL ELSE DDNO END ,''),NARRATION,DRAMT,CRAMT,CLTCODE,VTYP,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,EDIFF=ISNULL(EDIFF,0),FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EMAIL,MOBILE_PAGER,PAN,EXCHANGE = T.EXCHANGE,SEGMENT = T.SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES, CLTCODE_TODISPLAY =  CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CLTCODE END  , CHECKSTATUS = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE (CASE WHEN EFFDT > @TDATE THEN 'U' ELSE '' END) END , COLORFLAG = CASE WHEN EFFDT > CONVERT(VARCHAR(11),GETDATE(),109)+' 23:59' THEN '0' ELSE '1' END, ENTITY_DESC = ISNULL(C.SEGMENT_DESCRIPTION,'CHARGES ENTRIES'), REPORT_DATE = CONVERT(VARCHAR(10), GETDATE(), 103), RUNNING_BAL = 0
                FROM     #TMPLEDGERNEW T LEFT OUTER JOIN CLS_COMPANY_MASTER_SETTING C
				ON    T.EXCHANGE = C.EXCHANGE AND T.SEGMENT = C.SEGMENT				     
				--WHERE T.EXCHANGE = C.EXCHANGE AND T.SEGMENT = C.SEGMENT        
                ORDER BY CLTCODE,        
                         ORDERSEG,        
                        CONVERT(DATETIME,CONVERT(VARCHAR(10),VOUDT,101)),PDT, VNO,VTYP 
						
				UPDATE #LEDGER_RUNNING_DATA SET RUNNING_BAL = (sELECT SUM(CRAMT - DRAMT) FROM #LEDGER_RUNNING_DATA L WHERE #LEDGER_RUNNING_DATA.CLTCODE = L.CLTCODE AND #LEDGER_RUNNING_DATA.ENTITY = L.ENTITY AND L.SNO <= #LEDGER_RUNNING_DATA.SNO)

				SELECT * FROM #LEDGER_RUNNING_DATA ORDER BY SNO        
              END        
            ELSE        
              BEGIN  

			  INSERT INTO #LEDGER_RUNNING_DATA        
			     SELECT    BOOKTYPE=ISNULL(BOOKTYPE,''),VOUDT,EFFDT,VDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),VDT,103) END,EDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),EDT,103) END,SHORTDESC = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE SHORTDESC END,VNO=ISNULL(VNO,''),CROSAC,DDNO = ISNULL(CASE WHEN DDNO = '0' THEN '' ELSE DDNO END,''),NARRATION,DRAMT,CRAMT,CLTCODE,VTYP,ACNAME,OPBAL,L_ADDRESS1=ISNULL(L_ADDRESS1,''),L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,EDIFF=ISNULL(EDIFF,0),FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EMAIL,MOBILE_PAGER,PAN,EXCHANGE = t.EXCHANGE,SEGMENT = t.SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES , CLTCODE_TODISPLAY =  CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CLTCODE END, CHECKSTATUS = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE (CASE WHEN EFFDT > @TDATE THEN 'U' ELSE '' END) END , COLORFLAG = CASE WHEN EFFDT > CONVERT(VARCHAR(11),GETDATE(),109)+' 23:59' THEN '0' ELSE '1' END , ENTITY_DESC = ISNULL(C.SEGMENT_DESCRIPTION,'CHARGES ENTRIES'), REPORT_DATE = CONVERT(VARCHAR(10), GETDATE(), 103), running_bal = 0
                FROM     #TMPLEDGERNEW T LEFT OUTER JOIN CLS_COMPANY_MASTER_SETTING C
				ON    T.EXCHANGE = C.EXCHANGE AND T.SEGMENT = C.SEGMENT	        
                ORDER BY CLTCODE,        
                         ORDERSEG,        
                         CONVERT(DATETIME,CONVERT(VARCHAR(10),VOUDT,101)),PDT, VNO,VTYP
						
				UPDATE #LEDGER_RUNNING_DATA SET RUNNING_BAL = (sELECT SUM(CRAMT - DRAMT) FROM #LEDGER_RUNNING_DATA L WHERE #LEDGER_RUNNING_DATA.CLTCODE = L.CLTCODE AND #LEDGER_RUNNING_DATA.ENTITY = L.ENTITY AND L.SNO <= #LEDGER_RUNNING_DATA.SNO)

				SELECT * FROM #LEDGER_RUNNING_DATA ORDER BY SNO   
			  
                       
              END        
          END        
        ELSE        
          BEGIN        
            IF @ORDERFLG = 'N'        
              BEGIN  
			        
			  INSERT INTO #LEDGER_RUNNING_DATA     
			    SELECT * FROM #LEDGER_RUNNING_DATA ORDER BY SNO
                SELECT    BOOKTYPE,VOUDT,EFFDT,VDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),VDT,103) END,EDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),EDT,103) END,SHORTDESC = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE SHORTDESC END,VNO,CROSAC,DDNO = CASE WHEN DDNO = '0' THEN NULL ELSE DDNO END,NARRATION,DRAMT,CRAMT,CLTCODE,VTYP,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,EDIFF=ISNULL(EDIFF,0),FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EMAIL,MOBILE_PAGER,PAN,EXCHANGE = T.EXCHANGE,SEGMENT = T.SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES, CLTCODE_TODISPLAY =  CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CLTCODE END, CHECKSTATUS = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE (CASE WHEN EFFDT > @TDATE THEN 'U' ELSE '' END) END , COLORFLAG = CASE WHEN EFFDT > CONVERT(VARCHAR(11),GETDATE(),109)+' 23:59' THEN '0' ELSE '1' END ,ENTITY_DESC = ISNULL(C.SEGMENT_DESCRIPTION,'CHARGES ENTRIES'), REPORT_DATE = CONVERT(VARCHAR(10), GETDATE(), 103), RUNNING_BAL = 0
                FROM     #TMPLEDGERNEW T LEFT OUTER JOIN CLS_COMPANY_MASTER_SETTING C
				ON    T.EXCHANGE = C.EXCHANGE AND T.SEGMENT = C.SEGMENT	        
                ORDER BY CLTCODE,        
                         ORDERSEG,        
                         CONVERT(DATETIME,CONVERT(VARCHAR(10),EFFDT,101)),PDT,VTYP          
						  
				UPDATE #LEDGER_RUNNING_DATA SET RUNNING_BAL = (SELECT SUM(CRAMT - DRAMT) FROM #LEDGER_RUNNING_DATA L WHERE #LEDGER_RUNNING_DATA.CLTCODE = L.CLTCODE AND #LEDGER_RUNNING_DATA.ENTITY = L.ENTITY AND L.SNO <= #LEDGER_RUNNING_DATA.SNO)

				
              END        
            ELSE        
              BEGIN
			  
				INSERT INTO #LEDGER_RUNNING_DATA     
			    SELECT    BOOKTYPE,VOUDT,EFFDT,VDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),VDT,103) END,EDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),EDT,103) END,SHORTDESC = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE SHORTDESC END,VNO,CROSAC,DDNO  = CASE WHEN DDNO = '0' THEN NULL ELSE DDNO END,NARRATION,DRAMT,CRAMT,CLTCODE,VTYP,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,EDIFF=ISNULL(EDIFF,0),FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EMAIL,MOBILE_PAGER,PAN,EXCHANGE = T.EXCHANGE,SEGMENT = T.SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES, CLTCODE_TODISPLAY =  CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CLTCODE END, CHECKSTATUS = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE (CASE WHEN EFFDT > @TDATE THEN 'U' ELSE '' END) END  ,COLORFLAG = CASE WHEN EFFDT > CONVERT(VARCHAR(11),GETDATE(),109)+' 23:59' THEN '0' ELSE '1' END, ENTITY_DESC = ISNULL(C.SEGMENT_DESCRIPTION,'CHARGES ENTRIES'), REPORT_DATE = CONVERT(VARCHAR(10), GETDATE(), 103), RUNNING_BAL = 0
                FROM     #TMPLEDGERNEW T LEFT OUTER JOIN CLS_COMPANY_MASTER_SETTING C
				ON    T.EXCHANGE = C.EXCHANGE AND T.SEGMENT = C.SEGMENT	       
                ORDER BY CLTCODE,        
                         ORDERSEG,        
                         CONVERT(DATETIME,CONVERT(VARCHAR(10),EFFDT,101)),PDT ,VTYP 
						  
				UPDATE #LEDGER_RUNNING_DATA SET RUNNING_BAL = (SELECT SUM(CRAMT - DRAMT) FROM #LEDGER_RUNNING_DATA L WHERE #LEDGER_RUNNING_DATA.CLTCODE = L.CLTCODE AND #LEDGER_RUNNING_DATA.ENTITY = L.ENTITY AND L.SNO <= #LEDGER_RUNNING_DATA.SNO)    
			      
                      
              END        
          END        
      END        
  ELSE        
 BEGIN        
 IF @SELECTBY = 'VDT' 
	      BEGIN        
		    IF @ORDERFLG = 'N'        
              BEGIN
				INSERT INTO #LEDGER_RUNNING_DATA     
			    SELECT    BOOKTYPE,VOUDT,EFFDT,VDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),VDT,103) END,EDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),EDT,103) END,SHORTDESC = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE SHORTDESC END,VNO,CROSAC,DDNO  = CASE WHEN DDNO = '0' THEN NULL ELSE DDNO END,NARRATION,DRAMT,CRAMT,CLTCODE,VTYP,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,EDIFF=ISNULL(EDIFF,0),FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EMAIL,MOBILE_PAGER,PAN,EXCHANGE = t.EXCHANGE,SEGMENT = t.SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES, CLTCODE_TODISPLAY =  CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CLTCODE END, CHECKSTATUS = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE (CASE WHEN EFFDT > @TDATE THEN 'U' ELSE '' END) END, COLORFLAG = CASE WHEN EFFDT > CONVERT(VARCHAR(11),GETDATE(),109)+' 23:59' THEN '0' ELSE '1' END, ENTITY_DESC = ISNULL(C.SEGMENT_DESCRIPTION,'CHARGES ENTRIES'), REPORT_DATE = CONVERT(VARCHAR(10), GETDATE(), 103),
				RUNNING_BAL = 0
				FROM     #TMPLEDGERNEW T left outer join CLS_COMPANY_MASTER_SETTING C        
				on T.EXCHANGE = C.EXCHANGE AND T.SEGMENT = C.SEGMENT
                ORDER BY ACNAME,        
                         ORDERSEG,        
                          CONVERT(DATETIME,CONVERT(VARCHAR(10),VOUDT,101)),PDT, VNO  
						  
				UPDATE #LEDGER_RUNNING_DATA SET RUNNING_BAL = (SELECT SUM(CRAMT - DRAMT) FROM #LEDGER_RUNNING_DATA L WHERE #LEDGER_RUNNING_DATA.CLTCODE = L.CLTCODE AND #LEDGER_RUNNING_DATA.ENTITY = L.ENTITY AND L.SNO <= #LEDGER_RUNNING_DATA.SNO)

				SELECT * FROM #LEDGER_RUNNING_DATA ORDER BY SNO
              END        
            ELSE        
              BEGIN   
			  
			  INSERT INTO #LEDGER_RUNNING_DATA     
			    SELECT    BOOKTYPE,VOUDT,EFFDT,VDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),VDT,103) END,EDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),EDT,103) END,SHORTDESC = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL'  THEN '' ELSE SHORTDESC END,VNO,CROSAC,DDNO  = CASE WHEN DDNO = '0' THEN NULL ELSE DDNO END,NARRATION,DRAMT,CRAMT,CLTCODE,VTYP,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,EDIFF=ISNULL(EDIFF,0),FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EMAIL,MOBILE_PAGER,PAN,EXCHANGE = T.EXCHANGE,SEGMENT = T.SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES, CLTCODE_TODISPLAY =  CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CLTCODE END, CHECKSTATUS = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE (CASE WHEN EFFDT > @TDATE THEN 'U' ELSE '' END) END, COLORFLAG = CASE WHEN EFFDT > CONVERT(VARCHAR(11),GETDATE(),109)+' 23:59' THEN '0' ELSE '1' END , ENTITY_DESC = ISNULL(C.SEGMENT_DESCRIPTION,'CHARGES ENTRIES'), REPORT_DATE = CONVERT(VARCHAR(10), GETDATE(), 103), RUNNING_BAL = 0         
                FROM     #TMPLEDGERNEW T LEFT OUTER JOIN CLS_COMPANY_MASTER_SETTING C
				ON    T.EXCHANGE = C.EXCHANGE AND T.SEGMENT = C.SEGMENT	       
                ORDER BY ACNAME,        
                         ORDERSEG,        
                         CONVERT(DATETIME,CONVERT(VARCHAR(10),VOUDT,101)),PDT, VNO,VTYP    
						  
				UPDATE #LEDGER_RUNNING_DATA SET RUNNING_BAL = (SELECT SUM(CRAMT - DRAMT) FROM #LEDGER_RUNNING_DATA L WHERE #LEDGER_RUNNING_DATA.CLTCODE = L.CLTCODE AND #LEDGER_RUNNING_DATA.ENTITY = L.ENTITY AND L.SNO <= #LEDGER_RUNNING_DATA.SNO)

				SELECT * FROM #LEDGER_RUNNING_DATA ORDER BY SNO     
			
                     
              END        
          END        
        ELSE        
          BEGIN        
            IF @ORDERFLG = 'N'        
              BEGIN 
			  
				INSERT INTO #LEDGER_RUNNING_DATA     
			    SELECT    BOOKTYPE,VOUDT,EFFDT,VDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),VDT,103) END,EDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),EDT,103) END,SHORTDESC = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL'  THEN '' ELSE SHORTDESC END,CROSAC,VNO,DDNO  = CASE WHEN DDNO = '0' THEN NULL ELSE DDNO END,NARRATION,DRAMT,CRAMT,CLTCODE,VTYP,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,EDIFF=ISNULL(EDIFF,0),FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EMAIL,MOBILE_PAGER,PAN,EXCHANGE = t.EXCHANGE,SEGMENT = t.SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES , CLTCODE_TODISPLAY =  CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CLTCODE END, CHECKSTATUS = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE (CASE WHEN EFFDT > @TDATE THEN 'U' ELSE '' END) END, COLORFLAG = CASE WHEN EFFDT > CONVERT(VARCHAR(11),GETDATE(),109)+' 23:59' THEN '0' ELSE '1' END, ENTITY_DESC = ISNULL(C.SEGMENT_DESCRIPTION,'CHARGES ENTRIES'), REPORT_DATE = CONVERT(VARCHAR(10), GETDATE(), 103), RUNNING_BAL = 0          
                FROM     #TMPLEDGERNEW T LEFT OUTER JOIN CLS_COMPANY_MASTER_SETTING C
				ON    T.EXCHANGE = C.EXCHANGE AND T.SEGMENT = C.SEGMENT	         
                ORDER BY cltcode,        
                         ORDERSEG,        
                         CONVERT(DATETIME,CONVERT(VARCHAR(10),EFFDT,101)),PDT ,VTYP        
						  
				UPDATE #LEDGER_RUNNING_DATA SET RUNNING_BAL = (SELECT SUM(CRAMT - DRAMT) FROM #LEDGER_RUNNING_DATA L WHERE #LEDGER_RUNNING_DATA.CLTCODE = L.CLTCODE AND #LEDGER_RUNNING_DATA.ENTITY = L.ENTITY AND L.SNO <= #LEDGER_RUNNING_DATA.SNO)

				SELECT * FROM #LEDGER_RUNNING_DATA ORDER BY SNO    
			
                
              END        
            ELSE        
              BEGIN
			  
				INSERT INTO #LEDGER_RUNNING_DATA     
			    SELECT    BOOKTYPE,VOUDT,EFFDT,VDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),VDT,103) END,EDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),EDT,103) END,SHORTDESC = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE SHORTDESC END,CROSAC,VNO,DDNO  = CASE WHEN DDNO = '0' THEN NULL ELSE DDNO END,NARRATION,DRAMT,CRAMT,CLTCODE,VTYP,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,EDIFF=ISNULL(EDIFF,0),FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EMAIL,MOBILE_PAGER,PAN,EXCHANGE = t.EXCHANGE,SEGMENT = t.SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES, CLTCODE_TODISPLAY =  CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CLTCODE END, CHECKSTATUS = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE (CASE WHEN EFFDT > @TDATE THEN 'U' ELSE '' END) END, COLORFLAG = CASE WHEN EFFDT > CONVERT(VARCHAR(11),GETDATE(),109)+' 23:59' THEN '0' ELSE '1' END, ENTITY_DESC = ISNULL(C.SEGMENT_DESCRIPTION,'CHARGES ENTRIES'), REPORT_DATE = CONVERT(VARCHAR(10), GETDATE(), 103), RUNNING_BAL = 0       
                FROM     #TMPLEDGERNEW T LEFT OUTER JOIN CLS_COMPANY_MASTER_SETTING C
				ON    T.EXCHANGE = C.EXCHANGE AND T.SEGMENT = C.SEGMENT	          
                ORDER BY cltcode,        
                         ORDERSEG,        
                         CONVERT(DATETIME,CONVERT(VARCHAR(10),EFFDT,101)) ,PDT,VTYP        
						  
				UPDATE #LEDGER_RUNNING_DATA SET RUNNING_BAL = (SELECT SUM(CRAMT - DRAMT) 
				FROM #LEDGER_RUNNING_DATA L 
				WHERE #LEDGER_RUNNING_DATA.CLTCODE = L.CLTCODE AND #LEDGER_RUNNING_DATA.ENTITY = L.ENTITY AND L.SNO <= #LEDGER_RUNNING_DATA.SNO)

				SELECT * FROM #LEDGER_RUNNING_DATA ORDER BY SNO    
			
                
              END        
          END        
      END 
  END   
END    

--    IF @STRORDER = 'ACCODE' 
	
--      BEGIN        
--        IF @SELECTBY = 'VDT'        
--          BEGIN        
--            IF @ORDERFLG = 'N'        
--              BEGIN   
--			    SELECT  BOOKTYPE,VOUDT,EFFDT,VDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),VDT,103) END,EDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),EDT,103) END, SHORTDESC = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE SHORTDESC END,VNO,CROSAC,DDNO = ISNULL(CASE WHEN DDNO = '0' THEN NULL ELSE DDNO END ,''),NARRATION,CLTCODE,VTYP,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,EDIFF=ISNULL(EDIFF,0),FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EMAIL,MOBILE_PAGER,PAN,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES, CLTCODE_TODISPLAY =  CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CLTCODE END  , CHECKSTATUS = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE (CASE WHEN EFFDT > @TDATE THEN 'U' ELSE '' END) END , COLORFLAG = CASE WHEN EFFDT > CONVERT(VARCHAR(11),GETDATE(),109)+' 23:59' THEN '0' ELSE '1' END  
--                FROM     #TMPLEDGERNEW        
            
--                ORDER BY CLTCODE,   ACNAME,     
--                         ORDERSEG,        
--                         VOUDT, VNO        
--              END        
--            ELSE        
--              BEGIN  
--                SELECT    BOOKTYPE=ISNULL(BOOKTYPE,''),VOUDT,EFFDT,VDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),VDT,103) END,EDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),EDT,103) END,SHORTDESC = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE SHORTDESC END,VNO=ISNULL(VNO,''),CROSAC,DDNO = ISNULL(CASE WHEN DDNO = '0' THEN '' ELSE DDNO END,''),NARRATION,DRAMT,CRAMT,CLTCODE,VTYP,ACNAME,OPBAL,L_ADDRESS1=ISNULL(L_ADDRESS1,''),L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,EDIFF=ISNULL(EDIFF,0),FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EMAIL,MOBILE_PAGER,PAN,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES , CLTCODE_TODISPLAY =  CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CLTCODE END, CHECKSTATUS = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE (CASE WHEN EFFDT > @TDATE THEN 'U' ELSE '' END) END , COLORFLAG = CASE WHEN EFFDT > CONVERT(VARCHAR(11),GETDATE(),109)+' 23:59' THEN '0' ELSE '1' END   
--                FROM     #TMPLEDGERNEW        
--                ORDER BY CLTCODE,   ACNAME,     
--                         ORDERSEG,        
--                         VOUDT, VNO,VTYP        
--              END        
--          END        
--        ELSE        
--          BEGIN        
--            IF @ORDERFLG = 'N'        
--              BEGIN        
--                SELECT    BOOKTYPE,VOUDT,EFFDT,VDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),VDT,103) END,EDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),EDT,103) END,SHORTDESC = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE SHORTDESC END,VNO,CROSAC,DDNO = CASE WHEN DDNO = '0' THEN NULL ELSE DDNO END,NARRATION,DRAMT,CRAMT,CLTCODE,VTYP,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,EDIFF=ISNULL(EDIFF,0),FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EMAIL,MOBILE_PAGER,PAN,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES, CLTCODE_TODISPLAY =  CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CLTCODE END, CHECKSTATUS = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE (CASE WHEN EFFDT > @TDATE THEN 'U' ELSE '' END) END , COLORFLAG = CASE WHEN EFFDT > CONVERT(VARCHAR(11),GETDATE(),109)+' 23:59' THEN '0' ELSE '1' END  
--                FROM     #TMPLEDGERNEW        
--                ORDER BY CLTCODE,  ACNAME,      
--                         ORDERSEG,        
--                         EFFDT        
--              END        
--            ELSE        
--              BEGIN        
--                SELECT    BOOKTYPE,VOUDT,EFFDT,VDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),VDT,103) END,EDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),EDT,103) END,SHORTDESC = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE SHORTDESC END,VNO,CROSAC,DDNO  = CASE WHEN DDNO = '0' THEN NULL ELSE DDNO END,NARRATION,DRAMT,CRAMT,CLTCODE,VTYP,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,EDIFF=ISNULL(EDIFF,0),FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EMAIL,MOBILE_PAGER,PAN,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES, CLTCODE_TODISPLAY =  CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CLTCODE END, CHECKSTATUS = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE (CASE WHEN EFFDT > @TDATE THEN 'U' ELSE '' END) END  ,COLORFLAG = CASE WHEN EFFDT > CONVERT(VARCHAR(11),GETDATE(),109)+' 23:59' THEN '0' ELSE '1' END  
--                FROM     #TMPLEDGERNEW        
--                ORDER BY CLTCODE,  ACNAME,      
--                         ORDERSEG,        
--                         EFFDT ,VTYP       
--              END        
--          END        
--      END        
--  ELSE        
-- BEGIN        
-- IF @SELECTBY = 'VDT'        
--          BEGIN        
--            IF @ORDERFLG = 'N'        
--              BEGIN   
			    
--			    SELECT    BOOKTYPE,VOUDT,EFFDT,VDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),VDT,103) END,EDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),EDT,103) END,SHORTDESC = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE SHORTDESC END,VNO,CROSAC,DDNO  = CASE WHEN DDNO = '0' THEN NULL ELSE DDNO END,NARRATION,DRAMT,CRAMT,CLTCODE,VTYP,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,EDIFF=ISNULL(EDIFF,0),FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EMAIL,MOBILE_PAGER,PAN,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES, CLTCODE_TODISPLAY =  CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CLTCODE END, CHECKSTATUS = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE (CASE WHEN EFFDT > @TDATE THEN 'U' ELSE '' END) END, COLORFLAG = CASE WHEN EFFDT > CONVERT(VARCHAR(11),GETDATE(),109)+' 23:59' THEN '0' ELSE '1' END            
--                FROM     #TMPLEDGERNEW T        
--                ORDER BY ACNAME,   CLTCODE,     
--                         ORDERSEG,        
--                         VOUDT, VNO, VTYP        
--              END        
--            ELSE        
--              BEGIN        
--                SELECT    BOOKTYPE,VOUDT,EFFDT,VDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),VDT,103) END,EDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),EDT,103) END,SHORTDESC = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL'  THEN '' ELSE SHORTDESC END,VNO,CROSAC,DDNO  = CASE WHEN DDNO = '0' THEN NULL ELSE DDNO END,NARRATION,DRAMT,CRAMT,CLTCODE,VTYP,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,EDIFF=ISNULL(EDIFF,0),FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EMAIL,MOBILE_PAGER,PAN,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES, CLTCODE_TODISPLAY =  CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CLTCODE END, CHECKSTATUS = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE (CASE WHEN EFFDT > @TDATE THEN 'U' ELSE '' END) END, COLORFLAG = CASE WHEN EFFDT > CONVERT(VARCHAR(11),GETDATE(),109)+' 23:59' THEN '0' ELSE '1' END            
--                FROM     #TMPLEDGERNEW        
--                ORDER BY ACNAME,    CLTCODE,    
--                         ORDERSEG,        
--                         VOUDT, VNO, VTYP        
--              END        
--          END        
--        ELSE        
--          BEGIN        
--            IF @ORDERFLG = 'N'        
--              BEGIN        
--                SELECT    BOOKTYPE,VOUDT,EFFDT,VDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),VDT,103) END,EDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),EDT,103) END,SHORTDESC = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL'  THEN '' ELSE SHORTDESC END,CROSAC,VNO,DDNO  = CASE WHEN DDNO = '0' THEN NULL ELSE DDNO END,NARRATION,DRAMT,CRAMT,CLTCODE,VTYP,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,EDIFF=ISNULL(EDIFF,0),FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EMAIL,MOBILE_PAGER,PAN,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES , CLTCODE_TODISPLAY =  CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CLTCODE END, CHECKSTATUS = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE (CASE WHEN EFFDT > @TDATE THEN 'U' ELSE '' END) END, COLORFLAG = CASE WHEN EFFDT > CONVERT(VARCHAR(11),GETDATE(),109)+' 23:59' THEN '0' ELSE '1' END            
--                FROM     #TMPLEDGERNEW        
--                ORDER BY ACNAME,   CLTCODE,     
--                         ORDERSEG,        
--                         EFFDT , VTYP       
--              END        
--            ELSE        
--              BEGIN        
--                SELECT    BOOKTYPE,VOUDT,EFFDT,VDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),VDT,103) END,EDT = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CONVERT(VARCHAR(11),EDT,103) END,SHORTDESC = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE SHORTDESC END,CROSAC,VNO,DDNO  = CASE WHEN DDNO = '0' THEN NULL ELSE DDNO END,NARRATION,DRAMT,CRAMT,CLTCODE,VTYP,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,EDIFF=ISNULL(EDIFF,0),FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO,PDT,EMAIL,MOBILE_PAGER,PAN,EXCHANGE,SEGMENT,ENTITY,ORDERSEG,ACTIVE_SEG,PARTYROWCOUNT,TOTALPAGES, CLTCODE_TODISPLAY =  CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE CLTCODE END, CHECKSTATUS = CASE WHEN SHORTDESC = 'NTBAL' OR SHORTDESC = 'TBAL' THEN '' ELSE (CASE WHEN EFFDT > @TDATE THEN 'U' ELSE '' END) END, COLORFLAG = CASE WHEN EFFDT > CONVERT(VARCHAR(11),GETDATE(),109)+' 23:59' THEN '0' ELSE '1' END          
--                FROM     #TMPLEDGERNEW        
--                ORDER BY ACNAME,     CLTCODE,   
--                         ORDERSEG,        
--                         EFFDT, VTYP        
--              END        
--          END        
--      END 
--  END   
--END

GO
