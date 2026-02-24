-- Object: PROCEDURE dbo.BBGCONFIRMATION_NSE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE BBGCONFIRMATION(                
  @SETT_NO VARCHAR(10), ---1 SETTLEMENT NO(FROM)                
  @TOSETT_NO VARCHAR(10), ---2 SETTLEMENT NO (TO)                
  @SETT_TYPE VARCHAR(3), ---3 SETTLEMENT TYPE                
  @SAUDA_DATE VARCHAR(11), ---4 SAUDA_DATE (FROM)                
  @TODATE VARCHAR(11), ---5 SAUDA_DATE (TO)                
  @FROMSCRIP VARCHAR(10), ---6 FROM SCRIP_CD (FROM)                
  @TOSCRIP VARCHAR(10), ---7 TO SCRIP_CD (TO)                
  @FROM VARCHAR(20), ---8 FROM CONSOL                
  @TO VARCHAR (20), ---9 TO CONSOL                
  @CONSOL VARCHAR(10), ---10 CONSOL INDICATES THAT WHETHER IS "PARTY_CODE","TRADER","SUB BROKER","BRANCH"                
  @DETAIL VARCHAR(3), ---11 THIS IS OTHER DETAILS IN QUERY "B" = "BILL","C" = "CONFIRMATION","P" = "POSITION","BR" = "BROKERAGE","S" = "SAUDA SUMMARY"                
  @LEVEL SMALLINT, --- 12 WILL BE USED TO SELECT LEVEL OF CONSOLIDATION DEFAULT 0                
  @GROUPF VARCHAR(500), ---13 (ANY NECESSARY GROUPING) THIS CAN BE DEFINED ON THE FLY BY DEVELOPER                
  @ORDERF VARCHAR(500), ---14 (ANY NECESSARY ORDER BY) THIS CAN DE DEFINED ON THE FLY BY DEVELOPER                
  @USE1 VARCHAR(10), --- 15 TO BE USED LATER FOR OTHER PURPOSES                
  @STATUSID VARCHAR(15),                
  @STATUSNAME VARCHAR(25)                 
)                
                
                
AS                
DECLARE                
 @@GETSTYLE AS CURSOR,                
 @@SETT_NO AS VARCHAR(10),                
 @@FROMPARTY_CODE AS VARCHAR(10),                
 @@TOPARTY_CODE AS VARCHAR(10),                
 @@FROMSETT_TYPE AS VARCHAR(3),                
 @@TOSETT_TYPE AS VARCHAR(3),                
 @@MYQUERY AS VARCHAR(4000),                
 @@MYREPORT AS VARCHAR(50),                
 @@MYORDER AS VARCHAR(1500),                
 @@MYGROUP AS VARCHAR(1500),                
 @@PART AS VARCHAR(8000),                
 @@PART1 AS VARCHAR(8000),                
 @@PART2 AS VARCHAR(8000),                
 @@PART3 AS VARCHAR(8000),                
 @@PART4 AS VARCHAR(8000),                
 @@PART5 AS VARCHAR(8000),                
 @@PART6 AS VARCHAR(8000),                
 @@WISEREPORT AS VARCHAR(10),                
 @@DUMMY1 AS VARCHAR(1000),                
 @@DUMMY2 AS VARCHAR(1000),                
 @@FROMREGION AS VARCHAR(10),                
 @@TOREGION AS VARCHAR(10),                
 @@FROMFAMILY AS VARCHAR(10),                
 @@TOFAMILY AS VARCHAR(10),                
 @@FROMBRANCH_CD AS VARCHAR(15),                
 @@TOBRANCH_CD AS VARCHAR(15),                
 @@FROMSUB_BROKER AS VARCHAR(15),                
 @@TOSUB_BROKER AS VARCHAR(15),                
 @@FROMTRADER AS VARCHAR(15),                
 @@TOTRADER AS VARCHAR(15),                
 @@DUMMY3 AS VARCHAR(1000),                
 @@FROMTABLE AS VARCHAR(1000), -------------------- THIS STRING WILL ENABLE US TO CODE CONDITIONS LIKE FROM SETTLEMENT                
 @@SELECTFLEX AS VARCHAR (2000), --------------------- THIS STRING WILL ENABLE US TO CODE FLEXIBLE SELECT CONDITIONS                
 @@SELECTFLEX1 AS VARCHAR (2000), --------------------- THIS STRING WILL ENABLE US TO CODE FLEXIBLE SELECT CONDITIONS                
 @@SELECTBODY AS VARCHAR(8000), --------------------- THIS IS REGULAR SELECT BODY                
 @@SELECTBODY1 AS VARCHAR(8000), --------------------- THIS IS REGULAR SELECT BODY                
 @@WHERETEXT AS VARCHAR(8000), --------------------- THIS WILL BE USED FOR CODING WHERE CONDITION                
 @@FROMTABLE1 AS VARCHAR(1000), --------------------- THIS IS ANOTHER STRING THAT CAN BE USED FOR                
 @@WHERECOND1 AS VARCHAR(2000)                
                
                
