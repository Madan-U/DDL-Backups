-- Object: PROCEDURE dbo.NSENRIDETAIL
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

--SELECT SETT_NO FROM SETT_MST WHERE START_DATE='2021-06-23 00:00:00.000'  AND SETT_TYPE ='N'    
--NSENRIDETAIL 'MAY 24 2021' ,1    
    
CREATE PROC [dbo].[NSENRIDETAIL] (@SDATE AS VARCHAR(11),@SELL_BUY AS VARCHAR(1))                        
AS     
    
DECLARE @@SETT_NO VARCHAR(8)        
        
SELECT @@SETT_NO = SETT_NO FROM SETT_MST WHERE START_DATE LIKE @SDATE+'%'  AND SETT_TYPE ='N'  
  
select * into #party from (SELECT cl_code FROM Client1 with (nolock) WHERE Cl_type ='NRI') a  
select a.* into #contractdata from CONTRACT_DATA a with (nolock) inner join #party b on a.party_code=b.cl_code where SETT_NO=@@SETT_NO and SELL_BUY =@SELL_BUY    
              
SELECT  'NSECM' AS EXCHANGE,PARTY_CODE,SAUDA_DATE,CONTRACTNO,                  
CASE WHEN SELL_BUY = 1 THEN 'P' ELSE 'S' END TRANSACTION_TYPE,                  
B.ISIN,PQTY+SQTY AS QTY,(PAMT-SAMT)/(PQTY+SQTY) RATE,(ROUND(BROKERAGE,2)) AS BROK_PERSCRIP,(PAMT-SAMT)                   
AS TRANACTIONAMT                   
from #contractdata Cd with (nolock),[AngelDemat].MSAJAG.DBO.MULTIISIN AS B with (nolock)  
 WHERE Cd.SCRIP_CD <>'BROKERAGE'  
--AND PARTY_CODE IN (SELECT cl_code FROM Client1 WHERE Cl_type ='NRI')            
AND Cd.SCRIP_CD=B.SCRIP_CD          
AND Cd.SERIES=B.Series           
AND VALID=1 AND SETT_NO=@@SETT_NO AND SELL_BUY = @SELL_BUY    
--AND VALID=1 AND SETT_NO='2021117' AND SELL_BUY = 1  
and (PQTY+SQTY) !=0

GO
