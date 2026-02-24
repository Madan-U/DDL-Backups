-- Object: PROCEDURE dbo.RPT_MTF_MIS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


  

CREATE PROCEDURE [dbo].[RPT_MTF_MIS]   

  

AS ---- EXEC RPT_MTF_MIS  

  

DECLARE @FM_DATE VARCHAR(11),@LM_DATE VARCHAR(11),@FDAY INT, @LDAY INT  

  

SELECT @FDAY=SETT_NO-20,@LDAY=SETT_NO FROM MSAJAG.DBO.SETT_MST WHERE START_DATE = LEFT(GETDATE(),11) AND SETT_TYPE='N'  

  

SELECT @FM_DATE = START_DATE FROM MSAJAG.DBO.SETT_MST WHERE SETT_TYPE='N' AND SETT_NO=@FDAY  

SELECT @LM_DATE = START_DATE FROM MSAJAG.DBO.SETT_MST WHERE SETT_TYPE='N' AND SETT_NO=@LDAY  

  

  

--ADDED FOR NEW YEAR  

  

SELECT * INTO #SETT_MST_NO FROM MSAJAG.DBO.SETT_MST   

WHERE START_DATE BETWEEN LEFT(GETDATE()-30,11)  AND LEFT(GETDATE(),11) AND SETT_TYPE='N'  

ORDER BY START_DATE DESC  

  

ALTER TABLE #SETT_MST_NO ADD SRNO INT NOT NULL IDENTITY(1, 1)  

  

DECLARE @SRNO INT  

  

SELECT @LM_DATE = START_DATE,@SRNO = SRNO FROM #SETT_MST_NO WHERE SETT_TYPE='N' AND SETT_NO=@LDAY  

SELECT @FM_DATE = START_DATE FROM #SETT_MST_NO WHERE SETT_TYPE='N' AND SRNO =  @SRNO -20  

  

DROP TABLE #SETT_MST_NO  

  

--ADDED FOR NEW YEAR  

  

--SELECT @FM_DATE = LEFT(GETDATE()-DAY(GETDATE())+1,11), @LM_DATE = LEFT(CONVERT(DATETIME,EOMONTH(GETDATE())),11)  

  

SELECT SAUDA_DATE,PARTY_CODE,EXCHANGE,SEGMENT,SCRIPNAME,ISIN,QTY,SELL_BUY,MARKETRATE,MARKETAMT,SCRIP_CATEGORY=CONVERT(VARCHAR(50),'POOR') INTO #BUY  

FROM MSAJAG.dbo.COMMON_CONTRACT_DATA WITH (NOLOCK)  

WHERE SAUDA_DATE BETWEEN @FM_DATE AND @LM_DATE + ' 23:59' AND SEGMENT='CAPITAL' AND TMARK='D' AND SELL_BUY=1  

  

INSERT INTO #BUY  

SELECT SAUDA_DATE,PARTY_CODE,EXCHANGE,SEGMENT,SCRIPNAME,ISIN,QTY,SELL_BUY,MARKETRATE,MARKETAMT,SCRIP_CATEGORY=CONVERT(VARCHAR(50),'POOR')   

FROM MSAJAG.dbo.COMMON_CONTRACT_DATA_HISTORY WITH (NOLOCK)  

WHERE SAUDA_DATE BETWEEN @FM_DATE AND @LM_DATE + ' 23:59' AND SEGMENT='CAPITAL' AND TMARK='D' AND SELL_BUY=1  

  

SELECT ISIN,BSECODE,NSESYMBOL,NSESERIES,SCRIPNAME,[STATUS] INTO #SCRIPCAT  

FROM [csokyc-6].[GENERAL].[DBO].[SCRIP_MASTER]  WITH (NOLOCK)

  

SELECT SAUDA_DATE,TOTAL_DELIVERY_BUY_VALUE=CAST(SUM(MARKETAMT)/10000000 AS NUMERIC(18,2)),  

MTF_TOTAL_BUY_VALUE=CONVERT(MONEY,0),

MTT_OPN_POS_CLIENT=CONVERT(INT,''),

MTF_OUT_OF_TOTAL_DELIVERY_BUY=CONVERT(MONEY,0),  

BLUECHIP_CATEGORY_BOOKED_IN_MTF=CONVERT(MONEY,0),  

GOOD_CATEGORY_BOOKED_IN_MTF=CONVERT(MONEY,0),  

AVERAGE_CATEGORY_BOOKED_IN_MTF=CONVERT(MONEY,0),  

BLUECHIP_IN_TOTAL_MTF_BOOKED=CONVERT(INT,0),  

GOOD_IN_TOTAL_MTF_BOOKED=CONVERT(INT,0),  

AVERAGE_IN_TOTAL_MTF_BOOKED=CONVERT(INT,0) INTO #REPORT  

FROM #BUY GROUP BY SAUDA_DATE  

  

SELECT SAUDA_DATE,PARTY_CODE,SCRIP_CD,FRESHBQTY,FRESHBUY,SCRIP_CATEGORY_MTF=CONVERT(VARCHAR(50),'POOR') INTO #BUYMTF  

