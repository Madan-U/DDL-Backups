-- Object: PROCEDURE dbo.CLASSPROC_SAUDA_SUMMARY_CASHPRINT_NEW
-- Server: 10.253.33.91 | DB: PRADNYA
--------------------------------------------------


--EXEC PRADNYA.DBO.CLASSPROC_SAUDA_SUMMARY_CASHPRINT_NEW @STATUSID = 'broker', @STATUSNAME = 'broker', @FROMPARTYCODE = '0', @TOPARTYCODE = 'ZZZZZZZ', @FROMDATE = 'Dec  1 2007', @TODATE = 'Nov 30 2010', @SETT_TYPE = '%', @FROMCODE = 'DFGDF', @TOCODE = 'DFGDF', @RPT_BY = 'SUB_BROKER' 

CREATE PROC [dbo].[CLASSPROC_SAUDA_SUMMARY_CASHPRINT_NEW]
	(                        
	@STATUSID VARCHAR(25),
	@STATUSNAME VARCHAR(25),
	@FROMPARTYCODE VARCHAR(10),
	@TOPARTYCODE VARCHAR(10),
	@FROMDATE VARCHAR(11),
	@TODATE VARCHAR(11),
	@SETT_TYPE VARCHAR(3),
	@FROMCODE VARCHAR(15)='',
	@TOCODE	VARCHAR(15)='zzzzzzzzzz',
	@RPT_BY VARCHAR(15)='BROKER'
	)                        
                        
/*                        
EXEC [CLASSPROC_SAUDA_SUMMARY_CASHPRINT_NEW] 'BROKER','BROKER', 'GV54', 'GV54', 'FEB  1 2011', 'FEB 28 2011' ,'%'                       
*/                        
                        
AS                        

IF @TOCODE = ''
BEGIN
	SET @TOCODE = 'zzzzzzzzzz'
END


SELECT
	DISTINCT
	PARTY_CODE,
	PARENTCODE
INTO 
	#PARTY
FROM
	AngelBSECM.PRADNYA.DBO.TBL_ECNCASH with (NOLOCK)
WHERE
	PARENTCODE BETWEEN @FROMPARTYCODE AND @TOPARTYCODE
	AND (
	CASE
		WHEN @RPT_BY = 'FAMILY'		THEN FAMILY
		WHEN @RPT_BY = 'REGION'		THEN REGION
		WHEN @RPT_BY = 'AREA'		THEN AREA
		WHEN @RPT_BY = 'BRANCH'		THEN BRANCH_CD
		WHEN @RPT_BY = 'SUB_BROKER'	THEN SUB_BROKER
		WHEN @RPT_BY = 'TRADER'		THEN TRADER
		ELSE PARTY_CODE
	END)
	BETWEEN @FROMCODE AND @TOCODE
	AND @STATUSNAME = (
	CASE 
		WHEN @STATUSID = 'AREA' THEN AREA                
		WHEN @STATUSID = 'REGION' THEN REGION                
		WHEN @STATUSID = 'BRANCH' THEN BRANCH_CD                
		WHEN @STATUSID = 'SUBBROKER' THEN SUB_BROKER                
		WHEN @STATUSID = 'TRADER' THEN TRADER                
		WHEN @STATUSID = 'FAMILY' THEN FAMILY                
		WHEN @STATUSID = 'CLIENT' THEN PARTY_CODE                
		WHEN @STATUSID = 'BROKER' THEN @STATUSNAME                
		ELSE 'I DONT KNOW ' 
	END)