IF ((@CONSOL = "PARTY_CODE" OR @CONSOL = "BROKER")) AND ((@FROM <> "") AND (@TO = "" ) )                
BEGIN                
 SELECT @@FROMPARTY_CODE = @FROM                
SELECT @@TOPARTY_CODE = @FROM                
END                
                
                
IF ((@CONSOL = "PARTY_CODE" OR @CONSOL = "BROKER")) AND ((@FROM <> "") AND (@TO <> "" ) )                
BEGIN                
 SELECT @@FROMPARTY_CODE = @FROM                
 SELECT @@TOPARTY_CODE = @TO                
END                
                
                
IF (@CONSOL = "FAMILY") AND ((@FROM <> "") AND (@TO <> "" ) )                
BEGIN                
 SELECT @@FROMFAMILY = @FROM                
 SELECT @@TOFAMILY = @TO                
 SELECT @@FROMPARTY_CODE = MIN(PARTY_CODE) , @@TOPARTY_CODE = MAX(PARTY_CODE) FROM CLIENT2, CLIENT1 WHERE CLIENT2.CL_CODE = CLIENT1.CL_CODE AND CLIENT1.FAMILY BETWEEN @@FROMFAMILY AND @@TOFAMILY                
END                
ELSE IF (@CONSOL = "FAMILY") AND ((@FROM = "") AND (@TO = "" ) )                
BEGIN                
 SELECT @@FROMPARTY_CODE = MIN(PARTY_CODE) , @@TOPARTY_CODE = MAX(PARTY_CODE), @@FROMFAMILY = MIN(FAMILY) , @@TOFAMILY = MAX(FAMILY) FROM CLIENT2, CLIENT1 WHERE CLIENT2.CL_CODE = CLIENT1.CL_CODE                
END                
                
IF (@CONSOL = "BRANCH_CD") AND ((@FROM <> "") AND (@TO <> "" ) )                
BEGIN                
 SELECT @@FROMBRANCH_CD = @FROM                
 SELECT @@TOBRANCH_CD = @TO                
 SELECT @@FROMPARTY_CODE = MIN(PARTY_CODE) , @@TOPARTY_CODE = MAX(PARTY_CODE) FROM CLIENT2, CLIENT1 WHERE CLIENT2.CL_CODE = CLIENT1.CL_CODE AND CLIENT1.BRANCH_CD BETWEEN @@FROMBRANCH_CD AND @@TOBRANCH_CD                
END                
ELSE IF (@CONSOL = "BRANCH_CD") AND ((@FROM = "") AND (@TO = "" ) )                
BEGIN                
 SELECT @@FROMPARTY_CODE = MIN(PARTY_CODE) , @@TOPARTY_CODE = MAX(PARTY_CODE),@@FROMBRANCH_CD = MIN(BRANCH_CD), @@TOBRANCH_CD = MAX(BRANCH_CD) FROM CLIENT2, CLIENT1 WHERE CLIENT2.CL_CODE = CLIENT1.CL_CODE                
END                
                
IF (@CONSOL = "TRADER") AND ((@FROM <> "") AND (@TO <> "" ) )                
BEGIN                
 SELECT @@FROMTRADER = @FROM                
 SELECT @@TOTRADER = @TO                
 SELECT @@FROMPARTY_CODE = MIN(PARTY_CODE) , @@TOPARTY_CODE = MAX(PARTY_CODE) FROM CLIENT2, CLIENT1 WHERE CLIENT2.CL_CODE = CLIENT1.CL_CODE AND CLIENT1.TRADER BETWEEN @@FROMTRADER AND @@TOTRADER                
END                
ELSE IF (@CONSOL = "TRADER") AND ( ( @FROM = "" ) AND ( @TO = "" ) )                
BEGIN                
 SELECT @@FROMPARTY_CODE = MIN(PARTY_CODE) , @@TOPARTY_CODE = MAX(PARTY_CODE), @@FROMTRADER=MIN(TRADER),@@TOTRADER=MAX(TRADER) FROM CLIENT2, CLIENT1 WHERE CLIENT2.CL_CODE = CLIENT1.CL_CODE                
END                
                
IF (@CONSOL = "SUB_BROKER") AND ((@FROM <> "") AND (@TO <> "" ) )                
BEGIN                
 SELECT @@FROMSUB_BROKER = @FROM                
 SELECT @@TOSUB_BROKER = @TO                
 SELECT @@FROMPARTY_CODE = MIN(PARTY_CODE) , @@TOPARTY_CODE = MAX(PARTY_CODE) FROM CLIENT2, CLIENT1 WHERE CLIENT2.CL_CODE = CLIENT1.CL_CODE AND CLIENT1.SUB_BROKER BETWEEN @@FROMSUB_BROKER AND @@TOSUB_BROKER                
