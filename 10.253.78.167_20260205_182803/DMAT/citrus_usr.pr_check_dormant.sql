-- Object: PROCEDURE citrus_usr.pr_check_dormant
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

---pr_check_dormant 4,'DORMANT','IN504316',''
CREATE procedure [citrus_usr].[pr_check_dormant](@pa_id numeric,@pa_action varchar(100), @pa_dtls_id VARCHAR(20),@pa_output varchar(8000) output)
as
begin
print @pa_dtls_id
print convert(datetime,getdate(),103)
declare @pa_request_date datetime,@l_yn char(1)    
set @pa_request_date=convert(datetime,getdate(),103)
if @pa_action = 'DORMANT'
--set @pa_output = citrus_usr.fn_get_high_val('',0,'DORMANT',@pa_dtls_id,convert(datetime,getdate(),103))

declare @l_act_dt datetime     
select distinct @l_act_dt = convert(datetime,left(BOActDt,2)+'/'+substring(BOActDt,3,2) + '/' +RIGHT(BOActDt,4) ,103)     
from dps8_pc1 
where right(boid,8) =right(@pa_dtls_id,8)   



IF EXISTS(SELECT TOP 1 CDSHM_DPAM_ID FROM cdsl_HOLDING_DTLS   with (nolock)
WHERE --right(CDSHM_BEN_ACCT_NO,'8') = right(@PA_ACCT_NO,'8')   
right (CDSHM_BEN_ACCT_NO ,8) =  right (@pa_dtls_id  ,8)
and CDSHM_CDAS_TRAS_TYPE not in ( '21'  ,'22')  
and CDSHM_TRATM_CD = ('2277')   --and cdshm_tras_dt>='DEC  1 2019'    
AND CDSHM_TRAs_DT between DATEADD(M,-6,@PA_REQUEST_DATE) AND @PA_REQUEST_DATE ) 
or datediff(mm,@l_act_dt,getdate()) < 6    
BEGIN    
SET @L_YN =  'N'      
END    
ELSE    
BEGIN    
SET @L_YN =  'Y'      
END  

Set @pa_output=@L_YN
PRINT @pa_output
end

GO
