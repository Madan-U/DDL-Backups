-- Object: PROCEDURE dbo.ClientWiseDatewise_PldDetails
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc [dbo].[ClientWiseDatewise_PldDetails]          
(@processdate    datetime)
AS          

RETURN 0

declare @prevdate datetime

select @prevdate = convert(varchar(11),max(processdate),120) from [CSOKYC-6].PLEDGE.DBO.Tbl_party_pledged_bankwise_data
where processdate <@processdate 



select /* ROW_NUMBER() OVER(ORDER BY A.processdate ASC) SRNO ,*/A.processdate,party_code,isin,  
qty,pledge_qty,avg_closing,pledge_value,        
A.Bank_code,B.Bankname,ledger_bal,isnull(C.PERCENTAGE,0 )as PERCENTAGE,        
Borrowing=   convert(decimal(18,3), ((pledge_value/2) * isnull(C.PERCENTAGE,0 ))/100) from           
(select processdate,party_code,isin,sum(qty) as qty ,sum(pledge_qty)pledge_qty ,avg_closing,sum(pledge_value)/2 as pledge_value ,Bank_code,ledger_bal
from 
 [CSOKYC-6].PLEDGE.DBO.Tbl_party_pledged_bankwise_data A with(nolock)  
 where processdate > = @prevdate  and processdate <= @prevdate + ' 23:59' --AND PARTY_cODE ='JOD17256'
 group by processdate,party_code,isin,avg_closing,Bank_code,ledger_bal
  ) A         
inner Join [CSOKYC-6].PLEDGE.DBO.Tbl_las_bank_master_Pledge  B  with(nolock) On A.Bank_code = B.Bank_code         
Left Join [CSOKYC-6].PLEDGE.DBO.tbl_PledgeUnpledgeBorrowing C  with(nolock) on B.Bank_Code = C.Bank_Code

GO
