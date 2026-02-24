-- Object: PROCEDURE dbo.sms_t7_data_15072013
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

          
          
CREATE proc sms_t7_data_15072013          
(          
 @Process_Date Varchar(11)          
)          
as          
          
SELECT C.Party_code, MOBILE = '91' + right(MOBILE_PAGER,10),            
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