CREATE TABLE #CLASSTBL_SAUDASUMMARY                        
(                        
 EXCHANGE VARCHAR(8),                        
 TRDTYPE  VARCHAR(10),                        
 PARTY_CODE VARCHAR(10),                        
 TRADEDATE VARCHAR(10),                        
 SCRIP_CD VARCHAR(12),                         
 SCRIP_NAME VARCHAR(100),                        
 SETT_NO VARCHAR(7),                        
 SETT_TYPE VARCHAR(3),                        
 BUYQTY INT,                         
 BUYAVGRATE MONEY,                        
 BUYAMOUNT MONEY,                         
 SELLQTY INT,                        
 SELLAVGRATE MONEY,                        
 SELLAMOUNT MONEY,                        
 NETQTY INT,                        
 NETAVGRATE MONEY,                        
 NetAmount MONEY,                        
 FLAG TINYINT,
 LONG_NAME VARCHAR(100),          
 BRANCH_CD VARCHAR(20),          
 SUB_BROKER VARCHAR(20),          
 L_ADDRESS1 VARCHAR(100),          
 L_ADDRESS2 VARCHAR(100),          
 L_ADDRESS3 VARCHAR(100),          
 L_CITY VARCHAR(50),          
 L_STATE VARCHAR(50),          
 L_ZIP VARCHAR(20),          
 MOBILE_PAGER VARCHAR(50),          
 RES_PHONE1 VARCHAR(100),          
 RES_PHONE2 VARCHAR(100),          
 OFF_PHONE1 VARCHAR(100)         
)                        
                        
----------------------------                        
-- NOW STARTING BSE CASH --                        
----------------------------                        
                        
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                        
INSERT INTO #CLASSTBL_SAUDASUMMARY                        
SELECT                         
 EXCHANGE = 'BSE CASH',                        
 TRDTYPE = '1. TRD',                        
 PARTY_CODE = P.PARENTCODE,                        
 TRADEDATE = CONVERT(VARCHAR,SAUDA_DATE,103),                        
 SCRIP_CD,                         
 SCRIP_NAME,                        
 SETT_NO,                        
 SETT_TYPE,                        
 BUYQTY = SUM(PQTYTRD),                         
 BUYAVGRATE = (CASE WHEN SUM(PQTYTRD) <> 0 THEN SUM(PAMTTRD) / SUM(PQTYTRD) ELSE 0 END),                        
 BUYAMOUNT = SUM(PAMTTRD),                         
 SELLQTY = SUM(SQTYTRD),                        
 SELLAVGRATE = (CASE WHEN SUM(SQTYTRD) <> 0 THEN SUM(SAMTTRD) / SUM(SQTYTRD) ELSE 0 END),                        
 SELLAMOUNT = SUM(SAMTTRD) ,                        
 NETQTY = SUM(PQTYTRD) - SUM(SQTYTRD),                        
 NETAVGRATE = (CASE WHEN (SUM(PQTYTRD) - SUM(SQTYTRD)) <> 0 THEN ABS((SUM(SAMTTRD)-SUM(PAMTTRD))/(SUM(PQTYTRD) - SUM(SQTYTRD))) ELSE 0 END),                        
 NETAMT = SUM(SAMTTRD)-SUM(PAMTTRD),                        
 FLAG = 1,
 LONG_NAME='',
 BRANCH_CD='',
 SUB_BROKER='',
 L_ADDRESS1='',
 L_ADDRESS2='',
 L_ADDRESS3='',
 L_CITY='',
 L_STATE='',
 L_ZIP='',
 MOBILE_PAGER='',
 RES_PHONE1='',
 RES_PHONE2='',
 OFF_PHONE1=''
FROM 
	BSEDB_AB.DBO.CMBILLVALAN C (NOLOCK),
	#PARTY P (NOLOCK)
WHERE 
	C.PARTY_CODE = P.PARTY_CODE
	AND SAUDA_DATE >= @FROMDATE
	AND SAUDA_DATE <= @TODATE + ' 23:59:59'
	AND C.SETT_TYPE = (CASE WHEN @SETT_TYPE = '%' THEN C.SETT_TYPE ELSE @SETT_TYPE END)
	AND C.SETT_TYPE NOT IN ('AC','AD')
GROUP BY                         
	P.PARENTCODE,                        
	CONVERT(VARCHAR,SAUDA_DATE,103),                        
	SCRIP_CD,                         
	SCRIP_NAME,                        
	SETT_NO,                        
	SETT_TYPE                        
HAVING                        
	SUM(PQTYTRD) - SUM(SQTYTRD) <> 0                         
	OR SUM(SAMTTRD)-SUM(PAMTTRD) <> 0                        
                        