END                
ELSE IF (@CONSOL = "SUB_BROKER") AND ( ( @FROM = "" ) AND ( @TO = "" ) )                
BEGIN                
 SELECT @@FROMPARTY_CODE = MIN(PARTY_CODE) , @@TOPARTY_CODE = MAX(PARTY_CODE), @@FROMSUB_BROKER=MIN(SUB_BROKER),@@TOSUB_BROKER=MAX(SUB_BROKER) FROM CLIENT2, CLIENT1 WHERE CLIENT2.CL_CODE = CLIENT1.CL_CODE                
END                
                
                
IF ( (@CONSOL = "PARTY_CODE" OR @CONSOL = "BROKER")) AND ( ( @FROM = "" ) AND ( @TO = "" ) )                
BEGIN                
 SELECT @@TOPARTY_CODE = MAX(PARTY_CODE) ,@@FROMPARTY_CODE = MIN(PARTY_CODE) FROM DETAILS                
END                
                
                
IF (@CONSOL = "REGION") AND ( ( @FROM = "" ) AND ( @TO = "" ) )                
BEGIN                
 SELECT @@FROMPARTY_CODE = MIN(PARTY_CODE) , @@TOPARTY_CODE = MAX(PARTY_CODE), @@FROMREGION=MIN(REGION),@@TOREGION = MAX(REGION) FROM CMBILLVALAN                
END                
                
                
IF (@CONSOL = "REGION") AND ( ( @FROM <> "" ) AND ( @TO <> "" ) )                
BEGIN                
 SET @@FROMREGION = @FROM                
 SET @@TOREGION = @TO                
 SELECT @@FROMPARTY_CODE = MIN(PARTY_CODE) , @@TOPARTY_CODE = MAX(PARTY_CODE) FROM CMBILLVALAN WHERE REGION BETWEEN @@FROMREGION AND @@TOREGION                
END                
                
-----------------------------------------------------------------------------------------                
                
IF @SETT_TYPE <> "%"                
BEGIN                
 SELECT @@FROMSETT_TYPE = @SETT_TYPE                
 SELECT @@TOSETT_TYPE = @SETT_TYPE                
END                
                
                
IF @SETT_TYPE = "%"                
BEGIN                
 SELECT @@FROMSETT_TYPE = MIN(SETT_TYPE), @@TOSETT_TYPE = MAX(SETT_TYPE) FROM DETAILS                
END                
                
-----------------------------------------------------------------------------------------                
                
IF ( (@FROMSCRIP = "") AND (@TOSCRIP = "") )                
 SELECT @FROMSCRIP = MIN(BSECODE) ,@TOSCRIP = MAX(BSECODE) FROM SCRIP2                
                
IF (@FROMSCRIP = "")                
 SELECT @FROMSCRIP = MIN(BSECODE) FROM SCRIP2                
                
IF (@TOSCRIP = "")                
 SELECT @TOSCRIP = MAX(BSECODE) FROM SCRIP2                
                
-----------------------------------------------------------------------------------------                
                
IF @TOSETT_NO = ""                
 SET @TOSETT_NO = @SETT_NO                
                
SELECT @SAUDA_DATE = LTRIM(RTRIM(@SAUDA_DATE))                
                
IF LEN(@SAUDA_DATE) = 10                
BEGIN                
 SET @SAUDA_DATE = STUFF(@SAUDA_DATE, 4, 1," ")                
END                
                
SELECT @TODATE = LTRIM(RTRIM(@TODATE))                
                
IF LEN(@TODATE) = 10                
BEGIN                
 SET @TODATE = STUFF(@TODATE, 4, 1," ")                
END                
                
--------------------------------------------------- FIND SAUDADATE FROM TO FROM SETTLEMENT RANGE -------------------------------------------------------------------------------------------------------                
                
IF ( @TODATE = "" )                
BEGIN                
 SELECT @TODATE = END_DATE FROM SETT_MST WHERE SETT_TYPE = @SETT_TYPE AND SETT_NO = @TOSETT_NO                
END                
                
IF ( @SAUDA_DATE = "" )                
BEGIN                
 SELECT @SAUDA_DATE = START_DATE FROM SETT_MST WHERE SETT_TYPE = @SETT_TYPE AND SETT_NO = @SETT_NO                
END                
                
----------------------------------------------------FIND SETTNO FROM TO FROM SAUDA_DATE RANGE -------------------------------------------------------------------------------------------------------                
                
IF ( (@SETT_NO = "" ) AND ( LEN(@SAUDA_DATE) > 1))                
BEGIN                
 SELECT @SETT_NO = MIN(SETT_NO) FROM SETT_MST WHERE SETT_TYPE BETWEEN @@FROMSETT_TYPE AND @@TOSETT_TYPE AND START_DATE < @TODATE + " 00:01" AND END_DATE >= @SAUDA_DATE + " 23:58:59"                
 IF @TODATE = ""                
 SET @TOSETT_NO = @SETT_NO                
END                 
                
