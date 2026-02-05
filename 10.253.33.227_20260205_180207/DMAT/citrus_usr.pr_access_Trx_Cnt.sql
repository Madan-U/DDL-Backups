-- Object: PROCEDURE citrus_usr.pr_access_Trx_Cnt
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

  
--exec pr_access_Trx_Cnt @pa_boid='1203320000022523',@pa_date='dec 13 2016'  
CREATE proc [citrus_usr].[pr_access_Trx_Cnt](@pa_boid varchar(150),@pa_date datetime)    
as    
begin    
    
SELECT DPTDC_EXECUTION_DT,DPTDC_DPAM_ID,COUNT(1)-1 Cnt FROM DPTDC_MAK,DP_ACCT_MSTR WHERE DPAM_ID=DPTDC_DPAM_ID AND DPAM_DELETED_IND=1  
AND DPTDC_EXECUTION_DT  = convert(varchar(11),convert(datetime,@pa_date,103),109) and dpam_sba_no=@pa_boid  
and ISNULL(dptdc_res_cd,'')=''  
GROUP BY DPTDC_EXECUTION_DT,DPTDC_DPAM_ID  
    
end

GO