UNION                        
                        
SELECT                         
 EXCHANGE = 'BSE CASH',                        
 TRDTYPE = '2. DEL',                         
 PARTY_CODE = P.PARENTCODE,                        
 TRADEDATE = CONVERT(VARCHAR,SAUDA_DATE,103),                   
 SCRIP_CD,                         
 SCRIP_NAME = SCRIP_NAME + ' (DELIVERY)',                        
 SETT_NO,                        
 SETT_TYPE,           
 BUYQTY = SUM(PQTYDEL),                         
 BUYAVGRATE = (CASE WHEN SUM(PQTYDEL) <> 0 THEN SUM(PAMTDEL) / SUM(PQTYDEL) ELSE 0 END),                        
 BUYAMOUNT = SUM(PAMTDEL),                         
 SELLQTY = SUM(SQTYDEL),                        
 SELLAVGRATE = (CASE WHEN SUM(SQTYDEL) <> 0 THEN SUM(SAMTDEL) / SUM(SQTYDEL) ELSE 0 END),                        
 SELLAMOUNT = SUM(SAMTDEL),                        
 NETQTY = SUM(PQTYDEL) - SUM(SQTYDEL),                        
 NETAVGRATE = (CASE WHEN (SUM(PQTYDEL) - SUM(SQTYDEL)) <> 0 THEN ABS((SUM(SAMTDEL)-SUM(PAMTDEL))/(SUM(PQTYDEL) - SUM(SQTYDEL))) ELSE 0 END),                        
 NETAMT = SUM(SAMTDEL)-SUM(PAMTDEL),                        
 FLAG = 1,
 LONG_NAME='',
 BRANCH_CD='',
 SUB_BROKER='',
 L_ADDRESS1='',
 L_ADDRESS2='',
 L_ADDRESS3='',
 L_CITY='',
 L_STATE='',
 L_ZIP='',
 MOBILE_PAGER='',
 RES_PHONE1='',
 RES_PHONE2='',
 OFF_PHONE1=''
FROM 
	BSEDB_AB.DBO.CMBILLVALAN C (NOLOCK),
	#PARTY P (NOLOCK)
WHERE 
	C.PARTY_CODE = P.PARTY_CODE
	AND SAUDA_DATE >= @FROMDATE
	AND SAUDA_DATE <= @TODATE + ' 23:59:59'
	AND C.SETT_TYPE = (CASE WHEN @SETT_TYPE = '%' THEN C.SETT_TYPE ELSE @SETT_TYPE END)
	AND C.SETT_TYPE NOT IN ('AC','AD')
GROUP BY                         
	P.PARENTCODE,                        
	CONVERT(VARCHAR,SAUDA_DATE,103),                        
	SCRIP_CD,                         
	SCRIP_NAME,                        
	SETT_NO,                        
	SETT_TYPE                        
HAVING                        
	SUM(PQTYDEL) - SUM(SQTYDEL) <> 0                         
	OR SUM(SAMTDEL)-SUM(PAMTDEL) <> 0                        
                        
UNION                        
                        
SELECT                         
 EXCHANGE = 'BSE CASH',                        
 TRDTYPE = '3. LEV',                         
 PARTY_CODE = P.PARENTCODE,                        
 TRADEDATE = CONVERT(VARCHAR,SAUDA_DATE,103),                        
 SCRIP_CD = 'ZZZZZZZZZZZZ',                         
SCRIP_NAME = '** LEVIES **',                        
 SETT_NO,                        
 SETT_TYPE,                        
 BUYQTY = 0,                         
 BUYAVGRATE = 0,                        
 BUYAMOUNT = 0,                         
 SELLQTY = 0,                        
 SELLAVGRATE = 0,                        
 SELLAMOUNT = 0,                        
 NETQTY = 0,                        
 NETAVGRATE = 0,                        
 NETAMT = (SUM(SERVICE_TAX) + SUM(TURN_TAX)  + SUM(SEBI_TAX) + SUM(INS_CHRG) + SUM(BROKER_CHRG) + SUM(OTHER_CHRG)) * -1,                        
 FLAG = 2,                        
 LONG_NAME='',
 BRANCH_CD='',
 SUB_BROKER='',
 L_ADDRESS1='',
 L_ADDRESS2='',
 L_ADDRESS3='',
 L_CITY='',
 L_STATE='',
 L_ZIP='',
 MOBILE_PAGER='',
 RES_PHONE1='',
 RES_PHONE2='',
 OFF_PHONE1=''