IF ( (@TOSETT_NO = "" ) AND ( LEN(@TODATE) > 1))                
BEGIN                
 SELECT @TOSETT_NO = MAX(SETT_NO) FROM SETT_MST WHERE SETT_TYPE BETWEEN @@FROMSETT_TYPE AND @@TOSETT_TYPE AND START_DATE < @TODATE + " 00:01" AND END_DATE >= @SAUDA_DATE + " 23:58:59"                
END                
-----------------------------------------------------------------------------------------                
                
IF @DETAIL = "C"                
 SET @@MYREPORT = "CONFIRMATION"                
                
IF @ORDERF = "0" ------------------------------ TO BE USED FOR CONTRACT / BILL PRINTING ------------------------                
BEGIN                
 IF @CONSOL = "PARTY_CODE"                
 SET @@MYORDER = " ORDER BY S.PARTY_CODE, S.CONTRACTNO,S.SETT_NO, S.SETT_TYPE, S.SCRIP_CD ASC, S.SERIES, TRADETYP , BILLNO, CONTRACTNO, S.SAUDA_DATE OPTION (FAST 10 ) "                
END                
                
IF @ORDERF = "1" ------------------------ TO BE USED FOR GROSS POSITION ACROSS RANGE ----------------------                
BEGIN                
 IF @CONSOL = "REGION"                
 SET @@MYORDER = " ORDER BY REGION ,S.PARTY_CODE,SETT_NO,SETT_TYPE,CONTRACTNO,SCRIP2.BSECODE,SERIES,SELL_BUY,SAUDA_DATE,TRADEQTY OPTION (FAST 1 ) "                
 IF @CONSOL = "PARTY_CODE"                
 SET @@MYORDER = " ORDER BY S.PARTY_CODE,SETT_NO,SETT_TYPE,CONTRACTNO,SCRIP2.BSECODE,SERIES,SELL_BUY,SAUDA_DATE,TRADEQTY OPTION (FAST 1 ) "                
 IF @CONSOL = "BRANCH_CD"                
 SET @@MYORDER = " ORDER BY BRANCH_CD, S.PARTY_CODE,SETT_NO,SETT_TYPE,CONTRACTNO,SCRIP2.BSECODE,SERIES,SELL_BUY,SAUDA_DATE,TRADEQTY OPTION (FAST 1 ) "                
 IF @CONSOL = "FAMILY"                
 SET @@MYORDER = " ORDER BY FAMILY,S.PARTY_CODE,SETT_NO,SETT_TYPE,CONTRACTNO,SCRIP2.BSECODE,SERIES,SELL_BUY,SAUDA_DATE,TRADEQTY OPTION (FAST 1 ) "                
 IF @CONSOL = "TRADER"                
 SET @@MYORDER = " ORDER BY TRADER,S.PARTY_CODE,SETT_NO,SETT_TYPE,CONTRACTNO,SCRIP2.BSECODE,SERIES,SELL_BUY,SAUDA_DATE,TRADEQTY OPTION (FAST 1 ) "                
 IF @CONSOL = "SUB_BROKER"                
 SET @@MYORDER = " ORDER BY SUB_BROKER,S.PARTY_CODE,SETT_NO,SETT_TYPE,CONTRACTNO,SCRIP2.BSECODE,SERIES,SELL_BUY,SAUDA_DATE,TRADEQTY OPTION (FAST 1 ) "                
END                
                
                
IF @ORDERF = "1.1" ------------------------ TO BE USED FOR GROSS POSITION ACROSS RANGE ----------------------                
BEGIN                
 IF @CONSOL = "REGION"                
 SET @@MYORDER = " ORDER BY S.SCRIP_CD, S.SERIES, REGION OPTION (FAST 1 ) "                
 IF @CONSOL = "PARTY_CODE"               
 SET @@MYORDER = " ORDER BY S.SCRIP_CD, S.SERIES, PARTY_CODE OPTION (FAST 1 ) "                
 IF @CONSOL = "BRANCH_CD"                
 SET @@MYORDER = " ORDER BY S.SCRIP_CD, S.SERIES, BRANCH_CD OPTION (FAST 1 ) "                
 IF @CONSOL = "FAMILY"                
 SET @@MYORDER = " ORDER BY S.SCRIP_CD, S.SERIES, FAMILY OPTION (FAST 1 ) "                
 IF @CONSOL = "TRADER"                
 SET @@MYORDER = " ORDER BY S.SCRIP_CD, S.SERIES, TRADER OPTION (FAST 1 ) "                
 IF @CONSOL = "SUB_BROKER"                
 SET @@MYORDER = " ORDER BY S.SCRIP_CD, S.SERIES, SUB_BROKER OPTION (FAST 1 ) "                
END                
                
                
                
