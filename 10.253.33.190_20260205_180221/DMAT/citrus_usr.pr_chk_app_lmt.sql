-- Object: PROCEDURE citrus_usr.pr_chk_app_lmt
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--pr_chk_app_lmt 3,530,'VISHAL','Nov 16 2009',''  
CREATE procedure [citrus_usr].[pr_chk_app_lmt]  
(@pa_id numeric,   
 @pa_dtls_id  numeric ,  
 @pa_loginname varchar (50),  
 @pa_req_dt datetime,  
 @pa_output  varchar(8000) output )  
as   
begin   
declare @l_valuation numeric   
select @l_valuation  = sum(abs(valuation))  
from (  
select dptdc_qty*(select top 1 CLOPM_CDSL_RT from closing_price_mstr_cdsl where CLOPM_ISIN_CD= dptdc_isin and CLOPM_DT < = @pa_req_dt order by CLOPM_DT desc) valuation  
from dptdc_mak   
where dptdc_dtls_id = @pa_dtls_id  
and dptdc_deleted_ind in (0,-1) and isnull(dptdc_res_cd,'')='')  
a  
  
  
if exists(select  llm_login_name  , FROM_LIMIT ,TO_LIMIT   
          from MASTERLIMITS   
             , login_limit_mapping   
          where llm_RANGENAME = RANGENAME   
          and llm_login_name = @pa_loginname   
           and @l_valuation between FROM_LIMIT and to_limit)  
begin   
set @pa_output = 'Y'  
end  
else  
begin   
set @pa_output = 'N'  
end   
  
print @pa_output  
end

GO
