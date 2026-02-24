-- Object: PROCEDURE dbo.sms_t5_data_15072013
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

-- sms_t5_data   'apr 10 2013'    
CREATE proc sms_t5_data_15072013                
(                
 @Process_Date Varchar(11)                
)                
as                
                
declare @Tdate Varchar(10)                
             
    
SELECT @TDATE = CONVERT(VARCHAR,MAX(START_DATE),103) FROM (                 
SELECT TOP 3 START_DATE FROM SETT_MST                
WHERE START_DATE >= @PROCESS_DATE    
AND SETT_TYPE = 'N'      
ORDER BY 1 ) A    
    
SELECT * INTO #TBL_RMS_SALE_LEDBAL       
from TBL_RMS_SALE_LEDBAL      
where SAUDA_DATE = @process_date      
      
      
SELECT C.Party_code, MOBILE = '91' + right(MOBILE_PAGER,10),            
MessageTxt = 'Dear Customer (' + Ltrim(Rtrim(C.Party_code)) + '), please pay Rs. ' + CONVERT(Varchar,Convert(Numeric(18,2),Balance))                
     + ' today towards overdue debit and margin call in angel to avoid liquidation on ' + @Tdate                 
     + ', subject to availability of scrips. Please ignore if already paid.',  
MessageType = 'NORMAL'      
from #TBL_RMS_SALE_LEDBAL T, CLIENT_DETAILS C                
where SAUDA_DATE = @process_date               
and t.PARTY_CODE = c.party_code           
and NOOFDAYS = 5                
and Mobile_PAGER <> ''               
and c.party_code in (Select PCODE from V_USERLIST            
         WHERE CATEGORY IN (2, 4))       
and c.party_code NOT IN (SELECT PARTY_CODE from  #TBL_RMS_SALE_LEDBAL      
       where NOOFDAYS > 5)      
order by c.party_code

GO