IF @ORDERF = "2" ------------------------ TO BE USED FOR NET POSITION ACROSS SETTLEMENT ----------------------                
BEGIN                
 IF @CONSOL = "REGION"                
 SET @@MYORDER = " ORDER BY S.SETT_NO,S.SETT_TYPE OPTION (FAST 1 ) "                
 IF @CONSOL = "PARTY_CODE"                
 SET @@MYORDER = " ORDER BY S.SETT_NO,S.SETT_TYPE OPTION (FAST 1 ) "                
 IF @CONSOL = "BRANCH_CD"                
 SET @@MYORDER = " ORDER BY S.SETT_NO,S.SETT_TYPE OPTION (FAST 1 ) "                
 IF @CONSOL = "FAMILY"                
 SET @@MYORDER = " ORDER BY S.SETT_NO,S.SETT_TYPE OPTION (FAST 1 ) "                
 IF @CONSOL = "TRADER"                
 SET @@MYORDER = " ORDER BY S.SETT_NO,S.SETT_TYPE OPTION (FAST 1 ) "                
 IF @CONSOL = "SUB_BROKER"                
 SET @@MYORDER = " ORDER BY S.SETT_NO,S.SETT_TYPE OPTION (FAST 1 )"                
END                
                
                
IF @ORDERF = "3" ------------------------ TO BE USED FOR NET POSITION ACROSS SETTLEMENT,SCRIP,SERIES ----------------------                
BEGIN                
 IF @CONSOL = "REGION"                
 SET @@MYORDER = " ORDER BY S.SCRIP_CD ,S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "PARTY_CODE"                
 SET @@MYORDER = " ORDER BY S.SCRIP_CD ,S.SERIES OPTION (FAST 1 ) "                
IF @CONSOL = "BRANCH_CD"                
 SET @@MYORDER = " ORDER BY S.SCRIP_CD ,S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "FAMILY"                
 SET @@MYORDER = " ORDER BY S.SCRIP_CD ,S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "TRADER"                
 SET @@MYORDER = " ORDER BY S.SCRIP_CD ,S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "SUB_BROKER"                
 SET @@MYORDER = " ORDER BY S.SCRIP_CD ,S.SERIES OPTION (FAST 1 )"                
END                
                
                
                
IF @ORDERF = "3.1" ------------------------ TO BE USED FOR NET POSITION ACROSS SETTLEMENT,SCRIP,SERIES,TMARK ----------------------                
BEGIN                
 IF @CONSOL = "REGION"                
 SET @@MYORDER = " ORDER BY REGION , S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD, S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "PARTY_CODE"                
 SET @@MYORDER = " ORDER BY S.PARTY_CODE , S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD, S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "BRANCH_CD"                
 SET @@MYORDER = " ORDER BY BRANCH_CD ,S.SETT_NO,S.SETT_TYPE ,S.SCRIP_CD , S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "FAMILY"                
 SET @@MYORDER = " ORDER BY FAMILY , S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD, S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "TRADER"                
 SET @@MYORDER = " ORDER BY TRADER , S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD, S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "SUB_BROKER"                
 SET @@MYORDER = " ORDER BY SUB_BROKER , S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD, S.SERIES OPTION (FAST 1 )"                
END                
                
                
                
IF @ORDERF = "3.11" ------------------------ TO BE USED FOR NET POSITION ACROSS SETTLEMENT,SCRIP,SERIES,TMARK ----------------------                
BEGIN                
 IF @CONSOL = "REGION"                
 SET @@MYORDER = " ORDER BY REGION,S.PARTY_CODE OPTION (FAST 1 ) "                
 IF @CONSOL = "PARTY_CODE"                
 SET @@MYORDER = " ORDER BY S.PARTY_CODE OPTION (FAST 1 ) "                
 IF @CONSOL = "BRANCH_CD"                
 SET @@MYORDER = " ORDER BY BRANCH_CD ,S.PARTY_CODE OPTION (FAST 1 ) "                
 IF @CONSOL = "FAMILY"                
 SET @@MYORDER = " ORDER BY FAMILY , S.PARTY_CODE OPTION (FAST 1 ) "                
 IF @CONSOL = "TRADER"                
 SET @@MYORDER = " ORDER BY TRADER , S.PARTY_CODE OPTION (FAST 1 ) "                
 IF @CONSOL = "SUB_BROKER"                
 SET @@MYORDER = " ORDER BY SUB_BROKER , S.PARTY_CODE OPTION (FAST 1 )"                
END                
                
                
                
IF @ORDERF = "3.2" ------------------------ TO BE USED FOR NET POSITION ACROSS SETTLEMENT,SCRIP,SERIES,TMARK ----------------------                
BEGIN                
 IF @CONSOL = "REGION"                
 SET @@MYORDER = " ORDER BY REGION , S.SAUDA_DATE ,S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD, S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "PARTY_CODE"                
 SET @@MYORDER = " ORDER BY S.PARTY_CODE , S.SAUDA_DATE ,S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD, S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "BRANCH_CD"                
 SET @@MYORDER = " ORDER BY BRANCH_CD ,S.SAUDA_DATE ,S.SETT_NO,S.SETT_TYPE ,S.SCRIP_CD , S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "FAMILY"                
 SET @@MYORDER = " ORDER BY FAMILY , S.SAUDA_DATE ,S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD, S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "TRADER"                
 SET @@MYORDER = " ORDER BY TRADER , S.SAUDA_DATE ,S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD, S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "SUB_BROKER"                
 SET @@MYORDER = " ORDER BY SUB_BROKER , S.SAUDA_DATE ,S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD, S.SERIES OPTION (FAST 1 )"                
