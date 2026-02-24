-- Object: PROCEDURE citrus_usr.pr_ins_RESPONSE_DISC
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


    
CREATE proc [citrus_usr].[pr_ins_RESPONSE_DISC]    
   
as
RETURN     
begin    

INSERT INTO DPMRESPONSE_detail   SELECT * FROM TMP_DPMRESPONSE_detail
 
update sliim set SLIIM_SUCCESS_FLAG = Acceptance_Rejection_Flag    
from slip_issue_mstr   sliim , TMP_DPMRESPONSE_detail     
where DIS_Slip_No_from = SLIIM_SERIES_TYPE + convert(varchar(100),SLIIM_SLIP_NO_FR)       
and DIS_Slip_No_to = SLIIM_SERIES_TYPE +convert(varchar(100),SLIIM_SLIP_NO_to)    
    
    
update usedb set USES_SUCCESS_FLAG = Acceptance_Rejection_Flag    
from used_slip_block  usedb , TMP_DPMRESPONSE_detail     
where DIS_Slip_No_from = USES_SERIES_TYPE + convert(varchar(100),USES_SLIP_NO)       
and DIS_Slip_No_to = USES_SERIES_TYPE +convert(varchar(100),USES_SLIP_NO_to)    
end

GO