FROM 
	BSEDB_AB.DBO.CMBILLVALAN C (NOLOCK),
	#PARTY P (NOLOCK)
WHERE 
	C.PARTY_CODE = P.PARTY_CODE
	AND SAUDA_DATE >= @FROMDATE
	AND SAUDA_DATE <= @TODATE + ' 23:59:59'
	AND C.SETT_TYPE = (CASE WHEN @SETT_TYPE = '%' THEN C.SETT_TYPE ELSE @SETT_TYPE END)
	AND C.SETT_TYPE NOT IN ('AC','AD')
GROUP BY
	P.PARENTCODE,
	CONVERT(VARCHAR,SAUDA_DATE,103),                        
	SETT_NO,                        
	SETT_TYPE                        
                        
----------------------------                        
-- NOW STARTING NSE CASH --                        
----------------------------                        
                        
                        
INSERT INTO #CLASSTBL_SAUDASUMMARY                        
SELECT                         
 EXCHANGE = 'NSE CASH',                        
 TRDTYPE = '1. TRD',                        
 PARTY_CODE = P.PARENTCODE,                        
 TRADEDATE = CONVERT(VARCHAR,SAUDA_DATE,103),                        
 SCRIP_CD,                         
 SCRIP_NAME = SCRIP_CD + ' - ' + SERIES,                        
 SETT_NO,                        
 SETT_TYPE,                        
 BUYQTY = SUM(PQTYTRD),                         
 BUYAVGRATE = (CASE WHEN SUM(PQTYTRD) <> 0 THEN SUM(PAMTTRD) / SUM(PQTYTRD) ELSE 0 END),                        
 BUYAMOUNT = SUM(PAMTTRD),                         
 SELLQTY = SUM(SQTYTRD),                        
 SELLAVGRATE = (CASE WHEN SUM(SQTYTRD) <> 0 THEN SUM(SAMTTRD) / SUM(SQTYTRD) ELSE 0 END),                        
 SELLAMOUNT = SUM(SAMTTRD) ,                        
 NETQTY = SUM(PQTYTRD) - SUM(SQTYTRD),                        
 NETAVGRATE = (CASE WHEN (SUM(PQTYTRD) - SUM(SQTYTRD)) <> 0 THEN ABS((SUM(SAMTTRD)-SUM(PAMTTRD))/(SUM(PQTYTRD) - SUM(SQTYTRD))) ELSE 0 END),                        
 NETAMT = SUM(SAMTTRD)-SUM(PAMTTRD),                        
 FLAG = 1,
 LONG_NAME='',
 BRANCH_CD='',
 SUB_BROKER='',
 L_ADDRESS1='',
 L_ADDRESS2='',
 L_ADDRESS3='',
 L_CITY='',
 L_STATE='',
 L_ZIP='',
 MOBILE_PAGER='',
 RES_PHONE1='',
 RES_PHONE2='',
 OFF_PHONE1=''
FROM 
	AngelNseCM.MSAJAG.DBO.CMBILLVALAN C with (NOLOCK),                     
	#PARTY P (NOLOCK)
WHERE 
	C.PARTY_CODE = P.PARTY_CODE
	AND SAUDA_DATE >= @FROMDATE
	AND SAUDA_DATE <= @TODATE + ' 23:59:59'
	AND SETT_TYPE = (CASE WHEN @SETT_TYPE = '%' THEN C.SETT_TYPE ELSE @SETT_TYPE END)
	AND C.SETT_TYPE NOT IN ('A','X')