END                
                
                
                
IF @ORDERF = "3.3" ------------------------ TO BE USED FOR NET POSITION ACROSS SETTLEMENT,SCRIP,SERIES,TMARK ----------------------                
BEGIN                
 IF @CONSOL = "REGION"                
 SET @@MYORDER = " ORDER BY REGION ,S.SCRIP_CD, S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "PARTY_CODE"                
 SET @@MYORDER = " ORDER BY S.PARTY_CODE ,S.SCRIP_CD, S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "BRANCH_CD"                
 SET @@MYORDER = " ORDER BY BRANCH_CD ,S.SCRIP_CD , S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "FAMILY"                
 SET @@MYORDER = " ORDER BY FAMILY , S.SCRIP_CD, S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "TRADER"                
 SET @@MYORDER = " ORDER BY TRADER , S.SCRIP_CD, S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "SUB_BROKER"                
 SET @@MYORDER = " ORDER BY SUB_BROKER , S.SCRIP_CD, S.SERIES OPTION (FAST 1 )"                
END                
                
                
                
IF @ORDERF = "3.4" ------------------------ TO BE USED FOR NET POSITION ACROSS SETTLEMENT,SCRIP,SERIES,TMARK ----------------------                
BEGIN                
 IF @CONSOL = "REGION"                
 SET @@MYORDER = " ORDER BY S.SETT_NO,S.SETT_TYPE ,S.SCRIP_CD, S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "PARTY_CODE"                
 SET @@MYORDER = " ORDER BY S.SETT_NO,S.SETT_TYPE ,S.SCRIP_CD, S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "BRANCH_CD"                
 SET @@MYORDER = " ORDER BY S.SETT_NO,S.SETT_TYPE ,S.SCRIP_CD , S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "FAMILY"                
 SET @@MYORDER = " ORDER BYS.SETT_NO,S.SETT_TYPE , S.SCRIP_CD, S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "TRADER"                
 SET @@MYORDER = " ORDER BY S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD, S.SERIES OPTION (FAST 1 ) "                
 IF @CONSOL = "SUB_BROKER"                
 SET @@MYORDER = " ORDER BY S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD, S.SERIES OPTION (FAST 1 )"                
END                
                
                
                
IF @ORDERF = "4" ------------------------ TO BE USED FOR NET POSITION ACROSS SETTLEMENT,SCRIP,SERIES,SAUDA_DATE,TMARK ----------------------                
BEGIN         
 IF @CONSOL = "REGION"                
 SET @@MYORDER = " ORDER BY S.SAUDA_DATE , S.SETT_NO,S.SETT_TYPE OPTION (FAST 1 ) "                
 IF @CONSOL = "PARTY_CODE"                
 SET @@MYORDER = " ORDER BY S.SAUDA_DATE , S.SETT_NO,S.SETT_TYPE OPTION (FAST 1 ) "                
 IF @CONSOL = "BRANCH_CD"                
 SET @@MYORDER = " ORDER BY S.SAUDA_DATE , S.SETT_NO,S.SETT_TYPE OPTION (FAST 1 ) "                
 IF @CONSOL = "FAMILY"                
 SET @@MYORDER = " ORDER BY S.SAUDA_DATE , S.SETT_NO,S.SETT_TYPE OPTION (FAST 1 ) "                
 IF @CONSOL = "TRADER"                
 SET @@MYORDER = " ORDER BY S.SAUDA_DATE , S.SETT_NO,S.SETT_TYPE OPTION (FAST 1 ) "                
 IF @CONSOL = "SUB_BROKER"                
 SET @@MYORDER = " ORDER BY S.SAUDA_DATE , S.SETT_NO,S.SETT_TYPE OPTION (FAST 1 ) "                
END                
                
                
                
