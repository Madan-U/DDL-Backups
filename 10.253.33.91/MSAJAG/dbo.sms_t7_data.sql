-- Object: PROCEDURE dbo.sms_t7_data
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE proc [dbo].[sms_t7_data]        
(        
 @Process_Date Varchar(11)        
)        
as        
IF LEN(@Process_Date) = 10 AND CHARINDEX('/', @Process_Date) > 0
	BEGIN
		SET @Process_Date = CONVERT(VARCHAR(11), CONVERT(DATETIME, @Process_Date, 103), 109)
	END
SELECT top 5 C.Party_code, MOBILE = '91' + right('9820731985',10),          
MessageTxt = 'Dear Customer (' + Ltrim(Rtrim(C.Party_code)) + '), your position will be liquidated today due to non payment of overdue debit and/or margin call of Rs.' + CONVERT(Varchar,CONVERT(NUMERIC(18,2),Balance)) + '.',
MessageType = 'NORMAL'          
from TBL_RMS_SALE_LEDBAL T, CLIENT_DETAILS C        
where SAUDA_DATE = @process_date     
and t.PARTY_CODE = c.party_code       
and NOOFDAYS = 7        
and Mobile_PAGER <> ''        
and c.party_code in (Select PCODE from V_USERLIST      
         WHERE CATEGORY IN (2, 4))      
order by c.party_code

GO