GROUP BY
	P.PARENTCODE,
	CONVERT(VARCHAR,SAUDA_DATE,103),                        
	SCRIP_CD,                         
	SERIES,                        
	SETT_NO,                        
	SETT_TYPE                        
HAVING                        
	SUM(PQTYTRD) - SUM(SQTYTRD) <> 0          
	OR SUM(SAMTTRD)-SUM(PAMTTRD) <> 0                        
                        
UNION                        
                        
SELECT                         
 EXCHANGE = 'NSE CASH',                        
 TRDTYPE = '2. DEL',                         
 PARTY_CODE = P.PARENTCODE,                        
 TRADEDATE = CONVERT(VARCHAR,SAUDA_DATE,103),                        
 SCRIP_CD,                         
 SCRIP_NAME = SCRIP_CD + ' - ' + SERIES + ' (DELIVERY)',                        
 SETT_NO,                        
 SETT_TYPE,                        
 BUYQTY = SUM(PQTYDEL),                         
 BUYAVGRATE = (CASE WHEN SUM(PQTYDEL) <> 0 THEN SUM(PAMTDEL) / SUM(PQTYDEL) ELSE 0 END),                        
 BUYAMOUNT = SUM(PAMTDEL),                         
 SELLQTY = SUM(SQTYDEL),                        
 SELLAVGRATE = (CASE WHEN SUM(SQTYDEL) <> 0 THEN SUM(SAMTDEL) / SUM(SQTYDEL) ELSE 0 END),                        
 SELLAMOUNT = SUM(SAMTDEL),                        
 NETQTY = SUM(PQTYDEL) - SUM(SQTYDEL),                        
 NETAVGRATE = (CASE WHEN (SUM(PQTYDEL) - SUM(SQTYDEL)) <> 0 THEN ABS((SUM(SAMTDEL)-SUM(PAMTDEL))/(SUM(PQTYDEL) - SUM(SQTYDEL))) ELSE 0 END),                        
 NETAMT = SUM(SAMTDEL)-SUM(PAMTDEL),                        
 FLAG = 1,
 LONG_NAME='',
 BRANCH_CD='',
 SUB_BROKER='',
 L_ADDRESS1='',
 L_ADDRESS2='',
 L_ADDRESS3='',
 L_CITY='',
 L_STATE='',
 L_ZIP='',
 MOBILE_PAGER='',
 RES_PHONE1='',
 RES_PHONE2='',
 OFF_PHONE1=''
FROM 
	AngelNseCM.MSAJAG.DBO.CMBILLVALAN C with(NOLOCK),
	#PARTY P (NOLOCK)
WHERE 
	C.PARTY_CODE = P.PARTY_CODE
	AND SAUDA_DATE >= @FROMDATE
	AND SAUDA_DATE <= @TODATE + ' 23:59:59'
	AND SETT_TYPE = (CASE WHEN @SETT_TYPE = '%' THEN C.SETT_TYPE ELSE @SETT_TYPE END)
	AND C.SETT_TYPE NOT IN ('A','X')
GROUP BY
	P.PARENTCODE,
	CONVERT(VARCHAR,SAUDA_DATE,103),                        
	SCRIP_CD,                         
	SERIES,                        
	SETT_NO,                        
	SETT_TYPE                        
HAVING                        
	SUM(PQTYDEL) - SUM(SQTYDEL) <> 0                         
	OR SUM(SAMTDEL)-SUM(PAMTDEL) <> 0                        

UNION                        
                        