IF @ORDERF = "4.1" ------------------------ TO BE USED FOR NET POSITION ACROSS SETTLEMENT,SCRIP,SERIES,SAUDA_DATE,TMARK ----------------------                
BEGIN                
 IF @CONSOL = "REGION"                
 SET @@MYORDER = " ORDER BY REGION , S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD,S.SERIES , S.SAUDA_DATE OPTION (FAST 1 ) "                
 IF @CONSOL = "PARTY_CODE"                
 SET @@MYORDER = " ORDER BY S.PARTY_CODE , S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD,S.SERIES , S.SAUDA_DATE OPTION (FAST 1 ) "                
 IF @CONSOL = "BRANCH_CD"                
 SET @@MYORDER = " ORDER BY BRANCH_CD ,S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD,S.SERIES,S.SAUDA_DATE OPTION (FAST 1 ) "                
 IF @CONSOL = "FAMILY"                
 SET @@MYORDER = " ORDER BY FAMILY ,S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD,S.SERIES , S.SAUDA_DATE OPTION (FAST 1 ) "                
 IF @CONSOL = "TRADER"                
 SET @@MYORDER = " ORDER BY TRADER , S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD,S.SERIES, S.SAUDA_DATE OPTION (FAST 1 ) "                
 IF @CONSOL = "SUB_BROKER"                
 SET @@MYORDER = " ORDER BY SUB_BROKER , S.SETT_NO,S.SETT_TYPE , S.SCRIP_CD,S.SERIES ,S.SAUDA_DATE OPTION (FAST 1 ) "                
END                
                
SET @@WHERETEXT = ""                
SET @@WHERETEXT = @@WHERETEXT + " AND S.SAUDA_DATE BETWEEN '" + @SAUDA_DATE + " 00:00:00'"                
SET @@WHERETEXT = @@WHERETEXT + " AND '" + @TODATE + " 23:59:00'"                
SET @@WHERETEXT = @@WHERETEXT + " AND S.SCRIP_CD BETWEEN '" + @FROMSCRIP + "'"                
SET @@WHERETEXT = @@WHERETEXT + " AND '"+ @TOSCRIP + "'"                
SET @@WHERETEXT = @@WHERETEXT + " AND S.SETT_NO BETWEEN '" + @SETT_NO + "'"                
SET @@WHERETEXT = @@WHERETEXT + " AND '" + @TOSETT_NO +"' AND "                
                
--------------------------- NOW WE WILL DECIDE ABOUT JOIN WE WILL ALWAYS PROVIDE FROM PARTY AND TOPARTY -------------------------------------------                
SET @@WHERETEXT = @@WHERETEXT + " S.PARTY_CODE BETWEEN '" + @@FROMPARTY_CODE + "' AND '" + @@TOPARTY_CODE +"' "                
IF @CONSOL = "REGION"                
 SET @@WHERETEXT = @@WHERETEXT + " AND REGION BETWEEN '" + @@FROMREGION + "' AND '" + @@TOREGION +"' "                
IF @CONSOL = "FAMILY"                
 SET @@WHERETEXT = @@WHERETEXT + " AND FAMILY BETWEEN '" + @@FROMFAMILY + "' AND '" + @@TOFAMILY +"' "                
IF @CONSOL = "TRADER"                
 SET @@WHERETEXT = @@WHERETEXT + " AND TRADER BETWEEN '" + @@FROMTRADER + "' AND '" + @@TOTRADER +"' "                
IF @CONSOL = "BRANCH_CD"                
 SET @@WHERETEXT = @@WHERETEXT + " AND BRANCH_CD BETWEEN '" + @@FROMBRANCH_CD + "' AND '" + @@TOBRANCH_CD +"' "                
IF @CONSOL = "SUB_BROKER"                
 SET @@WHERETEXT = @@WHERETEXT + " AND SUB_BROKER BETWEEN '" + @@FROMSUB_BROKER + "' AND '" + @@TOSUB_BROKER +"' "                
                
              
                
------------------------- ADDED FOR ACCESS CONTROL AS PER USER LOGIN STATUS ---------------------------------------------------------------------------------------------                
                
IF @STATUSID = "FAMILY"                
BEGIN                
 SET @@WHERETEXT = @@WHERETEXT + " AND FAMILY BETWEEN '" + @STATUSNAME + "' AND '" + @STATUSNAME +"' "                
END                
                
IF @STATUSID = "TRADER"                
BEGIN                
 SET @@WHERETEXT = @@WHERETEXT + " AND TRADER BETWEEN '" + @STATUSNAME + "' AND '" + @STATUSNAME +"' "                
END                
                
IF @STATUSID = "BRANCH"                
BEGIN                
 SET @@WHERETEXT = @@WHERETEXT + " AND BRANCH_CD BETWEEN '" + @STATUSNAME + "' AND '" + @STATUSNAME +"' "                
END                
                
IF @STATUSID = "SUBBROKER"                
BEGIN                
 SET @@WHERETEXT = @@WHERETEXT + " AND SUB_BROKER BETWEEN '" + @STATUSNAME + "' AND '" + @STATUSNAME +"' "                
END                
                
IF @STATUSID = "PARTY"                
BEGIN                
 SET @@WHERETEXT = @@WHERETEXT + " AND PARTY_CODE BETWEEN '" + @STATUSNAME + "' AND '" + @STATUSNAME +"' "                
END                
                
IF @STATUSID = "CLIENT"                
BEGIN                
 SET @@WHERETEXT = @@WHERETEXT + " AND S.PARTY_CODE BETWEEN '" + @STATUSNAME + "' AND '" + @STATUSNAME +"' "                
