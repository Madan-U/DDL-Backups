-- Object: PROCEDURE dbo.sms_t6_data
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC [DBO].[SMS_T6_DATA]
(
 @PROCESS_DATE VARCHAR(11)
)
as
IF LEN(@Process_Date) = 10 AND CHARINDEX('/', @Process_Date) > 0
	BEGIN
		SET @Process_Date = CONVERT(VARCHAR(11), CONVERT(DATETIME, @Process_Date, 103), 109)
	END
declare @Tdate Varchar(10)


SELECT @TDATE = ISNULL(CONVERT(VARCHAR,MAX(START_DATE),103),'') FROM (
SELECT TOP 2 START_DATE FROM SETT_MST
WHERE START_DATE >= @PROCESS_DATE
AND SETT_TYPE = 'N'
ORDER BY 1 ) A


SELECT * INTO #TBL_RMS_SALE_LEDBAL
from TBL_RMS_SALE_LEDBAL
where SAUDA_DATE = @process_date

SELECT top 5  C.Party_code, MOBILE = '91' + right('9820731985',10),
MessageTxt = 'Dear Customer (' + Ltrim(Rtrim(C.Party_code)) + '), please pay Rs. ' + CONVERT(Varchar,convert(numeric(18,2),Balance))
     + ' today towards overdue debit and margin call in angel to avoid liquidation on ' + @Tdate
     + ', subject to availability of scrips. Please ignore if already paid.',
MessageType = 'NORMAL'
from #TBL_RMS_SALE_LEDBAL T, CLIENT_DETAILS C
where SAUDA_DATE = @process_date
and t.PARTY_CODE = c.party_code
and NOOFDAYS = 6
and Mobile_PAGER <> ''
and c.party_code in (Select PCODE from V_USERLIST
         WHERE CATEGORY IN (2, 4))
and c.party_code NOT IN (SELECT PARTY_CODE from  #TBL_RMS_SALE_LEDBAL
       where NOOFDAYS > 6)
order by c.party_code

GO