SELECT                         
 EXCHANGE = 'NSE CASH',                        
 TRDTYPE = '3. LEV',                         
 PARTY_CODE = P.PARENTCODE,                        
 TRADEDATE = CONVERT(VARCHAR,SAUDA_DATE,103),                        
 SCRIP_CD = 'ZZZZZZZZZZZZ',                         
 SCRIP_NAME = '** LEVIES **',                        
 SETT_NO,                        
 SETT_TYPE,                        
 BUYQTY = 0,                         
 BUYAVGRATE = 0,                        
 BUYAMOUNT = 0,                         
 SELLQTY = 0,                        
 SELLAVGRATE = 0,                        
 SELLAMOUNT = 0,                        
 NETQTY = 0,                        
 NETAVGRATE = 0,                        
 NETAMT = (SUM(SERVICE_TAX) + SUM(TURN_TAX)  + SUM(SEBI_TAX) + SUM(INS_CHRG) + SUM(BROKER_CHRG) + SUM(OTHER_CHRG)) * -1,            
 FLAG = 2,
 LONG_NAME='',
 BRANCH_CD='',
 SUB_BROKER='',
 L_ADDRESS1='',
 L_ADDRESS2='',
 L_ADDRESS3='',
 L_CITY='',
 L_STATE='',
 L_ZIP='',
 MOBILE_PAGER='',
 RES_PHONE1='',
 RES_PHONE2='',
 OFF_PHONE1=''
FROM 
	AngelNseCM.MSAJAG.DBO.CMBILLVALAN C with (NOLOCK),
	#PARTY P (NOLOCK)
WHERE 
	C.PARTY_CODE = P.PARTY_CODE
	AND SAUDA_DATE >= @FROMDATE
	AND SAUDA_DATE <= @TODATE + ' 23:59:59'
	AND SETT_TYPE = (CASE WHEN @SETT_TYPE = '%' THEN C.SETT_TYPE ELSE @SETT_TYPE END)
	AND C.SETT_TYPE NOT IN ('A','X')
GROUP BY
	P.PARENTCODE,
	CONVERT(VARCHAR,SAUDA_DATE,103),                        
	SETT_NO,                        
	SETT_TYPE                                              

-------------------------------                        
-- COMPLETED CALCULATION --                        
-------------------------------                        
                    
UPDATE 
	#CLASSTBL_SAUDASUMMARY
SET 
	LONG_NAME	= C1.LONG_NAME,
	BRANCH_CD	= C1.BRANCH_CD,
	SUB_BROKER	= C1.SUB_BROKER,
	L_ADDRESS1	= C1.L_ADDRESS1,
	L_ADDRESS2	= C1.L_ADDRESS2,
	L_ADDRESS3	= C1.L_ADDRESS3,
	L_CITY		= C1.L_CITY,
	L_STATE		= C1.L_STATE,
	L_ZIP		= C1.L_ZIP,
	MOBILE_PAGER= C1.MOBILE_PAGER,
	RES_PHONE1	= C1.RES_PHONE1,
	RES_PHONE2	= C1.RES_PHONE2,
	OFF_PHONE1	= C1.OFF_PHONE1
FROM
	AngelBSECM.PRADNYA.DBO.TBL_ECNCASH C1 (NOLOCK)
WHERE
	#CLASSTBL_SAUDASUMMARY.PARTY_CODE = C1.PARTY_CODE


SELECT                         
	EXCHANGE,
	TRDTYPE,
	PARTY_CODE,
	TRADEDATE,
	SCRIP_CD,
	SCRIP_NAME,
	SETT_NO,
	SETT_TYPE,
	BUYQTY,
	BUYAVGRATE,
	BUYAMOUNT,
	SELLQTY,
	SELLAVGRATE,
	SELLAMOUNT,
	NETQTY,
	NETAVGRATE,
	NetAmount,
	FLAG,
	LONG_NAME,          
	BRANCH_CD,          
	SUB_BROKER,          
	L_ADDRESS1,          
	L_ADDRESS2,          
	L_ADDRESS3,          
	L_CITY,          
	L_STATE,          
	L_ZIP,          
	MOBILE_PAGER,          
	RES_PHONE1,          
	RES_PHONE2,          
	OFF_PHONE1          
FROM            
	#CLASSTBL_SAUDASUMMARY (NOLOCK)
ORDER BY                        
	PARTY_CODE,                        
	EXCHANGE,                        
	SETT_NO,                        
	SETT_TYPE,                        
	FLAG,                        
	SCRIP_NAME,                        
	TRDTYPE                        
                        
--TRUNCATE TABLE #CLASSTBL_SAUDASUMMARY        
                        
--DROP TABLE #CLASSTBL_SAUDASUMMARY

GO