END                
                
              
SET @@SELECTFLEX = " SELECT S.PARTY_CODE, FAMILY,TRADER,BRANCH_CD,SUB_BROKER,CONTRACTNO,C1.LONG_NAME,RES_PHONE1,SCRIP2.BSECODE,SERIES = SCRIP1.SHORT_NAME,TRADE_NO,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),SAUDA_DATE,USER_ID ,SETT_NO,SETT_TYPE,MARKETRATE,BROKAPPLIED,NBROKAPP,TRADEQTY,SELL_BUY, "                
SET @@SELECTFLEX = @@SELECTFLEX + " NETRATE = ( CASE WHEN SELL_BUY = 1 THEN MARKETRATE + BROKAPPLIED ELSE MARKETRATE - BROKAPPLIED END), NETAMOUNT = TRADEQTY * ( CASE WHEN SELL_BUY = 1 THEN MARKETRATE + BROKAPPLIED ELSE MARKETRATE - BROKAPPLIED END),"    
  
    
      
        
          
            
SET @@SELECTFLEX = @@SELECTFLEX + " N_NETRATE = ( CASE WHEN SELL_BUY = 1 THEN MARKETRATE + NBROKAPP ELSE MARKETRATE - NBROKAPP END) ,N_NETAMOUNT = TRADEQTY * ( CASE WHEN SELL_BUY = 1 THEN MARKETRATE + NBROKAPP ELSE MARKETRATE - NBROKAPP END),SERVICE_TAX = SERVICE_TAX ,NSERTAX = NSERTAX " + " , SORIS = 'S',BRANCH_ID = BRANCH_ID "                
SET @@SELECTFLEX = @@SELECTFLEX + " FROM SETTLEMENT S,CLIENT1 C1 ,CLIENT2 C2 ,SCRIP1,SCRIP2 WHERE S.PARTY_CODE = C2.PARTY_CODE AND C2.CL_CODE = C1.CL_CODE AND TRADEQTY > 0 AND S.SCRIP_CD = SCRIP2.BSECODE AND SCRIP1.CO_CODE = SCRIP2.CO_CODE AND S.AUCTIONPART NOT LIKE 'A%' AND S.AUCTIONPART NOT LIKE 'F%'"                
SET @@SELECTFLEX1 = " UNION ALL SELECT S.PARTY_CODE,FAMILY,TRADER,SUB_BROKER,BRANCH_CD,CONTRACTNO,C1.LONG_NAME,RES_PHONE1,SCRIP2.BSECODE,SERIES = SCRIP1.SHORT_NAME,TRADE_NO,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),SAUDA_DATE,USER_ID ,SETT_NO,SETT_TYPE,MARKETRATE,BROKAPPLIED,NBROKAPP,TRADEQTY,SELL_BUY, "                
SET @@SELECTFLEX1 = @@SELECTFLEX1 + " NETRATE = ( CASE WHEN SELL_BUY = 1 THEN MARKETRATE + BROKAPPLIED ELSE MARKETRATE - BROKAPPLIED END), NETAMOUNT = TRADEQTY * ( CASE WHEN SELL_BUY = 1 THEN MARKETRATE + BROKAPPLIED ELSE MARKETRATE - BROKAPPLIED END), " 
  
    
      
        
          
            
              
SET @@SELECTFLEX1 = @@SELECTFLEX1+ " N_NETRATE = ( CASE WHEN SELL_BUY = 1 THEN MARKETRATE + NBROKAPP ELSE MARKETRATE - NBROKAPP END) ,N_NETAMOUNT = TRADEQTY * ( CASE WHEN SELL_BUY = 1 THEN MARKETRATE + NBROKAPP ELSE MARKETRATE - NBROKAPP END),SERVICE_TAX = SERVICE_TAX ,NSERTAX = NSERTAX " + ", SORIS = 'IS',BRANCH_ID = BRANCH_ID "                
SET @@SELECTFLEX1 = @@SELECTFLEX1 + " FROM ISETTLEMENT S,CLIENT1 C1 ,CLIENT2 C2 , SCRIP1, SCRIP2 WHERE S.PARTY_CODE = C2.PARTY_CODE AND C2.CL_CODE = C1.CL_CODE AND TRADEQTY > 0 AND S.SCRIP_CD = SCRIP2.BSECODE AND SCRIP1.CO_CODE = SCRIP2.CO_CODE AND S.AUCTIONPART NOT LIKE 'A%' AND S.AUCTIONPART NOT LIKE 'F%'"                
IF LEN(ISNULL(@@WHERETEXT,'')) = 0              
BEGIN              
 SET @@WHERETEXT =  " AND 1 = 2"              
END                
              
--PRINT (@@SELECTFLEX + @@WHERETEXT + @@SELECTFLEX1 + @@WHERETEXT + @@MYORDER)                
EXEC (@@SELECTFLEX + @@WHERETEXT + @@SELECTFLEX1 + @@WHERETEXT + @@MYORDER)

GO