FROM MTFTRADE.DBO.TBL_NSE_REPORTING WHERE FRESHBQTY <> 0  

and SAUDA_DATE BETWEEN @FM_DATE AND @LM_DATE + ' 23:59'   

  

UPDATE #BUYMTF SET SCRIP_CATEGORY_MTF = UPPER([STATUS]) FROM #BUYMTF A,#SCRIPCAT B WHERE A.SCRIP_CD = B.NSESYMBOL



UPDATE #REPORT SET MTT_OPN_POS_CLIENT=MTFTRD,MTF_TOTAL_BUY_VALUE = MTFBUYVLAUE FROM #REPORT A,

(SELECT SAUDA_DATE,MTFTRD=COUNT(PARTY_CODE),MTFBUYVLAUE=CAST(SUM(FRESHBUY)/10000000 AS NUMERIC(18,2)) 

FROM #BUYMTF GROUP BY SAUDA_DATE) B

WHERE A.SAUDA_DATE = B.SAUDA_DATE

  

UPDATE #REPORT SET MTF_TOTAL_BUY_VALUE = MTFBUYVLAUE FROM #REPORT A,  

(SELECT SAUDA_DATE,MTFBUYVLAUE=CAST(SUM(FRESHBUY)/10000000 AS NUMERIC(18,2)) FROM #BUYMTF GROUP BY SAUDA_DATE) B  

WHERE A.SAUDA_DATE = B.SAUDA_DATE  

  

UPDATE #REPORT SET MTF_OUT_OF_TOTAL_DELIVERY_BUY = CAST ((MTF_TOTAL_BUY_VALUE / TOTAL_DELIVERY_BUY_VALUE) * 100 AS NUMERIC(18,2))  

  

UPDATE #REPORT SET BLUECHIP_CATEGORY_BOOKED_IN_MTF = BLUECHIP FROM #REPORT A,  

(SELECT SAUDA_DATE,BLUECHIP=CAST(SUM(FRESHBUY)/10000000 AS NUMERIC(18,2)) FROM #BUYMTF   

WHERE SCRIP_CATEGORY_MTF='BLUECHIP' GROUP BY SAUDA_DATE) B WHERE A.SAUDA_DATE = B.SAUDA_DATE  

  

UPDATE #REPORT SET GOOD_CATEGORY_BOOKED_IN_MTF = GOOD FROM #REPORT A,  

(SELECT SAUDA_DATE,GOOD=CAST(SUM(FRESHBUY)/10000000 AS NUMERIC(18,2)) FROM #BUYMTF   

WHERE SCRIP_CATEGORY_MTF='GOOD' GROUP BY SAUDA_DATE) B WHERE A.SAUDA_DATE = B.SAUDA_DATE  

  

UPDATE #REPORT SET AVERAGE_CATEGORY_BOOKED_IN_MTF = AVERAGE FROM #REPORT A,  

(SELECT SAUDA_DATE,AVERAGE=CAST(SUM(FRESHBUY)/10000000 AS NUMERIC(18,2)) FROM #BUYMTF   

WHERE SCRIP_CATEGORY_MTF NOT IN ('BLUECHIP','GOOD') GROUP BY SAUDA_DATE) B WHERE A.SAUDA_DATE = B.SAUDA_DATE  

  

UPDATE #REPORT SET BLUECHIP_IN_TOTAL_MTF_BOOKED = CAST ((BLUECHIP_CATEGORY_BOOKED_IN_MTF / MTF_TOTAL_BUY_VALUE) * 100 AS NUMERIC(18,0))  

UPDATE #REPORT SET GOOD_IN_TOTAL_MTF_BOOKED = CAST ((GOOD_CATEGORY_BOOKED_IN_MTF / MTF_TOTAL_BUY_VALUE) * 100 AS NUMERIC(18,0))  

UPDATE #REPORT SET AVERAGE_IN_TOTAL_MTF_BOOKED = CAST ((AVERAGE_CATEGORY_BOOKED_IN_MTF / MTF_TOTAL_BUY_VALUE) * 100 AS NUMERIC(18,0))  

  

ALTER TABLE #REPORT ADD MTFBOOKVALUE NUMERIC(18,2)



SELECT SAUDA_DATE, SUM(NETAMOUNT)/10000000 AS NETAMOUNT  INTO #MTFBOOKVALUE

FROM MTFTRADE.DBO.TBL_NSE_REPORTING P    

WHERE SAUDA_DATE BETWEEN @FM_DATE AND @LM_DATE + ' 23:59'   AND (BODQTY + FRESHBQTY + FRESHSQTY) > 0   

GROUP BY SAUDA_DATE



UPDATE #REPORT SET MTFBOOKVALUE = NETAMOUNT FROM #MTFBOOKVALUE WHERE #MTFBOOKVALUE.SAUDA_DATE = #REPORT.SAUDA_DATE



TRUNCATE TABLE TBL_MTF_MIS  

  

INSERT INTO TBL_MTF_MIS  

SELECT SAUDA_DATE,  

TOTAL_DEL_BUY=TOTAL_DELIVERY_BUY_VALUE,

TOTAL_MTF_BUY=MTF_TOTAL_BUY_VALUE,  

MTT_OPN_POS_CLIENT,

MTF_DEL_BUY=MTF_OUT_OF_TOTAL_DELIVERY_BUY,  

BLUECHIP_MTF=BLUECHIP_CATEGORY_BOOKED_IN_MTF,  

GOOD_MTF=GOOD_CATEGORY_BOOKED_IN_MTF,  

AVERAGE_MTF=AVERAGE_CATEGORY_BOOKED_IN_MTF,  

BLUECHIP_MTF_BOOKED=CONVERT(VARCHAR,BLUECHIP_IN_TOTAL_MTF_BOOKED) + ' %',  

GOOD_MTF_BOOKED=CONVERT(VARCHAR,GOOD_IN_TOTAL_MTF_BOOKED) + ' %',  

AVERAGE_MTF_BOOKED=CONVERT(VARCHAR,AVERAGE_IN_TOTAL_MTF_BOOKED) + ' %'   ,MTFBOOKVALUE

FROM #REPORT  ORDER BY  SAUDA_DATE ASC



--SELECT * FROM TBL_MTF_MIS

--RETURN



DECLARE @emails VARCHAR(4000),@bodycontent VARCHAR(max),@people varchar(4000),@sname varchar(4000),@SUB varchar(4000),@xml VARCHAR(MAX),@TBLE VARCHAR(MAX)  

  

SET @SUB = 'MTF MIS REPORT : '+ CONVERT(VARCHAR(11),GETDATE(),105)  

  



SET @xml = CAST(( SELECT CONVERT(VARCHAR(12),SAUDA_DATE,107) AS 'td','',  

TOTAL_DEL_BUY AS 'td','',TOTAL_MTF_BUY AS 'td','',MTT_OPN_POS_CLIENT AS 'td','',

MTF_DEL_BUY AS 'td','',BLUECHIP_MTF AS 'td','',GOOD_MTF AS 'td','',  

AVERAGE_MTF AS 'td','',BLUECHIP_MTF_BOOKED AS 'td','',GOOD_MTF_BOOKED AS 'td','',

AVERAGE_MTF_BOOKED AS 'td','',MTFBOOKVALUE AS 'td',''  

FROM MSAJAG.DBO.TBL_MTF_MIS   

ORDER BY SAUDA_DATE FOR XML PATH('tr'), ELEMENTS ) AS VARCHAR(MAX))  

  

SET @TBLE ='<html><head><style>body>table>tbody>tr>td:nth-child(1){text-align: center;}body>table>tbody>tr>td:nth-child(4){text-align: center;}body>table>tbody > tr > td:nth-child(5){text-align:center;}body>table>tbody>tr>td:nth-child(6){text-align:center;}body>table>tbody>tr>td:nth-child(7){text-align: center;}body>table>tbody>tr>td:nth-child(8){text-align:center;}body>table>tbody>tr>td:nth-child(9){text-align:center;}body>table>tbody>tr>td:nth-child(10){text-align: center; } body > table > tbody > tr > td:nth-child(11){     text-align: center; } body > table > tbody > tr > td:nth-child(12){     text-align: right; } body > table > tbody > tr > td:nth-child(13){     text-align: center; } </style> </head> <table border = 1; style="width:100%"> <thead> <tr style="background-color: #4f6e9c;     color: white; font-size: 13px"><th> Sauda Date </th> <th> Total Delivery Buy (Amt in Cr) </th><th> MTF Total Buy Value (Amt in Cr) </th><th> MTF Open Position Clients </th><th> % MTF out of Total Delivery Buy </th> <th> Bluechip Category Booked in MTF (Amt in Cr) </th> <th> Good Category Booked in MTF (Amt in Cr) </th> <th> Average Category Booked in MTF (Amt in Cr) </th> <th> % Bluechip in Total MTF Booked </th> <th> % Good in Total MTF Booked </th> <th>% Average in Total MTF Booked</th> <th>Total MTF Book Value (Amt in Cr) </th> </tr> </thead><tbody STYLE="font-size: 13px;text-align: center;">'      

SET @TBLE = @TBLE + @xml +'</tbody></table></body></html>'  

  

SELECT @bodycontent =  '<p><span style="color: rgb(0, 0, 128); font-family: Verdana; font-size: small; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;">Dear All,</span></p> <p><span style="color: rgb(0, 0, 128); font-family: Verdana; font-size: small; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;">Please find the below MTF MIS Report &nbsp;</span></p>'+@TBLE+''  

  

EXEC MSDB.DBO.SP_SEND_DBMAIL   

@PROFILE_NAME='BO SUPPORT',   

--@RECIPIENTS='avinash.ghodake@angelbroking.com',  

@RECIPIENTS='harigopal.thanvi@angelbroking.com;rahulc.shah@angelbroking.com',  

@blind_copy_recipients='ganesh.jagdale@angelbroking.com;ananthanarayanan.b@angelbroking.com;sanjay.chavan@angelbroking.com',  

@SUBJECT=@SUB,  

@BODY=@BODYCONTENT,  

@IMPORTANCE = 'HIGH',  

@BODY_FORMAT ='HTML'

GO
